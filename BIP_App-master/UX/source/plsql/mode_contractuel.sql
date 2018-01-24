-- PACK_MODE_CONTRACTUEL PL/SQL

-- Cree le le 29/06/2010 par YNI Fiche 970
-- Modifiée le 18/07/2010 par YNI Fiche 970
-- 24/09/2010 YSB FDT 970
-- Modifiée le 08/10/2010 par ABA Fiche 970

CREATE OR REPLACE PACKAGE PACK_MODE_CONTRACTUEL AS

   -- Définition curseur sur la table DATE_EFFET
   TYPE Mode_Contractuel_ViewType IS RECORD ( codcontractuel    MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                              commentaire       MODE_CONTRACTUEL.COMMENTAIRE%type,
                                              libelle           MODE_CONTRACTUEL.LIBELLE%type,
                                              typressource      MODE_CONTRACTUEL.TYPE_RESSOURCE%type,
                                              codlocalisation   MODE_CONTRACTUEL.CODE_LOCALISATION%type,
                                              topactif          MODE_CONTRACTUEL.TOP_ACTIF%type                                          
                                              );

   TYPE Mode_Contractuel_CurType_Char IS REF CURSOR RETURN Mode_Contractuel_ViewType;


   PROCEDURE insert_Mode_Contractuel ( p_codcontractuel    IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                       p_commentaire       IN MODE_CONTRACTUEL.COMMENTAIRE%type,
                                       p_libelle           IN MODE_CONTRACTUEL.LIBELLE%type,
                                       p_typressource      IN MODE_CONTRACTUEL.TYPE_RESSOURCE%type,
                                       p_codlocalisation   IN MODE_CONTRACTUEL.CODE_LOCALISATION%type,
                                       p_topactif          IN MODE_CONTRACTUEL.TOP_ACTIF%type,        
                                       p_userid     	     IN VARCHAR2,
                                       p_nbcurseur         OUT INTEGER,
                                       p_message           OUT VARCHAR2
                                      );

     PROCEDURE update_Mode_Contractuel ( p_codcontractuel    IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                         p_commentaire       IN MODE_CONTRACTUEL.COMMENTAIRE%type,
                                         p_libelle           IN MODE_CONTRACTUEL.LIBELLE%type,
                                         p_typressource      IN MODE_CONTRACTUEL.TYPE_RESSOURCE%type,
                                         p_codlocalisation   IN MODE_CONTRACTUEL.CODE_LOCALISATION%type,
                                         p_topactif          IN MODE_CONTRACTUEL.TOP_ACTIF%type,
                                         p_userid     	      IN VARCHAR2,
                                         p_nbcurseur         OUT INTEGER,
                                         p_message           OUT VARCHAR2
                                         );

	 PROCEDURE delete_Mode_Contractuel (p_codcontractuel    IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                      p_userid            IN  VARCHAR2,
                                      p_nbcurseur         OUT INTEGER,
                                      p_message           OUT VARCHAR2
                                      );

	 PROCEDURE select_Mode_Contractuel (p_codcontractuel    IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                      p_userid     	        IN  VARCHAR2,
                                      p_curContractuel     IN OUT Mode_Contractuel_CurType_Char ,
                                      p_nbcurseur           OUT INTEGER,
                                      p_message             OUT VARCHAR2
                                      );
   
   PROCEDURE maj_mode_contractuel_logs (p_codcontractuel  IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                        p_user_log        IN VARCHAR2,
                                        p_colonne          IN VARCHAR2,
                                        p_valeur_prec     IN VARCHAR2,
                                        p_valeur_nouv     IN VARCHAR2,
                                        p_commentaire     IN VARCHAR2
                                        );
     
   PROCEDURE select_Lib_Contractuel (p_modeContractuel      IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                    p_ident IN VARCHAR2,
                                    p_soccont IN VARCHAR2,
                                    p_numcont IN VARCHAR2,
                                    p_cav IN VARCHAR2,   
                                    p_libModeContractuel    OUT MODE_CONTRACTUEL.LIBELLE%type,
                                    p_message               OUT VARCHAR2
                                    );

  FUNCTION select_code_Contr_valid (p_modeContractuel IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                    p_ident IN VARCHAR2,
                                    p_soccont IN VARCHAR2,
                                    p_numcont IN VARCHAR2, 
                                    p_cav IN VARCHAR2 ) RETURN NUMBER; 
                                    
  FUNCTION select_mode_contr_comp(p_ident IN VARCHAR2,
                                  p_soccont IN VARCHAR2,
                                  p_lresdeb IN DATE,
                                  p_lresfin IN DATE,
                                  p_numcont IN VARCHAR2, 
                                  p_cav IN VARCHAR2) RETURN NUMBER;
                                  
