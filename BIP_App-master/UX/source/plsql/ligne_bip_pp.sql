-- Pack Ligne_BIP_PP
--
-- Package permettant d'inserer en base des lignes T9 en masse
--
-- Le 23/07/2007 par BPO : Mise en controle de version du package
-- le 11/05/2011 par ABA : la procéduure ne n'hesite plus d'avoir la vlauer "a cr"  (à creer) pour la création de ligne bip
-- le 25/05/2011 par ABA : ajout du champ pzone
-- le 09/11/2011 par ABA : l'ajout des budgets doit être facultatif
-- le 07/12/2011 par ABA : QC 1314
-- le 18/04/2012 par BSA : QC 1382
-- le 19/07/2012 par BSA : QC 1382
-- le 12/12/2012 par ABA : QC 1399
-- le 21/12/2012 par ABA : QC 1399
create or replace
PACKAGE     pack_ligne_bip_pp AS


	PROCEDURE insert_ligne_bip (p_id_batch TRAIT_BATCH.ID_TRAIT_BATCH%TYPE, p_ligne ligne_bip_maj_masse%ROWTYPE) ;
	PROCEDURE insert_ligne_bip_pp ;
	PROCEDURE insert_ligne_bip_pp_copie ;
--ZAA PM 61695
TYPE t_array IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array;
END pack_ligne_bip_pp;
/

create or replace
PACKAGE BODY     pack_ligne_bip_pp
AS
FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array
IS

   i       number :=0;
   pos     number :=0;
   lv_str  varchar2(2000) := p_in_string;

strings t_array;

BEGIN

   -- determine first chuck of string
   pos := instr(lv_str,p_delim,1,1);

   IF(pos = 0) THEN
    lv_str:=lv_str||',';
    pos := instr(lv_str,p_delim,1,1);
   END IF;

   -- while there are chunks left, loop
   WHILE ( pos != 0) LOOP

      -- increment counter
      i := i + 1;

      -- create array element for chuck of string
      strings(i) := substr(lv_str,1,pos-1);

      -- remove chunk from string
      lv_str := substr(lv_str,pos+1,length(lv_str));

      -- determine next chunk
      pos := instr(lv_str,p_delim,1,1);

      -- no last chunk, add to array
      IF pos = 0 THEN

         strings(i+1) := lv_str;

      END IF;

   END LOOP;

   -- return array
   RETURN strings;

END SPLIT;
   PROCEDURE insert_ligne_bip (p_id_batch TRAIT_BATCH.ID_TRAIT_BATCH%TYPE, p_ligne ligne_bip_maj_masse%ROWTYPE)
   IS


    l_pid         VARCHAR2 (4); -- variable locale pid (p_pid ne peut etre lue (OUT))
    l_pcle        VARCHAR2 (3);
    l_dpcode      NUMBER;
    l_erreur      NUMBER;
    l_presence    NUMBER;
    l_liberreur   VARCHAR2 (500);
    l_annee_ref   NUMBER (4);
    l_budget      NUMBER;
    l_actif       VARCHAR2 (1);

    t_separateur VARCHAR2(10);


    t_date_fermeture    DATE;

    t_cafi      STRUCT_INFO.CAFI%TYPE;
    t_metier    LIGNE_BIP.METIER%TYPE;
    t_camo      LIGNE_BIP.CODCAMO%TYPE;

	t_valeur VARCHAR2(400);
    t_message VARCHAR2(400);

    l_presence_dbs    NUMBER;

    --SEL 26/06/2014 PPM 58143 QC 1627
    l_client_dbs_obligatoire boolean :=false;
    l_dbs_obligatoire boolean :=false;
    l_dbs_obligatoire_varchar VARCHAR2(5);
    l_dbs_logs VARCHAR2(5);
   
    --ABN PPM 59138 - DEBUT
    l_statut          CHAR (1);
    l_astatut          CHAR (1);
    
    l_dirprin     NUMBER;--PPM 59288
    p_message     VARCHAR2(500);--PPM 59288

    --ABN PPM 59138 - FIN
    --ZAA PPM 61695
    l_dbs_obligation VARCHAR2(5);
    t_table         t_array;
    separateur VARCHAR2(1);
      BEGIN

        --ABN PPM 59138 - DEBUT

        BEGIN
			--FAD PPM 63410: Récupération du statut du projet affecté à la ligne BIP
            /*SELECT p.statut into l_statut FROM proj_info p
                WHERE p.icpi = p_ligne.icpi AND p.statut = 'O';*/
			SELECT p.statut into l_statut FROM proj_info p
                WHERE p.icpi = p_ligne.icpi;
			--FAD PPM 63410
        EXCEPTION
                WHEN NO_DATA_FOUND
                  THEN
                     l_statut := null;

        END;

        l_astatut := null;
        --ABN PPM 59138 - FIN

        t_separateur := ';' ;

         SELECT TO_NUMBER (TO_CHAR (datdebex, 'YYYY')) INTO l_annee_ref FROM datdebex;

        --
        -- Calculer le pid et la cle de controle pcle
        l_erreur := 0;
        l_presence := 0;

        -- initialisation de l_budget à 1 (top de mise à jour de la table budget)
            l_budget := 1;


