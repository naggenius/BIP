-- pack_proposes_mass PL/SQL
-- 
-- Créé le 23/08/2004 par PJO
--
-- Modifié le 16/06/2005 par JMA : ajout filtre Client et Application
-- Modifié le 31/08/2005 par BAA : enlever le teste de l'habilitation MO
-- Modifié le 28/03/2006 par BAA : 
-- 11/06/2007 JAL : Fiche 556 exclusion lignes BIP type 9
-- 27/08/2009   YNA: TD 822 (lot 7.3) trace des modifications des budgets
-- 01/09/2009   YNA: TD 822 (lot 7.3) trace des modifications des budgets
-- 28/09/2009   ABA: TD 822 (lot 7.3) trace des modifications des budgets
-- 27/10/2009   YSB: TD 772 (lot 7.4) ajout du test périmétre mo dans la procédure select_propo_mass pour le menu client
-- 22/11/2011   BSA : QC 1268 - extension du user_rtfe de 7 a 30
-- 16/06/2012   OEL : QC 1391
--*******************************************************************
--

CREATE OR REPLACE PACKAGE     pack_proposes_mass AS

FUNCTION str_propo_mass     (    p_string     IN  VARCHAR2,
                                   p_occurence  IN  NUMBER
                                ) return VARCHAR2;

PROCEDURE select_propo_mass       (    p_codsg        IN  VARCHAR2,
                                        p_clicode          IN  VARCHAR2,
                                       p_airt       IN VARCHAR2,
                                       p_annee            IN  VARCHAR2,
                                       p_userid           IN  VARCHAR2,
                                      -- p_global  IN VARCHAR2,
                                       p_libcodsg    OUT struct_info.libdsg%TYPE,
                                       p_libclicode    OUT client_mo.clisigle%TYPE,
                                       p_libairt     OUT application.alibel%TYPE,
                                       p_nbpages    OUT VARCHAR2,
                                       p_numpage     OUT VARCHAR2,
                                       p_nbcurseur    OUT INTEGER,
                                       p_message    OUT VARCHAR2
                                       ,
                                       p_perime      OUT VARCHAR2,
                                       p_perimo      OUT VARCHAR2
                                      );

PROCEDURE update_propo_mass(        p_string    IN  VARCHAR2,
                                      p_userid    IN  VARCHAR2,
                                      p_nbcurseur OUT INTEGER,
                                      p_message   OUT VARCHAR2
                             );



TYPE clientdpg_liste_ViewType IS RECORD ( CLICODE VARCHAR2(5),
                                          CLIENT  VARCHAR2(100)
                                        );
TYPE clientdpg_listeCurType IS REF CURSOR RETURN clientdpg_liste_ViewType;
PROCEDURE lister_client_dpg( p_codsg     IN VARCHAR2,
                                p_userid     IN VARCHAR2,
                                p_curseur     IN OUT clientdpg_listeCurType
                            );
PROCEDURE lister_appli_dpg( p_codsg     IN VARCHAR2,
                                p_userid     IN VARCHAR2,
                                p_curseur     IN OUT clientdpg_listeCurType
                            );

END pack_proposes_mass;
/


CREATE OR REPLACE PACKAGE BODY     pack_proposes_mass AS

   FUNCTION str_propo_mass (    p_string     IN  VARCHAR2,
                               p_occurence  IN  NUMBER
                              ) return VARCHAR2 IS
   pos1 NUMBER(6);
   pos2 NUMBER(6);
   str  VARCHAR2(111);

   BEGIN

      pos1 := INSTR(p_string,';',1,p_occurence);
      pos2 := INSTR(p_string,';',1,p_occurence+1);

      IF pos2 != 1 THEN
         str := SUBSTR( p_string, pos1+1, pos2-pos1-1);
         return str;
      ELSE
         return '1';
      END IF;

   END str_propo_mass;




