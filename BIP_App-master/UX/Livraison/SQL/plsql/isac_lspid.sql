-- APPLICATION ISAC
-- -------------------------------------
-- pack_liste_isac_pid PL/SQL
-- 
-- Créé le 03/06/2002 par NBM
-- Liste des lignes BIP auxquelles l'utilisateur est habilité
--
-- Modifié le 16/06/2003 par Pierre JOSSE : Suppression des références à UserBIp et à isac_habilitations.
--         le 25/07/2003 par NBM : ajout des libellés des lignes BIP(fiche 169)
--	   le 03/03/2004 par PJO : passage sur 4 caractères du PID
--         le 30/12/2005 par BAA : Optimisation des requêtes
--         le 26/01/2006 par PPR : Simplification de la requete dans lister_isac_pid
---- 29/12/2009 par ABA : TD 875 : on ne ramène pas les lignes bip de type t9
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...



CREATE OR REPLACE PACKAGE Pack_Liste_Isac_Pid AS

   TYPE RefCurTyp IS REF CURSOR;

   TYPE pid_ListeViewType IS RECORD(
				   	PID	LIGNE_BIP.pid%TYPE,
					PNOM	VARCHAR2(40)
                                         );

   TYPE pid_listeCurType IS REF CURSOR RETURN pid_ListeViewType;

   PROCEDURE lister_isac_pid (
                              	p_userid  IN VARCHAR2,
                              	p_curseur IN OUT RefCurTyp
                             );

   PROCEDURE lister_isac_pid_modif (
                              	p_userid  IN VARCHAR2,
                              	p_curseur IN OUT RefCurTyp
                             );

END Pack_Liste_Isac_Pid ;
/

create or replace PACKAGE BODY     Pack_Liste_Isac_Pid  AS

-- liste des lignes ouvertes sur l'annee pour la liste de CP de l'utilisateur
PROCEDURE lister_isac_pid  (
                         		p_userid  IN VARCHAR2,
                			p_curseur IN OUT RefCurTyp
                             ) IS

l_lst_chefs_projets VARCHAR2(8000);-- PPM 63485 : augmenter la taille à 4000
req                 VARCHAR2(10000);-- PPM 61776 QC 1848 : modification de taille de 2000 à 8000

BEGIN
	l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;


	      req := ' SELECT pid,pid||'' - ''||l.pnom   '
		         || '	FROM LIGNE_BIP l, DATDEBEX d  '
		         || '	WHERE  l.pcpi IN ('|| l_lst_chefs_projets ||')  '
				 || ' MINUS '
				 || ' SELECT pid,pid||'' - ''||l.pnom   '
				 || ' FROM LIGNE_BIP l, DATDEBEX d  '
				 || '	WHERE  l.pcpi IN ('|| l_lst_chefs_projets ||')  '
				 || ' AND TRUNC(adatestatut,''YEAR'')<TRUNC(d.DATDEBEX,''YEAR'')   '
                  || '   AND to_number(l.typproj) != 9 '
				 || ' ORDER BY 1 ';

--	             || ' AND (adatestatut > ADD_MONTHS(d.moismens,-1) OR adatestatut IS  NULL ) '
--				 || ' AND ((topfer=''O'' AND TRUNC(adatestatut,''YEAR'')<TRUNC(d.DATDEBEX,''YEAR'')  ) '
--               || ' OR (astatut  IN (''A'',''D'',''C'')  AND TRUNC(adatestatut,''YEAR'')<TRUNC(d.DATDEBEX,''YEAR'') ) ) '


        OPEN p_curseur FOR   req;



END lister_isac_pid ;

-- liste des lignes non fermées depuis un mois pour la liste de CP de l'utilisateur
PROCEDURE lister_isac_pid_modif  (
                         		p_userid  IN VARCHAR2,
                			p_curseur IN OUT RefCurTyp
                             ) IS

l_lst_chefs_projets VARCHAR2(4000);-- PPM 63485 : augmenter la taille à 4000
req                               VARCHAR2(8000); -- PPM 63485 : augmenter la taille à 2000 + 4000 chefs de projets

BEGIN
	l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;

	  req := ' SELECT pid,pid||'' - ''||l.pnom   '
		         || '	FROM LIGNE_BIP l, DATDEBEX d  '
		         || '	WHERE  l.pcpi IN ('|| l_lst_chefs_projets ||')  '
	             || '   AND (adatestatut > ADD_MONTHS(d.moismens,-1) OR adatestatut IS  NULL ) '
                 || '   AND to_number(l.typproj) != 9 '
				 || '	ORDER BY 1 ';


        OPEN p_curseur FOR   req;


END lister_isac_pid_modif ;


END Pack_Liste_Isac_Pid ;
/