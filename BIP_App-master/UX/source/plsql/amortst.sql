-- pack_st_amort PL/SQL
--
-- equipe SOPRA
--
-- crée le 26/03/1999
-- 
-- modifié le 06/10/1999 : prise en compte d'une RG (statut 'en cours' rend date facultative)
--
-- modifié le 15/10/1999 : prise en compte d'une RG, suite à la Fiche d'Evenement 27
--
-- modifié le 08/10/2001 : prise en compte de gesmenu - on supprime la possibilité de mise à jour de l'onglet MAJ statut
--
-- FE 27 => RG1 : 	la date du statut est obligatoire si :
--				statut différent de 'a immobiliser'
--			   ET statut différent de 'non amortissable'
--			   ET statut différent de 'en cours'
--
-- FE 27 => RG2 : 	la date du statut ne doit pas être saisie si
--				statut égal à 'a immobiliser'
--			   OU statut égal à 'non amortissable'
--			   OU statut égal à 'en cours'
--
-- Le 07/11/2003 PJO	IAS 	Suppression du statut en cours : remplacé par NULL
--			IAS	Nouvelle règles de gestion:
-- le 04/12/2003 NBM fiche 211 : bug quand suppression des 3 champs audit
-- 	  			 	 	   	   création de la procédure audit
-- 
-- Le 26/10/2004 PJO  Ajout de logs lors de la mise à jour de statuts
--
-- Le 12/06/2006 PPR  Ajout d'informations sur les projets et dossiers projets
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
-- Modifié le 15/03/2012 : ABA QC 1305

CREATE OR REPLACE PACKAGE pack_st_amort AS

TYPE st_amort_RecType IS RECORD (pid         ligne_bip.pid%TYPE,
                                 pnom        ligne_bip.pnom%TYPE,
                                 typproj     ligne_bip.typproj%TYPE,
                                 astatut     ligne_bip.astatut%TYPE,
                                 topfer      ligne_bip.topfer%TYPE,
                                 adatestatut VARCHAR2(10),
                                 flaglock    ligne_bip.flaglock%TYPE,
		         		    	date_demande VARCHAR2(10),
		         		    	 demandeur   audit_statut.demandeur%TYPE,
		        		     	 commentaire audit_statut.commentaire%TYPE,
		        		    	 dpcode		 dossier_projet.dpcode%TYPE,
		        		    	 dplib 		 dossier_projet.dplib%TYPE,
		        		    	 datimmo     VARCHAR2(10),
		        		    	 actif       dossier_projet.actif%TYPE,
		        		    	 icpi        proj_info.icpi%TYPE,
		        		    	 ilibel      proj_info.ilibel%TYPE,
		        		    	 libstatut   code_statut.libstatut%TYPE,
		        		    	 datstatut   VARCHAR2(10)
								);


TYPE st_amortCurType IS REF CURSOR RETURN st_amort_RecType;

TYPE st_amortges_RecType IS RECORD (pid         ligne_bip.pid%TYPE,
                                    pnom        ligne_bip.pnom%TYPE,
                                    libstatut   code_statut.libstatut%TYPE,
                                    adatestatut VARCHAR2(10),
                                    flaglock    ligne_bip.flaglock%TYPE
                                );


