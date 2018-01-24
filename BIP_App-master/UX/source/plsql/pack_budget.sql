--------------------------------------------------------
--  Fichier créé - lundi-octobre-10-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_BUDGET
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BIP"."PACK_BUDGET" IS
	PROCEDURE Delete_budgetprop(
			p_annee		IN	budget.annee%TYPE,
			p_pid	IN	budget.pid%TYPE
	);
PROCEDURE Delete_budgetnot(
			p_annee		IN	budget.annee%TYPE,
			p_pid	IN	budget.pid%TYPE
	);
PROCEDURE Delete_budgetarbprop(
			p_annee		IN	budget.annee%TYPE,
			p_pid	IN	budget.pid%TYPE
	);
PROCEDURE Delete_budgetarbnot(
			p_annee		IN	budget.annee%TYPE,
			p_pid	IN	budget.pid%TYPE
	);
	PROCEDURE Insert_budgetprop(
			p_annee		IN	budget.annee%TYPE,
			p_pid	IN	budget.pid%TYPE,
			p_bpmontme	IN	budget.bpmontme%TYPE,
			p_bpmontme2     IN      budget.bpmontme2%TYPE,
			p_bpdate       IN      budget.bpdate%TYPE,
                	p_reserve          IN      budget.reserve%TYPE,
                	p_bpmontmo        IN      budget.bpmontmo%TYPE
	);
	PROCEDURE Update_budgetprop(
			p_annee		IN	budget.annee%TYPE,
			p_pid	IN	budget.pid%TYPE,
			p_bpmontme	IN	budget.bpmontme%TYPE,
			p_bpmontme2     IN      budget.bpmontme2%TYPE,
			p_bpdate       IN      budget.bpdate%TYPE,
                	p_reserve          IN      budget.reserve%TYPE,
                	p_bpmontmo        IN      budget.bpmontmo%TYPE
	);
	PROCEDURE Insert_budgetnot(
	p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_bnmont	IN	budget.bnmont%TYPE
	);
	PROCEDURE Update_budgetnot(
				p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_bnmont	IN	budget.bnmont%TYPE
	);
PROCEDURE Insert_budgetarbprop(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_apdate	IN	budget.apdate%TYPE,
		p_apmont	IN	budget.apmont%TYPE
	);
	PROCEDURE Update_budgetarbprop(
					p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_apdate	IN	budget.apdate%TYPE,
		p_apmont	IN	budget.apmont%TYPE
	);
PROCEDURE Insert_budgetarbnot(
	p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_anmont	IN	budget.anmont%TYPE
	);
	PROCEDURE Update_budgetarbnot(
			p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_anmont	IN	budget.anmont%TYPE
	);
	PROCEDURE Update_lignebip(
		p_pid	IN	budget.pid%TYPE,
		p_preesancou_old	IN	budget.reestime%TYPE,
		p_preesancou_new        IN      budget.reestime%TYPE
	);
END pack_budget;

 

/
--------------------------------------------------------
--  DDL for Package Body PACK_BUDGET
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "BIP"."PACK_BUDGET" IS
	PROCEDURE Delete_budgetprop(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE
	) IS
	BEGIN
        	UPDATE budget set bpmontme = NULL,
					bpmontme2 = NULL,
					bpdate = NULL,
					reserve = NULL,
					bpmontmo = NULL
        	WHERE annee = p_annee
        	AND   pid = p_pid;
	END Delete_budgetprop;
PROCEDURE Delete_budgetarbprop(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE
	) IS
	BEGIN
        	raise_application_error(-20000,'Déclenchement du trigger delete_budgproparb');
	END Delete_budgetarbprop;
	PROCEDURE Delete_budgetarbnot(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE
	) IS
	BEGIN
        	raise_application_error(-20000,'Déclenchement du trigger delete_budgnotarb');
	END Delete_budgetarbnot;
PROCEDURE Delete_budgetnot(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE
	) IS
	BEGIN
        	raise_application_error(-20000,'Déclenchement du trigger delete_budgnot');
	END Delete_budgetnot;
	PROCEDURE Insert_budgetprop(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_bpmontme	IN	budget.bpmontme%TYPE,
		p_bpmontme2     IN      budget.bpmontme2%TYPE,
		p_bpdate       IN      budget.bpdate%TYPE,
                p_reserve          IN      budget.reserve%TYPE,
                p_bpmontmo        IN      budget.bpmontmo%TYPE
               ) IS
	BEGIN
                INSERT INTO BUDGET
						(annee,
			 pid,
			 bnmont,
			 bpmontme,
			 bpmontme2,
			 anmont,
			 bpdate,
			 reserve,
                   apdate,
                   apmont,
			 bpmontmo,
			 reestime,
			 flaglock)
		VALUES (p_annee,
						p_pid,
						NULL,
						p_bpmontme,
						p_bpmontme2,
						NULL,
						p_bpdate,
						p_reserve,
						NULL,
						NULL,
						p_bpmontmo,
						NULL,
						0);
	EXCEPTION
			WHEN DUP_VAL_ON_INDEX THEN
			update_budgetprop(p_annee,p_pid,p_bpmontme,p_bpmontme2,p_bpdate,p_reserve,p_bpmontmo);
	END Insert_budgetprop;
	PROCEDURE Insert_budgetnot(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_bnmont	IN	budget.bnmont%TYPE
               ) IS
	BEGIN
                INSERT INTO BUDGET
						(annee,
			 pid,
			 bnmont,
			 bpmontme,
			 bpmontme2,
			 anmont,
			 bpdate,
			 reserve,
                   apdate,
                   apmont,
			 bpmontmo,
			reestime,
			 flaglock)
		VALUES (p_annee,
						p_pid,
						p_bnmont,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						0);
	EXCEPTION
			WHEN DUP_VAL_ON_INDEX THEN
				update_budgetnot(p_annee,p_pid,p_bnmont);
	END Insert_budgetnot;
