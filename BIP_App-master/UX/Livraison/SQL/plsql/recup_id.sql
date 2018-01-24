-- pack_recup_id PL/SQL
-- 
-- Créé le 27/06/2005 JMA
--
-- Modifié le 27/06/2005 par JMA : REchercher ID Chef de Projet
-- Modifié le 12/09/2005 par DDI : Modif de la recherche societes
-- Modifié le 21/09/2005 par BAA : Ajout de la recherche client
-- Modifié le 23/09/2005 par DDI : Ajout de la recherche code projet
-- Modifié le 03/10/2005 par JMA : Ajout de la recherche code comptable
-- Modifié le 03/10/2005 par JMA : Ajout de la recherche code prestation
-- Modifié le 05/10/2005 par BAA : Ajout de la recharche code ligne bip 
-- Modifié le 14/11/2005 par JMA : Ajout de la recherche code table de répartition
-- Modifié le 01/12/2005 par JMA : Ajout de la recherche code application
-- Modifié le 12/12/2005 par BAA : Ajout de la recherche id ressource selon le type
-- Modifié le 14/12/2005 par BAA : Ajout du message pour les recherche sans resultat
-- Modifié le 08/02/2006 par BAA : Ajout du message pour les recherche des rubriques
-- Modifié le 21/03/2006 par BAA : Fiche 377 Ajout loop pour la recherche contrat/avenant et 
--			           la recherche facture/avoir
-- Modifié le 19/06/2006 par PPR : Ajout de la société dans la liste des personnes (selon le type)
-- Modifié le 19/06/2006 par BAA : Enlever les rownum
-- Modifié le 26/07/2006 par ASA : Ajout de la recherche code investissement
-- Modifié le 29/08/2006 par ASA : Ajout de la recherche code dossier projet
-- Modifié le 27/09/2006 par PPR : Remplace SITU_RESS par SITU_RESS_FULL dans lister_cdp_type
-- Modifié le 22/08/2007 par JAL  :  Rajout recherche de matricules
-- Modifié le 10/04/2007 par EVI : Ajout d'un filtre (dans lister_codePresta) afin de ne recuperer que les presta liée au SSII (F,L,P)
-- Modifié le 31/03/2008 par ABA : Ajout de la recherche des directions et Projets Spécial 
-- Modifié le 24/04/2008 par JAL : Ajout recherche Dossier Projet COPI
-- Modifié le 24/04/2008 par JAL : Ajout recherche Dossier Projet COPI par DPCODE
-- Modifié le 28/05/2008 par ABA : modification recherche DP COPI pour chercher egalement dans la table budget
-- Modifié le 29/05/2008 par ABA : ajout liste recherche des client appartenant à BDDF pour le COPI
-- Modifié le 04/08/2008 par EVI : TD 637 refonte societe
-- Modifié le 11/09/2008 par JAL : rajout récupération groupe société
-- Modifié le 17/10/2008 par ABA : ajout recherche societe via ajax
-- Modifié le 06/11/2008 par EVI : TD 710 ajout recherche ressource, contrat, siren et fournisseur via ajax
-- Modifié le 08/12/2008 par ABA : TD 721 
-- Modifié le 09/01/2009 par ABA : TD 723 ajout recherche ajax dpcopi provisoire 
-- Modifié le 25/02/2009 par ABA : TD 735 ajout recherche ajax libellé projet Audit
-- Modifié le 06/03/2009 par ABA : TD 755 ajout recherche ajax libellé application
-- Modifié le 06/03/2009 par ABA : TD 737  modif proc lister_contrat
-- Modifié le 17/04/2009 par EVI : TD737 augmentation de la taille du numero de contrat + avenant 27+3
-- Modifié le 20/04/2009 par ABA : TD 737  modif proc lister_contrat
-- Modifié le 29/05/2009 par ABA : TD 760  ajout recherche dossier projet immobilisé en fonction des habilitations du user
-- Modifié le 15/01/2010 par YNI : TD 918  gestion du nom du responsable DPG
-- Modifié le 16/08/2010 par YNI : TD 970  
-- 24/09/2010 YSB FDT 970
-- Modifiée le 13/01/2011 par ABA Fiche 1095
-- Modifiée le 27/01/2011 par CMA Fiche 1028
-- Modifiée le 01/09/2011 par ABA Fiche 1233
--***********************************************************************************

CREATE OR REPLACE PACKAGE       "PACK_RECUP_ID" AS


temp VARCHAR2(36);
temp1 VARCHAR2(36);

TYPE cdp_liste_ViewType IS RECORD ( IDENT NUMBER(5),
                    RNOM VARCHAR2(30),
                    RPRENOM VARCHAR2(15),
                    SOCCODE VARCHAR2(4) );

TYPE cdp_listeCurType IS REF CURSOR RETURN cdp_liste_ViewType;



TYPE cdp_societe_ViewType IS RECORD ( SOCCODE VARCHAR2(4),
                    SOCLIB VARCHAR2(25),
                    SIREN  AGENCE.SIREN%TYPE,
                    SOCAD1 VARCHAR2(25),
                    SOCAD2 VARCHAR2(25),
                    SOCFER VARCHAR2(10),
                    SOCGRPE VARCHAR2(4));

TYPE societe_listeCurType IS REF CURSOR RETURN cdp_societe_ViewType;

TYPE projet_liste_ViewType IS RECORD ( ICPI CHAR(5),
                       ILIBEL VARCHAR2(50) );

TYPE projet_listeCurType IS REF CURSOR RETURN projet_liste_ViewType;

TYPE invest_liste_ViewType IS RECORD ( CODTYPE NUMBER(4),
                       LIB_TYPE VARCHAR2(64) );

TYPE invest_listeCurType IS REF CURSOR RETURN invest_liste_ViewType;


PROCEDURE lister_cdTypeInv( p_nomRecherche     IN VARCHAR2,
                    p_curseur     IN OUT invest_listeCurType
                            ) ;
PROCEDURE lister_projet( d_nomRecherche     IN VARCHAR2,
                    d_curseur     IN OUT projet_listeCurType
                            );


PROCEDURE lister_cdp( p_nomRecherche     IN VARCHAR2,
                      p_curseur     IN OUT cdp_listeCurType
                    );


PROCEDURE lister_cdp_type( p_nomRecherche     IN VARCHAR2,
                           p_rtype    IN VARCHAR2,
                           p_curseur     IN OUT cdp_listeCurType
                          );


PROCEDURE lister_cdp_compatible( p_nomRecherche     IN VARCHAR2,
                                 p_rtype      IN VARCHAR2,
                                 p_soccont    IN VARCHAR2,
                                 p_lresdeb    IN VARCHAR2,
                                 p_lresfin    IN VARCHAR2,
                                 p_numcont IN VARCHAR2,
                                 p_cav IN VARCHAR2,
                                 p_curseur    IN OUT cdp_listeCurType
                                );

PROCEDURE lister_societe( p_nomRechercheSociete     IN VARCHAR2,
                          s_curseur     IN OUT societe_listeCurType
                          );

PROCEDURE lister_societe_ouvert( p_nomRechercheSociete     IN VARCHAR2,
                                 p_userid        IN  VARCHAR2,
                                 s_curseur     IN OUT societe_listeCurType
                            );
PROCEDURE lister_societeAjax( p_nomRechercheSociete     IN VARCHAR2,
                    s_curseur     IN OUT societe_listeCurType
                            );

TYPE ca_ViewType IS RECORD ( CODCAMO NUMBER(6),
                    CLIBRCA CHAR(16),
                    CLIBCA VARCHAR2(30) );

TYPE ca_listeCurType IS REF CURSOR RETURN ca_ViewType;



PROCEDURE lister_ca( p_nomRechercheCa     IN VARCHAR2,
                                                    p_cafidpg     IN VARCHAR2,
                                                     p_curseur     IN OUT ca_listeCurType
                                                 );


TYPE rubrique_ViewType IS RECORD ( CODRUB  NUMBER(5),
                                                                                                   LIBELLE    VARCHAR2(70),
                                                                                 CAFI           NUMBER(6),
                                                                                 LIBCAFI     VARCHAR2(20)
                                                                                 );

TYPE rubrique_listeCurType IS REF CURSOR RETURN rubrique_ViewType;



PROCEDURE lister_rubrique( p_nomRechercheRubrique     IN VARCHAR2,
                                                                  p_curseur     IN OUT rubrique_listeCurType
                                                             );



TYPE dpg_liste_ViewType IS RECORD ( CODSG NUMBER(7),
                    LIBDSG VARCHAR2(30) );


TYPE dpg_listeCurType IS REF CURSOR RETURN dpg_liste_ViewType;



PROCEDURE lister_dpg( d_nomRecherche     IN VARCHAR2,
                    d_curseur     IN OUT dpg_listeCurType
                            );

-- FAD PPM 63560 : Reproduction de la procédure lister_dpg pour récupérer les DPG ouverts et fermés
PROCEDURE lister_dpg_ouvert_ferme( d_nomRecherche     IN VARCHAR2,
                    d_curseur     IN OUT dpg_listeCurType
                            );

TYPE mo_ViewType IS RECORD ( CLICODE   CLIENT_MO.CLICODE%TYPE,
                             CLISIGLE  CLIENT_MO.CLISIGLE%TYPE,
                             CLILIB    CLIENT_MO.CLILIB%TYPE
                           );

TYPE mo_listeCurType IS REF CURSOR RETURN mo_ViewType;



PROCEDURE lister_mo( p_nomRechercheMo     IN VARCHAR2,
                        p_curseur             IN OUT mo_listeCurType
                   );



TYPE codeCompta_liste_ViewType IS RECORD (  COMCODE CODE_COMPT.COMCODE%TYPE,
                                            COMLIB  CODE_COMPT.COMLIB%TYPE );


TYPE codeCompta_listeCurType IS REF CURSOR RETURN codeCompta_liste_ViewType;



PROCEDURE lister_codeCompta( d_nomRecherche IN VARCHAR2,
                             d_curseur        IN OUT codeCompta_listeCurType
                            );

