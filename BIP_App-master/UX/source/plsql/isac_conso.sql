CREATE OR REPLACE PACKAGE Pack_Isac_Conso AS
TYPE ressource_ViewType IS RECORD ( 	IDENT     	VARCHAR2(5),
                                    	RESSOURCE     	VARCHAR2(100),
					MOIS 		VARCHAR2(7),
					NBMOIS 		NUMBER,
					KeyList4 	VARCHAR2(60),
					KeyList5 	VARCHAR2(7),
					KeyList6 	VARCHAR2(7)
                                     );

TYPE ressourceCurType IS REF CURSOR RETURN ressource_ViewType;


PROCEDURE update_conso_chaine(	p_chaine	IN VARCHAR2,
									   						  		  		 p_userid 	IN VARCHAR2,
                        									 				 p_nbcurseur     OUT INTEGER,
                        									 				 p_message       OUT VARCHAR2
															 				 );


PROCEDURE update_conso(	p_chaine1	IN VARCHAR2,
		  							   						 p_chaine2	IN VARCHAR2,
															 p_chaine3	IN VARCHAR2,
															 p_chaine4	IN VARCHAR2,
		  							   						 p_chaine5	IN VARCHAR2,
															 p_chaine6	IN VARCHAR2,
                                                             p_chaine7	IN VARCHAR2,-- PPM 64836 - ABN
									   			             p_userid 	IN VARCHAR2,
                       	                                     p_nbcurseur     OUT INTEGER,
                                                             p_message       OUT VARCHAR2
			                                                ) ;
													


PROCEDURE select_ressource(	p_ident 	IN VARCHAR2,
			    	p_userid 	IN VARCHAR2,
			    	p_curressource 	IN OUT ressourceCurType,
			   	p_nbpages       OUT VARCHAR2,
                             	p_numpage       OUT VARCHAR2,
				p_menu		OUT VARCHAR2,
                             	p_nbcurseur     OUT INTEGER,
                             	p_message       OUT VARCHAR2
			);

 PROCEDURE annulation_conso(	p_chaine	IN VARCHAR2,
				p_userid 	IN VARCHAR2
			);
--PPM 57865 : couleur_fond_mois 
PROCEDURE couleur_fond_mois(	p_ident 	IN VARCHAR2,
			    		p_mois 	IN VARCHAR2,
			    		p_recouv 	OUT VARCHAR2
			    		
      );
-- FAD PPM 64579 : couleur de fond de l'année
PROCEDURE couleur_fond_annee(	p_ident 	IN VARCHAR2,
			    		p_annee 	IN VARCHAR2,
			    		p_recouv 	OUT VARCHAR2
			    		
      );
-- FAD PPM 64579 : Fin
END Pack_Isac_Conso ;
/
CREATE OR REPLACE PACKAGE BODY Pack_Isac_Conso AS
--*************************************************************************************************
-- Procédure annulation_conso
--
-- Cette procédure sert à passer à l'écran igconso.htm lors d'une annulation
--
-- Appelée dans la page ilconso.htm
--
-- ************************************************************************************************
 PROCEDURE annulation_conso(	p_chaine	IN VARCHAR2,
				p_userid 	IN VARCHAR2
			) IS
 ligne VARCHAR2(30000);
 BEGIN
   ligne :='';
   --ligne :=p_chaine;
 END annulation_conso;
--*************************************************************************************************
-- Procédure update_conso
--
-- Permet de modifier les conso d'une ressource
--
-- Appelée dans la page ilconso.htm
--
-- ************************************************************************************************
PROCEDURE update_conso(	p_chaine1	IN VARCHAR2,
		  							   						 p_chaine2	IN VARCHAR2,
															 p_chaine3	IN VARCHAR2,
															 p_chaine4	IN VARCHAR2,
		  							   						 p_chaine5	IN VARCHAR2,
															 p_chaine6	IN VARCHAR2,
                                                             p_chaine7	IN VARCHAR2,
									   			             p_userid 	IN VARCHAR2,
                       	                                     p_nbcurseur     OUT INTEGER,
                                                             p_message       OUT VARCHAR2
			                                                ) IS
