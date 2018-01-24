-- pack_ratt_bip PL/SQL
--
-- Equipe SOPRA
--
-- Creer le 24/03/1999
--
-- Objet : Permet le rattachement en masse des lignes bip à un code dossier
-- Tables : struct_info	(recherche du code DPG), bip_info (modif de 'CODSG'), message
--
-- Modifié le 31/03/2004 par PJO : MAJ PID sur 4 caractères
-- Modifié le 24/06/2005 par PPR : Gestion de REPARTITION_LIGNE
--

-- Attention le nom du package ne peut etre le nom
-- de la table...



create or replace
PACKAGE pack_ratt_bip AS

  TYPE Struct_info_ViewType IS RECORD (codsg      char(7),
                                       sigdep     struct_info.sigdep%TYPE,
                                       sigpole    struct_info.sigpole%TYPE,
                                       libdsg     struct_info.libdsg%TYPE,
                                       centractiv char(7),
                                       topfer     struct_info.topfer%TYPE,
                                       flaglock   struct_info.flaglock%TYPE
                                      );

   TYPE client_moCurType IS REF CURSOR RETURN client_mo%ROWTYPE;
   TYPE struct_infoCurType_Char IS REF CURSOR RETURN Struct_info_ViewType;
   TYPE ligne_bipCurType IS REF CURSOR RETURN ligne_bip%ROWTYPE;

   	PROCEDURE select_c_ratt_proj (	p_codsg          IN VARCHAR2,
                                 	p_userid         IN VARCHAR2,
                                 	p_curStruct_info IN OUT struct_infoCurType_Char,
                                 	p_nbcurseur         OUT INTEGER,
                                 	p_message           OUT VARCHAR2
                                	);

   	PROCEDURE select_m_ratt_proj (	p_clicode      IN client_mo.clicode%TYPE,
                                 	p_userid       IN VARCHAR2,
                                 	p_curClient_mo IN OUT client_moCurType,
                                 	p_nbcurseur       OUT INTEGER,
                                 	p_message         OUT VARCHAR2
                                	);

	PROCEDURE update_un_projet (p_cod      IN VARCHAR2,
                              p_pid     IN ligne_bip.pid%TYPE,
                              p_flaglock IN VARCHAR2,
                              p_table    IN VARCHAR2,
                              p_userid	 IN VARCHAR2,
                              p_compteur IN OUT INTEGER,
                              p_message  IN OUT VARCHAR2,
                              p_lignes_ratt IN OUT VARCHAR2, --PPM 59288
                              p_lignes_non_ratt IN OUT VARCHAR2, --PPM 59288
                              p_isDbs IN OUT BOOLEAN --PPM 59288
                             );

	PROCEDURE update_ratt_bip (p_table      IN  VARCHAR2,
                               p_cod        IN  VARCHAR2,
                               p_lib        IN  VARCHAR2,
                               p_pid_1      IN  ligne_bip.pid%TYPE,
                               p_flaglock_1 IN  VARCHAR2,
                               p_pid_2      IN  ligne_bip.pid%TYPE,
                               p_flaglock_2 IN  VARCHAR2,
                               p_pid_3      IN  ligne_bip.pid%TYPE,
                               p_flaglock_3 IN  VARCHAR2,
                               p_pid_4      IN  ligne_bip.pid%TYPE,
                               p_flaglock_4 IN  VARCHAR2,
                               p_pid_5      IN  ligne_bip.pid%TYPE,
                               p_flaglock_5 IN  VARCHAR2,
                               p_pid_6      IN  ligne_bip.pid%TYPE,
                               p_flaglock_6 IN  VARCHAR2,
                               p_userid     IN  VARCHAR2,
                               p_nbcurseur  OUT INTEGER,
                               p_message    OUT VARCHAR2
                              );

	PROCEDURE select_ratt_pid (p_dpcode	IN  VARCHAR2,
                               p_dplib	IN  VARCHAR2,
                               p_flaglock	IN VARCHAR2,
                               p_pid_1      IN  ligne_bip.pid%TYPE,
                               p_pid_2      IN  ligne_bip.pid%TYPE,
                               p_pid_3      IN  ligne_bip.pid%TYPE,
                               p_pid_4      IN  ligne_bip.pid%TYPE,
                               p_pid_5      IN  ligne_bip.pid%TYPE,
                               p_pid_6      IN  ligne_bip.pid%TYPE,
                               p_userid     IN  VARCHAR2,
                               p_curpid IN OUT ligne_bipCurType,
                               p_nbcurseur  OUT INTEGER,
                               p_message    OUT VARCHAR2
                              );