TYPE st_amortgesCurType IS REF CURSOR RETURN st_amortges_RecType;

   PROCEDURE update_st_amort (p_pid         IN  ligne_bip.pid%TYPE,
                              p_pnom        IN  ligne_bip.pnom%TYPE,
                              p_filsigle    IN  filiale_cli.filsigle%TYPE,
                              p_typproj	    IN  ligne_bip.typproj%TYPE,
                              p_astatut     IN  ligne_bip.astatut%TYPE,
			      	p_topfer      IN  ligne_bip.topfer%TYPE,
                              p_top         IN  CHAR,--aur
                              p_adatestatut IN  VARCHAR2,
                              p_valid       IN  VARCHAR2,
					p_date_demande  IN  VARCHAR2,
		       		p_demandeur IN  VARCHAR2,
		       		p_commentaire IN  VARCHAR2,
                              p_flaglock    IN  NUMBER,
                              p_userid      IN  VARCHAR2,
                              p_nbcurseur   OUT INTEGER,
                              p_message     OUT VARCHAR2
                             );

  PROCEDURE confirm_st_amort (p_pid         IN  ligne_bip.pid%TYPE,
                              p_pnom        IN  ligne_bip.pnom%TYPE,
                              p_filsigle    IN  filiale_cli.filsigle%TYPE,
                              p_typproj	    IN ligne_bip.typproj%TYPE,
                              p_astatut     IN  ligne_bip.astatut%TYPE,
			      	p_topfer      IN  ligne_bip.topfer%TYPE,
                              p_top         IN CHAR,--aur
                              p_adatestatut IN  VARCHAR2,
                              p_valid       IN VARCHAR2,
					p_date_demande  IN  VARCHAR2,
		       		p_demandeur IN  VARCHAR2,
		       		p_commentaire IN  VARCHAR2,
                              p_flaglock    IN  NUMBER,
                              p_userid      IN  VARCHAR2,
                              p_nbcurseur   OUT INTEGER,
                              p_message     OUT VARCHAR2
                             );

   PROCEDURE select_st_amort (p_pid         IN ligne_bip.pid%TYPE,
                              p_userid      IN VARCHAR2,
                              p_curst_amort IN OUT st_amortCurType,
                              p_date           OUT VARCHAR2,
                              p_filsigle       OUT VARCHAR2,
                              p_nbcurseur      OUT INTEGER,
                              p_message        OUT VARCHAR2
                             );

PROCEDURE select_st_amortges (p_pid            IN ligne_bip.pid%TYPE,
                              p_userid         IN VARCHAR2,
                              p_curst_amortges IN OUT st_amortgesCurType,
                              p_filsigle    	  OUT VARCHAR2,
                              p_nbcurseur 	  OUT INTEGER,
                              p_message   	  OUT VARCHAR2
                             );

PROCEDURE audit ( p_pid            IN ligne_bip.pid%TYPE,
		  		  p_date_demande   IN VARCHAR2,
				  p_demandeur	   IN audit_statut.demandeur%TYPE,
				  p_commentaire	   IN audit_statut.commentaire	%TYPE,
				  p_message     OUT VARCHAR2);

END pack_st_amort;
/


