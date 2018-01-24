-- pack_copi_budget
--
-- EQUIPE BIP 
-- 
-- Créé le 01/04/2007 par JAL - fiche (616)
-- Modifié le 
-- 02/05/2008   JAL : Modification primary key de la table
-- 13/05/2008   JAL : Modification clef de table et procédures
-- 16/05/2008   JAL : suite fiche 616 dernières modifs
-- 27/05/2008   ABA	: ajout des liste dynamique en fonction de leur présence dans buget copi pour la suppression et modification
-- 12/08/2009 ABA TD 799
-- 16/09/2009 ABA TD 799 : correction anomalie
-- 20/01/2010 YSB 
-- 10/03/2010 	YNI FDT 798
-- 17/03/2010 ABA QC 934
-- 27/04/2010	YNI FDT 798
-- 22/11/2011   BSA : QC 1268 - extension du user_rtfe de 7 a 30

CREATE OR REPLACE PACKAGE     pack_copi_Budget IS

TYPE typeDemande_Type IS RECORD (
                             code    VARCHAR2(2) ,
                             libelle    VARCHAR2(50)
                );
TYPE typeDemandeCurType IS REF CURSOR RETURN typeDemande_Type;

PROCEDURE lister_typeDemande (p_userid     IN VARCHAR2,
                               p_typeDemandeCurType IN OUT typeDemandeCurType
                                  );

/* ---------------- Gestion budget COPI -------------------------------- */
TYPE budgetCopi_View IS RECORD (
                             DP_COPI   BUDGET_COPI.DP_COPI%TYPE ,
                             ANNEE     BUDGET_COPI.ANNEE%TYPE  ,
                             DATE_COPI         BUDGET_COPI.DATE_COPI%TYPE ,
                             CODE_FOUR_COPI   BUDGET_COPI.CODE_FOUR_COPI%TYPE ,
                             METIER             BUDGET_COPI.METIER%TYPE,
                             CODE_TYPE_DEMANDE BUDGET_COPI.CODE_TYPE_DEMANDE%TYPE,
                             JH_COUTTOTAL           BUDGET_COPI.JH_COUTTOTAL%TYPE,
                             JH_ARBDEMANDES     BUDGET_COPI.JH_ARBDEMANDES%TYPE,
                             JH_ARBDECIDES         BUDGET_COPI.JH_ARBDECIDES%TYPE,
                             JH_CANTDEMANDES  BUDGET_COPI.JH_CANTDEMANDES%TYPE,
                             JH_CANTDECIDES  BUDGET_COPI.JH_CANTDECIDES%TYPE,
                             JH_PREVIDECIDE BUDGET_COPI.JH_PREVIDECIDE%TYPE
                );

 TYPE budget_copiCurType IS REF CURSOR RETURN budgetCopi_View;




PROCEDURE maj_budget_copi(p_dpcopi     IN VARCHAR2,
                                p_annee     IN VARCHAR2,
                                p_datecopi     IN VARCHAR2,
                                p_fourcopi    IN VARCHAR2,
                                p_metier     IN VARCHAR2,
                                p_typedemande     IN VARCHAR2,
                                p_jhcouttot     IN VARCHAR2,
                                p_jharbitresdemandes     IN VARCHAR2,
                                p_jharbitresdecides    IN VARCHAR2,
                                p_jhcantonnedemandes     IN VARCHAR2,
                                p_jhcantonnedecides     IN VARCHAR2,
                                p_jhprevidecide  IN VARCHAR2,
                                p_userid    IN  VARCHAR2,
                                p_message     OUT VARCHAR2
                                ) ;

------------------------------ inserer Budget Copi --------------------------------------- ----
PROCEDURE insert_budget_copi(p_dpcopi     IN VARCHAR2,
                                p_annee     IN VARCHAR2,
                                p_datecopi     IN VARCHAR2,
                                p_fourcopi    IN VARCHAR2,
                                p_metier     IN VARCHAR2,
                                p_typedemande     IN VARCHAR2,
                                p_jhcouttot     IN VARCHAR2,
                                p_jharbitresdemandes     IN VARCHAR2,
                                p_jharbitresdecides    IN VARCHAR2,
                                p_jhcantonnedemandes     IN VARCHAR2,
                                p_jhcantonnedecides     IN VARCHAR2,
                                 p_jhprevidecide  IN VARCHAR2,
                                p_userid    IN  VARCHAR2,
                                p_message     OUT VARCHAR2
                                )  ;
   ------------------------------ Supprimer Budget Copi --------------------------------------- ----
  PROCEDURE supprimer_BudgetCopi (  p_dpcopi     IN VARCHAR2,
                                    p_datecopi     IN VARCHAR2 ,
                                    p_metier     IN  VARCHAR2 ,
                                    p_annee      IN  VARCHAR2 ,
                                    p_fournisseur IN VARCHAR2 ,
                                    p_userid    IN  VARCHAR2,
                                  p_message     OUT VARCHAR2
                              ) ;
/* ---------------- Gestion Forunisseur COPI -------------------------------- */
TYPE fourCopi_Type IS RECORD (
                             fourCopi    VARCHAR2(50) ,
                             lib_fourCopi    VARCHAR2(50)
                );


TYPE fourCopieCurType IS REF CURSOR RETURN fourCopi_Type;

 PROCEDURE lister_fourCopi (p_userid     IN VARCHAR2,
                            p_fourCopieCurType IN OUT fourCopieCurType
                                  );




/* procedure d'insertion d'un Budget COPI */
/*PROCEDURE insert_budget_copi(p_dpcopi     IN VARCHAR2,
                                p_annee     IN VARCHAR2,
                                p_datecopi     IN VARCHAR2,
                                p_fourcopi    IN VARCHAR2,
                                p_metier     IN VARCHAR2,
                                p_typedemande     IN VARCHAR2,
                                p_jhcouttot     IN VARCHAR2,
                                p_jharbitresdemandes     IN VARCHAR2,
                                p_jharbitresdecides    IN VARCHAR2,
                                p_jhcantonnedemandes     IN VARCHAR2,
                                p_jhcantonnedecides     IN VARCHAR2,
                                p_kecouttot     IN VARCHAR2,
                                p_kearbitresdemandes     IN VARCHAR2,
                                p_kearbitresdecides    IN VARCHAR2,
                                p_kecantonnedemandes     IN VARCHAR2,
                                p_kecantonnedecides     IN VARCHAR2,
                                p_message     OUT VARCHAR2
                                );*/




/*---------------------- Compte le nombre de Budget COPI ---------------------------------------   */
PROCEDURE verifie_nb_budgetcopi ( p_dpcopi       IN VARCHAR2,
                                    p_datecopi   IN VARCHAR2,
                                    p_metier     IN  VARCHAR2 ,
                                    p_annee      IN  VARCHAR2 ,
                                    p_fournisseur IN  VARCHAR2 ,
                                    p_nombre_bud      OUT NUMBER,
                                    p_message     OUT VARCHAR2
                                  );


TYPE dpcopi_Type IS RECORD (
                             code    VARCHAR2(6) ,
                             libelle    VARCHAR2(60)
                );


TYPE  dpcopiCurType IS REF CURSOR RETURN  dpcopi_Type;

PROCEDURE lister_dpcopi_par_dp (p_userid     IN VARCHAR2,p_dpcode VARCHAR2  ,
                                p_dpcopiCurType IN OUT dpcopiCurType
                                  );

TYPE metier_ViewType IS RECORD( id     cout_std_ke.metier%TYPE,
					libelle   cout_std_ke.metier%TYPE ) ;


TYPE metierCurType IS REF CURSOR RETURN metier_ViewType;

PROCEDURE lister_metier_coutske ( p_userid  IN VARCHAR2,
                                  p_curseur IN OUT metierCurType
                                ) ;

  PROCEDURE lister_metier_coutskebudget  (p_userid     IN VARCHAR2,
                                p_dpcopi    IN VARCHAR2,
                                p_annee     IN VARCHAR2,
                                p_datecopi  IN VARCHAR2,
                          p_curi IN OUT metierCurType
                                  );


FUNCTION f_get_bud_prestation ( p_dpcopi 	IN VARCHAR2,
                                p_date_copi	IN VARCHAR2,
                                p_fournisseur IN NUMBER,
                                p_metier IN VARCHAR2,
                                p_CODE_TYPE_DEMANDE IN NUMBER,
                                p_ANNEE IN NUMBER,
                                p_type_bud IN NUMBER)
                                RETURN VARCHAR2;


TYPE bud_ListeViewType IS RECORD(
				 	type_bud	NUMBER,
					metier		CHAR(3),
					annee1 		VARCHAR2(15),
					annee2 		VARCHAR2(15),
					annee3 		VARCHAR2(15),
					annee4 		VARCHAR2(15),
					annee5		VARCHAR2(15),
					annee6		VARCHAR2(15)
					);

   TYPE bud_listeCurType IS REF CURSOR RETURN bud_ListeViewType;

PROCEDURE lister_copi_budget( p_dpcopi 	IN VARCHAR2,
                            p_date_copi	IN VARCHAR2,
                            p_fournisseur IN NUMBER,
                            p_CODE_TYPE_DEMANDE IN NUMBER,
                            p_curseur  IN OUT bud_listeCurType,
                            p_TYPE_DEMANDE OUT NUMBER,
                            p_annee out NUMBER
                            );

TYPE budCopiVM_View IS RECORD (
                             DATE_COPI        VARCHAR2(10) ,
                             DP_COPI            VARCHAR2(6) ,
                             ANNEE            VARCHAR2(4)  ,
                             METIER             VARCHAR2(3),
                             CODE_FOUR_COPI     VARCHAR2(3),
                             LIBELLE_FOUR       VARCHAR2(50) ,
                             CODE_TYPE_DEMANDE  VARCHAR2(3),
                             LIB_TYPE_DEMANDE  VARCHAR2(50),
                             JH_ARBDEMANDES     VARCHAR2(15),
                             JH_ARBDECIDES     VARCHAR2(15),
                             JH_CANTDEMANDES  VARCHAR2(15),
                             JH_CANTDECIDES  VARCHAR2(15),
                             JH_COUTTOTAL   VARCHAR2(15),
                             JH_PREVIDECIDE VARCHAR2(15)
                );

 TYPE budCopiVMCurType IS REF CURSOR RETURN budCopiVM_View;

PROCEDURE lister_copi_bud_valid_masse( p_date_copi    IN VARCHAR2,
                            p_dpcopi     IN VARCHAR2,
                            p_curseur  IN OUT budCopiVMCurType,
                            p_message OUT VARCHAR2
                            );


PROCEDURE UPDATE_COPI_BUDGET_MASSE( p_dpcopi     IN VARCHAR2,
                                    p_date_copi    IN VARCHAR2,
                                    p_fournisseur IN VARCHAR2,
                                    p_CODE_TYPE_DEMANDE IN VARCHAR2,
                                    p_chaine1    IN VARCHAR2,
                                      p_chaine2    IN VARCHAR2,
                                    p_chaine3    IN VARCHAR2,
                                    p_chaine4    IN VARCHAR2,
                                      p_chaine5    IN VARCHAR2,
                                    p_chaine6    IN VARCHAR2,
                                    p_userid     IN VARCHAR2,
                                       p_message   OUT VARCHAR2
                                                            );