-- SEL 28/05/2014 PPM 58143 8.6
    -- Recherche du parametre applicatif OBLIGATION-DBS
    PACK_LIGNE_BIP.RECUPERER_PARAM_APP('OBLIGATION-DBS','DEFAUT','1',t_valeur,t_message);
    PACK_LIGNE_BIP.RECUPERER_SEPAR_PARAM_APP('OBLIGATION-DBS','DEFAUT',1,separateur,t_message);
    --ZAA PPM 61695
    --t_table := SPLIT(t_valeur,',');
    t_table := SPLIT(t_valeur,separateur);
    l_dbs_obligation:=t_table(1);
    -- Si le parametre OBLIGATION-DBS n existe pas
    IF t_message IS NOT NULL
    THEN
                 l_erreur := 1;
                 INSERT INTO TRAIT_BATCH_RETOUR
                            (ID_TRAIT_BATCH,  DATA, ERREUR )
                     VALUES (p_id_batch,
                     t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                             || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                             || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                             , 'Le paramètre applicatif OBLIGATION-DBS est absent'
                            );
    -- Sinon le parametre OBLIGATION-DBS existe bien
    ELSE

    -- Tester si le client possede comme direction rendant le DBS obligatoire ou non.
   l_client_dbs_obligatoire := pack_ligne_bip.est_client_dbs(p_ligne.clicode);

   l_dbs_obligatoire := ( trim(p_ligne.typproj) = '1' OR trim(p_ligne.typproj) = '2') AND l_client_dbs_obligatoire;

   IF(p_ligne.dbs IS NULL) THEN
          
          --Si le paramètre d'obligation DBS est à OUI
          IF(l_dbs_obligation = 'OUI') THEN
          
             -- Si le DBS est obligatoire et null

             IF (l_dbs_obligatoire) THEN

                   l_erreur := 1;

                     INSERT INTO TRAIT_BATCH_RETOUR
                            (ID_TRAIT_BATCH,  DATA, ERREUR )
                     VALUES (p_id_batch,
                     t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                             || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                             || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                             , 'Le DBS est obligatoire et n''a pas été fourni'
                            );
            END IF;

          END IF;

        ELSE

        -- le DBS est non null
                 BEGIN
                  SELECT 1
                    INTO l_presence_dbs
                    FROM SOUS_TYPOLOGIE
                   WHERE sous_type = p_ligne.dbs;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                 END;

                 --Si le DBS n est pas obligatoire et non null, peu importe la valeur du DBS (correcte ou non)
                 IF(l_dbs_obligatoire = false) THEN
                 l_erreur := 0;
                 END IF;

                 IF(l_erreur = 1) THEN

                 INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch,
                     t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                             || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                             || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                             , 'Le DBS fourni n''est pas autorisée'
                                 );


                 END IF;

            END IF; -- dbs obligatoire
     END IF;

            IF (p_ligne.annee IS NOT NULL OR p_ligne.prop_four IS NOT NULL)
            THEN
               IF (p_ligne.annee IS NULL AND p_ligne.prop_four IS NOT NULL) OR (p_ligne.annee IS NOT NULL AND p_ligne.prop_four IS NULL)
               THEN
                  l_erreur := 1;

                  INSERT INTO TRAIT_BATCH_RETOUR
                              (ID_TRAIT_BATCH,  DATA, ERREUR )
                       VALUES ( p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                               || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                               || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                               , 'Annee vide ou proposé vide'
                              );
               END IF;

               IF (l_erreur = 0)
               THEN
                  IF (p_ligne.annee < l_annee_ref - 1 OR p_ligne.annee > l_annee_ref + 3)
                  THEN
                     l_erreur := 1;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH,  DATA, ERREUR )
                          VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                  || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                  || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                  , 'Annee incorrecte'
                                 );
                  ELSIF (p_ligne.prop_four < 0)
                  THEN
                     l_erreur := 1;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH,  DATA, ERREUR )
                          VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                  || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                  || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                  , 'budget incorrect'
                                 );
                  END IF;

                  -- on bascule l_budget à 0 car il n'y a pas d'erreur concernant l'année et le proposé fournisseur
                  -- permet donc de déclencher la mise à jour de la table budget sous reserve des contrôles ci-dessous.
                  l_budget := 0;
               END IF;
            END IF;

            IF (l_erreur = 0)
            THEN
               BEGIN
                  SELECT icodproj
                    INTO l_dpcode
                    FROM proj_info
                   WHERE icpi = p_ligne.icpi;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH,  DATA, ERREUR )
                          VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                  || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                  || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                  , 'projet inexistant'
                                 );
               END;
            END IF;

            IF (l_erreur = 0)
            THEN

              --59288 : debut
              IF (p_ligne.arctype != 'T1' OR p_ligne.typproj != '1') -- ligne non GT1
              -- IF (p_ligne.arctype != 'T1' )
               THEN
               --PPM 59288 : gestion des lignes Bip en masse
               --Si la ligne saisie est non GT1 :
               --SI le DP saisi n'existe pas, rejeter le mouvement avec mention de l'erreur « DP inconnu ».
               BEGIN
                    SELECT dirprin into l_dirprin
                    FROM dossier_projet
                    WHERE dpcode = p_ligne.dpcode;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;

                           INSERT INTO TRAIT_BATCH_RETOUR
                                       (ID_TRAIT_BATCH,  DATA, ERREUR )
                                VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                        || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                        || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                        , 'DP inconnu'
                                       );
                  END;
                  --ZAA PPM 61695 SI un vrai DP (càd <>0) est saisi, ne le valider que si la « Direction Bip principalement concernée » est absente, OU si aucun paramètre actif OBLIGATION-DP-IMMO / DEFAUT / <RR> n¿existe, OU si elle est présente et ne fait pas partie des Directions du paramètre Bip OBLIGATION-DP-IMMO / DEFAUT / <rr>

                  --IF (p_ligne.dpcode != 0 AND PACK_DOSSIER_PROJET.is_autoris_elargis(l_dirprin, p_message))
                  --FAD erreur autorisation
                  IF (p_ligne.dpcode <> 0 AND NOT PACK_DOSSIER_PROJET.is_autoris_elargis(l_dirprin, p_message))
                  THEN
                  l_erreur := 1;

                           INSERT INTO TRAIT_BATCH_RETOUR
                                       (ID_TRAIT_BATCH,  DATA, ERREUR )
                                VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                        || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                        || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                        , 'Le DP indiqué n''est pas autorisé pour une ligne non GT1, compte-tenu de la Direction principalement concernée, associée à ce DP'
                                       );
                  END IF;
               /*
                  IF (l_dpcode != 0 OR p_ligne.dpcode != 0)
                  THEN
                     l_erreur := 1;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH,  DATA, ERREUR )
                          VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                  || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                  || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                  , 'ligne non T1 : le DP de la ligne et/ou du projet associé doit être 0 '
                                 );
                  END IF;
                  */
                  --59288 : fin
               ELSE
                  IF (l_dpcode = 0 OR p_ligne.dpcode = 0)
                  THEN
                     l_erreur := 1;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH,  DATA, ERREUR )
                          VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                  || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                  || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                  , 'Ligne T1 : le DP de la ligne et du projet associé doit être différent de 0 '
                                 );
                  END IF;

                  -- TEST de verification si le dossier projet de la ligne est ouvert
                  IF (l_erreur = 0)
                  THEN
                     BEGIN
                        SELECT actif
                          INTO l_actif
                          FROM dossier_projet
                         WHERE dpcode = p_ligne.dpcode;

                        IF l_actif = 'N'
                        THEN
                           l_erreur := 1;

                           INSERT INTO TRAIT_BATCH_RETOUR
                                       (ID_TRAIT_BATCH,  DATA, ERREUR )
                                VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                      || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                      || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                      , 'Le dossier projet est inactif'
                                       );
                        END IF;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           l_erreur := 1;

                           INSERT INTO TRAIT_BATCH_RETOUR
                                       (ID_TRAIT_BATCH,  DATA, ERREUR )
                                VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                        || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                        || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                        , 'Le dossier projet n''existe pas'
                                       );
                     END;
                  END IF;

                  -- verifie si le code dossier projet et le code projet sont bien lié dans la table proj_info
                  IF (l_erreur = 0)
                  THEN
                     BEGIN
                        SELECT 1
                          INTO l_presence
                          FROM proj_info
                         WHERE icodproj = p_ligne.dpcode AND icpi = p_ligne.icpi;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           l_erreur := 1;

                           INSERT INTO TRAIT_BATCH_RETOUR
                                       (ID_TRAIT_BATCH,  DATA, ERREUR )
                                VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                        || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                        || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                        , 'Le dossier projet et le projet de la ligne ne sont pas lié'
                                       );
                     END;
                  END IF;


               END IF;
            END IF;

            /* rejet du CODCAMO 66666 */
          IF (l_erreur = 0) THEN
             IF ( p_ligne.codcamo = 66666 AND (p_ligne.arctype = 'T1' OR trim(p_ligne.typproj) = '7' OR trim(p_ligne.typproj) = '9')) then
                l_erreur := 1;

                INSERT INTO TRAIT_BATCH_RETOUR
                            (ID_TRAIT_BATCH,  DATA, ERREUR )
                     VALUES (p_id_batch,
                     t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                             || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                             || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                             , 'Codcamo doit etre different de ' || p_ligne.codcamo
                            );
            END IF;
            END IF;

            /* test de l'existance du codcamo */
           IF (l_erreur = 0)
              THEN
                   BEGIN
                      SELECT CDATEFERM
                        INTO t_date_fermeture
                        FROM centre_activite
                       WHERE codcamo = p_ligne.codcamo;
                   EXCEPTION
                      WHEN NO_DATA_FOUND
                      THEN
                         l_erreur := 1;

                       INSERT INTO TRAIT_BATCH_RETOUR
                                   (ID_TRAIT_BATCH,  DATA, ERREUR )
                            VALUES (p_id_batch,
                            t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                    || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                    || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                    , 'Codcamo inexistant'
                                   );

                   END;

                   -- Controle date fermeture du code camo
                   -- Il doit etre superieur au mois en cours
                   IF (l_erreur = 0) THEN

                        IF t_date_fermeture IS NOT NULL THEN
                            IF TO_CHAR(t_date_fermeture,'YYYYMM') <= TO_CHAR(SYSDATE,'YYYYMM') THEN

                                  l_erreur := 1;

                                INSERT INTO TRAIT_BATCH_RETOUR
                                       (ID_TRAIT_BATCH,  DATA, ERREUR )
                                VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                        || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                        || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                        , 'Le CA payeur est fermé'
                                       );

                            END IF;

                        END IF;

                   END IF;
           END IF;



            BEGIN
               SELECT COUNT (*)
                 INTO l_presence
                 FROM metier
                WHERE TRIM (metier) = TRIM (p_ligne.metier);
            END;

            IF (l_presence = 0 AND l_erreur = 0)
            THEN
               l_erreur := 1;

               INSERT INTO TRAIT_BATCH_RETOUR
                           (ID_TRAIT_BATCH,  DATA, ERREUR )
                    VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                            || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                            || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                            , 'Metier'
                           );
            END IF;

            IF (l_erreur = 0) THEN

                -- recherche du cafi source QC 1607
                SELECT decode(s.cafi,'99820',s.centractiv,s.cafi) INTO t_cafi FROM STRUCT_INFO s WHERE s.CODSG = p_ligne.codsg ;

                -- Controle metier
               IF ( t_cafi NOT IN ( 88888, 99999, 99810 ) )
                    AND ( p_ligne.codcamo NOT IN (21000, 22000, 23000, 24000, 25000) )

                    AND TRIM(p_ligne.TYPPROJ) NOT IN ('5','7')
                    AND  NOT PACK_LISTE_RUBRIQUE.exister_rubrique_fictive() -- SEL 19/05/2014 PPM 58920 8.5.1
                    THEN

     --DBMS_OUTPUT.PUT_LINE('1 IL FAUT CONTROLER');
                    IF pack_ligne_bip_maj_masse.ctrlMetier( t_cafi, p_ligne.metier ) = 'KO' THEN

                      l_erreur := 1;

                    INSERT INTO TRAIT_BATCH_RETOUR
                           (ID_TRAIT_BATCH,  DATA, ERREUR )
                    VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                            || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                            || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                            , 'Rubrique(s) manquante(s) sur le DPG'
                           );

                    END IF;
                 END IF;


            END IF;


            IF (l_erreur = 0)
            THEN
               BEGIN
                  pack_ligne_bip.calcul_pid (l_pid);
                  pack_ligne_bip.calcul_cle (RTRIM (l_pid), l_pcle);

                  --SEL 26/06/2014 PPM 58143 QC 1627
                  IF(l_dbs_obligatoire) THEN
                  l_dbs_obligatoire_varchar:='TRUE';
                  ELSE
                  l_dbs_obligatoire_varchar:='FALSE';
                  END IF;
                  --ABN PPM 59138 - DEBUT
                  --DBMS_OUTPUT.PUT_LINE('l_statut: '||l_statut);
                  --DBMS_OUTPUT.PUT_LINE('p_ligne.arctype: '||p_ligne.arctype);
                  --DBMS_OUTPUT.PUT_LINE('p_ligne.typproj: '||p_ligne.typproj);
				  
				  --FAD PPM 63410: Si la ligne BIP est une GT1 alors on test la valeur du statut du projet et on affecte la valeur adéquate à la ligne
                  /*IF (l_statut = 'O' AND p_ligne.arctype = 'T1' AND  p_ligne.typproj = '1') THEN
                      --DBMS_OUTPUT.PUT_LINE('l_statut222: '||l_statut);
                      l_astatut := 'O';
                  ELSE
                      l_astatut := null;
                  END IF;*/

				  IF (p_ligne.arctype = 'T1' AND  p_ligne.typproj = '1') THEN
					IF (l_statut = 'O') THEN
						l_astatut := 'O';
					ELSE
						IF (l_statut = 'N' OR l_statut IS NULL) THEN
							l_astatut := 'N';
						END IF;
					END IF;
                  END IF;
				  --FAD PPM 63410: Fin

                  INSERT INTO ligne_bip
                              (pid, pcle, flaglock, topfer, pcactop, pconsn1, pdecn1, petat, dpcode, pnom, typproj, pdatdebpre,
                               arctype, toptri, codpspe, airt,
                               icpi, codsg, pcpi, clicode, clicode_oper, codcamo, pnmouvra,
                               pzone, metier, pobjet,CODREP,sous_type,astatut
                              )
                       VALUES (RTRIM (l_pid), l_pcle, 0, 'N', 'O', 0, 0, 'M', p_ligne.dpcode, p_ligne.pnom, p_ligne.typproj, p_ligne.pdatdebpre,
                               p_ligne.arctype, p_ligne.toptri, DECODE (p_ligne.codpspe, '', NULL, ' ', NULL, p_ligne.codpspe), p_ligne.airt,
                               p_ligne.icpi, p_ligne.codsg, p_ligne.pcpi, p_ligne.clicode, p_ligne.clicode_oper, p_ligne.codcamo, p_ligne.pnmouvra,
                               p_ligne.pzone, p_ligne.metier, p_ligne.pobjet,decode(p_ligne.codcamo,66666,'A_RENSEIGNER',null),decode(l_dbs_obligatoire_varchar,'TRUE',p_ligne.dbs,null),l_astatut
                              );
                  --ABN PPM 59138 - FIN

                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Type', NULL, p_ligne.typproj, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Typologie', NULL, p_ligne.arctype, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'CA payeur', NULL, p_ligne.codcamo, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Top fermeture', NULL, 'N', 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Code métier', NULL, p_ligne.metier, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                     'CREATION MASSE',
                                                     'Code application',
                                                     NULL,
                                                     p_ligne.airt,
                                                     'Création de la ligne BIP'
                                                    );
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                     'CREATION MASSE',
                                                     'Code dossier projet',
                                                     NULL,
                                                     p_ligne.dpcode,
                                                     'Création de la ligne BIP'
                                                    );
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Code projet', NULL, p_ligne.icpi, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                     'CREATION MASSE',
                                                     'Code DPG fornisseur',
                                                     NULL,
                                                     TO_NUMBER (p_ligne.codsg),
                                                     'Création de la ligne BIP'
                                                    );
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                     'CREATION MASSE',
                                                     'Code chef de projet',
                                                     NULL,
                                                     p_ligne.pcpi,
                                                     'Création de la ligne BIP'
                                                    );
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Code client', NULL, p_ligne.clicode, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                     'CREATION MASSE',
                                                     'Code client oper',
                                                     NULL,
                                                     p_ligne.clicode_oper,
                                                     'Création de la ligne BIP'
                                                    );
                  if (p_ligne.codcamo = 66666) THEN
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                     'CREATION MASSE',
                                                     'codrep',
                                                     NULL,
                                                     'A_RENSEIGNER',
                                                     'Création de la ligne BIP'
                                                    );
                END IF;
				--ABN PPM 59138 - DEBUT
                IF (l_statut = 'O' AND p_ligne.arctype = 'T1' AND  p_ligne.typproj = '1') THEN
                    --DBMS_OUTPUT.PUT_LINE('l_statut333: '||l_statut);
                      pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Statut', NULL, 'O', 'Création de la ligne BIP');
                END IF;
				--ABN PPM 59138 - FIN





                      --SEL 26/06/2014 PPM 58143 QC 1627
                 select decode(l_dbs_obligatoire_varchar,'TRUE',p_ligne.dbs,null) into l_dbs_logs from dual;
                 pack_ligne_bip.maj_ligne_bip_logs(l_pid, 'CREATION MASSE', 'Code DBS', NULL,l_dbs_logs, 'Création de la ligne BIP');
                  
                  --SEL PPM 64405
                  pack_ligne_bip.maj_ligne_bip_logs(l_pid,'CREATION MASSE','Paramètre local',null,p_ligne.pzone,'Création de la ligne BIP');
                  
                  UPDATE ligne_bip_maj_masse
                     SET pid = l_pid
                   WHERE id_sequence = p_ligne.id_sequence;

                 INSERT INTO TRAIT_BATCH_RETOUR
                           (ID_TRAIT_BATCH,  DATA, ERREUR )
                    VALUES (p_id_batch,
                             l_pid || t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                            || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                            || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                            , ' '
                           );

                  IF (l_budget = 0)
                  THEN
                     INSERT INTO budget
                                 (pid, annee, bpmontme, ubpmontme, bpdate
                                 )
                          VALUES (RTRIM (l_pid), p_ligne.annee, p_ligne.prop_four, 'MAJ MAS', SYSDATE
                                 );

                     pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                        'CREATION MASSE',
                                                        'Prop four ' || p_ligne.annee,
                                                        NULL,
                                                        p_ligne.prop_four,
                                                        'Création proposé fournisseur'
                                                       );
                  END IF;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                    l_liberreur := SQLERRM;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH,  DATA, ERREUR )
                          VALUES (p_id_batch,
                                t_separateur ||  p_ligne.pnom || t_separateur || p_ligne.typproj || t_separateur || p_ligne.pdatdebpre || t_separateur || p_ligne.arctype || t_separateur || p_ligne.toptri || t_separateur || p_ligne.codpspe || t_separateur || p_ligne.airt
                                  || t_separateur ||  p_ligne.icpi || t_separateur || p_ligne.codsg || t_separateur || p_ligne.pcpi || t_separateur || p_ligne.clicode || t_separateur || p_ligne.clicode_oper || t_separateur || p_ligne.codcamo || t_separateur || p_ligne.pnmouvra
                                  || t_separateur ||  p_ligne.metier || t_separateur || p_ligne.pobjet || t_separateur || p_ligne.dpcode || t_separateur || p_ligne.pzone || t_separateur || p_ligne.dbs || t_separateur || p_ligne.annee || t_separateur || p_ligne.prop_four
                                  , l_liberreur
                                 );
               END;

            -- erreur
            ELSE

                UPDATE TRAIT_BATCH
                SET TOP_ANO = 'O'
                WHERE ID_TRAIT_BATCH = p_id_batch;

            END IF;


