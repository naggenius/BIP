
/*
Cre? le 02/02/2010 par ABA
procedure de mise ? jour de ligne bip

Modif
ABA 05/05/2011 modification rgle de traitement du champ pobjet du cas numero 5
ABA 09/05/2011 modification du critre prise en compte de la date de fermeture d'une ligne BIP
ABA 26/05/2011 QC 1199 ajout du cas6  MAJ codcamo
ABA 28/07/2011 QC 1246 ajout du cas 7
ABA 01/08/2011 QC 1247 procdure modification type et typologie ligne bip
ABA 15/03/2012 QC 1305 
BSA 18/04/2012 QC 1382
BSA 14/06/2012 QC 1382
BSA 19/07/2012 QC 1382
ABA 21/12/2012 QC 1399
ABN 18/02/2014 PPM 58078
SEL 30/05/2014 PPM 58143
SEL 01/09/2014 PPM 58986
Updated for USERSTORY 8 02/20/2017

*/

CREATE OR REPLACE PACKAGE     pack_ligne_bip_maj_masse IS

TYPE t_array IS TABLE OF VARCHAR2(600)
   INDEX BY BINARY_INTEGER;

FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array;
  
FUNCTION ctrlMetier(p_cafi STRUCT_INFO.CAFI%TYPE, p_metier LIGNE_BIP.METIER%TYPE) RETURN VARCHAR2;

PROCEDURE maj_masse_ligne_bip ( p_id_batch TRAIT_BATCH.ID_TRAIT_BATCH%TYPE) ;

PROCEDURE maj_masse_ligne_bip_dbs ( p_id_batch TRAIT_BATCH.ID_TRAIT_BATCH%TYPE) ;

PROCEDURE maj_masse_ligne_bip_typo;

PROCEDURE CHECK_LINK_LIGNEAXEMETIER2(LIGNE IN ligne_bip_maj_masse%ROWTYPE,
l_erreur IN OUT number,
p_id_batch in TRAIT_BATCH.ID_TRAIT_BATCH%TYPE);

PROCEDURE INSR_BATCH_RETOUR(p_batch in TRAIT_BATCH.ID_TRAIT_BATCH%TYPE,
p_nom IN VARCHAR2,
p_msg IN varchar2
);

PROCEDURE CHECK_DMPLINK_LIGNE
(LIGNE IN ligne_bip_maj_masse%ROWTYPE,
l_erreur out number,
l_obligatoire out ligne_param_bip.obligatoire%type);

END pack_ligne_bip_maj_masse;
/


CREATE OR REPLACE PACKAGE BODY     pack_ligne_bip_maj_masse
IS


/*
BIP 8 changes for inserting the error messages in TRAIT_BATCH_RETOUR to show it in GUI file
*/
PROCEDURE INSR_BATCH_RETOUR(p_batch in TRAIT_BATCH.ID_TRAIT_BATCH%TYPE,
p_nom IN VARCHAR2,
p_msg IN varchar2
) IS

BEGIN
         begin
      
           INSERT INTO TRAIT_BATCH_RETOUR    (ID_TRAIT_BATCH, DATA, ERREUR)
           VALUES ( p_batch,p_nom ,p_msg );
           EXCEPTION
                    WHEN NO_DATA_FOUND 
                    THEN null;
         end;
end INSR_BATCH_RETOUR;

/*
BIP 8 changes for checking link with DMP - input from the CSV file 
*/

PROCEDURE CHECK_DMPLINK_LIGNE(LIGNE IN ligne_bip_maj_masse%ROWTYPE,l_erreur out number,l_obligatoire out ligne_param_bip.obligatoire%type) IS
l_direction       client_mo.clidir%type;
l_code_action     ligne_param_bip.code_action%type;
l_valeur          ligne_param_bip.valeur%type;

BEGIN       

            BEGIN  --b3
               l_erreur := 1;
              
             SELECT CMO.clidir INTO l_direction FROM client_mo CMO
             WHERE ligne.clicode = CMO.clicode;
            
             SELECT code_action, obligatoire, valeur  
            into l_code_action, l_obligatoire, l_valeur FROM ligne_param_bip 
             WHERE code_action = 'AXEMETIER_'||l_direction  
          and upper(code_version) = 'LI2'||
          -- QC 1993 and QC 1994 change is done to add a 0 to typproj having only one digit 
          decode(length(trim(ligne.typproj)),1,'0'||trim(ligne.typproj),trim(ligne.typproj)) ||upper(trim(ligne.arctype))
          and actif = 'O';
     
          EXCEPTION
          WHEN NO_DATA_FOUND 
          THEN
        
          BEGIN --stb
          l_erreur := 1;

           select SI.coddir into l_direction from struct_info SI where ligne.codsg = SI.codsg;
       
            select code_action, obligatoire, valeur  
            into l_code_action, l_obligatoire, l_valeur 
            from ligne_param_bip 
            where code_action = 'AXEMETIER_'||l_direction 
            and upper(code_version) = 'LI2'||
             -- QC 1993 and QC 1994 change is done to add a 0 to typproj having only one digit 
            decode(length(trim(ligne.typproj)),1,'0'||trim(ligne.typproj),trim(ligne.typproj)) ||upper(trim(ligne.arctype))
            and actif = 'O';
                      
               EXCEPTION
               WHEN NO_DATA_FOUND   
               THEN
                    l_erreur := 0;
                  
                   END;      --stb
      END;--b3
               
END CHECK_DMPLINK_LIGNE;

/*
BIP 8 changes for checking the ligne conditions before inserting the data in to ligne_bip 
Procedue is used in Pack_ligne_bip_pp package
*/

PROCEDURE CHECK_LINK_LIGNEAXEMETIER2(LIGNE IN ligne_bip_maj_masse%ROWTYPE,
l_erreur IN out number,
p_id_batch in TRAIT_BATCH.ID_TRAIT_BATCH%TYPE) IS

l_direction       client_mo.clidir%type;
LigneAxeMet2Long  ligne_bip.lineaxisbusiness2%type;
l_code_action     ligne_param_bip.code_action%type;
l_obligatoire     ligne_param_bip.obligatoire%type;
l_valeur          ligne_param_bip.valeur%type;
l_bbrf            directions.codbr%type;
l_bbrf_cli        directions.codbr%type;
l_bbrf_dpg         directions.codbr%type;
l_valeur_cli VARCHAR2(30);
l_valeur_dpg VARCHAR2(30);
l_actif LIGNE_PARAM_BIP.ACTIF%TYPE;
l_code_version LIGNE_PARAM_BIP.CODE_VERSION%TYPE;
l_dmpnum VARCHAR2(20);



BEGIN  
          
        
/* checking the presence of dmp link  */
      CHECK_DMPLINK_LIGNE(LIGNE,l_erreur ,l_obligatoire);
            
    
     
    IF (l_erreur = 1) THEN--if2
    
        --if1
           IF(upper(l_obligatoire) = 'O' AND (ligne.LINEAXISBUSINESS2 IS NULL OR ligne.LINEAXISBUSINESS2 ='')) THEN
                    
                  l_erreur:=1;
             
                  
                  insr_batch_retour(p_id_batch,ligne.pnom,'La référence de demande est absente, inexistante ou incompatible avec la ligne');
                
           ELSE
      
                BEGIN--b
                      select code_action, code_version, actif, obligatoire, valeur  
                      into l_code_action, l_code_version,l_actif, l_obligatoire, l_valeur 
                      from ligne_param_bip 
                      where code_action = 'DIR-REGLAGES' and code_version = l_direction and actif = 'O';
                 
                EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                        BEGIN
                              select bdclicode into l_valeur_cli from vue_clicode_perimo where clicode = ligne.clicode and codhabili = 'br';
                        EXCEPTION
                        WHEN NO_DATA_FOUND THEN null;
                        END;
                    
                        BEGIN
                               select codbddpg into l_valeur_dpg from vue_dpg_perime where codsg = ligne.codsg and codhabili = 'br';
                        EXCEPTION
                        WHEN NO_DATA_FOUND THEN null;
                        END;
                END ;--b
      
      
        l_bbrf := substr(l_valeur,1,2);        
        l_bbrf_cli := substr(l_valeur_cli,1,2);
        l_bbrf_dpg := substr(l_valeur_dpg,1,2);
      
      
          --1
          if ( (l_bbrf = '03' or l_bbrf_cli = '03' or l_bbrf_dpg ='03') and (upper(ligne.PZONE) = 'TRANSITOIRE' or upper(ligne.PZONE) = 'DEVIS') and ligne.LINEAXISBUSINESS2 != '000000')  then
                    
                      l_erreur:=1;
                     
                      insr_batch_retour(p_id_batch,ligne.pnom,'La référence de demande est absente, inexistante ou incompatible avec la ligne');

          else 
              
              IF ( l_obligatoire = 'O' and ligne.LINEAXISBUSINESS2 != '000000') then
             
                  BEGIN
                 
                  select distinct dmpnum into l_dmpnum from DMP_RESEAUXFRANCE where dmpnum = ligne.LINEAXISBUSINESS2 and upper(ddetype) = 'C';
                  l_erreur := 0;
              
               
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN 
                      l_erreur:=1;
                      insr_batch_retour(p_id_batch,ligne.pnom,'La référence de demande est absente, inexistante ou incompatible avec la ligne');
                 
                  END;
                ELSE 
               
                l_erreur := 0;
               
               
              END IF;
          
        end if;--1
        end if;--if1
        END IF;--if2
                    
  END CHECK_LINK_LIGNEAXEMETIER2;

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
    function isNumeric(x in varchar2) return BOOLEAN as

       -- renvoie TRUE si le paramètre correspond à un nombre
       -- 0 sinon
       nb   number;

    begin
       nb := to_number(x);
       return TRUE;
    exception
       when others then
          return FALSE;
    end;


    FUNCTION ctrlMetier(p_cafi STRUCT_INFO.CAFI%TYPE, p_metier LIGNE_BIP.METIER%TYPE) RETURN VARCHAR2 AS

       -- renvoie OK si le controle metier est OK
       -- FALSE sinon

    CURSOR c_metier_manquant_simple ( t_cafi STRUCT_INFO.CAFI%TYPE, t_metier LIGNE_BIP.METIER%TYPE ) IS
        SELECT DISTINCT rm.CODFEI CODFEI,r.CODFEI CODFEI2
        FROM RUBRIQUE_METIER rm LEFT OUTER JOIN (SELECT r1.CODFEI FROM RUBRIQUE r1 WHERE r1.CAFI = t_cafi) r
                                                ON rm.CODFEI = r.CODFEI
        WHERE rm.METIER = TRIM( t_metier ) AND r.CODFEI IS NULL
        ORDER BY rm.CODFEI;

    t_metier_manquant_simple    c_metier_manquant_simple%ROWTYPE;

    CURSOR c_metier_manquant ( t_cafi STRUCT_INFO.CAFI%TYPE ) IS
        SELECT r.CODFEI
        FROM RUBRIQUE r
        WHERE r.CAFI = t_cafi;

    t_metier_manquant  c_metier_manquant%ROWTYPE;

    t_code_6       BOOLEAN;
    t_code_7_8     BOOLEAN;
    t_rejet_metier BOOLEAN;

    t_retour        VARCHAR2(2);

    BEGIN

        t_rejet_metier  := FALSE;

        CASE

            WHEN TRIM(p_metier) = 'EXP' THEN

                -- Pour le metier EXP il faut au moins une des 2 valeurs pour le non rejet .
                t_code_7_8 := FALSE;

                OPEN c_metier_manquant (p_cafi );
                LOOP
                    FETCH c_metier_manquant INTO t_metier_manquant;
                    EXIT WHEN c_metier_manquant%NOTFOUND;

                    IF NVL(t_metier_manquant.CODFEI,-1) = 7 OR NVL(t_metier_manquant.CODFEI,-1) = 8  THEN
                        t_code_7_8 := TRUE;
                    END IF;

                END LOOP;
                CLOSE c_metier_manquant;

                IF t_code_7_8 = TRUE THEN
                    t_rejet_metier  := FALSE;
                ELSE
                    t_rejet_metier  := TRUE;
                END IF;

            WHEN TRIM(p_metier) = 'GAP' OR TRIM(p_metier) = 'SAU' THEN

                -- Pour ces metiers il faut le code fei 6 et (7 ou 8 )
                t_code_7_8 := FALSE;
                t_code_6   := FALSE;
                t_rejet_metier  := TRUE;

                OPEN c_metier_manquant (p_cafi );
                LOOP

                    FETCH c_metier_manquant INTO t_metier_manquant;
                    EXIT WHEN c_metier_manquant%NOTFOUND;

                    IF NVL(t_metier_manquant.CODFEI,-1) = 6 THEN
                        t_code_6 := TRUE;
                    END IF;
                    IF NVL(t_metier_manquant.CODFEI,-1) = 7 OR NVL(t_metier_manquant.CODFEI,-1) = 8  THEN
                        t_code_7_8 := TRUE;
                    END IF;


                END LOOP;
                CLOSE c_metier_manquant;

                IF  t_code_6 = TRUE AND t_code_7_8 = TRUE THEN
                    t_rejet_metier  := FALSE;
                END IF;

            WHEN TRIM(p_metier) = 'ME' OR TRIM(p_metier) = 'MO' OR TRIM(p_metier) = 'HOM' THEN

                OPEN c_metier_manquant_simple (p_cafi,p_metier) ;
                LOOP
                    FETCH c_metier_manquant_simple INTO t_metier_manquant_simple;
                    EXIT WHEN c_metier_manquant_simple%NOTFOUND;

                    -- rejet
                    t_rejet_metier  := TRUE;

                END LOOP;
                CLOSE c_metier_manquant_simple;

            ELSE
                NULL;
        END CASE;

        IF t_rejet_metier = TRUE THEN
            -- REJET
            t_retour := 'KO';
        ELSE
            t_retour := 'OK';
        END IF;

        RETURN t_retour;

    EXCEPTION
       WHEN others THEN
          RETURN 'KO';
    END;

   PROCEDURE maj_masse_ligne_bip ( p_id_batch TRAIT_BATCH.ID_TRAIT_BATCH%TYPE)
   IS
