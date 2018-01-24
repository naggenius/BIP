-- APPLICATION ISAC
-- -------------------------------------
-- pack_isac_tache PL/SQL
-- 
-- Créé le 28/03/2002 par NBM
-- Modifié le 28/07/2003 par NBM : suppression keyList2#
-- 10/02/2005 par MMC : ajout controle pour empecher la suppression des taches ayant des sous taches
--			ayant du consomme sur l annee courante
--
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

create or replace
PACKAGE pack_isac_tache AS

 TYPE tacheCurType IS REF CURSOR RETURN isac_tache%ROWTYPE;
                                      
PROCEDURE VERIFIER_TACHE_AXE_METIER ( p_tacheaxemetier IN ISAC_TACHE.tacheaxemetier%TYPE, 
                                      p_pid   IN  isac_tache.pid%TYPE,
                                      p_message OUT VARCHAR2,
                                      p_type OUT VARCHAR2,
                                      p_param_id OUT VARCHAR2);

PROCEDURE INITIALISER_TACHE_AXE_METIER ( p_pid   IN  isac_tache.pid%TYPE,
                                         p_tacheaxemetier OUT ISAC_TACHE.tacheaxemetier%TYPE);

PROCEDURE miseAVide ( type_msg   IN VARCHAR2, param_id IN VARCHAR2, p_userid IN VARCHAR2, p_message   OUT VARCHAR2 );

PROCEDURE delete_tache  (p_pid     	IN isac_tache.pid%TYPE,
			 p_etape 	IN VARCHAR2,
			 p_tache 	IN VARCHAR2,
			 p_userid     	IN VARCHAR2,
			 p_nbcurseur    OUT INTEGER,
                         p_message    	OUT VARCHAR2
                        );

PROCEDURE update_tache(	p_tache		IN VARCHAR2,
			p_pid     	IN isac_tache.pid%TYPE,
			p_etape 	IN VARCHAR2,
			p_acta		IN VARCHAR2,
			p_libtache	IN VARCHAR2,
			p_flaglock      IN VARCHAR2,
      p_tacheaxemetier  IN VARCHAR2,
			p_userid     	IN VARCHAR2,
      p_absence_param  IN VARCHAR2,
			p_nbcurseur    	OUT INTEGER,
                        p_message    	OUT VARCHAR2
			);

PROCEDURE select_tache (p_pid     	IN isac_tache.pid%TYPE,
			p_etape 	IN VARCHAR2,
			p_tache		IN VARCHAR2,
			p_userid     	IN VARCHAR2,
			p_curtache    	IN OUT tacheCurType,
			p_nbcurseur    	OUT INTEGER,
                        p_message    	OUT VARCHAR2
			  ) ;

PROCEDURE insert_tache(	p_pid     	IN isac_tache.pid%TYPE,
			p_etape 	IN VARCHAR2,
			p_acta		IN VARCHAR2,
			p_libtache	IN VARCHAR2,
      p_tacheaxemetier  IN VARCHAR2,
			p_userid     	IN VARCHAR2,
      p_absence_param  IN VARCHAR2,
			p_nbcurseur    	OUT INTEGER,
                        p_message    	OUT VARCHAR2
			);

PROCEDURE select_tache_suivante(p_pid     	IN isac_tache.pid%TYPE,
				p_etape 	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_acta		OUT VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                         	p_message    	OUT VARCHAR2
			    );




PROCEDURE select_liste_tache (	p_pid     	IN isac_tache.pid%TYPE,
				p_etape 	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_keylist2      OUT VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                         	p_message    	OUT VARCHAR2
			    );


END pack_isac_tache;

/
create or replace
PACKAGE  BODY pack_isac_tache AS

