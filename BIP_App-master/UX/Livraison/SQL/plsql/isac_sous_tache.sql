create or replace PACKAGE pack_isac_sous_tache AS
 PROCEDURE verif_aist ( p_pid IN isac_sous_tache.pid%TYPE,
			p_sous_tache IN VARCHAR2,  -- HP PPM 61074 - ABN
			p_etape IN VARCHAR2,
			p_aist IN VARCHAR2,
			p_result OUT VARCHAR2,
			p_message OUT VARCHAR2);

PROCEDURE delete_sous_tache (	p_pid     	IN isac_sous_tache.pid%TYPE,
				p_etape 	IN VARCHAR2,
				p_tache 	IN VARCHAR2,
				p_sous_tache 	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                       	  	p_message    	OUT VARCHAR2
                        );

PROCEDURE update_sous_tache(	p_sous_tache	IN VARCHAR2,
				p_pid     	IN isac_sous_tache.pid%TYPE,
				p_etape 	IN VARCHAR2,
				p_tache		IN VARCHAR2,
				p_acst		IN VARCHAR2,
				p_aist		IN VARCHAR2,
				p_asnom		IN VARCHAR2,
				p_adeb		IN VARCHAR2,
				p_afin		IN VARCHAR2,
				p_ande		IN VARCHAR2,
				p_anfi		IN VARCHAR2,
				p_asta		IN VARCHAR2,
				p_adur		IN VARCHAR2,
				p_paramlocal	IN VARCHAR2,
				p_flaglock      IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                       	  	p_message    	OUT VARCHAR2
			);
TYPE stacheRec IS RECORD     (	SOUS_TACHE	VARCHAR2(20),
				ACST		VARCHAR2(2),
				AIST		VARCHAR2(6),
				ASNOM		VARCHAR2(35),
				ADEB		VARCHAR2(10),
				AFIN		VARCHAR2(10),
				ANDE		VARCHAR2(10),
				ANFI		VARCHAR2(10),
				ASTA		VARCHAR2(2),
				ADUR		VARCHAR2(5),
				PARAMLOCAL	VARCHAR2(5),
				FLAGLOCK	VARCHAR2(10)
				);
  TYPE stacheCurType IS REF CURSOR RETURN stacheRec;

PROCEDURE select_sous_tache (	p_pid     	IN isac_sous_tache.pid%TYPE,
				p_etape 	IN VARCHAR2,
				p_tache		IN VARCHAR2,
				p_sous_tache    IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_curstache    	IN OUT stacheCurType,
				p_nbcurseur    	OUT INTEGER,
                      	   	p_message    	OUT VARCHAR2
			  );
PROCEDURE insert_sous_tache ( 	p_pid		IN isac_sous_tache.pid%TYPE,
				p_etape		IN VARCHAR2,
				p_tache		IN VARCHAR2,
				p_acst		IN VARCHAR2,
				p_aist		IN VARCHAR2,
				p_asnom		IN VARCHAR2,
				p_adeb		IN VARCHAR2,
				p_afin		IN VARCHAR2,
				p_ande		IN VARCHAR2,
				p_anfi		IN VARCHAR2,
				p_asta		IN VARCHAR2,
				p_adur		IN VARCHAR2,
				p_paramlocal	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                 		p_message    	OUT VARCHAR2
			    ) ;

PROCEDURE select_new_sous_tache (p_pid		IN isac_sous_tache.pid%TYPE,
				 p_etape	IN VARCHAR2,
				 p_tache	IN VARCHAR2,
				 p_userid     	IN VARCHAR2,
				 p_acst		OUT VARCHAR2,
				 p_nbcurseur    OUT INTEGER,
                 		 p_message    	OUT VARCHAR2
			    );

PROCEDURE select_tache ( p_pid		IN isac_sous_tache.pid%TYPE,
			p_tache		IN VARCHAR2,
			p_userid     	IN VARCHAR2,
			p_keylist3out   OUT VARCHAR2,
			p_keylist4out   OUT VARCHAR2,
			p_nbcurseur    	OUT INTEGER,
                 	p_message    	OUT VARCHAR2
			    );



-- Retourne le libellé ligne bip, le code DPG et le libéllé du code DPG
PROCEDURE get_lib ( 	p_aist		    IN	VARCHAR2,
						 				  						 p_libpid	  OUT	LIGNE_BIP.pnom%TYPE,
																 p_codsg	  OUT	STRUCT_INFO.codsg%TYPE,
																 p_libcodsg	  OUT	STRUCT_INFO.libdsg%TYPE,
																 p_message	  OUT 	VARCHAR2
																);

