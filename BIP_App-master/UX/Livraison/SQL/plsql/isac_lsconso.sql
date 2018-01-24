CREATE OR REPLACE PACKAGE Pack_Liste_Isac_Conso AS

FUNCTION f_get_cusag_mois ( 	p_ident 	IN VARCHAR2,
				p_sous_tache 	IN VARCHAR2,
				p_mois 		IN VARCHAR2)
				  RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(f_get_cusag_mois,wnds,wnps);

FUNCTION f_get_adatestatut ( 	p_ident IN VARCHAR2,
				p_sous_tache IN VARCHAR2) RETURN NUMBER;

FUNCTION f_get_astatut ( 	p_ident IN VARCHAR2,
				p_sous_tache IN VARCHAR2) RETURN NUMBER;

PRAGMA RESTRICT_REFERENCES(f_get_adatestatut,wnds,wnps);

FUNCTION f_get_total_sstache( 	p_ident 	IN NUMBER,
				p_sous_tache	IN NUMBER,
			 	p_annee 	IN VARCHAR2
			)  RETURN VARCHAR2;
PRAGMA RESTRICT_REFERENCES(f_get_total_sstache,wnds,wnps);


FUNCTION f_get_lib_pid( p_pid 	IN VARCHAR2
			          )  RETURN VARCHAR2;

-- Majuscule pour javascript qui utilise le nom des colonnes pour l'automates.
  -- Majuscule pour javascript qui utilise le nom des colonnes pour l'automates.
   TYPE conso_ListeViewType IS RECORD(
				 	MOIS_1 		VARCHAR2(9),
					MOIS_2		VARCHAR2(9),
					MOIS_3 		VARCHAR2(9),
					MOIS_4 		VARCHAR2(9),
					MOIS_5 		VARCHAR2(9),
					MOIS_6 		VARCHAR2(9),
					MOIS_7		VARCHAR2(9),
					MOIS_8		VARCHAR2(9),
					MOIS_9 		VARCHAR2(9),
					MOIS_10 	VARCHAR2(9),
					MOIS_11		VARCHAR2(9),
					MOIS_12		VARCHAR2(9),
					PID		    ISAC_AFFECTATION.pid%TYPE,
					LIB		    LIGNE_BIP.pnom%TYPE,
				   	ETAPE		ISAC_CONSOMME.ETAPE%TYPE,
					ECET		ISAC_ETAPE.ecet%TYPE,
					LIBETAPE 	ISAC_ETAPE.libetape%TYPE,
				    TACHE		ISAC_CONSOMME.TACHE%TYPE,
					ACTA		ISAC_TACHE.acta%TYPE,
					LIBTACHE	ISAC_TACHE.libtache%TYPE,
				   	SOUS_TACHE	ISAC_CONSOMME.sous_tache%TYPE,
					ACST		ISAC_SOUS_TACHE.acst%TYPE,
					ASNOM		ISAC_SOUS_TACHE.asnom%TYPE,
					AIST 		ISAC_SOUS_TACHE.aist%TYPE,
					MOIS_SAISIE     NUMBER(2),
					TOTAL_PID	VARCHAR2(10),
					IDENTIFIANT     VARCHAR2(50),
					TYPETAPE      VARCHAR2(2),
					FERMEE	VARCHAR2(8),
					moisfin VARCHAR2(8),
					statut VARCHAR2(1),
					datedebut VARCHAR2(8),
					TYPPROJ	VARCHAR2(2),
          FAVORITE ISAC_SOUS_TACHE.FAVORITE%TYPE,
          EXISTE_CONSOMME_ANNEE VARCHAR2(1),
          codsg LIGNE_BIP.CODSG%type,
					LIBELLE_TRI	VARCHAR2(110),
					TYPE	VARCHAR2(1)
                                         );

   TYPE conso_listeCurType IS REF CURSOR; --RETURN conso_ListeViewType;

    FUNCTION a_un_consomme(
				p_ident 	IN VARCHAR2,
				p_sous_tache 	IN VARCHAR2,
				p_annee 		IN VARCHAR2) return VARCHAR2;

    PROCEDURE a_des_sous_taches(p_ident    IN VARCHAR2,
          p_userid   IN VARCHAR2,
					p_liste_dpg	IN VARCHAR2,
          p_liste_sous_taches IN VARCHAR2,
          p_resultat OUT VARCHAR2,
          p_message OUT VARCHAR2);

    PROCEDURE lister_isac_conso( 	p_ident    IN VARCHAR2,
                              		p_userid   IN VARCHAR2,
					p_ordre_tri IN VARCHAR2,
					p_liste_dpg	IN VARCHAR2,
          p_liste_sous_taches IN VARCHAR2,
                              		p_curseur  IN OUT conso_listeCurType
                             );

