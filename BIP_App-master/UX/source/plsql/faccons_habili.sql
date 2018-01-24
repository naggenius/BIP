-- pack_faccons_habili
-- 
-- crée le 15/11/2002 par MMC
--
-- objet: gestion des habilitations des utilisateurs au niveau Branche/Direction/Département/Pôle/Groupe
-- replique d 1 PROCEDURE du pack_habilitation : necessaire au passage de parammetre pour les editions faccons
-- Attention le nom du package ne peut etre le nom de la table...

CREATE or REPLACE PACKAGE pack_faccons_habili AS
-- **************************************************************************************
-- Nom 		: verif_habili_me
-- Auteur 	: MMC
-- Description 	: Vérifie si l'utilisateur est habilité au BDDPG 
--		  en vérifiant d'abord l'existence du code DPG demandé
--		  ( pack_utile.f_verif_dpg(p_codsg)= true or false )
-- Paramètres 	: p_codsg (IN) code DPG demandé (016**** ou 01616** ou 161612)
--		  p_annee (IN) annee courante ou precedente
--		  p_global (IN) contenant le code périmètre de l'utilisateur
-- Retour	: message d'erreur si non habilitation
--
-- **************************************************************************************
  PROCEDURE verif_habili_me ( 	p_codsg   IN  VARCHAR2,
  				p_annee   IN  VARCHAR2,
				p_global  IN  VARCHAR2,
				p_message OUT VARCHAR2 );

END pack_faccons_habili;
/


CREATE or REPLACE PACKAGE BODY pack_faccons_habili AS
  PROCEDURE verif_habili_me ( 	p_codsg   IN  VARCHAR2,
  				p_annee   IN  VARCHAR2,
				p_global  IN  VARCHAR2,
				p_message OUT VARCHAR2 ) IS

 -- Création du curseur qui ramène tous les BDDPG du périmètre de l'utilisateur
   CURSOR cur_bddpg (p_perimetre IN VARCHAR2) IS
	select codbddpg, codhabili
	from vue_dpg_perime
	where INSTR(p_perimetre, codbddpg) > 0
	order by codbddpg;

  l_perimetre 	VARCHAR2(1000);
  l_branche 	varchar2(2);
  l_direction 	varchar2(2);
  l_departement varchar2(7);
  l_pole 	varchar2(5);
  l_groupe 	varchar2(7);
  c_branche 	varchar2(2);
  c_direction 	varchar2(2);
  c_departement varchar2(7);
  c_pole 	varchar2(5);
  c_groupe 	varchar2(7);
  l_dpg         varchar2(7);
  l_habilitation varchar2(6);
  l_msg         varchar2(1024);
  l_saisi 	varchar2(15);

  BEGIN
	l_msg:=p_message ;
	l_msg:='';
	l_habilitation := 'faux';
  -- **************************************************************
  -- 1) Vérification de l'existence du code DPG demandé
  -- ***************************************************************

      IF (p_codsg!='*******' )  THEN
	If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu	      
		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);
     	End if;
     END IF;
  -- *********************************************************************************
  -- 2) Vérification de l'habilitation de l'utilisateur par rapport à son périmètre
  -- *********************************************************************************
	-- Récupérer le perimetre du user
      	l_perimetre := pack_global.lire_globaldata(p_global).perime;

   	-- Remplacer les '*' du code DPG par des 0 et remet le code sur 7 caractères
	l_dpg := REPLACE(LPAD(p_codsg,7,'0'),'*','0');

	if substr(l_dpg,4,4)='0000' then --un département
		l_saisi :='dpt';
	else 
		if substr(l_dpg,6,2)='00' then --un pôle
			l_saisi :='pole';
		else
			if l_dpg!='0000000' then --un groupe
				l_saisi :='grpe';
			else 
				l_saisi :='bip';
			end if;
		end if;
	end if;


	-- Retrouver la direction et la branche du code DPG
     IF (p_codsg!='*******' )  THEN
	BEGIN
	  select distinct lpad(d.codbr,2,0), lpad(d.coddir,2,0)
		into l_branche     , l_direction
	  from struct_info s, directions d
	  where ( s.codsg=to_number(l_dpg) or s.coddeppole=to_number(substr(l_dpg,1,5)) or s.coddep=to_number(substr(l_dpg,1,3)) )
	  and s.coddir=d.coddir
	  and s.topfer='O';


	  l_departement := l_branche||l_direction||SUBSTR(l_dpg,1,3);
	  l_pole 	:= SUBSTR(l_dpg,1,5);
	  l_groupe 	:= l_dpg;