-- MCH, SEL : PPM 61919 chapitre 6.10 et 6.11.2 la procédure 'VERIFIER_DPCOPI_AXE_METIER' permet de controler le champ tacheaxemetier
PROCEDURE VERIFIER_TACHE_AXE_METIER ( p_tacheaxemetier IN ISAC_TACHE.tacheaxemetier%TYPE, 
                                      p_pid   IN  isac_tache.pid%TYPE,
                                      p_message OUT VARCHAR2,
                                      p_type OUT VARCHAR2,
                                      p_param_id OUT VARCHAR2) IS
    l_code_action LIGNE_PARAM_BIP.CODE_ACTION%TYPE;
    l_code_version LIGNE_PARAM_BIP.CODE_VERSION%TYPE;
    l_actif LIGNE_PARAM_BIP.ACTIF%TYPE;
    l_obligatoire LIGNE_PARAM_BIP.OBLIGATOIRE%TYPE;
    l_valeur LIGNE_PARAM_BIP.VALEUR%TYPE;
    l_bbrf VARCHAR2(3);
    l_bbrf_cli VARCHAR2(3);
    l_bbrf_dpg VARCHAR2(3);
    l_valeur_cli VARCHAR2(30);
    l_valeur_dpg VARCHAR2(30);
    l_param_local LIGNE_BIP.PZONE%TYPE;
    l_direction CLIENT_MO.CLIDIR%TYPE;
    l_dmpnum VARCHAR2(20);
    type_msg VARCHAR2(5);
    param_id VARCHAR2(20);
    l_retour VARCHAR(2) := 'OK';
    no_control EXCEPTION;
    
    BEGIN
      
      p_type := 'OK';
      p_message := 'valid';
      
      --Recherche du code direction selon le code client ou DPG
      BEGIN
      select CMO.clidir into l_direction from client_mo CMO, ligne_bip LB where LB.pid = p_pid and LB.clicode = CMO.clicode;
      
      select code_action, obligatoire, valeur  
          into l_code_action, l_obligatoire, l_valeur 
          from ligne_param_bip 
          where code_action = 'AXEMETIER_'||l_direction 
          and code_version = 'TAC'||(select trim(lpad(typproj,3,'0'))||arctype from ligne_bip where pid=p_pid)
          and actif = 'O';
     
      EXCEPTION
      WHEN NO_DATA_FOUND 
      THEN
        

          BEGIN

           select SI.coddir into l_direction from struct_info SI, ligne_bip LB where LB.pid = p_pid and LB.codsg = SI.codsg;
       
            select code_action, obligatoire, valeur  
            into l_code_action, l_obligatoire, l_valeur 
            from ligne_param_bip 
            where code_action = 'AXEMETIER_'||l_direction 
            and code_version = 'TAC'||(select trim(lpad(typproj,3,'0'))||arctype from ligne_bip where pid=p_pid)
            and actif = 'O';
             
          EXCEPTION
          WHEN NO_DATA_FOUND 
          THEN 
                p_type := 'N';
                p_message := 'absence'; 
                
          END;
          
      END;
      
      
      IF (p_message <> 'absence')  THEN  
      
      BEGIN
          
       
      IF(upper(l_obligatoire) = 'O' AND (p_tacheaxemetier IS NULL OR p_tacheaxemetier ='')) THEN
       
       pack_global.recuperer_message (21300, NULL, NULL, NULL, p_message);
       p_type := 'A';
       l_retour := 'KO';
      
      ELSE
      
        BEGIN
          select code_action, code_version, actif, obligatoire, valeur  
          into l_code_action, l_code_version,l_actif, l_obligatoire, l_valeur 
          from ligne_param_bip 
          where code_action = 'DIR-REGLAGES' and code_version = l_direction and actif = 'O';
          --DBMS_OUTPUT.PUT_LINE(l_code_action || ';;;' ||l_valeur );
        EXCEPTION
          WHEN NO_DATA_FOUND THEN 
            BEGIN
              select bdclicode into l_valeur_cli from vue_clicode_perimo where clicode = (select clicode from ligne_bip where pid = p_pid) and codhabili = 'br';
                 --DBMS_OUTPUT.PUT_LINE('l_valeur_cli ' ||l_valeur );
            EXCEPTION
              WHEN NO_DATA_FOUND THEN null;
            END;
            BEGIN
                  select codbddpg into l_valeur_dpg from vue_dpg_perime where codsg = (select codsg from ligne_bip where pid = p_pid) and codhabili = 'br';
                  --DBMS_OUTPUT.PUT_LINE('l_valeur_dpg ' ||l_valeur_dpg );
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN null;
                END;
        END;
      
      
        l_bbrf := substr(l_valeur,1,2);
        
        l_bbrf_cli := substr(l_valeur_cli,1,2);
        l_bbrf_dpg := substr(l_valeur_dpg,1,2);
      
      
      BEGIN
          select pzone  into l_param_local from ligne_bip where pid = p_pid;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN null; 
        END;

          if ( (l_bbrf = '03' or l_bbrf_cli = '03' or l_bbrf_dpg ='03') and (upper(l_param_local) = 'TRANSITOIRE' or upper(l_param_local) = 'DEVIS') and p_tacheaxemetier != '000000')  then
            pack_global.recuperer_message (21300, NULL, NULL, NULL, p_message);
            p_type := 'A';
            l_retour := 'KO';
          else 
              
              IF ( l_obligatoire = 'O' and p_tacheaxemetier != '000000') then
             
                  BEGIN
                  
                  select distinct dmpnum into l_dmpnum from DMP_RESEAUXFRANCE where dmpnum = p_tacheaxemetier and upper(ddetype) = 'C';
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN 
                  
                  pack_global.recuperer_message (21300, NULL, NULL, NULL, p_message);
                   p_type := 'A';
                   l_retour := 'KO';
                  END;
              
              
              END IF;
          
        end if;
        
          IF ( l_retour = 'OK') THEN

              BEGIN
              
              SELECT distinct icpi,'P' INTO p_param_id,p_type  FROM PROJ_INFO where ProjAxeMetier = p_tacheaxemetier and rownum = 1;
              pack_global.recuperer_message (21301, '%s1', p_param_id, NULL, p_message);
               
              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                  
                  BEGIN
                  
                  SELECT distinct dp_copi,'D' INTO p_param_id,p_type FROM dossier_projet_copi where dpcopiaxemetier = p_tacheaxemetier and rownum = 1;
                  pack_global.recuperer_message (21302, '%s1', p_param_id, NULL, p_message);
                  
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                  null;
                  END;
                  
              END;
        END IF;          
         END IF; 
         
       
       END;
        
        END IF; 
        
    END VERIFIER_TACHE_AXE_METIER;
    
    
    -- MCH : PPM 61919 chapitre 6.10 la procédure 'INITIALISER_TACHE_AXE_METIER' permet d'initialiser le champ tacheaxemetier
    PROCEDURE INITIALISER_TACHE_AXE_METIER ( p_pid   IN  isac_tache.pid%TYPE,
                                             p_tacheaxemetier OUT ISAC_TACHE.tacheaxemetier%TYPE) IS
    
    l_code_action LIGNE_PARAM_BIP.CODE_ACTION%TYPE;
    l_obligatoire LIGNE_PARAM_BIP.OBLIGATOIRE%TYPE;                                         
    l_direction CLIENT_MO.CLIDIR%TYPE;
    l_valeur VARCHAR2(20);
    l_bbrf_clicode VARCHAR2(3);
    l_bbrf_dpg VARCHAR2(3);
    l_nbre_param_local number(3);
    BEGIN
    
      p_tacheaxemetier := '';
      
      BEGIN
      select CMO.clidir into l_direction from client_mo CMO, ligne_bip LB where LB.pid = p_pid and LB.clicode = CMO.clicode;
      
      select code_action, obligatoire, substr(valeur,1,2)  
          into l_code_action, l_obligatoire, l_valeur 
          from ligne_param_bip 
          where code_action = 'DIR-REGLAGES' 
          and code_version = l_direction
          and actif = 'O';
      EXCEPTION
      WHEN NO_DATA_FOUND 
      THEN
        BEGIN
          select SI.coddir into l_direction from struct_info SI, ligne_bip LB where LB.pid = p_pid and LB.codsg = SI.codsg;
          
          select code_action, obligatoire, substr(valeur,1,2)  
          into l_code_action, l_obligatoire, l_valeur 
          from ligne_param_bip 
          where code_action = 'DIR-REGLAGES' 
          and code_version = l_direction
          and actif = 'O';
        EXCEPTION
          WHEN NO_DATA_FOUND 
          THEN 
            BEGIN
              select substr(bdclicode,1,2) into l_bbrf_clicode from vue_clicode_perimo where clicode = (select clicode from ligne_bip where pid = p_pid) and codhabili = 'br';
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                l_bbrf_clicode := null;
            END;
       
            BEGIN
              select substr(CODBDDPG,1,2) into l_bbrf_dpg From vue_dpg_perime WHERE codsg = (select CODSG from ligne_bip LB where LB.pid = p_pid) and codhabili = 'br';
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                l_bbrf_dpg := null;
            END; 
          END;
        END;
      
       
       
       IF(l_valeur = '03' or l_bbrf_clicode = '03' or l_bbrf_dpg = '03') Then
        select count(*) into l_nbre_param_local from ligne_bip where pid = p_pid and upper(pzone) in ('TRANSITOIRE', 'DEVIS');
          IF (l_nbre_param_local > 0)
            THEN
              p_tacheaxemetier := '000000';  
            END IF;
       END IF;
       
                                   
    END INITIALISER_TACHE_AXE_METIER;
    
     
    -- MCH : PPM 61919 chapitre 6.10 la procédure 'miseAVide' permet de réinitialiser le champ *axemetier
    PROCEDURE miseAVide ( type_msg   IN VARCHAR2, param_id IN VARCHAR2, p_userid IN VARCHAR2, p_message   OUT VARCHAR2 ) IS
    
    l_old_projaxemetier VARCHAR2(20);
    l_old_dpcopiaxemetier VARCHAR2(20);
    l_user VARCHAR2(30);
    BEGIN

    l_user := pack_global.lire_globaldata(p_userid).idarpege;
    if ( type_msg = 'D' )
    then
      select dpcopiaxemetier into l_old_dpcopiaxemetier from DOSSIER_PROJET_COPI where dp_copi = param_id;
      update DOSSIER_PROJET_COPI set dpcopiaxemetier = null where dp_copi = param_id;
      PACK_COPI.maj_dossier_projet_copi_logs (UPPER(param_id), l_user, 'DPCOPIAXEMETIER',l_old_dpcopiaxemetier,null,'Mis à vide par contrôle d''unicité');
    elsif ( type_msg = 'P' )
    then
      select projaxemetier into l_old_projaxemetier from PROJ_INFO where icpi = param_id;
      update PROJ_INFO set ProjAxeMetier = null where icpi = param_id;
      PACK_PROJ_INFO.maj_proj_info_logs(UPPER(param_id), l_user, 'ProjAxeMetier', l_old_projaxemetier, null, 'Mis à vide par contrôle d''unicité');
    end if;
    
    END miseAVide;