CREATE OR REPLACE PACKAGE BODY     pack_st_amort AS

   PROCEDURE update_st_amort (p_pid         IN  ligne_bip.pid%TYPE,
                              p_pnom        IN  ligne_bip.pnom%TYPE,
                              p_filsigle    IN  filiale_cli.filsigle%TYPE,
                              p_typproj	    IN  ligne_bip.typproj%TYPE,
                              p_astatut     IN  ligne_bip.astatut%TYPE,
	                   	p_topfer      IN  ligne_bip.topfer%TYPE,
                              p_top         IN  CHAR, -- pour avoir le bon nombre de paramètre
		       		p_adatestatut IN  VARCHAR2,
		       		p_valid       IN  VARCHAR2,
		       		p_date_demande  IN  VARCHAR2,
		       		p_demandeur IN  VARCHAR2,
		       		p_commentaire IN  VARCHAR2,
                              p_flaglock    IN  NUMBER,
                              p_userid      IN  VARCHAR2,
                              p_nbcurseur   OUT INTEGER,
                              p_message     OUT VARCHAR2
                             ) IS

      	l_msg VARCHAR2(1024);
	l_annee NUMBER;
        l_datesaisie NUMBER;
        l_mois NUMBER;
 	out_of_stock    EXCEPTION;
	l_length_commentaire  NUMBER(4);

 	l_user		ligne_bip_logs.user_log%TYPE;
 	-- Valeurs précédentes pour les logs
 	l_topfer	ligne_bip.topfer%TYPE;
 	l_astatut	ligne_bip.astatut%TYPE;
 	l_adatestatut	ligne_bip.adatestatut%TYPE;


   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);

      -- On récupère les valeurs précédentes pour les logs
      SELECT topfer, astatut, adatestatut
      INTO l_topfer, l_astatut, l_adatestatut
      FROM ligne_bip
      WHERE pid=p_pid
      AND flaglock = p_flaglock;

      -- Si le statut ancien est Vide et que le nouveau est A ou D ou C
      -- On renvoie un message d'erreur
      If (l_astatut IS NULL) AND ((p_astatut='A') OR (p_astatut='D') OR (p_astatut='C')) THEN
         pack_global.recuperer_message(20929, '%s1', NVL(l_astatut,''), '%s2', NVL(p_astatut,''), 'ASTATUT', l_msg);
         raise_application_error( -20929, l_msg);
      END IF;

      -- Si le statut ancien est D et que le nouveau est A ou Vide ou N ou C
      -- On renvoie un message d'erreur
      If (l_astatut='D') AND ((p_astatut='A') OR (p_astatut='N') OR (p_astatut='C') OR (p_astatut IS NULL)) THEN
         pack_global.recuperer_message(20929, '%s1', NVL(l_astatut,''), '%s2', NVL(p_astatut,''), 'ASTATUT', l_msg);
         raise_application_error( -20929, l_msg);
      END IF;

      -- Si le statut ancien est A et que le nouveau est D ou N ou C ou Vide
      -- On renvoie un message d'erreur
      If (l_astatut='A') AND ((p_astatut='D') OR (p_astatut='N') OR (p_astatut='C') OR (p_astatut IS NULL)) THEN
         pack_global.recuperer_message(20929, '%s1', NVL(l_astatut,''), '%s2', NVL(p_astatut,''), 'ASTATUT', l_msg);
         raise_application_error( -20929, l_msg);
      END IF;

      -- Si le statut ancien est C et que le nouveau est D ou N ou A ou Vide
      -- On renvoie un message d'erreur
      If (l_astatut='C') AND ((p_astatut='D') OR (p_astatut='N') OR (p_astatut='A') OR (p_astatut IS NULL)) THEN
         pack_global.recuperer_message(20929, '%s1', NVL(l_astatut,''), '%s2', NVL(p_astatut,''), 'ASTATUT', l_msg);
         raise_application_error( -20929, l_msg);
      END IF;

      -- Si le statut ancien est N et que le nouveau est D ou C ou A ou Vide
      -- On renvoie un message d'erreur
      If (l_astatut='N') AND ((p_astatut='D') OR (p_astatut='C') OR (p_astatut='A') OR (p_astatut IS NULL)) THEN
         pack_global.recuperer_message(20929, '%s1', NVL(l_astatut,''), '%s2', NVL(p_astatut,''), 'ASTATUT', l_msg);
         raise_application_error( -20929, l_msg);
      END IF;

	--
	-- RG 24/11/2003 : la date du statut est obligatoire si statut différent de vide de 'O' et de 'N',

	IF ( (p_adatestatut IS NULL) AND (p_astatut IS NOT NULL) AND (p_astatut!='O') AND (p_astatut!='N')) THEN
         pack_global.recuperer_message(20002, NULL, NULL, 'ADATESTATUT', l_msg);
         raise_application_error( -20002, l_msg );
	END IF;

	--
	--  la date est obligatoire si top_fermeture est égal à OUI,
	--
	IF ( (p_adatestatut IS NULL) AND (p_topfer ='O')) THEN
         pack_global.recuperer_message(20004, NULL, NULL, 'ADATESTATUT', l_msg);
         raise_application_error( -20004, l_msg );
	END IF;


	--
	-- RG 24/11/2003 : la date du statut ne doit pas être saisie si statut vide ou ='O' ou ='N' et top fermeture égal à 'non'
	IF ( (p_adatestatut IS NOT NULL) AND ((p_astatut IS NULL) OR (p_astatut='O') OR (p_astatut='N')) AND (p_topfer='N') )
		 THEN
         pack_global.recuperer_message(20005, NULL, NULL, 'ADATESTATUT', l_msg);
         raise_application_error( -20005, l_msg );
	END IF;

	--controle de saisie de la DATE de statut d'une ligne bip
	IF p_adatestatut IS NOT NULL THEN
		l_datesaisie := TO_NUMBER(substr(p_adatestatut,4,4) || substr(p_adatestatut,0,2));
		--l_annee := TO_NUMBER (to_char(SYSDATE,'yyyy'));
		--l_mois :=TO_NUMBER (to_char(SYSDATE,'mm'));
        
        
        BEGIN
            select to_char(datdebex,'YYYY') into l_annee from datdebex;
        END ;

        IF l_datesaisie < ((l_annee -1) ||12) THEN
			--date saisie antérieure au dernier bilan
			pack_global.recuperer_message(20923,NULL,NULL,'ADATESTATUT',l_msg);
			raise_application_error( -20923, l_msg );
        END IF;
        

	/*	IF l_mois BETWEEN 01 AND 06 THEN
			IF l_datesaisie < ((l_annee -1) ||12) THEN
			--date saisie antérieure au dernier bilan
			pack_global.recuperer_message(20923,NULL,NULL,'ADATESTATUT',l_msg);
			raise_application_error( -20923, l_msg );
			ELSIF l_datesaisie > (l_annee ||0||5) THEN
			--anticipation sur les dates est interdite
			pack_global.recuperer_message(20924,NULL,NULL,'ADATESTATUT',l_msg);
			raise_application_error( -20924, l_msg );
			END IF;
		ELSE  -- DATE comprise entre juillet et decembre
			IF l_datesaisie < (l_annee||0||6) THEN
			--date saisie antérieure au dernier bilan
			pack_global.recuperer_message(20923,NULL,NULL,'ADATESTATUT',l_msg);
			raise_application_error( -20923, l_msg );
			ELSIF l_datesaisie > (l_annee ||11) THEN
			--anticipation sur les dates est interdite
			pack_global.recuperer_message(20924,NULL,NULL,'ADATESTATUT',l_msg);
			raise_application_error( -20924, l_msg );
			END IF;
		END IF;*/
	END IF;


      BEGIN
         UPDATE ligne_bip
         SET astatut     = decode(p_astatut, 'E', NULL, p_astatut),
	     topfer      = p_topfer,
             adatestatut = TO_DATE(p_adatestatut, 'MM/YYYY'),
             flaglock    = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE  pid = p_pid
         AND flaglock = p_flaglock;

         -- On loggue le type, la typologie, le CA payeur, le topfer, le statut, la date de statut
         pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'Top fermeture', l_topfer, p_topfer, 'MAJ statut de la ligne BIP via dirmenu');
         pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'Statut', l_astatut, p_astatut, 'MAJ statut de la ligne BIP via dirmenu');
         pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'Date statut', TO_CHAR(l_adatestatut, 'MM/YYYY'), p_adatestatut, 'MAJ statut de la ligne BIP via dirmenu');

	 --Audit
	 audit(p_pid, p_date_demande, p_demandeur, p_commentaire, p_message);

      EXCEPTION

         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN

         pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );

      ELSE

        pack_global.recuperer_message(2065, '%s1', p_pid, NULL, l_msg);
        p_message := l_msg;

     END IF;


