--
-- pack_export_comptable PL/SQL
--
-- extractions lot3a : export compta siège -->	accès  via axcompta.htm --> execssjs.htm ET ./lib/axcompta
--
-- Equipe SOPRA 
--
-- Créé le 15/12/1999
--
-- Modifications ulterieures :
--    14/03/2000	MSA	ajout de 2 exceptions (n° poste sdff = null, nb_factures = 0)
--				modification ModeExecution : n'est plus differee
--				extraction est consideree comme un traitement TP
--
--    06/06/2000 	NCM 	- entete : cle discriminante = code user||n°envoi
--				- factures : 	ajout champ 13=montant tva
--						le n° du champ règle fiscale(avant 17) devient n°14
--				- détail de factures : champ 10 devient règle fiscale
--
--    08/08/2000 	NCM : 	création d'un état de controle des factures à envoyer
--				qui se lance après le message "Export comptabilité siège terminé avec succès"
--  				-> création d'une table temporaire qui garde les factures qui doivent être envoyées
--					   table : tmp_factae
--    18/09/2000 	NCM : zone DCO=H si code comptable=4380(ancien code)=6396206(nouveau code) Frais d'études
--				  (lignes factures)
--    27/09/2000        NCM : ajout d'un 2 devant le code centre d'activité
--    04/10/2000	NCM : site fournisseur = 3 derniers caractères du nouveau code fournisseur
--    06/10/2000	NCM : -	code taux de taxe =196FG si tva=19.6, 
--						= 0PCT  si tva=0 
--  			      - si plusieurs lignes de facture,renumérotation	
--    06/11/2000        NCM : la zone n°facture ne doit contenir que le n°de facture et non typfact et société	
--    21/11/2000        NCM : Création de la fonction f_get_numenvoi qui retourne le numéro d'envoi
--    29/12/2000	PDQ : Suppression du 2 devant le code centre d'activité
--    05/01/2001	NCM : Le code centre de frais ne doit plus être en dur , prendre le centre de frais de l'utilisateur
--    25/01/2001        NCM : code devise=EUR
--    22/09/2003	OTO : Mise en place du traitement pour passage en batch.
--    05/11/2003	EGR : Gestion pour les users SGCIB
--    01/07/2004	MMC : La table tmp_factae sera videe dans le reports et non dans le package
--    24/06/2005	BAA : Ajout de la clause (where c.filcode='01 ' ) au curseur cur_user  



CREATE OR REPLACE PACKAGE pack_export_comptable AS

  -- -----------------------------------------------------------------------
  -- Nom        : f_get_numenvoi
  -- Auteur     : NCM
  -- Description :  combinaison des 10 chiffres et des 26 lettres
  -- Retour     : retourne le numéro d'envoi sur 2 caractères (00 à ZZ)
  --
  -- -----------------------------------------------------------------------
  FUNCTION f_get_numenvoi RETURN VARCHAR2;

  -- -----------------------------------------------------------------------
  -- Nom        : select_export_comptable
  -- Auteur     : Equipe SOPRA
  -- Description : extraction des exports comptables siège,
  --			sélection de factures et de lignes de facture associées
  -- Paramètres : p_chemin_fichier IN VARCHAR2  :
  --
  -- ------------------------------------------------------------------------

  PROCEDURE select_export_comptable( p_chemin_fichier  IN VARCHAR2) ;

END pack_export_comptable;
/



CREATE OR REPLACE PACKAGE BODY pack_export_comptable AS

  -- -----------------------------------------------------------------------
  -- Nom        : f_get_numenvoi
  -- Auteur     : NCM
  -- Description :  combinaison des 10 chiffres et des 26 lettres
  -- Retour     : retourne le numéro d'envoi sur 2 caractères (00 à ZZ)
  --
  -- -----------------------------------------------------------------------

FUNCTION f_get_numenvoi RETURN VARCHAR2 IS