--YNI FDT 798
--Ajout du parametre p_userid
PROCEDURE update_copi_bud_valid_masse(	p_userid 	IN VARCHAR2,
                                        p_chaine1	IN VARCHAR2,
                         p_chaine2    IN VARCHAR2,
                        p_chaine3    IN VARCHAR2,
                        p_chaine4    IN VARCHAR2,
                         p_chaine5    IN VARCHAR2,
                        p_chaine6    IN VARCHAR2,
                        p_message       OUT VARCHAR2
                      );


--YNI FDT 798
--Ajout du parametre p_userid
PROCEDURE update_valid_masse_chaine (p_user IN VARCHAR2,
                                     p_chaine IN VARCHAR2,
                                     p_message OUT VARCHAR2);

--YNI FDT 798
--Ajout du parametre p_userid
FUNCTION f_maj_masse_copi( 	p_user IN VARCHAR2,
                                    p_dpcopi 	IN VARCHAR2,
                                    p_date_copi    IN VARCHAR2,
                                    p_fournisseur IN VARCHAR2,
                                    p_CODE_TYPE_DEMANDE IN VARCHAR2,
                                    p_chaine    IN VARCHAR2)
                                RETURN VARCHAR2;

FUNCTION f_x_portefeuille_copi( p_dpcopi     IN VARCHAR2,
                                    p_date_copi    IN VARCHAR2,
                                    p_metier IN VARCHAR2,
                                    p_annee IN VARCHAR2,
                                    p_fournisseur IN VARCHAR2,
                                    p_CODE_TYPE_DEMANDE IN VARCHAR2,
                                    p_categorie_depense    IN VARCHAR2,
                                    p_type IN VARCHAR2,
                                    p_CATEGORIE_DEPENSE_demande IN VARCHAR2)
                                RETURN VARCHAR2;

--YNI FDT 798
--Procédure pour remplir les logs de MAJ du  dossier projet copi
PROCEDURE maj_budget_copi_logs (p_dp_copi     IN BUDGET_COPI_LOGS.dp_copi%TYPE,
                                p_annee  IN BUDGET_COPI_LOGS.annee%TYPE,
                                p_date_copi IN BUDGET_COPI_LOGS.date_copi%TYPE,
                                p_metier IN VARCHAR2,
                                p_code_four_copi IN VARCHAR2,
                                p_code_type_demande IN VARCHAR2,
                                p_categorie_depense IN VARCHAR2,
                                p_user_log    IN VARCHAR2,
                                p_colonne        IN VARCHAR2,
                                p_valeur_prec    IN VARCHAR2,
                                p_valeur_nouv    IN VARCHAR2,
                                p_commentaire    IN VARCHAR2);

END pack_copi_Budget;
/


CREATE OR REPLACE PACKAGE BODY     pack_copi_Budget AS




/*---------------------- Lister Fournisseurs COPI ---------------------------------------   */
PROCEDURE lister_fourCopi (p_userid     IN VARCHAR2,
                           p_fourCopieCurType IN OUT fourCopieCurType
                                  ) IS

  l_msg VARCHAR(1024);
   BEGIN

      BEGIN
         OPEN   p_fourCopieCurType FOR
          SELECT DISTINCT
                 TO_CHAR(CODE_FOUR_COPI) code,
                 CODE_FOUR_COPI  || ' - ' || LIBELLE_FOUR_COPI
          FROM COPI_FOUR ORDER BY code
         ;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_fourCopi;



PROCEDURE lister_dpcopi_par_dp (p_userid     IN VARCHAR2,
                                p_dpcode VARCHAR2  ,
                                p_dpcopiCurType IN OUT dpcopiCurType
                                  ) IS

  l_msg VARCHAR(1024);
   BEGIN

      BEGIN
         OPEN  p_dpcopiCurType FOR
          SELECT DISTINCT
                 TO_CHAR(DP_COPI) code,
                 DP_COPI || ' - ' || LIBELLE
          FROM DOSSIER_PROJET_COPI
          WHERE DPCODE = TO_NUMBER(p_dpcode)
          ORDER BY  code;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_dpcopi_par_dp;



   /*----------------------------- ----------------------------------------------*/
   PROCEDURE lister_typeDemande (p_userid     IN VARCHAR2,
                               p_typeDemandeCurType IN OUT typeDemandeCurType
                                  ) IS
      l_msg VARCHAR(1024);
       BEGIN
          BEGIN
             OPEN p_typeDemandeCurType FOR
              SELECT DISTINCT
                TO_CHAR(CODE_TYPE_DEMANDE) code ,
                libelle
              FROM COPI_TYPE_DEMANDE ORDER BY code
             ;

          EXCEPTION
             WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR( -20997, SQLERRM );
          END;
   END lister_typeDemande;




   ------------------------------ Supprimer Budget Copi --------------------------------------- ----
  PROCEDURE supprimer_BudgetCopi (  p_dpcopi     IN VARCHAR2,
                                    p_datecopi     IN VARCHAR2 ,
                                    p_metier     IN  VARCHAR2 ,
                                    p_annee      IN  VARCHAR2 ,
                                    p_fournisseur IN VARCHAR2 ,
                                    p_userid    IN  VARCHAR2,
                                  p_message     OUT VARCHAR2
                              ) IS

     l_msg VARCHAR(1024);
     referential_integrity EXCEPTION;
     PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
     --YNI FDT 798
     l_user varchar2(30);
     --Fin YNI FDT 798
     l_type_demande varchar2(6);


   BEGIN
   --YNI FDT 798
   l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
   --Fin YNI FDT 798

      BEGIN

      -- on recupère le type de demande pour pouvoir logger correctement
      -- une fiche d'evolution va etre creer lot 7.6 ou 7.7 pour retirer de la clé budget copi
      -- le code type_demande
      begin
      select CODE_TYPE_DEMANDE into l_type_demande from budget_copi
      where  DP_COPI = UPPER(p_dpcopi)  AND DATE_COPI = TO_DATE(p_datecopi,'DD/MM/YYYY')
             AND ANNEE = TO_NUMBER(p_annee) AND METIER = p_metier
             AND CODE_FOUR_COPI = TO_NUMBER(p_fournisseur)
             AND CATEGORIE_DEPENSE = 'P';

      exception
      when too_many_rows then
               l_type_demande := 'toutes';
       end;

         DELETE FROM BUDGET_COPI
                WHERE
             DP_COPI = UPPER(p_dpcopi)  AND DATE_COPI = TO_DATE(p_datecopi,'DD/MM/YYYY')
             AND ANNEE = TO_NUMBER(p_annee) AND METIER = p_metier
             AND CODE_FOUR_COPI = TO_NUMBER(p_fournisseur)
             AND CATEGORIE_DEPENSE = 'P';

          --YNI FDT 798
          maj_budget_copi_logs (p_dpcopi, p_annee,TO_DATE(p_datecopi,'DD/MM/YYYY'),p_metier,p_fournisseur,l_type_demande,'P', l_user, 'TOUTES','TOUTES','','Suppression du Budget DP COPI');
          --Fin YNI FDT 798

          EXCEPTION
             WHEN referential_integrity THEN
                Pack_Global.recuperer_message( 21100, NULL, NULL, NULL, l_msg);
                raise_application_error (-21100, l_msg);
             WHEN OTHERS THEN
                raise_application_error (-20997, SQLERRM);

      END;

        IF SQL%NOTFOUND THEN
           Pack_Global.recuperer_message(21099,'%s1',p_dpcopi ||' - ' || p_datecopi, NULL, l_msg);
           p_message := l_msg;
        ELSE
            Pack_Global.recuperer_message(21098,'%s1',p_dpcopi ||' - ' || p_datecopi , NULL, l_msg);
            p_message := l_msg;
        END IF;







 END supprimer_BudgetCopi;



/* ------------------ procedure d'insertion d'un Budget COPI ----------------------- */
PROCEDURE insert_budget_copi(p_dpcopi     IN VARCHAR2,
                                p_annee     IN VARCHAR2,
                                p_datecopi     IN VARCHAR2,
                                p_fourcopi    IN VARCHAR2,
                                p_metier     IN VARCHAR2,
                                p_typedemande     IN VARCHAR2,
                                p_jhcouttot     IN VARCHAR2,
                                p_jharbitresdemandes     IN VARCHAR2,
                                p_jharbitresdecides    IN VARCHAR2,
                                p_jhcantonnedemandes     IN VARCHAR2,
                                p_jhcantonnedecides     IN VARCHAR2 ,
                                p_jhprevidecide  IN VARCHAR2,
                                p_userid    IN  VARCHAR2,
                                p_message     OUT VARCHAR2
                                ) IS

    l_msg VARCHAR2(1024);
    --YNI FDT 798
    l_user varchar2(30);
    --Fin YNI FDT 798

   BEGIN
      --YNI FDT 798
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
      --Fin YNI FDT 798
      p_message := '';

      BEGIN


        INSERT INTO  BUDGET_COPI (
        DP_COPI  ,
        ANNEE  ,
        DATE_COPI  ,
        CODE_FOUR_COPI ,
        METIER  ,
        CODE_TYPE_DEMANDE  ,
        JH_COUTTOTAL   ,
        JH_ARBDEMANDES  ,
        JH_ARBDECIDES   ,
        JH_CANTDEMANDES  ,
        JH_CANTDECIDES,
        JH_PREVIDECIDE,
        CATEGORIE_DEPENSE    )

    VALUES(
        UPPER(p_dpcopi),
        TO_NUMBER(p_annee),
        TO_DATE(p_datecopi,'DD/MM/YYYY'),
        TO_NUMBER(p_fourcopi),
        p_metier,
        TO_NUMBER(p_typedemande),
        TO_NUMBER(p_jhcouttot),
        TO_NUMBER(p_jharbitresdemandes),
        TO_NUMBER(p_jharbitresdecides),
        TO_NUMBER(p_jhcantonnedemandes),
        TO_NUMBER(p_jhcantonnedecides),
         to_number(p_jhprevidecide)  ,
         'P'
     ) ;

     --YNI FDT 798
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'DP_COPI', '', UPPER(p_dpcopi),'Création du DP copi');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'ANNEE', '', p_annee,'Création de l''annee de reference');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'DATE_COPI', '', p_datecopi,'Création de la date copi');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'CODE_FOUR_COPI', '', p_fourcopi,'Création du code four copi');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'METIER', '', p_metier,'Création du metier');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'CODE_TYPE_DEMANDE', '', p_typedemande,'Création du type demande');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_COUTTOTAL', '', p_jhcouttot,'Création du cout total en JH');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_ARBDEMANDES', '', p_jharbitresdemandes,'Création de l''arbitré demandé en JH');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_ARBDECIDES', '', p_jharbitresdecides,'Création de l''arbitré décidés en JH');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_CANTDEMANDES', '', p_jhcantonnedemandes,'Création du cantonné demandé en JH');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_CANTDECIDES', '', p_jhcantonnedecides,'Création du cantonné décidé en JH');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_PREVIDECIDE', '', p_jhprevidecide,'Création du previsionnel décidé en JH');
     maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), TO_DATE(p_datecopi,'DD/MM/YYYY'), p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'CATEGORIE_DEPENSE', '', 'P','Création de la categorie depense');
     --Fin YNI FDT 798
     COMMIT;

      Pack_Global.recuperer_message(21097,'%s1',p_dpcopi ||' - ' || p_datecopi ||' - ' ||p_annee||' - ' || p_metier , NULL, l_msg);
      p_message :=  l_msg ;

     EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
              -- pack_global.recuperer_message( 21112, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR(  -20997 ,  SQLERRM);

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);

     END;

   END insert_budget_copi;