BEGIN


      IF(p_chaine1 IS NOT NULL)THEN
	                update_conso_chaine(	p_chaine1, p_userid, p_nbcurseur, p_message );
	  
	  			    IF(p_chaine2 IS NOT NULL)THEN
						  	    update_conso_chaine(	p_chaine2, p_userid, p_nbcurseur, p_message );
								 
	   							 IF(p_chaine3 IS NOT NULL)THEN
	  											 update_conso_chaine(	p_chaine3, p_userid, p_nbcurseur, p_message );
												 
												   IF(p_chaine4 IS NOT NULL)THEN
	    			   								   				update_conso_chaine(	p_chaine4, p_userid, p_nbcurseur, p_message );
	  
	  			    																	IF(p_chaine5 IS NOT NULL)THEN
					
	  							 																	 update_conso_chaine(	p_chaine5, p_userid, p_nbcurseur, p_message );
								 
	   							 																	 IF(p_chaine6 IS NOT NULL)THEN
	  																								 			    update_conso_chaine(	p_chaine6, p_userid, p_nbcurseur, p_message );
																													
																													 -- PPM 64836 - ABN
																													 IF(p_chaine7 IS NOT NULL)THEN
																																	update_conso_chaine(	p_chaine7, p_userid, p_nbcurseur, p_message );
																													 END IF;
																													 -- PPM 64836 - ABN
												 												 	 END IF;
																						END IF;							 
													END IF;
								END IF;
					END IF;							 
	  END IF;


END 	update_conso;														
															





PROCEDURE update_conso_chaine(	p_chaine	IN VARCHAR2,
											   								 p_userid 	IN VARCHAR2,
                        													 p_nbcurseur     OUT INTEGER,
                        													 p_message       OUT VARCHAR2
			) IS
l_msg VARCHAR2(500);
l_length NUMBER(7);
l_chaine VARCHAR2(32000);
l_pos NUMBER(7);
l_pos1 NUMBER(7);
i NUMBER(7);
l_ident VARCHAR2(5);
l_ligne VARCHAR2(32000);
l_pid LIGNE_BIP.pid%TYPE;
l_etape NUMBER(10);
l_tache NUMBER(10);
l_sous_tache NUMBER(10);
l_point1 NUMBER(7);
l_point2 NUMBER(7);
l_point3 NUMBER(7);
l_point4 NUMBER(7);
l_separateur NUMBER(7);
l_separateur1 NUMBER(7);
l_ligne_conso VARCHAR2(32000);
l_mois NUMBER(2);
l_conso VARCHAR2(100);
l_exist NUMBER(1);
l_annee VARCHAR2(4);
l_mois_saisie NUMBER(2);
l_datemens DATE;
l_count NUMBER(3);
l_rnom RESSOURCE.rnom%TYPE;
l_rprenom RESSOURCE.rprenom%TYPE;
l_mois_courant VARCHAR2(7);
l_erreur      NUMBER;

BEGIN
p_message :='';
--p_chaine du type ':PID;ETAPE;TACHE;SOUS_TACHE;:PID1;ETAPE1;TACHE1;SOUS_TACHE1;'
	l_length := LENGTH(p_chaine);
	l_ident := SUBSTR(p_chaine,1,INSTR(p_chaine,':',1,1)-1);


	FOR i IN 1..l_length LOOP
		l_pos := INSTR(p_chaine,':',1,i);
		l_pos1 := INSTR(p_chaine,':',1,i+1);
		l_ligne := SUBSTR(p_chaine,l_pos+1,l_pos1-l_pos-1);
		l_point1 := INSTR(l_ligne,';',1,1);
		l_point2 := INSTR(l_ligne,';',1,2);
		l_point3 := INSTR(l_ligne,';',1,3);
		l_point4 := INSTR(l_ligne,';',1,4);

