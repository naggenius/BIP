-- pack_struct_info PL/SQL
--
-- Equipe SOPRA
-- Créé le 06/12/1999
-- 
-- Modifié 
-- le 06/12/1999	* Procédures update_struct_info & delete_struct_info 
--		 	 . Prise en compte de la gestion des accès concurrents
-- le 08/01/2001  NBM	ajout de scentrefrais dans struct_info
-- le 05/04/2001  NBM   ajout de filcode dans struct_info
-- le 12/07/2001  PHD   Correction bug de la fiche 251  sur la création de nouveaux code DPG
-- 				et de leur rattachement automatique à un centre de frais
-- le 14/10/2002  NBM   ajout de gnom : nom du responsable dans struct_info
-- le 10/09/2003  NBM : bug création nouveau DPG au niveau des centres de frais=>création fonction getCentrefrais
--				fiche 41
-- le 28/04/2004 KHA   : Bug fiche 334 Mise à jour systematique centre frais à zero.
-- le 26/05/2004 MMC   : fiche 189 Ajout controle sur le CAFI
-- le 25/10/2006 PPR   : Ajout Top DIVA
-- le 23/07/2007  JAL   : ajout matricule pour la saisie/modif : fiche 524
-- le 11/10/2007  EVI   : ajout top_diva_int pour la saisie/modif : fiche 591
-- le 08/12/2008  ABA   : TD 715 logs dpg
-- le 20/05/2011  BSA   : QC 879
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE     pack_struct_info AS

   -- Définition curseur sur la table struct_info

   TYPE Struct_info_ViewType IS RECORD ( codsg      	VARCHAR2(20),
					 	sigdep     	STRUCT_INFO.sigdep%TYPE,
                        sigpole    	STRUCT_INFO.sigpole%TYPE,
                        libdsg     	STRUCT_INFO.libdsg%TYPE,
						gnom 		STRUCT_INFO.gnom%TYPE,
                        centractiv 	VARCHAR2(20),
                        topfer     	STRUCT_INFO.topfer%TYPE,
					 	flaglock   	STRUCT_INFO.flaglock%TYPE,
					 	coddir     	VARCHAR2(20),
					 	cafi 	    	VARCHAR2(20),
					 	scentrefrais 	VARCHAR2(3),
					 	filcode    	VARCHAR2(3),
					 	top_diva	CHAR(1),
					 	identgdm 	VARCHAR2(5),
					 	matricule 	VARCHAR2(7),
						top_diva_int	CHAR(1)
						);

   TYPE struct_infoCurType_Char IS REF CURSOR RETURN Struct_info_ViewType;

  FUNCTION getCentrefrais (p_codsg      	IN  VARCHAR2,
				  	p_coddir     	IN  VARCHAR2
				) RETURN VARCHAR2;


  PROCEDURE isDpgAppartientCdFrais ( p_codsg   IN  VARCHAR2,
                                     p_userid  IN  VARCHAR2,
                                     p_message    OUT VARCHAR2 ) ;
                                    

  PROCEDURE testDpg ( p_codsg   IN  VARCHAR2,
                          p_message    OUT VARCHAR2 ) ;
                                    
  
   PROCEDURE insert_struct_info ( 	p_codsg      	IN  VARCHAR2,
				  					p_coddir     	IN  VARCHAR2,
                                  	p_sigdep     	IN  STRUCT_INFO.sigdep%TYPE,
                                  	p_sigpole    	IN  STRUCT_INFO.sigpole%TYPE,
                                  	p_libdsg     	IN  STRUCT_INFO.libdsg%TYPE,
									p_gnom 		IN  STRUCT_INFO.gnom%TYPE,
                                  	p_centractiv 	IN  VARCHAR2,
				  					p_cafi       	IN  VARCHAR2,
				 	 				p_filcode    	IN  VARCHAR2,
				  					p_centrefrais 	IN  VARCHAR2,
                                  	p_topfer     	IN  STRUCT_INFO.topfer%TYPE,
                                  	p_userid     	IN  VARCHAR2,
                                  	p_top_diva		IN  CHAR,
                                  	p_identgdm  	IN  VARCHAR2,
                                  	p_matricule  	IN  VARCHAR2,
									p_top_diva_int	IN	CHAR,
                                  	p_nbcurseur  	OUT INTEGER,
                                  	p_message    	OUT VARCHAR2
                                );

   PROCEDURE update_struct_info ( 	p_codsg      	IN  VARCHAR2,
				  					p_coddir     	IN  VARCHAR2,
                                  	p_sigdep     	IN  STRUCT_INFO.sigdep%TYPE,
                                  	p_sigpole    	IN  STRUCT_INFO.sigpole%TYPE,
                                  	p_libdsg     	IN  STRUCT_INFO.libdsg%TYPE,
									p_gnom 		IN  STRUCT_INFO.gnom%TYPE,
                                  	p_centractiv 	IN  VARCHAR2,
								  	p_cafi       	IN  VARCHAR2,
								  	p_filcode    	IN  VARCHAR2,
								  	p_centrefrais 	IN  VARCHAR2,
				                    p_topfer     	IN  STRUCT_INFO.topfer%TYPE,
                                  	p_flaglock   	IN  NUMBER,
				  					p_userid     	IN  VARCHAR2,
				  			     	p_top_diva		IN  CHAR,
                                  	p_identgdm  	IN  VARCHAR2,
                                  	p_matricule  	IN  VARCHAR2,
									p_top_diva_int	IN	CHAR,
				  					p_nbcurseur  	OUT INTEGER,
                                  	p_message    	OUT VARCHAR2
                              );

   PROCEDURE delete_struct_info ( p_codsg     IN  VARCHAR2,
                                  p_flaglock  IN  NUMBER,
                                  p_userid    IN  VARCHAR2,
                                  p_nbcurseur OUT INTEGER,
                                  p_message   OUT VARCHAR2
                              );

   PROCEDURE select_struct_info ( p_codsg	   IN VARCHAR2,
                                  p_userid         IN VARCHAR2,
                                  p_curStruct_info IN OUT struct_infoCurType_Char ,
                                  p_nbcurseur         OUT INTEGER,
                                  p_message           OUT VARCHAR2
                                );

    PROCEDURE maj_struct_info_logs (p_codsg       IN STRUCT_INFO.codsg%TYPE,
                              p_user_log    IN VARCHAR2,
                              p_colonne        IN VARCHAR2,
                              p_valeur_prec    IN VARCHAR2,
                              p_valeur_nouv    IN VARCHAR2,
                              p_commentaire    IN VARCHAR2
                              );
