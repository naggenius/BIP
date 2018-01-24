-- -----------------------------------------------------------------------------------------------
-- APPLICATION BIP
-- -----------------------------------------------------------------------------------------------
-- 
-- Ce package contient les procédures qui permettent le traitement de répartition des arbitrés
--
-- Crée        le 21/02/2006 par DDI
--
-- Modifié le 05/03/2007 par Emmanuel VINATIER : adaptation aux nouvelles regles de calcul (Fiche TD531) 
-- Modifié le 27/04/2007 par Emmanuel VINATIER : Modification des regles de calcul
-- Modifié le 03/05/2007 par DDI : Retours sur l'homologation du lot 6.2
-- Modifié le 04/05/2007 par DDI : Retours sur l'homologation du lot 6.2
-- Modifié le 09/05/2007 par DDI : Retours sur l'homologation du lot 6.2
-- Modifié le 11/05/2007 par DDI : Retours sur l'homologation du lot 6.2
--*************************************************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE Packbatch_Repartition_Arb AS

    -- -----------------------------------------------------------------------------------------------------------------
    -- Utilitaire : Traitement de répartition
    -- -----------------------------------------------------------------------------------------------------------------
   PROCEDURE ALIM_RJH( P_LOGDIR IN VARCHAR2 );

    -- -----------------------------------------------------------------------------------------------------------------
    -- Utilitaire : Traitement de répartition des arbitrés
    -- -----------------------------------------------------------------------------------------------------------------
   PROCEDURE REPART_ARB( P_HFILE IN UTL_FILE.FILE_TYPE );


END Packbatch_Repartition_Arb;
/
CREATE OR REPLACE PACKAGE BODY Packbatch_Repartition_Arb  AS

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

   L_PROCNAME  VARCHAR2(16) := 'ALIM_RJH_ARB';
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
    -- Alimentation des arbitrés dans la table BUDGET
    -- ------------------------------------------------------------------------------------------------------
		Packbatch_Repartition_Arb.REPART_ARB( L_HFILE );
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
   -- Alimentation des arbitrés dans la table BUDGET
   -- -------------------------------------------------------------------------------------------------------------
PROCEDURE REPART_ARB( P_HFILE IN UTL_FILE.FILE_TYPE ) IS

 L_STATEMENT	VARCHAR2(128);

 l_annee	INTEGER;
 l_date		DATE;
 l_moismens DATDEBEX.DATDEBEX%TYPE;
 l_mois		DATDEBEX.MOISMENS%TYPE;
 l_anmont	INTEGER;
 v_anmont	NUMBER(12,2);
 cpt1		INTEGER;

 consori	CONSOMME.CUSAG%TYPE; -- consomme origine
 arbori 	BUDGET.ANMONT%TYPE; -- arbitré origine
 rafori		NUMBER(12,2); -- reste a faire origine
 raf		NUMBER(12,2); -- reste a faire*
 dateR		DATE; -- Date ou cosomme > arbitre
 dd_flag	VARCHAR2(1);
 tauxR    RJH_TABREPART_DETAIL.TAUXREP%TYPE; -- taux au mois R
 reste		NUMBER(12,2); -- reste des consommé
 r_conso	NUMBER(12,2); -- Consomme jusqu'au mois R
 r_conso_ori NUMBER(12,2); -- Consomme de la ligne d'origine jusqu'au mois R.
 bool 		NUMBER(1); -- booleen
 total_arb  NUMBER(12,2);

--
--  Ramène les lignes BIP origine appartenant à la table de répartition
--
	CURSOR cur_ligne_ori(c_table_rep CHAR,
		   			   	 c_annee NUMBER
						 )IS
			SELECT lb.pid, nvl(b.anmont,0) arbori, nvl(c.cusag,0) consori
				 FROM CONSOMME c, BUDGET b, LIGNE_BIP lb
				 WHERE  c.pid=b.pid
				 	and lb.pid=c.pid
					and lb.codrep=c_table_rep
					and c.annee=c_annee
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
--		 and rt.codrep like 'N_CLB_0%';

