-- ****************************************************************************
-- pack_proposes PL/SQL :       Mise a jour de budget 
--
-- equipe SOPRA
--
-- crée le 09/02/1999
--
-- Modifications 
-- 
-- Quand      Qui  Quoi
-- ---------- ---  ------------------------------------------------------------
-- 20/01/1999 JFM  ajout de l'appel a la procedure packbatch2 de maj des budgets BUCONSMAJ
-- 30/05/2000 QHL  pb de performance : remplacer l'appel à packbatch2.buconsmaj par la maj
--                 de BUDCONS directement ici
-- 19/02/2001 NBM  gestion des habilitations selon le périmètre de l'utilisateur :
--		   le codsg de la ligne BIP doit appartenir au périmètre de l'utilisateur
-- 04/2002    ARE  refonte budget
--
-- 10/06/2003 Pierre JOSSE Migration RTFE(suppression UserBip) et changement fromat DPG. 
-- 08/07/2003 MMC select_proposes : p_bouton remplace par p_mode et p_preproc supprime 
-- 17/08/2004 PJO : Fiche 390 : Modification de la gestion des budgets
-- 11/06/2007 JAL : Fiche 556 exclusion lignes BIP type 9
-- 28/09/2009   ABA: TD 822 (lot 7.3) trace des modifications des budgets
-- 11/05/2011 CMA fiche 1176 quand on passe par le menu client, on utilise perimcli, pas perimo
-- 14/06/2012 OEL QC 1391
-- ****************************************************************************

CREATE OR REPLACE PACKAGE       "PACK_PROPOSES" AS

   TYPE proposes_RecType IS RECORD (bpannee      VARCHAR2(20),
                                    bpmontme      VARCHAR2(20),
                                    bpmontmo      VARCHAR2(20),
                                    flaglock     VARCHAR2(20),
                                    pid          budget.pid%TYPE
                                   );

   TYPE proposesCurType IS REF CURSOR RETURN proposes_RecType;


   PROCEDURE insert_proposes (p_pid            IN  ligne_bip.pid%TYPE,
                              p_pnom          IN  ligne_bip.pnom%TYPE,
                              p_bpannee       IN  VARCHAR2,
                              p_bpmontme       IN  VARCHAR2,
                              p_bpmontmo       IN  VARCHAR2,
                              p_userid        IN  VARCHAR2,
                              p_nbcurseur     OUT INTEGER,
                              p_message       OUT VARCHAR2
                             );

   PROCEDURE update_proposes (p_pid       IN  ligne_bip.pid%TYPE,
                              p_pnom      IN  ligne_bip.pnom%TYPE,
                              p_bpannee   IN  VARCHAR2,
                              p_bpmontme  IN  VARCHAR2,
                              p_bpmontmo  IN  VARCHAR2,
                              p_flaglock  IN  NUMBER,
                              p_userid    IN  VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             );



   PROCEDURE select_proposes (p_pid       IN budget.pid%TYPE,
                              p_bpannee   IN VARCHAR2,
                              p_userid    IN VARCHAR2,
                              p_pnom      OUT VARCHAR2,
                              p_mode      OUT VARCHAR2,
                              p_bpmontme  OUT VARCHAR2,
                              p_bpmontmo  OUT VARCHAR2,
                              p_perime      OUT VARCHAR2,
                              p_perimo      OUT VARCHAR2,
                              p_typproj      OUT VARCHAR2,
                              p_flaglock  OUT VARCHAR2,
                              p_bpdate      OUT VARCHAR2,
                              p_bpmedate      OUT VARCHAR2,
                              p_ubpmontme      OUT VARCHAR2,
                              p_ubpmontmo      OUT VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             );
END pack_proposes;
/


CREATE OR REPLACE PACKAGE BODY "PACK_PROPOSES" AS


