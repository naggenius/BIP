-- APPLICATION ISAC
-- -------------------------------------
-- pack_liste_isac_resscons PL/SQL
--
-- Créé le 13/06/2002 par NBM
-- Liste des ressources auxquelles l'utilisateur est habilité
--
-- Modifié par Pierre JOSSE le 16/06/2003
-- Migration RTFE : suppression des références à userBip et isac_habilitation
-- Le 22/07/2004 PJO : Fiche 355 : modif des habilitations ISAC : autorisation des ressources dans la liste du rTFE*
-- Le 03/01/2006 BAA : Fiche 334 : Optimisation des requétes
-- Le 26/01/2006 BAA Augmentation de la taill des variables l_lst_chefs_projets et req(255,800) de à (600,4000)
-- Le 14/09/2006 DDI : Fiche 465 : Ajout de la liste des DPG des ressources étant rattachees au CP. (lister_isac_dpg).
-- Le 08/01/2007 BAA : Fiche 465 : la liste dpg depend de la ressource selectionée
-- Le 19/07/2012 BSA : QC 1235 : Saisie des réalisés : amelioration de la gestion des affectations
-- Le 27/09/2012 BSA : QC 1235 : filtre sur les affectations
-- Le 28/01/2012 ABA : QC 1235 : correction regression liste des ressources
--
-- Utilisée dans les pages idetcons.htm
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE BIP.Pack_Liste_Isac_Resscons AS

   TYPE ressource_ListeViewType IS RECORD(
				   	IDENT	VARCHAR2(5),
					LIB	VARCHAR2(50)
                                         );

	 TYPE RefCurTyp IS REF CURSOR;

   TYPE ressource_listeCurType IS REF CURSOR RETURN ressource_ListeViewType;

   PROCEDURE lister_isac_resscons (
                              		p_userid  IN VARCHAR2,
                              		p_curseur IN OUT RefCurTyp
                             );

   PROCEDURE lister_ress_hab (
                              		p_userid  IN VARCHAR2,
                              		p_curseur IN OUT RefCurTyp
                             );

   PROCEDURE lister_isac_ressfavcons (
                              		p_userid  IN VARCHAR2,
                              		p_curseur IN OUT RefCurTyp
                             );

-- Liste des DPG des lignes BIP pour lesquelle il y a une affectation au niveau du CP.
   PROCEDURE lister_isac_dpg (
                              		p_userid  IN VARCHAR2,
									p_ident  IN VARCHAR2,
                              		p_curseur IN OUT RefCurTyp
                             );
     -- Liste les ressources affectées , habilitées et actives sur une  sous tache
   PROCEDURE lister_isac_resscons_aff (
                                      p_userid  IN VARCHAR2,
                                      p_curseur IN OUT RefCurTyp
                             );

END Pack_Liste_Isac_Resscons ;
/
create or replace PACKAGE BODY     Pack_Liste_Isac_Resscons AS

PROCEDURE lister_isac_resscons  (
                                 p_userid  IN VARCHAR2,
                                p_curseur IN OUT RefCurTyp
                             ) IS

l_lst_chefs_projets VARCHAR2(8000);-- PPM 63485 : augmenter la taille à 4000
req                            VARCHAR2(10000); -- PPM 63485 : augmenter la taille à 4000 + 4000 chefs de projets

BEGIN

    l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;

    req := ' SELECT DISTINCT TO_CHAR(r.ident) ,r.rnom||'' - ''||r.ident LIB  '
           || ' FROM SITU_RESS_FULL f, RESSOURCE r, DATDEBEX d  '
           || ' WHERE f.ident=r.ident '
           || ' AND (TRUNC(f.datsitu,''YEAR'') <=TRUNC(d.DATDEBEX,''YEAR'') OR f.datsitu IS NULL) '
           || ' AND (TRUNC(f.datdep,''YEAR'')>=TRUNC(d.DATDEBEX,''YEAR'') OR f.datdep IS NULL) '
           || ' AND ( f.cpident IN ('|| l_lst_chefs_projets ||')  OR f.ident IN ('|| l_lst_chefs_projets ||') ) '
           || ' AND f.type_situ=''N'' '
           || ' ORDER BY LIB ';



        OPEN p_curseur FOR   req;



END lister_isac_resscons ;

PROCEDURE lister_ress_hab  (
                         		p_userid  IN VARCHAR2,
                			    p_curseur IN OUT RefCurTyp
                             ) IS

l_lst_chefs_projets     VARCHAR2(4000);-- PPM 63485 : augmenter la taille à 4000
req                     VARCHAR2(8000);-- PPM 63485 : augmenter la taille à 4000 + 4000 chefs de projets

BEGIN

	l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;


	req := ' SELECT DISTINCT TO_CHAR(r.ident) ,r.rnom||'' - ''||r.ident LIB  '
           || ' FROM LIGNE_BIP l, isac_affectation a, RESSOURCE r '
		   || ' WHERE 1=1 '
           || ' AND a.PID = l.PID '
           || ' AND a.IDENT = r.IDENT '
           || ' AND l.pcpi IN ('|| l_lst_chefs_projets ||') '
		   || ' ORDER BY LIB ';


    OPEN p_curseur FOR   req;



