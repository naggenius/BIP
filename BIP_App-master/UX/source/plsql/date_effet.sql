-- Ecran Paramètres BIP Administrations/Tables/Mise à jour/Paramètres BIP
-- CMA 22/03/2011 Fiche 1087 mise en place des paramètres BIP

CREATE OR REPLACE PACKAGE     PACK_DATES_EFFET AS

   -- Définition curseur sur la table DATE_EFFET
   TYPE Dates_Effet_ViewType IS RECORD (  codaction       DATE_EFFET.CODE_ACTION%type,
                                          codversion      DATE_EFFET.CODE_VERSION%type,
                                          commentaire     DATE_EFFET.COMMENTAIRE%type,
                                          dateffet        DATE_EFFET.DATE_EFFET%type,
                                          heureffet       DATE_EFFET.HEURE_EFFET%type,
                                          datfin          DATE_EFFET.DATE_FIN%type,
                                          heurfin         DATE_EFFET.HEURE_FIN%type
                                          );

   TYPE Dates_Effet_CurType_Char IS REF CURSOR RETURN Dates_Effet_ViewType;


    PROCEDURE insert_Dates_Effet( 	p_codaction       IN DATE_EFFET.CODE_ACTION%type,
                                    p_codversion      IN DATE_EFFET.CODE_VERSION%type,
                                    p_commentaire     IN DATE_EFFET.COMMENTAIRE%type,
                                    p_dateffet        IN DATE_EFFET.DATE_EFFET%type,
                                    p_heureffet       IN DATE_EFFET.HEURE_EFFET%type,
                                    p_datfin          IN DATE_EFFET.DATE_FIN%type,
                                    p_heurfin         IN DATE_EFFET.HEURE_FIN%type,
                                    p_userid     	    IN VARCHAR2,
                                    p_nbcurseur       OUT INTEGER,
                                    p_message         OUT VARCHAR2
                                    );


	PROCEDURE update_Dates_Effet ( 	p_codaction       IN DATE_EFFET.CODE_ACTION%type,
                                  p_codversion      IN DATE_EFFET.CODE_VERSION%type,
                                  p_commentaire     IN DATE_EFFET.COMMENTAIRE%type,
                                  p_dateffet        IN DATE_EFFET.DATE_EFFET%type,
                                  p_heureffet       IN DATE_EFFET.HEURE_EFFET%type,
                                  p_datfin          IN DATE_EFFET.DATE_FIN%type,
                                  p_heurfin         IN DATE_EFFET.HEURE_FIN%type,
                                  p_userid     	    IN VARCHAR2,
                                  p_nbcurseur       OUT INTEGER,
                                  p_message         OUT VARCHAR2
                                  );



	PROCEDURE delete_Dates_Effet (  p_codaction       IN DATE_EFFET.CODE_ACTION%type,
                                  p_codversion      IN DATE_EFFET.CODE_VERSION%type,
                                  p_userid          IN  VARCHAR2,
                                  p_nbcurseur       OUT INTEGER,
                                  p_message         OUT VARCHAR2
                                  );

	 PROCEDURE select_Dates_Effet(  p_codaction       DATE_EFFET.CODE_ACTION%type,
                                  p_codversion      DATE_EFFET.CODE_VERSION%type,
                                  p_userid     	    IN  VARCHAR2,
                                  p_curDatesEffet   IN OUT Dates_Effet_CurType_Char ,
                                  p_nbcurseur       OUT INTEGER,
                                  p_message         OUT VARCHAR2
                                  ) ;
                                  

END PACK_DATES_EFFET;
/


