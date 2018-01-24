create or replace PACKAGE "PACK_CONTRAT" AS


   TYPE ContRecType IS RECORD (soccont      CONTRAT.soccont%TYPE,
                               soclib       SOCIETE.soclib%TYPE,
                               numcont      CONTRAT.numcont%TYPE,
                               cav          CONTRAT.cav%TYPE,
                               cagrement    CONTRAT.cagrement%TYPE,
                               NICHE        VARCHAR2(20),
                               cnaffair     CONTRAT.cnaffair%TYPE,
                               crang        CONTRAT.crang%TYPE,
                               cdatarr      VARCHAR2(20),
                               cobjet1      CONTRAT.cobjet1%TYPE,
                               cobjet2      CONTRAT.cobjet2%TYPE,
                               crem         CONTRAT.crem%TYPE,
                               codsg        VARCHAR2(20),
                               comcode      VARCHAR2(20),
                               ctypfact     CONTRAT.ctypfact%TYPE,
                               ccoutht      VARCHAR2(20),
                               ccharesti    VARCHAR2(20),
                               cdatdeb      VARCHAR2(10),
                               cdatfin      VARCHAR2(10),
                               flaglock     VARCHAR2(20),
                               siren        VARCHAR2(9),
							   sourcectr 	CONTRAT.orictr%TYPE
                              );

   TYPE ContCurType IS REF CURSOR RETURN ContRecType;

   PROCEDURE insert_contrat (p_test     IN  VARCHAR2,
                             p_soccont   IN  CONTRAT.soccont%TYPE,
                             p_soclib    IN  SOCIETE.soclib%TYPE,
                             p_numcont   IN  CONTRAT.numcont%TYPE,
                             p_cav       IN  CONTRAT.cav%TYPE,
                             p_cagrement IN  CONTRAT.cagrement%TYPE,
                             p_niche     IN  VARCHAR2,
                             p_cnaffair  IN  CONTRAT.cnaffair%TYPE,
                             p_crang     IN  CONTRAT.crang%TYPE,
                             p_cdatarr   IN  VARCHAR2,
                             p_cobjet1   IN  CONTRAT.cobjet1%TYPE,
                             p_cobjet2   IN  CONTRAT.cobjet2%TYPE,
                             p_crem      IN  CONTRAT.crem%TYPE,
                             p_codsg     IN  VARCHAR2,
                             p_comcode   IN  VARCHAR2,
                             p_ctypfact  IN  CONTRAT.ctypfact%TYPE,
                             p_ccoutht   IN  VARCHAR2,
                             p_ccharesti IN  VARCHAR2,
                             p_cdatdeb   IN  VARCHAR2,
                             p_cdatfin   IN  VARCHAR2,
                             p_userid    IN  VARCHAR2,
                             p_siren IN VARCHAR2,
							 p_source IN CONTRAT.orictr%TYPE,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            );

   PROCEDURE update_contrat (p_test     IN  VARCHAR2,
                             p_soccont   IN  CONTRAT.soccont%TYPE,
                             p_soclib    IN  SOCIETE.soclib%TYPE,
                             p_numcont   IN  CONTRAT.numcont%TYPE,
                             p_cav       IN  CONTRAT.cav%TYPE,
                             p_cagrement IN  CONTRAT.cagrement%TYPE,
                             p_niche     IN  VARCHAR2,
                             p_cnaffair  IN  CONTRAT.cnaffair%TYPE,
                             p_crang     IN  CONTRAT.crang%TYPE,
                             p_cdatarr   IN  VARCHAR2,
                             p_cobjet1   IN  CONTRAT.cobjet1%TYPE,
                             p_cobjet2   IN  CONTRAT.cobjet2%TYPE,
                             p_crem      IN  CONTRAT.crem%TYPE,
                             p_codsg     IN  VARCHAR2,
                             p_comcode   IN  VARCHAR2,
                             p_ctypfact  IN  CONTRAT.ctypfact%TYPE,
                             p_ccoutht   IN  VARCHAR2,
                             p_ccharesti IN  VARCHAR2,
                             p_cdatdeb   IN  VARCHAR2,
                             p_cdatfin   IN  VARCHAR2,
                             p_flaglock  IN  NUMBER,
                             p_userid    IN  VARCHAR2,
                             p_siren IN VARCHAR2,
							 p_source IN CONTRAT.orictr%TYPE,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            );

   PROCEDURE delete_contrat (p_test     IN  VARCHAR2,
                             p_soccont   IN  CONTRAT.soccont%TYPE,
                             p_soclib    IN  SOCIETE.soclib%TYPE,
                             p_numcont   IN  CONTRAT.numcont%TYPE,
                             p_cav       IN  CONTRAT.cav%TYPE,
                             p_cagrement IN  CONTRAT.cagrement%TYPE,
                             p_niche     IN  VARCHAR2,
                             p_cnaffair  IN  CONTRAT.cnaffair%TYPE,
                             p_crang     IN  CONTRAT.crang%TYPE,
                             p_cdatarr   IN  VARCHAR2,
                             p_cobjet1   IN  CONTRAT.cobjet1%TYPE,
                             p_cobjet2   IN  CONTRAT.cobjet2%TYPE,
                             p_crem      IN  CONTRAT.crem%TYPE,
                             p_codsg     IN  VARCHAR2,
                             p_comcode   IN  VARCHAR2,
                             p_ctypfact  IN  CONTRAT.ctypfact%TYPE,
                             p_ccoutht   IN  VARCHAR2,
                             p_ccharesti IN  VARCHAR2,
                             p_cdatdeb   IN  VARCHAR2,
                             p_cdatfin   IN  VARCHAR2,
                             p_flaglock  IN  NUMBER,
                             p_userid    IN  VARCHAR2,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            );

   PROCEDURE select_contrat (p_mode    IN VARCHAR2,
                             p_test     IN VARCHAR2,
                             p_soccont   IN CONTRAT.soccont%TYPE,
                             p_numcont   IN CONTRAT.numcont%TYPE,
                             p_cav       IN CONTRAT.cav%TYPE,
                             p_userid    IN VARCHAR2,
                             p_curcont   IN OUT ContCurType,
                             p_socout       OUT VARCHAR2,
                         p_cavout       OUT VARCHAR2,
                             p_choixout     OUT VARCHAR2,
                 p_cnaffout     OUT VARCHAR2,
                 p_codsg        OUT VARCHAR2,
                 p_comcode      OUT VARCHAR2,
                 p_cobjet1      OUT VARCHAR2,
                             p_cobjet2      OUT VARCHAR2,
                             p_nbcurseur    OUT INTEGER,
                             p_message      OUT VARCHAR2
                            );


 PROCEDURE maj_contrats_logs(   p_numcont        IN CONTRATS_LOGS.numcont%TYPE,
                                p_siren         IN CONTRATS_LOGS.siren%TYPE,
                                p_soccont       IN CONTRATS_LOGS.soccont%TYPE,
                                p_cav           IN CONTRATS_LOGS.cav%TYPE,
                                p_codsg         IN CONTRATS_LOGS.codsg%TYPE,
                                p_lcnum          IN CONTRATS_LOGS.lcnum%TYPE,
                                   p_user_log        IN CONTRATS_LOGS.user_log%TYPE,
                                p_table          IN CONTRATS_LOGS.nom_table%TYPE,
                                   p_colonne        IN CONTRATS_LOGS.colonne%TYPE,
                                   p_valeur_prec    IN CONTRATS_LOGS.valeur_prec%TYPE,
                                   p_valeur_nouv    IN CONTRATS_LOGS.valeur_nouv%TYPE,
                                p_cdatdeb       IN CONTRATS_LOGS.cdatdeb%TYPE,
                                p_cdatfin       IN CONTRATS_LOGS.cdatfin%TYPE,
                                p_type_action   IN CONTRATS_LOGS.type_action%TYPE,
                                   p_commentaire    IN CONTRATS_LOGS.commentaire%TYPE
                               );

    PROCEDURE LISTER_SIREN_AGENCE(p_code IN VARCHAR2,
                                p_curSiren  IN OUT Pack_Liste_Dynamique.liste_dyn );

TYPE Cont2RecType IS RECORD (code             AGENCE.SOCCODE%TYPE,
                             fournisseur      AGENCE.SOCFLIB%TYPE,
                             siren            CONTRAT.SIREN%TYPE,
                             nom              RESSOURCE.RNOM%TYPE,
                             prenom           RESSOURCE.RPRENOM%TYPE,
                             ident            RESSOURCE.IDENT%TYPE,
                             num_contrat      CONTRAT.NUMCONT%TYPE,
                             cav              CONTRAT.CAV%TYPE,
                             dpg              STRUCT_INFO.LIBDSG%TYPE,
                             datdeb           LIGNE_CONT.LRESDEB%TYPE,
                             datfin           LIGNE_CONT.LRESFIN%TYPE
                              );
TYPE Cont2CurType IS REF CURSOR RETURN Cont2RecType;

    PROCEDURE LISTER_CONTRAT (p_ident    IN LIGNE_CONT.IDENT%TYPE,
                             p_numcont     IN CONTRAT.NUMCONT%TYPE,
                             p_siren   IN CONTRAT.SIREN%TYPE,
                             p_userid    IN VARCHAR2,
                             p_curcont   IN OUT Cont2CurType,
                             p_nbcurseur    OUT INTEGER,
                             p_message      OUT VARCHAR2
                            );


    PROCEDURE LISTER_CONTRAT_PERIM (p_ident    IN LIGNE_CONT.IDENT%TYPE,
                             p_numcont     IN CONTRAT.NUMCONT%TYPE,
                             p_siren   IN CONTRAT.SIREN%TYPE,
                             p_userid    IN VARCHAR2,
                             p_liste_centre_frais IN VARCHAR2,
                             p_curcont   IN OUT Cont2CurType,
                             p_nbcurseur    OUT INTEGER,
                             p_message      OUT VARCHAR2
                            );

    PROCEDURE LISTER_CONTRAT_ORD (p_ident    IN LIGNE_CONT.IDENT%TYPE,
                             p_numcont     IN CONTRAT.NUMCONT%TYPE,
                             p_siren   IN CONTRAT.SIREN%TYPE,
                             p_userid    IN VARCHAR2,
                             p_liste_centre_frais IN VARCHAR2,
                             p_curcont   IN OUT Cont2CurType,
                             p_nbcurseur    OUT INTEGER,
                             p_message      OUT VARCHAR2
                            );


  FUNCTION get_cout_situ_comp(p_ident IN VARCHAR2,
                              p_soccont IN VARCHAR2,
                              p_lresdeb IN DATE,
                              p_lresfin IN DATE) RETURN NUMBER;

  --PPM 59805 : KRA
  FUNCTION INSERT_TMP_CONTRATRF(p_critereDosPac IN  VARCHAR2,
                              p_champsDosPac IN VARCHAR2,
                              p_critereRefCon IN VARCHAR2,
                              p_champsRefCon IN VARCHAR2,
                              p_critereRefAve IN VARCHAR2,
                              p_champsRefAve IN VARCHAR2,
                              p_critereNom IN VARCHAR2,
                              p_champsNom IN VARCHAR2,
                              p_critereIgg IN VARCHAR2,
                              p_champsIgg IN VARCHAR2,
                              p_critereMatArp IN VARCHAR2,
                              p_champsMatArp IN VARCHAR2,
                              p_critereIdenBip IN VARCHAR2,
                              p_champsIdenBip IN VARCHAR2,
                              p_critereRefFac IN VARCHAR2,
                              p_champsRefFac IN VARCHAR2,
                              p_critereRefExp IN VARCHAR2,
                              p_champsRefExp IN VARCHAR2,
                              p_champsRacine IN VARCHAR2,
                              p_champsAvenant IN VARCHAR2,
                              p_global IN VARCHAR2,
                              p_centrefrais IN VARCHAR2,
                              p_arborescence IN VARCHAR2) RETURN NUMBER;  
PROCEDURE TRACE_LOGS(P_HFILE utl_file.file_type, P_PROCNAME IN  VARCHAR2,P_TEXT IN  VARCHAR2, P_CHAINE IN  VARCHAR2, p_maxvarchar IN  NUMBER);                              

PROCEDURE  calculRequete(cas IN  VARCHAR2,
                        requete IN OUT VARCHAR2,
                        critereDosPac IN  VARCHAR2,
                        critereRefCon IN  VARCHAR2,
                        critereRefAve IN  VARCHAR2,
                        critereNom IN  VARCHAR2,
                        critereIgg IN  VARCHAR2,
                        critereMatArp IN  VARCHAR2,
                        critereIdenBip IN  VARCHAR2,
                        critereRefFac IN  VARCHAR2,
                        critereRefExp IN  VARCHAR2,
                        champsDosPac IN  VARCHAR2,
                        champsRefCon IN  VARCHAR2,
                        champsRefAve IN  VARCHAR2,
                        champsNom IN  VARCHAR2,
                        champsIgg1 IN  VARCHAR2,
                        champsIgg2 IN  VARCHAR2,
                        champsMatArp1 IN  VARCHAR2,
                        champsMatArp2 IN  VARCHAR2,
                        champsIdenBip IN  VARCHAR2,
                        champsRefFac IN  VARCHAR2,
                        champsRefExp IN  VARCHAR2,
                        champsRacine IN  VARCHAR2,
                        champsAvenant IN  VARCHAR2,
                        req_centre_frais IN  VARCHAR2,
                        req_dpg_perim_me  IN  VARCHAR2,
                        isClone IN BOOLEAN);--PPM 1691 : 27/03/2015 (clone)
                          
 PROCEDURE select_contratrf( P_param6     IN  VARCHAR2,
                            p_message   OUT VARCHAR2
                          );