--*************************************************************************************************
-- Procédure delete_tache
--
-- Permet de supprimer une tâche
-- Appelée dans la page iltache.htm à partir du bouton "Supprimer"
--
-- ************************************************************************************************
PROCEDURE delete_tache (p_pid     	IN isac_tache.pid%TYPE,
			p_etape 	IN VARCHAR2,
			p_tache 	IN VARCHAR2,
			p_userid     	IN VARCHAR2,
			p_nbcurseur    	OUT INTEGER,
                        p_message    	OUT VARCHAR2
                        ) IS

l_acta VARCHAR2(2);
l_libtache VARCHAR2(35);
l_test NUMBER;
l_anneecourante VARCHAR2(4);
l_conso NUMBER;
BEGIN
p_message:='';

  BEGIN

  --test pour savoir si la tache comprend des sous-taches avec du FF sur une ligne fermée
	SELECT 1 into l_test
	FROM isac_sous_tache sst,isac_tache t,ligne_bip lb,datdebex dx
	WHERE lb.pid(+)=substr(sst.aist,3,4)
	AND t.tache=to_number(p_tache)
	AND t.tache=sst.tache
	AND t.etape=sst.etape
	AND lb.adatestatut is not null
	AND lb.adatestatut <= add_months(dx.moismens,-1)
	AND rownum=1
	;

	IF l_test=1 THEN
		pack_isac.recuperer_message(20024, NULL, NULL, NULL, p_message);
               	raise_application_error( -20024, p_message );
	END IF;

	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		NULL;
  END;

  BEGIN
  --on recupere l annee courante
  	select to_char(datdebex,'YYYY') into  l_anneecourante
        from datdebex;

  --on verifie qu il n y a pas de consomme sur l annee
  	SELECT  nvl(sum(c.cusag),0) INTO l_conso
 	FROM isac_consomme c,isac_tache t
 	WHERE c.tache(+)=t.tache
 	AND t.tache=to_number(p_tache)
 	AND to_char(c.cdeb,'YYYY')=l_anneecourante
	;
		if l_conso<>0 then
		pack_isac.recuperer_message(20029, NULL,NULL, NULL, p_message);
               	raise_application_error( -20029, p_message );
		end if;
  END;

  BEGIN
	select acta,libtache into l_acta, l_libtache
	from isac_tache
	where tache=to_number(p_tache);

	--Supprimer les tâches,sous-tâches,affections,consommés
	delete isac_consomme
	where pid=p_pid
	and etape=to_number(p_etape)
	and tache=to_number(p_tache);

	delete isac_affectation
	where pid=p_pid
	and etape=to_number(p_etape)
	and tache=to_number(p_tache);


	delete isac_sous_tache
	where pid=p_pid
	and etape=to_number(p_etape)
	and tache=to_number(p_tache);


	delete isac_tache
	where pid=p_pid
	and etape=to_number(p_etape)
	and tache=to_number(p_tache);



	commit;

	--tache supprimée
	pack_isac.recuperer_message(20002, '%s1', 'Tâche '||l_acta||' - '||l_libtache, NULL, p_message);
  END;