PROCEDURE select_propo_mass  (    p_codsg         IN VARCHAR2,
                                    p_clicode    IN VARCHAR2,
                                   p_airt       IN VARCHAR2,
                                   p_annee      IN VARCHAR2,
                                   p_userid     IN VARCHAR2,
                                  -- p_global  IN VARCHAR2,
                                   p_libcodsg     OUT struct_info.libdsg%TYPE,
                                   p_libclicode OUT client_mo.clisigle%TYPE,
                                   p_libairt     OUT application.alibel%TYPE,
                                   p_nbpages     OUT VARCHAR2,
                                   p_numpage      OUT VARCHAR2,
                                   p_nbcurseur     OUT INTEGER,
                                   p_message     OUT VARCHAR2
                                   ,
                                   p_perime      OUT VARCHAR2,
                                   p_perimo      OUT VARCHAR2
                              ) IS

      NB_LIGNES_MAXI     NUMBER(10);
      NB_LIGNES_PAGES   NUMBER(2);
      l_msg    VARCHAR2(1024);
      l_nbpages    NUMBER(10);
      l_habilitation    varchar2(10);
      l_codsg    VARCHAR2(10);
      l_perime    VARCHAR2(1000);
      l_perimo    VARCHAR2(1000);
      l_annee    VARCHAR2(4);
      l_menu VARCHAR2(255);


