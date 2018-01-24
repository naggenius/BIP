-- pack_RefTrans PL/SQL
-- equipe SOPRA
-- crée le 27/10/1999
-- Package qui sert à la réalisation du report RefTrans
-- 22/02/2010 ABA : TD 938
-- -------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_RefTrans IS

-- =========================================================================
-- PROCEDURE Verif_Param
-- Role : Verifie l'existance de et l'exactitude du paramettre d'entree de
--        l'édition RefTrans.
-- Parametre : P_codPADP peut prendre une valeure d'un Code Porjet ou d'un
--               Code Appli ou d'un code Dossier Projet.
-- -------------------------------------------------------------------------

-- PROCEDURE Verif_ParamProref4
-- Role : Verifie l'existance de et l'exactitude du paramettre d'entree de
--        l'édition proref4.
-- Parametre : P_codDP : code Dossier Projet.
-- -------------------------------------------------------------------------

-- FUNCTION Titre3
-- Role : Construit et retourne le 3eme ligne du titre de l'édition.
-- -------------------------------------------------------------------------

-- FUNCTION Titre4
-- Role : Construit et retourne le 4eme ligne du titre de l'édition.
-- -------------------------------------------------------------------------

   PROCEDURE Verif_Param (P_param6 IN VARCHAR2,P_param7 IN VARCHAR2,
                          P_param8 IN VARCHAR2, p_userid  IN VARCHAR2);

   PROCEDURE Verif_ParamProref4 (P_codDP IN CHAR, p_userid  IN VARCHAR2);


   FUNCTION Titre3 (P_param6 IN VARCHAR2,P_param7 IN VARCHAR2,
                          P_param8 IN VARCHAR2) RETURN VARCHAR2;

   FUNCTION Titre4 (P_param7 IN VARCHAR2,P_param8 IN VARCHAR2,
                          P_param9 IN VARCHAR2) RETURN VARCHAR2;

   -- Retourne le nombre de lignes de la table pour un codgroup donné
   FUNCTION Get_Nb_Lignes(p_codgroup 	VARCHAR2,
   			  p_numseq 	NUMBER
   			  ) RETURN NUMBER;


   -- Retourne le nombre de lignes de la table pour un codgroup donné
   FUNCTION Get_Nb_Lignes_Clicode(	p_codgroup 	VARCHAR2,
   			  		p_numseq 	NUMBER,
   			  		p_clicode	VARCHAR2
   			  ) RETURN NUMBER;


   -- Retourne le nombre de lignes de la table pour un codgroup donné
   FUNCTION Get_Nb_Lignes_codsg(	p_codgroup 	VARCHAR2,
   			  		p_numseq 	NUMBER,
   			  		p_codsg		VARCHAR2
   			  ) RETURN NUMBER;

END pack_RefTrans;
/


CREATE OR REPLACE PACKAGE BODY     pack_RefTrans IS
-- =========================================================================
-- PROCEDURE Verif_Param
-- Role : Verifie l'existance de et l'exactitude du paramettre d'entree.
-- Parametre : P_codPADP peut prendre une valeure d'un Code Porjet ou d'un
--        Code Appli ou d'un code Dossier Projet.
-- -------------------------------------------------------------------------

      PROCEDURE Verif_Param (P_param6 IN VARCHAR2,P_param7 IN VARCHAR2,
                          P_param8 IN VARCHAR2, p_userid  IN VARCHAR2) IS

   l_codeProj     VARCHAR2(5);
   l_codeAppli    VARCHAR2(5);
   l_codeDossProj NUMBER(5);
   l_msg   	  VARCHAR2(1024);


   BEGIN
       l_msg := '';

                -- PROJET 
            IF (P_param6 <> null or P_param6 != ' ')  THEN
                BEGIN
                     SELECT pri.icpi INTO l_codeProj
                     FROM proj_info pri
                    WHERE pri.icpi = P_param6
                        AND rownum < 2;

                 EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                 -- Code projet informatique inexistant
                 pack_global.recuperer_message(20735, null, null, null, l_msg);
                 raise_application_error(-20735, l_msg);

                     WHEN OTHERS THEN
                 raise_application_error(-20997, SQLERRM);
                 END;
              
              -- APPLICATION 
                ELSIF (P_param7 <> null or P_param7 != ' ') THEN
                
                  BEGIN
                      SELECT app.airt INTO l_codeAppli
                      FROM application app
                      WHERE app.airt = P_param7
                        AND rownum < 2;

                   EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                         -- Identifiant Application inexistant
                         pack_global.recuperer_message(20733, null, null, null, l_msg);
                         raise_application_error(-20733, l_msg);

                      WHEN OTHERS THEN
                         raise_application_error(-20997,SQLERRM);
                   END;
                    
                   
                   -- DOSSIER PROJET    
                    ELSIF (P_param8 <> null or P_param8 != ' ') THEN
                    
                         BEGIN
                          SELECT dp.dpcode INTO l_codeDossProj
                          FROM dossier_projet dp
                          WHERE dp.dpcode = TO_NUMBER(P_param8)
                            AND rownum < 2;

                            EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                             -- Code dossier projet inexistant
                             pack_global.recuperer_message(20729, null, null, null, l_msg);
                             raise_application_error(-20729, l_msg);

                          WHEN OTHERS THEN
                             raise_application_error(-20997,SQLERRM);
                            END;
            
            END IF;