END PACK_MODE_CONTRACTUEL;
/


CREATE OR REPLACE PACKAGE BODY "PACK_MODE_CONTRACTUEL" AS

  PROCEDURE insert_Mode_Contractuel (  p_codcontractuel    IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                       p_commentaire       IN MODE_CONTRACTUEL.COMMENTAIRE%type,
                                       p_libelle           IN MODE_CONTRACTUEL.LIBELLE%type,
                                       p_typressource      IN MODE_CONTRACTUEL.TYPE_RESSOURCE%type,
                                       p_codlocalisation   IN MODE_CONTRACTUEL.CODE_LOCALISATION%type,
                                       p_topactif          IN MODE_CONTRACTUEL.TOP_ACTIF%type,        
                                       p_userid     	     IN VARCHAR2,
                                       p_nbcurseur         OUT INTEGER,
                                       p_message           OUT VARCHAR2
                                      ) AS
  l_msg VARCHAR2(1024);
  l_count NUMBER;
  l_user VARCHAR2(30);

  BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';


      -- Verification d'existence du code ressource 
      SELECT COUNT(*)  INTO l_count  FROM TYPE_RESS  WHERE rtype = p_typressource;
      IF(l_count = 0)THEN
            Pack_Global.recuperer_message(21194, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20958, l_msg );
      END if;
      
      
      -- Verification d'existence du code localisation
      SELECT COUNT(*)  INTO l_count  FROM LOCALISATION  WHERE code_localisation = p_codlocalisation;
      IF(l_count = 0)THEN
            Pack_Global.recuperer_message(21195, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20958, l_msg );
      END if;
      
      
      
      -- Verification d'existence du mode contractuel
      SELECT COUNT(*)  INTO l_count  FROM MODE_CONTRACTUEL  WHERE code_contractuel = p_codcontractuel;
      
      IF(l_count <> 0)THEN
    
            Pack_Global.recuperer_message(21189, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20958, l_msg );
    
      ELSE
  


      BEGIN
             INSERT INTO MODE_CONTRACTUEL ( code_contractuel,
                                            commentaire,
                                            libelle,
                                            type_ressource,
                                            code_localisation,
                                            top_actif)
                   VALUES ( UPPER(p_codcontractuel),
                            p_commentaire,
                            p_libelle,
                            p_typressource,
                            p_codlocalisation,
                            p_topactif);
                            
          -- Insertions des logs en table de APPLICATION_LOGS
          l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);
          --maj_mode_contractuel_logs(p_codcontractuel, l_user, 'code_contractuel', '', p_codcontractuel, 'Création du code contractuel');
          --maj_mode_contractuel_logs(p_codcontractuel, l_user, 'commentaire', '', p_commentaire, 'Création du commentaire');
          --maj_mode_contractuel_logs(p_codcontractuel, l_user, 'libelle', '', p_libelle, 'Création du libelle');
          maj_mode_contractuel_logs(p_codcontractuel, l_user, 'type_ressource', '', p_typressource, 'Création du type ressource');
          maj_mode_contractuel_logs(p_codcontractuel, l_user, 'code_localisation', '', p_codlocalisation, 'Création du code localisation');
          maj_mode_contractuel_logs(p_codcontractuel, l_user, 'top_actif', '', p_topactif, 'Création du top actif');
      
          Pack_Global.recuperer_message( 21190, NULL, NULL, NULL, l_msg);
          p_message := l_msg;
    
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               Pack_Global.recuperer_message( 21059, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20001, l_msg );
    
         END;

	 END IF;
  END insert_Mode_Contractuel;

  PROCEDURE update_Mode_Contractuel (  p_codcontractuel    IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                       p_commentaire       IN MODE_CONTRACTUEL.COMMENTAIRE%type,
                                       p_libelle           IN MODE_CONTRACTUEL.LIBELLE%type,
                                       p_typressource      IN MODE_CONTRACTUEL.TYPE_RESSOURCE%type,
                                       p_codlocalisation   IN MODE_CONTRACTUEL.CODE_LOCALISATION%type,
                                       p_topactif          IN MODE_CONTRACTUEL.TOP_ACTIF%type,
                                       p_userid     	      IN VARCHAR2,
                                       p_nbcurseur         OUT INTEGER,
                                       p_message           OUT VARCHAR2
                                       ) AS
  l_msg VARCHAR2(1024);
  l_count NUMBER;
  l_user VARCHAR2(30);
  l_code_contractuel MODE_CONTRACTUEL.CODE_CONTRACTUEL%type;
  l_commentaire MODE_CONTRACTUEL.COMMENTAIRE%type;
  l_libelle MODE_CONTRACTUEL.LIBELLE%type;
  l_type_ressource MODE_CONTRACTUEL.TYPE_RESSOURCE%type;
  l_code_localisation MODE_CONTRACTUEL.CODE_LOCALISATION%type;
  l_top_actif MODE_CONTRACTUEL.TOP_ACTIF%type;

  BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';


      -- Verification d'existence du code ressource 
      SELECT COUNT(*)  INTO l_count  FROM TYPE_RESS  WHERE rtype = p_typressource;
      IF(l_count = 0)THEN
            Pack_Global.recuperer_message(21194, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20958, l_msg );
      END if;
      
      
      -- Verification d'existence du code localisation
      SELECT COUNT(*)  INTO l_count  FROM LOCALISATION  WHERE code_localisation = p_codlocalisation;
      IF(l_count = 0)THEN
            Pack_Global.recuperer_message(21195, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20958, l_msg );
      END if;
      
      
      BEGIN
            -- Récupération des anciennes valeurs avant le update
            SELECT
                code_contractuel,
                commentaire,
                libelle,
                type_ressource,
                code_localisation,
                top_actif
            INTO
                l_code_contractuel,
                l_commentaire,
                l_libelle,
                l_type_ressource,
                l_code_localisation,
                l_top_actif
            FROM MODE_CONTRACTUEL
            WHERE code_contractuel = p_codcontractuel;
            
    
            UPDATE MODE_CONTRACTUEL
            SET	 --code_contractuel = p_codcontractuel,
                 commentaire = p_commentaire,
                 libelle = p_libelle,
                 type_ressource = p_typressource,
                 code_localisation = p_codlocalisation,
                 top_actif = p_topactif
            WHERE code_contractuel = p_codcontractuel;
            
          -- Insertions des logs en table de APPLICATION_LOGS
          l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);
          --maj_mode_contractuel_logs(p_codcontractuel, l_user, 'code_contractuel', l_code_contractuel, p_codcontractuel, 'Modification du code contractuel');
          --maj_mode_contractuel_logs(p_codcontractuel, l_user, 'commentaire', l_commentaire, p_commentaire, 'Modification du commentaire');
          --maj_mode_contractuel_logs(p_codcontractuel, l_user, 'libelle', l_libelle, p_libelle, 'Modification du libelle');
          maj_mode_contractuel_logs(p_codcontractuel, l_user, 'type_ressource', l_type_ressource, p_typressource, 'Modification du type ressource');
          maj_mode_contractuel_logs(p_codcontractuel, l_user, 'code_localisation', l_code_localisation, p_codlocalisation, 'Modification du code localisation');
          maj_mode_contractuel_logs(p_codcontractuel, l_user, 'top_actif', l_top_actif, p_topactif, 'Modification du top actif');
    
      EXCEPTION
    
         WHEN OTHERS THEN
               Pack_Global.recuperer_message( 21191, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20999, l_msg );
      END;
    
    
          IF SQL%NOTFOUND THEN
    
          -- 'Accès concurrent'
    
             Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20999, l_msg );
    
          ELSE
    
    
         -- 'La date effet a été modifiée'
    
               Pack_Global.recuperer_message( 21192, NULL, NULL, NULL, l_msg);
               p_message := l_msg;
          END IF;
    
  END update_Mode_Contractuel;

  PROCEDURE delete_Mode_Contractuel ( p_codcontractuel    IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                      p_userid            IN  VARCHAR2,
                                      p_nbcurseur         OUT INTEGER,
                                      p_message           OUT VARCHAR2
                                      ) AS
    l_msg VARCHAR2(1024);
    l_user VARCHAR2(30);
    referential_integrity EXCEPTION;
	  l_count NUMBER;
    PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

    BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

     BEGIN
	   DELETE FROM MODE_CONTRACTUEL WHERE code_contractuel = p_codcontractuel;
     
     -- Insertions des logs en table de APPLICATION_LOGS
     l_user := SUBSTR(pack_global.lire_globaldata(p_userid).idarpege, 1, 30);
     maj_mode_contractuel_logs(p_codcontractuel, l_user, 'Tous', '', '', 'Suppression du code contractuel');
          

     EXCEPTION
		 WHEN referential_integrity THEN
		         Pack_Global.recuperer_message( 21179, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20954, l_msg );

		 WHEN OTHERS THEN
				    RAISE_APPLICATION_ERROR( -21179, SQLERRM);
		 END;

     IF SQL%NOTFOUND THEN
	   -- 'Accès concurrent'
	    Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
      RAISE_APPLICATION_ERROR( -20999, l_msg );

      ELSE

	     Pack_Global.recuperer_message( 21193, NULL, NULL, NULL, l_msg);
	     p_message := l_msg;

      END IF;

  END delete_Mode_Contractuel;

  PROCEDURE select_Mode_Contractuel ( p_codcontractuel     IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                      p_userid     	       IN  VARCHAR2,
                                      p_curContractuel     IN OUT Mode_Contractuel_CurType_Char ,
                                      p_nbcurseur          OUT INTEGER,
                                      p_message            OUT VARCHAR2
                                      ) AS

  l_msg VARCHAR2(1024);

   BEGIN

        -- Positionner le nb de curseurs ==> 0
        -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         OPEN  p_curContractuel FOR
              SELECT 	code_contractuel,
                      commentaire,
                      libelle,
                      type_ressource,
                      code_localisation,
                      top_actif
              FROM  MODE_CONTRACTUEL
              WHERE p_codcontractuel = code_contractuel ;


          Pack_Global.recuperer_message( 21191, NULL, NULL, NULL, l_msg);
          p_message := l_msg;

      EXCEPTION

        WHEN OTHERS THEN

		  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;
 
  END select_Mode_Contractuel;
  
  
  
  PROCEDURE select_Lib_Contractuel (p_modeContractuel       IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                    p_ident IN VARCHAR2,
                                    p_soccont IN VARCHAR2,
                                    p_numcont IN VARCHAR2, 
                                    p_cav IN VARCHAR2,                                    
                                    p_libModeContractuel    OUT MODE_CONTRACTUEL.LIBELLE%type,
                                    p_message               OUT VARCHAR2
                                    ) AS

  l_msg VARCHAR2(1024);
  l_rtype VARCHAR2(2); 
  l_ress_type VARCHAR2(2); 
  l_soccode VARCHAR2(10);  
  l_ctype_fact VARCHAR2(2);

   BEGIN

        -- Positionner le nb de curseurs ==> 0
        -- Initialiser le message retour

      p_message := '';
      
      
      BEGIN 
      
          select ctypfact into l_ctype_fact 
          from contrat 
          where soccont = p_soccont
          AND numcont = p_numcont
          AND cav = to_number(p_cav);
          
          select rtype into l_rtype 
          from ressource
          where ident = to_number(p_ident);
          
          select soccode into l_soccode 
          from situ_ress 
          where ident = to_number(p_ident)
          and rownum = 1
          order by datsitu desc;   
          
          SELECT 	type_ressource into l_ress_type
          FROM  MODE_CONTRACTUEL
          WHERE code_contractuel = p_modeContractuel;
          
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            null;
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;
          
          
          BEGIN
                SELECT 	libelle INTO p_libModeContractuel
                  FROM  MODE_CONTRACTUEL
                  WHERE code_contractuel = p_modeContractuel;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  Pack_Global.recuperer_message( 21191, NULL, NULL, NULL, l_msg);
                  p_message := l_msg;
                WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;
                    
          IF(l_ctype_fact = 'M' or l_ctype_fact = 'R') THEN
            IF(l_soccode <> 'SG..' and l_ress_type = 'P') THEN
              BEGIN
                SELECT 	libelle INTO p_libModeContractuel
                  FROM  MODE_CONTRACTUEL
                  WHERE code_contractuel = p_modeContractuel         
                  AND type_ressource = l_rtype
                  AND TOP_ACTIF = 'O';
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
                  p_message := l_msg;
                WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
              END;
            ELSE
              Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
              p_message := l_msg;
            END IF;
          ELSIF(l_ctype_fact = 'F') THEN
            IF((l_ress_type = 'E') or (l_ress_type = 'F') or (l_ress_type = 'L')) THEN
                BEGIN
                  SELECT 	libelle INTO p_libModeContractuel
                  FROM  MODE_CONTRACTUEL
                  WHERE code_contractuel = p_modeContractuel         
                  AND type_ressource = l_rtype
                  AND TOP_ACTIF = 'O';  
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
                    p_message := l_msg;
                  WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
                END;
            ELSE
              Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
              p_message := l_msg;  
            END IF;
          ELSE
            Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
            p_message := l_msg;  
          END IF;                          
 
  END select_Lib_Contractuel;
  
  -- function verifie si le code contractuel rentré en paramétre est :
  -- (autre que XXX ou ???) est ACTIF
  -- cohérent avec le Type de facturation du contrat et avec le Type de ressource de la ressource 
  
  FUNCTION select_code_Contr_valid (p_modeContractuel IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                    p_ident IN VARCHAR2,
                                    p_soccont IN VARCHAR2,
                                    p_numcont IN VARCHAR2, 
                                    p_cav IN VARCHAR2 ) RETURN NUMBER IS 
  
  l_msg VARCHAR2(1024);
  l_rtype VARCHAR2(2); 
  l_ress_type VARCHAR2(2); 
  l_soccode VARCHAR2(10);  
  l_ctype_fact VARCHAR2(2);
  nbr NUMBER;

   BEGIN
      
      BEGIN 
      
          select ctypfact into l_ctype_fact 
          from contrat 
          where soccont = p_soccont
          AND numcont = p_numcont
          AND cav = to_number(nvl(p_cav,0));
          
          select rtype into l_rtype 
          from ressource
          where ident = to_number(p_ident);
          
          select soccode into l_soccode 
          from situ_ress 
          where ident = to_number(p_ident)
          and rownum = 1
          order by datsitu desc;   
          
          SELECT 	type_ressource into l_ress_type
          FROM  MODE_CONTRACTUEL
          WHERE code_contractuel = p_modeContractuel;
          
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            null;
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;
          
                    
          IF(l_ctype_fact = 'M' or l_ctype_fact = 'R') THEN
            IF(l_soccode <> 'SG..' and l_ress_type = 'P') THEN
              BEGIN
                SELECT 	count(*) INTO nbr
                  FROM  MODE_CONTRACTUEL
                  WHERE code_contractuel = p_modeContractuel         
                  AND type_ressource = l_rtype
                  AND TOP_ACTIF = 'O';
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  null;
                WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
              END;
            END IF;
          ELSIF(l_ctype_fact = 'F') THEN
            IF((l_ress_type = 'E') or (l_ress_type = 'F') or (l_ress_type = 'L')) THEN
                BEGIN
                  SELECT 	count(*) INTO nbr
                  FROM  MODE_CONTRACTUEL
                  WHERE code_contractuel = p_modeContractuel         
                  AND type_ressource = l_rtype
                  AND TOP_ACTIF = 'O';  
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    null;
                  WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
                END;
            END IF;
          END IF;   
        
        IF(nbr >0) THEN
          return 1;
        ELSE
          return 0;
        END IF;
        
  END select_code_Contr_valid;
  
  
  --Function qui renvoie 1 si le mode contractuel de la dernière situation est compatible
  --avec la ligne de contrat en plus et fait appel à la function select_code_Contr_valid
  -- dans le cas contratire elle renvoie 0
  FUNCTION select_mode_contr_comp(p_ident IN VARCHAR2, 
                                  p_soccont IN VARCHAR2,
                                  p_lresdeb IN DATE,
                                  p_lresfin IN DATE,
                                  p_numcont IN VARCHAR2, 
                                  p_cav IN VARCHAR2) RETURN NUMBER IS 
        
      l_mode_contractuel VARCHAR2(20);
      l_compteur NUMBER;
      l_count NUMBER;
      l_valid NUMBER;
      l_datef DATE;
      l_datefstat DATE;
      l_datedeb DATE;
      l_datefin DATE;    
      l_rtype VARCHAR2(2); 
      l_ress_type VARCHAR2(2); 
      l_soccode VARCHAR2(10);  
      l_ctype_fact VARCHAR2(2);
      nbr NUMBER;
      
     CURSOR cur_situligne IS     
          
          SELECT datsitu, datdep FROM situ_ress
            where ident = to_number(p_ident) 
            and soccode = p_soccont
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and soccode = p_soccont and datsitu <= p_lresdeb) and p_lresfin)        
            order by datsitu asc;
                   
      BEGIN
        l_valid := 1;
        
        SELECT count(*) into l_count FROM situ_ress
            where ident = to_number(p_ident) 
            and soccode = p_soccont
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and soccode = p_soccont and datsitu <= p_lresdeb) and p_lresfin)        
            order by datsitu asc;
         
         IF(l_count = 0) THEN
          
          l_valid := 0; 
         
         ELSIF(l_count = 1) THEN
          
          SELECT datsitu, datdep into l_datedeb,l_datefin FROM situ_ress
            where ident = to_number(p_ident) 
            and soccode = p_soccont
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and soccode = p_soccont and datsitu <= p_lresdeb) and p_lresfin)        
            and rownum = 1
            order by datsitu asc;
          
          IF((l_datedeb > p_lresdeb) or ((l_datefin is not null) and (l_datefin < p_lresfin))) THEN  
            l_valid := 0; 
          END IF;
          
         ELSE
         
           l_datefstat := TO_DATE('01/01/1900','DD/MM/YYYY');
           l_datef := TO_DATE('01/01/1900','DD/MM/YYYY');   
           l_compteur := 0;     
           
           
           IF((p_lresdeb is null) and (p_lresfin is null)) THEN
            return '';
           END IF; 
           
             FOR one_situligne IN cur_situligne LOOP              
                l_compteur := l_compteur+1;
                l_datedeb := one_situligne.datsitu;
                l_datefin := one_situligne.datdep;
                  
                  IF((one_situligne.datdep is not null) and (one_situligne.datdep <= p_lresfin)) THEN                  
                      IF(l_datef != l_datefstat) THEN                         
                        IF(l_datef = one_situligne.datsitu) THEN                                                 
                            l_datef := one_situligne.datdep + 1;
                        ELSE
                          l_valid := 0; 
                          EXIT;
                        END IF;
                      ELSE                                                                            
                          l_datef := one_situligne.datdep + 1;                      
                      END IF;
                    ELSIF(one_situligne.datdep is null) THEN
                      IF(l_datef != l_datefstat) THEN
                        IF(l_datef != one_situligne.datsitu) THEN 
                          l_valid := 0;
                          EXIT;
                        END IF;
                      END IF;
                    END IF;                
             END LOOP;
                    
           IF(
              ((l_datefin is not null) and  (l_datefin < p_lresfin)) 
            or
              ((l_datefin is not null) and  (l_datefin > p_lresfin) and (l_datef != p_lresfin) and (l_datef != l_datedeb))
             ) THEN
              l_valid := 0;
           END IF;
         
         END IF;
  
        IF(l_valid = 1) THEN
        
          BEGIN                    
            IF(l_datefin is not null) THEN 
            SELECT mode_contractuel_indicatif into l_mode_contractuel FROM situ_ress 
              where datsitu =  l_datedeb 
              and datdep = l_datefin
              and soccode = p_soccont 
              and ident = p_ident;
            ELSE
            SELECT PRESTATION into l_mode_contractuel FROM situ_ress 
              where datsitu =  l_datedeb 
              and datdep is null
              and soccode = p_soccont 
              and ident = p_ident;
            END IF;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              null;
          END;                                     
       ELSE
         l_mode_contractuel := '0'; --ce mode contractuel n'existe pas
       END IF;
          
    return select_code_Contr_valid(l_mode_contractuel,p_ident,p_soccont,p_numcont,p_cav);
    
  END select_mode_contr_comp;
  
  --Procédure pour remplir les logs de MAJ du mode contractuel
  PROCEDURE maj_mode_contractuel_logs ( p_codcontractuel     IN MODE_CONTRACTUEL.CODE_CONTRACTUEL%type,
                                        p_user_log        IN VARCHAR2,
                                        p_colonne        IN VARCHAR2,
                                        p_valeur_prec    IN VARCHAR2,
                                        p_valeur_nouv    IN VARCHAR2,
                                        p_commentaire    IN VARCHAR2
                                        ) IS
  BEGIN
  
      IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
          INSERT INTO mode_contractuel_logs
              (code_contractuel, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
          VALUES
              (p_codcontractuel, SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);
  
      END IF;
      -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne
  
  END maj_mode_contractuel_logs;

END PACK_MODE_CONTRACTUEL;
/