
-- pack_type_etape PL/SQL
-- 
-- Créé le 14/11/2011  ABA   QC 1283


CREATE OR REPLACE PACKAGE     pack_type_etape
AS
   TYPE type_etape_viewtype IS RECORD (
      typetap    type_etape.typetap%TYPE,
      libtyet    type_etape.libtyet%TYPE,
      top_immo   type_etape.top_immo%TYPE,
      flaglock   type_etape.flaglock%TYPE,
      typeligne  type_etape.typeligne%TYPE
   );

   TYPE type_etape_curtype IS REF CURSOR
      RETURN type_etape_viewtype;

   TYPE jeu_viewtype IS RECORD (
      jeu           type_etape_jeux.jeu%TYPE,
      chronologie   type_etape.chronologie%TYPE
   );

   TYPE jeu_curtype IS REF CURSOR
      RETURN jeu_viewtype;


     FUNCTION controlTypeLigne (
      code IN type_etape.typeligne%TYPE
   )RETURN varchar2;

     PROCEDURE insert_type_etape (
      p_typetap     IN       type_etape.typetap%TYPE,
      p_libtyet     IN       type_etape.libtyet%TYPE,
      p_top_immo    IN       type_etape.top_immo%TYPE,
      p_chaine      IN       VARCHAR2,
      p_userid      IN       VARCHAR2,
      p_type_ligne  IN       type_etape.typeligne%TYPE,
      p_nbcurseur   OUT      INTEGER,
      p_message     OUT      message.limsg%TYPE

   );

   PROCEDURE update_type_etape (
      p_typetap     IN       type_etape.typetap%TYPE,
      p_libtyet     IN       type_etape.libtyet%TYPE,
      p_top_immo    IN       type_etape.top_immo%TYPE,
      p_flaglock             type_etape.flaglock%TYPE,
      p_type_ligne  IN       type_etape.typeligne%TYPE,
      p_chaine      IN       VARCHAR2,
      p_userid      IN       VARCHAR2,
      p_nbcurseur   OUT      INTEGER,
      p_message     OUT      VARCHAR2
   );

   PROCEDURE delete_type_etape (p_typetap IN type_etape.typetap%TYPE, p_userid IN VARCHAR2, p_nbcurseur OUT INTEGER, p_message OUT VARCHAR2);

   PROCEDURE select_type_etape (
      p_typetap         IN       type_etape.typetap%TYPE,
      p_userid          IN       VARCHAR2,
      p_curtype_etape   IN OUT   type_etape_curtype,
      p_curtype_jeu     IN OUT   jeu_curtype,
      p_nbcurseur       OUT      INTEGER,
      p_message         OUT      VARCHAR2
   );

   PROCEDURE init_type_etape_jeu (
      p_typetap         IN       type_etape.typetap%TYPE,
      p_userid          IN       VARCHAR2,
      p_curtype_etape   IN OUT   type_etape_curtype,
      p_curtype_jeu     IN OUT   jeu_curtype,
      p_nbcurseur       OUT      INTEGER,
      p_message         OUT      VARCHAR2
   );
   
   FUNCTION controle_parametrage RETURN BOOLEAN;
   
   
   PROCEDURE maj_type_etape_logs(p_typetap			IN TYPE_ETAPE_LOGS.typetap%TYPE,
                                 p_jeu      IN TYPE_ETAPE_LOGS.jeu%TYPE,
   							    p_user_log		IN TYPE_ETAPE_LOGS.user_log%TYPE,
								p_colonne		IN TYPE_ETAPE_LOGS.colonne%TYPE,
								p_valeur_prec	IN TYPE_ETAPE_LOGS.valeur_prec%TYPE,
								p_valeur_nouv	IN TYPE_ETAPE_LOGS.valeur_nouv%TYPE,
								p_commentaire	IN TYPE_ETAPE_LOGS.commentaire%TYPE
								);
   
  PROCEDURE verif_type_etape(p_jeu IN VARCHAR2,
                             p_message OUT VARCHAR2);
                             
PROCEDURE type_ligne_verif(p_type_ligne IN type_etape.typeligne%TYPE, p_message OUT message.limsg%TYPE);
   
END pack_type_etape;
/


