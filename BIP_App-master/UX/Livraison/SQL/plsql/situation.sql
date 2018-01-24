/*
Impacts

source/plsql/tp :
resfor.SQL
	1 insert
reslog.sql
	1 insert
resper.sql
	1 insert
situfor.SQL
	4 update
	2 INSERT
	1 delete
situlog.sql
situper.sql
societe.SQL
	1 INSERT
	2 update
*/
-- Modifiée le 03/06/2008 par EVI FICHE 652  Mise en place des ressource SLOT

CREATE OR REPLACE TRIGGER delete_situation
AFTER DELETE ON situ_ress
FOR EACH ROW
BEGIN
	pack_situation_full.delete_situation(:old.ident, :old.datsitu);
END;
/

--UPDATE_SITUATION
--
create or replace
TRIGGER UPDATE_SITUATION
AFTER UPDATE
ON SITU_RESS
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
	Pack_Situation_Full.update_situation(:OLD.ident, :OLD.datsitu, :NEW.datsitu ,:NEW.datdep, :NEW.cpident,
	 :NEW.cout , :NEW.dispo, :NEW.marsg2, :NEW.rmcomp, :NEW.PRESTATION, :NEW.dprest, :NEW.soccode,
	:NEW.codsg, :NEW.NIVEAU, :NEW.MONTANT_MENSUEL, :NEW.fident, :NEW.MODE_CONTRACTUEL_INDICATIF);
END;
/

--INSERT_SITUATION
--
create or replace
TRIGGER INSERT_SITUATION
AFTER INSERT
ON SITU_RESS
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    Pack_Situation_Full.insert_situation(:NEW.ident, :NEW.datsitu, :NEW.datdep, :NEW.cpident,
     :NEW.cout , :NEW.dispo, :NEW.marsg2, :NEW.rmcomp, :NEW.PRESTATION, :NEW.dprest, :NEW.soccode,
    :NEW.codsg, :NEW.NIVEAU, :NEW.MONTANT_MENSUEL, :NEW.fident, :NEW.MODE_CONTRACTUEL_INDICATIF);
END;
/

-- Modifié le
-- 18/11/2003: ajout du niveau
-- 12/07/2004	EGR	:	F370 : retrait de filcode dans situ_ress et situ_ress_full
-- 05/12/2005   BAA     :       Fiche 319 : ajouter la mise à jour de montant_mensuel
-- Modifiée le 03/06/2008 par EVI FICHE 652  Mise en place des ressource SLOT
-- Modifiée le 29/06/2010 par YNI FICHE 970 

create or replace
PACKAGE     Pack_Situation_Full IS
	PROCEDURE Maj_Ressource(
		p_ident	IN	RESSOURCE.ident%TYPE
	);

	PROCEDURE Delete_Situation(
		p_ident		IN	SITU_RESS.ident%TYPE,
		p_datsitu	IN	DATE
	);

	PROCEDURE Insert_Situation(
		p_ident		IN	SITU_RESS.ident%TYPE,
		p_datsitu	IN	DATE,
		p_datdep	IN	DATE,
                p_cpident       IN      NUMBER,
                p_cout          IN      NUMBER,
                p_dispo         IN      NUMBER,
                p_marsg2        IN      CHAR,
                p_rmcomp        IN      NUMBER,
                p_prestation    IN      CHAR,
                p_dprest        IN      CHAR,
                p_soccode       IN      CHAR,
                --p_filcode       IN      CHAR,
                p_codsg         IN      NUMBER,
				p_niveau		IN		VARCHAR2,
				p_montant_mensuel		IN		NUMBER,
                p_fident       IN      NUMBER,
                p_mode_contractuel_ind IN SITU_RESS_FULL.MODE_CONTRACTUEL_INDICATIF%TYPE
);
	PROCEDURE Update_Situation(
		p_ident		IN	SITU_RESS.ident%TYPE,
		p_datsitu_b	IN	DATE,
		p_datsitu_a	IN	DATE,
		p_datdep_a	IN	DATE,
                p_cpident       IN      NUMBER,
                p_cout          IN      NUMBER,
                p_dispo         IN      NUMBER,
                p_marsg2        IN      CHAR,
                p_rmcomp        IN      NUMBER,
                p_prestation    IN      CHAR,
                p_dprest        IN      CHAR,
                p_soccode       IN      CHAR,
                --p_filcode       IN      CHAR,
                p_codsg         IN      NUMBER,
				p_niveau		IN		VARCHAR2,
				p_montant_mensuel		IN		NUMBER,
                p_fident       IN      NUMBER,
                p_mode_contractuel_ind IN SITU_RESS_FULL.MODE_CONTRACTUEL_INDICATIF%TYPE

	);

	PROCEDURE Maj_Complete;

	FUNCTION Qualif_Ressource(
		p_ident	IN	SITU_RESS.ident%TYPE,
		p_date	IN	DATE
	) RETURN SITU_RESS.PRESTATION%TYPE;
	PRAGMA RESTRICT_REFERENCES (Qualif_Ressource, WNDS, WNPS);

	FUNCTION DatSitu_Ressource(
                p_ident IN      SITU_RESS.ident%TYPE,
                p_date  IN      DATE
        ) RETURN SITU_RESS.DatSitu%TYPE;
        PRAGMA RESTRICT_REFERENCES (DatSitu_Ressource, WNDS, WNPS);

