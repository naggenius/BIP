-- pack_liste_direction_mo PL/SQL
--
-- MMC
-- Crée le 3/06/2002
--
-- Modifié le 13/06/2003 par Pierre JOSSE
-- Remplacement des references au perimetre MO
-- (ce n'est plus un code perim MO mais une liste de BDCLICODE)
--
-- Objet  : Permet la création de la liste des directions MO
-- Table  : client_mo
-- Pour le fichier HTML : cdgmligne.htm
--
--*********************************************************************
-- CMA le 11/05/2011 fiche 1176 dans le cas du menu client, on utilise perimcli, pas perimo
-- Attention le nom du package ne peut etre le nom
-- de la table...
--
CREATE OR REPLACE PACKAGE pack_liste_direction_mo AS

TYPE dirmo_ListeViewType IS RECORD( id      client_mo.clicode%TYPE,
			            libelle CHAR(40)
                                        );

TYPE dirmo_listeCurType IS REF CURSOR RETURN dirmo_ListeViewType;

PROCEDURE lister_direction_mo(p_userid  IN VARCHAR2,
                              p_curseur IN OUT dirmo_listeCurType
                                 );

END pack_liste_direction_mo;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_direction_mo AS

   PROCEDURE lister_direction_mo(p_userid   IN VARCHAR2,
                                  p_curseur IN OUT dirmo_listeCurType
                                  ) IS
l_perimo VARCHAR2(1000);
l_menu VARCHAR2(25);

   BEGIN

    l_menu := pack_global.lire_globaldata(p_userid).menutil;
	
		if('MO'=l_menu)then
			l_perimo := pack_global.lire_globaldata(p_userid).perimcli;
		else
			l_perimo := pack_global.lire_globaldata(p_userid).perimo;
		end if;

      OPEN p_curseur FOR
 	SELECT clicode,
             rpad( clicode, 10, ' ') ||
             clilib
	FROM client_mo
	WHERE clicode IN (SELECT clicode
				FROM vue_clicode_perimo
				WHERE INSTR(l_perimo, bdclicode)>0)
	ORDER BY 1;

   END lister_direction_mo;

END pack_liste_direction_mo;
/


