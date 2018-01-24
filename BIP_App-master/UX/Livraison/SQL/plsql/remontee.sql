create or replace PACKAGE PACK_REMONTEE AS

STATUT_ERREUR 		NUMBER :=-1;
STATUT_NON_NO_DATA	NUMBER := 0;
STATUT_NON_CONTROLE	NUMBER := 1;
STATUT_CONTROLE_OK	NUMBER := 2;
STATUT_CONTROLE_KO	NUMBER := 3;
STATUT_REMPLACE		NUMBER := 4;
STATUT_CHARGE		NUMBER := 5;
STATUT_SUPPRIME		NUMBER := 6;

PROCEDURE SP_FIND_RETRO(
    P_IDENT IN ARRAY_TABLE,
    P_RETRO_IDENT OUT ARRAY_TABLE);

PROCEDURE GET_ELIGIBLE_OUTSOURCED_DATA (P_LIGNE_BIPS_IN  IN  BIPS_OUTSOUC,                                                                                                                                                          
                                      P_LIGNE_BIPS_OUT OUT BIPS_OUTSOUC);

PROCEDURE get_fichier(		p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
							p_FICHIER_DATA OUT REMONTEE.FICHIER_DATA%TYPE,
							p_STATUT OUT REMONTEE.STATUT%TYPE,
							p_STATUT_DATE OUT REMONTEE.STATUT_DATE%TYPE,
							p_STATUT_INFO OUT REMONTEE.STATUT_INFO%TYPE);



PROCEDURE get_fichier_bips(		p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
							p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE,
							p_STATUT OUT REMONTEE.STATUT%TYPE,
							p_STATUT_DATE OUT REMONTEE.STATUT_DATE%TYPE,
							p_STATUT_INFO OUT REMONTEE.STATUT_INFO%TYPE);



PROCEDURE insert_fichier(	p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
							p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE,
							p_STATUT IN REMONTEE.STATUT%TYPE,
							p_STATUT_INFO IN REMONTEE.STATUT_INFO%TYPE);

PROCEDURE update_fichier(	p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
							p_STATUT IN REMONTEE.STATUT%TYPE,
							p_STATUT_INFO IN REMONTEE.STATUT_INFO%TYPE);

--SEL PPM 60612
PROCEDURE update_fichier_bips(	p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
              p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE,
							p_STATUT IN REMONTEE.STATUT%TYPE,
							p_STATUT_INFO IN REMONTEE.STATUT_INFO%TYPE);

PROCEDURE update_statut(	p_STATUT_IN IN REMONTEE.STATUT%TYPE,
							p_STATUT_OUT IN  REMONTEE.STATUT%TYPE,
							p_STATUT_INFO IN REMONTEE.STATUT_INFO%TYPE);


PROCEDURE remplacer_fichiers(	p_PID IN REMONTEE.PID%TYPE,
								p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,

                p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE
                );

--SEL PPM 60612
PROCEDURE supprimer_fichiers(	p_PID IN REMONTEE.PID%TYPE,
								p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
                p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE
                );

PROCEDURE get_data_fichier(	p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
							p_DATA IN OUT REMONTEE.DATA%TYPE);

--SEL PPM 60612
PROCEDURE get_data_fichier_bips(	p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
              p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE,
							p_DATA IN OUT REMONTEE.DATA%TYPE);

PROCEDURE get_erreur_fichier(	p_PID IN REMONTEE.PID%TYPE,
								p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
								p_ERREUR IN OUT REMONTEE.ERREUR%TYPE);

--SEL PPM 60612
PROCEDURE get_erreur_fichier_bips(	p_PID IN REMONTEE.PID%TYPE,
								p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
                p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE,
								p_ERREUR IN OUT REMONTEE.ERREUR%TYPE);

TYPE remonteeRecType IS RECORD (	PID REMONTEE.PID%TYPE,
									ID_REMONTEUR REMONTEE.ID_REMONTEUR%TYPE,
									FICHIER_DATA REMONTEE.FICHIER_DATA%TYPE,
									STATUT REMONTEE.STATUT%TYPE,
									STATUT_INFO REMONTEE.STATUT_INFO%TYPE,
									STATUT_DATE VARCHAR(32));

TYPE remonteeCurType IS REF CURSOR RETURN remonteeRecType ;

PROCEDURE select_fichiers(	p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
							p_CURSEUR IN OUT remonteeCurType);

PROCEDURE select_fichiers_statut(	p_STATUT IN REMONTEE.STATUT%TYPE,
									p_CURSEUR IN OUT remonteeCurType);



FUNCTION is_number (p_string IN VARCHAR2) RETURN INT;
PROCEDURE check_LigneBipCode(p_pid IN VARCHAR2, p_message OUT VARCHAR2);--PPM 60612
PROCEDURE check_LigneBipCle(p_pid IN VARCHAR2, p_cle IN VARCHAR2, p_message OUT VARCHAR2);
PROCEDURE check_activite(p_pid IN VARCHAR2, p_etape IN VARCHAR2, p_tache IN VARCHAR2, p_sous_tache IN VARCHAR2, p_message OUT VARCHAR2);
PROCEDURE check_EtapeType(p_pid IN VARCHAR2, p_activite IN VARCHAR2,p_typetape IN VARCHAR2,p_structureAction IN VARCHAR2, p_message OUT VARCHAR2);
PROCEDURE check_StructSR (p_pid IN LIGNE_BIP.pid%TYPE, p_message OUT VARCHAR2);
PROCEDURE check_StacheType (p_pid IN VARCHAR2, p_stacheType IN VARCHAR2, p_message OUT VARCHAR2);
PROCEDURE check_RessBipCode (p_ident IN VARCHAR2, p_dateDebConso IN VARCHAR2, p_dateFinConso IN VARCHAR2, p_message OUT VARCHAR2);
PROCEDURE check_RessBipNom (p_ident IN VARCHAR2, p_ressNom IN VARCHAR2, p_message OUT VARCHAR2);

PROCEDURE check_StacheInitDebDate (p_pid IN LIGNE_BIP.pid%TYPE, p_date IN VARCHAR2, p_message OUT VARCHAR2);
PROCEDURE check_StacheInitFinDate (p_pid IN LIGNE_BIP.pid%TYPE, p_date IN VARCHAR2, p_message OUT VARCHAR2);
PROCEDURE check_StacheRevDebDate (p_pid IN LIGNE_BIP.pid%TYPE, p_date IN VARCHAR2, p_message OUT VARCHAR2);
PROCEDURE check_StacheRevFinDate (p_pid IN LIGNE_BIP.pid%TYPE, p_date IN VARCHAR2, p_message OUT VARCHAR2);

PROCEDURE check_ConsoDebDate(p_ident IN VARCHAR2, p_dateDebConso IN VARCHAR2, p_message OUT VARCHAR2);
PROCEDURE check_ConsoFinDate(p_ident IN VARCHAR2, p_dateFinConso IN VARCHAR2, p_message OUT VARCHAR2);
PROCEDURE isLigneProductive (p_pid IN VARCHAR2, p_result OUT VARCHAR2);
PROCEDURE isPeriodeAnterieureAnneeFonct(p_dateDebConso IN VARCHAR2, p_result OUT VARCHAR2);
PROCEDURE isPeriodeUlterieureMoisFonct(p_dateDebConso IN VARCHAR2, p_pid IN VARCHAR2, p_result OUT VARCHAR2);

--SEL PPM 62605
PROCEDURE isPeriodeUlterieureAnneeFonct(p_dateDebConso IN VARCHAR2, p_pid IN VARCHAR2, p_result OUT VARCHAR2);


--SEL PPM 60709 5.4
PROCEDURE check_EtapeType_No(p_pid IN VARCHAR2,p_message OUT VARCHAR2);


FUNCTION check_EtapeType_f(p_pid IN VARCHAR2, p_activite IN VARCHAR2,p_typetape IN VARCHAR2,p_structureAction IN VARCHAR2) RETURN VARCHAR2;

FUNCTION check_TacheAxeMetier(p_pid IN isac_tache.pid%TYPE,p_tacheaxemetier IN ISAC_TACHE.tacheaxemetier%TYPE) RETURN VARCHAR2;

--SEL 1811
PROCEDURE VERIFIER_TACHE_AXE_METIER_BIPS ( p_tacheaxemetier IN ISAC_TACHE.tacheaxemetier%TYPE,
                                      p_pid   IN  isac_tache.pid%TYPE,
                                      p_type OUT VARCHAR2,
                                      p_nb_rejet OUT VARCHAR2);

-- FAD PPM 64368 : Purge de la table temporaire
PROCEDURE PURGE_CONSO_TMP (sNUMSEQ IN NUMBER);

-- FAD PPM 64368 : Récupération d'un id unique pour le traitement en cours
PROCEDURE GET_NUM_SEQ(sNUMSEQ OUT NUMBER);

