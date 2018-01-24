-- APPLICATION ISAC
-- -------------------------------------
-- pack_liste_isac_restachePL/SQL
-- 
-- Créé le 29/03/2002 par NBM
-- Modifié le 09/07/2003 par NBM : suppression de p_ress et p_pid
-- Liste des sous-tâches de la ressource (ilaffect.htm)
--
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_isac_restache AS
  TYPE sous_tache_ListeViewType IS RECORD( 
				   	SOUS_TACHE VARCHAR2(100),
					LIBELLE	VARCHAR2(500)
				
                                         );

   TYPE sous_tache_listeCurType IS REF CURSOR RETURN sous_tache_ListeViewType;
PROCEDURE lister_isac_restache( p_ident 	IN VARCHAR2,
                              	p_userid  	IN VARCHAR2,
                              	p_curseur 	IN OUT sous_tache_listeCurType
                             	);
END pack_liste_isac_restache;
/
CREATE OR REPLACE PACKAGE BODY pack_liste_isac_restache AS
PROCEDURE lister_isac_restache( p_ident 	IN VARCHAR2,
                              	p_userid  	IN VARCHAR2,
                              	p_curseur 	IN OUT sous_tache_listeCurType
                             	) IS
l_count number(2);
BEGIN
	
	
		OPEN p_curseur FOR
		select et.pid||'-'||st.etape||'-'||st.tache||'-'||st.sous_tache SOUS_TACHE,
		et.pid||' '||et.ecet||'-'||RPAD(SUBSTR(et.libetape,1,25),25,' ')||' '||
		RPAD(et.TYPETAPE,2,' ')||' '||
		ta.acta||'-'||RPAD(SUBSTR(ta.libtache,1,25),25,' ')||
		' '||st.acst||'-'||RPAD(SUBSTR(st.asnom,1,25),25,' ')||
		' ' || RPAD(NVL(st.AIST,' '),6,' ')
		 LIBELLE
		from isac_affectation af, isac_sous_tache st, isac_tache ta, isac_etape et
		where ta.etape=et.etape
		and st.tache=ta.tache
		and af.sous_tache=st.sous_tache
		and af.ident=to_number(p_ident)
		order by et.pid,et.ecet,ta.acta,st.acst;
			
END lister_isac_restache ;


END pack_liste_isac_restache;
/