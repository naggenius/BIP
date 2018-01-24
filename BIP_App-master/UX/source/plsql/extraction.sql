/*
Nom	PACK_LISTE_EXTRACTION
Auteur	Olivier Duprey
But	Package d'extractions parametrables, dont la DEFINITION est stockee en base
QUAND	QUI	QUOI
07/2001	ODu	Creation du PACKAGE
09/2003  NBM      ajout liste_extraction
04/2005  PPR      ajout de l'impact des sous menus
*/
CREATE OR REPLACE PACKAGE pack_liste_extraction IS


	PROCEDURE Lister_Extraction(
		p_userid	IN	CHAR,
		p_curseur	IN OUT	pack_liste_dynamique.liste_dyn
	);

END pack_liste_extraction;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_extraction IS
	
	PROCEDURE Lister_Extraction(
		p_userid	IN	CHAR,
		p_curseur	IN OUT	pack_liste_dynamique.liste_dyn
	) IS
		
		l_menu 		varchar2(20);
    		l_sousmenus   	VARCHAR2(255);		
	BEGIN
		-- Récupération du menu courant et des sous-menus de l'utilisateur
		l_menu := pack_global.lire_globaldata(p_userid).menutil;
   		l_sousmenus := pack_global.lire_globaldata(p_userid).sousmenus;
		
		-- Recherche les requêtes habilitée
		-- Si un sous-menu plus est renseigné dans la table et qu'il appartient 
		-- 	au sous-menu de l'utilisateur on renvoie la ligne
		OPEN p_curseur FOR SELECT DISTINCT
			r.nom_fichier,
				r.libelle
			FROM requete r, requete_profil rp
			WHERE r.nom_fichier=rp.nom_fichier
			AND UPPER(rp.code_profil)=UPPER(l_menu)
			AND	(rp.sous_menu_plus is null OR INSTR(l_sousmenus,rp.sous_menu_plus) > 0 ) 
			AND 	(rp.sous_menu_moins is null 
				OR NOT EXISTS ( SELECT 1 
							FROM requete_profil rp2 
							WHERE rp.nom_fichier = rp2.nom_fichier
							AND   rp.code_profil = rp2.code_profil
							AND	 INSTR(l_sousmenus,rp2.sous_menu_moins) > 0 )
				)
				    order by r.libelle;
		
	EXCEPTION
		WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-20997, SQLERRM); 
	END Lister_Extraction;


END pack_liste_extraction;
/