/* ------------------ procedure de MAJ d'un Budget COPI ----------------------- */
PROCEDURE maj_budget_copi(p_dpcopi     IN VARCHAR2,
                                p_annee     IN VARCHAR2,
                                p_datecopi     IN VARCHAR2,
                                p_fourcopi    IN VARCHAR2,
                                p_metier     IN VARCHAR2,
                                p_typedemande     IN VARCHAR2,
                                p_jhcouttot     IN VARCHAR2,
                                p_jharbitresdemandes     IN VARCHAR2,
                                p_jharbitresdecides    IN VARCHAR2,
                                p_jhcantonnedemandes     IN VARCHAR2,
                                p_jhcantonnedecides     IN VARCHAR2 ,
                                  p_jhprevidecide  IN VARCHAR2,
                                p_userid    IN  VARCHAR2,
                                p_message     OUT VARCHAR2
                                )
                                 IS

    l_msg VARCHAR2(1024);
    --YNI FDT 798
    l_user varchar2(30);
    old_CODE_FOUR_COPI VARCHAR2(30);
    old_CODE_TYPE_DEMANDE VARCHAR2(30);
    old_JH_COUTTOTAL VARCHAR2(30);
    old_JH_ARBDEMANDES VARCHAR2(30);
    old_JH_ARBDECIDES VARCHAR2(30);
    old_JH_CANTDEMANDES VARCHAR2(30);
    old_JH_CANTDECIDES VARCHAR2(30);
    old_JH_PREVIDECIDE VARCHAR2(30);
    --Fin YNI FDT 798
   BEGIN

        --YNI FDT 798
        l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
        --Fin YNI FDT 798
        BEGIN

          SELECT CODE_FOUR_COPI,CODE_TYPE_DEMANDE,JH_COUTTOTAL,JH_ARBDEMANDES,JH_ARBDECIDES,JH_CANTDEMANDES,JH_CANTDECIDES,JH_PREVIDECIDE
          INTO old_CODE_FOUR_COPI,old_CODE_TYPE_DEMANDE,old_JH_COUTTOTAL,old_JH_ARBDEMANDES,old_JH_ARBDECIDES,old_JH_CANTDEMANDES,old_JH_CANTDECIDES,old_JH_PREVIDECIDE
          FROM BUDGET_COPI
          WHERE DP_COPI = UPPER(p_dpcopi) AND DATE_COPI= p_datecopi
            AND DATE_COPI =  TO_DATE(p_datecopi,'DD/MM/YYYY')
            AND ANNEE = TO_NUMBER(p_annee)
            AND METIER = p_metier
			      AND CODE_FOUR_COPI = to_number(p_fourcopi)
            AND CATEGORIE_DEPENSE='P';

          UPDATE
              BUDGET_COPI SET
            --ANNEE     = TO_NUMBER(p_annee),
            CODE_FOUR_COPI =   TO_NUMBER(p_fourcopi),
            --METIER =p_metier ,
            CODE_TYPE_DEMANDE =TO_NUMBER(p_typedemande) ,
            JH_COUTTOTAL   = TO_NUMBER(p_jhcouttot) ,
            JH_ARBDEMANDES = TO_NUMBER(p_jharbitresdemandes) ,
            JH_ARBDECIDES  = TO_NUMBER(p_jharbitresdecides) ,
            JH_CANTDEMANDES = TO_NUMBER(p_jhcantonnedemandes) ,
            JH_CANTDECIDES  = TO_NUMBER(p_jhcantonnedecides),
             JH_PREVIDECIDE = to_number(p_jhprevidecide)
            WHERE DP_COPI = UPPER(p_dpcopi) AND DATE_COPI= p_datecopi
            AND DATE_COPI =  TO_DATE(p_datecopi,'DD/MM/YYYY')
            AND ANNEE = TO_NUMBER(p_annee)
            AND METIER = p_metier
			and CODE_FOUR_COPI = to_number(p_fourcopi)
            and CATEGORIE_DEPENSE='P';

              Pack_Global.recuperer_message(21095,'%s1',p_dpcopi ||' - ' || p_datecopi ||' - ' ||p_annee||' - ' || p_metier , NULL, l_msg);
              p_message :=  l_msg ;

         --YNI FDT 798
         maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), p_datecopi, p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'CODE_FOUR_COPI', old_CODE_FOUR_COPI, p_fourcopi, 'Modification du code four copi');
         maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), p_datecopi, p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'CODE_TYPE_DEMANDE', old_CODE_TYPE_DEMANDE, p_typedemande, 'Modification du type demande');
         maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), p_datecopi, p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_COUTTOTAL', old_JH_COUTTOTAL, p_jhcouttot, 'Modification du cout total en JH');
         maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), p_datecopi, p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_ARBDEMANDES', old_JH_ARBDEMANDES, p_jharbitresdemandes, 'Modification de l''arbitré demandé en JH');
         maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), p_datecopi, p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_ARBDECIDES', old_JH_ARBDECIDES, p_jharbitresdecides, 'Modification de l''arbitré décidés en JH');
         maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), p_datecopi, p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_CANTDEMANDES', old_JH_CANTDEMANDES, p_jhcantonnedemandes, 'Modification du cantonné demandé en JH');
         maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), p_datecopi, p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_CANTDECIDES', old_JH_CANTDECIDES, p_jhcantonnedecides, 'Modification du previsionnel décidé en JH');
         maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(p_annee), p_datecopi, p_metier, p_fourcopi, p_typedemande, 'P', l_user, 'JH_PREVIDECIDE', old_JH_PREVIDECIDE, p_jhprevidecide, 'Modification du previsionnel décidé en JH');
         --Fin YNI FDT 798

         EXCEPTION

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20997, SQLERRM);
          END;

        IF SQL%NOTFOUND THEN
           Pack_Global.recuperer_message(21099,'%s1',p_dpcopi ||' - ' || p_datecopi, NULL, l_msg);
           p_message := l_msg;
        ELSE
           Pack_Global.recuperer_message(21095,'%s1',p_dpcopi ||' - ' || p_datecopi , NULL, l_msg);
           p_message := l_msg;
        END IF;


  END maj_budget_copi;




/*---------------------- compte le nombre de Budget COPI ---------------------------------------   */
/* Renvoie -1 si le DPCOPI n'existe pas sinon renvoie le nombre de couples DP_COPI/DATE_COPI
existants dans table BUDGET_COPI* (0 à n) */
PROCEDURE verifie_nb_budgetcopi (   p_dpcopi     IN VARCHAR2,
                                    p_datecopi   IN VARCHAR2,
                                    p_metier     IN  VARCHAR2 ,
                                    p_annee      IN  VARCHAR2 ,
                                    p_fournisseur IN VARCHAR2 ,
                                    p_nombre_bud OUT NUMBER,
                                    p_message    OUT VARCHAR2
                                  ) IS

  l_msg VARCHAR(1024);
  l_nombre_trouve NUMBER ;
   BEGIN

      BEGIN

          --SELECT count(*) INTO l_nombre_trouve from DOSSIER_PROJET_COPI
          --WHERE
          --DP_COPI = p_dpcopi ;
          --IF(l_nombre_trouve<=0)THEN
           --   p_nombre_bud := -1 ;
          --ELSE
             SELECT count(*) INTO p_nombre_bud from BUDGET_COPI
             WHERE
             DP_COPI = UPPER(p_dpcopi)  AND DATE_COPI = TO_DATE(p_datecopi,'DD/MM/YYYY')
             AND ANNEE = TO_NUMBER(p_annee) AND METIER = p_metier
             AND CODE_FOUR_COPI = TO_NUMBER(p_fournisseur)
             and CATEGORIE_DEPENSE='P';
         -- END IF ;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
END verifie_nb_budgetcopi;



PROCEDURE lister_metier_coutske ( p_userid  IN VARCHAR2,
                                  p_curseur IN OUT metierCurType
                                ) IS
   BEGIN

    OPEN p_curseur FOR
    SELECT DISTINCT metier code, metier libelle
	FROM COUT_STD_KE
	ORDER BY  code ASC ;

END lister_metier_coutske;

       ---------------------- Lister les metiers COPI utilisées par les budgets ---------------------------------------
  PROCEDURE lister_metier_coutskebudget  (p_userid     IN VARCHAR2,
                                p_dpcopi    IN VARCHAR2,
                                p_annee     IN VARCHAR2,
                                p_datecopi  IN VARCHAR2,
                          p_curi IN OUT metierCurType
                                  ) IS

  l_msg VARCHAR(1024);
   BEGIN

      BEGIN
         OPEN p_curi FOR
            SELECT '' id,
          ' ' libelle

        FROM DUAL
        UNION
            SELECT distinct
           metier id,
           metier libelle
          FROM BUDGET_COPI
          where
          to_char(annee) = p_annee
          and dp_copi = p_dpcopi
          and to_char(date_copi,'DD/MM/YYYY') = p_datecopi

       --  group by metier
          order by libelle;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_metier_coutskebudget;



   FUNCTION f_get_bud_prestation ( 	 	p_dpcopi 	IN VARCHAR2,
				p_date_copi	IN VARCHAR2,
                p_fournisseur IN NUMBER,
                p_metier IN VARCHAR2,
                p_CODE_TYPE_DEMANDE IN NUMBER,
                p_ANNEE IN NUMBER,
                p_type_bud IN NUMBER) RETURN VARCHAR2 IS

l_bud NUMBER(12,2);
l_cat_depense CHAR(1);
l_metier VARCHAR2(3);



/*
type_bud = 1 correspond au budget prévisionnel demandé
           2 correspond au budget préviosnnel decidé
           3 correspond à l'engagé précedent
           4 correspond au cantonné précédent
           5 correspond au budget demanndé
           6 correspond au budget decidé
           7 correspond au budget cantonné demandé
           8 correspond au budget cantonne decidé




*/

BEGIN

if (p_fournisseur = 99)
then
    l_cat_depense := p_metier;
    l_metier := 'NON';
else
    l_cat_depense := 'P';
    l_metier := p_metier;
end IF;



if (p_type_bud = 1) then
BEGIN

  select decode(CATEGORIE_DEPENSE,'P',nvl(jh_couttotal,0),(nvl(jh_couttotal,0)/1000)) into l_bud from budget_copi
    where
    DP_COPI=p_dpcopi
    and ANNEE = p_annee
    and DATE_COPI = to_date(p_date_copi)
    and METIER = l_metier
    and CODE_TYPE_DEMANDE = p_CODE_TYPE_DEMANDE
    and CODE_FOUR_COPI = p_fournisseur
    and CATEGORIE_DEPENSE = l_cat_depense ;

        RETURN TO_CHAR(l_bud,'FM99990');

  EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN null;
     end;
