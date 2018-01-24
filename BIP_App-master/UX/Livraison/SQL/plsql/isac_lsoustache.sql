-- APPLICATION ISAC
-- -------------------------------------
-- pack_liste_isac_sous_tache PL/SQL
-- 
-- Créé le 29/03/2002 par NBM
--
-- Liste des sous-tâches de la tâche choisie
--
-- Utilisée dans la page ilstache.htm
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_isac_sous_tache AS

   TYPE sous_tache_ListeViewType IS RECORD( 
				   	SOUS_TACHE VARCHAR2(100),
					LIBELLE	VARCHAR2(500)
				
                                         );

   TYPE sous_tache_listeCurType IS REF CURSOR RETURN sous_tache_ListeViewType;

   PROCEDURE lister_isac_sous_tache( 	p_pid   	IN isac_sous_tache.pid%TYPE,
					p_etape 	IN VARCHAR2,
					p_tache 	IN VARCHAR2,
					p_libetape	IN VARCHAR2,
					p_libtache 	IN VARCHAR2,
                              		p_userid  	IN VARCHAR2,
                              		p_curseur 	IN OUT sous_tache_listeCurType
                             	);

END pack_liste_isac_sous_tache;
/
CREATE OR REPLACE PACKAGE BODY pack_liste_isac_sous_tache AS

PROCEDURE lister_isac_sous_tache( 	p_pid   	IN isac_sous_tache.pid%TYPE,
					p_etape 	IN VARCHAR2,
					p_tache 	IN VARCHAR2,
					p_libetape	IN VARCHAR2,
					p_libtache 	IN VARCHAR2,
                              		p_userid  	IN VARCHAR2,
                              		p_curseur 	IN OUT sous_tache_listeCurType
                             	) IS
l_count number(2);
BEGIN
	select count(*) into l_count
	from isac_sous_tache
	where pid=p_pid
	and etape=to_number(p_etape)
	and tache=to_number(p_tache);

	if l_count=0 then
	OPEN p_curseur FOR
	 select' ',RPAD(' ',65,' ') from dual;
	else
	OPEN p_curseur FOR
	select SOUS_TACHE , RPAD(acst,2,' ')||' '||RPAD(asnom,30,' ')||'   '||RPAD(NVL(aist,' '),6,' ')||' '||
RPAD(NVL(TO_CHAR(ande,'DD/MM/YYYY'),NVL(TO_CHAR(adeb,'DD/MM/YYYY'),' ')),10,' ')||' '||
RPAD(NVL(TO_CHAR(anfi,'DD/MM/YYYY'),NVL(TO_CHAR(afin,'DD/MM/YYYY'),' ')),10,' ')
LIBELLE
	from isac_sous_tache
	where pid=p_pid
	and etape=to_number(p_etape)
	and tache=to_number(p_tache)
	order by acst;
	end if;
END lister_isac_sous_tache;

END pack_liste_isac_sous_tache;
/ 
show errors