-- FAD PPM 64368 : Insertion de la ligne en cours dans une table temporaire
PROCEDURE INSERT_CONSO_TMP (vNUMSEQ IN TMP_PMW_BIPS.NUMSEQ%TYPE,
	vLIGNEBIPCODE IN TMP_PMW_BIPS.LIGNEBIPCODE%TYPE,
	vSTRUCTUREACTION IN TMP_PMW_BIPS.STRUCTUREACTION%TYPE,
	vETAPENUM IN TMP_PMW_BIPS.ETAPENUM%TYPE,
	vTACHENUM IN TMP_PMW_BIPS.TACHENUM%TYPE,
	vSTACHENUM IN TMP_PMW_BIPS.STACHENUM%TYPE,
	vCONSODEBDATE IN TMP_PMW_BIPS.CONSODEBDATE%TYPE,
	vCONSOFINDATE IN TMP_PMW_BIPS.CONSOFINDATE%TYPE,
	vRESSBIPCODE IN TMP_PMW_BIPS.RESSBIPCODE%TYPE,
	vCONSOQTE IN TMP_PMW_BIPS.CONSOQTE%TYPE,
	RETOUR OUT VARCHAR2);

-- FAD PPM 64368 : Procédures stockées pour verifier le consommé du mois et de l'année d'une ligne BIP
PROCEDURE CONSO_MOIS_OK (vNUMSEQ IN TMP_PMW_BIPS.NUMSEQ%TYPE,
	vLIGNEBIPCODE IN TMP_PMW_BIPS.LIGNEBIPCODE%TYPE,
	vSTRUCTUREACTION IN TMP_PMW_BIPS.STRUCTUREACTION%TYPE,
	vETAPENUM IN TMP_PMW_BIPS.ETAPENUM%TYPE,
	vTACHENUM IN TMP_PMW_BIPS.TACHENUM%TYPE,
	vSTACHENUM IN TMP_PMW_BIPS.STACHENUM%TYPE,
	vCONSODEBDATE IN TMP_PMW_BIPS.CONSODEBDATE%TYPE,
	vCONSOFINDATE IN TMP_PMW_BIPS.CONSOFINDATE%TYPE,
	vRESSBIPCODE IN TMP_PMW_BIPS.RESSBIPCODE%TYPE,
	vCONSOQTE IN TMP_PMW_BIPS.CONSOQTE%TYPE,
	RETOUR OUT VARCHAR2);
PROCEDURE CONSO_ANNEE_OK (vNUMSEQ IN TMP_PMW_BIPS.NUMSEQ%TYPE,
	vLIGNEBIPCODE IN TMP_PMW_BIPS.LIGNEBIPCODE%TYPE,
	vSTRUCTUREACTION IN TMP_PMW_BIPS.STRUCTUREACTION%TYPE,
	vETAPENUM IN TMP_PMW_BIPS.ETAPENUM%TYPE,
	vTACHENUM IN TMP_PMW_BIPS.TACHENUM%TYPE,
	vSTACHENUM IN TMP_PMW_BIPS.STACHENUM%TYPE,
	vCONSODEBDATE IN TMP_PMW_BIPS.CONSODEBDATE%TYPE,
	vCONSOFINDATE IN TMP_PMW_BIPS.CONSOFINDATE%TYPE,
	vRESSBIPCODE IN TMP_PMW_BIPS.RESSBIPCODE%TYPE,
	vCONSOQTE IN TMP_PMW_BIPS.CONSOQTE%TYPE,
	RETOUR OUT VARCHAR2);
-- FAD PPM 64368 : Fin



--DHA Optimization BIPS 
 PROCEDURE check_StructsSR (id_lignes_bip_in  IN  ARRAY_TABLE,                                                                                
                           id_ligne_bip_out OUT ARRAY_TABLE );                          
                           
PROCEDURE find_id_lignes_bip_valides(id_lignes_bip_in  IN  ARRAY_TABLE,                                                                                
                                     id_lignes_bip  OUT ARRAY_TABLE,
                                     dates_statut OUT ARRAY_DATE,
                                     types_projet OUT ARRAY_TABLE);   
--DHA

END PACK_REMONTEE;
/

create or replace PACKAGE BODY PACK_REMONTEE AS

PROCEDURE SP_FIND_RETRO(
    P_IDENT IN ARRAY_TABLE,
    P_RETRO_IDENT OUT ARRAY_TABLE)
IS
  L_VALEUR    VARCHAR2(400);
  L_RETRO_IND VARCHAR2(1):= 'Y';
  ID_K        NUMBER     := 1;
