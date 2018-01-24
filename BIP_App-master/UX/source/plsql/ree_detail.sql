CREATE OR REPLACE PACKAGE pack_ree_detail AS
-----------------------------------------


------------------------------------------------------------------------------
-- Constantes globales
------------------------------------------------------------------------------



------------------------------------------------------------------------------
-- Types et Curseurs
------------------------------------------------------------------------------

    -- ------------------------------------------------------------------------
    --le type tableau_numerique définit un tableau de NUMBER
    -- ------------------------------------------------------------------------


    TYPE tableau_numerique IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

		



------------------------------------------------------------------------------
-- Les Fonctions
------------------------------------------------------------------------------

-- ------------------------------------------------------------------------
   -- Nom        : tmp_ree_detail_seq
   -- Auteur     : BAA
   -- Decription : mise a jour de la table tmp_reee_detail  a partir des tables
   --              
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_scenario  (IN) code du scenario
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION tmp_ree_detail_seq (p_codsg IN ligne_bip.codsg%TYPE,
				                p_code_scenario  IN ree_scenarios.code_scenario%TYPE
				               ) RETURN NUMBER;


-- ------------------------------------------------------------------------
   -- Nom        : consom_reestime
   -- Auteur     : BAA
   -- Decription : renvoi la somme des consomes reestimer
   --              
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_scenario  (IN) code du scenario
   --              p_code_activite  (IN) code de l'activite
   --              p_ident  (IN) identifiant de la ressource
   --              p_moismens  (IN) le moismens de la table datdebex
   --              p_mois  (IN) le numero du mois
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


     FUNCTION consom_reestime(p_codsg 	IN ligne_bip.codsg%TYPE,
				            p_code_scenario IN ree_scenarios.code_scenario%TYPE,
							p_code_activite IN ree_activites.code_activite%TYPE,
							p_ident IN ree_ressources.ident%TYPE,
							p_typer IN ree_ressources.type%TYPE,
							p_moismens IN DATE,
							p_mois IN NUMBER
				            ) RETURN NUMBER;
				            
				        
-- ------------------------------------------------------------------------
   -- Nom        : consom_realiser
   -- Auteur     : BAA
   -- Decription : renvoi la somme des consomes realiser
   --              
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_activite  (IN) code de l'activite
   --              p_ident  (IN) identifiant de la ressource
   --              p_moismens  (IN) le moismens de la table datdebex
   --              p_mois  (IN) le numero du mois
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


     FUNCTION consom_realiser(p_codsg 	IN ligne_bip.codsg%TYPE,
				              p_code_activite IN ree_activites.code_activite%TYPE,
							  p_ident IN ree_ressources.ident%TYPE,
							  p_moismens IN DATE,
							  p_mois IN NUMBER
				            ) RETURN NUMBER;
				            


-- ------------------------------------------------------------------------
   -- Nom        : consom_realiser_absence
   -- Auteur     : BAA
   -- Decription : renvoi la somme des consomes realiser pour l'activite absences
   --              
   -- Paramètres : p_ident  (IN) identifiant de la ressource
   --              p_moismens  (IN) le moismens de la table datdebex
   --              p_mois  (IN) le numero du mois
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


     FUNCTION consom_realiser_absences(p_ident IN ree_ressources.ident%TYPE,
	 		  						   p_moismens IN DATE,
							           p_mois IN NUMBER
				                       ) RETURN NUMBER;
				            


-- ------------------------------------------------------------------------
   -- Nom        : consom_realiser_fournie
   -- Auteur     : BAA
   -- Decription : renvoi la somme des consomes realiser pour l'activite ss fournie
   --              
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_activite  (IN) code de l'activite
   --              p_ident  (IN) identifiant de la ressource
   --              p_moismens  (IN) le moismens de la table datdebex
   --              p_mois  (IN) le numero du mois
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


     FUNCTION consom_realiser_fournie(p_codsg 	IN ligne_bip.codsg%TYPE,
				              p_ident IN ree_ressources.ident%TYPE,
							  p_moismens IN DATE,
							  p_mois IN NUMBER
				            ) RETURN NUMBER;							


							
							
-- ------------------------------------------------------------------------
   -- Nom        : consom_realiser_recu
   -- Auteur     : BAA
   -- Decription : renvoi la somme des consomes realiser pour la ressource reçue
   --              
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_activite  (IN) code de l'activite
   --              p_moismens  (IN) le moismens de la table datdebex
   --              p_mois  (IN) le numero du mois
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


     FUNCTION consom_realiser_recu(p_codsg 	IN ligne_bip.codsg%TYPE,
   								   p_code_activite IN ree_activites.code_activite%TYPE,
				                   p_moismens IN DATE,
							       p_mois IN NUMBER,
								   p_ident IN NUMBER
				                  ) RETURN NUMBER;
								
				            
				            
