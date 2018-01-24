-- pack_dossier_projet PL/SQL
--
-- Equipe SOPRA
--
-- Cree le 11/02/1999
-- Attention le nom du package ne peut etre le nom
-- de la table...
-- Quand    Qui   Quoi
-- -----    ---   ----------------------------------------------------------------------------------------
-- 07/07/00 QHL   ajout test integrity exception lors des update, insert (exception -2291 -> +600) 
--                et delete (exception -2292 -> +750)
-- 03/11/03 PJO	  Ajout de la donnée date d'immobilisation
-- 19/09/06 ASI	  Ajout des champs directeur de projet 1 et directeur de projet 2
-- 08/10/08 ABA TD 697
-- 11/01/2013 TCO PPM 30653
-- *********************************************************************************
--       Procedure   SUPPRESSION  DOSSIER PROJET 
-- *********************************************************************************

CREATE OR REPLACE PACKAGE     pack_dossier_projet AS


    TYPE dossier_projetCurType IS REF CURSOR RETURN dossier_projet%ROWTYPE;
--HMI
TYPE ListeViewType IS RECORD(code   VARCHAR2(5), libelle VARCHAR2(30)
                                        );
TYPE listeCurType IS REF CURSOR RETURN ListeViewType;
--FIN HMI
--PPM 59288 : debut
 PROCEDURE dir_prin_dp(p_dpcode IN VARCHAR2, p_valeur OUT VARCHAR2, p_message   OUT VARCHAR2);
 PROCEDURE liste_dir_dbs (p_valeur OUT VARCHAR2, p_message   OUT VARCHAR2);
 PROCEDURE liste_dir_dp_immo(p_valeur OUT VARCHAR2, p_message   OUT VARCHAR2);
 FUNCTION is_obligation_dbs(p_dirprin   IN NUMBER, p_message   OUT VARCHAR2) RETURN BOOLEAN;--PPM 59288
 --PPM 61695 ZAA
 FUNCTION is_obligation_dp_immo(p_dirprin   IN NUMBER, p_message   OUT VARCHAR2) RETURN BOOLEAN;
 FUNCTION is_autoris_elargis(p_dirprin   IN NUMBER, p_message   OUT VARCHAR2) RETURN BOOLEAN;
 --PPM 61695 : fin
 PROCEDURE CONTROLE_DIRPRIN (p_dpcode IN VARCHAR2, p_dirprin IN NUMBER, p_result OUT VARCHAR2);
 FUNCTION liste_directions_branche (l_branche IN VARCHAR2) RETURN VARCHAR2; --QC 1659
--PPM 59288 : fin
   PROCEDURE insert_dossier_projet (p_dpcode    IN  VARCHAR2,
                                    p_dplib     IN  dossier_projet.dplib%TYPE,
                                    p_userid    IN  VARCHAR2,
                                    p_dateimmo	IN  VARCHAR2,
                                    p_actif	IN  VARCHAR2,
									p_dp1	IN  VARCHAR2,
                                    p_dp2	IN  VARCHAR2,
				    p_dptype    IN  type_dossier_projet.typdp%TYPE,
            p_dirprin   IN NUMBER, --PPM 59288
                                    p_nbcurseur OUT INTEGER,
                                    p_message   OUT VARCHAR2
                                   );

   PROCEDURE update_dossier_projet (p_dpcode    IN  VARCHAR2,
                                    p_dplib     IN  dossier_projet.dplib%TYPE,
                                    p_flaglock  IN  NUMBER,
                                    p_userid    IN  VARCHAR2,
                                    p_dateimmo	IN  VARCHAR2,
                                    p_actif	IN  VARCHAR2,
									p_dp1	IN  VARCHAR2,
                                    p_dp2	IN  VARCHAR2,
				    p_dptype    IN  type_dossier_projet.typdp%TYPE,
            p_dirprin   IN NUMBER, --PPM 59288
                                    p_nbcurseur OUT INTEGER,
                                    p_message   OUT VARCHAR2
                                   );

   PROCEDURE delete_dossier_projet (p_dpcode    IN  VARCHAR2,
                                    p_flaglock  IN  NUMBER,
                                    p_userid    IN  VARCHAR2,
                                    p_nbcurseur OUT INTEGER,
                                    p_message   OUT VARCHAR2
                                   );

   PROCEDURE select_dossier_projet (p_dpcode            IN VARCHAR2,
                                    p_userid            IN VARCHAR2,
                                    p_curdossier_projet IN OUT dossier_projetCurType,
                                    p_nbcurseur         OUT INTEGER,
                                    p_message           OUT VARCHAR2
                                   );
                                   
PROCEDURE maj_dossier_projet_logs (p_dpcode        IN DOSSIER_PROJET_LOGS.dpcode%TYPE,
                              p_user_log    IN VARCHAR2,--proj_info_logs.user_log%TYPE,
                              p_colonne        IN VARCHAR2,--proj_info_logs.colonne%TYPE,
                              p_valeur_prec    IN VARCHAR2,--proj_info_logs.valeur_prec%TYPE,
                              p_valeur_nouv    IN VARCHAR2,--proj_info_logs.valeur_nouv%TYPE,
                              p_commentaire    IN VARCHAR2--proj_info_logs.commentaire%TYPE
                              );

PROCEDURE verif_code_dp(p_dpcode IN VARCHAR2,
                        p_message   OUT VARCHAR2
                        );							  

--HMI
PROCEDURE afficher_tous_dossier_projet(p_dpcode  OUT VARCHAR2,
                                       p_dpcopi  OUT VARCHAR2,
                                       p_dpcopiaxemetier  OUT VARCHAR2,
                                       p_message  OUT VARCHAR2
                              );
PROCEDURE liste_dossier_projet(p_userid IN VARCHAR2, p_dpcode IN VARCHAR2 , p_dpcopi IN VARCHAR2 ,  p_dpcopiaxemetier IN VARCHAR2  ,  p_message  OUT VARCHAR2 ,   p_curseur IN OUT listecurtype);
                              
PROCEDURE liste_dossier_projet_copi(p_userid IN VARCHAR2, p_dpcode IN VARCHAR2,  p_dpcopi IN VARCHAR2, p_dpcopiaxemetier IN VARCHAR2 , p_message  OUT VARCHAR2,  p_curseur IN OUT listecurtype);
PROCEDURE liste_ref_demande(p_userid IN VARCHAR2, p_dpcode IN VARCHAR2 , p_dpcopi IN VARCHAR2 , p_dpcopiaxemetier IN VARCHAR2,   p_curseur IN OUT listecurtype);   
PROCEDURE  verifi_habilitation(p_userid IN varchar2,p_message OUT VARCHAR2);
FUNCTION control (l_valeur IN varchar2) return varchar2;
--FIN HMI
END pack_dossier_projet;
/


CREATE OR REPLACE PACKAGE BODY     pack_dossier_projet AS


