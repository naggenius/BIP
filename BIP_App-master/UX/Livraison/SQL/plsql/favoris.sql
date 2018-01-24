-- pack_favoris PL/SQL
--
-- JMA
-- Créé le 03/03/2006
-- 
--****************************************************************************
--
--
CREATE OR REPLACE PACKAGE BIP.pack_favoris AS

   -- Définition curseur sur la table stat_page

   TYPE favoris_ViewType IS RECORD ( 	id_user  		FAVORIS.IDUSER%TYPE,
						  	 			typefav  		FAVORIS.TYPEFAV%TYPE,
										ordre  			FAVORIS.ORDRE%TYPE,
										libelle  		FAVORIS.LIBFAV%TYPE,
										lien  			FAVORIS.LIENFAV%TYPE,
										menu  			FAVORIS.MENU%TYPE
										);


   TYPE favorisCurType_Char IS REF CURSOR RETURN favoris_ViewType;


   PROCEDURE select_liste ( p_userid	IN VARCHAR2,
   			 			  	p_menu      IN VARCHAR2,
   			 			  	p_curstat 	IN OUT favorisCurType_Char ,
                            p_nbcurseur    OUT INTEGER,
                            p_message      OUT VARCHAR2
                          );

   PROCEDURE add_favori ( p_userid  IN VARCHAR2,
		 			  	  p_menu    IN VARCHAR2,
                          p_libelle IN VARCHAR2,
                          p_lien    IN VARCHAR2,
                          p_type    IN VARCHAR2,
                          p_nbcurseur  OUT INTEGER,
                          p_message    OUT VARCHAR2
                        );

   PROCEDURE delete_favori ( p_userid  IN VARCHAR2,
   			 			  	 p_menu    IN VARCHAR2,
                             p_type    IN VARCHAR2,
                             p_ordre   IN INTEGER,
                             p_nbcurseur  OUT INTEGER,
                             p_message    OUT VARCHAR2
                           );

   PROCEDURE update_ordre ( p_userid  IN VARCHAR2,
   			 			  	p_menu    IN VARCHAR2,
                            p_type    IN VARCHAR2,
                            p_ordre   IN INTEGER,
                            p_sens    IN INTEGER,
                            p_nbcurseur  OUT INTEGER,
                            p_message    OUT VARCHAR2
                           );

END pack_favoris;
/


CREATE OR REPLACE PACKAGE BODY BIP.pack_favoris AS


/***********************************************************************************/
/*                                                                                 */
/*               SELECTION LISTE DES FAVORIS POUR UN UTILISATEUR                   */
/*                                                                                 */
/***********************************************************************************/
PROCEDURE select_liste ( p_userid	 IN VARCHAR2,
		 			  	 p_menu      IN VARCHAR2,
		  			   	 p_curstat 	 IN OUT favorisCurType_Char ,
                         p_nbcurseur    OUT INTEGER,
                         p_message      OUT VARCHAR2
                       ) IS
	l_msg VARCHAR2(1024);
    l_idarpege	    FAVORIS.IDUSER%TYPE;
	l_codsg NUMBER;
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	p_nbcurseur := 1;
   	p_message := '';

	l_idarpege := PACK_GLOBAL.lire_globaldata(p_userid).idarpege;

   	OPEN   p_curstat FOR
       	SELECT iduser, typefav, ordre, libfav, lienfav, menu
          FROM FAVORIS
		 WHERE IDUSER = l_idarpege
--		   AND MENU = p_menu
	    ORDER BY typefav, menu, ordre;

EXCEPTION
	WHEN OTHERS THEN
   		raise_application_error( -20997, SQLERRM);

END select_liste;



/***********************************************************************************/
/*                                                                                 */
/*                    AJOUT D'UN FAVORI A UN UTILISATEUR                           */
/*                                                                                 */
/***********************************************************************************/
PROCEDURE add_favori ( p_userid  IN VARCHAR2,
		  			   p_menu    IN VARCHAR2,
                       p_libelle IN VARCHAR2,
                       p_lien    IN VARCHAR2,
                       p_type    IN VARCHAR2,
                       p_nbcurseur  OUT INTEGER,
                       p_message    OUT VARCHAR2
                              ) IS 
    l_idarpege	    FAVORIS.IDUSER%TYPE;
    l_next_ordre		FAVORIS.ORDRE%TYPE;
