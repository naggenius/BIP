-- Package pour l alimentation des stocks retours arrieres (fiche 54)
-- Créé le 26/03/2007 par BAA
-- modifié le 04/04/2007 par JAL modification fonction integrite_test
-- modifié le 05/04/2007 par DDI modification export contrats
-- modifié le 11/04/2007 par DDI modification export contrats
-- modifié le 11/04/2007 par DDI modification export realises
-- modifié le 16/04/2007 par JAL rajout code forunisseur dans Export contrats
-- modifié le 24/05/2007 par BPO mise à jour des codes directions
-- modifié le 19/05/2007 par JAL nouvelles règles de gestion pour  CONTRAT_RESSOURCE_LOGS
--                                                 et dates début contrat, date fin ligne contrat pour fic sortie 
--                                                de la procédure export_contrat 
-- modifié le 12/06/2007 par JAL : si la société d'une ligne contrat possède déjà un fournisseur EBIS on écrit dans la table de LOGS
--                                                    RPAD de export_contrat et export réalisé remplacé par LPAD
-- modifié le 14/06/2007 par JAL : Mise en commentaire test sur les coûts (demande de la MOE)
-- modifié le 19/06/2007 par JAL : Correction alim_ebis_factures ne fonctionnant plus
-- modifié le 20/06/2007 par JAL : Correction alim_ebis_factures ne fonctionnant plus + ajout TIMESTAMP dans EBIS_FACT_REJET
-- modifié le 09/07/2007 par JAL : Correction alim_ebis_factures , procédure insert_facture : champ FMODREGLT reçoit donnée TOPPOST du fichier reçu
-- modifié le 10/07/2007 par DDI : Restriction sur la table de LOG : Lignes contrats valides ou echues depuis moins de 6 mois.
-- modifié le 20/07/2007 par JAL : Correction alim_ebis_factures , procédure insert_facture : prise en compte "." pour champ CUSAG_EXPENSE
-- modifié le 27/07/2007 par JAL : Correction alim_ebis_factures , procédure integrite_test : code retour 23 : teste avec 1° du mois  de début contrat.
-- modifié le 13/09/2007 par EVI : TD580 ajout de 2 champs: NUMENR et TOP_ETAT
-- modifié le 27/09/2007 par DDI : Nous n'envoyons pas les ressources gratuites dans l'export des contrats.
-- modifié le 11/10/2007 par DDI : Suppression controle 19 sur Import facture ET modification export Realise.
-- modifié le 05/11/2007 par DDI : Modification du test d integrite sur la societe fermee (3).
-- modifié le 08/11/2007 par DDI : Suppression des tests d integrite 3, 13, 14, 19 et 26.
--				   Modification de l alimentation des LOGS CONTRATS sur les situations ouvertes.
-- modifié le 22/11/2007 par DDI : Suppression de la notion de douzieme dans les flux contrats et realises.
-- modifié le 11/02/2008 par JAL : fiche 608 export réalisé  (pour ressources en double consommé à 0.001)
-- modifié le 12/02/2008 par JAL : fiche 608 montant à 0.01 en sortie et non .01 pour lignes en double (forçage du 0 devant le point avec to_char)
-- modifié le 19/02/2008 par JAL : fiche 608 rajouté un order by sur le ident aifn regrouper les montants à 0.01 soient regroupés sur le fichier de sortie
-- modifié le 27/02/2008 par JAL : duplication méthode contra_ressource_logs maintenant pour tout le périmètre (demande de Gérard : pas de fiche)
-- modifié le 08/04/2008 par JAL : rajout test dans test sur EBIS_FOURNISSEUR (cas changement société)
-- modifié le 13/03/2008 par JAL : fiche 613 rajout logs TT Ebis non ramassés (non ramassés dans Export_réalisés)
-- modifié le 25/03/2008 par JAL : fiche 613 modif logs TT Ebis (rajout nouvelles colonnes)
-- modifié le 14/04/2008 par EVI : On retire le test sur le taux de TVA
-- modifié le 30/04/2008 par JAL : Correction message erreur
-- modifié le 15/05/2008 par JAL : fiche 644 On remet le test Taux TVA avec tolérance +/- 1 
-- modifié le 15/05/2008 par JAL : fiche 646 conditionnement alim factures EBIS suivant table CALENDRIER
-- modifié le 27/05/2008 par JAL : fiche 646 conditionnement alim factures EBIS suivant table CALENDRIER (modif libellés erreurs)
-- modifié le 28/05/2008 par ABA : duplication des methodes export_realise et export_contrat pour la prise en compte des petimetre bis et ter
-- modifié le 05/06/2008 par JAL :  rajour de compteurs dans méthode alim_factures afin de faire apparaire nb lignes traitées dans bipdata/batch
-- modifié le 21/08/2008 par ABA :  modification des methodes export des contrat et realisé expense avec l'utilisation du système comptable
--Modif   ABA  25-08-2008 : TD 615 
-- modifié le 24/11/2008 par EVI: arrondi du taux de TVA a 1 decimal
-- modifié le 08/12/2008 par ABA: suppression du trunc dans la procedure des rejet contrat pour verfier si la ligne contrat possède une situation ouverte
-- modifié le 08/12/2008 par ABA: TD 727
-- modifié le 03/02/2008 par ABA: TD 743
-- modifié le 04/02/2008 par ABA: TD 744
-- modifié le 06/02/2008 par ABA: TD 743 modification en fonction des nouvelles règles de l'EB
-- modifié le 15/04/2009 par ABA: TD 737  
-- modifié le 15/05/2009 par EVI: Correction des fiche TD 615 (Mise en place table direction) + TD 683 (Gestion des logs pour EXPENSE) 
-- modifié le 21/08/2009 par EVI: TD 792
-- modifié le 12/11/2009 par YNA : TD 877
-- modifié le 12/11/2009 par ABA : retour arrière TD 792
-- modifié le 18/11/2009 par YNA : TD 877 taux TVA avec tolérance de +/- 1


-- modifié le 16/11/2009 par ABA: retour avant TD 792
-- modifié le 25/06/2010 par YSB : Fiche 970 : 4.13
-- modifié le 27/07/2010 par YSB : Fiche 970 : 4.13
-- modifié le 02/08/2010 par YSB : Fiche 970 : 4.13
-- modifié le 23/08/2010 par YSB : Fiche 970 : 4.13
-- modifié le 16/09/2010 par ABA : Fiche 1057
-- modifié le 03/11/2010 par ABA : Fiche 970 prise en compte de la date d'effet D3 pour les rejet sur les code prestations des lignes contrats
-- modifié le 18/05/2011 par BSA : QC 1184
-- modifié le 29/07/2011 par CMA : QC 1159 Paramétrage BIP des exports
-- modifié le 31/12/2011 par ABA : QC 1339 anomalie sur le paramétrage 
-- modifié le 01/02/2012 par ABA : a nomalie sur le paramétrage + optimisation
-- modifié le 14/02/2012 par BSA : Ajout des champs sur le group by
-- modifié le 23/03/2012 par OEL : QC 1388
-- modifié le 18/04/2012 par BSA : QC 1415
-- modifié le 24/04/2012 par OEL : QC 1415

CREATE OR REPLACE PACKAGE "PACK_EXPENSEBIS" AS




----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
PRAGMA EXCEPTION_INIT( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     NUMBER := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     NUMBER := -20001;   -- problème : erreur dans la gestion d'erreur !
ERR_FONCTIONNELLE_ID NUMBER := -20002;   -- pour provoquer erreur alors que Oracle OK
CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
PRAGMA EXCEPTION_INIT( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère





FUNCTION Controle_param_bip(p_coddir IN VARCHAR2,
                            p_mode_contractuel IN VARCHAR2,
                            p_codcamo NUMBER
                            ) RETURN NUMBER;
--****************************************************
-- Procédure export des contrats
--****************************************************
   PROCEDURE export_contrat (
                                                                 p_chemin_fichier IN VARCHAR2,
                                                                 p_nom_fichier    IN VARCHAR2
                                                                 );


--****************************************************
-- Procédure export realise
--****************************************************
   PROCEDURE export_realise(
                                                                 p_chemin_fichier IN VARCHAR2,
                                                                 p_nom_fichier    IN VARCHAR2
                                                                 );


--****************************************************
-- Procédure export des contrats ressources logs
-- pour tout le périmètre expense
--****************************************************
    PROCEDURE CONTRAT_RESSOURCE_REJET(P_LOGDIR          IN VARCHAR2);


--****************************************************
-- Procédure alim ebis factures
--****************************************************
    PROCEDURE alim_ebis_factures(P_LOGDIR          IN VARCHAR2,
                                 p_chemin_fichier        IN VARCHAR2,
                                 p_nom_fichier           IN VARCHAR2) ;

--****************************************************
-- Fonction test integrite
--****************************************************
FUNCTION integrite_test(p_NUMFACT               IN    VARCHAR2,
                                                   p_TYPFACT                 IN    VARCHAR2,
                                                   p_DATFACT                IN   VARCHAR2,
                                                   p_NUMCONT              IN    VARCHAR2,
                                                   p_CAV                            IN    VARCHAR2,
                                                   p_CD_REFERENTIEL     IN    VARCHAR2,
                                                   p_CD_EXPENSE       IN    VARCHAR2,
                                                   p_NUM_EXPENSE   IN    VARCHAR2,
                                                   p_FMONTHT              IN     VARCHAR2,
                                                   p_FMONTTTC            IN    VARCHAR2,
                                                   p_DATE_COMPTA   IN     VARCHAR2,
                                                   p_LNUM                        IN     VARCHAR2,
                                                   p_IDENT                       IN    VARCHAR2,
                                                   p_LMONTHT                         IN  VARCHAR2,
                                                   p_LMOISPREST        IN     VARCHAR2,
                                                   p_CUSAG_EXPENSE  IN  VARCHAR2,
                                                   p_TOPPOST                  IN    VARCHAR2,
                                                   p_SOCCONT                  OUT VARCHAR2,
                                                    p_CCENTREFRAIS    OUT NUMBER,
                                                    p_SOCFOUR                 OUT  VARCHAR2,
                                                    p_TVA                              OUT FACTURE.FTVA%TYPE,
                                                    p_CODCOMPTA          OUT VARCHAR2,
                                                    p_DEPPOLE                  OUT VARCHAR2,
                                                    o_FMONTHT             OUT   FACTURE.FMONTHT%TYPE,
                                                    o_FMONTTTC            OUT   FACTURE.FMONTTTC%TYPE,
                                                    o_FLMONTHT            OUT      LIGNE_FACT.LMONTHT%TYPE

                                                     )  RETURN NUMBER ;




--****************************************************
-- Procédure insertion/update table Factures
--****************************************************
PROCEDURE    insert_facture(p_SOCCODE      IN VARCHAR2,
                                                                                                 p_NUMFACT      IN VARCHAR2,
                                                                                                 p_TYPFACT        IN  CHAR,
                                                               p_DATFACT        IN DATE,
                                                                                                 p_MONTHT         IN VARCHAR2,
                                                               p_MONTTTC       IN VARCHAR2,
                                                             p_NUMCONT      IN VARCHAR2,
                                                             p_CAV                    IN VARCHAR2,
                                                             p_CD_EXPENSE  IN  VARCHAR2,
                                                             p_CUSAG_EXPENSE  IN  VARCHAR2,
                                                             p_NUM_EXPENSE IN VARCHAR2,
                                                             p_DATE_COMPTA IN DATE,
                                                             p_TOPPOST     IN VARCHAR2,
                                                             p_CDEB                    IN DATE,
                                                             p_ccentrefrais       IN NUMBER,
                                                             p_socfour                 IN VARCHAR2,
                                                             p_tva                IN FACTURE.FTVA%TYPE,
                                                             p_codcompta         IN VARCHAR2,
                                                             p_deppole              IN NUMBER
                                                                );


--****************************************************
-- Procédure insertion table  Ligne Factures
--****************************************************
        PROCEDURE    insert_ligne_facture(p_MONTHT            IN LIGNE_FACT.LMONTHT%TYPE,
                                                                         p_codcompta         IN VARCHAR2,
                                                                         p_deppole               IN NUMBER,
                                                                         p_CDEB                    IN DATE,
                                                                         p_SOCCODE          IN VARCHAR2,
                                                                            p_TYPFACT            IN  CHAR,
                                                                         p_DATFACT            IN DATE,
                                                                         p_NUMFACT           IN VARCHAR2,
                                                                         p_tva                          IN NUMBER,
                                                                         p_ident                      IN NUMBER,
                                                                         p_num                        IN NUMBER
                                                                         ) ;



--****************************************************
-- Procédure export facture TT ebis non ramassées
--****************************************************
  PROCEDURE export_tt_rejet(    p_chemin_fichier    IN VARCHAR2,
                  p_nom_fichier        IN VARCHAR2 );

PROCEDURE ecrit_table_rejet_tt(  p_dpg IN        NUMBER   ,
                                  p_soccode IN    CHAR ,
                                  p_ident IN      NUMBER ,
                                  p_rnom IN       VARCHAR2  ,
                                  p_lmoisprest IN DATE,
                                  p_cusag IN       NUMBER ,
                                  p_datdep IN DATE,
                                  p_numcont IN VARCHAR2  ,
                                  p_cav IN VARCHAR2  ,
                                  p_cdatfin IN   DATE,
                                  p_message IN VARCHAR2 ,
                                  p_soccont IN    CHAR,
                                  p_codsg_cont IN NUMBER ,
                                  p_syscomp_cont IN VARCHAR2 ,
                                  p_syscomp_res IN VARCHAR2 ,
                                  p_timestamp IN DATE,
                                  p_code_retour IN NUMBER );


END Pack_Expensebis;
/

create or replace
PACKAGE BODY     PACK_EXPENSEBIS AS


FUNCTION Controle_param_bip(p_coddir IN VARCHAR2,
                            p_mode_contractuel IN VARCHAR2,
                            p_codcamo NUMBER
                            ) RETURN NUMBER IS

   --Curseur sur les paramètres BIP qui régissent les exclusions de l'export Expense
   CURSOR csr_param_bip IS
        select lpb.code_action, lpb.code_version, lpb.valeur, lpb.MULTI, lpb.separateur, lpb.NUM_LIGNE from date_effet de, ligne_param_bip lpb
        where de.code_action = 'FILTRECTRACONSO'
        and de.code_action = lpb.code_action
        and de.code_version = lpb.code_version
        and de.DATE_EFFET <= SYSDATE
        and lpb.NUM_LIGNE = (select MIN(lpb2.num_ligne) from ligne_param_bip lpb2 where lpb2.code_action = 'FILTRECTRACONSO' and lpb2.code_version = de.code_version and lpb2.actif = 'O');


   --Un curseur différent est nécessaire pour les paramètres relatifs aux ES d'une direction
   -- car dans ce cas ilf aut prendre les deux premières lignes actives
   -- ce cas concernce uniquement les ES qui NE SONT PAS LIE a un MC
   CURSOR csr_es_param_bip_non_lie IS
       SELECT   lpb.code_action, lpb.code_version, lpb.num_ligne, lpb.valeur, lpb.multi, lpb.separateur
        FROM date_effet de, ligne_param_bip lpb
       WHERE de.code_action = 'FILTRECTRACONSO'
         AND de.code_action = lpb.code_action
         AND de.code_version = lpb.code_version
         AND de.code_version LIKE 'ES%'
         AND de.date_effet <= SYSDATE
         AND lpb.num_ligne IN (
                SELECT lpb2.num_ligne num_ligne
                  FROM ligne_param_bip lpb2
                 WHERE lpb2.code_action = 'FILTRECTRACONSO'
                   AND lpb2.code_version = de.code_version
                   AND lpb2.actif = 'O'
                   AND lpb2.code_action_lie IS NULL
                   AND ROWNUM <= 2)
       ORDER BY num_ligne;

   --Un curseur différent est nécessaire pour les paramètres relatifs aux ES d'une direction
   -- car dans ce cas ilf aut prendre les deux premières lignes actives
   -- ce cas concernce uniquement les ES qui SONT LIE a un MC
   CURSOR csr_es_param_bip_lie  (p_coddir  VARCHAR, p_num_ligne NUMBER ) IS
    select lpb.code_action, lpb.code_version, lpb.num_ligne, lpb.valeur, lpb.MULTI, lpb.separateur
    from date_effet de, ligne_param_bip lpb
        where de.code_action = 'FILTRECTRACONSO'
        and de.code_action = lpb.code_action
        and de.code_version = lpb.code_version
        and de.code_version LIKE 'ES%'
        and de.DATE_EFFET <= SYSDATE
        and lpb.NUM_LIGNE IN (
        select lpb2.num_ligne num_ligne from ligne_param_bip lpb2 where lpb2.code_action = 'FILTRECTRACONSO'
        and lpb2.code_version = de.code_version and lpb2.actif = 'O'
        and lpb2.CODE_ACTION_LIE = de.code_action and lpb2.CODE_VERSION_LIE = 'MC'||p_coddir and lpb2.NUM_LIGNE_lie = p_num_ligne and ROWNUM<=2
        )
       order by num_ligne;


        v_error        NUMBER(1) ;
        v_str PACK_GLOBAL.t_array;
        v_count NUMBER;
        v_tmp VARCHAR2(30);
        v_es_trouve NUMBER;
        v_contrat_ko_mc NUMBER;
        v_contrat_ko_es NUMBER;
        v_niveau NUMBER;
        niv_rec NUMBER;
        v_commentaire            VARCHAR2(160);
        top_es_lie  NUMBER;
        v_param_ligne_active NUMBER(2);
            TYPE c_cursor IS REF CURSOR; -- Création d'un type CURSOR
    niv1_cur c_cursor;



    BEGIN
 v_error  := 0;

      v_contrat_ko_mc:=0;
        v_contrat_ko_es:=0;


           FOR rec_param_bip IN csr_param_bip LOOP

 v_error  := 0;

      v_contrat_ko_mc:=0;
        v_contrat_ko_es:=0;
          --  insert into test_message (message) values (p_coddir||';'||p_mode_contractuel||';'||p_codcamo);


               BEGIN

                        IF(rec_param_bip.code_version='DIR' AND v_error=0) THEN

                            if(rec_param_bip.multi='O') then
                                v_str := PACK_GLOBAL.split(rec_param_bip.valeur,rec_param_bip.separateur);
                            else
                                v_str(1) := rec_param_bip.valeur;
                            end if;



                            for i in 1..v_str.count loop

                                SELECT COUNT(*) into v_count FROM DIRECTIONS WHERE CODDIR = TO_NUMBER(v_str(i));

                                    IF(v_count<1) THEN
                                            raise_application_error( -20997, 'Erreur dans le paramétrage BIP de l export Expense : FILTRECTRACONSO/DIR est mal configuré. La Direction '||v_str(i)||' n existe pas');
                                            RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID, 'Erreur : consulter le fichier LOG', FALSE );
                                    END IF;

                              if(p_coddir = TO_NUMBER(v_str(i))) THEN

                                    v_commentaire := 'Contrat rejeté d''après les règles d''exclusion du paramétrage BIP FILTRECTRACONSO/DIR. Direction : '||v_str(i);
                                    v_error := 1;

                                END IF;

                                if(v_error=1)then
                                    EXIT;
                                end if;

                            end loop;


                        ELSIF (rec_param_bip.code_version='MC' AND v_error=0) THEN

                            if(rec_param_bip.multi='O') then
                                v_str := PACK_GLOBAL.split(rec_param_bip.valeur,rec_param_bip.separateur);
                            else
                                v_str(1) := rec_param_bip.valeur;
                            end if;

                            for i in 1..v_str.count loop


                                SELECT COUNT(*) into v_count FROM MODE_CONTRACTUEL WHERE CODE_CONTRACTUEL = v_str(i);

                                IF(v_count<1) THEN
                                        raise_application_error( -20997, 'Erreur dans le paramétrage BIP de l export Expense : FILTRECTRACONSO/MC est mal configuré. Le mode contractuel '||v_str(i)||' n existe pas');
                                        RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID, 'Erreur : consulter le fichier LOG', FALSE );
                                END IF;

                              if(p_mode_contractuel = v_str(i)) THEN

                                    v_commentaire := 'Contrat rejeté d''après les règles d''exclusion du paramétrage BIP FILTRECTRACONSO/MC. Mode Contractuel : '||v_str(i);
                                    v_error := 1;

                                END IF;
                                if(v_error=1)then
                                    EXIT;
                                end if;

                            end loop;

                        ELSIF(rec_param_bip.code_version LIKE'MC%' AND LENGTH(rec_param_bip.code_version) >2 AND v_error=0) THEN

                        -- On vérifie d'abord que la direction existe
                            v_tmp := SUBSTR(rec_param_bip.code_version,3);

                            SELECT COUNT(*) into v_count FROM DIRECTIONS WHERE CODDIR = TO_NUMBER(v_tmp);

                              IF(v_count<1) THEN
                                    raise_application_error( -20997, 'Erreur dans le paramétrage BIP de l''export Expense : FILTRECTRACONSO/'||rec_param_bip.code_version||' est mal configuré. La Direction '||v_tmp||' n''existe pas');
                                    RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID, 'Erreur : consulter le fichier LOG', FALSE );
                              END IF;


                        -- On recupère le numero de la ligne du paramètre actif
                            v_param_ligne_active :=  rec_param_bip.NUM_LIGNE;

                             top_es_lie := 0;
                        -- test les paramètres relatifs aux ES des directions lié à un MC
                            FOR rec_param_bip IN csr_es_param_bip_lie(v_tmp, v_param_ligne_active)LOOP

                                -- top indiquant qu'il y un paramètre ES lié avec un paramètre MC
                                 top_es_lie := 1;

                                -- Puis on vérifie les ES
                                v_str.DELETE;
                                if(rec_param_bip.multi='O') then
                                    v_str := PACK_GLOBAL.split(rec_param_bip.valeur,rec_param_bip.separateur);
                                else
                                    v_str(1) := rec_param_bip.valeur;
                                end if;

                                    for i in 1..v_str.count loop

                                      SELECT COUNT(*) into v_count FROM ENTITE_STRUCTURE WHERE CODCAMO = TO_NUMBER(v_str(i));

                                    IF(v_count<1) THEN
                                            raise_application_error( -20997, 'Erreur dans le paramétrage BIP de l''export Expense : FILTRECTRACONSO/'||rec_param_bip.code_version||' est mal configuré. L''ES '||v_str(i)||' n''existe pas');
                                            RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID, 'Erreur : consulter le fichier LOG', FALSE );
                                    END IF;

                                        -- Pour trouver l'ES, on regarde de quel niveau il est, puis on regarde dans centre_activite si le centre_activite
                                        -- du contrat a pour ce niveau là, cet ES. Si c'est le cas, il est exclu
                                        if(p_coddir = v_tmp) THEN
                                            v_es_trouve := 0;
                                            v_niveau := PACK_GLOBAL.recherche_niveau(v_str(i));
                                            if(v_niveau=0)then
                                                if(TO_NUMBER(v_str(i))=p_codcamo)then
                                                    v_es_trouve:=1;
                                                end if;
                                            else
                                                OPEN niv1_cur FOR 'select codcamo FROM centre_activite where caniv'||v_niveau||' = TO_NUMBER('||v_str(i)||')';
                                                   loop
                                                        FETCH niv1_cur INTO niv_rec;
                                                            if(p_codcamo = niv_rec)then
                                                                v_es_trouve:=1;
                                                                EXIT;
                                                            end if;
                                                        EXIT WHEN NOT niv1_cur%FOUND;
                                                   end loop;
                                                CLOSE niv1_cur;

                                            end if;

                                           if(v_es_trouve=1)then
                                                v_commentaire := 'Contrat rejeté d''après les règles d''exclusion du paramétrage BIP FILTRECTRACONSO/'||rec_param_bip.code_version||'. ES : '||v_str(i);
                                                 v_contrat_ko_es := 1;

                                           end if;

                                            END IF;
                                            if( v_contrat_ko_es=1)then
                                                EXIT;
                                            end if;

                                    end loop;


                            END LOOP;


                          -- Puis on vérifie les modes contractuels

                            v_str.DELETE;

                         if(rec_param_bip.multi='O') then
                                v_str := PACK_GLOBAL.split(rec_param_bip.valeur,rec_param_bip.separateur);
                            else
                                v_str(1) := rec_param_bip.valeur;
                            end if;

                            for i in 1..v_str.count loop

                                SELECT COUNT(*) into v_count FROM MODE_CONTRACTUEL WHERE CODE_CONTRACTUEL = v_str(i);

                                IF(v_count<1) THEN
                                        raise_application_error( -20997, 'Erreur dans le paramétrage BIP de l export Expense : FILTRECTRACONSO/MC est mal configuré. Le mode contractuel '||v_str(i)||' n existe pas');
                                        RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID, 'Erreur : consulter le fichier LOG', FALSE );
                                END IF;

                               if(p_mode_contractuel = v_str(i) AND p_coddir = TO_NUMBER(v_tmp)) THEN
                                    v_commentaire := 'Contrat rejeté d''après les règles d''exclusion du paramétrage BIP FILTRECTRACONSO/'||rec_param_bip.code_version||'. Mode Contractuel : '||v_str(i);
                                    v_contrat_ko_mc := 1;

                                END IF;
                                if(v_contrat_ko_mc=1)then
                                     EXIT;
                                end if;

                            end loop;

                            IF (top_es_lie = 1 AND v_contrat_ko_mc = 1 AND v_contrat_ko_es = 1) THEN
                                   v_error := 1;
                            ELSIF (top_es_lie = 0 and  v_contrat_ko_mc = 1) THEN
                               v_error := 1;
                            END IF;


                        END IF;


                        if(v_error=1)then
                            EXIT;
                        end if;

                    END;

                END LOOP;
                IF(v_error=0)THEN
                    -- Puis on teste les paramètres relatifs aux ES des directions non lie à un parametre MC
                    FOR rec_param_bip IN csr_es_param_bip_non_lie LOOP

                        BEGIN

                            -- On vérifie d'abord que la direction existe
                                v_tmp := SUBSTR(rec_param_bip.code_version,3);
                            IF (v_tmp is not null) THEN
                             SELECT COUNT(*) into v_count FROM DIRECTIONS WHERE CODDIR = TO_NUMBER(v_tmp);

                              IF(v_count<1) THEN
                                    raise_application_error( -20997, 'Erreur dans le paramétrage BIP de l''export Expense : FILTRECTRACONSO/'||rec_param_bip.code_version||' est mal configuré. La Direction '||v_tmp||' n''existe pas');
                                    RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID, 'Erreur : consulter le fichier LOG', FALSE );
                              END IF;

                            END IF;

                                v_str.DELETE;

                            -- Puis on vérifie les ES

                                if(rec_param_bip.multi='O') then
                                    v_str := PACK_GLOBAL.split(rec_param_bip.valeur,rec_param_bip.separateur);
                                else
                                    v_str(1) := rec_param_bip.valeur;
                                end if;

                                for i in 1..v_str.count loop

                                  SELECT COUNT(*) into v_count FROM ENTITE_STRUCTURE WHERE CODCAMO = TO_NUMBER(v_str(i));

                                    IF(v_count<1) THEN
                                            raise_application_error( -20997, 'Erreur dans le paramétrage BIP de l''export Expense : FILTRECTRACONSO/'||rec_param_bip.code_version||' est mal configuré. L''ES '||v_str(i)||' n''existe pas');
                                            RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID, 'Erreur : consulter le fichier LOG', FALSE );
                                    END IF;

                                    -- Pour trouver l'ES, on regarde de quel niveau il est, puis on regarde dans centre_activite si le centre_activite
                                    -- du contrat a pour ce niveau là, cet ES. Si c'est le cas, il est exclu
                                    if((p_coddir = v_tmp) or (v_tmp is null)) THEN
                                        v_es_trouve := 0;
                                        v_niveau := PACK_GLOBAL.recherche_niveau(v_str(i));
                                        if(v_niveau=0)then
                                            if(TO_NUMBER(v_str(i))=p_codcamo)then
                                                v_es_trouve:=1;
                                            end if;
                                        else
                                            OPEN niv1_cur FOR 'select codcamo FROM centre_activite where caniv'||v_niveau||' = TO_NUMBER('||v_str(i)||')';
                                            LOOP
                                                FETCH niv1_cur INTO niv_rec;
                                                if(p_codcamo = niv_rec)then
                                                    v_es_trouve:=1;
                                                    EXIT;
                                                end if;
                                                EXIT WHEN NOT niv1_cur%FOUND;
                                            end loop;
                                            CLOSE niv1_cur;

                                        end if;

                                       if(v_es_trouve=1)then
                                            v_commentaire := 'Contrat rejeté d''après les règles d''exclusion du paramétrage BIP FILTRECTRACONSO/'||rec_param_bip.code_version||'. ES : '||v_str(i);
                                            v_error := 1;

                                       end if;

                                        END IF;
                                        if(v_error=1)then
                                            EXIT;
                                        end if;

                                end loop;
                                if(v_error=1)then
                                    EXIT;
                                end if;

                        END;

                    END LOOP;
                END IF;


                return v_error;