-- *********************************************************************************
--       Procedure   AJOUT  DOSSIER PROJET
-- *********************************************************************************

   PROCEDURE insert_dossier_projet (p_dpcode    IN  VARCHAR2,
                                    p_dplib     IN  dossier_projet.dplib%TYPE,
                                    p_userid    IN  VARCHAR2,
                                    p_dateimmo	IN  VARCHAR2,
                                    p_actif	IN  VARCHAR2,
                                    p_dp1	IN  VARCHAR2,
                                    p_dp2	IN  VARCHAR2,
				    p_dptype    IN  type_dossier_projet.typdp%TYPE,
            p_dirprin   IN NUMBER, --PPM 59288
                                    p_nbcurseur OUT INTEGER,
                                    p_message   OUT VARCHAR2
                                   ) IS

      l_new_dateimmo DATE;
      l_datdebex DATE;
      l_msg VARCHAR2(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);
      l_user VARCHAR2(7);

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      -- Si la date de saisie est différente de la précédente valeur
      -- et qu'elle est inférieure à l'année en cours, on renvoie une erreur
      SELECT datdebex INTO l_datdebex
      FROM datdebex
      WHERE ROWNUM<2;

      l_new_dateimmo := TO_DATE(p_dateimmo, 'FMDD/MM/YYYY');

      IF (TO_NUMBER(TO_CHAR(l_new_dateimmo,'YYYY')) < TO_NUMBER(TO_CHAR(l_datdebex, 'YYYY'))) THEN
      	    pack_global.recuperer_message( 20927, NULL, NULL, NULL, l_msg);
      	    raise_application_error( -20927, l_msg );
      END IF;

      BEGIN
        INSERT INTO dossier_projet
             (
              dpcode,
              dplib,
              datimmo,
              actif,
	      typdp, dp1,dp2,
        dirprin --PPM 59288
             )
             VALUES
             (
              p_dpcode,
              p_dplib,
              TO_DATE(p_dateimmo, 'FMDD/MM/YYYY'),
              p_actif,
	      p_dptype,
		  p_dp1,
		  p_dp2,
      p_dirprin --PPM 59288
		 );
   
        l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
        maj_dossier_projet_logs (p_dpcode, l_user, 'DATIMMO','',p_dateimmo,'Creation date immo');
        maj_dossier_projet_logs (p_dpcode, l_user, 'ACTIF','',p_actif,'Creation top actif');
        maj_dossier_projet_logs (p_dpcode, l_user, 'DirPrin','',p_dirprin,'Creation DirPrin');--PPM 59288
        -- p_message := 'Code dossier ' || p_dpcode || ' et libellé enregistrés.';

        pack_global.recuperer_message( 2028, '%s1', p_dpcode, NULL, l_msg);
        p_message := l_msg;

      EXCEPTION
         WHEN referential_integrity THEN
            pack_global.recuperation_integrite(-2291);
         WHEN DUP_VAL_ON_INDEX THEN
            pack_global.recuperer_message( 20212, NULL, NULL, NULL, l_msg);
            raise_application_error( -20212, l_msg );
         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;
   END insert_dossier_projet;


-- *********************************************************************************
--       Procedure   MISE A JOUR  DOSSIER PROJET
-- *********************************************************************************

   PROCEDURE update_dossier_projet (p_dpcode    IN  VARCHAR2,
                                    p_dplib     IN  dossier_projet.dplib%TYPE,
                                    p_flaglock  IN  NUMBER,
                                    p_userid    IN  VARCHAR2,
                                    p_dateimmo	IN  VARCHAR2,
                                    p_actif	IN  VARCHAR2,
									p_dp1	IN  VARCHAR2,
                                    p_dp2	IN  VARCHAR2,
				    p_dptype    IN  type_dossier_projet.typdp%TYPE,
            p_dirprin   IN NUMBER, --PPM 59288
                                    p_nbcurseur OUT INTEGER,
                                    p_message   OUT VARCHAR2
                                   ) IS

     l_msg VARCHAR2(1024);
     l_new_dateimmo DATE;
     l_old_dateimmo DATE;
     l_datdebex DATE;
     referential_integrity EXCEPTION;
     PRAGMA EXCEPTION_INIT(referential_integrity, -2291);
    l_top_actif_old CHAR;
     l_user VARCHAR2(7);

     l_old_dirprin  NUMBER; --PPM 59288

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';

      -- Si la date de saisie est différente de la précédente valeur
      -- et qu'elle est inférieure à l'année en cours, on renvoie une erreur
      SELECT datdebex INTO l_datdebex
      FROM datdebex
      WHERE ROWNUM<2;

      l_new_dateimmo := TO_DATE(p_dateimmo, 'FMDD/MM/YYYY');
      SELECT datimmo INTO l_old_dateimmo
      FROM dossier_projet
      WHERE dpcode = p_dpcode;


      IF (l_new_dateimmo IS NOT NULL) AND (TO_CHAR(l_new_dateimmo, 'FMDD/MM/YYYY') <> TO_CHAR(NVL(l_old_dateimmo, TO_DATE('01/01/1900', 'FMDD/MM/YYYY')), 'FMDD/MM/YYYY')) THEN
      	  IF (TO_NUMBER(TO_CHAR(l_new_dateimmo,'YYYY')) < TO_NUMBER(TO_CHAR(l_datdebex, 'YYYY'))) THEN
      	    pack_global.recuperer_message( 20927, NULL, NULL, NULL, l_msg);
      	    raise_application_error( -20927, l_msg );
      	  END IF;
      END IF;

       BEGIN
            select  actif
            into l_top_actif_old
            from dossier_projet
            where dpcode = p_dpcode;
        END;

        --PPM 59288 début
        BEGIN
            select  dirprin
            into l_old_dirprin
            from dossier_projet
            where dpcode = p_dpcode;
        END;
      --PPM 59288 Fin 
      BEGIN
         UPDATE dossier_projet SET dpcode = p_dpcode,
                                   dplib  = p_dplib,
                                   datimmo = l_new_dateimmo,
                                   actif = p_actif,
				   typdp = p_dptype,
				   dp1=p_dp1,
				   dp2=p_dp2,
                                   flaglock = decode( p_flaglock, 1000000, 0, p_flaglock + 1),
                                   dirprin = p_dirprin --PPM 59288
         WHERE dpcode = p_dpcode;
        l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
        maj_dossier_projet_logs (p_dpcode, l_user, 'DATIMMO',l_old_dateimmo,l_new_dateimmo,'Modification date immo');
        maj_dossier_projet_logs (p_dpcode, l_user, 'ACTIF',l_top_actif_old,p_actif,'Modification top actif');
        --Début FAD PPM 63740 : Trace de la MAJ du DIrPrin dans le cas ou l'ancienne valeur de cet attribut est nul
        --IF l_old_dirprin <> p_dirprin THEN
        IF (l_old_dirprin <> p_dirprin) OR (l_old_dirprin IS NULL AND p_dirprin IS NOT NULL) THEN
        --Fin FAD PPM 63740
          maj_dossier_projet_logs (p_dpcode, l_user, 'DirPrin',l_old_dirprin,p_dirprin,'Modification DirPrin');--PPM 59288
        END IF;
      EXCEPTION
         WHEN referential_integrity THEN
            pack_global.recuperation_integrite(-2291);

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE
         pack_global.recuperer_message( 2029, '%s1', p_dpcode, NULL, l_msg);
         p_message := l_msg;
      END IF;

   END update_dossier_projet;


