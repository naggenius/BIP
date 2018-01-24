-- pack_calendrier PL/SQL
--
-- equipe SOPRA
--
-- crée le 31/03/1999
-- modifié le 22/07/2003 par NBM : suppression des paramètres du types param#
-- modifié le 27/04/2005 par EJE : ajout champ nb jours SG et nb jours SSII
-- modifié le 06/02/2006 par JMA : ajout liste_annee
-- modifié le 09/03/2006 par BAA : Fiche 301 ajout colonne pourcentage théorique
-- modifié le 26/05/2007 par JAL : Fiche 643 ajout colonne date déblocage factures EBIS
-- modifié le 18/04/2012 par BSA : QC 1415
-- 
-- Attention le nom du package ne peut etre le nom
-- de la table...


CREATE OR REPLACE PACKAGE "PACK_CALENDRIER" AS

TYPE calendrier_RecType IS RECORD (cafin      	VARCHAR2(20),
                                   calanmois  	VARCHAR2(20),
                                   ccloture   	VARCHAR2(20),
                                   cjours     	VARCHAR2(20),
                                   cnbjourssg   VARCHAR2(20),
                                   cnbjoursssii VARCHAR2(20),
                                   cmensuelle 	VARCHAR2(20),
                                   cpremens1  	VARCHAR2(20),
                                   cpremens2  	VARCHAR2(20),
                                   flaglock   	NUMBER,
								   theorique   	NUMBER
                                  );

   TYPE calendrierCurType IS REF CURSOR RETURN calendrier_RecType;

   PROCEDURE insert_calendrier (p_calanmois  	                IN  VARCHAR2,
                                p_cpremens1  	                IN  VARCHAR2,
                                p_cpremens2  	                IN  VARCHAR2,
                                p_cmensuelle 	                IN  VARCHAR2,
                                p_ccloture   	                IN  VARCHAR2,
                                p_cafin      	                IN  VARCHAR2,
                                p_cjours     	                IN  VARCHAR2,
                                p_cnbjourssg 	                IN  VARCHAR2,
                                p_cnbjoursssii 	                IN  VARCHAR2,
                                p_userid     	                IN  VARCHAR2,
								p_theorique   	                IN  VARCHAR2,
                                p_debutblocageebis  IN VARCHAR2,
                                p_datefacturesebis              IN VARCHAR2,
                                p_nbcurseur  	                OUT INTEGER,
                                p_message    	                OUT VARCHAR2
                               );

   PROCEDURE update_calendrier (p_calanmois  	                IN  VARCHAR2,
                                p_cpremens1  	                IN  VARCHAR2,
                                p_cpremens2  	                IN  VARCHAR2,
                                p_cmensuelle 	                IN  VARCHAR2,
                                p_ccloture   	                IN  VARCHAR2,
                                p_cafin      	                IN  VARCHAR2,
                                p_cjours     	                IN  VARCHAR2,
                                p_cnbjourssg 	                IN  VARCHAR2,
                                p_cnbjoursssii 	                IN  VARCHAR2,
                                p_flaglock   	                IN  NUMBER,
                                p_userid     	                IN  VARCHAR2,
								p_theorique     	            IN  VARCHAR2,
                                p_debutblocageebis              IN VARCHAR2,
                                p_datefacturesebis              IN VARCHAR2,
                                p_nbcurseur  	                OUT INTEGER,
                                p_message    	                OUT VARCHAR2
                               );

   PROCEDURE select_calendrier (p_calanmois                     IN  VARCHAR2,
                                p_userid                        IN  VARCHAR2,
                                p_cafin                         OUT VARCHAR2,
                                p_cal                           OUT VARCHAR2,
                                p_ccloture                      OUT VARCHAR2,
                                p_cjours                        OUT VARCHAR2,
                                p_cnbjourssg 	                OUT  VARCHAR2,
                                p_cnbjoursssii 	                OUT  VARCHAR2,
                                p_cmensuelle                    OUT VARCHAR2,
                                p_cpremens1                     OUT VARCHAR2,
                                p_cpremens2                     OUT VARCHAR2,
                                p_mode                          OUT VARCHAR2,
                                p_flaglock                      OUT VARCHAR2,
								p_theorique                     OUT VARCHAR2,
                                p_debutblocageebis  OUT VARCHAR2,
                                p_datefacturesebis              OUT VARCHAR2,
                                p_nbcurseur                     OUT INTEGER,
                                p_message                       OUT VARCHAR2
                               );


   TYPE calendrierListe_ViewType IS RECORD ( MOIS          VARCHAR2(10),
                                           	 PREMENS1      VARCHAR2(30),
                                        	 PREMENS2      VARCHAR2(30),
                                        	 MENSUELLE     VARCHAR2(30),
                                        	 CJOURS        VARCHAR2(6),
											 CCLOTURE	   VARCHAR2(30),
                                           	 CSS_PREMENS1  NUMBER,
                                        	 CSS_PREMENS2  NUMBER,
                                        	 CSS_MENSUELLE NUMBER
									  	   );

   TYPE calendrierListeCurType IS REF CURSOR RETURN calendrierListe_ViewType;

   PROCEDURE liste_annee       (p_annee         IN  VARCHAR2,
                                p_curCalendrier IN OUT calendrierListeCurType,
                                p_nbcurseur     OUT INTEGER,
                                p_message       OUT VARCHAR2
                               );

   TYPE entete_ViewType IS RECORD ( IDFIC    FICHIER.IDFIC%TYPE,
                                    CONTENU  FICHIER.CONTENU%TYPE
								  );

   TYPE enteteCurType IS REF CURSOR RETURN entete_ViewType;

   PROCEDURE get_entete (  p_curEntete IN OUT enteteCurType,
                           p_nbcurseur    OUT INTEGER,
                           p_message      OUT VARCHAR2
						);

