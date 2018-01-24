-- -----------------------------------------------------------------------------------------------
-- APPLICATION BIP
-- -----------------------------------------------------------------------------------------------
-- 
-- Ce package contient les procédures qui permettent le traitement de répartition des proposées
--
-- Crée        le 05/03/2007 par Emmanuel VINATIER
--
-- Modifié le 27/04/2007 par Emmanuel VINATIER : Modification des regles de calculs
-- Modifié le 03/05/2007 par DDI : Retours sur l'homologation du lot 6.2  
-- Modifié le 09/05/2007 par DDI : Retours sur l'homologation du lot 6.2  
--*************************************************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE Packbatch_Repartition_Prop AS

    -- -----------------------------------------------------------------------------------------------------------------
    -- Utilitaire : Traitement de répartition
    -- -----------------------------------------------------------------------------------------------------------------
   PROCEDURE ALIM_RJH( P_LOGDIR IN VARCHAR2 );

    -- -----------------------------------------------------------------------------------------------------------------
    -- Utilitaire : Traitement de répartition des proposés
    -- -----------------------------------------------------------------------------------------------------------------
   PROCEDURE REPART_PROP( P_HFILE IN UTL_FILE.FILE_TYPE );

   PROCEDURE REPART_PROPN( P_HFILE IN UTL_FILE.FILE_TYPE );

END Packbatch_Repartition_Prop;
/
CREATE OR REPLACE PACKAGE BODY Packbatch_Repartition_Prop  AS

