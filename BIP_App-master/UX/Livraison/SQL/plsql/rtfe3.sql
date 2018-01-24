-- APPLICATION 
-- -----------------------------------------------------------------------------------------------
-- packbatch_rtfe PL/SQL
-- 
-- Ce package contient les differents procedures 
-- qui permet le chagement de la table rtfe à partir de la table tmp_rtfe
--
-- Crée        le 20/10/2005 par BAA
-- Modifiée    le 21/10/2005 par BAA   remplacer le ';' par les ',' et tester le debut du curseur.id 
-- Modifier    le 26/10/2005 par BAA   enlever remplacement de ';' par ',' et l'ajout du nom et prenom 
--				       dans la table RTFE
-- Modifié     le 18/11/2005 par BAA   Mettre les données en majuscle avant la comparaison
-- Modifié     le 23/11/2005 par BAA   Ajouter le rownum=1 dans les select avec into 
-- Modifié     le 06/10/2006 par PPR   Ajout de la table RTFE_USER
-- Modifié     le 05/11/2009 par YSB  TD 893
-- Modifié     le 05/02/2010 par YSB  TD 925
-- Modifié     le 05/05/2011 par BSA  QC 1176
-- 06/01/2012  QC 1329
--*************************************************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE     Packbatch_Rtfe AS


   --********************************************************************
   -- Procédure qui alimente la table rtfe à partir de la table tmp_rtfe
   --********************************************************************
   PROCEDURE load_rtfe(P_LOGDIR          IN VARCHAR2);


   --********************************************************************
   -- Procédure qui insert un ligne qui correspond à un role
   --********************************************************************
   -- FAD PPM 63956 : Ajout du IGG_RTFE
   PROCEDURE insert_role(p_ident IN NUMBER, P_USER_RTFE IN VARCHAR2, P_NOM IN VARCHAR2, P_PRENOM IN VARCHAR2, p_mail IN VARCHAR2,p_role IN VARCHAR2,p_igg IN VARCHAR2);
   -- FAD PPM 63956 : Fin


   --********************************************************************
   -- Procédure qui insert un ligne qui correspond
   -- à un role qui n'est pas trouvé dans la BIP
   --********************************************************************
   -- FAD PPM 63956 : Ajout du IGG_RTFE
   PROCEDURE insert_role_error(P_ID IN VARCHAR2, P_NOM IN VARCHAR2, P_PRENOM IN VARCHAR2, P_MAIL IN VARCHAR2 ,P_ROLE IN VARCHAR2, p_igg IN varchar2);
   -- FAD PPM 63956 : Fin



END Packbatch_Rtfe;
 /
 
 
 create or replace PACKAGE BODY     Packbatch_Rtfe AS

