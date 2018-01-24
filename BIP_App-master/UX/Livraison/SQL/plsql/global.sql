-- pack_global PL/SQL
--
-- Equipe SOPRA
--
-- Créé le 01/12/1998
--
-- Modifié le 11/03/1999
--
--         * Création des procédures surchargées RECUPERER_MESSAGE
--
-- Modifié le 18/03/1999
--
--         * Création du record GLOBAL_DATA
--         * Création de la fonction LIRE_GLOBALDATA
--
-- Modifié le 22/03/1999
--         * Intégration en provenance du pack LIGNE_BIP
--           de la fonction verifier_habilitation
-- 
-- Modifié le 04/10/1999
--         * Création de procédure permettant d'ecrire dans
--           un fichier
--
-- Modifié le 07/10/1999
--         * Ajout de FILCODE dans le record GlobalData
--           pour la fonction Lire_GlobalData
--
-- Modifié le 02/12/1999
--          * le flush de la procédure d'écriture dans un 
--            fichier est déplacé vers la procédure de fermeture
--            du handle
--
--   	   le 18/02/2000
--	    * ajout de codperime, codperimo et codcfrais
--
-- Modifié le 26/05/2003 par Pierre JOSSE
--		Migration RTFE
-- 		* Suppression de la table USERBIP
--		* Suppression des notions de code périmètres ME et MO
--		  Ils sont remplacés par les périmètres explicites(liste de codes BDDPG/CliCode)
--		* Suppression du paramètre imprimante
--
-- Modifié le 12/06/2003 par Pierre JOSSE
-- 		Ajout de la variable export_sms.
--
-- Modifié le 23/06/2003 par Pierre JOSSE
--		Ajout d'une fonction qui retourne le perimetre ME lire_perime
--		(Dans les reports, la fonction lire_globaldata ne fonctionne pas)
--
-- Modifié le 23/07/2003 par Pierre JOSSE
--		Ajout d'une fonction qui retourne export_sms lire_export_sms
--		(Dans les reports, la fonction lire_globaldata ne fonctionne pas)
-- Modifié le 11/04/2005 par Pascal PRIGENT
--		remplacement de DIRMENU par DIR 
-- Modifié le 11/04/2005 par Pascal PRIGENT
--		Ajout des sous menus dans le record GlobalData
--
-- Modifié le 29/09/2005 par David DEDIEU
--		Ajout d'une fonction qui retourne le perimetre MO lire_perimo
--		(Dans les reports, la fonction lire_globaldata ne fonctionne pas)
-- Modifié le 26/01/2006 par BAA
--		augmentation de la taille de la variable chefprojet de 255 à 600 caractéré
-- Modifié le 06/10/2009 par YNI
--		Ajout de la fonction verifier_habilitation_2 et son Intégration en provenance du pack pack_gestbudg
-- Modifié le 15/10/2009 par YSB
--		modification  de la fonction lire_globaldata : ajout du ca da
-- 		ajout de la fonction lire_ca_da
--      ajout de la fonction recherche_niveau
-- Modifié le 27/10/2009 par YSB
--      modification  de la fonction lire_globaldata : ajout du ca da
-- Modifié le 08/01/2010 par YSB
--      modification  de la fonction lire_globaldata : ajout de la liste des menus et ca_suivi
-- 18/05/2010 ABA FICHE 1006
-- 15/06/2010 ABA fiche 1010
-- ABA Fiche 916 24/01/2011
--
-- Modifié le 29/04/2011 par CMA Fiche 1159 ajout de la function split
-- Modifié le 06/05/2011 par CMA Fiche 1176 ajout du Perim_MCLI
-- Modifié le 02/01/2012 par OEL Fiche 1329 Augmentation de la zone de récupération pour les habilitation des dossier Projet/Projets
--***********************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
--------------------------------------------------------
--  DDL for Package PACK_GLOBAL
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_GLOBAL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PACK_GLOBAL" AS

    TYPE GlobalData IS RECORD( idarpege   VARCHAR2(255),
                              menutil    VARCHAR2(25),
                              codpole    VARCHAR2(25),
                              direction1 client_mo.clicode%TYPE,
                              filcode    filiale_cli.filcode%TYPE,
			      perime     VARCHAR2(1000),
			      perimo     VARCHAR2(1000),
			      codcfrais  NUMBER(3),
			      chefprojet VARCHAR2(6000),--PPM 63485 : augmenter la taille à 4000
			      doss_proj	 VARCHAR2(5000),
			      appli	 VARCHAR2(255),
			      projet	 VARCHAR2(5000),
                  ca_fi     VARCHAR2(5000),
                  ca_payeur     VARCHAR2(5000),
                  sousmenus  VARCHAR2(255),
                  ca_da     VARCHAR2(5000),
                  listemenus VARCHAR2(255),
                  ca_suivi     VARCHAR2(5000),
                  perimcli  VARCHAR2(5000)
                             );

   FUNCTION lire_globaldata( p_string varchar2) RETURN GlobalData;

   FUNCTION lire_perime		(p_global VARCHAR2) RETURN VARCHAR2;

   FUNCTION lire_perimo		(p_global VARCHAR2) RETURN VARCHAR2;

   FUNCTION lire_perimcli	(p_global VARCHAR2) RETURN VARCHAR2;

   FUNCTION lire_doss_proj	(p_global VARCHAR2) RETURN VARCHAR2;

   FUNCTION lire_appli		(p_global VARCHAR2) RETURN VARCHAR2;

   FUNCTION lire_projet		(p_global VARCHAR2) RETURN VARCHAR2;

   FUNCTION lire_ca_fi		(p_global VARCHAR2) RETURN VARCHAR2;

   FUNCTION lire_ca_payeur	(p_global VARCHAR2) RETURN VARCHAR2;

   FUNCTION lire_ca_da	(p_global VARCHAR2) RETURN VARCHAR2;

   FUNCTION lire_ca_suivi	(p_global VARCHAR2) RETURN VARCHAR2;

   FUNCTION lire_menutil	(p_global VARCHAR2) RETURN VARCHAR2;

   FUNCTION verifier_habilitation ( p_global  IN VARCHAR2,
                                    p_codsg   IN VARCHAR2,
                                    p_libelle IN VARCHAR2,
                                    p_focus   IN VARCHAR2
                                  ) RETURN INTEGER;

   FUNCTION verifier_habilitation_2 ( p_global  IN VARCHAR2,
                                    p_codsg   IN VARCHAR2,
                                    p_clicode   IN VARCHAR2,
                                    p_pid IN VARCHAR2,
                                    p_libelle IN VARCHAR2,
                                    p_focus   IN VARCHAR2
                                  ) RETURN INTEGER;


   PROCEDURE recuperation_integrite ( p_code IN NUMBER );

   PROCEDURE recuperer_message( p_id_msg        IN NUMBER,
                                p_tag           IN VARCHAR2,
                                p_replace_value IN VARCHAR2,
				p_focus         IN VARCHAR2,
	                        p_msg           OUT VARCHAR2);

   PROCEDURE recuperer_message( p_id_msg         IN NUMBER,
                                p_tag1           IN VARCHAR2,
                                p_replace_value1 IN VARCHAR2,
                                p_tag2           IN VARCHAR2,
                                p_replace_value2 IN VARCHAR2,
				p_focus          IN VARCHAR2,
	                        p_msg            OUT VARCHAR2);

   PROCEDURE recuperer_message( p_id_msg         IN NUMBER,
                                p_tag1           IN VARCHAR2,
                                p_replace_value1 IN VARCHAR2,
                                p_tag2           IN VARCHAR2,
                                p_replace_value2 IN VARCHAR2,
                                p_tag3           IN VARCHAR2,
                                p_replace_value3 IN VARCHAR2,
				p_focus          IN VARCHAR2,
	                        p_msg            OUT VARCHAR2);

   -- Initialisation du fichier en sortie si existe alors REPLACE
   --                                     sinon CREATE

   PROCEDURE init_write_file ( p_dirname IN VARCHAR2,
                               p_filename IN VARCHAR2,
                               p_hfile OUT UTL_FILE.FILE_TYPE);

   -- Ecriture d'une chaine de caractère dans un fichier

   PROCEDURE write_string ( p_hfile IN UTL_FILE.FILE_TYPE,
                            p_string IN VARCHAR2);

   -- Fermeture du fichier

   PROCEDURE close_write_file ( p_hfile IN OUT UTL_FILE.FILE_TYPE);

   -- --fonction qui récupère le niveau du centre d'activité

   FUNCTION recherche_niveau(p_codcamo IN varchar2)
    RETURN NUMBER;

    TYPE t_array IS TABLE OF VARCHAR2(6000)--PPM 63485 : augmenter la taille à 4000
   INDEX BY BINARY_INTEGER;


    FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array;

