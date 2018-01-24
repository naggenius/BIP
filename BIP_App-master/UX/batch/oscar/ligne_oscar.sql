-- pack_oscar_lignebip PL/SQL
--
-- Crée le 09/07/2002
--
--***********************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_ligne_oscar AS

	
   PROCEDURE maj_ligne_oscar;

END pack_ligne_oscar;
/

CREATE OR REPLACE PACKAGE BODY pack_ligne_oscar AS 

   PROCEDURE maj_ligne_oscar IS

	L_ANNEE NUMBER;
	L_ANNEE1 NUMBER;
	l_top_oscar char(2);
	l_pid varchar2(4);

-- non modification des lignes SBAN par DIST

	CURSOR ligne_oscar IS
        SELECT i.pid,notifie,code_mo,resp_mo,objectif_mo,i.propo_mo_n1
        FROM imp_oscar_tmp i,client_mo c,ligne_bip lb
        WHERE lb.clicode=c.clicode
	AND  i.pid = lb.pid
        AND c.top_oscar='O'
        AND i.code_mo IN (SELECT clicode FROM client_mo
				WHERE top_oscar='O')
	;


	BEGIN

	SELECT TO_NUMBER(TO_CHAR(datdebex,'YYYY')) INTO L_ANNEE
	FROM datdebex;

	SELECT TO_NUMBER(TO_CHAR(datdebex,'YYYY'))+1 INTO L_ANNEE1
	FROM datdebex;

	FOR oscar IN ligne_oscar LOOP

-- mise a jour du nom de la maitrise d'ouvrage


		UPDATE ligne_bip
		SET pnmouvra=SUBSTR(oscar.resp_mo,1,15)
		WHERE pid=oscar.pid
		;

		IF SQL%ROWCOUNT=0 THEN
			UPDATE imp_oscar_tmp
			SET erreur='O'
			WHERE pid=oscar.pid; 
		END IF;


-- mise a jour du code client 

		
		UPDATE ligne_bip
		SET clicode=oscar.code_mo
		WHERE pid=oscar.pid
		;


		IF SQL%ROWCOUNT=0 THEN
			UPDATE imp_oscar_tmp
			SET erreur='O'
			WHERE pid=oscar.pid; 
		END IF;


-- mise a jour des donnees budgetaire : proposé mo de l'année
		
		UPDATE budget
		SET bpmontmo=oscar.notifie
		WHERE pid=oscar.pid 
		AND annee=L_ANNEE
		;

		IF SQL%ROWCOUNT=0 THEN
			BEGIN
				SELECT lb.pid INTO l_pid FROM ligne_bip lb
				WHERE lb.pid = oscar.pid;

				INSERT INTO budget(pid,annee,bpmontmo,flaglock)
				VALUES (oscar.pid,L_ANNEE,oscar.notifie,0);
				-- VALUES (oscar.pid,L_ANNEE1,oscar.notifie,0);

			EXCEPTION
				WHEN NO_DATA_FOUND THEN
				UPDATE imp_oscar_tmp
				SET erreur='O'
				WHERE pid=oscar.pid;	
			END;
		
		END IF;
		
	
-- mise a jour des donnees budgetaire : proposé mo de l'année+1
		
		UPDATE budget
		SET bpmontmo=oscar.propo_mo_n1
		WHERE pid=oscar.pid 
		AND annee=L_ANNEE1
		;

		IF SQL%ROWCOUNT=0 THEN
			BEGIN
				SELECT lb.pid INTO l_pid FROM ligne_bip lb
				WHERE lb.pid = oscar.pid;

				INSERT INTO budget(pid,annee,bpmontmo,flaglock)
				VALUES (oscar.pid,L_ANNEE1,oscar.propo_mo_n1,0);

			EXCEPTION
				WHEN NO_DATA_FOUND THEN
				UPDATE imp_oscar_tmp
				SET erreur='O'
				WHERE pid=oscar.pid;	
			END;
		
		END IF;

-- mise a jour des donnees budgetaire : réestimé de l'année en cours
		BEGIN
			SELECT nvl(sti.top_oscar,'N') INTO l_top_oscar
			FROM struct_info sti,ligne_bip lb
			WHERE sti.codsg = lb.codsg
			and lb.pid = oscar.pid;

		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				UPDATE imp_oscar_tmp
				SET erreur='O'
				WHERE pid=oscar.pid; 
				l_top_oscar := 'N';
		END;

		IF l_top_oscar = 'O' THEN 
	
			UPDATE budget
			SET reestime=oscar.objectif_mo
			WHERE pid=oscar.pid 
			AND annee=L_ANNEE
			;

			IF SQL%ROWCOUNT=0 THEN
				INSERT INTO budget(pid,annee,reestime,flaglock)
				VALUES (oscar.pid,L_ANNEE,oscar.objectif_mo,0);
			END IF;
		END IF;
	END LOOP;

	COMMIT;

   END maj_ligne_oscar;

END pack_ligne_oscar;
/
