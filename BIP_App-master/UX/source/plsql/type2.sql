-- pack_type_activite PL/SQL
--
-- Equipe SOPRA
--
-- Créé le 18/02/99
-- 21/06/2004 PJO : Fiche 308 : Ajout de top actif et de liaison avec les types 1
--
--
-- **********************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_type_activite AS

   TYPE type_activite_ViewType IS RECORD( arctype 	type_activite.arctype%TYPE,
   					  libarc	type_activite.libarc%TYPE,
   					  actif		type_activite.actif%TYPE,
   					  listeType1	VARCHAR2(30),
   					  flaglock	type_activite.flaglock%TYPE
   					  );

   TYPE type_activiteCurType IS REF CURSOR RETURN type_activite_ViewType;

   PROCEDURE insert_type_activite (p_arctype   	IN  type_activite.arctype%TYPE,
                                   p_libarc    	IN  type_activite.libarc%TYPE,
                                   p_actif      IN  type_activite.actif%TYPE,
                                   p_listeType1	IN  VARCHAR2,
                                   p_global    	IN  VARCHAR2,
                                   p_nbcurseur 	OUT INTEGER,
                                   p_message   	OUT VARCHAR2
                                  );

   PROCEDURE update_type_activite (p_arctype    IN  type_activite.arctype%TYPE, 
                                   p_libarc     IN  type_activite.libarc%TYPE,
                                   p_actif      IN  type_activite.actif%TYPE,
                                   p_listeType1	IN  VARCHAR2,
                                   p_flaglock   IN  NUMBER,
                                   p_global     IN  VARCHAR2,
                                   p_nbcurseur  OUT INTEGER,
                                   p_message    OUT VARCHAR2
                                  );

   PROCEDURE delete_type_activite (p_arctype   IN type_activite.arctype%TYPE,
                                   p_libarc    IN type_activite.libarc%TYPE,
                                   p_flaglock  IN NUMBER,
                                   p_global    IN VARCHAR2,
                                   p_nbcurseur OUT INTEGER,
                                   p_message   OUT VARCHAR2
	   	    	                );

   PROCEDURE select_type_activite (p_arctype   IN type_activite.arctype%TYPE,
                                   p_global    IN VARCHAR2,
                                   p_cursor    IN OUT type_activiteCurType,
                                   p_nbcurseur OUT INTEGER,
                                   p_message   OUT VARCHAR2
                                  );

END pack_type_activite;
/

