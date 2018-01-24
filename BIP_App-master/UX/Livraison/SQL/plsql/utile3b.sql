-- pack_utile3B PL/SQL @G:\Commun\Lot_Commun\PLSql\Utile3B.sql;
--
-- equipe SOPRA
--
-- crée le 21/01/2000
-- Package fonctions utilitaires
-- @G:\Commun\Lot_Commun\Plsql\Utile3B;
-- Attention le PRAGMA restrict_references doit etre declare juste après la fonction !!!
--
-- Quand    Qui  Nom                   		Quoi
-- -------- ---  --------------------  		----------------------------------------
-- 22/03/00 HTM  f_verif_airt_application		vérification existence Identifiant application (AIRT) dans table APPLICATION
-- 22/03/00 HTM  f_verif_icpi_proj_info		vérification existence Identifiant projet (ICPI) dans table PROJ_INFO
-- 16/02/00 HTM  f_get_top_immo_bip_clicode	Retourne le top_immo à partir du code client de ligne bip
-- 15/02/00 HTM  f_verif_existence_dpg    	Fonction testant existence Ligne BIP contenant DPG compris entre 2 bornes 
-- 14/02/00 HTM  f_get_clisigle_climo     	Renvoi le sigle Direction/Dpt d'un client MO en fonction du code client MO
-- 21/01/00 HTM  f_verif_pid_histo_amort  	Fonction testant si PID (Code projet) existe dans HISTO_AMORT  
-- 


CREATE OR REPLACE PACKAGE pack_utile3B IS 
-----------------------------------------

   -- ------------------------------------------------------------------------
   -- Nom        : f_verif_airt_application
   -- Auteur     : Equipe SOPRA (HTM) 
   -- Decription : vérification existence Identifiant application (AIRT) dans table APPLICATION  
   -- Paramètres : 
   --              p_airt IN            Identifiant Application
   -- Retour     : renvoie TRUE si on trouve l'identifiant
   --	          	FALSE sinon
   -- 
   -- Remarque : 
   --             
   -- Quand    	Qui  	Quoi
   -- -----    	---  	--------------------------------------------------------
   -- ------------------------------------------------------------------------
   FUNCTION f_verif_airt_application(p_airt  IN application.airt%TYPE) RETURN BOOLEAN;

   -- ------------------------------------------------------------------------
   -- Nom        : f_verif_icpi_proj_info
   -- Auteur     : Equipe SOPRA (HTM) 
   -- Decription : vérification existence Identifiant projet (ICPI) dans table PROJ_INFO  
   -- Paramètres : 
   --              p_icpi IN            Identifiant Projet
   -- Retour     : renvoie TRUE si on trouve l'identifiant
   --	          	FALSE sinon
   -- 
   -- Remarque : 
   --             
   -- Quand    	Qui  	Quoi
   -- -----    	---  	--------------------------------------------------------
   -- ------------------------------------------------------------------------
   FUNCTION f_verif_icpi_proj_info(p_icpi  IN proj_info.icpi%TYPE) RETURN BOOLEAN;



-- ------------------------------------------------------------------------
   -- Nom        : f_get_top_immo_bip_clicode
   -- Auteur     : Equipe SOPRA (HTM) 
   -- Decription : Retourne le top_immo à partir du code client de ligne bip  
   -- Paramètres : 
   --              p_clicode IN            Code client de la ligne BIP
   -- Retour     : Top_immo
   -- 
   -- Remarque : 
   --             
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
-- ------------------------------------------------------------------------
   FUNCTION f_get_top_immo_bip_clicode(p_clicode  IN ligne_bip.clicode%TYPE) RETURN VARCHAR2; 
		PRAGMA restrict_references(f_get_top_immo_bip_clicode, WNDS, WNPS);					   


-- ------------------------------------------------------------------------
   -- Nom        : f_verif_existence_dpg
   -- Auteur     : Equipe SOPRA (HTM) 
   -- Decription : Test existence Ligne BIP contenant DPG compris entre 2 bornes  
   -- Paramètres : 
   --              p_codsg_inf IN            Code DPG Inf
   --              p_codsg_sup IN            Code DPG Sup
   -- Retour     : TRUE Si existence, FALSE Sinon
   -- 
   -- Remarque : 
   --             
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
-- ------------------------------------------------------------------------
   FUNCTION f_verif_existence_dpg(p_codsg_inf IN ligne_bip.codsg%TYPE, 
					    p_codsg_sup ligne_bip.codsg%TYPE
					   ) RETURN BOOLEAN;
                                  
