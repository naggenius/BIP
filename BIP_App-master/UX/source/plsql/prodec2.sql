-- @C:\Honore\Prodec2\PlSql\Prodec2.sql;
-- SET SERVEROUTPUT ON SIZE 1000000;
--
-----------------------------------------
-------------------------------------------------------------------------------------------------------
-- Quand    Qui  	Nom                   		Quoi
-- -------- ---  	--------------------  		----------------------------------------
-- 08/06/00 HTM  	ouvrir_conso_cv			(1)Remplacement tests (sir.prestation != 'GRA') par
--								   ( (sir.prestation != 'GRA') OR (sir.prestation IS NULL) )
--								(2) Exclusion de la ressource 0 du calcul du consommé
--								(3) SELECT ... UNION ALL ... SELECT pour prendre en compte
--								    les ressources ayant "une mauvaise situation" :
--								    Ressource sans situation, Ressource ayant consomme
--								    avec une situation fermée, ...
--
--			calc_cons_sstache_res_mois2	Exclusion de la ressource 0 du calcul du consommé
-- 02/03/2001 NBM : gestion des habilitations: filtre par direction ou département
-- 15/03/2001 NBM : TRUNC(sir.datsitu,'MONTH')  <= TRUNC(csr.cdeb,'MONTH') au lieu de
--					sir.datsitu  <= csr.cdeb :une situation commençant le 02/01/2001
--					n'était pas prise en compte pour le mois de janvier
-- 30/11/2004 EGR : F93 modification sur les codes MO, clidom est abandonné au profit de clicode pour la table client_mo
-- 11/09/2007 EVI : TD514 pour les etat prodecl, prodectop et prodec3 ne doivent pas comptabiliser les ressources IFO, GRA, INT et MO
-- 19/09/2007 EVI : TD514 on retire les ressource non facturé du calcul du consomme du budget (IFO, GRA, INT, STA et MO)
-- 19/09/2007 EVI : TD514 correction erreur affichage des consommé gratuit dans le detail.
-- 22/02/2010 ABA : TD 938
-- 18/11/2011 OLE : QC 1266
---18/11/2011 ABA : valorsation de la colonne total pour les etats détaillés clients 

/**************************************************************************************
 * NOTE : Package "pack_prodec2" est utilisé pour :
 *        PROJPRIN, PRODEC2 (Lot 3A),
 *        PRODEC3, PRODEC4, PRODECL (Lot 3B)
 *
 *
 * PAR AILLEURS : - verif_prodec3 et verif_prodecl utilisent le concept d'HISTORIQUE!!!
 *                Elles se trouvent dans  le package des HISTORIQUES : pack_historique
 *             - verif_prodec4 est déplacé dans pack_prodec4
 *
 **************************************************************************************/


CREATE OR REPLACE PACKAGE     pack_prodec2 IS
------------------------------------------------------------------------------
-- Constantes globales
------------------------------------------------------------------------------

CST_CODE_DPG_TOUS CONSTANT CHAR(7) := '*******';     -- Code DPG signifiant tous les Codes DPG
CST_PREM_CAR_ID_APPLI CONSTANT CHAR(1) := 'A';        -- 1er caractère identifiant Application (AIRT)
CST_PREM_CAR_ID_PROJ CONSTANT CHAR(1) := 'P';        -- 1er caractère identifiant Projet (ICPI)

CST_BUD_XXXX CONSTANT CHAR(4) := 'XXXX';            -- Chaîne 'XXXX' affichée dans les états PRODEC


------------------------------------------------------------------------------
-- Types et Curseurs
------------------------------------------------------------------------------

TYPE ConsoCurRecTyp IS RECORD (
                        cdeb  cons_sstache_res_mois.cdeb%TYPE,
                          pid   cons_sstache_res_mois.pid%TYPE,
                          acta  cons_sstache_res_mois.acta%TYPE,
                          acst  cons_sstache_res_mois.acst%TYPE,
                          ecet  cons_sstache_res_mois.ecet%TYPE,
                        cusag cons_sstache_res_mois.cusag%TYPE
                        );

 TYPE BudgetCurRecTyp IS RECORD ( pid ligne_bip.pid%TYPE );

-- Type de curseur générique
-- TYPE GenericCurType IS REF CURSOR;

-- Types de curseur utilisés pour la construction des tables tmp_conso_sstache, tmp_budget_sstache
-- (Etats PRODEC2, PRODEC3, PRODEC4, PRODECL)
TYPE ConsoCurTyp  IS REF CURSOR RETURN ConsoCurRecTyp;
TYPE BudgetCurTyp IS REF CURSOR RETURN BudgetCurRecTyp;

------------------------------------------------------------------------------
-- Les Fonctions
------------------------------------------------------------------------------

----------------------------------
-- Copié à partir de pack_utile
----------------------------------
   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_pnom_lbip
   -- Auteur     :  Equipe SOPRA
   -- Decription :  recupere le libelle d'une ligne bip
   -- Paramètres :  p_pid (IN) identifiant du code projet
   --
   -- Retour     :  le libelle du projet
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_pnom_lbip(p_pid IN ligne_bip.pid%TYPE) RETURN VARCHAR2;
       PRAGMA restrict_references(f_get_pnom_lbip,wnds,wnps);

   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_codsg_lbip
   -- Auteur     :  Equipe SOPRA
   -- Decription :  recupere le codsg d'une ligne bip
   -- Paramètres :  p_pid (IN) identifiant du code projet
   --
   -- Retour     :  le code DEP/POL/GR de la ligne bip
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_codsg_lbip(p_pid IN ligne_bip.pid%TYPE) RETURN VARCHAR2;
       PRAGMA restrict_references(f_get_codsg_lbip,wnds,wnps);


   -- ------------------------------------------------------------------------
   -- Nom        :  f_formater_budget
   -- Auteur     :  Equipe SOPRA
   -- Decription :  Formatage des Montants  de la table tmp_budget_sstache
   -- Paramètres :  p_val      (IN)      Montant à formater
   --
   -- Retour     :  p_val au format 'FM9G999G999G999G999D0' si possible, sinon p_val tel quel!!!
   --
   -- ------------------------------------------------------------------------

