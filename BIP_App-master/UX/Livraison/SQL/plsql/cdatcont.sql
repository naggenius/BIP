-- ***************************************************************************************************************
-- pack_MajDatSuivCont PL/SQL
-- ***************************************************************************************************************
-- equipe SOPRA
-- crée le 05/10/1999
--
-- Pour Mise a jour des des dates de suivi d'un contrat
-- Procedures : select_contrat
--              update_contrat
-- Modifié le 20/12/2000 par NCM : gestion des habilitation suivant le centre de frais
--				le centre de frais est récupéré par la variable globale
--				=>inconvénient : si un utilisateur est affecté à un autre centre de frais,
--				la modification est prise en compte à la prochaine connexion de l'utilisateur
--
-- 07/08/2008 EVI TD 637: refonte societe
-- 23/04/2009 ABA TD 737: contrat 27+3
-- ***************************************************************************************************************

CREATE OR REPLACE PACKAGE     pack_MajDatSuivCont AS

   TYPE ContRecType IS RECORD (soccont      contrat.soccont%TYPE,
                               soclib       societe.soclib%TYPE,
                               numcont      contrat.numcont%TYPE,
                               cav          contrat.cav%TYPE,
                               cobjet1      contrat.cobjet1%TYPE,
                               cobjet2      contrat.cobjet2%TYPE,
                               codsg        VARCHAR2(20),
                               libdsg       struct_info.libdsg%TYPE,
                               cdatsai      VARCHAR2(10),
                               cdatdeb      VARCHAR2(10),
                               cdatfin      VARCHAR2(10),
                               cdatrpol     VARCHAR2(10),  -- date de d'envoie au pole
                               cdatdir      VARCHAR2(10),  -- date de retour au pole
                               flaglock     VARCHAR2(20),
                               siren        contrat.siren%TYPE
                              );

   TYPE ContCurType IS REF CURSOR RETURN ContRecType;

   PROCEDURE update_contrat (
                             p_soccont   IN  contrat.soccont%TYPE,
                             p_soclib    IN  societe.soclib%TYPE,
                             p_numcont   IN  contrat.numcont%TYPE,
                             p_cav       IN  contrat.cav%TYPE,
                             p_cobjet1   IN  contrat.cobjet1%TYPE,
                             p_cobjet2   IN  contrat.cobjet2%TYPE,
                             p_codsg     IN  VARCHAR2,
                             p_libdsg    IN  struct_info.libdsg%TYPE,
                             p_cdatsai   IN  VARCHAR2,
                             p_cdatdeb   IN  VARCHAR2,
                             p_cdatfin   IN  VARCHAR2,
                             p_cdatrpol  IN  VARCHAR2,     -- date de d'envoie au pole
                             p_cdatdir   IN  VARCHAR2,     -- date de retour au pole
                             p_flaglock  IN  NUMBER,
                             p_userid    IN  VARCHAR2,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            );

   PROCEDURE select_contrat (
                             p_soccont   IN contrat.soccont%TYPE,
                             p_numcont   IN contrat.numcont%TYPE,
                             p_cav       IN contrat.cav%TYPE,
                             p_userid    IN VARCHAR2,
                             p_curcont   IN OUT ContCurType,
                             p_nbcurseur    OUT INTEGER,
                             p_message      OUT VARCHAR2
                            );

END pack_MajDatSuivCont;
/


