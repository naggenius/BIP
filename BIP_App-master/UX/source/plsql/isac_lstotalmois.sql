-- APPLICATION ISAC
-- -------------------------------------
-- pack_liste_isac_total_mois PL/SQL
-- 
-- Cr‰‰ le 14/03/2002 par NBM
--
-- Modifié le 15/09/2005 par PPR : Optimisations
-- Modifié le 22/06/2006 par BAA : Ajouter type de la date saisie (pour weblogic 9.1)
--
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
-- Ne pas modifier l'ordre des paramˆtres pour le curseur (de MOIS_1 € MOIS_12)

CREATE OR REPLACE PACKAGE pack_liste_isac_total_mois AS
Function f_get_total_mois ( p_ident IN VARCHAR2,
			    p_mois IN VARCHAR2
			)  return VARCHAR2  ;
PRAGMA restrict_references(f_get_total_mois,wnds,wnps);

Function f_get_nbjour_mois (  p_mois IN VARCHAR2
			)  return Number ;
PRAGMA restrict_references(f_get_nbjour_mois,wnds,wnps);

 TYPE conso_ListeViewType IS RECORD(    TOT_MOIS_1 	VARCHAR2(10),
					TOT_MOIS_2	VARCHAR2(10),
					TOT_MOIS_3 	VARCHAR2(10),
					TOT_MOIS_4 	VARCHAR2(10),
					TOT_MOIS_5 	VARCHAR2(10),
					TOT_MOIS_6 	VARCHAR2(10),
					TOT_MOIS_7	VARCHAR2(10),
					TOT_MOIS_8	VARCHAR2(10),
					TOT_MOIS_9 	VARCHAR2(10),
					TOT_MOIS_10 	VARCHAR2(10),
					TOT_MOIS_11	VARCHAR2(10),
					TOT_MOIS_12	VARCHAR2(10),
					TOTAL		VARCHAR2(10),
					NBJOUR_1 	isac_consomme.cusag%TYPE,
					NBJOUR_2	isac_consomme.cusag%TYPE,
					NBJOUR_3 	isac_consomme.cusag%TYPE,
					NBJOUR_4 	isac_consomme.cusag%TYPE,
					NBJOUR_5 	isac_consomme.cusag%TYPE,
					NBJOUR_6 	isac_consomme.cusag%TYPE,
					NBJOUR_7	isac_consomme.cusag%TYPE,
					NBJOUR_8	isac_consomme.cusag%TYPE,
					NBJOUR_9 	isac_consomme.cusag%TYPE,
					NBJOUR_10 	isac_consomme.cusag%TYPE,
					NBJOUR_11	isac_consomme.cusag%TYPE,
					NBJOUR_12	isac_consomme.cusag%TYPE
                                   );

   TYPE conso_listeCurType IS REF CURSOR RETURN conso_ListeViewType;


   PROCEDURE lister_isac_total_mois( 	p_ident    IN VARCHAR2,	 
                              		p_userid   IN VARCHAR2,
                              		p_curseur  IN OUT conso_listeCurType
                             	  );


END pack_liste_isac_total_mois;
/
CREATE OR REPLACE PACKAGE BODY pack_liste_isac_total_mois AS

Function f_get_total_mois ( p_ident IN VARCHAR2,
			  p_mois IN VARCHAR2
			)  return VARCHAR2  IS 

l_total NUMBER;
BEGIN
	select sum(cusag) into l_total
	from isac_consomme
	where ident=to_number(p_ident)
	and  to_char(cdeb,'MM/YYYY')=p_mois;

	if (l_total<1 and l_total>0) then
		return to_char(l_total,'FM9990D99');
	else
		return to_char(l_total);
	end if;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Return '0';


END f_get_total_mois;

Function f_get_nbjour_mois (  p_mois IN VARCHAR2
			)  return Number  IS 

l_nbjour NUMBER;
BEGIN
	select cjours into l_nbjour from calendrier
	where calanmois= to_date('01/'||p_mois,'DD/MM/YYYY');

	Return l_nbjour ;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Return 0;


END f_get_nbjour_mois;




   PROCEDURE lister_isac_total_mois( 	p_ident    IN VARCHAR2, 
                              		p_userid   IN VARCHAR2,
                              		p_curseur  IN OUT conso_listeCurType
                             	) IS
l_anneecourante VARCHAR2(4);
l_annee date;
  BEGIN
	select to_char(datdebex,'YYYY'),datdebex into  l_anneecourante,l_annee
	from datdebex;

  	OPEN p_curseur FOR
	select f_get_total_mois(max(c.ident), '01/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_1,
	f_get_total_mois(max(c.ident), '02/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_2,
	f_get_total_mois(max(c.ident), '03/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_3,
	f_get_total_mois(max(c.ident), '04/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_4,
	f_get_total_mois(max(c.ident), '05/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_5,
	f_get_total_mois(max(c.ident), '06/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_6,
	f_get_total_mois(max(c.ident), '07/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_7,
	f_get_total_mois(max(c.ident), '08/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_8,
	f_get_total_mois(max(c.ident), '09/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_9,
	f_get_total_mois(max(c.ident), '10/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_10,
	f_get_total_mois(max(c.ident), '11/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_11,
	f_get_total_mois(max(c.ident), '12/'||to_char(min(cdeb),'YYYY')) TOT_MOIS_12,
	to_char(sum(cusag)) TOTAL,
	pack_liste_isac_total_mois.f_get_nbjour_mois('01/'||l_anneecourante) NBJOUR_1,
	pack_liste_isac_total_mois.f_get_nbjour_mois('02/'||l_anneecourante) NBJOUR_2,
	pack_liste_isac_total_mois.f_get_nbjour_mois('03/'||l_anneecourante) NBJOUR_3,
	pack_liste_isac_total_mois.f_get_nbjour_mois('04/'||l_anneecourante) NBJOUR_4,
	pack_liste_isac_total_mois.f_get_nbjour_mois('05/'||l_anneecourante) NBJOUR_5,
	pack_liste_isac_total_mois.f_get_nbjour_mois('06/'||l_anneecourante) NBJOUR_6,
	pack_liste_isac_total_mois.f_get_nbjour_mois('07/'||l_anneecourante) NBJOUR_7,
 	pack_liste_isac_total_mois.f_get_nbjour_mois('08/'||l_anneecourante) NBJOUR_8,
	pack_liste_isac_total_mois.f_get_nbjour_mois('09/'||l_anneecourante) NBJOUR_9,
 	pack_liste_isac_total_mois.f_get_nbjour_mois('10/'||l_anneecourante) NBJOUR_10,
	pack_liste_isac_total_mois.f_get_nbjour_mois('11/'||l_anneecourante) NBJOUR_11,
 	pack_liste_isac_total_mois.f_get_nbjour_mois('12/'||l_anneecourante) NBJOUR_12
	from isac_consomme c , isac_affectation a
	where c.ident=to_number(p_ident)
	and trunc(c.cdeb,'YEAR')=trunc(l_annee,'YEAR')
	and c.ident=a.ident(+)
	and c.pid=a.pid(+)
	and c.etape=a.etape(+)
	and c.tache=a.tache(+)
	and c.sous_tache=a.sous_tache(+);

  END lister_isac_total_mois;


END pack_liste_isac_total_mois;
/
