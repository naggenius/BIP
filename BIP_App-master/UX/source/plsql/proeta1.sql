-- -------------------------------------------------------------------
-- pack_verif_proeta1 PL/SQL
--
-- equipe SOPRA (HT)
--
-- crée le 23/02/2000
--
-- Package qui sert à la réalisation de l'état PROETA1/PCA4
--                   
-- -------------------------------------------------------------------

-- SET SERVEROUTPUT ON SIZE 1000000;

CREATE OR REPLACE PACKAGE pack_verif_proeta1  AS

   --
   -- Nom        : f_reserve
   -- Auteur     : Equipe SOPRA (HT)
   -- Paramètres : 
   --              p_factpid (IN)         
   --			 p_soci(IN)     'SG ou SSII' soc. des ressources
   --              p_type (IN)    'M ou A' mensuel ou annuel  
   --              p_moisannee (IN)  Ex. : 01/04/1999             
   -- ---------------------------------------------------------------
   FUNCTION f_reserve(
			    p_pid             IN VARCHAR2,
			    p_annee	      IN VARCHAR2
			    ) RETURN NUMBER;

  PRAGMA restrict_references(f_reserve, WNDS);

-- **************************************************************************************
-- Nom 		: habili_direction
-- Auteur 	: NBM
-- Description 	: Vérifie si l'utilisateur est habilité à la direction 
--		  
-- Paramètres 	: p_codperime (IN) code périmètre de l'utilisateur
--		  p_direction (IN) code direction sur 2 caractères
-- Retour	: message d'erreur si non habilitation
--
-- **************************************************************************************
  PROCEDURE habili_direction(	p_perime    IN  VARCHAR2,
				p_direction IN  VARCHAR2,
				p_message   OUT VARCHAR2) ;

-- **************************************************************************************
-- Nom 		: habili_branche
-- Auteur 	: NBM
-- Description 	: Vérifie si l'utilisateur est habilité à la branche
--		  
-- Paramètres 	: p_codperime (IN) code périmètre de l'utilisateur
--		  p_branche (IN) code branche sur 2 caractères
-- Retour	: message d'erreur si non habilitation
--
-- **************************************************************************************
  PROCEDURE habili_branche(	p_perime  IN VARCHAR2,
				p_branche IN VARCHAR2,
				p_message OUT VARCHAR2) ;

-- ************************************************************************************************
-- Nom 		: verif_proeta1
-- Auteur 	: NBM
-- Description 	: Vérifie si l'utilisateur est habilité au BDDPG et l'existence des codes saisis
--		  
-- Paramètres 	: p_codperime (IN) code périmètre de l'utilisateur
--		  p_direction(IN) code direction sur 2 caractères
-- Retour	: message d'erreur si non habilitation
--
-- ************************************************************************************************
  PROCEDURE verif_proeta1(
			p_nomproj   IN  VARCHAR2,
			p_branche   IN  VARCHAR2,
			p_direction IN  VARCHAR2,
			p_codsg     IN  VARCHAR2,
			p_global    IN  VARCHAR2, 
                        p_message   OUT VARCHAR2
			);
END pack_verif_proeta1;
/

CREATE OR REPLACE PACKAGE BODY pack_verif_proeta1  AS 
-- ---------------------------------------------------

FUNCTION f_reserve(
			   p_pid         IN VARCHAR2,
			   p_annee	 IN VARCHAR2
			)
			     RETURN NUMBER IS
      
	montant1 number;
	montant2 number;
	l_datdebex date;
	
BEGIN
	select datdebex into l_datdebex from datdebex;

	select reserve,bpmontme into montant1,montant2 
		from budget 
		where	pid = p_pid
			and annee=p_annee;
	
	if p_annee = to_char(l_datdebex,'YYYY') then 
		if montant1 is null then
			return 0;
		else
			return(montant1);
		end if;
	else
	if p_annee = to_char(add_months(l_datdebex,12),'YYYY') then
		if montant2 is null then
			return 0;
		else
			return(montant2);
		end if;
	else 
		return 0;
	end if;
	
	end if;

 
	EXCEPTION
		WHEN no_data_found THEN return 0;
		WHEN others THEN return 0;

END f_reserve;

-- ******************************************************************************************************************
-- Nom 		: habili_direction
-- Auteur 	: NBM
-- Description 	: Vérifie si l'utilisateur est habilité à la direction 
--		  
-- Paramètres 	: p_codperime (IN) code périmètre de l'utilisateur
--		  p_direction (IN) code direction sur 2 caractères
-- Retour	: message d'erreur si non habilitation
--
-- ******************************************************************************************************************
 PROCEDURE habili_direction(	p_perime    IN  VARCHAR2,
				p_direction IN  VARCHAR2,
				p_message   OUT VARCHAR2) IS
   l_coddir  number;


   BEGIN
		
	select 1 into l_coddir
	from vue_dpg_perime 
	where INSTR(p_perime, codbddpg) > 0
	and codhabili='dir'
	and substr(codbddpg,3,2)=LPAD(p_direction, 2, '0');

   EXCEPTION
	WHEN NO_DATA_FOUND THEN --Vous n'êtes pas habilité à cette direction
		pack_global.recuperer_message(20364,'%s1', 'à cette direction','P_param9', p_message);
              	raise_application_error(-20364,p_message);
		
			

 END habili_direction;