-- *********************************************************************************
--       Procedure   SUPPRESSION  DOSSIER PROJET
-- *********************************************************************************

   PROCEDURE delete_dossier_projet (p_dpcode    IN  VARCHAR2,
                                    p_flaglock  IN  NUMBER,
                                    p_userid    IN  VARCHAR2,
                                    p_nbcurseur OUT INTEGER,
                                    p_message   OUT VARCHAR2
                                   ) IS

      l_msg VARCHAR2(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
      l_user VARCHAR2(7);
     l_dateimmo_old VARCHAR2(10);
     l_actif_old CHAR;
     -- YNI FDT 900
     l_count NUMBER;


   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';
      -- YNI FDT 900
      l_count := 0;

         -- YNI FDT 900: Test de la liaison avec la table PROJ_INFO
         BEGIN
            select count(*)
            into l_count
            from proj_info
            where icodproj = p_dpcode;

         END; 
         
         IF l_count <> 0 THEN
              pack_global.recuperer_message( 21170, NULL, NULL, NULL, l_msg);
              raise_application_error( -20999, l_msg );
         ELSE
                       
              BEGIN
                select datimmo, actif
                into l_dateimmo_old, l_actif_old
                from dossier_projet
                where dpcode = p_dpcode;
    
              END;
        
              BEGIN
                 DELETE FROM dossier_projet
                        WHERE dpcode = p_dpcode
                        AND flaglock = p_flaglock;
        
                  l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
                  maj_dossier_projet_logs (p_dpcode, l_user, 'DATIMMO',l_dateimmo_old,'','Suppression date immo');
                  maj_dossier_projet_logs (p_dpcode, l_user, 'ACTIF',l_actif_old,'','Suppression top actif');
        
              EXCEPTION
                 WHEN referential_integrity THEN
                    pack_global.recuperation_integrite(-2292);
                 WHEN OTHERS THEN
                    raise_application_error (-20997, SQLERRM);
        
              END;
        
              IF SQL%NOTFOUND THEN
                 pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
                 raise_application_error( -20999, l_msg );
              ELSE
                 pack_global.recuperer_message( 2030, '%s1', p_dpcode, NULL, l_msg);
                 p_message := l_msg;
              END IF;
              
      END IF; 
   END delete_dossier_projet;


-- *********************************************************************************
--       Procedure   SELECTION  DOSSIER PROJET
-- *********************************************************************************

   PROCEDURE select_dossier_projet (p_dpcode            IN VARCHAR2,
                                    p_userid            IN VARCHAR2,
                                    p_curdossier_projet IN OUT dossier_projetCurType,
                                    p_nbcurseur         OUT INTEGER,
                                    p_message           OUT VARCHAR2
                                   ) IS

      l_msg VARCHAR2(1024);

   BEGIN
      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur := 1;
      p_message := '';
      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN p_curdossier_projet FOR
              SELECT *
              FROM DOSSIER_PROJET
              WHERE dpcode = p_dpcode;

      EXCEPTION
         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;
      -- en cas absence
      -- p_message := 'Le centre d'activité n'existe pas';
      pack_global.recuperer_message( 2031, '%s1', p_dpcode, NULL, l_msg);
      p_message := l_msg;

   END select_dossier_projet;
   
--Procédure pour remplir les logs de MAJ du  dossier projet
PROCEDURE maj_dossier_projet_logs (p_dpcode        IN DOSSIER_PROJET_LOGS.dpcode%TYPE,
                              p_user_log    IN VARCHAR2,
                              p_colonne        IN VARCHAR2,
                              p_valeur_prec    IN VARCHAR2,
                              p_valeur_nouv    IN VARCHAR2,
                              p_commentaire    IN VARCHAR2
                              ) IS
BEGIN

    IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
        INSERT INTO DOSSIER_PROJET_LOGS
            (dpcode, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
        VALUES
            (p_dpcode, SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);

    END IF;
    -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

END maj_dossier_projet_logs; 

PROCEDURE verif_code_dp(p_dpcode IN VARCHAR2,
                        p_message   OUT VARCHAR2) IS
                        
code_dp dossier_projet.dpcode%type;
l_msg      VARCHAR2 (1024);
BEGIN
 BEGIN
     	-- Vérif DP existe
   	SELECT dpcode INTO code_dp
   	FROM dossier_projet
   	WHERE dpcode = TO_NUMBER(p_dpcode);
     EXCEPTION
     	WHEN NO_DATA_FOUND THEN
   	  -- DPCODE inconnu!
     	  pack_global.recuperer_message(21250, NULL, NULL, NULL, l_msg);
        p_message := l_msg;
     END;
          
END verif_code_dp;


--*******************************************************************************
-- PPM 59288 - retourne le dirprin de la direction qui a l'obligation du DBS et provenant du paramètre OBLIGATION-DBS/DEFAUT/<rr>.
--*******************************************************************************

PROCEDURE dir_prin_dp(p_dpcode IN VARCHAR2, p_valeur OUT VARCHAR2, p_message   OUT VARCHAR2) IS

BEGIN
  p_valeur:=null;
  BEGIN
      select dirprin into p_valeur 
      from dossier_projet
      where dpcode = TO_NUMBER(p_dpcode);
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
      p_valeur :=null;
    END;

END dir_prin_dp;




--*******************************************************************************************
--PPM 59288 : recupère la liste des Directions liées au contenu du paramètre OBLIGATION-DBS
--*******************************************************************************************
PROCEDURE liste_dir_dbs (p_valeur OUT VARCHAR2, p_message   OUT VARCHAR2) IS
      --PPM 59288 : déclaration des variables      
      l_chaine_dbs VARCHAR2(400);
      t_table PACK_LIGNE_BIP.t_array;
      l_dirprin VARCHAR2(2);
      l_branche VARCHAR2(2);
      l_valeur VARCHAR2(500);
      separateur VARCHAR2(1);

      BEGIN
      p_valeur:='';
      l_dirprin:='';
      l_branche:='';
      l_valeur:='';
      --PPM 59288 : on recupère la liste des Directions liées au contenu du paramètre OBLIGATION-DBS
   PACK_LIGNE_BIP.RECUPERER_PARAM_APP('OBLIGATION-DBS','DEFAUT',1,l_chaine_dbs,p_message);
   PACK_LIGNE_BIP.RECUPERER_SEPAR_PARAM_APP('OBLIGATION-DBS','DEFAUT',1,separateur,p_message);

        --t_table := PACK_LIGNE_BIP.SPLIT(l_chaine_dbs,',');
        t_table := PACK_LIGNE_BIP.SPLIT(l_chaine_dbs, separateur);
        FOR i IN 2 .. t_table.count --ZAA - PPM 61695
        LOOP

          l_dirprin := SUBSTR(t_table(i),3,2);
          -- PPM 59288 - QC 1659
          IF l_dirprin = '00' THEN
              l_branche := SUBSTR(t_table(I),1,2);
              l_valeur:=''; --initialisation
              
              -- fonction pour récupérer toutes les directions d'une branche séparées par des virgules
              l_valeur := liste_directions_branche(l_branche);
              --si on est au début de la liste
              IF NVL(p_valeur,'^') = '^' THEN            
                  p_valeur:=l_valeur;   
              ELSE
                  p_valeur:=p_valeur || ',' || l_valeur; 



              END IF;
          ELSE            
              --si on est au début de la liste
              IF NVL(p_valeur,'^') = '^' THEN            
                  p_valeur:=l_dirprin;   
              ELSE



                  p_valeur:=p_valeur || ',' || l_dirprin; 
              END IF;
              
          END IF;
        END LOOP;
END liste_dir_dbs;



PROCEDURE liste_dir_dp_immo(p_valeur OUT VARCHAR2, p_message   OUT VARCHAR2) IS
      --PPM 61695 : déclaration des variables
      l_chaine_dp_immo VARCHAR2(400);
      t_table PACK_LIGNE_BIP.t_array;
      l_dirprin VARCHAR2(2);
      l_branche VARCHAR2(2);
      l_valeur VARCHAR2(500);
      separateur VARCHAR2(1);

      BEGIN
      p_valeur:='';
      l_dirprin:='';
      l_branche:='';
      l_valeur:='';
      separateur := '';
      --PPM 61695 : on recupère la liste des Directions liées au contenu du paramètre OBLIGATION-DP-IMMO
      PACK_LIGNE_BIP.RECUPERER_PARAM_APP('OBLIGATION-DP-IMMO','DEFAUT',1,l_chaine_dp_immo,p_message);
      PACK_LIGNE_BIP.RECUPERER_SEPAR_PARAM_APP('OBLIGATION-DP-IMMO','DEFAUT',1,separateur,p_message);
        --t_table := PACK_LIGNE_BIP.SPLIT(l_chaine_dp_immo,',');
        t_table := PACK_LIGNE_BIP.SPLIT(l_chaine_dp_immo, separateur);
        FOR I IN 1..t_table.COUNT LOOP

          l_dirprin := SUBSTR(t_table(I),3,2);
          
          IF l_dirprin = '00' THEN
              l_branche := SUBSTR(t_table(I),1,2);
              l_valeur:=''; --initialisation

              -- fonction pour récupérer toutes les directions d'une branche séparées par des virgules
              l_valeur := liste_directions_branche(l_branche);
              --si on est au début de la liste
              IF NVL(p_valeur,'^') = '^' THEN
                  p_valeur:=l_valeur;
              ELSE
                  p_valeur:=p_valeur || ',' || l_valeur;



              END IF;
          ELSE
              --si on est au début de la liste
              IF NVL(p_valeur,'^') = '^' THEN
                  p_valeur:=l_dirprin;
              ELSE



                  p_valeur:=p_valeur || ',' || l_dirprin;
              END IF;

          END IF;
        END LOOP;
END liste_dir_dp_immo;

-- PPM 59288 - QC 1659 : fonction pour récupérer toutes les directions d'une branche séparées par des virgules
FUNCTION liste_directions_branche (l_branche IN VARCHAR2) RETURN VARCHAR2 IS
    l_valeur VARCHAR2(500);
    
    CURSOR c_tmp_coddir IS
                    select coddir from directions where codbr=to_number(l_branche) order by coddir;
    BEGIN
    l_valeur:='';
              for rec_tmp_coddir in c_tmp_coddir loop              
              --si on est au début de la liste
              IF NVL(l_valeur,'^') = '^' THEN            
                  l_valeur:=rec_tmp_coddir.coddir;   
              ELSE
                  l_valeur:=l_valeur || ',' || rec_tmp_coddir.coddir; 
              END IF;
              end loop;
RETURN l_valeur;
END;
--*******************************************************************************
-- PPM 59288 - Fonction de vérification si une direction est liée au paramètre OBLIGATION-DBS (return TRUE), sinon (return FALSE).
--*******************************************************************************
FUNCTION is_obligation_dbs ( p_dirprin   IN NUMBER,
                            p_message   OUT VARCHAR2) RETURN BOOLEAN IS
      --PPM 59288 : déclaration des variables
      l_chaine_dbs VARCHAR2(400);
      l_direction VARCHAR2(10);
      t_table PACK_LIGNE_BIP.t_array;
      l_nbre NUMBER;
      l_branche VARCHAR2(10);
      separateur VARCHAR2(1);
      BEGIN


       -- Initialisation
    l_direction := '';
    l_branche := '';
    l_nbre := 0;
    separateur := '';
   --PPM 59288 : vérification si une direction est liée au contenu du paramètre OBLIGATION-DBS
   PACK_LIGNE_BIP.RECUPERER_PARAM_APP('OBLIGATION-DBS','DEFAUT',1,l_chaine_dbs,p_message);
   PACK_LIGNE_BIP.RECUPERER_SEPAR_PARAM_APP('OBLIGATION-DBS','DEFAUT',1,separateur,p_message);

            --t_table := PACK_LIGNE_BIP.SPLIT(l_chaine_dbs,',');
            t_table := PACK_LIGNE_BIP.SPLIT(l_chaine_dbs,separateur);
            FOR I IN 2..t_table.COUNT LOOP --ZAA - PPM 61695
              l_direction := SUBSTR(t_table(I),3,2);
              --PPM 59288 - QC 1659
              IF l_direction = '00' THEN
                  l_branche := SUBSTR(t_table(I),1,2);
                  l_nbre:=0; --initialisation 
                  select count(*) into l_nbre from directions where codbr=to_number(l_branche) and coddir = p_dirprin;                   
                  IF l_nbre > 0 THEN
                  RETURN TRUE; -- le dirprin existe dans le paramètre DBS
                  END IF;           
              END IF;
              IF l_direction <> '00' AND l_direction = TO_CHAR(p_dirprin, 'FM00') THEN
                    RETURN TRUE; -- le dirprin existe dans le paramètre DBS
              END IF;


            END LOOP;
   RETURN FALSE;
END;

--*******************************************************************************
-- PPM 61695 - Fonction de vérification si une direction est liée au paramètre OBLIGATION-DP-IMMO (return TRUE), sinon (return FALSE).
--*******************************************************************************
FUNCTION is_obligation_dp_immo ( p_dirprin   IN NUMBER,
                            p_message   OUT VARCHAR2) RETURN BOOLEAN IS
      --PPM 61695 : déclaration des variables
      l_chaine_dp VARCHAR2(400);
      l_direction VARCHAR2(10);
      t_table PACK_LIGNE_BIP.t_array;
      l_nbre NUMBER;
      l_branche VARCHAR2(10);
      separateur VARCHAR2(1);
      BEGIN


       -- Initialisation
    l_direction := '';
    l_branche := '';
    l_nbre := 0;
    separateur := '';
    --PPM 61695 : vérification si une direction est liée au contenu du paramètre OBLIGATION-DP-IMMO
    PACK_LIGNE_BIP.RECUPERER_PARAM_APP('OBLIGATION-DP-IMMO','DEFAUT',1,l_chaine_dp,p_message);
    PACK_LIGNE_BIP.RECUPERER_SEPAR_PARAM_APP('OBLIGATION-DP-IMMO','DEFAUT',1,separateur,p_message);

            --t_table := PACK_LIGNE_BIP.SPLIT(l_chaine_dp,',');
            t_table := PACK_LIGNE_BIP.SPLIT(l_chaine_dp, separateur);
            FOR I IN 1..t_table.COUNT LOOP
              l_direction := SUBSTR(t_table(I),3,2);
              
              IF l_direction = '00' THEN
                  l_branche := SUBSTR(t_table(I),1,2);
                  l_nbre:=0; --initialisation
                  select count(*) into l_nbre from directions where codbr=to_number(l_branche) and coddir = p_dirprin;
                  IF l_nbre > 0 THEN
                  RETURN TRUE; -- le dirprin existe dans le paramètre DP-IMMO
                  END IF;
              END IF;
              IF l_direction <> '00' AND l_direction = TO_CHAR(p_dirprin, 'FM00') THEN
                    RETURN TRUE; -- le dirprin existe dans le paramètre DP-IMMO
              END IF;


            END LOOP;
   RETURN FALSE;
END;
--*******************************************************************************
-- PPM 61695 - Fonction de controle de cohérence d'une direction principale à un dossier projet
--*******************************************************************************
 FUNCTION is_autoris_elargis(p_dirprin   IN NUMBER, p_message   OUT VARCHAR2) RETURN BOOLEAN
 IS
 l_chaine_dp VARCHAR2(400);
 t_table PACK_LIGNE_BIP.t_array;
 separateur VARCHAR2(1);
  
 Begin
 
   separateur := '';
   PACK_LIGNE_BIP.RECUPERER_PARAM_APP('OBLIGATION-DP-IMMO','DEFAUT',1,l_chaine_dp,p_message);
   PACK_LIGNE_BIP.RECUPERER_SEPAR_PARAM_APP('OBLIGATION-DP-IMMO','DEFAUT',1,separateur,p_message);
   --t_table := PACK_LIGNE_BIP.SPLIT(l_chaine_dp,',');
   t_table := PACK_LIGNE_BIP.SPLIT(l_chaine_dp, separateur);
    
   IF p_dirprin IS NULL OR NOT is_obligation_dp_immo(p_dirprin,p_message) OR t_table IS NULL THEN 

     RETURN TRUE; 
   
   ELSE IF p_dirprin IS NOT NULL AND is_obligation_dp_immo(p_dirprin,p_message) then
   
        RETURN FALSE;
   
        END IF;
   
   END IF;
 
 END;
--*******************************************************************************
-- PPM 59288 - Fonction de controle de cohérence d'une direction principale à un dossier projet
--*******************************************************************************
PROCEDURE CONTROLE_DIRPRIN ( p_dpcode IN VARCHAR2, 
                             p_dirprin IN NUMBER, 
                             p_result OUT VARCHAR2) IS
      l_nb_ligne NUMBER;--PPM 59288
      l_msg VARCHAR2(50);

      BEGIN
      -- Initialisations
      l_msg := '';
     -- PPM 61695 l_nb_ligne :=0;
      p_result := 0;
      -- PPM 61695 recupère au moins une ligne Bip active et non GT1 qui correspond à un dossier projet
      select count(*) into l_nb_ligne
      from ligne_bip
      where dpcode = p_dpcode
      and (arctype != 'T1' OR typproj != '1') -- lignes non GT1
      and adatestatut is null -- lignes actives
      and rownum <2;

      -- PPM 61695 IF l_nb_ligne > 0 AND  is_obligation_dbs(p_dirprin, l_msg) THEN
      IF l_nb_ligne > 0 AND not is_autoris_elargis(p_dirprin, l_msg) THEN
          p_result := '1';
      END IF;                     

END CONTROLE_DIRPRIN;

--HMI PPM 62325 $4.3
PROCEDURE afficher_tous_dossier_projet(p_dpcode  OUT VARCHAR2,
                                      p_dpcopi  OUT VARCHAR2,
                                      p_dpcopiaxemetier  OUT VARCHAR2,
                                     p_message  OUT VARCHAR2
                              ) IS
BEGIN

             BEGIN
             
             p_dpcode := 'TOUS';
             p_dpcopi := 'TOUS';
             p_dpcopiaxemetier := 'TOUS';
              pack_global.recuperer_message (21303, NULL, NULL, NULL, p_message);

               
    exception when
    others then
        p_message := sqlerrm;
        
        
     end;

END afficher_tous_dossier_projet;

PROCEDURE liste_dossier_projet(p_userid IN VARCHAR2, p_dpcode IN VARCHAR2 , p_dpcopi IN VARCHAR2 , p_dpcopiaxemetier IN VARCHAR2  ,  p_message  OUT VARCHAR2 ,  p_curseur IN OUT listecurtype)
    IS
    parametrage_controle EXCEPTION;
    l_doss_proj VARCHAR2(5000);
      BEGIN
       l_doss_proj := '';
       p_message := '';
            
         l_doss_proj := pack_global.lire_doss_proj(p_userid);
            
             
         /* select DOSS_PROJ into l_doss_proj  from rtfe where USER_RTFE = p_userid 
           and MENUS like '%ref%';*/
           
           
          IF l_doss_proj IS NULL or control(l_doss_proj) like 'invalide' THEN
          pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
                                        
           RAISE parametrage_controle;
           pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
          
    ELSE
    p_message := '';
         /*   IF  p_dpcode <> 'TOUS' THEN            
                OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT TO_CHAR(dpcode) code, TO_CHAR(dpcode)|| ' - ' || dplib libelle, DPCODE
                            FROM DOSSIER_PROJET
                       where dpcode = p_dpcode
                          UNION
                          SELECT 'TOUS' code, 'TOUS' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE;
               
            ELSE */
       IF  (UPPER(l_doss_proj) = 'TOUS') THEN    
        
      
            
          /* IF p_dpcode = 'Tous'  THEN
            
             DBMS_OUTPUT.PUT_LINE('*******3*****');
              OPEN p_curseur FOR
               
                SELECT   code, libelle
                    FROM (SELECT TO_CHAR(dpcode) code, TO_CHAR(dpcode,'FM00000')|| ' - ' || dplib libelle, DPCODE
                            FROM DOSSIER_PROJET
                                                   
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE;   
                
                ELSE*/
                
             IF p_dpcopi <> 'Tous'  THEN 
            
                OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT TO_CHAR(DOSSIER_PROJET.dpcode) code, TO_CHAR(DOSSIER_PROJET.dpcode,'FM00000')|| ' - ' || DOSSIER_PROJET.dplib libelle, DOSSIER_PROJET.DPCODE
                            FROM DOSSIER_PROJET, DOSSIER_PROJET_COPI
                       WHERE DOSSIER_PROJET.DPCODE = DOSSIER_PROJET_COPI.DPCODE
                       and DOSSIER_PROJET_COPI.DP_COPI = p_dpcopi
                    
                          UNION
                          SELECT 'Tous' code, 'Tous' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE; 
              ELSE 
              
               IF  p_dpcode <> 'Tous' THEN            
                OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT TO_CHAR(DOSSIER_PROJET.dpcode) code, TO_CHAR(DOSSIER_PROJET.dpcode,'FM00000')|| ' - ' || DOSSIER_PROJET.dplib libelle, DOSSIER_PROJET.DPCODE
                            FROM DOSSIER_PROJET
                       where dpcode = p_dpcode
                          UNION
                          SELECT 'Tous' code, 'Tous' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE;
          
            ELSE 
          
          IF p_dpcopiaxemetier  <> 'Tous'   THEN 
          
                  OPEN p_curseur FOR
               
                SELECT   code, libelle
                    FROM (SELECT TO_CHAR(DOSSIER_PROJET.DPCODE) code, TO_CHAR(DOSSIER_PROJET.DPCODE,'FM00000')|| ' - ' || DOSSIER_PROJET.DPLIB libelle, DOSSIER_PROJET.DPCODE
                            FROM DOSSIER_PROJET, DOSSIER_PROJET_COPI
                            WHERE DOSSIER_PROJET.DPCODE = DOSSIER_PROJET_COPI.DPCODE
                            AND DOSSIER_PROJET_COPI.DPCOPIAXEMETIER = p_dpcopiaxemetier
                        
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE;       
      
      
      ELSE
          
         IF  p_dpcode is null or p_dpcopi is null or p_dpcopiaxemetier is null or  p_dpcode = 'Tous' or p_dpcopi = 'Tous' or p_dpcopiaxemetier = 'Tous'  THEN  
               OPEN p_curseur FOR
               
                SELECT   code, libelle
                    FROM (SELECT TO_CHAR(dpcode) code, TO_CHAR(dpcode,'FM00000')|| ' - ' || dplib libelle, DPCODE
                            FROM DOSSIER_PROJET
                                                   
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE;        
               
          END If;
          END IF;     
          END IF;
          END IF;
    
    --here 
    
  ELSE 
        
        /*IF  p_dpcode <> 'TOUS' THEN     
        DBMS_OUTPUT.PUT_LINE('*******66*****');
                OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT TO_CHAR(DOSSIER_PROJET.dpcode) code, TO_CHAR(DOSSIER_PROJET.dpcode,'FM00000')|| ' - ' || DOSSIER_PROJET.dplib libelle, DOSSIER_PROJET.DPCODE
                            FROM DOSSIER_PROJET
                       where dpcode = p_dpcode
                        AND INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET.dpcode, 'FM00000')) > 0
                          UNION
                          SELECT 'TOUS' code, 'TOUS' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE;
         ELSE */
         
          
         /*  IF p_dpcode = 'Tous'  THEN
            
             DBMS_OUTPUT.PUT_LINE('*******3*****');
               OPEN p_curseur FOR
               
                SELECT   code, libelle
                    FROM (SELECT TO_CHAR(dpcode) code, TO_CHAR(dpcode,'FM00000')|| ' - ' || dplib libelle, DPCODE
                            FROM DOSSIER_PROJET
                           where  
                           --INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET.dpcode)) > 0
                             --INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET.dpcode)) > 0
                             INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET.dpcode, 'FM00000')) > 0
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE;   
                
                ELSE*/
                
                
           IF p_dpcopi <> 'Tous'  THEN 
            
                OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT TO_CHAR(DOSSIER_PROJET.dpcode) code, TO_CHAR(DOSSIER_PROJET.dpcode,'FM00000')|| ' - ' || DOSSIER_PROJET.dplib libelle, DOSSIER_PROJET.DPCODE
                            FROM DOSSIER_PROJET, DOSSIER_PROJET_COPI
                       WHERE DOSSIER_PROJET.DPCODE = DOSSIER_PROJET_COPI.DPCODE
                       and DOSSIER_PROJET_COPI.DP_COPI = p_dpcopi
                    
                         AND INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET.dpcode, 'FM00000')) > 0
                          UNION
                          SELECT 'Tous' code, 'Tous' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE; 
               
               ELSE 
                IF  p_dpcode <> 'Tous' THEN            
                OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT TO_CHAR(DOSSIER_PROJET.dpcode) code, TO_CHAR(DOSSIER_PROJET.dpcode,'FM00000')|| ' - ' || DOSSIER_PROJET.dplib libelle, DOSSIER_PROJET.DPCODE
                            FROM DOSSIER_PROJET
                       where dpcode = p_dpcode
                          UNION
                          SELECT 'Tous' code, 'Tous' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE;
          
            ELSE 
          
          IF p_dpcopiaxemetier  <> 'Tous'  THEN 
          
                  OPEN p_curseur FOR
               
                SELECT   code, libelle
                    FROM (SELECT TO_CHAR(DOSSIER_PROJET.DPCODE) code, TO_CHAR(DOSSIER_PROJET.DPCODE,'FM00000')|| ' - ' || DOSSIER_PROJET.DPLIB libelle, DOSSIER_PROJET.DPCODE
                            FROM DOSSIER_PROJET, DOSSIER_PROJET_COPI
                            WHERE DOSSIER_PROJET.DPCODE = DOSSIER_PROJET_COPI.DPCODE
                            AND DOSSIER_PROJET_COPI.DPCOPIAXEMETIER = p_dpcopiaxemetier
                         --   AND INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET.dpcode)) > 0	
                              --AND   INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET.dpcode)) > 0
                               AND INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET.dpcode, 'FM00000')) > 0
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE;       
      ELSE 
      IF  p_dpcode is null or p_dpcopi is null or p_dpcopiaxemetier is null or  p_dpcode = 'Tous' or p_dpcopi = 'Tous' or p_dpcopiaxemetier = 'Tous'  THEN
              --IF  p_dpcode is null  or  p_dpcode = 'Tous'  THEN
            
             
               OPEN p_curseur FOR
               
                SELECT   code, libelle
                    FROM (SELECT TO_CHAR(dpcode) code, TO_CHAR(dpcode,'FM00000')|| ' - ' || dplib libelle, DPCODE
                            FROM DOSSIER_PROJET
                           where  
                           --INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET.dpcode)) > 0
                             --INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET.dpcode)) > 0
                             INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET.dpcode, 'FM00000')) > 0
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE; 
          
         
                     
               
          END If;
          END IF;     
          END IF;       
          END IF;
          END IF;
     
    END IF;
     EXCEPTION 
             WHEN parametrage_controle THEN
              pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);  
              
             WHEN NO_DATA_FOUND THEN 
             pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);

   END liste_dossier_projet;