END update_st_amort;

  PROCEDURE confirm_st_amort (p_pid         IN  ligne_bip.pid%TYPE,
                              p_pnom        IN  ligne_bip.pnom%TYPE,
                              p_filsigle    IN  filiale_cli.filsigle%TYPE,
                              p_typproj	    IN ligne_bip.typproj%TYPE,
                              p_astatut     IN  ligne_bip.astatut%TYPE,
			      	p_topfer      IN  ligne_bip.topfer%TYPE,
                              p_top         IN CHAR, -- pour avoir le bon nombre de paramètre
			      	p_adatestatut IN  VARCHAR2,
			      	p_valid       IN VARCHAR2,
					p_date_demande  IN  VARCHAR2,
		       		p_demandeur IN  VARCHAR2,
		       		p_commentaire IN  VARCHAR2,
                              p_flaglock    IN  NUMBER,
                              p_userid      IN  VARCHAR2,
                              p_nbcurseur   OUT INTEGER,
                              p_message     OUT VARCHAR2
                             ) IS

        l_msg VARCHAR2(1024);
	l_annee NUMBER;
        l_datesaisie NUMBER;
        l_mois NUMBER;

 	l_user		ligne_bip_logs.user_log%TYPE;
 	-- Valeurs précédentes pour les logs
 	l_topfer	ligne_bip.topfer%TYPE;
 	l_astatut	ligne_bip.astatut%TYPE;
 	l_adatestatut	ligne_bip.adatestatut%TYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);

      -- On récupère les valeurs précédentes pour les logs
      SELECT topfer, astatut, adatestatut
      INTO l_topfer, l_astatut, l_adatestatut
      FROM ligne_bip
      WHERE pid=p_pid
      AND flaglock = p_flaglock;

	--
	-- RG 06/10/199 : la date du statut est obligatoire si statut différent de 'en cours',
	-- IF ( (p_astatut!='E') AND (p_adatestatut IS NULL) ) THEN
	-- FE 27 => RG1 : 	la date du statut est obligatoire si :
	--				statut différent de 'a immobiliser'
	--			   ET statut différent de 'non amortissable'
	--			   ET statut différent de 'en cours'
	--
	IF ( (p_adatestatut IS NULL) AND (p_astatut!='O') AND (p_astatut!='N') AND (p_astatut!='E') ) THEN
         pack_global.recuperer_message(20002, NULL, NULL, 'ADATESTATUT', l_msg);
         raise_application_error( -20002, l_msg );
	END IF;

	--
	--  la date est obligatoire si top_fermeture est égal à OUI,
	--

	IF ( (p_adatestatut IS NULL) AND (p_top ='O')) THEN
         pack_global.recuperer_message(20004, NULL, NULL, 'ADATESTATUT', l_msg);
         raise_application_error( -20004, l_msg );
	END IF;


	--
	-- RG 06/10/199 : la date du statut ne doit pas être saisie si statut égal à 'en cours' et top fermeture égal à 'non'
	-- IF ( (p_astatut='E') AND  (p_topfer='N') AND (p_adatestatut IS NOT NULL) ) THEN
	-- FE 27 => RG2 : 	la date du statut ne doit pas être saisie si
	--				statut égal à 'a immobiliser'
	--			   OU statut égal à 'non amortissable'
	--			   OU statut égal à 'en cours'
	--
	IF ( (p_adatestatut IS NOT NULL) AND ( (p_astatut='O') OR (p_astatut='N') OR (p_astatut='E') )AND  (p_top='N') )
		 THEN
         pack_global.recuperer_message(20005, NULL, NULL, 'ADATESTATUT', l_msg);
         raise_application_error( -20005, l_msg );
	END IF;

	--controle de saisie de la DATE de statut d'une ligne bip
	IF p_adatestatut IS NOT NULL THEN

		l_datesaisie := TO_NUMBER(substr(p_adatestatut,4,4) || substr(p_adatestatut,0,2));
		l_annee := TO_NUMBER (to_char(SYSDATE,'yyyy'));
		l_mois :=TO_NUMBER (to_char(SYSDATE,'mm'));

		IF l_mois BETWEEN 01 AND 06 THEN
			IF l_datesaisie > (l_annee ||0||5) THEN
			--anticipation sur les dates est interdite
			pack_global.recuperer_message(20924,NULL,NULL,'ADATESTATUT',l_msg);
			raise_application_error( -20924, l_msg );
			END IF;
		ELSE  -- DATE comprise entre juillet et decembre
			IF l_datesaisie > (l_annee ||11) THEN
			--anticipation sur les dates est interdite
			pack_global.recuperer_message(20924,NULL,NULL,'ADATESTATUT',l_msg);
			raise_application_error( -20924, l_msg );
			END IF;
		END IF;
	END IF;


      BEGIN
         UPDATE ligne_bip
         SET astatut     = decode(p_astatut, 'E', NULL, p_astatut),
	     topfer     = p_topfer,
             adatestatut = TO_DATE(p_adatestatut, 'MM/YYYY'),
             flaglock    = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE  pid = p_pid
         AND flaglock = p_flaglock;

         -- On loggue le type, la typologie, le CA payeur, le topfer, le statut, la date de statut
         pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'Top fermeture', l_topfer, p_topfer, 'MAJ statut de la ligne BIP via dirmenu');
         pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'Statut', l_astatut, p_astatut, 'MAJ statut de la ligne BIP via dirmenu');
         pack_ligne_bip.maj_ligne_bip_logs(p_pid, l_user, 'Date statut', TO_CHAR(l_adatestatut, 'MM/YYYY'), p_adatestatut, 'MAJ statut de la ligne BIP via dirmenu');

	 --Audit
	 audit(p_pid, p_date_demande, p_demandeur, p_commentaire, p_message);

      EXCEPTION

         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE
        pack_global.recuperer_message(2065, '%s1', p_pid, NULL, l_msg);
        p_message := l_msg;
     END IF;