END Controle_param_bip;
-- ======================================================================
-- Extraction des contrats pour lapplication ExpenseBis
-- ======================================================================
PROCEDURE export_contrat(
                                                                p_chemin_fichier    IN VARCHAR2,
                                                                p_nom_fichier        IN VARCHAR2
                                                              ) IS

            CURSOR csr_contrat IS
                                     SELECT

                                     DECODE(c.top30,'N',trim(c.numcont) || '-' || substr(c.cav,2,2),'O',trim(c.numcont) || decode(c.cav,'000','   ',c.cav)) id_cont,
                                                                    ebf.CODE_FOURNISSEUR_EBIS cod_fourn,
                                                                    DECODE(r.rtype,'E','F','L','F',r.rtype)||'-'||RPAD(NVL(trim(lc.MODE_CONTRACTUEL), ' '), 3, ' ')||'-'||RPAD(NVL(trim(md.CODE_LOCALISATION), ' '), 2, ' ')||'-' rtype,
                                                                    TO_CHAR(c.cdatdeb,'dd/mm/yyyy') cdatdeb,
                                                                    TO_CHAR(c.cdatfin,'dd/mm/yyyy') cdatfin,
                                                                    si1.CENTRACTIV ca_cont,
                                                                    si2.CENTRACTIV ca_ress,
                                                                    d1.codperim perim_exp,
                                                                    d1.codref referentiel,
                                                                    LPAD(si1.ident_gdm,5,'0') ident_gdm,
                                                                    LPAD(lc.lcnum,2,'0') lcnum,
                                                                    LPAD(lc.ident,5,'0') ident,
                                                                    r.rnom || DECODE(r.rprenom,NULL,'',',') || r.rprenom nom_prenom,

                                                                    REPLACE (sr.cout , ',' , '.') cout,
                                                                    TO_CHAR(lc.lresfin,'dd/mm/yyyy') lresfin,
                                                                    TO_CHAR(lc.lresdeb,'dd/mm/yyyy') lresdeb,
                                                                    TO_CHAR(SYSDATE,'dd/mm/yyyy HH24:MI:SS') dttm_stamp,
                                                                    lc.soccont soccont,
                                                                    si1.coddir coddir,
                                                                    lc.mode_contractuel mode_contractuel
                                                  FROM CONTRAT c, LIGNE_CONT lc, RESSOURCE r, SITU_RESS sr,STRUCT_INFO si1,STRUCT_INFO si2 ,EBIS_FOURNISSEURS ebf, DIRECTIONS d1, DIRECTIONS d2, MODE_CONTRACTUEL md, prestation pr
                                                 WHERE c.numcont=lc.numcont
                                                AND c.soccont=lc.soccont
                                                AND c.soccont != 'SG..'
                                                AND c.cav=lc.cav
                                                AND (( c.cdatdeb <= SYSDATE AND c.cdatfin>= SYSDATE) OR (c.cdatfin between ADD_MONTHS(SYSDATE,-6) and SYSDATE) )
                                      AND ( ( lc.lresdeb <=  SYSDATE AND  lc.lresfin>= SYSDATE) OR (lc.lresfin between ADD_MONTHS(SYSDATE,-6) and SYSDATE) )
                                                   AND r.ident=lc.ident
                                                AND sr.ident=r.ident
                                               AND  (
                                                                     (lc.LRESFIN between sr.DATSITU and sr.DATDEP)
                                                               or (lc.LRESFIN >= sr.DATSITU and sr.DATDEP is null)

                                                          )

                                            -- perimetre du contrat
                                              AND si1.codsg=c.codsg
                                              and d1.CODDIR = si1.coddir
                                              and d1.syscompta in ('EXP')
                                              -- perimetre de la ressource
                                              AND si2.codsg=sr.codsg
                                              and d2.CODDIR = si1.coddir
                                              and d2.syscompta in ('EXP')
                                              AND ebf.SOCCODE = c.SOCCONT
                                              AND ebf.SIREN = c.SIREN
                                              AND ebf.REFERENTIEL=d1.CODREF
                                              AND sr.PRESTATION = pr.PRESTATION
                                              AND md.CODE_CONTRACTUEL(+) = lc.MODE_CONTRACTUEL
                                              AND sr.PRESTATION NOT IN ('IFO','GRA','MO','INT','STA','SLT')
                                              AND NOT EXISTS ( SELECT * FROM EXP_CONTRAT_REJET cr
                                              WHERE cr.numcont= lc.numcont AND cr.soccont=lc.soccont AND  cr.cav=lc.cav)
                                              ;


            --  Curseur sur les situation_ressources rattachés à la ligne contrat en cours de traitement
            --  boucle ci dessus
            CURSOR cur_situress_ligne_contr_pr (p_ident SITU_RESS.IDENT%TYPE ,
                                                      p_lresfin SITU_RESS.DATDEP%TYPE) IS
                  select (RPAD(NVL(trim(pr.CODE_DOMAINE), ' '),2,' ')|| '-' ||RPAD(NVL(trim(pr.PRESTATION), ' '),3,' ')) domaine_presta
                      from (select sr1.IDENT, sr1.DATSITU ,sr1.prestation
                      from SITU_RESS sr1 ,(SELECT IDENT,MAX(DATSITU) DATSITU
                      FROM SITU_RESS
                      WHERE ident = p_ident
                      AND (( p_lresfin  between DATSITU and DATDEP ) OR  (p_lresfin  >= DATSITU AND DATDEP is null))
                      GROUP BY IDENT,DATDEP) sr2
                      where sr1.ident = sr2.ident
                      AND sr1.DATSITU = sr2.DATSITU) fn, prestation pr
                      where fn.prestation = pr.prestation
                      AND rownum = 1;


        l_msg  VARCHAR2(1024);
        l_domaine_presta VARCHAR2(500);
        v_valide NUMBER;
        l_hfile UTL_FILE.FILE_TYPE;


BEGIN

        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

        FOR rec_contrat IN csr_contrat LOOP

            -- on lance la procedure des controles avec les paramètre BIP
            IF(Controle_param_bip(rec_contrat.coddir,rec_contrat.mode_contractuel,rec_contrat.ca_cont)=1) THEN
                --- Permet d'inserer les exclussions dansd la table Message pour analyse en cas de problème

               insert into test_message (message) values (rec_contrat.id_cont||';'||rec_contrat.coddir||';'||rec_contrat.mode_contractuel||';'||rec_contrat.ca_cont);

            ELSE
                l_msg := 'RR';
                v_valide := pack_situation_p.verif_situ_ligcont(rec_contrat.ident,rec_contrat.soccont,rec_contrat.lresdeb,rec_contrat.lresfin);

                FOR curseur_situ_ress_pr IN cur_situress_ligne_contr_pr(rec_contrat.ident,rec_contrat.lresfin) LOOP
                  BEGIN
                    IF(v_valide = 1) THEN
                      l_domaine_presta := curseur_situ_ress_pr.domaine_presta;
                    ELSE
                      l_domaine_presta := '!!-!!!';
                    END IF;
                  END;
                END LOOP;

                Pack_Global.WRITE_STRING( l_hfile,
                    '0;' ||
                    'BIP;' ||
                    rec_contrat.perim_exp || ';' ||
                    rec_contrat.id_cont || ';' ||
                     rec_contrat.referentiel || ';' ||
                    rec_contrat.cod_fourn || ';' ||
                    rec_contrat.lcnum || ';' ||
                    rec_contrat.ident || ';' ||
                    rec_contrat.nom_prenom || ';' ||
                    '04;' || -- Statut du contrat
                    rec_contrat.ca_cont || ';' || -- CA associé au DPG du contrat
                    '1000000;' || --GE_MAN_DAYS
                    '10000000;' || --MERCHANDISE_AMT
                    rec_contrat.cout || ';' ||
                    'EUR;' ||
                    --rec_contrat.cdatdeb || ';' ||
                    --rec_contrat.cdatfin || ';' ||
                    rec_contrat.cdatdeb || ';' ||
                    rec_contrat.lresfin || ';' ||
                    ' ;' || --SET ID
                    rec_contrat.rtype || l_domaine_presta ||';' ||
                    ' ;' || --statut de la ligne
                    rec_contrat.dttm_stamp || ';' ||
                    rec_contrat.ca_ress || ';' ||
                    rec_contrat.ca_cont
                    );
           END IF;
        END LOOP;


        Pack_Global.CLOSE_WRITE_FILE(l_hfile);
    EXCEPTION
           WHEN OTHERS THEN
            Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20401, l_msg);
END export_contrat;