TYPE codePresta_liste_ViewType IS RECORD (  CODEPRESTA PRESTATION.PRESTATION%TYPE,
                                            LIBPREST   PRESTATION.LIBPREST%TYPE );


TYPE codePresta_listeCurType IS REF CURSOR RETURN codePresta_liste_ViewType;



PROCEDURE lister_codePresta( d_nomRecherche IN VARCHAR2,
                             d_curseur        IN OUT codePresta_listeCurType
                            );



TYPE pid_ViewType IS RECORD ( CLICODE   LIGNE_BIP.PID%TYPE,
                              CLISIGLE  LIGNE_BIP.PNOM%TYPE
                            );

TYPE pid_listeCurType IS REF CURSOR RETURN pid_ViewType;



PROCEDURE lister_pid( p_nomRechercheMo     IN VARCHAR2,
                      p_typeLigne        IN VARCHAR2,
                         p_curseur         IN OUT pid_listeCurType
                   );


-- -------------------------------------------------
--          Recherche Table de répartition
-- -------------------------------------------------
TYPE codrep_ViewType IS RECORD ( CODREP   RJH_TABREPART.CODREP%TYPE,
                                   LIBREP   RJH_TABREPART.LIBREP%TYPE
                               );

TYPE codrep_listeCurType IS REF CURSOR RETURN codrep_ViewType;



PROCEDURE lister_codeTableRep( p_nomRechercheMo IN VARCHAR2,
                                 p_userid            IN VARCHAR2,
                                    p_curseur         IN OUT codrep_listeCurType
                             );


-- -------------------------------------------------
--          Recherche Application
-- -------------------------------------------------
TYPE airt_ViewType IS RECORD ( AIRT   APPLICATION.AIRT%TYPE,
                                 ALIBEL APPLICATION.ALIBEL%TYPE
                             );

TYPE airt_listeCurType IS REF CURSOR RETURN airt_ViewType;



PROCEDURE lister_appli( p_nomRecherche IN VARCHAR2,
                          p_curseur        IN OUT airt_listeCurType
                      );

-- -------------------------------------------------
--          Recherche dossier projet
-- -------------------------------------------------
TYPE dosproj_liste_ViewType IS RECORD ( CODTYPE NUMBER(4),
                       LIB_TYPE VARCHAR2(64) );

TYPE dosproj_listeCurType IS REF CURSOR RETURN dosproj_liste_ViewType;


PROCEDURE lister_cdTypeDosProj( p_nomRecherche     IN VARCHAR2,
                    p_curseur     IN OUT dosproj_listeCurType
                            ) ;

-- -------------------------------------------------
--          Recherche Contrat
-- -------------------------------------------------

TYPE RefCurTyp IS REF CURSOR;



PROCEDURE lister_contrat( p_typeContrat     IN VARCHAR2,
                                                             p_soccont     IN VARCHAR2,
                                                         p_nomRecherche IN VARCHAR2,
                                                         p_nomRessource IN VARCHAR2,
                                                           p_contratEncours   IN VARCHAR2,
                                                         p_userid  IN VARCHAR2,
                                                            p_curseur         IN OUT RefCurTyp
                                                        );


PROCEDURE lister_facture( p_typefacture    IN VARCHAR2,
                                                             p_socfact     IN VARCHAR2,
                                                         p_nomRessource IN VARCHAR2,
                                                         p_contrat IN VARCHAR2,
                                                           p_FactureEncours   IN VARCHAR2,
                                                         p_userid  IN VARCHAR2,
                                                            p_curseur         IN OUT RefCurTyp
                                                        );



-- ------------------------------------------------------------------------------------------------------------
--                                      Recherche Matricules
-- ------------------------------------------------------------------------------------------------------------
TYPE matricule_liste_ViewType IS RECORD ( MATRICULE VARCHAR2(7),
                    RNOM VARCHAR2(30),
                    RPRENOM VARCHAR2(15)
                    );

TYPE matricule_listeCurType IS REF CURSOR RETURN matricule_liste_ViewType;


PROCEDURE lister_matricules( p_nomRecherche     IN VARCHAR2,
                                p_curseur     IN OUT matricule_listeCurType
                                                              );


PROCEDURE get_nomprenom_par_matricule(p_matriculeRecherche     IN VARCHAR2,
                                          nomPrenom OUT  VARCHAR2,
                                      p_message   OUT VARCHAR2
                                      );

TYPE direction_ViewType IS RECORD ( CODDIR  VARCHAR2(5),
                                         LIBDIR    VARCHAR2(30)
                                 );

TYPE direction_listeCurType IS REF CURSOR RETURN direction_ViewType;



PROCEDURE lister_direction( p_curseur     IN OUT direction_listeCurType
                                                             );

TYPE branche_ViewType IS RECORD ( CODBR  VARCHAR2(5),
                                         LIBBR    VARCHAR2(30),
                                         COMBR    VARCHAR2(200)
                                 );

TYPE branche_listeCurType IS REF CURSOR RETURN branche_ViewType;



PROCEDURE lister_branche( p_curseur     IN OUT branche_listeCurType
                                                             );

TYPE cod_proj_spe_Type IS RECORD (codpspe        char(1),
                           libpspe         VARCHAR2(10)
                );

      TYPE cod_proj_spe_CurType IS REF CURSOR RETURN cod_proj_spe_Type;

PROCEDURE lister_cod_proj_spe (p_userid     IN VARCHAR2,
                          p_curcodpspe IN OUT cod_proj_spe_CurType
                                  );

/* ----------------- Liste Dossier Projets COPI ---------------------- */

TYPE dpcopi_liste_ViewType IS RECORD ( DP_COPI VARCHAR2(6),
                       LIBELLE VARCHAR2(60) );


TYPE dpcopi_listeCurType IS REF CURSOR RETURN dpcopi_liste_ViewType;

PROCEDURE lister_dpcopi( d_nomRecherche     IN VARCHAR2,
                           d_type IN VARCHAR2,
                    d_curseur     IN OUT dpcopi_listeCurType
                            ) ;

PROCEDURE lister_dpcopi_par_dpcode( p_userid  IN VARCHAR2, p_dpcode     IN VARCHAR2,
                    d_curseur     IN OUT dpcopi_listeCurType
                            );


PROCEDURE lister_clientCopi( p_nomRechercheMo     IN VARCHAR2,
                        p_curseur             IN OUT mo_listeCurType
                   );
TYPE cdp_nom_ViewType IS RECORD ( IDENT RESSOURCE.IDENT%TYPE,
                                  RNOM RESSOURCE.RNOM%TYPE);
TYPE nom_listeCurType IS REF CURSOR RETURN cdp_nom_ViewType;
PROCEDURE lister_nomAjax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT nom_listeCurType
                            );

TYPE cdp_contrat_ViewType IS RECORD ( num_cont CONTRAT.NUMCONT%TYPE);
TYPE contrat_listeCurType IS REF CURSOR RETURN cdp_contrat_ViewType;
PROCEDURE lister_contratAjax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT contrat_listeCurType
                            );

TYPE cdp_siren_ViewType IS RECORD ( fournisseur VARCHAR2(100),
                                    siren AGENCE.SIREN%TYPE);
TYPE siren_listeCurType IS REF CURSOR RETURN cdp_siren_ViewType;
PROCEDURE lister_sirenAjax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT siren_listeCurType
                            );

TYPE cdp_fournisseur_ViewType IS RECORD ( fournisseur AGENCE.SOCFLIB%TYPE,
                                           siren AGENCE.SIREN%TYPE );
TYPE fournisseur_listeCurType IS REF CURSOR RETURN cdp_fournisseur_ViewType;
PROCEDURE lister_fournisseurAjax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT fournisseur_listeCurType
                            );

TYPE dpcopi_prov__ViewType IS RECORD ( dp_copi_prov dossier_projet_copi.dp_copi%TYPE,
                                           libelle dossier_projet_copi.libelle%TYPE );

TYPE dpcopi_prov_listeCurType IS REF CURSOR RETURN dpcopi_prov__ViewType;
PROCEDURE lister_dp_copi_prov_Ajax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT dpcopi_prov_listeCurType
                            );

TYPE lib_projet__ViewType IS RECORD ( icpi audit_immo.icpi%TYPE,
                                           ilibel audit_immo.ilibel%TYPE );

TYPE lib_projet__listeCurType IS REF CURSOR RETURN lib_projet__ViewType;
PROCEDURE lister_lib_projet_audit_Ajax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT lib_projet__listeCurType
                            );


TYPE lib_appli_ViewType IS RECORD ( airt application.airt%TYPE,
                                           libelle VARCHAR2(70) );

TYPE lib_appli_listeCurType IS REF CURSOR RETURN lib_appli_ViewType;
PROCEDURE lister_lib_appli_Ajax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT lib_appli_listeCurType
                            );
TYPE CentreActivite_ListeViewType IS RECORD( clef				VARCHAR2(10),
 				     		  	 		     libelle 			VARCHAR2(60)
                                            );

TYPE centreActivite_listeCurType IS REF CURSOR RETURN CentreActivite_ListeViewType;


--BIP 307 user story
PROCEDURE lister_codcamo(p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT centreActivite_listeCurType);

TYPE cod_dos_proj_user_Type IS RECORD (dpcode      VARCHAR2(5),
                           libelle         VARCHAR2(50)
                );

      TYPE cod_dos_proj_user_CurType IS REF CURSOR RETURN cod_dos_proj_user_Type;

PROCEDURE lister_dos_proj_user (p_userid     IN VARCHAR2,
                          p_curseur   IN OUT RefCurTyp
                                  );


FUNCTION recup_soccode(p_ident IN VARCHAR2) RETURN VARCHAR2;

PROCEDURE lister_cdp_saisie( 
                      p_userid     IN VARCHAR2,
                      p_codeRecherche     IN VARCHAR2,
                      p_nomRecherche     IN VARCHAR2,
                      p_curseur     IN OUT RefCurTyp
                    );


