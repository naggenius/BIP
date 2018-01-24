-- pack_utile3A PL/SQL
--
-- equipe SOPRA
--
-- cr�e le 10/01/2000
-- Package fonctions utilitaires
--
-- Attention le PRAGMA restrict_references doit etre declare juste apr�s la fonction !!!
--
-- Quand    Qui  Nom                   	Quoi
-- -------- ---  --------------------  	----------------------------------------
-- 25/01/00 HTM  f_verif_pid_ligne_bip 	Fonction v�rifiant existence PID  dans table LIGNE_BIP  
-- 25/01/00 HTM  f_verif_factpid_proplus  Fonction v�rifiant existence FACTPID  dans table PROPLUS
-- 17/01/00 HT   verif_date_codsg_edipara Proc v�rifiant Date et Code DPT/POLE/GROUPE saisis pour editions param�tr�es 
-- 17/01/00 HT   f_verif_dpg_edipara   	Fonction testant si Code DPT/POLE/GROUPE saisi pour editions param�tr�es existe  
-- 12/01/00 QHL  f_verif_user_deppole  	fonction retourne vrai-faux suivant le codsg de l'user
-- 12/01/00 QHL  select_verif_deppole_mens    proc verifier habilitation dep/pole lors de l'�dition mensuelle
--                                     	autorise que DEP = '**'
-- 28/12/99 QHL habili_user_deppole   	proc verifier habilitation DEP/POLE du User pour les edit REFPCA4x
--                                     	DEP est obligatoire
-- 01/12/00 NCM habili_user_deppole     v�rification existence du DPG complet
--
-- 05/06/02 ODU suppression de f_verif_user_deppole qui utilisait userbip.pole1 ... pole9
--		suppression de habili_user_deppole qui utilisait f_verif_user_deppole
--		suppression de select_verif_deppole_mens qui utilisait f_verif_user_deppole
-- 03/06/02 PJO Migration Codes DPG     On passe � 7 caract�res


CREATE OR REPLACE PACKAGE pack_utile3A IS 
   -- ------------------------------------------------------------------------
   -- Nom        : f_verif_dpg_edipara
   -- Auteur     : Equipe SOPRA (HT) 
   -- Decription : v�rification existence Dpt/P�le/Groupe dans table des DPG  
   -- Param�tres : 
   --              p_codsg IN            Code DPG
   -- Retour     : renvoie TRUE si on trouve le code DPG 
   --	          	FALSE sinon
   -- 
   -- Remarque : P_codsg peut �tre de l'une des formes ci-dessous (n d�signant 1 entier quelconque) : 
   --            'nnnnnnn'
   --            '*******', '       ', 
   --            'nnn****', 'nnn    ',  
   --            'nnnnn**', 'nnnnn  ' 
   --            EN PRINCIPE, l'�cran de saisie EDIPARA n'autorise que les CODSG sur 7 positions
   --             
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_verif_dpg_edipara(p_codsg IN VARCHAR2) RETURN BOOLEAN;



   -- ------------------------------------------------------------------------
   --
   -- Nom        : verif_date_codsg_edipara
   -- Auteur     : Equipe SOPRA 
   -- Decription : V�rification des param�tres Date et Code Dpt/P�le/Groupe des �ditions param�tr�es
   -- Param�tres : 
   --              p_mois_annee (IN)		Mois et Ann�e trait�e 
   --              p_codsg      (IN) 		Code DPG
   --		    P_message OUT             Message de sortie
   -- 
   -- Remarque :  
   --             
   -- ------------------------------------------------------------------------   

   PROCEDURE verif_date_codsg_edipara( 
                 p_mois_annee IN  VARCHAR2,	     -- CHAR(7) (Format MM/AAAA)
                 p_codsg IN  VARCHAR2,               -- CHAR(7)
                 P_message OUT VARCHAR2
                 );


   -- ------------------------------------------------------------------------
   -- Nom        : f_verif_factpid_proplus
   -- Auteur     : Equipe SOPRA (HT) 
   -- Decription : v�rification existence FACTPID  dans table PROPLUS  
   -- Param�tres : 
   --              p_factpid IN            Code projet
   -- Retour     : renvoie TRUE si on trouve le code projet
   --	          	FALSE sinon
   -- 
   -- Remarque : 
   --             
   -- Quand    	Qui  	Quoi
   -- -----    	---  	--------------------------------------------------------
   --
   -- ------------------------------------------------------------------------
   FUNCTION  f_verif_factpid_proplus(p_factpid  IN proplus.factpid%TYPE) RETURN BOOLEAN ;


   -- ------------------------------------------------------------------------
   -- Nom        : f_verif_pid_ligne_bip
   -- Auteur     : Equipe SOPRA (HT) 
   -- Decription : v�rification existence PID  dans table LIGNE_BIP  
   -- Param�tres : 
   --              p_pid IN            Code projet
   -- Retour     : renvoie TRUE si on trouve le code projet
   --	          	FALSE sinon
   -- 
   -- Remarque : 
   --             
   -- Quand    	Qui  	Quoi
   -- -----    	---  	--------------------------------------------------------
   --
   -- ------------------------------------------------------------------------
   FUNCTION  f_verif_pid_ligne_bip(p_pid  IN ligne_bip.pid%TYPE) RETURN BOOLEAN ;

