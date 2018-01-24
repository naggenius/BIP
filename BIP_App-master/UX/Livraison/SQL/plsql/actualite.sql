-- pack_actu PL/SQL
--
-- K. Hazard
-- Créé le 06/10/2004
-- 
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

-- 10/01/2007 ASI  * Ajout des tests d'alertes d'actualité.

CREATE OR REPLACE PACKAGE Pack_Actu AS

   -- Définition curseur sur la table actualite

   TYPE actualite_ViewType IS RECORD ( code_actu  ACTUALITE.code_actu%TYPE,
					titre ACTUALITE.titre%TYPE,
					texte ACTUALITE.texte%TYPE,
					date_affiche VARCHAR2(20),
					date_debut VARCHAR2(20),
					date_fin VARCHAR2(20),
					valide ACTUALITE.valide%TYPE,
					url ACTUALITE.url%TYPE,
					derniere_minute ACTUALITE.derniere_minute%TYPE,
					alerte_actu ACTUALITE.alerte_actu%TYPE,
					nom_fichier ACTUALITE.nom_fichier%TYPE,
					mime_fichier ACTUALITE.mime_fichier%TYPE,
					size_fichier ACTUALITE.size_fichier%TYPE

					 	);


   TYPE actualiteCurType_Char IS REF CURSOR RETURN actualite_ViewType;


   PROCEDURE insert_actualite (
					p_titre IN VARCHAR2,
					p_texte IN VARCHAR2,
					p_date_affiche IN VARCHAR2,
					p_date_debut IN VARCHAR2,
					p_date_fin IN VARCHAR2,
					p_valide IN VARCHAR2,
					p_url IN VARCHAR2,
					p_derniere_minute IN VARCHAR2,
					p_alerte_actu IN VARCHAR2,
					p_string_menus IN VARCHAR2,
					p_nom_fichier IN VARCHAR2,
					p_mime_fichier IN VARCHAR2,
					p_size_fichier IN VARCHAR2,
                                  	p_userid     	IN  VARCHAR2,
                                  	p_code_actu OUT VARCHAR2,
                                  	p_nbcurseur  	OUT INTEGER,
                                  	p_message    	OUT VARCHAR2
                                );

   PROCEDURE update_actualite ( 	p_code_actu IN VARCHAR2,
					p_titre IN VARCHAR2,
					p_texte IN VARCHAR2,
					p_date_affiche IN VARCHAR2,
					p_date_debut IN VARCHAR2,
					p_date_fin IN VARCHAR2,
					p_valide IN VARCHAR2,
					p_url IN VARCHAR2,
					p_derniere_minute IN VARCHAR2,
					p_alerte_actu IN VARCHAR2,
					p_string_menus IN VARCHAR2,
					p_nom_fichier IN VARCHAR2,
					p_mime_fichier IN VARCHAR2,
					p_size_fichier IN VARCHAR2,
					p_top_update_fichier IN VARCHAR2,
				  	p_userid     	IN  VARCHAR2,
				  	p_nbcurseur  	OUT INTEGER,
                                  	p_message    	OUT VARCHAR2
                              );

   PROCEDURE delete_actualite ( p_code_actu     IN  VARCHAR2,
                                  p_userid    IN  VARCHAR2,
                                  p_nbcurseur OUT INTEGER,
                                  p_message   OUT VARCHAR2
                              );

   PROCEDURE select_actualite ( p_code_actu	   IN VARCHAR2,
                                  p_userid         IN VARCHAR2,
                                  p_curactualite IN OUT actualiteCurType_Char ,
                                  p_nbcurseur         OUT INTEGER,
                                  p_message           OUT VARCHAR2
                                );