END Pack_Recup_Id;
/


CREATE OR REPLACE PACKAGE BODY "PACK_RECUP_ID" AS


--*************************************************************************************************
-- Procédure lister_cdp
--
-- Sélectionne la liste des chefs de projets
--
-- ************************************************************************************************
PROCEDURE lister_cdp( p_nomRecherche     IN VARCHAR2,
                    p_curseur     IN OUT cdp_listeCurType
                            ) IS

l_var      RESSOURCE.ident%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
  BEGIN


temp := UPPER(p_nomRecherche) || '%';


    SELECT IDENT INTO l_var
                FROM RESSOURCE
                WHERE UPPER(RNOM) LIKE temp
             AND ROWNUM < 2;

    -- PPR : on n'a pas besoin de la société dans cette recherche - renseigne à blanc

    OPEN p_curseur  FOR
                SELECT IDENT,RNOM, RPRENOM , ''
                FROM RESSOURCE
                WHERE UPPER(RNOM) LIKE temp
             ORDER BY RNOM ;


       EXCEPTION

      WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_cdp;




--*************************************************************************************************
-- Procédure lister_cdp
--
-- Sélectionne la liste des chefs de projets
--
-- ************************************************************************************************
PROCEDURE lister_societe( p_nomRechercheSociete     IN VARCHAR2,
                    s_curseur     IN OUT societe_listeCurType
                            ) IS

l_var      SOCIETE.SOCCODE%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
       BEGIN


temp := UPPER(p_nomRechercheSociete) || '%';
temp1 := '% ' || UPPER(p_nomRechercheSociete) || '%';

     SELECT s.SOCCODE INTO  l_var
                FROM SOCIETE s, AGENCE a
             WHERE
             (    UPPER(a.SOCFLIB) LIKE temp
                 OR UPPER(a.SOCFLIB) LIKE temp1
                 OR UPPER(s.SOCCODE) LIKE temp
                 OR UPPER(s.SOCCODE) LIKE temp1
                 OR UPPER(s.SOCGRPE) LIKE temp
                 OR UPPER(s.SOCGRPE) LIKE temp1)
                AND s.SOCCODE=a.SOCCODE
                AND ROWNUM < 2;


    OPEN s_curseur  FOR
                SELECT s.SOCCODE, a.SOCFLIB, a.SIREN, s.SOCAD1, s.SOCAD2, DECODE(SOCFER,TO_DATE('','yyyy'),'OUVERTE','FERMEE'), s.SOCGRPE
                FROM SOCIETE s, AGENCE a
             WHERE
             (    UPPER(a.SOCFLIB) LIKE temp
                 OR UPPER(a.SOCFLIB) LIKE temp1
                 OR UPPER(s.SOCCODE) LIKE temp
                 OR UPPER(s.SOCCODE) LIKE temp1
                 OR UPPER(s.SOCGRPE) LIKE temp
                 OR UPPER(s.SOCGRPE) LIKE temp1)
              AND s.SOCCODE=a.SOCCODE
              ORDER BY SOCLIB ;


       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

END lister_societe;


PROCEDURE lister_societeAjax( p_nomRechercheSociete     IN VARCHAR2,
                    s_curseur     IN OUT societe_listeCurType
                            ) IS


l_msg           VARCHAR2(1024);

BEGIN
       BEGIN


temp := UPPER(p_nomRechercheSociete) || '%';
temp1 := '% ' || UPPER(p_nomRechercheSociete) || '%';




    OPEN s_curseur  FOR
                SELECT s.SOCCODE, a.SOCFLIB, a.SIREN, s.SOCAD1, s.SOCAD2, DECODE(SOCFER,TO_DATE('','yyyy'),'OUVERTE','FERMEE'), s.SOCGRPE
                FROM SOCIETE s, AGENCE a
             WHERE
             (    UPPER(a.SOCFLIB) LIKE temp
                 OR UPPER(a.SOCFLIB) LIKE temp1
                 OR UPPER(s.SOCCODE) LIKE temp
                 OR UPPER(s.SOCCODE) LIKE temp1
                 OR UPPER(s.SOCGRPE) LIKE temp
                 OR UPPER(s.SOCGRPE) LIKE temp1)
              AND s.SOCCODE=a.SOCCODE(+)
              ORDER BY SOCLIB ;


       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_societeAjax;

PROCEDURE lister_societe_ouvert( p_nomRechercheSociete     IN VARCHAR2,
                    p_userid        IN  VARCHAR2,
                    s_curseur     IN OUT societe_listeCurType
                            ) IS

l_var      SOCIETE.SOCCODE%TYPE;
l_msg           VARCHAR2(1024);
l_menu   VARCHAR2(255);

BEGIN

l_menu := Pack_Global.lire_globaldata(p_userid).menutil;
temp := UPPER(p_nomRechercheSociete) || '%';
temp1 := '% ' || UPPER(p_nomRechercheSociete) || '%';

IF l_menu != 'DIR' THEN
BEGIN

     SELECT s.SOCCODE INTO  l_var
                FROM SOCIETE s, AGENCE a
             WHERE
             (    UPPER(a.SOCFLIB) LIKE temp
                 OR UPPER(a.SOCFLIB) LIKE temp1
                 OR UPPER(s.SOCCODE) LIKE temp
                 OR UPPER(s.SOCCODE) LIKE temp1
                 OR UPPER(s.SOCGRPE) LIKE temp
                 OR UPPER(s.SOCGRPE) LIKE temp1)
                AND s.SOCCODE=a.SOCCODE
                AND s.SOCFER is null
                AND ROWNUM < 2;


    OPEN s_curseur  FOR
                SELECT s.SOCCODE, a.SOCFLIB, a.SIREN, s.SOCAD1, s.SOCAD2, DECODE(SOCFER,TO_DATE('','yyyy'),'OUVERTE','FERMEE'), s.SOCGRPE
                FROM SOCIETE s, AGENCE a
             WHERE
             (    UPPER(a.SOCFLIB) LIKE temp
                 OR UPPER(a.SOCFLIB) LIKE temp1
                 OR UPPER(s.SOCCODE) LIKE temp
                 OR UPPER(s.SOCCODE) LIKE temp1
                 OR UPPER(s.SOCGRPE) LIKE temp
                 OR UPPER(s.SOCGRPE) LIKE temp1)
              AND s.SOCCODE=a.SOCCODE
              AND s.SOCFER is null
              ORDER BY SOCLIB ;


       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

ELSE
BEGIN
    SELECT s.SOCCODE INTO  l_var
                FROM SOCIETE s, AGENCE a
             WHERE
             (    UPPER(a.SOCFLIB) LIKE temp
                 OR UPPER(a.SOCFLIB) LIKE temp1
                 OR UPPER(s.SOCCODE) LIKE temp
                 OR UPPER(s.SOCCODE) LIKE temp1
                 OR UPPER(s.SOCGRPE) LIKE temp
                 OR UPPER(s.SOCGRPE) LIKE temp1)
                AND s.SOCCODE=a.SOCCODE
                AND ROWNUM < 2;


    OPEN s_curseur  FOR
                SELECT s.SOCCODE, a.SOCFLIB, a.SIREN, s.SOCAD1, s.SOCAD2, DECODE(SOCFER,TO_DATE('','yyyy'),'OUVERTE','FERMEE'), s.SOCGRPE
                FROM SOCIETE s, AGENCE a
             WHERE
             (    UPPER(a.SOCFLIB) LIKE temp
                 OR UPPER(a.SOCFLIB) LIKE temp1
                 OR UPPER(s.SOCCODE) LIKE temp
                 OR UPPER(s.SOCCODE) LIKE temp1
                 OR UPPER(s.SOCGRPE) LIKE temp
                 OR UPPER(s.SOCGRPE) LIKE temp1)
              AND s.SOCCODE=a.SOCCODE
              ORDER BY SOCLIB ;


       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

END IF;

END lister_societe_ouvert;

--*************************************************************************************************
-- Procédure lister_cdp_type
--
-- Sélectionne la liste des ressources selon leurs type
--
-- ************************************************************************************************
PROCEDURE lister_cdp_type( p_nomRecherche     IN VARCHAR2,
                                                               p_rtype     IN VARCHAR2,
                                                                  p_curseur     IN OUT cdp_listeCurType
                                                            ) IS
nbr  RESSOURCE.ident%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
  BEGIN