END delete_tache;

--*************************************************************************************************
-- Procédure update_tache
--
-- Permet de modifier une tâche
-- Appelée dans la page imtache.htm
--
-- ************************************************************************************************
PROCEDURE update_tache(	p_tache		IN VARCHAR2,
			p_pid     	IN isac_tache.pid%TYPE,
			p_etape 	IN VARCHAR2,
			p_acta		IN VARCHAR2,
			p_libtache	IN VARCHAR2,
			p_flaglock      IN VARCHAR2,
      p_tacheaxemetier  IN VARCHAR2,-- MCH : PPM 61919 chapitre 6.10
			p_userid     	IN VARCHAR2,
      p_absence_param  IN VARCHAR2,-- MCH : PPM 61919 chapitre 6.10
			p_nbcurseur    	OUT INTEGER,
                        p_message    	OUT VARCHAR2
			) IS

l_count NUMBER(1);
l_msg VARCHAR2(255);
l_old_acta VARCHAR2(2);
l_old_tacheaxemetier VARCHAR2(12);
l_user VARCHAR2(30);
l_ecet VARCHAR2(2);
l_tacheaxemetier VARCHAR(12);
l_source VARCHAR(12):='IHM';

BEGIN

  p_nbcurseur := 0;
  p_message:='';
  l_msg:='';
  
  IF (p_userid like '.BIPS') THEN
  l_user := '.BIPS';
  l_source := 'fichier';
  ELSE
  l_user := pack_global.lire_globaldata(p_userid).idarpege;
  END IF;

  -- Recherche de l'ancien numéro de la tâche
	select acta into l_old_acta
	from isac_tache
	where tache=to_number(p_tache);

	select count(tache) into l_count
	from isac_tache
	where pid=p_pid
	and etape=to_number(p_etape)
	and acta=p_acta
	and acta!=l_old_acta;

  select tacheaxemetier 
  into l_old_tacheaxemetier
  from isac_tache
  where tache = p_tache;

	if (l_count!=0) then
	--Vous ne pouvez pas modifier le numéro d'une tâche qui existe déjà
		pack_isac.recuperer_message(20001, '%s1','une tâche', 'ACTA', l_msg);
         	raise_application_error( -20001, l_msg);

	else
	-- Modification de l'étape

  IF (p_absence_param = 'absence') THEN --SEL 6.11.2
  
  l_tacheaxemetier := null;
  
  ELSE
  
  l_tacheaxemetier := p_tacheaxemetier;
  
  END IF;
  
  
		update isac_tache
		set 	acta=p_acta,
			libtache=p_libtache,
			flaglock=to_number(decode(p_flaglock, 1000000, 0, p_flaglock + 1)),
      tacheaxemetier=l_tacheaxemetier
		where  tache=to_number(p_tache)
		and flaglock = to_number(p_flaglock,'FM9999999');
    
    

    select LPAD(ecet,2,'0') into l_ecet from isac_etape where etape=to_number(p_etape);
    
    IF (p_absence_param = 'absence') THEN --SEL 6.11.2
  
    pack_ligne_bip.maj_ligne_bip_logs        (p_pid,
                                                l_user,
                                                'Axe métier Tâche',
                                                l_old_tacheaxemetier,
                                                l_tacheaxemetier,
                                                'Suppression de la valeur du champ car paramètre applicatif inexistant'
                                               );
  
  ELSE
  
  pack_ligne_bip.maj_ligne_bip_logs        (p_pid,
                                                l_user,
                                                'Axe métier Tâche',
                                                l_old_tacheaxemetier,
                                                p_tacheaxemetier,
                                                'Modification via '||l_source||' sur la tâche '||l_ecet||'.'||p_acta
                                               );
  
  END IF;
    

    
		IF SQL%NOTFOUND THEN  -- Acces concurrent
        			pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         		raise_application_error( -20999, l_msg );
      		END IF;


	commit;
	end if;

	p_message:=l_msg;

