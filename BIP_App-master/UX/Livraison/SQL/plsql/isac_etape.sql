-- APPLICATION ISAC
-- -------------------------------------
-- pack_isac_etape PL/SQL
-- 
-- Cr le 26/03/2002 par NBM
-- Modifi le 25/07/2003 par NBM : suppression de ECET#
-- Modifi le 24/05/2004 par PJO : vrif pas de doublons dans ECET
-- Modifi le 05/03/2004 par PJO : PID sur 4 caractres
-- 10/02/2005 par MMC : ajout controle pour empecher la suppression etapes ayant des sous taches
--			ayant du consomme sur l annee courante
-- Modifi  14/11/2011  ABA   QC 1283
-- Modifi  28/11/2011  ABA   QC 1283
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
create or replace PACKAGE     pack_isac_etape AS


 TYPE etapeCurType IS REF CURSOR RETURN isac_etape%ROWTYPE;


  TYPE ListeViewType IS RECORD(code      VARCHAR2(5),
                                        libelle VARCHAR2(30)
                                        );
   TYPE listeCurType IS REF CURSOR RETURN ListeViewType;


   TYPE RefCurTyp IS REF CURSOR;


  PROCEDURE verif_type_etape ( 	p_pid 	   IN isac_etape.pid%TYPE,
				p_etape    IN VARCHAR2,
				p_typetape IN VARCHAR2,
				p_message  OUT VARCHAR2);


PROCEDURE delete_etape (p_pid     	IN isac_etape.pid%TYPE,
			p_etape 	IN VARCHAR2,
			p_userid     	IN VARCHAR2,
			p_nbcurseur    	OUT INTEGER,
                       	p_message    	OUT VARCHAR2
                        );

PROCEDURE update_etape (p_etape		IN VARCHAR2,
			p_pid     	IN isac_etape.pid%TYPE,
			p_ecet 		IN VARCHAR2,
			p_typetape	IN VARCHAR2,
			p_libetape 	IN VARCHAR2,
            p_jeu       IN VARCHAR2,
			p_flaglock      IN VARCHAR2,
			p_userid     	IN VARCHAR2,
			p_nbcurseur    	OUT INTEGER,
                      	p_message    	OUT VARCHAR2
                        );

PROCEDURE select_etape (p_pid     	IN isac_etape.pid%TYPE,
			p_etape 	IN VARCHAR2,
			p_userid     	IN VARCHAR2,
       p_direction   IN       VARCHAR2,
			p_curEtape     	IN OUT etapeCurType,
			p_nbcurseur    	OUT INTEGER,
                      	p_message    	OUT VARCHAR2
                        );

PROCEDURE insert_etape (p_pid     	IN isac_etape.pid%TYPE,
			p_ecet 		IN VARCHAR2,
			p_typetape	IN VARCHAR2,
			p_libetape 	IN VARCHAR2,
            p_jeu       IN VARCHAR2,
			p_userid     	IN VARCHAR2,
     p_nbcurseur    	OUT INTEGER,
               	        p_message    	OUT VARCHAR2
                        );

PROCEDURE select_etape_suivante (p_pid     	IN  isac_etape.pid%TYPE,
				 p_userid     	IN  VARCHAR2,
                 p_direction    IN VARCHAR2,
				 p_etape  	OUT VARCHAR2,
                 p_jeu      OUT VARCHAR2,
			 	 p_nbcurseur    OUT INTEGER,
                                 p_message    	OUT VARCHAR2
                                );

PROCEDURE liste_jeu(p_userid  IN VARCHAR2,
                    p_direction    IN VARCHAR2,
                    p_mode IN VARCHAR2,
                    p_pid     	IN  isac_etape.pid%TYPE,

                    p_etape IN VARCHAR2,
                    p_curseur IN OUT RefCurTyp,
                     p_message     OUT      message.limsg%TYPE
                              );


PROCEDURE liste_type_etape_jeu(p_userid  IN VARCHAR2,
                               p_jeu    IN VARCHAR2,
                               p_pid     	IN  isac_etape.pid%TYPE,
                               p_mode IN VARCHAR2,
                               p_direction IN VARCHAR2,
                              p_curseur IN OUT listeCurType
                              );
FUNCTION control(l_valeur IN varchar2, p_pid     	IN  isac_etape.pid%TYPE ,  SEPARATEUR IN varchar2 ) return varchar2 ;




FUNCTION controle_parametrage RETURN BOOLEAN;
Function verifTypologie(p_pid IN varchar2, p_valeur IN varchar2 ,  SEPARATEUR IN varchar2)return varchar2;
Function verifTypologieTypeEtape(p_pid IN varchar2, p_valeur IN varchar2 )return varchar2;
FUNCTION controle_prio(l_valeur IN varchar2 ,  SEPARATEUR IN varchar2) return VARCHAR2 ;
FUNCTION get_jeu_prio(p_direction IN VARCHAR2, p_pid IN VARCHAR2) return VARCHAR2;

--HMI - PPM 60709 - $5.3 - QC: 1774
Procedure parametrage_defaut(p_message OUT VARCHAR2);


END pack_isac_etape;
/


create or replace PACKAGE BODY     pack_isac_etape
AS
-- *****************************************************************************************************
-- Procédure verif_type_etape
-- Vérifie que le type d'étape convient pour la ligne BIP
-- appelée dans les procédures insert_etape et update_etape
-- *****************************************************************************************************
   PROCEDURE verif_type_etape (p_pid IN isac_etape.pid%TYPE, p_etape IN VARCHAR2, p_typetape IN VARCHAR2, p_message OUT VARCHAR2)
   IS
      l_typproj    NUMBER;
      l_count      NUMBER;
      l_typetape   VARCHAR2 (2);
   BEGIN
      -- Vérifier le type de projet
      SELECT TO_NUMBER (typproj)
        INTO l_typproj
        FROM ligne_bip
       WHERE pid = p_pid;

      -- Projet de type ABSENCE
      IF l_typproj = 7
      THEN
         -- Est-ce qu'il existe déjà une étape ES?
         BEGIN
            SELECT typetape
              INTO l_typetape
              FROM isac_etape
             WHERE pid = p_pid AND typetape = 'ES';

            --Message d'erreur : Une seule étape ES pour ce projet de type ABSENCE
            pack_isac.recuperer_message (20006, NULL, NULL, 'TYPETAPE', p_message);
            raise_application_error (-20006, p_message);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               --Vérifier que le type d'étape entré est bien ES
               IF p_typetape != 'ES'
               THEN
                  --Message d'erreur : Etape ES obligatoire pour ce projet de type ABSENCE
                  pack_isac.recuperer_message (20007, NULL, NULL, 'TYPETAPE', p_message);
                  raise_application_error (-20007, p_message);
               END IF;
         END;
      END IF;
   END verif_type_etape;