-- procedure de maj de PROPLUS suite a modif des situations
	PROCEDURE Maj_Situation_Proplus_Ress(P_Ident IN RESSOURCE.ident%TYPE);

	NORMAL	CONSTANT CHAR(1) := 'N';
	AVANT	CONSTANT CHAR(1) := 'A';
	APRES	CONSTANT CHAR(1) := 'P';
	VIDE	CONSTANT CHAR(1) := 'V';
END Pack_Situation_Full;
/

create or replace
PACKAGE BODY     Pack_Situation_Full IS


PROCEDURE Copie_N(
		p_ident	IN	RESSOURCE.ident%TYPE
	) IS
	BEGIN
-- on retire tout ce qui existait
		DELETE SITU_RESS_FULL WHERE ident=p_ident;

-- on remet les situations existantes normales
		INSERT INTO SITU_RESS_FULL
			(DATSITU,
			DATDEP,
			CPIDENT,
			COUT,
			DISPO,
			MARSG2,
			RMCOMP,
			PRESTATION,
			DPREST,
			IDENT,
			SOCCODE,
			--FILCODE,
			CODSG,
			TYPE_SITU,
			NIVEAU,
            FIDENT
            )
		SELECT DATSITU,
			DATDEP,
			CPIDENT,
			COUT,
			DISPO,
			MARSG2,
			RMCOMP,
			PRESTATION,
			DPREST,
			IDENT,
			SOCCODE,
			--FILCODE,
			CODSG,
			NORMAL,
			NIVEAU,
            FIDENT
		FROM SITU_RESS
		WHERE ident=p_ident;

	END Copie_N;


	PROCEDURE Complete_AVP(
		p_ident	IN	RESSOURCE.ident%TYPE
	) IS
		nombre	INTEGER;

		CURSOR csr_situation(csr_ident IN RESSOURCE.ident%TYPE) IS
			SELECT *
			FROM SITU_RESS_FULL
			WHERE ident=csr_ident
                        AND type_situ = NORMAL
			ORDER BY datsitu;
		rec_situation_prev	csr_situation%ROWTYPE;
	BEGIN
-- ON ajoute la situation avant toutes les autres
-- ON reprend les donnees de la premiere situation
		INSERT INTO SITU_RESS_FULL
			(DATSITU,
			DATDEP,
			CPIDENT,
			COUT,
			DISPO,
			MARSG2,
			RMCOMP,
			PRESTATION,
			DPREST,
			IDENT,
			SOCCODE,
			--FILCODE,
			CODSG,
			TYPE_SITU,
			NIVEAU,
            FIDENT)

		SELECT NULL,
			DATSITU-1,
			CPIDENT,
			COUT,
			DISPO,
			MARSG2,
			RMCOMP,
			PRESTATION,
			DPREST,
			IDENT,
			SOCCODE,
			--FILCODE,
			CODSG,
			AVANT,
			NIVEAU,
            FIDENT

		FROM SITU_RESS_FULL
		WHERE ident=p_ident
                AND type_situ = NORMAL
		AND datsitu=(SELECT MIN(datsitu) FROM SITU_RESS_FULL WHERE ident=p_ident);