END confirm_st_amort;



   PROCEDURE select_st_amort (p_pid         IN ligne_bip.pid%TYPE,
                              p_userid      IN VARCHAR2,
                              p_curst_amort IN OUT st_amortCurType,
                              p_date        OUT VARCHAR2,
                              p_filsigle    OUT VARCHAR2,
                              p_nbcurseur   OUT INTEGER,
                              p_message     OUT VARCHAR2
                             ) IS

      l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Recuperation de FILCODE dans la table client_mo.

      BEGIN
         SELECT filsigle
         INTO   p_filsigle
         FROM   filiale_cli
         WHERE  filcode IN (
                            SELECT filcode
                            FROM   client_mo
                            WHERE  clicode IN (
                                               SELECT clicode
                                               FROM ligne_bip
                                               WHERE pid = p_pid
                                              )
                           );

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
             NULL;

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);

      END;

       BEGIN
         SELECT TO_CHAR(SYSDATE,'mm/yyyy')
         INTO   p_date
         FROM   dual
         ;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
             NULL;

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);

      END;


      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN p_curst_amort FOR
              SELECT 	l.pid,
                 	l.pnom,
                     	l.typproj,
                     	l.astatut,
                     	l.topfer,
                   	TO_CHAR(l.adatestatut,'mm/yyyy') ,
                   	l.flaglock,
  	       		TO_CHAR(a.date_demande,'dd/mm/yyyy') ,
		 		a.demandeur ,
		 		a.commentaire,
		 		d.dpcode,
		 		d.dplib,
		 		TO_CHAR(d.datimmo,'dd/mm/yyyy') ,
		 		d.actif,
		 		p.icpi,
		 		p.ilibel,
		 		c.libstatut,
		 		TO_CHAR(p.datstatut,'dd/mm/yyyy')
              FROM ligne_bip l, audit_statut a, dossier_projet d, proj_info p, code_statut c
              WHERE l.pid=a.pid(+)
              AND l.icpi = p.icpi
              AND l.dpcode = d.dpcode
              AND p.statut = c.astatut(+)
	   	  	  AND l.pid = p_pid;

      EXCEPTION
         WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
      END;

      -- en cas absence
      -- p_message := 'n''existe pas';

      pack_global.recuperer_message(5010, NULL, NULL, NULL, l_msg);
      p_message := l_msg;

   END select_st_amort;