-- ------------------------------------------------------------------------
   -- Nom        : f_get_clisigle_climo
   -- Auteur     : Equipe SOPRA (HTM) 
   -- Decription : Renvoi le sigle Direction/Dpt d'un client MO en fonction du code client MO  
   -- Paramètres : 
   --              p_clicode IN            Code Client MO
   -- Retour     : Sigle Direction/Dpt d'un client MO en fonction du code client MO
   --	          	 ou chaîne vide si on ne trouve rien.
   -- 
   -- Remarque : 
   --             
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
-- ------------------------------------------------------------------------
   FUNCTION  f_get_clisigle_climo(p_clicode  IN client_mo.clicode%TYPE) RETURN VARCHAR2;
	PRAGMA restrict_references(f_get_clisigle_climo,WNDS, WNPS);


-- ------------------------------------------------------------------------
   -- Nom        : f_verif_pid_histo_amort
   -- Auteur     : Equipe SOPRA (HT) 
   -- Decription : vérification existence PID  dans table HISTO_AMORT  
   -- Paramètres : 
   --              p_pid IN            Code projet
   -- Retour     : renvoie TRUE si on trouve le code projet
   --	          	FALSE sinon
   -- 
   -- Remarque : 
   --             
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
-- ------------------------------------------------------------------------
   FUNCTION  f_verif_pid_histo_amort(p_pid  IN histo_amort.pid%TYPE) RETURN BOOLEAN ;


END pack_utile3B;
/

