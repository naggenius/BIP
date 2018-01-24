-- PACK_FILE PL/SQL
--
-- K. Hazard
-- Créé le 06/10/2004
-- 
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE PACK_FILE AS

   -- Définition curseur sur la table actualite
	
   TYPE file_ViewType IS RECORD ( 
					fichier actualite.fichier%TYPE,
					nom_fichier actualite.nom_fichier%TYPE,
					mime_fichier actualite.mime_fichier%TYPE,
					size_fichier actualite.size_fichier%TYPE
					
					 	); 
 

   TYPE fileCurType_Char IS REF CURSOR RETURN file_ViewType;
 

 
   PROCEDURE DOWNLOAD_FILE ( p_code_actu	   IN VARCHAR2,
                                  p_userid         IN VARCHAR2,
                                  p_curfile IN OUT fileCurType_Char,
                                  p_nbcurseur         OUT INTEGER,
                                  p_message           OUT VARCHAR2
                                );


END PACK_FILE;
/

CREATE OR REPLACE PACKAGE BODY PACK_FILE AS 

 



   PROCEDURE DOWNLOAD_FILE ( p_code_actu	   IN VARCHAR2,
                                  p_userid         IN VARCHAR2,
                                  p_curfile IN OUT fileCurType_Char,
                                  p_nbcurseur         OUT INTEGER,
                                  p_message           OUT VARCHAR2
                                ) IS

	l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
	
      p_nbcurseur := 1;

      p_message := '';
 
 

-- dbms_output.put_line('p_code_actu = ' || p_code_actu || ' --- p_userid = ' || p_userid );

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN   p_curfile FOR
              SELECT 	
		fichier,
		nom_fichier,
		mime_fichier,
		size_fichier
                     	
              FROM  actualite
              WHERE code_actu = TO_NUMBER(p_code_actu);

         -- en cas absence
	   -- 'Code Département/Pôle/Groupe p_code_actu inexistant'

         pack_global.recuperer_message( 20203, '%s1', p_code_actu, NULL, l_msg);
         p_message := l_msg;

      EXCEPTION

        WHEN OTHERS THEN
          raise_application_error( -20997, SQLERRM);

      END;
 
   END DOWNLOAD_FILE;
END PACK_FILE;
/