CREATE OR REPLACE PACKAGE BODY     pack_MajDatSuivCont AS

   PROCEDURE update_contrat (
                             p_soccont   IN  contrat.soccont%TYPE,
                             p_soclib    IN  societe.soclib%TYPE,
                             p_numcont   IN  contrat.numcont%TYPE,
                             p_cav       IN  contrat.cav%TYPE,
                             p_cobjet1   IN  contrat.cobjet1%TYPE,
                             p_cobjet2   IN  contrat.cobjet2%TYPE,
                             p_codsg     IN  VARCHAR2,
                             p_libdsg    IN  struct_info.libdsg%TYPE,
                             p_cdatsai   IN  VARCHAR2,
                             p_cdatdeb   IN  VARCHAR2,
                             p_cdatfin   IN  VARCHAR2,
                             p_cdatrpol  IN  VARCHAR2,     -- date de d'envoie au pole
                             p_cdatdir   IN  VARCHAR2,     -- date de retour au pole
                             p_flaglock  IN  NUMBER,
                             p_userid    IN  VARCHAR2,
                             p_nbcurseur OUT INTEGER,
                             p_message   OUT VARCHAR2
                            ) IS

      l_msg VARCHAR2(1024);
      l_filcode filiale_cli.filcode%TYPE;

      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';

      -- On recupere le code filiale de l'utilisateur

      l_filcode := pack_global.lire_globaldata(p_userid).filcode;
      -- dbms_output.put_line(l_filcode);

      -- ---------------------------
      -- Controles Regles de gestion
      IF (p_cdatdir IS NULL) OR (p_cdatrpol IS NULL) THEN
         -- Saisie obligatoire
         pack_global.recuperer_message(20434, NULL, NULL, NULL, l_msg);
         p_message := l_msg;
         raise_application_error(-20434, l_msg );
	ELSE
         IF TO_DATE(p_cdatdir, 'dd/mm/yyyy') < TO_DATE(p_cdatsai, 'dd/mm/yyyy') THEN
            -- Date de retour du pôle doit être postérieure ou égale à la date de saisie
            pack_global.recuperer_message(20433,NULL, NULL, 'CDATDIR', l_msg);
            raise_application_error(-20433, l_msg );

         ELSIF TO_DATE(p_cdatrpol, 'dd/mm/yyyy') < TO_DATE(p_cdatsai, 'dd/mm/yyyy') THEN
            -- Date d'envoi au pôle doit être postérieure ou égale à la date de saisie
            pack_global.recuperer_message(20432,NULL, NULL, 'CDATRPOL', l_msg);
            raise_application_error(-20432, l_msg );

         ELSIF TO_DATE(p_cdatrpol, 'dd/mm/yyyy') > TO_DATE(p_cdatdir, 'dd/mm/yyyy') THEN
            -- Date d'envoi au pôle doit être inférieur ou égale à la date de retour du pôle
            pack_global.recuperer_message(20439,NULL, NULL, 'CDATRPOL', l_msg);
            raise_application_error(-20439, l_msg );

         END IF;

      END IF;

      -- UPDATE du contrat
      BEGIN
         UPDATE contrat
         SET cdatrpol  = to_date(p_cdatrpol,'DD/MM/YYYY'),
             cdatdir   = to_date(p_cdatdir,'DD/MM/YYYY'),
             cdatmaj   = trunc(sysdate),
             flaglock  = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE soccont = p_soccont
         AND   filcode = l_filcode
         AND   numcont = p_numcont
         AND   cav     = lpad(nvl(p_cav,'0'),3,'0')
         AND   flaglock = p_flaglock;

      EXCEPTION
         WHEN referential_integrity THEN
            -- habiller le msg erreur
            pack_global.recuperation_integrite(-2291);

         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN   -- si la mise a jour n'est pas effectuee
         -- Accès concurrent sur les mêmes données,\nveuillez recharger vos données
         pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE
         -- Contrat %s1 modifié
         pack_global.recuperer_message(2089,'%s1',p_numcont, NULL, l_msg);
         p_message := l_msg;
      END IF;

   END update_contrat;