END pack_struct_info;
/


CREATE OR REPLACE PACKAGE BODY     pack_struct_info AS
-- Correction bug de la fiche 251 sur la création de nouveaux code DPG
-- et de leur rattachement automatique à un centre de frais
FUNCTION getCentrefrais (p_codsg      	IN  VARCHAR2,
				  p_coddir     	IN  VARCHAR2
				) RETURN VARCHAR2  IS

 l_codbr VARCHAR2(2);
 l_codbddpg VARCHAR2(11);
 l_centrefrais VARCHAR2(3);
 l_msg VARCHAR2(1024);


BEGIN

      -- récupération du code branche
	BEGIN
        SELECT LPAD(codbr,2,'0') INTO l_codbr
        FROM DIRECTIONS
        WHERE coddir = p_coddir;

	  EXCEPTION
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;


      -- récupération du code centre de frais
	BEGIN

        SELECT codcfrais INTO l_centrefrais
        FROM COMPO_CENTRE_FRAIS ccf
        WHERE SUBSTR(ccf.codbddpg,1,2) = l_codbr
	  AND ((SUBSTR(ccf.codbddpg,3,2) = LPAD(p_coddir,2,'0')) OR (SUBSTR(ccf.codbddpg,3,9) = '000000000'))
	  AND ((SUBSTR(ccf.codbddpg,5,3) = SUBSTR(LPAD( p_codsg, 7, '0'),1,3)) OR (SUBSTR(ccf.codbddpg,5,7) = '0000000'))
	  AND ((SUBSTR(ccf.codbddpg,8,2) = SUBSTR(LPAD( p_codsg, 7, '0'),4,2)) OR (SUBSTR(ccf.codbddpg,8,4) = '0000'))
	  AND ((SUBSTR(ccf.codbddpg,10,2) = SUBSTR(LPAD( p_codsg, 7, '0'),6,2)) OR (SUBSTR(ccf.codbddpg,10,2) = '00'));

	  EXCEPTION
        WHEN NO_DATA_FOUND THEN
		 l_centrefrais:='';


     	  WHEN DUP_VAL_ON_INDEX THEN
	    pack_global.recuperer_message( 20751, NULL, NULL, NULL, l_msg);
          RAISE_APPLICATION_ERROR( -20751, l_msg );

        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
	RETURN  l_centrefrais;

