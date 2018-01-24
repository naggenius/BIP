--*************************************************************************
-- MODIFICATION 
--    Le 11/07/2005 par DDI : Fiche 226 : Passage du type2 sur 3 caractères
--*************************************************************************

CREATE OR REPLACE PACKAGE pack_ferme_ligne AS

   -- definition d'un enregistrement de la table ligne_bip pour la gestion  des entetes

   TYPE ligne_bip_ViewType IS RECORD ( PID          LIGNE_BIP.PID%TYPE,
                                       CODCAMO      LIGNE_BIP.CODCAMO%TYPE,
                                       TYPPROJ      LIGNE_BIP.TYPPROJ%TYPE,
                                       ARCTYPE      LIGNE_BIP.ARCTYPE%TYPE,
                                       TOPTRI       LIGNE_BIP.TOPTRI%TYPE,
                                       ICPI         LIGNE_BIP.ICPI%TYPE,
                                       ILIBEL       PROJ_INFO.ILIBEL%TYPE,
                                       AIRT	    LIGNE_BIP.AIRT%TYPE,
                                       ALIBEL       APPLICATION.ALIBEL%TYPE,
                                       DPCODE       LIGNE_BIP.DPCODE%TYPE,
                                       DPLIB        DOSSIER_PROJET.DPLIB%TYPE,
                                       CODPSPE      LIGNE_BIP.CODPSPE%TYPE,
                                       LIBPSPE      PROJ_SPE.LIBPSPE%TYPE,
                                       CODSG        LIGNE_BIP.CODSG%TYPE,
                                       LIBDSG       STRUCT_INFO.LIBDSG%TYPE,
                                       RNOM         RESSOURCE.RNOM%TYPE,
                                       METIER       LIGNE_BIP.METIER%TYPE,
                                       PNOM         LIGNE_BIP.PNOM%TYPE,
                                       PNMOUVRA     LIGNE_BIP.PNMOUVRA%TYPE,
                                       CLICODE      LIGNE_BIP.CLICODE%TYPE,
                                       CLILIB       CLIENT_MO.CLILIB%TYPE,
                                       POBJET       LIGNE_BIP.POBJET%TYPE,
                                       ANNEE	    VARCHAR2(4),
                                       BNMONT       VARCHAR2(12),
                                       BPMONTME     VARCHAR2(12),
                                       ANMONT       VARCHAR2(12),
                                       REESTIME     VARCHAR2(12),
                                       ESTIMPLURIAN VARCHAR2(12),
                                       CUSAG 	    VARCHAR2(12),
                                       BPMONTMO     VARCHAR2(12),
                                       FLAGLOCK     ligne_bip.FLAGLOCK%TYPE
					);

  -- définition du curseur sur la table ligne_bip pour la gestion de l'entete du projet

   TYPE ligne_bipCurType IS REF CURSOR RETURN ligne_bip_ViewType;



	PROCEDURE select_ligne( p_pid          IN ligne_bip.pid%TYPE,
                                p_adatestatut  IN VARCHAR2,
                                p_global       IN VARCHAR2,
                                p_curLigne_bip IN OUT ligne_bipCurType,
                                p_last_conso   	   OUT VARCHAR2,
                                p_nbcurseur    OUT INTEGER,
                                p_message      OUT VARCHAR2
                              );
                              
   	PROCEDURE ferme_ligne (	p_pid         	IN  ligne_bip.pid%TYPE,
		       		p_adatestatut 	IN  VARCHAR2,
		       		p_flaglock	IN  VARCHAR2,
                              	p_global      	IN  VARCHAR2,
                              	p_message     	OUT VARCHAR2
                              );

END pack_ferme_ligne;
/


CREATE OR REPLACE PACKAGE BODY BIP.pack_ferme_ligne AS

PROCEDURE select_ligne ( 	p_pid          	IN ligne_bip.pid%TYPE,
                                p_adatestatut  	IN VARCHAR2,
                                p_global      	IN VARCHAR2,
                                p_curLigne_bip 	IN OUT ligne_bipCurType,
                                p_last_conso   	   OUT VARCHAR2,
                                p_nbcurseur    	   OUT INTEGER,
                                p_message      	   OUT VARCHAR2
                              ) IS
	msg 		     VARCHAR(1024);
	l_pid 			 ligne_bip.pid%TYPE;
	l_datdebex		 VARCHAR2(4);
	l_moismens		 datdebex.moismens%TYPE;
	l_typproj 		 ligne_bip.typproj%TYPE;
	l_arctype 		 ligne_bip.arctype%TYPE;
	l_adatestatut	 ligne_bip.adatestatut%TYPE;
	l_codsg			 ligne_bip.codsg%TYPE;
	l_habilitation 	 VARCHAR2(10);
    l_datesaisie 	 VARCHAR2(6);
    l_annee		 	 VARCHAR2(4);
    l_mois		 	 VARCHAR2(2);
    l_dpcode     	 ligne_bip.dpcode%TYPE;
	l_conso          NUMBER;
	d_last_conso	 VARCHAR2(8);