BEGIN
    -- Initialiser le message retour
    p_message   := '';
	p_nbcurseur := 1;

	l_idarpege := PACK_GLOBAL.lire_globaldata(p_userid).idarpege;

	select nvl(max(ordre),0) + 2
	  into l_next_ordre
	  from FAVORIS 
	 where IDUSER = l_idarpege
	   and MENU = p_menu 
	   and TYPEFAV = p_type;
	   
	insert into FAVORIS (IDUSER, MENU, TYPEFAV, ORDRE, LIBFAV, LIENFAV) 
	values (l_idarpege, p_menu, p_type, l_next_ordre, p_libelle, p_lien);
      
    pack_global.recuperer_message( 20366 , '%s1', 'La page a été ajoutée aux favoris.', '', p_message);
     
END add_favori;


/***********************************************************************************/
/*                                                                                 */
/*                    SUPPRESSION D'UN FAVORI D'UN UTILISATEUR                     */
/*                                                                                 */
/***********************************************************************************/
PROCEDURE delete_favori ( p_userid  IN VARCHAR2,
                          p_menu    IN VARCHAR2,
                          p_type    IN VARCHAR2,
                          p_ordre   IN INTEGER,
                          p_nbcurseur  OUT INTEGER,
                          p_message    OUT VARCHAR2
                        ) IS 
    l_idarpege	    FAVORIS.IDUSER%TYPE;
BEGIN
    -- Initialiser le message retour
    p_message   := '';
	p_nbcurseur := 1;

	l_idarpege := PACK_GLOBAL.lire_globaldata(p_userid).idarpege;

	
	delete FAVORIS
	 where IDUSER = l_idarpege and MENU = p_menu and TYPEFAV = p_type and ORDRE = p_ordre;


	-- si le favori supprimé n'était pas le dernier de la liste on décrémente l'ordre des favoris suivants	 
    update FAVORIS
	   set ORDRE = ORDRE - 2
     where IDUSER = l_idarpege and MENU = p_menu and TYPEFAV = p_type and ORDRE > p_ordre;
	
    --pack_global.recuperer_message( 20366 , '%s1', 'La page a été ajoutée aux favoris.', '', p_message);
     
END delete_favori;





/***********************************************************************************/
/*                                                                                 */
/*                    MODIFICATION DE L'ORDRE D'UN FAVORI                          */
/*                                                                                 */
/***********************************************************************************/
PROCEDURE update_ordre ( p_userid  IN VARCHAR2,
                         p_menu    IN VARCHAR2,
                         p_type    IN VARCHAR2,
                         p_ordre   IN INTEGER,
                         p_sens    IN INTEGER,
                         p_nbcurseur  OUT INTEGER,
                         p_message    OUT VARCHAR2
                       ) IS 
    l_idarpege	    FAVORIS.IDUSER%TYPE;
	l_first_ordre   INTEGER;
	l_second_ordre  INTEGER;
BEGIN
    -- Initialiser le message retour
    p_message   := '';
	p_nbcurseur := 1;

	l_idarpege := PACK_GLOBAL.lire_globaldata(p_userid).idarpege;

	
	if (p_sens>0) then
	    l_first_ordre  := p_ordre;
	    l_second_ordre := p_ordre+2;
	else
	    l_first_ordre  := p_ordre-2;
	    l_second_ordre := p_ordre;
	end if;
	
    update FAVORIS
	   set ORDRE = ORDRE - 3
     where IDUSER = l_idarpege and MENU = p_menu and TYPEFAV = p_type and ORDRE = l_second_ordre;
	
    update FAVORIS
	   set ORDRE = ORDRE + 2
     where IDUSER = l_idarpege and MENU = p_menu and TYPEFAV = p_type and ORDRE = l_first_ordre;

    update FAVORIS
	   set ORDRE = ORDRE + 1
     where IDUSER = l_idarpege and MENU = p_menu and TYPEFAV = p_type and ORDRE = l_second_ordre - 3;

    --pack_global.recuperer_message( 20366 , '%s1', 'La page a été ajoutée aux favoris.', '', p_message);
     
END update_ordre;


END pack_favoris;
/