-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
PRAGMA EXCEPTION_INIT( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     NUMBER := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     NUMBER := -20001;   -- problème : erreur dans la gestion d'erreur !
ERR_FONCTIONNELLE_ID NUMBER := -20002;   -- pour provoquer erreur alors que Oracle OK
CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
PRAGMA EXCEPTION_INIT( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère




--********************************************************************
-- Procédure qui alimente la table rtfe à partir de la table tmp_rtfe
--********************************************************************
PROCEDURE load_rtfe(P_LOGDIR          IN VARCHAR2)   IS


L_PROCNAME  VARCHAR2(16) := 'ALIM_RTFE';
L_HFILE     UTL_FILE.FILE_TYPE;
L_RETCOD    NUMBER;
L_STATEMENT VARCHAR2(128);

l_ident NUMBER(5);

CURSOR cur_rtfe IS
SELECT * FROM TMP_RTFE;


BEGIN

    -----------------------------------------------------
	-- Init de la trace
	-----------------------------------------------------
		L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
		IF ( L_RETCOD <> 0 ) THEN
		RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
		                        'Erreur : Gestion du fichier LOG impossible',
		                         FALSE );
		END IF;


		Trclog.Trclog( L_HFILE, 'Debut de ' || L_PROCNAME );

	-- On vide la table RTFE
	L_STATEMENT := '* Truncate de la table RTFE';
    Trclog.Trclog( L_HFILE, L_STATEMENT );
	Packbatch.DYNA_TRUNCATE('RTFE');

	-- On vide la table RTFE_ERROR
	L_STATEMENT := '* Truncate de la table RTFE_ERROR';
    Trclog.Trclog( L_HFILE, L_STATEMENT );
	Packbatch.DYNA_TRUNCATE('RTFE_ERROR');



    -----------------------------------------------------
	-- Trace Start
	-----------------------------------------------------


  L_STATEMENT := '* Insertion des données dans la table RTFE';
    Trclog.Trclog( L_HFILE, L_STATEMENT );


	FOR curseur IN cur_rtfe LOOP
	 	BEGIN

		  IF(UPPER(SUBSTR(curseur.ID,1,1)) = 'A')THEN

	 	     SELECT ident INTO l_ident FROM RESSOURCE
		     WHERE UPPER(SUBSTR(matricule,1,6)) = UPPER(SUBSTR(curseur.ID,2,7))
                     AND ROWNUM=1;

		  ELSIF(UPPER(SUBSTR(curseur.ID,1,1)) = 'X')THEN

		     SELECT ident INTO l_ident FROM RESSOURCE
		     WHERE UPPER(matricule) = UPPER(curseur.ID)
                     AND ROWNUM=1 ;

		  ELSE
		     RAISE NO_DATA_FOUND;
		  END IF;


		EXCEPTION

		 WHEN NO_DATA_FOUND THEN

		    BEGIN

			   SELECT ident INTO l_ident FROM RESSOURCE
		       WHERE UPPER(rnom)=UPPER(curseur.sn)
		       AND UPPER(rprenom)=UPPER(curseur.givenname)
		       AND ROWNUM=1;



		    EXCEPTION
		      WHEN NO_DATA_FOUND THEN

		      DBMS_OUTPUT.PUT_LINE('erreur');

		      l_ident := NULL;

			  -- FAD PPM 63956 : Insertion du IGG dans la table RTFE_ERROR
		      IF(curseur.sgutiroleatt1 IS NOT NULL)THEN
		      		insert_role_error(curseur.ID,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt1, curseur.IGG);
		  	  END IF;
		      IF(curseur.sgutiroleatt2 IS NOT NULL)THEN
		            insert_role_error(curseur.ID,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt2, curseur.IGG);
		      END IF;
		      IF(curseur.sgutiroleatt3 IS NOT NULL)THEN
		            insert_role_error(curseur.ID,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt3, curseur.IGG);
		      END IF;
		      IF(curseur.sgutiroleatt4 IS NOT NULL)THEN
		            insert_role_error(curseur.ID,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt4, curseur.IGG);
		      END IF;
		      IF(curseur.sgutiroleatt5 IS NOT NULL)THEN
		            insert_role_error(curseur.ID,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt5, curseur.IGG);
		      END IF;
		      IF(curseur.sgutiroleatt6 IS NOT NULL)THEN
		            insert_role_error(curseur.ID,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt6, curseur.IGG);
		      END IF;
		      IF(curseur.sgutiroleatt7 IS NOT NULL)THEN
		            insert_role_error(curseur.ID,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt7, curseur.IGG);
		      END IF;
			  -- FAD PPM 63956 : Fin
		    END;


       END;



		IF(l_ident IS NOT NULL)THEN
		  -- FAD PPM 63956 : Insertion du IGG dans la table RTFE
		  IF(curseur.sgutiroleatt1 IS NOT NULL)THEN
		     insert_role(l_ident,curseur.sgzoneid,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt1, curseur.IGG);
		  END IF;
		  IF(curseur.sgutiroleatt2 IS NOT NULL)THEN
		     insert_role(l_ident,curseur.sgzoneid,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt2, curseur.IGG);
		  END IF;
		  IF(curseur.sgutiroleatt3 IS NOT NULL)THEN
		     insert_role(l_ident,curseur.sgzoneid,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt3, curseur.IGG);
		  END IF;
		  IF(curseur.sgutiroleatt4 IS NOT NULL)THEN
		     insert_role(l_ident,curseur.sgzoneid,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt4, curseur.IGG);
		  END IF;
		  IF(curseur.sgutiroleatt5 IS NOT NULL)THEN
		     insert_role(l_ident,curseur.sgzoneid,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt5, curseur.IGG);
		  END IF;
		  IF(curseur.sgutiroleatt6 IS NOT NULL)THEN
		     insert_role(l_ident,curseur.sgzoneid,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt6, curseur.IGG);
		  END IF;
		  IF(curseur.sgutiroleatt7 IS NOT NULL)THEN
		     insert_role(l_ident,curseur.sgzoneid,curseur.sn,curseur.givenname,curseur.mail,curseur.sgutiroleatt7, curseur.IGG);
		  END IF;
		  -- FAD PPM 63956 : Fin

		END IF;

	 END LOOP;

	 COMMIT;

	-- On vide la table RTFE_USER
	L_STATEMENT := '* Truncate de la table RTFE_USER';
    Trclog.Trclog( L_HFILE, L_STATEMENT );
	Packbatch.DYNA_TRUNCATE('RTFE_USER');

	-- Renseigne la table RTFE_USER
	  INSERT INTO RTFE_USER(
  		 	  	   user_rtfe,
  		 	  	   nom,
				   prenom,
				   ident)
	 	SELECT DISTINCT
	 			upper(user_rtfe),
	 			nom,
	 			prenom,
	 			ident
	 	FROM RTFE ;

	 	-- Renseigne la table RTFE_USER (utilisateurs qui ne sont pas déclarés comme ressources BIP)
	  INSERT INTO RTFE_USER(
  		 	  	   user_rtfe,
  		 	  	   nom,
				   prenom,
				   ident)
	 	SELECT DISTINCT
	 			upper(user_rtfe),
	 			nom,
	 			prenom,
	 			0
	 	FROM RTFE_ERROR
	 	WHERE NOT EXISTS ( SELECT 1 FROM RTFE
	 	                   WHERE RTFE.user_rtfe = RTFE_ERROR.user_rtfe) ;

	 	COMMIT;

	Trclog.Trclog( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME);


	EXCEPTION
	WHEN OTHERS THEN
	    ROLLBACK;
		IF SQLCODE <> CALLEE_FAILED_ID THEN
				Trclog.Trclog( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		END IF;
		Trclog.Trclog( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		RAISE CALLEE_FAILED;




END load_rtfe;




--********************************************************************
-- Procédure qui insert une ligne qui correspond à un role
--********************************************************************
PROCEDURE insert_role(p_ident IN NUMBER, P_USER_RTFE IN VARCHAR2, P_NOM IN VARCHAR2, P_PRENOM IN VARCHAR2, p_mail IN VARCHAR2,p_role IN VARCHAR2,p_igg IN VARCHAR2) IS

l_role              VARCHAR2(20);
l_menus             VARCHAR2(200);
l_ss_menus          VARCHAR2(200);
l_bddpg_defaut 		VARCHAR2(30);
l_perim_me 		    VARCHAR2(1000);
l_chef_projet 		VARCHAR2(4000);--PPM 63485
l_mo_defaut		    VARCHAR2(30);
l_perim_mo          VARCHAR2(1000);
l_perim_mcli        VARCHAR2(500);
l_centre_frais  	VARCHAR2(50);
l_ca_suivi 		    VARCHAR2(4000);
l_projet 		    VARCHAR2(5000);
l_appli        		VARCHAR2(4000);
l_ca_fi        		VARCHAR2(4000);
l_ca_payeur   		VARCHAR2(4000);
--YNI FDT 893
l_ca_da   		VARCHAR2(4000);
--Fin YNI FDT 893
l_doss_proj   		VARCHAR2(5000);

l_pos NUMBER(7);
l_pos1 NUMBER(7);
l_chaine VARCHAR2(4000);

BEGIN


   --recherche du role
   l_pos := INSTR(p_role,'Role=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+5;
     l_pos1 := INSTR(p_role,':',l_pos,1);


     IF(l_pos1=0)THEN
       l_role := SUBSTR(p_role,l_pos);
     ELSE
	   l_role := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,':Menus=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+7;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_menus := SUBSTR(p_role,l_pos);
     ELSE
	   l_menus := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'Ss_Menus=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+9;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_ss_menus := SUBSTR(p_role,l_pos);
     ELSE
	   l_ss_menus := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'BDDPG_defaut=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+13;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_bddpg_defaut := SUBSTR(p_role,l_pos);
     ELSE
	   l_bddpg_defaut := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;





   l_pos := INSTR(p_role,'Perim_ME=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+9;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_perim_me := SUBSTR(p_role,l_pos);
     ELSE
	   l_perim_me := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

	-- DBMS_OUTPUT.PUT_LINE('l_pos  !'||l_pos);
	-- DBMS_OUTPUT.PUT_LINE('l_pos1  !'||l_pos1);
	-- DBMS_OUTPUT.PUT_LINE('l_perim_me  !'||l_perim_me);


   END IF;

   l_pos := INSTR(p_role,'Chef_Projet=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+12;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_chef_projet := SUBSTR(p_role,l_pos);
     ELSE
	   l_chef_projet := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'MO_defaut=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+10;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_mo_defaut := SUBSTR(p_role,l_pos);
     ELSE
	   l_mo_defaut := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'Perim_MO=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+9;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_perim_mo := SUBSTR(p_role,l_pos);
     ELSE
	   l_perim_mo := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;

-- BSA 1176
   l_pos := INSTR(p_role,'Perim_MCLI=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+11;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_perim_mcli := SUBSTR(p_role,l_pos);
     ELSE
	   l_perim_mcli := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'Centre_Frais=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+13;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_centre_frais := SUBSTR(p_role,l_pos);
     ELSE
	   l_centre_frais := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'CA_Suivi=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+9;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_ca_suivi := SUBSTR(p_role,l_pos);
     ELSE
	   l_ca_suivi := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,':Projet=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+8;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_projet := SUBSTR(p_role,l_pos);
     ELSE
	   l_projet := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;

   l_pos := INSTR(p_role,'Appli=',1,2);

   IF(l_pos>0)THEN

	 l_pos := l_pos+6;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_appli := SUBSTR(p_role,l_pos);
     ELSE
	   l_appli := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'CA_FI=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+6;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_ca_fi := SUBSTR(p_role,l_pos);
     ELSE
	   l_ca_fi := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'CA_Payeur=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+10;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_ca_payeur := SUBSTR(p_role,l_pos);
     ELSE
	   l_ca_payeur := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;

   l_pos := INSTR(p_role,'Doss_proj=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+10;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_doss_proj := SUBSTR(p_role,l_pos);
     ELSE
	   l_doss_proj := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


  --YNI FDT 893
  l_pos := INSTR(p_role,'CA_DA=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+6;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_ca_da := SUBSTR(p_role,l_pos);
     ELSE
	   l_ca_da := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;
  --Fin YNI FDT 893


  INSERT INTO RTFE(ident,
  		 	  	   user_rtfe,
  		 	  	   nom,
				   prenom,
  		 	  	   ROLE,
				   menus,
				   ss_menus,
				   bddpg_defaut,
				   perim_me,
				   chef_projet,
				   mo_defaut,
				   perim_mo,
                   perim_mcli,      -- BSA QC 1176
				   CENTRE_FRAIS,
  				   ca_suivi,
  				   projet,
  				   appli,
  				   ca_fi,
  				   ca_payeur,
  				   doss_proj,
             CA_DA,
             MAIL,
			 -- FAD PPM 63956 : Ajout du IGG_RTFE
			 IGG_RTFE
			 -- FAD PPM 63956 : Fin
				  )
			VALUES(p_ident,
			       p_user_rtfe,
				   p_nom,
				   p_prenom,
  		 	  	   l_role,
				   l_menus,
				   l_ss_menus,
				   l_bddpg_defaut,
				   l_perim_me,
				   l_chef_projet,
				   l_mo_defaut,
				   l_perim_mo,
                   l_perim_mcli,     -- BSA QC 1176
				   l_centre_frais,
  				   l_ca_suivi,
  				   l_projet,
  				   l_appli,
  				   l_ca_fi,
  				   l_ca_payeur,
  				   l_doss_proj,
             l_ca_da,
             p_mail,
			 -- FAD PPM 63956 : Ajout du IGG_RTFE
			 p_igg
			 -- FAD PPM 63956 : Fin
				  );
  COMMIT;

END insert_role;



--********************************************************************
-- Procédure qui insert un ligne qui correspond
-- à un role qui n'est pas trouvé dans la BIP
--********************************************************************
PROCEDURE insert_role_error(P_ID IN VARCHAR2, P_NOM IN VARCHAR2, P_PRENOM IN VARCHAR2, p_mail IN VARCHAR2,P_ROLE IN VARCHAR2,P_IGG IN VARCHAR2) IS

l_role              VARCHAR2(20);
l_menus             VARCHAR2(200);
l_ss_menus          VARCHAR2(200);
l_bddpg_defaut 		VARCHAR2(30);
l_perim_me 		    VARCHAR2(1000);
l_chef_projet 		VARCHAR2(4000);--PPM 63485
l_mo_defaut		    VARCHAR2(30);
l_perim_mo          VARCHAR2(1000);
l_perim_mcli         VARCHAR2(500);
l_centre_frais  	VARCHAR2(50);
l_ca_suivi 		    VARCHAR2(4000);
l_projet 		    VARCHAR2(5000);
l_appli        		VARCHAR2(4000);
l_ca_fi        		VARCHAR2(4000);
l_ca_payeur   		VARCHAR2(4000);
l_doss_proj   		VARCHAR2(5000);
--YNI FDT 893
l_ca_da   		VARCHAR2(4000);
--Fin YNI FDT 893


l_pos NUMBER(7);
l_pos1 NUMBER(7);
l_chaine VARCHAR2(4000);

BEGIN


   --recherche du role
   l_pos := INSTR(p_role,'Role=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+5;
     l_pos1 := INSTR(p_role,':',l_pos,1);


     IF(l_pos1=0)THEN
       l_role := SUBSTR(p_role,l_pos);
     ELSE
	   l_role := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,':Menus=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+7;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_menus := SUBSTR(p_role,l_pos);
     ELSE
	   l_menus := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'Ss_Menus=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+9;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_ss_menus := SUBSTR(p_role,l_pos);
     ELSE
	   l_ss_menus := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'BDDPG_defaut=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+13;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_bddpg_defaut := SUBSTR(p_role,l_pos);
     ELSE
	   l_bddpg_defaut := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;





   l_pos := INSTR(p_role,'Perim_ME=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+9;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_perim_me := SUBSTR(p_role,l_pos);
     ELSE
	   l_perim_me := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;




   END IF;

   l_pos := INSTR(p_role,'Chef_Projet=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+12;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_chef_projet := SUBSTR(p_role,l_pos);
     ELSE
	   l_chef_projet := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'MO_defaut=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+10;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_mo_defaut := SUBSTR(p_role,l_pos);
     ELSE
	   l_mo_defaut := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'Perim_MO=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+9;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_perim_mo := SUBSTR(p_role,l_pos);
     ELSE
	   l_perim_mo := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


-- BSA QC 1176
   l_pos := INSTR(p_role,'Perim_MCLI=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+11;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_perim_mcli := SUBSTR(p_role,l_pos);
     ELSE
	   l_perim_mcli := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'Centre_Frais=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+13;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_centre_frais := SUBSTR(p_role,l_pos);
     ELSE
	   l_centre_frais := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'CA_Suivi=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+9;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_ca_suivi := SUBSTR(p_role,l_pos);
     ELSE
	   l_ca_suivi := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,':Projet=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+8;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_projet := SUBSTR(p_role,l_pos);
     ELSE
	   l_projet := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;

   l_pos := INSTR(p_role,'Appli=',1,2);

   IF(l_pos>0)THEN

	 l_pos := l_pos+6;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_appli := SUBSTR(p_role,l_pos);
     ELSE
	   l_appli := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'CA_FI=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+6;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_ca_fi := SUBSTR(p_role,l_pos);
     ELSE
	   l_ca_fi := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;


   l_pos := INSTR(p_role,'CA_Payeur=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+10;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_ca_payeur := SUBSTR(p_role,l_pos);
     ELSE
	   l_ca_payeur := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;

   l_pos := INSTR(p_role,'Doss_proj=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+10;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_doss_proj := SUBSTR(p_role,l_pos);
     ELSE
	   l_doss_proj := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;

 --YNI FDT 893
  l_pos := INSTR(p_role,'CA_DA=',1,1);

   IF(l_pos>0)THEN

	 l_pos:=l_pos+6;
     l_pos1 := INSTR(p_role,':',l_pos,1);

     IF(l_pos1=0)THEN
       l_ca_da := SUBSTR(p_role,l_pos);
     ELSE
	   l_ca_da := SUBSTR(p_role,l_pos,l_pos1-l_pos);
	 END IF;

   END IF;
  --Fin YNI FDT 893

  INSERT INTO RTFE_ERROR(
  		 	  	   user_rtfe,
  		 	  	   nom,
				   prenom,
				   ROLE,
				   menus,
				   ss_menus,
				   bddpg_defaut,
				   perim_me,
				   chef_projet,
				   mo_defaut,
				   perim_mo,
                   perim_mcli,       -- BSA QC 1176
				   CENTRE_FRAIS,
  				   ca_suivi,
  				   projet,
  				   appli,
  				   ca_fi,
  				   ca_payeur,
  				   doss_proj,
             CA_DA,
             MAIL,
			 -- FAD PPM 63956 : Ajout du IGG_RTFE
			 IGG_RTFE
			 -- FAD PPM 63956 : Fin
				  )
			VALUES(
			       p_id,
  		 	  	   p_nom,
				   p_prenom,
				   l_role,
				   l_menus,
				   l_ss_menus,
				   l_bddpg_defaut,
				   l_perim_me,
				   l_chef_projet,
				   l_mo_defaut,
				   l_perim_mo,
                   l_perim_mcli,        -- BSA QC 1176
				   l_centre_frais,
  				   l_ca_suivi,
  				   l_projet,
  				   l_appli,
  				   l_ca_fi,
  				   l_ca_payeur,
  				   l_doss_proj,
             l_ca_da,
             p_mail,
			 -- FAD PPM 63956 : Ajout du IGG_RTFE
			 p_igg
			 -- FAD PPM 63956 : Fin
				  );
  COMMIT;

END;




END Packbatch_Rtfe;
/