/* 8 cas possible :
1   : Insertion en masse des lignes
2   : maj du cpident des lignes
3   : maj de la date de fermeture des lignes
4   : maj du dpg de la ligne
5   : maj du dpg du cpident du nom de la ligne et du commentaire
6   : maj du codcamo des lignes
7   : maj du proposé fournisseur pour une ligne et une année
8   : Copie du Proposé fournisseur d'une année source vers le Proposé fournisseur de l'année cible (pour sauvegarde)
9   : Copie du Réestimé d'une année source vers le Proposé fournisseur de l'année cible (pour sauvegarde)
10  : maj du code DBS (sous type)

*/
      CURSOR curseur
      IS
      /* PPM 61077 : ajout de distinct pour ne pas avoir des lignes en double */
      /* QC 1704 : Suppression de Distinct pour garder le meme ordre de tri des lignes BIP */
         SELECT *
           FROM ligne_bip_maj_masse;
     
      l_msg         VARCHAR2 (1024);
      l_presence    NUMBER;
      l_pobjet       VARCHAR2(304);
      l_date        DATE;
      l_erreur      NUMBER;
      l_result      NUMBER;
      l_typproj    VARCHAR(3);
      l_arctype VARCHAR(10);
      l_old_codsg   VARCHAR2 (10);
      l_old_pcpi    VARCHAR2 (10);
      l_old_topfer  VARCHAR2(10);
      l_old_astatut VARCHAR2(10);--PPM 61357
      l_old_adatestatut VARCHAR2(10);
      l_old_codcamo VARCHAR2(6);
      l_old_prop_four NUMBER(12,2);
      l_old_codrep ligne_bip.codrep%TYPE;
      l_annee_bip NUMBER(4);

      /*  ABN - HP PPM 61091 */
      --l_client_dbs_obligatoire boolean :=false;
      l_sousType   VARCHAR2 (10);
      l_dbs VARCHAR2 (10);
      l_maj_dbs boolean :=false;
      --l_cliCode VARCHAR2 (10);
      l_clicode_oper VARCHAR2 (10);
      l_result_clicode      NUMBER;
      l_result_clicode_oper      NUMBER;
      l_result_dbs      NUMBER;
      /*  ABN - HP PPM 61091 */

      t_valeur VARCHAR2(400);
      t_message VARCHAR2(400);
      l_presence_dbs number;
      

    CURSOR c_8_9_existe (p_pid BUDGET.PID%TYPE, p_annee BUDGET.ANNEE%TYPE )  IS
        SELECT ANNEE, PID, BNMONT, BPMONTME, BPMONTME2, ANMONT, BPDATE, RESERVE, APDATE, APMONT, BPMONTMO, REESTIME, FLAGLOCK, BPMEDATE, BNDATE, REDATE, UBPMONTME, UBPMONTMO, UBNMONT, UANMONT, UREESTIME
        FROM BUDGET b
        WHERE b.PID = p_pid
            AND b.ANNEE = p_annee;

    t_8_9_source c_8_9_existe%ROWTYPE;
    t_8_9_cible c_8_9_existe%ROWTYPE;

    t_cafi      STRUCT_INFO.CAFI%TYPE;
    t_metier    LIGNE_BIP.METIER%TYPE;
    t_camo      LIGNE_BIP.CODCAMO%TYPE;
    t_typeProj  LIGNE_BIP.TYPPROJ%TYPE;

    t_date_fermeture    DATE;
    t_presence_retour   BOOLEAN := FALSE;

    l_old_sousType   VARCHAR2 (10);
    t_centractiv      STRUCT_INFO.CENTRACTIV%TYPE;
    
    --SEL 26/06/2014 PPM 58143 QC 1627
    l_client_dbs_obligatoire boolean :=false;
    l_dbs_obligatoire boolean :=false;
    l_typproj12 boolean :=false;
    l_dbs_obligatoire_varchar VARCHAR2(5);
    l_dbs_logs VARCHAR2(5);
    
    t_table         t_array;
    l_clicode CHAR(5);
    
    l_dbs_obligation VARCHAR2(5);
    separateur VARCHAR2(1);

    l_actif VARCHAR2(1);
    L_datdebex datdebex.datdebex%TYPE;
    L_MOISMENS datdebex.MOISMENS%TYPE;
    
     L_cusag CONS_SSTACHE_RES_MOIS.cusag%TYPE; 

    
    
   BEGIN

      DELETE TRAIT_BATCH_RETOUR
      WHERE ID_TRAIT_BATCH = p_id_batch;

      FOR ligne IN curseur
      LOOP
         CASE

            -- Insertion en masse
            WHEN ligne.cas = 1
            THEN
               l_erreur := 0;

l_erreur := 0;
/*Check the existence of the DPG code - BIP-13 - starts*/
/* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                                 /*commented below ligne.pid to fix QC-1984 - because in CASE 1 PID will be null every time*/
                          VALUES ( p_id_batch, /*ligne.pid*/ligne.pnom , 'Code DPG inexistant'
                                 );
               END;

			   /* test de l'existance du codsg_new */
              /* BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg_new;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Nouveau DPG inexistant'
                                 );
               END;*/
			   
			   /*Check the existence of the DPG code - BIP-13 - ends*/
               --KRA 61919 p6.9 : Contrôle du métier
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM dual
                   WHERE INSTR(NVL(pack_liste_rubrique.liste_metiers_autorisees(to_number(ligne.codsg)),trim(ligne.metier)),trim(ligne.metier))>0;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                                 /*commented below ligne.pid to fix QC-1984 - because in CASE 1 PID will be null every time*/
                          VALUES ( p_id_batch, /*ligne.pid*/ligne.pnom, 'CodeMetier incompatible avec le paramétrage de l''entité cliente'
                                 );
               END;
			IF (l_erreur = 0) THEN
				--FAD PPM 63986 : Contrôle de la typologie principale
				BEGIN
					SELECT 1
					INTO l_presence
					FROM TYPE_PROJET
					WHERE TYPPROJ = ligne.TYPPROJ;
				EXCEPTION
					WHEN NO_DATA_FOUND
					THEN
					l_erreur := 1;
					t_presence_retour := TRUE;
					separateur := ';';
           /*commented below to fix QC-1984 - because in CASE 1 PID will be null every time*/
					/*INSERT INTO TRAIT_BATCH_RETOUR
						(ID_TRAIT_BATCH, DATA, ERREUR)
					VALUES ( p_id_batch,
						separateur ||  ligne.pnom || separateur || ligne.typproj || separateur || ligne.pdatdebpre || separateur || ligne.arctype || separateur || ligne.toptri || separateur || ligne.codpspe || separateur || ligne.airt
						|| separateur ||  ligne.icpi || separateur || ligne.codsg || separateur || ligne.pcpi || separateur || ligne.clicode || separateur || ligne.clicode_oper || separateur || ligne.codcamo || separateur || ligne.pnmouvra
						|| separateur ||  ligne.metier || separateur || ligne.pobjet || separateur || ligne.dpcode || separateur || ligne.pzone || separateur || ligne.dbs || separateur || ligne.annee || separateur || ligne.prop_four,
						'Type ligne inconnue'
					);*/
          INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, /*ligne.pid*/ligne.pnom, 'Type ligne inconnue'
					);
				END;
				IF (l_erreur = 0) THEN
					--FAD PPM 63986 : Contrôle de la typologie secondaire
					BEGIN
						SELECT ACTIF
						INTO l_actif
						FROM TYPE_ACTIVITE
						WHERE ARCTYPE = ligne.ARCTYPE;
					EXCEPTION
						WHEN NO_DATA_FOUND
						THEN
						l_erreur := 1;
						t_presence_retour := TRUE;
						separateur := ';';
            /*commented below to fix QC-1984 - because in CASE 1 PID will be null every time*/
						/*INSERT INTO TRAIT_BATCH_RETOUR
							(ID_TRAIT_BATCH, DATA, ERREUR)
						VALUES ( p_id_batch, 
							separateur ||  ligne.pnom || separateur || ligne.typproj || separateur || ligne.pdatdebpre || separateur || ligne.arctype || separateur || ligne.toptri || separateur || ligne.codpspe || separateur || ligne.airt
							|| separateur ||  ligne.icpi || separateur || ligne.codsg || separateur || ligne.pcpi || separateur || ligne.clicode || separateur || ligne.clicode_oper || separateur || ligne.codcamo || separateur || ligne.pnmouvra
							|| separateur ||  ligne.metier || separateur || ligne.pobjet || separateur || ligne.dpcode || separateur || ligne.pzone || separateur || ligne.dbs || separateur || ligne.annee || separateur || ligne.prop_four,
							'Typologie inconnue'
						);*/
             INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, /*ligne.pid*/ligne.pnom, 'Typologie inconnue'
						);
					END;
					IF (l_erreur = 0) THEN
						--FAD PPM 63986 : Contrôle état de la typologie secondaire
						IF (l_actif = 'N') THEN
							l_erreur := 1;
							t_presence_retour := TRUE;
							separateur := ';';
               /*commented below to fix QC-1984 - because in CASE 1 PID will be null every time*/
							/*INSERT INTO TRAIT_BATCH_RETOUR
								(ID_TRAIT_BATCH, DATA, ERREUR)
							VALUES ( p_id_batch,
								separateur ||  ligne.pnom || separateur || ligne.typproj || separateur || ligne.pdatdebpre || separateur || ligne.arctype || separateur || ligne.toptri || separateur || ligne.codpspe || separateur || ligne.airt
								|| separateur ||  ligne.icpi || separateur || ligne.codsg || separateur || ligne.pcpi || separateur || ligne.clicode || separateur || ligne.clicode_oper || separateur || ligne.codcamo || separateur || ligne.pnmouvra
								|| separateur ||  ligne.metier || separateur || ligne.pobjet || separateur || ligne.dpcode || separateur || ligne.pzone || separateur || ligne.dbs || separateur || ligne.annee || separateur || ligne.prop_four,
								'Typologie fermée'
							);*/
              INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, /*ligne.pid*/ligne.pnom, 'Typologie fermée'
							);
						ELSE
							l_erreur := 0;
						END IF;
						IF (l_erreur = 0) THEN
							--FAD PPM 63986 : Contrôle association des typologies primaire et secondaire
							BEGIN
								SELECT 1
								INTO l_actif
								FROM LIEN_TYPES_PROJ_ACT
								WHERE TYPE_ACT = ligne.ARCTYPE
								AND TYPE_PROJ = ligne.TYPPROJ;
							EXCEPTION
								WHEN NO_DATA_FOUND
								THEN
								l_erreur := 1;
								t_presence_retour := TRUE;
								separateur := ';';
                 /*commented below to fix QC-1984 - because in CASE 1 PID will be null every time*/
								/*INSERT INTO TRAIT_BATCH_RETOUR
									(ID_TRAIT_BATCH, DATA, ERREUR)
								VALUES ( p_id_batch,
								separateur ||  ligne.pnom || separateur || ligne.typproj || separateur || ligne.pdatdebpre || separateur || ligne.arctype || separateur || ligne.toptri || separateur || ligne.codpspe || separateur || ligne.airt
								|| separateur ||  ligne.icpi || separateur || ligne.codsg || separateur || ligne.pcpi || separateur || ligne.clicode || separateur || ligne.clicode_oper || separateur || ligne.codcamo || separateur || ligne.pnmouvra
								|| separateur ||  ligne.metier || separateur || ligne.pobjet || separateur || ligne.dpcode || separateur || ligne.pzone || separateur || ligne.dbs || separateur || ligne.annee || separateur || ligne.prop_four,
								'Votre Type ligne et secondaire ne sont pas sensées être associées'
								);*/
                 INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, /*ligne.pid*/ligne.pnom, 'Votre Type ligne et secondaire ne sont pas sensées être associées'
								);
							END;
						END IF;
					END IF;
				END IF;
			END IF;
          
               
            -- s'il y a une erreur on passe à l'enregistrement suivant
                IF (l_erreur = 0)
                  THEN
                     pack_ligne_bip_pp.INSERT_LIGNE_BIP(p_id_batch, ligne );
                     t_presence_retour := TRUE;
                  
                END IF;
            --Fin  KRA 61919
            WHEN ligne.cas = 2
            THEN
               l_erreur := 0;
               l_presence := 0;

               /*Check the existence of the DPG code - BIP-13 - starts*/
/* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
                                 );
               END;

			   /* test de l'existance du codsg_new */
             /*  BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg_new;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Nouveau DPG inexistant'
                                 );
               END;*/
			   
			   /*Check the existence of the DPG code - BIP-13 - ends*/

               /* test de l'existance du chef de projet */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM ressource
                   WHERE ident = ligne.pcpi;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid, 'Code CP inexistant'
                                 );
               END;

               IF (l_erreur = 0)
               THEN
                  BEGIN

                     SELECT pcpi
                       INTO l_old_pcpi
                       FROM ligne_bip
                      WHERE pid = ligne.pid;

                     UPDATE ligne_bip
                        SET pcpi = ligne.pcpi
                     WHERE pid = ligne.pid
                        AND codsg = ligne.codsg
                        AND (   adatestatut IS NULL
                        --SEL PPM 58986 : ligne active au sens de la FI
                             OR adatestatut >= to_date('01/'||to_number(to_char(sysdate,'YYYY')),'MM/YYYY')
                            );

                     l_result := SQL%ROWCOUNT;

                     UPDATE ligne_bip_maj_masse
                        SET resultat = l_result
                      WHERE pid = ligne.pid AND codsg = ligne.codsg;

                     IF l_result = 0
                     THEN
                        t_presence_retour := TRUE;
                        INSERT INTO TRAIT_BATCH_RETOUR
                                    (ID_TRAIT_BATCH, DATA, ERREUR
                                    )
                             VALUES ( p_id_batch, ligne.pid, 'MAJ impossible problème sur le couple ligne/dpg ou Ligne non active'
                                    );
                     ELSE
                        pack_ligne_bip.maj_ligne_bip_logs
                                               (ligne.pid,
                                                'MAJ MASSE',
                                                'PCPI',
                                                l_old_pcpi,
                                                ligne.pcpi,
                                                'Modification de la ligne BIP'
                                               );
                     END IF;
                  END;
               END IF;
            WHEN ligne.cas = 3
            THEN
               l_erreur := 0;

               /*Check the existence of the DPG code - BIP-13 - starts*/
/* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
                                 );
               END;

			   /* test de l'existance du codsg_new */
             /*  BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg_new;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Nouveau DPG inexistant'
                                 );
               END;*/
			   
			   /*Check the existence of the DPG code - BIP-13 - ends*/

               /* test de la pertinence de la date */
               BEGIN
                  SELECT TO_DATE (ligne.dateferm,'MM/YYYY')
                    INTO l_date
                    FROM DUAL;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Mauvaise date de fermeture'
                                 );
               END;


-- Change sysdate by datedebex FIXME
				-- SEL PPM 60949 : Retour arriere pra rapport a la PPM 58986
         
         SELECT datdebex INTO L_datdebex FROM datdebex;	 

               IF (l_date < to_date('12/'||to_number(to_char(L_datdebex,'YYYY')-1),'MM/YYYY') AND l_erreur = 0)
               THEN

                  l_erreur := 1;
                  t_presence_retour := TRUE;

                  INSERT INTO TRAIT_BATCH_RETOUR
                              (ID_TRAIT_BATCH, DATA, ERREUR
                              )
                       VALUES ( p_id_batch, ligne.pid , 'date de fermeture inférieur à décembre N-1'
                              );

               END IF;

-- FIXME Check if the bip line have efforts with date > l_date if yes reject with message : "Modification impossible car des consommés existent au-delà de la date de fermeture demandée"
			   
			    IF (l_erreur = 0) THEN
				
				select NVL(sum(cusag),0) INTO L_cusag from CONS_SSTACHE_RES_MOIS where pid=ligne.pid and l_date < CDEB ;
				
				if L_cusag>0 then 
				l_erreur := 1;
                  t_presence_retour := TRUE;
				
				iNSERT INTO TRAIT_BATCH_RETOUR
                              (ID_TRAIT_BATCH, DATA, ERREUR
                              )
                       VALUES ( p_id_batch, ligne.pid , 'Modification impossible car des consommés existent au-delà de la date de fermeture demandée'
                              );
							  end if;
				END IF;
			   
			   
               IF (l_erreur = 0)
               THEN
                  BEGIN

    SELECT MOISMENS INTO L_MOISMENS FROM DATDEBEX;

                      SELECT topfer, to_char(adatestatut,'DD/MM/YYYY')
                       INTO l_old_topfer, l_old_adatestatut
                       FROM ligne_bip
                      WHERE pid = ligne.pid;

                     UPDATE ligne_bip
                        SET topfer = 'O',
                            adatestatut = to_date(ligne.dateferm,'MM/YYYY')
                       WHERE pid = ligne.pid
                        AND codsg = ligne.codsg
                        AND arctype != 'T1'
                        AND (   adatestatut IS NULL

                             -- FIXME adatestatut >= MOISMENS
                             OR adatestatut >= to_date('12/'||to_number(to_char(L_MOISMENS,'YYYY')-1),'MM/YYYY')
                            );

                     l_result := SQL%ROWCOUNT;

                     UPDATE ligne_bip_maj_masse
                        SET resultat = l_result
                      WHERE pid = ligne.pid AND codsg = ligne.codsg;

                     IF l_result = 0
                     THEN

                        t_presence_retour := TRUE;
                        INSERT INTO TRAIT_BATCH_RETOUR
                                    (ID_TRAIT_BATCH, DATA, ERREUR )
                             VALUES ( p_id_batch, ligne.pid , 'MAJ impossible problème sur le couple ligne/dpg ou Ligne non active ou ligne T1'
                                    );
                     ELSE
                      pack_ligne_bip.maj_ligne_bip_logs
                                              (ligne.pid,
                                               'MAJ MASSE',
                                               'TOPFER',
                                               l_old_topfer,
                                               'O',
                                               'Modification de la ligne BIP'
                                              );
                      pack_ligne_bip.maj_ligne_bip_logs
                                               (ligne.pid,
                                                'MAJ MASSE',
                                                'ADATESTATUT',
                                                l_old_adatestatut,
                                                ligne.dateferm,
                                                'Modification de la ligne BIP'
                                               );
                     END IF;
                  END;
               END IF;
            WHEN ligne.cas = 4
            THEN
               l_presence := 0;
               l_erreur := 0;

               /* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
                                 );
               END;

			   /* test de l'existance du codsg_new */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg_new;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Nouveau DPG inexistant'
                                 );
               END;

--PPM 61077	début		   /* test de l'existance de la ligne Bip (cas 4) */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM LIGNE_BIP
                   WHERE PID = ligne.PID;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Ligne Bip inexistante'
                                 );
               END;
--PPM 61077	fin
                IF (l_erreur = 0) THEN
                    -- Recherche du metier
                    SELECT METIER, CODCAMO, TRIM(TYPPROJ) INTO t_metier, t_camo, t_typeProj FROM LIGNE_BIP WHERE PID = ligne.PID;

                    -- recherche du cafi source QC 1607
                    SELECT decode(s.cafi,'99820',s.centractiv,s.cafi) INTO t_cafi FROM STRUCT_INFO s WHERE s.CODSG = ligne.codsg ;

                       -- Controle metier
                    IF ( t_cafi NOT IN ( 88888, 99999, 99810 ) )
                        AND ( t_camo NOT IN (21000, 22000, 23000, 24000, 25000) )
                        AND t_typeProj NOT IN ('5','7')
                        AND  NOT PACK_LISTE_RUBRIQUE.exister_rubrique_fictive() -- SEL 19/05/2014 PPM 58920 8.5.1
                     THEN
--DBMS_OUTPUT.PUT_LINE('4 IL FAUT CONTROLER');

                        IF ctrlMetier( t_cafi, t_metier ) = 'KO' THEN

                          l_erreur := 1;
                          t_presence_retour := TRUE;
                          INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Rubrique(s) manquante(s) sur le DPG source'
                                 );

                        END IF;

                     END IF;

                    -- recherche du cafi cible QC 1607
                    SELECT decode(s.cafi,'99820',s.centractiv,s.cafi) INTO t_cafi FROM STRUCT_INFO s WHERE s.CODSG = ligne.codsg_new ;
                    -- Controle metier
                    IF ( t_cafi NOT IN ( 88888, 99999, 99810 ) )
                        AND ( t_camo NOT IN (21000, 22000, 23000, 24000, 25000) )
                        AND t_typeProj NOT IN ('5','7')
                        AND  NOT PACK_LISTE_RUBRIQUE.exister_rubrique_fictive() -- SEL 19/05/2014 PPM 58920 8.5.1
                        THEN