--dbms_output.put_line('ligne:'||l_ligne);

		l_pid := SUBSTR(l_ligne,1,l_point1-1);
		l_etape := TO_NUMBER(SUBSTR(l_ligne, l_point1+1, l_point2-l_point1-1));
		l_tache := TO_NUMBER(SUBSTR(l_ligne, l_point2+1, l_point3-l_point2-1));
		l_sous_tache := TO_NUMBER(SUBSTR(l_ligne, l_point3+1, l_point4-l_point3-1));



		FOR j IN 1..LENGTH(l_ligne) LOOP
			l_separateur := INSTR(l_ligne,';',l_point4,j);
			l_separateur1 := INSTR(l_ligne,';',l_point4,j+1);

			l_ligne_conso := SUBSTR(l_ligne,l_separateur+1,l_separateur1-l_separateur-1);


		--Rechercher le mois de consommé
			l_mois:=TO_NUMBER(SUBSTR(l_ligne_conso,INSTR(l_ligne_conso,'_',1,2)+1,INSTR(l_ligne_conso,'=',1,1)-INSTR(l_ligne_conso,'_',1,2)-1));


		--Rechercher le consommé
			l_conso:=SUBSTR(l_ligne_conso,INSTR(l_ligne_conso,'=',1,1)+1,LENGTH(l_ligne_conso)-INSTR(l_ligne_conso,'=',1,1));

		--Verifier la presence de sous-tache dans la table isac_affectation	- ABN 58299
			BEGIN
				l_erreur := 1;
				SELECT 1 INTO l_exist
					FROM ISAC_AFFECTATION
					WHERE ident=TO_NUMBER(l_ident)
					AND sous_tache=l_sous_tache;
			EXCEPTION
				WHEN NO_DATA_FOUND
				THEN
                  l_erreur := 0;
			END;
			
		--Rechercher si la sous-tâche a déjà un consommé pour le mois
		   BEGIN
			SELECT TO_CHAR(DATDEBEX,'YYYY') INTO l_annee
			FROM DATDEBEX;

			SELECT 1 INTO l_exist
			FROM ISAC_CONSOMME
			WHERE ident=TO_NUMBER(l_ident)
			AND sous_tache=l_sous_tache
			AND TO_CHAR(cdeb,'MM/YYYY')=TO_CHAR(l_mois,'FM00')||'/'||l_annee;

			--Modifier le consommé si le consommé n'est pas nul
		   IF l_conso IS NOT NULL THEN
			UPDATE ISAC_CONSOMME
			SET cusag=TO_NUMBER(l_conso)
			WHERE ident=TO_NUMBER(l_ident)
			AND sous_tache=l_sous_tache
			AND TO_CHAR(cdeb,'MM/YYYY')=TO_CHAR(l_mois,'FM00')||'/'||l_annee;

		   ELSE
			DELETE ISAC_CONSOMME
			WHERE ident=TO_NUMBER(l_ident)
			AND sous_tache=l_sous_tache
			AND TO_CHAR(cdeb,'MM/YYYY')=TO_CHAR(l_mois,'FM00')||'/'||l_annee;

		   END IF;

	   		COMMIT;


	             EXCEPTION
			WHEN NO_DATA_FOUND THEN
			--pas de consommé pour la sous-tâche
			IF ((l_conso!='' OR l_conso IS NOT NULL) AND (l_erreur = 1)) THEN
			   --Ajouter le nouveau consommé
				INSERT INTO ISAC_CONSOMME (ident,pid,ETAPE,TACHE,sous_tache,cdeb,cusag)
				VALUES (TO_NUMBER(l_ident),l_pid,l_etape,l_tache,l_sous_tache,TO_DATE('01/'||TO_CHAR(l_mois,'FM00')||'/'||l_annee,'DD/MM/YYYY'),TO_NUMBER(l_conso));
			END IF;
		   END;

		IF (INSTR(l_ligne,';',l_point4,j+2)=0) THEN
				EXIT;
		END IF;
		END LOOP;

		IF (INSTR(p_chaine,':',1,i+2)=0) THEN
			EXIT;
		END IF;
	END LOOP;
	COMMIT;