-- ******************************************************************************************************************
-- Nom 		: habili_branche
-- Auteur 	: NBM
-- Description 	: Vérifie si l'utilisateur est habilité à la branche
--		  
-- Paramètres 	: p_codperime (IN) code périmètre de l'utilisateur
--		  p_branche (IN) code branche sur 2 caractères
-- Retour	: message d'erreur si non habilitation
--
-- *******************************************************************************************************************
  PROCEDURE habili_branche(	p_perime    IN  VARCHAR2,
				p_branche   IN  VARCHAR2,
				p_message   OUT VARCHAR2) IS
  l_codbr  number;


   BEGIN
		
	select 1 into l_codbr
	from vue_dpg_perime
	where INSTR(p_perime, codbddpg) > 0
	and codhabili='br'
	and substr(codbddpg,1,2)=LPAD(p_branche, 2, '0');

   EXCEPTION
	WHEN NO_DATA_FOUND THEN --Vous n'êtes pas habilité à cette branche
		pack_global.recuperer_message(20364,'%s1', 'à cette branche','P_param8', p_message);
              	raise_application_error(-20364,p_message);
		
			

 END habili_branche;
-- *******************************************************************************************************************
-- Nom 		: verif_proeta1
-- Auteur 	: NBM
-- Description 	: Vérifie si l'utilisateur est habilité au BDDPG et l'existence des codes saisis
--		  
-- Paramètres 	: p_codperime (IN) code périmètre de l'utilisateur
--		  p_direction(IN) code direction sur 2 caractères
-- Retour	: message d'erreur si non habilitation
--
-- ******************************************************************************************************************
PROCEDURE verif_proeta1(
			p_nomproj   IN VARCHAR2,
			p_branche   IN VARCHAR2,
			p_direction IN VARCHAR2,
			p_codsg     IN VARCHAR2,
			p_global    IN VARCHAR2, 
                        p_message   OUT VARCHAR2
			)
