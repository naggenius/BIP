CREATE OR REPLACE PACKAGE pack_liste_isac_tachelb_copier AS

       TYPE sous_tache_ListeViewType IS RECORD(
                                        SOUS_TACHE VARCHAR2(100),
                                        LIBELLE VARCHAR2(500)
                                         );

       TYPE sous_tache_listeCurType IS REF CURSOR RETURN sous_tache_ListeViewType;

       -- liste des sous-taches à copier
       PROCEDURE lister_isac_sstachelb_copier(  
                                    	p_pid_src   	IN VARCHAR2,                                    
                                        p_userid        IN VARCHAR2,
                                        p_curseur       IN OUT sous_tache_listeCurType
                                );

       --liste des taches ou sera collee la sous-tache choisie 
       PROCEDURE lister_isac_sstachelb_coller(
                                        p_pid_dest      IN VARCHAR2,
                                        p_userid        IN VARCHAR2,
                                        p_curseur       IN OUT sous_tache_listeCurType
                                );

END pack_liste_isac_tachelb_copier;
/


CREATE OR REPLACE PACKAGE BODY pack_liste_isac_tachelb_copier AS
       PROCEDURE lister_isac_sstachelb_copier(  
                                    p_pid_src   IN VARCHAR2,                                    
                                    p_userid    IN VARCHAR2,
                                    p_curseur   IN OUT sous_tache_listeCurType
                                ) IS
       l_count number;

       BEGIN

        select count(*) into l_count
        from isac_sous_tache
        where pid=p_pid_src;

        if l_count=0 then
                OPEN p_curseur FOR
                select' ',RPAD(' ',86,' ') from dual;
        else
                OPEN p_curseur FOR
                select st.etape||'-'||st.tache||'-'||st.sous_tache "SOUS_TACHE",
                et.ecet||'-'||RPAD(SUBSTR(et.libetape,1,25),25,' ')||' '||ta.acta||'-'||
                        RPAD(SUBSTR(ta.libtache,1,25),25,' ')||
                ' '||st.acst||'-'||RPAD(SUBSTR(st.asnom,1,25),25,' ') "LIBELLE"
                from  isac_sous_tache st, isac_tache ta, isac_etape et
                where st.tache=ta.tache
                and ta.etape=et.etape
                and et.pid=p_pid_src            
                order by et.ecet,ta.acta,st.acst;
        end if;

      END lister_isac_sstachelb_copier;

      PROCEDURE lister_isac_sstachelb_coller(     
                                    p_pid_dest  IN VARCHAR2,                                    
                                    p_userid    IN VARCHAR2,
                                    p_curseur   IN OUT sous_tache_listeCurType
                                ) IS
       l_count number;

       BEGIN

        select count(*) into l_count
        from isac_tache
        where pid=p_pid_dest;

        if l_count=0 then
                OPEN p_curseur FOR
                select' ',RPAD(' ',86,' ') from dual;
        else
                OPEN p_curseur FOR
                select ta.etape||'-'||ta.tache "TACHE",
                et.ecet||'-'||RPAD(SUBSTR(et.libetape,1,25),25,' ')||' '||ta.acta||'-'||
                        RPAD(SUBSTR(ta.libtache,1,25),25,' ') "LIBELLE"
                from  isac_tache ta, isac_etape et
                where ta.etape=et.etape
                and et.pid=p_pid_dest           
                order by et.ecet,ta.acta;
        end if;

      END lister_isac_sstachelb_coller;


END pack_liste_isac_tachelb_copier;
/