--PPM 61776 : début
TYPE ident_table IS TABLE of VARCHAR2(10);

PROCEDURE lire_liste_chefs_projet(p_listeCodeRess IN VARCHAR2, p_listeCp OUT VARCHAR2);

FUNCTION get_liste_chefs_projet( p_listeCodeRess IN VARCHAR2) RETURN VARCHAR2;

--Fin PPM 61776
--PPM 62551 : début
   FUNCTION lpad_liste(p_liste IN VARCHAR2 ) RETURN VARCHAR2;
--PPM 62551 : fin

END pack_global;
/
--------------------------------------------------------
--  DDL for Package Body PACK_GLOBAL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PACK_GLOBAL" AS

   FUNCTION lire_globaldata( p_string varchar2) RETURN GlobalData IS

      glob_rec  GlobalData;
      pos1   integer;
      pos2   integer;
      pos3   integer;
      pos4   integer;
      pos5   integer;
      pos6   integer;
      pos7   integer;
      pos8   integer;
      pos9   integer;
      pos10  integer;
      pos11  integer;
      pos12  integer;
      pos13  integer;
      pos14  integer;
      pos15  integer;
      pos16  integer;
      pos17  integer;
      pos18  integer;
      lgth   integer;

   BEGIN


      pos1 := INSTR( p_string, ';', 1, 1);

      pos2 := INSTR( p_string, ';', 1, 2);

      pos3 := INSTR( p_string, ';', 1, 3);

      pos4 := INSTR( p_string, ';', 1, 4);

      pos5 := INSTR( p_string, ';', 1, 5);

      pos6 := INSTR( p_string, ';', 1, 6);

      pos7 := INSTR( p_string, ';', 1, 7);

      pos8 := INSTR( p_string, ';', 1, 8);

      pos9 := INSTR( p_string, ';', 1, 9);

      pos10:= INSTR( p_string, ';', 1,10);

      pos11:= INSTR( p_string, ';', 1,11);

      pos12:= INSTR( p_string, ';', 1,12);

      pos13:= INSTR( p_string, ';', 1,13);

      pos14:= INSTR( p_string, ';', 1,14);

      pos15:= INSTR( p_string, ';', 1,15);

      pos16:= INSTR( p_string, ';', 1,16);

      pos17:= INSTR( p_string, ';', 1,17);

      pos18:= INSTR( p_string, ';', 1,18);

      lgth := LENGTH( p_string);


      	glob_rec.idarpege   	:= substr( p_string, 1, pos1-1);

      	glob_rec.menutil    	:= UPPER(substr( p_string, pos1+1, pos2-pos1-1));

      	glob_rec.direction1 	:= substr( p_string, pos2+1, pos3-pos2-1);

      	glob_rec.codpole    	:= substr( p_string, pos3+1, pos4-pos3-1);

      	glob_rec.filcode    	:= substr( p_string, pos4+1, pos5-pos4-1);

  	glob_rec.perime   	:= substr( p_string, pos5+1, pos6-pos5-1);

      	glob_rec.perimo   	:= substr( p_string, pos6+1, pos7-pos6-1);

        glob_rec.codcfrais   	:= to_number(substr( p_string, pos7+1, pos8-pos7-1));

      	glob_rec.chefprojet   	:= substr( p_string, pos8+1, pos9-pos8-1);
       --KRA PPM 61776
       -- if INSTR(glob_rec.chefprojet,'*') >0 then
        glob_rec.chefprojet :=pack_global.get_liste_chefs_projet(glob_rec.chefprojet);
     --   end if;
        --Fin KRA 61776

      	glob_rec.doss_proj   	:= substr( p_string, pos9+1, pos10-pos9-1);

	glob_rec.appli   	:= substr( p_string, pos10+1, pos11-pos10-1);

	glob_rec.projet   	:= substr( p_string, pos11+1, pos12-pos11-1);

	glob_rec.ca_fi   	:= substr( p_string, pos12+1, pos13-pos12-1);

	glob_rec.ca_payeur   	:= substr( p_string, pos13+1, pos14-pos13-1);

      	glob_rec.sousmenus   	:= substr( p_string, pos14+1, pos15-pos14-1);

        glob_rec.ca_da       := substr( p_string, pos15+1, pos16-pos15-1);

        glob_rec.listemenus       := substr( p_string, pos16+1, pos17-pos16-1);

        glob_rec.ca_suivi       := substr( p_string, pos17+1, pos18-pos17-1);

        glob_rec.perimcli    := substr(p_string, pos18+1, lgth-pos18);

      RETURN glob_rec;

   END lire_globaldata;


   FUNCTION lire_perime(p_global VARCHAR2) RETURN VARCHAR2 IS
     BEGIN
   	RETURN pack_global.lire_globaldata(p_global).perime;
   END lire_perime;

   FUNCTION lire_perimo(p_global VARCHAR2) RETURN VARCHAR2 IS
     BEGIN
   	RETURN pack_global.lire_globaldata(p_global).perimo;
   END lire_perimo;

   FUNCTION lire_perimcli(p_global VARCHAR2) RETURN VARCHAR2 IS
     BEGIN
   	RETURN pack_global.lire_globaldata(p_global).perimcli;
   END lire_perimcli;

   FUNCTION lire_doss_proj(p_global VARCHAR2) RETURN VARCHAR2 IS
     BEGIN
   	RETURN pack_global.lire_globaldata(p_global).doss_proj;
   END lire_doss_proj;

   FUNCTION lire_appli(p_global VARCHAR2) RETURN VARCHAR2 IS
     BEGIN
   	RETURN pack_global.lire_globaldata(p_global).appli;
   END lire_appli;

   FUNCTION lire_projet(p_global VARCHAR2) RETURN VARCHAR2 IS
     BEGIN
   	RETURN pack_global.lire_globaldata(p_global).projet;
   END lire_projet;

   FUNCTION lire_ca_fi(p_global VARCHAR2) RETURN VARCHAR2 IS
     BEGIN
   	RETURN pack_global.lire_globaldata(p_global).ca_fi;
   END lire_ca_fi;

   FUNCTION lire_ca_payeur(p_global VARCHAR2) RETURN VARCHAR2 IS
     BEGIN
   	RETURN pack_global.lire_globaldata(p_global).ca_payeur;
   END lire_ca_payeur;

   FUNCTION lire_ca_da(p_global VARCHAR2) RETURN VARCHAR2 IS
     BEGIN
   	RETURN pack_global.lire_globaldata(p_global).ca_da;
   END lire_ca_da;

   FUNCTION lire_ca_suivi(p_global VARCHAR2) RETURN VARCHAR2 IS
     BEGIN
   	RETURN pack_global.lire_globaldata(p_global).ca_suivi;
   END lire_ca_suivi;

   FUNCTION lire_menutil(p_global VARCHAR2) RETURN VARCHAR2 IS
     BEGIN
   	RETURN pack_global.lire_globaldata(p_global).menutil;
   END lire_menutil;

   FUNCTION verifier_habilitation ( p_global  IN VARCHAR2,
                                    p_codsg   IN VARCHAR2,
                                    p_libelle IN VARCHAR2,
                                    p_focus   IN VARCHAR2
                                  )
                              RETURN INTEGER IS
      msg VARCHAR(1024);
      l_codpole VARCHAR2(25);
      l_menutil VARCHAR2(255);

   BEGIN

      l_codpole := LPAD(pack_global.lire_globaldata( p_global).codpole, 7, '0');
      l_menutil := pack_global.lire_globaldata( p_global).menutil;

      IF l_codpole IS NULL THEN
         IF l_menutil != 'DIR' AND
            l_menutil != 'ME' THEN
            pack_global.recuperer_message( 20274, NULL, NULL, NULL, msg);
            raise_application_error( -20274, msg );
         END IF;
      END IF;

      IF ( SUBSTR( l_codpole, 1, 3) != SUBSTR(LPAD(p_codsg, 7, '0'), 1, 3)
           AND SUBSTR( l_codpole, 1, 3) != '000' ) THEN

         -- Departement invalide

         pack_global.recuperer_message( 20012, '%s1', p_libelle, '%s2',
                                        SUBSTR(l_codpole, 1, 3),
                                        p_focus, msg);
         raise_application_error( -20012, msg );
      END IF;

      IF ( SUBSTR( l_codpole, 4, 2) != SUBSTR(LPAD(p_codsg, 7, '0'), 4, 2)
           AND SUBSTR( l_codpole, 4, 2) != '00' ) THEN

         -- Pole invalide

         pack_global.recuperer_message( 20013, '%s1', p_libelle, '%s2',
                                        SUBSTR(l_codpole, 4, 2),
                                        p_focus, msg);
         raise_application_error( -20013, msg );
      END IF;

      RETURN 0;

      -- Ne pas intercepter les exceptions

   END verifier_habilitation;

  FUNCTION verifier_habilitation_2 ( p_global  IN VARCHAR2,
                                    p_codsg   IN VARCHAR2,
                                    p_clicode   IN VARCHAR2,
                                    p_pid   IN VARCHAR2,
                                    p_libelle IN VARCHAR2,
                                    p_focus   IN VARCHAR2
                                  )
                              RETURN INTEGER IS
      msg VARCHAR(1024);
      l_codpole VARCHAR2(25);
      l_perimo VARCHAR2(1000);
      l_perime VARCHAR2(1000);
      l_exist_mo INTEGER;
      l_exist_me INTEGER;
      l_menutil VARCHAR2(1000);

   BEGIN

      l_codpole := LPAD(pack_global.lire_globaldata( p_global).codpole, 7, '0');
      l_menutil := pack_global.lire_globaldata( p_global).menutil;
      l_perimo:= PACK_GLOBAL.lire_globaldata(p_global).perimo;
      l_perime := PACK_GLOBAL.lire_globaldata(p_global).perime;

      --YNI : code mis en commentaire suite à la maj de l'eb 839

      /*IF l_codpole IS NULL THEN
         IF l_menutil != 'DIR' AND
            l_menutil != 'ME' THEN
            pack_global.recuperer_message( 21157, NULL, NULL, NULL, msg);
            raise_application_error( -20012, msg );
         END IF;
      END IF;*/

      /*IF ( SUBSTR( l_codpole, 1, 3) != SUBSTR(LPAD(p_codsg, 7, '0'), 1, 3)
           AND SUBSTR( l_codpole, 1, 3) != '000' ) THEN

         -- Departement invalide

         pack_global.recuperer_message( 21157, '%s1', p_libelle, '%s2',
                                        SUBSTR(l_codpole, 1, 3),
                                        p_focus, msg);
         raise_application_error( -20012, msg );
      END IF;*/

      -- YNI
        select count(*) into l_exist_mo from ligne_bip
           where pid = p_pid
           AND clicode in (select clicode from vue_clicode_perimo where INSTR(l_perimo,BDCLICODE)>0);

        select count(*) into l_exist_me from ligne_bip
           where pid = p_pid
           AND codsg in (select codsg from vue_dpg_perime where INSTR(l_perime,codbddpg)>0);

        /*IF l_exist_mo = 0 and l_exist_me != 0  THEN
          pack_global.recuperer_message( 21157, NULL, NULL, NULL, msg);
          raise_application_error( -20012, msg );
        END IF;

        IF l_exist_me = 0 and l_exist_mo != 0 THEN
            pack_global.recuperer_message( 21157, NULL, NULL, NULL, msg);
            raise_application_error( -20012, msg );
        END IF;*/

        IF l_exist_me = 0 and l_exist_mo = 0 THEN
            pack_global.recuperer_message( 21157, NULL, NULL, NULL, msg);
            raise_application_error( -20012, msg );
        END IF;
       --Fin YNI

      /*IF ( SUBSTR( l_codpole, 4, 2) != SUBSTR(LPAD(p_codsg, 7, '0'), 4, 2)
           AND SUBSTR( l_codpole, 4, 2) != '00' ) THEN

         -- Pole invalide

         pack_global.recuperer_message( 21157, '%s1', p_libelle, '%s2',
                                        SUBSTR(l_codpole, 4, 2),
                                        p_focus, msg);
         raise_application_error( -20012, msg );
      END IF;*/

      RETURN 0;

      -- Ne pas intercepter les exceptions

   END verifier_habilitation_2;

   PROCEDURE recuperation_integrite ( p_code IN NUMBER ) IS
      msg VARCHAR(1024);
      temp CHAR(20);
      no_msg NUMBER(5);
      positionDebut PLS_INTEGER;
      positionFin PLS_INTEGER;
   BEGIN

      -- Recuperer le message complet

      msg := SQLERRM(p_code);

      -- Chercher le point qui separe le nom integrite du nom
      -- owner

      positionDebut := INSTR( msg , '.' );

      -- Chercher la parenthese fermante du nom integrite

      positionFin := INSTR( SUBSTR( msg, positionDebut + 1), ')');

      -- Recuperer la chaine situee entre le point et )

      temp := SUBSTR( msg, positionDebut + 1, positionFin - 1 );

      -- Decouper nomchamp_nomsg (constituant le nom integrite)

      IF (p_code = -2291) THEN
         no_msg := '20' ||
                   TO_NUMBER( SUBSTR( temp, INSTR( temp, '_' ) +1 ) + 600 );
      ELSE

       -- p_code = -2292

         no_msg := '20' ||
                   TO_NUMBER( SUBSTR( temp, INSTR( temp, '_' ) +1 ) + 750 );
      END IF;

      -- Recuperer le message erreur concatené avec le nom du champ
      -- en erreur (qui recevra le focus)

      pack_global.recuperer_message(no_msg, NULL, NULL,
                                    SUBSTR( temp, 1, INSTR(temp,'_' )-1),
                                    msg);
      raise_application_error( - no_msg, msg);

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            raise_application_error( - no_msg,
                                     'Message à définir :\t' || no_msg || '\n' ||
                                     'Contrainte :\t' || temp || '\n' ||
                                     'Type integrite :\t' || p_code || '\n' ||
                                     'FOCUS=' || SUBSTR( temp, 1, INSTR( temp, '_' ) - 1) );

         -- Ne pas intercepter les autres exceptions

   END recuperation_integrite;


   PROCEDURE recuperer_message( p_id_msg        IN NUMBER,
                                p_tag           IN VARCHAR2,
                                p_replace_value IN VARCHAR2,
 				p_focus         IN VARCHAR2,
	                        p_msg           OUT VARCHAR2
                              ) IS
      l_msgerr VARCHAR2(1024);
   BEGIN

   p_msg := NULL;
   l_msgerr := NULL;

   -- Récupération et enrichissement du message
      SELECT REPLACE( limsg, p_tag, p_replace_value) ||
             DECODE( p_focus, NULL,
                     NULL, 'FOCUS=' || p_focus)
      INTO   p_msg
      FROM   message
      WHERE  id_msg = p_id_msg;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_msgerr := 'Code message '    ||
                     TO_CHAR( p_id_msg) ||
                     ' inexistant' ;

         raise_application_error( -20998, l_msgerr);

      WHEN OTHERS THEN
         raise_application_error( -20998, SQLERRM);

   END recuperer_message;


   PROCEDURE recuperer_message( p_id_msg         IN NUMBER,
                                p_tag1           IN VARCHAR2,
                                p_replace_value1 IN VARCHAR2,
                                p_tag2           IN VARCHAR2,
                                p_replace_value2 IN VARCHAR2,
				p_focus          IN VARCHAR2,
	                        p_msg            OUT VARCHAR2
                              ) IS
      l_msgerr VARCHAR2(1024);
   BEGIN

   p_msg := NULL;
   l_msgerr := NULL;

   -- Récupération et enrichissement du message

      SELECT REPLACE( REPLACE( limsg, p_tag1, p_replace_value1),
                      p_tag2, p_replace_value2) ||
             DECODE( p_focus, NULL,
                     NULL, 'FOCUS=' || p_focus)
      INTO   p_msg
      FROM   message
      WHERE  id_msg = p_id_msg;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_msgerr := 'Code message '    ||
                     TO_CHAR( p_id_msg) ||
                     ' inexistant' ;

         raise_application_error( -20998, l_msgerr);

      WHEN OTHERS THEN
         raise_application_error( -20998, SQLERRM);

   END recuperer_message;

   PROCEDURE recuperer_message( p_id_msg         IN NUMBER,
                                p_tag1           IN VARCHAR2,
                                p_replace_value1 IN VARCHAR2,
                                p_tag2           IN VARCHAR2,
                                p_replace_value2 IN VARCHAR2,
                                p_tag3           IN VARCHAR2,
                                p_replace_value3 IN VARCHAR2,
				p_focus          IN VARCHAR2,
	                        p_msg            OUT VARCHAR2
                              ) IS
      l_msgerr VARCHAR2(1024);
   BEGIN

   p_msg := NULL;
   l_msgerr := NULL;

   -- Récupération et enrichissement du message

      SELECT REPLACE( REPLACE( REPLACE( limsg,
                                        p_tag1,
                                        p_replace_value1),
                               p_tag2,
                               p_replace_value2),
                       p_tag3,
                       p_replace_value3) ||
             DECODE( p_focus, NULL,
                     NULL, 'FOCUS=' || p_focus)
      INTO   p_msg
      FROM   message
      WHERE  id_msg = p_id_msg;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_msgerr := 'Code message '    ||
                     TO_CHAR( p_id_msg) ||
                     ' inexistant' ;

         raise_application_error( -20998, l_msgerr);

      WHEN OTHERS THEN
         raise_application_error( -20998, SQLERRM);

   END recuperer_message;


   -- Initialisation du fichier en sortie si existe alors REPLACE
   --                                     sinon CREATE

   PROCEDURE init_write_file ( p_dirname IN VARCHAR2,
                              p_filename IN VARCHAR2,
                              p_hfile OUT UTL_FILE.FILE_TYPE) IS

   l_msg VARCHAR2(1024);

   BEGIN

     -- nom de fichier vide interdit
     IF LENGTH( RTRIM(LTRIM(p_filename))) = 0 THEN
        pack_global.recuperer_message( 20402, NULL, NULL, NULL, l_msg);
        raise_application_error(-20402, l_msg);
     END IF;

     p_hfile := UTL_FILE.FOPEN(p_dirname, p_filename, 'w');

   EXCEPTION
     WHEN OTHERS THEN
       pack_global.recuperer_message( 20402, NULL, NULL, NULL, l_msg);
       -- raise_application_error( -20402, l_msg);
       raise_application_error( -20997, SQLERRM);

   END init_write_file;


   -- Ecriture d'une chaine de caractère dans un fichier


   PROCEDURE write_string ( p_hfile IN UTL_FILE.FILE_TYPE,
                            p_string IN VARCHAR2) IS

   l_msg VARCHAR2(1024);

   BEGIN
