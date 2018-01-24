-- pack_liste_parametre PL/SQL
--
--
-- Objet  : liste les differents paremetres de la table PARAMETRE
-- Table  : oui
--
--
--*********************************************************************
-- Creation : 21/02/2005 Evode GREVREND
--*********************************************************************
--
CREATE OR REPLACE PACKAGE pack_liste_parametre AS

   TYPE parametre_ListeViewType IS RECORD(	CLE			parametre.CLE%TYPE,
   											LIBELLE		parametre.LIBELLE%TYPE);

   TYPE parametre_listeCurType IS REF CURSOR RETURN parametre_ListeViewType;

   PROCEDURE lister_parametre( p_curseur IN OUT parametre_listeCurType );

END pack_liste_parametre;
/


CREATE OR REPLACE PACKAGE BODY pack_liste_parametre AS

   PROCEDURE lister_parametre (p_curseur IN OUT parametre_listeCurType ) IS
   BEGIN

      OPEN p_curseur FOR
        SELECT
       		cle,
       		libelle
        FROM
        	parametre
        ORDER BY Libelle;

   END lister_parametre;



END pack_liste_parametre;
/
