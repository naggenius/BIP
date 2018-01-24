-- Le 19/06/2007 par BPO : Fiche 550 : Modification de la taille du champ correspondant au libelle du Dossier Projet

-- pack_fair
--
-- Le 20/07/2007 par BPO : MAJ du package pour l'activation d'un filtre sur le perimetre des DF
-- Le 25/08/2007 par ABA :TD 615 modification de la liste des direction expense par le système comptable EXP 
-- Le 15/04/2009 par ABA :TD 737
--

/* PROJET FAIR

CREATE TABLE tmp_fair
(type_enreg NUMBER(1),
ident NUMBER(5),
date_crea varchar2(8), 
date_emi varchar2(8),
type VARCHAR2(50),
cavcont VARCHAR2(20),
carat VARCHAR2(20),
codsg NUMBER(6),
libdpg VARCHAR2(50),
numligne NUMBER(1),
rnom VARCHAR2(50),
code_comta VARCHAR2(20),
qualif CHAR(3),
sms VARCHAR2(9),
centre_activite varchar2(20),
camo varchar2(20),
dpcode number(5),
libdpcode varchar2(40),
icpi char(5),
libproj varchar2(40),
cout number(12,2),
cusag number(12,2),
unite_oeuvre char(1),
montantht number(12,2),
tva number(9,2),
taux_recup number(9,2),
code_classe char(4),
code_iso char(3),
date_fin_contrat varchar2(8),
rtype char(1),
pid varchar2(4),
pnom varchar2(50),
societe char(4),
CONSTRAINT fair_pk PRIMARY KEY (ident, date_crea, pid) USING INDEX TABLESPACE idx
);
*/

CREATE OR REPLACE PACKAGE pack_fair AS

   PROCEDURE alim_fair(p_filsigle IN VARCHAR2);

   PROCEDURE selectP_fair (   p_filsigle IN VARCHAR2,
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2);

   PROCEDURE referentielE_fair (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2);

   PROCEDURE referentielA_fair (   p_filsigle IN VARCHAR2,
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2);

   PROCEDURE select_fair (
                           p_chemin_fichier IN VARCHAR2,
                           p_nom_fic_sgpm IN VARCHAR2,
                           p_nom_fic_sgam IN VARCHAR2,
			  -- p_nom_fic_sogessur IN VARCHAR2,
                           p_nom_fic_refE IN VARCHAR2,
                           p_nom_fic_refApm IN VARCHAR2,
			   p_nom_fic_refAam IN VARCHAR2
                          ) ;

END pack_fair;
/


