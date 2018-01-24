-- pack_liste_dpg_cfrais PL/SQL
-- 
-- cree le 09/01/2001 par NBM
-- modifié le 17/06/2003 par NBM : suppression de p_titre
--
-- Objet : Liste des DPG formant un centre de frais
-- Tables : struct_info
-- Pour le fichier HTML : dccfrais.htm


-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_dpg_cfrais AS

   PROCEDURE lister_dpg_cfrais( p_codcfrais IN VARCHAR2,
				p_habilitation IN VARCHAR2,
				p_userid IN VARCHAR2,
             			p_curseur IN OUT pack_liste_dynamique.liste_dyn
            			);

END pack_liste_dpg_cfrais;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_dpg_cfrais AS 
 
PROCEDURE lister_dpg_cfrais( p_codcfrais IN VARCHAR2,
				p_habilitation IN VARCHAR2,
				p_userid IN VARCHAR2,
             			p_curseur IN OUT pack_liste_dynamique.liste_dyn
            			)IS

BEGIN

    IF p_habilitation='br' THEN 
       		OPEN p_curseur FOR 	
	        SELECT distinct codbr as DPG,
	 		LPAD(codbr,2,0)||' '||libbr
		FROM branches b
		order by 1;

    ELSIF p_habilitation='dir' THEN 
       		OPEN p_curseur FOR 
		SELECT distinct d.coddir as DPG,
			LPAD(d.coddir,2,0)||' '||b.libbr||'/'||d.libdir
		FROM directions d,branches b
		where d.codbr=b.codbr
		order by 1;

    ELSIF p_habilitation='dpt' THEN 
        	OPEN p_curseur FOR    --pour bien différencier les mêmes codes dep
		SELECT distinct s.topfer||lpad(s.coddep,3,0)||lpad(s.coddir,2,0) as DPG,    
			LPAD(s.coddep,3,0)||' '||b.libbr||'/'||d.libdir||'/'||s.sigdep||'  '||s.topfer
		FROM struct_info s, directions d, branches b
		where s.coddir=d.coddir
		and d.codbr=b.codbr
		order by 2;

    ELSIF p_habilitation='pole' THEN 
        	OPEN p_curseur FOR 
		SELECT distinct topfer||substr(lpad(s.codsg,7,0),1,5)||lpad(s.coddir,2,0) as DPG,
	        substr(lpad(s.codsg,7,0),1,5)||' '||b.libbr||'/'||d.libdir||'/'||s.sigdep||'/'||s.sigpole||'  '||s.topfer
		FROM struct_info s, directions d, branches b
		where s.coddir=d.coddir
		and d.codbr=b.codbr
		order by 2;
    
    END IF; 

    
   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM); 

   END lister_dpg_cfrais;

END pack_liste_dpg_cfrais;
/