-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
PRAGMA EXCEPTION_INIT( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     NUMBER := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     NUMBER := -20001;   -- problème : erreur dans la gestion d'erreur !
ERR_FONCTIONNELLE_ID NUMBER := -20002;   -- pour provoquer erreur alors que Oracle OK
CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
VIOLATION_CONSTRAINT_UNIQUE EXCEPTION;          -- pour clause when
PRAGMA EXCEPTION_INIT( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère
PRAGMA EXCEPTION_INIT( VIOLATION_CONSTRAINT_UNIQUE, -00001 );


-- -----------------------------------------------------------------------------------------------------------------
-- Utilitaire : Traitement de répartition
-- -----------------------------------------------------------------------------------------------------------------

PROCEDURE ALIM_RJH( P_LOGDIR IN VARCHAR2 ) IS

   L_PROCNAME  VARCHAR2(16) := 'ALIM_RJH_PROP';
   L_STATEMENT VARCHAR2(128);
   L_HFILE     UTL_FILE.FILE_TYPE;
   L_RETCOD    NUMBER;


BEGIN

    -----------------------------------------------------
    -- Init de la trace
    -----------------------------------------------------
		L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
		IF ( L_RETCOD <> 0 ) THEN
		RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
		                         'Erreur : Gestion du fichier LOG impossible',
		                         FALSE );
		END IF;
    -----------------------------------------------------
    -- Trace Start
    -----------------------------------------------------
		Trclog.Trclog( L_HFILE, 'Debut de ' || L_PROCNAME );
    -- ------------------------------------------------------------------------------------------------------
    -- Alimentation des proposes dans la table BUDGET pour l'anne N et N+1
    -- ------------------------------------------------------------------------------------------------------
		Packbatch_Repartition_Prop.REPART_PROP( L_HFILE );
		Packbatch_Repartition_Prop.REPART_PROPN( L_HFILE );
    -- ------------------------------------------------------------------------------------------------------

    Trclog.Trclog( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME);

EXCEPTION
	WHEN OTHERS THEN
	    ROLLBACK;
		IF SQLCODE <> CALLEE_FAILED_ID THEN
				Trclog.Trclog( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		END IF;
		Trclog.Trclog( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		RAISE CALLEE_FAILED;


END ALIM_RJH;

-- ----------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------

   -- -------------------------------------------------------------------------------------------------------------
   -- Alimentation des Proposé pour l'année N dans la table BUDGET
   -- -------------------------------------------------------------------------------------------------------------
PROCEDURE REPART_PROP( P_HFILE IN UTL_FILE.FILE_TYPE ) IS

 L_STATEMENT	VARCHAR2(128);


 l_annee	INTEGER;
 l_date		DATE;
 l_moismens DATDEBEX.DATDEBEX%TYPE;
 l_mois		DATDEBEX.MOISMENS%TYPE;
 cpt1		INTEGER;

propoMo	BUDGET.BPMONTMO%TYPE; -- consomme origine
propoMe BUDGET.BPMONTME%TYPE;

 
--
--  Ramène les lignes BIP origine appartenant à la table de répartition
--
	CURSOR cur_ligne_ori(c_table_rep CHAR,
		   			   	 c_annee NUMBER
						 )IS
			SELECT lb.pid, nvl(b.bpmontmo,0) propoMo ,nvl(b.bpmontme,0) propoMe
				 FROM BUDGET b, LIGNE_BIP lb
				 WHERE lb.pid=b.pid
					and lb.codrep=c_table_rep
					and b.annee=c_annee; 
 
--
--  Ramène toutes les tables de repartition qui sont de type ARBITRE.
--
	CURSOR cur_table IS
		SELECT DISTINCT rt.codrep
		FROM RJH_TABREPART_DETAIL rtd, RJH_TABREPART rt
		WHERE rt.codrep = rtd.codrep
		 and rtd.moisrep=l_moismens
		 and rt.codrep!='A_RENSEIGNER';
--		AND rtd.typtab = 'A'

--
--  Ramène toutes les lignes BIP appartenant à la table de répartition de type 'A'.
--
	CURSOR cur_ligne(c_table_rep CHAR,
		   			l_moismens DATDEBEX.MOISMENS%TYPE
		   						 ) IS
		SELECT	pid,
			nvl(tauxrep,0) tauxrep
		FROM RJH_TABREPART_DETAIL
		WHERE CODREP=c_table_rep
		and MOISREP=l_moismens;
--		AND TYPTAB='A'



-- ------------------------------------------------------------------------------------------------------

 BEGIN
 -- Récupération de la date système et de l'année courante.
    SELECT SYSDATE INTO l_date FROM DUAL;
    SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'YYYY')),MOISMENS,DATDEBEX INTO l_annee,l_mois,l_moismens FROM DATDEBEX;

-- Parcours tout les mois de janvier au mois de la mensuelle	
WHILE l_moismens<= l_mois LOOP
 -- Remet à zéro tous les arbitrés des lignes T9 qui sont reparti pour le mois en cours.
    UPDATE BUDGET
    SET  bpmontmo=0, bpmontme=0, apdate = l_date, flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1)
    WHERE  pid IN ( SELECT lb.pid FROM LIGNE_BIP lb, RJH_TABREPART_DETAIL r
                    WHERE lb.typproj = 9
						  and lb.pid=r.pid
						  and r.MOISREP=l_moismens)
    AND annee=l_annee;
    COMMIT;

	L_STATEMENT:='1. Remise à zéro des arbitrés des lignes T9 pour le mois de ';
    Trclog.Trclog( P_HFILE, L_STATEMENT || l_moismens ||' :-'||SQL%rowcount);
	
	
	 -- Boucle sur toutes les tables de répartition
 	L_STATEMENT := '1. Boucle sur toutes les tables de répartitions';
	Trclog.Trclog( P_HFILE, L_STATEMENT );
	cpt1 := 0 ;

	FOR curseur_tab IN cur_table LOOP
 		cpt1 := cpt1 + 1 ;
-- Ne faire les MAJ que pour le mois de la mensuelle. 		
IF (l_moismens = l_mois ) THEN
		L_STATEMENT := '1. Code table de répartition = ' || curseur_tab.codrep;
		Trclog.Trclog( P_HFILE, L_STATEMENT );

		
		 -- On recupere les ligne BIP origine
		 FOR curseur_ligne_ori IN cur_ligne_ori(curseur_tab.codrep,l_annee) LOOP 
		 
		 	FOR curseur_ligne IN cur_ligne(curseur_tab.codrep,l_moismens) LOOP
		  	  BEGIN