-- *****************************************************************************
-- SELECT FACTURE
-- *****************************************************************************
   PROCEDURE select_contrat (
                             p_soccont   IN contrat.soccont%TYPE,
                             p_numcont   IN contrat.numcont%TYPE,
                             p_cav       IN contrat.cav%TYPE,
                             p_userid    IN VARCHAR2,
                             p_curcont   IN OUT ContCurType,
                             p_nbcurseur    OUT INTEGER,
                             p_message      OUT VARCHAR2
                            ) IS

      l_msg VARCHAR2(1024);
      l_soclib  societe.soclib%TYPE;
      l_soccont contrat.soccont%TYPE;
      l_filcode filiale_cli.filcode%TYPE;
      l_centre_frais centre_frais.codcfrais%TYPE;
      l_ccentrefrais centre_frais.codcfrais%TYPE;
      l_cav VARCHAR2(3);



   BEGIN
      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';
      l_cav := lpad(nvl(p_cav,'0'),3,'0');

      -- ----------------------------------------------------
      -- TEST existence du code societe dans la table societe
      BEGIN
         SELECT DISTINCT soccode
         INTO   l_soccont
         FROM   societe
         WHERE  soccode = p_soccont
           AND  rownum < 2;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
             -- Erreur message "Code Societe inconnu"
             pack_global.recuperer_message(20306, '%s1', p_soccont, 'SOCCONT', l_msg);
             raise_application_error(-20306,l_msg);

         WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
      END;

      --------------------------------------------------------------------------
      -- Test de l'existence du no de contrat et no avenant dans la table contrat
      
      IF (length(p_cav) = 2) THEN
      BEGIN
         SELECT distinct soccont
         INTO   l_soccont
         FROM   contrat
         WHERE  numcont = p_numcont
           AND  soccont = p_soccont
           AND  cav = l_cav
           AND  top30 = 'N'
           AND  rownum < 2;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
             -- Erreur message "Contrat inexistant"
             pack_global.recuperer_message(20280, NULL, NULL, 'NUMCONT', l_msg);
             raise_application_error(-20280,l_msg);
         WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
      END;
      ELSE
       BEGIN
         SELECT distinct soccont
         INTO   l_soccont
         FROM   contrat
         WHERE  numcont = p_numcont
           AND  soccont = p_soccont
           AND  cav = l_cav
           AND  top30 = 'O'
           AND  rownum < 2;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
             -- Erreur message "Contrat inexistant"
             pack_global.recuperer_message(20280, NULL, NULL, 'NUMCONT', l_msg);
             raise_application_error(-20280,l_msg);
         WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
      END;
      END IF;
      

      ----------------------------------------------
      -- On recupere le code filiale de l'utilisateur
      l_filcode := pack_global.lire_globaldata(p_userid).filcode;

      -- Test de l'existance du contrat dans la table contrat pour une autre filiale
      BEGIN
         SELECT distinct soccont
         INTO   l_soccont
         FROM   contrat
         WHERE  soccont = p_soccont
         AND    numcont = p_numcont
         AND    cav     = l_cav
         AND    filcode <> l_filcode;

         IF SQL%FOUND THEN
             -- Erreur message "Le contrat existe deja pour une autre filiale"
             pack_global.recuperer_message(20286, NULL, NULL, 'NUMCONT', l_msg);
             raise_application_error(-20286,l_msg);
         END IF;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
             NULL;
         WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
      END;

      -- 20/12/2000 :Contrôler que le contrat appartient au centre de frais de l'utilisateur
      -- On récupère le code centre de frais de l'utilisateur
      l_centre_frais:=pack_global.lire_globaldata(p_userid).codcfrais;

     IF l_centre_frais!=0 then    -- le centre de frais 0 donne tout les droits à l'utilisateur
        BEGIN
		select ccentrefrais into l_ccentrefrais
		from contrat
        	where  	numcont = p_numcont
	 	and	soccont = p_soccont
         	and    cav     = l_cav
		and    filcode = l_filcode;
	EXCEPTION

		WHEN OTHERS THEN
               		raise_application_error(-20997,SQLERRM);

	END;
	IF l_ccentrefrais is null  then
		-- Ce contrat n'est rattaché à aucun centre de frais
			 pack_global.recuperer_message(20336, '%s1',to_char(l_centre_frais),NULL, l_msg);
         		 raise_application_error(-20336, l_msg);

	END IF;
  	IF l_ccentrefrais!=l_centre_frais then
		--Le contrat n'existe pas dans le centre de frais mais dans le centre %s2
		 pack_global.recuperer_message(20335, '%s1',to_char(l_centre_frais),'%s2',to_char(l_ccentrefrais),NULL, l_msg);
         	raise_application_error(-20335, l_msg);
	END IF;
     END IF;

      ----------------------
      -- select

      BEGIN
            OPEN p_curcont FOR
               SELECT c.soccont                             ,
                      --s.soclib                            ,
                      a.socflib                           ,
                      c.numcont                           ,
                      decode(c.top30,'N',substr(c.cav,2,2),'O',decode(c.cav,'000',null,c.cav)),                            
                      c.cobjet1                           ,
                      c.cobjet2                           ,
                      to_char(c.codsg, 'FM0000000')       ,
                      si.libdsg                           ,
                      to_char(c.cdatsai,'dd/mm/yyyy')     ,
                      to_char(c.cdatdeb,'dd/mm/yyyy')     ,
                      to_char(c.cdatfin,'dd/mm/yyyy')     ,
                      to_char(c.cdatrpol,'dd/mm/yyyy')    ,
                      to_char(c.cdatdir,'dd/mm/yyyy')     ,
                      to_char(c.flaglock)                 ,
                      c.siren
              FROM    contrat c, societe s, struct_info si, agence a
              WHERE   c.soccont = p_soccont
              AND     s.soccode = p_soccont
              AND     si.codsg  = c.codsg
              AND     c.filcode = l_filcode
              AND     c.numcont = p_numcont
              AND     c.cav     = l_cav
              AND     c.siren=a.siren(+)
              AND     ROWNUM=1;

      EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Erreur message "Contrat inexistant"
                pack_global.recuperer_message(20280, NULL, NULL, NULL, l_msg);
                raise_application_error(-20280,l_msg);

            WHEN OTHERS THEN
               raise_application_error(-20997,SQLERRM);
      END;

   END select_contrat;

