-- PACK_MESSAGE_PERSO PL/SQL 
--
-- J. Mas
-- Créé le 24/03/2006
-- 
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE PACK_MESSAGE_PERSO AS

   -- Définition curseur sur la table MESSAGE_PERSONNEL
	
   TYPE msgperso_ViewType IS RECORD ( code_mp       message_personnel.code_mp%TYPE,
                   					  titre         message_personnel.titre%TYPE,
					                  texte         message_personnel.texte%TYPE,
					                  date_affiche  VARCHAR2(20),
					                  date_debut    VARCHAR2(20),
					                  date_fin      VARCHAR2(20),
					                  valide        message_personnel.valide%TYPE,
					                  type_mp       message_personnel.type_mp%TYPE
					 	            ); 
 
   TYPE msgpersoCurType_Char IS REF CURSOR RETURN msgperso_ViewType;

   PROCEDURE affiche_liste ( p_userid       IN VARCHAR2,
   							p_listeMenu    IN VARCHAR2,
   							p_listeCentreFrais IN VARCHAR2,
                            p_curmsgperso  IN OUT msgpersoCurType_Char ,
                            p_nbcurseur       OUT INTEGER,
                            p_message         OUT VARCHAR2
                          );

	PROCEDURE message_forum ( p_ident       IN NUMBER,
 						  p_listeMenu    IN VARCHAR2
                         );
                         
   PROCEDURE message_factures_GDM ( p_ident       IN NUMBER
                         			);  
                                             
   PROCEDURE message_factures_ord ( p_ident       IN NUMBER,
									p_listeMenu    IN VARCHAR2,
									p_liste_centre_frais  IN VARCHAR2
                         			);  

END PACK_MESSAGE_PERSO;
/

CREATE OR REPLACE PACKAGE BODY PACK_MESSAGE_PERSO AS 


/*******************************************************************************/
/*                                                                             */
/*       SELECTIONNE LES MESSAGES A AFFICHER POUR UN UTILISATEUR DONNE         */
/*                   ET REGENERE LES MESSAGES                                  */
/*******************************************************************************/
PROCEDURE affiche_liste ( p_userid       IN VARCHAR2,
 						  p_listeMenu    IN VARCHAR2,
 						  p_listeCentreFrais IN VARCHAR2,
                          p_curmsgperso  IN OUT msgpersoCurType_Char ,
                          p_nbcurseur       OUT INTEGER,
                          p_message         OUT VARCHAR2
                         ) IS

	l_msg	   VARCHAR2(1024);
	l_idarpege  RTFE_USER.USER_RTFE%TYPE;
	l_ident		   RTFE_USER.IDENT%TYPE;
	l_codcfrais		VARCHAR2(3);
	
BEGIN
    p_nbcurseur := 1;
    p_message := '';

	-- Recherche les informations de l'utilisateur
	l_idarpege  := PACK_GLOBAL.lire_globaldata(p_userid).idarpege;
	l_codcfrais := PACK_GLOBAL.lire_globaldata(p_userid).codcfrais;

	-- Recherche s'il existe en tant que ressource BIP
	BEGIN
	    SELECT IDENT
		  INTO l_ident
		  FROM RTFE_USER
		 WHERE USER_RTFE = upper(l_idarpege);
		EXCEPTION
 		    WHEN NO_DATA_FOUND THEN
 		    	-- S'il n'existe pas on ne bloque pas le traitement pour autant - on positionne l'ident à 0
				l_ident     := 0;
	        WHEN OTHERS THEN
	            raise_application_error(-20997, SQLERRM);
		END;

	-- Si pas d'identifiant, on ne génére pas de message personnel

	if l_ident> 0 then
		
		-- Regénére le message sur le Forum
		message_forum ( l_ident, p_listeMenu );
		
		-- Regénére le message des factures en attente pour les GDM 
		message_factures_GDM ( l_ident) ;
		
		-- Regénére le Message "Etat des demandes de validation des factures" pour l'ordonnancement
		message_factures_ord ( l_ident, p_listeMenu , p_listeCentreFrais );
 
  	end if ;
 
    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
		
    BEGIN
        OPEN p_curmsgperso FOR
            SELECT p.code_mp, p.titre, p.texte, to_char(p.date_affiche,'DD/MM/YYYY'), to_char(p.date_debut,'DD/MM/YYYY'),
		           to_char(p.date_fin,'DD/MM/YYYY'), p.valide, p.type_mp
              FROM MESSAGE_PERSONNEL p
             WHERE p.ident = l_ident
		     GROUP BY p.code_mp, p.titre, p.texte, to_char(p.date_affiche,'DD/MM/YYYY'), to_char(p.date_debut,'DD/MM/YYYY'),
		           to_char(p.date_fin,'DD/MM/YYYY'), p.valide, p.type_mp;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;


 	  