PROCEDURE liste_dossier_projet_copi(p_userid IN VARCHAR2, p_dpcode IN VARCHAR2,  p_dpcopi IN VARCHAR2, p_dpcopiaxemetier IN VARCHAR2 ,  p_message  OUT VARCHAR2 , p_curseur IN OUT listecurtype)
    IS
    l_dp_copi varchar2(1000);
    parametrage_controle EXCEPTION; 
    l_number Number(10);
     l_doss_proj VARCHAR2(5000);
      BEGIN
    
     l_doss_proj := '';
     p_message := '';
     
    
             l_doss_proj := pack_global.lire_doss_proj(p_userid);
              
             IF l_doss_proj IS NULL or control(l_doss_proj) like 'invalide' THEN
              pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
              
              RAISE parametrage_controle;
               pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
            
      ELSE 
      
       IF   (UPPER(l_doss_proj) = 'TOUS') THEN    
       IF  p_dpcode <> 'Tous' THEN  
          
                 BEGIN 
                    select dp_copi into l_dp_copi  from dossier_projet_copi 
                    --where to_char(dpcode) = p_dpcode 
                    where dpcode = TO_NUMBER(p_dpcode, '99999')
                    --where  INSTR(p_dpcode, TO_CHAR(dossier_projet_copi.dpcode, 'FM00000')) > 0
                    and rownum = 1;
                    
                 EXCEPTION
                  
                         WHEN NO_DATA_FOUND THEN 
                           
                         pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
                END;
       
          IF l_dp_copi is null THEN 
            
            RAISE parametrage_controle;
           pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
             
          ELSE 
          
          --HMI PPM 62325 QC 1854 (Order by tri par dpcopi )
              OPEN p_curseur FOR
                SELECT   code, libelle
                    FROM (SELECT dp_copi code, dp_copi || ' - ' || libelle libelle, dp_copi
                            FROM DOSSIER_PROJET_COPI
                           where DPCODE = p_dpcode
                           -- where  INSTR(p_dpcode, TO_CHAR(dossier_projet_copi.dpcode, 'FM00000')) > 0
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, '_' dp_copi
                            FROM DUAL)
                ORDER BY dp_copi;   
                --FIN HMI PPM 62325 QC 1854
            END IF;
            
        ELSE
         
             IF p_dpcopi <> 'Tous'   THEN 
                  
               OPEN p_curseur FOR
                SELECT   code, libelle
                    FROM (SELECT dp_copi code, dp_copi || ' - ' || libelle libelle, dp_copi
                            FROM DOSSIER_PROJET_COPI
                              where dp_copi = p_dpcopi
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, '_' dp_copi
                            FROM DUAL)
                ORDER BY dp_copi;   
                
            ELSE 
             IF p_dpcopiaxemetier <> 'Tous'  THEN 
             
                
             OPEN p_curseur FOR
                SELECT   code, libelle
                    FROM (SELECT dp_copi code, dp_copi || ' - ' || libelle libelle, dp_copi
                            FROM DOSSIER_PROJET_COPI
                              where DPCOPIAXEMETIER = p_dpcopiaxemetier
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, '_' dp_copi
                            FROM DUAL)
                ORDER BY dp_copi;  
                
                
                 ELSE 
           
          
        
       -- IF p_dpcode = 'Tous' or p_dpcopi = 'Tous' or p_dpcode is null or p_dpcopi is null or p_dpcopiaxemetier is null  THEN
          IF  p_dpcode is null or p_dpcopi is null or p_dpcopiaxemetier is null or p_dpcode = 'Tous' or  p_dpcopi = 'Tous' or   p_dpcopiaxemetier = 'Tous'  THEN
       
             OPEN p_curseur FOR
                SELECT   code, libelle
                    FROM (SELECT dp_copi code, dp_copi || ' - ' || libelle libelle, dp_copi
                            FROM DOSSIER_PROJET_COPI
                          UNION
                          SELECT 'Tous' code, 'Tous' libelle, '_' dp_copi
                            FROM DUAL)
                ORDER BY dp_copi; 
                     
                
          END If;
        
          END IF;
          END IF;       
          END IF;
         
          
           
      --here
            
      ELSE 
    
      BEGIN      
           SELECT count(*) into l_number FROM DOSSIER_PROJET_COPI
           where  INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET_COPI.DPCODE, 'FM00000')) > 0;
         
            EXCEPTION 
             WHEN NO_DATA_FOUND THEN 
            pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);     
        END ;  
       
          IF l_number = 0  then 
        
          pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
                      
    ELSE
                
          
            
           IF  p_dpcode <> 'Tous' THEN  
             
                 BEGIN 
                    select dp_copi into l_dp_copi  from dossier_projet_copi 
                    --where to_char(dpcode) = p_dpcode 
                    where dpcode = TO_NUMBER(p_dpcode, '99999')
                    -- where  INSTR(p_dpcode, TO_CHAR(dossier_projet_copi.dpcode, 'FM00000')) > 0
                    and rownum = 1;
                   
                 EXCEPTION
                         WHEN NO_DATA_FOUND THEN 
                         pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
                END;
       
          IF l_dp_copi is null THEN 
             
            RAISE parametrage_controle;
           pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
             
          ELSE 
         
           
              OPEN p_curseur FOR
                SELECT   code, libelle
                    FROM (SELECT dp_copi code, dp_copi || ' - ' || libelle libelle, dp_copi
                            FROM DOSSIER_PROJET_COPI
                            where DPCODE = p_dpcode
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, '_' dp_copi
                            FROM DUAL)
                ORDER BY dp_copi;      
            END IF;
           ELSE 
           
        /* IF p_dpcode = 'Tous' or  p_dpcopi = 'Tous'  THEN
       
                OPEN p_curseur FOR
                SELECT   code, libelle
                    FROM (SELECT dp_copi code, dp_copi || ' - ' || libelle libelle, DPCODE
                            FROM DOSSIER_PROJET_COPI
                           where  INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET_COPI.DPCODE, 'FM00000')) > 0
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, -1 DPCODE
                            FROM DUAL)
                ORDER BY DPCODE; 
          ELSE */
          
             IF p_dpcopiaxemetier <> 'Tous'  THEN 
             
                
             OPEN p_curseur FOR
                SELECT   code, libelle
                    FROM (SELECT dp_copi code, dp_copi || ' - ' || libelle libelle, dp_copi
                            FROM DOSSIER_PROJET_COPI
                              where DPCOPIAXEMETIER = p_dpcopiaxemetier
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, '_' dp_copi
                            FROM DUAL)
                ORDER BY dp_copi;   
            ELSE 
            IF p_dpcopi <> 'Tous'  THEN 
             
            
               OPEN p_curseur FOR
                SELECT   code, libelle
                    FROM (SELECT dp_copi code, dp_copi || ' - ' || libelle libelle, dp_copi
                            FROM DOSSIER_PROJET_COPI
                              where dp_copi = p_dpcopi
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, '_' dp_copi
                            FROM DUAL)
                ORDER BY dp_copi;   
                
           ELSE 
            IF  p_dpcode is null or p_dpcopi is null or p_dpcopiaxemetier is null or p_dpcode = 'Tous' or  p_dpcopi = 'Tous' or   p_dpcopiaxemetier = 'Tous'  THEN
       
               OPEN p_curseur FOR
                SELECT   code, libelle
                    FROM (SELECT dp_copi code, dp_copi || ' - ' || libelle libelle, dp_copi
                            FROM DOSSIER_PROJET_COPI
                           where  INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET_COPI.DPCODE, 'FM00000')) > 0
                        UNION
                          SELECT 'Tous' code, 'Tous' libelle, '_' dp_copi
                            FROM DUAL)
                ORDER BY dp_copi; 
           
     
                
          END If;
          END IF;
         
          END IF;       
          END IF;
          END IF;
         END IF;
         END IF;
        -- END IF;
                 
        
  
      
      EXCEPTION 
             WHEN parametrage_controle THEN
              pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);  
              
             WHEN NO_DATA_FOUND THEN 
             pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
   END liste_dossier_projet_copi;
 
 PROCEDURE liste_ref_demande(p_userid IN VARCHAR2, p_dpcode IN VARCHAR2 , p_dpcopi IN VARCHAR2, p_dpcopiaxemetier IN VARCHAR2,  p_curseur IN OUT listecurtype)
    IS
      l_doss_proj VARCHAR2(5000);
            BEGIN
            
         l_doss_proj := pack_global.lire_doss_proj(p_userid);
          IF   (UPPER(l_doss_proj) = 'TOUS') THEN    
         
       
                 IF p_dpcopi <> 'Tous'  THEN 
            
                 OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT DOSSIER_PROJET_COPI.DPCOPIAXEMETIER code, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER || ' - ' || DMP_RESEAUXFRANCE.DMPLIBEL libelle, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                     FROM DOSSIER_PROJET_COPI
                     LEFT JOIN DMP_RESEAUXFRANCE ON trim(DMP_RESEAUXFRANCE.DMPNUM)= DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                      where DOSSIER_PROJET_COPI.DPCOPIAXEMETIER is not null
                      and  DOSSIER_PROJET_COPI.DP_COPI = p_dpcopi
                        UNION
                          SELECT 'Tous' code, 'Toutes' libelle, '_' DPCOPIAXEMETIER
                            FROM DUAL)
                ORDER BY DPCOPIAXEMETIER;  
          
          ELSE 
            IF  p_dpcode <> 'Tous' THEN     
              --HMI PPM 62325 QC 1854 (Order by tri par DPCOPIAXEMETIER )
          OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT DOSSIER_PROJET_COPI.DPCOPIAXEMETIER code, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER || ' - ' || DMP_RESEAUXFRANCE.DMPLIBEL libelle, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                     FROM DOSSIER_PROJET_COPI
                     LEFT JOIN DMP_RESEAUXFRANCE ON trim(DMP_RESEAUXFRANCE.DMPNUM)= DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                      where DOSSIER_PROJET_COPI.DPCOPIAXEMETIER is not null
                      and DOSSIER_PROJET_COPI.DPCODE = p_dpcode
                        UNION
                          SELECT 'Tous' code, 'Toutes' libelle, '_' DPCOPIAXEMETIER
                            FROM DUAL)
                ORDER BY DPCOPIAXEMETIER;   
                --FIN HMI PPM 62325 QC 1854 
           ELSE
            
            IF  p_dpcopiaxemetier <> 'Tous' THEN     
          OPEN p_curseur FOR
                 SELECT  code, libelle
                    FROM (SELECT distinct DOSSIER_PROJET_COPI.DPCOPIAXEMETIER code, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER || ' - ' || DMP_RESEAUXFRANCE.DMPLIBEL libelle, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                     FROM DOSSIER_PROJET_COPI
                     LEFT JOIN DMP_RESEAUXFRANCE ON trim(DMP_RESEAUXFRANCE.DMPNUM)= DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                      where DOSSIER_PROJET_COPI.DPCOPIAXEMETIER is not null
                      and DOSSIER_PROJET_COPI.DPCOPIAXEMETIER = p_dpcopiaxemetier
                      and rownum = 1
                        UNION
                          SELECT 'Tous' code, 'Toutes' libelle, '_' DPCOPIAXEMETIER
                            FROM DUAL)
                ORDER BY DPCOPIAXEMETIER;   
                ELSE 
            
         IF p_dpcode is null  or p_dpcopi is null  or p_dpcopiaxemetier is null  or p_dpcode = 'Tous' or p_dpcopi = 'Tous' or p_dpcopiaxemetier = 'Tous'
          
            THEN
               OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT DOSSIER_PROJET_COPI.DPCOPIAXEMETIER code, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER || ' - ' || DMP_RESEAUXFRANCE.DMPLIBEL libelle, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                     FROM DOSSIER_PROJET_COPI
                     LEFT JOIN DMP_RESEAUXFRANCE ON trim(DMP_RESEAUXFRANCE.DMPNUM)= DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                      where DOSSIER_PROJET_COPI.DPCOPIAXEMETIER is not null
                        UNION
                          SELECT 'Tous' code, 'Toutes' libelle, '_' DPCOPIAXEMETIER
                            FROM DUAL)
              ORDER BY DPCOPIAXEMETIER;    
                
          
        
        END IF;
        END IF;
        END IF;                   
        END If;
       --here 
       ELSE 
       
     
              
                IF p_dpcopi <> 'Tous'  THEN 
            
                 OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT DOSSIER_PROJET_COPI.DPCOPIAXEMETIER code, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER || ' - ' || DMP_RESEAUXFRANCE.DMPLIBEL libelle, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                     FROM DOSSIER_PROJET_COPI
                     LEFT JOIN DMP_RESEAUXFRANCE ON trim(DMP_RESEAUXFRANCE.DMPNUM)= DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                      where DOSSIER_PROJET_COPI.DPCOPIAXEMETIER is not null
                      and  DOSSIER_PROJET_COPI.DP_COPI = p_dpcopi
                        UNION
                          SELECT 'Tous' code, 'Toutes' libelle, '_' DPCOPIAXEMETIER
                            FROM DUAL)
                ORDER BY DPCOPIAXEMETIER;  
          
          ELSE 
            IF  p_dpcode <> 'Tous' THEN     
          OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT DOSSIER_PROJET_COPI.DPCOPIAXEMETIER code, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER || ' - ' || DMP_RESEAUXFRANCE.DMPLIBEL libelle, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                     FROM DOSSIER_PROJET_COPI
                     LEFT JOIN DMP_RESEAUXFRANCE ON trim(DMP_RESEAUXFRANCE.DMPNUM)= DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                      where DOSSIER_PROJET_COPI.DPCOPIAXEMETIER is not null
                      and DOSSIER_PROJET_COPI.DPCODE = p_dpcode
                        UNION
                          SELECT 'Tous' code, 'Toutes' libelle, '_' DPCOPIAXEMETIER
                            FROM DUAL)
                ORDER BY DPCOPIAXEMETIER;   
           ELSE
            IF  p_dpcopiaxemetier <> 'Tous' THEN     
          OPEN p_curseur FOR
                 SELECT  code, libelle
                    FROM (SELECT  DOSSIER_PROJET_COPI.DPCOPIAXEMETIER code, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER || ' - ' || DMP_RESEAUXFRANCE.DMPLIBEL libelle, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                     FROM DOSSIER_PROJET_COPI
                     LEFT JOIN DMP_RESEAUXFRANCE ON trim(DMP_RESEAUXFRANCE.DMPNUM)= DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                      where DOSSIER_PROJET_COPI.DPCOPIAXEMETIER is not null
                      and DOSSIER_PROJET_COPI.DPCOPIAXEMETIER = p_dpcopiaxemetier
                       and rownum = 1
                        UNION
                          SELECT 'Tous' code, 'Toutes' libelle, '_' DPCOPIAXEMETIER
                            FROM DUAL)
                ORDER BY DPCOPIAXEMETIER;   
                ELSE 
             
         IF p_dpcode is null  or p_dpcopi is null  or p_dpcopiaxemetier is null  or p_dpcode = 'Tous' or p_dpcopi = 'Tous' or p_dpcopiaxemetier = 'Tous'
          
            THEN
               OPEN p_curseur FOR
                 SELECT   code, libelle
                    FROM (SELECT DOSSIER_PROJET_COPI.DPCOPIAXEMETIER code, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER || ' - ' || DMP_RESEAUXFRANCE.DMPLIBEL libelle, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                     FROM DOSSIER_PROJET_COPI
                     LEFT JOIN DMP_RESEAUXFRANCE ON trim(DMP_RESEAUXFRANCE.DMPNUM)= DOSSIER_PROJET_COPI.DPCOPIAXEMETIER
                      where DOSSIER_PROJET_COPI.DPCOPIAXEMETIER is not null
                        and INSTR(l_doss_proj, TO_CHAR(DOSSIER_PROJET_COPI.DPCODE, 'FM00000')) > 0
                        UNION
                          SELECT 'Tous' code, 'Toutes' libelle, '_' DPCOPIAXEMETIER
                            FROM DUAL)
              ORDER BY DPCOPIAXEMETIER;    
                
         
        END IF;
        END IF;
        END IF;                
        END IF;
        END IF;
       -- END IF;
       
       
   END liste_ref_demande;

