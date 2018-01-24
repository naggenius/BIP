-- -------------------------------------------------------------------
-- pack_verif_consit PL/SQL
--
-- equipe SOPRA (HT)
--
-- crée le 21/03/2000
-- Mofifié le 08/12/2005 par BAA : fiche 327 ajout le controle de perimetre me
-- Modifié le 25/01/2006 par PPR : correction controle perimetre ME
--
-- Package qui sert à la réalisation de l'état CONSIT
--                   
-- -------------------------------------------------------------------

-- SET SERVEROUTPUT ON SIZE 1000000;



CREATE OR REPLACE PACKAGE Pack_Verif_Consit  AS

   PROCEDURE verif_consit(
			p_coderessource IN VARCHAR2,
			p_userid 	IN VARCHAR2
			);
END Pack_Verif_Consit;
/




CREATE OR REPLACE PACKAGE BODY Pack_Verif_Consit  AS
-- ---------------------------------------------------

PROCEDURE verif_consit(
			p_coderessource IN VARCHAR2,
			p_userid 	IN VARCHAR2
                       )

IS
     code_ress	VARCHAR2(30);
     l_msg	VARCHAR2(100);
     l_codsg    VARCHAR2(7);
     l_habilitation VARCHAR2(10);
	 l_menu          VARCHAR2(255);
	 l_perim_me          VARCHAR2(1024);
   BEGIN
   
   l_menu := Pack_Global.lire_globaldata(p_userid).menutil;
   l_perim_me := Pack_Global.lire_globaldata(p_userid).perime;
   
	-- Recherche d'un code ressource correspondant au critère p_coderessource
	BEGIN
		SELECT ident INTO code_ress
		FROM RESSOURCE
		WHERE ident = p_coderessource
		AND ROWNUM =1;

		SELECT TO_CHAR(codsg, 'FM0000000') INTO l_codsg
		FROM SITU_RESS
		WHERE ident=p_coderessource
		AND datsitu IN (SELECT MAX(datsitu)
				FROM SITU_RESS
				WHERE ident=p_coderessource);

		 IF l_menu != 'DIR' and (l_perim_me is not null and l_perim_me != '') THEN		
              -- ====================================================================
              -- 08/12/2005 : BAA Test appartenance du DPG au périmètre de l'utilisateur
              -- ====================================================================
              l_habilitation := Pack_Habilitation.fhabili_me( l_codsg,p_userid);
	          IF l_habilitation='faux' THEN
		           --ous n'êtes pas autorisé à visualiser cette ressource, son DPG est
		          	Pack_Global.recuperer_message(20365, '%s1',  'visualiser cette ressource, son DPG est '||l_codsg, 'IDENT', l_msg);
                    RAISE_APPLICATION_ERROR(-20365, l_msg);
				   	 END IF;
        END IF;
				
				
 	EXCEPTION
 		WHEN NO_DATA_FOUND THEN -- Msg Code  ressource inconnue
                          Pack_Global.recuperer_message(20017, NULL, NULL, NULL, l_msg);
                          RAISE_APPLICATION_ERROR(-20017,l_msg);

		WHEN OTHERS THEN
	                 RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;

   END verif_consit;

END Pack_Verif_Consit;
/


