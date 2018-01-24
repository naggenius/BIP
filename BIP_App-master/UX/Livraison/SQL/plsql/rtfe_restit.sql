-- Package qui renvoie la logues sur les reports génèrés.
-- YSB : 08/01/2010 : Fiche TD 876 - Création
-- ABA/CMA : 27/01/2011 : Fiche 916
-- BSA : 06/05/2011 QC 1176
-- CMA 12/05/2011 QC 1176 ajout du perm_mcli dans le record

CREATE OR REPLACE package     pack_rtfe_restit as

  TYPE Perims_Restit_ViewType IS RECORD ( user_rtfe      VARCHAR2(7),
                                          nom            VARCHAR2(30),
                                          prenom         VARCHAR2(30),
                                          nom_etat       VARCHAR2(200),
                                          date_restit    VARCHAR2(8),
                                          ident          VARCHAR2(5),
                                          nom_rdf        VARCHAR2(200),
                                          jobid          VARCHAR2(50),
                                          MENU_UTILS     VARCHAR2(20),
                                          PERIM_ME       VARCHAR2(4000),
                                          PERIM_MO       VARCHAR2(4000),
                                          PERIM_MCLI     VARCHAR2(4000),
                                          doss_proj      VARCHAR2(4000),
                                          projet         VARCHAR2(4000),
                                          appli          VARCHAR2(4000),
                                          ca_fi          VARCHAR2(4000),
                                          ca_payeur      VARCHAR2(4000),
                                          ca_da          VARCHAR2(4000),
                                          filtres        VARCHAR2(4000));



   TYPE Perims_Restit_CurType_Char IS REF CURSOR; --RETURN Perims_Restit_ViewType;

  PROCEDURE select_perims_restit (  p_matricule     	    IN  VARCHAR2,
                                    p_restitution     	  IN  VARCHAR2,
                                    p_datedeb     	      IN  VARCHAR2,
                                    p_heuredeb     	      IN  VARCHAR2,
                                    p_datefin     	      IN  VARCHAR2,
                                    p_heurefin     	      IN  VARCHAR2,
                                    p_curStruct_info      IN OUT Perims_Restit_CurType_Char ,
                                    p_message             OUT VARCHAR2);

end pack_rtfe_restit;
/


CREATE OR REPLACE package body     pack_rtfe_restit as

  PROCEDURE select_perims_restit (  p_matricule     	    IN  VARCHAR2,
                                    p_restitution     	  IN  VARCHAR2,
                                    p_datedeb     	      IN  VARCHAR2,
                                    p_heuredeb     	      IN  VARCHAR2,
                                    p_datefin     	      IN  VARCHAR2,
                                    p_heurefin     	      IN  VARCHAR2,
                                    p_curStruct_info IN OUT Perims_Restit_CurType_Char ,
                                    p_message           OUT VARCHAR2) is
   l_msg VARCHAR2(1024);
   LC$Requete VARCHAR2(5000);
   l_nbre NUMBER;
   l_datedebut VARCHAR2(50);
   l_datefin VARCHAR2(50);

   BEGIN

      p_message := '';
      LC$Requete := '';
      

	  IF (p_datedeb is not null ) THEN
						  IF (p_heuredeb is null) THEN
							    l_datedebut := to_char(to_date(p_datedeb || ' 00:00','DD/MM/rrrr HH24:MI'),'DD/MM/rrrr HH24:MI');
						  ELSE
							    l_datedebut := to_char(to_date(p_datedeb || ' ' || p_heuredeb,'DD/MM/rrrr HH24:MI'),'DD/MM/rrrr HH24:MI');
							END IF;
    END IF;
	  --ELSE
              --l_datedebut := to_char(sysdate,'DD/MM/rrrr HH24:MI');
	  --END IF;

	  IF (p_datefin is not null ) THEN
							IF(p_heurefin is null) THEN
							    l_datefin := to_char(to_date(p_datefin || ' 23:59','DD/MM/rrrr HH24:MI'),'DD/MM/rrrr HH24:MI');
							ELSE
							    l_datefin := to_char(to_date(p_datefin || ' ' || p_heurefin,'DD/MM/rrrr HH24:MI'),'DD/MM/rrrr HH24:MI');
							END IF;
	  END IF;

	  BEGIN

	      LC$Requete := 'SELECT rest.user_rtfe, rest.nom, rest.prenom,rest.nom_etat, 
                      to_char(rest.date_restit,''DD/MM/rrrr HH24:MI''),rest.ident,rest.nom_rdf,rest.jobid,rest.menu_utils, nvl(rest.perim_me,''VIDE'') perim_me, nvl(rest.perim_mo,''VIDE'') perim_mo, nvl(rest.perim_mcli,''VIDE'') perim_mcli,
                      nvl(rest.doss_proj,''VIDE'') doss_proj, nvl(rest.projet,''VIDE'') projet, nvl(rest.appli,''VIDE'') appli, nvl(rest.ca_fi,''VIDE'') ca_fi, nvl(rest.ca_payeur,''VIDE'') ca_payeur, nvl(rest.ca_da,''VIDE'') ca_da, rest.filtres
                      FROM  rtfe_restit rest WHERE';

            IF LTRIM(RTRIM(p_matricule)) is not null
            THEN
            LC$Requete := LC$Requete || ' UPPER(rest.user_rtfe) = LTRIM(RTRIM(UPPER(''' || p_matricule || '''))) AND';
            END IF;

            IF LTRIM(RTRIM(p_restitution)) is not null
            THEN
            LC$Requete := LC$Requete || ' UPPER(rest.nom_etat) LIKE LTRIM(RTRIM(UPPER(''%' || p_restitution || '%''))) AND';
            END IF;

            IF l_datedebut is not null
            THEN
            LC$Requete := LC$Requete||' to_date(to_char(rest.date_restit,''DD/MM/rrrr HH24:MI''),''DD/MM/rrrr HH24:MI'') >= to_date(''' || l_datedebut || ''',''DD/MM/rrrr HH24:MI'') AND';
            END IF;

            IF p_datefin is not null
            THEN
            LC$Requete := LC$Requete||' to_date(to_char(rest.date_restit,''DD/MM/rrrr HH24:MI''),''DD/MM/rrrr HH24:MI'') <= to_date(''' || l_datefin || ''',''DD/MM/rrrr HH24:MI'') AND';
            END IF;

            LC$Requete := LC$Requete||' 1=1 order by rest.date_restit desc';

            OPEN  p_curStruct_info  FOR  LC$Requete;

            END;

            IF SQL%NOTFOUND THEN
               pack_global.recuperer_message( 20849, NULL,NULL,NULL, l_msg);
			         p_message := l_msg;
               RAISE_APPLICATION_ERROR( -20849, l_msg);
            END IF;


  END select_perims_restit;

END pack_rtfe_restit;
/