PROCEDURE  verifi_habilitation(p_userid IN varchar2,p_message OUT VARCHAR2)IS
parametrage_controle EXCEPTION;
 
   
     l_doss_proj VARCHAR2(5000);
     
     
      BEGIN
        p_message := '';
            l_doss_proj := pack_global.lire_doss_proj(p_userid);
            
        IF l_doss_proj IS NULL THEN
         RAISE parametrage_controle;
             pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
      
   ELSE
    p_message := '';
  
    END IF;
    
    EXCEPTION 
      WHEN parametrage_controle
              THEN
            pack_global.recuperer_message (21307, NULL, NULL, NULL, p_message);
           -- raise_application_error (-20999, p_message);
           
  
   END verifi_habilitation;

FUNCTION control (l_valeur IN varchar2) return varchar2
             IS

       l_tab_val PACK_GLOBAL.t_array;
       l_groupe VARCHAR2 (1000);
       counter number(38);
       l_retour   VARCHAR2 (32767);

    BEGIN
     
         counter := 0;
         l_retour := 'valide';
         
                  
       IF l_valeur is null then   l_retour := 'invalide';
       IF   (UPPER(l_valeur) = 'TOUS') THEN   l_retour := 'valide'; 
           ELSE
               l_tab_val := PACK_GLOBAL.SPLIT (l_valeur, ',');

                 FOR i IN 1 .. l_tab_val.count
          LOOP

                 l_groupe := l_tab_val(i);

            select count(*) into counter  from DOSSIER_PROJET where INSTR(TRIM(l_groupe),To_CHAR(DPCODE,'FM00000'))>0;

          if counter > 0 then   l_retour := 'valide';exit;
           else  l_retour := 'invalide';
          END IF;
        END LOOP;
      END IF;
      END IF;
       return l_retour;
END control ;
--FIN HMI PPM 62325 $4.3
END pack_dossier_projet;
/
--SET SERVEROUTPUT ON
--DECLARE
--	p_nbcurseur INTEGER;
--	p_message VARCHAR2(1024);
--BEGIN
--	pack_dossier_projet.update_dossier_projet('12345', 'Test', 0, 'A189194', '01/01/2000', p_nbcurseur, p_message);
--	DBMS_OUTPUT.PUT_LINE(p_message);
--END;
--/