END getCentrefrais;


PROCEDURE isDpgAppartientCdFrais ( p_codsg   IN  VARCHAR2,
                                   p_userid  IN  VARCHAR2,
                                   p_message    OUT VARCHAR2 ) IS


    l_centre_frais NUMBER(3);
    l_scentrefrais NUMBER(3);

     l_msg VARCHAR2(1024);
     l_msg_alert VARCHAR2(1024);
     l_codcamo CENTRE_ACTIVITE.codcamo%TYPE;
     l_exist NUMBER;
     l_codbr VARCHAR2(2);
     l_codbddpg VARCHAR2(11);
     l_centrefrais VARCHAR2(3);


BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour

    p_message := '';

    -- On recupere le code centre de frais de l'utilisateur
    l_centre_frais:= Pack_Global.lire_globaldata(p_userid).codcfrais;


      BEGIN
         SELECT scentrefrais
         INTO   l_scentrefrais
         FROM   STRUCT_INFO
         WHERE  codsg = TO_NUMBER(p_codsg);

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

    -- ===================================================================
    -- 19/12/2000 : Test si le DPG appartient bien au centre de frais
    -- ===================================================================
    IF l_centre_frais!=0 THEN    -- le centre de frais 0 donne tout les droits à l'utilisateur
        IF (l_scentrefrais IS NULL)   THEN
            --msg : Le DPG n'est rattaché à aucun centre de frais
            Pack_Global.recuperer_message(20339, NULL,NULL,'', l_msg);
            p_message := l_msg ;
            
        ELSE
            IF (l_scentrefrais!=l_centre_frais) THEN
                --msg:Ce DPG n'appartient pas à ce centre de frais
                Pack_Global.recuperer_message(20334, '%s1',TO_CHAR(l_centre_frais),'', l_msg);
                p_message := l_msg ;
                
            END IF;
        END IF;
        
    ELSE    -- l'utilisateur n'est pas affecté à un centre de frais réel: récupérer le centre de frais du DPG
        IF (l_scentrefrais IS NULL) THEN
            --msg : Le DPG n'est rattaché à aucun centre de frais
            Pack_Global.recuperer_message(20339, NULL,NULL,'', l_msg);
            p_message := l_msg ;
            
        END IF;
        
    END IF;

END isDpgAppartientCdFrais;
   


PROCEDURE testDpg ( p_codsg   IN  VARCHAR2,
                        p_message    OUT VARCHAR2 ) IS


    l_topfer  STRUCT_INFO.topfer%TYPE;   
    l_msg VARCHAR2(1024);


BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour

    p_message := '';

    BEGIN
       SELECT topfer
       INTO   l_topfer
       FROM   STRUCT_INFO
       WHERE  codsg = TO_NUMBER(p_codsg);

    EXCEPTION

        WHEN NO_DATA_FOUND THEN
            -- Code Département/Pôle/Groupe inexistant 
            Pack_Global.recuperer_message(20203, NULL, NULL, '', l_msg);
            p_message := l_msg;
        WHEN INVALID_NUMBER THEN
            -- Le DPG saisi ne doit pas contenir de caractère
            Pack_Global.recuperer_message(20386, NULL, NULL, '', l_msg);
            p_message := l_msg;

        WHEN OTHERS THEN
            Pack_Global.recuperer_message(20203, NULL, NULL, '', l_msg);
            p_message := l_msg;
            --RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

    IF l_topfer = 'F' THEN
        -- Code Département/Pôle/Groupe fermé 
        Pack_Global.recuperer_message(20274, NULL, NULL, '', l_msg);
        p_message := l_msg;
        --RAISE_APPLICATION_ERROR(-20274, l_msg);
    END IF;