--DBMS_OUTPUT.PUT_LINE('4 IL FAUT CONTROLER');

                        IF ctrlMetier( t_cafi, t_metier ) = 'KO' THEN

                          l_erreur := 1;
                          t_presence_retour := TRUE;

                          INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Rubrique(s) manquante(s) sur le DPG cible'
                                 );

                        END IF;

                    END IF;

                END IF;


               IF (l_erreur = 0) THEN

                  BEGIN

                    SELECT codsg
                       INTO l_old_codsg
                       FROM ligne_bip
                      WHERE pid = ligne.pid;

                     UPDATE ligne_bip
                        SET codsg = ligne.codsg_new
                      WHERE pid = ligne.pid
                        AND codsg = ligne.codsg
                        AND (   adatestatut IS NULL
                        --SEL PPM 58986 : ligne active au sens de la FI
                             OR adatestatut >= to_date('01/'||to_number(to_char(sysdate,'YYYY')),'MM/YYYY')
                            );

                     l_result := SQL%ROWCOUNT;

                     UPDATE ligne_bip_maj_masse
                        SET resultat = l_result
                      WHERE pid = ligne.pid AND codsg = ligne.codsg;

                     IF l_result = 0
                     THEN
                        t_presence_retour := TRUE;

                        INSERT INTO TRAIT_BATCH_RETOUR
                                    (ID_TRAIT_BATCH, DATA, ERREUR )
                             VALUES ( p_id_batch, ligne.pid , 'MAJ impossible problème sur le couple ligne/dpg ou Ligne non active'
                                    );
                     ELSE
                        pack_ligne_bip.maj_ligne_bip_logs
                                              (ligne.pid,
                                               'MAJ MASSE',
                                               'CODSG',
                                               l_old_codsg,
                                               ligne.codsg_new,
                                               'Modification de la ligne BIP'
                                              );
                     END IF;
                  END;
               END IF;
            WHEN ligne.cas = 5
            THEN
               l_presence := 0;
               l_erreur := 0;

/*Check the existence of the DPG code - BIP-13 - starts*/
               /* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
                                 );
               END;
			   
			   /*Check the existence of the DPG code - BIP-13 - ends*/
               /* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg_new;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Nouveau DPG inexistant'
                                 );
               END;

               /* test de l'existance du chef de projet */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM ressource
                   WHERE ident = ligne.pcpi;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code CP inexistant'
                                 );
               END;

               /* Test de la présence du pobjet
                s'il existe dans le fichier on remplace alors celui de ligne bip
                sinon on laisse celui de la ligne bip */
                BEGIN
                   IF (NVL (LENGTH (TRIM (ligne.pobjet)), 0) <> 0)
                   THEN
                      l_pobjet := ligne.pobjet;
                   ELSE
                      BEGIN
                         SELECT pobjet
                           INTO l_pobjet
                           FROM ligne_bip
                          WHERE pid = ligne.pid;
                      EXCEPTION
                         WHEN NO_DATA_FOUND
                         THEN
                            l_pobjet := NULL;
                      END;
                   END IF;
                END;
--PPM 61077	début		   /* test de l'existance de la ligne Bip (cas 5) */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM LIGNE_BIP
                   WHERE PID = ligne.PID;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Ligne Bip inexistante'
                                 );
               END;
--PPM 61077	fin
                IF (l_erreur = 0) THEN
                    -- Controle metier
                    -- Recherche du metier
                    SELECT METIER, CODCAMO, TRIM(TYPPROJ) INTO t_metier, t_camo, t_typeProj FROM LIGNE_BIP WHERE PID = ligne.PID;

                    -- recherche du cafi source QC 1607
                    SELECT decode(s.cafi,'99820',s.centractiv,s.cafi) INTO t_cafi FROM STRUCT_INFO s WHERE s.CODSG = ligne.codsg ;

                    IF ( t_cafi NOT IN ( 88888, 99999, 99810 ) )
                        AND ( t_camo NOT IN (21000, 22000, 23000, 24000, 25000) )
                        AND t_typeProj NOT IN ('5','7')
                        AND  NOT PACK_LISTE_RUBRIQUE.exister_rubrique_fictive() -- SEL 19/05/2014 PPM 58920 8.5.1
                        THEN
--DBMS_OUTPUT.PUT_LINE('5 IL FAUT CONTROLER');

                        -- Controle metier
                        IF ctrlMetier( t_cafi, t_metier ) = 'KO' THEN

                          l_erreur := 1;
                          t_presence_retour := TRUE;

                          INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Rubrique(s) manquante(s) sur le DPG source'
                                 );

                        END IF;

                    END IF;

                    -- recherche du cafi cible
                    SELECT decode(s.cafi,'99820',s.centractiv,s.cafi) INTO t_cafi FROM STRUCT_INFO s WHERE s.CODSG = ligne.codsg_new ;

                     IF ( t_cafi NOT IN ( 88888, 99999, 99810 ) )
                        AND ( t_camo NOT IN (21000, 22000, 23000, 24000, 25000) )
                        AND t_typeProj NOT IN ('5','7')
                        AND  NOT PACK_LISTE_RUBRIQUE.exister_rubrique_fictive() -- SEL 19/05/2014 PPM 58920 8.5.1
                        THEN
--DBMS_OUTPUT.PUT_LINE('5 IL FAUT CONTROLER');

                        -- Controle metier
                        IF ctrlMetier( t_cafi, t_metier ) = 'KO' THEN

                          l_erreur := 1;
                          t_presence_retour := TRUE;

                          INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Rubrique(s) manquante(s) sur le DPG cible'
                                 );

                        END IF;

                    END IF;

                END IF;

               IF (l_erreur = 0)
               THEN
                  BEGIN
                     SELECT codsg, pcpi
                       INTO l_old_codsg, l_old_pcpi
                       FROM ligne_bip
                      WHERE pid = ligne.pid;

                     UPDATE ligne_bip
                        SET codsg = ligne.codsg_new,
                            pcpi = ligne.pcpi,
                            pnom = ligne.pnom,
                            pobjet = l_pobjet
                      WHERE pid = ligne.pid
                        AND codsg = ligne.codsg
                        AND (   adatestatut IS NULL
                        --SEL PPM 58986 : ligne active au sens de la FI
                             OR adatestatut >= to_date('01/'||to_number(to_char(sysdate,'YYYY')),'MM/YYYY')
                            );

                     l_result := SQL%ROWCOUNT;

                     UPDATE ligne_bip_maj_masse
                        SET resultat = l_result
                      WHERE pid = ligne.pid AND codsg = ligne.codsg;

                     IF l_result = 0
                     THEN
                        t_presence_retour := TRUE;

                        INSERT INTO TRAIT_BATCH_RETOUR
                                    (ID_TRAIT_BATCH, DATA, ERREUR )
                             VALUES ( p_id_batch, ligne.pid , 'MAJ impossible problème sur le couple ligne/dpg ou Ligne non active'
                                    );
                     ELSE
                        pack_ligne_bip.maj_ligne_bip_logs
                                              (ligne.pid,
                                               'MAJ MASSE',
                                               'CODSG',
                                               l_old_codsg,
                                               ligne.codsg_new,
                                               'Modification de la ligne BIP'
                                              );
                        pack_ligne_bip.maj_ligne_bip_logs
                                               (ligne.pid,
                                                'MAJ MASSE',
                                                'PCPI',
                                                l_old_pcpi,
                                                ligne.pcpi,
                                                'Modification de la ligne BIP'
                                               );
                     END IF;
                  END;
               END IF;
            WHEN ligne.cas = 6
            THEN
               l_erreur := 0;
               l_presence := 0;

/*Check the existence of the DPG code - BIP-13 - starts*/
/* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
                                 );
               END;

			   /* test de l'existance du codsg_new */
              /* BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg_new;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Nouveau DPG inexistant'
                                 );
               END;*/
			   
			   /*Check the existence of the DPG code - BIP-13 - ends*/
               /* le codcamo doit être différent de 88888 et 99999 */
               BEGIN
                    IF (ligne.codcamo = 88888 or ligne.codcamo=99999 ) then

                     l_erreur := 1;
                     t_presence_retour := TRUE;

                      INSERT INTO TRAIT_BATCH_RETOUR
                                     (ID_TRAIT_BATCH, DATA, ERREUR
                                     )
                              VALUES ( p_id_batch, ligne.pid , 'Code CAMO doit être différent de ' || ligne.codcamo
                                     );
                    END IF;
               END;

             IF (l_erreur = 0) THEN

                IF (ligne.codcamo = 66666)THEN
                      BEGIN
                        select trim(typproj) , arctype into l_typproj, l_arctype from ligne_bip where pid = ligne.pid;


                            IF ( l_arctype = 'T1' or  l_typproj in ('7','9') ) THEN
                                      l_erreur := 1;
                                      t_presence_retour := TRUE;

                                      INSERT INTO TRAIT_BATCH_RETOUR
                                                     (ID_TRAIT_BATCH, DATA, ERREUR
                                                     )
                                              VALUES ( p_id_batch, ligne.pid , 'Le Code CAMO 66666 est interdit pour ce type de ligne'
                                                     );
                            END IF;


                            EXCEPTION  WHEN NO_DATA_FOUND
                                THEN
                                    l_erreur := 1;
                                    t_presence_retour := TRUE;

                                INSERT INTO TRAIT_BATCH_RETOUR
                                       (ID_TRAIT_BATCH, DATA, ERREUR
                                       )
                                VALUES ( p_id_batch, ligne.pid, 'Ligne BIP inexistante'
                                       );
                             END;
                END IF;




            END IF;


             IF (l_erreur = 0) THEN
             /* test de l'existance du codcamo */
               BEGIN
                  SELECT CDATEFERM
                    INTO t_date_fermeture
                    FROM centre_activite
                   WHERE codcamo = ligne.codcamo;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code CAMO inexistant'
                                 );
               END;
            END IF;
               -- Controle date fermeture du code camo
               -- Il doit etre superieur au mois en cours
               IF (l_erreur = 0) THEN

                    IF t_date_fermeture IS NOT NULL THEN
                        IF TO_CHAR(t_date_fermeture,'YYYYMM') <= TO_CHAR(SYSDATE,'YYYYMM') THEN

                              l_erreur := 1;
                              t_presence_retour := TRUE;

                              INSERT INTO TRAIT_BATCH_RETOUR
                                             (ID_TRAIT_BATCH, DATA, ERREUR
                                             )
                                      VALUES ( p_id_batch, ligne.pid , 'Le Code CAMO est fermé'
                                             );
                        END IF;

                    END IF;

               END IF;



               IF (l_erreur = 0)
               THEN
                  BEGIN
                    BEGIN
                     SELECT to_char(codcamo), codrep
                       INTO l_old_codcamo,l_old_codrep
                       FROM ligne_bip
                      WHERE pid = ligne.pid;
                      EXCEPTION
                        when NO_DATA_FOUND then
                         null;
                      end;
                     UPDATE ligne_bip
                        SET codcamo = ligne.codcamo, codrep = decode(ligne.codcamo,66666,'A_RENSEIGNER',null)
                     WHERE pid = ligne.pid
                        AND codsg = ligne.codsg
                        AND (   adatestatut IS NULL
                        --SEL PPM 58986 : ligne active au sens de la FI
                             OR adatestatut >= to_date('01/'||to_number(to_char(sysdate,'YYYY')),'MM/YYYY')
                            );

                     l_result := SQL%ROWCOUNT;

                     UPDATE ligne_bip_maj_masse
                        SET resultat = l_result
                      WHERE pid = ligne.pid AND codsg = ligne.codsg;

                     IF l_result = 0
                     THEN
                        t_presence_retour := TRUE;

                        INSERT INTO TRAIT_BATCH_RETOUR
                                    (ID_TRAIT_BATCH, DATA, ERREUR )
                             VALUES ( p_id_batch, ligne.pid , 'MAJ impossible problème sur le couple ligne/dpg ou Ligne non active'
                                    );
                     ELSE
                        pack_ligne_bip.maj_ligne_bip_logs
                                               (ligne.pid,
                                                'MAJ MASSE',
                                                'CODCAMO',
                                                l_old_codcamo,
                                                to_char(ligne.codcamo),
                                                'Modification de la ligne BIP'
                                               );
                         IF (ligne.codcamo = 66666)THEN
                                 pack_ligne_bip.maj_ligne_bip_logs
                                               (ligne.pid,
                                                'MAJ MASSE',
                                                'CODREP',
                                                l_old_codrep,
                                                'A_RENSEIGNER',
                                                'Modification de la ligne BIP'
                                               );
                         END IF;

                     END IF;
                  END;
               END IF;
          WHEN ligne.cas = 7
            THEN
               l_erreur := 0;
               l_presence := 0;