temp := UPPER(p_nomRecherche) || '%';

    IF(p_rtype='A')THEN

        SELECT r.ident INTO nbr
                 FROM RESSOURCE r
                  WHERE UPPER(r.RNOM) LIKE temp
              AND EXISTS (SELECT 1 FROM SITU_RESS_FULL s WHERE s.ident=r.ident AND s.soccode='SG..' AND (DATDEP IS NULL OR datdep>=TO_DATE(TO_CHAR(SYSDATE,'dd/mm/yyyy'),'dd/mm/yyyy')) GROUP BY s.ident )
               AND R.RTYPE='P'
               AND ROWNUM < 2;

             OPEN p_curseur  FOR
                       SELECT r.IDENT,r.RNOM, r.RPRENOM , 'SG..'
                        FROM RESSOURCE r
                          WHERE UPPER(r.RNOM) LIKE temp
                       AND EXISTS (SELECT 1 FROM SITU_RESS_FULL s WHERE s.ident=r.ident AND s.soccode='SG..' AND (DATDEP IS NULL OR datdep>=TO_DATE(TO_CHAR(SYSDATE,'dd/mm/yyyy'),'dd/mm/yyyy')) GROUP BY s.ident )
                       AND R.RTYPE='P'
                       ORDER BY r.RNOM ;


        ELSIF(p_rtype='F') OR (p_rtype='E')THEN


           SELECT ident INTO nbr
              FROM RESSOURCE
                  WHERE UPPER(RNOM) LIKE temp
               AND (RTYPE='F' OR RTYPE='E' )
               AND ROWNUM < 2;


              OPEN p_curseur  FOR
                       SELECT IDENT,RNOM, RPRENOM, ''
                          FROM RESSOURCE
                          WHERE UPPER(RNOM) LIKE temp
                       AND (RTYPE='F' OR RTYPE='E' )
                       ORDER BY RNOM ;



     ELSIF(p_rtype='P') THEN



               SELECT r.ident INTO nbr
                FROM RESSOURCE r
                WHERE UPPER(r.RNOM) LIKE temp
                AND NOT EXISTS (SELECT 1 FROM SITU_RESS_FULL s WHERE s.ident=r.ident AND s.soccode='SG..' AND (DATDEP IS NULL OR datdep>=TO_DATE(TO_CHAR(SYSDATE,'dd/mm/yyyy'),'dd/mm/yyyy')) GROUP BY s.ident )
                AND R.RTYPE='P'
                 AND ROWNUM < 2;


              OPEN p_curseur  FOR
                      SELECT r.IDENT,r.RNOM, r.RPRENOM , sr.SOCCODE
                         FROM RESSOURCE r, SITU_RESS_FULL sr
                          WHERE UPPER(r.RNOM) LIKE temp
                       AND r.RTYPE='P'
                       AND sr.soccode<>'SG..'
                       AND sr.IDENT = r.IDENT
                       AND (sr.DATSITU IS NULL OR sr.DATSITU <= SYSDATE )
                       AND (sr.DATDEP IS NULL OR sr.DATDEP >= TO_DATE(TO_CHAR(SYSDATE,'dd/mm/yyyy'),'dd/mm/yyyy') )
                    ORDER BY RNOM ;


      ELSIF p_rtype='L' THEN


           SELECT ident INTO nbr
              FROM RESSOURCE
                  WHERE UPPER(RNOM) LIKE temp
               AND RTYPE='L'
               AND ROWNUM < 2;


              OPEN p_curseur  FOR
                        SELECT IDENT,RNOM, RPRENOM , ''
                     FROM RESSOURCE
                        WHERE UPPER(RNOM) LIKE temp
                    AND RTYPE='L'
                   ORDER BY RNOM ;

        --agents SG et prestations
    ELSIF(p_rtype='R') THEN

               SELECT r.ident INTO nbr
                FROM RESSOURCE r
                WHERE UPPER(r.RNOM) LIKE temp
                AND  EXISTS (SELECT 1 FROM SITU_RESS_FULL s WHERE s.ident=r.ident  AND (DATDEP IS NULL OR datdep>=TO_DATE(TO_CHAR(SYSDATE,'dd/mm/yyyy'),'dd/mm/yyyy')) GROUP BY s.ident )
                 AND R.RTYPE='P'
                 AND ROWNUM < 2;


              OPEN p_curseur  FOR
                      SELECT r.IDENT,r.RNOM, r.RPRENOM , sr.SOCCODE
                         FROM RESSOURCE r, SITU_RESS_FULL sr
                          WHERE UPPER(r.RNOM) LIKE temp
                       AND sr.IDENT = r.IDENT
                       AND (sr.DATSITU IS NULL OR sr.DATSITU <= SYSDATE )
                       AND (sr.DATDEP IS NULL OR sr.DATDEP >= TO_DATE(TO_CHAR(SYSDATE,'dd/mm/yyyy'),'dd/mm/yyyy'))
                       AND r.RTYPE='P'
                    ORDER BY RNOM ;

    END IF;



       EXCEPTION

    WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_cdp_type;




--*************************************************************************************************
-- Procédure lister_cdp_compatible
--
-- Sélectionne la liste des ressources selon leurs type et la compatibilité entre
-- lignes contrats et situations
-- ************************************************************************************************
PROCEDURE lister_cdp_compatible( p_nomRecherche     IN VARCHAR2,
                                 p_rtype      IN VARCHAR2,
                                 p_soccont    IN VARCHAR2,
                                 p_lresdeb    IN VARCHAR2,
                                 p_lresfin    IN VARCHAR2,
                                 p_numcont IN VARCHAR2,
                                 p_cav IN VARCHAR2,
                                 p_curseur    IN OUT cdp_listeCurType
                                ) IS
  nbr  RESSOURCE.ident%TYPE;
  l_msg           VARCHAR2(1024);

  BEGIN
    BEGIN

    temp := UPPER(p_nomRecherche) || '%';

    IF(p_rtype='F') THEN

              SELECT ident INTO nbr
              FROM RESSOURCE
              WHERE UPPER(RNOM) LIKE temp
              AND (RTYPE='F' OR RTYPE='E' OR RTYPE='L')
              AND pack_situation_p.verif_situ_ligcont(TO_CHAR(ident),p_soccont,TO_DATE(p_lresdeb,'DD/MM/YYYY'),TO_DATE(p_lresfin,'DD/MM/YYYY'))=1
              AND ROWNUM < 2;

              OPEN p_curseur  FOR
                       SELECT distinct IDENT, RNOM, RPRENOM, ''
                       FROM RESSOURCE
                       WHERE UPPER(RNOM) LIKE temp
                       AND (RTYPE='F' OR RTYPE='E' OR RTYPE='L')
                       --AND pack_mode_contractuel.select_mode_contr_comp(TO_CHAR(ident),p_soccont ,p_lresdeb ,p_lresfin ,p_numcont, p_cav) = 1
                       AND pack_situation_p.verif_situ_ligcont(TO_CHAR(IDENT),p_soccont,TO_DATE(p_lresdeb,'DD/MM/YYYY'),TO_DATE(p_lresfin,'DD/MM/YYYY'))=1
                       ORDER BY RNOM ;



     ELSIF(p_rtype='R' OR p_rtype='M') THEN

               SELECT r.ident INTO nbr
                FROM RESSOURCE r
                WHERE UPPER(r.RNOM) LIKE temp
                AND NOT EXISTS (SELECT 1 FROM SITU_RESS_FULL s WHERE s.ident=r.ident AND s.soccode='SG..' AND (DATDEP IS NULL OR datdep>=TO_DATE(TO_CHAR(SYSDATE,'dd/mm/yyyy'),'dd/mm/yyyy')) GROUP BY s.ident )
                AND R.RTYPE='P'
                AND pack_situation_p.verif_situ_ligcont(TO_CHAR(r.IDENT),p_soccont,TO_DATE(p_lresdeb,'DD/MM/YYYY'),TO_DATE(p_lresfin,'DD/MM/YYYY'))=1
                AND ROWNUM < 2;


              OPEN p_curseur  FOR
                      SELECT distinct r.IDENT,r.RNOM, r.RPRENOM , sr.SOCCODE
                         FROM RESSOURCE r,situ_ress sr
                          WHERE UPPER(r.RNOM) LIKE temp
                       AND r.RTYPE='P'
                       AND recup_soccode(r.IDENT) <>'SG..'
                       AND sr.IDENT = r.IDENT
                       --AND pack_mode_contractuel.select_mode_contr_comp(TO_CHAR(r.IDENT),p_soccont ,p_lresdeb ,p_lresfin ,p_numcont, p_cav) = 1
                       AND pack_situation_p.verif_situ_ligcont(TO_CHAR(r.IDENT),p_soccont,TO_DATE(p_lresdeb,'DD/MM/YYYY'),TO_DATE(p_lresfin,'DD/MM/YYYY'))=1
                    ORDER BY RNOM ;

    END IF;



    EXCEPTION

    WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_cdp_compatible;


FUNCTION recup_soccode(p_ident IN VARCHAR2) RETURN VARCHAR2 IS

      l_soccode VARCHAR2(10);

      BEGIN

          select trim(soccode) into l_soccode
          from situ_ress
            where ident = p_ident
            and rownum = 1
            order by datsitu desc;

        return l_soccode;

END  recup_soccode;

--*************************************************************************************************
-- Procédure lister_ca
--
-- Recherche les CA d'aprés le début d'un nom saisi
--
-- ************************************************************************************************
PROCEDURE lister_ca( p_nomRechercheCa     IN VARCHAR2,
                                                          p_cafidpg     IN VARCHAR2,
                                                     p_curseur     IN OUT ca_listeCurType
                                                 ) IS

l_var      CENTRE_ACTIVITE.CODCAMO%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
       BEGIN

    temp := UPPER(p_nomRechercheCa) || '%';


    IF(p_cafidpg  = 'OUI' )THEN

                   SELECT a.CODCAMO INTO  l_var
                               FROM CENTRE_ACTIVITE a
                           WHERE UPPER(a.CLIBRCA) LIKE temp
                              AND EXISTS (SELECT 1 FROM  STRUCT_INFO WHERE  CAFI=a.CODCAMO )
                           AND ROWNUM < 2;

                 OPEN  p_curseur   FOR
                          SELECT a.CODCAMO, a.CLIBRCA, a.CLIBCA
                              FROM CENTRE_ACTIVITE a
                           WHERE UPPER(a.CLIBRCA) LIKE temp
                          AND EXISTS (SELECT 1 FROM  STRUCT_INFO WHERE  CAFI=a.CODCAMO )
                          ORDER BY CLIBCA ;




    ELSE

       SELECT CODCAMO INTO l_var
                FROM CENTRE_ACTIVITE
             WHERE UPPER(CLIBRCA) LIKE temp
             AND ROWNUM < 2;

    OPEN  p_curseur   FOR
                SELECT CODCAMO, CLIBRCA, CLIBCA
                FROM CENTRE_ACTIVITE
             WHERE UPPER(CLIBRCA) LIKE temp
             ORDER BY CLIBCA ;

     END IF;

       EXCEPTION

         WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_ca;


--*************************************************************************************************
-- Procédure lister_rubrique
--
-- Recherche les RUBRIQUES d'aprés le début d'un nom saisi
--
-- ************************************************************************************************
PROCEDURE lister_rubrique( p_nomRechercheRubrique     IN VARCHAR2,
                                                                  p_curseur     IN OUT rubrique_listeCurType
                                                             ) IS

