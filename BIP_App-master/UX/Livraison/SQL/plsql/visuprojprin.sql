--
CREATE OR replace PACKAGE pack_visuprojprin IS 
-----------------------------------------


------------------------------------------------------------------------------
-- Constantes globales
------------------------------------------------------------------------------

CST_BUD_XXXX CONSTANT CHAR(4) := '';			-- Chane 'XXXX' affiche dans les tats PRODEC


------------------------------------------------------------------------------
-- Types et Curseurs
------------------------------------------------------------------------------


------------------------------------------------------------------------------
-- Les Fonctions 
------------------------------------------------------------------------------

-- ------------------------------------------------------------------------
   -- Nom        : tmp_visuprojprin_budget2
   -- Auteur     : MMC
   -- Decription : met a jour de la table tmp_visuprojprin  a partir des tables
   --              cons_sstache_res_mois,budget
   -- Paramtres : p_codsg (IN) codsg du projet
   --              p_pid1  (IN) identifiant ligne BIP
   --              p_pid2  (IN) identifiant ligne BIP
   --              p_pid3  (IN) identifiant ligne BIP
   --              p_pid4  (IN) identifiant ligne BIP
   --              p_pid5  (IN) identifiant ligne BIP
   --              p_pid6  (IN) identifiant ligne BIP
   --			 p_date_traite  (DATE) Date traite : En principe, Sysdate ou datedebex
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   -- 
   -- Modifi le 22/05/2006 par DDI : Passage du rstim sur 2 dcimales.
   -- Modifi le 22/05/2006 par DDI : Passage de tous les montants sur 2 dcimales.
   -- Modifi le 12/01/2010 par YSB : Changement du traitement pour qu'il affiche les caractristiques de toute les lignes (inclus les T7) 
   -- Modifi le 01/09/2014 par SEL : PPM 58986 : bascule FI en anne calendaire.
   -- ------------------------------------------------------------------------
   FUNCTION CF_LIB_AXE_CATLOGFORMULA(
    P_PARAM7              IN LIGNE_BIP.PID%TYPE,
    P_DPCOPIAXEMETIERCODE IN VARCHAR2,
    P_PROJAXEMETIERCODE   IN VARCHAR2)
  RETURN CHAR; 
  
   FUNCTION tmp_visuprojprin_budget2 (p_codsg IN ligne_bip.codsg%TYPE,
				 p_pid1  IN ligne_bip.pid%TYPE,
				 p_pid2  IN ligne_bip.pid%TYPE,
				 p_pid3  IN ligne_bip.pid%TYPE,
				 p_pid4  IN ligne_bip.pid%TYPE,
				 p_pid5  IN ligne_bip.pid%TYPE,
				 p_pid6  IN ligne_bip.pid%TYPE,
		             p_date_traite IN DATE) RETURN NUMBER;


------------------------------------------------------------------------------
-- Les Procdures 
------------------------------------------------------------------------------

   -- ------------------------------------------------------------------------
   -- Nom        : verif_projprin
   -- Auteur     : Equipe SOPRA
   -- Decription : Test les champs saisies dans la page WEB
   --              
   -- Paramtres : p_param6  (IN) codsg
   --              p_param7  (IN) code ligne bip
   --              p_param8  (IN) code ligne bip
   --              p_param9  (IN) code ligne bip
   --              p_param10 (IN) code ligne bip
   --              p_param11 (IN) code ligne bip
   --              p_param12 (IN) code ligne bip
   --              p_userid  (IN) donnee de l'utilisateur
   -- Retour     : p_message (OUT) message d'erreur
   --            
   -- Modif      : 20/01/2000 correction d'un bug dans le test de retour d'info
   --              dans le cas de la non saisie d'un codsg
   -- 	  PJOSSE : 14/08/2003 Ajout d'un test pour savoir si le DPG demand est clotur.
   -- ------------------------------------------------------------------------
   PROCEDURE verif_projprin (p_param6  IN VARCHAR2,
			     p_param7  IN ligne_bip.pid%TYPE,
			     p_param8  IN ligne_bip.pid%TYPE,
			     p_param9  IN ligne_bip.pid%TYPE,
			     p_param10 IN ligne_bip.pid%TYPE,
			     p_param11 IN ligne_bip.pid%TYPE,
			     p_param12 IN ligne_bip.pid%TYPE,
			     p_userid  IN  CHAR,
			     p_message OUT VARCHAR2
			    );


   
   -- ------------------------------------------------------------------------
   -- Nom        : verif_pid
   -- Auteur     : Equipe SOPRA
   -- Decription : Test les champs saisis dans la page WEB
   --              
   -- Paramtres : p_pid   (IN) code ligne_bip
   --              p_focus (IN) focus pour les pages WEB
   -- Retour     : 
   -- 
   -- ------------------------------------------------------------------------
   PROCEDURE verif_pid(p_pid     ligne_bip.pid%TYPE,
		       p_focus   VARCHAR2,
		       p_userid  IN  VARCHAR2);
   
