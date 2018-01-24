-- Package de gestion du COPI fiche 616
-- Créé le 15/04/2008 par JAL
-- modifié le 18/04/2008  par :  JAL (MAJ dernière version)
-- modifié le 23/04/2008 par : EVI FIche TD 616
-- modifié le 05/05/2008 par : JAL fiche 616 : rajout UPPERCASE sur champ DP_COPI
-- modifié le 23/05/2008 par : EVI fiche 616 : correction affichage du code dp a la place du code client 
-- modifié le 29/05/2008 par : ABA verife lors de l'ajout que le code client appartient à bddf
-- modifier le 07 /11/ 2008 par ABA : TD 665    
-- modifier le 31 /12/ 2008 par ABA : TD  723
-- modifier le 20 /01/ 2009 par ABA : TD  723 ajout du champ code dossier projet lors du transfert d'un dp copi provisoire en un dp copi definitif
-- modifier le 27 /03/ 2009 par ABA : nous ne creeons plus d dpcode lors de la validation d'un dp copi celui ci est creer manuellement avant le transfert
-- modifier le 24/07/ 2009 par ABA : TD 797
--  12/08/2009         ABA TD 799
-- Modifié le 18/07/2011 par CMA : TD 1233 On peut créer un dp copi avec un code client différent de BDFF désormais

CREATE OR REPLACE PACKAGE     pack_copi IS


TYPE dossier_projet_copi_ViewType IS RECORD(p_dpcopi dossier_projet_copi.dp_copi%TYPE,
                                     p_libelle dossier_projet_copi.libelle%TYPE,
                                     p_dpcode  dossier_projet_copi.dpcode%TYPE,
                                     p_clicode dossier_projet_copi.clicode%TYPE,
                                     p_flaglock dossier_projet_copi.flaglock%TYPE,
                                     p_domaine_code VARCHAR2(5),
                                     p_domaine_lib VARCHAR2(100),
                                     p_AXE_STRATEGIQUE VARCHAR2(2),
                                     p_ETAPE VARCHAR2(2),
                                     p_TYPE_FINANCEMENT VARCHAR2(2),
                                     p_QUOTE_PART VARCHAR2(5),
                                     p_dpcopiaxemetier VARCHAR2(20)
                                       );

TYPE dossier_projet_copiCurType IS REF CURSOR RETURN dossier_projet_copi_ViewType;

TYPE dpcopi_info_budget_ViewType IS RECORD(  p_annee   budget_copi.annee%TYPE,
                                     p_date_copi   budget_copi.date_copi%TYPE,
                                     p_metier   budget_copi.metier%TYPE,
                                     p_JH_COUTTOTAL budget_copi.JH_COUTTOTAL%TYPE,
                                     p_JH_ARBDEMANDES budget_copi.JH_ARBDEMANDES%TYPE,
                                     p_JH_ARBDECIDES budget_copi.JH_ARBDECIDES%TYPE,
                                     p_JH_CANTDEMANDES budget_copi.JH_CANTDEMANDES%TYPE,
                                     p_JH_CANTDECIDES budget_copi.JH_CANTDECIDES%TYPE,
                                     p_TYPE_DEMANDE copi_type_demande.libelle%TYPE,
                                     p_FOUR_COPI copi_four.libelle_four_copi%TYPE
                                       );

TYPE  dpcopi_info_budget_copiCurType IS REF CURSOR RETURN dpcopi_info_budget_ViewType;

