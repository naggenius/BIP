-- pack_bjh_type_absence PL/SQL
--
-- Maintenance BIP
-- Créé le 02/11/2000
-- 
--
--
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_bjh_type_absence AS

	
   TYPE Bjh_type_absence_ViewType IS RECORD ( bipabs bjh_type_absence.bipabs%TYPE,
					      gipabs bjh_type_absence.bipabs%TYPE);

   TYPE bjh_type_absenceCurType_Char IS REF CURSOR RETURN Bjh_type_absence_ViewType;

   PROCEDURE insert_bjh_type_absence ( p_gipabs     IN VARCHAR2,
				       p_bipabs     IN bjh_type_absence.bipabs%TYPE,
                                       p_userid     IN VARCHAR2,
                           	       p_nbcurseur  OUT INTEGER,
                           	       p_message    OUT VARCHAR2);

   PROCEDURE update_bjh_type_absence (  p_gipabs    IN VARCHAR2,
				        p_bipabs    IN bjh_type_absence.bipabs%TYPE,
					p_userid    IN VARCHAR2,
					p_nbcurseur OUT INTEGER,
                	                p_message   OUT VARCHAR2);

   PROCEDURE delete_bjh_type_absence ( 	p_gipabs    IN VARCHAR2,
					p_bipabs    IN bjh_type_absence.bipabs%TYPE,
					p_userid    IN VARCHAR2,
        	                        p_nbcurseur OUT INTEGER,
                	                p_message   OUT VARCHAR2);

   PROCEDURE select_bjh_type_absence (   p_gipabs      IN VARCHAR2,
        	                         p_curBjh_typa IN OUT bjh_type_absenceCurType_Char,
                	                 p_nbcurseur         OUT INTEGER,
                        	         p_message           OUT VARCHAR2);
END pack_bjh_type_absence;
/

CREATE OR REPLACE PACKAGE BODY pack_bjh_type_absence AS 

   PROCEDURE insert_bjh_type_absence ( p_gipabs    IN VARCHAR2,
	  			       p_bipabs    IN bjh_type_absence.bipabs%TYPE,
                                       p_userid	   IN VARCHAR2,
                                       p_nbcurseur OUT INTEGER,
                                       p_message   OUT VARCHAR2
                              ) IS 
 
     l_msg VARCHAR2(1024);
     l_gipabs bjh_type_absence.gipabs%TYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
   
	
	BEGIN
     	   INSERT INTO bjh_type_absence
	    ( bipabs,
 		gipabs)
         VALUES (p_bipabs,
		 p_gipabs 
		); 
	   -- 'type d'absence p_gipabs cree'


     EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
		   pack_global.recuperer_message( 20001, NULL, NULL, NULL, l_msg);
               raise_application_error( -20001, l_msg );

            WHEN OTHERS THEN
               raise_application_error( -20997, SQLERRM);
     END;

   END insert_bjh_type_absence;


   PROCEDURE update_bjh_type_absence(    p_gipabs     IN VARCHAR2,
					 p_bipabs     IN bjh_type_absence.bipabs%TYPE,
					 p_userid     IN VARCHAR2,
	                                 p_nbcurseur  OUT INTEGER,
                	                 p_message    OUT VARCHAR2
	                             ) IS 

	l_msg VARCHAR2(1024);
	l_gipabs bjh_type_absence.gipabs%TYPE;

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- initialiser le message retour
	p_nbcurseur := 0;
	p_message := '';
      -- test si le type d'absence existe deja

      BEGIN
        SELECT gipabs INTO l_gipabs
        FROM bjh_type_absence
        WHERE p_gipabs= gipabs;  
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
 	    pack_global.recuperer_message( 20754, NULL, NULL, NULL, l_msg);
          raise_application_error( -20754, l_msg );

        WHEN OTHERS THEN
          raise_application_error( -20997, SQLERRM);
        
      END;

	BEGIN
         UPDATE bjh_type_absence
		SET	bipabs  =   p_bipabs
		WHERE gipabs 	=   p_gipabs;

	   EXCEPTION

		WHEN OTHERS THEN
	        raise_application_error( -20754, l_msg );

--	   raise_application_error( -20997, SQLERRM);
	END;


      IF SQL%NOTFOUND THEN
	   
	   -- 'Accès concurrent'

	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
         
      END IF;

   END update_bjh_type_absence;

   PROCEDURE delete_bjh_type_absence (p_gipabs    IN VARCHAR2,
				      p_bipabs    IN bjh_type_absence.bipabs%TYPE,
				      p_userid    IN VARCHAR2,
        	                      p_nbcurseur OUT INTEGER,
                	              p_message   OUT VARCHAR2
                              ) IS


      l_msg VARCHAR2(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
	   DELETE FROM bjh_type_absence
		    WHERE gipabs = p_gipabs;

         EXCEPTION

		WHEN referential_integrity THEN

               -- habiller le msg erreur
               pack_global.recuperation_integrite(-2292);
	   
		WHEN OTHERS THEN
		   raise_application_error( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
	   
	   -- 'Accès concurrent'

	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
           raise_application_error( -20999, l_msg );
         
      END IF;

   END delete_bjh_type_absence;


   PROCEDURE select_bjh_type_absence(     p_gipabs      IN VARCHAR2,
	                                  p_curbjh_typa IN OUT bjh_type_absenceCurType_Char,
                	                  p_nbcurseur      OUT INTEGER,
                        	          p_message        OUT VARCHAR2
                              		) IS

	l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

-- dbms_output.put_line('p_codsg = ' || p_codsg || ' --- p_userid = ' || p_userid );

 
      BEGIN
         OPEN   p_curbjh_typa FOR
              SELECT bipabs,
                     gipabs
              FROM  bjh_type_absence
              WHERE gipabs = p_gipabs;

         -- en cas absence
	   -- 'type d'absence inexistante'

         pack_global.recuperer_message( 20331, '%s1', p_gipabs, NULL, l_msg);
         p_message := l_msg;

      EXCEPTION

        WHEN OTHERS THEN
          raise_application_error( -20997, SQLERRM);

      END;

   END select_bjh_type_absence;

END pack_bjh_type_absence;
/

-- exec pack_bjh_type_absence.select_bjh_type_absence('D01','ABSDIV',:pcur,:nbcur,:mess);
-- create table bjh_type_absence
-- (bipabs VARCHAR2(6),
-- gipabs VARCHAR2(3));