END Pack_Contrat;
/
create or replace PACKAGE BODY "PACK_CONTRAT" AS


      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

   PROCEDURE insert_contrat (p_test     IN  VARCHAR2,
                             p_soccont   IN  CONTRAT.soccont%TYPE,
                             p_soclib    IN  SOCIETE.soclib%TYPE,
                             p_numcont   IN  CONTRAT.numcont%TYPE,
                             p_cav       IN  CONTRAT.cav%TYPE,
                             p_cagrement IN  CONTRAT.cagrement%TYPE,
                             p_niche     IN  VARCHAR2,
                             p_cnaffair  IN  CONTRAT.cnaffair%TYPE,
                             p_crang     IN  CONTRAT.crang%TYPE,
                             p_cdatarr   IN  VARCHAR2,
                             p_cobjet1   IN  CONTRAT.cobjet1%TYPE,
                             p_cobjet2   IN  CONTRAT.cobjet2%TYPE,
                             p_crem      IN  CONTRAT.crem%TYPE,
                             p_codsg     IN  VARCHAR2,
                             p_comcode   IN  VARCHAR2,
                             p_ctypfact  IN  CONTRAT.ctypfact%TYPE,
                             p_ccoutht   IN  VARCHAR2,
                             p_ccharesti IN  VARCHAR2,
                             p_cdatdeb   IN  VARCHAR2,
                             p_cdatfin   IN  VARCHAR2,
                             p_userid    IN  VARCHAR2,
                             p_siren IN VARCHAR2,
							 p_source IN CONTRAT.orictr%TYPE,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            ) IS

   l_msg VARCHAR2(1024);
   l_cdatarr NUMBER;
   l_filcode FILIALE_CLI.filcode%TYPE;
   l_topfer  STRUCT_INFO.topfer%TYPE;
   l_centre_frais NUMBER(3);
   l_scentrefrais NUMBER(3);
   l_user        CONTRATS_LOGS.user_log%TYPE;
   l_sousmenus   VARCHAR2(1024);
   referential_integrity EXCEPTION;
   PRAGMA EXCEPTION_INIT(referential_integrity, -2291);
   l_cav VARCHAR2(3);
   l_ach30  CHAR;


   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      -- On recupere le code filiale de l'utilisateur

      l_filcode := Pack_Global.lire_globaldata(p_userid).filcode;

      -- On récupère le code centre de frais de l'utilisateur
      l_centre_frais:=Pack_Global.lire_globaldata(p_userid).codcfrais;

      -- On récupère le matricule de l'utilisateur
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      -- On récupère le matricule de l'utilisateur
      l_sousmenus := Pack_Global.lire_globaldata(p_userid).sousmenus;
      -- On récupère le matricule de l'utilisateur
      l_sousmenus := Pack_Global.lire_globaldata(p_userid).sousmenus;

      l_cav := lpad(nvl(p_cav,'0'),3,'0');

      -- determine si le contrat est au format 27+3
      if  (INSTR(l_sousmenus,'ach30') >0) then
        l_ach30 := 'O';
      else
        l_ach30 := 'N';
      end if;

      -- TEST date d'arrivee a GES/ACH doit etre > a date du jour

      SELECT TO_NUMBER(MONTHS_BETWEEN(TRUNC(SYSDATE), TRUNC(TO_DATE(p_cdatarr,'DD/MM/YYYY'))))
      INTO   l_cdatarr
      FROM   DUAL;

      IF l_cdatarr < 0 THEN
        IF INSTR(l_sousmenus,'supach') >0 THEN
            Pack_Global.recuperer_message(20283,NULL, NULL,NULL, l_msg);
            p_message:=p_message ||'\n'|| l_msg;
            ELSE
            Pack_Global.recuperer_message(20283,NULL, NULL,'CDATARR', l_msg);
            RAISE_APPLICATION_ERROR(-20283 , l_msg );

        END IF;
      END IF;

      -- Test le DPG non ouvert donc fermer

      BEGIN
         SELECT topfer , scentrefrais
         INTO   l_topfer, l_scentrefrais
         FROM   STRUCT_INFO
         WHERE  codsg = TO_NUMBER(p_codsg);

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            Pack_Global.recuperer_message(20203, NULL, NULL, 'CODSG', l_msg);
            RAISE_APPLICATION_ERROR(-20203, l_msg);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF l_topfer = 'F' THEN
          Pack_Global.recuperer_message(20274, NULL, NULL, 'CODSG', l_msg);
          RAISE_APPLICATION_ERROR(-20274, l_msg);
      END IF;
     -- ===================================================================
     -- 19/12/2000 : Test si le DPG appartient bien au centre de frais
     -- ===================================================================
    IF l_centre_frais!=0 THEN    -- le centre de frais 0 donne tout les droits à l'utilisateur
          IF (l_scentrefrais IS NULL)   THEN
        --msg : Le DPG n'est rattaché à aucun centre de frais
        Pack_Global.recuperer_message(20339, NULL,NULL,'CODSG', l_msg);
              RAISE_APPLICATION_ERROR(-20339, l_msg);
    ELSE
        IF (l_scentrefrais!=l_centre_frais) THEN
            --msg:Ce DPG n'appartient pas à ce centre de frais
            Pack_Global.recuperer_message(20334, '%s1',TO_CHAR(l_centre_frais),'CODSG', l_msg);
                  RAISE_APPLICATION_ERROR(-20334, l_msg);
        END IF;
          END IF;
    ELSE    -- l'utilisateur n'est pas affecté à un centre de frais réel: récupérer le centre de frais du DPG
    IF (l_scentrefrais IS NULL) THEN
        --msg : Le DPG n'est rattaché à aucun centre de frais
        Pack_Global.recuperer_message(20339, NULL,NULL,'CODSG', l_msg);
              RAISE_APPLICATION_ERROR(-20339, l_msg);

    ELSE
        -- le centre de frais du contrat est le centre de frais du DPG
        l_centre_frais := l_scentrefrais;
    END IF;
    END IF;


      -- TEST si la date de fin < date de debut ERROR

      IF TO_DATE(p_cdatfin,'dd/mm/yyyy') < TO_DATE(p_cdatdeb,'dd/mm/yyyy') THEN

            IF INSTR(l_sousmenus,'supach') >0 THEN
                --Pack_Global.recuperer_message(20284,NULL, NULL,NULL, l_msg);
                --p_message:=p_message ||'\n'|| l_msg;
                Pack_Global.recuperer_message(20284,NULL, NULL,'CDATFIN', l_msg);
                p_message:=p_message ||'\n'|| l_msg;
                RAISE_APPLICATION_ERROR(-20284 , l_msg );
                ELSE
                Pack_Global.recuperer_message(20284,NULL, NULL,'CDATDEB', l_msg);
                RAISE_APPLICATION_ERROR(-20284 , l_msg );

            END IF;

      ELSE -- p_cdatfin >= p_cdatdeb

        BEGIN
           INSERT INTO CONTRAT (filcode,
                                soccont,
                                numcont,
                                cav,
                                cagrement,
                                NICHE,
                                cnaffair,
                                crang,
                                cdatarr,
                                cobjet1,
                                cobjet2,
                                crem,
                                codsg,
                                comcode,
                                ctypfact,
                                ccoutht,
                                ccharesti,
                                cdatdeb,
                                cdatfin,
                                cdatsai,
                                cduree,
                                cmmens,
                                cantcons,
                                cantfact,
                                cecartht,
                                cevainit,
                   ccentrefrais,
                   cdatrpol,
                   cdatdir,
                   siren,
                   top30,
				   orictr
                               )
           VALUES (l_filcode,
                   p_soccont,
                   p_numcont,
                   l_cav,
                   p_cagrement,
                   TO_NUMBER(p_niche),
                   p_cnaffair,
                   p_crang,
                   TO_DATE(p_cdatarr,'dd/mm/yyyy'),
                   p_cobjet1,
                   p_cobjet2,
                   p_crem,
                   TO_NUMBER(p_codsg),
                   p_comcode,
                   p_ctypfact,
                   TO_NUMBER(p_ccoutht,'FM9999999999D00'),
                   TO_NUMBER(p_ccharesti,'FM99999D0'),
                   TO_DATE(p_cdatdeb,'dd/mm/yyyy'),
                   TO_DATE(p_cdatfin,'dd/mm/yyyy'),
                   TRUNC(SYSDATE), -- to_date(to_char(sysdate,'dd/mm/yyyy')),
                   TO_NUMBER(MONTHS_BETWEEN(TRUNC(TO_DATE(p_cdatfin,'DD/MM/YYYY'), 'MONTH'),
                                            TRUNC(TO_DATE(p_cdatdeb,'DD/MM/YYYY'), 'MONTH'))),
                   ROUND(TO_NUMBER(p_ccoutht,'FM9999999999D00')/
                         DECODE(MONTHS_BETWEEN(TRUNC(TO_DATE(p_cdatfin,'DD/MM/YYYY'), 'MONTH'),
                           TRUNC(TO_DATE(p_cdatdeb,'DD/MM/YYYY'), 'MONTH')), 0, 1,
                    MONTHS_BETWEEN(TRUNC(TO_DATE(p_cdatfin,'DD/MM/YYYY'), 'MONTH'),
                           TRUNC(TO_DATE(p_cdatdeb,'DD/MM/YYYY'), 'MONTH')))
                        ),
                   0,
                   0,
                   0,
                   0,
          l_centre_frais,
          TRUNC(SYSDATE),
          TRUNC(SYSDATE),
          p_siren,
          l_ach30,
		  p_source
                  );

              Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, l_cav, TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'numéro de contrat', NULL, p_numcont,null,null,1, 'Création du contrat');
              Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, l_cav, TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'date début', NULL, p_cdatdeb,null,null,1, 'Création du contrat');
              Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, l_cav, TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'date fin', NULL, p_cdatfin,null,null,1, 'Création du contrat');
              Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, l_cav, TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'DPG', NULL, p_codsg,null,null,1, 'Création du contrat');
              Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, l_cav, TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'Siren', NULL, p_siren,null,null,1, 'Création du contrat');
              Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, l_cav, TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'Type facturation', NULL, p_ctypfact,null,null,1, 'Création du contrat');



        EXCEPTION

          WHEN referential_integrity THEN

                -- habiller le msg erreur

                Pack_Global.recuperation_integrite(-2291);

           WHEN DUP_VAL_ON_INDEX THEN
              Pack_Global.recuperer_message(20285,NULL, NULL, NULL, l_msg);
              RAISE_APPLICATION_ERROR(-20285 , l_msg );

           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM );
        END;

      END IF; -- Fin si p_cdatfin < p_cdatdeb

      IF l_cav = '000' THEN -- On cree un contrat

         -- MSG : 'Le contrat %s1 a ete creer'

         Pack_Global.recuperer_message(2087,'%s1',p_numcont, NULL, l_msg);

     ELSE

         -- MSG : 'L'avenant %s1 a ete creer pour le contrat %s2'

         Pack_Global.recuperer_message(2088,'%s1',p_cav,'%s2',p_numcont, NULL, l_msg);

     END IF;
     p_message :=p_message ||'\n'|| l_msg;

   END insert_contrat;

   PROCEDURE update_contrat (p_test     IN  VARCHAR2,
                             p_soccont   IN  CONTRAT.soccont%TYPE,
                             p_soclib    IN  SOCIETE.soclib%TYPE,
                             p_numcont   IN  CONTRAT.numcont%TYPE,
                             p_cav       IN  CONTRAT.cav%TYPE,
                             p_cagrement IN  CONTRAT.cagrement%TYPE,
                             p_niche     IN  VARCHAR2,
                             p_cnaffair  IN  CONTRAT.cnaffair%TYPE,
                             p_crang     IN  CONTRAT.crang%TYPE,
                             p_cdatarr   IN  VARCHAR2,
                             p_cobjet1   IN  CONTRAT.cobjet1%TYPE,
                             p_cobjet2   IN  CONTRAT.cobjet2%TYPE,
                             p_crem      IN  CONTRAT.crem%TYPE,
                             p_codsg     IN  VARCHAR2,
                             p_comcode   IN  VARCHAR2,
                             p_ctypfact  IN  CONTRAT.ctypfact%TYPE,
                             p_ccoutht   IN  VARCHAR2,
                             p_ccharesti IN  VARCHAR2,
                             p_cdatdeb   IN  VARCHAR2,
                             p_cdatfin   IN  VARCHAR2,
                             p_flaglock  IN  NUMBER,
                             p_userid    IN  VARCHAR2,
                             p_siren IN VARCHAR2,
							 p_source IN CONTRAT.orictr%TYPE,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            ) IS

      l_msg VARCHAR2(1024);
      l_filcode FILIALE_CLI.filcode%TYPE;
      l_topfer  STRUCT_INFO.topfer%TYPE;
      l_cdatarr NUMBER;
      l_centre_frais NUMBER(3);
      l_scentrefrais NUMBER(3);
      l_user        CONTRATS_LOGS.user_log%TYPE;
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

      cdatdeb_old CONTRAT.cdatdeb%TYPE;
      cdatfin_old CONTRAT.cdatfin%TYPE;
      codsg_old CONTRAT.codsg%TYPE;
      siren_old CONTRAT.siren%TYPE;
      ctypfact_old CONTRAT.ctypfact%TYPE;

      l_sousmenus VARCHAR2(1024);
      l_maxdate VARCHAR2(10);
      l_mindate VARCHAR2(10);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';

      -- On recupere le code filiale de l'utilisateur
      l_filcode := Pack_Global.lire_globaldata(p_userid).filcode;

       -- On recupere le code centre de frais de l'utilisateur
      l_centre_frais:= Pack_Global.lire_globaldata(p_userid).codcfrais;

       -- On récupère le matricule de l'utilisateur
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      -- On récupère le matricule de l'utilisateur
      l_sousmenus := Pack_Global.lire_globaldata(p_userid).sousmenus;

      -- Test le DPG non ouvert donc fermer

      BEGIN
         SELECT topfer , scentrefrais
         INTO   l_topfer, l_scentrefrais
         FROM   STRUCT_INFO
         WHERE  codsg = TO_NUMBER(p_codsg);

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            Pack_Global.recuperer_message(20203, NULL, NULL, 'CODSG', l_msg);
            RAISE_APPLICATION_ERROR(-20203, l_msg);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF l_topfer = 'F' THEN
          Pack_Global.recuperer_message(20274, NULL, NULL, 'CODSG', l_msg);
          RAISE_APPLICATION_ERROR(-20274, l_msg);
      END IF;

     -- ===================================================================
     -- 19/12/2000 : Test si le DPG appartient bien au centre de frais
     -- ===================================================================
    IF l_centre_frais!=0 THEN    -- le centre de frais 0 donne tout les droits à l'utilisateur
          IF (l_scentrefrais IS NULL)   THEN
        --msg : Le DPG n'est rattaché à aucun centre de frais
        Pack_Global.recuperer_message(20339, NULL,NULL,'CODSG', l_msg);
              RAISE_APPLICATION_ERROR(-20339, l_msg);
    ELSE
        IF (l_scentrefrais!=l_centre_frais) THEN
            --msg:Ce DPG n'appartient pas à ce centre de frais
            Pack_Global.recuperer_message(20334, '%s1',TO_CHAR(l_centre_frais),'CODSG', l_msg);
                  RAISE_APPLICATION_ERROR(-20334, l_msg);
        END IF;
          END IF;
    ELSE    -- l'utilisateur n'est pas affecté à un centre de frais réel: récupérer le centre de frais du DPG
    IF (l_scentrefrais IS NULL) THEN
        --msg : Le DPG n'est rattaché à aucun centre de frais
        Pack_Global.recuperer_message(20339, NULL,NULL,'CODSG', l_msg);
              RAISE_APPLICATION_ERROR(-20339, l_msg);

    ELSE
        -- le centre de frais du contrat est le centre de frais du DPG
        l_centre_frais := l_scentrefrais;
    END IF;
    END IF;

      -- TEST  coherence entre la date de debut et date de fin
      IF TO_DATE(p_cdatdeb, 'DD/MM/YYYY') > TO_DATE(p_cdatfin, 'DD/MM/YYYY') THEN

        IF INSTR(l_sousmenus,'supach') >0 THEN
            --Pack_Global.recuperer_message(20284, NULL, NULL, NULL, l_msg);
            --p_message:=p_message ||'\n'|| l_msg;
            Pack_Global.recuperer_message(20284, NULL, NULL, 'CDATFIN', l_msg);
            p_message:=p_message ||'\n'|| l_msg;
            RAISE_APPLICATION_ERROR(-20284, l_msg);
            ELSE
            Pack_Global.recuperer_message(20284, NULL, NULL, 'CDATDEB', l_msg);
            RAISE_APPLICATION_ERROR(-20284, l_msg);
        END IF;

      ELSE --p_cdatdeb <= p_cdatfin

              -- TEST date d'arrivee a GES/ACH doit etre > a date du jour

              SELECT TO_NUMBER(MONTHS_BETWEEN(TRUNC(SYSDATE), TRUNC(TO_DATE(p_cdatarr,'DD/MM/YYYY'))))
            INTO   l_cdatarr
            FROM   DUAL;

              IF l_cdatarr < 0 THEN

                IF INSTR(l_sousmenus,'supach') >0 THEN
                    Pack_Global.recuperer_message(20283,NULL, NULL,NULL, l_msg);
                    p_message:=p_message ||'\n'|| l_msg;
                    ELSE
                    Pack_Global.recuperer_message(20283,NULL, NULL,'CDATARR', l_msg);
                    RAISE_APPLICATION_ERROR(-20283 , l_msg );
                END IF;

              END IF;


        BEGIN

            SELECT DISTINCT MAX(l.LRESFIN), MIN(l.LRESDEB)
            INTO l_maxdate, l_mindate
            FROM ligne_cont l
            WHERE l.numcont = p_numcont
            AND   l.CAV = TRIM(LPAD(NVL(p_cav,'0'),3,'0'))
			AND   l.soccont = p_soccont;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                  l_maxdate :='';
                  l_mindate :='';
        END;

        IF( TO_DATE(p_cdatfin, 'DD/MM/YYYY') < TO_DATE(l_maxdate,'DD/MM/RRRR') ) THEN
            -- l_msg : Les dates de début et fin indiquées ne sont pas cohérentes avec une ou plusieurs LIGNES de ce contrat.
            --         Vous devez commencer par modifier les dates des LIGNES pour ensuite modifier les dates globales du contrat
            Pack_Global.recuperer_message(20317,NULL, NULL,'CDATFIN', l_msg);
            RAISE_APPLICATION_ERROR(-20317 , l_msg );

        END IF;

        IF( TO_DATE(p_cdatdeb, 'DD/MM/YYYY') > TO_DATE(l_mindate,'DD/MM/RRRR') ) THEN
            -- l_msg : Les dates de début et fin indiquées ne sont pas cohérentes avec une ou plusieurs LIGNES de ce contrat.
            --         Vous devez commencer par modifier les dates des LIGNES pour ensuite modifier les dates globales du contrat
            Pack_Global.recuperer_message(20317,NULL, NULL,'CDATDEB', l_msg);
            RAISE_APPLICATION_ERROR(-20317 , l_msg );
        END IF;

        IF( TO_DATE(p_cdatfin, 'DD/MM/YYYY') >= TO_DATE(l_maxdate,'DD/MM/RRRR') OR ( TO_DATE(p_cdatdeb, 'DD/MM/YYYY') <= TO_DATE(l_mindate,'DD/MM/RRRR') ) OR l_maxdate IS NULL) THEN

            -- UPDATE du contrat
            BEGIN
             -- Recupération des anciennes valeurs
              select cdatdeb, cdatfin, codsg, siren, ctypfact
             into cdatdeb_old, cdatfin_old, codsg_old, siren_old, ctypfact_old
              from contrat
                WHERE soccont = p_soccont
               AND   filcode = l_filcode
               AND   numcont = p_numcont
               AND   cav     = lpad(nvl(p_cav,'0'),3,'0')
               AND   flaglock = p_flaglock;

               UPDATE CONTRAT
               SET cagrement = p_cagrement,
                   NICHE     = TO_NUMBER(p_niche),
                   cnaffair  = p_cnaffair,
                   crang     = p_crang,
                   cdatarr   = TO_DATE(p_cdatarr,'DD/MM/YYYY'),
                   cobjet1   = p_cobjet1,
                   cobjet2   = p_cobjet2,
                   crem      = p_crem,
                   codsg     = TO_NUMBER(p_codsg),
                   comcode   = p_comcode,
                   ctypfact  = p_ctypfact,
                   ccoutht   = TO_NUMBER(p_ccoutht,'FM9999999999D00'),
                   ccharesti = TO_NUMBER(p_ccharesti,'FM99999D0'),
                   cdatdeb   = TO_DATE(p_cdatdeb,'DD/MM/YYYY'),
                   cdatfin   = TO_DATE(p_cdatfin,'DD/MM/YYYY'),
                   cdatmaj   = TRUNC(SYSDATE),
                   flaglock  = DECODE( p_flaglock, 1000000, 0, p_flaglock + 1),
               ccentrefrais=l_centre_frais,
               siren = p_siren,
			   orictr = p_source
               WHERE soccont = p_soccont
               AND   filcode = l_filcode
               AND   numcont = p_numcont
               AND   cav     = lpad(nvl(p_cav,0),3,'0')
               AND   flaglock = p_flaglock;

              Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'date début', to_char(cdatdeb_old,'DD/MM/YYYY'), p_cdatdeb,null,null,3, 'Modification du contrat');
              Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'date fin', to_char(cdatfin_old,'DD/MM/YYYY'), p_cdatfin,null,null,3, 'Modification du contrat');
              Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'DPG', lpad(to_char(codsg_old),7,0), to_char(p_codsg),null,null,3, 'Modification du contrat');
              Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'Siren', to_char(siren_old), to_char(p_siren),null,null,3, 'Modification du contrat');
              Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'Type facturation', to_char(ctypfact_old), to_char(p_ctypfact),null,null,3, 'Modification du contrat');



            EXCEPTION
               WHEN referential_integrity THEN

                  -- habiller le msg erreur

                  Pack_Global.recuperation_integrite(-2291);

               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20997, SQLERRM);
            END;

        END IF;

      END IF; -- Fin si p_cdatdeb > p_cdatfin

      IF SQL%NOTFOUND THEN
         Pack_Global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
         Pack_Global.recuperer_message(2089,'%s1',p_numcont, NULL, l_msg);
         p_message :=p_message ||'\n'|| l_msg;
      END IF;

   END update_contrat;


   PROCEDURE delete_contrat (p_test     IN  VARCHAR2,
                             p_soccont   IN  CONTRAT.soccont%TYPE,
                             p_soclib    IN  SOCIETE.soclib%TYPE,
                             p_numcont   IN  CONTRAT.numcont%TYPE,
                             p_cav       IN  CONTRAT.cav%TYPE,
                             p_cagrement IN  CONTRAT.cagrement%TYPE,
                             p_niche     IN  VARCHAR2,
                             p_cnaffair  IN  CONTRAT.cnaffair%TYPE,
                             p_crang     IN  CONTRAT.crang%TYPE,
                             p_cdatarr   IN  VARCHAR2,
                             p_cobjet1   IN  CONTRAT.cobjet1%TYPE,
                             p_cobjet2   IN  CONTRAT.cobjet2%TYPE,
                             p_crem      IN  CONTRAT.crem%TYPE,
                             p_codsg     IN  VARCHAR2,
                             p_comcode   IN  VARCHAR2,
                             p_ctypfact  IN  CONTRAT.ctypfact%TYPE,
                             p_ccoutht   IN  VARCHAR2,
                             p_ccharesti IN  VARCHAR2,
                             p_cdatdeb   IN  VARCHAR2,
                             p_cdatfin   IN  VARCHAR2,
                             p_flaglock  IN  NUMBER,
                             p_userid    IN  VARCHAR2,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            ) IS

      l_msg VARCHAR2(1024);
      l_filcode FILIALE_CLI.filcode%TYPE;
      l_numcont CONTRAT.numcont%TYPE;
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

      l_user        CONTRATS_LOGS.user_log%TYPE;

      cdatdeb_old CONTRAT.cdatdeb%TYPE;
      cdatfin_old CONTRAT.cdatfin%TYPE;
      codsg_old CONTRAT.codsg%TYPE;
      siren_old CONTRAT.siren%TYPE;

      CURSOR contratsCur IS SELECT * FROM CONTRAT
           WHERE soccont  = p_soccont
           AND   filcode  = l_filcode
           AND   numcont  = p_numcont;

      l_contrat CONTRAT%ROWTYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      -- On recupere le code filiale de l'utilisateur

      l_filcode := Pack_Global.lire_globaldata(p_userid).filcode;

        -- On récupère le matricule de l'utilisateur
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      -- On test si le contrat supprimer possede une ou des factures
      -- Il n'y a pas de contrainte car elle doit etre sur contrat
      BEGIN

     SELECT  fac.numcont
       INTO  l_numcont
       FROM  FACTURE fac
       WHERE fac.numcont = p_numcont
       AND   fac.soccont = p_soccont
       AND   fac.cav     = lpad(nvl(p_cav,'0'),3,'0')
       AND ROWNUM < 2;

      EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL; -- Il n'existe pas de facture avec ce numero de contrat/avenant
     WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;

      IF l_numcont IS NOT NULL THEN
     Pack_Global.recuperer_message(20294 ,NULL, NULL, NULL, l_msg);
     RAISE_APPLICATION_ERROR( -20294, l_msg );
      END IF;


     -- 2 cas : si l'avenant(p_cav) = 00 et != 00
     -- 1er cas avenat = 00 on efface tous les contrats:

     -- recuperation des données avant suppressoin
      select cdatdeb, cdatfin, codsg, siren
       into cdatdeb_old, cdatfin_old, codsg_old, siren_old
        from contrat
          WHERE soccont = p_soccont
         AND   filcode = l_filcode
         AND   numcont = p_numcont
         AND   cav     = lpad(nvl(p_cav,'0'),3,'0')
         AND   flaglock = p_flaglock;

     OPEN contratsCur;

     IF (lpad(nvl(p_cav,'0'),3,'0') = '000') THEN

        BEGIN
           DELETE FROM CONTRAT
           WHERE soccont  = p_soccont
           AND   filcode  = l_filcode
           AND   numcont  = p_numcont;

        EXCEPTION

           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20997, SQLERRM);
        END;

        LOOP
            FETCH contratsCur INTO l_contrat;
            IF (contratsCur%FOUND) THEN
                Pack_contrat.maj_contrats_logs(p_numcont,siren_old, p_soccont, lpad(nvl(l_contrat.cav,0),3,'0'), TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'Toutes',null,null, cdatdeb_old,cdatfin_old,2, 'Suppression du contrat');
            END IF;
            EXIT WHEN contratsCur%NOTFOUND;
        END LOOP;
        CLOSE contratsCur;


     ELSE  -- on ne supprime que l'avenant sélectionné

        BEGIN
           DELETE FROM  CONTRAT
           WHERE soccont  = p_soccont
           AND   filcode  = l_filcode
           AND   numcont  = p_numcont
           AND   cav      = lpad(nvl(p_cav,'0'),3,'0')
           AND   flaglock = p_flaglock;


        EXCEPTION
           WHEN referential_integrity THEN

              -- habiller le msg erreur : "Pas de suppression de contrat/avenant avec des factures liées"

              Pack_Global.recuperation_integrite(-2292);

           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20997, SQLERRM);
        END;

        Pack_contrat.maj_contrats_logs(p_numcont,siren_old, p_soccont, lpad(nvl(p_cav,0),3,'0'), TO_NUMBER(p_codsg), null, l_user, 'CONTRAT', 'Toutes',null,null, cdatdeb_old,cdatfin_old,2, 'Suppression du contrat');

     END IF;

      IF SQL%NOTFOUND THEN
         Pack_Global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
     RAISE_APPLICATION_ERROR( -20999, l_msg );

      ELSIF (lpad(nvl(p_cav,'0'),3,'0') = '000') THEN

         -- On supprime un contrat

         Pack_Global.recuperer_message(2090,'%s1' , p_numcont , NULL, l_msg);
      ELSE

         -- On supprime un avenant

         Pack_Global.recuperer_message(2091,'%s1' , p_numcont , NULL, l_msg);
      END IF;
      p_message := l_msg;

   END delete_contrat;


   PROCEDURE select_contrat (p_mode    IN VARCHAR2,
                             p_test     IN VARCHAR2,
                             p_soccont   IN CONTRAT.soccont%TYPE,
                             p_numcont   IN CONTRAT.numcont%TYPE,
                             p_cav       IN CONTRAT.cav%TYPE,
                             p_userid    IN VARCHAR2,
                             p_curcont   IN OUT ContCurType,
                             p_socout       OUT VARCHAR2,
                              p_cavout       OUT VARCHAR2,
                             p_choixout     OUT VARCHAR2,
                 p_cnaffout     OUT VARCHAR2,
                 p_codsg        OUT VARCHAR2,
                 p_comcode      OUT VARCHAR2,
                 p_cobjet1      OUT VARCHAR2,
                             p_cobjet2      OUT VARCHAR2,
                             p_nbcurseur    OUT INTEGER,
                             p_message      OUT VARCHAR2
                            ) IS

      l_msg VARCHAR2(1024);
      l_soclib   SOCIETE.soclib%TYPE;
      l_soccont  CONTRAT.soccont%TYPE;
      l_numcont  CONTRAT.numcont%TYPE;
      l_filcode  FILIALE_CLI.filcode%TYPE;
      l_cav      CONTRAT.cav%TYPE;
      l_cav_hist CONTRAT.cav%TYPE;
      l_centre_frais CENTRE_FRAIS.codcfrais%TYPE;
      l_ccentrefrais CENTRE_FRAIS.codcfrais%TYPE;
      l_ssmenu VARCHAR2(250);
      l_top30 CHAR;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';


      l_cav := p_cav;

      -- On recupere le code filiale de l'utilisateur

      l_filcode := Pack_Global.lire_globaldata(p_userid).filcode;

      -- on recupère le sous menu de l'utilisateur
      l_ssmenu := Pack_Global.lire_globaldata(p_userid).sousmenus;


      -- TEST existance du code societe dans la table societe

      BEGIN
         SELECT soccode
         INTO   l_soccont
         FROM   SOCIETE
         WHERE  soccode = p_soccont;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN

             -- Erreur message "Code Societe inconnu"

             Pack_Global.recuperer_message(20306, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR(-20306,l_msg);

         WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR(-20997,SQLERRM);
      END;


      -- Positionne le tag <% CHOIX %> pour la page HTML

      p_choixout :=  p_test;


      -- TEST de cnaffair

      IF p_mode = 'insert' AND p_test != 'avenant' THEN
         p_cnaffout := 'OUI';
      END IF;

      -- Cas de la creation

      IF p_mode = 'insert' THEN

       -- AJOUT du 26/05/2000 : Création impossible si societe fermée
     BEGIN
         SELECT soccode
         INTO   l_soccont
         FROM   SOCIETE
         WHERE  soccode = p_soccont
     AND (socfer IS NULL OR socfer='');

           EXCEPTION
          WHEN NO_DATA_FOUND THEN

             -- Erreur message "Création impossible, la societe n'existe plus"

             Pack_Global.recuperer_message(20325, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR(-20325,l_msg);

          WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR(-20997,SQLERRM);
           END;


         -- On retourne le libelle de la societe

         SELECT  soclib
       INTO  l_soclib
       FROM  SOCIETE
       WHERE soccode = p_soccont;

         p_socout :=  l_soclib;

         -- Différence entre creation d'un avenant et d'un contrat

         IF p_test = 'contrat' THEN
            if (instr(l_ssmenu,'ach30') > 0) then
                p_cavout := null;
            else
                p_cavout := '00';
            end if;


         ELSE -- On cree un avenant

            -- On prend le cav max pour le contrat selectionne ensuite
            -- il devient un number pour ajouter 1 et retour
            -- au format caractere avec un affichage au format '09'

            -- mise en commanetaire TD 737
            /* SELECT TO_CHAR((TO_NUMBER(MAX(con.cav))+1), 'FM09')
              INTO   l_cav
              FROM   CONTRAT con
              WHERE  con.soccont = p_soccont
              AND    con.filcode = l_filcode
              AND    con.numcont = p_numcont; */

           p_cavout := l_cav;


            -- On recuperer le codsg et le code comptable du contrat
            BEGIN
                   SELECT TO_CHAR(codsg, 'FM0000000'), comcode, cobjet1, cobjet2
                 INTO  p_codsg, p_comcode, p_cobjet1, p_cobjet2
                 FROM  CONTRAT con
                 WHERE con.soccont = p_soccont
                 AND   con.numcont = p_numcont
                 AND   con.cav = '000';  -- TD 737
                -- AND   con.cav = (     SELECT MAX(cav)
                  --          FROM CONTRAT
                    --        WHERE soccont = p_soccont
                      --       AND   numcont = p_numcont);

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
                WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20997,SQLERRM);
            END;
        END IF;



      END IF;  -- Fin du cas creation





      -- Test de l'existance du contrat dans la table contrat pour une autre filiale

      BEGIN
         SELECT DISTINCT soccont
         INTO   l_soccont
         FROM   CONTRAT
         WHERE  soccont = p_soccont
         AND    numcont = p_numcont
         AND    filcode <> l_filcode;

         IF SQL%FOUND THEN

             -- Erreur message "Le contrat existe deja pour une autre filiale"

             Pack_Global.recuperer_message(20286, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR(-20286,l_msg);
         END IF;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
             NULL;
         WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR(-20997,SQLERRM);
      END;

      -- Cas Creation ou lignes on ne filtre pas sur cav

      --      IF (p_mode = 'insert' AND p_test = 'contrat') THEN
      IF (p_mode = 'insert' AND p_test = 'contrat') THEN

     -- Attention ordre des colonnes doit correspondre a l ordre
         -- de declaration dans la table ORACLE (a cause de ROWTYPE)
         -- ou selectionner toutes les colonnes par *

         BEGIN
            OPEN p_curcont FOR
               SELECT c.soccont,
                      --soc.SOCLIB,
                      a.socflib,
                      c.numcont,
                      decode(c.top30,'N',substr(c.cav,2,2),'O',decode(c.cav,'000',null,c.cav)),
                      c.cagrement,
                      TO_CHAR(c.NICHE),
                      c.cnaffair,
                      c.crang,
                      TO_CHAR(c.cdatarr,'dd/mm/yyyy'),
                      c.cobjet1,
                      c.cobjet2,
                      c.crem,
                      TO_CHAR(c.codsg, 'FM0000000'),
                      c.comcode,
                      ctypfact,
                      TO_CHAR(c.ccoutht,'FM9999999999D00'),
                      TO_CHAR(c.ccharesti,'FM99999D0'),
                      TO_CHAR(c.cdatdeb,'dd/mm/yyyy'),
                      TO_CHAR(c.cdatfin,'dd/mm/yyyy'),
                      TO_CHAR(c.flaglock),
                      c.SIREN,
					  c.orictr
--,to_char(contrat.ccentrefrais)
              FROM    CONTRAT c, SOCIETE soc, AGENCE a
              WHERE   C.soccont = p_soccont
              AND     soc.soccode = p_soccont
              AND     c.filcode = l_filcode
              AND     c.numcont = p_numcont
              AND     c.SIREN=a.SIREN(+)
              AND      c.cav = '000' ;

         EXCEPTION
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20997,SQLERRM);
         END;

      -- Cas ou l'on veut créer un avenant
      -- On doit tester que le contrat existe
      -- On doit renvoyer un curseur vide
      -- Pbl.: car en creation un curseur avec une ligne declanche l'affichage du message "entite deja existante"
      -- Sol.: il faut tester que le contrat existe et renvoyer un curseur bidon avec zero ligne.

      ELSIF (p_mode = 'insert' AND p_test = 'avenant') THEN

         -- Test de l'existance d'un contrat dans la table contrat
            --- mise en commentaire TD 737
      /*   BEGIN

            SELECT soccont
            INTO   l_soccont
            FROM   CONTRAT
            WHERE  soccont = p_soccont
            AND    filcode = l_filcode
            AND    numcont = p_numcont
            AND    ROWNUM < 2;


         EXCEPTION
         WHEN NO_DATA_FOUND THEN
           -- Erreur message "Contrat inexistant"

           Pack_Global.recuperer_message(20280, NULL, NULL, NULL, l_msg);
           RAISE_APPLICATION_ERROR(-20280,l_msg);
         WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20997,SQLERRM);

         END;*/

         -- La c'est, la super ouverture de curseur de la mort qui tue
         -- et qui retourne rien pour faire plaisir a HTML, overthetop

         BEGIN
            OPEN p_curcont FOR
               SELECT c.soccont,
                      --soc.SOCLIB,
                      a.socflib,
                      c.numcont,
                     decode(c.top30,'N',substr(c.cav,2,2),'O',c.cav),
                      c.cagrement,
                      TO_CHAR(c.NICHE),
                      c.cnaffair,
                      c.crang,
                      TO_CHAR(c.cdatarr,'dd/mm/yyyy'),
                      c.cobjet1,
                      c.cobjet2,
                      c.crem,
                      TO_CHAR(c.codsg, 'FM0000000'),
                      c.comcode,
                      ctypfact,
                      TO_CHAR(c.ccoutht,'FM9999999999D00'),
                      TO_CHAR(c.ccharesti,'FM99999D0'),
                      TO_CHAR(c.cdatdeb,'dd/mm/yyyy'),
                      TO_CHAR(c.cdatfin,'dd/mm/yyyy'),
                      TO_CHAR(c.flaglock),
                      c.SIREN,
					  c.orictr
--,to_char(contrat.ccentrefrais)
              FROM    CONTRAT c, SOCIETE soc, AGENCE a
              WHERE   C.soccont = p_soccont
              AND     soc.soccode = p_soccont
              AND     c.filcode = l_filcode
              AND     c.numcont = p_numcont
              ANd     c.cav = lpad(l_cav,3,'0')
              AND     c.SIREN=a.SIREN(+);

         EXCEPTION
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20997,SQLERRM);
         END;

      ELSE

     -- Cas modification ou suppression on filtre sur cav
     -- modif. + cas lignes


    -- Contrôler que le contrat appartient au centre de frais de l'utilisateur
     -- On récupère le code centre de frais de l'utilisateur
    l_centre_frais:=Pack_Global.lire_globaldata(p_userid).codcfrais;

            IF (l_cav is null) THEN
                l_cav := lpad(nvl(l_cav,'0'),3,'0');

                    BEGIN
                             SELECT numcont, ccentrefrais
                    INTO l_numcont, l_ccentrefrais
                    FROM CONTRAT
                        WHERE      numcont = p_numcont
                     AND    soccont = p_soccont
                         AND    cav     = l_cav
                         AND    filcode = l_filcode;


                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN     --Le contrat n'existe pas
                       IF p_test = 'contrat' THEN
                             Pack_Global.recuperer_message(2086, NULL, NULL, NULL, l_msg);
                              ELSE
                             Pack_Global.recuperer_message(2092, NULL, NULL, NULL, l_msg);
                              END IF;

                    WHEN OTHERS THEN
                                   RAISE_APPLICATION_ERROR(-20997,SQLERRM);

                    END;
                    IF l_centre_frais!=0 THEN    -- le centre de frais 0 donne tout les droits à l'utilisateur
                        IF (l_ccentrefrais IS NULL  AND l_numcont IS NOT NULL ) THEN
                    -- Ce contrat n'est rattaché à aucun centre de frais
                        Pack_Global.recuperer_message(20336,NULL,NULL,NULL, l_msg);
                              RAISE_APPLICATION_ERROR(-20336, l_msg);
                    END IF;

                      IF l_ccentrefrais!=l_centre_frais THEN
                    --Le contrat n'existe pas dans le centre de frais mais dans le centre %s2
                     Pack_Global.recuperer_message(20335, '%s1',TO_CHAR(l_centre_frais),'%s2',TO_CHAR(l_ccentrefrais),NULL, l_msg);
                         RAISE_APPLICATION_ERROR(-20335, l_msg);
                    END IF;
                    END IF;


                          BEGIN
                            OPEN p_curcont FOR
                                SELECT c.soccont,
                                  --soc.SOCLIB,
                                  a.socflib,
                                  c.numcont,
                                  decode(c.top30,'N',substr(c.cav,2,2),'O',decode(c.cav,'000',null,c.cav)),
                                  c.cagrement,
                                  TO_CHAR(c.NICHE),
                                  c.cnaffair,
                                  c.crang,
                                  TO_CHAR(c.cdatarr,'dd/mm/yyyy'),
                                  c.cobjet1,
                                  c.cobjet2,
                                  c.crem,
                                  TO_CHAR(c.codsg, 'FM0000000'),
                                  c.comcode,
                                  ctypfact,
                                  TO_CHAR(c.ccoutht,'FM9999999999D00'),
                                  TO_CHAR(c.ccharesti,'FM99999D0'),
                                  TO_CHAR(c.cdatdeb,'dd/mm/yyyy'),
                                  TO_CHAR(c.cdatfin,'dd/mm/yyyy'),
                                  TO_CHAR(c.flaglock),
                                  c.SIREN,
								  c.orictr
                          FROM    CONTRAT c, SOCIETE soc, AGENCE a
                          WHERE   c.soccont = p_soccont
                          AND     soc.soccode = p_soccont
                          AND     c.filcode = l_filcode
                          AND     c.numcont = p_numcont
                          and     c.cav = l_cav
                          AND     c.siren=a.siren(+)
                          AND     ROWNUM = 1;


                      EXCEPTION
                        WHEN OTHERS THEN
                           RAISE_APPLICATION_ERROR(-20997,SQLERRM);
                     END;

            elsif (length(l_cav)=2) then


             BEGIN
                             SELECT numcont, ccentrefrais
                    INTO l_numcont, l_ccentrefrais
                    FROM CONTRAT
                        WHERE      numcont = p_numcont
                     AND    soccont = p_soccont
                         AND    substr(cav,2,2)     = l_cav
                    AND    filcode = l_filcode
                    AND TOP30 = 'N';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN     --Le contrat n'existe pas
                         IF p_test = 'contrat' THEN
                             Pack_Global.recuperer_message(2086, NULL, NULL, NULL, l_msg);
                              ELSE
                             Pack_Global.recuperer_message(2092, NULL, NULL, NULL, l_msg);
                              END IF;

                    WHEN OTHERS THEN
                                   RAISE_APPLICATION_ERROR(-20997,SQLERRM);

                END;
                    IF l_centre_frais!=0 THEN    -- le centre de frais 0 donne tout les droits à l'utilisateur
                        IF (l_ccentrefrais IS NULL  AND l_numcont IS NOT NULL ) THEN
                    -- Ce contrat n'est rattaché à aucun centre de frais
                        Pack_Global.recuperer_message(20336,NULL,NULL,NULL, l_msg);
                              RAISE_APPLICATION_ERROR(-20336, l_msg);
                    END IF;

                      IF l_ccentrefrais!=l_centre_frais THEN
                    --Le contrat n'existe pas dans le centre de frais mais dans le centre %s2
                     Pack_Global.recuperer_message(20335, '%s1',TO_CHAR(l_centre_frais),'%s2',TO_CHAR(l_ccentrefrais),NULL, l_msg);
                         RAISE_APPLICATION_ERROR(-20335, l_msg);
                    END IF;
                END IF;


                          BEGIN
                            OPEN p_curcont FOR
                                SELECT c.soccont,
                                  --soc.SOCLIB,
                                  a.socflib,
                                  c.numcont,
                                  decode(c.top30,'N',substr(c.cav,2,2),'O',decode(c.cav,'000',null,c.cav)),
                                  c.cagrement,
                                  TO_CHAR(c.NICHE),
                                  c.cnaffair,
                                  c.crang,
                                  TO_CHAR(c.cdatarr,'dd/mm/yyyy'),
                                  c.cobjet1,
                                  c.cobjet2,
                                  c.crem,
                                  TO_CHAR(c.codsg, 'FM0000000'),
                                  c.comcode,
                                  ctypfact,
                                  TO_CHAR(c.ccoutht,'FM9999999999D00'),
                                  TO_CHAR(c.ccharesti,'FM99999D0'),
                                  TO_CHAR(c.cdatdeb,'dd/mm/yyyy'),
                                  TO_CHAR(c.cdatfin,'dd/mm/yyyy'),
                                  TO_CHAR(c.flaglock),
                                  c.SIREN,
								  c.orictr
                          FROM    CONTRAT c, SOCIETE soc, AGENCE a
                          WHERE   c.soccont = p_soccont
                          AND     soc.soccode = p_soccont
                          AND     c.filcode = l_filcode
                          AND     c.numcont = p_numcont
                          and     substr(c.cav,2,2) = l_cav
                          AND     c.siren=a.siren(+)
                          AND TOP30 = 'N'
                          AND     ROWNUM = 1;



                      EXCEPTION
                        WHEN OTHERS THEN
                           RAISE_APPLICATION_ERROR(-20997,SQLERRM);
                     END;

            else
                       BEGIN
                             SELECT numcont, ccentrefrais
                    INTO l_numcont, l_ccentrefrais
                    FROM CONTRAT
                        WHERE      numcont = p_numcont
                     AND    soccont = p_soccont
                         AND    cav = l_cav
                    AND    filcode = l_filcode
                    AND top30 = 'O';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN     --Le contrat n'existe pas
                         IF p_test = 'contrat' THEN
                             Pack_Global.recuperer_message(2086, NULL, NULL, NULL, l_msg);
                              ELSE
                             Pack_Global.recuperer_message(2092, NULL, NULL, NULL, l_msg);
                              END IF;

                    WHEN OTHERS THEN
                                   RAISE_APPLICATION_ERROR(-20997,SQLERRM);

                END;
                    IF l_centre_frais!=0 THEN    -- le centre de frais 0 donne tout les droits à l'utilisateur
                        IF (l_ccentrefrais IS NULL  AND l_numcont IS NOT NULL ) THEN
                    -- Ce contrat n'est rattaché à aucun centre de frais
                        Pack_Global.recuperer_message(20336,NULL,NULL,NULL, l_msg);
                              RAISE_APPLICATION_ERROR(-20336, l_msg);
                    END IF;

                      IF l_ccentrefrais!=l_centre_frais THEN
                    --Le contrat n'existe pas dans le centre de frais mais dans le centre %s2
                     Pack_Global.recuperer_message(20335, '%s1',TO_CHAR(l_centre_frais),'%s2',TO_CHAR(l_ccentrefrais),NULL, l_msg);
                         RAISE_APPLICATION_ERROR(-20335, l_msg);
                    END IF;
                END IF;


                          BEGIN
                            OPEN p_curcont FOR
                                SELECT c.soccont,
                                  --soc.SOCLIB,
                                  a.socflib,
                                  c.numcont,
                                  decode(c.top30,'N',substr(c.cav,2,2),'O',c.cav),
                                  c.cagrement,
                                  TO_CHAR(c.NICHE),
                                  c.cnaffair,
                                  c.crang,
                                  TO_CHAR(c.cdatarr,'dd/mm/yyyy'),
                                  c.cobjet1,
                                  c.cobjet2,
                                  c.crem,
                                  TO_CHAR(c.codsg, 'FM0000000'),
                                  c.comcode,
                                  ctypfact,
                                  TO_CHAR(c.ccoutht,'FM9999999999D00'),
                                  TO_CHAR(c.ccharesti,'FM99999D0'),
                                  TO_CHAR(c.cdatdeb,'dd/mm/yyyy'),
                                  TO_CHAR(c.cdatfin,'dd/mm/yyyy'),
                                  TO_CHAR(c.flaglock),
                                  c.SIREN,
								  c.orictr
                          FROM    CONTRAT c, SOCIETE soc, AGENCE a
                          WHERE   c.soccont = p_soccont
                          AND     soc.soccode = p_soccont
                          AND     c.filcode = l_filcode
                          AND     c.numcont = p_numcont
                          and     c.cav = l_cav
                          AND     c.siren=a.siren(+)
                          AND c.TOP30 ='O'
                          AND     ROWNUM = 1;


                      EXCEPTION
                        WHEN OTHERS THEN
                           RAISE_APPLICATION_ERROR(-20997,SQLERRM);
                     END;
            end if;


  /*   BEGIN
        SELECT numcont, ccentrefrais
        INTO l_numcont, l_ccentrefrais
        FROM CONTRAT
            WHERE      numcont = p_numcont
         AND    soccont = p_soccont
             AND    cav     = l_cav
        AND    filcode = l_filcode;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN     --Le contrat n'existe pas
             IF p_test = 'contrat' THEN
                 Pack_Global.recuperer_message(2086, NULL, NULL, NULL, l_msg);
                  ELSE
                 Pack_Global.recuperer_message(2092, NULL, NULL, NULL, l_msg);
                  END IF;

        WHEN OTHERS THEN
                       RAISE_APPLICATION_ERROR(-20997,SQLERRM);

    END;
        IF l_centre_frais!=0 THEN    -- le centre de frais 0 donne tout les droits à l'utilisateur
            IF (l_ccentrefrais IS NULL  AND l_numcont IS NOT NULL ) THEN
        -- Ce contrat n'est rattaché à aucun centre de frais
            Pack_Global.recuperer_message(20336,NULL,NULL,NULL, l_msg);
                  RAISE_APPLICATION_ERROR(-20336, l_msg);
        END IF;

          IF l_ccentrefrais!=l_centre_frais THEN
        --Le contrat n'existe pas dans le centre de frais mais dans le centre %s2
         Pack_Global.recuperer_message(20335, '%s1',TO_CHAR(l_centre_frais),'%s2',TO_CHAR(l_ccentrefrais),NULL, l_msg);
             RAISE_APPLICATION_ERROR(-20335, l_msg);
        END IF;
    END IF;


              BEGIN
                OPEN p_curcont FOR
                    SELECT c.soccont,
                      --soc.SOCLIB,
                      a.socflib,
                      c.numcont,
                      decode(c.top30,'N',substr(c.cav,2,2),'O',c.cav),
                      c.cagrement,
                      TO_CHAR(c.NICHE),
                      c.cnaffair,
                      c.crang,
                      TO_CHAR(c.cdatarr,'dd/mm/yyyy'),
                      c.cobjet1,
                      c.cobjet2,
                      c.crem,
                      TO_CHAR(c.codsg, 'FM0000000'),
                      c.comcode,
                      ctypfact,
                      TO_CHAR(c.ccoutht,'FM9999999999D00'),
                      TO_CHAR(c.ccharesti,'FM99999D0'),
                      TO_CHAR(c.cdatdeb,'dd/mm/yyyy'),
                      TO_CHAR(c.cdatfin,'dd/mm/yyyy'),
                      TO_CHAR(c.flaglock),
                      c.SIREN
              FROM    CONTRAT c, SOCIETE soc, AGENCE a
              WHERE   c.soccont = p_soccont
              AND     soc.soccode = p_soccont
              AND     c.filcode = l_filcode
              AND     c.numcont = p_numcont
              and     c.cav = l_cav
              AND     c.siren=a.siren(+)
              AND     ROWNUM = 1;


          EXCEPTION
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20997,SQLERRM);
         END;
*/
      END IF;


      -- en cas absence
      -- p_message := "Le contrat n'existe pas";

      p_message := l_msg;

   END select_contrat;

   PROCEDURE maj_contrats_logs( p_numcont        IN CONTRATS_LOGS.numcont%TYPE,
                                p_siren          IN CONTRATS_LOGS.siren%TYPE,
                                p_soccont       IN CONTRATS_LOGS.soccont%TYPE,
                                p_cav           IN CONTRATS_LOGS.cav%TYPE,
                                p_codsg         IN CONTRATS_LOGS.codsg%TYPE,
                                p_lcnum          IN CONTRATS_LOGS.lcnum%TYPE,
                                   p_user_log        IN CONTRATS_LOGS.user_log%TYPE,
                                p_table          IN CONTRATS_LOGS.nom_table%TYPE,
                                   p_colonne        IN CONTRATS_LOGS.colonne%TYPE,
                                   p_valeur_prec    IN CONTRATS_LOGS.valeur_prec%TYPE,
                                   p_valeur_nouv    IN CONTRATS_LOGS.valeur_nouv%TYPE,
                                p_cdatdeb        IN CONTRATS_LOGS.cdatdeb%TYPE,
                                p_cdatfin        IN CONTRATS_LOGS.cdatfin%TYPE,
                                p_type_action        IN CONTRATS_LOGS.type_action%TYPE,
                                p_commentaire    IN CONTRATS_LOGS.commentaire%TYPE
                                   ) IS
   BEGIN

      if(p_type_action = 2)
      then
        INSERT INTO CONTRATS_LOGS
            (numcont,siren, soccont, cav, codsg, lcnum, date_log, user_log, nom_table, colonne, valeur_prec, valeur_nouv,cdatdeb,cdatfin,type_action, commentaire)
        VALUES
            (p_numcont,p_siren, p_soccont, p_cav, p_codsg, p_lcnum, SYSDATE, p_user_log, p_table, p_colonne, p_valeur_prec, p_valeur_nouv,p_cdatdeb,p_cdatfin,p_type_action, p_commentaire);

      else

        IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
        INSERT INTO CONTRATS_LOGS
            (numcont,siren, soccont, cav, codsg, lcnum ,date_log, user_log, nom_table, colonne, valeur_prec, valeur_nouv,cdatdeb,cdatfin,type_action, commentaire)
        VALUES
            (p_numcont,p_siren, p_soccont, p_cav, p_codsg, p_lcnum ,SYSDATE, p_user_log, p_table, p_colonne, p_valeur_prec, p_valeur_nouv,p_cdatdeb,p_cdatfin,p_type_action, p_commentaire);

        END IF;
    end if;
    -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

   END maj_contrats_logs;


