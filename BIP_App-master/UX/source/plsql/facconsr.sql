-- -------------------------------------------------------------------
-- pack_verif_facconsrh PL/SQL
--
-- equipe SOPRA (HT)
--
-- crée le 10/11/1999
--
-- Package qui sert à la réalisation des rapports 
--    (1) FACCONSR : Consultation des factures 
-- -------------------------------------------------------------------

-- MODIF
-- PPR le 04/07/2006 enleve table histo
-- OEL QC 1344
-- OEL QC 1344 Le 05/04/2012
-- SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE pack_verif_facconsrh AS

-- ----------------------------------------------

-- ------------------------------------------------------------------------
--
-- Nom        : verif_facconsr
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des paramètres saisis pour l'etat FACCONSR
-- Paramètres :
--              p_soccode (IN)		   Code société
--              p_numfact IN              Numéro facture
--              p_typfact IN              Type facture
--              p_datfact IN              date facture
--			 P_message OUT             Message de sortie
--
-- Remarque :  Cette procédure se contente d'appeler verif_facconsrh en lui passant en paramètre
--   		la table FACTURE et les paramètres ci-dessus.
--
-- ------------------------------------------------------------------------

     PROCEDURE verif_facconsr(
		 p_centrefrais IN VARCHAR2,
                 p_soccode IN  societe.soccode%TYPE, -- CHAR(4)
                 p_numfact IN  VARCHAR2,             -- CHAR(15)
                 p_typfact IN  VARCHAR2,             -- CHAR(1)
                 p_datfact IN  VARCHAR2,             -- DATE
                 p_num_expense IN facture.NUM_EXPENSE%type,
                 P_message OUT VARCHAR2
                 );

-- ------------------------------------------------------------------------
--
-- Nom        : verif_facconsr
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des paramètres saisis pour l'etat FACCONSH
-- Paramètres :
--              p_soccode (IN)		   Code société
--              p_numfact IN              Numéro facture
--              p_typfact IN              Type facture
--              p_datfact IN              date facture
--			 P_message OUT             Message de sortie
--
-- Remarque :  Cette procédure se contente d'appeler verif_facconsrh en lui passant en paramètre
--   		la table FACTURE et les paramètres ci-dessus.
--
-- ------------------------------------------------------------------------

      PROCEDURE verif_facconsh(
                 p_centrefrais IN VARCHAR2,
                 p_soccode IN  societe.soccode%TYPE, -- CHAR(4)
                 p_numfact IN  VARCHAR2,             -- CHAR(15)
                 p_typfact IN  VARCHAR2,             -- CHAR(1)
                 p_datfact IN  VARCHAR2,             -- DATE
                 p_num_expense IN facture.NUM_EXPENSE%type,
                 P_message OUT VARCHAR2
                 );

-- ------------------------------------------------------------------------
--
-- Nom        : verif_facconsrh
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des paramètres saisis pour l'etat FACCONSR ou FACCONSH
-- Paramètres :
--              p_tablefact IN            Nom de la table des factures
--              p_socfact (IN)		Code société
--              p_numfact IN              Numéro facture
--              p_typfact IN              Type facture
--              p_datfact IN              date facture
--		    P_message OUT          	Message d'erreur
--
-- Remarque :  p_tablefact doit valoir 'FACTURE'
--             Attention : ce contrôle n'est pas effectué!!!
-- ------------------------------------------------------------------------

      PROCEDURE verif_facconsrh(
                 p_tablefact IN VARCHAR2,            -- Nom de la table des factures
                 p_soccode IN  societe.soccode%TYPE, -- CHAR(4)
                 p_numfact IN  VARCHAR2,             -- CHAR(15)
                 p_typfact IN  VARCHAR2,             -- CHAR(1)
                 p_datfact IN  VARCHAR2,             -- DATE
                 p_num_expense IN facture.NUM_EXPENSE%type,
	 	 p_centrefrais IN VARCHAR2,
                 P_message OUT VARCHAR2
                 );

END pack_verif_facconsrh;
/


