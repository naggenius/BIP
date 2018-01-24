create or replace
PACKAGE     Pack_Proj_Info AS

   TYPE proj_info_ViewType IS RECORD (     ICPI PROJ_INFO.ICPI%TYPE,
                       ILIBEL       PROJ_INFO.ILIBEL%TYPE,
                    DESCR        PROJ_INFO.DESCR%TYPE,
                    IMOP         PROJ_INFO.IMOP%TYPE,
                    CLICODE      PROJ_INFO.CLICODE%TYPE,
                    ICME         PROJ_INFO.ICME%TYPE,
                    CODSG        PROJ_INFO.CODSG%TYPE,
                    ICODPROJ     PROJ_INFO.ICODPROJ%TYPE,
                    ICPIR        PROJ_INFO.ICPIR%TYPE,
                    STATUT       PROJ_INFO.STATUT%TYPE,
                    CADA         PROJ_INFO.CADA%TYPE,
                    DATDEM       PROJ_INFO.DATDEM%TYPE,
                    DATSTATUT    PROJ_INFO.DATSTATUT%TYPE,
                    FLAGLOCK     PROJ_INFO.FLAGLOCK%TYPE,
                    COD_DB       PROJ_INFO.COD_DB%TYPE,
                    CLILIB       CLIENT_MO.CLILIB%TYPE,
                    LIBDSG       STRUCT_INFO.LIBDSG%TYPE,
                    DATCRE       PROJ_INFO.DATCRE%TYPE,
                    LIBRPB       PROJ_INFO.LIBRPB%TYPE,
                    IDRPB        PROJ_INFO.IDRPB%TYPE,
                    DATPROD      PROJ_INFO.DATPROD%TYPE,
                    DATRPRO      PROJ_INFO.DATRPRO%TYPE,
                    CRIREG       PROJ_INFO.CRIREG%TYPE,
                    DEANRE       PROJ_INFO.DEANRE%TYPE,
                    LIBCADA      CENTRE_ACTIVITE.CLIBCA%TYPE,
                    LICODPRCA     PROJ_INFO.LICODPRCA%TYPE, -- TD 532
                    CODCAMO1     PROJ_INFO.CODCAMO1%TYPE, -- TD 532
                    CLIBCA1         PROJ_INFO.CLIBCA1%TYPE, -- TD 532
                    CDFAIN1         PROJ_INFO.CDFAIN1%TYPE, -- TD 532
                    DATVALLI1     PROJ_INFO.DATVALLI1%TYPE, -- TD 532
                    RESPVAL1     PROJ_INFO.RESPVAL1%TYPE, -- TD 532
                    CODCAMO2     PROJ_INFO.CODCAMO2%TYPE, -- TD 532
                    CLIBCA2         PROJ_INFO.CLIBCA2%TYPE, -- TD 532
                    CDFAIN2         PROJ_INFO.CDFAIN2%TYPE, -- TD 532
                    DATVALLI2     PROJ_INFO.DATVALLI2%TYPE, -- TD 532
                    RESPVAL2     PROJ_INFO.RESPVAL2%TYPE, -- TD 532
                    CODCAMO3     PROJ_INFO.CODCAMO3%TYPE, -- TD 532
                    CLIBCA3         PROJ_INFO.CLIBCA3%TYPE, -- TD 532
                    CDFAIN3         PROJ_INFO.CDFAIN3%TYPE, -- TD 532
                    DATVALLI3     PROJ_INFO.DATVALLI3%TYPE, -- TD 532
                    RESPVAL3     PROJ_INFO.RESPVAL3%TYPE, -- TD 532
                    CODCAMO4     PROJ_INFO.CODCAMO4%TYPE, -- TD 532
                    CLIBCA4         PROJ_INFO.CLIBCA4%TYPE, -- TD 532
                    CDFAIN4         PROJ_INFO.CDFAIN4%TYPE, -- TD 532
                    DATVALLI4     PROJ_INFO.DATVALLI4%TYPE, -- TD 532
                    RESPVAL4     PROJ_INFO.RESPVAL4%TYPE, -- TD 532
                    CODCAMO5     PROJ_INFO.CODCAMO5%TYPE, -- TD 532
                    CLIBCA5         PROJ_INFO.CLIBCA5%TYPE, -- TD 532
                    CDFAIN5         PROJ_INFO.CDFAIN5%TYPE, -- TD 532
                    DATVALLI5     PROJ_INFO.DATVALLI5%TYPE, -- TD 532
                    RESPVAL5     PROJ_INFO.RESPVAL5%TYPE, -- TD 532
                    DPACTIF         DOSSIER_PROJET.ACTIF%TYPE, --TD 501
                    DPLIB         DOSSIER_PROJET.DPLIB%TYPE, -- TD 501
                    DP_COPI       DOSSIER_PROJET_COPI.DP_COPI%TYPE,  -- TD 616
                    TOPENVOI     PROJ_INFO.TOPENVOI%TYPE, -- TD 673
                    DATE_ENVOI     PROJ_INFO.DATE_ENVOI%TYPE, -- TD 673
                    LIB_DOMAINE     DOMAINE.LIBELLE%TYPE, -- TD 665
                    DATE_FONCTIONNEL DATDEBEX.DATDEBEX%TYPE, --TD 910
                    DUREEAMOR    PROJ_INFO.DUREEAMOR%TYPE,
                    PROJAXEMETIER    PROJ_INFO.PROJAXEMETIER%TYPE -- PPM 61919 6.8
                                         );


   TYPE proj_infoCurType IS REF CURSOR RETURN proj_info_ViewType;

   TYPE dpcode_ViewType IS RECORD (dpcode DOSSIER_PROJET.DPCODE%TYPE);

   TYPE dpcode_CurType IS REF CURSOR RETURN dpcode_ViewType;

   PROCEDURE insert_proj_info (p_icpi          IN  PROJ_INFO.icpi%TYPE,
                               p_ilibel        IN  PROJ_INFO.ilibel%TYPE,
                               p_descr       IN  PROJ_INFO.descr%TYPE,
                               p_clicode       IN  PROJ_INFO.clicode%TYPE,
                               p_imop          IN  PROJ_INFO.imop%TYPE,
                               p_codsg         IN  VARCHAR2,
                               p_icme          IN  PROJ_INFO.icme%TYPE,
                               p_icodproj      IN  VARCHAR2,
                       p_icpir         IN  PROJ_INFO.icpir%TYPE,
                       p_statut           IN  PROJ_INFO.statut%TYPE,
                       p_datestatut     IN  VARCHAR2,
                       p_cada        IN  VARCHAR2,
                       p_datedemar    IN  VARCHAR2,
                       p_cod_db        IN  VARCHAR2,
                               p_userid        IN  VARCHAR2,
                      p_librpb        IN  VARCHAR2,
                      p_idrpb         IN  VARCHAR2,
                      p_datprod       IN  VARCHAR2,
                      p_datrpro       IN  VARCHAR2,
                      p_crireg        IN  VARCHAR2,
                      p_deanre        IN  VARCHAR2,
                      p_datcre        IN  VARCHAR2,
                                  p_licodprca        IN    VARCHAR2, -- TD 532
                               p_codcamo1        IN  VARCHAR2, -- TD 532
                               p_respval1        IN    VARCHAR2, -- TD 532
                               p_codcamo2        IN  VARCHAR2, -- TD 532
                               p_respval2        IN    VARCHAR2, -- TD 532
                               p_codcamo3        IN  VARCHAR2, -- TD 532
                               p_respval3        IN    VARCHAR2, -- TD 532
                               p_codcamo4        IN  VARCHAR2, -- TD 532
                               p_respval4        IN    VARCHAR2, -- TD 532
                               p_codcamo5        IN  VARCHAR2, -- TD 532
                               p_respval5        IN    VARCHAR2, -- TD 532
                   p_dpcopi      IN  DOSSIER_PROJET_COPI.DP_COPI%TYPE, --TD 616,
                   p_dureeamor IN PROJ_INFO.DUREEAMOR%TYPE,
                   p_projaxemetier        IN  PROJ_INFO.PROJAXEMETIER%TYPE,
                                           p_nbcurseur     OUT INTEGER,
                               p_message       OUT VARCHAR2
                              );

   PROCEDURE update_proj_info (p_icpi       IN  PROJ_INFO.icpi%TYPE,
                               p_ilibel     IN  PROJ_INFO.ilibel%TYPE,
                               p_descr      IN  PROJ_INFO.descr%TYPE,
                               p_clicode    IN  PROJ_INFO.clicode%TYPE,
                               p_imop       IN  PROJ_INFO.imop%TYPE,
                               p_codsg      IN  VARCHAR2,
                               p_icme       IN  PROJ_INFO.icme%TYPE,
                               p_icodproj   IN  VARCHAR2,
                               p_icpir      IN  PROJ_INFO.icpir%TYPE,
                       p_statut        IN  PROJ_INFO.statut%TYPE,
                       p_datestatut IN  VARCHAR2,
                       p_cada        IN  VARCHAR2,
                       p_datedemar  IN  VARCHAR2,
                       p_cod_db        IN  VARCHAR2,
                               p_flaglock   IN  NUMBER,
                               p_userid     IN  VARCHAR2,
                      p_librpb     IN VARCHAR2,
                      p_idrpb      IN VARCHAR2,
                      p_datprod    IN VARCHAR2,
                      p_datrpro    IN VARCHAR2,
                      p_crireg     IN VARCHAR2,
                      p_deanre     IN VARCHAR2,
                                  p_licodprca        IN    VARCHAR2, -- TD 532
                               p_codcamo1        IN  VARCHAR2, -- TD 532
                               p_respval1        IN    VARCHAR2, -- TD 532
                               p_codcamo2        IN  VARCHAR2, -- TD 532
                               p_respval2        IN    VARCHAR2, -- TD 532
                               p_codcamo3        IN  VARCHAR2, -- TD 532
                               p_respval3        IN    VARCHAR2, -- TD 532
                               p_codcamo4        IN  VARCHAR2, -- TD 532
                               p_respval4        IN    VARCHAR2, -- TD 532
                               p_codcamo5        IN  VARCHAR2, -- TD 532
                               p_respval5        IN    VARCHAR2, -- TD 532
                   p_dpcopi      IN  DOSSIER_PROJET_COPI.DP_COPI%TYPE,
                     p_topenvoi    PROJ_INFO.TOPENVOI%TYPE, -- TD 673
                   p_date_envoi     PROJ_INFO.DATE_ENVOI%TYPE, -- TD 673
                   p_dureeamor     PROJ_INFO.DUREEAMOR%TYPE,
                   p_projaxemetier        IN  PROJ_INFO.PROJAXEMETIER%TYPE,
                   p_updatestatut        IN  VARCHAR2,
                               p_nbcurseur  OUT INTEGER,
                               p_message    OUT VARCHAR2
                              );

   PROCEDURE delete_proj_info (p_icpi      IN  PROJ_INFO.icpi%TYPE,
                               p_flaglock  IN  NUMBER,
                               p_userid    IN  VARCHAR2,
                               p_nbcurseur OUT INTEGER,
                               p_message   OUT VARCHAR2
                              );

   FUNCTION check_cod_proj (p_icpi      IN  PROJ_INFO.icpi%TYPE
                           ) RETURN VARCHAR2 ;


  FUNCTION check_statut_proj (p_icpi IN PROJ_INFO.icpi%TYPE,
                              p_date_statut IN VARCHAR2
                           ) RETURN VARCHAR2 ;


   PROCEDURE select_proj_info (p_icpi         IN PROJ_INFO.icpi%TYPE,
                               p_userid       IN VARCHAR2,
                               p_curproj_info IN OUT proj_infoCurType,
                               p_nbcurseur       OUT INTEGER,
                               p_message         OUT VARCHAR2
                              );

PROCEDURE update_dom_bancaire(p_icodproj          IN VARCHAR2,
                    p_cod_db        IN VARCHAR2,
                    p_userid        IN VARCHAR2,
                    p_message         OUT VARCHAR2
                   );

PROCEDURE maj_proj_info_logs (p_icpi        IN PROJ_INFO_LOGS.icpi%TYPE,
                              p_user_log    IN VARCHAR2,--proj_info_logs.user_log%TYPE,
                              p_colonne        IN VARCHAR2,--proj_info_logs.colonne%TYPE,
                              p_valeur_prec    IN VARCHAR2,--proj_info_logs.valeur_prec%TYPE,
                              p_valeur_nouv    IN VARCHAR2,--proj_info_logs.valeur_nouv%TYPE,
                              p_commentaire    IN VARCHAR2--proj_info_logs.commentaire%TYPE
                              );