PROCEDURE LISTER_SIREN_AGENCE( p_code       IN VARCHAR2,

                           p_curSiren   IN OUT Pack_Liste_Dynamique.liste_dyn
                       ) IS
BEGIN

     OPEN p_curSiren FOR
           SELECT DISTINCT SIREN,SIREN libelle
          FROM  agence a
          WHERE  trim(SOCCODE)  =  trim(p_code)
             AND SIREN IS NOT NULL
          ORDER BY SIREN DESC;

END LISTER_SIREN_AGENCE;

PROCEDURE LISTER_CONTRAT (p_ident    IN LIGNE_CONT.IDENT%TYPE,
                             p_numcont     IN CONTRAT.NUMCONT%TYPE,
                             p_siren   IN CONTRAT.SIREN%TYPE,
                             p_userid    IN VARCHAR2,
                             p_curcont   IN OUT Cont2CurType,
                             p_nbcurseur    OUT INTEGER,
                             p_message      OUT VARCHAR2
                            ) IS

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      OPEN p_curcont FOR
           SELECT a.SOCFLIB, c.SIREN, r.RNOM, r.RPRENOM, r.ident, c.NUMCONT, DECODE(c.top30,'O',DECODE(c.cav,'000',NULL,RPAD(c.cav,3)),'N',SUBSTR(c.cav,2,2) ), s.LIBDSG, TO_CHAR(l.LRESDEB,'dd/mm/yyyy'), TO_CHAR(l.LRESFIN,'dd/mm/yyyy'), a.SOCCODE
          FROM  agence a, contrat c, ressource r, ligne_cont l, struct_info s
          WHERE  c.numcont=l.numcont
             AND c.cav=l.cav
             AND c.soccont=l.soccont
             AND l.ident=r.ident
             AND c.siren=a.siren
             AND c.CODSG=s.CODSG
             -- on test les argument envoye
             AND ( r.ident=p_ident OR c.siren=p_siren OR c.numcont=p_numcont)
             AND l.lresfin > sysdate - 730
          ORDER BY c.numcont,c.cav DESC;