END pack_ratt_bip;
/


-- exec pack_ratt_bip_dpg.update_ratt_bip_dpg(10300,'AAA','P5000',1,'',null,'',null,
-- 'P6000',0,'',null,'',null,'msaade',:nb,:msg)
-- select icpi, ilibel, flaglock, codsg from bip_info;

 


   
create or replace
PACKAGE BODY pack_ratt_bip AS

  PROCEDURE select_c_ratt_proj (p_codsg           IN VARCHAR2,
                                p_userid          IN VARCHAR2,
                                p_curStruct_info  IN OUT struct_infoCurType_Char,
                                p_nbcurseur          OUT INTEGER,
                                p_message            OUT VARCHAR2
                              ) IS

	l_msg    VARCHAR2(1024);
      l_topfer struct_info.topfer%TYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- TEST codsg actif

      BEGIN
         SELECT topfer
         INTO   l_topfer
         FROM   struct_info
         WHERE  codsg = TO_NUMBER(p_codsg);

      EXCEPTION

        WHEN NO_DATA_FOUND THEN
            NULL;

        WHEN OTHERS THEN
           raise_application_error(-20997, SQLERRM);
      END;

      IF l_topfer != 'O' THEN
         pack_global.recuperer_message( 20252, '%s1', p_codsg, NULL, l_msg);
         raise_application_error( -20252, l_msg);
      END IF;

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN   p_curStruct_info FOR
              SELECT codsg,
                     sigdep,
                     sigpole,
                     libdsg,
                     TO_CHAR(centractiv),
                     topfer,
                     flaglock
              FROM   struct_info
              WHERE  codsg = TO_NUMBER(p_codsg)
              AND    topfer = 'O';

      EXCEPTION

         WHEN OTHERS THEN
            raise_application_error( -20997,SQLERRM);
      END;

      -- en cas absence
	-- 'Code Département/Pôle/Groupe p_codsg inexistant'

	pack_global.recuperer_message( 2064, '%s1', p_codsg, NULL, l_msg);
	p_message := l_msg;

   END select_c_ratt_proj;


   PROCEDURE select_m_ratt_proj(p_clicode       IN client_mo.clicode%TYPE,
                                p_userid   	IN VARCHAR2,
                                p_curClient_mo  IN OUT client_moCurType,
                                p_nbcurseur       OUT INTEGER,
                                p_message         OUT VARCHAR2
                               ) IS
	l_msg     VARCHAR2(1024);
      	l_clitopf client_mo.clitopf%TYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- TEST clicode actif

      BEGIN

         SELECT clitopf
         INTO   l_clitopf
         FROM   client_mo
         WHERE  LTRIM(RTRIM(clicode)) = p_clicode;

      EXCEPTION

        WHEN NO_DATA_FOUND THEN
          NULL;

        WHEN OTHERS THEN
           raise_application_error(-20997, SQLERRM);
      END;

      IF (l_clitopf != 'O') AND (l_clitopf IS NOT NULL) THEN
         pack_global.recuperer_message( 20253, '%s1', p_clicode, NULL, l_msg);
         raise_application_error( -20253, l_msg);
      END IF;

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *


      BEGIN

         OPEN p_curClient_mo FOR
              SELECT *
              FROM client_mo
              WHERE LTRIM(RTRIM(clicode)) = LTRIM(RTRIM(p_clicode));

      EXCEPTION

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);

      END;

        -- en cas absence
	-- p_message := 'Code Client absent';
	pack_global.recuperer_message( 4, '%s1', p_clicode, NULL, l_msg);
	p_message := l_msg;

   END select_m_ratt_proj;



  PROCEDURE update_un_projet (p_cod      IN VARCHAR2,
                              p_pid      IN ligne_bip.pid%TYPE,
                              p_flaglock IN VARCHAR2,
                              p_table    IN VARCHAR2,
                              p_userid	 IN VARCHAR2,
                              p_compteur IN OUT INTEGER,
                              p_message  IN OUT VARCHAR2,
                              p_lignes_ratt IN OUT VARCHAR2,
                              p_lignes_non_ratt IN OUT VARCHAR2,
                              p_isDbs IN OUT BOOLEAN
                             ) IS
   CODCAMO_MULTI	VARCHAR2(6) := '77777';
   l_user		ligne_bip_logs.user_log%TYPE;
   -- Valeurs précédentes pour les logs
   l_codcamo		ligne_bip.codcamo%TYPE;
   -- Date de début d'exercice
   l_datdeb		repartition_ligne.datdeb%TYPE;
   l_test 		CHAR(1) ; -- utilisée dans un test d'existance
   l_dirprin NUMBER;--PPM 59288
   l_arctype VARCHAR2(3);--PPM 59288
   p_messages VARCHAR2(500);--PPM 59288
   l_dpcode ligne_bip.dpcode%TYPE; --PPM 59288 : Valeurs précédentes pour les logs
   BEGIN

      --Initialisations
      l_dpcode := '';--PPM 59288
      l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);
      IF p_table = 'DPG' THEN
         BEGIN
            UPDATE ligne_bip
            SET codsg    = TO_NUMBER(p_cod),
                flaglock = decode( TO_NUMBER(p_flaglock), 1000000, 0, p_flaglock + 1)
            WHERE pid    = p_pid
            AND flaglock = p_flaglock;

         EXCEPTION

            WHEN OTHERS THEN
                raise_application_error(-20997, SQLERRM);
         END;

      ELSIF p_table = 'CAMO' THEN
         BEGIN
            -- On récupère les valeurs précédentes pour les logs
            SELECT codcamo
            INTO l_codcamo
            FROM ligne_bip
            WHERE pid = p_pid
            AND flaglock = p_flaglock;

            UPDATE ligne_bip
            SET codcamo = TO_NUMBER(p_cod),
                flaglock = decode( TO_NUMBER(p_flaglock), 1000000, 0, p_flaglock + 1)
            WHERE pid   = p_pid
            AND flaglock = p_flaglock;

	    -- Si le CA saisit correspond avec le code de multi_facturation,
	    -- On saisit l'ancien CA dans la table repartition_ligne avec un taux de 100%
	    IF ((p_cod=CODCAMO_MULTI) AND (l_codcamo != CODCAMO_MULTI)) THEN
	  	SELECT ADD_MONTHS(datdebex, -1) INTO l_datdeb FROM datdebex WHERE ROWNUM<2;

	         --
	         -- Vérifie qu'il n'existe pas déjà des lignes dans répartition ligne

	         --
	         BEGIN
	            SELECT distinct '1' into l_test
	            FROM REPARTITION_LIGNE
	            WHERE PID = p_pid;


	         EXCEPTION
	            WHEN NO_DATA_FOUND THEN
	      	  	-- Insère une première répartition
		  	INSERT INTO repartition_ligne
		  	       (pid, codcamo, tauxrep, datdeb)
		  	VALUES (p_pid, l_codcamo, 100, l_datdeb);

	            WHEN OTHERS THEN
	               raise_application_error( -20997, SQLERRM);

	          END;
	    END IF;

	    pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'CA payeur', TO_CHAR(l_codcamo), p_cod, 'Modification du CA Payeur via Lien CA MO');
         EXCEPTION
	    WHEN NO_DATA_FOUND THEN
	    	-- Pas de problème on ne fait rien : C'est une ligne inexistante
	    	l_codcamo := 0;
            WHEN OTHERS THEN
                raise_application_error(-20997, SQLERRM);
         END;

      ELSIF p_table = 'DP' THEN




      -- On récupère les valeurs précédentes pour les logs
        BEGIN
            SELECT dpcode
            INTO l_dpcode
            FROM ligne_bip
            WHERE pid = p_pid
            AND flaglock = p_flaglock;

          EXCEPTION
	            WHEN NO_DATA_FOUND THEN
              l_dpcode :='';
        END;
          --PPM 59288 : SI la Direction attachée au DP autorise l'élargissement
          IF ( p_isDbs = FALSE )
          THEN
          --alors autoriser la mise à jour de toute ligne Bip saisie, en gardant les contrôles existants sur la ligne
             BEGIN
                UPDATE ligne_bip
                SET dpcode  = TO_NUMBER(p_cod),
                    flaglock = decode( TO_NUMBER(p_flaglock), 1000000, 0, p_flaglock + 1)
                WHERE pid   = p_pid
                AND flaglock = p_flaglock;
             EXCEPTION

                WHEN OTHERS THEN
                    raise_application_error(-20997, SQLERRM);
             END;
         -- on garde une traçabilité du DP modifié
         pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'DPCODE', TO_CHAR(l_dpcode), p_cod, 'MAJ du dossier projet');
         --on mémorise les lignes rattachées au DP
         p_lignes_ratt := p_lignes_ratt || p_pid || ', ';
     --PPM 59288 :debut
     --SINON (la Direction attachée au DP n'autorise pas l'élargissement),
     --garder les contrôles existants sur la ligne, mais ne pas mettre à jour une ligne autre que GT1.
         ELSE
           BEGIN
            SELECT arctype into l_arctype
            FROM ligne_bip
            WHERE pid = p_pid;
          EXCEPTION


            WHEN NO_DATA_FOUND
            THEN
             raise_application_error(-20997, SQLERRM);
          END;

          IF (l_arctype = 'T1') THEN
            BEGIN
                UPDATE ligne_bip
                SET dpcode  = TO_NUMBER(p_cod),
                    flaglock = decode( TO_NUMBER(p_flaglock), 1000000, 0, p_flaglock + 1)
                WHERE pid   = p_pid
                AND flaglock = p_flaglock;
            EXCEPTION
                WHEN OTHERS THEN
                    raise_application_error(-20997, SQLERRM);

              END;
          -- on garde une traçabilité du DP modifié
          pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'DPCODE', TO_CHAR(l_dpcode), p_cod, 'MAJ du dossier projet');
          --on mémorise les lignes rattachées au DP
          p_lignes_ratt := p_lignes_ratt || p_pid || ', ';
           ELSE
           --on mémorise les lignes non rattachées au DP
           p_lignes_non_ratt := p_lignes_non_ratt || p_pid || ', ';
          END IF;
         END IF;

     --PPM 59288 : fin
      ELSIF p_table = 'MO' THEN
         BEGIN
            UPDATE ligne_bip
            SET clicode  = p_cod,
                flaglock = decode( TO_NUMBER(p_flaglock), 1000000, 0, p_flaglock + 1)
            WHERE pid    = p_pid
            AND flaglock = p_flaglock;

         EXCEPTION

            WHEN OTHERS THEN
                raise_application_error(-20997, SQLERRM);
         END;


	  ELSIF p_table = 'CP' THEN
         BEGIN
            UPDATE ligne_bip
            SET pcpi  = TO_NUMBER(p_cod),
                flaglock = decode( TO_NUMBER(p_flaglock), 1000000, 0, p_flaglock + 1)
            WHERE pid   = p_pid
            AND flaglock = p_flaglock;

         EXCEPTION

            WHEN OTHERS THEN
                raise_application_error(-20997, SQLERRM);
         END;

      END IF;

      IF SQL%NOTFOUND THEN

         -- Rollback car on ne connait pas quel update ne marche pas

         ROLLBACK;

      ELSE


         COMMIT;
         p_compteur := p_compteur + 1;
         p_message := REPLACE( p_message, '%s1', p_pid||'   %s1' );

      END IF;

   END update_un_projet;


    PROCEDURE update_ratt_bip (p_table      IN  VARCHAR2,
                               p_cod        IN  VARCHAR2,
                               p_lib        IN  VARCHAR2,
                               p_pid_1      IN  ligne_bip.pid%TYPE,
                               p_flaglock_1 IN  VARCHAR2,
                               p_pid_2      IN  ligne_bip.pid%TYPE,
                               p_flaglock_2 IN  VARCHAR2,
                               p_pid_3      IN  ligne_bip.pid%TYPE,
                               p_flaglock_3 IN  VARCHAR2,
                               p_pid_4      IN  ligne_bip.pid%TYPE,
                               p_flaglock_4 IN  VARCHAR2,
                               p_pid_5      IN  ligne_bip.pid%TYPE,
                               p_flaglock_5 IN  VARCHAR2,
                               p_pid_6      IN  ligne_bip.pid%TYPE,
                               p_flaglock_6 IN  VARCHAR2,
                               p_userid     IN  VARCHAR2,
                               p_nbcurseur  OUT INTEGER,
                               p_message    OUT VARCHAR2
                              ) IS

      l_msg VARCHAR2(1024);
      l_total INTEGER := 0;
      l_lignes_ratt VARCHAR2(1024);--PPM 59288
      l_lignes_non_ratt VARCHAR2(1024);-- PPM 59288
      l_msg2 VARCHAR2(500);--PPM 59288
      l_message VARCHAR2(500);--PPM 59288
      l_dirprin NUMBER;--PPM 59288
      l_autoris_elargis BOOLEAN;--PPM 61695
      l_isDbs BOOLEAN;--PPM 59288
   BEGIN

     -- Positionner le nb de curseurs ==> 0
     -- Initialiser le message retour

     p_nbcurseur := 0;
     p_message := '';
     l_lignes_ratt := '';--PPM 59288
     l_lignes_non_ratt :='';--PPM 59288
     l_dirprin := null;

     -- Recuperer le message parametre

     IF p_table = 'DPG' THEN
         pack_global.recuperer_message( 2057, '%s2', p_cod, NULL, l_msg);
     ELSIF p_table = 'MO' THEN
         pack_global.recuperer_message( 2058, '%s2', p_cod, NULL, l_msg);
     ELSIF p_table = 'CAMO' THEN
         pack_global.recuperer_message( 2059, '%s2', p_cod, NULL, l_msg);
     ELSIF p_table = 'DP' THEN
         pack_global.recuperer_message( 21285, '%s2', p_cod, NULL, l_msg);--PPM 59288 : modification du message 2060 par 21285

         --PPM 59288 :debut requete pour savoir si la direction attachée au DP autorise l'élargissement ou pas
         -- un seul appel ici est suffisant
          BEGIN
            SELECT dirprin into l_dirprin
            FROM dossier_projet
            WHERE dpcode = TO_NUMBER(p_cod);
          EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
             raise_application_error(-20997, SQLERRM);
          END;
          --PPM 59288 : SI la Direction attachée au DP autorise l'élargissement
           --PPM 61695 l_isDbs := PACK_DOSSIER_PROJET.is_obligation_dbs(l_dirprin, l_message);
         
          l_autoris_elargis :=not PACK_DOSSIER_PROJET.is_autoris_elargis(l_dirprin, p_message);
          -- l_isDbs : variable à ajouter dans les paramètres de update_un_projet()
         -- PPM 59288 : fin

     ELSIF p_table = 'CP' THEN
         pack_global.recuperer_message( 21016, '%s2', p_cod, NULL, l_msg);
     END IF;

     -- 1er traitement

  IF p_pid_1 is not null THEN --PPM 59288
     update_un_projet( p_cod, p_pid_1, p_flaglock_1, p_table, p_userid, l_total, l_msg, l_lignes_ratt, l_lignes_non_ratt, l_autoris_elargis);--PPM 59288
  END IF;

     -- 2e traitement

  IF p_pid_2 is not null THEN
     update_un_projet( p_cod, p_pid_2, p_flaglock_2, p_table, p_userid, l_total, l_msg, l_lignes_ratt, l_lignes_non_ratt, l_autoris_elargis);

  END IF;
     -- 3e traitement

  IF p_pid_3 is not null THEN
     update_un_projet( p_cod, p_pid_3, p_flaglock_3, p_table, p_userid, l_total, l_msg, l_lignes_ratt, l_lignes_non_ratt, l_autoris_elargis);

  END IF;
     -- 4e traitement

  IF p_pid_4 is not null THEN
     update_un_projet( p_cod, p_pid_4, p_flaglock_4, p_table, p_userid, l_total, l_msg, l_lignes_ratt, l_lignes_non_ratt, l_autoris_elargis);

  END IF;
     -- 5e traitement

  IF p_pid_5 is not null THEN
     update_un_projet( p_cod, p_pid_5, p_flaglock_5, p_table, p_userid, l_total, l_msg, l_lignes_ratt, l_lignes_non_ratt, l_autoris_elargis);

  END IF;
     -- 6er traitement

  IF p_pid_6 is not null THEN
     update_un_projet( p_cod, p_pid_6, p_flaglock_6, p_table, p_userid, l_total, l_msg, l_lignes_ratt, l_lignes_non_ratt, l_autoris_elargis);

  END IF;
     IF l_total > 0 THEN

     IF p_table = 'DP' THEN
        --Si aucune ligne Bip saisie n'a pu être validée
        IF NVL(l_lignes_ratt,'^') = '^' AND NVL(l_lignes_non_ratt,'^') <> '^' THEN
         pack_global.recuperer_message( 21287, '%s2', p_cod, NULL, l_msg);--PPM 59288 : Rattachement NON effectué
         p_message := REPLACE( l_msg, '%s1', l_lignes_non_ratt );
         --Si au moins 1 ligne a été correctement rattachée (pas de lignes non rattachées)
        ELSIF NVL(l_lignes_ratt,'^') <> '^' AND NVL(l_lignes_non_ratt,'^') = '^' THEN
         pack_global.recuperer_message( 21285, '%s2', p_cod, NULL, l_msg);--PPM 59288 Rattachement des lignes effectué
         p_message := REPLACE( l_msg, '%s1', l_lignes_ratt );
        --Si au moins 1 ligne a été correctement rattachée et s'il y a des lignes non rattachées
        ELSIF NVL(l_lignes_ratt,'^') <> '^' AND NVL(l_lignes_non_ratt,'^') <> '^' THEN
         pack_global.recuperer_message( 21285, '%s2', p_cod, NULL, l_msg);--PPM 59288 Rattachement des lignes effectué
         p_message := REPLACE( l_msg, '%s1', l_lignes_ratt );

         pack_global.recuperer_message( 21286, '%s2', p_cod, NULL, l_msg2);--PPM 59288 Rattachement des lignes NON effectué
         l_message := REPLACE( l_msg2, '%s1', l_lignes_non_ratt );
         p_message := p_message || '\n' || l_message;
        ELSE
        --p_message := REPLACE( l_msg, '%s1', NULL );--en garde les contrôles existants sur la ligne
         pack_global.recuperer_message( 21285, '%s2', p_cod, NULL, l_msg);--PPM 59288 Rattachement des lignes effectué
         p_message := REPLACE( l_msg, '%s1', l_lignes_ratt );
        END IF;
         p_message := REPLACE( p_message, ',  ', ' ' );--on remplace la dernière virgule par espace
        --PPM 59288 : Fin
      ELSE

        p_message := REPLACE( l_msg, '%s1', NULL );

      END IF;

     ELSE

        pack_global.recuperer_message( 2061, '%s1', p_cod, NULL, l_msg);
        p_message := l_msg;

     END IF;

  END update_ratt_bip;


