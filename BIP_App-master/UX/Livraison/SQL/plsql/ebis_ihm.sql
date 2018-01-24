-- pack_ebis_ihm PL/SQL
--
-- BPI
-- Créé le 22/03/2007
-- Modfif  JAL  06-06-2007 : il existe des doublons dans la table agance même SOCCODE et SIREN : modification insert et delete fournisseur
--                                            afin de ramener une seule ligne
-- Modfif  EVI  13-09-2007 : TD580 ajout de 2 champs NUMENR et TOP_ETAT
-- Modfif  EVI  13-09-2007 : ajout du CODSG dans lister_logs_contrats_ressource
-- Modif    EVI  18-12-2007 : ajout du filtre sur le Centre de frais dans l'affichage de EBIS_FACT_REJET
-- Modif    JAL 08-02-2008 : Correction recherche de SIREN rajout de TRIM également sur autres fonctions
-- Modif    JAL 13-03-2008 : Fiche 613 : rajout fonctions de lecture des logs TT ebis
-- Modif    EVI 20-03-2008 : Fiche 634 : ajout des champs Cdatdeb et Cdatfin pour l'export des contrat ebis
-- Modif   JAL 25-03-2008 : Fiche 613 : rajout cuseur lecture table EXP_TT_REJET
-- Modif   EVI 26-03-2008 : Fiche 610
--Modif   ABA  15-05-2008 : TD 607 ajout procdure qui recupère toutes les lignes de la vue ebis_logs_ligne_cont_supp
--Modif   ABA  21-08-2008 : duplication fonction select_codsg en select_codsg_ter pour le log des contrats expense
--Modif   ABA  25-08-2008 : TD 615 
--Modif   ABA  01-09-2008 : TD 686 : ajout libelle motif rejet dans l'ihm
--Modif   ABA  04-09-2008 : TD 687 : ajout user dans les logs contrats
--Modif   EVI  16-09-2008 :  Correction manque filtre sur topEtat dans SELECT_REJET_FACTURE
--Modif   EVI  15-05-2009 :  Correction procedure lister_logs_tt_expensebis
-- Modif CMA 17/02/2011 : Fiche 1071 Le centre de frais zéro est géré
-- Modif ABA 17/10/2011 : QC 1282 
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
CREATE OR REPLACE PACKAGE     Pack_Ebis_Ihm AS


TYPE ebis_logs_contrats_ViewType IS RECORD ( NUMCONT              EXP_CONTRAT_REJET.NUMCONT%TYPE,
                                             SOCCONT              EXP_CONTRAT_REJET.SOCCONT%TYPE,
                                             CAV                EXP_CONTRAT_REJET.CAV%TYPE,
                                             LCNUM               EXP_CONTRAT_REJET.LCNUM%TYPE,
                                             IDENT                EXP_CONTRAT_REJET.IDENT%TYPE,
                                             CHAMP_CONTRAT       EXP_CONTRAT_REJET.CHAMP_CONTRAT%TYPE,
                                             CHAMP_RESSOURCE      EXP_CONTRAT_REJET.CHAMP_RESSOURCE%TYPE,
                                             COMMENTAIRE        EXP_CONTRAT_REJET.COMMENTAIRE%TYPE,
                                             CODSG                SITU_RESS.CODSG%TYPE,
                                             LIBDSG               STRUCT_INFO.LIBDSG%TYPE,
                                             CDATDEB                CONTRAT.CDATDEB%TYPE,
                                             CDATFIN                CONTRAT.CDATFIN%TYPE,
                                             REFERENTIEL            DIRECTIONS.CODREF%TYPE,
                                             PERIMETRE            DIRECTIONS.CODPERIM%TYPE
                             );

TYPE ebis_logs_cont_listeCurType IS REF CURSOR RETURN ebis_logs_contrats_ViewType;


 TYPE ebis_logs_ttebis_ViewType IS RECORD (
  DPG    EXP_TT_REJET.DPG%TYPE,
  SOCCODE  EXP_TT_REJET.SOCCODE%TYPE,
  IDENT    EXP_TT_REJET.IDENT%TYPE,
  RNOM      EXP_TT_REJET.RNOM%TYPE,
  LMOISPREST EXP_TT_REJET.LMOISPREST%TYPE,
  CUSAG     EXP_TT_REJET.CUSAG%TYPE,
  DATDEP   EXP_TT_REJET.DATDEP%TYPE,
  NUMCONT   EXP_TT_REJET.NUMCONT%TYPE,
  CAV       EXP_TT_REJET.CAV%TYPE,
  SOCCONT   EXP_TT_REJET.SOCCONT%TYPE,
  CDATFIN   EXP_TT_REJET.CDATFIN%TYPE,
  MESSAGE   EXP_TT_REJET.MESSAGE%TYPE,
  DATE_TRAIT EXP_TT_REJET.DATE_TRAIT%TYPE,
  CODE_RETOUR EXP_TT_REJET.CODE_RETOUR%TYPE,
  CODSG_CONT  EXP_TT_REJET.CODSG_CONT%TYPE,
  SYSCPT_RES  EXP_TT_REJET.SYSCPT_RES%TYPE,
  SYSCPT_CONT EXP_TT_REJET.SYSCPT_CONT%TYPE,
  REFERENTIEL            DIRECTIONS.CODREF%TYPE,
  PERIMETRE            DIRECTIONS.CODPERIM%TYPE
   );

 TYPE ebis_logs_ttebis_listeCurType IS REF CURSOR RETURN ebis_logs_ttebis_ViewType;

TYPE rejet_facture_ViewType IS RECORD ( NUMENR     EBIS_FACT_REJET.NUMENR%TYPE,
                                                  NUMCONT     EBIS_FACT_REJET.NUMCONT%TYPE,
                                             CAV             EBIS_FACT_REJET.CAV%TYPE,
                                             NUMFACT         EBIS_FACT_REJET.NUMFACT%TYPE,
                                             IDENT             EBIS_FACT_REJET.IDENT%TYPE,
                                             NUM_EXPENSE     EBIS_FACT_REJET.NUM_EXPENSE%TYPE,
                                             MOTIF_REJET     EBIS_MOTIFS_REJETS_FACTURE.LIB_ERR%TYPE,
                                             TOP_ETAT     EBIS_FACT_REJET.TOP_ETAT%TYPE,
                                             FC            CENTRE_FRAIS.CODCFRAIS%TYPE
                             );

TYPE rejet_facture_listeCurType IS REF CURSOR RETURN rejet_facture_ViewType;



PROCEDURE lister_logs_contrats_ressource( s_curseur     IN OUT ebis_logs_cont_listeCurType) ;