--
--  Ramène toutes les lignes BIP appartenant à la table de répartition.
--
	CURSOR cur_ligne(c_table_rep CHAR,
		   			l_moismens DATDEBEX.MOISMENS%TYPE
		   						 ) IS
		SELECT	pid,
			nvl(tauxrep,0) tauxrep
		FROM RJH_TABREPART_DETAIL
		WHERE CODREP=c_table_rep
		and MOISREP=l_moismens
		and pid NOT IN (SELECT pid FROM RJH_TABREPART_DETAIL
					   		   	   WHERE MOISREP=ADD_MONTHS(l_moismens,+1)
								   and CODREP=c_table_rep);

--
--  Calcul le consomme pour chaque mois d'une ligne T9.
--
/*	CURSOR cur_rjh_conso(c_pid RJH_CONSOMME.PID%TYPE,
		   			     c_pid_origine RJH_CONSOMME.PID_ORIGINE%TYPE,
		   			     c_annee NUMBER)
						 IS
					   SELECT nvl(sum(r.consojh),0) consom, nvl(cdeb,'01/01/1901') cdeb
					   FROM RJH_CONSOMME r
					   WHERE r.pid=c_pid
					     and r.pid_origine=c_pid_origine
					   	 and TO_CHAR(CDEB,'YYYY')=l_annee
					   GROUP BY cdeb;
*/
--
--  Calcule le consomme pour chaque mois d'une ligne origine.
--
	CURSOR cur_rjh_conso_ori(c_pid_origine RJH_CONSOMME.PID_ORIGINE%TYPE,
		   			     c_annee NUMBER)
						 IS
					   SELECT nvl(sum(r.consojh),0) consom, nvl(cdeb,'01/01/1901') cdeb
					   FROM RJH_CONSOMME r
					   WHERE r.pid_origine=c_pid_origine
					   	 and TO_CHAR(CDEB,'YYYY')=l_annee
					   GROUP BY cdeb;

-- ------------------------------------------------------------------------------------------------------

 BEGIN
 -- Récupération de la date système et de l'année courante.
    SELECT SYSDATE INTO l_date FROM DUAL;
    SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'YYYY')),MOISMENS,DATDEBEX INTO l_annee,l_mois,l_moismens FROM DATDEBEX;
total_arb:=0;
-- Parcours tout les mois de janvier au mois de la mensuelle
WHILE l_moismens<= l_mois LOOP


 -- Remet à zéro tous les arbitrés des lignes T9 qui sont reparti pour le mois en cours.
    UPDATE BUDGET
    SET  anmont = 0, apdate = l_date, flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1)
    WHERE  pid IN ( SELECT lb.pid FROM LIGNE_BIP lb, RJH_TABREPART_DETAIL r
                    WHERE lb.typproj = 9
						  and lb.pid=r.pid
						  and r.MOISREP=l_moismens)
    AND annee=l_annee;
    COMMIT;

	L_STATEMENT:='Remise à zéro des arbitrés des lignes T9';
    Trclog.Trclog( P_HFILE, L_STATEMENT ||':-'||SQL%rowcount);

	 -- Boucle sur toutes les tables de répartition
 	L_STATEMENT := 'Boucle sur toutes les tables de répartitions';
	Trclog.Trclog( P_HFILE, L_STATEMENT );
	cpt1 := 0 ;

-- Boucle sur les tables de répartition.
	FOR curseur_tab IN cur_table LOOP
 		cpt1 := cpt1 + 1 ;

		L_STATEMENT := 'Code table de répartition = ' || curseur_tab.codrep;
		Trclog.Trclog( P_HFILE, L_STATEMENT );


		 -- On recupere les ligne BIP origine
		 FOR curseur_ligne_ori IN cur_ligne_ori(curseur_tab.codrep,l_annee) LOOP


		 -- calcul du reste a faire
		 rafori := 0;
		 rafori := curseur_ligne_ori.arbori - curseur_ligne_ori.consori;
		 