END LISTER_CONTRAT;

PROCEDURE LISTER_CONTRAT_PERIM (p_ident    IN LIGNE_CONT.IDENT%TYPE,
                             p_numcont     IN CONTRAT.NUMCONT%TYPE,
                             p_siren   IN CONTRAT.SIREN%TYPE,
                             p_userid    IN VARCHAR2,
                             p_liste_centre_frais IN VARCHAR2,
                             p_curcont   IN OUT Cont2CurType,
                             p_nbcurseur    OUT INTEGER,
                             p_message      OUT VARCHAR2
                            ) IS
   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur := 1;
      p_message := '';

      IF(Pack_Global.lire_globaldata(p_userid).codcfrais=0)THEN
      OPEN p_curcont FOR
           SELECT a.SOCFLIB, c.SIREN, r.RNOM, r.RPRENOM, r.ident, c.NUMCONT, DECODE(c.top30,'O',DECODE(c.cav,'000',NULL,RPAD(c.cav,3)),'N',SUBSTR(c.cav,2,2) ), s.LIBDSG, TO_CHAR(l.LRESDEB,'dd/mm/yyyy'), TO_CHAR(l.LRESFIN,'dd/mm/yyyy'), a.SOCCODE
          FROM  agence a, contrat c, ressource r, ligne_cont l, struct_info s
          WHERE  c.numcont=l.numcont
             AND c.cav=l.cav
             AND c.soccont=l.soccont
             AND l.ident=r.ident
             AND c.siren=a.siren
             AND c.CODSG=s.CODSG
             -- on test les argument envoye
             AND ( r.ident=p_ident OR c.siren=p_siren OR c.numcont=p_numcont)
             AND l.lresfin > sysdate - 730
          ORDER BY c.numcont,c.cav DESC;
      ELSE
      OPEN p_curcont FOR
           SELECT a.SOCFLIB, c.SIREN, r.RNOM, r.RPRENOM, r.ident, c.NUMCONT, DECODE(c.top30,'O',DECODE(c.cav,'000',NULL,RPAD(c.cav,3)),'N',SUBSTR(c.cav,2,2) ), s.LIBDSG, TO_CHAR(l.LRESDEB,'dd/mm/yyyy'), TO_CHAR(l.LRESFIN,'dd/mm/yyyy'), a.SOCCODE
          FROM  agence a, contrat c, ressource r, ligne_cont l, struct_info s
          WHERE  c.numcont=l.numcont
             AND c.cav=l.cav
             AND c.soccont=l.soccont
             AND l.ident=r.ident
             AND c.siren=a.siren
             AND c.CODSG=s.CODSG
             -- on test les argument envoye
             AND ( r.ident=p_ident OR c.siren=p_siren OR c.numcont=p_numcont)
             AND l.lresfin > sysdate - 730
             AND INSTR(p_liste_centre_frais,to_char(s.SCENTREFRAIS))>0
          ORDER BY c.numcont,c.cav DESC;
      END IF;

END LISTER_CONTRAT_PERIM;

PROCEDURE LISTER_CONTRAT_ORD (p_ident    IN LIGNE_CONT.IDENT%TYPE,
                             p_numcont     IN CONTRAT.NUMCONT%TYPE,
                             p_siren   IN CONTRAT.SIREN%TYPE,
                             p_userid    IN VARCHAR2,
                             p_liste_centre_frais IN VARCHAR2,
                             p_curcont   IN OUT Cont2CurType,
                             p_nbcurseur    OUT INTEGER,
                             p_message      OUT VARCHAR2
                            ) IS
   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur := 1;
      p_message := '';

      IF(Pack_Global.lire_globaldata(p_userid).codcfrais=0)THEN
      OPEN p_curcont FOR
           SELECT a.SOCFLIB, c.SIREN, r.RNOM, r.RPRENOM, r.ident, c.NUMCONT, DECODE(c.top30,'O',DECODE(c.cav,'000',NULL,RPAD(c.cav,3)),'N',SUBSTR(c.cav,2,2) ), s.LIBDSG, TO_CHAR(l.LRESDEB,'dd/mm/yyyy'), TO_CHAR(l.LRESFIN,'dd/mm/yyyy'), a.SOCCODE
          FROM  agence a, contrat c, ressource r, ligne_cont l, struct_info s
          WHERE  c.numcont=l.numcont
             AND c.cav=l.cav
             AND c.soccont=l.soccont
             AND l.ident=r.ident
             AND c.siren=a.siren
             AND c.CODSG=s.CODSG
             -- on test les argument envoye
             AND ( r.ident=p_ident OR c.siren=p_siren OR c.numcont=p_numcont)
             AND l.lresfin > sysdate - 730
          ORDER BY c.numcont,c.cav DESC;
      ELSE
      OPEN p_curcont FOR
           SELECT a.SOCFLIB, c.SIREN, r.RNOM, r.RPRENOM, r.ident, c.NUMCONT, DECODE(c.top30,'O',DECODE(c.cav,'000',NULL,RPAD(c.cav,3)),'N',SUBSTR(c.cav,2,2) ), s.LIBDSG, TO_CHAR(l.LRESDEB,'dd/mm/yyyy'), TO_CHAR(l.LRESFIN,'dd/mm/yyyy'), a.SOCCODE
          FROM  agence a, contrat c, ressource r, ligne_cont l, struct_info s
          WHERE  c.numcont=l.numcont
             AND c.cav=l.cav
             AND c.soccont=l.soccont
             AND l.ident=r.ident
             AND c.siren=a.siren
             AND c.CODSG=s.CODSG
             -- on test les argument envoye
             AND ( r.ident=p_ident OR c.siren=p_siren OR c.numcont=p_numcont)
             AND l.lresfin > sysdate - 730
             AND INSTR(p_liste_centre_frais,to_char(s.SCENTREFRAIS))>0
          ORDER BY c.numcont,c.cav DESC;
      END IF;