TYPE ebis_factures_ViewType IS RECORD ( NUMCONT         EBIS_FACT_REJET.NUMCONT%TYPE,
                                             NUMFACT         EBIS_FACT_REJET.NUMFACT%TYPE,
                                        TYPFACT         EBIS_FACT_REJET.TYPFACT%TYPE,
                                        DATFACT         EBIS_FACT_REJET.DATFACT%TYPE,
                                        CAV             EBIS_FACT_REJET.CAV%TYPE,
                                        CD_REFERENTIEL  EBIS_FACT_REJET.CD_REFERENTIEL%TYPE,
                                        CD_EXPENSE         EBIS_FACT_REJET.CD_EXPENSE%TYPE,
                                        SOCCODE         EBIS_FOURNISSEURS.SOCCODE%TYPE,
                                        NUM_EXPENSE     EBIS_FACT_REJET.NUM_EXPENSE%TYPE,
                                        FMONTHT         EBIS_FACT_REJET.FMONTHT%TYPE,
                                        FMONTTTC         EBIS_FACT_REJET.FMONTTTC%TYPE,
                                        DATE_COMPTA     EBIS_FACT_REJET.DATE_COMPTA%TYPE,
                                        LNUM             EBIS_FACT_REJET.LNUM%TYPE,
                                        IDENT             EBIS_FACT_REJET.IDENT%TYPE,
                                        LMONTHT         EBIS_FACT_REJET.LMONTHT%TYPE,
                                        LMOISPREST         EBIS_FACT_REJET.LMOISPREST%TYPE,
                                        CUSAG_EXPENSE     EBIS_FACT_REJET.CUSAG_EXPENSE%TYPE,
                                        TOPPOST         EBIS_FACT_REJET.TOPPOST%TYPE,
                                        TIMESTAMP       EBIS_FACT_REJET.TIMESTAMP%TYPE,
                                        CODE_RETOUR     EBIS_FACT_REJET.CODE_RETOUR%TYPE,
                                        TOP_ETAT        EBIS_FACT_REJET.TOP_ETAT%TYPE,
                                        NUMENR            EBIS_FACT_REJET.NUMENR%TYPE
                             );

TYPE ebis_factures_listeCurType IS REF CURSOR RETURN ebis_factures_ViewType;

PROCEDURE lister_rejet_factures( p_centrefrais    IN CENTRE_FRAIS.CODCFRAIS%TYPE,
                                 s_curseur         IN OUT ebis_factures_listeCurType
                            );

 TYPE fournisseur IS RECORD (    SOCCODE                  EBIS_FOURNISSEURS.SOCCODE%TYPE,
                                       SIREN                      EBIS_FOURNISSEURS.SIREN%TYPE,
                                       PERIMETRE                EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                                       REFERENTIEL              EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                                 CODE_FOURNISSEUR_EBIS    EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                 FLAGLOCK                  EBIS_FOURNISSEURS.FLAGLOCK%TYPE
                           );

   TYPE fournisseurCurType IS REF CURSOR RETURN fournisseur;

   PROCEDURE insert_fournisseur ( p_soccode                 IN EBIS_FOURNISSEURS.soccode%TYPE,
                                  p_siren                    IN EBIS_FOURNISSEURS.SIREN%TYPE,
                                    p_perimetre                IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                                  p_referentiel             IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                                  p_code_fournisseur_ebis   IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                   p_message                 OUT VARCHAR2
                            );

   PROCEDURE update_fournisseur ( p_soccode                     IN EBIS_FOURNISSEURS.soccode%TYPE,
                                      p_siren                        IN EBIS_FOURNISSEURS.SIREN%TYPE,
                                    p_perimetre                    IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                                  p_referentiel                 IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                                  p_code_fournisseur_ebis       IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                     p_siren_sav                    IN EBIS_FOURNISSEURS.SIREN%TYPE,
                                  p_perimetre_sav               IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                                    p_referentiel_sav             IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                                  p_code_fournisseur_ebis_sav   IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                   p_flaglock                    IN NUMBER,
                                  p_global                      IN VARCHAR2,
                                  p_nbcurseur                   OUT INTEGER,
                                  p_message                     OUT VARCHAR2
                           );

   PROCEDURE delete_fournisseur ( p_soccode                 IN EBIS_FOURNISSEURS.soccode%TYPE,
                                      p_siren                    IN EBIS_FOURNISSEURS.SIREN%TYPE,
                                    p_perimetre                IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                                  p_referentiel             IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                                  p_code_fournisseur_ebis   IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                    p_flaglock                IN NUMBER,
                                  p_nbcurseur                 OUT INTEGER,
                                  p_message                   OUT VARCHAR2
                           );

   PROCEDURE select_fournisseur ( p_soccode                 IN EBIS_FOURNISSEURS.soccode%TYPE,
                                      p_siren                    IN EBIS_FOURNISSEURS.SIREN%TYPE,
                                  p_perimetre                IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                                  p_referentiel              IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                                  p_code_fournisseur_ebis   IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                   p_curFournisseur             IN OUT fournisseurCurType,
                                  p_nbcurseur                 OUT INTEGER,
                                  p_message                   OUT VARCHAR2
                            );

    PROCEDURE select_ligne_fournisseur ( p_soccode                 IN EBIS_FOURNISSEURS.SOCCODE%TYPE,
                                 p_siren                     IN EBIS_FOURNISSEURS.SIREN%TYPE,
                               p_perimetre                 IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                               p_referentiel               IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                               p_code_fournisseur_ebis   IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                p_curFournisseur          IN OUT fournisseurCurType,
                               p_nbcurseur                  OUT INTEGER,
                               p_message                    OUT VARCHAR2) ;


    PROCEDURE LISTER_SIREN(p_code IN VARCHAR2,

                                p_curSiren  IN OUT Pack_Liste_Dynamique.liste_dyn );


    PROCEDURE SELECT_REJET_FACTURE ( p_datfactdebut                 IN EBIS_FACT_REJET.DATFACT%TYPE,
                                          p_datfactfin                 IN EBIS_FACT_REJET.DATFACT%TYPE,
                                     p_topEtat                    IN EBIS_FACT_REJET.TOP_ETAT%TYPE,
                                     p_centrefrais                IN CENTRE_FRAIS.CODCFRAIS%TYPE,
                                   p_curRejetFacture            IN OUT rejet_facture_listeCurType,
                                  p_nbcurseur                 OUT INTEGER,
                                  p_message                   OUT VARCHAR2
                            );

	PROCEDURE UPDATE_REJET_FACTURE ( p_chaine    IN  VARCHAR2,
                        p_message   OUT VARCHAR2
                     );

    FUNCTION SELECT_CODSG (p_numcont IN EXP_CONTRAT_REJET.NUMCONT%TYPE,
                        p_soccont IN EXP_CONTRAT_REJET.SOCCONT%TYPE,
                        p_cav   IN EXP_CONTRAT_REJET.CAV%TYPE,
                        p_lcnum IN EXP_CONTRAT_REJET.LCNUM%TYPE,
                        p_ident IN EXP_CONTRAT_REJET.IDENT%TYPE
                     ) RETURN NUMBER;



     PROCEDURE lister_logs_tt_expensebis ( s_curseur     IN OUT ebis_logs_ttebis_listeCurType
                                         ) ;

     TYPE logs_lignecont_ViewType IS RECORD (   TYPE_ACTION    NUMBER,
                                                DATE_LOG       DATE,
                                                USER_LOG       VARCHAR(30),
                                                CONTRAT        VARCHAR2(15),
                                                PERIMETRE      VARCHAR2(5),
                                                REFFOURNISSEUR VARCHAR2(5),
                                                FOURNISSEUR    VARCHAR2(10),
                                                LIGNE          NUMBER,
                                                CODE_RESSOURCE NUMBER,
                                                NOM_RESSOURCE  VARCHAR2(30),
                                                DATEDEB_LIGNE  DATE,
                                                DATEFIN_LIGNE  DATE,
                                                SOCIETE        VARCHAR2(4),
                                                SIREN          NUMBER,
                                                AVENANT        VARCHAR2(2),
                                                DATDEBCONTRAT   DATE,
                                                DATFINCONTRAT  DATE
                                            );


    TYPE logs_lignecont_listeCurType IS REF CURSOR RETURN logs_lignecont_ViewType;

     PROCEDURE lister_logs_ligne_cont_delete ( s_curseur     IN OUT logs_lignecont_listeCurType
                                         ) ;

