-- pack_asynchrone PL/SQL
--
-- EQUIPE SOPRA
--
--
-- Gestion des traitements différés
-- 
--
-- cree le 02/12/1999
--
-- modifie le 05/01/2000 - utilisation de la fonction unescape() pour décoder le titre
--
-- modifie le 12/01/2000 - cf. convert.sql
--
-- modifie le 31/01/2000 - création de statut 2 - traitement terminé, fichier non récupérable
--
-- modifie le 18/02/2000 - création d'une nouvelle procédure 'update_async' dédiée au éditions
--
-- modifie le 21/02/2000 - modification de la procedure 'purge_async'
--
-- modifié le 13/12/2001 - procédure qui supprime les traitements terminés ou en erreur
--
-- modifié le 03/06/2003 - Migration RTFE : suppression des références à la table UserBip
-- L'id Arpège est remplacé par VARCHAR(255)
-- modifié le 08/12/2003 - modification de update async(editions) : P_DATE type DATE et non plus varchar2
--
-- modifié le 29/11/2005 JMA - TD320 : Ajout d'une colone ReportId utilisé notament pour détecter si c'est une édition en vue d'un tableau excel
--
-- modifié le 08/02/2006 JMA - TD354 : Ajout de la fonction "liste_delete_async" qui permet de lister les fichiers à supprimer lors de la purge
--
-- modifié le 06/04/2006 JMA - TD385 : Ajout d'une colone IdJobReport utilisé notament pour avoir le id report
--
-- modifié le 07/07/2006 JMA - TD445 : purge uniquement des traitements sélectionnés
--

-- modifier le 15/01/2007 BAA Correction du bug suprression de plusieurs extractions





CREATE OR REPLACE PACKAGE Pack_Asynchrone AS

   TYPE asyncRecType IS RECORD (titre         TRAIT_ASYNCHRONE.titre%TYPE,
                                nom_fichier   VARCHAR2(200),
                                statut        VARCHAR2(100),
                                DATE          VARCHAR2(20),
                                reportid      TRAIT_ASYNCHRONE.REPORTID%TYPE,
								idjobreport      TRAIT_ASYNCHRONE.IDJOBREPORT%TYPE
					 );

   TYPE asyncCurType IS REF CURSOR RETURN asyncRecType ;

   FUNCTION getStatut_async( p_statut IN INTEGER ) RETURN VARCHAR2 ;

   FUNCTION getURL_async( 	p_type        IN VARCHAR2,
				p_statut      IN INTEGER,
				p_nom_fichier IN VARCHAR2 ) RETURN VARCHAR2 ;
   --
   --    WNDS   means "writes no database state" (does not modify database tables).
   --
   --    WNPS   means "writes no package state" (does not change the values of packaged variables).
   --
   --    RNDS   means "reads no database state" (does not query database tables).
   --
   --    RNPS   means "reads no package state" (does not reference the values of packaged variables).
   --
   PRAGMA RESTRICT_REFERENCES (getStatut_async, WNDS, WNPS, RNDS, RNPS);
   PRAGMA RESTRICT_REFERENCES (getURL_async, WNDS, WNPS, RNDS, RNPS);


   --
   -- Gestion des extractions
   --
   PROCEDURE update_async( 	p_global      IN VARCHAR2,
                           	p_type        IN VARCHAR2,
			        p_titre       IN VARCHAR2,
			        p_nom_fichier IN VARCHAR2,
			        p_statut      IN INTEGER,
			        p_reportid    IN VARCHAR2,
					p_idjobreport   IN VARCHAR2,
			        p_message     OUT VARCHAR2
			       );

   --
   -- Gestion des éditions
   --
   PROCEDURE update_async( p_global                IN VARCHAR2,
                           p_type                  IN VARCHAR2,
                           p_titre                 IN VARCHAR2,
                           p_nom_fichier_initial   IN VARCHAR2,
                           p_date                  IN DATE,
                           p_nom_fichier_final     IN VARCHAR2,
                           p_statut                IN INTEGER,
			        	   p_reportid    		   IN VARCHAR2,
						   p_idjobreport    IN VARCHAR2,
                           p_message               OUT VARCHAR2
                         );

   PROCEDURE select_async( p_type        IN VARCHAR2,
                           p_global      IN VARCHAR2,
                           p_curseur     IN OUT asyncCurType,
			   p_message     OUT VARCHAR2
			       );
   PROCEDURE DELete_async(
			   p_type        IN VARCHAR2,
			   p_global      IN VARCHAR2,
			   p_file2delete IN VARCHAR2,
			   p_message     OUT VARCHAR2
			   );

   PROCEDURE purge_async(  p_delai       IN INTEGER,
			   p_type        IN VARCHAR2
			       );


   PROCEDURE liste_delete_async( p_type        IN VARCHAR2,
                           		 p_global      IN VARCHAR2,
                           		 p_curseur     IN OUT asyncCurType,
			   			   		 p_message     OUT VARCHAR2
			       		 		 );