FUNCTION f_formater_budget(p_val IN VARCHAR2) RETURN VARCHAR2;
    PRAGMA restrict_references(f_formater_budget, wnds, wnps);



   -- ------------------------------------------------------------------------
   -- Nom        :  f_conso_mois_a_afficher
   -- Auteur     :  Equipe SOPRA
   -- Decription :  Retourne le montant qui sera affiché dans le Report pour les états PRODEC2,3,4,L ou NULL
   -- Paramètres :  p_cusag      (IN)      Montant du consommé
   --              p_cdeb (IN)          Date du consommé (Date)
   --              p_mois  (IN)         Mois traité ( format 'MM')
   --              p_mois_maxi (IN)     Mois maxi à traiter ( format 'MM')
   --                            (Si p_mois > p_mois_maxi, on retourne NULL!!!)
   --
   -- Retour     :  Le montant du consommé (p_cusag) si Mois de p_cdeb = p_mois et p_mois <= p_mois_maxi
   --           NULL dans le cas contraire
   -- ------------------------------------------------------------------------
   FUNCTION f_conso_mois_a_afficher(        p_cusag     IN cons_sstache_res_mois.cusag%TYPE,
                        p_cdeb      IN cons_sstache_res_mois.cdeb%TYPE,
                        p_mois      IN VARCHAR2,
                        p_mois_maxi     IN VARCHAR2
                        ) RETURN NUMBER;
       PRAGMA restrict_references(f_conso_mois_a_afficher, wnds, wnps);



   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_lib_statut
   -- Auteur     :  Equipe SOPRA
   -- Decription :  recupere le libelle d'un code statut
   -- Paramètres :  p_astatut (IN) Code statut
   --
   -- Retour     :  le libelle du statut
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_lib_statut(p_astatut IN code_statut.astatut%TYPE) RETURN VARCHAR2;
       PRAGMA restrict_references(f_get_lib_statut, wnds, wnps);

   -- ------------------------------------------------------------------------
   -- Nom        : calc_prop_budget2 (Construit à partir de calc_prop_budget!!!)
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget propose pour une annee
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_date_cour (IN) Date courante (En principe, SYSDATE ou datdebex)
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION calc_prop_budget2 (p_pid          IN budget.pid%TYPE,
                   p_annee         IN budget.annee%TYPE,
                   p_date_cour     IN DATE
                     ) RETURN VARCHAR2;

   PRAGMA restrict_references(calc_prop_budget2, wnds, wnps);

   -- ------------------------------------------------------------------------
   -- Nom        : calc_budg_notif2
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget notifier pour une annee
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_date_cour (IN) Date courante (En principe, SYSDATE ou datdebex)
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION calc_budg_notif2 (p_pid         IN budget.pid%TYPE,
                  p_annee       IN budget.annee%TYPE,
                  p_date_cour IN DATE
                ) RETURN VARCHAR2;

   PRAGMA restrict_references(calc_budg_notif2, wnds, wnps);

   -- ------------------------------------------------------------------------
   -- Nom        : calc_budg_arb_notif2
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget arbitrer notifier pour une annee
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_date_cour (IN) Date courante (En principe, SYSDATE ou datdebex)
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION calc_budg_arb_notif2 (p_pid       IN budget.pid%TYPE,
                  p_annee     IN budget.annee%TYPE,
                  p_date_cour IN DATE
                ) RETURN VARCHAR2;

      PRAGMA restrict_references(calc_budg_arb_notif2, wnds, wnps);

   -- ------------------------------------------------------------------------
   -- Nom        : calc_budg_reestime
   -- Auteur     : OEL (EL KHABZI OUSSAMA) - QC 1266
   -- Decription : calcul le budget arbitrer notifier pour une annee
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_date_cour (IN) Date courante (En principe, SYSDATE ou datdebex)
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION calc_budg_reestime (p_pid       IN budget.pid%TYPE,
                  p_annee     IN budget.annee%TYPE,
                  p_date_cour IN DATE
                ) RETURN VARCHAR2;

      PRAGMA restrict_references(calc_budg_reestime, wnds, wnps);
   -- ------------------------------------------------------------------------
   -- Nom        : calc_cons_sstache_res_mois2
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget consomme pour une annee
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_date_cour (IN) Date courante (En principe, SYSDATE ou datdebex)
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION calc_cons_sstache_res_mois2 (p_pid       IN cons_sstache_res_mois.pid%TYPE,
                     p_annee     IN cons_sstache_res_mois.cdeb%TYPE,
                     p_date_cour IN DATE
                       ) RETURN VARCHAR2;
      PRAGMA restrict_references(calc_cons_sstache_res_mois2, wnds, wnps);

   -- ------------------------------------------------------------------------
   -- Nom        : calc_cons_annee_prec
   -- Auteur     : MMC
   -- Decription : calcul le budget consomme pour l'anne precedente et l'historique
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_date_cour (IN) Date courante (En principe, SYSDATE ou datdebex)
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION calc_cons_annee_prec (p_pid    IN consomme.pid%TYPE,
                  p_annee IN consomme.annee%TYPE,
                  p_indic_annee IN VARCHAR2
                  ) RETURN VARCHAR2;
      PRAGMA restrict_references(calc_cons_annee_prec, wnds, wnps);

   -- ------------------------------------------------------------------------
   -- Nom        : decode_amortissement
   -- Auteur     : Equipe SOPRA
   -- Decription : test pour renvoyer l'amortissement dans les editions prodec2
   --              et edition ligne BIP
   --
   -- Paramètres : p_type    (IN) code type de projet
   --              p_astatut (IN) statut de l'amortissement
   -- Retour     : un  varchar2 avec 'OUI' ou 'NON'
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION decode_amortissement (p_type    ligne_bip.typproj%TYPE,
                  p_astatut ligne_bip.astatut%TYPE
                 ) RETURN VARCHAR2;
   PRAGMA restrict_references(decode_amortissement,wnds,wnps);

   -- ------------------------------------------------------------------------
   -- Nom        : tmp_sstache_budget2
   -- Auteur     : Equipe SOPRA
   -- Decription : met a jour de la table tmp_budget_sstache a partir des tables
   --              cons_sstache_res_mois, prop_budget, budg_notif, budg_arb_notif
   --              budg_arb_notif
   -- Paramètres :
   --               p_nom_etat (IN)         Nom de l'état traité (PRODEC2, 3, 4, ou L)
   --           p_clicode   (IN)     Code direction
   --              p_codsg    (IN)       Code DPG (Pouvant contenir des * à la fin!!!)
   --               p_pid      (IN)       Code ligne BIP
   --               p_id_proj_ou_appli     (IN)       Code référentiel (Identifiant Projet ou Application)
   --              p_date_traite (IN)    Date à prendre en compte
   --             (L'année de cette date correspond à l'année N !!! dans l'état!!!)
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   --
   -- ------------------------------------------------------------------------
   FUNCTION tmp_sstache_budget2 (
                    p_nom_etat         IN VARCHAR2,
                    p_clicode           IN client_mo.clicode%TYPE,
                    p_codsg            IN VARCHAR2,
                    p_pid              IN ligne_bip.pid%TYPE,
                    p_appli         IN VARCHAR2,
                    p_projet         IN VARCHAR2,
                    p_date_traite         IN DATE
                    ) RETURN NUMBER;


   -- ------------------------------------------------------------------------
   -- Nom        : tmp_sstache2
   -- Auteur     : Equipe SOPRA  (HTM 23/02/2000)
   -- Decription : met a jour de la table tmp_conso_sstache a partir des tables
   --              cons_sstache_res_mois, proplus, tache et etape
   -- Paramètres :
   --               p_nom_etat (IN)         Nom de l'état traité (PRODEC2, 3, 4, ou L)
   --           p_clicode   (IN)     Code direction
   --              p_codsg    (IN)       Code DPG (Pouvant contenir des * à la fin!!!)
   --               p_pid      (IN)       Code ligne BIP
   --               p_id_proj_ou_appli     (IN)       Code référentiel (Identifiant Projet ou Application)
   --              p_date_traite (IN)    Date à prendre en compte
   --             (L'année de cette date correspond à l'année N !!! dans l'état!!!)
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- Remarque   : Le filtre sur p_clicode serait trop coûteux : Ce paramètre
   --             est inutilisé pour l'instant!!!
   -- ------------------------------------------------------------------------
   FUNCTION tmp_sstache2 (
                    p_nom_etat         IN VARCHAR2,
                    p_clicode           IN client_mo.clicode%TYPE,
                    p_codsg            IN VARCHAR2,
                    p_pid              IN ligne_bip.pid%TYPE,
                    p_appli         IN VARCHAR2,
                    p_projet         IN VARCHAR2,
                    p_date_traite         IN DATE
                    ) RETURN NUMBER;


------------------------------------------------------------------------------
-- Les Procédures
------------------------------------------------------------------------------

   -- ------------------------------------------------------------------------
   -- Nom        :  ouvrir_conso_cv (Procédure)
   -- Auteur     :  Equipe SOPRA
   -- Decription :  Ouverture variable curseur de type ConsoCurTyp
   -- Paramètres :  p_curv    (IN/OUT)     Curseur à ouvrir
   --               p_nom_etat (IN)         Nom de l'état traité (PRODEC2, 3, 4, ou L)
   --           p_clicode   (IN)     Code direction
   --              p_codsg    (IN)       Code DPG (Pouvant contenir des * à la fin!!!)
   --               p_pid      (IN)       Code ligne BIP
   --               p_id_proj_ou_appli     (IN)       Code référentiel (Identifiant Projet ou Application)
   --               p_airt     (IN)       Identifiant Application
   --              p_date_traite (IN)    Date à prendre en compte
   --             (L'année de cette date correspond à l'année N !!! dans l'état!!!)
   --
   -- Retour     :
   --
   -- ------------------------------------------------------------------------
   PROCEDURE ouvrir_conso_cv(
                    p_curv         IN OUT ConsoCurTyp,
                    p_nom_etat     IN VARCHAR2,
                    p_clicode       IN client_mo.clicode%TYPE,
                    p_codsg        IN VARCHAR2,
                    p_pid          IN ligne_bip.pid%TYPE,
                    p_appli         IN VARCHAR2,
                    p_projet         IN VARCHAR2,
                    p_date_traite     IN DATE
                    );

   -- ------------------------------------------------------------------------
   -- Nom        :  ouvrir_budget_cv (Procédure)
   -- Auteur     :  Equipe SOPRA
   -- Decription :  Ouverture variable curseur de type BudgetCurTyp
   -- Paramètres :  p_curv     (IN/OUT)      Curseur à ouvrir
   --               p_nom_etat (IN)         Nom de l'état traité (PRODEC2, 3, 4, ou L)
   --           p_clicode   (IN)     Code direction
   --              p_codsg    (IN)       Code DPG (Pouvant contenir des * à la fin!!!)
   --               p_pid      (IN)       Code ligne BIP
   --               p_id_proj_ou_appli     (IN)       Code référentiel (Identifiant Projet ou Application)
   --              p_date_traite (IN)    Date à prendre en compte
   --             (L'année de cette date correspond à l'année N !!! dans l'état!!!)
   --
   -- Retour     :
   --
   -- ------------------------------------------------------------------------
   PROCEDURE ouvrir_budget_cv(
                    p_curv         IN OUT BudgetCurTyp,
                    p_nom_etat     IN VARCHAR2,
                    p_clicode       IN client_mo.clicode%TYPE,
                    p_codsg        IN VARCHAR2,
                    p_pid          IN ligne_bip.pid%TYPE,
                    p_appli         IN VARCHAR2,
                    p_projet         IN VARCHAR2,
                    p_date_traite     IN DATE
                    );

-- ------------------------------------------------------------------------
   -- Nom        :  ouvrir_budget_tout (Procédure)
   -- Auteur     :  MMC
   -- Decription :  Ouverture variable curseur de type BudgetCurTyp
   -- Paramètres :  p_curv     (IN/OUT)      Curseur à ouvrir
   --               p_userid    (IN)    identifiant de l'utilisateur
   --
-- ------------------------------------------------------------------------
   PROCEDURE ouvrir_budget_tout(    p_curv         IN OUT BudgetCurTyp,
                    p_userid     IN VARCHAR2
                    ) ;

-- ------------------------------------------------------------------------
   -- Nom        :  ouvrir_conso_tout (Procédure)
   -- Auteur     :  MMC
   -- Decription :  Ouverture variable curseur de type ConsoCurTyp
   -- Paramètres :  p_curv    (IN/OUT)     Curseur à ouvrir
   --               p_userid (IN)         p_global
-- ------------------------------------------------------------------------
 PROCEDURE ouvrir_conso_tout(        p_curv         IN OUT ConsoCurTyp,
                    p_userid     IN VARCHAR2,
                    p_date_traite     IN DATE
                    ) ;



END pack_prodec2;
/


create or replace PACKAGE BODY     pack_prodec2 IS
----------------------------------------------

--****************************************************************************
-- Les Fonctions
--****************************************************************************

   -- **********************************************************************
   -- Nom        : f_get_pnom_lbip
   -- Auteur     : Equipe SOPRA
   -- Decription : recupere le libelle d'une ligne bip
   -- Paramètres : p_pid (IN) identifiant du code projet
   --
   -- Retour     : le libelle du projet
   --
   -- **********************************************************************
   FUNCTION f_get_pnom_lbip(p_pid IN ligne_bip.pid%TYPE) RETURN VARCHAR2 IS

      l_pnom ligne_bip.pnom%TYPE;

   BEGIN
      SELECT  lib.pnom
    INTO  l_pnom
    FROM  ligne_bip lib
    WHERE lib.pid = p_pid;

      RETURN l_pnom;

   END f_get_pnom_lbip;

   -- **********************************************************************
   -- Nom        : f_get_codsg_lbip
   -- Auteur     : Equipe SOPRA
   -- Decription : recupere le codsg d'une ligne bip
   -- Paramètres : p_pid (IN) identifiant du code projet
   --
   -- Retour     : le code DEP/POL/GR de la ligne bip
   --
   -- **********************************************************************
   FUNCTION f_get_codsg_lbip(p_pid IN ligne_bip.pid%TYPE) RETURN VARCHAR2 IS

      l_codsg ligne_bip.codsg%TYPE;

   BEGIN
      SELECT  lib.codsg
       INTO  l_codsg
       FROM  ligne_bip lib
       WHERE lib.pid = p_pid;

      RETURN TO_CHAR(l_codsg, 'FM0000000');

   END f_get_codsg_lbip;


   -- ------------------------------------------------------------------------
   -- Nom        :  f_formater_budget
   -- Auteur     :  Equipe SOPRA
   -- Decription :  Formatage des Montants  de la table tmp_budget_sstache
   -- Paramètres :  p_val      (IN)      Montant à formater
   --
   -- Retour     :  p_val au format 'FM9G999G999G999G999D0' si possible, sinon p_val tel quel!!!
   --
   -- ------------------------------------------------------------------------

FUNCTION f_formater_budget(p_val VARCHAR2) RETURN VARCHAR2 is
    l_val VARCHAR2(30);

BEGIN

  l_val := LTRIM(RTRIM(p_val));

  IF ( (l_val IS NULL) OR (l_val  = CST_BUD_XXXX) ) THEN
    RETURN(l_val );
  ELSE
      RETURN( TO_CHAR(TO_NUMBER(l_val ), 'FM9G999G999G999G999D0') );
  END IF;


EXCEPTION
    WHEN OTHERS THEN RETURN(l_val );

END f_formater_budget;


   -- ------------------------------------------------------------------------
   -- Nom        :  f_conso_mois_a_afficher
   -- Auteur     :  Equipe SOPRA
   -- Decription :  Retourne le montant qui sera affiché dans le Report pour les états PRODEC2,3,4,L ou NULL
   -- Paramètres :  p_cusag      (IN)      Montant du consommé
   --              p_cdeb (IN)          Date du consommé (Date)
   --              p_mois  (IN)         Mois traité ( format 'MM')
   --              p_mois_maxi (IN)     Mois maxi à traiter ( format 'MM')
   --                            (Si p_mois > p_mois_maxi, on retourne NULL!!!)
   --
   -- Retour     :  Le montant du consommé (p_cusag) si Mois de p_cdeb = p_mois et p_mois <= p_mois_maxi
   --           NULL dans le cas contraire
   -- ------------------------------------------------------------------------
   FUNCTION f_conso_mois_a_afficher(p_cusag     IN cons_sstache_res_mois.cusag%TYPE,
                    p_cdeb      IN cons_sstache_res_mois.cdeb%TYPE,
                    p_mois      IN VARCHAR2,
                    p_mois_maxi IN VARCHAR2
                ) RETURN NUMBER IS
  BEGIN

    IF ( (p_mois <= p_mois_maxi) AND (TO_CHAR(p_cdeb,'MM') = p_mois) ) THEN
        RETURN (p_cusag);
    ELSE
        RETURN (NULL);
    END IF;

  END f_conso_mois_a_afficher;


   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_lib_statut
   -- Auteur     :  Equipe SOPRA
   -- Decription :  recupere le libelle d'un code statut
   -- Paramètres :  p_astatut (IN) Code statut
   --
   -- Retour     :  le libelle du statut
   --
   -- Quand    Qui      Quoi
   -- -----    ---      --------------------------------------------------------
   -- 15/03/00 HTM      Création

   -- ------------------------------------------------------------------------
   FUNCTION f_get_lib_statut(p_astatut IN code_statut.astatut%TYPE) RETURN VARCHAR2 IS

      l_res code_statut.libstatut%TYPE;

   BEGIN

    IF  ( (p_astatut IS NULL) OR p_astatut = ' ' ) THEN
        l_res := 'En Cours';
    ELSE
          SELECT  sta.libstatut
        INTO  l_res
        FROM  code_statut sta
        WHERE sta.astatut = p_astatut;
      END IF;

      RETURN l_res;

    EXCEPTION
          WHEN OTHERS THEN RETURN '';

   END f_get_lib_statut;

   -- ------------------------------------------------------------------------
   -- Nom        : calc_prop_budget2 (Construit à partir de calc_prop_budget!!!)
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget propose pour une annee
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_date_cour (IN) Date courante (En principe, SYSDATE ou datdebex)
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION calc_prop_budget2 (p_pid          IN budget.pid%TYPE,
                   p_annee        IN budget.annee%TYPE,
                   p_date_cour IN DATE
                     ) RETURN VARCHAR2 IS

      l_bpmont1 budget.bpmontme%TYPE;

   BEGIN

          -- Le select fait la somme des montants pour un projet et une annee
          -- le decode est present dans le cas d'un historique p_annee = N-2
          -- ou l'on doit faire la somme des budgets sinon on prend l'annee
          -- p_annee (prb.bpannee <= p_annee ET prb.bpannee >= p_annee équivaut à prb.bpannee = p_annee )
          -- N annee courante
          SELECT  sum(b.bpmontme)
    INTO  l_bpmont1
    FROM  budget b
    WHERE b.pid = p_pid
    AND   b.annee <= p_annee
    AND   b.annee >= decode(p_annee,
                    to_number(to_char(p_date_cour, 'YYYY')) - 2 , 0,
                    p_annee);

    RETURN to_char(l_bpmont1, 'FM9999999999D00');

   EXCEPTION
          WHEN OTHERS THEN RETURN 'NOK';

   END calc_prop_budget2;

   -- ------------------------------------------------------------------------
   -- Nom        : calc_budg_notif2
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget notifier pour une annee
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_date_cour (IN) Date courante (En principe, SYSDATE ou datdebex)
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION calc_budg_notif2 (p_pid         IN budget.pid%TYPE,
                  p_annee       IN budget.annee%TYPE,
                  p_date_cour IN DATE
                ) RETURN VARCHAR2 IS

      l_bnmont budget.bnmont%TYPE;

   BEGIN

      -- Le select fait la somme des montants pour un projet et une annee
      -- le decode est present dans le cas d'un historique p_annee = N-2
      -- ou l'on doit faire la somme des budgets sinon on prend l'annee
      -- p_annee (<= + >= donne =)
      -- N annee courante
      SELECT  sum(b.bnmont)
    INTO  l_bnmont
    FROM  budget b
    WHERE b.pid = p_pid
    AND   b.annee <= p_annee
       AND   b.annee >= decode(p_annee,
                    to_number(to_char(p_date_cour, 'YYYY')) - 2 , 0,
                    p_annee);

    RETURN to_char(l_bnmont, 'FM9999999999D00');

   EXCEPTION
      WHEN OTHERS THEN RETURN 'NOK';

   END calc_budg_notif2;

   -- ------------------------------------------------------------------------
   -- Nom        : calc_budg_arb_notif2
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget arbitrer notifier pour une annee
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_date_cour (IN) Date courante (En principe, SYSDATE ou datdebex)
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION calc_budg_arb_notif2 (p_pid       IN budget.pid%TYPE,
                  p_annee     IN budget.annee%TYPE,
                  p_date_cour     IN DATE
                ) RETURN VARCHAR2 IS

      l_anmont budget.anmont%TYPE;

   BEGIN

      -- Le select fait la somme des montants pour un projet et une annee
      -- le decode est present dans le cas d'un historique p_annee = N-2
      -- pour avoir la condition : 0 >= 0
      -- ou l'on doit faire la somme des budgets sinon on prend l'annee
      -- p_annee (<= + >= donne =)
      -- N annee courante
      SELECT  sum(b.anmont)
    INTO  l_anmont
    FROM  budget b
    WHERE b.pid = p_pid
    AND   b.annee <= p_annee
    AND   b.annee >= decode(p_annee,
                    to_number(to_char(p_date_cour, 'YYYY')) - 2 , 0,
                    p_annee
                    );

    RETURN to_char(l_anmont, 'FM9999999999D00');

   EXCEPTION
      WHEN OTHERS THEN RETURN 'NOK';

   END calc_budg_arb_notif2;

   -- ------------------------------------------------------------------------
   -- Nom        : calc_budg_reestime
   -- Auteur     : OEL (EL KHABZI OUSSAMA) - QC 1266
   -- Decription : calcul le budget arbitrer notifier pour une annee
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_date_cour (IN) Date courante (En principe, SYSDATE ou datdebex)
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------

       FUNCTION calc_budg_reestime (p_pid       IN budget.pid%TYPE,
                             p_annee     IN budget.annee%TYPE,
                             p_date_cour     IN DATE)
                             RETURN VARCHAR2 IS

      l_anmont budget.anmont%TYPE;

   BEGIN

      -- Le select fait la somme des montants pour un projet et une annee
      -- le decode est present dans le cas d'un historique p_annee = N-2
      -- pour avoir la condition : 0 >= 0
      -- ou l'on doit faire la somme des budgets sinon on prend l'annee
      -- p_annee (<= + >= donne =)
      -- N annee courante

        SELECT  sum(b.reestime)
        INTO  l_anmont
        FROM  budget b
        WHERE b.pid = p_pid
        AND   b.annee <= p_annee
        AND   b.annee >= decode(p_annee, to_number(to_char(p_date_cour, 'YYYY')) - 2 , 0, p_annee);

    RETURN to_char(l_anmont, 'FM9999999999D00');

   EXCEPTION
      WHEN OTHERS THEN RETURN 'NOK';

   END calc_budg_reestime;

   -- ------------------------------------------------------------------------
   -- Nom        : calc_cons_sstache_res_mois2
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget consomme pour une annee
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_date_cour (IN) Date courante (En principe, SYSDATE ou datdebex)
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION calc_cons_sstache_res_mois2 (p_pid       IN cons_sstache_res_mois.pid%TYPE,
                     p_annee     IN cons_sstache_res_mois.cdeb%TYPE,
                     p_date_cour IN DATE
                       ) RETURN VARCHAR2 IS

      l_cusag  NUMBER(12,2);
      l_cusag1  NUMBER(12,2);

   BEGIN

      -- Le select fait la somme des montants pour un projet et une annee
      -- Sans prendre les sous-traitances
      -- le decode est present dans le cas d'un historique p_annee = N-2
      -- ou l'on doit faire la somme des budgets sinon on prend l'annee
      -- p_annee (<= + >= donne =)
      -- N annee courante
      SELECT  sum(csr.cusag)
    INTO  l_cusag
    FROM  cons_sstache_res_mois csr,
    tache tac,
    situ_ress sir
    WHERE csr.pid = p_pid
    AND   tac.pid = csr.pid
    AND   tac.acta = csr.acta
    AND   tac.acst = csr.acst
    AND   tac.ecet = csr.ecet
    AND   ((tac.aistty != 'FF') OR (tac.aistty IS NULL))
    AND   trunc(csr.cdeb, 'YEAR') <= trunc(p_annee, 'YEAR')
    AND   trunc(csr.cdeb, 'YEAR') >= decode(p_annee,
                        add_months(trunc(p_date_cour, 'YEAR'), -24) ,
                        to_date('01/01/1900', 'dd/mm/yyyy'),
                        p_annee)
    AND csr.ident != 0    -- HTM 08/06/00 : Exclusion de la Ressource 0
    -- jointure avec la table situ_ress
    AND sir.ident = csr.ident
    AND TRUNC(sir.datsitu,'MONTH')  <= TRUNC(csr.cdeb,'MONTH')
    AND   ( (csr.cdeb <= sir.datdep) OR (sir.datdep IS NULL) )
    AND   ( (sir.prestation != 'GRA') AND (sir.prestation!='IFO')
                                                  AND (sir.prestation!='INT')
                                           AND (sir.prestation!='MO ')
                                         AND (sir.prestation!='STA')
                                          )
    ;

      -- Meme chose mais on prend les consommes des sous-traitances
      -- donne par le projet
      SELECT  sum(csr.cusag)
    INTO  l_cusag1
    FROM  cons_sstache_res_mois csr,
    tache tac,
    situ_ress sir
    WHERE tac.aistpid = p_pid
    AND   tac.aistty  = 'FF'
    AND   tac.pid = csr.pid
    AND   tac.acta = csr.acta
    AND   tac.acst = csr.acst
    AND   tac.ecet = csr.ecet
    AND   trunc(csr.cdeb, 'YEAR') <= trunc(p_annee, 'YEAR')
    AND   trunc(csr.cdeb, 'YEAR') >= decode(p_annee,
                        add_months(trunc(p_date_cour, 'YEAR'), -24),
                        to_date('01/01/1900', 'dd/mm/yyyy'),
                        p_annee)
    AND csr.ident != 0    -- HTM 08/06/00 : Exclusion de la Ressource 0
    -- jointure avec la table situ_ress
    AND sir.ident = csr.ident
    AND TRUNC(sir.datsitu,'MONTH')  <= TRUNC(csr.cdeb,'MONTH')
    AND   ( (csr.cdeb <= sir.datdep) OR (sir.datdep IS NULL) )
    AND   ( (sir.prestation != 'GRA') AND (sir.prestation!='IFO')
                                                  AND (sir.prestation!='INT')
                                           AND (sir.prestation!='STA')
                                         AND (sir.prestation!='MO ') )
    ;

      l_cusag := nvl(l_cusag, 0) + nvl(l_cusag1, 0);
      IF l_cusag = 0 THEN
     RETURN NULL;
      ELSE
      RETURN to_char(l_cusag, 'FM9999999999D00');
      END IF;

   EXCEPTION
      WHEN OTHERS THEN RETURN 'NOK';

   END calc_cons_sstache_res_mois2;

   -- ------------------------------------------------------------------------
   -- Nom        : calc_cons_annee_prec
   -- Auteur     : MMC
   -- Decription : calcul le budget consomme pour l'annee precedente
   --
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   --              p_indic_annee IN VARCHAR2
   -- Retour     : un  varchar2 avec le montant
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION calc_cons_annee_prec (p_pid    IN consomme.pid%TYPE,
                  p_annee IN consomme.annee%TYPE,
                  p_indic_annee IN VARCHAR2
                  ) RETURN VARCHAR2 IS

   l_montant_res consomme.cusag%TYPE ;

BEGIN
    begin
    if p_indic_annee='p' then
        SELECT cusag
        INTO  l_montant_res
        FROM  consomme
        WHERE pid = p_pid
        AND annee = p_annee;

    else SELECT xcusag
        INTO  l_montant_res
        FROM  consomme
        WHERE pid = p_pid
        AND annee = p_annee;
    end if;

    RETURN(to_char(l_montant_res, 'FM9999999999D00'));

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN NULL;
             WHEN OTHERS THEN RETURN 'NOK';
    end;
   END calc_cons_annee_prec;


   -- ------------------------------------------------------------------------
   -- Nom        : decode_amortissement
   -- Auteur     : Equipe SOPRA
   -- Decription : test pour renvoyer l'amortissement dans les editions prodec2
   --              et edition ligne BIP
   --
   -- Paramètres : p_type    (IN) code type de projet
   --              p_astatut (IN) statut de l'amortissement
   -- Retour     : un  varchar2 avec 'OUI' ou 'NON'
   --               un  varchar2 avec 'NOK' si erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION decode_amortissement (p_type ligne_bip.typproj%TYPE,
                  p_astatut ligne_bip.astatut%TYPE
                 ) RETURN VARCHAR2 IS
   BEGIN

    IF (
        ( (p_type = '1 ') AND ((p_astatut != 'N') OR  (p_astatut IS NULL)) )
                            OR
          ( ((p_type != '1 ') OR (p_type IS NULL)) AND (p_astatut = 'O') )
        ) THEN
        RETURN( 'OUI' );
    ELSE
        RETURN( 'NON' );
    END IF;

   END decode_amortissement;


   -- ------------------------------------------------------------------------
   -- Nom        : tmp_sstache2
   -- Auteur     : Equipe SOPRA  (HTM 23/02/2000)
   -- Decription : met a jour de la table tmp_conso_sstache a partir des tables
   --              cons_sstache_res_mois, proplus, tache et etape
   -- Paramètres :
   --               p_nom_etat (IN)         Nom de l'état traité (PRODEC2, 3, 4, ou L)
   --           p_clicode   (IN)     Code direction
   --              p_codsg    (IN)       Code DPG (Pouvant contenir des * à la fin!!!)
   --               p_pid      (IN)       Code ligne BIP
   --               p_id_proj_ou_appli     (IN)       Code référentiel (Identifiant Projet ou Application)
   --              p_date_traite (IN)    Date à prendre en compte
   --             (L'année de cette date correspond à l'année N !!! dans l'état!!!)
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- Remarque   : Le filtre sur p_clicode serait trop coûteux : Ce paramètre
   --             est inutilisé pour l'instant!!!
   -- ------------------------------------------------------------------------
   FUNCTION tmp_sstache2 (
                    p_nom_etat     IN VARCHAR2,
                    p_clicode       IN client_mo.clicode%TYPE,
                    p_codsg        IN VARCHAR2,
                    p_pid          IN ligne_bip.pid%TYPE,
                    p_appli         IN VARCHAR2,
                    p_projet         IN VARCHAR2,
                    p_date_traite     IN DATE
                    ) RETURN NUMBER IS

      l_var_seq NUMBER;       -- Numero de séquence

    -- Déclaration curseurs
    -- Sert à récupérer les identifiants (PID) de cons_sstache_res_mois pour qualif != 'GRA' dans proplus
          -- ramene les informations de cons_sstache_res_mois
          -- il faut encore filtrer par rapport a TACHE pour enlever les taches dont aistty != 'FC' et 'DF'

    lc_conso ConsoCurTyp;        -- Variable Curseur pour conso


    -- declaration des variables pour les curseurs.
     lc_lig_conso ConsoCurRecTyp;

    -- Mois maxi à prendre en compte (Vaut '12' si on prend en compte tous les mois!!!)
    l_mois_maxi_a_traiter VARCHAR2(2);

   BEGIN
      -- Initialisations
    l_mois_maxi_a_traiter := TO_CHAR(p_date_traite, 'MM');
      SELECT sconso.nextval INTO l_var_seq FROM dual;

    -- Ouverture Curseur
    IF NOT lc_conso%ISOPEN THEN
        IF p_pid='Tout' THEN
            -- isac : etat lancé pour toutes le lignes bip de l'utilisateur
            -- p_nom_etat devient l identifiant de l'utilisateur
         ouvrir_conso_tout(lc_conso, p_nom_etat, p_date_traite);
        ELSE
         ouvrir_conso_cv(lc_conso, p_nom_etat, p_clicode, p_codsg, p_pid, p_appli,p_projet, p_date_traite);
        END IF;

    END IF;

       -- Boucle sur le curseur ...
      LOOP
     -- Fetch du curseur des conso
     FETCH  lc_conso INTO lc_lig_conso;

     -- condition de sortie
     EXIT WHEN lc_conso%NOTFOUND;

    /*******************************************************************************************************
     DBMS_OUTPUT.PUT_LINE( ' ');
     DBMS_OUTPUT.PUT_LINE( ' ');
     DBMS_OUTPUT.PUT_LINE('FETCH : PID:' || lc_lig_conso.pid || ' CUSAG:' || lc_lig_conso.cusag ||' CDEB:'|| lc_lig_conso.cdeb
                                    || ' ACTA:' || lc_lig_conso.acta ||' ACST:'|| lc_lig_conso.acst
                                      || ' ECET:' || lc_lig_conso.ecet);
    ********************************************************************************************************/

     INSERT INTO tmp_conso_sstache (numseq ,
                    typetap,
                    id     ,        -- AIST : Type de sous-tâche
                    aist,
                    asnom  ,        -- Libellé sous-tâche
                    pid    ,
                    codsg  ,
                    pnom   ,
                    acst   ,        -- N° sous-tâche
                    janv   ,
                    fevr   ,
                    mars   ,
                    avril  ,
                    mai    ,
                    juin   ,
                    juil   ,
                    aout   ,
                    sept   ,
                    octo   ,
                    nove   ,
                    dece
                    )
       (SELECT l_var_seq,
        eta.typetap,
            tac.aistty || tac.aistpid,                  -- FF et ligne bip sous traitance
            tac.aist,
        tac.asnom,
        tac.pid,
        TO_NUMBER(f_get_codsg_lbip(tac.pid)),   -- codsg de la ligne_bip
        f_get_pnom_lbip(tac.pid),   -- pnom de la ligne_bip
        tac.acst,
        f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '01', l_mois_maxi_a_traiter) janv,
            f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '02', l_mois_maxi_a_traiter) fevr,
        f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '03', l_mois_maxi_a_traiter) mars,
        f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '04', l_mois_maxi_a_traiter) avril,
        f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '05', l_mois_maxi_a_traiter) mai,
        f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '06', l_mois_maxi_a_traiter) juin,
        f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '07', l_mois_maxi_a_traiter) juil,
        f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '08', l_mois_maxi_a_traiter) aout,
        f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '09', l_mois_maxi_a_traiter) sept,
        f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '10', l_mois_maxi_a_traiter) octo,
        f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '11', l_mois_maxi_a_traiter) nove,
        f_conso_mois_a_afficher(lc_lig_conso.cusag, lc_lig_conso.cdeb, '12', l_mois_maxi_a_traiter) dece
        FROM  tache tac,
                etape eta
        WHERE tac.pid  = lc_lig_conso.pid
        AND   tac.acta = lc_lig_conso.acta
        AND   tac.acst = lc_lig_conso.acst
        AND   tac.ecet = lc_lig_conso.ecet
        AND   eta.pid  = tac.pid
        AND   eta.ecet = tac.ecet            -- N° Etape
        AND   ( (tac.aistty NOT IN ('FC', 'DF')) OR (tac.aistty IS NULL) )
        ----------------------------------------------------------------
        -- HTM 31/03/00
        -- (tac.aistty IS NULL) permet de prendre en compte les consommés en direct!
        ----------------------------------------------------------------
        );

     COMMIT;

      END LOOP;

    -- Fermeture Curseur
    CLOSE lc_conso;

      RETURN l_var_seq;

   EXCEPTION
      WHEN OTHERS THEN RETURN 0;
    --WHEN OTHERS THEN raise_application_error(-20997, sqlerrm);


   END tmp_sstache2;

   -- ------------------------------------------------------------------------
   -- Nom        : tmp_sstache_budget2
   -- Auteur     : Equipe SOPRA
   -- Decription : met a jour de la table tmp_budget_sstache a partir des tables
   --              cons_sstache_res_mois, prop_budget, budg_notif, budg_arb_notif
   --              budg_arb_notif
   -- Paramètres :
   --             p_nom_etat (IN)         Nom de l'état traité (PRODEC2, 3, 4, ou L)
   --           p_clidom   (IN)     Code direction
   --          p_codsg    (IN)       Code DPG (Pouvant contenir des * à la fin!!!)
   --             p_pid      (IN)       Code ligne BIP
   --             p_id_proj_ou_appli     (IN)       Code référentiel (Identifiant Projet ou Application)
   --          p_date_traite (IN)    Date à prendre en compte
   --         (L'année de cette date correspond à l'année N !!! dans l'état!!!)
   --           p_clicode   (IN)     Code direction
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   --
   -- ------------------------------------------------------------------------
   FUNCTION tmp_sstache_budget2 (
                    p_nom_etat     IN VARCHAR2,
                    p_clicode       IN client_mo.clicode%TYPE,
                    p_codsg        IN VARCHAR2,
                    p_pid          IN ligne_bip.pid%TYPE,
                    p_appli     IN VARCHAR2,
                    p_projet     IN VARCHAR2,
                    p_date_traite     IN DATE
                    ) RETURN NUMBER IS

      -- numero de sequence
      l_var_seq NUMBER;

    lc_pid BudgetCurTyp;        -- Variable Curseur

    -- declaration des variables pour les curseurs.
    lc_lig_pid BudgetCurRecTyp;


    l_temp1 VARCHAR2(50);
    l_temp2 VARCHAR2(50);
    l_temp3 VARCHAR2(50);
    l_temp4 VARCHAR2(50);
    l_temp5 VARCHAR2(50);
    l_temp6 VARCHAR2(50);



   BEGIN

      SELECT sbudget.nextval INTO l_var_seq FROM dual;

    -- DBMS_OUTPUT.PUT_LINE(' Avant ouvrir_budget_cv ');
    -- Ouverture Curseur

    IF NOT lc_pid%ISOPEN THEN
        IF p_pid='Tout' THEN
            -- isac : etat lancé pour toutes le lignes bip de l'utilisateur
            -- p_nom_etat devient l identifiant de l'utilisateur
         ouvrir_budget_tout(lc_pid, p_nom_etat);
        ELSE
         ouvrir_budget_cv(lc_pid, p_nom_etat, p_clicode, p_codsg, p_pid, p_appli,p_projet, p_date_traite);
        END IF;
    END IF;

    -- DBMS_OUTPUT.PUT_LINE(' Après ouvrir_budget_cv ');

      LOOP

     FETCH lc_pid INTO lc_lig_pid;
     EXIT WHEN lc_pid%NOTFOUND;


     -- DBMS_OUTPUT.PUT_LINE('FETCH :' || lc_lig_pid.pid ||' '|| l_var_seq );

     -- insert dans la table tmp_budget_sstache de budget propose
          l_temp1 :=   calc_prop_budget2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) -2), p_date_traite);
          l_temp2 :=   calc_prop_budget2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) -1), p_date_traite);
          l_temp3 :=   calc_prop_budget2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY'))), p_date_traite);
          l_temp4 :=   calc_prop_budget2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) +1), p_date_traite);
          l_temp5 :=   calc_prop_budget2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) +2), p_date_traite);
          l_temp6 :=   calc_prop_budget2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) +3), p_date_traite);