CREATE OR REPLACE PACKAGE BODY "PACK_VERIF_FACCONSRH" AS
-- ---------------------------------------------------

    PROCEDURE verif_facconsr(
	         p_centrefrais IN VARCHAR2,
                 p_soccode IN  societe.soccode%TYPE, -- CHAR(4)
                 p_numfact IN  VARCHAR2,             -- CHAR(15)
                 p_typfact IN  VARCHAR2,             -- CHAR(1)
                 p_datfact IN  VARCHAR2,             -- DATE
                 p_num_expense IN facture.NUM_EXPENSE%type,
                 P_message OUT VARCHAR2
                 ) IS

   BEGIN
      p_message := '';
     -- verif_facconsrh('FACTURE', p_soccode, p_numfact, p_typfact, p_datfact, p_message);
     verif_facconsrh('FACTURE', p_soccode, p_numfact, p_typfact, p_datfact, p_num_expense, p_centrefrais, p_message);

   END verif_facconsr;

   PROCEDURE verif_facconsh(   p_centrefrais IN VARCHAR2,
                 p_soccode IN  societe.soccode%TYPE, -- CHAR(4)
                 p_numfact IN  VARCHAR2,             -- CHAR(15)
                 p_typfact IN  VARCHAR2,             -- CHAR(1)
                 p_datfact IN  VARCHAR2,             -- DATE
                 p_num_expense IN facture.NUM_EXPENSE%type,
                 p_message OUT VARCHAR2
                 ) IS

   BEGIN
      p_message := '';
     -- verif_facconsrh('HISTO_FACTURE', p_soccode, p_numfact, p_typfact, p_datfact, p_message);
