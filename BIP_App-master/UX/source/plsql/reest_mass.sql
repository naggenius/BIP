-- pack_proposes_mass PL/SQL
-- 
-- Créé le 23/08/2004 par PJO
--
-- Modifié le 16/06/2005 par JMA : ajout filtre client et application
-- Le 05/12/2005 par BAA  : Fiche 299 : LOG Ligne BIP - nouvelles zone à surveiller arbitre et réestime
-- 11/06/2007 JAL : Fiche 556 exclusion lignes BIP type 9
-- 27/08/2009   YNA: TD 822 (lot 7.3) trace des modifications des budgets
-- 01/09/2009   YNA: TD 822 (lot 7.3) trace des modifications des budgets
-- 28/09/2009   ABA: TD 822 (lot 7.3) trace des modifications des budgets
--*******************************************************************
-- 01/12/2011 BSA QC 1281 
-- 24/04/2012   RBO : HPPM 31739 (pour livraison 8.4) Enrichissement traçabilité du Réeestimé et d'Arbitré

CREATE OR REPLACE PACKAGE Pack_Reestimes_Mass AS

FUNCTION str_reestimes 		(p_string     IN  CLOB,
                           	 p_occurence  IN  NUMBER
                          	 ) RETURN VARCHAR2;

PROCEDURE select_reest_mass  	 (	p_codsg		IN  VARCHAR2,
   							 	 	p_clicode    IN VARCHAR2,
   									p_airt       IN VARCHAR2,
                               		p_userid       	IN  VARCHAR2,
                               		p_libcodsg	OUT STRUCT_INFO.libdsg%TYPE,
                               		p_libclicode OUT CLIENT_MO.clisigle%TYPE,
                               		p_libairt	 OUT APPLICATION.alibel%TYPE,
                               		p_nbpages	OUT VARCHAR2,
                               		p_numpage 	OUT VARCHAR2,
                               		p_nbcurseur	OUT INTEGER,
                               		p_message	OUT VARCHAR2
                             		 );

PROCEDURE update_reest_mass(  p_string    IN  VARCHAR2,
                              p_userid    IN  VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             );
END Pack_Reestimes_Mass;
/


CREATE OR REPLACE PACKAGE BODY     Pack_Reestimes_Mass AS


     -- Découpage de la chaine récupérée 
   FUNCTION str_reestimes (p_string     IN  CLOB,--VARCHAR2,
                           p_occurence  IN  NUMBER
                          ) RETURN VARCHAR2 IS
   pos1 NUMBER(6);
   pos2 NUMBER(6);
   str  VARCHAR2(4000);

   BEGIN

      -- indice de la p_occurence ème occurence de ';'
      -- renvoie 0 si non trouvé
      pos1 := INSTR(p_string,'§',1,p_occurence);
      pos2 := INSTR(p_string,'§',1,p_occurence+1);

      IF pos2 != 1 THEN
         str := SUBSTR( p_string, pos1+1, pos2-pos1-1);
         RETURN str;
      ELSE
         RETURN 1;
      END IF;

   END str_reestimes;