PROCEDURE mettre_en_favorite(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE,
  p_favorite ISAC_SOUS_TACHE.FAVORITE%TYPE);

PROCEDURE desaffecter(p_sous_tache ISAC_AFFECTATION.SOUS_TACHE%TYPE,
  p_ressource ISAC_AFFECTATION.IDENT%TYPE);

FUNCTION existeConsomme(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE, p_ressource ISAC_AFFECTATION.IDENT%TYPE) return BOOLEAN;
FUNCTION existeConsommeDef(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE, p_ressource ISAC_AFFECTATION.IDENT%TYPE) return BOOLEAN;

PROCEDURE existeConsomme(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE, p_ressource ISAC_AFFECTATION.IDENT%TYPE, p_message OUT VARCHAR2);
PROCEDURE existeConsommeDef(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE, p_ressource ISAC_AFFECTATION.IDENT%TYPE, p_message OUT VARCHAR2);
PROCEDURE supprimer(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE, p_ressource ISAC_AFFECTATION.IDENT%TYPE, p_message OUT VARCHAR2);

END pack_isac_sous_tache ;
/
create or replace PACKAGE BODY     pack_isac_sous_tache AS
-- ****************************************************************
-- Procedure verif_aist
-- Verifie que le type de la sous-t¿che convient pour la ligne BIP
-- utilisee dans les procedures insert_sous_tache et update_sous_tache
-- ****************************************************************

  PROCEDURE verif_aist (p_pid IN isac_sous_tache.pid%TYPE,
			p_sous_tache	IN VARCHAR2, -- HP PPM 61074 - ABN
			p_etape IN VARCHAR2,
			p_aist IN VARCHAR2,
			p_result  OUT VARCHAR2,
			p_message OUT VARCHAR2) IS
l_typproj NUMBER;
l_count NUMBER;
l_typetape VARCHAR2(2);
l_moismens DATE;
l_adatestatut DATE;
l_typeligne CHAR(2);
l_aist VARCHAR2(6);


  BEGIN
  p_result:='';

	--on recupere le mois de mensuelle
	SELECT moismens INTO l_moismens
	FROM datdebex;

	-- Recherche du type d'etape
	select typetape into l_typetape
	from isac_etape
	where etape=to_number(p_etape);


	IF l_typetape='ES' THEN  --TYPE ES
	-- Verifier le type de projet
	select to_number(typproj) into l_typproj
	from ligne_bip
	where pid=p_pid;
		IF l_typproj=7 THEN --Projet de type ABSENCE
			IF p_aist not in ('CONGES','ABSDIV','MOBILI','CLUBUT','FORFAC','ACCUEI',
				'FORMAT','SEMINA','INTEGR','FORHUM','FOREAO','FORINF',
				'FOREXT','FORINT','COLOQU','RTT','PARTIE','DEMENA') or p_aist is null THEN
--Message d'erreur : Type de sous-tache incorrect pour la ligne BIP.Entrez un autre type de sous-tache
				pack_isac.recuperer_message(20010,null,null,'AIST',p_message);
        				raise_application_error(-20010,p_message);


			END IF;
		ELSE --Projet !=ABSENCE
			IF p_aist not in ('FM','EN','ST') or p_aist is null THEN
			--Message d'erreur
				pack_isac.recuperer_message(20010,null,null,'AIST',p_message);
        				raise_application_error(-20010,p_message);
			END IF;

		END IF;

	ELSE --TYPE non ES

        IF p_aist='HEUSUP' THEN null;
		-- si sous tache EN dans une etape de n'importe qu'elle pacte cad autre que ES et NO
		ELSIF l_typetape != 'NO' AND p_aist='EN' THEN NULL;
		ELSIF (p_aist='' or p_aist is null) THEN null;
		ELSIF substr(p_aist,1,2) in ('FF','DF') THEN
			select count(*) into l_count
			from ligne_bip
			where pid=rtrim(substr(p_aist,3,4));
			if l_count=0 then
			--Message d'erreur:ce n'est pas un code ligne BIP
			     pack_isac.recuperer_message(20011,'%s1',substr(p_aist,3,4),'AIST',p_message);
        			     raise_application_error(-20011,p_message);
			end if;
			select adatestatut, typproj into l_adatestatut, l_typeligne
			from ligne_bip
			where pid=rtrim(substr(p_aist,3,4))
			;
            if ( trim(l_typeligne) = '9' ) then
                Pack_Global.recuperer_message(21163, NULL, NULL, NULL, p_message);
                 raise_application_error(-20019,p_message);
            end if;
        -- DEB - HP PPM 61074 - ABN
        BEGIN
          if (p_sous_tache is not null) then
            select aist into l_aist from isac_sous_tache
            where sous_tache=to_number(p_sous_tache) and aist=p_aist;
          end if;

        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             l_aist := null;
        END;

            if (l_adatestatut is not null and l_adatestatut <= add_months(l_moismens,-1) and l_aist is null) then
				 pack_isac.recuperer_message(20019,'%s1',substr(p_aist,3,4),'AIST',p_message);
        			 raise_application_error(-20019,p_message);
			end if;

     -- FIN - HP PPM 61074 - ABN

		ELSE
			p_result :='Autre chose';
		END IF;

	END IF;

  END;