END Pack_Liste_Isac_Conso;
/


CREATE OR REPLACE PACKAGE BODY Pack_Liste_Isac_Conso AS
/**
 * Fonction booléenne de vérification de l'existence d'un consommé pour une sous-tâche sur une année donnée.
 */
FUNCTION a_un_consomme (p_ident IN VARCHAR2,
				p_sous_tache IN VARCHAR2,
				p_annee IN VARCHAR2
        ) RETURN VARCHAR2 IS
n_conso number;
BEGIN
  SELECT count(cusag) INTO n_conso FROM ISAC_CONSOMME
	WHERE sous_tache=p_sous_tache
  AND ident=TO_NUMBER(p_ident)
	AND to_char(cdeb, 'YYYY')=p_annee;

	IF (n_conso>0) THEN
		RETURN 'O';
	ELSE
		RETURN 'N';
	END IF;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN NULL;

END a_un_consomme;

/**
 * Procedure de vérification de la présence d'une sous-tâche.
 */
PROCEDURE a_des_sous_taches(p_ident    IN VARCHAR2,
          p_userid   IN VARCHAR2,
					p_liste_dpg	IN VARCHAR2,
          p_liste_sous_taches IN VARCHAR2,
          p_resultat OUT VARCHAR2,
          p_message OUT VARCHAR2) IS