-- ON teste s'il existe une situation sans DATE de fin (derniere situation)
		SELECT COUNT(1)
			INTO nombre
			FROM SITU_RESS_FULL
			WHERE ident=p_ident
                        AND type_situ = NORMAL
			AND datdep IS NULL;

-- s'il en existe pas ON ajoute une situation apres la derniere
-- ON reprend les donnees de la derniere situation
		IF nombre=0 THEN
			INSERT INTO SITU_RESS_FULL
				(DATSITU,
				DATDEP,
				CPIDENT,
				COUT,
				DISPO,
				MARSG2,
				RMCOMP,
				PRESTATION,
				DPREST,
				IDENT,
				SOCCODE,
				--FILCODE,
				CODSG,
				TYPE_SITU,
				NIVEAU,
                FIDENT)

			SELECT DATDEP+1,
				NULL,
				CPIDENT,
				COUT,
				DISPO,
				MARSG2,
				RMCOMP,
				PRESTATION,
				DPREST,
				IDENT,
				SOCCODE,
				--FILCODE,
				CODSG,
				APRES,
				NIVEAU,
                FIDENT

			FROM SITU_RESS_FULL
			WHERE ident=p_ident
                        AND type_situ = NORMAL
			AND datsitu=(SELECT MAX(datsitu) FROM SITU_RESS_FULL WHERE ident=p_ident);
		END IF;

-- il reste a boucher les eventuels trous
		nombre:=0;
		FOR rec_situation IN csr_situation(p_ident) LOOP
			IF nombre=0 THEN
				nombre:=1;
			ELSE
				IF rec_situation_prev.datdep+1<rec_situation.datsitu THEN
					INSERT INTO SITU_RESS_FULL
						(DATSITU,
						DATDEP,
						CPIDENT,
						COUT,
						DISPO,
						MARSG2,
						RMCOMP,
						PRESTATION,
						DPREST,
						IDENT,
						SOCCODE,
						--FILCODE,
						CODSG,
						TYPE_SITU,
						NIVEAU,
                        FIDENT)

					VALUES (rec_situation_prev.datdep+1,
						rec_situation.datsitu-1,
						rec_situation_prev.cpident,
						rec_situation_prev.cout,
						rec_situation_prev.dispo,
						rec_situation_prev.MARSG2,
						rec_situation_prev.RMCOMP,
						rec_situation_prev.PRESTATION,
						rec_situation_prev.DPREST,
						rec_situation_prev.IDENT,
						rec_situation_prev.SOCCODE,
						--rec_situation_prev.FILCODE,
						rec_situation_prev.CODSG,
						VIDE,
						rec_situation_prev.NIVEAU,
                        rec_situation_prev.FIDENT);

				END IF;
			END IF;
			rec_situation_prev:=rec_situation;
		END LOOP;
	END Complete_AVP;

PROCEDURE Delete_AVP(
		p_ident		IN	SITU_RESS.ident%TYPE
	) IS
	BEGIN
         DELETE FROM SITU_RESS_FULL
         WHERE ident = p_ident
         AND TYPE_SITU IN (AVANT,APRES,VIDE);
        END Delete_AVP;



	PROCEDURE Maj_Ressource(
		p_ident	IN	RESSOURCE.ident%TYPE
	) IS
		BEGIN

-- on recopie dans la table situ_ress_full les situations normales de la table situ_ress pour l'identifiant donné
		Copie_N (p_ident);
-- on complète par les avants, après et les vides
                Complete_AVP (p_ident);
	COMMIT;
	END Maj_Ressource;






	PROCEDURE Delete_Situation(
		p_ident		IN	SITU_RESS.ident%TYPE,
		p_datsitu	IN	DATE
	) IS
	BEGIN