--*************************************************************************************************
-- Procedure delete_sous_tache
--
-- Permet de supprimer une sous_tache
-- Appelee dans la page iltache.htm a partir du bouton "Supprimer"
--
-- ************************************************************************************************
PROCEDURE delete_sous_tache (	p_pid     	IN isac_sous_tache.pid%TYPE,
				p_etape 	IN VARCHAR2,
				p_tache 	IN VARCHAR2,
				p_sous_tache 	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                       	  	p_message    	OUT VARCHAR2
                        ) IS
l_acst VARCHAR2(2);
l_asnom VARCHAR2(35);
l_anneecourante VARCHAR2(4);
l_conso NUMBER;
l_moismens datdebex.moismens%TYPE;
l_adatestatut ligne_bip.adatestatut%TYPE;
l_pid ligne_bip.pid%TYPE;
l_conso_remonte NUMBER;
BEGIN
  p_message:='';

  BEGIN
  --on recupere le mois de mensuelle
	SELECT moismens INTO l_moismens
	FROM datdebex;

  --on récupère la date de statut de la ligne en FF
	SELECT adatestatut,l.pid INTO l_adatestatut,l_pid
			FROM ligne_bip l,isac_sous_tache i
			WHERE l.pid(+)=substr(i.aist,3,4)
			AND i.sous_tache=to_number(p_sous_tache)
			;
	 --TD347--	if l_adatestatut is not null and l_adatestatut <= add_months(l_moismens,-1) then
	 --TD347--		 pack_isac.recuperer_message(20021, '%s1', l_pid, NULL, p_message);
     --TD347--		 raise_application_error( -20021, p_message );
	 --TD347--	end if;
  END;

  BEGIN
  --on recupere l annee courante
  	select to_char(datdebex,'YYYY') into  l_anneecourante
        from datdebex;

  --on verifie qu il n y a pas de consomme sur l annee dans les tables ISAC.
  	SELECT  nvl(sum(c.cusag),0) INTO l_conso
 	FROM isac_consomme c,isac_sous_tache sst
 	WHERE c.sous_tache(+)=sst.sous_tache
 	AND sst.sous_tache=to_number(p_sous_tache)
    AND to_char(c.cdeb,'YYYY')=l_anneecourante
	;
		if l_conso<>0 then
		pack_isac.recuperer_message(20032, NULL,NULL, NULL, p_message);
               	raise_application_error( -20032, p_message );
		end if;
  END;

  -- TD347 : On vérifie s'il y a des consommés qui ont déjà été remontés.
  BEGIN
  --on recupere l annee courante
  	select to_char(datdebex,'YYYY') into  l_anneecourante
        from datdebex;

  --on verifie qu il n y a pas de consomme sur l annee dans les tables ISAC.
	-- FAD PPM 65123 : Ajout du contrôle du consommé sur la table PMW_BIPS
  	SELECT nvl(sum(consomme), 0) INTO l_conso_remonte
		FROM (
		SELECT cstrm.cusag consomme
		FROM cons_sstache_res_mois cstrm, isac_sous_tache ist, isac_tache it, isac_etape itp
		WHERE ist.sous_tache=to_number(p_sous_tache)
		AND ist.pid = cstrm.pid
		AND ist.acst = cstrm.acst
		AND ist.pid = it.pid
		AND ist.tache = it.tache
		AND it.acta = cstrm.acta
		AND ist.pid = itp.pid
		AND ist.etape = itp.etape
		AND itp.ecet = cstrm.ecet
		AND to_char(cstrm.cdeb,'YYYY')=l_anneecourante

		UNION
		SELECT PB.CONSOQTE
		FROM PMW_BIPS PB, isac_sous_tache ist, isac_tache it, isac_etape itp
		WHERE ist.sous_tache=to_number(p_sous_tache)
		AND ist.pid = PB.LIGNEBIPCODE
		AND ist.acst = PB.STACHENUM
		AND ist.pid = it.pid
		AND ist.tache = it.tache
		AND it.acta = PB.TACHENUM
		AND ist.pid = itp.pid
		AND ist.etape = itp.etape
		AND itp.ecet = PB.ETAPENUM
    /*QC - 1980 starts*/
    AND PB.PRIORITE = 'P2'
    /*QC - 1980 ends*/
		AND to_char(PB.CONSODEBDATE,'YYYY')=l_anneecourante
		)
		;
	-- FAD PPM 65123 : Fin
		if l_conso_remonte<>0 then
		pack_isac.recuperer_message(20032, NULL,NULL, NULL, p_message);
               	raise_application_error( -20032, p_message );
		end if;
  END; -- Fin contrôle TD347 --

  BEGIN
	select acst,asnom into l_acst, l_asnom
	from isac_sous_tache
	where sous_tache=to_number(p_sous_tache);

	--Supprimer les sous-t¿ches,affections,consommes
	delete isac_consomme
	where sous_tache=to_number(p_sous_tache);

	delete isac_affectation
	where sous_tache=to_number(p_sous_tache);

	delete isac_sous_tache
	where sous_tache=to_number(p_sous_tache);


	commit;

	--Sous-tache supprimee
	pack_isac.recuperer_message(20002, '%s1', 'Sous-tache '||l_acst||' - '||l_asnom, NULL, p_message);
  END;