END pack_utile3A;
/

CREATE OR replace PACKAGE BODY pack_utile3A IS 

   -- **********************************************************************
   --
   -- Nom        : f_verif_dpg_edipara 
   -- Auteur     : Equipe SOPRA (HT)
   -- Decription : v�rification existence Dpt/P�le/Groupe dans table des DPG (struct_info) 
   -- Param�tres : 
   --              p_codsg IN            Code DPG
   -- Retour     : renvoie TRUE si on trouve le code DPG 
   --	          	FALSE sinon
   -- 
   -- Remarque : P_codsg peut �tre de l'une des formes ci-dessous (n d�signant 1 entier quelconque) : 
   --            'nnnnnnn'
   --            '*******', '       ', 
   --            'nnn****', 'nnn    ',  
   --            'nnnnn**', 'nnnnn  ' 
   --            EN PRINCIPE, l'�cran de saisie EDIPARA n'autorise que les CODSG sur 7 positions
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- **********************************************************************
   FUNCTION f_verif_dpg_edipara(p_codsg IN VARCHAR2) RETURN BOOLEAN IS
	l_car_meta_etoile CONSTANT CHAR(1) := '*';
	l_car_meta_blanc  CONSTANT CHAR(1) := ' ';
			   
   BEGIN
      
         
      BEGIN

		IF ( (p_codsg IS NULL)
				OR
			(p_codsg = l_car_meta_etoile || l_car_meta_etoile || l_car_meta_etoile || l_car_meta_etoile 
					|| l_car_meta_etoile || l_car_meta_etoile || l_car_meta_etoile
			)
				OR
			(p_codsg = l_car_meta_blanc || l_car_meta_blanc || l_car_meta_blanc || l_car_meta_blanc 
					|| l_car_meta_blanc || l_car_meta_blanc || l_car_meta_blanc
                  )
		   ) THEN
			-------------------------------------------------------------------------------------------
			-- CAS : p_codsg NULL ou �gal � 7 �toiles ou 7 blancs : 
			-- On veut traiter tous les Dpt/P�le/Groupe : FAUT DONC RETOURNER VRAI !!!
			------------------------------------------------------------------------------------------		
			RETURN(TRUE);
		ELSE  
			-------------------------------------------------------------------------------------------
			-- CAS AUTRE: Appel � la fonction  pack_utile.f_verif_dpg
			------------------------------------------------------------------------------------------		
			IF ( pack_utile.f_verif_dpg(p_codsg) = TRUE )
			THEN
				RETURN(TRUE);
			ELSE
				RETURN(FALSE);
			END IF;

		END IF;
		
      END;

   END f_verif_dpg_edipara;





   -- ------------------------------------------------------------------------
   --
   -- Nom        : verif_prodeta
   -- Auteur     : Equipe SOPRA 
   -- Decription : V�rification des param�tres saisis pour l'etat $PRODETA
   -- Param�tres : 
   --              p_mois_annee (IN)		Mois et Ann�e trait�e 
   --              p_codsg      (IN) 		Code DPG
   --		    P_message OUT             Message de sortie
   -- 
   -- Remarque :  
   --             
   -- ------------------------------------------------------------------------   

PROCEDURE verif_date_codsg_edipara ( 
                 p_mois_annee IN  VARCHAR2,	     -- CHAR(7) (Format MM/AAAA)
                 p_codsg IN  VARCHAR2,               -- CHAR(7)
                 P_message OUT VARCHAR2
                 ) IS 

      l_message   VARCHAR2(1024) := '';
      l_num_exception NUMBER;
	-- nuexc_coddpg_invalide3    CONSTANT NUMBER := 20430; --  Code D�partement/P�le/Groupe %s1 invalide 
	l_nuexc_date_sup_dat_cour CONSTANT NUMBER := 20603;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
	l_nuexc_mois_trop_ancien CONSTANT NUMBER := 20605;

	l_mois_annee_du_jour VARCHAR2(7);  		-- Date jour au format MM/YYYY


