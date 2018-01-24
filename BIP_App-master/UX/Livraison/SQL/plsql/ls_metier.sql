-- pack_liste_metier PL/SQL
--
--
-- Objet  : Permet la création de la liste des metiers
--
--*********************************************************************
-- Modif 30/04/2004 KHA ajout ligne vide dans le curseur. 
--                      Supression des espaces en fin de valeur métier.
-- Modif 08/01/2005 PPR Pointe sur la table METIER au lieu de LIGNE_BIP
--*********************************************************************
-- Attention le nom du package ne peut etre le nom
-- de la table...
--
CREATE OR REPLACE PACKAGE pack_liste_metier AS

   TYPE metier_ListeViewType IS RECORD( id      ligne_bip.metier%TYPE,
					libelle metier.libmetier%TYPE             
                                        );

   TYPE metier_listeCurType IS REF CURSOR RETURN metier_ListeViewType;

   PROCEDURE lister_metier(p_userid  IN VARCHAR2,
                           p_curseur IN OUT metier_listeCurType
                          );
   PROCEDURE lister_metier_tous(p_userid  IN VARCHAR2,
                           p_curseur IN OUT metier_listeCurType
                          );

END pack_liste_metier;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_metier AS 

   PROCEDURE lister_metier (p_userid  IN VARCHAR2,
                            p_curseur IN OUT metier_listeCurType
                           ) IS
   BEGIN


      OPEN p_curseur FOR
      	SELECT '','   '
	FROM dual
	UNION
	SELECT RPAD(metier,3,' ') ,
             libmetier
	FROM metier
	ORDER BY 1 DESC;

   END lister_metier;


   PROCEDURE lister_metier_tous (p_userid  IN VARCHAR2,
                            p_curseur IN OUT metier_listeCurType
                           ) IS
   BEGIN

      OPEN p_curseur FOR
-- HPPM 58337 : Ajout de tous en tête de liste par défaut (dans jsp)


	--SELECT 	' TOUS' metier,
  --		'Tous' libmetier
  --	FROM dual
  --	UNION
      	SELECT '','   '
	FROM dual
	UNION
	SELECT RPAD(metier,3,' ') ,
             libmetier
	FROM metier
	ORDER BY 1 DESC;

   END lister_metier_tous;

END pack_liste_metier;
/