l_var      CENTRE_ACTIVITE.CODCAMO%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
       BEGIN

    temp := UPPER( p_nomRechercheRubrique) || '%';



    SELECT r.codrub  INTO l_var
             FROM RUBRIQUE r, CENTRE_ACTIVITE ca, TYPE_RUBRIQUE tr
             WHERE ca.codcamo=r.CAFI
             AND r.CODEP=tr.CODEP(+)
             AND r.CODFEI=tr.CODFEI
             AND UPPER(ca.clibrca) LIKE temp
             AND ROWNUM < 2;

    OPEN  p_curseur   FOR
            SELECT r.codrub, r.codep || ' - ' || r.codfei || ' - ' || tr.librubst libelle, r.CAFI, ca.clibrca
             FROM RUBRIQUE r, CENTRE_ACTIVITE ca, TYPE_RUBRIQUE tr
             WHERE ca.codcamo=r.CAFI
             AND r.CODEP=tr.CODEP(+)
             AND r.CODFEI=tr.CODFEI
             AND UPPER(ca.clibrca) LIKE temp
            ORDER BY ca.CLIBCA ,  r.codfei;



       EXCEPTION

         WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_rubrique;



--*************************************************************************************************
-- Procédure lister_dpg
--
-- Sélectionne la liste des codes DPG
--
-- ************************************************************************************************
PROCEDURE lister_dpg( d_nomRecherche     IN VARCHAR2,
                    d_curseur     IN OUT dpg_listeCurType
                            ) IS

l_var      STRUCT_INFO.CODSG%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
  BEGIN


temp := UPPER(d_nomRecherche) || '%';


     SELECT CODSG INTO l_var
                FROM STRUCT_INFO
                WHERE UPPER(LIBDSG) LIKE temp
             AND ROWNUM < 2
             AND TOPFER!='F';

    OPEN d_curseur  FOR
                SELECT CODSG,LIBDSG
                FROM STRUCT_INFO
                WHERE UPPER(LIBDSG) LIKE temp
                    AND TOPFER!='F'
             ORDER BY LIBDSG ;


       EXCEPTION
         WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_dpg;

--*************************************************************************************************
-- FAD PPM 63560 : Reproduction de la procédure lister_dpg pour récupérer les DPG ouverts et fermés
--
-- ************************************************************************************************
PROCEDURE lister_dpg_ouvert_ferme( d_nomRecherche     IN VARCHAR2,
                    d_curseur     IN OUT dpg_listeCurType
                            ) IS

l_var      STRUCT_INFO.CODSG%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
  BEGIN


temp := UPPER(d_nomRecherche) || '%';


     SELECT CODSG INTO l_var
                FROM STRUCT_INFO
                WHERE UPPER(LIBDSG) LIKE temp
             AND ROWNUM < 2;

    OPEN d_curseur  FOR
                SELECT CODSG,LIBDSG
                FROM STRUCT_INFO
                WHERE UPPER(LIBDSG) LIKE temp
             ORDER BY LIBDSG ;


       EXCEPTION
         WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_dpg_ouvert_ferme;

--*************************************************************************************************
-- Procédure lister_projet
--
-- Sélectionne la liste des codes Projet
--
-- ************************************************************************************************
PROCEDURE lister_projet( d_nomRecherche     IN VARCHAR2,
                    d_curseur     IN OUT projet_listeCurType
                            ) IS

l_var      PROJ_INFO.ICPI%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
  BEGIN


temp := UPPER(d_nomRecherche) || '%';


    SELECT ICPI INTO l_var
                FROM PROJ_INFO
                WHERE UPPER(ILIBEL) LIKE temp AND
             ROWNUM < 2;

    OPEN d_curseur  FOR
                SELECT ICPI,ILIBEL
                FROM PROJ_INFO
                WHERE UPPER(ILIBEL) LIKE temp
            ORDER BY ILIBEL ;


       EXCEPTION

      WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_projet;


--*************************************************************************************************

--*************************************************************************************************
-- Procédure lister_mo
--
-- Recherche les client d'après le libellé entré
--
-- ************************************************************************************************
PROCEDURE lister_mo( p_nomRechercheMo     IN VARCHAR2,
                        p_curseur           IN OUT mo_listeCurType
                            ) IS

l_var      CLIENT_MO.CLICODE%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
       BEGIN


    temp := UPPER(p_nomRechercheMo) || '%';


     SELECT CLICODE INTO l_var
                FROM CLIENT_MO
             WHERE ( UPPER(CLILIB) LIKE temp
                     OR UPPER(CLISIGLE) LIKE temp)
             AND CLITOPF ='O'
             AND ROWNUM < 2;

    OPEN  p_curseur   FOR
                SELECT CLICODE, CLISIGLE, CLILIB
                FROM CLIENT_MO
             WHERE ( UPPER(CLILIB) LIKE temp
                     OR UPPER(CLISIGLE) LIKE temp)
             AND CLITOPF ='O'
             ORDER BY CLISIGLE ;




       EXCEPTION

         WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_mo;



--*************************************************************************************************
-- Procédure lister_codeCompta
--
-- Sélectionne la liste des codes comptable
--
-- ************************************************************************************************
PROCEDURE lister_codeCompta( d_nomRecherche IN VARCHAR2,
                             d_curseur        IN OUT codeCompta_listeCurType
                            ) IS

l_var      CODE_COMPT.COMCODE%TYPE;
l_msg           VARCHAR2(1024);

BEGIN

    temp := UPPER(d_nomRecherche) || '%';

    SELECT COMCODE INTO l_var
          FROM CODE_COMPT
         WHERE UPPER(COMLIB) LIKE temp AND ROWNUM < 2;


    OPEN d_curseur  FOR
        SELECT COMCODE, COMLIB
          FROM CODE_COMPT
         WHERE UPPER(COMLIB) LIKE temp
        ORDER BY COMCODE ;


EXCEPTION

     WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

    WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END lister_codeCompta;


--*************************************************************************************************
-- Procédure lister_codePresta
--
-- Sélectionne la liste des codes comptable
--
-- ************************************************************************************************
PROCEDURE lister_codePresta( d_nomRecherche IN VARCHAR2,
                             d_curseur        IN OUT codePresta_listeCurType
                            ) IS

l_var          PRESTATION.PRESTATION%TYPE;
l_msg        VARCHAR2(1024);

BEGIN

    temp := UPPER(d_nomRecherche) || '%';


      SELECT PRESTATION INTO l_var
          FROM PRESTATION
         WHERE UPPER(LIBPREST) LIKE temp AND ROWNUM < 2
           AND (RTYPE='F' OR RTYPE='L' OR RTYPE='P' OR RTYPE='E')
           AND TOP_ACTIF = 'O'
           ;


    OPEN d_curseur  FOR
        SELECT PRESTATION, LIBPREST
          FROM PRESTATION
         WHERE UPPER(LIBPREST) LIKE temp
         AND (RTYPE='F' OR RTYPE='L' OR RTYPE='P' OR RTYPE='E')
          AND TOP_ACTIF = 'O'

         ORDER BY LIBPREST ;


EXCEPTION
    WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END lister_codePresta;



--*************************************************************************************************
-- Procédure lister_pid
--
-- Recherche les ligne bip d'après le libellé entré et le type de la ligne bip
--
-- ************************************************************************************************
PROCEDURE lister_pid(  p_nomRechercheMo     IN VARCHAR2,
                      p_typeLigne        IN VARCHAR2,
                         p_curseur         IN OUT pid_listeCurType
                     ) IS

l_var         LIGNE_BIP.pid%TYPE;
l_msg        VARCHAR2(1024);

BEGIN
       BEGIN


    temp := '%' ||UPPER( p_nomRechercheMo) || '%';


    IF(p_typeLigne = 'OUVERTES')THEN

                SELECT PID INTO l_var
             FROM LIGNE_BIP
             WHERE UPPER(PNOM) LIKE temp
             AND TOPFER = 'N'
             AND ADATESTATUT IS NULL
             AND ROWNUM < 2;


        OPEN  p_curseur   FOR
               SELECT PID, PNOM
             FROM LIGNE_BIP
             WHERE UPPER(PNOM) LIKE temp
             AND TOPFER = 'N'
             AND ADATESTATUT IS NULL
            ORDER BY PNOM;

    ELSE

         SELECT PID INTO l_var
             FROM LIGNE_BIP
             WHERE UPPER(PNOM) LIKE temp
             AND ROWNUM < 2;

        OPEN  p_curseur   FOR
             SELECT PID, PNOM
             FROM LIGNE_BIP
             WHERE UPPER(PNOM) LIKE temp
            ORDER BY PNOM;

    END IF;

       EXCEPTION

        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_pid;



--****************************************************************************************************************
-- Procédure lister_codeTableRep
--
-- Recherche les codes Table de répartition d'après le libellé entré et suivant le périmètre de l'utilisateur
--
--****************************************************************************************************************
PROCEDURE lister_codeTableRep( p_nomRechercheMo IN VARCHAR2,
                                 p_userid            IN VARCHAR2,
                                    p_curseur         IN OUT codrep_listeCurType
                             ) IS
    l_perime VARCHAR2(1000);
    l_dir    VARCHAR2(255);
    l_pos     NUMBER;
    temp     VARCHAR2(20);
    l_var      RJH_TABREPART.CODREP%TYPE;
    l_msg           VARCHAR2(1024);

BEGIN
       -- Récupérer le périmètre de l'utilisateur
       l_perime := Pack_Global.lire_globaldata(p_userid).perime ;
    l_dir := '';

    -- On fait une boucle pour récupérer les codes directions qu'on met dans la variable
    -- l_dir qui sera ensuite testée
    WHILE (LENGTH(l_perime)>0)
    LOOP
        IF (LENGTH(l_dir) > 0) THEN
            l_dir := l_dir||','||SUBSTR(l_perime,3,2);
        ELSE
            l_dir := SUBSTR(l_perime,3,2);
        END IF;
        l_perime := SUBSTR(l_perime,13);
    END LOOP;


       BEGIN
        temp := '%' || UPPER(p_nomRechercheMo) || '%';


         SELECT CODREP INTO l_var
              FROM RJH_TABREPART
             WHERE UPPER(LIBREP) LIKE temp
               AND ( (INSTR(l_dir, coddir)>0) OR (INSTR(l_dir,'00')>0) )
             AND ROWNUM < 2;

           OPEN  p_curseur   FOR
              SELECT CODREP, LIBREP
              FROM RJH_TABREPART
             WHERE UPPER(LIBREP) LIKE temp
               AND ( (INSTR(l_dir, coddir)>0) OR (INSTR(l_dir,'00')>0) )
              ORDER BY LIBREP;

       EXCEPTION

        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);
        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_codeTableRep;



