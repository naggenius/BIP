-- *****************************************************************************************
-- Package pour les table de réference du COPI
-- Créé le 24/04/2008 par ABA
-- Modification
--    date 	            auteur             	commentaire
--24/04/2008          ABA		ajout dun test pour eviter la multi insertion d'une meme donne dans les exceptions
--02/05/2008          ABA	         modification message d'alerte en cas de suppression
--05/05/2008          ABA	        suppression des méthodes concernant la variation
--10/05/2008          JAL	        modifs pour fiche 616 : rajout code fournisseur en clef de fourcopi
--27/05/2008          ABA	        ajout des liste dynamique en fonction de leur présence dans buget copi pour la suppression et modification
-- 16/07/2008         JAL              Fiche 662 : COPI partie qualitative
-- 31/07/2008         JAL              Fiche 662 : COPI partie qualitative suite DEV
-- 08/08/2008         JAL              Fiche 662 : COPI2 corrections et changement nom Table 
-- 12/08/2008         JAL              Fiche 662 : COPI2 changements méthodes appellées
-- 11/09/2008         ABA              suppression des methodes de gestion des tables du npsi
-- 23/09/2008         ABA             mise en conformité avec les tables du npsi
-- 24/02/2009         ABA             TD 729
-- 17/03/2009         ABA             TD 778
--  12/08/2009         ABA TD 799
-- 22/02/2010 ABA : TD 938
-- Modifié le 26/05/2011 par BSA : QC 1166
-- Modifié le 07/06/2012 par ABA : QC 1386
-- ******************************************************************************************

CREATE OR REPLACE PACKAGE     pack_copi_referentiel IS

/* -------------- Gestion Eceptions COPI ---------------------- */

/* procedure d'insertion d'une nouvelle exception */
PROCEDURE insert_exception_copi(p_dpcode1     IN VARCHAR2,
                                p_dpcode2     IN VARCHAR2,
                                p_dpcode3     IN VARCHAR2,
                                p_dpcode4     IN VARCHAR2,
                                p_dpcode5     IN VARCHAR2,
                                p_icpi1     IN VARCHAR2,
                                p_icpi2     IN VARCHAR2,
                                p_icpi3     IN VARCHAR2,
                                p_icpi4     IN VARCHAR2,
                                p_icpi5     IN VARCHAR2,
                                p_airt1     IN VARCHAR2,
                                p_airt2     IN VARCHAR2,
                                p_airt3     IN VARCHAR2,
                                p_airt4     IN VARCHAR2,
                                p_airt5     IN VARCHAR2,
                                p_clicode1     IN VARCHAR2,
                                p_clicode2     IN VARCHAR2,
                                p_clicode3     IN VARCHAR2,
                                p_clicode4     IN VARCHAR2,
                                p_clicode5     IN VARCHAR2,
                                p_codsg1     IN VARCHAR2,
                                p_codsg2     IN VARCHAR2,
                                p_codsg3     IN VARCHAR2,
                                p_codsg4     IN VARCHAR2,
                                p_codsg5     IN VARCHAR2,
                                p_codpspe1     IN VARCHAR2,
                                p_codpspe2     IN VARCHAR2,
                                p_codpspe3     IN VARCHAR2,
                                p_codpspe4     IN VARCHAR2,
                                p_codpspe5     IN VARCHAR2,
                                p_message     OUT VARCHAR2
                                );

/* procedure de suppression d'une nouvelle exception */
PROCEDURE supprimer_exception_copi(p_dpcode1     IN VARCHAR2,
                                p_dpcode2     IN VARCHAR2,
                                p_dpcode3     IN VARCHAR2,
                                p_dpcode4     IN VARCHAR2,
                                p_dpcode5     IN VARCHAR2,
                                p_icpi1     IN VARCHAR2,
                                p_icpi2     IN VARCHAR2,
                                p_icpi3     IN VARCHAR2,
                                p_icpi4     IN VARCHAR2,
                                p_icpi5     IN VARCHAR2,
                                p_airt1     IN VARCHAR2,
                                p_airt2     IN VARCHAR2,
                                p_airt3     IN VARCHAR2,
                                p_airt4     IN VARCHAR2,
                                p_airt5     IN VARCHAR2,
                                p_clicode1     IN VARCHAR2,
                                p_clicode2     IN VARCHAR2,
                                p_clicode3     IN VARCHAR2,
                                p_clicode4     IN VARCHAR2,
                                p_clicode5     IN VARCHAR2,
                                p_codsg1     IN VARCHAR2,
                                p_codsg2     IN VARCHAR2,
                                p_codsg3     IN VARCHAR2,
                                p_codsg4     IN VARCHAR2,
                                p_codsg5     IN VARCHAR2,
                                p_codpspe1     IN VARCHAR2,
                                p_codpspe2     IN VARCHAR2,
                                p_codpspe3     IN VARCHAR2,
                                p_codpspe4     IN VARCHAR2,
                                p_codpspe5     IN VARCHAR2,
                                p_message     OUT VARCHAR2
                                );


/* -------------- Gestion Dates COPI ---------------------- */
TYPE dateCopi_Type IS RECORD (
                                 datecopi        VARCHAR2(10) ,
                                 lib_datecopi        VARCHAR2(10)
                             );

TYPE datesCopiCurType IS REF CURSOR RETURN dateCopi_Type;

PROCEDURE lister_datesCopi (p_userid     IN VARCHAR2,
                          p_curDatesCopi IN OUT datesCopiCurType
                                  );

PROCEDURE lister_datesCopibudget (p_userid     IN VARCHAR2,
                                p_dpcopi    IN VARCHAR2,
                                p_annee     IN VARCHAR2,
                          p_curDatesCopi IN OUT datesCopiCurType
                                  );


PROCEDURE insert_date_copi( p_datecopi IN VARCHAR2,
                            p_message OUT VARCHAR2
                            );


PROCEDURE supprimer_date_copi( p_datecopi IN VARCHAR2,
                            p_message OUT VARCHAR2
                            );

TYPE fourCopi_ViewType IS RECORD ( code_four_copi  varchar(2),
                                    libelle varchar2(50)
                                     );

TYPE FourCopiCurType IS REF CURSOR RETURN fourCopi_ViewType;


PROCEDURE insert_fourCopi( p_code_four_copi       IN  VARCHAR2,
                                p_libelle              IN VARCHAR2,
                           p_message              OUT VARCHAR2
                              );


PROCEDURE update_fourCopi ( p_code_four_copi       IN  VARCHAR2,
                                 p_libelle              IN VARCHAR2,
                            p_message              OUT VARCHAR2
                          );



PROCEDURE delete_fourCopi (  p_code_four_copi       IN  VARCHAR2,
                               p_message               OUT VARCHAR2
                             );


PROCEDURE select_fourCopi(  p_code_four_copi       IN  VARCHAR2,
                                 p_libelle             IN OUT VARCHAR2,
                            p_message              OUT VARCHAR2
                         ) ;



/* procdure de renseignement de la loupe*/
PROCEDURE lister_fourcopi( p_nomRecherche    IN VARCHAR2,
                               s_curseur     IN OUT FourCopiCurType
                            );

/* procdure de liste des fourcopi utilisé dans les budgets */
PROCEDURE lister_fourcopibud( p_userId   IN VARCHAR2,
                              p_dpcopi IN VARCHAR2,
                              p_annee IN VARCHAR2,
                              p_datecopi IN VARCHAR2,
                              p_metier IN VARCHAR2,
                              p_curseur     IN OUT FourCopiCurType
                            );


/* ---------------- Gestion budget COPI -------------------------------- */
TYPE budgetCopi_View IS RECORD (
                             DP_COPI   VARCHAR(2) ,
                             ANNEE     VARCHAR(2) ,
                             DATE_COPI         VARCHAR(2) ,
                             CODE_FOUR_COPI   VARCHAR(2) ,
                             METIER             VARCHAR(2),
                             CODE_TYPE_DEMANDE VARCHAR(2),
                             JH_COUTTOTAL           VARCHAR2(15) ,
                             JH_ARBDEMANDES     VARCHAR2(15),
                             JH_ARBDECIDES      VARCHAR2(15),
                             JH_CANTDEMANDES  VARCHAR2(15),
                             JH_CANTDECIDES VARCHAR2(15),
                             JH_PREVIDECIDE  VARCHAR2(15)

                );

 TYPE budget_copiCurType IS REF CURSOR RETURN budgetCopi_View;

 PROCEDURE select_BudgetCopi (
                               p_dpcopi IN VARCHAR2,
                               p_datecopi IN VARCHAR2 ,
                               p_metier IN VARCHAR2 ,
                               p_annee   IN VARCHAR2 ,
                               p_fourcopi IN VARCHAR2,
                               p_cur  IN OUT budget_copiCurType,
                               p_nbcurseur             OUT INTEGER,
                               p_message               OUT VARCHAR2
                              ) ;



 PROCEDURE lister_direction_client ( p_userid   IN       VARCHAR2,
                                           p_curseur  IN OUT Pack_Liste_Dynamique.liste_dyn
                                                                            );