propoMo:= 0;
propoMe:= 0;			  

			propoMo:= curseur_ligne_ori.propoMo * curseur_ligne.tauxrep;
			propoMe:= curseur_ligne_ori.propoMe * curseur_ligne.tauxrep;

			L_STATEMENT := '1. Insertion: PID= ' || curseur_ligne.pid || ' proposeMo= ' || propoMo|| ' proposeMe= ' || propoMe;
			Trclog.Trclog( P_HFILE, L_STATEMENT );
			-- Essaie d'insérer dans budget
			INSERT INTO BUDGET (
			 				  	 PID,
								 ANNEE,
								 BPMONTMO,
								 BPMONTME,
								 APDATE,
								 FLAGLOCK
								)
             		VALUES(
					     		curseur_ligne.pid,
								l_annee,
					 			propoMo,
								propoMe,
								l_date,
								0
								);
								

			EXCEPTION

            		WHEN VIOLATION_CONSTRAINT_UNIQUE THEN

                    	UPDATE BUDGET
                    	SET  bpmontmo=bpmontmo + propoMo, bpmontme=bpmontme + propoMe ,apdate = l_date, flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1)
                    	WHERE  pid = curseur_ligne.pid
						and annee=l_annee;

					WHEN NO_DATA_FOUND THEN
						L_STATEMENT := '1. Pas de donnee pour cette ligne BIP: ' || curseur_ligne.pid;
						Trclog.Trclog( P_HFILE, L_STATEMENT );
		  				END;

		  END LOOP;		
		END LOOP;
END IF;	-- Fin des mises à jour sur la mensuelle. 	
	END LOOP;
l_moismens:=ADD_MONTHS(l_moismens,+1);	
END LOOP; --fin while
	COMMIT;

	Trclog.Trclog( P_HFILE, '1. Nombre de table traitées pour les arbitrés : ' || cpt1 );


 END REPART_PROP;

   -- -------------------------------------------------------------------------------------------------------------
   -- Alimentation des Proposé pour l'année N+1 dans la table BUDGET
   -- -------------------------------------------------------------------------------------------------------------
PROCEDURE REPART_PROPN( P_HFILE IN UTL_FILE.FILE_TYPE ) IS

 L_STATEMENT	VARCHAR2(128);


 l_annee	INTEGER;
 l_date		DATE;
 l_moismens DATDEBEX.DATDEBEX%TYPE;
 l_mois		DATDEBEX.MOISMENS%TYPE;
 cpt1		INTEGER;

propoMo	BUDGET.BPMONTMO%TYPE; -- consomme origine
propoMe BUDGET.BPMONTME%TYPE;

 
--
--  Ramène les lignes BIP origine appartenant à la table de répartition
--
	CURSOR cur_ligne_ori(c_table_rep CHAR,
		   			   	 c_annee NUMBER
						 )IS
			SELECT lb.pid, nvl(b.bpmontmo,0) propoMo ,nvl(b.bpmontme,0) propoMe
				 FROM  BUDGET b, LIGNE_BIP lb
				 WHERE  lb.pid=b.pid
					and lb.codrep=c_table_rep
					and b.annee=c_annee; 
 
--
--  Ramène toutes les tables de repartition qui sont de type ARBITRE.
--
	CURSOR cur_table IS
		SELECT DISTINCT rt.codrep
		FROM RJH_TABREPART_DETAIL rtd, RJH_TABREPART rt
		WHERE rt.codrep = rtd.codrep
		 and rtd.moisrep=l_moismens
		 and rt.codrep!='A_RENSEIGNER';
--		AND rtd.typtab = 'A'

--
--  Ramène toutes les lignes BIP appartenant à la table de répartition de type 'A'.
--
	CURSOR cur_ligne(c_table_rep CHAR,
		   			l_moismens DATDEBEX.MOISMENS%TYPE
		   						 ) IS
		SELECT	pid,
			nvl(tauxrep,0) tauxrep
		FROM RJH_TABREPART_DETAIL
		WHERE CODREP=c_table_rep
		and MOISREP=l_moismens;
--		AND TYPTAB='A'



