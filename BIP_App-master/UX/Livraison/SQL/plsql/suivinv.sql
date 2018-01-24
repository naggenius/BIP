--kha td17: modif en taux HTR 09/04
--          modif sysdate par CMENSUELLE 11/04
--kha td124 matricule devient comrea
--
-- Modifié le 16/03/2006 par DDI : La valeur 'supinv' était testée au lieu de 'ginv'.
--
-- Modifié le 19/06/2007 par BPO : Fiche 550 - Modification de la taille du champ correspondant au libelle Dossier Projet
-- Modifié le 26/06/2008 par EVI : Ajout fonction pour corriger probleme acces concurrent dans menu suivi investissement
-- Modifié le 04/09/2009 par YNI : la restitution de la liste des CA en fonction des habilitation de l'utilisateur
-- Modifié le 22/09/2009 par ABA : Modification liste des ca en fonction de leur niveau de chaque utilisateur
-- Modifié le 12/10/2009 par YSB : Modification liste des ca en fonction de leur niveau de chaque utilisateur

CREATE OR REPLACE PACKAGE     pack_suivi_investissement AS


TYPE RefCurTyp IS REF CURSOR;

  TYPE liste_centre_activite IS RECORD ( codcamo  VARCHAR2(5)
                                        , libelle  VARCHAR2(30),
                                      niveau   CHAR(1)
                                      );
  TYPE liste_ca IS REF CURSOR RETURN liste_centre_activite;


   -- definition d'un enregistrement de la table ligne_bip pour la gestion  des entetes

  TYPE ligne_inv_m_ViewType IS RECORD (
                                     codinv      CHAR(3),
                       annee       VARCHAR2(4),
                       codcamo     VARCHAR2(5),
                       type        VARCHAR2(4),
                       icpi        VARCHAR2(5),
                       dpcode      VARCHAR2(5),
                       libelle     VARCHAR2(25),
                       quantite    ligne_investissement.quantite%TYPE,
                       demande     VARCHAR2(7),
                       notifie     VARCHAR2(7),
                       engage      VARCHAR2(7),
                       re_estime   VARCHAR2(7),
                       realise     VARCHAR2(7),
                       disponible  VARCHAR2(7),
                       cominv      VARCHAR2(200),
                       toprp      CHAR(1),
                       flaglock    ligne_investissement.flaglock%TYPE,
                                     clibca      centre_activite.clibca%TYPE,
                       lib_type    investissements.lib_type%TYPE,
                       plib        proj_info.ilibel%TYPE,
                       dplib       dossier_projet.dplib%TYPE
                    );

  TYPE ligne_rea_m_ViewType IS RECORD (codrea           CHAR(2),
                       codinv           VARCHAR2(3),
                       annee            CHAR(4),
                       codcamo          CHAR(5),
                       num_cmd          VARCHAR2(8),
                       type_cmd         VARCHAR2(16),
                       marque           VARCHAR2(16),
                       modele           VARCHAR2(16),
                       comrea        VARCHAR2(200),
                       date_saisie      CHAR(10),
                       engage           VARCHAR2(8),
                       type_eng         VARCHAR2(16),
                       type_ligne        VARCHAR2(64), --new
                       projet        VARCHAR2(5), --new
                       dossier_projet       VARCHAR2(50), --new
                       disponible      VARCHAR2(7),
                       disponible_htr  VARCHAR2(7),--kha 09/04
                       flaglock         INT,
                     clibca      centre_activite.clibca%type
                                    );

   TYPE ca_niveau0_ViewType IS RECORD (codcamo          CHAR(5));


   -- définition du curseur sur la table ligne_bip pour la gestion de l'entete du projet

   TYPE ligneInvCurType IS REF CURSOR RETURN ligne_inv_m_ViewType;

   TYPE ligneReaCurType IS REF CURSOR RETURN ligne_rea_m_ViewType;

   TYPE CANiveauZeroCurType IS REF CURSOR RETURN ca_niveau0_ViewType;

   /*****************************************************************************/
   TYPE CA_util_ListeViewType IS RECORD     (codcamo    VARCHAR2(6),
                                          lib    VARCHAR2(100)
                                         );
   TYPE CA_util_listeCurType IS REF CURSOR RETURN CA_util_ListeViewType;
   /*****************************************************************************/
   PROCEDURE lister_ca_niv0_utilisateur ( p_userid  IN VARCHAR2,
                           p_curseur IN OUT CA_util_listeCurType
              );

   PROCEDURE lister_global_ca_utilisateur ( p_ca_suivi  IN VARCHAR2,
                           p_curseur IN OUT RefCurTyp
              );

   PROCEDURE select_ligne_inv_c ( p_codcamo          IN CHAR,
                                  p_annee       IN CHAR,
                                  p_codinv OUT VARCHAR2,
                                  p_clibca      OUT VARCHAR2);

   PROCEDURE select_ligne_rea_c ( p_codinv      IN CHAR,
                                  p_codcamo     IN CHAR,
                                  p_annee       IN CHAR,
                                  p_codrea      OUT VARCHAR2,
                                  p_clibca      OUT VARCHAR2,
                                  p_type_ligne    OUT VARCHAR2,
                                  p_projet        OUT VARCHAR2,
                                  p_dossier_projet OUT VARCHAR2,
                                  p_disponible    OUT VARCHAR2,
                                  p_disponible_htr    OUT VARCHAR2,
                                  p_message     OUT VARCHAR2);

   PROCEDURE select_ligne_rea_m ( p_codrea      IN VARCHAR2,
                                  p_codinv      IN CHAR,
                                  p_codcamo     IN CHAR,
                                  p_annee       IN CHAR,
                                  p_curLigneRea IN OUT ligneReaCurType,
                                  p_userid      IN  VARCHAR2,
                                  p_message     OUT VARCHAR2);

   PROCEDURE select_ligne_inv_m (p_mode        IN  VARCHAR2,
                    p_codinv    IN CHAR,
                                p_codcamo          IN CHAR,
                                p_annee       IN CHAR,
                                p_curLigneInv IN OUT ligneInvCurType,
                                p_userid     IN  VARCHAR2,
                                p_message     OUT VARCHAR2
                              );


   PROCEDURE insert_ligne_inv (
                   p_codinv           IN CHAR,
                   p_annee             IN CHAR,
                               p_codcamo                IN CHAR,
                               p_type            IN CHAR,
                   p_pcode             IN CHAR,
                               p_dpcode            IN CHAR,
                               p_libelle           IN VARCHAR2,
                    p_quantite       IN VARCHAR2,
                               p_demande          IN VARCHAR2,
                               p_notifie           IN VARCHAR2,
                               --p_engage            IN VARCHAR2,
                               p_re_estime        IN VARCHAR2,
                               --p_disponible       IN VARCHAR2,
                               p_cominv       IN VARCHAR2,
                               p_toprp       IN CHAR,
                               p_message        OUT VARCHAR2
                              );

   PROCEDURE insert_ligne_rea (
                    p_codrea           IN VARCHAR2,
                  p_codinv           IN VARCHAR2,
                  p_annee            IN VARCHAR2,
                  p_codcamo          IN VARCHAR2,
                                p_type_cmd         IN VARCHAR2,
                  p_num_cmd           IN VARCHAR2,
                  p_marque           IN VARCHAR2,
                  p_modele           IN VARCHAR2,
                  p_comrea        IN VARCHAR2,
                  p_date_saisie      IN VARCHAR2,
                  p_engage           IN VARCHAR2,
                  p_type_eng         IN VARCHAR2,
                  p_flaglock         IN INT,
                                p_message             OUT VARCHAR2
                              );

   PROCEDURE update_ligne_rea ( p_codrea           IN VARCHAR2,
                                p_codinv           IN VARCHAR2,
                                p_annee            IN VARCHAR2,
                                p_codcamo          IN VARCHAR2,
                                            p_type_cmd         IN VARCHAR2,
                                p_num_cmd           IN VARCHAR2,
                                p_marque           IN VARCHAR2,
                                p_modele           IN VARCHAR2,
                                p_comrea        IN VARCHAR2,
                                p_date_saisie      IN VARCHAR2,
                                p_engage           IN VARCHAR2,
                                p_type_eng         IN VARCHAR2,
                                p_flaglock         IN INT,
                                            p_message             OUT VARCHAR2
                              );

    PROCEDURE delete_ligne_rea ( p_codrea           IN VARCHAR2,
                   p_codinv           IN VARCHAR2,
                   p_annee            IN VARCHAR2,
                   p_codcamo          IN VARCHAR2,
                                 p_flaglock  IN NUMBER,
                                 p_message     OUT VARCHAR2);

   PROCEDURE update_ligne_inv ( p_codinv           IN VARCHAR2,
                    p_annee         IN VARCHAR2,
                               p_codcamo        IN VARCHAR2,
                               p_type        IN VARCHAR2,
                   p_pcode         IN VARCHAR2,
                               p_dpcode        IN VARCHAR2,
                               p_libelle           IN VARCHAR2,
                    p_quantite       IN VARCHAR2,
                               p_demande          IN VARCHAR2,
                               p_notifie           IN VARCHAR2,
                               p_re_estime        IN VARCHAR2,
                               p_cominv        IN VARCHAR2,
                               p_toprp        IN CHAR,
                               p_flaglock        IN NUMBER,
                               p_message        OUT VARCHAR2
                              );

    PROCEDURE delete_ligne_inv ( p_codinv      IN CHAR,
                                 p_codcamo          IN CHAR,
                                 p_annee       IN CHAR,
                                 p_flaglock  IN NUMBER,
                                 p_message     OUT VARCHAR2);

    PROCEDURE notifier_centre_activite (
                                 p_codcamo          IN VARCHAR2,
                                 p_niveau      IN VARCHAR2,
                                 p_annee       IN VARCHAR2,
                                 p_flaglock        IN NUMBER,
                                 p_message     OUT VARCHAR2);

    PROCEDURE liste_globale_ca(p_codcamo in varchar2,
                               p_curseur out liste_ca,
                               p_niveau out varchar2,
                               p_mesage out varchar2);

    PROCEDURE liste_niveau0_ca(p_codcamo in number,
                               p_curseur out liste_ca,
                               p_mesage out varchar2);

    FUNCTION sum_realises(p_codinv IN number,
                          p_codcamo IN number,
                          p_annee IN varchar2)
    RETURN NUMBER;

    FUNCTION sum_realises_htr(p_codinv IN number,
                          p_codcamo IN number,
                          p_annee IN varchar2)
    RETURN NUMBER;

    FUNCTION cherche_tva(p_datetva IN varchar2)
    RETURN NUMBER;

    FUNCTION cherche_date_exercice
    RETURN DATE;

    FUNCTION recherche_niveau(p_codcamo IN varchar2)
    RETURN NUMBER;
    


