-- pack_cout_standard_ke
--
-- EQUIPE BIP 
-- 
--
-- Modifié le 
--     31/10/2007           JAL : inclusion Etat par client et sous traitance
--     06/11/2007           JAL : inclusion Edition table couts standards en KE
--     09/11/2007           JAL : inclusion Règles gestion anomalies
--     14/11/2007            JAL : dernière version avec màj corrigée
--     19/11/2007            JAL : modification gestion des anomalies
--     23/11/2007            JAL : modification Etat par client avec sous traitance en KE
 --    27/11/2007            JAL : modificationprocédure création anomalie suite à rajout code branche
 --   13/12/2007             JAL : supression odre delete inutile dans création Etat de la table couts standards en KE
 --   19/12/2007            JAL : modification formule calcul réestimé selon nouvelles specs
  --  06/02/2008          JAL : Fiche 612->rajout procédure pour couts financier sur ME->Etat Export sur PC- suivi financier
-- 10/04/2008		EVI: Correction beug ligne non ramene car pas de budget
-- 23/04/2008		JAL: fiche 616 : rajout colonne Fournisseur COPI dans Etats couts KE
-- 02/05/2008		JAL: fiche 616 : rajout méthodes pour Etats COPI Synthèse
-- 08/05/2008		JAL: fiche 616 : rajout méthodes et modifications en cours
-- 16/05/2008		JAL: fiche 616 : rajout méthodes et modifications en cours
-- 23/05/2008		EVI: fiche 616 : correction: la variable "l_libelle_fournisseur" est de longueur 50
-- 28/05/2008		JAL: fiche 616 intégration corrections Antoine sur calculs COPI
-- 28/05/2008		JAL: fiche 616 intégration correction recherche code four COPI 
-- 29/05/2008		JAL: fiche 616 Correction : on ne ramène que les DPCOPI avec client_mo BDDF
-- 02/05/2008           JAL : ficher 616 Correction affichage libellé et consomme depus table CONSOMME
-- 09/06/2008           JAL : ficher 616 Remplacement Left Outer Join par Join simple (PROD pas encore en Oracle10)
-- 19/06/2008           JAL : ficher 596 Rajout de Logs coutKE
-- 24/06/2008           JAL : ficher 596 maj dernière version Logs coutKE
-- 01/08/2008           JAL : fiche 596 on logue chaque cout lorsque on supprime ainsi que fournisseur COPI
-- 05/08/2008           JAL : fiche 616 : Left Outer Join marche pas comme on veut : remplacement par des UNION simples.
-- 09/09/2008           ABA : modification procedure recherche_pourcentage 
-- 26/01/2008           ABA : TD  742 
-- 30/01/2008           ABA : Modification de la procedure qui ramène le code fournisseur copi par défaut
-- 24/02/2009           ABA : TD 729
--  12/08/2009         ABA TD 799
--  23/09/2009         ABA TD 799  modification de l'export budget pour prendre en compte les catégorie L M A dans les champs EU et non JH
--  30/10/2009         ABA TD 884
--  13/12/2010          ABA TD 959
-- 18/07/2011         CMA TD 1233 Lorsque on fait la synthese realise copi, on prend en compte les codes clients différents de BDDF
-- 09/09/2011         ABA QC 1262
-- 28/11/2011          BSA 1281
-- 16/04/2012         BSA 1420 ajout filtre sur le menu
-- 30/03/2012       OEL 1378
-- 25/06/2012       ABA 1378 : remplacement des UNION par UNION ALL
-- 26/09/2012       BSA 1450 : Optimisation INSERT_TMPCOPI_SYNTH_REALISE
-- 07/01/2013       ABA 1450 : Correction sur la profondeur des données
CREATE OR REPLACE PACKAGE "BIP"."PACK_COUT_STANDARD_KE" AS



TYPE cout_Type IS RECORD (annee VARCHAR2(4),
                         dpg_bas VARCHAR2(7),
                         dpg_haut VARCHAR2(7),
                         me_type1 VARCHAR2(25),
                         mo_type1 VARCHAR2(25),
                         hom_type1 VARCHAR2(25),
                         gap_type1 VARCHAR2(25),
                         EXP_type1 VARCHAR2(25),
                         sau_type1 VARCHAR2(25),
                         me_type2 VARCHAR2(25),
                         mo_type2 VARCHAR2(25),
                         hom_type2 VARCHAR2(25),
                         gap_type2 VARCHAR2(25),
                         EXP_type2 VARCHAR2(25),
                         sau_type2 VARCHAR2(25),
                         p_fourCopi VARCHAR2(2),
                         FLAGLOCK   COUT_STD_SG.flaglock%TYPE
                  );
TYPE coutCurType IS REF CURSOR RETURN cout_Type;



TYPE tmp_coutke_etats_type IS RECORD (
                                  pid VARCHAR2(4),
                          codsg NUMBER(7),
                          annee NUMBER(4),
                          annee_budg1 NUMBER(4),
                          METIER VARCHAR2(3),
                          cout NUMBER(12,2),
                          cout_budg1 NUMBER(12,2) ,
                          reestime NUMBER(12,2) ,
                          CONSOMME NUMBER(12,2) ,
                          reste_afaire  NUMBER(12,2),
                          consojh NUMBER(12,2),
                          reestimejh NUMBER(12,2)
                  );
TYPE tmp_coutke_CurType IS REF CURSOR RETURN tmp_coutke_etats_type;




TYPE dpg_std_type IS RECORD(
                     pcle        VARCHAR2(20),
                     pcoutstd    VARCHAR2(200)
                      );

     TYPE dpg_stdCurType IS REF CURSOR RETURN dpg_std_type;


TYPE cout_sg_Type IS RECORD (     annee VARCHAR2(4),
                    dpg_bas VARCHAR2(7),
                    dpg_haut VARCHAR2(7),
                    me VARCHAR2(7),
                     mo VARCHAR2(7),
                     hom VARCHAR2(7),
                     gap VARCHAR2(7),
                    NIVEAU VARCHAR2(2),
                     longueur NUMBER(1),
                                    FLAGLOCK   COUT_STD_SG.flaglock%TYPE
                  );

      TYPE coutSgCurType IS REF CURSOR RETURN cout_sg_Type;

PROCEDURE insert_cout_standard_KE(
        p_couann        IN  VARCHAR2,
        p_codsg_bas     IN  VARCHAR2,
        p_codsg_haut    IN  VARCHAR2,
        p_coutME_type1         IN  VARCHAR2,
        p_coutMO_type1         IN  VARCHAR2,
        p_coutHOM_type1         IN  VARCHAR2,
        p_coutGAP_type1         IN  VARCHAR2,
        p_coutEXP_type1         IN  VARCHAR2,
        p_coutSAU_type1         IN  VARCHAR2,
        p_coutME_type2         IN  VARCHAR2,
        p_coutMO_type2         IN  VARCHAR2,
        p_coutHOM_type2         IN  VARCHAR2,
        p_coutGAP_type2         IN  VARCHAR2,
        p_coutEXP_type2         IN  VARCHAR2,
        p_coutSAU_type2         IN  VARCHAR2,
                p_fourCopi      IN  VARCHAR2,
        p_userid        IN  VARCHAR2,
          p_nbcurseur     OUT INTEGER,
                       p_message       OUT VARCHAR2
);


PROCEDURE UPDATE_COUT_STANDARD_KE (p_couann        IN  VARCHAR2,
                                   p_codsg_bas     IN  VARCHAR2,
                                   p_codsg_bas_new IN  VARCHAR2,
                                   p_codsg_haut      IN  VARCHAR2,
                                   p_codsg_haut_new IN  VARCHAR2,
                                   p_coutME_type1         IN  VARCHAR2,
                                   p_coutMO_type1         IN  VARCHAR2,
                                   p_coutHOM_type1         IN  VARCHAR2,
                                   p_coutGAP_type1         IN  VARCHAR2,
                                   p_coutEXP_type1         IN  VARCHAR2,
                                   p_coutSAU_type1         IN  VARCHAR2,
                                   p_coutME_type2         IN  VARCHAR2,
                                   p_coutMO_type2         IN  VARCHAR2,
                                   p_coutHOM_type2         IN  VARCHAR2,
                                   p_coutGAP_type2         IN  VARCHAR2,
                                   p_coutEXP_type2         IN  VARCHAR2,
                                   p_coutSAU_type2         IN  VARCHAR2,
                                   p_fourCopi      IN  VARCHAR2,
                                   userid        IN  VARCHAR2,
                                   p_nbcurseur        OUT INTEGER,
                                   p_message          OUT VARCHAR2
                                   );

FUNCTION insert_tmp_coutke_etats(
                                    annee               IN NUMBER ,
                                    p_param6            IN  VARCHAR2 ,
                                    etat_sous_traitance IN VARCHAR2,
                                    ecran_isac          IN VARCHAR2 ,
                                    CODE_CHEF_PROJET    IN VARCHAR2,
                                    matricule           IN VARCHAR2 ,
                                    p_global            IN VARCHAR2,
-- FAD PPM 63956 : Ajout du P_PERIME pour faciliter le traitement niveau export
									P_PERIME            IN VARCHAR2
-- FAD PPM 63956 : Fin
                                   -- libelle_branche     IN VARCHAR2 ,
                                   -- code_branche        IN VARCHAR2
)RETURN NUMBER;

-- FAD QC 1853 : Duplication de la fonction insert_tmp_coutke_etats en remplaçant les ROUND(VAL, 0) par ROUND(VAL, 2)
FUNCTION insert_tmp_coutke_dmdlbip(
                                    annee               IN NUMBER ,
                                    p_param6            IN  VARCHAR2 ,
                                    etat_sous_traitance IN VARCHAR2,
                                    ecran_isac          IN VARCHAR2 ,
                                    CODE_CHEF_PROJET    IN VARCHAR2,
                                    matricule           IN VARCHAR2 ,
                                    p_global            IN VARCHAR2,
-- FAD PPM 63956 : Ajout du P_PERIME pour faciliter le traitement niveau export
									P_PERIME            IN VARCHAR2
-- FAD PPM 63956 : Fin

                                   -- libelle_branche     IN VARCHAR2 ,
                                   -- code_branche        IN VARCHAR2
)RETURN NUMBER;

FUNCTION insert_tmp_edition_etatke(
        p_couann        IN  VARCHAR2
        )  RETURN NUMBER ;


FUNCTION liste_anomalies(
                                    p_couann        IN  VARCHAR2
                                     ) RETURN NUMBER ;


PROCEDURE delete_cout_standard_ke (p_couann    IN  VARCHAR2,
                p_codsg_bas IN  VARCHAR2,
                               p_flaglock  IN  NUMBER,
                            p_userid    IN  VARCHAR2,
                               p_nbcurseur OUT INTEGER,
                               p_message   OUT VARCHAR2
                      );

PROCEDURE select_cout_standard_ke ( p_couann    IN VARCHAR2,
                                       p_codsg_bas IN VARCHAR2,
                                       p_userid    IN VARCHAR2,
                                       p_curcout   IN OUT coutCurType,
                                       p_nbcurseur OUT INTEGER,
                                       p_message   OUT VARCHAR2
                      );


PROCEDURE controle_cout_standard_ke (    p_couann    IN VARCHAR2,
                                         p_userid    IN VARCHAR2,
                                          p_message   OUT VARCHAR2
                      );


PROCEDURE lister_coutstandard_ke (    p_anneestd    IN VARCHAR2,
                                     p_userid      IN VARCHAR2,
                                    p_curdpg_std  IN OUT dpg_stdCurType
                 );







FUNCTION get_coutstandard_ke (p_anneestd IN VARCHAR2,
                           p_dpg_bas  IN VARCHAR2,
                           p_dpg_haut  IN VARCHAR2,
                           p_metier   IN VARCHAR2,
                           p_TYPE_LIGNE IN VARCHAR2)
                           RETURN VARCHAR2;


FUNCTION  update_coutKE_parmetier (p_anneestd IN NUMBER,
                           p_dpg_bas  IN NUMBER,
                           p_dpg_bas_old  IN NUMBER,
                           p_dpg_haut  IN NUMBER,
                           p_dpg_haut_old  IN NUMBER,
                           p_metier   IN VARCHAR2,
                           p_cout IN NUMBER,
                           p_fourCopi  IN  VARCHAR2 ,
                           p_time_stamp IN VARCHAR2,
                           p_userid IN VARCHAR2,
                           p_type_ligne IN VARCHAR2) RETURN VARCHAR2 ;

FUNCTION creer_anomalie_coutstdKE(p_annee  IN NUMBER,
                                    p_dpg IN NUMBER,
                                    p_metier IN VARCHAR2,
                                    p_pid IN VARCHAR2,
                                    p_libelle_erreur IN VARCHAR2,
                                    p_matricule IN VARCHAR2,
                                    p_code_branche IN VARCHAR2 ,
                                    p_libelle_branche IN VARCHAR2 ,
                                    p_timestamep IN DATE ,
                                    p_type_ligne_bip VARCHAR2) RETURN NUMBER ;

FUNCTION INSERT_ETAT_SUIVI_FINANCIER_KE(
        annee IN NUMBER ,
        p_param6     IN  VARCHAR2 ,
        etat_sous_traitance IN VARCHAR2,
        ecran_isac IN VARCHAR2 ,
        CODE_CHEF_PROJET  IN VARCHAR2,
        matricule IN VARCHAR2 ,
        libelle_branche IN VARCHAR2 ,
        code_branche IN VARCHAR2
)RETURN NUMBER;



   TYPE SynthActMoisType IS RECORD (
        PID SYNTHESE_ACTIVITE_MOIS.PID%TYPE,
              CDEB  SYNTHESE_ACTIVITE_MOIS.CDEB%TYPE,
              TYPPROJ SYNTHESE_ACTIVITE_MOIS.TYPPROJ%TYPE,
              METIER   SYNTHESE_ACTIVITE_MOIS.METIER%TYPE,
              PNOM   SYNTHESE_ACTIVITE_MOIS.PNOM%TYPE,
              CODSG    SYNTHESE_ACTIVITE_MOIS.CODSG%TYPE,
              DPCODE   SYNTHESE_ACTIVITE_MOIS.DPCODE%TYPE,
              ICPI    SYNTHESE_ACTIVITE_MOIS.ICPI%TYPE,
              CODCAMO   SYNTHESE_ACTIVITE_MOIS.CODCAMO%TYPE,
              CONSOJH_SG  SYNTHESE_ACTIVITE_MOIS.CONSOJH_SG%TYPE,
              CONSOJH_SSII SYNTHESE_ACTIVITE_MOIS.CONSOJH_SSII%TYPE,
              CONSOFT_SG    SYNTHESE_ACTIVITE_MOIS.CONSOFT_SG%TYPE,
              CONSOFT_SSII  SYNTHESE_ACTIVITE_MOIS.CONSOFT_SSII%TYPE,
              CONSOENV_SG  SYNTHESE_ACTIVITE_MOIS.CONSOENV_SG%TYPE,
              CONSOENV_SSII SYNTHESE_ACTIVITE_MOIS.CONSOENV_SSII%TYPE
              ) ;

   TYPE SynthMoisCurType IS REF CURSOR RETURN SynthActMoisType;



TYPE metier_ViewType IS RECORD( id     cout_std_ke.metier%TYPE,
                    libelle   cout_std_ke.metier%TYPE ) ;


TYPE metierCurType IS REF CURSOR RETURN metier_ViewType;


PROCEDURE lister_metier_coutske ( p_userid  IN VARCHAR2,
                                  p_curseur IN OUT metierCurType
                                ) ;
FUNCTION budget_en_exception (p_dpcode IN VARCHAR2,p_clicode IN VARCHAR2) RETURN NUMBER ;


FUNCTION projet_en_exception(p_icpi IN VARCHAR2) RETURN NUMBER ;


FUNCTION ligneBip_en_exception(p_airt IN VARCHAR2,p_codpspe IN VARCHAR2,p_codsg IN NUMBER) RETURN NUMBER ;


FUNCTION recherche_simple_coutKE(p_annee IN NUMBER,p_metier IN VARCHAR2,p_code_fournisseur IN NUMBER, p_type_ligne_bip IN VARCHAR2) RETURN NUMBER ;



FUNCTION INSERT_TMP_COPI_SYNTHESE(
                p_dpcopi IN VARCHAR2 ,
                p_annee  IN VARCHAR2  ,
                p_clicode IN VARCHAR2,
                p_type_etat IN NUMBER)   RETURN NUMBER ;

FUNCTION INSERT_TMPCOPI_SYNTH_REALISE(
                p_dpcopi IN VARCHAR2 ,
                p_annee IN VARCHAR2 ,
                p_clicode IN VARCHAR2 ,
                p_dpcode IN NUMBER)  RETURN NUMBER ;


FUNCTION INSERT_TMPCOPI_SYNTH_BUDGET(
                p_dpcopi IN VARCHAR2 ,
                p_annee IN VARCHAR2 ,
                p_clicode IN VARCHAR2   )  RETURN NUMBER ;



PROCEDURE recherche_simple2_coutKE(p_annee IN VARCHAR2,p_metier IN VARCHAR2,p_code_fournisseur IN VARCHAR2,
                                    p_message  OUT VARCHAR2 ,
                                    p_cout_ke  OUT VARCHAR2)  ;




FUNCTION recherche_code_fournisseur(p_codsg IN NUMBER, p_metier IN VARCHAR2, p_annee IN NUMBER) RETURN NUMBER ;


FUNCTION recherche_pourcentage(p_datdebex IN DATE,  p_annee IN NUMBER  ) RETURN NUMBER ;



FUNCTION recherche_reestime_euro(l_jh_reestime IN NUMBER,l_cout_ke IN NUMBER ,l_consomme_jh IN NUMBER ,
                                 l_cout_consomme IN NUMBER , l_cout_consomme_nonarrondi IN NUMBER   ) RETURN NUMBER ;



PROCEDURE log_coutKE(p_couann IN NUMBER,p_codsg_haut  IN NUMBER ,p_codsg_bas IN NUMBER ,l_metier IN VARCHAR2  ,
                     l_time_stamp IN DATE , p_userid IN VARCHAR2 , p_nom_table IN VARCHAR2  ,
                     p_nom_colonne IN VARCHAR2 , p_val_prec IN VARCHAR2 , p_val_new IN VARCHAR2 ,type_action IN NUMBER ,
                     p_commentaire IN VARCHAR2,type_ligne in VARCHAR2  )  ;

END Pack_Cout_Standard_Ke;

/



  CREATE OR REPLACE PACKAGE BODY "BIP"."PACK_COUT_STANDARD_KE" AS



TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
/************************************************************************************/
/*                                                                                  */
/*       Liste les couts standard KE                                                */
/*                                                                                  */
/************************************************************************************/
PROCEDURE lister_coutstandard_ke     (p_anneestd        IN VARCHAR2,
                 p_userid       IN VARCHAR2,
                              p_curdpg_std   IN OUT dpg_stdCurType
                 ) IS

BEGIN
OPEN p_curdpg_std FOR
    SELECT  DISTINCT   (TO_CHAR(dpg_bas, 'FM0000000') ||'-'|| TO_CHAR(dpg_haut, 'FM0000000'))   AS pcle,
                 (
                  '   ' || TO_CHAR(NVL(dpg_bas,0),'FM0000000') ||
                  '               ' || RPAD(TO_CHAR(NVL(dpg_haut,0),'FM0000000'),9,' ')
                 ) AS pcoutstd
        FROM COUT_STD_KE
        WHERE annee = TO_NUMBER(p_anneestd)
        ORDER BY 2 ASC
        ;
END lister_coutstandard_ke ;


/************************************************************************************/
/*                                                                                  */
/*       CREATION des couts standard KE                                             */
/*                                                                                  */
/************************************************************************************/
PROCEDURE insert_cout_standard_ke(
        p_couann        IN  VARCHAR2,
        p_codsg_bas     IN  VARCHAR2,
        p_codsg_haut    IN  VARCHAR2,
        p_coutME_type1         IN  VARCHAR2,
        p_coutMO_type1         IN  VARCHAR2,
        p_coutHOM_type1         IN  VARCHAR2,
        p_coutGAP_type1         IN  VARCHAR2,
        p_coutEXP_type1         IN  VARCHAR2,
        p_coutSAU_type1         IN  VARCHAR2,
        p_coutME_type2         IN  VARCHAR2,
        p_coutMO_type2         IN  VARCHAR2,
        p_coutHOM_type2         IN  VARCHAR2,
        p_coutGAP_type2         IN  VARCHAR2,
        p_coutEXP_type2         IN  VARCHAR2,
        p_coutSAU_type2         IN  VARCHAR2,
        p_fourCopi      IN  VARCHAR2,
        p_userid          IN  VARCHAR2,
        p_nbcurseur        OUT INTEGER,
        p_message          OUT VARCHAR2)  IS



    l_msg VARCHAR(1024);
    l_dpg_bas NUMBER(7) ;
    l_count NUMBER;
    l_time_stamp VARCHAR2(10);

    l_user VARCHAR2(30);

    l_commentaire_create VARCHAR2(50) ;
    type_ligne VARCHAR2(10);

BEGIN


        l_commentaire_create := 'Création';

        l_user := pack_global.lire_globaldata(p_userid).idarpege;


        SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY') INTO l_time_stamp FROM DUAL ;


            --Tester si le DPG BAS existe déjà
         BEGIN

             l_dpg_bas := NULL ;

             SELECT  dpg_bas INTO l_dpg_bas
             FROM  COUT_STD_KE
             WHERE annee = TO_NUMBER(p_couann)
             AND dpg_bas = TO_NUMBER(p_codsg_bas)
             AND ROWNUM<=1;

             IF (l_dpg_bas IS NOT NULL) THEN
                --Message d'erreur : Le codsg bas existe déjà
                 Pack_Global.recuperer_message(20370, NULL, NULL, NULL, p_message);
                 RAISE_APPLICATION_ERROR( -20997, p_message );
             END IF;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                 NULL;
         END;


         --Vérifier qu'il n'existe pas de tranche DPG_HAUT - DPG_BAS chevauchant
         --celle que l'on veut créer
         BEGIN
          SELECT  COUNT(*) INTO l_count
             FROM  COUT_STD_KE
             WHERE annee = TO_NUMBER(p_couann)
             AND dpg_bas <= TO_NUMBER(p_codsg_haut)
             AND dpg_haut >= TO_NUMBER(p_codsg_bas);
              IF (l_count>0) THEN
                --Message d'erreur : il existe un cout standard en KE avec une
                --tranche DPG chevauchant celle saisie
                 Pack_Global.recuperer_message(21062, NULL, NULL, NULL, p_message);
                 RAISE_APPLICATION_ERROR(  -20997, p_message );
             END IF;
         END ;



         if (to_number(p_couann) > 2009) then
         -- TYPE 1 (GT1)
         type_ligne := 'GT1';
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutME_type1), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'ME', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
          VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutMO_type1), TO_NUMBER(p_codsg_haut),
              TO_NUMBER(p_codsg_bas), 'MO', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutHOM_type1), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'HOM', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutGAP_type1), TO_NUMBER(p_codsg_haut),
              TO_NUMBER(p_codsg_bas), 'GAP',0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutEXP_type1), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'EXP', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutSAU_type1), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'SAU', 0,TO_NUMBER(p_fourCopi),type_ligne);
               log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'TOUS'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'CODE_FOUR_COPI' , '' ,p_fourCopi   ,1 , l_commentaire_create, type_ligne)  ;
             -- Fiche 596 : Log couts std KE
         -- Log des couts par métier
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'ME'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutME_type1  ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'MO'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutMO_type1   ,1 , l_commentaire_create,type_ligne)  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'HOM'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutHOM_type1   ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'GAP'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , '' ,p_coutGAP_type1   ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'EXP'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , '' ,p_coutEXP_type1   ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'SAU'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutSAU_type1   ,1 , l_commentaire_create,type_ligne )  ;

         --  TYPES 2 (AUTRE)
         type_ligne := 'AUTRE';
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutME_type2), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'ME', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
          VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutMO_type2), TO_NUMBER(p_codsg_haut),
              TO_NUMBER(p_codsg_bas), 'MO', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutHOM_type2), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'HOM', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutGAP_type2), TO_NUMBER(p_codsg_haut),
              TO_NUMBER(p_codsg_bas), 'GAP',0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutEXP_type2), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'EXP', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutSAU_type2), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'SAU', 0,TO_NUMBER(p_fourCopi),type_ligne);
         log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'TOUS'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'CODE_FOUR_COPI' , '' ,p_fourCopi   ,1 , l_commentaire_create, type_ligne)  ;
            -- Fiche 596 : Log couts std KE
         -- Log des couts par métier
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'ME'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutME_type2  ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'MO'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutMO_type2   ,1 , l_commentaire_create,type_ligne)  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'HOM'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutHOM_type2   ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'GAP'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , '' ,p_coutGAP_type2   ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'EXP'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , '' ,p_coutEXP_type2   ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'SAU'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutSAU_type2   ,1 , l_commentaire_create,type_ligne )  ;

              -- 'Coût Standard KE ' || p_couann ||  ' a été créé.';
     Pack_Global.recuperer_message(21064, '%s1', p_couann, NULL, p_message);

         else

         type_ligne :='TOUT';

                  INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutME_type1), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'ME', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
          VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutMO_type1), TO_NUMBER(p_codsg_haut),
              TO_NUMBER(p_codsg_bas), 'MO', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutHOM_type1), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'HOM', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutGAP_type1), TO_NUMBER(p_codsg_haut),
              TO_NUMBER(p_codsg_bas), 'GAP',0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutEXP_type1), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'EXP', 0,TO_NUMBER(p_fourCopi),type_ligne);
         INSERT INTO COUT_STD_KE (annee, cout, dpg_haut, dpg_bas, METIER, flaglock,CODE_FOUR_COPI,type_ligne)
         VALUES ( TO_NUMBER(p_couann), TO_NUMBER(p_coutSAU_type1), TO_NUMBER(p_codsg_haut),
                  TO_NUMBER(p_codsg_bas), 'SAU', 0,TO_NUMBER(p_fourCopi),type_ligne);


        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'TOUS'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'CODE_FOUR_COPI' , '' ,p_fourCopi   ,1 , l_commentaire_create, type_ligne)  ;
             -- Fiche 596 : Log couts std KE
         -- Log des couts par métier
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'ME'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutME_type1  ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'MO'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutMO_type1   ,1 , l_commentaire_create,type_ligne)  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'HOM'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutHOM_type1   ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'GAP'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , '' ,p_coutGAP_type1   ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'EXP'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , '' ,p_coutEXP_type1   ,1 , l_commentaire_create,type_ligne )  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'SAU'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' ,'' , p_coutSAU_type1   ,1 , l_commentaire_create,type_ligne )  ;

                 -- 'Coût Standard KE ' || p_couann ||  ' a été créé.';
     Pack_Global.recuperer_message(21064, '%s1', p_couann, NULL, p_message);

         end if;











EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
         Pack_Global.recuperer_message(20370, NULL, NULL, NULL, p_message);
        RAISE_APPLICATION_ERROR( -20997, p_message );

     WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END insert_cout_standard_ke;



/************************************************************************************/
/*                                                                                  */
/*       Pré insert des couts KE : insert dans table  TMP_COUTKE_ETATS              */
/*                                                                                  */
/************************************************************************************/
-- variable ecran_isac : indique que l'état à sortir est : par client avec sous traitance
-- depuis écran isac
-- 28/11/2011 BSA QC 1281 - Ajout p_global
-- 16/04/2012 BSA 1420    - Le perim ME ne doit pas etre pris en compte dans le menu REF

