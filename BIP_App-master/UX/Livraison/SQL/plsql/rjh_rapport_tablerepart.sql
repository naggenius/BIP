CREATE OR REPLACE PACKAGE PACK_RJH_RAPPORT AS

   -- Définition curseur sur la table RJH_CHARGEMENT
   TYPE LoadTableRepart_ViewType IS RECORD ( codchr  RJH_CHARGEMENT.CODCHR%TYPE,
   								 		     codrep  RJH_CHARGEMENT.CODREP%TYPE,
   							 		   	 	 moisrep VARCHAR2(10),
										 	 fichier RJH_CHARGEMENT.FICHIER%TYPE,
										 	 statut  RJH_CHARGEMENT.STATUT%TYPE,
										 	 datechg VARCHAR2(20),
											 moisfin VARCHAR2(10)
									       );

   TYPE load_tablerepartCurType IS REF CURSOR RETURN LoadTableRepart_ViewType;

-- ----------------------------------------------------------------------
-- Procédure qui ramène tous les chargements pour un utilisateur
-- ----------------------------------------------------------------------
   PROCEDURE select_all_rapport ( p_userid     IN     VARCHAR2,
							      p_curseur    IN OUT load_tablerepartCurType,
                               	  p_nbcurseur     OUT INTEGER,
                               	  p_message       OUT VARCHAR2
                          		);

-- ----------------------------------------------------------------------
-- Procédure qui ramène un chargement
-- ----------------------------------------------------------------------
   PROCEDURE select_rapport ( p_codchr     IN     NUMBER,
							  p_curseur    IN OUT load_tablerepartCurType,
                              p_nbcurseur     OUT INTEGER,
                              p_message       OUT VARCHAR2
                          	);

-- ----------------------------------------------------------------------------------------
-- Procédure qui supprime le rapport sélectionné
-- ----------------------------------------------------------------------------------------
   PROCEDURE delete_rapport ( p_codchr      IN  NUMBER,
   			 				  p_userid     	IN  VARCHAR2,
                              p_nbcurseur  	OUT INTEGER,
                              p_message    	OUT VARCHAR2
                          	);

-- ----------------------------------------------------------------------------------------
-- Procédure qui supprime tous les chargments pour un utilisateur sauf ceux du jour
-- ----------------------------------------------------------------------------------------
   PROCEDURE delete_all_rapport ( p_userid     	IN  VARCHAR2,
                            	  p_nbcurseur  	OUT INTEGER,
                            	  p_message    	OUT VARCHAR2
                          		);



-- Définition curseur sur la table RJH_TABREPART_DETAIL
   TYPE TableRepartDetail_ViewType IS RECORD ( codrep  RJH_TABREPART_DETAIL.CODREP%TYPE,
   							 		   	 	   moisrep VARCHAR2(10),
										 	   pid     RJH_TABREPART_DETAIL.PID%TYPE,
										 	   libPID  LIGNE_BIP.PNOM%TYPE,
   							 		   	 	   tauxrep VARCHAR2(10),
										 	   libelle RJH_TABREPART_DETAIL.LIBLIGNEREP%TYPE,
										 	   codcamo LIGNE_BIP.CODCAMO%TYPE,
										 	   libCA   CENTRE_ACTIVITE.CLIBRCA%TYPE
									         );

   TYPE tablerepartDetailCurType IS REF CURSOR RETURN TableRepartDetail_ViewType;
-- ----------------------------------------------------------------------
-- Procédure qui ramène le détail d'une table
-- ----------------------------------------------------------------------
   PROCEDURE select_detail ( p_codrep     IN     VARCHAR2,
							 p_moisrep    IN     VARCHAR2,
							 p_curseur    IN OUT tablerepartDetailCurType,
                             p_nbcurseur     OUT INTEGER,
                             p_message       OUT VARCHAR2
                          	);