-- ======================================================================
-- Extraction des réalisés pour lapplication ExpenseBis
-- ======================================================================
  PROCEDURE export_realise(
                                                                p_chemin_fichier    IN VARCHAR2,
                                                                p_nom_fichier        IN VARCHAR2
                                                              ) IS


            CURSOR csr_realise IS



  SELECT

                                                                  d1.codperim perimetre,
                                                                    c.numcont numcont,
                                                                    c.cav  cav,
                                                                    d.MOISMENS  moisprest,
                                                                    SUM(cs.cusag) nbjours,

                                                                    SYSDATE  date_exec,
                                                                    LPAD(r.ident,5,0) ident,
                                                                    d1.codref referentiel,
                                                                    ef.CODE_FOURNISSEUR_EBIS frxbis,
                                                                    c.top30 top30,
                                                                    d1.coddir coddir,
                                                                    lc.mode_contractuel mode_contractuel,
                                                                    si1.centractiv centractiv
                                              FROM  CONTRAT c, LIGNE_CONT lc, RESSOURCE r, SITU_RESS sr ,STRUCT_INFO si1, STRUCT_INFO si2, CONS_SSTACHE_RES_MOIS cs, LIGNE_BIP lb, TACHE t, DATDEBEX d, EBIS_FOURNISSEURS ef, DIRECTIONS d1, DIRECTIONS d2
                                              WHERE   lc.soccont <> 'SG..'
                                              AND c.numcont=lc.numcont
                                              AND c.soccont=lc.soccont
                                              AND c.cav=lc.cav
                                              AND ( TRUNC(lc.lresdeb,'MM') <=  d.MOISMENS AND  lc.lresfin>= d.MOISMENS)
                                              AND lc.ident=r.ident
                                              AND sr.ident=r.ident
                                              AND sr.PRESTATION NOT IN ('IFO','GRA','MO','INT','STA','SLT')
                                             AND r.rtype='P'  -- Ressources de type P
                                              AND (TO_DATE(TO_CHAR(sr.DATSITU,'dd/mm/yyyy'),'dd/mm/yyyy') <= d.MOISMENS AND (TO_DATE(TO_CHAR(sr.DATDEP,'dd/mm/yyyy'),'dd/mm/yyyy') >= d.MOISMENS OR sr.DATDEP IS NULL) )
                                              -- perimetre du contrat
                                               AND si1.codsg=c.codsg
                                              and d1.CODDIR = si1.coddir
                                              and d1.syscompta in ('EXP')
                                              -- perimetre de la ressource
                                              AND si2.codsg=sr.codsg
                                              and d2.CODDIR = si1.coddir
                                              and d2.syscompta in ('EXP')
                                              AND sr.ident=cs.ident(+)
                                              AND ( cs.cdeb IS NULL OR cs.cdeb=d.moismens)
                                              AND lb.pid(+)=cs.pid
                                              AND t.pid(+)=cs.pid
                                              AND t.ecet(+)=cs.ecet
                                              AND t.acta(+)=cs.acta
                                              AND t.acst(+)=cs.acst
                                              AND c.siren = ef.siren
                                              AND c.soccont = ef.soccode
                                              AND ef.REFERENTIEL = d1.codref
                                              AND (lb.typproj <> 7 OR lb.typproj IS NULL OR ( lb.typproj=7  AND t.aist NOT IN ('FORMAT','ABSDIV','MOBIL','PARTIE','RTT','CONGES','ACCUEI')  ))
                                              GROUP BY c.numcont, c.cav, d.moismens, r.ident,r.rtype , sr.montant_mensuel, ef.CODE_FOURNISSEUR_EBIS, d1.codref, d1.codperim, c.top30, d1.coddir, lc.mode_contractuel, si1.centractiv
--
          HAVING (r.rtype='P'  AND SUM(cs.cusag)<>0 ) ;

        -- curseur avec order sur IDENT pour pouvoir supprimer doublons
        -- sert aussi pour l'extraction sur fichier
        CURSOR csr_ebis_exp_realises IS
        SELECT
          process_inst,
          appsrc,
          perimetre,
          DECODE(top30,'N',trim(numcont) || '-' || substr(cav,2,2),'O',trim(numcont) || decode(cav,'000','   ',cav)) numContrat,
          origin_um,
          lmoisprest,
          ident,
          ROUND(cusag,2) cusag,
          receipt_um,
          TIME_STAMP,
          CODE_ERREUR,
          REFERENTIEL,
          CODE_FOURNISSEUR_EBIS

        FROM EBIS_EXPORT_REALISE
           ORDER BY IDENT ,numcont,cav ;




        l_msg  VARCHAR2(1024);
        l_hfile UTL_FILE.FILE_TYPE;
        v_error NUMBER;
        l_ident_precedent NUMBER(5) ;



    BEGIN

          ---------------------------------------------------------------------------------
         --------- Modifs pour fiche 608 ; on met le CUSAG à 0.01 pour les ressources trouvées
         --------- sur deux contrats (doublons sur les idents
         -----------------------------------------------------------------------------------
         ---- Etape 1 : insertion des résultats dans  la table temporaire TMP_EBIS_REALISES

          BEGIN

            DELETE FROM EBIS_EXPORT_REALISE  ;

            FOR curseur_all_lignes IN csr_realise  LOOP

            if (Controle_param_bip(curseur_all_lignes.coddir,curseur_all_lignes.mode_contractuel,curseur_all_lignes.centractiv)=0) then
                              INSERT INTO EBIS_EXPORT_REALISE (
                                 PERIMETRE,  NUMCONT , CAV, LMOISPREST , IDENT, CUSAG , TIME_STAMP  , REFERENTIEL, CODE_FOURNISSEUR_EBIS, TOP30
                              )  VALUES  (
                               curseur_all_lignes.perimetre ,
                                     curseur_all_lignes.numcont,
                                     curseur_all_lignes.cav ,
                                     curseur_all_lignes.moisprest,
                                       curseur_all_lignes.ident  ,
                                        curseur_all_lignes.nbjours,
                                     curseur_all_lignes.date_exec ,
                                      curseur_all_lignes.referentiel ,
                                     curseur_all_lignes.frxbis,
                                     curseur_all_lignes.top30
                            );
            end if;

                      END LOOP ;
            END;

         -----------------------------------------------------------------------------------
         ---- Etape 2 : insertion des résultats dans  la table temporaire TMP_EBIS_REALISES
         ---- On rebalaie la table temporaire et pour chaque ressource trouvée en double (ident)
         ---- on met à jour son cout à 0.01 (fiche 608)
         -----------------------------------------------------------------------------------
         l_ident_precedent := NULL ;
         BEGIN
            FOR curseur_ebis_export IN csr_ebis_exp_realises  LOOP
                 -- Si ident trouvé identique au précédent (ordre select du curseur trié par ident)
                 -- on fait la mise à jour des consommé à 0.01
                 IF(curseur_ebis_export.ident = l_ident_precedent) THEN
                    UPDATE EBIS_EXPORT_REALISE SET CUSAG = 0.01 WHERE EBIS_EXPORT_REALISE.ident = curseur_ebis_export.ident ;
                 END IF  ;
                 l_ident_precedent := curseur_ebis_export.ident ;
            END LOOP ;

         END;


         Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);



         FOR rec_fichier_sortie IN csr_ebis_exp_realises LOOP

            Pack_Global.WRITE_STRING( l_hfile,
              rec_fichier_sortie.process_inst || ';' || --  '0;' || --process instance
              rec_fichier_sortie.appsrc || ';' ||  -- 'BIP;' ||
              rec_fichier_sortie.perimetre ||';' ||
              rec_fichier_sortie.numContrat ||';' ||
              rec_fichier_sortie.origin_um || ';' || --'ST;' ||
              TO_CHAR(rec_fichier_sortie.lmoisprest,'mmyyyy')  || ';' ||
              LPAD(rec_fichier_sortie.ident,5,0)   || ';' ||
              REPLACE (TO_CHAR(rec_fichier_sortie.cusag,'FM9999990D00') ,',','.')  || ';' ||--rec_realise.nbjours || ';' ||
              rec_fichier_sortie.receipt_um || ';' || -- 'MDY;' ||
              TO_CHAR(rec_fichier_sortie.TIME_STAMP,'dd/mm/yyyy HH24:MI:SS')|| ';' || -- rec_fichier_sortie.date_exec || ';' ||
              rec_fichier_sortie.CODE_ERREUR || ';' || --'000' || ';' ||
              rec_fichier_sortie.REFERENTIEL || ';' ||
              rec_fichier_sortie.CODE_FOURNISSEUR_EBIS --rec_realise.frxbis
                );
        END LOOP;
     Pack_Global.CLOSE_WRITE_FILE(l_hfile);

     EXCEPTION
           WHEN OTHERS THEN
            RAISE;
END export_realise;


--**********************************************************************************************
-- Procédure qui alimente la table facture et ligne_fact à partir de la table tmp_ebis_facture
--*********************************************************************************************

PROCEDURE alim_ebis_factures(P_LOGDIR          IN VARCHAR2,
                             p_chemin_fichier        IN VARCHAR2,
                             p_nom_fichier           IN VARCHAR2)   IS


L_PROCNAME  VARCHAR2(20) := 'ALIM_EBIS_FACTURES';
L_HFILE     UTL_FILE.FILE_TYPE;

L_HFILE2     UTL_FILE.FILE_TYPE;
L_RETCOD    NUMBER;
L_STATEMENT VARCHAR2(1000);

l_err NUMBER;
-- QC 1923 - PPM 64007
l_soccont CHAR(4);
l_ccentrefrais      NUMBER(3);
l_socfour           VARCHAR2(10);
l_tva               NUMBER(9,2);
l_codcompta         VARCHAR2(11);
l_deppole             NUMBER(7);
l_montantttc NUMBER(12,2);
l_montantht NUMBER(12,2);
l_lmontantht NUMBER(12,2);
l_tva_temp   NUMBER(9,2);
l_ident VARCHAR2(5);
v_number  NUMBER(5);

chaine_temp  VARCHAR2(15);
l_max_numenr NUMBER(7);
CURSOR cur_factures IS
SELECT * FROM EBIS_IMPORT_FACTURE;


-- fiche 646 : DATE PRESENTE DANS TABLE CALENDRIER
 l_date_ebis_facture DATE ;
 l_debut_ebis_facture DATE ;

 l_date_du_jour DATE ;
 --Flag indiquant si on doit lancer l'import des factures ou pas
 l_traite_factures NUMBER(1) ;

 l_count_date_debloc NUMBER ;

 l_nombre_fact_traitees NUMBER ;
 l_nombre_fact_integrees NUMBER ;
 l_nombre_fact_rejetees NUMBER ;

 l_count NUMBER;
 l_count2 NUMBER;