FUNCTION insert_tmp_coutke_etats(
                                    annee               IN NUMBER ,
                                    p_param6            IN  VARCHAR2 ,
                                    etat_sous_traitance IN VARCHAR2,
                                    ecran_isac          IN VARCHAR2 ,
                                    CODE_CHEF_PROJET    IN VARCHAR2,
                                    matricule           IN VARCHAR2 ,
                                    p_global            IN VARCHAR2,
-- FAD PPM 63956 : Ajout du P_PERIME pour faciliter le traitement niveau export
									P_PERIME            IN VARCHAR2
-- FAD PPM 63956 : Fin
   )  RETURN NUMBER IS


     l_msg VARCHAR(1024);
     p_message VARCHAR(1024);
     l_dpg_bas NUMBER(7);
     l_param VARCHAR2(100);
     l_param_requete VARCHAR2(400);
     l_annee NUMBER(4) ;
     l_annee_plusun NUMBER(4) ;
     requet  VARCHAR2(5000);
     metierExclus VARCHAR2(10);
     fin_requete VARCHAR2(500);
     last_requete VARCHAR2(2000);

     l_num_seq NUMBER(7);

     l_cout_consomme NUMBER(12,2);
     l_cout_consomme_nonarrondi NUMBER(12,6);
     l_cout_ke  NUMBER(12,2);
     l_cout_anneeplusun_ke  NUMBER(12,2);
     l_consomme NUMBER(12,2);
     l_resteafaire NUMBER(12,6);
     l_cout_constate_non_arrondi NUMBER(12,6) ;

     l_count NUMBER;

     compt NUMBER ;

     codsg_coutpardefaut NUMBER(7) ;

     --infos utilisateur (matricule,branche) + date du jour : timestamp
     l_coddir NUMBER(2);
     l_codbr NUMBER(2);
     l_codsg_utiilisateur NUMBER(7);
     l_anomalie VARCHAR2(500) ;
     l_timestamp  DATE;
     l_retour NUMBER(1) ;
     l_flag_anomalie_detectee NUMBER(1)  ;


     l_cusag_proplus NUMBER(12,2) ;
     l_pcpi_proplus NUMBER(5)  ;
     l_pid_proplus VARCHAR2(4) ;

     type_ligne_bip VARCHAR2(5);

    TYPE lignesCurTyp IS REF CURSOR;
    lignesCt lignesCurTyp ;

    ligneTableTemp TMP_COUTKE_ETATS%ROWTYPE ;

    l_perim_me      VARCHAR2(1000);

      CURSOR curseur_requete(c_annee NUMBER, p_param6 VARCHAR2) IS SELECT  DISTINCT
                                lb.pid PID   ,
                             lb.codsg codsg,
                             --budg.annee  annee,
                             c_annee annee,
                             lb.METIER METIER ,
                             NVL(conso.cusag,0)                 CONSOJH,
                             NVL(budg.reestime,0)      REESTJH,
                             NVL(budg.bpmontme,0)         PROPOJH,
                             NVL(budg.bnmont,0)                 NOTIFJH,
                             NVL(budg.bpmontmo,0)        PROPOMOJH,
                             NVL(budg.anmont,0)                ARBITJH,
                             NVL(budg1.bpmontme,0)        PROPOJH1,
                             NVL(budg1.bpmontmo,0)        PROPOMOJH1
                          FROM  LIGNE_BIP       lb  ,  STRUCT_INFO S,  PROJ_INFO       pri ,
                          BUDGET     budg  ,  BUDGET     budg1 , CONSOMME conso   ,     RESSOURCE       r   ,  CLIENT_MO  cm
                          WHERE
                          lb.icpi    = pri.icpi  AND S.codsg= lb.codsg  AND lb.clicode = cm.clicode
                          AND lb.pcpi    = r.ident AND lb.pid = budg.pid  (+)   AND lb.pid = conso.pid (+)
                          AND lb.pid = budg1.pid (+)
                          AND lb.typproj!=9
                          AND lb.typproj!=7
                          AND trim(lb.METIER) !=  ( 'FOR' )
                          AND (   (  conso.cusag     <> 0 AND   conso.cusag    IS NOT NULL ) OR ( budg.reestime  <> 0 AND  budg.reestime IS NOT NULL )
                          OR ( budg.bpmontme     <> 0 AND  budg.bpmontme    IS NOT NULL )  OR ( budg.bnmont      <> 0 AND  budg.bnmont     IS NOT NULL )
                           OR ( budg.bpmontmo     <> 0 AND  budg.bpmontmo    IS NOT NULL )  OR (budg.anmont      <> 0 AND budg.anmont     IS NOT NULL )
                          OR (budg1.bpmontme     <> 0 AND budg1.bpmontme    IS NOT NULL)  OR (budg1.bpmontmo     <> 0 AND budg1.bpmontmo    IS NOT NULL)
                           )
                           AND budg.annee(+) = c_annee
                           AND budg1.annee(+) = (c_annee+1)
                             AND conso.annee(+) = c_annee
                           AND  TO_CHAR(lb.codsg, 'FM0000000')  LIKE  RTRIM(RTRIM(LPAD(p_param6, 7, '0'),'*')) || '%'
                           AND lb.codsg IN (SELECT codsg FROM vue_dpg_perime where INSTR(l_perim_me, codbddpg) > 0 ); 
                           
      CURSOR curseur_requete_ref(c_annee NUMBER, p_param6 VARCHAR2) IS SELECT  DISTINCT
                                lb.pid PID   ,
                             lb.codsg codsg,
                             --budg.annee  annee,
                             c_annee annee,
                             lb.METIER METIER ,
                             NVL(conso.cusag,0)                 CONSOJH,
                             NVL(budg.reestime,0)      REESTJH,
                             NVL(budg.bpmontme,0)         PROPOJH,
                             NVL(budg.bnmont,0)                 NOTIFJH,
                             NVL(budg.bpmontmo,0)        PROPOMOJH,
                             NVL(budg.anmont,0)                ARBITJH,
                             NVL(budg1.bpmontme,0)        PROPOJH1,
                             NVL(budg1.bpmontmo,0)        PROPOMOJH1
                          FROM  LIGNE_BIP       lb  ,  STRUCT_INFO S,  PROJ_INFO       pri ,
                          BUDGET     budg  ,  BUDGET     budg1 , CONSOMME conso   ,     RESSOURCE       r   ,  CLIENT_MO  cm
                          WHERE
                          lb.icpi    = pri.icpi  AND S.codsg= lb.codsg  AND lb.clicode = cm.clicode
                          AND lb.pcpi    = r.ident AND lb.pid = budg.pid  (+)   AND lb.pid = conso.pid (+)
                          AND lb.pid = budg1.pid (+)
                          AND lb.typproj!=9
                          AND lb.typproj!=7
                          AND trim(lb.METIER) !=  ( 'FOR' )
                          AND (   (  conso.cusag     <> 0 AND   conso.cusag    IS NOT NULL ) OR ( budg.reestime  <> 0 AND  budg.reestime IS NOT NULL )
                          OR ( budg.bpmontme     <> 0 AND  budg.bpmontme    IS NOT NULL )  OR ( budg.bnmont      <> 0 AND  budg.bnmont     IS NOT NULL )
                           OR ( budg.bpmontmo     <> 0 AND  budg.bpmontmo    IS NOT NULL )  OR (budg.anmont      <> 0 AND budg.anmont     IS NOT NULL )
                          OR (budg1.bpmontme     <> 0 AND budg1.bpmontme    IS NOT NULL)  OR (budg1.bpmontmo     <> 0 AND budg1.bpmontmo    IS NOT NULL)
                           )
                           AND budg.annee(+) = c_annee
                           AND budg1.annee(+) = (c_annee+1)
                             AND conso.annee(+) = c_annee;


                        --------------------------------------------------------------------------------------------------
                        -- requête quasiment identique pour Etat : par client avec sous traitance
                        -- condition sur clause WHERE : CODSG
                        --------------------------------------------------------------------------------------------------
                        CURSOR curseur_requete_sst_codsg(c_annee NUMBER, p_param6 VARCHAR2) IS SELECT  DISTINCT
                                lb.pid PID   ,
                             lb.codsg codsg,
                             --budg.annee  annee,
                             c_annee annee,
                             lb.METIER METIER ,
                             NVL(conso.cusag,0)                 CONSOJH,
                             NVL(budg.reestime,0)      REESTJH,
                             NVL(budg.bpmontme,0)         PROPOJH,
                             NVL(budg.bnmont,0)                 NOTIFJH,
                             NVL(budg.bpmontmo,0)        PROPOMOJH,
                             NVL(budg.anmont,0)                ARBITJH,
                             NVL(budg1.bpmontme,0)        PROPOJH1,
                             NVL(budg1.bpmontmo,0)        PROPOMOJH1  ,
                             pro.PCPI ,
                             pro.PID PROPID
                          FROM  LIGNE_BIP       lb  ,
                                  PROPLUS pro,
                                  STRUCT_INFO S,
                                 STRUCT_INFO S2,
                                   PROJ_INFO       pri ,
                                    BUDGET     budg  ,
                                    BUDGET     budg1 ,
                                     CONSOMME conso   ,
                                      RESSOURCE       r   ,
                                       RESSOURCE       r2   ,
                                       CLIENT_MO       cm
                        WHERE  lb.icpi    = pri.icpi
                               AND S.codsg= lb.codsg
                               AND lb.pid=pro.factpid(+)
                               AND TO_CHAR(pro.cdeb(+),'yyyy') = TO_CHAR(c_annee)
                               AND pro.pcpi=r2.ident(+)
                               AND S2.codsg(+)= pro.pdsg
                               AND lb.clicode = cm.clicode
                               AND lb.pcpi    = r.ident
                               AND lb.pid = budg.pid  (+)
                               AND lb.pid = conso.pid   (+)
                               AND lb.pid = budg1.pid (+)
                               AND lb.typproj!=9
                               AND (   (  conso.cusag     <> 0 AND   conso.cusag    IS NOT NULL )
                                    OR ( budg.reestime  <> 0 AND  budg.reestime IS NOT NULL )
                                    OR ( budg.bpmontme     <> 0 AND  budg.bpmontme    IS NOT NULL )
                                    OR ( budg.bnmont      <> 0 AND  budg.bnmont     IS NOT NULL )
                                    OR ( budg.bpmontmo     <> 0 AND  budg.bpmontmo    IS NOT NULL )
                                    OR (budg.anmont      <> 0 AND budg.anmont     IS NOT NULL )
                                    OR (budg1.bpmontme     <> 0 AND budg1.bpmontme    IS NOT NULL)
                                    OR (budg1.bpmontmo     <> 0 AND budg1.bpmontmo    IS NOT NULL)
                                    )
                                AND budg.annee(+) = c_annee
                                AND budg1.annee(+) = (c_annee+1)
                                AND conso.annee(+) = c_annee
                                AND  TO_CHAR(lb.codsg, 'FM0000000')  LIKE  RTRIM(RTRIM(LPAD(p_param6, 7, '0'),'*')) || '%'
                                AND lb.codsg IN (SELECT codsg FROM vue_dpg_perime where INSTR(l_perim_me, codbddpg) > 0 );

                        CURSOR curseur_requete_sst_codsg_ref(c_annee NUMBER, p_param6 VARCHAR2) IS SELECT  DISTINCT
                                lb.pid PID   ,
                             lb.codsg codsg,
                             --budg.annee  annee,
                             c_annee annee,
                             lb.METIER METIER ,
                             NVL(conso.cusag,0)                 CONSOJH,
                             NVL(budg.reestime,0)      REESTJH,
                             NVL(budg.bpmontme,0)         PROPOJH,
                             NVL(budg.bnmont,0)                 NOTIFJH,
                             NVL(budg.bpmontmo,0)        PROPOMOJH,
                             NVL(budg.anmont,0)                ARBITJH,
                             NVL(budg1.bpmontme,0)        PROPOJH1,
                             NVL(budg1.bpmontmo,0)        PROPOMOJH1  ,
                             pro.PCPI ,
                             pro.PID PROPID
                          FROM  LIGNE_BIP       lb  ,
                                  PROPLUS pro,
                                  STRUCT_INFO S,
                                 STRUCT_INFO S2,
                                   PROJ_INFO       pri ,
                                    BUDGET     budg  ,
                                    BUDGET     budg1 ,
                                     CONSOMME conso   ,
                                      RESSOURCE       r   ,
                                       RESSOURCE       r2   ,
                                       CLIENT_MO       cm
                        WHERE  lb.icpi    = pri.icpi
                               AND S.codsg= lb.codsg
                               AND lb.pid=pro.factpid(+)
                               AND TO_CHAR(pro.cdeb(+),'yyyy') = TO_CHAR(c_annee)
                               AND pro.pcpi=r2.ident(+)
                               AND S2.codsg(+)= pro.pdsg
                               AND lb.clicode = cm.clicode
                               AND lb.pcpi    = r.ident
                               AND lb.pid = budg.pid  (+)
                               AND lb.pid = conso.pid   (+)
                               AND lb.pid = budg1.pid (+)
                               AND lb.typproj!=9
                               AND (   (  conso.cusag     <> 0 AND   conso.cusag    IS NOT NULL )
                                    OR ( budg.reestime  <> 0 AND  budg.reestime IS NOT NULL )
                                    OR ( budg.bpmontme     <> 0 AND  budg.bpmontme    IS NOT NULL )
                                    OR ( budg.bnmont      <> 0 AND  budg.bnmont     IS NOT NULL )
                                    OR ( budg.bpmontmo     <> 0 AND  budg.bpmontmo    IS NOT NULL )
                                    OR (budg.anmont      <> 0 AND budg.anmont     IS NOT NULL )
                                    OR (budg1.bpmontme     <> 0 AND budg1.bpmontme    IS NOT NULL)
                                    OR (budg1.bpmontmo     <> 0 AND budg1.bpmontmo    IS NOT NULL)
                                    )
                                AND budg.annee(+) = c_annee
                                AND budg1.annee(+) = (c_annee+1)
                                AND conso.annee(+) = c_annee;

     CURSOR curseur_temp_couts(l_num_seq_var NUMBER) IS SELECT * FROM TMP_COUTKE_ETATS
     WHERE NUMSEQ = l_num_seq_var;

    CURSOR c_lbl_branche(l_codsg NUMBER) IS
        SELECT d.CODBR, b.LIBBR  
            FROM STRUCT_INFO s ,DIRECTIONS d, BRANCHES b
            WHERE 1 = 1
                AND s.CODDIR = d.CODDIR
                AND b.CODBR = d.CODBR
                AND CODSG =  l_codsg  ;
    
    t_lbl_branche   c_lbl_branche%ROWTYPE;  
    l_menu  VARCHAR2(50);
             

BEGIN

    BEGIN

        l_perim_me := P_PERIME;
        l_menu := pack_global.LIRE_MENUTIL(p_global);  
               
        codsg_coutpardefaut :=  9999999 ;
        -- last_requete := ' and budg.annee(+) = 2007 and budg1.annee(+) = 2008 and conso.annee(+) = 2007 ';

        -- récupération d'un numéro de séquence
        -- les données générées par deux utilisateurs seront différenciées par le NUMSEQ
        SELECT BIP.SETATKE.NEXTVAL INTO l_num_seq FROM DUAL ;

        l_timestamp := SYSDATE ;

        --------------------------------------------------------------------------------------
        --  SI PAS ETAT PAR CLIENT AVEC SOUS TRAITANCE
        --------------------------------------------------------------------------------------
        IF (etat_sous_traitance IS NULL) THEN

            -- Dans le menu referentiel pas de filtre sur le perim me
            IF ( l_menu = 'REF' ) THEN       

                FOR curseur IN curseur_requete_ref( annee, p_param6)  LOOP
                          
                        INSERT INTO TMP_COUTKE_ETATS (
                             PID,
                             CODSG,
                             METIER ,
                             NUMSEQ ,

                             COUT_KE  ,
                             COUT_ANNEEPLUSUN_KE  ,
                             CONSOJH  ,
                             REESTJH ,
                             PROPOJH  ,
                             NOTIFJH ,
                             PROPOMOJH  ,
                             ARBITJH  ,
                             PROPOJH1  ,
                             PROPOMOJH1 ,

                             CONSO_KE  ,
                             REEST_KE  ,
                             PROPO_KE ,
                             NOTIF_KE ,
                             PROPOMO_KE  ,
                             ARBIT_KE  ,
                             PROPO_ANNEEPLUSUN_KE  ,
                             PROPOMO_ANNEEPLUSUN_KE ,
                             ANNEE ,
                             ANNEEPLUSUN  ,
                             RESTEAFAIREJH
                        )  VALUES  (
                                  curseur.PID  ,
                               curseur.codsg ,
                               curseur.METIER ,
                                l_num_seq  ,

                               0,
                               0,
                               curseur.CONSOJH  ,
                               curseur.REESTJH ,
                               curseur.PROPOJH  ,
                               curseur.NOTIFJH ,
                               curseur.PROPOMOJH  ,
                               curseur.ARBITJH  ,
                               curseur.PROPOJH1  ,
                               curseur.PROPOMOJH1 ,
                               0,
                               0,
                               0,
                               0,
                               0,
                               0,
                               0,
                               0,
                               curseur.annee,
                               (NVL(curseur.annee,0) + 1) , --annee_budg1,
                               0
                      );
                            

                END LOOP ;
                
            ELSE
            
                FOR curseur IN curseur_requete( annee, p_param6)  LOOP
                          
                    INSERT INTO TMP_COUTKE_ETATS (
                         PID,
                         CODSG,
                         METIER ,
                         NUMSEQ ,

                         COUT_KE  ,
                         COUT_ANNEEPLUSUN_KE  ,
                         CONSOJH  ,
                         REESTJH ,
                         PROPOJH  ,
                         NOTIFJH ,
                         PROPOMOJH  ,
                         ARBITJH  ,
                         PROPOJH1  ,
                         PROPOMOJH1 ,

                         CONSO_KE  ,
                         REEST_KE  ,
                         PROPO_KE ,
                         NOTIF_KE ,
                         PROPOMO_KE  ,
                         ARBIT_KE  ,
                         PROPO_ANNEEPLUSUN_KE  ,
                         PROPOMO_ANNEEPLUSUN_KE ,
                         ANNEE ,
                         ANNEEPLUSUN  ,
                         RESTEAFAIREJH
                    )  VALUES  (
                              curseur.PID  ,
                           curseur.codsg ,
                           curseur.METIER ,
                            l_num_seq  ,

                           0,
                           0,
                           curseur.CONSOJH  ,
                           curseur.REESTJH ,
                           curseur.PROPOJH  ,
                           curseur.NOTIFJH ,
                           curseur.PROPOMOJH  ,
                           curseur.ARBITJH  ,
                           curseur.PROPOJH1  ,
                           curseur.PROPOMOJH1 ,
                           0,
                           0,
                           0,
                           0,
                           0,
                           0,
                           0,
                           0,
                           curseur.annee,
                           (NVL(curseur.annee,0) + 1) , --annee_budg1,
                           0
                  );
                            

                END LOOP ;
            
            END IF;

        --------------------------------------------------------------------------------------
        --  SI  ETAT PAR CLIENT AVEC SOUS TRAITANCE
        --------------------------------------------------------------------------------------
        ELSE

            --------------------------------------------------------------------------------------
            --  SI  DEPUIS ECRAN MENSUELLE
            --------------------------------------------------------------------------------------
            IF(ecran_isac IS NULL) THEN
            
                -- Dans le menu referentiel pas de filtre sur le perim me
                IF ( l_menu = 'REF' ) THEN 

                    FOR curseur IN curseur_requete_sst_codsg_ref( annee, p_param6)  LOOP
                             INSERT INTO TMP_COUTKE_ETATS (
                                  PID,
                                  CODSG,
                                  METIER ,
                                  NUMSEQ ,
                                  COUT_KE  ,
                                  COUT_ANNEEPLUSUN_KE  ,
                                  CONSOJH  ,
                                  REESTJH ,
                                  PROPOJH  ,
                                  NOTIFJH ,
                                  PROPOMOJH  ,
                                  ARBITJH  ,
                                  PROPOJH1  ,
                                  PROPOMOJH1 ,
                                  CONSO_KE  ,
                                  REEST_KE  ,
                                  PROPO_KE ,
                                  NOTIF_KE ,
                                  PROPOMO_KE  ,
                                  ARBIT_KE  ,
                                  PROPO_ANNEEPLUSUN_KE  ,
                                  PROPOMO_ANNEEPLUSUN_KE ,
                                  ANNEE ,
                                  ANNEEPLUSUN  ,
                                  RESTEAFAIREJH ,
                                  PROCONSOJH ,
                                  PROCONSO_KE   ,
                                  PCPI ,
                                  PID_PROPLUS
                             )  VALUES   (
                                    curseur.PID  ,
                                    curseur.codsg ,
                                    curseur.METIER ,
                                    l_num_seq  ,
                                    0,
                                    0,
                                    curseur.CONSOJH  ,
                                    curseur.REESTJH ,
                                    curseur.PROPOJH  ,
                                    curseur.NOTIFJH ,
                                    curseur.PROPOMOJH  ,
                                    curseur.ARBITJH  ,
                                    curseur.PROPOJH1  ,
                                    curseur.PROPOMOJH1 ,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    curseur.annee,
                                    (NVL(curseur.annee,0) + 1), -- annee_budg1,
                                    0  ,  -- reste a faire
                                    0, -- curseur.PROCONSOJH ,
                                    0,     --  PROCONSO_KE ,
                                    curseur.PCPI ,
                                    curseur.PROPID

                           );

                    END LOOP ;
                 
                ELSE

                    FOR curseur IN curseur_requete_sst_codsg( annee, p_param6)  LOOP
                    
                     
                             INSERT INTO TMP_COUTKE_ETATS (
                                  PID,
                                  CODSG,
                                  METIER ,
                                  NUMSEQ ,
                                  COUT_KE  ,
                                  COUT_ANNEEPLUSUN_KE  ,
                                  CONSOJH  ,
                                  REESTJH ,
                                  PROPOJH  ,
                                  NOTIFJH ,
                                  PROPOMOJH  ,
                                  ARBITJH  ,
                                  PROPOJH1  ,
                                  PROPOMOJH1 ,
                                  CONSO_KE  ,
                                  REEST_KE  ,
                                  PROPO_KE ,
                                  NOTIF_KE ,
                                  PROPOMO_KE  ,
                                  ARBIT_KE  ,
                                  PROPO_ANNEEPLUSUN_KE  ,
                                  PROPOMO_ANNEEPLUSUN_KE ,
                                  ANNEE ,
                                  ANNEEPLUSUN  ,
                                  RESTEAFAIREJH ,
                                  PROCONSOJH ,
                                  PROCONSO_KE   ,
                                  PCPI ,
                                  PID_PROPLUS
                             )  VALUES   (
                                    curseur.PID  ,
                                    curseur.codsg ,
                                    curseur.METIER ,
                                    l_num_seq  ,
                                    0,
                                    0,
                                    curseur.CONSOJH  ,
                                    curseur.REESTJH ,
                                    curseur.PROPOJH  ,
                                    curseur.NOTIFJH ,
                                    curseur.PROPOMOJH  ,
                                    curseur.ARBITJH  ,
                                    curseur.PROPOJH1  ,
                                    curseur.PROPOMOJH1 ,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    curseur.annee,
                                    (NVL(curseur.annee,0) + 1), -- annee_budg1,
                                    0  ,  -- reste a faire
                                    0, -- curseur.PROCONSOJH ,
                                    0,     --  PROCONSO_KE ,
                                    curseur.PCPI ,
                                    curseur.PROPID

                           );

                    END LOOP ;
                                     
                END IF;
                 

            END IF ;
            
        END IF ;

               --------------------------------------------------------------------------------------------------------
                  -- ETAPE 2 : Recherche cout standard en KE ANNEE et cout standard en KE ANNEE + 1 pour chaque ligne BIP
               --------------------------------------------------------------------------------------------------------

                -----------------------------------------------------------------------------------------------
                -- MAJ table temporaire TMP_COUTKE_ETATS ANNEE N
                -----------------------------------------------------------------------------------------------
                FOR curseurTemp IN  curseur_temp_couts(l_num_seq) LOOP

                        --  RECHERCHE COUT STANDARD ANNEE  POUR LA LIGNE BIP ACTUELLE DU CURSEUR
                        --  LIGNE BIP:CODSG
                        --  LIGNE BIP:METIER
                        --  LIGNE BIP:ANNEE
                        --  Le coût standard est récupéré dans la table COUT_STD_KE
                        --  cette table fournit un cout standard pour chaque : CODSG, METIER,ANNEE donnés
                       --  Si l'année est supérieur à 2009 on utilise le type de la ligne bip pour determiner quel cout on doit utiliser (GT1 ou autre)

                        l_cout_ke := 0 ;
                        l_flag_anomalie_detectee  := 0 ;


                        -- Recherche type de ligne (T1 ou autres)
                        select arctype into type_ligne_bip from ligne_bip where pid = curseurTemp.pid;

                        IF(  curseurTemp.annee  IS NOT NULL AND LENGTH(curseurTemp.annee)>0  ) THEN

                              IF (curseurTemp.annee > 2009) THEN
                                  IF (type_ligne_bip = 'T1') THEN
                                    type_ligne_bip := 'GT1';
                                  ELSE
                                    type_ligne_bip := 'AUTRE';
                                  END IF;
                              ELSE
                                 type_ligne_bip := 'TOUT';
                              END IF;

                              l_count := 0 ;
                                SELECT COUNT(*) INTO l_count  FROM  COUT_STD_KE cout  WHERE
                                                cout.annee = curseurTemp.annee
                                                AND cout.dpg_bas<=curseurTemp.codsg
                                                AND cout.dpg_haut>=curseurTemp.codsg
                                                AND cout.dpg_haut != codsg_coutpardefaut
                                                AND cout.dpg_bas != codsg_coutpardefaut
                                                AND trim(cout.METIER) = trim(curseurTemp.METIER)
                                                AND TYPE_LIGNE = type_ligne_bip  ;

                                     -- Gestion de récupération du cout standard en KE
                                     -- si anomalie : ramène le cout par défaut (CODSG = 9999999)
                                     IF(l_count=1) THEN
                                           -- Via ANNEE,CODSG,METIER lecture cout standard en KE table COUT_STD_KE
                                           SELECT DISTINCT cout.cout INTO l_cout_ke FROM  COUT_STD_KE cout
                                           WHERE  cout.annee = curseurTemp.annee
                                            AND cout.dpg_bas<=curseurTemp.codsg  AND cout.dpg_haut>=curseurTemp.codsg
                                            AND cout.dpg_haut != codsg_coutpardefaut
                                            AND trim(cout.METIER)  = trim(curseurTemp.METIER)  AND ROWNUM <=1
                                            AND TYPE_LIGNE = type_ligne_bip  ;

                                           --ecriture dans table Anomalies
                                           IF(l_cout_ke=0)THEN
                                             l_flag_anomalie_detectee := 1 ;
                                             --OPEN c_lbl_branche(curseurTemp.codsg);
                                             --FETCH c_lbl_branche INTO t_lbl_branche;
                                             --CLOSE c_lbl_branche;
                                             --l_anomalie := 'Le coût du métier est à 0';
                                             --l_retour := creer_anomalie_coutstdKE( curseurTemp.annee, curseurTemp.codsg,
                                              --              curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                              --              t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                             
                                           END IF ;
                                      END IF ;

                                    --ecriture dans table Anomalies
                                    IF(l_count=0 OR l_count>1) THEN
                                           l_flag_anomalie_detectee := 1 ;
                                           
                                           /*
                                           IF(l_count=0) THEN
                                             l_anomalie := 'Pas de poste dans la table pour ce critère';
                                             OPEN c_lbl_branche(curseurTemp.codsg);
                                             FETCH c_lbl_branche INTO t_lbl_branche;
                                             CLOSE c_lbl_branche;                            
                                             l_retour := creer_anomalie_coutstdKE( curseurTemp.annee, curseurTemp.codsg,
                                                     curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                                     t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                           END IF ;
                                           IF(l_count>1) THEN
                                             l_anomalie := 'Plusieurs postes dans la table pour ce critère';
                                             OPEN c_lbl_branche(curseurTemp.codsg);
                                             FETCH c_lbl_branche INTO t_lbl_branche;
                                             CLOSE c_lbl_branche;
                                             l_retour := creer_anomalie_coutstdKE( curseurTemp.annee, curseurTemp.codsg,
                                                     curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                                     t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                           END IF ;
                                             */
                                             
                                      END IF ;

                                     -- Anomalie : Recherche cout par défaut via ANNEE,CODSG= 9999999 ,
                                     --            METIER  lecture cout standard par défaut en KE table COUT_STD_KE
                                     IF(l_flag_anomalie_detectee = 1) THEN
                                           SELECT cout.cout INTO l_cout_ke  FROM  COUT_STD_KE cout WHERE
                                           cout.annee = curseurTemp.annee AND cout.dpg_haut= codsg_coutpardefaut
                                           AND trim(cout.METIER)  = trim(curseurTemp.METIER)
                                           AND TYPE_LIGNE = type_ligne_bip AND ROWNUM <=1 ;
                                     END IF ;

                                     -- MAJ COUT STANDARD pour la ligne BIP avec
                                     -- LIGNE BIP PID
                                     -- LIGNE BIP CODSG
                                       -- LIGNE BIP METIER
                                      UPDATE TMP_COUTKE_ETATS SET COUT_KE = l_cout_ke WHERE
                                                                      TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                                                      AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                      trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                        TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                      AND curseurTemp.NUMSEQ = l_num_seq ;


                            END IF ;


                             -------------------------------------------------------------------------------------
                             --  RECHERCHE COUT STANDARD ANNEE + 1 POUR LA MEME LIGNE BIP
                             -------------------------------------------------------------------------------------
                             --  Le coût standard est récupéré dans la table COUT_STD_KE
                             --  cette table fournit un cout standard pour chaque : CODSG, METIER,ANNEE + 1 donnés
                             --  Si l'année est supérieur à 2009 on utilise le type de la ligne bip pour determiner quel cout on doit utiliser (GT1 ou autre)

                             select arctype into type_ligne_bip from ligne_bip where pid = curseurTemp.pid;

                             l_cout_anneeplusun_ke := 0 ;
                             l_flag_anomalie_detectee  := 0 ;
                             IF( (curseurTemp.ANNEEPLUSUN IS NOT NULL) AND (LENGTH(curseurTemp.ANNEEPLUSUN)>0) AND
                                (curseurTemp.annee  IS NOT NULL) AND (LENGTH(curseurTemp.annee)>0) )  THEN
                                  l_count := 0 ;

                                   IF (curseurTemp.ANNEEPLUSUN > 2009) THEN
                                        IF (type_ligne_bip = 'T1') THEN
                                            type_ligne_bip := 'GT1';
                                        ELSE
                                            type_ligne_bip := 'AUTRE';
                                        END IF;
                                  ELSE
                                        type_ligne_bip := 'TOUT';
                                  END IF;



                                   SELECT COUNT(*) INTO l_count  FROM  COUT_STD_KE cout  WHERE
                                                cout.annee = curseurTemp.ANNEEPLUSUN
                                                AND cout.dpg_bas<=curseurTemp.codsg
                                                AND cout.dpg_haut>=curseurTemp.codsg
                                                AND cout.dpg_haut != codsg_coutpardefaut
                                                AND cout.dpg_bas != codsg_coutpardefaut
                                                AND trim(cout.METIER) = trim(curseurTemp.METIER)
                                                AND TYPE_LIGNE = type_ligne_bip    ;

                                     IF(l_count=1) THEN
                                           -- Via ANNEE + 1 ,CODSG,METIER lecture cout standard en KE table COUT_STD_KE
                                           SELECT DISTINCT cout.cout INTO l_cout_anneeplusun_ke FROM  COUT_STD_KE cout
                                           WHERE  cout.annee = curseurTemp.ANNEEPLUSUN
                                            AND cout.dpg_bas<=curseurTemp.codsg
                                            AND cout.dpg_haut>=curseurTemp.codsg
                                            AND cout.dpg_haut != codsg_coutpardefaut
                                           AND trim(cout.METIER)  = trim(curseurTemp.METIER)
                                           AND TYPE_LIGNE = type_ligne_bip AND ROWNUM <=1  ;
                                           --ecriture dans table Anomalies
                                           IF(l_cout_anneeplusun_ke =0)THEN
                                             l_flag_anomalie_detectee := 1 ;
                                             /*
                                             l_anomalie := 'Le coût du métier est à 0';
                                             OPEN c_lbl_branche(curseurTemp.codsg);
                                             FETCH c_lbl_branche INTO t_lbl_branche;
                                             CLOSE c_lbl_branche;
                                               l_retour := creer_anomalie_coutstdKE( curseurTemp.ANNEEPLUSUN, curseurTemp.codsg,
                                                      curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                                      t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                               */
                                           END IF ;
                                     END IF ;

                                     IF(l_count=0 OR l_count>1) THEN
                                           l_flag_anomalie_detectee := 1 ;
                                          /* 
                                            IF(l_count=0) THEN
                                             l_anomalie := 'Pas de poste dans la table pour ce critère';
                                             OPEN c_lbl_branche(curseurTemp.codsg);
                                             FETCH c_lbl_branche INTO t_lbl_branche;
                                             CLOSE c_lbl_branche;
                                               l_retour := creer_anomalie_coutstdKE( curseurTemp.ANNEEPLUSUN, curseurTemp.codsg,
                                                  curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                                  t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                           END IF ;
                                           IF(l_count>1) THEN
                                             l_anomalie := 'Plusieurs postes dans la table pour ce critère';
                                             OPEN c_lbl_branche(curseurTemp.codsg);
                                             FETCH c_lbl_branche INTO t_lbl_branche;
                                             CLOSE c_lbl_branche;
                                                     l_retour := creer_anomalie_coutstdKE( curseurTemp.ANNEEPLUSUN, curseurTemp.codsg,
                                                       curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                                      t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                           END IF ;
                                           */
                                    END IF ;

                                     -- Anomalie : Recherche cout par défaut via ANNEE + 1 ,CODSG= 9999999
                                     IF(l_flag_anomalie_detectee = 1) THEN
                                            SELECT cout.cout INTO l_cout_anneeplusun_ke  FROM  COUT_STD_KE cout WHERE
                                           cout.annee = curseurTemp.ANNEEPLUSUN
                                           AND cout.dpg_haut= codsg_coutpardefaut
                                           AND trim(cout.METIER)  = trim(curseurTemp.METIER)
                                           AND TYPE_LIGNE = type_ligne_bip AND ROWNUM <=1 ;
                                     END IF ;

                                     -- MAJ COUT STANDARD pour la ligne BIP avec
                                     -- LIGNE BIP PID
                                     -- LIGNE BIP CODSG
                                       -- LIGNE BIP METIER
                                      UPDATE TMP_COUTKE_ETATS SET COUT_ANNEEPLUSUN_KE = l_cout_anneeplusun_ke WHERE
                                                                      TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                                                      AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                      trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                        TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                      AND curseurTemp.NUMSEQ = l_num_seq ;


                             END IF ;

                             -- LES 2 COUTS STANDARD EN KE  (ANNEE et ANNEE +1 )  ont été trouvés pour chaque ligne BIP
                            -- COUT en KE pour : ANNEE  ligne BIP , METIER ligne BIP  , CODSG  ligne BIP
                            -- COUT en KE pour : ANNEE +1 ligne BIP , METIER ligne BIP  , CODSG  ligne BIP

                            -- La table TMP_COUTKE_ETATS contient donc toutes les lignes BIP
                            -- avec les 2 coûts en KE (cout  année et cout année + 1)
                            -- Cette table temporaire contient également les consommés en JH
                            -- qui servaient l'Etat PCA4 , ces JH vont simplement être multipliés
                            -- par le coût en KE afin obtenir un Etat PCA4 en KE



                            ---------------------------------------------------------------------
                            -- ETAPE 3 : calcul des champs simple (nombre JH lu * cout en KE)
                            ---------------------------------------------------------------------

                            -- Update montants ANNEE via cout standard ANNEE

                            UPDATE TMP_COUTKE_ETATS SET
                             PROPO_KE = ROUND((PROPOJH * l_cout_ke)/1000,0) ,
                              NOTIF_KE = ROUND((NOTIFJH * l_cout_ke)/1000,0),
                               PROPOMO_KE = ROUND((PROPOMOJH * l_cout_ke)/1000,0),
                                ARBIT_KE = ROUND((ARBITJH * l_cout_ke)/1000,0),
                                 PROPO_ANNEEPLUSUN_KE = ROUND((PROPOJH1 * l_cout_anneeplusun_ke)/1000,0),
                                  PROPOMO_ANNEEPLUSUN_KE = ROUND((PROPOMOJH1 * l_cout_anneeplusun_ke)/1000,0)
                                   WHERE
                                    TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                     AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg
                                      AND trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER)
                                       AND TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                        AND curseurTemp.NUMSEQ = l_num_seq ;



                                   -- Etape b) La formule de calcul du consommé est inapliccableà la
                                   -- sous traitance:  on l'affiche à BLANC
                                   IF(etat_sous_traitance IS NOT NULL) THEN


                                      UPDATE TMP_COUTKE_ETATS SET
                                           PROCONSO_KE = 0
                                               WHERE
                                                TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                                 AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg
                                                  AND trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER)
                                                   AND TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                    AND curseurTemp.NUMSEQ = l_num_seq   ;

                                    END IF ;


                            ---------------------------------------------------------------------------
                            -- ETAPE 4 : calculs complexes Consommé et Ré-estimé (voir spécifications)
                            ---------------------------------------------------------------------------

                                      --------------------------------
                                      -- ETAPE 4.1 : calcul CONSOMME
                                      --------------------------------
                                      l_count := 0 ;
                                      l_cout_consomme := 0 ;
                                      l_cout_consomme_nonarrondi :=0 ;
                                      SELECT COUNT(*) INTO   l_count  FROM SYNTHESE_ACTIVITE synth
                                                  WHERE synth.pid = curseurTemp.pid AND synth.annee = curseurTemp.annee  AND trim(synth.METIER) = trim(curseurTemp.METIER)  ;
                                      IF(  l_count > 0 )THEN
                                                    SELECT  (  ( NVL(synth.CONSOFT_SG,0) + NVL(synth.CONSOFT_SSII,0) + NVL(synth.CONSOENV_SG,0) + NVL(synth.CONSOENV_SSII,0)  ) /1000  ) INTO  l_cout_consomme_nonarrondi
                                                    FROM SYNTHESE_ACTIVITE synth  WHERE  synth.pid  =  curseurTemp.pid  AND synth.annee = curseurTemp.annee AND trim(synth.METIER)  =  trim(curseurTemp.METIER) ;
                                                    l_cout_consomme := ROUND(l_cout_consomme_nonarrondi,0) ;
                                      END IF ;

                                      UPDATE TMP_COUTKE_ETATS SET CONSO_KE = l_cout_consomme WHERE
                                                         TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                                         AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                         trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                         TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                         AND curseurTemp.NUMSEQ = l_num_seq ;

                                      --------------------------------
                                      -- ETAPE 4.1 : calcul REESTIME
                                      --------------------------------
                                      IF ( curseurTemp.CONSOJH = 0 ) THEN
                                             -- Si le consommé en jh est  = 0 alors :
                                              -- coût en k¿ du ré estimé =  (ré estimé en jh * coût)/1000
                                           UPDATE TMP_COUTKE_ETATS  SET  REEST_KE  =    ROUND(  (  NVL( curseurTemp.REESTJH,0) *  l_cout_ke   )/1000 , 0  )
                                                              WHERE
                                                                 TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                                 TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                 trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                 TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                 AND curseurTemp.NUMSEQ = l_num_seq ;
                                        ELSE
                                             -- CALCUL DU RESTE A FAIRE : Si le consommé  est > 0  : Ràf JH = ré estimé JH ¿ consommé JH
                                             l_resteafaire := curseurTemp.reestjh - curseurTemp.consojh ;

                                              --Si le ràf est = 0 :Coût en k¿ du ré estimé  =  coût en k¿ du consommé
                                             IF (l_resteafaire  = 0) THEN
                                                 UPDATE TMP_COUTKE_ETATS  SET  REEST_KE  =  l_cout_consomme
                                                            WHERE   TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                            TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                            trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                            TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                            AND curseurTemp.NUMSEQ = l_num_seq ;
                                             ELSE
                                               -- CALCUL COUT CONSTATE (non arrondi en KE): Si le reste à faire est différent de 0
                                               -- Coût constaté  = cout consommé calculé / consommé en JH
                                                    l_cout_constate_non_arrondi :=  ( l_cout_consomme_nonarrondi / curseurTemp.consojh)   ;
                                             END IF ;

                                             IF (l_resteafaire  >0  ) THEN
                                                     -- Si ràf est >0, alors le montant en kE du ré estimé se calcule ainsi :
                                                     -- Coût en kE du ré estimé  =  coût en kEdu consommé + (ràf JH * coût constaté)/1000
                                                     UPDATE TMP_COUTKE_ETATS  SET  REEST_KE = ROUND(( l_cout_consomme_nonarrondi +    (  l_cout_constate_non_arrondi * NVL(l_resteafaire,0))),0)
                                                                                     WHERE
                                                                                     TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                                                     TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                                     trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                                     TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                                     AND curseurTemp.NUMSEQ = l_num_seq ;
                                             END IF;

                                             IF (l_resteafaire  < 0 ) THEN
                                                      --Si ràf est < 0, alors le montant en KE du ré estimé se calcule ainsi :
                                                     --Coût en KE du ré estimé  =  Coût constaté  * ré-estimés en JH
                                                     UPDATE TMP_COUTKE_ETATS  SET  REEST_KE  = ROUND(  ( l_cout_constate_non_arrondi * NVL(curseurTemp.REESTJH ,0) ),0)
                                                           WHERE    TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                                    TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                    trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                    TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                    AND curseurTemp.NUMSEQ = l_num_seq ;
                                            END IF ;

                                --------- Fin Calcul réestimé  ----------
                                END IF ;



                END LOOP ;

                COMMIT ;


      END ;


     RETURN  l_num_seq ;


EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        --ROLLBACK;
         Pack_Global.recuperer_message(20370, NULL, NULL, NULL, p_message);
        RAISE_APPLICATION_ERROR( -20370, p_message );
        
   WHEN NO_DATA_FOUND THEN
             RETURN l_num_seq;

     WHEN OTHERS THEN
        --ROLLBACK;
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END INSERT_TMP_COUTKE_ETATS;

/************************************************************************************/
/*                                                                                  */
/*       Pré insert des couts KE : insert dans table  TMP_COUTKE_ETATS              */
/*                                                                                  */
/************************************************************************************/
-- FAD QC 1853 : Duplication de la fonction insert_tmp_coutke_etats en remplaçant les ROUND(VAL, 0) par ROUND(VAL, 2)

FUNCTION insert_tmp_coutke_dmdlbip(
                                    annee               IN NUMBER ,
                                    p_param6            IN  VARCHAR2 ,
                                    etat_sous_traitance IN VARCHAR2,
                                    ecran_isac          IN VARCHAR2 ,
                                    CODE_CHEF_PROJET    IN VARCHAR2,
                                    matricule           IN VARCHAR2 ,
                                    p_global            IN VARCHAR2,
-- FAD PPM 63956 : Ajout du P_PERIME pour faciliter le traitement niveau export
									P_PERIME            IN VARCHAR2
-- FAD PPM 63956 : Fin

   )  RETURN NUMBER IS


     L_HFILE utl_file.file_type;
     L_RETCOD number;
     nbrLigneInserer number;
     indiceRequete number;

     l_msg VARCHAR(1024);
     p_message VARCHAR(1024);
     l_dpg_bas NUMBER(7);
     l_param VARCHAR2(100);
     l_param_requete VARCHAR2(400);
     l_annee NUMBER(4) ;
     l_annee_plusun NUMBER(4) ;
     requet  VARCHAR2(5000);
     metierExclus VARCHAR2(10);
     fin_requete VARCHAR2(500);
     last_requete VARCHAR2(2000);

     l_num_seq NUMBER(7);

     l_cout_consomme NUMBER(12,2);
     l_cout_consomme_nonarrondi NUMBER(12,6);
     l_cout_ke  NUMBER(12,2);
     l_cout_anneeplusun_ke  NUMBER(12,2);
     l_consomme NUMBER(12,2);
     l_resteafaire NUMBER(13,6);
     l_cout_constate_non_arrondi NUMBER(12,6) ;

     l_count NUMBER;

     compt NUMBER ;

     codsg_coutpardefaut NUMBER(7) ;

     --infos utilisateur (matricule,branche) + date du jour : timestamp
     l_coddir NUMBER(2);
     l_codbr NUMBER(2);
     l_codsg_utiilisateur NUMBER(7);
     l_anomalie VARCHAR2(500) ;
     l_timestamp  DATE;
     l_retour NUMBER(1) ;
     l_flag_anomalie_detectee NUMBER(1)  ;


     l_cusag_proplus NUMBER(12,2) ;
     l_pcpi_proplus NUMBER(5)  ;
     l_pid_proplus VARCHAR2(4) ;

     type_ligne_bip VARCHAR2(5);

    TYPE lignesCurTyp IS REF CURSOR;
    lignesCt lignesCurTyp ;

    ligneTableTemp TMP_COUTKE_ETATS%ROWTYPE ;

    l_perim_me      VARCHAR2(1000);

      CURSOR curseur_requete(c_annee NUMBER, p_param6 VARCHAR2) IS SELECT  DISTINCT
                                lb.pid PID   ,
                             lb.codsg codsg,
                             --budg.annee  annee,
                             c_annee annee,
                             lb.METIER METIER ,
                             NVL(conso.cusag,0)                 CONSOJH,
                             NVL(budg.reestime,0)      REESTJH,
                             NVL(budg.bpmontme,0)         PROPOJH,
                             NVL(budg.bnmont,0)                 NOTIFJH,
                             NVL(budg.bpmontmo,0)        PROPOMOJH,
                             NVL(budg.anmont,0)                ARBITJH,
                             NVL(budg1.bpmontme,0)        PROPOJH1,
                             NVL(budg1.bpmontmo,0)        PROPOMOJH1
                          FROM  LIGNE_BIP       lb  ,  STRUCT_INFO S,  PROJ_INFO       pri ,
                          BUDGET     budg  ,  BUDGET     budg1 , CONSOMME conso   ,     RESSOURCE       r   ,  CLIENT_MO  cm
                          WHERE
                          lb.icpi    = pri.icpi  AND S.codsg= lb.codsg  AND lb.clicode = cm.clicode
                          AND lb.pcpi    = r.ident AND lb.pid = budg.pid  (+)   AND lb.pid = conso.pid (+)
                          AND lb.pid = budg1.pid (+)
                          AND lb.typproj!=9
                          AND lb.typproj!=7
                          AND trim(lb.METIER) !=  ( 'FOR' )
                          AND (   (  conso.cusag     <> 0 AND   conso.cusag    IS NOT NULL ) OR ( budg.reestime  <> 0 AND  budg.reestime IS NOT NULL )
                          OR ( budg.bpmontme     <> 0 AND  budg.bpmontme    IS NOT NULL )  OR ( budg.bnmont      <> 0 AND  budg.bnmont     IS NOT NULL )
                           OR ( budg.bpmontmo     <> 0 AND  budg.bpmontmo    IS NOT NULL )  OR (budg.anmont      <> 0 AND budg.anmont     IS NOT NULL )
                          OR (budg1.bpmontme     <> 0 AND budg1.bpmontme    IS NOT NULL)  OR (budg1.bpmontmo     <> 0 AND budg1.bpmontmo    IS NOT NULL)
                           )
                           AND budg.annee(+) = c_annee
                           AND budg1.annee(+) = (c_annee+1)
                             AND conso.annee(+) = c_annee
                           AND  TO_CHAR(lb.codsg, 'FM0000000')  LIKE  RTRIM(RTRIM(LPAD(p_param6, 7, '0'),'*')) || '%'
                           AND lb.codsg IN (SELECT codsg FROM vue_dpg_perime where INSTR(l_perim_me, codbddpg) > 0 ); 
                           
      CURSOR curseur_requete_ref(c_annee NUMBER, p_param6 VARCHAR2) IS SELECT  DISTINCT
                                lb.pid PID   ,
                             lb.codsg codsg,
                             --budg.annee  annee,
                             c_annee annee,
                             lb.METIER METIER ,
                             NVL(conso.cusag,0)                 CONSOJH,
                             NVL(budg.reestime,0)      REESTJH,
                             NVL(budg.bpmontme,0)         PROPOJH,
                             NVL(budg.bnmont,0)                 NOTIFJH,
                             NVL(budg.bpmontmo,0)        PROPOMOJH,
                             NVL(budg.anmont,0)                ARBITJH,
                             NVL(budg1.bpmontme,0)        PROPOJH1,
                             NVL(budg1.bpmontmo,0)        PROPOMOJH1
                          FROM  LIGNE_BIP       lb  ,  STRUCT_INFO S,  PROJ_INFO       pri ,
                          BUDGET     budg  ,  BUDGET     budg1 , CONSOMME conso   ,     RESSOURCE       r   ,  CLIENT_MO  cm
                          WHERE
                          lb.icpi    = pri.icpi  AND S.codsg= lb.codsg  AND lb.clicode = cm.clicode
                          AND lb.pcpi    = r.ident AND lb.pid = budg.pid  (+)   AND lb.pid = conso.pid (+)
                          AND lb.pid = budg1.pid (+)
                          AND lb.typproj!=9
                          AND lb.typproj!=7
                          AND trim(lb.METIER) !=  ( 'FOR' )
                          AND (   (  conso.cusag     <> 0 AND   conso.cusag    IS NOT NULL ) OR ( budg.reestime  <> 0 AND  budg.reestime IS NOT NULL )
                          OR ( budg.bpmontme     <> 0 AND  budg.bpmontme    IS NOT NULL )  OR ( budg.bnmont      <> 0 AND  budg.bnmont     IS NOT NULL )
                           OR ( budg.bpmontmo     <> 0 AND  budg.bpmontmo    IS NOT NULL )  OR (budg.anmont      <> 0 AND budg.anmont     IS NOT NULL )
                          OR (budg1.bpmontme     <> 0 AND budg1.bpmontme    IS NOT NULL)  OR (budg1.bpmontmo     <> 0 AND budg1.bpmontmo    IS NOT NULL)
                           )
                           AND budg.annee(+) = c_annee
                           AND budg1.annee(+) = (c_annee+1)
                             AND conso.annee(+) = c_annee;


                        --------------------------------------------------------------------------------------------------
                        -- requête quasiment identique pour Etat : par client avec sous traitance
                        -- condition sur clause WHERE : CODSG
                        --------------------------------------------------------------------------------------------------
                        CURSOR curseur_requete_sst_codsg(c_annee NUMBER, p_param6 VARCHAR2) IS SELECT  DISTINCT
                                lb.pid PID   ,
                             lb.codsg codsg,
                             --budg.annee  annee,
                             c_annee annee,
                             lb.METIER METIER ,
                             NVL(conso.cusag,0)                 CONSOJH,
                             NVL(budg.reestime,0)      REESTJH,
                             NVL(budg.bpmontme,0)         PROPOJH,
                             NVL(budg.bnmont,0)                 NOTIFJH,
                             NVL(budg.bpmontmo,0)        PROPOMOJH,
                             NVL(budg.anmont,0)                ARBITJH,
                             NVL(budg1.bpmontme,0)        PROPOJH1,
                             NVL(budg1.bpmontmo,0)        PROPOMOJH1  ,
                             pro.PCPI ,
                             pro.PID PROPID
                          FROM  LIGNE_BIP       lb  ,
                                  PROPLUS pro,
                                  STRUCT_INFO S,
                                 STRUCT_INFO S2,
                                   PROJ_INFO       pri ,
                                    BUDGET     budg  ,
                                    BUDGET     budg1 ,
                                     CONSOMME conso   ,
                                      RESSOURCE       r   ,
                                       RESSOURCE       r2   ,
                                       CLIENT_MO       cm
                        WHERE  lb.icpi    = pri.icpi
                               AND S.codsg= lb.codsg
                               AND lb.pid=pro.factpid(+)
                               AND TO_CHAR(pro.cdeb(+),'yyyy') = TO_CHAR(c_annee)
                               AND pro.pcpi=r2.ident(+)
                               AND S2.codsg(+)= pro.pdsg
                               AND lb.clicode = cm.clicode
                               AND lb.pcpi    = r.ident
                               AND lb.pid = budg.pid  (+)
                               AND lb.pid = conso.pid   (+)
                               AND lb.pid = budg1.pid (+)
                               AND lb.typproj!=9
                               AND (   (  conso.cusag     <> 0 AND   conso.cusag    IS NOT NULL )
                                    OR ( budg.reestime  <> 0 AND  budg.reestime IS NOT NULL )
                                    OR ( budg.bpmontme     <> 0 AND  budg.bpmontme    IS NOT NULL )
                                    OR ( budg.bnmont      <> 0 AND  budg.bnmont     IS NOT NULL )
                                    OR ( budg.bpmontmo     <> 0 AND  budg.bpmontmo    IS NOT NULL )
                                    OR (budg.anmont      <> 0 AND budg.anmont     IS NOT NULL )
                                    OR (budg1.bpmontme     <> 0 AND budg1.bpmontme    IS NOT NULL)
                                    OR (budg1.bpmontmo     <> 0 AND budg1.bpmontmo    IS NOT NULL)
                                    )
                                AND budg.annee(+) = c_annee
                                AND budg1.annee(+) = (c_annee+1)
                                AND conso.annee(+) = c_annee
                                AND  TO_CHAR(lb.codsg, 'FM0000000')  LIKE  RTRIM(RTRIM(LPAD(p_param6, 7, '0'),'*')) || '%'
                                AND lb.codsg IN (SELECT codsg FROM vue_dpg_perime where INSTR(l_perim_me, codbddpg) > 0 );

                        CURSOR curseur_requete_sst_codsg_ref(c_annee NUMBER, p_param6 VARCHAR2) IS SELECT  DISTINCT
                                lb.pid PID   ,
                             lb.codsg codsg,
                             --budg.annee  annee,
                             c_annee annee,
                             lb.METIER METIER ,
                             NVL(conso.cusag,0)                 CONSOJH,
                             NVL(budg.reestime,0)      REESTJH,
                             NVL(budg.bpmontme,0)         PROPOJH,
                             NVL(budg.bnmont,0)                 NOTIFJH,
                             NVL(budg.bpmontmo,0)        PROPOMOJH,
                             NVL(budg.anmont,0)                ARBITJH,
                             NVL(budg1.bpmontme,0)        PROPOJH1,
                             NVL(budg1.bpmontmo,0)        PROPOMOJH1  ,
                             pro.PCPI ,
                             pro.PID PROPID
                          FROM  LIGNE_BIP       lb  ,
                                  PROPLUS pro,
                                  STRUCT_INFO S,
                                 STRUCT_INFO S2,
                                   PROJ_INFO       pri ,
                                    BUDGET     budg  ,
                                    BUDGET     budg1 ,
                                     CONSOMME conso   ,
                                      RESSOURCE       r   ,
                                       RESSOURCE       r2   ,
                                       CLIENT_MO       cm
                        WHERE  lb.icpi    = pri.icpi
                               AND S.codsg= lb.codsg
                               AND lb.pid=pro.factpid(+)
                               AND TO_CHAR(pro.cdeb(+),'yyyy') = TO_CHAR(c_annee)
                               AND pro.pcpi=r2.ident(+)
                               AND S2.codsg(+)= pro.pdsg
                               AND lb.clicode = cm.clicode
                               AND lb.pcpi    = r.ident
                               AND lb.pid = budg.pid  (+)
                               AND lb.pid = conso.pid   (+)
                               AND lb.pid = budg1.pid (+)
                               AND lb.typproj!=9
                               AND (   (  conso.cusag     <> 0 AND   conso.cusag    IS NOT NULL )
                                    OR ( budg.reestime  <> 0 AND  budg.reestime IS NOT NULL )
                                    OR ( budg.bpmontme     <> 0 AND  budg.bpmontme    IS NOT NULL )
                                    OR ( budg.bnmont      <> 0 AND  budg.bnmont     IS NOT NULL )
                                    OR ( budg.bpmontmo     <> 0 AND  budg.bpmontmo    IS NOT NULL )
                                    OR (budg.anmont      <> 0 AND budg.anmont     IS NOT NULL )
                                    OR (budg1.bpmontme     <> 0 AND budg1.bpmontme    IS NOT NULL)
                                    OR (budg1.bpmontmo     <> 0 AND budg1.bpmontmo    IS NOT NULL)
                                    )
                                AND budg.annee(+) = c_annee
                                AND budg1.annee(+) = (c_annee+1)
                                AND conso.annee(+) = c_annee;

     CURSOR curseur_temp_couts(l_num_seq_var NUMBER) IS SELECT * FROM TMP_COUTKE_ETATS
     WHERE NUMSEQ = l_num_seq_var;

    CURSOR c_lbl_branche(l_codsg NUMBER) IS
        SELECT d.CODBR, b.LIBBR  
            FROM STRUCT_INFO s ,DIRECTIONS d, BRANCHES b
            WHERE 1 = 1
                AND s.CODDIR = d.CODDIR
                AND b.CODBR = d.CODBR
                AND CODSG =  l_codsg  ;
    
    t_lbl_branche   c_lbl_branche%ROWTYPE;  
    l_menu  VARCHAR2(50);
             

BEGIN

    BEGIN
        nbrLigneInserer := 0;
        L_RETCOD := TRCLOG.INITTRCLOG( 'PL_LOGS' , 'insert_tmp_coutke_dmdlbip', L_HFILE );

        if ( L_RETCOD <> 0 ) then
            raise_application_error( TRCLOG_FAILED_ID,
                                  'Erreur : Gestion du fichier LOG impossible ',
                                   false );
        end if;

        l_perim_me := P_PERIME;
        l_menu := pack_global.LIRE_MENUTIL(p_global);  
               
        codsg_coutpardefaut :=  9999999 ;
        -- last_requete := ' and budg.annee(+) = 2007 and budg1.annee(+) = 2008 and conso.annee(+) = 2007 ';

        -- récupération d'un numéro de séquence
        -- les données générées par deux utilisateurs seront différenciées par le NUMSEQ
        SELECT BIP.SETATKE.NEXTVAL INTO l_num_seq FROM DUAL ;

        l_timestamp := SYSDATE ;

        --------------------------------------------------------------------------------------
        --  SI PAS ETAT PAR CLIENT AVEC SOUS TRAITANCE
        --------------------------------------------------------------------------------------
        IF (etat_sous_traitance IS NULL) THEN

            -- Dans le menu referentiel pas de filtre sur le perim me
            IF ( l_menu = 'REF' ) THEN       

                FOR curseur IN curseur_requete_ref( annee, p_param6)  LOOP
                          
                        INSERT INTO TMP_COUTKE_ETATS (
                             PID,
                             CODSG,
                             METIER ,
                             NUMSEQ ,

                             COUT_KE  ,
                             COUT_ANNEEPLUSUN_KE  ,
                             CONSOJH  ,
                             REESTJH ,
                             PROPOJH  ,
                             NOTIFJH ,
                             PROPOMOJH  ,
                             ARBITJH  ,
                             PROPOJH1  ,
                             PROPOMOJH1 ,

                             CONSO_KE  ,
                             REEST_KE  ,
                             PROPO_KE ,
                             NOTIF_KE ,
                             PROPOMO_KE  ,
                             ARBIT_KE  ,
                             PROPO_ANNEEPLUSUN_KE  ,
                             PROPOMO_ANNEEPLUSUN_KE ,
                             ANNEE ,
                             ANNEEPLUSUN  ,
                             RESTEAFAIREJH
                        )  VALUES  (
                                  curseur.PID  ,
                               curseur.codsg ,
                               curseur.METIER ,
                                l_num_seq  ,

                               0,
                               0,
                               curseur.CONSOJH  ,
                               curseur.REESTJH ,
                               curseur.PROPOJH  ,
                               curseur.NOTIFJH ,
                               curseur.PROPOMOJH  ,
                               curseur.ARBITJH  ,
                               curseur.PROPOJH1  ,
                               curseur.PROPOMOJH1 ,
                               0,
                               0,
                               0,
                               0,
                               0,
                               0,
                               0,
                               0,
                               curseur.annee,
                               (NVL(curseur.annee,0) + 1) , --annee_budg1,
                               0
                      );
                            

                END LOOP ;
                
            ELSE
                TRCLOG.TRCLOG(L_HFILE, 'Ouverture du cursseur curseur_requete');
                FOR curseur IN curseur_requete( annee, p_param6)  LOOP
                          
                    INSERT INTO TMP_COUTKE_ETATS (
                         PID,
                         CODSG,
                         METIER ,
                         NUMSEQ ,

                         COUT_KE  ,
                         COUT_ANNEEPLUSUN_KE  ,
                         CONSOJH  ,
                         REESTJH ,
                         PROPOJH  ,
                         NOTIFJH ,
                         PROPOMOJH  ,
                         ARBITJH  ,
                         PROPOJH1  ,
                         PROPOMOJH1 ,

                         CONSO_KE  ,
                         REEST_KE  ,
                         PROPO_KE ,
                         NOTIF_KE ,
                         PROPOMO_KE  ,
                         ARBIT_KE  ,
                         PROPO_ANNEEPLUSUN_KE  ,
                         PROPOMO_ANNEEPLUSUN_KE ,
                         ANNEE ,
                         ANNEEPLUSUN  ,
                         RESTEAFAIREJH
                    )  VALUES  (
                              curseur.PID  ,
                           curseur.codsg ,
                           curseur.METIER ,
                            l_num_seq  ,

                           0,
                           0,
                           curseur.CONSOJH  ,
                           curseur.REESTJH ,
                           curseur.PROPOJH  ,
                           curseur.NOTIFJH ,
                           curseur.PROPOMOJH  ,
                           curseur.ARBITJH  ,
                           curseur.PROPOJH1  ,
                           curseur.PROPOMOJH1 ,
                           0,
                           0,
                           0,
                           0,
                           0,
                           0,
                           0,
                           0,
                           curseur.annee,
                           (NVL(curseur.annee,0) + 1) , --annee_budg1,
                           0
                  );
                  nbrLigneInserer := nbrLigneInserer + 1;
              END LOOP ;
              TRCLOG.TRCLOG(L_HFILE, 'Nombre de ligne inserer depuis le cursseur curseur_requete: ' || nbrLigneInserer);
            END IF;

        --------------------------------------------------------------------------------------
        --  SI  ETAT PAR CLIENT AVEC SOUS TRAITANCE
        --------------------------------------------------------------------------------------
        ELSE

            --------------------------------------------------------------------------------------
            --  SI  DEPUIS ECRAN MENSUELLE
            --------------------------------------------------------------------------------------
            IF(ecran_isac IS NULL) THEN
            
                -- Dans le menu referentiel pas de filtre sur le perim me
                IF ( l_menu = 'REF' ) THEN 

                    FOR curseur IN curseur_requete_sst_codsg_ref( annee, p_param6)  LOOP
                             INSERT INTO TMP_COUTKE_ETATS (
                                  PID,
                                  CODSG,
                                  METIER ,
                                  NUMSEQ ,
                                  COUT_KE  ,
                                  COUT_ANNEEPLUSUN_KE  ,
                                  CONSOJH  ,
                                  REESTJH ,
                                  PROPOJH  ,
                                  NOTIFJH ,
                                  PROPOMOJH  ,
                                  ARBITJH  ,
                                  PROPOJH1  ,
                                  PROPOMOJH1 ,
                                  CONSO_KE  ,
                                  REEST_KE  ,
                                  PROPO_KE ,
                                  NOTIF_KE ,
                                  PROPOMO_KE  ,
                                  ARBIT_KE  ,
                                  PROPO_ANNEEPLUSUN_KE  ,
                                  PROPOMO_ANNEEPLUSUN_KE ,
                                  ANNEE ,
                                  ANNEEPLUSUN  ,
                                  RESTEAFAIREJH ,
                                  PROCONSOJH ,
                                  PROCONSO_KE   ,
                                  PCPI ,
                                  PID_PROPLUS
                             )  VALUES   (
                                    curseur.PID  ,
                                    curseur.codsg ,
                                    curseur.METIER ,
                                    l_num_seq  ,
                                    0,
                                    0,
                                    curseur.CONSOJH  ,
                                    curseur.REESTJH ,
                                    curseur.PROPOJH  ,
                                    curseur.NOTIFJH ,
                                    curseur.PROPOMOJH  ,
                                    curseur.ARBITJH  ,
                                    curseur.PROPOJH1  ,
                                    curseur.PROPOMOJH1 ,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    curseur.annee,
                                    (NVL(curseur.annee,0) + 1), -- annee_budg1,
                                    0  ,  -- reste a faire
                                    0, -- curseur.PROCONSOJH ,
                                    0,     --  PROCONSO_KE ,
                                    curseur.PCPI ,
                                    curseur.PROPID

                           );

                    END LOOP ;
                 
                ELSE

                    FOR curseur IN curseur_requete_sst_codsg( annee, p_param6)  LOOP
                    
                     
                             INSERT INTO TMP_COUTKE_ETATS (
                                  PID,
                                  CODSG,
                                  METIER ,
                                  NUMSEQ ,
                                  COUT_KE  ,
                                  COUT_ANNEEPLUSUN_KE  ,
                                  CONSOJH  ,
                                  REESTJH ,
                                  PROPOJH  ,
                                  NOTIFJH ,
                                  PROPOMOJH  ,
                                  ARBITJH  ,
                                  PROPOJH1  ,
                                  PROPOMOJH1 ,
                                  CONSO_KE  ,
                                  REEST_KE  ,
                                  PROPO_KE ,
                                  NOTIF_KE ,
                                  PROPOMO_KE  ,
                                  ARBIT_KE  ,
                                  PROPO_ANNEEPLUSUN_KE  ,
                                  PROPOMO_ANNEEPLUSUN_KE ,
                                  ANNEE ,
                                  ANNEEPLUSUN  ,
                                  RESTEAFAIREJH ,
                                  PROCONSOJH ,
                                  PROCONSO_KE   ,
                                  PCPI ,
                                  PID_PROPLUS
                             )  VALUES   (
                                    curseur.PID  ,
                                    curseur.codsg ,
                                    curseur.METIER ,
                                    l_num_seq  ,
                                    0,
                                    0,
                                    curseur.CONSOJH  ,
                                    curseur.REESTJH ,
                                    curseur.PROPOJH  ,
                                    curseur.NOTIFJH ,
                                    curseur.PROPOMOJH  ,
                                    curseur.ARBITJH  ,
                                    curseur.PROPOJH1  ,
                                    curseur.PROPOMOJH1 ,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    curseur.annee,
                                    (NVL(curseur.annee,0) + 1), -- annee_budg1,
                                    0  ,  -- reste a faire
                                    0, -- curseur.PROCONSOJH ,
                                    0,     --  PROCONSO_KE ,
                                    curseur.PCPI ,
                                    curseur.PROPID

                           );

                    END LOOP ;
                                     
                END IF;
                 

            END IF ;
            
        END IF ;

               --------------------------------------------------------------------------------------------------------
                  -- ETAPE 2 : Recherche cout standard en KE ANNEE et cout standard en KE ANNEE + 1 pour chaque ligne BIP
               --------------------------------------------------------------------------------------------------------

                -----------------------------------------------------------------------------------------------
                -- MAJ table temporaire TMP_COUTKE_ETATS ANNEE N
                -----------------------------------------------------------------------------------------------
                TRCLOG.TRCLOG(L_HFILE, 'Début du traitement des lignes depuis la table TMP');
                FOR curseurTemp IN  curseur_temp_couts(l_num_seq) LOOP

                        --  RECHERCHE COUT STANDARD ANNEE  POUR LA LIGNE BIP ACTUELLE DU CURSEUR
                        --  LIGNE BIP:CODSG
                        --  LIGNE BIP:METIER
                        --  LIGNE BIP:ANNEE
                        --  Le coût standard est récupéré dans la table COUT_STD_KE
                        --  cette table fournit un cout standard pour chaque : CODSG, METIER,ANNEE donnés
                       --  Si l'année est supérieur à 2009 on utilise le type de la ligne bip pour determiner quel cout on doit utiliser (GT1 ou autre)
                        indiceRequete := 0;
                        l_cout_ke := 0 ;
                        l_flag_anomalie_detectee  := 0 ;


                        -- Recherche type de ligne (T1 ou autres)
                        indiceRequete := 1;
                        select arctype into type_ligne_bip from ligne_bip where pid = curseurTemp.pid;

                        IF(  curseurTemp.annee  IS NOT NULL AND LENGTH(curseurTemp.annee)>0  ) THEN

                              IF (curseurTemp.annee > 2009) THEN
                                  IF (type_ligne_bip = 'T1') THEN
                                    type_ligne_bip := 'GT1';
                                  ELSE
                                    type_ligne_bip := 'AUTRE';
                                  END IF;
                              ELSE
                                 type_ligne_bip := 'TOUT';
                              END IF;

                              l_count := 0 ;
                              indiceRequete := 2;
                              SELECT COUNT(*) INTO l_count  FROM  COUT_STD_KE cout  WHERE
                                                cout.annee = curseurTemp.annee
                                                AND cout.dpg_bas<=curseurTemp.codsg
                                                AND cout.dpg_haut>=curseurTemp.codsg
                                                AND cout.dpg_haut != codsg_coutpardefaut
                                                AND cout.dpg_bas != codsg_coutpardefaut
                                                AND trim(cout.METIER) = trim(curseurTemp.METIER)
                                                AND TYPE_LIGNE = type_ligne_bip  ;

                                     -- Gestion de récupération du cout standard en KE
                                     -- si anomalie : ramène le cout par défaut (CODSG = 9999999)
                                     IF(l_count=1) THEN
                                           -- Via ANNEE,CODSG,METIER lecture cout standard en KE table COUT_STD_KE
                                           indiceRequete := 3;
                                           SELECT DISTINCT cout.cout INTO l_cout_ke FROM  COUT_STD_KE cout
                                           WHERE  cout.annee = curseurTemp.annee
                                            AND cout.dpg_bas<=curseurTemp.codsg  AND cout.dpg_haut>=curseurTemp.codsg
                                            AND cout.dpg_haut != codsg_coutpardefaut
                                            AND trim(cout.METIER)  = trim(curseurTemp.METIER)  AND ROWNUM <=1
                                            AND TYPE_LIGNE = type_ligne_bip  ;

                                           --ecriture dans table Anomalies
                                           IF(l_cout_ke=0)THEN
                                             l_flag_anomalie_detectee := 1 ;
                                             --OPEN c_lbl_branche(curseurTemp.codsg);
                                             --FETCH c_lbl_branche INTO t_lbl_branche;
                                             --CLOSE c_lbl_branche;
                                             --l_anomalie := 'Le coût du métier est à 0';
                                             --l_retour := creer_anomalie_coutstdKE( curseurTemp.annee, curseurTemp.codsg,
                                              --              curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                              --              t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                             
                                           END IF ;
                                      END IF ;

                                    --ecriture dans table Anomalies
                                    IF(l_count=0 OR l_count>1) THEN
                                           l_flag_anomalie_detectee := 1 ;
                                           
                                           /*
                                           IF(l_count=0) THEN
                                             l_anomalie := 'Pas de poste dans la table pour ce critère';
                                             OPEN c_lbl_branche(curseurTemp.codsg);
                                             FETCH c_lbl_branche INTO t_lbl_branche;
                                             CLOSE c_lbl_branche;                            
                                             l_retour := creer_anomalie_coutstdKE( curseurTemp.annee, curseurTemp.codsg,
                                                     curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                                     t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                           END IF ;
                                           IF(l_count>1) THEN
                                             l_anomalie := 'Plusieurs postes dans la table pour ce critère';
                                             OPEN c_lbl_branche(curseurTemp.codsg);
                                             FETCH c_lbl_branche INTO t_lbl_branche;
                                             CLOSE c_lbl_branche;
                                             l_retour := creer_anomalie_coutstdKE( curseurTemp.annee, curseurTemp.codsg,
                                                     curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                                     t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                           END IF ;
                                             */
                                             
                                      END IF ;

                                     -- Anomalie : Recherche cout par défaut via ANNEE,CODSG= 9999999 ,
                                     --            METIER  lecture cout standard par défaut en KE table COUT_STD_KE
                                     IF(l_flag_anomalie_detectee = 1) THEN
                                            indiceRequete := 4;
                                            SELECT cout.cout INTO l_cout_ke  FROM  COUT_STD_KE cout WHERE
                                            cout.annee = curseurTemp.annee AND cout.dpg_haut= codsg_coutpardefaut
                                            AND trim(cout.METIER)  = trim(curseurTemp.METIER)
                                            AND TYPE_LIGNE = type_ligne_bip AND ROWNUM <=1 ;
                                     END IF ;

                                     -- MAJ COUT STANDARD pour la ligne BIP avec
                                     -- LIGNE BIP PID
                                     -- LIGNE BIP CODSG
                                       -- LIGNE BIP METIER
                                      indiceRequete := 5;
                                      UPDATE TMP_COUTKE_ETATS SET COUT_KE = l_cout_ke WHERE
                                                                      TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                                                      AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                      trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                        TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                      AND curseurTemp.NUMSEQ = l_num_seq ;


                            END IF ;


                             -------------------------------------------------------------------------------------
                             --  RECHERCHE COUT STANDARD ANNEE + 1 POUR LA MEME LIGNE BIP
                             -------------------------------------------------------------------------------------
                             --  Le coût standard est récupéré dans la table COUT_STD_KE
                             --  cette table fournit un cout standard pour chaque : CODSG, METIER,ANNEE + 1 donnés
                             --  Si l'année est supérieur à 2009 on utilise le type de la ligne bip pour determiner quel cout on doit utiliser (GT1 ou autre)

                             indiceRequete := 6;
                             select arctype into type_ligne_bip from ligne_bip where pid = curseurTemp.pid;

                             l_cout_anneeplusun_ke := 0 ;
                             l_flag_anomalie_detectee  := 0 ;
                             IF( (curseurTemp.ANNEEPLUSUN IS NOT NULL) AND (LENGTH(curseurTemp.ANNEEPLUSUN)>0) AND
                                (curseurTemp.annee  IS NOT NULL) AND (LENGTH(curseurTemp.annee)>0) )  THEN
                                  l_count := 0 ;

                                   IF (curseurTemp.ANNEEPLUSUN > 2009) THEN
                                        IF (type_ligne_bip = 'T1') THEN
                                            type_ligne_bip := 'GT1';
                                        ELSE
                                            type_ligne_bip := 'AUTRE';
                                        END IF;
                                  ELSE
                                        type_ligne_bip := 'TOUT';
                                  END IF;



                                   indiceRequete := 7;
                                   SELECT COUNT(*) INTO l_count  FROM  COUT_STD_KE cout  WHERE
                                                cout.annee = curseurTemp.ANNEEPLUSUN
                                                AND cout.dpg_bas<=curseurTemp.codsg
                                                AND cout.dpg_haut>=curseurTemp.codsg
                                                AND cout.dpg_haut != codsg_coutpardefaut
                                                AND cout.dpg_bas != codsg_coutpardefaut
                                                AND trim(cout.METIER) = trim(curseurTemp.METIER)
                                                AND TYPE_LIGNE = type_ligne_bip    ;

                                     IF(l_count=1) THEN
                                           -- Via ANNEE + 1 ,CODSG,METIER lecture cout standard en KE table COUT_STD_KE
                                           indiceRequete := 8;
                                           SELECT DISTINCT cout.cout INTO l_cout_anneeplusun_ke FROM  COUT_STD_KE cout
                                           WHERE  cout.annee = curseurTemp.ANNEEPLUSUN
                                            AND cout.dpg_bas<=curseurTemp.codsg
                                            AND cout.dpg_haut>=curseurTemp.codsg
                                            AND cout.dpg_haut != codsg_coutpardefaut
                                           AND trim(cout.METIER)  = trim(curseurTemp.METIER)
                                           AND TYPE_LIGNE = type_ligne_bip AND ROWNUM <=1  ;
                                           --ecriture dans table Anomalies
                                           IF(l_cout_anneeplusun_ke =0)THEN
                                             l_flag_anomalie_detectee := 1 ;
                                             /*
                                             l_anomalie := 'Le coût du métier est à 0';
                                             OPEN c_lbl_branche(curseurTemp.codsg);
                                             FETCH c_lbl_branche INTO t_lbl_branche;
                                             CLOSE c_lbl_branche;
                                               l_retour := creer_anomalie_coutstdKE( curseurTemp.ANNEEPLUSUN, curseurTemp.codsg,
                                                      curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                                      t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                               */
                                           END IF ;
                                     END IF ;

                                     IF(l_count=0 OR l_count>1) THEN
                                           l_flag_anomalie_detectee := 1 ;
                                          /* 
                                            IF(l_count=0) THEN
                                             l_anomalie := 'Pas de poste dans la table pour ce critère';
                                             OPEN c_lbl_branche(curseurTemp.codsg);
                                             FETCH c_lbl_branche INTO t_lbl_branche;
                                             CLOSE c_lbl_branche;
                                               l_retour := creer_anomalie_coutstdKE( curseurTemp.ANNEEPLUSUN, curseurTemp.codsg,
                                                  curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                                  t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                           END IF ;
                                           IF(l_count>1) THEN
                                             l_anomalie := 'Plusieurs postes dans la table pour ce critère';
                                             OPEN c_lbl_branche(curseurTemp.codsg);
                                             FETCH c_lbl_branche INTO t_lbl_branche;
                                             CLOSE c_lbl_branche;
                                                     l_retour := creer_anomalie_coutstdKE( curseurTemp.ANNEEPLUSUN, curseurTemp.codsg,
                                                       curseurTemp.METIER, curseurTemp.pid , l_anomalie, matricule ,
                                                      t_lbl_branche.CODBR , t_lbl_branche.LIBBR , l_timestamp,type_ligne_bip);
                                           END IF ;
                                           */
                                    END IF ;

                                     -- Anomalie : Recherche cout par défaut via ANNEE + 1 ,CODSG= 9999999
                                     IF(l_flag_anomalie_detectee = 1) THEN
										BEGIN
                                           indiceRequete := 9;
                                           SELECT cout.cout INTO l_cout_anneeplusun_ke  FROM  COUT_STD_KE cout WHERE
                                           cout.annee = curseurTemp.ANNEEPLUSUN
                                           AND cout.dpg_haut= codsg_coutpardefaut
                                           AND trim(cout.METIER)  = trim(curseurTemp.METIER)
                                           AND TYPE_LIGNE = type_ligne_bip AND ROWNUM <=1 ;
										EXCEPTION WHEN OTHERS THEN
											NULL;
										END;	
                                     END IF ;

                                     -- MAJ COUT STANDARD pour la ligne BIP avec
                                     -- LIGNE BIP PID
                                     -- LIGNE BIP CODSG
                                       -- LIGNE BIP METIER
                                      indiceRequete := 10;
                                      UPDATE TMP_COUTKE_ETATS SET COUT_ANNEEPLUSUN_KE = l_cout_anneeplusun_ke WHERE
                                                                      TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                                                      AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                      trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                        TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                      AND curseurTemp.NUMSEQ = l_num_seq ;


                             END IF ;

                             -- LES 2 COUTS STANDARD EN KE  (ANNEE et ANNEE +1 )  ont été trouvés pour chaque ligne BIP
                            -- COUT en KE pour : ANNEE  ligne BIP , METIER ligne BIP  , CODSG  ligne BIP
                            -- COUT en KE pour : ANNEE +1 ligne BIP , METIER ligne BIP  , CODSG  ligne BIP

                            -- La table TMP_COUTKE_ETATS contient donc toutes les lignes BIP
                            -- avec les 2 coûts en KE (cout  année et cout année + 1)
                            -- Cette table temporaire contient également les consommés en JH
                            -- qui servaient l'Etat PCA4 , ces JH vont simplement être multipliés
                            -- par le coût en KE afin obtenir un Etat PCA4 en KE



                            ---------------------------------------------------------------------
                            -- ETAPE 3 : calcul des champs simple (nombre JH lu * cout en KE)
                            ---------------------------------------------------------------------

                            -- Update montants ANNEE via cout standard ANNEE

                            indiceRequete := 11;
                            UPDATE TMP_COUTKE_ETATS SET
							 --FAD : Correction QC 1853
							 PROPO_KE = ROUND((PROPOJH * l_cout_ke)/1000,2) ,
                              NOTIF_KE = ROUND((NOTIFJH * l_cout_ke)/1000,2),
                               PROPOMO_KE = ROUND((PROPOMOJH * l_cout_ke)/1000,2),
                                ARBIT_KE = ROUND((ARBITJH * l_cout_ke)/1000,2),
							    PROPO_ANNEEPLUSUN_KE = ROUND((PROPOJH1 * l_cout_anneeplusun_ke)/1000,0),
                                  PROPOMO_ANNEEPLUSUN_KE = ROUND((PROPOMOJH1 * l_cout_anneeplusun_ke)/1000,0)
                                   WHERE
                                   TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                     AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg
                                      AND trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER)
                                       AND TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                        AND curseurTemp.NUMSEQ = l_num_seq ;



                                   -- Etape b) La formule de calcul du consommé est inapliccableà la
                                   -- sous traitance:  on l'affiche à BLANC
                                   IF(etat_sous_traitance IS NOT NULL) THEN


                                      indiceRequete := 12;
                                      UPDATE TMP_COUTKE_ETATS SET
                                           PROCONSO_KE = 0
                                               WHERE
                                                TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                                 AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg
                                                  AND trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER)
                                                   AND TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                    AND curseurTemp.NUMSEQ = l_num_seq   ;

                                    END IF ;


                            ---------------------------------------------------------------------------
                            -- ETAPE 4 : calculs complexes Consommé et Ré-estimé (voir spécifications)
                            ---------------------------------------------------------------------------

                                      --------------------------------
                                      -- ETAPE 4.1 : calcul CONSOMME
                                      --------------------------------
                                      l_count := 0 ;
                                      l_cout_consomme := 0 ;
                                      l_cout_consomme_nonarrondi :=0 ;
                                      indiceRequete := 13;
                                      SELECT COUNT(*) INTO   l_count  FROM SYNTHESE_ACTIVITE synth
                                                  WHERE synth.pid = curseurTemp.pid AND synth.annee = curseurTemp.annee  AND trim(synth.METIER) = trim(curseurTemp.METIER)  ;
                                      IF(  l_count > 0 )THEN
                                                    indiceRequete := 14;
                                                    SELECT  (  ( NVL(synth.CONSOFT_SG,0) + NVL(synth.CONSOFT_SSII,0) + NVL(synth.CONSOENV_SG,0) + NVL(synth.CONSOENV_SSII,0)  ) /1000  ) INTO  l_cout_consomme_nonarrondi
                                                    FROM SYNTHESE_ACTIVITE synth  WHERE  synth.pid  =  curseurTemp.pid  AND synth.annee = curseurTemp.annee AND trim(synth.METIER)  =  trim(curseurTemp.METIER) ;
                                                    --FAD : Correction QC 1853
													l_cout_consomme := ROUND(l_cout_consomme_nonarrondi,2) ;
                                      END IF ;

                                      indiceRequete := 15;
                                      UPDATE TMP_COUTKE_ETATS SET CONSO_KE = l_cout_consomme WHERE
                                                         TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                                         AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                         trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                         TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                         AND curseurTemp.NUMSEQ = l_num_seq ;

                                      --------------------------------
                                      -- ETAPE 4.1 : calcul REESTIME
                                      --------------------------------
                                      IF ( curseurTemp.CONSOJH = 0 ) THEN
                                             -- Si le consommé en jh est  = 0 alors :
                                              -- coût en k¿ du ré estimé =  (ré estimé en jh * coût)/1000
                                           indiceRequete := 16;
                                           UPDATE TMP_COUTKE_ETATS  SET  REEST_KE  =    ROUND(  (  NVL( curseurTemp.REESTJH,0) *  l_cout_ke   )/1000 , 2  )
                                                              WHERE
                                                                 TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                                 TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                 trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                 TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                 AND curseurTemp.NUMSEQ = l_num_seq ;
                                        ELSE
                                             -- CALCUL DU RESTE A FAIRE : Si le consommé  est > 0  : Ràf JH = ré estimé JH ¿ consommé JH
                                             l_resteafaire := curseurTemp.reestjh - curseurTemp.consojh ;

                                              --Si le ràf est = 0 :Coût en k¿ du ré estimé  =  coût en k¿ du consommé
                                             IF (l_resteafaire  = 0) THEN
                                                 indiceRequete := 17;
                                                 UPDATE TMP_COUTKE_ETATS  SET  REEST_KE  =  l_cout_consomme
                                                            WHERE   TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                            TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                            trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                            TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                            AND curseurTemp.NUMSEQ = l_num_seq ;
                                             ELSE
                                               -- CALCUL COUT CONSTATE (non arrondi en KE): Si le reste à faire est différent de 0
                                               -- Coût constaté  = cout consommé calculé / consommé en JH
                                                    l_cout_constate_non_arrondi :=  ( l_cout_consomme_nonarrondi / curseurTemp.consojh)   ;
                                             END IF ;

                                             IF (l_resteafaire  >0  ) THEN
                                                     -- Si ràf est >0, alors le montant en kE du ré estimé se calcule ainsi :
                                                     -- Coût en kE du ré estimé  =  coût en kEdu consommé + (ràf JH * coût constaté)/1000
                                                     indiceRequete := 18;
                                                     UPDATE TMP_COUTKE_ETATS  SET  REEST_KE = ROUND(( l_cout_consomme_nonarrondi +    (  l_cout_constate_non_arrondi * NVL(l_resteafaire,0))),2)
                                                                                     WHERE
                                                                                     TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                                                     TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                                     trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                                     TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                                     AND curseurTemp.NUMSEQ = l_num_seq ;
                                             END IF;

                                             IF (l_resteafaire  < 0 ) THEN
                                                      --Si ràf est < 0, alors le montant en KE du ré estimé se calcule ainsi :
                                                     --Coût en KE du ré estimé  =  Coût constaté  * ré-estimés en JH
                                                     indiceRequete := 19;
                                                     UPDATE TMP_COUTKE_ETATS  SET  REEST_KE  = ROUND(  ( l_cout_constate_non_arrondi * NVL(curseurTemp.REESTJH ,0) ),2)
                                                           WHERE    TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                                    TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                    trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                    TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                    AND curseurTemp.NUMSEQ = l_num_seq ;
                                            END IF ;

                                --------- Fin Calcul réestimé  ----------
                                END IF ;



                END LOOP ;

                COMMIT ;


      END ;
      
      TRCLOG.CLOSETRCLOG( L_HFILE );
     
     RETURN  l_num_seq ;


EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        TRCLOG.TRCLOG(L_HFILE, 'Exception dans la requête ' || indiceRequete);
        indiceRequete := 19;
        TRCLOG.CLOSETRCLOG( L_HFILE );
        --ROLLBACK;
         Pack_Global.recuperer_message(20370, NULL, NULL, NULL, p_message);
        RAISE_APPLICATION_ERROR( -20370, p_message );
        
   WHEN NO_DATA_FOUND THEN
          TRCLOG.TRCLOG(L_HFILE, 'Exception dans la requête ' || indiceRequete);
          TRCLOG.CLOSETRCLOG( L_HFILE );
          RETURN l_num_seq;

     WHEN OTHERS THEN
        --ROLLBACK;
        TRCLOG.TRCLOG(L_HFILE, 'Exception dans la requête ' || indiceRequete || ' - ' || SQLERRM);
        TRCLOG.CLOSETRCLOG( L_HFILE );
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END insert_tmp_coutke_dmdlbip;

/************************************************************************************/
/*                                                                                  */
/*    INSERTION TABLE TEMPORAIRE POUR EDITION ETATS EN KE                           */
/*       (MET A PLAT LES DONNEES PAR METIER POUR CHAQUE TRANCHE DE DPG)                                                                                          */
/*                                                                                  */
/************************************************************************************/
FUNCTION insert_tmp_edition_etatke(
                                       p_couann        IN  VARCHAR2
                                     ) RETURN NUMBER   IS


     p_message VARCHAR(1024);

     l_msg VARCHAR(1024);

     l_dpg_bas NUMBER(7) ;

     l_num_seq NUMBER(20);

      libelle_four VARCHAR2(50);
      nombre_four NUMBER;

    CURSOR curseur_coutke_edition  IS SELECT  DISTINCT
                                cout.dpg_haut  DPHAUT ,
                             cout.dpg_bas   DPBAS  ,
                             annee ANNEE,

                                                         CODE_FOUR_COPI fourCopi,
                                                         type_ligne
                            -- cout.METIER    METIER,
                            -- cout.cout      COUT
                          FROM  COUT_STD_KE cout
                          WHERE  cout.annee IS NOT NULL AND  cout.annee =  TO_NUMBER(p_couann) ;

    CURSOR curseur_ckeed_sansannee IS SELECT  DISTINCT
                                cout.dpg_haut  DPHAUT ,
                             cout.dpg_bas   DPBAS  ,
                             annee ANNEE,

                                                         CODE_FOUR_COPI fourCopi,
                                                         type_ligne
                            -- cout.METIER    METIER,
                            -- cout.cout      COUT
                          FROM  COUT_STD_KE cout  ;


    CURSOR curseur_coutke  IS SELECT  *
                          FROM  COUT_STD_KE cout
                          WHERE  cout.annee IS NOT NULL AND cout.annee =  TO_NUMBER(p_couann) ;

     CURSOR curseur_cke_sansannee IS SELECT  *
                          FROM  COUT_STD_KE cout  ;


BEGIN



         BEGIN





                   SELECT  BIP.SETATKE.NEXTVAL INTO l_num_seq FROM DUAL ;

                   -- On distingue les deux cas où l'année est NULLE et NON NULLE
                   -- suivant les cas on utilisera les curseurs adéquats
                   IF(p_couann IS NULL OR LENGTH(p_couann)<=0) THEN
                                 FOR curseur IN curseur_ckeed_sansannee   LOOP

                                                   select count(*) into nombre_four FROM COPI_FOUR WHERE CODE_FOUR_COPI = curseur.fourCopi;
                                                   if(nombre_four>0)THEN
                                                   SELECT To_CHAR(CODE_FOUR_COPI)||'-'|| LIBELLE_FOUR_COPI  into  libelle_four FROM COPI_FOUR WHERE CODE_FOUR_COPI = curseur.fourCopi;
                                                   ELSE
                                                   libelle_four:='';
                                                   END IF ;

                               INSERT INTO TMP_COUTKE_EDITION (NUMSEQ,DPG_HAUT,DPG_BAS,ANNEE,CODE_FOUR_COPI,LIBELLE_FOUR_COPI,type_ligne)
                                 VALUES(l_num_seq,curseur.DPHAUT,curseur.DPBAS,curseur.ANNEE,curseur.fourCopi,libelle_four,curseur.type_ligne);

                                  END LOOP ;
                               FOR curseur  IN curseur_cke_sansannee  LOOP
                                        IF (curseur.METIER='ME')THEN
                                            UPDATE TMP_COUTKE_EDITION SET ME = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                               AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='MO')THEN
                                            UPDATE TMP_COUTKE_EDITION SET MO = curseur.cout WHERE
                                              TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                              AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='HOM')THEN
                                            UPDATE TMP_COUTKE_EDITION SET HOM = curseur.cout WHERE
                                              TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                              AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='GAP')THEN
                                            UPDATE TMP_COUTKE_EDITION SET GAP = curseur.cout WHERE
                                              TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                              AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='EXP')THEN
                                            UPDATE TMP_COUTKE_EDITION SET EXP = curseur.cout WHERE
                                              TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                              AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                         IF (curseur.METIER='SAU')THEN
                                            UPDATE TMP_COUTKE_EDITION SET SAU = curseur.cout WHERE
                                              TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                              AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                   END LOOP ;

                   ELSE
                                      FOR curseur IN curseur_coutke_edition   LOOP

                                                             select count(*) into nombre_four FROM COPI_FOUR WHERE CODE_FOUR_COPI = curseur.fourCopi;
                                                             if(nombre_four>0)THEN
                                                             SELECT To_CHAR(CODE_FOUR_COPI)||'-'|| LIBELLE_FOUR_COPI into libelle_four FROM COPI_FOUR WHERE CODE_FOUR_COPI = curseur.fourCopi;
                                                             ELSE
                                                             libelle_four:='';
                                                             END IF ;

                                INSERT INTO TMP_COUTKE_EDITION (NUMSEQ,DPG_HAUT,DPG_BAS,ANNEE,CODE_FOUR_COPI,LIBELLE_FOUR_COPI,type_ligne)
                                  VALUES(l_num_seq,curseur.DPHAUT,curseur.DPBAS,curseur.ANNEE,curseur.fourCopi,libelle_four,curseur.type_ligne) ;
                                   END LOOP ;

                                FOR curseur  IN curseur_coutke   LOOP
                                        IF (curseur.METIER='ME')THEN
                                            UPDATE TMP_COUTKE_EDITION SET ME = curseur.cout WHERE
                                              TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                              AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='MO')THEN
                                            UPDATE TMP_COUTKE_EDITION SET MO = curseur.cout WHERE
                                              TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                              AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='HOM')THEN
                                            UPDATE TMP_COUTKE_EDITION SET HOM = curseur.cout WHERE
                                              TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                              AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='GAP')THEN
                                            UPDATE TMP_COUTKE_EDITION SET GAP = curseur.cout WHERE
                                              TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                              AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='EXP')THEN
                                            UPDATE TMP_COUTKE_EDITION SET EXP = curseur.cout WHERE
                                              TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                              AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                         IF (curseur.METIER='SAU')THEN
                                            UPDATE TMP_COUTKE_EDITION SET SAU = curseur.cout WHERE
                                              TMP_COUTKE_EDITION.NUMSEQ  = l_num_seq AND
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              AND TMP_COUTKE_EDITION.ANNEE = curseur.ANNEE
                                              AND TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                   END LOOP ;

                   END IF ;




                   COMMIT ;

                     RETURN  l_num_seq ;

         END;





EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
         Pack_Global.recuperer_message(20370, NULL, NULL, NULL, p_message);
        RAISE_APPLICATION_ERROR( -20370, p_message );

     WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END insert_tmp_edition_etatke;




/************************************************************************************/
/*                                                                                  */
/*    INSERTION TABLE TEMPORAIRE POUR EDITION ETATS EN KE                           */
/*       (MET A PLAT LES DONNEES PAR METIER POUR CHAQUE TRANCHE DE DPG)                                                                                          */
/*                                                                                  */
/************************************************************************************/
FUNCTION liste_anomalies(
                                    p_couann        IN  VARCHAR2
                                     ) RETURN NUMBER   IS


     p_message VARCHAR(1024);

     l_msg VARCHAR(1024);

     l_dpg_bas NUMBER(7) ;

     l_num_seq NUMBER(7);



    CURSOR curseur_coutke_edition(c_annee NUMBER ) IS SELECT  DISTINCT
                                cout.dpg_haut  DPHAUT ,
                             cout.dpg_bas   DPBAS,
                             cout.type_ligne
                            -- cout.METIER    METIER,
                            -- cout.cout      COUT
                          FROM  COUT_STD_KE cout
                         WHERE  cout.annee IS NOT NULL AND  cout.annee =  TO_NUMBER(p_couann) ;

    CURSOR curseur_ckeed_sansannee IS SELECT  DISTINCT
                                cout.dpg_haut  DPHAUT ,
                             cout.dpg_bas   DPBAS,
                             cout.type_ligne
                            -- cout.METIER    METIER,
                            -- cout.cout      COUT
                          FROM  COUT_STD_KE cout  ;


    CURSOR curseur_coutke(c_annee NUMBER ) IS SELECT  *
                          FROM  COUT_STD_KE cout
                          WHERE  cout.annee IS NOT NULL AND cout.annee =  TO_NUMBER(p_couann) ;

     CURSOR curseur_cke_sansannee IS SELECT  *
                          FROM  COUT_STD_KE cout  ;


BEGIN


         BEGIN


              DELETE FROM TMP_COUTKE_EDITION;
              COMMIT ;

                   SELECT  BIP.SETATKE.NEXTVAL INTO l_num_seq FROM DUAL ;

                   -- On distingue les deux cas où l'année est NULLE et NON NULLE
                   -- suivant les cas on utilisera les curseurs adéquats
                   IF(p_couann IS NULL OR LENGTH(p_couann)<=0) THEN
                                 FOR curseur IN curseur_ckeed_sansannee   LOOP
                               INSERT INTO TMP_COUTKE_EDITION (NUMSEQ,DPG_HAUT,DPG_BAS,type_ligne)
                                 VALUES(l_num_seq,curseur.DPHAUT,curseur.DPBAS,curseur.type_ligne) ;
                                  END LOOP ;
                               FOR curseur  IN curseur_cke_sansannee  LOOP
                                        IF (curseur.METIER='ME')THEN
                                            UPDATE TMP_COUTKE_EDITION SET ME = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                              and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='MO')THEN
                                            UPDATE TMP_COUTKE_EDITION SET MO = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='HOM')THEN
                                            UPDATE TMP_COUTKE_EDITION SET HOM = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='GAP')THEN
                                            UPDATE TMP_COUTKE_EDITION SET GAP = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='EXP')THEN
                                            UPDATE TMP_COUTKE_EDITION SET EXP = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                         IF (curseur.METIER='SAU')THEN
                                            UPDATE TMP_COUTKE_EDITION SET SAU = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                   END LOOP ;

                   ELSE
                                      FOR curseur IN curseur_coutke_edition(p_couann)  LOOP
                                INSERT INTO TMP_COUTKE_EDITION (NUMSEQ,DPG_HAUT,DPG_BAS,type_ligne)
                                  VALUES(l_num_seq,curseur.DPHAUT,curseur.DPBAS,curseur.type_ligne) ;
                                   END LOOP ;

                                FOR curseur  IN curseur_coutke(p_couann)  LOOP
                                        IF (curseur.METIER='ME')THEN
                                            UPDATE TMP_COUTKE_EDITION SET ME = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='MO')THEN
                                            UPDATE TMP_COUTKE_EDITION SET MO = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='HOM')THEN
                                            UPDATE TMP_COUTKE_EDITION SET HOM = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='GAP')THEN
                                            UPDATE TMP_COUTKE_EDITION SET GAP = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                        IF (curseur.METIER='EXP')THEN
                                            UPDATE TMP_COUTKE_EDITION SET EXP = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                         IF (curseur.METIER='SAU')THEN
                                            UPDATE TMP_COUTKE_EDITION SET SAU = curseur.cout WHERE
                                                  TMP_COUTKE_EDITION.DPG_HAUT = curseur.DPG_HAUT
                                              AND TMP_COUTKE_EDITION.DPG_BAS = curseur.DPG_BAS
                                               and TMP_COUTKE_EDITION.type_ligne = curseur.type_ligne;
                                        END IF ;
                                   END LOOP ;

                   END IF ;




                   COMMIT ;

                     RETURN  l_num_seq ;

         END;





EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
         Pack_Global.recuperer_message(20370, NULL, NULL, NULL, p_message);
        RAISE_APPLICATION_ERROR( -20370, p_message );

     WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END liste_anomalies;


/************************************************************************************/
/*                                                                                  */
/*       MISE A JOUR des couts standard pour Etats KE                               */
/*                                                                                  */
/************************************************************************************/
PROCEDURE UPDATE_COUT_STANDARD_KE (p_couann        IN  VARCHAR2,
                                   p_codsg_bas     IN  VARCHAR2,
                                   p_codsg_bas_new IN  VARCHAR2,
                                   p_codsg_haut      IN  VARCHAR2,
                                   p_codsg_haut_new IN  VARCHAR2,
                                   p_coutME_type1         IN  VARCHAR2,
                                   p_coutMO_type1         IN  VARCHAR2,
                                   p_coutHOM_type1         IN  VARCHAR2,
                                   p_coutGAP_type1         IN  VARCHAR2,
                                   p_coutEXP_type1         IN  VARCHAR2,
                                   p_coutSAU_type1         IN  VARCHAR2,
                                   p_coutME_type2         IN  VARCHAR2,
                                   p_coutMO_type2         IN  VARCHAR2,
                                   p_coutHOM_type2         IN  VARCHAR2,
                                   p_coutGAP_type2         IN  VARCHAR2,
                                   p_coutEXP_type2         IN  VARCHAR2,
                                   p_coutSAU_type2         IN  VARCHAR2,
                                   p_fourCopi      IN  VARCHAR2,
                                   userid        IN  VARCHAR2,
                                   p_nbcurseur        OUT INTEGER,
                                   p_message          OUT VARCHAR2
                              ) IS


    l_msg VARCHAR(1024);

    l_flaglock NUMBER(7);

    m_flaglock NUMBER(9);

    l_dpg_bas NUMBER(7) ;

    l_number NUMBER(4) ;

    l_count NUMBER ;



    p_userid  VARCHAR2(30) ;

    l_dpg_haut_old NUMBER(7) ;
    l_dpg_bas_old NUMBER(7) ;
    l_metier_old VARCHAR2(4);
    l_cout_old   NUMBER(12,2);
    l_codefourcopi_old   NUMBER(2) ;

    l_commentaire_update VARCHAR2(200) ;

    l_time_stamp DATE ;
    l_type_ligne VARCHAR2(20);

BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour

    l_commentaire_update := 'Mise à jour';

    p_userid := pack_global.lire_globaldata(userid).idarpege;


       p_nbcurseur := 0;
       p_message   := '';

    l_dpg_bas := NULL ;

    l_number := 0 ;






    SELECT SYSDATE INTO l_time_stamp FROM DUAL ;

     --RAISE_APPLICATION_ERROR( -20997, 'valeurs : an:'|| p_couann ||'bas:'|| p_codsg_bas_new ||'bas old'|| p_codsg_bas ||'haut:'|| p_codsg_haut_new ||'haut old:'|| p_codsg_haut || 'cout:'|| p_coutME );

             IF (p_codsg_bas !=p_codsg_bas_new OR p_codsg_haut != p_codsg_haut_new) THEN

                     -- Vérifier qu'il n'existe pas de tranche DPG_HAUT - DPG_BAS chevauchant
                      -- celle saisie
                     BEGIN
                      SELECT  COUNT(*) INTO l_count
                         FROM  COUT_STD_KE
                         WHERE annee = TO_NUMBER(p_couann)
                         AND dpg_bas <= TO_NUMBER(p_codsg_haut_new)
                         AND dpg_haut >= TO_NUMBER(p_codsg_bas_new)
                         AND ( dpg_bas!=p_codsg_bas
                         AND dpg_haut!= p_codsg_haut) ;

                          IF (l_count>0) THEN
                            --Message d'erreur : il existe un cout standard en KE avec une
                            --tranche DPG chevauchant celle saisie
                             Pack_Global.recuperer_message(21062, NULL, NULL, NULL, p_message);
                             RAISE_APPLICATION_ERROR(-20997, p_message );
                         END IF;
                     END ;




            END IF;

    BEGIN


     -- Sauvegarde FOURNISSEUR COPI ACTUEL avant éventuelle MODIF
    SELECT  CODE_FOUR_COPI INTO l_codefourcopi_old FROM COUT_STD_KE WHERE
     ANNEE = TO_NUMBER(p_couann)
     AND DPG_BAS =  TO_NUMBER(p_codsg_bas)
     AND DPG_HAUT = TO_NUMBER(p_codsg_haut)
     AND ROWNUM = 1 ;

      -- RAISE_APPLICATION_ERROR( -20997, 'Avant update : an:'|| p_couann ||'bas:'|| p_codsg_bas_new ||'bas old'|| p_codsg_bas ||'haut:'|| p_codsg_haut_new ||'haut old:'|| p_codsg_haut || 'cout:'|| p_coutME );


       IF (p_couann > 2009) THEN
        l_type_ligne := 'GT1 et AUTRE';
       ELSE
         l_type_ligne := 'TOUT';
       END IF;

     --LOG SI DPG BAS MODIFIE
     IF(p_codsg_bas <> p_codsg_bas_new ) THEN
            log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'TOUS'  , l_time_stamp , p_userid ,
                   'COUT_STD_KE'  ,'DPG_BAS' , TO_CHAR(NVL(p_codsg_bas,'')) , TO_CHAR(NVL(p_codsg_bas_new,'')) ,3 , l_commentaire_update,l_type_ligne )  ;
     END IF ;



    --LOG SI DPG HAUT MODIFIE
     IF(p_codsg_haut <> p_codsg_haut_new ) THEN
       log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'TOUS'  , l_time_stamp , p_userid ,
                'COUT_STD_KE'  ,'DPG_HAUT' ,TO_CHAR(NVL(p_codsg_haut,'')) , TO_CHAR(NVL(p_codsg_haut_new,'')) ,3 , l_commentaire_update,l_type_ligne )  ;
     END IF ;


    IF(l_codefourcopi_old <> TO_NUMBER(p_fourCopi)) THEN
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(p_codsg_haut),TO_NUMBER(p_codsg_bas) ,'TOUS'  ,l_time_stamp , p_userid ,
                 'COUT_STD_KE'  ,'CODE_FOUR_COPI' , TO_CHAR(NVL(l_codefourcopi_old,'')) ,  p_fourCopi ,3, l_commentaire_update,l_type_ligne )  ;
    END IF ;


    IF (p_couann > 2009) THEN
            l_type_ligne := 'GT1';
    ELSE
            l_type_ligne := 'TOUT';
    END IF;
      l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'ME',
                            TO_NUMBER(p_coutME_type1),
                            p_fourCopi ,l_time_stamp,p_userid, l_type_ligne
                                                         );

     l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'MO',
                            TO_NUMBER(p_coutMO_type1)
                                                        ,p_fourCopi,l_time_stamp,p_userid, l_type_ligne);

     l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'HOM',
                            TO_NUMBER(p_coutHOM_type1)
                                                        ,p_fourCopi,l_time_stamp,p_userid, l_type_ligne);

     l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'GAP',
                            TO_NUMBER(p_coutGAP_type1)
                                                        ,p_fourCopi,l_time_stamp,p_userid, l_type_ligne);

     l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'EXP',
                            TO_NUMBER(p_coutEXP_type1)
                                                        ,p_fourCopi,l_time_stamp,p_userid, l_type_ligne);

     l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'SAU',
                            TO_NUMBER(p_coutSAU_type1)
                                                        ,p_fourCopi,l_time_stamp,p_userid, l_type_ligne);


     IF (p_couann > 2009) THEN
            l_type_ligne := 'AUTRE';


              l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'ME',
                            TO_NUMBER(p_coutME_type2),
                            p_fourCopi ,l_time_stamp,p_userid, l_type_ligne
                                                         );

     l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'MO',
                            TO_NUMBER(p_coutMO_type2)
                                                        ,p_fourCopi,l_time_stamp,p_userid, l_type_ligne);

     l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'HOM',
                            TO_NUMBER(p_coutHOM_type2)
                                                        ,p_fourCopi,l_time_stamp,p_userid, l_type_ligne);

     l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'GAP',
                            TO_NUMBER(p_coutGAP_type2)
                                                        ,p_fourCopi,l_time_stamp,p_userid, l_type_ligne);

     l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'EXP',
                            TO_NUMBER(p_coutEXP_type2)
                                                        ,p_fourCopi,l_time_stamp,p_userid, l_type_ligne);

     l_count := update_coutKE_parmetier(TO_NUMBER(p_couann),
                            TO_NUMBER(p_codsg_bas_new),
                            TO_NUMBER(p_codsg_bas ),
                            TO_NUMBER(p_codsg_haut_new),
                               TO_NUMBER(p_codsg_haut),
                            'SAU',
                            TO_NUMBER(p_coutSAU_type2)
                                                        ,p_fourCopi,l_time_stamp,p_userid, l_type_ligne);
     END IF;





    COMMIT ;

      Pack_Global.recuperer_message(21065, '%s1', p_couann, NULL, p_message);




    END ;


    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );



  END UPDATE_COUT_STANDARD_KE;