BEGIN
      -- Nombres de lignes BIP retournï¿½es Maxis :
      --Changed below value to 2000 as part of BIP-185
      --NB_LIGNES_MAXI := 500;
      NB_LIGNES_MAXI := 2000;
      -- Nombre de lignes BIP maxi par pages
      NB_LIGNES_PAGES := 10;

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur := 1;
      p_message := '';

      -- Récupérer les périmètres de l'utilisateur
      l_perime := pack_global.lire_globaldata(p_userid).perime ;
      l_menu := pack_global.lire_globaldata(p_userid).menutil;

        if('MO'=l_menu)then
            l_perimo := pack_global.lire_globaldata(p_userid).perimcli;
        else
            l_perimo := pack_global.lire_globaldata(p_userid).perimo;
        end if;


      p_numpage := 'NumPage#1';


          -- ====================================================================
          --  Pas de proposé sur une année passée
          -- ====================================================================
    SELECT TO_CHAR (datdebex, 'YYYY')
    INTO l_annee
    FROM datdebex
    WHERE rownum < 2;

    IF TO_NUMBER(p_annee) < TO_NUMBER(l_annee) THEN
        --('vous n etes pas autorisé à faire des proposés sur une année passée')
               pack_global.recuperer_message(20365, '%s1',  'faire des proposés sur une année passée','ANNEE', l_msg);
           raise_application_error(-20365,  l_msg);
    END IF;

    -- ===================================================================
    -- Test existence et appartenance du DPG au périmètre de l'utilisateur
    -- ===================================================================
    IF (p_codsg IS NOT NULL) AND (p_codsg != '*******') THEN
        
        IF('ME'=l_menu) THEN
            pack_habilitation.verif_habili_me(p_codsg, p_userid ,l_msg);
        
            IF(l_msg !='' or l_msg is not null) THEN
                p_perime:='N';
            ELSE
                p_perime:='O';
            END IF;
        END IF;
        --  QC 1281
        l_codsg := REPLACE(LPAD(p_codsg, 7, '0'),'*','%');
        /*
        IF SUBSTR(LPAD(p_codsg, 7, '0'),4,4) = '****' THEN
            l_codsg :=SUBSTR(LPAD(p_codsg, 7, '0'),1,3)||'%';
        ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) = '**' THEN
            l_codsg :=SUBSTR(LPAD(p_codsg, 7, '0'),1,5)||'%';
        ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) != '**' THEN
            l_codsg :=LPAD(p_codsg, 7, '0');
        END IF;
        */

    END IF;

    -- **************************************************************
    -- Controle du perim ME (FICHE QC 1391)
    -- ***************************************************************
    
    IF (l_perime is null or trim(l_perime) = '') THEN
          NULL;    
    ELSE
          IF ( PACK_HABILITATION.VERIF_PERIM_ME ( p_userid ) = 'KO' ) THEN
              p_perime:='N';
              -- Votre périmètre ME est invalide, veuillez contacter la MO.
              --pack_global.recuperer_message(21240, NULL, NULL, NULL, l_msg);
              --raise_application_error(-20327,l_msg);  
          ELSE
             p_perime:='O';
          END IF;    
    END IF;
   
    -- =======================================================================
    -- Test existence et appartenance du CLICODE au périmètre de l'utilisateur
    -- =======================================================================
    IF (l_menu = 'MO' or l_menu = 'ME') THEN
        IF (p_clicode IS NOT NULL) AND (p_clicode != '*****') THEN
            IF NOT pack_habilitation.fverif_habili_mo(l_perimo, p_clicode) THEN
                -- Message d'alerte 'Vous n'êtes pas habilité à ce code client
                 pack_global.recuperer_message(20737, '%s1', p_clicode, 'clicode', l_msg);
                     raise_application_error(-20737,l_msg);
                 p_perimo:='N';
            ELSE
                 p_perimo:='O';    
            END IF;
        END IF;
    END IF;
    
        
      -- =======================================
      -- On récupère le lib du DPG ou du clicode
      -- =======================================
      IF p_codsg IS NOT NULL THEN
          IF p_codsg = '*******' THEN
              p_libcodsg := 'Tout le Périmètre';
          ELSE
              -- On récupère le lib du DPG
              BEGIN

                IF SUBSTR(LPAD(p_codsg, 7, '0'),2,6) = '******' THEN
                    p_libcodsg := p_codsg;
                ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),3,5) = '*****' THEN
                    p_libcodsg := p_codsg;
                ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),4,4) = '****' THEN
                    SELECT sigdep INTO p_libcodsg FROM struct_info
                     WHERE TO_CHAR(codsg, 'FM0000000') LIKE l_codsg AND topfer='O' AND rownum < 2;
                ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),5,3) = '***' THEN
                    p_libcodsg := p_codsg;
                ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) = '**' THEN
                    SELECT sigdep || '/' || sigpole INTO p_libcodsg FROM struct_info
                     WHERE TO_CHAR(codsg, 'FM0000000') LIKE l_codsg AND topfer='O' AND rownum < 2;
                ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),7,1) = '*' THEN
                    p_libcodsg := p_codsg;
                ELSE
                    SELECT libdsg INTO p_libcodsg FROM struct_info
                     WHERE TO_CHAR(codsg, 'FM0000000') = p_codsg AND topfer='O' AND rownum < 2;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    pack_global.recuperer_message(20925, '%s1', p_codsg, 'codsg', l_msg);
                               raise_application_error(-20925,l_msg);

                WHEN OTHERS THEN
                          -- Message d'alerte Problème avec le libellé du DPG
                          pack_global.recuperer_message(20738, '%s1', p_codsg, 'codsg', l_msg);
                               raise_application_error(-20738,l_msg);
              END;
          END IF;
      END IF;

      IF p_clicode IS NOT NULL THEN
          IF p_clicode = '*****' THEN
              p_libclicode := 'Tout le Périmètre';
          ELSE
              -- On récupère le lib du clicode
              p_libclicode := pack_utile3b.f_get_clisigle_climo(p_clicode);
          END IF;
      END IF;


      IF (p_airt IS NULL) or (p_airt='') THEN
             p_libairt := 'Tout le Périmètre';
      ELSE
            -- On récupère le lib de l'application
          IF (pack_utile3b.f_verif_airt_application(p_airt)) THEN
              BEGIN
                  SELECT alibel INTO p_libairt
                    FROM application
                   WHERE airt = p_airt;
              EXCEPTION
                  WHEN OTHERS THEN
                         p_libairt := '';
              END;
          ELSE
                p_libairt := 'Code application inconnu';
          END IF;
      END IF;

      -- =======================================
      -- On récupère le nombre de lignes
      -- =======================================

      -- Si c'est un code ME = *****
      IF (p_codsg IS NOT NULL) AND (p_codsg = '*******') THEN
          BEGIN
            -- Compte le nombre de lignes et test si on a des pid
             SELECT count(*)
             INTO   l_nbpages
             FROM   budget budg, ligne_bip bip, vue_dpg_perime vdp
             WHERE  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  ((bip.adatestatut is null) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
               AND  bip.codsg = vdp.codsg
               AND  bip.TYPPROJ != '9'
               AND  INSTR(l_perime, vdp.codbddpg) > 0
               AND  (p_airt is null or p_airt = bip.AIRT)
               AND  (p_clicode is null or p_clicode = bip.CLICODE);
         -- inutile de tester SQL%NOTFOUND car fonction de groupe renvoie toujours soit NULL, soit une valeur

         IF (l_nbpages = 0) THEN
               pack_global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               raise_application_error(-20373 , l_msg);
             ELSIF (l_nbpages > NB_LIGNES_MAXI) THEN
               pack_global.recuperer_message( 20381 , '%s1', p_codsg, 'codsg', l_msg);
               raise_application_error(-20381 , l_msg);
             END IF;

             l_nbpages := CEIL(l_nbpages/NB_LIGNES_PAGES);
             p_nbpages := 'NbPages#'|| l_nbpages;
          EXCEPTION
           WHEN NO_DATA_FOUND THEN
               pack_global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               raise_application_error(-20373 , l_msg);

           WHEN OTHERS THEN
             raise_application_error( -20997, SQLERRM);
          END;


     -- Si c'est un code ME != *******
     ELSIF (p_codsg IS NOT NULL) THEN
          BEGIN
            -- Compte le nombre de lignes et test si on a des pid
             SELECT count(*)
             INTO   l_nbpages
             FROM   budget budg, ligne_bip bip
             WHERE  TO_CHAR(bip.codsg, 'FM0000000') LIKE l_codsg
               AND  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  bip.TYPPROJ != '9'
               AND  ((bip.adatestatut is null) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
               AND  (p_airt is null or p_airt = bip.AIRT)
               AND  (p_clicode is null or p_clicode = bip.CLICODE);
         -- inutile de tester SQL%NOTFOUND car fonction de groupe renvoie toujours soit NULL, soit une valeur

         IF (l_nbpages = 0) THEN
               pack_global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               raise_application_error(-20373 , l_msg);
             ELSIF (l_nbpages > NB_LIGNES_MAXI) THEN
               pack_global.recuperer_message( 20381 , '%s1', p_codsg, 'codsg', l_msg);
               raise_application_error(-20381 , l_msg);
             END IF;

             l_nbpages := CEIL(l_nbpages/NB_LIGNES_PAGES);
             p_nbpages := 'NbPages#'|| l_nbpages;
          EXCEPTION
           WHEN NO_DATA_FOUND THEN
               pack_global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               raise_application_error(-20373 , l_msg);

           WHEN OTHERS THEN
             raise_application_error( -20997, SQLERRM);
          END;
     END IF;


      -- Si c'est un code MO = *****
      -- JMAS 13/06/2005 : ajout de la condition "AND (p_codsg IS NULL)" pour différencier "Mes Lignes" de "Lignes Clients"
      IF (p_clicode IS NOT NULL) AND (p_clicode = '*****') AND (p_codsg IS NULL) THEN
          BEGIN
            -- Compte le nombre de lignes et test si on a des pid
             SELECT count(*)
             INTO   l_nbpages
             FROM   budget budg, ligne_bip bip, vue_clicode_perimo vcp
             WHERE  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  bip.TYPPROJ != '9'
               AND  ((bip.adatestatut is null) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
               AND  bip.clicode = vcp.clicode
               --AND  INSTR(l_perimo, vcp.bdclicode) > 0
               AND  (p_airt is null or p_airt = bip.AIRT);
         -- inutile de tester SQL%NOTFOUND car fonction de groupe renvoie toujours soit NULL, soit une valeur

            IF (l_nbpages = 0) THEN
               pack_global.recuperer_message( 20373 , '%s1', p_clicode, 'clicode', l_msg);
               raise_application_error(-20373 , l_msg);
            ELSIF (l_nbpages > NB_LIGNES_MAXI) THEN
               pack_global.recuperer_message( 20381 , '%s1', p_clicode, 'clicode', l_msg);
               raise_application_error(-20381 , l_msg);
            END IF;

             l_nbpages := CEIL(l_nbpages/NB_LIGNES_PAGES);
             p_nbpages := 'NbPages#'|| l_nbpages;
          EXCEPTION
           WHEN NO_DATA_FOUND THEN
               pack_global.recuperer_message( 20373 , '%s1', p_clicode, 'clicode', l_msg);
               raise_application_error(-20373 , l_msg);

           WHEN OTHERS THEN
             raise_application_error( -20997, SQLERRM);
          END;


     -- Si c'est un code MO != *****
     -- JMAS 13/06/2005 : ajout de la condition "AND (p_codsg IS NULL)" pour différencier "Mes Lignes" de "Lignes Clients"
     ELSIF (p_clicode IS NOT NULL) AND (p_codsg IS NULL) THEN
          BEGIN
            -- Compte le nombre de lignes et test si on a des pid
             SELECT count(*)
             INTO   l_nbpages
             FROM   budget budg, ligne_bip bip
             WHERE  bip.clicode  = p_clicode
               AND  budg.annee(+) = TO_NUMBER(p_annee)
               AND  budg.pid (+)= bip.pid
               AND  bip.TYPPROJ != '9'
               AND  ((bip.adatestatut is null) OR (TO_NUMBER(TO_CHAR(bip.adatestatut,'YYYY') ) >= TO_NUMBER(p_annee)))
               AND  (p_airt is null or p_airt = bip.AIRT);
         -- inutile de tester SQL%NOTFOUND car fonction de groupe renvoie toujours soit NULL, soit une valeur

         IF (l_nbpages = 0) THEN
               pack_global.recuperer_message( 20373 , '%s1', p_clicode, 'clicode', l_msg);
               raise_application_error(-20373 , l_msg);
             -- Si > 500, pas de saisie en masse possible car il n'y a pas de plus petit périmètre que le clicode
             ELSIF (l_nbpages > NB_LIGNES_MAXI) THEN
               pack_global.recuperer_message( 20382 , '%s1', p_clicode, 'clicode', l_msg);
               raise_application_error(-20382 , l_msg);
             END IF;

             l_nbpages := CEIL(l_nbpages/NB_LIGNES_PAGES);
             p_nbpages := 'NbPages#'|| l_nbpages;
          EXCEPTION
           WHEN NO_DATA_FOUND THEN
               pack_global.recuperer_message( 20373 , '%s1', p_clicode, 'clicode', l_msg);
               raise_application_error(-20373 , l_msg);

           WHEN OTHERS THEN
             raise_application_error( -20997, SQLERRM);
          END;
     END IF;

      p_message := l_msg;


  END select_propo_mass;



  PROCEDURE update_propo_mass(        p_string    IN  VARCHAR2,
                                      p_userid    IN  VARCHAR2,
                                      p_nbcurseur OUT INTEGER,
                                      p_message   OUT VARCHAR2
                                 ) IS

   l_msg        VARCHAR2(10000);
   l_cpt        NUMBER(7);
   l_bpannee      budget.annee%TYPE;
   l_pid        ligne_bip.pid%TYPE;
   l_bpmontme    VARCHAR2(15);
   l_bpmontmo     VARCHAR2(15);
   l_flaglock   budget.flaglock%TYPE;
   l_exist     NUMBER;
   l_user VARCHAR2(30);
   old_bpmontme VARCHAR2(15);
   old_bpmontmo VARCHAR2(15);

   BEGIN


      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message   := '';
      l_cpt       := 1;
      l_bpannee := TO_NUMBER(pack_proposes_mass.str_propo_mass(p_string,l_cpt));

      l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege,1,30);


      WHILE l_cpt != 0 LOOP
    if l_cpt!=1 then
        l_pid := pack_proposes_mass.str_propo_mass(p_string,l_cpt);
        l_flaglock   := TO_NUMBER(pack_proposes_mass.str_propo_mass(p_string,l_cpt+1));
        l_bpmontme := pack_proposes_mass.str_propo_mass(p_string,l_cpt+2);
        l_bpmontmo := pack_proposes_mass.str_propo_mass(p_string,l_cpt+3);
    else
            l_pid := pack_proposes_mass.str_propo_mass(p_string,l_cpt+1);
             l_flaglock   := TO_NUMBER(pack_proposes_mass.str_propo_mass(p_string,l_cpt+2));
        l_bpmontme := pack_proposes_mass.str_propo_mass(p_string,l_cpt+3);
        l_bpmontmo := pack_proposes_mass.str_propo_mass(p_string,l_cpt+4);
    end if;


        IF l_pid != '0' THEN


      -- Existence de la ligne bip dans prop_budget
             BEGIN
        select 1 into l_exist
        from budget
        where pid=l_pid
        and   annee = l_bpannee;
             EXCEPTION
        WHEN NO_DATA_FOUND THEN
        --Création de la ligne dans la table BUDGET
          --Création de la ligne dans la table BUDGET

              IF ((l_bpmontme is not null) or (l_bpmontme != '')) THEN



                INSERT INTO budget (annee, bpdate, bpmontme, flaglock, pid, ubpmontme)
                VALUES (l_bpannee,  sysdate, to_number(l_bpmontme), 0, l_pid, l_user);
                --YNI
              Pack_Ligne_Bip.maj_ligne_bip_logs(l_pid, l_user, 'proposé fournisseur ' || l_bpannee, null, to_char(l_bpmontme), 'Creation en masse/Mes_lignes_propo_frs');
                --YNI
              END IF;


              IF ((l_bpmontmo is not null) or (l_bpmontmo != ''))  THEN
               INSERT INTO budget (annee, bpmedate, bpmontmo, flaglock, pid, ubpmontmo)
              VALUES (l_bpannee,  sysdate, to_number(l_bpmontmo), 0, l_pid, l_user);
              --YNI
            Pack_Ligne_Bip.maj_ligne_bip_logs(l_pid, l_user, 'proposé client ' || l_bpannee, null, to_char(l_bpmontmo), 'Creation en masse/Mes_lignes_propo_cli');
              --YNI
             END IF;
         END;

        IF l_exist=1 THEN
         --Mise à jour de la table PROP_BUDGET

         BEGIN
          select to_char(replace(to_char(bpmontme,'FM999999999990D00'),'.',',')) into old_bpmontme
            from budget
            where pid=l_pid
            and   annee = l_bpannee;
         EXCEPTION WHEN
         NO_DATA_FOUND then
            old_bpmontme := ' ';
         END;


         BEGIN
          select replace(to_char(bpmontmo,'FM999999999990D00'),'.',',')   into old_bpmontmo
            from budget
            where pid=l_pid
            and   annee = l_bpannee;
         EXCEPTION WHEN
         NO_DATA_FOUND then
            old_bpmontmo := ' ';
         END;

                --YNI update des champs "budget proposé fournisseur"

               IF (nvl(l_bpmontme,' ') <> nvl(old_bpmontme,' ')) THEN

                    UPDATE budget SET
                                      bpdate  =  sysdate,
                                      bpmontme = l_bpmontme,
                                      ubpmontme = l_user,
                                      flaglock = decode( l_flaglock, 1000000, 0, l_flaglock + 1)
                    WHERE pid = l_pid
                AND annee = l_bpannee;
                --AND flaglock = l_flaglock;
                --YNI
               Pack_Ligne_Bip.maj_ligne_bip_logs(l_pid, l_user, 'proposé fournisseur ' || l_bpannee, to_char(old_bpmontme,'FM999999990D00'), to_char(l_bpmontme,'FM999999990D00'), 'Modification en masse/Mes_lignes_propo_frs');
                --YNI
            END IF;

              --YNI update des champs "budget proposï¿½ client"

               IF (nvl(l_bpmontmo, ' ') != nvl(old_bpmontmo,' ') ) THEN
                     UPDATE budget SET
                                      bpmedate  = to_date(sysdate,'DD/MM/RRRR'),
                                      bpmontmo = l_bpmontmo,
                                      ubpmontmo = l_user,
                                      flaglock = decode( l_flaglock, 1000000, 0, l_flaglock + 1)
                    WHERE pid = l_pid
                AND annee = l_bpannee;
                --AND flaglock = l_flaglock;
                --YNI
               Pack_Ligne_Bip.maj_ligne_bip_logs(l_pid, l_user, 'proposé client ' || l_bpannee, to_char(old_bpmontmo,'FM999999990D00'), to_char(l_bpmontmo,'FM999999990D00'), 'Modification en masse/Mes_lignes_propo_cli');
                --YNI
              END IF;



         END IF;

        if l_cpt=1 then       --pris en compte de l'annï¿½e au dï¿½but de la chaï¿½ne {;annee;pid;flaglock;bpmontme;bpmontmo;pid;flaglock;bpmontme;bpmontmo;..;}
        l_cpt := l_cpt + 5;

        else
                l_cpt := l_cpt + 4;
        end if;

         ELSE
            l_cpt :=0;
         END IF;

      END LOOP;

   pack_global.recuperer_message( 20972 , '%s1', 'Proposé de l''année', '', p_message);

   END update_propo_mass;



--*************************************************************************************************
-- Procï¿½dure lister_client_dpg
--
-- Sï¿½lectionne la liste des clients disponible pour un DPG donnï¿½
--
-- ************************************************************************************************
PROCEDURE lister_client_dpg( p_codsg     IN VARCHAR2,
                                p_userid     IN VARCHAR2,
                                p_curseur     IN OUT clientdpg_listeCurType
                             ) IS
    l_msg VARCHAR2(1024);
    l_codsg VARCHAR2(10);
    l_perimo    VARCHAR2(1000);
    l_menu VARCHAR2(25);

BEGIN

        l_menu := pack_global.lire_globaldata(p_userid).menutil;

        if('MO'=l_menu)then
            l_perimo := pack_global.lire_globaldata(p_userid).perimcli;
        else
            l_perimo := pack_global.lire_globaldata(p_userid).perimo;
        end if;




    IF (p_codsg IS NOT NULL) AND (p_codsg != '*******') THEN
           --pack_habilitation.verif_habili_me(p_codsg, p_userid ,l_msg);
           NULL;
    END IF;

    -- On formatte l_codsg QC 1281
    l_codsg := REPLACE(LPAD(p_codsg, 7, '0'),'*','%');
/*
    IF (p_codsg = '*******') THEN
        l_codsg := '%';
    ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),4,4) = '****' THEN
        l_codsg :=SUBSTR(LPAD(p_codsg, 7, '0'),1,3)||'%';
    ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) = '**' THEN
        l_codsg :=SUBSTR(LPAD(p_codsg, 7, '0'),1,5)||'%';
    ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) != '**' THEN
        l_codsg :=LPAD(p_codsg, 7, '0');
    END IF;
*/
    BEGIN
           OPEN p_curseur FOR
          SELECT DISTINCT l.CLICODE, c.CLISIGLE||DECODE(c.CLISIGLE,c.CLILIB,'',' - '||c.CLILIB) CLIENT
            FROM LIGNE_BIP l, CLIENT_MO c
            WHERE  l.clicode = c.clicode
                  AND TO_CHAR(l.codsg, 'FM0000000') LIKE l_codsg
                  AND l.ADATESTATUT is null
            UNION
            SELECT null, '' FROM dual
            ORDER by 2,1;

    EXCEPTION
        WHEN OTHERS THEN
               raise_application_error( -20997, SQLERRM);
    END;

END lister_client_dpg;


--*************************************************************************************************
-- Procï¿½dure lister_appli_dpg
--
-- Sï¿½lectionne la liste des applications disponible pour un DPG donnï¿½
--
-- ************************************************************************************************
PROCEDURE lister_appli_dpg( p_codsg     IN VARCHAR2,
                                p_userid     IN VARCHAR2,
                                p_curseur     IN OUT clientdpg_listeCurType
                             ) IS
    l_msg VARCHAR2(1024);
    l_codsg VARCHAR2(10);
    
    
BEGIN
    
    IF (p_codsg IS NOT NULL) AND (p_codsg != '*******') THEN
          --pack_habilitation.verif_habili_me(p_codsg, p_userid ,l_msg);
          NULL;
    END IF;

    -- On formatte l_codsg QC 1281
    l_codsg := REPLACE(LPAD(p_codsg, 7, '0'),'*','%');
/*
    IF (p_codsg = '*******') THEN
        l_codsg := '%';
    ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),4,4) = '****' THEN
        l_codsg :=SUBSTR(LPAD(p_codsg, 7, '0'),1,3)||'%';
    ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) = '**' THEN
        l_codsg :=SUBSTR(LPAD(p_codsg, 7, '0'),1,5)||'%';
    ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) != '**' THEN
        l_codsg :=LPAD(p_codsg, 7, '0');
    END IF;
*/
    BEGIN
           OPEN p_curseur FOR
               SELECT l.AIRT, a.alibel APPLI
                 FROM LIGNE_BIP l, APPLICATION a
                WHERE l.AIRT = a.AIRT
               AND TO_CHAR(l.codsg, 'FM0000000') LIKE l_codsg
               AND l.ADATESTATUT is null
             GROUP by l.AIRT, a.alibel
            UNION
            select null, '' from dual
                ORDER by 2, 1;
    EXCEPTION
        WHEN OTHERS THEN
               raise_application_error( -20997, SQLERRM);
    END;

END lister_appli_dpg;


END pack_proposes_mass;
/
