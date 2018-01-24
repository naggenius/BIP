CREATE OR REPLACE PACKAGE pack_liste_type_doss_proj AS



TYPE lib_ListeViewType IS RECORD(    	TYPDP	type_dossier_projet.typdp%TYPE,

					LIBTYPDP type_dossier_projet.libtypdp%TYPE

                                         );



   TYPE lib_listeCurType IS REF CURSOR RETURN lib_ListeViewType;





   -- Liste des type de dossier projet

   PROCEDURE lister_type_doss_proj(	p_userid   IN 	  VARCHAR2,

             	       			p_curseur  IN OUT lib_listeCurType

            );



END pack_liste_type_doss_proj;

/



CREATE OR REPLACE PACKAGE BODY pack_liste_type_doss_proj AS



   PROCEDURE lister_type_doss_proj( p_userid   IN 	  VARCHAR2,

             	       			p_curseur  IN OUT lib_listeCurType

            ) IS



   BEGIN



      OPEN p_curseur FOR 

      SELECT

           typdp,

           libtypdp

      FROM type_dossier_projet

       ORDER BY typdp;



   EXCEPTION

       WHEN OTHERS THEN

          raise_application_error(-20997, SQLERRM); 



   END lister_type_doss_proj;



END pack_liste_type_doss_proj;

/