-- on delete toutes les situations fictives avant,après et vide
        	Delete_AVP (p_ident);
-- on delete la situation passée en paramètre
        	DELETE FROM SITU_RESS_FULL
        	WHERE ident = p_ident
        	AND   datsitu = p_datsitu;
-- on complète les situations de cet identifiant par les avants,après et vide
        	Complete_AVP(p_ident);
-- on met a jour la table PROPLUS
		Maj_Situation_Proplus_Ress(p_ident);
	END Delete_Situation;


	PROCEDURE Insert_Situation(
		p_ident		IN	SITU_RESS.ident%TYPE,
		p_datsitu	IN	DATE,
		p_datdep	IN	DATE,
		p_cpident       IN      NUMBER,
    p_cout          IN      NUMBER,
    p_dispo         IN      NUMBER,
    p_marsg2        IN      CHAR,
    p_rmcomp        IN      NUMBER,
    p_prestation    IN      CHAR,
    p_dprest        IN      CHAR,
    p_soccode       IN      CHAR,
    --p_filcode       IN      CHAR,
    p_codsg         IN      NUMBER,
    p_niveau		IN		VARCHAR2,
    p_montant_mensuel		IN		NUMBER,
    p_fident       IN      NUMBER, 
    p_mode_contractuel_ind IN SITU_RESS_FULL.MODE_CONTRACTUEL_INDICATIF%TYPE


	) IS
	BEGIN
		Delete_AVP(p_ident);
                INSERT INTO SITU_RESS_FULL
						(DATSITU,
						DATDEP,
						CPIDENT,
						COUT,
						DISPO,
						MARSG2,
						RMCOMP,
						PRESTATION,
						DPREST,
						IDENT,
						SOCCODE,
						--FILCODE,
						CODSG,
						TYPE_SITU,
						NIVEAU,
						MONTANT_MENSUEL,
            FIDENT,
            MODE_CONTRACTUEL_INDICATIF
                        )
		VALUES (p_datsitu,
						p_datdep,
						p_cpident,
						p_cout,
						p_dispo,
						p_marsg2,
						p_rmcomp,
						p_prestation,
						p_dprest,
						p_ident,
						p_soccode,
						--p_filcode,
						p_codsg,
						NORMAL,
						p_niveau,
						p_montant_mensuel,
            p_fident,
            p_mode_contractuel_ind);


	        Complete_AVP(p_ident);
-- on met a jour la table PROPLUS
		Maj_Situation_Proplus_Ress(p_ident);
	END Insert_Situation;


	PROCEDURE Update_Situation(
		p_ident		IN	SITU_RESS.ident%TYPE,
		p_datsitu_b	IN	DATE,
		p_datsitu_a	IN	DATE,
		p_datdep_a	IN	DATE,
		p_cpident       IN      NUMBER,
                p_cout          IN      NUMBER,
                p_dispo         IN      NUMBER,
                p_marsg2        IN      CHAR,
                p_rmcomp        IN      NUMBER,
                p_prestation    IN      CHAR,
                p_dprest        IN      CHAR,
                p_soccode       IN      CHAR,
                --p_filcode       IN      CHAR,
                p_codsg         IN      NUMBER,
				p_niveau		IN		VARCHAR2,
				p_montant_mensuel		IN		NUMBER,
                p_fident       IN      NUMBER,
                p_mode_contractuel_ind IN SITU_RESS_FULL.MODE_CONTRACTUEL_INDICATIF%TYPE


	) IS
	BEGIN
		  Delete_AVP(p_ident);
                  UPDATE SITU_RESS_FULL
                  SET   cpident       = p_cpident,
                        cout          = p_cout,
	                	dispo         = p_dispo,
                		marsg2        = p_marsg2,
                		rmcomp        = p_rmcomp,
                		PRESTATION    = p_prestation,
                		dprest        = p_dprest,
                		soccode       = p_soccode,
                		--filcode       = p_filcode,
                		codsg         = p_codsg,
                        datsitu       = p_datsitu_a,
                        datdep        = p_datdep_a,
						NIVEAU		  = p_niveau,
						MONTANT_MENSUEL = p_montant_mensuel,
                        FIDENT        = p_fident,
                        MODE_CONTRACTUEL_INDICATIF = p_mode_contractuel_ind

                  WHERE ident = p_ident
                  AND   datsitu = p_datsitu_b;
		  Complete_AVP(p_ident);