BEGIN
      	-- ====================================================================
      	-- On teste l'existence de la ligne et on récupère ses données
      	-- ====================================================================
  	 BEGIN
            SELECT pid, typproj, arctype, adatestatut, codsg, dpcode 
            INTO l_pid, l_typproj, l_arctype, l_adatestatut, l_codsg, l_dpcode
            FROM ligne_bip
            WHERE pid = p_pid;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               -- Code projet %s1 inexistant
               pack_global.recuperer_message(20504, '%s1', p_pid, NULL, msg);
               raise_application_error( -20504, msg );
            WHEN OTHERS THEN
               raise_application_error( -20997, SQLERRM);
	  END;


      	-- ====================================================================
      	-- Test appartenance au perimetre ME
      	-- ====================================================================
     	pack_habilitation.verif_habili_me(TO_CHAR(l_codsg, 'FM0000000'), p_global, msg );

      	-- ====================================================================
      	--  test sur le TYPE (doit etre <> T1)
      	-- ====================================================================
	IF l_typproj = '1 ' AND (l_arctype = 'T1' OR l_dpcode <> '00000') THEN
       		--('vous n etes pas autorisé à fermer une ligne T1')
       		pack_global.recuperer_message(20365, '%s1',  'fermer une ligne T1','PID', msg);
	   	raise_application_error(-20365,  msg);
   	END IF;
    
      	-- ====================================================================
      	--  test sur un ligne non fermée
      	-- ====================================================================
	IF l_adatestatut IS NOT NULL THEN
       		--('cette ligne est déjà fermée ')
       		pack_global.recuperer_message(20981, '%s1', p_pid, 'PID', msg);
	   	raise_application_error(-20981,  msg);
   	END IF;


      	-- ====================================================================
      	--  Récupération du drnier mois où un consommé a été saisi 
      	-- ====================================================================
	
	SELECT moismens 
	INTO l_moismens
	FROM datdebex
	WHERE rownum < 2;

	select nvl(to_char(max(cdeb),'mm/yyyy'),'12/'||to_char(to_number(to_char(l_moismens,'yyyy'))-1)) 
	  into d_last_conso
	  from proplus 
	 where pid=p_pid
	   and to_char(cdeb,'yyyy') = to_char(l_moismens,'yyyy');

	p_last_conso := d_last_conso;
	
	select sum(cusag)
	  into l_conso
	  from proplus
	 where pid=p_pid
	   and trunc(cdeb)>trunc(TO_DATE(p_adatestatut, 'MM/YYYY'));

	if (l_conso>0) then
   		pack_global.recuperer_message(20365, '%s1', 'effectuer une fermeture sur une ligne ayant une consommation après la date de fermeture.', 'ADATESTATUT', msg);
	   	raise_application_error(-20365,  msg);
	end if;
	