END lister_ress_hab ;

PROCEDURE lister_isac_ressfavcons  (
                         		p_userid  IN VARCHAR2,
                			    p_curseur IN OUT RefCurTyp
                             ) IS

    l_lst_chefs_projets     VARCHAR2(8000);-- PPM 63485 : augmenter la taille à 4000
    l_idarpege              VARCHAR2(600);
    req                     VARCHAR2(10000);-- PPM 63485 : augmenter la taille à 4000 + 4000 chef de projets

BEGIN

	l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;
    l_idarpege := Pack_Global.lire_globaldata(p_userid).idarpege;


    req := ' SELECT DISTINCT TO_CHAR(r.ident) ,r.rnom||'' - ''||r.ident LIB '
           || ' FROM SITU_RESS_FULL f, RESSOURCE r, DATDEBEX d, ISAC_RESSOURCE_FAVORITE i '
           || ' WHERE f.ident = r.ident '
           || '       AND i.IDENT = f.ident AND UPPER(i.IDARPEGE) = UPPER(''' || l_idarpege || ''')'
           || '       AND (TRUNC(f.datsitu,''YEAR'') <=TRUNC(d.DATDEBEX,''YEAR'') OR f.datsitu IS NULL) '
           || '       AND (TRUNC(f.datdep,''YEAR'')>=TRUNC(d.DATDEBEX,''YEAR'') OR f.datdep IS NULL) '
           || '       AND ( f.cpident IN ('|| l_lst_chefs_projets ||') OR f.ident IN ('|| l_lst_chefs_projets ||') ) '
           || '       AND f.type_situ=''N'' '
           || '     ORDER BY LIB ' ;


        OPEN p_curseur FOR   req;

END lister_isac_ressfavcons ;

-- Liste des DPG des lignes BIP pour lesquelle il y a une affectation au niveau du CP.
PROCEDURE lister_isac_dpg  (
                         	p_userid  IN VARCHAR2,
							p_ident  IN VARCHAR2,
                			p_curseur IN OUT RefCurTyp
                           ) IS

l_liste_cp			VARCHAR2(8000);-- PPM 63485 : augmenter la taille des chefs de projets à 4000
req					     VARCHAR2(10000); -- PPM 63485 : augmenter la taille des chefs de projets à 4000 + 4000

BEGIN

	l_liste_cp := Pack_Global.lire_globaldata(p_userid).chefprojet;


	  req := ' Select distinct to_char(lb.codsg), to_char(lb.codsg)  '
		   || ' from ligne_bip lb '
		   || ' where lb.pid in (Select distinct ia.pid '
		   || '	 		from isac_affectation ia '
		   || '			where ia.ident in (	SELECT DISTINCT r.ident '
		   || '			  		   	  FROM SITU_RESS_FULL f, RESSOURCE r, DATDEBEX d '
		   || '						  WHERE f.ident=r.ident '
		   || '						  AND (TRUNC(f.datsitu,''YEAR'') <=TRUNC(d.DATDEBEX,''YEAR'') OR f.datsitu IS NULL) '
		   || '						  AND (TRUNC(f.datdep,''YEAR'')>=TRUNC(d.DATDEBEX,''YEAR'') OR f.datdep IS NULL) '
		   || '						  AND f.type_situ=''N'' '
		   ||'                        AND f.ident = TO_NUMBER('|| p_ident || ') '
		   || '						  ) '
		   || '				) '
		   || ' order by codsg ';



        OPEN p_curseur FOR   req;

END lister_isac_dpg ;

PROCEDURE  lister_isac_resscons_aff  (
                                 p_userid  IN VARCHAR2,
                                p_curseur IN OUT RefCurTyp
                             ) IS

l_lst_chefs_projets     VARCHAR2(8000);-- PPM 63485 : augmenter la taille à 4000
req                     VARCHAR2(10000);-- PPM 63485 : augmenter la taille à 4000 + 4000 chefs de projets

BEGIN

    l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;


    req := ' SELECT DISTINCT TO_CHAR(r.ident) ,r.rnom||'' - ''||r.ident LIB  '
           || ' FROM SITU_RESS_FULL f, RESSOURCE r, DATDEBEX d,isac_affectation af  '
           || ' WHERE f.ident = r.ident '
           || ' AND r.ident = af.ident '
           || ' AND (TRUNC(f.datsitu,''YEAR'') <=TRUNC(d.DATDEBEX,''YEAR'') OR f.datsitu IS NULL) '
           || ' AND (TRUNC(f.datdep,''YEAR'')>=TRUNC(d.DATDEBEX,''YEAR'') OR f.datdep IS NULL) '
           || ' AND ( f.cpident IN ('|| l_lst_chefs_projets ||')  OR f.ident IN ('|| l_lst_chefs_projets ||') ) '
           || ' AND f.type_situ=''N'' '
           || ' ORDER BY LIB ';



    OPEN p_curseur FOR   req;



END  lister_isac_resscons_aff;

END Pack_Liste_Isac_Resscons;
/
