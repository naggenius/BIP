CREATE OR REPLACE PACKAGE PACK_PARAMETRE AS
	PROCEDURE select_parametre ( p_cle    	IN  parametre.cle%TYPE,
	                            	p_valeur 	OUT  parametre.valeur%TYPE,
	                            	p_listeValeurs OUT  parametre.liste_valeurs%TYPE,
	                            	p_libelle OUT  parametre.libelle%TYPE,
	                            	p_message   	OUT VARCHAR2
	                                );

	PROCEDURE select_lib_parametre ( p_cle    	IN  parametre.cle%TYPE,
                            	p_valeur 	OUT  parametre.valeur%TYPE,
                            	p_message   	OUT VARCHAR2
                                );
	PROCEDURE select_listeval_parametre ( p_cle    	IN  parametre.cle%TYPE,
                            	p_valeur 	OUT  parametre.valeur%TYPE,
                            	p_message   	OUT VARCHAR2
                                );
					
	PROCEDURE update_parametre ( p_cle    	IN  parametre.cle%TYPE,
                            	p_valeur 	IN  parametre.valeur%TYPE,
                            	p_message   	OUT VARCHAR2
                              );
END PACK_PARAMETRE;
/

CREATE OR REPLACE PACKAGE BODY PACK_PARAMETRE AS

	-- Récupération de la valeur d'un paramètre de la table
	PROCEDURE select_parametre ( p_cle    	IN  parametre.cle%TYPE,
	                            	p_valeur 	OUT  parametre.valeur%TYPE,
	                            	p_listeValeurs OUT  parametre.liste_valeurs%TYPE,
	                            	p_libelle OUT  parametre.libelle%TYPE,
	                            	p_message   	OUT VARCHAR2
	                                ) IS
	BEGIN
		select VALEUR,LISTE_VALEURS,LIBELLE into p_valeur, p_listeValeurs, p_Libelle
		from PARAMETRE
		where CLE = p_CLE;
	END select_parametre;
	
	-- Récupération du libelle d'un paramètre de la table
	PROCEDURE select_lib_parametre ( p_cle    	IN  parametre.cle%TYPE,
	                            	p_valeur 	OUT  parametre.valeur%TYPE,
	                            	p_message   	OUT VARCHAR2
	                                ) IS
	BEGIN
		select LIBELLE into p_valeur
		from PARAMETRE
		where CLE = p_CLE;
	END select_lib_parametre;
	
	-- Récupération de la liste des valeurs autorisées d'un paramètre de la table
	PROCEDURE select_listeval_parametre ( p_cle    	IN  parametre.cle%TYPE,
	                            	p_valeur 	OUT  parametre.valeur%TYPE,
	                            	p_message   	OUT VARCHAR2
	                                ) IS
	BEGIN
		select LISTE_VALEURS into p_valeur
		from PARAMETRE
		where CLE = p_CLE;
	END select_listeval_parametre;
			
	
	-- Mise à jour de la valeur d'un paramètre de la table		
	PROCEDURE update_parametre (	p_cle    	IN  parametre.cle%TYPE,
	                            	p_valeur 	IN  parametre.valeur%TYPE,
	                            	p_message   	OUT VARCHAR2
	                              ) 
	IS
		
	BEGIN
		update PARAMETRE set VALEUR = p_valeur where CLE = p_cle;
		IF(p_valeur = 'ACTIVE') THEN
		  update actualite set VALIDE = 'N'
		  where DERNIERE_MINUTE = 'P'
		  AND VALIDE = 'O'
		  AND sysdate BETWEEN date_debut AND date_fin;          
		END IF;
	END update_parametre;
					
END PACK_PARAMETRE;
/