BEGIN

    -----------------------------------------------------
    -- Init de la trace
    -----------------------------------------------------
        L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
        IF ( L_RETCOD <> 0 ) THEN
        RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
                                'Problème lors de l initialisation du fichier de LOG',
                                 FALSE );
        END IF;


        Trclog.Trclog( L_HFILE, 'Debut de ' || L_PROCNAME );


    -----------------------------------------------------
    -- Trace Start
    -----------------------------------------------------




   --- JAL  16/05/2008 Fiche 646
   -- Le TRUNCATE de la table EBIS_IMPORT_FACTURE est géré via la procédure
   -- ainsi que le lancement ou non des traitements


   l_nombre_fact_traitees := 0 ;
   l_nombre_fact_integrees := 0  ;
   l_nombre_fact_rejetees := 0 ;

   -- RAZ Flag
   l_traite_factures := 0 ;



   --récup date du jour
   SELECT  TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')) INTO l_date_du_jour FROM DUAL ;


   SELECT count(*) INTO  l_count_date_debloc FROM CALENDRIER WHERE
   EXTRACT(YEAR FROM CALANMOIS) = EXTRACT(YEAR from l_date_du_jour)
   AND EXTRACT(MONTH FROM CALANMOIS) = EXTRACT(MONTH from l_date_du_jour) ;


  IF(l_count_date_debloc >0) THEN
 
       -- récup DATE_EBIS_FACTURE d'aprés le mois et année de SYSDATE
       SELECT DATE_EBIS_FACTURE, DEBUT_BLOCAGE_EBIS INTO  l_date_ebis_facture, l_debut_ebis_facture FROM CALENDRIER WHERE
       EXTRACT(YEAR FROM CALANMOIS) = EXTRACT(YEAR from l_date_du_jour)
       AND EXTRACT(MONTH FROM CALANMOIS) = EXTRACT(MONTH from l_date_du_jour) ;
  ELSE
  
        -- SI PAS DE DATE DEBLOCAGE FACTURES EBIS TROUVEE : RAISE APPLICATION ERROR
        RAISE_APPLICATION_ERROR(-20401, 'Ligne non présente dans la table CALENDRIER pour le mois en cours');
  END IF ;

  IF( l_date_ebis_facture IS NULL) THEN
 
   -- SI PAS DE DATE DEBLOCAGE FACTURES EBIS TROUVEE : RAISE APPLICATION ERROR
        RAISE_APPLICATION_ERROR(-20401, 'Absence dans la table CALENDRIER de la Date de déblocage des factures Expense pour le mois en cours');
  END IF ;

    -- BSA QC 1415 : ajout date de debut de blocage
  IF( l_debut_ebis_facture IS NULL) THEN
 
   -- SI PAS DE DATE DE DEBUT BLOCAGE FACTURES EBIS TROUVEE : RAISE APPLICATION ERROR
        RAISE_APPLICATION_ERROR(-20401, 'Absence dans la table CALENDRIER de la Date de début de blocage des factures Expense pour le mois en cours');
  END IF ;


   -- De la date debut blocage (inclu) jusqu'au jour de la date DATE_EBIS_FACTURE (exclu)
   -- LE TRAITEMENT DES FACTURES N'EST PAS LANCE
   -- ON NE FAIT PAS DE TRUNCATE DE LA TABLE EBIS_IMPORT_FACTURE
        --IF( TO_CHAR(l_debut_ebis_facture,'YYYYMMDD') <= TO_CHAR(l_date_du_jour,'YYYYMMDD')
        --AND EXTRACT(DAY FROM l_date_du_jour) < EXTRACT(DAY FROM l_date_ebis_facture)) THEN
   IF( TO_CHAR(l_debut_ebis_facture,'YYYYMMDD') <= TO_CHAR(l_date_du_jour,'YYYYMMDD')
       AND TO_CHAR(l_date_du_jour,'YYYYMMDD') <  TO_CHAR(l_date_ebis_facture,'YYYYMMDD')) THEN

    l_traite_factures := 1 ;
    Trclog.Trclog( L_HFILE, 'Date du jour : ' || TO_CHAR(l_date_du_jour,'DD/MM/YYYY') || '  Date DEBUT BLOCAGE EBIS Facture de CALENDRIER :'  || TO_CHAR(l_debut_ebis_facture,'DD/MM/YYYY') );
    Trclog.Trclog( L_HFILE, 'Date du jour : ' || TO_CHAR(l_date_du_jour,'DD/MM/YYYY') || '  Date EBIS Facture de CALENDRIER :'  || TO_CHAR(l_date_ebis_facture,'DD/MM/YYYY') );
    Trclog.Trclog( L_HFILE, 'Jour compris dans l intervalle d exclusion : Pas de traitements et pas de TRUNCATE TABLE EBIS_IMPORT_FACTURE');
  ELSE
    l_traite_factures := 1 ;
    Trclog.Trclog( L_HFILE, 'Date du jour : ' || TO_CHAR(l_date_du_jour,'DD/MM/YYYY') || '  Date DEBUT BLOCAGE EBIS Facture de CALENDRIER :'  || TO_CHAR(l_debut_ebis_facture,'DD/MM/YYYY') );
    Trclog.Trclog( L_HFILE, 'Date du jour : ' || TO_CHAR(l_date_du_jour,'DD/MM/YYYY') || '  Date EBIS Facture de CALENDRIER :'  || TO_CHAR(l_date_ebis_facture,'DD/MM/YYYY') );
    Trclog.Trclog( L_HFILE, 'Jour supérieur ou égal à la date de traitement factures : traitement factures et TRUNCATE TABLE EBIS_IMPORT_FACTURE');
   END IF ;

 IF(l_traite_factures = 1) THEN

    Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile2);
    FOR curseur IN cur_factures LOOP


     BEGIN

         l_nombre_fact_traitees := l_nombre_fact_traitees + 1 ;


         l_err := 0 ;



         l_err := integrite_test (               curseur.NUMFACT,
                                                curseur.TYPFACT,
                                                curseur.DATFACT,
                                              curseur.NUMCONT,
                                               curseur.CAV,
                                              curseur.CD_REFERENTIEL,
                                              curseur.CD_EXPENSE,
                                               curseur.NUM_EXPENSE,
                                               curseur.FMONTHT,
                                               curseur.FMONTTTC,
                                               curseur.DATE_COMPTA,
                                               curseur.LNUM,
                                                curseur.IDENT,
                                                curseur.LMONTHT,
                                                curseur.LMOISPREST,
                                                curseur.CUSAG_EXPENSE,
                                                curseur.TOPPOST,
                                                   l_soccont,
                                      l_ccentrefrais,
                                      l_socfour,
                                      l_tva,
                                          l_codcompta,
                                      l_deppole ,
                                      l_montantht,
                                      l_montantttc,
                                      l_lmontantht
                                    )
                                    ;

        --insert dans tables code err
        Trclog.Trclog( L_HFILE, 'FIN INTEGRITE TEST ' || l_err || ' l_soccont ' || l_soccont);


        IF( l_err <>  0 )THEN


           SELECT max(numenr) INTO l_max_numenr FROM ebis_fact_rejet;

           INSERT INTO EBIS_FACT_REJET
                                                  (CODE_RETOUR,
                                                  NUMFACT,
                                                  TYPFACT,
                                                  DATFACT,
                                                  NUMCONT,
                                                  CAV,
                                                  CD_REFERENTIEL,
                                                  CD_EXPENSE,
                                                   NUM_EXPENSE,
                                                   FMONTHT,
                                                   FMONTTTC,
                                                   DATE_COMPTA,
                                                   LNUM,
                                                   IDENT,
                                                   LMONTHT,
                                                   LMOISPREST,
                                                   CUSAG_EXPENSE,
                                                   TOPPOST,
                                                   TIMESTAMP,
                                                   --Ajout de 2 champs pour la gestion des rejet dans IHM
                                                   TOP_ETAT,
                                                   NUMENR)

                                VALUES(               l_err,
                                                     curseur.NUMFACT,
                                                   curseur.TYPFACT,
                                                   curseur.DATFACT,
                                                   curseur.NUMCONT,
                                                   curseur.CAV,
                                                   curseur.CD_REFERENTIEL,
                                                   curseur.CD_EXPENSE,
                                                   curseur.NUM_EXPENSE,
                                                   curseur.FMONTHT,
                                                   curseur.FMONTTTC,
                                                   curseur.DATE_COMPTA,
                                                   curseur.LNUM,
                                                   curseur.IDENT,
                                                   curseur.LMONTHT,
                                                   curseur.LMOISPREST,
                                                   curseur.CUSAG_EXPENSE,
                                                   curseur.TOPPOST,
                                                   SYSDATE,
                                                   'AT',
                                                   l_max_numenr+1);

                             COMMIT;
            Trclog.Trclog( L_HFILE, 'insert ebis rejet done');
            l_nombre_fact_rejetees :=  l_nombre_fact_rejetees +1  ;


                        Pack_Global.WRITE_STRING( l_hfile2,
                                                   l_err || ';' ||
                                                   curseur.NUMFACT || ';' ||
                                                   curseur.TYPFACT || ';' ||
                                                   curseur.DATFACT || ';' ||
                                                   curseur.NUMCONT || ';' ||
                                                   curseur.CAV || ';' ||
                                                   curseur.CD_REFERENTIEL || ';' ||
                                                   curseur.CD_EXPENSE || ';' ||
                                                   curseur.NUM_EXPENSE || ';' ||
                                                   curseur.FMONTHT || ';' ||
                                                   curseur.FMONTTTC || ';' ||
                                                   curseur.DATE_COMPTA || ';' ||
                                                   curseur.LNUM || ';' ||
                                                   curseur.IDENT || ';' ||
                                                   curseur.LMONTHT || ';' ||
                                                   curseur.LMOISPREST || ';' ||
                                                   curseur.CUSAG_EXPENSE || ';' ||
                                                   curseur.TOPPOST
                                                    );


        ELSE

        --L_STATEMENT := 'Julio : Insertion des données dans la table FACTURES';
        --Trclog.Trclog( L_HFILE, L_STATEMENT );
        --L_STATEMENT := 'l_soccont:' || l_soccont||'NUMFACT:'||curseur.NUMFACT ||'TYPFACT:'||curseur.TYPFACT||
        --               'DATFACT:'||curseur.DATFACT ;
        --Trclog.Trclog( L_HFILE, L_STATEMENT );

        --L_STATEMENT :=   'l_montantht:'||l_montantht||'l_montantttc:'||l_montantttc||
        --'NUMCONT:'||curseur.NUMCONT||' curseur.CAV :'|| curseur.CAV ;
        --Trclog.Trclog( L_HFILE, L_STATEMENT );

         --L_STATEMENT := 'curseur.CUSAG_EXPENSE'|| curseur.CUSAG_EXPENSE||' curseur.NUM_EXPENSE:'|| curseur.NUM_EXPENSE||
         --'curseur.DATE_COMPTA:'||curseur.DATE_COMPTA||'LMOISPREST:'||
         --'l_ccentrefrais:'||l_ccentrefrais ||'l_socfour:' ||l_socfour ;
         --Trclog.Trclog( L_HFILE, L_STATEMENT );



        --L_STATEMENT := 'curseur.DATE_COMPTA:'||curseur.DATE_COMPTA||'LMOISPREST:'||TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy') ;
        --Trclog.Trclog( L_HFILE, L_STATEMENT );

        --L_STATEMENT := 'l_ccentrefrais:'||l_ccentrefrais||'l_socfour:'||l_socfour||'l_tva:'||l_tva||' l_codcompta:'|| l_codcompta;
        --Trclog.Trclog( L_HFILE, L_STATEMENT );
        --L_STATEMENT := ' l_deppole :'|| l_deppole ||' END' ;
        --Trclog.Trclog( L_HFILE, L_STATEMENT );

        --L_STATEMENT :=' l_codcompta:' ||l_codcompta ;
        --Trclog.Trclog( L_HFILE, L_STATEMENT );

        l_ident := curseur.ident;
        v_number := curseur.ident;

        if (v_number is null or v_number=0) then

            select count(*) into l_count from (select ident
            from ligne_cont
            where soccont= l_soccont
            and numcont = curseur.NUMCONT
            and cav = curseur.CAV
            AND TRUNC(lresdeb,'MM')  <= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')  AND lresfin >= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')
            group by ident);

            if (l_count = 1) then
                select ident into l_ident
                from ligne_cont
                where soccont= l_soccont
                and numcont = curseur.NUMCONT
                and cav = curseur.CAV
                AND TRUNC(lresdeb,'MM')  <= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')  AND lresfin >= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')
                group by ident;
            --On récupère la première ressource active sur les lignes contrats du contrat
            --et sur le mois de prestation en se basant sur le lcnum croissant.
            elsif (l_count > 1) then
                select count (*) into l_count2
                from ligne_cont, cons_sstache_res_mois
                where ligne_cont.ident =  cons_sstache_res_mois.ident
                and cons_sstache_res_mois.cdeb = curseur.LMOISPREST
                and cons_sstache_res_mois.cusag is not null
                and soccont= l_soccont
                and numcont = curseur.NUMCONT
                and cav = curseur.CAV
                AND TRUNC(lresdeb,'MM')  <= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')  AND lresfin >=    TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy');

                IF (l_count2 > 0) then
                  --On récupère la première ressource ayant un consommé
                  select distinct ligne_cont.ident into l_ident
                  from ligne_cont, cons_sstache_res_mois
                  where ligne_cont.ident =  cons_sstache_res_mois.ident
                  and cons_sstache_res_mois.cdeb = curseur.LMOISPREST
                  and cons_sstache_res_mois.cusag is not null
                  and soccont= l_soccont
                  and numcont = curseur.NUMCONT
                  and cav = curseur.CAV
                  AND TRUNC(lresdeb,'MM')  <= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')  AND lresfin >=    TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')
                  AND lcnum = (select min(lcnum) from ligne_cont, cons_sstache_res_mois
                  where ligne_cont.ident =  cons_sstache_res_mois.ident
                  and cons_sstache_res_mois.cdeb = curseur.LMOISPREST
                  and cons_sstache_res_mois.cusag is not null
                  and soccont= l_soccont
                  and numcont = curseur.NUMCONT
                  and cav = curseur.CAV
                  AND TRUNC(lresdeb,'MM')  <= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')  AND lresfin >= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy'));
                ELSE
                  --Sinon on récupère la première ressource
                  select ident into l_ident
                  from ligne_cont
                  where soccont= l_soccont
                  and numcont = curseur.NUMCONT
                  and cav = curseur.CAV
                  AND TRUNC(lresdeb,'MM')  <= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')  AND lresfin >=    TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')
                  AND lcnum = (select min(lcnum) from ligne_cont
                  where soccont= l_soccont
                  and numcont = curseur.NUMCONT
                  and cav = curseur.CAV
                  AND TRUNC(lresdeb,'MM')  <= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')  AND lresfin >= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')) ;
                END IF;
            end if;
                /*select ident into l_ident
                from ligne_cont
                where soccont= l_soccont
                and numcont = curseur.NUMCONT
                and cav = curseur.CAV
                AND TRUNC(lresdeb,'MM')  <= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')  AND lresfin >= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')
                AND lcnum = (select min(lcnum) from ligne_cont
                where soccont= l_soccont
                and numcont = curseur.NUMCONT
                and cav = curseur.CAV
                AND TRUNC(lresdeb,'MM')  <= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')  AND lresfin >= TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy')) ;*/

        end if;
        Trclog.Trclog( L_HFILE, 'begin insert data');
        L_STATEMENT := '* Insertion des données dans la table FACTURES. NUMFACT: ' || curseur.NUMFACT || 'l_soccont' || l_soccont;
        Trclog.Trclog( L_HFILE, L_STATEMENT );
        Trclog.Trclog( L_HFILE, 'data to insert ' || l_soccont || '--'|| l_montantht|| '--'|| l_montantttc|| '--' || l_ccentrefrais|| '--'|| l_socfour|| '--'|| l_tva|| '--'|| l_codcompta|| '--'|| l_deppole);


         insert_facture(                                            l_soccont,
                                                                                                 curseur.NUMFACT,
                                                                                                 curseur.TYPFACT,
                                                                   TO_DATE(curseur.DATFACT,'DD/MM/YYYY'),
                                                                                                 l_montantht,
                                                              l_montantttc,
                                                             curseur.NUMCONT,
                                                             curseur.CAV ,
                                                             curseur. CD_EXPENSE,
                                                             curseur.CUSAG_EXPENSE,
                                                             curseur.NUM_EXPENSE,
                                                             curseur.DATE_COMPTA,
                                                             curseur.TOPPOST,
                                                             TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy'),
                                                             l_ccentrefrais,
                                                             l_socfour,
                                                             l_tva,
                                                             l_codcompta,
                                                             l_deppole
                                                             );

    L_STATEMENT := '* Insertion des données dans la table LIGNES FACTURES. NUMFACT: ' || curseur.NUMFACT || 'l_lmontantht' || l_lmontantht;
    Trclog.Trclog( L_HFILE, L_STATEMENT );


                                 insert_ligne_facture(l_lmontantht,
                                                                         l_codcompta,
                                                                         l_deppole,
                                                                         TO_DATE(curseur.LMOISPREST,'dd/mm/yyyy'),
                                                                         l_soccont,
                                                                            curseur.TYPFACT,
                                                                         curseur.DATFACT,
                                                                         curseur.NUMFACT,
                                                                         l_tva,
                                                                         l_ident,
                                                                         curseur.lnum
                                                                         );






                               COMMIT;
         l_nombre_fact_integrees :=   l_nombre_fact_integrees + 1  ;


        END IF;





     END ;

        --insert facture

     END LOOP;

     Pack_Global.CLOSE_WRITE_FILE(l_hfile2);

 END IF ; -- Fin test si on doit traiter les factures fiche 646

  -- Fiche 646 : si on traite facture -> il faut lancer le TRUNCATE DE LA TABLE AUSSI
 IF(l_traite_factures = 1) THEN
   DELETE FROM EBIS_IMPORT_FACTURE ;
 END IF ;



 COMMIT;

    Trclog.Trclog( L_HFILE, ' ');
    Trclog.Trclog( L_HFILE, 'Nombre total de facture traitées :  ' || l_nombre_fact_traitees);
    Trclog.Trclog( L_HFILE, 'Nombre de facture intégrées :  ' || l_nombre_fact_integrees);
    Trclog.Trclog( L_HFILE, 'Nombre de facture rejetées :  ' || l_nombre_fact_rejetees);



    Trclog.Trclog( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME);


    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END IF;
        Trclog.Trclog( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;




END alim_ebis_factures;



FUNCTION integrite_test(p_NUMFACT               IN    VARCHAR2,
                                                   p_TYPFACT                 IN    VARCHAR2,
                                                   p_DATFACT                IN   VARCHAR2,
                                                   p_NUMCONT              IN    VARCHAR2,
                                                   p_CAV                            IN    VARCHAR2,
                                                   p_CD_REFERENTIEL     IN    VARCHAR2,
                                                   p_CD_EXPENSE       IN    VARCHAR2,
                                                   p_NUM_EXPENSE   IN    VARCHAR2,
                                                   p_FMONTHT              IN     VARCHAR2,
                                                   p_FMONTTTC            IN    VARCHAR2,
                                                   p_DATE_COMPTA   IN     VARCHAR2,
                                                   p_LNUM                        IN     VARCHAR2,
                                                   p_IDENT                       IN    VARCHAR2,
                                                   p_LMONTHT                         IN  VARCHAR2,
                                                   p_LMOISPREST        IN     VARCHAR2,
                                                   p_CUSAG_EXPENSE  IN  VARCHAR2,
                                                   P_TOPPOST                  IN    VARCHAR2,
                                                   p_SOCCONT                  OUT VARCHAR2,
                                                    p_CCENTREFRAIS    OUT NUMBER,
                                                    p_SOCFOUR                 OUT  VARCHAR2,
                                                    p_TVA                    OUT FACTURE.FTVA%TYPE ,
                                                    p_CODCOMPTA          OUT VARCHAR2,
                                                    p_DEPPOLE                  OUT VARCHAR2,
                                                    o_FMONTHT              OUT     FACTURE.FMONTHT%TYPE,
                                                    o_FMONTTTC            OUT      FACTURE.FMONTTTC%TYPE,
                                                    o_FLMONTHT            OUT      LIGNE_FACT.LMONTHT%TYPE

                                                     )  RETURN NUMBER IS




l_msg  VARCHAR2(1024);

v_date DATE;
v_number NUMBER;
l_count NUMBER;
l_count2 NUMBER;
l_ident VARCHAR2(5);
--l_soccode CHAR(4);
--l_soccont CHAR(4);
l_montantttc NUMBER(12,2);
l_montantht NUMBER(12,2);
l_numfact CHAR(15);
l_lmontantht NUMBER(12,2);

l_tva_ok NUMBER;
l_lmontanttmp number;

l_numcont VARCHAR2(27);
l_cav VARCHAR2(3);

--SEL PPM 64007
l_soccode VARCHAR2(32000);

L_Procname  Varchar2(20) := 'integrite_test';
L_Hfile     Utl_File.File_Type;
L_RETCOD NUMBER;

BEGIN

 L_RETCOD := Trclog.INITTRCLOG( 'PL_LOGS', L_PROCNAME, L_HFILE );
        IF ( L_RETCOD <> 0 ) THEN
        RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
                                'Problème lors de l initialisation du fichier de LOG',
                                 FALSE );
        END IF;


        Trclog.Trclog( L_HFILE, 'Debut de ' || L_PROCNAME );


         BEGIN



                l_montantht := CAST( REPLACE(p_FMONTHT,'.',',') AS NUMBER);
                l_montantttc := CAST( REPLACE(p_FMONTTTC,'.',',') AS NUMBER);
                v_number := p_LNUM;
                v_number := p_IDENT;
                l_lmontantht :=CAST( REPLACE(p_LMONTHT,'.',',') AS NUMBER);
                                     v_number := CAST( REPLACE(p_CUSAG_EXPENSE,'.',',') AS NUMBER);
         EXCEPTION
                  When Others Then
                   TRCLOG.CLOSETRCLOG( L_HFILE );
                         RETURN 104;
         END;


         BEGIN
                v_date := TO_DATE(p_DATFACT,'dd/mm/yyyy');
                v_date := TO_DATE(p_DATE_COMPTA,'dd/mm/yyyy');
                v_date := TO_DATE(p_LMOISPREST,'dd/mm/yyyy');

                EXCEPTION
                  When Others Then
                   TRCLOG.CLOSETRCLOG( L_HFILE );
                        RETURN 103;
         END;


         -- TD 743 (TEST 1 ) test si le montant HT de la facture est egale à 0 ou null
         If (L_Montantht = 0 Or P_Fmontht Is Null ) Then
          TRCLOG.CLOSETRCLOG( L_HFILE );
            return 18;
         end if;
         -- test si le montant HT de la ligne facture est egale à 0 ou null
          If (L_Lmontantht = 0 Or P_Lmontht Is Null ) Then
           TRCLOG.CLOSETRCLOG( L_HFILE );
            return 19;
         end if;




        --Récupération des données OBLIGATOIRES pour la table FACTURE



        --------------------------- CHECK DONNEES EBIS FOURNISSEURS --------------------------------

        -- Véirifcation cohérence société et ebis_fournisserurs
        SELECT COUNT(*) INTO l_count FROM EBIS_FOURNISSEURS , SOCIETE WHERE  
        EBIS_FOURNISSEURS.REFERENTIEL = p_CD_REFERENTIEL AND
        EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS = p_CD_EXPENSE AND 
        SOCIETE.SOCCODE = EBIS_FOURNISSEURS.SOCCODE  ;
        If (L_Count =0) Then
         TRCLOG.CLOSETRCLOG( L_HFILE );
           RETURN 27 ;
        END IF;


        p_SOCCONT := NULL ;
        -- Récupération SOCCONT : unique pour un code société
        
        /*SELECT EBIS_FOURNISSEURS.SOCCODE  INTO p_SOCCONT FROM EBIS_FOURNISSEURS  WHERE
        EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS = p_CD_EXPENSE
        AND ROWNUM = 1 ;*/
        
        -- Trclog.Trclog( L_Hfile, '1-AVANT 64007 - num facture '||P_Numfact||' num contrat '||P_Numcont||' p_CD_EXPENSE '|| P_Cd_Expense||' l_soccode '||l_soccode );
       
        --SEL PPM 64007
        select distinct
        listagg (SOCCODE, ',')
        WITHIN GROUP
        (ORDER BY SOCCODE) SOCCODE
        INTO l_soccode
        FROM
        EBIS_FOURNISSEURS
        WHERE
        Ebis_Fournisseurs.Code_Fournisseur_Ebis =  p_CD_EXPENSE;
       -- Trclog.Trclog( L_HFILE, '1-APRES 64007 - num facture '||p_NUMFACT||' num contrat '||p_numcont||' p_CD_EXPENSE '|| p_CD_EXPENSE||' l_soccode '||l_soccode );
        
   --insert into aa values('64007 - num facture '||p_NUMFACT||' num contrat '||p_numcont||' p_CD_EXPENSE '|| p_CD_EXPENSE||' l_soccode '||l_soccode);commit;       
          
      


		-- controle du num contrat existant pour le code Société
        /*SELECT COUNT(*) INTO l_count FROM CONTRAT WHERE 
        trim(numcont) = trim(p_numcont)
        AND 
        p_SOCCONT = CONTRAT.SOCCONT 
        AND 
        p_cav = CONTRAT.CAV;*/
        
       -- Trclog.Trclog( L_HFILE, '2-AVANT 64007 - num facture '||p_NUMFACT||' num contrat '||p_numcont||' P_Cav '|| P_Cav||' l_soccode '||l_soccode );
        --SEL PPM 64007
        SELECT COUNT(*) INTO l_count FROM CONTRAT WHERE 
        trim(numcont) = trim(p_numcont)
        AND 
        INSTR(l_soccode,CONTRAT.SOCCONT) >0
        AND 
        P_Cav = Contrat.Cav;
        Trclog.Trclog( L_Hfile, '2-APRES 64007 - num facture '||P_Numfact||' num contrat '||P_Numcont||' P_Cav '|| P_Cav||' l_soccode '||l_soccode );
        Trclog.Trclog( L_HFILE, '64007 count '||l_count);
           
        IF (l_count = 0 ) THEN
                      --DBMS_OUTPUT.put_line('Controle num contrat pour la société!');
                       TRCLOG.CLOSETRCLOG( L_HFILE );
                      RETURN  7 ;
        END IF ;

        ----------------------------------------- RESSOURCE EXISTANTE -------------------------

        -- SGA PPM 3177 Si l'identifiant ressource n'est pas donné, on va chercher dans les lignes contrats
        -- combien de ressources existent pour ce contrat, cet avenant, ce code fournisseur Expense et ce mois de prestation
        -- S'il n'y en a qu'une, p_ident prend sa valeur et on continue le traitement
        -- S'il y en a plusieurs, on récupère la première ressource active sur les lignes contrats du contrat
        --et sur le mois de prestation en se basant sur le lcnum croissant
        -- Si il y en a aucune on renvoie le code d'erreur 108
        --BEGIN SEL PPM 64007
        SELECT CONTRAT.SOCCONT INTO p_SOCCONT FROM CONTRAT WHERE 
        trim(numcont) = trim(p_numcont)
        AND 
        INSTR(l_soccode,CONTRAT.SOCCONT) >0
        AND 
        P_Cav = Contrat.Cav
        AND ROWNUM = 1;
        --END SEL PPM 64007
        
        --p_SOCCONT := l_soccode;
        Trclog.Trclog( L_HFILE, '64007 affectation  p_SOCCONT' || p_SOCCONT);
        --v_number := 0;
        v_number := p_IDENT;
        l_ident := p_IDENT;
        if (v_number is null or v_number=0) then
            select count(*) into l_count from (select ident
            from ligne_cont
            where soccont= p_SOCCONT
            and numcont = p_NUMCONT
            and cav = p_CAV
            AND TRUNC(lresdeb,'MM')  <= TO_DATE(p_LMOISPREST,'dd/mm/yyyy')  AND lresfin >= TO_DATE(p_LMOISPREST,'dd/mm/yyyy')
            Group By Ident);
    
            if (l_count = 1) then
                select ident into l_ident
                from ligne_cont
                where soccont= p_SOCCONT
                and numcont = p_NUMCONT
                and cav = p_CAV
                AND TRUNC(lresdeb,'MM')  <= TO_DATE(p_LMOISPREST,'dd/mm/yyyy')  AND lresfin >= TO_DATE(p_LMOISPREST,'dd/mm/yyyy')
                group by ident;
            --On récupère la première ressource active sur les lignes contrats du contrat
            --et sur le mois de prestation en se basant sur le lcnum croissant.
            elsif (l_count > 1) then
                select count (*) into l_count2
                from ligne_cont, cons_sstache_res_mois
                where ligne_cont.ident =  cons_sstache_res_mois.ident
                and cons_sstache_res_mois.cdeb = p_LMOISPREST
                and cons_sstache_res_mois.cusag is not null
                and soccont= p_SOCCONT
                and numcont = p_NUMCONT
                and cav = p_CAV
                And Trunc(Lresdeb,'MM')  <= To_Date(P_Lmoisprest,'dd/mm/yyyy')  And Lresfin >=    To_Date(P_Lmoisprest,'dd/mm/yyyy');
       
                IF (l_count2 > 0) then
                  --On récupère la première ressource ayant un consommé
                  select distinct ligne_cont.ident into l_ident
                  from ligne_cont, cons_sstache_res_mois
                  where ligne_cont.ident =  cons_sstache_res_mois.ident
                  and cons_sstache_res_mois.cdeb = p_LMOISPREST
                  and cons_sstache_res_mois.cusag is not null
                  and soccont= p_SOCCONT
                  and numcont = p_NUMCONT
                  and cav = p_CAV
                  AND TRUNC(lresdeb,'MM')  <= TO_DATE(p_LMOISPREST,'dd/mm/yyyy')  AND lresfin >=    TO_DATE(p_LMOISPREST,'dd/mm/yyyy')
                  AND lcnum = (select min(lcnum) from ligne_cont, cons_sstache_res_mois
                  where ligne_cont.ident =  cons_sstache_res_mois.ident
                  and cons_sstache_res_mois.cdeb = p_LMOISPREST
                  and cons_sstache_res_mois.cusag is not null
                  and soccont= p_SOCCONT
                  and numcont = p_NUMCONT
                  and cav = p_CAV
                  And Trunc(Lresdeb,'MM')  <= To_Date(P_Lmoisprest,'dd/mm/yyyy')  And Lresfin >= To_Date(P_Lmoisprest,'dd/mm/yyyy'));
                           
                ELSE
                  --Sinon on récupère la première ressource
                  select ident into l_ident
                  from ligne_cont
                  where soccont= p_SOCCONT
                  and numcont = p_NUMCONT
                  and cav = p_CAV
                  AND TRUNC(lresdeb,'MM')  <= TO_DATE(p_LMOISPREST,'dd/mm/yyyy')  AND lresfin >=    TO_DATE(p_LMOISPREST,'dd/mm/yyyy')
                  AND lcnum = (select min(lcnum) from ligne_cont
                  where soccont= p_SOCCONT
                  and numcont = p_NUMCONT
                  and cav = p_CAV
                  And Trunc(Lresdeb,'MM')  <= To_Date(P_Lmoisprest,'dd/mm/yyyy')  And Lresfin >= To_Date(P_Lmoisprest,'dd/mm/yyyy')) ;
                          
                END IF;
            Else
            Trclog.Trclog( L_Hfile, ' 64007 - ERREUR 108 p_LMOISPREST ' || p_LMOISPREST);
            TRCLOG.CLOSETRCLOG( L_HFILE );
                return 108;
             end if;

        end if;
         -- Code ressource inexistant
        v_number := l_ident ; 
        Select Count(*) Into L_Count From Ressource Where  V_Number = Ressource.Ident;   
        Trclog.Trclog( L_Hfile, ' 64007 - NOMBRE RESOURCES ');
        
        
        If( L_Count = 0)Then
        TRCLOG.CLOSETRCLOG( L_HFILE );
                   RETURN 21;
        END IF;

   Trclog.Trclog( L_Hfile, ' 64007 - CONTRAT ' );      
        ------------------------------ CONTRAT ------------------------------------

        -- Récupération codcompta du CONTRAT  (Num"ro code comptable CONTRAT)
        SELECT COMCODE INTO p_CODCOMPTA FROM CONTRAT WHERE
        trim(CONTRAT.NUMCONT) = trim(p_NUMCONT) AND  CONTRAT.CAV = p_CAV AND
        CONTRAT.SOCCONT = p_soccont AND ROWNUM = 1;

        
        -- Récupération CODSG du CONTRAT  (code département pôle groupe)
        SELECT CONTRAT.CODSG INTO p_DEPPOLE  FROM CONTRAT WHERE
        trim(CONTRAT.NUMCONT) = trim(p_NUMCONT) AND  CONTRAT.CAV = p_CAV AND
        CONTRAT.SOCCONT = p_soccont AND ROWNUM = 1;

       
        -- pas de contrat couvrant la date de prestation
        SELECT COUNT(*) INTO l_count FROM CONTRAT WHERE
        p_SOCCONT  = CONTRAT.SOCCONT and p_cav =  CONTRAT.CAV AND
        TRIM(p_numcont)=TRIM(CONTRAT.NUMCONT)
        --AND  CONTRAT.CDATDEB <= TO_DATE(p_lmoisprest,'dd/mm/yyyy')  AND CONTRAT.CDATFIN >= TO_DATE(p_lmoisprest,'dd/mm/yyyy');
        And Trunc(Contrat.Cdatdeb,'MM')  <= To_Date(P_Lmoisprest,'dd/mm/yyyy')  And Contrat.Cdatfin >= To_Date(P_Lmoisprest,'dd/mm/yyyy');
       
        IF(l_count = 0)THEN
                   Trclog.Trclog( L_Hfile, ' 64007 - ERREUR 23 ');
                  --DBMS_OUTPUT.put_line('pas de contrat couvrant la date de prestation');
                  TRCLOG.CLOSETRCLOG( L_HFILE );
                  RETURN 23;
        END IF;







        ----------------------------------------- CENTRE FRAIS ----------------------------
Trclog.Trclog( L_Hfile, ' 64007 - CENTRE FRAIS ' );
        -- Test si existe dans STRCUT_INFO
          SELECT count(*) into l_count FROM CONTRAT ,STRUCT_INFO WHERE
          trim(CONTRAT.NUMCONT) = trim(p_NUMCONT) AND  CONTRAT.CAV = p_CAV AND
          CONTRAT.SOCCONT = p_soccont AND STRUCT_INFO.CODSG = CONTRAT.CODSG AND ROWNUM = 1;
        IF (l_count = 0) THEN
          -- DBMS_OUTPUT.put_line('PAS SOCIETE TROUVEE VIA EBIS FOURNISSEUR !');
          Trclog.Trclog( L_Hfile, ' 64007 - ERREUR 28 ');
          TRCLOG.CLOSETRCLOG( L_HFILE );
           RETURN 28 ;
        END IF;

        -- Récuparation Centre Frais : STRUCT_INFO via Société
        SELECT STRUCT_INFO.SCENTREFRAIS INTO p_CCENTREFRAIS  FROM CONTRAT ,STRUCT_INFO WHERE
          trim(CONTRAT.NUMCONT) = trim(p_NUMCONT) AND  CONTRAT.CAV = p_CAV AND
          CONTRAT.SOCCONT = p_soccont AND STRUCT_INFO.CODSG = CONTRAT.CODSG AND ROWNUM = 1;



        -- Récuparation SOCFOUR : Code Fournisseur : ExpenseBis  à BLANC car factures pas en provenance de SMS
        p_SOCFOUR  := '' ;



        -- Ressource non associée au contrat
        SELECT COUNT(*) INTO l_count
        FROM LIGNE_CONT WHERE trim(p_soccont)=trim(SOCCONT)  AND trim(p_numcont)=trim(NUMCONT) AND p_cav=CAV AND ident=TO_NUMBER(l_ident)
        AND TRUNC(LRESDEB,'MM') <= p_lmoisprest AND LRESFIN >= p_lmoisprest;
        If( L_Count = 0)Then
        Trclog.Trclog( L_Hfile, ' 64007 - ERREUR 22 ');
        TRCLOG.CLOSETRCLOG( L_HFILE );
                  RETURN 22;
        END IF;



       --controle numfact
       SELECT TRIM(TRANSLATE(p_NUMFACT, '~#{[|`@]}¿e''(-è_çà)=^$ù*<,;:!°+£%µ>?./§', ' '))  INTO l_numfact FROM DUAL;




        -- Calcul TVA :


         o_FMONTHT :=  l_montantht;
         o_FMONTTTC := l_montantttc;
         o_FLMONTHT := l_lmontantht;



         p_tva  := ( l_montantttc-l_montantht) * (100/l_montantht);







-- PAR JAL le 15/05/2008 : fiche 644 (taux TVA avec tolérance de +/- 1

        l_tva_ok := 0 ;

        IF ( p_TVA >=  18.6 AND  p_TVA <=  21) THEN
         l_tva_ok := 1 ;
        END IF ;

        IF ( p_TVA >=  4.5 AND  p_TVA <=  6.5) THEN
         l_tva_ok := 1 ;
        END IF ;

        IF ( p_TVA >=0 AND p_TVA <= 1 ) THEN
         l_tva_ok := 1 ;
        END IF ;
        
       -- l_tva_ok := 1 ;
        If(L_Tva_Ok=0)Then
        Trclog.Trclog( L_Hfile, ' 64007 - ERREUR 16 ');
        TRCLOG.CLOSETRCLOG( L_HFILE );
            RETURN 16 ;
        END IF ;






        /*IF(l_montantttc <> p_FMONTTTC)THEN
                DBMS_OUTPUT.put_line('Test total montant HT !');
                   RETURN 16;
             END IF;*/

       --controle du dpg (code DPG fermé)
      /*SELECT COUNT(*) INTO l_count FROM CONTRAT,STRUCT_INFO  WHERE CONTRAT.NUMCONT = p_NUMCONT AND
       CONTRAT.cav = p_cav AND CONTRAT.SOCCONT   = p_soccont AND
       STRUCT_INFO.CODSG = CONTRAT.CODSG AND STRUCT_INFO.TOPFER = 'O' ;
       IF (l_count=0) THEN
               --DBMS_OUTPUT.put_line('Code DPG fermé ! ');
              RETURN 14 ;
       END IF ;*/





       ----------------------------------- TYPE FACTURE --------------------------------------------


       -- Recherche pour un type de FACTURE = 'A' (Avoir) : Recherche d'une Facture et Ligne Facture
       -- de type 'F' pour les mêmes sociétes, contract, ressource, date prestation
/*       IF (p_TYPFACT = 'A') THEN
            SELECT count(*) INTO l_count2 FROM FACTURE WHERE FACTURE.TYPFACT = 'F'
                                  AND FACTURE.NUMCONT = p_NUMCONT AND FACTURE.CAV = p_CAV AND FACTURE.SOCFACT = p_SOCCONT ;
            IF(l_count2 >0) THEN

                SELECT COUNT(*) INTO l_count FROM LIGNE_FACT WHERE LIGNE_FACT.TYPFACT = 'F'
                 AND LIGNE_FACT.SOCFACT = p_SOCCONT AND
                LIGNE_FACT.IDENT = p_IDENT AND LIGNE_FACT.LMOISPREST = p_LMOISPREST
                AND NUMFACT IN (
                                  SELECT NUMFACT FROM FACTURE WHERE FACTURE.TYPFACT = 'F'
                                  AND FACTURE.NUMCONT = p_NUMCONT AND FACTURE.CAV = p_CAV AND FACTURE.SOCFACT = p_SOCCONT
                                );
                IF (l_count>0) THEN
                   --DBMS_OUTPUT.put_line('TEST pour type Facture = A !');
                   RETURN 26 ;
                END IF ;

            END IF ;

       END IF;
*/


            /* TD 743 (TEST 2) controle sur le montant total des lignes factures il doit être  égal à celui de la facture*/
            l_lmontanttmp := 0;
            SELECT sum(to_number(replace(lmontht,'.',','))) into l_lmontanttmp from ebis_import_facture where
            cd_expense = p_CD_EXPENSE and TYPFACT = p_TYPFACT and  DATFACT = p_DATFACT  and NUMFACT =  p_NUMFACT ;

            If (L_Lmontanttmp != To_Number(Replace(P_Fmontht,'.',',')) ) Then
            Trclog.Trclog( L_Hfile, ' 64007 - ERREUR 17 L_Lmontanttmp' || L_Lmontanttmp || 'P_Fmontht' ||P_Fmontht);
            TRCLOG.CLOSETRCLOG( L_HFILE );
              return 17;
            end if;



Trclog.Trclog( L_Hfile, ' 64007 - END INTEGRITE TEST' );
TRCLOG.CLOSETRCLOG( L_HFILE );
       RETURN 0;





      EXCEPTION WHEN OTHERS THEN
            --Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            --RAISE_APPLICATION_ERROR(-20401, l_msg);
            Trclog.Trclog( L_Hfile, 'EXCEPTION 64007 -'||Sqlerrm||' num facture '||P_Numfact||' num contrat '||P_Numcont||' P_Cav '|| P_Cav||' l_soccode '||L_Soccode||' p_CD_EXPENSE '|| P_Cd_Expense ||' p_SOCCONT '|| p_SOCCONT);
            TRCLOG.CLOSETRCLOG( L_HFILE );
            raise_application_error(-20997, SQLERRM);

END  integrite_test;



PROCEDURE   insert_facture(                                     p_SOCCODE      IN VARCHAR2,
                                                                                                  p_NUMFACT      IN VARCHAR2,
                                                                                                  p_TYPFACT        IN  CHAR,
                                                               p_DATFACT        IN DATE,
                                                                                                   p_MONTHT         IN VARCHAR2,
                                                               p_MONTTTC       IN VARCHAR2,
                                                             p_NUMCONT      IN VARCHAR2,
                                                             p_CAV                    IN VARCHAR2,
                                                             p_CD_EXPENSE  IN  VARCHAR2,
                                                             p_CUSAG_EXPENSE  IN  VARCHAR2,
                                                             p_NUM_EXPENSE IN VARCHAR2,
                                                             p_DATE_COMPTA IN DATE,
                                                             p_TOPPOST     IN VARCHAR2 ,
                                                             p_CDEB                    IN DATE,
                                                             p_ccentrefrais       IN NUMBER,
                                                             p_socfour                 IN VARCHAR2,
                                                             p_tva               IN FACTURE.FTVA%TYPE,
                                                             p_codcompta         IN VARCHAR2,
                                                             p_deppole              IN NUMBER
                                                                )  IS



 l_msg  VARCHAR2(1024);
 l_cusag_num NUMBER;

BEGIN


--PPM 50056 : Si le CUSAG est < -10000 ou >= 100000 charger à vide le champ CUSAG de la table FACTURE

l_cusag_num := CAST( REPLACE(p_CUSAG_EXPENSE,'.',',') AS NUMBER);

IF (l_cusag_num >= 100000 OR l_cusag_num < -10000) THEN
  l_cusag_num := NULL;
END IF;


 DBMS_OUTPUT.put_line(' Insert ligne table facture');


  INSERT INTO FACTURE( SOCFACT,
                                                       NUMFACT,
                                                       TYPFACT,
                                                       DATFACT,
                                                       FNUMASN,
                                                       FNUMORDRE,
                                                       FREGCOMPTA,
                                                       LLIBANALYT,
                                                       FMODREGLT,
                                                       FMOIACOMPTA,
                                                       FMONTHT,
                                                       FMONTTTC,
                                                       FCODUSER,
                                                       FCENTREFRAIS,
                                                       FDATMAJ,
                                                       FDATSAI,
                                                       FENRCOMPTA,
                                                       FSTATUT1,
                                                       FSTATUT2,
                                                       FACCSEC,
                                                       FSOCFOUR,
                                                       FTVA,
                                                       FCODCOMPTA,
                                                       FDEPPOLE,
                                                       FLAGLOCK,
                                                       SOCCONT,
                                                       CAV,
                                                       NUMCONT,
                                                       FDATRECEP,
                                                       NUM_SMS,
                                                       REF_SG,
                                                       NUM_CHARG,
                                                       NUM_EXPENSE,
                                                       CUSAG_EXPENSE,
                                                       FDATINT   -- TD 744
                                                )
                            VALUES(  p_SOCCODE,
                                                 p_NUMFACT,
                                                 p_TYPFACT,
                                                 p_DATFACT,
                                                 0,
                                                 0,
                                                 NULL,
                                                 p_SOCCODE || '-'|| TO_CHAR(p_cdeb,'MMYYYY') ||  '-' || p_NUMFACT || '-' || p_numcont,
                                                 p_TOPPOST,
                                                 TO_DATE(TO_CHAR(SYSDATE,'MM/YYYY'),'MM/YYYY'),
                                                 p_MONTHT,
                                                 p_MONTTTC,
                                                 'EXPENSE_BIS',
                                                 p_ccentrefrais,
                                                 SYSDATE,
                                                 p_DATE_COMPTA,
                                                 p_DATE_COMPTA,
                                                 'SE',
                                                 '  ',
                                                 NULL,
                                                 p_socfour,
                                                 ROUND(p_tva,1),
                                                 p_codcompta,
                                                 p_deppole,
                                                 0,
                                                 p_soccode,
                                                 p_cav,
                                                 p_numcont,
                                                 p_datfact,
                                                 '',
                                                 '',
                                                 '',
                                                 p_NUM_EXPENSE,
                                                 l_cusag_num,
                                                 to_date(to_char(SYSDATE,'DD/MM/YYYY'),'DD/MM/YYYY') -- TD 744
                                                );



      EXCEPTION

                   WHEN DUP_VAL_ON_INDEX THEN
                   BEGIN


                                UPDATE  FACTURE
                                SET
                                                       FNUMASN=0,
                                                       FNUMORDRE=0,
                                                       FREGCOMPTA=NULL,
                                                       LLIBANALYT=p_SOCCODE || '-'|| TO_CHAR(p_cdeb,'MMYYYY') ||  '-' || p_NUMFACT || '-' || p_numcont,
                                                       FMODREGLT=p_TOPPOST,
                                                       FMOIACOMPTA=TO_DATE(TO_CHAR(SYSDATE,'MM/YYYY'),'MM/YYYY'),
                                                       FMONTHT=p_MONTHT,
                                                       FMONTTTC=p_MONTTTC,
                                                       FCODUSER= 'EXPENSE_BIS',
                                                       FCENTREFRAIS=p_ccentrefrais,
                                                       FDATMAJ= SYSDATE,
                                                       FDATSAI=p_DATE_COMPTA,
                                                       FENRCOMPTA=p_DATE_COMPTA,
                                                       FSTATUT1='SE',
                                                       FSTATUT2='  ',
                                                       FACCSEC=NULL,
                                                       FSOCFOUR=p_socfour,
                                                       FTVA=p_tva,
                                                       FCODCOMPTA=p_codcompta,
                                                       FDEPPOLE=p_deppole,
                                                       FLAGLOCK=0,
                                                       SOCCONT=p_soccode,
                                                       CAV=p_cav,
                                                       NUMCONT=p_numcont,
                                                       FDATRECEP=p_datfact,
                                                       NUM_SMS='',
                                                       REF_SG='',
                                                       NUM_CHARG='',
                                                       NUM_EXPENSE=p_NUM_EXPENSE ,
                                                       CUSAG_EXPENSE=CAST( REPLACE(p_CUSAG_EXPENSE,'.',',') AS NUMBER)
                                        WHERE SOCFACT=p_SOCCODE AND DATFACT=p_DATFACT AND TYPFACT=p_TYPFACT AND NUMFACT=p_NUMFACT;


                              INSERT INTO EBIS_DATEMAJ_FACTURE (SOCFACT, NUMFACT, TYPFACT,
                                                             DATFACT, DATMAJEXPENSE )
                              VALUES( p_SOCCODE,p_NUMFACT, p_TYPFACT,p_DATFACT,SYSDATE) ;

                              EXCEPTION WHEN OTHERS THEN
                                --Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
                                --RAISE_APPLICATION_ERROR(-20401, l_msg);
                                raise_application_error(-20997, p_NUMFACT);

                               ROLLBACK;
                               COMMIT ;
                             END ;

               WHEN OTHERS THEN
                 --Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
                 --RAISE_APPLICATION_ERROR(-20401, l_msg);
                 raise_application_error(-20997, p_NUMFACT);




                 ROLLBACK;

            COMMIT ;

END insert_facture;





PROCEDURE    insert_ligne_facture(p_MONTHT            IN LIGNE_FACT.LMONTHT%TYPE,
                                                                         p_codcompta         IN VARCHAR2,
                                                                         p_deppole               IN NUMBER,
                                                                         p_CDEB                    IN DATE,
                                                                         p_SOCCODE          IN VARCHAR2,
                                                                            p_TYPFACT            IN  CHAR,
                                                                         p_DATFACT            IN DATE,
                                                                         p_NUMFACT           IN VARCHAR2,
                                                                         p_tva                          IN NUMBER,
                                                                         p_ident                      IN NUMBER,
                                                                         p_num                        IN NUMBER
                                                                         )   IS


 l_msg  VARCHAR2(1024);


BEGIN

 DBMS_OUTPUT.put_line(' insert ligne table ligne_facture');


  INSERT INTO LIGNE_FACT(LNUM,
                                                            LMONTHT,
                                                            LCODCOMPTA,
                                                            LDEPPOLE,
                                                            LMOISPREST,
                                                            SOCFACT,
                                                               TYPFACT,
                                                            DATFACT,
                                                            NUMFACT,
                                                            TVA,
                                                            IDENT
                                                          )
                            VALUES(  p_num,
                                                p_MONTHT,
                                                p_codcompta,
                                                p_deppole,
                                                p_CDEB,
                                                p_SOCCODE,
                                                   p_TYPFACT,
                                                p_DATFACT,
                                                p_NUMFACT,
                                                p_tva,
                                                p_ident
                                                );


EXCEPTION

        WHEN DUP_VAL_ON_INDEX THEN
         BEGIN



                        UPDATE LIGNE_FACT SET LMONTHT= p_MONTHT ,  LCODCOMPTA=p_codcompta,
                                                                                  LDEPPOLE=p_deppole, LMOISPREST=p_CDEB
                        WHERE SOCFACT=p_SOCCODE  AND NUMFACT=p_NUMFACT
                        AND TYPFACT=p_TYPFACT AND DATFACT=p_DATFACT
                        AND LNUM=p_num;


                        INSERT INTO EBIS_DATEMAJ_LIGNE_FACT (LNUM,   SOCFACT, NUMFACT, TYPFACT,
                                                             DATFACT, DATMAJEXPENSE )
                        VALUES(  p_num, p_SOCCODE, p_NUMFACT,p_TYPFACT,p_DATFACT,SYSDATE) ;

                        EXCEPTION WHEN OTHERS THEN
                               Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
                                RAISE_APPLICATION_ERROR(-20401,' ERROR : Duplicate ligne facture');
                               --RAISE_APPLICATION_ERROR(-20401, l_msg);
                               ROLLBACK;
                               COMMIT ;
        END ;



        WHEN OTHERS THEN
                  -- Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
                  --RAISE_APPLICATION_ERROR(-20401, l_msg);
                  raise_application_error(-20997, SQLERRM);
             ROLLBACK;


        COMMIT ;
END insert_ligne_facture;







-- ======================================================================
--   Contrat ressource logs pour tout le périmètre
-- ======================================================================
PROCEDURE CONTRAT_RESSOURCE_REJET(P_LOGDIR          IN VARCHAR2) IS

L_HFILE                         UTL_FILE.FILE_TYPE;
L_RETCOD                  NUMBER;
L_PROCNAME            VARCHAR2(35) := 'CONTRAT_RESSOURCE_REJET';

v_date                             DATE;
v_var                                NUMBER;
v_champ_contrat         VARCHAR2(50);
v_champ_ressource  VARCHAR2(50);
v_commentaire            VARCHAR2(160);
v_cout         NUMBER(12,2) ;
v_champ_numcont VARCHAR2(50);
v_champ_cav    VARCHAR2(50);
v_champ_lcnum  VARCHAR2(50);
v_champ_lsoccode VARCHAR2(50);
v_top_actif VARCHAR2(50);
v_top_actif2 VARCHAR2(50);
v_type_ress VARCHAR2(50);
v_code_localisation VARCHAR2(50);
v_date1 date;
v_date2 date;
v_date3 date;
v_date_deb_contrat      DATE ;
v_valide NUMBER;
v_date_deb_contrat_boucle      DATE ;

v_ligne_situress SITU_RESS%ROWTYPE ;

v_str PACK_GLOBAL.t_array;
v_count NUMBER;
v_tmp VARCHAR2(30);
v_es_trouve NUMBER;
v_niveau NUMBER;
niv_rec NUMBER;


--Flag signalant si une erreur a été rencontrée : utilisé afin d'apporter plus de lisibilité
v_error        NUMBER(1) ;
v_contrat_ko_mc NUMBER;
v_contrat_ko_es NUMBER;

    CURSOR csr_contrat IS
                       SELECT lc.numcont, lc.soccont, lc.cav,lc.lcnum, lc.ident, lc.lresdeb, lc.lresfin,lc.lccouact , c.codsg, si.coddir , c.siren, d.codref codref,c.CTYPFACT,lc.MODE_CONTRACTUEL,r.RTYPE, si.CENTRACTIV
                       FROM CONTRAT c,LIGNE_CONT lc, STRUCT_INFO si, directions d,ressource r
                       WHERE c.numcont=lc.numcont AND c.soccont=lc.soccont AND c.cav=lc.cav
                       AND lc.ident = r.ident
                       AND ( ( lc.lresdeb <=  SYSDATE AND  lc.lresfin>= SYSDATE) OR (lc.lresfin between ADD_MONTHS(SYSDATE,-6) and SYSDATE) ) -- Ajout par DDI le 10/07/2007
                       AND (( c.cdatdeb <= SYSDATE AND c.cdatfin>= SYSDATE) OR (c.cdatfin between ADD_MONTHS(SYSDATE,-6) and SYSDATE) )
                       AND si.codsg=c.codsg
                       AND si.coddir = d.coddir
                       and d.syscompta in ('EXP');

   --  Curseur sur les situation_ressources rattachés à la ligne contrat en cours de traitement
   --  boucle ci dessus
   CURSOR cur_situress_ligne_contrat (p_ident SITU_RESS.IDENT%TYPE ,
                                          p_lresdeb SITU_RESS.DATSITU%TYPE,
                                      p_lresfin SITU_RESS.DATDEP%TYPE) IS

                                     SELECT IDENT,MAX(DATSITU) DATSITU,DATDEP
                                        FROM SITU_RESS WHERE ident = p_ident    AND
                                        --(datsitu <=  p_lresfin AND (datdep IS NULL OR datdep >=  p_lresdeb))
                                        (( p_lresfin  between DATSITU and DATDEP ) OR  (p_lresfin  >= DATSITU AND DATDEP is null))
                                        GROUP BY IDENT,DATDEP     ;



    BEGIN


       v_champ_contrat := '';
       v_champ_ressource  := '';
       v_commentaire := '';

         -- Troncature EXP_CONTRAT_REJET
         Packbatch.DYNA_TRUNCATE('EXP_CONTRAT_REJET');

         -- YSB : Fiche 970 (4.13)
         select to_date(to_char(date_effet,'dd/mm/yyyy'),'dd/mm/yyyy') into v_date1 from date_effet where code_action = 'REFONTECTRAPRESTA-D1' and code_version = '2010' and rownum = 1;
         select to_date(to_char(date_effet,'dd/mm/yyyy'),'dd/mm/yyyy') into v_date2 from date_effet where code_action = 'REFONTECTRAPRESTA-D2' and code_version = '2010' and rownum = 1;
         select to_date(to_char(date_effet,'dd/mm/yyyy'),'dd/mm/yyyy') into v_date3 from date_effet where code_action = 'REFONTECTRAPRESTA-D3' and code_version = '2010' and rownum = 1;


        FOR rec_contrat IN csr_contrat LOOP


            BEGIN

             v_error := 0  ;

             v_date_deb_contrat := TO_DATE(TO_CHAR(rec_contrat.lresdeb,'mmyyyy') ,'mmyyyy')  ;


             -- Parcours de toutes les lignes

             -- On regarde tout d'abord si la ligne contrat est elligible pour l'export
             -- si elle ne l'est pas, on la met en error mais on ne la met pas dans EXP_CONTRAT_REJET

             -- Vérification des exclusions paramétrées par paramètres BIP FILTRECTRACONSO




             IF (Controle_param_bip(rec_contrat.coddir,rec_contrat.mode_contractuel,rec_contrat.centractiv) = 1) THEN
                v_error:=1;
              END IF;




              IF (v_error = 0) THEN

                --  TEST 1 : Vérification que la sociét de la  ligne contrat possède  un fournisseur EBIS
                SELECT count(*) into v_var
                 FROM EBIS_FOURNISSEURS  WHERE EBIS_FOURNISSEURS.SOCCODE = rec_contrat.soccont ;

                 IF(v_var <= 0 )  THEN

                        v_commentaire :=    ' Le soccode : '|| rec_contrat.soccont ||' est inexistant dans les fournisseurs EBIS pour le numéro de contrat:'|| rec_contrat.numcont ||' ';
                       INSERT INTO EXP_CONTRAT_REJET (     NUMCONT,
                                                                     SOCCONT,
                                                                     CAV,
                                                                     LCNUM,
                                                                     IDENT,
                                                                     CHAMP_CONTRAT,
                                                                     CHAMP_RESSOURCE,
                                                                     COMMENTAIRE
                                                                )
                                                                     VALUES(rec_contrat.numcont,
                                                                    rec_contrat.soccont,
                                                                     rec_contrat.cav,
                                                                      rec_contrat.lcnum,
                                                                       rec_contrat.ident,
                                                                        v_champ_lsoccode  ,
                                                                      v_champ_ressource,
                                                                     v_commentaire
                                                                    );

                                v_error := 1 ;

                  END IF;

              END IF;

                       IF (v_error = 0) THEN
                             SELECT count(*) into v_var
                              FROM EBIS_FOURNISSEURS  WHERE EBIS_FOURNISSEURS.SOCCODE = rec_contrat.soccont AND EBIS_FOURNISSEURS.SIREN = rec_contrat.siren ;

                    IF(v_var <= 0 )  THEN

                                v_commentaire :=    'Problème de SIREN pour le soccode : '|| rec_contrat.soccont ||'  dans les fournisseur EBIS pour le contrat:'|| rec_contrat.numcont ||' ';
                                            INSERT INTO EXP_CONTRAT_REJET (
                                                                                         NUMCONT,
                                                                                         SOCCONT,
                                                                                         CAV,
                                                                                         LCNUM,
                                                                                         IDENT,
                                                                                         CHAMP_CONTRAT,
                                                                                         CHAMP_RESSOURCE,
                                                                                         COMMENTAIRE
                                                                                    )
                                                                                    VALUES
                                                                                    (
                                                                                    rec_contrat.numcont,
                                                                                    rec_contrat.soccont,
                                                                                    rec_contrat.cav,
                                                                                    rec_contrat.lcnum,
                                                                                    rec_contrat.ident,
                                                                                    v_champ_lsoccode  ,
                                                                                    v_champ_ressource,
                                                                                    v_commentaire
                                                                                    );

                                v_error := 1 ;

                    END IF ;
                   end if;

                IF (v_error = 0) THEN
                             SELECT count(*) into v_var
                              FROM EBIS_FOURNISSEURS  WHERE EBIS_FOURNISSEURS.SOCCODE = rec_contrat.soccont AND EBIS_FOURNISSEURS.SIREN = rec_contrat.siren AND EBIS_FOURNISSEURS.REFERENTIEL = rec_contrat.codref;

                    IF(v_var <= 0 )  THEN

                               v_commentaire :=    'Problème de REFERENTIEL pour le soccode : '|| rec_contrat.soccont ||' et le siren : '|| rec_contrat.siren ||'  dans les fournisseur EBIS pour le contrat:'|| rec_contrat.numcont ||' ';

                                          INSERT INTO EXP_CONTRAT_REJET (
                                                                                         NUMCONT,
                                                                                         SOCCONT,
                                                                                         CAV,
                                                                                         LCNUM,
                                                                                         IDENT,
                                                                                         CHAMP_CONTRAT,
                                                                                         CHAMP_RESSOURCE,
                                                                                         COMMENTAIRE
                                                                                    )
                                                                                    VALUES
                                                                                    (
                                                                                    rec_contrat.numcont,
                                                                                    rec_contrat.soccont,
                                                                                    rec_contrat.cav,
                                                                                    rec_contrat.lcnum,
                                                                                    rec_contrat.ident,
                                                                                    v_champ_lsoccode  ,
                                                                                    v_champ_ressource,
                                                                                    v_commentaire
                                                                                    );


                                v_error := 1 ;

                    END IF ;
                   end if;


             IF(v_error = 0) THEN
                                 --  TEST  : Vérification qu'il y a une situation ouverte sur le contrat

                                 select count(*) into v_var from
                                 (
                                     SELECT IDENT,MAX(DATSITU),DATDEP
                                     FROM SITU_RESS WHERE ident = rec_contrat.ident    AND
                                                         (( rec_contrat.lresfin between DATSITU and DATDEP ) OR  (rec_contrat.lresfin >= DATSITU AND DATDEP is null))
                                     GROUP BY IDENT,DATDEP
                                 );



                                IF(v_var <= 0 )  THEN
                                                        v_commentaire :=    'Il n y a pas de situation ouverte sur le numéro de contrat suivant :  ('|| rec_contrat.numcont ||') et situ_ressource suivante (ident:'|| rec_contrat.ident ||')';
                                     INSERT INTO EXP_CONTRAT_REJET (
                                                                                         NUMCONT,
                                                                                         SOCCONT,
                                                                                         CAV,
                                                                                         LCNUM,
                                                                                         IDENT,
                                                                                         CHAMP_CONTRAT,
                                                                                         CHAMP_RESSOURCE,
                                                                                         COMMENTAIRE
                                                                                    )
                                                                                    VALUES
                                                                                    (
                                                                                    rec_contrat.numcont,
                                                                                    rec_contrat.soccont,
                                                                                    rec_contrat.cav,
                                                                                    rec_contrat.lcnum,
                                                                                    rec_contrat.ident,
                                                                                    v_champ_lsoccode  ,
                                                                                    v_champ_ressource,
                                                                                    v_commentaire
                                                                                    );


                                                v_error := 1 ;

                                  END IF ;
              END IF ;




                IF(v_error = 0) THEN

                     -- TEST 2  : Vérification que le  code société  est identique à celui de la ligne contrat
                    -- pour toutes les situ_ressources lui appartenant
                     select count(*) into v_var from
                     (
                         SELECT sr.IDENT,MAX(sr.DATSITU),sr.DATDEP
                         FROM SITU_RESS sr WHERE sr.ident = rec_contrat.ident    AND
                                               (( rec_contrat.lresfin between sr.DATSITU and sr.DATDEP ) OR  (rec_contrat.lresfin >= sr.DATSITU AND sr.DATDEP is null))
                                              AND sr.SOCCODE != rec_contrat.SOCCONT
                                              AND sr.SOCCODE != 'SG..'
                                              GROUP BY sr.IDENT,sr.DATDEP
                     );


                        IF (v_var > 0) THEN
                           select SOCCODE into v_champ_ressource from
                            (
                                 SELECT sr.IDENT,MAX(sr.DATSITU),sr.DATDEP ,sr.soccode
                                 FROM SITU_RESS sr WHERE sr.ident = rec_contrat.ident    AND
                                                      --(sr.datsitu <=  rec_contrat.lresfin AND (sr.datdep IS NULL OR sr.datdep >=  v_date_deb_contrat))
                                                       (( rec_contrat.lresfin between sr.DATSITU and sr.DATDEP ) OR  (rec_contrat.lresfin >= sr.DATSITU AND sr.DATDEP is null))
                                                      AND sr.SOCCODE != rec_contrat.SOCCONT
                                                      AND sr.SOCCODE != 'SG..'
                                                      AND ROWNUM = 1
                                                      GROUP BY sr.IDENT,sr.DATDEP ,sr.SOCCODE
                             );

                           v_commentaire :=    'Le code société :('|| rec_contrat.SOCCONT||') de la ligne contrat est différent du code contrat de la situation ressource ('|| v_champ_ressource ||') ';
                           INSERT INTO  EXP_CONTRAT_REJET (
                                                                                                                        NUMCONT,
                                                                                                                        SOCCONT,
                                                                                                                        CAV,
                                                                                                                        LCNUM,
                                                                                                                        IDENT,
                                                                                                                        CHAMP_CONTRAT,
                                                                                                                        CHAMP_RESSOURCE,
                                                                                                                        COMMENTAIRE)
                                                                                                    VALUES(rec_contrat.numcont,
                                                                                                                       rec_contrat.soccont,
                                                                                                                       rec_contrat.cav,
                                                                                                                       rec_contrat.lcnum,
                                                                                                                       rec_contrat.ident,
                                                                                                                       v_champ_contrat ,
                                                                                                                       v_champ_ressource,
                                                                                                                       v_commentaire
                                                                                                                       );


                          v_error := 1 ;
                    END IF ;
                END IF ;

  -- BSA 18/05/2011 QC 1184
/*
                IF (v_error = 0) THEN

                     -- TEST 3 :
                    -- Pour une ligne contrat donnée et une situ ressource les DPG
                    -- doivent posséder le même CODDIR

                    select count(*) into v_var from
                     (
                         SELECT sr.IDENT,MAX(sr.DATSITU),sr.DATDEP , sinfo.coddir
                         FROM SITU_RESS sr , STRUCT_INFO sinfo WHERE sr.ident = rec_contrat.ident
                                                    --AND (sr.datsitu <=  rec_contrat.lresfin AND (sr.datdep IS NULL OR sr.datdep >=  v_date_deb_contrat))
                                              AND
                                               (( rec_contrat.lresfin between sr.DATSITU and sr.DATDEP ) OR  (rec_contrat.lresfin >= sr.DATSITU AND sr.DATDEP is null))
                                              AND sinfo.CODSG = sr.CODSG
                                              AND rec_contrat.coddir != sinfo.coddir
                                              GROUP BY sr.IDENT,sr.DATDEP ,sinfo.coddir
                     );




                    IF(v_var > 0)  THEN

                         SELECT coddir INTO v_champ_ressource FROM
                     (
                         SELECT sr.IDENT,MAX(sr.DATSITU),sr.DATDEP , sinfo.coddir
                         FROM SITU_RESS sr , STRUCT_INFO sinfo WHERE sr.ident = rec_contrat.ident    AND
                                                   --(sr.datsitu <=  rec_contrat.lresfin AND (sr.datdep IS NULL OR sr.datdep >=  v_date_deb_contrat))
                                              (( rec_contrat.lresfin between sr.DATSITU and sr.DATDEP ) OR  (rec_contrat.lresfin >= sr.DATSITU AND sr.DATDEP is null))
                                              AND sinfo.CODSG = sr.CODSG
                                              AND rec_contrat.coddir != sinfo.coddir
                                              AND ROWNUM = 1
                                              GROUP BY sr.IDENT,sr.DATDEP,sinfo.coddir
                     );


                        v_champ_contrat := TO_CHAR(rec_contrat.lresdeb,'dd/mm/yyyy');
                        v_commentaire := ' Le code direction de la ligne contrat : '|| rec_contrat.coddir ||' est différent du code direction : '|| v_champ_ressource ||'  de la situation ressource (ident :'|| rec_contrat.ident||')  ';

                        INSERT INTO  EXP_CONTRAT_REJET (
                                                                                                                        NUMCONT,
                                                                                                                        SOCCONT,
                                                                                                                        CAV,
                                                                                                                        LCNUM,
                                                                                                                        IDENT,
                                                                                                                        CHAMP_CONTRAT,
                                                                                                                        CHAMP_RESSOURCE,
                                                                                                                        COMMENTAIRE)
                                                                                                    VALUES(rec_contrat.numcont,
                                                                                                                       rec_contrat.soccont,
                                                                                                                       rec_contrat.cav,
                                                                                                                       rec_contrat.lcnum,
                                                                                                                       rec_contrat.ident,
                                                                                                                       '' ,
                                                                                                                       v_champ_ressource,
                                                                                                                       v_commentaire
                                                                                                                       );


                  v_error := 1 ;

                     END IF ;
                END IF ;

*/
-- Fin QC 1184

                 IF (v_error = 0) THEN

                    -- TEST 6 :
                    -- La qualification des ressources doit être différent de  " IFO " ; " SLT "." GRA ", " INT " ou " STA ".

                    select count(*) into v_var from
                     (
                         SELECT sr.IDENT,MAX(sr.DATSITU),sr.DATDEP
                         FROM SITU_RESS sr WHERE

                         sr.ident = rec_contrat.ident
                         AND (( rec_contrat.lresfin between sr.DATSITU and sr.DATDEP ) OR  (rec_contrat.lresfin >= sr.DATSITU AND sr.DATDEP is null))
                         AND sr.prestation in ('IFO','SLT','GRA','INT','STA')
                         GROUP BY sr.IDENT,sr.DATDEP
                     );




                    IF(v_var > 0)  THEN

                        v_commentaire := ' La qualification de la ressources fait partie de la liste : IFO, SLT, GRA, INT, STA ';
                        INSERT INTO  EXP_CONTRAT_REJET (
                                                                                                                        NUMCONT,
                                                                                                                        SOCCONT,
                                                                                                                        CAV,
                                                                                                                        LCNUM,
                                                                                                                        IDENT,
                                                                                                                        CHAMP_CONTRAT,
                                                                                                                        CHAMP_RESSOURCE,
                                                                                                                        COMMENTAIRE)
                                                                                                    VALUES(rec_contrat.numcont,
                                                                                                                       rec_contrat.soccont,
                                                                                                                       rec_contrat.cav,
                                                                                                                       rec_contrat.lcnum,
                                                                                                                       rec_contrat.ident,
                                                                                                                       '' ,
                                                                                                                       v_champ_ressource,
                                                                                                                       v_commentaire
                                                                                                                       );


                  v_error := 1 ;

                     END IF ;
                END IF ;


              --YNI fiche 887 20/10/2009
              IF (v_error = 0) THEN
                    -- TEST 7 :
                    -- Pour une ligne contrat donnée, le cout journalier ht actualise doit etre superieur a 50 euros
                    IF(rec_contrat.LCCOUACT < 50)  THEN
                        v_commentaire := ' Cout du contrat anormalement bas ';
                        INSERT INTO  EXP_CONTRAT_REJET (
                                                              NUMCONT,
                                                              SOCCONT,
                                                              CAV,
                                                              LCNUM,
                                                              IDENT,
                                                              CHAMP_CONTRAT,
                                                              CHAMP_RESSOURCE,
                                                              COMMENTAIRE)
                                                       VALUES(rec_contrat.numcont,
                                                              rec_contrat.soccont,
                                                              rec_contrat.cav,
                                                              rec_contrat.lcnum,
                                                              rec_contrat.ident,
                                                              '' ,
                                                              v_champ_ressource,
                                                              v_commentaire
                                                              );
                  v_error := 1 ;

                     END IF ;
                END IF ;
              --Fin YNI


                  commit;
                IF (v_error = 0) THEN

                      -- TEST 5
                     --  Vérification que les situations ressource de la ligne contrat en cours de traitement ( boucle principale)
                     --  ne soient pas affectés à une autre ligne contrat pour la même période

                     -- parcours de toutes les SITU_RESSOURCES VALIDES DE LA LIGNE_CONTRAT EN COURS TRAITEMENT ( BOUCLE PRINCIPALE )
                     FOR curseur_situ_ress IN cur_situress_ligne_contrat(rec_contrat.ident,v_date_deb_contrat,rec_contrat.lresfin) LOOP
                          BEGIN



                        SELECT count(*) INTO v_var from
                        ( SELECT curseur_situ_ress.ident,MAX(sr.DATSITU),sr.datdep
                                                                   FROM CONTRAT c,LIGNE_CONT lc,SITU_RESS sr ,STRUCT_INFO si, directions d
                                                                   WHERE c.numcont=lc.numcont AND c.soccont=lc.soccont AND c.cav=lc.cav
                                                                   AND ( ( lc.lresdeb <=  SYSDATE AND  lc.lresfin>= SYSDATE) OR (lc.lresfin between ADD_MONTHS(SYSDATE,-6) and SYSDATE) )
                                                                   AND si.codsg=c.codsg
                                                                   and si.coddir = d.coddir
                                                                   and d.syscompta in ('EXP')

                                                                   -- Va cherche la même ligne SITU_RESS que celle du curseur
                                                                   AND sr.ident = curseur_situ_ress.ident
                                                                   AND sr.DATSITU = curseur_situ_ress.DATSITU

                                                                    AND lc.IDENT =     sr.ident


                                                                    AND (( lc.lresfin between sr.DATSITU  and sr.DATDEP ) OR  (lc.lresfin >= sr.DATSITU AND sr.DATDEP is null))


                                                                    --Exclusion LIGNE CONTRAT EN COURS
                                                                    AND lc.numcont != rec_contrat.numcont

                                                                    -- Ligne contrat chevauche la ligne contrat en cours
                                                                    AND  ( (lc.lresdeb >= rec_contrat.lresdeb AND  lc.lresdeb <= rec_contrat.lresfin)
                                                                           OR (lc.lresfin >= rec_contrat.lresdeb AND  lc.lresfin <= rec_contrat.lresfin))

                                                                    --Exclusion LIGNES CONTRAT DEJA DANS EXP_CONTRAT_REJET
                                                                    AND lc.numcont NOT IN (SELECT DISTINCT logs.numcont from EXP_CONTRAT_REJET logs WHERE
                                                                    logs.NUMCONT = lc.numcont AND logs.SOCCONT = lc.soccont AND
                                                                    logs.CAV = lc.CAV and logs.lcnum = lc.LCNUM AND ROWNUM = 1 )

                                                                    --YNI
                                                                    --Exclusion des lignes contrat dont le LCCOUACT inferieur a 50 euros
                                                                    --AND lc.LCCOUACT > 50


                                                                    GROUP BY sr.IDENT, sr.DATDEP
                                                                    )
                                                                    ;




                                        IF (v_var > 0 ) THEN
                                         SELECT numcont INTO  v_champ_numcont from
                                                 ( SELECT curseur_situ_ress.ident,MAX(sr.DATSITU),sr.datdep ,lc.numcont
                                                                   FROM CONTRAT c,LIGNE_CONT lc,SITU_RESS sr ,STRUCT_INFO si, directions d
                                                                   WHERE c.numcont=lc.numcont AND c.soccont=lc.soccont AND c.cav=lc.cav
                                                                   AND ( ( lc.lresdeb <=  SYSDATE AND  lc.lresfin>= SYSDATE) OR (lc.lresfin between ADD_MONTHS(SYSDATE,-6) and SYSDATE) )
                                                                   AND si.codsg=c.codsg
                                                                    and si.coddir = d.coddir
                                                                   and d.syscompta in ('EXP')


                                                                   -- Va cherche la même ligne SITU_RESS que celle du curseur
                                                                   AND sr.ident = curseur_situ_ress.ident
                                                                   AND sr.DATSITU = curseur_situ_ress.DATSITU

                                                                    AND lc.IDENT =     sr.ident


                                                                    AND (( lc.lresfin     between sr.DATSITU  and sr.DATDEP ) OR  (lc.lresfin >= sr.DATSITU AND sr.DATDEP is null))


                                                                    --Exclusion LIGNE CONTRAT EN COURS
                                                                    AND lc.numcont != rec_contrat.numcont

                                                                    -- Ligne contrat chevauche la ligne contrat en cours
                                                                    AND  ( (lc.lresdeb >= rec_contrat.lresdeb AND  lc.lresdeb <= rec_contrat.lresfin)
                                                                           OR (lc.lresfin >= rec_contrat.lresdeb AND  lc.lresfin <= rec_contrat.lresfin))

                                                                    --Exclusion LIGNES CONTRAT DEJA DANS EXP_CONTRAT_REJET
                                                                    AND lc.numcont NOT IN (SELECT DISTINCT logs.numcont from EXP_CONTRAT_REJET logs WHERE
                                                                    logs.NUMCONT = lc.numcont AND logs.SOCCONT = lc.soccont AND
                                                                    logs.CAV = lc.CAV and logs.lcnum = lc.LCNUM AND ROWNUM = 1 )

                                                                    --YNI
                                                                    --Exclusion des lignes contrat dont le LCCOUACT inferieur a 50 euros
                                                                    --AND lc.LCCOUACT > 50

                                                                    AND ROWNUM = 1
                                                                    GROUP BY sr.IDENT, sr.DATDEP , lc.numcont
                                                                    )
                                                                    ;








                                             v_commentaire :=   'Pour la situation ressource (ident:'|| curseur_situ_ress.ident||') Il existe une autre ligne contrat (numcont:'|| v_champ_numcont ||')';


                                             INSERT INTO  EXP_CONTRAT_REJET (
                                                                                                                                        NUMCONT,
                                                                                                                                        SOCCONT,
                                                                                                                                        CAV,
                                                                                                                                        LCNUM,
                                                                                                                                        IDENT,
                                                                                                                                        CHAMP_CONTRAT,
                                                                                                                                        CHAMP_RESSOURCE,
                                                                                                                                        COMMENTAIRE)
                                                                                                                    VALUES(rec_contrat.numcont,
                                                                                                                                       rec_contrat.soccont,
                                                                                                                                       rec_contrat.cav,
                                                                                                                                       rec_contrat.lcnum,
                                                                                                                                       rec_contrat.ident,
                                                                                                                                       v_champ_contrat ,
                                                                                                                                       v_champ_ressource,
                                                                                                                                       v_commentaire
                                                                                                                                       );



                                                      v_error := 1 ;

                                          END IF ;


                          EXIT WHEN  (v_var >0) ;

                          END;
                      END LOOP ;

                 END IF ;

             IF (v_error = 0) THEN

                 FOR curseur_situ_ress IN cur_situress_ligne_contrat(rec_contrat.ident,v_date_deb_contrat,rec_contrat.lresfin) LOOP

                     BEGIN
                      select count(*) into v_var
                      from situ_ress sr
                      where sr.ident = curseur_situ_ress.ident
                           AND sr.DATSITU = curseur_situ_ress.DATSITU
                           and cout < 10 ;

                            IF (v_var > 0 ) THEN

                                v_commentaire := ' Cout de la situation (datsitu:'|| curseur_situ_ress.DATSITU ||') de la ressource (ident:'|| curseur_situ_ress.ident||') anormalement bas ';
                                    INSERT INTO  EXP_CONTRAT_REJET (
                                                              NUMCONT,
                                                              SOCCONT,
                                                              CAV,
                                                              LCNUM,
                                                              IDENT,
                                                              CHAMP_CONTRAT,
                                                              CHAMP_RESSOURCE,
                                                              COMMENTAIRE)
                                                       VALUES(rec_contrat.numcont,
                                                              rec_contrat.soccont,
                                                              rec_contrat.cav,
                                                              rec_contrat.lcnum,
                                                              rec_contrat.ident,
                                                              '' ,
                                                              v_champ_ressource,
                                                              v_commentaire
                                                              );


                             v_error := 1 ;
                            END IF;
                     END;

                 END LOOP;

             END IF;


              IF (v_error = 0) THEN

                  -- Test 8 :

                  IF (v_date1 <= to_date(to_char(sysdate,'dd/mm/yyyy'),'dd/mm/yyyy'))
                  OR
                     (to_date(to_char(rec_contrat.lresfin,'dd/mm/yyyy'),'dd/mm/yyyy') >= v_date2)
                  THEN

                  BEGIN
                    select TYPE_RESSOURCE,TOP_ACTIF,CODE_LOCALISATION
                      into v_type_ress,v_top_actif,v_code_localisation
                      from mode_contractuel
                      where CODE_CONTRACTUEL = rec_contrat.MODE_CONTRACTUEL;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      null;
                   END;

                  BEGIN
                    SELECT pr.TOP_ACTIF  into v_top_actif2
                        FROM  SITU_RESS sr , prestation pr
                        WHERE sr.ident = rec_contrat.ident
                        AND sr.PRESTATION = pr.prestation
                        AND rownum = 1
                        order by DATSITU desc;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      null;
                   END;

                   v_valide := pack_situation_p.verif_situ_ligcont(rec_contrat.ident,rec_contrat.soccont,rec_contrat.lresdeb,rec_contrat.lresfin);

                  -- Type de facturation et MC non compatibles
                  -- cas  où le type de facturation est R ou M (correspond au type P)

                   IF (
                          (rec_contrat.CTYPFACT = 'F')
                        and
                          ((v_type_ress = 'F') or (v_type_ress = 'E') or (v_type_ress = 'L') or (v_type_ress = '*'))
                      ) THEN
                      v_var := 0;
                   ELSIF(
                          ((rec_contrat.CTYPFACT = 'R') or (rec_contrat.CTYPFACT = 'M'))
                        and
                          ((rec_contrat.SOCCONT <> 'SG..') and ((v_type_ress = 'P') or (v_type_ress = '*')))
                        ) THEN
                      v_var := 0;
                   ELSE
                      v_var := 1;
                   END IF;

                    IF (v_var > 0 ) THEN

                      v_commentaire := 'Le mode contractuel de la ligne est incompatible avec le type de facturation de l''en-tête ';
                      INSERT INTO  EXP_CONTRAT_REJET (
                                                            NUMCONT,
                                                            SOCCONT,
                                                            CAV,
                                                            LCNUM,
                                                            IDENT,
                                                            CHAMP_CONTRAT,
                                                            CHAMP_RESSOURCE,
                                                            COMMENTAIRE)
                            VALUES(rec_contrat.numcont,
                                                           rec_contrat.soccont,
                                                           rec_contrat.cav,
                                                           rec_contrat.lcnum,
                                                           rec_contrat.ident,
                                                           '' ,
                                                           v_champ_ressource,
                                                           v_commentaire
                                                           );

                      v_error := 1;
                      v_var := 0 ;
                    END IF;

                  -- Type de ressource et MC non comptatibles

                  IF (v_error = 0) THEN
                    IF((rec_contrat.rtype !=  v_type_ress) and ((v_type_ress != '*') and (rec_contrat.rtype != '*'))) THEN
                        v_commentaire := 'Le mode contractuel de la ligne est incompatible avec le Type de ressource de la ressource';
                        INSERT INTO  EXP_CONTRAT_REJET (
                                                              NUMCONT,
                                                              SOCCONT,
                                                              CAV,
                                                              LCNUM,
                                                              IDENT,
                                                              CHAMP_CONTRAT,
                                                              CHAMP_RESSOURCE,
                                                              COMMENTAIRE)
                              VALUES(rec_contrat.numcont,
                                                             rec_contrat.soccont,
                                                             rec_contrat.cav,
                                                             rec_contrat.lcnum,
                                                             rec_contrat.ident,
                                                             '' ,
                                                             v_champ_ressource,
                                                             v_commentaire
                                                             );

                        v_error := 1;
                    END IF;
                  END IF;

                  -- le Mode contractuel n'est pas valide

                  IF (v_error = 0) THEN
                    IF((rec_contrat.MODE_CONTRACTUEL is null)
                          or
                       (rec_contrat.MODE_CONTRACTUEL = '')
                          or
                       (rec_contrat.MODE_CONTRACTUEL = 'XXX')
                          or
                       (rec_contrat.MODE_CONTRACTUEL = '???')
                          or
                       (v_top_actif = 'N')
                      ) THEN
                        v_commentaire := 'Le mode contractuel de la ligne est invalide ou inactif';

                        INSERT INTO  EXP_CONTRAT_REJET (
                                                        NUMCONT,
                                                        SOCCONT,
                                                        CAV,
                                                        LCNUM,
                                                        IDENT,
                                                        CHAMP_CONTRAT,
                                                        CHAMP_RESSOURCE,
                                                        COMMENTAIRE)
                        VALUES(rec_contrat.numcont,
                                                       rec_contrat.soccont,
                                                       rec_contrat.cav,
                                                       rec_contrat.lcnum,
                                                       rec_contrat.ident,
                                                       '' ,
                                                       v_champ_ressource,
                                                       v_commentaire
                                                       );

                      v_error := 1;

                    END IF;
                  END IF;

                  -- le Code localisation attaché au Mode contractuel n¿est pas valide

                  IF (v_error = 0) THEN

                  select count(*) into v_var from localisation where CODE_LOCALISATION = v_code_localisation;


                   IF(
                       (v_code_localisation is null)
                          or
                       (v_code_localisation = '')
                       or
                       (v_code_localisation =  ' ')
                       or
                       (v_var = 0 )
                      ) THEN
                        v_commentaire := 'Le mode contractuel de la ligne est invalide en raison d''un code localisation incorrect';

                        INSERT INTO  EXP_CONTRAT_REJET (
                                                        NUMCONT,
                                                        SOCCONT,
                                                        CAV,
                                                        LCNUM,
                                                        IDENT,
                                                        CHAMP_CONTRAT,
                                                        CHAMP_RESSOURCE,
                                                        COMMENTAIRE)
                        VALUES(rec_contrat.numcont,
                                                       rec_contrat.soccont,
                                                       rec_contrat.cav,
                                                       rec_contrat.lcnum,
                                                       rec_contrat.ident,
                                                       '' ,
                                                       v_champ_ressource,
                                                       v_commentaire
                                                       );

                      v_error := 1;

                    END IF;
                  END IF;


                  -- compatibilité d'une ligne contrat par rapport à la situation
                  IF (v_error = 0) THEN
                    IF(v_valide = 0) THEN
                        v_commentaire := 'Pas de situation trouvée avec une date compatible avec le contrat';

                        INSERT INTO  EXP_CONTRAT_REJET (
                                                        NUMCONT,
                                                        SOCCONT,
                                                        CAV,
                                                        LCNUM,
                                                        IDENT,
                                                        CHAMP_CONTRAT,
                                                        CHAMP_RESSOURCE,
                                                        COMMENTAIRE)
                        VALUES(rec_contrat.numcont,
                                                       rec_contrat.soccont,
                                                       rec_contrat.cav,
                                                       rec_contrat.lcnum,
                                                       rec_contrat.ident,
                                                       '' ,
                                                       v_champ_ressource,
                                                       v_commentaire
                                                       );

                      v_error := 1;

                    END IF;
                  END IF;



                  -- le Code prestation attaché à la situation liée à la ligne est inactif



                  IF (v_error = 0 and (to_date(to_char(rec_contrat.lresfin,'dd/mm/yyyy'),'dd/mm/yyyy') >= v_date3) ) THEN
                    IF(v_top_actif2 = 'N') THEN

                        v_commentaire := 'Le code prestation lié à la situation de la ressource attachée à cette ligne, est inactif';

                        INSERT INTO  EXP_CONTRAT_REJET (
                                                        NUMCONT,
                                                        SOCCONT,
                                                        CAV,
                                                        LCNUM,
                                                        IDENT,
                                                        CHAMP_CONTRAT,
                                                        CHAMP_RESSOURCE,
                                                        COMMENTAIRE)
                        VALUES(rec_contrat.numcont,
                                                       rec_contrat.soccont,
                                                       rec_contrat.cav,
                                                       rec_contrat.lcnum,
                                                       rec_contrat.ident,
                                                       '' ,
                                                       v_champ_ressource,
                                                       v_commentaire
                                                       );

                      v_error := 1;

                    END IF;
                  END IF;



                  END IF;

              END IF ;

            END;

        END LOOP;



        -----------------------------------------------------
        -- Trace Stop
        -----------------------------------------------------
        --Trclog.Trclog( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
        --Trclog.CLOSETRCLOG( L_HFILE );



   EXCEPTION
        WHEN OTHERS THEN

            IF SQLCODE <> TRCLOG_FAILED_ID THEN
                raise_application_error( -20997, SQLERRM);
                RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID, 'Erreur : consulter le fichier LOG', FALSE );
            ELSE
                RAISE;
            END IF;


    COMMIT ;


END CONTRAT_RESSOURCE_REJET;





-- ======================================================================
-- Extraction des réalisés non ramassés pour lapplication ExpenseBis
-- Fiche 613 : Logs TT ebis
-- ======================================================================
PROCEDURE export_tt_rejet(    p_chemin_fichier    IN VARCHAR2,
                   p_nom_fichier        IN VARCHAR2   ) IS





            -- CURSEUR RAMENANT L'ENSEMBLE DES SITUATIONS RESSOURCES
            -- ( IDENTIQUE A L'EXPORT DES REALISES)
            CURSOR csr_realise IS


                                            SELECT
                                                        d.MOISMENS  moisprest,
                                                        SUM(cs.cusag) nbjours,
                                                        LPAD(r.ident,5,0) ident ,
                                                        sr.codsg,
                                                        sr.SOCCODE,
                                                        sr.datdep  ,
                                                        d2.syscompta


                                              FROM
                                               RESSOURCE r, SITU_RESS sr,
                                               STRUCT_INFO si2 , DIRECTIONS d2,
                                               CONS_SSTACHE_RES_MOIS cs, LIGNE_BIP lb,
                                               TACHE t, DATDEBEX d
                                              WHERE
                                              sr.ident=r.ident
                                              AND sr.PRESTATION NOT IN ('IFO','GRA','MO','INT','STA','SLT')
                                              --AND ( r.rtype='P' OR ( r.rtype<>'P'  AND sr.montant_mensuel IS NOT NULL AND sr.montant_mensuel <> 0)) -- Ressources de type P ou ayant un montant_mensuel 12ieme
                                              AND r.rtype='P'  -- Ressources de type P
                                              AND (TO_DATE(TO_CHAR(sr.DATSITU,'dd/mm/yyyy'),'dd/mm/yyyy') <= d.MOISMENS AND (TO_DATE(TO_CHAR(sr.DATDEP,'dd/mm/yyyy'),'dd/mm/yyyy') >= d.MOISMENS OR sr.DATDEP IS NULL) )
                                              -- La ligne contrat et la situation ressource doivent normalement avoir le même code
                                              -- société ne doit pas être 'SG..'
                                              AND sr.SOCCODE <> 'SG..'

                                              AND si2.codsg=sr.codsg
                                              AND si2.coddir = d2.coddir
                                              AND d2.SYSCOMPTA in ('EXP')

                                              AND sr.ident=cs.ident(+)
                                              AND ( cs.cdeb IS NULL OR cs.cdeb=d.moismens)
                                              AND lb.pid(+)=cs.pid
                                              AND t.pid(+)=cs.pid
                                              AND t.ecet(+)=cs.ecet
                                              AND t.acta(+)=cs.acta
                                              AND t.acst(+)=cs.acst
                                              AND (lb.typproj <> 7 OR lb.typproj IS NULL OR ( lb.typproj=7  AND t.aist NOT IN ('FORMAT','ABSDIV','MOBIL','PARTIE','RTT','CONGES','ACCUEI')  ))
                                              GROUP BY
                                              d.moismens, r.ident,r.rtype , sr.montant_mensuel,sr.codsg,sr.SOCCODE,sr.datdep,d2.syscompta
                                               HAVING (r.rtype='P'  AND SUM(cs.cusag)<>0 ) ;


                    -- CURSEUR RAMENANT LES CAS POUR LESQUELS , LA LIGNE CONTRAT ET LA SITUATION RESSOURCE
                    -- UN DES DEUX N4APPARTIENT PAS AU PERIMETRE DES DF
                    CURSOR curseur_perim IS      SELECT

                                                                          --fiche 608 pour table EBIS_EXPORT_REALISE
                                                                    -- on sépare le numcont et cav
                                                                    -- fiche 608 LPAD(trim(c.numcont),15,' ') ||'-'|| c.cav   id_cont,
                                                                    c.soccont ,
                                                                    c.cdatfin,
                                                                    c.numcont numcont,
                                                                    c.cav  cav,
                                                                    --Fiche 608 TO_CHAR(d.MOISMENS,'mmyyyy') moisprest,
                                                                    d.MOISMENS  moisprest,
                                                                    --REPLACE  ( DECODE(r.rtype,'P',NVL(SUM(cs.cusag),0),1) ,',','.') nbjours,
                                                                    --fiche 608 REPLACE  ( SUM(cs.cusag) ,',','.') nbjours,
                                                                    SUM(cs.cusag) nbjours,
                                                                    --fiche 608 TO_CHAR(SYSDATE,'dd/mm/yyyy HH24:MI:SS') date_exec,
                                                                    SYSDATE  date_exec,
                                                                    LPAD(r.ident,5,0) ident,
                                                                    sr.codsg ,
                                                                    sr.datdep ,
                                                                    ef.CODE_FOURNISSEUR_EBIS frxbis,
                                                                    c.codsg codsgcont,
                                                                    d1.SYSCOMPTA syscompta_cont,
                                                                    d2.SYSCOMPTA syscompta_res,

                                                                    d1.coddir coddir,
                                                                    lc.mode_contractuel mode_contractuel,
                                                                    si1.centractiv centractiv


                                              FROM  CONTRAT c, LIGNE_CONT lc, RESSOURCE r, SITU_RESS sr ,STRUCT_INFO si1, STRUCT_INFO si2, CONS_SSTACHE_RES_MOIS cs, LIGNE_BIP lb, TACHE t, DATDEBEX d, EBIS_FOURNISSEURS ef,
                                                    DIRECTIONS d1 , DIRECTIONS d2
                                              WHERE   lc.soccont <> 'SG..'
                                              AND c.numcont=lc.numcont
                                              AND c.soccont=lc.soccont
                                              AND c.cav=lc.cav
                                              AND ( TRUNC(lc.lresdeb,'MM') <=  d.MOISMENS AND  lc.lresfin>= d.MOISMENS)
                                              AND lc.ident=r.ident
                                              AND sr.ident=r.ident
                                              AND sr.PRESTATION NOT IN ('IFO','GRA','MO','INT','STA','SLT')
                                              --AND ( r.rtype='P' OR ( r.rtype<>'P'  AND sr.montant_mensuel IS NOT NULL AND sr.montant_mensuel <> 0)) -- Ressources de type P ou ayant un montant_mensuel 12ieme
                                              AND r.rtype='P'  -- Ressources de type P
                                              AND (TO_DATE(TO_CHAR(sr.DATSITU,'dd/mm/yyyy'),'dd/mm/yyyy') <= d.MOISMENS AND (TO_DATE(TO_CHAR(sr.DATDEP,'dd/mm/yyyy'),'dd/mm/yyyy') >= d.MOISMENS OR sr.DATDEP IS NULL) )

                                              -- CAS POUR L'UN DES DEUX N'APPARTIENT PAS AU PERIMETRE (BU)
                                              AND      si1.codsg=c.codsg
                                                          AND si1.coddir = d1.coddir
                                                          AND si2.codsg=sr.codsg
                                                          AND si2.coddir = d2.coddir
                                                          AND d1.codperim != d2.codperim

                                              -- PERIMETRE EXPENSE
                                              -- CONTRAT
                                              AND d1.syscompta in ('EXP')
                                              -- RESSOURCE
                                              AND d2.syscompta in ('EXP')

                                              AND sr.ident=cs.ident(+)
                                              AND ( cs.cdeb IS NULL OR cs.cdeb=d.moismens)
                                              AND lb.pid(+)=cs.pid
                                              AND t.pid(+)=cs.pid
                                              AND t.ecet(+)=cs.ecet
                                              AND t.acta(+)=cs.acta
                                              AND t.acst(+)=cs.acst
                                              AND c.siren = ef.siren
                                              AND c.soccont = ef.soccode
                                              AND ef.REFERENTIEL = d1.codref
                                              AND (lb.typproj <> 7 OR lb.typproj IS NULL OR ( lb.typproj=7  AND t.aist NOT IN ('FORMAT','ABSDIV','MOBIL','PARTIE','RTT','CONGES','ACCUEI')  ))
                                              GROUP BY c.soccont,c.cdatfin, c.numcont, c.cav,c.cdatfin , d.moismens, r.ident,r.rtype
                                              , sr.montant_mensuel,sr.codsg,sr.datdep, ef.CODE_FOURNISSEUR_EBIS ,
                                              c.codsg , d1.SYSCOMPTA ,  sr.codsg ,  d2.SYSCOMPTA, d1.coddir, lc.mode_contractuel, si1.centractiv

--        la clause à rajouter en cas s'il ne faut pas extraire les ressources de type P sans consommés
          HAVING (r.rtype='P'  AND SUM(cs.cusag)<>0 ) ;





        l_msg  VARCHAR2(1024);
        l_moismens DATE  ;
        l_message_erreur VARCHAR2(500);
        l_retour NUMBER ;
        l_soccont CHAR(4) ;
        l_rnom VARCHAR2(30)  ;
        l_ident_precedent NUMBER(5) ;
        l_time_stamp DATE ;
        l_numcont VARCHAR2(27);
        l_cav  VARCHAR2(3);
        l_cdatfin DATE;
        l_siren NUMBER(9);
        l_erreur_detectee NUMBER ;

        l_codsg_cont NUMBER(7);
        l_syscomp_cont VARCHAR2(3) ;
        l_syscomp_res  VARCHAR2(3) ;
        l_coddir NUMBER(2);
        l_mode_contractuel VARCHAR2(5);
        l_centractiv NUMBER(6);


        v_error NUMBER;


        l_hfile UTL_FILE.FILE_TYPE;


    BEGIN


         BEGIN

            DELETE FROM EXP_TT_REJET ;

            SELECT SYSDATE INTO l_time_stamp FROM DUAL ;


            -----------------------------------------------------------------------------
              -- 1 ) PARCOURS DES SITUATIONS RESSOURCE
            -----------------------------------------------------------------------------
            FOR curseur_sr IN csr_realise  LOOP

                    v_error := 0 ;

                    -- Récupère le nom de la ressource issue du curseur
                    SELECT rnom INTO l_rnom FROM RESSOURCE   r WHERE
                    r.ident=  curseur_sr.ident   ;

                                  -----------------------------------------------------------------------
                                  --  1-1 )   RECHERCHE S'IL EXISTE UNE LIGNE CONTRAT POUR LA SITUATION
                                  -----------------------------------------------------------------------
                                  SELECT COUNT(*) INTO l_retour
                                              FROM
                                                   CONTRAT c, LIGNE_CONT lc,
                                                   STRUCT_INFO si1 , DIRECTIONS d1 ,
                                                   DATDEBEX d
                                                   , EBIS_FOURNISSEURS ef
                                              WHERE
                                              lc.soccont <> 'SG..'
                                              AND c.numcont=lc.numcont
                                              AND c.soccont=lc.soccont
                                              AND c.cav=lc.cav
                                              AND ( TRUNC(lc.lresdeb,'MM') <=  d.MOISMENS AND  lc.lresfin>= d.MOISMENS)
                                              AND lc.ident=curseur_sr.ident
                                              AND si1.codsg=c.codsg
                                              AND si1.coddir = d1.coddir
                                              AND d1.SYSCOMPTA in ('EXP')
                                              AND c.siren = ef.siren
                                              AND c.soccont = ef.soccode
                                              AND ef.REFERENTIEL = d1.codref;



                            -- Si aucune ligne contrat existe pour la ressource  : écriture table des logs
                              IF (l_retour <=  0 ) THEN

                                                  v_error := 1 ;
                                                  l_message_erreur := 'Pas de contrat sur la période pour cette ressource';

                                                  ecrit_table_rejet_tt(   curseur_sr.codsg ,  curseur_sr.soccode, curseur_sr.ident,
                                                  l_rnom, curseur_sr.moisprest, curseur_sr.nbjours,   curseur_sr.datdep,NULL,
                                                  NULL,  NULL , l_message_erreur , NULL,NULL,NULL,curseur_sr.syscompta, l_time_stamp, TO_NUMBER('1')) ;


                            END IF ;


                            -- Si une seule ligne contrat existe :
                            IF (l_retour =  1)    THEN


                                        ------------------------------------------------------------------------------------------
                                        -- 1-2 ) TEST SI LA SITUATION RESSOURCE ET LA LIGNE CONTRAT POSSEDENT LE MEME
                                        --       CODE SOCIETE
                                        ------------------------------------------------------------------------------------------
                                        SELECT         c.numcont ,c.cav  ,c.soccont,c.cdatfin  ,c.codsg,d1.SYSCOMPTA, d1.coddir, lc.mode_contractuel, si1.centractiv
                                                         INTO   l_numcont,l_cav ,l_soccont ,l_cdatfin ,
                                                        l_codsg_cont,l_syscomp_cont, l_coddir, l_mode_contractuel, l_centractiv
                                                        FROM
                                                          CONTRAT c, LIGNE_CONT lc,
                                                          STRUCT_INFO si1 , DIRECTIONS d1 ,
                                                          DATDEBEX d , EBIS_FOURNISSEURS ef
                                                          WHERE
                                                          lc.soccont <> 'SG..'
                                                          AND c.numcont=lc.numcont
                                                          AND c.soccont=lc.soccont
                                                          AND c.cav=lc.cav
                                                          AND ( TRUNC(lc.lresdeb,'MM') <=  d.MOISMENS AND  lc.lresfin>= d.MOISMENS)
                                                          AND lc.ident=curseur_sr.ident
                                                          AND si1.codsg=c.codsg
                                                          AND si1.coddir = d1.coddir
                                                          AND d1.SYSCOMPTA in ('EXP')
                                                          AND c.siren = ef.siren
                                                          AND c.soccont = ef.soccode
                                                          AND ef.REFERENTIEL = d1.codref
                                                          AND ROWNUM = 1 ;

                                                           l_syscomp_res := curseur_sr.syscompta;

                                            -- Vérification des exclusions paramétrées par paramètres BIP FILTRECTRACONSO
                                              IF(Controle_param_bip(l_coddir,l_mode_contractuel,l_centractiv) = 0) THEN




                                           IF (TRIM(l_soccont) != TRIM(curseur_sr.SOCCODE)) THEN
                                                        v_error := 1 ;
                                                       l_message_erreur := 'Le contrat et la ressource ont un code société différent';
                                                  ecrit_table_rejet_tt( curseur_sr.codsg ,  curseur_sr.soccode, curseur_sr.ident,
                                                                        l_rnom, curseur_sr.moisprest, curseur_sr.nbjours,   curseur_sr.datdep, l_numcont,
                                                                        l_cav,  l_cdatfin , l_message_erreur , l_soccont,
                                                                        l_codsg_cont,
                                                                        l_syscomp_cont,
                                                                        l_syscomp_res,
                                                                        l_time_stamp,TO_NUMBER('2')) ;
                                            END IF ;

                                           END IF;

                           END IF  ;




              END LOOP ;

     END;

     EXCEPTION
           WHEN OTHERS THEN
            Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20401, l_msg);