END pack_suivi_investissement;
/


CREATE OR REPLACE PACKAGE BODY     pack_suivi_investissement AS

--
-- Liste les CA de niveau 0 qui ont été déclarés dans le RTFE pour un utilisateur
-- ( On utilise entite_structure pour retrouver le libelle )
-- Utilisé dans les habilitations par référentiels
--
   PROCEDURE lister_ca_niv0_utilisateur ( p_userid  IN VARCHAR2,
                           p_curseur IN OUT CA_util_listeCurType
              ) IS

   l_ca_payeur VARCHAR2(255);

   BEGIN
      l_ca_payeur := p_userid;
      BEGIN
      -- On affiche tous les CA rattachés aux clients
        --insert into test_message message values (p_userid);

        /*YNI
        --L'ancienne requete
         OPEN  p_curseur FOR
         SELECT distinct c.codcamo,
             to_char(c.codcamo)||' - '||nvl(c.clibca,'') lib
         FROM centre_activite c
         WHERE ((INSTR(l_ca_payeur, codcamo) > 0)
            OR (INSTR(l_ca_payeur, caniv1) > 0)
            OR (INSTR(l_ca_payeur, caniv2) > 0)
            OR (INSTR(l_ca_payeur, caniv3) > 0)
            OR (INSTR(l_ca_payeur, caniv4) > 0) )
            AND codcamo <> 0
            AND (c.cdateferm is null or substr(TO_DATE(c.cdateferm, 'DD/MM/YYYY'), 7, 8) = substr(TO_DATE(sysdate, 'DD/MM/YYYY'), 7, 8))
            ORDER BY 1;
          */
          OPEN  p_curseur FOR
         select ca.codcamo, to_char(ca.codcamo)||' - '||nvl(ca.clibca,'') lib  --toue les ca de niveau 0
              from centre_activite ca, entite_structure es
              where  ((INSTR(l_ca_payeur, ca.codcamo) > 0)
            OR (INSTR(l_ca_payeur, caniv1) > 0)
            OR (INSTR(l_ca_payeur, caniv2) > 0)
            OR (INSTR(l_ca_payeur, caniv3) > 0)
            OR (INSTR(l_ca_payeur, caniv4) > 0) )
            AND ca.codcamo <> 0
            AND (ca.cdateferm is null or substr(TO_DATE(ca.cdateferm, 'DD/MM/YYYY'), 7, 8) = substr(TO_DATE(sysdate, 'DD/MM/YYYY'), 7, 8))
              UNION           --tous le ca de niveau 1
              select distinct caniv1, to_char(es.codcamo)||' - '||nvl(es.licoes,'') lib
              from entite_structure es, centre_activite ca
              where
               ((INSTR(l_ca_payeur, ca.codcamo) > 0)
            OR (INSTR(l_ca_payeur, caniv1) > 0)
            OR (INSTR(l_ca_payeur, caniv2) > 0)
            OR (INSTR(l_ca_payeur, caniv3) > 0)
            OR (INSTR(l_ca_payeur, caniv4) > 0) )
            AND ca.codcamo <> 0
              and
              es.codcamo=caniv1
              AND (ca.cdateferm is null or substr(TO_DATE(ca.cdateferm, 'DD/MM/YYYY'), 7, 8) = substr(TO_DATE(sysdate, 'DD/MM/YYYY'), 7, 8))
              UNION              --tous le ca de niveau 2
              select distinct caniv2, to_char(es.codcamo)||' - '||nvl(es.licoes,'') lib
              from entite_structure es, centre_activite ca
              where
               ((INSTR(l_ca_payeur, ca.codcamo) > 0)
            OR (INSTR(l_ca_payeur, caniv1) > 0)
            OR (INSTR(l_ca_payeur, caniv2) > 0)
            OR (INSTR(l_ca_payeur, caniv3) > 0)
            OR (INSTR(l_ca_payeur, caniv4) > 0) )
            AND ca.codcamo <> 0
               and
              es.codcamo=caniv2
              AND (ca.cdateferm is null or substr(TO_DATE(ca.cdateferm, 'DD/MM/YYYY'), 7, 8) = substr(TO_DATE(sysdate, 'DD/MM/YYYY'), 7, 8))
              UNION              --tous le ca de niveau 2
              select distinct caniv3, to_char(es.codcamo)||' - '||nvl(es.licoes,'') lib
              from entite_structure es, centre_activite ca
              where
               ((INSTR(l_ca_payeur, ca.codcamo) > 0)
            OR (INSTR(l_ca_payeur, caniv1) > 0)
            OR (INSTR(l_ca_payeur, caniv2) > 0)
            OR (INSTR(l_ca_payeur, caniv3) > 0)
            OR (INSTR(l_ca_payeur, caniv4) > 0) )
            AND ca.codcamo <> 0
               and
              es.codcamo=caniv3
              AND (ca.cdateferm is null or substr(TO_DATE(ca.cdateferm, 'DD/MM/YYYY'), 7, 8) = substr(TO_DATE(sysdate, 'DD/MM/YYYY'), 7, 8))
              UNION              --le ca de niveau 3
              select codcamo, to_char(codcamo)||' - '||nvl(licoes,'') lib
              from entite_structure
              where
              (INSTR(l_ca_payeur, codcamo) > 0)
         ORDER BY 1;
         --Fin YNI

      EXCEPTION

          WHEN OTHERS THEN
             raise_application_error(-20997, SQLERRM);
      END;

   END lister_ca_niv0_utilisateur;


    PROCEDURE lister_global_ca_utilisateur ( p_ca_suivi  IN VARCHAR2,
                           p_curseur IN OUT RefCurTyp
              ) IS

     chaine_ca_suivi VARCHAR2(500);