END delete_sous_tache;

--*************************************************************************************************
-- Procedure SP_CHECK_OUT_SOURCING
--
-- to check below cases - if so raise eror
--¿ if there is outsourcing* from a non-productive line to a non-productive line,
--¿ if there is outsourcing* from a productive line to a non-productive line,
--¿ if there is outsourcing* from a non-productive line to a productive line,

-- ************************************************************************************************

PROCEDURE SP_CHECK_OUT_SOURCING(
    P_PID  IN isac_sous_tache.PID%TYPE,
    P_AIST IN isac_sous_tache.AIST%TYPE,
    P_MSG  OUT VARCHAR2
)
IS
L_OUT_SRC_FLAG VARCHAR2(1) := 'N';
BEGIN
       SELECT
        CASE
              WHEN P_AIST LIKE 'FF%'
              THEN 
                CASE
                 WHEN '7' = (SELECT TYPPROJ FROM LIGNE_BIP WHERE PID = SUBSTR(P_AIST,'3')) THEN
                 'Y'
                 ELSE 
                 CASE
                   WHEN TYPPROJ = '7'
                   THEN 'Y'
                 ELSE 'N'
                 END 
                 END 
              ELSE 'N'
            END
        END
      INTO L_OUT_SRC_FLAG
      FROM LIGNE_BIP L
      WHERE L.PID = P_PID;

      IF L_OUT_SRC_FLAG = 'Y' THEN
      	PACK_GLOBAL.RECUPERER_MESSAGE(21322,NULL, NULL, NULL, P_MSG);
         	RAISE_APPLICATION_ERROR( -20001, P_MSG);
      END IF;

END SP_CHECK_OUT_SOURCING;
--*************************************************************************************************
-- Procedure update_sous_tache
--
-- Permet de modifier une sous_tache
-- Appelee dans la page imstache.htm
--
-- ************************************************************************************************
PROCEDURE update_sous_tache(	p_sous_tache	IN VARCHAR2,
				p_pid     	IN isac_sous_tache.pid%TYPE,
				p_etape 	IN VARCHAR2,
				p_tache		IN VARCHAR2,
				p_acst		IN VARCHAR2,
				p_aist		IN VARCHAR2,
				p_asnom		IN VARCHAR2,
				p_adeb		IN VARCHAR2,
				p_afin		IN VARCHAR2,
				p_ande		IN VARCHAR2,
				p_anfi		IN VARCHAR2,
				p_asta		IN VARCHAR2,
				p_adur		IN VARCHAR2,
				p_paramlocal	IN VARCHAR2,
				p_flaglock      IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                       	  	p_message    	OUT VARCHAR2
			) IS