CREATE OR REPLACE PACKAGE BODY     pack_fair AS

   PROCEDURE alim_fair(p_filsigle IN VARCHAR2) IS


	l_nbmois    NUMBER(2,0);             -- nombre de mois M-` traiter
        i           NUMBER(2,0);             -- compteur (mois a traiter)
        l_mois      DATE ;                   -- mois a traiter, deduit de 'i'
        l_mois_min  DATE ;
	l_where	    VARCHAR2(100);

	BEGIN
--1ere étape : delete de la table temporaire et insertion des données de proplus

		DELETE FROM tmp_fair;
		COMMIT;

		l_nbmois    := 0 ;
        	select datdebex into l_mois_min from datdebex;

		SELECT  MONTHS_BETWEEN( trunc(add_months(moismens,1), 'Month'), trunc(datdebex, 'year') )
        	INTO            l_nbmois
        	FROM            datdebex;

	IF p_filsigle = 'SGPM' THEN
	FOR i IN 1..l_nbmois
        LOOP

           l_mois := trunc( add_months( l_mois_min, i-1), 'month' ) ;


		INSERT INTO tmp_fair (  type_enreg,
					ident,
					date_crea,
					date_emi,
					carat,
					codsg,
					numligne,
					rnom,
					qualif,
					cout,
					cusag,
					unite_oeuvre,
					montantht,
					code_classe,
					code_iso,
					rtype,
					pid ,
					pnom,
					societe)
				(SELECT 2,
					conso.tires,
					to_char(trunc(l_mois,'MONTH'),'DDMMYYYY'),
					'20'||to_char(l_mois,'MMYYYY'),
					decode(p_filsigle,'SGPM','S0001','S6640'),
					conso.divsecgrou,
					'1',
					decode(conso.rtype,'P',' ',conso.rnom),
					conso.qualif,
					conso.cout,
					conso.cusag,
					'J',
					conso.cout*conso.cusag,
					'SENT',
					'EUR',
					decode(conso.rtype,'P','R','F'),
					conso.factpid,
					conso.factpno,
					conso.societe
				FROM struct_info si, directions d,
				     (select sum(cusag) cusag,tires,divsecgrou,cdeb,rtype,qualif,cout,
				      factpid,factpno,rnom,societe
				      from proplus,datdebex
				      where trunc(l_mois,'MONTH')= trunc(cdeb,'MONTH')
				      and (aist not in ('CONGES','FORMAT','ABSDIV','PARTIE','RTT')
						OR aist IS NULL)
				      AND societe <> 'SG..'
				      AND factpid is not null
				      group by tires,divsecgrou,cdeb,rtype,qualif,cout,factpid,factpno,rnom,societe) 				      conso
				WHERE si.codsg = conso.divsecgrou
			  	AND	si.filcode in ('01','05','06','07')
				AND si.coddir = d.coddir
				AND (
					 		   (d.syscompta not in ('EXP') and conso.cdeb >= '01/07/2007')
					 		OR (conso.cdeb < '01/07/2007')
					)
				);

	END LOOP;
	ELSE
		l_where:=''''||02||'''';
	FOR i IN 1..l_nbmois
        LOOP

           l_mois := trunc( add_months( l_mois_min, i-1), 'month' ) ;


		INSERT INTO tmp_fair (  type_enreg,
					ident,
					date_crea,
					date_emi,
					carat,
					codsg,
					numligne,
					rnom,
					qualif,
					cout,
					cusag,
					unite_oeuvre,
					montantht,
					code_classe,
					code_iso,
					rtype,
					pid ,
					pnom,
					societe)
				(SELECT 2,
					conso.tires,
					to_char(trunc(l_mois,'MONTH'),'DDMMYYYY'),
					'20'||to_char(l_mois,'MMYYYY'),
					decode(p_filsigle,'SGPM','S0001','S6640'),
					conso.divsecgrou,
					'1',
					decode(conso.rtype,'P',' ',conso.rnom),
					conso.qualif,
					conso.cout,
					conso.cusag,
					'J',
					conso.cout*conso.cusag,
					'SENT',
					'EUR',
					decode(conso.rtype,'P','R','F'),
					conso.factpid,
					conso.factpno,
					conso.societe
				FROM struct_info si,
				     (select sum(cusag) cusag,tires,divsecgrou,cdeb,rtype,qualif,cout,
				      factpid,factpno,rnom,societe
				      from proplus,datdebex
				      where trunc(l_mois,'MONTH')= trunc(cdeb,'MONTH')
				      and (aist not in ('CONGES','FORMAT','ABSDIV','PARTIE','RTT')
						OR aist IS NULL)
				      AND societe <> 'SG..'
				      AND factpid is not null
				      group by tires,divsecgrou,cdeb,rtype,qualif,cout,factpid,factpno,rnom,societe) 				      conso
				WHERE si.codsg = conso.divsecgrou
			  	AND	si.filcode='02'
				);

	END LOOP;
	END IF;

		COMMIT;

--2eme etape : les update

UPDATE tmp_fair SET type = (select t.typproj || t.libtyp from type_projet t,ligne_bip lb
			    WHERE t.typproj = lb.typproj
			    AND lb.pid = tmp_fair.pid);
COMMIT;

UPDATE tmp_fair SET  cavcont = (select max(lc.cav) || trim(substr(lc.numcont,1,17)) cavcont from ligne_cont lc
				where tmp_fair.ident  = lc.ident
				and tmp_fair.societe = lc.soccont
				and lc.lcnum = (select max(l.lcnum) from ligne_cont l
						where tmp_fair.ident  = l.ident
						and tmp_fair.societe = l.soccont
						and trunc(l.lresdeb,'MONTH') <= to_date(tmp_fair.date_crea,'DDMMYYYY')
						and trunc(l.lresfin,'MONTH') > to_date(tmp_fair.date_crea,'DDMMYYYY'))
				and trunc(lc.lresdeb,'MONTH') <= to_date(tmp_fair.date_crea,'DDMMYYYY')
				and trunc(lc.lresfin,'MONTH') > to_date(tmp_fair.date_crea,'DDMMYYYY')
				and rownum = 1
				group by lc.numcont);
COMMIT;

UPDATE tmp_fair SET libdpg = (select b.libbr||'/'||d.libdir||'/'||si.sigdep||'/'||si.sigpole
				from struct_info si,branches b,directions d
				where tmp_fair.codsg = si.codsg
				and si.coddir = d.coddir
				and d.codbr = b.codbr
				);
COMMIT;

UPDATE tmp_fair SET code_comta = (select comcode from contrat
				where tmp_fair.societe = contrat.soccont
				and tmp_fair.cavcont =contrat.cav||trim(substr(contrat.numcont,1,17))),
		    date_fin_contrat = (select to_char(cdatfin,'DDMMYYYY') from contrat
					where tmp_fair.societe = contrat.soccont
					and tmp_fair.cavcont =contrat.cav||trim(substr(contrat.numcont,1,17)));
COMMIT;

UPDATE tmp_fair SET sms = (select distinct (SUBSTR(fact.fsocfour,1,9)) from facture fact,ligne_fact lf
				where tmp_fair.societe = lf.socfact
				and tmp_fair.ident = lf.ident
				and to_char(lf.lmoisprest,'DDMMYYYY') = tmp_fair.date_crea
				and lf.socfact = fact.socfact
				and lf.numfact = fact.numfact
				and lf.datfact = fact.datfact
				and lf.typfact = fact.typfact
				and rownum = 1);
COMMIT;


UPDATE tmp_fair SET centre_activite = (select centractiv from struct_info
					where struct_info.codsg = tmp_fair.codsg);
COMMIT;

UPDATE tmp_fair SET camo = (select decode(caamort,22000,decode(codcamo,22000,NULL,codcamo),nvl(caamort,decode(codcamo,22000,NULL,codcamo)))
				from ligne_bip
				where ligne_bip.pid = tmp_fair.pid);
COMMIT;

UPDATE tmp_fair SET dpcode = (select dp.dpcode from dossier_projet dp,ligne_bip lb
				where lb.dpcode = dp.dpcode
				and lb.pid = tmp_fair.pid),
		    libdpcode = (select dplib from dossier_projet dp,ligne_bip lb
					where lb.dpcode = dp.dpcode
				and lb.pid = tmp_fair.pid);
COMMIT;

UPDATE tmp_fair SET icpi = (select lb.icpi from ligne_bip lb
			    where lb.pid = tmp_fair.pid),
		    libproj = (select SUBSTR(ilibel,1,40) from proj_info,ligne_bip lb
				where proj_info.icpi = lb.icpi
				and lb.pid = tmp_fair.pid);
COMMIT;

UPDATE tmp_fair SET tva = (select tva from tva where datetva = (select max(datetva) from tva));
COMMIT;

UPDATE tmp_fair SET taux_recup = (select taux from taux_recup,datdebex where annee = to_number(to_char(datdebex,'YYYY')) and filcode ='01');
COMMIT;

UPDATE tmp_fair SET libsoc = (select soclib from societe where soccode = tmp_fair.societe);

UPDATE tmp_fair SET sms = (select substr(socfour,1,9)
						from agence a, societe s
						where s.soccode= tmp_fair.societe
						and s.soccode = a.soccode
						and rownum = 1)
WHERE sms is null;

COMMIT;


	END alim_fair;

PROCEDURE selectP_fair (   p_filsigle IN VARCHAR2,
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2) IS


       l_hfile utl_file.file_type;
       l_msg  varchar2(1024);
	l_moismens varchar2(6);
	l_sysdate varchar2(8);
	l_heure varchar2(6);
	compteur number(19);
	l_compteur varchar2(19);
	l_subdiv varchar2(1);

-- déclaration du curseur pour fair
	CURSOR curs_fair IS
	SELECT lpad(to_char(type_enreg),1,' ') type_enreg,
	lpad(to_char(ident),5,' ') ident,
	rpad(date_crea,8,' ') date_crea,
	rpad(date_emi,8,' ') date_emi,
	rpad(nvl(type,' '),50,' ') type,
	rpad(nvl(cavcont,' '),20,' ') cavcont,
	rpad(carat,20,' ') carat,
	lpad(to_char(nvl(codsg,0)),6,' ') codsg,
	rpad(nvl(libdpg,' '),50,' ') libdpg,
	lpad(to_char(numligne),4,' ') numligne,
	rpad(nvl(rnom,' '),50,' ') rnom,
	rpad(nvl(code_comta,' '),20,' ') code_comta,
	rpad(nvl(qualif,' '),20,' ') qualif,
	rpad(nvl(sms,'BIP fournisseur'),20,' ') sms,
	rpad(nvl(centre_activite,' '),20,' ') centre_activite,
	rpad(nvl(camo,' '),20,' ') camo,
	lpad(to_char(nvl(dpcode,0)),20,' ')dpcode,
	rpad(nvl(libdpcode,' '),50,' ') libdpcode,
	rpad(nvl(icpi,' '),20,' ') icpi,
	rpad(nvl(libproj,' '),40,' ') libproj,
	lpad(to_char(nvl(cout,0),'FM999999990D00','NLS_NUMERIC_CHARACTERS=''.,'),20,' ') cout,
	lpad(to_char(nvl(cusag,0),'FM999999990D00','NLS_NUMERIC_CHARACTERS=''.,'),15,' ') cusag,
	rpad(nvl(unite_oeuvre,' '),15,' ') unite_oeuvre,
	lpad(to_char(nvl(montantht,0),'FM999999990D00','NLS_NUMERIC_CHARACTERS=''.,'),15,' ') montantht,
	lpad(to_char(nvl(tva,0),'FM999990D00','NLS_NUMERIC_CHARACTERS=''.,'),15,' ') tva,
	lpad(to_char(nvl(taux_recup,0),'FM999990D00','NLS_NUMERIC_CHARACTERS=''.,'),15,' ') taux_recup,
	rpad(nvl(code_classe,' '),4,' ') code_classe,
	rpad(nvl(code_iso,' '),3,' ') code_iso,
	rpad(nvl(date_fin_contrat,' '),8,' ') date_fin_contrat,
	rpad(nvl(rtype,' '),20,' ') rtype,
	rpad(nvl(pid,' '),4,' ') pid,
	rpad(nvl(pnom,' '),50,' ') pnom,
	rpad(nvl(societe,' '),4,' ') societe,
	rpad(nvl(libsoc,' '),50,' ') libsoc
FROM    tmp_fair
ORDER BY rpad(date_crea,8,' '),lpad(to_char(ident),5,' ');


   BEGIN

	select to_char(moismens,'MMYYYY') into l_moismens from datdebex;
	select to_char(sysdate,'DDMMYYYY') into l_sysdate from dual;
	select to_char(sysdate,'HH24MISS') into l_heure from dual;
	select decode(p_filsigle,'SGPM','1',decode(p_filsigle,'SGAM','2','3')) into l_subdiv from dual;

      PACK_GLOBAL.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);


--entete
     PACK_GLOBAL.WRITE_STRING( l_hfile,
				'1' || ';' ||
				'BB' || ';' ||
				l_subdiv || ';' ||
				'P' || ';' ||
				l_moismens || ';' ||
				l_sysdate || ';' ||
				l_heure
			     );


	compteur := 0;

	 FOR cur_enr IN curs_fair
      LOOP

        PACK_GLOBAL.WRITE_STRING(l_hfile,
                                    cur_enr.type_enreg	||';'||
                                   cur_enr.ident		|| ';' ||
                                   cur_enr.date_crea 				|| ';' ||
                                   cur_enr.date_emi			 	|| ';' ||
                                   cur_enr.type 				|| ';' ||
                                   cur_enr.cavcont 				|| ';' ||
                                   cur_enr.carat 				|| ';' ||
                                   cur_enr.codsg				|| ';' ||
                                   cur_enr.libdpg 				|| ';' ||
				   cur_enr.numligne 				|| ';' ||
                                   cur_enr.rnom 				|| ';' ||
				   cur_enr.code_comta 				|| ';' ||
                                   cur_enr.qualif 				|| ';' ||
				   ' '				|| ';' ||
				   cur_enr.sms					|| ';' ||
				   ' '				|| ';' ||
				   ' '				|| ';' ||
                                   cur_enr.centre_activite 			|| ';' ||
                                   cur_enr.camo 				|| ';' ||
                                   cur_enr.dpcode 				|| ';' ||
                                   cur_enr.libdpcode 				|| ';' ||
                                   cur_enr.icpi 				|| ';' ||
				   cur_enr.libproj 				|| ';' ||
				   cur_enr.cout 				|| ';' ||
				   cur_enr.cusag				|| ';' ||
                                   cur_enr.unite_oeuvre 			|| ';' ||
                                   cur_enr.montantht	 			|| ';' ||
                                   cur_enr.tva 					|| ';' ||
                                   cur_enr.taux_recup 				|| ';' ||
				   cur_enr.code_classe				|| ';' ||
				   cur_enr.code_iso				|| ';' ||
				   cur_enr.date_fin_contrat			|| ';' ||
				   ' '				|| ';' ||
				   ' '				|| ';' ||
				   ' '				|| ';' ||
				   ' '				|| ';' ||
				   ' '				|| ';' ||
				   ' '				|| ';' ||
				   cur_enr.pid ||'\'|| cur_enr.pnom || ';' ||
				   cur_enr.societe ||'\'|| cur_enr.libsoc || ';' ||
				   ' '				|| ';' ||
				   ' ');


		-- alimentation du compteur d'occurence
			compteur := compteur+1;

       END LOOP;

	select lpad(to_char(compteur, 'FM9999999999999999990'),19,' ') into l_compteur from dual;
--fin de fichier
	PACK_GLOBAL.WRITE_STRING( l_hfile,
				 '3' || ';' ||
				 l_compteur);

       PACK_GLOBAL.CLOSE_WRITE_FILE(l_hfile);


	EXCEPTION
   		WHEN OTHERS THEN


   		pack_global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
   		raise_application_error(-20401, l_msg);

    END selectP_fair;



PROCEDURE referentielE_fair (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2) IS


       l_hfile utl_file.file_type;
       l_msg  varchar2(1024);
	l_moismens varchar2(6);
	l_sysdate varchar2(8);
	l_heure varchar2(6);
	compteur number(19);
	l_compteur varchar2(19);


-- déclaration du curseur pour le fichier de référentiel de type E contenant les dpg et centre d'activité
-- et envoyé seulement à SGAM
	CURSOR curs_refE IS
	SELECT  2 type_enreg,
		lpad(to_char(sti.codsg),6,' ') ||'\'|| lpad(to_char(sti.centractiv),7,' ') code_occurence,
		rpad(sti.libdsg,30,' ') libelle_occurence,
		lpad(to_char(sti.centractiv),7,' ') code_ca
	FROM struct_info sti,centre_activite ca
	where sti.centractiv = ca.codcamo
	and sti.codsg > 1
	order by sti.codsg;



   BEGIN

	select to_char(moismens,'MMYYYY') into l_moismens from datdebex;
	select to_char(sysdate,'DDMMYYYY') into l_sysdate from dual;
	select to_char(sysdate,'HH24MISS') into l_heure from dual;


      PACK_GLOBAL.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);


--entete
     PACK_GLOBAL.WRITE_STRING( l_hfile,
				'1' || ';' ||
				'BB' || ';' ||
				'2' || ';' ||
				'E' || ';' ||
				l_moismens || ';' ||
				l_sysdate || ';' ||
				l_heure
			     );


	compteur := 0;

	 FOR cur_enr IN curs_refE
      LOOP

        PACK_GLOBAL.WRITE_STRING(l_hfile,
                                   cur_enr.type_enreg	||';'||
                                   cur_enr.code_occurence		|| ';' ||
                                   cur_enr.libelle_occurence 				|| ';' ||
                                   ' '			 	|| ';' ||
                                   ' ' 				|| ';' ||
                                   cur_enr.code_ca 		|| ';' ||
                                   ' ' 				|| ';' ||
                                   ' '				|| ';' ||
                                   ' '
				   );


		-- alimentation du compteur d'occurence
			compteur := compteur+1;

       END LOOP;

	select lpad(to_char(compteur, 'FM9999999999999999990'),19,' ') into l_compteur from dual;
--fin de fichier
	PACK_GLOBAL.WRITE_STRING( l_hfile,
				 '3' || ';' ||
				 l_compteur);

       PACK_GLOBAL.CLOSE_WRITE_FILE(l_hfile);


	EXCEPTION
   		WHEN OTHERS THEN


   		pack_global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
   		raise_application_error(-20401, l_msg);

    END referentielE_fair;




PROCEDURE referentielA_fair ( p_filsigle IN VARCHAR2,
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2) IS


       l_hfile utl_file.file_type;
       l_msg  varchar2(1024);
	l_moismens varchar2(6);
	l_sysdate varchar2(8);
	l_heure varchar2(6);
	compteur number(19);
	l_compteur varchar2(19);
	l_subdiv varchar2(1);

-- déclaration du curseur pour le fichier de référentiel de type A contenant les qualif
-- et envoyé  à SGAM et à SGPM
	CURSOR curs_refA IS
	SELECT 	2 type_enreg,
		rpad(prestation,20,' ') code_occurence,
		rpad(libprest,50,' ') libelle_occurence
	FROM prestation;



   BEGIN

	select to_char(moismens,'MMYYYY') into l_moismens from datdebex;
	select to_char(sysdate,'DDMMYYYY') into l_sysdate from dual;
	select to_char(sysdate,'HH24MISS') into l_heure from dual;
	select decode(p_filsigle,'SGPM','1',decode(p_filsigle,'SGAM','2','3')) into l_subdiv from dual;


      PACK_GLOBAL.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);


--entete
     PACK_GLOBAL.WRITE_STRING( l_hfile,
				'1' || ';' ||
				'BB' || ';' ||
				l_subdiv || ';' ||
				'A' || ';' ||
				l_moismens || ';' ||
				l_sysdate || ';' ||
				l_heure
			     );


	compteur := 0;

	 FOR cur_enr IN curs_refA
      LOOP

        PACK_GLOBAL.WRITE_STRING(l_hfile,
                                  cur_enr.type_enreg	||';'||
                                   cur_enr.code_occurence		|| ';' ||
                                   cur_enr.libelle_occurence 				|| ';' ||
                                   ' '			 	|| ';' ||
                                   ' ' 				|| ';' ||
                                   ' ' 				|| ';' ||
                                   ' ' 				|| ';' ||
                                   ' '				|| ';' ||
                                   ' '
				   );


		-- alimentation du compteur d'occurence
			compteur := compteur+1;

       END LOOP;

	select lpad(to_char(compteur, 'FM9999999999999999990'),19,' ') into l_compteur from dual;
--fin de fichier
	PACK_GLOBAL.WRITE_STRING( l_hfile,
				 '3' || ';' ||
				 l_compteur);

       PACK_GLOBAL.CLOSE_WRITE_FILE(l_hfile);


	EXCEPTION
   		WHEN OTHERS THEN


   		pack_global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
   		raise_application_error(-20401, l_msg);

    END referentielA_fair;


PROCEDURE select_fair (
                           p_chemin_fichier IN VARCHAR2,
                           p_nom_fic_sgpm IN VARCHAR2,
                           p_nom_fic_sgam IN VARCHAR2,
			  -- p_nom_fic_sogessur IN VARCHAR2,
                           p_nom_fic_refE IN VARCHAR2,
                           p_nom_fic_refApm IN VARCHAR2,
			  -- p_nom_fic_refAso IN VARCHAR2,
			   p_nom_fic_refAam IN VARCHAR2
                          ) IS

l_msg  varchar2(1024);
BEGIN


	pack_fair.referentielE_fair(p_chemin_fichier,p_nom_fic_refE);
	pack_fair.referentielA_fair('SGPM',p_chemin_fichier,p_nom_fic_refApm);
	pack_fair.referentielA_fair('SGAM',p_chemin_fichier,p_nom_fic_refAam);

	pack_fair.alim_fair('SGPM');
	pack_fair.selectP_fair('SGPM',p_chemin_fichier,p_nom_fic_sgpm);

	pack_fair.alim_fair('SGAM');
	pack_fair.selectP_fair('SGAM',p_chemin_fichier,p_nom_fic_sgam);



EXCEPTION
   WHEN OTHERS THEN
   pack_global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
   raise_application_error(-20401, l_msg);

END select_fair;



END PACK_FAIR;
/


