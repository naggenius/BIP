-- pack_liste_departement PL/SQL
--
-- EJE
-- Crée le 12/04/2005
--
-- Objet  : Permet la création de la liste des departements
-- Table  : client_mo
--
-- Modifie le 26/04/2006 par PPR : ajout d'une liste de départements "ME" (issu de struct_info)
--*********************************************************************

--
CREATE OR REPLACE PACKAGE pack_liste_departement AS

TYPE departement_ListeViewType IS RECORD( id      VARCHAR2(5),
			            libelle CHAR(40)          
                                        );

TYPE departement_listeCurType IS REF CURSOR RETURN departement_ListeViewType;

PROCEDURE lister_departement(p_curseur IN OUT departement_listeCurType
                                 );

PROCEDURE lister_departement_me(p_curseur IN OUT departement_listeCurType
                                 );
END pack_liste_departement;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_departement AS 

   PROCEDURE lister_departement(p_curseur IN OUT departement_listeCurType
                                  ) IS

   BEGIN

      OPEN p_curseur FOR 
 	SELECT clicode id,
             clilib libelle
	FROM client_mo
	WHERE CLIPOL = 0
	and CLIDEP <> 0
	order by libelle;

   END lister_departement;

   PROCEDURE lister_departement_me(p_curseur IN OUT departement_listeCurType
                                  ) IS

   BEGIN

    OPEN p_curseur FOR 
 	SELECT DISTINCT s.coddep id,
             d.libdir ||'/'||s.sigdep libelle
	FROM struct_info s , directions d
	WHERE s.coddir = d.coddir
	and s.topfer='O'
	order by libelle;

   END lister_departement_me;

END pack_liste_departement;
/