-- ****************************************************************************
--           INSERT_PROPOSES
-- ****************************************************************************
   PROCEDURE insert_proposes (p_pid       IN  ligne_bip.pid%TYPE,
                              p_pnom      IN  ligne_bip.pnom%TYPE,
                              p_bpannee   IN  VARCHAR2,
                              p_bpmontme  IN  VARCHAR2,
                              p_bpmontmo  IN  VARCHAR2,
                              p_userid    IN  VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             ) IS

   l_msg    VARCHAR2(1024);
   l_bpdate DATE;
   l_user        LIGNE_BIP_LOGS.user_log%TYPE;


   referential_integrity EXCEPTION;
   PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
      -- Recupere la date courante

      -- SELECT SYSDATE
      -- INTO   l_bpdate
      -- FROM   DUAL;


      BEGIN

         INSERT INTO budget (pid,
                                  bpdate,
                                  annee,
                                  bpmontme,
                                  bpmontmo,
                                  flaglock,
                                  bpmedate,
                                  ubpmontme,
                                  ubpmontmo
                                 )
                VALUES (p_pid,
                          decode(p_bpmontme,null,null,'',null,sysdate),
                        TO_NUMBER(p_bpannee),
                        DECODE(p_bpmontme,
                               '', null,
                               NULL, null,
                               TO_NUMBER(p_bpmontme,'FM9999999990D00')
                              ),
                        DECODE(p_bpmontmo,
                                '', null,
                               NULL, null,
                               TO_NUMBER(p_bpmontmo,'FM9999999990D00')
                              ),
                       0,
                       decode(p_bpmontmo,null,null,'',null,sysdate),
                       decode(p_bpmontme,null,null,'',null,l_user),
                       decode(p_bpmontmo,null,null,'',null,l_user)
                       );

         IF RTRIM(LTRIM(p_bpmontme)) != ' '
         THEN
            Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé fournisseur ' || p_bpannee, NULL,p_bpmontme, 'Création via IHM');
         END IF;

         IF RTRIM(LTRIM(p_bpmontmo)) != ' '
         THEN
            Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé client ' || p_bpannee, NULL,p_bpmontmo, 'Création via IHM');
         END IF;

         IF (RTRIM(LTRIM(p_bpmontmo)) = ' ')
            AND
            (RTRIM(LTRIM(p_bpmontme)) = ' ')
         THEN
            Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé client ' || p_bpannee, NULL,p_bpmontme, 'Création via IHM');
            Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé fournisseur ' || p_bpannee, NULL,p_bpmontmo, 'Création via IHM');
         END IF;
         -- 'La proposition de budget' || p_pid || 'de l''annee' || p_bpannee || ' a été créé';
         pack_global.recuperer_message(2074, '%s1', p_pid, '%s2', p_bpannee, NULL, l_msg);
         p_message := l_msg;

      EXCEPTION

         WHEN DUP_VAL_ON_INDEX THEN
            pack_global.recuperer_message(20268,NULL, NULL, NULL, l_msg);
            raise_application_error( -20268, l_msg );

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2291);

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM );

      END;


   END insert_proposes;


-- ****************************************************************************
--           UPDATE_PROPOSES
-- ****************************************************************************
   PROCEDURE update_proposes (p_pid       IN  ligne_bip.pid%TYPE,
                              p_pnom      IN  ligne_bip.pnom%TYPE,
                              p_bpannee   IN  VARCHAR2,
                              p_bpmontme  IN  VARCHAR2,
                              p_bpmontmo  IN  VARCHAR2,
                              p_flaglock  IN  NUMBER,
                              p_userid    IN  VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             ) IS

   l_msg    VARCHAR2(1024);
   l_bpdate DATE;
   l_bud_prop  VARCHAR2(13);
   l_bud_propmo  VARCHAR2(13);
   LCRequete      VARCHAR2(5000) ;
   l_user        LIGNE_BIP_LOGS.user_log%TYPE;
   referential_integrity EXCEPTION;
   PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      LCRequete := '';
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
      -- Recupere la date courante

      -- SELECT SYSDATE
      -- INTO   l_bpdate
      -- FROM   DUAL;

         -- 06/08/2009 YSB  : On effectue la mise à jour si les données saisies sont
         -- différentes de celles de la base
        BEGIN
            SELECT TO_CHAR(bpmontme, 'FM9999999990D00'),
            TO_CHAR(bpmontmo, 'FM9999999990D00')
            INTO l_bud_prop,
                 l_bud_propmo
            FROM BUDGET
            WHERE pid = p_pid
            AND   annee = TO_NUMBER( p_bpannee)
            AND   flaglock = TO_NUMBER(p_flaglock);

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- 'Accès concurrent'

               Pack_Global.recuperer_message( 20999, NULL, NULL,
                                              NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20999, l_msg);

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;



   BEGIN

       IF (nvl(p_bpmontme,' ') <> nvl(l_bud_prop,' ')) THEN


                    UPDATE budget SET
                                      bpdate  =  sysdate,
                                      bpmontme = p_bpmontme,
                                      ubpmontme = l_user,
                                      flaglock = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
                    WHERE pid = p_pid
                AND annee = p_bpannee;
                --AND flaglock = l_flaglock;
                --YNI
                 Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé fournisseur ' || p_bpannee, to_char(l_bud_prop,'FM999999990D00'),to_char(p_bpmontme,'FM999999990D00'), 'Modification via IHM');
                  --YNI
            END IF;

              --YNI update des champs "budget proposé client"

               IF (nvl(p_bpmontmo, ' ') != nvl(l_bud_propmo,' ') ) THEN

                    UPDATE budget SET
                                      bpmedate  = sysdate,
                                      bpmontmo = p_bpmontmo,
                                      ubpmontmo = l_user,
                                      flaglock = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
                    WHERE pid = p_pid
                AND annee = p_bpannee;
                --AND flaglock = l_flaglock;
                --YNI
              Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé client ' || p_bpannee, to_char(l_bud_propmo,'FM999999990D00'),to_char(p_bpmontmo,'FM999999990D00'), 'Modification via IHM');
                --YNI
              END IF;


      EXCEPTION

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2291);

         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

      /*

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE
         IF RTRIM(LTRIM(p_bpmontme)) != RTRIM(LTRIM(l_bud_prop))
            THEN
            Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé client ' || p_bpannee, l_bud_propmo,p_bpmontmo, 'Modification via IHM');
         END IF;

         IF RTRIM(LTRIM(p_bpmontmo)) != RTRIM(LTRIM(l_bud_propmo))
            THEN
            Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé fournisseur ' || p_bpannee, l_bud_prop,p_bpmontme, 'Modification via IHM');
         END IF;

      END IF;

    END IF;*/

    pack_global.recuperer_message(2075, '%s1', p_pid, '%s2', p_bpannee, NULL, l_msg);
         p_message := l_msg;

   END update_proposes;


