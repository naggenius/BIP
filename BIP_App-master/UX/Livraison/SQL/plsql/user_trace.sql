-- Package PL/SQL USER_TRACE 

-- cree le 03/11/2011 par BSA FICHE QC 1274


CREATE OR REPLACE PACKAGE     USER_TRACE AS

TYPE t_array IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;

TYPE RefCurTyp IS REF CURSOR;


FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array; 

                        
PROCEDURE VERIF_TRACE (  p_date_debut       IN VARCHAR2,
                         p_date_fin         IN VARCHAR2, 
                         p_controle_date    IN NUMBER,
                         p_message          OUT VARCHAR2
                        );                        
                                                            
PROCEDURE GESTION_CREATION (  p_smenus_user   IN VARCHAR2, 
                                    p_code_menu     IN VARCHAR2,
                                    p_fields        OUT VARCHAR2,
                                    p_values        OUT VARCHAR2);


PROCEDURE GESTION_MODIFICATION (  p_user_navigation           IN OUT NAVIGATION_USER%ROWTYPE,
                                  p_sous_menu_liste       IN VARCHAR2  
                                      );
                                                                   
PROCEDURE INSERT_TRACE( p_userid             IN VARCHAR2,
                        p_menuId             IN VARCHAR2,
                        p_message               OUT VARCHAR2
                             );

PROCEDURE PURGE ;


END USER_TRACE;
/


CREATE OR REPLACE PACKAGE BODY     USER_TRACE AS

   