END Pack_Calendrier;
/


CREATE OR REPLACE PACKAGE BODY "PACK_CALENDRIER" AS

   PROCEDURE insert_calendrier (p_calanmois                      IN  VARCHAR2,
                                p_cpremens1                      IN  VARCHAR2,
                                p_cpremens2                      IN  VARCHAR2,
                                p_cmensuelle                     IN  VARCHAR2,
                                p_ccloture                       IN  VARCHAR2,
                                p_cafin                          IN  VARCHAR2,
                                p_cjours                         IN  VARCHAR2,
                                p_cnbjourssg                     IN  VARCHAR2,
                                p_cnbjoursssii                   IN  VARCHAR2,
                                p_userid                         IN  VARCHAR2,
                                p_theorique                      IN  VARCHAR2,
                                p_debutblocageebis               IN VARCHAR2,
                                p_datefacturesebis               IN VARCHAR2,
                                p_nbcurseur                      OUT INTEGER,
                                p_message    	                 OUT VARCHAR2
                               ) IS

   l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         INSERT INTO CALENDRIER (calanmois,
                                 cpremens1,
                                 cpremens2,
                                 cmensuelle,
                                 ccloture,
                                 cafin,
                                 cjours,
                                 nb_travail_sg,
                                 nb_travail_ssii,
								 theorique ,
                                 DEBUT_BLOCAGE_EBIS,
                                 DATE_EBIS_FACTURE
                                )
                VALUES (TO_DATE(p_calanmois,'mm/yyyy'),
                        TO_DATE(p_cpremens1, 'dd/mm/yyyy'),
                        TO_DATE(p_cpremens2, 'dd/mm/yyyy'),
                        TO_DATE(p_cmensuelle, 'dd/mm/yyyy'),
                        TO_DATE(p_ccloture, 'dd/mm/yyyy'),
                        TO_DATE(p_cafin, 'dd/mm/yyyy'),
                        TO_NUMBER(p_cjours, 'FM99D0'),
                        TO_NUMBER(p_cnbjourssg, 'FM99D0'),
                        TO_NUMBER(p_cnbjoursssii, 'FM99D0'),
			            TO_NUMBER(p_theorique, 'FM999D00') ,
                        TO_DATE(p_debutblocageebis, 'dd/mm/yyyy'),
                        TO_DATE(p_datefacturesebis, 'dd/mm/yyyy')
                       );

         -- 'Calendrier creee pour la date %s1';

         Pack_Global.recuperer_message(2071, '%s1', p_calanmois, NULL, l_msg);
         p_message := l_msg;

      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
             Pack_Global.recuperer_message(20267,NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20267, l_msg );

         WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM );

      END;
   END insert_calendrier;

   PROCEDURE update_calendrier (p_calanmois  	                IN  VARCHAR2,
                                p_cpremens1  	                IN  VARCHAR2,
                                p_cpremens2  	                IN  VARCHAR2,
                                p_cmensuelle 	                IN  VARCHAR2,
                                p_ccloture   	                IN  VARCHAR2,
                                p_cafin      	                IN  VARCHAR2,
                                p_cjours     	                IN  VARCHAR2,
                                p_cnbjourssg 	                IN  VARCHAR2,
                                p_cnbjoursssii 	                IN  VARCHAR2,
                                p_flaglock   	                IN  NUMBER,
                                p_userid     	                IN  VARCHAR2,
								p_theorique     	            IN  VARCHAR2,
                                p_debutblocageebis              IN VARCHAR2,
                                p_datefacturesebis              IN VARCHAR2,
                                p_nbcurseur  	                OUT INTEGER,
                                p_message    	                OUT VARCHAR2
                               ) IS

      l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
