-- pack_liste_actualites PL/SQL
-- 
-- Créé le 05/10/2004 par KHA
--
-- 10/01/2007 ASI  * Ajout des tests des popup d'alertes
-- 16/02/2007 EVI  * Ajout d'un commit a la fin de la requete d'insertion dans la table ALERTE_ACTU_USER
--*******************************************************************

CREATE OR REPLACE PACKAGE Pack_Liste_Actualites AS

   TYPE actualites_ListeViewType IS RECORD(  CODE_ACTU   ACTUALITE.code_actu%TYPE,
  		TITRE       ACTUALITE.titre%TYPE,
  		DATE_AFFICHE  VARCHAR2(20),
  		DATE_DEBUT    VARCHAR2(20),
  		DATE_FIN      VARCHAR2(20),
  		VALIDE        CHAR(3),
  		DERNIERE_MINUTE CHAR(3)
					                                          );
 TYPE accueil_actu_ListeViewType IS RECORD(  CODE_ACTU   ACTUALITE.code_actu%TYPE,
  		TITRE       ACTUALITE.titre%TYPE,
  		TEXTE       ACTUALITE.texte%TYPE,
  		DATE_AFFICHE  VARCHAR2(20),
  		URL         ACTUALITE.url%TYPE,
  		DATE_TRI    ACTUALITE.date_affiche%TYPE

					                                          );
   TYPE actualites_listeCurType IS REF CURSOR RETURN actualites_ListeViewType;
   TYPE accueil_actu_listeCurType IS REF CURSOR RETURN accueil_actu_ListeViewType;

   PROCEDURE lister_actualites( p_userid IN VARCHAR2,
   				p_curseur IN OUT actualites_listeCurType
                             );


   PROCEDURE lister_actualites_accueil( p_profils IN VARCHAR2,
   					p_derniere_minute IN VARCHAR2,
   					p_userid IN VARCHAR2,
   					p_curseur IN OUT accueil_actu_listeCurType
                             );
							 
   PROCEDURE lister_alertes_actu_accueil( p_profils IN VARCHAR2,
   					p_userid IN VARCHAR2,
   					p_curseur IN OUT accueil_actu_listeCurType
                             );			
	PROCEDURE exist_alertes_actu_accueil( p_profils IN VARCHAR2,
   					p_userid IN VARCHAR2,
   					p_count OUT INTEGER
                             );	
							 
	PROCEDURE confirmation_lecture(p_matricule IN VARCHAR2,
	p_code_actu IN VARCHAR2,
	p_message OUT VARCHAR2);				 

	
END Pack_Liste_Actualites;
/

CREATE OR REPLACE PACKAGE BODY Pack_Liste_Actualites AS