BEGIN
P_RETRO_IDENT := ARRAY_TABLE();
  BEGIN
    SELECT NVL(LISTAGG(LPB.VALEUR,',') WITHIN GROUP(
    ORDER BY LPB.VALEUR), ' ')
    INTO L_VALEUR
    FROM ligne_param_bip LPB
    WHERE LPB.code_action = 'LIMITATION-RETROACT'
    AND LPB.CODE_VERSION  = 'DEFAUT'
    AND LPB.actif         = 'O';
    
    IF L_VALEUR           = ' ' OR L_VALEUR IS NULL THEN
      NULL;
    ELSE
    
      FOR I IN P_IDENT.FIRST .. P_IDENT.LAST
      LOOP
      
      BEGIN
        SELECT RETRO_FLAG INTO L_RETRO_IND FROM(SELECT
          CASE
            WHEN INSTR(L_VALEUR,SI.CODDIR) >= 1
            THEN 'Y'
            ELSE 'N'
          END RETRO_FLAG
        FROM RESSOURCE R,
          SITU_RESS SITU,
          DATDEBEX D,
          STRUCT_INFO SI
        WHERE SITU.IDENT  = R.IDENT
        AND SITU.IDENT    = TRIM(P_IDENT(I))
        AND SITU.CODSG    = SI.CODSG
        AND 
        --(SITU.DATDEP IS NULL
       -- OR (
        D.MOISMENS BETWEEN SITU.DATSITU AND (NVL(SITU.DATDEP, TRUNC(SYSDATE))) ORDER BY SITU.DATSITU) WHERE ROWNUM = 1;
       EXCEPTION
       WHEN OTHERS THEN
        L_RETRO_IND := 'Y';
       END; 
        IF L_RETRO_IND = 'Y' THEN
          P_RETRO_IDENT.EXTEND;
          P_RETRO_IDENT(ID_K) := trim(P_IDENT(I));
          ID_K                := ID_K+1;
        END IF;
      END LOOP;
      
    END IF;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
  END;
EXCEPTION
WHEN OTHERS THEN
  RAISE;
END SP_FIND_RETRO;

PROCEDURE GET_ELIGIBLE_OUTSOURCED_DATA (P_LIGNE_BIPS_IN  IN  BIPS_OUTSOUC,                                                                                                                                                          
                                      P_LIGNE_BIPS_OUT OUT BIPS_OUTSOUC)
IS
BIPS_OUTSOUC_REC_TYPE BIPS_OUTSOUC_REC;
L_SOUS_TACHE ARRAY_TABLE;
L_SOUS_TACHE_OUT ARRAY_TABLE;
L_OUT_SRC_IND VARCHAR2(1) := 'N';
ID_K number;
ID_L number;


BEGIN
L_SOUS_TACHE_OUT := ARRAY_TABLE();
P_LIGNE_BIPS_OUT := BIPS_OUTSOUC();
--P_LIGNE_BIPS_OUT.EXTEND(P_LIGNE_BIPS_IN.COUNT);

ID_L := 1;
FOR I IN P_LIGNE_BIPS_IN.FIRST .. P_LIGNE_BIPS_IN.LAST
LOOP
  BIPS_OUTSOUC_REC_TYPE := P_LIGNE_BIPS_IN(I);
  
  L_SOUS_TACHE := BIPS_OUTSOUC_REC_TYPE.P_SOUS_TACHE_ID;
  
  ID_K := 1;
  FOR J IN L_SOUS_TACHE.FIRST .. L_SOUS_TACHE.LAST
  LOOP
    BEGIN
      SELECT
        CASE
              WHEN L_SOUS_TACHE(J) LIKE 'FF%'
              THEN 
                CASE
                 WHEN '7' = (SELECT TYPPROJ FROM LIGNE_BIP WHERE PID = SUBSTR(L_SOUS_TACHE(J),'3')) THEN
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
        INTO L_OUT_SRC_IND
      FROM LIGNE_BIP L
      WHERE L.PID = BIPS_OUTSOUC_REC_TYPE.P_PID;
     EXCEPTION
     WHEN OTHERS THEN
     L_OUT_SRC_IND := 'N';
     END; 
     
     IF L_OUT_SRC_IND = 'Y' THEN    
    L_SOUS_TACHE_OUT.EXTEND;
     L_SOUS_TACHE_OUT(ID_K) := L_SOUS_TACHE(J);
     ID_K := ID_K+1;
     END IF;   
  END LOOP;
  
  IF L_SOUS_TACHE_OUT IS NOT NULL THEN
  P_LIGNE_BIPS_OUT.EXTEND(1);
  P_LIGNE_BIPS_OUT(ID_L) := BIPS_OUTSOUC_REC(BIPS_OUTSOUC_REC_TYPE.P_PID,L_SOUS_TACHE_OUT);
  ID_L :=   ID_L+1;
  L_SOUS_TACHE_OUT.DELETE;
  END IF;
END LOOP;

--  EXCEPTION
--  WHEN OTHERS THEN
--  RAISE;
END GET_ELIGIBLE_OUTSOURCED_DATA;

PROCEDURE get_fichier(	p_PID IN REMONTEE.PID%TYPE,
						p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
						p_FICHIER_DATA OUT REMONTEE.FICHIER_DATA%TYPE,
						p_STATUT OUT REMONTEE.STATUT%TYPE,
						p_STATUT_DATE OUT REMONTEE.STATUT_DATE%TYPE,
						p_STATUT_INFO OUT REMONTEE.STATUT_INFO%TYPE)
IS
BEGIN
	SELECT
		FICHIER_DATA, STATUT, STATUT_DATE, STATUT_INFO
	INTO
		p_FICHIER_DATA, p_STATUT, p_STATUT_DATE, p_STATUT_INFO
	FROM
		REMONTEE
	WHERE
		PID = p_PID
	AND	ID_REMONTEUR = p_ID_REMONTEUR;


END get_fichier;

PROCEDURE get_fichier_bips(	p_PID IN REMONTEE.PID%TYPE,
						p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
						p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE,
						p_STATUT OUT REMONTEE.STATUT%TYPE,
						p_STATUT_DATE OUT REMONTEE.STATUT_DATE%TYPE,
						p_STATUT_INFO OUT REMONTEE.STATUT_INFO%TYPE)
IS
BEGIN
	SELECT
		STATUT, STATUT_DATE, STATUT_INFO
	INTO
		p_STATUT, p_STATUT_DATE, p_STATUT_INFO
	FROM
		REMONTEE
	WHERE
		PID = p_PID
	AND	ID_REMONTEUR = p_ID_REMONTEUR
  AND fichier_data = p_fichier_data;

END get_fichier_bips;

--
-- si un autre utilisateur a deja remonte un fichier pour ce PID pour le traitement a venir, celui-ci passe en statut 'remplace'
-- seul le fichier remonte en dernier est pris en compte
PROCEDURE remplacer_fichiers(	p_PID IN REMONTEE.PID%TYPE,
								p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
                p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE)

IS

extension VARCHAR2(5);

BEGIN



  --SEL PPM 60612
  SELECT substr(p_FICHIER_DATA,length(p_FICHIER_DATA)-3,4) into extension from dual;


  IF (extension = 'bips' or extension = 'BIPS') THEN


    update
		REMONTEE

  	SET
    STATUT = STATUT_REMPLACE,
		STATUT_DATE = sysdate,
		STATUT_INFO = p_ID_REMONTEUR
    WHERE
		PID = p_PID
    AND STATUT NOT IN (STATUT_CHARGE, STATUT_REMPLACE)
   AND FICHIER_DATA = p_FICHIER_DATA;


  ELSE


    update
		REMONTEE
    SET
		STATUT = STATUT_REMPLACE,
		STATUT_DATE = sysdate,
		STATUT_INFO = p_ID_REMONTEUR
    WHERE
		PID = p_PID
    AND STATUT NOT IN (STATUT_CHARGE, STATUT_REMPLACE);



  END IF;

END remplacer_fichiers;

PROCEDURE supprimer_fichiers (	p_PID IN REMONTEE.PID%TYPE,
								p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
                p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE)
IS
extension VARCHAR2(5);
BEGIN

 SELECT substr(p_FICHIER_DATA,length(p_FICHIER_DATA)-3,4) into extension from dual;


  IF (extension = 'bips' or extension = 'BIPS') THEN

    delete
		REMONTEE
    where
		PID = p_PID
    and ID_REMONTEUR = p_ID_REMONTEUR
    and fichier_data = p_fichier_data;


  ELSE


     delete
		REMONTEE
    where
		PID = p_PID
    and ID_REMONTEUR = p_ID_REMONTEUR;


  END IF;



END supprimer_fichiers;

PROCEDURE insert_fichier(	p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
							p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE,
							p_STATUT IN REMONTEE.STATUT%TYPE,
							p_STATUT_INFO IN REMONTEE.STATUT_INFO%TYPE)
IS
BEGIN

	-- si il y a deja un fichier avec ce PID qui a ete remonte : on le passe a 'remplacé'
	remplacer_fichiers(p_PID, p_ID_REMONTEUR, p_fichier_data);


	-- si le remonteur a deja remonte sur ce PID, on supprime sa ligne pour en recreer une nouvelle



	supprimer_fichiers(p_PID, p_ID_REMONTEUR, p_fichier_data);



	-- on cree la nouvelle ligne
	insert into
		REMONTEE(PID, ID_REMONTEUR, FICHIER_DATA, DATA, ERREUR, STATUT, STATUT_DATE, STATUT_INFO)
	VALUES(p_PID, p_ID_REMONTEUR, p_FICHIER_DATA, empty_clob(), empty_clob, p_STATUT, sysdate, p_STATUT_INFO);
END insert_fichier;

PROCEDURE update_fichier(	p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
							p_STATUT IN REMONTEE.STATUT%TYPE,
							p_STATUT_INFO IN REMONTEE.STATUT_INFO%TYPE)
IS
BEGIN
	update
		REMONTEE
	SET
		STATUT = p_STATUT,
		STATUT_INFO = p_STATUT_INFO,
		STATUT_DATE = sysdate
	WHERE
		PID = p_PID
	AND ID_REMONTEUR = p_ID_REMONTEUR;
END update_fichier;

--SEL PPM 60612
PROCEDURE update_fichier_bips(	p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
              p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE,
							p_STATUT IN REMONTEE.STATUT%TYPE,
							p_STATUT_INFO IN REMONTEE.STATUT_INFO%TYPE)
IS
BEGIN
	update
		REMONTEE
	SET
		STATUT = p_STATUT,
		STATUT_INFO = p_STATUT_INFO,
		STATUT_DATE = sysdate
	WHERE
		PID = p_PID
	AND ID_REMONTEUR = p_ID_REMONTEUR
  AND FICHIER_DATA = p_fichier_data;
END update_fichier_bips;

PROCEDURE select_fichiers(	p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
							p_CURSEUR IN OUT remonteeCurType )
IS
BEGIN

	OPEN p_CURSEUR FOR
	SELECT
		PID,
		ID_REMONTEUR,
		FICHIER_DATA,
		STATUT,
		nvl(STATUT_INFO, ' '),
		to_char(STATUT_DATE, 'DD/MM/YYYY HH24:MI')
	FROM
		REMONTEE
	WHERE
		ID_REMONTEUR = p_ID_REMONTEUR
	--AND	STATUT <> STATUT_SUPPRIME
	ORDER BY PID ASC;

END select_fichiers;



PROCEDURE get_data_fichier(	p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
							p_DATA IN OUT REMONTEE.DATA%TYPE)
IS
BEGIN
	SELECT DATA INTO p_DATA
	FROM REMONTEE
	WHERE PID = p_PID
	AND ID_REMONTEUR = p_ID_REMONTEUR;
END get_data_fichier;

--SEL PPM 60612
PROCEDURE get_data_fichier_bips(	p_PID IN REMONTEE.PID%TYPE,
							p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
              p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE,
							p_DATA IN OUT REMONTEE.DATA%TYPE)
IS
BEGIN
	SELECT DATA INTO p_DATA
	FROM REMONTEE
	WHERE PID = p_PID
	AND ID_REMONTEUR = p_ID_REMONTEUR
  AND fichier_data = p_FICHIER_DATA;
END get_data_fichier_bips;

PROCEDURE get_erreur_fichier(	p_PID IN REMONTEE.PID%TYPE,
								p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
								p_ERREUR IN OUT REMONTEE.ERREUR%TYPE)
IS
BEGIN
	SELECT ERREUR INTO p_ERREUR
	FROM REMONTEE
	WHERE PID = p_PID
	AND ID_REMONTEUR = p_ID_REMONTEUR;
END get_erreur_fichier;

--SEL PPM 60612
PROCEDURE get_erreur_fichier_bips(	p_PID IN REMONTEE.PID%TYPE,
								p_ID_REMONTEUR IN REMONTEE.ID_REMONTEUR%TYPE,
                p_FICHIER_DATA IN REMONTEE.FICHIER_DATA%TYPE,
								p_ERREUR IN OUT REMONTEE.ERREUR%TYPE)
IS
BEGIN
	SELECT ERREUR INTO p_ERREUR
	FROM REMONTEE
	WHERE PID = p_PID
	AND ID_REMONTEUR = p_ID_REMONTEUR
  AND fichier_data = p_fichier_data ;
END get_erreur_fichier_bips;

PROCEDURE select_fichiers_statut(	p_STATUT IN REMONTEE.STATUT%TYPE,
									p_CURSEUR IN OUT remonteeCurType)
IS
BEGIN
	OPEN p_CURSEUR FOR
	SELECT
		PID,
		ID_REMONTEUR,
		FICHIER_DATA,
		STATUT,
		nvl(STATUT_INFO, ' '),
		to_char(STATUT_DATE, 'DD/MM/YYYY HH24:MI')
	FROM
		REMONTEE
	WHERE (
		STATUT = p_STATUT
    OR
    STATUT = 22 --SEL 60709 5.4 : prise en compte des warnings BIP
    )
	ORDER BY PID ASC;

END select_fichiers_statut;

PROCEDURE update_statut(p_STATUT_IN IN REMONTEE.STATUT%TYPE,
						p_STATUT_OUT IN REMONTEE.STATUT%TYPE,
						p_STATUT_INFO IN REMONTEE.STATUT_INFO%TYPE)
IS
BEGIN
	UPDATE
		REMONTEE
	SET
		STATUT = p_STATUT_OUT,
		STATUT_INFO = p_STATUT_INFO,
		STATUT_DATE = sysdate
	WHERE
		STATUT = p_STATUT_IN;

END update_statut;



--PPM 60612
PROCEDURE check_LigneBipCode(p_pid IN VARCHAR2, p_message   OUT VARCHAR2)  IS

l_pid LIGNE_BIP.pid%TYPE;
l_mois_fonct date;
BEGIN
 select cmensuelle into l_mois_fonct from datdebex;
  
p_message := ''; --initialisation
      BEGIN
          SELECT lb.pid INTO l_pid
          FROM ligne_bip lb
          WHERE lb.pid = p_pid
          AND (length(p_pid) = 3 OR length(p_pid) = 4)
          --SEL PPM 60612 QC 1727
          --AND (lb.adatestatut IS NULL OR lb.adatestatut >= to_date('01'||to_char(sysdate,'/MM/YYYY') )  ) -- lignes actives(date statut vide ou >= mois fonctionnel en cours)
          AND (lb.adatestatut IS NULL OR lb.adatestatut >=  to_date('01/'||TO_CHAR(l_mois_fonct,'MM/YYYY'))  ) --QC 1772
                  
          --AND rownum < 2
          ;

           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_message := 'REJET';-- 'REJET GLOBAL pour la ligne Bip ' || p_code || ' car elle est inexistante ou fermée';
              WHEN OTHERS THEN
                  p_message := 'REJET';
                 raise_application_error(-20997, SQLERRM);
           END;



END check_LigneBipCode;

--La clé en paramètre doit correspondre à la clé de la ligne, sinon rejet.
PROCEDURE check_LigneBipCle(p_pid IN VARCHAR2, p_cle IN VARCHAR2, p_message OUT VARCHAR2) IS
l_cle LIGNE_BIP.pcle%TYPE;

BEGIN
p_message := ''; --initialisation
l_cle := null;
      BEGIN
          SELECT pcle INTO l_cle
          FROM ligne_bip
          WHERE pid = p_pid
          AND rownum < 2;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_message := 'REJET';
      END;
  IF l_cle is null OR l_cle <> p_cle THEN
    p_message := 'REJET';--'REJET pour la ligne '|| p_code ||', ressource '||l_ress||', activité '||l_activite||' et début de période consommée '||l_datdebconso||' : la clé est non conforme';
  END IF;

END check_LigneBipCle;

PROCEDURE check_activite(p_pid IN VARCHAR2, p_etape IN VARCHAR2, p_tache IN VARCHAR2, p_sous_tache IN VARCHAR2, p_message OUT VARCHAR2) IS

l_pid LIGNE_BIP.pid%TYPE;
l_etape ISAC_ETAPE.ECET%TYPE;
l_tache ISAC_TACHE.ACTA%TYPE;
l_sous_tache ISAC_SOUS_TACHE.ACST%TYPE;

BEGIN
p_message := ''; --initialisation
        BEGIN
          select lb.pid,ie.ECET,it.ACTA,ist.ACST INTO  l_pid, l_etape, l_tache, l_sous_tache
          from ligne_bip lb, isac_etape ie, isac_tache it, isac_sous_tache ist
          where

          lb.pid = ie.pid and
          ie.etape = it.etape and
          it.tache = ist.tache and
          lb.pid = p_pid and
          ie.ECET = p_etape and
          it.ACTA = p_tache and
          ist.ACST = p_sous_tache
          AND rownum < 2;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN -- activité en P2 - pas de SR directe
              p_message := 'REJET';
              
             --Verifier pour le P2 c'est l'activité existe deja en referentiel BIPS_ACTIVITE 
             PACK_BATCH_BIPS.VERIF_SR_P2(p_pid,p_etape,p_tache,p_sous_tache,p_message);
             
             IF(p_message = 'N') THEN
             
              p_message := 'REJET';
              
              ELSE 
              
              p_message := '';
                          
             END IF;
              
                 
      END;
END check_activite;


PROCEDURE check_EtapeType (p_pid IN VARCHAR2,p_activite IN VARCHAR2, p_typetape IN VARCHAR2, p_structureAction IN VARCHAR2, p_message OUT VARCHAR2)
   IS
      l_typproj    NUMBER;
      l_liste VARCHAR2(6000);
      l_liste_jeu VARCHAR2(6000) :='';
      l_jeu_prio VARCHAR2(30);
      t_table     PACK_UTILE.t_array;
      l_exist boolean;
      p_userid VARCHAR2(30);
      l_message_sr VARCHAR2(30);
      l_count_activite NUMBER;
      l_param_jeu VARCHAR2(400);
      l_param_jeu_prio VARCHAR2(10);
      array_param_jeu PACK_UTILE.t_array;
      array_gauche_jeu PACK_UTILE.t_array;
      array_type_jeu PACK_UTILE.t_array;
      l_type_etape VARCHAR2(30);
      l_activite_sr VARCHAR2(30);
      
      --5.4
      l_valeu_jeux_t VARCHAR2(300);
      l_typo_p VARCHAR2(6);
      l_typo_s VARCHAR2(6);
      t_table_typo     PACK_UTILE.t_array;
      l_is_concerne boolean := false;
      l_jeu_compa VARCHAR2(300):='';
      
   BEGIN
   l_exist := false;
   p_userid := null;


   -- Vérifier le type de projet
      BEGIN
      SELECT TO_NUMBER (typproj)
        INTO l_typproj
        FROM ligne_bip
       WHERE pid = p_pid;
             EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_message := 'REJET';

      END;

      -- *** La ligne BIP est non productive ***
      IF (l_typproj = 7) THEN

          IF ( p_typetape <> 'ES')  THEN

            p_message := 'REJET';
            
            ELSE
            
              p_message := 'ES';
            

          END IF;

      -- *** La ligne BIP est productive ***
      ELSE
      
       --SEL PPM 60709 5.4
               /*
               On regarde si le type etape NO est autorisé ou non selon :
               1-le param applicatif TYPETAPES-JEUX-T
               ET
               2-la typologie de la ligne BIP
               */
       IF(trim(upper(p_typetape)) = 'NO') THEN
      
          check_EtapeType_No(p_pid,p_message);

       ELSE
       
       BEGIN
       
       SELECT lpb.VALEUR INTO l_param_jeu
                            FROM  struct_info inf,
                                  ligne_bip lig,
                                  LIGNE_PARAM_BIP lpb
                            WHERE inf.CODSG = lig.CODSG
                            AND lpb.CODE_VERSION = to_char(inf.CODDIR)
                            AND lpb.CODE_ACTION = 'TYPETAPES-JEUX'
                            AND lpb.ACTIF = 'O'
                            AND lig.PID = TRIM(p_pid);


        EXCEPTION
        WHEN NO_DATA_FOUND THEN


            BEGIN
            
            SELECT lpb.VALEUR INTO l_param_jeu
            FROM LIGNE_PARAM_BIP lpb
            WHERE lpb.CODE_ACTION  = 'TYPETAPES-JEUX'
            AND lpb.CODE_VERSION = 'DEFAUT'
            AND lpb.ACTIF = 'O';

        
            EXCEPTION --SEL PPM 60709 5.5
            WHEN NO_DATA_FOUND THEN
            --dbms_output.put_line( 'DEFAUT not found' );
            return; --sortir de la procedure et ne faire aucun controle
            
            END;

        END;


      --Les jeux en PARAMETRE selon la direction de la ligne BIP
      array_param_jeu := PACK_UTILE.split(l_param_jeu,',');


       --dbms_output.put_line('Mode modification');

      --Constitution de la liste des jeux auxquels appartient le type etape

      /*Test de compatibilité*/
       
       for i in (select * from type_etape where typetap = trim(p_typetape)) loop


       
       IF (PACK_ISAC_ETAPE.verifTypologieTypeEtape(p_pid,i.typeligne) like 'valide') THEN
       
       l_liste_jeu := l_liste_jeu||','||i.jeu;


  
       END IF;
       
       end loop;

       --dbms_output.put_line('p_activite = ' || p_activite);
       --dbms_output.put_line(p_typetape || ' in { '|| l_liste_jeu||' }' );

    IF (l_liste_jeu IS NOT NULL) THEN

    check_StructSR(p_pid,l_message_sr);
    
    IF (trim(upper(l_message_sr)) like 'REJET') THEN
      l_message_sr := 'P2';
    ELSE
      l_message_sr := 'P3';
    END IF;
    
     --dbms_output.put_line('priorite = ' || l_message_sr);
    BEGIN
    
    IF (l_message_sr = 'P3') THEN
    
       select distinct e.typetape into l_type_etape from isac_etape e,isac_tache t, isac_sous_tache s
      where
      e.pid=p_pid
      and e.pid=t.pid
      and t.pid=s.pid
      and t.etape= e.etape
      and s.tache= t.tache
      and e.ecet||t.acta||s.acst = p_activite
      /*
      and e.ecet = P_ETAPENUM
      and t.acta = P_TACHENUM
      and s.acst = P_STACHENUM*/
         ORDER BY e.pid ;
          
         --dbms_output.put_line( '---> ISAC' );
   
    ELSE
    
       select distinct bips.etapetype into l_type_etape from bips_activite bips
      where
      bips.lignebipcode = p_pid
      and bips.etapenum||bips.tachenum||bips.stachenum = p_activite
      /*
      and e.ecet = P_ETAPENUM
      and t.acta = P_TACHENUM
      and s.acst = P_STACHENUM*/
         ORDER BY bips.lignebipcode ;
         
         --dbms_output.put_line( '---> bips_activite' );
    
    END IF;

    
     IF (p_structureAction = 'LA') THEN
       RAISE NO_DATA_FOUND;
       END IF;

      /*
                 Si on est en mode mise à jour
                      Si on est en LE OU en AE ou en AF et l'activité existe
      */

       IF (p_structureAction = 'LE' OR p_structureAction = 'AF' OR p_structureAction = 'AE') THEN
        
                    --dbms_output.put_line('l_param_jeu = ' || l_param_jeu);

                    FOR I IN 1..array_param_jeu.count LOOP

                          IF (INSTR(l_liste_jeu,array_param_jeu(I)) > 0) THEN
                           p_message := array_param_jeu(I);
                           exit;

                           ELSE
                           p_message := 'REJET';
                          END IF;

                    END LOOP;
        

       END IF;

       
       IF (p_structureAction = 'LA') THEN
       RAISE NO_DATA_FOUND;
       END IF;

       EXCEPTION
       WHEN NO_DATA_FOUND THEN
       --dbms_output.put_line('Mode creation');
                 /*
                 Si on est en mode création
                     Si on est en LA : Annule et remplce
                     OU
                     on est en AF et l'activité n'existe pas
                 */
                  --Le jeu prioritaire pour cette direction
                 l_param_jeu_prio := array_param_jeu(1);
                 --dbms_output.put_line('l_liste_jeu '||l_liste_jeu);
                 --dbms_output.put_line('l_param_jeu_prio '||l_param_jeu_prio);


                 IF (p_structureAction = 'LA' OR p_structureAction = 'AF' ) THEN


                   IF (INSTR (l_liste_jeu,l_param_jeu_prio) > 0 ) THEN

                   p_message := l_param_jeu_prio;


                   ELSE


                   p_message := 'REJET';


                   END IF;


               END IF;


           END;
           ELSE
            p_message := 'REJET';
           END IF;

      END IF;

   END IF;


END check_EtapeType;

FUNCTION check_EtapeType_f(p_pid IN VARCHAR2, p_activite IN VARCHAR2,p_typetape IN VARCHAR2,p_structureAction IN VARCHAR2) RETURN VARCHAR2

IS

l_retour VARCHAR2(10);

BEGIN

check_EtapeType(p_pid,p_activite,p_typetape,p_structureAction,l_retour);

RETURN l_retour;

END check_EtapeType_f;

FUNCTION check_TacheAxeMetier(p_pid IN isac_tache.pid%TYPE,p_tacheaxemetier IN ISAC_TACHE.tacheaxemetier%TYPE) RETURN VARCHAR2 IS


l_message VARCHAR2(200);
l_type VARCHAR2(20);
l_param_id VARCHAR2(20);
BEGIN

PACK_ISAC_TACHE.VERIFIER_TACHE_AXE_METIER ( p_tacheaxemetier,
                                      p_pid   ,
                                      l_message,
                                      l_type,
                                      l_param_id);
                                      
RETURN l_type;
 
END check_TacheAxeMetier;


PROCEDURE check_StructSR (p_pid IN LIGNE_BIP.pid%TYPE, p_message OUT VARCHAR2)
   IS
      l_sous_tache    ISAC_SOUS_TACHE.SOUS_TACHE%TYPE;
   BEGIN
      -- si la ligne a une struture SR
      BEGIN
      SELECT SOUS_TACHE
        INTO l_sous_tache
        FROM ISAC_SOUS_TACHE
        WHERE pid = p_pid
        AND rownum < 2;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_message := 'REJET';
        END;
END check_StructSR;



--------

PROCEDURE check_StacheType (p_pid IN VARCHAR2, p_stacheType IN VARCHAR2, p_message OUT VARCHAR2)
   IS
   l_typproj    NUMBER;
   l_pidImp VARCHAR2(4);
   BEGIN
   p_message := ''; --initialisation
   l_pidImp := '';


         -- Vérifier le type de projet
    BEGIN
      SELECT TO_NUMBER (typproj)
        INTO l_typproj
        FROM ligne_bip
       WHERE pid = p_pid;
             EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_message := 'REJET';


       END;

      --SI ligne productive : vide ou FFxxxx
       IF l_typproj != 7
       THEN
          IF INSTR(p_stacheType,'FF') = 1  THEN






            l_pidImp := substr(p_stacheType,3);
            check_LigneBipCode(l_pidImp,p_message);

          ELSE
            --PPM 60612 : QC 1712
            IF (p_stacheType <> '' OR p_stacheType IS NOT NULL) THEN
            p_message := 'REJET_PRO_INCONNU';

            END IF;

          END IF;
       --Ligne non productive (Projet de type ABSENCE)

       ELSE
          IF p_stacheType not in ('CONGES','ABSDIV','MOBILI','CLUBUT','FORFAC','ACCUEI',
            'FORMAT','SEMINA','INTEGR','FORHUM','FOREAO','FORINF',
            'FOREXT','FORINT','COLOQU','RTT','PARTIE','DEMENA')
          THEN
          p_message := 'REJET_ABSENCE';


          END IF;
       END IF;
END check_StacheType;


PROCEDURE check_StacheInitDebDate (p_pid IN LIGNE_BIP.pid%TYPE, p_date IN VARCHAR2, p_message OUT VARCHAR2)
   IS
      l_sous_tache    ISAC_SOUS_TACHE.SOUS_TACHE%TYPE;
   BEGIN
      -- on vérifie si la date initiale de début existe
      BEGIN
      SELECT SOUS_TACHE
        INTO l_sous_tache
        FROM ISAC_SOUS_TACHE
        WHERE pid = p_pid
        AND ADEB = to_date(p_date)
        AND rownum < 2;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_message := 'REJET';
        END;
END check_StacheInitDebDate;

PROCEDURE check_StacheInitFinDate (p_pid IN LIGNE_BIP.pid%TYPE, p_date IN VARCHAR2, p_message OUT VARCHAR2)
   IS
      l_sous_tache    ISAC_SOUS_TACHE.SOUS_TACHE%TYPE;
   BEGIN
      -- on vérifie si la date initiale de fin existe
      BEGIN
      SELECT SOUS_TACHE
        INTO l_sous_tache
        FROM ISAC_SOUS_TACHE
        WHERE pid = p_pid
        AND AFIN = to_date(p_date)
        AND rownum < 2;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_message := 'REJET';
        END;
END check_StacheInitFinDate;


PROCEDURE check_StacheRevDebDate (p_pid IN LIGNE_BIP.pid%TYPE, p_date IN VARCHAR2, p_message OUT VARCHAR2)
   IS
      l_sous_tache    ISAC_SOUS_TACHE.SOUS_TACHE%TYPE;
   BEGIN
      -- on vérifie si la date révisée de début existe
      BEGIN
      SELECT SOUS_TACHE
        INTO l_sous_tache
        FROM ISAC_SOUS_TACHE
        WHERE pid = p_pid
        AND ANDE = to_date(p_date)
        AND rownum < 2;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_message := 'REJET';
        END;
END check_StacheRevDebDate;


PROCEDURE check_StacheRevFinDate (p_pid IN LIGNE_BIP.pid%TYPE, p_date IN VARCHAR2, p_message OUT VARCHAR2)
   IS
      l_sous_tache    ISAC_SOUS_TACHE.SOUS_TACHE%TYPE;
   BEGIN
      -- on vérifie si la date révisée de fin existe
      BEGIN
      SELECT SOUS_TACHE
        INTO l_sous_tache
        FROM ISAC_SOUS_TACHE
        WHERE pid = p_pid
        AND ANFI = to_date(p_date)
        AND rownum < 2;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_message := 'REJET';
        END;
END check_StacheRevFinDate;


PROCEDURE check_RessBipCode (p_ident IN VARCHAR2, p_dateDebConso IN VARCHAR2, p_dateFinConso IN VARCHAR2, p_message OUT VARCHAR2)
   IS
   l_datsitu  SITU_RESS.DATSITU%type;
   l_datdep SITU_RESS.DATDEP%type;
   l_ident RESSOURCE.IDENT%type;
   BEGIN
   p_message := 'OK'; --initialisation


   -- on vérifie si la ressource existe, sinon rejet
   BEGIN
      SELECT ident
      INTO  l_ident
      FROM RESSOURCE
      WHERE ident = p_ident;
      EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_message := 'REJET';
        END;



   -- si le code ressource existe (pas de rejet), on passe au contrôle de période de consommé
   IF p_message <> 'REJET' AND p_dateDebConso is not null AND p_dateFinConso is not null  THEN
   --on cherche s'il y a une situation couvrant totalement la période de consommé d'une ressource, sinon avertissement
   BEGIN

      SELECT datsitu, datdep
        INTO l_datsitu, l_datdep
        FROM SITU_RESS
       WHERE
       ident = p_ident
       AND
       (
          (
             datsitu <= p_dateDebConso
             AND ( datdep is null OR datdep >= p_dateFinConso)
           )
         /*
                OR
          (


           ((datsitu BETWEEN p_dateDebConso and p_dateFinConso)  AND ( datdep is null OR datdep >= p_dateFinConso) )
              OR
           ((datdep BETWEEN p_dateDebConso and p_dateFinConso)  AND ( datsitu  <= p_dateDebConso))
              OR

           ((datsitu BETWEEN p_dateDebConso and p_dateFinConso)  AND (datdep BETWEEN p_dateDebConso and p_dateFinConso) )


           )*/
       )
       AND ROWNUM <2;

       EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_message := 'WARNING';
        END;
    END IF;


END check_RessBipCode;



PROCEDURE check_RessBipNom (p_ident IN VARCHAR2, p_ressNom IN VARCHAR2, p_message OUT VARCHAR2)
   IS
   l_ressNomBase RESSOURCE.RNOM%type;
   l_ressNomFichier RESSOURCE.RNOM%type;
   BEGIN
   p_message := ''; --initialisation


   --Si le nom de ressource non valorisé, alors pas d'action nécessaire.
   IF p_ressNom is not null THEN
   -- on recupère le nom de ressource correspondant au code de ressource
   BEGIN
      SELECT rnom
      INTO  l_ressNomBase
      FROM RESSOURCE
      WHERE ident = p_ident;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              p_message := 'REJET';
       END;


    -- on copie des deux noms dans deux champs de transit puis on les convertit en majuscules non accentuées
    l_ressNomBase := UPPER(REGEXP_REPLACE(CONVERT(l_ressNomBase, 'US7ASCII'), '[^A-Za-z0-9]', ''));
    l_ressNomFichier := UPPER(REGEXP_REPLACE(CONVERT(p_ressNom, 'US7ASCII'), '[^A-Za-z0-9]', ''));

    IF INSTR(l_ressNomBase,l_ressNomFichier) != 1 THEN
       p_message := 'REJET';
    END IF;
  END IF;
END check_RessBipNom;


PROCEDURE check_ConsoDebDate(p_ident IN VARCHAR2, p_dateDebConso IN VARCHAR2, p_message OUT VARCHAR2)
   IS
l_date VARCHAR2(10);
   BEGIN
   p_message := ''; --initialisation
   --TODO : attente de réponse sur les sources de données p_dateDebConso et p_dateFinConso
   BEGIN
   select 1 into l_date
   from dual;
   END;


END check_ConsoDebDate;


PROCEDURE check_ConsoFinDate(p_ident IN VARCHAR2, p_dateFinConso IN VARCHAR2, p_message OUT VARCHAR2)
   IS
l_date VARCHAR2(10);
   BEGIN
   p_message := ''; --initialisation
    --TODO : attente de réponse sur les sources de données p_dateDebConso et p_dateFinConso
    BEGIN
     select 1 into l_date
   from dual;
   END;
END check_ConsoFinDate;


PROCEDURE isLigneProductive (p_pid IN VARCHAR2, p_result OUT VARCHAR2)
   IS
   l_typproj    NUMBER;
   BEGIN
         -- Vérifier le type de projet
    BEGIN
      SELECT TO_NUMBER (typproj)
        INTO l_typproj
        FROM ligne_bip
       WHERE pid = p_pid;
             EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 p_result := 'FALSE';
       END;

      --SI ligne non productive
       IF l_typproj = 7  THEN
           p_result := 'FALSE';
       ELSE
    --Sinon la ligne est productive
     p_result := 'TRUE';
     END IF;
END  isLigneProductive;

PROCEDURE isPeriodeAnterieureAnneeFonct(p_dateDebConso IN VARCHAR2, p_result OUT VARCHAR2)
IS

l_annee_fonct number(4);
  BEGIN
  
  select to_char(datdebex,'YYYY') into l_annee_fonct from datdebex;
  
  p_result := ''; --initialisation
    --Si mention d'une période de consommé antérieure au 1er janvier de l'année fonctionnelle, alors rejet
      --DBMS_OUTPUT.PUT_LINE(to_char(to_date(p_dateDebConso),'yyyy'));
    IF to_char(to_date(p_dateDebConso),'yyyy') < to_number(l_annee_fonct) THEN
     p_result := 'REJET';
     END IF;

END isPeriodeAnterieureAnneeFonct;

PROCEDURE isPeriodeUlterieureMoisFonct(p_dateDebConso IN VARCHAR2, p_pid IN VARCHAR2, p_result OUT VARCHAR2)
IS
l_dateDebConso DATE;
l_message VARCHAR2(10);
l_mois_fonct date;
  BEGIN
  p_result := ''; --initialisation
  l_message :='';
  l_dateDebConso := to_date(p_dateDebConso);


  select cmensuelle into l_mois_fonct from datdebex;


  --Si mention d'une période de consommé ultérieure au mois fonctionnel en cours, alors :
  IF (to_date('01/'|| TO_CHAR(l_dateDebConso,'MM/YYYY')) > to_date('01/'||TO_CHAR(l_mois_fonct,'MM/YYYY'))
    AND TO_CHAR(l_dateDebConso,'YYYY') = TO_CHAR(l_mois_fonct,'YYYY')
  ) THEN
    --SI la ligne Bip est gérée en structure SR,
    check_StructSR(p_pid,l_message);
    --SEl PPM 60612 QC 1638

    IF l_message = 'REJET' THEN

    p_result := 'REJET';

    ELSE

    p_result := 'SR';

    END IF;
  END IF;
END isPeriodeUlterieureMoisFonct;

-- Création d'une fonction pour verifier si une chaine est de type number
FUNCTION is_number (p_string IN VARCHAR2)
     RETURN INT
      IS
         v_new_num NUMBER;
      BEGIN
         v_new_num := TO_NUMBER(p_string);
         RETURN 1;
      EXCEPTION
      WHEN VALUE_ERROR THEN
         RETURN 0;
END is_number;

PROCEDURE isPeriodeUlterieureAnneeFonct(p_dateDebConso IN VARCHAR2, p_pid IN VARCHAR2, p_result OUT VARCHAR2)
IS
l_dateDebConso DATE;
l_message VARCHAR2(10);
l_annee_fonc DATE;
  BEGIN
  p_result := 'OK'; --initialisation
  l_message :='';
  l_dateDebConso := to_date(p_dateDebConso);
  
  select datdebex into l_annee_fonc from datdebex;

  IF TO_CHAR(l_dateDebConso,'YYYY') > TO_CHAR(l_annee_fonc,'YYYY') THEN

    p_result := 'REJET';

  END IF;
  
END isPeriodeUlterieureAnneeFonct;

--SEL PPM 60709 5.4
PROCEDURE check_EtapeType_No(p_pid IN VARCHAR2,p_message OUT VARCHAR2) IS


--5.4
      l_valeu_jeux_t VARCHAR2(300);
      l_typo_p VARCHAR2(6);
      l_typo_s VARCHAR2(6);
      t_table_typo     PACK_UTILE.t_array;
      l_is_concerne boolean := false;

BEGIN

p_message := 'Sans objet';

BEGIN
                    
                    SELECT lpb.VALEUR INTO l_valeu_jeux_t
                                FROM  struct_info inf,
                                      ligne_bip lig,
                                      LIGNE_PARAM_BIP lpb
                                WHERE inf.CODSG = lig.CODSG
                                AND lpb.CODE_VERSION = to_char(inf.CODDIR)
                                AND lpb.CODE_ACTION = 'TYPETAPES-JEUX-T'
                                AND lpb.ACTIF = 'O'
                                
                                AND lig.PID = TRIM(p_pid)
                                
                                and lpb.num_ligne = 1
                                
                                ;
                    
                    t_table_typo := PACK_UTILE.SPLIT(l_valeu_jeux_t,',');
                                
                    SELECT trim(typproj),arctype INTO l_typo_p,l_typo_s FROM ligne_bip WHERE pid = TRIM(p_pid);
                    
                    FOR I in 1..t_table_typo.COUNT LOOP
                    
                        IF (     l_typo_p = t_table_typo(I)
                              OR l_typo_p||'_'||l_typo_s = t_table_typo(I) 
                              OR l_typo_p||'_'||l_typo_s LIKE replace(t_table_typo(I),'*','%')  
                           ) THEN
                        
                        l_is_concerne := true;
                        p_message := 'REJET';
                        exit;
                        
                        END IF;
                    
                    END LOOP;
                    
                      
                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
             
                    p_message := 'Sans objet';
     
                    END;

END check_EtapeType_No;


--SEL 1811
PROCEDURE VERIFIER_TACHE_AXE_METIER_BIPS ( 
                                      p_tacheaxemetier IN ISAC_TACHE.tacheaxemetier%TYPE,
                                      p_pid   IN  isac_tache.pid%TYPE,
                                      p_type OUT VARCHAR2,
                                      p_nb_rejet OUT VARCHAR2) IS


   l_message varchar2(1024);
   l_type varchar2(20);
   l_param_id varchar2(20);

    BEGIN

    PACK_ISAC_TACHE.VERIFIER_TACHE_AXE_METIER(p_tacheaxemetier,p_pid,l_message,p_type,l_param_id);
    
    select count(dpcode) into p_nb_rejet from dossier_projet_copi where dpcopiaxemetier = p_tacheaxemetier;
    
    DBMS_OUTPUT.PUT_LINE('l_message = ' || l_message);
    DBMS_OUTPUT.PUT_LINE('l_param_id = ' || l_param_id);

    END VERIFIER_TACHE_AXE_METIER_BIPS;

-- FAD PPM 64368 : Insertion de la ligne en cours dans une table temporaire
PROCEDURE INSERT_CONSO_TMP (vNUMSEQ IN TMP_PMW_BIPS.NUMSEQ%TYPE,
	vLIGNEBIPCODE IN TMP_PMW_BIPS.LIGNEBIPCODE%TYPE,
	vSTRUCTUREACTION IN TMP_PMW_BIPS.STRUCTUREACTION%TYPE,
	vETAPENUM IN TMP_PMW_BIPS.ETAPENUM%TYPE,
	vTACHENUM IN TMP_PMW_BIPS.TACHENUM%TYPE,
	vSTACHENUM IN TMP_PMW_BIPS.STACHENUM%TYPE,
	vCONSODEBDATE IN TMP_PMW_BIPS.CONSODEBDATE%TYPE,
	vCONSOFINDATE IN TMP_PMW_BIPS.CONSOFINDATE%TYPE,
	vRESSBIPCODE IN TMP_PMW_BIPS.RESSBIPCODE%TYPE,
	vCONSOQTE IN TMP_PMW_BIPS.CONSOQTE%TYPE,
	RETOUR OUT VARCHAR2) IS
BEGIN
	INSERT INTO TMP_PMW_BIPS VALUES(vNUMSEQ, vLIGNEBIPCODE, vSTRUCTUREACTION, vETAPENUM, vTACHENUM, vSTACHENUM, vCONSODEBDATE, vCONSOFINDATE, vRESSBIPCODE, vCONSOQTE);
END INSERT_CONSO_TMP;

-- FAD PPM 64368 : Procédures stockées pour verifier le consommé du mois et de l'année d'une ligne BIP
PROCEDURE CONSO_MOIS_OK (vNUMSEQ IN TMP_PMW_BIPS.NUMSEQ%TYPE,
	vLIGNEBIPCODE IN TMP_PMW_BIPS.LIGNEBIPCODE%TYPE,
	vSTRUCTUREACTION IN TMP_PMW_BIPS.STRUCTUREACTION%TYPE,
	vETAPENUM IN TMP_PMW_BIPS.ETAPENUM%TYPE,
	vTACHENUM IN TMP_PMW_BIPS.TACHENUM%TYPE,
	vSTACHENUM IN TMP_PMW_BIPS.STACHENUM%TYPE,
	vCONSODEBDATE IN TMP_PMW_BIPS.CONSODEBDATE%TYPE,
	vCONSOFINDATE IN TMP_PMW_BIPS.CONSOFINDATE%TYPE,
	vRESSBIPCODE IN TMP_PMW_BIPS.RESSBIPCODE%TYPE,
	vCONSOQTE IN TMP_PMW_BIPS.CONSOQTE%TYPE,
	RETOUR OUT VARCHAR2) IS

	CONSOMMEMOIS NUMBER;
	CONSOMMEMOISSR NUMBER;
	i NUMBER;
BEGIN
	CONSOMMEMOIS := NULL;
	CONSOMMEMOISSR := NULL;
	i := NULL;

	BEGIN
		-- On vérifie si la ligne en cours dispose d'une structure SR
		SELECT 1 INTO i
		FROM
			ISAC_ETAPE,
			ISAC_TACHE,
			ISAC_SOUS_TACHE
		WHERE
			ISAC_ETAPE.ETAPE = ISAC_TACHE.ETAPE
			AND ISAC_SOUS_TACHE.ETAPE = ISAC_TACHE.ETAPE
			AND ISAC_SOUS_TACHE.TACHE = ISAC_TACHE.TACHE

			AND ISAC_ETAPE.PID = vLIGNEBIPCODE
			AND TO_NUMBER(ISAC_ETAPE.ECET) = vETAPENUM
			AND TO_NUMBER(ISAC_TACHE.ACTA) = vTACHENUM
			AND TO_NUMBER(ISAC_SOUS_TACHE.ACST) = vSTACHENUM
			AND ROWNUM = 1;

		-- Si on dispose d'une structure SR et StructureAction <> de LA alors on récupère
		-- la somme des consommés SR du mois courant en plus des consommés déjà présents
		-- dans le fichier .BIPS
		IF(vSTRUCTUREACTION <> 'LA')
		THEN
			SELECT
				NVL(SUM(CONSOQTE), 0) INTO CONSOMMEMOIS
			FROM
				TMP_PMW_BIPS
			WHERE
				LIGNEBIPCODE = vLIGNEBIPCODE
				AND ETAPENUM = vETAPENUM
				AND TACHENUM = vTACHENUM
				AND STACHENUM = vSTACHENUM
				AND RESSBIPCODE = vRESSBIPCODE
				AND TO_CHAR(CONSODEBDATE, 'MMYYYY') = TO_CHAR(vCONSODEBDATE, 'MMYYYY')

				AND NUMSEQ = vNUMSEQ;

			SELECT
				NVL(SUM(ISAC_CONSOMME.CUSAG), 0) INTO CONSOMMEMOISSR
			FROM
				ISAC_ETAPE,
				ISAC_TACHE,
				ISAC_SOUS_TACHE,
				ISAC_CONSOMME
			WHERE
				ISAC_ETAPE.ETAPE = ISAC_TACHE.ETAPE
				AND ISAC_SOUS_TACHE.ETAPE = ISAC_TACHE.ETAPE
				AND ISAC_SOUS_TACHE.TACHE = ISAC_TACHE.TACHE
				AND ISAC_CONSOMME.ETAPE = ISAC_ETAPE.ETAPE
				AND ISAC_CONSOMME.TACHE = ISAC_TACHE.TACHE
				AND ISAC_CONSOMME.SOUS_TACHE = ISAC_SOUS_TACHE.SOUS_TACHE

				AND ISAC_ETAPE.PID = vLIGNEBIPCODE
				AND ISAC_ETAPE.ECET = vETAPENUM
				AND ISAC_TACHE.ACTA = vTACHENUM
				AND ISAC_SOUS_TACHE.ACST = vSTACHENUM
				AND ISAC_CONSOMME.IDENT = vRESSBIPCODE

				AND TO_CHAR(ISAC_CONSOMME.CDEB, 'MMYYYY') = TO_CHAR(vCONSODEBDATE, 'MMYYYY');

			IF (CONSOMMEMOIS + CONSOMMEMOISSR > 999.99)
			THEN
				RETOUR := 'REJET';
				DELETE
				FROM
					TMP_PMW_BIPS
				WHERE
					LIGNEBIPCODE = vLIGNEBIPCODE
					AND ETAPENUM = vETAPENUM
					AND TACHENUM = vTACHENUM
					AND STACHENUM = vSTACHENUM
					AND RESSBIPCODE = vRESSBIPCODE
					AND CONSODEBDATE = vCONSODEBDATE
					AND CONSOFINDATE = vCONSOFINDATE
					AND NUMSEQ = vNUMSEQ;
			END IF;
		END IF;
	EXCEPTION WHEN NO_DATA_FOUND THEN
		SELECT
			NVL(SUM(CONSOQTE), 0) INTO CONSOMMEMOIS
		FROM
			TMP_PMW_BIPS
		WHERE
			LIGNEBIPCODE = vLIGNEBIPCODE
			AND ETAPENUM = vETAPENUM
			AND TACHENUM = vTACHENUM
			AND STACHENUM = vSTACHENUM
			AND RESSBIPCODE = vRESSBIPCODE
			AND TO_CHAR(CONSODEBDATE, 'MMYYYY') = TO_CHAR(vCONSODEBDATE, 'MMYYYY')
			AND NUMSEQ = vNUMSEQ;
		IF (CONSOMMEMOIS > 999.99)
		THEN
			RETOUR := 'REJET';
			DELETE FROM TMP_PMW_BIPS
			WHERE LIGNEBIPCODE = vLIGNEBIPCODE
			AND ETAPENUM = vETAPENUM
			AND TACHENUM = vTACHENUM
			AND STACHENUM = vSTACHENUM
			AND RESSBIPCODE = vRESSBIPCODE
			AND CONSODEBDATE = vCONSODEBDATE
			AND CONSOFINDATE = vCONSOFINDATE
			AND NUMSEQ = vNUMSEQ;
		END IF;
	END;
END CONSO_MOIS_OK;

PROCEDURE CONSO_ANNEE_OK (vNUMSEQ IN TMP_PMW_BIPS.NUMSEQ%TYPE,
	vLIGNEBIPCODE IN TMP_PMW_BIPS.LIGNEBIPCODE%TYPE,
	vSTRUCTUREACTION IN TMP_PMW_BIPS.STRUCTUREACTION%TYPE,
	vETAPENUM IN TMP_PMW_BIPS.ETAPENUM%TYPE,
	vTACHENUM IN TMP_PMW_BIPS.TACHENUM%TYPE,
	vSTACHENUM IN TMP_PMW_BIPS.STACHENUM%TYPE,
	vCONSODEBDATE IN TMP_PMW_BIPS.CONSODEBDATE%TYPE,
	vCONSOFINDATE IN TMP_PMW_BIPS.CONSOFINDATE%TYPE,
	vRESSBIPCODE IN TMP_PMW_BIPS.RESSBIPCODE%TYPE,
	vCONSOQTE IN TMP_PMW_BIPS.CONSOQTE%TYPE,
	RETOUR OUT VARCHAR2) IS

	CONSOMMEMOIS NUMBER;
	CONSOMMEMOISSR NUMBER;
	i NUMBER;
BEGIN
	CONSOMMEMOIS := NULL;
	CONSOMMEMOISSR := NULL;
	i := NULL;
	BEGIN
		-- On vérifie si la ligne en cours dispose d'une structure SR
		SELECT 1 INTO i
		FROM
			ISAC_ETAPE,
			ISAC_TACHE,
			ISAC_SOUS_TACHE
		WHERE
			ISAC_ETAPE.ETAPE = ISAC_TACHE.ETAPE
			AND ISAC_SOUS_TACHE.ETAPE = ISAC_TACHE.ETAPE
			AND ISAC_SOUS_TACHE.TACHE = ISAC_TACHE.TACHE

			AND ISAC_ETAPE.PID = vLIGNEBIPCODE
			AND TO_NUMBER(ISAC_ETAPE.ECET) = vETAPENUM
			AND TO_NUMBER(ISAC_TACHE.ACTA) = vTACHENUM
			AND TO_NUMBER(ISAC_SOUS_TACHE.ACST) = vSTACHENUM
			AND ROWNUM = 1;

		-- Si on dispose d'une structure SR et StructureAction <> de LA alors on récupère
		-- la somme des consommés SR du mois courant en plus des consommés déjà présents
		-- dans le fichier .BIPS
		IF(vSTRUCTUREACTION <> 'LA')
		THEN
			SELECT
				NVL(SUM(CONSOQTE), 0) INTO CONSOMMEMOIS
			FROM
				TMP_PMW_BIPS
			WHERE
				LIGNEBIPCODE = vLIGNEBIPCODE
				AND ETAPENUM = vETAPENUM
				AND TACHENUM = vTACHENUM
				AND STACHENUM = vSTACHENUM
				AND RESSBIPCODE = vRESSBIPCODE
				AND TO_CHAR(CONSODEBDATE, 'YYYY') = TO_CHAR(vCONSODEBDATE, 'YYYY')
				AND NUMSEQ = vNUMSEQ;

			SELECT
				NVL(SUM(ISAC_CONSOMME.CUSAG), 0) INTO CONSOMMEMOISSR
			FROM
				ISAC_ETAPE,
				ISAC_TACHE,
				ISAC_SOUS_TACHE,
				ISAC_CONSOMME
			WHERE
				ISAC_ETAPE.ETAPE = ISAC_TACHE.ETAPE
				AND ISAC_SOUS_TACHE.ETAPE = ISAC_TACHE.ETAPE
				AND ISAC_SOUS_TACHE.TACHE = ISAC_TACHE.TACHE
				AND ISAC_CONSOMME.ETAPE = ISAC_ETAPE.ETAPE
				AND ISAC_CONSOMME.TACHE = ISAC_TACHE.TACHE
				AND ISAC_CONSOMME.SOUS_TACHE = ISAC_SOUS_TACHE.SOUS_TACHE

				AND ISAC_ETAPE.PID = vLIGNEBIPCODE
				AND ISAC_ETAPE.ECET = vETAPENUM
				AND ISAC_TACHE.ACTA = vTACHENUM
				AND ISAC_SOUS_TACHE.ACST = vSTACHENUM
				AND ISAC_CONSOMME.IDENT = vRESSBIPCODE

				AND TO_CHAR(ISAC_CONSOMME.CDEB, 'YYYY') = TO_CHAR(vCONSODEBDATE, 'YYYY');

			IF (CONSOMMEMOIS + CONSOMMEMOISSR > 99999.99)
			THEN
				RETOUR := 'REJET';
				DELETE
				FROM
					TMP_PMW_BIPS
				WHERE
					LIGNEBIPCODE = vLIGNEBIPCODE
					AND ETAPENUM = vETAPENUM
					AND TACHENUM = vTACHENUM
					AND STACHENUM = vSTACHENUM
					AND RESSBIPCODE = vRESSBIPCODE
					AND CONSODEBDATE = vCONSODEBDATE
					AND CONSOFINDATE = vCONSOFINDATE
					AND NUMSEQ = vNUMSEQ;
			END IF;
		END IF;
	EXCEPTION WHEN NO_DATA_FOUND THEN
		SELECT NVL(SUM(CONSOQTE), 0) INTO CONSOMMEMOIS
		FROM TMP_PMW_BIPS
		WHERE LIGNEBIPCODE = vLIGNEBIPCODE
		AND ETAPENUM = vETAPENUM
		AND TACHENUM = vTACHENUM
		AND STACHENUM = vSTACHENUM
		AND RESSBIPCODE = vRESSBIPCODE
		AND TO_CHAR(CONSODEBDATE, 'YYYY') = TO_CHAR(vCONSODEBDATE, 'YYYY')
		AND NUMSEQ = vNUMSEQ;
		IF (CONSOMMEMOIS > 99999.99)
		THEN
			RETOUR := 'REJET';
			DELETE FROM TMP_PMW_BIPS
			WHERE LIGNEBIPCODE = vLIGNEBIPCODE
			AND ETAPENUM = vETAPENUM
			AND TACHENUM = vTACHENUM
			AND STACHENUM = vSTACHENUM
			AND RESSBIPCODE = vRESSBIPCODE
			AND CONSODEBDATE = vCONSODEBDATE
			AND CONSOFINDATE = vCONSOFINDATE
			AND NUMSEQ = vNUMSEQ;
		END IF;
	END;
END CONSO_ANNEE_OK;

-- FAD PPM 64368 : Purge de la table temporaire
PROCEDURE PURGE_CONSO_TMP (sNUMSEQ IN NUMBER) IS
BEGIN
	DELETE FROM TMP_PMW_BIPS WHERE NUMSEQ = sNUMSEQ;
END PURGE_CONSO_TMP;

-- FAD PPM 64368 : Récupération d'un id unique pour le traitement en cours
PROCEDURE GET_NUM_SEQ(sNUMSEQ OUT NUMBER) IS
BEGIN
	SELECT BIP.SETATKE.NEXTVAL INTO sNUMSEQ FROM DUAL;
END GET_NUM_SEQ;
-- FAD PPM 64368 : Fin


--DHA Optimization BIPS 
 PROCEDURE check_StructsSR (id_lignes_bip_in  IN  ARRAY_TABLE,                                                                                
                           id_ligne_bip_out OUT ARRAY_TABLE)                           
  IS     
  BEGIN  
    BEGIN                  
          SELECT DISTINCT ISAC_SOUS_TACHE.pid
          BULK COLLECT INTO id_ligne_bip_out
          FROM ISAC_SOUS_TACHE          
          WHERE pid IN (select column_value from table(id_lignes_bip_in));                    
    END;
END check_StructsSR;

PROCEDURE find_id_lignes_bip_valides(id_lignes_bip_in  IN  ARRAY_TABLE,                                                                                
                                     id_lignes_bip  OUT ARRAY_TABLE,
                                     dates_statut OUT ARRAY_DATE,
                                     types_projet OUT ARRAY_TABLE)  IS
  l_mois_fonct date;
  
  BEGIN
        
      SELECT cmensuelle into l_mois_fonct FROM datdebex;
      
      BEGIN
          SELECT DISTINCT lb.PID, lb.ADATESTATUT, lb.TYPPROJ  
          BULK COLLECT INTO id_lignes_bip, dates_statut, types_projet 
          FROM ligne_bip lb
          WHERE lb.pid IN (SELECT column_value FROM table(id_lignes_bip_in)) 
          AND length(lb.pid) IN (3, 4);          
         -- AND (lb.adatestatut IS NULL OR lb.adatestatut >=  to_date('01/'||TO_CHAR(l_mois_fonct,'MM/YYYY'))) ;
                 
         
    END;

END find_id_lignes_bip_valides;

--DHA
END PACK_REMONTEE;
/