l_num_envoi	CHAR(2) ;
l_numenvoi1	CHAR(2) ;
l_numenvoi2	CHAR(2) ;

l_oldnum1       CHAR(1) ;
l_oldnum2       CHAR(1) ;
l_nextnum1	CHAR(1) ;
l_nextnum2	CHAR(1) ;


l_num1          CHAR(1) ;
l_num2 		CHAR(1) ;
liste_1      VARCHAR2(36);
liste_2		VARCHAR2(36);


BEGIN

liste_1 := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
liste_2 := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

select numenvoi,oldnum,nextnum
into l_num_envoi, l_oldnum1, l_nextnum1
from abecedaire where numliste=1;

dbms_output.put_line('le numéro d"envoi : '||l_num_envoi);

select oldnum, nextnum, numenvoi
into l_oldnum2, l_nextnum2 , l_numenvoi2
from abecedaire where numliste=2;


-- Si on n'est pas en fin de liste 2, on reste sur le même caractère de la liste 1
-- on se déplace sur la liste 2
IF l_oldnum2!='Z' THEN
	l_num1 := l_oldnum1;
	l_num2 := l_nextnum2;
	-- Prochain numéro d'envoi
	update abecedaire
	set numenvoi=l_num1||l_num2;


	-- le 2ème caractère du numéro d'envoi devient un ancien caractère
	if l_oldnum2!='Y' then
		l_nextnum2 := substr(liste_2, instr(liste_2,l_nextnum2,1,1)+1, 1);
	else
		l_nextnum2 := '0';
	end if;

	update abecedaire
	set oldnum=l_num2,
	    nextnum=l_nextnum2
	where numliste=2;
ELSE
-- On arrive à la fin de la liste 2 et on se déplace sur la liste 1
       	l_num1 := l_nextnum1;
       	l_num2 := l_nextnum2;
	l_nextnum2 := substr(liste_2, instr(liste_2,l_nextnum2,1,1)+1, 1);

	if l_nextnum1='Z' then   -- on arrive à la fin de la liste 1
		l_nextnum1 := '0';
	else
		l_nextnum1 := substr(liste_1, instr(liste_1,l_nextnum1,1,1)+1, 1);
	end if;

       update abecedaire
	set 	oldnum=l_num1,
		nextnum=l_nextnum1,
		numenvoi=l_num1||l_num2
	where numliste=1;

	update abecedaire
	set oldnum=l_num2,
	    nextnum=l_nextnum2
	where numliste=2;



END IF;


return l_num_envoi;

