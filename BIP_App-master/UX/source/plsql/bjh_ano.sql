-- pack_bjh_anomalies PL/SQL
--
-- Maintenance BIP
-- Créé le 04/12/2000
-- Modifié le 05/09/2001 par NBM :select_bjh_anomalies =>choix d'entrer soit le matricule soit le code --						ressource soit le code DPG
--						
-- Modifié le 19/11/2001 par ARE : prise en compte de la nouvelle structure de table
--
-- ****************************************************************************
--
--  Attention le nom du package ne peut etre le nom
--  de la table...
-- ****************************************************************************
--

CREATE OR REPLACE PACKAGE pack_bjh_anomalies AS
	
   TYPE Bjh_anomalies_ViewType IS RECORD (matricule bjh_anomalies.matricule%TYPE,
					  nom bjh_ressource.nom%type,
					  prenom bjh_ressource.prenom%type
					);




   TYPE Bjh_une_ano_ViewType IS RECORD (  matricule bjh_anomalies.matricule%TYPE,
					  nom bjh_ressource.nom%type,
					  prenom bjh_ressource.prenom%TYPE,
					  mois bjh_anomalies.mois%TYPE,
					  typeabsence bjh_anomalies.typeabsence%TYPE,
					  coutgip VARCHAR2(20),
					  coutbip VARCHAR2(20),
					  dateano VARCHAR2(20),
					  diff VARCHAR2(20),
					  ecartcal VARCHAR2(20),
					  validation1 bjh_anomalies.validation1%TYPE,
					  validation2 bjh_anomalies.validation2%TYPE
					);


   TYPE bjh_anomaliesCurType_Char IS REF CURSOR RETURN Bjh_anomalies_ViewType;
   TYPE bjh_une_anoCurType_Char IS REF CURSOR RETURN Bjh_une_ano_ViewType;

  PROCEDURE update_bjh_anomalies(   p_nom IN VARCHAR2,
   				    p_matricule IN VARCHAR2,
				    p_prenom IN VARCHAR2,
				    p_mois IN VARCHAR2,
				    p_typeabsence IN VARCHAR2,
				    p_dateano       IN VARCHAR2,
				    p_coutbip          IN VARCHAR2,
				    p_coutgip       IN VARCHAR2,
				    p_diff IN VARCHAR2,
				    p_ecartcal IN VARCHAR2,
				    p_validation1   IN VARCHAR2,
				    p_validation2   IN VARCHAR2,
				    p_userid     IN  VARCHAR2,
				    p_nbcurseur  OUT INTEGER,
                	            p_message    OUT VARCHAR2
	                             );

   PROCEDURE delete_bjh_anomalies ( p_matricule IN VARCHAR2,
				    p_nom IN VARCHAR2,
				    p_prenom IN VARCHAR2,
				    p_mois IN VARCHAR2,
				    p_typeabsence IN VARCHAR2,
				    p_coutgip       IN VARCHAR2,
				    p_coutbip       IN VARCHAR2,
				    p_dateano       IN VARCHAR2,
				    p_validation1   IN VARCHAR2,
				    p_validation2   IN VARCHAR2,
				    p_userid    IN  VARCHAR2,
        	                    p_nbcurseur OUT INTEGER,
                	            p_message   OUT VARCHAR2);

   PROCEDURE select_bjh_anomalies ( 	p_matricule  IN VARCHAR2,
					p_ident      IN VARCHAR2,
					p_codsg      IN VARCHAR2,
				    	p_userid     IN VARCHAR2,
        	                    	p_curBjh_ano IN OUT bjh_anomaliesCurType_Char,
                	            	p_nbcurseur     OUT INTEGER,
                        	    	p_message       OUT VARCHAR2);

   PROCEDURE select_bjh_une_ano( p_matricule IN VARCHAR2,
				 p_rnom IN VARCHAR2,
				 p_prenom IN VARCHAR2,
				 p_cle IN VARCHAR2,
				 p_userid IN VARCHAR2,
        	                 p_curBjh_ano IN OUT bjh_une_anoCurType_Char,
                	         p_nbcurseur         OUT INTEGER,
                                 p_message           OUT VARCHAR2);


   PROCEDURE select_bjh_liste (	p_matricule  IN VARCHAR2,
				p_userid     IN VARCHAR2,
				p_curBjh_ano IN OUT bjh_anomaliesCurType_Char,
                	        p_nbcurseur     OUT INTEGER,
                        	p_message       OUT VARCHAR2);



END pack_bjh_anomalies;
/