END pack_visuprojprin;
/


CREATE OR replace PACKAGE BODY pack_visuprojprin IS 
----------------------------------------------

--****************************************************************************
-- Les Fonctions 
--****************************************************************************

-- ------------------------------------------------------------------------
   -- Nom        : tmp_visuprojprin_budget2
   -- Auteur     : MMC
   -- Decription : met a jour de la table tmp_visuprojprin a partir des tables
   --              cons_sstache_res_mois,budget
   -- Paramtres : p_codsg (IN) codsg du projet
   --              p_pid1  (IN) identifiant ligne BIP
   --              p_pid2  (IN) identifiant ligne BIP
   --              p_pid3  (IN) identifiant ligne BIP
   --              p_pid4  (IN) identifiant ligne BIP
   --              p_pid5  (IN) identifiant ligne BIP
   --              p_pid6  (IN) identifiant ligne BIP
   --			 p_date_traite  (DATE) Date traite : En principe, Sysdate ou datedebex
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --	           
   -- 
   -- ------------------------------------------------------------------------
   
FUNCTION CF_LIB_AXE_CATLOGFORMULA (P_PARAM7 in LIGNE_BIP.PID%TYPE, P_DPCOPIAXEMETIERCODE IN VARCHAR2,
P_PROJAXEMETIERCODE IN VARCHAR2) RETURN CHAR IS
P_LINEAXISBUSINESS2 LIGNE_BIP.LINEAXISBUSINESS2%TYPE;
L_TACHEAXEMETIER ISAC_TACHE.TACHEAXEMETIER%TYPE;
P_MESSAGE VARCHAR2(1000) := 'valid';
L_TACHEAXEMETIER_CNT NUMBER(9):= 0;
L_COUNTER NUMBER(9) := 0;
L_DIRECTION CLIENT_MO.CLIDIR%type; 
l_tmp number(9) := 0;
P_TEMP_CODER_VER VARCHAR2(1000);
BEGIN
    IF (P_DPCOPIAXEMETIERCODE IS NOT NULL OR P_PROJAXEMETIERCODE IS NOT NULL) THEN --1
  		RETURN('Axe p/Catalogue :');   
    ELSE
    	
    		BEGIN
    			SELECT LINEAXISBUSINESS2, TRIM(LPAD(TYPPROJ,3,'0'))||ARCTYPE INTO P_LINEAXISBUSINESS2, P_TEMP_CODER_VER FROM LIGNE_BIP L WHERE L.PID = P_PARAM7;
    		EXCEPTION
    			WHEN NO_DATA_FOUND THEN
    			P_LINEAXISBUSINESS2 := NULL;
    		END;
    		--DMP CHECK LINE -START
    	--	PACK_ISAC_ALIMENTATION.VERIFY_BIP_LIGNE_DMP_LINK(P_LINEAXISBUSINESS2,:P_PARAM7,P_MESSAGE,P_TYPE,P_PARAM_ID);
    			
			   	BEGIN
			      SELECT CMO.CLIDIR INTO L_DIRECTION FROM CLIENT_MO CMO, LIGNE_BIP LB WHERE LB.PID = P_PARAM7 AND LB.CLICODE = CMO.CLICODE;
			      
			      SELECT distinct 1 into l_tmp  
			         -- INTO L_CODE_ACTION, L_OBLIGATOIRE, L_VALEUR 
			          FROM LIGNE_PARAM_BIP 
			          WHERE CODE_ACTION = 'AXEMETIER_'||L_DIRECTION 
			          AND CODE_VERSION = 'LI2'||P_TEMP_CODER_VER
			          AND ACTIF = 'O';
			     
			      EXCEPTION
			      WHEN NO_DATA_FOUND 
			      THEN      
			          BEGIN
			           select SI.CODDIR into L_DIRECTION from STRUCT_INFO SI, LIGNE_BIP LB where LB.PID = P_PARAM7 and LB.CODSG = SI.CODSG;
			       
			            SELECT distinct 1 into l_tmp  
			            --INTO L_CODE_ACTION, L_OBLIGATOIRE, L_VALEUR 
			            FROM LIGNE_PARAM_BIP 
			            WHERE CODE_ACTION = 'AXEMETIER_'||L_DIRECTION 
			            AND CODE_VERSION = 'LI2'||P_TEMP_CODER_VER
			            AND ACTIF = 'O';           
			          EXCEPTION
			          WHEN NO_DATA_FOUND 
			          THEN 
			                P_MESSAGE := 'absence';                
			          END;          
			      END;
   
    	----DMP CHECK LINE -end	
    		IF P_MESSAGE = 'valid' --2
    			THEN
						--:CP_LIB_AXE_CATLOG_VAL := P_LINEAXISBUSINESS2;
						RETURN('Ref_demande : '||P_LINEAXISBUSINESS2);
    		ELSE
    			--DMP CHECK TACHE - STARTS
    			P_MESSAGE := 'valid';
						 BEGIN
						      select CMO.clidir into l_direction from client_mo CMO, ligne_bip LB where LB.pid = P_PARAM7 and LB.clicode = CMO.clicode;
						      
						      select distinct 1 into l_tmp   
						          --into l_code_action, l_obligatoire, l_valeur 
						          from ligne_param_bip 
						          where code_action = 'AXEMETIER_'||l_direction 
						          and code_version = 'TAC'||P_TEMP_CODER_VER
						          and actif = 'O';
						     
						      EXCEPTION
						      WHEN NO_DATA_FOUND 
						      THEN
						          BEGIN			
						           select SI.coddir into l_direction from struct_info SI, ligne_bip LB where LB.pid = P_PARAM7 and LB.codsg = SI.codsg;
						       
						            select distinct 1 into l_tmp   
						            --into l_code_action, l_obligatoire, l_valeur 
						            from ligne_param_bip 
						            where code_action = 'AXEMETIER_'||l_direction 
						            and code_version = 'TAC'||P_TEMP_CODER_VER
						            and actif = 'O';
						             
						          EXCEPTION
						          WHEN NO_DATA_FOUND 
						          THEN 
						                p_message := 'absence'; 			                
						          END;			          
						      END;
    			--DMP CHECK TACHE - ENDS
    				IF P_MESSAGE = 'valid' --3
    					THEN
    					BEGIN
    						SELECT COUNT(IT.TACHEAXEMETIER) INTO L_TACHEAXEMETIER_CNT
									FROM ISAC_TACHE IT
									WHERE IT.PID  = P_PARAM7
										GROUP BY IT.PID;
    					EXCEPTION
    						WHEN NO_DATA_FOUND THEN
    						L_TACHEAXEMETIER_CNT := 0;
    					END;
    					
    					IF L_TACHEAXEMETIER_CNT = 0 --4
    						THEN
    						--:CP_LIB_AXE_CATLOG_VAL := '';
								RETURN('Axe p/Catalogue : '); 
    					ELSE
    						
    						SELECT
     							COUNT(ROWNUM) INTO L_COUNTER
								FROM
  								( SELECT DISTINCT IT.TACHEAXEMETIER
									  FROM LIGNE_BIP L,
									    ISAC_TACHE IT
									  WHERE L.PID = IT.PID
									  AND L.PID   = P_PARAM7
									  GROUP BY L.PID,
									    IT.TACHEAXEMETIER
									  ) ;
									  
									 IF L_COUNTER = 1 THEN --5
									 	
									 	SELECT DISTINCT IT.TACHEAXEMETIER INTO L_TACHEAXEMETIER
									  FROM 
									    ISAC_TACHE IT
									  WHERE IT.PID   = P_PARAM7
									  GROUP BY IT.PID,
									    IT.TACHEAXEMETIER;

									 	--:CP_LIB_AXE_CATLOG_VAL := L_TACHEAXEMETIER;
									 		RETURN('Ref_demande : '|| L_TACHEAXEMETIER); 
									 ELSE
									 		--:CP_LIB_AXE_CATLOG_VAL := '(PLUSIEURS)';
										RETURN('Ref_demande : (PLUSIEURS)');
									 	END IF; --5

    					END IF; --4
    				ELSE
							--:CP_LIB_AXE_CATLOG_VAL := '';
							RETURN('Axe p/Catalogue : ');
    				END IF; --3    			
    		END IF;--2
  END IF;--1 
