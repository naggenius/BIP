--*************************************************************************
-- MODIFICATION 
--   Le 11/07/2005 par DDI : Fiche 226 : Passage du type2 sur 3 caractères
-- Le 11/05/2011 par CMA : fiche 1176, si on passe par le menu client, on tulise perimcli au lieu de perimo
--*************************************************************************

CREATE OR REPLACE PACKAGE     pack_ligne_bip_mo AS

   -- definition d'un enregistrement de la table ligne_bip pour la gestion  des entetes

   TYPE ligne_bip_ViewType IS RECORD ( PID          LIGNE_BIP.PID%TYPE,
   				       ANNEE 	    CHAR(4),
                                       CODCAMO      LIGNE_BIP.CODCAMO%TYPE,
                                       TYPPROJ      LIGNE_BIP.TYPPROJ%TYPE,
                                       ARCTYPE      LIGNE_BIP.ARCTYPE%TYPE,
                                       TOPTRI       LIGNE_BIP.TOPTRI%TYPE,
                                       LIBSTATUT    CODE_STATUT.LIBSTATUT%TYPE,
                                       TOPFER       LIGNE_BIP.TOPFER%TYPE,
                                       ADATESTATUT  CHAR(10),
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
                                       CLICODE_OPER LIGNE_BIP.CLICODE_OPER%TYPE,
                                       CLILIB_OPER  VARCHAR2(50),
                                       POBJET       LIGNE_BIP.POBJET%TYPE,
                                       BNMONT       VARCHAR2(12),
                                       BPMONTME     VARCHAR2(12),
                                       ANMONT       VARCHAR2(12),
                                       REESTIME     VARCHAR2(12),
                                       ESTIMPLURIAN VARCHAR2(12),
                                       CUSAG 	    VARCHAR2(12),
                                       BPMONTMO     VARCHAR2(12),
                                       FLAG 	    budget.FLAGLOCK%TYPE,
                                       FLAGLOCK     ligne_bip.FLAGLOCK%TYPE
					);

  -- définition du curseur sur la table ligne_bip pour la gestion de l'entete du projet

   TYPE ligne_bipCurType IS REF CURSOR RETURN ligne_bip_ViewType;



	PROCEDURE select_ligne_bip_mo ( p_pid          IN ligne_bip.pid%TYPE,
                                	p_date         IN CHAR,
                                	p_global       IN VARCHAR2,
                                	p_curLigne_bip IN OUT ligne_bipCurType,
                                	p_nbcurseur    OUT INTEGER,
                                	p_message      OUT VARCHAR2
                              );

	PROCEDURE update_ligne_bip_mo (	p_pid         	IN ligne_bip.pid%TYPE,
					p_date 		IN CHAR,
					p_codcamo 	IN CHAR,
					p_typproj 	IN CHAR,
					p_arctype 	IN VARCHAR2,
					p_toptri 	IN CHAR,
					p_libstatut 	IN CHAR,
					p_topfer 	IN CHAR,
					p_adatestatut 	IN CHAR,
					p_icpi 		IN CHAR,
					p_ilibel 	IN CHAR,
					p_airt 		IN CHAR,
					p_alibel 	IN CHAR,
					p_dpcode 	IN ligne_bip.dpcode%TYPE,
					p_dplib 	IN dossier_projet.dplib%TYPE,
					p_codpspe 	IN CHAR,
					p_libpspe 	IN CHAR,
					p_codsg       	IN char,
					p_libdsg 	IN CHAR,
					p_rnom 		IN CHAR,
					p_metier 	IN CHAR,
					p_pnom        	IN CHAR,
	 				p_pnmouvra    	IN CHAR,
	 				p_clicode     	IN char,
	 				p_clilib 	IN CHAR,
	 				p_liste_objet 	IN varchar2,
					p_pobjet     	IN varchar2,
					p_bnmont 	IN VARCHAR2,
					p_bpmontme 	IN VARCHAR2,
					p_anmont 	IN VARCHAR2,
					p_reestime 	IN VARCHAR2,
					p_estimplurian 	IN VARCHAR2,
					p_cusag 	IN VARCHAR2,
					p_bpmontmo 	IN VARCHAR2,
					p_flag 		IN number,
					p_flaglock    	IN number,
					p_global      	IN VARCHAR2,
		                        p_nbcurseur   	OUT INTEGER,
                		        p_message     	OUT VARCHAR2
                              );

END pack_ligne_bip_mo;
/


CREATE OR REPLACE PACKAGE BODY     pack_ligne_bip_mo AS