elsif (p_type_bud = 2) then
    BEGIN
        select decode(CATEGORIE_DEPENSE,'P',nvl(JH_PREVIDECIDE,0),(nvl(JH_PREVIDECIDE,0)/1000)) into l_bud from budget_copi
        where
        DP_COPI=p_dpcopi
        and ANNEE = p_annee
        and DATE_COPI = to_date(p_date_copi)
        and METIER = l_metier
        and CODE_TYPE_DEMANDE = p_CODE_TYPE_DEMANDE
        and CODE_FOUR_COPI = p_fournisseur
        and CATEGORIE_DEPENSE = l_cat_depense;

        RETURN TO_CHAR(l_bud,'FM99990');

        EXCEPTION
	    WHEN NO_DATA_FOUND THEN
		    RETURN NULL;
     end;
elsif (p_type_bud = 3) then
    BEGIN
        select nvl(sum(JH_ARBDECIDES),0) into l_bud from budget_copi
 where
        DP_COPI=p_dpcopi
        and ANNEE = p_annee
        and DATE_COPI < to_date(p_date_copi)
        and METIER = l_metier
        and CODE_FOUR_COPI = p_fournisseur
        and CATEGORIE_DEPENSE = l_cat_depense;

        IF(l_cat_depense = 'P') THEN
          RETURN TO_CHAR(l_bud,'FM99990');
        ELSE
          RETURN TO_CHAR(l_bud/1000,'FM99990');
    	END IF;

        EXCEPTION
	    WHEN NO_DATA_FOUND THEN
		    RETURN null;
     end;
elsif (p_type_bud = 4) then
    BEGIN
        select nvl(sum(JH_CANTDECIDES),0) into l_bud from budget_copi
 where
        DP_COPI=p_dpcopi
        and ANNEE = p_annee
        and DATE_COPI < to_date(p_date_copi)
        and METIER = l_metier
        and CODE_FOUR_COPI = p_fournisseur
        and CATEGORIE_DEPENSE = l_cat_depense;

        IF(l_cat_depense = 'P') THEN
          RETURN TO_CHAR(l_bud,'FM99990');
        ELSE
          RETURN TO_CHAR(l_bud/1000,'FM99990');
    	END IF;

        EXCEPTION
	    WHEN NO_DATA_FOUND THEN
		    RETURN null;
     end;
elsif (p_type_bud = 5) then
    BEGIN
        select decode(CATEGORIE_DEPENSE,'P',nvl(JH_ARBDEMANDES,0),(nvl(JH_ARBDEMANDES,0)/1000)) into l_bud from budget_copi
        where
        DP_COPI=p_dpcopi
        and ANNEE = p_annee
        and DATE_COPI = to_date(p_date_copi)
        and METIER = l_metier
        and CODE_TYPE_DEMANDE = p_CODE_TYPE_DEMANDE
        and CODE_FOUR_COPI = p_fournisseur
        and CATEGORIE_DEPENSE = l_cat_depense;

        RETURN TO_CHAR(l_bud,'FM99990');

        EXCEPTION
	    WHEN NO_DATA_FOUND THEN
		    RETURN NULL;
     end;
elsif (p_type_bud = 6) then
    BEGIN
        select decode(CATEGORIE_DEPENSE,'P',nvl(JH_ARBDECIDES,0),(nvl(JH_ARBDECIDES,0)/1000)) into l_bud from budget_copi
        where
        DP_COPI=p_dpcopi
        and ANNEE = p_annee
        and DATE_COPI = to_date(p_date_copi)
        and METIER = l_metier
        and CODE_TYPE_DEMANDE = p_CODE_TYPE_DEMANDE
        and CODE_FOUR_COPI = p_fournisseur
        and CATEGORIE_DEPENSE = l_cat_depense;

        RETURN TO_CHAR(l_bud,'FM99990');

        EXCEPTION
	    WHEN NO_DATA_FOUND THEN
		    RETURN NULL;
     end;
elsif (p_type_bud = 7) then
    BEGIN
        select decode(CATEGORIE_DEPENSE,'P',nvl(JH_CANTDEMANDES,0),(nvl(JH_CANTDEMANDES,0)/1000)) into l_bud from budget_copi
        where
        DP_COPI=p_dpcopi
        and ANNEE = p_annee
        and DATE_COPI = to_date(p_date_copi)
        and METIER = l_metier
        and CODE_TYPE_DEMANDE = p_CODE_TYPE_DEMANDE
        and CODE_FOUR_COPI = p_fournisseur
        and CATEGORIE_DEPENSE = l_cat_depense;

        RETURN TO_CHAR(l_bud,'FM99990');

        EXCEPTION
	    WHEN NO_DATA_FOUND THEN
		    RETURN NULL;
     end;
elsif (p_type_bud = 8) then
    BEGIN
        select decode(CATEGORIE_DEPENSE,'P',nvl(JH_CANTDECIDES,0),(nvl(JH_CANTDECIDES,0)/1000)) into l_bud from budget_copi
        where
        DP_COPI=p_dpcopi
        and ANNEE = p_annee
        and DATE_COPI = to_date(p_date_copi)
        and METIER = l_metier
        and CODE_TYPE_DEMANDE = p_CODE_TYPE_DEMANDE
        and CODE_FOUR_COPI = p_fournisseur
        and CATEGORIE_DEPENSE = l_cat_depense;

        RETURN TO_CHAR(l_bud,'FM99990');

        EXCEPTION
	    WHEN NO_DATA_FOUND THEN
		    RETURN NULL;
     end;




end if;


END f_get_bud_prestation ;




PROCEDURE lister_copi_budget( p_dpcopi 	IN VARCHAR2,
                            p_date_copi	IN VARCHAR2,
                            p_fournisseur IN NUMBER,
                            p_CODE_TYPE_DEMANDE IN NUMBER,
                            p_curseur  IN OUT bud_listeCurType,
                            p_TYPE_DEMANDE OUT NUMBER,
                            p_annee out NUMBER
                            ) IS

l_annee NUMBER(4);
l_type_demande NUMBER(1);


BEGIN



/* Premier affichage de l'ecran à travers l'ecran de saisie des filtres (dpcopi, date_copi et fournisseur copi)*/
IF (p_CODE_TYPE_DEMANDE is null) then

BEGIN

    select min(code_type_demande),  min(annee)
    into l_TYPE_DEMANDE, l_annee
    from budget_copi
    where
    DP_COPI = p_dpcopi
    and DATE_COPI = p_date_copi
    and CODE_FOUR_COPI = p_fournisseur;


    IF (l_annee is null) THEN

        if (substr(p_date_copi,4,2) = '01')
        then
            l_annee := to_number(substr(p_date_copi,7,4))-1;
        else
            l_annee := to_number(substr(p_date_copi,7,4));
        end if;
        l_TYPE_DEMANDE := 1;

    END IF;


    END;

p_TYPE_DEMANDE := l_TYPE_DEMANDE;
p_annee := l_annee;

if(p_fournisseur <> 99)
then
  OPEN p_curseur FOR

        select
        t.type typ_bud,
        m.metier metier,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee,t.type ) annee1,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+1,t.type) annee2,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+2,t.type ) annee3,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+3,t.type ) annee4,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+4,t.type ) annee5,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+5,t.type ) annee6
        from
        (select rownum type from budget_copi
        where rownum < 9) t,
        (select metier from metier where metier in('MO','ME','HOM')) m
        order by m.metier desc, t.type  ;
else
  OPEN p_curseur FOR

        select
        t.type typ_bud,
        m.metier metier,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee,t.type ) annee1,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+1,t.type) annee2,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+2,t.type ) annee3,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+3,t.type ) annee4,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+4,t.type ) annee5,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+5,t.type ) annee6
        from
        (select rownum type from budget_copi
        where rownum < 9) t,
        (select 'L' metier from dual
            union
        select 'M' metier from dual
        union
        select 'A' metier from dual) m
        order by m.metier desc, t.type  ;
end if;


ELSE

 select min(annee)
    into  l_annee
    from budget_copi
    where
    DP_COPI = p_dpcopi
    and DATE_COPI = p_date_copi
    and CODE_FOUR_COPI = p_fournisseur
    and CODE_TYPE_DEMANDE = p_CODE_TYPE_DEMANDE;

      IF (l_annee is null) THEN

        if (substr(p_date_copi,4,2) = '01')
        then
            l_annee := to_number(substr(p_date_copi,7,4))-1;
        else
            l_annee := to_number(substr(p_date_copi,7,4));
        end if;

    END IF;

p_TYPE_DEMANDE := p_CODE_TYPE_DEMANDE;
 l_TYPE_DEMANDE := p_CODE_TYPE_DEMANDE;
p_annee := l_annee;

if(p_fournisseur <> 99)
then
  OPEN p_curseur FOR

        select
        t.type typ_bud,
        m.metier metier,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee,t.type ) annee1,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+1,t.type) annee2,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+2,t.type ) annee3,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+3,t.type ) annee4,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+4,t.type ) annee5,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+5,t.type ) annee6
        from
        (select rownum type from budget_copi
        where rownum < 9) t,
        (select metier from metier where metier in('MO','ME','HOM')) m
        order by m.metier desc, t.type  ;
else
  OPEN p_curseur FOR

        select
        t.type typ_bud,
        m.metier metier,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee,t.type ) annee1,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+1,t.type) annee2,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+2,t.type ) annee3,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+3,t.type ) annee4,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+4,t.type ) annee5,
        pack_copi_Budget.f_get_bud_prestation(p_dpcopi,p_date_copi,p_fournisseur,m.metier,l_type_demande, l_annee+5,t.type ) annee6
        from
        (select rownum type from budget_copi
        where rownum < 9) t,
        (select 'L' metier from dual
            union
        select 'M' metier from dual
        union
        select 'A' metier from dual) m
        order by m.metier desc, t.type  ;

end if;



END IF;


END  lister_copi_budget;



PROCEDURE lister_copi_bud_valid_masse( p_date_copi    IN VARCHAR2,
                            p_dpcopi     IN VARCHAR2,
                            p_curseur  IN OUT budCopiVMCurType,
                            p_message OUT VARCHAR2
                            ) IS

 l_msg VARCHAR(1024);
 nb_ligne NUMBER(4);

BEGIN