END Pack_Asynchrone ;
/





CREATE OR REPLACE PACKAGE BODY Pack_Asynchrone AS

-------------------------------------------------------------------
--
------------------------------------------------------------------

   FUNCTION getStatut_async( p_statut IN INTEGER ) RETURN VARCHAR2 IS

      l_statut VARCHAR2(100);

   BEGIN
	IF (p_statut = -1) THEN
	   l_statut := 'Erreur';

	ELSIF (p_statut = 0) THEN
	   l_statut := 'En cours';

	ELSIF (p_statut = 1) THEN
	   l_statut := 'Terminé';

	ELSIF (p_statut = 2) THEN
	   l_statut := 'Terminé';

	ELSE
	   l_statut := '';

	END IF;

	RETURN l_statut;

   END getStatut_async;


-------------------------------------------------------------------
--
------------------------------------------------------------------

   FUNCTION getURL_async( p_type        IN VARCHAR2,
			  p_statut      IN INTEGER,
			  p_nom_fichier IN VARCHAR2 ) RETURN VARCHAR2 IS

	l_pos1	INTEGER;
	l_pos2	INTEGER;
	l_base_name TRAIT_ASYNCHRONE.nom_fichier%TYPE;
      l_URL		VARCHAR2(1024);
	l_image	VARCHAR2(50) := '<img src="images/fileatt.gif" border=0>';

   BEGIN
	IF (p_type = 'E') THEN
	   --
	   -- Edition, p_nom_fichier ~= http://192.16.238.123:8000/reports/35690393.htm
	   --
	   IF (p_statut = 1) THEN
		l_URL := '<a href="' || p_nom_fichier || '">' || l_image || '</a>';
	   ELSE
		l_URL := '';
	   END IF;

	   RETURN l_URL;

	ELSIF (p_type = 'X') THEN
	   --
	   -- Extraction, p_nom_fichier ~= S935710.BIPTACHE.DOC
	   --
	   l_pos1 := INSTR( p_nom_fichier, '.', 1, 1);

         l_pos2 := INSTR( p_nom_fichier, '.', 1, 2);

         l_base_name := SUBSTR( p_nom_fichier, l_pos1 + 1, l_pos2 - l_pos1 - 1);		-- BIPTACHE

	   IF (p_statut = 1) THEN
		l_URL := '<a href="download.htm?File=' || p_nom_fichier || '">' || l_image || '<br>' || l_base_name || '</a>' ;
	   ELSE
		l_URL := l_base_name;
	   END IF;

	   RETURN l_URL;

	ELSIF (p_type = 'U') THEN
	   --
	   -- Upload, p_nom_fichier ~= ???
	   --
	   RETURN '';

	ELSE
	   RETURN '';

	END IF;

   END getURL_async;


-------------------------------------------------------------------
--
-------------------------------------------------------------------

   PROCEDURE update_async( p_global      IN VARCHAR2,
                           p_type        IN VARCHAR2,
			   p_titre       IN VARCHAR2,
			   p_nom_fichier IN VARCHAR2,
			   p_statut      IN INTEGER,
	           p_reportid    IN VARCHAR2,
			   p_idjobreport    IN VARCHAR2,
			   p_message     OUT VARCHAR2
			       ) IS

	l_msg       VARCHAR2(1024);
	l_idarpege  VARCHAR2(255);
	l_nb        NUMBER;
	l_titre	TRAIT_ASYNCHRONE.titre%TYPE;
   BEGIN

	-- Initialiser le message retour

	p_message  := '';

	l_idarpege := Pack_Global.lire_globaldata(p_global).idarpege;

	l_titre    := Pack_Conversion.unescape(p_titre);

	BEGIN
	   SELECT COUNT(statut)
	   INTO   l_nb
	   FROM   TRAIT_ASYNCHRONE
	   WHERE  userid      = l_idarpege
	   AND    TYPE        = p_type
	   AND    titre       = l_titre
	   AND    nom_fichier = p_nom_fichier;

	   IF ( (l_nb IS NULL) OR (l_nb = 0) ) THEN
		--
		-- Pas de ligne, donc INSERT
		--
		BEGIN
		   INSERT INTO TRAIT_ASYNCHRONE( userid,
							   TYPE,
							   titre,
							   nom_fichier,
							   statut,
							   date_trait,
							   reportid,
							   idjobreport
							 )
		   VALUES ( l_idarpege,
				p_type,
				l_titre,
				p_nom_fichier,
				p_statut,
				SYSDATE,
				p_reportid,
				p_idjobreport
			     );
		COMMIT;

		EXCEPTION
		   WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR( -20997, SQLERRM);
		END;
	   ELSE
		--
		-- Ligne existante, donc UPDATE
		--
		BEGIN
		   UPDATE TRAIT_ASYNCHRONE
			SET statut     = p_statut,
			    date_trait = SYSDATE
		   WHERE  userid      = l_idarpege
		   AND    TYPE        = p_type
		   AND    titre       = l_titre
		   AND    nom_fichier = p_nom_fichier;

		   COMMIT;

		EXCEPTION
		   WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR( -20997, SQLERRM);
		END;
	   END IF;


	EXCEPTION
	   WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR( -20997, SQLERRM);

	END;

   END update_async;


