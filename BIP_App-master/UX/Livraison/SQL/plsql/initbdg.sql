-- pack_initbdg PL/SQL
-- initialisation des budgets 
--
-- Equipe SOPRA 
--
-- Crée le 08/03/1999
--
-- Modifier le 08/04/1999 
--  Utilisation de curseur pour bloquer les enregistrements
--  pour la mise à jour
--
-- 06/02/2001 OPY : modif pour n'ecraser que les reestimes = 0
-- 09/01/2003 ARE : ne pas faire de copie de zones pour les lignes dont le code dossier projet est 70000
-- 30/11/2004 EGR : modification des code MO => direction correspinf a clicode et non plus clidom (table client_mo), la hierarchie se fait va la vue vue_clicode_hierarchie
-- 07/09/2005 MMC : TD2565 evol de la notification
-- 23/11/2005 PPR : met variable  l_num_vide  en VARCHAR
-- 26/01/2006 PPR : met à jour le réestimé s'il est égal à 0
-- 03/03/2006 PPR : Pour les type 9 - Modif suite règle qu'une ligne T9 appartient à plusieurs tables
-- 01/02/2006 DDI : Prise en compte du type de table de répartition (P ou A)
-- 17/03/2006 PPR : Optimisation du réestimé Type 9
-- 04/10/2006 BAA : Ajout de la clause client
-- 05/03/2009 EVI : TD 761 - Empeche la notification sur des lignes BIP fermé
--*************************************************************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...


CREATE OR REPLACE PACKAGE pack_initbdg AS

  -- Initialisation des budgets notifi_s et arbitr_s de tous les projets  : supprimé
  -- Initialisation des budgets notifi_s et arbitr_s par direction : supprimé
  -- Initialisation des budgets notifi_s et arbitr_s par type de projet : supprimé
  -- Initialisation des budgets arbitr_s par direction : supprimé
  -- Initialisation des budgets r_estim_s par domaine : supprimé


-- notification pour les grands projets
PROCEDURE initbdg_grand_projet (p_dpcode 	IN VARCHAR2,
				p_icpi 	IN VARCHAR2,
				p_metier 	IN VARCHAR2,
				p_dirme 	IN VARCHAR2,
				p_dirmo 	IN VARCHAR2,
                               	p_userid       	IN VARCHAR2,
                               	p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2,
                                p_nbnotif OUT NUMBER);

FUNCTION tous_metier  RETURN VARCHAR2;

-- notification hors grands projets
PROCEDURE initbdg_hors_grand_projet (p_typeprojet	IN VARCHAR2,
				p_metier 	IN VARCHAR2,
				p_dirme 	IN VARCHAR2,
				p_dirmo_partie 	IN VARCHAR2,
				p_code_mo 	IN VARCHAR2,
				p_dirmo_entier 	IN VARCHAR2,
                               	p_userid       	IN VARCHAR2,
                               	p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2,
                                p_nbnotif OUT NUMBER);


-- notification pour les lignes de type 9
PROCEDURE initbdg_type_9 (	p_dirme 	IN VARCHAR2,
			     	p_userid       	IN VARCHAR2,
                               	p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2);


END pack_initbdg;
/


CREATE OR REPLACE PACKAGE BODY     pack_initbdg AS

VIOLATION_CONSTRAINT_UNIQUE EXCEPTION;          -- pour clause when
PRAGMA EXCEPTION_INIT( VIOLATION_CONSTRAINT_UNIQUE, -00001 );

FUNCTION tous_metier  RETURN VARCHAR2 IS

l_metier VARCHAR2(50);

	CURSOR cur_metier  IS
 	select metier
 	from metier
 	order by metier;

 BEGIN
