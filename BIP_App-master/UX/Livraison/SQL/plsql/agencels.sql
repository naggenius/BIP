-- pack_liste_agence PL/SQL
-- 
-- Equipe SOPRA
--
-- Créé le 08/03/1999
--
--
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_agence AS

   TYPE Agence_ListeViewType IS RECORD( id      agence.socfour%TYPE,
					libelle CHAR(40)          
                                      );

   TYPE agence_listeCurType IS REF CURSOR RETURN Agence_ListeViewType;

   PROCEDURE lister_agence( p_soccode   IN agence.soccode%TYPE,
                            p_curseur   IN OUT agence_listeCurType
                          );

END pack_liste_agence;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_agence AS 

   PROCEDURE lister_agence ( p_soccode IN agence.soccode%TYPE,
			     p_curseur IN OUT agence_listeCurType
                           ) IS
   BEGIN

      OPEN p_curseur FOR 
	SELECT socfour,
	       rpad( socfour, 15, ' ')  ||
		 rpad( socflib, 25, ' ') 
	FROM 	 agence
	WHERE  soccode = p_soccode;

   END lister_agence;

END pack_liste_agence;
/
