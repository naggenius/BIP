-- APPLICATION ISAC
-- -------------------------------------
-- pack_liste_isac_tache PL/SQL
-- 
-- Créé le 28/03/2002 par NBM
-- Modifié le 03/03/2004 par PJO : PID sur 4 caractères
--
-- Liste des tâches de l'étape choisie
--
-- Utilisée dans la page iltache.htm
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_isac_tache AS

   TYPE tache_ListeViewType IS RECORD( 
				   	TACHE		VARCHAR2(100),
					LISTTACHE 	VARCHAR2(255)
				
                                         );

   TYPE tache_listeCurType IS REF CURSOR RETURN tache_ListeViewType;

   PROCEDURE lister_isac_tache( p_pid     IN isac_tache.pid%TYPE,
				p_etape   IN VARCHAR2,	 
                              	p_userid  IN VARCHAR2,
                              	p_curseur IN OUT tache_listeCurType
                             );

END pack_liste_isac_tache;
/
CREATE OR REPLACE PACKAGE BODY pack_liste_isac_tache AS

PROCEDURE lister_isac_tache( 	p_pid   	IN isac_tache.pid%TYPE,
				p_etape 	IN VARCHAR2,		 
                         	p_userid  	IN VARCHAR2,
                		p_curseur 	IN OUT tache_listeCurType
                             ) IS
l_count number(2);
BEGIN
	select count(*) into l_count
	from isac_tache
	where etape=to_number(p_etape);

	if l_count=0 then
	OPEN p_curseur FOR
	 select' ',RPAD(' ',33,' ') from dual;
	else
	OPEN p_curseur FOR
		select to_char(tache) TACHE,RPAD(ACTA,2,' ')||' '|| RPAD(LIBTACHE,30,' ') LISTACHE
		from isac_tache
		where etape=to_number(p_etape)
		order by acta;
	end if;
END lister_isac_tache;
END pack_liste_isac_tache;
/ 
show errors