TYPE AnneeCopiBud_Type IS RECORD (
                                 annee        VARCHAR2(4),
                                 lib_annee        VARCHAR2(4)

                             );

TYPE AnneeCopiBudCurType IS REF CURSOR RETURN AnneeCopiBud_Type;

PROCEDURE lister_anneeCopibud (p_userid     IN VARCHAR2,
                                p_dpcopi    IN VARCHAR2,
                          p_curAnneeCopi IN OUT AnneeCopiBudCurType
                                  );


/* -------------- AXES STRATEGIQUES COPI --------------------- */
TYPE axeStrategique_Type IS RECORD (
                                 numero        VARCHAR2(2) ,
                                 libelle       VARCHAR2(50)
                             );

TYPE axeStrategiqueCurType IS REF CURSOR RETURN axeStrategique_Type;

PROCEDURE lister_axesStrategiques (p_userid     IN VARCHAR2,
                                p_curAxestrat IN OUT axeStrategiqueCurType
                              ) ;

PROCEDURE lister_typeFinancement (p_userid     IN VARCHAR2,
                                p_curTypeFinan IN OUT axeStrategiqueCurType
                              ) ;
/* -------------- ETAPES COPI ---------------------- */
TYPE etapesCopi_Type IS RECORD (
                                  numero        VARCHAR2(2) ,
                                 libelle       VARCHAR2(50)
                             );

TYPE etapesCopiCurType IS REF CURSOR RETURN etapesCopi_Type;

PROCEDURE lister_EtapesDpCopi (p_userid     IN VARCHAR2,
                                p_curEtapesCopi IN OUT etapesCopiCurType
                              ) ;

-------------------- Notification DPCOPI ---------------------------
 PROCEDURE verifie_NotationDPCopi (  p_dpcopi      IN VARCHAR2 ,
                                        p_message     OUT VARCHAR2
                              ) ;

PROCEDURE insert_NotationDpCopi (p_dpcopi               IN  VARCHAR2,
                                     p_etape            IN  VARCHAR2,
                                     p_dirprojet        IN  VARCHAR2,
                                     p_respbancaires    IN  VARCHAR2,
                                     p_sponsors         IN  VARCHAR2,
                                     p_axestrateg       IN  VARCHAR2,
                                     p_bloc  IN  VARCHAR2,
                                     p_domaine      IN  VARCHAR2,
                                     p_notetrateg   IN  VARCHAR2,
                                     p_noteroi      IN  VARCHAR2,
                                     p_prochaincopi IN  VARCHAR2,
                                     p_coddir       IN  VARCHAR2,
                                     p_userid       IN  VARCHAR2,
                                     p_message      OUT VARCHAR2
                                    ) ;

TYPE notation_dpcopi_ViewType IS RECORD(
                                         p_dpcopi          COPI_NOTATION.dp_copi%TYPE,
                                         p_etape           VARCHAR2(2),
                                         p_dirprojet       COPI_NOTATION.DIRECTEURS_PROJET%TYPE,
                                         p_respbancaires   COPI_NOTATION.RESP_BANCAIRES%TYPE,
                                         p_sponsors        COPI_NOTATION.sponsors%TYPE,
                                         p_axestrateg      VARCHAR2(2),
                                         p_bloc         VARCHAR2(5),
                                         p_domaine          VARCHAR2(5),
                                         p_notetrateg      VARCHAR2(10),
                                         p_noteroi         VARCHAR2(10),
                                         p_prochaincopi    VARCHAR2(10),
                                         p_coddir          VARCHAR2(2) ,
                                         p_flaglock COPI_NOTATION.flaglock%TYPE,
                                         p_libelleEtape    VARCHAR2(70),
                                         p_libelleAxe      VARCHAR2(70),
                                         p_libelleBloc     VARCHAR2(70),
                                         p_libelleDomaine  VARCHAR2(70)
                                       );

TYPE notation_dpcopi_copiCurType IS REF CURSOR RETURN notation_dpcopi_ViewType ;



PROCEDURE select_notation_dpcopi (    p_dpcopi   IN  COPI_NOTATION.dp_copi%TYPE,
                                      p_userid             IN VARCHAR2,
                                      p_curseur IN OUT notation_dpcopi_copiCurType,
                                      p_nbcurseur             OUT INTEGER,
                                      p_message               OUT VARCHAR2
                                    );


PROCEDURE delete_notation_dpcopi (p_dpcopi   IN  COPI_NOTATION.dp_copi%TYPE,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                    ) ;


   PROCEDURE update_notation_dpcopi (
                                     p_dpcopi           IN  VARCHAR2,
                                     p_etape            IN  VARCHAR2,
                                     p_dirprojet        IN  VARCHAR2,
                                     p_respbancaires    IN  VARCHAR2,
                                     p_sponsors         IN  VARCHAR2,
                                     p_axestrateg       IN  VARCHAR2,
                                     p_bloc            IN  VARCHAR2,
                                     p_domaine        IN  VARCHAR2,
                                     p_notetrateg   IN  VARCHAR2,
                                     p_noteroi      IN  VARCHAR2,
                                     p_prochaincopi IN  VARCHAR2,
                                     p_coddir       IN  VARCHAR2,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                   ) ;


------------------------------------------------------------------------------------------------------
----------------- GESTION TABLES REFERENCE DE LA PARTIE QUALITATIVE DU COPI --------------------------
------------------------------------------------------------------------------------------------------


PROCEDURE insert_AxeStrategique(
                           p_libelle        IN VARCHAR2,
                           p_userid         IN VARCHAR2,
                           p_message        OUT VARCHAR2
                          ) ;
PROCEDURE update_AxeStrategique ( p_code      IN  VARCHAR2,
                                 p_libelle    IN VARCHAR2,
                                 p_userid         IN VARCHAR2,
                                 p_message    OUT VARCHAR2
                          ) ;
PROCEDURE delete_AxeStrategique (  p_code       IN  VARCHAR2,
                                   p_userid         IN VARCHAR2,
                                   p_message    OUT VARCHAR2
                             ) ;
PROCEDURE select_AxeStrategique(  p_code        IN  VARCHAR2,
                                  p_libelle     IN out VARCHAR2,
                                  p_message     OUT VARCHAR2
                                ) ;



PROCEDURE insert_EtapeCopi(
                           p_libelle        IN VARCHAR2,
                           p_message        OUT VARCHAR2
                          ) ;
PROCEDURE update_EtapeCopi ( p_code      IN  VARCHAR2,
                                 p_libelle    IN VARCHAR2,
                                 p_message    OUT VARCHAR2
                          ) ;
PROCEDURE delete_EtapeCopi (  p_code       IN  VARCHAR2,
                                   p_message    OUT VARCHAR2
                             ) ;
PROCEDURE select_EtapeCopi(  p_code        IN  VARCHAR2,
                                  p_libelle     IN out VARCHAR2,
                                  p_message     OUT VARCHAR2
                                ) ;


END pack_copi_referentiel;
/


CREATE OR REPLACE PACKAGE BODY     pack_copi_referentiel AS