verif_facconsrh('HISTO_FACTURE', p_soccode, p_numfact, p_typfact, p_datfact, p_num_expense, p_centrefrais, p_message);

   END verif_facconsh;


   PROCEDURE verif_facconsrh(
                 p_tablefact IN VARCHAR2,
                 p_soccode IN  societe.soccode%TYPE, -- CHAR(4)
                 p_numfact IN  VARCHAR2,             -- CHAR(15)
                 p_typfact IN  VARCHAR2,             -- CHAR(1)
                 p_datfact IN  VARCHAR2,             -- DATE
                 p_num_expense IN facture.NUM_EXPENSE%type,
                 p_centrefrais IN VARCHAR2,
		         P_message OUT VARCHAR2
                 ) IS

      l_message   VARCHAR2(1024);
      l_num_exception NUMBER;
      l_centre_frais centre_frais.codcfrais%TYPE;
      l_fcentrefrais centre_frais.codcfrais%TYPE;
      l_count NUMBER;
      
   BEGIN
      l_message := '';

      IF (p_num_expense IS NULL) THEN
      
             IF ( pack_utile.f_verif_facture(p_tablefact, p_soccode, p_numfact, p_typfact, TO_DATE(p_datfact, 'DD/MM/YYYY')) = FALSE ) THEN

                  -- Facture inexistante : On recherche l'existence des champs ...

                  -----------------------------------------------------------------
                  -- (1) Vérification Code Société
                  -----------------------------------------------------------------
                  IF ( pack_utile.f_verif_soccode(p_soccode) = FALSE ) THEN
                      pack_global.recuperer_message(pack_utile_numsg.nuexc_soccode_inexistant, NULL,
                                                    NULL , ' P_param6 ', l_message);
                      l_num_exception := pack_utile_numsg.nuexc_soccode_inexistant;
                  END IF;

                  -----------------------------------------------------------------
                  -- (2) Vérification Numéro facture si société existe
                  -----------------------------------------------------------------
                  IF (l_message IS NULL) THEN
                      IF ( pack_utile.f_verif_numfact(p_tablefact, p_numfact) = FALSE ) THEN
                          pack_global.recuperer_message(pack_utile_numsg.nuexc_numfact_inexistant, '%s1',
                                                        p_numfact, ' P_param7 ', l_message);
                          l_num_exception := pack_utile_numsg.nuexc_numfact_inexistant;
                      END IF;
                  END IF;

                  -----------------------------------------------------------------
                  -- (3) Si Code société et N° Facture sont corrects,
                  --     La non existance de la facture ne peut provenir que
                  --     de la non existence de la date de facturation
                  --  ATTENTION : Le message "date de facture inexistante" sera aussi
                  --              affiché si c'est le type de facture qui n'est pas le bon
                  --              (Typfact = 'F' existe par exemple alors qu'on a choisi 'A')
                  -----------------------------------------------------------------

                  IF (l_message IS NULL) THEN
                      pack_global.recuperer_message(pack_utile_numsg.nuexc_datfact_inexistant, '%s1',
                                                    p_datfact , ' P_param9 ', l_message);
                      l_num_exception := pack_utile_numsg.nuexc_datfact_inexistant;
                  END IF;

             ELSE

                -- ======================================================================================
                -- 21/12/2000 :Contrôler que la facture appartient au centre de frais de l'utilisateur
                -- =======================================================================================
        	    l_centre_frais := to_number(p_centrefrais);

        	    -- Recherche du centre de frais de la facture

                BEGIN
            	  IF p_tablefact='FACTURE' then
            	    select fcentrefrais into l_fcentrefrais
            	    from facture
            	    where socfact= p_soccode
            	    and   rtrim(numfact)= p_numfact
            	    and   typfact= p_typfact
            	    and   datfact= to_date(p_datfact,'DD/MM/YYYY');

            	  END IF;
          
            	EXCEPTION
            		WHEN NO_DATA_FOUND then
            			-- la facture n'est rattachée à aucun centre de frais
            			pack_global.recuperer_message(20337,NULL,NULL,NULL, l_message);
                     	 	raise_application_error(-20337, l_message);
            		WHEN OTHERS then
            			 raise_application_error(-20997, SQLERRM);

            	END;

                IF l_centre_frais!=0 then    -- le centre de frais 0 donne tout les droits à l'utilisateur
                	IF l_fcentrefrais is null THEN
                		-- la facture n'est rattachée à aucun centre de frais
                		pack_global.recuperer_message(20337,NULL,NULL,NULL, l_message);
                        	 	raise_application_error(-20337, l_message);

                	ELSE
                		IF l_centre_frais!=l_fcentrefrais THEN
                			-- la facture n'est pas rattachée au centre de frais %s1 mais au centre de frais %s2
                			pack_global.recuperer_message(20338,'%s1',to_char(l_centre_frais),'%s2',
                								to_char(l_fcentrefrais),NULL, l_message);
                        			raise_application_error(-20338,l_message);

                		END IF;
                	END IF;
                END IF;
        
             END IF;
      
      ELSE
      
            BEGIN
  
              SELECT COUNT(*) INTO l_count
              FROM   FACTURE
              WHERE  num_expense = p_num_expense;

                IF(l_count = 1) THEN

                     -- ======================================================================================
                     -- 03/04/2012 :Contrôler que la facture appartient au centre de frais de l'utilisateur
                     -- ======================================================================================
                  l_centre_frais := to_number(p_centrefrais);

                  -- Recherche du centre de frais de la facture

                     BEGIN
                 	  IF p_tablefact='FACTURE' then
                 	    select fcentrefrais into l_fcentrefrais
                 	    from facture
                 	    where num_expense = p_num_expense;

                 	  END IF;
          
                 	EXCEPTION
                 		WHEN NO_DATA_FOUND then
                 			-- la facture n'est rattachée à aucun centre de frais
                 			pack_global.recuperer_message(20337,NULL,NULL,NULL, l_message);
                          	 	raise_application_error(-20337, l_message);
                 		WHEN OTHERS then
                 			 raise_application_error(-20997, SQLERRM);

                 	END;

                     IF l_centre_frais!=0 then    -- le centre de frais 0 donne tout les droits à l'utilisateur
                     	IF l_fcentrefrais is null THEN
                     		-- la facture n'est rattachée à aucun centre de frais
                     		pack_global.recuperer_message(20337,NULL,NULL,NULL, l_message);
                             	 	raise_application_error(-20337, l_message);

                     	ELSE
                     		IF l_centre_frais!=l_fcentrefrais THEN
                     			-- la facture n'est pas rattachée au centre de frais %s1 mais au centre de frais %s2
                     			pack_global.recuperer_message(20338,'%s1',to_char(l_centre_frais),'%s2',
                     								to_char(l_fcentrefrais),NULL, l_message);
                             			raise_application_error(-20338,l_message);

                     		END IF;
                     	END IF;
                     END IF;
              
                ELSE              
                    -- Numero Expense n'existe pas
                    IF(l_count = 0) THEN    
                        pack_global.recuperer_message(4650,'%s1', p_num_expense, NULL, NULL, 'P_param10', p_message);
                        raise_application_error( -20226, p_message);                                                    
                    END IF ;              
              
                END IF;
              
            EXCEPTION
                WHEN OTHERS THEN  
                  RAISE_APPLICATION_ERROR(-20997, SQLERRM);
                  l_count := 0; 
            END;
      
      END IF;
      
      p_message := l_message;

    /*************************************************************************************************
      dbms_output.put_line('NUM ERR : '||l_num_exception);
      dbms_output.put_line('NUM ERR datfact: '||pack_utile_numsg.nuexc_datfact_inexistant);
      dbms_output.put_line('NUM ERR numfact: '||pack_utile_numsg.nuexc_numfact_inexistant);
      dbms_output.put_line('NUM ERR soccode: '||pack_utile_numsg.nuexc_soccode_inexistant);
    *************************************************************************************************/
      IF (l_message IS NOT NULL) THEN
          RAISE_APPLICATION_ERROR(-l_num_exception, l_message);
      END IF;

   END verif_facconsrh;



END pack_verif_facconsrh;
/


