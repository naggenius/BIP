CREATE OR REPLACE PACKAGE pack_liste_investissements AS

   PROCEDURE lister_type(p_userid  IN VARCHAR2,
             	       p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );

	PROCEDURE lister_ligne_inv(	p_userid  IN VARCHAR2,
								p_codcamo IN VARCHAR2,--LIGNE_INVESTISSEMENT.CODCAMO%TYPE,
								p_annee   IN VARCHAR2,--LIGNE_INVESTISSEMENT.ANNEE%TYPE,
								p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );


END pack_liste_investissements;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_investissements AS

PROCEDURE lister_type(p_userid  IN VARCHAR2,
             		p_curseur IN OUT pack_liste_dynamique.liste_dyn
            ) IS

BEGIN

   ---- recherche niveau du ca

    OPEN p_curseur FOR
    SELECT
    codtype,
    lib_type
	FROM investissements
	ORDER BY lib_type;

   EXCEPTION

       --WHEN NO_DATA_FOUND THEN BEGIN END;

       WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);

   END lister_type;

PROCEDURE lister_ligne_inv(	p_userid  IN VARCHAR2,
								p_codcamo IN VARCHAR2,--LIGNE_INVESTISSEMENT.CODCAMO%TYPE,
								p_annee   IN VARCHAR2,--LIGNE_INVESTISSEMENT.ANNEE%TYPE,
								p_curseur IN OUT pack_liste_dynamique.liste_dyn
								) IS
BEGIN
	OPEN p_curseur FOR
	SELECT
		codinv,
		codinv || ' - ' || libelle
	FROM
		LIGNE_INVESTISSEMENT
	WHERE
		to_char(CODCAMO) = p_codcamo
	AND to_char(ANNEE) = p_annee;

	EXCEPTION
       --WHEN NO_DATA_FOUND THEN BEGIN END;
       WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);

END lister_ligne_inv;


END pack_liste_investissements;
/