PROCEDURE select_ligne_bip_mo ( p_pid          	IN ligne_bip.pid%TYPE,
                                p_date      	IN CHAR,
                                p_global      	IN VARCHAR2,
                                p_curLigne_bip 	IN OUT ligne_bipCurType,
                                p_nbcurseur    	OUT INTEGER,
                                p_message      	OUT VARCHAR2
                              ) IS
	msg 		VARCHAR(1024);
	l_pid 		ligne_bip.pid%TYPE;
	l_perimo 	VARCHAR2(1000);
	l_clicode 	ligne_bip.clicode%TYPE;
	l_typproj 	ligne_bip.typproj%TYPE;
	l_habilitation 	boolean;
      	l_annee		VARCHAR2(4);
    	l_topfer    	ligne_bip.topfer%TYPE;
    	l_statut	ligne_bip.astatut%TYPE;
        l_menu VARCHAR2(25);

BEGIN

  	 BEGIN
            SELECT pid INTO l_pid
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


	-- test sur le TYPE
	BEGIN
		SELECT typproj INTO l_typproj
	 	FROM ligne_bip
		WHERE pid=p_pid;

	 EXCEPTION
           WHEN OTHERS THEN
             raise_application_error( -20997, SQLERRM);
	END;
	IF l_typproj = 7 THEN
       --('vous n etes pas autorisé à modifier cette ligne bip')
       pack_global.recuperer_message(20365, '%s1',  'modifier cette ligne BIP','PID', msg);
	   raise_application_error(-20365,  msg);
   	END IF;


    -- Test si la ligne bip est ouverte : Ajout S LALLIER 24/12/03
    BEGIN
      select topfer, astatut into l_topfer, l_statut
      from ligne_bip where pid = p_pid;

      IF ( (l_topfer = 'O') OR (l_statut='A') OR (l_statut='D') ) THEN
            -- Ligne bip %s1 fermée
            pack_global.recuperer_message(20981, '%s1', p_pid, NULL, msg);
            p_message := msg;
            raise_application_error(-20981, msg);
      END IF;
    END;

         -- Controle habilitation Departement et pole
	BEGIN
	 SELECT clicode INTO l_clicode
	 FROM ligne_bip
	 WHERE pid=p_pid
	 ;

        l_menu := pack_global.lire_globaldata(p_global).menutil;
		
		if('MO'=l_menu)then
			l_perimo := pack_global.lire_globaldata(p_global).perimcli;
		else
			l_perimo := pack_global.lire_globaldata(p_global).perimo;
		end if;


--raise_application_error(-20000,'MO:'||l_codperimo||' dir: ' ||p_clicode);

         EXCEPTION
           WHEN OTHERS THEN
             raise_application_error( -20997, SQLERRM);

         END;

      -- ====================================================================
      -- 27/05/2002 : Test appartenance au perimetre MO
      -- ====================================================================
     	l_habilitation := pack_habilitation.fverif_habili_mo(l_perimo, l_clicode );
	IF l_habilitation=false THEN
		pack_global.recuperer_message(20201, '%s1',p_pid,NULL, msg);
 		raise_application_error(-20201,msg);
	END IF;


      	-- ====================================================================
      	--  Pas de proposé sur une année passée
      	-- ====================================================================
	SELECT TO_CHAR (datdebex, 'YYYY')
	INTO l_annee
	FROM datdebex
	WHERE rownum < 2;

	IF TO_NUMBER(p_date) < TO_NUMBER(l_annee) THEN
		--('vous n etes pas autorisé à faire des proposés sur une année passée')
       		pack_global.recuperer_message(20365, '%s1',  'faire des proposés sur une année passée','ANNEE', msg);
	   	raise_application_error(-20365,  msg);
	END IF;