l_count NUMBER(1);
l_msg VARCHAR2(255);
l_old_acst VARCHAR2(2);
l_flaglock NUMBER(7);
l_result VARCHAR2(255);
l_aist VARCHAR2(6);
BEGIN
  p_nbcurseur := 0;
  p_message:='';
  l_msg:='';
  l_flaglock := to_number(p_flaglock,'FM9999999');

  /*BIP-308 Outsourcing not allowed for non-productive BIP line - STARTS*/
  SP_CHECK_OUT_SOURCING(P_PID,P_AIST,L_MSG);
  /*BIP-308 Outsourcing not allowed for non-productive BIP line - ENDS*/


  --Contr¿le du type de la sous-t¿che
	verif_aist(p_pid,p_sous_tache,p_etape,p_aist,l_result,p_message);

	if l_result='Autre chose' then
		l_aist := NULL;
	else l_aist := p_aist;
	end if;

  -- Recherche de l'ancien numero de la sous-t¿che
	select acst into l_old_acst
	from isac_sous_tache
	where sous_tache=to_number(p_sous_tache);

	select count(sous_tache) into l_count
	from isac_sous_tache
	where pid=p_pid
	and etape=to_number(p_etape)
	and tache=to_number(p_tache)
	and acst=p_acst
	and acst!=l_old_acst;

	if (l_count!=0) then
	--Vous ne pouvez pas modifier le numero d'une sous-t¿che qui existe dej¿
		pack_isac.recuperer_message(20001, '%s1','une sous-tâche', 'ACST', l_msg);
         	raise_application_error( -20001, l_msg);

	else
	-- Modification de l'etape
		update isac_sous_tache
		set 	acst=p_acst,
			asnom=p_asnom,
			aist=l_aist,
			asta=p_asta,
			adeb=to_date(p_adeb,'DD/MM/YYYY'),
			afin=to_date(p_afin,'DD/MM/YYYY'),
			ande=to_date(p_ande,'DD/MM/YYYY'),
			anfi=to_date(p_anfi,'DD/MM/YYYY'),
			adur=to_number(p_adur),
			param_local=p_paramlocal,
			flaglock=decode(l_flaglock, 1000000, 0, l_flaglock + 1)
		where sous_tache=to_number(p_sous_tache)
		and flaglock = l_flaglock;

		IF SQL%NOTFOUND THEN  -- Acces concurrent
        			pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         		raise_application_error( -20999, l_msg );
      		END IF;

		commit;
	end if;

	p_message:=l_msg;

END update_sous_tache;
-- ************************************************************************************************
-- Procedure select_sous_tache
--
-- Permet d'afficher les donnees de la sous-t¿che pour modification
-- Appelee dans la page ilstache.htm, bouton "Modifier"
--
-- ************************************************************************************************
PROCEDURE select_sous_tache (	p_pid     	IN isac_sous_tache.pid%TYPE,
				p_etape 	IN VARCHAR2,
				p_tache		IN VARCHAR2,
				p_sous_tache    IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_curstache    	IN OUT stacheCurType,
				p_nbcurseur    	OUT INTEGER,
                      	   	p_message    	OUT VARCHAR2
			  ) IS

BEGIN
p_nbcurseur := 0;
p_message:='';

 -- HP PPM 60935 - ABN

  	BEGIN
	OPEN p_curstache FOR
	select to_char(sous_tache) SOUS_TACHE,
		ACST,
		AIST,
		ASNOM,
		to_char(adeb,'DD/MM/YYYY') ADEB,
		to_char(afin,'DD/MM/YYYY') AFIN,
		to_char(ande,'DD/MM/YYYY') ANDE,
		to_char(anfi,'DD/MM/YYYY') ANFI,
		ASTA,
		to_char(adur) ADUR,
		PARAM_LOCAL,
		to_char(flaglock) FLAGLOCK
	from isac_sous_tache
	where sous_tache=to_number(p_sous_tache);
	END;


END select_sous_tache;
-- ************************************************************************************************
-- Procedure insert_sous_tache
--
-- Permet de creer une sous-t¿che
-- Appelee dans la page icstache.htm
--
-- ************************************************************************************************
PROCEDURE insert_sous_tache ( 	p_pid		IN isac_sous_tache.pid%TYPE,
				p_etape		IN VARCHAR2,
				p_tache		IN VARCHAR2,
				p_acst		IN VARCHAR2,
				p_aist		IN VARCHAR2,
				p_asnom		IN VARCHAR2,
				p_adeb		IN VARCHAR2,
				p_afin		IN VARCHAR2,
				p_ande		IN VARCHAR2,
				p_anfi		IN VARCHAR2,
				p_asta		IN VARCHAR2,
				p_adur		IN VARCHAR2,
				p_paramlocal	IN VARCHAR2,
				p_userid     	IN VARCHAR2,
				p_nbcurseur    	OUT INTEGER,
                 		p_message    	OUT VARCHAR2
			    ) IS