END f_get_numenvoi;

  -- -----------------------------------------------------------------------
  -- Nom        : select_export_comptable
  -- Auteur     : Equipe SOPRA
  -- Description : extraction des exports comptables siège,
  --			sélection de factures et de lignes de facture associées
  -- Paramètres : p_chemin_fichier IN VARCHAR2  :
  --
  -- ------------------------------------------------------------------------
  PROCEDURE select_export_comptable( p_chemin_fichier  IN VARCHAR2) IS

   l_msg       VARCHAR2(1024);
   l_hfile     utl_file.file_type;
   l_idarpege  FACTURE.fcoduser%TYPE ;
   l_filiale   FILIALE_CLI.filcode%TYPE ;
   l_centrefrais centre_frais.codcfrais%TYPE;

   NUMICRO_FAILED 	EXCEPTION;
   NB_FACTURES_FAILED 	EXCEPTION;
   NB_USERS_FAILED	EXCEPTION;
   CF_FICTIF            EXCEPTION;

   l_date_creation   CHAR(8);
   l_date_fichier    CHAR(8);
   l_heure_creation  CHAR(6);
   l_SEPARATEUR      CONSTANT CHAR(1) := ';'  ;
   l_socfour  varchar2(13);

   l_old_socfact FACTURE.socfact%TYPE ;
   l_old_typfact FACTURE.typfact%TYPE ;
   l_old_datfact FACTURE.datfact%TYPE ;
   l_old_numfact FACTURE.numfact%TYPE ;

   l_entete_type_enreg           CONSTANT VARCHAR2(1) := '1'     ;
   l_entete_cle_discriminante     VARCHAR2(257) := ' '     ;
   l_entete_type_fichier         CONSTANT VARCHAR2(3) := 'FAC'     ;
   l_entete_code_application     CONSTANT VARCHAR2(5) := 'A0374' ;
   l_entete_sum_fmontttc         NUMBER(17,2) := 0     ;
   l_entete_sum_lmontht          NUMBER(17,2) := 0     ;
   l_entete_nb_total_lignes      NUMBER(7)    := 0     ;
   l_entete_nb_factures          NUMBER(6)    := 0     ;
   l_entete_nb_lignes_fact       NUMBER(5)    := 0     ;

   l_facture_type_enreg          CONSTANT VARCHAR2(1)  := '2'     ;
   l_facture_entite_payante      CONSTANT VARCHAR2(5)  := 'F7090' ;
   l_facture_code_irt            CONSTANT VARCHAR2(5)  := 'A0374' ;
   l_facture_centre_frais        VARCHAR2(3)  := ''   ;  	-- modif du 5/01/20001
   l_facture_id_lot              VARCHAR2(10)          := ''      ;
   l_facture_date_compta         VARCHAR2(8)  := ''      ;
   l_facture_entite_projet       CONSTANT VARCHAR2(5)  := ''      ;
   l_facture_code_devise         CONSTANT VARCHAR2(3)  := 'EUR'   ;
   l_facture_codefour		 VARCHAR2(10);
   l_facture_sitefour            VARCHAR2(3);

   l_ligne_fact_type_enreg       CONSTANT VARCHAR2(1) := '3'     ;
   l_ligne_fact_entite_immo      CONSTANT VARCHAR2(5) := ''      ;
   l_ligne_fact_code_taux_taxe   VARCHAR2(5)  ;
   l_ligne_fact_code_taxe_recup  CONSTANT VARCHAR2(3) := 'PRO'   ;
   l_ligne_fact_code_dco          VARCHAR2(5) := ''      ;
   l_ligne_fact_emetteur         VARCHAR2(3) := ''   ;

   l_regle_fiscale  CONSTANT VARCHAR2(9)  := 'TVAENCSST' ;
   l_filler         CONSTANT VARCHAR2(19) := ''      ;

   l_num_envoi	CHAR(2) ;
   l_signe        CHAR(1);
   l_date_envoi date;

   -- 05/11/2003 gestion users SGCIB
   l_idSansPoint	FACTURE.fcoduser%TYPE;	-- identifiant dont les '.' sont convertis en '_'
   l_champ18_tailleMax CONSTANT NUMBER(2) := 30;
   -- le champ 18 est limite a 30 caracteres, l'id doit etre tronque pour ne pas depasser
   l_champ18	VARCHAR2(30);