END Pack_Actu;
/
CREATE OR REPLACE PACKAGE BODY Pack_Actu AS

  PROCEDURE insert_actualite (
					p_titre IN VARCHAR2,
					p_texte IN VARCHAR2,
					p_date_affiche IN VARCHAR2,
					p_date_debut IN VARCHAR2,
					p_date_fin IN VARCHAR2,
					p_valide IN VARCHAR2,
					p_url IN VARCHAR2,
					p_derniere_minute IN VARCHAR2,
					p_alerte_actu IN VARCHAR2,
					p_string_menus IN VARCHAR2,
					p_nom_fichier IN VARCHAR2,
					p_mime_fichier IN VARCHAR2,
					p_size_fichier IN VARCHAR2,
                                  	p_userid	IN VARCHAR2,
                                  	p_code_actu OUT VARCHAR2,
                                  	p_nbcurseur	OUT INTEGER,
                                  	p_message	OUT VARCHAR2
                              ) IS

     l_msg VARCHAR2(1024);
     l_msg_alert VARCHAR2(1024);
     l_code_actu ACTUALITE.code_actu%TYPE;
 	l_string_menus VARCHAR2(1000);
	l_menu VARCHAR2(1000);
     l_count NUMBER;




   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

---------------------------------------------------------------------------
-- La date de debut est toujours inférieure à la date de fin
---------------------------------------------------------------------------
 	BEGIN
	 IF TO_DATE(p_date_debut,'DD/MM/YYYY') > TO_DATE(p_date_fin,'DD/MM/YYYY') THEN
         Pack_Global.recuperer_message( 20366 , '%s1', 'date incompatible', '', l_msg);
         RAISE_APPLICATION_ERROR(-20366, l_msg);
      	END IF;
	END;