-------------------------------------------------------------------
--
-------------------------------------------------------------------

   PROCEDURE update_async( p_global                IN VARCHAR2,
                           p_type                  IN VARCHAR2,
                           p_titre                 IN VARCHAR2,
                           p_nom_fichier_initial   IN VARCHAR2,
                           p_date                  IN DATE,
                           p_nom_fichier_final     IN VARCHAR2,
                           p_statut                IN INTEGER,
						   p_reportid			   IN VARCHAR2,
						   p_idjobreport			   IN VARCHAR2,
                           p_message               OUT VARCHAR2
                         ) IS

	l_msg           VARCHAR2(1024);
	l_idarpege      VARCHAR2(255);
	l_nb            NUMBER;
	l_titre         TRAIT_ASYNCHRONE.titre%TYPE;
	l_nom_fichier   TRAIT_ASYNCHRONE.nom_fichier%TYPE;

	--L_RETCOD	NUMBER;
	--L_HFILE	utl_file.file_type;
	BEGIN
		--L_RETCOD := TRCLOG.INITTRCLOG( '/projet/bip/devwl/bipdata/batch' , 'ZZZZZZZ', L_HFILE );
		-- Initialiser le message retour
		p_message     := '';

		l_idarpege    := Pack_Global.lire_globaldata(p_global).idarpege;

		l_titre       := Pack_Conversion.unescape(p_titre);

		l_nom_fichier := p_nom_fichier_initial || '@' || p_date;

		BEGIN
			IF ( p_statut = 0 ) THEN
			--
			-- Lancement de l'edition, donc INSERT
			--
				BEGIN
					INSERT INTO TRAIT_ASYNCHRONE(	userid,
													TYPE,
													titre,
													nom_fichier,
													statut,
													date_trait,
													reportid,
													idjobreport )
					VALUES (	l_idarpege,
								p_type,
								l_titre,
								l_nom_fichier,
								p_statut,
								P_DATE,
								p_reportid,
								p_idjobreport);
					COMMIT;

					EXCEPTION
					WHEN OTHERS THEN
					RAISE_APPLICATION_ERROR( -20997, SQLERRM);
				END;
			ELSE
    	--
		-- Edition terminee ou en erreur, donc UPDATE
		--
			BEGIN
--				TRCLOG.TRCLOG( L_HFILE, 'P_GLOBAL : ' || P_GLOBAL);
--				TRCLOG.TRCLOG( L_HFILE, 'P_TYPE : ' || P_TYPE);
--				TRCLOG.TRCLOG( L_HFILE, 'P_TITRE : ' || P_TITRE);
--				TRCLOG.TRCLOG( L_HFILE, 'P_NOM_FICHIER_INITIAL : ' || P_NOM_FICHIER_INITIAL);
--				TRCLOG.TRCLOG( L_HFILE, 'P_DATE : ' || P_DATE);
--				TRCLOG.TRCLOG( L_HFILE, 'P_NOM_FICHIER_FINAL : ' || P_NOM_FICHIER_FINAL);
--				TRCLOG.TRCLOG( L_HFILE, 'P_STATUT : ' || P_STATUT);
--				TRCLOG.TRCLOG( L_HFILE, 'L_NOM_FICHIER : ' || L_NOM_FICHIER);
				UPDATE TRAIT_ASYNCHRONE
					SET
						statut	= p_statut,
						date_trait	= SYSDATE,
						nom_fichier	= p_nom_fichier_final
					WHERE
						userid	= l_idarpege
					AND TYPE	= p_type
					AND titre	= l_titre
					AND nom_fichier = l_nom_fichier;

				--TRCLOG.TRCLOG( L_HFILE, 'nb enr : ' || SQL%ROWCOUNT);
				COMMIT;

				--TRCLOG.CLOSETRCLOG( L_HFILE );
				EXCEPTION
					WHEN OTHERS THEN
						--TRCLOG.CLOSETRCLOG( L_HFILE );
						RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	            END;

			END IF;
		EXCEPTION
			WHEN OTHERS THEN
				--TRCLOG.CLOSETRCLOG( L_HFILE );
				RAISE_APPLICATION_ERROR( -20997, SQLERRM);
		END;

	END update_async;