END update_conso_chaine;


--*************************************************************************************************
-- Procédure select_ressource
--
-- Permet de vérifier l'existence de la ressource
--
-- Appelée dans la page igconso.htm
--
-- ************************************************************************************************
PROCEDURE select_ressource(	p_ident 	IN VARCHAR2,
			    		p_userid 	IN VARCHAR2,
			    		p_curressource 	IN OUT ressourceCurType,
			    		p_nbpages       OUT VARCHAR2,
                             			p_numpage       OUT VARCHAR2,
					p_menu		OUT VARCHAR2,
                             			p_nbcurseur     OUT INTEGER,
                             			p_message       OUT VARCHAR2
			) IS
-- FAD QC 1921 : modifier l_count NUMBER(3) par l_count NUMBER
l_count NUMBER;
-- FAD QC 1921 : Fin
l_nb_saisie NUMBER;
l_msg VARCHAR2(500);
l_cpident SITU_RESS_FULL.ident%TYPE;
l_datemens DATE;
l_annee DATE;
l_mois_saisie VARCHAR2(10);
l_nbmois NUMBER(2);
l_nbpages  NUMBER(5);
l_menu VARCHAR2(25);
BEGIN

p_numpage := 'NumPage#1';

-- Compter le nombre de sous-tâches pour la ressource
	SELECT COUNT(*) INTO l_count
	FROM ISAC_AFFECTATION
	WHERE ident=TO_NUMBER(p_ident);

 	l_nbpages := CEIL(l_count/10);
         p_nbpages := 'NbPages#'|| l_nbpages;

-- 19/12/2002 : nom du menu courant
	l_menu := Pack_Global.lire_globaldata(p_userid).menutil;
	p_menu := 'Menu#'||l_menu;

-- Nb de mois saisissables
	SELECT cmensuelle,DATDEBEX INTO l_datemens,l_annee
	FROM DATDEBEX;
	--l_mois_saisie := TO_NUMBER(TO_CHAR(ADD_MONTHS(l_datemens,-1),'MM'));

	--PPM 58896 : utilisation directe du datemens sans soustraire 1 mois.
      l_mois_saisie :=TO_CHAR(l_datemens,'MM/YYYY');--PPM 58896
	  l_nbmois :=TO_NUMBER(TO_CHAR(l_datemens,'MM'));--PPM 58896


	  --on compte  le nombre de saisie apres le cmensuelle s'il y on a
	  SELECT COUNT(*) INTO l_nb_saisie
      FROM ISAC_CONSOMME
      WHERE ident=TO_NUMBER(p_ident)
	  AND TO_CHAR(cdeb,'yyyy') = TO_CHAR(l_datemens,'yyyy')
      AND TO_NUMBER(TO_CHAR(cdeb,'MM')) > TO_NUMBER(TO_CHAR(l_datemens,'MM'));--PPM 58896

	--s'il existe des consommés après  la cmensuelle on affiche toute l'année
	IF(l_nb_saisie <> 0)THEN
	   l_nbmois := 12;
	END IF;


	IF l_count=0 THEN
	-- Aucune sous-tâche pour la ressource
		Pack_Isac.recuperer_message( 20005 , NULL, NULL, NULL, l_msg);
         	RAISE_APPLICATION_ERROR(-20005 , l_msg); --On veut récupérer le menu si erreur dans frameisac.htm
	ELSE
	OPEN p_curressource  FOR
	SELECT 	IDENT,
	         	RNOM||' '||RPRENOM||' - '||IDENT RESSOURCE ,
		l_mois_saisie  MOIS,
		l_nbmois  NBMOIS,
		RNOM||' '||RPRENOM KeyList4,
		l_mois_saisie  KeyList5,
		TO_CHAR(l_count) KeyList6
	FROM RESSOURCE
	WHERE ident=TO_NUMBER(p_ident);
	END IF;

	 p_message := l_msg;

END select_ressource;