p_message := '';

      BEGIN
         OPEN    p_curseur FOR
               select
                    to_char(b.DATE_COPI,'DD/MM/YYYY') date_copi,
                    b.DP_COPI dp_copi,
                    to_char(b.ANNEE) annee,
                    b.METIER metier,
                    f.CODE_FOUR_COPI code_four_copi,
                    f.LIBELLE_FOUR_COPI libelle_four,
                    t.CODE_TYPE_DEMANDE code_type_demande,
                    t.LIBELLE lib_type_demande,
                    TO_CHAR(JH_ARBDEMANDES,'FM99990')  JH_ARBDEMANDES,
                    TO_CHAR(JH_ARBDECIDES,'FM99990')  JH_ARBDECIDES,
                    TO_CHAR(JH_CANTDEMANDES,'FM99990') JH_CANTDEMANDES ,
                    TO_CHAR(JH_CANTDECIDES,'FM99990') JH_CANTDECIDES,
                    TO_CHAR(JH_COUTTOTAL,'FM99990')  JH_COUTTOTAL,
                    to_char(JH_PREVIDECIDE,'FM99990') JH_PREVIDECIDE
                    from budget_copi b, copi_four f, copi_type_demande t
                    where
                    CATEGORIE_DEPENSE = 'P'
                    and b.CODE_FOUR_COPI = f.CODE_FOUR_COPI
                    and b.CODE_TYPE_DEMANDE=t.CODE_TYPE_DEMANDE
                    and b.DATE_COPI = TO_DATE(p_date_copi,'DD/MM/YYYY')
                    and b.dp_copi like decode(p_dpcopi,null,'%','TOUS','%',p_dpcopi)
                    order by  dp_copi, annee, f.code_four_copi;


               select count(*)
               into nb_ligne
               from budget_copi b
               where  CATEGORIE_DEPENSE = 'P'
                   and b.DATE_COPI = TO_DATE(p_date_copi,'DD/MM/YYYY')
                    and b.dp_copi like decode(p_dpcopi,null,'%','TOUS','%',p_dpcopi)    ;


               IF (nb_ligne = 0) then
                 IF ((p_dpcopi = 'TOUS') or  (p_dpcopi = null)) THEN
                     Pack_Global.recuperer_message( 21160, '%s1', p_date_copi,NULL,NULL,null, l_msg);
                     p_message := l_msg;
                ELSE
                    Pack_Global.recuperer_message( 21158, '%s1', p_date_copi,'%s2',p_dpcopi,null, l_msg);
                    p_message := l_msg;
                end IF;
               END IF;






      END;


END  lister_copi_bud_valid_masse;


PROCEDURE UPDATE_COPI_BUDGET_MASSE( p_dpcopi 	IN VARCHAR2,
                                    p_date_copi	IN VARCHAR2,
                                    p_fournisseur IN VARCHAR2,
                                    p_CODE_TYPE_DEMANDE IN VARCHAR2,
                                    p_chaine1	IN VARCHAR2,
		  							p_chaine2	IN VARCHAR2,
									p_chaine3	IN VARCHAR2,
									p_chaine4	IN VARCHAR2,
		  							p_chaine5	IN VARCHAR2,
                                    p_chaine6	IN VARCHAR2,
									p_userid 	IN VARCHAR2,
                       	            p_message   OUT VARCHAR2) IS


l_msg VARCHAR2(100);
--YNI FDT 798
l_user varchar2(30);
--Fin YNI FDT 798

BEGIN

--YNI FDT 798
l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
--Fin YNI FDT 798

p_message :=  pack_copi_Budget.F_MAJ_MASSE_COPI(l_user,p_dpcopi,p_date_copi,p_fournisseur,p_CODE_TYPE_DEMANDE,p_chaine1);
p_message :=  pack_copi_Budget.F_MAJ_MASSE_COPI(l_user,p_dpcopi,p_date_copi,p_fournisseur,p_CODE_TYPE_DEMANDE,p_chaine2);
p_message :=  pack_copi_Budget.F_MAJ_MASSE_COPI(l_user,p_dpcopi,p_date_copi,p_fournisseur,p_CODE_TYPE_DEMANDE,p_chaine3);
p_message :=  pack_copi_Budget.F_MAJ_MASSE_COPI(l_user,p_dpcopi,p_date_copi,p_fournisseur,p_CODE_TYPE_DEMANDE,p_chaine4);
p_message :=  pack_copi_Budget.F_MAJ_MASSE_COPI(l_user,p_dpcopi,p_date_copi,p_fournisseur,p_CODE_TYPE_DEMANDE,p_chaine5);
p_message :=  pack_copi_Budget.F_MAJ_MASSE_COPI(l_user,p_dpcopi,p_date_copi,p_fournisseur,p_CODE_TYPE_DEMANDE,p_chaine6);

--YNI FDT 798
--maj_budget_copi_logs (p_dpcopi, p_annee,'','','','','', l_user, 'TOUTES','TOUTES','','Suppression du Budget DP COPI');
--Fin YNI FDT 798

Pack_Global.recuperer_message(21151,NULL,NULL, NULL, l_msg);
      p_message :=  l_msg ;


END UPDATE_COPI_BUDGET_MASSE;


PROCEDURE update_copi_bud_valid_masse(	p_userid 	IN VARCHAR2,
                                        p_chaine1	IN VARCHAR2,
                         p_chaine2    IN VARCHAR2,
                        p_chaine3    IN VARCHAR2,
                        p_chaine4    IN VARCHAR2,
                         p_chaine5    IN VARCHAR2,
                        p_chaine6    IN VARCHAR2,
                        p_message   OUT VARCHAR2
                      ) IS

--YNI FDT 798
l_user varchar2(30);
--Fin YNI FDT 798
BEGIN
--YNI FDT 798
l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
--Fin YNI FDT 798

      IF(p_chaine1 IS NOT NULL)THEN
	                update_valid_masse_chaine( l_user, p_chaine1, p_message );

                      IF(p_chaine2 IS NOT NULL)THEN
						  	     update_valid_masse_chaine(	l_user, p_chaine2, p_message );

                                    IF(p_chaine3 IS NOT NULL)THEN
	  											  update_valid_masse_chaine(	l_user, p_chaine3,  p_message );

                                                   IF(p_chaine4 IS NOT NULL)THEN
	    			   								   				 update_valid_masse_chaine(	l_user, p_chaine4, p_message );

                                                                                IF(p_chaine5 IS NOT NULL)THEN

						 																	  update_valid_masse_chaine(	l_user, p_chaine5, p_message );

                                                                                                  IF(p_chaine6 IS NOT NULL)THEN
																							 			     update_valid_masse_chaine(	l_user, p_chaine6, p_message );
                                                                                       END IF;
                                                                            END IF;
                                                          END IF;
                                END IF;
                    END IF;
      END IF;




END update_copi_bud_valid_masse;

PROCEDURE update_valid_masse_chaine (p_user	IN VARCHAR2,
                                     p_chaine IN VARCHAR2,
                                     p_message OUT VARCHAR2)

                                     IS


l_date_copi VARCHAR2(15);
l_dpcopi VARCHAR2(20);
l_annee VARCHAR2(4);
l_metier VARCHAR(3);
l_code_four_copi VARCHAR(3);
l_code_type_demande VARCHAR(3);
l_demande VARCHAR2(6);
l_decide VARCHAR2(6);
l_cant_demande VARCHAR2(6);
l_cant_decide VARCHAR2(6);
l_previ_demande VARCHAR2(6);
l_previ_decide VARCHAR2(6);
l_chaine VARCHAR2(31000);
l_pos NUMBER(12);
l_pos2 NUMBER(12);
l_pos2pt NUMBER(12);
l_msg VARCHAR2(1024);
--YNI fdt 978
nbre Number(4);
old_JH_COUTTOTAL VARCHAR2(30);
old_JH_ARBDEMANDES VARCHAR2(30);
old_JH_ARBDECIDES VARCHAR2(30);
old_JH_CANTDEMANDES VARCHAR2(30);
old_JH_CANTDECIDES VARCHAR2(30);
old_JH_PREVIDECIDE VARCHAR2(30);
--Fin YNI fdt 978


BEGIN

l_msg :='';
l_chaine := p_chaine;

while length(l_chaine) <> 0 loop

    l_pos := instr(l_chaine,';',1,1);
    l_date_copi := substr(l_chaine,1,l_pos-1);
    l_pos2 := instr(l_chaine,';',1,2);
    l_dpcopi := substr(l_chaine,l_pos+1,l_pos2-l_pos-1);
    l_pos := instr(l_chaine,';',1,2);
    l_pos2 := instr(l_chaine,';',1,3);
    l_annee := substr(l_chaine,l_pos+1,l_pos2-l_pos-1);
    l_pos := instr(l_chaine,';',1,3);
    l_pos2 := instr(l_chaine,';',1,4);
    l_metier := substr(l_chaine,l_pos+1,l_pos2-l_pos-1);
    l_pos := instr(l_chaine,';',1,4);
    l_pos2 := instr(l_chaine,';',1,5);
    l_code_four_copi := substr(l_chaine,l_pos+1,l_pos2-l_pos-1);
    l_pos := instr(l_chaine,';',1,5);
    l_pos2 := instr(l_chaine,';',1,6);
    l_code_type_demande := substr(l_chaine,l_pos+1,l_pos2-l_pos-1);
    l_pos := instr(l_chaine,';',1,6);
    l_pos2 := instr(l_chaine,';',1,7);
    l_demande  := substr(l_chaine,l_pos+1,l_pos2-l_pos-1);
    l_pos := instr(l_chaine,';',1,7);
    l_pos2 := instr(l_chaine,';',1,8);
    l_decide  := substr(l_chaine,l_pos+1,l_pos2-l_pos-1);
    l_pos := instr(l_chaine,';',1,8);
    l_pos2 := instr(l_chaine,';',1,9);
    l_cant_demande  := substr(l_chaine,l_pos+1,l_pos2-l_pos-1);
    l_pos := instr(l_chaine,';',1,9);
    l_pos2 := instr(l_chaine,';',1,10);
    l_cant_decide  := substr(l_chaine,l_pos+1,l_pos2-l_pos-1);
    l_pos := instr(l_chaine,';',1,10);
    l_pos2 := instr(l_chaine,';',1,11);
    l_previ_demande  := substr(l_chaine,l_pos+1,l_pos2-l_pos-1);
    l_pos := instr(l_chaine,';',1,11);
    l_pos2 := instr(l_chaine,':',1,1);
    l_previ_decide  := substr(l_chaine,l_pos+1,l_pos2-l_pos-1);


    --- Si le  xxxx decide est vide : le xxxx demande correspondant est recopié dans le www decide et les
    --- sont mis à jour

        IF ((l_decide = ' ' ) or (l_decide = '' ) or (l_decide is null )) THEN
            l_decide := l_demande;
        END IF;

        IF ((l_cant_decide = ' ' ) or (l_cant_decide = '' ) or (l_cant_decide is null )) THEN
            l_cant_decide := l_cant_demande;
        END IF;

        IF ((l_previ_decide = ' ' ) or (l_previ_decide = '' ) or (l_previ_decide is null )) THEN
            l_previ_decide := l_previ_demande;
        END IF;

    l_pos2pt := instr(l_chaine,':',1,1);
    l_chaine := substr(l_chaine,l_pos2pt+1);

/*
    MERGE INTO budget_copi b
        USING
        (
          SELECT
            l_dpcopi AS DP_COPI,
            to_number(l_annee) AS ANNEE,
            to_date(l_date_copi, 'dd/mm/yyyy') AS DATE_COPI,
            l_metier AS METIER,
            to_number(l_code_type_demande) AS CODE_TYPE_DEMANDE,
           to_number(l_code_four_copi) AS CODE_FOUR_COPI
          FROM DUAL) tmp
        ON
        (   tmp.DP_COPI = b.DP_COPI
        AND tmp.ANNEE = b.ANNEE
        AND tmp.DATE_COPI = b.DATE_COPI
        AND tmp.METIER = b.METIER
        AND tmp.CODE_TYPE_DEMANDE = b.CODE_TYPE_DEMANDE
        AND tmp.CODE_FOUR_COPI = b.CODE_FOUR_COPI
        )
        WHEN MATCHED THEN
        UPDATE SET
            b.JH_COUTTOTAL    = to_number(l_previ_demande),
            b.JH_ARBDEMANDES  = to_number(l_demande),
            b.JH_ARBDECIDES   = to_number(l_decide),
            b.JH_CANTDEMANDES = to_number(l_cant_demande),
            b.JH_CANTDECIDES  = to_number(l_cant_decide),
            b.JH_PREVIDECIDE  = to_number(l_previ_decide)
        DELETE WHERE ( l_previ_demande is null or l_previ_demande = '' or l_previ_demande = ' ')
        and (l_demande is null or l_demande = '' or l_demande= ' ')
        and (l_decide is null or l_decide ='' or l_decide = ' ')
        and ( l_cant_demande is null or l_cant_demande ='' or l_cant_demande= ' ')
        and( l_cant_decide is null or l_cant_decide ='' or l_cant_decide= ' ')
        and (l_previ_decide is null or l_previ_decide='' or l_previ_decide= ' ');

*/
BEGIN