IS
			
      l_msg       VARCHAR2(512);
      l_coddir    struct_info.coddir%TYPE;
      l_codbr     directions.codbr%TYPE;
      l_perimetre VARCHAR2(1000);
    
   BEGIN
      -- Initialiser le message retour
      	p_message := '';
	
      -- Récupérer le code user (idarpege)
      	l_perimetre := pack_global.lire_globaldata(p_global).perime;

	IF p_branche!='**' THEN     -- Branche renseignée
	    IF p_direction!='**' THEN  --Direction renseignée
		IF p_codsg!='*******' THEN  --Codsg renseigné
			-- Vérifier que le codsg existe et appartient bien à la direction et à la branche
			If ( pack_utile.f_verif_dpg(LPAD(p_codsg, 7, '0'))= false ) then -- Message Dep/pole inconnu	      
				pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               			raise_application_error(-20203,l_msg);
     			End if;
			BEGIN
				select distinct d.coddir,d.codbr into l_coddir, l_codbr
				from struct_info s,directions d
				where s.coddir=d.coddir
				and substr(to_char(codsg,'FM0000000'),1, length(rtrim(rtrim(LPAD(p_codsg, 7, '0'),'*')))) = rtrim(rtrim(LPAD(p_codsg, 7, '0'),'*'))
				and topfer='O'
				and rownum<2;
				
			EXCEPTION
				WHEN NO_DATA_FOUND THEN -- Le codsg n'est rattaché à aucune direction
					pack_global.recuperer_message(20356,'%s1', 'DPG', NULL, l_msg);
              	 			raise_application_error(-20356,l_msg);

			END;
			If l_codbr!=to_number(p_branche) Then  --'%s1 n'appartient pas %s2 mais %s3'
				-- Le codsg n'appartient pas à la branche p_branche mais à l_codbr
				pack_global.recuperer_message(20362, '%s1', 'Le DPG','%s2',
				'à la branche '||p_branche,'%s3','à la branche '||LPAD(l_codbr,2,0),'P_param8', l_msg);                            
               			raise_application_error(-20362,l_msg);

			End if;
			If l_coddir!=to_number(p_direction) Then
			-- Le codsg n'appartient pas à la direction p_direction mais à l_coddir
				pack_global.recuperer_message(20362, '%s1', 'Le DPG','%s2',
				'à la direction '||p_direction,'%s3','à la direction'||LPAD(l_coddir,2,0),'P_param9',l_msg);                            
               			raise_application_error(-20362,l_msg);
			End if;
			-- **************************************************
			-- Vérifier l'habilitation de l'utilisateur au DPG
			-- **************************************************                 
			pack_habilitation.verif_habili_me(p_codsg,p_global,l_msg);

		ELSE --toute la direction
			--Vérifier l'existence de la direction et de la branche
			BEGIN
				select coddir, codbr into l_coddir, l_codbr
				from directions d
				where coddir=to_number(p_direction);
			EXCEPTION
				WHEN NO_DATA_FOUND THEN --Direction inexistante
					pack_global.recuperer_message(20363,'%s1', 'Direction','P_param9', l_msg);
              	 			raise_application_error(-20363,l_msg);
			END;
			If l_codbr!=to_number(p_branche) Then
			-- La direction n'appartient pas à la branche
				pack_global.recuperer_message(20362, '%s1', 'La direction','%s2',
				'à la branche '||p_branche,'%s3','à la branche '||LPAD(l_codbr,2,0),'P_param8', l_msg);                            
               			raise_application_error(-20362,l_msg);

			End if;
			-- ***************************************************
			-- Habilitation de l'utilisateur à toute la direction
			-- ***************************************************
			habili_direction(l_perimetre,p_direction ,l_msg );

		END IF;
	    ELSE  -- Toute la branche
		BEGIN
			select codbr into l_codbr
			from branches
			where codbr=to_number(p_branche);
		EXCEPTION
				WHEN NO_DATA_FOUND THEN --Branche inexistante
					pack_global.recuperer_message(20363,'%s1', 'Branche','P_param8', l_msg);
              	 			raise_application_error(-20363,l_msg);
		END;
 	  	-- ***************************************************
		-- Habilitation de l'utilisateur à toute la branche
		-- ***************************************************
		habili_branche(l_perimetre,p_branche ,l_msg );

	    END IF;
	ELSE --Branche **
		IF p_direction='**' THEN
			IF p_codsg='*******' THEN   -- Toute la BIP
				-- *******************************************************
				--Vérifier que l'utilisateur est habilité à toute la BIP
				-- ******************************************************
				pack_habilitation.verif_habili_me(p_codsg,p_global,l_msg);

			ELSE
				-- Existence du codsg
				If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu	      
				pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               			raise_application_error(-20203,l_msg);
     				End if;
				-- ***************************************************
				-- Habilitation de l'utilisateur au codsg
				-- ***************************************************
				pack_habilitation.verif_habili_me(p_codsg,p_global,l_msg);
			END IF;
		ELSE 
			IF p_codsg='*******' THEN --Toute la direction
				-- Existence de la direction	
				BEGIN
				 	select coddir into l_coddir
				 	from directions d
				 	where coddir=to_number(p_direction);
				EXCEPTION
				WHEN NO_DATA_FOUND THEN --Direction inexistante
					pack_global.recuperer_message(20363,'%s1', 'Direction','P_param9', l_msg);
              	 			raise_application_error(-20363,l_msg);
				END;
				-- ***************************************************
				-- Habilitation de l'utilisateur à toute la direction
				-- ***************************************************
				habili_direction(l_perimetre,p_direction ,l_msg );

			ELSE  -- Codsg 
				-- vérifier l'appartenance du codsg à la direction
				BEGIN
					select  coddir into l_coddir
					from struct_info 
					where 
			        	substr(to_char(codsg,'FM0000000'),1, length(rtrim(rtrim(LPAD(p_codsg, 7, '0'),'*')))) = rtrim(rtrim(LPAD(p_codsg, 7, '0'),'*'))
					and topfer='O'
					and rownum<2;
				EXCEPTION
					WHEN NO_DATA_FOUND THEN --codsg inexistant
					pack_global.recuperer_message(20225, '%s1', 'DPG', 'P_param7', l_msg);
               				raise_application_error(-20225,l_msg);
				END;
				If l_coddir!=to_number(p_direction) Then
				-- Le codsg n'appartient pas à la direction p_direction mais à l_coddir
				pack_global.recuperer_message(20362, '%s1', 'Le DPG','%s2','à la direction '||p_direction,
						'%s3','à la direction '||LPAD(l_coddir,2,0),'P_param9',l_msg);                            
               			raise_application_error(-20362,l_msg);
				End if;
				-- ***************************************************
				-- Habilitation de l'utilisateur au codsg
				-- ***************************************************
				pack_habilitation.verif_habili_me(p_codsg,p_global,l_msg);

			END IF;
		END IF;
	END IF;

  --pack_habilitation.verif_habili_me(p_codsg,p_global,l_msg);

 
END verif_proeta1;

END pack_verif_proeta1;
/