end;
   
   
   
   FUNCTION tmp_visuprojprin_budget2 (p_codsg IN ligne_bip.codsg%TYPE,
				 p_pid1  IN ligne_bip.pid%TYPE,
				 p_pid2  IN ligne_bip.pid%TYPE,
				 p_pid3  IN ligne_bip.pid%TYPE,
				 p_pid4  IN ligne_bip.pid%TYPE,
				 p_pid5  IN ligne_bip.pid%TYPE,
				 p_pid6  IN ligne_bip.pid%TYPE,
		             p_date_traite IN DATE) RETURN NUMBER IS

      -- numero de sequence
      l_var_seq NUMBER;

      cursor l_pid  (c_codsg CHAR, c_pid1 CHAR, c_pid2 CHAR, c_pid3 CHAR, c_pid4 CHAR, c_pid5 CHAR, c_pid6 CHAR )IS
	SELECT  lbi.pid pid
	  FROM  ligne_bip lbi
	  -- WHERE lbi.typproj != '7 ' -- YSB
	  WHERE   decode(c_pid1, NULL, '0', lbi.pid) IN
	  (nvl(c_pid1, '0'), nvl(c_pid2, '0'), nvl(c_pid3, '0'), nvl(c_pid4, '0'), nvl(c_pid5, '0'), nvl(c_pid6, '0'))
	  AND   (((decode(c_codsg, NULL, '0', substr(to_char(lbi.codsg) ,1 ,length(c_codsg)))) = decode(c_codsg, NULL, '0', c_codsg))
		 OR ((decode(c_codsg, NULL, '0', substr(to_char(lbi.codsg, 'FM0000000') ,1 ,length(c_codsg)))) = decode(c_codsg, NULL, '0', c_codsg)));

	l_lig_pid l_pid%ROWTYPE;

	l_temp1 VARCHAR2(50);
	l_temp2 VARCHAR2(50);
	l_temp3 VARCHAR2(50);
	l_temp4 VARCHAR2(50);
	l_temp5 VARCHAR2(50);
	l_temp6 VARCHAR2(50);

   BEGIN

      SELECT sbudget.nextval INTO l_var_seq FROM dual;

      open l_pid(p_codsg, p_pid1,  p_pid2, p_pid3, p_pid4, p_pid5, p_pid6);

      LOOP

	 fetch l_pid INTO l_lig_pid;

	 IF l_pid%NOTFOUND THEN
	    EXIT;
	 END IF;

	 --dbms_output.put_line('FETCH :' || l_lig_pid.pid||' '||numseq);
	 -- insert dans la table tmp_visuprojprin de budget propose ME
   -- PPM 64252 MHA : modification de l'ordre des types , et le max des nombres
	 INSERT INTO tmp_visuprojprin (numseq,
					 typeb,
					 pid,
					 immo,
					fidec,
					fiannee,
					 minus1,
					 n,
					 plus1,
					 plus2,
					 plus3,
					 total)
	   VALUES ( l_var_seq,
		    'A',
		    l_lig_pid.pid,
		    '',
			'',
			'',
		    CST_BUD_XXXX,
		    to_char(pack_verif_visuproj.f_calc_budget_propose(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')))),'FM9999999990D00'),
		    to_char(pack_verif_visuproj.f_calc_budget_propose(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) +1)),'FM9999999990D00'),
		    to_char(pack_verif_visuproj.f_calc_budget_propose(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) +2)),'FM9999999990D00'),
		    to_char(pack_verif_visuproj.f_calc_budget_propose(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) +3)),'FM9999999990D00'),
		    CST_BUD_XXXX
		    );
	 -- insert dans la table tmp_visuprojprin de budget propose MO
	 INSERT INTO tmp_visuprojprin (numseq,
					 typeb,
					 pid,
					 immo,
					fidec,
					fiannee,
					 minus1,
					 n,
					 plus1,
					 plus2,
					 plus3,
					 total)
	   VALUES ( l_var_seq,
		    'B',
		    l_lig_pid.pid,
		    '',
			'',
			'',
		    CST_BUD_XXXX,
		    to_char(pack_verif_visuproj.f_calc_budget_propose_mo(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')))),'FM9999999990D00'),
		    to_char(pack_verif_visuproj.f_calc_budget_propose_mo(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) +1)),'FM9999999990D00'),
		    to_char(pack_verif_visuproj.f_calc_budget_propose_mo(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) +2)),'FM9999999990D00'),
		    to_char(pack_verif_visuproj.f_calc_budget_propose_mo(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) +3)),'FM9999999990D00'),
		    CST_BUD_XXXX
		    );

	 -- insert dans la table tmp_visuprojprin de budget notifie

	 l_temp2 := to_char(pack_verif_visuproj.f_calc_budget_notifie(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) -1)),'FM9999999990D00');
	 l_temp3 := to_char(pack_verif_visuproj.f_calc_budget_notifie(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')))),'FM9999999990D00');

	 INSERT INTO tmp_visuprojprin (numseq,
					 typeb,
					 pid,
					 immo,
					fidec,
					fiannee,
					 minus1,
					 n,
					 plus1,
					 plus2,
					 plus3,
					 total)
	   VALUES (l_var_seq,
		   'C',
		   l_lig_pid.pid,
		   '',
			'',
			'',
		   l_temp2,
		   l_temp3,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   to_char( nvl(to_number(l_temp2), 0) + nvl(to_number(l_temp3), 0),'FM9999999990D00')
		   );

	 -- insert dans la table tmp_visuprojprin de budget reserve

	 l_temp2 := to_char(pack_verif_visuproj.f_calc_budget_reserve(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')))),'FM9999999990D00');

	 INSERT INTO tmp_visuprojprin  (numseq,
					 typeb,
					 pid,
					 immo,
					fidec,
					fiannee,
					 minus1,
					 n,
					 plus1,
					 plus2,
					 plus3,
					 total)
	   VALUES (l_var_seq,
		   'E',
		   l_lig_pid.pid,
		   '',
			'',
			'',
		   CST_BUD_XXXX,
			l_temp2,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   to_char( nvl(to_number(l_temp2), 0) ,
			      'FM9999999990D00' )
		   );

	 -- insert dans la table tmp_visuprojprin de budget arbitre
	 l_temp2 := to_char(pack_verif_visuproj.f_calc_budget_arb_notifie(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')) -1)),'FM9999999990D00');
	 l_temp3 := to_char(pack_verif_visuproj.f_calc_budget_arb_notifie(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')))),'FM9999999990D00');

	 INSERT INTO tmp_visuprojprin (numseq,
					 typeb,
					 pid,
					 immo,
					fidec,
					fiannee,
					 minus1,
					 n,
					 plus1,
					 plus2,
					 plus3,
					 total)
	   VALUES (l_var_seq,
		   'D',
		   l_lig_pid.pid,
		   '',
			'',
			'',
		   l_temp2,
		   l_temp3,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   to_char( nvl(to_number(l_temp2), 0) + nvl(to_number(l_temp3), 0),'FM9999999990D00')
		   );


	 -- insert dans la table tmp_visuprojprin de budget consomme

	 l_temp2 := to_char(pack_verif_visuproj.f_calc_budget_conso(l_lig_pid.pid,'1'),'FM9999990D00');
	 l_temp3 := to_char(pack_verif_visuproj.f_calc_budget_conso(l_lig_pid.pid,'0'),'FM9999990D00');


	 INSERT INTO tmp_visuprojprin (numseq,
					 typeb,
					 pid,
					 immo,
					fidec,
					fiannee,
					 minus1,
					 n,
					 plus1,
					 plus2,
					 plus3,
					 total)
	   VALUES (l_var_seq,
		   'H',
		   l_lig_pid.pid,
		  '',
			'',
			'',
		   l_temp2,
		   l_temp3,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   to_char( nvl(to_number(l_temp2), 0) + nvl(to_number(l_temp3), 0),
			      'FM9999990D00')
		   );
-- insert dans la table tmp_visuprojprin de budget cons/mois
	 l_temp2 := to_char(pack_verif_visuproj.f_calc_budget_conso_mois_cour(l_lig_pid.pid),'FM999990D00');

	 INSERT INTO tmp_visuprojprin  (numseq,
					 typeb,
					 pid,
					 immo,
					fidec,
					fiannee,
					 minus1,
					 n,
					 plus1,
					 plus2,
					 plus3,
					 total)
	   VALUES (l_var_seq,
		   'G',
		   l_lig_pid.pid,
		   '',
			'',
			'',
		CST_BUD_XXXX,
		   l_temp2,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   to_char( nvl(to_number(l_temp2), 0) ,
			      'FM999990D00' )
		   );

-- insert dans la table tmp_visuprojprin de budget reestime
	 l_temp2 := to_char(pack_verif_visuproj.f_calc_reestime(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')))),'FM9999999990D00');

	 INSERT INTO tmp_visuprojprin  (numseq,
					 typeb,
					 pid,
					 immo,
					fidec,
					fiannee,
					 minus1,
					 n,
					 plus1,
					 plus2,
					 plus3,
					 total)
	   VALUES (l_var_seq,
		   'F',
		   l_lig_pid.pid,
		   '',
			'',
			'',
			CST_BUD_XXXX,
		   l_temp2,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   to_char( nvl(to_number(l_temp2), 0) ,
			      'FM9999999990D00' )
		   );


-- insert dans la table tmp_visuprojprin de conso ligne Bip
	 l_temp2 := to_char(pack_verif_visuproj.f_calc_totbudcons_depuis_creat(l_lig_pid.pid),'FM999999990D00');

	 INSERT INTO tmp_visuprojprin  (numseq,
					 typeb,
					 pid,
					 immo,
					fidec,
					fiannee,
					 minus1,
					 n,
					 plus1,
					 plus2,
					 plus3,
					 total)
	   VALUES (l_var_seq,
		   'I',
		   l_lig_pid.pid,
		   '',
			'',
			'',
			CST_BUD_XXXX,
		   l_temp2,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   to_char( nvl(to_number(l_temp2), 0) ,
			      'FM999999990D00' )
		   );

-- insert donnees Facturation Interne
l_temp1 := to_char((pack_verif_visuproj.f_calc_immos(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')))))/1000,'FM99990D00');
--SEL PPM 58986 : l_temp2 correspond au calcul FI de DEC N - 1 : il est valorise a 0
--l_temp2 := to_char((pack_verif_visuproj.f_calc_fact_interne_decn1_fr(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')))))/1000,'FM9999990D00');
l_temp2 :=0;


-- BIP-280 --allowing the 7 digit character into l_temp3 variable for j typebe

l_temp3 := to_char((pack_verif_visuproj.f_calc_fact_interne_annee_fr(l_lig_pid.pid, (to_number(to_char(p_date_traite, 'YYYY')))))/1000,'FM9999990D00');


	 INSERT INTO tmp_visuprojprin  (numseq,
					 typeb,
					 pid,
					 immo,
					fidec,
					fiannee,
					 minus1,
					 n,
					 plus1,
					 plus2,
					 plus3,
					 total)
	   VALUES (l_var_seq,
		   'J',
		   l_lig_pid.pid,
		   	l_temp1,
			l_temp2,
			DECODE(l_temp3,'###########','***',l_temp3),
			CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   CST_BUD_XXXX,
		   to_char( nvl(to_number(l_temp2), 0) + nvl(decode(l_temp3,'###########',0,to_number(l_temp3)), 0),
			      'FM99990D00' )
		   );


	 commit;

      END LOOP;

      -- Fermeture du curseur
      close l_pid;

      RETURN l_var_seq;

   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;

   END tmp_visuprojprin_budget2;



--****************************************************************************
-- Les Procdures
--****************************************************************************

   
   -- ------------------------------------------------------------------------
   -- Nom        : verif_projprin
   -- Auteur     : Equipe SOPRA
   -- Decription : Test les champs saisies dans la page WEB
   --              
   -- Paramtres : p_param6  (IN) codsg
   --              p_param7  (IN) code ligne bip
   --              p_param8  (IN) code ligne bip
   --              p_param9  (IN) code ligne bip
   --              p_param10 (IN) code ligne bip
   --              p_param11 (IN) code ligne bip
   --              p_param12 (IN) code ligne bip
   --              p_userid  (IN) donnee de l'utilisateur
   -- Retour     : p_message (OUT) message d'erreur
   --            
   -- Modif      : 20/01/2000 correction d'un bug dans le test de retour d'info
   --              dans le cas de la non saisie d'un codsg
   -- 	  PJOSSE : 14/08/2003 Ajout d'un test pour savoir si le DPG demand est clotur.
   -- ------------------------------------------------------------------------
   PROCEDURE verif_projprin (p_param6  IN VARCHAR2,
			     p_param7  IN ligne_bip.pid%TYPE,
			     p_param8  IN ligne_bip.pid%TYPE,
			     p_param9  IN ligne_bip.pid%TYPE,
			     p_param10 IN ligne_bip.pid%TYPE,
			     p_param11 IN ligne_bip.pid%TYPE,
			     p_param12 IN ligne_bip.pid%TYPE,
			     p_userid  IN  CHAR,
			     p_message OUT VARCHAR2
			    ) IS
      
      l_codsg ligne_bip.codsg%TYPE;
      l_msg  VARCHAR2(1000);

      
   BEGIN

      
      -- TEST d'existance du codsg pour DIRMENU
      IF p_param6 IS NOT NULL THEN
         BEGIN
	    SELECT  codsg
	      INTO  l_codsg
	      FROM  ligne_bip
	      WHERE substr(to_char(codsg, 'FM0000000'), 1, length(rtrim(rtrim(LPAD(p_param6,7,'0'), '*')))) = rtrim(rtrim(LPAD(p_param6,7,'0'), '*'))
	      AND   ROWNUM < 2;
	    
	   EXCEPTION
	    WHEN no_data_found THEN
	      pack_global.recuperer_message( 20273, NULL, NULL, 'P_param6', l_msg);
	      raise_application_error( -20273, l_msg );
	      
	    WHEN OTHERS THEN
	      raise_application_error( -20997, SQLERRM );
	   END;
   
    
	-- ====================================================================
      	-- 19/02/2001 : Test appartenance du DPG au primtre de l'utilisateur
      	-- ====================================================================
     	pack_habilitation.verif_habili_me(p_param6,p_userid ,l_msg  );


	-- ====================================================================
      	-- 14/08/2003 : Test de fermeture du DPG
      	-- ====================================================================
         BEGIN
	    SELECT  l.codsg
	      INTO  l_codsg
	      FROM  ligne_bip l, struct_info s
	      WHERE l.codsg = s.codsg
	      AND   s.topfer = 'O'
	      AND   substr(to_char(l.codsg, 'FM0000000'), 1, length(rtrim(rtrim(LPAD(p_param6,7,'0'), '*')))) = rtrim(rtrim(LPAD(p_param6,7,'0'), '*'))
	      AND   ROWNUM < 2;
	    
	   EXCEPTION
	    -- Pas de DPG ouverts correspondants.
	    WHEN no_data_found THEN
	      pack_global.recuperer_message( 20925, '%s1', LPAD(p_param6,7,'0'), 'P_param6', l_msg);
	      raise_application_error( -20925, l_msg );
	    -- Autre problme
	    WHEN OTHERS THEN
	      raise_application_error( -20997, SQLERRM );
	   END;


      END IF;
      
      -- TEST des pid message 20504
      IF p_param7 IS NOT NULL THEN
	 verif_pid(p_param7 , 'P_param7', p_userid);
	 IF p_param8 IS NOT NULL THEN verif_pid(p_param8 , 'P_param8', p_userid); END IF;
	 IF p_param9 IS NOT NULL THEN verif_pid(p_param9 , 'P_param9', p_userid); END IF;
	 IF p_param10 IS NOT NULL THEN verif_pid(p_param10, 'P_param10', p_userid); END IF;
	 IF p_param11 IS NOT NULL THEN verif_pid(p_param11, 'P_param11', p_userid); END IF;
	 IF p_param12 IS NOT NULL THEN verif_pid(p_param12, 'P_param12', p_userid); END IF;
	 
      ELSIF (p_param8  IS NOT NULL OR
	     p_param9  IS NOT NULL OR
	     p_param10 IS NOT NULL OR
	     p_param11 IS NOT NULL OR
	     p_param12 IS NOT NULL
	     ) THEN
	 pack_global.recuperer_message( 20293, NULL, NULL, 'P_param7', l_msg);
	 raise_application_error( -20293, l_msg );
      END IF;
      
      -- TEST si l'edition retourne des informations
      BEGIN
	 IF (p_param6 IS NOT NULL) AND (p_param7 IS NOT NULL) THEN
	    
	    SELECT lbi.codsg
	      INTO l_codsg
	      FROM ligne_bip lbi
	      WHERE to_char(lbi.codsg, 'FM0000000') LIKE rtrim(rtrim(LPAD(p_param6,7,'0'), '*')) || '%'
	      AND   lbi.pid IN (p_param7, p_param8, p_param9, p_param10, p_param11, p_param12)
	      --AND   lbi.typproj != '7 ' -- YSB
	      AND   ROWNUM < 2;
	    
	 END IF;
	 
      EXCEPTION
	 WHEN no_data_found THEN
	   pack_global.recuperer_message( 20292 , NULL, NULL, 'P_param6', l_msg);
	   raise_application_error( -20292, l_msg);
	   
	 WHEN OTHERS THEN
	    raise_application_error( -20997, SQLERRM );
      END;
   END verif_projprin;
   
   -- ------------------------------------------------------------------------
   -- Nom        : verif_pid
   -- Auteur     : Equipe SOPRA
   -- Decription : Test les champs saisies dans la page WEB
   --              
   -- Paramtres : p_pid   (IN) code ligne_bip
   --              p_focus (IN) focus pour les pages WEB
   --              p_userid (IN) var globale de l'utilisateur
   -- Retour     : 
   -- 
   -- ------------------------------------------------------------------------
   PROCEDURE verif_pid(p_pid   ligne_bip.pid%TYPE,
		       p_focus VARCHAR2,
		       p_userid  IN  VARCHAR2) IS
      
      l_codsg ligne_bip.codsg%TYPE;
      l_msg VARCHAR2(1000);
      l_codpole VARCHAR2(25);
      l_habilitation varchar2(10);

   BEGIN
      BEGIN 
	 -- Test l'existance de la ligne_bip
	 SELECT  lbi.codsg
	   INTO  l_codsg
	   FROM  ligne_bip lbi
	   WHERE lbi.pid = p_pid;
   
      EXCEPTION
	 WHEN no_data_found THEN
	   pack_global.recuperer_message( 20504, '%s1', p_pid, p_focus, l_msg);
	   raise_application_error( -20504, l_msg );
	   
	 WHEN OTHERS THEN
	      raise_application_error( -20997, SQLERRM );
      END;
      
      ------------------------------------------------
      -- Vrification que la ligne BIP a un DPG ouvert
      ------------------------------------------------
      BEGIN 
	 -- Test l'existance de la ligne_bip
	 SELECT  lbi.codsg
	   INTO  l_codsg
	   FROM  ligne_bip lbi,
	         struct_info si
	   WHERE lbi.pid = p_pid
	     AND lbi.codsg = si.codsg
	     AND si.topfer = 'O';
   
      EXCEPTION
	 WHEN no_data_found THEN
   /*COMMENTED FOR BIP-36 IMPLEMENTATION*/
	   /*pack_global.recuperer_message( 20926, '%s1', p_pid, p_focus, l_msg);
	   raise_application_error( -20926, l_msg );*/
     null;
	   
	 WHEN OTHERS THEN
	      raise_application_error( -20997, SQLERRM );
      END;
      
      
      
      -- Si l'utilisateur est PCMMENU alors test l'habilitation sur la ligne_bip
      l_codpole := pack_global.lire_globaldata(p_userid).codpole;
      
      IF l_codpole != '0000' THEN -- Utilisateur non DIRMENU
	 
	-- ====================================================================
      	-- 19/02/2001 : Test appartenance du DPG au primtre de l'utilisateur
      	-- ====================================================================
     		l_habilitation := pack_habilitation.fhabili_me( l_codsg,p_userid   );
		IF l_habilitation='faux' THEN
			 /*COMMENTED FOR BIP-36 IMPLEMENTATION*/
			/*pack_global.recuperer_message(20364,'%s1', 'à la ligne bip '||p_pid, p_focus, l_msg);
	  		raise_application_error( -20364, l_msg );*/
		 null;
		END IF;
      END IF;
      
   END verif_pid;


END  pack_visuprojprin;
/