-----------------------------------------------------------
--curseur ramenant les infos sur la ligne bip
-----------------------------------------------------------
BEGIN
OPEN p_curLigne_bip FOR
	SELECT lb.PID,
	p_date AS ANNEE,
	lb.CODCAMO, --CA payeur
	lb.TYPPROJ, --type
	lb.ARCTYPE, --typologie
	lb.TOPTRI,
	cs.LIBSTATUT,--statut comptable
	lb.TOPFER,--top fermeture
	TO_CHAR( lb.ADATESTATUT , 'MM/YYYY') AS ADATESTATUT, --date du statut
	lb.ICPI, --code projet
	pi.ILIBEL, --libelle projet
	lb.AIRT, --code irt
	a.ALIBEL,--libelle application
	lb.DPCODE,--code dossier projet
	dp.DPLIB, --libelle dossier projet
	lb.codpspe, -- projet special
	ps.LIBPSPE, --libelle projet special
	lb.CODSG, --DPG
	st.LIBDSG, --libelle DPG
	r.RNOM, --nom chef de projet
	lb.METIER,
	lb.PNOM, --libelle ligne BIP
	rtrim(lb.PNMOUVRA), --nom du correspondant MO
	lb.CLICODE, --direction cliente
	cm.CLILIB,--direction cliente
	lb.CLICODE_OPER, -- Code Client Opérationnel
	lb.CLICODE_OPER || '-' || cm2.CLILIB, -- Client Opérationnel
	lb.POBJET, --zone de texte
	DECODE( b.BNMONT,NULL,',00',TO_CHAR(b.BNMONT, 'FM9999999990D00')) AS BNMONT,  --budget notifie
        DECODE(b.BPMONTME,NULL,',00',TO_CHAR(b.BPMONTME, 'FM9999999990D00')) AS BPMONTME,--propose ME
        DECODE(b.ANMONT,NULL,',00',TO_CHAR(b.ANMONT, 'FM9999999990D00')) AS ANMONT,--arbitre
        DECODE(b.REESTIME,NULL,',00',TO_CHAR(b.REESTIME, 'FM9999999990D00')) AS REESTIME,--re-estime ME
        DECODE(lb.ESTIMPLURIAN,NULL,',00',TO_CHAR(lb.ESTIMPLURIAN, 'FM9999999990D00')) AS ESTIMPLURIAN,--estimation pluriannuelle
        DECODE(c.CUSAG ,NULL,',00',TO_CHAR(c.CUSAG , 'FM9999999990D00')) AS CUSAG,--realise
        DECODE( b.BPMONTMO ,NULL,',00',TO_CHAR( b.BPMONTMO , 'FM9999999990D00')) AS BPMONTMO,--propose MO
        NVL (b.flaglock,0) , --flaglock de la TABLE budget
	lb.FLAGLOCK

	FROM  ligne_bip lb,
              struct_info st,
              ressource r,
              code_statut cs,
              dossier_projet dp,
              proj_spe ps,
              proj_info pi,
              client_mo cm,
              client_mo cm2,
              application a,
              budget b,
              consomme c
      WHERE lb.pid = p_pid
      AND lb.pid = b.pid(+)
      AND lb.pid = c.pid(+)
      AND lb.codsg=st.codsg
      AND r.ident=lb.pcpi
      AND lb.airt=a.airt
      AND cs.astatut(+)=lb.astatut
      AND lb.icpi=pi.icpi
      AND lb.dpcode=dp.dpcode
      AND lb.codpspe=ps.codpspe(+)
      AND cm.clicode=lb.clicode
      AND cm2.clicode=lb.clicode_oper
      AND b.annee(+) = TO_NUMBER(p_date)
      AND c.annee(+) = TO_NUMBER(p_date)
     ;
  EXCEPTION
         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;

      pack_global.recuperer_message(5010, NULL, NULL, NULL, msg);
      p_message := msg;


END select_ligne_bip_mo;