L_STATEMENT := 'Total arbitre reparti: ' || total_arb;
Trclog.Trclog( P_HFILE, L_STATEMENT );
total_arb:=0 ;
		 
L_STATEMENT := 'Ligne origine = ' || curseur_ligne_ori.pid || ' rafori: ' || rafori || ' arbori ' ||curseur_ligne_ori.arbori;
Trclog.Trclog( P_HFILE, L_STATEMENT );



			-- Boucle sur les lignes BIP de la table de répartition
	    	FOR curseur_ligne IN cur_ligne(curseur_tab.codrep,l_moismens) LOOP
		  	  		BEGIN

			/* si le RESTE A FAIRE  est positif*/
			IF (rafori>=0) THEN

			   v_anmont:=0;
			   
			   
/*			   FOR curseur_rjh_conso IN cur_rjh_conso(curseur_ligne.pid,curseur_ligne_ori.pid, l_annee)
			   	   LOOP
				   v_anmont:= v_anmont + curseur_rjh_conso.consom;
				   END LOOP;
*/

  				SELECT nvl(sum(r.consojh),0) consom into v_anmont
				FROM RJH_CONSOMME r
				WHERE r.pid = curseur_ligne.pid
				  and r.pid_origine = curseur_ligne_ori.pid
				  and TO_CHAR(CDEB,'YYYY') = l_annee;
				   
-- DDI : modif le 02/05/2007:
-- Il faut ajouter le Reste A faire QUE pour le mois de la mensuelle.
-- Cette modif est indispensable pour le cas ou une ligne disparait d'une table de répartition en cours d'année.
	 IF(l_moismens = l_mois ) THEN
				   v_anmont:=v_anmont + (rafori * curseur_ligne.tauxrep);
	 END IF;

			   ELSE IF(rafori<0) THEN
			   			IF(curseur_ligne_ori.arbori=0) THEN v_anmont:=0; END IF;

			   			IF(curseur_ligne_ori.arbori>0) THEN
						 /*  Dans ce cas on dois retrouver le mois J qui est le mois ou le consomme est supérieur a l'arbitré */

					  raf:=curseur_ligne_ori.arbori;
					  bool:=0;
						  FOR curseur_rjh_conso_ori IN cur_rjh_conso_ori(curseur_ligne_ori.pid, l_annee)
							LOOP
								BEGIN
								raf:=raf - curseur_rjh_conso_ori.consom;
								dd_flag := 'O';
								IF(raf<0 and bool=0) THEN
										 dateR:=curseur_rjh_conso_ori.cdeb;

										  IF (to_char(curseur_rjh_conso_ori.cdeb,'dd/mm')<>'01/01')THEN
										  	 dateR:=to_date(ADD_MONTHS(dateR,-1),'dd/mm/yyyy');
											 dd_flag := 'N';
										  END IF;
										  bool:=1;
			   					END IF;
								END;
							END LOOP;

							--calcul des consomme jusqu'a la date dateR.

							SELECT NVL(SUM(RJH_CONSOMME.consojh),0)
							INTO r_conso
							FROM RJH_CONSOMME
					  					WHERE RJH_CONSOMME.pid = curseur_ligne.pid
					                     AND RJH_CONSOMME.cdeb <= to_date(dateR)
										 AND RJH_CONSOMME.pid_origine = curseur_ligne_ori.pid;

-- Si dépassement dès le mois de janvier il faut passer dans le cas ou r_cinso = 0.
IF (dd_flag='O') THEN
r_conso := 0;
END IF;

							--calcul des consommes de la ligne d'origine jusqu'a la date dateR.