/*



       IF SUBSTR(P_codPADP,1,1)= 'P' OR SUBSTR(P_codPADP, 1, 1)='I' THEN
           BEGIN
              SELECT pri.icpi INTO l_codeProj
              FROM proj_info pri
              WHERE pri.icpi = P_codPADP
                AND rownum < 2;

           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 -- Code projet informatique inexistant
                 pack_global.recuperer_message(20735, null, null, null, l_msg);
                 raise_application_error(-20735, l_msg);

              WHEN OTHERS THEN
                 raise_application_error(-20997, SQLERRM);
           END;


       ELSIF SUBSTR(P_codPADP,1,1)= 'A' THEN
           BEGIN
              SELECT app.airt INTO l_codeAppli
              FROM application app
              WHERE app.airt = P_codPADP
                AND rownum < 2;

           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 -- Identifiant Application inexistant
                 pack_global.recuperer_message(20733, null, null, null, l_msg);
                 raise_application_error(-20733, l_msg);

              WHEN OTHERS THEN
                 raise_application_error(-20997,SQLERRM);
           END;

       ELSIF SUBSTR(P_codPADP,1,1) IN ('0','1','2','3','4','5','6','7','8','9') THEN

           BEGIN
              SELECT dp.dpcode INTO l_codeDossProj
              FROM dossier_projet dp
              WHERE dp.dpcode = TO_NUMBER(P_codPADP)
                AND rownum < 2;

           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 -- Code dossier projet inexistant
                 pack_global.recuperer_message(20729, null, null, null, l_msg);
                 raise_application_error(-20729, l_msg);

              WHEN OTHERS THEN
                 raise_application_error(-20997,SQLERRM);
           END;

      ELSE
           -- Code projet informatique inexistant
           pack_global.recuperer_message(20735, null, null, null, l_msg);
           raise_application_error(-20735, l_msg);
      END IF;
*/
END Verif_Param;



-- -------------------------------------------------------------------------
-- PROCEDURE Verif_ParamProref4
-- Role : Verifie l'existance de et l'exactitude du paramettre d'entree de
--        l'édition proref4.
-- Parametre : P_codDP : code Dossier Projet.
-- -------------------------------------------------------------------------

   PROCEDURE Verif_ParamProref4 (P_codDP IN CHAR, p_userid  IN VARCHAR2) IS

   l_codeDossProj NUMBER(5);
   l_msg   VARCHAR2(1024);

   BEGIN
       l_msg := '';

        SELECT dp.dpcode INTO l_codeDossProj
        FROM   dossier_projet dp
        WHERE  dp.dpcode = TO_NUMBER(P_codDP)
        AND    rownum < 2;

   EXCEPTION
        WHEN NO_DATA_FOUND THEN
             -- Code dossier projet inexistant
             pack_global.recuperer_message(20729, null, null, null, l_msg);
             raise_application_error(-20729, l_msg);

        WHEN OTHERS THEN
                 raise_application_error(-20997,SQLERRM);
   END Verif_ParamProref4;