/*
	IF TO_DATE(p_adatestatut, 'MM/YYYY') <= l_moismens THEN
		--('vous n etes pas autorisé à effectuer une fermeture rétroactive')
       		pack_global.recuperer_message(20365, '%s1',  'effectuer une fermeture rétroactive','ADATESTATUT', msg);
	   	raise_application_error(-20365,  msg);
	END IF;
*/	
      	-- ====================================================================
      	--  Curseur rapportant les infos sur la ligne BIP
      	-- ====================================================================
      	
	BEGIN
		SELECT TO_CHAR(datdebex, 'YYYY') 
		INTO l_datdebex
		FROM datdebex
		WHERE rownum < 2;
	
		OPEN p_curLigne_bip FOR
			SELECT lb.PID,
			lb.CODCAMO, --CA payeur
			lb.TYPPROJ, --type
			lb.ARCTYPE, 	--typologie
			lb.TOPTRI,
			lb.ICPI, 	--code projet
			pi.ILIBEL, 	--libelle projet
			lb.AIRT, 	--code irt
			a.ALIBEL,	--libelle application
			lb.DPCODE,	--code dossier projet
			dp.DPLIB, 	--libelle dossier projet
			lb.codpspe, 	-- projet special
			ps.LIBPSPE, 	--libelle projet special
			lb.CODSG, 	--DPG
			st.LIBDSG, 	--libelle DPG
			r.RNOM, 	--nom chef de projet
			lb.METIER,
			lb.PNOM, 	--libelle ligne BIP
			rtrim(lb.PNMOUVRA), 	--nom du correspondant MO
			lb.CLICODE, 	--direction cliente
			cm.CLILIB,	--direction cliente
			lb.POBJET, 	--zone de texte
			l_datdebex,	-- Année en cours
			DECODE( b.BNMONT,NULL,',00',TO_CHAR(b.BNMONT, 'FM9999999990D00')) AS BNMONT,  		--budget notifie
		        DECODE(b.BPMONTME,NULL,',00',TO_CHAR(b.BPMONTME, 'FM9999999990D00')) AS BPMONTME,	--propose ME
		        DECODE(b.ANMONT,NULL,',00',TO_CHAR(b.ANMONT, 'FM9999999990D00')) AS ANMONT,		--arbitre
		        DECODE(b.REESTIME,NULL,',00',TO_CHAR(b.REESTIME, 'FM9999999990D00')) AS REESTIME,	--re-estime ME
		        DECODE(lb.ESTIMPLURIAN,NULL,',00',TO_CHAR(lb.ESTIMPLURIAN, 'FM9999999990D00')) AS ESTIMPLURIAN,	--estimation pluriannuelle
		        DECODE(c.CUSAG ,NULL,',00',TO_CHAR(c.CUSAG , 'FM9999999990D00')) AS CUSAG,	--realise
		        DECODE( b.BPMONTMO ,NULL,',00',TO_CHAR( b.BPMONTMO , 'FM9999999990D00')) AS BPMONTMO,	--propose MO
			lb.FLAGLOCK
	
		FROM  ligne_bip lb,
	              struct_info st,
        	      ressource r,
        	      dossier_projet dp,
        	      proj_spe ps,
        	      proj_info pi,
        	      client_mo cm,
        	      application a,
        	      budget b,
        	      consomme c
      		WHERE lb.pid = p_pid
      		AND lb.pid = b.pid(+)
      		AND lb.pid = c.pid(+)
      		AND lb.codsg=st.codsg
      		AND r.ident=lb.pcpi
      		AND lb.airt=a.airt
      		AND lb.icpi=pi.icpi
      		AND lb.dpcode=dp.dpcode
      		AND lb.codpspe=ps.codpspe(+)
      		AND cm.clicode=lb.clicode
      		AND b.annee(+) = TO_NUMBER(l_datdebex)
      		AND c.annee(+) = TO_NUMBER(l_datdebex);
     	
      EXCEPTION
         	WHEN OTHERS THEN
         	   raise_application_error(-20997,SQLERRM);
      END;


END select_ligne;

   PROCEDURE ferme_ligne (	p_pid         	IN  ligne_bip.pid%TYPE,
		       		p_adatestatut 	IN  VARCHAR2,
		       		p_flaglock	IN  VARCHAR2,
                              	p_global      	IN  VARCHAR2,
                              	p_message     	OUT VARCHAR2
                             ) IS 

 l_user		ligne_bip_logs.user_log%TYPE;
 -- Valeurs précédentes pour les logs
 l_topfer	ligne_bip.topfer%TYPE;
 l_adatestatut	ligne_bip.adatestatut%TYPE;

   BEGIN

      -- Initialiser le message retour
      p_message := '';
      l_user := SUBSTR(pack_global.lire_globaldata(p_global).idarpege, 1, 30);

	
      BEGIN

         -- On récupère les valeurs précédentes pour les logs
         SELECT topfer, adatestatut
         INTO l_topfer, l_adatestatut
         FROM ligne_bip
         WHERE pid = p_pid
         AND flaglock = p_flaglock;

         UPDATE ligne_bip 
         SET 	topfer     = 'O',
             	adatestatut = TO_DATE(p_adatestatut, 'MM/YYYY'),
             	flaglock    = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE  pid = p_pid
         AND flaglock = p_flaglock;

         -- On loggue le topfer, la date de statut
         pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'Top fermeture', l_topfer, 'O', 'Fermeture de la ligne BIP via pcmmenu');
         pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'Date statut', TO_CHAR(l_adatestatut, 'MM/YYYY'), p_adatestatut, 'Fermeture de la ligne BIP via pcmmenu');


	 --Audit
	 pack_st_amort.audit(p_pid, TO_CHAR(SYSDATE, 'DD/MM/YYYY'), SUBSTR(l_user, 1, 15), 'Fermeture via pcmmenu', p_message);

      EXCEPTION
         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

      pack_global.recuperer_message(20371, '%s1', p_pid, NULL, p_message);

END ferme_ligne;

END pack_ferme_ligne;
/