/************************************************************************************/
/*                                                                                  */
/*       SUPPRESSION des couts standard                                             */
/*                                                                                  */
/************************************************************************************/
   PROCEDURE delete_cout_standard_ke (p_couann    IN  VARCHAR2,
                     p_codsg_bas IN  VARCHAR2,
                                  p_flaglock  IN  NUMBER,
                                      p_userid    IN  VARCHAR2,
                                  p_nbcurseur OUT INTEGER,
                                  p_message   OUT VARCHAR2
                         ) IS

      l_msg VARCHAR(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

      l_codsg_bas NUMBER(7) ;
      l_codsg_haut NUMBER(7) ;
      l_position_separateur NUMBER ;


      l_time_stamp VARCHAR2(10);
      l_user VARCHAR2(30) ;

      l_commentaire_del VARCHAR2(200) ;

      l_cout NUMBER(12,2) ;
      l_four_copi NUMBER(2) ;
      l_type_ligne VARCHAR2(20);

BEGIN


    l_commentaire_del := 'Supression';

    l_user := pack_global.lire_globaldata(p_userid).idarpege;


    --La variable reçue  p_codsg_bas contient
    -- le DPGBAS concaténé avec le DPG HAUT
    -- séparés par "-"
    -- Exemple :
    -- 1112-55454
    l_position_separateur  := INSTR(p_codsg_bas,'-') ;
    l_codsg_bas := TO_NUMBER(SUBSTR(p_codsg_bas ,1, l_position_separateur-1)) ;
    l_codsg_haut := TO_NUMBER( SUBSTR(p_codsg_bas , l_position_separateur+1,LENGTH(p_codsg_bas))) ;

    SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY') INTO l_time_stamp FROM DUAL ;

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN


        if (to_number(p_couann) > 2009) then
            l_type_ligne := 'GT1';
        else
            l_type_ligne := 'TOUT';
        end if;
        ------------------------------ ON LOGGUE TOUS LES COUTS QUI VONT ETRE SUPPRIME PAR METIER ------------------


        SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                  AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'ME'  AND type_ligne = l_type_ligne AND ROWNUM = 1  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'ME'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del,l_type_ligne )  ;

        SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                  AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'MO'  AND type_ligne = l_type_ligne AND ROWNUM = 1  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'MO'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del,l_type_ligne  )  ;

        SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                  AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'HOM' AND type_ligne = l_type_ligne  AND ROWNUM = 1  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'HOM'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del,l_type_ligne  )  ;

         SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                  AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'GAP' AND type_ligne = l_type_ligne  AND ROWNUM = 1  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'GAP'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del ,l_type_ligne )  ;

        SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                  AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'SAU' AND type_ligne = l_type_ligne  AND ROWNUM = 1  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'SAU'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del,l_type_ligne )  ;

         SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                  AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'EXP' AND type_ligne = l_type_ligne  AND ROWNUM = 1  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'EXP'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del,l_type_ligne  )  ;

      ------------------------------ FIN LOG -----------------------------------------------------------------------------------------
          SELECT CODE_FOUR_COPI INTO l_four_copi FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                  AND dpg_haut = TO_NUMBER(l_codsg_haut) AND ROWNUM = 1  ;
        log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'TOUS'  , l_time_stamp , l_user ,
                   'COUT_STD_KE'  ,'CODE_FOUR_COPI' , TO_CHAR(l_four_copi) , '' ,2 , l_commentaire_del,l_type_ligne )  ;



        if (to_number(p_couann) > 2009) then
            l_type_ligne := 'AUTRE';
                SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                          AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'ME'  AND type_ligne = l_type_ligne AND ROWNUM = 1  ;
                log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'ME'  , l_time_stamp , l_user ,
                           'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del,l_type_ligne )  ;

                SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                          AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'MO'  AND type_ligne = l_type_ligne AND ROWNUM = 1  ;
                log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'MO'  , l_time_stamp , l_user ,
                           'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del,l_type_ligne  )  ;

                SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                          AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'HOM' AND type_ligne = l_type_ligne  AND ROWNUM = 1  ;
                log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'HOM'  , l_time_stamp , l_user ,
                           'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del,l_type_ligne  )  ;

                 SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                          AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'GAP' AND type_ligne = l_type_ligne  AND ROWNUM = 1  ;
                log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'GAP'  , l_time_stamp , l_user ,
                           'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del ,l_type_ligne )  ;

                SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                          AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'SAU' AND type_ligne = l_type_ligne  AND ROWNUM = 1  ;
                log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'SAU'  , l_time_stamp , l_user ,
                           'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del,l_type_ligne )  ;

                 SELECT COUT INTO l_cout FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                          AND dpg_haut = TO_NUMBER(l_codsg_haut)  AND TRIM(metier) = 'EXP' AND type_ligne = l_type_ligne  AND ROWNUM = 1  ;
                log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'EXP'  , l_time_stamp , l_user ,
                           'COUT_STD_KE'  ,'COUT' , TO_CHAR(l_cout) , '' ,2 , l_commentaire_del,l_type_ligne  )  ;

              ------------------------------ FIN LOG -----------------------------------------------------------------------------------------
                  SELECT CODE_FOUR_COPI INTO l_four_copi FROM COUT_STD_KE  WHERE annee  = TO_NUMBER(p_couann) AND dpg_bas = TO_NUMBER(l_codsg_bas)
                                                          AND dpg_haut = TO_NUMBER(l_codsg_haut) AND ROWNUM = 1  ;
                log_coutKE(TO_NUMBER(p_couann),TO_NUMBER(l_codsg_haut),TO_NUMBER(l_codsg_bas) ,'TOUS'  , l_time_stamp , l_user ,
                           'COUT_STD_KE'  ,'CODE_FOUR_COPI' , TO_CHAR(l_four_copi) , '' ,2 , l_commentaire_del,l_type_ligne )  ;
        END IF;



        DELETE FROM COUT_STD_KE
                 WHERE annee  = TO_NUMBER(p_couann)
            AND dpg_bas = TO_NUMBER(l_codsg_bas)
            AND dpg_haut = TO_NUMBER(l_codsg_haut)  ;


      EXCEPTION

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            Pack_Global.recuperation_integrite(-2292);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;

      IF SQL%NOTFOUND THEN
         Pack_Global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
         Pack_Global.recuperer_message(21066, '%s1', p_couann, NULL, l_msg);
         p_message := l_msg;
      END IF;

   END delete_cout_standard_ke ;



/********************************************************************************/
/*                                                                              */
/*                 Sélection pour la mise à jour suppression                    */
/*                                                                              */
/********************************************************************************/
PROCEDURE select_cout_standard_ke (p_couann    IN VARCHAR2,
                                   p_codsg_bas IN VARCHAR2,
                                   p_userid    IN VARCHAR2,
                                   p_curcout   IN OUT coutCurType,
                                   p_nbcurseur    OUT INTEGER,
                                   p_message      OUT VARCHAR2
                      ) IS


     l_msg VARCHAR(1024);

     l_codsg_bas NUMBER(7) ;
     l_codsg_haut NUMBER(7) ;
     l_position_separateur NUMBER ;



BEGIN


    --La variable reçue  p_codsg_bas contient
    -- le DPGBAS concaténé avec le DPG HAUT
    -- séparés par "-"
    -- Exemple :
    -- 1112-55454
    l_position_separateur  := INSTR(p_codsg_bas,'-') ;
    l_codsg_bas := TO_NUMBER(SUBSTR(p_codsg_bas ,1, l_position_separateur-1)) ;
    l_codsg_haut := TO_NUMBER( SUBSTR(p_codsg_bas , l_position_separateur+1,LENGTH(p_codsg_bas))) ;


    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour

    p_nbcurseur := 1;
    p_message := '';

    -- TEST p_couann > 1900 et < 3000

    IF TO_NUMBER(p_couann) < 1900 OR TO_NUMBER(p_couann) > 3000 THEN
        Pack_Global.recuperer_message(20242, NULL, NULL, NULL, l_msg);
        RAISE_APPLICATION_ERROR( -20242, l_msg);
    END IF;

    -- Attention ordre des colonnes doit correspondre a l ordre
    -- de declaration dans la table ORACLE (a cause de ROWTYPE)
    -- ou selectionner toutes les colonnes par *

    BEGIN
        IF (to_number(p_couann) < 2010) THEN

        OPEN p_curcout FOR

            SELECT TO_CHAR(annee),
                   TO_CHAR(dpg_bas,'FM0000000'),
                   TO_CHAR(dpg_haut,'FM0000000'),
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'ME','TOUT'),NULL, '0,00' ,get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'ME','TOUT'))   me,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'MO','TOUT'),NULL, '0,00' ,get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'MO','TOUT'))   mo,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'HOM','TOUT'),NULL, '0,00' , get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'HOM','TOUT')) hom,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'GAP','TOUT'),NULL, '0,00' ,  get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'GAP','TOUT')) gap,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'EXP','TOUT'),NULL, '0,00' , get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'EXP','TOUT')) EXP,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'SAU','TOUT'),NULL, '0,00' , get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'SAU','TOUT')) sau,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TO_CHAR(CODE_FOUR_COPI,'FM99'),
                   --get_coutstandard_ke (p_couann ,p_codsg_bas,'SAU') sau,
                   flaglock
              FROM COUT_STD_KE
             WHERE annee   = TO_NUMBER(p_couann)
               AND dpg_bas = TO_NUMBER(l_codsg_bas)
               AND dpg_haut = TO_NUMBER(l_codsg_haut)
               AND ROWNUM  = 1;

        ELSE
        OPEN p_curcout FOR

            SELECT TO_CHAR(annee),
                   TO_CHAR(dpg_bas,'FM0000000'),
                   TO_CHAR(dpg_haut,'FM0000000'),
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'ME','GT1'),NULL, '0,00' ,get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'ME','GT1'))   me,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'MO','GT1'),NULL, '0,00' ,get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'MO','GT1'))   mo,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'HOM','GT1'),NULL, '0,00' , get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'HOM','GT1')) hom,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'GAP','GT1'),NULL, '0,00' ,  get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'GAP','GT1')) gap,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'EXP','GT1'),NULL, '0,00' , get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'EXP','GT1')) EXP,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'SAU','GT1'),NULL, '0,00' , get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'SAU','GT1')) sau,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'ME','AUTRE'),NULL, '0,00' ,get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'ME','AUTRE'))   me,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'MO','AUTRE'),NULL, '0,00' ,get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'MO','AUTRE'))   mo,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'HOM','AUTRE'),NULL, '0,00' , get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'HOM','AUTRE')) hom,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'GAP','AUTRE'),NULL, '0,00' ,  get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'GAP','AUTRE')) gap,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'EXP','AUTRE'),NULL, '0,00' , get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'EXP','AUTRE')) EXP,
                   DECODE(get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'SAU','AUTRE'),NULL, '0,00' , get_coutstandard_ke (p_couann ,l_codsg_bas,l_codsg_haut,'SAU','AUTRE')) sau,
                   TO_CHAR(CODE_FOUR_COPI,'FM99'),
                   --get_coutstandard_ke (p_couann ,p_codsg_bas,'SAU') sau,
                   flaglock
              FROM COUT_STD_KE
             WHERE annee   = TO_NUMBER(p_couann)
               AND dpg_bas = TO_NUMBER(l_codsg_bas)
               AND dpg_haut = TO_NUMBER(l_codsg_haut)
               AND ROWNUM  = 1;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
    END;

    -- en cas absence
    -- p_message := 'Le cout n'existe pas';


    Pack_Global.recuperer_message(21067, '%s1', p_couann, NULL, l_msg);
    p_message := l_msg;

END select_cout_standard_KE;








/************************************************************************************/
/*                                                                                  */
/*   CONTROLE LA COHERENCE DES PLAGES DE DPG des couts standard  pour Etats KE      */
/*                                                                                  */
/************************************************************************************/
PROCEDURE controle_cout_standard_ke(    p_couann    IN  VARCHAR2,
                                        p_userid    IN  VARCHAR2,
                                        p_message   OUT VARCHAR2
                      ) IS

    l_msg VARCHAR(1024);
    dpg_bas_old COUT_STD_KE.dpg_bas%TYPE;
    dpg_haut_old COUT_STD_KE.dpg_haut%TYPE;

    dpg_bas_first COUT_STD_KE.dpg_bas%TYPE;
    flag_dpg_max NUMBER(1);

    CURSOR curs_coutstd IS
            SELECT DISTINCT annee couann,
                     dpg_bas codsg_bas,
                  dpg_haut codsg_haut
             FROM COUT_STD_KE
             WHERE annee = TO_NUMBER(p_couann)
            ORDER BY 1,2,3;

    curs_coutstd_enreg curs_coutstd%ROWTYPE;
BEGIN

    -- Initialiser le message retour et flag
    p_message := ' ';
    flag_dpg_max := 0;
    -- TEST p_couann > 1900 et < 3000

    IF TO_NUMBER(p_couann) < 1900 OR TO_NUMBER(p_couann) > 3000 THEN
        Pack_Global.recuperer_message(20242, NULL, NULL, NULL, l_msg);
        RAISE_APPLICATION_ERROR( -20242, l_msg);
    END IF;

    -- Attention ordre des colonnes doit correspondre a l ordre
    -- de declaration dans la table ORACLE (a cause de ROWTYPE)
    -- ou selectionner toutes les colonnes par *

    BEGIN

        -- Premier contrôle tranche DPG existante pour l'année
        OPEN curs_coutstd;

          FETCH curs_coutstd INTO curs_coutstd_enreg;

        IF curs_coutstd%FOUND THEN
            dpg_bas_first := curs_coutstd_enreg.codsg_bas;

              dpg_bas_old := curs_coutstd_enreg.codsg_bas;
              dpg_haut_old := curs_coutstd_enreg.codsg_haut;
            IF(dpg_haut_old = 9999999) THEN flag_dpg_max := 1;
            END IF;
        ELSE
            p_message := 'Aucune tranche de DPG pour l''année ' || p_couann || '.';
        END IF;

        FETCH curs_coutstd INTO curs_coutstd_enreg;

          WHILE curs_coutstd%FOUND LOOP

            IF (curs_coutstd_enreg.codsg_bas <= dpg_haut_old) THEN

                p_message :=p_message || ' Recouvrement entre les tranches DPG : '|| TO_CHAR(dpg_bas_old,'0000000') ||'-'|| TO_CHAR(dpg_haut_old,'0000000') || ' et ' || TO_CHAR(curs_coutstd_enreg.codsg_bas,'0000000') ||'-'||TO_CHAR(curs_coutstd_enreg.codsg_haut,'0000000') || '.';

                dpg_bas_old := curs_coutstd_enreg.codsg_bas;
                  dpg_haut_old := curs_coutstd_enreg.codsg_haut;
                IF(dpg_haut_old = 9999999) THEN flag_dpg_max := 1;
                END IF;

            ELSIF (curs_coutstd_enreg.codsg_bas > dpg_haut_old+1) THEN

                p_message := p_message || ' Vide entre les tranches DPG : ' || TO_CHAR(dpg_bas_old,'0000000') || '-' || TO_CHAR(dpg_haut_old,'0000000') || ' et ' ||    TO_CHAR(curs_coutstd_enreg.codsg_bas,'0000000') || '-' || TO_CHAR(curs_coutstd_enreg.codsg_haut,'0000000') ||'.';

                dpg_bas_old := curs_coutstd_enreg.codsg_bas;
                  dpg_haut_old := curs_coutstd_enreg.codsg_haut;
                IF(dpg_haut_old = 9999999) THEN flag_dpg_max := 1;
                END IF;

            ELSE
                dpg_bas_old := curs_coutstd_enreg.codsg_bas;
                dpg_haut_old := curs_coutstd_enreg.codsg_haut;
                IF(dpg_haut_old = 9999999) THEN flag_dpg_max := 1;
                END IF;
            END IF;

              FETCH curs_coutstd INTO curs_coutstd_enreg;

        END LOOP;

       CLOSE curs_coutstd;
    END;

    IF (dpg_bas_first <> 0000000 OR flag_dpg_max <> 1) THEN
        p_message :=  p_message || ' Tranches de DPG incomplètes.' ;
    END IF;
    IF (p_message = ' ') THEN
        p_message := 'Les tranches de codes DPG sont ok pour l''année ' || p_couann || ' Pas de recouvrement ni de vide.';
    END IF;

END controle_cout_standard_ke;












/*************************************************************************/
/*         Retourne le cout suivant le metier                             */
/*************************************************************************/
FUNCTION get_coutstandard_KE (p_anneestd IN VARCHAR2,
                           p_dpg_bas  IN VARCHAR2,
                           p_dpg_haut  IN VARCHAR2,
                           p_metier   IN VARCHAR2,
                           p_TYPE_LIGNE IN VARCHAR2) RETURN VARCHAR2 IS
    l_cout VARCHAR2(500);
BEGIN

    SELECT TO_CHAR(cout,'FM999999999999D00')
      INTO l_cout
      FROM COUT_STD_KE
     WHERE annee = TO_NUMBER(p_anneestd)
       AND dpg_bas = TO_NUMBER(p_dpg_bas)
       AND dpg_haut = TO_NUMBER(p_dpg_haut)
       AND RTRIM(METIER)=RTRIM(p_metier)
       and type_ligne = p_TYPE_LIGNE ;

    RETURN l_cout;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
             RETURN NULL;

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END get_coutstandard_KE;



/*************************************************************************/
/*        Update un cout standard en KE ou le crée s'il n'existe pas     */
/*************************************************************************/
FUNCTION update_coutKE_parmetier (p_anneestd IN NUMBER,
                           p_dpg_bas  IN NUMBER,
                           p_dpg_bas_old  IN NUMBER,
                           p_dpg_haut  IN NUMBER,
                           p_dpg_haut_old  IN NUMBER,
                           p_metier   IN VARCHAR2,
                           p_cout IN NUMBER,
                           p_fourCopi IN VARCHAR2 ,
                           p_time_stamp IN VARCHAR2,
                           p_userid IN VARCHAR2,
                           p_type_ligne IN VARCHAR2) RETURN VARCHAR2 IS

    l_cout VARCHAR2(500);
    l_count NUMBER ;
    l_flaglock NUMBER(7);
    l_cout_old   NUMBER(12,2);
    l_commentaire_create VARCHAR2(50) ;
    l_commentaire_update VARCHAR2(50) ;

BEGIN

    l_commentaire_create := 'Création';
    l_commentaire_update := 'Mise à jour';


    --RAISE_APPLICATION_ERROR( -20997, 'an:'||TO_CHAR(p_anneestd) ||'bas:'|| TO_CHAR(p_dpg_bas)||'bas old'||TO_CHAR(p_dpg_bas_old)||'haut:'||TO_CHAR(p_dpg_haut)||'haut old:'||TO_CHAR(p_dpg_haut_old)||'metier'||p_metier||'cout:'|| TO_CHAR(p_cout));
    SELECT COUNT(*) INTO l_count FROM COUT_STD_KE
             WHERE
           annee =  p_anneestd
             AND dpg_bas = p_dpg_bas_old
           AND dpg_haut = p_dpg_haut_old
             AND TRIM(METIER)=TRIM(p_metier)  ;


    -- Cas en Anomalie : où il manque un cout pour un Métier donné
    -- on créé la donnée
    -- Si rien trouvé  crée l'enregistrement en table
    IF(l_count <=0) THEN

        INSERT INTO COUT_STD_KE (ANNEE,DPG_BAS,DPG_HAUT,METIER,COUT,FLAGLOCK,CODE_FOUR_COPI) VALUES
        (p_anneestd ,p_dpg_bas,p_dpg_haut ,p_metier,p_cout,0,TO_NUMBER(p_fourCopi));

       log_coutKE(p_anneestd,p_dpg_haut,p_dpg_bas ,p_metier  , p_time_stamp , p_userid ,
                   'COUT_STD_KE'  ,'COUT' ,  '' , TO_CHAR(p_cout) ,1 , l_commentaire_create,p_type_ligne )  ;

    END IF ;

    -- Si l'enregistrement n'a pas été créé car non existant : update du cout et flaglock
    IF(l_count > 0) THEN

            SELECT flaglock INTO l_flaglock FROM
    COUT_STD_KE WHERE
            ANNEE = p_anneestd AND
            dpg_bas = p_dpg_bas_old AND
            dpg_haut = p_dpg_haut_old AND
            TRIM(METIER) = TRIM(p_metier)
            AND type_ligne = p_type_ligne ;

      --Fiche 596 :
      -- LOG COUT KE SI le cout a changé pour le métier donné
       SELECT COUT INTO  l_cout_old FROM COUT_STD_KE WHERE
       ANNEE = p_anneestd
       AND DPG_BAS = p_dpg_bas_old
       AND DPG_HAUT = p_dpg_haut_old
       AND METIER =  p_metier
       and type_ligne = p_type_ligne
       AND ROWNUM = 1  ;

     -- Si cout a changé pour le métier -> LOG COUT KE
     IF(l_cout_old <> p_cout) THEN
        log_coutKE(p_anneestd,p_dpg_haut,p_dpg_bas ,p_metier  , p_time_stamp , p_userid ,
                   'COUT_STD_KE'  ,'COUT' ,TO_CHAR(l_cout_old) , TO_CHAR(p_cout) ,3 , l_commentaire_update, p_type_ligne)  ;
     END IF ;

     SELECT count(*) into l_count from  COUT_STD_KE
            WHERE
            ANNEE = p_anneestd AND
            dpg_bas = p_dpg_bas_old AND
            dpg_haut = p_dpg_haut_old AND
            TRIM(METIER) = TRIM(p_metier)
            AND type_ligne = p_type_ligne ;




        COMMIT;

        UPDATE COUT_STD_KE SET  dpg_bas = p_dpg_bas, dpg_haut = p_dpg_haut,
        flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1),
        cout = p_cout,
                CODE_FOUR_COPI=TO_NUMBER(p_fourCopi)
        WHERE
            ANNEE = p_anneestd AND
            dpg_bas = p_dpg_bas_old AND
            dpg_haut = p_dpg_haut_old AND
            TRIM(METIER) = TRIM(p_metier)
            AND type_ligne = p_type_ligne  ;


    END IF ;



    COMMIT ;

    RETURN NULL;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
   RAISE_APPLICATION_ERROR( -20997,'NOT FOUND');
            -- RETURN NULL;

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END update_coutKE_parmetier;



/*************************************************************************/
/*       Insère une anomalies dans la table des anomalies                  */
/*       des coûts standards et coûts standards en KE                    */
/*************************************************************************/
FUNCTION creer_anomalie_coutstdKE(p_annee  IN NUMBER,
                                    p_dpg IN NUMBER,
                                    p_metier IN VARCHAR2,
                                    p_pid IN VARCHAR2,
                                    p_libelle_erreur IN VARCHAR2,
                                    p_matricule IN VARCHAR2,
                                    p_code_branche IN VARCHAR2 ,
                                    p_libelle_branche IN VARCHAR2 ,
                                    p_timestamep IN DATE,
                                    p_type_ligne_bip VARCHAR2) RETURN NUMBER IS


    l_number NUMBER ;

BEGIN

SELECT COUNT(*) INTO l_number FROM  COUTS_STD_REJETS
 WHERE ANNEE = p_annee AND DPG=p_dpg AND TRIM(METIER)=TRIM(p_metier) AND TRIM(PID)=TRIM(p_pid)
 AND TRIM(BRANCHE)=TRIM(p_code_branche) AND TRIM(MATRICULE)=TRIM(p_matricule)
  AND   TO_CHAR(p_timestamep, 'yyyy/mm/dd')=TO_CHAR(DATE_CREATION, 'yyyy/mm/dd')
  AND TRIM(libelle)=TRIM(p_libelle_erreur)
  and type_ligne= p_type_ligne_bip;

     IF (l_number=0) THEN
          INSERT INTO  COUTS_STD_REJETS (ANNEE,DPG ,METIER, PID, LIBELLE, MATRICULE,  BRANCHE,LIBBR , DATE_CREATION,type_ligne)
        VALUES (p_annee , p_dpg , p_metier, p_pid ,p_libelle_erreur , p_matricule, p_code_branche , p_libelle_branche, p_timestamep,p_type_ligne_bip);
     END IF ;


    RETURN  0;

EXCEPTION

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END creer_anomalie_coutstdKE;




/************************************************************************************/
/*                                                                                  */
/*       Pré insert des couts KE : insert dans table  TMP_COUTKE_ETATS              */
/*                                                                                  */
/************************************************************************************/
-- variable ecran_isac : indique que l'état à sortir est : par client avec sous traitance
-- depuis écran isac
FUNCTION INSERT_ETAT_SUIVI_FINANCIER_KE(
        annee NUMBER ,
        p_param6 IN  VARCHAR2 ,etat_sous_traitance IN VARCHAR2, ecran_isac IN VARCHAR2, CODE_CHEF_PROJET IN VARCHAR2,
        matricule IN VARCHAR2 , libelle_branche IN VARCHAR2 ,code_branche IN VARCHAR2)  RETURN NUMBER IS


     l_msg VARCHAR(1024);
     p_message VARCHAR(1024);
     l_dpg_bas NUMBER(7);
     l_param VARCHAR2(100);
     l_param_requete VARCHAR2(400);
     l_annee NUMBER(4) ;
     l_annee_plusun NUMBER(4) ;
     requet  VARCHAR2(5000);
     metierExclus VARCHAR2(10);
     fin_requete VARCHAR2(500);
     last_requete VARCHAR2(2000);

     l_num_seq NUMBER(7);

     l_cout_consomme NUMBER(12,2);
     l_cout_consomme_nonarrondi NUMBER(12,6);
     l_cout_ke  NUMBER(12,2);
     l_cout_anneeplusun_ke  NUMBER(12,2);
     l_consomme NUMBER(12,2);
     l_resteafaire NUMBER(12,6);
     l_cout_constate_non_arrondi NUMBER(12,6) ;

     l_count NUMBER;

     compt NUMBER ;

     codsg_coutpardefaut NUMBER(7) ;


     --infos utilisateur (matricule,branche) + date du jour : timestamp
     l_coddir NUMBER(2);
     l_codbr NUMBER(2);
     l_codsg_utiilisateur NUMBER(7);
     l_anomalie VARCHAR2(500) ;
     l_timestamp  DATE;
     l_retour NUMBER(1) ;
     l_flag_anomalie_detectee NUMBER(1)  ;


     l_cusag_proplus NUMBER(12,2) ;
     l_pcpi_proplus NUMBER(5)  ;
     l_pid_proplus VARCHAR2(4) ;

     type_ligne_bip VARCHAR2(5);

    TYPE lignesCurTyp IS REF CURSOR;
    lignesCt lignesCurTyp ;

    ligneTableTemp TMP_COUTKE_ETATS%ROWTYPE ;



      CURSOR curseur_requete(c_annee NUMBER, p_param6 VARCHAR2) IS SELECT  DISTINCT
                                lb.pid PID   ,
                             lb.codsg codsg,
                             budg.annee  annee,
                             lb.METIER METIER ,
                             NVL(conso.cusag,0)           CONSOJH,
                             NVL(budg.reestime,0)         REESTJH,
                             NVL(budg.bnmont,0)           NOTIFJH,
                             NVL(budg.anmont,0)           ARBITJH
                          FROM  LIGNE_BIP  lb   ,
                                BUDGET budg  ,
                                CONSOMME conso
                          WHERE
                           lb.pid = budg.pid  (+)
                           AND lb.pid = conso.pid (+)
                           AND lb.typproj!=9
                           AND lb.typproj!=7
                           AND trim(lb.METIER) !=  ( 'FOR' )
                           --AND budg.annee(+) = c_annee
                             --AND conso.annee(+) = c_annee;
                           AND budg.annee(+) = c_annee
                             AND conso.annee(+) = c_annee ;






     CURSOR curseur_temp_couts(l_num_seq_var NUMBER) IS SELECT * FROM TMP_COUTKE_ETATS
     WHERE NUMSEQ = l_num_seq_var;