END LISTER_CONTRAT_ORD;


  --Function qui renvoie le cout de la ressource de la situation compatible
  -- avec la ligne de contrat
  FUNCTION get_cout_situ_comp(p_ident IN VARCHAR2,
                              p_soccont IN VARCHAR2,
                              p_lresdeb IN DATE,
                              p_lresfin IN DATE) RETURN NUMBER IS

      l_mode_contractuel VARCHAR2(20);
      l_compteur NUMBER;
      l_count NUMBER;
      l_valid NUMBER;
      l_datef DATE;
      l_datefstat DATE;
      l_datedeb DATE;
      l_datefin DATE;
      l_rtype VARCHAR2(2);
      l_ress_type VARCHAR2(2);
      l_soccode VARCHAR2(10);
      l_ctype_fact VARCHAR2(2);
      nbr NUMBER;

      t_cout    situ_ress.cout%TYPE;

     CURSOR cur_situligne IS

          SELECT datsitu, datdep FROM situ_ress
            where ident = to_number(p_ident)
            and soccode = p_soccont
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and soccode = p_soccont and datsitu <= p_lresdeb) and p_lresfin)
            order by datsitu asc;


    BEGIN

        l_valid := 1;

        SELECT count(*) into l_count FROM situ_ress
        WHERE IDENT = TO_NUMBER(p_ident)
        AND soccode = p_soccont
        AND (datsitu BETWEEN (SELECT MAX(datsitu) from situ_ress where ident = to_number(p_ident) and soccode = p_soccont and datsitu <= p_lresdeb) and p_lresfin)
        ORDER BY DATSITU ASC;

        IF(l_count = 0) THEN

            l_valid := 0;

        ELSIF(l_count = 1) THEN

            SELECT datsitu, datdep into l_datedeb,l_datefin FROM situ_ress
              where ident = to_number(p_ident)
              and soccode = p_soccont
              and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and soccode = p_soccont and datsitu <= p_lresdeb) and p_lresfin)
              and rownum = 1
              order by datsitu asc;

            IF((l_datedeb > p_lresdeb) or ((l_datefin is not null) and (l_datefin < p_lresfin))) THEN
              l_valid := 0;
            END IF;

        ELSE

            l_datefstat := TO_DATE('01/01/1900','DD/MM/YYYY');
            l_datef := TO_DATE('01/01/1900','DD/MM/YYYY');
            l_compteur := 0;


            IF((p_lresdeb is null) and (p_lresfin is null)) THEN
             return '';
            END IF;

            FOR one_situligne IN cur_situligne LOOP
               l_compteur := l_compteur+1;
               l_datedeb := one_situligne.datsitu;
               l_datefin := one_situligne.datdep;

                 IF((one_situligne.datdep is not null) and (one_situligne.datdep <= p_lresfin)) THEN
                     IF(l_datef != l_datefstat) THEN
                       IF(l_datef = one_situligne.datsitu) THEN
                           l_datef := one_situligne.datdep + 1;
                       ELSE
                         l_valid := 0;
                         EXIT;
                       END IF;
                     ELSE
                         l_datef := one_situligne.datdep + 1;
                     END IF;
                   ELSIF(one_situligne.datdep is null) THEN
                     IF(l_datef != l_datefstat) THEN
                       IF(l_datef != one_situligne.datsitu) THEN
                         l_valid := 0;
                         EXIT;
                       END IF;
                     END IF;
                   END IF;
            END LOOP;

            IF(
               ((l_datefin IS NOT NULL) AND  (l_datefin < p_lresfin))
             OR
               ((l_datefin IS NOT NULL) AND  (l_datefin > p_lresfin) and (l_datef != p_lresfin) and (l_datef != l_datedeb))
              ) THEN
               l_valid := 0;
            END IF;

        END IF;

        IF(l_valid = 1) THEN

            BEGIN
                IF(l_datefin IS NOT NULL) THEN

                    SELECT cout into t_cout FROM situ_ress
                      where datsitu =  l_datedeb
                      and datdep = l_datefin
                      and soccode = p_soccont
                      and ident = p_ident;

                ELSE

                    SELECT cout into t_cout FROM situ_ress
                      where datsitu =  l_datedeb
                      and datdep is null
                      and soccode = p_soccont
                      and ident = p_ident;

                END IF;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

        ELSE

            l_mode_contractuel := '0'; --ce mode contractuel n'existe pas

        END IF;

    return t_cout;

  END get_cout_situ_comp;

--PPM 59805 : KRA 
  FUNCTION INSERT_TMP_CONTRATRF(p_critereDosPac IN  VARCHAR2, 
                              p_champsDosPac IN VARCHAR2,
                              p_critereRefCon IN VARCHAR2,
                              p_champsRefCon IN VARCHAR2,
                              p_critereRefAve IN VARCHAR2,
                              p_champsRefAve IN VARCHAR2,
                              p_critereNom IN VARCHAR2,
                              p_champsNom IN VARCHAR2,
                              p_critereIgg IN VARCHAR2,
                              p_champsIgg IN VARCHAR2,
                              p_critereMatArp IN VARCHAR2,
                              p_champsMatArp IN VARCHAR2,
                              p_critereIdenBip IN VARCHAR2,
                              p_champsIdenBip IN VARCHAR2,
                              p_critereRefFac IN VARCHAR2,
                              p_champsRefFac IN VARCHAR2,
                              p_critereRefExp IN VARCHAR2,
                              p_champsRefExp IN VARCHAR2,
                              p_champsRacine IN VARCHAR2,
                              p_champsAvenant IN VARCHAR2,
                              p_global IN VARCHAR2,
                              p_centrefrais IN VARCHAR2,
                              p_arborescence IN VARCHAR2) RETURN NUMBER IS
                              
l_numseq        NUMBER ;
l_perim_me      VARCHAR2(6000);
v_query1_societe VARCHAR2(6000);
v_queryfinale_societe VARCHAR2(6000);
v_query1_contrat VARCHAR2(6000);
v_queryfinale_contrat VARCHAR2(6000);
v_queryfinale_contrat_rejet VARCHAR2(6000);
v_query1_contrat_rejet VARCHAR2(6000);
v_query1_ressource VARCHAR2(6000);
v_queryfinale_ressource VARCHAR2(6000);
v_queryfinale_ressource_rejet VARCHAR2(6000);
v_query1_ressource_rejet VARCHAR2(6000);
v_query1_facture VARCHAR2(6000);
v_queryfinale_facture VARCHAR2(6000);
v_query1_facture_rejet VARCHAR2(6000);
v_queryfinale_facture_rejet VARCHAR2(6000);
req_societe VARCHAR2(6000);
req_contrat VARCHAR2(6000);
req_ressource VARCHAR2(6000);
req_facture VARCHAR2(6000);
req_facture_rejet VARCHAR2(6000);
req_contrat_rejet VARCHAR2(6000);
req_ressource_rejet VARCHAR2(6000);
req_societe_1 VARCHAR2(6000);
req_societe_2 VARCHAR2(6000);
req_societe_3 VARCHAR2(6000);
req_societe_4 VARCHAR2(6000);
req_societe_5 VARCHAR2(6000);
req_count_cont VARCHAR2(300);
req_count_ress VARCHAR2(300);
req_count_fact VARCHAR2(300);
req_count_cont_rej VARCHAR2(300);
req_count_ress_rej VARCHAR2(300);
req_count_fact_rej VARCHAR2(300);
l_req_where_cl    VARCHAR2(255);
PERIM_ME          BOOLEAN;
isClone BOOLEAN;--PPM 1691 : 27/03/2015 (clone)

critereDosPac VARCHAR2(1);
critereRefCon VARCHAR2(1);
critereRefAve VARCHAR2(1);
critereNom VARCHAR2(1);
critereIgg VARCHAR2(1);
critereMatArp VARCHAR2(1);
critereIdenBip VARCHAR2(1);
critereRefFac VARCHAR2(1);
critereRefExp VARCHAR2(1);
champsDosPac VARCHAR2(40);
champsRefCon VARCHAR2(40);
champsRefAve VARCHAR2(40);
champsNom VARCHAR2(40);
champsIgg1 VARCHAR2(40);
champsIgg2 VARCHAR2(40);
champsMatArp1 VARCHAR2(40);
champsMatArp2 VARCHAR2(40);
champsIdenBip VARCHAR2(40);
champsRefFac VARCHAR2(40);
champsRefExp VARCHAR2(40);
champsRacine VARCHAR2(40);
champsAvenant VARCHAR2(40);
req_centre_frais VARCHAR2(1000);
req_dpg_perim_me VARCHAR2(1000);
l_maxvarchar NUMBER;
l_req_societe VARCHAR2(6000);

t_codsg     vue_dpg_perime.CODSG%TYPE;

    P_HFILE        utl_file.file_type;     -- Pointeur de fichier log
    L_RETCOD    number;            -- Receptionne le code retour d'une procedure
    L_PROCNAME     varchar2(30):='P_INSERT_TMP_CONTRATRF'; -- nom de la procedure courante
    P_LOGDIR VARCHAR2(30):='PL_LOGS';
    
BEGIN

    -- Init de la trace
    -- ----------------
    L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, P_HFILE );
    if ( L_RETCOD <> 0 ) then
        raise_application_error( -20300,
        'Erreur : Gestion du fichier LOG impossible', false );
    end if;

    -- Trace Start
    -- -----------
    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Debut.');
    
    

--initialisations
req_dpg_perim_me := '';
req_centre_frais := '';
PERIM_ME := false;
isClone := false;--PPM 1691 : 27/03/2015 (clone)
champsIgg1 := '';
champsIgg2 := '';
champsMatArp1 := '';
champsMatArp2 := '';
critereDosPac  := p_critereDosPac;
critereRefCon  := p_critereRefCon;
critereRefAve  := p_critereRefAve;
critereNom  := p_critereNom;
critereIgg  := p_critereIgg;
critereMatArp  := p_critereMatArp;
critereIdenBip  := p_critereIdenBip;
critereRefFac  := p_critereRefFac;
critereRefExp  := p_critereRefExp;
if p_champsDosPac is not null then champsDosPac := upper(p_champsDosPac); else champsDosPac := ''; end if;
if p_champsRefCon is not null then champsRefCon := upper(p_champsRefCon); else champsRefCon := ''; end if;
if p_champsRefAve is not null then champsRefAve := upper(p_champsRefAve); else champsRefAve := ''; end if;
if p_champsNom is not null then champsNom := upper(p_champsNom); else champsNom := ''; end if;
if p_champsIdenBip is not null then champsIdenBip := upper(p_champsIdenBip); else champsIdenBip := ''; end if;
if p_champsRefFac is not null then champsRefFac := upper(p_champsRefFac); else champsRefFac := ''; end if;
if p_champsRefExp is not null then champsRefExp := upper(p_champsRefExp); else champsRefExp := ''; end if;
if p_champsRacine is not null then champsRacine := upper(p_champsRacine); else champsRacine := ''; end if;
if p_champsAvenant is not null then champsAvenant := upper(p_champsAvenant); else champsAvenant := ''; end if;