PROCEDURE lister_actualites(   p_userid IN VARCHAR2,
				p_curseur IN OUT actualites_listeCurType

                             ) IS



      	l_msg	VARCHAR2(1024);
 	l_code_actu NUMBER(5);
   	l_actu_rowcount BINARY_INTEGER;




      	BEGIN
      	BEGIN

             -- On récupère les lignes correspondante
	     OPEN p_curseur FOR
	     SELECT 	CODE_ACTU,
  		TITRE       ,
  		TO_CHAR(DATE_AFFICHE,'DD/MM/YYYY') AS  DATE_AFFICHE,
  		TO_CHAR(DATE_DEBUT,'DD/MM/YYYY') AS  DATE_DEBUT,
  		TO_CHAR(DATE_FIN,'DD/MM/YYYY') AS DATE_FIN,
  		DECODE(VALIDE,'O','Oui','Non')  AS VALIDE,
  		DECODE(DERNIERE_MINUTE,'O','Oui','Non')  AS DERNIERE_MINUTE

             FROM   ACTUALITE

             ORDER BY CODE_ACTU DESC;

      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
           --a modifier
               Pack_Global.recuperer_message( 20366 , '%s1', 'La liste est vide', '', l_msg);
               RAISE_APPLICATION_ERROR(-20366 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;

	BEGIN

	l_actu_rowcount :=0;
	SELECT COUNT(*) INTO l_actu_rowcount
	FROM ACTUALITE;

	IF l_actu_rowcount = 0 THEN

	Pack_Global.recuperer_message( 20366 , '%s1', 'La liste est vide', '', l_msg);

        RAISE_APPLICATION_ERROR(-20366 , l_msg);
        END IF;
	END;
  	END lister_actualites;

PROCEDURE lister_actualites_accueil( p_profils IN VARCHAR2,
					p_derniere_minute IN VARCHAR2,
   					p_userid IN VARCHAR2,
   					p_curseur IN OUT accueil_actu_listeCurType
                             ) IS



      	l_msg	VARCHAR2(1024);
 	l_code_actu NUMBER(5);
 	l_valide CHAR(1):='O';
      	BEGIN
      	BEGIN

             -- On récupère les lignes correspondante

		IF(p_derniere_minute != 'P') THEN 
			 OPEN p_curseur FOR	     
		   SELECT DISTINCT	DECODE (NOM_FICHIER, '', 0, a.CODE_ACTU)  AS CODE_ACTU   ,
					TITRE       ,

					DECODE(INSTR(TEXTE, chr(10)), 0,TEXTE,replace(TEXTE,chr(10),'<BR>'))       , --ABN - HP PPM 59158
					TO_CHAR(DATE_AFFICHE,'DD/MM/YYYY') AS DATE_AFFICHE,
					DECODE(URL, NULL,' ',URL) AS URL,
					date_affiche AS DATE_TRI
				 FROM   	ACTUALITE	   a,
						LIEN_PROFIL_ACTU    l
				 WHERE 	a.code_actu= l.code_actu
				AND ( (INSTR( UPPER(p_profils), UPPER(l.CODE_PROFIL))>0)
					  OR (UPPER(l.CODE_PROFIL)='POURTOUS') )
				AND derniere_minute = p_derniere_minute
				AND VALIDE = l_valide
				AND SYSDATE BETWEEN DATE_DEBUT AND DATE_FIN
		  ORDER BY DATE_TRI DESC;     	
		 ELSE
		  OPEN p_curseur FOR	  
		  SELECT DISTINCT	DECODE (NOM_FICHIER, '', 0, a.CODE_ACTU)  AS CODE_ACTU   ,
					TITRE       ,
					TEXTE       ,
					TO_CHAR(DATE_AFFICHE,'DD/MM/YYYY') AS DATE_AFFICHE,
					DECODE(URL, NULL,' ',URL) AS URL,
					date_affiche AS DATE_TRI
		  FROM   	ACTUALITE	   a
				WHERE derniere_minute = p_derniere_minute
				AND VALIDE = l_valide
				AND SYSDATE BETWEEN DATE_DEBUT AND DATE_FIN
		  ORDER BY DATE_TRI DESC;    
		END IF;

      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
           --a modifier
               Pack_Global.recuperer_message( 20366 , '%s1', 'La liste est vide', '', l_msg);
               RAISE_APPLICATION_ERROR(-20366 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;

  	END lister_actualites_accueil;
	
	
	
	PROCEDURE lister_alertes_actu_accueil( p_profils IN VARCHAR2,
   					p_userid IN VARCHAR2,
   					p_curseur IN OUT accueil_actu_listeCurType
                             ) IS

      	l_msg	VARCHAR2(1024);
  	l_valide CHAR(1):='O';
      	BEGIN
      	BEGIN

             -- On récupère les lignes correspondante

	     OPEN p_curseur FOR

			  SELECT DISTINCT CODE_ACTU   ,
  				TITRE       ,
  				TEXTE       ,
  				TO_CHAR(DATE_AFFICHE,'DD/MM/YYYY') AS DATE_AFFICHE,
  				DECODE(URL, NULL,' ',URL) AS URL,
  				date_affiche AS DATE_TRI
             FROM   	ACTUALITE	   a
			WHERE a.CODE_ACTU  IN ((
				     SELECT DISTINCT a1.code_actu 
					              FROM   	
								  ACTUALITE	   a1,
								  LIEN_PROFIL_ACTU    l
				
					              WHERE  ((INSTR( UPPER(p_profils), UPPER(l.CODE_PROFIL))>0)
							      OR (UPPER(l.CODE_PROFIL)='POURTOUS') )
								  AND l.CODE_ACTU=a1.code_actu 
								  AND a1.VALIDE = 'O'
       	 		                  AND a1.ALERTE_ACTU='O'
			                      AND SYSDATE BETWEEN a1.DATE_DEBUT AND a1.DATE_FIN ) MINUS ( SELECT al.code_actu FROM 	ALERTE_ACTU_USER  al	WHERE al.matricule=p_userid)	)
  		
             ORDER BY DATE_TRI DESC;

      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
           --a modifier
               Pack_Global.recuperer_message( 20366 , '%s1', 'La liste est vide', '', l_msg);
               RAISE_APPLICATION_ERROR(-20366 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;

  	END lister_alertes_actu_accueil;

	
		
	PROCEDURE exist_alertes_actu_accueil( p_profils IN VARCHAR2,
   					p_userid IN VARCHAR2,
   					p_count OUT INTEGER
                             ) IS
p_cou INTEGER:=0;
    BEGIN
    
	p_count := 0;

	
	     SELECT COUNT(*) INTO p_cou
		
             FROM   	ACTUALITE	   a
			WHERE a.CODE_ACTU  IN ((
				     SELECT DISTINCT a1.code_actu 
					              FROM   	
								  ACTUALITE	   a1,
								  LIEN_PROFIL_ACTU    l
				
					              WHERE  ((INSTR( UPPER(p_profils), UPPER(l.CODE_PROFIL))>0)
							      OR (UPPER(l.CODE_PROFIL)='POURTOUS') )
								  AND l.CODE_ACTU=a1.code_actu 
								  AND a1.VALIDE = 'O'
       	 		                  AND a1.ALERTE_ACTU='O'
			                      AND SYSDATE BETWEEN a1.DATE_DEBUT AND a1.DATE_FIN ) MINUS ( SELECT al.code_actu FROM 	ALERTE_ACTU_USER  al	WHERE al.matricule=p_userid)	);
  		
		 IF p_cou >0 THEN
		  p_count:=0;
		  ELSE
		  p_count:=p_cou;
		 END IF;
		
		 
  	END exist_alertes_actu_accueil;
	
	PROCEDURE confirmation_lecture(p_matricule IN VARCHAR2,
	p_code_actu IN VARCHAR2,
	p_message OUT VARCHAR2)IS
	

   BEGIN

      p_message := '';

      BEGIN
         INSERT INTO  ALERTE_ACTU_USER  (code_actu,
                               matricule, date_conf
                              )
         VALUES (p_code_actu,
                 p_matricule, SYSDATE
                );

      	COMMIT;
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            Pack_Global.recuperer_message(20213, NULL, NULL, NULL, p_message);
            RAISE_APPLICATION_ERROR( -20213, p_message );

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
			p_message:='ERROR INSERTION';
      END;
	
	
	END confirmation_lecture;
END Pack_Liste_Actualites;
/
