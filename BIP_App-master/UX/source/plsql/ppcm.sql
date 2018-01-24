--
-- 09/01/2003

CREATE OR replace PACKAGE pack_ppcm AS
  -- ------------------------------------------------------------------------
  -- Decription :  vérifie l'existence du code dpg 
  -- Paramètres :  p_param6 (IN) situ_ress.codsg%type: code dpg               
-- param10 classement du report
  -- param 
  --               p_message (out) varchar2
  -- Retour     :  renvoie rien si ok, erreur sinon
  -- 
  -- ------------------------------------------------------------------------ 

 
PROCEDURE  verif_ppcm(       p_codcfrais IN varchar2,
				p_param8 IN varchar2,
				p_param6 IN varchar2,
                                p_param10 IN varchar2,
				p_global  IN VARCHAR2,	
			 	p_message OUT VARCHAR2);

END pack_ppcm;
/

CREATE OR replace PACKAGE BODY pack_ppcm AS 
  
  -- ------------------------------------------------------------------------
  -- 
  -- ------------------------------------------------------------------------  


PROCEDURE  verif_ppcm(      p_codcfrais IN varchar2,   	-- centre de frais
				p_param8 IN varchar2,   	-- menu courant	
				p_param6 IN varchar2,		-- code dPG
                                 p_param10 IN varchar2,
				p_global  IN VARCHAR2,
			 	p_message OUT VARCHAR2) IS
  l_msg VARCHAR2(1024) :=''; 
  l_codsg2 struct_info.codsg%type;
  l_centre_frais centre_frais.codcfrais%TYPE;
  l_scentrefrais centre_frais.codcfrais%TYPE;
  

BEGIN
   BEGIN
      -- P_codsg peut avoir une valeur = '01313**' ou '0131312' ou '01312  ' (avec des blancs)
      -- S'il possed un metacaractere (' ', '*'), on va le supprimer
      -- Puis former la condition Where du Select en fonction du longueur de P_codsg
 	if p_param6!='*******' then
      		SELECT   codsg, scentrefrais   INTO  l_codsg2, l_scentrefrais
      		FROM   struct_info
	   	WHERE  substr(to_char(codsg,'FM0000000'),1, length(rtrim(rtrim(LPAD(p_param6,7,'0'),'*')))) = rtrim(rtrim(LPAD(p_param6,7,'0'),'*'))
	     	 AND ROWNUM <= 1;
  	end if;

   EXCEPTION
	WHEN NO_DATA_FOUND then
		pack_global.recuperer_message(20215, '%s1', p_param6, 'p_param6', l_msg);
     	 	raise_application_error(-20215, l_msg);
   	p_message := l_msg;
   END;

  IF p_param8='ACH' THEN
     -- ===================================================================
     -- 28/12/2000 : Test si le DPG appartient bien au centre de frais
     -- ===================================================================
     -- On récupère le code centre de frais de l'utilisateur
	l_centre_frais := to_number(p_codcfrais);
   	IF p_param6!='*******' then
     		IF l_centre_frais!=0 then    -- le centre de frais 0 donne tout les droits à l'utilisateur
      			IF (l_scentrefrais is null)   then 
			--msg : Le DPG n'est rattaché à aucun centre de frais
				pack_global.recuperer_message(20339, NULL,NULL,'CODSG', l_msg);
          			raise_application_error(-20339, l_msg);
			ELSE
				IF (l_scentrefrais!=l_centre_frais) then
				--msg:Ce DPG n'appartient pas à ce centre de frais
				pack_global.recuperer_message(20334, '%s1',to_char(l_centre_frais),'CODSG', l_msg);
          			raise_application_error(-20334, l_msg);
				END IF;
      			END IF;
     		END IF;
   	END IF;

  ELSE
     -- =====================================================================
     -- 07/02/2001 : Test si le DPG appartient au périmètre de l'utilisateur
     -- =====================================================================
     pack_habilitation.verif_habili_me ( p_param6,p_global  , p_message  );

  END IF;
END verif_ppcm;

END pack_ppcm;
/
