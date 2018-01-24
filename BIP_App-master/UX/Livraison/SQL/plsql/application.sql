-- pack_application PL/SQL

--
-- EQUIPE SOPRA
--
-- cree le 10/02/1999
-- Le 03/07/2007 par BPO : Fiche TD 532 : Ajout des CA préconisés
-- Le 17/07/2007 par BPO : Fiche TD 532 : Ajout du type d'activité lié au CA préconisé
-- Le 01/10/2008 par ABA : Fiche TD 665 : prise en compte du npsi
-- le 06/03/2009 par ABA TD 755


-- Attention le nom du package ne peut etre le nom

-- de la table...


CREATE OR REPLACE PACKAGE     pack_application AS

TYPE application_ViewType IS RECORD (airt      application.airt%TYPE,
                                         amop      application.amop%TYPE,
                                      amnemo    application.amnemo%TYPE,
                                      agappli   application.agappli%TYPE,
                                      acme      application.acme%TYPE,
                                      alibel    application.alibel%TYPE,
                                      flaglock  application.flaglock%TYPE,
                                      clicode   application.clicode%TYPE,
                                       codsg     application.codsg%TYPE,
                                      codgappli application.codgappli%TYPE,
                                      acdareg   application.acdareg%TYPE,
                                       alibcourt application.alibcourt%TYPE, -- TD 532
                                     alibme    application.alibme%TYPE, -- TD 532
                                     alibmo    application.alibmo%TYPE, -- TD 532
                                     alibgappli application.alibgappli%TYPE, -- TD 532
                                      datfinapp application.datfinapp%TYPE, -- TD 532
                                        licodapca application.licodapca%TYPE, -- TD 532
                                        codcamo1  application.codcamo1%TYPE, -- TD 532
                                     clibca1   application.clibca1%TYPE, -- TD 532
                                     cdfain1   application.cdfain1%TYPE, -- TD 532
                                     datvalli1 application.datvalli1%TYPE, -- TD 532
                                        respval1  application.respval1%TYPE, -- TD 532
                                        codcamo2  application.codcamo2%TYPE, -- TD 532
                                     clibca2   application.clibca2%TYPE, -- TD 532
                                     cdfain2   application.cdfain2%TYPE, -- TD 532
                                     datvalli2 application.datvalli2%TYPE, -- TD 532
                                        respval2  application.respval2%TYPE, -- TD 532
                                        codcamo3  application.codcamo3%TYPE, -- TD 532
                                     clibca3   application.clibca3%TYPE, -- TD 532
                                     cdfain3   application.cdfain3%TYPE, -- TD 532
                                     datvalli3 application.datvalli3%TYPE, -- TD 532
                                     respval3  application.respval3%TYPE, -- TD 532
                                        codcamo4  application.codcamo4%TYPE, -- TD 532
                                     clibca4   application.clibca4%TYPE, -- TD 532
                                     cdfain4   application.cdfain4%TYPE, -- TD 532
                                     datvalli4 application.datvalli4%TYPE, -- TD 532
                                     respval4  application.respval4%TYPE, -- TD 532
                                        codcamo5  application.codcamo5%TYPE, -- TD 532
                                     clibca5   application.clibca5%TYPE, -- TD 532
                                     cdfain5   application.cdfain5%TYPE, -- TD 532
                                     datvalli5 application.datvalli5%TYPE, -- TD 532
                                     respval5  application.respval5%TYPE, -- TD 532
                                        codcamo6  application.codcamo6%TYPE, -- TD 532
                                     clibca6   application.clibca6%TYPE, -- TD 532
                                     cdfain6   application.cdfain6%TYPE, -- TD 532
                                     datvalli6 application.datvalli6%TYPE, -- TD 532
                                     respval6  application.respval6%TYPE, -- TD 532
                                         codcamo7  application.codcamo7%TYPE, -- TD 532
                                     clibca7   application.clibca7%TYPE, -- TD 532
                                     cdfain7   application.cdfain7%TYPE, -- TD 532
                                     datvalli7 application.datvalli7%TYPE, -- TD 532
                                     respval7  application.respval7%TYPE, -- TD 532
                                        codcamo8  application.codcamo8%TYPE, -- TD 532
                                     clibca8   application.clibca8%TYPE, -- TD 532
                                     cdfain8   application.cdfain8%TYPE, -- TD 532
                                     datvalli8 application.datvalli8%TYPE, -- TD 532
                                        respval8  application.respval8%TYPE, -- TD 532
                                        codcamo9  application.codcamo9%TYPE, -- TD 532
                                     clibca9   application.clibca9%TYPE, -- TD 532
                                     cdfain9   application.cdfain9%TYPE, -- TD 532
                                     datvalli9 application.datvalli9%TYPE, -- TD 532
                                        respval9  application.respval9%TYPE, -- TD 532
                                        codcamo10 application.codcamo10%TYPE, -- TD 532
                                     clibca10  application.clibca10%TYPE, -- TD 532
                                     cdfain10  application.cdfain10%TYPE, -- TD 532
                                     datvalli10 application.datvalli10%TYPE, -- TD 532
                                        respval10 application.respval10%TYPE, -- TD 532
                                     typactca1 application.typactca1%TYPE, -- TD 532
                                     typactca2 application.typactca2%TYPE, -- TD 532
                                     typactca3 application.typactca3%TYPE, -- TD 532
                                     typactca4 application.typactca4%TYPE, -- TD 532
                                     typactca5 application.typactca5%TYPE, -- TD 532
                                     typactca6 application.typactca6%TYPE, -- TD 532
                                     typactca7 application.typactca7%TYPE, -- TD 532
                                     typactca8 application.typactca8%TYPE, -- TD 532
                                     typactca9 application.typactca9%TYPE, -- TD 532
                                     typactca10 application.typactca10%TYPE, -- TD 532
                                     bloc       application.bloc%TYPE,
                                     lib_bloc   VARCHAR2(110),
                                     adescr VARCHAR2(420)
                                     );

TYPE applicationCurType IS REF CURSOR RETURN application_ViewType;