PROCEDURE init_donnees_ca (p_codcamo IN OUT PROJ_INFO.codcamo1%TYPE,
                           p_clibca    IN OUT PROJ_INFO.clibca1%TYPE,
                           p_cdfain    IN OUT PROJ_INFO.cdfain1%TYPE,
                           p_datvalli    IN OUT PROJ_INFO.datvalli1%TYPE
                          );

PROCEDURE maj_donnees_ca (p_old_codcamo IN PROJ_INFO.codcamo1%TYPE,
                          p_old_clibca    IN PROJ_INFO.clibca1%TYPE,
                          p_old_cdfain    IN PROJ_INFO.cdfain1%TYPE,
                          p_old_datvalli    IN PROJ_INFO.datvalli1%TYPE,
                          p_old_respval    IN PROJ_INFO.respval1%TYPE,
                          p_codcamo IN OUT PROJ_INFO.codcamo1%TYPE,
                          p_clibca    IN OUT PROJ_INFO.clibca1%TYPE,
                          p_cdfain    IN OUT PROJ_INFO.cdfain1%TYPE,
                          p_datvalli    IN OUT PROJ_INFO.datvalli1%TYPE,
                          p_respval    IN OUT PROJ_INFO.respval1%TYPE
                          );


PROCEDURE GET_DPCOPI_DOM(
                            dpcopi IN VARCHAR2,
                            cod_db OUT VARCHAR2,
                            lib_domaine OUT VARCHAR2,
                            message OUT VARCHAR2);

PROCEDURE INTEGRITE_LIGNE_DP(p_icpi         IN PROJ_INFO.icpi%TYPE,
                               p_dpcode       IN VARCHAR2,
                               p_count      OUT VARCHAR2,
                               p_message         OUT VARCHAR2
                              );

-- Retourne la date fonctionnel
PROCEDURE get_datfonctionnel ( 	p_date_fonctionnel	OUT	VARCHAR2,
				p_message		OUT 	VARCHAR2
				);
--ABN PPM 63482 - Ajout p_dpcopi
         PROCEDURE verifier_ProjAxeMetier (p_icpi          IN  PROJ_INFO.icpi%TYPE,
                                     p_projaxemetier IN PROJ_INFO.PROJAXEMETIER%TYPE,
                                     p_clicode   IN  PROJ_INFO.CLICODE%TYPE,
                                     p_codsg         IN  VARCHAR2,
                                     p_dpcopi        IN  VARCHAR2,
                                     p_type OUT VARCHAR2,
                                     p_param_id OUT VARCHAR2,
                                     p_message OUT VARCHAR2);

 PROCEDURE miseAVide_ProjAxeMetier ( type_msg   IN VARCHAR2, param_id IN VARCHAR2, p_userid IN VARCHAR2, p_message   OUT VARCHAR2 );
 -- FAD PPM 63816 : Génération fichier flux projets vers ExpenseBis
 PROCEDURE SELECT_EXPORT_EXPENSE(p_chemin_fichier IN VARCHAR2,p_nom_fichier    IN VARCHAR2);
 -- FAD PPM 63816 : Fin
 --FAD PPM 63826 : Début
 PROCEDURE VERIF_DUREEAMORTIS(p_duramort IN NUMBER, r_retour OUT VARCHAR2);
 --FAD PPM 63826 : Fin
END Pack_Proj_Info;
/
create or replace
PACKAGE BODY     Pack_Proj_Info AS

 -- PPM 61919 chapitre 6.8 la fct permet de controler le champ ProjAxeMetier
 --ABN PPM 63482 - Ajout p_dpcopi
 PROCEDURE verifier_ProjAxeMetier (p_icpi          IN  PROJ_INFO.icpi%TYPE,
                                     p_projaxemetier IN PROJ_INFO.PROJAXEMETIER%TYPE,
                                     p_clicode   IN  PROJ_INFO.CLICODE%TYPE,
                                     p_codsg         IN  VARCHAR2,
                                     p_dpcopi        IN  VARCHAR2,
                                     p_type OUT VARCHAR2,
                                     p_param_id OUT VARCHAR2,
                                     p_message OUT VARCHAR2) IS

    l_msg VARCHAR2(1024);
    l_msg_dmp VARCHAR2(1024);
    l_code_action LIGNE_PARAM_BIP.CODE_ACTION%TYPE;
    l_code_version LIGNE_PARAM_BIP.CODE_VERSION%TYPE;
    l_actif LIGNE_PARAM_BIP.ACTIF%TYPE;
    l_obligatoire LIGNE_PARAM_BIP.OBLIGATOIRE%TYPE;
    l_direction CLIENT_MO.CLIDIR%TYPE;
    l_dmpnum VARCHAR2(20);
    l_DdeType VARCHAR2(10);
    type_msg VARCHAR2(5);
    param_id VARCHAR2(20);
    l_pid VARCHAR2(20);
	l_param VARCHAR(10); -- MCH - QC 1808
	l_projaxemetier PROJ_INFO.PROJAXEMETIER%TYPE;
	count_dmpnum NUMBER;
    BEGIN


       p_message := 'valid';
      type_msg :='';
      param_id :='';


	  l_param := 'OK';
    -- HMI PPM 63308 : enlever les projets fictifs

	--FAD PPM 64794 : Test de la nouvelle régle. Si ok, alors ne rien faire.
	BEGIN
		SELECT PROJAXEMETIER INTO l_projaxemetier FROM PROJ_INFO where icpi = p_icpi;
	EXCEPTION WHEN NO_DATA_FOUND THEN
		l_projaxemetier := NULL;
	END;
	SELECT COUNT(DMPNUM) INTO count_dmpnum FROM DMP_RESEAUXFRANCE WHERE dmpnum = l_projaxemetier;
	
	IF (l_projaxemetier IS NOT NULL AND l_projaxemetier = p_projaxemetier AND count_dmpnum = 0)
	THEN
		NULL;
	ELSE
      BEGIN
      select clidir into l_direction from client_mo where clicode = p_clicode;


        select code_action, code_version, actif, obligatoire
        into l_code_action, l_code_version,l_actif,l_obligatoire
        from ligne_param_bip
        where code_action = 'AXEMETIER_' || l_direction and code_version like 'PRJ%' and upper(actif) = 'O';


      EXCEPTION
        WHEN NO_DATA_FOUND THEN
         BEGIN
          select CODDIR into l_direction from STRUCT_INFO where CODSG = p_codsg;
        select code_action, code_version, actif, obligatoire
        into l_code_action, l_code_version,l_actif,l_obligatoire
        from ligne_param_bip
        where code_action = 'AXEMETIER_' || l_direction and code_version like 'PRJ%' and upper(actif) = 'O';


       EXCEPTION


      WHEN NO_DATA_FOUND THEN

        p_message := 'valid';
        l_param := 'absent';-- MCH : QC1808


      END;


      END;
      IF ( l_param != 'absent' ) THEN -- MCH : QC1808
      --ABN PPM 63482
      IF (p_dpcopi is not null or p_dpcopi != '') THEN
        --DBMS_OUTPUT.PUT_LINE('DANS DPCOPI  ' );
        p_message := 'valid#axe';
      ELSE IF(upper(l_obligatoire) = 'O' AND (p_projaxemetier IS NULL OR p_projaxemetier ='')) THEN
       pack_global.recuperer_message (21303, NULL, NULL, NULL, p_message);
       p_type := 'A';

      ELSE
        IF ( l_obligatoire = 'O') then
          BEGIN
            -- select dmpnum, DdeType into l_dmpnum, l_DdeType from DMP_RESEAUXFRANCE where PROJCODE = p_icpi;
            select distinct dmpnum into l_dmpnum from DMP_RESEAUXFRANCE where dmpnum = p_projaxemetier and (upper(ddetype) = 'P' or upper(ddetype) = 'E') ;
         --DBMS_OUTPUT.PUT_LINE('MSG2  ' );
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            pack_global.recuperer_message (21303, NULL, NULL, NULL, p_message);
            p_type := 'A';
          END;
        END IF;
      END IF;
      IF ( p_message = 'valid') THEN

        BEGIN

        SELECT distinct dp_copi,'D' INTO p_param_id,p_type FROM dossier_projet_copi where dpcopiaxemetier = p_projaxemetier and rownum = 1;
          pack_global.recuperer_message (21304, '%s1', p_param_id, NULL, p_message);
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            BEGIN

               SELECT distinct tache, 'T', pid INTO p_param_id,p_type, l_pid  FROM ISAC_TACHE where TacheAxeMetier = p_projaxemetier and rownum = 1;

               pack_global.recuperer_message (21305, '%s1', l_pid, NULL, p_message);

               --DBMS_OUTPUT.PUT_LINE('MSG5  ' );
            EXCEPTION
              WHEN NO_DATA_FOUND THEN

                -- MCH : QC1810
                BEGIN
                        SELECT distinct ecet || ',' || acta || ',' || acst || ',' || pid, 'TA', pid INTO p_param_id,p_type, l_pid  FROM TACHE where TacheAxeMetier = p_projaxemetier and rownum = 1;
                        pack_global.recuperer_message (21298, '%s1', l_pid, NULL, p_message);
                        
                      EXCEPTION
                      
                        WHEN NO_DATA_FOUND THEN
                          
                          BEGIN
                            SELECT distinct lignebipcode || ',' || etapenum || ',' || tachenum || ',' || stachenum, 'BIPS', lignebipcode INTO p_param_id,p_type, l_pid  FROM bips_activite where TacheAxeMetier = p_projaxemetier and rownum = 1;
                            pack_global.recuperer_message (21298, '%s1', l_pid, NULL, p_message);
                        -- MCH : QC1810
                          EXCEPTION
                      
                          WHEN NO_DATA_FOUND THEN
                            p_message := 'valid';
                      END;
                      END;
                
            END;

        END;
      END IF;
     END IF;
     END IF;
	END IF;
    END verifier_ProjAxeMetier;
      -- HMI : PPM 61919 chapitre 6.8 la procédure 'miseAVide' permet de réinitialiser le champ projAxeMetier 
    PROCEDURE miseAVide_ProjAxeMetier ( type_msg   IN VARCHAR2, param_id IN VARCHAR2, p_userid IN VARCHAR2, p_message   OUT VARCHAR2 ) IS
    
    l_old_dpcopiaxemetier VARCHAR2(20);
    l_old_projaxemetier VARCHAR2(20);
    l_old_tacheaxemetier VARCHAR2(20);
    l_pid VARCHAR2(20);
    l_user VARCHAR2(30);
    -- MCH QC1810
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
   PACK_COPI.maj_dossier_projet_copi_logs (UPPER(param_id), l_user, 'DPCOPIAXEMETIER',l_old_dpcopiaxemetier,null,'Mis à vide par contrôle d''unicité');
   
    elsif ( upper(type_msg) = 'T' )
    then
    select pid, tacheaxemetier into l_pid, l_old_tacheaxemetier from ISAC_TACHE where tache = param_id;
    update ISAC_TACHE set TacheAxeMetier = null where tache = param_id;
    pack_ligne_bip.maj_ligne_bip_logs (l_pid, l_user, 'Axe métier Tâche', l_old_tacheaxemetier, null, 'Mis à vide par contrôle d''unicité');
    -- MCH QC1810
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
    end if ;
    END miseAVide_ProjAxeMetier;
    PROCEDURE insert_proj_info (p_icpi          IN  PROJ_INFO.icpi%TYPE,
                                p_ilibel        IN  PROJ_INFO.ilibel%TYPE,
                                p_descr       IN  PROJ_INFO.descr%TYPE,
                                p_clicode       IN  PROJ_INFO.clicode%TYPE,
                                p_imop          IN  PROJ_INFO.imop%TYPE,
                                p_codsg         IN  VARCHAR2,
                                p_icme          IN  PROJ_INFO.icme%TYPE,
                                p_icodproj      IN  VARCHAR2,
                                p_icpir         IN  PROJ_INFO.icpir%TYPE,
                        p_statut    IN  PROJ_INFO.statut%TYPE,
                        p_datestatut     IN  VARCHAR2,
                        p_cada        IN  VARCHAR2,
                        p_datedemar     IN  VARCHAR2,
                        p_cod_db    IN  VARCHAR2,
                                p_userid        IN  VARCHAR2,
                 p_librpb           IN  VARCHAR2,
                 p_idrpb            IN  VARCHAR2,
                 p_datprod          IN  VARCHAR2,
                 p_datrpro          IN  VARCHAR2,
                 p_crireg           IN  VARCHAR2,
                 p_deanre           IN  VARCHAR2,
                 p_datcre           IN  VARCHAR2,
                                      p_licodprca        IN    VARCHAR2, -- TD 532
                                p_codcamo1        IN  VARCHAR2, -- TD 532
                                p_respval1        IN    VARCHAR2, -- TD 532
                                p_codcamo2        IN  VARCHAR2, -- TD 532
                                p_respval2        IN    VARCHAR2, -- TD 532
                                p_codcamo3        IN  VARCHAR2, -- TD 532
                                p_respval3        IN    VARCHAR2, -- TD 532
                                p_codcamo4        IN  VARCHAR2, -- TD 532
                                p_respval4        IN    VARCHAR2, -- TD 532
                                p_codcamo5        IN  VARCHAR2, -- TD 532
                                p_respval5        IN    VARCHAR2, -- TD 532
                 p_dpcopi      IN  DOSSIER_PROJET_COPI.DP_COPI%TYPE, --TD 616
                 p_dureeamor IN PROJ_INFO.DUREEAMOR%TYPE,
                  -- HMI : PPM 61919 chapitre 6.8
                  p_projaxemetier        IN  PROJ_INFO.PROJAXEMETIER%TYPE,  
                                p_nbcurseur     OUT INTEGER,
                                p_message       OUT VARCHAR2
                               ) IS

      l_msg VARCHAR2(1024);
      l_dpcode DOSSIER_PROJET.dpcode%TYPE;
      l_cada CENTRE_ACTIVITE.codcamo%TYPE;
      l_dateStatut VARCHAR2(10);
      l_icpir PROJ_INFO.icpir%TYPE;
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

      l_user VARCHAR2(30);

      l_codcamo1  PROJ_INFO.codcamo1%TYPE; -- TD 532
      l_respval1  PROJ_INFO.respval1%TYPE; -- TD 532
      l_codcamo2  PROJ_INFO.codcamo1%TYPE; -- TD 532
      l_respval2  PROJ_INFO.respval1%TYPE; -- TD 532
      l_codcamo3  PROJ_INFO.codcamo1%TYPE; -- TD 532
      l_respval3  PROJ_INFO.respval1%TYPE; -- TD 532
      l_codcamo4  PROJ_INFO.codcamo1%TYPE; -- TD 532
      l_respval4  PROJ_INFO.respval1%TYPE; -- TD 532
      l_codcamo5  PROJ_INFO.codcamo1%TYPE; -- TD 532
      l_respval5  PROJ_INFO.respval1%TYPE; -- TD 532

      l_clibca1    PROJ_INFO.CLIBCA1%TYPE; -- TD 532
      l_cdfain1    PROJ_INFO.CDFAIN1%TYPE; -- TD 532
      l_datvalli1 PROJ_INFO.DATVALLI1%TYPE; -- TD 532
      l_clibca2    PROJ_INFO.CLIBCA2%TYPE; -- TD 532
      l_cdfain2    PROJ_INFO.CDFAIN2%TYPE; -- TD 532
      l_datvalli2 PROJ_INFO.DATVALLI2%TYPE; -- TD 532
      l_clibca3    PROJ_INFO.CLIBCA3%TYPE; -- TD 532
      l_cdfain3    PROJ_INFO.CDFAIN3%TYPE; -- TD 532
      l_datvalli3 PROJ_INFO.DATVALLI3%TYPE; -- TD 532
      l_clibca4    PROJ_INFO.CLIBCA4%TYPE; -- TD 532
      l_cdfain4    PROJ_INFO.CDFAIN4%TYPE; -- TD 532
      l_datvalli4 PROJ_INFO.DATVALLI4%TYPE; -- TD 532
      l_clibca5    PROJ_INFO.CLIBCA5%TYPE; -- TD 532
      l_cdfain5    PROJ_INFO.CDFAIN5%TYPE; -- TD 532
      l_datvalli5 PROJ_INFO.DATVALLI5%TYPE; -- TD 532

      l_libstatut VARCHAR2(30);
      l_icpi PROJ_INFO.icpi%TYPE;
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
        -- Fiche 622 : contrôle identique à celui en création
        -- Olivier Duprey 15/06/2001 : on ajoute 'I' pour ITEC (fiche 240)
