-- pack_rbip_etape PL/SQL
--
-- OEL
-- Créé le 09/12/2011
-- QC 1283
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
create or replace
PACKAGE     PACK_RBIP_ETAPE AS



   TYPE RefCurTyp IS REF CURSOR;


   PROCEDURE LISTE_JEU_TYPE_ETAPE ( p_userid    IN VARCHAR2,
                                    p_pid       IN VARCHAR2,
                                    p_message   OUT VARCHAR2,
                                    p_liste     OUT VARCHAR2);

PROCEDURE LISTE_TOTAL_JEU_TYPE_ETAPE ( p_userid    IN VARCHAR2,
                                    p_pid       IN VARCHAR2,
                                    p_message   OUT VARCHAR2,
                                    p_liste     OUT VARCHAR2);

   PROCEDURE IS_PID_VALID ( p_userid    IN VARCHAR2,
                            p_pid       IN VARCHAR2,
                            p_message   OUT VARCHAR2);

END PACK_RBIP_ETAPE;
/


CREATE OR REPLACE PACKAGE BODY     PACK_RBIP_ETAPE
AS
-- *****************************************************************************************************
-- Auteur          |  Date
-- *****************************************************************************************************
-- OEL QC 1283     |  08/12/2011
-- *****************************************************************************************************
   
   PROCEDURE LISTE_JEU_TYPE_ETAPE ( p_userid    IN VARCHAR2, 
                                    p_pid       IN VARCHAR2,
                                    p_message   OUT VARCHAR2, 
                                    p_liste     OUT VARCHAR2)
   IS
      
   l_listejeux    LIGNE_PARAM_BIP.VALEUR%type;
   l_typetape     VARCHAR2 (1000);
   l_codeligne    LIGNE_BIP.PID%type;
   t_req          VARCHAR2 (1000);
   C_TYPETAPE RefCurTyp;
   
   CURSOR C_CODLIG IS 
                SELECT lig.PID
                FROM  LIGNE_BIP lig
                WHERE lig.PID = TRIM(p_pid);
                
   CURSOR C_LJEUX IS 
                SELECT '''' || REPLACE (lpb.VALEUR, ',', ''',''') || ''''
                FROM  struct_info inf, 
                      ligne_bip lig,
                      LIGNE_PARAM_BIP lpb
                WHERE inf.CODSG = lig.CODSG
                AND lpb.CODE_VERSION = to_char(inf.CODDIR)
                AND lpb.CODE_ACTION = 'TYPETAPES-JEUX'
                AND lpb.ACTIF = 'O'
                AND lig.PID = TRIM(p_pid);
    
    CURSOR C_DEFAULT IS
                SELECT '''' || REPLACE (lpb.VALEUR, ',', ''',''') || ''''
                FROM LIGNE_PARAM_BIP lpb
                WHERE lpb.CODE_ACTION  = 'TYPETAPES-JEUX'
                AND lpb.CODE_VERSION = 'DEFAUT'
                AND lpb.ACTIF = 'O';
                            
     
   BEGIN

        BEGIN
            
                OPEN C_CODLIG;
                FETCH C_CODLIG INTO l_codeligne;
                
                IF C_CODLIG%FOUND THEN
                                            
                        OPEN C_LJEUX;
                        FETCH C_LJEUX INTO l_listejeux;
                        IF C_LJEUX%FOUND THEN
                            --dbms_output.put_line('Liste Jeux : ' || l_listejeux);
                            p_message := 'OK';
                        ELSE
                                
                                OPEN C_DEFAULT;
                                FETCH C_DEFAULT INTO l_listejeux;
                                IF C_DEFAULT%FOUND THEN
                                    dbms_output.put_line('Liste Jeux par Défaut : ' || l_listejeux);
                                                                    
                                    p_message := 'OK';
                                    
                                    ELSE
                                     
                                     --SEL PPM 60709 5.4 5.5
                                     select distinct
                                  listagg ('''' || REPLACE (jeu, ',', ''',''') || '''', ',')
                                  WITHIN GROUP
                                  (ORDER BY jeu) jeu into l_listejeux
                                  FROM
                                  type_etape_jeux;
                                  dbms_output.put_line('NO Liste Jeux par Défaut : '||l_listejeux);
                                END IF;
                                CLOSE C_DEFAULT;
                            
                        END IF;
                        CLOSE C_LJEUX;
                        
                        
                         BEGIN
            
                            t_req := 'SELECT te.TYPETAP FROM type_etape te WHERE te.jeu IN (' || l_listejeux || ')';
                            OPEN C_TYPETAPE FOR t_req;
                            FETCH C_TYPETAPE INTO l_typetape;
                            p_liste :='';
                            LOOP
                 
                                IF (p_liste ='' or p_liste is null) THEN
                                        p_liste := l_typetape;
                                ELSE
                                        p_liste := p_liste || ',' || l_typetape;
                                END IF;
                
                                EXIT WHEN C_TYPETAPE%NOTFOUND;
                                IF C_TYPETAPE%FOUND THEN
                                    --dbms_output.put_line('Liste Type Etape : ' || l_typetape);
                                    p_message := 'OK';
                                END IF;
                                FETCH C_TYPETAPE INTO l_typetape;
                
                            END LOOP;
                            CLOSE C_TYPETAPE;
            
                         END;
                        
                ELSE
                        p_message := 'code ligne inexistant';
                        -- PACK_GLOBAL.RECUPERER_MESSAGE( ID_Message, NULL, NULL, NULL, MSG); EX: pack_global.recuperer_message( 20274, NULL, NULL, NULL, msg);
                        -- RAISE_APPLICATION_ERROR( -ID_Message, MSG ); EX: raise_application_error( -20274, msg );
                END IF;
                CLOSE C_CODLIG;
        
        END; 

  END LISTE_JEU_TYPE_ETAPE;

--PPM60709 16/07/2015 13.22
PROCEDURE LISTE_TOTAL_JEU_TYPE_ETAPE ( p_userid    IN VARCHAR2,
                                    p_pid       IN VARCHAR2,
                                    p_message   OUT VARCHAR2,
                                    p_liste     OUT VARCHAR2)
   IS

   l_listejeux    LIGNE_PARAM_BIP.VALEUR%type;
   l_typetape     VARCHAR2 (1000);
   l_codeligne    LIGNE_BIP.PID%type;
   t_req          VARCHAR2 (1000);
   C_TYPETAPE RefCurTyp;

   CURSOR C_CODLIG IS
                SELECT lig.PID
                FROM  LIGNE_BIP lig
                WHERE lig.PID = TRIM(p_pid);

   CURSOR C_LJEUX IS
                SELECT '''' || REPLACE (lpb.VALEUR, ',', ''',''') || ''''
                FROM  struct_info inf,
                      ligne_bip lig,
                      LIGNE_PARAM_BIP lpb
                WHERE inf.CODSG = lig.CODSG
                AND lpb.CODE_VERSION = to_char(inf.CODDIR)
                AND lpb.CODE_ACTION like 'TYPETAPES-JEUX-%'
                AND lpb.ACTIF = 'O'
                AND lig.PID = TRIM(p_pid);

    CURSOR C_DEFAULT IS
                SELECT '''' || REPLACE (lpb.VALEUR, ',', ''',''') || ''''
                FROM LIGNE_PARAM_BIP lpb
                WHERE lpb.CODE_ACTION  = 'TYPETAPES-JEUX-%'
                AND lpb.CODE_VERSION = 'DEFAUT'
                AND lpb.ACTIF = 'O';


   BEGIN

        BEGIN

                OPEN C_CODLIG;
                FETCH C_CODLIG INTO l_codeligne;

                IF C_CODLIG%FOUND THEN

                        OPEN C_LJEUX;
                        FETCH C_LJEUX INTO l_listejeux;
                        IF C_LJEUX%FOUND THEN
                            --dbms_output.put_line('Liste Jeux : ' || l_listejeux);
                            p_message := 'OK';
                        ELSE

                                OPEN C_DEFAULT;
                                FETCH C_DEFAULT INTO l_listejeux;
                                IF C_DEFAULT%FOUND THEN
                                    --dbms_output.put_line('Liste Jeux par Défaut : ' || l_listejeux);
                                    p_message := 'OK';
                                END IF;
                                CLOSE C_DEFAULT;

                        END IF;
                        CLOSE C_LJEUX;


                         BEGIN

                            t_req := 'SELECT te.TYPETAP FROM type_etape te WHERE te.jeu IN (' || l_listejeux || ')';
                            OPEN C_TYPETAPE FOR t_req;
                            FETCH C_TYPETAPE INTO l_typetape;
                            p_liste :='';
                            LOOP

                                IF (p_liste ='' or p_liste is null) THEN
                                        p_liste := l_typetape;
                                ELSE
                                        p_liste := p_liste || ',' || l_typetape;
                                END IF;

                                EXIT WHEN C_TYPETAPE%NOTFOUND;
                                IF C_TYPETAPE%FOUND THEN
                                    --dbms_output.put_line('Liste Type Etape : ' || l_typetape);
                                    p_message := 'OK';
                                END IF;
                                FETCH C_TYPETAPE INTO l_typetape;

                            END LOOP;
                            CLOSE C_TYPETAPE;

                         END;

                ELSE
                        p_message := 'code ligne inexistant';
                        -- PACK_GLOBAL.RECUPERER_MESSAGE( ID_Message, NULL, NULL, NULL, MSG); EX: pack_global.recuperer_message( 20274, NULL, NULL, NULL, msg);
                        -- RAISE_APPLICATION_ERROR( -ID_Message, MSG ); EX: raise_application_error( -20274, msg );
                END IF;
                CLOSE C_CODLIG;

        END;

   END LISTE_TOTAL_JEU_TYPE_ETAPE;









   PROCEDURE IS_PID_VALID ( p_userid    IN VARCHAR2, 
                            p_pid       IN VARCHAR2,
                            p_message   OUT VARCHAR2)
   IS
      
   l_codeligne    LIGNE_BIP.PID%type;
   
   CURSOR C_CODLIG IS 
                SELECT lig.PID
                FROM  LIGNE_BIP lig
                WHERE lig.PID = TRIM(p_pid);
                             
     
   BEGIN
 
                OPEN C_CODLIG;
                FETCH C_CODLIG INTO l_codeligne;
                
                IF C_CODLIG%FOUND THEN
                        p_message := 'OK';
                ELSE
                        p_message := 'code ligne inexistant';

                END IF;
                CLOSE C_CODLIG;
                  

   END IS_PID_VALID;


END PACK_RBIP_ETAPE;
/