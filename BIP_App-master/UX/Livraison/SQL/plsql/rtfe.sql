create or replace
PACKAGE     Pack_Rtfe AS




   -- ------------------------------------------------------------------------
   -- Nom        : estHabiliteMe
   -- Appel      : Appelé par la requette report
   -- Auteur     : BAA
   -- Decription : retourne OUI si bddpg_defaut et perim_me correspond bien à ses périmètres
   -- Paramètres : p_ident (IN) l'identifiant de la ressource
   -- 			   p_bddpg_defaut (IN) le bddpg par defaut de l'utilisateur
   --			   p_perim_me (IN) perimetre me
   -- Retour     : OUI ou NON
   -- ------------------------------------------------------------------------

   FUNCTION estHabiliteMe(p_ident IN VARCHAR2, p_bddpg_defaut IN VARCHAR2, p_perim_me IN VARCHAR2) RETURN VARCHAR2;



   -- ------------------------------------------------------------------------
   -- Nom        : bddpg_ress
   -- Auteur     : BAA
   -- Decription : retourne bddpg à partir des données de la bip
   -- Paramètres : p_ident (IN) l'identifiant de la ressource
   -- Retour     : bddpg sur 11 caracteres
   -- ------------------------------------------------------------------------

   FUNCTION bddpg_ress(p_ident IN VARCHAR2) RETURN VARCHAR2;



   -- ------------------------------------------------------------------------
   -- Nom        : tmp_saisie_realisee_seq
   -- Auteur     : BAA
   -- Decription : mise a jour de la table tmp_saisie_realisee
   --
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------
   FUNCTION tmp_saisie_realisee_seq RETURN NUMBER;

   TYPE rtfeCurType IS REF CURSOR RETURN RTFE%ROWTYPE;


	  -- ------------------------------------------------------------------------
   -- Nom        : select_rtfe_user
   -- Auteur     : CMA
   -- Decription : Récupération des infos RTFE dd'un utilisateur via son ident
   -- Utilisé lors du chargement du profil RTFE d'une ressource dans la session
   -- dans Administration->Boîte à outils->Charger profil
   --
   -- Retour     : La ligne de ses paramètres RTFE dans un curseur de type RTFE
   --
   -- ------------------------------------------------------------------------
   PROCEDURE select_rtfe_user (p_rtfeUser          IN  VARCHAR2,
                               p_currtfe  IN OUT rtfeCurType,
                               p_message          OUT VARCHAR2);
                               
  TYPE rtfeUsersCurType IS REF CURSOR;
    -- ------------------------------------------------------------------------
   -- Nom        : select_rtfe_users
   -- Auteur     : RBO
   -- Decription : Récupération des infos RTFE d'une liste d'utilisateurs via des identifiants RTFE
   -- Utilisé lors du chargement de profis Bip à partir d'une liste de ressources
   -- dans Administration->Boîte à outils->Profils liste ressources
   --
   -- Retour     : La ligne de ses paramètres RTFE dans un curseur de type RTFE
   --
   -- ------------------------------------------------------------------------
   PROCEDURE select_rtfe_users (p_rtfeUsers          IN  VARCHAR2,
                               p_currtfe  IN OUT rtfeUsersCurType,
                               p_message          OUT VARCHAR2);

-- Découpage de la chaine récupérée 
   FUNCTION split_varchar (p_string     IN  VARCHAR2,
                           p_occurence  IN  NUMBER
                          ) RETURN VARCHAR2;

TYPE rtfeUser IS RECORD (
                                 rtfeUser        VARCHAR2(60) ,
                                 libel        VARCHAR2(500)
                              );