PROCEDURE insert_exception_copi(p_dpcode1     IN VARCHAR2,
                                p_dpcode2     IN VARCHAR2,
                                p_dpcode3     IN VARCHAR2,
                                p_dpcode4     IN VARCHAR2,
                                p_dpcode5     IN VARCHAR2,
                                p_icpi1     IN VARCHAR2,
                                p_icpi2     IN VARCHAR2,
                                p_icpi3     IN VARCHAR2,
                                p_icpi4     IN VARCHAR2,
                                p_icpi5     IN VARCHAR2,
                                p_airt1     IN VARCHAR2,
                                p_airt2     IN VARCHAR2,
                                p_airt3     IN VARCHAR2,
                                p_airt4     IN VARCHAR2,
                                p_airt5     IN VARCHAR2,
                                p_clicode1     IN VARCHAR2,
                                p_clicode2     IN VARCHAR2,
                                p_clicode3     IN VARCHAR2,
                                p_clicode4     IN VARCHAR2,
                                p_clicode5     IN VARCHAR2,
                                p_codsg1     IN VARCHAR2,
                                p_codsg2     IN VARCHAR2,
                                p_codsg3     IN VARCHAR2,
                                p_codsg4     IN VARCHAR2,
                                p_codsg5     IN VARCHAR2,
                                p_codpspe1     IN VARCHAR2,
                                p_codpspe2     IN VARCHAR2,
                                p_codpspe3     IN VARCHAR2,
                                p_codpspe4     IN VARCHAR2,
                                p_codpspe5     IN VARCHAR2,
                                p_message     OUT VARCHAR2
                           )
                         IS

    l_msg VARCHAR2(1024);
    presence number;
    libprojspe varchar2(10);

    TYPE TYPE_TAB IS VARRAY (5) OF VARCHAR2(20);

    dpcode_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);
    icpi_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);
    airt_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);
    clicode_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);
    codsg_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);
    codpspe_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);

    ind number;
    l_icpi char;
    l_airt char;



   BEGIN

       p_message := '';

  --  remplissage des tableaux contenant les données à insérées


    -- remplissage du tableau des code dossiers projets
      dpcode_tab(1) := p_dpcode1;
      dpcode_tab(2) := p_dpcode2;
      dpcode_tab(3) := p_dpcode3;
      dpcode_tab(4) := p_dpcode4;
      dpcode_tab(5) := p_dpcode5;

      -- remplissage du tableau des codes projets
      icpi_tab(1) := p_icpi1;
      icpi_tab(2) := p_icpi2;
      icpi_tab(3) := p_icpi3;
      icpi_tab(4) := p_icpi4;
      icpi_tab(5) := p_icpi5;

      -- remplissage du tableau des codes applications
      airt_tab(1) := p_airt1;
      airt_tab(2) := p_airt2;
      airt_tab(3) := p_airt3;
      airt_tab(4) := p_airt4;
      airt_tab(5) := p_airt5;

      -- remplissage du tableau des codes clients
      clicode_tab(1) := p_clicode1;
      clicode_tab(2) := p_clicode2;
      clicode_tab(3) := p_clicode3;
      clicode_tab(4) := p_clicode4;
      clicode_tab(5) := p_clicode5;

      -- remplissage du tableau des codes dpg
      codsg_tab(1) := p_codsg1;
      codsg_tab(2) := p_codsg2;
      codsg_tab(3) := p_codsg3;
      codsg_tab(4) := p_codsg4;
      codsg_tab(5) := p_codsg5;

      -- remplissage du tableau des codes projets spéciaux
      codpspe_tab(1) := p_codpspe1;
      codpspe_tab(2) := p_codpspe2;
      codpspe_tab(3) := p_codpspe3;
      codpspe_tab(4) := p_codpspe4;
      codpspe_tab(5) := p_codpspe5;

      BEGIN

      -- top indiquant la presence du paramètre dans les différentes tables
     presence :=0 ;
     ind :=1;
     --- DEBUT TEST COHERENCE DONNEES
     -- DEBUT traitement des codes dossiers projets
     for ind in 1..5 loop
         if (dpcode_tab(ind) <> ' ')
         then
            -- test d'existance du code dossier projet dans la table dossier_projet
             SELECT count(*) into presence FROM DOSSIER_PROJET WHERE dpcode = to_number(dpcode_tab(ind));
             if (presence = 0)
             then
                pack_global.recuperer_message( 21074, '%s1', dpcode_tab(ind), NULL, l_msg);
                RAISE_APPLICATION_ERROR( -20000, l_msg );
             else
                -- test d'existance du code dossier projet dans la table copi_exception
                SELECT count(*) into presence FROM copi_exceptions WHERE valeur = dpcode_tab(ind) and type_exception = 'DPCODE';
                if (presence = 1)
                then
                   pack_global.recuperer_message( 21075, '%s1', dpcode_tab(ind)|| ' dejà', NULL, l_msg);
                   RAISE_APPLICATION_ERROR( -20000, l_msg );
                end if;
             end if;
         end if;
     end loop;
     -- FIN traitement des codes dossiers projets

     --- DEBUT traitement des codes projets
     for ind in 1..5 loop
          if (icpi_tab(ind) <> ' ')
          then
            --- Test format codes projet
            /*
            l_icpi := SUBSTR(icpi_tab(ind), 0, 1);
               IF ((l_icpi != 'P') AND (l_icpi != 'I')) THEN
                 Pack_Global.recuperer_message(20208, NULL, NULL, NULL, l_msg);
                 RAISE_APPLICATION_ERROR( -20208, l_msg );
               END IF;
*/
            IF pack_proj_info.check_cod_proj(icpi_tab(ind)) = 'FALSE' THEN
                Pack_Global.recuperer_message(20208, NULL, NULL, NULL, l_msg);
                RAISE_APPLICATION_ERROR( -20208, l_msg );
            END IF;

               -- test d'existance du code projet dans la table proj_info
               SELECT count(*) into presence FROM PROJ_INFO WHERE icpi = icpi_tab(ind);
               if (presence = 0)
               then
                   pack_global.recuperer_message( 21076, '%s1', icpi_tab(ind), NULL, l_msg);
                   RAISE_APPLICATION_ERROR( -20000, l_msg );
               else
                  -- test d'existance du code projet dans la table copi_exception
                  SELECT count(*) into presence FROM copi_exceptions WHERE valeur = icpi_tab(ind) and type_exception = 'ICPI';
                   if (presence = 1)
                   then
                      pack_global.recuperer_message( 21077, '%s1', icpi_tab(ind)|| ' dejà', NULL, l_msg);
                      RAISE_APPLICATION_ERROR( -20000, l_msg );
                   end if;
               end if;

            end if;

       end loop;
     --- FIN traitement des codes projets

          --- DEBUT traitement des codes application
          for ind in 1..5 loop
          if (airt_tab(ind) <> ' ')
          then
            --- Test format codes application
            l_airt := SUBSTR(airt_tab(ind), 0, 1);



                    -- test d'existance du code application dans la table application
                    SELECT count(*) into presence FROM application WHERE airt = airt_tab(ind);
                    if (presence = 0)
                    then
                        pack_global.recuperer_message( 2027, '%s1', airt_tab(ind), NULL, l_msg);
                        RAISE_APPLICATION_ERROR( -20000, l_msg );
                    else
                        -- test d'existance du code application dans la table copi_exception
                        SELECT count(*) into presence FROM copi_exceptions WHERE valeur = airt_tab(ind) and type_exception = 'AIRT';
                        if (presence = 1)
                        then
                            pack_global.recuperer_message( 21078, '%s1', airt_tab(ind)|| ' dejà', NULL, l_msg);
                            RAISE_APPLICATION_ERROR( -20000, l_msg );
                        end if;
                    end if;

            end if;

        end loop;
        --- FIN traitement des codes applications

       --- DEBUT traitement des codes client_mo
          for ind in 1..5 loop
          if (clicode_tab(ind) <> ' ')
          then
             -- test d'existance du code client dans la table client_mo
              SELECT count(*) into presence FROM client_mo WHERE clicode = clicode_tab(ind);
              if (presence = 0)
              then
                pack_global.recuperer_message( 4, '%s1', clicode_tab(ind), NULL, l_msg);
                RAISE_APPLICATION_ERROR( -20000, l_msg );
              else
              -- test d'existance du code client dans la table copi_exception
                  SELECT count(*) into presence FROM copi_exceptions WHERE valeur = clicode_tab(ind) and type_exception = 'CLICODE';
                  if (presence = 1)
                  then
                    pack_global.recuperer_message( 21079, '%s1', clicode_tab(ind)|| ' dejà', NULL, l_msg);
                    RAISE_APPLICATION_ERROR( -20000, l_msg );
                  end if;
              end if;

            end if;

        end loop;
        --- FIN traitement des codes client_mo

        --- DEBUT traitement des codes dpg
          for ind in 1..5 loop
          if (codsg_tab(ind) <> ' ')
          then
             -- test d'existance du code dpg dans la table struct_info
              SELECT count(*) into presence FROM struct_info WHERE lpad(codsg,7,0) = lpad(codsg_tab(ind),7,0);
              if (presence = 0)
              then
                pack_global.recuperer_message( 21080, '%s1', codsg_tab(ind), NULL, l_msg);
                RAISE_APPLICATION_ERROR( -20000, l_msg );
              else
              -- test d'existance du code dpgdans la table copi_exception
                  SELECT count(*) into presence FROM copi_exceptions WHERE lpad(valeur,7,0) = lpad(codsg_tab(ind),7,0) and type_exception = 'CODSG';
                  if (presence = 1)
                  then
                    pack_global.recuperer_message( 21081, '%s1', codsg_tab(ind)|| ' dejà', NULL, l_msg);
                    RAISE_APPLICATION_ERROR( -20000, l_msg );
                  end if;
              end if;

            end if;

        end loop;
        --- FIN traitement des codes dpg


        --- DEBUT traitement des codes projets spéciaux
          for ind in 1..5 loop
          if (codpspe_tab(ind) <> '---')
          then

              -- test d'existance du code projet special dans la table copi_exception
              SELECT count(*) into presence FROM copi_exceptions WHERE valeur = codpspe_tab(ind) and type_exception = 'CODPSPE';
              if (presence = 1)
              then
                Select libpspe into libprojspe from proj_spe where codpspe = codpspe_tab(ind);
                pack_global.recuperer_message( 21082, '%s1', libprojspe|| ' dejà', NULL, l_msg);
                RAISE_APPLICATION_ERROR( -20000, l_msg );
              end if;


            end if;

        end loop;
        --- FIN traitement des codes projets spéciaux
     --- FIN TEST COHERENCE DONNEES


     ---DEBUT INSERTION

      for ind in 1..5 loop

            -- DEBUT INSERTION DPCODE
            if (dpcode_tab(ind) <> ' ')
            then
                SELECT count(*) into presence FROM copi_exceptions WHERE valeur = dpcode_tab(ind) and type_exception = 'DPCODE';
                if (presence = 0)
                then
                    insert into copi_exceptions values ('DPCODE', dpcode_tab(ind));
                end if;
            end if;
            -- FIN INSERTION DPCODE

            -- DEBUT INSERTION ICPI
            if (icpi_tab(ind) <> ' ')
            then
                SELECT count(*) into presence FROM copi_exceptions WHERE valeur = icpi_tab(ind) and type_exception = 'ICPI';
                if (presence = 0)
                then
                     insert into copi_exceptions values ('ICPI', icpi_tab(ind));
                end if;
            end if;
            -- FIN INSERTION ICPI

            -- DEBUT INSERTION AIRT
            if (airt_tab(ind) <> ' ')
            then
                SELECT count(*) into presence FROM copi_exceptions WHERE valeur = airt_tab(ind) and type_exception = 'AIRT';
                if (presence = 0)
                then
                    insert into copi_exceptions values ('AIRT', airt_tab(ind));
                end if;
            end if;
            -- FIN INSERTION AIRT

            -- DEBUT INSERTION  CLICODE
            if (clicode_tab(ind) <> ' ')
            then
             SELECT count(*) into presence FROM copi_exceptions WHERE valeur = clicode_tab(ind) and type_exception = 'CLICODE';
                  if (presence = 0)
                  then
                insert into copi_exceptions values ('CLICODE', clicode_tab(ind));
                end if;
            end if;
            -- FIN INSERTION clicode

            -- DEBUT INSERTION DPG
            if (codsg_tab(ind) <> ' ')
            then
                    SELECT count(*) into presence FROM copi_exceptions WHERE lpad(valeur,7,0) = lpad(codsg_tab(ind),7,0) and type_exception = 'CODSG';
                  if (presence = 0)
                  then
                    insert into copi_exceptions values ('CODSG', codsg_tab(ind));
                   end if;
            end if;
            -- FIN INSERTION DPG

            -- DEBUT INSERTION CODPSPE


            if (codpspe_tab(ind) <> '---')
            then
               SELECT count(*) into presence FROM copi_exceptions WHERE valeur = codpspe_tab(ind) and type_exception = 'CODPSPE';
                if (presence = 0)
                then
                     insert into copi_exceptions values ('CODPSPE', codpspe_tab(ind));
                end if;
            end if;
            -- FIN INSERTION CODPSPE

      end loop;

      p_message := 'Insertion des données réalisées';

     ---FIN INSERTION



     END;

   END insert_exception_copi;