-- pour des lignes de longueur superieure a 1023 il faut le faire en deux fois
	IF (LENGTH(p_string)<1024) THEN
		UTL_FILE.PUT_LINE(p_hfile, p_string);
	ELSE
		UTL_FILE.PUT(p_hfile, SUBSTR(p_string, 1, 1000));
		UTL_FILE.PUT_LINE(p_hfile, SUBSTR(p_string, 1001));
	END IF;

   EXCEPTION
     WHEN OTHERS THEN
       pack_global.recuperer_message( 20402, NULL, NULL, NULL, l_msg);
       l_msg := l_msg || ' : Err. dans pack_global.Write_string';
       raise_application_error( -20997, SQLERRM);
   END write_string;


   -- Fermeture du fichier


   PROCEDURE close_write_file ( p_hfile IN OUT UTL_FILE.FILE_TYPE) IS

   l_msg VARCHAR2(1024);

   BEGIN
     UTL_FILE.FFLUSH(p_hfile);
     UTL_FILE.FCLOSE(p_hfile);

   EXCEPTION
     WHEN OTHERS THEN
       pack_global.recuperer_message( 20402, NULL, NULL, NULL, l_msg);
       -- raise_application_error( -20402, l_msg);
       raise_application_error( -20997, SQLERRM);

   END close_write_file;

   --fonction qui récupère le niveau du centre d'activité

   FUNCTION recherche_niveau(p_codcamo IN varchar2)
    RETURN NUMBER
    IS

    cursor niv0_cur is select codcamo from centre_activite
       where codcamo = TO_NUMBER(p_codcamo);

    cursor niv1_cur is select codcamo from centre_activite
       where caniv1 = TO_NUMBER(p_codcamo);

    cursor niv2_cur is select codcamo from centre_activite
       where caniv2 = TO_NUMBER(p_codcamo);

    cursor niv3_cur is select codcamo from centre_activite
       where caniv3 = TO_NUMBER(p_codcamo);

    cursor niv4_cur is select codcamo from centre_activite
       where caniv4 = TO_NUMBER(p_codcamo);

    cursor niv5_cur is select codcamo from centre_activite
       where caniv5 = TO_NUMBER(p_codcamo);

    cursor niv6_cur is select codcamo from centre_activite
       where caniv6 = TO_NUMBER(p_codcamo);

    l_niveau number(1);

    BEGIN

       for niv_rec in niv0_cur loop
           return 0;
       end loop;
       for niv_rec in niv1_cur loop
           return 1;
       end loop;
       for niv_rec in niv2_cur loop
           return 2;
       end loop;
       for niv_rec in niv3_cur loop
           return 3;
       end loop;
       for niv_rec in niv4_cur loop
           return 4;

       end loop;
       for niv_rec in niv5_cur loop
           return 5;
       end loop;
       for niv_rec in niv6_cur loop
           return 6;

       end loop;
       return 99;

    END recherche_niveau;

    FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array
   IS

      i       number :=0;
      pos     number :=0;
     -- PPM HMI 60709 $5.3
      -- PPM 63485 augmenter la taille à 6000
      lv_str  varchar2(6000) := p_in_string||p_delim;

   strings t_array;

   BEGIN

      -- determine first chuck of string
      pos := instr(lv_str,p_delim,1,1);

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

