-- pack_liste_cfrais_compo PL/SQL
-- 
-- cree le 11/01/2001 par NBM
-- modifie le 17/06/2003 par NBM : suppression de p_titre et p_habilitation 
-- 
-- Objet : Liste des BDDPG qui compose le centre de frais
-- Tables : 
-- Pour le fichier HTML : detcfrais.htm


-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_cfrais_compo AS


   PROCEDURE lister_cfrais_compo(p_codcfrais 	IN VARCHAR2,
				 p_userid 	IN VARCHAR2,
             			 p_curseur 	IN OUT pack_liste_dynamique.liste_dyn
          );

END pack_liste_cfrais_compo;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_cfrais_compo AS 

PROCEDURE lister_cfrais_compo(	p_codcfrais 	IN VARCHAR2,
				p_userid 	IN VARCHAR2,
             			p_curseur 	IN OUT pack_liste_dynamique.liste_dyn
           ) IS

BEGIN

      OPEN p_curseur FOR 
	select 	codbddpg||decode(topfer,'F','F','O') as DPG,
	       	NVL(substr(codbddpg,1,2),'  ')||' '||NVL(substr(codbddpg,3,2),'  ')||' '||NVL(substr(codbddpg,5,7),'      ') ||'  '||
		NVL(RPAD(libbddpg,28,' '),'                      ') ||'  '||
		NVL(RPAD(decode(codhabili,'br',	 'Branche'
					 ,'dir', 'Direction'
					 ,'dpt', 'Département'
					 ,'pole','Pôle',
					 'Groupe'),11,' '),'             ')||'  '||
		NVL(decode(topfer,'F','F','O'),' ')
	from compo_centre_frais
	where codcfrais=to_number(p_codcfrais)
	order by codhabili;


   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM); 

   END lister_cfrais_compo;
END pack_liste_cfrais_compo;
/