--génération d'un numéro de process
 SELECT BIP.SETATKE.NEXTVAL INTO l_numseq FROM DUAL ;

 if INSTR(p_arborescence, 'Responsable') = 1 THEN
      PERIM_ME := true;
      l_perim_me := pack_global.lire_perime( p_global);
      if l_perim_me is not null then
      req_dpg_perim_me := ' (SELECT codsg FROM vue_dpg_perime where INSTR('''|| l_perim_me || ''', codbddpg) > 0) ';
      end if;
    elsif INSTR(p_arborescence, 'Ordonnancement') = 1 THEN
      PERIM_ME := false;
      if p_centrefrais is not null AND p_centrefrais != 0 THEN
      req_centre_frais := ' ('|| p_centrefrais ||') ';
      end if;
  end if;

  IF p_champsIgg is not null THEN
      champsIgg1 := p_champsIgg; --QC 1694
     IF INSTR(p_champsIgg,'9')=1 THEN --recherche par l'IGG
        isClone := true;--PPM 1691 : 27/03/2015 (clone)
        champsIgg1 := '1'||SUBSTR(to_char(p_champsIgg),2);
        champsIgg2 := p_champsIgg;
     END IF;
      IF INSTR(p_champsIgg,'1')=1 THEN --recherche par l'IGG clone
        isClone := false;--PPM 1691 : 27/03/2015 (clone)
        champsIgg1 := p_champsIgg;
        champsIgg2 := '9'||SUBSTR(to_char(p_champsIgg),2);
     END IF;
  END IF;


 IF p_champsMatArp is not null THEN
      champsMatArp1 := p_champsMatArp; --QC 1694
     IF INSTR(upper(p_champsMatArp),'Y')=1 THEN  -- recherche par le matricule
        isClone := true;--PPM 1691 : 27/03/2015 (clone)
        champsMatArp1 := 'X'||SUBSTR(p_champsMatArp,2)||'';
        champsMatArp2 := p_champsMatArp;
     END IF;
      IF INSTR(upper(p_champsMatArp),'X')=1 THEN  -- recherche par le matricule clone
        isClone := false;--PPM 1691 : 27/03/2015 (clone)
        champsMatArp1 := p_champsMatArp;
        champsMatArp2 := 'Y'||SUBSTR(p_champsMatArp,2)||'';
     END IF;
  END IF;


req_contrat := 'SELECT DISTINCT '|| l_numseq ||',CONTRAT.CDATSAI,CONTRAT.SOCCONT,CONTRAT.SIREN,CONTRAT.NUMCONT,
					CONTRAT.CAV,CONTRAT.CDATDEB,CONTRAT.CDATFIN,LIGNE_CONT.IDENT,RESSOURCE.RNOM,RESSOURCE.MATRICULE,
					RESSOURCE.IGG,CONTRAT.CODSG,LIGNE_CONT.LCCOUACT,LIGNE_CONT.LRESDEB,LIGNE_CONT.LRESFIN,
					LIGNE_CONT.LCNUM
					FROM CONTRAT contrat
          LEFT JOIN LIGNE_CONT ligne_cont ON contrat.numcont = ligne_cont.numcont and contrat.cav = ligne_cont.cav AND contrat.soccont = ligne_cont.soccont
          LEFT OUTER JOIN FACTURE facture ON facture.numcont = contrat.numcont AND  contrat.soccont = facture.soccont AND contrat.cav = facture.cav
          LEFT OUTER JOIN LIGNE_FACT ligne_fact ON ligne_fact.numfact = facture.numfact and ligne_fact.ident = ligne_cont.ident AND ligne_fact.socfact = facture.socfact and ligne_fact.typfact = facture.typfact and ligne_fact.datfact = facture.datfact
          LEFT OUTER JOIN RESSOURCE ressource ON ressource.ident = ligne_cont.ident
					WHERE ';
    calculRequete('contrat',req_contrat, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me, isClone);--PPM 1691 : 27/03/2015 (clone)

req_contrat := req_contrat || ' UNION ';

req_contrat := req_contrat || 'SELECT DISTINCT '|| l_numseq ||',CONTRAT.CDATSAI,CONTRAT.SOCCONT,CONTRAT.SIREN,CONTRAT.NUMCONT,
					CONTRAT.CAV,CONTRAT.CDATDEB,CONTRAT.CDATFIN,LIGNE_CONT.IDENT,RESSOURCE.RNOM,RESSOURCE.MATRICULE,
					RESSOURCE.IGG,CONTRAT.CODSG,LIGNE_CONT.LCCOUACT,LIGNE_CONT.LRESDEB,LIGNE_CONT.LRESFIN,
					LIGNE_CONT.LCNUM
					FROM CONTRAT contrat
          LEFT JOIN LIGNE_CONT ligne_cont ON contrat.numcont = ligne_cont.numcont and contrat.cav = ligne_cont.cav AND contrat.soccont = ligne_cont.soccont
          LEFT OUTER JOIN FACTURE facture ON facture.numcont = contrat.numcont AND  contrat.soccont = facture.soccont AND contrat.cav = facture.cav
          LEFT OUTER JOIN LIGNE_FACT ligne_fact ON ligne_fact.numfact = facture.numfact and ligne_fact.ident = ligne_cont.ident AND ligne_fact.socfact = facture.socfact and ligne_fact.typfact = facture.typfact and ligne_fact.datfact = facture.datfact
          LEFT OUTER JOIN RESSOURCE ressource ON ressource.ident = ligne_cont.ident
          JOIN EBIS_FACT_REJET EBIS_FACT_REJET ON contrat.numcont = EBIS_FACT_REJET.numcont AND contrat.CAV = EBIS_FACT_REJET.CAV
					WHERE ';
    calculRequete('contrat_fact_rej',req_contrat, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me, isClone);


req_contrat_rejet :='SELECT DISTINCT '|| l_numseq ||', PRA_CONTRAT.DATE_TRAIT, PRA_CONTRAT.SOCCONT, PRA_CONTRAT.SIREN_FRS,
          TRIM(PRA_CONTRAT.NUM_CONTRAT) || '' / '' || PRA_CONTRAT.CAV, PRA_CONTRAT.DATE_DEB_CTRA || CHR(10) || PRA_CONTRAT.DATE_FIN_CTRA,
          PRA_CONTRAT.IDENT_RESSOURCE || '' - '' || PRA_CONTRAT.NOM_RESSOURCE, PRA_CONTRAT.MATRICULE_RESSOURCE, PRA_CONTRAT.IGG_RESSOURCE,
          PRA_CONTRAT.DPG, TO_CHAR(PRA_CONTRAT.COUT_ORIGINE_SITU, ''FM99999D00''), PRA_CONTRAT.RETOUR
          FROM PRA_CONTRAT
          LEFT JOIN RESSOURCE ressource ON ressource.IDENT = PRA_CONTRAT.IDENT_RESSOURCE 


          LEFT JOIN FACTURE facture ON facture.NUMCONT = PRA_CONTRAT.NUM_CONTRAT
          LEFT JOIN CONTRAT contrat ON contrat.NUMCONT = PRA_CONTRAT.NUM_CONTRAT
          WHERE ';--ajouter pour le CF
    calculRequete('contrat_rejet',req_contrat_rejet, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me, isClone);


			--RESSOURCE
req_ressource :='SELECT DISTINCT '|| l_numseq ||',RESSOURCE.IDENT,RESSOURCE.RNOM,RESSOURCE.RPRENOM,
					RESSOURCE.MATRICULE,RESSOURCE.IGG,SITU_RESS.CODSG,SITU_RESS.CPIDENT,SITU_RESS.PRESTATION,SITU_RESS.MODE_CONTRACTUEL_INDICATIF,
					SITU_RESS.SOCCODE,SITU_RESS.COUT,SITU_RESS.DATSITU,SITU_RESS.DATDEP,(select siren from agence where soccode = societe.soccode and rownum < 2) SIREN,SOCIETE.SOCLIB,
					(SELECT sum(CUSAG) FROM CONS_SSTACHE_RES_MOIS WHERE cons_sstache_res_mois.ident  = ressource.ident) as CONSOANNUEL
					FROM RESSOURCE ressource
					LEFT JOIN LIGNE_FACT ligne_fact ON ressource.ident = ligne_fact.ident
					LEFT OUTER JOIN FACTURE facture ON ligne_fact.numfact = facture.numfact
					LEFT OUTER JOIN LIGNE_CONT ligne_cont ON ligne_cont.ident = ressource.ident
					LEFT OUTER JOIN CONTRAT contrat ON contrat.numcont = ligne_cont.numcont
					LEFT OUTER JOIN SITU_RESS situ_ress ON ressource.ident  = situ_ress.ident
					LEFT OUTER JOIN SOCIETE societe ON situ_ress.soccode = societe.soccode
					LEFT OUTER JOIN AGENCE agence ON societe.soccode  = agence.soccode
					LEFT OUTER JOIN CONS_SSTACHE_RES_MOIS cons_sstache_res_mois ON cons_sstache_res_mois.ident  = ressource.ident
          LEFT OUTER JOIN STRUCT_INFO struct_info ON situ_ress.codsg  = struct_info.codsg ';--PPM 1699 : pour avoir le SCENTREFRAIS de la ressource dans la table struct_info
          if (NVL(req_dpg_perim_me,'^') <> '^') then
          req_ressource := req_ressource  || ' JOIN (select codsg from vue_dpg_perime  where INSTR('''|| l_perim_me || ''', codbddpg) > 0) VDP ON situ_ress.codsg=VDP.CODSG ';--QC 1692 et 1688
          end if;
					req_ressource := req_ressource  || ' WHERE ';
    calculRequete('ressource',req_ressource, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me, isClone);
--requête pour ramener les ressources qui ont des factures rejetées
req_ressource := req_ressource  || ' UNION ';
req_ressource := req_ressource  || 'SELECT DISTINCT '|| l_numseq ||',RESSOURCE.IDENT,RESSOURCE.RNOM,RESSOURCE.RPRENOM,
					RESSOURCE.MATRICULE,RESSOURCE.IGG,SITU_RESS.CODSG,SITU_RESS.CPIDENT,SITU_RESS.PRESTATION,SITU_RESS.MODE_CONTRACTUEL_INDICATIF,
					SITU_RESS.SOCCODE,SITU_RESS.COUT,SITU_RESS.DATSITU,SITU_RESS.DATDEP,(select siren from agence where soccode = societe.soccode and rownum < 2) SIREN,SOCIETE.SOCLIB,
					(SELECT sum(CUSAG) FROM CONS_SSTACHE_RES_MOIS WHERE cons_sstache_res_mois.ident  = ressource.ident) as CONSOANNUEL
					FROM RESSOURCE ressource
					LEFT JOIN LIGNE_FACT ligne_fact ON ressource.ident = ligne_fact.ident
					LEFT OUTER JOIN FACTURE facture ON ligne_fact.numfact = facture.numfact
					LEFT OUTER JOIN LIGNE_CONT ligne_cont ON ligne_cont.ident = ressource.ident
					LEFT OUTER JOIN CONTRAT contrat ON contrat.numcont = ligne_cont.numcont
					LEFT OUTER JOIN SITU_RESS situ_ress ON ressource.ident  = situ_ress.ident
					LEFT OUTER JOIN SOCIETE societe ON situ_ress.soccode = societe.soccode
					LEFT OUTER JOIN AGENCE agence ON societe.soccode  = agence.soccode
					LEFT OUTER JOIN CONS_SSTACHE_RES_MOIS cons_sstache_res_mois ON cons_sstache_res_mois.ident  = ressource.ident
          LEFT OUTER JOIN EBIS_FACT_REJET ebis_fact_rejet ON ressource.ident = ebis_fact_rejet.ident
          LEFT OUTER JOIN STRUCT_INFO struct_info ON situ_ress.codsg  = struct_info.codsg
          WHERE ';--PPM 1699 : pour avoir le SCENTREFRAIS de la ressource dans la table struct_info
          --PPM 1698 : ajout de jointure ressource.ident = ebis_fact_rejet.ident pour avoir les ressources liées aux factures rejetées
          calculRequete('ressource_fact_rej',req_ressource, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me, isClone);


req_ressource_rejet :='SELECT DISTINCT '|| l_numseq ||', TRUNC(PRA_RESSOURCE.DATE_TRAIT), PRA_RESSOURCE.IDENT_RESSOURCE, PRA_RESSOURCE.NOM_RESSOURCE,
          PRA_RESSOURCE.PRENOM_RESSOURCE, PRA_RESSOURCE.MATRICULE_RESSOURCE, PRA_RESSOURCE.IGG_RESSOURCE, PRA_RESSOURCE.DPG,
          PRA_RESSOURCE.IDENT_DO, PRA_RESSOURCE.PRESTATION, PRA_RESSOURCE.MCI, PRA_RESSOURCE.SOCCODE,
          REPLACE(PRA_RESSOURCE.COUT, ''.'', '',''), PRA_RESSOURCE.DATE_DEB_SITUATION, PRA_RESSOURCE.DATE_FIN_SITUATION, PRA_RESSOURCE.RETOUR
          FROM PRA_RESSOURCE
          LEFT JOIN LIGNE_FACT ligne_fact ON pra_ressource.ident_do = ligne_fact.ident
					LEFT OUTER JOIN FACTURE facture ON ligne_fact.numfact = facture.numfact
					LEFT OUTER JOIN LIGNE_CONT ligne_cont ON ligne_cont.ident = pra_ressource.ident_do
					LEFT OUTER JOIN CONTRAT contrat ON contrat.numcont = ligne_cont.numcont
					LEFT OUTER JOIN SITU_RESS situ_ress ON pra_ressource.ident_do  = situ_ress.ident

          LEFT OUTER JOIN STRUCT_INFO struct_info ON situ_ress.codsg  = struct_info.codsg ';--PPM 1699 : pour avoir le SCENTREFRAIS de la ressource dans la table struct_info
          if (NVL(req_dpg_perim_me,'^') <> '^') then
          req_ressource_rejet := req_ressource_rejet || ' JOIN (select codsg from vue_dpg_perime
          where INSTR('''|| l_perim_me || ''', codbddpg) > 0) VDP ON pra_ressource.DPG=VDP.CODSG ';
          end if;
          req_ressource_rejet := req_ressource_rejet || ' WHERE to_date(to_char(date_trait,''dd/mm/yyyy'')) > add_months(sysdate,-2)  AND code_retour  = ''0'' ';

          if (NVL(req_centre_frais,'^') <> '^') then
          req_ressource_rejet := req_ressource_rejet || ' AND struct_info.SCENTREFRAIS in ' || req_centre_frais;
          end if;

          calculRequete('ressource_rejet',req_ressource_rejet, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me, isClone);

--Les rejets de ressources avec motif « DPG inconnu » doivent êtres consultables hors profil RTFE (même si le contrat associée à cette ressource n'est pas présent dans la table CONTRAT)
req_ressource_rejet := req_ressource_rejet || ' UNION
          SELECT DISTINCT '|| l_numseq ||', TRUNC(PRA_RESSOURCE.DATE_TRAIT), PRA_RESSOURCE.IDENT_RESSOURCE, PRA_RESSOURCE.NOM_RESSOURCE,
          PRA_RESSOURCE.PRENOM_RESSOURCE, PRA_RESSOURCE.MATRICULE_RESSOURCE, PRA_RESSOURCE.IGG_RESSOURCE, PRA_RESSOURCE.DPG,
          PRA_RESSOURCE.IDENT_DO, PRA_RESSOURCE.PRESTATION, PRA_RESSOURCE.MCI, PRA_RESSOURCE.SOCCODE,
          REPLACE(PRA_RESSOURCE.COUT, ''.'', '',''), PRA_RESSOURCE.DATE_DEB_SITUATION, PRA_RESSOURCE.DATE_FIN_SITUATION, PRA_RESSOURCE.RETOUR
          FROM PRA_RESSOURCE
          LEFT JOIN LIGNE_FACT ligne_fact ON pra_ressource.ident_do = ligne_fact.ident
					LEFT OUTER JOIN FACTURE facture ON ligne_fact.numfact = facture.numfact
					LEFT OUTER JOIN LIGNE_CONT ligne_cont ON ligne_cont.ident = pra_ressource.ident_do
					LEFT OUTER JOIN CONTRAT contrat ON contrat.numcont = ligne_cont.numcont
					LEFT OUTER JOIN SITU_RESS situ_ress ON pra_ressource.ident_do  = situ_ress.ident
          WHERE RETOUR like ''DPG inconnu%''
          AND to_date(to_char(date_trait,''dd/mm/yyyy'')) > add_months(sysdate,-2)
          AND code_retour  = ''0'' ' ;
    calculRequete('ressource_rejet',req_ressource_rejet, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me, isClone);

			--FACTURE
      --QC 1689 : Ajout de jointure entre facture et ligne_fact (AND facture.SOCFACT = ligne_fact.SOCFACT AND facture.TYPFACT = ligne_fact.TYPFACT AND facture.DATFACT = ligne_fact.DATFACT  )
req_facture :='SELECT DISTINCT '|| l_numseq ||',FACTURE.FDATSAI,FACTURE.SOCFACT,FACTURE.NUMFACT,FACTURE.NUM_EXPENSE,
					FACTURE.TYPFACT,FACTURE.DATFACT,FACTURE.FMONTHT,FACTURE.NUMCONT,FACTURE.CAV,LIGNE_FACT.LMOISPREST,
					LIGNE_FACT.IDENT,RESSOURCE.RNOM,LIGNE_FACT.LNUM,FACTURE.FDEPPOLE,STRUCT_INFO.LIBDSG
					FROM FACTURE facture INNER JOIN LIGNE_FACT ligne_fact ON facture.numfact = ligne_fact.numfact AND facture.SOCFACT = ligne_fact.SOCFACT AND facture.TYPFACT = ligne_fact.TYPFACT AND facture.DATFACT = ligne_fact.DATFACT
					LEFT OUTER JOIN RESSOURCE ressource ON ressource.ident = ligne_fact.ident
					LEFT OUTER JOIN CONTRAT contrat ON contrat.numcont = facture.numcont and contrat.cav = facture.cav
					LEFT OUTER JOIN STRUCT_INFO struct_info ON facture.FDEPPOLE = struct_info.codsg ';--QC 1687 : ajout de jointure contrat.cav = facture.cav
          if (NVL(req_dpg_perim_me,'^') <> '^') then
          req_facture := req_facture || ' JOIN (select codsg from vue_dpg_perime  where INSTR('''|| l_perim_me || ''', codbddpg) > 0) VDP ON facture.FDEPPOLE=VDP.CODSG ';--QC 1690
          end if;
					req_facture := req_facture || ' WHERE ';
    calculRequete('facture',req_facture, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me, isClone);

req_facture_rejet :='SELECT DISTINCT '|| l_numseq ||', EBIS_FACT_REJET.TIMESTAMP, FACTURE.SOCFACT, EBIS_FACT_REJET.NUMFACT, EBIS_FACT_REJET.NUM_EXPENSE,
				EBIS_FACT_REJET.TYPFACT, EBIS_FACT_REJET.DATFACT, EBIS_FACT_REJET.FMONTHT, EBIS_FACT_REJET.NUMCONT, EBIS_FACT_REJET.CAV, EBIS_FACT_REJET.LMOISPREST,
				EBIS_FACT_REJET.IDENT, RESSOURCE.RNOM, EBIS_FACT_REJET.LNUM, EBIS_FACT_REJET.CODE_RETOUR
				FROM EBIS_FACT_REJET
				LEFT JOIN FACTURE ON TRIM(EBIS_FACT_REJET.NUMFACT) = TRIM(FACTURE.NUMFACT)
				LEFT OUTER JOIN CONTRAT contrat ON contrat.numcont = EBIS_FACT_REJET.numcont AND contrat.CAV = EBIS_FACT_REJET.CAV
				LEFT OUTER JOIN PRA_CONTRAT pra_contrat ON TRIM(pra_contrat.NUM_CONTRAT) = TRIM(EBIS_FACT_REJET.numcont) AND pra_contrat.CAV = EBIS_FACT_REJET.CAV 
				LEFT JOIN RESSOURCE ressource ON EBIS_FACT_REJET.IDENT = RESSOURCE.IDENT
				WHERE ';
    calculRequete('facture_rejet',req_facture_rejet, critereDosPac, critereRefCon, critereRefAve, critereNom, critereIgg, critereMatArp, critereIdenBip, critereRefFac, critereRefExp, champsDosPac, champsRefCon, champsRefAve, champsNom, champsIgg1, champsIgg2, champsMatArp1, champsMatArp2, champsIdenBip, champsRefFac, champsRefExp, champsRacine, champsAvenant, req_centre_frais, req_dpg_perim_me, isClone);

l_maxvarchar := 800;
--trace des requpêtes dans les log
TRACE_LOGS( P_HFILE, L_PROCNAME, 'req_contrat', req_contrat, l_maxvarchar);
TRACE_LOGS( P_HFILE, L_PROCNAME, 'req_contrat_rejet', req_contrat_rejet, l_maxvarchar);
TRACE_LOGS( P_HFILE, L_PROCNAME, 'req_ressource', req_ressource, l_maxvarchar);
TRACE_LOGS( P_HFILE, L_PROCNAME, 'req_ressource_rejet', req_ressource_rejet, l_maxvarchar);
TRACE_LOGS( P_HFILE, L_PROCNAME, 'req_facture', req_facture, l_maxvarchar);
TRACE_LOGS( P_HFILE, L_PROCNAME, 'req_facture_rejet', req_facture_rejet, l_maxvarchar);

--on exécute les requêtes d'insertion des données dans les tables temporaires
v_query1_contrat := 'INSERT INTO TMP_CONTRATRF ';
v_queryfinale_contrat := v_query1_contrat || req_contrat ;
-- DBMS_OUTPUT.PUT_LINE('v_queryfinale_contrat = ' || v_queryfinale_contrat);
EXECUTE IMMEDIATE v_queryfinale_contrat ;
COMMIT;

v_query1_contrat_rejet := 'INSERT INTO TMP_CONTRAT_REJETRF ';
v_queryfinale_contrat_rejet := v_query1_contrat_rejet || req_contrat_rejet ;
-- DBMS_OUTPUT.PUT_LINE('v_queryfinale_contrat_rejet = ' || v_queryfinale_contrat_rejet);
EXECUTE IMMEDIATE v_queryfinale_contrat_rejet ;
COMMIT;

v_query1_ressource := 'INSERT INTO TMP_RESSOURCERF ';
v_queryfinale_ressource := v_query1_ressource || req_ressource;
-- DBMS_OUTPUT.PUT_LINE('v_queryfinale_ressource = ' || v_queryfinale_ressource);
EXECUTE IMMEDIATE v_queryfinale_ressource ;
COMMIT;

v_query1_ressource_rejet := 'INSERT INTO TMP_RESSOURCE_REJETRF ';
v_queryfinale_ressource_rejet := v_query1_ressource_rejet || req_ressource_rejet;
-- DBMS_OUTPUT.PUT_LINE('v_queryfinale_ressource_rejet = ' || v_queryfinale_ressource_rejet);
EXECUTE IMMEDIATE v_queryfinale_ressource_rejet ;
COMMIT;

v_query1_facture :='INSERT INTO TMP_FACTURERF ';
v_queryfinale_facture := v_query1_facture || req_facture ;
-- DBMS_OUTPUT.PUT_LINE('v_queryfinale_facture = ' || v_queryfinale_facture);
EXECUTE IMMEDIATE v_queryfinale_facture ;
COMMIT;

v_query1_facture_rejet :='INSERT INTO TMP_FACTURE_REJETRF ';
v_queryfinale_facture_rejet := v_query1_facture_rejet || req_facture_rejet ;
-- DBMS_OUTPUT.PUT_LINE('v_queryfinale_facture_rejet = ' || v_queryfinale_facture_rejet);
EXECUTE IMMEDIATE v_queryfinale_facture_rejet ;
COMMIT;

-- construction de la requête société
req_societe := 'SELECT DISTINCT  '|| l_numseq||', SOCIETE.SOCLIB,SOCIETE.SOCCODE soccod,(select siren from agence where soccode = societe.soccode and rownum < 2) SIREN,SOCIETE.SOCCRE, EBIS_FOURNISSEURS1.CODE_FOURNISSEUR_EBIS CODE_FOURNISSEUR_EBIS_1, EBIS_FOURNISSEURS2.CODE_FOURNISSEUR_EBIS CODE_FOURNISSEUR_EBIS_2
                FROM SOCIETE societe, AGENCE agence, EBIS_FOURNISSEURS EBIS_FOURNISSEURS1, EBIS_FOURNISSEURS EBIS_FOURNISSEURS2 ,
                      (select distinct SOCCONT from ( select SOCCONT from TMP_CONTRATRF WHERE NUMERO_PROCESS_ENCOURS ='|| l_numseq||'
                      union select SOCCODE from TMP_RESSOURCERF WHERE NUMERO_PROCESS_ENCOURS ='|| l_numseq||'
                      union select SOCFACT from TMP_FACTURERF WHERE NUMERO_PROCESS_ENCOURS ='|| l_numseq||'
                      union select SOCCONT from TMP_CONTRAT_REJETRF WHERE NUMERO_PROCESS_ENCOURS ='|| l_numseq||'
                      union select SOCCODE from TMP_RESSOURCE_REJETRF WHERE NUMERO_PROCESS_ENCOURS ='|| l_numseq||'
                      union select SOCFACT from TMP_FACTURE_REJETRF WHERE NUMERO_PROCESS_ENCOURS ='|| l_numseq||')) VSOC
                WHERE societe.soccode = agence.soccode
                AND (societe.soccode = EBIS_FOURNISSEURS1.soccode(+) AND EBIS_FOURNISSEURS1.REFERENTIEL(+) = ''FR001'' )
                AND (societe.soccode = EBIS_FOURNISSEURS2.soccode(+) AND EBIS_FOURNISSEURS2.REFERENTIEL(+) = ''FR002'' )
                AND societe.soccode = VSOC.SOCCONT';

TRACE_LOGS( P_HFILE, L_PROCNAME, 'req_societe', req_societe, l_maxvarchar);
--exécution de la requête d'insertion des données ramenées par la requête societe dans la table temporaire
v_query1_societe := 'INSERT INTO TMP_SOCIETERF ';
v_queryfinale_societe := v_query1_societe || req_societe ;
EXECUTE IMMEDIATE v_queryfinale_societe ;
COMMIT;
    -- Trace Stop
    -- ----------
    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Fin normale.');
    TRCLOG.CLOSETRCLOG( P_HFILE );

return l_numseq ;

END INSERT_TMP_CONTRATRF;

--procédure pour tracer dans les logs des chaines de caractère très long
PROCEDURE TRACE_LOGS(P_HFILE utl_file.file_type, P_PROCNAME IN  VARCHAR2,P_TEXT IN  VARCHAR2, P_CHAINE IN  VARCHAR2, p_maxvarchar IN  NUMBER) IS

L_CHAINE VARCHAR2(6000);
BEGIN

  if (length(P_CHAINE)>p_maxvarchar) then
  TRCLOG.TRCLOG( P_HFILE, P_PROCNAME || ' : '|| P_TEXT ||' = ' || SUBSTR(P_CHAINE, 0, p_maxvarchar));
  L_CHAINE := SUBSTR(P_CHAINE, p_maxvarchar+1);
  while (length(L_CHAINE)>p_maxvarchar) loop
  TRCLOG.TRCLOG( P_HFILE, P_PROCNAME || ' : '|| P_TEXT ||' (suite) = ' || SUBSTR(L_CHAINE, 0, p_maxvarchar ) );
  L_CHAINE := SUBSTR(L_CHAINE, p_maxvarchar+1);
  end loop;
  TRCLOG.TRCLOG( P_HFILE, P_PROCNAME || ' : '|| P_TEXT ||' (suite) = ' || SUBSTR(L_CHAINE, 0 ) || ';');


  else
  TRCLOG.TRCLOG( P_HFILE, P_PROCNAME || ' : '|| P_TEXT ||' = ' || P_CHAINE || ';');
  end if;

END TRACE_LOGS;


PROCEDURE  calculRequete(cas IN  VARCHAR2,
                        requete IN OUT  VARCHAR2,
                        critereDosPac IN  VARCHAR2,
                        critereRefCon IN  VARCHAR2,
                        critereRefAve IN  VARCHAR2,
                        critereNom IN  VARCHAR2,
                        critereIgg IN  VARCHAR2,
                        critereMatArp IN  VARCHAR2,
                        critereIdenBip IN  VARCHAR2,
                        critereRefFac IN  VARCHAR2,
                        critereRefExp IN  VARCHAR2,
                        champsDosPac IN  VARCHAR2,
                        champsRefCon IN  VARCHAR2,
                        champsRefAve IN  VARCHAR2,
                        champsNom IN  VARCHAR2,
                        champsIgg1 IN  VARCHAR2,
                        champsIgg2 IN  VARCHAR2,
                        champsMatArp1 IN  VARCHAR2,
                        champsMatArp2 IN  VARCHAR2,
                        champsIdenBip IN  VARCHAR2,
                        champsRefFac IN  VARCHAR2,
                        champsRefExp IN  VARCHAR2,
                        champsRacine IN  VARCHAR2,
                        champsAvenant IN  VARCHAR2,
                        req_centre_frais IN  VARCHAR2,
                        req_dpg_perim_me  IN  VARCHAR2,
                        isClone IN BOOLEAN) IS

cond1 VARCHAR2(100);
cdospas BOOLEAN;
cressource boolean;
condtion_ress1 varchar2(50);
condtion_ress2 varchar2(50);
condtion_ress3 varchar2(50);
condtion_fact1 varchar2(50);
cfacture boolean;

 BEGIN
 	cond1 := '';
  cdospas := false;


--Dossier pacDOS
		if (cas = 'contrat_rejet') then
			if (critereDosPac = 'E' and champsDosPac is not null) then
				requete := requete || cond1 || 'PRA_CONTRAT.NUM_CONTRAT = '''|| champsRacine ||''' ';
				cdospas := true;
			elsif (critereDosPac = 'P' and champsDosPac is not null) then
				requete := requete || cond1 || 'PRA_CONTRAT.NUM_CONTRAT like '''|| champsRacine ||'%'' ';
				cdospas := true;
			elsif (critereDosPac = 'C' and champsDosPac is not null) then
				requete := requete || cond1 || 'PRA_CONTRAT.NUM_CONTRAT like ''%'|| champsRacine ||'%'' ';
				cdospas := true;
      end if;


			if (critereDosPac = 'E' and champsDosPac is not null and champsAvenant is not null) then
				requete := requete || 'AND PRA_CONTRAT.cav = '''|| champsAvenant ||''' ';
			elsif (critereDosPac = 'P' and champsDosPac is not null and champsAvenant is not null) then
				requete := requete || 'AND PRA_CONTRAT.cav like '''|| champsAvenant ||'%'' ';
			elsif (critereDosPac = 'C' and champsDosPac is not null and champsAvenant is not null)	then
				requete := requete || 'AND PRA_CONTRAT.cav like ''%'|| champsAvenant ||'%'' ';
			end if;


      --Contrat
			 if (cdospas = false) then
				 if (critereRefCon ='E' and champsRacine is not null) then
					 requete := requete || cond1 || 'TRIM(PRA_CONTRAT.NUM_CONTRAT) = '''|| champsRacine ||''' ';
				 elsif (critereRefCon = 'P' and champsRacine is not null) then

					 requete := requete || cond1 || 'PRA_CONTRAT.NUM_CONTRAT like '''|| champsRacine ||'%'' ';
				 elsif (critereRefCon = 'C' and champsRacine is not null) then
					 requete := requete || cond1 || 'PRA_CONTRAT.NUM_CONTRAT like ''%'|| champsRacine ||'%'' ';
				 end if;


				 if (critereRefAve = 'E' and champsRefAve is not null) then
					 requete := requete || 'AND PRA_CONTRAT.cav = '''|| champsRefAve ||''' ';
				 elsif (critereRefAve = 'P' and champsRefAve is not null) then
					 requete := requete || 'AND PRA_CONTRAT.cav like '''|| champsRefAve ||'%'' ';
				 elsif (critereRefAve = 'C' and champsRefAve is not null) then
					 requete := requete || 'AND PRA_CONTRAT.cav like ''%'|| champsRefAve ||'%'' ';
			   end if;
			 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
				 requete := requete || ' PRA_CONTRAT.RETOUR LIKE ''DPG inconnu%'' ';
			 else
				 requete := requete || ' AND PRA_CONTRAT.RETOUR LIKE ''DPG inconnu%'' ';
       end if;
		end if;


    -- rejet de ressource
    elsif (cas = 'ressource_rejet') then


		 cressource := false ;
		 condtion_ress1 := 'AND ( ';


		 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
			 condtion_ress1 := '( ';
		 end if;
		 if (critereNom = 'E' and champsNom is not null) then
			 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
				 requete := requete ||'(PRA_RESSOURCE.NOM_RESSOURCE = '''||  champsNom ||''' ';
			 else
				 requete := requete ||'AND (PRA_RESSOURCE.NOM_RESSOURCE = '''||  champsNom ||''' ';
       end if;
			 condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereNom = 'P' and champsNom is not null) then
			 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
				 requete := requete ||'(PRA_RESSOURCE.NOM_RESSOURCE like '''||  champsNom ||'%'' ';
			 else
				 requete := requete ||'AND (PRA_RESSOURCE.NOM_RESSOURCE like '''||  champsNom ||'%'' ';
       end if;
			 condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereNom = 'C' and champsNom is not null) then
			 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
				 requete := requete ||'(PRA_RESSOURCE.NOM_RESSOURCE like ''%'|| champsNom ||'%'' ';
			 else
				 requete := requete ||'AND (PRA_RESSOURCE.NOM_RESSOURCE like ''%'|| champsNom ||'%'' ';
       end if;
			 condtion_ress1 := 'OR ';
			 cressource := true;
		 end if;

		 condtion_ress2 := 'AND ( ';
		 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
			 condtion_ress2 := '( ';
     end if;
		 if (critereIgg = 'E' and champsIgg1 is not null) then
			 if (champsIgg2 is null) then
				 requete := requete || condtion_ress1 || 'PRA_RESSOURCE.IGG_RESSOURCE = '''||  champsIgg1 ||''' ';
			 else
				 requete := requete || condtion_ress1 || 'PRA_RESSOURCE.IGG_RESSOURCE = '''||  champsIgg1 ||''' OR PRA_RESSOURCE.IGG_RESSOURCE = '''|| champsIgg2 ||''' ';
       end if;
			 condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereIgg = 'P' and champsIgg1 is not null) then
			 if (champsIgg2 is null) then
				 requete := requete || condtion_ress1 || 'PRA_RESSOURCE.IGG_RESSOURCE like '''||  champsIgg1 ||'%'' ';
			 else
      --PPM 1691 : 27/03/2015 (clone) --requete := requete || condtion_ress1 || 'PRA_RESSOURCE.IGG_RESSOURCE like '''||  champsIgg1 ||'%'' OR PRA_RESSOURCE.IGG_RESSOURCE like '''||  champsIgg2 ||'%'' ';
            if isClone = true then
                requete := requete || condtion_ress1 || 'substr(PRA_RESSOURCE.IGG_RESSOURCE,2) in ( select substr(IGG_RESSOURCE,2) from PRA_RESSOURCE  where IGG_RESSOURCE like '''||  champsIgg2 ||'%'' ) ';
            else
            requete := requete || condtion_ress1 || 'substr(PRA_RESSOURCE.IGG_RESSOURCE,2) in ( select substr(IGG_RESSOURCE,2) from PRA_RESSOURCE  where IGG_RESSOURCE like '''||  champsIgg1 ||'%'' ) ';
            end if;
			 end if;
       condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereIgg = 'C' and champsIgg1 is not null) then
			 if (champsIgg2 is null) then
				 requete := requete || condtion_ress1 || 'PRA_RESSOURCE.IGG_RESSOURCE like ''%'|| champsIgg1 ||'%'' ';
			 else
				 requete := requete || condtion_ress1 || 'PRA_RESSOURCE.IGG_RESSOURCE like ''%'|| champsIgg1 ||'%'' OR PRA_RESSOURCE.IGG_RESSOURCE like ''%'|| champsIgg2 ||'%'' ';
			 end if;
       condtion_ress1 := 'OR ';
			 cressource := true;
		 end if;


	condtion_ress3 := 'AND ( ';
		 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
			 condtion_ress3 := '( ';
     end if;
		 if (critereMatArp = 'E' and champsMatArp1 is not null) then
			 if (champsMatArp2 is null) then
				 requete := requete || condtion_ress1 || 'PRA_RESSOURCE.MATRICULE_RESSOURCE = '''||  champsMatArp1 ||''' ';
			 else
				 requete := requete || condtion_ress1 || 'PRA_RESSOURCE.MATRICULE_RESSOURCE = '''||  champsMatArp1 ||''' OR PRA_RESSOURCE.MATRICULE_RESSOURCE = '''|| champsMatArp2 ||''' ';
			 end if;
       condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereMatArp = 'P' and champsMatArp1 is not null) then
			 if (champsMatArp2 is null) then
				requete := requete || condtion_ress1 || 'PRA_RESSOURCE.MATRICULE_RESSOURCE like '''||  champsMatArp1 ||'%'' ';
			 else