PROCEDURE select_ratt_pid (    p_dpcode     IN  VARCHAR2,
                               p_dplib      IN  VARCHAR2,
                               p_flaglock   IN  VARCHAR2,
                               p_pid_1      IN  ligne_bip.pid%TYPE,
                               p_pid_2      IN  ligne_bip.pid%TYPE,
                               p_pid_3      IN  ligne_bip.pid%TYPE,
                               p_pid_4      IN  ligne_bip.pid%TYPE,
                               p_pid_5      IN  ligne_bip.pid%TYPE,
                               p_pid_6      IN  ligne_bip.pid%TYPE,
                               p_userid     IN  VARCHAR2,
                               p_curpid IN OUT ligne_bipCurType,
                               p_nbcurseur  OUT INTEGER,
                               p_message    OUT VARCHAR2
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
       --pid,pnom,flaglock
      BEGIN
         OPEN p_curpid FOR
              SELECT * --pid,pnom,flaglock
              FROM LIGNE_BIP
              WHERE pid = p_pid_1
              UNION
              SELECT * -- pid,pnom,flaglock
              FROM LIGNE_BIP
              WHERE pid = p_pid_2
              UNION
              SELECT * --pid,pnom,flaglock
              FROM LIGNE_BIP
              WHERE pid = p_pid_3
              UNION
              SELECT * --pid,pnom,flaglock
              FROM LIGNE_BIP
              WHERE pid = p_pid_4
              UNION
              SELECT * --pid,pnom,flaglock
              FROM LIGNE_BIP
              WHERE pid = p_pid_5
              UNION
              SELECT * --pid,pnom,flaglock
              FROM LIGNE_BIP
              WHERE pid = p_pid_6

              ;

      EXCEPTION
         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;
      -- en cas absence
      -- p_message := '';
      pack_global.recuperer_message( 20504, '%s1', p_pid_1, NULL, l_msg);
      p_message := l_msg;
/*
var nbcurs number
var mess varchar2(1024)
var c refcursor
 exec PACK_RATT_BIP.SELECT_RATT_PID('50011','MARKETING ETUDES','0','BP5','MMC','GAY','A24','JFY
','NBK','A173818;dirmenu;15456;0270000;01 ;03140270000,03140250000;15456,14532;16;00677;1',:c,:nbcur
s,:mess);
*/
END select_ratt_pid;


END pack_ratt_bip;
/