/*
    l_icpi := SUBSTR(p_icpi, 0, 1);
    IF ((l_icpi != 'P') AND (l_icpi != 'I')) THEN
         Pack_Global.recuperer_message(20208, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20208, l_msg );
    END IF;
*/

    IF check_cod_proj(p_icpi) = 'FALSE' THEN
        Pack_Global.recuperer_message(20208, NULL, NULL, NULL, l_msg);
        RAISE_APPLICATION_ERROR( -20208, l_msg );
    END IF;


    -- Test de la presence de p_icodproj dans la table DOSSIER_PROJET

      IF (NOT(p_icodproj IS NULL)) THEN
        BEGIN
            SELECT dpcode
            INTO l_dpcode
            FROM DOSSIER_PROJET
            WHERE dpcode = TO_NUMBER(p_icodproj);

        EXCEPTION

             WHEN NO_DATA_FOUND THEN
                Pack_Global.recuperer_message(20211, NULL, NULL, 'ICODPROJ', l_msg);
                RAISE_APPLICATION_ERROR(-20211, l_msg);

             WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;
      END IF;


      -- Si le centre d'activité est inexistant
      -- On revoi une erreur
      BEGIN
          SELECT codcamo INTO l_cada
          FROM CENTRE_ACTIVITE
          WHERE codcamo=TO_NUMBER(p_cada);
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message( 20511, NULL, NULL, 'cada', l_msg);
           RAISE_APPLICATION_ERROR( -20511, l_msg);
          WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- Test pour initialiser la date de prise en compte du statut si celui ci est renseigné
      IF ((p_statut=' '))
    THEN  l_dateStatut := '';
      ELSE  l_dateStatut := TO_CHAR(SYSDATE,'DD/MM/YYYY');
      END IF;

      -- Initialisation de ICPIR s'il est non renseigné.
          IF (p_icpir IS NULL)
            THEN  l_icpir := p_icpi;
          ELSE  l_icpir := p_icpir;
      END IF;

    -- TD 532 : Initialisation des données des CA renseignées
    l_codcamo1 := p_codcamo1;
    l_respval1 := p_respval1;
    l_codcamo2 := p_codcamo2;
    l_respval2 := p_respval2;
    l_codcamo3 := p_codcamo3;
    l_respval3 := p_respval3;
    l_codcamo4 := p_codcamo4;
    l_respval4 := p_respval4;
    l_codcamo5 := p_codcamo5;
    l_respval5 := p_respval5;


     init_donnees_ca(l_codcamo1, l_clibca1, l_cdfain1, l_datvalli1);
     init_donnees_ca(l_codcamo2, l_clibca2, l_cdfain2, l_datvalli2);
     init_donnees_ca(l_codcamo3, l_clibca3, l_cdfain3, l_datvalli3);
     init_donnees_ca(l_codcamo4, l_clibca4, l_cdfain4, l_datvalli4);
     init_donnees_ca(l_codcamo5, l_clibca5, l_cdfain5, l_datvalli5);

      -- INSERT
      BEGIN

        
         INSERT INTO PROJ_INFO (icodproj,
                                descr,
                                icpi,
                                ilibel,
                                imop,
                                icme,
                                clicode,
                                codsg,
                                icpir,
                                statut,
                                datstatut,
                                cada,
                                datdem,
                                cod_db
                ,librpb
                ,idrpb
                ,datprod
                ,datrpro
                ,crireg
                ,deanre
                ,datcre
                                  ,licodprca -- TD 532
                                  ,codcamo1 -- TD 532
                                  ,clibca1 -- TD 532
                                  ,cdfain1 -- TD 532
                                  ,datvalli1 -- TD 532
                                  ,respval1 -- TD 532
                                  ,codcamo2 -- TD 532
                                  ,clibca2 -- TD 532
                                  ,cdfain2 -- TD 532
                                  ,datvalli2 -- TD 532
                                  ,respval2 -- TD 532
                                  ,codcamo3 -- TD 532
                                  ,clibca3 -- TD 532
                                  ,cdfain3 -- TD 532
                                  ,datvalli3 -- TD 532
                                  ,respval3 -- TD 532
                                  ,codcamo4 -- TD 532
                                  ,clibca4 -- TD 532
                                  ,cdfain4 -- TD 532
                                  ,datvalli4 -- TD 532
                                  ,respval4 -- TD 532
                                  ,codcamo5 -- TD 532
                                  ,clibca5 -- TD 532
                                  ,cdfain5 -- TD 532
                                  ,datvalli5 -- TD 532
                                  ,respval5    -- TD 532,
                                ,dp_copi    -- TD 616
                                ,dureeamor
                                ,projaxemetier
                               )
         VALUES (NVL(TO_NUMBER(p_icodproj),0),
                 p_descr,
                 p_icpi,
                 p_ilibel,
                 p_imop,
                 p_icme,
                 p_clicode,
                 TO_NUMBER(p_codsg),
                 l_icpir,
                 p_statut,
                 TO_DATE(l_dateStatut,'DD/MM/YYYY'),
                 TO_NUMBER(p_cada),
                 TO_DATE(p_datedemar, 'FMMM/YYYY'),
                 p_cod_db
        ,p_librpb
        ,p_idrpb
        ,TO_DATE( p_datprod, 'MM/YYYY')
        ,TO_DATE( p_datrpro, 'MM/YYYY')
        ,p_crireg
        ,TO_DATE( p_deanre, 'YYYY')
            ,SYSDATE
                 ,p_licodprca -- TD 532
                 ,TO_NUMBER(l_codcamo1) -- TD 532
                 ,l_clibca1 -- TD 532
                 ,TO_NUMBER(l_cdfain1) -- TD 532
                 ,TO_DATE(l_datvalli1,'DD/MM/YYYY') -- TD 532
                 ,p_respval1 -- TD 532
                 ,TO_NUMBER(l_codcamo2) -- TD 532
                 ,l_clibca2 -- TD 532
                 ,TO_NUMBER(l_cdfain2) -- TD 532
                 ,TO_DATE(l_datvalli2,'DD/MM/YYYY') -- TD 532
                 ,p_respval2 -- TD 532
                 ,TO_NUMBER(l_codcamo3) -- TD 532
                 ,l_clibca3 -- TD 532
                 ,TO_NUMBER(l_cdfain3) -- TD 532
                 ,TO_DATE(l_datvalli3,'DD/MM/YYYY') -- TD 532
                 ,p_respval3 -- TD 532
                 ,TO_NUMBER(l_codcamo4)-- TD 532
                 ,l_clibca4 -- TD 532
                 ,TO_NUMBER(l_cdfain4) -- TD 532
                 ,TO_DATE(l_datvalli4,'DD/MM/YYYY') -- TD 532
                 ,p_respval4 -- TD 532
                 ,TO_NUMBER(l_codcamo5) -- TD 532
                 ,l_clibca5 -- TD 532
                 ,TO_NUMBER(l_cdfain5) -- TD 532
                 ,TO_DATE(l_datvalli5,'DD/MM/YYYY') -- TD 532
                 ,p_respval5    -- TD 532
                 ,p_dpcopi -- td 616
                 ,p_dureeamor
                 ,p_projaxemetier
                );

        -- TD 532 :  Insertions des logs en table de PROJ_INFO_LOGS
        l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

        BEGIN
            select libstatut
            into l_libstatut
            from code_statut
            where astatut = p_statut;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_libstatut := 'Pas de statut';

        END;

        maj_proj_info_logs(p_icpi, l_user, 'STATUT', '', l_libstatut, 'Création du statut');
        maj_proj_info_logs(p_icpi, l_user, 'DATDEM', '', p_datedemar, 'Création de la date de démarrage');
        maj_proj_info_logs(p_icpi, l_user, 'CADA', '', p_cada, 'Création du CADA');
        maj_proj_info_logs(p_icpi, l_user, 'CODCAMO1', '', p_codcamo1, 'Création du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'RESPVAL1', '', p_respval1, 'Création du responsable de la validation du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'CODCAMO2', '', p_codcamo2, 'Création du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'RESPVAL2', '', p_respval2, 'Création du responsable de la validation du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'CODCAMO3', '', p_codcamo3, 'Création du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'RESPVAL3', '', p_respval3, 'Création du responsable de la validation du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'CODCAMO4', '', p_codcamo4, 'Création du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'RESPVAL4', '', p_respval4, 'Création du responsable de la validation du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'CODCAMO5', '', p_codcamo5, 'Création du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'RESPVAL5', '', p_respval5, 'Création du responsable de la validation du lien avec CA');
          -- HMI : PPM 61919 chapitre 6.8
        maj_proj_info_logs(p_icpi, l_user, 'PROJAXEMETIER', '', p_projaxemetier, 'Création de l''axe métier PROJET');

-- BSA 1123
        maj_proj_info_logs(p_icpi, l_user, 'TOPENVOI', '', 'N', 'Création du top envoi');

		maj_proj_info_logs(p_icpi, l_user, 'ICODPROJ', '', p_icodproj, 'Création du dossier projet');



         -- 'Le proj_info ' || p_ipi || ' a été créé.';
         Pack_Global.recuperer_message(2032,'%s1',p_icpi, NULL, l_msg);
     p_message := l_msg;
     
      
         
          EXCEPTION

            WHEN DUP_VAL_ON_INDEX THEN
               Pack_Global.recuperer_message(20212, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20212, l_msg );

            WHEN referential_integrity THEN

               -- habiller le msg erreur

               Pack_Global.recuperation_integrite(-2291);



            WHEN OTHERS THEN

                RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

   END insert_proj_info;


    PROCEDURE update_proj_info (p_icpi          IN  PROJ_INFO.icpi%TYPE,
                                p_ilibel        IN  PROJ_INFO.ilibel%TYPE,
                                p_descr       IN  PROJ_INFO.descr%TYPE,
                                p_clicode       IN  PROJ_INFO.clicode%TYPE,
                                p_imop          IN  PROJ_INFO.imop%TYPE,
                                p_codsg         IN  VARCHAR2,
                                p_icme          IN  PROJ_INFO.icme%TYPE,
                                p_icodproj      IN  VARCHAR2,
                p_icpir         IN  PROJ_INFO.icpir%TYPE,
                           p_statut    IN  PROJ_INFO.statut%TYPE,
                           p_datestatut     IN  VARCHAR2,
                           p_cada        IN  VARCHAR2,
                           p_datedemar    IN  VARCHAR2,
                           p_cod_db    IN  VARCHAR2,
                                p_flaglock      IN  NUMBER,
                                p_userid        IN  VARCHAR2,
                   p_librpb        IN  VARCHAR2,
                   p_idrpb         IN  VARCHAR2,
                   p_datprod       IN  VARCHAR2,
                   p_datrpro       IN  VARCHAR2,
                   p_crireg        IN  VARCHAR2,
                   p_deanre        IN  VARCHAR2,
                                p_licodprca        IN    VARCHAR2, -- TD 532
                                  p_codcamo1        IN  VARCHAR2, -- TD 532
                                p_respval1        IN    VARCHAR2, -- TD 532
                                p_codcamo2        IN  VARCHAR2, -- TD 532
                                p_respval2        IN    VARCHAR2, -- TD 532
                                p_codcamo3        IN  VARCHAR2, -- TD 532
                                p_respval3        IN    VARCHAR2, -- TD 532
                                p_codcamo4        IN  VARCHAR2, -- TD 532
                                p_respval4        IN    VARCHAR2, -- TD 532
                                p_codcamo5        IN  VARCHAR2, -- TD 532
                                p_respval5        IN    VARCHAR2, -- TD 532
                p_dpcopi      IN  DOSSIER_PROJET_COPI.DP_COPI%TYPE,
                  p_topenvoi    PROJ_INFO.TOPENVOI%TYPE, -- TD 673
                   p_date_envoi     PROJ_INFO.DATE_ENVOI%TYPE, -- TD 673
                   p_dureeamor PROJ_INFO.DUREEAMOR%TYPE,
                     -- HMI : PPM 61919 chapitre 6.8
                   p_projaxemetier        IN  PROJ_INFO.PROJAXEMETIER%TYPE,
                                    -- FAD : PPM 64510
                   p_updatestatut        IN  VARCHAR2,
               
                                p_nbcurseur     OUT INTEGER,
                                p_message       OUT VARCHAR2
                              ) IS

      l_msg VARCHAR2(1024);
      l_dpcode DOSSIER_PROJET.dpcode%TYPE;
      l_cada CENTRE_ACTIVITE.codcamo%TYPE;
      l_idarpege AUDIT_STATUT.demandeur%TYPE;
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

      l_old_statut PROJ_INFO.statut%TYPE;

      l_user        LIGNE_BIP_LOGS.user_log%TYPE;

      l_actif        DOSSIER_PROJET.actif%TYPE; -- TD 532
      l_old_cada CENTRE_ACTIVITE.codcamo%TYPE; -- TD 532

      l_old_codcamo1    PROJ_INFO.CODCAMO1%TYPE; -- TD 532
      l_old_clibca1    PROJ_INFO.CLIBCA1%TYPE; -- TD 532
      l_old_cdfain1    PROJ_INFO.CDFAIN1%TYPE; -- TD 532
      l_old_datvalli1    PROJ_INFO.DATVALLI1%TYPE; -- TD 532
      l_old_respval1     PROJ_INFO.RESPVAL1%TYPE; -- TD 532
      l_old_codcamo2    PROJ_INFO.CODCAMO2%TYPE; -- TD 532
      l_old_clibca2    PROJ_INFO.CLIBCA2%TYPE; -- TD 532
      l_old_cdfain2    PROJ_INFO.CDFAIN2%TYPE; -- TD 532
      l_old_datvalli2    PROJ_INFO.DATVALLI2%TYPE; -- TD 532
      l_old_respval2    PROJ_INFO.RESPVAL2%TYPE; -- TD 532
      l_old_codcamo3    PROJ_INFO.CODCAMO3%TYPE; -- TD 532
      l_old_clibca3    PROJ_INFO.CLIBCA3%TYPE; -- TD 532
      l_old_cdfain3    PROJ_INFO.CDFAIN3%TYPE; -- TD 532
      l_old_datvalli3    PROJ_INFO.DATVALLI3%TYPE; -- TD 532
      l_old_respval3    PROJ_INFO.RESPVAL3%TYPE; -- TD 532
      l_old_codcamo4    PROJ_INFO.CODCAMO4%TYPE; -- TD 532
      l_old_clibca4    PROJ_INFO.CLIBCA4%TYPE; -- TD 532
      l_old_cdfain4    PROJ_INFO.CDFAIN4%TYPE; -- TD 532
      l_old_datvalli4    PROJ_INFO.DATVALLI4%TYPE; -- TD 532
      l_old_respval4     PROJ_INFO.RESPVAL4%TYPE; -- TD 532
      l_old_codcamo5    PROJ_INFO.CODCAMO5%TYPE; -- TD 532
      l_old_clibca5    PROJ_INFO.CLIBCA5%TYPE; -- TD 532
      l_old_cdfain5    PROJ_INFO.CDFAIN5%TYPE; -- TD 532
      l_old_datvalli5    PROJ_INFO.DATVALLI5%TYPE; -- TD 532
      l_old_respval5    PROJ_INFO.RESPVAL5%TYPE; -- TD 532

  
    
  
      l_codcamo1  PROJ_INFO.codcamo1%TYPE; -- TD 532
      l_respval1  PROJ_INFO.respval1%TYPE; -- TD 532
      l_codcamo2  PROJ_INFO.codcamo2%TYPE; -- TD 532
      l_respval2  PROJ_INFO.respval2%TYPE; -- TD 532
      l_codcamo3  PROJ_INFO.codcamo3%TYPE; -- TD 532
      l_respval3  PROJ_INFO.respval3%TYPE; -- TD 532
      l_codcamo4  PROJ_INFO.codcamo4%TYPE; -- TD 532
      l_respval4  PROJ_INFO.respval4%TYPE; -- TD 532
      l_codcamo5  PROJ_INFO.codcamo5%TYPE; -- TD 532
      l_respval5  PROJ_INFO.respval5%TYPE; -- TD 532

      l_clibca1    PROJ_INFO.clibca1%TYPE; -- TD 532
      l_cdfain1    PROJ_INFO.cdfain1%TYPE; -- TD 532
      l_datvalli1  PROJ_INFO.datvalli1%TYPE; -- TD 532
      l_clibca2    PROJ_INFO.clibca2%TYPE; -- TD 532
      l_cdfain2    PROJ_INFO.cdfain2%TYPE; -- TD 532
      l_datvalli2  PROJ_INFO.datvalli2%TYPE; -- TD 532
      l_clibca3    PROJ_INFO.clibca3%TYPE; -- TD 532
      l_cdfain3    PROJ_INFO.cdfain3%TYPE; -- TD 532
      l_datvalli3  PROJ_INFO.datvalli3%TYPE; -- TD 532
      l_clibca4    PROJ_INFO.clibca4%TYPE; -- TD 532
      l_cdfain4    PROJ_INFO.cdfain4%TYPE; -- TD 532
      l_datvalli4  PROJ_INFO.datvalli4%TYPE; -- TD 532
      l_clibca5    PROJ_INFO.clibca5%TYPE; -- TD 532
      l_cdfain5    PROJ_INFO.cdfain5%TYPE; -- TD 532
      l_datvalli5  PROJ_INFO.datvalli5%TYPE; -- TD 532,

      l_old_topenvoi    PROJ_INFO.TOPENVOI%TYPE;       -- QC 1123,
      l_old_date_envoi  PROJ_INFO.DATE_ENVOI%TYPE;   -- QC 1123
      var_date_envoi    PROJ_INFO.DATE_ENVOI%TYPE;     -- QC 1123

    
     -- HMI : PPM 61919 chapitre 6.8
       l_old_projaxemetier    PROJ_INFO.PROJAXEMETIER%TYPE;
       
      l_old_datdem VARCHAR2(10);
      l_libstatut_new VARCHAR2(30);
      l_libstatut_old VARCHAR2(30);
	  l_old_icodproj PROJ_INFO.ICODPROJ%TYPE;
	  l_old_dpcode ligne_bip.dpcode%type;
    



   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      l_idarpege := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 15);

      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
      
       


    -- Les test ne respectent pas les regles du chap. 2.4.5 de la doc.
     -- ref.: id9847ac-605731 Car les verifs devraient etre sur la table proj_info et non
     -- client_mo, struct_info et dossier_proj.

    -- Test de la presence de p_icodproj dans la table DOSSIER_PROJET
    --insert into test_message message values ('yassine : ' || p_icodproj);
    IF (NOT(p_icodproj IS NULL)) THEN
         BEGIN
            SELECT dpcode
            INTO   l_dpcode
            FROM   DOSSIER_PROJET
            WHERE  dpcode = p_icodproj;

         EXCEPTION

            WHEN NO_DATA_FOUND THEN
                Pack_Global.recuperer_message(20211, NULL, NULL, 'ICODPROJ', l_msg);
                RAISE_APPLICATION_ERROR( -20211, l_msg);

             WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;
      END IF;

      -- Test sur les changements de statuts
      -- Mises à jour sur les stauts des lignes BIP liées.
      SELECT statut INTO l_old_statut
      FROM PROJ_INFO
      WHERE icpi = p_icpi AND flaglock = p_flaglock;

      -- Si le statut ancien est Vide et que le nouveau est A ou D ou R ou Q
      -- On renvoie un message d'erreur
      IF (l_old_statut IS NULL) AND ((p_statut='A') OR (p_statut='D') OR (p_statut='R') OR (p_statut='Q')) THEN
         Pack_Global.recuperer_message(20929, '%s1', NVL(l_old_statut,''), '%s2', NVL(p_statut,''), 'STATUT', l_msg);
         RAISE_APPLICATION_ERROR( -20929, l_msg);
      END IF;

      -- Si le statut ancien est D et que le nouveau est A ou R ou Vide
      -- On renvoie un message d'erreur
      IF (l_old_statut='D') AND ((p_statut='A') OR (p_statut='R') OR (p_statut IS NULL)) THEN
         Pack_Global.recuperer_message(20929, '%s1', NVL(l_old_statut,''), '%s2', NVL(p_statut,''), 'STATUT', l_msg);
         RAISE_APPLICATION_ERROR( -20929, l_msg);
      END IF;

      -- Si le statut ancien est Q (Démarré sans immo) et que le nouveau est R (Abandonné sans immo) ou A ou Vide
      -- On renvoie un message d'erreur
      IF (l_old_statut='Q') AND ((p_statut='R') OR (p_statut='A') OR (p_statut IS NULL)) THEN
         Pack_Global.recuperer_message(20929, '%s1', NVL(l_old_statut,''), '%s2', NVL(p_statut,''), 'STATUT', l_msg);
         RAISE_APPLICATION_ERROR( -20929, l_msg);
      END IF;

      -- Si le statut ancien est A et que le nouveau est D ou Q ou Vide
      -- On renvoie un message d'erreur
      IF (l_old_statut='A') AND ((p_statut='D') OR (p_statut='Q') OR (p_statut IS NULL)) THEN
         Pack_Global.recuperer_message(20929, '%s1', NVL(l_old_statut,''), '%s2', NVL(p_statut,''), 'STATUT', l_msg);
         RAISE_APPLICATION_ERROR( -20929, l_msg);
      END IF;

      -- Si le statut ancien est R (Abandonné sans immo) et que le nouveau est Q (Démarré sans immo) ou D ou Vide
      -- On renvoie un message d'erreur
      IF (l_old_statut='R') AND ((p_statut='Q') OR (p_statut='D') OR (p_statut IS NULL)) THEN
         Pack_Global.recuperer_message(20929, '%s1', NVL(l_old_statut,''), '%s2', NVL(p_statut,''), 'STATUT', l_msg);
         RAISE_APPLICATION_ERROR( -20929, l_msg);
      END IF;

      -- Si le statut ancien est N (Non amortissable) et que le nouveau est D (Démarré) ou A (Abandonné) ou Vide
      -- On renvoie un message d'erreur
      /*IF (l_old_statut='N') AND ((p_statut='D') OR (p_statut='A') OR (p_statut IS NULL)) THEN
         Pack_Global.recuperer_message(20929, '%s1', NVL(l_old_statut,''), '%s2', NVL(p_statut,''), 'STATUT', l_msg);
         RAISE_APPLICATION_ERROR( -20929, l_msg);
      END IF; */


    -- PPM 50589, ajout vérification du consommé en fonction du statut et de la date.
    IF check_statut_proj(p_icpi, p_datedemar) = 'TRUE' THEN
         Pack_Global.recuperer_message(21280, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20929, l_msg);
    END IF;








    -- TD 532 : Ajout d'une contrainte sur le dossier projet ne doit pas fermé (ie : dossier_projet.actif <> 'O')
    -- Si le statut passe à A (Abandonné) ou D (Démarré) ou Q (Démarré sans immo) ou R (Abandonné sans immo)
    -- On renvoie un message d'erreur si le Dossier Projet est fermé (ie : si dossier_projet.actif = 'N')

    -- Le 14/04/2008 EVI Mise en commentaire: contraire a la fiche 501
    /*SELECT dp.actif
    INTO   l_actif
    FROM   DOSSIER_PROJET dp, PROJ_INFO pi
    WHERE pi.ICODPROJ = dp.DPCODE
    AND pi.ICPI = p_icpi
    AND pi.FLAGLOCK = p_flaglock;

    IF (((p_statut='A') OR (p_statut='D') OR (p_statut='R') OR (p_statut='Q')) AND (l_actif='N')) THEN
        -- Affichage du message : Modification impossible : ce projet est rattaché à un dossier projet fermé
        Pack_Global.recuperer_message(21059, NULL, NULL, NULL, l_msg);
        RAISE_APPLICATION_ERROR( -20999, l_msg);
    END IF;*/


    -- YSB : 11/03/2010
      DECLARE
        CURSOR C_DP IS
          SELECT pid,dpcode  FROM LIGNE_BIP
          WHERE icpi = p_icpi
          AND dpcode in (select ICODPROJ from proj_info where  icpi=p_icpi);
      BEGIN
      FOR ONE_DP IN C_DP LOOP

              BEGIN
				select dpcode into l_old_dpcode from ligne_bip l where l.pid = ONE_DP.pid;
                UPDATE ligne_bip a
                SET  a.dpcode = p_icodproj
                WHERE a.pid = ONE_DP.pid;
                IF SQL%NOTFOUND THEN
                        --la ligne n'existe pas, on l'insère dans la table
                        --insert into test_message message values ('aucune ligne bip n''a été trouvé');  commit;
                        RAISE_APPLICATION_ERROR( -20208, 'aucune ligne bip trouvé l''update a échoué' );
                END IF;
        --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
			--Correction de la QC 1946, par SZ (nouvelle dpcode<>ancienne dpcode)
			--INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
              --  VALUES (ONE_DP.pid, CURRENT_TIMESTAMP, l_user, 'DPCODE',l_old_dpcode,p_icodproj,'MAJ du dossier projet');
				pack_ligne_bip.maj_ligne_bip_logs(ONE_DP.pid, l_user, 'DPCODE', TO_CHAR(l_old_dpcode), p_icodproj, 'MAJ du dossier projet');				
              END;
        COMMIT;
      END LOOP;
      END;