END insert_ligne_bip;

PROCEDURE insert_ligne_bip_pp
   IS
      l_pid         VARCHAR2 (4);                                                               -- variable locale pid (p_pid ne peut etre lue (OUT))
      l_pcle        VARCHAR2 (3);
      l_dpcode      NUMBER;
      l_erreur      NUMBER;
      l_presence    NUMBER;
      l_liberreur   VARCHAR2 (500);
      l_annee_ref   NUMBER (4);
      l_budget      NUMBER;
      l_actif       VARCHAR2 (1);
   BEGIN
      DECLARE
         CURSOR c_bip
         IS
            SELECT pnom, TRIM (typproj) typproj, pdatdebpre, TRIM (arctype) arctype, toptri, codpspe, airt, icpi, codsg, pcpi, clicode, clicode_oper,
                   codcamo, pnmouvra, UPPER(TRIM (metier)) metier, pobjet, TRIM (dpcode) dpcode, TRIM (pzone) pzone, annee, prop_four, id_sequence num_seq
              FROM ligne_bip_pp_pid;
      BEGIN
         DELETE FROM ligne_bip_pp_pid_rejet;

         COMMIT;

         SELECT TO_NUMBER (TO_CHAR (datdebex, 'YYYY'))
           INTO l_annee_ref
           FROM datdebex;

         FOR un_bip IN c_bip
         LOOP
                --
                -- Calculer le pid et la cle de controle pcle
                l_erreur := 0;
                l_presence := 0;
            -- initialisation de l_budget à 1 (top de mise à jour de la table budget)
            l_budget := 1;

            IF (un_bip.annee IS NOT NULL OR un_bip.prop_four IS NOT NULL)
            THEN
               IF (un_bip.annee IS NULL AND un_bip.prop_four IS NOT NULL) OR (un_bip.annee IS NOT NULL AND un_bip.prop_four IS NULL)
               THEN
                  l_erreur := 1;

                  INSERT INTO ligne_bip_pp_pid_rejet
                              (pid, pnom, typproj, pdatdebpre, arctype, toptri, codpspe, airt,
                               icpi, codsg, pcpi, clicode, clicode_oper, codcamo, pnmouvra,
                               metier, pobjet, dpcode, pzone, annee, prop_four,
                               erreur
                              )
                       VALUES (NULL, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre, un_bip.arctype, un_bip.toptri, un_bip.codpspe, un_bip.airt,
                               un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo, un_bip.pnmouvra,
                               un_bip.metier, un_bip.pobjet, un_bip.dpcode, un_bip.pzone, un_bip.annee, un_bip.prop_four,
                               'Annee vide ou proposé vide'
                              );
               END IF;

               IF (l_erreur = 0)
               THEN
                  IF (un_bip.annee < l_annee_ref - 1 OR un_bip.annee > l_annee_ref + 3)
                  THEN
                     l_erreur := 1;

                     INSERT INTO ligne_bip_pp_pid_rejet
                                 (pid, pnom, typproj, pdatdebpre, arctype, toptri, codpspe, airt,
                                  icpi, codsg, pcpi, clicode, clicode_oper, codcamo, pnmouvra,
                                  metier, pobjet, dpcode, pzone, annee, prop_four, erreur
                                 )
                          VALUES (NULL, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre, un_bip.arctype, un_bip.toptri, un_bip.codpspe, un_bip.airt,
                                  un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo, un_bip.pnmouvra,
                                  un_bip.metier, un_bip.pobjet, un_bip.dpcode, un_bip.pzone, un_bip.annee, un_bip.prop_four, 'Annee incorrecte'
                                 );
                  ELSIF (un_bip.prop_four < 0)
                  THEN
                     l_erreur := 1;

                     INSERT INTO ligne_bip_pp_pid_rejet
                                 (pid, pnom, typproj, pdatdebpre, arctype, toptri, codpspe, airt,
                                  icpi, codsg, pcpi, clicode, clicode_oper, codcamo, pnmouvra,
                                  metier, pobjet, dpcode, pzone, annee, prop_four, erreur
                                 )
                          VALUES (NULL, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre, un_bip.arctype, un_bip.toptri, un_bip.codpspe, un_bip.airt,
                                  un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo, un_bip.pnmouvra,
                                  un_bip.metier, un_bip.pobjet, un_bip.dpcode, un_bip.pzone, un_bip.annee, un_bip.prop_four, 'budget incorrect'
                                 );
                  END IF;

                  -- on bascule l_budget à 0 car il n'y a pas d'erreur concernant l'année et le proposé fournisseur
                  -- permet donc de déclencher la mise à jour de la table budget sous reserve des contrôles ci-dessous.
                  l_budget := 0;
               END IF;
            END IF;

            IF (l_erreur = 0)
            THEN
               BEGIN
                  SELECT icodproj
                    INTO l_dpcode
                    FROM proj_info
                   WHERE icpi = un_bip.icpi;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;

                     INSERT INTO ligne_bip_pp_pid_rejet
                                 (pid, pnom, typproj, pdatdebpre, arctype, toptri, codpspe, airt,
                                  icpi, codsg, pcpi, clicode, clicode_oper, codcamo, pnmouvra,
                                  metier, pobjet, dpcode, pzone, annee, prop_four, erreur
                                 )
                          VALUES (NULL, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre, un_bip.arctype, un_bip.toptri, un_bip.codpspe, un_bip.airt,
                                  un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo, un_bip.pnmouvra,
                                  un_bip.metier, un_bip.pobjet, un_bip.dpcode, un_bip.pzone, un_bip.annee, un_bip.prop_four, 'projet inexistant'
                                 );
               END;
            END IF;

            IF (l_erreur = 0)
            THEN
               IF (un_bip.arctype != 'T1')
               THEN
                  IF (l_dpcode != 0 OR un_bip.dpcode != 0)
                  THEN
                     l_erreur := 1;

                     INSERT INTO ligne_bip_pp_pid_rejet
                                 (pid, pnom, typproj, pdatdebpre, arctype, toptri, codpspe, airt,
                                  icpi, codsg, pcpi, clicode, clicode_oper, codcamo, pnmouvra,
                                  metier, pobjet, dpcode, pzone, annee, prop_four,
                                  erreur
                                 )
                          VALUES (NULL, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre, un_bip.arctype, un_bip.toptri, un_bip.codpspe, un_bip.airt,
                                  un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo, un_bip.pnmouvra,
                                  un_bip.metier, un_bip.pobjet, un_bip.dpcode, un_bip.pzone, un_bip.annee, un_bip.prop_four,
                                  'ligne non T1 : le DP de la ligne et/ou du projet associé doit être 0 '
                                 );
                  END IF;
               ELSE
                  IF (l_dpcode = 0 OR un_bip.dpcode = 0)
                  THEN
                     l_erreur := 1;

                     INSERT INTO ligne_bip_pp_pid_rejet
                                 (pid, pnom, typproj, pdatdebpre, arctype, toptri, codpspe, airt,
                                  icpi, codsg, pcpi, clicode, clicode_oper, codcamo, pnmouvra,
                                  metier, pobjet, dpcode, pzone, annee, prop_four,
                                  erreur
                                 )
                          VALUES (NULL, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre, un_bip.arctype, un_bip.toptri, un_bip.codpspe, un_bip.airt,
                                  un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo, un_bip.pnmouvra,
                                  un_bip.metier, un_bip.pobjet, un_bip.dpcode, un_bip.pzone, un_bip.annee, un_bip.prop_four,
                                  'Ligne T1 : le DP de la ligne et du projet associé doit être différent de 0 '
                                 );
                  END IF;

                  -- TEST de verification si le dossier projet de la ligne est ouvert
                  IF (l_erreur = 0)
                  THEN
                     BEGIN
                        SELECT actif
                          INTO l_actif
                          FROM dossier_projet
                         WHERE dpcode = un_bip.dpcode;

                        IF l_actif = 'N'
                        THEN
                           l_erreur := 1;

                           INSERT INTO ligne_bip_pp_pid_rejet
                                       (pid, pnom, typproj, pdatdebpre, arctype, toptri, codpspe,
                                        airt, icpi, codsg, pcpi, clicode, clicode_oper, codcamo,
                                        pnmouvra, metier, pobjet, dpcode, pzone, annee, prop_four,
                                        erreur
                                       )
                                VALUES (NULL, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre, un_bip.arctype, un_bip.toptri, un_bip.codpspe,
                                        un_bip.airt, un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo,
                                        un_bip.pnmouvra, un_bip.metier, un_bip.pobjet, un_bip.dpcode, un_bip.pzone, un_bip.annee, un_bip.prop_four,
                                        'Le dossier projet est inactif'
                                       );
                        END IF;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           l_erreur := 1;

                           INSERT INTO ligne_bip_pp_pid_rejet
                                       (pid, pnom, typproj, pdatdebpre, arctype, toptri, codpspe,
                                        airt, icpi, codsg, pcpi, clicode, clicode_oper, codcamo,
                                        pnmouvra, metier, pobjet, dpcode, pzone, annee, prop_four,
                                        erreur
                                       )
                                VALUES (NULL, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre, un_bip.arctype, un_bip.toptri, un_bip.codpspe,
                                        un_bip.airt, un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo,
                                        un_bip.pnmouvra, un_bip.metier, un_bip.pobjet, un_bip.dpcode, un_bip.pzone, un_bip.annee, un_bip.prop_four,
                                        'Le dossier projet n''existe pas'
                                       );
                     END;
                  END IF;

                  -- verifie si le code dossier projet et le code projet sont bien lié dans la table proj_info
                  IF (l_erreur = 0)
                  THEN
                     BEGIN
                        SELECT 1
                          INTO l_presence
                          FROM proj_info
                         WHERE icodproj = un_bip.dpcode AND icpi = un_bip.icpi;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           l_erreur := 1;

                           INSERT INTO ligne_bip_pp_pid_rejet
                                       (pid, pnom, typproj, pdatdebpre, arctype, toptri, codpspe,
                                        airt, icpi, codsg, pcpi, clicode, clicode_oper, codcamo,
                                        pnmouvra, metier, pobjet, dpcode, pzone, annee, prop_four,
                                        erreur
                                       )
                                VALUES (NULL, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre, un_bip.arctype, un_bip.toptri, un_bip.codpspe,
                                        un_bip.airt, un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo,
                                        un_bip.pnmouvra, un_bip.metier, un_bip.pobjet, un_bip.dpcode, un_bip.pzone, un_bip.annee, un_bip.prop_four,
                                        'Le dossier projet et le projet de la ligne ne sont pas lié'
                                       );
                     END;
                  END IF;
               END IF;
            END IF;

            BEGIN
               SELECT COUNT (*)
                 INTO l_presence
                 FROM metier
                WHERE TRIM (metier) = TRIM (un_bip.metier);
            END;

            IF (l_presence = 0 AND l_erreur = 0)
            THEN
               l_erreur := 1;

               INSERT INTO ligne_bip_pp_pid_rejet
                           (pid, pnom, typproj, pdatdebpre, arctype, toptri, codpspe, airt,
                            icpi, codsg, pcpi, clicode, clicode_oper, codcamo, pnmouvra,
                            metier, pobjet, dpcode, pzone, annee, prop_four, erreur
                           )
                    VALUES (NULL, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre, un_bip.arctype, un_bip.toptri, un_bip.codpspe, un_bip.airt,
                            un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo, un_bip.pnmouvra,
                            un_bip.metier, un_bip.pobjet, un_bip.dpcode, un_bip.pzone, un_bip.annee, un_bip.prop_four, 'Metier'
                           );
            END IF;

            IF (l_erreur = 0)
            THEN
               BEGIN
                  pack_ligne_bip.calcul_pid (l_pid);
                  pack_ligne_bip.calcul_cle (RTRIM (l_pid), l_pcle);

                  INSERT INTO ligne_bip
                              (pid, pcle, flaglock, topfer, pcactop, pconsn1, pdecn1, petat, dpcode, pnom, typproj, pdatdebpre,
                               arctype, toptri, codpspe, airt,
                               icpi, codsg, pcpi, clicode, clicode_oper, codcamo, pnmouvra,
                               pzone, metier, pobjet
                              )
                       VALUES (RTRIM (l_pid), l_pcle, 0, 'N', 'O', 0, 0, 'M', un_bip.dpcode, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre,
                               un_bip.arctype, un_bip.toptri, DECODE (un_bip.codpspe, '', NULL, ' ', NULL, un_bip.codpspe), un_bip.airt,
                               un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo, un_bip.pnmouvra,
                               un_bip.pzone, un_bip.metier, un_bip.pobjet
                              );

                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Type', NULL, un_bip.typproj, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Typologie', NULL, un_bip.arctype, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'CA payeur', NULL, un_bip.codcamo, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Top fermeture', NULL, 'N', 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Code métier', NULL, un_bip.metier, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                     'CREATION MASSE',
                                                     'Code application',
                                                     NULL,
                                                     un_bip.airt,
                                                     'Création de la ligne BIP'
                                                    );
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                     'CREATION MASSE',
                                                     'Code dossier projet',
                                                     NULL,
                                                     un_bip.dpcode,
                                                     'Création de la ligne BIP'
                                                    );
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Code projet', NULL, un_bip.icpi, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                     'CREATION MASSE',
                                                     'Code DPG fornisseur',
                                                     NULL,
                                                     TO_NUMBER (un_bip.codsg),
                                                     'Création de la ligne BIP'
                                                    );
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                     'CREATION MASSE',
                                                     'Code chef de projet',
                                                     NULL,
                                                     un_bip.pcpi,
                                                     'Création de la ligne BIP'
                                                    );
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid), 'CREATION MASSE', 'Code client', NULL, un_bip.clicode, 'Création de la ligne BIP');
                  pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                     'CREATION MASSE',
                                                     'Code client oper',
                                                     NULL,
                                                     un_bip.clicode_oper,
                                                     'Création de la ligne BIP'
                                                    );
                                                    
                    --SEL PPM 64405
                  pack_ligne_bip.maj_ligne_bip_logs(l_pid,'CREATION MASSE','Paramètre local',null,un_bip.pzone,'Création de la ligne BIP');                                                 

                  UPDATE ligne_bip_pp_pid
                     SET pid = l_pid
                   WHERE id_sequence = un_bip.num_seq;

                  IF (l_budget = 0)
                  THEN
                     INSERT INTO budget
                                 (pid, annee, bpmontme, ubpmontme, bpdate
                                 )
                          VALUES (RTRIM (l_pid), un_bip.annee, un_bip.prop_four, 'MAJ MAS', SYSDATE
                                 );

                     pack_ligne_bip.maj_ligne_bip_logs (RTRIM (l_pid),
                                                        'CREATION MASSE',
                                                        'Prop four ' || un_bip.annee,
                                                        NULL,
                                                        un_bip.prop_four,
                                                        'Création proposé fournisseur'
                                                       );
                  END IF;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                    l_liberreur := SQLERRM;

                     INSERT INTO ligne_bip_pp_pid_rejet
                                 (pid, pnom, typproj, pdatdebpre, arctype, toptri, codpspe, airt,
                                  icpi, codsg, pcpi, clicode, clicode_oper, codcamo, pnmouvra,
                                  metier, pobjet, dpcode, pzone, erreur
                                 )
                          VALUES (NULL, un_bip.pnom, un_bip.typproj, un_bip.pdatdebpre, un_bip.arctype, un_bip.toptri, un_bip.codpspe, un_bip.airt,
                                  un_bip.icpi, un_bip.codsg, un_bip.pcpi, un_bip.clicode, un_bip.clicode_oper, un_bip.codcamo, un_bip.pnmouvra,
                                  un_bip.metier, un_bip.pobjet, un_bip.dpcode, un_bip.pzone, l_liberreur
                                 );
               END;
            END IF;

            COMMIT;
         END LOOP;

         COMMIT;
    END;