END Pack_Ebis_Ihm;
/


CREATE OR REPLACE PACKAGE BODY     Pack_Ebis_Ihm AS

-- ************************************************************************************************
-- Procédure lister_logs_contrats_ressource
--
--
-- ************************************************************************************************
PROCEDURE lister_logs_contrats_ressource ( s_curseur     IN OUT ebis_logs_cont_listeCurType
                                         ) IS
          -- Variables locales
          l_msg           VARCHAR2(1024);

BEGIN
     BEGIN

     OPEN s_curseur  FOR

           SELECT E.NUMCONT ,
                 E.SOCCONT,
                 E.CAV,
                 TO_CHAR(E.LCNUM,'FM09999') AS LCNUM,
                 TO_CHAR(E.IDENT,'FM09999999') AS IDENT,
                 E.CHAMP_CONTRAT,
                 E.CHAMP_RESSOURCE ,
                 E.COMMENTAIRE,
                 --recupere le codsg de la situation
                 NVL(Pack_Ebis_Ihm.SELECT_CODSG(E.NUMCONT,E.SOCCONT,E.CAV,E.LCNUM,E.IDENT),0) CODSG,
                 --recupere le libelle du DPG
                 (select libdsg from struct_info where codsg = NVL(Pack_Ebis_Ihm.SELECT_CODSG(E.NUMCONT,E.SOCCONT,E.CAV,E.LCNUM,E.IDENT),0) ) LIBDSG,
                 TO_CHAR(C.CDATDEB,'dd/mm/yyyy') CDATDEB,
                 TO_CHAR(C.CDATFIN,'dd/mm/yyyy') CDATFIN,
                 d.codref referentiel,
                 d.codperim perimetre

          FROM EXP_CONTRAT_REJET E, CONTRAT C, STRUCT_INFO si, directions d
                  WHERE E.NUMCONT=C.NUMCONT(+)
                    AND E.SOCCONT=C.SOCCONT(+)
                    AND E.CAV=C.CAV(+)
                    AND c.codsg = si.codsg
                    AND d.coddir = si.coddir
          ORDER BY E.NUMCONT ASC;

     EXCEPTION
               WHEN NO_DATA_FOUND THEN
                     Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                     RAISE_APPLICATION_ERROR( -20849,  l_msg);

              WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR( -20998, SQLERRM);
    END;
END lister_logs_contrats_ressource;

PROCEDURE lister_rejet_factures (p_centrefrais    IN CENTRE_FRAIS.CODCFRAIS%TYPE,
                                 s_curseur     IN OUT ebis_factures_listeCurType
                                ) IS
        -- Variables locales
        l_msg           VARCHAR2(1024);

BEGIN
     BEGIN

           OPEN s_curseur  FOR

                 SELECT e.NUMCONT,
                      e.NUMFACT,
                      e.TYPFACT,
                      e.DATFACT,
                      e.CAV,
                      e.CD_REFERENTIEL,
                      e.CD_EXPENSE,
                      ef.SOCCODE,
                      e.NUM_EXPENSE,
                      e.FMONTHT,
                      e.FMONTTTC,
                      e.DATE_COMPTA,
                      e.LNUM,
                      e.IDENT,
                      e.LMONTHT,
                      e.LMOISPREST,
                      e.CUSAG_EXPENSE,
                      e.TOPPOST,
                      e.TIMESTAMP,
                      e.CODE_RETOUR,
                      DECODE(e.TOP_ETAT,'AT','A traiter','TR','Traité','EA','En attente','inconnu') TOP_ETAT,
                      e.NUMENR
                FROM EBIS_FACT_REJET e,
                      SITU_RESS sr,
                      STRUCT_INFO si,
                      EBIS_FOURNISSEURS ef
                WHERE e.ident=sr.ident(+)
                      AND (e.LMOISPREST BETWEEN sr.DATSITU AND sr.DATDEP )
                      AND si.codsg=sr.codsg
                     -- le centre de frais 0 (toute la bip) permet de visualiser la totalité des factures en rejets
                      AND (decode(p_centrefrais,0,si.SCENTREFRAIS,p_centrefrais)=si.SCENTREFRAIS OR  si.SCENTREFRAIS IS NULL)
                      AND ef.CODE_FOURNISSEUR_EBIS=e.CD_EXPENSE
                UNION
              -- On recupere les facture validé et les autres
              SELECT e.NUMCONT,
                      e.NUMFACT,
                      e.TYPFACT,
                      e.DATFACT,
                      e.CAV,
                      e.CD_REFERENTIEL,
                      e.CD_EXPENSE,
                      ef.SOCCODE,
                      e.NUM_EXPENSE,
                      e.FMONTHT,
                      e.FMONTTTC,
                      e.DATE_COMPTA,
                      e.LNUM,
                      e.IDENT,
                      e.LMONTHT,
                      e.LMOISPREST,
                      e.CUSAG_EXPENSE,
                      e.TOPPOST,
                      e.TIMESTAMP,
                      e.CODE_RETOUR,
                      DECODE(e.TOP_ETAT,'AT','A traiter','TR','Traité','EA','En attente','inconnu') TOP_ETAT,
                      e.NUMENR
              FROM EBIS_FACT_REJET e,
                      FACTURE f,
                      EBIS_FOURNISSEURS ef
              WHERE f.NUM_EXPENSE(+)=e.NUM_EXPENSE
                    AND e.NUMENR NOT IN (SELECT NUMENR FROM EBIS_FACT_REJET e1, SITU_RESS sr1 WHERE e1.ident=sr1.ident(+)
                                                                                        AND e1.LMOISPREST BETWEEN sr1.DATSITU AND sr1.DATDEP )
                           -- le centre de frais 0 (toute la bip) permet de visualiser la totalité des factures en rejets
                    AND ( decode(p_centrefrais,0,f.FCENTREFRAIS,p_centrefrais)=f.FCENTREFRAIS OR f.FCENTREFRAIS IS NULL )
                    AND ef.CODE_FOURNISSEUR_EBIS=e.CD_EXPENSE
                  UNION -- PPM 58085
                        select 
                      e.NUMCONT,
                      e.NUMFACT,
                      e.TYPFACT,
                      e.DATFACT,
                      e.CAV,
                      e.CD_REFERENTIEL,
                      e.CD_EXPENSE,
                      ef.SOCCODE ,
                      e.NUM_EXPENSE,
                      e.FMONTHT,
                      e.FMONTTTC,
                      e.DATE_COMPTA,
                      e.LNUM,
                      e.IDENT,
                      e.LMONTHT,
                      e.LMOISPREST,
                      e.CUSAG_EXPENSE,
                      e.TOPPOST,
                      e.TIMESTAMP,
                      e.CODE_RETOUR,
                      DECODE(TOP_ETAT,'AT','A traiter','TR','Traité','EA','En attente','inconnu') TOP_ETAT,
                      e.NUMENR
 from EBIS_FACT_REJET e, EBIS_FOURNISSEURS ef
 where e.CD_EXPENSE NOT IN (SELECT DISTINCT CODE_FOURNISSEUR_EBIS from ebis_fournisseurs) 
 and SOCCODE in (select soccode from EBIS_FOURNISSEURS where ROWNUM = 1)
            UNION
            -- Recherche du centre de frais attaché au contrat
            SELECT e.NUMCONT,
                      e.NUMFACT,
                      e.TYPFACT,
                      e.DATFACT,
                      e.CAV,
                      e.CD_REFERENTIEL,
                      e.CD_EXPENSE,
                      ef.SOCCODE,
                      e.NUM_EXPENSE,
                      e.FMONTHT,
                      e.FMONTTTC,
                      e.DATE_COMPTA,
                      e.LNUM,
                      e.IDENT,
                      e.LMONTHT,
                      e.LMOISPREST,
                      e.CUSAG_EXPENSE,
                      e.TOPPOST,
                      e.TIMESTAMP,
                      e.CODE_RETOUR,
                      DECODE(e.TOP_ETAT,'AT','A traiter','TR','Traité','EA','En attente','inconnu') TOP_ETAT,
                      e.NUMENR
              FROM EBIS_FACT_REJET e,
                      CONTRAT c,
                      EBIS_FOURNISSEURS ef
              WHERE c.NUMCONT=e.NUMCONT
                      AND c.CAV=e.CAV
                    AND e.NUMENR NOT IN (SELECT NUMENR FROM EBIS_FACT_REJET e1, SITU_RESS sr1 WHERE e1.ident=sr1.ident(+)
                                                                                    AND e1.LMOISPREST BETWEEN sr1.DATSITU AND sr1.DATDEP )
                     -- le centre de frais 0 (toute la bip) permet de visualiser la totalité des factures en rejets     
               AND ( decode(p_centrefrais,0,c.CCENTREFRAIS,p_centrefrais)=c.CCENTREFRAIS OR c.CCENTREFRAIS IS NULL )
                    AND ef.CODE_FOURNISSEUR_EBIS=e.CD_EXPENSE
                 ORDER BY NUMENR ASC ;

          EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                              Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                         RAISE_APPLICATION_ERROR( -20849,  l_msg);

                   WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR( -20998, SQLERRM);
    END;
