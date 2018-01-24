-- pack_liste_groupe PL/SQL
--
-- Noï BACCAM
--
--
-- Objet : Permet la création de la liste des poles, dépts, groupes
-- 
-- Modifie le 12/06/2003 Pierre JOSSE
--			 Changement de table de référence : detail_perimetre_me a été supprimée
--			 Pour trouver les codes DPG correspondant au perimetre du user,
--			 On utilise la vue vu_dpg_perime
-- Tables : struct_info
-- Modifie le 30/09/2010 YNI FDT 929


CREATE OR REPLACE PACKAGE pack_liste_groupe AS

   PROCEDURE lister_groupe( p_userid   IN VARCHAR2,
                            p_curseur  IN OUT pack_liste_dynamique.liste_dyn
                        );

END pack_liste_groupe;
/
create or replace
PACKAGE BODY       "PACK_LISTE_GROUPE" AS

----------------------------------- SELECT -----------------------------------

   PROCEDURE lister_groupe( p_userid   IN VARCHAR2,
                            p_curseur  IN OUT pack_liste_dynamique.liste_dyn
                        ) IS

   l_pole      VARCHAR2(7);
   l_perime    varchar2(1000);

   BEGIN
   	l_pole := pack_global.lire_globaldata(p_userid).codpole;
	l_perime := pack_global.lire_globaldata(p_userid).perime;


	IF (l_pole  = '000000' or (INSTR(l_perime, '00000000000')>0)) THEN 	-- Tous les départements et pôles
	    OPEN p_curseur FOR
		SELECT *
		FROM
		   (
		   -- ----------------------------------------------------------------------
		   -- Liste de tous les groupes
		   -- ----------------------------------------------------------------------
		   SELECT to_char(codsg,'FM0000000') AS code,
			to_char(codsg,'FM0000000')|| ' - '  ||
			libdsg --substr(libdsg,1,12)
	    FROM
			struct_info
		   WHERE
			codsg > 1 and topfer like 'O'
		   -- -----
		   UNION
		   -- -----
		   -- ----------------------------------------------------------------------
		   -- Liste de tous les departements/poles (XXXX)
		   -- ----------------------------------------------------------------------
		   SELECT DISTINCT
			substr(to_char(codsg,'FM0000000'),1,5)||'00' AS code,
			substr(to_char(codsg,'FM0000000'),1,5)||'00'||' - '  ||
			sigdep                                      || '/'   ||
			sigpole
		   FROM
			struct_info
		   WHERE
			codsg > 1 and topfer like 'O'
		   -- -----
		   UNION
		   -- -----
   		   -- ----------------------------------------------------------------------
		   -- Liste de tous les departements (XX**)
		   -- ----------------------------------------------------------------------
		   SELECT DISTINCT
			substr(to_char(codsg,'FM0000000'),1,3) || '0000'  AS code,
			substr(to_char(codsg,'FM0000000'),1,3) || '0000' || ' - '  ||
			rpad(sigdep,6,' ')
		   FROM
			struct_info
		   WHERE
			codsg > 1 and topfer like 'O'
		   -- -----
		   UNION
		   -- -----
   		   -- ----------------------------------------------------------------------
		   -- Code special '0000'
		   -- ----------------------------------------------------------------------
		   SELECT
			'000000' AS code,
			'000000' || ' - ' || rpad('Tous',6,' ')
		   FROM
			dual
		   )  ;

	ELSE	-- liste des dépt et pôles du périmètre ME de l'utilisateur
	   OPEN p_curseur FOR
		SELECT *
		FROM (
		   -- Groupes
		   	SELECT DISTINCT TO_CHAR(me.codsg, 'FM0000000') AS code,
		   			TO_CHAR(me.codsg, 'FM0000000') || ' - ' ||
		   			  libdsg--substr(s.libdsg,1,12)
		   	FROM    struct_info s,
		   		vue_dpg_perime me
		   	WHERE	s.codsg = me.codsg
		   	    AND s.topfer LIKE 'O'
		   	    AND INSTR(l_perime, me.codbddpg) > 0
		   	    AND me.codhabili IN ('bip', 'br', 'dir', 'dpt', 'pole', 'grpe')
		   UNION
		   -- Pôles
		   	SELECT DISTINCT SUBSTR(TO_CHAR(me.codsg, 'FM0000000'), 1, 5) || '00' AS code,
		   			SUBSTR(TO_CHAR(me.codsg, 'FM0000000'), 1, 5) || '00' || ' - ' ||
		   			  sigdep                                     || '/'  ||
		   			  sigpole
		   	FROM    struct_info s,
		   		vue_dpg_perime me
		   	WHERE	s.codsg = me.codsg
		   	    AND s.topfer LIKE 'O'
		   	    AND INSTR(l_perime, me.codbddpg) > 0
		   	    AND me.codhabili IN ('bip', 'br', 'dir', 'dpt', 'pole')
		   UNION
		   -- Départements
		   	SELECT DISTINCT SUBSTR(TO_CHAR(me.codsg, 'FM0000000'), 1, 3) || '0000' AS code,
		   			SUBSTR(TO_CHAR(me.codsg, 'FM0000000'), 1, 3) || '0000' || ' - ' ||
		   			  RPAD(sigdep, 6, ' ')
		   	FROM    struct_info s,
		   		vue_dpg_perime me
		   	WHERE	s.codsg = me.codsg
		   	    AND s.topfer LIKE 'O'
		   	    AND INSTR(l_perime, me.codbddpg) > 0
		   	    AND me.codhabili IN ('bip', 'br', 'dir', 'dpt')
		);
	END IF;
   END lister_groupe;

END pack_liste_groupe;

/