PROCEDURE VERIFIER_DPCOPI_AXE_METIER (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_dpcopiaxemetier IN DOSSIER_PROJET_COPI.dpcopiaxemetier%TYPE,
                                     p_clicode   IN  dossier_projet_copi.clicode%TYPE,
                                     p_type OUT VARCHAR2,
                                     p_param_id OUT VARCHAR2,
                                     p_message OUT VARCHAR2);
  PROCEDURE miseAVide ( type_msg   IN VARCHAR2, param_id IN VARCHAR2, p_userid IN VARCHAR2, p_message   OUT VARCHAR2 );
  
  PROCEDURE insert_dpcopi (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_libelle   IN  dossier_projet_copi.libelle%TYPE,
                                     p_dpcode    IN  dossier_projet_copi.dpcode%TYPE,
                                     p_clicode   IN  dossier_projet_copi.clicode%TYPE,
                                     p_userid    IN  VARCHAR2,
                                     p_domaine   IN  VARCHAR2,
                                     p_AXE_STRATEGIQUE VARCHAR2,
                                     p_ETAPE VARCHAR2,
                                     p_TYPE_FINANCEMENT VARCHAR2,
                                     p_QUOTE_PART VARCHAR2,
                                     p_dpcopiaxemetier VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                    );

   PROCEDURE update_dpcopi (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_libelle   IN  dossier_projet_copi.libelle%TYPE,
                                     p_dpcode   IN  dossier_projet_copi.dpcode%TYPE,
                                     p_clicode   IN  dossier_projet_copi.clicode%TYPE,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_domaine   IN  VARCHAR2,
                                     p_AXE_STRATEGIQUE VARCHAR2,
                                     p_ETAPE VARCHAR2,
                                     p_TYPE_FINANCEMENT VARCHAR2,
                                     p_QUOTE_PART VARCHAR2,
                                     p_dpcopiaxemetier VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                   );

   PROCEDURE delete_dpcopi (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                    );

   PROCEDURE select_dpcopi (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_userid             IN VARCHAR2,
                                     p_curdossier_projet_copi IN OUT dossier_projet_copiCurType,
                                     p_nbcurseur             OUT INTEGER,
                                     p_message               OUT VARCHAR2
                                    );

   PROCEDURE select_dpcopi_info_budget (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_userid             IN VARCHAR2,
                                    p_libelle OUT VARCHAR2,
                                     p_curseur IN OUT dpcopi_info_budget_copiCurType,
                                     p_message               OUT VARCHAR2
                                    );

   PROCEDURE update_dpcopi_info_budget (p_dpcopi_prov   IN  dossier_projet_copi.dp_copi%TYPE,
                                        p_dpcopi_def   IN  dossier_projet_copi.dp_copi%TYPE,
                                        p_dpcode    IN dossier_projet.dpcode%Type,
                                       p_userid             IN VARCHAR2,
                                        p_message               OUT VARCHAR2
                                    );


    PROCEDURE maj_dossier_projet_copi_logs (p_dp_copi        IN DOSSIER_PROJET_COPI_LOGS.dp_copi%TYPE,
                              p_user_log    IN VARCHAR2,
                              p_colonne        IN VARCHAR2,
                              p_valeur_prec    IN VARCHAR2,
                              p_valeur_nouv    IN VARCHAR2,
                              p_commentaire    IN VARCHAR2
                              );


TYPE dpcopi_Type IS RECORD (
                                 dpcopi        VARCHAR2(10) ,
                                 lib_dpcopi        VARCHAR2(10)
                             );

TYPE dpcopiCurType IS REF CURSOR RETURN dpcopi_Type;

PROCEDURE lister_dpcopi (p_userid     IN VARCHAR2,
                          p_curDpCopi IN OUT dpcopiCurType
                                  );

END pack_copi;
/


CREATE OR REPLACE PACKAGE BODY     pack_copi AS