--*************************************************************************************************
-- Procédure delete_etape
--
-- Permet de supprimer une étape et les tâches,sous-tâches,affectations,consommés associés
-- Appelée dans la page iletape.htm à partir du bouton "Supprimer
--
-- ************************************************************************************************
   PROCEDURE delete_etape (p_pid IN isac_etape.pid%TYPE, p_etape IN VARCHAR2, p_userid IN VARCHAR2, p_nbcurseur OUT INTEGER, p_message OUT VARCHAR2)
   IS
      l_ecet            VARCHAR2 (2);
      l_libetape        VARCHAR2 (35);
      l_test            NUMBER;
      l_anneecourante   VARCHAR2 (4);
      l_conso           NUMBER;
   BEGIN
      p_message := '';

      BEGIN
         --test pour savoir si la tache comprend des sous-taches avec du FF sur une ligne fermée
         SELECT 1
           INTO l_test
           FROM isac_sous_tache sst, isac_etape e, ligne_bip lb, datdebex dx
          WHERE lb.pid(+) = SUBSTR (sst.aist, 3, 4)
            AND e.etape = TO_NUMBER (p_etape)
            AND e.etape = sst.etape
            AND lb.adatestatut IS NOT NULL
            AND lb.adatestatut <= ADD_MONTHS (dx.moismens, -1)
            AND ROWNUM = 1;

         IF l_test = 1
         THEN
            pack_isac.recuperer_message (20025, NULL, NULL, NULL, p_message);
            raise_application_error (-20025, p_message);
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         --on recupere l annee courante
         SELECT TO_CHAR (datdebex, 'YYYY')
           INTO l_anneecourante
           FROM datdebex;

         --on verifie qu il n y a pas de consomme sur l annee
		 -- FAD PPM 65123 : Ajout du contrôle du consommé sur la table PMW_BIPS et CONS_SSTACHE_RES_MOIS
         SELECT NVL (SUM (consomme), 0) INTO l_conso
		 FROM (
		   SELECT c.cusag consomme
           FROM isac_consomme c, isac_etape e
          WHERE c.etape(+) = e.etape AND e.etape = TO_NUMBER (p_etape) AND TO_CHAR (c.cdeb, 'YYYY') = l_anneecourante

		  UNION

		  SELECT cstrm.cusag
		FROM cons_sstache_res_mois cstrm, isac_etape itp
		WHERE itp.etape=to_number(p_etape)
		AND itp.pid = cstrm.pid
		AND itp.ecet = cstrm.ecet
		AND to_char(cstrm.cdeb,'YYYY')=l_anneecourante

		UNION

		SELECT PB.CONSOQTE
		FROM PMW_BIPS PB, isac_tache it, isac_etape itp
		WHERE itp.etape=to_number(p_etape)
		AND itp.pid = PB.LIGNEBIPCODE
		AND itp.ecet = PB.ETAPENUM
    /*QC - 1980 starts*/
    AND PB.PRIORITE = 'P2'
    /*QC - 1980 ends*/
    AND (TO_CHAR(CONSODEBDATE, 'YYYY') = (SELECT TO_CHAR(DATDEBEX, 'YYYY') FROM DATDEBEX)
		OR TO_CHAR(CONSOFINDATE, 'YYYY') = (SELECT TO_CHAR(DATDEBEX, 'YYYY') FROM DATDEBEX))
		  );
		 -- FAD PPM 65123 : Fin

         IF l_conso <> 0
         THEN
            pack_isac.recuperer_message (20030, NULL, NULL, NULL, p_message);
            raise_application_error (-20030, p_message);
         END IF;
      END;

      BEGIN
         SELECT ecet, libetape
           INTO l_ecet, l_libetape
           FROM isac_etape
          WHERE pid = p_pid AND etape = TO_NUMBER (p_etape);

         --Supprimer les tâches,sous-tâches,affections,consommés
         DELETE      isac_consomme
               WHERE pid = p_pid AND etape = TO_NUMBER (p_etape);

         DELETE      isac_affectation
               WHERE pid = p_pid AND etape = TO_NUMBER (p_etape);

         DELETE      isac_sous_tache
               WHERE pid = p_pid AND etape = TO_NUMBER (p_etape);

         DELETE      isac_tache
               WHERE pid = p_pid AND etape = TO_NUMBER (p_etape);

         DELETE      isac_etape
               WHERE pid = p_pid AND etape = TO_NUMBER (p_etape);

         COMMIT;
         --Etape supprimée
         pack_isac.recuperer_message (20002, '%s1', 'Etape ' || l_ecet || ' - ' || l_libetape, NULL, p_message);
      END;
   END delete_etape;