PROCEDURE supprimer_exception_copi(p_dpcode1     IN VARCHAR2,
                                p_dpcode2     IN VARCHAR2,
                                p_dpcode3     IN VARCHAR2,
                                p_dpcode4     IN VARCHAR2,
                                p_dpcode5     IN VARCHAR2,
                                p_icpi1     IN VARCHAR2,
                                p_icpi2     IN VARCHAR2,
                                p_icpi3     IN VARCHAR2,
                                p_icpi4     IN VARCHAR2,
                                p_icpi5     IN VARCHAR2,
                                p_airt1     IN VARCHAR2,
                                p_airt2     IN VARCHAR2,
                                p_airt3     IN VARCHAR2,
                                p_airt4     IN VARCHAR2,
                                p_airt5     IN VARCHAR2,
                                p_clicode1     IN VARCHAR2,
                                p_clicode2     IN VARCHAR2,
                                p_clicode3     IN VARCHAR2,
                                p_clicode4     IN VARCHAR2,
                                p_clicode5     IN VARCHAR2,
                                p_codsg1     IN VARCHAR2,
                                p_codsg2     IN VARCHAR2,
                                p_codsg3     IN VARCHAR2,
                                p_codsg4     IN VARCHAR2,
                                p_codsg5     IN VARCHAR2,
                                p_codpspe1     IN VARCHAR2,
                                p_codpspe2     IN VARCHAR2,
                                p_codpspe3     IN VARCHAR2,
                                p_codpspe4     IN VARCHAR2,
                                p_codpspe5     IN VARCHAR2,
                                p_message     OUT VARCHAR2
                           )
                         IS

    l_msg VARCHAR2(1024);
    presence number;
    libprojspe varchar2(10);

    TYPE TYPE_TAB IS VARRAY (5) OF VARCHAR2(20);

    dpcode_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);
    icpi_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);
    airt_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);
    clicode_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);
    codsg_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);
    codpspe_tab TYPE_TAB := TYPE_TAB(1,2,3,4,5);

    ind number;
    l_icpi char;
    l_airt char;



   BEGIN

       p_message := '';

  --  remplissage des tableaux contenant les données à insérées


    -- remplissage du tableau des code dossiers projets
      dpcode_tab(1) := p_dpcode1;
      dpcode_tab(2) := p_dpcode2;
      dpcode_tab(3) := p_dpcode3;
      dpcode_tab(4) := p_dpcode4;
      dpcode_tab(5) := p_dpcode5;

      -- remplissage du tableau des codes projets
      icpi_tab(1) := p_icpi1;
      icpi_tab(2) := p_icpi2;
      icpi_tab(3) := p_icpi3;
      icpi_tab(4) := p_icpi4;
      icpi_tab(5) := p_icpi5;

      -- remplissage du tableau des codes applications
      airt_tab(1) := p_airt1;
      airt_tab(2) := p_airt2;
      airt_tab(3) := p_airt3;
      airt_tab(4) := p_airt4;
      airt_tab(5) := p_airt5;

      -- remplissage du tableau des codes clients
      clicode_tab(1) := p_clicode1;
      clicode_tab(2) := p_clicode2;
      clicode_tab(3) := p_clicode3;
      clicode_tab(4) := p_clicode4;
      clicode_tab(5) := p_clicode5;

      -- remplissage du tableau des codes dpg
      codsg_tab(1) := p_codsg1;
      codsg_tab(2) := p_codsg2;
      codsg_tab(3) := p_codsg3;
      codsg_tab(4) := p_codsg4;
      codsg_tab(5) := p_codsg5;

      -- remplissage du tableau des codes projets spéciaux
      codpspe_tab(1) := p_codpspe1;
      codpspe_tab(2) := p_codpspe2;
      codpspe_tab(3) := p_codpspe3;
      codpspe_tab(4) := p_codpspe4;
      codpspe_tab(5) := p_codpspe5;

      BEGIN

      -- top indiquant la presence du paramètre dans les différentes tables
     presence :=0 ;
     ind :=1;
     --- DEBUT TEST COHERENCE DONNEES
     -- DEBUT traitement des codes dossiers projets
     for ind in 1..5 loop
         if (dpcode_tab(ind) <> ' ')
         then
            -- test d'existance du code dossier projet dans la table dossier_projet
             SELECT count(*) into presence FROM DOSSIER_PROJET WHERE dpcode = to_number(dpcode_tab(ind));
             if (presence = 0)
             then
                pack_global.recuperer_message( 21074, '%s1', dpcode_tab(ind), NULL, l_msg);
                RAISE_APPLICATION_ERROR( -20000, l_msg );
             else
                -- test d'existance du code dossier projet dans la table copi_exception
                SELECT count(*) into presence FROM copi_exceptions WHERE valeur = dpcode_tab(ind) and type_exception = 'DPCODE';
                if (presence <> 1)
                then
                   pack_global.recuperer_message( 21075, '%s1', dpcode_tab(ind)|| ' non', NULL, l_msg);
                   RAISE_APPLICATION_ERROR( -20000, l_msg );
                end if;
             end if;
         end if;
     end loop;
     -- FIN traitement des codes dossiers projets

     --- DEBUT traitement des codes projets
     for ind in 1..5 loop
          if (icpi_tab(ind) <> ' ')
          then
            --- Test format codes projet
            /*
            l_icpi := SUBSTR(icpi_tab(ind), 0, 1);
               IF ((l_icpi != 'P') AND (l_icpi != 'I')) THEN
                 Pack_Global.recuperer_message(20208, NULL, NULL, NULL, l_msg);
                 RAISE_APPLICATION_ERROR( -20208, l_msg );
               END IF;
               */
            IF pack_proj_info.check_cod_proj(icpi_tab(ind)) = 'FALSE' THEN
                Pack_Global.recuperer_message(20208, NULL, NULL, NULL, l_msg);
                RAISE_APPLICATION_ERROR( -20208, l_msg );
            END IF;

               -- test d'existance du code projet dans la table proj_info
               SELECT count(*) into presence FROM PROJ_INFO WHERE icpi = icpi_tab(ind);
               if (presence = 0)
               then
                   pack_global.recuperer_message( 21076, '%s1', icpi_tab(ind), NULL, l_msg);
                   RAISE_APPLICATION_ERROR( -20000, l_msg );
               else
                  -- test d'existance du code projet dans la table copi_exception
                  SELECT count(*) into presence FROM copi_exceptions WHERE valeur = icpi_tab(ind) and type_exception = 'ICPI';
                   if (presence <> 1)
                   then
                      pack_global.recuperer_message( 21077, '%s1', icpi_tab(ind)|| ' non', NULL, l_msg);
                      RAISE_APPLICATION_ERROR( -20000, l_msg );
                   end if;
               end if;

            end if;

       end loop;
     --- FIN traitement des codes projets

          --- DEBUT traitement des codes application
          for ind in 1..5 loop
          if (airt_tab(ind) <> ' ')
          then
            --- Test format codes application
            l_airt := SUBSTR(airt_tab(ind), 0, 1);



                    -- test d'existance du code application dans la table application
                    SELECT count(*) into presence FROM application WHERE airt = airt_tab(ind);
                    if (presence = 0)
                    then
                        pack_global.recuperer_message( 2027, '%s1', airt_tab(ind), NULL, l_msg);
                        RAISE_APPLICATION_ERROR( -20000, l_msg );
                    else
                        -- test d'existance du code application dans la table copi_exception
                        SELECT count(*) into presence FROM copi_exceptions WHERE valeur = airt_tab(ind) and type_exception = 'AIRT';
                        if (presence <> 1)
                        then
                            pack_global.recuperer_message( 21078, '%s1', airt_tab(ind)|| ' non', NULL, l_msg);
                            RAISE_APPLICATION_ERROR( -20000, l_msg );
                        end if;
                    end if;

            end if;

        end loop;
        --- FIN traitement des codes applications

       --- DEBUT traitement des codes client_mo
          for ind in 1..5 loop
          if (clicode_tab(ind) <> ' ')
          then
             -- test d'existance du code client dans la table client_mo
              SELECT count(*) into presence FROM client_mo WHERE clicode = clicode_tab(ind);
              if (presence = 0)
              then
                pack_global.recuperer_message( 4, '%s1', clicode_tab(ind), NULL, l_msg);
                RAISE_APPLICATION_ERROR( -20000, l_msg );
              else
              -- test d'existance du code client dans la table copi_exception
                  SELECT count(*) into presence FROM copi_exceptions WHERE valeur = clicode_tab(ind) and type_exception = 'CLICODE';
                  if (presence <> 1)
                  then
                    pack_global.recuperer_message( 21079, '%s1', clicode_tab(ind)|| ' non', NULL, l_msg);
                    RAISE_APPLICATION_ERROR( -20000, l_msg );
                  end if;
              end if;

            end if;

        end loop;
        --- FIN traitement des codes client_mo

        --- DEBUT traitement des codes dpg
          for ind in 1..5 loop
          if (codsg_tab(ind) <> ' ')
          then
             -- test d'existance du code dpg dans la table struct_info
              SELECT count(*) into presence FROM struct_info WHERE lpad(codsg,7,0) = lpad(codsg_tab(ind),7,0);
              if (presence = 0)
              then
                pack_global.recuperer_message( 21080, '%s1', codsg_tab(ind), NULL, l_msg);
                RAISE_APPLICATION_ERROR( -20000, l_msg );
              else
              -- test d'existance du code dpgdans la table copi_exception
                  SELECT count(*) into presence FROM copi_exceptions WHERE lpad(valeur,7,0) = lpad(codsg_tab(ind),7,0) and type_exception = 'CODSG';
                  if (presence <> 1)
                  then
                    pack_global.recuperer_message( 21081, '%s1', codsg_tab(ind)|| ' non', NULL, l_msg);
                    RAISE_APPLICATION_ERROR( -20000, l_msg );
                  end if;
              end if;

            end if;

        end loop;
        --- FIN traitement des codes dpg


        --- DEBUT traitement des codes projets spéciaux
          for ind in 1..5 loop
          if (codpspe_tab(ind) <> '---')
          then

              -- test d'existance du code projet special dans la table copi_exception
              SELECT count(*) into presence FROM copi_exceptions WHERE valeur = codpspe_tab(ind) and type_exception = 'CODPSPE';
              if (presence <> 1)
              then
                Select libpspe into libprojspe from proj_spe where codpspe = codpspe_tab(ind);
                pack_global.recuperer_message( 21082, '%s1', libprojspe || ' non', NULL, l_msg);
                RAISE_APPLICATION_ERROR( -20000, l_msg );
              end if;


            end if;

        end loop;
        --- FIN traitement des codes projets spéciaux
     --- FIN TEST COHERENCE DONNEES


     ---DEBUT INSERTION

      for ind in 1..5 loop

            -- DEBUT INSERTION DPCODE
            if (dpcode_tab(ind) <> ' ')
            then
                delete from copi_exceptions where type_exception = 'DPCODE' and valeur=dpcode_tab(ind);
            end if;
            -- FIN INSERTION DPCODE

            -- DEBUT INSERTION ICPI
            if (icpi_tab(ind) <> ' ')
            then
                delete from copi_exceptions where type_exception = 'ICPI' and valeur=icpi_tab(ind);
            end if;
            -- FIN INSERTION ICPI

            -- DEBUT INSERTION AIRT
            if (airt_tab(ind) <> ' ')
            then
                delete from copi_exceptions where type_exception = 'AIRT' and valeur=airt_tab(ind);
            end if;
            -- FIN INSERTION AIRT

            -- DEBUT INSERTION  CLICODE
            if (clicode_tab(ind) <> ' ')
            then
                delete from copi_exceptions where type_exception = 'CLICODE' and valeur=clicode_tab(ind);
            end if;
            -- FIN INSERTION clicode

            -- DEBUT INSERTION DPG
            if (codsg_tab(ind) <> ' ')
            then
                delete from copi_exceptions where type_exception = 'CODSG' and valeur=codsg_tab(ind);
            end if;
            -- FIN INSERTION DPG

            -- DEBUT INSERTION CODPSPE
            if (codpspe_tab(ind) <> '---')
            then
                delete from copi_exceptions where type_exception = 'CODPSPE' and valeur=CODPSPE_tab(ind);
            end if;
            -- FIN INSERTION CODPSPE

      end loop;

      p_message := 'Suppression des données réalisées';

     ---FIN INSERTION



     END;

   END supprimer_exception_copi;


    ---------------------- Lister toutes les Dates COPI ---------------------------------------
  PROCEDURE lister_datesCopi (p_userid     IN VARCHAR2,
                                p_curDatesCopi IN OUT datesCopiCurType
                              ) IS

  l_msg VARCHAR(1024);
   BEGIN

      BEGIN
         OPEN p_curDatesCopi FOR
          SELECT
            TO_CHAR(DATE_COPI,'DD/MM/YYYY') ,
            TO_CHAR(DATE_COPI,'DD/MM/YYYY')
          FROM COPI_DATES ORDER BY DATE_COPI
         ;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_datesCopi;

       ---------------------- Lister les Dates COPI utilisées par les budgets ---------------------------------------
  PROCEDURE lister_datesCopibudget  (p_userid     IN VARCHAR2,
                                p_dpcopi    IN VARCHAR2,
                                p_annee     IN VARCHAR2,
                          p_curDatesCopi IN OUT datesCopiCurType
                                  ) IS

  l_msg VARCHAR(1024);
   BEGIN

      BEGIN
         OPEN p_curDatesCopi FOR
            SELECT '' datecopi,
          ' ' lib_datecopi

        FROM DUAL
        UNION
            SELECT distinct
            TO_CHAR(DATE_COPI,'DD/MM/YYYY') datecopi,
           TO_CHAR(DATE_COPI,'DD/MM/YYYY') lib_datecopi
          FROM BUDGET_COPI
          where
          to_char(annee) = p_annee
          and dp_copi = p_dpcopi

        -- group by date_copi;
         order by lib_datecopi;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_datesCopibudget;

   /*----------------------------- Insert Date COPI ------------------------------------*/