INSERT INTO tmp_budget_sstache (numseq,
                     typeb,
                     pid,
                     histo,
                     minus1,
                     n,
                     plus1,
                     plus2,
                     plus3,
                     total)
       VALUES ( l_var_seq,
            'A',
            lc_lig_pid.pid,
           l_temp1,
           l_temp2,
           l_temp3,
           l_temp4,
           l_temp5,
           l_temp6,
           to_char( nvl(to_number(l_temp1), 0) + nvl(to_number(l_temp2), 0) + nvl(to_number(l_temp3), 0)+ nvl(to_number(l_temp4), 0)
           + nvl(to_number(l_temp5), 0)+ nvl(to_number(l_temp6), 0),
                  'FM9999999D00' )

            );

     -- insert dans la table tmp_budget_sstache de budget notifier
     l_temp1 := calc_budg_notif2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) -2), p_date_traite);
     l_temp2 := calc_budg_notif2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) -1), p_date_traite);
     l_temp3 := calc_budg_notif2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY'))), p_date_traite);

     INSERT INTO tmp_budget_sstache (numseq,
                     typeb,
                     pid,
                     histo,
                     minus1,
                     n,
                     plus1,
                     plus2,
                     plus3,
                     total)
       VALUES (l_var_seq,
           'B',
           lc_lig_pid.pid,
           l_temp1,
           l_temp2,
           l_temp3,
           CST_BUD_XXXX,
           CST_BUD_XXXX,
           CST_BUD_XXXX,
           to_char( nvl(to_number(l_temp1), 0) + nvl(to_number(l_temp2), 0) + nvl(to_number(l_temp3), 0),
                  'FM9999999D00' )
           );

     -- insert dans la table tmp_budget_sstache de budget arbitré notifié
     l_temp1 := calc_budg_arb_notif2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) -2), p_date_traite);
     l_temp2 := calc_budg_arb_notif2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) -1), p_date_traite);
     l_temp3 := calc_budg_arb_notif2(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY'))), p_date_traite);

     INSERT INTO tmp_budget_sstache (numseq,
                     typeb,
                     pid,
                     histo,
                     minus1,
                     n,
                     plus1,
                     plus2,
                     plus3,
                     total)
       VALUES (l_var_seq,
           'C',
           lc_lig_pid.pid,
           l_temp1,
           l_temp2,
           l_temp3,
           CST_BUD_XXXX,
           CST_BUD_XXXX,
           CST_BUD_XXXX,
           to_char( nvl(to_number(l_temp1), 0) + nvl(to_number(l_temp2), 0) + nvl(to_number(l_temp3), 0),
                  'FM9999999D00')
           );

     -- insert dans la table tmp_budget_sstache de budget reestime

     -- QC 1266 ---------------------------------------------------------------------------------------------------
     l_temp1 := calc_budg_reestime(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) -2), p_date_traite);
     l_temp2 := calc_budg_reestime(lc_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) -1), p_date_traite);
     --------------------------------------------------------------------------------------------------------------

     INSERT INTO tmp_budget_sstache (numseq,
                     typeb,
                     pid,
                     histo,
                     minus1,
                     n,
                     plus1,
                     plus2,
                     plus3,
                     total)
       (SELECT l_var_seq,
        'D',
        lc_lig_pid.pid,
        l_temp1,
        l_temp2,
        to_char(budg.reestime, 'FM9999999999999'),
        CST_BUD_XXXX,
        CST_BUD_XXXX,
        CST_BUD_XXXX,
        to_char( nvl(to_number(l_temp1), 0) + nvl(to_number(l_temp2), 0) + nvl(budg.reestime, 0),
                  'FM9999999D00')
        FROM budget budg,ligne_bip lb
        WHERE budg.pid (+)= lb.pid
        AND lb.pid = lc_lig_pid.pid
        AND budg.annee (+)= TO_NUMBER(TO_CHAR(p_date_traite,'YYYY'))
        );

     -- insert dans la table tmp_budget_sstache de budget consomme
     -- ATTENTION ICI LE SECOND PARAM EST DE TYPE DATE

     l_temp1 := calc_cons_annee_prec(lc_lig_pid.pid, (to_number(to_char(p_date_traite,'YYYY'))-2), 'h');
     l_temp2 := calc_cons_annee_prec(lc_lig_pid.pid, (to_number(to_char(p_date_traite,'YYYY'))-1), 'p');
     l_temp3 := calc_cons_sstache_res_mois2(lc_lig_pid.pid, trunc(p_date_traite, 'YEAR'), p_date_traite);

     INSERT INTO tmp_budget_sstache (numseq,
                     typeb,
                     pid,
                     histo,
                     minus1,
                     n,
                     plus1,
                     plus2,
                     plus3,
                     total)
       VALUES (l_var_seq,
           'E',
           lc_lig_pid.pid,
           l_temp1,
           l_temp2,
           l_temp3,
           CST_BUD_XXXX,
           CST_BUD_XXXX,
           CST_BUD_XXXX,
           to_char( nvl(to_number(l_temp1), 0) + nvl(to_number(l_temp2), 0) + nvl(to_number(l_temp3), 0),
                 'FM9999999D00')
           );

     commit;

      END LOOP;

      -- Fermeture du curseur
      CLOSE lc_pid;

      RETURN l_var_seq;

   EXCEPTION
      WHEN OTHERS THEN RETURN 0;
    -- WHEN OTHERS THEN raise_application_error(-20997, sqlerrm);
   END tmp_sstache_budget2;


