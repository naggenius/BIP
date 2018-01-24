--------------------------------------------------------
--  Fichier créé - lundi-octobre-10-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_LISTE_SOUS_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BIP"."PACK_LISTE_SOUS_TYPE" AS
   TYPE Projet_ListeViewType IS RECORD( id      sous_typologie.sous_type%TYPE,
					libelle VARCHAR2(33)
                                        );
   TYPE projet_listeCurType IS REF CURSOR RETURN Projet_ListeViewType;

   PROCEDURE lister_sous_typo (p_userid  IN VARCHAR2,
   				   p_sous_typo IN VARCHAR2,
                                   p_curseur IN OUT projet_listeCurType);


END pack_liste_sous_type;

 

/
--------------------------------------------------------
--  DDL for Package Body PACK_LISTE_SOUS_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "BIP"."PACK_LISTE_SOUS_TYPE" AS

    PROCEDURE lister_sous_typo (p_userid  IN VARCHAR2,
   				   p_sous_typo IN VARCHAR2,
                                   p_curseur IN OUT projet_listeCurType
                                  ) IS

l_menutil 	VARCHAR2(100);
   BEGIN
      l_menutil := pack_global.lire_globaldata(p_userid).menutil;

      OPEN p_curseur FOR

      --Ligne vide en haut
        SELECT '',
               ' ' libelle
        FROM dual
       UNION
        SELECT sous_type,
             rpad( sous_type, 3, ' ') ||' '|| libsoustype libelle
	FROM sous_typologie
	ORDER BY libelle;

   END lister_sous_typo;

END pack_liste_sous_type;

/