--curseur qui ramene les lignes bip rattachees au projet ayant un statut = 'O'
      DECLARE
      CURSOR C_PID IS
          SELECT pid FROM LIGNE_BIP
          WHERE astatut = 'O'
          AND icpi=p_icpi;
      BEGIN
      -- Si le statut ancien est O et que le nouveau est D
      -- On passe toute les lignes du projet en statut O au statut D
      IF (l_old_statut='O') AND (p_statut='D') THEN

       -- On loggue le changement de statut
       --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Statut', astatut, 'D', 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE astatut = 'O' AND icpi=p_icpi
           );

       -- On loggue la nouvelle date de statut
       --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Date statut', TO_CHAR(adatestatut, 'MM/YYYY'), p_datedemar, 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE astatut = 'O' AND icpi=p_icpi
           );


              --on met à jour les donnees d'audit
              FOR ONE_PID IN C_PID LOOP
              BEGIN
                UPDATE AUDIT_STATUT a
                SET     a.pid = ONE_PID.pid,
                    a.date_demande = SYSDATE,
                    a.demandeur=l_idarpege,
                    a.commentaire='Projet ' || p_icpi || ' démarré'
                WHERE a.pid = ONE_PID.pid;

            IF SQL%NOTFOUND THEN
                    --la ligne n'existe pas, on l'insère dans la table
                    INSERT INTO AUDIT_STATUT (pid,date_demande,demandeur,commentaire)
                    VALUES (ONE_PID.pid,SYSDATE,l_idarpege,'Projet ' || p_icpi || ' démarré');
            END IF;
        END;
        COMMIT;
        END LOOP;

    -- mise à jour des lignes bip rattachees au projet
             BEGIN
               UPDATE LIGNE_BIP
               SET     astatut = 'D',
                   adatestatut = TO_DATE(p_datedemar, 'FMMM/YYYY')
               WHERE astatut = 'O'
                 AND icpi = p_icpi;
             EXCEPTION
               WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
             END;

      END IF;



      -- Si le statut ancien est O et que le nouveau est A
      -- On passe toutes les lignes du projet en statut O au statut A
      IF (l_old_statut='O') AND (p_statut='A') THEN

          --on met à jour les donnees d'audit
              FOR ONE_PID IN C_PID LOOP
              BEGIN
                UPDATE AUDIT_STATUT a
                SET     a.pid = ONE_PID.pid,
                    a.date_demande = SYSDATE,
                    a.demandeur=l_idarpege,
                    a.commentaire='Projet ' || p_icpi || ' abandonné'
                WHERE a.pid = ONE_PID.pid;

            IF SQL%NOTFOUND THEN
                    --la ligne n'existe pas, on l'insère dans la table
                    INSERT INTO AUDIT_STATUT (pid,date_demande,demandeur,commentaire)
                    VALUES (ONE_PID.pid,SYSDATE,l_idarpege,'Projet ' || p_icpi || ' abandonné');
            END IF;
        END;
        COMMIT;
        END LOOP;

          --mise a jour des lignes bip rattachees au projet
         BEGIN

       -- On loggue le changement de statut
       --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Statut', astatut, 'A', 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE astatut = 'O' AND icpi=p_icpi
           );

       -- On loggue la nouvelle date de statut
       --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Date statut', TO_CHAR(adatestatut, 'MM/YYYY'), p_datedemar, 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE astatut = 'O' AND icpi=p_icpi
           );

           UPDATE LIGNE_BIP
           SET     astatut = 'A',
               adatestatut = TO_DATE(p_datedemar, 'FMMM/YYYY')
           WHERE astatut = 'O'
             AND icpi = p_icpi;
         EXCEPTION
           WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;
      END IF;
      END; -- END CURSOR 'O'