--PPM 61776 : début
--Procédure qui prend en entrée la liste des chefs de projet (avec des codeRess*)
--et retourne la liste des chefs de projet et ceux habilités via le codeRess*
PROCEDURE lire_liste_chefs_projet(p_listeCodeRess IN VARCHAR2, p_listeCp OUT VARCHAR2)
IS

--l_element VARCHAR2(4000);

BEGIN

p_listeCp := get_liste_chefs_projet(p_listeCodeRess);

--l_element:= get_liste_chefs_projet(p_listeCodeRess);
--DBMS_OUTPUT.PUT_LINE('liste finale  ' ||  p_listeCp);
--DBMS_OUTPUT.PUT_LINE('liste finale ancienne methode  ' ||  l_element);

END lire_liste_chefs_projet;


FUNCTION get_liste_chefs_projet(
    p_listeCodeRess IN VARCHAR2)
  RETURN VARCHAR2
IS
  l_cpident ident_table;
  l_listeCp  VARCHAR2(32767);--PPM 63485 : augmenter la taille à 4000
  l_codeRess VARCHAR2(10);
  l_listeCpTotale t_array;
  l_cp    VARCHAR2(100);
  l_len   NUMBER(5);
  l_msg   VARCHAR2(300);
  l_exist BOOLEAN;
  i NUMBER(5);
  l_listeParCP VARCHAR2(6000);--PPM 63485 : augmenter la taille à 4000
  max_CP       CONSTANT NUMBER(3) := 400;
  max_total_CP CONSTANT NUMBER(3) := 667;
  max_string   CONSTANT NUMBER(4) := 4000;
  