END lister_rejet_factures;


PROCEDURE insert_fournisseur ( p_soccode                 IN EBIS_FOURNISSEURS.SOCCODE%TYPE,
                                 p_siren                     IN EBIS_FOURNISSEURS.SIREN%TYPE,
                                 p_perimetre                 IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                               p_referentiel             IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                               p_code_fournisseur_ebis   IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                p_message                 OUT VARCHAR2
                            ) IS
      -- Variables locales
      l_msg VARCHAR(1024);
      l_fournisseur AGENCE.SOCFLIB%TYPE;
      l_soccode AGENCE.SOCCODE%TYPE;
BEGIN
      p_message := '';

      BEGIN





         INSERT INTO EBIS_FOURNISSEURS ( SOCCODE,
                                              SIREN,
                                              PERIMETRE,
                                           REFERENTIEL,
                                                CODE_FOURNISSEUR_EBIS
                                       )
         VALUES ( p_soccode,
                   p_siren,
                   p_perimetre,
                  p_referentiel,
                  p_code_fournisseur_ebis
                );

      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN

          -- 'Code fournisseur déjà créé'

            Pack_Global.recuperer_message( 20307, NULL, NULL, NULL, l_msg);

            RAISE_APPLICATION_ERROR( -20307, l_msg);





         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20998, SQLERRM);

      END;

      -- Récuparation du libellé du fournisseur
      SELECT a.SOCFLIB INTO l_fournisseur
      FROM AGENCE a
      WHERE a.SOCCODE = p_soccode
      AND a.SIREN = p_siren
      AND ROWNUM = 1
      ;


      -- 'Fournisseur %s1 créé''

      Pack_Global.recuperer_message( 3004, '%s1', l_fournisseur, NULL, l_msg);

      p_message := l_msg;

END insert_fournisseur;



PROCEDURE update_fournisseur ( p_soccode                     IN EBIS_FOURNISSEURS.SOCCODE%TYPE,
                               p_siren                         IN EBIS_FOURNISSEURS.SIREN%TYPE,
                                 p_perimetre                     IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                               p_referentiel                 IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                               p_code_fournisseur_ebis       IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                  p_siren_sav                     IN EBIS_FOURNISSEURS.SIREN%TYPE,
                               p_perimetre_sav               IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                                 p_referentiel_sav             IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                               p_code_fournisseur_ebis_sav   IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                p_flaglock                    IN NUMBER,
                               p_global                      IN VARCHAR2,
                               p_nbcurseur                   OUT INTEGER,
                               p_message                     OUT VARCHAR2
                             ) IS
       -- Variables locales
       l_msg   VARCHAR(1024);
       l_fournisseur AGENCE.SOCFLIB%TYPE;
BEGIN
     p_nbcurseur := 0;
     p_message := '';

     BEGIN

          UPDATE EBIS_FOURNISSEURS
                 SET
                        SIREN = p_siren,
                      PERIMETRE = p_perimetre,
                        REFERENTIEL = p_referentiel,
                      CODE_FOURNISSEUR_EBIS = p_code_fournisseur_ebis,
                      FLAGLOCK = DECODE( p_flaglock, 1000000, 0, p_flaglock + 1)
                  WHERE
                        SOCCODE = p_soccode
                  AND SIREN = p_siren_sav
                AND PERIMETRE = p_perimetre_sav
                  AND REFERENTIEL = p_referentiel_sav
                  AND CODE_FOURNISSEUR_EBIS = p_code_fournisseur_ebis_sav
                     AND FLAGLOCK = p_flaglock;



           EXCEPTION
               WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
     END;


     IF SQL%NOTFOUND THEN
         -- 'Accès concurrent'
         Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
     ELSE
             -- Récuparation du libellé du fournisseur
          SELECT a.SOCFLIB INTO l_fournisseur
          FROM AGENCE a
          WHERE a.SOCCODE = p_soccode
         AND ROWNUM = 1
         AND a.SIREN = p_siren
           ;
         -- 'Fournisseur %s1 modifié'
         Pack_Global.recuperer_message( 3005, '%s1', l_fournisseur, NULL, l_msg);

         p_message := l_msg;
     END IF;

     COMMIT;

END update_fournisseur;


PROCEDURE delete_fournisseur ( p_soccode                 IN EBIS_FOURNISSEURS.SOCCODE%TYPE,
                                 p_siren                     IN EBIS_FOURNISSEURS.SIREN%TYPE,
                                 p_perimetre                 IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                               p_referentiel             IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                               p_code_fournisseur_ebis   IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                 p_flaglock                IN NUMBER,
                               p_nbcurseur                 OUT INTEGER,
                               p_message                   OUT VARCHAR2
                            ) IS
      -- Variables locales
      l_msg                                   VARCHAR(1024);
      l_fournisseur                       AGENCE.SOCFLIB%TYPE;
      referential_integrity                 EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