select count(*) into nbre from budget_copi b, (
            SELECT
              l_dpcopi AS DP_COPI,
              to_number(l_annee) AS ANNEE,
              to_date(l_date_copi, 'dd/mm/yyyy') AS DATE_COPI,
              l_metier AS METIER,
              to_number(l_code_type_demande) AS CODE_TYPE_DEMANDE,
              to_number(l_code_four_copi) AS CODE_FOUR_COPI
            FROM DUAL) tmp
            WHERE tmp.DP_COPI = b.DP_COPI
            AND tmp.ANNEE = b.ANNEE
            AND tmp.DATE_COPI = b.DATE_COPI
            AND tmp.METIER = b.METIER
            AND tmp.CODE_TYPE_DEMANDE = b.CODE_TYPE_DEMANDE
            AND tmp.CODE_FOUR_COPI = b.CODE_FOUR_COPI;

if (nbre <> 0) then

	if ( ( l_previ_demande is null or l_previ_demande = '' or l_previ_demande = ' ')
        and (l_demande is null or l_demande = '' or l_demande= ' ')
        and (l_decide is null or l_decide ='' or l_decide = ' ')
        and ( l_cant_demande is null or l_cant_demande ='' or l_cant_demande= ' ')
        and( l_cant_decide is null or l_cant_decide ='' or l_cant_decide= ' ')
        and (l_previ_decide is null or l_previ_decide='' or l_previ_decide= ' ')) then

			DELETE FROM BUDGET_COPI b
            WHERE b.DP_COPI = l_dpcopi
            AND b.ANNEE = to_number(l_annee)
            AND b.DATE_COPI = to_date(l_date_copi, 'dd/mm/yyyy')
            AND b.METIER = l_metier
            AND b.CODE_TYPE_DEMANDE = to_number(l_code_type_demande)
            AND b.CODE_FOUR_COPI = to_number(l_code_four_copi);

			maj_budget_copi_logs (UPPER(l_dpcopi), to_number(l_annee), to_date(l_date_copi, 'dd/mm/yyyy'), l_metier, l_code_four_copi, l_code_type_demande, 'P', p_user, 'TOUTES','TOUTES','','Suppression du Budget DP COPI');

	else

      SELECT JH_COUTTOTAL,JH_ARBDEMANDES,JH_ARBDECIDES,JH_CANTDEMANDES,JH_CANTDECIDES,JH_PREVIDECIDE
        INTO old_JH_COUTTOTAL,old_JH_ARBDEMANDES,old_JH_ARBDECIDES,old_JH_CANTDEMANDES,old_JH_CANTDECIDES,old_JH_PREVIDECIDE
        FROM BUDGET_COPI b
        WHERE b.DP_COPI = l_dpcopi
            AND b.ANNEE = to_number(l_annee)
            AND b.DATE_COPI = to_date(l_date_copi, 'dd/mm/yyyy')
            AND b.METIER = l_metier
            AND b.CODE_TYPE_DEMANDE = to_number(l_code_type_demande)
            AND b.CODE_FOUR_COPI = to_number(l_code_four_copi);


			UPDATE BUDGET_COPI b SET
            b.JH_COUTTOTAL    = to_number(l_previ_demande),
            b.JH_ARBDEMANDES  = to_number(l_demande),
            b.JH_ARBDECIDES   = to_number(l_decide),
            b.JH_CANTDEMANDES = to_number(l_cant_demande),
            b.JH_CANTDECIDES  = to_number(l_cant_decide),
            b.JH_PREVIDECIDE  = to_number(l_previ_decide)
            WHERE b.DP_COPI = l_dpcopi
            AND b.ANNEE = to_number(l_annee)
            AND b.DATE_COPI = to_date(l_date_copi, 'dd/mm/yyyy')
            AND b.METIER = l_metier
            AND b.CODE_TYPE_DEMANDE = to_number(l_code_type_demande)
            AND b.CODE_FOUR_COPI = to_number(l_code_four_copi);

			maj_budget_copi_logs (UPPER(l_dpcopi), TO_NUMBER(l_annee), to_date(l_date_copi, 'dd/mm/yyyy'), l_metier, l_code_four_copi, l_code_type_demande, 'P', p_user, 'JH_COUTTOTAL',old_JH_COUTTOTAL,l_previ_demande,'Modification du cout total en JH');
			maj_budget_copi_logs (UPPER(l_dpcopi), TO_NUMBER(l_annee), to_date(l_date_copi, 'dd/mm/yyyy'), l_metier, l_code_four_copi, l_code_type_demande, 'P', p_user, 'JH_ARBDEMANDES',old_JH_ARBDEMANDES,l_demande,'Modification de l''arbitré demandé en JH');
			maj_budget_copi_logs (UPPER(l_dpcopi), TO_NUMBER(l_annee), to_date(l_date_copi, 'dd/mm/yyyy'), l_metier, l_code_four_copi, l_code_type_demande, 'P', p_user, 'JH_ARBDECIDES',old_JH_ARBDECIDES,l_decide,'Modification de l''arbitré décidés en JH');
			maj_budget_copi_logs (UPPER(l_dpcopi), TO_NUMBER(l_annee), to_date(l_date_copi, 'dd/mm/yyyy'), l_metier, l_code_four_copi, l_code_type_demande, 'P', p_user, 'JH_CANTDEMANDES',old_JH_CANTDEMANDES,l_cant_demande,'Modification du cantonné demandé en JH');
			maj_budget_copi_logs (UPPER(l_dpcopi), TO_NUMBER(l_annee), to_date(l_date_copi, 'dd/mm/yyyy'), l_metier, l_code_four_copi, l_code_type_demande, 'P', p_user, 'JH_CANTDECIDES',old_JH_CANTDECIDES,l_cant_decide,'Modification du previsionnel décidé en JH');
			maj_budget_copi_logs (UPPER(l_dpcopi), TO_NUMBER(l_annee), to_date(l_date_copi, 'dd/mm/yyyy'), l_metier, l_code_four_copi, l_code_type_demande, 'P', p_user, 'JH_PREVIDECIDE',old_JH_PREVIDECIDE,l_previ_decide,'Modification du previsionnel décidé en JH');

	end if;

end if;

END;

end loop;


Pack_Global.recuperer_message(21159,NULL,NULL, NULL, l_msg);
p_message :=  l_msg ;




END update_valid_masse_chaine;


FUNCTION f_maj_masse_copi( p_user	IN VARCHAR2,
                                    p_dpcopi 	IN VARCHAR2,
                                    p_date_copi	IN VARCHAR2,
                                    p_fournisseur IN VARCHAR2,
                                    p_CODE_TYPE_DEMANDE IN VARCHAR2,
                                    p_chaine	IN VARCHAR2)
                                RETURN VARCHAR2 IS


pos1 Number(4);
--YNI fdt 978
nbre Number(4);
old_JH_COUTTOTAL VARCHAR2(30);
old_JH_ARBDEMANDES VARCHAR2(30);
old_JH_ARBDECIDES VARCHAR2(30);
old_JH_CANTDEMANDES VARCHAR2(30);
old_JH_CANTDECIDES VARCHAR2(30);
old_JH_PREVIDECIDE VARCHAR2(30);
--Fin YNI fdt 978

l_dpcopi VARCHAR2(7);
l_date_copi VARCHAR2(10);
l_annee VARCHAR2(4);
l_metier VARCHAR2(3);
l_bud VARCHAR2(1000);
l_chaine VARCHAR2(1000);

l_cat_depense CHAR;

l_previdemande NUMBER(12,2);
l_previdecide NUMBER(12,2);
l_engageprec NUMBER(12,2);
l_cantprec NUMBER(12,2);
l_demande NUMBER(12,2);
l_decide NUMBER(12,2);
l_cantdemande NUMBER(12,2);
l_cantdecide NUMBER(12,2);

BEGIN


pos1 := instr(p_chaine,':',1,1);
l_annee := substr(p_chaine,1,pos1-1);
l_chaine := substr(p_chaine,pos1+1);

l_bud := l_chaine;
while length(l_chaine) <> 0 loop



pos1 := instr(l_chaine,';',1,1);
l_metier := substr(l_chaine,1,pos1-1);
l_chaine := substr(l_chaine,pos1+1);
pos1 := instr(l_chaine,':',1,1);
l_bud := substr(l_chaine,1,pos1-1);
l_chaine := substr(l_chaine,pos1+1);


pos1 := instr(l_bud,';',1,1);
l_previdemande := to_number(substr(l_bud,3,pos1-3));
l_bud := substr(l_bud,pos1+1);
pos1 := instr(l_bud,';',1,1);
l_previdecide := to_number(substr(l_bud,3,pos1-3));
l_bud := substr(l_bud,pos1+1);
pos1 := instr(l_bud,';',1,1);
l_engageprec := to_number(substr(l_bud,3,pos1-3));
l_bud := substr(l_bud,pos1+1);
pos1 := instr(l_bud,';',1,1);
l_cantprec := to_number(substr(l_bud,3,pos1-3));
l_bud := substr(l_bud,pos1+1);
pos1 := instr(l_bud,';',1,1);
l_demande := to_number(substr(l_bud,3,pos1-3));
l_bud := substr(l_bud,pos1+1);
pos1 := instr(l_bud,';',1,1);
l_decide := to_number(substr(l_bud,3,pos1-3));
l_bud := substr(l_bud,pos1+1);
pos1 := instr(l_bud,';',1,1);
l_cantdemande := to_number(substr(l_bud,3,pos1-3));
l_bud := substr(l_bud,pos1+1);
pos1 := instr(l_bud,';',1,1);
if (pos1 = 0) then
l_cantdecide := to_number(substr(l_bud,3));

end if;

if (p_fournisseur <> '99') then