BEGIN
  l_listeCp := '';
  l_exist   :=true;
  -- replace ; par , au cas où la liste CHEF_PROJET est remontée de la table RTFE.
  l_listeCpTotale := SPLIT(REPLACE(p_listeCodeRess,';',','), ',');
  i := l_listeCpTotale.first;
  
  --DBMS_OUTPUT.PUT_LINE('debut :' || l_listeCp || ' - ' || to_char(REGEXP_COUNT(l_listeCp, ',')) || ' - ' || to_char(max_total_CP+1)  );
  <<search_cp>>
  WHILE (i IS NOT NULL) AND (nvl(REGEXP_COUNT(l_listeCp, ','),0) <= max_total_CP+1)
  LOOP
    --  FOR i IN 1..l_listeCpTotale.COUNT LOOP
    l_listeParCP := '';
    l_exist :=true;
    l_cp := l_listeCpTotale(i);
    l_len := LENGTH(l_cp);
    IF INSTR(l_cp,'*') = l_len THEN
       --DBMS_OUTPUT.PUT_LINE('CP avec etoile ' || l_cp);
      l_codeRess := SUBSTR(l_cp,0,l_len-1);
      --DBMS_OUTPUT.PUT_LINE('l_codeRess:' || l_codeRess ||' - '||i );
      IF l_listeCp || '^' = '^' THEN
        l_listeCp := l_codeRess; -- on initialise la liste des CP (N-1) par le CP (N) en cours
        --DBMS_OUTPUT.PUT_LINE('l_listeCp:' || l_listeCp );
        l_exist := false;
      ELSE
        -- QC 1874 : on test si un CP existe déjà dans la liste
        IF INSTR(','||l_listeCp||',', ','||l_codeRess||',' ) = 0 THEN-- on test si un CP existe déjà dans la liste
          l_listeCp := l_listeCp || ',' || l_codeRess;
          l_exist := false;
        END IF;
      END IF;
      IF NOT l_exist THEN
        <<List_PM>>
        FOR curseur IN
        (SELECT DISTINCT ident
        FROM view_list_active_pm
          START WITH cpident = to_number(l_codeRess)
          CONNECT BY cpident = prior ident
        )
        LOOP
          --l'ident est un CP, on le met dans la liste s'il n'existe pas déjà
          IF INSTR(','||l_listeCp||',', ','||curseur.ident||',' ) = 0 THEN-- on test si un CP existe déjà dans la liste
            l_listeParCP := l_listeParCP || ',' || curseur.ident;
          END IF;
        END LOOP List_PM;
        --DBMS_OUTPUT.PUT_LINE('CP listeparCP avant : ' || l_listeParCP);
        IF (REGEXP_COUNT(l_listeParCP, ',') > max_CP+1) THEN
          l_listeParCP := SUBSTR(l_listeParCP,0,instr(l_listeParCP,',',1,max_CP)-1);
        END IF;
        --DBMS_OUTPUT.PUT_LINE('CP listeparCP apres : ' || l_listeParCP);
        l_listeCp := l_listeCp || l_listeParCP;
      END IF;
    ELSE
      --DBMS_OUTPUT.PUT_LINE('CP sans etoile ' || l_cp);
      IF l_listeCp || '^' = '^' THEN
        l_listeCp := l_cp;
      ELSE
          IF INSTR(','||l_listeCp||',', ','||l_cp||',' ) = 0 THEN
            l_listeCp := l_listeCp || ',' || l_cp;
          END IF;
      END IF;
    END IF;
    i := l_listeCpTotale.next(i);
  END LOOP search_cp;
   --DBMS_OUTPUT.PUT_LINE('l_listeCp'||l_listeCp);
  -- cut the list at 666 project manager
  IF (REGEXP_COUNT(l_listeCp, ',') > max_total_CP+1) THEN
    l_listeCp := SUBSTR(l_listeCp,0,instr(l_listeCp,',',1,max_total_CP)-1);
  END IF;
 --DBMS_OUTPUT.PUT_LINE('l_listeCp'||l_listeCp);
   -- cut the list at 4000 characters max
  IF (LENGTH(l_listeCp) > max_string) THEN
    l_listeCp := SUBSTR(l_listeCp,0,max_string);
    l_listeCp := SUBSTR(l_listeCp,0,instr(l_listeCp,',',-1)-1);
  END IF;
  --on remet les ; au cas où la liste a été remontée de la tbale RTFE
  IF INSTR(p_listeCodeRess,';') >0 THEN
    l_listeCp := REPLACE(l_listeCp,',',';');
  END IF;
  --DBMS_OUTPUT.PUT_LINE('l_listeCp'||l_listeCp);
  RETURN l_listeCp;
END get_liste_chefs_projet;

--PPM 62551 : début
FUNCTION lpad_liste(p_liste IN VARCHAR2 ) RETURN VARCHAR2
IS
T_VAR t_array;
i INTEGER;
l_liste VARCHAR2(6000);
BEGIN


   T_VAR := SPLIT(p_liste, ',');
   FOR i IN 1..T_VAR.COUNT
   LOOP
   		if ( i = 1 ) then
   			l_liste := lpad(T_VAR(i),5,0);
   		else
   			l_liste := l_liste || ',' || lpad(T_VAR(i),5,0);
   		end if;
   	END LOOP;

    return l_liste;

END lpad_liste;
--PPM 62551 : fin

END pack_global;
/