/*Check the existence of the DPG code - BIP-13 - starts*/
/* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
                                 );
               END;

			   /* test de l'existance du codsg_new */
              /* BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg_new;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Nouveau DPG inexistant'
                                 );
               END;*/
			   
			   /*Check the existence of the DPG code - BIP-13 - ends*/

               /* verifie si proposé fournisseur est positif */
               BEGIN
               IF (ligne.prop_four < 0 or ligne.prop_four is null )    THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Proposé fourn négatif ou inexistant'
                                 );
                END IF;
               END;

               -- verifie si l'année saisie est entre N-1 et N+3

                IF (l_erreur = 0) THEN
                    BEGIN
                        select to_number(to_char(datdebex,'YYYY')) into l_annee_bip from datdebex;
                    /* bip 155 - check for 4 number condition in annee
                    */
                    IF ( isNumeric ( ligne.ANNEE ) = FALSE OR INSTR(ligne.ANNEE,',') > 0  OR INSTR(ligne.ANNEE,'.') > 0 or length(ligne.ANNEE) <> 4 ) THEN
    
                        l_erreur := 1;
                        t_presence_retour := TRUE;

                        INSERT INTO TRAIT_BATCH_RETOUR
                            (ID_TRAIT_BATCH, DATA, ERREUR
                            )
                        VALUES ( p_id_batch, ligne.pid, 'L''année budget mentionnée est incorrecte'
                            );

                
                       ELSE
                    
                        IF (ligne.annee < l_annee_bip -1 or ligne.annee > l_annee_bip +3 or ligne.annee is null) THEN
                             l_erreur := 1;
                             t_presence_retour := TRUE;

                            INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                             VALUES ( p_id_batch, ligne.pid , 'Année budget invalide ou inexistante'
                                 );
                        END IF;
                      END IF;
                      --BIP 155
                    END;
                END IF;

             -- verifie si la ligne bip existe, avec le bon dpg et active au sens FI
               IF (l_erreur = 0) THEN

                BEGIN  select 1 into l_presence
                 from ligne_bip
                 WHERE pid = ligne.pid
                    AND codsg = ligne.codsg
                    AND (   adatestatut IS NULL
                          OR
                         --SEL PPM 58986 : ligne active au sens de la FI
                         adatestatut >= to_date('01/'||to_number(to_char(sysdate,'YYYY')),'MM/YYYY')
                         );
                EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                         l_erreur := 1;
                         t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                            (ID_TRAIT_BATCH, DATA, ERREUR )
                     VALUES ( p_id_batch, ligne.pid  , 'MAJ budget impossible problème sur le couple ligne/dpg ou Ligne non active'
                            );
                    END;

               END IF;


                IF (l_erreur = 0)
               THEN

                  BEGIN
                     BEGIN
                     SELECT BPMONTME
                       INTO l_old_prop_four
                       FROM budget
                      WHERE pid = ligne.pid
                      and annee = ligne.annee;
                        EXCEPTION WHEN
                        NO_DATA_FOUND THEN
                            l_old_prop_four := null;
                       END;


                  MERGE INTO BUDGET s
                  USING (select ligne.pid, ligne.annee from dual)
                  ON (s.pid = ligne.pid and s.annee = ligne.annee)
                  WHEN MATCHED THEN -- Si Vraie
                     UPDATE SET s.BPMONTME = ligne.prop_four, s.UBPMONTME = 'MAJ MAS', s.BPDATE = SYSDATE
                  WHEN NOT MATCHED THEN -- Si faux
                    INSERT (s.pid, s.annee,s.BPMONTME,s.ubpmontme,s.bpdate) VALUES ( ligne.pid, ligne.annee,ligne.prop_four,'MAJ MAS',SYSDATE);


                    l_result := SQL%ROWCOUNT;

                     UPDATE ligne_bip_maj_masse
                        SET resultat = l_result
                      WHERE pid = ligne.pid AND codsg = ligne.codsg;

                     IF l_result = 0
                     THEN
                        t_presence_retour := TRUE;

                        INSERT INTO TRAIT_BATCH_RETOUR
                                    (ID_TRAIT_BATCH, DATA, ERREUR )
                             VALUES ( p_id_batch, ligne.pid , 'MAJ impossible ligne budget inexistante'
                                    );
                     ELSE
                        pack_ligne_bip.maj_ligne_bip_logs
                                               (ligne.pid,
                                                'MAJ MASSE',
                                                'Prop four ' || ligne.annee,
                                                to_char(l_old_prop_four),
                                                to_char(ligne.prop_four),
                                                'Modification du budget proposé'
                                               );

                     END IF;
                  END;
               END IF;



           -- Cas 8 et 9
           WHEN ligne.cas IN (8,9)
            THEN

                -- Initialisation
                l_erreur := 0;

                /*Check the existence of the DPG code - BIP-13 - starts*/
/* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
                                 );
               END;

			   /* test de l'existance du codsg_new */
             /*  BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg_new;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Nouveau DPG inexistant'
                                 );
               END;*/
			   
			   /*Check the existence of the DPG code - BIP-13 - ends*/

               /* test de l'existance de la ligne BIP */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM LIGNE_BIP l
                   WHERE l.PID = ligne.PID;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Ligne Bip inexistant'
                                 );


               END;


                -- Verifie si le code DPG est celui de la ligne
                -- verifie si la ligne bip existe, avec le bon dpg et active au sens FI
                IF (l_erreur = 0) THEN
                   BEGIN  select 1 into l_presence
                    from ligne_bip
                    WHERE pid = ligne.pid
                       AND codsg = ligne.codsg

                       AND (   adatestatut IS NULL
                            OR
                            --SEL PPM 58986 : ligne active au sens de la FI
                            adatestatut >= to_date('01/'||to_number(to_char(sysdate,'YYYY')),'MM/YYYY')
                           );
                   EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                            l_erreur := 1;
                            t_presence_retour := TRUE;

                        INSERT INTO TRAIT_BATCH_RETOUR
                               (ID_TRAIT_BATCH, DATA, ERREUR
                               )
                        VALUES ( p_id_batch, ligne.pid, 'Le code DPG doit etre celui de la ligne'
                               );
                   END;
                END IF;

               --bip 155 to check 4 digit for ligne anne cible
               -- Verifie si l'année source est numerique
                IF ( isNumeric ( ligne.ANNEE ) = FALSE OR INSTR(ligne.ANNEE,',') > 0  OR INSTR(ligne.ANNEE,'.') > 0 or length(ligne.ANNEE) <> 4 ) THEN

                    l_erreur := 1;
                    t_presence_retour := TRUE;

                    INSERT INTO TRAIT_BATCH_RETOUR
                        (ID_TRAIT_BATCH, DATA, ERREUR
                        )
                    VALUES ( p_id_batch, ligne.pid, 'L''année budget mentionnée est incorrecte'
                        );

                END IF;

                IF ligne.ANNEE IS NULL OR ligne.ANNEE = '' THEN
                    l_erreur := 1;
                    t_presence_retour := TRUE;

                    INSERT INTO TRAIT_BATCH_RETOUR
                        (ID_TRAIT_BATCH, DATA, ERREUR
                        )
                    VALUES ( p_id_batch, ligne.pid, 'Année budget vide'
                        );
                END IF;


              --bip 155 to check 4 digit for ligne anne cible
               -- Verifie si l'année cible est numerique
               IF ( isNumeric ( ligne.ANNEE_CIBLE ) = FALSE OR INSTR(ligne.ANNEE_CIBLE,',') > 0  OR INSTR(ligne.ANNEE_CIBLE,'.') > 0 or length(ligne.ANNEE_CIBLE) <> 4 ) THEN

                    l_erreur := 1;
                    t_presence_retour := TRUE;

                    INSERT INTO TRAIT_BATCH_RETOUR
                        (ID_TRAIT_BATCH, DATA, ERREUR
                        )
                    VALUES ( p_id_batch, ligne.pid, 'L''année cible mentionnée est incorrecte'
                        );

                END IF;

                IF ( ligne.ANNEE_CIBLE IS NULL OR ligne.ANNEE_CIBLE = '' ) THEN

                    l_erreur := 1;
                    t_presence_retour := TRUE;

                    INSERT INTO TRAIT_BATCH_RETOUR
                        (ID_TRAIT_BATCH, DATA, ERREUR
                        )
                    VALUES ( p_id_batch, ligne.pid, 'Année budget cible vide'
                        );

                END IF;


                -- Verifie si l'année cible >= source
                IF (l_erreur = 0) THEN
                    IF (ligne.annee_cible < ligne.annee ) THEN

                        l_erreur := 1;
                        t_presence_retour := TRUE;

                        INSERT INTO TRAIT_BATCH_RETOUR
                             (ID_TRAIT_BATCH, DATA, ERREUR
                             )
                         VALUES ( p_id_batch, ligne.pid, 'L''Année cible doit être supérieure à l''Année budget'
                             );

                    END IF;
                END IF;

                -- Traitement
                IF (l_erreur = 0) THEN

                    -- controle existance propose fournisseur source
                    OPEN c_8_9_existe ( ligne.PID, ligne.annee );
                    FETCH c_8_9_existe INTO t_8_9_source;

                    -- si source non trouve on ne fait rien
                    IF c_8_9_existe%FOUND THEN
                        CLOSE c_8_9_existe;

                        -- recherche cible
                        OPEN c_8_9_existe ( ligne.PID, ligne.annee_cible );
                        FETCH c_8_9_existe INTO t_8_9_cible;

                        -- Modification
                        IF c_8_9_existe%FOUND THEN

                            -- Cas 8 : Propose fournisseur
                            IF ( ligne.cas = 8 ) THEN
                                UPDATE BUDGET b SET
                                            b.BPMONTME = t_8_9_source.BPMONTME,
                                            BPDATE = SYSDATE,
                                            UBPMONTME = 'MAJ MAS'
                                WHERE b.PID = ligne.PID
                                    AND b.ANNEE = ligne.annee_cible;

                                -- MAJ des logs
                                pack_ligne_bip.maj_ligne_bip_logs
                                                       (ligne.pid,
                                                        'COPIE en MASSE',
                                                        'BPMONTME ' || ligne.annee_cible,
                                                        TO_CHAR(t_8_9_cible.BPMONTME),
                                                        TO_CHAR(t_8_9_source.BPMONTME),
                                                        'Modification du budget proposé'
                                                       );

                            -- Cas 9 : REESTIME
                            ELSE
                                UPDATE BUDGET b SET
                                            b.REESTIME = t_8_9_source.REESTIME,
                                            REDATE = SYSDATE,
                                            UREESTIME = 'MAJ MAS'
                                WHERE b.PID = ligne.PID
                                    AND b.ANNEE = ligne.annee_cible;

                                -- MAJ des logs
                                pack_ligne_bip.maj_ligne_bip_logs
                                                       (ligne.pid,
                                                        'COPIE en MASSE',
                                                        'REESTIME ' || ligne.annee_cible,
                                                        TO_CHAR(t_8_9_cible.REESTIME),
                                                        TO_CHAR(t_8_9_source.REESTIME),
                                                        'Modification du budget reestime'
                                                       );
                            END IF;

                        -- Insert
                        ELSE
                            -- Propose fournisseur
                            IF ( ligne.cas = 8 ) THEN

                                INSERT INTO BUDGET (pid, annee, BPMONTME, UBPMONTME, BPDATE)
                                VALUES ( ligne.pid, ligne.annee_cible, t_8_9_source.BPMONTME, 'MAJ MAS',SYSDATE);

                                -- MAJ des logs
                                pack_ligne_bip.maj_ligne_bip_logs
                                                       (ligne.pid,
                                                        'COPIE en MASSE',
                                                        'BPMONTME ' || ligne.annee_cible,
                                                        NULL,
                                                        TO_CHAR(t_8_9_source.BPMONTME),
                                                        'Copie du budget propose fournisseur'
                                                       );

                            -- REESTIME
                            ELSE

                                INSERT INTO BUDGET (pid, annee, REESTIME, UREESTIME, REDATE)
                                VALUES ( ligne.pid, ligne.annee_cible, t_8_9_source.REESTIME, 'MAJ MAS',SYSDATE);

                                -- MAJ des logs
                               pack_ligne_bip.maj_ligne_bip_logs
                                                     (ligne.pid,
                                                        'COPIE en MASSE',
                                                        'REESTIME ' || ligne.annee_cible,
                                                        NULL,
                                                        TO_CHAR(t_8_9_source.REESTIME),
                                                        'Copie du budget reestime'
                                                        );

                            END IF;


                        END IF;

                        CLOSE c_8_9_existe;

                    ELSE
                        CLOSE c_8_9_existe;
                    END IF;

                -- si pas d'erreur
                END IF;

				--SEL PPM 58143
                 WHEN ligne.cas = 10
           THEN
               l_presence := 0;
               l_erreur := 0;