PROCEDURE select_st_amortges (p_pid            IN ligne_bip.pid%TYPE,
                              p_userid         IN VARCHAR2,
                              p_curst_amortges IN OUT st_amortgesCurType,
                              p_filsigle    	  OUT VARCHAR2,
                              p_nbcurseur 	  OUT INTEGER,
                              p_message   	  OUT VARCHAR2
                             ) IS

      l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Recuperation de FILCODE dans la table client_mo.

      BEGIN
         SELECT filsigle
         INTO   p_filsigle
         FROM   filiale_cli
         WHERE  filcode IN (
                            SELECT filcode
                            FROM   client_mo
                            WHERE  clicode IN (
                                               SELECT clicode
                                               FROM ligne_bip
                                               WHERE pid = p_pid
                                              )
                           );

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
             NULL;

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);

      END;


      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN p_curst_amortges FOR
              SELECT lb.pid,
                     lb.pnom,
                     DECODE(lb.astatut, NULL, 'Pas de statut', cs.libstatut),
                     TO_CHAR(lb.adatestatut,'mm/yyyy'),
                     lb.flaglock
              FROM ligne_bip lb,code_statut cs
              WHERE lb.pid = p_pid
	      AND lb.astatut = cs.astatut (+);

      EXCEPTION
         WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
      END;

      -- en cas absence
      -- p_message := 'n''existe pas';

      pack_global.recuperer_message(5010, NULL, NULL, NULL, l_msg);
      p_message := l_msg;

   END select_st_amortges;