BEGIN
     p_nbcurseur := 0;
     p_message := '';

     BEGIN


           DELETE FROM EBIS_FOURNISSEURS
           WHERE
                SOCCODE = p_soccode
          AND SIREN = p_siren
           AND PERIMETRE = p_perimetre
          AND REFERENTIEL = p_referentiel
          AND CODE_FOURNISSEUR_EBIS = p_code_fournisseur_ebis
          AND FLAGLOCK = p_flaglock
           ;

           EXCEPTION
                      WHEN referential_integrity THEN
                             -- habiller le msg erreur
                           Pack_Global.recuperation_integrite(-2292);

                      WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR( -20998, SQLERRM);
     END;

     IF SQL%NOTFOUND THEN

         -- 'Accès concurrent'

         Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);

         RAISE_APPLICATION_ERROR( -20999, l_msg );

     ELSE
             -- Récuparation du libellé du fournisseur
          SELECT a.SOCFLIB INTO l_fournisseur
          FROM AGENCE a
          WHERE a.SOCCODE = p_soccode
         AND   a.SIREN = p_siren
         AND ROWNUM = 1
         -- AND a.SIREN = p_siren
           ;
         -- message 'Fournisseur %s1 supprimé'


         Pack_Global.recuperer_message( 3006, '%s1', l_fournisseur, NULL, l_msg);

         p_message := l_msg;

     END IF;

END delete_fournisseur;


PROCEDURE select_fournisseur ( p_soccode                 IN EBIS_FOURNISSEURS.SOCCODE%TYPE,
                                 p_siren                     IN EBIS_FOURNISSEURS.SIREN%TYPE,
                               p_perimetre                 IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                               p_referentiel               IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                               p_code_fournisseur_ebis   IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                p_curFournisseur          IN OUT fournisseurCurType,
                               p_nbcurseur                  OUT INTEGER,
                               p_message                    OUT VARCHAR2
                             )IS
      l_msg VARCHAR2( 1024);
BEGIN
     p_nbcurseur := 1;
     p_message := '';

     OPEN p_curFournisseur FOR

           SELECT SOCCODE,
                     SIREN,
                  PERIMETRE,
                  REFERENTIEL,
                  CODE_FOURNISSEUR_EBIS,
                  FLAGLOCK
           FROM EBIS_FOURNISSEURS
           WHERE
               SOCCODE = p_soccode
--           AND SIREN = p_siren
           AND PERIMETRE = p_perimetre
           AND REFERENTIEL = p_referentiel
           AND CODE_FOURNISSEUR_EBIS = p_code_fournisseur_ebis
           ;

      -- en cas absence
      -- p_message := 'Code Founisseur inexistant';
      -- Ce message est utilisé comme message APPLICATIF et
      -- message d'exception. => Il porte un numéro d'EXCEPTION
      Pack_Global.recuperer_message( 20308, NULL, NULL, NULL, l_msg);

      p_message := l_msg;

END select_fournisseur;


PROCEDURE select_ligne_fournisseur ( p_soccode                 IN EBIS_FOURNISSEURS.SOCCODE%TYPE,
                                 p_siren                     IN EBIS_FOURNISSEURS.SIREN%TYPE,
                               p_perimetre                 IN EBIS_FOURNISSEURS.PERIMETRE%TYPE,
                               p_referentiel               IN EBIS_FOURNISSEURS.REFERENTIEL%TYPE,
                               p_code_fournisseur_ebis   IN EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE,
                                p_curFournisseur          IN OUT fournisseurCurType,
                               p_nbcurseur                  OUT INTEGER,
                               p_message                    OUT VARCHAR2
                             )IS
      l_msg VARCHAR2( 1024);
BEGIN
     p_nbcurseur := 1;
     p_message := '';

     OPEN p_curFournisseur FOR

           SELECT SOCCODE,
                     SIREN,
                  PERIMETRE,
                  REFERENTIEL,
                  CODE_FOURNISSEUR_EBIS,
                  FLAGLOCK
           FROM EBIS_FOURNISSEURS
           WHERE
               SOCCODE = p_soccode
--           AND SIREN = p_siren
           AND PERIMETRE = p_perimetre
           AND REFERENTIEL = p_referentiel
           AND CODE_FOURNISSEUR_EBIS = p_code_fournisseur_ebis
           ;

      Pack_Global.recuperer_message( 20308, NULL, NULL, NULL, l_msg);

      p_message := l_msg;

END select_ligne_fournisseur;



PROCEDURE LISTER_SIREN ( p_code       IN VARCHAR2,

                           p_curSiren   IN OUT Pack_Liste_Dynamique.liste_dyn
                       ) IS
BEGIN

     OPEN p_curSiren FOR
           SELECT DISTINCT SIREN,SIREN libelle
          FROM  agence a
          WHERE  trim(SOCCODE)  =  trim(p_code)
             AND SIREN IS NOT NULL
          ORDER BY SIREN DESC;

END LISTER_SIREN;

-- Select dans les facture rejeter
-- Select dans les facture rejeter
PROCEDURE SELECT_REJET_FACTURE ( p_datfactdebut                 IN EBIS_FACT_REJET.DATFACT%TYPE,
                                          p_datfactfin                 IN EBIS_FACT_REJET.DATFACT%TYPE,
                                     p_topEtat                    IN EBIS_FACT_REJET.TOP_ETAT%TYPE,
                                     p_centrefrais                IN CENTRE_FRAIS.CODCFRAIS%TYPE,
                                   p_curRejetFacture            IN OUT rejet_facture_listeCurType,
                                  p_nbcurseur                 OUT INTEGER,
                                  p_message                   OUT VARCHAR2
                            )IS
    -- Variables locales
        l_msg           VARCHAR2(1024);
        l_datfactfin     EBIS_FACT_REJET.DATFACT%TYPE;
        l_datfactdebut     EBIS_FACT_REJET.DATFACT%TYPE;
        l_topEtat        VARCHAR(20);