PROCEDURE insert_date_copi( p_datecopi IN VARCHAR2,
                            p_message OUT VARCHAR2
                            ) IS

     l_msg VARCHAR2(1024);

    BEGIN

        insert into copi_dates values (to_date(p_datecopi,'DD/MM/YYYY'));
        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
           pack_global.recuperer_message( 21083, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20001, l_msg );



END insert_date_copi;

PROCEDURE supprimer_date_copi( p_datecopi IN VARCHAR2,
                            p_message OUT VARCHAR2
                            ) IS

     l_msg VARCHAR2(1024);
     referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

    BEGIN

        delete from copi_dates where date_copi = p_datecopi;
        EXCEPTION
       WHEN referential_integrity THEN
                 pack_global.recuperer_message( 21102, '%s1', p_datecopi,  NULL, l_msg);
                       p_message := l_msg;
                       raise_application_error( -20199, l_msg );



END supprimer_date_copi;






PROCEDURE insert_fourCopi( p_code_four_copi       IN  VARCHAR2,
                                p_libelle              IN VARCHAR2,
                           p_message              OUT VARCHAR2
                              ) IS

l_msg varchar2(1024);

BEGIN


     insert into copi_four values (to_number(p_code_four_copi), p_libelle);

     Pack_Global.recuperer_message( 21091, '%s1', p_code_four_copi , NULL, l_msg);
     p_message := l_msg;