END update_tache;

--*************************************************************************************************
-- Procédure select_tache
--
-- Permet d'afficher les champs modifiables d'une tâche
-- Appelée dans la page iltache.htm à partir du bouton "Modifier"
--
-- ************************************************************************************************
PROCEDURE select_tache (p_pid     	IN isac_tache.pid%TYPE,
			p_etape 	IN VARCHAR2,
			p_tache		IN VARCHAR2,
			p_userid     	IN VARCHAR2,
			p_curtache    	IN OUT tacheCurType,
			p_nbcurseur    	OUT INTEGER,
                         p_message    	OUT VARCHAR2
			  ) IS

l_test NUMBER;

BEGIN
  p_nbcurseur := 0;
  p_message:='';

  BEGIN

  --test pour savoir si la tache comprend des sous-taches avec du FF sur une ligne fermée
	SELECT 1 into l_test
	FROM isac_sous_tache sst,isac_tache t,ligne_bip lb,datdebex dx
	WHERE lb.pid(+)=substr(sst.aist,3,4)
	AND t.tache=to_number(p_tache)
	AND t.tache=sst.tache
	AND t.etape=sst.etape
	AND lb.adatestatut is not null
	AND lb.adatestatut <= add_months(dx.moismens,-1)
	AND rownum=1
	;

	IF l_test=1 THEN
		pack_isac.recuperer_message(20022, NULL, NULL, NULL, p_message);
               	raise_application_error( -20022, p_message );
	END IF;

	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		NULL;
  END;

  BEGIN
	OPEN p_curtache FOR
	select *
	from isac_tache
	where tache=to_number(p_tache);
  END;