--Insert
	BEGIN


	SELECT MAX(code_actu)+1 INTO l_code_actu
		FROM ACTUALITE;
	IF l_code_actu IS NULL THEN l_code_actu :=1;
	END IF ;
	p_code_actu := l_code_actu;

     	   INSERT INTO ACTUALITE
	    ( code_actu,
		titre,
		texte,
		date_affiche,
		date_debut,
		date_fin,
		valide,
		url,
		FICHIER,
		nom_fichier,
		mime_fichier,
		size_fichier,
		derniere_minute,
		alerte_actu
 		)
         VALUES ( TO_NUMBER(l_code_actu),
         		p_titre,
         		p_texte,
         		TO_DATE(p_date_affiche,'DD/MM/YYYY'),
         		TO_DATE(p_date_debut,'DD/MM/YYYY'),
         		TO_DATE(p_date_fin,'DD/MM/YYYY'),
         		p_valide,
         		p_url,
         		EMPTY_BLOB(),
         		p_nom_fichier,
         		p_mime_fichier,
         		TO_NUMBER(p_size_fichier),
         		p_derniere_minute,
				p_alerte_actu

		);


	   	-- 'Actualité  p_code_actu créée'

		-- et  si derniere minute ne doit chevaucher avec un autre profil


	 IF p_derniere_minute = 'O' THEN
        	SELECT COUNT (*) INTO l_count
		FROM
		ACTUALITE a,
		LIEN_PROFIL_ACTU l
		WHERE
		derniere_minute=p_derniere_minute
		AND a.code_actu = l.code_actu
		AND
		((p_date_debut BETWEEN date_debut AND date_fin)
		OR  (p_date_fin BETWEEN date_debut AND date_fin)
		OR (date_debut BETWEEN p_date_debut AND p_date_fin)
		OR  (date_fin BETWEEN p_date_debut AND p_date_fin))
		AND INSTR( p_string_menus, l.CODE_PROFIL)>0;
         	IF l_count > 0 THEN
         		Pack_Global.recuperer_message( 20366 , '%s1', 'Attention l actualite créée chevauche une autre actualite de type derniere minute', '', l_msg);
	  		p_message:=l_msg;
         	ELSE
        	 	Pack_Global.recuperer_message( 21000, '%s1', p_code_actu, NULL, l_msg);
			p_message:=l_msg;
         	END IF;
      	ELSE
         	Pack_Global.recuperer_message( 21000, '%s1', p_code_actu, NULL, l_msg);
		p_message:=l_msg;
	END IF;



     EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
		   Pack_Global.recuperer_message( 21001, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -21001, l_msg );

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
     END;
	BEGIN

		l_string_menus := p_string_menus;
		IF (l_string_menus IS NOT NULL OR l_string_menus != '') THEN
		LOOP
		l_menu := SUBSTR(l_string_menus,1,INSTR( l_string_menus, ',', 1, 1)-1);
		INSERT INTO LIEN_PROFIL_ACTU
		    ( code_actu,
		      code_profil
			)
     	    VALUES ( TO_NUMBER(l_code_actu),
      	   		LOWER(l_menu)
			);


		l_string_menus := SUBSTR(l_string_menus,INSTR( l_string_menus, ',', 1, 1)+1);
		EXIT WHEN l_string_menus IS NULL;
		END LOOP;
		END IF;
		EXCEPTION
		WHEN OTHERS THEN
		        RAISE_APPLICATION_ERROR( -21002, l_msg );
		END;
   END insert_actualite;



   PROCEDURE update_actualite ( 	p_code_actu IN VARCHAR2,
					p_titre IN VARCHAR2,
					p_texte IN VARCHAR2,
					p_date_affiche IN VARCHAR2,
					p_date_debut IN VARCHAR2,
					p_date_fin IN VARCHAR2,
					p_valide IN VARCHAR2,
					p_url IN VARCHAR2,
					p_derniere_minute IN VARCHAR2,
					p_alerte_actu IN VARCHAR2,
					p_string_menus IN VARCHAR2,
					p_nom_fichier IN VARCHAR2,
					p_mime_fichier IN VARCHAR2,
					p_size_fichier IN VARCHAR2,
					p_top_update_fichier IN VARCHAR2,
				  	p_userid     	IN  VARCHAR2,
				  	p_nbcurseur  	OUT INTEGER,
                                  	p_message    	OUT VARCHAR2
                              ) IS

	l_msg VARCHAR2(1024);
	l_string_menus VARCHAR2(1000);
	l_menu VARCHAR2(1000);
	l_count NUMBER;
	l_texte actualite.texte%type;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- initialiser le message retour

	p_nbcurseur := 0;
	p_message := '';


	BEGIN
	 IF TO_DATE(p_date_debut,'DD/MM/YYYY') > TO_DATE(p_date_fin,'DD/MM/YYYY') THEN
         Pack_Global.recuperer_message( 20366 , '%s1', 'date incompatible', '', l_msg);
         RAISE_APPLICATION_ERROR(-20366, l_msg);
      	END IF;
	END;

	BEGIN

	l_string_menus := p_string_menus;
	DELETE FROM LIEN_PROFIL_ACTU
	WHERE code_actu = TO_NUMBER(p_code_actu);

	IF (l_string_menus IS NOT NULL OR l_string_menus != '') THEN
	LOOP
	l_menu := SUBSTR(l_string_menus,1,INSTR( l_string_menus, ',', 1, 1)-1);
	INSERT INTO LIEN_PROFIL_ACTU
	    ( code_actu,
	      code_profil
		)
         VALUES ( TO_NUMBER(p_code_actu),
         		LOWER(l_menu)
		);

	l_string_menus := SUBSTR(l_string_menus,INSTR( l_string_menus, ',', 1, 1)+1);
	EXIT WHEN l_string_menus IS NULL;
	END LOOP;
	END IF;
	EXCEPTION
	WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR( -21002, l_msg );
	END;


	BEGIN


         UPDATE ACTUALITE
		SET	 		titre=p_titre,
					texte=p_texte,
					date_affiche=TO_DATE(p_date_affiche,'DD/MM/YYYY'),
					date_debut=TO_DATE(p_date_debut,'DD/MM/YYYY'),
					date_fin=TO_DATE(p_date_fin,'DD/MM/YYYY'),
					valide=p_valide,
					url=p_url,
					derniere_minute=p_derniere_minute,
					alerte_actu=p_alerte_actu
		  WHERE code_actu 	= TO_NUMBER(p_code_actu);
          IF (p_top_update_fichier != 'N') THEN
          UPDATE ACTUALITE
		SET	 		nom_fichier=p_nom_fichier,
					mime_fichier=p_mime_fichier,
					size_fichier = TO_NUMBER(p_size_fichier),
          FICHIER = EMPTY_BLOB()--PPM-60971 : initialisation du blob
		  WHERE code_actu 	= TO_NUMBER(p_code_actu);
	END IF;
	   EXCEPTION

		WHEN OTHERS THEN
	        -- RAISE_APPLICATION_ERROR( -21002, l_msg ); -- HP PPM 60971
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	--	   raise_application_error( -20997, SQLERRM);
	END;


      	IF SQL%NOTFOUND THEN

	   -- 'Accès concurrent'

	 Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );

      ELSE

 -- 'Le pôle p_code_actu a été modifié'
	 IF p_derniere_minute = 'O' THEN
        	SELECT COUNT (*) INTO l_count
		FROM
		ACTUALITE a,
		LIEN_PROFIL_ACTU l
		WHERE
		derniere_minute=p_derniere_minute
		AND a.code_actu = l.code_actu
		AND a.code_actu <> p_code_actu
		AND
		((p_date_debut BETWEEN date_debut AND date_fin)
		OR  (p_date_fin BETWEEN date_debut AND date_fin)
		OR (date_debut BETWEEN p_date_debut AND p_date_fin)
		OR  (date_fin BETWEEN p_date_debut AND p_date_fin))
		AND INSTR( p_string_menus, l.CODE_PROFIL)>0;
         	IF l_count > 0 THEN
         		Pack_Global.recuperer_message( 20366 , '%s1', 'Attention l actualite modifiée chevauche une autre actualite de type derniere minute', '', l_msg);
	  		p_message:=l_msg;
         	ELSE
        	 	Pack_Global.recuperer_message( 21003, '%s1', p_code_actu, NULL, l_msg);
	   		p_message:=l_msg;
         	END IF;
      	ELSE
         	Pack_Global.recuperer_message( 21003, '%s1', p_code_actu, NULL, l_msg);
	   	p_message:=l_msg;
	END IF;
	   -- 'Le pôle p_code_actu a été modifié'

	  -- pack_global.recuperer_message( 21003, '%s1', p_code_actu, NULL, l_msg);
	  -- p_message:=l_msg;



      END IF;

   END update_actualite;


   PROCEDURE delete_actualite ( p_code_actu     IN  VARCHAR2,

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

	   DELETE FROM ACTUALITE
		    WHERE code_actu = TO_NUMBER(p_code_actu)
			;
	   DELETE FROM ALERTE_ACTU_USER
		    WHERE code_actu = TO_NUMBER(p_code_actu)
			;
  	    Pack_Global.recuperer_message( 21004, '%s1', p_code_actu, NULL, l_msg);
            p_message := l_msg;
         EXCEPTION

		WHEN referential_integrity THEN

               -- habiller le msg erreur

               Pack_Global.recuperation_integrite(-2292);

		WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;


   END delete_actualite;



   PROCEDURE select_actualite ( p_code_actu      IN VARCHAR2,
                                  p_userid       IN VARCHAR2,
                                  p_curactualite IN OUT actualiteCurType_Char,
                                  p_nbcurseur    OUT INTEGER,
                                 p_message      OUT VARCHAR2
                              ) IS

	l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';



-- dbms_output.put_line('p_code_actu = ' || p_code_actu || ' --- p_userid = ' || p_userid );

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN   p_curactualite FOR
              SELECT 	code_actu,
              titre,
              texte,
		TO_CHAR(date_affiche,'DD/MM/YYYY'),
		TO_CHAR(date_debut,'DD/MM/YYYY'),
		TO_CHAR(date_fin,'DD/MM/YYYY'),
		valide,
		url,
		derniere_minute,
		alerte_actu,
		nom_fichier,
		mime_fichier,
		size_fichier

              FROM  ACTUALITE
              WHERE code_actu = TO_NUMBER(p_code_actu);

         -- en cas absence
	   -- 'Actualité p_code_actu inexistant'

         Pack_Global.recuperer_message( 21002, '%s1', p_code_actu, NULL, l_msg);
         p_message := l_msg;

      EXCEPTION

        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

   END select_actualite;

END Pack_Actu;
/