PROCEDURE audit ( p_pid            IN ligne_bip.pid%TYPE,
		  		  p_date_demande   IN VARCHAR2,
				  p_demandeur	   IN audit_statut.demandeur%TYPE,
				  p_commentaire	   IN audit_statut.commentaire	%TYPE,
				  p_message     OUT VARCHAR2) IS
l_msg VARCHAR2(1024);
out_of_stock    EXCEPTION;
l_length_commentaire  NUMBER(4);
l_exist NUMBER(1);
BEGIN
	--Si l'un des 3 champs est renseigné
	IF ((p_date_demande is not null) or (p_demandeur is not null) or (p_commentaire is not null)) THEN
	        IF (p_commentaire is not null) THEN
			BEGIN
				l_length_commentaire := length(p_commentaire);
				IF (l_length_commentaire > 150) THEN
		            		RAISE out_of_stock;
		       	 	END IF;
			EXCEPTION
				WHEN out_of_stock THEN
					pack_global.recuperer_message(20380,NULL,NULL,'commentaire',l_msg);
					raise_application_error( -20380, l_msg );
		 	END;
		END IF;
		BEGIN
			UPDATE audit_statut
			SET 	date_demande = TO_DATE(p_date_demande,'DD/MM/YYYY'),
				demandeur=p_demandeur,
				commentaire=p_commentaire
			WHERE  pid = p_pid;
		EXCEPTION
		       	WHEN OTHERS THEN
		            	raise_application_error(-20997, SQLERRM);
		END;
		IF SQL%NOTFOUND THEN
			--la ligne n'existe pas, on l'insère dans la table
			INSERT INTO audit_statut (pid,date_demande,demandeur,commentaire)
			VALUES (p_pid,TO_DATE(p_date_demande,'DD/MM/YYYY'),p_demandeur,p_commentaire);
	  	END IF;
	ELSE
		BEGIN
			SELECT count(1) into l_exist
			FROM audit_statut
			WHERE  pid = p_pid;

			IF l_exist=1 THEN
				DELETE audit_statut WHERE  pid = p_pid;
			END IF;

		END;
	END IF;
		p_message := l_msg;


END audit;

END pack_st_amort;
/


