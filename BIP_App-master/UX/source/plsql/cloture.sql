-- Nom            : CLOTURE.SQL
-- Auteur         : Equipe SOPRA
-- Description    : Batch Annuel de cloture 2eme partie 
--		    supprimer les étapes, tâches, sous-tâches et consommés 
--                  des tables ETAPE, TACHE, CONS_SSTACHE_RES et CONS_SSTACHE_RES_MOIS, 
--                  et réinsère des données cumulées (etape, tache, ...) dans les tables
--                  ETAPE, TACHE, CONS_SSTACHE_RES et CONS_SSTACHE_RES_MOIS
-- Ordonnancement : Apres la mensuelle de decembre 
--
--************************************************************************************************
-- Quand      Qui  Quoi
-- -----      ---  ----------------------------------------------------------------------------
-- 01/02/2001 PHD  Ajout des nouvelles ss-taches DEMENA, RTT, PARTIE 
-- 16/01/2006 PPR  Troncate de la table RESSOURCE_ECART 
--************************************************************************************************


CREATE OR REPLACE PACKAGE pack_batch_cloture AS
  
PROCEDURE cloture (p_logdir in varchar2);

--
-- Procedure de suppression des structures
--
PROCEDURE archive_structure (p_logdir in varchar2);

END pack_batch_cloture;
/


CREATE OR REPLACE PACKAGE BODY pack_batch_cloture  AS 
-- ---------------------------------------------------

	CALLEE_FAILED exception;
	pragma exception_init( CALLEE_FAILED, -20000 );
	CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
	TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
	ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
	CONSTRAINT_VIOLATION exception;          -- pour clause when
	pragma exception_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère

PROCEDURE cloture(p_logdir IN VARCHAR2)
IS

l_retcod	number;
l_procname 	varchar2(16) := 'CLOTURE';
l_statement	varchar2(64);
l_hfile	utl_file.file_type;
nblig		varchar2(200);
l_datdebex date;

BEGIN


-- Init de la trace
-- ----------------
L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
if ( L_RETCOD <> 0 ) then
	raise_application_error( TRCLOG_FAILED_ID,'Erreur : Gestion du fichier LOG impossible',false );
end if;

-- Trace Start
-- -----------
TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

--SELECT trunc(sysdate,'YEAR') INTO l_datdebex from dual ;
UPDATE DATDEBEX SET DATDEBEX = TRUNC(ADD_MONTHS(datdebex,12),'YEAR') ;

TRCLOG.TRCLOG( l_hfile, 'Mise à jour Date Exercice DATDEBEX : ' || to_char(l_datdebex,'DD/MM/YYYY') );


L_STATEMENT := 'Maj de Ligne_bip';
-- MAZ des colonnes PREESANCOU, PCCONSN1
-- -------------------------------------

UPDATE ligne_bip set pconsn1 = 0;

TRCLOG.TRCLOG( L_HFILE, L_STATEMENT ||'-'||sql%rowcount);
commit;

-- vide RESSOURCE_ECART
PACKBATCH.DYNA_TRUNCATE('RESSOURCE_ECART');
	   
TRCLOG.TRCLOG( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME );
	
-- Trace Stop
-- ----------
TRCLOG.CLOSETRCLOG( L_HFILE );

EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		If  sqlcode <> -20001 and
	         	sqlcode <>  -20101 and 
			sqlcode <>  -20102 and 
			sqlcode <>  -20103 then
		   	TRCLOG.TRCLOG( l_hfile, l_procname ||' : '|| SQLERRM );
	     	end if;
	     	if sqlcode <> -20001 then
		  	TRCLOG.TRCLOG( l_hfile, 'Fin ANORMALE de ' || L_PROCNAME  );
		  	TRCLOG.CLOSETRCLOG( l_hfile );
		  	raise_application_error(-20000,
					 'Erreur : consulter le fichier LOG',false );
	     	else
		  	raise;
	     	end if;

END cloture;


PROCEDURE archive_structure (p_logdir IN VARCHAR2) IS

l_retcod	number;
l_procname 	varchar2(17) := 'ARCHIVE_STRUCTURE';
l_statement	varchar2(64);
l_hfile	utl_file.file_type;
nblig		varchar2(200);
l_datdebex date;
l_compteur number :=0;

