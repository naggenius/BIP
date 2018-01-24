CREATE OR REPLACE FORCE VIEW "BIP"."EBIS_LOGS_CONT_LIGNE_SUPP" ("TYPE_ACTION", "DATE_LOG", "USER_LOG", "CONTRAT", "PERIMETRE", "REFFOURNISSEUR", "FOURNISSEUR", "LIGNE", "CODE_RESSOURCE", "NOM_RESSOURCE", "DATEDEB_LIGNE", "DATEFIN_LIGNE", "SOCIETE", "SIREN", "AVENANT", "DATDEBCONTRAT", "DATFINCONTRAT") AS 
  SELECT l.type_action type_action, l.date_log date_log, l.user_log user_log,
       l.numcont contrat, l.codperim perimetre, l.codref reffournisseur,
       l.code_fournisseur_ebis fournisseur, TO_CHAR (l.lcnum) ligne,
       TO_CHAR (l.ident) code_ressource, l.rnom nom_ressource,
       TO_CHAR (l.lresdeb) datedeb_ligne, TO_CHAR (l.lresfin) datefin_ligne,
       NULL societe, NULL siren, l.cav avenant, NULL datdebcontrat,
       NULL datfincontrat
  FROM ligne_cont_logs l, directions d, struct_info s
 WHERE l.type_action = 1
   AND s.codsg = l.codsg
   AND s.coddir = d.coddir
   AND d.syscompta = 'EXP'
UNION
SELECT c.type_action type_action, c.date_log date_log, c.user_log user_log,
       c.numcont contrat, NULL perimetre, NULL reffournisseur,
       NULL fournisseur, NULL ligne, NULL code_ressource, NULL nom_ressoure, NULL datedeb_ligne, NULL datefin_ligne, c.soccont societe, TO_CHAR (c.siren) siren, c.cav avenant,
       TO_CHAR (c.cdatdeb) datdebcontrat, TO_CHAR (c.cdatfin) datfincontrat
  FROM contrats_logs c, directions d, struct_info s
 WHERE c.type_action = 2
   AND s.codsg = c.codsg
   AND s.coddir = d.coddir
   AND d.syscompta = 'EXP'
 ;