BEGIN

     BEGIN

            codsg_coutpardefaut :=  9999999 ;
            -- last_requete := ' and budg.annee(+) = 2007 and budg1.annee(+) = 2008 and conso.annee(+) = 2007 ';

            -- récupération d'un numéro de séquence
            -- les données générées par deux utilisateurs seront différenciées par le NUMSEQ
            SELECT BIP.SETATKE.NEXTVAL INTO l_num_seq FROM DUAL ;


             l_timestamp := SYSDATE ;






                         FOR curseur IN curseur_requete( annee, p_param6)  LOOP
                              INSERT INTO TMP_COUTKE_ETATS (
                                   PID,
                                   CODSG,
                                   METIER ,
                                   NUMSEQ ,

                                   COUT_KE  ,
                                   COUT_ANNEEPLUSUN_KE  ,
                                   CONSOJH  ,
                                   REESTJH ,
                                   --PROPOJH  ,
                                   NOTIFJH ,
                                   --PROPOMOJH  ,
                                   ARBITJH  ,
                                   --PROPOJH1  ,
                                  -- PROPOMOJH1 ,

                                   CONSO_KE  ,
                                   REEST_KE  ,
                                   PROPO_KE ,
                                   NOTIF_KE ,
                                   PROPOMO_KE  ,
                                   ARBIT_KE  ,
                                   PROPO_ANNEEPLUSUN_KE  ,
                                   PROPOMO_ANNEEPLUSUN_KE ,
                                   ANNEE ,
                                   --ANNEEPLUSUN  ,
                                   RESTEAFAIREJH
                              )  VALUES  (
                                        curseur.PID  ,
                                     curseur.codsg ,
                                     curseur.METIER ,
                                      l_num_seq  ,

                                     0,
                                     0,
                                     curseur.CONSOJH  ,
                                     curseur.REESTJH ,
                                     --curseur.PROPOJH  ,
                                     curseur.NOTIFJH ,
                                   --  curseur.PROPOMOJH  ,
                                     curseur.ARBITJH  ,
                                   --  curseur.PROPOJH1  ,
                                   --  curseur.PROPOMOJH1 ,
                                     0,
                                     0,
                                     0,
                                     0,
                                     0,
                                     0,
                                     0,
                                     0,
                                     curseur.annee,
                                    -- (NVL(curseur.annee,0) + 1) , --annee_budg1,
                                     0
                            );

                      END LOOP ;
                     -- COMMIT ;






               --------------------------------------------------------------------------------------------------------
                  -- ETAPE 2 : Recherche cout standard en KE ANNEE et cout standard en KE ANNEE + 1 pour chaque ligne BIP
               --------------------------------------------------------------------------------------------------------

                -----------------------------------------------------------------------------------------------
                -- MAJ table temporaire TMP_COUTKE_ETATS ANNEE N
                -----------------------------------------------------------------------------------------------
            FOR curseurTemp IN  curseur_temp_couts(l_num_seq) LOOP
                -- si tous les JH à 0 , les montants ramenés seront tous égal à 0 : docn inutile effectuer calculs
                IF (curseurTemp.CONSOJH != 0 OR curseurTemp.REESTJH !=0 OR curseurTemp.NOTIFJH != 0 OR curseurTemp.ARBITJH != 0) THEN
                        --  RECHERCHE COUT STANDARD ANNEE  POUR LA LIGNE BIP ACTUELLE DU CURSEUR
                        --  LIGNE BIP:CODSG
                        --  LIGNE BIP:METIER
                        --  LIGNE BIP:ANNEE
                        --  Le coût standard est récupéré dans la table COUT_STD_KE
                        --  cette table fournit un cout standard pour chaque : CODSG, METIER,ANNEE donnés
                        --  donc l'identifiant LIGNE_BIP : PID ne sert pas à la récupération du cout en KE
                        l_cout_ke := 0 ;
                        l_flag_anomalie_detectee  := 0 ;

                        select arctype into type_ligne_bip from ligne_bip where pid = curseurTemp.pid;

                        IF(  curseurTemp.annee  IS NOT NULL AND LENGTH(curseurTemp.annee)>0  ) THEN

                         IF (curseurTemp.annee > 2009) THEN
                                  IF (type_ligne_bip = 'T1') THEN
                                    type_ligne_bip := 'GT1';
                                  ELSE
                                    type_ligne_bip := 'AUTRE';
                                  END IF;
                              ELSE
                                 type_ligne_bip := 'TOUT';
                         END IF;



                                  l_count := 0 ;
                                SELECT COUNT(*) INTO l_count  FROM  COUT_STD_KE cout  WHERE
                                                cout.annee = curseurTemp.annee
                                                AND cout.dpg_bas<=curseurTemp.codsg
                                                AND cout.dpg_haut>=curseurTemp.codsg
                                                AND cout.dpg_haut != codsg_coutpardefaut
                                                AND cout.dpg_bas != codsg_coutpardefaut
                                                AND trim(cout.METIER) = trim(curseurTemp.METIER)
                                                and type_ligne = type_ligne_bip ;

                                     -- Gestion de récupération du cout standard en KE
                                     -- si anomalie : ramène le cout par défaut (CODSG = 9999999)
                                     IF(l_count=1) THEN
                                           -- Via ANNEE,CODSG,METIER lecture cout standard en KE table COUT_STD_KE
                                           SELECT DISTINCT cout.cout INTO l_cout_ke FROM  COUT_STD_KE cout
                                           WHERE  cout.annee = curseurTemp.annee
                                            AND cout.dpg_bas<=curseurTemp.codsg  AND cout.dpg_haut>=curseurTemp.codsg
                                            AND cout.dpg_haut != codsg_coutpardefaut
                                            AND trim(cout.METIER)  = trim(curseurTemp.METIER)
                                            and type_ligne = type_ligne_bip AND ROWNUM <=1  ;

                                           --ecriture dans table Anomalies
                                           IF(l_cout_ke=0)THEN
                                             l_flag_anomalie_detectee := 1 ;

                                           END IF ;
                                      END IF ;

                                    --ecriture dans table Anomalies
                                    IF(l_count=0 OR l_count>1) THEN
                                           l_flag_anomalie_detectee := 1 ;

                                      END IF ;

                                     -- Anomalie : Recherche cout par défaut via ANNEE,CODSG= 9999999 ,
                                     --            METIER  lecture cout standard par défaut en KE table COUT_STD_KE
                                     IF(l_flag_anomalie_detectee = 1) THEN
                                           SELECT cout.cout INTO l_cout_ke  FROM  COUT_STD_KE cout WHERE
                                           cout.annee = curseurTemp.annee AND cout.dpg_haut= codsg_coutpardefaut
                                           AND trim(cout.METIER)  = trim(curseurTemp.METIER)
                                           and type_ligne = type_ligne_bip AND ROWNUM <=1 ;
                                     END IF ;

                                     -- MAJ COUT STANDARD pour la ligne BIP avec
                                     -- LIGNE BIP PID
                                     -- LIGNE BIP CODSG
                                       -- LIGNE BIP METIER
                                      UPDATE TMP_COUTKE_ETATS SET COUT_KE = l_cout_ke WHERE
                                                                      TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                                                      AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                      trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                        TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                      AND curseurTemp.NUMSEQ = l_num_seq ;


                            END IF ;


                            ---------------------------------------------------------------------
                            -- ETAPE 3 : calcul des champs simple (nombre JH lu * cout en KE)
                            ---------------------------------------------------------------------

                            -- Update montants ANNEE via cout standard ANNEE
                            IF(curseurTemp.NOTIFJH != 0 OR curseurTemp.ARBITJH != 0) THEN
                                UPDATE TMP_COUTKE_ETATS SET
                                  NOTIF_KE = ROUND((NOTIFJH * l_cout_ke)/1000,0),
                                    ARBIT_KE = ROUND((ARBITJH * l_cout_ke)/1000,0)
                                       WHERE
                                        TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                         AND TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg
                                          AND trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER)
                                           AND TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                            AND curseurTemp.NUMSEQ = l_num_seq ;
                            END IF ;



                            ---------------------------------------------------------------------------
                            -- ETAPE 4 : calculs complexes Consommé et Ré-estimé (voir spécifications)
                            ---------------------------------------------------------------------------



                                      /*UPDATE TMP_COUTKE_ETATS SET CONSO_KE = l_cout_consomme WHERE
                                                         TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee
                                                         AND TMP_COUTKE_ETATS. CODSG = curseurTemp.codsg AND
                                                         trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                         TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                         AND curseurTemp.NUMSEQ = l_num_seq ;*/


                            -- Si les deux montants sont à 0 : inutile effectuer les calculs
                            -- car on passera dans la 1° formule qui ramènera systématiquement 0
                            IF(curseurTemp.CONSOJH != 0 OR curseurTemp.REESTJH !=0 ) THEN
                                      --------------------------------
                                      -- ETAPE 4.1 : calcul REESTIME
                                      --------------------------------
                                      IF ( curseurTemp.CONSOJH = 0 ) THEN
                                             -- Si le consommé en jh est  = 0 alors :
                                              -- coût en k¿ du ré estimé =  (ré estimé en jh * coût)/1000
                                           UPDATE TMP_COUTKE_ETATS  SET  REEST_KE  =    ROUND(  (  NVL( curseurTemp.REESTJH,0) *  l_cout_ke   )/1000 , 0  )
                                                              WHERE
                                                                 TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                                 TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                 trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                 TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                 AND curseurTemp.NUMSEQ = l_num_seq ;
                                        ELSE

                                              -----------------------------------------------
                                              -- RECHERCHE CONSOMME : UTILISE POUR REESTIME
                                              -----------------------------------------------
                                              l_count := 0 ;
                                              l_cout_consomme := 0 ;
                                              l_cout_consomme_nonarrondi :=0 ;
                                              SELECT COUNT(*) INTO   l_count  FROM SYNTHESE_ACTIVITE synth
                                                          WHERE synth.pid = curseurTemp.pid AND synth.annee = curseurTemp.annee  AND trim(synth.METIER) = trim(curseurTemp.METIER)  ;
                                              IF(  l_count > 0 )THEN
                                                            SELECT  (  ( NVL(synth.CONSOFT_SG,0) + NVL(synth.CONSOFT_SSII,0) + NVL(synth.CONSOENV_SG,0) + NVL(synth.CONSOENV_SSII,0)  ) /1000  ) INTO  l_cout_consomme_nonarrondi
                                                            FROM SYNTHESE_ACTIVITE synth  WHERE  synth.pid  =  curseurTemp.pid  AND synth.annee = curseurTemp.annee AND trim(synth.METIER)  =  trim(curseurTemp.METIER) ;
                                                            l_cout_consomme := ROUND(l_cout_consomme_nonarrondi,0) ;
                                              END IF ;


                                             -- CALCUL DU RESTE A FAIRE : Si le consommé  est > 0  : Ràf JH = ré estimé JH ¿ consommé JH
                                             l_resteafaire := curseurTemp.reestjh - curseurTemp.consojh ;

                                              --Si le ràf est = 0 :Coût en k¿ du ré estimé  =  coût en kE du consommé
                                             IF (l_resteafaire  = 0) THEN
                                                 UPDATE TMP_COUTKE_ETATS  SET  REEST_KE  =  l_cout_consomme
                                                            WHERE   TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                            TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                            trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                            TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                            AND curseurTemp.NUMSEQ = l_num_seq ;
                                             ELSE
                                               -- CALCUL COUT CONSTATE (non arrondi en KE): Si le reste à faire est différent de 0
                                               -- Coût constaté  = cout consommé calculé / consommé en JH
                                                    l_cout_constate_non_arrondi :=  ( l_cout_consomme_nonarrondi / curseurTemp.consojh)   ;
                                             END IF ;

                                             IF (l_resteafaire  >0  ) THEN
                                                     -- Si ràf est >0, alors le montant en kE du ré estimé se calcule ainsi :
                                                     -- Coût en kE du ré estimé  =  coût en kEdu consommé + (ràf JH * coût constaté)/1000
                                                     UPDATE TMP_COUTKE_ETATS  SET  REEST_KE = ROUND(( l_cout_consomme_nonarrondi +    (  l_cout_constate_non_arrondi * NVL(l_resteafaire,0))),0)
                                                                                     WHERE
                                                                                     TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                                                     TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                                     trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                                     TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                                     AND curseurTemp.NUMSEQ = l_num_seq ;
                                             END IF;

                                             IF (l_resteafaire  < 0 ) THEN
                                                      --Si ràf est < 0, alors le montant en KE du ré estimé se calcule ainsi :
                                                     --Coût en KE du ré estimé  =  Coût constaté  * ré-estimés en JH
                                                     UPDATE TMP_COUTKE_ETATS  SET  REEST_KE  = ROUND(  ( l_cout_constate_non_arrondi * NVL(curseurTemp.REESTJH ,0) ),0)
                                                           WHERE    TMP_COUTKE_ETATS.ANNEE = curseurTemp.annee AND
                                                                    TMP_COUTKE_ETATS.CODSG = curseurTemp.codsg AND
                                                                    trim(TMP_COUTKE_ETATS.METIER) = trim(curseurTemp.METIER) AND
                                                                    TMP_COUTKE_ETATS.PID = curseurTemp.PID
                                                                    AND curseurTemp.NUMSEQ = l_num_seq ;
                                            END IF ;

                                --------- Fin Calcul réestimé  ----------
                                END IF ;
                             END IF ; -- Fin si CONSOJH ou REESTJH != 0

                        END IF ; -- Fin si tous les HJ à 0
                  END LOOP ;


                COMMIT ;


      END ;


     RETURN  l_num_seq ;


EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        --ROLLBACK;
         Pack_Global.recuperer_message(20370, NULL, NULL, NULL, p_message);
        RAISE_APPLICATION_ERROR( -20370, p_message );

     WHEN OTHERS THEN
        --ROLLBACK;
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END INSERT_ETAT_SUIVI_FINANCIER_KE;




/************************************************************************************/
/*                                                                                  */
/*     ETATS SYNTHESE DU COPI                                                       */
/*     p_type_etat  INDIQUE QUEL ETAT IL FAUT GENERER                               */
/************************************************************************************/

FUNCTION INSERT_TMP_COPI_SYNTHESE(
                p_dpcopi IN VARCHAR2 ,
                p_annee  IN VARCHAR2  ,
                p_clicode IN VARCHAR2,
                p_type_etat IN NUMBER)  RETURN NUMBER IS



        l_numseq NUMBER ;
        l_numseq_realises NUMBER ;
        l_numseq_budgets NUMBER ;

        l_etat_annee_dir NUMBER ;
        l_etat_annee_metier NUMBER ;
        l_etat_annee_dpcopi NUMBER ;

        CURSOR curseur_etat_annee_dir ( l_numseq_realises NUMBER , l_numseq_budgets NUMBER ) IS

           /* SELECT
                  DECODE ( lb.DP_COPI, NULL, budg.DP_COPI, lb.DP_COPI) DP_COPI,
                  DECODE (lb.LIBELLE,NULL, budg.LIBELLE,lb.LIBELLE) LIBELLE,
                  DECODE ( lb.ANNEE  ,NULL , budg.ANNEE    ,lb.ANNEE  ) ANNEE ,
                  --DECODE ( lb.CODE_DIR ,NULL ,   budg.CODE_DIR ,lb.CODE_DIR ) CODE_DIR,
                  --DECODE ( lb.LIB_DIR ,NULL ,   budg.LIB_DIR ,lb.LIB_DIR )  LIB_DIR,
                  DECODE ( lb.CLICODE ,NULL ,   budg.CLICODE ,lb.CLICODE )  CLICODE,
                  DECODE ( lb.CLISIGLE ,NULL ,   budg.CLISIGLE ,lb.CLISIGLE )  CLISIGLE,
                  lb.JH_REALISES    ,--     NUMBER(12,3),
                  lb.JH_REESTIMES   ,--     NUMBER(12,3),
                  lb.JH_EXTRAPOLES  ,--     NUMBER(12,3),
                  lb.EU_REALISES    ,--     NUMBER(12,3),
                  lb.EU_REESTIMES   ,--     NUMBER(12,3),
                  lb.EU_EXTRAPOLES ,--      NUMBER(12,3),
                  budg.JH_COUTTOTAL     ,--   NUMBER(12,3),
                  budg.JH_ARBDEMANDES   ,--   NUMBER(12,3),
                  budg.JH_ARBDECIDES    ,--   NUMBER(12,3),
                  budg.JH_CANTDEMANDES  ,--   NUMBER(12,3),
                  budg.JH_CANTDECIDES   ,--   NUMBER(12,3),
                  budg.EU_COUTTOTAL      ,--  NUMBER(12,3),
                  budg.EU_ARBDEMANDES   ,--   NUMBER(12,3),
                  budg.EU_ARBDECIDES    ,--   NUMBER(12,3),
                  budg.EU_CANTDEMANDES  ,--   NUMBER(12,3),
                  budg.EU_CANTDECIDES    --   NUMBER(12,3),
                    FROM( SELECT * FROM TMP_COPI_LIGNES_BIP
                        WHERE   NUMSEQ = l_numseq_realises )  lb
                      FULL OUTER JOIN
                      ( SELECT * FROM TMP_COPI_BUDGET
                        WHERE   NUMSEQ = l_numseq_budgets ) budg
                        ON    lb.DP_COPI = budg.DP_COPI
                        AND lb.annee = budg.annee
                        AND  lb.CLICODE = budg.CLICODE ;*/
               SELECT
                  DP_COPI,
                  LIBELLE,
                  ANNEE  ,
                  CLICODE  ,
                  CLISIGLE  ,
                  JH_REALISES    ,--     NUMBER(12,3),
                  JH_REESTIMES   ,--     NUMBER(12,3),
                  JH_EXTRAPOLES  ,--     NUMBER(12,3),
                  EU_REALISES    ,--     NUMBER(12,3),
                  EU_REESTIMES   ,--     NUMBER(12,3),
                  EU_EXTRAPOLES ,--      NUMBER(12,3),
                  NULL JH_COUTTOTAL     ,--   NUMBER(12,3),
                  NULL JH_ARBDEMANDES   ,--   NUMBER(12,3),
                  NULL JH_ARBDECIDES    ,--   NUMBER(12,3),
                  NULL JH_CANTDEMANDES  ,--   NUMBER(12,3),
                  NULL JH_CANTDECIDES   ,--   NUMBER(12,3),
                  NULL EU_COUTTOTAL     ,--  NUMBER(12,3),
                  NULL EU_ARBDEMANDES   ,--   NUMBER(12,3),
                  NULL EU_ARBDECIDES    ,--   NUMBER(12,3),
                  NULL EU_CANTDEMANDES  ,--   NUMBER(12,3),
                  NULL EU_CANTDECIDES    --   NUMBER(12,3),
                  FROM TMP_COPI_LIGNES_BIP
                      UNION all
                  SELECT
                  DP_COPI,
                  LIBELLE,
                  ANNEE  ,
                  CLICODE  ,
                  CLISIGLE ,
                  NULL JH_REALISES    ,--     NUMBER(12,3),
                  NULL JH_REESTIMES   ,--     NUMBER(12,3),
                  NULL JH_EXTRAPOLES  ,--     NUMBER(12,3),
                  NULL EU_REALISES    ,--     NUMBER(12,3),
                  NULL EU_REESTIMES  ,--     NUMBER(12,3),
                  NULL EU_EXTRAPOLES  ,--      NUMBER(12,3),
                  JH_COUTTOTAL     ,--   NUMBER(12,3),
                  JH_ARBDEMANDES   ,--   NUMBER(12,3),
                  JH_ARBDECIDES    ,--   NUMBER(12,3),
                  JH_CANTDEMANDES  ,--   NUMBER(12,3),
                  JH_CANTDECIDES   ,--   NUMBER(12,3),
                  EU_COUTTOTAL     ,--  NUMBER(12,3),
                  EU_ARBDEMANDES   ,--   NUMBER(12,3),
                  EU_ARBDECIDES    ,--   NUMBER(12,3),
                  EU_CANTDEMANDES  ,--   NUMBER(12,3),
                  EU_CANTDECIDES    --   NUMBER(12,3),
                  FROM TMP_COPI_BUDGET
                  WHERE
                  CATEGORIE_DEPENSE = 'Prestations';




        CURSOR curseur_etat_annee_metier ( l_numseq_realises NUMBER , l_numseq_budgets NUMBER ) IS

           /* SELECT
                  DECODE ( lb.DP_COPI, NULL, budg.DP_COPI, lb.DP_COPI) DP_COPI,
                  DECODE (lb.LIBELLE,NULL, budg.LIBELLE,lb.LIBELLE) LIBELLE,
                  DECODE ( lb.ANNEE  ,NULL , budg.ANNEE    ,lb.ANNEE  ) ANNEE ,
                  --DECODE ( lb.CODE_DIR ,NULL ,   budg.CODE_DIR ,lb.CODE_DIR ) CODE_DIR,
                  --DECODE ( lb.LIB_DIR ,NULL ,   budg.LIB_DIR ,lb.LIB_DIR )  LIB_DIR,
                  DECODE ( lb.METIER ,NULL ,   budg.METIER,lb.METIER )  METIER,
                  DECODE ( lb.CLICODE ,NULL ,   budg.CLICODE ,lb.CLICODE )  CLICODE,
                  DECODE ( lb.CLISIGLE ,NULL ,   budg.CLISIGLE ,lb.CLISIGLE )  CLISIGLE,
                  lb.JH_REALISES    ,--     NUMBER(12,3),
                  lb.JH_REESTIMES   ,--     NUMBER(12,3),
                  lb.JH_EXTRAPOLES  ,--     NUMBER(12,3),
                  lb.EU_REALISES    ,--     NUMBER(12,3),
                  lb.EU_REESTIMES   ,--     NUMBER(12,3),
                  lb.EU_EXTRAPOLES ,--      NUMBER(12,3),
                  budg.JH_COUTTOTAL     ,--   NUMBER(12,3),
                  budg.JH_ARBDEMANDES   ,--   NUMBER(12,3),
                  budg.JH_ARBDECIDES    ,--   NUMBER(12,3),
                  budg.JH_CANTDEMANDES  ,--   NUMBER(12,3),
                  budg.JH_CANTDECIDES   ,--   NUMBER(12,3),
                  budg.EU_COUTTOTAL      ,--  NUMBER(12,3),
                  budg.EU_ARBDEMANDES   ,--   NUMBER(12,3),
                  budg.EU_ARBDECIDES    ,--   NUMBER(12,3),
                  budg.EU_CANTDEMANDES  ,--   NUMBER(12,3),
                  budg.EU_CANTDECIDES    --   NUMBER(12,3),
                    FROM( SELECT * FROM TMP_COPI_LIGNES_BIP
                        WHERE   NUMSEQ = l_numseq_realises )  lb
                      FULL OUTER JOIN
                      ( SELECT * FROM TMP_COPI_BUDGET
                        WHERE   NUMSEQ = l_numseq_budgets ) budg
                        ON
                        -- lb.DP_COPI = budg.DP_COPI
                        lb.annee = budg.annee
                        AND  lb.CLICODE = budg.CLICODE
                        AND lb.METIER = budg.METIER ;*/
          SELECT
                  DP_COPI,
                  LIBELLE,
                  ANNEE  ,
                  METIER ,
                  CLICODE ,
                  CLISIGLE ,
                  JH_REALISES    ,--     NUMBER(12,3),
                  JH_REESTIMES   ,--     NUMBER(12,3),
                  JH_EXTRAPOLES  ,--     NUMBER(12,3),
                  EU_REALISES    ,--     NUMBER(12,3),
                  EU_REESTIMES   ,--     NUMBER(12,3),
                  EU_EXTRAPOLES  ,--      NUMBER(12,3),
                  NULL JH_COUTTOTAL     ,--   NUMBER(12,3),
                  NULL JH_ARBDEMANDES   ,--   NUMBER(12,3),
                  NULL JH_ARBDECIDES    ,--   NUMBER(12,3),
                  NULL JH_CANTDEMANDES  ,--   NUMBER(12,3),
                  NULL JH_CANTDECIDES   ,--   NUMBER(12,3),
                  NULL EU_COUTTOTAL     ,--  NUMBER(12,3),
                  NULL EU_ARBDEMANDES   ,--   NUMBER(12,3),
                  NULL EU_ARBDECIDES    ,--   NUMBER(12,3),
                  NULL EU_CANTDEMANDES  ,--   NUMBER(12,3),
                  NULL EU_CANTDECIDES    --   NUMBER(12,3),
                  FROM TMP_COPI_LIGNES_BIP
                      UNION all
                 SELECT
                  DP_COPI,
                  LIBELLE,
                  ANNEE  ,
                  METIER ,
                  CLICODE ,
                  CLISIGLE ,
                  NULL JH_REALISES    ,--     NUMBER(12,3),
                  NULL JH_REESTIMES   ,--     NUMBER(12,3),
                  NULL JH_EXTRAPOLES  ,--     NUMBER(12,3),
                  NULL EU_REALISES    ,--     NUMBER(12,3),
                  NULL EU_REESTIMES   ,--     NUMBER(12,3),
                  NULL EU_EXTRAPOLES  ,--      NUMBER(12,3),
                  JH_COUTTOTAL     ,--   NUMBER(12,3),
                  JH_ARBDEMANDES   ,--   NUMBER(12,3),
                  JH_ARBDECIDES    ,--   NUMBER(12,3),
                  JH_CANTDEMANDES  ,--   NUMBER(12,3),
                  JH_CANTDECIDES   ,--   NUMBER(12,3),
                  EU_COUTTOTAL     ,--  NUMBER(12,3),
                  EU_ARBDEMANDES   ,--   NUMBER(12,3),
                  EU_ARBDECIDES    ,--   NUMBER(12,3),
                  EU_CANTDEMANDES  ,--   NUMBER(12,3),
                  EU_CANTDECIDES    --   NUMBER(12,3),
                  FROM TMP_COPI_BUDGET
                  WHERE
                  CATEGORIE_DEPENSE = 'Prestations';



          CURSOR curseur_etat_annee_dpcopi ( l_numseq_realises NUMBER , l_numseq_budgets NUMBER ) IS
            /*SELECT
                  DECODE ( lb.DP_COPI, NULL, budg.DP_COPI, lb.DP_COPI) DP_COPI,
                  DECODE (lb.LIBELLE,NULL, budg.LIBELLE,lb.LIBELLE) LIBELLE,
                  DECODE ( lb.ANNEE  ,NULL , budg.ANNEE    ,lb.ANNEE  ) ANNEE ,
                  --DECODE ( lb.CODE_DIR ,NULL ,   budg.CODE_DIR ,lb.CODE_DIR ) CODE_DIR,
                  --DECODE ( lb.LIB_DIR ,NULL ,   budg.LIB_DIR ,lb.LIB_DIR )  LIB_DIR,
                  DECODE ( lb.METIER ,NULL ,   budg.METIER,lb.METIER )  METIER,
                  DECODE ( lb.LIBELLE_FOUR_COPI ,NULL ,   budg.LIBELLE_FOUR_COPI,lb.LIBELLE_FOUR_COPI ) LIBELLE_FOUR_COPI,
                  DECODE ( lb.CODE_FOUR_COPI ,NULL ,   budg.CODE_FOUR_COPI,lb.CODE_FOUR_COPI ) CODE_FOUR_COPI,
                  DECODE ( lb.CLICODE ,NULL ,   budg.CLICODE ,lb.CLICODE )  CLICODE,
                  DECODE ( lb.CLISIGLE ,NULL ,   budg.CLISIGLE ,lb.CLISIGLE )  CLISIGLE,
                  lb.JH_REALISES    ,--     NUMBER(12,3),
                  lb.JH_REESTIMES   ,--     NUMBER(12,3),
                  lb.JH_EXTRAPOLES  ,--     NUMBER(12,3),
                  lb.EU_REALISES    ,--     NUMBER(12,3),
                  lb.EU_REESTIMES   ,--     NUMBER(12,3),
                  lb.EU_EXTRAPOLES ,--      NUMBER(12,3),
                  budg.JH_COUTTOTAL     ,--   NUMBER(12,3),
                  budg.JH_ARBDEMANDES   ,--   NUMBER(12,3),
                  budg.JH_ARBDECIDES    ,--   NUMBER(12,3),
                  budg.JH_CANTDEMANDES  ,--   NUMBER(12,3),
                  budg.JH_CANTDECIDES   ,--   NUMBER(12,3),
                  budg.EU_COUTTOTAL      ,--  NUMBER(12,3),
                  budg.EU_ARBDEMANDES   ,--   NUMBER(12,3),
                  budg.EU_ARBDECIDES    ,--   NUMBER(12,3),
                  budg.EU_CANTDEMANDES  ,--   NUMBER(12,3),
                  budg.EU_CANTDECIDES    --   NUMBER(12,3),
                    FROM( SELECT * FROM TMP_COPI_LIGNES_BIP
                        WHERE   NUMSEQ = l_numseq_realises )  lb
                      FULL OUTER JOIN
                      ( SELECT * FROM TMP_COPI_BUDGET
                        WHERE   NUMSEQ = l_numseq_budgets ) budg
                        ON
                        lb.DP_COPI = budg.DP_COPI
                        AND lb.annee = budg.annee
                        AND lb.CODE_FOUR_COPI = budg.CODE_FOUR_COPI
                        AND lb.METIER = budg.METIER ;*/
                 SELECT
                  DP_COPI,
                  LIBELLE,
                  ANNEE  ,
                  METIER ,
                  LIBELLE_FOUR_COPI ,
                  CODE_FOUR_COPI ,
                  CLICODE ,
                  CLISIGLE ,
                  JH_REALISES    ,--     NUMBER(12,3),
                  JH_REESTIMES   ,--     NUMBER(12,3),
                  JH_EXTRAPOLES  ,--     NUMBER(12,3),
                  EU_REALISES    ,--     NUMBER(12,3),
                  EU_REESTIMES   ,--     NUMBER(12,3),
                  EU_EXTRAPOLES ,--      NUMBER(12,3),
                  NULL JH_COUTTOTAL     ,--   NUMBER(12,3),
                  NULL JH_ARBDEMANDES   ,--   NUMBER(12,3),
                  NULL JH_ARBDECIDES    ,--   NUMBER(12,3),
                  NULL JH_CANTDEMANDES  ,--   NUMBER(12,3),
                  NULL JH_CANTDECIDES   ,--   NUMBER(12,3),
                  NULL EU_COUTTOTAL      ,--  NUMBER(12,3),
                  NULL EU_ARBDEMANDES   ,--   NUMBER(12,3),
                  NULL EU_ARBDECIDES    ,--   NUMBER(12,3),
                  NULL EU_CANTDEMANDES  ,--   NUMBER(12,3),
                  NULL EU_CANTDECIDES    --   NUMBER(12,3),
                     FROM TMP_COPI_LIGNES_BIP
                  UNION all
                    SELECT
                      DP_COPI,
                      LIBELLE,
                      ANNEE  ,
                      METIER ,
                      LIBELLE_FOUR_COPI ,
                      CODE_FOUR_COPI ,
                      CLICODE ,
                      CLISIGLE ,
                      NULL JH_REALISES    ,--     NUMBER(12,3),
                      NULL JH_REESTIMES   ,--     NUMBER(12,3),
                      NULL JH_EXTRAPOLES  ,--     NUMBER(12,3),
                      NULL EU_REALISES    ,--     NUMBER(12,3),
                      NULL EU_REESTIMES   ,--     NUMBER(12,3),
                      NULL EU_EXTRAPOLES ,--      NUMBER(12,3),
                       JH_COUTTOTAL     ,--   NUMBER(12,3),
                       JH_ARBDEMANDES   ,--   NUMBER(12,3),
                       JH_ARBDECIDES    ,--   NUMBER(12,3),
                       JH_CANTDEMANDES  ,--   NUMBER(12,3),
                       JH_CANTDECIDES   ,--   NUMBER(12,3),
                       EU_COUTTOTAL      ,--  NUMBER(12,3),
                       EU_ARBDEMANDES   ,--   NUMBER(12,3),
                       EU_ARBDECIDES    ,--   NUMBER(12,3),
                       EU_CANTDEMANDES  ,--   NUMBER(12,3),
                       EU_CANTDECIDES    --   NUMBER(12,3),
                        FROM TMP_COPI_BUDGET
                          WHERE
                  CATEGORIE_DEPENSE = 'Prestations';


