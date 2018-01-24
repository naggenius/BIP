-- pack_stat_page PL/SQL
--
-- JMA
-- Créé le 25/01/2006
-- 
--****************************************************************************
--
--
CREATE OR REPLACE PACKAGE BIP.pack_stat_page AS

   -- Définition curseur sur la table stat_page

   TYPE statpage_ViewType IS RECORD ( 	id_page  		stat_page.id_page%TYPE,
						  	 			lib_page  		stat_page.lib_page%TYPE,
										trace  			stat_page.trace%TYPE,
										trace_action  	stat_page.trace_action%TYPE
										);


   TYPE statpageCurType_Char IS REF CURSOR RETURN statpage_ViewType;


   PROCEDURE select_liste ( p_curstat 	IN OUT statpageCurType_Char ,
                            p_nbcurseur    OUT INTEGER,
                            p_message      OUT VARCHAR2
                          );


END pack_stat_page;
/


CREATE OR REPLACE PACKAGE BODY BIP.pack_stat_page AS


    PROCEDURE select_liste ( p_curstat 	IN OUT statpageCurType_Char ,
                            p_nbcurseur    OUT INTEGER,
                            p_message      OUT VARCHAR2
                          ) IS

		l_msg VARCHAR2(1024);
		l_codsg NUMBER;

    BEGIN

        -- Positionner le nb de curseurs ==> 1
        -- Initialiser le message retour
		p_nbcurseur := 1;
      	p_message := '';

       	OPEN   p_curstat FOR
           	SELECT id_page,
              	   lib_page,
              	   trace,
				   trace_action
              FROM stat_page
			ORDER BY id_page;

   	EXCEPTION
		WHEN OTHERS THEN
       		raise_application_error( -20997, SQLERRM);

	END select_liste;


END pack_stat_page;
/