CREATE OR REPLACE PACKAGE BODY     PACK_DATES_EFFET AS



  PROCEDURE insert_Dates_Effet( 	p_codaction       DATE_EFFET.CODE_ACTION%type,
                                  p_codversion      DATE_EFFET.CODE_VERSION%type,
                                  p_commentaire     DATE_EFFET.COMMENTAIRE%type,
                                  p_dateffet        DATE_EFFET.DATE_EFFET%type,
                                  p_heureffet       DATE_EFFET.HEURE_EFFET%type,
                                  p_datfin          DATE_EFFET.DATE_FIN%type,
                                  p_heurfin         DATE_EFFET.HEURE_FIN%type,
                                  p_userid     	    IN VARCHAR2,
                                  p_nbcurseur       OUT INTEGER,
                                  p_message         OUT VARCHAR2
                                ) IS
  l_msg VARCHAR2(1024);
  l_count NUMBER;
  l_user		PARAM_BIP_LOGS.user_log%TYPE;

  BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);


      SELECT COUNT(*)  INTO l_count  FROM DATE_EFFET  WHERE code_action = p_codaction  AND code_version =  p_codversion;

      IF(l_count <> 0)THEN

            Pack_Global.recuperer_message(21176, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20958, l_msg );

      ELSE



      BEGIN
             INSERT INTO DATE_EFFET ( code_action,
                                      code_version,
                                      commentaire,
                                      date_effet,
                                      heure_effet,
                                      date_fin,
                                      heure_fin)
                   VALUES ( UPPER(p_codaction),
                            UPPER(p_codversion),
                            p_commentaire,
                            p_dateffet,
                            p_heureffet,
                            p_datfin,
                            p_heurfin);
        COMMIT;

        Pack_Global.recuperer_message( 21177, NULL, NULL, NULL, l_msg);
        p_message := l_msg;
        
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_codaction),UPPER(p_codversion),0,l_user,'Code action','',UPPER(p_codaction),'Création de nouveau paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_codaction),UPPER(p_codversion),0,l_user,'Code version','',UPPER(p_codversion),'Création de nouveau paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_codaction),UPPER(p_codversion),0,l_user,'Date et heure d''effet','',TO_CHAR(p_dateffet,'DD/MM/YYYY')||' '||p_heureffet,'Création de nouveau paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_codaction),UPPER(p_codversion),0,l_user,'Date et heure de fin','',TO_CHAR(p_datfin,'DD/MM/YYYY')||' '||p_heurfin,'Création de nouveau paramètre BIP');

         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               Pack_Global.recuperer_message( 21178, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20001, l_msg );

         END;

	 END IF;

  END insert_Dates_Effet;





	PROCEDURE update_Dates_Effet ( 	p_codaction       DATE_EFFET.CODE_ACTION%type,
                                  p_codversion      DATE_EFFET.CODE_VERSION%type,
                                  p_commentaire    DATE_EFFET.COMMENTAIRE%type,
                                  p_dateffet        DATE_EFFET.DATE_EFFET%type,
                                  p_heureffet       DATE_EFFET.HEURE_EFFET%type,
                                  p_datfin          DATE_EFFET.DATE_FIN%type,
                                  p_heurfin         DATE_EFFET.HEURE_FIN%type,
                                  p_userid     	    IN VARCHAR2,
                                  p_nbcurseur       OUT INTEGER,
                                  p_message         OUT VARCHAR2
                              	) IS

  l_msg VARCHAR2(1024);
  l_count NUMBER;
  l_user		PARAM_BIP_LOGS.user_log%TYPE;
  l_prev_dateffet VARCHAR2(30);
  l_prev_datfin VARCHAR2(30);

  BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);


      BEGIN
      
      SELECT TO_CHAR(date_effet,'DD/MM/YYYY')||' '||heure_effet,
             TO_CHAR(date_fin,'DD/MM/YYYY')||' '||heure_fin
             INTO l_prev_dateffet, l_prev_datfin
             FROM DATE_EFFET
             WHERE code_action = p_codaction  AND code_version =  p_codversion;

            UPDATE DATE_EFFET
            SET	 --code_action = p_codaction,
                 --code_version = p_codversion,
                 commentaire = p_commentaire,
                 date_effet = p_dateffet,
                 heure_effet = p_heureffet,
                 date_fin = p_datfin,
                 heure_fin = p_heurfin
            WHERE code_action = p_codaction  AND code_version =  p_codversion;
            
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_codaction),UPPER(p_codversion),0,l_user,'Date et heure d''effet',l_prev_dateffet,TO_CHAR(p_dateffet,'DD/MM/YYYY')||' '||p_heureffet,'Modification d''un paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_codaction),UPPER(p_codversion),0,l_user,'Date et heure de fin',l_prev_datfin,TO_CHAR(p_datfin,'DD/MM/YYYY')||' '||p_heurfin,'Modification d''un paramètre BIP');

      EXCEPTION

      WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -21181, l_msg );
      END;


          IF SQL%NOTFOUND THEN

          -- 'Accès concurrent'

             Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20999, l_msg );

          ELSE


         -- 'La date effet a été modifiée'

               Pack_Global.recuperer_message( 21182, NULL, NULL, NULL, l_msg);
               p_message := l_msg;
          END IF;


  END update_Dates_Effet;



	PROCEDURE delete_Dates_Effet (  p_codaction       DATE_EFFET.CODE_ACTION%type,
                                  p_codversion      DATE_EFFET.CODE_VERSION%type,
                                  p_userid          IN  VARCHAR2,
                                  p_nbcurseur       OUT INTEGER,
                                  p_message         OUT VARCHAR2
                         			) IS

    l_msg VARCHAR2(1024);
    referential_integrity EXCEPTION;
	  l_count NUMBER;
    PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
    l_user		PARAM_BIP_LOGS.user_log%TYPE;

    BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);


     BEGIN
     
       -- Suppresion des lignes paramètres BIP liées
       PACK_PARAM_BIP.delete_lignes_param_bip(UPPER(p_codaction),UPPER(p_codversion),p_userid);
         
	   DELETE FROM DATE_EFFET WHERE code_action = p_codaction  AND code_version =  p_codversion;

     EXCEPTION
		 WHEN referential_integrity THEN
		         Pack_Global.recuperer_message( 21179, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20954, l_msg );

		 WHEN OTHERS THEN
				    RAISE_APPLICATION_ERROR( -21179, SQLERRM);
		 END;

     IF SQL%NOTFOUND THEN

	   -- 'Accès concurrent'
	    Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
      RAISE_APPLICATION_ERROR( -20999, l_msg );

      ELSE

	   -- ' la date effet a été supprimé'

         PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_codaction),UPPER(p_codversion),0,l_user,'Code action',p_codaction,'','Suppression du paramètre BIP');
	     Pack_Global.recuperer_message( 21180, NULL, NULL, NULL, l_msg);
	     p_message := l_msg;

         
      END IF;


  END delete_Dates_Effet;



  PROCEDURE select_Dates_Effet (  p_codaction       DATE_EFFET.CODE_ACTION%type,
                                  p_codversion      DATE_EFFET.CODE_VERSION%type,
                                  p_userid     	    IN  VARCHAR2,
                                  p_curDatesEffet   IN OUT Dates_Effet_CurType_Char ,
                                  p_nbcurseur       OUT INTEGER,
                                  p_message         OUT VARCHAR2
                              ) IS
l_msg VARCHAR2(1024);

   BEGIN

        -- Positionner le nb de curseurs ==> 0
        -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         OPEN  p_curDatesEffet FOR
              SELECT 	code_action,
                      code_version,
                      commentaire,
                      to_char(date_effet,'dd/mm/yyyy'),
                      heure_effet,
                      to_char(date_fin,'dd/mm/yyyy'),
                      heure_fin
              FROM  DATE_EFFET
              WHERE code_action = p_codaction  AND code_version =  p_codversion;


          Pack_Global.recuperer_message( 21183, NULL, NULL, NULL, l_msg);
          p_message := l_msg;

      EXCEPTION

        WHEN OTHERS THEN

		  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
  END;



  END select_Dates_Effet;

END PACK_DATES_EFFET;
/