l_result VARCHAR2(255);
l_aist VARCHAR2(6);
l_count NUMBER;
BEGIN

 /*BIP-308 Outsourcing not allowed for non-productive BIP line - STARTS*/
  SP_CHECK_OUT_SOURCING(P_PID,P_AIST,p_message);
  /*BIP-308 Outsourcing not allowed for non-productive BIP line - ENDS*/
  	--Contr¿le du type de la sous-t¿che
	verif_aist(p_pid,null,p_etape,p_aist,l_result,p_message);

	if l_result='Autre chose' then
		l_aist := NULL;
	else l_aist := p_aist;
	end if;


	-- On compte le nombre de sous-tâche de même numéro
	select count(*) into l_count
	from isac_sous_tache
	where pid=p_pid
	  and etape=to_number(p_etape)
	  and tache=to_number(p_tache)
	  and acst=p_acst;
	-- si le numéro à attribuer est bien unique,
	If l_count = 0 THEN
 		-- Creation de la sous-tache
		insert into isac_sous_tache (pid,etape,tache,sous_tache,
			acst,asnom,aist,asta,adeb,afin,ande,anfi,adur,param_local,flaglock)
		values (p_pid,to_number(p_etape),to_number(p_tache),SEQ_SOUS_TACHE.nextval,
			p_acst,p_asnom,l_aist,p_asta,TO_DATE(p_adeb,'DD/MM/YYYY'),TO_DATE(p_afin,'DD/MM/YYYY'),
			TO_DATE(p_ande,'DD/MM/YYYY'),TO_DATE(p_anfi,'DD/MM/YYYY'),p_adur,p_paramlocal,0);
		commit;
	-- S'il y a déjà ce numéro de sous-tâche d'enregistré on renvoie une erreur.
	ELSE
		pack_global.recuperer_message(20046,NULL, NULL, NULL, p_message);
		raise_application_error( -20046, p_message );
	END IF;



END insert_sous_tache;