END testDpg;


  PROCEDURE insert_struct_info ( 	p_codsg		IN VARCHAR2,
								  	p_coddir    	IN VARCHAR2,
                                  	p_sigdep	IN STRUCT_INFO.sigdep%TYPE,
                                  	p_sigpole	IN STRUCT_INFO.sigpole%TYPE,
                                  	p_libdsg	IN STRUCT_INFO.libdsg%TYPE,
									p_gnom 		IN STRUCT_INFO.gnom%TYPE,
                                  	p_centractiv	IN VARCHAR2,
								  	p_cafi		IN VARCHAR2,
								  	p_filcode   	IN  VARCHAR2,
								 	p_centrefrais 	IN  VARCHAR2,
                                  	p_topfer	IN STRUCT_INFO.topfer%TYPE,
                                  	p_userid	IN VARCHAR2,
                                  	p_top_diva		IN  CHAR,
                                  	p_identgdm  	IN  VARCHAR2,
                                  	p_matricule  	IN  VARCHAR2,
									p_top_diva_int	IN	CHAR,
                                  	p_nbcurseur	OUT INTEGER,
                                  	p_message	OUT VARCHAR2
                              ) IS

     l_msg VARCHAR2(1024);
     l_msg_alert VARCHAR2(1024);
     l_codcamo CENTRE_ACTIVITE.codcamo%TYPE;
     l_exist NUMBER;
     l_codbr VARCHAR2(2);
     l_codbddpg VARCHAR2(11);
     l_centrefrais VARCHAR2(3);
     l_ctopact CENTRE_ACTIVITE.ctopact%TYPE;
     l_identgdm RESSOURCE.ident%TYPE;
     l_user VARCHAR2(7);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      -- test si le centre d'activité existe

      BEGIN
        SELECT codcamo INTO l_codcamo
        FROM CENTRE_ACTIVITE
        WHERE TO_NUMBER(p_centractiv)= codcamo;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
 	    pack_global.recuperer_message( 20754, NULL, NULL, NULL, l_msg);
          RAISE_APPLICATION_ERROR( -20754, l_msg );

        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

      -- test si le CA pour la FI existe

      BEGIN
        SELECT codcamo INTO l_codcamo
        FROM CENTRE_ACTIVITE
        WHERE TO_NUMBER(p_cafi)= codcamo;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
 	    pack_global.recuperer_message( 20755, NULL, NULL, NULL, l_msg);
          RAISE_APPLICATION_ERROR( -20755, l_msg );

        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

      -- ce CA pour la FI doit avoir le top amortissement a C
      BEGIN
        SELECT ctopact INTO l_ctopact
        FROM CENTRE_ACTIVITE
        WHERE TO_NUMBER(p_cafi)= codcamo
        AND ctopact='C';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        	-- 'Le centre d'activité pour la FI n'est pas topé à CAFI.'
 	    pack_global.recuperer_message( 20983, NULL, NULL, NULL, l_msg);
          RAISE_APPLICATION_ERROR( -20983, l_msg );

        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

	l_centrefrais := getCentrefrais (p_codsg, p_coddir) ;

    -- test existance GDM
    IF (p_identgdm IS NOT NULL AND LENGTH(p_identgdm)>0) THEN
      BEGIN
        SELECT r.ident INTO l_identgdm
        FROM RESSOURCE r
        WHERE TO_NUMBER(p_identgdm)= r.ident
		  AND EXISTS (SELECT 1 FROM SITU_RESS s WHERE s.ident=r.ident AND s.soccode='SG..' AND (DATDEP IS NULL OR datdep>=SYSDATE) GROUP BY s.ident )
          AND R.RTYPE='P';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
 	    pack_global.recuperer_message( 20131, NULL, NULL, NULL, l_msg);
          RAISE_APPLICATION_ERROR( -20131, l_msg );
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
    ELSE
      l_identgdm := NULL;
    END IF;

	BEGIN
     	   INSERT INTO STRUCT_INFO
	    ( codsg,
 		sigdep,
 		sigpole,
 		libdsg,
		gnom,
 		centractiv,
 		topfer,
 		coddep,
 		codpole,
		codgro,
 		coddeppole,
		coddir,
		cafi,
		scentrefrais ,
		filcode,
		flaglock,
		top_diva,
		ident_gdm,
		matricule,
		top_diva_int)
         VALUES ( TO_NUMBER(p_codsg),
		   p_sigdep,
		   p_sigpole,
		   p_libdsg,
		   p_gnom,
		   TO_NUMBER(p_centractiv),
		   p_topfer,
		   SUBSTR( LPAD( p_codsg, 7, '0' ), 1, 3) ,
		   SUBSTR( LPAD( p_codsg, 7, '0' ), 4, 2) ,
		   SUBSTR( LPAD( p_codsg, 7, '0' ), 6, 2) ,
		   SUBSTR( LPAD( p_codsg, 7, '0' ), 1, 5) ,
		   TO_NUMBER(p_coddir),
		   TO_NUMBER(p_cafi),
		   TO_NUMBER(l_centrefrais),
		   p_filcode,
		   0,
		   p_top_diva,
		   l_identgdm,
		   p_matricule,
		   p_top_diva_int
		);

	   -- 'Pôle p_sigpole créé'

        l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
        maj_struct_info_logs(p_codsg, l_user, 'CODSG','',p_codsg,'Creation code DPG');
        maj_struct_info_logs(p_codsg, l_user, 'CENTRACTIV','',p_centractiv,'Creation centre activite');
        maj_struct_info_logs(p_codsg, l_user, 'TOPFER','',p_topfer,'Creation top fermeture');
        maj_struct_info_logs(p_codsg, l_user, 'CODDIR','',p_coddir,'Creation code direction');
        maj_struct_info_logs(p_codsg, l_user, 'CAFI','',p_cafi,'Creation centre activite FI');
        maj_struct_info_logs(p_codsg, l_user, 'SCENTREFRAIS','',l_centrefrais,'Creation centre de frais');
        maj_struct_info_logs(p_codsg, l_user, 'FILCODE','',p_filcode,'Creation code de la filiale');
        maj_struct_info_logs(p_codsg, l_user, 'TOP_DIVA','',p_top_diva,'Creation top diva');
        maj_struct_info_logs(p_codsg, l_user, 'TOP_DIVA_INT','',p_top_diva_int,'Creation top diva intervenants');


         pack_global.recuperer_message( 1001, '%s1', p_codsg, NULL, l_msg);
	IF (l_centrefrais!='' OR l_centrefrais IS NOT NULL) THEN
		 p_message := l_msg;
	ELSE
	  	 p_message := l_msg||'\nATTENTION : Ce code DPG n''appartient à aucun centre de frais. \nPour rattacher ce DPG à un centre de frais, il faut mettre à jour le centre de frais.';
	END IF;

     EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
		   pack_global.recuperer_message( 20001, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20001, l_msg );

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
     END;

   END insert_struct_info;



   PROCEDURE update_struct_info ( 	p_codsg      	IN  VARCHAR2,
								  	p_coddir     	IN  VARCHAR2,
                                  	p_sigdep     	IN  STRUCT_INFO.sigdep%TYPE,
                                  	p_sigpole    	IN  STRUCT_INFO.sigpole%TYPE,
                                  	p_libdsg     	IN  STRUCT_INFO.libdsg%TYPE,
									p_gnom 		IN  STRUCT_INFO.gnom%TYPE,
                                  	p_centractiv 	IN  VARCHAR2,
								  	p_cafi       	IN  VARCHAR2,
								  	p_filcode    	IN  VARCHAR2,
								  	p_centrefrais 	IN  VARCHAR2,
                                  	p_topfer     	IN  STRUCT_INFO.topfer%TYPE,
                                  	p_flaglock   	IN  NUMBER,
								  	p_userid     	IN  VARCHAR2,
                                  	p_top_diva		IN  CHAR,
								  	p_identgdm  	IN  VARCHAR2,
								  	p_matricule  	IN  VARCHAR2,
									p_top_diva_int	IN	CHAR,
                                  	p_nbcurseur  	OUT INTEGER,
                                  	p_message    	OUT VARCHAR2
                              ) IS

	l_msg VARCHAR2(1024);
	l_codcamo CENTRE_ACTIVITE.codcamo%TYPE;
     l_centrefrais VARCHAR2(3);
     l_ctopact CENTRE_ACTIVITE.ctopact%TYPE;
     l_identgdm RESSOURCE.ident%TYPE;
    old_centractiv 	VARCHAR2(50);
	old_topfer 		VARCHAR2(50);
	old_coddir  	VARCHAR2(50);
 	old_cafi		VARCHAR2(50);
	old_filcode		VARCHAR2(50);
	old_scentrefrais VARCHAR2(50);
	old_top_diva	VARCHAR2(50);
	old_top_diva_int VARCHAR2(50);
     l_user VARCHAR2(7);


   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- initialiser le message retour

	p_nbcurseur := 0;
	p_message := '';

      -- test si le centre d'activité existe

      BEGIN
        SELECT codcamo INTO l_codcamo
        FROM CENTRE_ACTIVITE
        WHERE TO_NUMBER(p_centractiv)= codcamo;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
 	    pack_global.recuperer_message( 20754, NULL, NULL, NULL, l_msg);
          RAISE_APPLICATION_ERROR( -20754, l_msg );

        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

	-- test si le CA FI existe
	BEGIN
        SELECT codcamo INTO l_codcamo
        FROM CENTRE_ACTIVITE
        WHERE TO_NUMBER(p_cafi)= codcamo;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
 	    pack_global.recuperer_message( 20755, NULL, NULL, NULL, l_msg);
          RAISE_APPLICATION_ERROR( -20755, l_msg );

        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

      -- le CA pour la FI doit avoir le top amortissement a C
      BEGIN
        SELECT ctopact INTO l_ctopact
        FROM CENTRE_ACTIVITE
        WHERE TO_NUMBER(p_cafi)= codcamo
        AND ctopact='C';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        	-- 'Le centre d'activité pour la FI n'est pas topé à CAFI.'
 	    pack_global.recuperer_message( 20983, NULL, NULL, NULL, l_msg);
          RAISE_APPLICATION_ERROR( -20983, l_msg );

        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

    -- test existance GDM
    IF (p_identgdm IS NOT NULL AND LENGTH(p_identgdm)>0) THEN
      BEGIN
        SELECT r.ident INTO l_identgdm
          FROM RESSOURCE r
         WHERE TO_NUMBER(p_identgdm)= ident
		   AND EXISTS (SELECT 1 FROM SITU_RESS s WHERE s.ident=r.ident AND s.soccode='SG..' AND (DATDEP IS NULL OR datdep>=SYSDATE) GROUP BY s.ident )
           AND R.RTYPE='P';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
 	        pack_global.recuperer_message( 20131, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20131, l_msg );
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
    ELSE
      l_identgdm := NULL;
    END IF;

	BEGIN
	   l_centrefrais := getCentrefrais (p_codsg, p_coddir) ;

      -- on recupère les anciennes valeurs pour la table de log avant la mise à jour de la table struct_info
      select CENTRACTIV, TOPFER, CODDIR, CAFI, SCENTREFRAIS, FILCODE, TOP_DIVA, TOP_DIVA_INT
      into old_CENTRACTIV, old_TOPFER, old_CODDIR, old_CAFI, old_SCENTREFRAIS, old_FILCODE, old_TOP_DIVA, old_TOP_DIVA_INT
      from struct_info
      where codsg = to_number(p_codsg);


         UPDATE STRUCT_INFO
		SET	sigdep 		= p_sigdep,
		    sigpole 	= p_sigpole,
			libdsg 		= p_libdsg,
			gnom 		= p_gnom,
			centractiv 	= p_centractiv,
			topfer 		= p_topfer,
			coddep 		= SUBSTR( LPAD( p_codsg, 7, '0' ), 1, 3) ,
			codpole 	= SUBSTR( LPAD( p_codsg, 7, '0' ), 4, 2) ,
			codgro 		= SUBSTR( LPAD( p_codsg, 7, '0' ), 6, 2) ,
			coddeppole 	= SUBSTR( LPAD( p_codsg, 7, '0' ), 1, 5) ,
			flaglock 	= DECODE( p_flaglock, 1000000, 0, p_flaglock + 1 ) ,
			coddir  	= TO_NUMBER(p_coddir),
 			cafi		= TO_NUMBER(p_cafi),
			filcode		= p_filcode,
		    scentrefrais = TO_NUMBER(l_centrefrais),
		    top_diva	= p_top_diva,
			ident_gdm	= l_identgdm,
			matricule   = p_matricule,
			top_diva_int=p_top_diva_int
		WHERE codsg 	= TO_NUMBER(p_codsg)
              AND flaglock 	= p_flaglock;

        l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
        maj_struct_info_logs(p_codsg, l_user, 'CENTRACTIV',old_centractiv,p_centractiv,'Modification centre activite');
        maj_struct_info_logs(p_codsg, l_user, 'TOPFER',old_topfer,p_topfer,'Modification top fermeture');
        maj_struct_info_logs(p_codsg, l_user, 'CODDIR',old_coddir,p_coddir,'Modification code direction');
        maj_struct_info_logs(p_codsg, l_user, 'CAFI',old_cafi,p_cafi,'Modification centre activite FI');
        maj_struct_info_logs(p_codsg, l_user, 'SCENTREFRAIS',old_scentrefrais,l_centrefrais,'Modification centre de frais');
        maj_struct_info_logs(p_codsg, l_user, 'FILCODE',old_filcode,p_filcode,'Modification code de la filiale');
        maj_struct_info_logs(p_codsg, l_user, 'TOP_DIVA',old_top_diva,p_top_diva,'Modification top diva');
        maj_struct_info_logs(p_codsg, l_user, 'TOP_DIVA_INT',old_top_diva_int,p_top_diva_int,'Modification top diva intervenants');

	   EXCEPTION

		WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR( -20754, l_msg );

	--	   raise_application_error( -20997, SQLERRM);
	END;


      IF SQL%NOTFOUND THEN

	   -- 'Accès concurrent'

	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );

      ELSE



	   -- 'Le pôle p_codsg a été modifié'

	   pack_global.recuperer_message( 1002, '%s1', p_codsg, NULL, l_msg);
	IF (l_centrefrais!='' OR l_centrefrais IS NOT NULL) THEN
		 p_message := l_msg;
	ELSE
	  	 p_message := l_msg||'\nATTENTION : Ce code DPG n''appartient à aucun centre de frais. \nPour rattacher ce DPG à un centre de frais, il faut mettre à jour le centre de frais.';
	END IF;



      END IF;

   END update_struct_info;


   PROCEDURE delete_struct_info ( p_codsg     IN  VARCHAR2,
                                  p_flaglock  IN  NUMBER,
                                  p_userid    IN  VARCHAR2,
                                  p_nbcurseur OUT INTEGER,
                                  p_message   OUT VARCHAR2
                              ) IS


	l_msg VARCHAR2(1024);
    referential_integrity EXCEPTION;
    PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
    old_centractiv 	VARCHAR2(50);
	old_topfer 		VARCHAR2(50);
	old_coddir  	VARCHAR2(50);
 	old_cafi		VARCHAR2(50);
	old_filcode		VARCHAR2(50);
	old_scentrefrais VARCHAR2(50);
	old_top_diva	VARCHAR2(50);
	old_top_diva_int VARCHAR2(50);
     l_user VARCHAR2(7);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN

      -- on recupère les anciennes valeurs pour la table de log avant la suppresion de l'element dans la table struct_info
      select CENTRACTIV, TOPFER, CODDIR, CAFI, SCENTREFRAIS, FILCODE, TOP_DIVA, TOP_DIVA_INT
      into old_CENTRACTIV, old_TOPFER, old_CODDIR, old_CAFI, old_SCENTREFRAIS, old_FILCODE, old_TOP_DIVA, old_TOP_DIVA_INT
      from struct_info
      where codsg = to_number(p_codsg);


	   DELETE FROM STRUCT_INFO
		    WHERE codsg = TO_NUMBER(p_codsg)
			AND flaglock = p_flaglock;


         l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
        maj_struct_info_logs(p_codsg, l_user, 'CODSG',p_codsg,'','Suppression code DPG');
        maj_struct_info_logs(p_codsg, l_user, 'CENTRACTIV',old_centractiv,'','Suppression centre activite');
        maj_struct_info_logs(p_codsg, l_user, 'TOPFER',old_topfer,'','Suppression top fermeture');
        maj_struct_info_logs(p_codsg, l_user, 'CODDIR',old_coddir,'','Suppression code direction');
        maj_struct_info_logs(p_codsg, l_user, 'CAFI',old_cafi,'','Suppression centre activite FI');
        maj_struct_info_logs(p_codsg, l_user, 'SCENTREFRAIS',old_scentrefrais,'','Suppression centre de frais');
        maj_struct_info_logs(p_codsg, l_user, 'FILCODE',old_filcode,'','Suppression code de la filiale');
        maj_struct_info_logs(p_codsg, l_user, 'TOP_DIVA',old_top_diva,'','Suppression top diva');
        maj_struct_info_logs(p_codsg, l_user, 'TOP_DIVA_INT',old_top_diva_int,'','Suppression top diva intervenants');


         EXCEPTION

		WHEN referential_integrity THEN

               -- habiller le msg erreur

              pack_global.recuperation_integrite(-2292);

		WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN

	   -- 'Accès concurrent'

	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );

      ELSE

	   -- 'Le pôle p_codsg a été supprimé'

	   pack_global.recuperer_message( 1003, '%s1', p_codsg, NULL, l_msg);
	   p_message := l_msg;

      END IF;

   END delete_struct_info;



   PROCEDURE select_struct_info ( p_codsg          IN VARCHAR2,
                                  p_userid         IN VARCHAR2,
                                  p_curStruct_info IN OUT struct_infoCurType_Char,
                                  p_nbcurseur         OUT INTEGER,
                                  p_message           OUT VARCHAR2
                              ) IS

	l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