l_ca_suivi VARCHAR2(5);
l_req VARCHAR2(10000);
l_compteur NUMBER;


  BEGIN

  chaine_ca_suivi :=  substr(p_ca_suivi,2,length(p_ca_suivi)-1)  ;

  commit;
  l_req :='(';
  l_compteur := 1 ;

     begin

     while (length(chaine_ca_suivi) != 0) loop



     if (instr(chaine_ca_suivi,',') != 0) then
          l_ca_suivi := substr(chaine_ca_suivi,0,instr(chaine_ca_suivi,',')-1);
          chaine_ca_suivi := substr(chaine_ca_suivi,instr(chaine_ca_suivi,',')+1);
     else
        l_ca_suivi := chaine_ca_suivi;
        chaine_ca_suivi := '';
     end if;



        if (l_compteur != 1) then
            l_req := l_req || 'UNION';

        end if;

        CASE (recherche_niveau(l_ca_suivi)+1)
             WHEN 1 Then
                 l_req := l_req||'(
                            select ca.codcamo, to_char(ca.codcamo)|| ''-'' ||nvl(ca.clibca,'''') lib
                            from centre_activite ca
                            where
                            ca.codcamo IN ('|| l_ca_suivi || ')
                            AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                            )';
             WHEN 2 Then
                l_req := l_req||'(
                             select ca.codcamo , to_char(ca.codcamo)||'' - ''||nvl(ca.clibca,'''') lib
                             from centre_activite ca
                             where
                                 CANIV1 IN ('|| l_ca_suivi || ')
                            AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                            UNION
                            select distinct caniv1, to_char(es.codcamo)||'' - ''||nvl(es.licoes,'''') lib
                            from entite_structure es, centre_activite ca
                            where
                            CANIV1 IN ('|| l_ca_suivi || ')
                             and    es.codcamo=caniv1
                            AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                            )';
             WHEN 3 Then
             l_req := l_req||' (
                                         select codcamo  , to_char(ca.codcamo)||'' - ''||nvl(ca.clibca,'''') lib
                                                    from centre_activite ca
                                                    where
                                                        CANIV2 IN ('|| l_ca_suivi|| ')
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                                                UNION
                                                select distinct caniv1 , to_char(es.codcamo)||'' - ''||nvl(es.licoes,'''') lib
                                                    from entite_structure es, centre_activite ca
                                                    where
                                                            CANIV2 IN ('|| l_ca_suivi|| ')
                                         and    es.codcamo=caniv1
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                                                UNION
                                                select distinct caniv2 , to_char(es.codcamo)||'' - ''||nvl(es.licoes,'''') lib
                                                    from entite_structure es, centre_activite ca
                                                    where
                                                                CANIV2 IN ('|| l_ca_suivi || ')
                                                 and    es.codcamo=caniv2
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                    )';
                WHEN 4 Then
                l_req := l_req||' (
                                         select codcamo  , to_char(ca.codcamo)||'' - ''||nvl(ca.clibca,'''') lib
                                                    from centre_activite  ca
                                                    where
                                                             CANIV3 IN ('|| l_ca_suivi || ')
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                                                UNION
                                                select distinct caniv1 , to_char(es.codcamo)||'' - ''||nvl(es.licoes,'''') lib
                                                    from entite_structure es, centre_activite ca
                                                    where
                                                            CANIV3 IN ('|| l_ca_suivi || ')
                                         and    es.codcamo=caniv1
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                                                UNION
                                                select distinct caniv2 , to_char(es.codcamo)||'' - ''||nvl(es.licoes,'''') lib
                                                    from entite_structure es, centre_activite ca
                                                    where
                                                            CANIV3 IN ('|| l_ca_suivi || ')
                                         and    es.codcamo=caniv2
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                                                UNION
                                                select distinct caniv3 , to_char(es.codcamo)||'' - ''||nvl(es.licoes,'''') lib
                                                    from entite_structure es, centre_activite ca
                                                    where
                                                            CANIV3 IN ('|| l_ca_suivi|| ')
                                         and    es.codcamo=caniv3
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                                                )';
       
                WHEN 5 Then
                    l_req :=l_req|| '
                                      (
                                         select codcamo  , to_char(ca.codcamo)||'' - ''||nvl(ca.clibca,'''') lib
                                                    from centre_activite ca
                                                    where
                                                                CANIV4 IN ('|| l_ca_suivi || ')
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                                                UNION
                                                select distinct caniv1 , to_char(es.codcamo)||'' - ''||nvl(es.licoes,'''') lib
                                                    from entite_structure es, centre_activite ca
                                                    where
                                                    CANIV4 IN ('|| l_ca_suivi|| ')
                                         and    es.codcamo=caniv1
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                                                UNION
                                                select distinct caniv2 , to_char(es.codcamo)||'' - ''||nvl(es.licoes,'''') lib
                                                    from entite_structure es, centre_activite ca
                                                    where
                                                CANIV4 IN ('|| l_ca_suivi || ')
                                         and    es.codcamo=caniv2
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                                                UNION
                                                select distinct caniv3 , to_char(es.codcamo)||'' - ''||nvl(es.licoes,'''') lib
                                                    from entite_structure es, centre_activite ca
                                                    where
                                                    CANIV4 IN ('|| l_ca_suivi || ')
                                         and    es.codcamo=caniv3
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                                                UNION
                                                select distinct caniv4 , to_char(es.codcamo)||'' - ''||nvl(es.licoes,'''') lib
                                                    from entite_structure es, centre_activite ca
                                                    where
                                                CANIV4 IN ('|| l_ca_suivi || ')
                                                and    es.codcamo=caniv4
                                                AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8))
                                                )';
          ELSE
          l_req := substr(l_req,1,length(l_req)-5)  ;
       END CASE ;



        l_compteur := l_compteur+1;
      END LOOP;


      l_req := l_req || ')';
      

 -- On affiche tous les CA rattachés aux clients

         OPEN  p_curseur FOR l_req;

  EXCEPTION
         WHEN OTHERS THEN

            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;


   END lister_global_ca_utilisateur;


  PROCEDURE liste_niveau0_ca(p_codcamo in number,
                             p_curseur out liste_ca,
                             p_mesage out varchar2)
  is

  cursor ca_cur is
  select niveau
  from entite_structure where codcamo=p_codcamo;

    BEGIN


       p_mesage := '';
       for ca_rec in ca_cur loop

        if(ca_rec.niveau = 0)then

            open p_curseur for
            select ca.codcamo, clibca, 0 as niveau
            from centre_activite ca, entite_structure es
            where
            ca.codcamo=p_codcamo
            and ca.codcamo=es.codcamo;

        elsif(ca_rec.niveau = 1)then

            open p_curseur for
            select ca.codcamo, clibca, 0 as niveau
            from centre_activite ca, entite_structure es
            where
            caniv1=p_codcamo
            and ca.codcamo=es.codcamo;

        elsif(ca_rec.niveau = 2) then

          open p_curseur for
              select ca.codcamo, clibca, 0 as niveau
              from centre_activite ca, entite_structure es
              where
              caniv2=p_codcamo
              and ca.codcamo=es.codcamo;

        elsif(ca_rec.niveau = 3) then

              open p_curseur for
              select ca.codcamo, clibca, 0 as niveau
              from centre_activite ca, entite_structure es
              where
              caniv3=p_codcamo
              and ca.codcamo=es.codcamo;

        elsif(ca_rec.niveau = 4) then

              open p_curseur for
              select ca.codcamo, clibca, 0 as niveau
              from centre_activite ca, entite_structure es
              where
              caniv4=p_codcamo
              and ca.codcamo=es.codcamo;
        end if;
       end loop;

       exception when others then
       raise_application_error(to_char(sqlcode), sqlerrm);

  END liste_niveau0_ca;


  PROCEDURE liste_globale_ca(p_codcamo in varchar2,
                             p_curseur out liste_ca,
                             p_niveau out varchar2,
                             p_mesage out varchar2)
  is

    cursor ca_cur is
      select codcamo, liloes, niveau
      from entite_structure where codcamo=p_codcamo;


    begin
    p_mesage := '';

     if p_codcamo <> 'TOUS' then
               for ca_rec in ca_cur loop

                if(ca_rec.niveau = 0)then

                    open p_curseur for
                    select ca.codcamo, clibca, 0 as niveau
                    from centre_activite ca, entite_structure es
                    where
                    ca.codcamo=p_codcamo
                    and ca.codcamo=es.codcamo;
                    p_niveau := 0;

            elsif(ca_rec.niveau = 1)then

            open p_curseur for
            select ca.codcamo, clibca, 0 as niveau       --toue les ca de niveau 0
            from centre_activite ca, entite_structure es
            where
            caniv1=p_codcamo
            and caniv1=es.codcamo
            UNION
            select codcamo, liloes, niveau
            from entite_structure
            where
            codcamo=p_codcamo;
            p_niveau := 1;

        elsif(ca_rec.niveau = 2) then

          open p_curseur for
              select ca.codcamo, clibca, 0 as niveau       --tous les ca de niveau 0
              from centre_activite ca, entite_structure es
              where
              caniv2=p_codcamo
              and caniv2=es.codcamo
              UNION
              select distinct caniv1, liloes, niveau     --tous les ca de niveau 1
              from entite_structure es, centre_activite ca
              where
              caniv2=p_codcamo and
              es.codcamo=caniv1
              UNION
              select codcamo, liloes, niveau              -- le ca de niveau 2
              from entite_structure
              where
              codcamo=p_codcamo;
              p_niveau := 2;

        elsif(ca_rec.niveau = 3) then

              open p_curseur for --tous le ca de niveau 0
              select ca.codcamo, clibca, 0 as niveau       --toue les ca de niveau 0
              from centre_activite ca, entite_structure es
              where
              caniv3=p_codcamo
              and caniv3=es.codcamo
              UNION           --tous le ca de niveau 1
              select distinct caniv1, liloes, niveau
              from entite_structure es, centre_activite ca
              where
              caniv3=p_codcamo and
              es.codcamo=caniv1
              UNION              --tous le ca de niveau 2
              select distinct caniv2, liloes, niveau
              from entite_structure es, centre_activite ca
              where
              caniv3=p_codcamo and
              es.codcamo=caniv2
              UNION              --le ca de niveau 3
              select codcamo, liloes, niveau
              from entite_structure
              where
              codcamo=p_codcamo;
              p_niveau := 3;

        elsif(ca_rec.niveau = 4) then

              open p_curseur for --tous le ca de niveau 0
              select ca.codcamo, clibca, 0 as niveau
              from centre_activite ca, entite_structure es
              where
              caniv4=p_codcamo
              and caniv4=es.codcamo
              UNION           --tous le ca de niveau 1
              select distinct caniv1, liloes, niveau
              from entite_structure es, centre_activite ca
              where
              caniv4=p_codcamo and
              es.codcamo=caniv1
              UNION              --tous le ca de niveau 2
              select distinct caniv2, liloes, niveau
              from entite_structure es, centre_activite ca
              where
              caniv4=p_codcamo and
              es.codcamo=caniv2
              UNION              --tous le ca de niveau 3
              select distinct caniv3, liloes, niveau
              from entite_structure es, centre_activite ca
              where
              caniv4=p_codcamo and
              es.codcamo=caniv3
              UNION              --le ca de niveau 3
              select codcamo, liloes, niveau
              from entite_structure
              where
              codcamo=p_codcamo;
              p_niveau := 4;

        end if;
       end loop;
else
    open p_curseur for
                    select distinct ca.codcamo, clibca, 0 as niveau
                    from centre_activite ca
                    order by ca.codcamo;
       end if;
       exception when others then
       raise_application_error(to_char(sqlcode), sqlerrm);



 end liste_globale_ca;

  PROCEDURE select_ligne_inv_c ( p_codcamo     IN CHAR,
                                 p_annee       IN CHAR,
                                 p_codinv      OUT VARCHAR2,
                                 p_clibca      OUT VARCHAR2) IS
  l_msg varchar2(1024);

  BEGIN


         BEGIN
             select
             DECODE(max(codinv), null, '001',  TO_CHAR(max(codinv) + 1, 'FM000'))
             into p_codinv
             from ligne_investissement li
             where  li.codcamo  = TO_NUMBER(p_codcamo)
                   AND annee = TO_NUMBER(p_annee);
             EXCEPTION
             WHEN NO_DATA_FOUND THEN p_codinv := '001';
             WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);
         END;


        BEGIN
            select clibca into p_clibca
            from  centre_activite
            where codcamo = TO_NUMBER(p_codcamo);
            EXCEPTION
            /*WHEN NO_DATA_FOUND THEN
                pack_global.recuperer_message(20969, '%s1', p_codcamo, 'codcamo', p_message);
                raise_application_error( -20969, p_message);*/
            WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);
        END;

        dbms_output.put_line('clibca:' || p_clibca);
        dbms_output.put_line('codinv:' || p_codinv);

  END select_ligne_inv_c;


  PROCEDURE select_ligne_rea_c ( p_codinv      IN CHAR,
                                 p_codcamo     IN CHAR,
                                 p_annee       IN CHAR,
                                 p_codrea      OUT VARCHAR2,
                                 p_clibca      OUT VARCHAR2,
                                 p_type_ligne  OUT VARCHAR2,
                                 p_projet    OUT VARCHAR2,
                                 p_dossier_projet OUT VARCHAR2,
                                 p_disponible    OUT VARCHAR2,
                                 p_disponible_htr OUT VARCHAR2,
                                 p_message     OUT VARCHAR2) IS

   l_msg         VARCHAR(1024);
   l_codinv     ligne_investissement.codinv%TYPE;
   l_codcamo     ligne_investissement.codcamo%TYPE;
   l_annee         ligne_investissement.annee%TYPE;
   l_taux       taux_recup.taux%TYPE;
   l_not_tvarecup  ligne_investissement.not_tvarecup%TYPE;

  BEGIN

       p_message := '';

       ------------ Test si la lign correspondant au p_codinv, p_codcamo_, p_annee
       ------------ passes en parametres existe

       IF (p_codinv IS NOT NULL AND p_codcamo IS NOT NULL AND p_annee IS NOT NULL) THEN

           BEGIN

        -- Verifier que le ligne budgetaire existe pour la modification
            SELECT
                li.codinv,
                li.codcamo,
                li.annee,
                clibca,
                inv.lib_type,
                p.ilibel,
                dp.dplib,
                lpad(nvl(to_char(li.notifie - pack_suivi_investissement.sum_realises(TO_NUMBER(p_codinv),TO_NUMBER(p_codcamo),TO_NUMBER(p_annee)), 'FM9999999999.00'),'.00'),13,' ') ,
                lpad(nvl(to_char(li.notifie*decode(not_tvarecup, null,(1+t.tva/100*(1-tr.taux/100)) ,1+not_tvarecup/100) - pack_suivi_investissement.sum_realises_htr(TO_NUMBER(p_codinv),TO_NUMBER(p_codcamo),TO_NUMBER(p_annee)), 'FM9999999999.00'),'.00'),13,' ')
                   INTO
                   l_codinv,
                   l_codcamo,
                   l_annee,
                   p_clibca,
                   p_type_ligne,
                   p_projet,
                   p_dossier_projet,
                   p_disponible,
                   p_disponible_htr
               FROM
                   ligne_investissement li,
                   investissements inv,
                   dossier_projet dp,
                   centre_activite ca,
                   proj_info p,
                   tva t,
                   taux_recup tr

               WHERE
               li.codinv = TO_NUMBER(p_codinv)
               AND li.codcamo  = TO_NUMBER(p_codcamo)
               AND li.annee = TO_NUMBER(p_annee)
            AND ca.codcamo = TO_NUMBER(p_codcamo)
            --
            AND li.dpcode = dp.dpcode
            AND li.type = inv.codtype
            --
            AND li.icpi = p.icpi
            --
            AND tr.filcode = ca.filcode
            AND tr.annee = li.annee
            AND t.datetva =(select max(TVA.datetva) from tva where datetva <= pack_suivi_investissement.cherche_date_exercice)
            group by li.codinv,
                li.codcamo,
                li.annee,
                clibca,
                inv.lib_type,
                p.ilibel,
                dp.dplib,
                li.notifie,
                not_tvarecup,
                t.tva,
                tr.taux;

           EXCEPTION
               WHEN NO_DATA_FOUND THEN
               pack_global.recuperer_message(20960, '%s1', p_codinv, '%s2', p_annee, '%s3', p_codcamo, 'codinv', l_msg);
               raise_application_error( -20960, l_msg );
               WHEN OTHERS THEN
               raise_application_error( -20997, SQLERRM);
           END;

           p_message := l_msg;
       END IF;


       BEGIN
          select
          --DECODE(max(rownum), null, '01',  TO_CHAR(max(rownum) + 1, 'FM00'))
          DECODE(max(codrea), null, '01',  TO_CHAR(max(codrea) + 1, 'FM00'))
          into p_codrea
          from ligne_realisation
          WHERE codinv = TO_NUMBER(p_codinv)
                   AND codcamo  = TO_NUMBER(p_codcamo)
                   AND annee = TO_NUMBER(p_annee);

          EXCEPTION
             WHEN NO_DATA_FOUND THEN p_codrea := '01';
             WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);
       END;

  END select_ligne_rea_c;

  PROCEDURE select_ligne_rea_m (  p_codrea      IN VARCHAR2,
                                  p_codinv       IN CHAR,
                                  p_codcamo     IN CHAR,
                                  p_annee       IN CHAR,
                                  p_curLigneRea IN OUT ligneReaCurType,
                                  p_userid      IN  VARCHAR2,
                                  p_message     OUT VARCHAR2)
  IS
   l_msg         VARCHAR(1024);
   l_codinv     ligne_investissement.codinv%TYPE;
   l_codcamo     ligne_investissement.codcamo%TYPE;
   l_annee         ligne_investissement.annee%TYPE;
   l_codrea     ligne_realisation.codrea%TYPE;

  BEGIN

       p_message := '';

       ------------ Test si la ligne correspondant au p_codinv, p_codcamo_, p_annee
       ------------ passes en parametres existe

       IF (p_codrea IS NOT NULL AND p_codinv IS NOT NULL AND p_codcamo IS NOT NULL AND p_annee IS NOT NULL) THEN

           BEGIN

               -- Verifier que le ligne de réalisation existe pour la modification

            SELECT codinv, codcamo, annee, codrea
               INTO l_codinv, l_codcamo, l_annee, l_codrea
               FROM ligne_realisation
               WHERE codinv = TO_NUMBER(p_codinv)
               AND codcamo  = TO_NUMBER(p_codcamo)
               AND annee = TO_NUMBER(p_annee)
            AND codrea = TO_NUMBER(p_codrea);

           EXCEPTION
               WHEN NO_DATA_FOUND THEN
               --pack_global.recuperer_message(20976, '%s1', p_codinv, '%s2', p_annee, '%s3', p_codcamo, 'codinv', p_message);
            pack_global.recuperer_message(20976, '%s1', p_codrea, '%s2', p_codinv, '%s3', p_codcamo, null, p_message);
               raise_application_error( -20960, p_message);
               WHEN OTHERS THEN
               raise_application_error( -20997, SQLERRM);
           END;


       END IF;


       BEGIN
          OPEN p_curLigneRea FOR SELECT
                                 lr.codrea,
                     lr.codinv,
                     lr.annee,
                 lr.codcamo,
                 lr.num_cmd,
                 lr.type_cmd,
                 lr.marque,
                 lr.modele,
                 decode(lr.comrea, null, '', lr.comrea) as comrea,
                 lr.date_saisie,
                 TO_CHAR(lr.engage) as engage,
                 lr.type_eng,
                 inv.lib_type,
                 p.ilibel,
                 dp.dplib,
                 lpad(nvl(to_char(li.notifie - pack_suivi_investissement.sum_realises(TO_NUMBER(p_codinv),TO_NUMBER(p_codcamo),TO_NUMBER(p_annee)), 'FM9999999999.00'),'.00'),13,' ') as disponible,
                 lpad(nvl(to_char(li.notifie*decode(not_tvarecup, null,(1+t.tva/100*(1-tr.taux/100)) ,1+not_tvarecup/100) - pack_suivi_investissement.sum_realises_htr(TO_NUMBER(p_codinv),TO_NUMBER(p_codcamo),TO_NUMBER(p_annee)), 'FM9999999999.00'),'.00'),13,' ') as disponible_htr,
                 lr.flaglock,
                           ca.clibca
          from
              ligne_realisation lr,
              centre_activite ca,
              ligne_investissement li,
              investissements inv,
              dossier_projet dp,
              proj_info p,
              taux_recup tr,
              tva t
          WHERE lr.codinv = TO_NUMBER(p_codinv)
               AND lr.codcamo  = TO_NUMBER(p_codcamo)
               AND lr.annee = TO_NUMBER(p_annee)
                AND lr.codrea = TO_NUMBER(p_codrea)
                AND ca.codcamo =  TO_NUMBER(p_codcamo)
                --
                AND lr.codinv = li.codinv
                AND lr.annee = li.annee
                AND lr.codcamo = li.codcamo
                AND li.dpcode = dp.dpcode
                AND li.type = inv.codtype
                --
                AND li.icpi = p.icpi
                --
                AND tr.filcode = ca.filcode
                AND tr.annee = li.annee
                AND t.datetva =(select max(TVA.datetva) from tva where datetva <= TO_DATE(lr.date_saisie, 'DD/MM/YYYY'));
       END;

  END select_ligne_rea_m;


   PROCEDURE select_ligne_inv_m ( p_mode        IN  VARCHAR2,
                   p_codinv       IN CHAR,
                                p_codcamo             IN CHAR,
                                p_annee          IN CHAR,
                                p_curLigneInv    IN OUT ligneInvCurType,
                                p_userid     IN  VARCHAR2,
                                p_message        OUT VARCHAR2
                              ) IS

    l_msg         VARCHAR(1024);
    l_codinv     ligne_investissement.codinv%TYPE;
    l_codcamo     ligne_investissement.codcamo%TYPE;
    l_annee         ligne_investissement.annee%TYPE;
        l_icpi          ligne_investissement.icpi%TYPE;
        l_dpcode        ligne_investissement.dpcode%TYPE;
        l_notifie       ligne_investissement.notifie%TYPE;
        l_type          investissements.codtype%TYPE;
        l_sousmenus       VARCHAR2(255);


   BEGIN

    p_message := '';

    -- Récupération des sous menus de l'utilisateur.

    l_sousmenus := pack_global.lire_globaldata(p_userid).sousmenus;

       --Test si la lign correspondant au p_codinv, p_codcamo_, p_annee
    -- passes en parametres existe

       IF (p_codinv IS NOT NULL AND p_codcamo IS NOT NULL AND p_annee IS NOT NULL) THEN

        BEGIN

            -- Verifier que le ligne budgetaire existe pour la modification

            SELECT codinv, codcamo, annee,
                   type, icpi, dpcode, notifie
            INTO l_codinv, l_codcamo, l_annee,
                 l_type, l_icpi, l_dpcode, l_notifie
            FROM ligne_investissement
            WHERE codinv = TO_NUMBER(p_codinv)
            AND codcamo  = TO_NUMBER(p_codcamo)
            AND annee = TO_NUMBER(p_annee);

            --vérifier que laligne n'est pas déjà notifiée et que l'utilisateur n'est pas superviseur des investissements
              IF (INSTR(l_sousmenus,'ginv') = 0  AND l_notifie <> 0) THEN

                 pack_global.recuperer_message(20965, '%s1', p_codinv, '%s2', p_annee, '%s3', p_codcamo, 'codinv', l_msg);
             if p_mode = 'delete' then
                 raise_application_error( -20965, l_msg );
         end if;
            END IF;

            EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                      pack_global.recuperer_message(20960, '%s1', p_codinv, '%s2', p_annee, '%s3', p_codcamo, 'codinv', l_msg);
                      raise_application_error( -20960, l_msg );
                      WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);
        END;
        p_message := l_msg;
    END IF;

    OPEN p_curLigneInv FOR SELECT
            li.codinv,
        li.annee,
        li.codcamo,
        li.type,
        li.icpi,
        li.dpcode,
        li.libelle,
        li.quantite,
        TO_CHAR(li.demande) as demande,
        TO_CHAR(li.notifie) as notifie,
        TO_CHAR(sum(lr.engage)) as engage, --new kha09/04
        TO_CHAR(li.re_estime) as re_estime,
        TO_CHAR(sum(lr.engage)) as realise,
        TO_CHAR(li.notifie - sum(lr.engage)) as disponible, --new kha 09/04
        decode(li.cominv, null, '', li.cominv) as cominv,
        decode(li.toprp, null, '', li.toprp) as toprp,
        li.flaglock,
            clibca,
            lib_type,
        ilibel,
        dplib
        FROM  ligne_investissement li,
              ligne_realisation lr,
              centre_activite centre,
              investissements inv,
              proj_info pi,
              dossier_projet dp
         WHERE li.codinv = p_codinv
         AND li.codcamo = p_codcamo
         AND li.annee = p_annee
         AND li.codcamo = centre.codcamo
         AND centre.codcamo = li.codcamo
         AND li.type = inv.codtype
         AND inv.codtype = l_type
         AND li.icpi = pi.icpi
         AND pi.icpi = l_icpi
         AND li.dpcode = dp.dpcode
         AND dp.dpcode = l_dpcode
         -- jointure ligne inv <=> ligne real
         AND li.codinv = lr.codinv(+)
         AND li.annee = lr.annee(+)
         AND li.codcamo = lr.codcamo(+)
         GROUP BY li.codinv,
                li.annee,
                li.codcamo,
                li.type,
                li.icpi,
                li.dpcode,
                li.libelle,
                li.quantite,
                li.demande,
                li.notifie,
                --li.engage, kha 09/04
                li.re_estime,
                --li.disponible, kha 09/04
                li.cominv,
                li.toprp,
                li.flaglock,
                    clibca,
                    lib_type,
                ilibel,
                dplib;

   END select_ligne_inv_m;


   PROCEDURE insert_ligne_inv (
                   p_codinv           IN CHAR,
                       p_annee         IN CHAR,
                           p_codcamo       IN CHAR,
                           p_type        IN CHAR,
                       p_pcode     IN CHAR,
                           p_dpcode        IN CHAR,
                           p_libelle       IN VARCHAR2,
                        p_quantite      IN VARCHAR2,
                           p_demande          IN VARCHAR2,
                           p_notifie       IN VARCHAR2,
                           --p_engage        IN VARCHAR2, --kha09/04
                           p_re_estime        IN VARCHAR2,
                           --p_disponible   IN VARCHAR2, --kha09/04
                           p_cominv       IN VARCHAR2,
                           p_toprp       IN CHAR,
                           p_message        OUT VARCHAR2
                              ) IS

     l_msg         VARCHAR(1024);
    l_codinv     ligne_investissement.codinv%TYPE;
    l_codcamo     ligne_investissement.codcamo%TYPE;
    l_annee     ligne_investissement.annee%TYPE;

   BEGIN

        BEGIN
            INSERT INTO ligne_investissement (
            codinv,
              annee,
            codcamo,
            type,
            icpi,
            dpcode,
            libelle,
            quantite,
            demande,
            notifie,
            --engage,
            re_estime,
            --disponible,
            cominv,
            toprp,
            flaglock,
            not_tvarecup,
            date_modif_re
            )
            VALUES (
            p_codinv,
            p_annee,
            p_codcamo,
            p_type,
            p_pcode,
            p_dpcode,
            decode(p_libelle, null, '', p_libelle),
            decode(p_quantite, null, 1, p_quantite),
            decode(p_demande, null, 0, p_demande),
            decode(p_notifie, null, 0, p_notifie),
            --0, --cumul des engagés des realisés
            decode(p_demande, null, 0, p_demande),
            --decode(p_notifie, null, 0, p_notifie), -- disponible = notifie - engagé
                decode(p_cominv, null, '', p_cominv),
            decode(p_toprp, null, '', p_toprp),
                0,
                '',
                decode(p_demande, null, '',to_char(pack_suivi_investissement.cherche_date_exercice,'DD/MM/YYYY')));

            --Ligne investissement %s1 pour l''année d''exercice %s2 et le centre d''activité %s3 %s1 créé.

            pack_global.recuperer_message(20961, '%s1', p_codinv, '%s2', p_annee, '%s3', p_codcamo, NULL, l_msg);
            p_message := l_msg;

          EXCEPTION

              -- Ne pas intercepter les autres exceptions

            WHEN OTHERS THEN
               raise_application_error( -20997, SQLERRM);

          END;

   END insert_ligne_inv;


   PROCEDURE insert_ligne_rea (
                              p_codrea           IN VARCHAR2,
                                p_codinv           IN VARCHAR2,
                                p_annee            IN VARCHAR2,
                                p_codcamo          IN VARCHAR2,
                                            p_type_cmd         IN VARCHAR2,
                                p_num_cmd          IN VARCHAR2,
                                p_marque           IN VARCHAR2,
                                p_modele           IN VARCHAR2,
                                p_comrea        IN VARCHAR2,
                                p_date_saisie      IN VARCHAR2,
                                p_engage           IN VARCHAR2,
                                p_type_eng         IN VARCHAR2,
                                p_flaglock         IN INT,
                                            p_message             OUT VARCHAR2

                              ) IS

     msg         VARCHAR(1024);
    l_codinv     ligne_investissement.codinv%TYPE;
    l_ca         ligne_investissement.codcamo%TYPE;
    l_annee     ligne_investissement.annee%TYPE;
    l_msg VARCHAR2(1024);
 --   l_engage ligne_realisation.engage%TYPE;
 --   l_disponible ligne_investissement.disponible%TYPE;
    l_notifie ligne_investissement.notifie%TYPE;

   BEGIN

   p_message := '';

       BEGIN
            INSERT INTO ligne_realisation (
                   codrea,
                   codinv,
           annee,
           codcamo,
                   type_cmd,
           num_cmd,
           marque,
           modele,
           comrea,
           date_saisie,
                   engage,
           type_eng,
           flaglock)
            VALUES ( p_codrea,
                     p_codinv,
                     p_annee,
                     p_codcamo,
                     decode(p_type_cmd, null, '', p_type_cmd),
                     decode(p_num_cmd, null, '', p_num_cmd),
                     decode(p_marque, null, '', p_marque),
                     decode(p_modele, null, '', p_modele),
                     decode(p_comrea, null, '', p_comrea),
                     decode(p_date_saisie, null, TO_CHAR(pack_suivi_investissement.cherche_date_exercice, 'DD/MM/YYYY'), p_date_saisie),
                     decode(p_engage, null, 0, p_engage),
                     decode(p_type_eng, null, '', p_type_eng),
                     0);

                     pack_global.recuperer_message(20964, '%s1', p_codrea, '%s2', p_codinv, NULL, l_msg);
                     p_message := l_msg;

          EXCEPTION

              -- Ne pas intercepter les autres exceptions

            WHEN OTHERS THEN
               raise_application_error( -20997, SQLERRM);

          END;

          --maj dans ligne d'investissement du montant ENGAGE et DISPONIBLE
--kha 09/04 engagé et disponible des lignes investissement ne sont plus utilisés
       --BEGIN
       --    select nvl(notifie,0) into l_notifie
       --    from ligne_investissement where
       --    codcamo=p_codcamo
       --    and codinv=p_codinv
       --    and annee=to_number(p_annee);

       --l_engage := sum_realises(p_codinv, p_codcamo, p_annee);
       --l_disponible := l_notifie - l_engage;

    --UPDATE ligne_investissement
    --SET engage=nvl(l_engage,0),
    --    disponible=nvl(l_disponible,0)
    --WHERE    codinv = TO_NUMBER(p_codinv)
        --    AND codcamo  = TO_NUMBER(p_codcamo)
        --    AND annee = TO_NUMBER(p_annee)
        --    ;
    --EXCEPTION
              -- Ne pas intercepter les autres exceptions
        --    WHEN OTHERS THEN
        --       raise_application_error( -20997, SQLERRM);
    --END;

   END insert_ligne_rea;

   PROCEDURE update_ligne_rea ( p_codrea           IN VARCHAR2,
                                p_codinv           IN VARCHAR2,
                                p_annee            IN VARCHAR2,
                                p_codcamo          IN VARCHAR2,
                                            p_type_cmd         IN VARCHAR2,
                                p_num_cmd           IN VARCHAR2,
                                p_marque           IN VARCHAR2,
                                p_modele           IN VARCHAR2,
                                p_comrea        IN VARCHAR2,
                                p_date_saisie      IN VARCHAR2,
                                p_engage           IN VARCHAR2,
                                p_type_eng         IN VARCHAR2,
                                p_flaglock         IN INT,
                                            p_message             OUT VARCHAR2
                              )IS

    l_msg         VARCHAR(1024);
    l_codinv     ligne_investissement.codinv%TYPE;
    l_codcamo     ligne_investissement.codcamo%TYPE;
    l_annee     ligne_investissement.annee%TYPE;
    l_codrea     ligne_realisation.codrea%TYPE;
  --  l_engage ligne_investissement.engage%TYPE;
   -- l_disponible ligne_investissement.disponible%TYPE;
    l_notifie ligne_investissement.notifie%TYPE;

    BEGIN

           IF (p_codrea IS NOT NULL AND p_codinv IS NOT NULL AND p_codcamo IS NOT NULL AND p_annee IS NOT NULL) THEN

              BEGIN

                  -- Verifier que le ligne de réalisation existe

              SELECT codinv, codcamo, annee, codrea
              INTO l_codinv, l_codcamo, l_annee, l_codrea
              FROM ligne_realisation WHERE codinv = TO_NUMBER(p_codinv)
              AND codcamo  = TO_NUMBER(p_codcamo)
              AND annee = TO_NUMBER(p_annee)
              AND codrea = TO_NUMBER(p_codrea);

              EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     pack_global.recuperer_message(20976, '%s1', p_codrea, '%s2', p_codinv, '%s3', p_codcamo, null, p_message);
                       raise_application_error( -20976, p_message);
                  WHEN OTHERS THEN
                       raise_application_error( -20997, SQLERRM);
              END;


          END IF;

          BEGIN

            UPDATE ligne_realisation SET
                type_cmd    = p_type_cmd,
                type_eng    = p_type_eng,
              num_cmd     = p_num_cmd,
              marque      = p_marque,
              modele      = p_modele,
                    comrea   = decode(p_comrea, null, '', p_comrea),
                    date_saisie = p_date_saisie,
                    engage        = TO_NUMBER(p_engage),
                    flaglock    = decode(p_flaglock, 1000000, 0, p_flaglock + 1)
            WHERE
            codrea  = TO_NUMBER(p_codrea)
            AND codinv = TO_NUMBER(p_codinv)
            AND codcamo  = TO_NUMBER(p_codcamo)
            AND annee = TO_NUMBER(p_annee)
            AND flaglock = p_flaglock;

            IF SQL%NOTFOUND THEN
               -- 'Accès concurrent'
               pack_global.recuperer_message( 20999, NULL, NULL, NULL, p_message);
               raise_application_error( -20999, p_message);
            ELSE
                --'Ligne de réalisation numéro %s1 associée à la ligne d''investissement %s2 et le centre d''activité %s3 modifiée
                pack_global.recuperer_message(20974, '%s1', p_codrea, '%s2', p_codinv, '%s3', p_codcamo, NULL, p_message);
            END IF;

            EXCEPTION WHEN OTHERS THEN raise_application_error( -20999, SQLERRM);
         END;
--kha 09/04 engagé et disponible des lignes investissement ne sont plus utilisés

         --maj dans ligne d'investissement du montant ENGAGE et DISPONIBLE

       --BEGIN
       --    select nvl(notifie,0) into l_notifie
       --    from ligne_investissement where
       --    codcamo=p_codcamo
       --    and codinv=p_codinv
       --    and annee=to_number(p_annee);

       --l_engage := sum_realises(p_codinv, p_codcamo, p_annee);
       --l_disponible := l_notifie - l_engage;

    --UPDATE ligne_investissement
    --SET engage=nvl(l_engage,0),
    --    disponible=nvl(l_disponible,0)
    --WHERE    codinv = TO_NUMBER(p_codinv)
        --    AND codcamo  = TO_NUMBER(p_codcamo)
        --    AND annee = TO_NUMBER(p_annee)
        --    ;
    --EXCEPTION
              -- Ne pas intercepter les autres exceptions
        --    WHEN OTHERS THEN
        --       raise_application_error( -20997, SQLERRM);
    --END;


    END update_ligne_rea;

    PROCEDURE delete_ligne_rea ( p_codrea      IN VARCHAR2,
                                   p_codinv      IN VARCHAR2,
                                   p_annee       IN VARCHAR2,
                                   p_codcamo     IN VARCHAR2,
                                 p_flaglock    IN NUMBER,
                                 p_message     OUT VARCHAR2)
                                 IS
    l_msg         VARCHAR(1024);
    l_codinv     ligne_investissement.codinv%TYPE;
    l_codcamo     ligne_investissement.codcamo%TYPE;
    l_annee     ligne_investissement.annee%TYPE;
    l_codrea     ligne_realisation.codrea%TYPE;
       retour_engage ligne_realisation.engage%TYPE;

    BEGIN

           IF (p_codrea IS NOT NULL AND p_codinv IS NOT NULL AND p_codcamo IS NOT NULL AND p_annee IS NOT NULL) THEN

              BEGIN

                  -- Verifier que le ligne de réalisation existe

              SELECT codinv, codcamo, annee, codrea
              INTO l_codinv, l_codcamo, l_annee, l_codrea
              FROM ligne_realisation WHERE codinv = TO_NUMBER(p_codinv)
              AND codcamo  = TO_NUMBER(p_codcamo)
              AND annee = TO_NUMBER(p_annee)
              AND codrea = TO_NUMBER(p_codrea);

              EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     pack_global.recuperer_message(20976, '%s1', p_codrea, '%s2', p_codinv, '%s3', p_codcamo, null, p_message);
                       raise_application_error( -20976, p_message);
                  WHEN OTHERS THEN
                       raise_application_error( -20997, SQLERRM);
              END;


          END IF;

          BEGIN
          --kha 09/04 engagé et disponible des lignes investissement ne sont plus utilisés

         -- On met à jour la ligne d'investissement

            --   SELECT engage
            --   INTO retour_engage
            --   FROM ligne_realisation r
            --   WHERE r.codinv=TO_NUMBER(p_codinv)
            --   AND codcamo  = TO_NUMBER(p_codcamo)
            --   AND annee = TO_NUMBER(p_annee)
            --   AND r.codrea = TO_NUMBER(p_codrea)
         --;


         --   UPDATE ligne_investissement i
         --   SET engage = engage - retour_engage,
         --       disponible = disponible + retour_engage
         --   WHERE  codinv = TO_NUMBER(p_codinv)
        --    AND codcamo  = TO_NUMBER(p_codcamo)
         --   AND annee = TO_NUMBER(p_annee)
        --    ;

         -- On supprime la ligne de realisation

            DELETE FROM
            ligne_realisation
            WHERE codinv = TO_NUMBER(p_codinv)
            AND codcamo  = TO_NUMBER(p_codcamo)
            AND annee = TO_NUMBER(p_annee)
            AND codrea = TO_NUMBER(p_codrea)
            AND  flaglock = p_flaglock;

            IF SQL%NOTFOUND THEN
               -- 'Accès concurrent'
               pack_global.recuperer_message( 20999, NULL, NULL, NULL, p_message);
               raise_application_error( -20999, p_message);
            ELSE
               --'Ligne de réalisation numéro %s1 associée à la ligne d''investissement %s2 et le centre d''activité %s3 supprimée
               pack_global.recuperer_message(20975, '%s1', p_codrea, '%s2', p_codinv, '%s3', p_codcamo, null, p_message);
            END IF;

            EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);
       END;


    END delete_ligne_rea;


  PROCEDURE update_ligne_inv ( p_codinv           IN VARCHAR2,
                               p_annee             IN VARCHAR2,
                               p_codcamo                IN VARCHAR2,
                               p_type            IN VARCHAR2,
                               p_pcode             IN VARCHAR2,
                               p_dpcode            IN VARCHAR2,
                               p_libelle           IN VARCHAR2,
                                p_quantite       IN VARCHAR2,
                               p_demande          IN VARCHAR2,
                               p_notifie           IN VARCHAR2,
                               p_re_estime        IN VARCHAR2,
                               p_cominv        IN VARCHAR2,
                               p_toprp        IN CHAR,
                               p_flaglock        IN NUMBER,
                               p_message        OUT VARCHAR2
                              )IS

    l_msg VARCHAR2(1024);
    l_codinv     ligne_investissement.codinv%TYPE;
    l_codcamo     ligne_investissement.codcamo%TYPE;
    l_annee     ligne_investissement.annee%TYPE;
    l_re_estime     ligne_investissement.re_estime%TYPE;
    l_notifie      ligne_investissement.notifie%TYPE;
    l_not_tvarecup  ligne_investissement.not_tvarecup%TYPE;

   BEGIN

       p_message := '';

         IF (p_codinv IS NOT NULL AND p_codcamo IS NOT NULL AND p_annee IS NOT NULL) THEN

            ------------ Test si la lign existe

            BEGIN

                -- Verifier que le ligne budgetaire existe pour la modification

                SELECT codinv, codcamo, annee, re_estime, not_tvarecup, notifie
                INTO l_codinv, l_codcamo, l_annee, l_re_estime, l_not_tvarecup, l_notifie
                FROM ligne_investissement
                WHERE codinv = TO_NUMBER(p_codinv)
                AND codcamo  = TO_NUMBER(p_codcamo)
                AND annee = TO_NUMBER(p_annee);


            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                pack_global.recuperer_message(20960, '%s1', p_codinv, '%s2', p_annee, '%s3', p_codcamo, 'codinv', l_msg);
                raise_application_error( -20960, l_msg );
                WHEN OTHERS THEN
                raise_application_error( -20997, SQLERRM);
            END;

            p_message := l_msg;

        END IF;

        BEGIN
    if (to_number(p_notifie) = 0) then
        l_not_tvarecup := '';
    else

        -- vérifier si déjà notifié ou renotification manuelle
            --sinon calcul du tva/taux de recup à la notification
            if (l_not_tvarecup is NULL or l_notifie <> to_number(p_notifie)) then
            --forcer la mise à jour de date_modif_re
            l_re_estime := 0;

            select     TVA * (1 - tr.taux / 100) into l_not_tvarecup
            from     tva t ,
                taux_recup tr,
                centre_activite ca
        WHERE      t.datetva = (select max(TVA.datetva) from tva where datetva <= pack_suivi_investissement.cherche_date_exercice)
            AND tr.annee=TO_NUMBER(p_annee)
            AND tr.filcode  = ca.filcode
            AND ca.codcamo = to_number(p_codcamo) ;
        end if;
    end if;

         UPDATE ligne_investissement SET
        type        = TO_NUMBER(p_type),
        icpi          = p_pcode,
                dpcode         = TO_NUMBER(p_dpcode),
                libelle     = decode(p_libelle, null, '', p_libelle),
                quantite    = TO_NUMBER(p_quantite),
                demande        = TO_NUMBER(p_demande),
                notifie        = decode(p_notifie, null, 0, TO_NUMBER(p_notifie)),
                re_estime    = TO_NUMBER(p_re_estime),
                --disponible  = decode(p_notifie, null, 0, TO_NUMBER(p_notifie)) - engage, --kha 09/04
                cominv          = decode(p_cominv, null, '', p_cominv),
                toprp          = decode(p_toprp, null, '', p_toprp),
                flaglock     = decode(p_flaglock, 1000000, 0, p_flaglock + 1),
                not_tvarecup    = l_not_tvarecup,
                date_modif_re   = decode(l_re_estime,p_re_estime,date_modif_re,to_char(pack_suivi_investissement.cherche_date_exercice,'DD/MM/YYYY'))--date modifiée si re-estimé modifié
            WHERE
             codinv = TO_NUMBER(p_codinv)
             AND codcamo  = TO_NUMBER(p_codcamo)
             AND annee = TO_NUMBER(p_annee)
             AND flaglock = p_flaglock;

            --'Ligne investissement %s1 pour l''année d''exercice %s2 et le centre d''activité %s3 %s1 modifiée.')
            pack_global.recuperer_message(20962, '%s1', p_codinv, '%s2', p_annee, '%s3', p_codcamo, NULL, l_msg);
            p_message := l_msg;

            EXCEPTION WHEN OTHERS THEN raise_application_error( -20999, SQLERRM);
         END;

   END update_ligne_inv;

   PROCEDURE delete_ligne_inv ( p_codinv      IN CHAR,
                                 p_codcamo          IN CHAR,
                                 p_annee       IN CHAR,
                                 p_flaglock  IN NUMBER,
                                 p_message     OUT VARCHAR2)

    IS
    l_msg       varchar2(1024);
    l_codinv     ligne_investissement.codinv%TYPE;
    l_codcamo     ligne_investissement.codcamo%TYPE;
    l_annee     ligne_investissement.annee%TYPE;


    BEGIN

        p_message := '';

        IF (p_codinv IS NOT NULL AND p_codcamo IS NOT NULL AND p_annee IS NOT NULL) THEN

              BEGIN
              -- Verifier que le ligne budgetaire existe pour la modification

              SELECT codinv, codcamo, annee
              INTO l_codinv, l_codcamo, l_annee
              FROM ligne_investissement
              WHERE codinv = TO_NUMBER(p_codinv)
              AND codcamo  = TO_NUMBER(p_codcamo)
              AND annee = TO_NUMBER(p_annee);

              EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                  pack_global.recuperer_message(20960, '%s1', p_codinv, '%s2', p_annee, '%s3', p_codcamo, 'codinv', l_msg);
                  raise_application_error( -20960, l_msg );
                  WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);
             END;

             p_message := l_msg;

       END IF;


       BEGIN
         DELETE FROM ligne_realisation WHERE
         codinv = p_codinv
         AND codcamo = p_codcamo
         AND annee = p_annee;

         EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);
       END;

       BEGIN
          DELETE FROM
          ligne_investissement
          WHERE codinv = p_codinv
          AND codcamo = p_codcamo
          AND annee = p_annee
          AND  flaglock = p_flaglock;

          IF SQL%NOTFOUND THEN
             -- 'Accès concurrent'
             pack_global.recuperer_message( 20999, NULL, NULL, NULL, p_message);
             raise_application_error( -20999, p_message );
          ELSE
             --'Ligne investissement %s1 pour l''année d''exercice %s2 et le centre d''activité %s3 %s1 supprimée.')
             pack_global.recuperer_message(20963, '%s1', p_codinv, '%s2', p_annee, '%s3', p_codcamo, NULL, p_message);
          END IF;



          EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);
       END;

    END delete_ligne_inv;

    PROCEDURE notifier_centre_activite ( p_codcamo          IN VARCHAR2,
                                         p_niveau      IN VARCHAR2,
                                         p_annee       IN VARCHAR2,
                                         p_flaglock    IN NUMBER,
                                         p_message     OUT VARCHAR2)
    IS

--PRINCIPE DE LA NOTIFICATION
-- maj des champs NOTIFIE et REESTIME pour les lignes d'investissement correspondant au centre d'activité notifié
-- maj du DISPONIBLE (=Notifie - somme des réalisés)

    l_msg VARCHAR2(255);
    l_codinv ligne_investissement.CODINV%TYPE;
    l_codrea ligne_realisation.CODREA%TYPE;
    l_niveau NUMBER(1);
    l_codcamo     centre_activite.codcamo%TYPE;
    l_annee     ligne_investissement.annee%TYPE;
    l_realises  ligne_realisation.ENGAGE%TYPE;
    l_nb_lignes number(3);
    l_not_tvarecup ligne_investissement.not_tvarecup%TYPE;
    l_taux taux_recup.taux%TYPE;
    --liste des centres d'activités

    --definition du curseur pour le niveau 0
    cursor ca_niv0_cur is
           SELECT codcamo,
           DECODE(CLIBRCA, null, CLIBCA, CLIBRCA) AS CLIBCA,
           filcode
           FROM centre_activite WHERE codcamo=TO_NUMBER(p_codcamo);

    --definition du curseur pour le niveau 1
    cursor ca_niv1_cur is
           SELECT codcamo,
           DECODE(CLIBRCA, null, CLIBCA, CLIBRCA) AS CLIBCA,
           filcode
           FROM centre_activite WHERE caniv1=TO_NUMBER(p_codcamo);

    --definition du curseur pour le niveau 2

    cursor ca_niv2_cur is
           SELECT codcamo,
           DECODE(CLIBRCA, null, CLIBCA, CLIBRCA) AS CLIBCA,
           filcode
           FROM centre_activite WHERE caniv2=TO_NUMBER(p_codcamo);

    --definition du curseur pour le niveau 3
    cursor ca_niv3_cur is
           SELECT codcamo,
           DECODE(CLIBRCA, null, CLIBCA, CLIBRCA) AS CLIBCA,
           filcode
           FROM centre_activite WHERE caniv3=TO_NUMBER(p_codcamo);

    --definition des curseur pour le niveau 4
    cursor ca_niv4_cur is
           SELECT codcamo,
           DECODE(CLIBRCA, null, CLIBCA, CLIBRCA) AS CLIBCA,
           filcode
           FROM centre_activite WHERE caniv4=TO_NUMBER(p_codcamo);

    --liste des lignes d'investissements.

    cursor ligne_inv_cur(p_codcamo number) is
           select codinv, demande from ligne_investissement
           where codcamo = p_codcamo
           and annee = to_number(p_annee)
           order by codinv;

    BEGIN

         --l_niveau := TO_NUMBER(p_niveau);
         l_niveau := recherche_niveau(p_codcamo);
         --dbms_output.put_line('niveau trouvé :' || l_niveau);
         l_nb_lignes := 0;



         IF l_niveau = 0 THEN
            for ca_rec in ca_niv0_cur loop
        -- calcul du taux tva recuperable
        select taux into l_taux
        from taux_recup
        where annee =p_annee and filcode =ca_rec.filcode;
        select TVA * (1 - l_taux / 100) into l_not_tvarecup
        from tva t
        WHERE  t.datetva = (select max(TVA.datetva) from tva where datetva <= pack_suivi_investissement.cherche_date_exercice);
                for li_rec in ligne_inv_cur(ca_rec.codcamo) loop

                   update ligne_investissement set
                              flaglock     = decode(p_flaglock, 1000000, 0, p_flaglock + 1),
                              notifie = li_rec.demande,
                              re_estime  = li_rec.demande,
                              not_tvarecup = l_not_tvarecup,
                              date_modif_re = to_char(pack_suivi_investissement.cherche_date_exercice,'DD/MM/YYYY')
                              --disponible = li_rec.demande - li_rec.engage
                   where codinv = li_rec.codinv
                   and codcamo = ca_rec.codcamo
                   and annee=TO_NUMBER(p_annee);
                   --and flaglock = p_flaglock;

                   if(sql%found) then
                     l_nb_lignes := l_nb_lignes + 1;
                   end if;

                end loop;

            end loop;

         ELSIF l_niveau = 1 THEN
            for ca_rec in ca_niv1_cur loop
        -- calcul du taux tva recuperable
        select taux into l_taux
        from taux_recup
        where annee =p_annee and filcode =ca_rec.filcode;
        select TVA * (1 - l_taux / 100) into l_not_tvarecup
        from tva t
        WHERE  t.datetva = (select max(TVA.datetva) from tva where datetva <= pack_suivi_investissement.cherche_date_exercice);
                     for li_rec in ligne_inv_cur(ca_rec.codcamo) loop
                   l_realises := sum_realises(li_rec.codinv, ca_rec.codcamo, p_annee);

                   update ligne_investissement set
                              flaglock     = decode(p_flaglock, 1000000, 0, p_flaglock + 1),
                              notifie = li_rec.demande,
                              re_estime  = li_rec.demande,
                             not_tvarecup = l_not_tvarecup,
                             date_modif_re = to_char(pack_suivi_investissement.cherche_date_exercice,'DD/MM/YYYY')
                              --disponible = li_rec.demande - li_rec.engage
                   where codinv = li_rec.codinv
                   and codcamo = ca_rec.codcamo
                   and annee=TO_NUMBER(p_annee);

                   if(sql%found) then
                     l_nb_lignes := l_nb_lignes + 1;
                   end if;

                end loop;
            end loop;

         ELSIF l_niveau = 2 THEN
               for ca_rec in ca_niv2_cur loop
        -- calcul du taux tva recuperable
        select taux into l_taux
        from taux_recup
        where annee =p_annee and filcode =ca_rec.filcode;
        select TVA * (1 - l_taux / 100) into l_not_tvarecup
        from tva t
        WHERE  t.datetva = (select max(TVA.datetva) from tva where datetva <= pack_suivi_investissement.cherche_date_exercice);
                     for li_rec in ligne_inv_cur(ca_rec.codcamo) loop
                   l_realises := sum_realises(li_rec.codinv, ca_rec.codcamo, p_annee);

                   update ligne_investissement set
                              flaglock     = decode(p_flaglock, 1000000, 0, p_flaglock + 1),
                              notifie = li_rec.demande,
                              re_estime  = li_rec.demande,
                              not_tvarecup = l_not_tvarecup,
                              date_modif_re = to_char(pack_suivi_investissement.cherche_date_exercice,'DD/MM/YYYY')
                              --disponible = li_rec.demande - li_rec.engage
                   where codinv = li_rec.codinv
                   and codcamo = ca_rec.codcamo
                   and annee=TO_NUMBER(p_annee);

                   if(sql%found) then
                     l_nb_lignes := l_nb_lignes + 1;
                   end if;

                end loop;
            end loop;

         ELSIF l_niveau = 3 THEN
            for ca_rec in ca_niv3_cur loop
        -- calcul du taux tva recuperable
        select taux into l_taux
        from taux_recup
        where annee =p_annee and filcode =ca_rec.filcode;
        select TVA * (1 - l_taux / 100) into l_not_tvarecup
        from tva t
        WHERE  t.datetva = (select max(TVA.datetva) from tva where datetva <= pack_suivi_investissement.cherche_date_exercice);
                    for li_rec in ligne_inv_cur(ca_rec.codcamo) loop
                   l_realises := sum_realises(li_rec.codinv, ca_rec.codcamo, p_annee);

                   update ligne_investissement set
                              flaglock     = decode(p_flaglock, 1000000, 0, p_flaglock + 1),
                              notifie = li_rec.demande,
                              re_estime  = li_rec.demande,
                              not_tvarecup = l_not_tvarecup,
                              date_modif_re = to_char(pack_suivi_investissement.cherche_date_exercice,'DD/MM/YYYY')
                              --disponible = li_rec.demande - li_rec.engage
                   where codinv = li_rec.codinv
                   and codcamo = ca_rec.codcamo
                   and annee=TO_NUMBER(p_annee);

                   if(sql%found) then
                     l_nb_lignes := l_nb_lignes + 1;

                   end if;
                end loop;
            end loop;

         ELSE
            for ca_rec in ca_niv4_cur loop
        -- calcul du taux tva recuperable
        select taux into l_taux
        from taux_recup
        where annee =p_annee and filcode =ca_rec.filcode;
        select TVA * (1 - l_taux / 100) into l_not_tvarecup
        from tva t
        WHERE  t.datetva = (select max(TVA.datetva) from tva where datetva <= pack_suivi_investissement.cherche_date_exercice);
                    for li_rec in ligne_inv_cur(ca_rec.codcamo) loop
                   l_realises := sum_realises(li_rec.codinv, ca_rec.codcamo, p_annee);

                   update ligne_investissement set
                              flaglock     = decode(p_flaglock, 1000000, 0, p_flaglock + 1),
                              notifie = li_rec.demande,
                              re_estime  = li_rec.demande,
                              not_tvarecup = l_not_tvarecup,
                              date_modif_re = to_char(pack_suivi_investissement.cherche_date_exercice,'DD/MM/YYYY')
                              --disponible = li_rec.demande - li_rec.engage
                   where codinv = li_rec.codinv
                   and codcamo = ca_rec.codcamo
                   and annee=TO_NUMBER(p_annee);

                   if(sql%found) then
                     l_nb_lignes := l_nb_lignes + 1;
                   end if;

                end loop;
            end loop;

         END IF;

         if(l_nb_lignes > 1) then
             pack_global.recuperer_message(20966, '%s1', to_char(l_nb_lignes), '%s2', p_annee, '%s3', p_codcamo, NULL, l_msg);
         else
             pack_global.recuperer_message(20967, '%s1', to_char(l_nb_lignes), '%s2', p_annee, '%s3', p_codcamo, NULL, l_msg);
         end if;
         p_message := l_msg;

         EXCEPTION WHEN OTHERS THEN
               -- Accès concurrent
               --pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
               raise_application_error( -20999,  sqlerrm);

    END notifier_centre_activite;


    /**
    Fonction de calcul des réalisés pour la ligne d'investissement p_codinv
    le centre d'activité p_codcamo
    l'année p_annee
    **/
    FUNCTION sum_realises(p_codinv IN number,
                          p_codcamo IN number,
                          p_annee IN varchar2)
    RETURN NUMBER
    IS

    l_total ligne_realisation.ENGAGE%TYPE;

    BEGIN

       select sum(engage) into l_total
       from ligne_realisation
       where codinv=p_codinv
       and codcamo=p_codcamo
       and annee=to_number(p_annee);

       if(l_total is null) then
        l_total := 0;
       end if;
       return l_total;

       EXCEPTION WHEN OTHERS THEN return 0;

    END sum_realises;

    FUNCTION sum_realises_htr(p_codinv IN number,
                          p_codcamo IN number,
                          p_annee IN varchar2)
    RETURN NUMBER
    IS

    l_total ligne_realisation.ENGAGE%TYPE;

    BEGIN

    select sum(engage*(1+ t.tva/100*(1-tr.taux/100))) into l_total
       from ligne_realisation lr,
       centre_activite ca,
       taux_recup tr,
       tva t
       where lr.codinv=p_codinv
       and lr.codcamo=p_codcamo
       and lr.annee=to_number(p_annee)
       and tr.annee=lr.annee
       and tr.filcode = ca.filcode
       and lr.codcamo = ca.codcamo
       and t.datetva = (select max(TVA.datetva) from tva where datetva  <= to_date(lr.date_saisie,'DD/MM/YYYY'));

       if(l_total is null) then
        l_total := 0;
       end if;
       return l_total;

       EXCEPTION WHEN OTHERS THEN return 0;

    END sum_realises_htr;

   FUNCTION cherche_tva(p_datetva IN varchar2)
    RETURN NUMBER
    IS

    l_tva tva.tva%TYPE;

    BEGIN

    select t.tva into l_tva
       from tva t
       where
       t.datetva = (select max(TVA.datetva) from tva where datetva  <= to_date(p_datetva,'DD/MM/YYYY'));


       if(l_tva is null) then
        l_tva := 0;
       end if;
       return l_tva;

       EXCEPTION WHEN OTHERS THEN return 0;

    END cherche_tva;


    FUNCTION cherche_date_exercice
    RETURN DATE IS
     l_date datdebex.cmensuelle%TYPE;
     BEGIN

    --PPM 58896 : utilisation directe du cmensuelle sans soustraire 1 mois.
    select to_date(concat('01/', to_char(cmensuelle,'MM/YYYY'))) into l_date
       from datdebex d;

       return l_date;

       EXCEPTION WHEN OTHERS THEN return sysdate;

    END cherche_date_exercice;




    FUNCTION recherche_niveau(p_codcamo IN varchar2)
    RETURN NUMBER
    IS

    cursor niv0_cur is select codcamo from centre_activite
       where codcamo = TO_NUMBER(p_codcamo);

    cursor niv1_cur is select codcamo from centre_activite
       where caniv1 = TO_NUMBER(p_codcamo);

    cursor niv2_cur is select codcamo from centre_activite
       where caniv2 = TO_NUMBER(p_codcamo);

    cursor niv3_cur is select codcamo from centre_activite
       where caniv3 = TO_NUMBER(p_codcamo);

    cursor niv4_cur is select codcamo from centre_activite
       where caniv4 = TO_NUMBER(p_codcamo);

    l_niveau number(1);

    BEGIN

       for niv_rec in niv0_cur loop
           return 0;
       end loop;
       for niv_rec in niv1_cur loop
           return 1;
       end loop;
       for niv_rec in niv2_cur loop
           return 2;
       end loop;
       for niv_rec in niv3_cur loop
           return 3;
       end loop;
       for niv_rec in niv4_cur loop
           return 4;
       end loop;
       
       return 99;

    END recherche_niveau;
    

END pack_suivi_investissement;
/