/*Check the existence of the DPG code - BIP-13 - starts*/
/* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
                                 );
               END;

			   /* test de l'existance du codsg_new */
           /*    BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg_new;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Nouveau DPG inexistant'
                                 );
               END;*/
			   
			   /*Check the existence of the DPG code - BIP-13 - ends*/

			   /* test de l'existance de la ligne BIP */
               BEGIN

                  SELECT 1,typproj,clicode
                    INTO l_presence,l_typproj,l_clicode
                    FROM LIGNE_BIP l
                   WHERE l.PID = ligne.PID;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                                 /*Commented to maintain common description - qc-1984*/
                          VALUES ( p_id_batch, ligne.pid , 'Ligne Bip inexistante'/*'action demandée sur une ligne Bip inexistante'*/
                                 );


               END;

               /* test de l'existance du dpg */
                 IF (l_erreur = 0) THEN
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'action demandée avec un DPG inconnu ou fermé'
                                 );
               END;

			   /* test de l'existance du DBS */
           IF (l_erreur = 0) THEN
               -- SEL 28/05/2014 PPM 58143 8.6
    -- Recherche du parametre applicatif OBLIGATION-DBS
    PACK_LIGNE_BIP.RECUPERER_PARAM_APP('OBLIGATION-DBS','DEFAUT','1',t_valeur,t_message);

	-- Si le parametre OBLIGATION-DBS n existe pas
    IF t_message IS NOT NULL
    THEN
                 l_erreur := 1;
                 t_presence_retour := TRUE;
                 INSERT INTO TRAIT_BATCH_RETOUR
                            (ID_TRAIT_BATCH,  DATA, ERREUR )
                     VALUES (p_id_batch,ligne.pid, 'Le paramètre applicatif OBLIGATION-DBS est absent'
                            );
    -- Sinon le parametre OBLIGATION-DBS existe bien
    ELSE

    -- Tester si le client possede comme direction rendant le DBS obligatoire ou non.
   l_client_dbs_obligatoire := pack_ligne_bip.est_client_dbs(l_clicode);
   l_typproj12 := trim(l_typproj) = '1' OR trim(l_typproj) = '2';
   l_dbs_obligatoire := l_typproj12  AND l_client_dbs_obligatoire;

        IF(l_typproj12) THEN
		 IF(ligne.dbs IS NULL) THEN
			 l_erreur := 1;

			 t_presence_retour := TRUE;
			 INSERT INTO TRAIT_BATCH_RETOUR
					(ID_TRAIT_BATCH,  DATA, ERREUR )
			 VALUES (p_id_batch,ligne.pid, 'Le DBS est obligatoire pour cette action, et n''a pas été fourni'
					);
		 ELSE
				IF(l_client_dbs_obligatoire)THEN
						BEGIN
                  SELECT 1
                    INTO l_presence_dbs
                    FROM SOUS_TYPOLOGIE
                   WHERE sous_type = ligne.dbs;
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

                 t_presence_retour := TRUE;
                 INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES (p_id_batch,ligne.pid, 'Le DBS fourni n''est pas autorisée'
                                 );


                 END IF;
				ELSE
					l_erreur := 1;
					t_presence_retour := TRUE;
					INSERT INTO TRAIT_BATCH_RETOUR
							(ID_TRAIT_BATCH, DATA, ERREUR)
					VALUES (p_id_batch,ligne.pid, 'Cette ligne ne gère pas le DBS en raison de son contexte');
				END IF;
		 END IF;
	ELSE
	l_erreur := 1;
	t_presence_retour := TRUE;
		INSERT INTO TRAIT_BATCH_RETOUR
				(ID_TRAIT_BATCH, DATA, ERREUR)
		VALUES (p_id_batch,ligne.pid, 'Cette ligne ne gère pas le DBS en raison de son contexte');
END IF;

     END IF;
			   /* test de présence du DBS dans la ligne BIP en cours */
           IF (l_erreur = 0) THEN
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM LIGNE_BIP
                   WHERE pid = ligne.pid
                  AND (sous_type is null OR sous_type != ligne.dbs);

               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                /** IF(l_dbs_obligatoire = false) THEN
                 l_erreur := 0;

                 END IF;*/

                 IF(l_erreur = 1) THEN

                 t_presence_retour := TRUE;
                 INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Ligne non traitée car le DBS est identique à l''existant'
                                 );

                 END IF;

               END;


               IF (l_erreur = 0) THEN

                  BEGIN

                    SELECT sous_type
                       INTO l_old_sousType
                       FROM ligne_bip
                      WHERE pid = ligne.pid;

--Si le DBS n est pas obligatoire et non null, peu importe la valeur du DBS (correcte ou non)
                 IF(l_dbs_obligatoire = false) THEN
                 UPDATE ligne_bip
                        SET sous_type = null
                      WHERE pid = ligne.pid
                        AND codsg = ligne.codsg;
                ELSE
                     UPDATE ligne_bip
                        SET sous_type = ligne.dbs
                      WHERE pid = ligne.pid
                        AND codsg = ligne.codsg;

                END IF;
                     l_result := SQL%ROWCOUNT;


                     UPDATE ligne_bip_maj_masse
                        SET resultat = l_result
                      WHERE pid = ligne.pid AND codsg = ligne.codsg;

                     IF l_result = 0
                     THEN
                        t_presence_retour := TRUE;

                        INSERT INTO TRAIT_BATCH_RETOUR
                                    (ID_TRAIT_BATCH, DATA, ERREUR )
                             VALUES ( p_id_batch, ligne.pid , 'action demandée sur une ligne dont le DPG indiqué ne correspond pas'
                                    );
                     ELSE

                        IF(l_dbs_obligatoire = false) THEN
                        pack_ligne_bip.maj_ligne_bip_logs
                                              (ligne.pid,
                                               'MAJ EN MASSE',
                                               'Code DBS',
                                               l_old_sousType,
                                               null,
                                               'Modification de la ligne BIP '
                                              );
                        ELSE

                                              pack_ligne_bip.maj_ligne_bip_logs
                                              (ligne.pid,
                                               'MAJ EN MASSE',
                                               'Code DBS',
                                               l_old_sousType,
                                               ligne.dbs,
                                               'Modification de la ligne BIP '
                                              );
                       END IF;


                     END IF;
                  END;
               END IF;
                                END IF;
                                 END IF;
                                 END IF;
            /*  ABN - HP PPM 61091 */
WHEN ligne.cas = 11
THEN
   l_presence := 0;
   l_erreur := 0;
   l_maj_dbs := false; /* ABN - QC 1706  */
   l_result_clicode := 0; /* ABN - QC 1708-1709  */
   l_result_clicode_oper := 0; /* ABN - QC 1708-1709  */
   l_result_dbs := 0; /* ABN - QC 1708-1709  */
   
   /*Check the existence of the DPG code - BIP-13 - starts*/
/* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
                                 );
               END;

			   /* test de l'existance du codsg_new */
             /*  BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg_new;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Nouveau DPG inexistant'
                                 );
               END;*/
			   
			   /*Check the existence of the DPG code - BIP-13 - ends*/
         
   /* test de l'existance de la ligne BIP */
   BEGIN
		SELECT 1, trim(typproj), sous_type, clicode, clicode_oper
		INTO l_presence, l_typproj, l_sousType, l_cliCode, l_clicode_oper
		FROM LIGNE_BIP
		WHERE PID = ligne.PID;
   EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
	 l_erreur := 1;
	 t_presence_retour := TRUE;

	 INSERT INTO TRAIT_BATCH_RETOUR
				 (ID_TRAIT_BATCH, DATA, ERREUR
				 )
		  VALUES ( p_id_batch, ligne.pid , 'Ligne Bip inexistante'
				 );
   END;
 --ZAA PPM 61695
   separateur := '';
   PACK_LIGNE_BIP.RECUPERER_PARAM_APP('OBLIGATION-DBS','DEFAUT','1',t_valeur,t_message);
   PACK_LIGNE_BIP.RECUPERER_SEPAR_PARAM_APP('OBLIGATION-DBS','DEFAUT',1,separateur,t_message);
    --t_table := SPLIT(t_valeur,',');
    t_table := SPLIT(t_valeur,separateur);
    l_dbs_obligation:=t_table(1);
   /* test de l'existance du dpg */
	IF (l_erreur = 0) THEN

	   BEGIN
		  SELECT 1
			INTO l_presence
			FROM struct_info
		   WHERE codsg = ligne.codsg;
	   EXCEPTION
		  WHEN NO_DATA_FOUND
		  THEN
			 l_erreur := 1;
			 t_presence_retour := TRUE;

			 INSERT INTO TRAIT_BATCH_RETOUR
						 (ID_TRAIT_BATCH, DATA, ERREUR
						 )
				  VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
						 );
	   END;
	   IF (l_erreur = 0) THEN

			IF ((ligne.CLICODE IS NULL OR ligne.CLICODE = '') AND (ligne.CLICODE_OPER IS NULL OR ligne.CLICODE_OPER = '')) THEN
				l_erreur := 1;
				t_presence_retour := TRUE;

				INSERT INTO TRAIT_BATCH_RETOUR
					(ID_TRAIT_BATCH, DATA, ERREUR
					)
				VALUES ( p_id_batch, ligne.pid, 'Il faut désigner au moins 1 des 2 nouveaux CodMO'
					);
			END IF;

	   --DBMS_OUTPUT.PUT_LINE('CAS 11 - avant test de presence clicode');
		   IF (l_erreur = 0) THEN
        --DBMS_OUTPUT.PUT_LINE('ligne.CLICODE: '||ligne.CLICODE);
				IF (ligne.CLICODE IS NOT NULL) THEN

				   BEGIN
					  SELECT 1
						INTO l_presence
						FROM CLIENT_MO
					   WHERE CLICODE = ligne.CLICODE
						 AND CLITOPF = 'O';
				   EXCEPTION
					  WHEN NO_DATA_FOUND
					  THEN
						 l_erreur := 1;
						 t_presence_retour := TRUE;

						 INSERT INTO TRAIT_BATCH_RETOUR
									 (ID_TRAIT_BATCH, DATA, ERREUR
									 )
							  VALUES ( p_id_batch, ligne.pid , 'Nouveau CodMO inconnu ou fermé'
									 );
				   END;


				END IF;

				IF (l_erreur = 0) THEN
					IF (ligne.CLICODE_OPER IS NOT NULL) THEN
					   BEGIN
						  SELECT 1
							INTO l_presence
							FROM CLIENT_MO
						   WHERE CLICODE = ligne.CLICODE_OPER
							 AND CLITOPF = 'O';
					   EXCEPTION
						  WHEN NO_DATA_FOUND
						  THEN
							 l_erreur := 1;
							 t_presence_retour := TRUE;

							 INSERT INTO TRAIT_BATCH_RETOUR
										 (ID_TRAIT_BATCH, DATA, ERREUR
										 )
								  VALUES ( p_id_batch, ligne.pid , 'Nouveau CodMO_Oper inconnu ou fermé'
										 );
					   END;
					END IF;
					IF (l_erreur = 0) THEN
						IF (ligne.CLICODE IS NOT NULL) THEN
								IF ( l_typproj in ('1','2') ) THEN
									-- Tester si le client possede comme direction rendant le DBS obligatoire ou non.
									l_client_dbs_obligatoire := pack_ligne_bip.est_client_dbs(ligne.clicode);
									IF (l_client_dbs_obligatoire) THEN
                    --DBMS_OUTPUT.PUT_LINE('Avant 2 l_client_dbs_obligatoire');
										IF(ligne.dbs IS NULL OR ligne.dbs = '') THEN
											IF ((l_sousType IS NULL OR l_sousType = '') AND (l_dbs_obligation = 'OUI')) THEN
												l_erreur := 1;
												t_presence_retour := TRUE;
												INSERT INTO TRAIT_BATCH_RETOUR
														(ID_TRAIT_BATCH,  DATA, ERREUR )
												VALUES (p_id_batch,ligne.pid, 'Cette ligne impose un DBS');
											ELSE
												IF ((l_sousType IS NOT NULL OR l_sousType != '') AND (l_dbs_obligation = 'NON')) THEN
													l_erreur := 0;			
												END IF;
											END IF;
										ELSE
                      --DBMS_OUTPUT.PUT_LINE('apres 2 l_client_dbs_obligatoire');
											l_dbs := UPPER(REGEXP_REPLACE(CONVERT(ligne.dbs, 'US7ASCII'), '[^A-Za-z0-9]', ''));
											BEGIN
											  SELECT 1
												INTO l_presence_dbs
												FROM SOUS_TYPOLOGIE
											    WHERE sous_type = l_dbs;
										    EXCEPTION
												WHEN NO_DATA_FOUND
												THEN
													l_erreur := 1;
													t_presence_retour := TRUE;

													INSERT INTO TRAIT_BATCH_RETOUR
														(ID_TRAIT_BATCH, DATA, ERREUR)
														VALUES ( p_id_batch, ligne.pid , 'DBS inconnu');
											END;
											IF (l_erreur = 0) THEN
												l_maj_dbs := true;
											END IF;
										END IF;
									END IF;
								END IF;
						END IF;
					END IF;
				END IF;
		   END IF;
	   END IF;
	END IF;
	IF (l_erreur = 0) THEN
	IF (ligne.CLICODE IS NOT NULL AND l_clicode != ligne.CLICODE) THEN
			UPDATE ligne_bip
				SET CLICODE = ligne.CLICODE
			    WHERE pid = ligne.pid AND codsg = ligne.codsg;

			l_result_clicode := SQL%ROWCOUNT;
  ELSE
     IF (l_clicode = ligne.CLICODE) THEN
        l_erreur := 1;
        t_presence_retour := TRUE;
        INSERT INTO TRAIT_BATCH_RETOUR
            (ID_TRAIT_BATCH,  DATA, ERREUR )
        VALUES (p_id_batch,ligne.pid, 'Le code client principal chargé est identique de l''existant'
            );
     END IF;
		END IF;

    IF (l_erreur = 0) THEN
      IF (ligne.CLICODE_OPER IS NOT NULL AND l_clicode_oper != ligne.CLICODE_OPER) THEN
        UPDATE ligne_bip
          SET CLICODE_OPER = ligne.CLICODE_OPER
            WHERE pid = ligne.pid AND codsg = ligne.codsg;

        l_result_clicode_oper := SQL%ROWCOUNT;
      ELSE
        IF (l_clicode_oper = ligne.CLICODE_OPER) THEN
          l_erreur := 1;
          t_presence_retour := TRUE;
          INSERT INTO TRAIT_BATCH_RETOUR
              (ID_TRAIT_BATCH,  DATA, ERREUR )
          VALUES (p_id_batch,ligne.pid, 'Le CodMO_Oper chargé est identique de l''existant'
              );
        END IF;
      END IF;
    END IF;

    IF (l_erreur = 0) THEN
      IF (l_maj_dbs = true) THEN
        --DBMS_OUTPUT.PUT_LINE('l_maj_dbs OK');
        UPDATE ligne_bip
          SET sous_type = l_dbs
            WHERE pid = ligne.pid AND codsg = ligne.codsg;

        l_result_dbs := SQL%ROWCOUNT;
      END IF;
    END IF;
    IF (l_erreur = 0) THEN
      IF (l_result_clicode + l_result_dbs + l_result_clicode_oper = 0)
         THEN

          UPDATE ligne_bip_maj_masse
            SET resultat = '0'
            WHERE pid = ligne.pid AND codsg = ligne.codsg;

          t_presence_retour := TRUE;
          INSERT INTO TRAIT_BATCH_RETOUR
                (ID_TRAIT_BATCH, DATA, ERREUR )
             VALUES ( p_id_batch, ligne.pid , 'MAJ impossible problème sur le couple ligne/dpg'
                );
      ELSE

        UPDATE ligne_bip_maj_masse
          SET resultat = '1'
          WHERE pid = ligne.pid AND codsg = ligne.codsg;
        IF (l_result_clicode = 1) THEN
          pack_ligne_bip.maj_ligne_bip_logs
              (ligne.pid,
               'MAJ MASSE',
               'Code client principal',
               l_clicode,
               ligne.CLICODE,
               'Modification de la ligne BIP'
              );
        END IF;

        IF (l_result_dbs = 1) THEN
          pack_ligne_bip.maj_ligne_bip_logs
              (ligne.pid,
               'MAJ MASSE',
               'Code DBS',
               l_sousType,
               l_dbs,
               'Modification de la ligne BIP'
              );
        END IF;

        IF (l_result_clicode_oper = 1) THEN
          pack_ligne_bip.maj_ligne_bip_logs
              (ligne.pid,
               'MAJ MASSE',
               'CLICODE_OPER',
               l_clicode_oper,
               ligne.CLICODE_OPER,
               'Modification de la ligne BIP'
              );
        END IF;

      END IF;
    END IF;
	END IF;
/*  ABN - HP PPM 61091 */
      			/* ABN - HP PPM 61357 - Fermeture des lignes SGSS */
            WHEN ligne.cas = 12
            THEN
               l_erreur := 0;

               /*Check the existence of the DPG code - BIP-13 - starts*/
/* test de l'existance du dpg */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
                                 );
               END;

			   /* test de l'existance du codsg_new */
             /*  BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg_new;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Nouveau DPG inexistant'
                                 );
               END;*/
			   
			   /*Check the existence of the DPG code - BIP-13 - ends*/

			    BEGIN
					select trim(typproj) , arctype into l_typproj, l_arctype from ligne_bip where pid = ligne.pid;


						IF ( l_arctype != 'T1' or l_typproj != '1' ) THEN
								  l_erreur := 1;
								  t_presence_retour := TRUE;

								  INSERT INTO TRAIT_BATCH_RETOUR
												 (ID_TRAIT_BATCH, DATA, ERREUR
												 )
										  VALUES ( p_id_batch, ligne.pid , 'La ligne doit être une GT1'
												 );
						END IF;


						EXCEPTION  WHEN NO_DATA_FOUND
							THEN
								l_erreur := 1;
								t_presence_retour := TRUE;

							INSERT INTO TRAIT_BATCH_RETOUR
								   (ID_TRAIT_BATCH, DATA, ERREUR
								   )
							VALUES ( p_id_batch, ligne.pid, 'Ligne BIP inexistante'
								   );
				END;

               /* test de la pertinence de la date */
			    IF (l_erreur = 0)
                THEN
				   BEGIN
					  SELECT TO_DATE (ligne.dateferm,'MM/YYYY')
						INTO l_date
						FROM DUAL;
				   EXCEPTION
					  WHEN OTHERS
					  THEN
						 l_erreur := 1;
						 t_presence_retour := TRUE;

						 INSERT INTO TRAIT_BATCH_RETOUR
									 (ID_TRAIT_BATCH, DATA, ERREUR
									 )
							  VALUES ( p_id_batch, ligne.pid , 'Mauvaise date de fermeture'
									 );
				   END;
				END IF;
-- Change sysdate by datedebex FIXME
	SELECT datdebex INTO L_datdebex FROM datdebex;	 
               IF (l_date < to_date('12/'||to_number(to_char(L_DATDEBEX,'YYYY')-1),'MM/YYYY') AND l_erreur = 0)
               THEN

                  l_erreur := 1;
                  t_presence_retour := TRUE;

                  INSERT INTO TRAIT_BATCH_RETOUR
                              (ID_TRAIT_BATCH, DATA, ERREUR
                              )
                       VALUES ( p_id_batch, ligne.pid , 'date de fermeture inférieur à décembre N-1'
                              );

               END IF;

