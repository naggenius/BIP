-- ============================================================================
-- pack_RestPro3 PL/SQL
-- ============================================================================
-- Equipe SOPRA
-- Créé le 16/03/1999
-- 
-- ============================================================================

-- ============================================================================
CREATE OR REPLACE PACKAGE pack_RestPro3 AS
-- ----------------------------------------------------------------------------
-- PROCEDURE qui verifie les parametres de l'édition RestPro3.
   PROCEDURE Verif_ParamRestPro3 ( 
                       p_pid      IN ligne_bip.pid%TYPE,  -- varchar2(4)
                       p_global   IN VARCHAR2,
                       p_msg      OUT VARCHAR2

                       ) ;
END pack_RestPro3;

/

CREATE OR REPLACE PACKAGE BODY pack_RestPro3 AS 

-- ============================================================================
-- ----------------------------------------------------------------------------
-- PROCEDURE Verif_ParamRestPro3
-- Role : Verifie l'existence et l'exactitude du paramettre d'entree de 
--        l'édition RestPro3.
-- ----------------------------------------------------------------------------

   PROCEDURE Verif_ParamRestPro3 ( 
                       p_pid      IN ligne_bip.pid%TYPE,  -- varchar2(4)
                       p_global   IN VARCHAR2,
                       p_msg  OUT VARCHAR2
                       ) IS

   l_msg  VARCHAR2(1024);
   l_UserDepPole VARCHAR2(5);
   l_codsg ligne_bip.codsg%TYPE;    
   l_annee NUMBER(4);  
   l_habilitation varchar2(10);

  BEGIN

      p_msg := '';
 
      -- Rechercher le code departement pole de l'utilisateur.
      l_UserDepPole := substr(LPAD(pack_global.lire_globaldata(p_global).codpole,7,'0'), 1, 5);

     -- Rechercher le code departement pole du projet
     BEGIN

         SELECT lb.codsg INTO l_codsg
         FROM   ligne_bip lb 
         WHERE  lb.pid = p_pid
           AND  ROWNUM  < 2;   

     EXCEPTION
         WHEN NO_DATA_FOUND THEN
              -- Code ligne BIP inexistant
              pack_global.recuperer_message(20504, '%s1', p_pid, NULL, l_msg);
              raise_application_error(-20504, l_msg);

     END;

     -- Verifier l'habilitation de l'utilisateur sur le projet 
     
      	-- ====================================================================
      	-- 20/02/2001 : Test appartenance du DPG au périmètre de l'utilisateur
      	-- ====================================================================
     	l_habilitation := pack_habilitation.fhabili_me( l_codsg,p_global);
	IF l_habilitation='faux' THEN
		-- Vous n'êtes pas habilité à ce projet
		pack_global.recuperer_message(20364,'%s1',  'à ce projet, son DPG est '||l_codsg, 'P_param6', l_msg);
	  	raise_application_error( -20364, l_msg );
	END IF;



     EXCEPTION
        WHEN OTHERS THEN raise_application_error(-20997,SQLERRM);

  END Verif_ParamRestPro3;

END pack_RestPro3;
/


-- var msg VARCHAR2(100);
-- select * from userbip where CODPOLE != '0000'

-- exemple qui marche 
-- exec pack_RestPro3.Verif_ParamRestPro3('IT5C521;dirmenu;700 ;000000;01;Q04_08046_HP3SI', 'EAN', 'S935709;;;;01;', :msg);

-- controle d'existance d'un Pid ?
-- exec pack_RestPro3.Verif_ParamRestPro3('IT5C521;dirmenu;700 ;000000;01;Q04_08046_HP3SI', 'ttt', 'S935709;;;;01;', :msg);

-- controle user deppole ?= deppole du projet 
-- projet 'A24' dont le codsg=161612. 
-- exec pack_RestPro3.Verif_ParamRestPro3('IT5C521;dirmenu;700 ;1615;01;Q04_08046_HP3SI', 'A24', 'S935709;;;;01;', :msg);
-- exec pack_RestPro3.Verif_ParamRestPro3('IT5C521;dirmenu;700 ;1600;01;Q04_08046_HP3SI', 'A24', 'S935709;;;;01;', :msg);