BEGIN

   BEGIN

		-----------------------------------------------------------------------------
		-- R�cup�ration date du jour !
		-----------------------------------------------------------------------------
		SELECT TO_CHAR(sysdate, 'MM/YYYY') INTO l_mois_annee_du_jour FROM dual;
		
		EXCEPTION
	 		WHEN OTHERS THEN
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
   END;


   BEGIN

	---------------------------------------------------------------------------------------------
	-- (1) V�rification Si Date saisie <= Date Syst�me
	---------------------------------------------------------------------------------------------
	IF ( TO_DATE('01/' || p_mois_annee, 'DD/MM/YYYY') > TO_DATE('01/' || l_mois_annee_du_jour , 'DD/MM/YYYY') ) 
	THEN
		pack_global.recuperer_message(l_nuexc_date_sup_dat_cour , NULL, NULL , ' P_param6 ', l_message);
            l_num_exception := l_nuexc_date_sup_dat_cour;      	
	END IF;

	---------------------------------------------------------------------------------------------
	-- (2) V�rification Si Date saisie >= Date Syst�me - 14 mois
	---------------------------------------------------------------------------------------------
	IF (l_message IS NULL) 
	THEN
		IF ( TO_DATE('01/' || p_mois_annee, 'DD/MM/YYYY') 
				< 
	     		ADD_MONTHS( TO_DATE('01/' || l_mois_annee_du_jour , 'DD/MM/YYYY'), -14 )  
	    	    ) 
		THEN
			pack_global.recuperer_message(l_nuexc_mois_trop_ancien, NULL, NULL , ' P_param6 ', l_message);
            	l_num_exception := l_nuexc_mois_trop_ancien;      	
		END IF;
	END IF;

	---------------------------------------------------------------------------------------------
	-- (3) V�rification existence Code DPG dans la table des DPG (Table struct_info)
	---------------------------------------------------------------------------------------------
	IF (l_message IS NULL) 
	THEN   
		IF ( pack_utile3A.f_verif_dpg_edipara(p_codsg) = FALSE ) 
		THEN
                  pack_global.recuperer_message(pack_utile_numsg.nuexc_coddpg_invalide3, '%s1', 
                                                p_codsg, ' P_param7 ', l_message);
                  l_num_exception := pack_utile_numsg.nuexc_coddpg_invalide3;    
		END IF;  
      END IF;

      p_message := l_message;

      IF (l_message IS NOT NULL) THEN
          RAISE_APPLICATION_ERROR(-l_num_exception, l_message);
      END IF;

   END;

END verif_date_codsg_edipara;





   -- **********************************************************************
   -- Nom        : f_verif_factpid_proplus
   -- Auteur     : Equipe SOPRA (HT) 
   -- Decription : v�rification existence FACTPID  dans table PROPLUS  
   -- Param�tres : 
   --              p_factpid IN            Code projet
   -- Retour     : renvoie TRUE si on trouve le code projet
   --	          	FALSE sinon
   -- 
   -- Remarque : 
   --             
   -- Quand    	Qui  	Quoi
   -- -----    	---  	--------------------------------------------------------
   -- 25/01/00  	HTM  	Cr�ation
   --
   -- **********************************************************************
   FUNCTION f_verif_factpid_proplus(p_factpid   IN proplus.factpid%TYPE) RETURN BOOLEAN IS
      l_count NUMBER := 0;
   BEGIN
      
      BEGIN

         SELECT count(*) INTO l_count 
	      FROM   proplus
	      WHERE  factpid = p_factpid;

	      IF (l_count = 0)  THEN   RETURN false ;
	                        ELSE 	 RETURN true;
	      END IF ;

      EXCEPTION
	      WHEN OTHERS THEN  raise_application_error(-20997, sqlerrm);
      END;

   END f_verif_factpid_proplus;





   -- **********************************************************************
   -- Nom        : f_verif_pid_ligne_bip
   -- Auteur     : Equipe SOPRA (HT) 
   -- Decription : v�rification existence PID  dans table LIGNE_BIP  
   -- Param�tres : 
   --              p_pid IN            Code projet
   -- Retour     : renvoie TRUE si on trouve le code projet
   --	          	FALSE sinon
   -- 
   -- Remarque : 
   --             
   -- Quand    	Qui  	Quoi
   -- -----    	---  	--------------------------------------------------------
   -- **********************************************************************
   FUNCTION f_verif_pid_ligne_bip(p_pid   IN ligne_bip.pid%TYPE) RETURN BOOLEAN IS
      l_count NUMBER := 0;
   BEGIN
      
      BEGIN

         SELECT count(*) INTO l_count 
	      FROM   ligne_bip
	      WHERE  pid = p_pid;

	      IF (l_count = 0)  THEN   RETURN false ;
	                        ELSE 	 RETURN true;
	      END IF ;

      EXCEPTION
	      WHEN OTHERS THEN  raise_application_error(-20997, sqlerrm);
      END;
   END f_verif_pid_ligne_bip;


 
END pack_utile3A;
/