--PPM 1691 : 27/03/2015 (clone) --requete := requete || condtion_ress1 || 'PRA_RESSOURCE.MATRICULE_RESSOURCE like '''||  champsMatArp1 ||'%'' OR PRA_RESSOURCE.MATRICULE_RESSOURCE like '''||  champsMatArp2 ||'%'' ';
            if isClone = true then
                requete := requete || condtion_ress1 || 'substr(PRA_RESSOURCE.MATRICULE_RESSOURCE,2) in ( select substr(MATRICULE_RESSOURCE,2) from PRA_RESSOURCE  where MATRICULE_RESSOURCE like '''||  champsMatArp2 ||'%'' ) ';
            else
                requete := requete || condtion_ress1 || 'substr(PRA_RESSOURCE.MATRICULE_RESSOURCE,2) in ( select substr(MATRICULE_RESSOURCE,2) from PRA_RESSOURCE  where MATRICULE_RESSOURCE like '''||  champsMatArp1 ||'%'' ) ';
            end if;
			 end if;
			 condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereMatArp = 'C' and champsMatArp1 is not null) then
			 if (champsMatArp2 is null) then
			 	requete := requete || condtion_ress1 || 'PRA_RESSOURCE.MATRICULE_RESSOURCE like ''%'|| champsMatArp1 ||'%'' ';
			 else
				 requete := requete || condtion_ress1 || 'PRA_RESSOURCE.MATRICULE_RESSOURCE like ''%'|| champsMatArp1 ||'%'' OR PRA_RESSOURCE.MATRICULE_RESSOURCE like ''%'|| champsMatArp2 ||'%'' ';
			 end if;
       condtion_ress1 := 'OR ';
			 cressource := true;
		 end if;
		 if (critereIdenBip = 'E' and champsIdenBip is not null) then
			 requete := requete || condtion_ress1 || 'PRA_RESSOURCE.IDENT_DO = '''||  champsIdenBip ||''' ';

			 cressource := true;
		 elsif (critereIdenBip = 'P' and champsIdenBip is not null) then
			 requete := requete || condtion_ress1 || 'PRA_RESSOURCE.IDENT_DO like '''||  champsIdenBip ||'%'' ';

			 cressource := true;
		 elsif (critereIdenBip = 'C' and champsIdenBip is not null) then
			 requete := requete || condtion_ress1 || 'PRA_RESSOURCE.IDENT_DO like ''%'|| champsIdenBip ||'%'' ';
			 cressource := true;
		 end if;

		 if (cressource = true) then
      requete := requete ||') ';
      end if;




      --partie contrat (rejet de ressource)
      if (critereDosPac = 'E' and champsDosPac is not null) then
				if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
					requete := requete || cond1 ||'contrat.numcont = '''||  champsRacine ||''' ';
				 else
          requete := requete || cond1 ||' AND contrat.numcont = '''||  champsRacine ||''' ';
         end if;
        cdospas := true;
			elsif (critereDosPac = 'P' and champsDosPac is not null) then
				if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
					requete := requete || cond1 ||'contrat.numcont like '''||  champsRacine ||'%'' ';
				else
          requete := requete || cond1 ||' AND contrat.numcont like '''||  champsRacine ||'%'' ';
        end if;
        cdospas := true;
			elsif (critereDosPac = 'C' and champsDosPac is not null) then
				if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
					requete := requete || cond1 ||'contrat.numcont like ''%'|| champsRacine ||'%'' ';
				else
					requete := requete || cond1 ||' AND contrat.numcont like ''%'|| champsRacine ||'%'' ';
        end if;
          cdospas := true;
			end if;


			if (critereDosPac = 'E' and champsDosPac is not null and champsAvenant is not null) then

				requete := requete ||'AND contrat.cav = '''||  champsAvenant ||''' ';
			elsif (critereDosPac = 'P' and champsDosPac is not null and champsAvenant is not null) then
				requete := requete ||'AND contrat.cav like '''||  champsAvenant ||'%'' ';
			elsif (critereDosPac = 'C' and champsDosPac is not null and champsAvenant is not null) then
				requete := requete ||'AND contrat.cav like ''%'|| champsAvenant ||'%'' ';
			end if;


-- Contrat
			 if (cdospas = false) then
				 if (critereRefCon = 'E' and champsRacine is not null) then
					 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
						 requete := requete || cond1 ||'contrat.numcont = '''||  champsRacine ||''' ';
					 else
						 requete := requete || cond1 ||' AND contrat.numcont = '''||  champsRacine ||''' ';
           end if;
				 elsif (critereRefCon = 'P' and champsRacine is not null) then
					 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
						 requete := requete || cond1 ||'contrat.numcont like '''||  champsRacine ||'%'' ';
					 else
						 requete := requete || cond1 ||' AND contrat.numcont like '''||  champsRacine ||'%'' ';
           end if;
				 elsif (critereRefCon = 'C' and champsRacine is not null) then
					 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
						 requete := requete || cond1 ||'contrat.numcont like ''%'|| champsRacine ||'%'' ';
					 else
						 requete := requete || cond1 ||' AND contrat.numcont like ''%'|| champsRacine ||'%'' ';
				   end if;
         end if;
				 if (critereRefAve = 'E' and champsRefAve is not null) then

					 requete := requete ||'AND contrat.cav = '''||  champsRefAve ||''' ';
				 elsif (critereRefAve = 'P' and champsRefAve is not null) then

					 requete := requete ||'AND contrat.cav like '''||  champsRefAve ||'%'' ';
				 elsif (critereRefAve = 'C' and champsRefAve is not null) then
					 requete := requete ||'AND contrat.cav like ''%'|| champsRefAve ||'%'' ';
         end if;
			 end if;


       -- fin partie contrat (rejet de ressource)
       --partie facture (rejet de ressource) :
       cfacture := false;
       condtion_fact1 := 'AND ( ';
					if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
						condtion_fact1 := '( ';
          end if;
					if (critereRefFac = 'E' and champsRefFac is not null) then
						if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
							requete := requete ||'(facture.numfact = '''||  champsRefFac ||''' ';
						else
							requete := requete ||'AND (facture.numfact = '''||  champsRefFac ||''' ';
            end if;
						condtion_fact1 := 'OR ';

						cfacture := true;
					elsif (critereRefFac = 'P' and champsRefFac is not null) then
						if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
							requete := requete ||'(facture.numfact like '''||  champsRefFac ||'%'' ';
						else
							requete := requete ||'AND (facture.numfact like '''||  champsRefFac ||'%'' ';
            end if;
						condtion_fact1 := 'OR ';

						cfacture := true;
					elsif (critereRefFac = 'C' and champsRefFac is not null) then
						if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
							requete := requete ||'(facture.numfact like ''%'|| champsRefFac ||'%'' ';
						else
							requete := requete ||'AND (facture.numfact like ''%'|| champsRefFac ||'%'' ';
            end if;
						condtion_fact1 := 'OR ';
						cfacture := true;
					end if;


					if (critereRefExp = 'E' and champsRefExp is not null) then
						requete := requete || condtion_fact1 || 'facture.num_expense = '''||  champsRefExp ||''' ';

						cfacture := true;
					elsif (critereRefExp = 'P' and champsRefExp is not null) then
						requete := requete || condtion_fact1 || 'facture.num_expense like '''||  champsRefExp ||'%'' ';

						cfacture := true;
					elsif (critereRefExp = 'C' and champsRefExp is not null) then
						requete := requete || condtion_fact1 ||'facture.num_expense like ''%'|| champsRefExp ||'%'' ';
						cfacture := true;
					end if;


        if (cfacture) then
          requete := requete ||') ';
        end if;
    goto end_req;
    --fin rejet de ressource
		elsif (cas = 'facture_rejet' ) then
			if (critereDosPac = 'E' and champsDosPac is not null ) then
				requete := requete || cond1 || 'TRIM(EBIS_FACT_REJET.NUMCONT) = '''|| champsRacine ||''' ';
				cdospas := true;
			elsif (critereDosPac = 'P' and champsDosPac is not null) then
				requete := requete || cond1 ||'EBIS_FACT_REJET.NUMCONT like '''||  champsRacine ||'%'' ';
				cdospas := true;
			elsif (critereDosPac = 'C' and champsDosPac is not null) then
				requete := requete || cond1 ||'EBIS_FACT_REJET.NUMCONT like ''%'|| champsRacine ||'%'' ';
				cdospas := true;
			end if;


			if (critereDosPac = 'E' and champsDosPac is not null and champsAvenant is not null) then
				requete := requete ||'AND EBIS_FACT_REJET.cav = '''||  champsAvenant ||''' ';
			elsif (critereDosPac = 'P' and champsDosPac is not null and champsAvenant is not null) then
				requete := requete ||'AND EBIS_FACT_REJET.cav like '''||  champsAvenant ||'%'' ';
			elsif (critereDosPac = 'C' and champsDosPac is not null and champsAvenant is not null) then
				requete := requete ||'AND EBIS_FACT_REJET.cav like ''%'|| champsAvenant ||'%'' ';
			end if;


	--Contrat
			 if (cdospas = false) then
				 if (critereRefCon = 'E' and champsRacine is not null) then
					 requete := requete || cond1 ||'TRIM(EBIS_FACT_REJET.NUMCONT) = '''||  champsRacine ||''' ';
				 elsif (critereRefCon = 'P' and champsRacine is not null) then
					 requete := requete || cond1 ||'EBIS_FACT_REJET.NUMCONT like '''||  champsRacine ||'%'' ';
				 elsif (critereRefCon = 'C' and champsRacine is not null) then
					 requete := requete || cond1 ||'EBIS_FACT_REJET.NUMCONT like ''%'|| champsRacine ||'%'' ';
				 end if;


				 if (critereRefAve = 'E' and champsRefAve is not null) then
				 	 requete := requete ||'AND EBIS_FACT_REJET.cav = '''||  champsRefAve ||''' ';
				 elsif (critereRefAve = 'P' and champsRefAve is not null) then
					 requete := requete ||'AND EBIS_FACT_REJET.cav like '''||  champsRefAve ||'%'' ';
				 elsif (critereRefAve = 'C' and champsRefAve is not null) then
					 requete := requete ||'AND EBIS_FACT_REJET.cav like ''%'|| champsRefAve ||'%'' ';
				 end if;
			end if;

      
      
		else
			if (critereDosPac = 'E' and champsDosPac is not null) then
				if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
					requete := requete || cond1 ||'contrat.numcont = '''||  champsRacine ||''' ';
				 else
          requete := requete || cond1 ||' AND contrat.numcont = '''||  champsRacine ||''' ';
         end if;
        cdospas := true;
			elsif (critereDosPac = 'P' and champsDosPac is not null) then
				if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
					requete := requete || cond1 ||'contrat.numcont like '''||  champsRacine ||'%'' ';
				else
          requete := requete || cond1 ||' AND contrat.numcont like '''||  champsRacine ||'%'' ';
        end if;
        cdospas := true;
			elsif (critereDosPac = 'C' and champsDosPac is not null) then
				if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
					requete := requete || cond1 ||'contrat.numcont like ''%'|| champsRacine ||'%'' ';
				else
					requete := requete || cond1 ||' AND contrat.numcont like ''%'|| champsRacine ||'%'' ';
        end if;
          cdospas := true;
			end if;


			if (critereDosPac = 'E' and champsDosPac is not null and champsAvenant is not null) then

				requete := requete ||'AND contrat.cav = '''||  champsAvenant ||''' ';
			elsif (critereDosPac = 'P' and champsDosPac is not null and champsAvenant is not null) then
				requete := requete ||'AND contrat.cav like '''||  champsAvenant ||'%'' ';
			elsif (critereDosPac = 'C' and champsDosPac is not null and champsAvenant is not null) then
				requete := requete ||'AND contrat.cav like ''%'|| champsAvenant ||'%'' ';
			end if;