CREATE OR REPLACE PACKAGE BODY pack_type_activite AS 

   PROCEDURE insert_type_activite (p_arctype    IN  type_activite.arctype%TYPE,
                                   p_libarc     IN  type_activite.libarc%TYPE,
                                   p_actif      IN  type_activite.actif%TYPE,
                                   p_listeType1	IN  VARCHAR2,
                                   p_global     IN  VARCHAR2,
                                   p_nbcurseur 	OUT INTEGER,
                                   p_message   	OUT VARCHAR2
                                  ) IS 
      msg 		VARCHAR(1024);
      l_liste_Type1 	VARCHAR2(50);
      l_type1		lien_types_proj_act.type_proj%TYPE;
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         INSERT INTO type_activite ( arctype, 
                                     libarc,
                                     actif)
         VALUES ( p_arctype, 
                  p_libarc,
                  p_actif);

      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN

            -- 'Code typologie secondaire existe déjà'

            pack_global.recuperer_message(20614, NULL,NULL,NULL,msg);  
            raise_application_error( -20614, msg );

         WHEN OTHERS THEN
            raise_application_error( -20997,SQLERRM);

      END;

      -- On ratache les types 1 avec les types 2
      	BEGIN
      	  l_liste_Type1 := p_listeType1;
      	  WHILE INSTR(l_liste_Type1, ';') > 0 LOOP
      	  	l_type1 := SUBSTR(l_liste_Type1, 1, 2);
      	  	INSERT 	INTO lien_types_proj_act (type_proj, type_act)
      	  		VALUES (l_type1, p_arctype);
      	  	l_liste_Type1 := SUBSTR(l_liste_Type1, INSTR(l_liste_Type1, ';') + 1);
      	  END LOOP;
      	  	  
	EXCEPTION
         WHEN OTHERS THEN
            raise_application_error( -20997,SQLERRM);
        END;
      

      -- 'Code typologie secondaire ' || p_libarc|| ' créé';

      pack_global.recuperer_message( 6010, '%s1', p_libarc, NULL, msg);  
      p_message := msg;

   END insert_type_activite;


   PROCEDURE update_type_activite (p_arctype   	IN  type_activite.arctype%TYPE,
                                   p_libarc    	IN  type_activite.libarc%TYPE,
                                   p_actif      IN  type_activite.actif%TYPE,
                                   p_listeType1	IN  VARCHAR2,
                                   p_flaglock  	IN  NUMBER,
                                   p_global    	IN  VARCHAR2,
                                   p_nbcurseur 	OUT INTEGER,
                                   p_message   	OUT VARCHAR2
                                  ) IS 
      msg 		VARCHAR2(1024);
      l_liste_Type1 	VARCHAR2(50);
      l_type1		lien_types_proj_act.type_proj%TYPE;
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN 
         UPDATE type_activite 
         SET libarc    = p_libarc,
             actif     = p_actif,
             flaglock  = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE arctype  = p_arctype
         AND   flaglock = p_flaglock;

      EXCEPTION
         WHEN OTHERS THEN
            raise_application_error( -20997,SQLERRM);

      END;

      IF SQL%NOTFOUND THEN
         
         -- 'Accès concurrent'

         pack_global.recuperer_message(20999, NULL,NULL,NULL,msg);  
         raise_application_error( -20999, msg );                     

      END IF;

      -- On supprime les anciennes liaisons et
      -- On ratache les types 1 avec les types 2
      	BEGIN
      	  DELETE lien_types_proj_act WHERE type_act = p_arctype;
      	
      	  l_liste_Type1 := p_listeType1;
      	  WHILE INSTR(l_liste_Type1, ';') > 0 LOOP
      	  	l_type1 := SUBSTR(l_liste_Type1, 1, 2);
      	  	INSERT 	INTO lien_types_proj_act (type_proj, type_act)
      	  		VALUES (l_type1, p_arctype);
      	  	l_liste_Type1 := SUBSTR(l_liste_Type1, INSTR(l_liste_Type1, ';') + 1);
      	  END LOOP;
      	  	  
	EXCEPTION
         WHEN OTHERS THEN
            raise_application_error( -20997,SQLERRM);
        END;
        
         -- 'Code typologie secondaire ' || p_libarc|| 'modifié' ;

         pack_global.recuperer_message( 6011 , '%s1', p_libarc, NULL, msg);  
         p_message := msg; 


   END update_type_activite;


   PROCEDURE delete_type_activite (p_arctype   IN type_activite.arctype%TYPE,
                                   p_libarc    IN type_activite.libarc%TYPE,
                                   p_flaglock  IN NUMBER,
                                   p_global    IN VARCHAR2,
                                   p_nbcurseur OUT INTEGER,
                                   p_message   OUT VARCHAR2
                                  ) IS 
      msg VARCHAR(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN

         -- On supprime les liens avec les types 1
         DELETE lien_types_proj_act WHERE type_act = p_arctype;
      
      	 -- on supprime le lien
         DELETE FROM type_activite 
         WHERE arctype = p_arctype
         AND  flaglock = p_flaglock;

      EXCEPTION
         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2292);

         WHEN OTHERS THEN
            raise_application_error( -20997,SQLERRM);
      END;

      IF SQL%NOTFOUND THEN

         --'Accès concurrent'

         pack_global.recuperer_message( 20999, NULL, NULL, NULL, msg);  
         raise_application_error( -20999, msg );                     
      ELSE

         -- 'Code typologie secondaire ' || p_libarc|| 'supprimé' ;

         pack_global.recuperer_message( 6012 , '%s1', p_libarc, NULL, msg);  
         p_message := msg; 
      END IF;

   END delete_type_activite;


   PROCEDURE select_type_activite (p_arctype   IN type_activite.arctype%TYPE,
                                   p_global    IN VARCHAR2,
                                   p_cursor    IN OUT type_activiteCurType,
                                   p_nbcurseur OUT INTEGER,
                                   p_message   OUT VARCHAR2
                                  ) IS 
      msg VARCHAR(1024);
      l_listeType1 VARCHAR2(50);
      l_type1 lien_types_proj_act.type_proj%TYPE;
      
      CURSOR type1_curs IS
        SELECT typproj
        FROM type_projet;
   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';
      l_listeType1 := '';

      -- On construit la liste des types1
      FOR type1_rec IN type1_curs LOOP
      	BEGIN
      	  SELECT type_proj INTO l_type1
      	  FROM lien_types_proj_act
      	  WHERE type_proj = type1_rec.typproj
      	    AND type_act = p_arctype;
      	  
      	  l_listeType1 := l_listeType1 || type1_rec.typproj || ';';
      	EXCEPTION
      	   WHEN NO_DATA_FOUND THEN
      	     -- On ne fait rien
      	     dbms_output.put_line('Pas de ligne avec ce type');
	   WHEN OTHERS THEN
	      raise_application_error( -20997,SQLERRM);   
	END;   
      END LOOP;
      

      OPEN p_cursor FOR
           SELECT arctype,
           	  libarc,
           	  actif,
           	  l_listeType1,
           	  flaglock
           FROM type_activite
           WHERE arctype = p_arctype;

      -- en cas absence, Code typologie secondaire  p_arctype inexistant

      pack_global.recuperer_message( 6013, '%s1', p_arctype, NULL, msg);  
      p_message := msg;

   END select_type_activite;

END pack_type_activite;
/
