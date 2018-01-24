spool create_table_archive_bips.log;

create table BIP.ARCHIVE_PMW_BIPS parallel 4 nologging as 
select * from pmw_bips where to_char(consodebdate,'MM/YYYY')>=(select to_char(ADD_MONTHS(moismens,-2),'MM/YYYY') from datdebex);

COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."LIGNEBIPCODE" IS 'Identifiant de la ligne bip';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."LIGNEBIPCLE" IS 'Clé de la ligne bip';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STRUCTUREACTION" IS 'Action sur la structure la ligne bip';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."ETAPENUM" IS 'Numéro de l''étape';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."ETAPETYPE" IS 'Type de l''étape';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."ETAPELIBEL" IS 'Libellé de l''étape';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."TACHENUM" IS 'Numéro de tâche';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."TACHELIBEL" IS 'Libellé de tâche';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHENUM" IS 'Numéro de sous-tâche';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHETYPE" IS 'Type de sous-tâche';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHELIBEL" IS 'Libellé de la sous-tâche';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEINITDEBDATE" IS 'Date initiale de début prévue,  au format JJ/MM/AAAA';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEINITFINDATE" IS 'Date initiale de fin prévue,  au format JJ/MM/AAAA';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEREVDEBDATE" IS 'Date révisée ou réelle de début prévue,  au format JJ/MM/AAAA';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEREVFINDATE" IS 'Date révisée ou réelle de fin prévue,  au format JJ/MM/AAAA';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHESTATUT" IS 'Statut local de la sous-tâche';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEDUREE" IS 'Durée de la sous-tâche en jours ouvrés';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEPARAMLOCAL" IS 'Paramètre local de la sous-tâche';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."RESSBIPCODE" IS 'Code de la ressource qui impute';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."RESSBIPNOM" IS 'Nom ou début du nom, pour contrôle';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."CONSODEBDATE" IS 'Date de début de la période concernée, au format JJ/MM/AAAA. ';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."CONSOFINDATE" IS 'Date de fin de la période concernée à l''intérieur du même mois, au format JJ/MM/AAAA. ';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."CONSOQTE" IS 'Quantité consommée sur la période, en JH ou équivalent JH';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."PROVENANCE" IS 'Source du fichier';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."PRIORITE" IS 'P2 : PMW - P3 :ISAC';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."TOP" IS 'O : prise en compte - N : pas encore pris en compte';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."USER_PEC" IS 'User du fichier';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."DATE_PEC" IS 'Date de prise en compte';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."FICHIER" IS 'Nom du fichier';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."TACHEAXEMETIER" IS 'Axe métier associé à cette tâche';

/
exit;
show errors
  