CREATE OR replace PACKAGE BODY pack_utile3B IS 
----------------------------------------------

   -- **********************************************************************
   -- Nom        : f_verif_airt_application
   -- Auteur     : Equipe SOPRA (HTM) 
   -- Decription : vérification existence Identifiant application (AIRT) dans table APPLICATION  
   -- Paramètres : 
   --              p_airt IN            Identifiant Application
   -- Retour     : renvoie TRUE si on trouve l'identifiant
   --	          	FALSE sinon
   -- 
   -- Remarque : 
   --             
   -- Quand    	Qui  	Quoi
   -- -----    	---  	--------------------------------------------------------
   -- **********************************************************************
   FUNCTION f_verif_airt_application(p_airt  IN application.airt%TYPE) RETURN BOOLEAN IS
      l_count NUMBER := 0;
   BEGIN
      
      BEGIN

         	SELECT count(*) INTO l_count 
	      FROM   application
	      WHERE  airt = p_airt;

	      IF (l_count = 0)  THEN   RETURN false ;
	                        ELSE 	 RETURN true;
	      END IF ;

      EXCEPTION
	      WHEN OTHERS THEN  raise_application_error(-20997, sqlerrm);
      END;

   END f_verif_airt_application;

   -- **********************************************************************
   -- Nom        : f_verif_icpi_proj_info
   -- Auteur     : Equipe SOPRA (HTM) 
   -- Decription : vérification existence Identifiant projet (ICPI) dans table PROJ_INFO  
   -- Paramètres : 
   --              p_icpi IN            Identifiant Projet
   -- Retour     : renvoie TRUE si on trouve l'identifiant
   --	          	FALSE sinon
   -- 
   -- Remarque : 
   --             
   -- Quand    	Qui  	Quoi
   -- -----    	---  	--------------------------------------------------------
   -- **********************************************************************
   FUNCTION f_verif_icpi_proj_info(p_icpi  IN proj_info.icpi%TYPE) RETURN BOOLEAN IS
      l_count NUMBER := 0;
   BEGIN
      
      BEGIN

         	SELECT count(*) INTO l_count 
	      FROM   proj_info
	      WHERE  icpi = p_icpi;

	      IF (l_count = 0)  THEN   RETURN false ;
	                        ELSE 	 RETURN true;
	      END IF ;

      EXCEPTION
	      WHEN OTHERS THEN  raise_application_error(-20997, sqlerrm);
      END;

   END f_verif_icpi_proj_info;



   -- **********************************************************************
   -- Nom        : f_get_filcode_clicode
   -- Auteur     : Equipe SOPRA (HTM) 
   -- Decription : Retourne le code filiale associé au code client en entrée
   -- Paramètres : 
   --              p_clicode IN            Code client 
   -- Retour     : Code filiale
   -- 
   -- Remarque : 
   --             
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- **********************************************************************
   FUNCTION f_get_filcode_clicode(p_clicode  IN ligne_bip.clicode%TYPE) RETURN VARCHAR2 IS
      l_ret VARCHAR2(10);

   BEGIN   

	SELECT fil.top_immo 
	INTO l_ret 
	FROM client_mo cmo, filiale_cli fil 
	WHERE cmo.clicode = p_clicode 
		AND fil.filcode = cmo.filcode;
	
      RETURN l_ret;

   EXCEPTION 
	WHEN OTHERS THEN  RETURN '';
	
   END f_get_filcode_clicode; 


   -- **********************************************************************
   -- Nom        : f_get_top_immo_bip_clicode
   -- Auteur     : Equipe SOPRA (HTM) 
   -- Decription : Retourne le top_immo à partir du code client de ligne bip  
   -- Paramètres : 
   --              p_clicode IN            Code client de la ligne BIP
   -- Retour     : Top_immo
   -- 
   -- Remarque : 
   --             
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- **********************************************************************
   FUNCTION f_get_top_immo_bip_clicode(p_clicode  IN ligne_bip.clicode%TYPE) RETURN VARCHAR2 IS
      l_ret VARCHAR2(10);

   BEGIN   

	SELECT fil.top_immo 
	INTO l_ret 
	FROM client_mo cmo, filiale_cli fil 
	WHERE cmo.clicode = p_clicode 
		AND fil.filcode = cmo.filcode;
	
      RETURN l_ret;

   EXCEPTION 
	WHEN OTHERS THEN  RETURN '';
	
   END f_get_top_immo_bip_clicode; 


   -- **********************************************************************
   -- Nom        : f_verif_existence_dpg
   -- Auteur     : Equipe SOPRA (HTM) 
   -- Decription : Test existence Ligne BIP contenant DPG compris entre 2 bornes  
   -- Paramètres : 
   --              p_codsg_inf IN            Code DPG Inf
   --              p_codsg_sup IN            Code DPG Sup
   -- Retour     : TRUE Si existence, FALSE Sinon
   -- 
   -- Remarque : 
   --             
   -- Quand    	Qui  	Quoi
   -- -----    	---  	--------------------------------------------------------
   -- **********************************************************************
   FUNCTION f_verif_existence_dpg(p_codsg_inf IN ligne_bip.codsg%TYPE, 
					    p_codsg_sup ligne_bip.codsg%TYPE
					   ) RETURN BOOLEAN IS
      l_count NUMBER := 0;
   BEGIN
      
      BEGIN

         SELECT count(*) INTO l_count 
	      FROM   ligne_bip
	      WHERE  codsg BETWEEN  p_codsg_inf AND p_codsg_sup;

	      IF (l_count = 0)  THEN   RETURN false ;
	                        ELSE 	 RETURN true;
	      END IF ;

      EXCEPTION
	      WHEN OTHERS THEN  raise_application_error(-20997, sqlerrm);
      END;

   END f_verif_existence_dpg;


   -- **********************************************************************
   -- Nom        : f_get_clisigle_climo
   -- Auteur     : Equipe SOPRA
   -- Decription : renvoie le département/pole, séparé par un '/'
   -- Paramètres : p_clicode (IN)     code Client MO
   --
   -- Retour     : Sigle Direction/Dpt d'un client MO en fonction du code client MO
   --	          	 ou chaîne vide si on ne trouve rien ou si erreur.
   -- 
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   --
   -- **********************************************************************
   FUNCTION  f_get_clisigle_climo(p_clicode  IN client_mo.clicode%TYPE)RETURN VARCHAR2 IS 
      -- l_ret VARCHAR2 (20);
	l_ret client_mo.clisigle%TYPE;

   BEGIN   
      SELECT  clisigle INTO l_ret 
	FROM client_mo
	WHERE clicode = p_clicode AND ROWNUM <= 1;
	
      RETURN l_ret;

   EXCEPTION 
	WHEN OTHERS THEN  RETURN '';
   END f_get_clisigle_climo;


   -- **********************************************************************
   -- Nom        : f_verif_pid_histo_amort
   -- Auteur     : Equipe SOPRA (HT) 
   -- Decription : vérification existence PID  dans table HISTO_AMORT  
   -- Paramètres : 
   --              p_pid IN            Code projet
   -- Retour     : renvoie TRUE si on trouve le code projet
   --	          	FALSE sinon
   -- 
   -- Remarque :   
   --             
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- **********************************************************************
   FUNCTION f_verif_pid_histo_amort(p_pid  IN histo_amort.pid%TYPE) RETURN BOOLEAN IS
      l_count NUMBER := 0;
   BEGIN
      
      BEGIN

         SELECT count(*) INTO l_count 
	      FROM   histo_amort
	      WHERE  pid = p_pid;

	      IF (l_count = 0)  THEN   RETURN false ;
	                        ELSE 	 RETURN true;
	      END IF ;

      EXCEPTION
	      WHEN OTHERS THEN  raise_application_error(-20997, sqlerrm);
      END;
   END f_verif_pid_histo_amort;


 
END pack_utile3B;
/