END select_tache;

--*************************************************************************************************
-- Procédure insert_tache
--
-- Permet de créer une tâch
-- Appelée dans la page ictache.htm
--
-- ************************************************************************************************
PROCEDURE insert_tache(	p_pid     	IN isac_tache.pid%TYPE,
			p_etape 	IN VARCHAR2,
			p_acta		IN VARCHAR2,
			p_libtache	IN VARCHAR2,
      p_tacheaxemetier  IN VARCHAR2,-- MCH : PPM 61919 chapitre 6.10
			p_userid     	IN VARCHAR2,
      p_absence_param  IN VARCHAR2,-- MCH : PPM 61919 chapitre 6.10
			p_nbcurseur    	OUT INTEGER,
                        p_message    	OUT VARCHAR2
			) IS

l_count NUMBER;
l_user VARCHAR2(30);
l_ecet VARCHAR2(2);
l_tacheaxemetier VARCHAR(12);
l_source VARCHAR(12):='IHM';

BEGIN
  p_nbcurseur := 0;
  p_message:='';
  
  IF (p_userid like '.BIPS') THEN
    
    l_source := 'fichier';
    l_user := '.BIPS';

  ELSE
  
  l_user := pack_global.lire_globaldata(p_userid).idarpege;
  
  END IF;
  

	-- On compte le nombre de tâche de même numéro
	select count(*) into l_count
	from isac_tache
	where pid=p_pid
	  and acta=p_acta
	  and etape=to_number(p_etape);
	-- si le numéro à attribuer est bien unique,
	If l_count = 0 THEN
   
    IF (p_absence_param = 'absence') THEN --SEL 6.11.2
    
    l_tacheaxemetier := null;
    
    ELSE
  
    l_tacheaxemetier := p_tacheaxemetier;
    
    END IF;
  
		insert into isac_tache (pid,etape,tache,acta,libtache,flaglock,tacheaxemetier)
		values (p_pid,to_number(p_etape),SEQ_TACHE.nextval,p_acta,p_libtache,0,l_tacheaxemetier);
    
    select LPAD(ecet,2,'0') into l_ecet from isac_etape where etape=to_number(p_etape);




      IF (p_absence_param = 'absence') THEN --SEL 6.11.2  

      null; --MCH QC1787
      else
      pack_ligne_bip.maj_ligne_bip_logs        (p_pid,
                                                  l_user,
                                                  'Axe métier Tâche',
                                                  null,
                                                  p_tacheaxemetier,

                                                  'Création via '||l_source||' sur la tâche '||l_ecet||'.'||p_acta
                                                 );
      commit;


      END IF;
	-- S'il y a déjà ce numéro de tâche d'enregistré on renvoie une erreur.
	ELSE
		pack_global.recuperer_message(20045,NULL, NULL, NULL, p_message);
		raise_application_error( -20045, p_message );
	END IF;