BEGIN
     p_nbcurseur := 1;
     p_message := '';

     -- si la date de fin non renseigner on prend la date de la mensuelle
     IF p_datfactfin IS NOT NULL THEN
         l_datfactfin:=p_datfactfin;
        ELSE
        SELECT cmensuelle INTO l_datfactfin FROM DATDEBEX;
         END IF;
    -- si la date de debut n'est pas renseigner on prend une date de reference
     IF p_datfactdebut IS NOT NULL THEN  l_datfactdebut:=p_datfactdebut;
         ELSE
        l_datfactdebut:='01/01/2000';
         END IF;


     BEGIN

          -- s'il n'y a pa de restriction sur le top_etat
          IF p_topEtat='TT' THEN
                IF p_centrefrais<>0 THEN
                   OPEN p_curRejetFacture  FOR
                         --on ch les fact ayant une prestation correspondante dans situ_ress
                         SELECT e.NUMENR,
                                    e.NUMCONT,
                                 e.CAV,
                                 e.NUMFACT,
                                 e.IDENT,
                                 e.NUM_EXPENSE,
                                 r.lib_err,
                                 e.TOP_ETAT,
                                 si.SCENTREFRAIS FC
                        FROM EBIS_FACT_REJET e,
                              SITU_RESS sr,
                              STRUCT_INFO si,
                              EBIS_MOTIFS_REJETS_FACTURE r
                        WHERE TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin
                              AND e.ident=sr.ident(+)
                              AND (e.LMOISPREST BETWEEN sr.DATSITU AND sr.DATDEP )
                              AND si.codsg=sr.codsg
                              AND si.SCENTREFRAIS=p_centrefrais
                              AND r.code_err = e.code_retour
                        UNION
                      -- On recupere les facture validé et les autres
                      SELECT e.NUMENR,
                                  e.NUMCONT,
                                e.CAV,
                                e.NUMFACT,
                                e.IDENT,
                                e.NUM_EXPENSE,
                                 r.lib_err,
                                e.TOP_ETAT,
                                f.FCENTREFRAIS FC
                      FROM EBIS_FACT_REJET e,
                              FACTURE f,
                              ebis_motifs_rejets_facture r
                      WHERE TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin
                              AND f.NUM_EXPENSE(+)=e.NUM_EXPENSE
                            AND e.NUMENR NOT IN (SELECT NUMENR FROM EBIS_FACT_REJET e1, SITU_RESS sr1 WHERE e1.ident=sr1.ident(+)
                                                                                                AND e1.LMOISPREST BETWEEN sr1.DATSITU AND sr1.DATDEP )
                            AND ( f.FCENTREFRAIS=p_centrefrais OR f.FCENTREFRAIS IS NULL )
                            AND r.code_err = e.code_retour
                    UNION
                    -- Recherche du centre de frais attaché au contrat
                    SELECT e.NUMENR,
                                  e.NUMCONT,
                                e.CAV,
                                e.NUMFACT,
                                e.IDENT,
                                e.NUM_EXPENSE,
                                 r.lib_err,
                                e.TOP_ETAT,
                                c.CCENTREFRAIS FC
                      FROM EBIS_FACT_REJET e,
                              CONTRAT c,
                              EBIS_MOTIFS_REJETS_FACTURE r
                      WHERE c.NUMCONT=e.NUMCONT
                            AND TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin -- PPM 58101
                            AND c.CAV=e.CAV
                            AND e.NUMENR NOT IN (SELECT NUMENR FROM EBIS_FACT_REJET e1, SITU_RESS sr1 WHERE e1.ident=sr1.ident(+)
                                                                                            AND e1.LMOISPREST BETWEEN sr1.DATSITU AND sr1.DATDEP )
                            AND ( c.CCENTREFRAIS=p_centrefrais OR c.CCENTREFRAIS IS NULL )
                            AND r.code_err = e.code_retour
                            ORDER BY NUMENR ASC;
                ELSE
                               OPEN p_curRejetFacture  FOR
                         --on ch les fact ayant une prestation correspondante dans situ_ress
                         SELECT e.NUMENR,
                                    e.NUMCONT,
                                 e.CAV,
                                 e.NUMFACT,
                                 e.IDENT,
                                 e.NUM_EXPENSE,
                                 r.lib_err,
                                 e.TOP_ETAT,
                                 si.SCENTREFRAIS FC
                        FROM EBIS_FACT_REJET e,
                              SITU_RESS sr,
                              STRUCT_INFO si,
                              EBIS_MOTIFS_REJETS_FACTURE r
                        WHERE TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin
                              AND e.ident=sr.ident(+)
                              AND (e.LMOISPREST BETWEEN sr.DATSITU AND sr.DATDEP )
                              AND si.codsg=sr.codsg
                              AND r.code_err = e.code_retour
                        UNION
                      -- On recupere les facture validé et les autres
                      SELECT e.NUMENR,
                                  e.NUMCONT,
                                e.CAV,
                                e.NUMFACT,
                                e.IDENT,
                                e.NUM_EXPENSE,
                                 r.lib_err,
                                e.TOP_ETAT,
                                f.FCENTREFRAIS FC
                      FROM EBIS_FACT_REJET e,
                              FACTURE f,
                              ebis_motifs_rejets_facture r
                      WHERE TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin
                              AND f.NUM_EXPENSE(+)=e.NUM_EXPENSE
                            AND e.NUMENR NOT IN (SELECT NUMENR FROM EBIS_FACT_REJET e1, SITU_RESS sr1 WHERE e1.ident=sr1.ident(+)
                                                                                                AND e1.LMOISPREST BETWEEN sr1.DATSITU AND sr1.DATDEP )
                            AND r.code_err = e.code_retour
                    UNION
                    -- Recherche du centre de frais attaché au contrat
                    SELECT e.NUMENR,
                                  e.NUMCONT,
                                e.CAV,
                                e.NUMFACT,
                                e.IDENT,
                                e.NUM_EXPENSE,
                                 r.lib_err,
                                e.TOP_ETAT,
                                c.CCENTREFRAIS FC
                      FROM EBIS_FACT_REJET e,
                              CONTRAT c,
                              EBIS_MOTIFS_REJETS_FACTURE r
                      WHERE c.NUMCONT=e.NUMCONT
                              AND c.CAV=e.CAV
							  AND TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin -- PPM 58101 (QC 1636)
                            AND e.NUMENR NOT IN (SELECT NUMENR FROM EBIS_FACT_REJET e1, SITU_RESS sr1 WHERE e1.ident=sr1.ident(+)
                                                                                            AND e1.LMOISPREST BETWEEN sr1.DATSITU AND sr1.DATDEP )
                            AND r.code_err = e.code_retour
                            ORDER BY NUMENR ASC;

                END IF;
               -- si le top_etat est renseigner
          ELSE
                IF p_centrefrais<>0 THEN
                                   OPEN p_curRejetFacture  FOR
                                   --on ch les fact ayant une prestation correspondante dans situ_ress
                                   SELECT e.NUMENR,
                                                e.NUMCONT,
                                             e.CAV,
                                             e.NUMFACT,
                                             e.IDENT,
                                             e.NUM_EXPENSE,
                                              r.lib_err,
                                             e.TOP_ETAT,
                                             si.SCENTREFRAIS FC
                                    FROM EBIS_FACT_REJET e,
                                          SITU_RESS sr,
                                          STRUCT_INFO si,
                                          EBIS_MOTIFS_REJETS_FACTURE r
                                    WHERE TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin
                                          AND e.ident=sr.ident(+)
                                          AND (e.LMOISPREST BETWEEN sr.DATSITU AND sr.DATDEP )
                                          AND si.codsg=sr.codsg
                                          AND si.SCENTREFRAIS=p_centrefrais
                                          AND e.TOP_ETAT=p_topEtat
                                          AND r.code_err = e.code_retour
                                    UNION
                                    -- On recupere les facture validé et les autres
                                  SELECT e.NUMENR,
                                              e.NUMCONT,
                                            e.CAV,
                                            e.NUMFACT,
                                            e.IDENT,
                                            e.NUM_EXPENSE,
                                             r.lib_err,
                                            e.TOP_ETAT,
                                            f.FCENTREFRAIS FC
                                  FROM EBIS_FACT_REJET e,
                                          FACTURE f,
                                          EBIS_MOTIFS_REJETS_FACTURE r
                                  WHERE TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin
                                          AND f.NUM_EXPENSE(+)=e.NUM_EXPENSE
                                        AND e.NUMENR NOT IN (SELECT NUMENR FROM EBIS_FACT_REJET e1, SITU_RESS sr1 WHERE e1.ident=sr1.ident(+)
                                                                                                            AND e1.LMOISPREST BETWEEN sr1.DATSITU AND sr1.DATDEP )
                                        AND ( f.FCENTREFRAIS=p_centrefrais OR f.FCENTREFRAIS IS NULL )
                                           AND e.TOP_ETAT=p_topEtat
                                           AND r.code_err = e.code_retour
                                UNION
                                -- Recherche du centre de frais attaché au contrat
                                SELECT e.NUMENR,
                                              e.NUMCONT,
                                            e.CAV,
                                            e.NUMFACT,
                                            e.IDENT,
                                            e.NUM_EXPENSE,
                                             r.lib_err,
                                            e.TOP_ETAT,
                                            c.CCENTREFRAIS FC
                                  FROM EBIS_FACT_REJET e,
                                          CONTRAT c,
                                          EBIS_MOTIFS_REJETS_FACTURE r
                                  WHERE TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin
                                          AND c.NUMCONT=e.NUMCONT
                                          AND c.CAV=e.CAV
                                        AND e.NUMENR NOT IN (SELECT NUMENR FROM EBIS_FACT_REJET e1, SITU_RESS sr1 WHERE e1.ident=sr1.ident(+)
                                                                                                        AND e1.LMOISPREST BETWEEN sr1.DATSITU AND sr1.DATDEP )
                                        AND ( c.CCENTREFRAIS=p_centrefrais OR c.CCENTREFRAIS IS NULL )
                                        AND e.TOP_ETAT=p_topEtat
                                        AND r.code_err = e.code_retour
                                     ORDER BY NUMENR ASC ;
                ELSE
                             OPEN p_curRejetFacture  FOR
                                   --on ch les fact ayant une prestation correspondante dans situ_ress
                                   SELECT e.NUMENR,
                                                e.NUMCONT,
                                             e.CAV,
                                             e.NUMFACT,
                                             e.IDENT,
                                             e.NUM_EXPENSE,
                                              r.lib_err,
                                             e.TOP_ETAT,
                                             si.SCENTREFRAIS FC
                                    FROM EBIS_FACT_REJET e,
                                          SITU_RESS sr,
                                          STRUCT_INFO si,
                                          EBIS_MOTIFS_REJETS_FACTURE r
                                    WHERE TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin
                                          AND e.ident=sr.ident(+)
                                          AND (e.LMOISPREST BETWEEN sr.DATSITU AND sr.DATDEP )
                                          AND si.codsg=sr.codsg
                                          AND e.TOP_ETAT=p_topEtat
                                          AND r.code_err = e.code_retour
                                    UNION
                                    -- On recupere les facture validé et les autres
                                  SELECT e.NUMENR,
                                              e.NUMCONT,
                                            e.CAV,
                                            e.NUMFACT,
                                            e.IDENT,
                                            e.NUM_EXPENSE,
                                             r.lib_err,
                                            e.TOP_ETAT,
                                            f.FCENTREFRAIS FC
                                  FROM EBIS_FACT_REJET e,
                                          FACTURE f,
                                          EBIS_MOTIFS_REJETS_FACTURE r
                                  WHERE TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin
                                          AND f.NUM_EXPENSE(+)=e.NUM_EXPENSE
                                        AND e.NUMENR NOT IN (SELECT NUMENR FROM EBIS_FACT_REJET e1, SITU_RESS sr1 WHERE e1.ident=sr1.ident(+)
                                                                                                            AND e1.LMOISPREST BETWEEN sr1.DATSITU AND sr1.DATDEP )
                                           AND e.TOP_ETAT=p_topEtat
                                           AND r.code_err = e.code_retour
                                UNION
                                -- Recherche du centre de frais attaché au contrat
                                SELECT e.NUMENR,
                                              e.NUMCONT,
                                            e.CAV,
                                            e.NUMFACT,
                                            e.IDENT,
                                            e.NUM_EXPENSE,
                                             r.lib_err,
                                            e.TOP_ETAT,
                                            c.CCENTREFRAIS FC
                                  FROM EBIS_FACT_REJET e,
                                          CONTRAT c,
                                          EBIS_MOTIFS_REJETS_FACTURE r
                                  WHERE TO_DATE(TIMESTAMP) BETWEEN l_datfactdebut AND l_datfactfin
                                          AND c.NUMCONT=e.NUMCONT
                                          AND c.CAV=e.CAV
                                        AND e.NUMENR NOT IN (SELECT NUMENR FROM EBIS_FACT_REJET e1, SITU_RESS sr1 WHERE e1.ident=sr1.ident(+)
                                                                                                        AND e1.LMOISPREST BETWEEN sr1.DATSITU AND sr1.DATDEP )
                                        AND e.TOP_ETAT=p_topEtat
                                        AND r.code_err = e.code_retour
                                     ORDER BY NUMENR ASC ;

                END IF;

            END IF;

          EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                              Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                         RAISE_APPLICATION_ERROR( -20849,  l_msg);

                   WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR( -20998, SQLERRM);
    END;