-- FIXME Check if the bip line have efforts with date > l_date if yes reject with message : "Modification impossible car des consommés existent au-delà de la date de fermeture demandée"

               
               
               
			    IF (l_erreur = 0) THEN
				
				select NVL(sum(cusag),0) INTO L_cusag from CONS_SSTACHE_RES_MOIS where pid=ligne.pid and l_date < CDEB ;
				
				if L_cusag>0 then 
				l_erreur := 1;
                  t_presence_retour := TRUE;
				
				iNSERT INTO TRAIT_BATCH_RETOUR
                              (ID_TRAIT_BATCH, DATA, ERREUR
                              )
                       VALUES ( p_id_batch, ligne.pid , 'Modification impossible car des consommés existent au-delà de la date de fermeture demandée'
                              );
							  end if;
				END IF;
               
			   
               IF (l_erreur = 0)
               THEN
                  BEGIN


          SELECT MOISMENS INTO L_MOISMENS FROM DATDEBEX;
          
                      SELECT astatut, to_char(adatestatut,'DD/MM/YYYY')
                       INTO l_old_astatut, l_old_adatestatut
                       FROM ligne_bip
                      WHERE pid = ligne.pid;

                     UPDATE ligne_bip
                        SET
                            adatestatut = to_date(ligne.dateferm,'MM/YYYY'),
							astatut = 'C'
                       WHERE pid = ligne.pid
					   -- FIXME 
                        and  astatut = 'O'
                        AND codsg = ligne.codsg
						-- FIXME adatestatut >= MOISMENS
                        AND (   adatestatut IS NULL
                             OR adatestatut >= to_date('12/'||to_number(to_char(L_MOISMENS,'YYYY')-1),'MM/YYYY')
                            );

                     l_result := SQL%ROWCOUNT;

                     UPDATE ligne_bip_maj_masse
                        SET resultat = l_result
                      WHERE pid = ligne.pid AND codsg = ligne.codsg;

                     IF l_result = 0
                     THEN
                        t_presence_retour := TRUE;
                        INSERT INTO TRAIT_BATCH_RETOUR
                                    (ID_TRAIT_BATCH, DATA, ERREUR )
			-- FIXME chnage the message to " MAJ impossible problème sur le couple ligne/dpg ou Ligne non active ou statut actuel n'est pas à O "			
                             VALUES ( p_id_batch, ligne.pid , 'MAJ impossible problème sur le couple ligne/dpg ou Ligne non active ou statut actuel n est pas à O'
                                    );
                     ELSE

					  pack_ligne_bip.maj_ligne_bip_logs
                                              (ligne.pid,
                                               'MAJ MASSE',
                                               'ASTATUT',
                                               l_old_astatut,
                                               'C',
                                               'Modification de la ligne BIP'
                                              );
                      pack_ligne_bip.maj_ligne_bip_logs
                                               (ligne.pid,
                                                'MAJ MASSE',
                                                'ADATESTATUT',
                                                l_old_adatestatut,
                                                ligne.dateferm,
                                                'Modification de la ligne BIP'
                                               );
                     END IF;
                  END;
               END IF;
			/* ABN - HP PPM 61357 - Fermeture des lignes SGSS */

			ELSE
				INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code CAS incohérent'
                                 );

         END CASE;
      END LOOP;


    IF ( t_presence_retour = TRUE ) THEN

        UPDATE TRAIT_BATCH
        SET TOP_RETOUR = 'O'
        WHERE ID_TRAIT_BATCH = p_id_batch;
    END IF;

    IF (l_erreur = 1) THEN

        UPDATE TRAIT_BATCH
        SET TOP_ANO = 'O'
        WHERE ID_TRAIT_BATCH = p_id_batch;

    END IF;


    COMMIT;

   END maj_masse_ligne_bip;

PROCEDURE maj_masse_ligne_bip_dbs ( p_id_batch TRAIT_BATCH.ID_TRAIT_BATCH%TYPE)
   IS
/* 1 cas possible :
10   : maj du DBS sur stock lignes
*/
      CURSOR curseur
      IS
         SELECT *
           FROM ligne_bip_maj_masse_dbs;

      l_presence    NUMBER;
      l_erreur      NUMBER;
      l_result      NUMBER;
      l_old_sousType   VARCHAR2 (10);


    t_presence_retour   BOOLEAN := FALSE;

   BEGIN

      DELETE TRAIT_BATCH_RETOUR
      WHERE ID_TRAIT_BATCH = p_id_batch;

      FOR ligne IN curseur
      LOOP







         CASE

            WHEN ligne.cas = 10
            THEN
               l_presence := 0;
               l_erreur := 0;

			   /* test de l'existance de la ligne BIP */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM LIGNE_BIP l
                   WHERE l.PID = ligne.PID;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Ligne Bip inexistant'
                                 );


               END;

               /* test de l'existance du dpg */
                 IF (l_erreur = 0) THEN
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM struct_info
                   WHERE codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code DPG inexistant'
                                 );
               END;

			   /* test de l'existance du DBS */
           IF (l_erreur = 0) THEN
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM SOUS_TYPOLOGIE
                   WHERE sous_type = ligne.sous_type;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'La valeur de DBS indiquée n''est pas autorisée'
                                 );
               END;

			   /* test de présence du DBS dans la ligne BIP en cours */
           IF (l_erreur = 0) THEN
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM LIGNE_BIP
                   WHERE pid = ligne.pid
                  AND (sous_type is null OR sous_type != ligne.sous_type);

               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;
                     t_presence_retour := TRUE;

                     INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Ligne non traitée car le DBS est identique à l''existant'
                                 );
               END;


               IF (l_erreur = 0) THEN

                  BEGIN

                    SELECT sous_type
                       INTO l_old_sousType
                       FROM ligne_bip
                      WHERE pid = ligne.pid;

                     UPDATE ligne_bip
                        SET sous_type = ligne.sous_type
                      WHERE pid = ligne.pid
                        AND codsg = ligne.codsg;

                     l_result := SQL%ROWCOUNT;

                     UPDATE ligne_bip_maj_masse_dbs
                        SET resultat = l_result
                      WHERE pid = ligne.pid AND codsg = ligne.codsg;

                     IF l_result = 0
                     THEN
                        t_presence_retour := TRUE;

                        INSERT INTO TRAIT_BATCH_RETOUR
                                    (ID_TRAIT_BATCH, DATA, ERREUR )
                             VALUES ( p_id_batch, ligne.pid , 'MAJ impossible problème sur le couple ligne/dpg'
                                    );
                     ELSE
                        pack_ligne_bip.maj_ligne_bip_logs
                                              (ligne.pid,
                                               'MAJ EN MASSE',
                                               'Code DBS',
                                               l_old_sousType,
                                               ligne.sous_type,
                                               'Modification de la ligne BIP '
                                              );
                     END IF;
                  END;
               END IF;
                                END IF;
                                 END IF;
                                 END IF;
			ELSE
				INSERT INTO TRAIT_BATCH_RETOUR
                                 (ID_TRAIT_BATCH, DATA, ERREUR
                                 )
                          VALUES ( p_id_batch, ligne.pid , 'Code CAS incohérent'
                                 );

         END CASE;
      END LOOP;


    IF ( t_presence_retour = TRUE ) THEN

        UPDATE TRAIT_BATCH
        SET TOP_RETOUR = 'O'
        WHERE ID_TRAIT_BATCH = p_id_batch;
    END IF;

    IF (l_erreur = 1) THEN

        UPDATE TRAIT_BATCH
        SET TOP_ANO = 'O'
        WHERE ID_TRAIT_BATCH = p_id_batch;

    END IF;


    COMMIT;

   END maj_masse_ligne_bip_dbs;

PROCEDURE maj_masse_ligne_bip_typo
   IS

      CURSOR curseur
      IS
         SELECT *
           FROM ligne_bip_maj_masse_typo;

      l_msg         VARCHAR2 (1024);
      l_presence    NUMBER;

      l_erreur      NUMBER;
      l_result      NUMBER;

      l_old_typproj  CHAR(2);
      l_old_arctype  VARCHAR2(3);



    BEGIN



        DELETE      ligne_bip_maj_masse_rejet;

          FOR ligne IN curseur
       LOOP
       l_erreur := 0;
      l_presence := 0;
              IF (l_erreur = 0)
               THEN
              /* test de l'existance de la ligne */
               BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM ligne_bip
                   WHERE pid = ligne.pid;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;

                    INSERT INTO ligne_bip_maj_masse_rejet
                                 (pid, MOTIF
                                 )
                          VALUES (ligne.pid, 'ligne inexistante'
                                 );
               END;
               END IF;

                   /* test couple dpg ligne */
              IF (l_erreur = 0)
               THEN
                  BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM ligne_bip
                   WHERE pid = ligne.pid
                   and codsg = ligne.codsg;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;

                     INSERT INTO ligne_bip_maj_masse_rejet
                                (pid, MOTIF
                                 )
                          VALUES (ligne.pid, 'couple ligne/dpg inexistant'
                                 );
               END;
               END IF;

               /* test si la ligne est de type GT1  */
                IF (l_erreur = 0)
                 THEN
                  BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM ligne_bip
                   WHERE pid = ligne.pid
                   and codsg = ligne.codsg
                  and (arctype != 'T1');
                   EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;

                     INSERT INTO ligne_bip_maj_masse_rejet
                                 (pid, MOTIF
                                 )
                          VALUES (ligne.pid, 'La ligne ne doit pas être une GT1'
                                 );
                      END;
                      END IF;

                /* test si la ligne est active */
                IF (l_erreur = 0)
                 THEN
                  BEGIN
                  SELECT 1
                    INTO l_presence
                    FROM ligne_bip
                   WHERE pid = ligne.pid
                   and codsg = ligne.codsg
                   AND (   adatestatut IS NULL
                   --SEL PPM 58986 : ligne active au sens de la FI
                             OR adatestatut >= to_date('01/'||to_number(to_char(sysdate,'YYYY')),'MM/YYYY')
                            );
                   EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;

                     INSERT INTO ligne_bip_maj_masse_rejet
                                 (pid, MOTIF
                                 )
                          VALUES (ligne.pid, 'La ligne n''est pas active'
                                 );
                      END;

                      END IF;


                 /* test de l'existance du typproj*/
                IF (l_erreur = 0)
                 THEN
                  BEGIN
                  SELECT distinct 1
                    INTO l_presence
                    FROM lien_types_proj_act
                   WHERE TYPE_PROJ = ligne.typproj;

                   EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_erreur := 1;

                     INSERT INTO ligne_bip_maj_masse_rejet
                                 (pid, MOTIF
                                 )
                          VALUES (ligne.pid, 'Type inconnu'
                                 );
                      END;

                      END IF;

               /* test de l'existance de la typologie* et du lien type/typologie */
                IF (l_erreur = 0)
                 THEN
                  BEGIN
                  SELECT distinct 1
                    INTO l_presence
                    FROM lien_types_proj_act lt
                   WHERE TYPE_PROJ = ligne.typproj and TYPE_ACT = ligne.arctype;

                   EXCEPTION
                      WHEN NO_DATA_FOUND
                      THEN
                     l_erreur := 1;

                     INSERT INTO ligne_bip_maj_masse_rejet
                                 (pid, MOTIF
                                 )
                          VALUES (ligne.pid, 'Typologie inconnue ou lien type/typologie inexistant'
                                 );
                      END;

                END IF;


                /* update de la ligne*/
                IF (l_erreur = 0)
                 THEN
                  BEGIN
                  SELECT typproj,arctype
                    INTO l_old_typproj,  l_old_arctype
                    FROM ligne_bip
                   WHERE pid = ligne.pid;

                   UPDATE ligne_bip
                   set typproj = ligne.typproj, arctype = ligne.arctype
                   where pid = ligne.pid;

                   l_result := SQL%ROWCOUNT;


                  END;

                      UPDATE ligne_bip_maj_masse_typo
                        SET resultat = l_result
                      WHERE pid = ligne.pid AND codsg = ligne.codsg;


                 pack_ligne_bip.maj_ligne_bip_logs (ligne.pid, 'MAJ MASSE','Typproj',l_old_typproj,
                                                ligne.typproj,'Modification du type');
                 pack_ligne_bip.maj_ligne_bip_logs (ligne.pid, 'MAJ MASSE','Arctype' ,l_old_arctype,
                                                ligne.arctype,'Modification de la typologie');
                     END IF;


        END loop;


    END maj_masse_ligne_bip_typo;

END pack_ligne_bip_maj_masse;
/
