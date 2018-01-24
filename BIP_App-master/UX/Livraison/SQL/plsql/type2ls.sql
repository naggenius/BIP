-- pack_liste_type_activite PL/SQL
-- Equipe SOPRA
-- Cr‰e le 24/02/1999
--
-- Objet  : Permet la cr‰ation de la liste des types d'activit‰s 
--          des projets 
-- Table  : type_activite
-- PJO 16/06/2004 : Fiche 308 : La liste affich‰ d‰pend de la typologie primaire.
-- PJO 21/06/2004 : Fiche 308 : Construction d'une liste qui contient toutes les infos
--
-- Le 11/07/2005 par DDI : Fiche 226 : Passage du type2 sur 3 caractères
--*************************************************************************************

CREATE OR REPLACE PACKAGE pack_liste_type_activite AS

   TYPE Activite_ListeViewType IS RECORD( id      type_activite.arctype%TYPE,
					  libelle VARCHAR2(33)       
                                        );

   TYPE activite_listeCurType IS REF CURSOR RETURN Activite_ListeViewType;

   PROCEDURE lister_type_activite(p_userid  IN VARCHAR2,
   				  p_typproj IN VARCHAR2,
                                  p_curseur IN OUT activite_listeCurType
                                 );
   
   PROCEDURE lister_type2(p_userid  IN VARCHAR2,
                                  p_curseur IN OUT activite_listeCurType
                                 );

END pack_liste_type_activite;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_type_activite AS 

   PROCEDURE lister_type_activite (p_userid  IN VARCHAR2,
   				   p_typproj IN VARCHAR2,
                                   p_curseur IN OUT activite_listeCurType
                                  ) IS
    
l_menutil 	VARCHAR2(100);
   BEGIN
      
      l_menutil := pack_global.lire_globaldata(p_userid).menutil;
     
      OPEN p_curseur FOR 
        -- Ligne vide en haut
        SELECT '', 
               ' ' libelle
        FROM DUAL
        UNION
        SELECT arctype,
             rpad( arctype, 3, ' ') || libarc libelle
	FROM type_activite, lien_types_proj_act
	WHERE type_act = arctype
	  AND type_proj=RPAD(p_typproj, 2, ' ')
	  -- Type d'activit‰ actif
	  AND actif='O'
	  -- Il n'est pas possible de saisir un grand T1
	  AND (type_act <> 'T1' OR l_menutil = 'DIR')
	ORDER BY libelle;

   END lister_type_activite;

   PROCEDURE lister_type2	 (p_userid  IN VARCHAR2,
                                  p_curseur IN OUT activite_listeCurType
                                  ) IS
    
   BEGIN
     
      OPEN p_curseur FOR 
        -- Ligne vide en haut
        SELECT arctype,
             rpad( arctype, 3, ' ') || ' - ' || libarc || DECODE(actif, 'O', ' - ACTIF', '') libelle
	FROM type_activite
	ORDER BY libelle;

   END lister_type2;

END pack_liste_type_activite;
/