--*************************************************************************************************
-- Procédure update_etape
--
-- Permet de modifier une étape
-- Appelée dans la page imetape.htm
--
-- ************************************************************************************************
   PROCEDURE update_etape (
      p_etape       IN       VARCHAR2,
      p_pid         IN       isac_etape.pid%TYPE,
      p_ecet        IN       VARCHAR2,
      p_typetape    IN       VARCHAR2,
      p_libetape    IN       VARCHAR2,
      p_jeu         IN       VARCHAR2,
      p_flaglock    IN       VARCHAR2,
      p_userid      IN       VARCHAR2,
      p_nbcurseur   OUT      INTEGER,
      p_message     OUT      VARCHAR2
   )
   IS
      l_count      NUMBER (1);
      l_msg        VARCHAR2 (255);
      l_old_ecet   VARCHAR2 (2);
      l_typetape   VARCHAR2 (2);
   BEGIN
      p_nbcurseur := 0;
      p_message := '';
      l_msg := '';

      -- Recherche de l'ancien numéro d'étape de l'étape
      SELECT ecet, typetape
        INTO l_old_ecet, l_typetape
        FROM isac_etape
       WHERE pid = p_pid AND etape = TO_NUMBER (p_etape);

      IF l_typetape != p_typetape
      THEN
         --Controler le type d'étape de la ligne BIP
         verif_type_etape (p_pid, p_etape, p_typetape, p_message);
      END IF;

      SELECT COUNT (etape)
        INTO l_count
        FROM isac_etape
       WHERE pid = p_pid AND ecet = p_ecet AND ecet != l_old_ecet;

      IF (l_count != 0)
      THEN
         --Vous ne pouvez pas modifier le numéro d'une étape qui existe déjà
         pack_isac.recuperer_message (20001, '%s1', 'une étape', 'ECET', l_msg);
         raise_application_error (-20001, l_msg);
      ELSE
         -- Modification de l'étape
         UPDATE isac_etape
            SET ecet = p_ecet,
                typetape = p_typetape,
                libetape = p_libetape,
                jeu = p_jeu,
                flaglock = TO_NUMBER (DECODE (p_flaglock, 1000000, 0, p_flaglock + 1))
          WHERE pid = p_pid AND etape = TO_NUMBER (p_etape) AND flaglock = TO_NUMBER (p_flaglock, 'FM9999999');

         IF SQL%NOTFOUND
         THEN                                                                                                                      -- Acces concurrent
            pack_global.recuperer_message (20999, NULL, NULL, NULL, l_msg);
            raise_application_error (-20999, l_msg);
         END IF;

         COMMIT;
      END IF;
   END update_etape;

--*************************************************************************************************
-- Procédure select_etape
--
-- Permet d'afficher les champs modifiables d'une étape
-- Appelée dans la page iletape.htm à partir du bouton "Modifier"
--
-- ************************************************************************************************
   PROCEDURE select_etape (
      p_pid         IN       isac_etape.pid%TYPE,
      p_etape       IN       VARCHAR2,
      p_userid      IN       VARCHAR2,
      p_direction   IN       VARCHAR2,
      p_curetape    IN OUT   etapecurtype,
      p_nbcurseur   OUT      INTEGER,
      p_message     OUT      VARCHAR2
   )
   IS

      l_typetape    VARCHAR2 (600);
      l_separateur  VARCHAR2(10);

      l_jeu       ISAC_ETAPE.JEU%TYPE;
      l_jeu_prio     ISAC_ETAPE.JEU%TYPE;
      l_test        NUMBER;
      parametrage   EXCEPTION;
      l_valeur_param VARCHAR2 (1000);
       l_valeur VARCHAR2 (1000);
      l_typo VARCHAR2 (1000);
       l_typeLigne     TYPE_ETAPE.TYPELIGNE%TYPE;
      --HMI - PPM 60709 : $5.3 Exception de paramétrage DEFAULT inexistant
      parametrage_controle   EXCEPTION;


   BEGIN
      p_nbcurseur := 0;
      p_message := '';
      l_jeu := '';
      l_jeu_prio := '';
      l_test := '';
      l_typetape := '';

      BEGIN
         IF NOT pack_type_etape.controle_parametrage
         THEN
            RAISE parametrage;
         END IF;


          --HMI - PPM 60709 : $5.3 Exception de paramétrage DEFAULT inexistant
           IF NOT controle_parametrage
         THEN
            RAISE parametrage_controle;
      END IF;

-- ABN - PPM 63401 - Permettre la modification d'une étape et d'une tache qui comporte une sous tache de type FF sur une ligne fermee
         /*BEGIN
            --test pour savoir si la tache comprend des sous-taches avec du FF sur une ligne fermée
            SELECT 1
              INTO l_test
              FROM isac_sous_tache sst, isac_etape e, ligne_bip lb, datdebex dx
             WHERE lb.pid(+) = SUBSTR (sst.aist, 3, 4)
               AND e.etape = TO_NUMBER (p_etape)
               AND e.etape = sst.etape
               AND lb.adatestatut IS NOT NULL
               AND lb.adatestatut <= ADD_MONTHS (dx.moismens, -1)
               AND ROWNUM = 1;

            IF l_test = 1
            THEN
               pack_isac.recuperer_message (20023, NULL, NULL, NULL, p_message);
               raise_application_error (-20023, p_message);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;*/

-- ABN - PPM 63401 - Permettre la modification d'une étape et d'une tache qui comporte une sous tache de type FF sur une ligne fermee