PROCEDURE select_reest_mass  (		p_codsg		IN VARCHAR2,
   							 		p_clicode    IN VARCHAR2,
   									p_airt       IN VARCHAR2,
                               		p_userid       	IN VARCHAR2,
                               		p_libcodsg	OUT STRUCT_INFO.libdsg%TYPE,
                               		p_libclicode OUT CLIENT_MO.clisigle%TYPE,
                               		p_libairt	 OUT APPLICATION.alibel%TYPE,
                               		p_nbpages	OUT VARCHAR2,
                               		p_numpage 	OUT VARCHAR2,
                               		p_nbcurseur	OUT INTEGER,
                               		p_message	OUT VARCHAR2
                              		) IS

      NB_LIGNES_MAXI 	NUMBER(4);
      NB_LIGNES_PAGES   NUMBER(2);
      l_msg	VARCHAR2(1024);
      l_nbpages	NUMBER(5);
      l_habilitation	VARCHAR2(10);
      l_codsg	VARCHAR2(10);
      l_perime	VARCHAR2(1000);
      l_annee	NUMBER(4);



      BEGIN
      -- Nombres de lignes BIP retournées Maxis :
      NB_LIGNES_MAXI := 500;
      -- Nombre de lignes BIP maxi par pages
      NB_LIGNES_PAGES := 10;

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur := 1;
      p_message := '';

      -- Récupérer les périmètres de l'utilisateur
      l_perime := Pack_Global.lire_globaldata(p_userid).perime ;

      p_numpage := 'NumPage#1';



      -- ===================================================================
      -- Test existence et appartenance du DPG au périmètre de l'utilisateur
      -- ===================================================================
      	IF (p_codsg IS NOT NULL) AND (p_codsg != '*******') THEN
   		Pack_Habilitation.verif_habili_me(p_codsg, p_userid ,l_msg);

        l_codsg := REPLACE(LPAD(p_codsg, 7, '0'),'*','%');


	END IF;



      -- =========================
      -- On récupère le lib du DPG
      -- =========================
      IF p_codsg IS NOT NULL THEN
      	IF p_codsg = '*******' THEN
      		p_libcodsg := 'Tout le Périmètre';
      	ELSE
      		-- On récupère le lib du DPG
      		BEGIN
                IF SUBSTR(LPAD(p_codsg, 7, '0'),2,6) = '******' OR SUBSTR(LPAD(p_codsg, 7, '0'),3,5) = '*****'
                        OR SUBSTR(LPAD(p_codsg, 7, '0'),5,3) = '*****' OR SUBSTR(LPAD(p_codsg, 7, '0'),7,1) = '*' THEN
                    p_libcodsg := p_codsg;
      			ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),4,4) = '****' THEN
    				SELECT sigdep INTO p_libcodsg FROM STRUCT_INFO
    				WHERE TO_CHAR(codsg, 'FM0000000') LIKE l_codsg AND topfer='O' AND ROWNUM < 2;
    			ELSIF SUBSTR(LPAD(p_codsg, 7, '0'),6,2) = '**' THEN
    				SELECT sigdep || '/' || sigpole INTO p_libcodsg FROM STRUCT_INFO
    				WHERE TO_CHAR(codsg, 'FM0000000') LIKE l_codsg AND topfer='O' AND ROWNUM < 2;
    			ELSE
    				SELECT libdsg INTO p_libcodsg FROM STRUCT_INFO
    				WHERE TO_CHAR(codsg, 'FM0000000') = p_codsg AND topfer='O' AND ROWNUM < 2;
    			END IF;

		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				Pack_Global.recuperer_message(20925, '%s1', p_codsg, 'codsg', l_msg);
	               		RAISE_APPLICATION_ERROR(-20925,l_msg);

			WHEN OTHERS THEN
	      			-- Message d'alerte Problème avec le libellé du DPG
	      			Pack_Global.recuperer_message(20738, '%s1', p_codsg, 'codsg', l_msg);
	               		RAISE_APPLICATION_ERROR(-20738,l_msg);
      		END;
      	END IF;
      END IF;


      IF p_clicode IS NOT NULL THEN
      	IF p_clicode = '*****' THEN
      		p_libclicode := 'Tout le Périmètre';
      	ELSE
      		-- On récupère le lib du clicode
      		p_libclicode := Pack_Utile3b.f_get_clisigle_climo(p_clicode);
      	END IF;
      END IF;


      IF (p_airt IS NULL) OR (p_airt='') THEN
   		  p_libairt := 'Tout le Périmètre';
      ELSE
      	  -- On récupère le lib de l'application
		  IF (Pack_Utile3b.f_verif_airt_application(p_airt)) THEN
			  BEGIN
			      SELECT alibel INTO p_libairt
				    FROM APPLICATION
				   WHERE airt = p_airt;
		      EXCEPTION
				  WHEN OTHERS THEN
				  	   p_libairt := '';
			  END;
		  ELSE
		  	  p_libairt := 'Code application inconnu';
          END IF;
      END IF;

      -- =======================================
      -- On récupère le nombre de lignes
      -- =======================================
	SELECT TO_NUMBER(TO_CHAR (DATDEBEX, 'YYYY'))
	INTO l_annee
	FROM DATDEBEX
	WHERE ROWNUM < 2;


      -- Si c'est un code ME = *******
      IF (p_codsg IS NOT NULL) AND (p_codsg = '*******') THEN
      	BEGIN
            -- Compte le nombre de lignes et test si on a des pid
             SELECT COUNT(*)
             INTO   l_nbpages
             FROM     LIGNE_BIP,CONSOMME conso,BUDGET budg,DATDEBEX, vue_dpg_perime vdp
             WHERE    conso.pid(+) = LIGNE_BIP.pid
	     AND      budg.pid(+) = LIGNE_BIP.pid
	     AND      conso.annee(+) = l_annee
	     AND      budg.annee(+) = l_annee
	     AND      ((LIGNE_BIP.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(LIGNE_BIP.adatestatut,'YYYY')) >= l_annee))
             AND       LIGNE_BIP.codsg = vdp.codsg
             AND       LIGNE_BIP.TYPPROJ != '9'
             AND       INSTR(l_perime, vdp.codbddpg) > 0;
	     -- inutile de tester SQL%NOTFOUND car fonction de groupe renvoie toujours soit NULL, soit une valeur

	     IF (l_nbpages = 0) THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);
             ELSIF (l_nbpages > NB_LIGNES_MAXI) THEN
               Pack_Global.recuperer_message( 20381 , '%s1', p_codsg, 'codsg', l_msg);
               RAISE_APPLICATION_ERROR(-20381 , l_msg);
             END IF;

             l_nbpages := CEIL(l_nbpages/NB_LIGNES_PAGES);
             p_nbpages := 'NbPages#'|| l_nbpages;
      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      	END;


     -- Si c'est un code ME != *******
     ELSIF (p_codsg IS NOT NULL) THEN
      	BEGIN
            -- Compte le nombre de lignes et test si on a des pid
             SELECT COUNT(*)
             INTO   l_nbpages
	     FROM     LIGNE_BIP lb, CONSOMME conso,BUDGET budg
             WHERE    conso.pid(+) = lb.pid
             AND      budg.pid(+) = lb.pid
             AND      lb.TYPPROJ != '9'
	     AND      conso.annee(+) = l_annee
	     AND      budg.annee(+) = l_annee
	     AND      TO_CHAR(lb.codsg, 'FM0000000') LIKE l_codsg
	     AND   ((lb.adatestatut IS NULL) OR (TO_NUMBER(TO_CHAR(lb.adatestatut,'YYYY')) >= l_annee))
		 ;
	     -- inutile de tester SQL%NOTFOUND car fonction de groupe renvoie toujours soit NULL, soit une valeur

	     IF (l_nbpages = 0) THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);
             ELSIF (l_nbpages > NB_LIGNES_MAXI) THEN
               Pack_Global.recuperer_message( 20381 , '%s1', p_codsg, 'codsg', l_msg);
               RAISE_APPLICATION_ERROR(-20381 , l_msg);
             END IF;

             l_nbpages := CEIL(l_nbpages/NB_LIGNES_PAGES);
             p_nbpages := 'NbPages#'|| l_nbpages;
      	EXCEPTION
           WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message( 20373 , '%s1', p_codsg, 'codsg', l_msg);
               RAISE_APPLICATION_ERROR(-20373 , l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      	END;
     END IF;

     p_message := l_msg;

  END select_reest_mass;


PROCEDURE update_reest_mass(	p_string    IN  VARCHAR2,
                              	p_userid    IN  VARCHAR2,
                              	p_nbcurseur OUT INTEGER,
                              	p_message   OUT VARCHAR2
                             ) IS

   l_msg    VARCHAR2(10000);
   l_cpt    NUMBER(7);
   l_reescomm_size INTEGER;

   l_pid    LIGNE_BIP.pid%TYPE;
   l_preesancou BUDGET.reestime%TYPE;
   l_flaglock   BUDGET.flaglock%TYPE;
   l_datdebex NUMBER(4);
   l_user		LIGNE_BIP_LOGS.user_log%TYPE;
   l_reestime   BUDGET.reestime%TYPE;
   l_redate 	BUDGET.redate%TYPE;
   l_ureestime 	BUDGET.ureestime% TYPE;
   l_tr_flag NUMBER;
   l_tr NUMBER;
    msg           	VARCHAR2(1024);
    
    LC$Requete      VARCHAR2(2048) ;
    
    old_reestime VARCHAR2(15);
    l_preesancouString VARCHAR2(15);
    l_reescomm BUDGET.reescomm%TYPE;
    l_old_reescomm BUDGET.reescomm%TYPE;

   BEGIN


      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message   := '';
      LC$Requete := '';
      l_cpt       := 1;
      l_reescomm_size := 200;

 l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);


	SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'YYYY')) INTO l_datdebex FROM DATDEBEX;

      WHILE l_cpt != 0 LOOP

         l_pid := Pack_Reestimes_Mass.str_reestimes(p_string,l_cpt);

         l_flaglock   := TO_NUMBER(Pack_Reestimes_Mass.str_reestimes(p_string,l_cpt+1));
       	 l_preesancou := to_number(Pack_Reestimes_Mass.str_reestimes(p_string,l_cpt+2),'FM999999999990D00');
         l_preesancouString := Pack_Reestimes_Mass.str_reestimes(p_string,l_cpt+2);
         l_reescomm := pack_gestbudg.recupererCommentaireReestime(Pack_Reestimes_Mass.str_reestimes(p_string,l_cpt+3),l_reescomm_size);

         IF l_pid != '0' THEN


		   SELECT COUNT(*) INTO l_tr
		     FROM BUDGET
             WHERE  pid = l_pid
			 AND annee = l_datdebex;

        -- Alimentation de l'ancien réestimé pour log
        IF  (l_tr!=0) THEN
			       SELECT reestime INTO l_reestime
		             FROM BUDGET
                    WHERE  pid = l_pid
			        AND annee = l_datdebex;
			   END IF;

        -- Alimentation de l'ancien réestimé / commentaire réestimé
         BEGIN
         --  select to_char(replace(to_char(reestime,'FM999999999990D00'),'.',',')),
          select to_char(reestime,'FM999999999990D00'),
                redate,
                reescomm 
            into old_reestime, l_redate, l_old_reescomm
            from budget
            where pid=l_pid
            and   annee = l_datdebex;
         EXCEPTION WHEN
         NO_DATA_FOUND then
            old_reestime := ' ';
            l_old_reescomm := ' ';
         END;

         -- Si un réestimé ou un commentaire différent de l'existant a été saisi     
         IF (nvl(old_reestime,' ') != nvl( l_preesancouString ,' ')) OR
           (nvl(l_old_reescomm,' ') != nvl(l_reescomm, ' ')) THEN
         
            LC$Requete := 'UPDATE BUDGET SET ';
            
            -- Si un réestimé différent de l'existant a été saisi     
            IF (nvl(old_reestime,' ') != nvl( l_preesancouString ,' ')) THEN
                 LC$Requete := LC$Requete || 
                 'reestime = ''' || l_preesancou || 
                 ''', redate  =  ''' || sysdate || 
                 ''', ureestime = ''' || l_user || 
                 ''', flaglock  = DECODE( ''' || l_flaglock || ''', 1000000, 0, ''' || (l_flaglock + 1) || ''')';
                
                -- Si un commentaire différent de l'existant a été saisi     
                IF (nvl(l_old_reescomm,' ') != nvl(l_reescomm, ' ')) THEN
                    LC$Requete := LC$Requete || ', ';
                END IF;
            END IF;
            
            -- Si un commentaire différent de l'existant a été saisi     
            IF (nvl(l_old_reescomm,' ') != nvl(l_reescomm, ' ')) THEN
                LC$Requete := LC$Requete || 'reescomm = ''' || pack_gestbudg.recupererCommentaireReestime(l_reescomm, l_reescomm_size) || '''';
            END IF;
            
            LC$Requete := LC$Requete || ' WHERE  pid = ''' || l_pid || ''' AND annee = ''' || l_datdebex || '''';

            EXECUTE IMMEDIATE LC$Requete;
            
         END IF;

      -- Cas de la création
	    IF (SQL%NOTFOUND) AND (l_preesancou>0) THEN
        --YNI
	    	INSERT INTO BUDGET (annee, reestime, flaglock, pid, redate, ureestime)
	    	VALUES (l_datdebex, to_number(l_preesancou,'FM999999999990D00'), 0 , l_pid, sysdate, l_user);

		              Pack_Ligne_Bip.maj_ligne_bip_logs(l_pid, l_user, 'Réestimé ' || l_datdebex, NULL, l_preesancou, 'Création en masse/Mes_lignes_réestimé');
                  --YNI
                  --Pack_Ligne_Bip.maj_ligne_bip_logs(l_pid, l_user, 'Date de modification du budget réestimé' || l_datdebex, null, sysdate, 'Saisie en masse/Mes_lignes_réestimé');
                  --Pack_Ligne_Bip.maj_ligne_bip_logs(l_pid, l_user, 'identifiant qui réalise l''opération sur le budget réestimé' || l_datdebex, null, l_user, 'Saisie en masse/Mes_lignes_réestimé');
                  --Fin YNI
     -- Cas de la mise à jour ou l_preesancou < 0 (cas métier non possible via l'IHM existante)
	   ELSE
	          --YNI
              --Pack_Ligne_Bip.maj_ligne_bip_logs(l_pid, l_user, 'Date de modification du budget réestimé' || l_datdebex, l_redate, sysdate, 'Saisie en masse/Mes_lignes_réestimé');
              --Pack_Ligne_Bip.maj_ligne_bip_logs(l_pid, l_user, 'identifiant qui réalise l''opération sur le budget réestimé' || l_datdebex, l_ureestime, l_user, 'Saisie en masse/Mes_lignes_réestimé');
              --Fin YNI
              
              -- Si un réestimé différent de l'existant a été saisi     
              IF (nvl(old_reestime,' ') != nvl( l_preesancouString ,' ')) THEN
			  
			  Pack_Ligne_Bip.maj_ligne_bip_logs(l_pid, l_user, 'Réestimé ' || l_datdebex,  l_reestime, l_preesancou, 'Modification en masse/Mes_lignes_réestimé');          
			  
                -- Historisation de l'ancienne valeur du réestimé                  
                pack_gestbudg.insert_budget_histo (1, 
                                    l_pid, 
                                    TO_NUMBER(l_datdebex), 
                                    TO_NUMBER(old_reestime),
                                    l_redate, 
                                    l_user, 
                                    pack_gestbudg.recupererCommentaireReestime(l_old_reescomm, l_reescomm_size));
                -- Suppression des historiques réestimé les plus anciens si plus de 5 historiques sont présents
                pack_gestbudg.delete_old_budget_histo(1, l_pid, TO_NUMBER(l_datdebex));
              END IF;
	    END IF;


            l_cpt := l_cpt + 4;

         ELSE
            l_cpt :=0;
         END IF;

      END LOOP;

     Pack_Global.recuperer_message( 20972 , '%s1', 'Réestimé', '', p_message);

   END update_reest_mass;

END Pack_Reestimes_Mass;
/