create or replace
PACKAGE BODY     pack_type_etape
AS
   --PPM 60709 : MCH
   FUNCTION controlTypeLigne (code IN type_etape.typeligne%TYPE ) return varchar2 
   IS 
   
   l_code type_etape.typeligne%TYPE;
   l_tab_code PACK_GLOBAL.t_array;
   
   l_groupe VARCHAR2 (1000);
   l_erreur VARCHAR2 (50);
   
  
   position1 NUMBER (3);
   position2 NUMBER (3);
   position3 NUMBER (3);
   position4 NUMBER (3);
   
   apres_tiret VARCHAR2 (50);
   apres_etoile VARCHAR2 (50);
   avant_tiret VARCHAR2 (50);
   tiret_etoile VARCHAR2 (50);
   
   counter number(5);
	nbre number(10);--KRA PPM 60709 : QCs 1768,1769,1770
   tab_typ_princ PACK_GLOBAL.t_array;
   tab_typ_sec PACK_GLOBAL.t_array;
   tab_typ_sec_etoile PACK_GLOBAL.t_array;
   is_code_valid boolean;
   princi VARCHAR2 (50);
   BEGIN
   counter := 1;
   for i in (SELECT * FROM type_projet) loop
            tab_typ_princ(counter) := i.typproj;
            counter := counter + 1;
            end loop;
   counter := 1;
   for i in (SELECT * FROM type_activite) loop
            tab_typ_sec(counter) := i.arctype;
            counter := counter + 1;
            end loop;
	--KRA PPM 60709 : QCs 1768,1769,1770
	/*
   counter := 1;         
   for i in (SELECT * FROM type_activite WHERE arctype like 'S%') loop
            tab_typ_sec_etoile(counter) := i.arctype;
            counter := counter + 1;
            end loop;*/
   
   l_code := code;
   l_erreur := 'valide';
   
   if (l_code is not null) 
   then
       if  (INSTR(l_code,' ')) > 0
      then l_erreur := 'invalide';
      --DBMS_OUTPUT.PUT_LINE('espace');
      else
      l_tab_code := PACK_GLOBAL.SPLIT (l_code, ',');
      if (l_tab_code.count>30)
      then l_erreur := 'invalide';
      --DBMS_OUTPUT.PUT_LINE('>30');
      else 
          
        FOR i IN 1 .. l_tab_code.count LOOP
          
          l_groupe := l_tab_code(i);
          
         
          position1 := instr(l_groupe,'_',1,1);
          position2 := instr(l_groupe,'*',1,1);
          
          avant_tiret := substr(l_groupe,1,position1-1);
          apres_tiret := substr(l_groupe,position1+1,length(l_groupe)-position1);
          apres_etoile := substr(l_groupe,position2+1,length(l_groupe)-position2);
          tiret_etoile := substr(l_groupe,position1+1,position2-position1-1);
          
          position3 := instr(l_groupe,'_',1,2);
          position4 := instr(l_groupe,'*',1,2);
      
          if ( length(l_groupe) >6 )
          then 
          --DBMS_OUTPUT.PUT_LINE('>6');
          l_erreur := 'invalide'; exit;
          else
            
            if ( position1 = 1 or position2 = 1 or position3 != 0 or position4 != 0 ) 
            then 
            --DBMS_OUTPUT.PUT_LINE('mauvais départ');
            l_erreur := 'invalide'; exit;
            else
                
                if ( position1 = 0 )
                then 
                    
                    if ( position2 != 0 )
                    then 
                    --DBMS_OUTPUT.PUT_LINE('why * without _');
                    l_erreur := 'invalide'; exit;
                    else
                        
                            is_code_valid := false;
                            FOR i IN 1 .. tab_typ_princ.count LOOP
                                if ( l_groupe = rtrim(ltrim(tab_typ_princ(i))) )
                                then is_code_valid := true;
                                end if;
                            end loop;
                            if ( is_code_valid = false)
							--KRA PPM 60709 : QCs 1768,1769,1770
                            then l_erreur := l_groupe; 
                            --DBMS_OUTPUT.PUT_LINE('Principale invalid _ P seulement');
                            exit;
                            end if;
                      
                    end if;  
                else
                    if ( position2 = 0 )
                    then
                        
                            is_code_valid := false;
                            FOR i IN 1 .. tab_typ_princ.count LOOP
                                if ( avant_tiret = rtrim(ltrim(tab_typ_princ(i))) )
                                then is_code_valid := true;
                                end if;
                            end loop;
                            if ( is_code_valid = false )
							--KRA PPM 60709 : QCs 1768,1769,1770
                            then l_erreur := l_groupe; 
                            --DBMS_OUTPUT.PUT_LINE('Principale invalid _ P et S sans étoile');
                            exit;
                            else
                                
                                if ( apres_tiret is null)  
                                then 
                                --DBMS_OUTPUT.PUT_LINE('tiret final');
                                l_erreur := 'invalide'; exit;
                                else
                                    
                                    is_code_valid := false;
                                    FOR i IN 1 .. tab_typ_sec.count LOOP
                                        
                                        if ( apres_tiret = rtrim(ltrim(tab_typ_sec(i))) )
                                        then is_code_valid := true;
                                        end if;
                                    end loop;
                                    if ( is_code_valid = false )
									--KRA PPM 60709 : QCs 1768,1769,1770
									then l_erreur := l_groupe;  
                                    --DBMS_OUTPUT.PUT_LINE('Secondaire invalid _ sans étoile');
                                    exit;
                                    end if;
                                end if;
                            
                        end if;
                    else    
                            if ( position2 = position1 +1) 
                            then 
                            --DBMS_OUTPUT.PUT_LINE('_*');
                            l_erreur := 'invalide'; exit;
                            else
                                
                                if ( position1 > position2) 
                                then 
                                --DBMS_OUTPUT.PUT_LINE('*_');
                                l_erreur := 'invalide'; exit;
                                else 
                                    
                                    if ( apres_etoile is not null) 
                                    then 
                                    --DBMS_OUTPUT.PUT_LINE('*blabla');
                                    l_erreur := 'invalide'; exit;
                                    else
                                        
                                            is_code_valid := false;
                                            FOR i IN 1 .. tab_typ_princ.count LOOP
                                              if ( avant_tiret = rtrim(ltrim(tab_typ_princ(i))) )
                                              then is_code_valid := true;
                                              end if;
                                            end loop;
                                            if ( is_code_valid = false)
											--KRA PPM 60709 : QCs 1768,1769,1770
											then l_erreur := l_groupe; 
                                            --DBMS_OUTPUT.PUT_LINE('Principale invalid _ P et S ac étoile');
                                            exit;
										--KRA PPM 60709 : QCs 1768,1769,1770
                                          /*  else
                                                
                                                is_code_valid := false;
                                                FOR i IN 1 .. tab_typ_sec.count LOOP
                                                  if ( tiret_etoile = rtrim(ltrim(tab_typ_sec(i))))
                                                  then is_code_valid := true;
                                                  end if;
                                                end loop;
                                                if ( is_code_valid = false )
                                                then l_erreur := 'type_invalide'; 
                                                --DBMS_OUTPUT.PUT_LINE('Secondaire invalid _ P et S ac étoile');
                                                exit;
                                                end if;
												*/
                                            end if;
                                        
                                    end if;
                                end if;
                            end if;
                    end if;
                end if;
            end if;
          end if;
		-- Début KRA PPM 60709 : QCs 1768,1769,1770
          IF( INSTR(l_groupe,'_')>1 AND INSTR(l_groupe,'*')>1 ) 
                                                THEN 
                                                   BEGIN
                                                        SELECT COUNT(*) INTO nbre
                                                        FROM	type_activite ta,
                                                          type_projet tp,
                                                          lien_types_proj_act lpa
                                                        WHERE	lpa.type_proj = tp.typproj
                                                        AND	lpa.type_act = ta.arctype
                                                        AND	ta.actif='O' 
                                                        AND trim(ta.arctype) like replace(substr(l_groupe,instr(l_groupe,'_')+1),'*','%')
                                                        AND trim(tp.typproj) = substr(l_groupe,1,instr(l_groupe,'_')-1);
                                                          if nbre = 0 then
                                                            l_erreur := l_groupe;
                                                          end if;
                                                        END;
                                                  ELSE IF ( INSTR(l_groupe,'_')>1 )  THEN 
      
                                                     BEGIN
                                                          SELECT COUNT(*) INTO nbre
                                                          FROM	type_activite ta,
                                                            type_projet tp,
                                                            lien_types_proj_act lpa
                                                          WHERE	lpa.type_proj = tp.typproj
                                                          AND	lpa.type_act = ta.arctype
                                                          AND	ta.actif='O'
                                                          AND trim(ta.arctype) = substr(l_groupe,instr(l_groupe,'_')+1)

                                                          AND trim(tp.typproj) = substr(l_groupe,1,instr(l_groupe,'_')-1);
                                                            if nbre = 0 then
                                                              l_erreur := l_groupe;
                                                            end if;
                                                          END;
                                                          END IF;
                                                  END IF;
		-- Fin KRA PPM 60709 : QCs 1768,1769,1770
          end loop;
      end if;
   end if;
   end if;

  
  -- DBMS_OUTPUT.PUT_LINE(l_erreur);
   return l_erreur;
   end controlTypeLigne;
   
   
  --PPM 60709 : HMI 
  --KRA PPM 60709 : QCs 1768,1769,1770
   PROCEDURE type_ligne_verif (
        p_type_ligne IN type_etape.typeligne%TYPE, 
        p_message OUT message.limsg%TYPE
        ) 
        IS
          l_msg            VARCHAR2 (32767);
		  l_retour    VARCHAR2(300);
        
  BEGIN
      p_message := '';
      l_retour := controlTypeLigne(p_type_ligne);
        IF (l_retour = 'invalide') THEN
            pack_global.recuperer_message (21292, NULL, NULL, NULL, l_msg);
            p_message := l_msg;
        ELSE IF (NVL(l_retour,' ') != 'valide') THEN

            pack_global.recuperer_message (21293, '%s1', l_retour, NULL, l_msg);
            p_message := l_msg;
            END IF;
        END IF;
       
    END type_ligne_verif;
   
      


   PROCEDURE insert_type_etape (
      p_typetap     IN       type_etape.typetap%TYPE,
      p_libtyet     IN       type_etape.libtyet%TYPE,
      p_top_immo    IN       type_etape.top_immo%TYPE,
      p_chaine      IN       VARCHAR2,
      p_userid      IN       VARCHAR2,
      p_type_ligne  IN       type_etape.typeligne%TYPE,
      p_nbcurseur   OUT      INTEGER,
      p_message     OUT      message.limsg%TYPE

   )
   IS
      l_msg            VARCHAR2 (32767);
      l_count          NUMBER;
      l_user           VARCHAR2 (32767);
      l_chaine         VARCHAR2 (1000);
      l_separateur1    CHAR (1);
      l_separateur2    CHAR (1);
      pos1             NUMBER (4);
      pos2             NUMBER (4);
      l_jeu_chaine     VARCHAR (1000);
      l_jeu            VARCHAR (50);
      l_chronologie    VARCHAR2 (50);
      chrono_doublon   EXCEPTION;
      l_presence       NUMBER;
      l_erreur         VARCHAR2 (50);
      
 BEGIN
      p_nbcurseur := 0;
      p_message := '';
      l_chaine := p_chaine;
      l_separateur1 := '@';
      l_separateur2 := '+';
      l_count := 0;
      l_user := SUBSTR (pack_global.lire_globaldata (p_userid).idarpege, 1, 30);
      l_erreur := '';

      BEGIN
         WHILE LENGTH (l_chaine) <> 0
         LOOP
            pos1 := INSTR (l_chaine, l_separateur2, 1, 1);
            l_jeu_chaine := SUBSTR (l_chaine, 1, pos1 - 1);
            l_chaine := SUBSTR (l_chaine, pos1 + 1);
            pos2 := INSTR (l_jeu_chaine, l_separateur1, 1, 1);
            l_jeu := SUBSTR (l_jeu_chaine, 1, pos2 - 1);
            l_chronologie := SUBSTR (l_jeu_chaine, pos2 + 1, LENGTH (l_jeu_chaine));

            -- test si la chronologie est utilisé par un autre code type etape pour ce jeu
            SELECT COUNT (*)
              INTO l_presence
              FROM type_etape
             WHERE jeu = l_jeu AND chronologie = l_chronologie AND typetap != p_typetap;

            IF (l_presence > 0)
            THEN
               RAISE chrono_doublon;
            ELSE
               IF (l_chronologie <> 0)
               THEN
                  INSERT INTO type_etape
                              (jeu, typetap, libtyet, top_immo, chronologie, typeligne
                              )
                       VALUES (l_jeu, UPPER (p_typetap), p_libtyet, p_top_immo, l_chronologie, p_type_ligne
                              );

                  maj_type_etape_logs (p_typetap, l_jeu, l_user, 'TOP_IMMO', NULL, p_top_immo, 'Association code type d''étape avec Jeu créée');
                  maj_type_etape_logs (p_typetap,
                                       l_jeu,
                                       l_user,
                                       'CHRONOLOGIE',
                                       NULL,
                                       TO_CHAR (l_chronologie),
                                       'Association code type d''étape avec Jeu créée'
                                      );

                  maj_type_etape_logs (p_typetap, l_jeu, l_user, 'TYPELIGNE', NULL, p_type_ligne, 'Association code type d''étape avec typologie de ligne créée');

               END IF;
            END IF;

            l_count := l_count + 1;
         END LOOP;

         pack_global.recuperer_message (21237, NULL, NULL, NULL, l_msg);
         p_message := l_msg;
      EXCEPTION
         WHEN chrono_doublon
         THEN
            ROLLBACK;
            pack_global.recuperer_message (21230, '%s1', l_jeu, '%s2', l_chronologie, 'chrono' || l_count, l_msg);
            raise_application_error (-20999, l_msg);
         WHEN DUP_VAL_ON_INDEX
         THEN
            pack_global.recuperer_message (21059, NULL, NULL, NULL, l_msg);
            raise_application_error (-20001, l_msg);
      END;
   END insert_type_etape;

   PROCEDURE update_type_etape (
      p_typetap     IN       type_etape.typetap%TYPE,
      p_libtyet     IN       type_etape.libtyet%TYPE,
      p_top_immo    IN       type_etape.top_immo%TYPE,
      p_flaglock    IN       type_etape.flaglock%TYPE,
      p_type_ligne  IN       type_etape.typeligne%TYPE,
      p_chaine      IN       VARCHAR2,
      p_userid      IN       VARCHAR2,
      p_nbcurseur   OUT      INTEGER,
      p_message     OUT      VARCHAR2
   )
   IS
      l_msg                 VARCHAR2 (1024);
      l_count               NUMBER;
      l_chaine              VARCHAR2 (1000);
      l_separateur1         CHAR (1);
      l_separateur2         CHAR (1);
      pos1                  NUMBER (4);
      pos2                  NUMBER (4);
      l_jeu_chaine          VARCHAR (1000);
      l_jeu                 VARCHAR (50);
      l_chronologie         VARCHAR2 (50);
      l_presence            NUMBER;
      chrono_doublon        EXCEPTION;
      acces_concurrent      EXCEPTION;
      parametrage           EXCEPTION;
      non_present           EXCEPTION;
      association_utilise   EXCEPTION;
      l_flaglock            NUMBER (4);
      l_user                VARCHAR2 (30);
      old_jeu               type_etape.jeu%TYPE;
      old_top_immo          type_etape.top_immo%TYPE;
      old_chronologie       type_etape.chronologie%TYPE;
      old_typeligne         type_etape.typeligne%TYPE;
      l_erreur         VARCHAR2 (50);

   BEGIN
      p_nbcurseur := 0;
      p_message := '';
      l_chaine := p_chaine;
      l_separateur1 := '@';
      l_separateur2 := '+';
      l_count := 0;
      l_user := SUBSTR (pack_global.lire_globaldata (p_userid).idarpege, 1, 30);
      l_erreur := '';
      BEGIN
         IF NOT controle_parametrage
         THEN
            RAISE parametrage;
         END IF;

         SELECT MAX (flaglock)
           INTO l_flaglock
           FROM type_etape
          WHERE typetap = p_typetap;

         -- test accès concurrent
         IF (l_flaglock = p_flaglock)
         THEN
            WHILE LENGTH (l_chaine) <> 0
            LOOP
               pos1 := INSTR (l_chaine, l_separateur2, 1, 1);
               l_jeu_chaine := SUBSTR (l_chaine, 1, pos1 - 1);
               l_chaine := SUBSTR (l_chaine, pos1 + 1);
               pos2 := INSTR (l_jeu_chaine, l_separateur1, 1, 1);
               l_jeu := SUBSTR (l_jeu_chaine, 1, pos2 - 1);
               l_chronologie := SUBSTR (l_jeu_chaine, pos2 + 1, LENGTH (l_jeu_chaine));

               -- test si la chronologie est utilisé par un autre code type etape pour ce jeu
               SELECT COUNT (*)
                 INTO l_presence
                 FROM type_etape
                WHERE jeu = l_jeu AND chronologie = l_chronologie AND typetap != p_typetap;

               IF (l_presence > 0)
               THEN
                  RAISE chrono_doublon;
               ELSE
                  BEGIN
                     IF (l_chronologie = 0)
                     THEN
                        SELECT COUNT (*)
                          INTO l_presence
                          FROM isac_etape
                         WHERE typetape = p_typetap AND jeu = l_jeu;

                        IF (l_presence > 0)
                        THEN
                           RAISE association_utilise;
                        END IF;
                     END IF;

                     SELECT top_immo, chronologie, typeligne
                       INTO old_top_immo, old_chronologie, old_typeligne
                       FROM type_etape
                      WHERE jeu = l_jeu AND typetap = p_typetap;

                     UPDATE type_etape
                        SET libtyet = p_libtyet,
                            top_immo = p_top_immo,
                            chronologie = l_chronologie,
                            flaglock = p_flaglock + 1,
                            typeligne = p_type_ligne
                      WHERE jeu = l_jeu AND typetap = p_typetap;

                     -- on logue uniquement si la chronologie est différent de zero
                     IF (l_chronologie != 0)
                     THEN
                        maj_type_etape_logs (p_typetap,
                                             l_jeu,
                                             l_user,
                                             'TOP_IMMO',
                                             old_top_immo,
                                             p_top_immo,
                                             'Association code type étape avec jeu modifiée'
                                            );
                        maj_type_etape_logs (p_typetap,
                                             l_jeu,
                                             l_user,
                                             'CHRONOLOGIE',
                                             TO_CHAR (old_chronologie),
                                             TO_CHAR (l_chronologie),
                                             'Association code type étape avec jeu modifiée'
                                            );
                        maj_type_etape_logs (p_typetap,
                                             l_jeu,
                                             l_user,
                                             'TYPELIGNE',
                                             TO_CHAR (old_typeligne),
                                             TO_CHAR (p_type_ligne),
                                             'Association code type d''étape avec la typologie de ligne modifiée'
                                            );
                     ELSE
                        DELETE FROM type_etape
                              WHERE chronologie = 0;

                        IF (SQL%ROWCOUNT != 0)
                        THEN
                           maj_type_etape_logs (p_typetap, l_jeu, l_user, 'TOUTES', 'TOUTES', NULL, 'Association code type étape avec jeu supprimée');
                        END IF;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        -- on insère uniquement si le numero chronologie est différent zero
                        IF (l_chronologie != 0)
                        THEN
                           INSERT INTO type_etape
                                       (jeu, typetap, libtyet, top_immo, chronologie, flaglock, typeligne
                                       )
                                VALUES (l_jeu, p_typetap, p_libtyet, p_top_immo, l_chronologie, p_flaglock + 1, p_type_ligne
                                       );

                           maj_type_etape_logs (p_typetap, l_jeu, l_user, 'TOP_IMMO', NULL, p_top_immo, 'Association code type d''étape avec Jeu créée');
                           maj_type_etape_logs (p_typetap,
                                                l_jeu,
                                                l_user,
                                                'CHRONOLOGIE',
                                                NULL,
                                                TO_CHAR (l_chronologie),
                                                'Association code type d''étape avec Jeu créée'
                                               );
                            maj_type_etape_logs (p_typetap, l_jeu, l_user, 'TYPELIGNE', NULL, p_type_ligne, 'Association code type d''étape avec typologie de ligne créée');
                        END IF;
                  END;
               END IF;

               l_count := l_count + 1;
            END LOOP;
         ELSE
            RAISE acces_concurrent;
         END IF;

         pack_global.recuperer_message (21229, NULL, NULL, NULL, l_msg);
         p_message := l_msg;
      EXCEPTION
         WHEN parametrage
         THEN
            pack_global.recuperer_message (21231, NULL, NULL, NULL, l_msg);
            raise_application_error (-20999, l_msg);
         WHEN acces_concurrent
         THEN
            pack_global.recuperer_message (20999, NULL, NULL, NULL, l_msg);
            raise_application_error (-20999, l_msg);
         WHEN chrono_doublon
         THEN
            ROLLBACK;
            pack_global.recuperer_message (21230, '%s1', l_jeu, '%s2', l_chronologie, 'chrono' || l_count, l_msg);
            raise_application_error (-20999, l_msg);
         WHEN association_utilise
         THEN
            ROLLBACK;
            pack_global.recuperer_message (21238, '%s1', l_jeu, '%s2', p_typetap, 'chrono' || l_count, l_msg);
            raise_application_error (-20999, l_msg);
         WHEN OTHERS
         THEN
            raise_application_error (-20001, SQLERRM);
      END;
   END update_type_etape;

   PROCEDURE delete_type_etape (p_typetap IN type_etape.typetap%TYPE, p_userid IN VARCHAR2, p_nbcurseur OUT INTEGER, p_message OUT VARCHAR2)
   AS
      l_msg                   VARCHAR2 (1024);
      l_user                  VARCHAR2 (30);
      referential_integrity   EXCEPTION;
      l_count                 NUMBER;
   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';
      l_user := SUBSTR (pack_global.lire_globaldata (p_userid).idarpege, 1, 30);

      BEGIN
         SELECT COUNT (*)
           INTO l_count
           FROM etape
          WHERE typetap = p_typetap;

         IF (l_count > 0)
         THEN
            RAISE referential_integrity;
         END IF;

         SELECT COUNT (*)
           INTO l_count
           FROM isac_etape
          WHERE typetape = p_typetap;

         IF (l_count > 0)
         THEN
            RAISE referential_integrity;
         END IF;

         DELETE FROM type_etape
               WHERE typetap = p_typetap;

         maj_type_etape_logs (p_typetap, 'TOUS', l_user, 'TOUTES', 'TOUTES', NULL, 'Suppression du code type etape');
         pack_global.recuperer_message (21235, '%s1', p_typetap, NULL, l_msg);
         p_message := l_msg;
      EXCEPTION
         WHEN referential_integrity
         THEN
            pack_global.recuperer_message (21234, NULL, NULL, NULL, l_msg);
            raise_application_error (-20954, l_msg);
         WHEN OTHERS
         THEN
            raise_application_error (-21179, SQLERRM);
      END;
   END delete_type_etape;

   PROCEDURE select_type_etape (
      p_typetap         IN       type_etape.typetap%TYPE,
      p_userid          IN       VARCHAR2,
      p_curtype_etape   IN OUT   type_etape_curtype,
      p_curtype_jeu     IN OUT   jeu_curtype,
      p_nbcurseur       OUT      INTEGER,
      p_message         OUT      VARCHAR2
   )
   IS
      l_msg         VARCHAR2 (1024);
      l_count       NUMBER (2);
      parametrage   EXCEPTION;
   BEGIN
      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         IF NOT controle_parametrage
         THEN
            RAISE parametrage;
         END IF;

         SELECT COUNT (*)
           INTO l_count
           FROM type_etape
          WHERE typetap = p_typetap AND jeu IN (SELECT jeu
                                                  FROM type_etape_jeux);

         IF l_count = 0
         THEN
            pack_global.recuperer_message (21227, NULL, NULL, NULL, l_msg);
            p_message := l_msg;
         END IF;

         OPEN p_curtype_etape FOR
            SELECT DISTINCT typetap, libtyet, top_immo, flaglock, typeligne
                       FROM type_etape
                      WHERE typetap = UPPER (p_typetap) AND jeu IN (SELECT jeu
                                                                      FROM type_etape_jeux);

         OPEN p_curtype_jeu FOR
            SELECT   jeu, chronologie
                FROM (SELECT tej.jeu jeu, te.typetap typetap, te.libtyet libtyet, te.top_immo top_immo, te.chronologie chronologie,
                             te.flaglock flaglock, te.typeligne typeligne, tej.top_tri
                        FROM type_etape te, type_etape_jeux tej
                       WHERE tej.jeu = te.jeu
                      UNION
                      SELECT tej.jeu jeu, p_typetap typetap, NULL libtyet, NULL top_immo, 0 chronologie, 0 flaglock, NULL typeligne, tej.top_tri
                        FROM type_etape_jeux tej
                       WHERE tej.jeu NOT IN (SELECT jeu
                                               FROM type_etape
                                              WHERE typetap = p_typetap))
               WHERE typetap = p_typetap
            ORDER BY top_tri;
      EXCEPTION
         WHEN parametrage
         THEN
            pack_global.recuperer_message (21231, NULL, NULL, NULL, l_msg);
            raise_application_error (-20999, l_msg);
         WHEN NO_DATA_FOUND
         THEN
            pack_global.recuperer_message (21227, NULL, NULL, NULL, l_msg);
            p_message := l_msg;
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;
   END select_type_etape;

   PROCEDURE init_type_etape_jeu (
      p_typetap         IN       type_etape.typetap%TYPE,
      p_userid          IN       VARCHAR2,
      p_curtype_etape   IN OUT   type_etape_curtype,
      p_curtype_jeu     IN OUT   jeu_curtype,
      p_nbcurseur       OUT      INTEGER,
      p_message         OUT      VARCHAR2
   )
   AS
      l_msg         VARCHAR2 (1024);
      l_count       NUMBER (2);
      parametrage   EXCEPTION;
   BEGIN
      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         IF NOT controle_parametrage
         THEN
            RAISE parametrage;
         END IF;

         OPEN p_curtype_etape FOR
            SELECT typetap, libtyet, top_immo, flaglock, typeligne
              FROM type_etape
             WHERE typetap = p_typetap AND jeu IN (SELECT jeu
                                                     FROM type_etape_jeux);

         pack_global.recuperer_message (21228, NULL, NULL, NULL, l_msg);
         p_message := l_msg;

         OPEN p_curtype_jeu FOR
            SELECT   jeu, '0'
                FROM type_etape_jeux
            ORDER BY top_tri;
      EXCEPTION
         WHEN parametrage
         THEN
            pack_global.recuperer_message (21231, NULL, NULL, NULL, l_msg);
            raise_application_error (-20999, l_msg);
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;
   END init_type_etape_jeu;

   FUNCTION controle_parametrage
      RETURN BOOLEAN
   IS
      l_presence   NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO l_presence
           FROM type_etape_jeux;

         IF (l_presence != 0)
         THEN
            RETURN TRUE;
         ELSE
            RETURN FALSE;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            RETURN FALSE;
      END;
   END controle_parametrage;

   PROCEDURE maj_type_etape_logs (
      p_typetap       IN   type_etape_logs.typetap%TYPE,
      p_jeu           IN   type_etape_logs.jeu%TYPE,
      p_user_log      IN   type_etape_logs.user_log%TYPE,
      p_colonne       IN   type_etape_logs.colonne%TYPE,
      p_valeur_prec   IN   type_etape_logs.valeur_prec%TYPE,
      p_valeur_nouv   IN   type_etape_logs.valeur_nouv%TYPE,
      p_commentaire   IN   type_etape_logs.commentaire%TYPE
   )
   IS
   BEGIN
      IF (UPPER (LTRIM (RTRIM (NVL (p_valeur_prec, 'NULL')))) <> UPPER (LTRIM (RTRIM (NVL (p_valeur_nouv, 'NULL')))))
      THEN
         INSERT INTO type_etape_logs
                     (typetap, jeu, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire
                     )
              VALUES (p_typetap, p_jeu, SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire
                     );
      END IF;
   -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne
   END maj_type_etape_logs;

   PROCEDURE verif_type_etape (p_jeu IN VARCHAR2, p_message OUT VARCHAR2)
   IS
      l_nombre   NUMBER (3);
      l_msg      VARCHAR2 (100);
   BEGIN
      IF (p_jeu != '*')
      THEN
         BEGIN
            SELECT DISTINCT 1
                       INTO l_nombre
                       FROM type_etape
                      WHERE jeu LIKE p_jeu || '%';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               pack_global.recuperer_message (21239, NULL, NULL, NULL, l_msg);
               p_message := l_msg;
               raise_application_error (-20999, l_msg);
         END;
      END IF;
   END verif_type_etape;
END pack_type_etape;
/