BEGIN

       l_etat_annee_dir := 1  ;
       l_etat_annee_metier := 2  ;
       l_etat_annee_dpcopi := 3 ;

       SELECT BIP.SETATKE.NEXTVAL INTO l_numseq FROM DUAL ;


       -- GENERATION DONNEES REALISES ET BUDGET COPI (TABLES TEMP )
     l_numseq_realises := INSERT_TMPCOPI_SYNTH_REALISE( p_dpcopi,p_annee  , p_clicode ,null) ;
    l_numseq_budgets  := INSERT_TMPCOPI_SYNTH_BUDGET( p_dpcopi,p_annee  , p_clicode ) ;

       IF (p_type_etat = l_etat_annee_dir) THEN

        FOR cur_annee_dir IN curseur_etat_annee_dir ( l_numseq_realises,l_numseq_budgets) LOOP

        INSERT INTO TMP_COPI_SYNTHESE_ETATS
        (
          DP_COPI       ,--     VARCHAR2(6),
          LIB_DP_COPI    ,--     VARCHAR2(50),
          ANNEE             ,--  NUMBER(4),
          --CODE_DIR          ,--  NUMBER(2)  ,
          --LIB_DIR          ,--  VARCHAR2(30),
          CLICODE,
          CLISIGLE,
          JH_COUTTOTAL     ,--   NUMBER(12,3),
          JH_ARBDEMANDES   ,--   NUMBER(12,3),
          JH_ARBDECIDES    ,--   NUMBER(12,3),
          JH_CANTDEMANDES   ,--  NUMBER(12,3),
          JH_CANTDECIDES    ,--  NUMBER(12,3),
          JH_REALISES       ,--  NUMBER(12,3),
          JH_REESTIMES      ,--  NUMBER(12,3),
          JH_EXTRAPOLES    ,--   NUMBER(12,3),
          EU_COUTTOTAL     ,--   NUMBER(12,3),
          EU_ARBDEMANDES    ,--  NUMBER(12,3),
          EU_ARBDECIDES     ,--  NUMBER(12,3),
          EU_CANTDEMANDES   ,--  NUMBER(12,3),
          EU_CANTDECIDES     ,-- NUMBER(12,3),
          EU_REALISES       ,--  NUMBER(12,3),
          EU_REESTIMES      ,--  NUMBER(12,3),
          EU_EXTRAPOLES     ,--  NUMBER(12,3),
          NUMSEQ            --  NUMBER
          )VALUES (
                  cur_annee_dir.DP_COPI ,
                  cur_annee_dir.LIBELLE ,
                  cur_annee_dir.ANNEE ,
                  --cur_annee_dir.CODE_DIR ,
                  --cur_annee_dir.LIB_DIR ,
                  cur_annee_dir.CLICODE ,
                  cur_annee_dir.CLISIGLE ,
                  cur_annee_dir.JH_COUTTOTAL     ,--   NUMBER(12,3),
                  cur_annee_dir.JH_ARBDEMANDES   ,--   NUMBER(12,3),
                  cur_annee_dir.JH_ARBDECIDES    ,--   NUMBER(12,3),
                  cur_annee_dir.JH_CANTDEMANDES  ,--   NUMBER(12,3),
                  cur_annee_dir.JH_CANTDECIDES   ,--   NUMBER(12,3),
                  cur_annee_dir.JH_REALISES    ,--     NUMBER(12,3),
                  cur_annee_dir.JH_REESTIMES   ,--     NUMBER(12,3),
                  cur_annee_dir.JH_EXTRAPOLES  ,--     NUMBER(12,3),
                  cur_annee_dir.EU_COUTTOTAL      ,--  NUMBER(12,3),
                  cur_annee_dir.EU_ARBDEMANDES   ,--   NUMBER(12,3),
                  cur_annee_dir.EU_ARBDECIDES    ,--   NUMBER(12,3),
                  cur_annee_dir.EU_CANTDEMANDES  ,--   NUMBER(12,3),
                  cur_annee_dir.EU_CANTDECIDES   ,--   NUMBER(12,3),
                  cur_annee_dir.EU_REALISES    ,--     NUMBER(12,3),
                  cur_annee_dir.EU_REESTIMES   ,--     NUMBER(12,3),
                  cur_annee_dir.EU_EXTRAPOLES ,--      NUMBER(12,3),
                  l_numseq
          ) ;



        END LOOP ;
       DELETE FROM TMP_COPI_LIGNES_BIP WHERE NUMSEQ = l_numseq_realises ;
     DELETE FROM TMP_COPI_BUDGET WHERE NUMSEQ =  l_numseq_budgets;
        COMMIT ;
       END IF ;





  IF (p_type_etat =  l_etat_annee_metier) THEN

        FOR cur_annee_dir IN curseur_etat_annee_metier ( l_numseq_realises,l_numseq_budgets) LOOP

        INSERT INTO TMP_COPI_SYNTHESE_ETATS
        (
          DP_COPI       ,--     VARCHAR2(6),
          LIB_DP_COPI    ,--     VARCHAR2(50),
          ANNEE             ,--  NUMBER(4),
          --CODE_DIR          ,--  NUMBER(2)  ,
          --LIB_DIR          ,--  VARCHAR2(30),
          CLICODE,
          CLISIGLE,
          METIER,
          JH_COUTTOTAL     ,--   NUMBER(12,3),
          JH_ARBDEMANDES   ,--   NUMBER(12,3),
          JH_ARBDECIDES    ,--   NUMBER(12,3),
          JH_CANTDEMANDES   ,--  NUMBER(12,3),
          JH_CANTDECIDES    ,--  NUMBER(12,3),
          JH_REALISES       ,--  NUMBER(12,3),
          JH_REESTIMES      ,--  NUMBER(12,3),
          JH_EXTRAPOLES    ,--   NUMBER(12,3),
          EU_COUTTOTAL     ,--   NUMBER(12,3),
          EU_ARBDEMANDES    ,--  NUMBER(12,3),
          EU_ARBDECIDES     ,--  NUMBER(12,3),
          EU_CANTDEMANDES   ,--  NUMBER(12,3),
          EU_CANTDECIDES     ,-- NUMBER(12,3),
          EU_REALISES       ,--  NUMBER(12,3),
          EU_REESTIMES      ,--  NUMBER(12,3),
          EU_EXTRAPOLES     ,--  NUMBER(12,3),
          NUMSEQ            --  NUMBER
          )VALUES (
                  cur_annee_dir.DP_COPI ,
                  cur_annee_dir.LIBELLE ,
                  cur_annee_dir.ANNEE ,
                  cur_annee_dir.CLICODE ,
                  cur_annee_dir.CLISIGLE ,
                  cur_annee_dir.METIER ,
                  cur_annee_dir.JH_COUTTOTAL     ,--   NUMBER(12,3),
                  cur_annee_dir.JH_ARBDEMANDES   ,--   NUMBER(12,3),
                  cur_annee_dir.JH_ARBDECIDES    ,--   NUMBER(12,3),
                  cur_annee_dir.JH_CANTDEMANDES  ,--   NUMBER(12,3),
                  cur_annee_dir.JH_CANTDECIDES   ,--   NUMBER(12,3),
                  cur_annee_dir.JH_REALISES    ,--     NUMBER(12,3),
                  cur_annee_dir.JH_REESTIMES   ,--     NUMBER(12,3),
                  cur_annee_dir.JH_EXTRAPOLES  ,--     NUMBER(12,3),
                  cur_annee_dir.EU_COUTTOTAL      ,--  NUMBER(12,3),
                  cur_annee_dir.EU_ARBDEMANDES   ,--   NUMBER(12,3),
                  cur_annee_dir.EU_ARBDECIDES    ,--   NUMBER(12,3),
                  cur_annee_dir.EU_CANTDEMANDES  ,--   NUMBER(12,3),
                  cur_annee_dir.EU_CANTDECIDES   ,--   NUMBER(12,3),
                  cur_annee_dir.EU_REALISES    ,--     NUMBER(12,3),
                  cur_annee_dir.EU_REESTIMES   ,--     NUMBER(12,3),
                  cur_annee_dir.EU_EXTRAPOLES ,--      NUMBER(12,3),
                  l_numseq
          ) ;



        END LOOP ;
        DELETE FROM TMP_COPI_LIGNES_BIP WHERE NUMSEQ = l_numseq_realises ;
        DELETE FROM TMP_COPI_BUDGET WHERE NUMSEQ =  l_numseq_budgets;
        COMMIT ;
       END IF ;





  IF (p_type_etat =  l_etat_annee_dpcopi) THEN

        FOR cur_annee_dir IN curseur_etat_annee_dpcopi ( l_numseq_realises,l_numseq_budgets) LOOP

        INSERT INTO TMP_COPI_SYNTHESE_ETATS
        (
          DP_COPI       ,--     VARCHAR2(6),
          LIB_DP_COPI    ,--     VARCHAR2(50),
          ANNEE             ,--  NUMBER(4),
          CLICODE          ,--  NUMBER(2)  ,
          CLISIGLE          ,--  VARCHAR2(30),
          METIER,
          CODE_FOUR_COPI,
          LIBELLE_FOUR_COPI,
          JH_COUTTOTAL     ,--   NUMBER(12,3),
          JH_ARBDEMANDES   ,--   NUMBER(12,3),
          JH_ARBDECIDES    ,--   NUMBER(12,3),
          JH_CANTDEMANDES   ,--  NUMBER(12,3),
          JH_CANTDECIDES    ,--  NUMBER(12,3),
          JH_REALISES       ,--  NUMBER(12,3),
          JH_REESTIMES      ,--  NUMBER(12,3),
          JH_EXTRAPOLES    ,--   NUMBER(12,3),
          EU_COUTTOTAL     ,--   NUMBER(12,3),
          EU_ARBDEMANDES    ,--  NUMBER(12,3),
          EU_ARBDECIDES     ,--  NUMBER(12,3),
          EU_CANTDEMANDES   ,--  NUMBER(12,3),
          EU_CANTDECIDES     ,-- NUMBER(12,3),
          EU_REALISES       ,--  NUMBER(12,3),
          EU_REESTIMES      ,--  NUMBER(12,3),
          EU_EXTRAPOLES     ,--  NUMBER(12,3),
          NUMSEQ            --  NUMBER
          )VALUES (
                  cur_annee_dir.DP_COPI ,
                  cur_annee_dir.LIBELLE ,
                  cur_annee_dir.ANNEE ,
                  cur_annee_dir.CLICODE ,
                  cur_annee_dir.CLISIGLE ,
                  cur_annee_dir.METIER ,
                  cur_annee_dir.CODE_FOUR_COPI,
                  cur_annee_dir.LIBELLE_FOUR_COPI,
                  cur_annee_dir.JH_COUTTOTAL     ,--   NUMBER(12,3),
                  cur_annee_dir.JH_ARBDEMANDES   ,--   NUMBER(12,3),
                  cur_annee_dir.JH_ARBDECIDES    ,--   NUMBER(12,3),
                  cur_annee_dir.JH_CANTDEMANDES  ,--   NUMBER(12,3),
                  cur_annee_dir.JH_CANTDECIDES   ,--   NUMBER(12,3),
                  cur_annee_dir.JH_REALISES    ,--     NUMBER(12,3),
                  cur_annee_dir.JH_REESTIMES   ,--     NUMBER(12,3),
                  cur_annee_dir.JH_EXTRAPOLES  ,--     NUMBER(12,3),
                  cur_annee_dir.EU_COUTTOTAL      ,--  NUMBER(12,3),
                  cur_annee_dir.EU_ARBDEMANDES   ,--   NUMBER(12,3),
                  cur_annee_dir.EU_ARBDECIDES    ,--   NUMBER(12,3),
                  cur_annee_dir.EU_CANTDEMANDES  ,--   NUMBER(12,3),
                  cur_annee_dir.EU_CANTDECIDES   ,--   NUMBER(12,3),
                  cur_annee_dir.EU_REALISES    ,--     NUMBER(12,3),
                  cur_annee_dir.EU_REESTIMES   ,--     NUMBER(12,3),
                  cur_annee_dir.EU_EXTRAPOLES ,--      NUMBER(12,3),
                  l_numseq
          ) ;



        END LOOP ;
    DELETE FROM TMP_COPI_LIGNES_BIP WHERE NUMSEQ = l_numseq_realises ;
    DELETE FROM TMP_COPI_BUDGET WHERE NUMSEQ =  l_numseq_budgets;
        COMMIT ;
       END IF ;


     return l_numseq ;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END INSERT_TMP_COPI_SYNTHESE;



PROCEDURE lister_metier_coutske ( p_userid  IN VARCHAR2,
                                  p_curseur IN OUT metierCurType
                                ) IS
   BEGIN

    OPEN p_curseur FOR
    SELECT DISTINCT metier code, metier libelle
    FROM COUT_STD_KE
    ORDER BY  code ASC ;

END lister_metier_coutske;




FUNCTION budget_en_exception (p_dpcode IN VARCHAR2,p_clicode IN VARCHAR2) RETURN NUMBER IS

    l_exception NUMBER(1) ;

BEGIN
        l_exception := 0 ;
        -- INDIQUE S'IL Y A UNE EXCEPTION
        select count(*) into l_exception from COPI_EXCEPTIONS WHERE TYPE_EXCEPTION = 'DPCODE' AND
        VALEUR = p_dpcode ;
        -- Si pas d'exception trouvée continue les tests
         IF(l_exception =0 )THEN
            select count(*) into l_exception from COPI_EXCEPTIONS WHERE TYPE_EXCEPTION = 'CLICODE' AND
            VALEUR =  p_clicode ;
         END IF ;

    RETURN l_exception ;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END budget_en_exception;


FUNCTION projet_en_exception(p_icpi IN VARCHAR2) RETURN NUMBER IS

    l_exception NUMBER(1) ;

BEGIN
        l_exception := 0 ;
        select count(*) into  l_exception from COPI_EXCEPTIONS WHERE TYPE_EXCEPTION = 'ICPI' AND
        VALEUR =  p_icpi ;
        --IF(l_exception =0  )THEN
         -- select count(*) into  l_exception from COPI_EXCEPTIONS WHERE TYPE_EXCEPTION = 'CODSG' AND
         -- VALEUR =  TO_CHAR( p_codsg ) ;
        -- END IF ;
    RETURN l_exception ;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END projet_en_exception;


FUNCTION ligneBip_en_exception(p_airt IN VARCHAR2,p_codpspe IN VARCHAR2, p_codsg IN NUMBER) RETURN NUMBER IS

    l_exception NUMBER(1) ;

BEGIN
        l_exception := 0 ;
        select count(*) into l_exception from COPI_EXCEPTIONS WHERE TYPE_EXCEPTION = 'AIRT' AND
        VALEUR = p_airt ;
        IF(l_exception =0 )THEN
            select count(*) into l_exception from COPI_EXCEPTIONS WHERE TYPE_EXCEPTION = 'CODPSPE' AND
            VALEUR = p_codpspe ;
        END IF ;

       IF(l_exception =0  )THEN
          select count(*) into  l_exception from COPI_EXCEPTIONS WHERE TYPE_EXCEPTION = 'CODSG' AND
          VALEUR =  TO_CHAR( p_codsg ) ;
        END IF ;

    RETURN l_exception ;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END ligneBip_en_exception;





FUNCTION recherche_simple_coutKE(p_annee IN NUMBER,p_metier IN VARCHAR2,p_code_fournisseur IN NUMBER, p_type_ligne_bip IN VARCHAR2) RETURN NUMBER IS


    l_cout_ke NUMBER(12,2) ;
    l_count NUMBER ;
    l_type_ligne VARCHAR2(5);

BEGIN
                   l_cout_ke := 0 ;
                   -- Depuis 2010 nous gerons 2 type de cout moyen complet les GT1 et les AUTRES avant cette année le type de ligne est TOUT
                   -- ce test est dejà effectué pour les différents etats du COPI mais pas pour l'export du portefeuille COPI
                   if (p_annee <= 2009) then
                   l_type_ligne := 'TOUT';
                   else
                    l_type_ligne := p_type_ligne_bip;
                   END if;


                   IF(p_annee  IS NOT NULL ) THEN
                       l_count := 0 ;
                       SELECT COUNT(*) INTO l_count  FROM  COUT_STD_KE cout  WHERE
                        cout.annee = p_annee  AND trim(cout.METIER) = trim(p_metier)
                        AND cout.CODE_FOUR_COPI = p_code_fournisseur
                        AND cout.type_ligne = l_type_ligne ;
                        -- SI COUT TROUVE
                        IF(l_count>0) THEN
                            SELECT DISTINCT cout.cout INTO l_cout_ke FROM  COUT_STD_KE cout
                            WHERE   cout.annee = p_annee   AND trim(cout.METIER) = trim(p_metier)
                            AND cout.CODE_FOUR_COPI =p_code_fournisseur
                            AND cout.type_ligne = l_type_ligne
                            AND ROWNUM = 1  ;

                         -- RECHERCHE COUT PAR DEFAUT  (code fournisseur = 99)
                        ELSE
                           SELECT COUNT(*) INTO l_count  FROM  COUT_STD_KE cout  WHERE
                            cout.annee = p_annee  AND trim(cout.METIER) = trim(p_metier)
                            AND cout.CODE_FOUR_COPI = 99
                            AND cout.type_ligne = l_type_ligne;
                            -- SI COUT TROUVE
                            IF(l_count>0) THEN
                                SELECT DISTINCT cout.cout INTO l_cout_ke FROM  COUT_STD_KE cout
                                WHERE   cout.annee = p_annee   AND trim(cout.METIER) = trim(p_metier)
                                AND cout.CODE_FOUR_COPI = 99
                                AND cout.type_ligne = l_type_ligne
                                AND ROWNUM = 1  ;
                            END IF ;
                        END IF ;
                   END IF ;

    RETURN l_cout_ke ;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END recherche_simple_coutKE;














/************************************************************************************/
/*                                                                                  */
/*     ETAT SYNTHESE COPI PAR METIER , ANNEE , DIRECTION CLIENT                     */
/*                                                                                  */
/************************************************************************************/









FUNCTION recherche_cout_standard_ke(p_annee IN NUMBER ,p_codsg NUMBER,p_metier VARCHAR2, p_type_ligne_bip VARCHAR2) RETURN NUMBER IS


    l_cout_ke NUMBER(12,2) ;
    l_count NUMBER  ;
    codsg_coutpardefaut NUMBER(7) ;

BEGIN


           codsg_coutpardefaut :=  9999999 ;

           l_cout_ke := 0 ;
            IF( p_annee  IS NOT NULL AND LENGTH(p_annee)>0  ) THEN
                SELECT COUNT(*) INTO l_count  FROM  COUT_STD_KE cout  WHERE
                        cout.annee = p_annee
                        AND cout.dpg_bas<=p_codsg
                        AND cout.dpg_haut>=p_codsg
                        AND cout.dpg_haut != codsg_coutpardefaut
                        AND cout.dpg_bas != codsg_coutpardefaut
                        AND trim(cout.METIER) = trim(p_metier)
                        and type_ligne = p_type_ligne_bip   ;

                        -- RECUP COUTKE
                        IF(l_count=1) THEN
                            SELECT cout.cout INTO l_cout_ke FROM  COUT_STD_KE cout  WHERE
                            cout.annee = p_annee
                            AND cout.dpg_bas<=p_codsg
                            AND cout.dpg_haut>=p_codsg
                            AND cout.dpg_haut != codsg_coutpardefaut
                            AND cout.dpg_bas != codsg_coutpardefaut
                            AND trim(cout.METIER) = trim(p_metier)
                            and type_ligne = p_type_ligne_bip
                            AND ROWNUM =1   ;
                        END IF ;

                        -- SI AUCUN COUT TROUVE : ESSAIE RECUPERE LE COUT PAR DEFAUT
                        IF(l_count=0) THEN
                            SELECT count(*) INTO l_count FROM  COUT_STD_KE cout WHERE
                            cout.annee = p_annee AND cout.dpg_haut= codsg_coutpardefaut
                            AND trim(cout.METIER)  = trim(p_metier)   ;
                            IF(l_count>0) THEN
                                SELECT cout.cout INTO l_cout_ke  FROM  COUT_STD_KE cout WHERE
                                cout.annee = p_annee AND cout.dpg_haut= codsg_coutpardefaut
                                AND trim(cout.METIER)  = trim(p_metier)
                                and type_ligne = p_type_ligne_bip
                                AND ROWNUM =1 ;
                            END IF ;
                        END IF ;

                END IF ;



        RETURN   l_cout_ke;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END recherche_cout_standard_ke;




/************************************************************************************/
/*                                                                                  */
/*     Pour état COPI SYNTHESE : insert dans table   TMP_COPI_SYNTHESE              */
/*     Reprise calculs PCA4 et SUIVI SYNTHESE pour couts simples ,reestime,consommé */
/************************************************************************************/
-- variable ecran_isac : indique que l'état à sortir est : par client avec sous traitance
-- depuis écran isac
FUNCTION INSERT_TMPCOPI_SYNTH_REALISE(
                p_dpcopi IN VARCHAR2 ,
                p_annee IN VARCHAR2 ,
                p_clicode IN VARCHAR2 ,
                p_dpcode IN NUMBER)  RETURN NUMBER IS


     l_msg VARCHAR(1024);
     p_message VARCHAR(1024);

     l_num_seq NUMBER(7);
     l_jh_consomme NUMBER(12,2);
     l_jh_reestime NUMBER(12,2);
     l_cout_consomme NUMBER(12,3);
     l_cout_reestime NUMBER(12,3);
     l_cout_consomme_nonarrondi NUMBER(12,6);
     l_cout_ke  NUMBER(12,2);
     l_cout_anneeplusun_ke  NUMBER(12,3);
     l_consomme_jh NUMBER(12,2);
     l_resteafaire NUMBER(12,6);
     l_cout_constate_non_arrondi NUMBER(12,6) ;
     
     l_immos_nonarrondi NUMBER(12,6) ;
     l_immos NUMBER(12,3);
     
     l_extrapole_jh NUMBER(12,3) ;
     l_extrapole_ke NUMBER(12,3) ;
     l_extrapole_ke_non_arrondi NUMBER(12,3) ;

     l_pourcentage  NUMBER(5,2) ;

     l_count NUMBER;

     compt NUMBER ;

     codsg_coutpardefaut NUMBER(7) ;
     l_timestamp  DATE;


     l_fait_partie_exceptions NUMBER ;

     l_annee_datdebex DATE ;

     l_libelle_fournisseur VARCHAR(50) ;
     l_code_fournisseur NUMBER(2) ;

     l_requete   VARCHAR2(5000) := 'toto';
     nom_schema VARCHAR2(20);
     l_clicode VARCHAR2(5);

    type_ligne_bip VARCHAR2(5);

    TYPE lignesCurTyp IS REF CURSOR;
    lignesCt lignesCurTyp ;


    synthCur SynthMoisCurType ;

    ligneTableTemp TMP_COUTKE_ETATS%ROWTYPE ;



      CURSOR curseur_requete(p_dpcopi VARCHAR2 ,  l_clicode VARCHAR2 , p_dpcode NUMBER ) IS

                                       -------- JOINTURE  DP_COPI et PROJ_INFO ---------------------------------------
                                       -------- exclut les '88xxx' car n'ont pas de consommés sur Lignes BIP ---------
                                       SELECT
                                                        dpc.DP_COPI,
                                                        dpc.LIBELLE,
                                                        cmo.CLISIGLE,
                                                        cmo.CLICODE,
                                                        dp.DPCODE,
                                                        dp.DPLIB ,
                                                        pr.ICPI ,
                                                        pr.ICODPROJ,
                                                        pr.CODSG ,
                                                        pr.ILIBEL  ,
                                                        dir.CODDIR ,
                                                        dir.LIBDIR
                                        FROM
                                                        DOSSIER_PROJET_COPI dpc ,
                                                        DOSSIER_PROJET dp ,
                                                        PROJ_INFO pr,
                                                        CLIENT_MO cmo,
                                                        DIRECTIONS dir
                                        WHERE
                                                  dpc.DPCODE like DECODE ( p_dpcode ,NULL,'%','','%',TO_CHAR(p_dpcode))
                                                  AND dpc.DP_COPI like DECODE ( p_dpcopi ,NULL,'%','','%',UPPER(p_dpcopi))
                                                  AND dpc.DPCODE =  dp.DPCODE
                                                  AND dp.DPCODE NOT LIKE '88%'
                                                  AND dpc.CLICODE = cmo.CLICODE
                                                  AND  cmo.CLICODE  like DECODE ( l_clicode,NULL,'%','','%',TO_CHAR( l_clicode))
                                                  AND pr.ICODPROJ NOT LIKE '88%'
                                                  AND pr.DP_COPI = dpc.DP_COPI
                                                  AND pr.ICODPROJ = dp.DPCODE
                                                  -- Périmètre BDDF (codbr = 3)
                                                  AND dir.CODDIR = cmo.clidir
                                                  -- CMA QC 1233 on ne bloque plus les clients hors BDDF
                                                  -- AND dir.codbr = 3
                                                  ORDER BY dpc.DP_COPI , pr.ICPI    ;


    -- TOUTES LES LIGNES BIP POUR UN PROJET
       CURSOR cur_lignes_bip_GrandT1( p_ICPI VARCHAR2 ) IS SELECT
              PID,
              AIRT,
              l.CODSG ,
              CODPSPE ,
              l.metier
      FROM LIGNE_BIP   l
      WHERE
          --l.metier = p_metier
          l.ICPI = p_ICPI
          AND l.TYPPROJ = 1 AND l.arctype='T1'
          ORDER BY l.metier ;


     -- Correction 04/08/2008
     -- Une ligne BIP qui n'a aucun consommé ne sera pas présente dans la table SYNTHESE_ACTIVITE
     -- par contre cela n'empêchera pas de rechercher le réestimé et procéder au calcul des autres
     -- montants.
     -- SOLUTION UNION SUR LES TABLES DONT ON A BESOIN DES DONNEES

     -- TOUS LES CONSOMMES ET REESTIMES POUR UNE LIGNE BIP (PAR ANNEE, PID)
    /* CURSOR cur_synthese_activ( l_anne NUMBER , l_pid VARCHAR2 ) IS SELECT
              PID     ,
              TYPPROJ ,
              METIER  ,
              ANNEE,
              PNOM    ,
              CODSG   ,
              DPCODE  ,
              ICPI    ,
              CODCAMO ,
              CONSOJH_SG   ,
              CONSOJH_SSII ,
              CONSOFT_SG   ,
              CONSOFT_SSII ,
              CONSOENV_SG  ,
              CONSOENV_SSII
     FROM SYNTHESE_ACTIVITE
     WHERE
     TO_CHAR(ANNEE)  like  DECODE ( l_anne,NULL,'%','','%',l_anne )
     AND TRIM(PID) = TRIM(l_pid) ;*/


   CURSOR cur_donnees( l_annee NUMBER , l_pid VARCHAR2 )  IS
        SELECT PID , ANNEE , SUM(CUSAG) CUSAG, SUM(REESTIME) REESTIME,
                             SUM(CONSOFT_SG) CONSOFT_SG,SUM(CONSOFT_SSII) CONSOFT_SSII,
                             SUM(CONSOENV_SG) CONSOENV_SG,SUM(CONSOENV_SSII) CONSOENV_SSII, SUM(IMMOS) IMMOS
        FROM
           (
            SELECT /*+ index(BUDGET BUDGET_IDX03) */ PID,ANNEE,0 CUSAG , NVL(REESTIME,0) REESTIME , 0 CONSOFT_SG,0 CONSOFT_SSII,0 CONSOENV_SG,0 CONSOENV_SSII, 0 IMMOS
            FROM BUDGET 
            WHERE TRIM(PID) = TRIM(l_pid) AND TO_CHAR(ANNEE)  like  DECODE ( l_annee,NULL,'%','','%',l_annee )
            
            UNION ALL
            
            SELECT /*+ index(ARCHIVE_BUDGET@biparch  ARCH_BUDGET_IDX1) */ PID,ANNEE,0 CUSAG , NVL(REESTIME,0) REESTIME , 0 CONSOFT_SG,0 CONSOFT_SSII,0 CONSOENV_SG,0 CONSOENV_SSII, 0 IMMOS
            FROM BIPA.ARCHIVE_BUDGET   
            WHERE TRIM(PID) = TRIM(l_pid) AND TO_CHAR(ANNEE)  like  DECODE ( l_annee,NULL,'%','','%',l_annee )
            
            UNION ALL
            
            SELECT /*+ index(SYNTHESE_ACTIVITE_MENSUEL SYNTHESE_ACTIVITE_MENS_IDX01) */ PID,ANNEE, NVL(CONSOJH_SG+CONSOJH_SSII,0) CUSAG , 0 REESTIME , CONSOFT_SG,CONSOFT_SSII,CONSOENV_SG,CONSOENV_SSII, 0 IMMOS
            FROM SYNTHESE_ACTIVITE_MENSUEL 
            WHERE TRIM(PID) = TRIM(l_pid) AND TO_CHAR(ANNEE)  like  DECODE (l_annee ,NULL,'%','','%',l_annee)
            
            UNION ALL
            
            SELECT  /*+ index(ARCHIVE_SYNTHESE_ACTIVITE@biparch ARCH_SYNTH_ACT_IDX1) */ PID,ANNEE, NVL(CONSOJH_SG+CONSOJH_SSII,0) CUSAG , 0 REESTIME , CONSOFT_SG,CONSOFT_SSII,CONSOENV_SG,CONSOENV_SSII, 0 IMMOS
            FROM BIPA.ARCHIVE_SYNTHESE_ACTIVITE
            WHERE TRIM(PID) = TRIM(l_pid) AND TO_CHAR(ANNEE)  like  DECODE (l_annee ,NULL,'%','','%',l_annee)
            -- l'archivage de la table synthese_activite_mensuel n'est pas réalisé nous gardons toutes les données depuis 2007 sur la base principale
            and annee < 2007
            
            UNION ALL
            
            SELECT PID,TO_NUMBER(TO_CHAR(CDEB,'YYYY')) ANNEE,0 CUSAG , 0 REESTIME , 0 CONSOFT_SG,0 CONSOFT_SSII,0 CONSOENV_SG,0 CONSOENV_SSII, CONSOFT IMMOS
            FROM STOCK_IMMO 
            WHERE TRIM(PID) = TRIM(l_pid) AND TO_CHAR(CDEB,'YYYY') like  DECODE ( l_annee,NULL,'%','','%',l_annee )
            
            UNION ALL
            
            SELECT /*+ index(HISTO_STOCK_IMMO HISTO_STOCK_IMMO_IDX01) */ PID,TO_NUMBER(TO_CHAR(CDEB,'YYYY')) ANNEE,0 CUSAG , 0 REESTIME , 0 CONSOFT_SG,0 CONSOFT_SSII,0 CONSOENV_SG,0 CONSOENV_SSII, CONSOFT IMMOS
            FROM HISTO_STOCK_IMMO  
            WHERE TRIM(PID) = TRIM(l_pid) AND TO_CHAR(CDEB,'YYYY') like  DECODE ( l_annee,NULL,'%','','%',l_annee )

            UNION ALL
            
            SELECT /*+ index(ARCHIVE_HISTO_STOCK_IMMO@biparch ARCH_HIST_STK_IM_IDX1) */ PID,TO_NUMBER(TO_CHAR(CDEB,'YYYY')) ANNEE,0 CUSAG , 0 REESTIME , 0 CONSOFT_SG,0 CONSOFT_SSII,0 CONSOENV_SG,0 CONSOENV_SSII, CONSOFT IMMOS
            FROM BIPA.ARCHIVE_HISTO_STOCK_IMMO
            WHERE TRIM(PID) = TRIM(l_pid) AND TO_CHAR(CDEB,'YYYY') like  DECODE ( l_annee,NULL,'%','','%',l_annee )
            
                                                
           )
        GROUP BY PID , ANNEE ;   