-- HMI PPM 60709 $5.3 QC 1782

                 SELECT TYPETAPE, JEU
                 INTO l_typetape, l_jeu
                 FROM isac_etape
                WHERE pid = p_pid AND etape = TO_NUMBER (p_etape) ;

     IF l_jeu = 'Sans objet'
     THEN
     OPEN p_curetape FOR
               SELECT ETAPE, PID, ECET, LIBETAPE, 'NO - Etape globale' TYPETAPE, FLAGLOCK, 'Sans objet' JEU
                 FROM isac_etape
                WHERE pid = p_pid AND etape = TO_NUMBER (p_etape) ;
    ELSE

        BEGIN
             SELECT  ''''||REPLACE (valeur, ',', ''',''') ||'''', SEPARATEUR
              INTO l_valeur, l_separateur
              FROM ligne_param_bip
              WHERE code_action = 'TYPETAPES-JEUX'
               AND code_version = p_direction
               AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX' AND actif = 'O')
                                 AND control(valeur,p_pid,SEPARATEUR) is not null;


            EXCEPTION
              WHEN NO_DATA_FOUND
            THEN
            BEGIN
                SELECT  ''''||REPLACE (valeur, ',', ''',''') ||'''' , SEPARATEUR
                 INTO l_valeur,  l_separateur
                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip
                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O')
                                     AND control(valeur,p_pid,SEPARATEUR) is not null;


      EXCEPTION
              WHEN NO_DATA_FOUND
            THEN
            l_valeur := '';
            l_separateur := '';
        END;
        END;


        l_valeur := control(l_valeur,p_pid,l_separateur);

        BEGIN
                SELECT TYPELIGNE
                into l_typeLigne
                from TYPE_ETAPE
                where TYPETAP = l_typetape and jeu = l_jeu
                and  INSTR(l_valeur,l_jeu)>0;
          EXCEPTION
           WHEN NO_DATA_FOUND
          THEN
    BEGIN

    --HMI QC 1800
             select jeu, TYPELIGNE
             into l_jeu, l_typeLigne
             from TYPE_ETAPE
             where TYPETAP = l_typetape  and  INSTR(l_valeur,jeu)>0
              and   rownum = 1
            order by CHRONOLOGIE ;

        EXCEPTION
           WHEN NO_DATA_FOUND
          THEN
            l_typeLigne := '^';
   END;

  END;

       -- HMI PPM 60709 $5.3 QC 1782 : vérifier si le type d'étape en cours est compatible au contexte
      IF verifTypologieTypeEtape(p_pid,l_typeLigne)like 'valide'
      THEN
        OPEN p_curetape FOR
              SELECT ETAPE, PID, ECET, LIBETAPE, l_typetape TYPETAPE, FLAGLOCK, l_jeu JEU

              FROM isac_etape
                WHERE pid = p_pid AND etape = TO_NUMBER (p_etape) ;
      ELSE
        -- rechercher le 1er type d'étape compatible au contexte
             l_jeu_prio := get_jeu_prio(p_direction,p_pid);
         BEGIN
              select TYPETAP
              into l_typetape
              from type_etape
              where jeu = l_jeu_prio
              and (verifTypologieTypeEtape(p_pid,TYPELIGNE) = 'valide')
              and CHRONOLOGIE = (select min(CHRONOLOGIE) from type_etape
              where jeu = l_jeu_prio
              and (verifTypologieTypeEtape(p_pid,TYPELIGNE) = 'valide'));

              OPEN p_curetape FOR
               SELECT ETAPE, PID, ECET, LIBETAPE, l_typetape TYPETAPE, FLAGLOCK, l_jeu_prio JEU
                 FROM isac_etape
                WHERE pid = p_pid AND etape = TO_NUMBER (p_etape) ;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

       BEGIN
            SELECT valeur, SEPARATEUR
            INTO l_valeur_param, l_separateur
            FROM ligne_param_bip
            WHERE code_action = 'TYPETAPES-JEUX-T'
            AND code_version = p_direction
             AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX-T' AND actif = 'O');

         l_typo := verifTypologie(p_pid,l_valeur_param,l_separateur);
         IF  l_typo like 'valide'
         THEN

            l_jeu_prio := ' ';

           ELSE

             l_jeu_prio := 'Sans objet';

         END IF;

           EXCEPTION
              WHEN NO_DATA_FOUND
            THEN
           l_jeu_prio := 'Sans objet';
     END;

         OPEN p_curetape FOR
                  SELECT ETAPE, PID, ECET, LIBETAPE, ' ' TYPETAPE, FLAGLOCK, l_jeu_prio JEU
                 FROM isac_etape
                WHERE pid = p_pid AND etape = TO_NUMBER (p_etape) ;

        END;
END IF;

         END IF;

      EXCEPTION
         WHEN parametrage
         THEN
            pack_global.recuperer_message (21231, NULL, NULL, NULL, p_message);
            raise_application_error (-20999, p_message);

            --HMI - PPM 60709 : $5.3 Exception de paramétrage DEFAULT inexistant
             WHEN parametrage_controle
         THEN
            pack_global.recuperer_message (21299, NULL, NULL, NULL, p_message);
            raise_application_error (-20999, p_message);
      END;
   END select_etape;

--*************************************************************************************************
-- Procédure insert_etape
--
-- Permet de créer une étape
-- Appelée dans la page icetape.htm
--
-- ************************************************************************************************
   PROCEDURE insert_etape (
      p_pid         IN       isac_etape.pid%TYPE,
      p_ecet        IN       VARCHAR2,
      p_typetape    IN       VARCHAR2,
      p_libetape    IN       VARCHAR2,
      p_jeu         IN       VARCHAR2,
      p_userid      IN       VARCHAR2,
      p_nbcurseur   OUT      INTEGER,
      p_message     OUT      VARCHAR2
   )
   IS
      l_etape   NUMBER;
      l_count   NUMBER;
   BEGIN
      p_nbcurseur := 0;
      p_message := '';

      -- On compte le nombre d'étape de même numéro
      SELECT COUNT (*)
        INTO l_count
        FROM isac_etape
       WHERE pid = p_pid AND ecet = p_ecet;

      IF l_count = 0
      THEN
         SELECT seq_etape.NEXTVAL
           INTO l_etape
           FROM DUAL;

         verif_type_etape (p_pid, l_etape, p_typetape, p_message);

         INSERT INTO isac_etape
                     (etape, pid, ecet, typetape, libetape, flaglock, jeu
                     )
              VALUES (l_etape, p_pid, p_ecet, p_typetape, p_libetape, 0, p_jeu
                     );

         COMMIT;
      -- S'il y a déjà ce numéro d'étape d'enregistré on renvoie une erreur.
      ELSE
         pack_global.recuperer_message (20044, NULL, NULL, NULL, p_message);
         raise_application_error (-20044, p_message);
      END IF;
   END insert_etape;

--*************************************************************************************************
-- Procédure select_etape_suivante
--
-- Permet d'afficher le numéro de la nouvelle étape lors de la création d'une étape
-- Appelée dans la page iletape.htm à partir du bouton "Créer"
--
-- ************************************************************************************************
   PROCEDURE select_etape_suivante (
      p_pid         IN       isac_etape.pid%TYPE,
      p_userid      IN       VARCHAR2,
      p_direction   IN       VARCHAR2,
      p_etape       OUT      VARCHAR2,
      p_jeu         OUT      VARCHAR2,
      p_nbcurseur   OUT      INTEGER,
      p_message     OUT      VARCHAR2
   )
   IS
      l_ecet        NUMBER;
      l_msg         VARCHAR2 (1000);
      parametrage   EXCEPTION;
       --HMI - PPM 60709 : $5.3 Exception de paramétrage DEFAULT inexistant
      parametrage_controle   EXCEPTION;
             l_valeur   VARCHAR2 (600);
            l_valeur_add   VARCHAR2 (1000);
            l_valeur_param   VARCHAR2 (1000);
            l_typo   VARCHAR2 (1000);
            l_separateur VARCHAR2 (10);

   BEGIN
      p_nbcurseur := 1;
      p_message := '';
      l_msg := '';
      l_valeur_add := '';
      l_valeur := '';

      BEGIN
         IF NOT pack_type_etape.controle_parametrage
         THEN

            RAISE parametrage;
         END IF;

          --HMI - PPM 60709 : $5.3 Exception de paramétrage DEFAULT inexistant
         IF NOT controle_parametrage
         THEN  RAISE parametrage_controle;