TYPE rtfeUserCurType IS REF CURSOR RETURN rtfeUser;

	  -- ------------------------------------------------------------------------
   -- Nom        : find_rtfe_user
   -- Auteur     : CMA
   -- Decription : Recherche d'un user RTFE avec son identifiant ou son nom
   -- Utilisé lors de la recherche de profil RTFE en vue d'un chargement en session
   -- dans Administration->Boîte à outils->Charger profil
   --
   -- Retour     : Les users qui répondent au critère de recherche dans un curseur de type RTFE_USER
   --
   -- ------------------------------------------------------------------------
   PROCEDURE find_rtfe_user (p_ident          IN  VARCHAR2,
                             p_debnom         IN VARCHAR2,
                             p_nomcont        IN VARCHAR2,
                             p_currtfe        IN OUT rtfeUserCurType,
                             p_message        OUT VARCHAR2);


   -- ------------------------------------------------------------------------
   -- Nom        : find_rtfe_user
   -- Auteur     : CMA
   -- Decription :  Nombre de rtfe_users qui répondent aux critères de recherche
   -- Utilisé lors de la recherche de profil RTFE en vue d'un chargement en session
   -- dans Administration->Boîte à outils->Charger profil
   --
   -- Retour     : Le nombre de users qui répondent au critère de recherche
   --
   -- ------------------------------------------------------------------------
   PROCEDURE count_rtfe_user (p_ident         IN  VARCHAR2,
                             p_debnom         IN VARCHAR2,
                             p_nomcont        IN VARCHAR2,
                             p_count          IN OUT VARCHAR2,
                             p_message        OUT VARCHAR2);

    -- ------------------------------------------------------------------------
    -- Nom        : existe_bddpg
    -- Auteur     : CMA
    -- Decription :  Vérifie qu'un bddpg entré dans le profil RTFE de l'utilisateur
    -- existe bien dans la vue VUE_DPG_PERIME
    --
    -- Retour     : Un message d'erreur si le bddpg est inexistant, une chaîne vide
    -- le cas échéant
    --
    -- ------------------------------------------------------------------------
    PROCEDURE existe_bddpg (p_bddpg IN VARCHAR2,
                            p_message OUT VARCHAR2);

    -- ------------------------------------------------------------------------
    -- Nom        : existe_dpg
    -- Auteur     : CMA
    -- Decription :  Vérifie qu'un dpg entré dans le profil RTFE de l'utilisateur
    -- existe bien dans la vue VUE_DPG_PERIME
    --
    -- Retour     : Un message d'erreur si le dpg est inexistant, une chaîne vide
    -- le cas échéant
    --
    -- ------------------------------------------------------------------------
    PROCEDURE existe_dpg (p_dpg IN VARCHAR2,
                            p_message OUT VARCHAR2);

    -- ------------------------------------------------------------------------
    -- Nom        : existe_resbip
    -- Auteur     : CMA
    -- Decription :  Vérifie qu'un code ressource entré dans le profil RTFE de l'utilisateur
    -- existe bien dans la table ressource
    --
    -- Retour     : Un message d'erreur si la ressource est inexistante, une chaîne vide
    -- le cas échéant
    --
    -- ------------------------------------------------------------------------
    PROCEDURE existe_resbip (p_resbip IN VARCHAR2,
                            p_message OUT VARCHAR2);

    -- ------------------------------------------------------------------------
    -- Nom        : existe_clibip
    -- Auteur     : CMA
    -- Decription :  Vérifie qu'un code client réduit entré dans le profil RTFE de l'utilisateur
    -- existe bien dans la table client_mo
    --
    -- Retour     : Un message d'erreur si le code client réduit est inexistant, une chaîne vide
    -- le cas échéant
    --
    -- ------------------------------------------------------------------------
    PROCEDURE existe_clibip (p_clibip IN VARCHAR2,
                            p_message OUT VARCHAR2);

    -- ------------------------------------------------------------------------
    -- Nom        : existe_bdclibip
    -- Auteur     : CMA
    -- Decription :  Vérifie qu'un code client complet entré dans le profil RTFE de l'utilisateur
    -- existe bien dans la vue VUE_CLICODE_PERIMO
    --
    -- Retour     : Un message d'erreur si le code client complet est inexistant, une chaîne vide
    -- le cas échéant
    --
    -- ------------------------------------------------------------------------
    PROCEDURE existe_bdclibip (p_bdclibip IN VARCHAR2,
                            p_message OUT VARCHAR2);

    -- ------------------------------------------------------------------------
    -- Nom        : existe_cfbip
    -- Auteur     : CMA
    -- Decription :  Vérifie qu'un centre de frais entré dans le profil RTFE de l'utilisateur
    -- existe bien dans la table CENTRE_FRAIS
    --
    -- Retour     : Un message d'erreur si le centre de frais est inexistant, une chaîne vide
    -- le cas échéant
    --
    -- ------------------------------------------------------------------------
    PROCEDURE existe_cfbip (p_cfbip IN VARCHAR2,
                            p_message OUT VARCHAR2);

    -- ------------------------------------------------------------------------
    -- Nom        : existe_res
    -- Auteur     : CMA
    -- Decription :  Vérifie qu'un ES entré dans le profil RTFE de l'utilisateur
    -- existe bien dans la table CENTRE_ACTIVITE dans les colonnes CANIV1 à 6
    --
    -- Retour     : Un message d'erreur si l'ES est inexistant, une chaîne vide
    -- le cas échéant
    --
    -- ------------------------------------------------------------------------
    PROCEDURE existe_res (p_res IN VARCHAR2,
                            p_message OUT VARCHAR2);

    -- ------------------------------------------------------------------------
    -- Nom        : existe_resca
    -- Auteur     : CMA
    -- Decription :  Vérifie qu'un CA entré dans le profil RTFE de l'utilisateur
    -- existe bien dans la table CENTRE_ACTIVITE dans la colonne CODCAMO
    --
    -- Retour     : Un message d'erreur si le CA est inexistant, une chaîne vide
    -- le cas échéant
    --
    -- ------------------------------------------------------------------------
    PROCEDURE existe_resca (p_resca IN VARCHAR2,
                            p_message OUT VARCHAR2);

    -- ------------------------------------------------------------------------
    -- Nom        : existe_dpbip
    -- Auteur     : CMA
    -- Decription :  Vérifie qu'un code dossier projet entré dans le profil RTFE de l'utilisateur
    -- existe bien dans la table DOSSIER_PROJET
    --
    -- Retour     : Un message d'erreur si le code dossier projet est inexistant, une chaîne vide
    -- le cas échéant
    --
    -- ------------------------------------------------------------------------
    PROCEDURE existe_dpbip (p_dpbip IN VARCHAR2,
                            p_message OUT VARCHAR2);

    -- ------------------------------------------------------------------------
    -- Nom        : existe_projbip
    -- Auteur     : CMA
    -- Decription :  Vérifie qu'un code projet bip entré dans le profil RTFE de l'utilisateur
    -- existe bien dans la table PROJ_INFO
    --
    -- Retour     : Un message d'erreur si le code projet bip est inexistant, une chaîne vide
    -- le cas échéant
    --
    -- ------------------------------------------------------------------------
    PROCEDURE existe_projbip (p_projbip IN VARCHAR2,
                            p_message OUT VARCHAR2);

    -- ------------------------------------------------------------------------
    -- Nom        : existe_irt
    -- Auteur     : CMA
    -- Decription :  Vérifie qu'un code application entré dans le profil RTFE de l'utilisateur
    -- existe bien dans la table APPLICATION
    --
    -- Retour     : Un message d'erreur si le code application est inexistant, une chaîne vide
    -- le cas échéant
    --
    -- ------------------------------------------------------------------------
    PROCEDURE existe_irt (p_irt IN VARCHAR2,
                            p_message OUT VARCHAR2);

    TYPE rtfeRtfeUser IS RECORD (
                                 rtfeUser RTFE.USER_RTFE%type
                              );

    TYPE rtfeRtfeUserCurType IS REF CURSOR RETURN rtfeRtfeUser;
    
    -- ------------------------------------------------------------------------
    -- Nom        : select_userrtfe_from_ident
    -- Auteur     : RBO
    -- Decription :  Renvoie les identifiants RTFE correspondant à l'identifiant BIP passé en paramètre
    --
    -- ------------------------------------------------------------------------
    PROCEDURE select_userrtfe_from_ident (p_ident IN NUMBER, 
                            p_curseur IN OUT rtfeRtfeUserCurType,
                            p_message OUT VARCHAR2);
    
    -- ------------------------------------------------------------------------
    -- Nom        : exists_userrtfe
    -- Auteur     : RBO
    -- Decription :   Renvoie un booléan indiquant si l'identifiant RTFE passé en paramètre est présent dans la table RTFE
    --
    -- ------------------------------------------------------------------------              
    PROCEDURE exists_userrtfe (p_user_rtfe IN VARCHAR2, 
                            p_result OUT VARCHAR2,
                            p_message OUT VARCHAR2);  
                            
