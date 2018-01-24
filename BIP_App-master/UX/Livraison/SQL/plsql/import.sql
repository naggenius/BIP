

--
-- pack_import_cs1 PL/SQL
--
-- Import valid\351 par SEGL
--
-- Equipe SOPRA
--
-- Cr\351\351 le 04/01/2000
-- Modifi\351 le
--  04/07/2000 par NCM : modif du fichier import avec une ent\352te en plus
--  16/08/2000     NCM : ajout fonction getURL pour voir le fichier import \340partir de l'application
--  27/09/2000     NCM : ajout d'un 2 devant le code centre d'activit\351
--  14/10/2000     NCM : nouvelle structure de la table import_compta_data
--                       Les lignes de import_compta_data sont supprim\351es lors d'un nouvel import dans le script import_cgi
--  20/10/2000     NCM : dans certains cas, ligne vide en fin de fichier
--  17/10/2007     DDI : Modif de la mise à jour du num_sms
--*************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...


--*************************************************************
--
--   package pack_import_cs1
--
--*************************************************************
-- REESCON   :  consomm\351s JH SSII (resscon2 et resscon3)

--SET SERVEROUTPUT ON

CREATE OR REPLACE PACKAGE pack_import_cs1 AS

   PROCEDURE traite_import_cs1     ( p_userid                 IN CHAR,
                                     p_chemin_fichier         IN VARCHAR2,
                                     p_nom_fichier            IN VARCHAR2

                                   );
END pack_import_cs1;
/

--*************************************************************
--
--               corps du package pack_import_cs1
--
--*************************************************************

CREATE OR REPLACE PACKAGE BODY pack_import_cs1 AS
-- ********************************************************************
-- FONCTION getURL : sert \340 visualiser le fichier import
-- ********************************************************************

-- *********************************************************************************
-- PROCEDURE traite_import_cs1 : traite les factures import\351es
-- *********************************************************************************
   PROCEDURE traite_import_cs1     ( p_userid           IN CHAR,
                                     p_chemin_fichier   IN VARCHAR2,
                                     p_nom_fichier      IN VARCHAR2
                                   ) IS

   l_msg        varchar2(1024);
   l_ligne_fichier varchar2(2000);
   l_hfile utl_file.file_type;
   l_test varchar2(4);
   probleme_insertion EXCEPTION;
   pas_facture_traite EXCEPTION;
   filiale_differente EXCEPTION;
      pas_num_sms EXCEPTION;
   l_flag_maj BOOLEAN;

   /*** Curseur pour lire les lignes de la table import_compta_data ***/
   CURSOR curimp IS
        select socfact,numfact,typfact,num_sms
        from import_compta_data
        where nom_fichier=p_nom_fichier;

   BEGIN

      -- insertion du compte rendu si necessaire

      UPDATE import_compta_log
      SET  etat = 'en cours de traitement'
      WHERE userid = p_userid
      AND nom_fichier = p_nom_fichier
      AND date_trait = trunc(sysdate);

      IF SQL%NOTFOUND THEN
        INSERT INTO import_compta_log ( userid, nom_fichier, etat, date_trait)
        VALUES (p_userid, p_nom_fichier, 'en cours de traitement', TRUNC(sysdate));
        COMMIT;
      END IF;

      -- ouverture du fichier
      l_hfile := UTL_FILE.FOPEN(p_chemin_fichier, p_nom_fichier, 'r');


      -- Bloc d'insertion dans la table temporaire

      DECLARE
      l_socfact facture.socfact%TYPE;
      l_typfact facture.typfact%TYPE;
      l_numfact facture.numfact%TYPE;
      l_interne_sms VARCHAR2(15);
      l_code_erreur INTEGER;
      l_lib_erreur VARCHAR2(200);
      l_pos1 INTEGER ;
      l_pos2 INTEGER ;
      l_pos3 INTEGER ;
      l_pos4 INTEGER ;
      l_posuser  INTEGER ;
      l_count number;
      l_champ1 VARCHAR2(30);

      BEGIN
