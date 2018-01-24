-- pack_14mois PL/SQL
--
-- Equipe SOPRA
--
-- Crée le 02/2000
--
--*************************************************************
-- MODIF :
--
--
--*************************************************************

-- necessite la création d'un link entre la base
-- d'exploitation et la base d'historique
-- ce lien doit se nommer linkexpl
-- ce source doit etre compiler dans la base d'historique
-- test  sami antoine

SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE pack_14mois AS


PROCEDURE sauve_14mois (p_chemin_fichier IN VARCHAR2, -- chemin du log
                        p_nom_fichier    IN VARCHAR2  -- nom du fichier de log
                       );

END pack_14mois;
/
create or replace
PACKAGE BODY      "PACK_14MOIS" AS

 PROCEDURE sauve_14mois(p_chemin_fichier IN VARCHAR2,
                        p_nom_fichier    IN VARCHAR2
                    )IS

  l_msg  VARCHAR2(1024) ;
  l_hfile utl_file.file_type;
  l_schema VARCHAR2(20);
  l_procname VARCHAR2(100);
  -- gestion des erreurs

  erreur_log EXCEPTION ;
  erreur_oracle EXCEPTION ;
  erreur_fonctionnelle EXCEPTION ;
  table_inexistante EXCEPTION ;
  PRAGMA EXCEPTION_INIT(table_inexistante, -942);

  l_retcod NUMBER;
  l_etape VARCHAR2(50);

  -- curseur indiquant pour chaque table archivé
  -- la table correspondant dans l'historique
  -- CLIENT => CLIENT_BIPH1
  --- antoine test

  CURSOR cur_table(l_schema CHAR) IS
     SELECT nom_table || '_' || l_schema new_table,
            nom_table                    old_table
     FROM liste_table_histo;


 BEGIN

     -- *****************************
     -- ETAPE 0 Initialisation du log
     -- *****************************


     l_procname := ' *****sauvegarde 14 mois***** ';

     -- Init de la trace
     -- ----------------
     l_retcod :=0;

     l_retcod := TRCLOG.INITTRCLOG( p_chemin_fichier , p_nom_fichier, l_hfile );
       IF  ( l_retcod <> 0 ) THEN
         raise erreur_log;
       END IF ;


     TRCLOG.TRCLOG( l_hfile, 'Debut de ' || L_PROCNAME );


     -- ********************************************
     -- ETAPE 1 test la liste des tables sauvegardée
     -- ********************************************

     DECLARE
       l_ntable NUMBER ;

     BEGIN
       l_ntable:= 0;
       l_etape := 'Liste des tables sauvegardees';

       SELECT count(NOM_TABLE) INTO l_ntable
       FROM liste_table_histo;

     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         TRCLOG.TRCLOG( l_hfile,'La liste des tables sauvegardées est vide');
         raise erreur_fonctionnelle;
       WHEN OTHERS THEN
         TRCLOG.TRCLOG( l_hfile, 'Fin anormale de ' || l_etape  );
         raise;
     END ;



     -- ***************************************
     -- ETAPE 2 lecture du schema de sauvegarde
     -- ***************************************

     BEGIN

       l_etape := 'lecture du schema de sauvegarde';

       TRCLOG.TRCLOG( l_hfile, l_etape);

       SELECT nom_schema INTO l_schema
       FROM ref_histo rh
       WHERE rh.mois = ( SELECT MIN(rhmin.mois)
                         FROM ref_histo rhmin);

       TRCLOG.TRCLOG( l_hfile, 'Schema de sauvegarde : ' || l_schema);

       TRCLOG.TRCLOG( l_hfile, 'Fin normale de ' || l_etape  );

     EXCEPTION
      WHEN NO_DATA_FOUND THEN
         TRCLOG.TRCLOG( l_hfile,'Pas de schema correspondant au mois');
         raise erreur_fonctionnelle;

      WHEN OTHERS THEN
         TRCLOG.TRCLOG( l_hfile, 'Fin anormale de ' || l_etape  );
         raise;
     END ;


     -- ******************************
     -- ETAPE 3 destruction des tables
     -- ******************************


     DECLARE
     l_compteur NUMBER;
     cid NUMBER ;
     l_lig_com VARCHAR2(1024);
 
     BEGIN

       l_etape := 'Destruction des tables';

       TRCLOG.TRCLOG( l_hfile, 'DEBUT '|| l_etape);


       l_compteur := 0;

       FOR  cur_enr IN cur_table(l_schema)
       LOOP

         -- Creation du curseur pour le SQl dynamique
         cid := DBMS_SQL.OPEN_CURSOR;

         -- Construction de la requète
         l_lig_com := 'DROP TABLE ' || cur_enr.new_table;

         -- execution de la requete
         BEGIN
          DBMS_SQL.PARSE(cid,l_lig_com, DBMS_SQL.V7);

         EXCEPTION
           WHEN table_inexistante THEN
           TRCLOG.TRCLOG( l_hfile,'Table :' || cur_enr.new_table || 'inexistante');
           l_compteur := l_compteur - 1;
           null;

         END ;

         -- fermeture du curseur
         DBMS_SQL.CLOSE_CURSOR(cid);
         l_compteur := l_compteur + 1;

         TRCLOG.TRCLOG( l_hfile, 'Table ' || cur_enr.new_table || ' suprimmee' );

       END LOOP ;

       TRCLOG.TRCLOG( l_hfile, TO_CHAR(l_compteur) || ' tables supprimees');

       TRCLOG.TRCLOG( l_hfile, 'FIN '|| l_etape);

     EXCEPTION
       WHEN OTHERS THEN
         DBMS_SQL.CLOSE_CURSOR(cid);
         TRCLOG.TRCLOG( l_hfile, 'Fin anormale de ' || l_etape  );
         raise;

     END ;


     -- *****************************************************************************
     -- ETAPE 4 creation des tables d'historiques à partir des tables d'exploitations
     -- *****************************************************************************

     DECLARE
       l_compteur NUMBER ;
       cid NUMBER ;
       l_lig_com VARCHAR2(1024);

     BEGIN
       l_compteur := 0;

       l_etape := 'Creation des tables d historiques';

       TRCLOG.TRCLOG( l_hfile, 'DEBUT '|| l_etape);

  FOR  cur_enr IN cur_table(l_schema)
       LOOP
         -- Creation du curseur pour le SQl dynamique

         cid := DBMS_SQL.OPEN_CURSOR;

         l_lig_com := 'CREATE TABLE ' || cur_enr.new_table
                                  || ' TABLESPACE "BIPH_1M_DA"'        
                                  ||' AS SELECT * FROM BIP.'
                                  || cur_enr.old_table;
                                  

         -- Construction de la requète
         DBMS_SQL.PARSE(cid, l_lig_com,DBMS_SQL.V7);

         -- fermeture du curseur
         DBMS_SQL.CLOSE_CURSOR(cid);

         TRCLOG.TRCLOG( l_hfile, 'Table ' || cur_enr.new_table || ' cree' );

         l_compteur := l_compteur + 1;
       END LOOP ;

       TRCLOG.TRCLOG( l_hfile, TO_CHAR(l_compteur) || ' Tables crees');

       TRCLOG.TRCLOG( l_hfile, 'FIN '|| l_etape);

     EXCEPTION
       WHEN table_inexistante THEN
         TRCLOG.TRCLOG( l_hfile,'Copie d une table inexistante');
         raise erreur_fonctionnelle;
       WHEN OTHERS THEN
         DBMS_SQL.CLOSE_CURSOR(cid);
         TRCLOG.TRCLOG( l_hfile, 'Fin anormale de ' || l_etape  );
         raise;

     END ;

