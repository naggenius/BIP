 /* ***************************************
 
  Package servant à l'édition de synthèse des couts projets en euros
  Utilisée dans le menu Habilitations par référentiels
  Appelée par SynthCoutProj.rdf
  
 Modifié par PPR le 30/09/2005 : prend le dossier projet dans le périmètre des lignes d'investissement 
-- 06/01/2012 QC 1329
  
  ****************************************** */

CREATE OR REPLACE PACKAGE     pack_hab_ref AS


FUNCTION Delete_Donnees (P_numseq IN NUMBER)
RETURN BOOLEAN;

FUNCTION Select_Donnees (p_param7  IN VARCHAR2, 	-- Dossier projet demandé
			p_codcamo IN VARCHAR2, 	-- Centre d'activité demandé
			p_dos_proj IN VARCHAR2, -- Dossiers projets habilités dans le RTFE
			p_projet IN VARCHAR2, 	-- Projets habilités dans le RTFE
			p_app IN VARCHAR2)	-- Applications habilitées dans le RTFE
RETURN NUMBER ;

END pack_hab_ref;
/


CREATE OR REPLACE PACKAGE BODY     pack_hab_ref AS


-- -------------------------------------------------------------------------
-- FUNCTION Delete_Donnees
-- Role : Supprime, dans la table TMP_SYNTHCOUTPROJ, les données creees par la
-- fonction Select_Donnees A la fin de l'édition.
-- -------------------------------------------------------------------------

FUNCTION Delete_Donnees (
			 P_numseq IN NUMBER
                         ) RETURN BOOLEAN IS
BEGIN
   DELETE FROM TMP_SYNTHCOUTPROJ
   WHERE  numseq = p_numseq;
   COMMIT;
   RETURN TRUE;
EXCEPTION
      WHEN OTHERS THEN RETURN(FALSE); -- NOK
END Delete_Donnees;

-- -------------------------------------------------------------------------
-- FUNCTION Select_Donnees
-- -------------------------------------------------------------------------
FUNCTION Select_Donnees (
			p_param7  IN VARCHAR2, 	-- Dossier projet demandé
			p_codcamo IN VARCHAR2, 	-- Centre d'activité demandé
			p_dos_proj IN VARCHAR2, -- Dossiers projets habilités dans le RTFE
			p_projet IN VARCHAR2, 	-- Projets habilités dans le RTFE
			p_app IN VARCHAR2 	-- Applications habilitées dans le RTFE
                        ) RETURN NUMBER IS

   l_annee0  NUMBER(4);
   l_msg  VARCHAR2(1024);

   l_where  VARCHAR2(1024); -- Chaine pour constituer la requete
   l_where_ca  VARCHAR2(200);-- Chaine pour constituer la clause where sur les CA

   -- Données ramenées par les curseurs
   l_clicode client_mo.clicode%TYPE;
   l_clisigle client_mo.clisigle%TYPE;
   l_typedp type_dossier_projet.typdp%TYPE;
   l_codcamo ligne_investissement.codcamo%TYPE;
   l_annee  NUMBER(4);
   l_dpcode ligne_investissement.dpcode%TYPE;
   l_libdp dossier_projet.dplib%TYPE;
   l_filcode centre_activite.filcode%TYPE;
   l_conso tmp_synthcoutproj.conso%TYPE;

   l_numseq         NUMBER ; -- numéro de séquence identifiant l'edition en cours

   -- Données pour la clause where sur Dossier Projet,Projet,Application
   l_doss_proj VARCHAR2(5000);
   l_projet VARCHAR2(5000);
   l_application VARCHAR2(200);
   l_hab VARCHAR2(500);
   l_tous VARCHAR2(10);

   l_test 	CHAR(1) ; -- utilisée dans un test d'existance

   TYPE RefCurTyp IS REF CURSOR;
   c_ligne_inv RefCurTyp; -- déclaration du cursor sur les investissements
   c_ligne_bip RefCurTyp; -- déclaration du cursor sur les lignes BIP