l_count:=0;

/* Ne pas prendre en compte l'ent\352te ie la premi\350re ligne*/
    UTL_FILE.GET_LINE(l_hfile, l_ligne_fichier);
     DBMS_OUTPUT.PUT_LINE('on lance la boucle');
    LOOP
          -- lecture de chaque ligne du fichier apr\350s l'ent\352te
          UTL_FILE.GET_LINE(l_hfile, l_ligne_fichier);
l_count:=l_count+1;
DBMS_OUTPUT.PUT_LINE(l_count);

          -- position des s\351parateurs
                l_pos1 := TO_NUMBER(INSTR(l_ligne_fichier, ';', 1, 1));
                l_pos2 := TO_NUMBER(INSTR(l_ligne_fichier, ';', 1, 2));
                l_pos3 := TO_NUMBER(INSTR(l_ligne_fichier, ';', 1, 3));
                l_pos4 := TO_NUMBER(INSTR(l_ligne_fichier, ';', 1, 4));

                l_champ1 := SUBSTR(l_ligne_fichier, 1, l_pos1-1);
                DBMS_OUTPUT.PUT_LINE('l_champ1 : ' || l_champ1);
                l_socfact := SUBSTR(l_ligne_fichier, 1, 4);
                DBMS_OUTPUT.PUT_LINE('l_socfact : ' || l_socfact);
                -- 10 pour 30 - [ 4(socfact)+15(numfact)+1(typfact) ]
                -- le champ18 (fichier export) possede dans les details factureun identifiant de longueur max 10
                -- c'est cet identifiant tronque qui se trouve dans le detail des lignes ici
                l_posuser := INSTR(l_ligne_fichier, SUBSTR(p_userid, 1, 10), 1);

                l_typfact := SUBSTR(l_ligne_fichier, l_posuser-1, 1);
                DBMS_OUTPUT.PUT_LINE('l_typfact : ' || l_typfact);
                l_numfact := SUBSTR(l_ligne_fichier, 5, l_posuser-6);   -- -6 pour 4(socfact) + 1(typfact) + 1(espace)
                DBMS_OUTPUT.PUT_LINE('l_numfact : ' || l_numfact);

          l_interne_sms := SUBSTR(l_ligne_fichier, l_pos1 +1 ,l_pos2 - l_pos1 -1);

          l_code_erreur := TO_NUMBER(SUBSTR(l_ligne_fichier, l_pos2 +1 ,l_pos3 - l_pos2 - 1));

          l_lib_erreur := SUBSTR(l_ligne_fichier, l_pos4 +1 ,195);

          -- insertion dans la table contenant les lignes des fichiers d'importation
          	INSERT INTO import_compta_data (userid, nom_fichier,socfact, numfact,typfact, num_sms, code_error,lib_error)
         	VALUES(p_userid, p_nom_fichier, l_socfact, l_numfact, l_typfact, l_interne_sms, l_code_erreur,l_lib_erreur);

        commit;
    END LOOP;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          COMMIT;
          UTL_FILE.FCLOSE(l_hfile);
        WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Exception');
          if (l_pos1!=0) then
           ROLLBACK;
           raise probleme_insertion;
         else   --cas o\371 il y a une ligne vide \340 la fin du fichier
          COMMIT;
          UTL_FILE.FCLOSE(l_hfile);
         end if;

      END;

      -- MAJ des factures

      /*MAJ NUM_SMS*/
	  DBMS_OUTPUT.PUT_LINE('MAJ NUM_SMS dans la table FACTURE');
      UPDATE facture fac
      SET fac.num_sms = (SELECT data.num_sms FROM import_compta_data data
                        WHERE fac.socfact  = data.socfact
                        AND   fac.typfact  = data.typfact
                        AND   fac.numfact  = data.numfact
                        AND data.num_sms IS NOT NULL
						AND data.STATUT1 != 'IN')
      WHERE (socfact,numfact,typfact) in (SELECT socfact,numfact,typfact FROM import_compta_data)
      AND fac.num_sms IS NULL
      ;
     IF SQL%NOTFOUND THEN
          raise pas_num_sms;
      END IF;
      COMMIT;

      l_flag_maj := FALSE;
	  DBMS_OUTPUT.PUT_LINE('MAJ fastatut1 = VA  dans la table FACTURE');
      UPDATE facture fac SET fac.fstatut1 = 'VA'
      WHERE EXISTS (SELECT 1 FROM import_compta_data data
                    WHERE fac.socfact  = data.socfact
                    AND   fac.typfact  = data.typfact
                    AND   fac.numfact  = data.numfact
                    AND   data.code_error = 0)
      AND fac.fstatut1 = 'EN';

      IF SQL%NOTFOUND THEN l_flag_maj := TRUE;
      END IF;
	  DBMS_OUTPUT.PUT_LINE('MAJ fastatut1 = IN  dans la table FACTURE');
      UPDATE facture fac SET fac.fstatut1 = 'IN'
      WHERE     EXISTS (SELECT 1 FROM import_compta_data data
                        WHERE fac.socfact  = data.socfact
                        AND   fac.typfact  = data.typfact
                        AND   fac.numfact  = data.numfact
                        AND   data.code_error <> 0)
      AND fac.fstatut1 = 'EN';

      IF SQL%NOTFOUND AND l_flag_maj = TRUE THEN
          raise pas_facture_traite;
      END IF;

      COMMIT;
  -- Ajout de la date de facture et du statut CS1 pour l'\351tat de controle des fichiers imports
 DECLARE
      l_date date;
      l_statut char(2);
  BEGIN

      FOR cur_enr IN curimp
      LOOP
        select f.datfact,f.fstatut1 into l_date,l_statut
        from facture f
        where f.socfact=cur_enr.socfact
          and f.numfact=cur_enr.numfact
          and f.typfact=cur_enr.typfact;

        update import_compta_data i
        set      datfact=l_date,
                statut1=l_statut
        where i.socfact=cur_enr.socfact
          and i.numfact=cur_enr.numfact
          and i.typfact=cur_enr.typfact;

      END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
                commit;

   END;

      -- MAJ effectu\351e fin de proc\351dure
      -- MAJ de la table des logs

      UPDATE import_compta_log
      SET ETAT = 'Fichier traite'
      WHERE userid = p_userid
      AND   nom_fichier = p_nom_fichier
      AND   date_trait = trunc(sysdate);

      COMMIT;

  EXCEPTION

     WHEN probleme_insertion THEN
          -- mise \340 jour du log
          UPDATE import_compta_log
          SET ETAT = 'Erreur rencontr\351e lors de l''insertion des factures consulter la bip'
          WHERE userid = p_userid
          AND   nom_fichier = p_nom_fichier
          AND   date_trait = trunc(sysdate);
          COMMIT;
     WHEN pas_facture_traite THEN
          -- mise \340 jour du log
          UPDATE import_compta_log
          SET ETAT = 'Pas de facture a importer'
                    WHERE userid = p_userid
          AND   nom_fichier = p_nom_fichier
          AND   date_trait = trunc(sysdate);
          COMMIT;
      WHEN pas_num_sms THEN
          -- mise à jour du log
          UPDATE import_compta_log
          SET ETAT = 'SMS'
          WHERE userid = p_userid
          AND   nom_fichier = p_nom_fichier
          AND   date_trait = trunc(sysdate);
          COMMIT;
     WHEN filiale_differente THEN
          -- maj du log
          UPDATE import_compta_log
          SET ETAT = 'Le fichier comporte des factures avec des filiales diff\351rente contacter la BIP'
          WHERE userid = p_userid
          AND   nom_fichier = p_nom_fichier
          AND   date_trait = trunc(sysdate);
          COMMIT;
           WHEN OTHERS THEN
        raise_application_error(-20997, SQLERRM);

   END traite_import_cs1;

END pack_import_cs1;
/