-- ****************************************************************************
--           SELECT_PROPOSES
-- ****************************************************************************
   PROCEDURE select_proposes (p_pid       IN budget.pid%TYPE,
                              p_bpannee   IN VARCHAR2,
                              p_userid    IN VARCHAR2,
                              p_pnom      OUT VARCHAR2,
                              p_mode      OUT VARCHAR2,
                              p_bpmontme  OUT VARCHAR2,
                              p_bpmontmo  OUT VARCHAR2,
                              p_perime      OUT VARCHAR2,
                              p_perimo      OUT VARCHAR2,
                              p_typproj      OUT VARCHAR2,
                              p_flaglock  OUT VARCHAR2,
                              p_bpdate      OUT VARCHAR2,
                              p_bpmedate      OUT VARCHAR2,
                              p_ubpmontme      OUT VARCHAR2,
                              p_ubpmontmo      OUT VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             ) IS

      l_msg      VARCHAR2(1024);
      l_codsg    ligne_bip.codsg%TYPE;
      l_clicode  ligne_bip.clicode%TYPE;
      l_pid      ligne_bip.pid%TYPE;
      l_habilitation varchar2(10);
      l_perimo     VARCHAR2(1000);
      l_statut   VARCHAR2(56);
      l_date_statut VARCHAR2(10);
      l_topfer   CHAR(1);
      l_datdebex varchar2(10);
      l_date_statut_number NUMBER(10);
      l_menu     VARCHAR2(255);
   

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

    l_menu := pack_global.lire_globaldata(p_userid).menutil;



      -- TEST : Existence de pid dans ligne_bip

      BEGIN
         SELECT pid
         INTO   l_pid
         FROM   ligne_bip
         WHERE  pid = p_pid;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            pack_global.recuperer_message(20504, '%s1', p_pid, 'PID', l_msg);
            raise_application_error(-20504, l_msg);

        WHEN OTHERS THEN
           raise_application_error( -20997, SQLERRM);
      END;

      -- Gestion du niveau d'acces de l'utilisateur.

    -- On récupère le DPG de la ligne
          BEGIN
         SELECT codsg
         INTO   l_codsg
         FROM   ligne_bip
         WHERE  pid = p_pid;

          EXCEPTION

         WHEN NO_DATA_FOUND THEN
            pack_global.recuperer_message(20223, NULL, NULL, 'PID', l_msg);
            raise_application_error(-20223, l_msg);

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
          END;

    -- On récupère le CLICODE de la ligne
          BEGIN
         SELECT clicode
         INTO   l_clicode
         FROM   ligne_bip
         WHERE  pid = p_pid;

          EXCEPTION

         WHEN NO_DATA_FOUND THEN
            pack_global.recuperer_message(20373, NULL, NULL, 'PID', l_msg);
            raise_application_error(-20373, l_msg);

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
          END;


      -- ====================================================================
      -- Test appartenance du DPG au périmètre ME de l'utilisateur
      -- ====================================================================
        p_perime := 'N';
         l_habilitation := pack_habilitation.fhabili_me(l_codsg, p_userid);
    IF l_habilitation='vrai' THEN
        p_perime := 'O';
    ELSE
        IF('ME'=l_menu ) THEN
         -- Vous n'êtes pas autorisé à consulter cette ligne BIP, son DPG est
        Pack_Global.recuperer_message(20365, '%s1',  'consulter ou modifier cette ligne BIP, son DPG est '||l_codsg, 'PID', l_msg);
        RAISE_APPLICATION_ERROR(-20365, l_msg);
        END IF;
        -- OEL QC 1391 - END MODIF          
    END IF;

      -- ====================================================================
      -- Test appartenance du Code MO au périmètre MO de l'utilisateur
      -- ====================================================================
        p_perimo := 'N';


		if('MO'=l_menu)then
			l_perimo := pack_global.lire_globaldata(p_userid).perimcli;
		else
			l_perimo := pack_global.lire_globaldata(p_userid).perimo;
		end if;


    IF pack_habilitation.fverif_habili_mo(l_perimo, l_clicode) THEN
        p_perimo:='O';
    END IF;

      -- ====================================================================
      -- Si Ni perimètre ME ni périmètre MO alors message d'erreur Ligne hors périmètre
      -- ====================================================================
     IF p_perime = 'N' AND p_perimo = 'N' THEN
            pack_global.recuperer_message(20201, '%s1', p_pid, 'PID', l_msg);
            raise_application_error(-20201, l_msg);
     END IF;

    -- test de la date statut
    IF (l_menu <> 'DIR') THEN
        SELECT TO_CHAR(adatestatut,'DD/MM/YYYY'),nvl(astatut,'Pas de statut'),topfer INTO l_date_statut,l_statut,l_topfer
        FROM ligne_bip WHERE pid = p_pid;

        SELECT TO_NUMBER(TO_CHAR(adatestatut,'YYYY')) INTO l_date_statut_number
        FROM ligne_bip WHERE pid = p_pid;

        IF ((l_date_statut IS NOT NULL) AND (l_date_statut_number < to_number(p_bpannee))) THEN
        raise_application_error (-20000,'Vous ne pouvez pas modifier la ligne bip ' || p_pid ||
                    ' car son statut est ' || l_statut ||
                    ', son top fermeture est ' || l_topfer ||
                    ' et sa date de statut ou de top fermeture est ' || l_date_statut);
        END IF;
    END IF;


    -- Pas le droit de saisir sur des années antérieures
    SELECT TO_NUMBER(TO_CHAR(datdebex,'YYYY')) into l_datdebex from datdebex;
    IF l_datdebex > to_number(p_bpannee) THEN
        pack_global.recuperer_message(20313, '%s1', NULL, NULL, l_msg);
            raise_application_error(-20313, l_msg);
    END IF;

      -- Renvoie pnom de ligne_bip

      BEGIN
         SELECT pnom
         INTO   p_pnom
         FROM   ligne_bip
         WHERE  pid = p_pid;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            NULL;

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;



  -- Renvoie typproj de ligne_bip

     BEGIN
         SELECT typproj
         INTO   p_typproj
         FROM   ligne_bip
         WHERE  pid = p_pid;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            NULL;

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;


      -- Renvoie les valeurs pour l'affichage de proposes dc*

      -- Modification

     -- p_preproc := 'PreProc#' || 'UPDATE';
      p_mode  := 'update';

      BEGIN
         SELECT ligne_bip.pid,
                TO_CHAR(bpmontme, 'FM9999999990D00'),
                TO_CHAR(bpmontmo, 'FM9999999990D00'),
                TO_CHAR(budget.flaglock),
                TO_CHAR(bpdate,'DD/MM/YYYY'),
                TO_CHAR(bpmedate,'DD/MM/YYYY'),
                ubpmontme,
                ubpmontmo
         INTO   l_pid, p_bpmontme, p_bpmontmo, p_flaglock, p_bpdate, p_bpmedate, p_ubpmontme, p_ubpmontmo
         FROM   budget, ligne_bip
         WHERE  budget.pid = p_pid
         AND    ligne_bip.pid = p_pid
         AND    budget.annee = TO_NUMBER(p_bpannee);
      EXCEPTION

        WHEN NO_DATA_FOUND THEN

           -- Creation
           p_mode   :=  'insert';
           p_bpmontme  :=  '';
           p_bpmontmo  :=  '';
           p_flaglock :=  '';
           l_pid := NULL;
           p_bpdate := NULL;
           p_bpmedate := NULL;
           p_ubpmontme := NULL;
           p_ubpmontmo := NULL;
           NULL;

        WHEN OTHERS THEN
           raise_application_error( -20997, SQLERRM);
      END;

   END select_proposes;

END PACK_PROPOSES;
/