/*							SELECT NVL(SUM(cons_sstache_res_mois.cusag),0)
							INTO r_conso_ori
							FROM cons_sstache_res_mois
					  					WHERE cons_sstache_res_mois.pid = curseur_ligne_ori.pid
					                     AND cons_sstache_res_mois.cdeb <= to_date(dateR) ;
*/										 
							SELECT NVL(SUM(RJH_CONSOMME.CONSOJH),0)
							INTO r_conso_ori
							FROM RJH_CONSOMME
					  					WHERE RJH_CONSOMME.pid_origine = curseur_ligne_ori.pid
					                     AND RJH_CONSOMME.cdeb <= to_date(dateR) ;

L_STATEMENT := 'rafori < 0.  r_conso_ori: ' || r_conso_ori ||  ' dateR= ' || dateR;
Trclog.Trclog( P_HFILE, L_STATEMENT );
										 
							-- Si il n'y a pas de consomme a ventiler.
							 IF(r_conso=0) THEN
							 --Recherche du taux de repartition au mois dateR
							 SELECT tauxrep
							 INTO tauxR
							 FROM RJH_TABREPART_DETAIL
							 WHERE pid=curseur_ligne.pid
							  and moisrep=to_date(dateR)
							  and codrep=curseur_tab.codrep
							  and typtab = 'P';

							 v_anmont:=curseur_ligne_ori.arbori*tauxR;

							  ELSE
							  --Recherche du taux de repartition au mois dateR
							SELECT tauxrep
							INTO tauxR
							FROM RJH_TABREPART_DETAIL
							WHERE pid=curseur_ligne.pid
							 and moisrep=to_date(ADD_MONTHS(dateR,+1))
							 and codrep=curseur_tab.codrep
							 and typtab = 'P';

							  -- reste:=curseur_ligne_ori.consori - r_conso;
							  reste:=curseur_ligne_ori.arbori - r_conso_ori;

							  v_anmont:=r_conso + reste * tauxR;

							END IF;

--L_STATEMENT := 'RAF= ' || raf || ' r_conso= ' || r_conso || ' reste= ' || reste || ' tauxrep= ' || tauxR ||' dateR= ' || dateR;
--Trclog.Trclog( P_HFILE, L_STATEMENT );
						 END IF;
			   		END IF;
			END IF;

			--L_STATEMENT := 'INSERT - pid: ' || curseur_ligne.pid || ' arbitre: ' ||v_anmont ;
			--Trclog.Trclog( P_HFILE, L_STATEMENT );
			
			total_arb:=total_arb+v_anmont;
			-- Essaie d'insérer dans budget
			INSERT INTO BUDGET (
			 				  	 PID,
								 ANNEE,
								 ANMONT,
								 APDATE,
								 FLAGLOCK
								)
             		VALUES(
					     			curseur_ligne.pid,
								l_annee,
					 			v_anmont,
								l_date,
								0
								);

			EXCEPTION

            		WHEN VIOLATION_CONSTRAINT_UNIQUE THEN

			-- Fait la mise à jour dans budget en ajoutant les arbitrés aux arbitrés existants.

                    	UPDATE BUDGET
                    	SET  anmont =anmont + v_anmont, apdate = l_date, flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1)
                    	WHERE  pid = curseur_ligne.pid
						and annee=l_annee;

					WHEN NO_DATA_FOUND THEN
						L_STATEMENT := 'Pas de donnee pour cette ligne BIP: ' || curseur_ligne.pid;
						Trclog.Trclog( P_HFILE, L_STATEMENT );

		  				END;
		  COMMIT;				
		  END LOOP;-- Boucle sur les lignes BIP détails.
	
		END LOOP;-- Boucle les ligne BIP origine.
	
	END LOOP;-- Boucle sur les tables de répartition.

l_moismens:=ADD_MONTHS(l_moismens,+1);
COMMIT;
END LOOP; -- fin while sur les mois !

	Trclog.Trclog( P_HFILE, 'Nombre de table traitées pour les arbitrés : ' || cpt1 );

 END REPART_ARB;

END Packbatch_Repartition_Arb;
/
