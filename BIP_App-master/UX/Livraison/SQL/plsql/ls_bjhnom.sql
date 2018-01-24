-- pack_liste_bjh_matricule PL/SQL
--
-- Maintenance BIP (NBM)
-- Cree le 04/09/2001
--
-- Objet : Permet la création de la liste des personnes qui ont anomalies lors du bouclage
-- Tables : bjh_anomalies et bjh_extbip
--
-- modifié le 19/11/2001 : prise en compte de la nouvelle structure de table
--**********************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
-- 28/11/2011  BSA QC 1281

CREATE OR REPLACE PACKAGE pack_liste_bjh_matricule AS

TYPE matricule_p_RecType IS RECORD (cle    VARCHAR2(8),
                                    lib    VARCHAR2(150));

   TYPE matricule_p_CurType IS REF CURSOR RETURN matricule_p_RecType;

   PROCEDURE lister_bjh_matricule(     p_codsg   IN VARCHAR2,
                                       p_userid  IN VARCHAR2,
                                       p_curseur IN OUT matricule_p_CurType
                                      );




END pack_liste_bjh_matricule;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_bjh_matricule AS

----------------------------------- SELECT -----------------------------------
   PROCEDURE lister_bjh_matricule (p_codsg   IN VARCHAR2,
	                           p_userid  IN VARCHAR2,
                                   p_curseur IN OUT matricule_p_CurType
                                       ) IS

   l_codsg       VARCHAR2(7);
   t_perim_me	 VARCHAR2(1000) := '';

   BEGIN
   
   l_codsg := rtrim(rtrim(LPAD(p_codsg, 7, '0'),'*')) ;
   t_perim_me := pack_global.lire_perime(p_userid);
    
      OPEN p_curseur FOR
      SELECT DISTINCT
            a.matricule,
		RPAD(SUBSTR(r.nom,1,23),23,' ')||' '||
	        RPAD(SUBSTR(r.prenom,1,20),20,' ')||' '||
		LPAD(r.ident,5,' ')||' '||
		RPAD(SUBSTR(a.matricule,1,7),7,' ')
      FROM bjh_anomalies a, bjh_ressource r
      WHERE a.matricule = r.matricule
      AND to_char(r.codsg, 'FM0000000') like l_codsg || '%'
      
      AND r.codsg IN (SELECT codsg FROM vue_dpg_perime where INSTR(t_perim_me, codbddpg) > 0 )
      
      ORDER BY RPAD(SUBSTR(r.nom,1,23),23,' ')||' '||RPAD(SUBSTR(r.prenom,1,20),20,' ')||' '||LPAD(r.ident,5,' ')||' '||RPAD(SUBSTR(a.matricule,1,7),7,' ');


   END lister_bjh_matricule;

END pack_liste_bjh_matricule;
/


