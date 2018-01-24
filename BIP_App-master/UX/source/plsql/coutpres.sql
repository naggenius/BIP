-- pack_cout_prestation PL/SQL
-- V. PRIEUR le 09/02/1999
-- Attention le nom du package ne peut etre le nom
-- de la table...
-- PB. : il y a un probleme pour la saisie des nombre avec ','
-- Modifié le 05/11/2001 par NBM: Table prestation au lieu de cout_prestation
-- Modifié le 18/11/2005 par BAA: Fiche 257 Evolution du référentiel compétence / prestation dans la BIP 
-- Modification le 28/06/2010 YNI Fiche 970
-- Modification le 18/07/2010 YNI Fiche 970
----------------------------------------------------------------------------------------------
create or replace PACKAGE Pack_Cout_Prestation AS

TYPE cout_prestation_Type IS RECORD (   CODPREST       		 PRESTATION.PRESTATION%TYPE,
						  	 												   			LIBPREST    			PRESTATION.libprest%TYPE,
                                        												CODE_DOMAINE  PRESTATION.code_domaine%TYPE,
																						CODE_ACHA          PRESTATION.code_acha%TYPE,
																						RTYPE                      PRESTATION.rtype%TYPE,
																						TOP_ACTIF             PRESTATION.top_actif%TYPE,
																						FLAGLOCK              PRESTATION.flaglock%TYPE
																						);


   TYPE cout_prestationCurType IS REF CURSOR RETURN cout_prestation_type;

   PROCEDURE insert_cout_prestation (
                                       				  							p_codprest   			 IN  CHAR,
                                       											p_libprest     				IN  VARCHAR2,
                                       											p_code_domaine   IN  VARCHAR2,
									   											p_code_acha 	  	  IN  VARCHAR2,
									   											p_rtype 			      	  IN  VARCHAR2,
                                       											p_top_actif                 IN  CHAR,
                                       											p_userid                     IN  VARCHAR2,
                                       											p_nbcurseur             OUT INTEGER,
                                       											p_message              OUT VARCHAR2
                                     );

   PROCEDURE update_cout_prestation (
   			 						 		 		   		 	   		  		p_codprest   			 IN  CHAR,
                                       											p_libprest     				IN  VARCHAR2,
                                       											p_code_domaine   IN  VARCHAR2,
									   											p_code_acha 	  	  IN  VARCHAR2,
									   											p_rtype 			      	   IN  VARCHAR2,
                                       											p_top_actif                 IN  CHAR,
																				p_flaglock                  IN  NUMBER,
                                       											p_userid                     IN  VARCHAR2,
																				p_nbcurseur             OUT INTEGER,
                                       											p_message              OUT VARCHAR2
                                    );

   PROCEDURE delete_cout_prestation (
                                     p_codprest   IN  CHAR,
                                     p_flaglock   IN  NUMBER,
                                     p_userid     IN  VARCHAR2,
                                     p_nbcurseur  OUT INTEGER,
                                     p_message    OUT VARCHAR2
                                    );

   PROCEDURE select_cout_prestation (
                                     p_codprest           IN CHAR,
                                     p_userid             IN VARCHAR2,
                                     p_curcout_prestation IN OUT cout_prestationCurType,
                                     p_nbcurseur          OUT INTEGER,
                                     p_message            OUT VARCHAR2
                                    );
   
   PROCEDURE maj_cout_prestation_logs ( p_codprest        IN PRESTATION.PRESTATION%type,
                                        p_user_log        IN VARCHAR2,
                                        p_colonne         IN VARCHAR2,
                                        p_valeur_prec     IN VARCHAR2,
                                        p_valeur_nouv     IN VARCHAR2,
                                        p_commentaire     IN VARCHAR2
                                        );


