-- APPLICATION ISAC
-- -------------------------------------
-- pack_liste_isac_tachelb PL/SQL
-- 
-- Créé le 28/03/2002 par NBM
--
-- Liste des tâches de la ligne BIP
--
-- Utilisée dans la page igstache.htm
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_isac_tachelb AS

   TYPE tache_ListeViewType IS RECORD( 
				   	TACHE		VARCHAR2(100),
					LISTTACHE 	VARCHAR2(255)
				
                                         );

   TYPE tache_listeCurType IS REF CURSOR RETURN tache_ListeViewType;

   PROCEDURE lister_isac_tachelb(p_pid     IN isac_tache.pid%TYPE,
                              	 p_userid  IN VARCHAR2,
                              	 p_curseur IN OUT tache_listeCurType
                             );

END pack_liste_isac_tachelb;
/
CREATE OR REPLACE PACKAGE BODY pack_liste_isac_tachelb AS

PROCEDURE lister_isac_tachelb( 	p_pid     IN isac_tache.pid%TYPE,	 
                         	p_userid  IN VARCHAR2,
                		p_curseur IN OUT tache_listeCurType
                             ) IS

l_count number;
BEGIN
	select count(*) into l_count
	from isac_tache t, isac_etape e
	where  t.etape=e.etape
	and t.pid=p_pid;

	IF l_count=0 THEN
	OPEN p_curseur FOR
		select' ',RPAD(' ',67,' ') from dual;
	ELSE

	OPEN p_curseur FOR
	select to_char(e.etape)||'-'||to_char(t.tache) TACHE,
RPAD(e.ecet,2,' ') ||'-'||RPAD(e.libetape,30,' ')||' '||RPAD(t.acta,2,' ')||'-'|| RPAD(t.libtache,30,' ') LISTACHE
	from isac_tache t, isac_etape e
	where  t.etape=e.etape
	and t.pid=p_pid
	order by e.ecet,t.acta;

	END IF;
END lister_isac_tachelb;
END pack_liste_isac_tachelb;
/ 
show errors