-- dbms_output.put_line('p_codsg = ' || p_codsg || ' --- p_userid = ' || p_userid );

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN   p_curStruct_info FOR
              SELECT 	TO_CHAR(codsg),
                     	sigdep,
                     	sigpole,
                     	libdsg,
						gnom,
                     	TO_CHAR(centractiv),
                     	topfer,
                     	flaglock,
		     			TO_CHAR(coddir),
		     			TO_CHAR(cafi),
		     			TO_CHAR(scentrefrais),
		      			filcode,
		      			top_diva,
						TO_CHAR(ident_gdm),
						matricule,
						top_diva_int
              FROM  STRUCT_INFO
              WHERE codsg = TO_NUMBER(p_codsg);

         -- en cas absence
	   -- 'Code Département/Pôle/Groupe p_codsg inexistant'

         pack_global.recuperer_message( 20203, '%s1', p_codsg, NULL, l_msg);
         p_message := l_msg;

      EXCEPTION

        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

   END select_struct_info;


   --Procédure pour remplir les logs de MAJ des oodes dpg
PROCEDURE maj_struct_info_logs (p_codsg       IN STRUCT_INFO.codsg%TYPE,
                              p_user_log    IN VARCHAR2,
                              p_colonne        IN VARCHAR2,
                              p_valeur_prec    IN VARCHAR2,
                              p_valeur_nouv    IN VARCHAR2,
                              p_commentaire    IN VARCHAR2
                              ) IS
BEGIN

    IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
        INSERT INTO STRUCT_INFO_LOGS
            (codsg, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
        VALUES
            (p_codsg, SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);

    END IF;
    -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

END maj_struct_info_logs;

END pack_struct_info;
/