END SELECT_REJET_FACTURE;


-- Mise a jour de l'etat des facture rejete
PROCEDURE UPDATE_REJET_FACTURE ( p_chaine    IN  VARCHAR2,

                        p_message   OUT VARCHAR2

                     )IS

l_reste VARCHAR2(32000);
l_numenr VARCHAR2(7);
l_topEtat VARCHAR2(20);

l_pos1 NUMBER(7);
l_pos2 NUMBER(7);

BEGIN

l_reste:=p_chaine;

WHILE LENGTH(l_reste)!=0 LOOP

      l_pos1:= INSTR(l_reste,':');
      l_pos2:= INSTR(l_reste,';');

      l_numenr:=SUBSTR(l_reste,0,l_pos1-1);
      l_topEtat:=SUBSTR(l_reste,l_pos1+1,2);

      l_reste:=SUBSTR(l_reste,l_pos2+1);


      BEGIN

      UPDATE EBIS_FACT_REJET SET TOP_ETAT=l_topEtat WHERE NUMENR=l_numenr;

      COMMIT ;

           EXCEPTION
               WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20998, SQLERRM);
        END;

END LOOP;

END UPDATE_REJET_FACTURE;


--recupere le codsg de la situation correspondant au contrat
FUNCTION SELECT_CODSG (p_numcont IN EXP_CONTRAT_REJET.NUMCONT%TYPE,
                        p_soccont IN EXP_CONTRAT_REJET.SOCCONT%TYPE,
                        p_cav   IN EXP_CONTRAT_REJET.CAV%TYPE,
                        p_lcnum IN EXP_CONTRAT_REJET.LCNUM%TYPE,
                        p_ident IN EXP_CONTRAT_REJET.IDENT%TYPE

                     ) RETURN NUMBER IS
l_codsg NUMBER(7);