-- Définition curseur sur la table RJH_CHARGEMENT
   TYPE LoadTableRepartErreur_ViewType IS RECORD ( codchr    RJH_CHARG_ERREUR.CODCHR%TYPE,
   								 		     	   numligne  RJH_CHARG_ERREUR.NUMLIGNE%TYPE,
   								 		     	   txtligne  RJH_CHARG_ERREUR.TXTLIGNE%TYPE,
   								 		     	   liberr    RJH_CHARG_ERREUR.LIBERR%TYPE
									       		 );

   TYPE load_Erreur_tablerepartCurType IS REF CURSOR RETURN LoadTableRepartErreur_ViewType;
-- ----------------------------------------------------------------------
-- Procédure qui ramène les erreurs d'un chargement
-- ----------------------------------------------------------------------
   PROCEDURE select_erreur ( p_codchr     IN     NUMBER,
					         p_curseur    IN OUT load_Erreur_tablerepartCurType,
                             p_nbcurseur     OUT INTEGER,
                             p_message       OUT VARCHAR2
                           );


END PACK_RJH_RAPPORT;
/





CREATE OR REPLACE PACKAGE BODY PACK_RJH_RAPPORT AS



-- ----------------------------------------------------------------------
-- Procédure qui ramène tous les chargements pour un utilisateur
-- ----------------------------------------------------------------------
PROCEDURE select_all_rapport ( p_userid   IN     VARCHAR2,
							   p_curseur  IN OUT load_tablerepartCurType,
                               p_nbcurseur         OUT INTEGER,
                               p_message           OUT VARCHAR2
                              ) IS

	l_msg    VARCHAR2(1024);
    l_userid VARCHAR2(20);
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
    p_nbcurseur := 1;
    p_message := '';

   	-- Récupérer l'identifiant de l'utilisateur
   	l_userid := pack_global.lire_globaldata(p_userid).idarpege;

	OPEN p_curseur FOR
	    SELECT codchr, codrep, to_char(moisrep,'mm/yyyy'), fichier, statut, to_char(datechg,'dd/mm/yyyy HH24:mi'), to_char(moisrep,'mm/yyyy')
	      FROM RJH_CHARGEMENT
	     WHERE userid = l_userid
	     ORDER BY datechg desc;


EXCEPTION
    WHEN OTHERS THEN
		raise_application_error(-20997, SQLERRM);

END select_all_rapport;




-- ----------------------------------------------------------------------
-- Procédure qui ramène un chargement
-- ----------------------------------------------------------------------
PROCEDURE select_rapport ( p_codchr     IN     NUMBER,
						   p_curseur    IN OUT load_tablerepartCurType,
                           p_nbcurseur     OUT INTEGER,
                           p_message       OUT VARCHAR2
                         ) IS
	l_msg    VARCHAR2(1024);
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
    p_nbcurseur := 1;
    p_message := '';

	OPEN p_curseur FOR
	    SELECT codchr, codrep, to_char(moisrep,'mm/yyyy'), fichier, statut, to_char(datechg,'dd/mm/yyyy HH24:mi'), to_char(moisfin,'mm/yyyy')
	      FROM RJH_CHARGEMENT
	     WHERE codchr = p_codchr;

EXCEPTION
    WHEN OTHERS THEN
		raise_application_error(-20997, SQLERRM);

END select_rapport;




-- ----------------------------------------------------------------------------------------
-- Procédure qui supprime le rapport sélectionné
-- ----------------------------------------------------------------------------------------
PROCEDURE delete_rapport ( p_codchr     IN  NUMBER,
   			 			   p_userid     IN  VARCHAR2,
                           p_nbcurseur  OUT INTEGER,
                           p_message    OUT VARCHAR2
                        ) IS
	l_msg VARCHAR2(1024);
    referential_integrity EXCEPTION;
    PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';

	BEGIN
		-- suppression de la table des erreurs
	    DELETE FROM RJH_CHARG_ERREUR
		 WHERE codchr = p_codchr;

		-- suppression de la table des chargements
	    DELETE FROM RJH_CHARGEMENT
		 WHERE codchr = p_codchr;

    EXCEPTION
		WHEN referential_integrity THEN
            -- habiller le msg erreur
            pack_global.recuperation_integrite(-2292);
		WHEN OTHERS THEN
		    raise_application_error( -20997, SQLERRM);
    END;