PROCEDURE Insert_budgetarbprop(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_apdate	IN	budget.apdate%TYPE,
		p_apmont	IN	budget.apmont%TYPE
               ) IS
	BEGIN
                INSERT INTO BUDGET
						(annee,
			 pid,
			 bnmont,
			 bpmontme,
			 bpmontme2,
			 anmont,
			 bpdate,
			 reserve,
                   apdate,
                   apmont,
			 bpmontmo,
			 reestime,
			 flaglock)
		VALUES (p_annee,
						p_pid,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						p_apdate,
						p_apmont,
						NULL,
						NULL,
						0);
	EXCEPTION
			WHEN DUP_VAL_ON_INDEX THEN
				update_budgetarbprop(p_annee,p_pid,p_apdate,p_apmont);
	END Insert_budgetarbprop;
PROCEDURE Insert_budgetarbnot(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_anmont	IN	budget.anmont%TYPE
               ) IS
	BEGIN
                INSERT INTO BUDGET
						(annee,
			 pid,
			 bnmont,
			 bpmontme,
			 bpmontme2,
			 anmont,
			 bpdate,
			 reserve,
                   apdate,
                   apmont,
			 bpmontmo,
			 reestime,
			 flaglock)
		VALUES (p_annee,
						p_pid,
						NULL,
						NULL,
						NULL,
						p_anmont,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						0);
	EXCEPTION
			WHEN DUP_VAL_ON_INDEX THEN
				update_budgetarbnot(p_annee,p_pid,p_anmont);
	END Insert_budgetarbnot;
	PROCEDURE Update_budgetprop(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_bpmontme	IN	budget.bpmontme%TYPE,
		p_bpmontme2     IN      budget.bpmontme2%TYPE,
		p_bpdate       IN      budget.bpdate%TYPE,
                p_reserve          IN      budget.reserve%TYPE,
                p_bpmontmo        IN      budget.bpmontmo%TYPE
	) IS
	BEGIN
                 	UPDATE BUDGET SET bpdate = p_bpdate,
							bpmontme  = p_bpmontme,
							bpmontme2 = p_bpmontme2,
							reserve = p_reserve,
							bpmontmo = p_bpmontmo
				WHERE annee = p_annee AND pid = p_pid;
	END Update_budgetprop;
	PROCEDURE Update_budgetnot(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_bnmont	IN	budget.bnmont%TYPE
	) IS
	BEGIN
                 	UPDATE BUDGET SET bnmont = p_bnmont
				WHERE annee = p_annee AND pid = p_pid;
	END Update_budgetnot;
	PROCEDURE Update_budgetarbnot(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_anmont	IN	budget.anmont%TYPE
	) IS
	BEGIN
                 	UPDATE BUDGET SET anmont = p_anmont
				WHERE annee = p_annee AND pid = p_pid;
	END Update_budgetarbnot;
	PROCEDURE Update_budgetarbprop(
		p_annee		IN	budget.annee%TYPE,
		p_pid	IN	budget.pid%TYPE,
		p_apdate	IN	budget.apdate%TYPE,
		p_apmont	IN	budget.apmont%TYPE
	) IS
	BEGIN
                 	UPDATE BUDGET SET apdate = p_apdate,
						apmont = p_apmont
				WHERE annee = p_annee AND pid = p_pid;
	END Update_budgetarbprop;
	PROCEDURE Update_lignebip(
		p_pid	IN	budget.pid%TYPE,
		p_preesancou_old	IN	budget.reestime%TYPE,
		p_preesancou_new        IN      budget.reestime%TYPE
	)IS
	BEGIN
		UPDATE BUDGET SET reestime = p_preesancou_new
		WHERE pid = p_pid
		AND annee = (select to_number(to_char(datdebex.datdebex,'YYYY')) from datdebex);
		IF (SQL%ROWCOUNT = 0) THEN
			INSERT INTO BUDGET
				(annee,
				pid,
				bnmont,
				bpmontme,
				bpmontme2,
				anmont,
				bpdate,
				reserve,
				apdate,
				apmont,
				bpmontmo,
				reestime,
				flaglock)
			 (SELECT TO_NUMBER(TO_CHAR(datdebex.datdebex,'YYYY')),
				p_pid,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				p_preesancou_new,
				0
				FROM datdebex);
	 	END IF;
	END Update_lignebip;
END pack_budget;

/