-- ------------------------------------------------------------------------
   -- Nom        : consom
   -- Auteur     : BAA
   -- Decription : renvoi la somme des consomes realiser par code d'activite
   --              
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_scenario  (IN) code du scenario
   --              p_code_activite  (IN) code de l'activite
   --			   p_typea (IN) type de l'activite
   --              p_ident  (IN) identifiant de la ressource
   --			   p_typeb (IN) type de l'a ressource
   --              p_moismens  (IN) le moismens de la table datdebex
   --              p_mois (IN) le numero du mois
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


   FUNCTION consom(p_codsg 	IN ligne_bip.codsg%TYPE,
				   p_code_scenario IN ree_scenarios.code_scenario%TYPE,
				   p_code_activite IN ree_activites.code_activite%TYPE,
				   p_typea IN ree_activites.type%TYPE,
				   p_ident IN ree_ressources.ident%TYPE,
				   p_typer IN ree_ressources.type%TYPE,
				   p_moismens IN DATE,
				   p_mois IN NUMBER
				   ) RETURN NUMBER;
							      
		
		
		
-- ------------------------------------------------------------------------
   -- Nom        : total_realiser
   -- Auteur     : BAA
   -- Decription : renvoi le total des sommes des consomes realiser par code d'activite
   --              
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_scenario  (IN) code du scenario
   --              p_code_activite  (IN) code de l'activite
   --			   p_typea (IN) type de l'activite
   --              p_ident  (IN) identifiant de la ressource
   --			   p_typeb (IN) type de l'a ressource
   --              p_moismens  (IN) le moismens de la table datdebex
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


   FUNCTION total_realiser(p_codsg 	IN ligne_bip.codsg%TYPE,
				   p_code_scenario IN ree_scenarios.code_scenario%TYPE,
				   p_code_activite IN ree_activites.code_activite%TYPE,
				   p_typea IN ree_activites.type%TYPE,
				   p_ident IN ree_ressources.ident%TYPE,
				   p_typer IN ree_ressources.type%TYPE,
				   p_moismens IN DATE
				   ) RETURN NUMBER;
		
				   
				   
-- ------------------------------------------------------------------------
   -- Nom        : total_reestimer
   -- Auteur     : BAA
   -- Decription : renvoi le total des sommes des consomes reestimer par code d'activite
   --              
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_scenario  (IN) code du scenario
   --              p_code_activite  (IN) code de l'activite
   --			   p_typea (IN) type de l'activite
   --              p_ident  (IN) identifiant de la ressource
   --			   p_typeb (IN) type de l'a ressource
   --              p_moismens  (IN) le moismens de la table datdebex
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


   FUNCTION total_reestimer(p_codsg 	IN ligne_bip.codsg%TYPE,
				   p_code_scenario IN ree_scenarios.code_scenario%TYPE,
				   p_code_activite IN ree_activites.code_activite%TYPE,
				   p_typea IN ree_activites.type%TYPE,
				   p_ident IN ree_ressources.ident%TYPE,
				   p_typer IN ree_ressources.type%TYPE,
				   p_moismens IN DATE
				   ) RETURN NUMBER;
			
   -- ------------------------------------------------------------------------
   -- Nom        : total_realiser_t
   -- Auteur     : BAA
   -- Decription : renvoi le total des sommes des consomes realiser par code d'activite
   --              
   -- Paramètres : p_1 de p_12 (IN) est la somme des consommé realisé pour chaque mois p_i pour le mois i
   --              p_moismens  (IN) le moismens de la table datdebex
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------	   
											
	FUNCTION total_realiser_t(p_1 IN NUMBER,p_2 IN NUMBER,
							  p_3 IN NUMBER,p_4 IN NUMBER,
							  p_5 IN NUMBER,p_6 IN NUMBER,
							  p_7 IN NUMBER,p_8 IN NUMBER,
							  p_9 IN NUMBER,p_10 IN NUMBER,
							  p_11 IN NUMBER,p_12 IN NUMBER,
							  p_moismens IN DATE
							  ) RETURN NUMBER;
							 
							 
   -- ------------------------------------------------------------------------
   -- Nom        : total_reestimer_t
   -- Auteur     : BAA
   -- Decription : renvoi le total des sommes des consomes reestimer par code d'activite
   --              
   -- Paramètres : p_1 de p_12 (IN) est la somme des consommé reestimer pour chaque mois p_i pour le mois i
   --              p_moismens  (IN) le moismens de la table datdebex
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------	   
	
    FUNCTION total_reestimer_t(p_1 IN NUMBER,p_2 IN NUMBER,
	      	 				   p_3 IN NUMBER,p_4 IN NUMBER,
							   p_5 IN NUMBER,p_6 IN NUMBER,
							   p_7 IN NUMBER,p_8 IN NUMBER,
							   p_9 IN NUMBER,p_10 IN NUMBER,
							   p_11 IN NUMBER,p_12 IN NUMBER,
							   p_moismens IN DATE
							   ) RETURN NUMBER;
							 
					
							