END delete_rapport;




-- ----------------------------------------------------------------------------------------
-- Procédure qui supprime tous les chargments pour un utilisateur sauf ceux du jour
-- ----------------------------------------------------------------------------------------
PROCEDURE delete_all_rapport ( p_userid     	IN  VARCHAR2,
                           	   p_nbcurseur  	OUT INTEGER,
                           	   p_message    	OUT VARCHAR2
							 ) IS
	l_msg VARCHAR2(1024);
    referential_integrity EXCEPTION;
    PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
    l_userid VARCHAR2(255);
BEGIN
   	-- Récupérer l'identifiant de l'utilisateur
   	l_userid := pack_global.lire_globaldata(p_userid).idarpege;

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';

	BEGIN
		-- suppression de la table des erreurs
	    DELETE FROM RJH_CHARG_ERREUR
		 WHERE codchr in (SELECT codchr
		                    FROM RJH_CHARGEMENT
						   WHERE userid = l_userid
						     AND trunc(datechg) < trunc(sysdate) );

		-- suppression de la table des chargements
	    DELETE FROM RJH_CHARGEMENT
	     WHERE userid = l_userid
		   AND trunc(datechg) < trunc(sysdate);

    EXCEPTION
		WHEN referential_integrity THEN
            -- habiller le msg erreur
            pack_global.recuperation_integrite(-2292);
		WHEN OTHERS THEN
		    raise_application_error( -20997, SQLERRM);
    END;

END delete_all_rapport;




-- ----------------------------------------------------------------------
-- Procédure qui ramène le détail d'une table
-- ----------------------------------------------------------------------
PROCEDURE select_detail ( p_codrep     IN     VARCHAR2,
						  p_moisrep    IN     VARCHAR2,
						  p_curseur    IN OUT tablerepartDetailCurType,
                          p_nbcurseur     OUT INTEGER,
                          p_message       OUT VARCHAR2
                        ) IS
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
    p_nbcurseur := 1;
    p_message := '';

	OPEN p_curseur FOR
	    SELECT d.CODREP, d.MOISREP, d.PID, l.PNOM , d.TAUXREP, d.LIBLIGNEREP , l.CODCAMO, c.CLIBRCA
	      FROM RJH_TABREPART_DETAIL d, LIGNE_BIP l, CENTRE_ACTIVITE c
	     WHERE d.codrep = p_codrep
		   AND to_char(d.moisrep,'mm/yyyy') = p_moisrep
		   AND d.PID = l.PID
		   AND l.CODCAMO = c.CODCAMO
	     ORDER BY d.LIBLIGNEREP;

EXCEPTION
    WHEN OTHERS THEN
		raise_application_error(-20997, SQLERRM);

END select_detail;





-- ----------------------------------------------------------------------
-- Procédure qui ramène les erreurs d'un chargement
-- ----------------------------------------------------------------------
PROCEDURE select_erreur ( p_codchr     IN     NUMBER,
				          p_curseur    IN OUT load_Erreur_tablerepartCurType,
                          p_nbcurseur     OUT INTEGER,
                          p_message       OUT VARCHAR2
                        ) IS
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
    p_nbcurseur := 1;
    p_message := '';

	OPEN p_curseur FOR
	    SELECT e.CODCHR, e.NUMLIGNE, e.TXTLIGNE, e.LIBERR
	      FROM RJH_CHARG_ERREUR e
	     WHERE e.CODCHR = p_codchr
	     ORDER BY e.NUMLIGNE;

EXCEPTION
    WHEN OTHERS THEN
		raise_application_error(-20997, SQLERRM);

END select_erreur;

END PACK_RJH_RAPPORT;
/