--curseur qui ramene les lignes bip rattachees au projet ayant un statut = 'N'
      DECLARE
      CURSOR C_PID IS
          SELECT pid FROM LIGNE_BIP
          WHERE icpi=p_icpi;
      BEGIN
      -- Si le statut ancien est N et que le nouveau est Q (Démarré sans amortissement)
      IF (l_old_statut='N') AND (p_statut='Q') THEN

       -- On loggue le changement de statut
       --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Statut', astatut, 'Q', 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE icpi=p_icpi
           );

       -- On loggue la nouvelle date de statut
       --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Date statut', TO_CHAR(adatestatut, 'MM/YYYY'), p_datedemar, 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE icpi=p_icpi
           );


              --on met à jour les donnees d'audit
              FOR ONE_PID IN C_PID LOOP
              BEGIN
                UPDATE AUDIT_STATUT a
                SET     a.pid = ONE_PID.pid,
                    a.date_demande = SYSDATE,
                    a.demandeur=l_idarpege,
                    a.commentaire='Projet ' || p_icpi || ' Démarré sans immo'
                WHERE a.pid = ONE_PID.pid;

            IF SQL%NOTFOUND THEN
                    --la ligne n'existe pas, on l'insère dans la table
                    INSERT INTO AUDIT_STATUT (pid,date_demande,demandeur,commentaire)
                    VALUES (ONE_PID.pid,SYSDATE,l_idarpege,'Projet ' || p_icpi || ' démarré');
            END IF;
        END;
        COMMIT;
        END LOOP;

    -- mise à jour des lignes bip rattachees au projet
             BEGIN
               UPDATE LIGNE_BIP
               SET   adatestatut = TO_DATE(p_datedemar, 'FMMM/YYYY'),
                   topfer = 'O'
               WHERE icpi = p_icpi;

               UPDATE LIGNE_BIP
               SET   astatut = 'Q'
               WHERE  icpi = p_icpi;

             EXCEPTION
               WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
             END;

      END IF;



      -- Si le statut ancien est N et que le nouveau est R
      IF (l_old_statut='N') AND (p_statut='R') THEN

          --on met à jour les donnees d'audit
              FOR ONE_PID IN C_PID LOOP
              BEGIN
                UPDATE AUDIT_STATUT a
                SET     a.pid = ONE_PID.pid,
                    a.date_demande = SYSDATE,
                    a.demandeur=l_idarpege,
                    a.commentaire='Projet ' || p_icpi || ' abandonné sans immo'
                WHERE a.pid = ONE_PID.pid;

            IF SQL%NOTFOUND THEN
                    --la ligne n'existe pas, on l'insère dans la table
                    INSERT INTO AUDIT_STATUT (pid,date_demande,demandeur,commentaire)
                    VALUES (ONE_PID.pid,SYSDATE,l_idarpege,'Projet ' || p_icpi || ' abandonné sans immo');
            END IF;
        END;
        COMMIT;
        END LOOP;

          --mise a jour des lignes bip rattachees au projet
         BEGIN

       -- On loggue le changement de statut
       --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Statut', astatut, 'R', 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE icpi=p_icpi
           );

       -- On loggue la nouvelle date de statut
       --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Date statut', TO_CHAR(adatestatut, 'MM/YYYY'), p_datedemar, 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE icpi=p_icpi
           );

           UPDATE LIGNE_BIP
           SET     adatestatut = TO_DATE(p_datedemar, 'FMMM/YYYY'),
               topfer = 'O'
           WHERE icpi = p_icpi;

           UPDATE LIGNE_BIP
           SET     astatut = 'R'
           WHERE icpi = p_icpi
           AND (typproj ='1 ' OR typproj ='2 ');
         EXCEPTION
           WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;
      END IF;

   -- Si le statut ancien est Q et que le nouveau est N
      IF (l_old_statut='Q') AND (p_statut='N') THEN

       -- On loggue le changement de statut
	   --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Statut', astatut, 'N', 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE icpi=p_icpi
           );

       -- On loggue la nouvelle date de statut
       --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Date statut', TO_CHAR(adatestatut, 'MM/YYYY'), NULL, 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE icpi=p_icpi
           );


              --on met à jour les donnees d'audit
              FOR ONE_PID IN C_PID LOOP
              BEGIN
                UPDATE AUDIT_STATUT a
                SET     a.pid = ONE_PID.pid,
                    a.date_demande = SYSDATE,
                    a.demandeur=l_idarpege,
                    a.commentaire='Projet ' || p_icpi || ' démarré sans immo'
                WHERE a.pid = ONE_PID.pid;

            IF SQL%NOTFOUND THEN
                    --la ligne n'existe pas, on l'insère dans la table
                    INSERT INTO AUDIT_STATUT (pid,date_demande,demandeur,commentaire)
                    VALUES (ONE_PID.pid,SYSDATE,l_idarpege,'Projet ' || p_icpi || ' démarré');
            END IF;
        END;
        COMMIT;
        END LOOP;

    -- mise à jour des lignes bip rattachees au projet
             BEGIN
               UPDATE LIGNE_BIP
               SET   adatestatut = NULL
               WHERE icpi = p_icpi;
             EXCEPTION
               WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
             END;

      END IF;

 -- Si le statut ancien est R et que le nouveau est N
      IF (l_old_statut='R') AND (p_statut='N') THEN

          --on met à jour les donnees d'audit
              FOR ONE_PID IN C_PID LOOP
              BEGIN
                UPDATE AUDIT_STATUT a
                SET     a.pid = ONE_PID.pid,
                    a.date_demande = SYSDATE,
                    a.demandeur=l_idarpege,
                    a.commentaire='Projet ' || p_icpi || ' abandonné sans immo'
                WHERE a.pid = ONE_PID.pid;

            IF SQL%NOTFOUND THEN
                    --la ligne n'existe pas, on l'insère dans la table
                    INSERT INTO AUDIT_STATUT (pid,date_demande,demandeur,commentaire)
                    VALUES (ONE_PID.pid,SYSDATE,l_idarpege,'Projet ' || p_icpi || ' abandonné sans immo');
            END IF;
        END;
        COMMIT;
        END LOOP;

          --mise a jour des lignes bip rattachees au projet
         BEGIN

       -- On loggue le changement de statut
       --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Statut', astatut, 'N', 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE icpi=p_icpi
           );

       -- On loggue la nouvelle date de statut
       --PPM 61077 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
           INSERT INTO LIGNE_BIP_LOGS (pid, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
           (SELECT pid, CURRENT_TIMESTAMP, l_user, 'Date statut', TO_CHAR(adatestatut, 'MM/YYYY'), NULL, 'MAJ du statut du projet'
            FROM LIGNE_BIP
            WHERE icpi=p_icpi
           );

           UPDATE LIGNE_BIP
           SET     adatestatut = NULL
           WHERE icpi = p_icpi;

         EXCEPTION
           WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;
      END IF;
      
      --FAD PPM 64510

        If (L_Old_Statut='O') And (P_Statut='Q') And (p_updatestatut='O') Then
         --mise a jour des lignes bip rattachees au projet
         Begin

       -- On loggue le changement de statut
       --PPM 64510 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
		-- QC 1947 : MHA
          DECLARE
            CURSOR C_PID_DETAIL IS
            SELECT pid, adatestatut,astatut
            From Ligne_Bip
            WHERE icpi=p_icpi and astatut='O';
          BEGIN
          FOR ONE_PID_DETAIL IN C_PID_DETAIL LOOP
          pack_ligne_bip.maj_ligne_bip_logs(ONE_PID_DETAIL.pid, l_user, 'Statut', ONE_PID_DETAIL.astatut, 'Q', 'MAJ du statut du projet');
          pack_ligne_bip.maj_ligne_bip_logs(ONE_PID_DETAIL.pid, l_user, 'Date statut', TO_CHAR(ONE_PID_DETAIL.adatestatut, 'MM/YYYY'), p_datedemar, 'MAJ du statut du projet');
          END LOOP;
          END;

          
           
           Update Ligne_Bip
           Set     Astatut = 'Q' , adatestatut = TO_DATE(p_datedemar, 'FMMM/YYYY')
           WHERE icpi = p_icpi and astatut='O';

         Exception
           When Others Then
                RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         End;
        
      END IF;


      END; -- END CURSOR 'N'





      -- Si le centre d'activité est inexistant
      -- On revoi une erreur
      BEGIN
          SELECT codcamo INTO l_cada
          FROM CENTRE_ACTIVITE
          WHERE codcamo=TO_NUMBER(p_cada);
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message( 20511, NULL, NULL, 'cada', l_msg);
           RAISE_APPLICATION_ERROR( -20511, l_msg);
          WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

    -- TD 532 : Initialisation des données des CA renseignées
    -- Récupération des anciennes valeurs avant le update
    SELECT
          ca.codcamo
    INTO l_old_cada
    FROM CENTRE_ACTIVITE ca, PROJ_INFO pi
    WHERE ca.codcamo = pi.CADA
    AND pi.icpi = p_icpi
    AND pi.flaglock = p_flaglock;

    SELECT
        TO_NUMBER(codcamo1), clibca1,  TO_NUMBER(cdfain1), TO_DATE(datvalli1, 'DD/MM/YYYY'), respval1,
        TO_NUMBER(codcamo2), clibca2,  TO_NUMBER(cdfain2), TO_DATE(datvalli2, 'DD/MM/YYYY'), respval2,
        TO_NUMBER(codcamo3), clibca3,  TO_NUMBER(cdfain3), TO_DATE(datvalli3, 'DD/MM/YYYY'), respval3,
        TO_NUMBER(codcamo4), clibca4,  TO_NUMBER(cdfain4), TO_DATE(datvalli4, 'DD/MM/YYYY'), respval4,
        TO_NUMBER(codcamo5), clibca5,  TO_NUMBER(cdfain5), TO_DATE(datvalli5, 'DD/MM/YYYY'), respval5,
        TO_CHAR(datdem,'MM/YYYY'),
        topenvoi, date_envoi -- 1123
    INTO
        l_old_codcamo1, l_old_clibca1, l_old_cdfain1, l_old_datvalli1, l_old_respval1,
        l_old_codcamo2, l_old_clibca2, l_old_cdfain2, l_old_datvalli2, l_old_respval2,
        l_old_codcamo3, l_old_clibca3, l_old_cdfain3, l_old_datvalli3, l_old_respval3,
        l_old_codcamo4, l_old_clibca4, l_old_cdfain4, l_old_datvalli4, l_old_respval4,
        l_old_codcamo5, l_old_clibca5, l_old_cdfain5, l_old_datvalli5, l_old_respval5,
        l_old_datdem  , l_old_topenvoi, l_old_date_envoi
    FROM PROJ_INFO
    WHERE icpi = p_icpi;

    l_codcamo1 := p_codcamo1;
    l_respval1 := p_respval1;
    l_codcamo2 := p_codcamo2;
    l_respval2 := p_respval2;
    l_codcamo3 := p_codcamo3;
    l_respval3 := p_respval3;
    l_codcamo4 := p_codcamo4;
    l_respval4 := p_respval4;
    l_codcamo5 := p_codcamo5;
    l_respval5 := p_respval5;

    -- Vérification si les données sur les CA sont identiques aux précédentes et mise à jour avant le update

    maj_donnees_ca (l_old_codcamo1, l_old_clibca1, l_old_cdfain1, l_old_datvalli1, l_old_respval1,
                    l_codcamo1, l_clibca1, l_cdfain1, l_datvalli1, l_respval1);
    maj_donnees_ca (l_old_codcamo2, l_old_clibca2, l_old_cdfain2, l_old_datvalli2, l_old_respval2,
                    l_codcamo2, l_clibca2, l_cdfain2, l_datvalli2, l_respval2);
    maj_donnees_ca (l_old_codcamo3, l_old_clibca3, l_old_cdfain3, l_old_datvalli3, l_old_respval3,
                    l_codcamo3, l_clibca3, l_cdfain3, l_datvalli3, l_respval3);
    maj_donnees_ca (l_old_codcamo4, l_old_clibca4, l_old_cdfain4, l_old_datvalli4, l_old_respval4,
                    l_codcamo4, l_clibca4, l_cdfain4, l_datvalli4, l_respval4);
    maj_donnees_ca (l_old_codcamo5, l_old_clibca5, l_old_cdfain5, l_old_datvalli5, l_old_respval5,
                    l_codcamo5, l_clibca5, l_cdfain5, l_datvalli5, l_respval5);


        -- TD 673
        --  si le top envoi est NON  nous devons par conséquent supprimer la date envoi

        var_date_envoi := p_date_envoi;
        IF (p_topenvoi = 'N' )THEN
           var_date_envoi:= null;
        ELSE
            var_date_envoi := p_date_envoi;
        END IF;

   -- UPDATE
      BEGIN

       BEGIN
            select libstatut
            into l_libstatut_old
            from code_statut
            where astatut = l_old_statut;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_libstatut_old := 'Pas de statut';
        END;

        BEGIN
             select libstatut
            into l_libstatut_new
            from code_statut
            where astatut = p_statut;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_libstatut_new := 'Pas de statut';
        END;

		BEGIN
			select icodproj
			into l_old_icodproj
			from proj_info
			where icpi = p_icpi;
		END;
    
     -- HMI : PPM 61919 chapitre 6.8
    	BEGIN
			select PROJAXEMETIER
			into l_old_projaxemetier
			from proj_info
			where icpi = p_icpi;
      
      EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_old_projaxemetier := 'Pas de project axe metier';
		END;

 
         UPDATE PROJ_INFO SET icpi      = p_icpi,
                              descr         = p_descr,
                              icodproj      = NVL(TO_NUMBER(p_icodproj),0),
                              ilibel        = p_ilibel,
                              imop      = p_imop,
                              icme      = p_icme,
                              clicode     = p_clicode,
                              codsg         = TO_NUMBER(p_codsg),
                              icpir         = p_icpir,
                              statut        = p_statut,
                              datstatut  = DECODE(statut, p_statut, datstatut, trunc(SYSDATE)),
                              cada       = TO_NUMBER(p_cada),
                           datdem      = TO_DATE(p_datedemar, 'FMMM/YYYY'),
                           cod_db      = p_cod_db,
                              flaglock      = DECODE( p_flaglock, 1000000, 0, p_flaglock + 1),
                  librpb     = p_librpb,
                   idrpb       = p_idrpb,
                   datprod       = TO_DATE( p_datprod, 'MM/YYYY'),
                  datrpro    = TO_DATE( p_datrpro, 'MM/YYYY'),
                  crireg        = p_crireg,
                  deanre        = TO_DATE( p_deanre, 'YYYY')
                              ,licodprca = p_licodprca -- TD 532
                              ,codcamo1 = TO_NUMBER(l_codcamo1) -- TD 532
                              ,clibca1 = l_clibca1 -- TD 532
                              ,cdfain1 = TO_NUMBER(l_cdfain1) -- TD 532
                              ,datvalli1 = TO_DATE(l_datvalli1) -- TD 532
                              ,respval1 = l_respval1 -- TD 532
                              ,codcamo2 = TO_NUMBER(l_codcamo2) -- TD 532
                              ,clibca2 = l_clibca2 -- TD 532
                              ,cdfain2 = TO_NUMBER(l_cdfain2) -- TD 532
                              ,datvalli2 = TO_DATE(l_datvalli2) -- TD 532
                              ,respval2 = l_respval2 -- TD 532
                              ,codcamo3 = TO_NUMBER(l_codcamo3) -- TD 532
                              ,clibca3 = l_clibca3 -- TD 532
                              ,cdfain3 = TO_NUMBER(l_cdfain3) -- TD 532
                              ,datvalli3 = TO_DATE(l_datvalli3) -- TD 532
                              ,respval3 = l_respval3 -- TD 532
                              ,codcamo4 = TO_NUMBER(l_codcamo4) -- TD 532
                              ,clibca4 = l_clibca4 -- TD 532
                              ,cdfain4 = TO_NUMBER(l_cdfain4) -- TD 532
                              ,datvalli4 = TO_DATE(l_datvalli4) -- TD 532
                              ,respval4 = l_respval4 -- TD 532
                              ,codcamo5 = TO_NUMBER(l_codcamo5) -- TD 532
                              ,clibca5 = l_clibca5 -- TD 532
                              ,cdfain5 = TO_NUMBER(l_cdfain5) -- TD 532
                              ,datvalli5 = TO_DATE(l_datvalli5) -- TD 532
                              ,respval5 = l_respval5 -- TD 532
                              ,dp_copi = p_dpcopi    -- TD 616
                              ,topenvoi = p_topenvoi --td 673
                              ,date_envoi = var_date_envoi -- td 673
                              ,dureeamor = p_dureeamor
                              , PROJAXEMETIER=p_projaxemetier
                               WHERE icpi = p_icpi
           AND flaglock = p_flaglock;

        -- TD 532 :  Insertions des logs en table de PROJ_INFO_LOGS


        maj_proj_info_logs(p_icpi, l_user, 'STATUT', l_libstatut_old, l_libstatut_new, 'Modification du statut');
        maj_proj_info_logs(p_icpi, l_user, 'DATDEM', l_old_datdem, p_datedemar, 'Modification de la date de démarrage');
        maj_proj_info_logs(p_icpi, l_user, 'CADA', l_old_cada, p_cada, 'Modification du CADA');
        maj_proj_info_logs(p_icpi, l_user, 'CODCAMO1', l_old_codcamo1, l_codcamo1, 'Modification du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'RESPVAL1', l_old_respval1, l_respval1, 'Modification du responsable de la validation du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'CODCAMO2', l_old_codcamo2, l_codcamo2, 'Modification du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'RESPVAL2', l_old_respval2, l_respval2, 'Modification du responsable de la validation du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'CODCAMO3', l_old_codcamo3, l_codcamo3, 'Modification du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'RESPVAL3', l_old_respval3, l_respval3, 'Modification du responsable de la validation du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'CODCAMO4', l_old_codcamo4, l_codcamo4, 'Modification du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'RESPVAL4', l_old_respval4, l_respval4, 'Modification du responsable de la validation du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'CODCAMO5', l_old_codcamo5, l_codcamo5, 'Modification du lien avec CA');
        maj_proj_info_logs(p_icpi, l_user, 'RESPVAL5', l_old_respval5, l_respval5, 'Modification du responsable de la validation du lien avec CA');
      

-- BSA 1123
        maj_proj_info_logs(p_icpi, l_user, 'TOPENVOI', l_old_topenvoi, p_topenvoi, 'Modification du top envoi');
        maj_proj_info_logs(p_icpi, l_user, 'DATE_ENVOI', TO_CHAR(l_old_date_envoi,'DD/MM/YYYY'), TO_CHAR(var_date_envoi,'DD/MM/YYYY'), 'Modification de la date envoi');

		maj_proj_info_logs(p_icpi, l_user, 'ICODPROJ', l_old_icodproj, p_icodproj, 'Modification du dossier projet');


    
     -- HMI : PPM 61919 chapitre 6.8
    maj_proj_info_logs(p_icpi, l_user, 'PROJAXEMETIER', l_old_projaxemetier, p_projaxemetier, 'Modification de l''axe metier projet');
     
  
      EXCEPTION

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            Pack_Global.recuperation_integrite(-2291);



         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

      IF SQL%NOTFOUND THEN
         Pack_Global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
         Pack_Global.recuperer_message(2033, '%s1', p_icpi, NULL, l_msg);
         p_message := l_msg;
      END IF;

   END update_proj_info;


   PROCEDURE delete_proj_info (p_icpi      IN  PROJ_INFO.icpi%TYPE,
                               p_flaglock  IN  NUMBER,
                               p_userid    IN  VARCHAR2,
                               p_nbcurseur OUT INTEGER,
                               p_message   OUT VARCHAR2
                              ) IS

      l_msg VARCHAR2(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
      l_idarpege AUDIT_STATUT.demandeur%TYPE;
      l_user        LIGNE_BIP_LOGS.user_log%TYPE;
      l_libstatut_old VARCHAR2(30);
      l_old_datdem VARCHAR2(30);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';

      BEGIN
            BEGIN
            select c.libstatut
            into l_libstatut_old
            from code_statut c, proj_info p
            where c.astatut = p.statut
            and p.icpi = p_icpi;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_libstatut_old := 'Pas de statut';

            END;

            BEGIN
                select datdem
                into l_old_datdem
                from proj_info
                where icpi = p_icpi;
            END;

          DELETE FROM PROJ_INFO
                 WHERE icpi = p_icpi
               AND flaglock = p_flaglock;

           l_idarpege := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 15);

            l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

            maj_proj_info_logs(p_icpi, l_user, 'STATUT', l_libstatut_old, '', 'Suppression du projet');
            maj_proj_info_logs(p_icpi, l_user, 'DATDEM', l_old_datdem, '', 'Suppression du projet');

      EXCEPTION

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            Pack_Global.recuperation_integrite(-2292);

         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         Pack_Global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
         Pack_Global.recuperer_message(2034, '%s1', p_icpi, NULL, l_msg);
          --raise_application_error( -20000, 'le message est ' || l_msg );
         --raise_application_error( -20000, 'le message est ' || p_message );
         p_message := l_msg;
      END IF;
   END delete_proj_info;

   FUNCTION check_cod_proj (p_icpi      IN  PROJ_INFO.icpi%TYPE
                           ) RETURN VARCHAR2 IS

    l_icpi  CHAR(1);

    BEGIN

        IF length(p_icpi) != 5 THEN
            RETURN 'FALSE';
        END IF;

        -- Le code projet doit contenir que du alphanumerique ( uniquement majuscule )
        IF ( regexp_like( p_icpi ,'[^ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]')  = true )  then
            RETURN 'FALSE';
        END IF;

        RETURN 'TRUE';

    EXCEPTION
       WHEN OTHERS THEN
         RETURN 'FALSE';

    END check_cod_proj;



   PROCEDURE select_proj_info (p_icpi         IN PROJ_INFO.icpi%TYPE,
                               p_userid       IN VARCHAR2,
                               p_curproj_info IN OUT proj_infoCurType,
                               p_nbcurseur       OUT INTEGER,
                               p_message         OUT VARCHAR2
                              ) IS

       l_msg VARCHAR2(1024);
       l_icpi PROJ_INFO.icpi%TYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

-- BSA QC 1166
    IF check_cod_proj(p_icpi) = 'FALSE' THEN
        Pack_Global.recuperer_message(20208, NULL, NULL, NULL, l_msg);
        RAISE_APPLICATION_ERROR( -20208, l_msg );
    END IF;

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN p_curproj_info FOR
              SELECT
                    pi.ICPI,
                    pi.ILIBEL,
                    pi.DESCR,
                    pi.IMOP,
                    pi.CLICODE,
                    pi.ICME,
                    pi.CODSG,
                    pi.ICODPROJ,
                    pi.ICPIR,
                    pi.STATUT,
                    pi.CADA,
                    pi.DATDEM,
                    pi.DATSTATUT,
                    pi.FLAGLOCK,
                    pi.COD_DB,
                    cm.CLILIB,
                    si.LIBDSG,
                    TO_CHAR( pi.DATCRE ,  'DD/MM/YYYY') AS DATCRE,
                    pi.LIBRPB,
                    pi.IDRPB,
                    TO_CHAR( pi.DATPROD , 'MM/YYYY') AS DATPROD,
                    TO_CHAR( pi.DATRPRO , 'MM/YYYY') AS DATRPRO,
                    pi.CRIREG,
                    TO_CHAR( pi.DEANRE ,  'YYYY') AS DEANRE,
                    ca.CLIBCA,
                    pi.LICODPRCA, -- TD 532
                    pi.CODCAMO1, -- TD 532
                    pi.CLIBCA1, -- TD 532
                    pi.CDFAIN1, -- TD 532
                    TO_CHAR(pi.DATVALLI1,  'DD/MM/YYYY') AS DATVALLI1, -- TD 532
                    pi.RESPVAL1, -- TD 532
                    pi.CODCAMO2, -- TD 532
                    pi.CLIBCA2, -- TD 532
                    pi.CDFAIN2, -- TD 532
                    TO_CHAR(pi.DATVALLI2,  'DD/MM/YYYY') AS DATVALLI2, -- TD 532
                    pi.RESPVAL2, -- TD 532
                    pi.CODCAMO3, -- TD 532
                    pi.CLIBCA3, -- TD 532
                    pi.CDFAIN3, -- TD 532
                    TO_CHAR(pi.DATVALLI3,  'DD/MM/YYYY') AS DATVALLI3, -- TD 532
                    pi.RESPVAL3, -- TD 532
                    pi.CODCAMO4, -- TD 532
                    pi.CLIBCA4, -- TD 532
                    pi.CDFAIN4, -- TD 532
                    TO_CHAR(pi.DATVALLI4,  'DD/MM/YYYY') AS DATVALLI4, -- TD 532
                    pi.RESPVAL4, -- TD 532
                    pi.CODCAMO5, -- TD 532
                    pi.CLIBCA5, -- TD 532
                    pi.CDFAIN5, -- TD 532
                    TO_CHAR(pi.DATVALLI5,  'DD/MM/YYYY') AS DATVALLI5, -- TD 532
                    pi.RESPVAL5, -- TD 532
                    dp.actif, -- TD 501
                    dp.dplib, -- TD 501
                    DP_COPI,   -- TD 616
                    topenvoi, --TD 673
                    to_char(date_envoi,'DD/MM/YYYY') as date_envoi, -- TD 673
                    pi.cod_db || ' - ' || d.libelle as lib_domaine,
                    (select to_char(datdebex, 'YYYY') from datdebex) as date_fonctionnel, -- TD 910
                   pi.dureeamor,

                  pi.PROJAXEMETIER -- PPM 61919 $ 6.8
                  
                    
              FROM PROJ_INFO       pi,
                     CLIENT_MO       cm,
                   STRUCT_INFO     si,
                   CENTRE_ACTIVITE ca,
                   DOSSIER_PROJET dp,
                   DOMAINE d
                WHERE icpi = p_icpi
                AND pi.codsg=si.codsg(+)
                AND pi.clicode=cm.clicode(+)
                AND pi.cada=ca.CODCAMO(+)
                AND pi.icodproj=dp.dpcode
                AND pi.COD_DB = d.CODE_D;

     EXCEPTION

        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);
     END;

      -- en cas absence
      -- 'Le centre d'activité n'existe pas';

      Pack_Global.recuperer_message(2035, '%s1', p_icpi, NULL, l_msg);
      p_message := l_msg;

   END select_proj_info;