/* cette etape n'est pas utilisé
     -- ******************************************
     -- ETAPE 5 rapatriement des données par copie
     -- ******************************************

     DECLARE
       l_compteur NUMBER ;
       cid INTEGER ;
       ret INTEGER ;

     BEGIN
       l_compteur := 0;

       l_etape := 'Copie du contenu des tables';

       TRCLOG.TRCLOG( l_hfile, 'DEBUT de '|| l_etape);

       FOR  cur_enr IN cur_table(l_schema)
       LOOP
         -- Creation du curseur pour le SQl dynamique
         cid := DBMS_SQL.OPEN_CURSOR;

         l_msg := 'COPY FROM bip/bip@bip1 TO biph/biph@bip3 INSERT '
                         || cur_enr.new_table
                         || ' USING SELECT * FROM '
                         || cur_enr.old_table ;

         -- Construction de la requète
         DBMS_SQL.PARSE(cid,l_msg , DBMS_SQL.V7);

         -- fermeture du curseur
         DBMS_SQL.CLOSE_CURSOR(cid);

         l_compteur := l_compteur + 1;

         TRCLOG.TRCLOG( l_hfile, 'Table ' || cur_enr.new_table || ' copie' );

       END LOOP ;

       TRCLOG.TRCLOG( l_hfile, TO_CHAR(l_compteur) || ' Tables copie');

       TRCLOG.TRCLOG( l_hfile, 'FIN normale de '|| l_etape);

     EXCEPTION
       WHEN table_inexistante THEN
         TRCLOG.TRCLOG( l_hfile,'Table inexistante');
         raise erreur_fonctionnelle;
       WHEN OTHERS THEN
         DBMS_SQL.CLOSE_CURSOR(cid);
         TRCLOG.TRCLOG( l_hfile, 'FIN anormale de ' || l_etape  );
         raise;

     END ;
 fin du commentaire */

     -- *****************************
     -- ETAPE 6 allocation des droits
     -- *****************************

     DECLARE
       l_compteur NUMBER ;
       cid NUMBER ;
       cid2 number;
       l_lig_com VARCHAR2(1024);
        l_lig_grant_bip VARCHAR2(1024);

     BEGIN
       l_compteur := 0;

       l_etape := 'Allocation des droits';

       TRCLOG.TRCLOG( l_hfile, 'DEBUT de '|| l_etape);


       FOR  cur_enr IN cur_table(l_schema)
       LOOP
         -- Creation du curseur pour le SQl dynamique
         cid := DBMS_SQL.OPEN_CURSOR;
          -- Creation du curseur pour le SQL dynamique des grants pour le user BIP 
          cid2 := DBMS_SQL.OPEN_CURSOR;   
 
         IF substr(cur_enr.old_table, 1 ,4) = 'TMP_' THEN
            l_lig_com := 'GRANT SELECT,INSERT,UPDATE,DELETE ON ';
         ELSE
            l_lig_com := 'GRANT SELECT ON ';
         END IF;

         l_lig_com := l_lig_com
                         || cur_enr.old_table
                         || '_' ||l_schema
                         || ' TO '
                         || l_schema;

         -- Construction de la requète
         DBMS_SQL.PARSE (cid, l_lig_com, DBMS_SQL.V7);

         -- fermeture du curseur
         DBMS_SQL.CLOSE_CURSOR(cid);
         
          l_lig_grant_bip := 'GRANT SELECT,INSERT,UPDATE,DELETE ON ';
          l_lig_grant_bip := l_lig_grant_bip
                         || cur_enr.old_table
                         || '_' ||l_schema
                         || ' TO '
                         || 'BIP';
         
           -- Construction de la requète
         DBMS_SQL.PARSE (cid2, l_lig_grant_bip, DBMS_SQL.V7);

         -- fermeture du curseur
         DBMS_SQL.CLOSE_CURSOR(cid2);
          l_compteur := l_compteur + 1 ;

       END LOOP ;

       TRCLOG.TRCLOG( l_hfile, TO_CHAR(l_compteur) || ' allocation de droits');

       TRCLOG.TRCLOG( l_hfile, 'FIN normale de '|| l_etape);

     EXCEPTION
      WHEN table_inexistante THEN
         TRCLOG.TRCLOG( l_hfile,'Table inexistante');
         raise erreur_fonctionnelle;

      WHEN OTHERS THEN
         DBMS_SQL.CLOSE_CURSOR(cid);
         TRCLOG.TRCLOG( l_hfile, 'FIN anormale de ' || l_etape  );
         raise;

     END ;

         -- ****************************
     -- ETAPE 7 création des indexes
     -- ****************************

     DECLARE
       -- curseur pour la creation des index à partir de
       -- la table user_objects de la base d'exploitation

       CURSOR cur_index(l_schema CHAR) IS
         SELECT uind.index_name                    nom_ind,
                uind.table_name                    tab_expl,
                uind.table_name || '_' || l_schema tab_hist,
                ucol.column_name                   nom_col,
                ucol.column_position               num_pos
         FROM all_indexes uind,
              all_ind_columns ucol
         WHERE owner = 'BIP' AND index_owner='BIP'
         AND   uind.table_name = ucol.table_name
         AND   uind.index_name = ucol.index_name
         AND   uind.table_name IN ( SELECT nom_table
                                    FROM liste_table_histo )
         ORDER BY nom_ind, tab_expl, num_pos asc;

       cur_enr cur_index%ROWTYPE;
       cid NUMBER ;

       l_tab_expl     VARCHAR2(50);
       l_tab_ref      VARCHAR2(50);
       l_tab_hist     VARCHAR2(50);
       l_nom_ind      VARCHAR2(50);
       l_nom_ind_ref  VARCHAR2(50);
       l_liste_colonne VARCHAR2(100);
       libelle_appel VARCHAR2(100);
       l_creation VARCHAR2(200);
       l_stop BOOLEAN;
       verif_fonc NUMBER;
       pos_1 NUMBER;
       pos_2 NUMBER;

     BEGIN

       l_etape := 'Creation des indexs';

       TRCLOG.TRCLOG( l_hfile, 'DEBUT de '|| l_etape);

       OPEN cur_index(l_schema);
       l_liste_colonne := '';
       l_creation := '';
       l_tab_expl :='';
       l_stop := FALSE;
       l_tab_ref :='';

       LOOP
         FETCH cur_index INTO cur_enr;

           IF cur_index%NOTFOUND THEN
           l_stop := TRUE;
           ELSIF cur_index%ROWCOUNT < 2 THEN
             l_nom_ind_ref := cur_enr.nom_ind;
             l_nom_ind := cur_enr.nom_ind;
           ELSE
             l_nom_ind := cur_enr.nom_ind;
           END IF ;

           IF ((l_nom_ind <> l_nom_ind_ref) OR (l_stop = TRUE)) THEN
              l_liste_colonne := '(' || substr(l_liste_colonne, 2, length(l_liste_colonne)-1 ) || ')';

              -- construction de la requete
              l_creation := 'CREATE INDEX ' || l_nom_ind_ref
                            || '_' || l_schema
                            || ' ON ' || l_tab_hist ||
                            l_liste_colonne ||
                            'TABLESPACE "BIPH_1M_IX"';

              -- Creation du curseur pour le SQl dynamique
              cid := DBMS_SQL.OPEN_CURSOR;

              -- execution de la requète
              DBMS_SQL.PARSE(cid, l_creation, DBMS_SQL.V7);

              -- fermeture du curseur
              DBMS_SQL.CLOSE_CURSOR(cid);

              IF l_stop = TRUE THEN EXIT;
              END IF ;

              -- re-initialisation de la liste des colonnes
              l_liste_colonne := '';
              l_creation := '';
              -- re-initialisation de l'index a creer
              l_nom_ind_ref := l_nom_ind;

            END IF ;
              -- PPM 49272 : STERIA 08/04/2013
              verif_fonc := 0;
              -- Prise en charge des noms de colonnes qui sont en fait des appels de fonctions
              -- de type trim(pid) par exemple
              select count(*)
              into verif_fonc
              from all_ind_expressions
              WHERE table_owner = 'BIP'
              and index_name = cur_enr.nom_ind;

              -- Si le nom de colonne est un apppel de fonction alors
              -- un traitement de chaine de caractères est effectué afin de récuper le nom de colonne

              if (verif_fonc = 1) then

              -- Récupération du libéllé de l'appel de fonction
              select column_expression
              into libelle_appel
              from all_ind_expressions
              WHERE table_owner = 'BIP'
              and index_name = cur_enr.nom_ind;

              cur_enr.nom_col := libelle_appel;
              end if;

              l_liste_colonne := l_liste_colonne || ',' || cur_enr.nom_col;

              l_tab_hist := cur_enr.tab_hist;

       END LOOP ;

       CLOSE cur_index;

       TRCLOG.TRCLOG( l_hfile, 'FIN normale de '|| l_etape);

     EXCEPTION
      WHEN OTHERS THEN
         DBMS_SQL.CLOSE_CURSOR(cid);
         TRCLOG.TRCLOG( l_hfile, 'FIN anormale de ' || l_etape  );
         raise;
     END ;


     -- ******************************************
     -- ETAPE 8 mis a jour du tableau de référence
     -- avec la date du mois précédent
     -- PPM 58843 : mis a jour du tableau de référence 
     -- avec la date du mensuelle du mois courant 
     -- de la table DATDEBEX
     -- ******************************************

     DECLARE
       update_vide EXCEPTION ;
	   d_moismens date;-- PPM 58843

     BEGIN
       l_etape := 'Maj du tableau de reference';

       TRCLOG.TRCLOG( l_hfile, 'DEBUT de '|| l_etape);
	   -- PPM 58843 : date du mensuel de la table datdebex
       select moismens into d_moismens from datdebex;
		---- PPM 58843 : utilisation directe de moismens au lieu de sysdate-1 
       UPDATE ref_histo
	    --SET mois = trunc(add_months(sysdate, -1), 'month') -- PPM 58843
       SET mois = trunc(d_moismens, 'month')
       WHERE nom_schema = l_schema;

       IF SQL%ROWCOUNT = 0 THEN
         raise update_vide ;
       END IF ;

       commit;

       TRCLOG.TRCLOG( l_hfile, 'le schema '|| l_schema ||
                               'est associe au mois ' ||
							    TO_CHAR(d_moismens, 'MM/YYYY'));
                               --TO_CHAR(add_months(sysdate, -1), 'MM/YYYY'));--PPM 58843

       TRCLOG.TRCLOG( l_hfile, 'FIN normale de '|| l_etape);

     EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         TRCLOG.TRCLOG( l_hfile,'La date de sauvegarde existe déjà');
         TRCLOG.TRCLOG( l_hfile, 'FIN anormale de ' || l_etape  );
         rollback;
         null;
      WHEN update_vide THEN
         TRCLOG.TRCLOG( l_hfile,'La table de reference n est pas mise à jour');
         TRCLOG.TRCLOG( l_hfile, 'FIN anormale de ' || l_etape  );
         rollback;
         null;
      WHEN OTHERS THEN
         TRCLOG.TRCLOG( l_hfile, 'FIN anormale de ' || l_etape  );
         raise;

     END ;

     -- ******************************************
     -- ETAPE 9 fin de la trace
     -- ******************************************

     TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
     TRCLOG.CLOSETRCLOG( L_HFILE );

 EXCEPTION
   WHEN erreur_fonctionnelle THEN
         TRCLOG.TRCLOG( L_HFILE, 'Fin anormale de ' || L_PROCNAME  );
         TRCLOG.CLOSETRCLOG( L_HFILE );
         RAISE_APPLICATION_ERROR(-20000, 'Consulter le fichier log', FALSE);
   WHEN erreur_log THEN
         TRCLOG.TRCLOG( L_HFILE, 'Fin anormale de ' || L_PROCNAME  );
         TRCLOG.CLOSETRCLOG( L_HFILE );
         RAISE_APPLICATION_ERROR(-20000, 'Erreur de la gestion du log', FALSE);
   WHEN OTHERS THEN
         TRCLOG.TRCLOG( L_HFILE, l_procname || ':' || SQLERRM );
         TRCLOG.CLOSETRCLOG( L_HFILE );
         RAISE_APPLICATION_ERROR(-20000, 'Consulter le fichier log', FALSE);

 END sauve_14mois;


END pack_14mois;
/