END insert_tache;

--*************************************************************************************************
-- Procédure select_tache_suivante
--
-- Permet d'afficher le numéro de la nouvelle tâche lors de la création
-- Appelée dans la page iltache.htm à partir du bouton "Créer"
--
-- ************************************************************************************************
PROCEDURE select_tache_suivante(p_pid     	IN isac_tache.pid%TYPE,
				p_etape 	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_acta		OUT VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                         	p_message    	OUT VARCHAR2
			    ) IS
l_acta number;
l_msg VARCHAR2(255);
BEGIN
 p_nbcurseur := 1;

 l_msg:='';
 p_message:='';
	select NVL(MAX(TO_NUMBER(acta)),0)+1 into l_acta
	from isac_tache
	where --pid=p_pid and
	 etape=to_number(p_etape);

p_acta :=  to_char(l_acta,'FM00');

if l_acta>99 then
--99 taches maximum par étape
		pack_isac.recuperer_message(20016, NULL,NULL, NULL, l_msg);
         	raise_application_error( -20016, l_msg);

end if;
p_message:=l_msg;

END select_tache_suivante;

--*************************************************************************************************
-- Procédure select_liste_tache
--
-- Permet d'afficher le numéro de l'étape et son libellé
-- Appelée dans la page igtache.htm
--
-- ************************************************************************************************
PROCEDURE select_liste_tache (	p_pid     	IN isac_tache.pid%TYPE,
				p_etape 	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_keylist2      OUT VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                         	p_message    	OUT VARCHAR2
                        	) IS

l_ecet  VARCHAR2(2);
l_libetape VARCHAR2(30);
BEGIN
  p_nbcurseur := 0;
  p_message:='';
	select ecet,libetape into l_ecet,l_libetape
	from isac_etape
	where pid=p_pid
	and etape=to_number(p_etape) ;

	p_keylist2:=l_ecet||'-'||l_libetape;

END select_liste_tache;

END pack_isac_tache;

/