-- MCH : PPM 61919 chapitre 6.7 la procédure 'VERIFIER_DPCOPI_AXE_METIER' permet de controler le champ dpcopiaxemetier
PROCEDURE VERIFIER_DPCOPI_AXE_METIER (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_dpcopiaxemetier IN DOSSIER_PROJET_COPI.dpcopiaxemetier%TYPE,
                                     p_clicode   IN  dossier_projet_copi.clicode%TYPE,
                                     p_type OUT VARCHAR2,
                                     p_param_id OUT VARCHAR2,
                                     p_message OUT VARCHAR2)
                                     IS

    
    l_msg_dmp VARCHAR2(1024);
    l_code_action LIGNE_PARAM_BIP.CODE_ACTION%TYPE;
    l_actif LIGNE_PARAM_BIP.ACTIF%TYPE;
    l_obligatoire LIGNE_PARAM_BIP.OBLIGATOIRE%TYPE;
    l_direction CLIENT_MO.CLIDIR%TYPE;
    l_dmpnum VARCHAR2(20);
    l_DdeType VARCHAR2(10);
    type_msg VARCHAR2(5);
    param_id VARCHAR2(20);
    l_pid VARCHAR2(20);
	l_dpcopiaxemetier DOSSIER_PROJET_COPI.dpcopiaxemetier%TYPE;
	count_dmpnum NUMBER;
    BEGIN
		p_message := 'valid';
		type_msg :='';
		param_id :='';
		--FAD PPM 64794 : Test de la nouvelle régle. Si ok, alors ne rien faire.
		BEGIN
			SELECT dpcopiaxemetier INTO l_dpcopiaxemetier FROM dossier_projet_copi where dp_copi = p_dpcopi;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			l_dpcopiaxemetier := NULL;
		END;
		SELECT COUNT(DMPNUM) INTO count_dmpnum FROM DMP_RESEAUXFRANCE WHERE dmpnum = l_dpcopiaxemetier;
		
		IF (l_dpcopiaxemetier IS NOT NULL AND l_dpcopiaxemetier = p_dpcopiaxemetier AND count_dmpnum = 0)
		THEN
			NULL;
		ELSE
		--FAD PPM 64794 : Fin
			  
			  BEGIN
				select clidir into l_direction from client_mo where clicode = p_clicode;
				select code_action, actif, obligatoire  
				into l_code_action, l_actif,l_obligatoire 
				from ligne_param_bip 
				where code_action = 'AXEMETIER_' || l_direction and code_version like 'DPC%' and upper(actif) = 'O';
				
				IF(upper(l_obligatoire) = 'O' AND (p_dpcopiaxemetier IS NULL OR p_dpcopiaxemetier ='')) THEN
				  pack_global.recuperer_message (21295, NULL, NULL, NULL, p_message);
				  p_type := 'A';
				  
				ELSE
				  IF ( l_obligatoire = 'O') then
				
					BEGIN
					  select distinct dmpnum into l_dmpnum from DMP_RESEAUXFRANCE where dmpnum = p_dpcopiaxemetier and upper(ddetype) = 'P';
					EXCEPTION
					WHEN NO_DATA_FOUND THEN 
					  pack_global.recuperer_message (21295, NULL, NULL, NULL, p_message);
					  p_type := 'A';
					END;    
				  END IF;
				END IF;
				IF ( p_message = 'valid') THEN

					  BEGIN
					  
					  SELECT distinct dp_copi,'D' INTO p_param_id,p_type FROM dossier_projet_copi where dpcopiaxemetier = p_dpcopiaxemetier and dp_copi != p_dpcopi and rownum = 1;
					  pack_global.recuperer_message (21296, '%s1', p_param_id, NULL, p_message);
					   
					  EXCEPTION
					  WHEN NO_DATA_FOUND THEN

						  BEGIN

						  SELECT distinct icpi,'P' INTO p_param_id,p_type  FROM PROJ_INFO where ProjAxeMetier = p_dpcopiaxemetier and rownum = 1;
						  pack_global.recuperer_message (21297, '%s1', p_param_id, NULL, p_message);

						  EXCEPTION
						  WHEN NO_DATA_FOUND THEN

						  BEGIN
							SELECT distinct tache, 'T', pid INTO p_param_id,p_type, l_pid  FROM ISAC_TACHE where TacheAxeMetier = p_dpcopiaxemetier and rownum = 1;
							pack_global.recuperer_message (21298, '%s1', l_pid, NULL, p_message);
							EXCEPTION
							WHEN NO_DATA_FOUND THEN
							-- MCH : QC1809
							  BEGIN
								SELECT distinct ecet || ',' || acta || ',' || acst || ',' || pid, 'TA', pid INTO p_param_id,p_type, l_pid  FROM TACHE where TacheAxeMetier = p_dpcopiaxemetier and rownum = 1;
								pack_global.recuperer_message (21298, '%s1', l_pid, NULL, p_message);
								
							  EXCEPTION
							  
								WHEN NO_DATA_FOUND THEN
								  
								  BEGIN
									SELECT distinct lignebipcode || ',' || etapenum || ',' || tachenum || ',' || stachenum, 'BIPS', lignebipcode INTO p_param_id,p_type, l_pid  FROM bips_activite where TacheAxeMetier = p_dpcopiaxemetier and rownum = 1;
									pack_global.recuperer_message (21298, '%s1', l_pid, NULL, p_message);
								-- MCH : QC1809
								  EXCEPTION
							  
								  WHEN NO_DATA_FOUND THEN
									p_message := 'valid';
								  
							  END;
								  
							  END;
							END;
						  END;

					  END;
				END IF;         
			  EXCEPTION
				WHEN NO_DATA_FOUND THEN p_message := 'valid'; 
			  END;
		END IF;
 