CREATE OR REPLACE PACKAGE BODY pack_bjh_anomalies AS 

   PROCEDURE update_bjh_anomalies(  p_nom IN VARCHAR2,
   				    p_matricule IN VARCHAR2,
				    p_prenom IN VARCHAR2,
				    p_mois IN VARCHAR2,
				    p_typeabsence IN VARCHAR2,
				    p_dateano       IN VARCHAR2,
				    p_coutbip          IN VARCHAR2,
				    p_coutgip       IN VARCHAR2,
				    p_diff IN VARCHAR2,
				    p_ecartcal IN VARCHAR2,
				    p_validation1   IN VARCHAR2,
				    p_validation2   IN VARCHAR2,
				    p_userid     IN  VARCHAR2,
				    p_nbcurseur  OUT INTEGER,
                	            p_message    OUT VARCHAR2
	                             ) IS 

	l_msg VARCHAR2(1024);
	l_matricule bjh_anomalies.matricule%TYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- initialiser le message retour

	p_nbcurseur := 0;
	p_message := '';

      -- test si le type d'absence existe deja


	BEGIN
         UPDATE bjh_anomalies
		SET	
			coutgip = to_number(p_coutgip),
		     	coutbip = to_number(p_coutbip),
			validation1 = p_validation1,
			validation2 = nvl(p_validation2,' ')
		WHERE matricule = p_matricule
		AND mois = p_mois
		AND rtrim(typeabsence,' ') =rtrim(p_typeabsence,' ');

	   EXCEPTION

		WHEN OTHERS THEN
	        raise_application_error( -20754, l_msg );

	--	   raise_application_error( -20997, SQLERRM);
	END;


      IF SQL%NOTFOUND THEN
	   
	   -- 'Accès concurrent'

	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      END IF;

   END update_bjh_anomalies;

   PROCEDURE delete_bjh_anomalies (p_matricule IN VARCHAR2,
				    p_nom IN VARCHAR2,
				    p_prenom IN VARCHAR2,
				    p_mois IN VARCHAR2,
				    p_typeabsence IN VARCHAR2,
				    p_coutgip       IN VARCHAR2,
				    p_coutbip       IN VARCHAR2,
				    p_dateano       IN VARCHAR2,
				    p_validation1   IN VARCHAR2,
				    p_validation2   IN VARCHAR2,
				    p_userid    IN  VARCHAR2,
        	                    p_nbcurseur OUT INTEGER,
                	            p_message   OUT VARCHAR2
                              ) IS


	l_msg VARCHAR2(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
	   DELETE FROM bjh_anomalies
		    WHERE matricule = p_matricule
			AND mois = p_mois
			AND rtrim(typeabsence,' ') =rtrim(p_typeabsence,' ');

         EXCEPTION

		WHEN referential_integrity THEN

               -- habiller le msg erreur

               pack_global.recuperation_integrite(-2292);
	   
		WHEN OTHERS THEN
		   raise_application_error( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
	   
	   -- 'Accès concurrent'

	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      END IF;

   END delete_bjh_anomalies;

   PROCEDURE select_bjh_anomalies(  	p_matricule  IN VARCHAR2,
					p_ident      IN VARCHAR2,
					p_codsg      IN VARCHAR2,
				    	p_userid     IN VARCHAR2,
        	                    	p_curBjh_ano IN OUT bjh_anomaliesCurType_Char,
                	            	p_nbcurseur     OUT INTEGER,
                        	    	p_message       OUT VARCHAR2) IS
	l_msg VARCHAR2(1024);
	l_ges NUMBER(3);
	l_codsg VARCHAR2(7);

   BEGIN
	      
      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';
	BEGIN
		-- Le matricule est renseigné
		IF p_matricule is not null THEN
			SELECT distinct to_char(codsg, 'FM0000000') INTO l_codsg
			FROM bjh_ressource
			WHERE matricule = p_matricule
-- Bidouille pour que cette requete ne retourne qu'une seule ligne !
-- ODU 04/12/2001
				AND ROWNUM=1;
		ELSE
		-- Le code ressource est choisi
				SELECT distinct to_char(codsg, 'FM0000000') INTO l_codsg
				FROM bjh_ressource
				WHERE ident = to_number(p_ident)
-- Bidouille pour que cette requete ne retourne qu'une seule ligne !
-- ODU 04/12/2001
                                AND ROWNUM=1;
		END IF;
	EXCEPTION
  	    WHEN NO_DATA_FOUND THEN 
		-- en cas absence
	 	-- 'Anomalie inexistante
			pack_global.recuperer_message(20330, '%s1', p_matricule, NULL, l_msg); 
		 	raise_application_error( -20330, l_msg );

          WHEN OTHERS THEN
	            	raise_application_error( -20997,SQLERRM);
      END;
	
	

-- On verifie que l'utilisateur est habilite a acceder a cette ressource
-- Comme cette procedure est centrale dans les procedure du bouclage JH,
-- il n'est pas necessaire de le tester dans les autres.
pack_habilitation.verif_habili_me(l_codsg,p_userid,l_msg);

--             'à modifier la ressource ( matricule :' || p_matricule ||
--                                               ', code DPG :'|| l_codsg ||')', NULL);
	IF p_matricule is not null THEN
         	OPEN   p_curBjh_ano FOR
              SELECT a.MATRICULE,
			 BIP.NOM,
			 BIP.PRENOM
              FROM  bjh_anomalies a,(select distinct nom,prenom,matricule matricule1 from bjh_ressource) bip
              WHERE a.matricule = substr(p_matricule,1,7)
		AND a.matricule = bip.matricule1;
	ELSE
	
		OPEN   p_curBjh_ano FOR
              SELECT a.MATRICULE,
			 BIP.NOM,
			 BIP.PRENOM
              FROM  bjh_anomalies a,(select distinct nom,prenom,matricule,ident from bjh_ressource) bip
              WHERE bip.ident = to_number(p_ident)
		AND a.matricule = bip.matricule;
		

	END IF;
   
	     
   END select_bjh_anomalies;

   PROCEDURE select_bjh_une_ano(    p_matricule IN VARCHAR2,
				    p_rnom IN VARCHAR2,
				    p_prenom IN VARCHAR2,
				    p_cle IN VARCHAR2,
				    p_userid IN VARCHAR2,
        	                    p_curBjh_ano IN OUT bjh_une_anoCurType_Char,
                	            p_nbcurseur         OUT INTEGER,
                        	    p_message           OUT VARCHAR2) IS

	l_msg VARCHAR2(1024);
	l_ges NUMBER(3);
	l_codsg VARCHAR(7);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';
 
      BEGIN
	SELECT distinct to_char(codsg, 'FM0000000') INTO l_codsg
	FROM bjh_ressource
	WHERE matricule = p_matricule
-- bidouille pour avoir un seul DPG ...
-- ODU : 11/01/2002
		AND ROWNUM=1;


         OPEN   p_curBjh_ano FOR
              SELECT a.MATRICULE,
			 BIP.NOM,
			 BIP.PRENOM,
			 a.MOIS,
			 a.TYPEABSENCE,
			 TO_CHAR(a.COUTGIP,'FM999D0'),
			 TO_CHAR(a.COUTBIP,'FM999D0'),
			 TO_CHAR(a.DATEANO,'DD/MM/YYYY'),
			 TO_CHAR(a.coutbip-a.coutgip,'FM999D0') DIFF,
			 TO_CHAR(a.ecartcal,'FM999D0'),
			 a.validation1,
			 a.validation2
              FROM  bjh_anomalies a,(select distinct nom,prenom,matricule matricule1 from bjh_ressource) bip
              WHERE a.matricule = substr(p_matricule,1,7)
                AND a.mois=SUBSTR(p_cle,1,2)
                AND a.typeabsence=SUBSTR(p_cle,3,6)
		AND a.matricule = bip.matricule1;

         -- en cas absence
	 -- 'Anomalie inexistante'

         

      EXCEPTION
	WHEN NO_DATA_FOUND THEN
	  pack_global.recuperer_message(20330, '%s1', p_matricule, NULL, l_msg);
	   p_message := l_msg;
        WHEN OTHERS THEN
          raise_application_error( -20997, SQLERRM);
      END;

   END select_bjh_une_ano;

  PROCEDURE select_bjh_liste ( 		p_matricule  IN VARCHAR2,
				    	p_userid     IN VARCHAR2,
					p_curBjh_ano IN OUT bjh_anomaliesCurType_Char,
                	            	p_nbcurseur     OUT INTEGER,
                        	    	p_message       OUT VARCHAR2) IS
  l_msg VARCHAR2(1024);

  BEGIN
	OPEN   p_curBjh_ano FOR
              SELECT a.MATRICULE,
			 BIP.NOM,
			 BIP.PRENOM
              FROM  bjh_anomalies a,(select distinct nom,prenom,matricule matricule1 from bjh_ressource) bip
              WHERE a.matricule = substr(p_matricule,1,7)
		AND a.matricule = bip.matricule1;

	

	
  END select_bjh_liste;

END pack_bjh_anomalies;
/

-- exec pack_bjh_anomalies.select_bjh_anomalies('D01','ABSDIV',:pcur,:nbcur,:mess);
-- create table bjh_anomalies
-- (MATRICULE                                CHAR(7)
-- MOIS                                     NUMBER(2)
-- TYPEABSENCE                              CHAR(6)
-- COUTGIP                                  NUMBER(3,1)
-- COUTBIP                                  NUMBER(3,1)
-- DATEANO                                  DATE
-- VALIDATION1                              VARCHAR2(50)
-- VALIDATION2                              VARCHAR2(50)
-- ECARTCAL				    NUMBER(3,1));