dbms_output.put_line(l_perimetre||', '||l_branche||', '||l_direction||', '||l_departement);
	EXCEPTION
		WHEN NO_DATA_FOUND THEN   --'Le codsg n''est rattaché à aucune direction'
			pack_global.recuperer_message(20356,'%s1', 'codsg', NULL, l_msg);
              	 	raise_application_error(-20356,l_msg);
	END;
     END IF;

	FOR rec_bddpg IN cur_bddpg(l_perimetre) LOOP

 	  c_branche 	:= SUBSTR(rec_bddpg.codbddpg,1,2);          	--03
	  c_direction 	:= SUBSTR(rec_bddpg.codbddpg,3,2);		--14
	  c_departement := SUBSTR(rec_bddpg.codbddpg,1,7);		--0314016
	  c_pole 	:= SUBSTR(rec_bddpg.codbddpg,5,5);		--01616
	  c_groupe 	:= SUBSTR(rec_bddpg.codbddpg,5,7);		--0161612

dbms_output.put_line(l_perimetre||', '||l_dpg||', '||c_branche||', '||c_direction||', '||c_departement||', '||c_pole||', '||c_groupe||', '||rec_bddpg.codhabili);
	  -- Cas où on veut tout (*******)
		if (l_saisi='bip' and rec_bddpg.codhabili='bip') then
	 		l_habilitation := 'vrai';
			exit;
		end if;

 	  -- ******************************************
          -- cas 1 : habilitation à toute la BIP
	  -- ******************************************	
		if rec_bddpg.codhabili='bip' then
			--dbms_output.put_line('Vous êtes habilité à toute la BIP  ');
			l_habilitation := 'vrai';
	
			exit;
		else
	  -- ******************************************
	  -- cas 2 : habilitation à toute une branche
	  -- ******************************************
		if rec_bddpg.codhabili='br' then
			if c_branche=l_branche then
			--dbms_output.put_line('Vous êtes habilité à toute la branche : '||l_branche);
				l_habilitation := 'vrai';	
				exit;
			end if;
		--dbms_output.put_line('Votre habilitation branche est  :'||c_branche||', et non : '||l_branche);
			
		else
	  -- ********************************************
	  -- cas 3 : habilitation à toute une direction
	  -- ********************************************
		if rec_bddpg.codhabili='dir' then
			if c_direction=l_direction then
			--dbms_output.put_line('Vous êtes habilité à toute la direction : '||l_direction);
				l_habilitation := 'vrai';
				exit;
			end if;
		--dbms_output.put_line('Votre habilitation direction est : '||c_direction||', et non :'||l_direction);

		else
	  -- ********************************************
	  -- cas 4 : habilitation à tout un département
	  -- ********************************************
		if rec_bddpg.codhabili='dpt' then
			if c_departement=l_departement then
			dbms_output.put_line('Vous êtes habilité à tout le departement : '||l_departement);
				l_habilitation := 'vrai';
				exit;
			end if;
		--dbms_output.put_line('Votre habilitation département est '||c_departement||', et non :'||l_departement);

		else
 	  -- ********************************************
	  -- cas 5 : habilitation à tout un pole
	  -- ********************************************
		if rec_bddpg.codhabili='pole' then
			if c_pole=l_pole then
			dbms_output.put_line('Vous êtes habilité à tout le pole : '||l_pole);
				l_habilitation := 'vrai';
				exit;
			end if;
		else
	  -- ********************************************
	  -- cas 6 : habilitation à un BDDPG complet
	  -- ********************************************

			if( c_groupe=l_groupe )then
				dbms_output.put_line('Vous êtes habilité au groupe : '||l_groupe);
				l_habilitation := 'vrai';
				exit;
		  	end if;
	                dbms_output.put_line('Votre habilitation groupe est '||c_groupe||', et non :'||l_groupe);

	        end if;
		end if;
		end if;
		end if;
		end if;

	END LOOP;
	 dbms_output.put_line(l_habilitation);
	If l_habilitation='faux' then  
		if ( length(rtrim(LPAD(p_codsg,7,'0'),'*'))=7 ) then 
		-- Vous n'êtes pas habilité à ce groupe
			pack_global.recuperer_message(20329, NULL, NULL, NULL, l_msg);
               		raise_application_error(-20329,l_msg);
		else 
		  if  ( length(rtrim(LPAD(p_codsg,7,'0'),'*'))=5 ) then 
		   -- Vous n'êtes pas habilité à ce pôle
		   	pack_global.recuperer_message(20328, NULL, NULL, NULL, l_msg);
               		raise_application_error(-20328,l_msg);
		  else
		     if  ( length(rtrim(LPAD(p_codsg,7,'0'),'*'))=3) then 		
		     -- Vous n'êtes pas habilité à ce département
			pack_global.recuperer_message(20327, NULL, NULL, NULL, l_msg);
               		raise_application_error(-20327,l_msg);
		     else
		     -- Vous n'êtes pas habilité à toute la BIP
			pack_global.recuperer_message(20357, NULL, NULL, NULL, l_msg);
               		raise_application_error(-20357,l_msg);
		     end if;
		  end if;
		end if;
	End if;
	

  END verif_habili_me;

END pack_faccons_habili;
/
show errors