-- -------------------------------------------------
--          Recherche Application
-- -------------------------------------------------
PROCEDURE lister_appli( p_nomRecherche IN VARCHAR2,
                          p_curseur        IN OUT airt_listeCurType
                      ) IS
    l_perime VARCHAR2(1000);
    l_dir    VARCHAR2(255);
    l_pos     NUMBER;
    temp     VARCHAR2(20);
    l_var      APPLICATION.AIRT%TYPE;
    l_msg           VARCHAR2(1024);

BEGIN

       BEGIN
        temp := '%' || UPPER(p_nomRecherche) || '%';


         SELECT AIRT INTO l_var
              FROM APPLICATION
             WHERE UPPER(ALIBEL) LIKE temp
             AND ROWNUM < 2;

           OPEN  p_curseur   FOR
              SELECT AIRT, ALIBEL
              FROM APPLICATION
             WHERE UPPER(ALIBEL) LIKE temp
             ORDER BY ALIBEL;

       EXCEPTION
          WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

END lister_appli;



--*************************************************************************************************
-- Procédure lister_contrat
--
--
-- ************************************************************************************************
PROCEDURE lister_facture( p_typefacture    IN VARCHAR2,
                                                             p_socfact     IN VARCHAR2,
                                                         p_nomRessource IN VARCHAR2,
                                                         p_contrat IN VARCHAR2,
                                                           p_FactureEncours   IN VARCHAR2,
                                                         p_userid  IN VARCHAR2,
                                                            p_curseur         IN OUT RefCurTyp
                                                        ) IS

l_var         LIGNE_BIP.pid%TYPE;
l_msg        VARCHAR2(1024);
req  VARCHAR2(4000);
str               VARCHAR2(2000);
str1               VARCHAR2(2000);
tmp_req               VARCHAR2(800);
l_lst_codcfrais VARCHAR2(255);
cur       RefCurTyp;
v_contrat VARCHAR2(15);
l_annee NUMBER;

BEGIN
 BEGIN


    l_lst_codcfrais := Pack_Global.lire_globaldata(p_userid).codcfrais;

     tmp_req := ' ';



IF(p_typeFacture IS NOT NULL )THEN
             tmp_req := tmp_req || '  AND  f.typfact = '''|| p_typeFacture ||''' ';
 END IF;

 IF(LENGTH(l_lst_codcfrais ) <> 0) AND (l_lst_codcfrais IS NOT NULL ) AND (l_lst_codcfrais <> 0 )THEN
             tmp_req := tmp_req || '  AND f.fcentrefrais = ''' || l_lst_codcfrais || ''' ';
  END IF;


 IF(LENGTH(p_socfact ) <> 0) AND (p_socfact IS NOT NULL )  THEN
             tmp_req := tmp_req || '  AND upper(f.socfact) like ''' || UPPER(p_socfact) || ''' ';
 END IF;


  IF(p_factureEncours = 'OUI')  THEN
              SELECT EXTRACT(YEAR FROM SYSDATE) INTO l_annee FROM DUAL;
             tmp_req := tmp_req ||  '  AND EXTRACT(YEAR FROM f.datfact) >= '|| l_annee ||'   ';
 END IF;


 IF(p_nomRessource IS NOT NULL)  AND (LENGTH(p_nomRessource) <> 0)THEN
               tmp_req := tmp_req ||  '  AND upper(r.rnom) like ''' || UPPER(p_nomRessource) || '%'' ';
  END IF;

 IF(p_contrat IS NOT NULL)  AND (LENGTH(p_contrat) <> 0)THEN
               tmp_req := tmp_req ||  '  AND upper(f.NUMCONT) like ''' || UPPER(p_contrat) || '%'' ';
  END IF;

         req   :=  req || '  FROM FACTURE f, LIGNE_FACT lf, RESSOURCE r, CONTRAT c ';
       req   :=  req || '  WHERE lf.numfact =f.numfact ';
       req   :=  req || '  AND lf.socfact=f.socfact ';
       req   :=  req || '  AND lf.datfact=f.datfact ';
       req   :=  req || '  AND lf.ident=r.ident ';
       req   :=  req || '  AND c.numcont=f.numcont ';
       req   :=  req || '  AND c.cav=f.cav ';
       req   :=  req || '  AND c.soccont=f.soccont ';
       req   :=  req || tmp_req ;
      req   :=  req || ' ORDER BY r.rnom, f.datfact desc,  f.numfact' ;



      str := ' SELECT RTRIM(f.numfact), DECODE(f.typfact,''A'',''Avoir'',''F'',''FACTURE''), TO_CHAR(f.datfact,''dd/mm/yyyy''), r.rnom, r.rprenom, RTRIM(f.numcont) || DECODE(c.top30,''O'',DECODE(f.cav,''000'',NULL,'' - ''||RPAD(f.cav,3)),''N'','' - ''||SUBSTR(f.cav,2,2) )'  || req;
      str1 := ' SELECT f.numfact ' || req;

        OPEN cur FOR   str1;

        LOOP

                FETCH cur INTO v_contrat;
                EXIT WHEN (cur%NOTFOUND) OR (cur%ROWCOUNT > 0);

        END LOOP;

        IF(cur%ROWCOUNT = 0)THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20849,  l_msg);
        END IF;



        OPEN p_curseur FOR   str;



       EXCEPTION

        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20849,  l_msg);
        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_facture;





--*************************************************************************************************
-- Procédure lister_contrat
--
--
-- ************************************************************************************************
PROCEDURE lister_contrat( p_typeContrat     IN VARCHAR2,
                                                             p_soccont     IN VARCHAR2,
                                                         p_nomRecherche IN VARCHAR2,
                                                         p_nomRessource IN VARCHAR2,
                                                           p_contratEncours   IN VARCHAR2,
                                                         p_userid  IN VARCHAR2,
                                                            p_curseur         IN OUT RefCurTyp
                                                        )    IS

l_var         LIGNE_BIP.pid%TYPE;
l_msg        VARCHAR2(1024);
req  VARCHAR2(2000);
str               VARCHAR2(2000);
str1               VARCHAR2(2000);
tmp_req               VARCHAR2(800);
l_lst_codcfrais VARCHAR2(255);
cur       RefCurTyp;
v_contrat VARCHAR2(27);

BEGIN
 BEGIN


    l_lst_codcfrais := Pack_Global.lire_globaldata(p_userid).codcfrais;

     tmp_req := ' ';


IF(p_typeContrat = 'avenant')THEN
             tmp_req := tmp_req || '  AND c.cav <> ''000'' ';
 ELSIF (p_typeContrat = 'contrat')THEN
                tmp_req := tmp_req || '  AND c.cav = ''000'' ';
 END IF;

 IF(LENGTH(l_lst_codcfrais ) <> 0) AND (l_lst_codcfrais IS NOT NULL ) AND (l_lst_codcfrais <> 0 )THEN
             tmp_req := tmp_req || '  AND c.ccentrefrais = ''' || l_lst_codcfrais || ''' ';
  END IF;


 IF(LENGTH(p_soccont ) <> 0) AND (p_soccont IS NOT NULL )  THEN
             tmp_req := tmp_req || '  AND upper(c.soccont) like ''' || UPPER(p_soccont) || ''' ';
 END IF;

  IF(p_contratEncours = 'OUI')  THEN
             tmp_req := tmp_req ||  '  AND (c.cdatdeb < SYSDATE AND c.cdatfin > SYSDATE)  ';
 END IF;

 IF(LENGTH(p_nomRecherche) <> 0) AND (p_nomRecherche IS NOT NULL )  THEN
             tmp_req := tmp_req || '  AND upper(c.cobjet1) like ''%' || UPPER(p_nomRecherche) || '%'' ';
 END IF;

 IF(p_nomRessource IS NOT NULL)  AND (LENGTH(p_nomRessource) <> 0)THEN
               tmp_req := tmp_req ||  '  AND upper(r.rnom) like ''' || UPPER(p_nomRessource) || '%'' ';
  END IF;




       req   :=  req || '  FROM CONTRAT c, LIGNE_CONT lc, RESSOURCE r ';
       req   :=  req || '  WHERE lc.numcont =c.numcont ';
       req   :=  req || '  AND lc.soccont=c.soccont ';
       req   :=  req || '  AND lc.cav=c.cav ';
       req   :=  req || '  AND lc.ident=r.ident ';
       req   :=  req || tmp_req ;
       req   :=  req || ' GROUP BY c.numcont,c.top30, c.cav,r.rnom, c.cobjet1, TO_CHAR(c.cdatdeb,''dd/mm/yyyy''), TO_CHAR(c.cdatfin,''dd/mm/yyyy'') ';
       req   :=  req || ' ORDER BY r.rnom, c.numcont, c.cav desc ' ;


        str := ' SELECT  rtrim(c.numcont), decode(c.top30,''N'',substr(c.cav,2,2),''O'',decode(c.cav,''000'',null,c.cav)) cav, r.rnom, c.cobjet1, to_char(c.cdatdeb,''dd/mm/yyyy''), to_char(c.cdatfin,''dd/mm/yyyy'')  ' || req;
        str1 := ' SELECT c.numcont ' || req;

        OPEN cur FOR   str1;

        LOOP

                FETCH cur INTO v_contrat;
                EXIT WHEN (cur%NOTFOUND) OR (cur%ROWCOUNT > 0);

        END LOOP;

        IF(cur%ROWCOUNT = 0)THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20849,  l_msg);
        END IF;



        OPEN p_curseur FOR   str;



       EXCEPTION

        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20849,  l_msg);
        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_contrat;