-- PPM 50589 --
-- Message à retourner si on a des ressources sur le projet sélectionné avec les critères de la requête.
FUNCTION check_statut_proj (p_icpi IN PROJ_INFO.icpi%TYPE, p_date_statut IN VARCHAR2
                           ) RETURN VARCHAR2 IS

    nb_conso_proj int;
    p_char_dem char(24);
    p_date_dem date;


    BEGIN


      p_char_dem := CONCAT('01/', p_date_statut);
      p_date_dem := TO_DATE(p_char_dem,'dd/mm/yyyy');


      -- UNION car "SI du consommé existe au niveau de la saisie directe OU au niveau central Bip"
      SELECT count(*) nb_conso INTO nb_conso_proj FROM (
        Select pri.icpi icpi
            --, pri.ilibel
              , lb.pid pid
              , r.rnom nom
              , decode(pri.icpi,p_icpi,0,1) maitre
              , lb.typproj typeprojet
              , pro.cdeb datedeb
              , nvl(pro.cusag,0) montant
              , pro.rnom
        from proj_info pri, ligne_bip lb, ressource r , proplus pro
        where  pri.icpi = lb.icpi
          and lb.pcpi    = r.ident
          and lb.pid = pro.pid (+)
          and pri.icpi = p_icpi -- la ligne doit être liée au projet
          and lb.typproj in (1,2,3,4,6,8,9) -- D être attaché à une ligne Bip de type autre que 5 ou 7
          and ((pri.icpi LIKE DECODE(p_icpi, 'P', '%', p_icpi)) OR (pri.icpir LIKE DECODE(p_icpi, 'P', '%', p_icpi)))
          and pro.cdeb > p_date_dem -- d'être sur un mois ultérieur au mois <Date de prise en compte du statut> saisi sur l'écran du projet
          and NVL(pro.cusag,0) > 0 -- SEL PPM 64513
        UNION
        select pri.icpi icpi
            , lb.pid pid
            , r.rnom nom
            , decode(pri.icpi,p_icpi,0,1) maitre
            , lb.typproj typeprojet
            , isac.cdeb datedeb
            , nvl(isac.cusag,0) montant
            , to_char(isac.ident)
        from proj_info pri, ligne_bip lb, ressource r , isac_consomme isac
        where  pri.icpi = lb.icpi
          and lb.pcpi    = r.ident
          and lb.pid = isac.pid (+)
          and pri.icpi = p_icpi
          and lb.typproj in (1,2,3,4,6,8,9) -- BPO : Ajout ligne de type 9 (TD 585)
          and ((pri.icpi LIKE DECODE(p_icpi, 'P', '%', p_icpi)) OR (pri.icpir LIKE DECODE(p_icpi, 'P', '%', p_icpi)))
          and isac.cdeb > p_date_dem
		  and nvl(isac.cusag,0) > 0 -- FAD QC 1948


        );

    --Pack_Global.recuperer_message(XXXXX, NULL, NULL, NULL, l_msg);
      if (nb_conso_proj > 0) THEN
        RETURN 'TRUE';
      else
        RETURN 'FALSE';
      end if;

    EXCEPTION
       WHEN OTHERS THEN
         RETURN 'FALSE2';

