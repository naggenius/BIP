-- APPLICATION ISAC
-- -------------------------------------
-- pack_liste_isac_sstachelb PL/SQL
-- 
-- Créé le 08/04/2002 par NBM
--Modifié le 19/07/2003 par NBM : suppression de p_ress 
-- Liste des sous-tâches de la ligne BIP
--
-- Utilisée dans la page iaffect.htm
--Modifié le 12/09/2005 par BAA :  ajoute de la procedure nombre_isac_sstachelb
--*****************************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...


CREATE OR REPLACE PACKAGE pack_liste_isac_sstachelb AS


   TYPE sous_tache_ListeViewType IS RECORD( 
				   	SOUS_TACHE VARCHAR2(100),
					LIBELLE	VARCHAR2(500)				
                                         );

   TYPE sous_tache_listeCurType IS REF CURSOR RETURN sous_tache_ListeViewType;

   PROCEDURE lister_isac_sstachelb( 	p_ident 	IN VARCHAR2,
					p_pid   	IN isac_etape.pid%TYPE,
                              		p_userid  	IN VARCHAR2,
                             		p_curseur 	IN OUT sous_tache_listeCurType
                             	);

   -----------------------------------------------------------------------------------
   -- Cette procedure renvoie un message si une ligne bip n''a aucune de sous tache  
   --
   -------------------------------------------------------------------------------------
   
   PROCEDURE nombre_isac_sstachelb( p_pid   	IN isac_etape.pid%TYPE,
   			 						p_message   IN OUT VARCHAR2
   			 						);


END pack_liste_isac_sstachelb;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_isac_sstachelb AS


PROCEDURE lister_isac_sstachelb( 	p_ident 	IN VARCHAR2,
					p_pid   	IN isac_etape.pid%TYPE,
                              		p_userid  	IN VARCHAR2,
                              		p_curseur 	IN OUT sous_tache_listeCurType
                             	) IS

l_count number;

BEGIN

	select count(*) into l_count
	from isac_sous_tache
	where pid=p_pid;

	if l_count=0 then
		OPEN p_curseur FOR
	 	select' ',RPAD(' ',86,' ') from dual;
	else
		OPEN p_curseur FOR		
		select st.etape||'-'||st.tache||'-'||st.sous_tache SOUS_TACHE,
		et.ecet||'-'||RPAD(SUBSTR(et.libetape,1,25),25,' ')||' '||
		RPAD(et.TYPETAPE,2,' ')||' '||ta.acta||'-'||
			RPAD(SUBSTR(ta.libtache,1,25),25,' ')||
		' '||st.acst||'-'||RPAD(SUBSTR(st.asnom,1,25),25,' ')||' '|| RPAD(NVL(st.AIST,' '),6,' ')||' '||
		decode(aff.ident,NULL,'Non','Oui')
		 LIBELLE
		from  isac_affectation aff, isac_sous_tache st, isac_tache ta, isac_etape et
		where aff.sous_tache(+)=st.sous_tache
		and st.tache=ta.tache
		and ta.etape=et.etape
		and et.pid=p_pid
		and aff.ident(+)=to_number(p_ident)
		order by et.ecet,ta.acta,st.acst;

	end if;

END lister_isac_sstachelb;


PROCEDURE nombre_isac_sstachelb( p_pid   	IN isac_etape.pid%TYPE,
   			 						p_message   IN OUT VARCHAR2
   			 					   ) IS
      l_count number;

  BEGIN

     
	  select count(*) into l_count
	       from isac_sous_tache
	       where pid=p_pid;
		   
	  if l_count=0 then	  
	 
	      --p_message := 'Veuillez créer une sous-tâche pour cette ligne : '||p_pid;	
		  pack_global.recuperer_message(21028, '%s1', p_pid, NULL, p_message);   
        
	  end if;   
	  		   
     
	 
  END nombre_isac_sstachelb;


END pack_liste_isac_sstachelb;
/ 

show errors