-- =========================================================================
-- FUNCTION Titre3
-- Role : Construit et retourne la 3eme ligne du titre de l'édition.
-- Parametre : P_codPADP peut prendre la valeur d'un Code Porjet ou d'un
--        Code Appli ou d'un code Dossier Projet.
-- =========================================================================

   FUNCTION Titre3 (P_param6 IN VARCHAR2,P_param7 IN VARCHAR2,
                          P_param8 IN VARCHAR2) RETURN VARCHAR2 IS

   BEGIN
       IF (P_param6 <> null or P_param6 != ' ') THEN
          RETURN 'PROJET';
       ELSIF (P_param7 <> null or P_param7 != ' ') THEN
          RETURN 'APPLICATION';
       ELSIF (P_param8 <> null or P_param8 != ' ')THEN
          RETURN 'DOSSIER PROJET';
       ELSE
          RETURN 'ERREUR';
       END IF;

   END Titre3;


-- =========================================================================
-- FUNCTION Titre4
-- Role : Construit et retourne la 4eme ligne du titre de l'édition.

-- =========================================================================

   FUNCTION Titre4 (P_param7 IN VARCHAR2,P_param8 IN VARCHAR2,
                          P_param9 IN VARCHAR2) RETURN VARCHAR2 IS
   l_titre VARCHAR2(100);
   BEGIN
       
       
       
       
       
       IF ((P_param8 <> null or P_param8 != ' ') ) THEN

          BEGIN
              SELECT pri.ilibel INTO l_titre
              FROM proj_info pri
              WHERE pri.icpi = P_param8
                AND rownum < 2;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RETURN ' ';
              WHEN OTHERS THEN
                 raise_application_error(-20997, SQLERRM);
           END;
       ELSIF (P_param9 <> null or P_param9 != ' ') THEN

          BEGIN
              SELECT app.alibel INTO l_titre
              FROM application app
              WHERE app.airt = P_param9
                AND rownum < 2;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RETURN ' ';
              WHEN OTHERS THEN
                 raise_application_error(-20997, SQLERRM);
           END;

       ELSIF (P_param7 <> null or P_param7 != ' ') THEN
          BEGIN
              SELECT dp.dplib INTO l_titre
              FROM dossier_projet dp
              WHERE dp.dpcode = TO_NUMBER(P_param7)
                AND rownum < 2;
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RETURN ' ';
              WHEN OTHERS THEN
                 raise_application_error(-20997, SQLERRM);
           END;
       ELSE
          RETURN 'ERREUR';
       END IF;

       RETURN LTRIM(RTRIM(l_titre));
   END Titre4;

   -- Retourne le nombre de lignes de la table pour un codgroup donné
   FUNCTION Get_Nb_Lignes(p_codgroup 	VARCHAR2,
   			  p_numseq 	NUMBER
   			  ) RETURN NUMBER IS
   l_nb_lignes NUMBER(10);
   BEGIN
   	SELECT count(*) INTO l_nb_lignes
   	FROM tmpreftrans
   	WHERE codgroup = p_codgroup
   	  AND numseq = p_numseq;

   	RETURN l_nb_lignes;
   END Get_Nb_Lignes;

   -- Retourne le nombre de lignes de la table pour un codgroup donné
   FUNCTION Get_Nb_Lignes_Clicode(	p_codgroup 	VARCHAR2,
   			  		p_numseq 	NUMBER,
   			  		p_clicode	VARCHAR2
   			  ) RETURN NUMBER IS
   l_nb_lignes NUMBER(10);
   BEGIN
   	SELECT count(*) INTO l_nb_lignes
   	FROM tmpreftrans
   	WHERE codgroup = p_codgroup
   	  AND codmo    = p_clicode
   	  AND numseq   = p_numseq;

   	RETURN l_nb_lignes;
   END Get_Nb_Lignes_Clicode;


   -- Retourne le nombre de lignes de la table pour un codgroup donné
   FUNCTION Get_Nb_Lignes_codsg(	p_codgroup 	VARCHAR2,
   			  		p_numseq 	NUMBER,
   			  		p_codsg		VARCHAR2
   			  ) RETURN NUMBER IS
   l_nb_lignes NUMBER(10);
   BEGIN
   	SELECT count(*) INTO l_nb_lignes
   	FROM tmpreftrans
   	WHERE codgroup = p_codgroup
   	  AND codsg    = TO_NUMBER(p_codsg)
   	  AND numseq   = p_numseq;

   	RETURN l_nb_lignes;
   END Get_Nb_Lignes_codsg;


-- -------------------------------------------------------------
END pack_RefTrans;
/



