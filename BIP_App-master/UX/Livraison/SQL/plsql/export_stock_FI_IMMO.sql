create or replace
PACKAGE PACK_EXPORT_STOCK IS

  -- -----------------------------------------------------------------------
  -- Nom        : select_export_stock_FI
  -- Auteur     : Equipe STERIA
  -- Description : extraction des exports des STOCK FI,
  -- Paramètres : p_chemin_fichier IN VARCHAR2  : Chemin où ser exporté le fichier
  --			  p_nom_fichier    IN VARCHAR2  : Nom du fichier
  -- ------------------------------------------------------------------------

  PROCEDURE select_export_stock_FI( p_chemin_fichier  IN VARCHAR2, p_nom_fichier   IN VARCHAR2) ;
  
    -- -----------------------------------------------------------------------
  -- Nom        : select_export_stock_immo
  -- Auteur     : Equipe STERIA
  -- Description : extraction des exports des STOCK IMMO,
  -- Paramètres : p_chemin_fichier IN VARCHAR2  : Chemin où ser exporté le fichier
  --			  p_nom_fichier    IN VARCHAR2  : Nom du fichier
  -- ------------------------------------------------------------------------

  PROCEDURE select_export_stock_immo( p_chemin_fichier  IN VARCHAR2, p_nom_fichier   IN VARCHAR2) ;
  
END PACK_EXPORT_STOCK;
/
create or replace
PACKAGE BODY "PACK_EXPORT_STOCK" IS

	-- -------------------
	-- Gestions exceptions
	-- -------------------
	CALLEE_FAILED exception;
	pragma exception_init( CALLEE_FAILED, -20000 );
	CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
	TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
	ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
	CONSTRAINT_VIOLATION exception;          -- pour clause when
	pragma exception_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère
	CALLEE_FAILED exception;
	pragma exception_init( CALLEE_FAILED, -20000 );



-- ======================================================================
--   SELECT_EXPORT_STOCK_FI
-- ======================================================================
PROCEDURE SELECT_EXPORT_STOCK_FI(p_chemin_fichier IN VARCHAR2,
                        p_nom_fichier    IN VARCHAR2) IS