-------------------------------------------------------------------
--
------------------------------------------------------------------

   PROCEDURE select_async( p_type        IN VARCHAR2,
                           p_global      IN VARCHAR2,
                           p_curseur     IN OUT asyncCurType,
			   p_message     OUT VARCHAR2
			       ) IS

	l_idarpege  VARCHAR2(255);

   BEGIN

	-- Initialiser le message retour

	p_message := '';

	l_idarpege := Pack_Global.lire_globaldata(p_global).idarpege;

	OPEN p_curseur FOR

	SELECT	titre,
			--pack_asynchrone.getURL_async( type, statut, nom_fichier ),
			nom_fichier,
			Pack_Asynchrone.getStatut_async( statut ),
			TO_CHAR(date_trait,'DD/MM/YYYY HH24:MI'),
			reportid,
			idjobreport
	FROM		TRAIT_ASYNCHRONE
	WHERE		userid = l_idarpege
	  AND		TYPE   = p_type
	ORDER BY	date_trait DESC;

   END select_async;

-------------------------------------------------------------------
--      PURGE DES TRAITEMENTS 
------------------------------------------------------------------

PROCEDURE delete_async( p_type        IN VARCHAR2,
                        p_global      IN VARCHAR2,
			   			p_file2delete IN VARCHAR2,
			   			p_message        OUT VARCHAR2
			          ) IS

	l_idarpege  VARCHAR2(255);
	l_sysdate   DATE;
	l_requete   VARCHAR2(32000);
BEGIN

	p_message := '';
	l_idarpege := Pack_Global.lire_globaldata(p_global).idarpege;
	l_sysdate := SYSDATE;
	BEGIN
	
	    l_requete := 'DELETE TRAIT_ASYNCHRONE '||
	   			 	 ' WHERE TYPE   = '''||p_type||''''||
	   				 '   AND userid = '''||l_idarpege||''''||
					 '   AND NOM_FICHIER in ('||p_file2delete||')';
					
	    EXECUTE IMMEDIATE l_requete;

	    COMMIT;

	EXCEPTION
	   WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;

END delete_async;

-------------------------------------------------------------------
--
------------------------------------------------------------------

   PROCEDURE purge_async( p_delai    IN INTEGER,
			  p_type     IN VARCHAR2
			      ) IS

   BEGIN

	BEGIN
	   DELETE TRAIT_ASYNCHRONE
	   WHERE  TYPE       = p_type
	   AND    date_trait < ( TRUNC(SYSDATE) - p_delai );

	   COMMIT;

	EXCEPTION
	   WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;

   END purge_async;




-------------------------------------------------------------------
-- liste_delete_async : Fonction listant le fichier à supprimer
------------------------------------------------------------------

PROCEDURE liste_delete_async( p_type        IN VARCHAR2,
                           	  p_global      IN VARCHAR2,
                           	  p_curseur     IN OUT asyncCurType,
			   				  p_message     OUT VARCHAR2
			       			) IS
	l_idarpege  VARCHAR2(255);
BEGIN

	-- Initialiser le message retour
	p_message := '';
	l_idarpege := Pack_Global.lire_globaldata(p_global).idarpege;

	OPEN p_curseur FOR
		SELECT titre,
			   nom_fichier,
			   Pack_Asynchrone.getStatut_async( statut ),
			   TO_CHAR(date_trait,'DD/MM/YYYY HH24:MI'),
			   reportid,
			   idjobreport
		  FROM TRAIT_ASYNCHRONE
	     WHERE TYPE = p_type
	   	   AND (statut = 1 OR statut = -1)
	   	   AND date_trait < TRUNC(SYSDATE)
	   	   AND userid = l_idarpege
      ORDER BY date_trait DESC;

END liste_delete_async;


END Pack_Asynchrone ;
/