END check_statut_proj;




  PROCEDURE update_dom_bancaire(p_icodproj          IN VARCHAR2,
                    p_cod_db        IN VARCHAR2,
                    p_userid        IN VARCHAR2,
                    p_message     OUT VARCHAR2
                   ) IS
  BEGIN

      UPDATE PROJ_INFO SET cod_db = TO_NUMBER(p_cod_db)
      WHERE  icodproj = TO_NUMBER(p_icodproj);

      Pack_Global.recuperer_message(20383, '%s1', 'des projets', NULL, p_message);

  EXCEPTION
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);
  END update_dom_bancaire;

--Procédure pour remplir les logs de MAJ du projet
PROCEDURE maj_proj_info_logs (p_icpi        IN PROJ_INFO_LOGS.icpi%TYPE,
                              p_user_log    IN VARCHAR2,--proj_info_logs.user_log%TYPE,
                              p_colonne        IN VARCHAR2,--proj_info_logs.colonne%TYPE,
                              p_valeur_prec    IN VARCHAR2,--proj_info_logs.valeur_prec%TYPE,
                              p_valeur_nouv    IN VARCHAR2,--proj_info_logs.valeur_nouv%TYPE,
                              p_commentaire    IN VARCHAR2--proj_info_logs.commentaire%TYPE
                              ) IS
