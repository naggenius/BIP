-- -------------------------------------------------------------------
-- pack_verif_alphres PL/SQL
--
-- equipe SOPRA (HT)
--
-- crée le 21/03/2000
--
-- Package qui sert à la réalisation de l'état ALPHRES
--                   
-- -------------------------------------------------------------------

-- SET SERVEROUTPUT ON SIZE 1000000;

CREATE OR REPLACE PACKAGE pack_verif_alphres  AS


   PROCEDURE verif_alphres(
			p_nomressource IN VARCHAR2,
			p_userid	IN VARCHAR2
			);


	
END pack_verif_alphres;
/

CREATE OR REPLACE PACKAGE BODY pack_verif_alphres  AS 
-- ---------------------------------------------------


PROCEDURE verif_alphres(
			p_nomressource IN VARCHAR2,
			p_userid	IN VARCHAR2
                       )
IS
			
     nom_ress	VARCHAR2(30);
     l_msg	VARCHAR2(100);

   BEGIN
	
	-- Recherche d'un nom de ressource correspondant au critère p_nomressource

	select rnom into nom_ress from ressource 
		where rnom like (REPLACE(p_nomressource,'§','''')  || '%')
		and rownum = 1;

 	EXCEPTION 
 		WHEN NO_DATA_FOUND THEN -- Msg  ressource inconnue 
                          pack_global.recuperer_message(20016, NULL, NULL, NULL, l_msg);
                          raise_application_error(-20016,l_msg);
		WHEN OTHERS THEN
	                 raise_application_error(-20997, SQLERRM);


   END verif_alphres;



 
END pack_verif_alphres;
/