BEGIN


-- Init de la trace
-- ----------------
L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
if ( L_RETCOD <> 0 ) then
	raise_application_error( TRCLOG_FAILED_ID,'Erreur : Gestion du fichier LOG impossible',false );
end if;

-- Trace Start
-- -----------
TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

SELECT datdebex INTO l_datdebex
FROM datdebex;

	--
	-- On supprime tous les consommes de cons_sstache_res_mois_archive qui pourrait etre sur
	-- l'anne suivante
	--
	BEGIN

		TRCLOG.TRCLOG( L_HFILE, 'Suppression des lignes dans cons_sstache_res_mois_archive');

		DELETE cons_sstache_res_mois_archive
		WHERE cdeb>=l_datdebex;

		IF SQL%NOTFOUND THEN
			TRCLOG.TRCLOG( L_HFILE, 'Pas d enregistrements pour posterieur à: '||l_datdebex);
		END IF;
		
		COMMIT;

	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			TRCLOG.TRCLOG( L_HFILE, 'Pas de donnees archivees sur l annee prochaine');
	END;


	DECLARE
		CURSOR c_archive IS
			SELECT c.pid,c.ecet,c.acta,c.acst,c.cdeb,c.ident,c.cusag,c.cdur,c.chraf,c.chinit,t.aist,t.asnom 
			FROM tache t, cons_sstache_res_mois c
			WHERE c.pid=t.pid
			AND c.ecet=t.ecet
			AND c.acta=t.acta
			AND c.acst=t.acst
			AND c.cdeb>=l_datdebex;
	
	BEGIN

		TRCLOG.TRCLOG( L_HFILE, 'Insertion dans la table archive');


			FOR one_archive IN c_archive LOOP

			--
			-- On sauvegarde la structure dans la table cons_sstache_res_mois_archive avant de la supprimer
			--
				INSERT INTO cons_sstache_res_mois_archive(pid,ecet,acta,acst,cdeb,ident,cusag,cdur,chraf,chinit,aist,asnom)
				VALUES (one_archive.pid,
				one_archive.ecet,
				one_archive.acta,
				one_archive.acst,
				one_archive.cdeb,
				one_archive.ident,
				one_archive.cusag,
				one_archive.cdur,
				one_archive.chraf,
				one_archive.chinit,
				one_archive.aist,
				one_archive.asnom)
				;

				l_compteur:= l_compteur+1;
				IF l_compteur=500 THEN
					COMMIT;
					l_compteur:=0;
				END IF;


			END LOOP;


			-- On supprime tous les enregistrements dans cons_sstache_res_mois
			-- Le but est de ne pas conserver la structure des lignes d'une annee sur l'autre
			-- Lors du traitement mensuel, on ne supprime que les elements inexistants l'annee precedente...
			-- C'est pourquoi, il ne faut pas laisser de consommes....

			TRCLOG.TRCLOG( L_HFILE, 'Suppression des lignes dans cons_sstache_res_mois');
		
			DELETE cons_sstache_res_mois;	

			COMMIT;

		EXCEPTION
	
			WHEN CONSTRAINT_VIOLATION THEN
				TRCLOG.TRCLOG( L_HFILE, 'Erreur dans la sauvegarde des structures ' || SQLERRM);
				
		END;


TRCLOG.TRCLOG( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME );
	
-- Trace Stop
-- ----------
TRCLOG.CLOSETRCLOG( L_HFILE );


EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
--		If  sqlcode <> -20001 and
--	         	sqlcode <>  -20101 and 
--			sqlcode <>  -20102 and 
--			sqlcode <>  -20103 then
		   	TRCLOG.TRCLOG( l_hfile, l_procname ||' : '|| SQLERRM );
--	     	end if;
--	     	if sqlcode <> -20001 then
		  	TRCLOG.TRCLOG( l_hfile, 'Fin ANORMALE de ' || L_PROCNAME  );
		  	TRCLOG.CLOSETRCLOG( l_hfile );
--		  	raise_application_error(-20000,
--					 'Erreur : consulter le fichier LOG',false );
--	     	else
--		  	raise;
--	     	end if;

END archive_structure;

END pack_batch_cloture;
/
