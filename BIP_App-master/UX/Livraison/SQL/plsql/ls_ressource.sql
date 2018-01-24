--- 21/11/2008 Modifie par ABA  : recupère la liste des ressource en fonction du codsg passé en paramètre
-- 30/11/2011 BSA QC 1281

CREATE OR REPLACE PACKAGE     pack_liste_ressource AS


   -- Liste des type de dossier projet
TYPE ress_liste_ViewType IS RECORD (     CODE_RESSOURCE         VARCHAR2(5),
                                        RESSOURCE             VARCHAR2(100)
                                     );

--FAD PPM 60955
TYPE rejet_ress_contart IS RECORD ( CODE NUMBER, LIBELLE VARCHAR2(255));
TYPE RefCurRejets IS REF CURSOR RETURN rejet_ress_contart;
PROCEDURE lister_rejets_ress_contrat (  p_userid  IN VARCHAR2, p_menu IN VARCHAR2, p_perimme IN VARCHAR2,
                                        p_centre_frais IN VARCHAR2, p_curseur IN OUT RefCurRejets );
-- FAD Fin

TYPE ress_listeCurType IS REF CURSOR RETURN ress_liste_ViewType;


PROCEDURE liste_ress_dpg(  p_codsg     IN VARCHAR2,
                               p_userid     IN VARCHAR2,                              
                               p_curseur     IN OUT ress_listeCurType
                             );
                             
END pack_liste_ressource;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_ressource AS


 PROCEDURE liste_ress_dpg(     p_codsg     IN VARCHAR2,
                               p_userid     IN VARCHAR2,
                               p_curseur     IN OUT ress_listeCurType
                             ) IS
                             
    l_msg           VARCHAR2(1024);
    l_FmtCharDPG    VARCHAR2(10) := '';
    l_codsg         VARCHAR2(7);
    l_perim_me      VARCHAR2(1000);

BEGIN

    l_perim_me := pack_global.lire_perime( p_userid);
    
    l_codsg := RTRIM(LTRIM(p_codsg));
    

    BEGIN
        OPEN p_curseur FOR
              SELECT res.ident code, res.rnom || ' ' || res.rprenom|| ' - ' ||res.ident LIB_RESS
                FROM
                struct_info str, datdebex    bex, ressource res, situ_ress situ
              WHERE  situ.codsg = str.codsg (+)
                    AND situ.ident=res.ident
                    AND (situ.DATDEP>bex.datdebex OR datdep is null)                           
                    AND str.CODSG >= to_number(replace(l_codsg,'*','0') )
                    AND str.CODSG <= to_number(replace(l_codsg,'*','9') )                             
                    AND str.codsg IN (SELECT codsg FROM vue_dpg_perime where INSTR(l_perim_me , codbddpg) > 0 )                            
            GROUP BY res.rnom,res.rprenom, res.ident
            ORDER BY res.rnom;
            
     EXCEPTION
        WHEN No_Data_Found THEN
         BEGIN
              l_msg := 'Veuillez selectionner une ressource';
              raise_application_error(-20203,l_msg);
         END;
        WHEN OTHERS THEN
             raise_application_error( -20997, SQLERRM);
    END;

END liste_ress_dpg;

--FAD PPM 60955 : Début
PROCEDURE  lister_rejets_ress_contrat  (  p_userid  IN VARCHAR2, p_menu IN VARCHAR2, p_perimme IN VARCHAR2,
                                        p_centre_frais IN VARCHAR2, p_curseur IN OUT RefCurRejets ) IS
  DATE_TRAITEMENT VARCHAR2(10);
  id_trait NUMBER;
  CF VARCHAR2(400);
  REQ VARCHAR2(10000);
  DT VARCHAR2(10);