-- on met a jour la table PROPLUS
		Maj_Situation_Proplus_Ress(p_ident);
	END Update_Situation;



	PROCEDURE Maj_Complete
	IS
		CURSOR csr_ressource IS
			SELECT ident FROM RESSOURCE;
	BEGIN
		FOR rec_ressource IN csr_ressource LOOP
			maj_ressource(rec_ressource.ident);
		END LOOP;
	END Maj_complete;


        FUNCTION Qualif_Ressource(
                p_ident IN      SITU_RESS.ident%TYPE,
                p_date  IN      DATE
        ) RETURN SITU_RESS.PRESTATION%TYPE IS
		CURSOR csr_situation(pcsr_ident IN SITU_RESS.ident%TYPE) IS
			SELECT PRESTATION
				, datsitu
			FROM SITU_RESS
			WHERE ident=pcsr_ident
			ORDER BY datsitu;
		Prev_Qualif	SITU_RESS.PRESTATION%TYPE;
		Current_Qualif	SITU_RESS.PRESTATION%TYPE;
	BEGIN
		Prev_Qualif:=NULL;
		FOR rec_situation IN csr_situation(p_ident) LOOP
			Current_Qualif:=rec_situation.PRESTATION;
			IF rec_situation.datsitu>p_date THEN
				EXIT;
			END IF;
			Prev_Qualif:=Current_Qualif;
		END LOOP;
		IF Prev_Qualif IS NULL THEN
			Prev_Qualif:=Current_Qualif;
		END IF;
		RETURN Prev_Qualif;
	END Qualif_Ressource;


        FUNCTION DatSitu_Ressource(
                p_ident IN      SITU_RESS.ident%TYPE,
                p_date  IN      DATE
        ) RETURN SITU_RESS.DatSitu%TYPE IS
                CURSOR csr_situation(pcsr_ident IN SITU_RESS.ident%TYPE) IS
                        SELECT datsitu
                        FROM SITU_RESS
                        WHERE ident=pcsr_ident
                        ORDER BY datsitu;
                Prev_DatSitu	SITU_RESS.DatSitu%TYPE;
                Current_DatSitu	SITU_RESS.DatSitu%TYPE;
        BEGIN
                Prev_DatSitu:=NULL;
                FOR rec_situation IN csr_situation(p_ident) LOOP
                        Current_DatSitu:=rec_situation.DatSitu;
                        IF rec_situation.datsitu>p_date THEN
                                EXIT;
                        END IF;
                        Prev_DatSitu:=Current_DatSitu;
                END LOOP;
                IF Prev_DatSitu IS NULL THEN
                        Prev_DatSitu:=Current_DatSitu;
                END IF;
                RETURN Prev_DatSitu;
        END DatSitu_Ressource;


	PROCEDURE Maj_Situation_Proplus_Ress(P_Ident IN RESSOURCE.ident%TYPE) IS
	BEGIN
		UPDATE PROPLUS
		SET ( DATDEP, DIVSECGROU, CPIDENT, COUT, SOCIETE, QUALIF, DISPO ) =
		( SELECT DATDEP, CODSG, CPIDENT, COUT, SOCCODE, PRESTATION, DISPO
		  FROM SITU_RESS_FULL
		  WHERE PROPLUS.TIRES = SITU_RESS_FULL.IDENT
			AND ( (PROPLUS.CDEB>=SITU_RESS_FULL.DATSITU OR SITU_RESS_FULL.DATSITU IS NULL)
			      AND (PROPLUS.CDEB<=SITU_RESS_FULL.DATDEP OR SITU_RESS_FULL.DATDEP IS NULL)
			    )
			AND ROWNUM=1		-- petite condition pour se proteger contre les situations en recouvrement
		)
		WHERE tires=P_Ident;
	END Maj_Situation_Proplus_Ress;

END Pack_Situation_Full;
/


