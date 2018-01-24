CREATE OR REPLACE PACKAGE pack_ree_synthese_locale AS



  

  FUNCTION RAF_RESSOURCE (	acodsg          IN  NUMBER,

                           	acode_activite  IN  VARCHAR2,

                          	acode_scenario  IN  VARCHAR2,

				amoismens IN DATE

                       		) return NUMBER;

  FUNCTION min_dpg (p_codsg IN VARCHAR2) RETURN NUMBER;



  FUNCTION max_dpg (p_codsg IN VARCHAR2) RETURN NUMBER;



  FUNCTION code_scenario (code_sc IN VARCHAR2) RETURN VARCHAR2;



  FUNCTION officiel (code_sc IN VARCHAR2) RETURN VARCHAR2;





END pack_ree_synthese_locale;

/















CREATE OR REPLACE PACKAGE BODY pack_ree_synthese_locale AS











   FUNCTION RAF_RESSOURCE (	acodsg          IN  NUMBER,

                           	acode_activite  IN  VARCHAR2,

                          	acode_scenario  IN  VARCHAR2,

				amoismens IN DATE

                       		) return NUMBER IS



   CURSOR ct is select SUM(CONSO_PREVU) from REE_REESTIME where codsg=acodsg and code_activite=acode_activite and code_scenario=acode_scenario and CDEB>amoismens;

   CONSO_PREVU NUMBER;



   BEGIN



   open ct;



   Fetch ct into CONSO_PREVU;



   close ct;  





   return CONSO_PREVU;   



   END RAF_RESSOURCE;













   FUNCTION min_dpg (p_codsg IN VARCHAR2) RETURN NUMBER IS

     





   BEGIN

     

      

	IF substr(p_codsg,6,2)='**' THEN

		IF substr(p_codsg,4,4)='****' THEN



			IF substr(p_codsg,2,6)='******' THEN



				IF p_codsg='*******' THEN



					return '0000000';

				ELSE



					return substr(p_codsg,1,1)||'000000';

				END IF;   			

			ELSE



				return substr(p_codsg,1,3)||'0000';

			END IF;   

		ELSE



			return substr(p_codsg,1,5)||'00';

		END IF;                        	

              

	ELSE

	

		return p_codsg;

			

	END IF;





   END min_dpg;     





   FUNCTION max_dpg (p_codsg IN VARCHAR2) RETURN NUMBER IS

     





   BEGIN

      

	IF substr(p_codsg,6,2)='**' THEN

		IF substr(p_codsg,4,4)='****' THEN

			

			IF substr(p_codsg,2,6)='******' THEN



				IF p_codsg='*******' THEN

					return '9999999';



				ELSE



					return substr(p_codsg,1,1)||'999999';

				END IF;   			

			ELSE



				return substr(p_codsg,1,3)||'9999';

			END IF;

   

		ELSE

			return substr(p_codsg,1,5)||'99';

		END IF;                        	

              

	ELSE

	

		return p_codsg;

			

	END IF;







   END max_dpg;     









   FUNCTION code_scenario (code_sc IN VARCHAR2) RETURN VARCHAR2 IS

     

   BEGIN

     

      

	IF code_sc='***' THEN

	

		return '%%' ;                        	

              

	ELSE

	

		return code_sc;

			

	END IF;





   END code_scenario;     





   FUNCTION officiel (code_sc IN VARCHAR2) RETURN VARCHAR2 IS

     

   BEGIN

     

      

	IF code_sc='***' THEN

	

		return 'O' ;                        	

              

	ELSE

	

		return '%%';

			

	END IF;





   END officiel; 









END pack_ree_synthese_locale;

/   

  



show error