end insert_fourCopi;


PROCEDURE update_fourCopi ( p_code_four_copi       IN  VARCHAR2,
                                 p_libelle              IN VARCHAR2,
                            p_message              OUT VARCHAR2
                          ) IS
   l_msg varchar2(1024);

BEGIN

    update copi_four set libelle_four_copi = p_libelle where code_four_copi = to_number(p_code_four_copi);

    Pack_Global.recuperer_message( 21092, '%s1', p_code_four_copi , NULL, l_msg);
     p_message := l_msg;

end update_fourCopi;


PROCEDURE delete_fourCopi (  p_code_four_copi       IN  VARCHAR2,
                               p_message               OUT VARCHAR2
                             ) IS
      l_msg varchar2(1024);
      referential_integrity EXCEPTION;
       PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

    BEGIN




BEGIN


     DELETE FROM copi_four
            WHERE code_four_copi = TO_NUMBER(p_code_four_copi );

    Pack_Global.recuperer_message( 21093, '%s1', p_code_four_copi , NULL, l_msg);
     p_message := l_msg;

      EXCEPTION
       WHEN referential_integrity THEN
                 pack_global.recuperer_message( 21103, '%s1', p_code_four_copi,  NULL, l_msg);
                       p_message := l_msg;
                       raise_application_error( -20199, l_msg );

    end;
end delete_fourCopi;


PROCEDURE select_fourCopi(  p_code_four_copi       IN  VARCHAR2,
                                 p_libelle              IN out VARCHAR2,
                            p_message              OUT VARCHAR2
                         ) IS

      l_msg varchar2(1024);
      nombre NUMBER ;

BEGIN

    select count(*) into nombre from copi_four where code_four_copi = p_code_four_copi ;

    IF(nombre=1) THEN
        select libelle_four_copi into p_libelle from copi_four where code_four_copi = p_code_four_copi ;
    ELSE
        p_libelle := NULL ;
    END IF ;


    exception
    when others then
        raise_application_error( -20997, l_msg);


end select_fourCopi;


PROCEDURE lister_fourcopi( p_nomRecherche    IN VARCHAR2,
                               s_curseur     IN OUT FourCopiCurType
                            ) IS

l_msg           VARCHAR2(1024);


BEGIN
       BEGIN

    OPEN s_curseur  FOR
         SELECT code_four_copi, libelle_four_copi
                FROM copi_four
             WHERE
             UPPER(libelle_four_copi)  LIKE '%' || UPPER(p_nomRecherche) || '%'
              ORDER BY libelle_four_copi ;



       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_fourcopi;


       ---------------------- Lister les Four COPI utilisées par les budgets ---------------------------------------
  PROCEDURE lister_fourcopibud( p_userId   IN VARCHAR2,
                              p_dpcopi IN VARCHAR2,
                              p_annee IN VARCHAR2,
                              p_datecopi IN VARCHAR2,
                              p_metier IN VARCHAR2,
                              p_curseur     IN OUT FourCopiCurType
                            ) IS

  l_msg VARCHAR(1024);
   BEGIN

      BEGIN
         OPEN p_curseur FOR
            SELECT '' code_four_copi,
          ' ' libelle

        FROM DUAL
        UNION
            SELECT distinct
            to_char(bud.code_four_copi) code_four_copi,
           four.LIBELLE_FOUR_COPI libelle
          FROM BUDGET_COPI bud, COPI_FOUR four
          where
          bud.CODE_FOUR_COPI = four.CODE_FOUR_COPI
          and to_char(bud.annee) = p_annee
          and to_char(bud.date_copi,'DD/MM/YYYY') = p_datecopi
          and bud.dp_copi = p_dpcopi
          and bud.metier = p_metier

          order by libelle;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_fourcopibud;


 PROCEDURE select_BudgetCopi (  p_dpcopi IN VARCHAR2,
                                p_datecopi IN VARCHAR2 ,
                                p_metier IN VARCHAR2 ,
                                p_annee   IN VARCHAR2 ,
                                p_fourcopi IN VARCHAR2,
                                p_cur  IN OUT budget_copiCurType,
                               p_nbcurseur             OUT INTEGER,
                               p_message               OUT VARCHAR2
                              ) IS
      l_msg VARCHAR(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN   p_cur FOR
               SELECT          DP_COPI  ,
                              TO_CHAR( ANNEE)   ,
                              TO_CHAR(DATE_COPI,'DD/MM/YYYY') ,
                              TO_CHAR(CODE_FOUR_COPI) ,
                              METIER ,
                              TO_CHAR(CODE_TYPE_DEMANDE) ,
                              TO_CHAR(JH_COUTTOTAL,'FM999999999990D00')  ,
                              TO_CHAR(JH_ARBDEMANDES,'FM999999999990D00')  ,
                              TO_CHAR(JH_ARBDECIDES,'FM999999999990D00')  ,
                              TO_CHAR(JH_CANTDEMANDES,'FM999999999990D00')  ,
                              TO_CHAR(JH_CANTDECIDES,'FM999999999990D00'),
                              to_char(JH_PREVIDECIDE,'FM999999999990D00')
                    FROM BUDGET_COPI
                    WHERE DP_COPI =  UPPER(p_dpcopi)
                    AND DATE_COPI = TO_DATE(p_datecopi,'DD/MM/YYYY')
                    AND ANNEE = TO_NUMBER(p_annee)
                    AND METIER = p_metier
                    and CODE_FOUR_COPI =  to_number(p_fourcopi);

          EXCEPTION
          WHEN referential_integrity THEN
                Pack_Global.recuperer_message( 21100, NULL, NULL, NULL, l_msg);
                raise_application_error (-21100, l_msg);
          WHEN OTHERS THEN
            pack_global.recuperer_message(21118, '%s1', p_dpcopi, NULL, l_msg);
            raise_application_error( -21087, l_msg );
      END;


   END select_BudgetCopi;





   PROCEDURE lister_direction_client( p_userid   IN       VARCHAR2,
                                                                                      p_curseur  IN OUT Pack_Liste_Dynamique.liste_dyn
                                                                            ) IS

    BEGIN


      OPEN p_curseur FOR





      SELECT
                 clicode,
                 clicode|| ' - ' || clilib
       FROM Client_mo
       where CLITOPF = 'O'
       ORDER BY clilib ;



    END lister_direction_client;


PROCEDURE lister_anneeCopibud (p_userid     IN VARCHAR2,
                                p_dpcopi    IN VARCHAR2,
                          p_curAnneeCopi IN OUT AnneeCopiBudCurType
                                  )  IS

  l_msg VARCHAR(1024);
   BEGIN

      BEGIN
         OPEN p_curAnneeCopi FOR
          SELECT '' annee,
          ' ' lib_annee

        FROM DUAL
        UNION
          SELECT
            to_char(bud.annee) annee,
            to_char(bud.annee) lib_annee
          FROM budget_copi bud
          where bud.DP_COPI = p_dpcopi
          ORDER BY lib_annee
         ;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_anneeCopibud;


-----------------------------------------------------------------------------------------------------------
------------------------- COPI PARTIE QUALITATIVE ---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------




  ---------------------- Lister les Axes Stratégiques du DP COPI ---------------------------------------
  PROCEDURE lister_axesStrategiques (p_userid     IN VARCHAR2,
                                p_curAxestrat IN OUT axeStrategiqueCurType
                              ) IS

  l_msg VARCHAR(1024);
   BEGIN

      BEGIN
         OPEN p_curAxestrat FOR
          SELECT '',
               ' ' LIB
          FROM DUAL
        UNION
          SELECT
            TO_CHAR(NUMERO) ,
            LIBELLE LIB
            FROM COPI_AXE_STRATEGIQUE ORDER BY LIB ;


      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_axesStrategiques;


  ---------------------- Lister les Axes Stratégiques du DP COPI ---------------------------------------
  PROCEDURE lister_typeFinancement (p_userid     IN VARCHAR2,
                                p_curTypeFinan IN OUT axeStrategiqueCurType
                              ) IS

  l_msg VARCHAR(1024);
   BEGIN

      BEGIN
         OPEN p_curTypeFinan FOR
          SELECT
            TO_CHAR(NUMERO) ,
            LIBELLE LIB
            FROM COPI_TYPE_FINANCEMENT ORDER BY LIB ;


      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_typeFinancement;


  ---------------------- Lister les Etapes du DP COPI ---------------------------------------
    PROCEDURE lister_EtapesDpCopi (p_userid     IN VARCHAR2,
                                p_curEtapesCopi IN OUT etapesCopiCurType
                              ) IS

  l_msg VARCHAR(1024);
   BEGIN

      BEGIN
         OPEN p_curEtapesCopi FOR
          SELECT '',
               ' ' LIB
          FROM DUAL
           UNION
          SELECT
            TO_CHAR(NUMERO) ,
            LIBELLE LIB
          FROM COPI_ETAPE ORDER BY LIB
         ;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_EtapesDpCopi;


-------------------- Notation COPI ---------------------------
 PROCEDURE verifie_NotationDPCopi (  p_dpcopi      IN VARCHAR2 ,
                                        p_message     OUT VARCHAR2
                              ) IS
      l_msg VARCHAR(1024);
      l_nombre NUMBER ;

   BEGIN


      BEGIN


       SELECT COUNT(*) INTO  l_nombre FROM  COPI_NOTATION
       WHERE TRIM(DP_COPI)  LIKE UPPER(TRIM(p_dpcopi)) ;

       IF(l_nombre>0) THEN
            pack_global.recuperer_message(21113, '%s1', p_dpcopi, NULL, l_msg);
            p_message := l_msg ;
       END IF ;

        EXCEPTION
          WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;


   END verifie_NotationDPCopi;



PROCEDURE insert_NotationDpCopi (p_dpcopi               IN  VARCHAR2,
                                     p_etape            IN  VARCHAR2,
                                     p_dirprojet        IN  VARCHAR2,
                                     p_respbancaires    IN  VARCHAR2,
                                     p_sponsors         IN  VARCHAR2,
                                     p_axestrateg       IN  VARCHAR2,
                                     p_bloc   IN  VARCHAR2,
                                     p_domaine      IN  VARCHAR2,
                                     p_notetrateg   IN  VARCHAR2,
                                     p_noteroi      IN  VARCHAR2,
                                     p_prochaincopi IN  VARCHAR2,
                                     p_coddir       IN  VARCHAR2,
                                     p_userid       IN  VARCHAR2,
                                     p_message      OUT VARCHAR2
                                    ) IS

   l_msg VARCHAR2(1024);
   l_dpcode DOSSIER_PROJET.DPCODE%TYPE;
   l_clicode CLIENT_MO.CLICODE%TYPE;
   l_nombre NUMBER ;

   BEGIN

     --Vérifie que le DPCOPI n'a pas déjà une Notation
     -- Si jamais quelqu'un l'avait crée juste la seconde avant !!

       SELECT COUNT(*) INTO  l_nombre FROM  COPI_NOTATION
       WHERE TRIM(DP_COPI) LIKE UPPER(p_dpcopi) ;
       IF(l_nombre>0) THEN
            pack_global.recuperer_message(21113, '%s1', p_dpcopi, NULL, l_msg);
            raise_application_error(  -20997, l_msg );
       END IF ;


      BEGIN

         INSERT INTO COPI_NOTATION (
                                          DP_COPI,
                                          ETAPE              ,
                                          DIRECTEURS_PROJET  ,
                                          RESP_BANCAIRES     ,
                                          SPONSORS           ,
                                          AXE_STRATEGIQUE    ,
                                          BLOC    ,
                                          DOMAINE  ,
                                          NOTE_STRATEGIQUE   ,
                                          NOTE_ROI           ,
                                          PROCHAIN_COPI     ,
                                          CODDIR )
                VALUES (
                        UPPER(p_dpcopi),
                        TO_NUMBER(p_etape) ,
                        p_dirprojet        ,
                        p_respbancaires    ,
                        p_sponsors         ,
                        TO_NUMBER(p_axestrateg)     ,
                        p_bloc ,
                        p_domaine     ,
                        TO_NUMBER(p_notetrateg)   ,
                        TO_NUMBER(p_noteroi)      ,
                        TO_DATE(p_prochaincopi,'DD/MM/YYYY') ,
                        TO_NUMBER(p_coddir)
                       );


         pack_global.recuperer_message(21114,'%s1',p_dpcopi, NULL, l_msg);
         p_message := l_msg;

          EXCEPTION
          WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM );


     END;



   END insert_NotationDpCopi;