--*************************************************************************************************
-- Procedure select_new_sous_tache
--
-- Permet d'afficher la nouvelle sous-t¿che lors de la creation
-- Appelee dans la page ilstache.htm (bouton="Creer)
--
-- ************************************************************************************************
PROCEDURE select_new_sous_tache (p_pid		IN isac_sous_tache.pid%TYPE,
				 p_etape	IN VARCHAR2,
				 p_tache	IN VARCHAR2,
				 p_userid     	IN VARCHAR2,
				 p_acst		OUT VARCHAR2,
				 p_nbcurseur    OUT INTEGER,
                 		 p_message    	OUT VARCHAR2
			    ) IS
l_new_stache NUMBER(10);
l_msg VARCHAR2(255);
BEGIN
p_message:='';
  l_msg:='';

	select NVL(MAX(TO_NUMBER(acst)),0)+1 into l_new_stache
	from isac_sous_tache
	where pid=p_pid
	and etape=to_number(p_etape)
	and tache=to_number(p_tache);

p_acst := to_char(l_new_stache,'FM00');

if l_new_stache>99 then
--99 sous-taches maximum par t¿che
		pack_isac.recuperer_message(20017, NULL,NULL, NULL, l_msg);
         	raise_application_error( -20017, l_msg);

end if;
p_message:=l_msg;
END select_new_sous_tache;

--*************************************************************************************************
-- Procedure select_tache
--
-- Permet d'afficher l'etape et la t¿che choisie pour la gestion des sous-t¿ches
-- Appelee dans la page igstache.htm
--
-- ************************************************************************************************
PROCEDURE select_tache (p_pid		IN isac_sous_tache.pid%TYPE,
			p_tache		IN VARCHAR2,
			p_userid     	IN VARCHAR2,
			p_keylist3out   OUT VARCHAR2,
			p_keylist4out   OUT VARCHAR2,
			p_nbcurseur    	OUT INTEGER,
                 	p_message    	OUT VARCHAR2
			    ) IS
l_etape NUMBER(10);
l_tache NUMBER(10);
l_pos NUMBER(10);
l_libetape VARCHAR2(100);
l_libtache VARCHAR2(100);
BEGIN
  p_nbcurseur := 0;
  p_message:='';
	-- p_tache est de la forme "etape-tache"
	l_pos := INSTR(p_tache,'-',1,1);
	l_etape := TO_NUMBER( SUBSTR(p_tache,1,l_pos-1));
	l_tache := TO_NUMBER( SUBSTR(p_tache,l_pos+1,LENGTH(p_tache)-l_pos+1));

	select e.ecet||'-'||e.libetape , t.acta||'-'||t.libtache
	into l_libetape,l_libtache
	from isac_tache t, isac_etape e
	where t.etape=e.etape
	and t.tache=l_tache;

	p_keylist3out := l_libetape;
	p_keylist4out := l_libtache;

END select_tache;


-- Retourne le libellé ligne bip, le code DPG et le libéllé du code DPG
PROCEDURE get_lib ( 	p_aist		    IN	VARCHAR2,
						 				  						 p_libpid	  OUT	LIGNE_BIP.pnom%TYPE,
																 p_codsg	  OUT	STRUCT_INFO.codsg%TYPE,
																 p_libcodsg	  OUT	STRUCT_INFO.libdsg%TYPE,
																 p_message	  OUT 	VARCHAR2
																) IS

typeligne char(2);


BEGIN

typeligne:='';

 BEGIN
    -- On recherche le libellé ligne bip et cod DPG
	SELECT PNOM, CODSG, TYPPROJ INTO p_libpid, p_codsg, typeligne
    FROM LIGNE_BIP
    WHERE PID=SUBSTR(p_aist,3);

BEGIN
 -- On recherche de lib dans la table struct_info
	SELECT 	libdsg
	INTO    p_libcodsg
	FROM 	STRUCT_INFO
	WHERE	codsg=p_codsg;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Pack_Global.recuperer_message( 20430, NULL, NULL, NULL, p_message);
	WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Pack_Global.recuperer_message(20373, '%s1',SUBSTR(p_aist,3),NULL, p_message);
	WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR( -20997, SQLERRM);

  END;

--if ( trim(typeligne) = '9' ) then
-- Pack_Global.recuperer_message(21163, NULL, NULL, NULL, p_message);
--end if;

END get_lib;

/**
 * Procedure de mise en favorite / suppression de mise en favorite d'une sous-tâche.
 */
PROCEDURE mettre_en_favorite(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE,
  p_favorite ISAC_SOUS_TACHE.FAVORITE%TYPE) IS
BEGIN
  update ISAC_SOUS_TACHE set FAVORITE=p_favorite where SOUS_TACHE=p_sous_tache;
  commit;
END mettre_en_favorite;

/**
 * Procedure de désaffectation d'une sous-tâche.
 */
PROCEDURE desaffecter(p_sous_tache ISAC_AFFECTATION.SOUS_TACHE%TYPE,
  p_ressource ISAC_AFFECTATION.IDENT%TYPE) IS
BEGIN

  -- ABN - HP PPM 61559
  delete from ISAC_CONSOMME where SOUS_TACHE=p_sous_tache and IDENT=p_ressource;
  delete from ISAC_AFFECTATION where SOUS_TACHE=p_sous_tache and IDENT=p_ressource;
  --mettre_en_favorite(p_sous_tache, 0);
END desaffecter;

/**
  Fonction de vérificaiton d'existence de consommé pour une sous-tâche / ressource sur l'année en cours
*/
FUNCTION existeConsomme(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE, p_ressource ISAC_AFFECTATION.IDENT%TYPE) return BOOLEAN IS
  l_anneecourante VARCHAR2(4);
  l_conso NUMBER;
   BEGIN
    -- Récupération de l'annee courante
    select to_char(datdebex,'YYYY') into  l_anneecourante
          from datdebex;

      -- Vérification de l'existence de consommé sur l'annee courante dans la table isac_consomme.
	  -- FAD PPM 65123 : Ajout du contrôle du consommé sur la table PMW_BIPS et CONS_SSTACHE_RES_MOIS
    SELECT  nvl(sum(consomme), 0) INTO l_conso
		FROM (
		SELECT c.cusag consomme
		FROM isac_consomme c
		WHERE c.sous_tache=to_number(p_sous_tache)
		AND to_char(c.cdeb,'YYYY')=l_anneecourante
		-- Ressource différente de la ressource courante (différente de la ressource sur laquelle la saisie de consommé est en cours)
		and c.ident!=p_ressource

		UNION

		SELECT cstrm.cusag consomme
		FROM cons_sstache_res_mois cstrm, isac_sous_tache ist, isac_tache it, isac_etape itp
		WHERE ist.sous_tache=to_number(p_sous_tache)
		AND ist.pid = cstrm.pid
		AND ist.acst = cstrm.acst
		AND ist.pid = it.pid
		AND ist.tache = it.tache
		AND it.acta = cstrm.acta
		AND ist.pid = itp.pid
		AND ist.etape = itp.etape
		AND itp.ecet = cstrm.ecet
		AND to_char(cstrm.cdeb,'YYYY')=l_anneecourante

		UNION
		SELECT PB.CONSOQTE
		FROM PMW_BIPS PB, isac_sous_tache ist, isac_tache it, isac_etape itp
		WHERE ist.sous_tache=to_number(p_sous_tache)
		AND ist.pid = PB.LIGNEBIPCODE
		AND ist.acst = PB.STACHENUM
		AND ist.pid = it.pid
		AND ist.tache = it.tache
		AND it.acta = PB.TACHENUM
		AND ist.pid = itp.pid
		AND ist.etape = itp.etape
		AND itp.ecet = PB.ETAPENUM
    /*QC - 1980 starts*/
    AND PB.PRIORITE = 'P2'
    /*QC - 1980 ends*/
		AND to_char(PB.CONSODEBDATE,'YYYY')=l_anneecourante
		)
		;
		-- FAD PPM 65123 : Fin

    -- Si du consommé est présent
    IF l_conso<>0 THEN
      return true;
    ELSE
      return false;
    END IF;
END existeConsomme;

FUNCTION existeConsommeDef(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE, p_ressource ISAC_AFFECTATION.IDENT%TYPE) return BOOLEAN IS
  l_anneecourante VARCHAR2(4);
  l_conso NUMBER;
  l_conso_sstache NUMBER;
  l_conso_bips NUMBER;
  l_PID VARCHAR2(6);
  l_ECET VARCHAR2(6);
  l_ACTA VARCHAR2(6);
  l_ACST VARCHAR2(6);
   BEGIN
    -- Récupération de l'annee courante
    select to_char(datdebex,'YYYY') into  l_anneecourante
          from datdebex;

  /*    -- Vérification de l'existence de consommé sur l'annee courante dans la table isac_consomme.
    SELECT  nvl(sum(c.cusag),0) INTO l_conso
    FROM isac_consomme c
    WHERE c.sous_tache=to_number(p_sous_tache)
    AND to_char(c.cdeb,'YYYY')=l_anneecourante
    -- Ressource différente de la ressource courante (différente de la ressource sur laquelle la saisie de consommé est en cours)
    and c.ident!=p_ressource;*/

    -- PPM 64935 : MHA -controle de consomme sur CONS_SSTACHE_RES_MOIS et PMW_BIPS
    SELECT distinct c.PID , e.ECET , t.ACTA , st.ACST into l_PID,l_ECET,l_ACTA,l_ACST
    FROM isac_consomme c, isac_tache t, isac_etape e, isac_sous_tache st
    WHERE c.sous_tache = to_number(p_sous_tache)
    AND c.sous_tache= st.sous_tache
    AND st.tache= t.tache
    And t.etape= e.etape;


    SELECT nvl(sum(c.cusag),0) into l_conso_sstache
    from cons_sstache_res_mois c
    where pid=l_PID
    and ecet=l_ECET
    and ACTA=l_ACTA
    and acst=l_ACST
    AND to_char(c.cdeb,'YYYY')=l_anneecourante
    and c.ident=p_ressource;


    SELECT nvl(sum(consoqte),0) into l_conso_bips
    FROM PMW_BIPS
    where LIGNEBIPCODE=l_PID
    and ETAPENUM=l_ECET
    and TACHENUM=l_ACTA
    and STACHENUM=l_ACST
    /*QC - 1980 starts*/
    AND PRIORITE = 'P2'
    /*QC - 1980 ends*/
    AND to_char(CONSODEBDATE,'YYYY')=l_anneecourante
    and RESSBIPCODE=p_ressource;


    -- END PPM 64935

    -- Si du consommé est présent
    IF l_conso<>0 OR l_conso_sstache<>0 OR l_conso_bips<>0 THEN
      return true;
    ELSE
      return false;
    END IF;
END existeConsommeDef;

/**
  Fonction de vérificaiton d'existence de consommé pour une sous-tâche / ressource sur l'année en cours
*/
PROCEDURE existeConsomme(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE, p_ressource ISAC_AFFECTATION.IDENT%TYPE, p_message OUT VARCHAR2) IS
  BEGIN
    p_message := '0';
    IF existeConsomme(p_sous_tache, p_ressource) THEN
      p_message := '1';
    END IF;
END existeConsomme;

PROCEDURE existeConsommeDef(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE, p_ressource ISAC_AFFECTATION.IDENT%TYPE, p_message OUT VARCHAR2) IS
  BEGIN
    p_message := '0';
    IF existeConsommeDef(p_sous_tache, p_ressource) THEN
      p_message := '1';
    END IF;
END existeConsommeDef;

/**
 * Procédure de suppression d'une sous-tâche.
 */
PROCEDURE supprimer(p_sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE, p_ressource ISAC_AFFECTATION.IDENT%TYPE, p_message OUT VARCHAR2) IS

  BEGIN
    existeConsomme(p_sous_tache, p_ressource, p_message);

     -- Pas d'erreur
    IF (p_message = '0') THEN
      delete isac_consomme
      where sous_tache=to_number(p_sous_tache);

      delete isac_affectation
      where sous_tache=to_number(p_sous_tache);

      -- Suppression de l'entrée de la table ISAC_SOUS_TACHE
      delete from ISAC_SOUS_TACHE where SOUS_TACHE=p_sous_tache;
      commit;
	END IF;
END supprimer;

END pack_isac_sous_tache ;
/