END pack_MajDatSuivCont;
/






-- exec pack_MajDatSuivCont.select_contrat('so','TIG98013', '00', 'S935709;;;;01;',:cur,:nb, :msg);                                                      
-- exec pack_MajDatSuivCont.select_contrat('SOPR','B980621424','01', 'S935709;;;;01;',:cur,:nb, :msg);
-- exec pack_MajDatSuivCont.select_contrat('SOPR','B980621424','05', 'S935709;;;;01;',:cur,:nb, :msg);

-- Pour les parametres non utilises comme p_soclib, on evoit soit une chaine vide '', soit une chaine quelconque ('soclib' pour ameliorer la lisibilite). 
-- exec pack_MajDatSuivCont.update_contrat('SOPR','soclib', 'B980621424', '01','cobjet1','cobjet2','codsg','libdsg','08/06/1999','cdatdeb','cdatfin', '', '08/06/1999', 0, 'S935709;;;;01;', :nb, :msg);
-- exec pack_MajDatSuivCont.update_contrat('SOPR','soclib', 'B980621424', '01','cobjet1','cobjet2','codsg','libdsg','08/06/1999','cdatdeb','cdatfin', '08/06/1999', '01/06/1999', 0, 'S935709;;;;01;', :nb, :msg);
-- exec pack_MajDatSuivCont.update_contrat('SOPR','soclib', 'B980621424', '01','cobjet1','cobjet2','codsg','libdsg','08/06/1999','cdatdeb','cdatfin', '01/06/1999', '08/06/1999', 0, 'S935709;;;;01;', :nb, :msg);
-- exec pack_MajDatSuivCont.update_contrat('SOPR','soclib', 'B980621424', '01','cobjet1','cobjet2','codsg','libdsg','08/06/1999','cdatdeb','cdatfin', '08/06/1999', '08/06/1999', 0, 'S935709;;;;01;', :nb, :msg);

