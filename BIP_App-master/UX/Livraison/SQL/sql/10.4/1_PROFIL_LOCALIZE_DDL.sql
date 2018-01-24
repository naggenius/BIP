/*
 * 
 * New table PROFIL_LOCALIZE for new invoice calculation
 * */
  CREATE TABLE PROFIL_LOCALIZE 
   (	PROFIL_LOCALIZE VARCHAR2(12) NOT NULL, 
	LIBELLE VARCHAR2(30) NOT NULL, 
	DATE_EFFET DATE, 
	TOP_ACTIF VARCHAR2(1) NOT NULL, 
	FORCE_TRAVAIL NUMBER(12,2), 
	FRAIS_ENVIRONNEMENT NUMBER(12,2), 
	COMMENTAIRE VARCHAR2(300), 
	CODDIR VARCHAR2(2) NOT NULL, 
	PROFIL_DEFAUT VARCHAR2(1) NOT NULL, 
	CODE_LOCALIZE VARCHAR2(1), 
	CODE_ES VARCHAR2(29));
	
	ALTER TABLE PROFIL_LOCALIZE ADD CONSTRAINT PK_PROFIL_LOCALIZE PRIMARY KEY (PROFIL_LOCALIZE, DATE_EFFET);

   COMMENT ON COLUMN PROFIL_LOCALIZE.PROFIL_LOCALIZE IS 'Profil Localis�s';
   COMMENT ON COLUMN PROFIL_LOCALIZE.LIBELLE IS 'Libell� Profil Localis�s';
   COMMENT ON COLUMN PROFIL_LOCALIZE.DATE_EFFET IS 'Date Verrouill�e au Format MM/AAAA.';
   COMMENT ON COLUMN PROFIL_LOCALIZE.TOP_ACTIF IS 'Indicateur obligatoire associ� au Profil Localis�s et � la date d''effet.';
   COMMENT ON COLUMN PROFIL_LOCALIZE.FORCE_TRAVAIL IS 'Co�t unitaire HTR de la force de travail associ� au Profil DomFonc et � la date d''effet.';
   COMMENT ON COLUMN PROFIL_LOCALIZE.FRAIS_ENVIRONNEMENT IS 'Co�t unitaire HTR des frais d''environnement associ� au Profil DomFonc et � la date d''effet.';
   COMMENT ON COLUMN PROFIL_LOCALIZE.COMMENTAIRE IS 'Commentaires';
   COMMENT ON COLUMN PROFIL_LOCALIZE.CODDIR IS 'Direction Bip associ� au Profil Localis�s et � la date d''effet';
   COMMENT ON COLUMN PROFIL_LOCALIZE.PROFIL_DEFAUT IS 'Profil par d�faut associ� � la date d''effet et � la Direction.';
   COMMENT ON COLUMN PROFIL_LOCALIZE.CODE_LOCALIZE IS 'Code representing the localization concerned for this localizated profile and this date of effect.';
   COMMENT ON COLUMN PROFIL_LOCALIZE.CODE_ES IS 'La liste des codes ES concern�s par ce Profil Localis�s et cette date d''effet. ';