--*************************************************************************************************
-- Procédure lister_cdTypeInv
--
-- Sélectionne la liste des code d'investissement
--
-- ************************************************************************************************
PROCEDURE lister_cdTypeInv( p_nomRecherche     IN VARCHAR2,
                    p_curseur     IN OUT invest_listeCurType
                            ) IS

l_var      INVESTISSEMENTS.CODTYPE%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
  BEGIN


temp := '%' || UPPER(p_nomRecherche) || '%';

SELECT CODTYPE INTO l_var
                FROM INVESTISSEMENTS
                WHERE UPPER(LIB_TYPE) LIKE temp
             AND ROWNUM < 2;

    OPEN p_curseur  FOR
                SELECT CODTYPE,LIB_TYPE
                FROM INVESTISSEMENTS
                WHERE UPPER(LIB_TYPE) LIKE temp
             AND ROWNUM < 100
             ORDER BY LIB_TYPE ;


       EXCEPTION

      WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_cdTypeInv;

--*************************************************************************************************
-- Procédure lister_cdTypeDosProj
--
-- Sélectionne la liste des code dossier projet
--
-- ************************************************************************************************
PROCEDURE lister_cdTypeDosProj( p_nomRecherche     IN VARCHAR2,
                    p_curseur     IN OUT dosproj_listeCurType
                            ) IS

l_var      DOSSIER_PROJET.DPCODE%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
  BEGIN


temp := '%' || UPPER(p_nomRecherche) || '%';

SELECT DPCODE INTO l_var
                FROM  DOSSIER_PROJET
                WHERE UPPER(DPLIB) LIKE temp
             AND ROWNUM < 2;

    OPEN p_curseur  FOR
                SELECT DPCODE,DPLIB
                FROM  DOSSIER_PROJET
                WHERE UPPER(DPLIB) LIKE temp
             AND ROWNUM < 100
             ORDER BY DPLIB ;


       EXCEPTION

      WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_cdTypeDosProj;




--*************************************************************************************************
-- Procédure lister_matricules
--
-- Sélectionne la liste des matricules,nom,prénom d'aprés un nom ou début de nom
--
-- ************************************************************************************************
PROCEDURE lister_matricules( p_nomRecherche     IN VARCHAR2,
                                 p_curseur     IN OUT matricule_listeCurType
                            ) IS

l_var      RESSOURCE.MATRICULE%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
  BEGIN


  temp := UPPER(p_nomRecherche) || '%';

    SELECT MATRICULE INTO l_var
                FROM RESSOURCE
                WHERE UPPER(RNOM) LIKE temp
             AND ROWNUM < 2;

    -- PPR : on n'a pas besoin de la société dans cette recherche - renseigne à blanc

    OPEN p_curseur  FOR
                SELECT MATRICULE,RNOM, RPRENOM
                FROM RESSOURCE
                WHERE UPPER(RNOM) LIKE temp
             ORDER BY RNOM ;


       EXCEPTION

      WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_matricules;


-- ************************************************************
--       Récupère le Nom - Prénom d'aprés le Matricule
-- ************************************************************
PROCEDURE get_nomprenom_par_matricule( p_matriculeRecherche     IN VARCHAR2,
                                           nomPrenom OUT  VARCHAR2,
                                       p_message OUT VARCHAR2  ) IS

l_msg           VARCHAR2(1024);

BEGIN
  BEGIN

    /*
    YNI FDT 917 Enlevement du tiret qui separe le nom du prenom
    */
    SELECT  rnom || ' ' || rprenom  INTO nomPrenom
             FROM RESSOURCE
             WHERE MATRICULE = p_matriculeRecherche
             AND ROWNUM < 2;

       EXCEPTION

      WHEN NO_DATA_FOUND THEN
             Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             p_message := l_msg;
             --RAISE_APPLICATION_ERROR( -20849,  l_msg);


        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

END get_nomprenom_par_matricule;

-- ************************************************************
--       Récupère le code et le libellé des directions
-- ************************************************************

PROCEDURE lister_direction(    p_curseur     IN OUT direction_listeCurType
                                ) IS


l_msg           VARCHAR2(1024);

BEGIN
       BEGIN

    OPEN  p_curseur   FOR
            SELECT coddir, libdir
             FROM DIRECTIONS
             ORDER BY CODDIR;



       EXCEPTION

         WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);


    END;



END lister_direction;

-- ************************************************************
--       Récupère le code, le libellé et le commentaire des branches
-- ************************************************************

PROCEDURE lister_branche(    p_curseur     IN OUT branche_listeCurType
                                ) IS


l_msg           VARCHAR2(1024);

BEGIN
       BEGIN

    OPEN  p_curseur   FOR
            SELECT codbr, libbr, combr
             FROM BRANCHES
             ORDER BY CODBR;



       EXCEPTION

         WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);


    END;



END lister_branche;

PROCEDURE lister_cod_proj_spe (p_userid     IN VARCHAR2,
                          p_curcodpspe IN OUT cod_proj_spe_CurType
                                  ) IS

     l_msg VARCHAR(1024);

   BEGIN

      BEGIN
         OPEN p_curcodpspe FOR
        SELECT
            codpspe,
            libpspe
        FROM proj_spe
        order by libpspe
        ;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;

   END lister_cod_proj_spe ;


--*************************************************************************************************
-- Procédure lister Dossier Projet COPI
--
-- Sélectionne la liste des codes DPCOPI
--
-- ************************************************************************************************
PROCEDURE lister_dpcopi( d_nomRecherche     IN VARCHAR2,
                    d_type   IN VARCHAR2,
                    d_curseur     IN OUT dpcopi_listeCurType
                            ) IS

l_var      STRUCT_INFO.CODSG%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
  BEGIN


temp := UPPER(d_nomRecherche) || '%';

    --- type = creation recupère tous les dpcopi existant dans la table dossier_projet_copi
    if (d_type = 'creation')
    then
    OPEN d_curseur  FOR
                SELECT DP_COPI, DP_COPI|| ' - ' || LIBELLE
                FROM DOSSIER_PROJET_COPI
                WHERE UPPER(LIBELLE) LIKE temp
             ORDER BY LIBELLE ;
    end if;

    ---- type = modifsupp  recupère tous les dpcopi qui possèdent un budget
      if (d_type = 'modifsupp')
    then
    OPEN d_curseur  FOR
                SELECT  d.DP_COPI, d.DP_COPI|| ' - ' || d.LIBELLE
                FROM DOSSIER_PROJET_COPI d, budget_copi b
                where b.dp_copi  = d.dp_copi
                and UPPER(LIBELLE) LIKE temp
              group by d.dp_copi, d.libelle
             ORDER BY d.LIBELLE ;
    end if;


       EXCEPTION
         WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_dpcopi;



PROCEDURE lister_dpcopi_par_dpcode( p_userid  IN VARCHAR2, p_dpcode     IN VARCHAR2,
                    d_curseur     IN OUT dpcopi_listeCurType
                            ) IS

l_msg           VARCHAR2(1024);

BEGIN
  BEGIN


    OPEN d_curseur  FOR
             SELECT '',
             ' ' libelle
             FROM dual
             UNION
                SELECT DP_COPI, DP_COPI|| ' - ' || LIBELLE
                FROM DOSSIER_PROJET_COPI
                WHERE   dpcode = DECODE(p_dpcode,NULL,NULL,TO_NUMBER(p_dpcode))
             ORDER BY LIBELLE ;


       EXCEPTION
        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

END lister_dpcopi_par_dpcode;


PROCEDURE lister_clientCopi( p_nomRechercheMo     IN VARCHAR2,
                        p_curseur           IN OUT mo_listeCurType
                            ) IS

l_var      CLIENT_MO.CLICODE%TYPE;
l_msg           VARCHAR2(1024);

BEGIN
       BEGIN


    temp := UPPER(p_nomRechercheMo) || '%';

    OPEN  p_curseur   FOR
                SELECT c.CLICODE, c.CLISIGLE, c.CLILIB
                FROM CLIENT_MO c
             WHERE
             ( UPPER(CLILIB) LIKE temp
                     OR UPPER(CLISIGLE) LIKE temp)
             AND CLITOPF ='O'
             ORDER BY CLISIGLE ;




       EXCEPTION

         WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_clientCopi;

PROCEDURE lister_nomAjax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT nom_listeCurType
                            ) IS


l_msg           VARCHAR2(1024);

BEGIN
       BEGIN


temp := UPPER(p_nomRecherchenom) || '%';

    OPEN s_curseur  FOR
                SELECT r.ident, r.rnom || decode(r.rprenom,null,'',' - '||r.rprenom) || decode(r.matricule,null,'',' ('||r.matricule||')' )
                FROM RESSOURCE r
             WHERE UPPER(r.rnom) LIKE temp
              ORDER BY r.rnom ;


       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_nomAjax;

PROCEDURE lister_contratAjax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT contrat_listeCurType
                            ) IS


l_msg           VARCHAR2(1024);

BEGIN
       BEGIN


temp := UPPER(p_nomRecherchenom) || '%';

    OPEN s_curseur  FOR
                SELECT TRIM(c.numcont)
                FROM LIGNE_CONT c
             WHERE UPPER(c.numcont) LIKE temp
              AND c.lresfin > sysdate - 730
              GROUP BY c.numcont
              ORDER BY c.numcont;


       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_contratAjax;

PROCEDURE lister_sirenAjax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT siren_listeCurType
                            ) IS


l_msg           VARCHAR2(1024);

BEGIN
       BEGIN


temp := UPPER(p_nomRecherchenom) || '%';

    OPEN s_curseur  FOR
                SELECT DISTINCT a.siren||' - '||a.socflib, a.siren
                FROM AGENCE a
             WHERE UPPER(a.siren) LIKE temp
              ORDER BY a.siren ;


       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_sirenAjax;

PROCEDURE lister_fournisseurAjax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT fournisseur_listeCurType
                            ) IS