PROCEDURE select_notation_dpcopi (    p_dpcopi   IN  COPI_NOTATION.dp_copi%TYPE,
                                      p_userid             IN VARCHAR2,
                                      p_curseur IN OUT notation_dpcopi_copiCurType,
                                      p_nbcurseur             OUT INTEGER,
                                      p_message               OUT VARCHAR2
                                    )  IS

      l_msg VARCHAR(1024);
      l_libelle_lu VARCHAR2(70) ;

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

         OPEN p_curseur FOR
              SELECT
                  notif.DP_COPI        ,
                  TO_CHAR(notif.ETAPE) ,
                  notif.DIRECTEURS_PROJET ,
                  notif.RESP_BANCAIRES    ,
                  notif.SPONSORS          ,
                  TO_CHAR(notif.AXE_STRATEGIQUE),
                  notif.BLOC,
                  notif.DOMAINE,
                  TO_CHAR(notif.NOTE_STRATEGIQUE),
                  TO_CHAR(notif.NOTE_ROI),
                  TO_CHAR(notif.PROCHAIN_COPI,'DD/MM/YYYY'),
                  TO_CHAR(notif.CODDIR) ,
                  notif.FLAGLOCK ,
                  et.numero || ' - ' || et.libelle ,
                  axe.numero || ' - ' ||axe.libelle ,
                  bloc.code_b || ' - ' || bloc.libelle ,
                  dom.code_d ||' - ' ||dom.libelle
              FROM COPI_NOTATION notif ,copi_etape et,
                  copi_axe_strategique axe, bloc bloc ,
                  domaine dom
              WHERE notif.dp_copi = UPPER(p_dpcopi)
              AND notif.AXE_STRATEGIQUE = axe.numero
              AND notif.ETAPE = et.numero
              AND notif.BLOC = bloc.code_b
              AND notif.DOMAINE = dom.code_d
              AND ROWNUM = 1 ;

      EXCEPTION
         WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
      END;

      pack_global.recuperer_message(21118, '%s1', p_dpcopi, NULL, l_msg);
      p_message := l_msg;

   END select_notation_dpcopi

   ;