END affiche_liste;


-- 
-- Message "Forum : messages à valider" (type MP_FORUM_MSG_VAL) 
-- 

/*******************************************************************************/
PROCEDURE message_forum ( p_ident       IN NUMBER,
 						  p_listeMenu    IN VARCHAR2
                         ) IS
	
	l_texte		   MESSAGE_PERSONNEL.TEXTE%TYPE;
	l_typemp	   MESSAGE_PERSONNEL.TYPE_MP%TYPE;
	l_codemp	   MESSAGE_PERSONNEL.CODE_MP%TYPE;
	nb_msg_valider INTEGER;

BEGIN

		l_texte := '';
		l_typemp := 'MP_FORUM_MSG_VAL';

	BEGIN
			
		-- On n'affiche ce message que pour les administrateurs
		if (instr(p_listeMenu,';DIR;')>0 ) then
		
		    select count(*) into nb_msg_valider from MESSAGE_FORUM where statut in ('A', 'M'); 
			   
		    -- suppression du message précédent s'il existe
		    DELETE FROM MESSAGE_PERSONNEL
			 WHERE IDENT=p_ident
			   AND TYPE_MP = l_typemp;
		
			if (nb_msg_valider>0) then
			
			    l_texte := '1 message en attente de validation.';
			
			    if (nb_msg_valider>1) then
				    l_texte := nb_msg_valider||' messages en attente de validation.';
				end if;
				
				-- recherche du prochain CODE_MP
			    SELECT nvl(max(CODE_MP),1) + 1
				  INTO l_codemp
				  FROM MESSAGE_PERSONNEL;

				-- insertion du message
			    INSERT INTO MESSAGE_PERSONNEL 
				      (CODE_MP, IDENT, TITRE, TEXTE, DATE_AFFICHE, DATE_DEBUT, DATE_FIN,
					   VALIDE, TYPE_MP)
				VALUES
					  (l_codemp, p_ident, 'Forum : messages à valider', l_texte, sysdate, sysdate, '31/12/2099',
					   'O', l_typemp);

			end if;
		
		end if;
		
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;
  
END message_forum;

--	
-- Message "demande de validation d'écart de facturation" en attente pour les GDM (type MP_FACT_DEM_VAL)
--
/*******************************************************************************/
PROCEDURE message_factures_GDM ( p_ident       IN NUMBER
                         ) IS
	
	l_texte		   MESSAGE_PERSONNEL.TEXTE%TYPE;
	l_typemp	   MESSAGE_PERSONNEL.TYPE_MP%TYPE;
	l_codemp	   MESSAGE_PERSONNEL.CODE_MP%TYPE;
	nb_dem_attente INTEGER;

BEGIN
		l_texte := '';
		l_typemp := 'MP_FACT_DEM_VAL';
				 		
	BEGIN
		
	    SELECT count(distinct (d.DATDEM))
		  INTO nb_dem_attente
		  FROM DEMANDE_VAL_FACTU d
		 WHERE d.IDENT_GDM = p_ident
		   AND d.STATUT ='A';

	    if (nb_dem_attente = 1) then
		    l_texte := 'Vous avez 1 demande de validation d''écart de facture en attente.';
		elsif (nb_dem_attente > 1) then
		    l_texte := 'Vous avez '||nb_dem_attente||' demandes de validation d''écart de facture en attente.';
		end if;

	    -- suppression du message précédent s'il existe
	    DELETE FROM MESSAGE_PERSONNEL
		 WHERE IDENT=p_ident
		 AND TYPE_MP = l_typemp;

		if (nb_dem_attente > 0) then
				l_codemp := -1;

				-- recherche du prochain CODE_MP
			    SELECT nvl(max(CODE_MP),1) + 1
				  INTO l_codemp
				  FROM MESSAGE_PERSONNEL;
				  
				-- insertion du message
			    INSERT INTO MESSAGE_PERSONNEL 
				      (CODE_MP, IDENT, TITRE, TEXTE, DATE_AFFICHE, DATE_DEBUT, DATE_FIN,
					   VALIDE, TYPE_MP)
				VALUES
					  (l_codemp, p_ident, 'Demande de validation de facture', l_texte, sysdate, sysdate, '31/12/2099',
					   'O', l_typemp);

		END IF;
				   
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;	
  
END  message_factures_GDM;