END insert_ligne_bip_pp;


   PROCEDURE insert_ligne_bip_pp_copie
   IS
      l_pid    VARCHAR2 (4);                                                                    -- variable locale pid (p_pid ne peut etre lue (OUT))
      l_pcle   VARCHAR2 (3);
   BEGIN
      DECLARE
         CURSOR c_bip
         IS
            SELECT pid, pnom
              FROM ligne_bip_pp_pid;
      BEGIN
         FOR un_bip IN c_bip
         LOOP
            --
            -- Calculer le pid et la cle de controle pcle
            pack_ligne_bip.calcul_pid (l_pid);
            pack_ligne_bip.calcul_cle (RTRIM (l_pid), l_pcle);

               --
            --
            INSERT INTO bip.ligne_bip
                        (pid, pjcamon1, astatut, adatestatut, ttrmens, ttrfbip, tvaedn, tdebinn, tdatfhp, tdatfhr, tdatfhn, tdatebr, tarcproc,
                         pdatdebpre, pdatfinpre, ptypen1, pcactop, pconsn1, pdecn1, pmoycen, psitded, pnmouvra, pcle, petat, pnom, pcpi, toptri,
                         flaglock, typproj, icpi, codpspe, codcamo, dpcode, codsg, arctype, airt, clicode, pobjet, pzone, topfer, metier, caamort,
                         dureeamort, estimplurian, clicode_oper, sous_type, codrep, p_saisie)
               SELECT RTRIM (l_pid), pjcamon1, astatut, adatestatut, ttrmens, ttrfbip, tvaedn, tdebinn, tdatfhp, tdatfhr, tdatfhn, tdatebr, tarcproc,
                      pdatdebpre, pdatfinpre, ptypen1, pcactop, pconsn1, pdecn1, pmoycen, l.pid, pnmouvra, l_pcle, petat, un_bip.pnom, pcpi, toptri,
                      flaglock, typproj, icpi, codpspe, codcamo, dpcode, codsg, arctype, airt, clicode, pobjet, 'Copie', topfer, metier, caamort,
                      dureeamort, estimplurian, clicode_oper, sous_type, codrep, p_saisie
                 FROM ligne_bip l
                WHERE l.pid = un_bip.pid;
         END LOOP;

         COMMIT;
    END;
END insert_ligne_bip_pp_copie;
END pack_ligne_bip_pp;
/
