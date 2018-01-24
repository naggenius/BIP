-- ============================================================
-- PROJET  - Script de creation des tables BIP
-- Date : 02/10/2006	
-- Auteur :  A. SAKHRAOUI
-- Version:	1
--
-- Modifications :
--	
--
-- ============================================================

-- ========================================================
-- bip_cre_tables.sql
-- ========================================================

DROP TABLE bip.abecedaire CASCADE CONSTRAINTS;

--
-- ABECEDAIRE  (Table) 
--
CREATE TABLE bip.abecedaire
(
  numliste  NUMBER                              NOT NULL,
  liste     VARCHAR2(36)                        NOT NULL,
  numenvoi  VARCHAR2(2),
  oldnum    VARCHAR2(2),
  nextnum   VARCHAR2(2)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       5
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.abecedaire IS 'Table utilisée pour générer un numéro d''envoi sur 2 caractères pour les fichiers d''export de factures';

COMMENT ON COLUMN bip.abecedaire.numliste IS 'Numéro de liste : Indique quel est le caractère généré';

COMMENT ON COLUMN bip.abecedaire.liste IS 'Liste des caractères utilisables';

COMMENT ON COLUMN bip.abecedaire.numenvoi IS 'Numéro d''envoi généré sur 2 caractères';

COMMENT ON COLUMN bip.abecedaire.oldnum IS 'Numéro courant dans la liste';

COMMENT ON COLUMN bip.abecedaire.nextnum IS 'Prochain numéro dans la liste';


ALTER TABLE bip.actualite DROP PRIMARY KEY CASCADE;
DROP TABLE bip.actualite CASCADE CONSTRAINTS;

--
-- ACTUALITE  (Table) 
--
CREATE TABLE bip.actualite
(
  code_actu        NUMBER(5)                    NOT NULL,
  titre            VARCHAR2(50)                 NOT NULL,
  texte            VARCHAR2(255)                NOT NULL,
  date_affiche     DATE                         NOT NULL,
  date_debut       DATE                         NOT NULL,
  date_fin         DATE                         NOT NULL,
  valide           VARCHAR(1)                      NOT NULL,
  url              VARCHAR2(100),
  derniere_minute  VARCHAR(1)                      NOT NULL,
  fichier          BLOB,
  nom_fichier      VARCHAR2(100),
  mime_fichier     VARCHAR2(60),
  size_fichier     NUMBER(9)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
LOB (fichier) STORE AS
      ( TABLESPACE  tbs_bip_lob_data
        ENABLE      STORAGE IN ROW
        CHUNK       8192
        PCTVERSION  10
        NOCACHE
        STORAGE    (
                    INITIAL          1m
                    NEXT             256k
                    MINEXTENTS       1
                    MAXEXTENTS       500
                    PCTINCREASE      0
                    FREELISTS        1
                    FREELIST GROUPS  1
                    BUFFER_POOL      DEFAULT
                   )
      )
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.actualite IS 'Table des actualités qui sont affichées sur la page d''accueil de la BIP';

COMMENT ON COLUMN bip.actualite.code_actu IS 'Numéro de l''actualité';

COMMENT ON COLUMN bip.actualite.titre IS 'Titre de l''actualité';

COMMENT ON COLUMN bip.actualite.texte IS 'Texte descriptif affiché sous le titre de l''actualité';

COMMENT ON COLUMN bip.actualite.date_affiche IS 'Date affichée à l''écran devant le titre de l''actualité';

COMMENT ON COLUMN bip.actualite.date_debut IS 'Date de début de validite ( d''affichage)';

COMMENT ON COLUMN bip.actualite.date_fin IS 'Date de fin de validité ( d''affichage )';

COMMENT ON COLUMN bip.actualite.valide IS 'Top qui indique si l''actualité est valide (O/N)';

COMMENT ON COLUMN bip.actualite.url IS 'Lien vers une page html';

COMMENT ON COLUMN bip.actualite.derniere_minute IS 'Top qui indique si l''actualité doit être affichée dans la rubrique dernière minute (O/N)';

COMMENT ON COLUMN bip.actualite.fichier IS 'Fichier associé à l''actualité (document word par exemple)';

COMMENT ON COLUMN bip.actualite.nom_fichier IS 'Nom du ficher associé';

COMMENT ON COLUMN bip.actualite.mime_fichier IS 'Type MIME du fichier associé (exemple:application/msword)';

COMMENT ON COLUMN bip.actualite.size_fichier IS 'Taille du fichier associé en octets';


ALTER TABLE bip.agence DROP PRIMARY KEY CASCADE;
DROP TABLE bip.agence CASCADE CONSTRAINTS;

--
-- AGENCE  (Table) 
--
CREATE TABLE bip.agence
(
  socfour   VARCHAR2(10)                        NOT NULL,
  socflib   VARCHAR2(25)                        NOT NULL,
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL,
  soccode   VARCHAR(4)                             NOT NULL
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.agence IS 'Table des filiales des fournisseurs.';

COMMENT ON COLUMN bip.agence.socfour IS 'Identifiant de l''agence';

COMMENT ON COLUMN bip.agence.socflib IS 'Libelle agence';

COMMENT ON COLUMN bip.agence.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.agence.soccode IS 'Identifiant societe';


ALTER TABLE bip.application DROP PRIMARY KEY CASCADE;
DROP TABLE bip.application CASCADE CONSTRAINTS;

--
-- APPLICATION  (Table) 
--
CREATE TABLE bip.application
(
  airt       VARCHAR(5)                            NOT NULL,
  amop       VARCHAR2(35),
  amnemo     VARCHAR2(20),
  agappli    VARCHAR2(35),
  acme       VARCHAR2(35),
  alibel     VARCHAR2(50),
  adescr1    VARCHAR2(78),
  adescr2    VARCHAR2(78),
  adescr3    VARCHAR2(78),
  adescr4    VARCHAR2(78),
  adescr5    VARCHAR2(78),
  adescr6    VARCHAR2(78),
  flaglock   NUMBER(7)                          DEFAULT 0                     NOT NULL,
  clicode    VARCHAR(5),
  codsg      NUMBER(7),
  codgappli  VARCHAR(5),
  acdareg    VARCHAR(5)                            NOT NULL,
  alibcourt  VARCHAR2(20)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.application IS 'Table des applications.';

COMMENT ON COLUMN bip.application.airt IS 'Identifiant de l''application';

COMMENT ON COLUMN bip.application.amop IS 'Nom de la MO principale';

COMMENT ON COLUMN bip.application.amnemo IS 'Mnemonique de l''application';

COMMENT ON COLUMN bip.application.agappli IS 'Nom du gestionnaire de l''application';

COMMENT ON COLUMN bip.application.acme IS 'Nom de la maîtrise d''oeuvre principale';

COMMENT ON COLUMN bip.application.alibel IS 'Libelle de l''application';

COMMENT ON COLUMN bip.application.adescr1 IS 'Description de l''application';

COMMENT ON COLUMN bip.application.adescr2 IS 'Description de l''application';

COMMENT ON COLUMN bip.application.adescr3 IS 'Description de l''application';

COMMENT ON COLUMN bip.application.adescr4 IS 'Description de l''application';

COMMENT ON COLUMN bip.application.adescr5 IS 'Description de l''application';

COMMENT ON COLUMN bip.application.adescr6 IS 'Description de l''application';

COMMENT ON COLUMN bip.application.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.application.clicode IS 'Code client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.application.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.application.codgappli IS 'Code du gestionnaire de l''application (équivaut à un code client)';

COMMENT ON COLUMN bip.application.acdareg IS 'Code de l''application de regroupement';

COMMENT ON COLUMN bip.application.alibcourt IS 'Libellé court';


ALTER TABLE bip.audit_statut DROP PRIMARY KEY CASCADE;
DROP TABLE bip.audit_statut CASCADE CONSTRAINTS;

--
-- AUDIT_STATUT  (Table) 
--
CREATE TABLE bip.audit_statut
(
  pid           VARCHAR2(4),
  date_demande  DATE,
  demandeur     VARCHAR2(15),
  commentaire   VARCHAR2(150)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.audit_statut IS 'Table de surveillance des changements de statut des lignes BIP';

COMMENT ON COLUMN bip.audit_statut.demandeur IS 'Identifiant de l''utilisateur à l''origine du changement';

COMMENT ON COLUMN bip.audit_statut.commentaire IS 'Commentaire sur l''origine du changement';

COMMENT ON COLUMN bip.audit_statut.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.audit_statut.date_demande IS 'Date de la demande de changement';


DROP TABLE bip.batch_charge_camo_bad CASCADE CONSTRAINTS;

--
-- BATCH_CHARGE_CAMO_BAD  (Table) 
--
CREATE TABLE bip.batch_charge_camo_bad
(
  xcodcamo    VARCHAR(10),
  xclibrca    VARCHAR2(24),
  xclibca     VARCHAR2(35),
  xcdateouve  DATE,
  xcdateferm  DATE,
  xcodniv     NUMBER(3),
  xcaniv1     VARCHAR(10),
  xcaniv2     VARCHAR(10),
  xcaniv3     VARCHAR(10),
  xcaniv4     VARCHAR(10),
  xcdfain     NUMBER(1)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.batch_charge_camo_bad IS 'Table contenant des rejets de chargement dans la table des centres d''activité';

COMMENT ON COLUMN bip.batch_charge_camo_bad.xcdfain IS 'Code Facturation - Indique si le CA est facturable';

COMMENT ON COLUMN bip.batch_charge_camo_bad.xcodcamo IS 'Code centre d''activite maîtrise d''ouvrage';

COMMENT ON COLUMN bip.batch_charge_camo_bad.xclibrca IS 'Libelle reduit';

COMMENT ON COLUMN bip.batch_charge_camo_bad.xclibca IS 'Libelle du centre d''activite';

COMMENT ON COLUMN bip.batch_charge_camo_bad.xcdateouve IS 'Date d''ouverture';

COMMENT ON COLUMN bip.batch_charge_camo_bad.xcdateferm IS 'Date de fermeture';

COMMENT ON COLUMN bip.batch_charge_camo_bad.xcodniv IS 'Code niveau centre d''activite mo';

COMMENT ON COLUMN bip.batch_charge_camo_bad.xcaniv1 IS 'Code niv1 pole';

COMMENT ON COLUMN bip.batch_charge_camo_bad.xcaniv2 IS 'Code niv2 division';

COMMENT ON COLUMN bip.batch_charge_camo_bad.xcaniv3 IS 'Niv 3 departement';

COMMENT ON COLUMN bip.batch_charge_camo_bad.xcaniv4 IS 'Niv 4 direction';


DROP TABLE bip.batch_cons_sstache_res_bad CASCADE CONSTRAINTS;

--
-- BATCH_CONS_SSTACHE_RES_BAD  (Table) 
--
CREATE TABLE bip.batch_cons_sstache_res_bad
(
  tplan   NUMBER(7,2),
  tactu   NUMBER(7,2),
  TEST    NUMBER(7,2),
  pid     VARCHAR2(4),
  ecet    VARCHAR(2),
  acta    VARCHAR(2),
  acst    VARCHAR(2),
  ident   NUMBER(5),
  errmsg  VARCHAR2(128)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m 
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.batch_cons_sstache_res_bad IS 'Liste des Affectations PMW en anomalie';

COMMENT ON COLUMN bip.batch_cons_sstache_res_bad.tplan IS 'Charge planifiee pour la ressource';

COMMENT ON COLUMN bip.batch_cons_sstache_res_bad.tactu IS 'Consommation actuelle de la ressource';

COMMENT ON COLUMN bip.batch_cons_sstache_res_bad.TEST IS 'Reste a faire pour la ressource';

COMMENT ON COLUMN bip.batch_cons_sstache_res_bad.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.batch_cons_sstache_res_bad.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.batch_cons_sstache_res_bad.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.batch_cons_sstache_res_bad.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.batch_cons_sstache_res_bad.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.batch_cons_sstache_res_bad.errmsg IS 'Message d''erreur';


DROP TABLE bip.batch_cons_sst_res_m_bad CASCADE CONSTRAINTS;

--
-- BATCH_CONS_SST_RES_M_BAD  (Table) 
--
CREATE TABLE bip.batch_cons_sst_res_m_bad
(
  cdeb    DATE,
  cdur    NUMBER(8),
  cusag   NUMBER(7,2),
  chraf   NUMBER(7,2),
  chinit  NUMBER(7,2),
  pid     VARCHAR2(4),
  ecet    VARCHAR(2),
  acta    VARCHAR(2),
  acst    VARCHAR(2),
  ident   NUMBER(5),
  errmsg  VARCHAR2(128)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.batch_cons_sst_res_m_bad IS 'Liste des Consommés PMW en anomalie';

COMMENT ON COLUMN bip.batch_cons_sst_res_m_bad.cdeb IS 'Mois annee de reference';

COMMENT ON COLUMN bip.batch_cons_sst_res_m_bad.cdur IS 'Nombre de jours ouvres du mois (inutilisé)';

COMMENT ON COLUMN bip.batch_cons_sst_res_m_bad.cusag IS 'Consomme du mois';

COMMENT ON COLUMN bip.batch_cons_sst_res_m_bad.chraf IS 'Reste a faire du mois';

COMMENT ON COLUMN bip.batch_cons_sst_res_m_bad.chinit IS 'Charge initiale du mois';

COMMENT ON COLUMN bip.batch_cons_sst_res_m_bad.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.batch_cons_sst_res_m_bad.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.batch_cons_sst_res_m_bad.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.batch_cons_sst_res_m_bad.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.batch_cons_sst_res_m_bad.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.batch_cons_sst_res_m_bad.errmsg IS 'Message d''erreur Oracle';


DROP TABLE bip.batch_etape_bad CASCADE CONSTRAINTS;

--
-- BATCH_ETAPE_BAD  (Table) 
--
CREATE TABLE bip.batch_etape_bad
(
  ecet     VARCHAR(2),
  edur     NUMBER(5),
  enfi     DATE,
  ende     DATE,
  edeb     DATE,
  efin     DATE,
  pid      VARCHAR2(4),
  typetap  VARCHAR(2),
  errmsg   VARCHAR2(128)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.batch_etape_bad IS 'Liste des Etapes PMW en anomalie';

COMMENT ON COLUMN bip.batch_etape_bad.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.batch_etape_bad.edur IS 'Duree initiale de l''etape';

COMMENT ON COLUMN bip.batch_etape_bad.enfi IS 'Date revisee de fin d''etape';

COMMENT ON COLUMN bip.batch_etape_bad.ende IS 'Date revisee de debut d''etape';

COMMENT ON COLUMN bip.batch_etape_bad.edeb IS 'Date initiale de debut de l''etape';

COMMENT ON COLUMN bip.batch_etape_bad.efin IS 'Date initiale de fin d''etape';

COMMENT ON COLUMN bip.batch_etape_bad.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.batch_etape_bad.typetap IS 'Type d''etape';

COMMENT ON COLUMN bip.batch_etape_bad.errmsg IS 'Message d''erreur';


ALTER TABLE bip.batch_hdla DROP PRIMARY KEY CASCADE;
DROP TABLE bip.batch_hdla CASCADE CONSTRAINTS;

--
-- BATCH_HDLA  (Table) 
--
CREATE TABLE bip.batch_hdla
(
  pid          VARCHAR2(4)                      NOT NULL,
  totalchinit  NUMBER(7,2),
  totalchraf   NUMBER(7,2),
  pvalid       VARCHAR(1),
  astatut      VARCHAR(1),
  adatestatut  DATE
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.batch_hdla IS 'Tables Intermediaire pour RPETA';

COMMENT ON COLUMN bip.batch_hdla.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.batch_hdla.totalchinit IS 'Charge initiale du mois';

COMMENT ON COLUMN bip.batch_hdla.totalchraf IS 'Reste a faire du mois';

COMMENT ON COLUMN bip.batch_hdla.pvalid IS 'Flag';

COMMENT ON COLUMN bip.batch_hdla.astatut IS 'Statut du projet';

COMMENT ON COLUMN bip.batch_hdla.adatestatut IS 'Date de statut du projet';


DROP TABLE bip.batch_proplus_complus CASCADE CONSTRAINTS;

--
-- BATCH_PROPLUS_COMPLUS  (Table) 
--
CREATE TABLE bip.batch_proplus_complus
(
  factpid     VARCHAR2(4),
  pid         VARCHAR2(4),
  aist        VARCHAR(6),
  aistty      VARCHAR(2),
  tires       NUMBER(5),
  cdeb        DATE,
  ptype       VARCHAR(2),
  factpty     VARCHAR(2),
  pnom        VARCHAR2(30),
  factpno     VARCHAR2(30),
  pdsg        NUMBER(7),
  factpdsg    NUMBER(7),
  pcpi        NUMBER(5),
  factpcp     NUMBER(5),
  pcmouvra    VARCHAR(5),
  factpcm     VARCHAR(5),
  pnmouvra    VARCHAR(15),
  pdatdebpre  DATE,
  cusag       NUMBER(7,2),
  rnom        VARCHAR2(30),
  rprenom     VARCHAR2(15),
  datdep      DATE,
  divsecgrou  NUMBER(7),
  cpident     NUMBER(5),
  cout        NUMBER(12,2),
  matricule   VARCHAR(7),
  societe     VARCHAR(4),
  qualif      VARCHAR(3),
  dispo       NUMBER(2,1),
  chinit      NUMBER(7,2),
  chraf       NUMBER(7,2),
  rtype       VARCHAR(1),
  datsitu     DATE
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.batch_proplus_complus IS 'Table temporaire pour le traitement mensuel : nouvelles données à ajouter dans la table PROPLUS';

COMMENT ON COLUMN bip.batch_proplus_complus.cout IS 'Cout journalier ht de la ressource';

COMMENT ON COLUMN bip.batch_proplus_complus.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.batch_proplus_complus.societe IS 'Code societe de la ressource';

COMMENT ON COLUMN bip.batch_proplus_complus.qualif IS 'Qualification de la ressource';

COMMENT ON COLUMN bip.batch_proplus_complus.dispo IS 'Disponibilite en nombre de jours par semaine';

COMMENT ON COLUMN bip.batch_proplus_complus.chinit IS 'Charge initiale du mois';

COMMENT ON COLUMN bip.batch_proplus_complus.chraf IS 'Reste a faire du mois';

COMMENT ON COLUMN bip.batch_proplus_complus.rtype IS 'Type de ressource : p, f, l';

COMMENT ON COLUMN bip.batch_proplus_complus.datsitu IS 'Date de valeur de la situation';

COMMENT ON COLUMN bip.batch_proplus_complus.factpid IS 'Code du projet recevant la sous-traitance';

COMMENT ON COLUMN bip.batch_proplus_complus.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.batch_proplus_complus.aist IS 'Type de sous tache';

COMMENT ON COLUMN bip.batch_proplus_complus.aistty IS '2 premiers caracteres de type sous tache';

COMMENT ON COLUMN bip.batch_proplus_complus.tires IS 'Numero de ressource';

COMMENT ON COLUMN bip.batch_proplus_complus.cdeb IS 'Mois annee de reference';

COMMENT ON COLUMN bip.batch_proplus_complus.ptype IS 'Type de projet';

COMMENT ON COLUMN bip.batch_proplus_complus.factpty IS 'Type de projet pour le projet recevant la ss-traitance';

COMMENT ON COLUMN bip.batch_proplus_complus.pnom IS 'Libelle du projet';

COMMENT ON COLUMN bip.batch_proplus_complus.factpno IS 'Libelle du projet pour le projet recevant la';

COMMENT ON COLUMN bip.batch_proplus_complus.pdsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.batch_proplus_complus.factpdsg IS 'Code dpg du projet recevant la ss-traitance';

COMMENT ON COLUMN bip.batch_proplus_complus.pcpi IS 'Code du chef de projet';

COMMENT ON COLUMN bip.batch_proplus_complus.factpcp IS 'Code du chef du projet recevant la ss-traitance';

COMMENT ON COLUMN bip.batch_proplus_complus.pcmouvra IS 'Code du client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.batch_proplus_complus.factpcm IS 'Code du client maîtrise d''ouvrage du projet recevant la';

COMMENT ON COLUMN bip.batch_proplus_complus.pnmouvra IS 'Nom du client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.batch_proplus_complus.pdatdebpre IS 'Date prevue de debut de projet';

COMMENT ON COLUMN bip.batch_proplus_complus.cusag IS 'Consomme du mois';

COMMENT ON COLUMN bip.batch_proplus_complus.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.batch_proplus_complus.rprenom IS 'Prenom de la ressource';

COMMENT ON COLUMN bip.batch_proplus_complus.datdep IS 'Date de depart';

COMMENT ON COLUMN bip.batch_proplus_complus.divsecgrou IS 'Code dpg de la ressource';

COMMENT ON COLUMN bip.batch_proplus_complus.cpident IS 'Code du chef de projet';


DROP TABLE bip.batch_rejetsrp CASCADE CONSTRAINTS;

--
-- BATCH_REJETSRP  (Table) 
--
CREATE TABLE bip.batch_rejetsrp
(
  pid     VARCHAR2(4),
  ecet    VARCHAR(2),
  acta    VARCHAR(2),
  acst    VARCHAR(2),
  ident   VARCHAR(6),
  errmsg  VARCHAR2(128)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.batch_rejetsrp IS 'Liste des Rejets de RPINIT-RPRAF';

COMMENT ON COLUMN bip.batch_rejetsrp.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.batch_rejetsrp.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.batch_rejetsrp.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.batch_rejetsrp.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.batch_rejetsrp.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.batch_rejetsrp.errmsg IS 'Message d''erreur';


DROP TABLE bip.batch_rejet_datestatut CASCADE CONSTRAINTS;

--
-- BATCH_REJET_DATESTATUT  (Table) 
--
CREATE TABLE bip.batch_rejet_datestatut
(
  pid          VARCHAR2(4),
  aist         VARCHAR(6),
  ecet         VARCHAR(2),
  acta         VARCHAR(2),
  acst         VARCHAR(2),
  adeb         DATE,
  afin         DATE,
  ande         DATE,
  anfi         DATE,
  adur         NUMBER(5),
  apcp         NUMBER(3),
  asta         VARCHAR(2),
  asnom        VARCHAR(15),
  tplan        NUMBER(7,2),
  tactu        NUMBER(7,2),
  TEST         NUMBER(7,2),
  astatut      VARCHAR(1),
  adatestatut  DATE,
  cires        VARCHAR(6),
  cusag        NUMBER(8,2),
  cdeb         DATE,
  moismens     DATE,
  sstrait      VARCHAR(1)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.batch_rejet_datestatut IS 'Liste des Consommés PMW en anomalie pour une raison liée à une date invalide';

COMMENT ON COLUMN bip.batch_rejet_datestatut.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.batch_rejet_datestatut.aist IS 'Type de sous tâche';

COMMENT ON COLUMN bip.batch_rejet_datestatut.ecet IS 'Numéro de l''étape';

COMMENT ON COLUMN bip.batch_rejet_datestatut.acta IS 'Numéro de la tâche';

COMMENT ON COLUMN bip.batch_rejet_datestatut.acst IS 'Numéro de la sous tâche';

COMMENT ON COLUMN bip.batch_rejet_datestatut.adeb IS 'Date initiale de début';

COMMENT ON COLUMN bip.batch_rejet_datestatut.afin IS 'Date initiale de fin';

COMMENT ON COLUMN bip.batch_rejet_datestatut.ande IS 'Date revisee de debut';

COMMENT ON COLUMN bip.batch_rejet_datestatut.anfi IS 'Date initiale de fin';

COMMENT ON COLUMN bip.batch_rejet_datestatut.adur IS 'Duree de la sous tache';

COMMENT ON COLUMN bip.batch_rejet_datestatut.apcp IS 'Pourcentage d''avancement de la ss-tache';

COMMENT ON COLUMN bip.batch_rejet_datestatut.asta IS 'Statut de la sous tache';

COMMENT ON COLUMN bip.batch_rejet_datestatut.asnom IS 'Libellé de la sous tâche';

COMMENT ON COLUMN bip.batch_rejet_datestatut.tplan IS 'Charge planifiée pour la ressource';

COMMENT ON COLUMN bip.batch_rejet_datestatut.tactu IS 'Consommation actuelle de la ressource';

COMMENT ON COLUMN bip.batch_rejet_datestatut.TEST IS 'Reste à faire pour la ressource';

COMMENT ON COLUMN bip.batch_rejet_datestatut.astatut IS 'Statut du projet';

COMMENT ON COLUMN bip.batch_rejet_datestatut.adatestatut IS 'Date de statut du projet';

COMMENT ON COLUMN bip.batch_rejet_datestatut.cires IS 'Identifiant ressource';

COMMENT ON COLUMN bip.batch_rejet_datestatut.cusag IS 'Consommé du mois';

COMMENT ON COLUMN bip.batch_rejet_datestatut.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.batch_rejet_datestatut.moismens IS 'Mois de la mensuelle';

COMMENT ON COLUMN bip.batch_rejet_datestatut.sstrait IS 'Sous-traitance (O ou N)';


DROP TABLE bip.batch_tache_bad CASCADE CONSTRAINTS;

--
-- BATCH_TACHE_BAD  (Table) 
--
CREATE TABLE bip.batch_tache_bad
(
  acta     VARCHAR(2),
  acst     VARCHAR(2),
  aistty   VARCHAR(2),
  aistpid  VARCHAR2(4),
  adeb     DATE,
  afin     DATE,
  ande     DATE,
  anfi     DATE,
  adur     NUMBER(5),
  asnom    VARCHAR2(15),
  asta     VARCHAR(2),
  aist     VARCHAR(6),
  pid      VARCHAR2(4),
  ecet     VARCHAR(2),
  apcp     NUMBER(3),
  errmsg   VARCHAR2(128)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.batch_tache_bad IS 'Liste des Taches PMW en anomalie';

COMMENT ON COLUMN bip.batch_tache_bad.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.batch_tache_bad.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.batch_tache_bad.aistty IS '2 premiers caracteres de type sous tache';

COMMENT ON COLUMN bip.batch_tache_bad.aistpid IS 'Code projet client';

COMMENT ON COLUMN bip.batch_tache_bad.adeb IS 'Date initiale de début';

COMMENT ON COLUMN bip.batch_tache_bad.afin IS 'Date initiale de fin';

COMMENT ON COLUMN bip.batch_tache_bad.ande IS 'Date revisee de debut';

COMMENT ON COLUMN bip.batch_tache_bad.anfi IS 'Date revisee de fin';

COMMENT ON COLUMN bip.batch_tache_bad.adur IS 'Duree de la sous tache';

COMMENT ON COLUMN bip.batch_tache_bad.asnom IS 'Libelle de la sous tache';

COMMENT ON COLUMN bip.batch_tache_bad.asta IS 'Statut de la sous tache';

COMMENT ON COLUMN bip.batch_tache_bad.aist IS 'Type de sous tache';

COMMENT ON COLUMN bip.batch_tache_bad.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.batch_tache_bad.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.batch_tache_bad.apcp IS 'Pourcentage d''avancement de la ss-tache';

COMMENT ON COLUMN bip.batch_tache_bad.errmsg IS 'Message d''erreur';


ALTER TABLE bip.bjh_anomalies DROP PRIMARY KEY CASCADE;
DROP TABLE bip.bjh_anomalies CASCADE CONSTRAINTS;

--
-- BJH_ANOMALIES  (Table) 
--
CREATE TABLE bip.bjh_anomalies
(
  matricule    VARCHAR(7)                          NOT NULL,
  mois         NUMBER(2)                        NOT NULL,
  typeabsence  VARCHAR(6)                          NOT NULL,
  coutgip      NUMBER(8,2),
  coutbip      NUMBER(8,2),
  dateano      DATE,
  validation1  VARCHAR2(50),
  validation2  VARCHAR2(50),
  ecartcal     NUMBER(8,2),
  topdv        DATE
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.bjh_anomalies IS 'Liste des anomalies détectées par le traitement bouclage jour hommes';

COMMENT ON COLUMN bip.bjh_anomalies.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.bjh_anomalies.mois IS 'Mois de l''année courante BIP';

COMMENT ON COLUMN bip.bjh_anomalies.typeabsence IS 'Type d''absence BIP';

COMMENT ON COLUMN bip.bjh_anomalies.coutgip IS 'Nombre de jours d''absence selon Gershwin';

COMMENT ON COLUMN bip.bjh_anomalies.coutbip IS 'Nombre de jours d''absence selon l''application BIP';

COMMENT ON COLUMN bip.bjh_anomalies.dateano IS 'Date système du traitement ayant détecté l''anomalie';

COMMENT ON COLUMN bip.bjh_anomalies.validation1 IS 'Première validation';

COMMENT ON COLUMN bip.bjh_anomalies.validation2 IS 'Deuxième validation';

COMMENT ON COLUMN bip.bjh_anomalies.ecartcal IS 'Ecart de calcul ( non utilisé : mis à 0 )';

COMMENT ON COLUMN bip.bjh_anomalies.topdv IS 'Date de dévalidation ';


DROP TABLE bip.bjh_anomalies_temp CASCADE CONSTRAINTS;

--
-- BJH_ANOMALIES_TEMP  (Table) 
--
CREATE TABLE bip.bjh_anomalies_temp
(
  matricule    VARCHAR(7),
  mois         NUMBER(2),
  typeabsence  VARCHAR(6),
  coutbip      NUMBER(8,2),
  coutgip      NUMBER(8,2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.bjh_anomalies_temp IS 'Table temporaire servant à stocker les anomalies détectées par le traitement bouclage jour hommes';

COMMENT ON COLUMN bip.bjh_anomalies_temp.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.bjh_anomalies_temp.mois IS 'Mois de l''année courante BIP';

COMMENT ON COLUMN bip.bjh_anomalies_temp.typeabsence IS 'Type d''absence BIP';

COMMENT ON COLUMN bip.bjh_anomalies_temp.coutbip IS 'Nombre de jours d''absence selon l''application BIP';

COMMENT ON COLUMN bip.bjh_anomalies_temp.coutgip IS 'Nombre de jours d''absence selon Gershwin';


DROP TABLE bip.bjh_extbip CASCADE CONSTRAINTS;

--
-- BJH_EXTBIP  (Table) 
--
CREATE TABLE bip.bjh_extbip
(
  matricule  VARCHAR(7),
  mois       NUMBER(2),
  typsst     VARCHAR(6),
  cusag      NUMBER(8,2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.bjh_extbip IS 'Contient l''ensemble des consommés des ressources de la BIP. Utilisation par le traitement bouclage jour hommes';

COMMENT ON COLUMN bip.bjh_extbip.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.bjh_extbip.mois IS 'Mois de l''année courante BIP';

COMMENT ON COLUMN bip.bjh_extbip.typsst IS 'Type de sous-tâche';

COMMENT ON COLUMN bip.bjh_extbip.cusag IS 'Consomme du mois';


DROP TABLE bip.bjh_extgip CASCADE CONSTRAINTS;

--
-- BJH_EXTGIP  (Table) 
--
CREATE TABLE bip.bjh_extgip
(
  matricule  VARCHAR(7),
  gipnom     VARCHAR2(32),
  gipprenom  VARCHAR2(32),
  codemp     NUMBER(4),
  gipca      NUMBER(6),
  tempart    NUMBER(3),
  mois       NUMBER(2),
  motifabs   VARCHAR2(6),
  nbjour     VARCHAR(3),
  intjour    NUMBER(3,1),
  bipabs     VARCHAR(6)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.bjh_extgip IS 'Contient les consommés des absences des ressources transmis par Gershwin. Utilisation par le traitement bouclage jour hommes';

COMMENT ON COLUMN bip.bjh_extgip.gipca IS 'Code de centre d''activité';

COMMENT ON COLUMN bip.bjh_extgip.tempart IS 'Pourcentage de temps de travail';

COMMENT ON COLUMN bip.bjh_extgip.mois IS 'Mois de l''année courante BIP';

COMMENT ON COLUMN bip.bjh_extgip.motifabs IS 'Code du type d''absence';

COMMENT ON COLUMN bip.bjh_extgip.nbjour IS 'Nombre de jours';

COMMENT ON COLUMN bip.bjh_extgip.intjour IS 'Nombre de jours de l''absence';

COMMENT ON COLUMN bip.bjh_extgip.bipabs IS 'Traduction du motif d''absence';

COMMENT ON COLUMN bip.bjh_extgip.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.bjh_extgip.gipnom IS 'Nom de la ressource (Gershwin)';

COMMENT ON COLUMN bip.bjh_extgip.gipprenom IS 'Prénom de la ressource (Gershwin)';

COMMENT ON COLUMN bip.bjh_extgip.codemp IS 'Champ inutile';


DROP TABLE bip.bjh_ressource CASCADE CONSTRAINTS;

--
-- BJH_RESSOURCE  (Table) 
--
CREATE TABLE bip.bjh_ressource
(
  matricule    VARCHAR(7),
  mois         NUMBER(2),
  conso_total  NUMBER(8,2),
  conso_conge  NUMBER(8,2),
  conso_autre  NUMBER(8,2),
  codsg        NUMBER(7),
  nom          VARCHAR2(30),
  prenom       VARCHAR2(30),
  dep          VARCHAR(3),
  pole         VARCHAR(3),
  ident        NUMBER(5),
  tempart      NUMBER(3),
  activite     NUMBER(5)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.bjh_ressource IS 'Contient les informations sur les ressources de la BIP. Utilisation par le traitement bouclage jour hommes';

COMMENT ON COLUMN bip.bjh_ressource.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.bjh_ressource.mois IS 'Mois de l''année courante BIP';

COMMENT ON COLUMN bip.bjh_ressource.conso_total IS 'Consommé total';

COMMENT ON COLUMN bip.bjh_ressource.conso_conge IS 'Consommé jours de congés';

COMMENT ON COLUMN bip.bjh_ressource.conso_autre IS 'Autres consommés';

COMMENT ON COLUMN bip.bjh_ressource.codsg IS 'Code Département/Pôle/Groupe';

COMMENT ON COLUMN bip.bjh_ressource.nom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.bjh_ressource.prenom IS 'Prénom de la ressource';

COMMENT ON COLUMN bip.bjh_ressource.dep IS 'Département ';

COMMENT ON COLUMN bip.bjh_ressource.pole IS 'Pôle';

COMMENT ON COLUMN bip.bjh_ressource.ident IS 'Identifiant de la ressource';

COMMENT ON COLUMN bip.bjh_ressource.tempart IS 'Pourcentage de temps de travail';

COMMENT ON COLUMN bip.bjh_ressource.activite IS 'Centre d''activité';


DROP TABLE bip.bjh_type_absence CASCADE CONSTRAINTS;

--
-- BJH_TYPE_ABSENCE  (Table) 
--
CREATE TABLE bip.bjh_type_absence
(
  bipabs  VARCHAR2(6),
  gipabs  VARCHAR2(6)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.bjh_type_absence IS 'Fait le lien entre les types d''absences de Gershwin et ceux de la BIP. Utilisation par le traitement bouclage jour hommes';

COMMENT ON COLUMN bip.bjh_type_absence.bipabs IS 'Type d''absence BIP';

COMMENT ON COLUMN bip.bjh_type_absence.gipabs IS 'Type d''absence Gershwin';


ALTER TABLE bip.branches DROP PRIMARY KEY CASCADE;
DROP TABLE bip.branches CASCADE CONSTRAINTS;

--
-- BRANCHES  (Table) 
--
CREATE TABLE bip.branches
(
  codbr     NUMBER(2)                           NOT NULL,
  libbr     VARCHAR2(30),
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.branches IS 'Branches de la Société Générale. Une branche regroupe plusieurs directions';

COMMENT ON COLUMN bip.branches.codbr IS 'Code de la branche';

COMMENT ON COLUMN bip.branches.libbr IS 'Libellé de la branche';

COMMENT ON COLUMN bip.branches.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.budget DROP PRIMARY KEY CASCADE;
DROP TABLE bip.budget CASCADE CONSTRAINTS;

--
-- BUDGET  (Table) 
--
CREATE TABLE bip.budget
(
  annee      NUMBER(4)                          NOT NULL,
  pid        VARCHAR2(4)                        NOT NULL,
  bnmont     NUMBER(12,2),
  bpmontme   NUMBER(12,2),
  bpmontme2  NUMBER(12,2),
  anmont     NUMBER(12,2),
  bpdate     DATE,
  reserve    NUMBER(12,2),
  apdate     DATE,
  apmont     NUMBER(12,2),
  bpmontmo   NUMBER(12,2),
  reestime   NUMBER(12,2),
  flaglock   NUMBER(7)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.budget IS 'Budgets des lignes BIP';

COMMENT ON COLUMN bip.budget.annee IS 'Année du budget';

COMMENT ON COLUMN bip.budget.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.budget.bnmont IS 'Budget notifié';

COMMENT ON COLUMN bip.budget.bpmontme IS 'Budget proposé fournisseur';

COMMENT ON COLUMN bip.budget.bpmontme2 IS 'budget proposé ME priorité 2 (plus utilisé)';

COMMENT ON COLUMN bip.budget.anmont IS 'Budget arbitré notifié';

COMMENT ON COLUMN bip.budget.bpdate IS 'Date du budget proposé';

COMMENT ON COLUMN bip.budget.reserve IS 'Budget réserve (plus utilisé)';

COMMENT ON COLUMN bip.budget.apdate IS 'Date du budget arbitré';

COMMENT ON COLUMN bip.budget.apmont IS 'Budget arbitré proposé (plus utilisé)';

COMMENT ON COLUMN bip.budget.bpmontmo IS 'Budget proposé client';

COMMENT ON COLUMN bip.budget.reestime IS 'Budget réestimé';

COMMENT ON COLUMN bip.budget.flaglock IS 'N° de version';


ALTER TABLE bip.budget_dp DROP PRIMARY KEY CASCADE;
DROP TABLE bip.budget_dp CASCADE CONSTRAINTS;

--
-- BUDGET_DP  (Table) 
--
CREATE TABLE bip.budget_dp
(
  annee      NUMBER(4)                          NOT NULL,
  dpcode     NUMBER(5)                          NOT NULL,
  clicode    VARCHAR(5)                            NOT NULL,
  budgethtr  NUMBER(10,2)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.budget_dp IS 'Budget des dossiers projets';

COMMENT ON COLUMN bip.budget_dp.annee IS 'Année de référence';

COMMENT ON COLUMN bip.budget_dp.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.budget_dp.clicode IS 'Code client maîtrise d''ouvrage (On aura à ce niveau uniquement des clients de niveau département)';

COMMENT ON COLUMN bip.budget_dp.budgethtr IS 'Budget alloué au dossier projet pour ce dépatement en K Euros';


ALTER TABLE bip.calendrier DROP PRIMARY KEY CASCADE;
DROP TABLE bip.calendrier CASCADE CONSTRAINTS;

--
-- CALENDRIER  (Table) 
--
CREATE TABLE bip.calendrier
(
  calanmois        DATE                         NOT NULL,
  ccloture         DATE,
  cafin            DATE,
  cpremens2        DATE,
  cmensuelle       DATE,
  cjours           NUMBER(3,1),
  cpremens1        DATE,
  flaglock         NUMBER(7)                    DEFAULT 0                     NOT NULL,
  nb_travail_sg    NUMBER(3,1),
  nb_travail_ssii  NUMBER(3,1),
  theorique        NUMBER(5,2)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.calendrier IS 'Calendrier des traitements.';

COMMENT ON COLUMN bip.calendrier.theorique IS 'Pourcentage théorique du mois';

COMMENT ON COLUMN bip.calendrier.calanmois IS 'Mois a traiter en mois annee';

COMMENT ON COLUMN bip.calendrier.ccloture IS 'Date cloture';

COMMENT ON COLUMN bip.calendrier.cafin IS 'Dernier jour calendaire du mois';

COMMENT ON COLUMN bip.calendrier.cpremens2 IS 'Date de la premensuelle 2';

COMMENT ON COLUMN bip.calendrier.cmensuelle IS 'Date de la prochaine mensuelle';

COMMENT ON COLUMN bip.calendrier.cjours IS 'Nombre de jours ouvres du mois';

COMMENT ON COLUMN bip.calendrier.cpremens1 IS 'Date de la 1 premensuelle';

COMMENT ON COLUMN bip.calendrier.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.calendrier.nb_travail_sg IS 'Nombre de jours de travail moyen par an pour une ressource SG';

COMMENT ON COLUMN bip.calendrier.nb_travail_ssii IS 'Nombre de jours de travail moyen par an pour une ressource SSII';


ALTER TABLE bip.centre_activite DROP PRIMARY KEY CASCADE;
DROP TABLE bip.centre_activite CASCADE CONSTRAINTS;

--
-- CENTRE_ACTIVITE  (Table) 
--
CREATE TABLE bip.centre_activite
(
  codcamo    NUMBER(6)                          NOT NULL,
  clibrca    VARCHAR(16),
  ctopamo    VARCHAR(1),
  clibca     VARCHAR2(30),
  cdateouve  DATE,
  cdateferm  DATE,
  codnivca   NUMBER(1),
  caniv1     NUMBER(6),
  caniv2     NUMBER(6),
  caniv3     NUMBER(6),
  caniv4     NUMBER(6),
  flaglock   NUMBER(7)                          DEFAULT 0                     NOT NULL,
  ctopact    VARCHAR(1),
  filcode    VARCHAR(3)                            DEFAULT '01'                  NOT NULL,
  cdfain     NUMBER(1)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.centre_activite IS 'Table des centres d''actvite maîtrise d''ouvrage';

COMMENT ON COLUMN bip.centre_activite.codcamo IS 'Code centre d''activite maîtrise d''ouvrage';

COMMENT ON COLUMN bip.centre_activite.clibrca IS 'Libelle reduit';

COMMENT ON COLUMN bip.centre_activite.ctopamo IS 'Top Mise à Jour manuelle ou automatique';

COMMENT ON COLUMN bip.centre_activite.clibca IS 'Libelle du centre d''activite';

COMMENT ON COLUMN bip.centre_activite.cdateouve IS 'Date d''ouverture';

COMMENT ON COLUMN bip.centre_activite.cdateferm IS 'Date de fermeture';

COMMENT ON COLUMN bip.centre_activite.codnivca IS 'Code niveau centre d''activite mo';

COMMENT ON COLUMN bip.centre_activite.caniv1 IS 'Code niv1 pole';

COMMENT ON COLUMN bip.centre_activite.caniv2 IS 'Code niv2 division';

COMMENT ON COLUMN bip.centre_activite.caniv3 IS 'Niv 3 departement';

COMMENT ON COLUMN bip.centre_activite.caniv4 IS 'Niv 4 direction';

COMMENT ON COLUMN bip.centre_activite.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.centre_activite.ctopact IS 'Type d''amortissement, correspond a un top fact interne:';

COMMENT ON COLUMN bip.centre_activite.filcode IS 'Code de la filiale';

COMMENT ON COLUMN bip.centre_activite.cdfain IS 'Code Facturation - Indique si le CA est facturable';


ALTER TABLE bip.centre_frais DROP PRIMARY KEY CASCADE;
DROP TABLE bip.centre_frais CASCADE CONSTRAINTS;

--
-- CENTRE_FRAIS  (Table) 
--
CREATE TABLE bip.centre_frais
(
  codcfrais  NUMBER(3)                          NOT NULL,
  libcfrais  VARCHAR2(30),
  filcode    VARCHAR(3)                            DEFAULT '01 '
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.centre_frais IS 'Table des centres de frais';

COMMENT ON COLUMN bip.centre_frais.codcfrais IS 'Code du centre de frais';

COMMENT ON COLUMN bip.centre_frais.libcfrais IS 'Libellé du centre de frais';

COMMENT ON COLUMN bip.centre_frais.filcode IS 'Code de la filiale';


DROP TABLE bip.charge_camo CASCADE CONSTRAINTS;

--
-- CHARGE_CAMO  (Table) 
--
CREATE TABLE bip.charge_camo
(
  xcodcamo    VARCHAR(10),
  xclibrca    VARCHAR2(24),
  xclibca     VARCHAR2(35),
  xcdateouve  DATE,
  xcdateferm  DATE,
  xcodniv     NUMBER(3),
  xcaniv1     VARCHAR(10),
  xcaniv2     VARCHAR(10),
  xcaniv3     VARCHAR(10),
  xcaniv4     VARCHAR(10),
  xcdfain     NUMBER(1)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.charge_camo IS 'Table de chargement des centres d''activité. Chargée par Sql Loader';

COMMENT ON COLUMN bip.charge_camo.xcodcamo IS 'Code centre d''activite maîtrise d''ouvrage';

COMMENT ON COLUMN bip.charge_camo.xclibrca IS 'Libelle reduit';

COMMENT ON COLUMN bip.charge_camo.xclibca IS 'Libelle du centre d''activite';

COMMENT ON COLUMN bip.charge_camo.xcdateouve IS 'Date d''ouverture';

COMMENT ON COLUMN bip.charge_camo.xcdateferm IS 'Date de fermeture';

COMMENT ON COLUMN bip.charge_camo.xcodniv IS 'Code niveau centre d''activite mo';

COMMENT ON COLUMN bip.charge_camo.xcaniv1 IS 'Code niv1 pole';

COMMENT ON COLUMN bip.charge_camo.xcaniv2 IS 'Code niv2 division';

COMMENT ON COLUMN bip.charge_camo.xcaniv3 IS 'Niv 3 departement';

COMMENT ON COLUMN bip.charge_camo.xcaniv4 IS 'Niv 4 direction';

COMMENT ON COLUMN bip.charge_camo.xcdfain IS 'Code Facturation - Indique si le CA est facturable';


DROP TABLE bip.charge_es CASCADE CONSTRAINTS;

--
-- CHARGE_ES  (Table) 
--
CREATE TABLE bip.charge_es
(
  codcamo  VARCHAR(5),
  cdtyes   VARCHAR(3),
  liloes   VARCHAR(30),
  licoes   VARCHAR(30),
  idelst   VARCHAR(5)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.charge_es IS 'Table de chargement des éléments de structure. Chargée par Sql Loader';

COMMENT ON COLUMN bip.charge_es.codcamo IS 'Code du centre d''activité (entité de structure)';

COMMENT ON COLUMN bip.charge_es.cdtyes IS 'Type de l''entité de structure (équivaut au niveau)';

COMMENT ON COLUMN bip.charge_es.liloes IS 'Libellé long';

COMMENT ON COLUMN bip.charge_es.licoes IS 'Libellé court';

COMMENT ON COLUMN bip.charge_es.idelst IS 'Code banque (30003)';


DROP TABLE bip.charge_es_err CASCADE CONSTRAINTS;

--
-- CHARGE_ES_ERR  (Table) 
--
CREATE TABLE bip.charge_es_err
(
  idelst   VARCHAR2(5),
  codcamo  VARCHAR2(5),
  cdtyes   VARCHAR(3),
  liloes   VARCHAR2(24),
  licoes   VARCHAR2(35)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.charge_es_err IS 'Table contenant des rejets de chargement des éléments de structure';

COMMENT ON COLUMN bip.charge_es_err.idelst IS 'Code banque (30003)';

COMMENT ON COLUMN bip.charge_es_err.codcamo IS 'Code du centre d''activité (entité de structure)';

COMMENT ON COLUMN bip.charge_es_err.cdtyes IS 'Type de l''entité de structure (équivaut au niveau)';

COMMENT ON COLUMN bip.charge_es_err.liloes IS 'Libellé long';

COMMENT ON COLUMN bip.charge_es_err.licoes IS 'Libellé court';


ALTER TABLE bip.client_mo DROP PRIMARY KEY CASCADE;
DROP TABLE bip.client_mo CASCADE CONSTRAINTS;

--
-- CLIENT_MO  (Table) 
--
CREATE TABLE bip.client_mo
(
  clicode    VARCHAR(5)                            NOT NULL,
  clisigle   VARCHAR(8)                            NOT NULL,
  clilib     VARCHAR2(25)                       NOT NULL,
  clitopf    VARCHAR(1)                            NOT NULL,
  flaglock   NUMBER(7)                          DEFAULT 0                     NOT NULL,
  filcode    VARCHAR(3)                            NOT NULL,
  clidir     NUMBER(2),
  top_oscar  VARCHAR(2),
  clidep     NUMBER(3),
  clipol     NUMBER(2),
  codcamo    NUMBER(6)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.client_mo IS 'Table des clients maîtrise d''ouvrage';

COMMENT ON COLUMN bip.client_mo.clicode IS 'Code client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.client_mo.clidep IS 'Code du département';

COMMENT ON COLUMN bip.client_mo.clisigle IS 'Sigle direction/departement (domaine/dept)';

COMMENT ON COLUMN bip.client_mo.clilib IS 'Libelle du client';

COMMENT ON COLUMN bip.client_mo.clitopf IS 'Top fermeture';

COMMENT ON COLUMN bip.client_mo.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.client_mo.filcode IS 'Code de la filiale';

COMMENT ON COLUMN bip.client_mo.clidir IS 'Numéro de la direction';

COMMENT ON COLUMN bip.client_mo.top_oscar IS 'Indique si le client utilise l''application OSCAR';

COMMENT ON COLUMN bip.client_mo.clipol IS 'Code du pôle';

COMMENT ON COLUMN bip.client_mo.codcamo IS 'Code du centre d''activité du Client , Ce n''est pas forcément un CA de niveau 0, cela peut être un CA de niveau 1,2 3 ou 4';


ALTER TABLE bip.code_compt DROP PRIMARY KEY CASCADE;
DROP TABLE bip.code_compt CASCADE CONSTRAINTS;

--
-- CODE_COMPT  (Table) 
--
CREATE TABLE bip.code_compt
(
  comcode   VARCHAR2(11)                        NOT NULL,
  comlib    VARCHAR(25)                            NOT NULL,
  comtyp    VARCHAR(1)                             NOT NULL,
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.code_compt IS 'Tables des Codes comptables.';

COMMENT ON COLUMN bip.code_compt.comcode IS 'Num code comptable';

COMMENT ON COLUMN bip.code_compt.comlib IS 'Libelle du code comptable';

COMMENT ON COLUMN bip.code_compt.comtyp IS 'Type code comptable j/h (o n)';

COMMENT ON COLUMN bip.code_compt.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.code_statut DROP PRIMARY KEY CASCADE;
DROP TABLE bip.code_statut CASCADE CONSTRAINTS;

--
-- CODE_STATUT  (Table) 
--
CREATE TABLE bip.code_statut
(
  astatut    VARCHAR(1)                            NOT NULL,
  libstatut  VARCHAR(30)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.code_statut IS 'Table des statuts des ligne bip';

COMMENT ON COLUMN bip.code_statut.astatut IS 'Statut du projet';

COMMENT ON COLUMN bip.code_statut.libstatut IS 'Libelle d''un statut';


ALTER TABLE bip.compo_centre_frais DROP PRIMARY KEY CASCADE;
DROP TABLE bip.compo_centre_frais CASCADE CONSTRAINTS;

--
-- COMPO_CENTRE_FRAIS  (Table) 
--
CREATE TABLE bip.compo_centre_frais
(
  codcfrais  NUMBER(3)                          NOT NULL,
  codbddpg   VARCHAR2(11)                       NOT NULL,
  topfer     VARCHAR(1)                            NOT NULL,
  codhabili  VARCHAR2(15),
  libbddpg   VARCHAR2(30)
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.compo_centre_frais IS 'Table faisant le lien entre un centre de frais et les DPG qui le composent';

COMMENT ON COLUMN bip.compo_centre_frais.codcfrais IS 'Code du centre de frais';

COMMENT ON COLUMN bip.compo_centre_frais.codbddpg IS 'Périmètre d''un ensemble de DPG exprimé en (Branche,Direction,Departement,Pole,Groupe)';

COMMENT ON COLUMN bip.compo_centre_frais.topfer IS 'Top fermeture';

COMMENT ON COLUMN bip.compo_centre_frais.codhabili IS 'Indique si cet ensemble de DPG est une Branche,Direction,Departement,Pole ou Groupe';

COMMENT ON COLUMN bip.compo_centre_frais.libbddpg IS 'Libellé de cet ensemble de DPG';


ALTER TABLE bip.compte DROP PRIMARY KEY CASCADE;
DROP TABLE bip.compte CASCADE CONSTRAINTS;

--
-- COMPTE  (Table) 
--
CREATE TABLE bip.compte
(
  codcompte  NUMBER(10)                         NOT NULL,
  libcompte  VARCHAR2(50)                       NOT NULL,
  TYPE       VARCHAR(1)                            NOT NULL,
  flaglock   NUMBER(7)                          DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.compte IS 'Les comptes à créditer et à debiter';

COMMENT ON COLUMN bip.compte.codcompte IS 'Numero du compte';

COMMENT ON COLUMN bip.compte.libcompte IS 'Libellé du compte';

COMMENT ON COLUMN bip.compte.TYPE IS 'Le type du compte à créditer (C) ou à debiter (D)';

COMMENT ON COLUMN bip.compte.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.consomme DROP PRIMARY KEY CASCADE;
DROP TABLE bip.consomme CASCADE CONSTRAINTS;

--
-- CONSOMME  (Table) 
--
CREATE TABLE bip.consomme
(
  annee   NUMBER(4)                             NOT NULL,
  pid     VARCHAR2(4)                           NOT NULL,
  cusag   NUMBER(12,2),
  xcusag  NUMBER(12,2)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.consomme IS 'Cumul du consommé par ligne BIP';

COMMENT ON COLUMN bip.consomme.annee IS 'Année du consommé';

COMMENT ON COLUMN bip.consomme.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.consomme.cusag IS 'Consommé total de l''année';

COMMENT ON COLUMN bip.consomme.xcusag IS 'Cumul du consommé depuis le début jusqu''à l''année';


ALTER TABLE bip.cons_sstache_res DROP PRIMARY KEY CASCADE;
DROP TABLE bip.cons_sstache_res CASCADE CONSTRAINTS;

--
-- CONS_SSTACHE_RES  (Table) 
--
CREATE TABLE bip.cons_sstache_res
(
  tplan  NUMBER(7,2),
  tactu  NUMBER(7,2),
  TEST   NUMBER(7,2),
  pid    VARCHAR2(4)                            NOT NULL,
  ecet   VARCHAR(2)                                NOT NULL,
  acta   VARCHAR(2)                                NOT NULL,
  acst   VARCHAR(2)                                NOT NULL,
  ident  NUMBER(5)                              NOT NULL
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.cons_sstache_res IS 'Consommation d''une ressource pour une sous tache.';

COMMENT ON COLUMN bip.cons_sstache_res.tplan IS 'Charge planifiee pour la ressource';

COMMENT ON COLUMN bip.cons_sstache_res.tactu IS 'Consommation actuelle de la ressource';

COMMENT ON COLUMN bip.cons_sstache_res.TEST IS 'Reste a faire pour la ressource';

COMMENT ON COLUMN bip.cons_sstache_res.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.cons_sstache_res.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.cons_sstache_res.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.cons_sstache_res.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.cons_sstache_res.ident IS 'Identifiant ressource';


ALTER TABLE bip.cons_sstache_res_back DROP PRIMARY KEY CASCADE;
DROP TABLE bip.cons_sstache_res_back CASCADE CONSTRAINTS;

--
-- CONS_SSTACHE_RES_BACK  (Table) 
--
CREATE TABLE bip.cons_sstache_res_back
(
  tplan  NUMBER(7,2),
  tactu  NUMBER(7,2),
  TEST   NUMBER(7,2),
  pid    VARCHAR2(4)                            NOT NULL,
  ecet   VARCHAR(2)                                NOT NULL,
  acta   VARCHAR(2)                                NOT NULL,
  acst   VARCHAR(2)                                NOT NULL,
  ident  NUMBER(5)                              NOT NULL
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.cons_sstache_res_back IS 'Sauvegarde de la table CONS_SSTACHE_RES utilisée dans le traitement mensuel';

COMMENT ON COLUMN bip.cons_sstache_res_back.tplan IS 'Charge planifiee pour la ressource';

COMMENT ON COLUMN bip.cons_sstache_res_back.tactu IS 'Consommation actuelle de la ressource';

COMMENT ON COLUMN bip.cons_sstache_res_back.TEST IS 'Reste a faire pour la ressource';

COMMENT ON COLUMN bip.cons_sstache_res_back.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.cons_sstache_res_back.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.cons_sstache_res_back.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.cons_sstache_res_back.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.cons_sstache_res_back.ident IS 'Identifiant ressource';


ALTER TABLE bip.cons_sstache_res_mois DROP PRIMARY KEY CASCADE;
DROP TABLE bip.cons_sstache_res_mois CASCADE CONSTRAINTS;

--
-- CONS_SSTACHE_RES_MOIS  (Table) 
--
CREATE TABLE bip.cons_sstache_res_mois
(
  cdeb    DATE                                  NOT NULL,
  cdur    NUMBER(8),
  cusag   NUMBER(7,2),
  chraf   NUMBER(7,2),
  chinit  NUMBER(7,2),
  pid     VARCHAR2(4)                           NOT NULL,
  ecet    VARCHAR(2)                               NOT NULL,
  acta    VARCHAR(2)                               NOT NULL,
  acst    VARCHAR(2)                               NOT NULL,
  ident   NUMBER(5)                             NOT NULL
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.cons_sstache_res_mois IS 'Consommation d''une ressource pour une sous tache pour un mois.';

COMMENT ON COLUMN bip.cons_sstache_res_mois.cdeb IS 'Mois annee de reference';

COMMENT ON COLUMN bip.cons_sstache_res_mois.cdur IS 'Nombre de jours ouvres du mois (inutilisé)';

COMMENT ON COLUMN bip.cons_sstache_res_mois.cusag IS 'Consomme du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois.chraf IS 'Reste a faire du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois.chinit IS 'Charge initiale du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.cons_sstache_res_mois.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.cons_sstache_res_mois.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.cons_sstache_res_mois.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.cons_sstache_res_mois.ident IS 'Identifiant ressource';


ALTER TABLE bip.cons_sstache_res_mois_archive DROP PRIMARY KEY CASCADE;
DROP TABLE bip.cons_sstache_res_mois_archive CASCADE CONSTRAINTS;

--
-- CONS_SSTACHE_RES_MOIS_ARCHIVE  (Table) 
--
CREATE TABLE bip.cons_sstache_res_mois_archive
(
  cdeb    DATE                                  NOT NULL,
  cdur    NUMBER(8),
  cusag   NUMBER(7,2),
  chraf   NUMBER(7,2),
  chinit  NUMBER(7,2),
  pid     VARCHAR2(4)                           NOT NULL,
  ecet    VARCHAR(2)                               NOT NULL,
  acta    VARCHAR(2)                               NOT NULL,
  acst    VARCHAR(2)                               NOT NULL,
  ident   NUMBER(5)                             NOT NULL,
  aist    VARCHAR(6),
  asnom   VARCHAR(15)
)
TABLESPACE tbs_bip_his_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.cons_sstache_res_mois_archive IS 'Archivage de la table CONS_SSTACHE_RES_MOIS utilisée dans la cloture : contient des données des trois dernières années';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.cdeb IS 'Mois annee de reference';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.cdur IS 'Nombre de jours ouvres du mois (inutilisé)';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.cusag IS 'Consomme du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.chraf IS 'Reste a faire du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.chinit IS 'Charge initiale du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.aist IS 'Type de la sous-tâche';

COMMENT ON COLUMN bip.cons_sstache_res_mois_archive.asnom IS 'Nom de la sous-tâche';


ALTER TABLE bip.cons_sstache_res_mois_back DROP PRIMARY KEY CASCADE;
DROP TABLE bip.cons_sstache_res_mois_back CASCADE CONSTRAINTS;

--
-- CONS_SSTACHE_RES_MOIS_BACK  (Table) 
--
CREATE TABLE bip.cons_sstache_res_mois_back
(
  cdeb    DATE                                  NOT NULL,
  cdur    NUMBER(8),
  cusag   NUMBER(7,2),
  chraf   NUMBER(7,2),
  chinit  NUMBER(7,2),
  pid     VARCHAR2(4)                           NOT NULL,
  ecet    VARCHAR(2)                               NOT NULL,
  acta    VARCHAR(2)                               NOT NULL,
  acst    VARCHAR(2)                               NOT NULL,
  ident   NUMBER(5)                             NOT NULL
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.cons_sstache_res_mois_back IS 'Sauvegarde : Consommation d''une ressource pour une sous tache pour un mois.';

COMMENT ON COLUMN bip.cons_sstache_res_mois_back.cdeb IS 'Mois annee de reference';

COMMENT ON COLUMN bip.cons_sstache_res_mois_back.cdur IS 'Nombre de jours ouvres du mois (inutilisé)';

COMMENT ON COLUMN bip.cons_sstache_res_mois_back.cusag IS 'Consomme du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois_back.chraf IS 'Reste a faire du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois_back.chinit IS 'Charge initiale du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois_back.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.cons_sstache_res_mois_back.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.cons_sstache_res_mois_back.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.cons_sstache_res_mois_back.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.cons_sstache_res_mois_back.ident IS 'Identifiant ressource';


DROP TABLE bip.cons_sstache_res_mois_rejet CASCADE CONSTRAINTS;

--
-- CONS_SSTACHE_RES_MOIS_REJET  (Table) 
--
CREATE TABLE bip.cons_sstache_res_mois_rejet
(
  cdeb         DATE                             NOT NULL,
  cdur         NUMBER(8),
  cusag        NUMBER(7,2),
  chraf        NUMBER(7,2),
  chinit       NUMBER(7,2),
  pid          VARCHAR2(4)                      NOT NULL,
  ecet         VARCHAR(2)                          NOT NULL,
  acta         VARCHAR(2)                          NOT NULL,
  acst         VARCHAR(2)                          NOT NULL,
  ident        NUMBER(5)                        NOT NULL,
  motif_rejet  VARCHAR(1)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.cons_sstache_res_mois_rejet IS 'Table des données rejetées de CONS_SSTACHE_RES_MOIS pour les raisons : date future , ressource inconnue, ligne bip inexistante ...';

COMMENT ON COLUMN bip.cons_sstache_res_mois_rejet.cdeb IS 'Mois annee de reference';

COMMENT ON COLUMN bip.cons_sstache_res_mois_rejet.cdur IS 'Nombre de jours ouvres du mois (inutilisé)';

COMMENT ON COLUMN bip.cons_sstache_res_mois_rejet.cusag IS 'Consomme du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois_rejet.chraf IS 'Reste a faire du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois_rejet.chinit IS 'Charge initiale du mois';

COMMENT ON COLUMN bip.cons_sstache_res_mois_rejet.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.cons_sstache_res_mois_rejet.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.cons_sstache_res_mois_rejet.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.cons_sstache_res_mois_rejet.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.cons_sstache_res_mois_rejet.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.cons_sstache_res_mois_rejet.motif_rejet IS 'Motif du rejet : A: Date future , L : Ligne BIP inconnue , R: Ressource inconnue ...';


ALTER TABLE bip.cons_sstres_m_rejet_datestatut DROP PRIMARY KEY CASCADE;
DROP TABLE bip.cons_sstres_m_rejet_datestatut CASCADE CONSTRAINTS;

--
-- CONS_SSTRES_M_REJET_DATESTATUT  (Table) 
--
CREATE TABLE bip.cons_sstres_m_rejet_datestatut
(
  cdeb      DATE                                NOT NULL,
  cdur      NUMBER(8),
  cusag     NUMBER(7,2),
  chraf     NUMBER(7,2),
  chinit    NUMBER(7,2),
  pid       VARCHAR2(4)                         NOT NULL,
  ecet      VARCHAR(2)                             NOT NULL,
  acta      VARCHAR(2)                             NOT NULL,
  acst      VARCHAR(2)                             NOT NULL,
  ident     NUMBER(5)                           NOT NULL,
  ecet_new  VARCHAR2(2),
  acta_new  VARCHAR2(2),
  acst_new  VARCHAR2(2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.cons_sstres_m_rejet_datestatut IS 'Table utilisée dans le traitement mensuel pour renommer les numéros d''étape, de tâche et de sous-tâche de CONS_SSTACHE_RES_MOIS pour conserver les données saisies auparavant sur des tâches en sous-traitance sur des lignes BIP fermées';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.cdeb IS 'Mois annee de reference';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.cdur IS 'Nombre de jours ouvres du mois (inutilisé)';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.cusag IS 'Consomme du mois';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.chraf IS 'Reste a faire du mois';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.chinit IS 'Charge initiale du mois';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.ecet_new IS 'Nouveau numero de l''etape';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.acta_new IS 'Nouveau numero de la tache';

COMMENT ON COLUMN bip.cons_sstres_m_rejet_datestatut.acst_new IS 'Nouveau numero de sous tache';


ALTER TABLE bip.cons_sstres_rejet_datestatut DROP PRIMARY KEY CASCADE;
DROP TABLE bip.cons_sstres_rejet_datestatut CASCADE CONSTRAINTS;

--
-- CONS_SSTRES_REJET_DATESTATUT  (Table) 
--
CREATE TABLE bip.cons_sstres_rejet_datestatut
(
  tplan     NUMBER(7,2),
  tactu     NUMBER(7,2),
  TEST      NUMBER(7,2),
  pid       VARCHAR2(4)                         NOT NULL,
  ecet      VARCHAR(2)                             NOT NULL,
  acta      VARCHAR(2)                             NOT NULL,
  acst      VARCHAR(2)                             NOT NULL,
  ident     NUMBER(5)                           NOT NULL,
  ecet_new  VARCHAR2(2),
  acta_new  VARCHAR2(2),
  acst_new  VARCHAR2(2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.cons_sstres_rejet_datestatut IS 'Table utilisée dans le traitement mensuel pour renommer les numéros d''étape, de tâche et de sous-tâche de CONS_SSTACHE_RES pour conserver les données saisies auparavant sur des tâches en sous-traitance sur des lignes BIP fermées';

COMMENT ON COLUMN bip.cons_sstres_rejet_datestatut.acta_new IS 'Nouveau numero de la tache';

COMMENT ON COLUMN bip.cons_sstres_rejet_datestatut.acst_new IS 'Nouveau numero de sous tache';

COMMENT ON COLUMN bip.cons_sstres_rejet_datestatut.tplan IS 'Charge planifiee pour la ressource';

COMMENT ON COLUMN bip.cons_sstres_rejet_datestatut.tactu IS 'Consommation actuelle de la ressource';

COMMENT ON COLUMN bip.cons_sstres_rejet_datestatut.TEST IS 'Reste a faire pour la ressource';

COMMENT ON COLUMN bip.cons_sstres_rejet_datestatut.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.cons_sstres_rejet_datestatut.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.cons_sstres_rejet_datestatut.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.cons_sstres_rejet_datestatut.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.cons_sstres_rejet_datestatut.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.cons_sstres_rejet_datestatut.ecet_new IS 'Nouveau numero de l''etape';


ALTER TABLE bip.contrat DROP PRIMARY KEY CASCADE;
DROP TABLE bip.contrat CASCADE CONSTRAINTS;

--
-- CONTRAT  (Table) 
--
CREATE TABLE bip.contrat
(
  numcont       VARCHAR(15)                        NOT NULL,
  cchtsoc       VARCHAR(1),
  ctypfact      VARCHAR(1)                         NOT NULL,
  cobjet1       VARCHAR2(50)                    NOT NULL,
  cobjet2       VARCHAR2(50),
  cobjet3       VARCHAR2(50),
  crem          VARCHAR2(100),
  cantfact      NUMBER(12,2),
  cmoiderfac    DATE,
  cmmens        NUMBER(12,2),
  ccharesti     NUMBER(5,1)                     DEFAULT 0                     NOT NULL,
  cecartht      NUMBER(12,2),
  cevainit      NUMBER(12,2),
  cnaffair      VARCHAR(3)                         NOT NULL,
  cagrement     VARCHAR2(2),
  crang         VARCHAR(1),
  cantcons      NUMBER(12,2)                    NOT NULL,
  ccoutht       NUMBER(12,2)                    NOT NULL,
  cdatannul     DATE,
  cdatarr       DATE,
  cdatclot      DATE,
  cdatdeb       DATE,
  cdatsoce      DATE,
  cdatfin       DATE,
  cdatmaj       DATE,
  cdatdir       DATE                            NOT NULL,
  cdatbilq      DATE,
  cdatrpol      DATE                            NOT NULL,
  cdatsocr      DATE,
  cdatsai       DATE                            NOT NULL,
  cduree        NUMBER(2),
  flaglock      NUMBER(7)                       DEFAULT 0                     NOT NULL,
  soccont       VARCHAR(4)                         NOT NULL,
  cav           VARCHAR(2)                         NOT NULL,
  filcode       VARCHAR(3)                         DEFAULT '01'                  NOT NULL,
  comcode       VARCHAR2(11)                    NOT NULL,
  niche         NUMBER(2),
  codsg         NUMBER(7)                       NOT NULL,
  ccentrefrais  NUMBER(3)
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.contrat IS 'Table des contrats.';

COMMENT ON COLUMN bip.contrat.numcont IS 'Numero de contrat';

COMMENT ON COLUMN bip.contrat.cchtsoc IS 'Top changement de societe';

COMMENT ON COLUMN bip.contrat.ctypfact IS 'Type facture';

COMMENT ON COLUMN bip.contrat.cobjet1 IS 'Objet du contrat';

COMMENT ON COLUMN bip.contrat.cobjet2 IS 'Objet du contrat';

COMMENT ON COLUMN bip.contrat.cobjet3 IS 'Objet du contrat';

COMMENT ON COLUMN bip.contrat.crem IS 'Remarque';

COMMENT ON COLUMN bip.contrat.cantfact IS 'Facture anterieur sg2';

COMMENT ON COLUMN bip.contrat.cmoiderfac IS 'Mois de la derniere facturation';

COMMENT ON COLUMN bip.contrat.cmmens IS 'Montant mensuel ht';

COMMENT ON COLUMN bip.contrat.ccharesti IS 'Montant mensuel en jh';

COMMENT ON COLUMN bip.contrat.cecartht IS 'ecart anterieur';

COMMENT ON COLUMN bip.contrat.cevainit IS 'evaluation initiale';

COMMENT ON COLUMN bip.contrat.cnaffair IS 'Affaire nouvelle oui non';

COMMENT ON COLUMN bip.contrat.cagrement IS 'Code agrement';

COMMENT ON COLUMN bip.contrat.crang IS 'Code rang';

COMMENT ON COLUMN bip.contrat.cantcons IS 'Consomme sg2 anterieur';

COMMENT ON COLUMN bip.contrat.ccoutht IS 'Cout evalue hors taxe';

COMMENT ON COLUMN bip.contrat.cdatannul IS 'Date annulation contrat';

COMMENT ON COLUMN bip.contrat.cdatarr IS 'Date d''arrivee en ges/ach';

COMMENT ON COLUMN bip.contrat.cdatclot IS 'Date cloture';

COMMENT ON COLUMN bip.contrat.cdatdeb IS 'Date debut';

COMMENT ON COLUMN bip.contrat.cdatsoce IS 'Date envoi';

COMMENT ON COLUMN bip.contrat.cdatfin IS 'Date de fin de contrat';

COMMENT ON COLUMN bip.contrat.cdatmaj IS 'Date de mise a jour';

COMMENT ON COLUMN bip.contrat.cdatdir IS 'Date remise signature';

COMMENT ON COLUMN bip.contrat.cdatbilq IS 'Date retour bilan qualite';

COMMENT ON COLUMN bip.contrat.cdatrpol IS 'Date retour au pole';

COMMENT ON COLUMN bip.contrat.cdatsocr IS 'Date de retour du contrat';

COMMENT ON COLUMN bip.contrat.cdatsai IS 'Date de saisie';

COMMENT ON COLUMN bip.contrat.cduree IS 'Duree du contrat en mois';

COMMENT ON COLUMN bip.contrat.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.contrat.soccont IS 'Code société';

COMMENT ON COLUMN bip.contrat.cav IS 'Numero d''avenant';

COMMENT ON COLUMN bip.contrat.filcode IS 'Code de la filiale';

COMMENT ON COLUMN bip.contrat.comcode IS 'Num code comptable';

COMMENT ON COLUMN bip.contrat.niche IS 'Identifiant de la niche technologique';

COMMENT ON COLUMN bip.contrat.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.contrat.ccentrefrais IS 'Centre de frais';


ALTER TABLE bip.cout_std2 DROP PRIMARY KEY CASCADE;
DROP TABLE bip.cout_std2 CASCADE CONSTRAINTS;

--
-- COUT_STD2  (Table) 
--
CREATE TABLE bip.cout_std2
(
  annee         NUMBER(4)                       NOT NULL,
  cout_log      NUMBER(6,2),
  dpg_haut      NUMBER(7)                       NOT NULL,
  dpg_bas       NUMBER(7)                       NOT NULL,
  flaglock      NUMBER(7)                       DEFAULT 0                     NOT NULL,
  coutenv_sg    NUMBER(6,2),
  coutenv_ssii  NUMBER(6,2)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.cout_std2 IS 'Coûts d''environnement et logiciels par service';

COMMENT ON COLUMN bip.cout_std2.annee IS 'Année de référence';

COMMENT ON COLUMN bip.cout_std2.cout_log IS 'Coût moyen des logiciels du service : s''applique aux ressources de type logiciel déclarées pour le service';

COMMENT ON COLUMN bip.cout_std2.dpg_haut IS 'Code département/pôle/groupe minimum de la fourchette de coûts';

COMMENT ON COLUMN bip.cout_std2.dpg_bas IS 'Code département/pôle/groupe maximum de la fourchette de coûts';

COMMENT ON COLUMN bip.cout_std2.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.cout_std2.coutenv_sg IS 'Coût d''environnement pour les ressources SG';

COMMENT ON COLUMN bip.cout_std2.coutenv_ssii IS 'Coût d''environnement pour les ressources SSII';


ALTER TABLE bip.cout_std_sg DROP PRIMARY KEY CASCADE;
DROP TABLE bip.cout_std_sg CASCADE CONSTRAINTS;

--
-- COUT_STD_SG  (Table) 
--
CREATE TABLE bip.cout_std_sg
(
  annee     NUMBER(4)                           NOT NULL,
  niveau    VARCHAR2(2)                         NOT NULL,
  metier    VARCHAR2(3)                         NOT NULL,
  cout_sg   NUMBER(6,2)                         NOT NULL,
  dpg_haut  NUMBER(7)                           NOT NULL,
  dpg_bas   NUMBER(7)                           NOT NULL,
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.cout_std_sg IS 'Coûts standards des ressources SG';

COMMENT ON COLUMN bip.cout_std_sg.annee IS 'Année de référence';

COMMENT ON COLUMN bip.cout_std_sg.niveau IS 'Niveau de la ressource';

COMMENT ON COLUMN bip.cout_std_sg.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.cout_std_sg.cout_sg IS 'Coût journalier d''une ressource SG en euros hors taxes récupérable';

COMMENT ON COLUMN bip.cout_std_sg.dpg_haut IS 'Code département/pôle/groupe minimum de la fourchette de coûts';

COMMENT ON COLUMN bip.cout_std_sg.dpg_bas IS 'Code département/pôle/groupe maximum de la fourchette de coûts';

COMMENT ON COLUMN bip.cout_std_sg.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.cumul_conso DROP PRIMARY KEY CASCADE;
DROP TABLE bip.cumul_conso CASCADE CONSTRAINTS;

--
-- CUMUL_CONSO  (Table) 
--
CREATE TABLE bip.cumul_conso
(
  annee    NUMBER(4)                            NOT NULL,
  pid      VARCHAR2(4)                          NOT NULL,
  ftsg     NUMBER(12,2),
  ftssii   NUMBER(12,2),
  envsg    NUMBER(12,2),
  envssii  NUMBER(12,2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.cumul_conso IS 'Table du suivi financier - est remplacée par la table SYNTHESE_ACTIVITE';

COMMENT ON COLUMN bip.cumul_conso.annee IS 'Année de référence';

COMMENT ON COLUMN bip.cumul_conso.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.cumul_conso.ftsg IS 'Consommé force de travail de l''année en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.cumul_conso.ftssii IS 'Consommé force de travail de l''année en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.cumul_conso.envsg IS 'Consommé charge d''environnement de l''année en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.cumul_conso.envssii IS 'Consommé charge d''environnement de l''année en euros hors taxes récupérable pour les ressources SSII';


DROP TABLE bip.datdebex CASCADE CONSTRAINTS;

--
-- DATDEBEX  (Table) 
--
CREATE TABLE bip.datdebex
(
  datdebex       DATE,
  cmensuelle     DATE,
  dertrait       DATE,
  moismens       DATE,
  moismens_nbjo  NUMBER(3,1),
  moisfi         DATE,
  numtrait       NUMBER(1)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.datdebex IS 'Table de contrôle des traitements de la BIP - contient sur une seule ligne les dates de traitement de l''application BIP';

COMMENT ON COLUMN bip.datdebex.datdebex IS 'Date de l''exercice';

COMMENT ON COLUMN bip.datdebex.cmensuelle IS 'Date de la prochaine mensuelle';

COMMENT ON COLUMN bip.datdebex.dertrait IS 'Date du dernier traitement';

COMMENT ON COLUMN bip.datdebex.moismens IS 'Mois de la mensuelle ( equivaut au mois de référence du dernier traitement prémensuel ou mensuel passé)';

COMMENT ON COLUMN bip.datdebex.moismens_nbjo IS 'Nombre de jours du mois de la mensuelle';

COMMENT ON COLUMN bip.datdebex.moisfi IS 'Plus utilisé';

COMMENT ON COLUMN bip.datdebex.numtrait IS 'Numéro du dernier traitement mensuel passé ( 1: première prémensuelle , 2 :seconde prémensuelle , 3 : mensuelle)';


ALTER TABLE bip.directions DROP PRIMARY KEY CASCADE;
DROP TABLE bip.directions CASCADE CONSTRAINTS;

--
-- DIRECTIONS  (Table) 
--
CREATE TABLE bip.directions
(
  coddir    NUMBER(2)                           NOT NULL,
  libdir    VARCHAR2(30),
  codbr     NUMBER(2)                           NOT NULL,
  topme     NUMBER(1)                           DEFAULT 0                     NOT NULL,
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.directions IS 'Directions de la Société Générale. Une direction est rattachée à une branche et contient plusieurs départements (définis dans la table STRUCT_INFO)';

COMMENT ON COLUMN bip.directions.coddir IS 'Numéro de la direction';

COMMENT ON COLUMN bip.directions.libdir IS 'Libellé de la direction';

COMMENT ON COLUMN bip.directions.codbr IS 'Code de la branche';

COMMENT ON COLUMN bip.directions.topme IS 'Top qui indique si la direction comprend des maîtrises d''oeuvre (1:oui, 0:non)';

COMMENT ON COLUMN bip.directions.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.domaine_bancaire DROP PRIMARY KEY CASCADE;
DROP TABLE bip.domaine_bancaire CASCADE CONSTRAINTS;

--
-- DOMAINE_BANCAIRE  (Table) 
--
CREATE TABLE bip.domaine_bancaire
(
  cod_db  NUMBER(3)                             NOT NULL,
  lib_db  VARCHAR2(50)                          NOT NULL,
  cod_ea  NUMBER(2)                             NOT NULL,
  topfer  VARCHAR(1)                               DEFAULT 'O'                   NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.domaine_bancaire IS 'Table inutilisée car le concept de domaine bancaire doit être redéfini';

COMMENT ON COLUMN bip.domaine_bancaire.cod_db IS 'Code du domaine bancaire';

COMMENT ON COLUMN bip.domaine_bancaire.lib_db IS 'Libellé du domaine bancaire';

COMMENT ON COLUMN bip.domaine_bancaire.cod_ea IS 'Ensemble applicatif associé';

COMMENT ON COLUMN bip.domaine_bancaire.topfer IS 'Top Fermeture (F:Fermé,O:Ouvert)';


ALTER TABLE bip.dossier_projet DROP PRIMARY KEY CASCADE;
DROP TABLE bip.dossier_projet CASCADE CONSTRAINTS;

--
-- DOSSIER_PROJET  (Table) 
--
CREATE TABLE bip.dossier_projet
(
  dpcode    NUMBER(5)                           NOT NULL,
  dplib     VARCHAR(35)                            NOT NULL,
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL,
  datimmo   DATE,
  actif     VARCHAR2(1)                         DEFAULT 'O'                   NOT NULL,
  typdp     VARCHAR2(2)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.dossier_projet IS 'Table des dossiers projets.';

COMMENT ON COLUMN bip.dossier_projet.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.dossier_projet.dplib IS 'Libelle dossier projet';

COMMENT ON COLUMN bip.dossier_projet.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.dossier_projet.datimmo IS 'Date d''immobilisation du dossier projet';

COMMENT ON COLUMN bip.dossier_projet.actif IS 'Flag indiquant si le dossier projet est en activité (O:Oui,N:Non)';

COMMENT ON COLUMN bip.dossier_projet.typdp IS 'Type de dossier projet (0,1,2,3 ...)';


ALTER TABLE bip.ensemble_applicatif DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ensemble_applicatif CASCADE CONSTRAINTS;

--
-- ENSEMBLE_APPLICATIF  (Table) 
--
CREATE TABLE bip.ensemble_applicatif
(
  cod_ea  NUMBER(2)                             NOT NULL,
  lib_ea  VARCHAR2(50)                          NOT NULL,
  topfer  VARCHAR(1)                               DEFAULT 'O'                   NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ensemble_applicatif IS 'Table inutilisée car le concept d''ensemble applicatif doit être redéfini';


ALTER TABLE bip.entite_structure DROP PRIMARY KEY CASCADE;
DROP TABLE bip.entite_structure CASCADE CONSTRAINTS;

--
-- ENTITE_STRUCTURE  (Table) 
--
CREATE TABLE bip.entite_structure
(
  codcamo  NUMBER(5)                            NOT NULL,
  cdtyes   VARCHAR(3)                              NOT NULL,
  niveau   NUMBER(1)                            NOT NULL,
  liloes   VARCHAR2(30)                         NOT NULL,
  licoes   VARCHAR2(30),
  idelst   NUMBER(5)                            NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.entite_structure IS 'Table des eléments de structure';

COMMENT ON COLUMN bip.entite_structure.cdtyes IS 'Type de l''entité de structure (équivaut au niveau)';

COMMENT ON COLUMN bip.entite_structure.niveau IS 'Niveau du centre d''activité (0,1,2,3,4)';

COMMENT ON COLUMN bip.entite_structure.liloes IS 'Libellé long';

COMMENT ON COLUMN bip.entite_structure.licoes IS 'Libellé court';

COMMENT ON COLUMN bip.entite_structure.idelst IS 'Code banque (30003)';

COMMENT ON COLUMN bip.entite_structure.codcamo IS 'Code du centre d''activité (entité de structure)';


DROP TABLE bip.esourcing CASCADE CONSTRAINTS;

--
-- ESOURCING  (Table) 
--
CREATE TABLE bip.esourcing
(
  date_trait   DATE,
  id_oalia     VARCHAR2(15),
  ident        NUMBER(5),
  matricule    VARCHAR2(7),
  rnom         VARCHAR2(30),
  rprenom      VARCHAR2(15),
  datarr       DATE,
  datdep       DATE,
  dpg          NUMBER(7),
  soccode      VARCHAR2(4),
  coutht       NUMBER(13,2),
  qualif       VARCHAR2(3),
  cpident      NUMBER(5),
  code_retour  VARCHAR(1),
  retour       VARCHAR2(50)
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.esourcing IS 'Table de trace des situations et ressources créées par réception des fichiers de l''application RESAO';

COMMENT ON COLUMN bip.esourcing.date_trait IS 'Date à laquelle le traitement a tourné';

COMMENT ON COLUMN bip.esourcing.id_oalia IS 'Identifiant enregistrement interne OALIA';

COMMENT ON COLUMN bip.esourcing.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.esourcing.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.esourcing.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.esourcing.rprenom IS 'Prénom de la ressource';

COMMENT ON COLUMN bip.esourcing.datarr IS 'Date de début de la situation';

COMMENT ON COLUMN bip.esourcing.datdep IS 'Date de fin de la situation';

COMMENT ON COLUMN bip.esourcing.dpg IS 'Code Département/Pôle/Groupe';

COMMENT ON COLUMN bip.esourcing.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.esourcing.coutht IS 'Cout HT de la ressource';

COMMENT ON COLUMN bip.esourcing.qualif IS 'Qualification';

COMMENT ON COLUMN bip.esourcing.cpident IS 'Identifiant du chef de projet de la ressource';

COMMENT ON COLUMN bip.esourcing.code_retour IS 'Code retour de création de la situation ressource';

COMMENT ON COLUMN bip.esourcing.retour IS 'Commentaire sur insertion de la situation ressource';


ALTER TABLE bip.esourcing_contrat DROP PRIMARY KEY CASCADE;
DROP TABLE bip.esourcing_contrat CASCADE CONSTRAINTS;

--
-- ESOURCING_CONTRAT  (Table) 
--
CREATE TABLE bip.esourcing_contrat
(
  id_oalia_cont   VARCHAR2(15),
  id_oalia_ligne  VARCHAR2(15),
  soccont         VARCHAR2(4),
  numcont         VARCHAR2(15),
  cav             VARCHAR(2),
  ident           NUMBER(5),
  codsg           NUMBER(7),
  datdeb          DATE,
  datfin          DATE,
  proporig        NUMBER(10,2),
  date_trait      DATE,
  retour          VARCHAR2(50)
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.esourcing_contrat IS 'Table de trace des contrats créés par réception des fichiers de l''application RESAO';

COMMENT ON COLUMN bip.esourcing_contrat.id_oalia_cont IS 'Identifiant enregistrement interne OALIA';

COMMENT ON COLUMN bip.esourcing_contrat.id_oalia_ligne IS 'Identifiant enregistrement interne OALIA';

COMMENT ON COLUMN bip.esourcing_contrat.soccont IS 'Code société du contrat';

COMMENT ON COLUMN bip.esourcing_contrat.numcont IS 'N° de contrat';

COMMENT ON COLUMN bip.esourcing_contrat.cav IS 'Numéro d''avenant';

COMMENT ON COLUMN bip.esourcing_contrat.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.esourcing_contrat.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.esourcing_contrat.datdeb IS 'Date de début';

COMMENT ON COLUMN bip.esourcing_contrat.datfin IS 'Date de fin';

COMMENT ON COLUMN bip.esourcing_contrat.proporig IS 'Proposé d''origine';

COMMENT ON COLUMN bip.esourcing_contrat.date_trait IS 'Date à laquelle le traitement a tourné';

COMMENT ON COLUMN bip.esourcing_contrat.retour IS 'Commentaire sur insertion de la ligne contrat';


ALTER TABLE bip.etape DROP PRIMARY KEY CASCADE;
DROP TABLE bip.etape CASCADE CONSTRAINTS;

--
-- ETAPE  (Table) 
--
CREATE TABLE bip.etape
(
  ecet     VARCHAR(2)                              NOT NULL,
  edur     NUMBER(5),
  enfi     DATE,
  ende     DATE,
  edeb     DATE,
  efin     DATE,
  pid      VARCHAR2(4)                          NOT NULL,
  typetap  VARCHAR(2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.etape IS 'Table contenant les differentes etapes des projets.';

COMMENT ON COLUMN bip.etape.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.etape.edur IS 'Duree initiale de l''etape';

COMMENT ON COLUMN bip.etape.enfi IS 'Date revisee de fin d''etape';

COMMENT ON COLUMN bip.etape.ende IS 'Date revisee de debut d''etape';

COMMENT ON COLUMN bip.etape.edeb IS 'Date initiale de debut de l''etape';

COMMENT ON COLUMN bip.etape.efin IS 'Date initiale de fin d''etape';

COMMENT ON COLUMN bip.etape.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.etape.typetap IS 'Type d''etape';


ALTER TABLE bip.etape2 DROP PRIMARY KEY CASCADE;
DROP TABLE bip.etape2 CASCADE CONSTRAINTS;

--
-- ETAPE2  (Table) 
--
CREATE TABLE bip.etape2
(
  ecet     VARCHAR(2)                              NOT NULL,
  edur     NUMBER(5),
  enfi     DATE,
  ende     DATE,
  edeb     DATE,
  efin     DATE,
  pid      VARCHAR2(4)                          NOT NULL,
  typetap  VARCHAR(2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.etape2 IS 'Copie de la table etape pour le batch';

COMMENT ON COLUMN bip.etape2.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.etape2.edur IS 'Duree initiale de l''etape';

COMMENT ON COLUMN bip.etape2.enfi IS 'Date revisee de fin d''etape';

COMMENT ON COLUMN bip.etape2.ende IS 'Date revisee de debut d''etape';

COMMENT ON COLUMN bip.etape2.edeb IS 'Date initiale de debut de l''etape';

COMMENT ON COLUMN bip.etape2.efin IS 'Date initiale de fin d''etape';

COMMENT ON COLUMN bip.etape2.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.etape2.typetap IS 'Type d''etape';


ALTER TABLE bip.etape_back DROP PRIMARY KEY CASCADE;
DROP TABLE bip.etape_back CASCADE CONSTRAINTS;

--
-- ETAPE_BACK  (Table) 
--
CREATE TABLE bip.etape_back
(
  ecet     VARCHAR(2)                              NOT NULL,
  edur     NUMBER(5),
  enfi     DATE,
  ende     DATE,
  edeb     DATE,
  efin     DATE,
  pid      VARCHAR2(4)                          NOT NULL,
  typetap  VARCHAR(2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.etape_back IS 'Table de sauvegarde contenant les differentes etapes des projets.';

COMMENT ON COLUMN bip.etape_back.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.etape_back.edur IS 'Duree initiale de l''etape';

COMMENT ON COLUMN bip.etape_back.enfi IS 'Date revisee de fin d''etape';

COMMENT ON COLUMN bip.etape_back.ende IS 'Date revisee de debut d''etape';

COMMENT ON COLUMN bip.etape_back.edeb IS 'Date initiale de debut de l''etape';

COMMENT ON COLUMN bip.etape_back.efin IS 'Date initiale de fin d''etape';

COMMENT ON COLUMN bip.etape_back.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.etape_back.typetap IS 'Type d''etape';


ALTER TABLE bip.etape_rejet_datestatut DROP PRIMARY KEY CASCADE;
DROP TABLE bip.etape_rejet_datestatut CASCADE CONSTRAINTS;

--
-- ETAPE_REJET_DATESTATUT  (Table) 
--
CREATE TABLE bip.etape_rejet_datestatut
(
  ecet      VARCHAR(2)                             NOT NULL,
  edur      NUMBER(5),
  enfi      DATE,
  ende      DATE,
  edeb      DATE,
  efin      DATE,
  pid       VARCHAR2(4)                         NOT NULL,
  typetap   VARCHAR(2),
  ecet_new  VARCHAR2(2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.etape_rejet_datestatut IS 'Table de sauvegarde contenant la liste des étapes portant sur des lignes BIP fermées ( en direct ou en sous-traitance ). Ces données seront ensuite réinsérées dans la table ETAPE cela afin de garder les valeurs d''origine pour ces cas de figure';

COMMENT ON COLUMN bip.etape_rejet_datestatut.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.etape_rejet_datestatut.edur IS 'Duree initiale de l''etape';

COMMENT ON COLUMN bip.etape_rejet_datestatut.enfi IS 'Date revisee de fin d''etape';

COMMENT ON COLUMN bip.etape_rejet_datestatut.ende IS 'Date revisee de debut d''etape';

COMMENT ON COLUMN bip.etape_rejet_datestatut.edeb IS 'Date initiale de debut de l''etape';

COMMENT ON COLUMN bip.etape_rejet_datestatut.efin IS 'Date initiale de fin d''etape';

COMMENT ON COLUMN bip.etape_rejet_datestatut.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.etape_rejet_datestatut.typetap IS 'Type d''etape';

COMMENT ON COLUMN bip.etape_rejet_datestatut.ecet_new IS 'Nouveau numero de l''etape';


DROP TABLE bip.faccons_consomme CASCADE CONSTRAINTS;

--
-- FACCONS_CONSOMME  (Table) 
--
CREATE TABLE bip.faccons_consomme
(
  lmoisprest  DATE,
  ident       NUMBER(5),
  cusag       NUMBER(7,2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.faccons_consomme IS 'Table contenant le consommé des ressources de la BIP par identifiant et mois - Dédiée au traitement Faccons';

COMMENT ON COLUMN bip.faccons_consomme.lmoisprest IS 'Mois année de référence';

COMMENT ON COLUMN bip.faccons_consomme.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.faccons_consomme.cusag IS 'Consomme du mois';


DROP TABLE bip.faccons_facture CASCADE CONSTRAINTS;

--
-- FACCONS_FACTURE  (Table) 
--
CREATE TABLE bip.faccons_facture
(
  lmoisprest  DATE,
  ident       NUMBER(5),
  montht      NUMBER(12,2),
  socfact     VARCHAR(4),
  numfact     VARCHAR(15),
  typfact     VARCHAR(1),
  datfact     DATE,
  lnum        NUMBER(2),
  codcompta   VARCHAR2(11),
  numcont     VARCHAR(15),
  cav         VARCHAR(2),
  codsg       NUMBER(7)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.faccons_facture IS 'Table contenant des éléments des lignes factures des deux dernières années  - Dédiée au traitement Faccons';

COMMENT ON COLUMN bip.faccons_facture.lmoisprest IS 'Mois année de référence';

COMMENT ON COLUMN bip.faccons_facture.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.faccons_facture.montht IS 'Montant ht';

COMMENT ON COLUMN bip.faccons_facture.socfact IS 'Identifiant societe';

COMMENT ON COLUMN bip.faccons_facture.numfact IS 'Numero de facture';

COMMENT ON COLUMN bip.faccons_facture.typfact IS 'Type de la facture';

COMMENT ON COLUMN bip.faccons_facture.datfact IS 'Date de la facture';

COMMENT ON COLUMN bip.faccons_facture.lnum IS 'Numero de ligne facture';

COMMENT ON COLUMN bip.faccons_facture.codcompta IS 'Code comptable';

COMMENT ON COLUMN bip.faccons_facture.numcont IS 'Numero de contrat';

COMMENT ON COLUMN bip.faccons_facture.cav IS 'Numero d''avenant';

COMMENT ON COLUMN bip.faccons_facture.codsg IS 'Code département/pôle/groupe de la ligne BIP';


DROP TABLE bip.faccons_ressource CASCADE CONSTRAINTS;

--
-- FACCONS_RESSOURCE  (Table) 
--
CREATE TABLE bip.faccons_ressource
(
  lmoisprest       DATE,
  ident            NUMBER(5),
  codsg            NUMBER(7),
  prestation       VARCHAR(3),
  soccode          VARCHAR(4),
  cout             NUMBER(12,2),
  conso_total      NUMBER(12,2),
  fact_total       NUMBER(12,2),
  rnom             VARCHAR2(30),
  montant_mensuel  NUMBER(12,2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.faccons_ressource IS 'Table contenant des éléments des ressources ayant consommé ou fait l''objet d''une facture ces deux dernières années  - Dédiée au traitement Faccons';

COMMENT ON COLUMN bip.faccons_ressource.montant_mensuel IS 'Montant mensuel dans le cas de la facturation au 12ème';

COMMENT ON COLUMN bip.faccons_ressource.lmoisprest IS 'Mois année de référence';

COMMENT ON COLUMN bip.faccons_ressource.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.faccons_ressource.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.faccons_ressource.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.faccons_ressource.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.faccons_ressource.cout IS 'Cout unitaire de la ressource';

COMMENT ON COLUMN bip.faccons_ressource.conso_total IS 'Consommé total de la ressource pour la période';

COMMENT ON COLUMN bip.faccons_ressource.fact_total IS 'Montant facturé pour la ressource pour la période';

COMMENT ON COLUMN bip.faccons_ressource.rnom IS 'Nom de la ressource';


ALTER TABLE bip.facture DROP PRIMARY KEY CASCADE;
DROP TABLE bip.facture CASCADE CONSTRAINTS;

--
-- FACTURE  (Table) 
--
CREATE TABLE bip.facture
(
  socfact       VARCHAR(4)                         NOT NULL,
  numfact       VARCHAR(15)                        NOT NULL,
  typfact       VARCHAR(1)                         NOT NULL,
  datfact       DATE                            NOT NULL,
  fnom          VARCHAR2(32),
  fnumasn       NUMBER(9),
  fnumordre     NUMBER(5),
  fordrecheq    VARCHAR2(32),
  fenvsec       DATE,
  fprovsdff1    VARCHAR(1),
  fprovsdff2    VARCHAR(1),
  fprovsegl1    VARCHAR(1),
  fprovsegl2    VARCHAR(1),
  fregcompta    DATE,
  llibanalyt    VARCHAR2(43),
  fstegle       VARCHAR(3),
  fcdsg         VARCHAR(2),
  flivraison    DATE,
  fmodreglt     NUMBER(2),
  fmoiacompta   DATE,
  fmontht       NUMBER(12,2),
  fmontttc      NUMBER(12,2),
  fecritcptab   VARCHAR(11),
  fnmrapprocht  NUMBER(13),
  fcoduser      VARCHAR2(255),
  fcentrefrais  NUMBER(3),
  fdatmaj       DATE,
  fdatsai       DATE,
  fdatsup       DATE,
  fenrcompta    DATE,
  fburdistr     VARCHAR2(26),
  fcodepost     NUMBER(5),
  fstatut1      VARCHAR(2)                         NOT NULL,
  fstatut2      VARCHAR(2),
  faccsec       DATE,
  fsocfour      VARCHAR2(10),
  fadresse1     VARCHAR2(32),
  fadresse2     VARCHAR2(32),
  fadresse3     VARCHAR2(32),
  ftva          NUMBER(9,2),
  fcodcompta    VARCHAR2(11)                    NOT NULL,
  fdeppole      NUMBER(7)                       NOT NULL,
  flaglock      NUMBER(7)                       DEFAULT 0                     NOT NULL,
  soccont       VARCHAR(4),
  cav           VARCHAR(2),
  numcont       VARCHAR(15),
  fdatrecep     DATE,
  num_sms       VARCHAR2(15)
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          50m
            NEXT             1m
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.facture IS 'Table des factures.';

COMMENT ON COLUMN bip.facture.socfact IS 'Identifiant societe';

COMMENT ON COLUMN bip.facture.numfact IS 'Numero de facture';

COMMENT ON COLUMN bip.facture.typfact IS 'Type de la facture';

COMMENT ON COLUMN bip.facture.datfact IS 'Date de la facture';

COMMENT ON COLUMN bip.facture.fnom IS 'Nom';

COMMENT ON COLUMN bip.facture.fnumasn IS 'Numero asn';

COMMENT ON COLUMN bip.facture.fnumordre IS 'Numero d''ordre';

COMMENT ON COLUMN bip.facture.fordrecheq IS 'Ordre du cheque';

COMMENT ON COLUMN bip.facture.fenvsec IS 'Date de reglement souhaitee';

COMMENT ON COLUMN bip.facture.fprovsdff1 IS 'Provenance sdff1';

COMMENT ON COLUMN bip.facture.fprovsdff2 IS 'Provenance sdff2';

COMMENT ON COLUMN bip.facture.fprovsegl1 IS 'Provenance segl cs1';

COMMENT ON COLUMN bip.facture.fprovsegl2 IS 'Provenance segl cs2';

COMMENT ON COLUMN bip.facture.fregcompta IS 'Date d''envoi pour la regularisation comptable';

COMMENT ON COLUMN bip.facture.llibanalyt IS 'Libelle analytique';

COMMENT ON COLUMN bip.facture.fstegle IS 'Code societe Generale (A3)';

COMMENT ON COLUMN bip.facture.fcdsg IS 'Code_ste_generale (A2)';

COMMENT ON COLUMN bip.facture.flivraison IS 'Date de livraison';

COMMENT ON COLUMN bip.facture.fmodreglt IS 'Mode de reglement';

COMMENT ON COLUMN bip.facture.fmoiacompta IS 'Mois a comptabiliser';

COMMENT ON COLUMN bip.facture.fmontht IS 'Montant ht';

COMMENT ON COLUMN bip.facture.fmontttc IS 'Montant ttc';

COMMENT ON COLUMN bip.facture.fecritcptab IS 'Numero de l''ecriture comptable';

COMMENT ON COLUMN bip.facture.fnmrapprocht IS 'Num de rapprochement';

COMMENT ON COLUMN bip.facture.fcoduser IS 'Utilisateur ayant les droits pour la facture';

COMMENT ON COLUMN bip.facture.fcentrefrais IS 'Centre de frais';

COMMENT ON COLUMN bip.facture.fdatmaj IS 'Date de maj';

COMMENT ON COLUMN bip.facture.fdatsai IS 'Date de saisie';

COMMENT ON COLUMN bip.facture.fdatsup IS 'Date de suppression';

COMMENT ON COLUMN bip.facture.fenrcompta IS 'Date d''envoi pour l''enregistrement comptable';

COMMENT ON COLUMN bip.facture.fburdistr IS 'Bureau distributeur';

COMMENT ON COLUMN bip.facture.fcodepost IS 'Code postal';

COMMENT ON COLUMN bip.facture.fstatut1 IS 'Code statut cs1';

COMMENT ON COLUMN bip.facture.fstatut2 IS 'Code statut cs2';

COMMENT ON COLUMN bip.facture.faccsec IS 'Date accord secteur';

COMMENT ON COLUMN bip.facture.fsocfour IS 'Identifiant de l''agence';

COMMENT ON COLUMN bip.facture.fadresse1 IS 'Adresse1';

COMMENT ON COLUMN bip.facture.fadresse2 IS 'Adresse2';

COMMENT ON COLUMN bip.facture.fadresse3 IS 'Adresse3';

COMMENT ON COLUMN bip.facture.ftva IS 'Montant de la TVA';

COMMENT ON COLUMN bip.facture.fcodcompta IS 'Code comptable';

COMMENT ON COLUMN bip.facture.fdeppole IS 'Code département pôle groupe';

COMMENT ON COLUMN bip.facture.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.facture.soccont IS 'Identifiant societe du contrat';

COMMENT ON COLUMN bip.facture.cav IS 'Numero d''avenant';

COMMENT ON COLUMN bip.facture.numcont IS 'Numero de contrat';

COMMENT ON COLUMN bip.facture.fdatrecep IS 'Date de réception';

COMMENT ON COLUMN bip.facture.num_sms IS 'Numéro envoyé par l''application SMS - Identifiant de la facture dans SMS';


ALTER TABLE bip.favoris DROP PRIMARY KEY CASCADE;
DROP TABLE bip.favoris CASCADE CONSTRAINTS;

--
-- FAVORIS  (Table) 
--
CREATE TABLE bip.favoris
(
  iduser   VARCHAR2(60)                         NOT NULL,
  menu     VARCHAR2(10)                         NOT NULL,
  typefav  VARCHAR(1)                              DEFAULT 'T'                   NOT NULL,
  ordre    NUMBER(4),
  libfav   VARCHAR2(120)                        NOT NULL,
  lienfav  VARCHAR2(1000)                       NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.favoris IS 'Table des traitements favoris des utilisateurs';

COMMENT ON COLUMN bip.favoris.iduser IS 'Identifiant de l''utilisateur';

COMMENT ON COLUMN bip.favoris.menu IS 'Menu où se situe le favoris';

COMMENT ON COLUMN bip.favoris.typefav IS 'Type du favori (T : Traitement, E : Edition, X : Extraction)';

COMMENT ON COLUMN bip.favoris.ordre IS 'Numéro d''ordre du favori dans la liste';

COMMENT ON COLUMN bip.favoris.libfav IS 'Libellé du favori';

COMMENT ON COLUMN bip.favoris.lienfav IS 'Lien du favori';


ALTER TABLE bip.fichier DROP PRIMARY KEY CASCADE;
DROP TABLE bip.fichier CASCADE CONSTRAINTS;

--
-- FICHIER  (Table) 
--
CREATE TABLE bip.fichier
(
  idfic    VARCHAR(15)                             NOT NULL,
  contenu  VARCHAR2(2000)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.fichier IS 'Table contenant des fichiers pour l''application';

COMMENT ON COLUMN bip.fichier.idfic IS 'Identifiant du fichier';

COMMENT ON COLUMN bip.fichier.contenu IS 'Contenu du fichier';


ALTER TABLE bip.fichiers_rdf DROP PRIMARY KEY CASCADE;
DROP TABLE bip.fichiers_rdf CASCADE CONSTRAINTS;

--
-- FICHIERS_RDF  (Table) 
--
CREATE TABLE bip.fichiers_rdf
(
  fichier_rdf  VARCHAR2(30)                     NOT NULL,
  libelle_rdf  VARCHAR2(100)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.fichiers_rdf IS 'Table des reports de l''application utilisée pour exploiter la table REPORT_LOG';

COMMENT ON COLUMN bip.fichiers_rdf.fichier_rdf IS 'Nom des fichiers reports .rdf';

COMMENT ON COLUMN bip.fichiers_rdf.libelle_rdf IS 'Libellé du report';


ALTER TABLE bip.filiale_cli DROP PRIMARY KEY CASCADE;
DROP TABLE bip.filiale_cli CASCADE CONSTRAINTS;

--
-- FILIALE_CLI  (Table) 
--
CREATE TABLE bip.filiale_cli
(
  filcode   VARCHAR(3)                             NOT NULL,
  filsigle  VARCHAR2(30)                        NOT NULL,
  top_immo  VARCHAR(1)                             DEFAULT 'N',
  top_sdff  VARCHAR(1)                             DEFAULT 'N',
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.filiale_cli IS 'Table des filiales clients.';

COMMENT ON COLUMN bip.filiale_cli.filcode IS 'Code de la filiale';

COMMENT ON COLUMN bip.filiale_cli.filsigle IS 'Sigle de la filiale';

COMMENT ON COLUMN bip.filiale_cli.top_immo IS 'Top immobilisation';

COMMENT ON COLUMN bip.filiale_cli.top_sdff IS 'Top sdff';

COMMENT ON COLUMN bip.filiale_cli.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.filtre_requete DROP PRIMARY KEY CASCADE;
DROP TABLE bip.filtre_requete CASCADE CONSTRAINTS;

--
-- FILTRE_REQUETE  (Table) 
--
CREATE TABLE bip.filtre_requete
(
  nom_fichier  VARCHAR2(8)                      NOT NULL,
  code         VARCHAR2(30)                     NOT NULL,
  libelle      VARCHAR2(80)                     NOT NULL,
  text_sql     VARCHAR2(2000)                   NOT NULL,
  TYPE         VARCHAR2(20)                     NOT NULL,
  obligatoire  VARCHAR(1)                          NOT NULL,
  longueur     NUMBER(3)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.filtre_requete IS 'Filtre pour les requetes d''extraction';

COMMENT ON COLUMN bip.filtre_requete.TYPE IS 'Si filtre habilitation : PERIMETRE_ME, PERIMETRE_MO, DPG, DIRECTION, MENU, CENTRE_FRAIS.
Sinon : NUMBER1, NUMBER2, INTEGER1, INTEGER2, CHAR1, DATE1, DATE2';

COMMENT ON COLUMN bip.filtre_requete.obligatoire IS 'Trois valeurs :
- O : filtre obligatoire
- N : filtre facultatif
- H : filtre d''habilitation (pas affiché dans l''IHM)';

COMMENT ON COLUMN bip.filtre_requete.longueur IS 'Longueur max pour le champ de saisie dans l''IHM';

COMMENT ON COLUMN bip.filtre_requete.nom_fichier IS 'Nom du fichier généré (identifiant de la requete)';

COMMENT ON COLUMN bip.filtre_requete.code IS 'Identifiant interne';

COMMENT ON COLUMN bip.filtre_requete.libelle IS 'Libellé pour affichage dans l''IHM';

COMMENT ON COLUMN bip.filtre_requete.text_sql IS 'Texte SQL du filtre à ajouter dans la clause WHERE. La valeur du filtre sera insérée à la place de %FILTRE% (peut apparaitre plusieurs fois).
Si filtre avec plage de valeurs : %FILTRE1% et %FILTRE2%';


DROP TABLE bip.hispro CASCADE CONSTRAINTS;

--
-- HISPRO  (Table) 
--
CREATE TABLE bip.hispro
(
  pdsg      NUMBER(7),
  pid       VARCHAR2(4),
  pnom      VARCHAR2(30),
  idpro     VARCHAR2(20),
  flag      VARCHAR(1),
  factpdsg  NUMBER(7),
  factpid   VARCHAR2(4),
  factpno   VARCHAR2(30),
  tires     NUMBER(5),
  idres     VARCHAR2(14),
  cdeb      DATE,
  cusag     NUMBER(7,2)
)
TABLESPACE tbs_bip_his_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.hispro IS 'Table des historiques des projets';

COMMENT ON COLUMN bip.hispro.pdsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.hispro.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.hispro.pnom IS 'Libelle du projet';

COMMENT ON COLUMN bip.hispro.idpro IS 'Nom et prenom du chef de projet';

COMMENT ON COLUMN bip.hispro.flag IS '1 ress du projet 2 ress sous traitance';

COMMENT ON COLUMN bip.hispro.factpdsg IS 'Code dpg du projet recevant la ss-traitance';

COMMENT ON COLUMN bip.hispro.factpid IS 'Code du projet recevant la sous-traitance';

COMMENT ON COLUMN bip.hispro.factpno IS 'Libelle du projet pour le projet recevant la';

COMMENT ON COLUMN bip.hispro.tires IS 'Numero de ressource';

COMMENT ON COLUMN bip.hispro.idres IS 'Nom et prenom de la ressource';

COMMENT ON COLUMN bip.hispro.cdeb IS 'Mois annee de reference';

COMMENT ON COLUMN bip.hispro.cusag IS 'Consomme du mois';


ALTER TABLE bip.histo_amort DROP PRIMARY KEY CASCADE;
DROP TABLE bip.histo_amort CASCADE CONSTRAINTS;

--
-- HISTO_AMORT  (Table) 
--
CREATE TABLE bip.histo_amort
(
  pid           VARCHAR2(4)                     NOT NULL,
  aanhist       DATE                            NOT NULL,
  ajhssiil      NUMBER(7,1),
  ajhssiilde    NUMBER(7,1),
  ajhssiip      NUMBER(7,1),
  ajhssiipde    NUMBER(7,1),
  acoutsg       NUMBER(11,2),
  acoutsgde     NUMBER(11,2),
  acoussiif     NUMBER(11,2),
  acoutssiifde  NUMBER(11,2),
  acoutssiil    NUMBER(11,2),
  acoutssiilde  NUMBER(11,2),
  acoutssiip    NUMBER(11,2),
  acoutssiipde  NUMBER(11,2),
  ajhsg         NUMBER(7,1),
  akhsgde       NUMBER(7,1),
  ajhssiif      NUMBER(7,1),
  ajhssiifde    NUMBER(7,1)
)
TABLESPACE tbs_bip_his_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.histo_amort IS 'Table d''historique pour l''amortissement';

COMMENT ON COLUMN bip.histo_amort.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.histo_amort.aanhist IS 'Mois annee histo';

COMMENT ON COLUMN bip.histo_amort.ajhssiil IS 'Jh logiciel ssii';

COMMENT ON COLUMN bip.histo_amort.ajhssiilde IS 'Jh logiciel ssii de decembre';

COMMENT ON COLUMN bip.histo_amort.ajhssiip IS 'Jh personne ssii';

COMMENT ON COLUMN bip.histo_amort.ajhssiipde IS 'Jh personne ssii de decembre';

COMMENT ON COLUMN bip.histo_amort.acoutsg IS 'Cout S.G.';

COMMENT ON COLUMN bip.histo_amort.acoutsgde IS 'Cout S.G. de decembre';

COMMENT ON COLUMN bip.histo_amort.acoussiif IS 'Cout forfait ssii';

COMMENT ON COLUMN bip.histo_amort.acoutssiifde IS 'Cout forfait ssii de decembre';

COMMENT ON COLUMN bip.histo_amort.acoutssiil IS 'Ct logiciel ssii';

COMMENT ON COLUMN bip.histo_amort.acoutssiilde IS 'Cout logiciel ssii de decembre';

COMMENT ON COLUMN bip.histo_amort.acoutssiip IS 'Cout personne ssii';

COMMENT ON COLUMN bip.histo_amort.acoutssiipde IS 'Cout personne ssii de decembre';

COMMENT ON COLUMN bip.histo_amort.ajhsg IS 'Jh S.G.';

COMMENT ON COLUMN bip.histo_amort.akhsgde IS 'Jh S.G. de decembre';

COMMENT ON COLUMN bip.histo_amort.ajhssiif IS 'Jh forfait ssii';

COMMENT ON COLUMN bip.histo_amort.ajhssiifde IS 'Jh forfait ssii de decembre';


ALTER TABLE bip.histo_contrat DROP PRIMARY KEY CASCADE;
DROP TABLE bip.histo_contrat CASCADE CONSTRAINTS;

--
-- HISTO_CONTRAT  (Table) 
--
CREATE TABLE bip.histo_contrat
(
  numcont       VARCHAR(15)                        NOT NULL,
  cchtsoc       VARCHAR(1),
  ctypfact      VARCHAR(1)                         NOT NULL,
  cobjet1       VARCHAR2(50)                    NOT NULL,
  cobjet2       VARCHAR2(50),
  cobjet3       VARCHAR2(50),
  crem          VARCHAR2(100),
  cantfact      NUMBER(12,2),
  cmoiderfac    DATE,
  cmmens        NUMBER(12,2),
  ccharesti     NUMBER(5,1)                     DEFAULT 0                     NOT NULL,
  cecartht      NUMBER(12,2),
  cevainit      NUMBER(12,2),
  cnaffair      VARCHAR(3)                         NOT NULL,
  cagrement     VARCHAR(1),
  crang         VARCHAR(1),
  cantcons      NUMBER(12,2)                    NOT NULL,
  ccoutht       NUMBER(12,2)                    NOT NULL,
  cdatannul     DATE,
  cdatarr       DATE,
  cdatclot      DATE,
  cdatdeb       DATE,
  cdatsoce      DATE,
  cdatfin       DATE,
  cdatmaj       DATE,
  cdatdir       DATE,
  cdatbilq      DATE,
  cdatrpol      DATE,
  cdatsocr      DATE,
  cdatsai       DATE,
  cduree        NUMBER(2),
  flaglock      NUMBER(7)                       DEFAULT 0                     NOT NULL,
  soccont       VARCHAR(4)                         NOT NULL,
  cav           VARCHAR(2)                         NOT NULL,
  filcode       VARCHAR(3)                         DEFAULT '01'                  NOT NULL,
  comcode       VARCHAR2(11)                    NOT NULL,
  niche         NUMBER(2),
  codsg         NUMBER(7)                       NOT NULL,
  ccentrefrais  NUMBER(3)
)
TABLESPACE tbs_bip_his_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.histo_contrat IS 'A SUPPRIMER';


DROP TABLE bip.histo_facture CASCADE CONSTRAINTS;

--
-- HISTO_FACTURE  (Table) 
--
CREATE TABLE bip.histo_facture
(
  socfact       VARCHAR(4)                         NOT NULL,
  numfact       VARCHAR(15)                        NOT NULL,
  typfact       VARCHAR(1)                         NOT NULL,
  datfact       DATE                            NOT NULL,
  fnom          VARCHAR2(32),
  fnumasn       NUMBER(9),
  fnumordre     NUMBER(5),
  fordrecheq    VARCHAR2(32),
  fenvsec       DATE,
  fprovsdff1    VARCHAR(1),
  fprovsdff2    VARCHAR(1),
  fprovsegl1    VARCHAR(1),
  fprovsegl2    VARCHAR(1),
  fregcompta    DATE,
  llibanalyt    VARCHAR2(43),
  fstegle       VARCHAR(3),
  fcdsg         VARCHAR(2),
  flivraison    DATE,
  fmodreglt     NUMBER(2),
  fmoiacompta   DATE,
  fmontht       NUMBER(12,2),
  fmontttc      NUMBER(12,2),
  fecritcptab   VARCHAR(11),
  fnmrapprocht  NUMBER(13),
  fcoduser      VARCHAR(7),
  fcentrefrais  NUMBER(3),
  fdatmaj       DATE,
  fdatsai       DATE,
  fdatsup       DATE,
  fenrcompta    DATE,
  fburdistr     VARCHAR2(26),
  fcodepost     NUMBER(5),
  fstatut1      VARCHAR(2)                         NOT NULL,
  fstatut2      VARCHAR(2),
  faccsec       DATE,
  fsocfour      VARCHAR2(10),
  fadresse1     VARCHAR2(32),
  fadresse2     VARCHAR2(32),
  fadresse3     VARCHAR2(32),
  ftva          NUMBER(9,2),
  fcodcompta    VARCHAR2(11)                    NOT NULL,
  fdeppole      NUMBER(6)                       NOT NULL,
  flaglock      NUMBER(7)                       DEFAULT 0                     NOT NULL,
  soccont       VARCHAR(4),
  cav           VARCHAR(2),
  numcont       VARCHAR(15)
)
TABLESPACE tbs_bip_his_data
PCTUSED    90
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          50m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.histo_facture IS 'A SUPPRIMER';


ALTER TABLE bip.histo_ligne_cont DROP PRIMARY KEY CASCADE;
DROP TABLE bip.histo_ligne_cont CASCADE CONSTRAINTS;

--
-- HISTO_LIGNE_CONT  (Table) 
--
CREATE TABLE bip.histo_ligne_cont
(
  lcnum       NUMBER(2)                         NOT NULL,
  lfraisdep   VARCHAR(1),
  lastreinte  VARCHAR(1),
  lheursup    VARCHAR(1),
  lresdeb     DATE,
  lresfin     DATE,
  lcdatact    DATE,
  lccouact    NUMBER(12,2)                      DEFAULT 0                     NOT NULL,
  lccouinit   NUMBER(12,2),
  lcprest     VARCHAR(3),
  soccont     VARCHAR(4)                           NOT NULL,
  cav         VARCHAR(2)                           NOT NULL,
  numcont     VARCHAR(15)                          NOT NULL,
  ident       NUMBER(5)                         NOT NULL
)
TABLESPACE tbs_bip_his_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.histo_ligne_cont IS 'A SUPPRIMER';


ALTER TABLE bip.histo_ligne_fact DROP PRIMARY KEY CASCADE;
DROP TABLE bip.histo_ligne_fact CASCADE CONSTRAINTS;

--
-- HISTO_LIGNE_FACT  (Table) 
--
CREATE TABLE bip.histo_ligne_fact
(
  lnum        NUMBER(2)                         NOT NULL,
  lmontht     NUMBER(12,2),
  lprest      VARCHAR(3),
  lsecteur    NUMBER(1),
  lcodfinali  NUMBER(4),
  lcodcompta  VARCHAR2(11)                      NOT NULL,
  ldeppole    NUMBER(6),
  lidavfact   VARCHAR(26),
  lcodjh      VARCHAR(1),
  lcodestina  NUMBER(7),
  lmoisprest  DATE                              NOT NULL,
  socfact     VARCHAR(4)                           NOT NULL,
  typfact     VARCHAR(1)                           NOT NULL,
  datfact     DATE                              NOT NULL,
  numfact     VARCHAR(15)                          NOT NULL,
  tva         NUMBER(9,2)                       NOT NULL,
  ident       NUMBER(5)                         NOT NULL,
  codcamo     NUMBER(6),
  pid         VARCHAR2(4)
)
TABLESPACE tbs_bip_his_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.histo_ligne_fact IS 'A SUPPRIMER';


DROP TABLE bip.histo_stock_fi CASCADE CONSTRAINTS;

--
-- HISTO_STOCK_FI  (Table) 
--
CREATE TABLE bip.histo_stock_fi
(
  cdeb             DATE                         NOT NULL,
  pid              VARCHAR2(4)                  NOT NULL,
  ident            NUMBER(5)                    NOT NULL,
  typproj          VARCHAR(2),
  metier           VARCHAR2(3),
  pnom             VARCHAR2(30),
  codsg            NUMBER(7),
  dpcode           NUMBER(5),
  icpi             VARCHAR(5),
  codcamo          NUMBER(6),
  clibrca          VARCHAR(16),
  cafi             NUMBER(6),
  codsgress        NUMBER(7),
  libdsg           VARCHAR2(30),
  rnom             VARCHAR2(30),
  rtype            VARCHAR(1),
  prestation       VARCHAR(3),
  niveau           VARCHAR2(2),
  soccode          VARCHAR(4),
  cada             NUMBER(6),
  coutftht         NUMBER(12,2),
  coutft           NUMBER(12,2),
  coutenv          NUMBER(12,2),
  consojhimmo      NUMBER(12,2),
  nconsojhimmo     NUMBER(12,2),
  consoft          NUMBER(12,2),
  consoenvimmo     NUMBER(12,2),
  nconsoenvimmo    NUMBER(12,2),
  a_consojhimmo    NUMBER(12,2),
  a_nconsojhimmo   NUMBER(12,2),
  a_consoft        NUMBER(12,2),
  a_consoenvimmo   NUMBER(12,2),
  a_nconsoenvimmo  NUMBER(12,2),
  fi1              VARCHAR2(1)
)
TABLESPACE tbs_bip_his_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.histo_stock_fi IS 'Historique du stock de facturation interne - Est alimenté à la clôture - Stocke les années antérieures de STOCK_FI';

COMMENT ON COLUMN bip.histo_stock_fi.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.histo_stock_fi.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.histo_stock_fi.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.histo_stock_fi.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.histo_stock_fi.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.histo_stock_fi.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.histo_stock_fi.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.histo_stock_fi.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.histo_stock_fi.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.histo_stock_fi.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.histo_stock_fi.clibrca IS 'Libellé du centre d''activité du client payeur';

COMMENT ON COLUMN bip.histo_stock_fi.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.histo_stock_fi.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.histo_stock_fi.libdsg IS 'Libellé du département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.histo_stock_fi.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.histo_stock_fi.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.histo_stock_fi.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.histo_stock_fi.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.histo_stock_fi.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.histo_stock_fi.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.histo_stock_fi.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.histo_stock_fi.coutft IS 'Coût force de travail (en hors taxes récupérable)';

COMMENT ON COLUMN bip.histo_stock_fi.coutenv IS 'Coût d''environnement (en hors taxes récupérable)';

COMMENT ON COLUMN bip.histo_stock_fi.consojhimmo IS 'Consommé du mois immobilisable en jours hommes';

COMMENT ON COLUMN bip.histo_stock_fi.nconsojhimmo IS 'Consommé du mois non immobilisable en jours hommes';

COMMENT ON COLUMN bip.histo_stock_fi.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.histo_stock_fi.consoenvimmo IS 'Consommé charge d''environnement immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.histo_stock_fi.nconsoenvimmo IS 'Consommé charge d''environnement non immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.histo_stock_fi.a_consojhimmo IS 'Retour arrière consommé du mois immobilisable en jours hommes';

COMMENT ON COLUMN bip.histo_stock_fi.a_nconsojhimmo IS 'Retour arrière consommé du mois non immobilisable en jours hommes';

COMMENT ON COLUMN bip.histo_stock_fi.a_consoft IS 'Retour arrière consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.histo_stock_fi.a_consoenvimmo IS 'Retour arrière consommé charge d''environnement immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.histo_stock_fi.a_nconsoenvimmo IS 'Retour arrière consommé charge d''environnement non immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.histo_stock_fi.fi1 IS 'Top pour les lignes qui ont été copiées lors du traitement depuis STOCK_FI_1 (=O dans ce cas, null sinon)';


DROP TABLE bip.histo_stock_immo CASCADE CONSTRAINTS;

--
-- HISTO_STOCK_IMMO  (Table) 
--
CREATE TABLE bip.histo_stock_immo
(
  cdeb        DATE                              NOT NULL,
  pid         VARCHAR2(4)                       NOT NULL,
  ident       NUMBER(5)                         NOT NULL,
  typproj     VARCHAR(2),
  metier      VARCHAR2(3),
  pnom        VARCHAR2(30),
  codsg       NUMBER(7),
  dpcode      NUMBER(5),
  icpi        VARCHAR(5),
  codcamo     NUMBER(6),
  clibrca     VARCHAR(16),
  cafi        NUMBER(6),
  codsgress   NUMBER(7),
  libdsg      VARCHAR2(30),
  rnom        VARCHAR2(30),
  rtype       VARCHAR(1),
  prestation  VARCHAR(3),
  niveau      VARCHAR2(2),
  soccode     VARCHAR(4),
  cada        NUMBER(6),
  coutftht    NUMBER(12,2),
  coutft      NUMBER(12,2),
  consojh     NUMBER(12,2),
  consoft     NUMBER(12,2),
  a_consojh   NUMBER(12,2),
  a_consoft   NUMBER(12,2),
  immo1       VARCHAR2(1)
)
TABLESPACE tbs_bip_his_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.histo_stock_immo IS 'Historique du stock des immobilisations - Est alimenté à la clôture - Stocke les années antérieures de STOCK_IMMO';

COMMENT ON COLUMN bip.histo_stock_immo.clibrca IS 'Libellé du centre d''activité du client payeur';

COMMENT ON COLUMN bip.histo_stock_immo.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.histo_stock_immo.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.histo_stock_immo.libdsg IS 'Libellé du département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.histo_stock_immo.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.histo_stock_immo.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.histo_stock_immo.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.histo_stock_immo.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.histo_stock_immo.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.histo_stock_immo.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.histo_stock_immo.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.histo_stock_immo.coutft IS 'Coût force de travail (en hors taxes récupérable)';

COMMENT ON COLUMN bip.histo_stock_immo.consojh IS 'Consommé du mois en jours hommes';

COMMENT ON COLUMN bip.histo_stock_immo.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.histo_stock_immo.a_consojh IS 'Retour arrière consommé du mois en jours hommes';

COMMENT ON COLUMN bip.histo_stock_immo.a_consoft IS 'Retour arrière consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.histo_stock_immo.immo1 IS 'Top pour les lignes qui ont été copiées lors du traitement depuis STOCK_IMMO_1 (=O dans ce cas, null sinon)';

COMMENT ON COLUMN bip.histo_stock_immo.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.histo_stock_immo.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.histo_stock_immo.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.histo_stock_immo.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.histo_stock_immo.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.histo_stock_immo.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.histo_stock_immo.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.histo_stock_immo.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.histo_stock_immo.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.histo_stock_immo.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';


ALTER TABLE bip.histo_suivijhr DROP PRIMARY KEY CASCADE;
DROP TABLE bip.histo_suivijhr CASCADE CONSTRAINTS;

--
-- HISTO_SUIVIJHR  (Table) 
--
CREATE TABLE bip.histo_suivijhr
(
  codsg       NUMBER(7)                         NOT NULL,
  consmois_2  NUMBER(12,2),
  consmois_1  NUMBER(12,2),
  absmois_1   NUMBER(12,2)
)
TABLESPACE tbs_bip_his_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.histo_suivijhr IS 'Sauvegarde de la table SUIVIJRH - Stocke les données du mois précédent';

COMMENT ON COLUMN bip.histo_suivijhr.codsg IS 'Code département/pôle/groupe';

COMMENT ON COLUMN bip.histo_suivijhr.consmois_2 IS 'Consommé en jours hommes de l''avant-dernier mois';

COMMENT ON COLUMN bip.histo_suivijhr.consmois_1 IS 'Consommé en jours hommes du dernier mois';

COMMENT ON COLUMN bip.histo_suivijhr.absmois_1 IS 'Nombre de jours d''absences du dernier mois';


ALTER TABLE bip.ias DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ias CASCADE CONSTRAINTS;

--
-- IAS  (Table) 
--
CREATE TABLE bip.ias
(
  cdeb        DATE                              NOT NULL,
  factpid     VARCHAR2(4)                       NOT NULL,
  ident       NUMBER(5)                         NOT NULL,
  pid         VARCHAR2(4)                       NOT NULL,
  typproj     VARCHAR(2),
  metier      VARCHAR2(3),
  pnom        VARCHAR2(30),
  codsg       NUMBER(7),
  astatut     VARCHAR(1),
  dpcode      NUMBER(5),
  icpi        VARCHAR(5),
  codcamo     NUMBER(6),
  clibrca     VARCHAR(16),
  ctopact     VARCHAR(1),
  cafi        NUMBER(6),
  codsgress   NUMBER(7),
  libdsg      VARCHAR2(30),
  rnom        VARCHAR2(30),
  rtype       VARCHAR(1),
  prestation  VARCHAR(3),
  niveau      VARCHAR2(2),
  soccode     VARCHAR(4),
  cada        NUMBER(6),
  datdemar    DATE,
  datstatut   DATE,
  datimmo     DATE,
  typetap     VARCHAR(2),
  coutftht    NUMBER(12,2),
  coutft      NUMBER(12,2),
  coutenv     NUMBER(12,2),
  consojh     NUMBER(12,2),
  consoft     NUMBER(12,2),
  consoenv    NUMBER(12,2)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          20m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       1000
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ias IS 'Table de travail du traitement mensuel IAS : Facturation interne et immobilisations';

COMMENT ON COLUMN bip.ias.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.ias.factpid IS 'Identifiant de la ligne BIP à facturer (est différent de PID dans le cas d''une sous-traitance)';

COMMENT ON COLUMN bip.ias.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.ias.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.ias.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.ias.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.ias.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.ias.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.ias.astatut IS 'Statut de la ligne BIP à facturer (A:Annulée, D:Démarrée ...)';

COMMENT ON COLUMN bip.ias.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.ias.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.ias.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.ias.clibrca IS 'Libellé du centre d''activité du client payeur';

COMMENT ON COLUMN bip.ias.ctopact IS 'Type d''amortissement du centre d''activité du client payeur (B:Blanc,C:CAFI,S:Ne pas refacturer)';

COMMENT ON COLUMN bip.ias.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.ias.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.ias.libdsg IS 'Libellé du département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.ias.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.ias.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.ias.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.ias.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.ias.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.ias.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.ias.datdemar IS 'Date de démarrage du projet informatique';

COMMENT ON COLUMN bip.ias.datstatut IS 'Date de statut du projet informatique';

COMMENT ON COLUMN bip.ias.datimmo IS 'Date d''immobilisation du dossier projet';

COMMENT ON COLUMN bip.ias.typetap IS 'Type de l''étape (AP:Avant-projet, RE:Réalisation ...)';

COMMENT ON COLUMN bip.ias.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.ias.coutft IS 'Coût force de travail (en hors taxes récupérable)';

COMMENT ON COLUMN bip.ias.coutenv IS 'Coût d''environnement (en hors taxes récupérable)';

COMMENT ON COLUMN bip.ias.consojh IS 'Consommé du mois en jours hommes';

COMMENT ON COLUMN bip.ias.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.ias.consoenv IS 'Consommé charge d''environnement du mois en euros hors taxes récupérable';


ALTER TABLE bip.immeuble DROP PRIMARY KEY CASCADE;
DROP TABLE bip.immeuble CASCADE CONSTRAINTS;

--
-- IMMEUBLE  (Table) 
--
CREATE TABLE bip.immeuble
(
  icodimm   VARCHAR(5)                             NOT NULL,
  iadrabr   VARCHAR(10),
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k 
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.immeuble IS 'Table des factures.';

COMMENT ON COLUMN bip.immeuble.icodimm IS 'Code de l''immeuble';

COMMENT ON COLUMN bip.immeuble.iadrabr IS 'Adresse abregee de l''immeuble';

COMMENT ON COLUMN bip.immeuble.flaglock IS 'Flag pour la gestion de concurrence';


DROP TABLE bip.import_compta_data CASCADE CONSTRAINTS;

--
-- IMPORT_COMPTA_DATA  (Table) 
--
CREATE TABLE bip.import_compta_data
(
  userid       VARCHAR2(255)                    NOT NULL,
  nom_fichier  VARCHAR2(100)                    NOT NULL,
  socfact      VARCHAR(4),
  numfact      VARCHAR(15),
  typfact      VARCHAR(1),
  datfact      DATE,
  statut1      VARCHAR(2),
  num_sms      VARCHAR2(15),
  code_error   NUMBER,
  lib_error    VARCHAR2(500)
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.import_compta_data IS 'Table d''importation du retour des factures traitées par SMS';

COMMENT ON COLUMN bip.import_compta_data.userid IS 'Identifiant de l''utilisateur';

COMMENT ON COLUMN bip.import_compta_data.nom_fichier IS 'Nom du fichier reçu de SMS';

COMMENT ON COLUMN bip.import_compta_data.socfact IS 'Identifiant societe';

COMMENT ON COLUMN bip.import_compta_data.numfact IS 'Numero de facture';

COMMENT ON COLUMN bip.import_compta_data.typfact IS 'Type de la facture';

COMMENT ON COLUMN bip.import_compta_data.datfact IS 'Date de la facture';

COMMENT ON COLUMN bip.import_compta_data.statut1 IS 'Statut renvoyé par SMS : Normalement à la valeur VA';

COMMENT ON COLUMN bip.import_compta_data.num_sms IS 'Numéro envoyé par l''application SMS - Identifiant de la facture dans SMS';

COMMENT ON COLUMN bip.import_compta_data.code_error IS 'Code de l''erreur renvoyée par SMS';

COMMENT ON COLUMN bip.import_compta_data.lib_error IS 'Libellé de l''erreur renvoyée par SMS';


DROP TABLE bip.import_compta_log CASCADE CONSTRAINTS;

--
-- IMPORT_COMPTA_LOG  (Table) 
--
CREATE TABLE bip.import_compta_log
(
  userid       VARCHAR2(255),
  nom_fichier  VARCHAR2(100),
  etat         VARCHAR2(200),
  date_trait   DATE
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.import_compta_log IS 'Journal du retour des factures traitées par SMS';

COMMENT ON COLUMN bip.import_compta_log.userid IS 'Identifiant de l''utilisateur à l''origine de l''envoi';

COMMENT ON COLUMN bip.import_compta_log.nom_fichier IS 'Nom du fichier reçu de SMS';

COMMENT ON COLUMN bip.import_compta_log.etat IS 'Indique si le fichier a été traité';

COMMENT ON COLUMN bip.import_compta_log.date_trait IS 'Date de traitement dans SMS';


DROP TABLE bip.import_compta_res CASCADE CONSTRAINTS;

--
-- IMPORT_COMPTA_RES  (Table) 
--
CREATE TABLE bip.import_compta_res
(
  userid  VARCHAR2(255),
  etat    VARCHAR2(50)
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.import_compta_res IS 'Indique par utilisateur la date du dernier retour des factures traitées par SMS';

COMMENT ON COLUMN bip.import_compta_res.userid IS 'Identifiant de l''utilisateur';

COMMENT ON COLUMN bip.import_compta_res.etat IS 'Indique la date et l''heure du dernier retour';


DROP TABLE bip.imp_oscar_tmp CASCADE CONSTRAINTS;

--
-- IMP_OSCAR_TMP  (Table) 
--
CREATE TABLE bip.imp_oscar_tmp
(
  pid          VARCHAR2(4)                      NOT NULL,
  libelle      VARCHAR2(30),
  resp_mo      VARCHAR2(30),
  code_mo      VARCHAR(5),
  notifie      NUMBER(8,2),
  objectif_mo  NUMBER(8,2),
  erreur       VARCHAR(2),
  propo_mo_n1  NUMBER(8,2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.imp_oscar_tmp IS 'Table d''importation des données transmises par l''application OSCAR';

COMMENT ON COLUMN bip.imp_oscar_tmp.libelle IS 'Libellé de la ligne bip';

COMMENT ON COLUMN bip.imp_oscar_tmp.resp_mo IS 'Responsable de la Maîtrise d''Ouvrage';

COMMENT ON COLUMN bip.imp_oscar_tmp.code_mo IS 'Code client Maîtrise d''Ouvrage';

COMMENT ON COLUMN bip.imp_oscar_tmp.notifie IS 'Budget proposé MO';

COMMENT ON COLUMN bip.imp_oscar_tmp.objectif_mo IS 'Budget réestimé';

COMMENT ON COLUMN bip.imp_oscar_tmp.erreur IS 'Indique qu''une erreur a été rencontrée lors de l''intégration par la BIP de ces données';

COMMENT ON COLUMN bip.imp_oscar_tmp.propo_mo_n1 IS 'Budget proposé MO de l''année suivante';

COMMENT ON COLUMN bip.imp_oscar_tmp.pid IS 'Identifiant de la ligne bip';


ALTER TABLE bip.investissements DROP PRIMARY KEY CASCADE;
DROP TABLE bip.investissements CASCADE CONSTRAINTS;

--
-- INVESTISSEMENTS  (Table) 
--
CREATE TABLE bip.investissements
(
  codtype    NUMBER(4)                          NOT NULL,
  lib_type   VARCHAR2(64)                       NOT NULL,
  flaglock   NUMBER(7)                          DEFAULT 0                     NOT NULL,
  codposte   NUMBER(4)                          NOT NULL,
  codnature  NUMBER(4)                          NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.investissements IS 'Table de référence des différents types d''investissements';

COMMENT ON COLUMN bip.investissements.codtype IS 'Identifiant du type d''investissement';

COMMENT ON COLUMN bip.investissements.lib_type IS 'Libellé correspondant au type ';

COMMENT ON COLUMN bip.investissements.flaglock IS 'Flag';

COMMENT ON COLUMN bip.investissements.codposte IS 'Identifiant du poste correspondant au type d''investissement';

COMMENT ON COLUMN bip.investissements.codnature IS 'Identifiant de la nature de l''investissement';


ALTER TABLE bip.isac_affectation DROP PRIMARY KEY CASCADE;
DROP TABLE bip.isac_affectation CASCADE CONSTRAINTS;

--
-- ISAC_AFFECTATION  (Table) 
--
CREATE TABLE bip.isac_affectation
(
  sous_tache  NUMBER(10)                        NOT NULL,
  ident       NUMBER(5)                         NOT NULL,
  pid         VARCHAR2(4)                       NOT NULL,
  etape       NUMBER(10)                        NOT NULL,
  tache       NUMBER(10)                        NOT NULL
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.isac_affectation IS 'Affectation des ressources - Utilisation dans la saisie directe des consommés';

COMMENT ON COLUMN bip.isac_affectation.sous_tache IS 'Identifiant de la sous-tâche';

COMMENT ON COLUMN bip.isac_affectation.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.isac_affectation.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.isac_affectation.etape IS 'Identifiant de l''étape';

COMMENT ON COLUMN bip.isac_affectation.tache IS 'Identifiant de la tache';


ALTER TABLE bip.isac_consomme DROP PRIMARY KEY CASCADE;
DROP TABLE bip.isac_consomme CASCADE CONSTRAINTS;

--
-- ISAC_CONSOMME  (Table) 
--
CREATE TABLE bip.isac_consomme
(
  ident       NUMBER(5)                         NOT NULL,
  sous_tache  NUMBER(10)                        NOT NULL,
  cdeb        DATE                              NOT NULL,
  cusag       NUMBER(7,2)                       NOT NULL,
  pid         VARCHAR2(4)                       NOT NULL,
  etape       NUMBER(10)                        NOT NULL,
  tache       NUMBER(10)                        NOT NULL
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.isac_consomme IS 'Consommés des ressources - Utilisation dans la saisie directe des consommés';

COMMENT ON COLUMN bip.isac_consomme.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.isac_consomme.sous_tache IS 'Identifiant de la sous-tâche';

COMMENT ON COLUMN bip.isac_consomme.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.isac_consomme.cusag IS 'Consommé du mois';

COMMENT ON COLUMN bip.isac_consomme.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.isac_consomme.etape IS 'Identifiant de l''étape';

COMMENT ON COLUMN bip.isac_consomme.tache IS 'Identifiant de la tache';


ALTER TABLE bip.isac_controle DROP PRIMARY KEY CASCADE;
DROP TABLE bip.isac_controle CASCADE CONSTRAINTS;

--
-- ISAC_CONTROLE  (Table) 
--
CREATE TABLE bip.isac_controle
(
  ID       VARCHAR2(15)                         NOT NULL,
  MESSAGE  VARCHAR2(255)                        NOT NULL
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.isac_controle IS 'A SUPPRIMER';


ALTER TABLE bip.isac_etape DROP PRIMARY KEY CASCADE;
DROP TABLE bip.isac_etape CASCADE CONSTRAINTS;

--
-- ISAC_ETAPE  (Table) 
--
CREATE TABLE bip.isac_etape
(
  etape     NUMBER(10)                          NOT NULL,
  pid       VARCHAR2(4)                         NOT NULL,
  ecet      VARCHAR(2)                             NOT NULL,
  libetape  VARCHAR2(30)                        NOT NULL,
  typetape  VARCHAR(2)                             NOT NULL,
  flaglock  NUMBER(7)                           NOT NULL
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.isac_etape IS 'Etapes constituant les lignes BIP - Utilisation dans la saisie directe des consommés';

COMMENT ON COLUMN bip.isac_etape.etape IS 'Identifiant de l''étape';

COMMENT ON COLUMN bip.isac_etape.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.isac_etape.ecet IS 'Numéro d''étape';

COMMENT ON COLUMN bip.isac_etape.libetape IS 'Libellé de l''étape';

COMMENT ON COLUMN bip.isac_etape.typetape IS 'Type d''étape';

COMMENT ON COLUMN bip.isac_etape.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.isac_message DROP PRIMARY KEY CASCADE;
DROP TABLE bip.isac_message CASCADE CONSTRAINTS;

--
-- ISAC_MESSAGE  (Table) 
--
CREATE TABLE bip.isac_message
(
  id_msg  NUMBER(5)                             NOT NULL,
  limsg   VARCHAR2(1024)
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.isac_message IS 'Messages utilisateurs dédiés à la saisie directe des consommés';

COMMENT ON COLUMN bip.isac_message.id_msg IS 'Identifiant du message à récupérer';

COMMENT ON COLUMN bip.isac_message.limsg IS 'Libellé du message à récupérer';


ALTER TABLE bip.isac_sous_tache DROP PRIMARY KEY CASCADE;
DROP TABLE bip.isac_sous_tache CASCADE CONSTRAINTS;

--
-- ISAC_SOUS_TACHE  (Table) 
--
CREATE TABLE bip.isac_sous_tache
(
  sous_tache   NUMBER(10)                       NOT NULL,
  pid          VARCHAR2(4)                      NOT NULL,
  etape        NUMBER(10)                       NOT NULL,
  tache        NUMBER(10)                       NOT NULL,
  acst         VARCHAR(2)                          NOT NULL,
  asnom        VARCHAR2(30)                     NOT NULL,
  aist         VARCHAR2(6),
  asta         VARCHAR(2),
  adeb         DATE,
  afin         DATE,
  ande         DATE,
  anfi         DATE,
  adur         NUMBER(5),
  flaglock     NUMBER(7)                        NOT NULL,
  param_local  VARCHAR2(5)
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.isac_sous_tache IS 'Sous-tâches constituant les lignes BIP - Utilisation dans la saisie directe des consommés';

COMMENT ON COLUMN bip.isac_sous_tache.sous_tache IS 'Identifiant de la sous-tâche';

COMMENT ON COLUMN bip.isac_sous_tache.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.isac_sous_tache.etape IS 'Identifiant de l''étape';

COMMENT ON COLUMN bip.isac_sous_tache.tache IS 'Identifiant de la tache';

COMMENT ON COLUMN bip.isac_sous_tache.acst IS 'Numéro de la sous tâche';

COMMENT ON COLUMN bip.isac_sous_tache.asnom IS 'Libellé de la sous tâche';

COMMENT ON COLUMN bip.isac_sous_tache.aist IS 'Type de sous tâche';

COMMENT ON COLUMN bip.isac_sous_tache.asta IS 'Statut de la sous tache';

COMMENT ON COLUMN bip.isac_sous_tache.adeb IS 'Date initiale de début';

COMMENT ON COLUMN bip.isac_sous_tache.afin IS 'Date initiale de fin';

COMMENT ON COLUMN bip.isac_sous_tache.ande IS 'Date revisee de debut';

COMMENT ON COLUMN bip.isac_sous_tache.anfi IS 'Date initiale de fin';

COMMENT ON COLUMN bip.isac_sous_tache.adur IS 'Duree de la sous tache';

COMMENT ON COLUMN bip.isac_sous_tache.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.isac_sous_tache.param_local IS 'Paramêtre local (saisie libre)';


ALTER TABLE bip.isac_tache DROP PRIMARY KEY CASCADE;
DROP TABLE bip.isac_tache CASCADE CONSTRAINTS;

--
-- ISAC_TACHE  (Table) 
--
CREATE TABLE bip.isac_tache
(
  tache     NUMBER(10)                          NOT NULL,
  pid       VARCHAR2(4)                         NOT NULL,
  etape     NUMBER(10)                          NOT NULL,
  acta      VARCHAR(2)                             NOT NULL,
  libtache  VARCHAR2(30)                        NOT NULL,
  flaglock  NUMBER(7)                           NOT NULL
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.isac_tache IS 'Tâches constituant les lignes BIP - Utilisation dans la saisie directe des consommés';

COMMENT ON COLUMN bip.isac_tache.tache IS 'Identifiant de la tache';

COMMENT ON COLUMN bip.isac_tache.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.isac_tache.etape IS 'Identifiant de l''étape';

COMMENT ON COLUMN bip.isac_tache.acta IS 'Numéro de tache';

COMMENT ON COLUMN bip.isac_tache.libtache IS 'Libellé de la tache';

COMMENT ON COLUMN bip.isac_tache.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.jferie DROP PRIMARY KEY CASCADE;
DROP TABLE bip.jferie CASCADE CONSTRAINTS;

--
-- JFERIE  (Table) 
--
CREATE TABLE bip.jferie
(
  datjfer   DATE                                NOT NULL,
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.jferie IS 'A SUPPRIMER';


ALTER TABLE bip.lien_profil_actu DROP PRIMARY KEY CASCADE;
DROP TABLE bip.lien_profil_actu CASCADE CONSTRAINTS;

--
-- LIEN_PROFIL_ACTU  (Table) 
--
CREATE TABLE bip.lien_profil_actu
(
  code_actu    NUMBER(5)                        NOT NULL,
  code_profil  VARCHAR2(8)                      NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.lien_profil_actu IS 'Effectue un lien entre les Actualités et les menus - Permet à une actualité de n''être affichée qu''aux utilisateurs ayant accès à un menu donné';

COMMENT ON COLUMN bip.lien_profil_actu.code_actu IS 'Numéro de l''actualité';

COMMENT ON COLUMN bip.lien_profil_actu.code_profil IS 'Nom du menu habilité à présenter cette actualité (pourtous : tous les menus)';


ALTER TABLE bip.lien_types_proj_act DROP PRIMARY KEY CASCADE;
DROP TABLE bip.lien_types_proj_act CASCADE CONSTRAINTS;

--
-- LIEN_TYPES_PROJ_ACT  (Table) 
--
CREATE TABLE bip.lien_types_proj_act
(
  type_proj  VARCHAR(2)                            NOT NULL,
  type_act   VARCHAR2(3)                        NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.lien_types_proj_act IS 'Permet de faire un lien entre la typologie principale (table TYPE_PROJET) et la typologie secondaire (table TYPE_ACTIVITE)';

COMMENT ON COLUMN bip.lien_types_proj_act.type_proj IS 'Typologie principale (table TYPE_PROJET) - Zone Typproj de LIGNE_BIP';

COMMENT ON COLUMN bip.lien_types_proj_act.type_act IS 'Typologie secondaire (table TYPE_ACTIVITE) - Zone Arctype de LIGNE_BIP';


ALTER TABLE bip.ligne_bip DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ligne_bip CASCADE CONSTRAINTS;

--
-- LIGNE_BIP  (Table) 
--
CREATE TABLE bip.ligne_bip
(
  pid           VARCHAR2(4)                     NOT NULL,
  pjcamon1      NUMBER(6),
  astatut       VARCHAR(1),
  adatestatut   DATE,
  ttrmens       DATE,
  ttrfbip       DATE,
  tvaedn        DATE,
  tdebinn       DATE,
  tdatfhp       DATE,
  tdatfhr       DATE,
  tdatfhn       DATE,
  tdatebr       DATE,
  tarcproc      VARCHAR(1),
  pdatdebpre    DATE                            NOT NULL,
  pdatfinpre    DATE,
  ptypen1       VARCHAR(2),
  pcactop       VARCHAR(1),
  pconsn1       NUMBER(7,1),
  pdecn1        NUMBER(7,1),
  pmoycen       VARCHAR(10),
  psitded       VARCHAR2(21),
  pnmouvra      VARCHAR(15),
  pcle          VARCHAR2(3),
  petat         VARCHAR(1),
  pnom          VARCHAR2(30)                    NOT NULL,
  pcpi          NUMBER(5)                       NOT NULL,
  toptri        VARCHAR(3),
  flaglock      NUMBER(7)                       NOT NULL,
  typproj       VARCHAR(2)                         NOT NULL,
  icpi          VARCHAR(5)                         NOT NULL,
  codpspe       VARCHAR(1),
  codcamo       NUMBER(6)                       NOT NULL,
  dpcode        NUMBER(5),
  codsg         NUMBER(7)                       NOT NULL,
  arctype       VARCHAR2(3)                     NOT NULL,
  airt          VARCHAR(5)                         NOT NULL,
  clicode       VARCHAR(5)                         NOT NULL,
  pobjet        VARCHAR2(304),
  pzone         VARCHAR2(20),
  topfer        VARCHAR(1)                         NOT NULL,
  metier        VARCHAR(3),
  caamort       NUMBER(6),
  dureeamort    NUMBER(4,2),
  estimplurian  NUMBER(12,2),
  clicode_oper  VARCHAR(5)                         NOT NULL,
  sous_type     VARCHAR2(3),
  codrep        VARCHAR2(12),
  p_saisie      VARCHAR2(5)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          50m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ligne_bip IS 'Table des lignes BIP.';

COMMENT ON COLUMN bip.ligne_bip.p_saisie IS 'Origine de la saisie des consommés sur cette ligne (RBIP, OSCAR, NIKU, AUTRE)';

COMMENT ON COLUMN bip.ligne_bip.sous_type IS 'Sous-typologie mise en place pour SISE (table SOUS_TYPOLOGIE)';

COMMENT ON COLUMN bip.ligne_bip.codrep IS 'Identifiant de la table de répartition';

COMMENT ON COLUMN bip.ligne_bip.clicode_oper IS 'Code client de la maîtrise d''ouvrage opérationnelle';

COMMENT ON COLUMN bip.ligne_bip.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.ligne_bip.pjcamon1 IS 'Centre d''activite maîtrise d''ouvrage du mois precedent';

COMMENT ON COLUMN bip.ligne_bip.astatut IS 'Statut du projet';

COMMENT ON COLUMN bip.ligne_bip.adatestatut IS 'Date de statut du projet';

COMMENT ON COLUMN bip.ligne_bip.ttrmens IS 'Date du dernier traitement mensuel';

COMMENT ON COLUMN bip.ligne_bip.ttrfbip IS 'Date de transfert pmw -> bip';

COMMENT ON COLUMN bip.ligne_bip.tvaedn IS 'Date prevue (mois-1) de validation e.d. en mois annee';

COMMENT ON COLUMN bip.ligne_bip.tdebinn IS 'Date prevue debut d''industrialisation mois -1 en mois';

COMMENT ON COLUMN bip.ligne_bip.tdatfhp IS 'Date prevue de fin d''homologation en mois annee';

COMMENT ON COLUMN bip.ligne_bip.tdatfhr IS 'Date reelle de fin d''homologation en mois annee';

COMMENT ON COLUMN bip.ligne_bip.tdatfhn IS 'Date prevue de fin d''homologation mois -1 en mois annee';

COMMENT ON COLUMN bip.ligne_bip.tdatebr IS 'Date reelle d''expression des besoins en mois annee';

COMMENT ON COLUMN bip.ligne_bip.tarcproc IS 'Archi res central';

COMMENT ON COLUMN bip.ligne_bip.pdatdebpre IS 'Date prevue de debut de projet';

COMMENT ON COLUMN bip.ligne_bip.pdatfinpre IS 'Date prevue de fin de projet';

COMMENT ON COLUMN bip.ligne_bip.ptypen1 IS 'Type de projet du mois precedent';

COMMENT ON COLUMN bip.ligne_bip.pcactop IS 'Top camo facturation interne';

COMMENT ON COLUMN bip.ligne_bip.pconsn1 IS 'Consommation de decembre de l''annee precedente jusqu''a';

COMMENT ON COLUMN bip.ligne_bip.pdecn1 IS 'Conso de decembre de l''annee precedente';

COMMENT ON COLUMN bip.ligne_bip.pmoycen IS 'Site moyens centraux';

COMMENT ON COLUMN bip.ligne_bip.psitded IS 'Site dedie a l''application';

COMMENT ON COLUMN bip.ligne_bip.pnmouvra IS 'Nom du client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.ligne_bip.pcle IS 'Cle de controle';

COMMENT ON COLUMN bip.ligne_bip.petat IS 'Top maj fiche projet';

COMMENT ON COLUMN bip.ligne_bip.pnom IS 'Libelle du projet';

COMMENT ON COLUMN bip.ligne_bip.pcpi IS 'Code du chef de projet';

COMMENT ON COLUMN bip.ligne_bip.toptri IS 'Top de tri';

COMMENT ON COLUMN bip.ligne_bip.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.ligne_bip.typproj IS 'Type de projet : 1 2 3 4 5 6 7 8 9';

COMMENT ON COLUMN bip.ligne_bip.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.ligne_bip.codpspe IS 'Identifiant projet special';

COMMENT ON COLUMN bip.ligne_bip.codcamo IS 'Code centre d''activite maîtrise d''ouvrage';

COMMENT ON COLUMN bip.ligne_bip.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.ligne_bip.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.ligne_bip.arctype IS 'Identifiant de l''architecture, correspond au type de';

COMMENT ON COLUMN bip.ligne_bip.airt IS 'Identifiant de l''application';

COMMENT ON COLUMN bip.ligne_bip.clicode IS 'Code client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.ligne_bip.pobjet IS 'Objet de la ligne BIP (champ multi-lignes)';

COMMENT ON COLUMN bip.ligne_bip.pzone IS 'Champ libre (différentes significations selon les services)';

COMMENT ON COLUMN bip.ligne_bip.topfer IS 'Top fermeture (pour les lignes sans statut) : O/N';

COMMENT ON COLUMN bip.ligne_bip.metier IS 'Code metier : MO / ME / HOM';

COMMENT ON COLUMN bip.ligne_bip.caamort IS 'Centre d''activité amortissement (inutilisé ?)';

COMMENT ON COLUMN bip.ligne_bip.dureeamort IS 'Durée d''amortissement';

COMMENT ON COLUMN bip.ligne_bip.estimplurian IS 'Estimation pluri-annuelle (budget)';


ALTER TABLE bip.ligne_bip2 DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ligne_bip2 CASCADE CONSTRAINTS;

--
-- LIGNE_BIP2  (Table) 
--
CREATE TABLE bip.ligne_bip2
(
  pid          VARCHAR2(4)                      NOT NULL,
  pjcamon1     NUMBER(6),
  astatut      VARCHAR(1),
  adatestatut  DATE,
  ttrmens      DATE,
  ttrfbip      DATE,
  tvaedn       DATE,
  tdebinn      DATE,
  tdatfhp      DATE,
  tdatfhr      DATE,
  tdatfhn      DATE,
  tdatebr      DATE,
  tarcproc     VARCHAR(1),
  pdatdebpre   DATE                             NOT NULL,
  pdatfinpre   DATE,
  ptypen1      VARCHAR(2),
  pcactop      VARCHAR(1),
  pconsn1      NUMBER(7,1),
  pdecn1       NUMBER(7,1),
  pmoycen      VARCHAR(10),
  psitded      VARCHAR2(21),
  pnmouvra     VARCHAR(15),
  pcle         VARCHAR2(3),
  petat        VARCHAR(1),
  pnom         VARCHAR2(30),
  pcpi         NUMBER(5)                        NOT NULL,
  toptri       VARCHAR(3),
  flaglock     NUMBER(7)                        NOT NULL,
  typproj      VARCHAR(2)                          NOT NULL,
  icpi         VARCHAR(5)                          NOT NULL,
  codpspe      VARCHAR(1),
  codcamo      NUMBER(6)                        NOT NULL,
  dpcode       NUMBER(5),
  codsg        NUMBER(7)                        NOT NULL,
  arctype      VARCHAR2(3)                      NOT NULL,
  airt         VARCHAR(5)                          NOT NULL,
  clicode      VARCHAR(5)                          NOT NULL,
  pobjet       VARCHAR2(304),
  pzone        VARCHAR2(20)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          20m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ligne_bip2 IS 'Copie de la table LIGNE_BIP utilisée par le batch - Sert à alimenter des données de la table LIGNE_BIP qui semble t-il ne servent plus à rien !';

COMMENT ON COLUMN bip.ligne_bip2.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.ligne_bip2.pjcamon1 IS 'Centre d''activite maîtrise d''ouvrage du mois precedent';

COMMENT ON COLUMN bip.ligne_bip2.astatut IS 'Statut du projet';

COMMENT ON COLUMN bip.ligne_bip2.adatestatut IS 'Date de statut du projet';

COMMENT ON COLUMN bip.ligne_bip2.ttrmens IS 'Date du dernier traitement mensuel';

COMMENT ON COLUMN bip.ligne_bip2.ttrfbip IS 'Date de transfert pmw -> bip';

COMMENT ON COLUMN bip.ligne_bip2.tvaedn IS 'Date prevue (mois-1) de validation e.d. en mois annee';

COMMENT ON COLUMN bip.ligne_bip2.tdebinn IS 'Date prevue debut d''industrialisation mois -1 en mois';

COMMENT ON COLUMN bip.ligne_bip2.tdatfhp IS 'Date prevue de fin d''homologation en mois annee';

COMMENT ON COLUMN bip.ligne_bip2.tdatfhr IS 'Date reelle de fin d''homologation en mois annee';

COMMENT ON COLUMN bip.ligne_bip2.tdatfhn IS 'Date prevue de fin d''homologation mois -1 en mois annee';

COMMENT ON COLUMN bip.ligne_bip2.tdatebr IS 'Date reelle d''expression des besoins en mois annee';

COMMENT ON COLUMN bip.ligne_bip2.tarcproc IS 'Archi res central';

COMMENT ON COLUMN bip.ligne_bip2.pdatdebpre IS 'Date prevue de debut de projet';

COMMENT ON COLUMN bip.ligne_bip2.pdatfinpre IS 'Date prevue de fin de projet';

COMMENT ON COLUMN bip.ligne_bip2.ptypen1 IS 'Type de projet du mois precedent';

COMMENT ON COLUMN bip.ligne_bip2.pcactop IS 'Top camo facturation interne';

COMMENT ON COLUMN bip.ligne_bip2.pconsn1 IS 'Consommation de decembre de l''annee precedente jusqu''a';

COMMENT ON COLUMN bip.ligne_bip2.pdecn1 IS 'Conso de decembre de l''annee precedente';

COMMENT ON COLUMN bip.ligne_bip2.pmoycen IS 'Site moyens centraux';

COMMENT ON COLUMN bip.ligne_bip2.psitded IS 'Site dedie a l''application';

COMMENT ON COLUMN bip.ligne_bip2.pnmouvra IS 'Nom du client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.ligne_bip2.pcle IS 'Cle de controle';

COMMENT ON COLUMN bip.ligne_bip2.petat IS 'Top maj fiche projet';

COMMENT ON COLUMN bip.ligne_bip2.pnom IS 'Libelle du projet';

COMMENT ON COLUMN bip.ligne_bip2.pcpi IS 'Code du chef de projet';

COMMENT ON COLUMN bip.ligne_bip2.toptri IS 'Top de tri';

COMMENT ON COLUMN bip.ligne_bip2.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.ligne_bip2.typproj IS 'Type de projet : 1 2 3 4 5 6 7 8 9';

COMMENT ON COLUMN bip.ligne_bip2.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.ligne_bip2.codpspe IS 'Identifiant projet special';

COMMENT ON COLUMN bip.ligne_bip2.codcamo IS 'Code centre d''activite maîtrise d''ouvrage';

COMMENT ON COLUMN bip.ligne_bip2.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.ligne_bip2.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.ligne_bip2.arctype IS 'Identifiant de l''architecture, typologie secondaire';

COMMENT ON COLUMN bip.ligne_bip2.airt IS 'Identifiant de l''application';

COMMENT ON COLUMN bip.ligne_bip2.clicode IS 'Code client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.ligne_bip2.pobjet IS 'Objet de la ligne BIP (champ multi-lignes)';

COMMENT ON COLUMN bip.ligne_bip2.pzone IS 'Champ libre (différentes significations selon les services)';


ALTER TABLE bip.ligne_bip_logs DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ligne_bip_logs CASCADE CONSTRAINTS;

--
-- LIGNE_BIP_LOGS  (Table) 
--
CREATE TABLE bip.ligne_bip_logs
(
  pid          VARCHAR2(4)                      NOT NULL,
  date_log     DATE                             NOT NULL,
  user_log     VARCHAR2(30)                     NOT NULL,
  colonne      VARCHAR2(30)                     NOT NULL,
  valeur_prec  VARCHAR2(30),
  valeur_nouv  VARCHAR2(30),
  commentaire  VARCHAR2(50)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ligne_bip_logs IS 'Trace les modifications intervenues dans certaines données des lignes BIP';

COMMENT ON COLUMN bip.ligne_bip_logs.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.ligne_bip_logs.date_log IS 'Date et heure de la modification';

COMMENT ON COLUMN bip.ligne_bip_logs.user_log IS 'Identifiant de l''utilisateur ayant effectué la modification';

COMMENT ON COLUMN bip.ligne_bip_logs.colonne IS 'Nom de la donnée dans la table LIGNE_BIP qui a été modifiée';

COMMENT ON COLUMN bip.ligne_bip_logs.valeur_prec IS 'Valeur de la donnée avant modification';

COMMENT ON COLUMN bip.ligne_bip_logs.valeur_nouv IS 'Valeur de la donnée après modification';

COMMENT ON COLUMN bip.ligne_bip_logs.commentaire IS 'Indique l''événement déclancheur : écran ayant servi à modifier les données';


DROP TABLE bip.ligne_bip_pp_pid CASCADE CONSTRAINTS;

--
-- LIGNE_BIP_PP_PID  (Table) 
--
CREATE TABLE bip.ligne_bip_pp_pid
(
  pid           VARCHAR2(4)                     NOT NULL,
  pnom          VARCHAR2(30),
  typproj       VARCHAR(2),
  pdatdebpre    DATE,
  arctype       VARCHAR2(3),
  toptri        VARCHAR(3),
  codpspe       VARCHAR(1),
  airt          VARCHAR(5),
  icpi          VARCHAR(5),
  codsg         NUMBER(7),
  pcpi          NUMBER(5),
  clicode       VARCHAR(5),
  clicode_oper  VARCHAR(5),
  codcamo       NUMBER(6),
  pnmouvra      VARCHAR(15),
  metier        VARCHAR(3),
  pobjet        VARCHAR2(304)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;


ALTER TABLE bip.ligne_cont DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ligne_cont CASCADE CONSTRAINTS;

--
-- LIGNE_CONT  (Table) 
--
CREATE TABLE bip.ligne_cont
(
  lcnum       NUMBER(2)                         NOT NULL,
  lfraisdep   VARCHAR(1),
  lastreinte  VARCHAR(1),
  lheursup    VARCHAR(1),
  lresdeb     DATE,
  lresfin     DATE,
  lcdatact    DATE,
  lccouact    NUMBER(12,2)                      DEFAULT 0                     NOT NULL,
  lccouinit   NUMBER(12,2),
  lcprest     VARCHAR(3),
  soccont     VARCHAR(4)                           NOT NULL,
  cav         VARCHAR(2)                           NOT NULL,
  numcont     VARCHAR(15)                          NOT NULL,
  ident       NUMBER(5)                         NOT NULL,
  proporig    NUMBER(10,2)
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ligne_cont IS 'Table des lignes de contrat.';

COMMENT ON COLUMN bip.ligne_cont.lcnum IS 'Numero de ligne de contrat';

COMMENT ON COLUMN bip.ligne_cont.lfraisdep IS 'Frais de deplacement';

COMMENT ON COLUMN bip.ligne_cont.lastreinte IS 'Astreinte';

COMMENT ON COLUMN bip.ligne_cont.lheursup IS 'Heure supplementaire';

COMMENT ON COLUMN bip.ligne_cont.lresdeb IS 'Date de debut d''utilisation de la ressource';

COMMENT ON COLUMN bip.ligne_cont.lresfin IS 'Date de fin d''utilisation de la ressource';

COMMENT ON COLUMN bip.ligne_cont.lcdatact IS 'Date d''actualisation';

COMMENT ON COLUMN bip.ligne_cont.lccouact IS 'Cout journalier ht actualise';

COMMENT ON COLUMN bip.ligne_cont.lccouinit IS 'Cout journalier ht initial';

COMMENT ON COLUMN bip.ligne_cont.lcprest IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.ligne_cont.soccont IS 'Identifiant societe';

COMMENT ON COLUMN bip.ligne_cont.cav IS 'Numero d''avenant';

COMMENT ON COLUMN bip.ligne_cont.numcont IS 'Numero de contrat';

COMMENT ON COLUMN bip.ligne_cont.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.ligne_cont.proporig IS 'Proposé d''origine';


ALTER TABLE bip.ligne_fact DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ligne_fact CASCADE CONSTRAINTS;

--
-- LIGNE_FACT  (Table) 
--
CREATE TABLE bip.ligne_fact
(
  lnum        NUMBER(2)                         NOT NULL,
  lmontht     NUMBER(12,2),
  lprest      VARCHAR(3),
  lsecteur    NUMBER(1),
  lcodfinali  NUMBER(4),
  lcodcompta  VARCHAR2(11)                      NOT NULL,
  ldeppole    NUMBER(7),
  lidavfact   VARCHAR(26),
  lcodjh      VARCHAR(1),
  lcodestina  NUMBER(7),
  lmoisprest  DATE                              NOT NULL,
  socfact     VARCHAR(4)                           NOT NULL,
  typfact     VARCHAR(1)                           NOT NULL,
  datfact     DATE                              NOT NULL,
  numfact     VARCHAR(15)                          NOT NULL,
  tva         NUMBER(9,2)                       NOT NULL,
  ident       NUMBER(5)                         NOT NULL,
  codcamo     NUMBER(6),
  pid         VARCHAR2(4),
  lrapprocht  NUMBER(1)
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          20m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ligne_fact IS 'Table des lignes de facture.';

COMMENT ON COLUMN bip.ligne_fact.lnum IS 'Numero de ligne facture';

COMMENT ON COLUMN bip.ligne_fact.lmontht IS 'Montant ht';

COMMENT ON COLUMN bip.ligne_fact.lprest IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.ligne_fact.lsecteur IS 'Flag rapp fact-cons';

COMMENT ON COLUMN bip.ligne_fact.lcodfinali IS 'Code finalite';

COMMENT ON COLUMN bip.ligne_fact.lcodcompta IS 'Code comptable';

COMMENT ON COLUMN bip.ligne_fact.ldeppole IS 'departement pole groupe';

COMMENT ON COLUMN bip.ligne_fact.lidavfact IS 'ID facture AVANCE';

COMMENT ON COLUMN bip.ligne_fact.lcodjh IS 'Code jh';

COMMENT ON COLUMN bip.ligne_fact.lcodestina IS 'Centre d''activite';

COMMENT ON COLUMN bip.ligne_fact.lmoisprest IS 'Mois de prestation';

COMMENT ON COLUMN bip.ligne_fact.socfact IS 'Identifiant societe';

COMMENT ON COLUMN bip.ligne_fact.typfact IS 'Type de la facture';

COMMENT ON COLUMN bip.ligne_fact.datfact IS 'Date de la facture';

COMMENT ON COLUMN bip.ligne_fact.numfact IS 'Numero de facture';

COMMENT ON COLUMN bip.ligne_fact.tva IS 'Taux de tva';

COMMENT ON COLUMN bip.ligne_fact.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.ligne_fact.codcamo IS 'Code centre d''activite maîtrise d''ouvrage';

COMMENT ON COLUMN bip.ligne_fact.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.ligne_fact.lrapprocht IS 'Flag indiquant que la facture a été rapprochée (comparée avec le consommé)';


ALTER TABLE bip.ligne_investissement DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ligne_investissement CASCADE CONSTRAINTS;

--
-- LIGNE_INVESTISSEMENT  (Table) 
--
CREATE TABLE bip.ligne_investissement
(
  codinv         NUMBER(3)                      NOT NULL,
  annee          NUMBER(4)                      NOT NULL,
  codcamo        NUMBER(5)                      NOT NULL,
  notifie        NUMBER(8,2)                    DEFAULT 0,
  demande        NUMBER(8,2)                    DEFAULT 0                     NOT NULL,
  re_estime      NUMBER(8,2)                    DEFAULT 0                     NOT NULL,
  TYPE           NUMBER(4)                      NOT NULL,
  icpi           VARCHAR(5)                        NOT NULL,
  dpcode         NUMBER(5)                      NOT NULL,
  libelle        VARCHAR2(25),
  quantite       NUMBER(3)                      DEFAULT 1,
  flaglock       NUMBER(7)                      DEFAULT 0                     NOT NULL,
  cominv         VARCHAR2(200),
  toprp          VARCHAR(1),
  not_tvarecup   NUMBER(9,4),
  date_modif_re  VARCHAR2(10)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ligne_investissement IS 'Table des lignes d''investissements';

COMMENT ON COLUMN bip.ligne_investissement.cominv IS 'Commentaire ligne investissement';

COMMENT ON COLUMN bip.ligne_investissement.toprp IS 'Récurrent/Projet';

COMMENT ON COLUMN bip.ligne_investissement.not_tvarecup IS 'Taux TVA récupérable à la notification';

COMMENT ON COLUMN bip.ligne_investissement.date_modif_re IS 'Date modification du re_estimé';

COMMENT ON COLUMN bip.ligne_investissement.codinv IS 'Code investissement';

COMMENT ON COLUMN bip.ligne_investissement.annee IS 'Année d''exercice';

COMMENT ON COLUMN bip.ligne_investissement.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.ligne_investissement.notifie IS 'Notifié HT';

COMMENT ON COLUMN bip.ligne_investissement.demande IS 'Demandé HT';

COMMENT ON COLUMN bip.ligne_investissement.re_estime IS 'Ré_estimé HT';

COMMENT ON COLUMN bip.ligne_investissement.TYPE IS 'Type';

COMMENT ON COLUMN bip.ligne_investissement.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.ligne_investissement.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.ligne_investissement.libelle IS 'Libellé dossier projet';

COMMENT ON COLUMN bip.ligne_investissement.quantite IS 'Quantité';

COMMENT ON COLUMN bip.ligne_investissement.flaglock IS 'Flag';


ALTER TABLE bip.ligne_realisation DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ligne_realisation CASCADE CONSTRAINTS;

--
-- LIGNE_REALISATION  (Table) 
--
CREATE TABLE bip.ligne_realisation
(
  codrea       NUMBER(2)                        NOT NULL,
  codinv       NUMBER(3)                        NOT NULL,
  annee        NUMBER(4)                        NOT NULL,
  codcamo      NUMBER(5)                        NOT NULL,
  engage       NUMBER(8,2)                      NOT NULL,
  date_saisie  VARCHAR2(10)                     NOT NULL,
  num_cmd      VARCHAR2(15)                     NOT NULL,
  type_cmd     VARCHAR2(15)                     NOT NULL,
  marque       VARCHAR2(15)                     NOT NULL,
  modele       VARCHAR2(15)                     NOT NULL,
  type_eng     VARCHAR2(15)                     NOT NULL,
  flaglock     NUMBER(7)                        DEFAULT 0                     NOT NULL,
  comrea       VARCHAR2(200)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ligne_realisation IS 'Table des lignes de réalisation des investissements';

COMMENT ON COLUMN bip.ligne_realisation.comrea IS 'Commentaire';

COMMENT ON COLUMN bip.ligne_realisation.codrea IS 'Code réalisation';

COMMENT ON COLUMN bip.ligne_realisation.codinv IS 'Code investissement';

COMMENT ON COLUMN bip.ligne_realisation.annee IS 'Année d''exercice';

COMMENT ON COLUMN bip.ligne_realisation.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.ligne_realisation.engage IS 'Engagé HT';

COMMENT ON COLUMN bip.ligne_realisation.date_saisie IS 'Date de saisie du réalisée';

COMMENT ON COLUMN bip.ligne_realisation.num_cmd IS 'Numéro';

COMMENT ON COLUMN bip.ligne_realisation.type_cmd IS 'Type de commande';

COMMENT ON COLUMN bip.ligne_realisation.marque IS 'Marque';

COMMENT ON COLUMN bip.ligne_realisation.modele IS 'Modèle';

COMMENT ON COLUMN bip.ligne_realisation.type_eng IS 'Type du produit';

COMMENT ON COLUMN bip.ligne_realisation.flaglock IS 'Flag';


DROP TABLE bip.liste_table_histo CASCADE CONSTRAINTS;

--
-- LISTE_TABLE_HISTO  (Table) 
--
CREATE TABLE bip.liste_table_histo
(
  nom_table  VARCHAR2(30)                       NOT NULL
)
TABLESPACE tbs_bip_his_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512km
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.liste_table_histo IS 'Liste des tables à historiser (qui seront copiées et conservées 14 mois dans l''environnement BIPHISTSUN)';

COMMENT ON COLUMN bip.liste_table_histo.nom_table IS 'Nom de la table à historiser';


ALTER TABLE bip.MESSAGE DROP PRIMARY KEY CASCADE;
DROP TABLE bip.MESSAGE CASCADE CONSTRAINTS;

--
-- MESSAGE  (Table) 
--
CREATE TABLE bip.MESSAGE
(
  id_msg  NUMBER(5)                             NOT NULL,
  limsg   VARCHAR2(1024)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k 
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.MESSAGE IS 'Table des messages utilisateurs de l''application';

COMMENT ON COLUMN bip.MESSAGE.id_msg IS 'Identifiant du message';

COMMENT ON COLUMN bip.MESSAGE.limsg IS 'Libellé du message';


ALTER TABLE bip.metier DROP PRIMARY KEY CASCADE;
DROP TABLE bip.metier CASCADE CONSTRAINTS;

--
-- METIER  (Table) 
--
CREATE TABLE bip.metier
(
  metier     VARCHAR2(3)                        NOT NULL,
  libmetier  VARCHAR2(20),
  flaglock   NUMBER(7)                          DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.metier IS 'Table des métiers';

COMMENT ON COLUMN bip.metier.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.metier.libmetier IS 'Libellé du métier';

COMMENT ON COLUMN bip.metier.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.nature DROP PRIMARY KEY CASCADE;
DROP TABLE bip.nature CASCADE CONSTRAINTS;

--
-- NATURE  (Table) 
--
CREATE TABLE bip.nature
(
  codnature   NUMBER(4)                         NOT NULL,
  lib_nature  VARCHAR2(64)                      NOT NULL,
  flaglock    NUMBER(7)                         DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.nature IS 'Table des natures d''investissements';

COMMENT ON COLUMN bip.nature.codnature IS 'Identifiant de la nature de l''investissement';

COMMENT ON COLUMN bip.nature.lib_nature IS 'Le libellé correspondant à la nature';

COMMENT ON COLUMN bip.nature.flaglock IS 'Flag';


ALTER TABLE bip.niche DROP PRIMARY KEY CASCADE;
DROP TABLE bip.niche CASCADE CONSTRAINTS;

--
-- NICHE  (Table) 
--
CREATE TABLE bip.niche
(
  niche     NUMBER(2)                           NOT NULL,
  libniche  VARCHAR2(20),
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.niche IS 'Identifiant de la niche technologique';

COMMENT ON COLUMN bip.niche.niche IS 'Identifiant de la niche technologique';

COMMENT ON COLUMN bip.niche.libniche IS 'Libelle de la niche technologique';

COMMENT ON COLUMN bip.niche.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.niveau DROP PRIMARY KEY CASCADE;
DROP TABLE bip.niveau CASCADE CONSTRAINTS;

--
-- NIVEAU  (Table) 
--
CREATE TABLE bip.niveau
(
  niveau     VARCHAR2(2)                        NOT NULL,
  libniveau  VARCHAR2(20),
  flaglock   NUMBER(7)                          DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.niveau IS 'Table de référence des niveaux des ressources SG';

COMMENT ON COLUMN bip.niveau.niveau IS 'Code du niveau d''une ressource SG';

COMMENT ON COLUMN bip.niveau.libniveau IS 'Libellé du niveau';

COMMENT ON COLUMN bip.niveau.flaglock IS 'Flag pour la gestion de concurrence';


DROP TABLE bip.notification_logs CASCADE CONSTRAINTS;

--
-- NOTIFICATION_LOGS  (Table) 
--
CREATE TABLE bip.notification_logs
(
  date_log    DATE,
  user_log    VARCHAR2(30),
  dpcode      VARCHAR2(5),
  icpi        VARCHAR2(5),
  metier      VARCHAR2(5),
  dir_me      VARCHAR2(5),
  dir_mo      VARCHAR2(5),
  notifie     NUMBER(12,2),
  reestime    NUMBER(12,2),
  pid         VARCHAR2(4),
  clicode     VARCHAR2(5),
  type_notif  VARCHAR2(30)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.notification_logs IS 'Table de trace de la notification';

COMMENT ON COLUMN bip.notification_logs.date_log IS 'Date de notification';

COMMENT ON COLUMN bip.notification_logs.user_log IS 'Utilisateur notifieur';

COMMENT ON COLUMN bip.notification_logs.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.notification_logs.icpi IS 'Code projet';

COMMENT ON COLUMN bip.notification_logs.metier IS 'Métier';

COMMENT ON COLUMN bip.notification_logs.dir_me IS 'Direction fournisseur';

COMMENT ON COLUMN bip.notification_logs.dir_mo IS 'Direction Client';

COMMENT ON COLUMN bip.notification_logs.notifie IS 'Notifié';

COMMENT ON COLUMN bip.notification_logs.reestime IS 'Réestimé';

COMMENT ON COLUMN bip.notification_logs.pid IS 'identifiant ligne bip';

COMMENT ON COLUMN bip.notification_logs.clicode IS 'Code client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.notification_logs.type_notif IS 'Type de notification effectuée';


ALTER TABLE bip.parametre DROP PRIMARY KEY CASCADE;
DROP TABLE bip.parametre CASCADE CONSTRAINTS;

--
-- PARAMETRE  (Table) 
--
CREATE TABLE bip.parametre
(
  cle            VARCHAR2(64),
  valeur         VARCHAR2(512),
  liste_valeurs  VARCHAR2(1024),
  libelle        VARCHAR2(256)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.parametre IS 'Table de paramètres de l''application BIP';

COMMENT ON COLUMN bip.parametre.liste_valeurs IS 'Liste des valeurs permises du paramètre';

COMMENT ON COLUMN bip.parametre.libelle IS 'Libellé explicatif de l''utilisation du paramètre';

COMMENT ON COLUMN bip.parametre.cle IS 'Identifiant du paramètre';

COMMENT ON COLUMN bip.parametre.valeur IS 'Valeur actuelle du paramètre';


ALTER TABLE bip.partenaire DROP PRIMARY KEY CASCADE;
DROP TABLE bip.partenaire CASCADE CONSTRAINTS;

--
-- PARTENAIRE  (Table) 
--
CREATE TABLE bip.partenaire
(
  coddep   NUMBER(3)                            NOT NULL,
  soccode  VARCHAR(4)                              NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.partenaire IS 'Contient les codes departements et les societes partenaires';

COMMENT ON COLUMN bip.partenaire.coddep IS 'Code departement (=division)';

COMMENT ON COLUMN bip.partenaire.soccode IS 'Code de la société';


DROP TABLE bip.pmw_activite CASCADE CONSTRAINTS;

--
-- PMW_ACTIVITE  (Table) 
--
CREATE TABLE bip.pmw_activite
(
  pid    VARCHAR2(4)                            NOT NULL,
  acet   VARCHAR(2),
  acta   VARCHAR(2),
  acst   VARCHAR(2),
  alot   VARCHAR(6),
  aiet   VARCHAR(6),
  aist   VARCHAR(6),
  asta   VARCHAR(2),
  adeb   DATE,
  afin   DATE,
  ande   DATE,
  anfi   DATE,
  asnom  VARCHAR(15),
  apcp   NUMBER(3),
  adur   NUMBER(5)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512km
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.pmw_activite IS 'Table d''import pmw ACTIVITE';

COMMENT ON COLUMN bip.pmw_activite.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.pmw_activite.acet IS 'Numéro de l''étape';

COMMENT ON COLUMN bip.pmw_activite.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.pmw_activite.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.pmw_activite.alot IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_activite.aiet IS 'Type de l''étape';

COMMENT ON COLUMN bip.pmw_activite.aist IS 'Type de sous tache';

COMMENT ON COLUMN bip.pmw_activite.asta IS 'Statut de la sous tache';

COMMENT ON COLUMN bip.pmw_activite.adeb IS 'Date initiale de début';

COMMENT ON COLUMN bip.pmw_activite.afin IS 'Date initiale de fin';

COMMENT ON COLUMN bip.pmw_activite.ande IS 'Date revisee de debut';

COMMENT ON COLUMN bip.pmw_activite.anfi IS 'Date revisee de fin';

COMMENT ON COLUMN bip.pmw_activite.asnom IS 'Libelle de la sous tache';

COMMENT ON COLUMN bip.pmw_activite.apcp IS 'Pourcentage d''avancement de la ss-tache';

COMMENT ON COLUMN bip.pmw_activite.adur IS 'Duree de la sous tache';


DROP TABLE bip.pmw_affecta CASCADE CONSTRAINTS;

--
-- PMW_AFFECTA  (Table) 
--
CREATE TABLE bip.pmw_affecta
(
  pid    VARCHAR2(4)                            NOT NULL,
  tcet   VARCHAR(2),
  tcta   VARCHAR(2),
  tcst   VARCHAR(2),
  tires  VARCHAR(6),
  tplan  NUMBER(8,2),
  tactu  NUMBER(8,2),
  TEST   NUMBER(8,2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.pmw_affecta IS 'Table d''import pmw AFFECTATION';

COMMENT ON COLUMN bip.pmw_affecta.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.pmw_affecta.tcet IS 'Numéro de l''étape';

COMMENT ON COLUMN bip.pmw_affecta.tcta IS 'Numéro de la tâche';

COMMENT ON COLUMN bip.pmw_affecta.tcst IS 'Numéro de la sous-tâche';

COMMENT ON COLUMN bip.pmw_affecta.tires IS 'Numero de ressource';

COMMENT ON COLUMN bip.pmw_affecta.tplan IS 'Charge planifiee pour la ressource';

COMMENT ON COLUMN bip.pmw_affecta.tactu IS 'Consommation actuelle de la ressource';

COMMENT ON COLUMN bip.pmw_affecta.TEST IS 'Reste a faire pour la ressource';


DROP TABLE bip.pmw_consomm CASCADE CONSTRAINTS;

--
-- PMW_CONSOMM  (Table) 
--
CREATE TABLE bip.pmw_consomm
(
  pid    VARCHAR2(4)                            NOT NULL,
  ccet   VARCHAR(2),
  ccta   VARCHAR(2),
  ccst   VARCHAR(2),
  cires  VARCHAR(6),
  cpct   NUMBER(3),
  cdeb   DATE,
  cdur   NUMBER(8),
  cusag  NUMBER(8,2),
  chtyp  VARCHAR(1)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.pmw_consomm IS 'Table d''import pmw CONSOMMATION';

COMMENT ON COLUMN bip.pmw_consomm.pid IS 'PID de la ligne BIP';

COMMENT ON COLUMN bip.pmw_consomm.ccet IS 'N° etape';

COMMENT ON COLUMN bip.pmw_consomm.ccta IS 'N° tache';

COMMENT ON COLUMN bip.pmw_consomm.ccst IS 'N° sous-tache';

COMMENT ON COLUMN bip.pmw_consomm.cires IS 'Identifiant ressource (avec * à la fin)';

COMMENT ON COLUMN bip.pmw_consomm.cpct IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_consomm.cdeb IS 'Mois annee de reference';

COMMENT ON COLUMN bip.pmw_consomm.cdur IS 'Nombre de jours ouvres du mois (inutilisé)';

COMMENT ON COLUMN bip.pmw_consomm.cusag IS 'Consomme du mois';

COMMENT ON COLUMN bip.pmw_consomm.chtyp IS '0 : charge initial
1 : consommé
2 : reste à faire';


DROP TABLE bip.pmw_ligne_bip CASCADE CONSTRAINTS;

--
-- PMW_LIGNE_BIP  (Table) 
--
CREATE TABLE bip.pmw_ligne_bip
(
  pid         VARCHAR2(4)                       NOT NULL,
  pmwbipvers  VARCHAR(2),
  pname       VARCHAR2(25),
  pprostart   DATE,
  pproend     DATE,
  pcpmdates   VARCHAR(1),
  pmile       VARCHAR(1),
  ppctcmpl    NUMBER(3),
  PRESERVE    VARCHAR(1),
  pasofdate   DATE,
  pcaptstart  DATE,
  pcaptend    DATE,
  filler      VARCHAR(1),
  p_jj_carre  NUMBER(4),
  p_mm_carre  NUMBER(4),
  p_aa_carre  NUMBER(4),
  p_saisie    VARCHAR2(5)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.pmw_ligne_bip IS 'Table d''import pmw LIGNE_BIP';

COMMENT ON COLUMN bip.pmw_ligne_bip.p_saisie IS 'Origine de la saisie des consommés sur cette ligne (RBIP, OSCAR, NIKU, AUTRE)';

COMMENT ON COLUMN bip.pmw_ligne_bip.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.pmw_ligne_bip.pmwbipvers IS 'Numéro de version de la structure du fichier : Egal à 42';

COMMENT ON COLUMN bip.pmw_ligne_bip.pname IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_ligne_bip.pprostart IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_ligne_bip.pproend IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_ligne_bip.pcpmdates IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_ligne_bip.pmile IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_ligne_bip.ppctcmpl IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_ligne_bip.PRESERVE IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_ligne_bip.pasofdate IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_ligne_bip.pcaptstart IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_ligne_bip.pcaptend IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_ligne_bip.filler IS 'pas utilisé';

COMMENT ON COLUMN bip.pmw_ligne_bip.p_jj_carre IS 'Carré du jour de création du fichier';

COMMENT ON COLUMN bip.pmw_ligne_bip.p_mm_carre IS 'Carré du mois de création du fichier';

COMMENT ON COLUMN bip.pmw_ligne_bip.p_aa_carre IS 'Carré de l''année de création du fichier';


ALTER TABLE bip.poste DROP PRIMARY KEY CASCADE;
DROP TABLE bip.poste CASCADE CONSTRAINTS;

--
-- POSTE  (Table) 
--
CREATE TABLE bip.poste
(
  codposte   NUMBER(4)                          NOT NULL,
  lib_poste  VARCHAR2(64)                       NOT NULL,
  flaglock   NUMBER(7)                          DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.poste IS 'Table des postes d''investissements';

COMMENT ON COLUMN bip.poste.codposte IS 'Identifiant du poste correspondant au type d''investissement';

COMMENT ON COLUMN bip.poste.lib_poste IS 'Le libellé correspondant au poste';

COMMENT ON COLUMN bip.poste.flaglock IS 'Flag';


ALTER TABLE bip.prestation DROP PRIMARY KEY CASCADE;
DROP TABLE bip.prestation CASCADE CONSTRAINTS;

--
-- PRESTATION  (Table) 
--
CREATE TABLE bip.prestation
(
  prestation    VARCHAR(3)                         NOT NULL,
  codfi         VARCHAR(2),
  top_actif     VARCHAR(1),
  flaglock      NUMBER(7)                       DEFAULT 0                     NOT NULL,
  libprest      VARCHAR2(60),
  code_domaine  VARCHAR2(2),
  code_acha     VARCHAR2(2),
  rtype         VARCHAR(1)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k 
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.prestation IS 'Table des prestations (qualification)';

COMMENT ON COLUMN bip.prestation.code_domaine IS 'L''identifiant du type de domaine';

COMMENT ON COLUMN bip.prestation.code_acha IS 'Le code acha';

COMMENT ON COLUMN bip.prestation.rtype IS 'Type de ressource : a, p, e, f, l';

COMMENT ON COLUMN bip.prestation.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.prestation.codfi IS 'Code de cout standard de facturation interne';

COMMENT ON COLUMN bip.prestation.top_actif IS 'Top qui indique si la prestation est active (O:Oui,N:Non)';

COMMENT ON COLUMN bip.prestation.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.prestation.libprest IS 'Libellé de la prestation';


ALTER TABLE bip.proj_info DROP PRIMARY KEY CASCADE;
DROP TABLE bip.proj_info CASCADE CONSTRAINTS;

--
-- PROJ_INFO  (Table) 
--
CREATE TABLE bip.proj_info
(
  icpi       VARCHAR(5)                            NOT NULL,
  ilibel     VARCHAR2(50)                       NOT NULL,
  descr      VARCHAR2(305),
  imop       VARCHAR2(20),
  clicode    VARCHAR(5),
  icme       VARCHAR2(20),
  codsg      NUMBER(7),
  icodproj   NUMBER(5),
  icpir      VARCHAR(5)                            NOT NULL,
  statut     VARCHAR(1),
  cada       NUMBER(6),
  datdem     DATE,
  datstatut  DATE,
  flaglock   NUMBER(7)                          DEFAULT 0                     NOT NULL,
  cod_db     NUMBER(3),
  datcre     DATE,
  librpb     VARCHAR2(20),
  idrpb      VARCHAR2(20),
  datprod    DATE,
  datrpro    DATE,
  crireg     VARCHAR2(5),
  deanre     DATE
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k 
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.proj_info IS 'Table des projets informatiques.';

COMMENT ON COLUMN bip.proj_info.idrpb IS 'Nom du RPB';

COMMENT ON COLUMN bip.proj_info.datprod IS 'Date prévue de mise en production';

COMMENT ON COLUMN bip.proj_info.datrpro IS 'Date révisée de mise en production';

COMMENT ON COLUMN bip.proj_info.crireg IS 'Critère de regroupement';

COMMENT ON COLUMN bip.proj_info.deanre IS 'Dernière année de restitution';

COMMENT ON COLUMN bip.proj_info.datcre IS 'Date de création du projet';

COMMENT ON COLUMN bip.proj_info.librpb IS 'Libellé du service du RPB';

COMMENT ON COLUMN bip.proj_info.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.proj_info.ilibel IS 'Libelle projet informatique';

COMMENT ON COLUMN bip.proj_info.descr IS 'Description du projet';

COMMENT ON COLUMN bip.proj_info.imop IS 'Nom de la maîtrise d''ouvrage principale';

COMMENT ON COLUMN bip.proj_info.clicode IS 'Code client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.proj_info.icme IS 'Nom de la maîtrise d''oeuvre principale';

COMMENT ON COLUMN bip.proj_info.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.proj_info.icodproj IS 'Code dossier projet';

COMMENT ON COLUMN bip.proj_info.icpir IS 'Identifiant du projet informatique rattaché';

COMMENT ON COLUMN bip.proj_info.statut IS 'Statut du projet (D:Démarré,A:Abandonné,O:A Immobiliser, vide:en cours)';

COMMENT ON COLUMN bip.proj_info.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.proj_info.datdem IS 'Date de démarrage du projet informatique';

COMMENT ON COLUMN bip.proj_info.datstatut IS 'Date de statut du projet informatique';

COMMENT ON COLUMN bip.proj_info.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.proj_info.cod_db IS 'Code du domaine bancaire';


ALTER TABLE bip.proj_spe DROP PRIMARY KEY CASCADE;
DROP TABLE bip.proj_spe CASCADE CONSTRAINTS;

--
-- PROJ_SPE  (Table) 
--
CREATE TABLE bip.proj_spe
(
  codpspe   VARCHAR(1)                             NOT NULL,
  libpspe   VARCHAR(10)                            NOT NULL,
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.proj_spe IS 'Table des projets speciaux.';

COMMENT ON COLUMN bip.proj_spe.codpspe IS 'Identifiant projet special';

COMMENT ON COLUMN bip.proj_spe.libpspe IS 'Libelle projet special';

COMMENT ON COLUMN bip.proj_spe.flaglock IS 'Flag pour la gestion de concurrence';


DROP TABLE bip.proplus CASCADE CONSTRAINTS;

--
-- PROPLUS  (Table) 
--
CREATE TABLE bip.proplus
(
  factpid     VARCHAR2(4),
  pid         VARCHAR2(4),
  aist        VARCHAR(6),
  aistty      VARCHAR(2),
  tires       NUMBER(5),
  cdeb        DATE,
  ptype       VARCHAR(2),
  factpty     VARCHAR(2),
  pnom        VARCHAR2(30),
  factpno     VARCHAR2(30),
  pdsg        NUMBER(7),
  factpdsg    NUMBER(7),
  pcpi        NUMBER(5),
  factpcp     NUMBER(5),
  pcmouvra    VARCHAR(5),
  factpcm     VARCHAR(5),
  pnmouvra    VARCHAR(15),
  pdatdebpre  DATE,
  cusag       NUMBER(7,2),
  rnom        VARCHAR2(30),
  rprenom     VARCHAR2(15),
  datdep      DATE,
  divsecgrou  NUMBER(7),
  cpident     NUMBER(5),
  cout        NUMBER(12,2),
  matricule   VARCHAR(7),
  societe     VARCHAR(4),
  qualif      VARCHAR(3),
  dispo       NUMBER(2,1),
  chinit      NUMBER(7,2),
  chraf       NUMBER(7,2),
  rtype       VARCHAR(1)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          100m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.proplus IS 'table des consommes pour la sous traitance';

COMMENT ON COLUMN bip.proplus.factpid IS 'Identifiant de la ligne BIP à facturer (est différent de PID dans le cas d''une sous-traitance)';

COMMENT ON COLUMN bip.proplus.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.proplus.aist IS 'Type de sous tache';

COMMENT ON COLUMN bip.proplus.aistty IS '2 premiers caracteres de type sous tache';

COMMENT ON COLUMN bip.proplus.tires IS 'Identifiant ressource';

COMMENT ON COLUMN bip.proplus.cdeb IS 'Mois annee de reference';

COMMENT ON COLUMN bip.proplus.ptype IS 'Type de projet';

COMMENT ON COLUMN bip.proplus.factpty IS 'Type de projet pour le projet recevant la ss-traitance';

COMMENT ON COLUMN bip.proplus.pnom IS 'Libelle du projet';

COMMENT ON COLUMN bip.proplus.factpno IS 'Libelle du projet pour le projet recevant la';

COMMENT ON COLUMN bip.proplus.pdsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.proplus.factpdsg IS 'Code dpg du projet recevant la ss-traitance';

COMMENT ON COLUMN bip.proplus.pcpi IS 'Code du chef de projet';

COMMENT ON COLUMN bip.proplus.factpcp IS 'Code du chef du projet recevant la ss-traitance';

COMMENT ON COLUMN bip.proplus.pcmouvra IS 'Code du client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.proplus.factpcm IS 'Code du client maîtrise d''ouvrage du projet recevant la';

COMMENT ON COLUMN bip.proplus.pnmouvra IS 'Nom du client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.proplus.pdatdebpre IS 'Date prevue de debut de projet';

COMMENT ON COLUMN bip.proplus.cusag IS 'Consomme du mois';

COMMENT ON COLUMN bip.proplus.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.proplus.rprenom IS 'Prenom de la ressource';

COMMENT ON COLUMN bip.proplus.datdep IS 'Date de depart';

COMMENT ON COLUMN bip.proplus.divsecgrou IS 'Code dpg de la ressource';

COMMENT ON COLUMN bip.proplus.cpident IS 'Code du chef de projet';

COMMENT ON COLUMN bip.proplus.cout IS 'Cout journalier ht de la ressource';

COMMENT ON COLUMN bip.proplus.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.proplus.societe IS 'Code societe de la ressource';

COMMENT ON COLUMN bip.proplus.qualif IS 'Qualification de la ressource';

COMMENT ON COLUMN bip.proplus.dispo IS 'Disponibilite en nombre de jours par semaine';

COMMENT ON COLUMN bip.proplus.chinit IS 'Charge initiale du mois';

COMMENT ON COLUMN bip.proplus.chraf IS 'Reste a faire du mois';

COMMENT ON COLUMN bip.proplus.rtype IS 'Type de ressource : p, f, l';


ALTER TABLE bip.ree_activites DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ree_activites CASCADE CONSTRAINTS;

--
-- REE_ACTIVITES  (Table) 
--
CREATE TABLE bip.ree_activites
(
  codsg          NUMBER(7)                      NOT NULL,
  code_activite  VARCHAR2(12)                   NOT NULL,
  lib_activite   VARCHAR2(60),
  TYPE           VARCHAR2(1)                    NOT NULL
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ree_activites IS 'Table des activités de l''outil réestimé';

COMMENT ON COLUMN bip.ree_activites.codsg IS 'Code du DPG';

COMMENT ON COLUMN bip.ree_activites.code_activite IS 'Code  ( libelle court) de l''activite';

COMMENT ON COLUMN bip.ree_activites.lib_activite IS 'Libelle de l''activite';

COMMENT ON COLUMN bip.ree_activites.TYPE IS 'Type de l''activite (A : Absence, F : ss-traitance fournie, N : Normal)';


ALTER TABLE bip.ree_activites_ligne_bip DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ree_activites_ligne_bip CASCADE CONSTRAINTS;

--
-- REE_ACTIVITES_LIGNE_BIP  (Table) 
--
CREATE TABLE bip.ree_activites_ligne_bip
(
  codsg          NUMBER(7)                      NOT NULL,
  code_activite  VARCHAR2(12)                   NOT NULL,
  pid            VARCHAR2(4)                    NOT NULL
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ree_activites_ligne_bip IS 'Table de liaison activités/lignes BIP de l''outil réestimé';

COMMENT ON COLUMN bip.ree_activites_ligne_bip.codsg IS 'Code du DPG';

COMMENT ON COLUMN bip.ree_activites_ligne_bip.code_activite IS 'Code (libelle court) de l''activite';

COMMENT ON COLUMN bip.ree_activites_ligne_bip.pid IS 'Code de la ligne BIP';


ALTER TABLE bip.ree_reestime DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ree_reestime CASCADE CONSTRAINTS;

--
-- REE_REESTIME  (Table) 
--
CREATE TABLE bip.ree_reestime
(
  codsg          NUMBER(7)                      NOT NULL,
  code_scenario  VARCHAR2(12)                   NOT NULL,
  cdeb           DATE                           NOT NULL,
  TYPE           VARCHAR2(1)                    NOT NULL,
  ident          NUMBER(5)                      NOT NULL,
  code_activite  VARCHAR2(12)                   NOT NULL,
  conso_prevu    NUMBER(7,2)
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ree_reestime IS 'Table de saisie du réestimé de l''outil réestimé';

COMMENT ON COLUMN bip.ree_reestime.codsg IS 'Code du DPG';

COMMENT ON COLUMN bip.ree_reestime.code_scenario IS 'Code (libelle court) du scenario';

COMMENT ON COLUMN bip.ree_reestime.cdeb IS 'Date du reestime';

COMMENT ON COLUMN bip.ree_reestime.TYPE IS 'Type de ressource : P : Personne, F : Forfait, X : Fictif, S : Sous-traitance recue';

COMMENT ON COLUMN bip.ree_reestime.ident IS 'Identifiant de la ressource';

COMMENT ON COLUMN bip.ree_reestime.code_activite IS 'Code (libelle court) de l''activite';

COMMENT ON COLUMN bip.ree_reestime.conso_prevu IS 'Consomme prevu en jours/hommes';


ALTER TABLE bip.ree_ressources DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ree_ressources CASCADE CONSTRAINTS;

--
-- REE_RESSOURCES  (Table) 
--
CREATE TABLE bip.ree_ressources
(
  codsg    NUMBER(7)                            NOT NULL,
  TYPE     VARCHAR2(1)                          NOT NULL,
  ident    NUMBER(5),
  rnom     VARCHAR2(30)                         NOT NULL,
  rprenom  VARCHAR2(15),
  datdep   DATE
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ree_ressources IS 'Table des ressources de l''outil réestimé';

COMMENT ON COLUMN bip.ree_ressources.codsg IS 'Code du DPG';

COMMENT ON COLUMN bip.ree_ressources.TYPE IS 'Type de ressource : P : Personne, F : Forfait, X : Fictif, S : Sous-traitance recue';

COMMENT ON COLUMN bip.ree_ressources.ident IS 'Identifiant de la ressource';

COMMENT ON COLUMN bip.ree_ressources.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.ree_ressources.rprenom IS 'Prenom de la ressource';

COMMENT ON COLUMN bip.ree_ressources.datdep IS 'Date de depart';


ALTER TABLE bip.ree_ressources_activites DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ree_ressources_activites CASCADE CONSTRAINTS;

--
-- REE_RESSOURCES_ACTIVITES  (Table) 
--
CREATE TABLE bip.ree_ressources_activites
(
  codsg          NUMBER(7)                      NOT NULL,
  TYPE           VARCHAR2(1)                    NOT NULL,
  ident          NUMBER(5)                      NOT NULL,
  code_activite  VARCHAR2(12)                   NOT NULL,
  tauxrep        NUMBER(5,2)
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ree_ressources_activites IS 'Table de liaison ressources/activités de l''outil réestimé';

COMMENT ON COLUMN bip.ree_ressources_activites.codsg IS 'Code du DPG';

COMMENT ON COLUMN bip.ree_ressources_activites.TYPE IS 'Type de ressource : P : Personne, F : Forfait, X : Fictif';

COMMENT ON COLUMN bip.ree_ressources_activites.ident IS 'Identifiant de la ressource';

COMMENT ON COLUMN bip.ree_ressources_activites.code_activite IS 'Code (libelle court) de l''activite';

COMMENT ON COLUMN bip.ree_ressources_activites.tauxrep IS 'Taux de repartition';


ALTER TABLE bip.ree_scenarios DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ree_scenarios CASCADE CONSTRAINTS;

--
-- REE_SCENARIOS  (Table) 
--
CREATE TABLE bip.ree_scenarios
(
  codsg          NUMBER(7)                      NOT NULL,
  code_scenario  VARCHAR2(12)                   NOT NULL,
  lib_scenario   VARCHAR2(60),
  officiel       VARCHAR2(1)                    DEFAULT 'O'                   NOT NULL,
  commentaire    VARCHAR2(500)
)
TABLESPACE tbs_bip_isac_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ree_scenarios IS 'Table des scénarios de l''outil réestimé';

COMMENT ON COLUMN bip.ree_scenarios.codsg IS 'Code du DPG';

COMMENT ON COLUMN bip.ree_scenarios.code_scenario IS 'Code (libelle court) du scenario';

COMMENT ON COLUMN bip.ree_scenarios.lib_scenario IS 'Libelle du scenario';

COMMENT ON COLUMN bip.ree_scenarios.officiel IS 'Definit si le scenario est officiel (publiable) O : Officiel, N : Non Officiel';

COMMENT ON COLUMN bip.ree_scenarios.commentaire IS 'Zone de commentaires';


ALTER TABLE bip.ref_histo DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ref_histo CASCADE CONSTRAINTS;

--
-- REF_HISTO  (Table) 
--
CREATE TABLE bip.ref_histo
(
  mois        DATE                              NOT NULL,
  nom_schema  VARCHAR2(10)                      NOT NULL
)
TABLESPACE tbs_bip_his_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ref_histo IS 'Liste des 14 environnements d''historisation BIPHISTSUN - Permet de donner la date d''historisation des 14 schémas';

COMMENT ON COLUMN bip.ref_histo.mois IS 'Mois d''historisation';

COMMENT ON COLUMN bip.ref_histo.nom_schema IS 'Nom du schéma correspondant';


ALTER TABLE bip.remontee DROP PRIMARY KEY CASCADE;
DROP TABLE bip.remontee CASCADE CONSTRAINTS;

--
-- REMONTEE  (Table) 
--
CREATE TABLE bip.remontee
(
  pid           VARCHAR(4)                         NOT NULL,
  id_remonteur  VARCHAR2(20)                    NOT NULL,
  fichier_data  VARCHAR2(256)                   NOT NULL,
  DATA          CLOB,
  erreur        CLOB,
  statut        NUMBER(1)                       NOT NULL,
  statut_date   DATE                            NOT NULL,
  statut_info   VARCHAR2(512)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
LOB (DATA) STORE AS
      ( TABLESPACE  tbs_bip_lob_data
        ENABLE      STORAGE IN ROW
        CHUNK       8192
        PCTVERSION  10
        NOCACHE
        STORAGE    (
                    INITIAL          1m
                    NEXT             512k
                    MINEXTENTS       1
                    MAXEXTENTS       500
                    PCTINCREASE      0
                    FREELISTS        1
                    FREELIST GROUPS  1
                    BUFFER_POOL      DEFAULT
                   )
      )
  LOB (erreur) STORE AS
      ( TABLESPACE  tbs_bip_lob_data
        ENABLE      STORAGE IN ROW
        CHUNK       8192
        PCTVERSION  10
        NOCACHE
        STORAGE    (
                    INITIAL          1m
                    NEXT             512k
                    MINEXTENTS       1
                    MAXEXTENTS       500
                    PCTINCREASE      0
                    FREELISTS        1
                    FREELIST GROUPS  1
                    BUFFER_POOL      DEFAULT
                   )
      )
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.remontee IS 'Table des données traitées par la remontée BIP intranet';

COMMENT ON COLUMN bip.remontee.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.remontee.id_remonteur IS 'Identifiant de l''utilisateur ayant soumis le fichier';

COMMENT ON COLUMN bip.remontee.fichier_data IS 'Nom du fichier de données (fichier .bip)';

COMMENT ON COLUMN bip.remontee.DATA IS 'Contenu du fichier de données';

COMMENT ON COLUMN bip.remontee.erreur IS 'Liste des messages d''erreurs généres par le traitement';

COMMENT ON COLUMN bip.remontee.statut IS 'Statut de la remontée';

COMMENT ON COLUMN bip.remontee.statut_date IS 'Date du statut de la remontée';

COMMENT ON COLUMN bip.remontee.statut_info IS 'pas utilisé';


ALTER TABLE bip.repartition_ligne DROP PRIMARY KEY CASCADE;
DROP TABLE bip.repartition_ligne CASCADE CONSTRAINTS;

--
-- REPARTITION_LIGNE  (Table) 
--
CREATE TABLE bip.repartition_ligne
(
  pid      VARCHAR2(4)                          NOT NULL,
  codcamo  NUMBER(6)                            NOT NULL,
  clicode  VARCHAR2(5),
  tauxrep  NUMBER(5,2)                          NOT NULL,
  datdeb   DATE                                 NOT NULL,
  datfin   DATE
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.repartition_ligne IS 'Indique la répartition sur les différents centres d''activités des lignes BIP multi-ca ';

COMMENT ON COLUMN bip.repartition_ligne.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.repartition_ligne.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.repartition_ligne.clicode IS 'Code client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.repartition_ligne.tauxrep IS 'Taux de répartition';

COMMENT ON COLUMN bip.repartition_ligne.datdeb IS 'Date de début';

COMMENT ON COLUMN bip.repartition_ligne.datfin IS 'Date de fin';


DROP TABLE bip.report_log CASCADE CONSTRAINTS;

--
-- REPORT_LOG  (Table) 
--
CREATE TABLE bip.report_log
(
  fichier_rdf  VARCHAR2(30)                     NOT NULL,
  id_user      VARCHAR2(60)                     NOT NULL,
  date_log     DATE                             NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.report_log IS 'Table de trace du lancement des états par les utilisateurs';

COMMENT ON COLUMN bip.report_log.fichier_rdf IS 'Nom du report utilisé';

COMMENT ON COLUMN bip.report_log.id_user IS 'Identifiant de l''utilisateur ayant lancé le report';

COMMENT ON COLUMN bip.report_log.date_log IS 'Date Heure du lancement';


ALTER TABLE bip.requete DROP PRIMARY KEY CASCADE;
DROP TABLE bip.requete CASCADE CONSTRAINTS;

--
-- REQUETE  (Table) 
--
CREATE TABLE bip.requete
(
  libelle      VARCHAR2(80)                     NOT NULL,
  nb_data      NUMBER(3)                        NOT NULL,
  nom_fichier  VARCHAR2(8)                      NOT NULL,
  nom_donnees  VARCHAR2(2000)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.requete IS 'Table des requetes SQL pour les extractions paramétrables.';

COMMENT ON COLUMN bip.requete.libelle IS 'Libellé de la requête (pour l''IHM)';

COMMENT ON COLUMN bip.requete.nb_data IS 'Nombre de données retournées par la requête';

COMMENT ON COLUMN bip.requete.nom_fichier IS 'Nom du fichier généré (identifiant de la requete)';

COMMENT ON COLUMN bip.requete.nom_donnees IS 'Nom des données pour l''entête des colonnes';


DROP TABLE bip.requete_profil CASCADE CONSTRAINTS;

--
-- REQUETE_PROFIL  (Table) 
--
CREATE TABLE bip.requete_profil
(
  nom_fichier      VARCHAR2(8)                  NOT NULL,
  code_profil      VARCHAR2(8)                  NOT NULL,
  sous_menu_plus   VARCHAR2(10),
  sous_menu_moins  VARCHAR2(10)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.requete_profil IS 'Permet de définir pour quels menus sont accessibles les requêtes paramétrables (audits fonctionnels)';

COMMENT ON COLUMN bip.requete_profil.sous_menu_moins IS 'Nom du sous-menu ne pouvant pas utiliser la requête';

COMMENT ON COLUMN bip.requete_profil.nom_fichier IS 'Nom du fichier généré (identifiant de la requete)';

COMMENT ON COLUMN bip.requete_profil.code_profil IS 'Nom du menu utilisant la requête';

COMMENT ON COLUMN bip.requete_profil.sous_menu_plus IS 'Nom du sous-menu pouvant utiliser la requête';


ALTER TABLE bip.ressource DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ressource CASCADE CONSTRAINTS;

--
-- RESSOURCE  (Table) 
--
CREATE TABLE bip.ressource
(
  ident      NUMBER(5)                          NOT NULL,
  rnom       VARCHAR2(30)                       NOT NULL,
  rprenom    VARCHAR2(15),
  matricule  VARCHAR(7),
  coutot     NUMBER(12,2),
  rtel       VARCHAR(6),
  batiment   VARCHAR(1),
  etage      VARCHAR(2),
  bureau     VARCHAR(3),
  flaglock   NUMBER(7)                          DEFAULT 0                     NOT NULL,
  rtype      VARCHAR(1)                            NOT NULL,
  icodimm    VARCHAR(5)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          20m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ressource IS 'Table des ressources.';

COMMENT ON COLUMN bip.ressource.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.ressource.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.ressource.rprenom IS 'Prenom de la ressource';

COMMENT ON COLUMN bip.ressource.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.ressource.coutot IS 'Cout totale de la ressource';

COMMENT ON COLUMN bip.ressource.rtel IS 'Numero de telephone';

COMMENT ON COLUMN bip.ressource.batiment IS 'Numero du batiment (zone)';

COMMENT ON COLUMN bip.ressource.etage IS 'Numero de l''etage';

COMMENT ON COLUMN bip.ressource.bureau IS 'Numero du bureau';

COMMENT ON COLUMN bip.ressource.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.ressource.rtype IS 'Type de ressource : p, f, l';

COMMENT ON COLUMN bip.ressource.icodimm IS 'Code de l''immeuble';


ALTER TABLE bip.ressource_ecart DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ressource_ecart CASCADE CONSTRAINTS;

--
-- RESSOURCE_ECART  (Table) 
--
CREATE TABLE bip.ressource_ecart
(
  ident        NUMBER(5)                        NOT NULL,
  cdeb         DATE                             NOT NULL,
  TYPE         VARCHAR2(15)                     NOT NULL,
  nbjbip       NUMBER(7,2),
  nbjgersh     NUMBER(7,2),
  nbjmois      NUMBER(7,2),
  valide       VARCHAR(1),
  commentaire  VARCHAR2(255)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ressource_ecart IS 'Table des consommés saisis des ressources ayant des écarts';

COMMENT ON COLUMN bip.ressource_ecart.ident IS 'Identifiant de la ressource';

COMMENT ON COLUMN bip.ressource_ecart.cdeb IS 'Date de prestation';

COMMENT ON COLUMN bip.ressource_ecart.TYPE IS 'Type de l''écart : TOTAL, CONGES : CONGES et RTT, ABSDIV ';

COMMENT ON COLUMN bip.ressource_ecart.nbjbip IS 'Nombre de jours dans la bip';

COMMENT ON COLUMN bip.ressource_ecart.nbjgersh IS 'Nombre de jours dans Gershwin';

COMMENT ON COLUMN bip.ressource_ecart.nbjmois IS 'Nombre de jours de mois';

COMMENT ON COLUMN bip.ressource_ecart.valide IS 'Type de vaildation O : écart validé, N : écart non validé';

COMMENT ON COLUMN bip.ressource_ecart.commentaire IS 'Commentaire de l''écart';


ALTER TABLE bip.ressource_ecart_1 DROP PRIMARY KEY CASCADE;
DROP TABLE bip.ressource_ecart_1 CASCADE CONSTRAINTS;

--
-- RESSOURCE_ECART_1  (Table) 
--
CREATE TABLE bip.ressource_ecart_1
(
  ident        NUMBER(5)                        NOT NULL,
  cdeb         DATE                             NOT NULL,
  TYPE         VARCHAR2(15)                     NOT NULL,
  nbjbip       NUMBER(7,2),
  nbjgersh     NUMBER(7,2),
  nbjmois      NUMBER(7,2),
  valide       VARCHAR(1),
  commentaire  VARCHAR2(255)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.ressource_ecart_1 IS 'Table des consommés saisis des ressources ayant des écarts (mois précédent)';

COMMENT ON COLUMN bip.ressource_ecart_1.ident IS 'Identifiant de la ressource';

COMMENT ON COLUMN bip.ressource_ecart_1.cdeb IS 'Date de prestation';

COMMENT ON COLUMN bip.ressource_ecart_1.TYPE IS 'Type de l''écart : TOTAL, CONGES : CONGES et RTT, ABSDIV ';

COMMENT ON COLUMN bip.ressource_ecart_1.nbjbip IS 'Nombre de jours dans la bip';

COMMENT ON COLUMN bip.ressource_ecart_1.nbjgersh IS 'Nombre de jours dans Gershwin';

COMMENT ON COLUMN bip.ressource_ecart_1.nbjmois IS 'Nombre de jours de mois';

COMMENT ON COLUMN bip.ressource_ecart_1.valide IS 'Type de vaildation O : écart validé, N : écart non validé';

COMMENT ON COLUMN bip.ressource_ecart_1.commentaire IS 'Commentaire de l''écart';


ALTER TABLE bip.rjh_chargement DROP PRIMARY KEY CASCADE;
DROP TABLE bip.rjh_chargement CASCADE CONSTRAINTS;

--
-- RJH_CHARGEMENT  (Table) 
--
CREATE TABLE bip.rjh_chargement
(
  codchr   NUMBER(6)                            NOT NULL,
  codrep   VARCHAR2(12)                         NOT NULL,
  moisrep  DATE                                 NOT NULL,
  fichier  VARCHAR2(50)                         NOT NULL,
  statut   NUMBER(1)                            NOT NULL,
  datechg  DATE                                 NOT NULL,
  userid   VARCHAR2(10)                         NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.rjh_chargement IS 'Cette table liste tous les chargements de table de répartition effectués';

COMMENT ON COLUMN bip.rjh_chargement.codchr IS 'Identifiant du chargement (numéro séquentiel)';

COMMENT ON COLUMN bip.rjh_chargement.codrep IS 'Code de la table de répartition';

COMMENT ON COLUMN bip.rjh_chargement.moisrep IS 'Mois/Année de la table de répartition';

COMMENT ON COLUMN bip.rjh_chargement.fichier IS 'Nom du fichier chargé';

COMMENT ON COLUMN bip.rjh_chargement.statut IS 'Statut du chargement, 0 : pris en compte, 1 : en cours, 2 : terminé, 9 : en erreur';

COMMENT ON COLUMN bip.rjh_chargement.datechg IS 'Date du dernier statut';

COMMENT ON COLUMN bip.rjh_chargement.userid IS 'Identifiant de l''utilisateur ayant chargé le fichier';


ALTER TABLE bip.rjh_charg_erreur DROP PRIMARY KEY CASCADE;
DROP TABLE bip.rjh_charg_erreur CASCADE CONSTRAINTS;

--
-- RJH_CHARG_ERREUR  (Table) 
--
CREATE TABLE bip.rjh_charg_erreur
(
  codchr    NUMBER(6)                           NOT NULL,
  numligne  NUMBER(4)                           NOT NULL,
  txtligne  VARCHAR2(300)                       NOT NULL,
  liberr    VARCHAR2(2000)                      NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.rjh_charg_erreur IS 'Cette table liste les erreurs de chargement des fichiers de tables de répartition';

COMMENT ON COLUMN bip.rjh_charg_erreur.codchr IS 'Identifiant du chargement';

COMMENT ON COLUMN bip.rjh_charg_erreur.numligne IS 'Numéro de la ligne en erreur dans le fichier de chargement';

COMMENT ON COLUMN bip.rjh_charg_erreur.txtligne IS 'Texte de la ligne en erreur';

COMMENT ON COLUMN bip.rjh_charg_erreur.liberr IS 'Descriptions des erreurs';


ALTER TABLE bip.rjh_consomme DROP PRIMARY KEY CASCADE;
DROP TABLE bip.rjh_consomme CASCADE CONSTRAINTS;

--
-- RJH_CONSOMME  (Table) 
--
CREATE TABLE bip.rjh_consomme
(
  pid          VARCHAR2(4)                      NOT NULL,
  ident        NUMBER(5)                        NOT NULL,
  cdeb         DATE                             NOT NULL,
  pid_origine  VARCHAR2(4)                      NOT NULL,
  consojh      NUMBER(12,7)                     DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.rjh_consomme IS 'Cette table permet de stocker avec toute la précision requise le consommé d''une ressource réparti sur une ligne BIP de répartition';

COMMENT ON COLUMN bip.rjh_consomme.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.rjh_consomme.ident IS 'Identifiant de la ressource';

COMMENT ON COLUMN bip.rjh_consomme.cdeb IS 'Mois/Année de référence';

COMMENT ON COLUMN bip.rjh_consomme.pid_origine IS 'Identifiant de la ligne BIP d''origine';

COMMENT ON COLUMN bip.rjh_consomme.consojh IS 'Consommé en Jours Hommes';


ALTER TABLE bip.rjh_ias DROP PRIMARY KEY CASCADE;
DROP TABLE bip.rjh_ias CASCADE CONSTRAINTS;

--
-- RJH_IAS  (Table) 
--
CREATE TABLE bip.rjh_ias
(
  cdeb        DATE                              NOT NULL,
  pid         VARCHAR2(4)                       NOT NULL,
  ident       NUMBER(5)                         NOT NULL,
  typproj     VARCHAR(2),
  metier      VARCHAR2(3),
  pnom        VARCHAR2(30),
  codsg       NUMBER(7),
  dpcode      NUMBER(5),
  icpi        VARCHAR(5),
  codcamo     NUMBER(6),
  clibrca     VARCHAR(16),
  cafi        NUMBER(6),
  codsgress   NUMBER(7),
  libdsg      VARCHAR2(30),
  rnom        VARCHAR2(30),
  rtype       VARCHAR(1),
  prestation  VARCHAR(3),
  niveau      VARCHAR2(2),
  soccode     VARCHAR(4),
  cada        NUMBER(6),
  coutftht    NUMBER(12,2),
  coutft      NUMBER(12,2),
  coutenv     NUMBER(12,2),
  consojh     NUMBER(12,7),
  consoft     NUMBER(12,4),
  consoenv    NUMBER(12,4)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.rjh_ias IS 'Table de travail du traitement mensuel IAS (Facturation interne et immobilisations) dédiée aux lignes BIP de type 9 (répartition jh)';

COMMENT ON COLUMN bip.rjh_ias.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.rjh_ias.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.rjh_ias.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.rjh_ias.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.rjh_ias.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.rjh_ias.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.rjh_ias.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.rjh_ias.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.rjh_ias.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.rjh_ias.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.rjh_ias.clibrca IS 'Libellé du centre d''activité du client payeur';

COMMENT ON COLUMN bip.rjh_ias.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.rjh_ias.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.rjh_ias.libdsg IS 'Libellé du département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.rjh_ias.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.rjh_ias.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.rjh_ias.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.rjh_ias.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.rjh_ias.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.rjh_ias.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.rjh_ias.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.rjh_ias.coutft IS 'Coût force de travail (en hors taxes récupérable)';

COMMENT ON COLUMN bip.rjh_ias.coutenv IS 'Coût d''environnement (en hors taxes récupérable)';

COMMENT ON COLUMN bip.rjh_ias.consojh IS 'Consommé du mois en jours hommes';

COMMENT ON COLUMN bip.rjh_ias.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.rjh_ias.consoenv IS 'Consommé charge d''environnement du mois en euros hors taxes récupérable';


ALTER TABLE bip.rjh_tabrepart DROP PRIMARY KEY CASCADE;
DROP TABLE bip.rjh_tabrepart CASCADE CONSTRAINTS;

--
-- RJH_TABREPART  (Table) 
--
CREATE TABLE bip.rjh_tabrepart
(
  codrep     VARCHAR2(12)                       NOT NULL,
  librep     VARCHAR2(250)                      NOT NULL,
  coddir     NUMBER(2)                          NOT NULL,
  flagactif  VARCHAR(1)                            DEFAULT 'O'                   NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.rjh_tabrepart IS 'Tables de répartition - Utilisation dans le cadre de la répartition des jours-hommes sur les lignes BIP de type 9';

COMMENT ON COLUMN bip.rjh_tabrepart.codrep IS 'Code de la table de répartition';

COMMENT ON COLUMN bip.rjh_tabrepart.librep IS 'Libellé de la table de répartition';

COMMENT ON COLUMN bip.rjh_tabrepart.coddir IS 'Code de la direction à laquelle est rattachée la table de répartition';

COMMENT ON COLUMN bip.rjh_tabrepart.flagactif IS 'Statut de la table de répartition, O : active, N : inactive';


ALTER TABLE bip.rjh_tabrepart_detail DROP PRIMARY KEY CASCADE;
DROP TABLE bip.rjh_tabrepart_detail CASCADE CONSTRAINTS;

--
-- RJH_TABREPART_DETAIL  (Table) 
--
CREATE TABLE bip.rjh_tabrepart_detail
(
  codrep       VARCHAR2(12)                     NOT NULL,
  moisrep      DATE                             NOT NULL,
  pid          VARCHAR2(4)                      NOT NULL,
  tauxrep      NUMBER(6,5)                      DEFAULT 0                     NOT NULL,
  liblignerep  VARCHAR2(250),
  typtab       VARCHAR2(1)                      DEFAULT 'P'
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.rjh_tabrepart_detail IS 'Cette table liste le détail des tables de répartition (mois, ligne bip et taux de répartition affectés à cette table).';

COMMENT ON COLUMN bip.rjh_tabrepart_detail.codrep IS 'Code de la table de répartition';

COMMENT ON COLUMN bip.rjh_tabrepart_detail.moisrep IS 'Mois/Année de la table de répartition';

COMMENT ON COLUMN bip.rjh_tabrepart_detail.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.rjh_tabrepart_detail.tauxrep IS 'Taux de répartition compris entre 0 et 1';

COMMENT ON COLUMN bip.rjh_tabrepart_detail.liblignerep IS 'Libellé de la ligne de répartition';

COMMENT ON COLUMN bip.rjh_tabrepart_detail.typtab IS 'Type de table de répartition "P":Proposés "A":Arbitrés';


DROP TABLE bip.rtfe CASCADE CONSTRAINTS;

--
-- RTFE  (Table) 
--
CREATE TABLE bip.rtfe
(
  ident         NUMBER(5),
  user_rtfe     VARCHAR2(60),
  nom           VARCHAR2(30),
  prenom        VARCHAR2(30),
  ROLE          VARCHAR2(20),
  menus         VARCHAR2(200),
  ss_menus      VARCHAR2(200),
  bddpg_defaut  VARCHAR2(30),
  perim_me      VARCHAR2(500),
  chef_projet   VARCHAR2(500),
  mo_defaut     VARCHAR2(30),
  perim_mo      VARCHAR2(500),
  centre_frais  VARCHAR2(50),
  ca_suivi      VARCHAR2(200),
  projet        VARCHAR2(200),
  appli         VARCHAR2(200),
  ca_fi         VARCHAR2(200),
  ca_payeur     VARCHAR2(200),
  doss_proj     VARCHAR2(200)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.rtfe IS 'Table contenant le détail des habilitations déclarées dans le RTFE.';

COMMENT ON COLUMN bip.rtfe.ident IS 'Identifiant BIP de la ressource';

COMMENT ON COLUMN bip.rtfe.user_rtfe IS 'Identifiant RTFE de la ressource';

COMMENT ON COLUMN bip.rtfe.nom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.rtfe.prenom IS 'Prénom de la ressource';

COMMENT ON COLUMN bip.rtfe.ROLE IS 'Role (ADMINISTRATEUR, MO, ME, ORDONNANCEMENT, SAISIE_REALISE, SUIVI_INV, SUIVI_PROJET';

COMMENT ON COLUMN bip.rtfe.menus IS 'Liste des menus habilités';

COMMENT ON COLUMN bip.rtfe.ss_menus IS 'Liste des sous-menus habilités';

COMMENT ON COLUMN bip.rtfe.bddpg_defaut IS 'Structure ME défaut sur 11 caractères : Branche (2) , Direction (2), Département (3) , Pole (2) , Groupe (2)';

COMMENT ON COLUMN bip.rtfe.perim_me IS 'Périmètre ME : Liste de BDDPG séparés par des virgules';

COMMENT ON COLUMN bip.rtfe.chef_projet IS 'Listes des Identifiants BIP des chefs de projet pour lesquels on effectue la saisie directe des consommés dans la BIP';

COMMENT ON COLUMN bip.rtfe.mo_defaut IS 'Structure MO par défaut sur 5 caracteres';

COMMENT ON COLUMN bip.rtfe.perim_mo IS 'Périmetre MO : Liste de Branches (2) , Directions (2) , Structures MO (5) séparés par des virgules';

COMMENT ON COLUMN bip.rtfe.centre_frais IS 'Liste des centres de frais autorisés';

COMMENT ON COLUMN bip.rtfe.ca_suivi IS 'Centres d''activités utilisés dans le suivi des investissements';

COMMENT ON COLUMN bip.rtfe.projet IS 'Liste des projets utilisés dans le suivi par référentiel';

COMMENT ON COLUMN bip.rtfe.appli IS 'Liste des applications utiliséés dans le suivi par référentiel';

COMMENT ON COLUMN bip.rtfe.ca_fi IS 'Liste des Centres d''activité Fournisseur utilisés dans le suivi par référentiel';

COMMENT ON COLUMN bip.rtfe.ca_payeur IS 'Liste des Centres d''activité Client Payeur utilisés dans le suivi par référentiel';

COMMENT ON COLUMN bip.rtfe.doss_proj IS 'Liste des Dossiers projets utilisés dans le suivi par référentiel';


DROP TABLE bip.rtfe_error CASCADE CONSTRAINTS;

--
-- RTFE_ERROR  (Table) 
--
CREATE TABLE bip.rtfe_error
(
  user_rtfe     VARCHAR2(60),
  nom           VARCHAR2(30),
  prenom        VARCHAR2(30),
  ROLE          VARCHAR2(20),
  menus         VARCHAR2(200),
  ss_menus      VARCHAR2(200),
  bddpg_defaut  VARCHAR2(30),
  perim_me      VARCHAR2(500),
  chef_projet   VARCHAR2(500),
  mo_defaut     VARCHAR2(30),
  perim_mo      VARCHAR2(500),
  centre_frais  VARCHAR2(50),
  ca_suivi      VARCHAR2(200),
  projet        VARCHAR2(200),
  appli         VARCHAR2(200),
  ca_fi         VARCHAR2(200),
  ca_payeur     VARCHAR2(200),
  doss_proj     VARCHAR2(200)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.rtfe_error IS 'Table contenant les habilitations RTFE correspondant à des utilisateurs dont on n''a pas retrouvé l''identifiant dans la BIP';

COMMENT ON COLUMN bip.rtfe_error.user_rtfe IS 'Identifiant RTFE de la ressource';

COMMENT ON COLUMN bip.rtfe_error.nom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.rtfe_error.prenom IS 'Prénom de la ressource';

COMMENT ON COLUMN bip.rtfe_error.ROLE IS 'Role (ADMINISTRATEUR, MO, ME, ORDONNANCEMENT, SAISIE_REALISE, SUIVI_INV, SUIVI_PROJET';

COMMENT ON COLUMN bip.rtfe_error.menus IS 'Liste des menus habilités';

COMMENT ON COLUMN bip.rtfe_error.ss_menus IS 'Liste des sous-menus habilités';

COMMENT ON COLUMN bip.rtfe_error.bddpg_defaut IS 'Structure ME défaut sur 11 caractères : Branche (2) , Direction (2), Département (3) , Pole (2) , Groupe (2)';

COMMENT ON COLUMN bip.rtfe_error.perim_me IS 'Périmètre ME : Liste de BDDPG séparés par des virgules';

COMMENT ON COLUMN bip.rtfe_error.chef_projet IS 'Listes des Identifiants BIP des chefs de projet pour lesquels on effectue la saisie directe des consommés dans la BIP';

COMMENT ON COLUMN bip.rtfe_error.mo_defaut IS 'Structure MO par défaut sur 5 caracteres';

COMMENT ON COLUMN bip.rtfe_error.perim_mo IS 'Périmetre MO : Liste de Branches (2) , Directions (2) , Structures MO (5) séparés par des virgules';

COMMENT ON COLUMN bip.rtfe_error.centre_frais IS 'Liste des centres de frais autorisés';

COMMENT ON COLUMN bip.rtfe_error.ca_suivi IS 'Centres d''activités utilisés dans le suivi des investissements';

COMMENT ON COLUMN bip.rtfe_error.projet IS 'Liste des projets utilisés dans le suivi par référentiel';

COMMENT ON COLUMN bip.rtfe_error.appli IS 'Liste des applications utiliséés dans le suivi par référentiel';

COMMENT ON COLUMN bip.rtfe_error.ca_fi IS 'Liste des Centres d''activité Fournisseur utilisés dans le suivi par référentiel';

COMMENT ON COLUMN bip.rtfe_error.ca_payeur IS 'Liste des Centres d''activité Client Payeur utilisés dans le suivi par référentiel';

COMMENT ON COLUMN bip.rtfe_error.doss_proj IS 'Liste des Dossiers projets utilisés dans le suivi par référentiel';


ALTER TABLE bip.rtfe_log DROP PRIMARY KEY CASCADE;
DROP TABLE bip.rtfe_log CASCADE CONSTRAINTS;

--
-- RTFE_LOG  (Table) 
--
CREATE TABLE bip.rtfe_log
(
  user_rtfe      VARCHAR2(60),
  mois           DATE,
  nbr_connexion  NUMBER
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.rtfe_log IS 'Table contient le nombre de connexion pour chaque utilisateur et par mois';

COMMENT ON COLUMN bip.rtfe_log.user_rtfe IS ' l''identifiant RTFE';

COMMENT ON COLUMN bip.rtfe_log.mois IS 'le mois ';

COMMENT ON COLUMN bip.rtfe_log.nbr_connexion IS 'Nombre de conexion du mois ';


ALTER TABLE bip.rubrique DROP PRIMARY KEY CASCADE;
DROP TABLE bip.rubrique CASCADE CONSTRAINTS;

--
-- RUBRIQUE  (Table) 
--
CREATE TABLE bip.rubrique
(
  codrub        NUMBER(5)                       NOT NULL,
  coddir        NUMBER(2)                       NOT NULL,
  codep         NUMBER(5)                       NOT NULL,
  codfei        NUMBER(1)                       NOT NULL,
  cafi          NUMBER(6)                       NOT NULL,
  comptedeb     NUMBER(10)                      NOT NULL,
  comptecre     NUMBER(10)                      NOT NULL,
  schemacpt     NUMBER(5)                       NOT NULL,
  appli         VARCHAR2(10)                    NOT NULL,
  datedemande   DATE,
  dateretour    DATE,
  commentaires  VARCHAR2(100),
  flaglock      NUMBER(7)                       DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.rubrique IS 'Table qui contient les rubriques';

COMMENT ON COLUMN bip.rubrique.codrub IS 'code rubrique FI';

COMMENT ON COLUMN bip.rubrique.coddir IS 'Code de la direction';

COMMENT ON COLUMN bip.rubrique.codep IS 'Code élément de pilotage';

COMMENT ON COLUMN bip.rubrique.codfei IS 'Code CODFEI';

COMMENT ON COLUMN bip.rubrique.cafi IS 'Métier';

COMMENT ON COLUMN bip.rubrique.comptedeb IS 'numéro du compte FI à débiter';

COMMENT ON COLUMN bip.rubrique.comptecre IS 'numéro du compte FI à créditer';

COMMENT ON COLUMN bip.rubrique.schemacpt IS 'code du schéma comptable';

COMMENT ON COLUMN bip.rubrique.appli IS 'nom application (ici BIP)';

COMMENT ON COLUMN bip.rubrique.datedemande IS 'date de la demande création';

COMMENT ON COLUMN bip.rubrique.dateretour IS 'date de confirmation création';

COMMENT ON COLUMN bip.rubrique.commentaires IS 'zone libre ¿commentaires';

COMMENT ON COLUMN bip.rubrique.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.rubrique_metier DROP PRIMARY KEY CASCADE;
DROP TABLE bip.rubrique_metier CASCADE CONSTRAINTS;

--
-- RUBRIQUE_METIER  (Table) 
--
CREATE TABLE bip.rubrique_metier
(
  codep   NUMBER(5)                             NOT NULL,
  codfei  NUMBER(1)                             NOT NULL,
  metier  VARCHAR2(3)                           NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.rubrique_metier IS 'Table permettant de lister les métiers autorisés pour les rubriques de facturation interne';

COMMENT ON COLUMN bip.rubrique_metier.codep IS 'Code élément de pilotage';

COMMENT ON COLUMN bip.rubrique_metier.codfei IS 'Code CDOFEI transmis à la facturation interne : 3,4,5,6,7,8';

COMMENT ON COLUMN bip.rubrique_metier.metier IS 'Métier autorisé pour cette rubrique';


ALTER TABLE bip.situ_ress DROP PRIMARY KEY CASCADE;
DROP TABLE bip.situ_ress CASCADE CONSTRAINTS;

--
-- SITU_RESS  (Table) 
--
CREATE TABLE bip.situ_ress
(
  datsitu          DATE                         NOT NULL,
  datdep           DATE,
  cpident          NUMBER(5),
  cout             NUMBER(12,2),
  dispo            NUMBER(2,1),
  marsg2           VARCHAR(22),
  rmcomp           NUMBER(1),
  prestation       VARCHAR(3),
  dprest           VARCHAR(3),
  ident            NUMBER(5)                    NOT NULL,
  soccode          VARCHAR(4),
  codsg            NUMBER(7)                    NOT NULL,
  niveau           VARCHAR2(2),
  montant_mensuel  NUMBER(12,2)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.situ_ress IS 'Table des situations des ressources.';

COMMENT ON COLUMN bip.situ_ress.datsitu IS 'Date de valeur de la situation';

COMMENT ON COLUMN bip.situ_ress.datdep IS 'Date de depart';

COMMENT ON COLUMN bip.situ_ress.cpident IS 'Code du chef de projet';

COMMENT ON COLUMN bip.situ_ress.cout IS 'Cout journalier ht de la ressource';

COMMENT ON COLUMN bip.situ_ress.dispo IS 'Disponibilite en nombre de jours par semaine';

COMMENT ON COLUMN bip.situ_ress.marsg2 IS 'Numero de marche SG2';

COMMENT ON COLUMN bip.situ_ress.rmcomp IS 'Code poste';

COMMENT ON COLUMN bip.situ_ress.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.situ_ress.dprest IS 'Nouvelle prestation (qualification)';

COMMENT ON COLUMN bip.situ_ress.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.situ_ress.soccode IS 'Identifiant societe';

COMMENT ON COLUMN bip.situ_ress.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.situ_ress.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.situ_ress.montant_mensuel IS 'Montant mensuel dans le cas de la facturation au 12ème';


DROP TABLE bip.situ_ress_full CASCADE CONSTRAINTS;

--
-- SITU_RESS_FULL  (Table) 
--
CREATE TABLE bip.situ_ress_full
(
  datsitu          DATE,
  datdep           DATE,
  cpident          NUMBER(5),
  cout             NUMBER(12,2),
  dispo            NUMBER(2,1),
  marsg2           VARCHAR(22),
  rmcomp           NUMBER(1),
  prestation       VARCHAR(3),
  dprest           VARCHAR(3),
  ident            NUMBER(5)                    NOT NULL,
  soccode          VARCHAR(4),
  codsg            NUMBER(7),
  type_situ        VARCHAR(1),
  niveau           VARCHAR2(2),
  montant_mensuel  NUMBER(12,2)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          20m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.situ_ress_full IS 'Copie de la table SITU_RESS avec des situations supplémentaires pour compléter les "trous", avant, entre et après les situations réelles.
Cette TABLE est mise à jour par des TRIGGERS sur SITU_RESS.
Dans cette TABLE chaque ressource a une situation (réelle ou extrapolée) pour chaque DATE.
ON retrouve dans cette TABLE les éventuels recouvrements qui existent dans SITU_RESS';

COMMENT ON COLUMN bip.situ_ress_full.datsitu IS 'Date de valeur de la situation';

COMMENT ON COLUMN bip.situ_ress_full.datdep IS 'Date de depart';

COMMENT ON COLUMN bip.situ_ress_full.cpident IS 'Code du chef de projet';

COMMENT ON COLUMN bip.situ_ress_full.cout IS 'Cout journalier ht de la ressource';

COMMENT ON COLUMN bip.situ_ress_full.dispo IS 'Disponibilite en nombre de jours par semaine';

COMMENT ON COLUMN bip.situ_ress_full.marsg2 IS 'Numero de marche SG2';

COMMENT ON COLUMN bip.situ_ress_full.rmcomp IS 'Code poste';

COMMENT ON COLUMN bip.situ_ress_full.prestation IS 'Prestation';

COMMENT ON COLUMN bip.situ_ress_full.dprest IS 'Nouvelle prestation (qualification)';

COMMENT ON COLUMN bip.situ_ress_full.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.situ_ress_full.soccode IS 'Identifiant societe';

COMMENT ON COLUMN bip.situ_ress_full.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.situ_ress_full.type_situ IS 'Quatre valeurs :
- N : situation normale (présente dans situ_ress)
- A : situation antérieure à toute situation normale
- P : situation postérieure à toute situation normale
- V : situation pour combler un vide entre deux situations normales';

COMMENT ON COLUMN bip.situ_ress_full.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.situ_ress_full.montant_mensuel IS 'Montant mensuel dans le cas de la facturation au 12ème';


ALTER TABLE bip.societe DROP PRIMARY KEY CASCADE;
DROP TABLE bip.societe CASCADE CONSTRAINTS;

--
-- SOCIETE  (Table) 
--
CREATE TABLE bip.societe
(
  soccode   VARCHAR(4)                             NOT NULL,
  socnat    VARCHAR2(2),
  socgrpe   VARCHAR(4),
  soclib    VARCHAR2(25),
  soccon    VARCHAR2(25),
  soctel    VARCHAR(10),
  socad1    VARCHAR2(25),
  socad2    VARCHAR2(25),
  socad3    VARCHAR2(25),
  socad4    VARCHAR2(25),
  soccre    DATE,
  socfer    DATE,
  soccom    VARCHAR2(20),
  socnou    VARCHAR(4),
  soccop    VARCHAR2(20),
  soccat    VARCHAR(4),
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.societe IS 'Table des societes';

COMMENT ON COLUMN bip.societe.soccode IS 'Identifiant societe';

COMMENT ON COLUMN bip.societe.socnat IS 'Nature de la societe : A pour agregee';

COMMENT ON COLUMN bip.societe.socgrpe IS 'Groupe de la societe';

COMMENT ON COLUMN bip.societe.soclib IS 'Libelle de la societe';

COMMENT ON COLUMN bip.societe.soccon IS 'Contact de la societe';

COMMENT ON COLUMN bip.societe.soctel IS 'Telephone';

COMMENT ON COLUMN bip.societe.socad1 IS 'Adresse1';

COMMENT ON COLUMN bip.societe.socad2 IS 'Adresse 2';

COMMENT ON COLUMN bip.societe.socad3 IS 'Adresse 3';

COMMENT ON COLUMN bip.societe.socad4 IS 'Adresse 4';

COMMENT ON COLUMN bip.societe.soccre IS 'Date de creation';

COMMENT ON COLUMN bip.societe.socfer IS 'Date de fermeture';

COMMENT ON COLUMN bip.societe.soccom IS 'Commentaire fermeture';

COMMENT ON COLUMN bip.societe.socnou IS 'Nouvelle societe';

COMMENT ON COLUMN bip.societe.soccop IS 'Commentaire fermeture nouvelle societe';

COMMENT ON COLUMN bip.societe.soccat IS 'Categorie de la societe';

COMMENT ON COLUMN bip.societe.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.sous_typologie DROP PRIMARY KEY CASCADE;
DROP TABLE bip.sous_typologie CASCADE CONSTRAINTS;

--
-- SOUS_TYPOLOGIE  (Table) 
--
CREATE TABLE bip.sous_typologie
(
  sous_type    VARCHAR2(3)                      NOT NULL,
  libsoustype  VARCHAR2(30)                     NOT NULL,
  flaglock     NUMBER(7)                        DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.sous_typologie IS 'Table des sous types d''activite de PAEN';

COMMENT ON COLUMN bip.sous_typologie.sous_type IS 'Identifiant de la sous-typologie';

COMMENT ON COLUMN bip.sous_typologie.libsoustype IS 'Libelle de la sous typologie';

COMMENT ON COLUMN bip.sous_typologie.flaglock IS 'Flag pour la gestion de concurrence';


DROP TABLE bip.sql_requete CASCADE CONSTRAINTS;

--
-- SQL_REQUETE  (Table) 
--
CREATE TABLE bip.sql_requete
(
  nom_fichier  VARCHAR2(8)                      NOT NULL,
  text_sql     VARCHAR2(256),
  POSITION     INTEGER
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.sql_requete IS 'Table du code SQL des requetes d''extraction';

COMMENT ON COLUMN bip.sql_requete.nom_fichier IS 'Nom du fichier généré (identifiant de la requete)';

COMMENT ON COLUMN bip.sql_requete.text_sql IS 'Partie du texte SQL';

COMMENT ON COLUMN bip.sql_requete.POSITION IS 'Position dans la requete de la partie du texte SQL de la requete';


ALTER TABLE bip.sstrt DROP PRIMARY KEY CASCADE;
DROP TABLE bip.sstrt CASCADE CONSTRAINTS;

--
-- SSTRT  (Table) 
--
CREATE TABLE bip.sstrt
(
  pid          VARCHAR2(4)                      NOT NULL,
  pdsg         NUMBER(7),
  ecet         VARCHAR(2)                          NOT NULL,
  acta         VARCHAR(2)                          NOT NULL,
  acst         VARCHAR(2)                          NOT NULL,
  aistpid      VARCHAR2(4),
  tires        NUMBER(5)                        NOT NULL,
  cdeb         DATE                             NOT NULL,
  cusag        NUMBER(7,2),
  astatut      VARCHAR(1),
  adatestatut  DATE,
  libdsg       VARCHAR2(30),
  pnom         VARCHAR2(30)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.sstrt IS 'Table des anomalies de sous traitance';

COMMENT ON COLUMN bip.sstrt.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.sstrt.pdsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.sstrt.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.sstrt.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.sstrt.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.sstrt.aistpid IS 'Code projet client';

COMMENT ON COLUMN bip.sstrt.tires IS 'Numero de ressource';

COMMENT ON COLUMN bip.sstrt.cdeb IS 'Mois annee de reference';

COMMENT ON COLUMN bip.sstrt.cusag IS 'Consomme du mois';

COMMENT ON COLUMN bip.sstrt.astatut IS 'Statut du projet';

COMMENT ON COLUMN bip.sstrt.adatestatut IS 'Date de statut du projet';

COMMENT ON COLUMN bip.sstrt.libdsg IS 'Libelle du code div/sect/groupe';

COMMENT ON COLUMN bip.sstrt.pnom IS 'Libelle du projet';


ALTER TABLE bip.stat_page DROP PRIMARY KEY CASCADE;
DROP TABLE bip.stat_page CASCADE CONSTRAINTS;

--
-- STAT_PAGE  (Table) 
--
CREATE TABLE bip.stat_page
(
  id_menu       VARCHAR2(10)                    NOT NULL,
  id_page       NUMBER                          NOT NULL,
  lib_page      VARCHAR2(50)                    NOT NULL,
  TRACE         VARCHAR(1)                         DEFAULT 'O'                   NOT NULL,
  trace_action  VARCHAR(1)                         DEFAULT 'N'                   NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.stat_page IS 'Table permettant d''indiquer quelles pages de l''application sont tracées au travers de l''outil Weborama';

COMMENT ON COLUMN bip.stat_page.id_menu IS 'Identifiant du menu';

COMMENT ON COLUMN bip.stat_page.id_page IS 'Identifiant de la page';

COMMENT ON COLUMN bip.stat_page.lib_page IS 'Libellé de la page';

COMMENT ON COLUMN bip.stat_page.TRACE IS 'Flag de trace de la page (O ou N)';

COMMENT ON COLUMN bip.stat_page.trace_action IS 'Flag de trace au niveau de l''action de la page (O ou N)';


ALTER TABLE bip.stock_fi DROP PRIMARY KEY CASCADE;
DROP TABLE bip.stock_fi CASCADE CONSTRAINTS;

--
-- STOCK_FI  (Table) 
--
CREATE TABLE bip.stock_fi
(
  cdeb             DATE                         NOT NULL,
  pid              VARCHAR2(4)                  NOT NULL,
  ident            NUMBER(5)                    NOT NULL,
  typproj          VARCHAR(2),
  metier           VARCHAR2(3),
  pnom             VARCHAR2(30),
  codsg            NUMBER(7),
  dpcode           NUMBER(5),
  icpi             VARCHAR(5),
  codcamo          NUMBER(6),
  clibrca          VARCHAR(16),
  cafi             NUMBER(6),
  codsgress        NUMBER(7),
  libdsg           VARCHAR2(30),
  rnom             VARCHAR2(30),
  rtype            VARCHAR(1),
  prestation       VARCHAR(3),
  niveau           VARCHAR2(2),
  soccode          VARCHAR(4),
  cada             NUMBER(6),
  coutftht         NUMBER(12,2),
  coutft           NUMBER(12,2),
  coutenv          NUMBER(12,2),
  consojhimmo      NUMBER(12,2),
  nconsojhimmo     NUMBER(12,2),
  consoft          NUMBER(12,2),
  consoenvimmo     NUMBER(12,2),
  nconsoenvimmo    NUMBER(12,2),
  a_consojhimmo    NUMBER(12,2),
  a_nconsojhimmo   NUMBER(12,2),
  a_consoft        NUMBER(12,2),
  a_consoenvimmo   NUMBER(12,2),
  a_nconsoenvimmo  NUMBER(12,2),
  fi1              VARCHAR2(1)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.stock_fi IS 'Stock de facturation interne';

COMMENT ON COLUMN bip.stock_fi.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.stock_fi.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.stock_fi.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.stock_fi.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.stock_fi.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.stock_fi.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.stock_fi.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.stock_fi.clibrca IS 'Libellé du centre d''activité du client payeur';

COMMENT ON COLUMN bip.stock_fi.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.stock_fi.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_fi.libdsg IS 'Libellé du département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_fi.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.stock_fi.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.stock_fi.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.stock_fi.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.stock_fi.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.stock_fi.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.stock_fi.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.stock_fi.coutft IS 'Coût force de travail (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_fi.coutenv IS 'Coût d''environnement (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_fi.consojhimmo IS 'Consommé du mois immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi.nconsojhimmo IS 'Consommé du mois non immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi.consoenvimmo IS 'Consommé charge d''environnement immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi.nconsoenvimmo IS 'Consommé charge d''environnement non immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi.a_consojhimmo IS 'Retour arrière consommé du mois immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi.a_nconsojhimmo IS 'Retour arrière consommé du mois non immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi.a_consoft IS 'Retour arrière consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi.a_consoenvimmo IS 'Retour arrière consommé charge d''environnement immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi.a_nconsoenvimmo IS 'Retour arrière consommé charge d''environnement non immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi.fi1 IS 'Top pour les lignes qui ont été copiées lors du traitement depuis STOCK_FI_1 (=O dans ce cas, null sinon)';


ALTER TABLE bip.stock_fi_1 DROP PRIMARY KEY CASCADE;
DROP TABLE bip.stock_fi_1 CASCADE CONSTRAINTS;

--
-- STOCK_FI_1  (Table) 
--
CREATE TABLE bip.stock_fi_1
(
  cdeb             DATE                         NOT NULL,
  pid              VARCHAR2(4)                  NOT NULL,
  ident            NUMBER(5)                    NOT NULL,
  typproj          VARCHAR(2),
  metier           VARCHAR2(3),
  pnom             VARCHAR2(30),
  codsg            NUMBER(7),
  dpcode           NUMBER(5),
  icpi             VARCHAR(5),
  codcamo          NUMBER(6),
  clibrca          VARCHAR(16),
  cafi             NUMBER(6),
  codsgress        NUMBER(7),
  libdsg           VARCHAR2(30),
  rnom             VARCHAR2(30),
  rtype            VARCHAR(1),
  prestation       VARCHAR(3),
  niveau           VARCHAR2(2),
  soccode          VARCHAR(4),
  cada             NUMBER(6),
  coutftht         NUMBER(12,2),
  coutft           NUMBER(12,2),
  coutenv          NUMBER(12,2),
  consojhimmo      NUMBER(12,2),
  nconsojhimmo     NUMBER(12,2),
  consoft          NUMBER(12,2),
  consoenvimmo     NUMBER(12,2),
  nconsoenvimmo    NUMBER(12,2),
  a_consojhimmo    NUMBER(12,2),
  a_nconsojhimmo   NUMBER(12,2),
  a_consoft        NUMBER(12,2),
  a_consoenvimmo   NUMBER(12,2),
  a_nconsoenvimmo  NUMBER(12,2),
  fi1              VARCHAR2(1)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.stock_fi_1 IS 'Stock de facturation interne - Valeurs du mois précédent';

COMMENT ON COLUMN bip.stock_fi_1.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.stock_fi_1.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi_1.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.stock_fi_1.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.stock_fi_1.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.stock_fi_1.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi_1.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi_1.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.stock_fi_1.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.stock_fi_1.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.stock_fi_1.clibrca IS 'Libellé du centre d''activité du client payeur';

COMMENT ON COLUMN bip.stock_fi_1.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.stock_fi_1.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_fi_1.libdsg IS 'Libellé du département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_fi_1.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.stock_fi_1.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.stock_fi_1.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.stock_fi_1.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.stock_fi_1.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.stock_fi_1.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.stock_fi_1.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.stock_fi_1.coutft IS 'Coût force de travail (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_fi_1.coutenv IS 'Coût d''environnement (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_fi_1.consojhimmo IS 'Consommé du mois immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_1.nconsojhimmo IS 'Consommé du mois non immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_1.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_1.consoenvimmo IS 'Consommé charge d''environnement immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_1.nconsoenvimmo IS 'Consommé charge d''environnement non immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_1.a_consojhimmo IS 'Retour arrière consommé du mois immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_1.a_nconsojhimmo IS 'Retour arrière consommé du mois non immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_1.a_consoft IS 'Retour arrière consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_1.a_consoenvimmo IS 'Retour arrière consommé charge d''environnement immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_1.a_nconsoenvimmo IS 'Retour arrière consommé charge d''environnement non immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_1.fi1 IS 'Top pour les lignes qui ont été copiées';


ALTER TABLE bip.stock_fi_dec DROP PRIMARY KEY CASCADE;
DROP TABLE bip.stock_fi_dec CASCADE CONSTRAINTS;

--
-- STOCK_FI_DEC  (Table) 
--
CREATE TABLE bip.stock_fi_dec
(
  cdeb             DATE                         NOT NULL,
  pid              VARCHAR2(4)                  NOT NULL,
  ident            NUMBER(5)                    NOT NULL,
  typproj          VARCHAR(2),
  metier           VARCHAR2(3),
  pnom             VARCHAR2(30),
  codsg            NUMBER(7),
  dpcode           NUMBER(5),
  icpi             VARCHAR(5),
  codcamo          NUMBER(6),
  clibrca          VARCHAR(16),
  cafi             NUMBER(6),
  codsgress        NUMBER(7),
  libdsg           VARCHAR2(30),
  rnom             VARCHAR2(30),
  rtype            VARCHAR(1),
  prestation       VARCHAR(3),
  niveau           VARCHAR2(2),
  soccode          VARCHAR(4),
  cada             NUMBER(6),
  coutftht         NUMBER(12,2),
  coutft           NUMBER(12,2),
  coutenv          NUMBER(12,2),
  consojhimmo      NUMBER(12,2),
  nconsojhimmo     NUMBER(12,2),
  consoft          NUMBER(12,2),
  consoenvimmo     NUMBER(12,2),
  nconsoenvimmo    NUMBER(12,2),
  a_consojhimmo    NUMBER(12,2),
  a_nconsojhimmo   NUMBER(12,2),
  a_consoft        NUMBER(12,2),
  a_consoenvimmo   NUMBER(12,2),
  a_nconsoenvimmo  NUMBER(12,2),
  fi1              VARCHAR2(1)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.stock_fi_dec IS 'Stock de facturation interne - Valeurs du mois de Décembre';

COMMENT ON COLUMN bip.stock_fi_dec.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.stock_fi_dec.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi_dec.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.stock_fi_dec.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.stock_fi_dec.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.stock_fi_dec.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi_dec.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi_dec.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.stock_fi_dec.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.stock_fi_dec.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.stock_fi_dec.clibrca IS 'Libellé du centre d''activité du client payeur';

COMMENT ON COLUMN bip.stock_fi_dec.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.stock_fi_dec.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_fi_dec.libdsg IS 'Libellé du département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_fi_dec.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.stock_fi_dec.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.stock_fi_dec.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.stock_fi_dec.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.stock_fi_dec.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.stock_fi_dec.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.stock_fi_dec.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.stock_fi_dec.coutft IS 'Coût force de travail (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_fi_dec.coutenv IS 'Coût d''environnement (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_fi_dec.consojhimmo IS 'Consommé du mois immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_dec.nconsojhimmo IS 'Consommé du mois non immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_dec.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_dec.consoenvimmo IS 'Consommé charge d''environnement immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_dec.nconsoenvimmo IS 'Consommé charge d''environnement non immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_dec.a_consojhimmo IS 'Retour arrière consommé du mois immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_dec.a_nconsojhimmo IS 'Retour arrière consommé du mois non immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_dec.a_consoft IS 'Retour arrière consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_dec.a_consoenvimmo IS 'Retour arrière consommé charge d''environnement immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_dec.a_nconsoenvimmo IS 'Retour arrière consommé charge d''environnement non immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_dec.fi1 IS 'Top pour les lignes qui ont été copiées';


ALTER TABLE bip.stock_fi_multi DROP PRIMARY KEY CASCADE;
DROP TABLE bip.stock_fi_multi CASCADE CONSTRAINTS;

--
-- STOCK_FI_MULTI  (Table) 
--
CREATE TABLE bip.stock_fi_multi
(
  cdeb             DATE                         NOT NULL,
  pid              VARCHAR2(4)                  NOT NULL,
  ident            NUMBER(5)                    NOT NULL,
  typproj          VARCHAR(2),
  metier           VARCHAR2(3),
  pnom             VARCHAR2(30),
  codsg            NUMBER(7),
  dpcode           NUMBER(5),
  icpi             VARCHAR(5),
  codcamo          NUMBER(6),
  clibrca          VARCHAR(16),
  cafi             NUMBER(6),
  codsgress        NUMBER(7),
  libdsg           VARCHAR2(30),
  rnom             VARCHAR2(30),
  rtype            VARCHAR(1),
  prestation       VARCHAR(3),
  niveau           VARCHAR2(2),
  soccode          VARCHAR(4),
  cada             NUMBER(6),
  coutftht         NUMBER(12,2),
  coutft           NUMBER(12,2),
  coutenv          NUMBER(12,2),
  consojhimmo      NUMBER(12,2),
  nconsojhimmo     NUMBER(12,2),
  consoft          NUMBER(12,2),
  consoenvimmo     NUMBER(12,2),
  nconsoenvimmo    NUMBER(12,2),
  a_consojhimmo    NUMBER(12,2),
  a_nconsojhimmo   NUMBER(12,2),
  a_consoft        NUMBER(12,2),
  a_consoenvimmo   NUMBER(12,2),
  a_nconsoenvimmo  NUMBER(12,2),
  fi1              VARCHAR2(1)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.stock_fi_multi IS 'Stock de facturation interne - Valeurs pour les lignes BIP multi-ca';

COMMENT ON COLUMN bip.stock_fi_multi.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.stock_fi_multi.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi_multi.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.stock_fi_multi.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.stock_fi_multi.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.stock_fi_multi.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi_multi.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.stock_fi_multi.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.stock_fi_multi.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.stock_fi_multi.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.stock_fi_multi.clibrca IS 'Libellé du centre d''activité du client payeur';

COMMENT ON COLUMN bip.stock_fi_multi.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.stock_fi_multi.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_fi_multi.libdsg IS 'Libellé du département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_fi_multi.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.stock_fi_multi.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.stock_fi_multi.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.stock_fi_multi.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.stock_fi_multi.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.stock_fi_multi.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.stock_fi_multi.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.stock_fi_multi.coutft IS 'Coût force de travail (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_fi_multi.coutenv IS 'Coût d''environnement (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_fi_multi.consojhimmo IS 'Consommé du mois immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_multi.nconsojhimmo IS 'Consommé du mois non immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_multi.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_multi.consoenvimmo IS 'Consommé charge d''environnement immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_multi.nconsoenvimmo IS 'Consommé charge d''environnement non immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_multi.a_consojhimmo IS 'Retour arrière consommé du mois immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_multi.a_nconsojhimmo IS 'Retour arrière consommé du mois non immobilisable en jours hommes';

COMMENT ON COLUMN bip.stock_fi_multi.a_consoft IS 'Retour arrière consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_multi.a_consoenvimmo IS 'Retour arrière consommé charge d''environnement immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_multi.a_nconsoenvimmo IS 'Retour arrière consommé charge d''environnement non immobilisable du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_fi_multi.fi1 IS 'Top pour les lignes qui ont été copiées';


DROP TABLE bip.stock_fi_pp CASCADE CONSTRAINTS;

--
-- STOCK_FI_PP  (Table) 
--
CREATE TABLE bip.stock_fi_pp
(
  cas            NUMBER(2),
  pid            VARCHAR2(4),
  cdeb           DATE,
  cafi           NUMBER(6),
  codcamo        NUMBER(6),
  ident          NUMBER(5),
  rnom           VARCHAR2(30),
  coutftht       NUMBER(12,2),
  coutft         NUMBER(12,2),
  consojhimmo    NUMBER(12,2),
  nconsojhimmo   NUMBER(12,2),
  consoft        NUMBER(12,2),
  consoenvimmo   NUMBER(12,2),
  nconsoenvimmo  NUMBER(12,2)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;


ALTER TABLE bip.stock_immo DROP PRIMARY KEY CASCADE;
DROP TABLE bip.stock_immo CASCADE CONSTRAINTS;

--
-- STOCK_IMMO  (Table) 
--
CREATE TABLE bip.stock_immo
(
  cdeb        DATE                              NOT NULL,
  pid         VARCHAR2(4)                       NOT NULL,
  ident       NUMBER(5)                         NOT NULL,
  typproj     VARCHAR(2),
  metier      VARCHAR2(3),
  pnom        VARCHAR2(30),
  codsg       NUMBER(7),
  dpcode      NUMBER(5),
  icpi        VARCHAR(5),
  codcamo     NUMBER(6),
  clibrca     VARCHAR(16),
  cafi        NUMBER(6),
  codsgress   NUMBER(7),
  libdsg      VARCHAR2(30),
  rnom        VARCHAR2(30),
  rtype       VARCHAR(1),
  prestation  VARCHAR(3),
  niveau      VARCHAR2(2),
  soccode     VARCHAR(4),
  cada        NUMBER(6),
  coutftht    NUMBER(12,2),
  coutft      NUMBER(12,2),
  consojh     NUMBER(12,2),
  consoft     NUMBER(12,2),
  a_consojh   NUMBER(12,2),
  a_consoft   NUMBER(12,2),
  immo1       VARCHAR2(1)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.stock_immo IS 'Stock des immobilisations';

COMMENT ON COLUMN bip.stock_immo.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.stock_immo.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.stock_immo.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.stock_immo.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.stock_immo.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.stock_immo.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.stock_immo.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.stock_immo.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.stock_immo.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.stock_immo.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.stock_immo.clibrca IS 'Libellé du centre d''activité du client payeur';

COMMENT ON COLUMN bip.stock_immo.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.stock_immo.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_immo.libdsg IS 'Libellé du département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_immo.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.stock_immo.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.stock_immo.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.stock_immo.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.stock_immo.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.stock_immo.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.stock_immo.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.stock_immo.coutft IS 'Coût force de travail (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_immo.consojh IS 'Consommé du mois en jours hommes';

COMMENT ON COLUMN bip.stock_immo.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_immo.a_consojh IS 'Retour arrière consommé du mois en jours hommes';

COMMENT ON COLUMN bip.stock_immo.a_consoft IS 'Retour arrière consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_immo.immo1 IS 'Top pour les lignes qui ont été copiées lors du traitement depuis STOCK_IMMO_1 (=O dans ce cas, null sinon)';


ALTER TABLE bip.stock_immo_1 DROP PRIMARY KEY CASCADE;
DROP TABLE bip.stock_immo_1 CASCADE CONSTRAINTS;

--
-- STOCK_IMMO_1  (Table) 
--
CREATE TABLE bip.stock_immo_1
(
  cdeb        DATE                              NOT NULL,
  pid         VARCHAR2(4)                       NOT NULL,
  ident       NUMBER(5)                         NOT NULL,
  typproj     VARCHAR(2),
  metier      VARCHAR2(3),
  pnom        VARCHAR2(30),
  codsg       NUMBER(7),
  dpcode      NUMBER(5),
  icpi        VARCHAR(5),
  codcamo     NUMBER(6),
  clibrca     VARCHAR(16),
  cafi        NUMBER(6),
  codsgress   NUMBER(7),
  libdsg      VARCHAR2(30),
  rnom        VARCHAR2(30),
  rtype       VARCHAR(1),
  prestation  VARCHAR(3),
  niveau      VARCHAR2(2),
  soccode     VARCHAR(4),
  cada        NUMBER(6),
  coutftht    NUMBER(12,2),
  coutft      NUMBER(12,2),
  consojh     NUMBER(12,2),
  consoft     NUMBER(12,2),
  a_consojh   NUMBER(12,2),
  a_consoft   NUMBER(12,2),
  immo1       VARCHAR2(1)
)
TABLESPACE  tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.stock_immo_1 IS 'Stock des immobilisations - Valeurs du mois précédent';

COMMENT ON COLUMN bip.stock_immo_1.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.stock_immo_1.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.stock_immo_1.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.stock_immo_1.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.stock_immo_1.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.stock_immo_1.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.stock_immo_1.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.stock_immo_1.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.stock_immo_1.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.stock_immo_1.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.stock_immo_1.clibrca IS 'Libellé du centre d''activité du client payeur';

COMMENT ON COLUMN bip.stock_immo_1.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.stock_immo_1.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_immo_1.libdsg IS 'Libellé du département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_immo_1.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.stock_immo_1.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.stock_immo_1.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.stock_immo_1.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.stock_immo_1.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.stock_immo_1.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.stock_immo_1.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.stock_immo_1.coutft IS 'Coût force de travail (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_immo_1.consojh IS 'Consommé du mois en jours hommes';

COMMENT ON COLUMN bip.stock_immo_1.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_immo_1.a_consojh IS 'Retour arrière consommé du mois en jours hommes';

COMMENT ON COLUMN bip.stock_immo_1.a_consoft IS 'Retour arrière consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_immo_1.immo1 IS 'Top pour les lignes qui ont été copiées';


ALTER TABLE bip.stock_ra DROP PRIMARY KEY CASCADE;
DROP TABLE bip.stock_ra CASCADE CONSTRAINTS;

--
-- STOCK_RA  (Table) 
--
CREATE TABLE bip.stock_ra
(
  factpid     VARCHAR2(4)                       NOT NULL,
  pid         VARCHAR2(4)                       NOT NULL,
  cdeb        DATE                              NOT NULL,
  typproj     VARCHAR(2),
  metier      VARCHAR2(3),
  pnom        VARCHAR2(30),
  codsg       NUMBER(7),
  dpcode      NUMBER(5),
  icpi        VARCHAR(5),
  cada        NUMBER(6),
  codcamo     NUMBER(6)                         NOT NULL,
  ecet        VARCHAR(2)                           NOT NULL,
  typetap     VARCHAR(2),
  acta        VARCHAR(2)                           NOT NULL,
  acst        VARCHAR(2)                           NOT NULL,
  aist        VARCHAR(6),
  asnom       VARCHAR2(15),
  cafi        NUMBER(6)                         NOT NULL,
  codsgress   NUMBER(7),
  ident       NUMBER(5)                         NOT NULL,
  rtype       VARCHAR(1),
  niveau      VARCHAR2(2),
  prestation  VARCHAR(3),
  soccode     VARCHAR(4),
  coutftht    NUMBER(12,2),
  coutfthtr   NUMBER(12,2),
  coutenv     NUMBER(12,2),
  consojh     NUMBER(12,2),
  consoft     NUMBER(12,2),
  consoenv    NUMBER(12,2),
  a_consojh   NUMBER(12,2),
  a_consoft   NUMBER(12,2),
  a_consoenv  NUMBER(12,2),
  flag_ra     VARCHAR2(1)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.stock_ra IS 'Stock des retours arrières';

COMMENT ON COLUMN bip.stock_ra.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.stock_ra.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.stock_ra.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.stock_ra.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.stock_ra.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.stock_ra.coutfthtr IS 'Coût force de travail hors taxes récupérable';

COMMENT ON COLUMN bip.stock_ra.coutenv IS 'Coût d''environnement (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_ra.consojh IS 'Consommé du mois en jours hommes';

COMMENT ON COLUMN bip.stock_ra.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_ra.consoenv IS 'Consommé charge d''environnement du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_ra.a_consojh IS 'Retour arrière consommé du mois en jours hommes';

COMMENT ON COLUMN bip.stock_ra.a_consoft IS 'Retour arrière consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_ra.a_consoenv IS 'Retour arrière consommé charge d''environnement du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_ra.flag_ra IS 'Top pour les lignes qui ont été copiées lors du traitement depuis STOCK_RA_1 (=O dans ce cas, N sinon)';

COMMENT ON COLUMN bip.stock_ra.factpid IS 'Identifiant de la ligne BIP à facturer (est différent de PID dans le cas d''une sous-traitance)';

COMMENT ON COLUMN bip.stock_ra.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.stock_ra.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.stock_ra.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.stock_ra.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.stock_ra.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.stock_ra.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.stock_ra.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.stock_ra.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.stock_ra.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.stock_ra.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.stock_ra.ecet IS 'Numéro de l''étape';

COMMENT ON COLUMN bip.stock_ra.typetap IS 'Type de l''étape (AP:Avant-projet, RE:Réalisation ...)';

COMMENT ON COLUMN bip.stock_ra.acta IS 'Numéro de la tâche';

COMMENT ON COLUMN bip.stock_ra.acst IS 'Numéro de la sous tâche';

COMMENT ON COLUMN bip.stock_ra.aist IS 'Type de sous tâche';

COMMENT ON COLUMN bip.stock_ra.asnom IS 'Libellé de la sous tâche';

COMMENT ON COLUMN bip.stock_ra.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.stock_ra.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_ra.ident IS 'Identifiant ressource';


ALTER TABLE bip.stock_ra_1 DROP PRIMARY KEY CASCADE;
DROP TABLE bip.stock_ra_1 CASCADE CONSTRAINTS;

--
-- STOCK_RA_1  (Table) 
--
CREATE TABLE bip.stock_ra_1
(
  factpid     VARCHAR2(4)                       NOT NULL,
  pid         VARCHAR2(4)                       NOT NULL,
  cdeb        DATE                              NOT NULL,
  typproj     VARCHAR(2),
  metier      VARCHAR2(3),
  pnom        VARCHAR2(30),
  codsg       NUMBER(7),
  dpcode      NUMBER(5),
  icpi        VARCHAR(5),
  cada        NUMBER(6),
  codcamo     NUMBER(6)                         NOT NULL,
  ecet        VARCHAR(2)                           NOT NULL,
  typetap     VARCHAR(2),
  acta        VARCHAR(2)                           NOT NULL,
  acst        VARCHAR(2)                           NOT NULL,
  aist        VARCHAR(6),
  asnom       VARCHAR2(15),
  cafi        NUMBER(6)                         NOT NULL,
  codsgress   NUMBER(7),
  ident       NUMBER(5)                         NOT NULL,
  rtype       VARCHAR(1),
  niveau      VARCHAR2(2),
  prestation  VARCHAR(3),
  soccode     VARCHAR(4),
  coutftht    NUMBER(12,2),
  coutfthtr   NUMBER(12,2),
  coutenv     NUMBER(12,2),
  consojh     NUMBER(12,2),
  consoft     NUMBER(12,2),
  consoenv    NUMBER(12,2),
  a_consojh   NUMBER(12,2),
  a_consoft   NUMBER(12,2),
  a_consoenv  NUMBER(12,2),
  flag_ra     VARCHAR2(1)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.stock_ra_1 IS 'Stock des retours arrières - Valeurs du mois précédent';

COMMENT ON COLUMN bip.stock_ra_1.factpid IS 'Identifiant de la ligne BIP à facturer (est différent de PID dans le cas d''une sous-traitance)';

COMMENT ON COLUMN bip.stock_ra_1.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.stock_ra_1.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.stock_ra_1.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.stock_ra_1.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.stock_ra_1.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.stock_ra_1.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.stock_ra_1.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.stock_ra_1.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.stock_ra_1.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.stock_ra_1.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.stock_ra_1.ecet IS 'Numéro de l''étape';

COMMENT ON COLUMN bip.stock_ra_1.typetap IS 'Type de l''étape (AP:Avant-projet, RE:Réalisation ...)';

COMMENT ON COLUMN bip.stock_ra_1.acta IS 'Numéro de la tâche';

COMMENT ON COLUMN bip.stock_ra_1.acst IS 'Numéro de la sous tâche';

COMMENT ON COLUMN bip.stock_ra_1.aist IS 'Type de sous tâche';

COMMENT ON COLUMN bip.stock_ra_1.asnom IS 'Libellé de la sous tâche';

COMMENT ON COLUMN bip.stock_ra_1.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.stock_ra_1.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.stock_ra_1.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.stock_ra_1.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.stock_ra_1.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.stock_ra_1.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.stock_ra_1.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.stock_ra_1.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.stock_ra_1.coutfthtr IS 'Coût force de travail hors taxes récupérable';

COMMENT ON COLUMN bip.stock_ra_1.coutenv IS 'Coût d''environnement (en hors taxes récupérable)';

COMMENT ON COLUMN bip.stock_ra_1.consojh IS 'Consommé du mois en jours hommes';

COMMENT ON COLUMN bip.stock_ra_1.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_ra_1.consoenv IS 'Consommé charge d''environnement du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_ra_1.a_consojh IS 'Retour arrière consommé du mois en jours hommes';

COMMENT ON COLUMN bip.stock_ra_1.a_consoft IS 'Retour arrière consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_ra_1.a_consoenv IS 'Retour arrière consommé charge d''environnement du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.stock_ra_1.flag_ra IS 'Top pour les lignes qui ont été copiées lors du traitement depuis STOCK_RA_1 (=O dans ce cas, N sinon)';


ALTER TABLE bip.struct_info DROP PRIMARY KEY CASCADE;
DROP TABLE bip.struct_info CASCADE CONSTRAINTS;

--
-- STRUCT_INFO  (Table) 
--
CREATE TABLE bip.struct_info
(
  codsg         NUMBER(7)                       NOT NULL,
  centractiv    NUMBER(7)                       NOT NULL,
  coddep        NUMBER(3)                       NOT NULL,
  codpole       NUMBER(2)                       NOT NULL,
  codgro        NUMBER(2)                       NOT NULL,
  coddeppole    NUMBER(5)                       NOT NULL,
  sigdep        VARCHAR(3)                         NOT NULL,
  sigpole       VARCHAR(3),
  libdsg        VARCHAR2(30),
  topfer        VARCHAR(1)                         NOT NULL,
  flaglock      NUMBER(7)                       DEFAULT 0                     NOT NULL,
  coddir        NUMBER(2),
  cafi          NUMBER(6),
  scentrefrais  NUMBER(3),
  filcode       VARCHAR(3)                         NOT NULL,
  top_oscar     VARCHAR(2),
  gnom          VARCHAR2(30)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.struct_info IS 'Structure des services en departement pole groupe.';

COMMENT ON COLUMN bip.struct_info.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.struct_info.centractiv IS 'Centre d''activite';

COMMENT ON COLUMN bip.struct_info.coddep IS 'Code departement (=division)';

COMMENT ON COLUMN bip.struct_info.codpole IS 'Code pole de l''utilisateur (secteur)';

COMMENT ON COLUMN bip.struct_info.codgro IS 'Code groupe';

COMMENT ON COLUMN bip.struct_info.coddeppole IS 'Concatenation des code division et secteur';

COMMENT ON COLUMN bip.struct_info.sigdep IS 'Sigle departement (= division)';

COMMENT ON COLUMN bip.struct_info.sigpole IS 'Sigle pole ( = secteur)';

COMMENT ON COLUMN bip.struct_info.libdsg IS 'Libelle du code div/sect/groupe';

COMMENT ON COLUMN bip.struct_info.topfer IS 'Top fermeture';

COMMENT ON COLUMN bip.struct_info.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.struct_info.coddir IS 'Numéro de la direction';

COMMENT ON COLUMN bip.struct_info.cafi IS 'Centre d''activite de FI';

COMMENT ON COLUMN bip.struct_info.scentrefrais IS 'Centre de frais';

COMMENT ON COLUMN bip.struct_info.filcode IS 'Code de la filiale';

COMMENT ON COLUMN bip.struct_info.top_oscar IS 'Indique si le département/pôle/groupe utilise l''application OSCAR';

COMMENT ON COLUMN bip.struct_info.gnom IS 'Nom du responsable';


ALTER TABLE bip.suivijhr DROP PRIMARY KEY CASCADE;
DROP TABLE bip.suivijhr CASCADE CONSTRAINTS;

--
-- SUIVIJHR  (Table) 
--
CREATE TABLE bip.suivijhr
(
  dpg     NUMBER(7)                             NOT NULL,
  prodm2  NUMBER(12,2),
  prodm1  NUMBER(12,2),
  prod    NUMBER(12,2),
  absm1   NUMBER(12,2),
  ABS     NUMBER(12,2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.suivijhr IS 'Table dédiée à l''état SUIVIJHR - Est alimentée par les traitements mensuels';

COMMENT ON COLUMN bip.suivijhr.dpg IS 'Code département/pôle/groupe';

COMMENT ON COLUMN bip.suivijhr.prodm2 IS 'Consommé en jours hommes de l''avant-dernier mois';

COMMENT ON COLUMN bip.suivijhr.prodm1 IS 'Consommé en jours hommes du dernier mois';

COMMENT ON COLUMN bip.suivijhr.prod IS 'Consommé en jours hommes du mois courant';

COMMENT ON COLUMN bip.suivijhr.absm1 IS 'Nombre de jours d''absences du dernier mois';

COMMENT ON COLUMN bip.suivijhr.ABS IS 'Nombre de jours d''absences du mois courant';


ALTER TABLE bip.synthese_activite DROP PRIMARY KEY CASCADE;
DROP TABLE bip.synthese_activite CASCADE CONSTRAINTS;

--
-- SYNTHESE_ACTIVITE  (Table) 
--
CREATE TABLE bip.synthese_activite
(
  pid            VARCHAR2(4)                    NOT NULL,
  annee          NUMBER(4)                      NOT NULL,
  typproj        VARCHAR(2),
  metier         VARCHAR2(3),
  pnom           VARCHAR2(30),
  codsg          NUMBER(7),
  dpcode         NUMBER(5),
  icpi           VARCHAR(5),
  codcamo        NUMBER(6),
  consojh_sg     NUMBER(12,2),
  consojh_ssii   NUMBER(12,2),
  consoft_sg     NUMBER(12,2),
  consoft_ssii   NUMBER(12,2),
  consoenv_sg    NUMBER(12,2),
  consoenv_ssii  NUMBER(12,2)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.synthese_activite IS 'Synthèse de l''activité par ligne BIP et année';

COMMENT ON COLUMN bip.synthese_activite.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.synthese_activite.annee IS 'Année de référence';

COMMENT ON COLUMN bip.synthese_activite.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.synthese_activite.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.synthese_activite.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.synthese_activite.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.synthese_activite.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.synthese_activite.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.synthese_activite.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.synthese_activite.consojh_sg IS 'Consommé de l''année en jours hommes pour les ressources SG';

COMMENT ON COLUMN bip.synthese_activite.consojh_ssii IS 'Consommé de l''année en jours hommes pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_activite.consoft_sg IS 'Consommé force de travail de l''année en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_activite.consoft_ssii IS 'Consommé force de travail de l''année en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_activite.consoenv_sg IS 'Consommé charge d''environnement de l''année en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_activite.consoenv_ssii IS 'Consommé charge d''environnement de l''année en euros hors taxes récupérable pour les ressources SSII';


ALTER TABLE bip.synthese_activite_mois DROP PRIMARY KEY CASCADE;
DROP TABLE bip.synthese_activite_mois CASCADE CONSTRAINTS;

--
-- SYNTHESE_ACTIVITE_MOIS  (Table) 
--
CREATE TABLE bip.synthese_activite_mois
(
  pid            VARCHAR2(4)                    NOT NULL,
  cdeb           DATE                           NOT NULL,
  typproj        VARCHAR(2),
  metier         VARCHAR2(3),
  pnom           VARCHAR2(30),
  codsg          NUMBER(7),
  dpcode         NUMBER(5),
  icpi           VARCHAR(5),
  codcamo        NUMBER(6),
  consojh_sg     NUMBER(12,2),
  consojh_ssii   NUMBER(12,2),
  consoft_sg     NUMBER(12,2),
  consoft_ssii   NUMBER(12,2),
  consoenv_sg    NUMBER(12,2),
  consoenv_ssii  NUMBER(12,2)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.synthese_activite_mois IS 'Synthèse de l''activité par ligne BIP et mois';

COMMENT ON COLUMN bip.synthese_activite_mois.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.synthese_activite_mois.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.synthese_activite_mois.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.synthese_activite_mois.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.synthese_activite_mois.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.synthese_activite_mois.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.synthese_activite_mois.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.synthese_activite_mois.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.synthese_activite_mois.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.synthese_activite_mois.consojh_sg IS 'Consommé du mois en jours hommes pour les ressources SG';

COMMENT ON COLUMN bip.synthese_activite_mois.consojh_ssii IS 'Consommé du mois en jours hommes pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_activite_mois.consoft_sg IS 'Consommé force de travail du mois en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_activite_mois.consoft_ssii IS 'Consommé force de travail du mois en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_activite_mois.consoenv_sg IS 'Consommé charge d''environnement du mois en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_activite_mois.consoenv_ssii IS 'Consommé charge d''environnement du mois en euros hors taxes récupérable pour les ressources SSII';


ALTER TABLE bip.synthese_fin DROP PRIMARY KEY CASCADE;
DROP TABLE bip.synthese_fin CASCADE CONSTRAINTS;

--
-- SYNTHESE_FIN  (Table) 
--
CREATE TABLE bip.synthese_fin
(
  annee              NUMBER(4)                  NOT NULL,
  pid                VARCHAR2(4)                NOT NULL,
  codsg              NUMBER(7),
  codcamo            NUMBER(6)                  NOT NULL,
  cafi               NUMBER(6)                  NOT NULL,
  codsgress          NUMBER(7)                  NOT NULL,
  cada               NUMBER(6),
  consojhsg_im       NUMBER(12,2),
  consojhssii_im     NUMBER(12,2),
  consoftsg_im       NUMBER(12,2),
  consoftssii_im     NUMBER(12,2),
  consojhsg_fi       NUMBER(12,2),
  consojhssii_fi     NUMBER(12,2),
  consoftsg_fi       NUMBER(12,2),
  consoftssii_fi     NUMBER(12,2),
  consoenvsg_ni      NUMBER(12,2),
  consoenvssii_ni    NUMBER(12,2),
  consoenvsg_im      NUMBER(12,2),
  consoenvssii_im    NUMBER(12,2),
  d_consojhsg_fi     NUMBER(12,2),
  d_consojhssii_fi   NUMBER(12,2),
  d_consoftsg_fi     NUMBER(12,2),
  d_consoftssii_fi   NUMBER(12,2),
  d_consoenvsg_ni    NUMBER(12,2),
  d_consoenvssii_ni  NUMBER(12,2),
  d_consoenvsg_im    NUMBER(12,2),
  d_consoenvssii_im  NUMBER(12,2),
  m_consojhsg_im     NUMBER(12,2),
  m_consojhssii_im   NUMBER(12,2),
  m_consoftsg_im     NUMBER(12,2),
  m_consoftssii_im   NUMBER(12,2),
  m_consojhsg_fi     NUMBER(12,2),
  m_consojhssii_fi   NUMBER(12,2),
  m_consoftsg_fi     NUMBER(12,2),
  m_consoftssii_fi   NUMBER(12,2),
  m_consoenvsg_ni    NUMBER(12,2),
  m_consoenvssii_ni  NUMBER(12,2),
  m_consoenvsg_im    NUMBER(12,2),
  m_consoenvssii_im  NUMBER(12,2),
  a_consojh_im       NUMBER(12,2),
  a_consoft_im       NUMBER(12,2),
  a_consojh_fi       NUMBER(12,2),
  a_consoft_fi       NUMBER(12,2),
  a_consoenv_ni      NUMBER(12,2),
  a_consoenv_im      NUMBER(12,2)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.synthese_fin IS 'Synthèse financiere et comptable (FI/Immos) par ligne BIP, année, centre d''activité client, CAFI et code DPG de la ressource';

COMMENT ON COLUMN bip.synthese_fin.annee IS 'Année de référence';

COMMENT ON COLUMN bip.synthese_fin.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.synthese_fin.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.synthese_fin.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.synthese_fin.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.synthese_fin.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.synthese_fin.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.synthese_fin.consojhsg_im IS 'Consommé de l''année en jours hommes immobilisé pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.consojhssii_im IS 'Consommé de l''année en jours hommes immobilisé pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.consoftsg_im IS 'Consommé force de travail de l''année immobilisé en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.consoftssii_im IS 'Consommé force de travail de l''année immobilisé en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.consojhsg_fi IS 'Consommé de l''année en jours hommes en facturation interne pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.consojhssii_fi IS 'Consommé de l''année en jours hommes en facturation interne pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.consoftsg_fi IS 'Consommé force de travail de l''année en facturation interne en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.consoftssii_fi IS 'Consommé force de travail de l''année en facturation interne en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.consoenvsg_ni IS 'Consommé frais d''environnement de l''année non immobilisés en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.consoenvssii_ni IS 'Consommé frais d''environnement de l''année non immobilisés en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.consoenvsg_im IS 'Consommé frais d''environnement de l''année immobilisés en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.consoenvssii_im IS 'Consommé frais d''environnement de l''année immobilisés en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.d_consojhsg_fi IS 'Consommé de Décembre de l''année précédente en jours hommes en facturation interne pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.d_consojhssii_fi IS 'Consommé de Décembre de l''année précédente en jours hommes en facturation interne pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.d_consoftsg_fi IS 'Consommé force de travail de Décembre de l''année précédente en facturation interne en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.d_consoftssii_fi IS 'Consommé force de travail de Décembre de l''année précédente en facturation interne en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.d_consoenvsg_ni IS 'Consommé frais d''environnement de Décembre de l''année précédente non immobilisés en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.d_consoenvssii_ni IS 'Consommé frais d''environnement de Décembre de l''année précédente non immobilisés en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.d_consoenvsg_im IS 'Consommé frais d''environnement de Décembre de l''année précédente immobilisés en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.d_consoenvssii_im IS 'Consommé frais d''environnement de Décembre de l''année précédente immobilisés en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.m_consojhsg_im IS 'Consommé du mois en jours hommes immobilisé pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.m_consojhssii_im IS 'Consommé du mois en jours hommes immobilisé pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.m_consoftsg_im IS 'Consommé force de travail du mois immobilisé en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.m_consoftssii_im IS 'Consommé force de travail du mois immobilisé en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.m_consojhsg_fi IS 'Consommé du mois en jours hommes en facturation interne pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.m_consojhssii_fi IS 'Consommé du mois en jours hommes en facturation interne pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.m_consoftsg_fi IS 'Consommé force de travail du mois en facturation interne en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.m_consoftssii_fi IS 'Consommé force de travail du mois en facturation interne en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.m_consoenvsg_ni IS 'Consommé frais d''environnement du mois non immobilisés en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.m_consoenvssii_ni IS 'Consommé frais d''environnement du mois non immobilisés en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.m_consoenvsg_im IS 'Consommé frais d''environnement du mois immobilisés en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin.m_consoenvssii_im IS 'Consommé frais d''environnement du mois immobilisés en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin.a_consojh_im IS 'Retour arrière consommé du mois en jours hommes immobilisé';

COMMENT ON COLUMN bip.synthese_fin.a_consoft_im IS 'Retour arrière consommé force de travail du mois immobilisé en euros hors taxes récupérable';

COMMENT ON COLUMN bip.synthese_fin.a_consojh_fi IS 'Retour arrière consommé du mois en jours hommes en facturation interne';

COMMENT ON COLUMN bip.synthese_fin.a_consoft_fi IS 'Retour arrière consommé force de travail du mois en facturation interne en euros hors taxes récupérable';

COMMENT ON COLUMN bip.synthese_fin.a_consoenv_ni IS 'Retour arrière consommé frais d''environnement du mois non immobilisés en euros hors taxes récupérable';

COMMENT ON COLUMN bip.synthese_fin.a_consoenv_im IS 'Retour arrière consommé frais d''environnement du mois immobilisés en euros hors taxes récupérable';


ALTER TABLE bip.synthese_fin_bip DROP PRIMARY KEY CASCADE;
DROP TABLE bip.synthese_fin_bip CASCADE CONSTRAINTS;

--
-- SYNTHESE_FIN_BIP  (Table) 
--
CREATE TABLE bip.synthese_fin_bip
(
  annee           NUMBER(4)                     NOT NULL,
  pid             VARCHAR2(4)                   NOT NULL,
  consoftsg_im    NUMBER(12,2),
  consoftssii_im  NUMBER(12,2),
  consosg_fi      NUMBER(12,2),
  consossii_fi    NUMBER(12,2),
  d_consosg_fi    NUMBER(12,2),
  d_consossii_fi  NUMBER(12,2),
  m_consosg_fi    NUMBER(12,2)                  DEFAULT '0,00',
  m_consossii_fi  NUMBER(12,2)                  DEFAULT '0,00'
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.synthese_fin_bip IS 'Synthèse financiere et comptable (FI/Immos) par ligne BIP et année';

COMMENT ON COLUMN bip.synthese_fin_bip.m_consosg_fi IS 'Coût Mensuel en KEuros hors taxes en Facturation interne pour les ressources SG.';

COMMENT ON COLUMN bip.synthese_fin_bip.m_consossii_fi IS 'Coût Mensuel en KEuros hors taxes en Facturation interne pour les ressources SSII.';

COMMENT ON COLUMN bip.synthese_fin_bip.annee IS 'Année de référence';

COMMENT ON COLUMN bip.synthese_fin_bip.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.synthese_fin_bip.consoftsg_im IS 'Consommé de l''année immobilisé en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin_bip.consoftssii_im IS 'Consommé de l''année immobilisé en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin_bip.consosg_fi IS 'Consommé de l''année en facturation interne en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin_bip.consossii_fi IS 'Consommé de l''année en facturation interne en euros hors taxes récupérable pour les ressources SSII';

COMMENT ON COLUMN bip.synthese_fin_bip.d_consosg_fi IS 'Consommé de Décembre de l''année précédente en facturation interne en euros hors taxes récupérable pour les ressources SG';

COMMENT ON COLUMN bip.synthese_fin_bip.d_consossii_fi IS 'Consommé de Décembre de l''année précédente en facturation interne en euros hors taxes récupérable pour les ressources SSII';


ALTER TABLE bip.synthese_fin_ress DROP PRIMARY KEY CASCADE;
DROP TABLE bip.synthese_fin_ress CASCADE CONSTRAINTS;

--
-- SYNTHESE_FIN_RESS  (Table) 
--
CREATE TABLE bip.synthese_fin_ress
(
  annee          NUMBER(4)                      NOT NULL,
  pid            VARCHAR2(4)                    NOT NULL,
  ident          NUMBER(5)                      NOT NULL,
  codcamo        NUMBER(6)                      NOT NULL,
  cafi           NUMBER(6)                      NOT NULL,
  consojh_im     NUMBER(12,2),
  consojh_ni     NUMBER(12,2),
  consoft        NUMBER(12,2),
  consoenv_im    NUMBER(12,2),
  consoenv_ni    NUMBER(12,2),
  d_consojh_im   NUMBER(12,2),
  d_consojh_ni   NUMBER(12,2),
  d_consoft      NUMBER(12,2),
  d_consoenv_im  NUMBER(12,2),
  d_consoenv_ni  NUMBER(12,2)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.synthese_fin_ress IS 'Synthèse financiere (FI) par ligne BIP, ressource, centre d''activité client et CAFI ';

COMMENT ON COLUMN bip.synthese_fin_ress.annee IS 'Année de référence';

COMMENT ON COLUMN bip.synthese_fin_ress.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.synthese_fin_ress.ident IS 'Identifiant de la ressource';

COMMENT ON COLUMN bip.synthese_fin_ress.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.synthese_fin_ress.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.synthese_fin_ress.consojh_im IS 'Consommé de l''année en jours hommes immobilisable';

COMMENT ON COLUMN bip.synthese_fin_ress.consojh_ni IS 'Consommé de l''année en jours hommes non immobilisable';

COMMENT ON COLUMN bip.synthese_fin_ress.consoft IS 'Consommé force de travail de l''année ';

COMMENT ON COLUMN bip.synthese_fin_ress.consoenv_im IS 'Consommé frais d''environnement de l''année immobilisés en euros hors taxes récupérable ';

COMMENT ON COLUMN bip.synthese_fin_ress.consoenv_ni IS 'Consommé frais d''environnement de l''année non immobilisés en euros hors taxes récupérable';

COMMENT ON COLUMN bip.synthese_fin_ress.d_consojh_im IS 'Consommé de Décembre de l''année précédente en jours hommes immobilisable';

COMMENT ON COLUMN bip.synthese_fin_ress.d_consojh_ni IS 'Consommé de Décembre de l''année précédente en jours hommes non immobilisable';

COMMENT ON COLUMN bip.synthese_fin_ress.d_consoft IS 'Consommé force de travail de Décembre de l''année précédente ';

COMMENT ON COLUMN bip.synthese_fin_ress.d_consoenv_im IS 'Consommé frais d''environnement de Décembre de l''année précédente immobilisés en euros hors taxes récupérable ';

COMMENT ON COLUMN bip.synthese_fin_ress.d_consoenv_ni IS 'Consommé frais d''environnement de Décembre de l''année précédente non immobilisés en euros hors taxes récupérable';


ALTER TABLE bip.tache DROP PRIMARY KEY CASCADE;
DROP TABLE bip.tache CASCADE CONSTRAINTS;

--
-- TACHE  (Table) 
--
CREATE TABLE bip.tache
(
  acta         VARCHAR(2)                          NOT NULL,
  acst         VARCHAR(2)                          NOT NULL,
  aistty       VARCHAR(2),
  aistpid      VARCHAR2(4),
  adeb         DATE,
  afin         DATE,
  ande         DATE,
  anfi         DATE,
  adur         NUMBER(5),
  apcp         NUMBER(3),
  asnom        VARCHAR2(15),
  asta         VARCHAR(2),
  aist         VARCHAR(6),
  pid          VARCHAR2(4)                      NOT NULL,
  ecet         VARCHAR(2)                          NOT NULL,
  cdeb_max     DATE,
  motif_rejet  VARCHAR(1)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tache IS 'Table des tâches et des sous-tâches';

COMMENT ON COLUMN bip.tache.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.tache.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.tache.aistty IS '2 premiers caracteres de type sous tache';

COMMENT ON COLUMN bip.tache.aistpid IS 'Code projet client';

COMMENT ON COLUMN bip.tache.adeb IS 'Date initiale de debut';

COMMENT ON COLUMN bip.tache.afin IS 'Date initiale de fin';

COMMENT ON COLUMN bip.tache.ande IS 'Date revisee de debut';

COMMENT ON COLUMN bip.tache.anfi IS 'Date revisee de fin';

COMMENT ON COLUMN bip.tache.adur IS 'Duree de la sous tache';

COMMENT ON COLUMN bip.tache.apcp IS 'Pourcentage d''avancement de la ss-tache';

COMMENT ON COLUMN bip.tache.asnom IS 'Libelle de la sous tache';

COMMENT ON COLUMN bip.tache.asta IS 'Statut de la sous tache';

COMMENT ON COLUMN bip.tache.aist IS 'Type de sous tache';

COMMENT ON COLUMN bip.tache.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.tache.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.tache.cdeb_max IS 'Date maximale des consommés saisissables sur la sous-tâche';

COMMENT ON COLUMN bip.tache.motif_rejet IS 'Motif de rejet des consommés postérieurs à CDEB_MAX';


ALTER TABLE bip.tache_back DROP PRIMARY KEY CASCADE;
DROP TABLE bip.tache_back CASCADE CONSTRAINTS;

--
-- TACHE_BACK  (Table) 
--
CREATE TABLE bip.tache_back
(
  acta         VARCHAR(2)                          NOT NULL,
  acst         VARCHAR(2)                          NOT NULL,
  aistty       VARCHAR(2),
  aistpid      VARCHAR2(4),
  adeb         DATE,
  afin         DATE,
  ande         DATE,
  anfi         DATE,
  adur         NUMBER(5),
  apcp         NUMBER(3),
  asnom        VARCHAR2(15),
  asta         VARCHAR(2),
  aist         VARCHAR(6),
  pid          VARCHAR2(4)                      NOT NULL,
  ecet         VARCHAR(2)                          NOT NULL,
  cdeb_max     DATE,
  motif_rejet  VARCHAR(1)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tache_back IS 'Sauvegarde de la table TACHE utilisée dans le traitement mensuel';

COMMENT ON COLUMN bip.tache_back.acta IS 'Numero de la tache';

COMMENT ON COLUMN bip.tache_back.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.tache_back.aistty IS '2 premiers caracteres de type sous tache';

COMMENT ON COLUMN bip.tache_back.aistpid IS 'Code projet client';

COMMENT ON COLUMN bip.tache_back.adeb IS 'Date initiale de debut';

COMMENT ON COLUMN bip.tache_back.afin IS 'Date initiale de fin';

COMMENT ON COLUMN bip.tache_back.ande IS 'Date revisee de debut';

COMMENT ON COLUMN bip.tache_back.anfi IS 'Date revisee de fin';

COMMENT ON COLUMN bip.tache_back.adur IS 'Duree de la sous tache';

COMMENT ON COLUMN bip.tache_back.apcp IS 'Pourcentage d''avancement de la ss-tache';

COMMENT ON COLUMN bip.tache_back.asnom IS 'Libelle de la sous tache';

COMMENT ON COLUMN bip.tache_back.asta IS 'Statut de la sous tache';

COMMENT ON COLUMN bip.tache_back.aist IS 'Type de sous tache';

COMMENT ON COLUMN bip.tache_back.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.tache_back.ecet IS 'Numero de l''etape';

COMMENT ON COLUMN bip.tache_back.cdeb_max IS 'Date maximale des consommés saisissables sur la sous-tâche';

COMMENT ON COLUMN bip.tache_back.motif_rejet IS 'Motif de rejet des consommés postérieurs à CDEB_MAX';


ALTER TABLE bip.tache_rejet_datestatut DROP PRIMARY KEY CASCADE;
DROP TABLE bip.tache_rejet_datestatut CASCADE CONSTRAINTS;

--
-- TACHE_REJET_DATESTATUT  (Table) 
--
CREATE TABLE bip.tache_rejet_datestatut
(
  acta      VARCHAR(2)                             NOT NULL,
  acst      VARCHAR(2)                             NOT NULL,
  aistty    VARCHAR(2),
  aistpid   VARCHAR2(4),
  adeb      DATE,
  afin      DATE,
  ande      DATE,
  anfi      DATE,
  adur      NUMBER(5),
  apcp      NUMBER(3),
  asnom     VARCHAR2(15),
  asta      VARCHAR(2),
  aist      VARCHAR(6),
  pid       VARCHAR2(4)                         NOT NULL,
  ecet      VARCHAR(2)                             NOT NULL,
  ecet_new  VARCHAR2(2),
  acta_new  VARCHAR2(2),
  acst_new  VARCHAR2(2)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tache_rejet_datestatut IS 'Table de sauvegarde contenant la liste des tâches et sous-tâches portant sur des lignes BIP fermées ( en direct ou en sous-traitance ). Ces données seront ensuite réinsérées dans la table TACHE cela afin de garder les valeurs d''origine pour ces cas de figure';

COMMENT ON COLUMN bip.tache_rejet_datestatut.acta IS 'Numéro de la tâche';

COMMENT ON COLUMN bip.tache_rejet_datestatut.acst IS 'Numéro de la sous tâche';

COMMENT ON COLUMN bip.tache_rejet_datestatut.aistty IS 'Indique si sous-traitance ( si = FF )';

COMMENT ON COLUMN bip.tache_rejet_datestatut.aistpid IS 'Ligne bip sur laquelle on sous-traite';

COMMENT ON COLUMN bip.tache_rejet_datestatut.adeb IS 'Date initiale de début';

COMMENT ON COLUMN bip.tache_rejet_datestatut.afin IS 'Date initiale de fin';

COMMENT ON COLUMN bip.tache_rejet_datestatut.ande IS 'Date revisee de debut';

COMMENT ON COLUMN bip.tache_rejet_datestatut.anfi IS 'Date initiale de fin';

COMMENT ON COLUMN bip.tache_rejet_datestatut.adur IS 'Duree de la sous tache';

COMMENT ON COLUMN bip.tache_rejet_datestatut.apcp IS 'Pourcentage d''avancement de la ss-tache';

COMMENT ON COLUMN bip.tache_rejet_datestatut.asnom IS 'Libellé de la sous tâche';

COMMENT ON COLUMN bip.tache_rejet_datestatut.asta IS 'Statut de la sous tache';

COMMENT ON COLUMN bip.tache_rejet_datestatut.aist IS 'Type de sous tâche';

COMMENT ON COLUMN bip.tache_rejet_datestatut.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.tache_rejet_datestatut.ecet IS 'Numéro de l''étape';

COMMENT ON COLUMN bip.tache_rejet_datestatut.ecet_new IS 'Nouveau numero de l''etape';

COMMENT ON COLUMN bip.tache_rejet_datestatut.acta_new IS 'Nouveau numero de la tache';

COMMENT ON COLUMN bip.tache_rejet_datestatut.acst_new IS 'Nouveau numero de sous tache';


ALTER TABLE bip.taux_charge_salariale DROP PRIMARY KEY CASCADE;
DROP TABLE bip.taux_charge_salariale CASCADE CONSTRAINTS;

--
-- TAUX_CHARGE_SALARIALE  (Table) 
--
CREATE TABLE bip.taux_charge_salariale
(
  annee     NUMBER(4)                           NOT NULL,
  taux      NUMBER(6,2)                         NOT NULL,
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.taux_charge_salariale IS 'Table de stockage du taux de charge salariale';

COMMENT ON COLUMN bip.taux_charge_salariale.annee IS 'Année de référence';

COMMENT ON COLUMN bip.taux_charge_salariale.taux IS 'Taux de charge salariale';

COMMENT ON COLUMN bip.taux_charge_salariale.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.taux_recup DROP PRIMARY KEY CASCADE;
DROP TABLE bip.taux_recup CASCADE CONSTRAINTS;

--
-- TAUX_RECUP  (Table) 
--
CREATE TABLE bip.taux_recup
(
  annee    NUMBER(4)                            NOT NULL,
  taux     NUMBER(9,2)                          NOT NULL,
  filcode  VARCHAR(3)                              DEFAULT '01'                  NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.taux_recup IS 'Table de stockage du taux de récupération';

COMMENT ON COLUMN bip.taux_recup.filcode IS 'Code de la filiale';

COMMENT ON COLUMN bip.taux_recup.annee IS 'Année de référence';

COMMENT ON COLUMN bip.taux_recup.taux IS 'Taux de récupération. Utilisé dans la calcul des montants en hors taxes récupérable';

DROP TABLE bip.tmpedsstr CASCADE CONSTRAINTS;

--
-- TMPEDSSTR  (Table) 
--
CREATE TABLE bip.tmpedsstr
(
  pole_e   VARCHAR2(5),
  pole_r   VARCHAR2(5),
  pid_r    VARCHAR2(4),
  ident    NUMBER(5),
  cout     NUMBER(12,2),
  coutfi   NUMBER(12,2),
  cusag    NUMBER(7,2),
  pid_e    VARCHAR2(4),
  codsg    VARCHAR2(7),
  societe  VARCHAR2(4),
  sstr     VARCHAR2(1)
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmpedsstr IS 'Table temporaire pour le report edsstr1.rdf ainsi que pour l''extraction edsstr.sql - menu : Lignes BIP - Sous-traitance';

COMMENT ON COLUMN bip.tmpedsstr.pole_e IS 'Pôle émetteur';

COMMENT ON COLUMN bip.tmpedsstr.pole_r IS 'Pôle récepteur';

COMMENT ON COLUMN bip.tmpedsstr.pid_r IS 'Ligne BIP qui reçoit la sous-traitance';

COMMENT ON COLUMN bip.tmpedsstr.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.tmpedsstr.cout IS 'Cout journalier ht de la ressource';

COMMENT ON COLUMN bip.tmpedsstr.coutfi IS 'Cout journalier';

COMMENT ON COLUMN bip.tmpedsstr.cusag IS 'Consomme du mois';

COMMENT ON COLUMN bip.tmpedsstr.pid_e IS 'Ligne BIP qui emet la sous-traitance';

COMMENT ON COLUMN bip.tmpedsstr.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.tmpedsstr.societe IS 'Code societe de la ressource';

COMMENT ON COLUMN bip.tmpedsstr.sstr IS 'Type de sous-traitance. F=Fournie , R=Reçue';


DROP TABLE bip.tmpfe60 CASCADE CONSTRAINTS;

--
-- TMPFE60  (Table) 
--
CREATE TABLE bip.tmpfe60
(
  numseq         NUMBER                         NOT NULL,
  coddep         NUMBER(3),
  coddeppole     NUMBER(5),
  count_pascont  NUMBER,
  count00_30     NUMBER,
  count31_60     NUMBER,
  count61_90     NUMBER,
  count91_120    NUMBER,
  count120       NUMBER
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmpfe60 IS 'Table temporaire pour le report fe60.rdf (Factures en attente de règlement)';

COMMENT ON COLUMN bip.tmpfe60.numseq IS 'Numéro de séquence';

COMMENT ON COLUMN bip.tmpfe60.coddep IS 'Code departement (=division)';

COMMENT ON COLUMN bip.tmpfe60.coddeppole IS 'Concatenation des codes départements et pôles';

COMMENT ON COLUMN bip.tmpfe60.count_pascont IS 'Nombre de factures sans contrat';

COMMENT ON COLUMN bip.tmpfe60.count00_30 IS 'Nombre de factures en attente depuis moins de 30 jours';

COMMENT ON COLUMN bip.tmpfe60.count31_60 IS 'Nombre de factures en attente depuis 31 à 60 jours';

COMMENT ON COLUMN bip.tmpfe60.count61_90 IS 'Nombre de factures en attente depuis 61 à 90 jours';

COMMENT ON COLUMN bip.tmpfe60.count91_120 IS 'Nombre de factures en attente depuis 91 à 120 jours';

COMMENT ON COLUMN bip.tmpfe60.count120 IS 'Nombre de factures en attente depuis plus de 120 jours';


DROP TABLE bip.tmprapsynt CASCADE CONSTRAINTS;

--
-- TMPRAPSYNT  (Table) 
--
CREATE TABLE bip.tmprapsynt
(
  numseq        NUMBER                          NOT NULL,
  codsg         NUMBER(7),
  codcompta     VARCHAR2(11),
  jh_fac_eq0    NUMBER,
  mc_fac_eq0    NUMBER,
  jh_fac_eqcon  NUMBER,
  mf_fac_eqcon  NUMBER,
  mc_fac_eqcon  NUMBER,
  jh_fac_necon  NUMBER,
  mf_fac_necon  NUMBER,
  mc_fac_necon  NUMBER,
  mf_con_eq0    NUMBER,
  fact_aa1      NUMBER
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmprapsynt IS 'Table temporaire pour l''état rapsynt.rdf (edition de rapprochement / synthèse)';

COMMENT ON COLUMN bip.tmprapsynt.numseq IS 'Numéro de séquence';

COMMENT ON COLUMN bip.tmprapsynt.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.tmprapsynt.codcompta IS 'Code comptable';

COMMENT ON COLUMN bip.tmprapsynt.jh_fac_eq0 IS 'Jours hommes sans factures';

COMMENT ON COLUMN bip.tmprapsynt.mc_fac_eq0 IS 'Montant des jours hommes sans factures';

COMMENT ON COLUMN bip.tmprapsynt.jh_fac_eqcon IS 'Jours hommes rapprochés';

COMMENT ON COLUMN bip.tmprapsynt.mf_fac_eqcon IS 'Montant factures des jours hommes rapprochés';

COMMENT ON COLUMN bip.tmprapsynt.mc_fac_eqcon IS 'Montant des jours hommes rapprochés';

COMMENT ON COLUMN bip.tmprapsynt.jh_fac_necon IS 'Jours hommes non rapprochés';

COMMENT ON COLUMN bip.tmprapsynt.mf_fac_necon IS 'Montant factures des jours hommes non rapprochés';

COMMENT ON COLUMN bip.tmprapsynt.mc_fac_necon IS 'Montant des jours hommes non rapprochés';

COMMENT ON COLUMN bip.tmprapsynt.mf_con_eq0 IS 'Montant des factures sans jours hommes';

COMMENT ON COLUMN bip.tmprapsynt.fact_aa1 IS 'Consomme des années antérieures';


DROP TABLE bip.tmpreftrans CASCADE CONSTRAINTS;

--
-- TMPREFTRANS  (Table) 
--
CREATE TABLE bip.tmpreftrans
(
  numseq       NUMBER                           NOT NULL,
  codedp       NUMBER(5),
  sigdp        VARCHAR2(7),
  pid          VARCHAR2(4),
  ptype        VARCHAR2(2),
  codcamo      NUMBER(6),
  libprojet    VARCHAR2(30),
  chefprojet   VARCHAR2(30),
  cumuljh      NUMBER(12,1),
  consojh      NUMBER(7,1),
  facint       NUMBER(12,2),
  reestjh      NUMBER(13),
  propojh      NUMBER(12,2),
  notifjh      NUMBER(12,2),
  reserjh      NUMBER(12,2),
  arbitjh      NUMBER(12,2),
  propojhn1    NUMBER(12,2),
  codmo        VARCHAR2(5),
  sigdirmo     VARCHAR2(8),
  codgroup     VARCHAR(5),
  fils         NUMBER(1),
  propomojh    NUMBER(12,2),
  propomojhn1  NUMBER(12,2),
  nomgroup     VARCHAR2(50),
  metier       VARCHAR(3),
  arctype      VARCHAR2(3),
  codsg        NUMBER(7),
  libdsg       VARCHAR2(30)
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmpreftrans IS 'Table temporaire pour les reports reftrans.rdf et proref4.rdf (référentiel au choix)';

COMMENT ON COLUMN bip.tmpreftrans.numseq IS 'Numéro de séquence';

COMMENT ON COLUMN bip.tmpreftrans.codedp IS 'Concatenation des codes départements et pôles';

COMMENT ON COLUMN bip.tmpreftrans.sigdp IS 'Sigle département/Sigle pôle';

COMMENT ON COLUMN bip.tmpreftrans.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.tmpreftrans.ptype IS 'Type de projet : 1 2 3 4 5 6 7 8 9';

COMMENT ON COLUMN bip.tmpreftrans.codcamo IS 'Code centre d''activite maîtrise d''ouvrage';

COMMENT ON COLUMN bip.tmpreftrans.libprojet IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.tmpreftrans.chefprojet IS 'Nom du chef de projet';

COMMENT ON COLUMN bip.tmpreftrans.cumuljh IS 'Consommé en jours hommes depuis l''origine';

COMMENT ON COLUMN bip.tmpreftrans.consojh IS 'Consommé en jours hommes de l''année';

COMMENT ON COLUMN bip.tmpreftrans.facint IS 'Somme du montant consommé (force de travail + environnement)';

COMMENT ON COLUMN bip.tmpreftrans.reestjh IS 'Budget réestimé de l''année courante';

COMMENT ON COLUMN bip.tmpreftrans.propojh IS 'Budget proposé fournisseur de l''année courante';

COMMENT ON COLUMN bip.tmpreftrans.notifjh IS 'Budget notifié de l''année courante';

COMMENT ON COLUMN bip.tmpreftrans.reserjh IS 'Budget réserve (plus utilisé)';

COMMENT ON COLUMN bip.tmpreftrans.arbitjh IS 'Budget arbitré de l''année courante';

COMMENT ON COLUMN bip.tmpreftrans.propojhn1 IS 'Budget proposé fournisseur de l''année suivante';

COMMENT ON COLUMN bip.tmpreftrans.codmo IS 'Code client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.tmpreftrans.sigdirmo IS 'Sigle client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.tmpreftrans.codgroup IS 'Code du projet informatique';

COMMENT ON COLUMN bip.tmpreftrans.fils IS 'Indique si projet informatique rattaché à un autre projet informatique ( valeur 1 sinon 0)';

COMMENT ON COLUMN bip.tmpreftrans.propomojh IS 'Budget proposé client de l''année courante';

COMMENT ON COLUMN bip.tmpreftrans.propomojhn1 IS 'Budget proposé client de l''année suivante';

COMMENT ON COLUMN bip.tmpreftrans.nomgroup IS 'Libellé du projet informatique';

COMMENT ON COLUMN bip.tmpreftrans.metier IS 'Métier de la ligne IP';

COMMENT ON COLUMN bip.tmpreftrans.arctype IS 'Identifiant de l''architecture, typologie secondaire';

COMMENT ON COLUMN bip.tmpreftrans.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.tmpreftrans.libdsg IS 'Libellé departement pole groupe';


DROP TABLE bip.tmp_appli CASCADE CONSTRAINTS;

--
-- TMP_APPLI  (Table) 
--
CREATE TABLE bip.tmp_appli
(
  airt       VARCHAR2(5),
  alibel     VARCHAR2(50),
  alibcourt  VARCHAR2(20),
  amnemo     VARCHAR2(5),
  acdareg    VARCHAR2(5),
  codsg      VARCHAR2(7),
  acme       VARCHAR2(35),
  clicode    VARCHAR2(5),
  amop       VARCHAR2(35),
  codgappli  VARCHAR2(5),
  agappli    VARCHAR2(35),
  adescr1    VARCHAR2(70),
  adescr2    VARCHAR2(70),
  adescr3    VARCHAR2(70),
  adescr4    VARCHAR2(70),
  adescr5    VARCHAR2(70),
  adescr6    VARCHAR2(70)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_appli IS 'Table de chargement des applications. Chargée par Sql Loader';

COMMENT ON COLUMN bip.tmp_appli.adescr2 IS 'Description de l''application';

COMMENT ON COLUMN bip.tmp_appli.adescr3 IS 'Description de l''application';

COMMENT ON COLUMN bip.tmp_appli.adescr4 IS 'Description de l''application';

COMMENT ON COLUMN bip.tmp_appli.adescr5 IS 'Description de l''application';

COMMENT ON COLUMN bip.tmp_appli.adescr6 IS 'Description de l''application';

COMMENT ON COLUMN bip.tmp_appli.airt IS 'Identifiant de l''application';

COMMENT ON COLUMN bip.tmp_appli.alibel IS 'Libelle de l''application';

COMMENT ON COLUMN bip.tmp_appli.alibcourt IS 'Libellé court';

COMMENT ON COLUMN bip.tmp_appli.amnemo IS 'Mnemonique de l''application';

COMMENT ON COLUMN bip.tmp_appli.acdareg IS 'Code de l''application de regroupement';

COMMENT ON COLUMN bip.tmp_appli.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.tmp_appli.acme IS 'Nom de la maîtrise d''oeuvre principale';

COMMENT ON COLUMN bip.tmp_appli.clicode IS 'Code client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.tmp_appli.amop IS 'Nom de la MO principale';

COMMENT ON COLUMN bip.tmp_appli.codgappli IS 'Code du gestionnaire de l''application (équivaut à un code client)';

COMMENT ON COLUMN bip.tmp_appli.agappli IS 'Nom du gestionnaire de l''application';

COMMENT ON COLUMN bip.tmp_appli.adescr1 IS 'Description de l''application';


DROP TABLE bip.tmp_appli_rejet CASCADE CONSTRAINTS;

--
-- TMP_APPLI_REJET  (Table) 
--
CREATE TABLE bip.tmp_appli_rejet
(
  airt       VARCHAR2(5),
  alibel     VARCHAR2(50),
  alibcourt  VARCHAR2(20),
  amnemo     VARCHAR2(5),
  acdareg    VARCHAR2(5),
  codsg      VARCHAR2(7),
  acme       VARCHAR2(35),
  clicode    VARCHAR2(5),
  amop       VARCHAR2(35),
  codgappli  VARCHAR2(5),
  agappli    VARCHAR2(35),
  adescr1    VARCHAR2(70),
  adescr2    VARCHAR2(70),
  adescr3    VARCHAR2(70),
  adescr4    VARCHAR2(70),
  adescr5    VARCHAR2(70),
  adescr6    VARCHAR2(70),
  rejet      VARCHAR2(100)
)
TABLESPACE  tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_appli_rejet IS 'Table des enregistrements rejetés lors du chargement des applications par Sql Loader';

COMMENT ON COLUMN bip.tmp_appli_rejet.airt IS 'Identifiant de l''application';

COMMENT ON COLUMN bip.tmp_appli_rejet.alibel IS 'Libelle de l''application';

COMMENT ON COLUMN bip.tmp_appli_rejet.alibcourt IS 'Libellé court';

COMMENT ON COLUMN bip.tmp_appli_rejet.amnemo IS 'Mnemonique de l''application';

COMMENT ON COLUMN bip.tmp_appli_rejet.acdareg IS 'Code de l''application de regroupement';

COMMENT ON COLUMN bip.tmp_appli_rejet.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.tmp_appli_rejet.acme IS 'Nom de la maîtrise d''oeuvre principale';

COMMENT ON COLUMN bip.tmp_appli_rejet.clicode IS 'Code client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.tmp_appli_rejet.amop IS 'Nom de la MO principale';

COMMENT ON COLUMN bip.tmp_appli_rejet.codgappli IS 'Code du gestionnaire de l''application (équivaut à un code client)';

COMMENT ON COLUMN bip.tmp_appli_rejet.agappli IS 'Nom du gestionnaire de l''application';

COMMENT ON COLUMN bip.tmp_appli_rejet.adescr1 IS 'Description de l''application';

COMMENT ON COLUMN bip.tmp_appli_rejet.adescr2 IS 'Description de l''application';

COMMENT ON COLUMN bip.tmp_appli_rejet.adescr3 IS 'Description de l''application';

COMMENT ON COLUMN bip.tmp_appli_rejet.adescr4 IS 'Description de l''application';

COMMENT ON COLUMN bip.tmp_appli_rejet.adescr5 IS 'Description de l''application';

COMMENT ON COLUMN bip.tmp_appli_rejet.adescr6 IS 'Description de l''application';

COMMENT ON COLUMN bip.tmp_appli_rejet.rejet IS 'Explication du rejet';


DROP TABLE bip.tmp_budget_sstache CASCADE CONSTRAINTS;

--
-- TMP_BUDGET_SSTACHE  (Table) 
--
CREATE TABLE bip.tmp_budget_sstache
(
  numseq  NUMBER                                NOT NULL,
  typeb   VARCHAR(1)                               NOT NULL,
  pid     VARCHAR2(4)                           NOT NULL,
  histo   VARCHAR2(15),
  minus1  VARCHAR2(15),
  n       VARCHAR2(15),
  plus1   VARCHAR2(15),
  plus2   VARCHAR2(15),
  plus3   VARCHAR2(15),
  total   VARCHAR2(15)
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          20m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_budget_sstache IS 'Table temporaire pour les reports prodec2.rdf, prodectop_mens.rdf, prodec3_mens.rdf, projprin.rdf, restab10.rdf, prodecl_mens.rdf';

COMMENT ON COLUMN bip.tmp_budget_sstache.numseq IS 'Numéro de séquence';

COMMENT ON COLUMN bip.tmp_budget_sstache.typeb IS 'Type de budget : A=Proposé fournisseur , B=Notifié , C=Arbitré, D=Reestimé, E:Consommé';

COMMENT ON COLUMN bip.tmp_budget_sstache.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.tmp_budget_sstache.histo IS 'Budget depuis l''origine';

COMMENT ON COLUMN bip.tmp_budget_sstache.minus1 IS 'Budget de l''année dernière';

COMMENT ON COLUMN bip.tmp_budget_sstache.n IS 'Budget de l''année courante';

COMMENT ON COLUMN bip.tmp_budget_sstache.plus1 IS 'Budget de l''année courante plus 1 an';

COMMENT ON COLUMN bip.tmp_budget_sstache.plus2 IS 'Budget de l''année courante plus 2 ans';

COMMENT ON COLUMN bip.tmp_budget_sstache.plus3 IS 'Budget de l''année courante plus 3 ans';

COMMENT ON COLUMN bip.tmp_budget_sstache.total IS 'Somme des budgets des années passées et de l''année courante';


DROP TABLE bip.tmp_conso_sstache CASCADE CONSTRAINTS;

--
-- TMP_CONSO_SSTACHE  (Table) 
--
CREATE TABLE bip.tmp_conso_sstache
(
  numseq   NUMBER                               NOT NULL,
  typetap  VARCHAR(2),
  ID       VARCHAR(6),
  asnom    VARCHAR2(15),
  pid      VARCHAR2(4)                          NOT NULL,
  codsg    NUMBER(7),
  pnom     VARCHAR2(30),
  acst     VARCHAR(2),
  janv     NUMBER(7,2),
  fevr     NUMBER(7,2),
  mars     NUMBER(7,2),
  avril    NUMBER(7,2),
  mai      NUMBER(7,2),
  juin     NUMBER(7,2),
  juil     NUMBER(7,2),
  aout     NUMBER(7,2),
  sept     NUMBER(7,2),
  octo     NUMBER(7,2),
  nove     NUMBER(7,2),
  dece     NUMBER(7,2),
  aist     VARCHAR2(6)
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    90
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          20m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_conso_sstache IS 'Table des enregistrements rejetés lors du chargement des applications par Sql Loader';

COMMENT ON COLUMN bip.tmp_conso_sstache.aist IS 'Type de la sous-tâche';

COMMENT ON COLUMN bip.tmp_conso_sstache.numseq IS 'Numéro de séquence';

COMMENT ON COLUMN bip.tmp_conso_sstache.typetap IS 'Type d''etape';

COMMENT ON COLUMN bip.tmp_conso_sstache.ID IS 'FF et ligne bip sous traitance';

COMMENT ON COLUMN bip.tmp_conso_sstache.asnom IS 'Libelle de la sous tache';

COMMENT ON COLUMN bip.tmp_conso_sstache.pid IS 'Identifiant de la ligne bip';

COMMENT ON COLUMN bip.tmp_conso_sstache.codsg IS 'Code departement pole groupe';

COMMENT ON COLUMN bip.tmp_conso_sstache.pnom IS 'Libelle du projet';

COMMENT ON COLUMN bip.tmp_conso_sstache.acst IS 'Numero de sous tache';

COMMENT ON COLUMN bip.tmp_conso_sstache.janv IS 'Consommé du mois de Janvier';

COMMENT ON COLUMN bip.tmp_conso_sstache.fevr IS 'Consommé du mois de Février';

COMMENT ON COLUMN bip.tmp_conso_sstache.mars IS 'Consommé du mois de Mars';

COMMENT ON COLUMN bip.tmp_conso_sstache.avril IS 'Consommé du mois de Avril';

COMMENT ON COLUMN bip.tmp_conso_sstache.mai IS 'Consommé du mois de Mai';

COMMENT ON COLUMN bip.tmp_conso_sstache.juin IS 'Consommé du mois de Juin';

COMMENT ON COLUMN bip.tmp_conso_sstache.juil IS 'Consommé du mois de Juillet';

COMMENT ON COLUMN bip.tmp_conso_sstache.aout IS 'Consommé du mois de Août';

COMMENT ON COLUMN bip.tmp_conso_sstache.sept IS 'Consommé du mois de Septembre';

COMMENT ON COLUMN bip.tmp_conso_sstache.octo IS 'Consommé du mois de Octobre';

COMMENT ON COLUMN bip.tmp_conso_sstache.nove IS 'Consommé du mois de Novembre';

COMMENT ON COLUMN bip.tmp_conso_sstache.dece IS 'Consommé du mois de Décembre';


DROP TABLE bip.tmp_contrat CASCADE CONSTRAINTS;

--
-- TMP_CONTRAT  (Table) 
--
CREATE TABLE bip.tmp_contrat
(
  id_oalia    VARCHAR2(15),
  numcont     VARCHAR2(15),
  cav         VARCHAR(2),
  dpg         NUMBER(7),
  soccont     VARCHAR2(4),
  cagrement   VARCHAR(2),
  datarr      DATE,
  objet       VARCHAR2(100),
  comcode     VARCHAR2(11),
  typefact    VARCHAR(1),
  coutot      NUMBER(12,2),
  charesti    NUMBER(5,1),
  datdeb      DATE,
  datfin      DATE,
  retour      VARCHAR2(50),
  date_trait  DATE
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_contrat IS 'Table utilisée pour le chargement des contrats venant de OALIA - RESAO';

COMMENT ON COLUMN bip.tmp_contrat.id_oalia IS 'Identifiant enregistrement interne OALIA';

COMMENT ON COLUMN bip.tmp_contrat.numcont IS 'N° de contrat';

COMMENT ON COLUMN bip.tmp_contrat.cav IS 'Numéro d''avenant';

COMMENT ON COLUMN bip.tmp_contrat.dpg IS 'Code Département/Pôle/Groupe';

COMMENT ON COLUMN bip.tmp_contrat.soccont IS 'Code société du contrat';

COMMENT ON COLUMN bip.tmp_contrat.cagrement IS 'Date de début';

COMMENT ON COLUMN bip.tmp_contrat.datarr IS 'Date de fin';

COMMENT ON COLUMN bip.tmp_contrat.objet IS 'Proposé d''origine';

COMMENT ON COLUMN bip.tmp_contrat.comcode IS 'Code comptable';

COMMENT ON COLUMN bip.tmp_contrat.typefact IS 'Type de facturation';

COMMENT ON COLUMN bip.tmp_contrat.coutot IS 'Cout total évalué';

COMMENT ON COLUMN bip.tmp_contrat.charesti IS 'Charge estimée';

COMMENT ON COLUMN bip.tmp_contrat.datdeb IS 'Date de début';

COMMENT ON COLUMN bip.tmp_contrat.datfin IS 'Date de fin';

COMMENT ON COLUMN bip.tmp_contrat.retour IS 'Commentaire sur insertion de la ligne contrat';

COMMENT ON COLUMN bip.tmp_contrat.date_trait IS 'Date à laquelle le traitement a tourné';


DROP TABLE bip.tmp_factae CASCADE CONSTRAINTS;

--
-- TMP_FACTAE  (Table) 
--
CREATE TABLE bip.tmp_factae
(
  fcoduser      VARCHAR2(255)                   NOT NULL,
  socfact       VARCHAR(4)                         NOT NULL,
  typfact       VARCHAR(1)                         NOT NULL,
  numfact       VARCHAR(15)                        NOT NULL,
  lnum          NUMBER(2)                       NOT NULL,
  datfact       DATE                            NOT NULL,
  date_reglt    DATE,
  montht        NUMBER(12,2),
  tva           NUMBER(9,2),
  socfour       VARCHAR2(10),
  libsocfour    VARCHAR2(25),
  moisprest     DATE,
  codcompta     VARCHAR2(11),
  dpg           NUMBER(7),
  centre_frais  NUMBER(3),
  date_envoi    DATE
)
TABLESPACE tbs_bip_fact_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_factae IS 'Table temporaire pour le report factae.rdf et pour l''extraction expcompt.sql - menu ordonnancement : Import Export - Résultats exports';

COMMENT ON COLUMN bip.tmp_factae.fcoduser IS 'Utilisateur ayant les droits pour la facture';

COMMENT ON COLUMN bip.tmp_factae.socfact IS 'Identifiant societe';

COMMENT ON COLUMN bip.tmp_factae.typfact IS 'Type de la facture';

COMMENT ON COLUMN bip.tmp_factae.numfact IS 'Numero de facture';

COMMENT ON COLUMN bip.tmp_factae.lnum IS 'Numéro de ligne facture';

COMMENT ON COLUMN bip.tmp_factae.datfact IS 'Date de la facture';

COMMENT ON COLUMN bip.tmp_factae.date_reglt IS 'Date de règlement souhaitée';

COMMENT ON COLUMN bip.tmp_factae.montht IS 'Montant HT';

COMMENT ON COLUMN bip.tmp_factae.tva IS 'Taux de tva';

COMMENT ON COLUMN bip.tmp_factae.socfour IS 'Identifiant de l''agence';

COMMENT ON COLUMN bip.tmp_factae.libsocfour IS 'Libellé de l''agence';

COMMENT ON COLUMN bip.tmp_factae.moisprest IS 'Mois de prestation';

COMMENT ON COLUMN bip.tmp_factae.codcompta IS 'Code comptable';

COMMENT ON COLUMN bip.tmp_factae.dpg IS 'departement pole groupe';

COMMENT ON COLUMN bip.tmp_factae.centre_frais IS 'Centre de frais';

COMMENT ON COLUMN bip.tmp_factae.date_envoi IS 'Date de l''envoi';


ALTER TABLE bip.tmp_fair DROP PRIMARY KEY CASCADE;
DROP TABLE bip.tmp_fair CASCADE CONSTRAINTS;

--
-- TMP_FAIR  (Table) 
--
CREATE TABLE bip.tmp_fair
(
  type_enreg        NUMBER(1),
  ident             NUMBER(5),
  date_crea         VARCHAR2(8),
  date_emi          VARCHAR2(8),
  TYPE              VARCHAR2(50),
  cavcont           VARCHAR2(20),
  carat             VARCHAR2(20),
  codsg             NUMBER(7),
  libdpg            VARCHAR2(50),
  numligne          NUMBER(1),
  rnom              VARCHAR2(50),
  code_comta        VARCHAR2(20),
  qualif            VARCHAR(3),
  sms               VARCHAR2(9),
  centre_activite   VARCHAR2(20),
  camo              VARCHAR2(20),
  dpcode            NUMBER(5),
  libdpcode         VARCHAR2(40),
  icpi              VARCHAR(5),
  libproj           VARCHAR2(40),
  cout              NUMBER(12,2),
  cusag             NUMBER(12,2),
  unite_oeuvre      VARCHAR(1),
  montantht         NUMBER(12,2),
  tva               NUMBER(9,2),
  taux_recup        NUMBER(9,2),
  code_classe       VARCHAR(4),
  code_iso          VARCHAR(3),
  date_fin_contrat  VARCHAR2(8),
  rtype             VARCHAR(1),
  pid               VARCHAR2(4),
  pnom              VARCHAR2(50),
  societe           VARCHAR(4),
  libsoc            VARCHAR2(25)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          20m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_fair IS 'Table de travail utilisée lors de l''alimentation de l''application FAIR';

COMMENT ON COLUMN bip.tmp_fair.type_enreg IS 'Type d''enregistrement ( égal à 2) ';

COMMENT ON COLUMN bip.tmp_fair.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.tmp_fair.date_crea IS 'Mois du consommé';

COMMENT ON COLUMN bip.tmp_fair.date_emi IS 'Mois du consommé';

COMMENT ON COLUMN bip.tmp_fair.TYPE IS 'Type de la ligne BIP ( code et libellé )';

COMMENT ON COLUMN bip.tmp_fair.cavcont IS 'Numéro d''avenant et numéro de contrat de la ressource';

COMMENT ON COLUMN bip.tmp_fair.carat IS 'Code dépendant de la filiale ( SGPM=S0001 sinon =S6640)';

COMMENT ON COLUMN bip.tmp_fair.codsg IS 'Code DPG de la ressource';

COMMENT ON COLUMN bip.tmp_fair.libdpg IS 'Branche/Direction/Département/Pôle';

COMMENT ON COLUMN bip.tmp_fair.numligne IS 'Numéro de ligne ( égal à 1)';

COMMENT ON COLUMN bip.tmp_fair.rnom IS 'Nom de la ressource si Forfait , blanc sinon';

COMMENT ON COLUMN bip.tmp_fair.code_comta IS 'Code Comptable';

COMMENT ON COLUMN bip.tmp_fair.qualif IS 'Qualification de la ressource';

COMMENT ON COLUMN bip.tmp_fair.sms IS 'Identifiant de l''agence';

COMMENT ON COLUMN bip.tmp_fair.centre_activite IS 'Centre d''activité du DPG de la ressource';

COMMENT ON COLUMN bip.tmp_fair.camo IS 'Centre d''activité de la ligne BIP';

COMMENT ON COLUMN bip.tmp_fair.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.tmp_fair.libdpcode IS 'Libellé du dossier projet';

COMMENT ON COLUMN bip.tmp_fair.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.tmp_fair.libproj IS 'Libellé du projet informatique';

COMMENT ON COLUMN bip.tmp_fair.cout IS 'Cout HT de la ressource';

COMMENT ON COLUMN bip.tmp_fair.cusag IS 'Consommé en JH de la ressource pour le mois';

COMMENT ON COLUMN bip.tmp_fair.unite_oeuvre IS 'Unité d''oeuvre (J:Jours)';

COMMENT ON COLUMN bip.tmp_fair.montantht IS 'Montant Hors Taxes du consommé de la ressource pour le mois (= cout * consommé)';

COMMENT ON COLUMN bip.tmp_fair.tva IS 'TVA utilisée';

COMMENT ON COLUMN bip.tmp_fair.taux_recup IS 'Taux de récupération utilisé';

COMMENT ON COLUMN bip.tmp_fair.code_classe IS 'Code de la classe de montant ( = SENT )';

COMMENT ON COLUMN bip.tmp_fair.code_iso IS 'Code ISO de la devise ( = EUR )';

COMMENT ON COLUMN bip.tmp_fair.date_fin_contrat IS 'Date de fin du contrat';

COMMENT ON COLUMN bip.tmp_fair.rtype IS 'Type de la ressource (R = Personne , F = Forfait )';

COMMENT ON COLUMN bip.tmp_fair.pid IS 'Identifiant de la ligne BIP à facturer';

COMMENT ON COLUMN bip.tmp_fair.pnom IS 'Libellé de la ligne BIP à facturer';

COMMENT ON COLUMN bip.tmp_fair.societe IS 'Société de la ressource';

COMMENT ON COLUMN bip.tmp_fair.libsoc IS 'Libellé de la société de la ressource';


ALTER TABLE bip.tmp_immeuble DROP PRIMARY KEY CASCADE;
DROP TABLE bip.tmp_immeuble CASCADE CONSTRAINTS;

--
-- TMP_IMMEUBLE  (Table) 
--
CREATE TABLE bip.tmp_immeuble
(
  icodimm   VARCHAR(5),
  iadrabr   VARCHAR(25),
  flaglock  NUMBER(1)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_immeuble IS 'Table des immeubles temporaire.';

COMMENT ON COLUMN bip.tmp_immeuble.icodimm IS 'Code de l''immeuble';

COMMENT ON COLUMN bip.tmp_immeuble.iadrabr IS 'Adresse abregee de l''immeuble';

COMMENT ON COLUMN bip.tmp_immeuble.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.tmp_immo DROP PRIMARY KEY CASCADE;
DROP TABLE bip.tmp_immo CASCADE CONSTRAINTS;

--
-- TMP_IMMO  (Table) 
--
CREATE TABLE bip.tmp_immo
(
  cdeb        DATE                              NOT NULL,
  pid         VARCHAR2(4)                       NOT NULL,
  ident       NUMBER(5)                         NOT NULL,
  typproj     VARCHAR(2),
  metier      VARCHAR2(3),
  pnom        VARCHAR2(30),
  codsg       NUMBER(7),
  dpcode      NUMBER(5),
  icpi        VARCHAR(5),
  codcamo     NUMBER(6),
  clibrca     VARCHAR(16),
  cafi        NUMBER(6),
  codsgress   NUMBER(7),
  libdsg      VARCHAR2(30),
  rnom        VARCHAR2(30),
  rtype       VARCHAR(1),
  prestation  VARCHAR(3),
  niveau      VARCHAR2(2),
  soccode     VARCHAR(4),
  cada        NUMBER(6),
  coutftht    NUMBER(12,2),
  coutft      NUMBER(12,2),
  coutenv     NUMBER(12,2),
  consojh     NUMBER(12,2),
  consoft     NUMBER(12,2),
  consoenv    NUMBER(12,2)
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_immo IS 'Table temporaire pour le traitement mensuel IAS - stocke les lignes immobilisables';

COMMENT ON COLUMN bip.tmp_immo.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.tmp_immo.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.tmp_immo.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.tmp_immo.typproj IS 'Type projet de la ligne BIP : 1 (nv projet) , 2 (maintenance) , 3 (correctif) , 4 (Assistance) ...';

COMMENT ON COLUMN bip.tmp_immo.metier IS 'Code Métier : MO / ME / HOM ...';

COMMENT ON COLUMN bip.tmp_immo.pnom IS 'Nom de la ligne BIP';

COMMENT ON COLUMN bip.tmp_immo.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.tmp_immo.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.tmp_immo.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.tmp_immo.codcamo IS 'Code du centre d''activité du client payeur (maitrise d''ouvrage)';

COMMENT ON COLUMN bip.tmp_immo.clibrca IS 'Libellé du centre d''activité du client payeur';

COMMENT ON COLUMN bip.tmp_immo.cafi IS 'Centre d''activité du fournisseur pour la facturation interne';

COMMENT ON COLUMN bip.tmp_immo.codsgress IS 'Code département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.tmp_immo.libdsg IS 'Libellé du département/pôle/groupe de la ressource';

COMMENT ON COLUMN bip.tmp_immo.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.tmp_immo.rtype IS 'Type de la ressource';

COMMENT ON COLUMN bip.tmp_immo.prestation IS 'Code de la prestation (qualification)';

COMMENT ON COLUMN bip.tmp_immo.niveau IS 'Niveau de la ressource (si ressource SG)';

COMMENT ON COLUMN bip.tmp_immo.soccode IS 'Identifiant société';

COMMENT ON COLUMN bip.tmp_immo.cada IS 'Centre d''activité de dotation aux amortissements';

COMMENT ON COLUMN bip.tmp_immo.coutftht IS 'Coût force de travail hors taxes (si ressource SSII)';

COMMENT ON COLUMN bip.tmp_immo.coutft IS 'Coût force de travail (en hors taxes récupérable)';

COMMENT ON COLUMN bip.tmp_immo.coutenv IS 'Coût d''environnement (en hors taxes récupérable)';

COMMENT ON COLUMN bip.tmp_immo.consojh IS 'Consommé du mois en jours hommes';

COMMENT ON COLUMN bip.tmp_immo.consoft IS 'Consommé force de travail du mois en euros hors taxes récupérable';

COMMENT ON COLUMN bip.tmp_immo.consoenv IS 'Consommé charge d''environnement du mois en euros hors taxes récupérable';


DROP TABLE bip.tmp_imp_niveau CASCADE CONSTRAINTS;

--
-- TMP_IMP_NIVEAU  (Table) 
--
CREATE TABLE bip.tmp_imp_niveau
(
  matricule  VARCHAR2(7),
  nom        VARCHAR2(30),
  prenom     VARCHAR2(20),
  niveau     VARCHAR2(6),
  date_maj   VARCHAR2(8)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_imp_niveau IS 'Table de chargement des niveaux des ressources SG. Chargée par Sql Loader';

COMMENT ON COLUMN bip.tmp_imp_niveau.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.tmp_imp_niveau.nom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.tmp_imp_niveau.prenom IS 'Prenom de la ressource';

COMMENT ON COLUMN bip.tmp_imp_niveau.niveau IS 'Niveau de la ressource';

COMMENT ON COLUMN bip.tmp_imp_niveau.date_maj IS 'Date de maj du nouveau niveau';


DROP TABLE bip.tmp_imp_niveau_err CASCADE CONSTRAINTS;

--
-- TMP_IMP_NIVEAU_ERR  (Table) 
--
CREATE TABLE bip.tmp_imp_niveau_err
(
  matricule  VARCHAR2(7),
  ident      NUMBER(7),
  codsg      NUMBER(7),
  nom        VARCHAR2(30),
  prenom     VARCHAR2(20),
  niveau     VARCHAR2(6),
  date_maj   VARCHAR2(8),
  type_err   VARCHAR2(50)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_imp_niveau_err IS 'Table des erreurs intervenues lors du chargement des niveaux des ressources SG';

COMMENT ON COLUMN bip.tmp_imp_niveau_err.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.tmp_imp_niveau_err.ident IS 'Identifiant de la ressource';

COMMENT ON COLUMN bip.tmp_imp_niveau_err.codsg IS 'Code Département/Pôle/Groupe';

COMMENT ON COLUMN bip.tmp_imp_niveau_err.nom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.tmp_imp_niveau_err.prenom IS 'Prenom de la ressource';

COMMENT ON COLUMN bip.tmp_imp_niveau_err.niveau IS 'Niveau de la ressource';

COMMENT ON COLUMN bip.tmp_imp_niveau_err.date_maj IS 'Date de maj du nouveau niveau';

COMMENT ON COLUMN bip.tmp_imp_niveau_err.type_err IS 'Erreur concernant la maj du niveau';


DROP TABLE bip.tmp_ligne_cont CASCADE CONSTRAINTS;

--
-- TMP_LIGNE_CONT  (Table) 
--
CREATE TABLE bip.tmp_ligne_cont
(
  id_oalia    VARCHAR2(15),
  ident       NUMBER(5),
  numcont     VARCHAR2(15),
  cav         VARCHAR(2),
  soccont     VARCHAR2(4),
  coutht      NUMBER(12,2),
  datdeb      DATE,
  datfin      DATE,
  proporig    NUMBER(10,2),
  qualif      VARCHAR(3),
  retour      VARCHAR2(50),
  date_trait  DATE
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_ligne_cont IS 'Table utilisée pour le chargement des lignes de contrats venant de OALIA - RESAO';

COMMENT ON COLUMN bip.tmp_ligne_cont.id_oalia IS 'Identifiant enregistrement interne OALIA';

COMMENT ON COLUMN bip.tmp_ligne_cont.ident IS 'Identifiant BIP de la ressource généré par la BIP';

COMMENT ON COLUMN bip.tmp_ligne_cont.numcont IS 'N° de contrat';

COMMENT ON COLUMN bip.tmp_ligne_cont.cav IS 'Numéro d''avenant';

COMMENT ON COLUMN bip.tmp_ligne_cont.soccont IS 'Code société du contrat';

COMMENT ON COLUMN bip.tmp_ligne_cont.coutht IS 'Cout HT de la ressource';

COMMENT ON COLUMN bip.tmp_ligne_cont.datdeb IS 'Date de début';

COMMENT ON COLUMN bip.tmp_ligne_cont.datfin IS 'Date de fin';

COMMENT ON COLUMN bip.tmp_ligne_cont.proporig IS 'Proposé d''origine';

COMMENT ON COLUMN bip.tmp_ligne_cont.qualif IS 'Qualification';

COMMENT ON COLUMN bip.tmp_ligne_cont.retour IS 'Commentaire sur insertion de la ligne contrat';

COMMENT ON COLUMN bip.tmp_ligne_cont.date_trait IS 'Date à laquelle le traitement a tourné';


DROP TABLE bip.tmp_oscar CASCADE CONSTRAINTS;

--
-- TMP_OSCAR  (Table) 
--
CREATE TABLE bip.tmp_oscar
(
  pid          VARCHAR2(4)                      NOT NULL,
  datdebex     DATE,
  pnom         VARCHAR2(30)                     NOT NULL,
  typproj      VARCHAR(2)                          NOT NULL,
  dpcode       NUMBER(5),
  bpmontme     NUMBER(12,2),
  bpmontme1    NUMBER(12,2),
  bpmontme2    NUMBER(12,2),
  bpmontme3    NUMBER(12,2),
  bnmont       NUMBER(12,2),
  reserve      NUMBER(12,2),
  anmont       NUMBER(12,2),
  xcusmois     NUMBER(12,2),
  cusag        NUMBER(12,2),
  xcusag       NUMBER(12,2),
  reestime     NUMBER(12,2),
  sigdeppole   VARCHAR(7),
  clisigle     VARCHAR(8)                          NOT NULL,
  codcamo      NUMBER(6)                        NOT NULL,
  codpspe      VARCHAR(1),
  icpi         VARCHAR(5)                          NOT NULL,
  factint      NUMBER(12,2),
  airt         VARCHAR(5)                          NOT NULL,
  arctype      VARCHAR2(3)                      NOT NULL,
  rnom         VARCHAR2(30)                     NOT NULL,
  pnmouvra     VARCHAR(15),
  metier       VARCHAR(3),
  topfer       VARCHAR(1),
  cle_bip      VARCHAR2(3),
  astatut      VARCHAR(1),
  adatestatut  DATE,
  bpmontmo     NUMBER(12,2),
  bpmontmo1    NUMBER(12,2),
  ilibel       VARCHAR2(50),
  alibel       VARCHAR2(50),
  dplib        VARCHAR2(35)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          20m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_oscar IS 'Table utilisée dans le cadre de l''interface vers l''application OSCAR (ainsi que PMA et Metrique)';

COMMENT ON COLUMN bip.tmp_oscar.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.tmp_oscar.datdebex IS 'Date de début d''exercice (de début d''année)';

COMMENT ON COLUMN bip.tmp_oscar.pnom IS 'Libelle du projet (de la ligne BIP)';

COMMENT ON COLUMN bip.tmp_oscar.typproj IS 'Type de projet : 1 2 3 4 5 6 7 8 9';

COMMENT ON COLUMN bip.tmp_oscar.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.tmp_oscar.bpmontme IS 'Budget proposé fournisseur';

COMMENT ON COLUMN bip.tmp_oscar.bpmontme1 IS 'Budget proposé fournisseur (année + 1 )';

COMMENT ON COLUMN bip.tmp_oscar.bpmontme2 IS 'Budget proposé fournisseur (année + 2 )';

COMMENT ON COLUMN bip.tmp_oscar.bpmontme3 IS 'Budget proposé fournisseur (année + 3 )';

COMMENT ON COLUMN bip.tmp_oscar.bnmont IS 'Budget notifié';

COMMENT ON COLUMN bip.tmp_oscar.reserve IS 'Budget réservé (plus utilisé)';

COMMENT ON COLUMN bip.tmp_oscar.anmont IS 'Budget arbitré';

COMMENT ON COLUMN bip.tmp_oscar.xcusmois IS 'Consommé du mois (incluant les sous-traitances)';

COMMENT ON COLUMN bip.tmp_oscar.cusag IS 'Consommé du mois';

COMMENT ON COLUMN bip.tmp_oscar.xcusag IS 'Consommé depuis l''origine';

COMMENT ON COLUMN bip.tmp_oscar.reestime IS 'Budget réestimé';

COMMENT ON COLUMN bip.tmp_oscar.sigdeppole IS 'Sigle département/Sigle pôle';

COMMENT ON COLUMN bip.tmp_oscar.clisigle IS 'Sigle du client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.tmp_oscar.codcamo IS 'Code centre d''activite maîtrise d''ouvrage';

COMMENT ON COLUMN bip.tmp_oscar.codpspe IS 'Identifiant projet special';

COMMENT ON COLUMN bip.tmp_oscar.icpi IS 'Identifiant projet informatique';

COMMENT ON COLUMN bip.tmp_oscar.factint IS 'Montant en facturation interne du mois (Force de travail + Environnement)';

COMMENT ON COLUMN bip.tmp_oscar.airt IS 'Identifiant de l''application';

COMMENT ON COLUMN bip.tmp_oscar.arctype IS 'Identifiant de l''architecture, correspond au type de';

COMMENT ON COLUMN bip.tmp_oscar.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.tmp_oscar.pnmouvra IS 'Nom du client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.tmp_oscar.metier IS 'Métier de la ligne BIP';

COMMENT ON COLUMN bip.tmp_oscar.topfer IS 'Top fermeture de la ligne BIP';

COMMENT ON COLUMN bip.tmp_oscar.cle_bip IS 'Cle de controle';

COMMENT ON COLUMN bip.tmp_oscar.astatut IS 'Statut du projet';

COMMENT ON COLUMN bip.tmp_oscar.adatestatut IS 'Date de statut du projet';

COMMENT ON COLUMN bip.tmp_oscar.bpmontmo IS 'Budget proposé client';

COMMENT ON COLUMN bip.tmp_oscar.bpmontmo1 IS 'Budget proposé client (année + 1 )';

COMMENT ON COLUMN bip.tmp_oscar.ilibel IS 'Libellé du projet informatique';

COMMENT ON COLUMN bip.tmp_oscar.alibel IS 'Libellé de l''application';

COMMENT ON COLUMN bip.tmp_oscar.dplib IS 'Libellé du dossier projet';


ALTER TABLE bip.tmp_personne DROP PRIMARY KEY CASCADE;
DROP TABLE bip.tmp_personne CASCADE CONSTRAINTS;

--
-- TMP_PERSONNE  (Table) 
--
CREATE TABLE bip.tmp_personne
(
  matricule  VARCHAR(7),
  rnom       VARCHAR(30),
  rprenom    VARCHAR(15),
  iadrabr    VARCHAR(25),
  batiment   VARCHAR(1),
  etage      VARCHAR(2),
  bureau     VARCHAR(3),
  rtel       VARCHAR(6)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_personne IS 'Table de chargement des ressources (personnes) issues de l''annuaire. Chargée par Sql Loader';

COMMENT ON COLUMN bip.tmp_personne.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.tmp_personne.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.tmp_personne.rprenom IS 'Prenom de la ressource';

COMMENT ON COLUMN bip.tmp_personne.iadrabr IS 'Adresse de l''immeuble';

COMMENT ON COLUMN bip.tmp_personne.batiment IS 'Numero du batiment (zone)';

COMMENT ON COLUMN bip.tmp_personne.etage IS 'Numero de l''etage';

COMMENT ON COLUMN bip.tmp_personne.bureau IS 'Numero du bureau';

COMMENT ON COLUMN bip.tmp_personne.rtel IS 'Numero de telephone';


DROP TABLE bip.tmp_ree_detail CASCADE CONSTRAINTS;

--
-- TMP_REE_DETAIL  (Table) 
--
CREATE TABLE bip.tmp_ree_detail
(
  numseq         NUMBER                         NOT NULL,
  codsg          NUMBER(7)                      NOT NULL,
  libdsg         VARCHAR2(40),
  code_scenario  VARCHAR2(12)                   NOT NULL,
  lib_scenario   VARCHAR2(60),
  moismens       DATE,
  ident          NUMBER(5),
  nom            VARCHAR2(30),
  prenom         VARCHAR2(15),
  datdep         DATE,
  typer          VARCHAR2(1),
  code_activite  VARCHAR2(12),
  lib_activite   VARCHAR2(60),
  typea          VARCHAR2(1),
  cjan           NUMBER(3,1),
  cfev           NUMBER(3,1),
  cmar           NUMBER(3,1),
  cavr           NUMBER(3,1),
  cmai           NUMBER(3,1),
  cjun           NUMBER(3,1),
  cjul           NUMBER(3,1),
  caou           NUMBER(3,1),
  csep           NUMBER(3,1),
  coct           NUMBER(3,1),
  cnov           NUMBER(3,1),
  cdec           NUMBER(3,1),
  jan            NUMBER(10,2),
  fev            NUMBER(10,2),
  mar            NUMBER(10,2),
  avr            NUMBER(10,2),
  mai            NUMBER(10,2),
  jun            NUMBER(10,2),
  jul            NUMBER(10,2),
  aou            NUMBER(10,2),
  sep            NUMBER(10,2),
  oct            NUMBER(10,2),
  nov            NUMBER(10,2),
  DEC            NUMBER(10,2),
  t_realiser     NUMBER(10,2),
  t_reestimer    NUMBER(10,2)
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_ree_detail IS 'Table temporaire utilisée dans l''état de détail de l''outil de réestimé jour hommes';

COMMENT ON COLUMN bip.tmp_ree_detail.numseq IS 'Numéro de séquence';

COMMENT ON COLUMN bip.tmp_ree_detail.codsg IS 'Code du DPG';

COMMENT ON COLUMN bip.tmp_ree_detail.libdsg IS 'Libellé du DPG';

COMMENT ON COLUMN bip.tmp_ree_detail.code_scenario IS 'Code (libelle court) du scenario';

COMMENT ON COLUMN bip.tmp_ree_detail.lib_scenario IS 'Libellé du scenario';

COMMENT ON COLUMN bip.tmp_ree_detail.moismens IS 'Mois de la mensuelle';

COMMENT ON COLUMN bip.tmp_ree_detail.ident IS 'Identifiant de la ressource';

COMMENT ON COLUMN bip.tmp_ree_detail.nom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.tmp_ree_detail.prenom IS 'Prenom de la ressource';

COMMENT ON COLUMN bip.tmp_ree_detail.datdep IS 'Date de depart';

COMMENT ON COLUMN bip.tmp_ree_detail.typer IS 'Type de ressource : P : Personne, F : Forfait, X : Fictif, S : Sous-traitance recue';

COMMENT ON COLUMN bip.tmp_ree_detail.code_activite IS 'Code (libelle court) de l''activite';

COMMENT ON COLUMN bip.tmp_ree_detail.lib_activite IS 'Libellé de l''activite';

COMMENT ON COLUMN bip.tmp_ree_detail.typea IS 'Type de l''activite (A : Absence, F : ss-traitance fournie, N : Normal)';

COMMENT ON COLUMN bip.tmp_ree_detail.cjan IS 'Nombre de jours ouvrés du mois de Janvier';

COMMENT ON COLUMN bip.tmp_ree_detail.cfev IS 'Nombre de jours ouvrés du mois de Février';

COMMENT ON COLUMN bip.tmp_ree_detail.cmar IS 'Nombre de jours ouvrés du mois de Mars';

COMMENT ON COLUMN bip.tmp_ree_detail.cavr IS 'Nombre de jours ouvrés du mois d''Avril';

COMMENT ON COLUMN bip.tmp_ree_detail.cmai IS 'Nombre de jours ouvrés du mois de Mai';

COMMENT ON COLUMN bip.tmp_ree_detail.cjun IS 'Nombre de jours ouvrés du mois de Juin';

COMMENT ON COLUMN bip.tmp_ree_detail.cjul IS 'Nombre de jours ouvrés du mois de Juillet';

COMMENT ON COLUMN bip.tmp_ree_detail.caou IS 'Nombre de jours ouvrés du mois d''Aout';

COMMENT ON COLUMN bip.tmp_ree_detail.csep IS 'Nombre de jours ouvrés du mois de Septembre';

COMMENT ON COLUMN bip.tmp_ree_detail.coct IS 'Nombre de jours ouvrés du mois de Octobre';

COMMENT ON COLUMN bip.tmp_ree_detail.cnov IS 'Nombre de jours ouvrés du mois de Novembre';

COMMENT ON COLUMN bip.tmp_ree_detail.cdec IS 'Nombre de jours ouvrés du mois de Décembre';

COMMENT ON COLUMN bip.tmp_ree_detail.jan IS 'Nombre de jours consommés ou réestimés du mois de Janvier';

COMMENT ON COLUMN bip.tmp_ree_detail.fev IS 'Nombre de jours consommés ou réestimés du mois de Février';

COMMENT ON COLUMN bip.tmp_ree_detail.mar IS 'Nombre de jours consommés ou réestimés du mois de Mars';

COMMENT ON COLUMN bip.tmp_ree_detail.avr IS 'Nombre de jours consommés ou réestimés du mois d''Avril';

COMMENT ON COLUMN bip.tmp_ree_detail.mai IS 'Nombre de jours consommés ou réestimés du mois de Mai';

COMMENT ON COLUMN bip.tmp_ree_detail.jun IS 'Nombre de jours consommés ou réestimés du mois de Juin';

COMMENT ON COLUMN bip.tmp_ree_detail.jul IS 'Nombre de jours consommés ou réestimés du mois de Juillet';

COMMENT ON COLUMN bip.tmp_ree_detail.aou IS 'Nombre de jours consommés ou réestimés du mois d''Aout';

COMMENT ON COLUMN bip.tmp_ree_detail.sep IS 'Nombre de jours consommés ou réestimés du mois de Septembre';

COMMENT ON COLUMN bip.tmp_ree_detail.oct IS 'Nombre de jours consommés ou réestimés du mois de Octobre';

COMMENT ON COLUMN bip.tmp_ree_detail.nov IS 'Nombre de jours consommés ou réestimés du mois de Novembre';

COMMENT ON COLUMN bip.tmp_ree_detail.DEC IS 'Nombre de jours consommés ou réestimés du mois de Décembre';

COMMENT ON COLUMN bip.tmp_ree_detail.t_realiser IS 'Total du consommé';

COMMENT ON COLUMN bip.tmp_ree_detail.t_reestimer IS 'Total du réestimé';


DROP TABLE bip.tmp_rejetmens CASCADE CONSTRAINTS;

--
-- TMP_REJETMENS  (Table) 
--
CREATE TABLE bip.tmp_rejetmens
(
  pid          VARCHAR2(4),
  codsg        NUMBER(7),
  ecet         VARCHAR(2),
  acta         VARCHAR(2),
  acst         VARCHAR(2),
  ident        NUMBER(5),
  cdeb         DATE,
  cusag        NUMBER(7,2),
  motif_rejet  VARCHAR(1)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_rejetmens IS 'Table qui recueille tous les rejets détectés par les traitements mensuels';

COMMENT ON COLUMN bip.tmp_rejetmens.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.tmp_rejetmens.codsg IS 'Code département/pôle/groupe de la ligne BIP';

COMMENT ON COLUMN bip.tmp_rejetmens.ecet IS 'Numéro de l''étape';

COMMENT ON COLUMN bip.tmp_rejetmens.acta IS 'Numéro de la tâche';

COMMENT ON COLUMN bip.tmp_rejetmens.acst IS 'Numéro de la sous tâche';

COMMENT ON COLUMN bip.tmp_rejetmens.ident IS 'Identifiant ressource';

COMMENT ON COLUMN bip.tmp_rejetmens.cdeb IS 'Mois année de référence';

COMMENT ON COLUMN bip.tmp_rejetmens.cusag IS 'Consommé du mois';

COMMENT ON COLUMN bip.tmp_rejetmens.motif_rejet IS 'Motif du rejet : A: Date future , L : Ligne BIP inconnue , R: Ressource inconnue ...';


DROP TABLE bip.tmp_ressource CASCADE CONSTRAINTS;

--
-- TMP_RESSOURCE  (Table) 
--
CREATE TABLE bip.tmp_ressource
(
  id_oalia     VARCHAR2(15),
  matricule    VARCHAR2(7),
  rnom         VARCHAR2(30),
  rprenom      VARCHAR2(15),
  ident        NUMBER(5),
  code_retour  VARCHAR(1),
  retour       VARCHAR2(50)
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_ressource IS 'Table utilisée pour le chargement des ressources venant de OALIA - RESAO';

COMMENT ON COLUMN bip.tmp_ressource.id_oalia IS 'Identifiant enregistrement interne OALIA';

COMMENT ON COLUMN bip.tmp_ressource.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.tmp_ressource.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.tmp_ressource.rprenom IS 'Prénom de la ressource';

COMMENT ON COLUMN bip.tmp_ressource.ident IS 'Identifiant BIP de la ressource généré par la BIP';

COMMENT ON COLUMN bip.tmp_ressource.code_retour IS 'Code retour de création de la ressource';

COMMENT ON COLUMN bip.tmp_ressource.retour IS 'Commentaire sur insertion de la ressource';


DROP TABLE bip.tmp_rtfe CASCADE CONSTRAINTS;

--
-- TMP_RTFE  (Table) 
--
CREATE TABLE bip.tmp_rtfe
(
  sgzoneid          VARCHAR2(60),
  cn                VARCHAR2(45),
  sgcustomid1       VARCHAR2(15),
  sn                VARCHAR2(30),
  givenname         VARCHAR2(30),
  sglegalstatus     VARCHAR2(3),
  sgrtfeid          VARCHAR2(60),
  ID                VARCHAR2(50),
  sggroupid         VARCHAR2(100),
  c                 VARCHAR2(20),
  l                 VARCHAR2(100),
  mail              VARCHAR2(100),
  sgmailtype        VARCHAR2(20),
  telephonenumber   VARCHAR2(30),
  sgcompany         VARCHAR2(50),
  sgservicecode     VARCHAR2(30),
  sgservicename     VARCHAR2(30),
  sgjob             VARCHAR2(30),
  sgstructure       VARCHAR2(30),
  buildingname      VARCHAR2(30),
  roomnumber        VARCHAR2(15),
  postaladress      VARCHAR2(20),
  postalcode        VARCHAR2(20),
  fax               VARCHAR2(20),
  sgactivity        VARCHAR2(20),
  sgactivitycenter  VARCHAR2(15),
  sgutiroleatt1     VARCHAR2(4000),
  sgutiroleatt2     VARCHAR2(4000),
  sgutiroleatt3     VARCHAR2(4000),
  sgutiroleatt4     VARCHAR2(4000),
  sgutiroleatt5     VARCHAR2(4000),
  sgutiroleatt6     VARCHAR2(4000),
  sgutiroleatt7     VARCHAR2(4000)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_rtfe IS 'Table contienant les données chargées à partir du fichier émis par le RTFE.';

COMMENT ON COLUMN bip.tmp_rtfe.sgzoneid IS 'Identifiant unique de zone';

COMMENT ON COLUMN bip.tmp_rtfe.cn IS 'Nom complet';

COMMENT ON COLUMN bip.tmp_rtfe.sgcustomid1 IS 'Matricule Gershwin';

COMMENT ON COLUMN bip.tmp_rtfe.sn IS 'Nom';

COMMENT ON COLUMN bip.tmp_rtfe.givenname IS 'Prénom';

COMMENT ON COLUMN bip.tmp_rtfe.sglegalstatus IS 'Etat Civil';

COMMENT ON COLUMN bip.tmp_rtfe.sgrtfeid IS 'Identifiant unique RTFE';

COMMENT ON COLUMN bip.tmp_rtfe.ID IS 'Identifiant de connexion utilisateur';

COMMENT ON COLUMN bip.tmp_rtfe.sggroupid IS 'Identifiant unique groupe';

COMMENT ON COLUMN bip.tmp_rtfe.c IS 'Pays';

COMMENT ON COLUMN bip.tmp_rtfe.l IS 'Ville';

COMMENT ON COLUMN bip.tmp_rtfe.mail IS 'Adresse de messagerie';

COMMENT ON COLUMN bip.tmp_rtfe.sgmailtype IS 'Type messagerie';

COMMENT ON COLUMN bip.tmp_rtfe.telephonenumber IS 'Téléphone';

COMMENT ON COLUMN bip.tmp_rtfe.sgcompany IS 'Société';

COMMENT ON COLUMN bip.tmp_rtfe.sgservicecode IS 'Code service administratif';

COMMENT ON COLUMN bip.tmp_rtfe.sgservicename IS 'Libellé service administratif';

COMMENT ON COLUMN bip.tmp_rtfe.sgjob IS 'Métier';

COMMENT ON COLUMN bip.tmp_rtfe.sgstructure IS 'Elément de structure';

COMMENT ON COLUMN bip.tmp_rtfe.buildingname IS 'Immeuble';

COMMENT ON COLUMN bip.tmp_rtfe.roomnumber IS 'Bureau';

COMMENT ON COLUMN bip.tmp_rtfe.postaladress IS 'Adresse';

COMMENT ON COLUMN bip.tmp_rtfe.postalcode IS 'Code Postal';

COMMENT ON COLUMN bip.tmp_rtfe.fax IS 'Fax';

COMMENT ON COLUMN bip.tmp_rtfe.sgactivity IS 'Code activité';

COMMENT ON COLUMN bip.tmp_rtfe.sgactivitycenter IS 'Centre d''activité';

COMMENT ON COLUMN bip.tmp_rtfe.sgutiroleatt1 IS 'Attribut d''habilitations numéro 1';

COMMENT ON COLUMN bip.tmp_rtfe.sgutiroleatt2 IS 'Attribut d''habilitations numéro 2';

COMMENT ON COLUMN bip.tmp_rtfe.sgutiroleatt3 IS 'Attribut d''habilitations numéro 3';

COMMENT ON COLUMN bip.tmp_rtfe.sgutiroleatt4 IS 'Attribut d''habilitations numéro 4';

COMMENT ON COLUMN bip.tmp_rtfe.sgutiroleatt5 IS 'Attribut d''habilitations numéro 5';

COMMENT ON COLUMN bip.tmp_rtfe.sgutiroleatt6 IS 'Attribut d''habilitations numéro 6';

COMMENT ON COLUMN bip.tmp_rtfe.sgutiroleatt7 IS 'Attribut d''habilitations numéro 7';


DROP TABLE bip.tmp_saisie_realisee CASCADE CONSTRAINTS;

--
-- TMP_SAISIE_REALISEE  (Table) 
--
CREATE TABLE bip.tmp_saisie_realisee
(
  numseq           NUMBER                       NOT NULL,
  chef_projet      NUMBER(5),
  matricule        VARCHAR(7),
  rnom             VARCHAR2(30),
  rprenom          VARCHAR2(15),
  user_qui_saisie  VARCHAR2(2000),
  nombre           NUMBER
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_saisie_realisee IS 'Table temporaire pour le traitement de controle RTFE des habilitations sur le rôle SAISIE_REALISE.';

COMMENT ON COLUMN bip.tmp_saisie_realisee.numseq IS 'Numéro séquentiel de l''édition';

COMMENT ON COLUMN bip.tmp_saisie_realisee.chef_projet IS 'Identifiant BIP du chef de projet)';

COMMENT ON COLUMN bip.tmp_saisie_realisee.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.tmp_saisie_realisee.rnom IS 'Nom de la ressource';

COMMENT ON COLUMN bip.tmp_saisie_realisee.rprenom IS 'Prenom de la ressource';

COMMENT ON COLUMN bip.tmp_saisie_realisee.user_qui_saisie IS 'Liste des ressources habilitées à saisir';

COMMENT ON COLUMN bip.tmp_saisie_realisee.nombre IS 'Nombre de ressources habilitées';


DROP TABLE bip.tmp_situation CASCADE CONSTRAINTS;

--
-- TMP_SITUATION  (Table) 
--
CREATE TABLE bip.tmp_situation
(
  id_oalia       VARCHAR2(15),
  matricule      VARCHAR2(7),
  datarr         DATE,
  datdep         DATE,
  dpg            NUMBER(7),
  soccode        VARCHAR2(4),
  coutht         NUMBER(13,2),
  qualif         VARCHAR2(3),
  code_prest     VARCHAR2(10),
  disponibilite  NUMBER(2,1)                    DEFAULT 5.0,
  cpident        NUMBER(5),
  code_retour    VARCHAR(1),
  retour         VARCHAR2(50)
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_situation IS 'Table utilisée pour le chargement des situations des ressources venant de OALIA - RESAO';

COMMENT ON COLUMN bip.tmp_situation.id_oalia IS 'Identifiant enregistrement interne OALIA';

COMMENT ON COLUMN bip.tmp_situation.matricule IS 'Matricule de la ressource';

COMMENT ON COLUMN bip.tmp_situation.datarr IS 'Date de début de la situation';

COMMENT ON COLUMN bip.tmp_situation.datdep IS 'Date de fin de la situation';

COMMENT ON COLUMN bip.tmp_situation.dpg IS 'Code Département/Pôle/Groupe';

COMMENT ON COLUMN bip.tmp_situation.soccode IS 'Code de la société';

COMMENT ON COLUMN bip.tmp_situation.coutht IS 'Cout HT de la ressource';

COMMENT ON COLUMN bip.tmp_situation.qualif IS 'Qualification';

COMMENT ON COLUMN bip.tmp_situation.code_prest IS 'Code prestation';

COMMENT ON COLUMN bip.tmp_situation.disponibilite IS 'Disponibilité (forcé à 5.0)';

COMMENT ON COLUMN bip.tmp_situation.cpident IS 'Identifiant du chef de projet de la ressource';

COMMENT ON COLUMN bip.tmp_situation.code_retour IS 'Code retour de création de la situation de la ressource';

COMMENT ON COLUMN bip.tmp_situation.retour IS 'Commentaire sur insertion de la situation de la ressource';


DROP TABLE bip.tmp_situ_ress CASCADE CONSTRAINTS;

--
-- TMP_SITU_RESS  (Table) 
--
CREATE TABLE bip.tmp_situ_ress
(
  datsitu     DATE                              NOT NULL,
  datdep      DATE,
  cpident     NUMBER(5),
  cout        NUMBER(12,2),
  dispo       NUMBER(2,1),
  marsg2      VARCHAR(22),
  rmcomp      NUMBER(1),
  prestation  VARCHAR(3),
  dprest      VARCHAR(3),
  ident       NUMBER(5)                         NOT NULL,
  soccode     VARCHAR(4),
  filcode     VARCHAR(3),
  codsg       NUMBER(7)                         NOT NULL,
  niveau      VARCHAR2(2)
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_situ_ress IS 'A SUPPRIMER';


DROP TABLE bip.tmp_synthcoutproj CASCADE CONSTRAINTS;

--
-- TMP_SYNTHCOUTPROJ  (Table) 
--
CREATE TABLE bip.tmp_synthcoutproj
(
  numseq       NUMBER                           NOT NULL,
  clicode      VARCHAR2(5),
  clisigle     VARCHAR2(8),
  typedp       VARCHAR2(2),
  codcamo      NUMBER(6),
  annee        NUMBER(4),
  dpcode       NUMBER(5),
  libdp        VARCHAR2(35),
  filcode      VARCHAR(3),
  notifie_mat  NUMBER(8,2),
  notifie_log  NUMBER(8,2),
  notifie_mob  NUMBER(8,2),
  realise_mat  NUMBER(8,2),
  realise_log  NUMBER(8,2),
  realise_mob  NUMBER(8,2),
  conso        NUMBER(12,2),
  budget       NUMBER(12,2)
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_synthcoutproj IS 'Table temporaire pour l''édition de synhese des couts projets (Menu Suivi par référentiel/Suivi financier comptable/Suivi en euros) ';

COMMENT ON COLUMN bip.tmp_synthcoutproj.numseq IS 'Numéro de séquence';

COMMENT ON COLUMN bip.tmp_synthcoutproj.clicode IS 'Code client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.tmp_synthcoutproj.clisigle IS 'Sigle client maîtrise d''ouvrage';

COMMENT ON COLUMN bip.tmp_synthcoutproj.typedp IS 'Type du dossier projet';

COMMENT ON COLUMN bip.tmp_synthcoutproj.codcamo IS 'Code centre d''activite maîtrise d''ouvrage';

COMMENT ON COLUMN bip.tmp_synthcoutproj.annee IS 'Année de l''exercice';

COMMENT ON COLUMN bip.tmp_synthcoutproj.dpcode IS 'Code dossier projet';

COMMENT ON COLUMN bip.tmp_synthcoutproj.libdp IS 'Libellé du dossier projet';

COMMENT ON COLUMN bip.tmp_synthcoutproj.filcode IS 'Code de la filiale';

COMMENT ON COLUMN bip.tmp_synthcoutproj.notifie_mat IS 'Notifié pour les investissements de matériels';

COMMENT ON COLUMN bip.tmp_synthcoutproj.notifie_log IS 'Notifié pour les investissements de logiciels';

COMMENT ON COLUMN bip.tmp_synthcoutproj.notifie_mob IS 'Notifié pour les investissements de mobilier';

COMMENT ON COLUMN bip.tmp_synthcoutproj.realise_mat IS 'Réalisé pour les investissements de matériels';

COMMENT ON COLUMN bip.tmp_synthcoutproj.realise_log IS 'Réalisé pour les investissements de logiciels';

COMMENT ON COLUMN bip.tmp_synthcoutproj.realise_mob IS 'Réalisé pour les investissements de mobilier';

COMMENT ON COLUMN bip.tmp_synthcoutproj.conso IS 'Somme du montant consommé (force de travail + environnement)';

COMMENT ON COLUMN bip.tmp_synthcoutproj.budget IS 'Budget du dossier projet';


DROP TABLE bip.tmp_visuprojprin CASCADE CONSTRAINTS;

--
-- TMP_VISUPROJPRIN  (Table) 
--
CREATE TABLE bip.tmp_visuprojprin
(
  numseq   NUMBER                               NOT NULL,
  typeb    VARCHAR(1)                              NOT NULL,
  pid      VARCHAR2(4)                          NOT NULL,
  fidec    VARCHAR2(15),
  fiannee  VARCHAR2(15),
  minus1   VARCHAR2(15),
  n        VARCHAR2(15),
  plus1    VARCHAR2(15),
  plus2    VARCHAR2(15),
  plus3    VARCHAR2(15),
  total    VARCHAR2(15),
  immo     VARCHAR2(15)
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          10m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tmp_visuprojprin IS 'Table temporaire pour l''édition du détail d''une ligne BIP ';

COMMENT ON COLUMN bip.tmp_visuprojprin.numseq IS 'Numéro de séquence';

COMMENT ON COLUMN bip.tmp_visuprojprin.typeb IS 'Type de budget (A=proposé fournisseur,B=proposé client,C=notifié,D=reservé(ne sert plus),E=arbitré,F=consommé année,G=consommé mois,H=réestimé,I=consommé depuis l''origine,J=montants immobilisés et en facturation interne)';

COMMENT ON COLUMN bip.tmp_visuprojprin.pid IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN bip.tmp_visuprojprin.immo IS 'Montant immobilisé pour l''année courante';

COMMENT ON COLUMN bip.tmp_visuprojprin.fidec IS 'Montant en facturation interne du mois de décembre';

COMMENT ON COLUMN bip.tmp_visuprojprin.fiannee IS 'Montant en facturation interne pour l''année courante';

COMMENT ON COLUMN bip.tmp_visuprojprin.minus1 IS 'Données budgétaires de l''année précédente';

COMMENT ON COLUMN bip.tmp_visuprojprin.n IS 'Données budgétaires de l''année courante';

COMMENT ON COLUMN bip.tmp_visuprojprin.plus1 IS 'Données budgétaires de l''année courante + 1 an';

COMMENT ON COLUMN bip.tmp_visuprojprin.plus2 IS 'Données budgétaires de l''année courante + 2 ans';

COMMENT ON COLUMN bip.tmp_visuprojprin.plus3 IS 'Données budgétaires de l''année courante + 3 ans';

COMMENT ON COLUMN bip.tmp_visuprojprin.total IS 'Total des données budgétaires';



DROP TABLE bip.trait_asynchrone CASCADE CONSTRAINTS;

--
-- TRAIT_ASYNCHRONE  (Table) 
--
CREATE TABLE bip.trait_asynchrone
(
  TYPE         VARCHAR(1)                          NOT NULL,
  userid       VARCHAR2(255)                    NOT NULL,
  titre        VARCHAR2(80)                     NOT NULL,
  nom_fichier  VARCHAR2(100)                    NOT NULL,
  statut       NUMBER                           NOT NULL,
  date_trait   DATE                             NOT NULL,
  reportid     VARCHAR2(50)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.trait_asynchrone IS 'Table de lancement des états en mode différé';

COMMENT ON COLUMN bip.trait_asynchrone.reportid IS 'Identifiant du report';

COMMENT ON COLUMN bip.trait_asynchrone.TYPE IS 'Type de l''état (E=Edition, X=Extraction)';

COMMENT ON COLUMN bip.trait_asynchrone.userid IS 'Identifiant de l''utilisateur';

COMMENT ON COLUMN bip.trait_asynchrone.titre IS 'Titre de l''état : libellé de l''état affiché par l''écran traitements différés';

COMMENT ON COLUMN bip.trait_asynchrone.nom_fichier IS 'Nom du fichier de données généré sur le serveur';

COMMENT ON COLUMN bip.trait_asynchrone.statut IS 'Statut du traitement (-1=Erreur, 0=En cours , 1=Terminé)';

COMMENT ON COLUMN bip.trait_asynchrone.date_trait IS 'Date/Heure du traitement';


ALTER TABLE bip.tva DROP PRIMARY KEY CASCADE;
DROP TABLE bip.tva CASCADE CONSTRAINTS;

--
-- TVA  (Table) 
--
CREATE TABLE bip.tva
(
  tva       NUMBER(9,2)                         NOT NULL,
  ctva      VARCHAR(2)                             NOT NULL,
  datetva   DATE,
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.tva IS 'Table des Taux de tva';

COMMENT ON COLUMN bip.tva.tva IS 'Taux de tva';

COMMENT ON COLUMN bip.tva.ctva IS 'Identifiant du taux de tva';

COMMENT ON COLUMN bip.tva.datetva IS 'Date changement de tva en mois annee';

COMMENT ON COLUMN bip.tva.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.type_activite DROP PRIMARY KEY CASCADE;
DROP TABLE bip.type_activite CASCADE CONSTRAINTS;

--
-- TYPE_ACTIVITE  (Table) 
--
CREATE TABLE bip.type_activite
(
  arctype   VARCHAR2(3)                         NOT NULL,
  libarc    VARCHAR2(30)                        NOT NULL,
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL,
  actif     VARCHAR2(1)                         DEFAULT 'O'                   NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.type_activite IS 'Table des types d''activite';

COMMENT ON COLUMN bip.type_activite.arctype IS 'Identifiant de l''architecture, correspond au type de';

COMMENT ON COLUMN bip.type_activite.libarc IS 'Libelle de l''architecture';

COMMENT ON COLUMN bip.type_activite.flaglock IS 'Flag pour la gestion de concurrence';

COMMENT ON COLUMN bip.type_activite.actif IS 'Flag indiquant si le type est en activité (O:Oui,N:Non)';


ALTER TABLE bip.type_amort DROP PRIMARY KEY CASCADE;
DROP TABLE bip.type_amort CASCADE CONSTRAINTS;

--
-- TYPE_AMORT  (Table) 
--
CREATE TABLE bip.type_amort
(
  ctopact   VARCHAR(1)                             NOT NULL,
  libamort  VARCHAR2(30)                        NOT NULL,
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.type_amort IS 'Table des Types d''amortissement.';

COMMENT ON COLUMN bip.type_amort.ctopact IS 'Type d''amortissement, correspond a un top fact interne:';

COMMENT ON COLUMN bip.type_amort.libamort IS 'Libellé du type d''amortissement';

COMMENT ON COLUMN bip.type_amort.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.type_domaine DROP PRIMARY KEY CASCADE;
DROP TABLE bip.type_domaine CASCADE CONSTRAINTS;

--
-- TYPE_DOMAINE  (Table) 
--
CREATE TABLE bip.type_domaine
(
  code_domaine  VARCHAR2(2)                     NOT NULL,
  lib_domaine   VARCHAR2(25)                    NOT NULL,
  flaglock      NUMBER(7)                       DEFAULT 0
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.type_domaine IS 'Table qui contient les differents types de domaines';

COMMENT ON COLUMN bip.type_domaine.code_domaine IS 'L''identifiant du type de domaine';

COMMENT ON COLUMN bip.type_domaine.lib_domaine IS 'Libellé du type de domaine';

COMMENT ON COLUMN bip.type_domaine.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.type_dossier_projet DROP PRIMARY KEY CASCADE;
DROP TABLE bip.type_dossier_projet CASCADE CONSTRAINTS;

--
-- TYPE_DOSSIER_PROJET  (Table) 
--
CREATE TABLE bip.type_dossier_projet
(
  typdp     VARCHAR2(2)                         NOT NULL,
  libtypdp  VARCHAR2(50),
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.type_dossier_projet IS 'Table des types de dossiers projets';

COMMENT ON COLUMN bip.type_dossier_projet.typdp IS 'Type de dossier projet';

COMMENT ON COLUMN bip.type_dossier_projet.libtypdp IS 'Libellé du type de dossier projet';

COMMENT ON COLUMN bip.type_dossier_projet.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.type_etape DROP PRIMARY KEY CASCADE;
DROP TABLE bip.type_etape CASCADE CONSTRAINTS;

--
-- TYPE_ETAPE  (Table) 
--
CREATE TABLE bip.type_etape
(
  typetap  VARCHAR(2)                              NOT NULL,
  libtyet  VARCHAR2(30)                         NOT NULL,
  rangetp  NUMBER(1)                            NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.type_etape IS 'Table des Types d''etape.';

COMMENT ON COLUMN bip.type_etape.typetap IS 'Type d''etape';

COMMENT ON COLUMN bip.type_etape.libtyet IS 'Libelle du type d''etape';

COMMENT ON COLUMN bip.type_etape.rangetp IS 'Rang du type d''etape au sens aurige';


ALTER TABLE bip.type_projet DROP PRIMARY KEY CASCADE;
DROP TABLE bip.type_projet CASCADE CONSTRAINTS;

--
-- TYPE_PROJET  (Table) 
--
CREATE TABLE bip.type_projet
(
  typproj   VARCHAR(2)                             NOT NULL,
  libtyp    VARCHAR2(30),
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.type_projet IS 'Table des Types de projet.';

COMMENT ON COLUMN bip.type_projet.typproj IS 'Type de projet : 1 2 3 4 5 6 7 8 9';

COMMENT ON COLUMN bip.type_projet.libtyp IS 'Libelle du type de projet';

COMMENT ON COLUMN bip.type_projet.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.type_ress DROP PRIMARY KEY CASCADE;
DROP TABLE bip.type_ress CASCADE CONSTRAINTS;

--
-- TYPE_RESS  (Table) 
--
CREATE TABLE bip.type_ress
(
  rtype     VARCHAR(1)                             NOT NULL,
  rlib      VARCHAR2(50),
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.type_ress IS 'Table des Types de ressource.';

COMMENT ON COLUMN bip.type_ress.rtype IS 'Type de ressource : p, f, l';

COMMENT ON COLUMN bip.type_ress.rlib IS 'Libellé du type de ressource';

COMMENT ON COLUMN bip.type_ress.flaglock IS 'Flag pour la gestion de concurrence';


ALTER TABLE bip.type_rubrique DROP PRIMARY KEY CASCADE;
DROP TABLE bip.type_rubrique CASCADE CONSTRAINTS;

--
-- TYPE_RUBRIQUE  (Table) 
--
CREATE TABLE bip.type_rubrique
(
  codep     NUMBER(5)                           NOT NULL,
  codfei    NUMBER(1)                           NOT NULL,
  librubst  VARCHAR2(50)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.type_rubrique IS 'Les rubriques standards';

COMMENT ON COLUMN bip.type_rubrique.codep IS 'Code élément de pilotage';

COMMENT ON COLUMN bip.type_rubrique.codfei IS 'Code CODFEI';

COMMENT ON COLUMN bip.type_rubrique.librubst IS 'Libellé de la rubrique standard';


ALTER TABLE bip.version_tp DROP PRIMARY KEY CASCADE;
DROP TABLE bip.version_tp CASCADE CONSTRAINTS;

--
-- VERSION_TP  (Table) 
--
CREATE TABLE bip.version_tp
(
  numtp     VARCHAR(2)                             NOT NULL,
  dattp     DATE,
  lpmw      VARCHAR(1)                             NOT NULL,
  libtp     VARCHAR2(50),
  vpmw      VARCHAR(5),
  flaglock  NUMBER(7)                           DEFAULT 0                     NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCACHE
NOPARALLEL;

COMMENT ON TABLE bip.version_tp IS 'Table des versions de turbo pascal.';

COMMENT ON COLUMN bip.version_tp.numtp IS 'Numero de la version tp';

COMMENT ON COLUMN bip.version_tp.dattp IS 'Date de mise en service';

COMMENT ON COLUMN bip.version_tp.lpmw IS 'Lettre de la version pmw';

COMMENT ON COLUMN bip.version_tp.libtp IS 'Libelle de la nouvelle version de TP';

COMMENT ON COLUMN bip.version_tp.vpmw IS 'Numero de la version pmw';

COMMENT ON COLUMN bip.version_tp.flaglock IS 'Flag pour la gestion de concurrence';




ALTER TABLE BIP.BUDGET_ECART DROP PRIMARY KEY CASCADE;
DROP TABLE BIP.BUDGET_ECART CASCADE CONSTRAINTS;

--
-- BUDGET_ECART  (Table) 
--
CREATE TABLE BIP.BUDGET_ECART
(
  CODSG        NUMBER(7)                        NOT NULL,
  PID          VARCHAR2(4)                      NOT NULL,
  PNOM         VARCHAR2(30)                     NOT NULL,
  REESTIME     NUMBER(12,2),
  ANMONT       NUMBER(12,2),
  BPMONTME     NUMBER(12,2),
  BNMONT       NUMBER(12,2),
  CUSAG        NUMBER(12,2),
  ANNEE        NUMBER(4)                        NOT NULL,
  TYPE         VARCHAR2(15)                     NOT NULL,
  VALIDE       VARCHAR(1)                          NOT NULL,
  COMMENTAIRE  VARCHAR2(255)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON COLUMN BIP.BUDGET_ECART.CODSG IS 'Code Département Pole Groupe';

COMMENT ON COLUMN BIP.BUDGET_ECART.PID IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN BIP.BUDGET_ECART.PNOM IS 'Libellé du projet';

COMMENT ON COLUMN BIP.BUDGET_ECART.REESTIME IS 'Budget réestimé';

COMMENT ON COLUMN BIP.BUDGET_ECART.ANMONT IS 'Budget arbitré notifié';

COMMENT ON COLUMN BIP.BUDGET_ECART.BPMONTME IS 'Budget proposé ME';

COMMENT ON COLUMN BIP.BUDGET_ECART.BNMONT IS 'Budget notifié';

COMMENT ON COLUMN BIP.BUDGET_ECART.CUSAG IS 'Consommé total de l année';

COMMENT ON COLUMN BIP.BUDGET_ECART.ANNEE IS 'Année du budget';

COMMENT ON COLUMN BIP.BUDGET_ECART.TYPE IS 'Type de l écart (REE>ARB & CONS-BUD)';

COMMENT ON COLUMN BIP.BUDGET_ECART.VALIDE IS 'Top de validation (O/N)';

COMMENT ON COLUMN BIP.BUDGET_ECART.COMMENTAIRE IS 'Commentaire de la validation de l écart';


ALTER TABLE BIP.BUDGET_ECART_1 DROP PRIMARY KEY CASCADE;
DROP TABLE BIP.BUDGET_ECART_1 CASCADE CONSTRAINTS;

--
-- BUDGET_ECART_1  (Table) 
--
CREATE TABLE BIP.BUDGET_ECART_1
(
  CODSG        NUMBER(7)                        NOT NULL,
  PID          VARCHAR2(4)                      NOT NULL,
  PNOM         VARCHAR2(30)                     NOT NULL,
  REESTIME     NUMBER(12,2),
  ANMONT       NUMBER(12,2),
  BPMONTME     NUMBER(12,2),
  BNMONT       NUMBER(12,2),
  CUSAG        NUMBER(12,2),
  ANNEE        NUMBER(4)                        NOT NULL,
  TYPE         VARCHAR2(15)                     NOT NULL,
  VALIDE       VARCHAR(1)                          NOT NULL,
  COMMENTAIRE  VARCHAR2(255)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON COLUMN BIP.BUDGET_ECART_1.CODSG IS 'Code Département Pole Groupe';

COMMENT ON COLUMN BIP.BUDGET_ECART_1.PID IS 'Identifiant de la ligne BIP';

COMMENT ON COLUMN BIP.BUDGET_ECART_1.PNOM IS 'Libellé du projet';

COMMENT ON COLUMN BIP.BUDGET_ECART_1.REESTIME IS 'Budget réestimé';

COMMENT ON COLUMN BIP.BUDGET_ECART_1.ANMONT IS 'Budget arbitré notifié';

COMMENT ON COLUMN BIP.BUDGET_ECART_1.BPMONTME IS 'Budget proposé ME';

COMMENT ON COLUMN BIP.BUDGET_ECART_1.BNMONT IS 'Budget notifié';

COMMENT ON COLUMN BIP.BUDGET_ECART_1.CUSAG IS 'Consommé total de l année';

COMMENT ON COLUMN BIP.BUDGET_ECART_1.ANNEE IS 'Année du budget';

COMMENT ON COLUMN BIP.BUDGET_ECART_1.TYPE IS 'Type de l écart (REE>ARB & CONS-BUD)';

COMMENT ON COLUMN BIP.BUDGET_ECART_1.VALIDE IS 'Top de validation (O/N)';

COMMENT ON COLUMN BIP.BUDGET_ECART_1.COMMENTAIRE IS 'Commentaire de la validation de l écart';


ALTER TABLE BIP.DEMANDE_VAL_FACTU DROP PRIMARY KEY CASCADE;
DROP TABLE BIP.DEMANDE_VAL_FACTU CASCADE CONSTRAINTS;

--
-- DEMANDE_VAL_FACTU  (Table) 
--
CREATE TABLE BIP.DEMANDE_VAL_FACTU
(
  IDDEM         NUMBER(7)                       NOT NULL,
  DATDEM        DATE                            NOT NULL,
  USERDEM       VARCHAR2(60)                    NOT NULL,
  SOCFACT       VARCHAR(4)                         NOT NULL,
  NUMFACT       VARCHAR(15)                        NOT NULL,
  TYPFACT       VARCHAR(1)                         NOT NULL,
  DATFACT       DATE                            NOT NULL,
  LNUM          NUMBER(2)                       NOT NULL,
  ECART         NUMBER(9,2)                     NOT NULL,
  STATUT        VARCHAR(1)                         NOT NULL,
  DATSTAT       DATE,
  CAUSESUSPENS  VARCHAR2(250),
  FACCSEC       DATE,
  FREGCOMPTA    DATE,
  FSTATUT2      VARCHAR(2),
  CODCFRAIS     NUMBER(3),
  IDENT_GDM     NUMBER(5)                       NOT NULL,
  IDENT         NUMBER(5)                       NOT NULL,
  LMOISPREST    DATE                            NOT NULL,
  CONSOMMEHT    NUMBER(12,2),
  CUSAG         NUMBER(7,2)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.IDDEM IS 'N° de la demande';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.DATDEM IS 'Date de la demande';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.USERDEM IS 'User arpege du demandeur';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.SOCFACT IS 'Identifiant de la société';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.NUMFACT IS 'Numéro de la facture';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.TYPFACT IS 'Type de la facture';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.DATFACT IS 'Date de la facture';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.LNUM IS 'Numéro de la ligne de facture';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.ECART IS 'Ecart du rapprochement';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.STATUT IS 'Statut de la demande, null : en attente, A : acceptée, R : refusée';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.DATSTAT IS 'Date du statut';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.CAUSESUSPENS IS 'Cause de la mise en suspens';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.FACCSEC IS 'Date accord du pôle';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.FREGCOMPTA IS 'Date envoi réglement comptable';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.FSTATUT2 IS 'Statut CS2';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.CODCFRAIS IS 'Centre de frais';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.IDENT_GDM IS 'Identifiant du GDM';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.IDENT IS 'Identifiant de la ressource';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.LMOISPREST IS 'Mois de la prestation';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.CONSOMMEHT IS 'Consomme du mois de la ressource en euros hors taxes';

COMMENT ON COLUMN BIP.DEMANDE_VAL_FACTU.CUSAG IS 'Consomme du mois de la ressource en jours hommes';




ALTER TABLE BIP.MESSAGE_FORUM DROP PRIMARY KEY CASCADE;
DROP TABLE BIP.MESSAGE_FORUM CASCADE CONSTRAINTS;

--
-- MESSAGE_FORUM  (Table) 
--
CREATE TABLE BIP.MESSAGE_FORUM
(
  ID                 NUMBER(6)                  NOT NULL,
  PARENT_ID          NUMBER(6)                  NOT NULL,
  USER_RTFE          VARCHAR2(60)               NOT NULL,
  MENU               VARCHAR2(10)               NOT NULL,
  DATE_MSG           DATE                       NOT NULL,
  TITRE              VARCHAR2(200)              NOT NULL,
  TYPE_MSG           VARCHAR(1)                    NOT NULL,
  STATUT             VARCHAR(1)                    NOT NULL,
  DATE_STATUT        DATE                       NOT NULL,
  TEXTE              VARCHAR2(2000),
  TEXTE_MODIFIE      VARCHAR2(2000),
  MOTIF_REJET        VARCHAR2(500),
  DATE_AFFICHAGE     DATE,
  DATE_MODIFICATION  DATE,
  MSG_IMPORTANT      VARCHAR(1)                    DEFAULT NULL                  NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256K
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON COLUMN BIP.MESSAGE_FORUM.ID IS 'Identifiant du message';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.PARENT_ID IS 'Identifiant du parent du message';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.USER_RTFE IS 'Identifiant RTFE de l''utilisateur';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.MENU IS 'Menu dans lequel le message a été publié';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.DATE_MSG IS 'Date du message';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.TITRE IS 'Titre du message';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.TYPE_MSG IS 'Type du message (I: privé, U: public)';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.STATUT IS 'Statut du message (A: a valider, V: validé, F: fermé, M: modification à valider, R: rejeté)';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.DATE_STATUT IS 'Date du statut';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.TEXTE IS 'Texte du message';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.TEXTE_MODIFIE IS 'Texte modifié à valider du message';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.MOTIF_REJET IS 'Motif du rejet du message';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.DATE_AFFICHAGE IS 'Date de fin d''affichage';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.DATE_MODIFICATION IS 'Date de la dernière modification du message';

COMMENT ON COLUMN BIP.MESSAGE_FORUM.MSG_IMPORTANT IS 'Statut d''importance du message (O/N)';


ALTER TABLE BIP.MESSAGE_PERSONNEL DROP PRIMARY KEY CASCADE;
DROP TABLE BIP.MESSAGE_PERSONNEL CASCADE CONSTRAINTS;

--
-- MESSAGE_PERSONNEL  (Table) 
--
CREATE TABLE BIP.MESSAGE_PERSONNEL
(
  CODE_MP       NUMBER(6)                       NOT NULL,
  IDENT         NUMBER(5)                       NOT NULL,
  TITRE         VARCHAR2(50)                    NOT NULL,
  TEXTE         VARCHAR2(1000)                  NOT NULL,
  DATE_AFFICHE  DATE,
  DATE_DEBUT    DATE                            NOT NULL,
  DATE_FIN      DATE                            NOT NULL,
  VALIDE        VARCHAR(1)                         NOT NULL,
  TYPE_MP       VARCHAR2(30)                    NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512K
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON COLUMN BIP.MESSAGE_PERSONNEL.CODE_MP IS 'Numéro du message';

COMMENT ON COLUMN BIP.MESSAGE_PERSONNEL.IDENT IS 'Identifiant de l''utilisateur';

COMMENT ON COLUMN BIP.MESSAGE_PERSONNEL.TITRE IS 'Titre du message';

COMMENT ON COLUMN BIP.MESSAGE_PERSONNEL.TEXTE IS 'Texte descriptif du message';

COMMENT ON COLUMN BIP.MESSAGE_PERSONNEL.DATE_AFFICHE IS 'Date affichée devant le titre du message';

COMMENT ON COLUMN BIP.MESSAGE_PERSONNEL.DATE_DEBUT IS 'Date de début de validité d''affichage';

COMMENT ON COLUMN BIP.MESSAGE_PERSONNEL.DATE_FIN IS 'Date de fin de validité d''affichage';

COMMENT ON COLUMN BIP.MESSAGE_PERSONNEL.VALIDE IS 'Flag indiquant si le message doit être affiché ou pas';

COMMENT ON COLUMN BIP.MESSAGE_PERSONNEL.TYPE_MP IS 'Type du message, TEXTE : message affiché tel quel, MP_FACT_DEM_VAL : message demande de validation en attente, MP_FACT_DEM_ETA : message état des demandes de validation';



ALTER TABLE BIP.PARAMETRE_LIGNE_BIP DROP PRIMARY KEY CASCADE;
DROP TABLE BIP.PARAMETRE_LIGNE_BIP CASCADE CONSTRAINTS;

--
-- PARAMETRE_LIGNE_BIP  (Table) 
--
CREATE TABLE BIP.PARAMETRE_LIGNE_BIP
(
  USERID     VARCHAR2(60)                       NOT NULL,
  IDCPID     NUMBER(3)                          NOT NULL,
  AFFICHE    VARCHAR2(5)                        NOT NULL,
  CLIB_PID   VARCHAR2(50),
  NUM_ORDER  NUMBER(3)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON TABLE BIP.PARAMETRE_LIGNE_BIP IS 'Contient les champs des lignes bip pour les ressources';

COMMENT ON COLUMN BIP.PARAMETRE_LIGNE_BIP.USERID IS 'Identifiant de la ressource';

COMMENT ON COLUMN BIP.PARAMETRE_LIGNE_BIP.IDCPID IS 'Identifiant de la colonne';

COMMENT ON COLUMN BIP.PARAMETRE_LIGNE_BIP.AFFICHE IS 'Afficher ka colonne VRAI ou FAUX';

COMMENT ON COLUMN BIP.PARAMETRE_LIGNE_BIP.CLIB_PID IS 'Libellé personnalisé par l''utilisateur';

COMMENT ON COLUMN BIP.PARAMETRE_LIGNE_BIP.NUM_ORDER IS 'Numéro d''ordre de la colonne dans le nouveau tableau';



ALTER TABLE BIP.PARAM_TYPE_LIGNE_BIP DROP PRIMARY KEY CASCADE;
DROP TABLE BIP.PARAM_TYPE_LIGNE_BIP CASCADE CONSTRAINTS;

--
-- PARAM_TYPE_LIGNE_BIP  (Table) 
--
CREATE TABLE BIP.PARAM_TYPE_LIGNE_BIP
(
  USERID   VARCHAR2(60)                         NOT NULL,
  TYPPROJ  VARCHAR(2)                              NOT NULL
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON TABLE BIP.PARAM_TYPE_LIGNE_BIP IS 'Contient les types de ligne bip paramétré pour chaque reessource';

COMMENT ON COLUMN BIP.PARAM_TYPE_LIGNE_BIP.USERID IS 'Identifiant de la ressource';

COMMENT ON COLUMN BIP.PARAM_TYPE_LIGNE_BIP.TYPPROJ IS 'Type du projet';



ALTER TABLE BIP.RESSOURCE_LOGS DROP PRIMARY KEY CASCADE;
DROP TABLE BIP.RESSOURCE_LOGS CASCADE CONSTRAINTS;

--
-- RESSOURCE_LOGS  (Table) 
--
CREATE TABLE BIP.RESSOURCE_LOGS
(
  IDENT        NUMBER(5)                        NOT NULL,
  DATE_LOG     DATE                             NOT NULL,
  USER_LOG     VARCHAR2(30)                     NOT NULL,
  NOM_TABLE    VARCHAR2(30)                     NOT NULL,
  COLONNE      VARCHAR2(30)                     NOT NULL,
  VALEUR_PREC  VARCHAR2(30),
  VALEUR_NOUV  VARCHAR2(30),
  COMMENTAIRE  VARCHAR2(200)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON TABLE BIP.RESSOURCE_LOGS IS 'Trace les modifications intervenues dans certaines données des ressources';

COMMENT ON COLUMN BIP.RESSOURCE_LOGS.IDENT IS 'Identifiant de la ressource';

COMMENT ON COLUMN BIP.RESSOURCE_LOGS.DATE_LOG IS 'Date et heure de la modification';

COMMENT ON COLUMN BIP.RESSOURCE_LOGS.USER_LOG IS 'Identifiant de l''utilisateur ayant effectué la modification';

COMMENT ON COLUMN BIP.RESSOURCE_LOGS.NOM_TABLE IS 'Nom de la table ressource ou la table situ_ress qui a été modifiée';

COMMENT ON COLUMN BIP.RESSOURCE_LOGS.COLONNE IS 'Nom de la colonne a été modifiée';

COMMENT ON COLUMN BIP.RESSOURCE_LOGS.VALEUR_PREC IS 'Valeur de la donnée avant modification';

COMMENT ON COLUMN BIP.RESSOURCE_LOGS.VALEUR_NOUV IS 'Valeur de la donnée après modification';

COMMENT ON COLUMN BIP.RESSOURCE_LOGS.COMMENTAIRE IS 'Indique l''événement déclancheur : écran ayant servi à modifier les données';


ALTER TABLE BIP.RJH_ALIM_CONSO_LOG DROP PRIMARY KEY CASCADE;
DROP TABLE BIP.RJH_ALIM_CONSO_LOG CASCADE CONSTRAINTS;

--
-- RJH_ALIM_CONSO_LOG  (Table) 
--
CREATE TABLE BIP.RJH_ALIM_CONSO_LOG
(
  CODREP  VARCHAR2(12)                          NOT NULL,
  TEXTE   VARCHAR2(1024)                        NOT NULL
)
TABLESPACE tbs_bip_ias_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512K
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON COLUMN BIP.RJH_ALIM_CONSO_LOG.CODREP IS 'Code de la table de répartition';

COMMENT ON COLUMN BIP.RJH_ALIM_CONSO_LOG.TEXTE IS 'Texte de log';


ALTER TABLE BIP.RTFE_USER DROP PRIMARY KEY CASCADE;
DROP TABLE BIP.RTFE_USER CASCADE CONSTRAINTS;

--
-- RTFE_USER  (Table) 
--
CREATE TABLE BIP.RTFE_USER
(
  USER_RTFE  VARCHAR2(60),
  NOM        VARCHAR2(30),
  PRENOM     VARCHAR2(30),
  IDENT      NUMBER(5)
)
TABLESPACE tbs_bip_batch_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256K
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON TABLE BIP.RTFE_USER IS 'Table contenant les utilisateurs déclarés dans le RTFE.';

COMMENT ON COLUMN BIP.RTFE_USER.USER_RTFE IS 'Identifiant RTFE de la ressource';

COMMENT ON COLUMN BIP.RTFE_USER.NOM IS 'Nom de la ressource';

COMMENT ON COLUMN BIP.RTFE_USER.PRENOM IS 'Prénom de la ressource';

COMMENT ON COLUMN BIP.RTFE_USER.IDENT IS 'Identifiant BIP de la ressource: à 0 si inexistant';


ALTER TABLE BIP.TMP_DISC_FORUM DROP PRIMARY KEY CASCADE;
DROP TABLE BIP.TMP_DISC_FORUM CASCADE CONSTRAINTS;

--
-- TMP_DISC_FORUM  (Table) 
--
CREATE GLOBAL TEMPORARY TABLE BIP.TMP_DISC_FORUM
(
  USER_RTFE  VARCHAR2(60)                       NOT NULL,
  ID         NUMBER(6)                          NOT NULL
)
ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE BIP.TMP_DISC_FORUM IS 'Table temporaire pour l''écran Fil de discussion du forum';

COMMENT ON COLUMN BIP.TMP_DISC_FORUM.USER_RTFE IS 'Identifiant RTFE de l''utilisateur';

COMMENT ON COLUMN BIP.TMP_DISC_FORUM.ID IS 'Identifiant du message';


DROP TABLE BIP.TMP_DIVA_BUDGETS CASCADE CONSTRAINTS;

--
-- TMP_DIVA_BUDGETS  (Table) 
--
CREATE TABLE BIP.TMP_DIVA_BUDGETS
(
  PID        VARCHAR2(4)                        NOT NULL,
  PNOM       VARCHAR2(30),
  ANNEE      NUMBER(4)                          NOT NULL,
  BPMONTME   NUMBER(12,2),
  BPMONTME1  NUMBER(12,2),
  REESTIME   NUMBER(12,2)
)
TABLESPACE tbs_bip_ref_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256K
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON COLUMN BIP.TMP_DIVA_BUDGETS.PID IS 'Code ligne BIP';

COMMENT ON COLUMN BIP.TMP_DIVA_BUDGETS.PNOM IS 'Libellé ligne BIP';

COMMENT ON COLUMN BIP.TMP_DIVA_BUDGETS.ANNEE IS 'Année n du budget';

COMMENT ON COLUMN BIP.TMP_DIVA_BUDGETS.BPMONTME IS 'Budget proposé Année n';

COMMENT ON COLUMN BIP.TMP_DIVA_BUDGETS.BPMONTME1 IS 'Budget proposé Année n+1';

COMMENT ON COLUMN BIP.TMP_DIVA_BUDGETS.REESTIME IS 'Budget Réestimé';


DROP TABLE BIP.TMP_ORGANISATION CASCADE CONSTRAINTS;

--
-- TMP_ORGANISATION  (Table) 
--
CREATE TABLE BIP.TMP_ORGANISATION
(
  NUMSEQ        NUMBER                          NOT NULL,
  CODSG         NUMBER(7)                       NOT NULL,
  LIBDSG        VARCHAR2(30),
  GNOM          VARCHAR2(30),
  LIBPOLE       VARCHAR2(20),
  IDENT         NUMBER(5),
  CHEF_PROJET   VARCHAR2(50),
  REESTIME      NUMBER(12,2),
  ANMONT        NUMBER(12,2),
  CUSAG         NUMBER(12,2),
  NB_RESS       NUMBER(4),
  NB_RESS_SG    NUMBER(4),
  NB_RESS_SSII  NUMBER(4)
)
TABLESPACE tbs_bip_tmp_data
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       5000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCACHE
NOPARALLEL;

COMMENT ON COLUMN BIP.TMP_ORGANISATION.NUMSEQ IS 'Numéro Séquentiel de l''édition';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.CODSG IS 'Code Département Pole Groupe';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.LIBDSG IS 'Libelle du code div/sect/groupe';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.GNOM IS 'Nom du responsable';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.LIBPOLE IS 'Libelle du pôle';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.IDENT IS 'Identifiant du chef de projet';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.CHEF_PROJET IS 'Nom du chef de projet';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.REESTIME IS 'Budget réestimé';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.ANMONT IS 'Budget arbitré notifié';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.CUSAG IS 'Consommé total de l année';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.NB_RESS IS 'Nombre de ressources rattachées';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.NB_RESS_SG IS 'Nombre de ressources SG rattachées';

COMMENT ON COLUMN BIP.TMP_ORGANISATION.NB_RESS_SSII IS 'Nombre de ressources SSII rattachées';