END IF;

         SELECT NVL (MAX (TO_NUMBER (ecet)), 0) + 1
           INTO l_ecet
           FROM isac_etape
          WHERE pid = p_pid;

         p_etape := TO_CHAR (l_ecet, 'FM00');

         IF l_ecet > 99
         THEN
--99 étapes maximum par ligne BIP
            pack_isac.recuperer_message (20015, NULL, NULL, NULL, l_msg);
            raise_application_error (-20015, l_msg);
         END IF;

-- initialisation du jeu permet de charger à l'affichage de la page de création l''ensemble des code type d'étape en fonction du jeu

 --HMI - PPM 60709 : $5.3 QC 1780


     BEGIN
              SELECT  ''''||REPLACE (valeur, ',', ''',''') ||'''', SEPARATEUR
              INTO l_valeur,l_separateur

              FROM ligne_param_bip
              WHERE code_action = 'TYPETAPES-JEUX'
               AND code_version = p_direction
               AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX' AND actif = 'O')

                                 AND control(valeur,p_pid,SEPARATEUR) is not null;
            EXCEPTION
              WHEN NO_DATA_FOUND
            THEN

            BEGIN
                SELECT  ''''||REPLACE (valeur, ',', ''',''') ||'''',SEPARATEUR
                 INTO l_valeur,l_separateur


                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip
                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O')



                                     AND control(valeur,p_pid,SEPARATEUR) is not null;

      EXCEPTION
              WHEN NO_DATA_FOUND
            THEN
            l_valeur := '';
        END;
        END;

           l_valeur_add := control(l_valeur,p_pid,l_separateur);

           IF l_valeur_add || '^' = '^'

           then
           BEGIN
            SELECT  ''''||REPLACE (valeur, ',', ''',''') ||'''',SEPARATEUR
                 INTO l_valeur,l_separateur
                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip
                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O')
                                     AND control(valeur,p_pid,SEPARATEUR) is not null;


               EXCEPTION
              WHEN NO_DATA_FOUND
            THEN
            l_valeur := '';
        END;
             l_valeur_add := control(l_valeur,p_pid,l_separateur);
         END IF;


    IF l_valeur_add || '^' = '^'




    THEN
     BEGIN
            SELECT valeur,SEPARATEUR
            INTO l_valeur_param,l_separateur
            FROM ligne_param_bip
            WHERE code_action = 'TYPETAPES-JEUX-T'
            AND code_version = p_direction
             AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX-T' AND actif = 'O');


         l_typo := verifTypologie(p_pid,l_valeur_param,l_separateur);
         IF  l_typo like 'valide'
         THEN

            p_jeu := ' ';

           ELSE


             p_jeu := 'Sans objet';


         END IF;

           EXCEPTION
              WHEN NO_DATA_FOUND
            THEN
           p_jeu := 'Sans objet';
     END;

            ELSE


            l_valeur_add := control(l_valeur,p_pid,l_separateur);
            l_valeur_add := controle_prio(l_valeur_add,l_separateur);


            l_valeur_add := replace(l_valeur_add,'''','');
            p_jeu := l_valeur_add;

          END IF;
           p_message := l_msg;


          EXCEPTION
           WHEN parametrage
              THEN
             pack_global.recuperer_message (21231, NULL, NULL, NULL, l_msg);
              raise_application_error (-20999, l_msg);

        --HMI - PPM 60709 : $5.3 Exception de paramétrage DEFAULT inexistant
           WHEN parametrage_controle
              THEN

            pack_global.recuperer_message (21299, NULL, NULL, NULL, p_message);
            raise_application_error (-20999, p_message);
      END;
   END select_etape_suivante;

--Nouvelle procedure de selection de la liste des jeux  : HMI - PPM 60709 : $5.3
PROCEDURE liste_jeu ( p_userid IN VARCHAR2, p_direction IN VARCHAR2, p_mode IN VARCHAR2,p_pid     	IN  isac_etape.pid%TYPE, p_etape    IN    VARCHAR2,  p_curseur IN OUT refcurtyp,  p_message     OUT      message.limsg%TYPE)
   IS
      l_valeur   VARCHAR2 (1000);
      l_typo      VARCHAR2 (1000);
      l_typproj    NUMBER;
       l_typetape    VARCHAR2 (1000);
      l_jeu    VARCHAR2 (1000);
      l_valeur_param   VARCHAR2 (1000);
      l_req      VARCHAR2 (4000);
      l_tab_jeu PACK_GLOBAL.t_array;
       l_valeur_add   VARCHAR2 (1000);
       l_groupe VARCHAR2 (1000);
       counter number(5);
       l_msg            VARCHAR2 (32767);
       parametrage_controle   EXCEPTION;
       l_separateur VARCHAR2 (10);

   BEGIN
   l_valeur_add := '';
   counter := 0;

      --HMI - PPM 60709 : $5.3
      -- En mode modification : on affiche tous les jeux avec le jeu prioritaire en premier,  et celui enregistré sera selectionné

      IF (p_mode = 'update') THEN


      BEGIN

            SELECT valeur,SEPARATEUR
            INTO l_valeur_param,l_separateur
            FROM ligne_param_bip
            WHERE code_action = 'TYPETAPES-JEUX-T'
            AND code_version = p_direction



             AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX-T' AND actif = 'O');


            l_typo := verifTypologie(p_pid,l_valeur_param,l_separateur);
          --  SI le paramètre applicatif Bip est trouvé, et SI la typologie de la ligne en cours est concernée par le paramètre applicatif
            IF  l_typo like 'valide'
               THEN

        BEGIN


            SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR
            INTO l_valeur,l_separateur
              FROM ligne_param_bip
             WHERE code_action = 'TYPETAPES-JEUX'
               AND code_version = p_direction
               AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX' AND actif = 'O');


         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
            BEGIN

               SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR
               INTO l_valeur,l_separateur
                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip

                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O');

            END;
         END;
     -- on affiche la liste de tous les jeux qui sont compatible avec le contexte
      l_valeur_add := control(l_valeur,p_pid,l_separateur);


      IF l_valeur_add || '^' = '^'
         THEN
          SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR
               INTO l_valeur,l_separateur
                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip
                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O');

      l_valeur_add := control(l_valeur,p_pid,l_separateur);

       END IF;



        select jeu into l_jeu from isac_etape where ETAPE = p_etape;

       IF l_valeur_add || '^' = '^' THEN


     IF l_jeu = 'Sans objet'
        then
        l_req :=
                   'SELECT ''Sans objet'' code, ''Sans objet'' libelle,999 top_tri FROM dual order by top_tri';
              OPEN p_curseur FOR l_req;

       ELSE
         l_req :=
                   'SELECT '' '' code, '' '' libelle,999 top_tri FROM dual order by top_tri';
              OPEN p_curseur FOR l_req;
    END IF;

    ELSE
      IF l_jeu = 'Sans objet'
        then
        l_req :=
               'select code, libelle from (SELECT jeu code,jeu libelle, top_tri FROM type_etape_jeux WHERE jeu in ('

            || l_valeur_add

            || ') UNION
        SELECT ''Sans objet'' code, ''Sans objet'' libelle,999 top_tri FROM dual
        ) order by top_tri';
         OPEN p_curseur FOR l_req;

       ELSE
           l_req :=
               'select code, libelle from (SELECT jeu code,jeu libelle, top_tri FROM type_etape_jeux WHERE jeu in ('
            || l_valeur_add

            || ' )) order by top_tri';
         OPEN p_curseur FOR l_req;

    END IF;
    END IF;


        ELSE

          BEGIN
              SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR
              INTO l_valeur,l_separateur
              FROM ligne_param_bip
             WHERE code_action = 'TYPETAPES-JEUX'
               AND code_version = p_direction
               AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX' AND actif = 'O');

         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN

             SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR
              INTO l_valeur,l_separateur
                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip
                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O');

          END;

        l_valeur_add := control(l_valeur,p_pid,l_separateur);

        IF l_valeur_add || '^' = '^' then


        SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR
              INTO l_valeur,l_separateur
                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip
                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O');






        l_valeur_add := control(l_valeur,p_pid,l_separateur);
     END IF;

     -- on affiche la liste de tous les jeux compatible avec le Sans objet

    IF l_valeur_add || '^' = '^' THEN


         l_req :=
                   'SELECT ''Sans objet'' code, ''Sans objet'' libelle,999 top_tri FROM dual order by top_tri';
              OPEN p_curseur FOR l_req;


      ELSE
       l_req :=
               'select code, libelle from (SELECT jeu code,jeu libelle, top_tri FROM type_etape_jeux WHERE jeu in ('

            || l_valeur_add

            || ') UNION
        SELECT ''Sans objet'' code, ''Sans objet'' libelle,999 top_tri FROM dual
        ) order by top_tri';
         OPEN p_curseur FOR l_req;

     END IF;

            END IF;

            EXCEPTION
            WHEN NO_DATA_FOUND THEN

          BEGIN


            SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR
                 INTO l_valeur,l_separateur
              FROM ligne_param_bip
             WHERE code_action = 'TYPETAPES-JEUX'
               AND code_version = p_direction
               AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX' AND actif = 'O');

         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN



                 SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR
                 INTO l_valeur,l_separateur
                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip
                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O');

           END;

     l_valeur_add := control(l_valeur,p_pid,l_separateur);

     IF l_valeur_add || '^' = '^' then


          SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR
                 INTO l_valeur,l_separateur
                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip
                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O');













         l_valeur_add := control(l_valeur,p_pid,l_separateur);


      END IF;



     -- on affiche la liste de tous les jeux compatible avec le Sans objet
    IF l_valeur_add || '^' = '^' THEN


         l_req :=
                   'SELECT ''Sans objet'' code, ''Sans objet'' libelle,999 top_tri FROM dual order by top_tri';
              OPEN p_curseur FOR l_req;



      ELSE

         l_req :=
               'select code, libelle from (SELECT jeu code,jeu libelle, top_tri FROM type_etape_jeux WHERE jeu in ('

            || l_valeur_add

            || ') UNION
        SELECT ''Sans objet'' code, ''Sans objet'' libelle,999 top_tri FROM dual
        ) order by top_tri';
         OPEN p_curseur FOR l_req;

    END IF;

            END;


      --HMI - PPM 60709 : $5.3
      --En mode création : on affiche uniquement le jeu prioritaire
      ELSE

  BEGIN



            SELECT valeur,SEPARATEUR

            INTO l_valeur_param,l_separateur
            FROM ligne_param_bip
            WHERE code_action = 'TYPETAPES-JEUX-T'
            AND code_version = p_direction
             AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX-T' AND actif = 'O');




     l_typo := verifTypologie(p_pid,l_valeur_param,l_separateur);
          --  SI le paramètre applicatif Bip est trouvé, et SI la typologie de la ligne en cours est concernée par le paramètre applicatif
    IF  l_typo like 'valide'
       THEN

            l_valeur_add := get_jeu_prio(p_direction,p_pid);
        IF l_valeur_add || '^' = '^'
         THEN
          l_req :=
                   'SELECT '' '' code, '' '' libelle,999 top_tri FROM dual order by top_tri';
              OPEN p_curseur FOR l_req;


        ELSE


       --on affiche uniquement le jeu prioritaire
         OPEN p_curseur FOR
                      SELECT   code, libelle
                          FROM (SELECT jeu code, jeu libelle, top_tri
                                  FROM type_etape_jeux
                                 WHERE jeu = l_valeur_add
                                )
                      ORDER BY top_tri;



    END IF;
    ELSE

      l_valeur_add := get_jeu_prio(p_direction,p_pid);

        IF l_valeur_add || '^' = '^' then
            -- si aucun jeu prioritaire
             l_req :=
                   'SELECT ''Sans objet'' code, ''Sans objet'' libelle,998 top_tri FROM dual order by top_tri';
              OPEN p_curseur FOR l_req;

        ELSE
            -- on affiche le jeu prioritaire avec le sans objet
             OPEN p_curseur FOR
                SELECT   code, libelle
                    FROM (SELECT jeu code, jeu libelle, top_tri
                            FROM type_etape_jeux
                           WHERE jeu = l_valeur_add
                          UNION
                          SELECT 'Sans objet' code, 'Sans objet' libelle, 999 top_tri
                            FROM DUAL)
                ORDER BY top_tri;

        END IF;
  END IF;



    EXCEPTION
    WHEN NO_DATA_FOUND THEN

          l_valeur_add := get_jeu_prio(p_direction,p_pid);

         IF l_valeur_add || '^' = '^' then
                -- si aucun jeu prioritaire
                 l_req :=
                       'SELECT ''Sans objet'' code, ''Sans objet'' libelle,998 top_tri FROM dual order by top_tri';
                  OPEN p_curseur FOR l_req;

       ELSE
       -- on affiche le jeu prioritaireavec le sans objet
            OPEN p_curseur FOR
            SELECT   code, libelle
                FROM (SELECT jeu code, jeu libelle, top_tri
                        FROM type_etape_jeux
                       WHERE jeu = l_valeur_add
                      UNION
                      SELECT 'Sans objet' code, 'Sans objet' libelle, 999 top_tri
                        FROM DUAL)
            ORDER BY top_tri;

     END IF;

   END;

END IF;
END liste_jeu;



    PROCEDURE liste_type_etape_jeu (p_userid IN VARCHAR2, p_jeu IN VARCHAR2,p_pid IN  isac_etape.pid%TYPE,p_mode IN VARCHAR2, p_direction IN VARCHAR2, p_curseur IN OUT listecurtype)
   IS
      l_typproj   NUMBER;
      l_typo      VARCHAR2 (600);
      l_typologie      VARCHAR2 (600);
       l_typo2      VARCHAR2 (600);
      l_jeu      VARCHAR2 (600);
      l_valeur_param      VARCHAR2 (600);
      l_jeu_prio VARCHAR2 (600);
      counter NUMBER;
      counterNO NUMBER;
      l_separateur  VARCHAR2 (10);


   BEGIN
    counter:=0;
    counterNO:=0;
    -- HMI - PPM 60709 : $5.3

           -- SI la ligne est productive : Choix uniquement du type d'étape NO
      IF (p_jeu = 'Sans objet')
        THEN

         OPEN p_curseur FOR
            SELECT 'NO' code, 'NO - Etape globale' libelle
             FROM DUAL;

      ELSE
        -- Affichage des types d'etape compatible pour le jeu selectionne



         OPEN p_curseur FOR
            SELECT   typetap code, typetap || ' - ' || libtyet libelle
                FROM type_etape
               WHERE jeu = p_jeu
               AND (verifTypologieTypeEtape(p_pid,TYPELIGNE) like 'valide')

           ORDER BY chronologie;

           END IF;


   END liste_type_etape_jeu;
    --HMI - PPM 60709 : $5.3 : FUNCTION return la liste des jeux appartenant au parametrage et compatible au contexte
  FUNCTION control (l_valeur IN varchar2, p_pid  IN  isac_etape.pid%TYPE , SEPARATEUR IN varchar2 ) return varchar2
             IS

       l_tab_jeu PACK_GLOBAL.t_array;
       l_valeur_add   VARCHAR2 (1000);
       l_groupe VARCHAR2 (1000);


       counter number(38);
       l_msg   VARCHAR2 (32767);


    BEGIN
         l_valeur_add := '';
         counter := 0;




       IF l_valeur is not null then





       l_tab_jeu := PACK_GLOBAL.SPLIT (l_valeur, SEPARATEUR);


            FOR i IN 1 .. l_tab_jeu.count LOOP
              l_groupe := replace(l_tab_jeu(i),'''','');

         SELECT  count(*) into counter
               FROM type_etape
               WHERE jeu =l_groupe
              AND (verifTypologieTypeEtape(p_pid,TYPELIGNE) like 'valide');

              IF counter>0 then
                 IF l_valeur_add || '^' = '^'
                   then
                     l_valeur_add := '''' ||l_groupe|| '''';
                  ELSE

              l_valeur_add :=l_valeur_add ||',' || '''' ||l_groupe|| '''';
                END IF;
              END IF;

              END LOOP;
         END IF;


        return l_valeur_add;
  END control;

     -- HMI - PPM 60709 : $5.3 : Verif parametrage DEFAULT existant
      FUNCTION controle_parametrage
      RETURN BOOLEAN
   IS
      l_presence   NUMBER;
   BEGIN
      BEGIN
        SELECT  count(*)
              INTO l_presence
                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip
                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O');
         IF (l_presence != 0)
         THEN
            RETURN TRUE;
         ELSE
            RETURN FALSE;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN FALSE;
      END;
   END controle_parametrage;

-- HMI - PPM 60709 - $5.3 - QC: 1774
Procedure parametrage_defaut(p_message OUT VARCHAR2) IS
parametrage_controle EXCEPTION;
 BEGIN

    p_message := '';

    IF NOT controle_parametrage
         THEN  RAISE parametrage_controle;

   ELSE
    p_message := '';

    END IF;

    EXCEPTION
      WHEN parametrage_controle
              THEN
            pack_global.recuperer_message (21299, NULL, NULL, NULL, p_message);
            raise_application_error (-20999, p_message);

end parametrage_defaut;
-- FIN HMI - PPM 60709 - $5.3 - QC: 1774

 --HMI - PPM 60709 : $5.3 : FUNCTION return 'valide' si a typologie du param jeux-T est compatible au contexte sinon return 'invalide'
Function verifTypologie(p_pid IN varchar2, p_valeur IN varchar2 ,  SEPARATEUR IN varchar2 )return varchar2

 IS
   l_typroj VARCHAR2 (1000);
   l_arctype VARCHAR2 (1000);
   l_valeur VARCHAR2 (1000);
   l_tab_code PACK_GLOBAL.t_array;
    l_groupe VARCHAR2 (1000);
    l_retour varchar2(600);
    temp varchar2(600);
    typologie VARCHAR2 (600);
   BEGIN
   l_retour := 'invalide';

   select TRIM(TYPPROJ), TRIM(ARCTYPE) into l_typroj,l_arctype from ligne_bip   where pid = p_pid;
    typologie := l_typroj||'_'||l_arctype;


  if p_valeur is null then

  l_retour := 'invalide';

  ELSE

  l_tab_code := PACK_GLOBAL.SPLIT (p_valeur, SEPARATEUR);



  FOR i IN 1 .. l_tab_code.count LOOP

      l_groupe := l_tab_code(i);


      if ( instr(l_groupe,'*') >0 ) then

               temp := substr(l_groupe,1,LENGTH(l_groupe)-1);
               --DBMS_OUTPUT.PUT_LINE(temp);
               if (INSTR(typologie,temp)>0) then



                        l_retour := 'valide';
                       exit;


               end if;
      else

               if ( TRIM(l_groupe) = l_typroj)  then



                    l_retour := 'valide';



                    exit;

               else
                  if (TRIM(l_groupe) = l_typroj||'_'||l_arctype) then


                        l_retour := 'valide';

                         exit;

                  else
                     l_retour := 'invalide';

                  end if;
               end if;

      end if;
      end loop;
    end if;

--DBMS_OUTPUT.PUT_LINE(l_retour);
     return l_retour;
   end verifTypologie;


 --HMI - PPM 60709 : $5.3 : FUNCTION return 'valide' si la typologie du type d'étapes est compatible à la typologie de la ligne en cours sinon return 'invalide'
Function verifTypologieTypeEtape(p_pid IN varchar2, p_valeur IN varchar2 )return varchar2
   IS
   l_typroj VARCHAR2 (1000);
   l_arctype VARCHAR2 (1000);
   l_valeur VARCHAR2 (1000);
   l_tab_code PACK_GLOBAL.t_array;
    l_groupe VARCHAR2 (1000);
    l_retour varchar2(600);
    temp varchar2(600);
    typologie VARCHAR2 (600);
   BEGIN
   l_retour := 'invalide';

   select TRIM(TYPPROJ), TRIM(ARCTYPE) into l_typroj,l_arctype from ligne_bip   where pid = p_pid;
    typologie := l_typroj||'_'||l_arctype;

  if p_valeur is null then   l_retour := 'valide';
  ELSE
  l_tab_code := PACK_GLOBAL.SPLIT (p_valeur, ',');



        FOR i IN 1 .. l_tab_code.count LOOP

          l_groupe := l_tab_code(i);


      if ( instr(l_groupe,'*') >0 ) then

           temp := substr(l_groupe,1,LENGTH(l_groupe)-1);
               if (INSTR(typologie,temp)>0) then
                        l_retour := 'valide';
                       exit;
              end if;
     else


         if ( TRIM(l_groupe) = l_typroj)  then


              l_retour := 'valide';
              exit;


         else



            if (TRIM(l_groupe) = l_typroj||'_'||l_arctype) then


                  l_retour := 'valide';
                   exit;

            else
               l_retour := 'invalide';

             end if;
        end if;
        end if;


     end loop;
    end if;

--DBMS_OUTPUT.PUT_LINE(l_retour);

     return l_retour;
   end verifTypologieTypeEtape;

 --HMI - PPM 60709 : $5.3 : FUNCTION return le jeu prioritaire du param jeux de la ligne en cours
  FUNCTION controle_prio(l_valeur IN VARCHAR2 ,  SEPARATEUR IN varchar2) return VARCHAR2
   IS

       l_tab_jeu PACK_GLOBAL.t_array;
       l_valeur_prio   VARCHAR2 (1000);


    BEGIN
         l_valeur_prio := '';

       IF l_valeur is not null then


       l_tab_jeu := PACK_GLOBAL.SPLIT (l_valeur, SEPARATEUR);

       l_valeur_prio := replace(l_tab_jeu(1),'''','');

       END IF;

        return l_valeur_prio;

   END controle_prio;

    --HMI - PPM 60709 : $5.3 : FUNCTION return le jeu prioritaire pour une direction donné
   FUNCTION get_jeu_prio(p_direction IN VARCHAR2, p_pid IN VARCHAR2) return VARCHAR2

   IS
    l_jeu_prio   VARCHAR2 (1000);
    l_valeur   VARCHAR2 (1000);

    l_valeur_add   VARCHAR2 (1000);

    l_separateur  VARCHAR2 (10);
    BEGIN
    l_jeu_prio := '';
            BEGIN
            SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR
            INTO l_valeur,l_separateur
              FROM ligne_param_bip
             WHERE code_action = 'TYPETAPES-JEUX'
               AND code_version = p_direction
               AND num_ligne = (SELECT MIN (num_ligne)
                                  FROM ligne_param_bip
                                 WHERE code_version = p_direction AND code_action = 'TYPETAPES-JEUX' AND actif = 'O')
                                  AND control(valeur,p_pid,SEPARATEUR) is not null;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN

              BEGIN
               SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR

                 INTO l_valeur,l_separateur
                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip
                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O')
                                     AND control(valeur,p_pid,SEPARATEUR) is not null;

           EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
           l_valeur := '';
           END;
  END;
   l_valeur_add := control(l_valeur,p_pid,l_separateur);


    IF l_valeur_add || '^' = '^'
   THEN

      BEGIN
               SELECT nvl2(valeur,''''||REPLACE (valeur, ',', ''',''') ||'''',null),SEPARATEUR
                 INTO l_valeur,l_separateur
                 FROM ligne_param_bip
                WHERE code_action = 'TYPETAPES-JEUX'
                  AND code_version = 'DEFAUT'
                  AND num_ligne = (SELECT MIN (num_ligne)
                                     FROM ligne_param_bip
                                    WHERE code_version = 'DEFAUT' AND code_action = 'TYPETAPES-JEUX' AND actif = 'O')
                                     AND control(valeur,p_pid,separateur) is not null;

           EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
           l_valeur := '';
           END;

         l_valeur_add := control(l_valeur,p_pid,l_separateur);
    END IF;

 l_jeu_prio := controle_prio(l_valeur_add,l_separateur);

  return l_jeu_prio;


 END get_jeu_prio;

END pack_isac_etape;
/