/*
   TYPE applicationCurType IS REF CURSOR RETURN application%ROWTYPE;
*/


   PROCEDURE insert_application (p_airt      IN  application.airt%TYPE,
                                 p_alibel    IN  application.alibel%TYPE,
                                 p_alibcourt IN  application.alibcourt%TYPE,
                                 p_clicode   IN  application.clicode%TYPE,
                                 p_amop      IN  application.amop%TYPE,
                                 p_codsg     IN  VARCHAR2,
                                 p_acme      IN  application.acme%TYPE,
                                 p_codgappli IN  application.codgappli%TYPE,
                                 p_agappli   IN  application.agappli%TYPE,
                                 p_amnemo    IN  application.amnemo%TYPE,
                                 p_acdareg   IN  application.acdareg%TYPE,
                                 p_userid    IN  VARCHAR2,
                                  p_datfinapp IN  VARCHAR2, -- TD 532
                                   p_licodapca IN  VARCHAR2, -- TD 532
                                   p_codcamo1  IN  VARCHAR2, -- TD 532
                                   p_respval1  IN  VARCHAR2, -- TD 532
                                   p_codcamo2  IN  VARCHAR2, -- TD 532
                                   p_respval2  IN  VARCHAR2, -- TD 532
                                   p_codcamo3  IN  VARCHAR2, -- TD 532
                                   p_respval3  IN  VARCHAR2, -- TD 532
                                   p_codcamo4  IN  VARCHAR2, -- TD 532
                                   p_respval4  IN  VARCHAR2, -- TD 532
                                   p_codcamo5  IN  VARCHAR2, -- TD 532
                                   p_respval5  IN  VARCHAR2, -- TD 532
                                   p_codcamo6  IN  VARCHAR2, -- TD 532
                                   p_respval6  IN  VARCHAR2, -- TD 532
                                    p_codcamo7  IN  VARCHAR2, -- TD 532
                                   p_respval7  IN  VARCHAR2, -- TD 532
                                   p_codcamo8  IN  VARCHAR2, -- TD 532
                                   p_respval8  IN  VARCHAR2, -- TD 532
                                   p_codcamo9  IN  VARCHAR2, -- TD 532
                                   p_respval9  IN  VARCHAR2, -- TD 532
                                   p_codcamo10 IN  VARCHAR2, -- TD 532
                                   p_respval10 IN  VARCHAR2, -- TD 532
                                 p_typactca1 IN  VARCHAR2, -- TD 532
                                 p_typactca2 IN  VARCHAR2, -- TD 532
                                 p_typactca3 IN  VARCHAR2, -- TD 532
                                 p_typactca4 IN  VARCHAR2, -- TD 532
                                 p_typactca5 IN  VARCHAR2, -- TD 532
                                 p_typactca6 IN  VARCHAR2, -- TD 532
                                 p_typactca7 IN  VARCHAR2, -- TD 532
                                 p_typactca8 IN  VARCHAR2, -- TD 532
                                 p_typactca9 IN  VARCHAR2, -- TD 532
                                 p_typactca10 IN  VARCHAR2, -- TD 532
                                 p_bloc       IN VARCHAR2,
                                 p_adescr     IN VARCHAR2,--TD755 
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                );



   PROCEDURE update_application (p_airt      IN  application.airt%TYPE,
                                 p_alibel    IN  application.alibel%TYPE,
                                 p_alibcourt IN  application.alibcourt%TYPE,
                                 p_clicode   IN  application.clicode%TYPE,
                                 p_amop      IN  application.amop%TYPE,
                                 p_codsg     IN  VARCHAR2,
                                 p_acme      IN  application.acme%TYPE,
                                 p_codgappli IN  application.codgappli%TYPE,
                                 p_agappli   IN  application.agappli%TYPE,
                                 p_amnemo    IN  application.amnemo%TYPE,
                                 p_acdareg   IN  application.acdareg%TYPE,
                                 p_flaglock  IN  NUMBER,
                                 p_userid    IN  VARCHAR2,
                                 p_datfinapp IN  VARCHAR2, -- TD 532
                                   p_licodapca IN  VARCHAR2, -- TD 532
                                   p_codcamo1  IN  VARCHAR2, -- TD 532
                                   p_respval1  IN  VARCHAR2, -- TD 532
                                   p_codcamo2  IN  VARCHAR2, -- TD 532
                                   p_respval2  IN  VARCHAR2, -- TD 532
                                   p_codcamo3  IN  VARCHAR2, -- TD 532
                                   p_respval3  IN  VARCHAR2, -- TD 532
                                   p_codcamo4  IN  VARCHAR2, -- TD 532
                                   p_respval4  IN  VARCHAR2, -- TD 532
                                   p_codcamo5  IN  VARCHAR2, -- TD 532
                                   p_respval5  IN  VARCHAR2, -- TD 532
                                   p_codcamo6  IN  VARCHAR2, -- TD 532
                                   p_respval6  IN  VARCHAR2, -- TD 532
                                    p_codcamo7  IN  VARCHAR2, -- TD 532
                                   p_respval7  IN  VARCHAR2, -- TD 532
                                   p_codcamo8  IN  VARCHAR2, -- TD 532
                                   p_respval8  IN  VARCHAR2, -- TD 532
                                   p_codcamo9  IN  VARCHAR2, -- TD 532
                                   p_respval9  IN  VARCHAR2, -- TD 532
                                   p_codcamo10 IN  VARCHAR2, -- TD 532
                                   p_respval10 IN  VARCHAR2, -- TD 532
                                 p_typactca1 IN  VARCHAR2, -- TD 532
                                 p_typactca2 IN  VARCHAR2, -- TD 532
                                 p_typactca3 IN  VARCHAR2, -- TD 532
                                 p_typactca4 IN  VARCHAR2, -- TD 532
                                 p_typactca5 IN  VARCHAR2, -- TD 532
                                 p_typactca6 IN  VARCHAR2, -- TD 532
                                 p_typactca7 IN  VARCHAR2, -- TD 532
                                 p_typactca8 IN  VARCHAR2, -- TD 532
                                 p_typactca9 IN  VARCHAR2, -- TD 532
                                 p_typactca10 IN  VARCHAR2, -- TD 532
                                 p_bloc       IN VARCHAR2,
                                 p_adescr     IN VARCHAR2,--TD755 
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                );



   PROCEDURE delete_application (p_airt      IN  application.airt%TYPE,
                                 p_flaglock  IN  NUMBER,
                                 p_userid    IN  VARCHAR2,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                );



   PROCEDURE select_application (p_airt           IN application.airt%TYPE,
                                 p_userid         IN VARCHAR2,
                                 p_curapplication IN OUT applicationCurType,
                                 p_nbcurseur         OUT INTEGER,
                                 p_message           OUT VARCHAR2
                                );

PROCEDURE maj_application_logs (p_airt            IN application_logs.airt%TYPE,
                                     p_user_log      IN VARCHAR2,
                                p_colonne        IN VARCHAR2,
                                p_valeur_prec    IN VARCHAR2,
                                p_valeur_nouv    IN VARCHAR2,
                                p_commentaire    IN VARCHAR2
                                );

PROCEDURE init_donnees_ca (p_codcamo    IN OUT application.codcamo1%TYPE,
                           p_clibca        IN OUT application.clibca1%TYPE,
                           p_cdfain        IN OUT application.cdfain1%TYPE,
                           p_datvalli    IN OUT application.datvalli1%TYPE
                          );

PROCEDURE maj_donnees_ca (p_old_codcamo        IN application.codcamo1%TYPE,
                          p_old_clibca        IN application.clibca1%TYPE,
                          p_old_cdfain        IN application.cdfain1%TYPE,
                          p_old_datvalli    IN application.datvalli1%TYPE,
                          p_old_respval        IN application.respval1%TYPE,
                          p_codcamo         IN OUT application.codcamo1%TYPE,
                          p_clibca            IN OUT application.clibca1%TYPE,
                          p_cdfain            IN OUT application.cdfain1%TYPE,
                          p_datvalli        IN OUT application.datvalli1%TYPE,
                          p_respval            IN OUT application.respval1%TYPE
                          );

END pack_application;
/


