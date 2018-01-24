-- Nom            : histo_cloture.sql
-- Auteur         : P. JOSSE
-- Description    : Batch Annuel - cloture : pack_batch_histo_cloture
--                  MISE A JOUR DES TABLE HISTO_STOCK_IMMMO et HISTO_STOCK_FI
-- Ordonnancement : Lors de la clôture
--
--*********************************************************************************************
-- Quand      Qui  Quoi
-- 13/11/2008  ABA  TD 698 copie annuel de la stock_immo dans histo_stock_immo_corrige 
-- 13/07/2011  ABA   QC 1229
-- -----      ---  ----------------------------------------------------------------------------

--*********************************************************************************************

CREATE OR REPLACE PACKAGE pack_batch_histo_cloture AS

  -- ------------------------------------------------------------------------
  -- Nom         :  amthist
  -- Auteur      :  P. JOSSE
  -- Description :  historisation des consommés immobilisés au cours de l'année d'exercice.
  -- 		    Sélection des enregistrements de STOCK_IMMO
  --
  --
  -- ------------------------------------------------------------------------
PROCEDURE cloture_exercice (P_LOGDIR in varchar2);

PROCEDURE cloture_fi_nov (P_LOGDIR in varchar2);

END pack_batch_histo_cloture;
/


CREATE OR REPLACE PACKAGE BODY     pack_batch_histo_cloture AS
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




/*******************************************************************************************
  traitannuel.sh
      + histo_cloture.sh (historisation des immos)
*********************************************************************************************/
PROCEDURE cloture_exercice (P_LOGDIR in varchar2) IS

   L_HFILE utl_file.file_type;
   L_RETCOD       number;
   L_PROCNAME     varchar2(64) := 'pack_batch_amthist.cloture_exercice';
   L_STATEMENT    varchar2(64);

   l_inserted     number:=0;


BEGIN
   -- ----------------
   -- Init de la trace
   -- ----------------
      L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
     if ( L_RETCOD <> 0 ) then
         raise_application_error( TRCLOG_FAILED_ID,
                   'Erreur : Gestion du fichier LOG impossible');
     end if;


   -- -----------
   -- Trace Start
   -- -----------
   TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

   L_STATEMENT := 'MISE A JOUR DE HISTO_STOCK_IMMO';

   -- -----------
   -- On insert toute les lignes de STOCK_IMMO dans la table
   -- En attendant d'avoir des specs plus précises
   -- -----------
   SELECT count(*) INTO l_inserted
   FROM STOCK_IMMO;

   INSERT INTO HISTO_STOCK_IMMO
   (SELECT * FROM STOCK_IMMO);

   TRCLOG.TRCLOG(L_HFILE, L_STATEMENT || l_inserted||' lignes insérées dans HISTO_STOCK_IMMO');

    L_STATEMENT := 'MISE A JOUR DE HISTO_STOCK_IMMO_CORRIGE';

   -- -----------
   -- On insère l'année stocké dans stock immo dans stock_immo_corrigé pour les audits TD 698
   --
   -- -----------
   SELECT count(*) INTO l_inserted
   FROM STOCK_IMMO;

   INSERT INTO HISTO_STOCK_IMMO_CORRIGE
   (SELECT CDEB, PID, IDENT, TYPPROJ, METIER, PNOM, CODSG, DPCODE,
   ICPI, CODCAMO, CLIBRCA, CAFI, CODSGRESS, LIBDSG, RNOM, RTYPE,
   PRESTATION, NIVEAU, SOCCODE, CADA, COUTFTHT, COUTFT, CONSOJH, CONSOFT, A_CONSOJH, A_CONSOFT
    FROM STOCK_IMMO);

   TRCLOG.TRCLOG(L_HFILE, L_STATEMENT || l_inserted||' lignes insérées dans HISTO_STOCK_IMMO_CORRIGE');
   
    L_STATEMENT := 'MISE A JOUR DE HISTO_STOCK_IMMO_SC';

   -- -----------
   -- On insert toute les lignes de STOCK_IMMO_SC
   -- -----------
   SELECT count(*) INTO l_inserted
   FROM STOCK_IMMO_SC;

   INSERT INTO HISTO_STOCK_IMMO_SC
   (SELECT * FROM STOCK_IMMO_SC);

   TRCLOG.TRCLOG(L_HFILE, L_STATEMENT || l_inserted||' lignes insérées dans HISTO_STOCK_IMMO_SC');

   COMMIT;
   -- ----------
   -- Trace Stop
   -- ----------
   TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME );
   TRCLOG.CLOSETRCLOG( L_HFILE );

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      IF (sqlcode <> CALLEE_FAILED_ID) and  (sqlcode <> TRCLOG_FAILED_ID)
      THEN  TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' : '|| SQLERRM );
      END IF;

      IF sqlcode <> TRCLOG_FAILED_ID
      THEN  TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
            TRCLOG.CLOSETRCLOG( L_HFILE );
            raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
      ELSE  raise;
      END IF;

END cloture_exercice;

  -- ******************************************************************************************
  --SEL PPM 58986 : integré dans le script histo_cloture.sh
PROCEDURE cloture_fi_nov (P_LOGDIR in varchar2) IS

   L_HFILE utl_file.file_type;
   L_RETCOD       number;
   L_PROCNAME     varchar2(64) := 'pack_batch_amthist.cloture_fi_nov';
   L_STATEMENT    varchar2(64);

   l_inserted     number:=0;


BEGIN
   -- ----------------
   -- Init de la trace
   -- ----------------
      L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
     if ( L_RETCOD <> 0 ) then
         raise_application_error( TRCLOG_FAILED_ID,
                   'Erreur : Gestion du fichier LOG impossible');
     end if;


   -- -----------
   -- Trace Start
   -- -----------
   TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

   L_STATEMENT := 'MISE A JOUR DE HISTO_STOCK_FI';

   -- -----------
   -- On insert toute les lignes de STOCK_FI de novembre dans la table
   -- En attendant d'avoir des specs plus précises
   -- -----------
   SELECT count(*) INTO l_inserted
   FROM STOCK_FI;

   INSERT INTO HISTO_STOCK_FI
   (SELECT * FROM STOCK_FI);

   TRCLOG.TRCLOG(L_HFILE, L_STATEMENT || l_inserted||' rows inserted');

   COMMIT;
   -- ----------
   -- Trace Stop
   -- ----------
   TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME );
   TRCLOG.CLOSETRCLOG( L_HFILE );

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      IF (sqlcode <> CALLEE_FAILED_ID) and  (sqlcode <> TRCLOG_FAILED_ID)
      THEN  TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' : '|| SQLERRM );
      END IF;

      IF sqlcode <> TRCLOG_FAILED_ID
      THEN  TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
            TRCLOG.CLOSETRCLOG( L_HFILE );
            raise_application_error( CALLEE_FAILED_ID,'Erreur : consulter le fichier LOG',false );
      ELSE  raise;
      END IF;

END cloture_fi_nov;

END pack_batch_histo_cloture;
/