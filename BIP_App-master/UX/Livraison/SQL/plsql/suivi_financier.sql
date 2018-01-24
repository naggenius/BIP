/******************************************************************************
   NAME:       pack_batch_suivfin
   PURPOSE:    Sert à l'extraction x_suivi_financier.rdf :Suivi financier en coût réel

   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        19/11/2003   NBM		   Created this package.
   1.1	      28/04/2004   PJO		   Séparation entre le Batch et l'extraction
   1.2	      30/06/2005   BAA         Corriger le calcule du cout en HTR	
   1.3		  08/06/2012   OEL		   QC 1439 : Reports priorité 2 - Profil de FI
   1.4		  08/08/2012   ABA		   QC 1439 : Reports priorité 2 - Profil de FI / prise en compte des immos ne pas appliquer de profil de fi
   1.5		  28/11/2012   TCO		   PPM 31447 : Ajout DISTINCT pour récupération des top_immo
   1.6		  24/04/2014   SEL		   PPM 58225
******************************************************************************/
CREATE OR REPLACE PACKAGE       "PACK_BATCH_SUIVFIN" IS
------------------------------------------------------------------------------
-- Procédure de sélection des lignes pour l'année en cours
------------------------------------------------------------------------------
   PROCEDURE selection(P_LOGDIR 	IN VARCHAR2) ;


END pack_batch_suivfin;
/


CREATE OR REPLACE PACKAGE BODY "PACK_BATCH_SUIVFIN" AS
-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
pragma EXCEPTION_init( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
pragma EXCEPTION_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère

PROCEDURE selection(P_LOGDIR          IN VARCHAR2) IS
L_HFILE     utl_file.file_type;
L_RETCOD    number;
L_PROCNAME  varchar2(256) := 'suivi_financier';
L_STATEMENT varchar2(256);
BEGIN
	-----------------------------------------------------
	-- Init de la trace
	-----------------------------------------------------
	L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
	if ( L_RETCOD <> 0 ) then
	raise_application_error( TRCLOG_FAILED_ID,
		                         'Erreur : Gestion du fichier LOG impossible',
		                         false );
	end if;

	-----------------------------------------------------
	-- Trace Start
	-----------------------------------------------------
	TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

	 --Suppression des lignes pour l'année courante
	L_STATEMENT := '* Suppression des lignes de l''année courante de CUMUL_CONSO';
	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	DELETE CUMUL_CONSO
	WHERE annee in (select to_number(to_char(datdebex,'YYYY')) from datdebex);
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table CUMUL_CONSO';
	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	COMMIT;

	L_STATEMENT := '* Insertion dans CUMUL_CONSO';
	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	INSERT INTO CUMUL_CONSO (annee,pid,ftsg,ftssii,envsg,envssii)
	WITH vue AS
     (SELECT
-- la table cumul_conso est alimentee par les couts standards
               SUM (  cons.cusag
                    * pack_utile_cout.getcouthtr (sr.soccode,
                                                               r.rtype,
                                                               TO_NUMBER (TO_CHAR (cons.cdeb, 'YYYY')),
                                                               l.metier,
                                                               sr.niveau,
                                                               sr.codsg,
                                                               sr.cout,
                                                               TO_CHAR (cons.cdeb, 'DD/MM/YYYY'),
                                                               si1.filcode
                                                              )

                   ) ft,
               
               -- pas de cout ENV pour les forfaits HS et les logiciels
               SUM (DECODE (sr.soccode, 'SG..', cons.cusag * c.coutenv_sg, cons.cusag * DECODE (r.rtype, 'E', 0, 'L', 0, c.coutenv_ssii))) env,
               DECODE (t.aistty, 'FF', t.aistpid, t.pid) pid, sr.soccode soccode
          FROM situ_ress_full sr, datdebex d, cout_std2 c, ressource r, ligne_bip l, struct_info si1, cons_sstache_res_mois cons, tache t, etape e
         WHERE l.pid = DECODE (t.aistty, 'FF', t.aistpid, t.pid)
           -- Jointures entre cons_sstache_res_mois et situ_ress_full
           AND cons.ident = sr.ident
           AND r.ident = sr.ident
           --Année en cours
           AND (cons.cdeb BETWEEN d.datdebex AND (ADD_MONTHS (d.datdebex, 12) - 1))
           -- ressource dont la prestation <>(IFO,MO ,GRA,INT,STA)
           AND sr.prestation NOT IN ('IFO', 'MO ', 'GRA', 'INT', 'STA')
           --Situation existante
           AND (sr.datsitu <= cons.cdeb OR sr.datsitu IS NULL)
           AND (sr.datdep >= cons.cdeb OR sr.datdep IS NULL)
           -- coût ENV
           AND sr.codsg BETWEEN c.dpg_bas AND c.dpg_haut
           AND c.annee = TO_NUMBER (TO_CHAR (d.datdebex, 'YYYY'))
           AND sr.codsg = si1.codsg
           AND RTRIM (l.metier) = c.metier
           -- jointure avec les tables etape, tache et cons_sstache_res_mois
           AND cons.pid = t.pid
           AND cons.acta = t.acta
           AND cons.acst = t.acst
           AND cons.ecet = t.ecet
           AND t.pid = e.pid
           AND t.ecet = e.ecet
      GROUP BY DECODE (t.aistty, 'FF', t.aistpid, t.pid), sr.soccode)
        SELECT 
            TO_NUMBER (TO_CHAR (d.datdebex, 'YYYY')) annee, 
            lb.pid pid, 
            sg.ft ftsg, 
            ssii.ft ftssii, 
            sg.env envsg, 
            ssii.env envssii
        FROM 
            (SELECT sum(ft) ft, sum(env) env, pid FROM vue WHERE soccode = 'SG..' group by pid) sg,
            (SELECT sum(ft) ft, sum(env) env, pid FROM vue WHERE soccode != 'SG..' group by pid) ssii,
            datdebex d,
            ligne_bip lb
        WHERE 
            lb.pid = ssii.pid(+) 
            AND lb.pid = sg.pid(+)
            -- type projet de 1 à 8
            AND lb.typproj <= 8 ;
	commit;
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table CUMUL_CONSO';
	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	-- Trace Stop
	-----------------------------------------------------
	TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
	TRCLOG.CLOSETRCLOG( L_HFILE );

	EXCEPTION
		when others then

			ROLLBACK;

			if sqlcode <> CALLEE_FAILED_ID and sqlcode <> TRCLOG_FAILED_ID then
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME || ' : ' || SQLERRM );
			end if;
			if sqlcode <> TRCLOG_FAILED_ID then
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				TRCLOG.CLOSETRCLOG( L_HFILE );
				raise_application_error( CALLEE_FAILED_ID,
				                        'Erreur : consulter le fichier LOG',
				                         false );
			else
				raise;
			end if;

END selection;


END pack_batch_suivfin;
/