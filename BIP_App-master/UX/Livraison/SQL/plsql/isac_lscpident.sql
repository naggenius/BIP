-- APPLICATION ISAC
-- -------------------------------------
-- pack_liste_isac_cpident PL/SQL
-- 
-- Créé le 18/09/2002 par NBM
--         20/07/2004 par PJO : On ne s‰lectionne que les chefs de projets pour la liste
--      Le 03/01/2006 BAA : Fiche 334 : Optimisation des requétes
--
-- Liste des chefs de projet associés € l'utilisateur
--
-- Utilis‰e dans les pages iemens2.htm
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...


CREATE OR REPLACE PACKAGE Pack_Liste_Isac_Cpident AS

   TYPE cpident_ListeViewType IS RECORD(
				   	CLE		VARCHAR2(100),
					LIBELLE 	VARCHAR2(100)
                                         );


   TYPE cpident_listeCurType IS REF CURSOR RETURN cpident_ListeViewType;

    TYPE RefCurTyp IS REF CURSOR;


   PROCEDURE lister_isac_cpident( 	p_userid  IN VARCHAR2,
                              		p_curseur IN OUT RefCurTyp
                                );

END Pack_Liste_Isac_Cpident;
/

create or replace PACKAGE BODY Pack_Liste_Isac_Cpident AS

PROCEDURE lister_isac_cpident(
                              	p_userid  IN VARCHAR2,
                              	p_curseur IN OUT RefCurTyp
                             ) IS

l_lst_chefs_projets VARCHAR2(4000);-- PPM 63485 : augmenter la taille à 4000
req                            VARCHAR2(8000); -- PPM 63485 : augmenter la taille à 2000 + 4000 chefs de projets

BEGIN

	l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;

		req := ' SELECT DISTINCT res.ident CLE, res.rnom ||'' - ''||res.ident LIBELLE  '
                || ' FROM RESSOURCE res, SITU_RESS_FULL sr, DATDEBEX d  '
		        || ' WHERE  res.ident IN ('|| l_lst_chefs_projets ||')  '
			    || ' AND (TRUNC(sr.datsitu,''YEAR'') <=TRUNC(d.DATDEBEX,''YEAR'') OR sr.datsitu IS NULL) '
		        || ' AND (TRUNC(sr.datdep,''YEAR'')>=TRUNC(d.DATDEBEX,''YEAR'') OR sr.datdep IS NULL) '
		        || ' AND res.ident = sr.cpident '
		        || ' AND sr.type_situ=''N'' '
		        || ' ORDER BY LIBELLE ';



        OPEN p_curseur FOR   req;

END lister_isac_cpident;
END Pack_Liste_Isac_Cpident;
/