BEGIN



    IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
        INSERT INTO PROJ_INFO_LOGS
            (icpi, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
        VALUES
            (p_icpi, SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);

    END IF;
    -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

END maj_proj_info_logs;

--Procédure pour initlialiser un CA préconisé
PROCEDURE init_donnees_ca (p_codcamo IN OUT PROJ_INFO.codcamo1%TYPE,
                           p_clibca    IN OUT PROJ_INFO.clibca1%TYPE,
                           p_cdfain    IN OUT PROJ_INFO.cdfain1%TYPE,
                           p_datvalli    IN OUT PROJ_INFO.datvalli1%TYPE
                          ) IS
BEGIN
    IF (TO_NUMBER(p_codcamo) <> 0)
    THEN
        BEGIN
            SELECT ca.clibca, ca.cdfain INTO p_clibca, p_cdfain FROM CENTRE_ACTIVITE ca WHERE ca.codcamo = p_codcamo;
            SELECT TO_DATE(SYSDATE, 'DD/MM/YYYY') INTO p_datvalli FROM DUAL;
        END;
    ELSE
        BEGIN
            p_codcamo := 0;
            p_clibca := '';
            p_cdfain := '';
            p_datvalli := '';
        END;
    END IF;
END init_donnees_ca;

--Procédure pour mettre à jour un CA préconisé
PROCEDURE maj_donnees_ca (p_old_codcamo IN PROJ_INFO.codcamo1%TYPE,
                          p_old_clibca    IN PROJ_INFO.clibca1%TYPE,
                          p_old_cdfain    IN PROJ_INFO.cdfain1%TYPE,
                          p_old_datvalli    IN PROJ_INFO.datvalli1%TYPE,
                          p_old_respval    IN PROJ_INFO.respval1%TYPE,
                          p_codcamo IN OUT PROJ_INFO.codcamo1%TYPE,
                          p_clibca    IN OUT PROJ_INFO.clibca1%TYPE,
                          p_cdfain    IN OUT PROJ_INFO.cdfain1%TYPE,
                          p_datvalli    IN OUT PROJ_INFO.datvalli1%TYPE,
                          p_respval    IN OUT PROJ_INFO.respval1%TYPE
                          ) IS
BEGIN
    IF (TO_NUMBER(p_codcamo) <> 0)
    THEN
        BEGIN
            IF (p_codcamo = p_old_codcamo)
            THEN
                -- codcamo inchangé
                IF (p_respval <> p_old_respval)
                THEN
                    -- respval modifié
                    BEGIN
                        p_clibca := p_old_clibca;
                        p_cdfain := p_old_cdfain;
                        -- Mise à jour de la date de validité du lien
                        SELECT TO_DATE(SYSDATE, 'DD/MM/YYYY') INTO p_datvalli FROM DUAL;
                    END;
                ELSE
                    -- respval inchangé
                    BEGIN
                        p_clibca := p_old_clibca;
                        p_cdfain := p_old_cdfain;
                        p_datvalli := p_old_datvalli;
                        p_respval := p_old_respval;
                    END;
                END IF;
            ELSE
                -- codcamo modifié (et non nul)
                BEGIN
                    -- Mise à jour de clibca et cdfain
                    SELECT ca.clibca, ca.cdfain INTO p_clibca, p_cdfain FROM CENTRE_ACTIVITE ca WHERE ca.codcamo = p_codcamo;
                    -- Mise à jour de la date de validité du lien
                    SELECT TO_DATE(SYSDATE, 'DD/MM/YYYY') INTO p_datvalli FROM DUAL;

                    IF (p_respval = p_old_respval)
                    THEN
                        -- respval inchangé
                        BEGIN
                            p_respval := p_old_respval;
                        END;
                    END IF;
                END;
            END IF;
        END;
    ELSE
        -- codcamo = 0
        BEGIN
            p_codcamo := 0;
            p_clibca := '';
            p_cdfain := '';
            p_datvalli := '';
            p_respval := '';
        END;
    END IF;
END maj_donnees_ca;

PROCEDURE GET_DPCOPI_DOM (  dpcopi IN VARCHAR2,
                            cod_db OUT VARCHAR2,
                            lib_domaine OUT VARCHAR2,
                            message OUT VARCHAR2
				) IS

BEGIN

    IF (dpcopi is not null) THEN
BEGIN
SELECT 	d.code_d,d.code_d || ' - '|| d.libelle
	INTO    cod_db, lib_domaine
	FROM 	domaine d, dossier_projet_copi dp
	WHERE	d.code_d=dp.domaine
    and dp.DP_COPI = dpcopi;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		pack_global.recuperer_message( 20311, NULL, NULL, NULL, message);
	WHEN OTHERS THEN
		raise_application_error( -20997, SQLERRM);
        END;
      END IF;

END GET_DPCOPI_DOM;

PROCEDURE INTEGRITE_LIGNE_DP (p_icpi         IN PROJ_INFO.icpi%TYPE,
                               p_dpcode          IN VARCHAR2,
                               p_count      OUT VARCHAR2,
                               p_message         OUT VARCHAR2
                              ) IS
    BEGIN
    p_message := '';
    BEGIN
      SELECT count(*) into p_count FROM LIGNE_BIP
      WHERE icpi=p_icpi
      AND dpcode  in (select ICODPROJ from proj_info where  icpi=p_icpi);
     EXCEPTION
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);
     END;

END INTEGRITE_LIGNE_DP;

-- Retourne la date fonctionnel
PROCEDURE get_datfonctionnel ( 	p_date_fonctionnel	OUT	VARCHAR2,
				p_message		OUT 	VARCHAR2
				) IS

BEGIN
  select to_char(datdebex, 'YYYY') INTO p_date_fonctionnel from datdebex;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		pack_global.recuperer_message( 4, '%s1', p_date_fonctionnel, NULL, p_message);
	WHEN OTHERS THEN
		raise_application_error( -20997, SQLERRM);

END get_datfonctionnel;

-- FAD PPM 63816 : Génération fichier flux projets vers ExpenseBis
PROCEDURE SELECT_EXPORT_EXPENSE(p_chemin_fichier IN VARCHAR2,
                                p_nom_fichier    IN VARCHAR2) IS
	L_HFILE UTL_FILE.FILE_TYPE;
	L_RETCOD NUMBER;
	l_msg  VARCHAR2(1024);
BEGIN
	-----------------------------------------------------
	-- Génération du fichier.
	-----------------------------------------------------
	PACK_GLOBAL.INIT_WRITE_FILE(p_chemin_fichier, p_nom_fichier, l_hfile);

	FOR CUR IN (
		SELECT
			'BIP' BIP,
			'FR001' FR,
			ICPI,
			SUBSTR(ILIBEL, 1, 30) LIB,
			DECODE(STATUT, NULL, 'A', 'O', 'A', 'N', 'A', 'I') STAT,
			DECODE(DATCRE, NULL, NULL, '01/' || TO_CHAR(DATCRE, 'MM/YYYY')) DATCRE,
			'31/12/2099' DATDEF
		FROM PROJ_INFO
		WHERE
			--FAD QC 1890
			--TRIM(DATSTATUT) >= TO_DATE('01/01/2016', 'DD/MM/YYYY') --A verifier avec la ME
			DATDEM IS NULL OR TRIM(DATDEM) >= TO_DATE('01/01/2016', 'DD/MM/YYYY')
	)
	LOOP
		PACK_GLOBAL.WRITE_STRING(l_hfile,
			CUR.BIP || ';' ||
			CUR.FR || ';' ||
			CUR.ICPI || ';' ||
			CUR.LIB || ';' ||
			CUR.STAT || ';' ||
			CUR.DATCRE || ';' ||
			CUR.DATDEF
		);
	END LOOP;

	PACK_GLOBAL.CLOSE_WRITE_FILE(l_hfile);
 EXCEPTION
	WHEN OTHERS THEN
	PACK_GLOBAL.RECUPERER_MESSAGE(20401, NULL, NULL, NULL, l_msg);
	RAISE_APPLICATION_ERROR(-20401, l_msg);
END SELECT_EXPORT_EXPENSE;
-- FAD PPM 63816 : Fin

--FAD PPM 63826 : Début
PROCEDURE VERIF_DUREEAMORTIS(p_duramort IN NUMBER, r_retour OUT VARCHAR2) IS
	p_valeur VARCHAR2(400);
	nb_occ NUMBER;
  p_separateur VARCHAR2(1);
	p_val VARCHAR2(250);
  p_message VARCHAR2(250);
BEGIN
	--Récupérer de la valeur et du séparateur du paramètre applicatif  DUREEAMORTIS
	PACK_LIGNE_BIP.RECUPERER_PARAM_APP('DUREEAMORTIS', 'DEFAUT', 1, p_valeur, p_message);
	PACK_LIGNE_BIP.RECUPERER_SEPAR_PARAM_APP('DUREEAMORTIS', 'DEFAUT', 1, p_separateur, p_message);

	r_retour := 'KO';

	IF (p_valeur IS NOT NULL)
	THEN
		--Compter le nombre d'occurrence du séparateur dans la valeur du paramètre applicatif
		nb_occ := REGEXP_COUNT(p_valeur, p_separateur);
		IF (nb_occ = 0)
		THEN
			IF (p_duramort = TO_NUMBER(p_valeur))
			THEN
				r_retour := 'OK';
			END IF;
		else
			IF (p_valeur LIKE p_duramort || p_separateur || '%') OR (p_valeur LIKE '%' || p_separateur || p_duramort || p_separateur || '%') OR (p_valeur LIKE '%' || p_separateur || p_duramort)
			THEN
				r_retour := 'OK';
			END IF;
		END IF;
	ELSE
		r_retour := 'OK';
	end if;
END VERIF_DUREEAMORTIS;
--FAD PPM 63826 : Fin
END Pack_Proj_Info;
/