PROCEDURE delete_notation_dpcopi (p_dpcopi   IN  COPI_NOTATION.dp_copi%TYPE,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                    )IS

      l_msg VARCHAR(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN

           DELETE FROM COPI_NOTATION WHERE dp_copi = UPPER(p_dpcopi)
           AND FLAGLOCK = p_flaglock ;

           COMMIT ;

      EXCEPTION
         WHEN referential_integrity THEN
               pack_global.recuperer_message(21116,'%s1',p_dpcopi, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20757, l_msg);
            --pack_global.recuperation_integrite(-2292);
            --raise_application_error(-20997,SQLERRM);

         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;


       pack_global.recuperer_message(21117, '%s1', p_dpcopi, NULL, l_msg);
       p_message := l_msg;


   END delete_notation_dpcopi;



 PROCEDURE update_notation_dpcopi (
                                     p_dpcopi           IN  VARCHAR2,
                                     p_etape            IN  VARCHAR2,
                                     p_dirprojet        IN  VARCHAR2,
                                     p_respbancaires    IN  VARCHAR2,
                                     p_sponsors         IN  VARCHAR2,
                                     p_axestrateg       IN  VARCHAR2,
                                     p_bloc   IN  VARCHAR2,
                                     p_domaine     IN  VARCHAR2,
                                     p_notetrateg   IN  VARCHAR2,
                                     p_noteroi      IN  VARCHAR2,
                                     p_prochaincopi IN  VARCHAR2,
                                     p_coddir       IN  VARCHAR2,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                   ) IS

      l_msg VARCHAR(1024);

   BEGIN


      p_nbcurseur := 0;
      p_message := '';


      BEGIN
          UPDATE COPI_NOTATION SET


              ETAPE             = TO_NUMBER(p_etape) ,
              DIRECTEURS_PROJET = p_dirprojet ,
              RESP_BANCAIRES    = p_respbancaires ,
              SPONSORS          = p_sponsors ,
              AXE_STRATEGIQUE   = TO_NUMBER(p_axestrateg) ,
              BLOC   = p_bloc ,
              DOMAINE  = p_domaine ,
              NOTE_STRATEGIQUE  = TO_NUMBER(p_notetrateg) ,
              NOTE_ROI          = TO_NUMBER(p_noteroi) ,
              PROCHAIN_COPI     = TO_DATE(p_prochaincopi,'DD/MM/YYYY'),
              CODDIR            = TO_NUMBER(p_coddir) ,
              FLAGLOCK          = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
          WHERE DP_COPI = UPPER(p_dpcopi)
           AND  FLAGLOCK = p_flaglock;

      EXCEPTION
           WHEN OTHERS THEN
              raise_application_error(-20757, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         raise_application_error( -20757, l_msg );
      ELSE
        pack_global.recuperer_message(21119, '%s1', p_dpcopi, NULL, l_msg);
        p_message := l_msg;
      END IF;

   END  update_notation_dpcopi ;



------------------------------------------------------------------------------------------------------
----------------- GESTION TABLES REFERENCE DE LA PARTIE QUALITATIVE DU COPI --------------------------
------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------
------------------- GESTION AXES STRATEGIQUES COPI -------------------------
----------------------------------------------------------------------------

----------------- INSERT -------------------------------------------------------------
PROCEDURE insert_AxeStrategique(
                           p_libelle        IN VARCHAR2,
                           p_userid         IN VARCHAR2,
                           p_message        OUT VARCHAR2
                          ) IS
l_msg varchar2(1024);
l_numero_suivant NUMBER ;
l_count NUMBER ;
l_user varchar2(30);

BEGIN

l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

    SELECT COUNT(*) INTO l_count FROM COPI_AXE_STRATEGIQUE ;

     IF l_count > 0 THEN
         SELECT MAX(numero) INTO l_numero_suivant FROM  COPI_AXE_STRATEGIQUE  ;
         l_numero_suivant := l_numero_suivant + 1 ;
     ELSE
            l_numero_suivant := 0 ;
     END IF ;

     INSERT INTO COPI_AXE_STRATEGIQUE (NUMERO,LIBELLE) VALUES (l_numero_suivant, p_libelle);
     
     --PPM 58143 QC 1611
     INSERT INTO copi_axe_strategique_logs (AXE_STRATEGIQUE,DATE_LOG,USER_LOG,COLONNE,VALEUR_PREC,VALEUR_NOUV,COMMENTAIRE) 
                          VALUES (l_numero_suivant, sysdate,l_user,'LIBELLE',null,p_libelle,'Création de l''enveloppe budgétaire');

     Pack_Global.recuperer_message( 21120, '%s1', p_libelle , NULL, l_msg);

     p_message := l_msg;
END insert_AxeStrategique;

----------------- UPDATE -------------------------------------------------------------
PROCEDURE update_AxeStrategique ( p_code      IN  VARCHAR2,
                                 p_libelle    IN VARCHAR2,
                                 p_userid         IN VARCHAR2,
                                 p_message    OUT VARCHAR2
                          ) IS
 l_msg varchar2(1024);
 l_count NUMBER ;
 l_old_libelle varchar2(50);
l_user varchar2(30);

BEGIN

l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

    select libelle into l_old_libelle from copi_axe_strategique 
    where numero=p_code;

    UPDATE COPI_AXE_STRATEGIQUE SET libelle = p_libelle WHERE numero = to_number(p_code);
    Pack_Global.recuperer_message( 21121, NULL, NULL , NULL, l_msg);
    p_message := l_msg;
    
    --PPM 58143 QC 1611
     INSERT INTO copi_axe_strategique_logs (AXE_STRATEGIQUE,DATE_LOG,USER_LOG,COLONNE,VALEUR_PREC,VALEUR_NOUV,COMMENTAIRE) 
                          VALUES (p_code, sysdate,l_user,'LIBELLE',l_old_libelle,p_libelle,'Modification de l''enveloppe budgétaire');

END update_AxeStrategique;

----------------- DELETE -------------------------------------------------------------
PROCEDURE delete_AxeStrategique (  p_code       IN  VARCHAR2,
                                   p_userid         IN VARCHAR2,
                                   p_message    OUT VARCHAR2
                             ) IS
      l_msg varchar2(1024);
      l_lib_axe VARCHAR2(50) ;
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
l_user varchar2(30);

BEGIN

l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      BEGIN

         SELECT LIBELLE INTO  l_lib_axe FROM COPI_AXE_STRATEGIQUE WHERE numero = TO_NUMBER(p_code) ;
         DELETE FROM COPI_AXE_STRATEGIQUE WHERE numero = TO_NUMBER(p_code);
         Pack_Global.recuperer_message( 21122, '%s1', l_lib_axe , NULL, l_msg);
         p_message := l_msg;
         
         --PPM 58143 QC 1611
     INSERT INTO copi_axe_strategique_logs (AXE_STRATEGIQUE,DATE_LOG,USER_LOG,COLONNE,VALEUR_PREC,VALEUR_NOUV,COMMENTAIRE) 
                          VALUES (p_code, sysdate,l_user,'TOUTES','TOUTES',null,'Suppression de l''enveloppe budgétaire');
         
      EXCEPTION
       WHEN referential_integrity THEN
            pack_global.recuperer_message( 21123, '%s1', l_lib_axe,  NULL, l_msg);
            p_message := l_msg;
            raise_application_error( -20199, l_msg );
       WHEN OTHERS THEN
            raise_application_error( -20997, l_msg);
    END;
END delete_AxeStrategique;

----------------- SELECT -------------------------------------------------------------
PROCEDURE select_AxeStrategique(  p_code        IN  VARCHAR2,
                                  p_libelle     IN out VARCHAR2,
                                  p_message     OUT VARCHAR2
                                ) IS
l_msg varchar2(1024);
nombre NUMBER ;

BEGIN

    SELECT COUNT(*) INTO nombre FROM COPI_AXE_STRATEGIQUE WHERE numero = p_code ;
    IF(nombre=1) THEN
        SELECT libelle  INTO p_libelle FROM COPI_AXE_STRATEGIQUE WHERE numero = p_code ;
    ELSE
        p_libelle := NULL ;
    END IF ;
    EXCEPTION
    WHEN others THEN
        raise_application_error( -20997, l_msg);

END select_AxeStrategique;




----------------------------------------------------------------------------
------------------- GESTION ETAPES  COPI ---------------------------
----------------------------------------------------------------------------

----------------- INSERT -------------------------------------------------------------
PROCEDURE insert_EtapeCopi(
                           p_libelle        IN VARCHAR2,
                           p_message        OUT VARCHAR2
                          ) IS

l_msg varchar2(1024);
l_count NUMBER ;
l_numero_suivant  NUMBER ;

BEGIN



    SELECT COUNT(*) INTO l_count FROM   COPI_ETAPE ;

     IF l_count > 0 THEN
         SELECT MAX(numero) INTO l_numero_suivant FROM   COPI_ETAPE;
         l_numero_suivant := l_numero_suivant + 1 ;
     ELSE
            l_numero_suivant := 0 ;
     END IF ;


     INSERT INTO COPI_ETAPE (NUMERO,LIBELLE) VALUES (l_numero_suivant, p_libelle);
     Pack_Global.recuperer_message( 21132, '%s1', p_libelle , NULL, l_msg);
     p_message := l_msg ;

END insert_EtapeCopi;

----------------- UPDATE -------------------------------------------------------------
PROCEDURE update_EtapeCopi ( p_code      IN  VARCHAR2,
                                 p_libelle    IN VARCHAR2,
                                 p_message    OUT VARCHAR2
                          ) IS
 l_msg varchar2(1024);
BEGIN
    UPDATE COPI_ETAPE SET libelle = p_libelle WHERE numero = to_number(p_code);
    Pack_Global.recuperer_message( 21133, NULL, NULL, NULL, l_msg);
    p_message := l_msg;

END update_EtapeCopi;

----------------- DELETE -------------------------------------------------------------
PROCEDURE delete_EtapeCopi (  p_code       IN  VARCHAR2,
                                   p_message    OUT VARCHAR2
                             ) IS
      l_msg varchar2(1024);
      referential_integrity EXCEPTION;
      l_lib_axe varchar2(50);
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
  BEGIN

      BEGIN
         SELECT LIBELLE INTO  l_lib_axe FROM COPI_ETAPE WHERE numero = TO_NUMBER(p_code) ;
         DELETE FROM COPI_ETAPE WHERE numero = TO_NUMBER(p_code);
         Pack_Global.recuperer_message( 21134, '%s1',  l_lib_axe , NULL, l_msg);
         p_message := l_msg;
      EXCEPTION
       WHEN referential_integrity THEN
            pack_global.recuperer_message( 21135, '%s1',  l_lib_axe,  NULL, l_msg);
            p_message := l_msg;
            raise_application_error( -20199, l_msg );
       WHEN OTHERS THEN
            raise_application_error( -20997, l_msg);
    END;
END delete_EtapeCopi;

----------------- SELECT -------------------------------------------------------------
PROCEDURE select_EtapeCopi(  p_code        IN  VARCHAR2,
                                  p_libelle     IN out VARCHAR2,
                                  p_message     OUT VARCHAR2
                                ) IS
l_msg varchar2(1024);
nombre NUMBER ;

BEGIN

    SELECT COUNT(*) INTO nombre FROM COPI_ETAPE WHERE numero = p_code ;
    IF(nombre=1) THEN
        SELECT libelle  INTO p_libelle FROM COPI_ETAPE WHERE numero = p_code ;
    ELSE
        p_libelle := NULL ;
    END IF ;
    EXCEPTION
    WHEN others THEN
        raise_application_error( -20997, l_msg);

END select_EtapeCopi;



END pack_copi_referentiel;
/