/*
MERGE INTO budget_copi b
USING
(
  SELECT
    p_dpcopi AS DP_COPI,
    to_number(l_annee) AS ANNEE,
    to_date(p_date_copi, 'dd/mm/yyyy') AS DATE_COPI,
    l_metier AS METIER,
    to_number(p_CODE_TYPE_DEMANDE) AS CODE_TYPE_DEMANDE,
    to_number(p_fournisseur) AS CODE_FOUR_COPI
  FROM DUAL) tmp
ON
(   tmp.DP_COPI = b.DP_COPI
AND tmp.ANNEE = b.ANNEE
AND tmp.DATE_COPI = b.DATE_COPI
AND tmp.METIER = b.METIER
AND tmp.CODE_TYPE_DEMANDE = b.CODE_TYPE_DEMANDE
AND tmp.CODE_FOUR_COPI = b.CODE_FOUR_COPI
)
WHEN MATCHED THEN
UPDATE SET
    b.JH_COUTTOTAL    = l_previdemande,
    b.JH_ARBDEMANDES  = l_demande,
    b.JH_ARBDECIDES   = l_decide,
    b.JH_CANTDEMANDES = l_cantdemande,
    b.JH_CANTDECIDES  = l_cantdecide,
    b.JH_PREVIDECIDE  = l_previdecide

DELETE WHERE ( l_previdemande is null)
and (l_demande is null)
and (l_decide is null)
and ( l_cantdemande is null)
and( l_cantdecide is null)
and (l_previdecide is null)

WHEN NOT MATCHED THEN
INSERT (b.DP_COPI,b.ANNEE, b.DATE_COPI, b.METIER, b.CODE_TYPE_DEMANDE,
        b.CODE_FOUR_COPI, b.JH_COUTTOTAL, b.JH_ARBDEMANDES, b.JH_ARBDECIDES,
        b.JH_CANTDEMANDES, b.JH_CANTDECIDES, b.JH_PREVIDECIDE,b.CATEGORIE_DEPENSE)
VALUES (
   tmp.DP_COPI, tmp.ANNEE, tmp.DATE_COPI, tmp.metier, tmp.CODE_TYPE_DEMANDE,
   tmp.CODE_FOUR_COPI, l_previdemande, l_demande, l_decide,l_cantdemande, l_cantdecide,l_previdecide,'P'
       )
       WHERE (l_previdemande is not null)
or (l_demande is not null)
or (l_decide is not null)
or (l_cantdemande is not null)
or(l_cantdecide is not null)
or (l_previdecide is not null);


*/
BEGIN

select count(*) into nbre from budget_copi b, (
					 SELECT
					 p_dpcopi AS DP_COPI,
					 to_number(l_annee) AS ANNEE,
					 to_date(p_date_copi, 'dd/mm/yyyy') AS DATE_COPI,
					 l_metier AS METIER,
					 to_number(p_CODE_TYPE_DEMANDE) AS CODE_TYPE_DEMANDE,
					 to_number(p_fournisseur) AS CODE_FOUR_COPI
				   FROM DUAL) tmp
           WHERE tmp.DP_COPI = b.DP_COPI
           AND tmp.ANNEE = b.ANNEE
           AND tmp.DATE_COPI = b.DATE_COPI
           AND tmp.METIER = b.METIER
           AND tmp.CODE_TYPE_DEMANDE = b.CODE_TYPE_DEMANDE
           AND tmp.CODE_FOUR_COPI = b.CODE_FOUR_COPI;

if (nbre <> 0) then

	if ( l_previdemande is null and l_demande is null and l_decide is null and l_cantdemande is null and l_cantdecide is null and l_previdecide is null) then

			DELETE FROM BUDGET_COPI b
			WHERE b.DP_COPI = p_dpcopi
      AND b.ANNEE = to_number(l_annee)
      AND b.DATE_COPI = to_date(p_date_copi, 'dd/mm/yyyy')
      AND b.METIER = l_metier
      AND b.CODE_TYPE_DEMANDE = to_number(p_CODE_TYPE_DEMANDE)
      AND b.CODE_FOUR_COPI = to_number(p_fournisseur);

			maj_budget_copi_logs (UPPER(p_dpcopi), to_number(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'TOUTES','TOUTES','','Suppression du Budget DP COPI');

	else

      SELECT JH_COUTTOTAL,JH_ARBDEMANDES,JH_ARBDECIDES,JH_CANTDEMANDES,JH_CANTDECIDES,JH_PREVIDECIDE
      INTO old_JH_COUTTOTAL,old_JH_ARBDEMANDES,old_JH_ARBDECIDES,old_JH_CANTDEMANDES,old_JH_CANTDECIDES,old_JH_PREVIDECIDE
      FROM BUDGET_COPI
      WHERE DP_COPI = p_dpcopi
            AND ANNEE = to_number(l_annee)
            AND DATE_COPI = to_date(p_date_copi, 'dd/mm/yyyy')
            AND METIER = l_metier
            AND CODE_TYPE_DEMANDE = to_number(p_CODE_TYPE_DEMANDE)
            AND CODE_FOUR_COPI = to_number(p_fournisseur);

      UPDATE BUDGET_COPI b SET
            b.JH_COUTTOTAL    = l_previdemande ,
            b.JH_ARBDEMANDES  = l_demande ,
            b.JH_ARBDECIDES   = l_decide ,
            b.JH_CANTDEMANDES = l_cantdemande ,
            b.JH_CANTDECIDES  = l_cantdecide ,
            b.JH_PREVIDECIDE  = l_previdecide
            WHERE b.DP_COPI = p_dpcopi
            AND b.ANNEE = to_number(l_annee)
            AND b.DATE_COPI = to_date(p_date_copi, 'dd/mm/yyyy')
            AND b.METIER = l_metier
            AND b.CODE_TYPE_DEMANDE = to_number(p_CODE_TYPE_DEMANDE)
            AND b.CODE_FOUR_COPI = to_number(p_fournisseur);

			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_COUTTOTAL',old_JH_COUTTOTAL,l_previdemande,'Modification du cout total en JH');
			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_ARBDEMANDES',old_JH_ARBDEMANDES,l_demande,'Modification de l''arbitré demandé en JH');
			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_ARBDECIDES',old_JH_ARBDECIDES,l_decide,'Modification de l''arbitré décidés en JH');
			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_CANTDEMANDES',old_JH_CANTDEMANDES,l_cantdemande,'Modification du cantonné demandé en JH');
			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_CANTDECIDES',old_JH_CANTDECIDES,l_cantdecide,'Modification du previsionnel décidé en JH');
			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_PREVIDECIDE',old_JH_PREVIDECIDE,l_previdecide,'Modification du previsionnel décidé en JH');

	end if;

else

if ( l_previdemande is not null or l_demande is not null or l_decide is not null or l_cantdemande is not null or l_cantdecide is not null or l_previdecide is not null) then


	INSERT INTO BUDGET_COPI (DP_COPI, ANNEE, DATE_COPI, METIER, CODE_TYPE_DEMANDE,
          CODE_FOUR_COPI, JH_COUTTOTAL, JH_ARBDEMANDES, JH_ARBDECIDES,
          JH_CANTDEMANDES, JH_CANTDECIDES, JH_PREVIDECIDE, CATEGORIE_DEPENSE)
  VALUES (p_dpcopi, to_number(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, to_number(p_CODE_TYPE_DEMANDE),
          to_number(p_fournisseur), l_previdemande , l_demande , l_decide ,l_cantdemande , l_cantdecide ,l_previdecide ,'P');

	  maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'DP_COPI', '', upper(p_dpcopi),'Création du DP copi');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'ANNEE', '', l_annee,'Création de l''annee de reference');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'DATE_COPI', '', p_date_copi,'Création de la date copi');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'CODE_FOUR_COPI', '', p_fournisseur,'Création du code four copi');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'METIER', '', l_metier,'Création du metier');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'CODE_TYPE_DEMANDE', '', p_code_type_demande,'Création du type demande');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_COUTTOTAL', '', l_previdemande,'Création du cout total en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_ARBDEMANDES', '', l_demande,'Création de l''arbitré demandé en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_ARBDECIDES', '', l_decide,'Création de l''arbitré décidés en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_CANTDEMANDES', '', l_cantdemande,'Création du cantonné demandé en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_CANTDECIDES', '', l_cantdecide,'Création du cantonné décidé en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'JH_PREVIDECIDE', '', l_previdecide,'Création du previsionnel décidé en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, 'P', p_user, 'CATEGORIE_DEPENSE', '', 'P','Création de la categorie depense');
  end if;
end if;

END;

else

l_cat_depense := l_metier;
l_metier := 'NON';
/*
MERGE INTO budget_copi b
USING
(
  SELECT
    p_dpcopi AS DP_COPI,
    to_number(l_annee) AS ANNEE,
    to_date(p_date_copi, 'dd/mm/yyyy') AS DATE_COPI,
    l_metier AS METIER,
    to_number(p_CODE_TYPE_DEMANDE) AS CODE_TYPE_DEMANDE,
    to_number(p_fournisseur) AS CODE_FOUR_COPI,
    l_cat_depense AS CATEGORIE_DEPENSE
  FROM DUAL) tmp
ON
(   tmp.DP_COPI = b.DP_COPI
AND tmp.ANNEE = b.ANNEE
AND tmp.DATE_COPI = b.DATE_COPI
AND tmp.METIER = b.METIER
AND tmp.CATEGORIE_DEPENSE = b.CATEGORIE_DEPENSE
AND tmp.CODE_TYPE_DEMANDE = b.CODE_TYPE_DEMANDE
AND tmp.CODE_FOUR_COPI = b.CODE_FOUR_COPI
)
WHEN MATCHED THEN
UPDATE SET
    b.JH_COUTTOTAL    = l_previdemande * 1000,
    b.JH_ARBDEMANDES  = l_demande * 1000,
    b.JH_ARBDECIDES   = l_decide * 1000,
    b.JH_CANTDEMANDES = l_cantdemande * 1000,
    b.JH_CANTDECIDES  = l_cantdecide * 1000,
    b.JH_PREVIDECIDE  = l_previdecide * 1000
DELETE WHERE (l_previdemande is null)
and (l_demande is null)
and (l_decide is null)
and (l_cantdemande is null)
and(  l_cantdecide is null)
and ( l_previdecide is null)
WHEN NOT MATCHED THEN
INSERT (b.DP_COPI,b.ANNEE, b.DATE_COPI, b.METIER, b.CODE_TYPE_DEMANDE,
        b.CODE_FOUR_COPI, b.JH_COUTTOTAL, b.JH_ARBDEMANDES, b.JH_ARBDECIDES,
        b.JH_CANTDEMANDES, b.JH_CANTDECIDES, b.JH_PREVIDECIDE,b.CATEGORIE_DEPENSE)
VALUES (
   tmp.DP_COPI, tmp.ANNEE, tmp.DATE_COPI, tmp.metier, tmp.CODE_TYPE_DEMANDE,
   tmp.CODE_FOUR_COPI, l_previdemande * 1000, l_demande * 1000, l_decide * 1000, l_cantdemande * 1000, l_cantdecide * 1000, l_previdecide * 1000,tmp.CATEGORIE_DEPENSE
       )
       WHERE ( l_previdemande is not null)
or (l_demande is not null)
or ( l_decide is not null)
or (l_cantdemande is not null)
or( l_cantdecide is not null)
or (l_previdecide is not null);
*/

BEGIN

select count(*) into nbre from budget_copi b, (
					 SELECT
					 p_dpcopi AS DP_COPI,
           to_number(l_annee) AS ANNEE,
           to_date(p_date_copi, 'dd/mm/yyyy') AS DATE_COPI,
           l_metier AS METIER,
           to_number(p_CODE_TYPE_DEMANDE) AS CODE_TYPE_DEMANDE,
           to_number(p_fournisseur) AS CODE_FOUR_COPI,
           l_cat_depense AS CATEGORIE_DEPENSE
				   FROM DUAL) tmp
           WHERE tmp.DP_COPI = b.DP_COPI
           AND tmp.ANNEE = b.ANNEE
           AND tmp.DATE_COPI = b.DATE_COPI
           AND tmp.METIER = b.METIER
           AND tmp.CATEGORIE_DEPENSE = b.CATEGORIE_DEPENSE
           AND tmp.CODE_TYPE_DEMANDE = b.CODE_TYPE_DEMANDE
           AND tmp.CODE_FOUR_COPI = b.CODE_FOUR_COPI;