END Pack_Rtfe;
/

create or replace
PACKAGE BODY     Pack_Rtfe AS





   -- ------------------------------------------------------------------------
   -- Nom        : estHabiliteMe
   -- Appel      : Appelé par la requette report
   -- Auteur     : BAA
   -- Decription : retourne OUI si bddpg_defaut et perim_me correspond bien à ses périmètres
   -- Paramètres : p_ident (IN) l'identifiant de la ressource
   -- 			   p_bddpg_defaut (IN) le bddpg par defaut de l'utilisateur
   --			   p_perim_me (IN) perimetre me
   -- Retour     : OUI ou NON
   -- ------------------------------------------------------------------------

   FUNCTION estHabiliteMe(p_ident IN VARCHAR2, p_bddpg_defaut IN VARCHAR2, p_perim_me IN VARCHAR2) RETURN VARCHAR2 IS

   l_hab 			CHAR(3);
   l_perim_me  		CHAR(11);
   l_tmp			CHAR(11);




   l_pos NUMBER(7);
   l_pos1 NUMBER(7);
   l_chaine VARCHAR2(4000);

   BEGIN

       l_hab:='OUI';

	   l_perim_me := bddpg_ress(p_ident);

	   DBMS_OUTPUT.PUT_LINE(l_perim_me);



	   --On verifie si le bddpg_defaut correspond à son codsg
	   IF(p_bddpg_defaut IS NOT NULL) AND (p_bddpg_defaut <> '') AND (SUBSTR(p_bddpg_defaut,1,9) <> SUBSTR(l_perim_me,1,9))THEN

	   		 RETURN 'NON';

	   ELSIF(SUBSTR(p_bddpg_defaut,10,2) <> '00') AND (SUBSTR(p_bddpg_defaut,10,2) <> SUBSTR(l_perim_me,10,2)) THEN

		     RETURN 'NON';

	   END IF;



       l_chaine := p_perim_me;

	   DBMS_OUTPUT.PUT_LINE('l_chaine '||l_chaine);


	  WHILE l_chaine IS NOT NULL LOOP

         l_tmp := SUBSTR(l_chaine,1,11);


		 IF(l_tmp<> '') AND (SUBSTR(l_tmp,1,9) <> SUBSTR(l_tmp,1,9))THEN

	   		 RETURN 'NON';

	     ELSIF(SUBSTR(l_tmp,10,2) <> '00') AND (SUBSTR(l_tmp,10,2) <> SUBSTR(l_perim_me,10,2)) THEN

		     RETURN 'NON';

	     END IF;



         DBMS_OUTPUT.PUT_LINE(l_tmp);
         l_chaine := SUBSTR(l_chaine,13);

      END LOOP;




	   RETURN l_hab;

   END estHabiliteMe;




   -- ------------------------------------------------------------------------
   -- Nom        : bddpg_ress
   -- Auteur     : BAA
   -- Decription : retourne bddpg à partir des données de la bip
   -- Paramètres : p_ident (IN) l'identifiant de la ressource
   -- Retour     : bddpg sur 11 caracteres
   -- ------------------------------------------------------------------------

   FUNCTION bddpg_ress(p_ident IN VARCHAR2) RETURN VARCHAR2 IS

   l_perim_me  		CHAR(11);

   BEGIN


     SELECT TO_CHAR(d.codbr,'FM00')||TO_CHAR(si.coddir,'FM00')||TO_CHAR(si.coddep,'FM000')||TO_CHAR(si.codpole,'FM00')||TO_CHAR(si.codgro,'FM00')
            INTO l_perim_me
	   FROM SITU_RESS_FULL sr, DATDEBEX d, STRUCT_INFO si,DIRECTIONS d
	   WHERE sr.ident=p_ident
	   AND (d.moismens>=sr.datsitu OR sr.datsitu IS NULL)
	   AND (d.moismens<=sr.datdep OR sr.datdep IS NULL)
	   AND si.codsg=sr.codsg
	   AND d.coddir=si.coddir;


	RETURN l_perim_me;


   END bddpg_ress;


	  -- ------------------------------------------------------------------------
   -- Nom        : tmp_saisie_realisee_seq
   -- Auteur     : BAA
   -- Decription : mise a jour de la table tmp_saisie_realisee
   --
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


   FUNCTION tmp_saisie_realisee_seq RETURN NUMBER IS


    l_var_seq   NUMBER; -- numero de sequence

	v_liste     VARCHAR2(2000);
	v_nombre 	NUMBER;

    CURSOR cur_ress IS
	       SELECT ident, matricule, rnom, rprenom FROM RESSOURCE;


 	CURSOR cur_user(c_chef_projet CHAR)  IS
          SELECT ident FROM RTFE
		  WHERE ROLE='SAISIE_REALISEE'
		  AND INSTR(';'||chef_projet||';',';'||c_chef_projet||';')>0;


   BEGIN

     SELECT sdetail.NEXTVAL INTO l_var_seq FROM dual; --creation de la sequence



     FOR curseur IN cur_ress LOOP


	    v_nombre := 0;
	    v_liste := '';

        FOR curseur1 IN cur_user(curseur.ident) LOOP

		    v_nombre := v_nombre + 1;
		    v_liste := v_liste ||';'|| curseur1.ident;

        END LOOP;



	    INSERT INTO TMP_SAISIE_REALISEE ( NUMSEQ,
					       		          CHEF_PROJET,
								          MATRICULE,
									      RNOM,
									      RPRENOM,
									      USER_QUI_SAISIE,
									      NOMBRE
		  			      		         )
	    VALUES ( l_var_seq,
		         curseur.ident,
				 curseur.matricule,
				 curseur.rnom,
				 curseur.rprenom,
				 SUBSTR(v_liste,2),
				 v_nombre
			   );

	    COMMIT;



	 END LOOP;


	 RETURN l_var_seq;


   END 	tmp_saisie_realisee_seq;

	  -- ------------------------------------------------------------------------
   -- Nom        : select_rtfe_user
   -- Auteur     : CMA
   -- Decription : Récupération des infos RTFE dd'un utilisateur via son user_rtfe
   -- Utilisé lors du chargement du profil RTFE d'une ressource dans la session
   -- dans Administration->Boîte à outils->Charger profil
   --
   -- Retour     : La ligne de ses paramètres RTFE dans un curseur de type RTFE
   --
   -- ------------------------------------------------------------------------

    PROCEDURE select_rtfe_user (p_rtfeUser          IN  VARCHAR2,
                               p_currtfe  IN OUT rtfeCurType,
                               p_message          OUT VARCHAR2
                                  ) IS

       l_msg VARCHAR2(1024);


   BEGIN


      -- Initialiser le message retour

      p_message := '';

     -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *
      -- On ouvre le curseur suivant p_ident
      BEGIN

        -- BSA QC 1176 : ajout PERIM_MCLI
		-- FAD PPM 63956 : Ajout de l'IGG dans la liste des données RTFE de l'utilisateur
        OPEN p_currtfe FOR
             SELECT IDENT, USER_RTFE, NOM, PRENOM, ROLE, MENUS, SS_MENUS, BDDPG_DEFAUT, PERIM_ME, CHEF_PROJET, MO_DEFAUT, PERIM_MO,
                    CENTRE_FRAIS, CA_SUIVI, PROJET, APPLI, CA_FI, CA_PAYEUR, DOSS_PROJ, CA_DA, MAIL, PERIM_MCLI, IGG_RTFE
             FROM RTFE
             WHERE UPPER(user_rtfe) = UPPER(p_rtfeUser)
             UNION
             SELECT 0,user_rtfe,nom, prenom, role, menus, ss_menus,bddpg_defaut,perim_me,chef_projet,mo_defaut,perim_mo,
             centre_frais,ca_suivi,projet,appli,ca_fi,ca_payeur,doss_proj,ca_da,mail,perim_mcli, IGG_RTFE
             FROM RTFE_ERROR
             WHERE UPPER(user_rtfe) = UPPER(p_rtfeUser);

      EXCEPTION

        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- en cas absence
      Pack_Global.recuperer_message(21209, '%s1', p_rtfeUser, NULL, l_msg);
      p_message := l_msg;

   END select_rtfe_user;
   
   -- ------------------------------------------------------------------------
   -- Nom        : select_rtfe_users
   -- Auteur     : RBO
   -- Decription : Récupération des infos RTFE d'une liste d'utilisateurs via des identifiants RTFE
   -- Utilisé lors du chargement de profis Bip à partir d'une liste de ressources
   -- dans Administration->Boîte à outils->Profils liste ressources
   --
   -- Retour     : La ligne de ces infos RTFE dans un curseur de type RTFE
   --
   -- ------------------------------------------------------------------------
   PROCEDURE select_rtfe_users (p_rtfeUsers          IN  VARCHAR2,
                               p_currtfe  IN OUT rtfeUsersCurType,
                               p_message          OUT VARCHAR2) IS
           l_msg VARCHAR2(1024);
            l_requete_chaineparam_in VARCHAR2(32767);
            l_requetechaineorder VARCHAR2(32767);
            l_souschaine_rtfeUser RTFE.USER_RTFE%TYPE;
            l_cpt    NUMBER(7);

   BEGIN

      -- Initialiser les variables locales
      p_message := '';
      l_souschaine_rtfeUser := '';
      l_cpt     := 1;

      WHILE l_cpt != 0 LOOP
        -- Récupération de l'utilisateur RTFE courant
        l_souschaine_rtfeUser := split_varchar(p_rtfeUsers, l_cpt);

        -- S'il existe encore un délimiteur
        IF l_souschaine_rtfeUser != '0' THEN
            -- Si ce n'est pas le premier élément
            IF (NVL(l_requete_chaineparam_in, ' ') != ' ') THEN
              -- Ajout d'une virgule
              l_requete_chaineparam_in := l_requete_chaineparam_in || ',';
              l_requetechaineorder := l_requetechaineorder || ',';
            END IF;
            -- Ajout de l'utilisateur RTFE courant
            l_requete_chaineparam_in := l_requete_chaineparam_in || 'UPPER(''' || l_souschaine_rtfeUser || ''')';
            l_requetechaineorder := l_requetechaineorder || 'UPPER(''' || l_souschaine_rtfeUser || '''),' || l_cpt;
            
            -- Incrémentation du compteur
            l_cpt := l_cpt + 1;
        -- Si tous les éléments ont été traités
        ELSE
            l_cpt :=0;
        END IF;
      END LOOP;
      
      -- Si au moins un paramètre in
      IF (NVL(l_requete_chaineparam_in, ' ') != ' ') THEN
        
        -- On ouvre le curseur suivant p_ident
        BEGIN
          -- TODO : supprimer param non utilisés : IDENT, ROLE
          -- Ouverture du curseur
		  -- KRA - PPM 61776
          OPEN p_currtfe FOR 'SELECT * FROM (SELECT DISTINCT IDENT, USER_RTFE, NOM, PRENOM, ROLE, MENUS, SS_MENUS, BDDPG_DEFAUT, PERIM_ME, pack_global.get_liste_chefs_projet(CHEF_PROJET) CHEF_PROJET, MO_DEFAUT, PERIM_MO,
                      CENTRE_FRAIS, CA_SUIVI, PROJET, APPLI, CA_FI, CA_PAYEUR, DOSS_PROJ, CA_DA, MAIL, PERIM_MCLI
               FROM RTFE
               WHERE UPPER(user_rtfe) IN (' || l_requete_chaineparam_in || ')
               UNION
               SELECT 0,user_rtfe,nom, prenom, role, menus, ss_menus,bddpg_defaut,perim_me,chef_projet,mo_defaut,perim_mo,
               centre_frais,ca_suivi,projet,appli,ca_fi,ca_payeur,doss_proj,ca_da,mail,perim_mcli
               FROM RTFE_ERROR
               WHERE UPPER(user_rtfe) IN (' || l_requete_chaineparam_in || '))
               ORDER BY decode(UPPER(user_rtfe),' || l_requetechaineorder || ',NULL)';
  
        EXCEPTION
  
          WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;
      END IF;
      
  END select_rtfe_users;
  
  -- Découpage de la chaine récupérée 
   FUNCTION split_varchar (p_string     IN  VARCHAR2,
                           p_occurence  IN  NUMBER
                          ) RETURN VARCHAR2 IS
   pos1 NUMBER(6);
   pos2 NUMBER(6);
   str  RTFE.USER_RTFE%TYPE;

   BEGIN
      -- indice de la p_occurence ème occurence de ' ' à partir de la première position
      -- renvoie 0 si non trouvé
      pos1 := INSTR(p_string,' ',1,p_occurence);
      pos2 := INSTR(p_string,' ',1,p_occurence+1);

     str := SUBSTR( p_string, pos1+1, pos2-pos1-1);
     RETURN str;
   END split_varchar;

 PROCEDURE find_rtfe_user (p_ident          IN  VARCHAR2,
                             p_debnom         IN VARCHAR2,
                             p_nomcont        IN VARCHAR2,
                             p_currtfe        IN OUT rtfeUserCurType,
                             p_message        OUT VARCHAR2)IS

  BEGIN

      if(p_ident is not null) then
           BEGIN
           open p_currtfe FOR select r.user_rtfe,
           RPAD(NVL(to_char(r.user_rtfe), ' '), 15, ' ')||
           RPAD(NVL(TO_CHAR(r.nom), ' '), 32, ' ')||
           RPAD(NVL(TO_CHAR(r.prenom), ' '), 17, ' ')||
           RPAD(NVL(TO_CHAR(r.ident), ' '), 9, ' ')
              from rtfe_user r
              where r.ident = p_ident
              order by r.nom;
              EXCEPTION
           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -21019, SQLERRM);
           END;
      elsif(p_nomcont is not null) then
           BEGIN
           open p_currtfe FOR select r.user_rtfe,
           RPAD(NVL(to_char(r.user_rtfe), ' '), 15, ' ')||
           RPAD(NVL(TO_CHAR(r.nom), ' '), 32, ' ')||
           RPAD(NVL(TO_CHAR(r.prenom), ' '), 17, ' ')||
           RPAD(NVL(TO_CHAR(r.ident), ' '), 9, ' ')
              from rtfe_user r
              where r.nom like '%'||UPPER(p_nomcont)||'%'
              order by r.nom;
              EXCEPTION
           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -21019, SQLERRM);
           END;
      else
      BEGIN
           open p_currtfe FOR select r.user_rtfe,
           RPAD(NVL(to_char(r.user_rtfe), ' '), 15, ' ')||
           RPAD(NVL(TO_CHAR(r.nom), ' '), 32, ' ')||
           RPAD(NVL(TO_CHAR(r.prenom), ' '), 17, ' ')||
           RPAD(NVL(TO_CHAR(r.ident), ' '), 9, ' ')
              from rtfe_user r
              where r.nom like upper(p_debnom)||'%'
              order by r.nom;
              EXCEPTION
           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -21019, SQLERRM);
              END;
      end if;

  END find_rtfe_user;

  PROCEDURE count_rtfe_user (p_ident         IN  VARCHAR2,
                             p_debnom         IN VARCHAR2,
                             p_nomcont        IN VARCHAR2,
                             p_count          IN OUT VARCHAR2,
                             p_message        OUT VARCHAR2)IS

  l_count NUMBER;
  BEGIN
  l_count := 0;
  IF(p_ident is not null) then
    select count(*) into l_count
              from rtfe_user r
              where r.ident = p_ident
              order by r.nom;
   elsif(p_nomcont is not null) then
            select count(*) into l_count
              from rtfe_user r
              where r.nom like '%'||UPPER(p_nomcont)||'%'
              order by r.nom;
      else
            select count(*) into l_count
              from rtfe_user r
              where r.nom like upper(p_debnom)||'%'
              order by r.nom;
      end if;
  if(l_count=0)then
  pack_global.recuperer_message( 21019,null,null,null,p_message);
  end if;
  p_count := l_count;
  END count_rtfe_user;

  PROCEDURE existe_bddpg (p_bddpg IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    bddpg NUMBER(11);

    BEGIN

    p_message :='';



        BEGIN

            SELECT codbddpg into bddpg
            FROM VUE_DPG_PERIME
            WHERE codbddpg = TO_NUMBER(p_bddpg)
            AND ROWNUM<=1;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- BDDPG inexistant

               Pack_Global.recuperer_message(2064, '%s1', p_bddpg, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

    END existe_bddpg;

    PROCEDURE existe_dpg (p_dpg IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    dpg NUMBER(7);

    BEGIN

    p_message :='';



        BEGIN

            SELECT codsg into dpg
            FROM VUE_DPG_PERIME
            WHERE codsg = TO_NUMBER(p_dpg)
            AND ROWNUM<=1;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- DPG inexistant

               Pack_Global.recuperer_message(2064, '%s1', p_dpg, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

    END existe_dpg;

    PROCEDURE existe_resbip (p_resbip IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    resbip NUMBER(5);
    l_len NUMBER;
    l_resbip VARCHAR2(10); -- ABN - QC 1842 - PPM 61776

    BEGIN

    p_message :='';



    -- ABN - QC 1842 - PPM 61776
    IF INSTR(p_resbip,'*') >0 THEN
      l_len := length(p_resbip);
      l_resbip := substr(p_resbip,0,l_len-1);
      --DBMS_OUTPUT.PUT_LINE('l_resbip IF: '||l_resbip);
    ELSE 
      l_resbip := p_resbip;
    END IF;
    -- ABN - QC 1842 - PPM 61776
        BEGIN

            SELECT ident into resbip
            FROM RESSOURCE
            WHERE ident = TO_NUMBER(l_resbip)
            AND ROWNUM<=1;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Ressource inexistante

               Pack_Global.recuperer_message(2050, NULL, NULL, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

    END existe_resbip;

    PROCEDURE existe_clibip (p_clibip IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    clibip VARCHAR2(5);

    BEGIN

    p_message :='';



        BEGIN

            SELECT clicode into clibip
            FROM CLIENT_MO
            WHERE clicode = p_clibip
            AND ROWNUM<=1;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Client MO inexistant

               Pack_Global.recuperer_message(4, '%s1', p_clibip, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

    END existe_clibip;

    PROCEDURE existe_bdclibip (p_bdclibip IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    bdclibip VARCHAR2(12);

    BEGIN

    p_message :='';



        BEGIN

            SELECT bdclicode into bdclibip
            FROM VUE_CLICODE_PERIMO
            WHERE bdclicode = p_bdclibip
            AND ROWNUM<=1;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Code client inexistant

               Pack_Global.recuperer_message(4, '%s1', p_bdclibip, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

    END existe_bdclibip;

    PROCEDURE existe_cfbip (p_cfbip IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    cfbip NUMBER(3);

    BEGIN

    p_message :='';



        BEGIN

            SELECT codcfrais into cfbip
            FROM CENTRE_FRAIS
            WHERE codcfrais = TO_NUMBER(p_cfbip)
            AND ROWNUM<=1;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Centre de frais inexistant

               Pack_Global.recuperer_message(20344, '%s1', p_cfbip, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

    END existe_cfbip;

    PROCEDURE existe_res (p_res IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    res NUMBER(6);

    BEGIN

    p_message :='';



        BEGIN

            SELECT codcamo into res
            FROM CENTRE_ACTIVITE
            WHERE (CODCAMO = TO_NUMBER(p_res)
            OR CANIV1 = TO_NUMBER(p_res)
            OR CANIV2 = TO_NUMBER(p_res)
            OR CANIV3 = TO_NUMBER(p_res)
            OR CANIV4 = TO_NUMBER(p_res)
            OR CANIV5 = TO_NUMBER(p_res)
            OR CANIV6 = TO_NUMBER(p_res))
            AND ROWNUM<=1;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- ES du RES inexistant

               Pack_Global.recuperer_message(20969, '%s1', p_res, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

    END existe_res;

        PROCEDURE existe_resca (p_resca IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    resca NUMBER(6);

    BEGIN

    p_message :='';



        BEGIN

            SELECT codcamo into resca
            FROM CENTRE_ACTIVITE
            WHERE codcamo = TO_NUMBER(p_resca)
            AND ROWNUM<=1;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Centre activite inexistant

               Pack_Global.recuperer_message(2007, '%s1', p_resca, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

    END existe_resca;

        PROCEDURE existe_dpbip (p_dpbip IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    dpbip NUMBER(5);

    BEGIN

    p_message :='';



        BEGIN

            SELECT dpcode into dpbip
            FROM DOSSIER_PROJET
            WHERE dpcode = TO_NUMBER(p_dpbip)
            AND ROWNUM<=1;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Code dossier projet inexistant

               Pack_Global.recuperer_message(2031, '%s1', p_dpbip, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

    END existe_dpbip;

        PROCEDURE existe_projbip (p_projbip IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    projbip VARCHAR2(5);

    BEGIN

    p_message :='';



        BEGIN

            SELECT icpi into projbip
            FROM PROJ_INFO
            WHERE icpi = p_projbip
            AND ROWNUM<=1;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- CCode projet inexistant

               Pack_Global.recuperer_message(21076, '%s1', p_projbip, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

    END existe_projbip;

        PROCEDURE existe_irt (p_irt IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    irt VARCHAR2(5);

    BEGIN

    p_message :='';



        BEGIN

            SELECT airt into irt
            FROM APPLICATION
            WHERE airt = p_irt
            AND ROWNUM<=1;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Code application inexistant

               Pack_Global.recuperer_message(2027, '%s1', p_irt, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

    END existe_irt;
    
    -- ------------------------------------------------------------------------
    -- Nom        : select_userrtfe_from_ident
    -- Auteur     : RBO
    -- Decription :  Renvoie les identifiants RTFE correspondant à l'identifiant BIP passé en paramètre
    --
    -- ------------------------------------------------------------------------
    PROCEDURE select_userrtfe_from_ident (p_ident IN NUMBER, 
                            p_curseur IN OUT rtfeRtfeUserCurType,
                            p_message OUT VARCHAR2)IS
    BEGIN     
      BEGIN
        OPEN p_curseur FOR
          SELECT DISTINCT USER_RTFE
          FROM RTFE
          WHERE IDENT = p_ident;
        EXCEPTION
          WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
    END select_userrtfe_from_ident;
    
   -- ------------------------------------------------------------------------
    -- Nom        : exists_userrtfe
    -- Auteur     : RBO
    -- Decription :  Renvoie un boolean indiquant si l'identifiant RTFE passé en paramètre est présent dans la table RTFE
    --
    -- ------------------------------------------------------------------------              
    PROCEDURE exists_userrtfe (p_user_rtfe IN VARCHAR2,
                            p_result OUT VARCHAR2,
                            p_message OUT VARCHAR2)IS
     -- Correction SZ 14/10/2016 la procedure retourne dans tous les cas 'O' !!!!
    --  p_curseur rtfeRtfeUserCurType; 
    l_chaine VARCHAR2(4000);
    BEGIN
        p_result := 'O';
   --   BEGIN
    --    OPEN p_curseur FOR
          SELECT DISTINCT USER_RTFE INTO l_chaine
          FROM RTFE
          WHERE UPPER(USER_RTFE) = UPPER(p_user_rtfe)
          UNION
          SELECT DISTINCT USER_RTFE
          FROM RTFE_ERROR
          WHERE UPPER(USER_RTFE) = UPPER(p_user_rtfe);
      Exception
        When NO_DATA_FOUND Then
            p_result := 'N';
     -- END;
    END exists_userrtfe;

END Pack_Rtfe;
/