l_msg           VARCHAR2(1024);

BEGIN
       BEGIN


temp := UPPER(p_nomRecherchenom) || '%';

    OPEN s_curseur  FOR
                SELECT a.socflib ||' - '||a.siren, a.siren
                FROM AGENCE a
             WHERE UPPER(a.socflib) LIKE temp
             and a.siren is not null
              ORDER BY a.socflib ;


       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_fournisseurAjax;


PROCEDURE lister_dp_copi_prov_Ajax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT dpcopi_prov_listeCurType
                            ) IS


  l_msg           VARCHAR2(1024);

BEGIN

           BEGIN


temp := UPPER(p_nomRecherchenom) || '%';

    OPEN s_curseur  FOR
                SELECT lpad(dp.dp_copi,6,' ') || ' - '|| dp.libelle, dp.dp_copi
                FROM dossier_projet_copi dp
             WHERE UPPER(dp.dp_copi) LIKE temp

              ORDER BY dp.dp_copi ;


       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

END lister_dp_copi_prov_Ajax ;


PROCEDURE lister_lib_projet_audit_Ajax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT lib_projet__listeCurType
                            )IS


  l_msg           VARCHAR2(1024);

BEGIN

           BEGIN


temp := '%' || UPPER(p_nomRecherchenom) || '%';

    OPEN s_curseur  FOR
                SELECT lpad(ai.icpi,5,' ')  || ' - '|| ai.ilibel ilibel,
                lpad(ai.icpi,5,' ') icpi

                FROM audit_immo ai
             WHERE UPPER(ai.ilibel) LIKE UPPER(temp)
group by icpi, ilibel
              ORDER BY ai.ilibel ;


       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

END lister_lib_projet_audit_Ajax ;

PROCEDURE lister_lib_appli_Ajax( p_nomRecherchenom     IN VARCHAR2,
                    s_curseur     IN OUT lib_appli_listeCurType
                            ) IS

                             l_msg           VARCHAR2(1024);

BEGIN

           BEGIN


temp := '%' || UPPER(p_nomRecherchenom) || '%';

    OPEN s_curseur  FOR

              select AIRT|| ' - '|| AMNEMO || ' - '||  ALIBEL libelle,
              airt   code
             from  application

             WHERE (UPPER(alibel) LIKE UPPER(temp) or
             UPPER(amnemo) LIKE UPPER(temp)or
             UPPER(airt) LIKE UPPER(temp))
            order by alibel;


       EXCEPTION
        WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

END lister_lib_appli_Ajax ;

--BIP 307 user story
PROCEDURE lister_codcamo(
    p_nomRecherchenom IN VARCHAR2,
    s_curseur         IN OUT centreActivite_listeCurType)
IS
  l_msg     VARCHAR2(1024);
  l_libelle VARCHAR2(1024);
  l_tmp integer;
BEGIN

    temp := '%' || UPPER(p_nomRecherchenom) || '%';

    /* Valeur des différents états pris par un CA :
    0 - Entité soumise à toute facturation interne
    1 - Entité soumise à toute facturation interne
    2 - Entité exonérée de la FI Gestion du personnel
    3 - Entitée exonérée de toute FI
    4 - Entité exonérée des FI Gest Pers a Pro*/
    begin
    SELECT 1 into l_tmp FROM 
          (SELECT TO_CHAR(ca.CODCAMO, 'FM00000') CODCAMO,
          DECODE(ca.CODCAMO, 0, '00000 - A RENSEIGNER ...', (TO_CHAR(ca.CODCAMO, 'FM00000')
          || ' - '
          || ca.CLIBCA
          || ' -- Etat : '
          || NVL(TO_CHAR(ca.CDFAIN), ' '))) L_LIBELLE
        FROM CENTRE_ACTIVITE ca
        WHERE ca.CDATEFERM IS NULL
        AND (ca.CDFAIN     IS NULL
        OR ca.CDFAIN       !='3'))A WHERE UPPER(A.L_LIBELLE) LIKE TEMP and rownum =1;
        
        OPEN s_curseur FOR
         SELECT * FROM 
          (SELECT TO_CHAR(ca.CODCAMO, 'FM00000') CODCAMO,
          DECODE(ca.CODCAMO, 0, '00000 - A RENSEIGNER ...', (TO_CHAR(ca.CODCAMO, 'FM00000')
          || ' - '
          || ca.CLIBCA
          || ' -- Etat : '
          || NVL(TO_CHAR(ca.CDFAIN), ' '))) L_LIBELLE
        FROM CENTRE_ACTIVITE ca
        WHERE ca.CDATEFERM IS NULL
        AND (ca.CDFAIN     IS NULL
        OR ca.CDFAIN       !='3'))A WHERE UPPER(A.L_LIBELLE) LIKE TEMP
          --AND ( UPPER(CA.CODCAMO) LIKE temp OR UPPER(ca.CLIBCA) LIKE temp or ca.CDFAIN like temp)
        ORDER BY A.CODCAMO;
        
        exception
        when no_data_found then
        Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);
             when others then
                 RAISE_APPLICATION_ERROR( -20997, SQLERRM);

  end;    

END lister_codcamo ;


PROCEDURE lister_dos_proj_user (p_userid     IN VARCHAR2,
                                p_curseur  IN OUT RefCurTyp
                                  ) IS

     l_msg VARCHAR(1024);
     test_mess VARCHAR2(5000);
     test_mess2 VARCHAR2(5000);
     req varchar2(5000);
      req1 varchar2(5000);
       reqnull varchar2(500);

   BEGIN

    test_mess := pack_global.lire_globaldata(p_userid).doss_proj;

   BEGIN


    req := 'select ''0Tous'' code,
                  ''Tous'' libelle
                   from dual
                   union

        SELECT
            to_char(s.dpcode) code ,
            to_char(s.dpcode) || '' - '' || dp.dplib libelle
        FROM stock_immo s, dossier_projet dp
        where
        s.dpcode = dp.dpcode
        and s.dpcode in (' || test_mess ||')     order by code
        ';


     req1 := 'select ''0Tous'' code,
                  ''Tous'' libelle
                   from dual
                   union

        SELECT
            to_char(s.dpcode) code ,
            to_char(s.dpcode) || '' - '' || dp.dplib libelle
        FROM stock_immo s, dossier_projet dp
        where
        s.dpcode = dp.dpcode
          order by code
        ';

      reqnull := 'select ''test'' code,
                         ''test'' libelle
                         from dual';


        if (test_mess = 'TOUS') then
             OPEN p_curseur FOR  req1;
        elsif (test_mess is not null) then

         OPEN p_curseur FOR  req;
            else
            OPEN p_curseur FOR  reqnull;
         end if;



      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;

   END lister_dos_proj_user ;
   
   
   --*************************************************************************************************
-- Procédure lister_cdp_saisie
--
-- Sélectionne la liste des ressources
-- SEL PPM 63897
-- ************************************************************************************************
PROCEDURE lister_cdp_saisie(  
                              p_userid     IN VARCHAR2,
                              p_codeRecherche     IN VARCHAR2,
                              p_nomRecherche     IN VARCHAR2,
                              p_curseur     IN OUT RefCurTyp
                            ) IS

l_var      RESSOURCE.ident%TYPE;
l_msg           VARCHAR2(1024);
l_lst_chefs_projets VARCHAR2(8000);
req      VARCHAR2(10000);

BEGIN
  BEGIN


temp := '%'||UPPER(p_nomRecherche)||'%';
l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;

   
             IF(p_nomRecherche IS NULL OR p_nomRecherche = '') THEN
             
              req := ' SELECT DISTINCT  r.IDENT,r.RNOM, r.RPRENOM , ''''  '
           || ' FROM SITU_RESS_FULL f, RESSOURCE r, DATDEBEX d  '
           || ' WHERE f.ident=r.ident '
           || ' AND r.ident = '|| p_coderecherche
           || ' AND (TRUNC(f.datsitu,''YEAR'') <=TRUNC(d.DATDEBEX,''YEAR'') OR f.datsitu IS NULL) '
           || ' AND (TRUNC(f.datdep,''YEAR'')>=TRUNC(d.DATDEBEX,''YEAR'') OR f.datdep IS NULL) '
           || ' AND ( f.cpident IN ('|| l_lst_chefs_projets ||')  OR f.ident IN ('|| l_lst_chefs_projets ||') ) '
           || ' AND f.type_situ=''N'' '
           || ' ORDER BY RNOM,RPRENOM '; --QC 1917


            OPEN p_curseur FOR   req;    
             
             ELSE
             
             SELECT IDENT INTO l_var
                FROM RESSOURCE
                WHERE UPPER(RNOM) LIKE temp
             AND ROWNUM < 2;
           
         req := ' SELECT DISTINCT  r.IDENT,r.RNOM, r.RPRENOM , ''''  '
             || ' FROM SITU_RESS_FULL f, RESSOURCE r, DATDEBEX d  '
             || ' WHERE f.ident=r.ident '
             || ' AND UPPER(RNOM) LIKE '''||temp || ''''
             || ' AND (TRUNC(f.datsitu,''YEAR'') <=TRUNC(d.DATDEBEX,''YEAR'') OR f.datsitu IS NULL) '
             || ' AND (TRUNC(f.datdep,''YEAR'')>=TRUNC(d.DATDEBEX,''YEAR'') OR f.datdep IS NULL) '
             || ' AND ( f.cpident IN ('|| l_lst_chefs_projets ||')  OR f.ident IN ('|| l_lst_chefs_projets ||') ) '
             || ' AND f.type_situ=''N'' '
             || ' ORDER BY RNOM,RPRENOM ';--QC 1917


          OPEN p_curseur FOR   req;    
             
             END IF;


       EXCEPTION
 
      WHEN NO_DATA_FOUND THEN
      
               Pack_Global.recuperer_message(20849, NULL,NULL,NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20849,  l_msg);

        WHEN OTHERS THEN
       
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;



END lister_cdp_saisie;


END Pack_Recup_Id;
/