v_number number;
l_anneecourante VARCHAR2(4);
t_liste_dpg pack_utile.t_array;
v_requete varchar2(32767);
BEGIN
  SELECT TO_CHAR(DATDEBEX,'YYYY') INTO l_anneecourante
	FROM DATDEBEX;

  t_liste_dpg := pack_utile.SPLIT(p_liste_dpg, ',');

  v_requete := 'SELECT count(*)
	FROM  ISAC_AFFECTATION a, ISAC_SOUS_TACHE st, ISAC_TACHE t, ISAC_ETAPE e, LIGNE_BIP l, APPLICATION ap
	WHERE a.ident=TO_NUMBER('||p_ident||')
	AND a.sous_tache=st.sous_tache
	AND st.TACHE=t.TACHE
	AND t.ETAPE=e.ETAPE
	AND l.pid=a.pid
	AND ap.airt=l.airt ';

  if (p_liste_dpg is not null and t_liste_dpg.count > 0) then
    v_requete := v_requete || 'AND l.codsg in (';
    for i in 1..t_liste_dpg.count
    loop
      if (i != 1) then
        v_requete := v_requete || ',''' || t_liste_dpg(i) || '''';
      else
        v_requete := v_requete || '''' || t_liste_dpg(i) || '''';
      end if;
    end loop;
    v_requete := v_requete || ')';
  end if;

  v_requete := v_requete || ' AND DECODE('||p_liste_sous_taches||',''2'',st.favorite,0)=DECODE('||p_liste_sous_taches||',''2'',1,0)
  AND DECODE('||p_liste_sous_taches||',''3'',pack_liste_isac_conso.a_un_consomme('||p_ident||',a.sous_tache,'||l_anneecourante||') ,0)=DECODE('||p_liste_sous_taches||',''3'',''O'',0)';

  execute immediate v_requete into v_number;

  if (v_number>=1) then
    p_resultat:='O';
  else
    p_resultat:='N';
    select limsg into p_message from message where id_msg=21270;
  end if;
END a_des_sous_taches;

FUNCTION f_get_cusag_mois ( 	p_ident IN VARCHAR2,
				p_sous_tache IN VARCHAR2,
				p_mois IN VARCHAR2) RETURN VARCHAR2 IS
l_cusag NUMBER(7,2);
BEGIN
	SELECT cusag INTO l_cusag FROM ISAC_CONSOMME
	WHERE ident=TO_NUMBER(p_ident)
	AND sous_tache=p_sous_tache
	AND cdeb=TO_DATE('01/'||p_mois,'DD/MM/YYYY');
	IF (l_cusag<1 AND l_cusag>0) THEN
		RETURN TO_CHAR(l_cusag,'FM9990D99');
	ELSE
		RETURN TO_CHAR(l_cusag);
	END IF;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN NULL;

END f_get_cusag_mois;

--fonction qui renvoie 1 ou 0 en fonction de la date de statut et du mois de mensuelle
FUNCTION f_get_adatestatut ( 	p_ident IN VARCHAR2,
				p_sous_tache IN VARCHAR2) RETURN NUMBER IS
l_test NUMBER(1);
l_test_sst NUMBER(1);
l_res NUMBER(1);
BEGIN
	BEGIN
	-- on teste si la ligne Bip est fermée
	SELECT DISTINCT 1 INTO l_test
	FROM LIGNE_BIP lb,ISAC_AFFECTATION c,DATDEBEX dx
	WHERE c.ident=TO_NUMBER(p_ident)
	AND c.sous_tache=p_sous_tache
	AND c.pid=lb.pid
	AND lb.adatestatut IS NOT NULL AND lb.adatestatut <= ADD_MONTHS(dx.moismens,-1);

	EXCEPTION
			WHEN NO_DATA_FOUND THEN
	-- on teste la sous tache
		SELECT DISTINCT 2 INTO l_test_sst
		FROM LIGNE_BIP lb,ISAC_SOUS_TACHE sst,ISAC_AFFECTATION c,DATDEBEX dx
		WHERE c.ident=TO_NUMBER(p_ident)
		AND sst.sous_tache=p_sous_tache
		AND sst.sous_tache=c.sous_tache
		/*BIP-33 changes - Starts*/
   -- AND SUBSTR(sst.aist,3,4)=lb.pid(+)
    AND SST.PID=LB.PID
    /*BIP-33 changes - Ends*/
		AND lb.adatestatut IS NOT NULL AND lb.adatestatut <= ADD_MONTHS(dx.moismens,-1);
	END;

		IF (l_test_sst!=2 AND l_test!=1) THEN
			l_res := 0;
		ELSE
			 l_res := 1;
		END IF;

	RETURN l_res;
END f_get_adatestatut;


--fonction qui renvoie 1 ou 0 en fonction du statut de la ligne Bip
FUNCTION f_get_astatut ( 	p_ident IN VARCHAR2,
				p_sous_tache IN VARCHAR2) RETURN NUMBER IS
l_test NUMBER(1);
l_test_sst NUMBER(1);
l_res NUMBER(1);
BEGIN
	BEGIN
	-- on teste si la ligne Bip est sur statut Q
	SELECT DISTINCT 1 INTO l_test
	FROM LIGNE_BIP lb,ISAC_AFFECTATION c,DATDEBEX dx
	WHERE c.ident=TO_NUMBER(p_ident)
	AND c.sous_tache=p_sous_tache
	AND c.pid=lb.pid
	AND lb.astatut IS NOT NULL AND lb.astatut='Q';

	EXCEPTION
			WHEN NO_DATA_FOUND THEN
	-- on teste la sous tache
		SELECT DISTINCT 2 INTO l_test_sst
		FROM LIGNE_BIP lb,ISAC_SOUS_TACHE sst,ISAC_AFFECTATION c,DATDEBEX dx
		WHERE c.ident=TO_NUMBER(p_ident)
		AND sst.sous_tache=p_sous_tache
		AND sst.sous_tache=c.sous_tache
		AND SUBSTR(sst.aist,3,4)=lb.pid(+)
		AND lb.astatut IS NOT NULL AND lb.astatut ='Q';
	END;

		IF (l_test_sst!=2 AND l_test!=1) THEN
			l_res := 0;
		ELSE
			 l_res := 1;
		END IF;

	RETURN l_res;
END f_get_astatut;


FUNCTION f_get_total_sstache( 	p_ident 	IN NUMBER,
				p_sous_tache	IN NUMBER,
			 	p_annee 	IN VARCHAR2
			)  RETURN VARCHAR2 IS

l_total NUMBER(9,2);
BEGIN
	SELECT SUM(cusag) INTO l_total
	FROM ISAC_CONSOMME
	WHERE ident=p_ident
	AND sous_tache=p_sous_tache
	AND  TO_CHAR(cdeb,'YYYY')=p_annee;

	IF (l_total<1 AND l_total>0) THEN
		RETURN TO_CHAR(l_total,'FM9990D99');
	ELSE
		RETURN TO_CHAR(l_total);
	END IF;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN 0;


END f_get_total_sstache;


FUNCTION f_get_lib_pid( p_pid 	IN VARCHAR2
			          )  RETURN VARCHAR2 IS

l_lib LIGNE_BIP.PNOM%TYPE;

BEGIN

    l_lib := '';

    SELECT pnom INTO l_lib
           FROM LIGNE_BIP
           WHERE pid=p_pid;

	RETURN l_lib;

END f_get_lib_pid;




PROCEDURE lister_isac_conso(  	p_ident    IN VARCHAR2,
                              			p_userid   IN VARCHAR2,
										p_ordre_tri IN VARCHAR2,
										p_liste_dpg		IN VARCHAR2,
                    p_liste_sous_taches IN VARCHAR2,
                              			p_curseur  IN OUT conso_listeCurType
                             ) IS
l_datemens DATE;
l_datecourante DATE;
l_mois_saisie NUMBER(2);
l_anneecourante VARCHAR2(4);
l_annee DATE;
t_liste_dpg PACK_UTILE.t_array;
v_requete VARCHAR2(32767);

type conso_listeCurType is ref cursor;

   BEGIN
--comparer la date courante par rapport à la date de la mensuelle du mois
	SELECT cmensuelle,TO_CHAR(DATDEBEX,'YYYY'),DATDEBEX INTO l_datemens, l_anneecourante, l_annee
	FROM DATDEBEX;

  --PPM 58896 : utilisation directe du datemens sans soustraire 1 mois.
	l_mois_saisie := TO_NUMBER(TO_CHAR(l_datemens,'MM'));
	--adatestatut is not null and l_adatestatut <= add_months(l_moismens,-1)

IF( p_liste_dpg = 'TOUS')THEN
 DBMS_OUTPUT.PUT_LINE('TOUS');
ELSE
 DBMS_OUTPUT.PUT_LINE('DPG');
 t_liste_dpg := pack_utile.SPLIT(p_liste_dpg, ',');
END IF;

	-- Récupere les consommés de l'annéé pour la ressource
	v_requete := 'SELECT DISTINCT
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''01/' || l_anneecourante || ''') MOIS_1,
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''02/' || l_anneecourante || ''') MOIS_2,
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''03/' || l_anneecourante || ''') MOIS_3,
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''04/' || l_anneecourante || ''') MOIS_4,
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''05/' || l_anneecourante || ''') MOIS_5,
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''06/' || l_anneecourante || ''') MOIS_6,
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''07/' || l_anneecourante || ''') MOIS_7,
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''08/' || l_anneecourante || ''') MOIS_8,
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''09/' || l_anneecourante || ''') MOIS_9,
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''10/' || l_anneecourante || ''') MOIS_10,
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''11/' || l_anneecourante || ''') MOIS_11,
	pack_liste_isac_conso.f_get_cusag_mois(a.ident,a.sous_tache,''12/' || l_anneecourante || ''') MOIS_12,
	a.pid PID,
  pack_liste_isac_conso.f_get_lib_pid(a.pid),
  a.ETAPE ETAPE,
  e.ecet ECET,
  e.libetape LIBETAPE,
	a.TACHE TACHE,
  t.acta ACTA,
  t.libtache LIBTACHE,
  a.sous_tache SOUS_TACHE,
  st.acst ACST,
  st.asnom ASNOM,
  NVL(st.aist,'' '') AIST, ' || l_mois_saisie || ' MOIS_SAISIE,
	pack_liste_isac_conso.f_get_total_sstache(a.ident,a.sous_tache,' || l_anneecourante || ') TOTAL_PID,
	a.pid||e.ecet||t.acta||st.acst IDENTIFIANT,
	e.TYPETAPE TYPETAPE,
	DECODE(1,pack_liste_isac_conso.f_get_adatestatut(a.ident,a.sous_tache),''class=inputgras disabled ''/*,pack_liste_isac_conso.f_get_astatut(a.ident,a.sous_tache),''class=inputgras disabled ''*/,''class=inputisac '') FERMEE,
	DECODE(l.ADATESTATUT, NULL,''13/' || l_anneecourante || ''', TO_CHAR(l.ADATESTATUT,''mm/yyyy'')) moisfin,
	l.ASTATUT statut,
	TO_CHAR(l.PDATDEBPRE,''mm/yyyy'') datedebut,
	l.typproj typproj,
  st.favorite,
  pack_liste_isac_conso.a_un_consomme('||p_ident||',a.sous_tache,' || l_anneecourante || '),
  l.codsg,
	ap.alibel/* || l.typproj */|| a.pid || e.ecet||t.acta||st.acst LIBELLE_TRI,
	DECODE(TO_NUMBER(l.typproj),''7'',''7'',''1'') TYPE,
  CASE 
    WHEN st.aist LIKE ''%FF%'' THEN
   (select DECODE(ADATESTATUT, NULL,''13/'|| l_anneecourante || ''', TO_CHAR(ADATESTATUT,''mm/yyyy''))
   from LIGNE_BIP WHERE pid = trim(substr(st.aist,3))) 
   END AIST_MOISFIN
	FROM  ISAC_AFFECTATION a, ISAC_SOUS_TACHE st, ISAC_TACHE t, ISAC_ETAPE e, LIGNE_BIP l, APPLICATION ap
	WHERE a.ident=TO_NUMBER(' || p_ident || ')
	AND a.sous_tache=st.sous_tache
	AND st.TACHE=t.TACHE
	AND t.ETAPE=e.ETAPE
	AND l.pid=a.pid
	AND ap.airt=l.airt ';

  if (p_liste_dpg is not null and t_liste_dpg.count > 0) then
    v_requete := v_requete || 'AND l.codsg in (';
    for i in 1..t_liste_dpg.count
    loop
      if (i != 1) then
        v_requete := v_requete || ',''' || t_liste_dpg(i) || '''';
      else
        v_requete := v_requete || '''' || t_liste_dpg(i) || '''';
      end if;
    end loop;
    v_requete := v_requete || ')';
  end if;

	v_requete := v_requete || ' AND DECODE(' || p_liste_sous_taches || ',''2'',st.favorite,0)=DECODE(' || p_liste_sous_taches || ',''2'',1,0)
  AND DECODE(' || p_liste_sous_taches || ',''3'',pack_liste_isac_conso.a_un_consomme('||p_ident||',a.sous_tache,' || l_anneecourante || '),0)=DECODE(' || p_liste_sous_taches || ',''3'',''O'',0)';

  IF(TO_NUMBER(p_ordre_tri) = 1)THEN
  --commented to fix bug-1996
    --v_requete := v_requete || ' ORDER BY TYPE DESC, FERMEE DESC, IDENTIFIANT,moisfin DESC, datedebut DESC';
    v_requete := v_requete || ' ORDER BY FERMEE DESC, TYPE DESC, IDENTIFIANT,moisfin DESC, datedebut DESC';
  ELSE
  --commented to fix bug-1996
    --v_requete := v_requete || ' ORDER BY TYPE DESC, FERMEE DESC ,LIBELLE_TRI, moisfin DESC, datedebut DESC';
    v_requete := v_requete || ' ORDER BY FERMEE DESC, TYPE DESC, LIBELLE_TRI, moisfin DESC, datedebut DESC';
  END IF;

open p_curseur for v_requete;

  END lister_isac_conso;

END Pack_Liste_Isac_Conso;
/