-- ------------------------------------------------------------------------------------------------------

 BEGIN
 -- Récupération de la date système et de l'année courante.
    SELECT SYSDATE INTO l_date FROM DUAL;
    SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'YYYY')),MOISMENS,DATDEBEX INTO l_annee,l_mois,l_moismens FROM DATDEBEX;

	l_annee:=l_annee+1;
-- Parcours tout les mois de janvier au mois de la mensuelle	
WHILE l_moismens<= l_mois LOOP
 -- Remet à zéro tous les arbitrés des lignes T9 qui sont reparti pour le mois en cours.
    UPDATE BUDGET
    SET  bpmontmo=0, bpmontme=0, apdate = l_date, flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1)
    WHERE  pid IN ( SELECT lb.pid FROM LIGNE_BIP lb, RJH_TABREPART_DETAIL r
                    WHERE lb.typproj = 9
						  and lb.pid=r.pid
						  and r.MOISREP=l_moismens)
    AND annee=l_annee;
    COMMIT;

	L_STATEMENT:='2. Remise à zéro des arbitrés des lignes T9';
    Trclog.Trclog( P_HFILE, L_STATEMENT ||':-'||SQL%rowcount);
	
	
	 -- Boucle sur toutes les tables de répartition
 	L_STATEMENT := '2. Boucle sur toutes les tables de répartitions';
	Trclog.Trclog( P_HFILE, L_STATEMENT );
	cpt1 := 0 ;

	FOR curseur_tab IN cur_table LOOP
 		cpt1 := cpt1 + 1 ;
-- Ne faire les MAJ que pour le mois de la mensuelle.
IF (l_moismens = l_mois ) THEN	
		L_STATEMENT := '2. Code table de répartition = ' || curseur_tab.codrep;
		Trclog.Trclog( P_HFILE, L_STATEMENT );

		
		 -- On recupere les ligne BIP origine
		 FOR curseur_ligne_ori IN cur_ligne_ori(curseur_tab.codrep,l_annee) LOOP 
		 
		 	FOR curseur_ligne IN cur_ligne(curseur_tab.codrep,l_moismens) LOOP
		  	  BEGIN
			  			  
propoMo:= 0;
propoMe:= 0;			  
		  			  
			propoMo:= curseur_ligne_ori.propoMo * curseur_ligne.tauxrep;
			propoMe:= curseur_ligne_ori.propoMe * curseur_ligne.tauxrep;

			L_STATEMENT := '2. Insertion: PID= ' || curseur_ligne.pid || ' proposeMo= ' || propoMo|| ' proposeMe= ' || propoMe;
			Trclog.Trclog( P_HFILE, L_STATEMENT );
			-- Essaie d'insérer dans budget
			INSERT INTO BUDGET (
			 				  	 PID,
								 ANNEE,
								 BPMONTMO,
								 BPMONTME,
								 APDATE,
								 FLAGLOCK
								)
             		VALUES(
					     		curseur_ligne.pid,
								l_annee,
					 			propoMo,
								propoMe,
								l_date,
								0
								);


			EXCEPTION

            		WHEN VIOLATION_CONSTRAINT_UNIQUE THEN

                    	UPDATE BUDGET
                    	SET  bpmontmo=bpmontmo + propoMo, bpmontme=bpmontme + propoMe ,apdate = l_date, flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1)
                    	WHERE  pid = curseur_ligne.pid
						and annee=l_annee;

					WHEN NO_DATA_FOUND THEN
						L_STATEMENT := '2. Pas de donnee pour cette ligne BIP: ' || curseur_ligne.pid;
						Trclog.Trclog( P_HFILE, L_STATEMENT );

		  				END;
		  END LOOP;		
		END LOOP;
END IF; -- Fin des mises à jour sur la mensuelle.
	END LOOP;
l_moismens:=ADD_MONTHS(l_moismens,+1);	
END LOOP; --fin while
	COMMIT;

	Trclog.Trclog( P_HFILE, '2. Nombre de table traitées pour les arbitrés : ' || cpt1 );


 END REPART_PROPN;

END Packbatch_Repartition_Prop;
/