CREATE OR REPLACE PACKAGE BODY     pack_application AS



   PROCEDURE insert_application (p_airt      IN  application.airt%TYPE,
                                 p_alibel    IN  application.alibel%TYPE,
                                 p_alibcourt IN  application.alibcourt%TYPE,
                                 p_clicode   IN  application.clicode%TYPE,
                                 p_amop      IN  application.amop%TYPE,
                                 p_codsg     IN  VARCHAR2,
                                 p_acme      IN  application.acme%TYPE,
                                 p_codgappli IN  application.codgappli%TYPE,
                                 p_agappli   IN  application.agappli%TYPE,
                                 p_amnemo    IN  application.amnemo%TYPE,
                                 p_acdareg   IN  application.acdareg%TYPE,
                                 p_userid    IN  VARCHAR2,
                                  p_datfinapp IN  VARCHAR2, -- TD 532
                                   p_licodapca IN  VARCHAR2, -- TD 532
                                   p_codcamo1  IN  VARCHAR2, -- TD 532
                                   p_respval1  IN  VARCHAR2, -- TD 532
                                   p_codcamo2  IN  VARCHAR2, -- TD 532
                                   p_respval2  IN  VARCHAR2, -- TD 532
                                   p_codcamo3  IN  VARCHAR2, -- TD 532
                                   p_respval3  IN  VARCHAR2, -- TD 532
                                   p_codcamo4  IN  VARCHAR2, -- TD 532
                                   p_respval4  IN  VARCHAR2, -- TD 532
                                   p_codcamo5  IN  VARCHAR2, -- TD 532
                                   p_respval5  IN  VARCHAR2, -- TD 532
                                   p_codcamo6  IN  VARCHAR2, -- TD 532
                                   p_respval6  IN  VARCHAR2, -- TD 532
                                    p_codcamo7  IN  VARCHAR2, -- TD 532
                                   p_respval7  IN  VARCHAR2, -- TD 532
                                   p_codcamo8  IN  VARCHAR2, -- TD 532
                                   p_respval8  IN  VARCHAR2, -- TD 532
                                   p_codcamo9  IN  VARCHAR2, -- TD 532
                                   p_respval9  IN  VARCHAR2, -- TD 532
                                   p_codcamo10 IN  VARCHAR2, -- TD 532
                                   p_respval10 IN  VARCHAR2, -- TD 532
                                 p_typactca1 IN  VARCHAR2, -- TD 532
                                 p_typactca2 IN  VARCHAR2, -- TD 532
                                 p_typactca3 IN  VARCHAR2, -- TD 532
                                 p_typactca4 IN  VARCHAR2, -- TD 532
                                 p_typactca5 IN  VARCHAR2, -- TD 532
                                 p_typactca6 IN  VARCHAR2, -- TD 532
                                 p_typactca7 IN  VARCHAR2, -- TD 532
                                 p_typactca8 IN  VARCHAR2, -- TD 532
                                 p_typactca9 IN  VARCHAR2, -- TD 532
                                 p_typactca10 IN  VARCHAR2, -- TD 532
                                 p_bloc       IN  VARCHAR2,
                                 p_adescr     IN VARCHAR2,--TD755 
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                ) IS

      l_msg VARCHAR2(1024);

      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

      l_user VARCHAR2(30);
      l_alibme    application.alibme%TYPE; -- TD 532
      l_alibmo    application.alibmo%TYPE; -- TD 532
      l_alibgappli application.alibgappli%TYPE; -- TD 532

      l_codcamo1 application.codcamo1%TYPE; -- TD 532
      l_respval1 application.respval1%TYPE; -- TD 532
      l_codcamo2 application.codcamo1%TYPE; -- TD 532
      l_respval2 application.respval1%TYPE; -- TD 532
      l_codcamo3 application.codcamo1%TYPE; -- TD 532
      l_respval3 application.respval1%TYPE; -- TD 532
      l_codcamo4 application.codcamo1%TYPE; -- TD 532
      l_respval4 application.respval1%TYPE; -- TD 532
      l_codcamo5 application.codcamo1%TYPE; -- TD 532
      l_respval5 application.respval1%TYPE; -- TD 532
      l_codcamo6 application.codcamo1%TYPE; -- TD 532
      l_respval6 application.respval1%TYPE; -- TD 532
      l_codcamo7 application.codcamo1%TYPE; -- TD 532
      l_respval7 application.respval1%TYPE; -- TD 532
      l_codcamo8 application.codcamo1%TYPE; -- TD 532
      l_respval8 application.respval1%TYPE; -- TD 532
      l_codcamo9 application.codcamo1%TYPE; -- TD 532
      l_respval9 application.respval1%TYPE; -- TD 532
      l_codcamo10 application.codcamo1%TYPE; -- TD 532
      l_respval10 application.respval1%TYPE; -- TD 532

      l_clibca1    application.clibca1%TYPE; -- TD 532
      l_cdfain1    application.cdfain1%TYPE; -- TD 532
      l_datvalli1 application.datvalli1%TYPE; -- TD 532
      l_clibca2    application.clibca2%TYPE; -- TD 532
      l_cdfain2    application.cdfain2%TYPE; -- TD 532
      l_datvalli2 application.datvalli2%TYPE; -- TD 532
      l_clibca3    application.clibca3%TYPE; -- TD 532
      l_cdfain3    application.cdfain3%TYPE; -- TD 532
      l_datvalli3 application.datvalli3%TYPE; -- TD 532
      l_clibca4    application.clibca4%TYPE; -- TD 532
      l_cdfain4    application.cdfain4%TYPE; -- TD 532
      l_datvalli4 application.datvalli4%TYPE; -- TD 532
      l_clibca5    application.clibca5%TYPE; -- TD 532
      l_cdfain5    application.cdfain5%TYPE; -- TD 532
      l_datvalli5 application.datvalli5%TYPE; -- TD 532
      l_clibca6    application.clibca6%TYPE; -- TD 532
      l_cdfain6    application.cdfain6%TYPE; -- TD 532
      l_datvalli6 application.datvalli6%TYPE; -- TD 532
      l_clibca7    application.clibca7%TYPE; -- TD 532
      l_cdfain7    application.cdfain7%TYPE; -- TD 532
      l_datvalli7 application.datvalli7%TYPE; -- TD 532
      l_clibca8    application.clibca8%TYPE; -- TD 532
      l_cdfain8    application.cdfain8%TYPE; -- TD 532
      l_datvalli8 application.datvalli8%TYPE; -- TD 532
      l_clibca9    application.clibca9%TYPE; -- TD 532
      l_cdfain9    application.cdfain9%TYPE; -- TD 532
      l_datvalli9 application.datvalli9%TYPE; -- TD 532
      l_clibca10    application.clibca10%TYPE; -- TD 532
      l_cdfain10    application.cdfain10%TYPE; -- TD 532
      l_datvalli10 application.datvalli10%TYPE; -- TD 532


   BEGIN


      -- Positionner le nb de curseurs ==> 0

      -- Initialiser le message retour


      p_nbcurseur := 0;

      p_message := '';

      -- TD 532 : Initialisation des données des CA renseignées

    l_codcamo1 := p_codcamo1;
    l_respval1 := p_respval1;
    l_codcamo2 := p_codcamo2;
    l_respval2 := p_respval2;
    l_codcamo3 := p_codcamo3;
    l_respval3 := p_respval3;
    l_codcamo4 := p_codcamo4;
    l_respval4 := p_respval4;
    l_codcamo5 := p_codcamo5;
    l_respval5 := p_respval5;
    l_codcamo6 := p_codcamo6;
    l_respval6 := p_respval6;
    l_codcamo7 := p_codcamo7;
    l_respval7 := p_respval7;
    l_codcamo8 := p_codcamo8;
    l_respval8 := p_respval8;
    l_codcamo9 := p_codcamo9;
    l_respval9 := p_respval9;
    l_codcamo10 := p_codcamo10;
    l_respval10 := p_respval10;


      init_donnees_ca(l_codcamo1, l_clibca1, l_cdfain1, l_datvalli1);
      init_donnees_ca(l_codcamo2, l_clibca2, l_cdfain2, l_datvalli2);
      init_donnees_ca(l_codcamo3, l_clibca3, l_cdfain3, l_datvalli3);
      init_donnees_ca(l_codcamo4, l_clibca4, l_cdfain4, l_datvalli4);
      init_donnees_ca(l_codcamo5, l_clibca5, l_cdfain5, l_datvalli5);
      init_donnees_ca(l_codcamo6, l_clibca6, l_cdfain6, l_datvalli6);
      init_donnees_ca(l_codcamo7, l_clibca7, l_cdfain7, l_datvalli7);
      init_donnees_ca(l_codcamo8, l_clibca8, l_cdfain8, l_datvalli8);
      init_donnees_ca(l_codcamo9, l_clibca9, l_cdfain9, l_datvalli9);
      init_donnees_ca(l_codcamo10, l_clibca10, l_cdfain10, l_datvalli10);

      -- Récupération des valeurs : alibme,  alibmo,  alibgappli

      BEGIN
               IF (p_codsg IS NOT NULL)
             THEN
                    SELECT DISTINCT si.libdsg
                   INTO l_alibme
                   FROM application a, struct_info si
                   WHERE a.codsg = si.codsg
                   AND a.codsg = TO_NUMBER(p_codsg);
             ELSE
                    l_alibme := '';
             END IF;

              EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                         pack_global.recuperer_message( 4, '%s1', p_clicode, NULL, p_message);
                         WHEN OTHERS THEN
                         raise_application_error( -20997, SQLERRM);
      END;

        BEGIN
             IF (p_clicode IS NOT NULL)
             THEN
                   SELECT DISTINCT cmo.clilib
                  INTO l_alibmo
                  FROM application a, client_mo cmo
                  WHERE a.clicode = cmo.clicode
                  AND a.clicode = p_clicode;
             ELSE
              l_alibmo := '';
             END IF;

              EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                         pack_global.recuperer_message( 4, '%s1', p_clicode, NULL, p_message);
                         WHEN OTHERS THEN
                         raise_application_error( -20997, SQLERRM);
      END;

      BEGIN
             IF (p_codgappli IS NOT NULL)
             THEN
                    SELECT DISTINCT cmo.clilib
                   INTO l_alibgappli
                   FROM application a, client_mo cmo
                   WHERE a.codgappli = cmo.clicode
                   AND a.codgappli = p_codgappli;
             ELSE
             l_alibgappli := '';
             END IF;

           EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                         pack_global.recuperer_message( 4, '%s1', p_codgappli, NULL, p_message);
                         WHEN OTHERS THEN
                         raise_application_error( -20997, SQLERRM);
      END;

      -- INSERT
      BEGIN
         INSERT INTO application (acme,
                  amnemo,
                                  
                                  agappli,
                                  airt,
                                  alibel,
                                  amop,
                                  clicode,
                                  codgappli,
                                  codsg,
                                  alibcourt,
                                  acdareg,
                                  alibme, -- TD 532
                                  alibmo, -- TD 532
                                  alibgappli, -- TD 532
                                  datfinapp, -- TD 532
                                  licodapca, -- TD 532
                                  codcamo1, -- TD 532
                                  clibca1, -- TD 532
                                  cdfain1, -- TD 532
                                  datvalli1, -- TD 532
                                  respval1, -- TD 532
                                  codcamo2, -- TD 532
                                  clibca2,-- TD 532
                                  cdfain2, -- TD 532
                                  datvalli2, -- TD 532
                                  respval2, -- TD 532
                                  codcamo3, -- TD 532
                                  clibca3, -- TD 532
                                  cdfain3, -- TD 532
                                  datvalli3, -- TD 532
                                  respval3, -- TD 532
                                  codcamo4, -- TD 532
                                  clibca4, -- TD 532
                                  cdfain4, -- TD 532
                                  datvalli4, -- TD 532
                                  respval4, -- TD 532
                                  codcamo5, -- TD 532
                                  clibca5, -- TD 532
                                  cdfain5, -- TD 532
                                  datvalli5, -- TD 532
                                  respval5, -- TD 532
                                  codcamo6, -- TD 532
                                  clibca6, -- TD 532
                                  cdfain6, -- TD 532
                                  datvalli6, -- TD 532
                                  respval6, -- TD 532
                                  codcamo7, -- TD 532
                                  clibca7, -- TD 532
                                  cdfain7, -- TD 532
                                  datvalli7, -- TD 532
                                  respval7, -- TD 532
                                  codcamo8, -- TD 532
                                  clibca8, -- TD 532
                                  cdfain8, -- TD 532
                                  datvalli8, -- TD 532
                                  respval8, -- TD 532
                                  codcamo9, -- TD 532
                                  clibca9, -- TD 532
                                  cdfain9, -- TD 532
                                  datvalli9, -- TD 532
                                  respval9, -- TD 532
                                  codcamo10, -- TD 532
                                  clibca10, -- TD 532
                                  cdfain10, -- TD 532
                                  datvalli10, -- TD 532
                                  respval10, -- TD 532
                                  typactca1, -- TD 532
                                  typactca2, -- TD 532
                                  typactca3, -- TD 532
                                  typactca4, -- TD 532
                                  typactca5, -- TD 532
                                  typactca6, -- TD 532
                                  typactca7, -- TD 532
                                  typactca8, -- TD 532
                                  typactca9, -- TD 532
                                  typactca10, -- TD 532
                                    bloc,
                                    adescr     --TD755 
                                  )
                VALUES (p_acme,
                        p_amnemo,
                        p_agappli,
                        p_airt,
                        p_alibel,
                        p_amop,
                        p_clicode,
                        p_codgappli,
                        TO_NUMBER(p_codsg),
                        p_alibcourt,
                        p_acdareg,
                        l_alibme, -- TD 532
                        l_alibmo, -- TD 532
                        l_alibgappli, -- TD 532
                        TO_DATE(p_datfinapp, 'DD/MM/YYYY'), -- TD 532
                        p_licodapca, -- TD 532
                        TO_NUMBER(p_codcamo1), -- TD 532
                        l_clibca1, -- TD 532
                        TO_NUMBER(l_cdfain1), -- TD 532
                        TO_DATE(l_datvalli1), -- TD 532
                        p_respval1, -- TD 532
                        TO_NUMBER(p_codcamo2), -- TD 532
                        l_clibca2, -- TD 532
                        TO_NUMBER(l_cdfain2), -- TD 532
                        TO_DATE(l_datvalli2), -- TD 532
                        p_respval2, -- TD 532
                        TO_NUMBER(p_codcamo3), -- TD 532
                        l_clibca3, -- TD 532
                        TO_NUMBER(l_cdfain3), -- TD 532
                        TO_DATE(l_datvalli3), -- TD 532
                        p_respval3, -- TD 532
                        TO_NUMBER(p_codcamo4), -- TD 532
                        l_clibca4, -- TD 532
                        TO_NUMBER(l_cdfain4), -- TD 532
                        TO_DATE(l_datvalli4), -- TD 532
                        p_respval4, -- TD 532
                        TO_NUMBER(p_codcamo5), -- TD 532
                        l_clibca5, -- TD 532
                        TO_NUMBER(l_cdfain5), -- TD 532
                        TO_DATE(l_datvalli5), -- TD 532
                        p_respval5,    -- TD 532
                        TO_NUMBER(p_codcamo6), -- TD 532
                        l_clibca6, -- TD 532
                        TO_NUMBER(l_cdfain6), -- TD 532
                        TO_DATE(l_datvalli6), -- TD 532
                        p_respval6, -- TD 532
                        TO_NUMBER(p_codcamo7), -- TD 532
                        l_clibca7, -- TD 532
                        TO_NUMBER(l_cdfain7), -- TD 532
                        TO_DATE(l_datvalli7), -- TD 532
                        p_respval7, -- TD 532
                        TO_NUMBER(p_codcamo8), -- TD 532
                        l_clibca8, -- TD 532
                        TO_NUMBER(l_cdfain8), -- TD 532
                        TO_DATE(l_datvalli8), -- TD 532
                        p_respval8, -- TD 532
                        TO_NUMBER(p_codcamo9), -- TD 532
                        l_clibca9, -- TD 532
                        TO_NUMBER(l_cdfain9), -- TD 532
                        TO_DATE(l_datvalli9), -- TD 532
                        p_respval9, -- TD 532
                        TO_NUMBER(p_codcamo10), -- TD 532
                        l_clibca10, -- TD 532
                        TO_NUMBER(l_cdfain10), -- TD 532
                        TO_DATE(l_datvalli10), -- TD 532
                        p_respval10, -- TD 532
                        p_typactca1, -- TD 532
                        p_typactca2, -- TD 532
                        p_typactca3, -- TD 532
                        p_typactca4, -- TD 532
                        p_typactca5, -- TD 532
                        p_typactca6, -- TD 532
                        p_typactca7, -- TD 532
                        p_typactca8, -- TD 532
                        p_typactca9, -- TD 532
                        p_typactca10, -- TD 532
                        p_bloc,
                        p_adescr    --TD755 
                        );

        -- TD 532 :  Insertions des logs en table de APPLICATION_LOGS
        l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);

        maj_application_logs(p_airt, l_user, 'CODCAMO1', '', p_codcamo1, 'Création du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL1', '', p_respval1, 'Création du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO2', '', p_codcamo2, 'Création du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL2', '', p_respval2, 'Création du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO3', '', p_codcamo3, 'Création du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL3', '', p_respval3, 'Création du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO4', '', p_codcamo4, 'Création du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL4', '', p_respval4, 'Création du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO5', '', p_codcamo5, 'Création du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL5', '', p_respval5, 'Création du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO6', '', p_codcamo6, 'Création du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL6', '', p_respval6, 'Création du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO7', '', p_codcamo7, 'Création du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL7', '', p_respval7, 'Création du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO8', '', p_codcamo8, 'Création du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL8', '', p_respval8, 'Création du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO9', '', p_codcamo9, 'Création du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL9', '', p_respval9, 'Création du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO10', '', p_codcamo10, 'Création du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL10', '', p_respval10, 'Création du responsable de la validation du lien avec CA');

         -- 'L'application ' || p_airt || ' a été créé.';


         pack_global.recuperer_message(2024,'%s1',p_airt, NULL, l_msg);
         p_message := l_msg;

      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            pack_global.recuperer_message(20205, NULL, NULL, NULL, l_msg);
            raise_application_error( -20205, l_msg );
         WHEN referential_integrity THEN
            -- habiller le msg erreur
            pack_global.recuperation_integrite(-2291);


          WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;
   END insert_application;




   PROCEDURE update_application (p_airt      IN  application.airt%TYPE,
                                 p_alibel    IN  application.alibel%TYPE,
                                 p_alibcourt IN  application.alibcourt%TYPE,
                                 p_clicode   IN  application.clicode%TYPE,
                                 p_amop      IN  application.amop%TYPE,
                                 p_codsg     IN  VARCHAR2,
                                 p_acme      IN  application.acme%TYPE,
                                 p_codgappli IN  application.codgappli%TYPE,
                                 p_agappli   IN  application.agappli%TYPE,
                                 p_amnemo    IN  application.amnemo%TYPE,
                                 p_acdareg   IN  application.acdareg%TYPE,
                                 p_flaglock  IN  NUMBER,
                                 p_userid    IN  VARCHAR2,
                                 p_datfinapp IN  VARCHAR2, -- TD 532
                                   p_licodapca IN  VARCHAR2, -- TD 532
                                   p_codcamo1  IN  VARCHAR2, -- TD 532
                                   p_respval1  IN  VARCHAR2, -- TD 532
                                   p_codcamo2  IN  VARCHAR2, -- TD 532
                                   p_respval2  IN  VARCHAR2, -- TD 532
                                   p_codcamo3  IN  VARCHAR2, -- TD 532
                                   p_respval3  IN  VARCHAR2, -- TD 532
                                   p_codcamo4  IN  VARCHAR2, -- TD 532
                                   p_respval4  IN  VARCHAR2, -- TD 532
                                   p_codcamo5  IN  VARCHAR2, -- TD 532
                                   p_respval5  IN  VARCHAR2, -- TD 532
                                   p_codcamo6  IN  VARCHAR2, -- TD 532
                                   p_respval6  IN  VARCHAR2, -- TD 532
                                    p_codcamo7  IN  VARCHAR2, -- TD 532
                                   p_respval7  IN  VARCHAR2, -- TD 532
                                   p_codcamo8  IN  VARCHAR2, -- TD 532
                                   p_respval8  IN  VARCHAR2, -- TD 532
                                   p_codcamo9  IN  VARCHAR2, -- TD 532
                                   p_respval9  IN  VARCHAR2, -- TD 532
                                   p_codcamo10 IN  VARCHAR2, -- TD 532
                                   p_respval10 IN  VARCHAR2, -- TD 532
                                 p_typactca1 IN  VARCHAR2, -- TD 532
                                 p_typactca2 IN  VARCHAR2, -- TD 532
                                 p_typactca3 IN  VARCHAR2, -- TD 532
                                 p_typactca4 IN  VARCHAR2, -- TD 532
                                 p_typactca5 IN  VARCHAR2, -- TD 532
                                 p_typactca6 IN  VARCHAR2, -- TD 532
                                 p_typactca7 IN  VARCHAR2, -- TD 532
                                 p_typactca8 IN  VARCHAR2, -- TD 532
                                 p_typactca9 IN  VARCHAR2, -- TD 532
                                 p_typactca10 IN  VARCHAR2, -- TD 532
                                 p_bloc       IN VARCHAR2,
                                 p_adescr     IN VARCHAR2,--TD755 
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                ) IS


      l_msg VARCHAR(1024);

      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);
      l_user VARCHAR(30);
      l_alibme application.alibme%TYPE;
      l_alibmo application.alibmo%TYPE;
      l_alibgappli application.alibgappli%TYPE;

      l_codcamo1  application.codcamo1%TYPE; -- TD 532
      l_respval1  application.respval1%TYPE; -- TD 532
      l_codcamo2  application.codcamo1%TYPE; -- TD 532
      l_respval2  application.respval1%TYPE; -- TD 532
      l_codcamo3  application.codcamo1%TYPE; -- TD 532
      l_respval3  application.respval1%TYPE; -- TD 532
      l_codcamo4  application.codcamo1%TYPE; -- TD 532
      l_respval4  application.respval1%TYPE; -- TD 532
      l_codcamo5  application.codcamo1%TYPE; -- TD 532
      l_respval5  application.respval1%TYPE; -- TD 532
      l_codcamo6  application.codcamo1%TYPE; -- TD 532
      l_respval6  application.respval1%TYPE; -- TD 532
      l_codcamo7  application.codcamo1%TYPE; -- TD 532
      l_respval7  application.respval1%TYPE; -- TD 532
      l_codcamo8  application.codcamo1%TYPE; -- TD 532
      l_respval8  application.respval1%TYPE; -- TD 532
      l_codcamo9  application.codcamo1%TYPE; -- TD 532
      l_respval9  application.respval1%TYPE; -- TD 532
      l_codcamo10  application.codcamo1%TYPE; -- TD 532
      l_respval10  application.respval1%TYPE; -- TD 532

      l_clibca1    application.clibca1%TYPE; -- TD 532
      l_cdfain1    application.cdfain1%TYPE; -- TD 532
      l_datvalli1 application.datvalli1%TYPE; -- TD 532
      l_clibca2    application.clibca2%TYPE; -- TD 532
      l_cdfain2    application.cdfain2%TYPE; -- TD 532
      l_datvalli2 application.datvalli2%TYPE; -- TD 532
      l_clibca3    application.clibca3%TYPE; -- TD 532
      l_cdfain3    application.cdfain3%TYPE; -- TD 532
      l_datvalli3 application.datvalli3%TYPE; -- TD 532
      l_clibca4    application.clibca4%TYPE; -- TD 532
      l_cdfain4    application.cdfain4%TYPE; -- TD 532
      l_datvalli4 application.datvalli4%TYPE; -- TD 532
      l_clibca5    application.clibca5%TYPE; -- TD 532
      l_cdfain5    application.cdfain5%TYPE; -- TD 532
      l_datvalli5 application.datvalli5%TYPE; -- TD 532
      l_clibca6    application.clibca6%TYPE; -- TD 532
      l_cdfain6    application.cdfain6%TYPE; -- TD 532
      l_datvalli6 application.datvalli6%TYPE; -- TD 532
      l_clibca7    application.clibca7%TYPE; -- TD 532
      l_cdfain7    application.cdfain7%TYPE; -- TD 532
      l_datvalli7 application.datvalli7%TYPE; -- TD 532
      l_clibca8    application.clibca8%TYPE; -- TD 532
      l_cdfain8    application.cdfain8%TYPE; -- TD 532
      l_datvalli8 application.datvalli8%TYPE; -- TD 532
      l_clibca9    application.clibca9%TYPE; -- TD 532
      l_cdfain9    application.cdfain9%TYPE; -- TD 532
      l_datvalli9 application.datvalli9%TYPE; -- TD 532
      l_clibca10    application.clibca10%TYPE; -- TD 532
      l_cdfain10    application.cdfain10%TYPE; -- TD 532
      l_datvalli10 application.datvalli10%TYPE; -- TD 532

      l_old_codcamo1    application.codcamo1%TYPE; -- TD 532
      l_old_clibca1    application.clibca1%TYPE; -- TD 532
      l_old_cdfain1    application.cdfain1%TYPE; -- TD 532
      l_old_datvalli1    application.datvalli1%TYPE; -- TD 532
      l_old_respval1     application.respval1%TYPE; -- TD 532
      l_old_codcamo2    application.codcamo2%TYPE; -- TD 532
      l_old_clibca2    application.clibca2%TYPE; -- TD 532
      l_old_cdfain2    application.cdfain2%TYPE; -- TD 532
      l_old_datvalli2    application.datvalli2%TYPE; -- TD 532
      l_old_respval2    application.respval2%TYPE; -- TD 532
      l_old_codcamo3    application.codcamo3%TYPE; -- TD 532
      l_old_clibca3    application.clibca3%TYPE; -- TD 532
      l_old_cdfain3    application.cdfain3%TYPE; -- TD 532
      l_old_datvalli3    application.datvalli3%TYPE; -- TD 532
      l_old_respval3    application.respval3%TYPE; -- TD 532
      l_old_codcamo4    application.codcamo4%TYPE; -- TD 532
      l_old_clibca4    application.clibca4%TYPE; -- TD 532
      l_old_cdfain4    application.cdfain4%TYPE; -- TD 532
      l_old_datvalli4    application.datvalli4%TYPE; -- TD 532
      l_old_respval4     application.respval4%TYPE; -- TD 532
      l_old_codcamo5    application.codcamo5%TYPE; -- TD 532
      l_old_clibca5    application.clibca5%TYPE; -- TD 532
      l_old_cdfain5    application.cdfain5%TYPE; -- TD 532
      l_old_datvalli5    application.datvalli5%TYPE; -- TD 532
      l_old_respval5    application.respval5%TYPE; -- TD 532
      l_old_codcamo6    application.codcamo6%TYPE; -- TD 532
      l_old_clibca6    application.clibca6%TYPE; -- TD 532
      l_old_cdfain6    application.cdfain6%TYPE; -- TD 532
      l_old_datvalli6    application.datvalli6%TYPE; -- TD 532
      l_old_respval6     application.respval6%TYPE; -- TD 532
      l_old_codcamo7    application.codcamo7%TYPE; -- TD 532
      l_old_clibca7    application.clibca7%TYPE; -- TD 532
      l_old_cdfain7    application.cdfain7%TYPE; -- TD 532
      l_old_datvalli7    application.datvalli7%TYPE; -- TD 532
      l_old_respval7    application.respval7%TYPE; -- TD 532
      l_old_codcamo8    application.codcamo8%TYPE; -- TD 532
      l_old_clibca8    application.clibca8%TYPE; -- TD 532
      l_old_cdfain8    application.cdfain8%TYPE; -- TD 532
      l_old_datvalli8    application.datvalli8%TYPE; -- TD 532
      l_old_respval8    application.respval8%TYPE; -- TD 532
      l_old_codcamo9    application.codcamo9%TYPE; -- TD 532
      l_old_clibca9    application.clibca9%TYPE; -- TD 532
      l_old_cdfain9    application.cdfain9%TYPE; -- TD 532
      l_old_datvalli9    application.datvalli9%TYPE; -- TD 532
      l_old_respval9     application.respval9%TYPE; -- TD 532
      l_old_codcamo10    application.codcamo10%TYPE; -- TD 532
      l_old_clibca10    application.clibca10%TYPE; -- TD 532
      l_old_cdfain10    application.cdfain10%TYPE; -- TD 532
      l_old_datvalli10 application.datvalli10%TYPE; -- TD 532
      l_old_respval10    application.respval10%TYPE; -- TD 532

      l_typactca1 application.typactca1%TYPE; -- TD 532
      l_typactca2 application.typactca2%TYPE; -- TD 532
      l_typactca3 application.typactca3%TYPE; -- TD 532
      l_typactca4 application.typactca4%TYPE; -- TD 532
      l_typactca5 application.typactca5%TYPE; -- TD 532
      l_typactca6 application.typactca6%TYPE; -- TD 532
      l_typactca7 application.typactca7%TYPE; -- TD 532
      l_typactca8 application.typactca8%TYPE; -- TD 532
      l_typactca9 application.typactca9%TYPE; -- TD 532
      l_typactca10 application.typactca10%TYPE; -- TD 532
      
     

   BEGIN

      -- Positionner le nb de curseurs ==> 0

      -- Initialiser le message retour


      p_nbcurseur := 0;

      p_message := '';

    l_codcamo1 := p_codcamo1; -- TD 532
    l_respval1 := p_respval1; -- TD 532
    l_codcamo2 := p_codcamo2; -- TD 532
    l_respval2 := p_respval2; -- TD 532
    l_codcamo3 := p_codcamo3; -- TD 532
    l_respval3 := p_respval3; -- TD 532
    l_codcamo4 := p_codcamo4; -- TD 532
    l_respval4 := p_respval4; -- TD 532
    l_codcamo5 := p_codcamo5; -- TD 532
    l_respval5 := p_respval5; -- TD 532
    l_codcamo6 := p_codcamo6; -- TD 532
    l_respval6 := p_respval6; -- TD 532
    l_codcamo7 := p_codcamo7; -- TD 532
    l_respval7 := p_respval7; -- TD 532
    l_codcamo8 := p_codcamo8; -- TD 532
    l_respval8 := p_respval8; -- TD 532
    l_codcamo9 := p_codcamo9; -- TD 532
    l_respval9 := p_respval9; -- TD 532
    l_codcamo10 := p_codcamo10; -- TD 532
    l_respval10 := p_respval10; -- TD 532

    l_typactca1 := p_typactca1; -- TD 532
    l_typactca2 := p_typactca2; -- TD 532
    l_typactca3 := p_typactca3; -- TD 532
    l_typactca4 := p_typactca4; -- TD 532
    l_typactca5 := p_typactca5; -- TD 532
    l_typactca6 := p_typactca6; -- TD 532
    l_typactca7 := p_typactca7; -- TD 532
    l_typactca8 := p_typactca8; -- TD 532
    l_typactca9 := p_typactca9; -- TD 532
    l_typactca10 := p_typactca10; -- TD 532

    -- TD 532 : Initialisation des données des CA renseignées
    -- Récupération des anciennes valeurs avant le update
    SELECT
        TO_NUMBER(codcamo1), clibca1, TO_NUMBER(cdfain1), TO_DATE(datvalli1, 'DD/MM/YYYY'), respval1,
        TO_NUMBER(codcamo2), clibca2, TO_NUMBER(cdfain2), TO_DATE(datvalli2, 'DD/MM/YYYY'), respval2,
        TO_NUMBER(codcamo3), clibca3, TO_NUMBER(cdfain3), TO_DATE(datvalli3, 'DD/MM/YYYY'), respval3,
        TO_NUMBER(codcamo4), clibca4, TO_NUMBER(cdfain4), TO_DATE(datvalli4, 'DD/MM/YYYY'), respval4,
        TO_NUMBER(codcamo5), clibca5, TO_NUMBER(cdfain5), TO_DATE(datvalli5, 'DD/MM/YYYY'), respval5,
        TO_NUMBER(codcamo6), clibca6, TO_NUMBER(cdfain6), TO_DATE(datvalli6, 'DD/MM/YYYY'), respval6,
        TO_NUMBER(codcamo7), clibca7, TO_NUMBER(cdfain7), TO_DATE(datvalli7, 'DD/MM/YYYY'), respval7,
        TO_NUMBER(codcamo8), clibca8, TO_NUMBER(cdfain8), TO_DATE(datvalli8, 'DD/MM/YYYY'), respval8,
        TO_NUMBER(codcamo9), clibca9, TO_NUMBER(cdfain9), TO_DATE(datvalli9, 'DD/MM/YYYY'), respval9,
        TO_NUMBER(codcamo10), clibca10, TO_NUMBER(cdfain10), TO_DATE(datvalli10, 'DD/MM/YYYY'), respval10
    INTO
        l_old_codcamo1, l_old_clibca1, l_old_cdfain1, l_old_datvalli1, l_old_respval1,
        l_old_codcamo2, l_old_clibca2, l_old_cdfain2, l_old_datvalli2, l_old_respval2,
        l_old_codcamo3, l_old_clibca3, l_old_cdfain3, l_old_datvalli3, l_old_respval3,
        l_old_codcamo4, l_old_clibca4, l_old_cdfain4, l_old_datvalli4, l_old_respval4,
        l_old_codcamo5, l_old_clibca5, l_old_cdfain5, l_old_datvalli5, l_old_respval5,
        l_old_codcamo6, l_old_clibca6, l_old_cdfain6, l_old_datvalli6, l_old_respval6,
        l_old_codcamo7, l_old_clibca7, l_old_cdfain7, l_old_datvalli7, l_old_respval7,
        l_old_codcamo8, l_old_clibca8, l_old_cdfain8, l_old_datvalli8, l_old_respval8,
        l_old_codcamo9, l_old_clibca9, l_old_cdfain9, l_old_datvalli9, l_old_respval9,
        l_old_codcamo10, l_old_clibca10, l_old_cdfain10, l_old_datvalli10, l_old_respval10
    FROM application
    WHERE airt = p_airt;


    -- Vérification si les données sur les CA sont identiques aux précédentes et mise à jour avant le update

    maj_donnees_ca (l_old_codcamo1, l_old_clibca1, l_old_cdfain1, l_old_datvalli1, l_old_respval1,
                    l_codcamo1, l_clibca1, l_cdfain1, l_datvalli1, l_respval1);
    maj_donnees_ca (l_old_codcamo2, l_old_clibca2, l_old_cdfain2, l_old_datvalli2, l_old_respval2,
                    l_codcamo2, l_clibca2, l_cdfain2, l_datvalli2, l_respval2);
    maj_donnees_ca (l_old_codcamo3, l_old_clibca3, l_old_cdfain3, l_old_datvalli3, l_old_respval3,
                    l_codcamo3, l_clibca3, l_cdfain3, l_datvalli3, l_respval3);
    maj_donnees_ca (l_old_codcamo4, l_old_clibca4, l_old_cdfain4, l_old_datvalli4, l_old_respval4,
                    l_codcamo4, l_clibca4, l_cdfain4, l_datvalli4, l_respval4);
    maj_donnees_ca (l_old_codcamo5, l_old_clibca5, l_old_cdfain5, l_old_datvalli5, l_old_respval5,
                    l_codcamo5, l_clibca5, l_cdfain5, l_datvalli5, l_respval5);
    maj_donnees_ca (l_old_codcamo6, l_old_clibca6, l_old_cdfain6, l_old_datvalli6, l_old_respval6,
                    l_codcamo6, l_clibca6, l_cdfain6, l_datvalli6, l_respval6);
    maj_donnees_ca (l_old_codcamo7, l_old_clibca7, l_old_cdfain7, l_old_datvalli7, l_old_respval7,
                    l_codcamo7, l_clibca7, l_cdfain7, l_datvalli7, l_respval7);
    maj_donnees_ca (l_old_codcamo8, l_old_clibca8, l_old_cdfain8, l_old_datvalli8, l_old_respval8,
                    l_codcamo8, l_clibca8, l_cdfain8, l_datvalli8, l_respval8);
    maj_donnees_ca (l_old_codcamo9, l_old_clibca9, l_old_cdfain9, l_old_datvalli9, l_old_respval9,
                    l_codcamo9, l_clibca9, l_cdfain9, l_datvalli9, l_respval9);
    maj_donnees_ca (l_old_codcamo10, l_old_clibca10, l_old_cdfain10, l_old_datvalli10, l_old_respval10,
                    l_codcamo10, l_clibca10, l_cdfain10, l_datvalli10, l_respval10);

      -- Récupération des valeurs : alibme,  alibmo,  alibgappli
      BEGIN
               IF (p_codsg IS NOT NULL)
             THEN
                    SELECT DISTINCT si.libdsg
                   INTO l_alibme
                   FROM application a, struct_info si
                   WHERE a.codsg = si.codsg
                   AND a.codsg = TO_NUMBER(p_codsg);
             ELSE
                    l_alibme := '';
             END IF;

              EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                         pack_global.recuperer_message( 4, '%s1', p_clicode, NULL, p_message);
                         WHEN OTHERS THEN
                         raise_application_error( -20997, SQLERRM);
      END;


        BEGIN
             IF (p_clicode IS NOT NULL)
             THEN
                   SELECT DISTINCT cmo.clilib
                  INTO l_alibmo
                  FROM application a, client_mo cmo
                  WHERE a.clicode = cmo.clicode
                  AND a.clicode = p_clicode;
             ELSE
              l_alibmo := '';
             END IF;

              EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                         pack_global.recuperer_message( 4, '%s1', p_clicode, NULL, p_message);
                         WHEN OTHERS THEN
                         raise_application_error( -20997, SQLERRM);
      END;

      BEGIN
             IF (p_codgappli IS NOT NULL)
             THEN
                    SELECT DISTINCT cmo.clilib
                   INTO l_alibgappli
                   FROM application a, client_mo cmo
                   WHERE a.codgappli = cmo.clicode
                   AND a.codgappli = p_codgappli;
             ELSE
             l_alibgappli := '';
             END IF;

           EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                         pack_global.recuperer_message( 4, '%s1', p_codgappli, NULL, p_message);
                         WHEN OTHERS THEN
                         raise_application_error( -20997, SQLERRM);
      END;

    -- UPDATE
      BEGIN
         UPDATE application SET acme      = p_acme,
                amnemo    = p_amnemo,
                                agappli   = p_agappli,
                                airt      = p_airt,
                                alibel    = p_alibel,
                                amop      = p_amop,
                                clicode   = p_clicode,
                                codgappli = p_codgappli,
                                codsg     = TO_NUMBER(p_codsg),
                                alibcourt = p_alibcourt,
                                acdareg   = p_acdareg,
                                flaglock  = decode( p_flaglock, 1000000, 0, p_flaglock + 1),
                                alibme        = l_alibme, -- TD 532
                                alibmo        = l_alibmo, -- TD 532
                                alibgappli    = l_alibgappli, -- TD 532
                                datfinapp    = TO_DATE(p_datfinapp, 'DD/MM/YYYY'), -- TD 532
                                licodapca     = p_licodapca, -- TD 532
                                codcamo1    = TO_NUMBER(l_codcamo1), -- TD 532
                                clibca1        = l_clibca1, -- TD 532
                                cdfain1        = TO_NUMBER(l_cdfain1), -- TD 532
                                datvalli1    = TO_DATE(l_datvalli1), -- TD 532
                                respval1    = l_respval1, -- TD 532
                                codcamo2    = TO_NUMBER(l_codcamo2), -- TD 532
                                clibca2        = l_clibca2, -- TD 532
                                cdfain2        = TO_NUMBER(l_cdfain2), -- TD 532
                                datvalli2    = TO_DATE(l_datvalli2), -- TD 532
                                respval2    = l_respval2, -- TD 532
                                codcamo3    = TO_NUMBER(l_codcamo3), -- TD 532
                                clibca3        = l_clibca3, -- TD 532
                                cdfain3        = TO_NUMBER(l_cdfain3), -- TD 532
                                datvalli3    = TO_DATE(l_datvalli3), -- TD 532
                                respval3    = l_respval3, -- TD 532
                                codcamo4    = TO_NUMBER(l_codcamo4), -- TD 532
                                clibca4        = l_clibca4, -- TD 532
                                cdfain4        = TO_NUMBER(l_cdfain4), -- TD 532
                                datvalli4    = TO_DATE(l_datvalli4), -- TD 532
                                respval4    = l_respval4, -- TD 532
                                codcamo5    = TO_NUMBER(l_codcamo5), -- TD 532
                                clibca5        = l_clibca5, -- TD 532
                                cdfain5        = TO_NUMBER(l_cdfain5), -- TD 532
                                datvalli5    = TO_DATE(l_datvalli5), -- TD 532
                                respval5    = l_respval5, -- TD 532
                                codcamo6    = TO_NUMBER(l_codcamo6), -- TD 532
                                clibca6        = l_clibca6, -- TD 532
                                cdfain6        = TO_NUMBER(l_cdfain6), -- TD 532
                                datvalli6    = TO_DATE(l_datvalli6), -- TD 532
                                respval6    = l_respval6, -- TD 532
                                codcamo7    = TO_NUMBER(l_codcamo7), -- TD 532
                                clibca7        = l_clibca7, -- TD 532
                                cdfain7        = TO_NUMBER(l_cdfain7), -- TD 532
                                datvalli7    = TO_DATE(l_datvalli7), -- TD 532
                                respval7    = l_respval7, -- TD 532
                                codcamo8    = TO_NUMBER(l_codcamo8), -- TD 532
                                clibca8        = l_clibca8, -- TD 532
                                cdfain8        = TO_NUMBER(l_cdfain8), -- TD 532
                                datvalli8    = TO_DATE(l_datvalli8), -- TD 532
                                respval8    = l_respval8, -- TD 532
                                codcamo9    = TO_NUMBER(l_codcamo9), -- TD 532
                                clibca9        = l_clibca9, -- TD 532
                                cdfain9        = TO_NUMBER(l_cdfain9), -- TD 532
                                datvalli9    = TO_DATE(l_datvalli9), -- TD 532
                                respval9    = l_respval9, -- TD 532
                                codcamo10    = TO_NUMBER(l_codcamo10), -- TD 532
                                clibca10    = l_clibca10, -- TD 532
                                cdfain10    = TO_NUMBER(l_cdfain10), -- TD 532
                                datvalli10    = TO_DATE(l_datvalli10), -- TD 532
                                respval10    = l_respval10, -- TD 532
                                typactca1     = p_typactca1, -- TD 532
                                typactca2     = p_typactca2, -- TD 532
                                typactca3     = p_typactca3, -- TD 532
                                typactca4     = p_typactca4, -- TD 532
                                typactca5     = p_typactca5, -- TD 532
                                typactca6     = p_typactca6, -- TD 532
                                typactca7     = p_typactca7, -- TD 532
                                typactca8     = p_typactca8, -- TD 532
                                typactca9     = p_typactca9, -- TD 532
                                typactca10     = p_typactca10, -- TD 532
                                bloc = p_bloc,
                                adescr = p_adescr -- TD 755 
         WHERE airt = p_airt
         AND flaglock = p_flaglock;

        -- TD 532 :  Insertions des logs en table de APPLICATION_LOGS
        l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);

        maj_application_logs(p_airt, l_user, 'CODCAMO1', l_old_codcamo1, l_codcamo1, 'Modification du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL1', l_old_respval1, l_respval1, 'Modification du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO2', l_old_codcamo2, l_codcamo2, 'Modification du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL2', l_old_respval2, l_respval2, 'Modification du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO3', l_old_codcamo3, l_codcamo3, 'Modification du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL3', l_old_respval3, l_respval3, 'Modification du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO4', l_old_codcamo4, l_codcamo4, 'Modification du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL4', l_old_respval4, l_respval4, 'Modification du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO5', l_old_codcamo5, l_codcamo5, 'Modification du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL5', l_old_respval5, l_respval5, 'Modification du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO6', l_old_codcamo6, l_codcamo6, 'Modification du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL6', l_old_respval6, l_respval6, 'Modification du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO7', l_old_codcamo7, l_codcamo7, 'Modification du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL7', l_old_respval7, l_respval7, 'Modification du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO8', l_old_codcamo8, l_codcamo8, 'Modification du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL8', l_old_respval8, l_respval8, 'Modification du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO9', l_old_codcamo9, l_codcamo9, 'Modification du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL9', l_old_respval9, l_respval9, 'Modification du responsable de la validation du lien avec CA');
        maj_application_logs(p_airt, l_user, 'CODCAMO10', l_old_codcamo10, l_codcamo10, 'Modification du lien avec CA');
        maj_application_logs(p_airt, l_user, 'RESPVAL10', l_old_respval10, l_respval10, 'Modification du responsable de la validation du lien avec CA');


      EXCEPTION
         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2291);




         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;


      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE
         pack_global.recuperer_message(2025, '%s1', p_airt, NULL, l_msg);
         p_message := l_msg;
      END IF;
   END update_application;





   PROCEDURE delete_application (p_airt      IN  application.airt%TYPE,
                                 p_flaglock  IN  NUMBER,
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

         DELETE FROM application
                WHERE airt = p_airt
                AND flaglock = p_flaglock;

      EXCEPTION
         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2292);

        WHEN OTHERS THEN
          raise_application_error( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE
         pack_global.recuperer_message(2026, '%s1', p_airt, NULL, l_msg);
         p_message := l_msg;
      END IF;


   END delete_application;




   PROCEDURE select_application (p_airt           IN application.airt%TYPE,
                                 p_userid         IN VARCHAR2,
                                 p_curapplication IN OUT applicationCurType,
                                 p_nbcurseur         OUT INTEGER,
                                 p_message           OUT VARCHAR2
                                ) IS
      l_msg VARCHAR2(1024);
      l_airt application.airt%TYPE;
   BEGIN

      -- Positionner le nb de curseurs ==> 1

      -- Initialiser le message retour


      p_nbcurseur := 1;

      p_message := '';




      -- Attention ordre des colonnes doit correspondre a l ordre

      -- de declaration dans la table ORACLE (a cause de ROWTYPE)

      -- ou selectionner toutes les colonnes par *


      BEGIN
         OPEN p_curapplication FOR
                 SELECT
                          a.AIRT,
                         a.AMOP,
                         a.AMNEMO,
                         a.AGAPPLI,
                         a.ACME,
                         a.ALIBEL,
                          a.FLAGLOCK,
                       a.CLICODE,
                         a.CODSG,
                         a.CODGAPPLI,
                         a.ACDAREG,
                         a.ALIBCOURT,
                         a.ALIBME, -- TD 532
                         a.ALIBMO, -- TD 532
                         a.ALIBGAPPLI, -- TD 532
                         TO_CHAR(a.DATFINAPP, 'DD/MM/YYYY') AS DATFINAPP, -- TD 532
                         a.LICODAPCA, -- TD 532
                         a.CODCAMO1, -- TD 532
                         a.CLIBCA1, -- TD 532
                         a.CDFAIN1, -- TD 532
                         TO_CHAR(a.DATVALLI1, 'DD/MM/YYYY') AS DATVALLI1, -- TD 532
                         a.RESPVAL1, -- TD 532
                         a.CODCAMO2, -- TD 532
                         a.CLIBCA2, -- TD 532
                         a.CDFAIN2, -- TD 532
                         TO_CHAR(a.DATVALLI2, 'DD/MM/YYYY') AS DATVALLI2, -- TD 532
                         a.RESPVAL2, -- TD 532
                         a.CODCAMO3, -- TD 532
                         a.CLIBCA3, -- TD 532
                         a.CDFAIN3, -- TD 532
                         TO_CHAR(a.DATVALLI3, 'DD/MM/YYYY') AS DATVALLI3, -- TD 532
                         a.RESPVAL3, -- TD 532
                         a.CODCAMO4, -- TD 532
                         a.CLIBCA4, -- TD 532
                         a.CDFAIN4, -- TD 532
                         TO_CHAR(a.DATVALLI4, 'DD/MM/YYYY') AS DATVALLI4, -- TD 532
                         a.RESPVAL4, -- TD 532
                         a.CODCAMO5, -- TD 532
                         a.CLIBCA5, -- TD 532
                         a.CDFAIN5, -- TD 532
                         TO_CHAR(a.DATVALLI5, 'DD/MM/YYYY') AS DATVALLI5, -- TD 532
                         a.RESPVAL5, -- TD 532
                         a.CODCAMO6, -- TD 532
                         a.CLIBCA6, -- TD 532
                         a.CDFAIN6, -- TD 532
                         TO_CHAR(a.DATVALLI6, 'DD/MM/YYYY') AS DATVALLI6, -- TD 532
                         a.RESPVAL6, -- TD 532
                         a.CODCAMO7, -- TD 532
                         a.CLIBCA7, -- TD 532
                         a.CDFAIN7, -- TD 532
                         TO_CHAR(a.DATVALLI7, 'DD/MM/YYYY') AS DATVALLI7, -- TD 532
                         a.RESPVAL7, -- TD 532
                         a.CODCAMO8, -- TD 532
                         a.CLIBCA8, -- TD 532
                         a.CDFAIN8, -- TD 532
                         TO_CHAR(a.DATVALLI8, 'DD/MM/YYYY') AS DATVALLI8, -- TD 532
                         a.RESPVAL8, -- TD 532
                         a.CODCAMO9, -- TD 532
                         a.CLIBCA9, -- TD 532
                         a.CDFAIN9, -- TD 532
                         TO_CHAR(a.DATVALLI9, 'DD/MM/YYYY') AS DATVALLI9, -- TD 532
                         a.RESPVAL9, -- TD 532
                         a.CODCAMO10, -- TD 532
                         a.CLIBCA10, -- TD 532
                         a.CDFAIN10, -- TD 532
                         TO_CHAR(a.DATVALLI10, 'DD/MM/YYYY') AS DATVALLI10, -- TD 532
                         a.RESPVAL10, -- TD 532
                         a.TYPACTCA1, -- TD 532
                         a.TYPACTCA2, -- TD 532
                         a.TYPACTCA3, -- TD 532
                         a.TYPACTCA4, -- TD 532
                         a.TYPACTCA5, -- TD 532
                         a.TYPACTCA6, -- TD 532
                         a.TYPACTCA7, -- TD 532
                         a.TYPACTCA8, -- TD 532
                         a.TYPACTCA9, -- TD 532
                         a.TYPACTCA10, -- TD 532
                       a.bloc,
                      b.code_b || ' - ' || b.libelle  lib_bloc ,
                      a.adescr
                 FROM APPLICATION a, bloc b
                 WHERE a.airt = p_airt
                 and   a.bloc = b.code_b;

/*
              SELECT *
              FROM APPLICATION
              WHERE airt = p_airt;
*/

      EXCEPTION
         WHEN OTHERS THEN
           raise_application_error( -20997, SQLERRM);
      END;

      -- en cas absence

      -- 'Le centre d'activité n'existe pas';


      pack_global.recuperer_message(2027, '%s1',p_airt, NULL, l_msg);
      p_message := l_msg;
   END select_application;

--Procédure pour remplir les logs de MAJ de l'application
PROCEDURE maj_application_logs (p_airt            IN application_logs.airt%TYPE,
                                p_user_log        IN VARCHAR2,
                                p_colonne        IN VARCHAR2,
                                p_valeur_prec    IN VARCHAR2,
                                p_valeur_nouv    IN VARCHAR2,
                                p_commentaire    IN VARCHAR2
                                ) IS
BEGIN

    IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
        INSERT INTO application_logs
            (airt, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
        VALUES
            (p_airt, SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);

    END IF;
    -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

END maj_application_logs;

--Procédure pour initlialiser un CA préconisé
PROCEDURE init_donnees_ca (p_codcamo     IN OUT application.codcamo1%TYPE,
                           p_clibca        IN OUT application.clibca1%TYPE,
                           p_cdfain        IN OUT application.cdfain1%TYPE,
                           p_datvalli    IN OUT application.datvalli1%TYPE
                          ) IS
BEGIN
    IF (TO_NUMBER(p_codcamo) <> 0)
    THEN
        BEGIN
            SELECT
                ca.clibca, ca.cdfain
            INTO p_clibca, p_cdfain
            FROM centre_activite ca
            WHERE ca.codcamo = p_codcamo;
            SELECT
                TO_DATE(SYSDATE, 'DD/MM/YYYY')
            INTO p_datvalli
            FROM DUAL;
        END;
    ELSE
        BEGIN
            p_codcamo := 0;
            p_clibca := '';
            p_cdfain := '';
            p_datvalli := '';
        END;
    END IF;
END init_donnees_ca;

--Procédure pour mettre à jour un CA préconisé
PROCEDURE maj_donnees_ca (p_old_codcamo     IN application.codcamo1%TYPE,
                          p_old_clibca        IN application.clibca1%TYPE,
                          p_old_cdfain        IN application.cdfain1%TYPE,
                          p_old_datvalli    IN application.datvalli1%TYPE,
                          p_old_respval        IN application.respval1%TYPE,
                          p_codcamo         IN OUT application.codcamo1%TYPE,
                          p_clibca            IN OUT application.clibca1%TYPE,
                          p_cdfain            IN OUT application.cdfain1%TYPE,
                          p_datvalli        IN OUT application.datvalli1%TYPE,
                          p_respval            IN OUT application.respval1%TYPE
                          ) IS
BEGIN
    IF (TO_NUMBER(p_codcamo) <> 0)
    THEN
        BEGIN
            IF (p_codcamo = p_old_codcamo)
            THEN
                -- codcamo inchangé
                IF (p_respval <> p_old_respval)
                THEN
                    -- respval modifié
                    BEGIN
                        p_clibca := p_old_clibca;
                        p_cdfain := p_old_cdfain;
                        -- Mise à jour de la date de validité du lien
                        SELECT
                            TO_DATE(SYSDATE, 'DD/MM/YYYY')
                        INTO p_datvalli
                        FROM DUAL;
                    END;
                ELSE
                    -- respval inchangé
                    BEGIN
                        p_clibca := p_old_clibca;
                        p_cdfain := p_old_cdfain;
                        p_datvalli := p_old_datvalli;
                        p_respval := p_old_respval;
                    END;
                END IF;
            ELSE
                -- codcamo modifié (et non nul)
                BEGIN
                    -- Mise à jour de clibca et cdfain
                    SELECT
                        ca.clibca, ca.cdfain
                    INTO p_clibca, p_cdfain
                    FROM centre_activite ca
                    WHERE ca.codcamo = p_codcamo;
                    -- Mise à jour de la date de validité du lien
                    SELECT
                        TO_DATE(SYSDATE, 'DD/MM/YYYY')
                    INTO p_datvalli
                    FROM DUAL;

                    IF (p_respval = p_old_respval)
                    THEN
                        -- respval inchangé
                        BEGIN
                            p_respval := p_old_respval;
                        END;
                    END IF;
                END;
            END IF;
        END;
    ELSE
        -- codcamo = 0
        BEGIN
            p_codcamo := 0;
            p_clibca := '';
            p_cdfain := '';
            p_datvalli := '';
            p_respval := '';
        END;
    END IF;
END maj_donnees_ca;

END pack_application;
/





