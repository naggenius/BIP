spool create_table_archive_bips.log;

create table BIP.ARCHIVE_PMW_BIPS parallel 4 nologging as 
select * from pmw_bips where to_char(consodebdate,'MM/YYYY')>=(select to_char(ADD_MONTHS(moismens,-2),'MM/YYYY') from datdebex);

COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."LIGNEBIPCODE" IS 'Identifiant de la ligne bip';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."LIGNEBIPCLE" IS 'Cl� de la ligne bip';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STRUCTUREACTION" IS 'Action sur la structure la ligne bip';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."ETAPENUM" IS 'Num�ro de l''�tape';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."ETAPETYPE" IS 'Type de l''�tape';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."ETAPELIBEL" IS 'Libell� de l''�tape';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."TACHENUM" IS 'Num�ro de t�che';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."TACHELIBEL" IS 'Libell� de t�che';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHENUM" IS 'Num�ro de sous-t�che';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHETYPE" IS 'Type de sous-t�che';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHELIBEL" IS 'Libell� de la sous-t�che';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEINITDEBDATE" IS 'Date initiale de d�but pr�vue,  au format JJ/MM/AAAA';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEINITFINDATE" IS 'Date initiale de fin pr�vue,  au format JJ/MM/AAAA';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEREVDEBDATE" IS 'Date r�vis�e ou r�elle de d�but pr�vue,  au format JJ/MM/AAAA';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEREVFINDATE" IS 'Date r�vis�e ou r�elle de fin pr�vue,  au format JJ/MM/AAAA';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHESTATUT" IS 'Statut local de la sous-t�che';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEDUREE" IS 'Dur�e de la sous-t�che en jours ouvr�s';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."STACHEPARAMLOCAL" IS 'Param�tre local de la sous-t�che';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."RESSBIPCODE" IS 'Code de la ressource qui impute';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."RESSBIPNOM" IS 'Nom ou d�but du nom, pour contr�le';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."CONSODEBDATE" IS 'Date de d�but de la p�riode concern�e, au format JJ/MM/AAAA. ';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."CONSOFINDATE" IS 'Date de fin de la p�riode concern�e � l''int�rieur du m�me mois, au format JJ/MM/AAAA. ';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."CONSOQTE" IS 'Quantit� consomm�e sur la p�riode, en JH ou �quivalent JH';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."PROVENANCE" IS 'Source du fichier';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."PRIORITE" IS 'P2 : PMW - P3 :ISAC';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."TOP" IS 'O : prise en compte - N : pas encore pris en compte';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."USER_PEC" IS 'User du fichier';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."DATE_PEC" IS 'Date de prise en compte';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."FICHIER" IS 'Nom du fichier';
COMMENT ON COLUMN "BIP"."ARCHIVE_PMW_BIPS"."TACHEAXEMETIER" IS 'Axe m�tier associ� � cette t�che';

/
exit;
show errors
  