BEGIN
	-- p_msg := '';
	SELECT TO_NUMBER( TO_CHAR( datdebex, 'YYYY') )
	INTO l_annee0
	FROM datdebex;

	-- Définition de la requete
	l_where := 'select distinct cli.clicode CLICODE,'
		|| 'cli.clisigle CLISIGLE,'
		|| 'typedp.typdp TYPEDP,'
		|| 'l_inv.CODCAMO CODCAMO,'
	 	|| 'l_inv.ANNEE  ANNEE,'
	        || 'l_inv.dpcode DPCODE,'
	        || 'dp.dplib     LIBDP,'
	        || 'ca.filcode FILCODE';
	l_where := l_where || ' FROM centre_activite ca,'
	 	|| 'client_mo cli,'
	     	|| 'ligne_investissement l_inv,'
	 	|| 'investissements inv,'
	 	|| 'dossier_projet dp,'
	        || 'type_dossier_projet typedp';
	l_where := l_where ||' WHERE inv.codtype = l_inv.type'
		|| ' AND dp.dpcode=l_inv.dpcode'
		|| ' AND dp.typdp=typedp.typdp'
		|| ' AND ca.codcamo=l_inv.codcamo'
		|| ' AND cli.clidep <> 0'
		|| ' AND cli.clipol=0'
		|| ' AND (ca.codcamo=cli.codcamo'
	     	|| ' or ca.caniv1=cli.codcamo'
	     	|| ' or ca.caniv2=cli.codcamo'
	     	|| ' or ca.caniv3=cli.codcamo'
	     	|| ' or ca.caniv4=cli.codcamo)'
	    	|| ' AND l_inv.annee='|| l_annee0 ;

	l_where_ca := ' ';

	-- CENTRE ACTIVITE
  	if(p_codcamo IS NOT NULL and p_codcamo<> 'TOUS' ) THEN
	   	l_where_ca := ' and (ca.CODCAMO IN (' || p_codcamo
	   	||') or ca.CANIV1 IN (' || p_codcamo
	   	||') or ca.CANIV2 IN (' || p_codcamo
	   	||') or ca.CANIV3 IN (' || p_codcamo
	   	||') or ca.CANIV4 IN (' || p_codcamo ||')) ';
	end if ;

	l_hab := ' ';

	-- DOSSIER PROJET
    -- Dossier Projet demandé
  	if(p_param7 IS NOT NULL and p_param7 <> 'TOUS') THEN
	  	l_hab := ' and l_inv.DPCODE IN (' ||p_param7 ||') ';
	else
	 	-- Si il n'y a aucun critère passe - construit à partir des données du RTFE
 	  	if(p_dos_proj IS NOT NULL AND p_dos_proj<> 'TOUS') THEN
			l_hab := ' and l_inv.DPCODE IN (' || p_dos_proj ||') ';
		end if;
	end if;

	l_where := l_where || l_where_ca || l_hab;


	-- Recherche du numéro de séquence de l'édition
      	SELECT Seqreftrans.nextval INTO l_numseq FROM dual;


	OPEN c_ligne_inv   for l_where  ;

        LOOP
            	FETCH c_ligne_inv INTO l_clicode,l_clisigle,l_typedp,l_codcamo,l_annee,l_dpcode,l_libdp,l_filcode ;

	    	EXIT WHEN c_ligne_inv%NOTFOUND;

            	INSERT INTO TMP_SYNTHCOUTPROJ
	       	(numseq,CLICODE,CLISIGLE,TYPEDP, CODCAMO, ANNEE, DPCODE, LIBDP,FILCODE
	       	)
	      	VALUES
               	(l_numseq,l_clicode,l_clisigle,l_typedp,l_codcamo,l_annee,l_dpcode,
                l_libdp,l_filcode
                );

        END LOOP;

	COMMIT ;

	CLOSE c_ligne_inv   ;


        -- Calcul des montants des lignes d'investissement par Materiel,Logiciel, Mobilier

            -- MATERIEL
            UPDATE TMP_SYNTHCOUTPROJ tmp SET (NOTIFIE_MAT,REALISE_MAT)=
	    (select sum(pack_utile_cout.AppliqueTauxHTR(TO_NUMBER(TO_CHAR(d.datdebex,'yyyy')),l_inv.notifie,TO_CHAR(d.datdebex,'dd/mm/yyyy'),tmp.filcode)),
	    sum(pack_suivi_investissement.sum_realises_htr(TO_NUMBER(l_inv.codinv),TO_NUMBER(l_inv.codcamo),TO_NUMBER(l_inv.annee)))
	    from datdebex d,ligne_investissement l_inv,investissements inv
	    where
	    inv.codposte=1000
	    AND inv.codtype = l_inv.type
	    AND l_inv.dpcode=tmp.dpcode
	    AND l_inv.codcamo=tmp.codcamo
	    AND l_inv.annee=TO_NUMBER(TO_CHAR(d.datdebex,'yyyy'))
	    )
	    where numseq =  l_numseq
	    ;
	    COMMIT;

	    -- LOGICIEL
	    UPDATE TMP_SYNTHCOUTPROJ tmp SET (NOTIFIE_LOG,REALISE_LOG)=
	    (select sum(pack_utile_cout.AppliqueTauxHTR(TO_NUMBER(TO_CHAR(d.datdebex,'yyyy')),l_inv.notifie,TO_CHAR(d.datdebex,'dd/mm/yyyy'),tmp.filcode)),
	    sum(pack_suivi_investissement.sum_realises_htr(TO_NUMBER(l_inv.codinv),TO_NUMBER(l_inv.codcamo),TO_NUMBER(l_inv.annee)))
	    from datdebex d,ligne_investissement l_inv,investissements inv
	    where
	    inv.codposte=2000
	    AND inv.codtype = l_inv.type
	    AND l_inv.dpcode=tmp.dpcode
	    AND l_inv.codcamo=tmp.codcamo
	    AND l_inv.annee=TO_NUMBER(TO_CHAR(d.datdebex,'yyyy'))
	    )
	    where numseq =  l_numseq
	    ;
	    COMMIT;

	    -- MOBILIER
	    UPDATE TMP_SYNTHCOUTPROJ tmp SET (NOTIFIE_MOB,REALISE_MOB)=
	    (select sum(pack_utile_cout.AppliqueTauxHTR(TO_NUMBER(TO_CHAR(d.datdebex,'yyyy')),l_inv.notifie,TO_CHAR(d.datdebex,'dd/mm/yyyy'),tmp.filcode)),
	    sum(pack_suivi_investissement.sum_realises_htr(TO_NUMBER(l_inv.codinv),TO_NUMBER(l_inv.codcamo),TO_NUMBER(l_inv.annee)))
	    from datdebex d,ligne_investissement l_inv,investissements inv
	    where
	    inv.codposte=3000
	    AND inv.codtype = l_inv.type
	    AND l_inv.dpcode=tmp.dpcode
	    AND l_inv.codcamo=tmp.codcamo
	    AND l_inv.annee=TO_NUMBER(TO_CHAR(d.datdebex,'yyyy'))
	    )
	    where numseq =  l_numseq
	    ;
	    COMMIT;

	-- Regroupe toutes les lignes (par client , dossier projet ) sur une seule ligne avec codcamo à 0
	INSERT INTO TMP_SYNTHCOUTPROJ
	       	(numseq,CLICODE,CLISIGLE,TYPEDP, CODCAMO, ANNEE, DPCODE, LIBDP,FILCODE,
	       	NOTIFIE_MAT,REALISE_MAT,NOTIFIE_LOG,REALISE_LOG,NOTIFIE_MOB,REALISE_MOB
	       	)
	SELECT numseq, clicode, clisigle, typedp ,0, annee , dpcode , libdp , filcode,
		sum(NOTIFIE_MAT),sum(REALISE_MAT),sum(NOTIFIE_LOG),sum(REALISE_LOG),sum(NOTIFIE_MOB),sum(REALISE_MOB)
	FROM TMP_SYNTHCOUTPROJ
	WHERE numseq =  l_numseq
	GROUP BY numseq, clicode, clisigle, typedp , annee , dpcode , libdp , filcode ;

        -- Supprime toutes les lignes regroupées
	DELETE FROM TMP_SYNTHCOUTPROJ
	WHERE numseq =  l_numseq
	AND   codcamo <> 0 ;

        COMMIT ;

	-- Recherche des lignes BIP à prendre en compte

	-- Définition de la requete
	l_where := 'select d.clicode CLICODE,'
		|| 'd.clisigle CLISIGLE,'
		|| 'typedp.typdp TYPEDP,'
	        || 'lb.dpcode DPCODE,'
	        || 'dp.dplib     LIBDP,'
	        || 'round(sum( nvl(cc.ftsg,0) + nvl(cc.ftssii,0) + nvl(cc.envsg,0) + nvl(cc.envssii,0) ) /1000) CONSO';
	l_where := l_where || ' FROM ligne_bip lb,'
	 	|| 'client_mo d,'
	 	|| 'client_mo p,'
	 	|| 'cumul_conso cc,'
	 	|| 'dossier_projet dp,'
	        || 'type_dossier_projet typedp';
	l_where := l_where ||' WHERE cc.pid=lb.pid'
		|| ' AND dp.dpcode=lb.dpcode'
		|| ' AND dp.typdp=typedp.typdp'
		|| ' AND d.clidir=p.clidir'
		|| ' AND d.clidep=p.clidep'
		|| ' AND d.clipol=0'
		|| ' AND p.clicode = lb.clicode'
	    	|| ' AND cc.annee='|| l_annee0 ;

	-- Code du CA --
	-- Recherche des clients dont le CA est dans la liste des CA payeur du RTFE
	l_where_ca := ' AND lb.clicode IN ( SELECT clicoderatt FROM vue_clicode_hierarchie v, client_mo cl ' ||
			' WHERE v.clicode = cl.clicode ' ||
			' AND cl.codcamo IN (';

   	if(p_codcamo IS NOT NULL and p_codcamo<> 'TOUS' ) THEN
		l_where := l_where || l_where_ca  || p_codcamo ||')) ';
	end if ;

        --
	-- Rajout des restrictions sur Dossier projet, Projet, Application
	--

	l_doss_proj :='VIDE';
	l_projet := 'VIDE';
	l_application :='VIDE';
	l_tous :='VIDE';

	-- Test pour savoir si une des valeurs du RTFE est tous
	if ((NVL(p_dos_proj,' ')= 'TOUS' or NVL(p_projet,' ')= 'TOUS' or NVL(p_app,' ') = 'TOUS')) THEN
		l_tous:='TOUS';
	end if ;

        -- Dossier Projet demandé
  	if(p_param7 IS NOT NULL and p_param7 <> 'TOUS') THEN
	  	l_doss_proj := ' lb.DPCODE IN (' ||p_param7 ||') ';
	  end if;

 	-- Si il n'y a aucun critère passe - construit à partir des données du RTFE
 	if ( l_doss_proj = 'VIDE' and l_tous <> 'TOUS') THEN
 			--dossier projet
 	  	if(p_dos_proj IS NOT NULL ) THEN
			l_doss_proj := ' lb.DPCODE IN (' || p_dos_proj ||') ';
			end if;
			-- projet
  	  	if(p_projet IS NOT NULL) THEN
		  	l_projet := ' lb.ICPI IN ('''||p_projet||''') ';
		  end if ;
		 -- application
 	  	if(p_app IS NOT NULL) THEN
	  		l_application := ' lb.AIRT IN ('''||p_app||''')';
	  	end if;
  	end if ;

 	-- Compile le select sur Dossier projet, Projet, Application
 	if ( l_doss_proj <> 'VIDE' OR l_projet <> 'VIDE' OR l_application <> 'VIDE' ) THEN
 		l_hab := ' AND ( ' ;
 		if (  l_doss_proj <> 'VIDE' ) then
 			l_hab := l_hab || l_doss_proj ;
 		end if;
 		if ( l_projet <> 'VIDE' ) then
 			if ( l_hab <> ' AND ( ') then
 				l_hab := l_hab || ' OR ' ;
 			end if ;
 			l_hab := l_hab || l_projet ;
 		end if ;
 		if ( l_application <> 'VIDE' ) then
 			if ( l_hab <> ' AND ( ') then
 				l_hab := l_hab || ' OR ' ;
 			end if ;
 			l_hab := l_hab || l_application ;
 		end if ;
 		l_hab := l_hab ||' ) ' ;
 		l_where := l_where || l_hab ;
 	end if ;

	-- Rajout du Group By
	l_where := l_where || ' GROUP BY d.clicode,d.clisigle,typedp.typdp,lb.dpcode,dp.dplib ' ;

--insert into test_message(message) values(l_where);

	OPEN c_ligne_bip   for l_where  ;

        LOOP
            	FETCH c_ligne_bip INTO l_clicode,l_clisigle,l_typedp,l_dpcode,l_libdp,l_conso ;

	    	EXIT WHEN c_ligne_bip%NOTFOUND;

                BEGIN
                	-- Recherche si une ligne existe dans TMP_SYNTHCOUTPROJ
	                SELECT '1' into l_test FROM TMP_SYNTHCOUTPROJ
	                WHERE numseq=l_numseq
	                AND   clicode=l_clicode
	                AND   dpcode=l_dpcode;

			-- Met à jour le consommé
	                UPDATE TMP_SYNTHCOUTPROJ SET CONSO=l_conso
	                WHERE numseq=l_numseq
	                AND   clicode=l_clicode
	                AND   dpcode=l_dpcode;

	  	EXCEPTION
	            WHEN NO_DATA_FOUND THEN
	      	  	-- Insère une ligne dans TMP_SYNTHCOUTPROJ
	      	  	-- Cas des départements qui n'ont pas de lignes d'investissements
	      	  	IF (l_conso<>0) THEN
		      	  	INSERT INTO TMP_SYNTHCOUTPROJ
		       		(numseq,CLICODE,CLISIGLE,TYPEDP,ANNEE, DPCODE, LIBDP,CONSO
		       		)
		      		VALUES
	               		(l_numseq,l_clicode,l_clisigle,l_typedp,l_annee0,l_dpcode,
	                	l_libdp,l_conso
	                	);
	            END IF;
	    	END;

        END LOOP;

	COMMIT ;

	CLOSE c_ligne_bip   ;

	-- Met à jour le budget par département et dossier projet
        UPDATE TMP_SYNTHCOUTPROJ tmp SET BUDGET=
		   ( SELECT BUDGETHTR
		     FROM BUDGET_DP b
		     WHERE b.annee=l_annee0
		     AND   b.dpcode=tmp.dpcode
		     AND   b.clicode=tmp.clicode
		   )
	WHERE tmp.numseq =  l_numseq;
	COMMIT;

      RETURN l_numseq;

EXCEPTION
    WHEN OTHERS THEN
    RETURN 0; -- code d'erreur
END Select_Donnees;


END pack_hab_ref;
/