--****************************************************************************
-- Les Procédures
--****************************************************************************

   -- ------------------------------------------------------------------------
   -- Nom        :  ouvrir_conso_cv (Procédure)
   -- Auteur     :  Equipe SOPRA
   -- Decription :  Ouverture variable curseur de type ConsoCurTyp
   -- Paramètres :  p_curv    (IN/OUT)     Curseur à ouvrir
   --               p_nom_etat (IN)         Nom de l'état traité (PRODEC2, 3, 4, ou L)
   --           p_clicode   (IN)     Code direction
   --              p_codsg    (IN)       Code DPG (Pouvant contenir des * à la fin!!!)
   --               p_pid      (IN)       Code ligne BIP
   --               p_id_proj_ou_appli     (IN)       Code référentiel (Identifiant Projet ou Application)
   --              p_date_traite (IN)    Date à prendre en compte
   --                 Le mois de cette date est le mois maxi à traiter
   --                 L'année de cette date correspond à l'année à traiter
   --
   -- Retour     :
   --
   -- Remarque   : On ne peut avoir p_codsg et p_pid tous les 2 non NULS!!!
   -- ------------------------------------------------------------------------
 PROCEDURE ouvrir_conso_cv(
                    p_curv         IN OUT ConsoCurTyp,
                    p_nom_etat     IN VARCHAR2,
                    p_clicode       IN client_mo.clicode%TYPE,
                    p_codsg        IN VARCHAR2,
                    p_pid          IN ligne_bip.pid%TYPE,
                    p_appli IN VARCHAR2,
                    p_projet IN VARCHAR2,
                    p_date_traite     IN DATE
                    ) IS

    l_annee_traite VARCHAR2(4);
    l_mois_maxi_traite VARCHAR2(2);
    l_derjour_mois_maxi_traite VARCHAR2(2);

    l_date_mini DATE;
    l_date_maxi DATE;
    l_dir varchar2(10);

 BEGIN

 /********************************************************************************
  * Seul le paramètre "p_date_traite" est pris en compte :
  * On conserve les autres paramètres pour le  cas où!!!
  ********************************************************************************/

    l_annee_traite := TO_CHAR(p_date_traite, 'YYYY');
    l_mois_maxi_traite  := TO_CHAR(p_date_traite, 'MM');
        l_derjour_mois_maxi_traite := TO_CHAR( LAST_DAY(TO_DATE('01' || '/' || l_mois_maxi_traite  || '/' || l_annee_traite, 'DD/MM/YYYY')), 'DD' );

    l_date_mini := TO_DATE('01/01/' || l_annee_traite, 'DD/MM/YYYY');
    l_date_maxi := TO_DATE(l_derjour_mois_maxi_traite || '/' || l_mois_maxi_traite || '/' || l_annee_traite, 'DD/MM/YYYY');