END VERIFIER_DPCOPI_AXE_METIER;
    
    -- MCH : PPM 61919 chapitre 6.7 la procédure 'miseAVide' permet de réinitialiser le champ *axemetier 
    PROCEDURE miseAVide ( type_msg   IN VARCHAR2, param_id IN VARCHAR2, p_userid IN VARCHAR2, p_message   OUT VARCHAR2 ) IS
    
    l_old_dpcopiaxemetier VARCHAR2(20);
    l_old_projaxemetier VARCHAR2(20);
    l_old_tacheaxemetier VARCHAR2(20);
    l_pid VARCHAR2(20);
    l_user VARCHAR2(30);
    l_tab PACK_GLOBAL.t_array;
    l_ecet VARCHAR2(10);
    l_acta VARCHAR2(10);
    l_acst VARCHAR2(10);
    
    BEGIN
    
    l_user := pack_global.lire_globaldata(p_userid).idarpege;
    
    if ( upper(type_msg) = 'D' )
    then
    select dpcopiaxemetier into l_old_dpcopiaxemetier from DOSSIER_PROJET_COPI where dp_copi = param_id;
    update DOSSIER_PROJET_COPI set dpcopiaxemetier = null where dp_copi = param_id;
    maj_dossier_projet_copi_logs (UPPER(param_id), l_user, 'DPCOPIAXEMETIER',l_old_dpcopiaxemetier,null,'Mis à vide par contrôle d''unicité');
    elsif ( upper(type_msg) = 'P' )
    then
    select projaxemetier into l_old_projaxemetier from PROJ_INFO where icpi = param_id;
    update PROJ_INFO set ProjAxeMetier = null where icpi = param_id;
    PACK_PROJ_INFO.maj_proj_info_logs(UPPER(param_id), l_user, 'ProjAxeMetier', l_old_projaxemetier, null, 'Mis à vide par contrôle d''unicité');
    elsif ( upper(type_msg) = 'T' )
    then
    select pid, tacheaxemetier into l_pid, l_old_tacheaxemetier from ISAC_TACHE where tache = param_id;
    update ISAC_TACHE set TacheAxeMetier = null where tache = param_id;
    pack_ligne_bip.maj_ligne_bip_logs (l_pid, l_user, 'Axe métier Tâche', l_old_tacheaxemetier, null, 'Mis à vide par contrôle d''unicité');
    -- MCH : QC1809
    elsif ( upper(type_msg) = 'TA' )
    then
    l_tab := PACK_GLOBAL.SPLIT (param_id, ',');
    l_ecet := l_tab(1); 
    l_acta := l_tab(2);
    l_acst := l_tab(3);
    l_pid := l_tab(4);
    select tacheaxemetier into l_old_tacheaxemetier from TACHE where ecet = l_ecet and acta = l_acta and acst = l_acst and pid = l_pid;
    update TACHE set TacheAxeMetier = null where ecet = l_ecet and acta = l_acta and acst = l_acst and pid = l_pid;
    pack_ligne_bip.maj_ligne_bip_logs (l_pid, l_user, 'Axe métier Tâche', l_old_tacheaxemetier, null, 'Mis à vide par contrôle d''unicité');
    elsif ( upper(type_msg) = 'BIPS' )
    then
    l_tab := PACK_GLOBAL.SPLIT (param_id, ',');
    l_pid := l_tab(1); 
    l_ecet := l_tab(2);
    l_acta := l_tab(3);
    l_acst := l_tab(4);
    select tacheaxemetier into l_old_tacheaxemetier from BIPS_ACTIVITE where lignebipcode = l_pid and etapenum = l_ecet and tachenum = l_acta and stachenum = l_acst; 
    update BIPS_ACTIVITE set TacheAxeMetier = null where lignebipcode = l_pid and etapenum = l_ecet and tachenum = l_acta and stachenum = l_acst;
    pack_ligne_bip.maj_ligne_bip_logs (l_pid, l_user, 'Axe métier Tâche', l_old_tacheaxemetier, null, 'Mis à vide par contrôle d''unicité');
    -- MCH : QC1809
    end if;

    END miseAVide;

 PROCEDURE insert_dpcopi (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_libelle   IN  dossier_projet_copi.libelle%TYPE,
                                     p_dpcode    IN  dossier_projet_copi.dpcode%TYPE,
                                     p_clicode   IN  dossier_projet_copi.clicode%TYPE,
                                     p_userid    IN  VARCHAR2,
                                     p_domaine   IN  VARCHAR2,
                                     p_AXE_STRATEGIQUE VARCHAR2,
                                     p_ETAPE VARCHAR2,
                                     p_TYPE_FINANCEMENT VARCHAR2,
                                     p_QUOTE_PART VARCHAR2,
                                     -- MCH : PPM 61919 chapitre 6.7 nouveau champ dpcopiaxemetier ds la table dossier_projet_copi
                                     p_dpcopiaxemetier VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                    ) IS

   l_msg VARCHAR2(1024);
   l_dpcode DOSSIER_PROJET.DPCODE%TYPE;
   l_clicode CLIENT_MO.CLICODE%TYPE;
   l_user VARCHAR2(7);
   l_libelle_axe_strategique COPI_AXE_STRATEGIQUE.LIBELLE%TYPE;

   l_verif VARCHAR2(1024); 
   
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

          l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      BEGIN -- Test si le dossier projet existe
      SELECT dpcode INTO l_dpcode
      FROM DOSSIER_PROJET
      WHERE dpcode=p_dpcode;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                    pack_global.recuperer_message(2031,'%s1',p_dpcode, NULL, l_msg);
                    RAISE_APPLICATION_ERROR(-20757,l_msg);
            WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20757, SQLERRM);
         END;
      
      -- SEL 10/06/2014 PPM 58143 QC 1612 
      BEGIN 
      SELECT libelle into l_libelle_axe_strategique from copi_axe_strategique where numero=p_AXE_STRATEGIQUE;
      END;

      BEGIN -- Test si code client MO existe
      SELECT c.clicode INTO l_clicode
      FROM CLIENT_MO c
      WHERE c.clicode=p_clicode;

      EXCEPTION
            WHEN NO_DATA_FOUND THEN
               pack_global.recuperer_message(4,'%s1',p_clicode, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20757, l_msg);
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20757, SQLERRM);
         END;

    -- CMA QC 1233 - Le code client ne doit plus obligatoirement appartenir à BDDF 
    /*
      BEGIN   -- Test si code client MO appartient à BDDF
      SELECT c.clicode INTO l_clicode
      FROM CLIENT_MO c, directions d
      WHERE c.clicode=p_clicode
       AND c.clidir = d.coddir
         AND d.codbr = 3;

      EXCEPTION
            WHEN NO_DATA_FOUND THEN
               pack_global.recuperer_message(21104,'%s1',p_clicode, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20757, l_msg);
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20757, SQLERRM);
         END;
    */

         BEGIN

         INSERT INTO dossier_projet_copi (
                                      dp_copi,
                                      libelle,
                                      dpcode,
                                      clicode,
                                      domaine,
                                      AXE_STRATEGIQUE,
                                      ETAPE,
                                      TYPE_FINANCEMENT,

                                      QUOTE_PART,
                                      dpcopiaxemetier
                                     )
                VALUES ( UPPER(p_dpcopi),
                        p_libelle,
                        TO_NUMBER(p_dpcode),
                        TO_NUMBER(p_clicode),
                        p_domaine,
                        to_number(p_AXE_STRATEGIQUE),
                        to_number(p_ETAPE),
                        to_number(p_TYPE_FINANCEMENT),
                        to_number(p_QUOTE_PART),
                        --PPM 65186 : Adding RTRIM function to remove space from axemetier -- START
                        RTRIM(p_dpcopiaxemetier)
                        --PPM 65186 : Adding RTRIM function to remove space from axemetier -- END
                       );

         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'DP_COPI','',UPPER(p_dpcopi),'Création du dp_copi');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'LIBELLE','',p_libelle,'Création du libelle');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'DPCODE','',p_dpcode,'Création du code dossier projet');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'CLICODE','',p_clicode,'Création du code client');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'DOMAINE','',p_domaine,'Création du code domaine');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'AXE_STRATEGIQUE','',p_AXE_STRATEGIQUE||'-'||l_libelle_axe_strategique,'Création du code enveloppe budgétaire');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'ETAPE','',p_ETAPE,'Création du code etape');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'TYPE_FINANCEMENT','',p_TYPE_FINANCEMENT,'Création du code type financemennt');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'QUOTE_PART','',to_char(p_QUOTE_PART,'FM0D00'),'Création du la quote_part');

         --PPM 65186 : Adding RTRIM function to remove space from axemetier -- START
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'DPCOPIAXEMETIER','',RTRIM(p_dpcopiaxemetier),'Création de l''axe métier DPCOPI');
         --PPM 65186 : Adding RTRIM function to remove space from axemetier -- END
         pack_global.recuperer_message(21084,'%s1',p_dpcopi, NULL, l_msg);
         p_message := l_msg;
             
     END;
   END insert_dpcopi;

   PROCEDURE update_dpcopi (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_libelle   IN  dossier_projet_copi.libelle%TYPE,
                                     p_dpcode   IN  dossier_projet_copi.dpcode%TYPE,
                                     p_clicode   IN  dossier_projet_copi.clicode%TYPE,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_domaine   IN  VARCHAR2,
                                     p_AXE_STRATEGIQUE VARCHAR2,
                                     p_ETAPE VARCHAR2,
                                     p_TYPE_FINANCEMENT VARCHAR2,
                                     p_QUOTE_PART VARCHAR2,
                                     -- MCH : PPM 61919 chapitre 6.7 nouveau champ dpcopiaxemetier ds la table dossier_projet_copi
                                     p_dpcopiaxemetier VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                   ) IS

      l_msg VARCHAR(1024);
      l_dpcode DOSSIER_PROJET.DPCODE%TYPE;
      l_clicode CLIENT_MO.CLICODE%TYPE;
      l_domaine VARCHAR2(5);
      l_user varchar2(7);

      old_LIBELLE VARCHAR2(50);
      old_DPCODE VARCHAR2(50);
      old_CLICODE VARCHAR2(50);
      old_FLAGLOCK VARCHAR2(50);
      old_DOMAINE VARCHAR2(50);
      old_AXE_STRATEGIQUE VARCHAR2(50);
      old_ETAPE VARCHAR2(50);
      old_TYPE_FINANCEMENT VARCHAR2(50);
      old_QUOTE_PART VARCHAR2(50);
      old_DPCOPIAXEMETIER VARCHAR2(20);
      old_AXE_STRATEGIQUE_LIBELLE COPI_AXE_STRATEGIQUE.LIBELLE%TYPE;
      AXE_STRATEGIQUE_LIBELLE COPI_AXE_STRATEGIQUE.LIBELLE%TYPE;

      l_verif VARCHAR2(1024);




   BEGIN


      p_nbcurseur := 0;
      p_message := '';
        l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
        

      BEGIN -- Test si le dossier projet existe
      SELECT dpcode INTO l_dpcode
      FROM DOSSIER_PROJET
      WHERE dpcode=p_dpcode;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                    pack_global.recuperer_message(2031,'%s1',p_dpcode, NULL, l_msg);
                    RAISE_APPLICATION_ERROR(-20757,l_msg);
            WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20757, SQLERRM);
      END;

      BEGIN -- Test si code client MO existe
      SELECT clicode INTO l_clicode
      FROM CLIENT_MO
      WHERE clicode=p_clicode;
      EXCEPTION
            WHEN NO_DATA_FOUND THEN
               pack_global.recuperer_message(4,'%s1',p_clicode, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20757, l_msg);
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20757, SQLERRM);
      END;

      /*  On verifie si le domaine  a été modifié
      si oui nous devons mettre à jour egalement le domaine de tous les projet qui sont rattaché à ce dpcopi */
      BEGIN
        SELECT domaine into l_domaine from dossier_projet_copi where dp_copi = p_dpcopi;
        IF (l_domaine <> p_domaine)THEN
            UPDATE PROJ_INFO SET COD_DB = p_domaine where dp_copi = p_dpcopi;
        END IF;

      END;

      BEGIN

      SELECT LIBELLE, DPCODE, CLICODE, FLAGLOCK, DOMAINE, AXE_STRATEGIQUE, ETAPE, TYPE_FINANCEMENT, to_char(QUOTE_PART,'FM0D00'), DPCOPIAXEMETIER
      into old_LIBELLE, old_DPCODE, old_CLICODE, old_FLAGLOCK, old_DOMAINE, old_AXE_STRATEGIQUE, old_ETAPE, old_TYPE_FINANCEMENT, old_QUOTE_PART, old_DPCOPIAXEMETIER
      from dossier_projet_copi
      WHERE dp_copi = UPPER(p_dpcopi);


      -- SEL 10/06/2014 PPM 58143 QC 1612
      BEGIN
      SELECT libelle into old_AXE_STRATEGIQUE_LIBELLE from copi_axe_strategique where numero=old_AXE_STRATEGIQUE;
      SELECT libelle into AXE_STRATEGIQUE_LIBELLE from copi_axe_strategique where numero=p_AXE_STRATEGIQUE;
      END;
         
          UPDATE dossier_projet_copi SET libelle  = p_libelle,
                                     dpcode  = TO_NUMBER(p_dpcode),
                                     clicode   = TO_NUMBER(p_clicode),
                                     flaglock = decode( p_flaglock, 1000000, 0, p_flaglock + 1),
                                     domaine = p_domaine,
                                      axe_strategique =to_number(p_AXE_STRATEGIQUE),
                        etape=to_number(p_ETAPE),
                        type_financement=to_number(p_TYPE_FINANCEMENT),
                        quote_part=to_number(p_QUOTE_PART),
                        --PPM 65186 : Adding RTRIM function to remove space from axemetier -- START
                        dpcopiaxemetier=RTRIM(p_dpcopiaxemetier)
                        --PPM 65186 : Adding RTRIM function to remove space from axemetier -- END
          WHERE dp_copi = UPPER(p_dpcopi)
           AND flaglock = p_flaglock;


         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'LIBELLE',old_libelle,p_libelle,'Modification du libelle');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'DPCODE',old_dpcode,p_dpcode,'Modification du code dossier projet');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'CLICODE',old_clicode,p_clicode,'Modification du code client');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'DOMAINE',old_domaine,p_domaine,'Modification du code domaine');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'AXE_STRATEGIQUE',old_axe_strategique||'-'||old_AXE_STRATEGIQUE_LIBELLE,p_AXE_STRATEGIQUE||'-'||AXE_STRATEGIQUE_LIBELLE,'Modification du code enveloppe budgétaire');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'ETAPE',old_etape,p_ETAPE,'Modificationdu code etape');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'TYPE_FINANCEMENT',old_type_financement,p_TYPE_FINANCEMENT,'Modification du code type financemennt');
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'QUOTE_PART',old_quote_part,to_char(p_QUOTE_PART,'FM0D00'),'Modification du la quote_part');
         --PPM 65186 : Adding RTRIM function to remove space from axemetier -- START
         maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'DPCOPIAXEMETIER',old_dpcopiaxemetier,RTRIM(p_dpcopiaxemetier),'Modification de l''axe metier dpcopi');
         
         --PPM 65186 : Adding RTRIM function to remove space from axemetier -- END
         pack_global.recuperer_message(21085, '%s1', p_dpcopi, NULL, l_msg);
         p_message := l_msg;
      EXCEPTION
      
           WHEN OTHERS THEN
              raise_application_error(-20757, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         raise_application_error( -20757, l_msg );
      ELSE
        pack_global.recuperer_message(21085, '%s1', p_dpcopi, NULL, l_msg);
        p_message := l_msg;
      END IF;

   END update_dpcopi;


   PROCEDURE delete_dpcopi (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                    )IS

      l_msg VARCHAR(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
      l_user varchar2(7);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
       l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      BEGIN
         DELETE FROM dossier_projet_copi
                WHERE dp_copi = p_dpcopi
                 AND flaglock = p_flaglock;

        maj_dossier_projet_copi_logs (UPPER(p_dpcopi), l_user, 'TOUTES','TOUTES','','Suppression du DP COPI');

      EXCEPTION
         WHEN referential_integrity THEN
               pack_global.recuperer_message(21101,'%s1',p_dpcopi, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20757, l_msg);
            --pack_global.recuperation_integrite(-2292);
            --raise_application_error(-20997,SQLERRM);



         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         raise_application_error( -20757, l_msg );
      ELSE
         pack_global.recuperer_message(21086, '%s1', p_dpcopi, NULL, l_msg);
       p_message := l_msg;
      END IF;

   END delete_dpcopi;


   PROCEDURE select_dpcopi (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_userid             IN VARCHAR2,
                                     p_curdossier_projet_copi IN OUT dossier_projet_copiCurType,
                                     p_nbcurseur             OUT INTEGER,
                                     p_message               OUT VARCHAR2
                                    ) IS

      l_msg VARCHAR(1024);
      l_domaine VARCHAR2(20);


   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

    -- Test pour verifier que le dpcopi est valide
    IF p_dpcopi is NULL THEN
         Pack_Global.recuperer_message(21111, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20208, l_msg );
    END IF;


      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN


         OPEN p_curdossier_projet_copi FOR
              SELECT dp.dp_copi p_dpcopi
                   , dp.libelle p_libelle
                   , dp.dpcode  p_dpcode
                   , dp.clicode p_clicode
                   , dp.flaglock p_flaglock
                   , dp.domaine p_domaine_code
                   , d.LIBELLE  p_domaine_lib
                   ,to_char(dp.axe_strategique) p_axe_strategique
                   ,to_char(dp.etape) p_etape
                   ,to_char(dp.type_financement) p_type_financement
                   ,to_char(dp.quote_part,'FM0D00') p_quote_part
                   ,dp.dpcopiaxemetier p_dpcopiaxemetier --PPM 61919
              FROM dossier_projet_copi dp, domaine d
              WHERE dp.dp_copi = p_dpcopi
              and dp.domaine = d.code_d;

            EXCEPTION
            WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);

         END;

      -- en cas absence
      -- p_message := 'Le code dossier projet n''existe pas';

      pack_global.recuperer_message(21087, '%s1', p_dpcopi, NULL, l_msg);
      p_message := l_msg;


   END select_dpcopi;


 PROCEDURE select_dpcopi_info_budget (p_dpcopi   IN  dossier_projet_copi.dp_copi%TYPE,
                                     p_userid             IN VARCHAR2,
                                     p_libelle OUT VARCHAR2,
                                     p_curseur IN OUT dpcopi_info_budget_copiCurType,
                                     p_message               OUT VARCHAR2
                                    ) IS

             vari number;
                   l_msg VARCHAR(1024);


      BEGIN



          BEGIN
            select libelle into p_libelle from dossier_projet_copi where dp_copi = p_dpcopi;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_libelle:='Libellé inconnu' ;

          END;

          BEGIN
            OPEN p_curseur FOR
              SELECT b.annee                p_annee
                   , to_char(b.date_copi,'DD/MM/YYYY')  p_date_copi
                   , b.metier               p_metier
                   , to_char(b.jh_couttotal,'FM999999990.00')        p_JH_COUTTOTAL
                   , to_char(b.jh_arbdemandes,'FM999999990.00')       p_JH_ARBDEMANDES
                   , to_char(b.jh_arbdecides,'FM999999990.00')        p_JH_ARBDECIDES
                   , to_char(b.jh_cantdemandes,'FM999999990.00')      p_JH_CANTDEMANDES
                   , to_char(b.jh_cantdecides,'FM999999990.00')       p_JH_CANTDECIDES
                   , d.libelle              p_TYPE_DEMANDE
                    ,f.libelle_four_copi    p_FOUR_COPI

              FROM budget_copi b, copi_four f, copi_type_demande d
              WHERE b.dp_copi = p_dpcopi
               and b.code_four_copi = f.code_four_copi
              and b.code_type_demande = d.code_type_demande
              order by b.date_copi;



            EXCEPTION
            WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
            END;

              pack_global.recuperer_message(21146, '%s1', p_dpcopi, NULL, l_msg);
      p_message := l_msg;


     END select_dpcopi_info_budget;


    PROCEDURE update_dpcopi_info_budget (p_dpcopi_prov   IN  dossier_projet_copi.dp_copi%TYPE,
                                         p_dpcopi_def   IN  dossier_projet_copi.dp_copi%TYPE,
                                         p_dpcode    IN dossier_projet.dpcode%Type,
                                       p_userid             IN VARCHAR2,
                                        p_message               OUT VARCHAR2
                                    ) IS

                l_msg VARCHAR(1024);
                l_error NUMBER;
                   l_user VARCHAR2(7);

 BEGIN
    l_msg:='';
    l_error := 0;


        l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

    /* Verification de la presence du dp oopi provisoire */
    BEGIN
        select 1 into l_error from dossier_projet_copi where dp_copi = p_dpcopi_prov;
          l_error := 0;
    EXCEPTION
    /*cas où le dp copi provisoire n'existe pas on retourne un message d'erreur*/
    WHEN NO_DATA_FOUND THEN
        pack_global.recuperer_message(21146, '%s1', p_dpcopi_prov, NULL, l_msg);
        p_message := l_msg;
        l_error := 1;
    END;

    /* Verification de la presence du dpcode */
        IF (l_error = 0) THEN
        BEGIN
            select 1 into l_error from dossier_projet where dpcode = p_dpcode;
              l_error := 0;
        EXCEPTION
        /* cas où le dpcode n'existe pas on retourne un message d'erreur*/
        WHEN NO_DATA_FOUND THEN
            pack_global.recuperer_message(21147, '%s1', p_dpcode, NULL, l_msg);
            p_message := l_msg;
            l_error := 1;

        END;

     /* si le dp copi provisoire existe ainsi que le dpcode on insère dans la table le dp copi definitif */
    IF (l_error = 0) THEN
        BEGIN
           insert into dossier_projet_copi (dp_copi, libelle, dpcode, clicode, flaglock, domaine,AXE_STRATEGIQUE, ETAPE, TYPE_FINANCEMENT, QUOTE_PART, dpcopiaxemetier) select p_dpcopi_def, libelle, dpcode, clicode, flaglock, domaine,AXE_STRATEGIQUE, ETAPE, TYPE_FINANCEMENT, QUOTE_PART, dpcopiaxemetier from dossier_projet_copi where dp_copi = p_dpcopi_prov;
        EXCEPTION
        /* cas où le dp copi definitif existe dejà on retourne un message d'erreur*/
        WHEN DUP_VAL_ON_INDEX THEN
            pack_global.recuperer_message(21144, '%s1', p_dpcopi_def, NULL, l_msg);
            p_message := l_msg;
            l_error := 1;

        END;

         /* on met à jour les tables si les insertions se sont bien passées */
        IF (l_error = 0) THEN
            maj_dossier_projet_copi_logs (p_dpcopi_prov, l_user, 'DP_COPI','',p_dpcopi_def,'Création du dp_copi définitif');
            update dossier_projet_copi set dpcode = p_dpcode where dp_copi = p_dpcopi_def;
            update budget_copi set dp_copi = p_dpcopi_def where dp_copi = p_dpcopi_prov;
            update proj_info set dp_copi = p_dpcopi_def where dp_copi = p_dpcopi_prov;
            update copi_notation set dp_copi = p_dpcopi_def where dp_copi = p_dpcopi_prov;
            maj_dossier_projet_copi_logs (p_dpcopi_prov, l_user, 'TOUTES',p_dpcopi_prov,p_dpcopi_def,'Transfert données ' ||p_dpcopi_prov|| ' --> ' ||p_dpcopi_def);
            COMMIT;
            delete from dossier_projet_copi where dp_copi = p_dpcopi_prov;
            maj_dossier_projet_copi_logs (p_dpcopi_prov, l_user, 'DP_COPI','',p_dpcopi_prov,'Suppression du dp_copi provisoire');

        pack_global.recuperer_message(21145, NULL, NULL, NULL, l_msg);
        p_message := l_msg;

        END IF;

       END IF;

    END IF;

 END update_dpcopi_info_budget;

 --Procédure pour remplir les logs de MAJ du  dossier projet copi
PROCEDURE maj_dossier_projet_copi_logs (p_dp_copi     IN DOSSIER_PROJET_COPI_LOGS.dp_copi%TYPE,
                              p_user_log    IN VARCHAR2,
                              p_colonne        IN VARCHAR2,
                              p_valeur_prec    IN VARCHAR2,
                              p_valeur_nouv    IN VARCHAR2,
                              p_commentaire    IN VARCHAR2
                              ) IS
BEGIN

    IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
        INSERT INTO DOSSIER_PROJET_COPI_LOGS
            (dp_copi, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
        VALUES
            (p_dp_copi, SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);

    END IF;
    -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

END maj_dossier_projet_copi_logs;

PROCEDURE lister_dpcopi (p_userid     IN VARCHAR2,
                          p_curDpCopi IN OUT dpcopiCurType
                              ) IS

  l_msg VARCHAR(1024);
   BEGIN

      BEGIN
         OPEN  p_curDpCopi FOR
          SELECT
            dp_copi ,
            dp_copi || ' -' || libelle
          FROM DOSSIER_PROJET_COPI ORDER BY libelle
         ;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_dpcopi;

END pack_copi;
/