-------------------------------------------------------------------------------------
--PPM 57865 : couleur_fond_mois

PROCEDURE couleur_fond_mois(	p_ident 	IN VARCHAR2,
			    		p_mois 	IN VARCHAR2,
			    		p_recouv 	OUT VARCHAR2
			    		
      ) IS
l_conso NUMBER;
l_datsitu DATE;
l_datdep DATE;
l_datmois DATE;
BEGIN

-- convertir le mois passé en paramètre à la date du premier jour du mois
l_datmois := TRUNC(to_date('01/'||p_mois, 'DD/MM/YYYY'), 'MONTH');
l_conso := 0;
p_recouv := '1';
BEGIN
-- verification de si le mois est inclus dans la ou les situations de la ressource
SELECT DATSITU, DATDEP into l_datsitu, l_datdep  FROM SITU_RESS 
WHERE IDENT = TO_NUMBER(p_ident) 
AND (
  ( TRUNC(DATSITU, 'MONTH') <= l_datmois AND DATDEP is null) 
OR( TRUNC(DATSITU, 'MONTH') <= l_datmois AND TRUNC(DATDEP, 'MONTH') >= l_datmois ) );

  EXCEPTION
				WHEN NO_DATA_FOUND
				THEN        
          -- verification du consomme du mois 
          SELECT SUM(CUSAG) into l_conso FROM ISAC_CONSOMME
          WHERE IDENT=TO_NUMBER(p_ident)
          AND CDEB = l_datmois;
        -- Cas de consomme de la ressource egale a 0
            IF (l_conso > 0)
              THEN 
                p_recouv := '3'; -- le mois n est pas inclus dans une situation et il a du consomme different à 0
         -- Cas de consomme egale a 0                  
            ELSE
                p_recouv := '4'; -- le mois n est pas inclus dans une situation et il a du consomme egale à 0
            END IF;
END;
  
  --Cas de date fin de situation est nulle ou la date du mois est comprise entre date debut et date fin de situation
    IF ((l_datsitu <= l_datmois AND l_datdep is null) OR (l_datsitu <= l_datmois AND l_datdep >= LAST_DAY(l_datmois)))
      THEN
        p_recouv := '1'; -- recouvrement complet

  ELSE
    IF ((l_datsitu > l_datmois AND TRUNC(l_datsitu, 'MONTH') = l_datmois) OR (l_datdep < LAST_DAY(l_datmois) AND TRUNC(l_datdep, 'MONTH') = l_datmois ))
      THEN
        p_recouv := '2'; -- recouvrement partiel
        ELSE
        -- Sinon pas de revcouvrement
  -- Cas de consomme de la ressource egale a 0
    IF l_conso > 0
      THEN
        p_recouv := '3'; -- le mois n'est pas inclus dans une situation et il a du consomme different a  0
 -- Cas de consomme egale a 0
    ELSE
        p_recouv := '4'; -- le mois n'est pas inclus dans une situation et il a du consomme egale a 0
        END IF;
      END IF;
  END IF;



END couleur_fond_mois;
-- PPM 57865 : couleur_fond_mois

-- FAD PPM 64579 : couleur de fond de l'année
PROCEDURE couleur_fond_annee(	p_ident 	IN VARCHAR2,
			    		p_annee 	IN VARCHAR2,
			    		p_recouv 	OUT VARCHAR2
			    		
      ) IS
	p_mois VARCHAR2(7);
	mois NUMBER;
	p_recouvmois VARCHAR(1);
	l_recouv VARCHAR2(24);
BEGIN
	FOR mois IN 1 .. 12
	LOOP
		p_mois := LPAD(mois, 2, '0') || '/' || p_annee;
		couleur_fond_mois(p_ident, p_mois, p_recouvmois);
		l_recouv := l_recouv || ';' || p_recouvmois;
	END LOOP;
	p_recouv := SUBSTR(l_recouv, 2);
END couleur_fond_annee;
-- FAD PPM 64579 : Fin
END Pack_Isac_Conso ;
/

show errors
