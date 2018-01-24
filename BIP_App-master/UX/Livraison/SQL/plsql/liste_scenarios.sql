
CREATE OR REPLACE PACKAGE pack_liste_scenarios AS




   TYPE scenarios_ListeViewType IS RECORD(  CODE_ACTIVITE   VARCHAR2(12),

  								   			LIB_ACTIVITE     VARCHAR2(75)

					  					  );



   TYPE scenarios_listeCurType IS REF CURSOR RETURN scenarios_ListeViewType;



   

   PROCEDURE lister_scenarios_dpg( 	p_codsg 	IN VARCHAR2,

   			 						p_userid 	IN VARCHAR2,

   			 						p_curseur 	IN OUT scenarios_listeCurType

                             	  );
-- FAD PPM 65042 : Création de la procédure lister_scenarios_dpg_gen pour lister scenarios des DPG génériques avec contrôle d'habilitation
PROCEDURE lister_scenarios_dpg_gen( 	p_codsg 	IN VARCHAR2,

   			 						p_userid 	IN VARCHAR2,

   			 						p_curseur 	IN OUT scenarios_listeCurType

                             	  );



END pack_liste_scenarios;

/













CREATE OR REPLACE PACKAGE BODY pack_liste_scenarios AS

   PROCEDURE lister_scenarios_dpg( 	p_codsg IN VARCHAR2,


   			 						p_userid 	IN VARCHAR2,

   									p_curseur IN OUT scenarios_listeCurType

                                 ) IS



	l_msg VARCHAR2(1024);

	l_codsg NUMBER;



   BEGIN



      -- Positionner le nb de curseurs ==> 1

      -- Initialiser le message retour



	If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu

		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);

               raise_application_error(-20203,l_msg);



     ELSE

     IF ( pack_habilitation.fhabili_me(p_codsg, p_userid)= 'faux' )

     THEN

	pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);

	raise_application_error(-20364,l_msg);



     ELSE



	BEGIN

        	OPEN   p_curseur FOR

              	SELECT CODE_SCENARIO CODE_SCENARIO,CODE_SCENARIO||' - '||LIB_SCENARIO LIB_SCENARIO

				FROM REE_SCENARIOS

				WHERE CODSG=TO_NUMBER(p_codsg)


				ORDER BY OFFICIEL desc;



				



      		EXCEPTION

			WHEN OTHERS THEN

         		raise_application_error( -20997, SQLERRM);

       END;

        END IF;

     END IF;






  END lister_scenarios_dpg;

-- FAD PPM 65042 : Création de la procédure lister_scenarios_dpg_gen pour lister scenarios des DPG génériques avec contrôle d'habilitation
PROCEDURE lister_scenarios_dpg_gen( 	p_codsg IN VARCHAR2,

   			 						p_userid 	IN VARCHAR2,

   									p_curseur IN OUT scenarios_listeCurType

                                 ) IS



	l_msg VARCHAR2(1024);

	l_codsg NUMBER;

  l_perim_me varchar(4000);

   BEGIN

  L_PERIM_ME := PACK_GLOBAL.LIRE_PERIME(p_userid);


      -- Positionner le nb de curseurs ==> 1

      -- Initialiser le message retour




	BEGIN
  
        	OPEN   p_curseur FOR

              	SELECT DISTINCT CODE_SCENARIO CODE_SCENARIO,CODE_SCENARIO||' - '||LIB_SCENARIO LIB_SCENARIO

				FROM REE_SCENARIOS

				WHERE CODSG >= TO_NUMBER(REPLACE(P_CODSG, '*', '0'))
        AND CODSG <= TO_NUMBER(REPLACE(P_CODSG, '*', '9'))
        AND codsg IN (SELECT codsg FROM vue_dpg_perime where INSTR(L_PERIM_ME, codbddpg) > 0 )


        
				--ORDER BY OFFICIEL desc
				;




				



      		EXCEPTION

			WHEN OTHERS THEN

         		raise_application_error( -20997, SQLERRM);

       END;


  END lister_scenarios_dpg_gen;
END pack_liste_scenarios;
/




show error