-- ------------------------------------------------------------------------
   -- Nom        : total_reestimer
   -- Auteur     : BAA
   -- Decription : renvoi le total des sommes des consomes reestimer par code d'activite
   --              
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_scenario  (IN) code du scenario
   --              p_code_activite  (IN) code de l'activite
   --			   p_typea (IN) type de l'activite
   --              p_ident  (IN) identifiant de la ressource
   --			   p_typeb (IN) type de l'a ressource
   --              p_moismens  (IN) le moismens de la table datdebex
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


   FUNCTION nombre_jour(p_mois 	IN CHAR,
				        p_moismens IN DATE
				       ) RETURN NUMBER;							
							

							
							
------------------------------------------------------------------------------
-- Les Procédures
------------------------------------------------------------------------------


END pack_ree_detail;
/




CREATE OR REPLACE PACKAGE BODY pack_ree_detail AS


-- Decription : ajout dans la table tmp_reee_detail les données necessaire pour 
--              les editions detail a partir des tables

 FUNCTION tmp_ree_detail_seq (p_codsg IN ligne_bip.codsg%TYPE,
				              p_code_scenario  IN ree_scenarios.code_scenario%TYPE
				              ) RETURN NUMBER IS

      
        l_var_seq NUMBER; -- numero de sequence
        EXISTE_TYPE VARCHAR2(3);
		v_CODSG NUMBER(7);
		v_LIBDSG VARCHAR2(40);
		v_CODE_SCENARIO VARCHAR2(12);
		v_LIB_SCENARIO VARCHAR2(60);
		v_MOISMENS DATE;
		v_IDENT NUMBER(5);
		v_NOM VARCHAR2(30);
		v_PRENOM VARCHAR2(15);
		v_DATDEP DATE;
		v_TYPEA VARCHAR2(1);
		v_TYPER VARCHAR2(1);
		v_CODE_ACTIVITE VARCHAR2(12);
		v_LIB_ACTIVITE VARCHAR2(60);
		
		st_ident NUMBER(5);
		st_nom VARCHAR2(30);
		st_prenom VARCHAR2(15);
		
		Tab_mois   tableau_numerique; --tableaux qui va contenir les sommes des consomé et realiser pour chaque mois
		R NUMBER; -- la somme du consommé realiser et reestimer
		T NUMBER; -- la somme du consommé realiser et reestimer


      --on recupere toutes les ressources et leurs activites pour un odsg		

      cursor l_c_a(c_codsg CHAR,c_code_scenario CHAR) IS
	   SELECT
       	RR.CODSG CODSG,
       	SI.LIBDSG LIBDSG,
       	RS.CODE_SCENARIO CODE_SCENARIO,
       	RS.LIB_SCENARIO LIB_SCENARIO,
       	D.MOISMENS MOISMENS,
	   	RR.IDENT IDENT,
	   	RR.RNOM NOM,
	   	RR.RPRENOM PRENOM,
	   	RR.DATDEP DATDEP,
	   	RR.TYPE TYPER,
		RA.CODE_ACTIVITE CODE_ACTIVITE,
		RA.LIB_ACTIVITE LIB_ACTIVITE,
		RA.TYPE TYPEA
	   FROM
         REE_RESSOURCES RR,
	     REE_ACTIVITES RA,
	     REE_SCENARIOS RS,
	     STRUCT_INFO SI,
	     DATDEBEX D
	  WHERE
         RR.CODSG=c_codsg
	     and RA.CODSG=RR.CODSG
	     and SI.CODSG=RR.CODSG
	     and RS.CODSG=RR.CODSG
	     and RS.CODE_SCENARIO=c_code_scenario
     ORDER BY NOM,CODE_ACTIVITE;

	  cursor ss_trait(c_codsg CHAR,c_code_scenario CHAR) IS
        select distinct pp.tires, pp.rnom, pp.rprenom
        from proplus pp, ligne_bip lb, ree_scenarios rs, situ_ress sr, datdebex d
        where pp.pid = lb.pid
        and rs.codsg = lb.codsg
        and pp.tires = sr.ident
        and pp.datdep = sr.datdep
        and sr.codsg <> c_codsg
        and lb.codsg = c_codsg
        and rs.code_scenario = c_code_scenario
        and TO_NUMBER(TO_CHAR(sr.datdep,'yyyy')) >= TO_NUMBER(TO_CHAR(d.datdebex,'yyyy'))
        and exists ( select 1
                    from REE_ACTIVITES_LIGNE_BIP r
                    where r.codsg = c_codsg
                    and r.pid = PP.FACTPID);

   BEGIN


     BEGIN
   
      --Création automatique ressource de type S pour le DPG s'il n'existe pas
	  SELECT 'OUI' INTO EXISTE_TYPE FROM REE_RESSOURCES WHERE CODSG=p_codsg AND TYPE='S' and rownum = 1;

      EXCEPTION

			 WHEN No_Data_Found THEN

				 EXISTE_TYPE := 'NON';

        END; 
   
      IF(EXISTE_TYPE = 'NON') THEN

              OPEN ss_trait(p_codsg,p_code_scenario);

              LOOP

              fetch ss_trait into st_ident, st_nom, st_prenom;
  
              IF ss_trait%NOTFOUND THEN
                EXIT;
              END IF;
              
              INSERT INTO REE_RESSOURCES(CODSG, TYPE, IDENT, RNOM, RPRENOM) values (p_codsg, 'S', st_ident, st_nom , st_prenom);

              END LOOP;
      
      END IF;  
      
   

      SELECT sdetail.nextval INTO l_var_seq FROM dual; --creation de la sequence 
	  
      
      OPEN l_c_a(p_codsg,p_code_scenario);

      LOOP

	  fetch l_c_a  INTO v_CODSG, v_LIBDSG, v_CODE_SCENARIO, v_LIB_SCENARIO, v_MOISMENS, v_IDENT, v_NOM, v_PRENOM, v_DATDEP, v_TYPER, v_CODE_ACTIVITE, v_LIB_ACTIVITE, v_TYPEA;

	 IF l_c_a%NOTFOUND THEN
	    EXIT;
	 END IF;
 
 	  --on recupere toutes les consomés de chaque mois pour une ressource 
	  --et une activite et on les stock dans un tanleaux
	  FOR i in 1..12 LOOP
	
	 Tab_mois(i):=consom(v_CODSG,v_CODE_SCENARIO,v_CODE_ACTIVITE,v_TYPEA,v_IDENT,v_TYPER,v_MOISMENS,i);
				
	 END LOOP; 
	 
	 R := total_realiser_t(Tab_mois(1),Tab_mois(2),Tab_mois(3),Tab_mois(4),Tab_mois(5),Tab_mois(6),Tab_mois(7),Tab_mois(8),Tab_mois(9),Tab_mois(10),Tab_mois(11),Tab_mois(12),v_MOISMENS);
	 
	 T := total_reestimer_t(Tab_mois(1),Tab_mois(2),Tab_mois(3),Tab_mois(4),Tab_mois(5),Tab_mois(6),Tab_mois(7),Tab_mois(8),Tab_mois(9),Tab_mois(10),Tab_mois(11),Tab_mois(12),v_MOISMENS);

	 
	 IF((R+T)!=0)THEN
	 
	 -- insert dans la table tmp_ree_detail des lignes pour chaque activite de chaque ressource
	 INSERT INTO tmp_ree_detail (NUMSEQ,
					       		 CODSG,
					  			 LIBDSG,
					   			 CODE_SCENARIO,
					    		 LIB_SCENARIO,
					    		 MOISMENS,
					      		 IDENT,
					      		 NOM,
					      		 PRENOM,
					          	 DATDEP,
					        	 TYPER,
					        	 CODE_ACTIVITE,
								 LIB_ACTIVITE,
								 TYPEA,
								 CJAN,
								 CFEV,
								 CMAR,
								 CAVR,
								 CMAI,
								 CJUN,
								 CJUL,
								 CAOU,
								 CSEP,
								 COCT,
								 CNOV,
								 CDEC,
					        	 JAN,
					        	 FEV,
					        	 MAR,
					        	 AVR,
					        	 MAI,
					        	 JUN,
								 JUL,
					        	 AOU,
					        	 SEP,
					        	 OCT,
					        	 NOV,
					        	 DEC,
								 T_REALISER,
								 T_REESTIMER
								 )
	   VALUES ( l_var_seq,
		        v_CODSG,
				v_LIBDSG,
				v_CODE_SCENARIO,
				v_LIB_SCENARIO,
				v_MOISMENS,
				v_IDENT,
				v_NOM,
				v_PRENOM,
				v_DATDEP,
				v_TYPER,
				v_CODE_ACTIVITE,
				v_LIB_ACTIVITE,
				v_TYPEA,
				nombre_jour('1',v_MOISMENS),
				nombre_jour('2',v_MOISMENS),
				nombre_jour('3',v_MOISMENS),
				nombre_jour('4',v_MOISMENS),
				nombre_jour('5',v_MOISMENS),
				nombre_jour('6',v_MOISMENS),
			 	nombre_jour('7',v_MOISMENS),
				nombre_jour('8',v_MOISMENS),
				nombre_jour('9',v_MOISMENS),
				nombre_jour('10',v_MOISMENS),
				nombre_jour('11',v_MOISMENS),
				nombre_jour('12',v_MOISMENS),
				Tab_mois(1),
				Tab_mois(2),
				Tab_mois(3),
				Tab_mois(4),
				Tab_mois(5),
				Tab_mois(6),
				Tab_mois(7),
				Tab_mois(8),
				Tab_mois(9),
				Tab_mois(10),
				Tab_mois(11),
				Tab_mois(12),
				R,
				T
				);

      END IF;

      END LOOP;

      -- Fermeture du curseur
      close l_c_a;

      RETURN l_var_seq;

   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;

   END tmp_ree_detail_seq;



   
   
   -- Decription : renvoi la somme des consomes reestimer
   
   FUNCTION consom_reestime(p_codsg 	IN ligne_bip.codsg%TYPE,
				            p_code_scenario IN ree_scenarios.code_scenario%TYPE,
							p_code_activite IN ree_activites.code_activite%TYPE,
							p_ident IN ree_ressources.ident%TYPE,
							p_typer IN ree_ressources.type%TYPE,
							p_moismens IN DATE,
							p_mois IN NUMBER
				            ) RETURN NUMBER IS
				            
        
      consom NUMBER; 
		
	--on recupere la somme des consomés reestimer pour chaque ressource et activite
	
		
      cursor l_c_con(c_codsg CHAR, c_code_scenario CHAR, c_code_activite CHAR, c_ident NUMBER, c_typer CHAR, c_moismens DATE, c_mois NUMBER) IS
	    select SUM(CONSO_PREVU)
        from ree_reestime
		where
			codsg=c_codsg
			and code_scenario=c_code_scenario 
			and code_activite=c_code_activite
			and ident=c_ident
			and type=c_typer
			and TO_NUMBER(TO_CHAR(cdeb,'mmyyyy'))=TO_NUMBER(TO_CHAR(c_mois)||TO_CHAR(c_moismens,'yyyy'))
		group by codsg, code_scenario, code_activite, ident;
     
     
   BEGIN             
		
		OPEN l_c_con(p_codsg,p_code_scenario,p_code_activite,p_ident, p_typer, p_moismens,p_mois);

	  	fetch l_c_con  INTO consom;

	  	-- Fermeture du curseur
        CLOSE l_c_con;

      RETURN NVL(consom,0);	
		
   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;		            
				            
   END consom_reestime;
   
   
   
   
   -- Decription : renvoi la somme des consomes realiser
   
   FUNCTION consom_realiser(p_codsg 	IN ligne_bip.codsg%TYPE,
				            p_code_activite IN ree_activites.code_activite%TYPE,
							p_ident IN ree_ressources.ident%TYPE,
							p_moismens IN DATE,
							p_mois IN NUMBER
				            ) RETURN NUMBER IS
				            
        
     consom NUMBER;
		 
	--on recupere la somme des consomés realiser pour chaque ressource et activite
			 
		 
     cursor l_c_con(c_codsg CHAR, c_code_activite CHAR, c_ident NUMBER, c_moismens DATE, c_mois NUMBER) IS
	    select SUM(PP.CUSAG)
		from REE_ACTIVITES_LIGNE_BIP RAL,PROPLUS PP
		where
			RAL.CODSG=c_codsg
			and RAL.CODE_ACTIVITE=c_code_activite 
			--and PP.FACTPDSG=RAL.CODSG
			and PP.TIRES=c_ident
			and PP.FACTPID=RAL.PID
			and PP.PTYPE<>7
			and TO_NUMBER(TO_CHAR(PP.CDEB,'mmyyyy'))=TO_NUMBER(TO_CHAR(c_mois)||TO_CHAR(c_moismens,'yyyy'));
		
   BEGIN             
		
		OPEN l_c_con(p_codsg,p_code_activite,p_ident,p_moismens,p_mois);

	  	fetch l_c_con  INTO consom;

	  	-- Fermeture du curseur
        CLOSE l_c_con;

      RETURN NVL(consom,0);	
		
   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;		            
				            
   END consom_realiser;
   
   
   
   -- Decription : renvoi la somme des consomes realiser pour l'activite absences
   
   FUNCTION consom_realiser_absences(p_ident IN ree_ressources.ident%TYPE,
   									 p_moismens DATE,
				                     p_mois IN NUMBER 
									  ) RETURN NUMBER IS
				            
        
     consom NUMBER;
		
     --	on recupere la somme des absences pour une resource de chaque mois de l'activite absence
	  		 
     cursor l_c_con(c_ident NUMBER,c_moismens DATE, c_mois NUMBER) IS
	   select SUM(PP.CUSAG)
	   from PROPLUS PP
	   where
			PP.TIRES=c_ident
			and PP.PTYPE=7
			and TO_NUMBER(TO_CHAR(PP.CDEB,'mmyyyy'))=TO_NUMBER(TO_CHAR(c_mois)||TO_CHAR(c_moismens,'yyyy'));
					
		
   BEGIN             
		
		OPEN l_c_con(p_ident,p_moismens,p_mois);

	  	fetch l_c_con  INTO consom;

	  	-- Fermeture du curseur
        CLOSE l_c_con;

      RETURN NVL(consom,0);	
		
   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;		            
				            
   END consom_realiser_absences;
   
   
 
 FUNCTION consom_realiser_fournie(p_codsg 	IN ligne_bip.codsg%TYPE,
				            p_ident IN ree_ressources.ident%TYPE,
							p_moismens IN DATE,
							p_mois IN NUMBER
				            ) RETURN NUMBER IS
				            
        
     consom NUMBER;
		 
 
     -- on recupere la somme des jours fournie à une ressource de chaque mois de l'activite ss fournie
  
     cursor l_c_con(c_codsg CHAR, c_ident NUMBER, c_moismens DATE, c_mois NUMBER) IS
	   select SUM(PP.CUSAG)
	   from PROPLUS PP
	   where
			PP.TIRES=c_ident
			and PP.PTYPE<>7
			and TO_NUMBER(TO_CHAR(PP.CDEB,'mmyyyy'))=TO_NUMBER(TO_CHAR(c_mois)||TO_CHAR(c_moismens,'yyyy'))
			and not exists ( select 1
                             from REE_ACTIVITES_LIGNE_BIP a
                              where a.codsg = c_codsg 
                              and a.pid = PP.FACTPID);
					
		
   BEGIN             
		
		OPEN l_c_con(p_codsg,p_ident,p_moismens,p_mois);

	  	fetch l_c_con  INTO consom;

	  	-- Fermeture du curseur
        CLOSE l_c_con;

      RETURN NVL(consom,0);	
		
   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;		            
				            
   END consom_realiser_fournie;
 
 
   FUNCTION consom_realiser_recu(p_codsg 	IN ligne_bip.codsg%TYPE,
   								 p_code_activite IN ree_activites.code_activite%TYPE,
				                 p_moismens IN DATE,
							     p_mois IN NUMBER,
								 p_ident IN NUMBER
				                 ) RETURN NUMBER IS
 
 
   consom NUMBER;
		 
		 
