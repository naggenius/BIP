-- pack_liste_pole PL/SQL
--
-- Equipe SOPRA
--
-- Cree le 01/04/1999
--
-- Modifie le 14/03/2000
--
-- Modifie le 06/07/2000  (maintenance, OT)
--	      31/01/2001  NBM : liste des pôles appartenant au périmètre ME de l'utilisateur
--
-- Modifie le 12/06/2003 Pierre JOSSE
--			 Changement de table de référence : detail_perimetre_me a été supprimée
--			 Pour trouver les codes DP correspondant au perimetre du user,
--			 On utilise la vue vu_dpg_perime
--
-- Objet : Permet la création de la liste des poles, chaque element etant de la forme :
-- 		coddeppole + ' ' + sigdep + ' ' + sigpole
-- Tables : struct_info


CREATE OR REPLACE PACKAGE pack_liste_pole AS

   PROCEDURE lister_pole( p_userid   IN VARCHAR2,
                          p_curseur  IN OUT pack_liste_dynamique.liste_dyn
                        );

END pack_liste_pole;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_pole AS

----------------------------------- SELECT -----------------------------------

   PROCEDURE lister_pole( p_userid   IN VARCHAR2,
                          p_curseur  IN OUT pack_liste_dynamique.liste_dyn
                        ) IS

   l_pole      VARCHAR2(25);
   l_perime    VARCHAR2(1000);
   BEGIN
	l_pole := SUBSTR(LPAD(pack_global.lire_globaldata(p_userid).codpole, 7, '0'), 1, 5);
	l_perime := pack_global.lire_globaldata(p_userid).perime;


	IF l_pole  = '00000' THEN 	-- Tous les départements et pôles
	    OPEN p_curseur FOR 
		SELECT *
		FROM 
		   (
		   -- ----------------------------------------------------------------------
		   -- Liste de tous les departements/poles (XXXXX)
		   -- ----------------------------------------------------------------------
		   SELECT DISTINCT
			substr(to_char(codsg,'FM0000000'),1,5) AS code,
			substr(to_char(codsg,'FM0000000'),1,5)  || ' - '  ||
			sigdep                                 || '/'    ||
			sigpole
		   FROM
			struct_info
		   WHERE
			codsg > 1 and topfer like 'O'
		   -- -----
		   UNION
		   -- -----
   		   -- ----------------------------------------------------------------------
		   -- Liste de tous les departements (XXX**)
		   -- ----------------------------------------------------------------------
		   SELECT DISTINCT
			substr(to_char(codsg,'FM0000000'),1,3) || '00'  AS code,
			substr(to_char(codsg,'FM0000000'),1,3) || '00'   || ' - '  ||
			rpad(sigdep,6,' ')
		   FROM
			struct_info
		   WHERE
			codsg > 1 and topfer like 'O'
		   -- -----
		   UNION
		   -- -----
   		   -- ----------------------------------------------------------------------
		   -- Code special '00000'
		   -- ----------------------------------------------------------------------
		   SELECT
			'00000' AS code,
			'00000' || ' - ' || rpad('Tous',6,' ')
		   FROM
			dual
		   );

	ELSE	-- liste des dépt et pôles du périmètre ME de l'utilisateur
	   OPEN p_curseur FOR 
		SELECT *
		FROM (
		   -- Pôles
		   	SELECT DISTINCT SUBSTR(TO_CHAR(me.codsg, 'FM0000000'), 1, 5) AS code,
		   			SUBSTR(TO_CHAR(me.codsg, 'FM0000000'), 1, 5) || ' - ' ||
		   			  sigdep                                     || '/'   ||
		   			  sigpole
		   	FROM    struct_info s,
		   		vue_dpg_perime me
		   	WHERE	s.codsg = me.codsg
		   	    AND s.topfer LIKE 'O'
		   	    AND INSTR(l_perime, me.codbddpg) > 0
		   	    AND me.codhabili IN ('bip', 'br', 'dir', 'dpt', 'pole')
		   UNION
		   -- Départements
		   	SELECT DISTINCT SUBSTR(TO_CHAR(me.codsg, 'FM0000000'), 1, 3) || '00' AS code,
		   			SUBSTR(TO_CHAR(me.codsg, 'FM0000000'), 1, 3) || '00' || ' - ' ||
		   			  RPAD(sigdep, 6, ' ')
		   	FROM    struct_info s,
		   		vue_dpg_perime me
		   	WHERE	s.codsg = me.codsg
		   	    AND s.topfer LIKE 'O'
		   	    AND INSTR(l_perime, me.codbddpg) > 0
		   	    AND me.codhabili IN ('bip', 'br', 'dir', 'dpt')
		);
	END IF;	
   END lister_pole;

END pack_liste_pole;
/