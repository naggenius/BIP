-- pack_liste_dpg_perimo PL/SQL
-- 
-- cree le 26/01/2001 par NBM
--
-- Objet : Liste des BRCLICODE formant un périmètre mo
-- Tables : client_mo
-- Pour le fichier HTML : dtdpgmo.htm


-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_dpg_perimo AS

   PROCEDURE lister_dpg_perimo( 
				p_habilitation 	IN VARCHAR2,
				p_userid 	IN VARCHAR2,
             			p_curseur 	IN OUT pack_liste_dynamique.liste_dyn
            			);

END pack_liste_dpg_perimo;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_dpg_perimo AS 
 
PROCEDURE lister_dpg_perimo( 
				p_habilitation 	IN VARCHAR2,
				p_userid 	IN VARCHAR2,
             			p_curseur 	IN OUT pack_liste_dynamique.liste_dyn
            			)IS
l_habilitation varchar2(10);
BEGIN
    -- p_habilitation est la concaténation du code périmètre sur 5 caractères et du code habilitation
    l_habilitation:=substr(p_habilitation,6,4);
  
    IF l_habilitation='br' THEN 
       		OPEN p_curseur FOR 	
	        SELECT distinct b.codbr as DPG,
	 		LPAD(b.codbr,2,0)||' '||b.libbr
		FROM client_mo c, directions d, branches b
		where c.clidir=d.coddir
		and d.codbr=b.codbr
		order by 1;

    ELSIF l_habilitation='dir' THEN 
       		OPEN p_curseur FOR 
		SELECT distinct clidir as DPG,
			clidir||' '||libbr||'/'||clilib
		FROM client_mo c, directions d, branches b
		where  c.clidir=d.coddir
		and d.codbr=b.codbr
		and clitopf='O'
		order by 1;
    END IF; 


   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM); 

   END lister_dpg_perimo;

END pack_liste_dpg_perimo;
/