BEGIN

  CF := REPLACE(P_CENTRE_FRAIS, ',', ''',''');
  CF := '''' || CF || '''';

  SELECT BIP.SETATKE.NEXTVAL INTO id_trait FROM DUAL ;
  --Récupération de la dernière date de traitement depuis les tables PRA_CONTRAT et PRA_RESSOURCE
  BEGIN
	SELECT TO_CHAR(MAX(DATE_TRAIT), 'DD/MM/YYYY') INTO DATE_TRAITEMENT
		FROM
		(SELECT DATE_TRAIT FROM PRA_CONTRAT
		UNION
		SELECT DATE_TRAIT FROM PRA_RESSOURCE);
  EXCEPTION WHEN OTHERS THEN
    DATE_TRAITEMENT := NULL;
  END;

  IF p_menu = 'ME' THEN
    INSERT INTO TMP_REJ_RESS_CONT (ID_TRAITEMENT,ID_REJET, REJET, DATE_EDITION)
    SELECT id_trait, rownum, req.libelle, SYSDATE
    FROM (
      SELECT DISTINCT RETOUR libelle
      FROM PRA_RESSOURCE
      WHERE TO_CHAR(DATE_TRAIT, 'DD/MM/YYYY') = DATE_TRAITEMENT
      AND CODE_RETOUR = '0'
      AND (
        DPG IN (SELECT codsg FROM vue_dpg_perime where INSTR(p_perimme, codbddpg) > 0)
        OR RETOUR LIKE 'DPG non renseigné%'
        OR RETOUR LIKE 'DPG inconnu%'
      )

      UNION

      SELECT DISTINCT RETOUR libelle
      FROM PRA_CONTRAT
      WHERE TO_CHAR(DATE_TRAIT, 'DD/MM/YYYY') = DATE_TRAITEMENT
      AND CODE_RETOUR = '0'
      AND (
        DPG IN (SELECT codsg FROM vue_dpg_perime where INSTR(p_perimme, codbddpg) > 0)
        OR RETOUR LIKE 'DPG non renseigné%'
        OR RETOUR LIKE 'DPG inconnu%'
      )
    ) req;
  ELSE
    IF p_centre_frais = '0' THEN
      INSERT INTO TMP_REJ_RESS_CONT (ID_TRAITEMENT,ID_REJET, REJET, DATE_EDITION)
      SELECT id_trait, rownum, req.libelle, SYSDATE
      FROM (
      SELECT DISTINCT RETOUR libelle
        FROM PRA_RESSOURCE
        WHERE TO_CHAR(DATE_TRAIT, 'DD/MM/YYYY') = DATE_TRAITEMENT
        AND CODE_RETOUR = '0'
    
        UNION
    
        SELECT DISTINCT RETOUR libelle
        FROM PRA_CONTRAT
        WHERE TO_CHAR(DATE_TRAIT, 'DD/MM/YYYY') = DATE_TRAITEMENT
        AND CODE_RETOUR = '0'
        ) req;
    ELSE
      REQ := 'INSERT INTO TMP_REJ_RESS_CONT (ID_TRAITEMENT,ID_REJET, REJET, DATE_EDITION)
      SELECT '||id_trait||', rownum, req.libelle, SYSDATE
      FROM (
      SELECT DISTINCT RETOUR libelle
        FROM PRA_RESSOURCE
        LEFT JOIN 
			(SELECT IDENT, CODSG
			FROM SITU_RESS
			WHERE
			(IDENT, NVL(DATDEP, SYSDATE)) IN (SELECT IDENT, MAX(NVL(DATDEP, SYSDATE)) FROM SITU_RESS GROUP BY IDENT)
			AND TRUNC(SYSDATE) BETWEEN TRUNC(DATSITU) AND TRUNC(NVL(DATDEP, SYSDATE))
			)
		SR ON PRA_RESSOURCE.IDENT_DO = SR.IDENT
        LEFT JOIN STRUCT_INFO ON SR.CODSG  = STRUCT_INFO.CODSG

        WHERE TO_CHAR(DATE_TRAIT, ''DD/MM/YYYY'') = ''' || DATE_TRAITEMENT || '''
        AND CODE_RETOUR = ''0''
        AND (
          to_char(STRUCT_INFO.SCENTREFRAIS) IN ('||CF||')
          OR RETOUR LIKE ''DPG non renseigné%''
          OR RETOUR LIKE ''DPG inconnu%''
        )

        UNION

        SELECT DISTINCT RETOUR libelle
        FROM PRA_CONTRAT
        LEFT JOIN STRUCT_INFO ON PRA_CONTRAT.DPG  = STRUCT_INFO.CODSG

        WHERE TO_CHAR(DATE_TRAIT, ''DD/MM/YYYY'') = ''' || DATE_TRAITEMENT || '''
        AND CODE_RETOUR = ''0''
        AND (
          TO_CHAR(STRUCT_INFO.SCENTREFRAIS) IN ('||CF||')
          OR RETOUR LIKE ''DPG non renseigné%''
          OR RETOUR LIKE ''DPG inconnu%''
        )
      ) req';

      EXECUTE IMMEDIATE REQ;

    END IF;
  END IF;
  OPEN p_curseur FOR
    SELECT id_trait code, '0' libelle FROM DUAL
    UNION
    SELECT ID_REJET code, REJET libelle
    FROM TMP_REJ_RESS_CONT WHERE ID_TRAITEMENT = id_trait
    ORDER BY libelle;
END  lister_rejets_ress_contrat;
--FAD PPM 60955 : Fin



END pack_liste_ressource;
/


