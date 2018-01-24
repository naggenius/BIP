-- pack_budactjh PL/SQL
-- 
-- Créé le 13/04/2005 par EJE
-- Modifié le 16/09/2005 par PPR : Correction de bug
--
--*******************************************************************
--

CREATE OR REPLACE PACKAGE pack_budactjh AS

FUNCTION str_budactjh 	(	p_string     IN  VARCHAR2,
                           		p_occurence  IN  NUMBER
                          	  ) return VARCHAR2;

PROCEDURE select_budactjh  	 (	p_annee		IN  VARCHAR2,
   					p_clicode      	IN  client_mo.clicode%TYPE,
   					p_clisigle     	OUT  client_mo.clisigle%TYPE,
                               		p_nbpages	OUT VARCHAR2,
                               		p_numpage 	OUT VARCHAR2,
                               		p_nbcurseur	OUT INTEGER,
                               		p_message	OUT VARCHAR2
                               	);
                             		 
PROCEDURE update_budactjh(		p_string    IN  VARCHAR2,
                              		p_nbcurseur OUT INTEGER,
                              		p_message   OUT VARCHAR2
                             );


END pack_budactjh;
/

CREATE OR REPLACE PACKAGE BODY pack_budactjh AS 

   FUNCTION str_budactjh (	p_string     IN  VARCHAR2,
                           	p_occurence  IN  NUMBER
                          	) return VARCHAR2 IS
   pos1 NUMBER(6);
   pos2 NUMBER(6);
   str  VARCHAR2(111);

   BEGIN

      pos1 := INSTR(p_string,';',1,p_occurence);
      pos2 := INSTR(p_string,';',1,p_occurence+1);

      IF pos2 != 1 THEN
         str := SUBSTR( p_string, pos1+1, pos2-pos1-1);
         IF str = 'null' THEN 
	    str := '-1' ;
	 END IF ;
         return str;
      ELSE
         return '0';
      END IF;

   END str_budactjh;

PROCEDURE select_budactjh  	 (	p_annee		IN  VARCHAR2,
   					p_clicode      	IN  client_mo.clicode%TYPE,
   					p_clisigle     	OUT  client_mo.clisigle%TYPE,
                               		p_nbpages	OUT VARCHAR2,
                               		p_numpage 	OUT VARCHAR2,
                               		p_nbcurseur	OUT INTEGER,
                               		p_message	OUT VARCHAR2
                               	) IS

      NB_LIGNES_MAXI 	NUMBER(5);
      NB_LIGNES_PAGES   NUMBER(2);
      l_msg	VARCHAR2(1024);
      l_nbpages	NUMBER(5);
      
      BEGIN
	    -- Nombres de lignes BIP retournées Maxis : 
	    NB_LIGNES_MAXI := 500;
	    -- Nombre de lignes BIP maxi par pages
	    NB_LIGNES_PAGES := 10;
	      
	    -- Positionner le nb de curseurs ==> 1
	    -- Initialiser le message retour
	    p_nbcurseur := 1;
	    p_message := '';
	
	    p_numpage := 'NumPage#1';

	    -- Compte le nombre de lignes
	    SELECT count(distinct dp.DPCODE) INTO l_nbpages
	    FROM dossier_projet dp,
	    	ligne_bip lb
	    WHERE dp.ACTIF = 'O'
	    and lb.CLICODE in (
	    	select clicoderatt
	    	from vue_clicode_hierarchie
	    	where clicode = p_clicode )
	    and dp.DPCODE = lb.DPCODE;
	 
	    SELECT clisigle INTO p_clisigle
	    FROM client_mo
	    WHERE clicode = p_clicode;
	   
	    IF (l_nbpages = 0) THEN
	       pack_global.recuperer_message( 20373 , '%s1', p_clicode, 'clicode', l_msg);
	       raise_application_error(-20373 , l_msg);
	     ELSIF (l_nbpages > NB_LIGNES_MAXI) THEN
	       pack_global.recuperer_message( 20381 , '%s1', p_clicode, 'clicode', l_msg);
	       raise_application_error(-20381 , l_msg);
	     END IF;
	
	     l_nbpages := CEIL(l_nbpages/NB_LIGNES_PAGES);
	     p_nbpages := 'NbPages#'|| l_nbpages;
	EXCEPTION
	   WHEN NO_DATA_FOUND THEN
	       pack_global.recuperer_message( 20373 , '%s1', p_clicode, 'clicode', l_msg);
	       raise_application_error(-20373 , l_msg);
	
	   WHEN OTHERS THEN
	     raise_application_error( -20997, SQLERRM);

      p_message := l_msg;
      
  END select_budactjh;

  PROCEDURE update_budactjh(		p_string    IN  VARCHAR2,
                              		p_nbcurseur OUT INTEGER,
                              		p_message   OUT VARCHAR2
                             	) IS

   l_msg    	VARCHAR2(10000);
   l_cpt    	NUMBER(7);
   l_annee  	budget_dp.annee%TYPE;
   l_dpcode    	budget_dp.dpcode%TYPE;
   l_clicode  	budget_dp.clicode%TYPE;
   l_budgethtr  budget_dp.budgethtr%TYPE;
   l_exist 	NUMBER;

   BEGIN
   
      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message   := '';
      -- Prise en compte de l'année
      l_cpt       := 1;
      l_annee := TO_NUMBER(pack_budactjh.str_budactjh(p_string,l_cpt));
      -- Prise en compte de du clicode
      l_cpt       := 2;
      l_clicode := TO_NUMBER(pack_budactjh.str_budactjh(p_string,l_cpt));
      -- Position de départ pour la boucle
      l_cpt       := 3;

      WHILE l_cpt != 0 LOOP
      
	l_dpcode := pack_budactjh.str_budactjh(p_string,l_cpt);
        l_budgethtr := TO_NUMBER(NVL(pack_budactjh.str_budactjh(p_string,l_cpt+1),-1));
	
	IF l_dpcode != '-1' THEN
	        IF l_budgethtr != '-1' THEN
		   	
		  -- Existence de la ligne dans budget_dp
	             BEGIN
			select 1 into l_exist
			from budget_dp
			where clicode = l_clicode
			and annee = l_annee
			and dpcode = l_dpcode;
	             EXCEPTION
			WHEN NO_DATA_FOUND THEN 
			--Création de la ligne dans la table BUDGET_DP
			INSERT INTO budget_dp (annee, dpcode, clicode, budgethtr)
			VALUES (l_annee,
				l_dpcode,
				l_clicode,
				l_budgethtr);
	
		     END;
	
		    IF l_exist=1 THEN
			 --Mise à jour de la table budget_dp
	             	UPDATE budget_dp SET 
	                        	budgethtr  = l_budgethtr
	             	where clicode = l_clicode
			and annee = l_annee
			and dpcode = l_dpcode;
		
		     END IF;

		END IF;
		-- pris en compte de l'année au début de la chaîne {;annee;clicode;dpcode;budgethtr;..;}
		l_cpt := l_cpt + 2;
         ELSE
            l_cpt :=0;
         END IF;
	 dbms_output.put_line('l_cpt:'||l_cpt);
      END LOOP; 
     
   pack_global.recuperer_message( 20972 , '%s1', 'Budget de l''année', '', p_message);

   END update_budactjh;
END pack_budactjh;
/