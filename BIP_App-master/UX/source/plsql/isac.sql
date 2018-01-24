-- APPLICATION ISAC
-- -------------------------------------
-- pack_isac PL/SQL
-- 
-- Créé le 27/03/2002 par NBM
--
--
--
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...


CREATE OR REPLACE PACKAGE pack_isac AS

  
   PROCEDURE recuperer_message( 	p_id_msg        IN NUMBER,
                                	p_tag           IN VARCHAR2,
                                	p_replace_value IN VARCHAR2,
			       	p_focus         IN VARCHAR2,
	                        	p_msg           OUT VARCHAR2);

   PROCEDURE recuperer_message( 	p_id_msg         IN NUMBER,
                                	p_tag1           IN VARCHAR2,
                                	p_replace_value1 IN VARCHAR2,
                                	p_tag2           IN VARCHAR2,
                                	p_replace_value2 IN VARCHAR2,
			       	p_focus          IN VARCHAR2,
	                      	p_msg            OUT VARCHAR2);
                                
   PROCEDURE recuperer_message( 	p_id_msg         IN NUMBER,
                                	p_tag1           IN VARCHAR2,
                                	p_replace_value1 IN VARCHAR2,
                                	p_tag2           IN VARCHAR2,
                                	p_replace_value2 IN VARCHAR2,
                                	p_tag3           IN VARCHAR2,
                                	p_replace_value3 IN VARCHAR2,
				p_focus          IN VARCHAR2,
	                        	p_msg            OUT VARCHAR2);

--FAD PPM 63773 : Suppression de la structure d'une ligne BIP
	PROCEDURE DELETE_STRUCTURE (p_pid IN VARCHAR2);
--FAD PPM 63773 : Fin
END pack_isac;
/

CREATE OR REPLACE PACKAGE BODY pack_isac AS 

 
   PROCEDURE recuperer_message( 	p_id_msg        IN NUMBER,
                                	p_tag           IN VARCHAR2,
                                	p_replace_value IN VARCHAR2,
 			       	p_focus         IN VARCHAR2,
	                       	p_msg           OUT VARCHAR2
                              ) IS
      l_msgerr VARCHAR2(1024);
   BEGIN

   p_msg := NULL;
   l_msgerr := NULL;

   -- Récupération et enrichissement du message 

      SELECT REPLACE( limsg, p_tag, p_replace_value) ||
             DECODE( p_focus, NULL, 
                     NULL, 'FOCUS=' || p_focus)
      INTO   p_msg 
      FROM   isac_message
      WHERE  id_msg = p_id_msg;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_msgerr := 'Code message '    || 
                     TO_CHAR( p_id_msg) ||
                     ' inexistant' ;

         raise_application_error( -20998, l_msgerr);

      WHEN OTHERS THEN
         raise_application_error( -20998, SQLERRM);
         
   END recuperer_message;


   PROCEDURE recuperer_message( 	p_id_msg         IN NUMBER,
                                	p_tag1           IN VARCHAR2,
                                	p_replace_value1 IN VARCHAR2,
                                	p_tag2           IN VARCHAR2,
                                	p_replace_value2 IN VARCHAR2,
			  	p_focus          IN VARCHAR2,
	                       	p_msg            OUT VARCHAR2
                              ) IS
      l_msgerr VARCHAR2(1024);
   BEGIN

   p_msg := NULL;
   l_msgerr := NULL;

   -- Récupération et enrichissement du message 

      SELECT REPLACE( REPLACE( limsg, p_tag1, p_replace_value1), 
                      p_tag2, p_replace_value2) ||
             DECODE( p_focus, NULL, 
                     NULL, 'FOCUS=' || p_focus)
      INTO   p_msg 
      FROM   isac_message
      WHERE  id_msg = p_id_msg;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_msgerr := 'Code message '    || 
                     TO_CHAR( p_id_msg) ||
                     ' inexistant' ;

         raise_application_error( -20998, l_msgerr);

      WHEN OTHERS THEN
         raise_application_error( -20998, SQLERRM);
         
   END recuperer_message;

   PROCEDURE recuperer_message( 	p_id_msg         IN NUMBER,
                                	p_tag1           IN VARCHAR2,
                                	p_replace_value1 IN VARCHAR2,
                                	p_tag2           IN VARCHAR2,
                                	p_replace_value2 IN VARCHAR2,
                                	p_tag3           IN VARCHAR2,
                                	p_replace_value3 IN VARCHAR2,
				p_focus          IN VARCHAR2,
	                     	p_msg            OUT VARCHAR2
                              ) IS
      l_msgerr VARCHAR2(1024);
   BEGIN

   p_msg := NULL;
   l_msgerr := NULL;

   -- Récupération et enrichissement du message 

      SELECT REPLACE( REPLACE( REPLACE( limsg, 
                                        p_tag1, 
                                        p_replace_value1), 
                               p_tag2, 
                               p_replace_value2), 
                       p_tag3,
                       p_replace_value3) ||
             DECODE( p_focus, NULL, 
                     NULL, 'FOCUS=' || p_focus)
      INTO   p_msg 
      FROM   isac_message
      WHERE  id_msg = p_id_msg;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         l_msgerr := 'Code message '    || 
                     TO_CHAR( p_id_msg) ||
                     ' inexistant' ;

         raise_application_error( -20998, l_msgerr);

      WHEN OTHERS THEN
         raise_application_error( -20998, SQLERRM);
         
   END recuperer_message;

--FAD PPM 63773 : Suppression de la structure d'une ligne BIP
PROCEDURE DELETE_STRUCTURE ( p_pid IN VARCHAR2)
IS
BEGIN
  DELETE FROM ISAC_CONSOMME WHERE PID = p_pid;
  DELETE FROM ISAC_AFFECTATION WHERE PID = p_pid;
  DELETE FROM ISAC_SOUS_TACHE WHERE PID = p_pid;
  DELETE FROM ISAC_TACHE WHERE PID = p_pid;
  DELETE FROM ISAC_ETAPE WHERE PID = p_pid;
  COMMIT;
EXCEPTION WHEN OTHERS THEN
  raise_application_error( -20998, SQLERRM);
END DELETE_STRUCTURE;
--FAD PPM 63773 : Fin
END pack_isac;
/


