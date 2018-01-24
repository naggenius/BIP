-- pack_liste_activites PL/SQL
-- 
-- Créé le 02/05/2005 par EJE
-- Modifié le 31/07/2005 par PPR : restraint la liste des lignes BIP à celles non présentes
--  dans une activité du groupe
-- Modifié le 20/09/2005 par PPR : affine la liste des lignes BIP au lignes en vie au début de l'année
--
--*******************************************************************

CREATE OR REPLACE PACKAGE pack_liste_activites AS

   TYPE activites_ListeViewType IS RECORD(  	CODE_ACTIVITE   VARCHAR2(12),
  						LIB_ACTIVITE     VARCHAR2(60)
					  );

   TYPE activites_listeCurType IS REF CURSOR RETURN activites_ListeViewType;
   
   TYPE ligne_ListeViewType IS RECORD(  PID   ligne_bip.codsg%TYPE,
   					LIB   VARCHAR2(50)
				);

   TYPE ligne_listeCurType IS REF CURSOR RETURN ligne_ListeViewType;

   PROCEDURE lister_activites_dpg( 	p_codsg 	IN VARCHAR2,
   					p_userid 	IN VARCHAR2,
   					p_curseur 	IN OUT activites_listeCurType
                             	);
                             	
   PROCEDURE lister_ligne_dpg( 	p_codsg 	IN VARCHAR2,
   				p_code_activite IN VARCHAR2,
   				p_userid 	IN VARCHAR2,
   				p_curseur 	IN OUT ligne_listeCurType
                             	);

END pack_liste_activites;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_activites AS 
   PROCEDURE lister_activites_dpg( 	p_codsg IN VARCHAR2,
   					p_userid IN VARCHAR2,
   					p_curseur IN OUT activites_listeCurType
                             ) IS

	l_msg VARCHAR2(1024);
	l_codsg NUMBER;

   BEGIN
   	

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      
	If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);
        
     ELSE
     IF ( pack_habilitation.fhabili_me(p_codsg, p_userid)= 'faux' ) 
     THEN
	pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
	raise_application_error(-20364,l_msg);

     ELSE

	BEGIN
        	OPEN   p_curseur FOR
        	SELECT '', 
               ' ' LIB_ACTIVITEß
        	FROM dual
       	     UNION
              	SELECT 	code_activite CODE_ACTIVITEß,
              		code_activite || ' - ' || lib_activite LIB_ACTIVITEß
              	FROM  ree_activites
              	WHERE codsg = TO_NUMBER(p_codsg) and type = 'N'
              	order by 2;

      		EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
       END;
        END IF; 
     END IF;
     
     
  END lister_activites_dpg;
  
  PROCEDURE lister_ligne_dpg( 	p_codsg 	IN VARCHAR2,
   				p_code_activite IN VARCHAR2,
   				p_userid 	IN VARCHAR2,
   				p_curseur 	IN OUT ligne_listeCurType
                             ) IS

	l_msg VARCHAR2(1024);
	l_codsg NUMBER;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      
	If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);
        
     ELSE
     IF ( pack_habilitation.fhabili_me(p_codsg, p_userid)= 'faux' ) 
     THEN
	pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
	raise_application_error(-20364,l_msg);

     ELSE

	BEGIN
        	OPEN   p_curseur FOR
              	SELECT 	pid PID,
			pid || ' - ' || pnom LIB
		FROM  ligne_bip lb, datdebex d
		where lb.CODSG = p_codsg 
		and   lb.TYPPROJ <> '7'
		and   ( lb.adatestatut is null or lb.adatestatut>= d.datdebex )
		and not exists ( SELECT ralb.pid
				 FROM ree_activites_ligne_bip ralb
				 WHERE ralb.CODSG = p_codsg 
				 AND   ralb.pid = lb.pid ) 
		ORDER BY pid	 ;


      		EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
       END;
        END IF; 
     END IF;
     
     
  END lister_ligne_dpg;

END pack_liste_activites;
/                       