CURSOR curs_stockFI IS
select        
		nvl(s.pid ,' ') pid ,
        nvl(to_char(s.cdeb,'MM/YYYY'),' ') cdeb,
        nvl(s.typproj,' ') 	typproj,
        nvl(s.metier,' ') metier,    
        nvl(s.pnom,' ') pnom,
        nvl(to_char(s.codsg),' ') codsg,
        nvl(to_char(s.dpcode ),' ') dpcode,
        nvl(s.icpi,' ') icpi,
        nvl(to_char(s.cafi),' ') cafi,
        nvl(to_char(s.codsgress),' ') codsgress,
        nvl(s.libdsg,' ') libdsg,        
        nvl(to_char(s.codcamo),' ') codcamo,
        nvl(s.clibrca,' ') clibrca,
        nvl(to_char(s.ident),' ') ident,
       DECODE('fournisseur','fournisseur', 
                             DECODE( pack_habilitation.isDpgMe(s.codsg,'00000000000'), 'O', 
                                        rpad(nvl(s.rnom,' '),30,' ') ,
                                        DECODE(  pack_habilitation.isPerimCafi( s.cafi  ,'') ,'N',
                                                RPAD(' ',30,' ')
                                                ,rpad(nvl(s.rnom,' '),30,' ')   ) )
                         , ' ' )   rnom        ,     
        nvl(s.rtype,' ') rtype,
        nvl(s.prestation,' ') prestation,
       DECODE('fournisseur','fournisseur', 
                             DECODE( pack_habilitation.isDpgMe(s.codsg,'00000000000'), 'O', 
                                        rpad(nvl(s.niveau,' '),2,' ') ,
                                        DECODE( pack_habilitation.isPerimCafi( s.cafi  ,'') ,'N',
                                                RPAD(' ',2,' ')
                                                ,rpad(nvl(s.niveau,' '),2,' ')   ) )
                         , '  ' )   niveau        ,       
        nvl(s.soccode,' ') soccode,
        nvl(to_char(s.coutftht, 'FM9999999990D00','NLS_NUMERIC_CHARACTERS='',.'), '0,00') coutftht,
        nvl(to_char(s.coutft, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') coutft,
        nvl(to_char(s.coutenv, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') coutenv,
        nvl(to_char(sfr.d_consojh_im, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consojhimmo_dec,
        nvl(to_char(sfr.d_consojh_ni, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') nconsojhimmo_dec,    
        nvl(to_char(sfr.d_consoft , 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consoft_dec,
        nvl(to_char(sfr.d_consoenv_im, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consoenvimmo_dec,
        nvl(to_char(sfr.d_consoenv_ni, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') nconsoenvimmo_dec,
--
        nvl (to_char(nvl(sfr.consojh_im,0) - nvl(sfr.d_consojh_im,0), 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consojhimmo_n,
        nvl (to_char(nvl(sfr.consojh_ni,0) - nvl(sfr.d_consojh_ni,0), 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') nconsojhimmo_n,
        nvl (to_char(nvl(sfr.consoft,0) - nvl(sfr.d_consoft,0), 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consoft_n,
        nvl (to_char(nvl(sfr.consoenv_im,0) - nvl(sfr.d_consoenv_im,0), 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consoenvimmo_n,
        nvl (to_char(nvl(sfr.consoenv_ni,0) -nvl(sfr.d_consoenv_ni,0.00), 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') nconsoenvimmo_n,
--
        nvl (to_char(nvl(sfr.consojh_im,0.00), 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consojhimmo_tot,
        nvl (to_char(nvl(sfr.consojh_ni,0.00), 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') nconsojhimmo_tot,
        nvl (to_char(nvl(sfr.consoft,0.00) , 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consoft_tot,
        nvl (to_char(nvl(sfr.consoenv_im,0.00) , 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consoenvimmo_tot ,
        nvl (to_char(nvl(sfr.consoenv_ni,0.00) , 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') nconsoenvimmo_tot,
--
        nvl (to_char(nvl(s.consojhimmo,0.00), 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consojhimmo,
        nvl (to_char(nvl(s.nconsojhimmo,0.00), 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') nconsojhimmo,
        nvl (to_char(s.consoft, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consoft,
        nvl (to_char(s.consoenvimmo, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') consoenvimmo,
        nvl (to_char(s.nconsoenvimmo, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') nconsoenvimmo,
        nvl (to_char(s.a_consojhimmo, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') a_consojhimmo,
        nvl (to_char(s.a_nconsojhimmo, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') a_nconsojhimmo,
        nvl (to_char(s.a_consoft, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') a_consoft,
        nvl (to_char(s.a_consoenvimmo, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') a_consoenvimmo,
        nvl (to_char(s.a_nconsoenvimmo, 'fm9999999990d00','nls_numeric_characters='',.'), '0,00') a_nconsoenvimmo
from stock_fi s,
		ligne_bip lb, 
		synthese_fin_ress sfr,
 		(						 		        
		select codcamo 
		from centre_activite
		where 
		CANIV5 IN ('30053')
    --SEL PPM 58986 : il faut prendre en compte l'année civile : Janvier N -> last day Decembre N
		AND ((cdateferm is null) or (cdateferm between to_date('01/'||to_number(to_char(sysdate,'YYYY')),'MM/YYYY') and
		last_day(to_date('12/'||to_char(sysdate,'YYYY'),'MM/YYYY'))))
		) liste_ca_fi
 where s.ident= sfr.ident(+)
		and s.pid = sfr.pid(+)
		and s.codcamo = sfr.codcamo(+)
		and s.cafi = liste_ca_fi.CODCAMO
		and s.cafi = sfr.cafi(+)
		and s.PID = lb.PID(+)
order by s.pid, s.cdeb, s.ident, s.cafi;

L_HFILE	  						UTL_FILE.FILE_TYPE;
L_RETCOD						NUMBER;
l_msg  VARCHAR2(1024);

	BEGIN

		-----------------------------------------------------
		-- Génération du fichier.
		-----------------------------------------------------
		Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);
    Pack_Global.WRITE_STRING( l_hfile, 
		'ligne;mois;Type ligne;Métier;Libellé;Pôle ME;Dossier projet;Projet Pxxxx;' ||
		'CAFI ress;DPG ress;LibelleDPG;CAMO;Lib MO;Code ressource;Nom ressource;Type ressource;' ||
		'Qualification;Niveau;Société;Cout ress HT;Cout ress HTR;Coût env IMMO;' ||
		'Conso jh immo dec N-1;Conso FT dec N-1;Conso env immo dec N-1;Conso env non immo dec N-1;'||
		'Conso jh immo année N;Conso jh non immo année N;Conso FT année N;Conso env immo année N;' ||
		'Consommé ENV non immo année N;Total Conso jh immo;Total Conso jh non immo;Total Conso FT;' ||
		'Total Conso env immo;Conso env non immo total;Conso jh immo du mois;Conso jh non immo du mois;' ||
		'Conso FT du mois;Conso env immo du mois;Conso env non immo du mois;conso jh RA;' ||
		'conso jh non immo RA;Conso FT RA;Conso env immo RA;Conso env non immo RA;'); 
    
	  FOR cur_enr IN curs_stockFI
      LOOP
        Pack_Global.WRITE_STRING( l_hfile,
        cur_enr.pid 				|| ';' ||
        cur_enr.cdeb				|| ';' ||
        cur_enr.typproj				|| ';' ||
        cur_enr.metier				|| ';' ||    
        cur_enr.pnom				|| ';' ||
        cur_enr.codsg				|| ';' ||
        cur_enr.dpcode				|| ';' ||
        cur_enr.icpi				|| ';' ||
        cur_enr.cafi				|| ';' ||
        cur_enr.codsgress			|| ';' ||
        cur_enr.libdsg  			|| ';' ||    
        cur_enr.codcamo				|| ';' ||
        cur_enr.clibrca				|| ';' ||
        cur_enr.ident				|| ';' ||
        cur_enr.rnom        || ';' ||
        cur_enr.rtype				|| ';' ||
        cur_enr.prestation			|| ';' ||
        cur_enr.niveau			  || ';' ||
        cur_enr.soccode				|| ';' ||
        cur_enr.coutftht			|| ';' ||
        cur_enr.coutft				|| ';' ||
        cur_enr.coutenv				|| ';' ||
        cur_enr.consojhimmo_dec		|| ';' ||
        cur_enr.nconsojhimmo_dec    || ';' ||
        cur_enr.consoft_dec			|| ';' ||
        cur_enr.consoenvimmo_dec	|| ';' ||
        cur_enr.nconsoenvimmo_dec	|| ';' ||
        cur_enr.consojhimmo_n		|| ';' ||
        cur_enr.nconsojhimmo_n		|| ';' ||
        cur_enr.consoft_n			|| ';' ||
        cur_enr.consoenvimmo_n		|| ';' ||
        cur_enr.nconsoenvimmo_n		|| ';' ||
--
        cur_enr.consojhimmo_tot		|| ';' ||
        cur_enr.nconsojhimmo_tot	|| ';' ||
        cur_enr.consoft_tot			|| ';' ||
        cur_enr.consoenvimmo_tot 	|| ';' ||
        cur_enr.nconsoenvimmo_tot	|| ';' ||
--
        cur_enr.consojhimmo			|| ';' ||
        cur_enr.nconsojhimmo		|| ';' ||	
        cur_enr.consoft				|| ';' ||	
        cur_enr.consoenvimmo		|| ';' ||
        cur_enr.nconsoenvimmo		|| ';' ||
        cur_enr.a_consojhimmo		|| ';' ||
        cur_enr.a_nconsojhimmo		|| ';' ||
        cur_enr.a_consoft			|| ';' ||
        cur_enr.a_consoenvimmo		|| ';' ||
        cur_enr.a_nconsoenvimmo		);
		
      END LOOP;

	Pack_Global.CLOSE_WRITE_FILE(l_hfile);

END SELECT_EXPORT_STOCK_FI;

-- ======================================================================
--   SELECT_EXPORT_STOCK_IMMO
-- ======================================================================
PROCEDURE SELECT_EXPORT_STOCK_IMMO(p_chemin_fichier IN VARCHAR2,
                        p_nom_fichier    IN VARCHAR2) IS


CURSOR curs_stockImmo IS
select	nvl(s.pid ,' ') pid,
        nvl(to_char(s.cdeb,'MM/YYYY'),' ') cdeb,
        nvl(s.typproj,' ') typproj,
        nvl(s.metier,' ') metier,    
        nvl(s.pnom,' ') pnom,
        nvl(to_char(s.codsg),' ') codsg,
        nvl(to_char(s.dpcode),' ') dpcode,
        nvl(s.icpi,' ') icpi,
        nvl(to_char(s.cada),' ') cada,
        nvl(to_char(s.cafi),' ') cafi,
        nvl(to_char(s.codsgress),' ') codsgress,
        nvl(s.libdsg,' ') libdsg,        
        nvl(to_char(s.codcamo),' ') codcamo,
        nvl(s.clibrca,' ') clibrca,
        nvl(to_char(s.ident),' ') ident,
        DECODE('fournisseur','fournisseur', 
                             DECODE( pack_habilitation.isDpgMe(s.codsg,'00000000000'), 'O', 
                                        rpad(nvl(s.rnom,' '),30,' ') ,
                                        DECODE(  pack_habilitation.isPerimCafi( s.cafi  ,null) ,'N',
                                                RPAD(' ',30,' ')
                                                ,rpad(nvl(s.rnom,' '),30,' ')   ) )
                         , ' ' )   rnom        , 
		    nvl(s.rtype,' ') rtype,
        nvl(s.prestation,' ') prestation,
        DECODE('fournisseur','fournisseur', 
                             DECODE( pack_habilitation.isDpgMe(s.codsg,'00000000000'), 'O', 
                                        rpad(nvl(s.niveau,' '),2,' ') ,
                                        DECODE( pack_habilitation.isPerimCafi( s.cafi  ,null) ,'N',
                                                RPAD(' ',2,' ')
                                                ,rpad(nvl(s.niveau,' '),2,' ')   ) )
                         , '  ' )   niveau        ,    
        nvl(s.soccode,' ') soccode,
        NVL (TO_CHAR(s.coutftht, 'FM9999999999D00','NLS_NUMERIC_CHARACTERS='',.'), '0,00') coutftht,
        NVL (TO_CHAR(s.coutft, 'FM9999999999D00','NLS_NUMERIC_CHARACTERS='',.'), '0,00') coutft,
        NVL (TO_CHAR(NVL(a.consojh_N,0) , 'FM9999999990D00','NLS_NUMERIC_CHARACTERS='',.'), '0,00') consojh_N,
        NVL (TO_CHAR(NVL(a.consoft_N,0) , 'FM9999999990D00','NLS_NUMERIC_CHARACTERS='',.'), '0,00') consoft_N,
        NVL (TO_CHAR(NVL(s.consojh ,0.00), 'FM9999999990D00','NLS_NUMERIC_CHARACTERS='',.'), '0,00') consojh ,
        NVL (TO_CHAR(s.consoft, 'FM9999999990D00','NLS_NUMERIC_CHARACTERS='',.'), '0,00') consoft,    
        NVL (TO_CHAR(s.a_consojh, 'FM9999999990D00','NLS_NUMERIC_CHARACTERS='',.'), '0,00') a_consojh,
        NVL (TO_CHAR(s.a_consoft, 'FM9999999990D00','NLS_NUMERIC_CHARACTERS='',.'), '0,00') a_consoft
from stock_immo s,
	 ligne_bip lb,
	 (select s1.pid,s1.ident, s1.cafi,
		 sum(NVL(s1.consojh,0)) consojh_N,
		 sum(NVL(s1.consoft,0)) consoft_N
		 from stock_immo s1
		 group by pid,ident,cafi) a,
		 (						 		        
			select codcamo 
				from centre_activite
				where 
					CANIV5 IN ('30053')
					AND (cdateferm is null or substr(TO_DATE(cdateferm, 'DD/MM/YYYY'), 7, 8) = substr(TO_DATE(sysdate, 'DD/MM/YYYY'), 7, 8))
			UNION
			select distinct caniv1
				from centre_activite
				where 
					CANIV5 IN ('30053')
					AND (cdateferm is null or substr(TO_DATE(cdateferm, 'DD/MM/YYYY'), 7, 8) = substr(TO_DATE(sysdate, 'DD/MM/YYYY'), 7, 8))
			UNION
			select distinct caniv2
				from centre_activite
				where 
					CANIV5 IN ('30053')
					AND (cdateferm is null or substr(TO_DATE(cdateferm, 'DD/MM/YYYY'), 7, 8) = substr(TO_DATE(sysdate, 'DD/MM/YYYY'), 7, 8))
			UNION
			select distinct caniv3
				from centre_activite
				where 
					CANIV5 IN ('30053')
					AND (cdateferm is null or substr(TO_DATE(cdateferm, 'DD/MM/YYYY'), 7, 8) = substr(TO_DATE(sysdate, 'DD/MM/YYYY'), 7, 8))
			UNION
			select distinct caniv4
				from centre_activite
				where 
					CANIV5 IN ('30053')
					AND (cdateferm is null or substr(TO_DATE(cdateferm, 'DD/MM/YYYY'), 7, 8) = substr(TO_DATE(sysdate, 'DD/MM/YYYY'), 7, 8))
			UNION
			select distinct caniv5
				from centre_activite
				where 
					CANIV5 IN ('30053')
					AND (cdateferm is null or substr(TO_DATE(cdateferm, 'DD/MM/YYYY'), 7, 8) = substr(TO_DATE(sysdate, 'DD/MM/YYYY'), 7, 8))
			) liste_fi		
		where s.ident=a.ident(+)
		and s.pid = a.pid(+)
		and s.cafi = a.cafi(+)
		and s.cafi = liste_fi.CODCAMO
		and s.PID = lb.PID(+)
		and s.CODCAMO = lb.CODCAMO(+)
		and s.ICPI = lb.ICPI(+)
		and s.DPCODE = lb.DPCODE(+)
		
order by s.pid, s.cdeb, s.ident, s.cafi;	

L_HFILE	  						UTL_FILE.FILE_TYPE;
L_RETCOD						NUMBER;
l_msg  VARCHAR2(1024);

	BEGIN

		-----------------------------------------------------
		-- Génération du fichier.
		-----------------------------------------------------
		Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);
    
    -----------------------------------------------------
    --Ajout des entètes
    -----------------------------------------------------
    Pack_Global.WRITE_STRING(l_hfile,
        'Ligne' || ';' ||
        'Mois' || ';' ||
        'Type ligne' || ';' ||
        'Métier' || ';' ||
        'Libellé' || ';' ||
        'Pôle ME' || ';' ||
        'dossier projet' || ';' ||
        'projet Pxxxx' || ';' ||
        'CADA' || ';' ||
        'CAFI ress' || ';' ||
        'DPG ress' || ';' ||
        'Libellé DPG' || ';' ||
        'CAMO' || ';' ||
        'Lib MO' || ';' ||
        'Code ressource' || ';' ||
        'Nom ressource' || ';' ||
        'Type ressource' || ';' ||
        'Qualification' || ';' ||
        'Niveau' || ';' ||
        'Société' || ';' ||
        'Coût ress HT' || ';' ||
        'Coût ress HTR' || ';' ||
        'Conso jh année N' || ';' ||
        'Conso FT année N' || ';' ||
        'Conso jh du mois' || ';' ||
        'Conso FT du mois' || ';' ||
        'conso JH RA' || ';' ||
        'conso FT RA' 
		    );


	  FOR cur_enr IN curs_stockImmo
      LOOP
        Pack_Global.WRITE_STRING(l_hfile,
		    cur_enr.pid || ';' ||
        cur_enr.cdeb || ';' ||
        cur_enr.typproj || ';' ||
        cur_enr.metier || ';' ||
        cur_enr.pnom   || ';' ||
        cur_enr.codsg  || ';' ||
        cur_enr.dpcode || ';' ||
        cur_enr.icpi  || ';' ||
        cur_enr.cada || ';' ||
        cur_enr.cafi || ';' ||
        cur_enr.codsgress || ';' ||
        cur_enr.libdsg || ';' ||
        cur_enr.codcamo || ';' ||
        cur_enr.clibrca || ';' ||
        cur_enr.ident || ';' ||
		cur_enr.rnom || ';' ||
		cur_enr.rtype || ';' ||
        cur_enr.prestation || ';' ||
		cur_enr.niveau || ';' ||
        cur_enr.soccode || ';' ||
        cur_enr.coutftht || ';' ||
        cur_enr.coutft || ';' ||
        cur_enr.consojh_N || ';' ||
        cur_enr.consoft_N || ';' ||
        cur_enr.consojh || ';' ||
        cur_enr.consoft || ';' ||
        cur_enr.a_consojh || ';' ||
        cur_enr.a_consoft
		);
	
      END LOOP;

	Pack_Global.CLOSE_WRITE_FILE(l_hfile);


END SELECT_EXPORT_STOCK_IMMO;

END PACK_EXPORT_STOCK;
/