--	
--Message "Etat des demandes de validation des factures" pour l'ordonnancement (type MP_FACT_DEM_ETA) 
--
/*******************************************************************************/
PROCEDURE message_factures_ord ( p_ident       IN NUMBER,
								 p_listeMenu    IN VARCHAR2,
								 p_liste_centre_frais  IN VARCHAR2
                         ) IS
	
	l_texte		   VARCHAR2(1200);
	l_typemp	   MESSAGE_PERSONNEL.TYPE_MP%TYPE;
	l_codemp	   MESSAGE_PERSONNEL.CODE_MP%TYPE;
    l_where  	   VARCHAR2(1024); -- Chaine pour constituer la requete
    l_codcfrais    NUMBER(3) ;     -- Code retourné par la requete
	nb_dem_attente INTEGER;
	nb_dem_validee INTEGER;
	nb_dem_suspens INTEGER;
	nb_dem 		   INTEGER;

	
   -- ----------------------------------------------------------------------------
   --  Curseur d'extraction des statuts des demandes 
   --  Si la liste des centres de frais commence par 0 sort tout
   -- ----------------------------------------------------------------------------
   TYPE RefCurTyp IS REF CURSOR;
   cur_statut RefCurTyp; -- déclaration du cursor sur les investissements
			 	 		 
BEGIN

-- On n'affiche ce message que pour l'ordonnancement
if (instr(p_listeMenu,';ACH;')>0 ) then


   	--  Curseur d'extraction des statuts des demandes 
   	--  Si la liste des centres de frais commence par 0 sort tout	
	l_where := 'SELECT DISTINCT D.CODCFRAIS '
	        || 'FROM DEMANDE_VAL_FACTU d '
	        || 'WHERE ( d.codcfrais in ( ' || p_liste_centre_frais || ') '
	        || ' or substr(''' || p_liste_centre_frais || ''',1,1)=''0'' ) '
	        || 'AND d.statut <> ''T'' '
	        || 'ORDER BY D.CODCFRAIS ';
	
	
	l_texte := '<ul>';
	nb_dem  := 0 ;
	l_typemp := 'MP_FACT_DEM_ETA';
	BEGIN
	
	    -- suppression du message précédent s'il existe
	    DELETE FROM MESSAGE_PERSONNEL
		 WHERE IDENT=p_ident
		 AND TYPE_MP = l_typemp;	
		
		OPEN cur_statut   for l_where  ;
				
		LOOP
		
			FETCH cur_statut INTO l_codcfrais ;
			
			EXIT WHEN cur_statut%NOTFOUND;
					
			SELECT count(*) INTO nb_dem_attente FROM demande_val_factu 
			WHERE codcfrais = l_codcfrais AND statut = 'A';
			
			SELECT count(*) INTO nb_dem_validee FROM demande_val_factu 
			WHERE codcfrais = l_codcfrais AND statut = 'V';

			SELECT count(*) INTO nb_dem_suspens FROM demande_val_factu 
			WHERE codcfrais = l_codcfrais AND statut = 'S';

			if (nb_dem_attente>0) then
			    l_texte := l_texte ||'<li>'||nb_dem_attente||' demande';
				if (nb_dem_attente>1) then
				    l_texte := l_texte ||'s';
				end if;
				l_texte := l_texte ||' en attente. (Cf. '|| l_codcfrais || ')</li>';
			end if;
			if (nb_dem_validee>0) then
			    l_texte := l_texte ||'<li>'||nb_dem_validee||' demande';
				if (nb_dem_validee>1) then
				    l_texte := l_texte ||'s';
				end if;
				l_texte := l_texte ||' validee GDM. (Cf. '|| l_codcfrais || ')</li>';
			end if;
			if (nb_dem_suspens>0) then
			    l_texte := l_texte ||'<li>'||nb_dem_suspens||' demande';
				if (nb_dem_suspens>1) then
				    l_texte := l_texte ||'s';
				end if;
				l_texte := l_texte ||' en suspens. (Cf. '|| l_codcfrais || ')</li>';
			end if;

			nb_dem := nb_dem + nb_dem_attente + nb_dem_validee + nb_dem_suspens ;
		END LOOP;

		-- Si on a un message à afficher
		if (nb_dem > 0 )then
					
			l_texte := l_texte ||'</ul>';

			-- recherche du prochain CODE_MP
		    SELECT nvl(max(CODE_MP),1) + 1 
			  INTO l_codemp
			  FROM MESSAGE_PERSONNEL;
			  
			-- insertion du message
		    INSERT INTO MESSAGE_PERSONNEL 
			      (CODE_MP, IDENT, TITRE, TEXTE, DATE_AFFICHE, DATE_DEBUT, DATE_FIN,
				   VALIDE, TYPE_MP)
			VALUES
				  (l_codemp, p_ident, 'Etat demande validation de facture', substr(l_texte,1,1000) , sysdate, sysdate, '31/12/2099',
				   'O', l_typemp);

		END IF;
				   
    EXCEPTION
     	WHEN NO_DATA_FOUND THEN
     		l_texte := '';
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;

end if;
	
 
END  message_factures_ord;	



END PACK_MESSAGE_PERSO;
/