-- Contrat
			 if (cdospas = false) then
				 if (critereRefCon = 'E' and champsRacine is not null) then
					 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
						 requete := requete || cond1 ||'contrat.numcont = '''||  champsRacine ||''' ';
					 else
						 requete := requete || cond1 ||' AND contrat.numcont = '''||  champsRacine ||''' ';
           end if;
				 elsif (critereRefCon = 'P' and champsRacine is not null) then
					 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
						 requete := requete || cond1 ||'contrat.numcont like '''||  champsRacine ||'%'' ';
					 else
						 requete := requete || cond1 ||' AND contrat.numcont like '''||  champsRacine ||'%'' ';
           end if;
				 elsif (critereRefCon = 'C' and champsRacine is not null) then
					 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
						 requete := requete || cond1 ||'contrat.numcont like ''%'|| champsRacine ||'%'' ';
					 else
						 requete := requete || cond1 ||' AND contrat.numcont like ''%'|| champsRacine ||'%'' ';
				   end if;
         end if;
				 if (critereRefAve = 'E' and champsRefAve is not null) then

					 requete := requete ||'AND contrat.cav = '''||  champsRefAve ||''' ';
				 elsif (critereRefAve = 'P' and champsRefAve is not null) then

					 requete := requete ||'AND contrat.cav like '''||  champsRefAve ||'%'' ';
				 elsif (critereRefAve = 'C' and champsRefAve is not null) then
					 requete := requete ||'AND contrat.cav like ''%'|| champsRefAve ||'%'' ';
         end if;
			 end if;
		end if;
-- Traitement Ressource
		 cressource := false ;
		 condtion_ress1 := 'AND ( ';


		 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
			 condtion_ress1 := '( ';
		 end if;
		 if (critereNom = 'E' and champsNom is not null) then
			 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
				 requete := requete ||'(ressource.rnom = '''||  champsNom ||''' ';
			 else
				 requete := requete ||'AND (ressource.rnom = '''||  champsNom ||''' ';
       end if;
			 condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereNom = 'P' and champsNom is not null) then
			 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
				 requete := requete ||'(ressource.rnom like '''||  champsNom ||'%'' ';
			 else
				 requete := requete ||'AND (ressource.rnom like '''||  champsNom ||'%'' ';
       end if;
			 condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereNom = 'C' and champsNom is not null) then
			 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
				 requete := requete ||'(ressource.rnom like ''%'|| champsNom ||'%'' ';
			 else
				 requete := requete ||'AND (ressource.rnom like ''%'|| champsNom ||'%'' ';
       end if;
			 condtion_ress1 := 'OR ';
			 cressource := true;
		 end if;

		 condtion_ress2 := 'AND ( ';
		 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
			 condtion_ress2 := '( ';
     end if;
		 if (critereIgg = 'E' and champsIgg1 is not null) then
			 if (champsIgg2 is null) then
				 requete := requete || condtion_ress1 || 'ressource.igg = '''||  champsIgg1 ||''' ';
			 else
				 requete := requete || condtion_ress1 || 'ressource.igg = '''||  champsIgg1 ||''' OR ressource.igg = '''|| champsIgg2 ||''' ';
       end if;
			 condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereIgg = 'P' and champsIgg1 is not null) then
			 if (champsIgg2 is null) then
				 requete := requete || condtion_ress1 || 'ressource.igg like '''||  champsIgg1 ||'%'' ';
			 else
--PPM 1691 : 27/03/2015 (clone) --requete := requete || condtion_ress1 || 'ressource.igg like '''||  champsIgg1 ||'%'' OR ressource.igg like '''||  champsIgg2 ||'%'' ';
           if isClone = true then
                requete := requete || condtion_ress1 || 'substr(ressource.igg,2) in ( select substr(igg,2) from ressource  where igg like '''||  champsIgg2 ||'%'' ) ';
            else
                requete := requete || condtion_ress1 || 'substr(ressource.igg,2) in ( select substr(igg,2) from ressource  where igg like '''||  champsIgg1 ||'%'' ) ';
            end if;
			 end if;
       condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereIgg = 'C' and champsIgg1 is not null) then
			 if (champsIgg2 is null) then
				 requete := requete || condtion_ress1 || 'ressource.igg like ''%'|| champsIgg1 ||'%'' ';
			 else
				 requete := requete || condtion_ress1 || 'ressource.igg like ''%'|| champsIgg1 ||'%'' OR ressource.igg like ''%'|| champsIgg2 ||'%'' ';
			 end if;
       condtion_ress1 := 'OR ';
			 cressource := true;
		 end if;


	condtion_ress3 := 'AND ( ';
		 if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
			 condtion_ress3 := '( ';
     end if;
		 if (critereMatArp = 'E' and champsMatArp1 is not null) then
			 if (champsMatArp2 is null) then
				 requete := requete || condtion_ress1 || 'ressource.matricule = '''||  champsMatArp1 ||''' ';
			 else
				 requete := requete || condtion_ress1 || 'ressource.matricule = '''||  champsMatArp1 ||''' OR ressource.matricule = '''|| champsMatArp2 ||''' ';
			 end if;
       condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereMatArp = 'P' and champsMatArp1 is not null) then
			 if (champsMatArp2 is null) then
				requete := requete || condtion_ress1 || 'ressource.matricule like '''||  champsMatArp1 ||'%'' ';
			 else
--PPM 1691 : 27/03/2015 (clone) --requete := requete || condtion_ress1 || 'ressource.matricule like '''||  champsMatArp1 ||'%'' OR ressource.matricule like '''||  champsMatArp2 ||'%'' ';
            if isClone = true then
                requete := requete || condtion_ress1 || 'substr(ressource.matricule,2) in ( select substr(matricule,2) from ressource  where matricule like '''||  champsMatArp2 ||'%'' ) ';
            else
                requete := requete || condtion_ress1 || 'substr(ressource.matricule,2) in ( select substr(matricule,2) from ressource  where matricule like '''||  champsMatArp1 ||'%'' ) ';
            end if;
			 end if;
			 condtion_ress1 := 'OR ';

			 cressource := true;
		 elsif (critereMatArp = 'C' and champsMatArp1 is not null) then
			 if (champsMatArp2 is null) then
			 	requete := requete || condtion_ress1 || 'ressource.matricule like ''%'|| champsMatArp1 ||'%'' ';
			 else
				 requete := requete || condtion_ress1 || 'ressource.matricule like ''%'|| champsMatArp1 ||'%'' OR ressource.matricule like ''%'|| champsMatArp2 ||'%'' ';
			 end if;
       condtion_ress1 := 'OR ';
			 cressource := true;
		 end if;
		 if (critereIdenBip = 'E' and champsIdenBip is not null) then
			 requete := requete || condtion_ress1 || 'ressource.ident = '''||  champsIdenBip ||''' ';

			 cressource := true;
		 elsif (critereIdenBip = 'P' and champsIdenBip is not null) then
			 requete := requete || condtion_ress1 || 'ressource.ident like '''||  champsIdenBip ||'%'' ';

			 cressource := true;
		 elsif (critereIdenBip = 'C' and champsIdenBip is not null) then
			 requete := requete || condtion_ress1 || 'ressource.ident like ''%'|| champsIdenBip ||'%'' ';
			 cressource := true;
		 end if;

		 if (cressource = true) then
      requete := requete ||') ';
      end if;


-- Traitement  Facture
        cfacture := false;
				if (cas = 'facture_rejet' or cas = 'ressource_fact_rej' or  cas = 'contrat_fact_rej' ) then
					condtion_fact1 := 'AND ( ';
					if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
						condtion_fact1 := '( ';
          end if;
					if (critereRefFac = 'E' and champsRefFac is not null) then
						if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
							requete := requete ||'(EBIS_FACT_REJET.numfact = '''||  champsRefFac ||''' ';
						else
							requete := requete ||'AND (EBIS_FACT_REJET.numfact = '''||  champsRefFac ||''' ';
            end if;
						condtion_fact1 := 'OR ';
						cfacture := true;
					elsif (critereRefFac = 'P' and champsRefFac is not null) then
						if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
							requete := requete ||'(EBIS_FACT_REJET.numfact like '''||  champsRefFac ||'%'' ';
						else
							requete := requete ||'AND (EBIS_FACT_REJET.numfact like '''||  champsRefFac ||'%'' ';
            end if;
						condtion_fact1 := 'OR ';

						cfacture := true;
					elsif (critereRefFac = 'C' and champsRefFac is not null) then
						if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
							requete := requete ||'(EBIS_FACT_REJET.numfact like ''%'|| champsRefFac ||'%'' ';
						else
							requete := requete ||'AND (EBIS_FACT_REJET.numfact like ''%'|| champsRefFac ||'%'' ';
            end if;
						condtion_fact1 := 'OR ';
						cfacture := true;
					end if;


					if (critereRefExp = 'E' and champsRefExp is not null) then
						requete := requete || condtion_fact1 || 'EBIS_FACT_REJET.num_expense = '''||  champsRefExp ||''' ';

						cfacture := true;
					elsif (critereRefExp = 'P' and champsRefExp is not null) then
						requete := requete || condtion_fact1 || 'EBIS_FACT_REJET.num_expense like '''||  champsRefExp ||'%'' ';

						cfacture := true;
					elsif (critereRefExp = 'C' and champsRefExp is not null) then
						requete := requete || condtion_fact1 ||'EBIS_FACT_REJET.num_expense like ''%'|| champsRefExp ||'%'' ';
						cfacture := true;


					end if;
				else
					condtion_fact1 := 'AND ( ';
					if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
						condtion_fact1 := '( ';
          end if;
					if (critereRefFac = 'E' and champsRefFac is not null) then
						if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
							requete := requete ||'(facture.numfact = '''||  champsRefFac ||''' ';
						else
							requete := requete ||'AND (facture.numfact = '''||  champsRefFac ||''' ';
            end if;
						condtion_fact1 := 'OR ';

						cfacture := true;
					elsif (critereRefFac = 'P' and champsRefFac is not null) then
						if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
							requete := requete ||'(facture.numfact like '''||  champsRefFac ||'%'' ';
						else
							requete := requete ||'AND (facture.numfact like '''||  champsRefFac ||'%'' ';
            end if;
						condtion_fact1 := 'OR ';

						cfacture := true;
					elsif (critereRefFac = 'C' and champsRefFac is not null) then
						if (SUBSTR(requete, length(requete)-5) = 'WHERE ') then
							requete := requete ||'(facture.numfact like ''%'|| champsRefFac ||'%'' ';
						else
							requete := requete ||'AND (facture.numfact like ''%'|| champsRefFac ||'%'' ';
            end if;
						condtion_fact1 := 'OR ';
						cfacture := true;
					end if;


					if (critereRefExp = 'E' and champsRefExp is not null) then
						requete := requete || condtion_fact1 || 'facture.num_expense = '''||  champsRefExp ||''' ';

						cfacture := true;
					elsif (critereRefExp = 'P' and champsRefExp is not null) then
						requete := requete || condtion_fact1 || 'facture.num_expense like '''||  champsRefExp ||'%'' ';

						cfacture := true;
					elsif (critereRefExp = 'C' and champsRefExp is not null) then
						requete := requete || condtion_fact1 ||'facture.num_expense like ''%'|| champsRefExp ||'%'' ';
						cfacture := true;
					end if;
				end if;


				if (cfacture) then
          requete := requete ||') ';
        end if;


    CASE
            --1692 (et 1688)
   WHEN cas = 'contrat' THEN
          IF NVL(req_centre_frais,'^') <> '^' THEN
            requete := requete || ' AND contrat.CCENTREFRAIS in ' || req_centre_frais;
          END IF;
          IF NVL(req_dpg_perim_me,'^') <> '^' THEN
            requete := requete || ' AND contrat.codsg in ' || req_dpg_perim_me;
          END IF;
    WHEN cas = 'contrat_rejet' THEN    
          requete := requete || ' AND PRA_CONTRAT.CODE_RETOUR = 0 ';--PPM 62077 : déplacer le code_retour=0 après le where
          IF NVL(req_centre_frais,'^') <> '^' THEN
            requete := requete || ' AND ( contrat.CCENTREFRAIS in ' || req_centre_frais || ' OR PRA_CONTRAT.NUM_CONTRAT not in (select numcont from contrat)) ';
          END IF;
          IF NVL(req_dpg_perim_me,'^') <> '^' THEN
            requete := requete || ' AND ( contrat.codsg in ' || req_dpg_perim_me || ' OR PRA_CONTRAT.NUM_CONTRAT not in (select numcont from contrat)) ';
          END IF;
    WHEN cas = 'ressource' THEN
          IF NVL(req_centre_frais,'^') <> '^' THEN
            requete := requete || ' AND struct_info.SCENTREFRAIS in ' || req_centre_frais;--habilitation perim_me déjà faite dans la requête principale
          END IF;
    WHEN cas = 'ressource_rejet' THEN
          requete := requete ;--habilitation déjà faite dans la requête principale
    WHEN cas = 'facture' THEN
          IF NVL(req_centre_frais,'^') <> '^' THEN
            requete := requete || ' AND facture.FCENTREFRAIS in ' || req_centre_frais;--habilitation perim_me déjà faite dans la requête principale
          END IF;
    WHEN cas = 'facture_rejet' THEN
					requete := requete ||' AND EBIS_FACT_REJET.CODE_RETOUR = 7 AND EBIS_FACT_REJET.TOP_ETAT = ''AT'' ';--PPM 62077 : déplacer le code_retour=7 après le where

          IF NVL(req_centre_frais,'^') <> '^' THEN
            requete := requete || ' AND ( facture.FCENTREFRAIS in ' || req_centre_frais || ' OR contrat.CCENTREFRAIS in ' || req_centre_frais || ' OR EBIS_FACT_REJET.NUMCONT not in (select numcont from contrat)) '; --PPM 1698 : ajout de CF du contrat

          END IF;
          IF NVL(req_dpg_perim_me,'^') <> '^' THEN
            requete := requete || ' AND ( facture.FDEPPOLE in ' || req_dpg_perim_me || ' OR contrat.codsg in ' || req_dpg_perim_me || ' OR EBIS_FACT_REJET.NUMCONT not in (select numcont from contrat)) ';--PPM 1698 : ajout de codsg du contrat
          END IF;
    WHEN cas = 'ressource_fact_rej' or cas = 'contrat_fact_rej' THEN
					requete := requete ||' AND EBIS_FACT_REJET.TOP_ETAT = ''AT'' ';

          IF NVL(req_centre_frais,'^') <> '^' THEN
            requete := requete || ' AND ( facture.FCENTREFRAIS in ' || req_centre_frais || ' OR EBIS_FACT_REJET.NUMCONT not in (select numcont from contrat)) ';

          END IF;
          IF NVL(req_dpg_perim_me,'^') <> '^' THEN
            requete := requete || ' AND ( facture.FDEPPOLE in ' || req_dpg_perim_me || ' OR EBIS_FACT_REJET.NUMCONT not in (select numcont from contrat)) ';
          END IF;
    END CASE;
			--	return requete;
	 <<end_req>>
   null;




--RETURN requete;
END calculRequete;


PROCEDURE select_contratrf(
                 P_param6     IN  VARCHAR2,          	-- NUMBER(9)
                 p_message   OUT VARCHAR2
                 ) IS
       l_msg   VARCHAR2(1024);
       param6 VARCHAR2(10);
   BEGIN
      l_msg := '';
      BEGIN
            SELECT P_param6 INTO param6 FROM DUAL ;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            --pack_global.recuperer_message(4000, '%s1', l_msg);
             raise_application_error( -20998, l_msg);
         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;
      p_message := l_msg;
END select_contratrf;



END Pack_Contrat;
/