--l_metier := '';
FOR enr_cour IN cur_metier LOOP
  l_metier := l_metier || ',''' || enr_cour.metier|| '''';
END LOOP;



 return (substr(l_metier,2));
END tous_metier;

PROCEDURE initbdg_grand_projet (p_dpcode 	IN VARCHAR2,
				  p_icpi 	IN VARCHAR2,
				  p_metier 	IN VARCHAR2,
				  p_dirme 	IN VARCHAR2,
				  p_dirmo 	IN VARCHAR2,
                                  p_userid       	IN VARCHAR2,
                                  p_nbcurseur 	OUT INTEGER,
                                  p_message   	OUT VARCHAR2,
                                  p_nbnotif OUT NUMBER) IS


    -- variables locales

    msg 	VARCHAR(1024);
    l_annee 	NUMBER(4);                       -- annee courante
    l_jour 	DATE;                       -- jour de la modif
    l_user	VARCHAR2(35);
    l_bool_vide 	BOOLEAN;
    l_num_vide  VARCHAR2(4);
    l_budget_notifs BUDGET%ROWTYPE:=null;--PPM 58337 QC 1648
    l_budget_reestime BUDGET%ROWTYPE:=null;--PPM 58337 QC 1648
    l_nb_budg NUMBER:=-1;--PPM 58337 QC 1648
    l_nb_rees NUMBER:=-1;--PPM 58337 QC 1648
    exc_vide 	EXCEPTION;
    concurrence EXCEPTION;
    PRAGMA 	EXCEPTION_INIT (concurrence, -00054);

--*******************************************
--cas 1 : tous les projets - toutes les directions fournisseur - tous les metiers
CURSOR cur_1 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.dpcode = p_dpcode
	AND lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.arctype = 'T1'
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
        AND lb.dpcode <> 70000
	;
--******************

--*******************************************
--cas 01 : tous les dossiers projets - tous les projets - toutes les directions fournisseur - tous les metiers
CURSOR cur_01 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.arctype = 'T1'
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
        AND lb.dpcode <> 70000
	;
--******************

--*******************************************
--cas 2 : tous les projets - toutes les directions fournisseur
CURSOR cur_2 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.metier = p_metier
	AND lb.dpcode = p_dpcode
	AND lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.arctype = 'T1'
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
        AND lb.dpcode <> 70000
	;
--******************

--*******************************************
--cas 02 : tous les dossiers projets - tous les projets - toutes les directions fournisseur
CURSOR cur_02 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.metier = p_metier
	AND lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.arctype = 'T1'
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
        AND lb.dpcode <> 70000
	;
--******************

--*******************************************
--cas 3 : tous les projets - tous les metiers
CURSOR cur_3 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.dpcode = p_dpcode
	AND lb.codsg in (select codsg from struct_info si
			where si.coddir = p_dirme)
	AND lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.arctype = 'T1'
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND lb.dpcode <> 70000
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
	;
--******************

--*******************************************
--cas 03 : tous les dossiers projets - tous les projets - tous les metiers
CURSOR cur_03 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.codsg in (select codsg from struct_info si
			where si.coddir = p_dirme)
	AND lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.arctype = 'T1'
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND lb.dpcode <> 70000
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
	;
--******************

--*******************************************
--cas 4 : tous les projets (donc on se base sur le dossier projet pour faire la selection)
CURSOR cur_4 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.metier = p_metier
	AND lb.dpcode = p_dpcode
	AND lb.codsg in (select codsg from struct_info si
			where si.coddir = p_dirme)
	AND lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.arctype = 'T1'
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND lb.dpcode <> 70000
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
	;
--******************

--*******************************************
--cas 04 : tous les dossiers projets - tous les projets (donc on se base sur le dossier projet pour faire la selection)
CURSOR cur_04 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.metier = p_metier
	AND lb.codsg in (select codsg from struct_info si
			where si.coddir = p_dirme)
	AND lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.arctype = 'T1'
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND lb.dpcode <> 70000
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
	;
--******************

--*******************************************
--cas 5 : tous les metiers, toutes les directions fournisseur
CURSOR cur_5 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.icpi = p_icpi
	AND lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.arctype = 'T1'
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND lb.dpcode <> 70000
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
	;
--******************

--*******************************************
--cas 05 = cas 5 : tous les dossiers projets - tous les metiers, toutes les directions fournisseur
-- si on veut choisir un projet, on doit obligatoirement choisir un dossiers projet. donc les autres cas ne sont pas réalistes
--******************

--*******************************************
--cas 6 : toutes les directions fournisseur d'un projet
CURSOR cur_6 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.metier = p_metier
	AND lb.icpi = p_icpi
	AND lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.arctype = 'T1'
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND lb.dpcode <> 70000
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
	;
--******************

--*******************************************
--cas 7 : tous les metiers
CURSOR cur_7 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.icpi = p_icpi
	AND lb.codsg in (select codsg from struct_info si
			where si.coddir = p_dirme)
	AND lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.dpcode <> 70000
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
        AND lb.arctype = 'T1'
	;
--******************

--*******************************************
--cas 8 : on a tous les parametres renseignes

	CURSOR cur_8 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE lb.metier = p_metier
	AND lb.icpi = p_icpi
	AND lb.codsg in (select codsg from struct_info si
			where si.coddir = p_dirme)
	AND lb.clicode=cm.clicode
	AND cm.clidir = p_dirmo
	AND lb.dpcode <> 70000
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND (RTRIM(lb.typproj)='1'
                    OR RTRIM(lb.typproj)='2'
                    OR RTRIM(lb.typproj)='3'
                    OR RTRIM(lb.typproj)='4')
        AND lb.arctype = 'T1'
	;

--******************

BEGIN

    -- recuperation de la date courante
	BEGIN
	 SELECT TO_NUMBER(TO_CHAR(datdebex,'YYYY')) INTO l_annee FROM datdebex;

     	 EXCEPTION
        WHEN OTHERS THEN
          raise_application_error( -20997, SQLERRM);
	END;

	l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);

-- on appelle un curseur en fonction des parametres passes
	BEGIN



    p_nbnotif := 0; -- PPM 58337 initialisation du compteur à 0



  --HPPM 58337 - Début : Ajout d'une nouvelle valeur "Tous" pour sélectionner tous les dossiers projets
  -- cas 01 : tous les dossiers projets - tous les projets - toutes les directions fournisseur - tous les metiers
		IF p_dpcode='TOUS' AND p_icpi='TOUS' AND p_dirme='TOUS' AND p_metier='TOUS'
		THEN
			begin

				begin
        		OPEN cur_01;
         		FETCH cur_01 INTO l_num_vide;
         		l_bool_vide := cur_01%NOTFOUND;
        	CLOSE cur_01;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_01 LOOP
         -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		BEGIN
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		EXCEPTION
            	WHEN NO_DATA_FOUND THEN
	      		pack_global.recuperer_message(20508, '%s1', '', NULL, msg);
          		raise_application_error(-20508, msg);
          		p_message:=msg;
	        WHEN OTHERS THEN
                	raise_application_error( -20997, SQLERRM);
		END;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin
       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN


      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin
		END LOOP;
		end;



    	--cas 02 : tous les dossiers projets - tous les projets - toutes les directions fournisseur
	ELSIF p_dpcode='TOUS' AND p_icpi='TOUS' AND p_dirme='TOUS' THEN
		begin

			begin
        		OPEN cur_02;
         	FETCH cur_02 INTO l_num_vide;
         	l_bool_vide := cur_02%NOTFOUND;
        	CLOSE cur_02;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_02 LOOP
         -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		COMMIT;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime = 0)
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin
       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN

      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin
		END LOOP;
		end;


	--cas 03 : tous les dossiers projets - tous les projets - tous les metiers
	ELSIF p_dpcode='TOUS' AND p_icpi='TOUS' AND p_metier='TOUS' THEN
		begin

			begin
        		OPEN cur_03;
         	FETCH cur_03 INTO l_num_vide;
         	l_bool_vide := cur_03%NOTFOUND;
        	CLOSE cur_03;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_03 LOOP
  -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		COMMIT;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime = 0)
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin
       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN
      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin
		END LOOP;
		end;

	--cas 04 : tous les dossiers projets - tous les projets (donc on se base sur le dossier projet pour faire la selection)
	ELSIF p_dpcode='TOUS' AND p_icpi='TOUS'  THEN
		begin

			begin
        		OPEN cur_04;
         	FETCH cur_04 INTO l_num_vide;
         	l_bool_vide := cur_04%NOTFOUND;
        	CLOSE cur_04;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_04 LOOP
         -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		COMMIT;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime = 0)
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin
       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN

      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin
		END LOOP;
		end;
   --HPPM 58337 - Fin
		-- cas 1 : tous les projets - toutes les directions fournisseur - tous les metiers
		ELSIF p_icpi='TOUS' AND p_dirme='TOUS' AND p_metier='TOUS' --HPPM 58337
		THEN
			begin

				begin
        		OPEN cur_1;
         		FETCH cur_1 INTO l_num_vide;
         		l_bool_vide := cur_1%NOTFOUND;
        	CLOSE cur_1;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_1 LOOP
     -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		BEGIN
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		EXCEPTION
            	WHEN NO_DATA_FOUND THEN
	      		pack_global.recuperer_message(20508, '%s1', '', NULL, msg);
          		raise_application_error(-20508, msg);
          		p_message:=msg;
	        WHEN OTHERS THEN
                	raise_application_error( -20997, SQLERRM);
		END;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
       		COMMIT;
--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin

       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN

      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin

		END LOOP;
		end;


	--cas 2 : tous les projets - toutes les directions fournisseur
	ELSIF p_icpi='TOUS' AND p_dirme='TOUS' THEN --HPPM 58337
		begin

			begin
        		OPEN cur_2;
         	FETCH cur_2 INTO l_num_vide;
         	l_bool_vide := cur_2%NOTFOUND;
        	CLOSE cur_2;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_2 LOOP
         -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		COMMIT;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime = 0)
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin
       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN

      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin

		END LOOP;
		end;

	--cas 3 : tous les projets - tous les metiers
	ELSIF p_icpi='TOUS' AND p_metier='TOUS' THEN --HPPM 58337
		begin

			begin
        		OPEN cur_3;
         	FETCH cur_3 INTO l_num_vide;
         	l_bool_vide := cur_3%NOTFOUND;
        	CLOSE cur_3;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_3 LOOP
         -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		COMMIT;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime = 0)
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin
       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN

      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin
		END LOOP;
		end;

	--cas 4 : tous les projets (donc on se base sur le dossier projet pour faire la selection)
	ELSIF p_icpi='TOUS'  THEN --HPPM 58337
		begin

			begin
        		OPEN cur_4;
         	FETCH cur_4 INTO l_num_vide;
         	l_bool_vide := cur_4%NOTFOUND;
        	CLOSE cur_4;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_4 LOOP
         -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		COMMIT;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime = 0)
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin
       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN

      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin
		END LOOP;
		end;

	--cas 5 : tous les metiers, toutes les directions fournisseur
	ELSIF p_icpi <>'TOUS' AND p_dirme='TOUS' AND p_metier='TOUS' THEN --HPPM 58337
		begin

			begin
        		OPEN cur_5;
         	FETCH cur_5 INTO l_num_vide;
         	l_bool_vide := cur_5%NOTFOUND;
        	CLOSE cur_5;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_5 LOOP
         -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		COMMIT;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime= 0)
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin


       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN


      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin

		END LOOP;
		end;

	--cas 6 : toutes les directions fournisseur d'un projet
		ELSIF p_icpi <> 'TOUS' AND p_dirme='TOUS' AND p_metier <> 'TOUS' THEN --HPPM 58337
		begin

			begin
        		OPEN cur_6;
         	FETCH cur_6 INTO l_num_vide;
         	l_bool_vide := cur_6%NOTFOUND;
        	CLOSE cur_6;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_6 LOOP
         -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		COMMIT;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin


       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN


      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin

		END LOOP;
		end;

	--cas 7 : tous les metiers d'un projet
		ELSIF p_icpi <>'TOUS' AND p_metier='TOUS' THEN --HPPM 58337
		begin
			begin
        		OPEN cur_7;
         	FETCH cur_7 INTO l_num_vide;
         	l_bool_vide := cur_7%NOTFOUND;
        	CLOSE cur_7;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;
		FOR curseur IN cur_7 LOOP
         -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		COMMIT;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin


       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN


      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin

		END LOOP;
		end;

	--cas 8 : on a tous les parametres renseignes
	ELSE
		begin

	begin
        OPEN cur_8;
         FETCH cur_8 INTO l_num_vide;
         l_bool_vide := cur_8%NOTFOUND;
        CLOSE cur_8;
        IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        end;

	FOR curseur IN cur_8 LOOP
       -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		begin


		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;


		END;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
       		COMMIT;


--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin



       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,DPCODE,ICPI,METIER,DIR_ME,DIR_MO,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_dpcode,p_icpi,p_metier,p_dirme,p_dirmo,'Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN




      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin
	END LOOP;
		end;
	END IF;

pack_global.recuperer_message(21029,NULL,NULL, NULL, msg);
p_message := msg;

END;

END initbdg_grand_projet;


-- notification hors grands projets
PROCEDURE initbdg_hors_grand_projet (p_typeprojet	IN VARCHAR2,
				p_metier 	IN VARCHAR2,
				p_dirme 	IN VARCHAR2,
				p_dirmo_partie 	IN VARCHAR2,
				p_code_mo 	IN VARCHAR2,
				p_dirmo_entier 	IN VARCHAR2,
                               	p_userid       	IN VARCHAR2,
                               	p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2,
                                p_nbnotif OUT NUMBER)
                               	IS
-- variables locales

    msg 	VARCHAR(1024);
    l_annee 	NUMBER(4);                       -- annee courante
    l_jour 	DATE;                       -- jour de la modif
    l_user	VARCHAR2(35);
    l_bool_vide 	BOOLEAN;
    l_num_vide  VARCHAR2(4);
    l_budget_notifs BUDGET%ROWTYPE:=null;--PPM 58337 QC 1648
    l_budget_reestime BUDGET%ROWTYPE:=null;--PPM 58337 QC 1648
    l_nb_budg NUMBER:=-1;--PPM 58337 QC 1648
    l_nb_rees NUMBER:=-1;--PPM 58337 QC 1648


    exc_vide 	EXCEPTION;
    concurrence EXCEPTION;
    PRAGMA 	EXCEPTION_INIT (concurrence, -00054);

--*******************************************
--cas 1 : toutes les directions fournisseur - tous les metiers
CURSOR cur_1 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE INSTR(to_number(p_typeprojet),to_number(lb.typproj)) > 0
	AND lb.clicode=cm.clicode
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND cm.clidir = DECODE (nvl(p_dirmo_partie,'0'),'0',p_dirmo_entier,p_dirmo_partie)
	AND (nvl(p_code_mo,'0')= '0' OR cm.clicode = p_code_mo)
	AND lb.arctype <> 'T1'
	AND lb.dpcode <> 70000
	;

--*******************************************
--cas 2 : toutes les directions fournisseur
CURSOR cur_2 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE INSTR(to_number(p_typeprojet),to_number(lb.typproj)) > 0
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND lb.clicode=cm.clicode
	AND cm.clidir = DECODE (nvl(p_dirmo_partie,'0'),'0',p_dirmo_entier,p_dirmo_partie)
        AND (nvl(p_code_mo,'0')= '0' OR cm.clicode = p_code_mo)
	AND lb.metier = p_metier
	AND lb.arctype <> 'T1'
	AND lb.dpcode <> 70000
	;

--*******************************************
--cas 3 : tous les parametres definis
CURSOR cur_3 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE INSTR(to_number(p_typeprojet),to_number(lb.typproj)) > 0
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND lb.clicode=cm.clicode
	AND cm.clidir = DECODE (nvl(p_dirmo_partie,'0'),'0',p_dirmo_entier,p_dirmo_partie)
        AND (nvl(p_code_mo,'0')= '0' OR cm.clicode = p_code_mo)
	AND lb.metier = p_metier
	AND lb.codsg in (select codsg from struct_info si
			where si.coddir = p_dirme)
	AND lb.arctype <> 'T1'
	AND lb.dpcode <> 70000
	;

--*******************************************
--cas 4 : tous les metiers
CURSOR cur_4 IS
	SELECT 	lb.pid
	FROM ligne_bip lb,client_mo cm, datdebex d
	WHERE INSTR(to_number(p_typeprojet),to_number(lb.typproj)) > 0
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND lb.clicode=cm.clicode
	AND cm.clidir = DECODE (nvl(p_dirmo_partie,'0'),'0',p_dirmo_entier,p_dirmo_partie)
        AND (nvl(p_code_mo,'0')= '0' OR cm.clicode = p_code_mo)
	AND lb.codsg in (select codsg from struct_info si
			where si.coddir = p_dirme)
	AND lb.arctype <> 'T1'
	AND lb.dpcode <> 70000
	;

BEGIN

	-- recuperation de la date courante
	BEGIN
	 SELECT TO_NUMBER(TO_CHAR(datdebex,'YYYY')) INTO l_annee FROM datdebex;

     	 EXCEPTION
        WHEN OTHERS THEN
          raise_application_error( -20997, SQLERRM);
	END;

	l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);

-- on appelle un curseur en fonction des parametres passes
	BEGIN



    p_nbnotif := 0; -- PPM 58337 initialisation du compteur à 0

		-- cas 1 : tous les projets - toutes les directions fournisseur - tous les metiers
		IF p_dirme='TOUS' AND p_metier='TOUS' --HPPM 58337
		THEN
		BEGIN
		begin
        		OPEN cur_1;
         		FETCH cur_1 INTO l_num_vide;
         		l_bool_vide := cur_1%NOTFOUND;
        	CLOSE cur_1;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_1 LOOP
           -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		BEGIN
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		EXCEPTION
            	WHEN NO_DATA_FOUND THEN
	      		pack_global.recuperer_message(20508, '%s1', '', NULL, msg);
          		raise_application_error(-20508, msg);
	        WHEN OTHERS THEN
                	raise_application_error( -20997, SQLERRM);
		END;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin


       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,METIER,DIR_ME,DIR_MO,CLICODE,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_metier,p_dirme,p_dirmo_partie||p_dirmo_entier,p_code_mo,'Hors Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN


      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin


		END LOOP;
		end;

		-- cas 2 : toutes les directions fournisseur
	ELSIF p_dirme='TOUS' --HPPM 58337
		THEN
		BEGIN
			begin
        		OPEN cur_2;
         		FETCH cur_2 INTO l_num_vide;
         		l_bool_vide := cur_2%NOTFOUND;
        	CLOSE cur_2;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_2 LOOP
           -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		BEGIN
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		EXCEPTION
            	WHEN NO_DATA_FOUND THEN
	      		pack_global.recuperer_message(20508, '%s1', '', NULL, msg);
          		raise_application_error(-20508, msg);
	        WHEN OTHERS THEN
                	raise_application_error( -20997, SQLERRM);
		END;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin


       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,METIER,DIR_ME,DIR_MO,CLICODE,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_metier,p_dirme,p_dirmo_partie||p_dirmo_entier,p_code_mo,'Hors Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN


      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin


		END LOOP;
		end;

		-- cas 3 : tous les parametres renseignes
	ELSIF p_dirme <> 'TOUS' AND p_metier <> 'TOUS' --HPPM 58337
		THEN
		BEGIN
		begin
        	OPEN cur_3;
         	FETCH cur_3 INTO l_num_vide;
         		l_bool_vide := cur_3%NOTFOUND;
        	CLOSE cur_3;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_3 LOOP
           -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		BEGIN
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		EXCEPTION
            	WHEN NO_DATA_FOUND THEN
	      		pack_global.recuperer_message(20508, '%s1', '', NULL, msg);
          		raise_application_error(-20508, msg);
	        WHEN OTHERS THEN
                	raise_application_error( -20997, SQLERRM);
		END;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin


       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,METIER,DIR_ME,DIR_MO,CLICODE,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_metier,p_dirme,p_dirmo_partie||p_dirmo_entier,p_code_mo,'Hors Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN


      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin

		END LOOP;
		end;

		-- cas 4 : tous les metiers
	ELSIF p_dirme <> 'TOUS' AND p_metier = 'TOUS' --HPPM 58337
		THEN
		BEGIN
		begin
        	OPEN cur_4;
         	FETCH cur_4 INTO l_num_vide;
         		l_bool_vide := cur_4%NOTFOUND;
        	CLOSE cur_4;
        	IF l_bool_vide THEN
          	raise exc_vide;
        	END IF;

      		EXCEPTION
        	WHEN exc_vide THEN
          	pack_global.recuperer_message(20508, '%s1', 'avec ces paramètres', NULL, msg);
          	raise_application_error(-20508, msg);

          	p_message:=msg;
        	end;

		FOR curseur IN cur_4 LOOP
           -- PPM-58337 QC 1648 : debut
     l_nb_budg:=1;
     l_nb_rees:=1;
          BEGIN
                SELECT * into l_budget_notifs from budget b
                WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_budg:=0;
          END;
          BEGIN
                SELECT * into l_budget_reestime from budget b
            		WHERE pid	= curseur.pid
                AND b.annee = l_annee
                AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
          EXCEPTION
        	WHEN NO_DATA_FOUND THEN
          	l_nb_rees:=0;
          END;

  -- PPM-58337 QC 1648 : Fin
		BEGIN
		UPDATE budget b SET
			bnmont	= bpmontmo,
	    		anmont	= bpmontmo,
	    		apmont	= bpmontmo
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
                AND b.bpmontmo IS NOT NULL
                AND b.bnmont IS NULL
                AND b.anmont IS NULL
                AND b.apmont IS NULL
                ;
       		EXCEPTION
            	WHEN NO_DATA_FOUND THEN
	      		pack_global.recuperer_message(20508, '%s1', '', NULL, msg);
          		raise_application_error(-20508, msg);
	        WHEN OTHERS THEN
                	raise_application_error( -20997, SQLERRM);
		END;

       		UPDATE budget b SET
			reestime = bpmontme
		WHERE pid	= curseur.pid
		AND b.annee = l_annee
		AND b.bpmontme IS NOT NULL
                AND ( b.reestime is null or b.reestime=0 )
                ;
       		COMMIT;

--PPM 58337 QC 1648 : debut
  IF (l_nb_budg > 0 AND (l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR l_budget_notifs.anmont||'Z' <> l_budget_notifs.bpmontmo||'Z' OR  l_budget_notifs.apmont||'Z' <> l_budget_notifs.bpmontmo||'Z'))
  OR (l_nb_rees >0 AND l_budget_reestime.reestime||'Z' <> l_budget_reestime.bpmontme||'Z')  THEN
        		begin


       			-- alimentation de la table de logs
		INSERT INTO NOTIFICATION_LOGS (NOTIFIE,REESTIME,PID,DATE_LOG,USER_LOG,METIER,DIR_ME,DIR_MO,CLICODE,TYPE_NOTIF)
		(SELECT distinct bpmontmo,bpmontme,pid,sysdate,l_user,p_metier,p_dirme,p_dirmo_partie||p_dirmo_entier,p_code_mo,'Hors Grand Projet' from budget
		where pid=curseur.pid
		and annee=l_annee)
		;
		EXCEPTION
        	WHEN OTHERS THEN
          	raise_application_error( -20997, SQLERRM);
          	end;

    --QC 1651 : compteur du notifié uniquement s'il a été mis à jour
    IF (l_nb_budg > 0 AND l_budget_notifs.bnmont||'Z' <> l_budget_notifs.bpmontmo||'Z') THEN


      p_nbnotif:= p_nbnotif+1; --PPM 58337 : compteur de nombre de lignes ayant leurs notifiés mis à jour
    END IF;
    END IF;
--PPM 58337 QC 1648 : Fin
		END LOOP;
		end;
	END IF;


pack_global.recuperer_message(21029,NULL,NULL, NULL, msg);
p_message := msg;

END;
END initbdg_hors_grand_projet;



-- notification pour les lignes de type 9
PROCEDURE initbdg_type_9 (	p_dirme 	IN VARCHAR2,
			     	p_userid       	IN VARCHAR2,
                               	p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2)
                               	IS
-- variables locales

    l_annee 	NUMBER(4);                  -- annee courante
    l_moismens  DATE ;						-- mois de la mensuelle
    l_notifie  NUMBER (12,2);               -- notifié à répartir
    l_codrep   RJH_TABREPART.CODREP%TYPE ;  -- table de répartition
    l_taux  NUMBER (6,5);

    exc_vide 	EXCEPTION;
    concurrence EXCEPTION;
    PRAGMA 	EXCEPTION_INIT (concurrence, -00054);

    -- Recherche la somme des notifiés de toutes les lignes d'origine
    -- qui pointent sur des tables de répartition actives
	CURSOR cur_origine IS
	SELECT SUM(nvl(bud.bnmont,0)) notifie ,
	rjh.codrep codrep
	FROM BUDGET bud , LIGNE_BIP lb , RJH_TABREPART rjh, datdebex d
	WHERE bud.annee = l_annee
    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
	AND lb.pid = bud.pid
	AND lb.typproj != 9
	AND lb.codrep = rjh.codrep
	AND rjh.coddir = p_dirme
	AND rjh.flagactif = 'O'
	GROUP BY rjh.codrep ;

    CURSOR cur_not IS
	SELECT distinct
	det.pid,
	det.tauxrep taux
	FROM RJH_TABREPART_DETAIL det, datdebex d, ligne_bip l
	WHERE det.codrep = l_codrep
    AND (l.ADATESTATUT is null OR TO_CHAR(l.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
    AND l.pid = det.pid
	AND det.typtab = 'P'
	AND det.moisrep = d.moismens
	;


	BEGIN

	-- recuperation de la date courante
	BEGIN
 	SELECT TO_NUMBER(TO_CHAR(datdebex,'YYYY')), moismens INTO l_annee,l_moismens FROM datdebex;

 	 	EXCEPTION
    	WHEN OTHERS THEN
      	raise_application_error( -20997, SQLERRM);
	END;

    -- Remet à zero tous les notifiés des lignes T9 de la direction
    UPDATE BUDGET
    SET  bnmont = 0, anmont = 0, apmont = 0, bpdate = sysdate, flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1)
    WHERE  pid IN ( SELECT pid FROM LIGNE_BIP lb, datdebex d
                    WHERE lb.typproj = 9
                    AND (lb.ADATESTATUT is null OR TO_CHAR(lb.ADATESTATUT,'YYYY') = TO_CHAR(d.datdebex,'YYYY'))
                    AND lb.codsg IN ( SELECT codsg FROM STRUCT_INFO
                    			   WHERE coddir = p_dirme
					           	 )
					)
	AND annee = l_annee
	;
    COMMIT;


	-- Boucle pour chaque table de répartition
	FOR origine IN cur_origine LOOP

		-- Sauve les valeurs de travail
		l_notifie := origine.notifie ;
		l_codrep  := origine.codrep ;

		-- boucle sur toutes les lignes de répartition de cette table
		FOR curseur IN cur_not LOOP
		BEGIN

			-- Met à jour le notifié , l'arbitré et l'arbitre proposé ( ne sert plus ?)
			-- On somme les valeurs car une ligne de type 9 appartient à plusieurs tables
			-- de répartition
			UPDATE BUDGET
			SET bnmont = bnmont + l_notifie * curseur.taux,
				anmont = anmont + l_notifie * curseur.taux,
				apmont = apmont + l_notifie * curseur.taux
			WHERE pid = curseur.pid
			AND annee = l_annee ;

		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			-- Si on n'a pas trouvé de budget - on crée la ligne
			INSERT INTO BUDGET (PID,ANNEE,BNMONT,ANMONT,APMONT,FLAGLOCK)
	        VALUES(curseur.pid,l_annee,(l_notifie * curseur.taux),(l_notifie * curseur.taux),(l_notifie * curseur.taux),0);
		END ;

		COMMIT;
		END LOOP ;

	END LOOP;

	COMMIT;


    EXCEPTION
		   WHEN OTHERS THEN
		        ROLLBACK;
	   		RAISE_APPLICATION_ERROR( -20997, SQLERRM);

END initbdg_type_9;

END pack_initbdg;
/