--     -- 02/03/2001 : filtre sur p_clidom (direction ou département)
--      -- tester si p_clidom est une direction ou un département
--      BEGIN
--           select 'dir' into l_dir
--        from client_mo
--        where
--         clicode=p_clicode;
--          EXCEPTION
--        WHEN NO_DATA_FOUND THEN   --départment
--        l_dir :='dpt';
--          END;

    -----------------------------------------------------------------------------------------
    -- ON PREND CONSOMMES DE L'ANNEE TRAITEE ET DES MOIS <= Mois maxi à traiter (Mois saisi)
      -- (l_date_mini <= cdeb <= l_date_maxi )
    --                +
    -- Filtres supplémentaires suivant Etat
    -----------------------------------------------------------------------------------------

    IF ( (p_nom_etat = 'PRODECL') AND (p_pid IS NOT NULL) ) THEN
        -- PRODECL Avec Code ligne BIP Obligatoirement Saisi (Code DPG  est non saisi)!!!

OPEN p_curv FOR
SELECT
      csr.cdeb   cdeb,
      csr.pid   pid,
      csr.acta   acta,
      csr.acst  acst,
      csr.ecet  ecet,
      SUM(csr.cusag)    cusag
FROM
(
  ------------------------------------------------------------------------------------
  -- Cas 1 : Ressource avec bonne situation
  -- On teste prestation != 'GRA' !!!
  ------------------------------------------------------------------------------------
  SELECT
      csr1.cdeb       cdeb,
      csr1.pid           pid,
      csr1.acta       acta,
      csr1.acst          acst,
      csr1.ecet          ecet,
      SUM(csr1.cusag)   cusag
    FROM  cons_sstache_res_mois csr1,
          situ_ress sir1
    WHERE
    sir1.ident = csr1.ident
      AND    TRUNC(sir1.datsitu,'MONTH')  <= TRUNC(csr1.cdeb,'MONTH')
      AND   ( (csr1.cdeb <= sir1.datdep) OR (sir1.datdep IS NULL) )
      AND sir1.prestation!='GRA'
      AND sir1.prestation!='IFO'
      AND sir1.prestation!='INT'
      AND sir1.prestation!='MO '
      AND sir1.prestation!='STA'
      AND sir1.prestation IS NOT NULL
         AND   (csr1.cdeb BETWEEN l_date_mini AND l_date_maxi )
        AND   csr1.ident != 0
      AND   csr1.cusag != 0
      -------------------------------------------------------------------
      -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
      --------------------------------------------------------------------
      AND  csr1.pid IN ( SELECT pro1.pid FROM proplus pro1
                    WHERE pro1.factpid = p_pid
                    AND ( pro1.cdeb BETWEEN l_date_mini AND l_date_maxi ))
     GROUP BY csr1.pid, csr1.cdeb, csr1.acta, csr1.acst, csr1.ecet
   -----------------------------------------------------------------------
   UNION ALL
   ------------------------------------------------------------------------
   ------------------------------------------------------------------------------------
   -- Cas 2 : Ressource avec mauvaise situation
   -- Correspond à tous les cas autres que Cas 1 :
   ------------------------------------------------------------------------------------
   SELECT
       csr2.cdeb       cdeb,
       csr2.pid       pid,
       csr2.acta       acta,
       csr2.acst      acst,
       csr2.ecet      ecet,
       SUM(csr2.cusag)  cusag
    FROM  cons_sstache_res_mois csr2
    WHERE
         NOT EXISTS     (
                    SELECT 1 from situ_ress sir2
                    WHERE  sir2.ident = csr2.ident
                    AND   TRUNC(sir2.datsitu,'MONTH')  <= TRUNC(csr2.cdeb,'MONTH')
                    AND   ( (csr2.cdeb <= sir2.datdep) OR (sir2.datdep IS NULL) )
                    AND   ( (sir2.prestation != 'GRA') OR (sir2.prestation!='IFO')
                                                  OR (sir2.prestation!='INT')
                                           OR (sir2.prestation!='MO ')
                                         OR (sir2.prestation!='STA') )
                  )
         AND ( csr2.cdeb BETWEEN l_date_mini AND l_date_maxi )
         AND csr2.ident != 0
    AND csr2.cusag != 0
     -------------------------------------------------------------------
     -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
     -------------------------------------------------------------------
     AND csr2.pid IN (     SELECT pro2.pid FROM proplus pro2
                    WHERE pro2.factpid = p_pid
                    AND ( pro2.cdeb BETWEEN l_date_mini AND l_date_maxi ))
    GROUP BY csr2.pid, csr2.cdeb, csr2.acta, csr2.acst, csr2.ecet
) csr
GROUP BY csr.pid, csr.cdeb, csr.acta, csr.acst, csr.ecet
;

  ELSIF ( (p_nom_etat = 'PRODECL') AND (p_codsg IS NOT NULL) AND (p_codsg <> CST_CODE_DPG_TOUS) ) THEN
    -- PRODECL Avec Code DPG différent de '******' saisi (Code ligne BIP n'est pas saisi) !!!

OPEN p_curv FOR
SELECT
      csr.cdeb  cdeb,
      csr.pid   pid,
      csr.acta  acta,
      csr.acst  acst,
      csr.ecet  ecet,
      SUM(csr.cusag)    cusag
FROM
(
  ------------------------------------------------------------------------------------
  -- Cas 1 : Ressource avec bonne situation
  -- On teste prestation != 'GRA' !!!
  ------------------------------------------------------------------------------------
  SELECT
      csr1.cdeb       cdeb,
      csr1.pid       pid,
      csr1.acta       acta,
      csr1.acst      acst,
      csr1.ecet      ecet,
      SUM(csr1.cusag)   cusag
    FROM  cons_sstache_res_mois csr1,
          situ_ress sir1
    WHERE
      sir1.ident = csr1.ident
      AND  TRUNC(sir1.datsitu,'MONTH')  <= TRUNC(csr1.cdeb,'MONTH')
      AND   ( (csr1.cdeb <= sir1.datdep) OR (sir1.datdep IS NULL) )
      AND sir1.prestation!='GRA'
      AND sir1.prestation!='IFO'
      AND sir1.prestation!='INT'
      AND sir1.prestation!='MO '
      AND sir1.prestation!='STA'
      AND   (csr1.cdeb BETWEEN l_date_mini AND l_date_maxi )
      AND   csr1.ident != 0
      AND   csr1.cusag != 0
      -------------------------------------------------------------------
      -- Ne prendre que les lignes concernant le codsg saisie
      --------------------------------------------------------------------
      AND  csr1.pid IN ( SELECT pro1.pid FROM proplus pro1
                    WHERE SUBSTR(TO_CHAR(pro1.factpdsg,'FM0000000'), 1, LENGTH(RTRIM(RTRIM(LPAD(p_codsg, 7, '0'),'*')))) = RTRIM(RTRIM(LPAD(p_codsg, 7 ,'0'),'*'))
                    AND ( pro1.cdeb BETWEEN l_date_mini AND l_date_maxi ) )
     GROUP BY csr1.pid, csr1.cdeb, csr1.acta, csr1.acst, csr1.ecet
   -----------------------------------------------------------------------
   UNION ALL
   ------------------------------------------------------------------------
   ------------------------------------------------------------------------------------
   -- Cas 2 : Ressource avec mauvaise situation
   -- Correspond à tous les cas autres que Cas 1 :
   ------------------------------------------------------------------------------------
   SELECT
       csr2.cdeb       cdeb,
       csr2.pid       pid,
       csr2.acta       acta,
       csr2.acst      acst,
       csr2.ecet      ecet,
       SUM(csr2.cusag)  cusag
    FROM  cons_sstache_res_mois csr2
    WHERE
         NOT EXISTS     (
                    SELECT 1 from situ_ress sir2
                    WHERE  sir2.ident = csr2.ident
                    AND   TRUNC(sir2.datsitu,'MONTH')  <= TRUNC(csr2.cdeb,'MONTH')
                    AND   ( (csr2.cdeb <= sir2.datdep) OR (sir2.datdep IS NULL) )
                    AND   ( (sir2.prestation != 'GRA') OR (sir2.prestation!='IFO')
                                                  OR (sir2.prestation!='INT')
                                           OR (sir2.prestation!='MO ')
                                         OR (sir2.prestation!='STA') )
                  )
         AND ( csr2.cdeb BETWEEN l_date_mini AND l_date_maxi )
         AND csr2.ident != 0
    AND csr2.cusag != 0
     -------------------------------------------------------------------
     -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
     -------------------------------------------------------------------
     AND csr2.pid IN (     SELECT pro2.pid FROM proplus pro2
                    WHERE SUBSTR(TO_CHAR(pro2.factpdsg,'FM0000000'), 1, LENGTH(RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*')))) = RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*'))
                    AND ( pro2.cdeb BETWEEN l_date_mini AND l_date_maxi ))
    GROUP BY csr2.pid, csr2.cdeb, csr2.acta, csr2.acst, csr2.ecet
) csr
GROUP BY csr.pid, csr.cdeb, csr.acta, csr.acst, csr.ecet
;


    ELSIF ( (p_nom_etat = 'PRODEC3') AND (p_codsg IS NOT NULL) AND (p_codsg <> CST_CODE_DPG_TOUS) ) THEN
        -- PRODEC3 avec saisie DPG différent de '*******'

OPEN p_curv FOR
SELECT
      csr.cdeb   cdeb,
      csr.pid   pid,
      csr.acta   acta,
      csr.acst  acst,
      csr.ecet  ecet,
      SUM(csr.cusag)    cusag
FROM
(
  ------------------------------------------------------------------------------------
  -- Cas 1 : Ressource avec bonne situation
  -- On teste prestation != 'GRA' !!!
  ------------------------------------------------------------------------------------
  SELECT
      csr1.cdeb       cdeb,
      csr1.pid       pid,
      csr1.acta       acta,
      csr1.acst      acst,
      csr1.ecet      ecet,
      SUM(csr1.cusag)   cusag
    FROM  cons_sstache_res_mois csr1,
          situ_ress sir1
    WHERE
      sir1.ident = csr1.ident
      AND    TRUNC(sir1.datsitu,'MONTH')  <= TRUNC(csr1.cdeb,'MONTH')
      AND   ( (csr1.cdeb <= sir1.datdep) OR (sir1.datdep IS NULL) )
      AND sir1.prestation!='GRA'
      AND sir1.prestation!='IFO'
      AND sir1.prestation!='INT'
      AND sir1.prestation!='MO '
      AND sir1.prestation!='STA'
      AND   (csr1.cdeb BETWEEN l_date_mini AND l_date_maxi )
      AND   csr1.ident != 0
      AND   csr1.cusag != 0
      -------------------------------------------------------------------
      -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
      --------------------------------------------------------------------
      AND  csr1.pid IN ( SELECT pro1.pid FROM proplus pro1
                    WHERE SUBSTR(TO_CHAR(pro1.factpdsg,'FM0000000'), 1, LENGTH(RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*')))) = RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*'))
                    AND ( pro1.cdeb BETWEEN l_date_mini AND l_date_maxi ))
     GROUP BY csr1.pid, csr1.cdeb, csr1.acta, csr1.acst, csr1.ecet
   -----------------------------------------------------------------------
   UNION ALL
   ------------------------------------------------------------------------
   ------------------------------------------------------------------------------------
   -- Cas 2 : Ressource avec mauvaise situation
   -- Correspond à tous les cas autres que Cas 1 :
   ------------------------------------------------------------------------------------
   SELECT
       csr2.cdeb       cdeb,
       csr2.pid       pid,
       csr2.acta       acta,
       csr2.acst      acst,
       csr2.ecet      ecet,
       SUM(csr2.cusag)  cusag
    FROM  cons_sstache_res_mois csr2
    WHERE
         NOT EXISTS     (
                    SELECT 1 from situ_ress sir2
                    WHERE  sir2.ident = csr2.ident
                    AND   TRUNC(sir2.datsitu,'MONTH')  <= TRUNC(csr2.cdeb,'MONTH')
                    AND   ( (csr2.cdeb <= sir2.datdep) OR (sir2.datdep IS NULL) )
                    AND   ( (sir2.prestation != 'GRA') OR (sir2.prestation!='IFO')
                                                  OR (sir2.prestation!='INT')
                                           OR (sir2.prestation!='MO ')
                                         OR (sir2.prestation!='STA') )
                  )
         AND ( csr2.cdeb BETWEEN l_date_mini AND l_date_maxi )
         AND csr2.ident != 0
    AND csr2.cusag != 0
     -------------------------------------------------------------------
     -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
     -------------------------------------------------------------------
     AND csr2.pid IN (     SELECT pro2.pid FROM proplus pro2
                    WHERE SUBSTR(TO_CHAR(pro2.factpdsg,'FM0000000'), 1, LENGTH(RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*')))) = RTRIM(RTRIM(LPAD(p_codsg, 7, '0'),'*'))
                    AND ( pro2.cdeb BETWEEN l_date_mini AND l_date_maxi ))
    GROUP BY csr2.pid, csr2.cdeb, csr2.acta, csr2.acst, csr2.ecet
) csr
GROUP BY csr.pid, csr.cdeb, csr.acta, csr.acst, csr.ecet
;

    ELSIF ( (p_nom_etat = 'PRODEC4') AND (p_appli is not null or p_appli != ' ')) THEN
        -- PRODEC4 avec Code Application saisi

OPEN p_curv FOR
SELECT
      csr.cdeb   cdeb,
      csr.pid   pid,
      csr.acta   acta,
      csr.acst  acst,
      csr.ecet  ecet,
      SUM(csr.cusag)    cusag
FROM
(
  ------------------------------------------------------------------------------------
  -- Cas 1 : Ressource avec bonne situation
  -- On teste prestation != 'GRA' !!!
  ------------------------------------------------------------------------------------
  SELECT
      csr1.cdeb       cdeb,
      csr1.pid       pid,
      csr1.acta       acta,
      csr1.acst      acst,
      csr1.ecet      ecet,
      SUM(csr1.cusag)   cusag
    FROM  cons_sstache_res_mois csr1,
          situ_ress sir1
    WHERE
      sir1.ident = csr1.ident
      AND   TRUNC(sir1.datsitu,'MONTH')  <= TRUNC(csr1.cdeb,'MONTH')
      AND   ( (csr1.cdeb <= sir1.datdep) OR (sir1.datdep IS NULL) )
      AND   ( (sir1.prestation != 'GRA') OR (sir1.prestation IS NULL) )
      AND   (csr1.cdeb BETWEEN l_date_mini AND l_date_maxi )
      AND   csr1.ident != 0
      AND   csr1.cusag != 0
      -------------------------------------------------------------------
      -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
      --------------------------------------------------------------------
      AND  csr1.pid IN ( SELECT pro1.pid FROM proplus pro1
                    WHERE pro1.factpid IN (SELECT lbi.pid  FROM ligne_bip lbi WHERE lbi.airt = p_appli)
                    AND ( pro1.cdeb BETWEEN l_date_mini AND l_date_maxi )
                      )
     GROUP BY csr1.pid, csr1.cdeb, csr1.acta, csr1.acst, csr1.ecet
   -----------------------------------------------------------------------
   UNION ALL
   ------------------------------------------------------------------------
   ------------------------------------------------------------------------------------
   -- Cas 2 : Ressource avec mauvaise situation
   -- Correspond à tous les cas autres que Cas 1 :
   ------------------------------------------------------------------------------------
   SELECT
       csr2.cdeb       cdeb,
       csr2.pid       pid,
       csr2.acta       acta,
       csr2.acst      acst,
       csr2.ecet      ecet,
       SUM(csr2.cusag)  cusag
    FROM  cons_sstache_res_mois csr2
    WHERE
         NOT EXISTS     (
                    SELECT 1 from situ_ress sir2
                    WHERE  sir2.ident = csr2.ident
                    AND   TRUNC(sir2.datsitu,'MONTH')  <= TRUNC(csr2.cdeb,'MONTH')
                    AND   ( (csr2.cdeb <= sir2.datdep) OR (sir2.datdep IS NULL) )
                  )
         AND ( csr2.cdeb BETWEEN l_date_mini AND l_date_maxi )
         AND csr2.ident != 0
    AND csr2.cusag != 0
     -------------------------------------------------------------------
     -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
     -------------------------------------------------------------------
     AND csr2.pid IN (     SELECT pro2.pid FROM proplus pro2
                    WHERE pro2.factpid IN (SELECT lbi.pid  FROM ligne_bip lbi WHERE lbi.airt = p_appli)
                    AND ( pro2.cdeb BETWEEN l_date_mini AND l_date_maxi )
                     )
    GROUP BY csr2.pid, csr2.cdeb, csr2.acta, csr2.acst, csr2.ecet
) csr
GROUP BY csr.pid, csr.cdeb, csr.acta, csr.acst, csr.ecet
;

    ELSIF ( (p_nom_etat = 'PRODEC4') AND  (p_projet is not null or p_projet != ' ') ) THEN
        -- PRODEC4 avec Code Projet saisi

OPEN p_curv FOR
SELECT
      csr.cdeb      cdeb,
      csr.pid       pid,
      csr.acta      acta,
      csr.acst      acst,
      csr.ecet      ecet,
      SUM(csr.cusag)    cusag
FROM
(
  ------------------------------------------------------------------------------------
  -- Cas 1 : Ressource avec bonne situation
  -- On teste prestation != 'GRA' !!!
  ------------------------------------------------------------------------------------
  SELECT
      csr1.cdeb       cdeb,
      csr1.pid       pid,
      csr1.acta       acta,
      csr1.acst      acst,
      csr1.ecet      ecet,
      SUM(csr1.cusag)   cusag
    FROM  cons_sstache_res_mois csr1,
          situ_ress         sir1
    WHERE
    sir1.ident = csr1.ident
      AND   TRUNC(sir1.datsitu,'MONTH')  <= TRUNC(csr1.cdeb,'MONTH')
      AND   ( (csr1.cdeb <= sir1.datdep) OR (sir1.datdep IS NULL) )
      AND   ( (sir1.prestation != 'GRA') OR (sir1.prestation IS NULL) )
         AND   (csr1.cdeb BETWEEN l_date_mini AND l_date_maxi )
        AND   csr1.ident != 0
      AND   csr1.cusag != 0
      -------------------------------------------------------------------
      -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
      --------------------------------------------------------------------
      AND  csr1.pid IN ( SELECT pro1.pid FROM proplus pro1
                    WHERE pro1.factpid IN (SELECT lbi.pid pid FROM ligne_bip lbi WHERE lbi.icpi = p_projet)
                    AND ( pro1.cdeb BETWEEN l_date_mini AND l_date_maxi )
                      )
     GROUP BY csr1.pid, csr1.cdeb, csr1.acta, csr1.acst, csr1.ecet
   -----------------------------------------------------------------------
   UNION ALL
   ------------------------------------------------------------------------
   ------------------------------------------------------------------------------------
   -- Cas 2 : Ressource avec mauvaise situation
   -- Correspond à tous les cas autres que Cas 1 :
   ------------------------------------------------------------------------------------
   SELECT
       csr2.cdeb       cdeb,
       csr2.pid       pid,
       csr2.acta       acta,
       csr2.acst      acst,
       csr2.ecet      ecet,
       SUM(csr2.cusag)  cusag
    FROM  cons_sstache_res_mois csr2
    WHERE
         NOT EXISTS     (
                    SELECT 1 from situ_ress sir2
                    WHERE  sir2.ident = csr2.ident
                    AND   TRUNC(sir2.datsitu,'MONTH')  <= TRUNC(csr2.cdeb,'MONTH')
                    AND   ( (csr2.cdeb <= sir2.datdep) OR (sir2.datdep IS NULL) )
                  )
         AND ( csr2.cdeb BETWEEN l_date_mini AND l_date_maxi )
         AND csr2.ident != 0
    AND csr2.cusag != 0
     -------------------------------------------------------------------
     -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
     -------------------------------------------------------------------
     AND csr2.pid IN (     SELECT pro2.pid FROM proplus pro2
                    WHERE pro2.factpid IN (SELECT lbi.pid pid FROM ligne_bip lbi WHERE lbi.icpi = p_projet)
                    AND ( pro2.cdeb BETWEEN l_date_mini AND l_date_maxi )
                     )
    GROUP BY csr2.pid, csr2.cdeb, csr2.acta, csr2.acst, csr2.ecet
) csr
GROUP BY csr.pid, csr.cdeb, csr.acta, csr.acst, csr.ecet
;

    ELSIF ( (p_nom_etat = 'PRODEC2') ) THEN
        -- PRODEC2 (FILTRE SUR clicode pour TEST SI GAIN EXECUTION!!!)

OPEN p_curv FOR
SELECT
      csr.cdeb      cdeb,
      csr.pid       pid,
      csr.acta      acta,
      csr.acst      acst,
      csr.ecet      ecet,
      SUM(csr.cusag)    cusag
FROM
(
  ------------------------------------------------------------------------------------
  -- Cas 1 : Ressource avec bonne situation
  -- On teste prestation != 'GRA' !!!
  ------------------------------------------------------------------------------------
  SELECT
      csr1.cdeb       cdeb,
      csr1.pid       pid,
      csr1.acta       acta,
      csr1.acst      acst,
      csr1.ecet      ecet,
      SUM(csr1.cusag)   cusag
    FROM  cons_sstache_res_mois csr1,
          situ_ress         sir1
    WHERE
    sir1.ident = csr1.ident
      AND   TRUNC(sir1.datsitu,'MONTH')  <= TRUNC(csr1.cdeb,'MONTH')
      AND   ( (csr1.cdeb <= sir1.datdep) OR (sir1.datdep IS NULL) )
      AND   ( (sir1.prestation != 'GRA') OR (sir1.prestation IS NULL) )
      AND   (csr1.cdeb BETWEEN l_date_mini AND l_date_maxi )
      AND   csr1.ident != 0
      AND   csr1.cusag != 0
      -------------------------------------------------------------------
      -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
      --------------------------------------------------------------------
      AND  csr1.pid IN ( SELECT pro1.pid FROM proplus pro1
                 WHERE pro1.factpid IN (    SELECT lbi.pid pid
                                    FROM ligne_bip lbi, client_mo  clm
                                        WHERE lbi.clicode = clm.clicode
                                            --AND clm.clicode  = p_clicode
                                            --F93
                                        AND clm.clicode in (
                                                select clicoderatt
                                                from vue_clicode_hierarchie vu
                                                where vu.clicode = p_clicode)
                                  )
                     AND ( pro1.cdeb BETWEEN l_date_mini AND l_date_maxi )
                      )
     GROUP BY csr1.pid, csr1.cdeb, csr1.acta, csr1.acst, csr1.ecet
   -----------------------------------------------------------------------
   UNION ALL
   ------------------------------------------------------------------------
   ------------------------------------------------------------------------------------
   -- Cas 2 : Ressource avec mauvaise situation
   -- Correspond à tous les cas autres que Cas 1 :
   ------------------------------------------------------------------------------------
   SELECT
       csr2.cdeb       cdeb,
       csr2.pid       pid,
       csr2.acta       acta,
       csr2.acst      acst,
       csr2.ecet      ecet,
       SUM(csr2.cusag)  cusag
    FROM  cons_sstache_res_mois csr2
    WHERE
         NOT EXISTS     (
                    SELECT 1 from situ_ress sir2
                    WHERE  sir2.ident = csr2.ident
                    AND   TRUNC(sir2.datsitu,'MONTH')  <= TRUNC(csr2.cdeb,'MONTH')
                    AND   ( (csr2.cdeb <= sir2.datdep) OR (sir2.datdep IS NULL) )
                  )
         AND ( csr2.cdeb BETWEEN l_date_mini AND l_date_maxi )
         AND csr2.ident != 0
    AND csr2.cusag != 0
     -------------------------------------------------------------------
     -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
     -------------------------------------------------------------------
     AND csr2.pid IN (     SELECT pro2.pid FROM proplus pro2
                WHERE pro2.factpid IN (    SELECT lbi.pid pid
                                FROM ligne_bip lbi, client_mo  clm
                                WHERE lbi.clicode = clm.clicode
                                --AND clm.clicode = p_clicode
                                --F93
                                AND clm.clicode in (
                                                select clicoderatt
                                                from vue_clicode_hierarchie vu
                                                where vu.clicode = p_clicode)
                                 )
                    AND ( pro2.cdeb BETWEEN l_date_mini AND l_date_maxi )
                     )
    GROUP BY csr2.pid, csr2.cdeb, csr2.acta, csr2.acst, csr2.ecet
) csr
GROUP BY csr.pid, csr.cdeb, csr.acta, csr.acst, csr.ecet
;

    ELSE

OPEN p_curv FOR
SELECT
      csr.cdeb   cdeb,
      csr.pid   pid,
      csr.acta   acta,
      csr.acst  acst,
      csr.ecet  ecet,
      SUM(csr.cusag)    cusag
FROM
(
  ------------------------------------------------------------------------------------
  -- Cas 1 : Ressource avec bonne situation
  -- On teste prestation != 'GRA' !!!
  ------------------------------------------------------------------------------------
  SELECT
      csr1.cdeb       cdeb,
      csr1.pid           pid,
      csr1.acta       acta,
      csr1.acst          acst,
      csr1.ecet          ecet,
      SUM(csr1.cusag)   cusag
    FROM  cons_sstache_res_mois csr1,
          situ_ress sir1
    WHERE
    sir1.ident = csr1.ident
      AND   TRUNC(sir1.datsitu,'MONTH')  <= TRUNC(csr1.cdeb,'MONTH')
      AND   ( (csr1.cdeb <= sir1.datdep) OR (sir1.datdep IS NULL) )
      AND   ( (sir1.prestation != 'GRA') OR (sir1.prestation IS NULL) )
         AND   (csr1.cdeb BETWEEN l_date_mini AND l_date_maxi )
        AND   csr1.ident != 0
      AND   csr1.cusag != 0
     GROUP BY csr1.pid, csr1.cdeb, csr1.acta, csr1.acst, csr1.ecet
   -----------------------------------------------------------------------
   UNION ALL
   ------------------------------------------------------------------------
   ------------------------------------------------------------------------------------
   -- Cas 2 : Ressource avec mauvaise situation
   -- Correspond à tous les cas autres que Cas 1 :
   ------------------------------------------------------------------------------------
   SELECT
       csr2.cdeb       cdeb,
       csr2.pid       pid,
       csr2.acta       acta,
       csr2.acst      acst,
       csr2.ecet      ecet,
       SUM(csr2.cusag)  cusag
    FROM  cons_sstache_res_mois csr2
    WHERE
         NOT EXISTS     (
                    SELECT 1 from situ_ress sir2
                    WHERE  sir2.ident = csr2.ident
                    AND   TRUNC(sir2.datsitu,'MONTH')  <= TRUNC(csr2.cdeb,'MONTH')
                    AND   ( (csr2.cdeb <= sir2.datdep) OR (sir2.datdep IS NULL) )
                  )
         AND ( csr2.cdeb BETWEEN l_date_mini AND l_date_maxi )
         AND csr2.ident != 0
    AND csr2.cusag != 0
    GROUP BY csr2.pid, csr2.cdeb, csr2.acta, csr2.acst, csr2.ecet
) csr
GROUP BY csr.pid, csr.cdeb, csr.acta, csr.acst, csr.ecet
;

    END IF;

 END ouvrir_conso_cv;


   -- ------------------------------------------------------------------------
   -- Nom        :  ouvrir_budget_cv (Procédure)
   -- Auteur     :  Equipe SOPRA
   -- Decription :  Ouverture variable curseur de type BudgetCurTyp
   -- Paramètres :  p_curv     (IN/OUT)      Curseur à ouvrir
   --               p_nom_etat (IN)         Nom de l'état traité (PRODEC2, 3, 4, ou L)
   --             p_clicode  (IN)     Code direction
   --            p_codsg    (IN)       Code DPG (Pouvant contenir des * à la fin!!!)
   --               p_pid      (IN)       Code ligne BIP
   --               p_id_proj_ou_appli     (IN)       Code référentiel (Identifiant Projet ou Application)
   --            p_date_traite (IN)    Date à prendre en compte
   --           (L'année de cette date correspond à l'année N !!! dans l'état!!!)
   --
   -- Retour     :
   --
   -- ------------------------------------------------------------------------
   PROCEDURE ouvrir_budget_cv(
                    p_curv         IN OUT BudgetCurTyp,
                    p_nom_etat     IN VARCHAR2,
                    p_clicode       IN client_mo.clicode%TYPE,
                    p_codsg        IN VARCHAR2,
                    p_pid          IN ligne_bip.pid%TYPE,
                    p_appli     IN VARCHAR2,
                    p_projet     IN VARCHAR2,
                    p_date_traite     IN DATE
                    ) IS

    l_annee_traite VARCHAR2(4);
    l_mois_maxi_traite VARCHAR2(2);
    l_derjour_mois_maxi_traite VARCHAR2(2);

    l_date_mini DATE;
    l_date_maxi DATE;
    l_dir varchar2(10);
  BEGIN

    l_annee_traite := TO_CHAR(p_date_traite, 'YYYY');
    l_mois_maxi_traite  := TO_CHAR(p_date_traite, 'MM');
        l_derjour_mois_maxi_traite := TO_CHAR( LAST_DAY(TO_DATE('01' || '/' || l_mois_maxi_traite  || '/' || l_annee_traite, 'DD/MM/YYYY')), 'DD' );

    l_date_mini := TO_DATE('01/01/' || l_annee_traite, 'DD/MM/YYYY');
    l_date_maxi := TO_DATE(l_derjour_mois_maxi_traite || '/' || l_mois_maxi_traite || '/' || l_annee_traite, 'DD/MM/YYYY');

--     -- 02/03/2001 : filtre sur p_clidom (direction ou département)
--      -- tester si p_clidom est une direction ou un département
--      BEGIN
--           select 'dir' into l_dir
--        from client_mo
--        where clidom=p_clidom
--        and clicode=p_clidom;
--          EXCEPTION
--        WHEN NO_DATA_FOUND THEN   --départment
--        l_dir :='dpt';
--          END;

  IF ( (p_nom_etat = 'PRODEC4') AND (p_appli is not null or p_appli != ' ') ) THEN
    -- PRODEC4 avec Code Application saisi

    OPEN p_curv FOR
        SELECT DISTINCT lbi.pid pid
        FROM     ligne_bip lbi,
                          client_mo  clm
          WHERE lbi.airt = p_appli
    ;

  ELSIF ( (p_nom_etat = 'PRODEC4') AND (p_projet is not null or p_projet != ' ') ) THEN
    -- PRODEC4 avec Code Projet saisi

    OPEN p_curv FOR
        SELECT DISTINCT lbi.pid pid
        FROM     ligne_bip lbi,
                          client_mo  clm
          WHERE lbi.icpi = p_projet
    ;

  ELSIF ( (p_nom_etat = 'PRODEC3') AND ( (p_codsg IS NULL) OR (p_codsg = CST_CODE_DPG_TOUS) ) ) THEN
    -- PRODEC3 avec : absence saisie DPG ou saisie DPG '*******'
    OPEN p_curv FOR
        SELECT DISTINCT pro.pid pid
        FROM     proplus pro
        WHERE pro.cdeb BETWEEN l_date_mini AND l_date_maxi

        UNION

        SELECT DISTINCT pro.factpid pid
        FROM     proplus pro
        WHERE pro.cdeb BETWEEN l_date_mini AND l_date_maxi
    ;

  ELSIF ( (p_nom_etat = 'PRODEC3') AND (p_codsg IS NOT NULL) AND (p_codsg <> CST_CODE_DPG_TOUS) ) THEN
    -- PRODEC3 avec saisie DPG différent de '*******'

    OPEN p_curv FOR
        SELECT DISTINCT pro.pid pid
        FROM     proplus pro
        WHERE pro.cdeb BETWEEN l_date_mini AND l_date_maxi
        AND SUBSTR(TO_CHAR(pro.pdsg,'FM0000000'), 1, LENGTH(RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*')))) = RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*'))

        UNION

        SELECT DISTINCT pro.factpid pid
        FROM     proplus pro
        WHERE pro.cdeb BETWEEN l_date_mini AND l_date_maxi
        AND SUBSTR(TO_CHAR(pro.factpdsg,'FM0000000'), 1, LENGTH(RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*')))) = RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*'))
    ;

  ELSIF (
        ( (p_nom_etat = 'PRODECL') AND (p_codsg IS NULL) AND (p_pid IS NULL) )
        -- PRODECL avec absence saisie Code DPG et Code PID !!!
                OR
        ( (p_nom_etat = 'PRODECL') AND (p_codsg = CST_CODE_DPG_TOUS) )
        -- PRODECL Avec Code DPG '*******' Saisi !!!
        ) THEN

    OPEN p_curv FOR
        SELECT DISTINCT pro.pid pid
        FROM     proplus pro
        WHERE pro.cdeb BETWEEN l_date_mini AND l_date_maxi

        UNION

        SELECT DISTINCT pro.factpid pid
        FROM     proplus pro
        WHERE pro.cdeb BETWEEN l_date_mini AND l_date_maxi
    ;

  ELSIF ( (p_nom_etat = 'PRODECL') AND (p_codsg IS NOT NULL) AND (p_codsg <> CST_CODE_DPG_TOUS) ) THEN
    -- PRODECL Avec Code DPG différent de '*******' saisi (Code ligne BIP n'est pas saisi) !!!

    OPEN p_curv FOR
        SELECT DISTINCT pro.pid pid
        FROM     proplus pro
        WHERE pro.cdeb BETWEEN l_date_mini AND l_date_maxi
        AND SUBSTR(TO_CHAR(pro.pdsg,'FM0000000'), 1, LENGTH(RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*')))) = RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*'))

        UNION

        SELECT DISTINCT pro.factpid pid
        FROM     proplus pro
        WHERE pro.cdeb BETWEEN l_date_mini AND l_date_maxi
        AND SUBSTR(TO_CHAR(pro.factpdsg,'FM0000000'), 1, LENGTH(RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*')))) = RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*'))
    ;

  ELSIF ( (p_nom_etat = 'PRODECL') AND (p_pid IS NOT NULL) ) THEN
    -- PRODECL Avec Code ligne BIP Obligatoirement Saisi (Code DPG  est non saisi)!!!

    OPEN p_curv FOR
        SELECT  lbi.pid pid
        FROM     ligne_bip lbi
          WHERE lbi.pid = p_pid    -- Retournera 1 ligne au maxi (PID est la clé primaire de LIGNE_BIP!)
    ;

  ELSE
    -- Dans tous les autres cas (Normalement, devrait correspondre au seul cas PRODEC2 !!!)
    -- FAUT PAS OUBLIER QU'IL Y A DES CONTROLES DE SAISIE FAITS AVANT!!!

    OPEN p_curv FOR
        SELECT DISTINCT pro.pid pid
        FROM     proplus pro,
                          client_mo  clm
        WHERE pro.pcmouvra = clm.clicode
        --AND clm.clicode = p_clicode
        --F93
        AND clm.clicode in (
                select clicoderatt
                from vue_clicode_hierarchie vu
                where vu.clicode = p_clicode)
        AND pro.cdeb BETWEEN l_date_mini AND l_date_maxi

        UNION

        SELECT DISTINCT pro.factpid pid
        FROM     proplus pro,
                 client_mo  clm
        WHERE pro.factpcm = clm.clicode
        --AND clm.clicode = p_clicode
        --F93
        AND clm.clicode in (
                select clicoderatt
                from vue_clicode_hierarchie vu
                where vu.clicode = p_clicode)
        AND pro.cdeb BETWEEN l_date_mini AND l_date_maxi
    ;

  END IF;

  END ouvrir_budget_cv;

-- ------------------------------------------------------------------------
   -- Nom        :  ouvrir_budget_tout (Procédure)
   -- Auteur     :  MMC
   -- Decription :  Ouverture variable curseur de type BudgetCurTyp
   -- Paramètres :  p_curv     (IN/OUT)      Curseur à ouvrir
   --               p_userid    (IN)    identifiant de l'utilisateur
   --
-- ------------------------------------------------------------------------
   PROCEDURE ouvrir_budget_tout(    p_curv         IN OUT BudgetCurTyp,
                    p_userid     IN VARCHAR2
                    ) IS

    l_lst_chefs_projets VARCHAR2(4000);-- PPM 63485 : augmenter la taille à 4000

  BEGIN

    /*l_annee_traite := TO_CHAR(p_date_traite, 'YYYY');
    l_mois_maxi_traite  := TO_CHAR(p_date_traite, 'MM');
        l_derjour_mois_maxi_traite := TO_CHAR( LAST_DAY(TO_DATE('01' || '/' || l_mois_maxi_traite  || '/' || l_annee_traite, 'DD/MM/YYYY')), 'DD' );
    l_date_mini := TO_DATE('01/01/' || l_annee_traite, 'DD/MM/YYYY');
    l_date_maxi := TO_DATE(l_derjour_mois_maxi_traite || '/' || l_mois_maxi_traite || '/' || l_annee_traite, 'DD/MM/YYYY');*/

    l_lst_chefs_projets := pack_global.lire_globaldata(p_userid).chefprojet;

     /* -- tester si p_clidom est une direction ou un département
      BEGIN
           select 'dir' into l_dir
        from client_mo
        where clidom=p_clidom
        and clicode=p_clidom;
          EXCEPTION
        WHEN NO_DATA_FOUND THEN   --départment
        l_dir :='dpt';
          END;    */

      OPEN p_curv FOR
        SELECT DISTINCT l.pid pid
        from ligne_bip l, datdebex d
            where INSTR(l_lst_chefs_projets ,TO_CHAR(l.pcpi, 'FM00000')) > 0
            minus
            select DISTINCT l.pid pid
            from ligne_bip l, datdebex d
            where INSTR(l_lst_chefs_projets ,TO_CHAR(l.pcpi, 'FM00000')) > 0
            and ((topfer='O' and TRUNC(adatestatut,'YEAR')<TRUNC(d.datdebex,'YEAR')  )
            or
            (astatut  in ('A','D','C')
             and TRUNC(adatestatut,'YEAR')<TRUNC(d.datdebex,'YEAR') )
            )
    ;

  END ouvrir_budget_tout;


   -- ------------------------------------------------------------------------
   -- Nom        :  ouvrir_conso_tout (Procédure)
   -- Auteur     :  MMC
   -- Decription :  Ouverture variable curseur de type ConsoCurTyp
   -- Paramètres :  p_curv    (IN/OUT)     Curseur à ouvrir
   --               p_userid (IN)         p_global
   -- ------------------------------------------------------------------------
 PROCEDURE ouvrir_conso_tout(        p_curv         IN OUT ConsoCurTyp,
                    p_userid     IN VARCHAR2,
                    p_date_traite     IN DATE
                    ) IS

    l_annee_traite VARCHAR2(4);
    l_mois_maxi_traite VARCHAR2(2);
    l_derjour_mois_maxi_traite VARCHAR2(2);

    l_date_mini DATE;
    l_date_maxi DATE;

    l_lst_chefs_projets VARCHAR2(4000);-- PPM 63485 : augmenter la taille à 4000


 BEGIN

 /********************************************************************************
  * Seul le paramètre "p_date_traite" est pris en compte :
  * On conserve les autres paramètres pour le  cas où!!!
  ********************************************************************************/

    l_annee_traite := TO_CHAR(p_date_traite, 'YYYY');
    l_mois_maxi_traite  := TO_CHAR(p_date_traite, 'MM');
        l_derjour_mois_maxi_traite := TO_CHAR( LAST_DAY(TO_DATE('01' || '/' || l_mois_maxi_traite  || '/' || l_annee_traite, 'DD/MM/YYYY')), 'DD' );

    l_date_mini := TO_DATE('01/01/' || l_annee_traite, 'DD/MM/YYYY');
    l_date_maxi := TO_DATE(l_derjour_mois_maxi_traite || '/' || l_mois_maxi_traite || '/' || l_annee_traite, 'DD/MM/YYYY');
    l_lst_chefs_projets := pack_global.lire_globaldata(p_userid).chefprojet;

OPEN p_curv FOR
SELECT
      csr.cdeb   cdeb,
      csr.pid   pid,
      csr.acta   acta,
      csr.acst  acst,
      csr.ecet  ecet,
      SUM(csr.cusag)    cusag
FROM
(
  ------------------------------------------------------------------------------------
  -- Cas 1 : Ressource avec bonne situation
  -- On teste prestation != 'GRA' !!!
  ------------------------------------------------------------------------------------
    SELECT
      csr1.cdeb       cdeb,
      csr1.pid           pid,
      csr1.acta       acta,
      csr1.acst          acst,
      csr1.ecet          ecet,
      SUM(csr1.cusag)   cusag
    FROM  cons_sstache_res_mois csr1,
          situ_ress sir1
    WHERE
    sir1.ident = csr1.ident
      AND    TRUNC(sir1.datsitu,'MONTH')  <= TRUNC(csr1.cdeb,'MONTH')
      AND   ( (csr1.cdeb <= sir1.datdep) OR (sir1.datdep IS NULL) )
      AND   ( (sir1.prestation != 'GRA') OR (sir1.prestation IS NULL) )
      AND   (csr1.cdeb BETWEEN l_date_mini AND l_date_maxi )
      AND   csr1.ident != 0
      AND   csr1.cusag != 0
      -------------------------------------------------------------------
      -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
      --------------------------------------------------------------------
      AND  csr1.pid IN (SELECT DISTINCT l.pid
        from ligne_bip l, datdebex d
            where INSTR(l_lst_chefs_projets ,TO_CHAR(l.pcpi, 'FM00000')) > 0
            and ( (topfer='N' and adatestatut is null)
            or
            (TRUNC(adatestatut,'YEAR')=TRUNC(d.datdebex,'YEAR'))
            ))
     GROUP BY csr1.pid, csr1.cdeb, csr1.acta, csr1.acst, csr1.ecet
   -----------------------------------------------------------------------
   UNION ALL
   ------------------------------------------------------------------------
   ------------------------------------------------------------------------------------
   -- Cas 2 : Ressource avec mauvaise situation
   -- Correspond à tous les cas autres que Cas 1 :
   ------------------------------------------------------------------------------------
   SELECT
       csr2.cdeb       cdeb,
       csr2.pid       pid,
       csr2.acta       acta,
       csr2.acst      acst,
       csr2.ecet      ecet,
       SUM(csr2.cusag)  cusag
    FROM  cons_sstache_res_mois csr2
    WHERE
         NOT EXISTS     (
                    SELECT 1 from situ_ress sir2
                    WHERE  sir2.ident = csr2.ident
                    AND   TRUNC(sir2.datsitu,'MONTH')  <= TRUNC(csr2.cdeb,'MONTH')
                    AND   ( (csr2.cdeb <= sir2.datdep) OR (sir2.datdep IS NULL) )
                  )
         AND ( csr2.cdeb BETWEEN l_date_mini AND l_date_maxi )
         AND csr2.ident != 0
    AND csr2.cusag != 0
     -------------------------------------------------------------------
     -- Ne prendre que les lignes concernant le Code ligne BIP Saisi
     -------------------------------------------------------------------
        AND csr2.pid IN (SELECT DISTINCT l.pid
        from ligne_bip l, datdebex d
            where INSTR(l_lst_chefs_projets ,TO_CHAR(l.pcpi, 'FM00000')) > 0
            and ( (topfer='N' and adatestatut is null)
            or
            (TRUNC(adatestatut,'YEAR')=TRUNC(d.datdebex,'YEAR'))
            ))
    GROUP BY csr2.pid, csr2.cdeb, csr2.acta, csr2.acst, csr2.ecet
) csr
GROUP BY csr.pid, csr.cdeb, csr.acta, csr.acst, csr.ecet
;

END ouvrir_conso_tout;

END  pack_prodec2;
/