-------------------------------------------------------------
-- procedure qui modifie une ligne bip (menu client)
-------------------------------------------------------------
PROCEDURE update_ligne_bip_mo(	p_pid         	IN ligne_bip.pid%TYPE,
				p_date 		IN CHAR,
				p_codcamo 	IN CHAR,
				p_typproj 	IN CHAR,
				p_arctype 	IN VARCHAR2,
				p_toptri 	IN CHAR,
				p_libstatut 	IN CHAR,
				p_topfer 	IN CHAR,
				p_adatestatut 	IN CHAR,
				p_icpi 		IN CHAR,
				p_ilibel 	IN CHAR,
				p_airt 		IN CHAR,
				p_alibel 	IN CHAR,
				p_dpcode 	IN ligne_bip.dpcode%TYPE,
				p_dplib 	IN dossier_projet.dplib%TYPE,
				p_codpspe 	IN CHAR,
				p_libpspe 	IN CHAR,
				p_codsg       	IN char,
				p_libdsg 	IN CHAR,
				p_rnom 		IN CHAR,
				p_metier 	IN CHAR,
				p_pnom        	IN CHAR,
	 			p_pnmouvra    	IN CHAR,
	 			p_clicode     	IN char,
	 			p_clilib 	IN CHAR,
	 			p_liste_objet 	IN varchar2,
				p_pobjet     	IN varchar2,
				p_bnmont 	IN VARCHAR2,
				p_bpmontme 	IN VARCHAR2,
				p_anmont 	IN VARCHAR2,
				p_reestime 	IN VARCHAR2,
				p_estimplurian 	IN VARCHAR2,
				p_cusag 	IN VARCHAR2,
				p_bpmontmo 	IN VARCHAR2,
				p_flag 		IN number,
				p_flaglock    	IN number,
				p_global      	IN VARCHAR2,
		                p_nbcurseur   	OUT INTEGER,
                		p_message     	OUT VARCHAR2
                              )IS
      msg 		    VARCHAR(1024);
      topfer 		    CHAR(1);    -- variable locale pour recuperer les tops fermeture
      l_menutil 	    VARCHAR2(255);
      l_habilitation 	    BOOLEAN ;
      l_perimo 		    VARCHAR2(1000);
      l_direction 	    client_mo.clicode%TYPE;
      l_menu VARCHAR2(25);

      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT( referential_integrity, -2291);
      objet_split	    VARCHAR2(2000);
   BEGIN

      -- positionner le nb de curseurs ==> 0
      -- initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';


   -- Controle habilitation Departement et pole
	BEGIN
    
        l_menu := pack_global.lire_globaldata(p_global).menutil;
		
		if('MO'=l_menu)then
			l_perimo := pack_global.lire_globaldata(p_global).perimcli;
		else
			l_perimo := pack_global.lire_globaldata(p_global).perimo;
		end if;


    EXCEPTION
      WHEN OTHERS THEN
        raise_application_error( -20997, SQLERRM);

    END;

    -- ====================================================================
    -- 27/05/2002 : Test appartenance au perimetre MO
    -- ====================================================================
   	l_habilitation := pack_habilitation.fverif_habili_mo(l_perimo, p_clicode);

	IF l_habilitation=false THEN
		-- Vous n'etes pas habilite à ce DPG
		pack_global.recuperer_message(20364, '%s1', 'à ce périmètre','', msg);
                raise_application_error(-20364, msg);
	END IF;

	-- controle du paramètre p_pobjet : il ne doit y avoir que 5 lignes qui font au max 60 caractères
	objet_split := pack_ligne_bip.controle_obj(p_pobjet);

--raise_application_error(-20000,',p_flaglock :'||p_flaglock||'et l_flaglock :'||l_flaglock);
-- UPDATE des 2 TABLES concernees : LIGNE_BIP, BUDGET
         BEGIN
            UPDATE ligne_bip
            SET
            pnom=p_pnom ,
            clicode=p_clicode,
            pnmouvra=p_pnmouvra,
            pobjet=objet_split,
            flaglock = decode(p_flaglock, 1000000, 0, p_flaglock + 1)
            WHERE pid = p_pid
            AND flaglock=p_flaglock
            ;

           EXCEPTION
            WHEN referential_integrity THEN
              -- habiller le msg erreur
              pack_global.recuperation_integrite(-2291);

              -- Ne pas intercepter les autres exceptions
            WHEN OTHERS THEN
               raise_application_error( -20997, SQLERRM);
         END;

         IF SQL%NOTFOUND THEN
            pack_global.recuperer_message(20999, NULL, NULL, NULL, msg);
            raise_application_error( -20999, msg );
         ELSE
            pack_global.recuperer_message(20277, '%s1', p_pid, NULL, msg);
            p_message := msg;
         END IF;



      BEGIN
       	UPDATE budget
      	SET
            bpmontmo=TO_NUMBER(p_bpmontmo),
            flaglock = decode(p_flag, 1000000, 0, p_flag + 1)
            WHERE pid=p_pid
            AND annee=TO_NUMBER(p_date)
            AND flaglock=p_flag
            ;
        EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM );
      END;

-- il n'y a pas de ligne budget pour ce pid --> On la cree
	IF SQL%NOTFOUND THEN
		INSERT INTO budget ( 	ANNEE,
 					PID,
 					BNMONT,
 					BPMONTME,
 					BPMONTME2,
 					ANMONT,
 					BPDATE,
 					RESERVE,
 					APDATE,
 					APMONT,
 					BPMONTMO,
 					REESTIME,
 					FLAGLOCK)
			VALUES 	(p_date,
				 p_pid,
				 NULL,
				 NULL,
				 NULL,
				 NULL,
				 NULL,
				 NULL,
				 NULL,
				 NULL,
				 TO_NUMBER (p_bpmontmo),
				 NULL,
				 0);
	pack_global.recuperer_message(20277, '%s1', p_pid, NULL, msg);
        p_message := msg;
	END IF;

   END update_ligne_bip_mo;


END pack_ligne_bip_mo;
/


