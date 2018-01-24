-- pack_liste_rjhPL/SQL
-- 
--
-- Objet : Liste des table de r�partition
-- Tables : RJH_TABREPART
--
-- Modifi� le 30/03/2007 par Emmanuel VINATIER : modification de la clause WHERE
-- Modifi� le 12/04/2007 par Emmanuel VINATIER : Prise en compte des DPG a 7 chiffres
-- Modifi� le 23/04/2007 par Emmanuel VINATIER : changement: controle sur le coddeppole au lieu du DPG
-- Modifi� le 03/07/2007 par Emmanuel VINATIER : filtre sur le PERIMME
-- Modifi� le 11/09/2007 par Emmanuel VINATIER : prise en compte des coddep sur 4 ou 5 chiffre
-- Modifi� le 27/09/2007 par Emmanuel VINATIER : correction de "prise en compte des coddep sur 4 ou 5 chiffre"
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE PACK_LISTE_RJH AS

   TYPE lib_ListeViewType IS RECORD( CODREP RJH_TABREPART.CODREP%TYPE,
   						  	 		 LIB	RJH_TABREPART.LIBREP%TYPE
                                   );

   TYPE lib_listeCurType IS REF CURSOR RETURN lib_ListeViewType;


   -- liste des tables de r�partition suivant le perim�tre de l'utilisateur
   PROCEDURE lister_table_repart( p_userid   IN 	  VARCHAR2,
   			 					  p_codsg IN LIGNE_BIP.CODSG%TYPE,
             	       			  p_curseur  IN OUT lib_listeCurType
                                );

END PACK_LISTE_RJH;
/
CREATE OR REPLACE PACKAGE BODY PACK_LISTE_RJH AS

PROCEDURE lister_table_repart( p_userid  IN VARCHAR2,
		  					   p_codsg IN LIGNE_BIP.CODSG%TYPE,
							   p_curseur IN OUT lib_listeCurType
            ) IS
    l_perime VARCHAR2(1000);
    l_dir    VARCHAR2(255);
	l_pos	 NUMBER;
	l_coddeppole	 RJH_TABREPART.CODDEPPOLE%TYPE;
	
BEGIN
   	-- R�cup�rer le p�rim�tre de l'utilisateur
   	l_perime := pack_global.lire_globaldata(p_userid).perime ;
	l_dir := '';

	-- On fait une boucle pour r�cup�rer les codes directions qu'on met dans la variable
	-- l_dir qui sera ensuite test�e
	while (length(l_perime)>0)
	loop
		if (length(l_dir) > 0) then
		    l_dir := l_dir||','||substr(l_perime,3,2);
		else
			l_dir := substr(l_perime,3,2);
		end if;
	    l_perime := substr(l_perime,13);
	end loop;
	
	l_perime := pack_global.lire_globaldata(p_userid).perime ;

	IF length(p_codsg)=7 THEN l_coddeppole:=5;
						   ELSE l_coddeppole:=4;
	END IF;

	OPEN p_curseur FOR
	    SELECT codrep, codrep ||' - ' || ltrim(rtrim(librep))  LIB
	      FROM RJH_TABREPART
	     WHERE FLAGACTIF = 'O'
	       AND ( (INSTR(l_dir, coddir)>0) or (INSTR(l_dir,'00')>0) )
		   -- recuperation des tab ayant le meme code departmeent et pole que le dpg
		   AND (
		   coddeppole IN (SELECT SUBSTR(codsg,1,5) FROM vue_dpg_perime where INSTR(l_perime,codbddpg) > 0 )
		   OR 
		   coddeppole IN (SELECT SUBSTR(codsg,1,4) FROM vue_dpg_perime where INSTR(l_perime,codbddpg) > 0 )
		   )UNION
		 SELECT 'A_RENSEIGNER' codrep,
		 		'A_RENSEIGNER - Table par d�faut sans r�partition' LIB
		 FROM RJH_TABREPART
	     ORDER BY LIB;


EXCEPTION
    WHEN OTHERS THEN
		raise_application_error(-20997, SQLERRM);

END lister_table_repart;


END PACK_LISTE_RJH;
/