--on recupere la somme des jours recu d'une sous traitance pour chaque moi de chaque activite d'une ressource ss reçue
		 
 cursor l_c_con(c_codsg CHAR, c_code_activite CHAR, c_moismens DATE, c_mois NUMBER, c_ident NUMBER) IS
	select SUM(PP.CUSAG)
		from REE_ACTIVITES_LIGNE_BIP RAL,PROPLUS PP
		where
			RAL.CODSG=c_codsg
			and RAL.CODE_ACTIVITE=c_code_activite 
			--and PP.FACTPDSG=RAL.CODSG
			and PP.FACTPID=RAL.PID
			and PP.PTYPE<>7
			and TO_NUMBER(TO_CHAR(PP.CDEB,'mmyyyy'))=TO_NUMBER(TO_CHAR(c_mois)||TO_CHAR(c_moismens,'yyyy'))
			and PP.tires = c_ident;
 						
   BEGIN             
		
		OPEN l_c_con(p_codsg,p_code_activite,p_moismens,p_mois,p_ident);

	  	fetch l_c_con  INTO consom;

	  	-- Fermeture du curseur
        CLOSE l_c_con;

      RETURN NVL(consom,0);	
		
   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;		            
				            
   END consom_realiser_recu;
 
 
 
 --cette fonction permet le renvoi des sommes pour n'inport activite et ressource
 -- C'est la fonction maitre des autre fonctions
 
   FUNCTION consom(p_codsg 	IN ligne_bip.codsg%TYPE,
				   p_code_scenario IN ree_scenarios.code_scenario%TYPE,
				   p_code_activite IN ree_activites.code_activite%TYPE,
				   p_typea IN ree_activites.type%TYPE,
				   p_ident IN ree_ressources.ident%TYPE,
				   p_typer IN ree_ressources.type%TYPE,
				   p_moismens IN DATE,
				   p_mois IN NUMBER
				   ) RETURN NUMBER IS
				            
        
      consom NUMBER;
		
      
     
   BEGIN             
		IF(p_mois<=TO_NUMBER(TO_CHAR(p_moismens,'mm'))) THEN--entraite les consomés realiser
			IF(p_typer='X')THEN-- si la ressource est de type fictive
					
				 consom:=0;
							   
			ELSIF(p_typer='S')THEN-- si la ressource est de type ss reçu
			   
			     consom:=consom_realiser_recu(p_codsg,p_code_activite,p_moismens,p_mois,p_ident);
			
			ELSE
											
		
		    	IF(p_typea='A')THEN-- si l'activite est de type Absence
		    
						 consom:=consom_realiser_absences(p_ident,p_moismens,p_mois);
			
			    ELSIF(p_typea='F')THEN-- si l'activite est de type ss fournie
			
				         consom:=consom_realiser_fournie(p_codsg,p_ident,p_moismens,p_mois);
			
			    ELSE -- les autres type d'activites
			
				         consom:=consom_realiser(p_codsg,p_code_activite,p_ident,p_moismens,p_mois);
				
				END IF;
			END IF;
			
		ELSE --on traite  les comsomés  reestimer
		
			consom:=consom_reestime(p_codsg,p_code_scenario,p_code_activite,p_ident,p_typer,p_moismens,p_mois);	
		
	    END IF;
		
		return ROUND(consom,1);
		
   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;		            
				            
   END consom;  
   
   
   
   FUNCTION total_realiser(p_codsg 	IN ligne_bip.codsg%TYPE,
				   p_code_scenario IN ree_scenarios.code_scenario%TYPE,
				   p_code_activite IN ree_activites.code_activite%TYPE,
				   p_typea IN ree_activites.type%TYPE,
				   p_ident IN ree_ressources.ident%TYPE,
				   p_typer IN ree_ressources.type%TYPE,
				   p_moismens IN DATE
				   ) RETURN NUMBER IS
		
		
   nb_m_real NUMBER;	--  p_nb_mois le nombre de mois realiser
   total NUMBER;
   
   			   
				   
   BEGIN
   
   
   total:=0;
   
   
   SELECT TO_NUMBER(TO_CHAR(p_moismens,'mm')) INTO nb_m_real FROM dual;
   
   			   
   FOR i in 1..nb_m_real LOOP
   
   
   
   total:= total+consom(p_codsg,p_code_scenario,p_code_activite,p_typea,p_ident,p_typer,p_moismens,i);
				
 			
   
   END LOOP;				   
   
   
   return total;
   
   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;		            
	
   
   END total_realiser;
   
   
   
   
   
   FUNCTION total_reestimer(p_codsg 	IN ligne_bip.codsg%TYPE,
				   p_code_scenario IN ree_scenarios.code_scenario%TYPE,
				   p_code_activite IN ree_activites.code_activite%TYPE,
				   p_typea IN ree_activites.type%TYPE,
				   p_ident IN ree_ressources.ident%TYPE,
				   p_typer IN ree_ressources.type%TYPE,
				   p_moismens IN DATE
				   ) RETURN NUMBER IS
		
		
   nb_m_real NUMBER;	--  p_nb_mois le nombre de mois realiser
   total NUMBER;
   
   			   
				   
   BEGIN
   
   
   total:=0;
   
   
   SELECT TO_NUMBER(TO_CHAR(p_moismens,'mm')) INTO nb_m_real FROM dual;
   
   nb_m_real:=nb_m_real+1;
	 	 
 				   
     
   FOR i in nb_m_real..12 LOOP
   
     
   total:= total+consom(p_codsg,p_code_scenario,p_code_activite,p_typea,p_ident,p_typer,p_moismens,i);
				
   
   END LOOP;				   
   
   
   return total;
   
   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;		            
	
   
   END total_reestimer;
   

   -- Decription : renvoi le total des sommes des consomes realiser par code d'activite
   
   FUNCTION total_realiser_t(p_1 IN NUMBER,p_2 IN NUMBER,
							 p_3 IN NUMBER,p_4 IN NUMBER,
							 p_5 IN NUMBER,p_6 IN NUMBER,
							 p_7 IN NUMBER,p_8 IN NUMBER,
							 p_9 IN NUMBER,p_10 IN NUMBER,
							 p_11 IN NUMBER,p_12 IN NUMBER,
							 p_moismens IN DATE
							 ) RETURN NUMBER IS
		
		
	
   nb_m_real NUMBER;	--  p_nb_mois le nombre de mois realiser
   total NUMBER;
   Tab tableau_numerique;
      
   			   
   BEGIN
   
   
   total:=0;
   
   
   SELECT TO_NUMBER(TO_CHAR(p_moismens,'mm')) INTO nb_m_real FROM dual;
   
   --on recupere tous les sommes et on les stock dans un tableaux pour pouvoir utiliser une boucle
   Tab(1) := p_1;
   Tab(2) := p_2;
   Tab(3) := p_3;
   Tab(4) := p_4;
   Tab(5) := p_5;
   Tab(6) := p_6;
   Tab(7) := p_7;
   Tab(8) := p_8;
   Tab(9) := p_9;
   Tab(10) := p_10;
   Tab(11) := p_11;
   Tab(12) := p_12;
   		
   --on somme que les consomés realiser		
			   
   FOR i in 1..nb_m_real LOOP
   
   total:= total + Tab(i);		
   
   END LOOP;				   
   
   
   return total;
   
   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;		            
	
   
   END total_realiser_t;
   
   
   
   -- Decription : renvoi le total des sommes des consomes reestimer par code d'activite
   
   FUNCTION total_reestimer_t(p_1 IN NUMBER,p_2 IN NUMBER,
							  p_3 IN NUMBER,p_4 IN NUMBER,
							  p_5 IN NUMBER,p_6 IN NUMBER,
							  p_7 IN NUMBER,p_8 IN NUMBER,
							  p_9 IN NUMBER,p_10 IN NUMBER,
							  p_11 IN NUMBER,p_12 IN NUMBER,
							  p_moismens IN DATE
							  ) RETURN NUMBER IS
		
		
   nb_m_real NUMBER;	--  p_nb_mois le nombre de mois realiser
   total NUMBER;
   Tab tableau_numerique;
   			   
				   
   BEGIN
   
   
   total:=0;
   
   
   SELECT TO_NUMBER(TO_CHAR(p_moismens,'mm')) INTO nb_m_real FROM dual;
   
   nb_m_real:=nb_m_real+1;
	 
   --on recupere tous les sommes et on les stock dans un tableaux pour pouvoir utiliser une boucle
   	 	 
   Tab(1) := p_1;
   Tab(2) := p_2;
   Tab(3) := p_3;
   Tab(4) := p_4;
   Tab(5) := p_5;
   Tab(6) := p_6;
   Tab(7) := p_7;
   Tab(8) := p_8;
   Tab(9) := p_9;
   Tab(10) := p_10;
   Tab(11) := p_11;
   Tab(12) := p_12;			
			
				   
   --on somme que les consomés reestimer
   FOR i in nb_m_real..12 LOOP
   
     total:= total + Tab(i);
   
   
   END LOOP;				   
   
   
   return total;
   
   EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;		            
	
   
   END total_reestimer_t;
   
   
   
   
   FUNCTION nombre_jour(p_mois 	IN CHAR,
				        p_moismens IN DATE
				       ) RETURN NUMBER IS
					
		
	nb NUMBER;	
				   
		   
	BEGIN
	
	
	select CJOURS INTO nb
          from CALENDRIER
          where TO_NUMBER(TO_CHAR(CALANMOIS,'mmyyyy'))=TO_NUMBER(p_mois||TO_CHAR(p_moismens,'yyyy'));
	
	return nb;
	
	EXCEPTION
      WHEN OTHERS THEN raise; --RETURN 0;	
	
	END nombre_jour;				   		
   
   
END pack_ree_detail;
/