--
-- Curseur de recherche des utilisateurs
-- On selectionne tous les users arpeges  et leur code filiale
--
	CURSOR cur_users IS

		SELECT DISTINCT f.fcoduser, c.filcode, f.fcentrefrais
		FROM contrat c, ligne_fact LF, facture f
		WHERE	F.fstatut1   = 'AE'
		AND	(
			F.numcont IS null
			OR
			   (
			   C.soccont = F.soccont
		   	AND
		   	C.numcont = F.numcont
		   	AND
		   	C.cav     = F.cav
		   	))
		AND	LF.socfact  = F.socfact
		AND   LF.typfact  = F.typfact
		AND   LF.datfact  = F.datfact
		AND   LF.numfact  = F.numfact
		AND   c.filcode='01 ';

   --
   -- Curseur principal
   --
   -- Permet de selectionner les factures ET les lignes de facture associées
   --
   -- Attention : le curseur accepte 2 paramètres :
   --			1. l'identifiant de l'utilisateur
   --			2. le code filiale choisi par l'utilisateur
   --

   CURSOR type_curGlobal( p_idarpege  FACTURE.fcoduser%TYPE,
                          p_filiale   FILIALE_CLI.filcode%TYPE,
			  p_centrefrais CENTRE_FRAIS.codcfrais%TYPE
                        ) IS

	SELECT DISTINCT
		   F.fsocfour,
		   F.socfact,
		   F.typfact,
		   F.numfact,
		   F.datfact,
		   DECODE(F.typfact, 'F', 'INVC', 'A', 'DBMM', '') as code_justificatif,
		   F.fenvsec as fdate_reglt,
		   DECODE(F.typfact, 'F', '+' , 'A', '-', '') as signe,
			NVL(F.fmontttc,0)  as fmontttc,
		   SUBSTR(F.llibanalyt, 1, 35) as llibanalyt,
	 	  DECODE(F.typfact, 'F', '+' , 'A', '-', '') || TO_CHAR(NVL((F.fmontttc-F.fmontht),0),'FM999999999990.00')  as monttva,
		   LF.lnum,
		   LF.lmontht,
		   LF.lcodcompta,
		   to_char(SI.centractiv) centractiv,
		   LF.tva
	FROM	facture	F,
		contrat	C,
		ligne_fact	LF,
		struct_info	SI
	WHERE
		F.fstatut1   = 'AE'
	AND   F.fcoduser   = p_idarpege
	AND   F.fcentrefrais=p_centrefrais
	AND	(
		F.numcont IS null
		OR
		   (
		   C.soccont = F.soccont
		   AND
		   C.numcont = F.numcont
		   AND
		   C.cav     = F.cav
		   AND
		   C.filcode = p_filiale
		   )
		)
	AND	LF.socfact  = F.socfact
	AND   LF.typfact  = F.typfact
	AND   LF.datfact  = F.datfact
	AND   LF.numfact  = F.numfact
	AND   LF.ldeppole = SI.codsg
	ORDER BY
		F.fsocfour 			asc,
		F.socfact 			asc,
		F.numfact 			asc,
		F.typfact 			asc,
		F.datfact 			asc,
		code_justificatif 	asc,
		LF.lnum			asc ;


   BEGIN

	FOR  cur_ligne IN cur_users
	LOOP
		IF cur_users%NOTFOUND THEN
			RAISE NB_USERS_FAILED;
		END IF;

		l_facture_centre_frais  := LPAD(to_char(cur_ligne.fcentrefrais),3,'0');
		l_ligne_fact_emetteur := l_facture_centre_frais;

		-- ------------------------------------------------------------------------------------
		--
		-- Traitement de l'en-tete du fichier, 1er parcours du curseur
		--
		-- ------------------------------------------------------------------------------------
		l_old_socfact := ' ' ;
		l_old_typfact := ' ' ;
		l_old_numfact := ' ' ;
		SELECT to_date('01011900','DDMMYYYY') INTO l_old_datfact FROM dual;

		-- ------------------------------------------------------------------------------------
		-- 08/08/2000 :  table tmp_factae qui contient les factures à envoyer
		-- ------------------------------------------------------------------------------------
		BEGIN

		select sysdate into l_date_envoi
		from dual;

		INSERT INTO tmp_factae (FCODUSER,SOCFACT,TYPFACT,NUMFACT,LNUM,DATFACT,DATE_REGLT,MONTHT,TVA,
					SOCFOUR,LIBSOCFOUR,MOISPREST,CODCOMPTA,DPG,CENTRE_FRAIS,DATE_ENVOI)
			(SELECT DISTINCT
					F.fcoduser,
			    		F.socfact,
			   		F.typfact,
			   		F.numfact,
					LF.lnum,
			   		F.datfact,
					F.fenvsec as date_reglt,
					LF.lmontht,
					LF.tva,
					F.fsocfour,
					A.socflib,
					LF.lmoisprest,
					LF.lcodcompta,
					LF.ldeppole,
					F.fcentrefrais ,   -- 05/01/2001
					l_date_envoi --22/03/2001
			FROM	facture	F,
				contrat	C,
				ligne_fact	LF,
				struct_info	SI,
				agence		A
			WHERE
				F.fstatut1   = 'AE'
			AND   F.fcoduser   = cur_ligne.fcoduser
				AND   F.fcentrefrais=cur_ligne.fcentrefrais
			AND	(
				F.numcont IS null
				OR
			   	(
			   		C.soccont = F.soccont
			   	AND
			   		C.numcont = F.numcont
			   	AND
			   		C.cav     = F.cav
			   	AND
			   		C.filcode = cur_ligne.filcode
			   	)
				)
			AND	LF.socfact  = F.socfact
			AND   LF.typfact  = F.typfact
			AND   LF.datfact  = F.datfact
			AND   LF.numfact  = F.numfact
			AND   LF.ldeppole = SI.codsg
			AND   rtrim(A.socfour)=rtrim(F.fsocfour)
			AND   A.soccode=F.socfact
			);
		EXCEPTION
			WHEN NO_DATA_FOUND THEN null;
		END;

		FOR  cur_enr IN type_curGlobal(cur_ligne.fcoduser, cur_ligne.filcode,cur_ligne.fcentrefrais)
		LOOP

		   --
		   -- Est-ce une nouvelle facture ?
		   --
		   IF (    (cur_enr.socfact != l_old_socfact)
			  OR (cur_enr.typfact != l_old_typfact)
			  OR (cur_enr.datfact != l_old_datfact)
			  OR (cur_enr.numfact != l_old_numfact)
			) THEN

	dbms_output.put_line('montant='||cur_enr.fmontttc);
			l_entete_nb_total_lignes := l_entete_nb_total_lignes + 1 ;
   			l_entete_nb_factures     := l_entete_nb_factures     + 1 ;
		--	l_entete_sum_fmontttc    := l_entete_sum_fmontttc    + to_number(cur_enr.fmontttc,'FM999999999990.00S');
			l_entete_sum_fmontttc    := l_entete_sum_fmontttc    + (cur_enr.signe||to_number(cur_enr.fmontttc));
	dbms_output.put_line('total='||	l_entete_sum_fmontttc    );

			--
			-- Sauvegarder l'id de la facture
			--
			l_old_socfact := cur_enr.socfact ;
			l_old_typfact := cur_enr.typfact ;
			l_old_datfact := cur_enr.datfact ;
			l_old_numfact := cur_enr.numfact ;
		   END IF;

		   l_entete_nb_total_lignes := l_entete_nb_total_lignes + 1 ;
		   l_entete_nb_lignes_fact  := l_entete_nb_lignes_fact  + 1 ;
		   l_entete_sum_lmontht     := l_entete_sum_lmontht     + (cur_enr.signe||cur_enr.lmontht) ;
		l_signe:=cur_enr.signe;
		END LOOP;


		-- ------------------------------------------------------------------------------------
		-- Si pas de facture a extraire
		-- ------------------------------------------------------------------------------------
		IF l_entete_nb_factures = 0 THEN
		   raise NB_FACTURES_FAILED;
		END IF;


		-- ------------------------------------------------------------------------------------
		-- Initialisations
		-- ------------------------------------------------------------------------------------
		SELECT   to_char(sysdate,'YYYYMMDD'),
			   to_char(sysdate,'DDMMYYYY'),
			   to_char(sysdate,'HH24MISS')
		INTO     l_date_creation,
			   l_date_fichier,
			   l_heure_creation
		FROM	dual;


		l_num_envoi:=f_get_numenvoi;

		l_facture_id_lot :=  l_facture_centre_frais || l_num_envoi || l_facture_code_irt;

	        	-- -----------------------------------------------------
     			-- 06/06/2000 :La clé discriminante= codeuser+n°envoi
			-- -----------------------------------------------------
			-- ICI GESTION USERS SGCIB:
			-- on remplace les '.' par des '_' dans le fcoduser
			l_idSansPoint := replace(cur_ligne.fcoduser, '.', '_');

			dbms_output.put_line(cur_ligne.fcoduser || ' ===> ' || l_idSansPoint);
			--l_entete_cle_discriminante := cur_ligne.fcoduser || l_num_envoi;
			l_entete_cle_discriminante := l_idSansPoint || l_num_envoi;


		-- ------------------------------------------------------------------------------------
		-- Sinon, initialisation du fichier et ecriture de l'en-tete
		-- ------------------------------------------------------------------------------------

	  --PACK_GLOBAL.INIT_WRITE_FILE( p_chemin_fichier, 'NCS.BIP.BIPEXCOMPTA.' || cur_ligne.fcoduser || l_num_envoi || '.D' || l_date_fichier, l_hfile);
	  PACK_GLOBAL.INIT_WRITE_FILE( p_chemin_fichier, 'NCS.BIP.BIPEXCOMPTA.' || l_idSansPoint || l_num_envoi || '.D' || l_date_fichier, l_hfile);

		PACK_GLOBAL.WRITE_STRING( l_hfile,
						  l_entete_type_enreg                                  || l_SEPARATEUR ||
						  l_entete_cle_discriminante                           || l_SEPARATEUR ||
						  l_entete_type_fichier                                || l_SEPARATEUR ||
						  l_entete_code_application                            || l_SEPARATEUR ||
						  l_date_creation                                      || l_SEPARATEUR ||
						  l_heure_creation                                     || l_SEPARATEUR ||
						  TO_CHAR(l_entete_sum_fmontttc,'SFM999999999990.00')      || l_SEPARATEUR ||
						  TO_CHAR(l_entete_sum_lmontht,'SFM999999999990.00')   || l_SEPARATEUR ||
						  TO_CHAR(l_entete_nb_total_lignes)                    || l_SEPARATEUR ||
						  TO_CHAR(l_entete_nb_factures)                        || l_SEPARATEUR ||
						  TO_CHAR(l_entete_nb_lignes_fact)
						);


		-- ------------------------------------------------------------------------------------
		--
		-- Traitement de la suite du fichier, 2e parcours du curseur
		--
		-- ------------------------------------------------------------------------------------

		l_old_socfact := ' ' ;
		l_old_typfact := ' ' ;
		l_old_numfact := ' ' ;
		SELECT to_date('01011900','DDMMYYYY') INTO l_old_datfact FROM dual;


		FOR  cur_enr IN type_curGlobal(cur_ligne.fcoduser, cur_ligne.filcode,cur_ligne.fcentrefrais)
		LOOP

		   --
		   -- Est-ce une nouvelle facture ?
		   --
		   IF (    (cur_enr.socfact != l_old_socfact)
			  OR (cur_enr.typfact != l_old_typfact)
			  OR (cur_enr.datfact != l_old_datfact)
			  OR (cur_enr.numfact != l_old_numfact)
			) THEN

			--
			-- Sauvegarder l'id de la facture
			--
			l_old_socfact := cur_enr.socfact ;
			l_old_typfact := cur_enr.typfact ;
			l_old_datfact := cur_enr.datfact ;
			l_old_numfact := cur_enr.numfact ;

			BEGIN
			   UPDATE	facture
			   SET	fstatut1 = 'EN'
			   WHERE	socfact = cur_enr.socfact
			   AND	typfact = cur_enr.typfact
			   AND	datfact = cur_enr.datfact
			   AND	numfact = cur_enr.numfact;

			   COMMIT;

			EXCEPTION
			   WHEN OTHERS THEN
				--
				--
				--
				null;

			END;
		/* DATE DE COMPTABILISATION = DATE DE SAISIE DE LA FACTURE */
			BEGIN
				SELECT to_char(fdatsai,'YYYYMMDD') into l_facture_date_compta
				FROM facture
				WHERE	socfact = cur_enr.socfact
			       AND	typfact = cur_enr.typfact
			       AND	datfact = cur_enr.datfact
			       AND	numfact = cur_enr.numfact;

			EXCEPTION
				WHEN OTHERS THEN
				null;
     			END;

		/* 18/09/2000: ZONE DCO=H si code compta=6396206 */
		if cur_enr.lcodcompta='6396206' then
			l_ligne_fact_code_dco :='H';

		else
			l_ligne_fact_code_dco :='';
		end if;

		/* 04/10/2000:déconcaténation du code fournisseur sous oracle en codefour et sitefour */
		l_socfour :=RTRIM(LTRIM(cur_enr.fsocfour));
		l_facture_codefour :=LTRIM(SUBSTR(LPAD(l_socfour,10,' '),1,7));
		l_facture_sitefour :=LTRIM(SUBSTR(LPAD(l_socfour,10,' '),8,3));

		/* Test taux de tva pour code de taux de taxe */
		if (cur_enr.tva=19.6 ) then
			l_ligne_fact_code_taux_taxe:='196FG';
		elsif (cur_enr.tva=0) then
   			l_ligne_fact_code_taux_taxe:='0PC';
		elsif (cur_enr.tva=20.6) then
			l_ligne_fact_code_taux_taxe:='206FG';
		end if;

			-- 06/11/2003 SGCIB
			l_champ18 := substr(cur_enr.socfact || cur_enr.numfact || cur_enr.typfact || cur_ligne.fcoduser, 1, l_champ18_tailleMax);

			--
			-- Ecrire l'enreg correspondant a la nouvelle facture
			--
			PACK_GLOBAL.WRITE_STRING( l_hfile,
							  l_facture_type_enreg                              || l_SEPARATEUR ||
							  l_facture_entite_payante                          || l_SEPARATEUR ||
							  l_facture_codefour                                || l_SEPARATEUR ||
 							  l_facture_sitefour              ||l_SEPARATEUR ||      -- site fournisseur
							cur_enr.socfact||cur_enr.numfact||cur_enr.typfact   || l_SEPARATEUR ||
							  to_char(cur_enr.datfact,'YYYYMMDD')      	    || l_SEPARATEUR ||
							  cur_enr.code_justificatif                         || l_SEPARATEUR ||
							  l_facture_id_lot                                  || l_SEPARATEUR ||
							  l_facture_date_compta                             || l_SEPARATEUR ||
							  l_date_creation                                   || l_SEPARATEUR ||
							  to_char(cur_enr.fdate_reglt,'YYYYMMDD')   	    || l_SEPARATEUR ||
							  cur_enr.signe||to_char(cur_enr.fmontttc,'FM999999999990.00')    || l_SEPARATEUR ||
							  cur_enr.monttva                                   || l_SEPARATEUR ||
							  l_regle_fiscale                                   || l_SEPARATEUR ||
							  cur_enr.llibanalyt                                || l_SEPARATEUR ||
							  l_facture_entite_projet                           || l_SEPARATEUR ||
							  l_facture_code_devise                             || l_SEPARATEUR ||
							  -- 06/11/2003 SGCIB
							  --cur_enr.socfact || cur_enr.numfact
							    --              || cur_enr.typfact || cur_ligne.fcoduser  || l_SEPARATEUR
							    l_champ18 || l_SEPARATEUR
							|| l_SEPARATEUR	-- critère de lettrage1
							|| l_SEPARATEUR	-- critère de lettrage2
							|| l_SEPARATEUR   -- motif éco
				                  || l_SEPARATEUR	-- code pays
							|| l_SEPARATEUR	-- zone utilisateur 5
							|| l_SEPARATEUR	-- zone utilisateur 6
							|| l_SEPARATEUR	-- zone utilisateur 7
							|| l_SEPARATEUR ||	-- zone utilisateur 10
							l_filler
							);
		   END IF;

		   --
		   -- Ecrire les enreg correspondants aux lignes de facture
		   --
		  PACK_GLOBAL.WRITE_STRING( l_hfile,
						     l_ligne_fact_type_enreg                             || l_SEPARATEUR ||
						     l_facture_codefour                               || l_SEPARATEUR ||
 						     l_facture_sitefour                 || l_SEPARATEUR ||      -- site fournisseur
						      cur_enr.socfact||cur_enr.numfact||cur_enr.typfact	 || l_SEPARATEUR ||
						     to_char(cur_enr.datfact,'YYYYMMDD')      		   || l_SEPARATEUR ||
						     to_char(cur_enr.lnum,'FM99')                        || l_SEPARATEUR ||
						     cur_enr.signe||to_char(cur_enr.lmontht,'FM999999999990.00')  || l_SEPARATEUR ||
						     cur_enr.llibanalyt                                  || l_SEPARATEUR ||
						     l_ligne_fact_entite_immo                            || l_SEPARATEUR ||
						     l_regle_fiscale                                     || l_SEPARATEUR ||
						     l_ligne_fact_code_taux_taxe                         || l_SEPARATEUR ||
						     l_ligne_fact_code_taxe_recup                        || l_SEPARATEUR ||
						     l_ligne_fact_code_dco                               || l_SEPARATEUR ||
						     cur_enr.lcodcompta                                  || l_SEPARATEUR ||
						     l_ligne_fact_emetteur                               || l_SEPARATEUR ||
						     cur_enr.centractiv                                  || l_SEPARATEUR
							|| l_SEPARATEUR	-- partenaire
							|| l_SEPARATEUR	-- code projet devl
							|| l_SEPARATEUR   -- axe dédié
				                  || l_SEPARATEUR	-- axe libre 1
							|| l_SEPARATEUR	-- axe libre 2
							|| l_SEPARATEUR	-- axe libre 3
							|| l_SEPARATEUR	-- axe libre 4
							|| l_SEPARATEUR	-- identifiant projet
							|| l_SEPARATEUR	-- composant
							|| l_SEPARATEUR   -- numéro d'affaire
				                  || l_SEPARATEUR	-- date début prestation
							|| l_SEPARATEUR	-- date fin prestation
							|| l_SEPARATEUR	-- nomenclature achat
							|| l_SEPARATEUR	-- zone utilisateur 2
							|| l_SEPARATEUR	-- zone utilisateur 6
							|| l_SEPARATEUR	-- zone utilisateur 7
							|| l_SEPARATEUR   -- zone utilisateur 8
				                  || l_SEPARATEUR	-- zone utilisateur 9
							|| l_SEPARATEUR ||	-- zone utilisateur 10
						     l_filler
						   );

		END LOOP;

	-- Fermeture de fichier
   	PACK_GLOBAL.CLOSE_WRITE_FILE(l_hfile);

	l_entete_sum_fmontttc:= 0;
	l_entete_sum_lmontht:= 0;
	l_entete_nb_total_lignes:= 0;
	l_entete_nb_factures:=0;
	l_entete_nb_lignes_fact:= 0 ;

	END LOOP;

/*EXCEPTION
   WHEN NB_FACTURES_FAILED THEN
	pack_global.recuperer_message(20445, null, null, null, l_msg);
	raise_application_error(-20445, l_msg) ;

   WHEN NB_USERS_FAILED THEN
	pack_global.recuperer_message(20448, null, null, null, l_msg);
	raise_application_error(-20448, l_msg) ;

  WHEN OTHERS THEN
	IF UTL_FILE.IS_OPEN(l_hfile) THEN
	   PACK_GLOBAL.CLOSE_WRITE_FILE(l_hfile);
	END IF;
	pack_global.recuperer_message(20401,null,null,null,l_msg);
	raise_application_error(-20401, 'SQLCODE=' || SQLCODE || ' - SQLERRM=' || SQLERRM) ;
*/
END select_export_comptable ;

END pack_export_comptable ;
/





show errors