BEGIN

         BEGIN

         --Si il existe une situation on recupere le codsg
         SELECT  S.CODSG INTO l_codsg
          FROM EXP_CONTRAT_REJET E,
                 LIGNE_CONT C,
               SITU_RESS S
          WHERE E.NUMCONT=C.NUMCONT(+)
            AND E.SOCCONT=C.SOCCONT(+)
            AND E.CAV=C.CAV(+)
            AND E.LCNUM=C.LCNUM(+)
            AND C.IDENT=S.IDENT(+)
            AND E.NUMCONT=p_numcont
            AND E.SOCCONT=p_soccont
            AND E.CAV=p_cav
            AND E.LCNUM=p_lcnum
            AND C.IDENT=p_ident
            AND ((c.LRESFIN BETWEEN s.DATSITU AND s.DATDEP) OR (c.LRESFIN >= s.DATSITU AND s.DATDEP IS NULL));

            EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                              --si rien recuper precedement on recupere le codsg de la derniere situation
                        SELECT  S.CODSG INTO l_codsg
               FROM EXP_CONTRAT_REJET E,
               SITU_RESS S
          WHERE E.IDENT=S.IDENT(+)
              AND E.NUMCONT=p_numcont
            AND E.SOCCONT=p_soccont
            AND E.CAV=p_cav
            AND E.LCNUM=p_lcnum
            AND E.IDENT=p_ident
            AND s.DATSITU = (SELECT MAX(DATSITU) FROM SITU_RESS S1 WHERE S1.IDENT(+)=p_ident);

                   WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR( -20998, SQLERRM);

            END;
        RETURN l_codsg;

END SELECT_CODSG;

-- ************************************************************************************************
-- Procédure lister_logs_tt_expensebis
-- Fiche 613 : liste les logs de l'envoi des Time Tracking vers ExpenseBis
--
-- ************************************************************************************************
PROCEDURE lister_logs_tt_expensebis ( s_curseur     IN OUT ebis_logs_ttebis_listeCurType
                                         ) IS
        -- Variables locales
          l_msg           VARCHAR2(1024);

BEGIN
     BEGIN
       OPEN s_curseur  FOR
                -- rejet avec un contrat
                SELECT
                  TO_CHAR( e.DPG ,'FM09999999') AS   DPG      ,  --  NUMBER(7),
                  e.SOCCODE  ,  --  CHAR(4),
                  TO_CHAR( e.IDENT ,'FM099999')  AS IDENT    ,   -- NUMBER(5),
                  e.RNOM      ,  -- VARCHAR2(30),
                  TO_CHAR(e.LMOISPREST  , 'DD/MM/YYYY') AS LMOISPREST ,--  DATE,
                  TO_CHAR(e.CUSAG ,'FM9999990D00') AS CUSAG     ,  -- NUMBER(7,2),
                  TO_CHAR(e.DATDEP , 'DD/MM/YYYY') AS DATDEP  ,   -- DATE,
                  e.NUMCONT   ,  -- CHAR(15),
                  e.CAV       ,  -- CHAR(2),
                  e.SOCCONT   ,  -- CHAR(4),
                  TO_CHAR(e.CDATFIN  , 'DD/MM/YYYY') AS CDATFIN   ,  -- DATE,
                  e.MESSAGE   , --  VARCHAR2(500),
                  TO_CHAR(e.DATE_TRAIT  , 'DD/MM/YYYY') AS DATE_TRAIT ,  -- DATE,
                  TO_CHAR(e.CODE_RETOUR) AS  CODE_RETOUR , -- NUMBER(2)
                  TO_CHAR(e.CODSG_CONT , 'FM09999999') AS CODSG_CONT ,
                    e.SYSCPT_RES ,
                    e.SYSCPT_CONT,
                    d.codref referentiel,
                    d.codperim perimetre
                  FROM   EXP_TT_REJET E, CONTRAT C, STRUCT_INFO si, DIRECTIONS d
                  WHERE
                  e.numcont = c.numcont
                  and e.cav = c.cav
                  and e.soccont = c.soccont
                  and c.codsg = si.codsg
                  and si.coddir = d.coddir
                  and E.numcont is not null
                  --ORDER BY   e.NUMCONT , e.SOCCONT ,e.CAV, e.CODE_RETOUR
                UNION
                 -- rejet sans contrat
                 SELECT
                  TO_CHAR( e.DPG ,'FM09999999') AS   DPG      ,  --  NUMBER(7),
                  e.SOCCODE  ,  --  CHAR(4),
                  TO_CHAR( e.IDENT ,'FM099999')  AS IDENT    ,   -- NUMBER(5),
                  e.RNOM      ,  -- VARCHAR2(30),
                  TO_CHAR(e.LMOISPREST  , 'DD/MM/YYYY') AS LMOISPREST ,--  DATE,
                  TO_CHAR(e.CUSAG ,'FM9999990D00') AS CUSAG     ,  -- NUMBER(7,2),
                  TO_CHAR(e.DATDEP , 'DD/MM/YYYY') AS DATDEP  ,   -- DATE,
                  e.NUMCONT   ,  -- CHAR(15),
                  e.CAV       ,  -- CHAR(2),
                  e.SOCCONT   ,  -- CHAR(4),
                  TO_CHAR(e.CDATFIN  , 'DD/MM/YYYY') AS CDATFIN   ,  -- DATE,
                  e.MESSAGE   , --  VARCHAR2(500),
                  TO_CHAR(e.DATE_TRAIT  , 'DD/MM/YYYY') AS DATE_TRAIT ,  -- DATE,
                  TO_CHAR(e.CODE_RETOUR) AS  CODE_RETOUR , -- NUMBER(2)
                  TO_CHAR(e.CODSG_CONT , 'FM09999999') AS CODSG_CONT ,
                    e.SYSCPT_RES ,
                    e.SYSCPT_CONT,
                    '' referentiel,
                    '' perimetre
                  FROM   EXP_TT_REJET E
                  WHERE  E.numcont is null
                  --ORDER BY   e.NUMCONT , e.SOCCONT ,e.CAV, e.CODE_RETOUR
                  ;

     EXCEPTION
               WHEN NO_DATA_FOUND THEN
                     Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                     RAISE_APPLICATION_ERROR( -20849,  l_msg);

              WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR( -20998, SQLERRM);
    END;
END lister_logs_tt_expensebis;

-- ************************************************************************************************
-- Procédure lister_logs_cont_ligne_supp
-- Fiche 607 :
--
-- ************************************************************************************************
PROCEDURE lister_logs_ligne_cont_delete ( s_curseur     IN OUT logs_lignecont_listeCurType
                                         ) IS
        -- Variables locales
          l_msg           VARCHAR2(1024);

BEGIN
     BEGIN
       OPEN s_curseur  FOR
                SELECT
                    TYPE_ACTION,
                    DATE_LOG,
                    USER_LOG,
                    CONTRAT,
                    PERIMETRE,
                    REFFOURNISSEUR,
                    FOURNISSEUR,
                    LIGNE,
                    CODE_RESSOURCE,
                    NOM_RESSOURCE,
                    DATEDEB_LIGNE,
                    DATEFIN_LIGNE,
                    SOCIETE,
                    SIREN,
                    AVENANT,
                    DATDEBCONTRAT,
                    DATFINCONTRAT

                 FROM EBIS_LOGS_CONT_LIGNE_SUPP
                 order by DATE_LOG desc;


     EXCEPTION
               WHEN NO_DATA_FOUND THEN
                     Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
                     RAISE_APPLICATION_ERROR( -20849,  l_msg);

              WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR( -20998, SQLERRM);
    END;
END lister_logs_ligne_cont_delete;


END Pack_Ebis_Ihm ;
/

show errors