BEGIN

   BEGIN

            SELECT  DATDEBEX into l_annee_datdebex  FROM DATDEBEX ;

            SELECT BIP.SETATKE.NEXTVAL INTO l_num_seq FROM DUAL ;

             l_timestamp := SYSDATE ;


             if (substr(p_clicode,3,3) = '000' and length(p_clicode) = 5)
             then
                l_clicode := substr(p_clicode,1,2) || '%';
             else
                l_clicode := p_clicode;
             end if;




   -------------------------  PARCOURS  DP_COPI - PROJETS (liés à ce DPCOPI) ----------------------
    FOR curseur IN curseur_requete(p_dpcopi ,  l_clicode , p_dpcode)  LOOP

     IF(budget_en_exception(curseur.DPCODE ,curseur.CLICODE) =0) THEN

      -- VERIFIE SI PROJET PAS EN EXCEPTION ------------------
             l_fait_partie_exceptions := projet_en_exception(curseur.ICPI )  ;

             IF (l_fait_partie_exceptions = 0 ) THEN


                  ------- RECHERCHE LIGNES BIP DU PROJET  (pour calcul REALISE,REESTIME,EXTRAPOLE)  --------

                    FOR  curseur_lignes_Bip IN cur_lignes_bip_GrandT1(curseur.ICPI ) LOOP

                         BEGIN

                            l_fait_partie_exceptions := ligneBip_en_exception(curseur_lignes_Bip.AIRT,curseur_lignes_Bip.CODPSPE,curseur_lignes_Bip.CODSG)  ;
                            
                            ------------ Si ligne BIP pas en EXCEPTION ---------------------
                             IF( l_fait_partie_exceptions =0) THEN


                                                       -- SI utilisateur a saisi une ANNEE on la prend en compte sinon on prend toutes les ANNEES
                                                       -- pour chaque PID de Ligne Bip parcours SYNTHESE_ACTIVITE et BUDGET avec le PID et on
                                                       -- PREND TOUTES les ANNEES
                                     FOR cur_donnees_lignebip  IN  cur_donnees( p_annee , curseur_lignes_Bip.PID  ) LOOP
                                         BEGIN


                                                       l_extrapole_jh:=0 ;
                                                       l_extrapole_ke :=0 ;
                                                       l_extrapole_ke_non_arrondi := 0 ;
                                                       l_count := 0 ;
                                                       l_cout_consomme := 0 ;
                                                       l_consomme_jh := 0 ;
                                                       l_cout_consomme_nonarrondi :=0 ;
                                                       l_jh_reestime := 0 ;
                                                       l_cout_reestime := 0 ;
                                                       l_code_fournisseur := NULL ;
                                                       l_libelle_fournisseur := NULL ;
                                                       
                                                       l_immos_nonarrondi := 0 ;
                                                       l_immos := 0 ;
                                                              ----------------------------------------------------------------------------
                                                              ---------------------------- CALCUL REALISES -------------------------------
                                                              ----------------------------------------------------------------------------

                                                               ------------- CONSOMME NORME PCA4  --------------------


                                                               --  ETAPE 1 ) --------  RECHERCHE COUT_KE pour ANNEE,METIER,FOURNISSEUR du BUDGET_COPI
                                                                     --- Pour le copi on ne gère que les ligne de type T1 donc on utilise que les cout metier concernant les T1
                                                                    --- par conqéquent si année > 2009 alors type_ligne = GT1 sinon type_ligne = TOUT
                                                                    IF (cur_donnees_lignebip.annee >2009) THEN
                                                                       type_ligne_bip := 'GT1';
                                                                    ELSE
                                                                        type_ligne_bip := 'TOUT';
                                                                    END iF;

                                                                 l_cout_ke := recherche_cout_standard_ke(cur_donnees_lignebip.annee , curseur_lignes_Bip.codsg,  curseur_lignes_Bip.metier,  type_ligne_bip) ;


                                                               --l_consomme_jh :=  (  NVL(cur_synth_activite.CONSOJH_SG,0) + NVL(cur_synth_activite.CONSOJH_SSII,0) )  ;
                                                                l_consomme_jh := 0 ;

                                                                -- RECHERCHE CONSOMME JH    (via table consomme)
                                                                SELECT count(*) into l_count
                                                                FROM (select *  from SYNTHESE_ACTIVITE_MENSUEL union  select *  FROM BIPA.ARCHIVE_SYNTHESE_ACTIVITE where annee < 2007  ) c WHERE ANNEE = cur_donnees_lignebip.annee and  PID = cur_donnees_lignebip.PID ;


                                                                IF(l_count>0) THEN
                                                                    SELECT CONSOJH_SG+CONSOJH_SSII  into l_consomme_jh
                                                                    FROM  (select *  from SYNTHESE_ACTIVITE_MENSUEL union  select *  FROM BIPA.ARCHIVE_SYNTHESE_ACTIVITE where annee < 2007  ) c WHERE
                                                                    ANNEE = cur_donnees_lignebip.annee and  PID = cur_donnees_lignebip.PID AND ROWNUM = 1 ;
                                                                END IF;


                                                               -- CONSOMME en KEURO (non arrondi)
                                                               l_cout_consomme_nonarrondi :=   ( NVL(cur_donnees_lignebip.CONSOFT_SG,0) + NVL(cur_donnees_lignebip.CONSOFT_SSII,0) +
                                                                                             + NVL(cur_donnees_lignebip.CONSOENV_SG,0) + NVL(cur_donnees_lignebip.CONSOENV_SSII,0)  ) /1000  ;
                                                               --l_cout_consomme := ROUND(l_cout_consomme_nonarrondi,3);
                                                               -- on ne fait pas comme PCA4 ne KE on arrondi pas le consomme final
                                                               l_cout_consomme := l_cout_consomme_nonarrondi ;

                                                                ------------------- REESTIME JH --------------
                                                               SELECT COUNT(*) INTO l_count FROM  (select * from BUDGET union select * from BIPA.ARCHIVE_BUDGET ) b  WHERE  b.PID = curseur_lignes_Bip.PID AND b.ANNEE =  cur_donnees_lignebip.annee ;
                                                               IF(l_count>0) THEN
                                                                    SELECT  SUM(NVL(REESTIME,0))  into l_jh_reestime FROM (select * from BUDGET union select * from BIPA.ARCHIVE_BUDGET )  b
                                                                    WHERE  b.PID = curseur_lignes_Bip.PID  AND b.ANNEE =  cur_donnees_lignebip.annee;
                                                               END IF ;
                                                                ---------------  EXTRAPOLE JH et en KEuro -----------------
                                                                l_pourcentage := 0 ;
                                                                l_pourcentage := recherche_pourcentage(l_annee_datdebex, TO_NUMBER(p_annee)  ) ;


                                                                IF(l_pourcentage <>0)THEN
                                                                       l_extrapole_jh :=  ( l_consomme_jh*100) /l_pourcentage ;
                                                                       l_extrapole_ke_non_arrondi := ( l_cout_consomme_nonarrondi *100) /l_pourcentage ;
                                                                       -- Transforme cout Euro en KEuro
                                                                       l_extrapole_ke := l_extrapole_ke_non_arrondi;
                                                                END IF ;

                                                                ------------ REESTIME (norme PCA4 en Keuro)--------------
                                                                l_cout_reestime := recherche_reestime_euro(l_jh_reestime ,l_cout_ke  ,l_consomme_jh ,
                                                                l_cout_consomme  , l_cout_consomme_nonarrondi )  ;

                                                                ----------- CODE ET LIBELLE FOURNISSEUR VIA CODSG LIGNE BIP ---------------------
                                                                 l_code_fournisseur:= recherche_code_fournisseur(curseur_lignes_Bip.codsg , curseur_lignes_Bip.metier ,cur_donnees_lignebip.annee ) ;


                                                                 IF(l_code_fournisseur IS NOT NULL)THEN
                                                                    SELECT  c.LIBELLE_FOUR_COPI INTO l_libelle_fournisseur FROM COPI_FOUR c WHERE
                                                                    c.CODE_FOUR_COPI = l_code_fournisseur ;
                                                                 END IF ;

                                                               ----------------- Calcul d'Immobilisations --------------------------------
                                                                 l_immos_nonarrondi := cur_donnees_lignebip.IMMOS / 1000;
                                                                 l_immos := l_immos_nonarrondi;
                                                                 
                                                              ---------------------------------------------------------------------------
                                                              ---------------------------- FIN CALCULS ----------------------------------
                                                              ---------------------------------------------------------------------------

                                                                INSERT INTO TMP_COPI_LIGNES_BIP
                                                                (
                                                                  DP_COPI    ,--     VARCHAR2(6 BYTE),
                                                                  LIBELLE    ,--      VARCHAR2(50 BYTE),
                                                                  CLICODE,
                                                                  CLISIGLE   ,--      VARCHAR2(8 BYTE),
                                                                  DPCODE     ,--      NUMBER(5),
                                                                  DPLIB      ,--      VARCHAR2(50 BYTE),
                                                                  --DATE_COPI  ,--      DATE,
                                                                  ICPI       ,--      VARCHAR2(5 BYTE),
                                                                  ILIBEL     ,--      VARCHAR2(50 BYTE),
                                                                  ANNEE      ,--      NUMBER(4),
                                                                  METIER      ,--     VARCHAR2(3 BYTE),
                                                                  JH_REALISES   ,--    NUMBER(12,3),
                                                                  JH_REESTIMES  ,--   NUMBER(12,3),
                                                                  JH_EXTRAPOLES ,--   NUMBER(12,3),
                                                                  EU_REALISES   ,--   NUMBER(12,3),
                                                                  EU_REESTIMES  ,--   NUMBER(12,3),
                                                                  EU_EXTRAPOLES ,--   NUMBER(12,3),
                                                                  NUMSEQ         ,--  NUMBER,
                                                                  COUT_KE        ,--  NUMBER(12,2),
                                                                  PID,           --   VARCHAR2(4 BYTE),
                                                                  --KREAL_ARBITRE  ,--  NUMBER(12,2),
                                                                  --KREAL_CANTONNE --  NUMBER(12,2)
                                                                  CODE_FOUR_COPI , --     NUMBER(2),
                                                                  LIBELLE_FOUR_COPI ,  --   VARCHAR2(50 BYTE)
                                                                  CODE_DIR ,
                                                                  LIB_DIR, 
                                                                  EU_REAL_DONT_IMMO
                                                               ) VALUES  (
                                                                curseur.DP_COPI,
                                                                curseur.LIBELLE,
                                                                 curseur.CLICODE,
                                                                curseur.CLISIGLE,
                                                                curseur.DPCODE,
                                                                curseur.DPLIB,
                                                                --curseur.DATE_COPI,
                                                                curseur.ICPI,
                                                                curseur.ILIBEL,
                                                                cur_donnees_lignebip.annee,
                                                                curseur_lignes_Bip.METIER,
                                                                l_consomme_jh,
                                                                l_jh_reestime,
                                                                l_extrapole_jh,
                                                                l_cout_consomme, --Eur Realises
                                                                l_cout_reestime,
                                                                l_extrapole_ke,
                                                                l_num_seq,
                                                                l_cout_ke ,
                                                                curseur_lignes_Bip.PID ,
                                                                l_code_fournisseur ,
                                                                l_code_fournisseur || '-' || l_libelle_fournisseur ,
                                                                --curseur_lignes_Bip.CODDIR,
                                                                curseur.CODDIR,
                                                                --curseur_lignes_Bip.LIBDIR
                                                                curseur.LIBDIR,
                                                                l_immos
                                                                
                                                            );

                                              END;

                                     END LOOP ;

                             END IF ; -- FIN LIGNE BIP CORRECTE

                         END;

                    END LOOP ;  -- Fin parcours lignes BIP

             END IF ;  -- Fin si projet valide


           END IF;

     END LOOP ;
     -- CURSEUR BUDGET_COPI / DP COPI

     COMMIT ;

     END ;

     RETURN  l_num_seq ;


EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        --ROLLBACK;
         Pack_Global.recuperer_message(20370, NULL, NULL, NULL, p_message);
        RAISE_APPLICATION_ERROR( -20370, p_message );

     WHEN OTHERS THEN
        --ROLLBACK;
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END INSERT_TMPCOPI_SYNTH_REALISE;



FUNCTION INSERT_TMPCOPI_SYNTH_BUDGET(
                p_dpcopi  IN VARCHAR2 ,
                p_annee   IN VARCHAR2 ,
                p_clicode IN VARCHAR2  )  RETURN NUMBER IS


     l_msg VARCHAR(1024);
     p_message VARCHAR(1024);
     l_dpg_bas NUMBER(7);
     l_param VARCHAR2(100);
     l_param_requete VARCHAR2(400);
     l_annee NUMBER(4) ;
     l_annee_plusun NUMBER(4) ;
     requet  VARCHAR2(5000);
     metierExclus VARCHAR2(10);
     fin_requete VARCHAR2(500);
     last_requete VARCHAR2(2000);

     l_num_seq NUMBER(7);
         l_jh_consomme NUMBER(12,2);
         l_jh_reestime NUMBER(12,2);
     l_cout_consomme NUMBER(12,3);
     l_cout_reestime NUMBER(12,3);
     l_cout_consomme_nonarrondi NUMBER(12,6);
     l_cout_ke  NUMBER(12,2);
     l_cout_anneeplusun_ke  NUMBER(12,3);
     l_consomme_jh NUMBER(12,2);
     l_resteafaire NUMBER(12,6);
     l_cout_constate_non_arrondi NUMBER(12,6) ;



     l_somme_conso_ke NUMBER(12,3);
     l_somme_conso_jh NUMBER(12,3);
     l_somme_consomme_nonarrondi NUMBER(12,3);
     l_somme_reest_jh NUMBER(12,3);
     l_somme_reest_ke NUMBER(12,3);
     l_somme_extrapole_jh NUMBER(12,3);
     l_somme_extrapole_ke NUMBER(12,3) ;
     l_somme_extrapke_nonarrondi NUMBER(12,3) ;


     l_count NUMBER;

     compt NUMBER ;

     codsg_coutpardefaut NUMBER(7) ;


     --infos utilisateur (matricule,branche) + date du jour : timestamp
     l_coddir NUMBER(2);
     l_codbr NUMBER(2);
     l_codsg_utiilisateur NUMBER(7);
     l_anomalie VARCHAR2(500) ;
     l_timestamp  DATE;
     l_retour NUMBER(1) ;
     l_flag_anomalie_detectee NUMBER(1)  ;


     l_cusag_proplus NUMBER(12,3) ;
     l_pcpi_proplus NUMBER(5)  ;
     l_pid_proplus VARCHAR2(4) ;

     l_extrapole_jh NUMBER(12,3) ;
     l_extrapole_ke NUMBER(12,3) ;
     l_extrapole_ke_non_arrondi NUMBER(12,3) ;
     l_pourcentage  NUMBER(5,2) ;


     l_EU_COUTTOTAL NUMBER(12,3);
     l_EU_ARBDEMANDES NUMBER(12,3);
     l_EU_ARBDECIDES  NUMBER(12,3);
     l_EU_CANTDEMANDES NUMBER(12,3);
     l_EU_CANTDECIDES  NUMBER(12,3);
     l_EU_PREVISIO_DECIDE  NUMBER(12,3);

     l_fait_partie_exceptions NUMBER ;

     l_possede_projet_valide NUMBER(1) ;

     l_clicode VARCHAR2(5);

     type_ligne_bip VARCHAR2(5);

    TYPE lignesCurTyp IS REF CURSOR;
    lignesCt lignesCurTyp ;


    synthCur SynthMoisCurType ;

    ligneTableTemp TMP_COUTKE_ETATS%ROWTYPE ;


      CURSOR curseur_requete(p_dpcopi VARCHAR2, p_annee VARCHAR2 , l_clicode VARCHAR2 ) IS

        -- ------------ PARCOURS POUR UN DP_COPI -> TOUS LES BUDGETS COPI  ---------------------
                                   SELECT
                                                        dpc.DP_COPI,
                                                        dpc.LIBELLE,
                                                        cmo.CLISIGLE,
                                                        cmo.CLICODE,
                                                        dp.DPCODE,
                                                        dp.DPLIB,
                                                        bud.DATE_COPI datecopi,
                                                        typedem.libelle libtypedemande,
                                                        bud.ANNEE,
                                                        four.CODE_FOUR_COPI ||'-'||four.LIBELLE_FOUR_COPI libFournisseur,
                                                        four.CODE_FOUR_COPI code_fournisseur,
                                                        bud.METIER,
                                                        bud.JH_COUTTOTAL,
                                                        bud.JH_ARBDEMANDES,
                                                        bud.JH_ARBDECIDES,
                                                        bud.JH_CANTDEMANDES,
                                                        bud.JH_CANTDECIDES,
                                                        bud.JH_PREVIDECIDE,
                                                        dir.CODDIR,
                                                        dir.LIBDIR,
                                                        bud.CATEGORIE_DEPENSE
                                    FROM
                                                        BUDGET_COPI bud  ,
                                                        COPI_FOUR  four,
                                                        COPI_TYPE_DEMANDE typedem,
                                                        DOSSIER_PROJET_COPI dpc ,
                                                        DOSSIER_PROJET dp ,
                                                        CLIENT_MO cmo  ,
                                                        DIRECTIONS dir
                                    WHERE
                                                   bud.DP_COPI like DECODE (p_dpcopi,NULL,'%','','%',UPPER(p_dpcopi))
                                                   AND TO_CHAR(bud.annee) like  DECODE (p_annee,NULL,'%','','%',p_annee)
                                                   AND bud.DP_COPI =  dpc.DP_COPI
                                                   -- Ne pas prendre les Dossiers Projets Provisoires
                                                   ---AND SUBSTR( TRIM(dpc.DPCODE), 1,2) != '88'
                                                   -- JOINTURE INFOS SUPPLEMENTAIRES
                                                   AND bud.CODE_FOUR_COPI = four.CODE_FOUR_COPI
                                                   AND bud.CODE_TYPE_DEMANDE = typedem.CODE_TYPE_DEMANDE
                                                   AND dpc.CLICODE = cmo.CLICODE
                                                   AND dpc.DPCODE =  dp.DPCODE
                                                   AND cmo.CLIDIR = dir.CODDIR
                                                   AND cmo.CLICODE  like  DECODE (l_clicode,NULL,'%','','%',l_clicode) ;


BEGIN

   BEGIN


            -- récupération d'un numéro de séquence
            -- les données générées par deux utilisateurs seront différenciées par le NUMSEQ
            SELECT BIP.SETATKE.NEXTVAL INTO l_num_seq FROM DUAL ;



                  if (substr(p_clicode,3,3) = '000' and length(p_clicode) = 5)
             then
                l_clicode := substr(p_clicode,1,2) || '%';
             else
                l_clicode := p_clicode;
             end if;


   -- CURSEUR BUDGET_COPI / DP COPI
    FOR curseur IN curseur_requete(p_dpcopi, p_annee ,l_clicode)  LOOP

                ------------- SI BUDEGT COPI PAS PARTIE EXCEPTIONS  --------------------------
            IF(budget_en_exception(curseur.DPCODE ,curseur.CLICODE) =0) THEN


                  --  ETAPE 1 ) --------  RECHERCHE COUT_KE pour ANNEE,METIER,FOURNISSEUR du BUDGET_COPI
                  --- Pour le copi on ne gère que les ligne de type T1 donc on utilise que les cout metier concernant les T1
                  --- par conqéquent si année > 2009 alors type_ligne = GT1 sinon type_ligne = TOUT
                 IF (curseur.annee >2009) THEN
                 type_ligne_bip := 'GT1';
                 ELSE
                 type_ligne_bip := 'TOUT';
                 END iF;


                l_cout_ke := recherche_simple_coutKE(curseur.annee ,curseur.metier,curseur.code_fournisseur, type_ligne_bip) ;

                  --- ETAPE 2 )  -------- CALCUL DES COUTS DU BUDGET COPI ---------------------------

                  if (curseur.CATEGORIE_DEPENSE = 'P') then
                  l_EU_COUTTOTAL := (curseur.JH_COUTTOTAL * l_cout_ke)/1000 ;
                  l_EU_ARBDEMANDES :=  (curseur.JH_ARBDEMANDES * l_cout_ke)/1000;
                  l_EU_ARBDECIDES :=  (curseur.JH_ARBDECIDES * l_cout_ke)/1000 ;
                  l_EU_CANTDEMANDES := (curseur.JH_CANTDEMANDES * l_cout_ke)/1000;
                  l_EU_CANTDECIDES :=  (curseur.JH_CANTDECIDES * l_cout_ke)/1000;
                  l_EU_PREVISIO_DECIDE := (curseur.JH_PREVIDECIDE * l_cout_ke)/1000;
                end if;

                                -- INSERTION DONNEES LIGNE BUDGET/ DONNEES PROJET
                                         INSERT INTO TMP_COPI_BUDGET (
                                                             DP_COPI,--" VARCHAR2(6 BYTE),
                                                             LIBELLE,--" VARCHAR2(50 BYTE),
                                                             CLICODE ,
                                                             CLISIGLE,--" VARCHAR2(8 BYTE),
                                                             DPCODE,--" NUMBER(5,0),
                                                             DPLIB,--" VARCHAR2(50 BYTE),
                                                             DATE_COPI,--" DATE,
                                                             LIB_T_DEMANDE,--" VARCHAR2(50 BYTE),
                                                             ANNEE,--" NUMBER(4,0),
                                                             LIBELLE_FOUR_COPI,--" VARCHAR2(50 BYTE),
                                                             CODE_FOUR_COPI , --number(2)
                                                             METIER,--" VARCHAR2(3 BYTE),
                                                             JH_COUTTOTAL,--" NUMBER(12,2),
                                                             JH_ARBDEMANDES,--" NUMBER(12,2),
                                                             JH_ARBDECIDES,--" NUMBER(12,2),
                                                             JH_CANTDEMANDES,--" NUMBER(12,2),
                                                             JH_CANTDECIDES,--" NUMBER(12,2),
                                                             EU_COUTTOTAL,--" NUMBER(12,2),
                                                             EU_ARBDEMANDES,--" NUMBER(12,2),
                                                             EU_ARBDECIDES,--" NUMBER(12,2),
                                                             EU_CANTDEMANDES,--" NUMBER(12,2),
                                                             EU_CANTDECIDES,--" NUMBER(12,2),
                                                             NUMSEQ ,--" NUMBER
                                                             CODE_DIR,
                                                             LIB_DIR,
                                                             JH_PREVISIO_DECIDE,
                                                             EU_PREVISIO_DECIDE,
                                                             CATEGORIE_DEPENSE


                                         )  VALUES  (
                                                        curseur.DP_COPI,
                                                        curseur.LIBELLE,
                                                        curseur.CLICODE,
                                                        curseur.CLISIGLE,
                                                        curseur.DPCODE,
                                                        curseur.DPLIB,
                                                        curseur.datecopi,
                                                        curseur.libtypedemande,
                                                        curseur.ANNEE,
                                                        curseur.libFournisseur,
                                                        curseur.code_fournisseur,
                                                        curseur.METIER,
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',curseur.JH_COUTTOTAL,null),
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',curseur.JH_ARBDEMANDES,null),
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',curseur.JH_ARBDECIDES,null),
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',curseur.JH_CANTDEMANDES,null),
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',curseur.JH_CANTDECIDES,null),
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',l_EU_COUTTOTAL,curseur.JH_COUTTOTAL/1000),
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',l_EU_ARBDEMANDES,curseur.JH_ARBDEMANDES/1000),
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',l_EU_ARBDECIDES,curseur.JH_ARBDECIDES/1000),
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',l_EU_CANTDEMANDES,curseur.JH_CANTDEMANDES/1000),
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',l_EU_CANTDECIDES,curseur.JH_CANTDECIDES/1000),
                                                        l_num_seq ,
                                                        curseur.CODDIR,
                                                        curseur.LIBDIR,
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',curseur.JH_PREVIDECIDE,null),
                                                        decode(curseur.CATEGORIE_DEPENSE,'P',l_EU_PREVISIO_DECIDE,curseur.JH_PREVIDECIDE/1000),
                                                        decode(curseur.CATEGORIE_DEPENSE,'P','Prestations','L','Logiciels','M','Matériels','A','Autres',curseur.CATEGORIE_DEPENSE)
                                            );


            END IF ; -- Fin  Budget COPI pas en EXCEPTION



     END LOOP ;
     -- CURSEUR BUDGET_COPI / DP COPI

     COMMIT ;


      END ;


     RETURN  l_num_seq ;


EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        --ROLLBACK;
         Pack_Global.recuperer_message(20370, NULL, NULL, NULL, p_message);
        RAISE_APPLICATION_ERROR( -20370, p_message );

     WHEN OTHERS THEN
        --ROLLBACK;
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END INSERT_TMPCOPI_SYNTH_BUDGET;





PROCEDURE recherche_simple2_coutKE(p_annee IN VARCHAR2,p_metier IN VARCHAR2,p_code_fournisseur IN VARCHAR2,
                                   p_message  OUT VARCHAR2 , p_cout_ke  OUT VARCHAR2
                                   ) IS

    l_cout_ke NUMBER(12,2) ;
    l_count NUMBER ;
    type_ligne_bip VARCHAR2(5);

BEGIN

                --- ABA TD 884
                ---  le COPI ne concerne que les ligne T1 on ne cherche donc des cout que sur GT1 ou TOUT de la table cout_std_ke
                IF (to_number(p_annee) > 2009) THEN
                    type_ligne_bip := 'GT1';
                ELSE
                    type_ligne_bip := 'TOUT';
                END IF;

                     l_cout_ke := 0 ;
                    IF(p_annee  IS NOT NULL ) THEN
                       l_count := 0 ;
                       SELECT COUNT(*) INTO l_count  FROM  COUT_STD_KE cout  WHERE
                        cout.annee = TO_NUMBER(p_annee)  AND trim(cout.METIER) = trim(p_metier)
                        AND cout.CODE_FOUR_COPI = TO_NUMBER(p_code_fournisseur)
                        AND type_ligne = type_ligne_bip ;
                        -- SI COUT TROUVE
                        IF(l_count>0) THEN
                            SELECT DISTINCT cout.cout INTO l_cout_ke FROM  COUT_STD_KE cout
                            WHERE   cout.annee = TO_NUMBER(p_annee)   AND trim(cout.METIER) = trim(p_metier)
                            AND cout.CODE_FOUR_COPI = TO_NUMBER(p_code_fournisseur)
                            AND type_ligne = type_ligne_bip
                            AND ROWNUM = 1  ;

                        ELSE -- RECHERCHE COUT PAR DEFAUT  (code fournisseur = 99)
                           SELECT COUNT(*) INTO l_count  FROM  COUT_STD_KE cout  WHERE
                            cout.annee = p_annee  AND trim(cout.METIER) = trim(p_metier)
                            AND cout.CODE_FOUR_COPI = 99
                            AND type_ligne = type_ligne_bip ;
                            -- SI COUT TROUVE
                            IF(l_count>0) THEN
                                p_message := 'Fournisseur COPI non présent dans la table des Coûts Standards en KE, valorisation avec le coût du fournisseur COPI par défaut';
                                SELECT DISTINCT cout.cout INTO l_cout_ke FROM  COUT_STD_KE cout
                                WHERE   cout.annee = p_annee   AND trim(cout.METIER) = trim(p_metier)
                                AND cout.CODE_FOUR_COPI = 99
                                AND type_ligne = type_ligne_bip
                                AND ROWNUM = 1  ;
                            ELSE
                             p_message := 'Fournisseur COPI sélectionné et Fournisseur COPI par défaut non présents dans la table des Coûts Standards en KE, valorisation non possible';
                            END IF ;
                        END IF ;

                   END IF ;


    p_cout_ke := TO_CHAR(l_cout_ke) ;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END recherche_simple2_coutKE;






FUNCTION recherche_code_fournisseur(p_codsg IN NUMBER, p_metier IN VARCHAR2, p_annee IN NUMBER) RETURN NUMBER IS


    l_cout_ke NUMBER(12,2) ;
    l_count NUMBER ;
    l_libelle_four VARCHAR2(1000);
    l_code_four NUMBER(2) ;
    type_ligne_bip VARCHAR2(10);
BEGIN


                l_code_four := NULL  ;

                 --- ABA TD 884
                ---  le COPI ne concerne que les ligne T1 on ne cherche donc des cout que sur GT1 ou TOUT de la table cout_std_ke
                IF (to_number(p_annee) > 2009) THEN
                    type_ligne_bip := 'GT1';
                ELSE
                    type_ligne_bip := 'TOUT';
                END IF;

                -- Recherche Tranche dans COUTSTD_KE via le DPG de la ligne BIP
                SELECT count(*) into l_count
                FROM COUT_STD_KE   WHERE
                p_codsg >=  DPG_BAS AND   p_codsg <=  DPG_HAUT AND
                metier =  TRIM(p_metier)  AND  annee = p_annee
                AND type_ligne = type_ligne_bip ;



                IF(l_count>0) THEN
                    SELECT CODE_FOUR_COPI  into l_code_four FROM COUT_STD_KE   WHERE
                    p_codsg >=  DPG_BAS AND  p_codsg <=  DPG_HAUT AND
                    metier = TRIM(p_metier) AND  annee = p_annee
                    AND type_ligne = type_ligne_bip ;
                END IF ;

                -- SI ACUNE LIGNE CORRESPOND DANS COUT_ETAT_KE OU
                -- SI LE CODE RECUPERE N'EST P RENSEIGNE
                IF(l_count<=0 OR  l_code_four IS NULL) THEN
                      -- ramène le code fournisseur de la tranche DPG par défaut
                      SELECT count(*) INTO l_count FROM COUT_STD_KE   WHERE
                        DPG_BAS =  9999999 AND DPG_HAUT =  9999999 and
                      metier = TRIM(p_metier)   AND   annee = p_annee
                      AND type_ligne = type_ligne_bip ;
                      IF(l_count>0) THEN
                          SELECT CODE_FOUR_COPI into l_code_four FROM COUT_STD_KE   WHERE
                           DPG_BAS =  9999999 AND DPG_HAUT =  9999999 and
                      metier = TRIM(p_metier)   AND   annee = p_annee
                      AND type_ligne = type_ligne_bip ;
                      END IF ;

                END IF ;

    RETURN l_code_four ;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END recherche_code_fournisseur;



-- Recherche le pourcentage théorique dans la table CALENDRIER
FUNCTION recherche_pourcentage(p_datdebex IN DATE,  p_annee IN NUMBER  ) RETURN NUMBER IS

    l_cout_ke NUMBER(12,2) ;
    l_count NUMBER ;
    l_pourcentage NUMBER(12,2) ;
    l_theorique NUMBER(5,2) ;
    l_annee NUMBER(4) ;
    l_test DATE;
    l_num_trait NUMBER(1);


BEGIN
            select moismens into l_test from datdebex;
            select numtrait into l_num_trait from datdebex;

           l_annee :=  p_annee  ;
           l_theorique := 0 ;
           -- Si Année champ DatDebex de la table DatDebex = Année traitée
           -- on essaie récupérer le pourcentage

        IF l_num_trait = 1 or l_num_trait = 2 THEN

        l_test := l_test - 1;

            IF ( EXTRACT(YEAR FROM  p_datdebex) = p_annee )  THEN
                     SELECT count(*) into l_count  FROM CALENDRIER WHERE
                     EXTRACT(MONTH FROM  CALANMOIS) =    EXTRACT(MONTH FROM l_test)
                     AND EXTRACT(YEAR FROM  CALANMOIS) =  p_annee;
                IF(l_count >0 )THEN
                     SELECT theorique into l_theorique  FROM CALENDRIER WHERE
                     EXTRACT(MONTH FROM  CALANMOIS) =    EXTRACT(MONTH FROM l_test)
                     AND EXTRACT(YEAR FROM  CALANMOIS) =  p_annee;
                END IF ;
            ELSE
            -- Si année différente : on essaie récupérer le 12° mois de l'année traitée
            -- qui doit normalement être à 100 %
                SELECT count(*) into l_count FROM CALENDRIER WHERE
                EXTRACT(MONTH FROM  CALANMOIS) = 12
                AND EXTRACT(YEAR FROM  CALANMOIS) = p_annee ;
                                                                commit;
                IF(l_count >0 )THEN
                     SELECT theorique into l_theorique  FROM CALENDRIER WHERE
                     EXTRACT(MONTH FROM  CALANMOIS) = 12
                     AND EXTRACT(YEAR FROM  CALANMOIS) = p_annee ;
                END IF ;

            END IF ;

        ELSE
              IF ( EXTRACT(YEAR FROM  p_datdebex) = p_annee )  THEN
                     SELECT count(*) into l_count  FROM CALENDRIER WHERE
                     EXTRACT(MONTH FROM  CALANMOIS) =    EXTRACT(MONTH FROM l_test)
                     AND EXTRACT(YEAR FROM  CALANMOIS) =  p_annee;
                IF(l_count >0 )THEN
                     SELECT theorique into l_theorique  FROM CALENDRIER WHERE
                     EXTRACT(MONTH FROM  CALANMOIS) =    EXTRACT(MONTH FROM l_test)
                     AND EXTRACT(YEAR FROM  CALANMOIS) =  p_annee;
                END IF ;
            ELSE
            -- Si année différente : on essaie récupérer le 12° mois de l'année traitée
            -- qui doit normalement être à 100 %
                SELECT count(*) into l_count FROM CALENDRIER WHERE
                EXTRACT(MONTH FROM  CALANMOIS) = 12
                AND EXTRACT(YEAR FROM  CALANMOIS) = p_annee ;
                                                                commit;
                IF(l_count >0 )THEN
                     SELECT theorique into l_theorique  FROM CALENDRIER WHERE
                     EXTRACT(MONTH FROM  CALANMOIS) = 12
                     AND EXTRACT(YEAR FROM  CALANMOIS) = p_annee ;
                END IF ;

            END IF ;



        END IF;

            -- Remplace théorique par Zéro si jamis NULL a tété ramené
            l_theorique := NVL(l_theorique,0) ;

            return l_theorique;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END recherche_pourcentage;



-- CALCUL REESTIME EN EUROS
FUNCTION recherche_reestime_euro(l_jh_reestime IN NUMBER,l_cout_ke IN NUMBER ,l_consomme_jh IN NUMBER ,
                                 l_cout_consomme IN NUMBER , l_cout_consomme_nonarrondi IN NUMBER   ) RETURN NUMBER IS



    l_resteafaire NUMBER(12,3) ;
    l_cout_reestime NUMBER(12,3) ;
    l_cout_constate_non_arrondi NUMBER(12,3) ;

BEGIN

         l_cout_reestime := 0 ;

         IF ( l_consomme_jh = 0 ) THEN
                 -- Si le consommé en jh est  = 0 alors :
                 -- coût en k¿ du ré estimé =  (ré estimé en jh * coût)/1000
                 l_cout_reestime :=     ROUND(  (  NVL(l_jh_reestime,0) *  l_cout_ke   )/1000 , 3  ) ;
         ELSE

                 -- CALCUL DU RESTE A FAIRE : Si le consommé  est > 0  : Ràf JH = ré estimé JH - consommé JH
                 l_resteafaire :=l_jh_reestime - l_consomme_jh ;
                 --Si le ràf est = 0 :Coût en k¿ du ré estimé  =  coût en kE du consommé
                IF (l_resteafaire  = 0) THEN
                    l_cout_reestime := l_cout_consomme ;
                 ELSE
                  -- Coût constaté  = cout consommé calculé / consommé en JH
                  l_cout_constate_non_arrondi :=  ( l_cout_consomme_nonarrondi / l_consomme_jh)   ;
                END IF ;

               IF (l_resteafaire  >0  ) THEN
                 -- Coût en kE du ré estimé  =  coût en kEdu consommé + (ràf JH * coût constaté)
                 l_cout_reestime := ROUND(( l_cout_consomme_nonarrondi +    (  l_cout_constate_non_arrondi * NVL(l_resteafaire,0))),3);

               END IF;

              IF (l_resteafaire  < 0 ) THEN
                  --Coût en KE du ré estimé  =  Coût constaté  * ré-estimés en JH
                  l_cout_reestime := ROUND(  ( l_cout_constate_non_arrondi * NVL(l_jh_reestime ,0) ),3) ;
              END IF ;

         END IF ;

        RETURN  l_cout_reestime;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END recherche_reestime_euro;




-- Permet de loggeur un insert sur la table COUTSTD2 ou COUSTSG
PROCEDURE log_coutKE(p_couann IN NUMBER,p_codsg_haut  IN NUMBER ,p_codsg_bas IN NUMBER ,l_metier IN VARCHAR2  ,
                     l_time_stamp IN DATE , p_userid IN VARCHAR2 , p_nom_table IN VARCHAR2  ,
                     p_nom_colonne IN VARCHAR2 , p_val_prec IN VARCHAR2 , p_val_new IN VARCHAR2 ,type_action IN NUMBER ,
                     p_commentaire IN VARCHAR2,type_ligne in VARCHAR2 )   IS


BEGIN



            -- Fiche 596 : LOGS COUT STD
           INSERT INTO  COUT_STD_KE_LOG

            (
              ANNEE       , -- NUMBER(4),
              DPG_HAUT    , --  NUMBER(7),
              DPG_BAS     , --  NUMBER(7),
              METIER       , -- VARCHAR2(3 BYTE),

              DATE_LOG    , --  DATE                             NOT NULL,
              USER_LOG    , --  VARCHAR2(30 BYTE)                NOT NULL,
              NOM_TABLE   , --  VARCHAR2(30 BYTE)                NOT NULL,

              COLONNE     , --  VARCHAR2(30 BYTE)                NOT NULL,
              VALEUR_PREC , --  VARCHAR2(30 BYTE),
              VALEUR_NOUV , --  VARCHAR2(30 BYTE),

              TYPE_ACTION  , -- NUMBER,
              COMMENTAIRE  , --  VARCHAR2(200 BYTE)
              type_ligne
            ) VALUES  (
               p_couann ,
               p_codsg_haut,
               p_codsg_bas,
               l_metier,

               l_time_stamp ,
               p_userid ,
               p_nom_table,

               p_nom_colonne ,
               p_val_prec ,
               p_val_new ,

               type_action,
               p_commentaire,
               type_ligne
               );

EXCEPTION
    WHEN OTHERS THEN

        RAISE_APPLICATION_ERROR( -20997, SQLERRM );

END log_coutKE;



END Pack_Cout_Standard_Ke;

/