END Pack_Cout_Prestation;
/
create or replace PACKAGE BODY Pack_Cout_Prestation AS

    PROCEDURE insert_cout_prestation (
                                       				  							p_codprest   			 IN  CHAR,
                                       											p_libprest     				IN  VARCHAR2,
                                       											p_code_domaine   IN  VARCHAR2,
									   											p_code_acha 	  	  IN  VARCHAR2,
									   											p_rtype 			      	  IN  VARCHAR2,
                                       											p_top_actif                 IN  CHAR,
                                       											p_userid                     IN  VARCHAR2,
                                       											p_nbcurseur             OUT INTEGER,
                                       											p_message              OUT VARCHAR2
                                     ) IS
     l_msg VARCHAR2(1024);
     l_cod VARCHAR2(10);
     l_user VARCHAR2(30);
     l_codacha NUMBER;

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';


	  SELECT COUNT(*) INTO l_codacha
	                    FROM PRESTATION
                        WHERE UPPER(code_acha)=UPPER(p_code_acha)
						AND TOP_ACTIF='O';

		-- En cas de l'existence du code d'acha
		IF(l_codacha<>0)THEN

                    Pack_Global.recuperer_message( 21043, '%s1', p_code_acha, NULL, l_msg);
                 	RAISE_APPLICATION_ERROR( -20001, l_msg );

		END IF;

      BEGIN
         INSERT INTO PRESTATION (     PRESTATION,
         				                                                   libprest,
																		   code_domaine,
																		   code_acha,
																		   rtype,
                                    									   top_actif
                                    							   )
         VALUES (p_codprest,
         	                 p_libprest,
                             p_code_domaine,
							 p_code_acha,
							 p_rtype,
                             p_top_actif
                            );

          --'La prestation ' || p_codprest || ' de l'année '
          --|| p_anneeprest || ' a été créé.';
          -- Insertions des logs en table de PRESTATION_LOGS
          l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);
          --maj_cout_prestation_logs(p_codprest, l_user, 'prestation', '', p_codprest, 'Création de la prestation');
          --maj_cout_prestation_logs(p_codprest, l_user, 'libprest', '', p_libprest, 'Création du libelle prestation');
          maj_cout_prestation_logs(p_codprest, l_user, 'code_domaine', '', p_code_domaine, 'Création du code domaine');
          --maj_cout_prestation_logs(p_codprest, l_user, 'code_acha', '', p_code_acha, 'Création du code achat');
          maj_cout_prestation_logs(p_codprest, l_user, 'rtype', '', p_rtype, 'Création du code type ressource');
          maj_cout_prestation_logs(p_codprest, l_user, 'top_actif', '', p_top_actif, 'Création du top actif');

         Pack_Global.recuperer_message(20375, '%s1',p_codprest,NULL, l_msg);
         p_message := l_msg;

      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            Pack_Global.recuperer_message(20001, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20001, l_msg );

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );

      END;

   END insert_cout_prestation;


   PROCEDURE update_cout_prestation (
   			 						 		 		   		 	   		  		p_codprest   			 IN  CHAR,
                                       											p_libprest     				IN  VARCHAR2,
                                       											p_code_domaine   IN  VARCHAR2,
									   											p_code_acha 	  	  IN  VARCHAR2,
									   											p_rtype 			      	   IN  VARCHAR2,
                                       											p_top_actif                 IN  CHAR,
																				p_flaglock                  IN  NUMBER,
                                       											p_userid                     IN  VARCHAR2,
																				p_nbcurseur             OUT INTEGER,
                                       											p_message              OUT VARCHAR2
                                    ) IS
      l_msg VARCHAR2(1024);
      l_cod VARCHAR2(10);
      l_codacha NUMBER;
      l_user VARCHAR2(30);
      l_codprest     PRESTATION.PRESTATION%type;
      l_libprest     PRESTATION.LIBPREST%type;
      l_code_domaine   PRESTATION.CODE_DOMAINE%type;
      l_code_acha 	 PRESTATION.CODE_ACHA%type;
      l_rtype 	     PRESTATION.RTYPE%type;
      l_top_actif    PRESTATION.TOP_ACTIF%type;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

	  SELECT COUNT(*) INTO l_codacha
	                    FROM PRESTATION
                        WHERE PRESTATION<>p_codprest
						AND UPPER(code_acha)=UPPER(p_code_acha)
						AND TOP_ACTIF='O';

		-- En cas de l'existence du code d'acha
		IF(l_codacha<>0)THEN

                    Pack_Global.recuperer_message( 21043, '%s1', p_code_acha, NULL, l_msg);
                 	RAISE_APPLICATION_ERROR( -20001, l_msg );

		END IF;

      BEGIN
      
          -- Récupération des anciennes valeurs avant le update
          SELECT
              prestation,
              libprest,
              code_domaine,
              code_acha,
              rtype,
              top_actif
          INTO
              l_codprest,
              l_libprest,
              l_code_domaine,
              l_code_acha,
              l_rtype,
              l_top_actif
          FROM PRESTATION
          WHERE PRESTATION = p_codprest AND flaglock = p_flaglock;
          
            
          UPDATE PRESTATION SET libprest = p_libprest,
          			                                                  code_domaine = p_code_domaine,
																	  code_acha = p_code_acha,
																	  rtype = p_rtype,
          			                                                  top_actif=p_top_actif,
                                                                      flaglock = DECODE( p_flaglock, 1000000,0, p_flaglock + 1)
          WHERE PRESTATION = p_codprest
              AND flaglock = p_flaglock;
              
          -- Insertions des logs en table de PRESTATION_LOGS
          l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);
          --maj_cout_prestation_logs(p_codprest, l_user, 'prestation', l_codprest, p_codprest, 'Modification de la prestation');
          --maj_cout_prestation_logs(p_codprest, l_user, 'libprest', l_libprest, p_libprest, 'Modification du libelle prestation');
          maj_cout_prestation_logs(p_codprest, l_user, 'code_domaine', l_code_domaine, p_code_domaine, 'Modification du code domaine');
          --maj_cout_prestation_logs(p_codprest, l_user, 'code_acha', l_code_acha, p_code_acha, 'Modification du code achat');
          maj_cout_prestation_logs(p_codprest, l_user, 'rtype', l_rtype, p_rtype, 'Modification du code type ressource');
          maj_cout_prestation_logs(p_codprest, l_user, 'top_actif', l_top_actif, p_top_actif, 'Modification du top actif');

      EXCEPTION
          WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997,SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
      -- accès concurrent
         Pack_Global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
      -- prestation modifiée
         Pack_Global.recuperer_message(20376, '%s1', p_codprest, NULL, l_msg);
 	   p_message := l_msg;
      END IF;

   END update_cout_prestation;


   PROCEDURE delete_cout_prestation (
                                     p_codprest   IN  CHAR,
                                     p_flaglock   IN  NUMBER,
                                     p_userid     IN  VARCHAR2,
                                     p_nbcurseur  OUT INTEGER,
                                     p_message    OUT VARCHAR2
                                    ) IS

      l_msg VARCHAR2(1024);
      l_user VARCHAR2(30);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
    BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN

         DELETE FROM PRESTATION
                WHERE PRESTATION = p_codprest
                    AND flaglock = p_flaglock;
         -- Insertions des logs en table de APPLICATION_LOGS
         l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);
         maj_cout_prestation_logs(p_codprest, l_user, 'Tous', '', '', 'Suppression de la prestation');

      EXCEPTION

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            Pack_Global.recuperation_integrite(-2292);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         Pack_Global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
         Pack_Global.recuperer_message(20377, '%s1',p_codprest, NULL, l_msg);
         p_message := l_msg;
      END IF;

   END delete_cout_prestation;


   PROCEDURE select_cout_prestation (
	                                 p_codprest           IN CHAR,
                                     p_userid             IN VARCHAR2,
                                     p_curcout_prestation IN OUT cout_prestationCurType,
                                     p_nbcurseur          OUT INTEGER,
                                     p_message            OUT VARCHAR2
                                    ) IS

      l_msg VARCHAR2(1024);
      l_date_courante VARCHAR2(10);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';


      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN p_curcout_prestation FOR
              SELECT PRESTATION,
              		            libprest,
                                code_domaine,
								code_acha,
								rtype,
                                top_actif,
                                flaglock
              FROM PRESTATION
              WHERE PRESTATION = p_codprest;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20997, SQLERRM);

      END;

      -- en cas absence
      -- p_message := 'La prestation n'existe pas';

      Pack_Global.recuperer_message(2003, '%s1', p_codprest, '%s2', NULL, NULL, l_msg);
      p_message := l_msg;

   END select_cout_prestation;
   
   
   
  --Procédure pour remplir les logs de MAJ des prestations
  PROCEDURE maj_cout_prestation_logs (  p_codprest        IN PRESTATION.PRESTATION%type,
                                        p_user_log        IN VARCHAR2,
                                        p_colonne         IN VARCHAR2,
                                        p_valeur_prec     IN VARCHAR2,
                                        p_valeur_nouv     IN VARCHAR2,
                                        p_commentaire     IN VARCHAR2
                                        ) IS
  BEGIN
  
      IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
          INSERT INTO prestation_logs
              (prestation, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
          VALUES
              (p_codprest, SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);
  
      END IF;
      -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne
  
  END maj_cout_prestation_logs;
  
  
END Pack_Cout_Prestation;
/