--insert into test_message values(p_debutblocageebis);
--insert into test_message values(p_datefacturesebis);

      BEGIN
          UPDATE CALENDRIER SET calanmois  	= TO_DATE(p_calanmois,'mm/yyyy'),
                                cpremens1  	= TO_DATE(p_cpremens1, 'dd/mm/yyyy'),
                                cpremens2  	= TO_DATE(p_cpremens2, 'dd/mm/yyyy'),
                                cmensuelle 	= TO_DATE(p_cmensuelle, 'dd/mm/yyyy'),
                                ccloture   	= TO_DATE(p_ccloture, 'dd/mm/yyyy'),
                                cafin      	= TO_DATE(p_cafin, 'dd/mm/yyyy'),
                                cjours     	= TO_NUMBER(p_cjours, 'FM99D0'),
                                nb_travail_sg 	= TO_NUMBER(p_cnbjourssg, 'FM99D0'),
                                nb_travail_ssii	= TO_NUMBER(p_cnbjoursssii, 'FM99D0'),
								theorique	= TO_NUMBER(p_theorique, 'FM999D00'),
                                flaglock   	= DECODE( p_flaglock, 1000000, 0, p_flaglock + 1) ,
                                DEBUT_BLOCAGE_EBIS = TO_DATE(p_debutblocageebis,'dd/mm/yyyy'),
                                DATE_EBIS_FACTURE = TO_DATE(p_datefacturesebis,'dd/mm/yyyy')
          WHERE TO_CHAR(calanmois, 'mm/yyyy') = p_calanmois
          AND flaglock = p_flaglock;

      EXCEPTION
           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20997, SQLERRM);
              --RAISE_APPLICATION_ERROR(-20997,p_datedebutblocagefacturesebis );
      END;

      IF SQL%NOTFOUND THEN
         Pack_Global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
        Pack_Global.recuperer_message( 2072,'%s1', p_calanmois, NULL, l_msg);
        p_message := l_msg;
      END IF;

   END update_calendrier;


   PROCEDURE select_calendrier (p_calanmois                     IN  VARCHAR2,
                                p_userid                        IN  VARCHAR2,
                                p_cafin                         OUT VARCHAR2,
                                p_cal                           OUT VARCHAR2,
                                p_ccloture                      OUT VARCHAR2,
                                p_cjours                        OUT VARCHAR2,
                                p_cnbjourssg 	                OUT  VARCHAR2,
                                p_cnbjoursssii 	                OUT  VARCHAR2,
                                p_cmensuelle                    OUT VARCHAR2,
                                p_cpremens1                     OUT VARCHAR2,
                                p_cpremens2                     OUT VARCHAR2,
                                p_mode                          OUT VARCHAR2,
                                p_flaglock                      OUT VARCHAR2,
								p_theorique                     OUT VARCHAR2,
                                p_debutblocageebis              OUT VARCHAR2,
                                p_datefacturesebis              OUT VARCHAR2,
                                p_nbcurseur                     OUT INTEGER,
                                p_message                       OUT VARCHAR2
                               ) IS

      l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      p_mode :=  'update';

      BEGIN

           -- Si pas d'exception -> UPDATE

           SELECT TO_CHAR(cafin, 'dd/mm/yyyy'),
                  TO_CHAR(calanmois,'mm/yyyy'),
                  TO_CHAR(ccloture, 'dd/mm/yyyy'),
                  TO_CHAR(cjours, 'FM90D0'),
                  TO_CHAR(nb_travail_sg, 'FM90D0'),
                  TO_CHAR(nb_travail_ssii, 'FM90D0'),
                  TO_CHAR(cmensuelle, 'dd/mm/yyyy'),
                  TO_CHAR(cpremens1, 'dd/mm/yyyy'),
                  TO_CHAR(cpremens2, 'dd/mm/yyyy'),
                  flaglock,
				  TO_CHAR(theorique, 'FM990D00') ,
                  TO_CHAR( DEBUT_BLOCAGE_EBIS, 'dd/mm/yyyy'),
                  TO_CHAR( DATE_EBIS_FACTURE, 'dd/mm/yyyy')
           INTO p_cafin, p_cal, p_ccloture, p_cjours,p_cnbjourssg,p_cnbjoursssii,p_cmensuelle, p_cpremens1, p_cpremens2, p_flaglock, p_theorique, p_debutblocageebis,  p_datefacturesebis
           FROM CALENDRIER
           WHERE TO_CHAR(calanmois,'mm/yyyy') = p_calanmois;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN

            --INSERT

            p_cafin      	:= '';
            p_cal        	:= '';
            p_ccloture   	:= '';
            p_cjours     	:= '';
            p_cnbjourssg     	:= '';
            p_cnbjoursssii     	:= '';
            p_cmensuelle 	:= '';
            p_cpremens1  	:= '';
            p_cpremens2  	:= '';
            p_flaglock   	:= '';
            p_mode       	:= 'insert';
            NULL;

         WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR(-20997,SQLERRM);
      END;

   END select_calendrier;