if (nbre <> 0) then

	if ( l_previdemande is null and l_demande is null and l_decide is null and l_cantdemande is null and l_cantdecide is null and l_previdecide is null) then

			DELETE FROM BUDGET_COPI b
			WHERE b.DP_COPI = p_dpcopi
      AND b.ANNEE = to_number(l_annee)
      AND b.DATE_COPI = to_date(p_date_copi, 'dd/mm/yyyy')
      AND b.METIER = l_metier
      AND b.CODE_TYPE_DEMANDE = to_number(p_CODE_TYPE_DEMANDE)
      AND b.CATEGORIE_DEPENSE = l_cat_depense
      AND b.CODE_FOUR_COPI = to_number(p_fournisseur);

			maj_budget_copi_logs (UPPER(p_dpcopi), to_number(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'TOUTES','TOUTES','','Suppression du Budget DP COPI');

	else

      SELECT JH_COUTTOTAL,JH_ARBDEMANDES,JH_ARBDECIDES,JH_CANTDEMANDES,JH_CANTDECIDES,JH_PREVIDECIDE
      INTO old_JH_COUTTOTAL,old_JH_ARBDEMANDES,old_JH_ARBDECIDES,old_JH_CANTDEMANDES,old_JH_CANTDECIDES,old_JH_PREVIDECIDE
      FROM BUDGET_COPI
      WHERE DP_COPI = p_dpcopi
            AND ANNEE = to_number(l_annee)
            AND DATE_COPI = to_date(p_date_copi, 'dd/mm/yyyy')
            AND METIER = l_metier
            AND CODE_TYPE_DEMANDE = to_number(p_CODE_TYPE_DEMANDE)
            AND CATEGORIE_DEPENSE = l_cat_depense
            AND CODE_FOUR_COPI = to_number(p_fournisseur);

      UPDATE BUDGET_COPI b SET
            b.JH_COUTTOTAL    = l_previdemande * 1000 ,
            b.JH_ARBDEMANDES  = l_demande * 1000 ,
            b.JH_ARBDECIDES   = l_decide * 1000 ,
            b.JH_CANTDEMANDES = l_cantdemande * 1000 ,
            b.JH_CANTDECIDES  = l_cantdecide * 1000 ,
            b.JH_PREVIDECIDE  = l_previdecide * 1000
            WHERE b.DP_COPI = p_dpcopi
            AND b.ANNEE = to_number(l_annee)
            AND b.DATE_COPI = to_date(p_date_copi, 'dd/mm/yyyy')
            AND b.METIER = l_metier
            AND b.CODE_TYPE_DEMANDE = to_number(p_CODE_TYPE_DEMANDE)
            AND b.CATEGORIE_DEPENSE = l_cat_depense
            AND b.CODE_FOUR_COPI = to_number(p_fournisseur);

			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_COUTTOTAL',old_JH_COUTTOTAL,l_previdemande * 1000 ,'Modification du cout total en JH');
			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_ARBDEMANDES',old_JH_ARBDEMANDES,l_demande * 1000 ,'Modification de l''arbitré demandé en JH');
			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_ARBDECIDES',old_JH_ARBDECIDES,l_decide * 1000 ,'Modification de l''arbitré décidés en JH');
			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_CANTDEMANDES',old_JH_CANTDEMANDES,l_cantdemande * 1000 ,'Modification du cantonné demandé en JH');
			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_CANTDECIDES',old_JH_CANTDECIDES,l_cantdecide * 1000 ,'Modification du previsionnel décidé en JH');
			maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_PREVIDECIDE',old_JH_PREVIDECIDE,l_previdecide * 1000 ,'Modification du previsionnel décidé en JH');

	end if;

else

if ( l_previdemande is not null or l_demande is not null or l_decide is not null or l_cantdemande is not null or l_cantdecide is not null or l_previdecide is not null) then

INSERT INTO BUDGET_COPI (DP_COPI, ANNEE, DATE_COPI, METIER, CODE_TYPE_DEMANDE,
              CODE_FOUR_COPI, JH_COUTTOTAL, JH_ARBDEMANDES, JH_ARBDECIDES,
              JH_CANTDEMANDES, JH_CANTDECIDES, JH_PREVIDECIDE, CATEGORIE_DEPENSE)
  VALUES (p_dpcopi, to_number(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, to_number(p_CODE_TYPE_DEMANDE),
          to_number(p_fournisseur), l_previdemande * 1000 , l_demande * 1000 , l_decide * 1000 ,l_cantdemande * 1000 , l_cantdecide * 1000 ,l_previdecide * 1000 ,l_cat_depense);

	  maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'DP_COPI', '', upper(p_dpcopi),'Création du DP copi');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'ANNEE', '', l_annee,'Création de l''annee de reference');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'DATE_COPI', '', p_date_copi,'Création de la date copi');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'CODE_FOUR_COPI', '', p_fournisseur,'Création du code four copi');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'METIER', '', l_metier,'Création du metier');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'CODE_TYPE_DEMANDE', '', p_code_type_demande,'Création du type demande');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_COUTTOTAL', '', l_previdemande,'Création du cout total en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_ARBDEMANDES', '', l_demande,'Création de l''arbitré demandé en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_ARBDECIDES', '', l_decide,'Création de l''arbitré décidés en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_CANTDEMANDES', '', l_cantdemande,'Création du cantonné demandé en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_CANTDECIDES', '', l_cantdecide,'Création du cantonné décidé en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'JH_PREVIDECIDE', '', l_previdecide,'Création du previsionnel décidé en JH');
    maj_budget_copi_logs (UPPER(p_dpcopi), TO_NUMBER(l_annee), to_date(p_date_copi, 'dd/mm/yyyy'), l_metier, p_fournisseur, p_CODE_TYPE_DEMANDE, l_cat_depense, p_user, 'CATEGORIE_DEPENSE', '', l_cat_depense,'Création de la categorie depense');
 end if;
end if;

END;

end if;

end loop;
RETURN 'MAJ OK';

end f_maj_masse_copi;


FUNCTION f_x_portefeuille_copi( p_dpcopi 	IN VARCHAR2,
                                    p_date_copi	IN VARCHAR2,
                                    p_metier IN VARCHAR2,
                                    p_annee IN VARCHAR2,
                                    p_fournisseur IN VARCHAR2,
                                    p_CODE_TYPE_DEMANDE IN VARCHAR2,
                                    p_categorie_depense	IN VARCHAR2,
                                    p_type IN VARCHAR2,
                                    p_CATEGORIE_DEPENSE_demande IN VARCHAR2)
                                RETURN VARCHAR2 IS


l_resultat VARCHAR2(15);
l_presence VARCHAR2(10);

begin

l_presence := 0;

if (p_type = '1') then
 BEGIN
    select decode(CATEGORIE_DEPENSE,'P',nvl(JH_PREVIDECIDE,0),nvl(JH_PREVIDECIDE,0)/1000) into l_resultat
    from budget_copi
where
DP_COPI = p_dpcopi
and metier = p_metier
and annee = p_annee
and date_copi in (select max(date_copi) from budget_copi where
DP_COPI = p_dpcopi
and JH_COUTTOTAL is not null
and date_copi <= p_date_copi
and annee = p_annee
and CATEGORIE_DEPENSE = p_categorie_depense)
and code_four_copi = p_fournisseur
and code_type_demande = p_CODE_TYPE_DEMANDE
and CATEGORIE_DEPENSE = p_categorie_depense
and  p_categorie_depense=p_CATEGORIE_DEPENSE_demande;

return  l_resultat;
exception when
no_data_found then
select to_char(max(date_copi)) into l_presence from budget_copi where
DP_COPI = p_dpcopi
and JH_COUTTOTAL is not null
and date_copi <= p_date_copi
and annee = p_annee
and CATEGORIE_DEPENSE = p_categorie_depense
and  p_categorie_depense=p_CATEGORIE_DEPENSE_demande;

if (l_presence is not null) then
return '0';
else
return null;
end if;
end;
else
begin
    select decode(CATEGORIE_DEPENSE,'P',nvl(JH_COUTTOTAL,0),nvl(JH_COUTTOTAL,0)/1000) into l_resultat
    from budget_copi
where
DP_COPI = p_dpcopi
and metier = p_metier
and annee = p_annee
and date_copi in (select max(date_copi) from budget_copi where
DP_COPI = p_dpcopi
and JH_COUTTOTAL is not null
and date_copi <= p_date_copi
and annee = p_annee
and CATEGORIE_DEPENSE = p_categorie_depense)
and code_four_copi = p_fournisseur
and code_type_demande = p_CODE_TYPE_DEMANDE
and CATEGORIE_DEPENSE = p_categorie_depense
and  p_categorie_depense=p_CATEGORIE_DEPENSE_demande;

return  l_resultat;
exception when
no_data_found then
select to_char(max(date_copi)) into l_presence from budget_copi where
DP_COPI = p_dpcopi
and JH_COUTTOTAL is not null
and date_copi <= p_date_copi
and annee = p_annee
and CATEGORIE_DEPENSE = p_categorie_depense
and  p_categorie_depense=p_CATEGORIE_DEPENSE_demande;

if (l_presence is not null) then
return '0';
else
return null;
end if;



end;
end if;

return  l_resultat;



END f_x_portefeuille_copi;

--YNI FDT 798
--Procédure pour remplir les logs de MAJ du  dossier projet copi
PROCEDURE maj_budget_copi_logs (p_dp_copi     IN BUDGET_COPI_LOGS.dp_copi%TYPE,
                                p_annee  IN BUDGET_COPI_LOGS.annee%TYPE,
                                p_date_copi IN BUDGET_COPI_LOGS.date_copi%TYPE,
                                p_metier IN VARCHAR2,
                                p_code_four_copi IN VARCHAR2,
                                p_code_type_demande IN VARCHAR2,
                                p_categorie_depense IN VARCHAR2,
                                p_user_log    IN VARCHAR2,
                                p_colonne        IN VARCHAR2,
                                p_valeur_prec    IN VARCHAR2,
                                p_valeur_nouv    IN VARCHAR2,
                                p_commentaire    IN VARCHAR2
                                ) IS
l_date VARCHAR2(30);
BEGIN

    IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
        --insert into test_message message values ('(dp_copi, annee, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire) : '|| p_dp_copi||','|| p_annee || ',' || SYSDATE || ',' || p_user_log || ',' || p_colonne || ',' || p_valeur_prec || ',' || p_valeur_nouv || ',' || p_commentaire);commit;
        INSERT INTO BUDGET_COPI_LOGS
            (dp_copi, annee, date_copi, metier, code_four_copi, code_type_demande, categorie_depense, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
        VALUES
            (p_dp_copi, p_annee, p_date_copi, p_metier, p_code_four_copi, p_code_type_demande, p_categorie_depense, sysdate, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);

    END IF;
-- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

END maj_budget_copi_logs;
--Fin YNI FDT 798

END pack_copi_Budget;
/