PROCEDURE VERIF_TRACE (  p_date_debut       IN VARCHAR2,
                         p_date_fin         IN VARCHAR2, 
                         p_controle_date    IN NUMBER,
                         p_message          OUT VARCHAR2
                        ) IS

    l_msg VARCHAR2(1024);

    t_trace NUMBER;
    t_req  VARCHAR2(1024);   
        
    c_trace RefCurTyp;
        
    CURSOR c_date IS
            SELECT MIN(n.DATE_CREATION) FROM NAVIGATION_USER n;        
    
    t_date DATE;
              
    BEGIN
    
        IF ( NVL(p_controle_date,-1) != 1 ) THEN
        
            OPEN c_date;
            FETCH c_date INTO t_date;
            IF c_date%FOUND THEN
                IF TO_CHAR(t_date,'YYYYMM') > SUBSTR(p_date_debut,4) || SUBSTR(p_date_debut,1,2) THEN
                    Pack_Global.recuperer_message(21233, '%s1','Semaine '|| TO_CHAR(t_date,'IW') || ' de ' || TO_CHAR(t_date,'MM/YYYY')   ,'', l_msg);
                    raise_application_error(-20356,l_msg);
                END IF;
            END IF;
         
        END IF;
            
        t_req := 'SELECT 1 FROM NAVIGATION_USER n WHERE 1=1 AND ROWNUM < 2 ';
           
        IF ( NVL(LENGTH(p_date_debut),-1) > 0 ) THEN
            t_req := t_req || ' AND to_char(n.DATE_CREATION,''YYYYMM'')  >= ''' || SUBSTR(p_date_debut,4) || SUBSTR(p_date_debut,1,2) ||'''';
        END IF;    
            
        IF ( NVL(LENGTH(p_date_fin),-1) > 0 ) THEN
         t_req := t_req || ' AND to_char(n.DATE_CREATION,''YYYYMM'')  <= ''' || SUBSTR(p_date_fin,4) || SUBSTR(p_date_fin,1,2) ||'''';
           END IF;
       
        OPEN c_trace FOR t_req;
        FETCH c_trace INTO t_trace;
        
        IF c_trace%NOTFOUND THEN
            --msg : Aucune trace d'accès à un menu Bip n'a été conservée sur la période indiquée
            Pack_Global.recuperer_message(21232, NULL,NULL,'', l_msg);
            p_message := l_msg ; 
            raise_application_error(-20356,l_msg);       
        END IF;
           
        CLOSE c_trace;
    
    END VERIF_TRACE; 
        
PROCEDURE GESTION_CREATION (    p_smenus_user   IN VARCHAR2, 
                                p_code_menu     IN VARCHAR2,
                                p_fields        OUT VARCHAR2,
                                p_values        OUT VARCHAR2) IS
    
    t_fields    VARCHAR2(200);
    t_values    VARCHAR2(200);

    CURSOR c_smenu_rtfe IS
        SELECT l.VALEUR FROM LIGNE_PARAM_BIP l
        WHERE CODE_VERSION = 'SMENUS'
            AND CODE_ACTION = 'RTFE-' || UPPER(p_code_menu);

    t_smenu_rtfe LIGNE_PARAM_BIP.VALEUR%TYPE;
    t_table t_array; 
    t_presence NUMBER;
    t_nb    NUMBER;
    t_droit_trouve   BOOLEAN;
                
    BEGIN
       
        t_fields := '-1';
        t_values := '-1';
        t_droit_trouve := FALSE;
        
        OPEN c_smenu_rtfe;
        FETCH c_smenu_rtfe INTO t_smenu_rtfe;
            
        t_table := SPLIT(t_smenu_rtfe,',');
        t_nb := t_table.COUNT ;
        
        -- Ajout du sous menu vide 
        --t_table(t_nb+1) := 'VIDE';
        
        FOR I IN 1..t_table.COUNT LOOP
        
            -- sous menu trouve 
            IF ( INSTR(UPPER(p_smenus_user) , UPPER(t_table(I)) ) > 0  ) THEN
                t_presence := 1;
                t_droit_trouve := TRUE;
            ELSE
                t_presence := 0;
            END IF;
            
            IF t_fields = '-1' THEN
                t_fields := 'SOUS_MENU_' || I || ',DROIT_SOUS_MENU_' || I;
            ELSE
                t_fields := t_fields || ',SOUS_MENU_' || I || ',DROIT_SOUS_MENU_' || I;          
            END IF;
            
            IF t_values = '-1' THEN
                t_values := '''' || t_table(I) || ''',' || t_presence;
            ELSE
                t_values :=  t_values || ',''' || t_table(I) || ''',' || t_presence;            
            END IF;                          
     
        END LOOP;         
  
        -- Gestion du sous menu vide 
        IF t_droit_trouve = TRUE THEN
            IF t_fields = '-1' THEN
                t_fields := 'SOUS_MENU_1 ,DROIT_SOUS_MENU_1 ' ;
            ELSE
                t_fields := t_fields || ',SOUS_MENU_' || TO_CHAR(t_nb+1) || ',DROIT_SOUS_MENU_' || TO_CHAR(t_nb+1);        
            END IF; 
            IF t_values = '-1' THEN
                t_values := '''' || 'VIDE' || ''',' || 0;
            ELSE
                t_values :=  t_values || ',''' || 'VIDE' || ''',' || 0;            
            END IF;                          
                   
        ELSE
            IF t_fields = '-1' THEN
                t_fields := 'SOUS_MENU_1 , DROIT_SOUS_MENU_1 ';
            ELSE            
                t_fields := t_fields || ',SOUS_MENU_' || TO_CHAR(t_nb+1) || ',DROIT_SOUS_MENU_' || TO_CHAR(t_nb+1);         
            END IF; 
            IF t_values = '-1' THEN
                t_values := '''' || 'VIDE' || ''',' || 1;
            ELSE
                t_values :=  t_values || ',''' || 'VIDE' || ''',' || 1;            
            END IF;                          
        
        END IF;
        
        
        
       p_fields := t_fields;
       p_values := t_values; 
    
    END GESTION_CREATION;


PROCEDURE GESTION_MODIFICATION (  p_user_navigation   IN OUT NAVIGATION_USER%ROWTYPE,
                                  p_sous_menu_liste       IN VARCHAR2
                                      ) IS
    
    CURSOR c_smenu_rtfe IS
        SELECT l.VALEUR FROM LIGNE_PARAM_BIP l
        WHERE CODE_VERSION = 'SMENUS'
            AND CODE_ACTION = 'RTFE-' || UPPER(p_user_navigation.CODE_MENU);

    t_liste_smenu_rtfe LIGNE_PARAM_BIP.VALEUR%TYPE;
    
    t_table_rtfe    t_array;
    t_table         t_array;
    
    t_num NUMBER;
    int_droit NUMBER(5);
    t_liste_ssmenu_user VARCHAR2(2000);
    t_droit_trouve   BOOLEAN;
                    
    BEGIN
        
        t_droit_trouve := FALSE;
        
        t_liste_ssmenu_user := p_user_navigation.SOUS_MENU_1 || ',' || p_user_navigation.SOUS_MENU_2 || ',' || ',' || p_user_navigation.SOUS_MENU_3 || ',' || ',' || p_user_navigation.SOUS_MENU_4 || ',' || ',' || p_user_navigation.SOUS_MENU_5;
        t_liste_ssmenu_user := t_liste_ssmenu_user || ',' || p_user_navigation.SOUS_MENU_6 || ',' || ',' || p_user_navigation.SOUS_MENU_7 || ',' || ',' || p_user_navigation.SOUS_MENU_8 || ',' || ',' || p_user_navigation.SOUS_MENU_9 || ',' || ',' || p_user_navigation.SOUS_MENU_10;
        
        OPEN c_smenu_rtfe;
        FETCH c_smenu_rtfe INTO t_liste_smenu_rtfe;
        
        IF c_smenu_rtfe%FOUND THEN

        t_table := SPLIT(t_liste_smenu_rtfe,',');
            
            FOR I IN 1..t_table.COUNT LOOP
                
                -- test droit user 
                IF ( INSTR( UPPER(p_sous_menu_liste),UPPER(t_table(I)) ) > 0 ) THEN
                    int_droit := 1;
                    t_droit_trouve := TRUE;
                ELSE
                    int_droit := 0;
                END IF;
                
                -- Champ deja present en base => modif valeur du champ 
                IF  ( INSTR( UPPER(t_liste_ssmenu_user),UPPER(t_table(I)) ) > 0 ) THEN

                    IF UPPER(p_user_navigation.SOUS_MENU_1) = UPPER(t_table(I)) THEN 
                        IF p_user_navigation.DROIT_SOUS_MENU_1 = 0 THEN
                            p_user_navigation.DROIT_SOUS_MENU_1 := int_droit;
                        END IF;
                    ELSIF UPPER(p_user_navigation.SOUS_MENU_2) = UPPER(t_table(I)) THEN
                        IF p_user_navigation.DROIT_SOUS_MENU_2 = 0 THEN
                            p_user_navigation.DROIT_SOUS_MENU_2 := int_droit;
                        END IF;
                    ELSIF UPPER(p_user_navigation.SOUS_MENU_3) = UPPER(t_table(I)) THEN
                        IF p_user_navigation.DROIT_SOUS_MENU_3 = 0 THEN
                            p_user_navigation.DROIT_SOUS_MENU_3 := int_droit;
                        END IF;
                    ELSIF UPPER(p_user_navigation.SOUS_MENU_4) = UPPER(t_table(I)) THEN
                        IF p_user_navigation.DROIT_SOUS_MENU_4 = 0 THEN
                            p_user_navigation.DROIT_SOUS_MENU_4 := int_droit;
                        END IF;
                    ELSIF UPPER(p_user_navigation.SOUS_MENU_5) = UPPER(t_table(I)) THEN
                        IF p_user_navigation.DROIT_SOUS_MENU_5 = 0 THEN
                            p_user_navigation.DROIT_SOUS_MENU_5 := int_droit;
                        END IF;
                    ELSIF UPPER(p_user_navigation.SOUS_MENU_6) = UPPER(t_table(I)) THEN
                        IF p_user_navigation.DROIT_SOUS_MENU_6 = 0 THEN
                            p_user_navigation.DROIT_SOUS_MENU_6 := int_droit;
                        END IF;
                    ELSIF UPPER(p_user_navigation.SOUS_MENU_7) = UPPER(t_table(I)) THEN
                        IF p_user_navigation.DROIT_SOUS_MENU_7 = 0 THEN
                            p_user_navigation.DROIT_SOUS_MENU_7 := int_droit;
                        END IF;
                    ELSIF UPPER(p_user_navigation.SOUS_MENU_8) = UPPER(t_table(I)) THEN
                        IF p_user_navigation.DROIT_SOUS_MENU_8 = 0 THEN
                            p_user_navigation.DROIT_SOUS_MENU_8 := int_droit;
                        END IF;
                    ELSIF UPPER(p_user_navigation.SOUS_MENU_9) = UPPER(t_table(I)) THEN
                        IF p_user_navigation.DROIT_SOUS_MENU_9 = 0 THEN
                            p_user_navigation.DROIT_SOUS_MENU_9 := int_droit;
                        END IF;
                    ELSIF UPPER(p_user_navigation.SOUS_MENU_10) = UPPER(t_table(I)) THEN
                        IF p_user_navigation.DROIT_SOUS_MENU_10 = 0 THEN
                            p_user_navigation.DROIT_SOUS_MENU_10 := int_droit;
                        END IF;
                    
                    END IF;
     
                -- Champ non present en base => creation  valeur + champ       
                ELSE

                    IF p_user_navigation.SOUS_MENU_1 IS NULL THEN
                        p_user_navigation.SOUS_MENU_1 := t_table(I);            
                        p_user_navigation.DROIT_SOUS_MENU_1 := int_droit;
                    ELSIF p_user_navigation.SOUS_MENU_2 IS NULL THEN
                        p_user_navigation.SOUS_MENU_2 := t_table(I);
                        p_user_navigation.DROIT_SOUS_MENU_2 := int_droit;
                    ELSIF p_user_navigation.SOUS_MENU_3 IS NULL THEN
                        p_user_navigation.SOUS_MENU_3 := t_table(I);
                        p_user_navigation.DROIT_SOUS_MENU_3 := int_droit;
                    ELSIF p_user_navigation.SOUS_MENU_4 IS NULL THEN
                        p_user_navigation.SOUS_MENU_4 := t_table(I);
                        p_user_navigation.DROIT_SOUS_MENU_4 := int_droit;
                    ELSIF p_user_navigation.SOUS_MENU_5 IS NULL THEN
                        p_user_navigation.SOUS_MENU_5 := t_table(I);
                        p_user_navigation.DROIT_SOUS_MENU_5 := int_droit;
                    ELSIF p_user_navigation.SOUS_MENU_6 IS NULL THEN
                        p_user_navigation.SOUS_MENU_6 := t_table(I);
                        p_user_navigation.DROIT_SOUS_MENU_6 := int_droit;
                    ELSIF p_user_navigation.SOUS_MENU_7 IS NULL THEN
                        p_user_navigation.SOUS_MENU_7 := t_table(I);
                        p_user_navigation.DROIT_SOUS_MENU_7 := int_droit;
                    ELSIF p_user_navigation.SOUS_MENU_8 IS NULL THEN
                        p_user_navigation.SOUS_MENU_8 := t_table(I);
                        p_user_navigation.DROIT_SOUS_MENU_8 := int_droit;
                    ELSIF p_user_navigation.SOUS_MENU_9 IS NULL THEN
                        p_user_navigation.SOUS_MENU_9 := t_table(I);
                        p_user_navigation.DROIT_SOUS_MENU_9 := int_droit;
                    ELSIF p_user_navigation.SOUS_MENU_10 IS NULL THEN
                        p_user_navigation.SOUS_MENU_10 := t_table(I);
                        p_user_navigation.DROIT_SOUS_MENU_10 := int_droit;
    
                    END IF;    
    
                END IF; 
            
            END LOOP;
            
            -- Gestion du sous menu vide 
            IF t_droit_trouve = FALSE THEN
                    IF p_user_navigation.SOUS_MENU_1 = 'VIDE' THEN
                        p_user_navigation.DROIT_SOUS_MENU_1 := 1;
                    ELSIF p_user_navigation.SOUS_MENU_2 = 'VIDE' THEN
                        p_user_navigation.DROIT_SOUS_MENU_2 := 1;
                    ELSIF p_user_navigation.SOUS_MENU_3 = 'VIDE' THEN
                        p_user_navigation.DROIT_SOUS_MENU_3 := 1;
                    ELSIF p_user_navigation.SOUS_MENU_4 = 'VIDE' THEN
                        p_user_navigation.DROIT_SOUS_MENU_4 := 1;
                    ELSIF p_user_navigation.SOUS_MENU_5 = 'VIDE' THEN
                        p_user_navigation.DROIT_SOUS_MENU_5 := 1;
                    ELSIF p_user_navigation.SOUS_MENU_6 = 'VIDE' THEN
                        p_user_navigation.DROIT_SOUS_MENU_6 := 1;
                    ELSIF p_user_navigation.SOUS_MENU_7 = 'VIDE' THEN
                        p_user_navigation.DROIT_SOUS_MENU_7 := 1;
                    ELSIF p_user_navigation.SOUS_MENU_8 = 'VIDE' THEN
                        p_user_navigation.DROIT_SOUS_MENU_8 := 1;
                    ELSIF p_user_navigation.SOUS_MENU_9 = 'VIDE' THEN
                        p_user_navigation.DROIT_SOUS_MENU_9 := 1;
                    ELSIF p_user_navigation.SOUS_MENU_10 = 'VIDE' THEN
                        p_user_navigation.DROIT_SOUS_MENU_10 := 1;
    
                    END IF;           
            END IF;
            

                     
            p_user_navigation.DATE_MODIFICATION := SYSDATE;
            p_user_navigation.COMPTEUR_MENU := p_user_navigation.COMPTEUR_MENU + 1;                                                                
         
        END IF;
        
        CLOSE c_smenu_rtfe;
    
    END GESTION_MODIFICATION;
       
PROCEDURE MODIF_CHAMP (    p_user_navigation   IN OUT NAVIGATION_USER%ROWTYPE ,
                           p_smenu             IN NAVIGATION_USER.SOUS_MENU_1%TYPE
                      ) IS
 
    t_liste_ssmenu_user VARCHAR2(2000);
    int_value    NAVIGATION_USER.DROIT_SOUS_MENU_1%TYPE;
                   
    BEGIN

        int_value := 1;
        
        t_liste_ssmenu_user := p_user_navigation.SOUS_MENU_1 || ',' || p_user_navigation.SOUS_MENU_2 || ',' || ',' || p_user_navigation.SOUS_MENU_3 || ',' || ',' || p_user_navigation.SOUS_MENU_4 || ',' || ',' || p_user_navigation.SOUS_MENU_5;
        t_liste_ssmenu_user := t_liste_ssmenu_user || ',' || p_user_navigation.SOUS_MENU_6 || ',' || ',' || p_user_navigation.SOUS_MENU_7 || ',' || ',' || p_user_navigation.SOUS_MENU_8 || ',' || ',' || p_user_navigation.SOUS_MENU_9 || ',' || ',' || p_user_navigation.SOUS_MENU_10;

    -- Champ deja present en base => modif valeur du champ
    IF  ( INSTR( UPPER(t_liste_ssmenu_user),UPPER(p_smenu) ) > 0 ) THEN
    
        IF UPPER(p_user_navigation.SOUS_MENU_1) = UPPER(p_smenu) THEN 
            p_user_navigation.DROIT_SOUS_MENU_1 := 1;
        ELSIF UPPER(p_user_navigation.SOUS_MENU_2) = UPPER(p_smenu) THEN
            p_user_navigation.DROIT_SOUS_MENU_2 := 1;
        ELSIF UPPER(p_user_navigation.SOUS_MENU_3) = UPPER(p_smenu) THEN
            p_user_navigation.DROIT_SOUS_MENU_3 := 1;
        ELSIF UPPER(p_user_navigation.SOUS_MENU_4) = UPPER(p_smenu) THEN
            p_user_navigation.DROIT_SOUS_MENU_4 := 1;
        ELSIF UPPER(p_user_navigation.SOUS_MENU_5) = UPPER(p_smenu) THEN
            p_user_navigation.DROIT_SOUS_MENU_5 := 1;
        ELSIF UPPER(p_user_navigation.SOUS_MENU_6) = UPPER(p_smenu) THEN
            p_user_navigation.DROIT_SOUS_MENU_6 := 1;
        ELSIF UPPER(p_user_navigation.SOUS_MENU_7) = UPPER(p_smenu) THEN
            p_user_navigation.DROIT_SOUS_MENU_7 := 1;
        ELSIF UPPER(p_user_navigation.SOUS_MENU_8) = UPPER(p_smenu) THEN
            p_user_navigation.DROIT_SOUS_MENU_8 := 1;
        ELSIF UPPER(p_user_navigation.SOUS_MENU_9) = UPPER(p_smenu) THEN
            p_user_navigation.DROIT_SOUS_MENU_9 := 1;
        ELSIF UPPER(p_user_navigation.SOUS_MENU_10) = UPPER(p_smenu) THEN
            p_user_navigation.DROIT_SOUS_MENU_10 := 1;
                    
        END IF;
     
    -- Champ non present en base => creation  valeur + champ       
    ELSE
    
        IF NVL(p_user_navigation.SOUS_MENU_1,'') = '' THEN
            p_user_navigation.SOUS_MENU_1 := p_smenu;            
            p_user_navigation.DROIT_SOUS_MENU_1 := int_value;
        ELSIF NVL(p_user_navigation.SOUS_MENU_2,'') = '' THEN
            p_user_navigation.SOUS_MENU_2 := p_smenu;
            p_user_navigation.DROIT_SOUS_MENU_2 := int_value;
        ELSIF NVL(p_user_navigation.SOUS_MENU_3,'') = '' THEN
            p_user_navigation.SOUS_MENU_3 := p_smenu;
            p_user_navigation.DROIT_SOUS_MENU_3 := int_value;
        ELSIF NVL(p_user_navigation.SOUS_MENU_4,'') = '' THEN
            p_user_navigation.SOUS_MENU_4 := p_smenu;
            p_user_navigation.DROIT_SOUS_MENU_4 := int_value;
        ELSIF NVL(p_user_navigation.SOUS_MENU_5,'') = '' THEN
            p_user_navigation.SOUS_MENU_5 := p_smenu;
            p_user_navigation.DROIT_SOUS_MENU_5 := int_value;
        ELSIF NVL(p_user_navigation.SOUS_MENU_6,'') = '' THEN
            p_user_navigation.SOUS_MENU_6 := p_smenu;
            p_user_navigation.DROIT_SOUS_MENU_6 := int_value;
        ELSIF NVL(p_user_navigation.SOUS_MENU_7,'') = '' THEN
            p_user_navigation.SOUS_MENU_7 := p_smenu;
            p_user_navigation.DROIT_SOUS_MENU_7 := int_value;
        ELSIF NVL(p_user_navigation.SOUS_MENU_8,'') = '' THEN
            p_user_navigation.SOUS_MENU_8 := p_smenu;
            p_user_navigation.DROIT_SOUS_MENU_8 := int_value;
        ELSIF NVL(p_user_navigation.SOUS_MENU_9,'') = '' THEN
            p_user_navigation.SOUS_MENU_9 := p_smenu;
            p_user_navigation.DROIT_SOUS_MENU_9 := int_value;
        ELSIF NVL(p_user_navigation.SOUS_MENU_10,'') = '' THEN
            p_user_navigation.SOUS_MENU_10 := p_smenu;
            p_user_navigation.DROIT_SOUS_MENU_10 := int_value;
                    
        END IF;    
    
    END IF;
                          
END MODIF_CHAMP;



    FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array 
    IS
   
       i       number :=0;
       pos     number :=0;
       lv_str  varchar2(50) := p_in_string;
      
    strings t_array;
   
    BEGIN
   
       -- determine first chuck of string  
       pos := instr(lv_str,p_delim,1,1);
   
       -- while there are chunks left, loop 
       WHILE ( pos != 0) LOOP
         
          -- increment counter 
          i := i + 1;
         
          -- create array element for chuck of string 
          strings(i) := substr(lv_str,1,pos-1);
         
          -- remove chunk from string 
          lv_str := substr(lv_str,pos+1,length(lv_str));
         
          -- determine next chunk 
          pos := instr(lv_str,p_delim,1,1);
         
          -- no last chunk, add to array 
          IF pos = 0 THEN
        
             strings(i+1) := lv_str;
         
          END IF;
      
       END LOOP;
   
       -- return array 
       RETURN strings;
      
    END SPLIT;
   
   
PROCEDURE INSERT_TRACE( p_userid             IN VARCHAR2,
                        p_menuId             IN VARCHAR2,
                        p_message               OUT VARCHAR2
                             ) IS 


    
    t_user_rtfe         RTFE_USER.USER_RTFE%TYPE;
    t_ident             RTFE_USER.IDENT%TYPE; 
    t_nom               RTFE_USER.NOM%TYPE;
    t_prenom            RTFE_USER.PRENOM%TYPE;           
    t_sous_menu_liste   LIGNE_PARAM_BIP.VALEUR%TYPE; 

  
    -- 1 enregistrement par semaine, menu et user 
    CURSOR c_user_trace IS
        SELECT *
        FROM NAVIGATION_USER n
        WHERE 1=1
            AND UPPER(n.USER_RTFE) = UPPER(t_user_rtfe)
            AND UPPER(n.CODE_MENU) = UPPER(p_menuId)
            AND TO_CHAR(n.DATE_CREATION,'YYYYIW') = TO_CHAR(SYSDATE,'YYYYIW');
            
    t_user_trace   c_user_trace%ROWTYPE;
                
    CURSOR c_smenu_rtfe IS
        SELECT l.VALEUR FROM LIGNE_PARAM_BIP l
        WHERE CODE_VERSION = 'SMENUS'
            AND CODE_ACTION = 'RTFE-' || UPPER(p_menuId);

    t_smenu_rtfe LIGNE_PARAM_BIP.VALEUR%TYPE;
    
    t_table t_array; 
    t_fields    VARCHAR2(200);
    t_values    VARCHAR2(200);
    t_req       VARCHAR2(1000);
    t_sets      VARCHAR2(1000);
    t_sous_menu NAVIGATION_USER.SOUS_MENU_1%TYPE;
    
    int_presence NUMBER;
    
    
   BEGIN

        -- Initialiser le message retour
        p_message := '';
        
        t_user_rtfe := pack_global.lire_globaldata(p_userid).idarpege;
        t_sous_menu_liste := pack_global.lire_globaldata(p_userid).sousmenus;

        SELECT NVL(r.IDENT,-1) , r.NOM, r.PRENOM INTO t_ident, t_nom, t_prenom
        FROM RTFE_USER r
        WHERE UPPER(USER_RTFE) = UPPER(t_user_rtfe);

        OPEN c_user_trace;
        FETCH c_user_trace INTO t_user_trace;
           
        -- Modification ligne 
        IF c_user_trace%FOUND THEN

            GESTION_MODIFICATION( t_user_trace,t_sous_menu_liste);
   
            UPDATE NAVIGATION_USER SET
                DATE_MODIFICATION =  t_user_trace.DATE_MODIFICATION,
                COMPTEUR_MENU =  t_user_trace.COMPTEUR_MENU,
                SOUS_MENU_1 =  t_user_trace.SOUS_MENU_1,
                DROIT_SOUS_MENU_1 =  t_user_trace.DROIT_SOUS_MENU_1,
                SOUS_MENU_2 =  t_user_trace.SOUS_MENU_2,
                DROIT_SOUS_MENU_2 =  t_user_trace.DROIT_SOUS_MENU_2,
                SOUS_MENU_3 =  t_user_trace.SOUS_MENU_3,
                DROIT_SOUS_MENU_3 =  t_user_trace.DROIT_SOUS_MENU_3,
                SOUS_MENU_4 =  t_user_trace.SOUS_MENU_4,
                DROIT_SOUS_MENU_4 =  t_user_trace.DROIT_SOUS_MENU_4,
                SOUS_MENU_5 =  t_user_trace.SOUS_MENU_5,
                DROIT_SOUS_MENU_5 =  t_user_trace.DROIT_SOUS_MENU_5,
                SOUS_MENU_6 =  t_user_trace.SOUS_MENU_6,
                DROIT_SOUS_MENU_6 =  t_user_trace.DROIT_SOUS_MENU_6,
                SOUS_MENU_7 =  t_user_trace.SOUS_MENU_7,
                DROIT_SOUS_MENU_7 =  t_user_trace.DROIT_SOUS_MENU_7,
                SOUS_MENU_8 =  t_user_trace.SOUS_MENU_8,
                DROIT_SOUS_MENU_8 =  t_user_trace.DROIT_SOUS_MENU_8,
                SOUS_MENU_9 =  t_user_trace.SOUS_MENU_9,
                DROIT_SOUS_MENU_9 =  t_user_trace.DROIT_SOUS_MENU_9,
                SOUS_MENU_10 =  t_user_trace.SOUS_MENU_10,
                DROIT_SOUS_MENU_10 =  t_user_trace.DROIT_SOUS_MENU_10
            WHERE 1=1
                AND UPPER(USER_RTFE) = UPPER(t_user_rtfe)
                AND UPPER(CODE_MENU) = UPPER(p_menuId)
                AND TO_CHAR(DATE_CREATION,'YYYYIW') = TO_CHAR(SYSDATE,'YYYYIW');

        -- Creation ligne 
        ELSE

            GESTION_CREATION (t_sous_menu_liste,p_menuId,t_fields, t_values);
               
            t_req := 'INSERT INTO NAVIGATION_USER (USER_RTFE,NOM,PRENOM,IDENT,DATE_CREATION,DATE_MODIFICATION,CODE_MENU,COMPTEUR_MENU,';
            t_req := t_req || t_fields;
            t_req := t_req || ') VALUES (';
            t_req := t_req || '''' || t_user_rtfe || ''',''' || t_nom || ''',''' || t_prenom || ''',''' || t_ident || ''', TO_DATE(''' || TO_CHAR(SYSDATE,'DDMMYYYY HH24:MI') || ''',''DDMMYYYY HH24:MI''  ), TO_DATE(''' || TO_CHAR(SYSDATE,'DDMMYYYY HH24:MI') || ''',''DDMMYYYY HH24:MI''  ),''' || p_menuId || ''',1,' ;
            t_req := t_req || t_values;
            t_req := t_req || ')';

            execute immediate t_req;                

        END IF;
            
            
        CLOSE c_user_trace;
        
        
        EXCEPTION

            WHEN OTHERS THEN
              raise_application_error( -20997, SQLERRM);

   END INSERT_TRACE;

PROCEDURE PURGE IS
    
                
    BEGIN

        DELETE FROM NAVIGATION_USER n 
        WHERE n.DATE_CREATION < (SYSDATE -731) ;           
    
    END PURGE;
    
    
END USER_TRACE;
/