PROCEDURE liste_annee ( p_annee         IN  VARCHAR2,
                        p_curCalendrier IN OUT calendrierListeCurType,
                        p_nbcurseur     OUT INTEGER,
                        p_message       OUT VARCHAR2
                      ) IS
	l_annee VARCHAR2(4);
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';

	-- Si p_annee == NULL on prend l'année courante
	IF ( (p_annee IS NULL) OR (p_annee='') ) THEN
	    l_annee := TO_CHAR(SYSDATE(),'YYYY');
	ELSE
		l_annee := p_annee;
	END IF;

	BEGIN
		OPEN p_curCalendrier FOR
			SELECT TO_CHAR(calanmois,'Month') AS "libMois",
			       trim(TO_CHAR(cpremens1,'Day'))||' '||TO_CHAR(cpremens1,'DD/MM/YYYY') AS "cpremens1",
			       trim(TO_CHAR(cpremens2,'Day'))||' '||TO_CHAR(cpremens2,'DD/MM/YYYY') AS "cpremens2",
			       trim(TO_CHAR(cmensuelle,'Day'))||' '||TO_CHAR(cmensuelle,'DD/MM/YYYY') AS "cmensuelle",
				   TO_CHAR(cjours),
				   trim(TO_CHAR(ccloture,'Day'))||' '||TO_CHAR(ccloture,'DD/MM/YYYY') AS "ccloture",
				   trunc(cpremens1)-trunc(SYSDATE)  AS "css_cpremens1",
				   trunc(cpremens2)-trunc(SYSDATE)  AS "css_cpremens2",
				   trunc(cmensuelle)-trunc(SYSDATE) AS "css_cmensuelle"
			  FROM CALENDRIER
			 WHERE calanmois >= ADD_MONTHS(TO_DATE('01/01/'||l_annee, 'DD/MM/YYYY'),-1)
			   AND calanmois <= ADD_MONTHS(TO_DATE('01/01/'||l_annee, 'DD/MM/YYYY'),11)
			 ORDER BY calanmois;
    EXCEPTION
        WHEN OTHERS THEN
         	RAISE_APPLICATION_ERROR(-20997,SQLERRM);
    END;


END liste_annee;



PROCEDURE get_entete (  p_curEntete IN OUT enteteCurType,
                        p_nbcurseur    OUT INTEGER,
                        p_message      OUT VARCHAR2
                      ) IS
	l_annee VARCHAR2(4);
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';

	BEGIN
		OPEN p_curEntete FOR
			SELECT idfic, contenu
			  FROM FICHIER
			 WHERE idfic LIKE 'enteteCal%'
			 ORDER BY idfic;
    EXCEPTION
        WHEN OTHERS THEN
         	RAISE_APPLICATION_ERROR(-20997,SQLERRM);
    END;


END get_entete;


END Pack_Calendrier;
/