END export_tt_rejet;


-- ======================================================================
-- Ecriture des rejets dans la table exp_tt_rejet
-- ======================================================================
 PROCEDURE ecrit_table_rejet_tt(p_dpg IN        NUMBER   ,
                                  p_soccode IN    CHAR ,
                                  p_ident IN      NUMBER ,
                                  p_rnom IN       VARCHAR2  ,
                                  p_lmoisprest IN DATE,
                                  p_cusag IN       NUMBER ,
                                  p_datdep IN DATE,
                                  p_numcont IN VARCHAR2  ,
                                  p_cav IN VARCHAR2  ,
                                  p_cdatfin IN   DATE,
                                  p_message IN VARCHAR2 ,
                                  p_soccont IN    CHAR ,

                                  p_codsg_cont IN NUMBER ,
                                  p_syscomp_cont IN VARCHAR2 ,
                                  p_syscomp_res IN VARCHAR2 ,

                                  p_timestamp IN DATE ,
                                  p_code_retour IN NUMBER ) IS


     l_msg  VARCHAR2(1024);

    BEGIN
                      INSERT INTO EXP_TT_REJET (
                              DPG,
                              SOCCODE,
                              IDENT,
                              RNOM,
                              LMOISPREST,
                              CUSAG,
                              DATDEP,
                              NUMCONT,
                              CAV,
                              CDATFIN,
                              SOCCONT,

                              CODSG_CONT,
                                      SYSCPT_CONT ,
                                SYSCPT_RES,

                              MESSAGE ,
                              DATE_TRAIT,
                              CODE_RETOUR
                              ) VALUES (
                                p_dpg   ,
                                p_soccode  ,
                                p_ident  ,
                                p_rnom ,
                                TO_CHAR(p_lmoisprest,'DD/MM/YYYY'),
                                p_cusag ,
                                p_datdep  ,
                                p_numcont ,
                                p_cav  ,
                                p_cdatfin,
                                p_soccont,

                                p_codsg_cont  ,
                                p_syscomp_cont ,
                                p_syscomp_res  ,

                                p_message ,
                                p_timestamp ,
                                p_code_retour
                           );



    EXCEPTION
           WHEN OTHERS THEN
            Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20401, l_msg);
END ecrit_table_rejet_tt;




END Pack_Expensebis;
/


