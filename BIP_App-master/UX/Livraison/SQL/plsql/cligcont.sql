-- *************************************************************************
-- pack_LigCont PL/SQL
-- *************************************************************************
-- equipe SOPRA
--
-- crée le 18/11/1999
-- Gestion de lignes de contrat
-- Procedures :
--    1. ctrl_RglGestion : Verifie les regles de gestion et retourne des
--            messages si elles ne sont pas repectees.         
--    2. select_forinsert : Retourne certaines informations sur la ressource
--            pour afficher dans la page acligcon.htm permettant la saisie.
--    3. select_LigCont : Retourne les informations a afficher avant une 
--            mise a jour ou une suppression.
--    4. Insert_LigCont : Insert une ligne de contrat.
--    5. update_ligcont : Mise a jour d'une linge de contrat.    
--    6. delete_LigCont : Suppression d'une ligne de contrat.
--
-- *************************************************************************
-- MODIF :
-- 18/01/2000 : Ajout dans ctrl_RglGestion du controle sur l'existance de la
--              prestation dans la table cout_prestation. (PV)
--
-- 03/05/2000 : Accepter les ressources fictives (prestation = 'FIC' dans
--              select_forinsert (AEE)
-- 05/11/2001 : Remplacement de la table cout_prestation par la table prestation
-- 12/03/2003 : ajout de la zone cout propose d'origine    
-- 07/08/2003 :(NBM) modif du mode          
-- 07/04/2008 : TD 607 : fiabilisation EBIS    
--15/05/2008 : ABA TD 607 : modification de la procdure de suppression qui permet d'ajouter dans la table ligne_cont_logs toutes les lignes contrats supprimées       
--29/05/2008 : EVI TD 607 : correction retour fiche 607   
--30/05/2008   ABA : correction point 4 fiche 607 tranformation d'un différent en égal
--02/06/2008   ABA : TD 607 pt 4 ajout du numero d'avenant dans la log
--30/06/2008   ABA : suppression du controle sur les dates pour une prestation de type FIC
-- - 02/07/2008 ( EVI) : TD 644  Test non bloquant pour personne habillité SUPACH
-- - 04/09/2008 ABA : TD 687 ajout user dans log ligne contrat et contrat
---  16/09/2008 ABA TD 674 alerte message  : La situation de la ressource n'a pas de date de fin. Merci de vérifier  lors de la modification d'une ligne contrat
-- 20/04/2009 ABA : TD TD737 augmentation de la taille du numero de contrat + avenant 27+3
-- 29/06/2010 YNI FDT 970
-- 18/07/2010 YNI FDT 970
-- 05/08/2010 YNI FDT 970
-- 06/08/2010 YNI FDT 970
-- 12/08/2010 YNI FDT 970
-- 16/08/2010 YNI FDT 970
-- 24/09/2010 YSB FDT 970
-- Modifiée le 08/10/2010 par ABA Fiche 970
-- Modifiée le 13/01/2011 par ABA Fiche 1095
-- Modifiée le 01/07/2011 par BSA Fiche 1203
-- Modifiée le 25/08/2011 par BSA Fiche 1203
-- *************************************************************************

CREATE OR REPLACE PACKAGE "PACK_LIGCONT" AS

   TYPE LigContRecType IS RECORD (
                               soccont      LIGNE_CONT.soccont%TYPE,  -- char(4)
                               soclib       SOCIETE.soclib%TYPE,
                               numcont      LIGNE_CONT.numcont%TYPE,  -- char(15)
                               cav          LIGNE_CONT.cav%TYPE,      -- char(2)
                               lcnum        LIGNE_CONT.lcnum%TYPE,    -- char(2)
                               ident        VARCHAR2(5),              -- number(5)
                               rnom         RESSOURCE.rnom%TYPE,
                               rprenom      RESSOURCE.rprenom%TYPE,
                               lcprest      LIGNE_CONT.lcprest%TYPE,  -- char(3)
                               lresdeb      VARCHAR2(10),             -- date
                               lresfin      VARCHAR2(10),             -- date
                               cout         VARCHAR2(20), -- number(12.2) table situ_ress
                               lccouact     VARCHAR2(20), -- number(12.2) table contrat
                               proporig     VARCHAR2(20), -- number(10,2) table ligne_cont
                               flaglock     VARCHAR2(20),
                               mode_contractuel_indicatif VARCHAR2(5),
                               lib_mode_contractuel_indicatif VARCHAR2(50),--Mode contractuel indicatif
                               domaine       VARCHAR2(20),
                               rtype      RESSOURCE.rtype%TYPE,
                               code_localisation VARCHAR2(20)
                              );

   TYPE LigContCurType IS REF CURSOR RETURN LigContRecType;

   PROCEDURE ctrl_RglGestion ( p_userid    IN VARCHAR2,
                  p_mode    IN VARCHAR2,
                  p_soccont   IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                  p_numcont   IN LIGNE_CONT.numcont%TYPE,  -- char(15)
                  p_cav       IN LIGNE_CONT.cav%TYPE,      -- char(2)
                  p_lcnum     IN LIGNE_CONT.lcnum%TYPE,      -- char(2)
                  p_lresdeb   IN VARCHAR2,  -- date
                  p_lresfin   IN VARCHAR2,  -- date
                  p_ident     IN NUMBER ,   -- number(5)
                  p_lcprest   IN LIGNE_CONT.lcprest%TYPE, -- char(3)
                  p_message         OUT VARCHAR2
                  );

   PROCEDURE select_forinsert (
                             p_soccont    IN  LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_soclib     IN  SOCIETE.soclib%TYPE,
                             p_numcont    IN  LIGNE_CONT.numcont%TYPE,  -- char(15)
                             p_cav        IN  LIGNE_CONT.cav%TYPE,      -- char(2)
                             p_ident      IN  VARCHAR2,                 -- number(5)
                             p_userid     IN  VARCHAR2,
                             p_soccontOut OUT VARCHAR2,
                             p_soclibOut  OUT VARCHAR2,
                             p_numcontOut OUT VARCHAR2,
                             p_cavOut     OUT VARCHAR2,
                             p_identOut   OUT VARCHAR2,
                             p_rnomOut    OUT VARCHAR2,
                             p_rprenomOut OUT VARCHAR2,
                             p_coutOUT    OUT VARCHAR2,
                             p_modeout    OUT VARCHAR2,
                             p_nbcurseur  OUT INTEGER,
                             p_message    OUT VARCHAR2
                             );

   PROCEDURE select_LigCont (
                             p_mode  IN VARCHAR2,
                             p_soccont      IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_soclib       IN SOCIETE.soclib%TYPE,
                             p_numcont      IN LIGNE_CONT.numcont%TYPE,  -- char(15)
                             p_cav          IN LIGNE_CONT.cav%TYPE,      -- char(2)
                             p_lcnum        IN LIGNE_CONT.lcnum%TYPE,    -- char(2)
                             p_userid       IN VARCHAR2,
                             p_curLigCont   IN OUT LigContCurType,
                             p_nbcurseur       OUT INTEGER,
                             p_message         OUT VARCHAR2
                            );

   PROCEDURE select_LigContAjout (
                             p_soccont      IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_numcont      IN LIGNE_CONT.numcont%TYPE,  -- char(15)
                             p_cav          IN LIGNE_CONT.cav%TYPE,      -- char(2)
                             p_userid       IN VARCHAR2,
                             p_soclib    OUT VARCHAR2 ,
                             p_cdatdeb   OUT VARCHAR2,
                             p_cdatfin   OUT VARCHAR2,
                             p_nbcurseur       OUT INTEGER,
                             p_message         OUT VARCHAR2
                            );

   PROCEDURE Insert_LigCont (
                             p_soccont   IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_soclib    IN SOCIETE.soclib%TYPE,
                             p_numcont   IN LIGNE_CONT.numcont%TYPE,  -- char(15)
                             p_cav       IN LIGNE_CONT.cav%TYPE,      -- char(2)
                             p_lcnum     IN LIGNE_CONT.lcnum%TYPE,    -- char(2)
                             p_ident     IN VARCHAR2,                 -- number(5)
                             p_rnom      IN RESSOURCE.rnom%TYPE,
                             p_rprenom   IN RESSOURCE.rprenom%TYPE,
                             p_lcprest   IN VARCHAR2,  -- char(3)
                             p_lresdeb   IN VARCHAR2,             -- date
                             p_lresfin   IN VARCHAR2,             -- date
                             p_cout      IN VARCHAR2, -- number(12.2) table situ_ress
                             p_lccouact  IN VARCHAR2, -- number(12.2) table contrat
                             p_proporig  IN VARCHAR2, -- number(10,2) table ligne_cont
                             p_modeContractuel IN VARCHAR2,
                             p_userid    IN VARCHAR2,
                             p_nbcurseur       OUT INTEGER,
                             p_message         OUT VARCHAR2
                            ) ;

   PROCEDURE update_ligcont (
                             p_soccont   IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_soclib    IN SOCIETE.soclib%TYPE,
                             p_numcont   IN LIGNE_CONT.numcont%TYPE,  -- char(15)
                             p_cav       IN LIGNE_CONT.cav%TYPE,      -- char(2)
                             p_lcnum     IN LIGNE_CONT.lcnum%TYPE,    -- char(2)
                             p_ident     IN VARCHAR2,                 -- number(5)
                             p_rnom      IN RESSOURCE.rnom%TYPE,
                             p_rprenom   IN RESSOURCE.rprenom%TYPE,
                             p_lcprest   IN VARCHAR2,  -- char(3)
                             p_lresdeb   IN VARCHAR2,             -- date
                             p_lresfin   IN VARCHAR2,             -- date
                             p_coutDsit  IN VARCHAR2, -- number(12.2) table situ_ress
                             p_lccouact  IN VARCHAR2, -- number(12.2) table contrat
                             p_proporig  IN VARCHAR2, -- number(10,2) table ligne_cont
                             p_flaglock  IN VARCHAR2,
                             p_modeContractuel IN VARCHAR2,
                             p_userid    IN VARCHAR2,
                             p_nbcurseur       OUT INTEGER,
                             p_message         OUT VARCHAR2
                            ) ;

   PROCEDURE delete_LigCont (p_soccont   IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_soclib    IN SOCIETE.soclib%TYPE,
                             p_numcont   IN LIGNE_CONT.numcont%TYPE,  -- char(15)
                             p_cav       IN LIGNE_CONT.cav%TYPE,      -- char(2)
                             p_lcnum     IN LIGNE_CONT.lcnum%TYPE,    -- char(2)
                             p_ident     IN VARCHAR2,                 -- number(5)
                             p_rnom      IN RESSOURCE.rnom%TYPE,
                             p_rprenom   IN RESSOURCE.rprenom%TYPE,
                             p_lcprest   IN LIGNE_CONT.lcprest%TYPE,  -- char(3)
                             p_lresdeb   IN VARCHAR2,             -- date
                             p_lresfin   IN VARCHAR2,             -- date
                             p_cout      IN VARCHAR2, -- number(12.2) table situ_ress
                             p_lccouact  IN VARCHAR2, -- number(12.2) table contrat
                             p_proporig  IN VARCHAR2, -- number(10,2) table ligne_cont
                             p_userid    IN VARCHAR2,
                             p_nbcurseur       OUT INTEGER,
                             p_message         OUT VARCHAR2
                            ) ;

PROCEDURE verif_ressource (p_ident      IN VARCHAR2,
                            p_soccont   IN VARCHAR2,
                            p_lresdeb   IN DATE,
                            p_lresfin   IN DATE,
                            p_numcont   IN VARCHAR2,
                            p_cav       IN LIGNE_CONT.cav%TYPE,
                            p_mode IN VARCHAR2,
                            p_rnom      OUT RESSOURCE.rnom%TYPE,
                            p_rprenom   OUT RESSOURCE.rprenom%TYPE,
                            p_rtype     OUT VARCHAR2,
                            p_lcprest   OUT VARCHAR2,
                            p_lcdomaine   OUT PRESTATION.CODE_DOMAINE%TYPE,
                            p_cout      OUT VARCHAR2,
                            p_modeContractuel  IN OUT VARCHAR2,
                            p_libmodeContractuel  OUT VARCHAR2,
                            p_message         OUT VARCHAR2
                            );

PROCEDURE update_modecont_situations ( p_ident IN VARCHAR2,
                                          p_soccont IN VARCHAR2,
                                          p_lresdeb IN DATE,
                                          p_lresfin IN DATE,
                                          p_modeContractuel IN VARCHAR2,
                                          p_user    IN VARCHAR2);

PROCEDURE RECUP_LIB_MC(p_mc        IN    VARCHAR2,
                               p_lib_mc    OUT    VARCHAR2,
                               p_message        OUT     VARCHAR2);

PROCEDURE TEST_PERIODE_RESSOURCES( P_NUMCONT    IN LIGNE_CONT.NUMCONT%TYPE,
                                   P_MODE       IN VARCHAR2,
                                   p_lcnum      IN LIGNE_CONT.LCNUM%TYPE,
                                   p_cav        IN VARCHAR2,
                                   p_message  OUT VARCHAR2 );

PROCEDURE CTRL_PERIODE_CREATION( P_NUMCONT    IN LIGNE_CONT.NUMCONT%TYPE,
                                 p_lcnum      IN LIGNE_CONT.LCNUM%TYPE,
                                 p_resdeb     IN VARCHAR2,
                                 p_resfin     IN VARCHAR2,
                                 p_cav        IN VARCHAR2,
                                 p_ident      IN VARCHAR2,
                                 p_message    OUT VARCHAR2 );

PROCEDURE CTRL_PERIODE_MODIFICATION( P_NUMCONT    IN LIGNE_CONT.NUMCONT%TYPE,
                                     p_lcnum      IN LIGNE_CONT.LCNUM%TYPE,
                                     p_ident      IN VARCHAR2,
                                     p_resdeb     IN VARCHAR2,
                                     p_resfin     IN VARCHAR2,
                                     p_cav        IN VARCHAR2,
                                     p_message    OUT VARCHAR2 );

-- FAD PPM 64360 : Création d'une fonction qui vérifie si le forfait doit être affiché selon les nouvelles règles de gestion
-- FAD PPM 64360 QC 1932 : Modification des paramètres transmis à la fonction, seul le FIDENT est nécessaire.
-- la ligne contrat du forfait lié est incluse dans une seule situation du forfait lié et non dans la situation de la ressource en cours
FUNCTION VERIF_FORFAIT(V_FIDENT IN SITU_RESS.FIDENT%TYPE) RETURN VARCHAR2;
-- FAD PPM 64360 QC 1932 : Fin
-- FAD PPM 64360 : Fin

END  Pack_Ligcont;
/






CREATE OR REPLACE PACKAGE BODY "PACK_LIGCONT" AS

   -- *************************************************************************
   -- ctrl_RglGestion
   -- *************************************************************************
      PROCEDURE ctrl_RglGestion ( p_userid    IN VARCHAR2,
                  p_mode      IN VARCHAR2,
                  p_soccont   IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                  p_numcont   IN LIGNE_CONT.numcont%TYPE,
                  p_cav       IN LIGNE_CONT.cav%TYPE,
                  p_lcnum     IN LIGNE_CONT.lcnum%TYPE,      -- char(2)
                  p_lresdeb   IN VARCHAR2,  -- date
                  p_lresfin   IN VARCHAR2,  -- date
                  p_ident     IN NUMBER ,   -- number(5)
                  p_lcprest   IN LIGNE_CONT.lcprest%TYPE, -- char(3)
                  p_message         OUT VARCHAR2
                            ) IS
      l_msg VARCHAR2(1024);
      l_datdeb DATE;
      l_datfin DATE;
      l_datdebmin DATE;
      l_datfinmax DATE;
      l_codprest LIGNE_CONT.lcprest%TYPE;

      l_count   NUMBER ;
      l_numcont VARCHAR2(27) ;
      l_soccont VARCHAR2(4) ;
      l_cav        VARCHAR2(3);
      l_numligne NUMBER(2) ;
      l_ident SITU_RESS.ident%TYPE;
      l_sousmenus   VARCHAR2(1024);
      l_valide NUMBER(1) ;

      CURSOR cur_situligne IS
          SELECT datsitu, datdep FROM situ_ress
            where ident = to_number(p_ident)
            and trim(soccode) = trim(p_soccont)
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
            order by datsitu asc;

   BEGIN

      -- On r?cup?re le matricule de l'utilisateur
      l_sousmenus := Pack_Global.lire_globaldata(p_userid).sousmenus;
      l_valide := 0;
      /* TD 607: Message d'alerte en cas de situation incoh?rente avec les dates du contrat */
      /*
      BEGIN
          SELECT s.ident
          INTO l_ident
          FROM situ_ress s
          WHERE s.ident = TO_NUMBER(p_ident)
          AND s.datsitu<=p_lresdeb
          AND s.datdep>=p_lresfin;

      EXCEPTION
           WHEN NO_DATA_FOUND THEN

                        --TD 674 alerte message  : La situation de la ressource n'a pas de date de fin. Merci de v?rifier
                         BEGIN
                                 SELECT s.ident
                                 INTO l_ident
                                  FROM situ_ress s
                                  WHERE s.ident = TO_NUMBER(p_ident)
                                    AND s.datsitu<=p_lresdeb
                                  AND s.datdep is null;
                        Pack_Global.recuperer_message( 21140, NULL,NULL,NULL, l_msg);
                        p_message := l_msg;

                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                Pack_Global.recuperer_message( 21073, NULL,NULL,NULL, l_msg);
                                p_message := l_msg;
                        WHEN OTHERS THEN
                                 RAISE_APPLICATION_ERROR( -20997, SQLERRM);
                        END;


      END;
      */

       BEGIN
            select max(datsitu) into l_datdebmin
            from situ_ress
            where ident = to_number(p_ident)
            and trim(soccode) = trim(p_soccont)
            and datsitu <= p_lresdeb;
      EXCEPTION
            WHEN NO_DATA_FOUND THEN
              l_datdebmin := null;
      END;

       FOR one_situligne IN cur_situligne LOOP
          l_datfinmax := one_situligne.datdep;
       END LOOP;


       IF(  l_datdebmin is not null
          and
            l_datfinmax is not null
          and
            l_datdebmin = p_lresdeb
          and
            l_datfinmax = p_lresfin
          ) THEN
          l_valide := 1;
       END IF;


       IF(l_valide != 1) THEN
         FOR one_situligne IN cur_situligne LOOP

                  IF(one_situligne.datsitu < p_lresfin) THEN
                      p_message := p_message ||'\n'|| '            ' || one_situligne.datsitu || ' au ' || one_situligne.datdep;
                  END IF;

         END LOOP;

         IF(p_message is  not null) THEN
           p_message:= 'Attention, la situation de la ressource et la période '  || '\n' ||
                       'de la ligne contrat sont en décalage sur les dates :' || '\n' || '       Situation(s) :' ||'\n'||  p_message;


           p_message:=p_message ||'\n'|| '       Ligne contrat :';
           p_message:=p_message ||'\n'|| '            ' ||   p_lresdeb || ' au ' || p_lresfin;
           p_message:=p_message ||'\n'|| 'Si nécessaire, pensez à mettre en cohérence la situation et/ou la ligne contrat.';
           p_message:=p_message ||'\n';

         END IF;
       END IF;



      -- Cas Creation ou Modification
      IF (p_mode = 'insert') OR (p_mode = 'update') THEN
         -- RG1 : Dates de d?but et de fin de prestation doivent ?tre comprises
         -- entre dates de d?but et de fin de contrat.
         BEGIN
            SELECT c.cdatdeb, c.cdatfin
            INTO   l_datdeb, l_datfin
            FROM   CONTRAT c
            WHERE  c.soccont = p_soccont
              AND  c.numcont = p_numcont
              AND  c.cav = lpad(nvl(p_cav,'0'),3,'0');

         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                   -- Erreur message "Contrat inexistant"
                   Pack_Global.recuperer_message(20280, NULL, NULL, NULL, l_msg);
                   RAISE_APPLICATION_ERROR(-20280,l_msg);
            WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR(-20997,SQLERRM);
         END;


       /*  IF TO_DATE(p_lresdeb,'dd/mm/yyyy') > TO_DATE(p_lresfin,'dd/mm/yyyy') THEN
            -- La date de fin doit ?tre sup?rieure ou ?gale ? la date de d?but

            IF INSTR(l_sousmenus,'supach') >0 THEN
            Pack_Global.recuperer_message(20284, NULL, NULL, NULL, l_msg);
            p_message:=p_message ||'\n'|| l_msg;
            ELSE
            Pack_Global.recuperer_message(20284, NULL, NULL, 'LRESDEB', l_msg);
            RAISE_APPLICATION_ERROR(-20284, l_msg);

            END IF;


         ELSIF  ( TO_DATE(p_lresdeb,'dd/mm/yyyy') < TO_DATE(l_datdeb,'dd/mm/yyyy') ) OR
                ( TO_DATE(p_lresdeb,'dd/mm/yyyy') > TO_DATE(l_datfin,'dd/mm/yyyy') ) OR
                ( TO_DATE(p_lresfin,'dd/mm/yyyy') < TO_DATE(l_datdeb,'dd/mm/yyyy') ) OR
                ( TO_DATE(p_lresfin,'dd/mm/yyyy') > TO_DATE(l_datfin,'dd/mm/yyyy') ) AND
                (p_lcprest <> 'FIC')THEN

            -- message : Dates de d?but et de fin de prestation doivent ?tre comprises
            -- entre dates de d?but et de fin de contrat.
            IF INSTR(l_sousmenus,'supach') >0 THEN
            Pack_Global.recuperer_message(20435, NULL, NULL, NULL, l_msg);
            p_message:=p_message ||'\n'|| l_msg;
            ELSE
            Pack_Global.recuperer_message(20435, NULL, NULL, 'LRESDEB', l_msg);
            RAISE_APPLICATION_ERROR(-20435, l_msg);

            END IF;

         END IF;

     -- TEST sur la validit? de la prestation
     -- Ajout du test sur le type de la prestation pour ne prendre en compte que les hors SG
 /*    BEGIN
        SELECT  PRESTATION
          INTO  l_codprest
          FROM  PRESTATION
          WHERE PRESTATION = p_lcprest
          --YNI FDT 823 ajout du controle de la prestation
          AND (RTYPE='F' OR RTYPE='L' OR RTYPE='P' OR RTYPE='E')
          --Fin YNI FDT 823
          AND   UPPER(top_actif) = 'O';

     EXCEPTION
        WHEN NO_DATA_FOUND THEN
          Pack_Global.recuperer_message(20246, '%s1', p_lcprest, 'LCPREST', l_msg);
        RAISE_APPLICATION_ERROR( -20246, l_msg);
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20997,SQLERRM);
     END;
*/
        -- Rajout contr?le : interdire saisie d'une ressource ?tant d?j? affect?e ? un autre
        -- contrat sur la m?me p?riode
         BEGIN
            -- On autorise la saisie ou modification lors d'une prestastion fictive (FIC)
          IF (p_lcprest <> 'FIC') THEN
             IF  ( p_mode = 'insert' )  THEN
                  SELECT COUNT(*) INTO l_count FROM LIGNE_CONT l WHERE
                  l.ident =p_ident
                  AND ((p_lresdeb >= l.lresdeb AND p_lresfin<=l.lresfin)
                  OR ( p_lresdeb <= l.lresfin AND p_lresfin >= l.lresfin )
                  OR ( p_lresdeb <= l.lresdeb AND p_lresfin>=l.lresdeb));
                 -- Si en mode insert , on ne doit pas trouver de lignes contrat d?j? affect?es ? la ressource
                 -- chevauchant la p?riode que l'on a choisi
                 IF (l_count > 0 ) THEN
                      IF INSTR(l_sousmenus,'supach') >0 THEN
                      Pack_Global.recuperer_message(21071, NULL,NULL,NULL, l_msg);
                      p_message:=p_message ||'\n'|| l_msg;
                      ELSE
                      Pack_Global.recuperer_message(21071, NULL,NULL,NULL, l_msg);
                      RAISE_APPLICATION_ERROR( -20246, l_msg);

                      END IF;
                  END IF ;
                END IF ; -- Fin mode insert

            IF  ( p_mode  = 'update' )  THEN
                        -- on selectionne tout les ligne_cont de la ressource sauf celle en cours d'update
                         SELECT count(*) INTO l_count FROM(
                                        SELECT * FROM LIGNE_CONT l
                                                 WHERE
                                                    l.ident =p_ident
                                                    AND ((p_lresdeb >= l.lresdeb AND p_lresfin<=l.lresfin)
                                                    OR ( p_lresdeb <= l.lresfin AND p_lresfin >= l.lresfin )
                                                    OR ( p_lresdeb <= l.lresdeb AND p_lresfin>=l.lresdeb))
                                        MINUS
                                        SELECT * from LIGNE_CONT l
                                                WHERE trim(l.numcont)= trim(p_numcont)
                                                    AND trim(l.soccont)=trim(p_soccont)
                                                    AND trim(l.cav)=trim(lpad(nvl(p_cav,'0'),3,'0'))
                                                    AND trim(l.lcnum)=trim(p_lcnum)
                                              );
                         -- mode update : on ne doit pas trouver de lignes contrat d?j? affect?es ? la ressource
                         -- chevauchant la p?riode que l'on a choisi
                         -- attention : on exclu la ligne que l'on est en train de modifier
                         IF (l_count > 0 ) THEN

                              IF INSTR(l_sousmenus,'supach') >0 THEN
                              Pack_Global.recuperer_message(21071, NULL,NULL,NULL, l_msg);
                              p_message:=p_message ||'\n'|| l_msg;
                              ELSE
                              Pack_Global.recuperer_message(21071, NULL,NULL,NULL, l_msg);
                              RAISE_APPLICATION_ERROR( -20246, l_msg);

                              END IF;

                  END IF ;
                END IF ; -- Fin mode insert
                  --EXCEPTION
          END IF;        --    RAISE_APPLICATION_ERROR(-20997,SQLERRM);
            END ;
      END IF; -- Fin de Cas Creation ou Modification
   END ctrl_RglGestion;

   -- *************************************************************************
   -- select_forinsert
   -- *************************************************************************
   PROCEDURE select_forinsert (
                             p_soccont    IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_soclib     IN SOCIETE.soclib%TYPE,
                             p_numcont    IN LIGNE_CONT.numcont%TYPE,
                             p_cav        IN LIGNE_CONT.cav%TYPE,
                             p_ident      IN VARCHAR2,                 -- number(5)
                             p_userid     IN VARCHAR2,
                             p_soccontOut OUT VARCHAR2,
                             p_soclibOut  OUT VARCHAR2,
                             p_numcontOut OUT VARCHAR2,
                             p_cavOut     OUT VARCHAR2,
                             p_identOut   OUT VARCHAR2,
                             p_rnomOut    OUT VARCHAR2,
                             p_rprenomOut OUT VARCHAR2,
                             p_coutOUT    OUT VARCHAR2,
                             p_modeout    OUT VARCHAR2,
                             p_nbcurseur  OUT INTEGER,
                             p_message    OUT VARCHAR2
                             ) IS

      l_msg        VARCHAR2(1024);
      l_rnom       RESSOURCE.rnom%TYPE;
      l_rprenom    RESSOURCE.rprenom%TYPE;
      l_cout       SITU_RESS.cout%TYPE;
      l_ident      RESSOURCE.ident%TYPE;
      l_datsitu    DATE;
      -- TD 607 point 2
      l_crtype VARCHAR2(2);
      l_rtype VARCHAR2(2);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      p_soccontOut :=  p_soccont;
      p_soclibOut  :=  p_soclib;
      p_numcontOut :=  p_numcont;
      p_cavOut     :=  p_cav;
      p_identOut      :=  p_ident;

      -- Test de l'existance de ressource et recherche de son nom
      BEGIN
         SELECT rnom, rprenom
         INTO   l_rnom, l_rprenom
         FROM   RESSOURCE
         WHERE  ident = TO_NUMBER(p_ident);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            -- Message : Code ressource inexistant
            Pack_Global.recuperer_message(20437, '%s1', p_ident, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20437, l_msg);
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;


      -- Test d'appartenance de la ressource à la societe,
      -- Si la prestation
      l_cout:=0;
      BEGIN
       SELECT sr.ident, sr.datsitu, sr.cout
         INTO     l_ident, l_datsitu, l_cout
        FROM   SITU_RESS sr, RESSOURCE r
        WHERE  sr.ident = r.ident
           AND    (sr.ident, sr.datsitu) = (SELECT ident, MAX(datsitu)
                                          FROM SITU_RESS
                                          WHERE ident = TO_NUMBER(p_ident)
                                          AND (trim(soccode) = trim(p_soccont)
                                               OR UPPER(PRESTATION) = 'FIC')
                                          GROUP BY ident
                                          );
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            -- Message : La ressource %s1 n'appartient pas à la société %s2.
            Pack_Global.recuperer_message(20438, '%s1', p_ident, '%s2', p_soccont, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20438, l_msg);
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;


      -- TD 607 point 2: on interdit dans un meme contrat des ressources de type différent
      BEGIN
       -- on recupere le type de la premiere ressource attaché a ce le contrat
       SELECT r.RTYPE INTO l_crtype
       FROM RESSOURCE r, LIGNE_CONT l
       WHERE r.IDENT=l.IDENT
             AND trim(l.numcont)= trim(p_numcont)
             AND trim(l.soccont)=trim(p_soccont)
             AND trim(l.cav)=trim(lpad(nvl(p_cav,'0'),3,'0'))
             AND rownum=1;
       -- on recupere le type de la ressource que nous voulons ajouter
       SELECT r.RTYPE INTO l_rtype
       FROM RESSOURCE r
       WHERE r.IDENT=p_ident;

             -- si il existe deja une ressource attache au contrat
        IF (l_crtype IS NOT NULL)  THEN
         -- si l'ancienne ressource est de type P et la nouvelle de tpe F ou E
         IF (l_crtype = 'P') AND (l_rtype = 'F' OR l_rtype = 'E') THEN
                      Pack_Global.recuperer_message(21072,NULL,NULL,NULL, l_msg);
                      RAISE_APPLICATION_ERROR( -20246, l_msg);
          END IF;

         IF (l_rtype = 'P') AND (l_crtype = 'F' OR l_crtype = 'E')THEN
                      Pack_Global.recuperer_message(21072,NULL, NULL,NULL, l_msg);
                      RAISE_APPLICATION_ERROR( -20246, l_msg);
         END IF;

        END IF;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- si il n'y a aucune ligne contrat on recupere le type de la ressource que nous voulons crrer
                SELECT r.RTYPE INTO l_crtype
                FROM RESSOURCE r
                WHERE r.IDENT=p_ident;
                  --RAISE_APPLICATION_ERROR(-20997,SQLERRM);
      END ;

      p_rnomOut :=  l_rnom;
      p_rprenomOut := l_rprenom;
      p_modeout := 'insert';
      p_coutOut :=  TO_CHAR(l_cout,'FM9999999999D00');

   END select_forinsert;


   -- *************************************************************************
   -- select_LigCont
   -- *************************************************************************
   PROCEDURE select_LigCont (
                             p_mode IN VARCHAR2,
                             p_soccont     IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_soclib      IN SOCIETE.soclib%TYPE,
                             p_numcont     IN LIGNE_CONT.numcont%TYPE,
                             p_cav         IN LIGNE_CONT.cav%TYPE,
                             p_lcnum       IN LIGNE_CONT.lcnum%TYPE,    -- char(2)
                             p_userid      IN VARCHAR2,
                             p_curLigCont  IN OUT LigContCurType,
                             p_nbcurseur      OUT INTEGER,
                             p_message        OUT VARCHAR2
                            ) IS

      l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      BEGIN
            OPEN p_curLigCont FOR
               SELECT l.soccont,
                      s.soclib,
                      l.numcont,
                      decode(c.top30,'N',substr(l.cav,2,2),'O',decode(l.cav,'000','',l.cav)),
                      l.lcnum,
                      TO_CHAR(l.ident,'FM99999'),
                      r.rnom,
                      r.rprenom,
                      sr.prestation,
                      TO_CHAR(l.lresdeb,'dd/mm/yyyy'),
                      TO_CHAR(l.lresfin,'dd/mm/yyyy'),
                      TO_CHAR(sr.cout,'FM9999999999D00'),
                      TO_CHAR(l.lccouact,'FM9999999999D00'),
                      TO_CHAR(NVL(l.proporig,0),'FM9999990D00'),
                      TO_CHAR(c.flaglock),
                      --sr.mode_contractuel_indicatif,
                      l.mode_contractuel,
                      mc.libelle,
                      --RPAD(NVL((select dom.lib_domaine from prestation pr, type_domaine dom where pr.prestation = l.lcprest and pr.code_domaine = dom.code_domaine), ' '), 5, ' '),
                      RPAD(NVL((select pr.code_domaine from prestation pr where pr.prestation = sr.prestation), ' '), 5, ' '),
                      r.rtype,
                      mc.CODE_LOCALISATION
              FROM    LIGNE_CONT l, CONTRAT c,SOCIETE s, RESSOURCE r,
                      SITU_RESS sr, mode_contractuel mc
              WHERE   c.soccont = l.soccont
                AND   c.numcont = l.numcont
                AND   c.cav = l.cav
                -- YNI FDT 970
                --AND   c.siren = pack_consult_ress.get_siren(sr.soccode)
                AND   l.mode_contractuel = mc.code_contractuel(+)
                -- Fin YNI FDT 970
                AND   l.ident = r.ident
                AND   r.ident = sr.ident
                AND   l.soccont = p_soccont
                AND   l.numcont = p_numcont
                AND   l.cav = lpad(nvl(p_cav,'0'),3,'0')
                AND   l.lcnum = p_lcnum
                AND   trim(s.soccode) = trim(p_soccont)
                AND   (sr.ident, sr.datsitu) = (SELECT ident, MAX(datsitu)
                                                FROM SITU_RESS
                                                WHERE ident = TO_NUMBER(r.ident)
                                                GROUP BY ident
                                                );
      EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 Pack_Global.recuperer_message(20997, NULL, NULL, NULL, l_msg);
                 p_message := l_msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20997,SQLERRM);
      END; -- fin de select

 -- dbms_output.put_line('lcnum = ' || p_lcnum);
   END select_LigCont;

PROCEDURE select_LigContAjout (
                             p_soccont      IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_numcont      IN LIGNE_CONT.numcont%TYPE,
                             p_cav          IN LIGNE_CONT.cav%TYPE,
                             p_userid       IN VARCHAR2,
                             p_soclib    OUT VARCHAR2 ,
                              p_cdatdeb   OUT VARCHAR2,
                             p_cdatfin   OUT VARCHAR2,
                             p_nbcurseur       OUT INTEGER,
                             p_message         OUT VARCHAR2
                            )IS

      l_msg VARCHAR2(1024);
      l_ssmenu VARCHAR2(1024);
      l_presence NUMBER;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;

      -- on recupère le sous menu de l'utilisateur
      l_ssmenu := Pack_Global.lire_globaldata(p_userid).sousmenus;

     BEGIN
            SELECT s.soclib INTO p_soclib
            FROM    SOCIETE s
              WHERE trim(s.soccode) = trim(p_soccont)
                ;
      END; -- fin de select

     IF (instr(l_ssmenu,'ach30') > 0) THEN
         BEGIN
                        SELECT 1,to_char(cdatdeb,'DD/MM/YYYY'), to_char(cdatfin,'DD/MM/YYYY')
                        INTO l_presence, p_cdatdeb, p_cdatfin
                        FROM CONTRAT
                        WHERE      numcont = p_numcont
                        AND    soccont = p_soccont
                        AND    cav     = lpad(nvl(p_cav,'0'),3,'0')
                        and top30 = 'O';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 Pack_Global.recuperer_message(21149, NULL, NULL, NULL, l_msg);
                 p_message := l_msg;
         END;
     ELSE
        BEGIN
                          SELECT 1,to_char(cdatdeb,'DD/MM/YYYY'), to_char(cdatfin,'DD/MM/YYYY')
                        INTO l_presence, p_cdatdeb, p_cdatfin
                        FROM CONTRAT
                        WHERE      numcont = p_numcont
                        AND    soccont = p_soccont
                        AND    cav     = lpad(nvl(p_cav,'0'),3,'0')
                        and top30 = 'N';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 Pack_Global.recuperer_message(21150, NULL, NULL, NULL, l_msg);
                 p_message := l_msg;
         END;
     END IF;




   END select_LigContAjout;

   -- *************************************************************************
   -- Insert_LigCont
   -- *************************************************************************
   PROCEDURE Insert_LigCont (p_soccont   IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_soclib    IN SOCIETE.soclib%TYPE,
                             p_numcont   IN LIGNE_CONT.numcont%TYPE,  -- char(15)
                             p_cav       IN LIGNE_CONT.cav%TYPE,      -- char(2)
                             p_lcnum     IN LIGNE_CONT.lcnum%TYPE,    -- char(2)
                             p_ident     IN VARCHAR2,                 -- number(5)
                             p_rnom      IN RESSOURCE.rnom%TYPE,
                             p_rprenom   IN RESSOURCE.rprenom%TYPE,
                             p_lcprest   IN VARCHAR2,  -- char(3)
                             p_lresdeb   IN VARCHAR2,             -- date
                             p_lresfin   IN VARCHAR2,             -- date
                             p_cout      IN VARCHAR2, -- number(12.2) table situ_ress
                             p_lccouact  IN VARCHAR2, -- number(12.2) table contrat
                             p_proporig  IN VARCHAR2, -- number(10,2) table ligne_cont
                             p_modeContractuel IN VARCHAR2,
                             p_userid    IN VARCHAR2,
                             p_nbcurseur       OUT INTEGER,
                             p_message         OUT VARCHAR2
                            ) IS
   l_msg VARCHAR2(1024);
   l_nblcnum LIGNE_CONT.lcnum%TYPE;
   l_rtype VARCHAR2(5);
   l_codCont VARCHAR2(5);
   l_user        CONTRATS_LOGS.user_log%TYPE;

    l_rnom       RESSOURCE.rnom%TYPE;
    l_rprenom    RESSOURCE.rprenom%TYPE;
    l_cout       VARCHAR2(50);
    l_ident      VARCHAR2(10);
    l_datsitu    DATE;
    l_crtype VARCHAR2(2);
    l_lcdomaine VARCHAR2(2);
    l_lcprest VARCHAR2(5);
    l_modeContractuel VARCHAR2(5);
    l_libmodeContractuel VARCHAR2(50);
    l_ress_type VARCHAR2(2);
    l_soccode VARCHAR2(10);
    l_ctype_fact VARCHAR2(2);

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';

      -- On récupère le matricule de l'utilisateur
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

        -- Mode contractuel (autre que XXX ou ???) devra être ACTIF, cohérent avec le Type de facturation du contrat,
        -- et avec le Type de ressource de la ressource
          BEGIN
          SELECT cont.ctypfact INTO l_ctype_fact
           FROM CONTRAT cont
           WHERE trim(cont.numcont)= trim(p_numcont)
             AND trim(cont.soccont)= trim(p_soccont)
             AND trim(cont.cav)=trim(lpad(nvl(p_cav,'0'),3,'0'));
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
              RAISE_APPLICATION_ERROR( -20999, l_msg );
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;

          BEGIN
            select trim(soccode) into l_soccode
            from situ_ress
            where ident = to_number(p_ident)
            and rownum = 1
            order by datsitu desc;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
              RAISE_APPLICATION_ERROR( -20999, l_msg );
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;

          BEGIN
            select rtype into l_rtype
            from ressource
            where ident = to_number(p_ident);
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
              RAISE_APPLICATION_ERROR( -20999, l_msg );
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;

          -- mode contractuel est obligatoire
          IF(p_modeContractuel is null) THEN
              Pack_Global.recuperer_message( 21191, NULL, NULL, NULL, l_msg);
              RAISE_APPLICATION_ERROR( -20999, l_msg );
          END IF;

          BEGIN
            SELECT     libelle INTO l_libModeContractuel
              FROM  MODE_CONTRACTUEL
              WHERE code_contractuel = p_modeContractuel;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message( 21191, NULL, NULL, NULL, l_msg);
              RAISE_APPLICATION_ERROR( -20999, l_msg );
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;

          IF(l_ctype_fact = 'M' or l_ctype_fact = 'R') THEN
            IF(l_soccode <> 'SG..' and l_rtype = 'P') THEN
              BEGIN
                SELECT     code_contractuel INTO l_codCont
                  FROM  MODE_CONTRACTUEL
                  WHERE code_contractuel = trim(p_modeContractuel)
                  AND type_ressource = l_rtype
                  AND code_contractuel not in ('???','XXX')
                  AND TOP_ACTIF = 'O';
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
                  RAISE_APPLICATION_ERROR( -20999, l_msg );
                WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
              END;
            ELSE
                  Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
                  RAISE_APPLICATION_ERROR( -20999, l_msg );
            END IF;
          ELSIF(l_ctype_fact = 'F') THEN
            IF((l_rtype = 'E') or (l_rtype = 'F')) THEN

              BEGIN
                  SELECT     code_contractuel INTO l_codCont
                  FROM  MODE_CONTRACTUEL
                  WHERE code_contractuel = p_modeContractuel
                  AND type_ressource = l_rtype
                  AND code_contractuel not in ('???','XXX')
                  AND TOP_ACTIF = 'O';
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
                    RAISE_APPLICATION_ERROR( -20999, l_msg );
                  WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
              END;
           end if;
          ELSE
            Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20999, l_msg );
        END IF;

      verif_ressource (p_ident, p_soccont, p_lresdeb, p_lresfin, p_numcont, p_cav,'insert', l_rnom, l_rprenom, l_rtype, l_lcprest, l_lcdomaine, l_cout, l_modeContractuel, l_libmodeContractuel, p_message);
      IF(p_message is not null  ) THEN
        RAISE_APPLICATION_ERROR( -20999, p_message);
      END IF;
      ctrl_RglGestion (p_userid,'insert',p_soccont,p_numcont,p_cav,p_lcnum, p_lresdeb,p_lresfin,TO_NUMBER(p_ident), p_lcprest,   p_message);

      -- lcnum est partie de la clé de la table ligne_cont.
      -- Pour inserer une nouvelle ligne, on prend le dernier lcnum de la societe
      -- et on y ajoute 1.
      /*BEGIN
         SELECT MAX(l.lcnum)      -- S'il ne trouve pas la function d'agregat
         INTO   l_maxlcnum        -- empeche le leve de l'exception when no data found.
         FROM   LIGNE_CONT l
         WHERE  l.soccont = p_soccont
           AND  l.numcont = RPAD(p_numcont,15)
           AND  l.cav = p_cav;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;*/

      -- Fiche 607: fiabilisation expense
      -- Désormais on recupere le nombre de ligne contrat qui a été ajouté sur le contrat

      BEGIN
        SELECT NBLCNUM
        INTO l_nblcnum
        FROM contrat c
        where c.SOCCONT=p_soccont
            AND c.numcont=p_numcont
            AND c.cav = lpad(nvl(p_cav,'0'),3,'0');
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- Fiche 970: recuperation du type ressource
      BEGIN
        SELECT r.rtype
        INTO l_rtype
        FROM ressource r
        WHERE r.ident = TO_NUMBER(p_ident);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      BEGIN
       INSERT INTO LIGNE_CONT(soccont,
                              numcont,
                              cav,
                              lcnum,
                              ident,
                              --lcprest, Fiche 970 : pas besoin de stocker le code prestaion ,ce dernier est récuperer de la situation
                              lresdeb,
                              lresfin,
                              lccouact,
                              lccouinit,
                              lfraisdep,  -- char(1)
                              lastreinte, -- char(1)
                              lheursup,   -- char(1)
                              lcdatact,    -- date
                              proporig,
                              mode_contractuel
                             )
         VALUES (p_soccont,
                 p_numcont,
                 lpad(nvl(p_cav,'0'),3,'0'),
                 l_nblcnum + 1,
                 TO_NUMBER(p_ident),
                 --p_lcprest,
                 TO_DATE(p_lresdeb,'dd/mm/yyyy'),
                 TO_DATE(p_lresfin,'dd/mm/yyyy'),
                 TO_NUMBER(p_lccouact),
                 TO_NUMBER(p_lccouact),
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 TO_NUMBER(p_proporig),
                 p_modeContractuel
                );
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN

            -- Ligne contrat déjà existant
            Pack_Global.recuperer_message(20436,NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20436 , l_msg );

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;  -- fin d'insert

      IF SQL%NOTFOUND THEN
         -- Accès concurrent sur les mêmes données,\nveuillez recharger vos données
         Pack_Global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
         -- Ligne contrat %s1 créee pour le contrat %s2
         Pack_Global.recuperer_message(4004,'%s1',l_nblcnum + 1,'%s2',p_numcont, NULL, l_msg);
         p_message :=p_message ||'\n'|| l_msg;
         --Tracabilite des champs ayant subis des chagements
         Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), null, l_nblcnum + 1, l_user, 'LIGNE_CONT', 'lresdeb', null, TO_DATE(p_lresdeb,'dd/mm/yyyy'),null,null,3, 'Creation de la ligne contrat');
         Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), null, l_nblcnum + 1, l_user, 'LIGNE_CONT', 'lresfin', null, TO_DATE(p_lresfin,'dd/mm/yyyy'),null,null,3, 'Creation de la ligne contrat');
         Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), null, l_nblcnum + 1, l_user, 'LIGNE_CONT', 'ident', null, TO_NUMBER(p_ident),null,null,3, 'Creation de la ligne contrat');
         Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), null, l_nblcnum + 1, l_user, 'LIGNE_CONT', 'mode_contractuel', null, p_modeContractuel,null,null,3, 'Creation de la ligne contrat');

      END IF;
      --mise a jour du mode contractuel des situations
      Pack_ligcont.update_modecont_situations (p_ident ,p_soccont,p_lresdeb,p_lresfin,p_modeContractuel ,l_user);


   END insert_LigCont;

-- *************************************************************************
-- update_ligcont
-- *************************************************************************
   PROCEDURE update_ligcont (
                             p_soccont   IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_soclib    IN SOCIETE.soclib%TYPE,
                             p_numcont   IN LIGNE_CONT.numcont%TYPE,
                             p_cav       IN LIGNE_CONT.cav%TYPE,
                             p_lcnum     IN LIGNE_CONT.lcnum%TYPE,    -- char(2)
                             p_ident     IN VARCHAR2,                 -- number(5)
                             p_rnom      IN RESSOURCE.rnom%TYPE,
                             p_rprenom   IN RESSOURCE.rprenom%TYPE,
                             p_lcprest   IN VARCHAR2,  -- char(3)
                             p_lresdeb   IN VARCHAR2,             -- date
                             p_lresfin   IN VARCHAR2,             -- date
                             p_coutDsit  IN VARCHAR2, -- number(12.2) table situ_ress
                             p_lccouact  IN VARCHAR2, -- number(12.2) table contrat
                             p_proporig  IN VARCHAR2, -- number(10,2) table ligne_cont
                             p_flaglock  IN VARCHAR2,
                             p_modeContractuel IN VARCHAR2,
                             p_userid    IN VARCHAR2,
                             p_nbcurseur       OUT INTEGER,
                             p_message         OUT VARCHAR2
                            ) IS



      l_msg VARCHAR2(1024);
      l_filcode FILIALE_CLI.filcode%TYPE;
      l_topfer  STRUCT_INFO.topfer%TYPE;
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);
      l_user        CONTRATS_LOGS.user_log%TYPE;
      l_codCont VARCHAR2(5);

      old_ident VARCHAR2(30);
      old_lresdeb VARCHAR2(30);
      old_lresfin VARCHAR2(30);
      old_mode_contractuel VARCHAR2(5);

      l_rnom       RESSOURCE.rnom%TYPE;
      l_rprenom    RESSOURCE.rprenom%TYPE;
      l_cout       SITU_RESS.cout%TYPE;
      l_ident      RESSOURCE.ident%TYPE;
      l_datsitu    DATE;
      l_crtype VARCHAR2(2);
      l_lcdomaine VARCHAR2(2);
      l_rtype VARCHAR2(5);
      l_lcprest VARCHAR2(5);
      l_modeContractuel VARCHAR2(5);
      l_libmodeContractuel VARCHAR2(50);
      l_ress_type VARCHAR2(2);
      l_soccode VARCHAR2(10);
      l_ctype_fact VARCHAR2(2);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';
      l_rnom := p_rnom;
      l_rprenom := p_rprenom;
      l_lcprest := p_lcprest;
      l_modeContractuel :=  p_modeContractuel;

      -- On récupère le matricule de l'utilisateur
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      -- Mode contractuel (autre que XXX ou ???) devra être ACTIF, cohérent avec le Type de facturation du contrat,
      -- et avec le Type de ressource de la ressource
      BEGIN
          SELECT cont.ctypfact INTO l_ctype_fact
           FROM CONTRAT cont
           WHERE trim(cont.numcont)= trim(p_numcont)
             AND trim(cont.soccont)= trim(p_soccont)
             AND trim(cont.cav)=trim(lpad(nvl(p_cav,'0'),3,'0'));
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
              RAISE_APPLICATION_ERROR( -20999, l_msg );
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;

          BEGIN
            select trim(soccode) into l_soccode
            from situ_ress
            where ident = to_number(p_ident)
            and rownum = 1
            order by datsitu desc;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
              RAISE_APPLICATION_ERROR( -20999, l_msg );
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;

          BEGIN
            select rtype into l_rtype
            from ressource
            where ident = to_number(p_ident);
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
              RAISE_APPLICATION_ERROR( -20999, l_msg );
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;

          -- mode contractuel est obligatoire
          IF(p_modeContractuel is null) THEN
              Pack_Global.recuperer_message( 21191, NULL, NULL, NULL, l_msg);
              RAISE_APPLICATION_ERROR( -20999, l_msg );
          END IF;

          BEGIN
            SELECT     libelle INTO l_libModeContractuel
              FROM  MODE_CONTRACTUEL
              WHERE code_contractuel = p_modeContractuel;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message( 21191, NULL, NULL, NULL, l_msg);
              RAISE_APPLICATION_ERROR( -20999, l_msg );
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
          END;

          IF(l_ctype_fact = 'M' or l_ctype_fact = 'R') THEN
            IF(l_soccode <> 'SG..' and l_rtype = 'P') THEN
              BEGIN
                SELECT     code_contractuel INTO l_codCont
                  FROM  MODE_CONTRACTUEL
                  WHERE code_contractuel = trim(p_modeContractuel)
                  AND type_ressource = l_rtype
                  AND code_contractuel not in ('???','XXX')
                  AND TOP_ACTIF = 'O';
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
                  RAISE_APPLICATION_ERROR( -20999, l_msg );
                WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
              END;
            ELSE
                  Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
                  RAISE_APPLICATION_ERROR( -20999, l_msg );
            END IF;
          ELSIF(l_ctype_fact = 'F') THEN
                BEGIN
                  SELECT     code_contractuel INTO l_codCont
                  FROM  MODE_CONTRACTUEL
                  WHERE code_contractuel = p_modeContractuel
                  AND type_ressource = l_rtype
                  AND code_contractuel not in ('???','XXX')
                  AND TOP_ACTIF = 'O';
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
                    RAISE_APPLICATION_ERROR( -20999, l_msg );
                  WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
                END;

          ELSE
            Pack_Global.recuperer_message( 21200, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20999, l_msg );
        END IF;

      verif_ressource (p_ident, p_soccont, p_lresdeb, p_lresfin, p_numcont, p_cav,'update', l_rnom, l_rprenom, l_rtype, l_lcprest, l_lcdomaine, l_cout, l_modeContractuel, l_libmodeContractuel, p_message);
      IF(p_message is not null  ) THEN
        RAISE_APPLICATION_ERROR( -20999, p_message);
      END IF;
      ctrl_RglGestion (p_userid,'update',p_soccont,p_numcont,p_cav,p_lcnum, p_lresdeb,p_lresfin,p_ident,  p_lcprest,  p_message);

      -- Fiche 970: recuperation du type ressource
      BEGIN
        SELECT r.rtype
        INTO l_rtype
        FROM ressource r
        WHERE r.ident = TO_NUMBER(p_ident);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

       -- Selection des anciennes valeurs
       BEGIN
         SELECT ident, lresdeb, lresfin, mode_contractuel
         INTO old_ident, old_lresdeb, old_lresfin, old_mode_contractuel
         FROM LIGNE_CONT
         WHERE soccont = p_soccont
         AND   numcont = p_numcont
         AND   cav     = lpad(nvl(p_cav,'0'),3,'0')
         AND   lcnum   = p_lcnum;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            null;
       END;


      -- UPDATE ligne contrat
      BEGIN
         UPDATE LIGNE_CONT
         SET --lcprest  = p_lcprest, --Fiche 970 : pas besoin de stocker le code prestaion ,ce dernier est récuperer de la situation
             lresdeb  = TO_DATE(p_lresdeb, 'DD/MM/YYYY'),
             lresfin  = TO_DATE(p_lresfin, 'DD/MM/YYYY'),
             lccouact = TO_NUMBER(p_lccouact),
             proporig = TO_NUMBER(p_proporig),
             ident = TO_NUMBER(p_ident),
             mode_contractuel = p_modeContractuel
         WHERE soccont = p_soccont
         AND   numcont = p_numcont
         AND   cav     = lpad(nvl(p_cav,'0'),3,'0')
         AND   lcnum   = p_lcnum;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20997, SQLERRM);
      END;


      IF SQL%NOTFOUND THEN
         -- Accès concurrent sur les mêmes données,\nveuillez recharger vos données
         Pack_Global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
         -- 'Ligne contrat %s1 modifiée pour le contrat %s2'
         Pack_Global.recuperer_message(4003,'%s1',p_lcnum,'%s2',p_numcont, NULL, l_msg);
         p_message :=p_message ||'\n'|| l_msg;

         --Tracabilite des champs ayant subis des chagements
         Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), null, p_lcnum, l_user, 'LIGNE_CONT', 'lresdeb', TO_DATE(old_lresdeb,'dd/mm/yyyy'), TO_DATE(p_lresdeb,'dd/mm/yyyy'),null,null,3, 'Modification de la ligne contrat');
         Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), null, p_lcnum, l_user, 'LIGNE_CONT', 'lresfin', TO_DATE(old_lresfin,'dd/mm/yyyy'), TO_DATE(p_lresfin,'dd/mm/yyyy'),null,null,3, 'Modification de la ligne contrat');
         Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), null, p_lcnum, l_user, 'LIGNE_CONT', 'ident', TO_NUMBER(old_ident), TO_NUMBER(p_ident),null,null,3, 'Modification de la ligne contrat');
         Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), null, p_lcnum, l_user, 'LIGNE_CONT', 'mode_contractuel', old_mode_contractuel, p_modeContractuel,null,null,3, 'Modification de la ligne contrat');
         --Modification du mode contractuel de la situation
         --mise a jour du mode contractuel des situations
         Pack_ligcont.update_modecont_situations (p_ident, p_soccont, p_lresdeb, p_lresfin, p_modeContractuel, l_user);



      END IF;

   END update_ligcont;
   -- *************************************************************************
   -- delete_LigCont
   -- *************************************************************************
      PROCEDURE delete_LigCont (
                             p_soccont   IN LIGNE_CONT.soccont%TYPE,  -- char(4)
                             p_soclib    IN SOCIETE.soclib%TYPE,
                             p_numcont   IN LIGNE_CONT.numcont%TYPE,
                             p_cav       IN LIGNE_CONT.cav%TYPE,
                             p_lcnum     IN LIGNE_CONT.lcnum%TYPE,    -- char(2)
                             p_ident     IN VARCHAR2,                 -- number(5)
                             p_rnom      IN RESSOURCE.rnom%TYPE,
                             p_rprenom   IN RESSOURCE.rprenom%TYPE,
                             p_lcprest   IN LIGNE_CONT.lcprest%TYPE,  -- char(3)
                             p_lresdeb   IN VARCHAR2,             -- date
                             p_lresfin   IN VARCHAR2,             -- date
                             p_cout      IN VARCHAR2, -- number(12.2) table situ_ress
                             p_lccouact  IN VARCHAR2, -- number(12.2) table contrat
                             p_proporig  IN VARCHAR2, -- number(10,2) table ligne_cont
                             p_userid    IN VARCHAR2,
                             p_nbcurseur       OUT INTEGER,
                             p_message         OUT VARCHAR2
                            ) IS

    l_msg VARCHAR2(1024);
    referential_integrity EXCEPTION;
    PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

    l_codperim DIRECTIONS.CODPERIM%TYPE;
    l_numcont CONTRAT.NUMCONT%TYPE;
    l_codref DIRECTIONS.CODREF%TYPE;
    l_code_fournisseur_ebis EBIS_FOURNISSEURS.CODE_FOURNISSEUR_EBIS%TYPE;
    l_codsg number(7);
    l_presence char;
    l_user        CONTRATS_LOGS.user_log%TYPE;

    BEGIN
        -- Positionner le nb de curseurs ==> 0
        -- Initialiser le message retour

        p_nbcurseur := 0;
        p_message := '';
        -- On récupère le matricule de l'utilisateur
        l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);


    -- BSA  QC 1125 16/05/2011
    BEGIN
   
        SELECT  fac.numcont
            INTO  l_numcont
        FROM  FACTURE fac, LIGNE_FACT l
        WHERE fac.NUMFACT = l.NUMFACT
            AND fac.numcont = p_numcont
            AND fac.soccont = p_soccont
            AND l.IDENT = p_ident
            AND fac.cav     = lpad(nvl(p_cav,'0'),3,'0')
            AND ROWNUM < 2;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL; -- Il n'existe pas de facture avec ce numero de contrat/avenant
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR( -20997, SQLERRM );
    END;

    IF l_numcont IS NOT NULL THEN
        Pack_Global.recuperer_message(20300 ,NULL, NULL, NULL, l_msg);
        RAISE_APPLICATION_ERROR( -20300, l_msg );
    END IF;

    -- Fin 1125

    BEGIN

       DELETE FROM LIGNE_CONT l
       WHERE l.soccont=p_soccont
           AND l.numcont=p_numcont
           AND l.cav=lpad(nvl(p_cav,'0'),3,'0')
           AND l.lcnum=p_lcnum;
          
    EXCEPTION
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20997, SQLERRM);
    END;


    IF SQL%NOTFOUND THEN
       -- Accès concurrent sur les mêmes données,\nveuillez recharger vos données
       Pack_Global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
       RAISE_APPLICATION_ERROR( -20999, l_msg );
    ELSE
       -- TD 607 LOGS la suppression de ligne contrat
       -- 1. on recupere les info sur le contrat et la ressource


        BEGIN
             select '1' into l_presence from ebis_fournisseurs e, contrat c, directions d, struct_info s
               where c.codsg = s.codsg
               and s.coddir = d.coddir
               and c.siren = e.siren
               and e.referentiel = d.codref
               and e.perimetre = d.CODPERIM
               and  c.SOCCONT= p_soccont
               AND c.NUMCONT= p_numcont
               AND c.CAV = lpad(nvl(p_cav,'0'),3,'0');

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                SELECT d.CODPERIM, c.NUMCONT, d.CODREF, null, c.codsg
                     INTO l_codperim,l_numcont,l_codref,l_code_fournisseur_ebis, l_codsg
                FROM DIRECTIONS d, STRUCT_INFO s, CONTRAT c
                WHERE c.SOCCONT= p_soccont
                    AND c.NUMCONT= p_numcont
                    AND c.CAV = lpad(nvl(p_cav,'0'),3,'0')
                    AND c.CODSG=s.CODSG
                    AND s.CODDIR=d.CODDIR;

        END;
       
        IF l_presence = '1' THEN
       
            SELECT d.CODPERIM, c.NUMCONT, d.CODREF, e.CODE_FOURNISSEUR_EBIS, c.codsg
                INTO l_codperim,l_numcont,l_codref,l_code_fournisseur_ebis, l_codsg
            FROM DIRECTIONS d, STRUCT_INFO s, CONTRAT c, EBIS_FOURNISSEURS e
            WHERE c.SOCCONT= p_soccont
                AND c.NUMCONT= p_numcont
                AND c.CAV = lpad(nvl(p_cav,'0'),3,'0')
                AND c.CODSG=s.CODSG
                AND s.CODDIR=d.CODDIR
                -- jointure EBIS_FOURNISSEURS
                AND c.SIREN = e.SIREN
                AND trim(e.SOCCODE)=trim(c.SOCCONT)
                AND e.PERIMETRE=d.CODPERIM
                AND e.REFERENTIEL=d.CODREF;
        END IF;

        -- 2. on insert les donnees dans la table de logs
        BEGIN
        INSERT INTO LIGNE_CONT_LOGS (  date_log,
                                       codperim,
                                       numcont,
                                       cav,
                                       codsg,
                                       codref,
                                       code_fournisseur_ebis,
                                       lcnum,
                                       ident,
                                       rnom,
                                       lresdeb,
                                       lresfin,
                                       type_action,
                                       commentaire,
                                       user_log
                                     )
                                VALUES ( sysdate,
                                         l_codperim,
                                         l_numcont,
                                         lpad(nvl(p_cav,'0'),3,'0'),
                                         l_codsg,
                                         l_codref,
                                         l_code_fournisseur_ebis,
                                         p_lcnum,
                                         p_ident,
                                         p_rnom,
                                         p_lresdeb,
                                         p_lresfin,
                                         '1', -- 1 signifie suppresion
                                         'Ligne contrat supprimée',
                                        substr(p_userid,1,7)
                                       );
        END;

         -- Ligne contrat %s1 supprimée pour le contrat %s2.
            Pack_Global.recuperer_message(4005,'%s1',p_lcnum,'%s2',p_numcont, NULL, l_msg);
            p_message := l_msg;

            Pack_contrat.maj_contrats_logs(p_numcont,null, p_soccont, lpad(nvl(p_cav,'0'),3,'0'), null, p_lcnum, l_user, 'LIGNE_CONT', 'Toutes', null, null,null,null,2, 'Suppression de la ligne contrat');
        END IF;

   END delete_LigCont;



   -- *************************************************************************
   -- delete_LigCont
   -- *************************************************************************
   PROCEDURE verif_ressource (p_ident     IN VARCHAR2,
                              p_soccont   IN VARCHAR2,
                              p_lresdeb   IN DATE,
                              p_lresfin   IN DATE,
                              p_numcont    IN VARCHAR2,
                              p_cav       IN LIGNE_CONT.cav%TYPE,
                               p_mode IN VARCHAR2,
                              p_rnom      OUT RESSOURCE.rnom%TYPE,
                              p_rprenom   OUT RESSOURCE.rprenom%TYPE,
                              p_rtype     OUT VARCHAR2,
                              p_lcprest   OUT VARCHAR2,
                              p_lcdomaine   OUT PRESTATION.CODE_DOMAINE%TYPE,
                              p_cout      OUT VARCHAR2,
                              p_modeContractuel  IN OUT VARCHAR2,
                              p_libmodeContractuel  OUT VARCHAR2,
                              p_message         OUT VARCHAR2
                              ) IS

      l_msg VARCHAR2(1024);
      l_dprest VARCHAR2(20);
      l_compteur NUMBER;
      l_count NUMBER;
      l_valid NUMBER;
      l_error NUMBER;
      l_datef DATE;
      l_datefstat DATE;
      l_datedeb DATE;
      l_datefin DATE;

      l_rnom       RESSOURCE.rnom%TYPE;
      l_rprenom    RESSOURCE.rprenom%TYPE;
      l_cout       SITU_RESS.cout%TYPE;
      l_ident      RESSOURCE.ident%TYPE;
      l_datsitu    DATE;
      -- TD 607 point 2
      l_crtype VARCHAR2(2);
      l_ctype_fact VARCHAR2(2);
      l_rtype VARCHAR2(2);
      l_soccode SITU_RESS.SOCCODE%TYPE;
      l_codCont VARCHAR2(3);

      CURSOR cur_situligne IS
          SELECT datsitu, datdep FROM situ_ress
            where ident = to_number(p_ident)
            and trim(soccode) = trim(p_soccont)
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
            order by datsitu asc;

      BEGIN
      l_datefstat := TO_DATE('01/01/1900','DD/MM/YYYY');
      l_datef := TO_DATE('01/01/1900','DD/MM/YYYY');
      l_compteur := 0;
      l_valid := 1;
      l_error := 1;
      p_message := '';
      l_msg := '';

       IF (l_error = 1) THEN
          IF((p_lresdeb is null) or (p_lresfin is null)) THEN
              Pack_Global.recuperer_message( 21198, null, null, null, l_msg);
              p_message := l_msg;
              l_error := 0;
          END IF;
       END IF;

      -- Verification de l'existence de la ressource
      -- Test de l'existance de ressource et recherche de son nom
      IF(l_error=1) THEN
      BEGIN
         SELECT rnom, rprenom, rtype
         INTO   p_rnom, p_rprenom, p_rtype
         FROM   RESSOURCE
         WHERE  ident = TO_NUMBER(p_ident);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            -- Message : Code ressource inexistant
            Pack_Global.recuperer_message(20437, '%s1', p_ident, NULL, l_msg);
            l_error:=0;
            p_message := l_msg;
            --RAISE_APPLICATION_ERROR(-20437, l_msg);
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
    END IF;

   IF(l_error=1) THEN
      -- Test d'appartenance de la ressource à la societe,
      -- Si la prestation
      l_cout:=0;
      BEGIN
          SELECT sr.ident, sr.datsitu, sr.cout
          INTO   l_ident, l_datsitu, l_cout
          FROM   SITU_RESS sr, RESSOURCE r
          WHERE  sr.ident = r.ident
          AND    (sr.ident, sr.datsitu) = (SELECT ident, MAX(datsitu)
                                          FROM SITU_RESS
                                          WHERE ident = TO_NUMBER(p_ident)
                                          AND (trim(soccode) = trim(p_soccont)
                                               OR UPPER(PRESTATION) = 'FIC')
                                          GROUP BY ident
                                          );
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            -- Message : La ressource %s1 n'appartient pas à la société %s2.
            l_error:=0;
            Pack_Global.recuperer_message(20438, '%s1', p_ident, '%s2', trim(p_soccont), NULL, l_msg);
            p_message := l_msg;
            --RAISE_APPLICATION_ERROR(-20438, l_msg);
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
  END IF;


  IF (l_error = 1) THEN
      -- TD 970: on interdit dans un contrat des ressources incompatible avec le type de facturation
      BEGIN
       -- on recupere le type de facturation de ce contrat
       SELECT cont.ctypfact INTO l_ctype_fact
       FROM CONTRAT cont
       WHERE trim(cont.numcont)= trim(p_numcont)
         AND trim(cont.soccont)= trim(p_soccont)
         AND trim(cont.cav)=trim(lpad(nvl(p_cav,'0'),3,'0'));

       -- on recupere le type de la ressource que nous voulons ajouter
       SELECT r.RTYPE INTO l_rtype
       FROM RESSOURCE r
       WHERE r.IDENT=p_ident;

        -- Test compatibilité entre type ressource et type facturation contrat
         IF (l_ctype_fact = 'R' OR l_ctype_fact = 'M') AND (l_rtype = 'F' OR l_rtype = 'E' OR l_rtype = 'L') THEN
                     Pack_Global.recuperer_message( 21197, '%s1', p_ident, null, l_msg);
                      p_message := l_msg;
                      l_error := 0;
          END IF;

         IF (l_rtype = 'P') AND (l_ctype_fact = 'F')THEN
                      Pack_Global.recuperer_message( 21197, '%s1', p_ident, null, l_msg);
                      p_message := l_msg;
                      l_error := 0;
         END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                null;
                --RAISE_APPLICATION_ERROR(-20997,SQLERRM);
       END ;

   END IF;


   -- nous faisons ce test uniquement en mode création
  IF (l_error = 1 and p_mode = 'insert') THEN
      -- TD 607 point 2: on interdit dans un meme contrat des ressources de type différent
      BEGIN
       -- on recupere le type de la premiere ressource attaché a ce contrat
       SELECT r.RTYPE INTO l_crtype
       FROM RESSOURCE r, LIGNE_CONT l
       WHERE r.IDENT=l.IDENT
             AND trim(l.numcont)= trim(p_numcont)
             AND trim(l.soccont)=trim(p_soccont)
             AND trim(l.cav)=trim(lpad(nvl(p_cav,'0'),3,'0'))
             AND rownum=1;
       -- on recupere le type de la ressource que nous voulons ajouter
       SELECT r.RTYPE INTO l_rtype
       FROM RESSOURCE r
       WHERE r.IDENT=p_ident;

        -- si il existe deja une ressource attache au contrat
        IF (l_crtype IS NOT NULL)  THEN
         -- si l'ancienne ressource est de type P et la nouvelle de tpe F ou E
         IF (l_crtype = 'P') AND (l_rtype = 'F' OR l_rtype = 'E') THEN
                      Pack_Global.recuperer_message(21072,NULL,NULL,NULL, l_msg);
                      p_message := l_msg;
                      l_error := 0;
                      --RAISE_APPLICATION_ERROR( -20246, l_msg);
          END IF;

         IF (l_rtype = 'P') AND (l_crtype = 'F' OR l_crtype = 'E')THEN
                      Pack_Global.recuperer_message(21072,NULL, NULL,NULL, l_msg);
                      p_message := l_msg;
                      l_error := 0;
                      --RAISE_APPLICATION_ERROR( -20246, l_msg);
         END IF;

        END IF;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- si il n'y a aucune ligne contrat on recupere le type de la ressource que nous voulons creer
                SELECT r.RTYPE INTO l_crtype
                FROM RESSOURCE r
                WHERE r.IDENT=p_ident;
                  --RAISE_APPLICATION_ERROR(-20997,SQLERRM);
      END ;

   END IF;

    IF (l_error = 1) THEN

          SELECT count(*) into l_count FROM situ_ress
            where ident = to_number(p_ident)
            and trim(soccode) = trim(p_soccont)
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
            order by datsitu asc;

          IF(l_count = 0) THEN
             l_valid := 0;
          ELSIF(l_count = 1) THEN

            SELECT datsitu, datdep into l_datedeb,l_datefin FROM situ_ress
              where ident = to_number(p_ident)
              and trim(soccode) = trim(p_soccont)
              and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
              and rownum = 1
              order by datsitu asc;

            IF((l_datedeb > p_lresdeb) or ((l_datefin is not null) and (l_datefin < p_lresfin))) THEN
              l_valid := 0;
            END IF;
         ELSE
          --Test de compatibilité entre les ressources
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
              )
           THEN
              l_valid := 0;
           END IF;
       END IF;


       IF(l_valid = 1) THEN
          BEGIN
          p_libmodeContractuel := '';
          IF(l_datefin is not null) THEN
            SELECT sr.prestation, TO_CHAR(sr.cout,'FM9999999999D00'), sr.mode_contractuel_indicatif, mc.libelle, p.code_domaine
            INTO p_lcprest, p_cout, p_modeContractuel, p_libmodeContractuel, p_lcdomaine
            FROM situ_ress sr , prestation p, mode_contractuel mc
              where sr.datsitu =  l_datedeb
              and sr.datdep = l_datefin
              and trim(sr.soccode) = trim(p_soccont)
              and sr.ident = p_ident
              and sr.prestation = p.prestation
              and sr.mode_contractuel_indicatif = mc.code_contractuel(+);
          ELSE
          SELECT sr.prestation, TO_CHAR(sr.cout,'FM9999999999D00'), sr.mode_contractuel_indicatif, mc.libelle, p.code_domaine
            INTO p_lcprest, p_cout, p_modeContractuel, p_libmodeContractuel, p_lcdomaine
            FROM situ_ress sr , prestation p, mode_contractuel mc
              where sr.datsitu =  l_datedeb
              and sr.datdep is null
              and trim(sr.soccode) = trim(p_soccont)
              and sr.ident = p_ident
              and sr.prestation = p.prestation
              and sr.mode_contractuel_indicatif = mc.code_contractuel(+);
          END IF;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message( 21199, null, null, null, l_msg);
              p_message := l_msg;
              l_error := 0;
              --RAISE_APPLICATION_ERROR(-20246, l_msg);
          END;
       ELSE
        Pack_Global.recuperer_message( 21197, '%s1', p_ident, null, l_msg);
          p_message := l_msg;
          l_error := 0;
          --RAISE_APPLICATION_ERROR(-20246, l_msg);
       END IF;
       END IF;

   END verif_ressource;

   PROCEDURE update_modecont_situations ( p_ident IN VARCHAR2,
                                          p_soccont IN VARCHAR2,
                                          p_lresdeb IN DATE,
                                          p_lresfin IN DATE,
                                          p_modeContractuel IN VARCHAR2,
                                          p_user    IN VARCHAR2) IS
      l_dprest VARCHAR2(20);
      l_compteur NUMBER;
      l_valid NUMBER;
      l_count NUMBER;
      l_datef DATE;
      l_datefstat DATE;
      l_datedeb DATE;
      l_datefin DATE;
      l_datsitumin DATE;

     CURSOR cur_situligne IS
          SELECT ident, datsitu, datdep, mode_contractuel_indicatif FROM situ_ress
            where ident = to_number(p_ident)
            and trim(soccode) = trim(p_soccont)
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
            order by datsitu asc;

      BEGIN
          l_valid := 1;

          SELECT count(*) into l_count FROM situ_ress
            where ident = to_number(p_ident)
            and trim(soccode) = trim(p_soccont)
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
            order by datsitu asc;

         IF(l_count = 0) THEN
          l_valid := 0;
         ELSIF(l_count = 1) THEN

          SELECT datsitu, datdep into l_datedeb,l_datefin FROM situ_ress
            where ident = to_number(p_ident)
            and trim(soccode) = trim(p_soccont)
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
            and rownum = 1
            order by datsitu asc;

          IF((l_datedeb > p_lresdeb) or ((l_datefin is not null) and (l_datefin < p_lresfin))) THEN
            l_valid := 0;
          END IF;

         ELSE

         l_datefstat := TO_DATE('01/01/1900','DD/MM/YYYY');
         l_datef := TO_DATE('01/01/1900','DD/MM/YYYY');
         l_compteur := 0;


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
            select max(datsitu) into l_datsitumin
            from situ_ress
            where ident = to_number(p_ident)
            and trim(soccode) = trim(p_soccont)
            and datsitu <= p_lresdeb;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
              l_datsitumin := null;
         END;

         -- Si une ou plusieurs situations recouvrent parfaitement la ligne contrat (sans déborder avant ou après) on fait l'update de ces situations
         IF(
              (l_datsitumin is not null)
          AND
              (l_datefin is not null)
          AND
              (l_datsitumin = p_lresdeb)
          AND
              (l_datefin = p_lresfin)
            ) THEN
              FOR one_situligne IN cur_situligne LOOP
                  IF(
                      (one_situligne.datsitu >= l_datsitumin)
                    and
                      (one_situligne.datdep <= l_datefin)
                    ) THEN
                        -- Mise à jour
                        UPDATE SITU_RESS
                        SET mode_contractuel_indicatif = p_modeContractuel
                        WHERE ident = one_situligne.ident
                        AND datsitu = one_situligne.datsitu;
                        -- Tracabilité
                        Pack_Ressource_P.maj_ressource_logs(TO_NUMBER(p_ident), p_user, 'SITU_RESS', 'mode_contractuel_indicatif', one_situligne.mode_contractuel_indicatif, p_modeContractuel, 'Modification de la situation ecran modification Ligne contrat (date valeur situation : ' || one_situligne.datsitu ||')');
                  END IF;
              END LOOP;
         END IF;

       END IF;
  END update_modecont_situations;


     PROCEDURE RECUP_LIB_MC(p_mc        IN    VARCHAR2,
                               p_lib_mc    OUT    VARCHAR2,
                               p_message        OUT     VARCHAR2)
            IS
msg         VARCHAR(1024);
BEGIN
    SELECT LIBELLE INTO p_lib_mc
    FROM mode_contractuel
    WHERE CODE_CONTRACTUEL=p_mc;


    EXCEPTION
    WHEN NO_DATA_FOUND THEN
            Pack_Global.recuperer_message( 21191, NULL, NULL, NULL, p_message);
    WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END RECUP_LIB_MC;

    -- -------------------------------------------------------------------
    -- Test pour savoir si il y a un chevauchement des periodes contrat.
    -- -------------------------------------------------------------------
    -- Fp_message := 'xxxx' Erreur ;  p_message := '' => OK
    --
    --
    --
    -- -------------------------------------------------------------------
PROCEDURE TEST_PERIODE_RESSOURCES( P_NUMCONT    IN LIGNE_CONT.NUMCONT%TYPE,
                                   P_MODE       IN VARCHAR2,
                                   p_lcnum      IN LIGNE_CONT.LCNUM%TYPE,
                                   p_cav        IN VARCHAR2,
                                   p_message  OUT VARCHAR2 ) IS

    CURSOR c_ident IS
    SELECT DISTINCT l.ident
    FROM ligne_cont l
    WHERE l.numcont = P_NUMCONT
        AND l.LCNUM = p_lcnum;

    t_ident c_ident%ROWTYPE;

    -- Recherche des lignes contrat d'une ressources qui sont englobant ou partiellement        
    CURSOR c_contrat IS
    SELECT DISTINCT l.IDENT
    FROM ligne_cont l , ligne_cont l2
    WHERE l.IDENT= l2.IDENT AND l.LCNUM != l2.LCNUM AND l.CAV = l2.CAV AND l.NUMCONT = l2.NUMCONT AND l.SOCCONT = l2.SOCCONT --Ajout de numcont et soccont pour avoir le même contrat
        AND (
            (l2.LRESDEB >= l.LRESDEB AND l2.LRESDEB <= l.LRESFIN)
            OR
            ( l2.LRESFIN >= l.LRESDEB AND l2.LRESFIN <= l.LRESFIN)
            OR
            ( l2.LRESDEB <= l.LRESDEB AND l2.LRESFIN >= l.LRESFIN)
        )
        AND l.numcont = P_NUMCONT
        AND l.CAV = TRIM(LPAD(NVL(p_cav,'0'),3,'0'))
        ORDER BY l.IDENT;

    t_contrat   c_contrat%ROWTYPE;

    l_msg           VARCHAR2(1024);
    ident_concerne  BOOLEAN;        -- Ident selectionné dans l'interface via lcnum
    t_chevauchement BOOLEAN;
    ident_ano       ligne_cont.IDENT%TYPE;
           
    BEGIN

        p_message := '';
       
        CASE
            WHEN P_MODE = 'creer' THEN
           
                OPEN c_contrat;
                FETCH c_contrat INTO t_contrat;
                    IF c_contrat%FOUND THEN
                        Pack_Global.recuperer_message(21223, '%s1', t_contrat.IDENT, '', l_msg);
                        p_message := l_msg;           

                    END IF;
                CLOSE c_contrat;           
               
            WHEN P_MODE = 'modifier' THEN
               
                ident_concerne := FALSE;
                t_chevauchement := FALSE;
               
                OPEN c_ident;
                FETCH c_ident INTO t_ident;
                IF c_ident%FOUND THEN
                    OPEN c_contrat;
                    LOOP
                        FETCH c_contrat INTO t_contrat;
                        EXIT WHEN c_contrat%NOTFOUND;                   
                       
                        t_chevauchement := TRUE;
                        ident_ano := t_contrat.IDENT;
                        IF t_contrat.IDENT = t_ident.IDENT THEN
                            ident_concerne := TRUE;
                        END IF;
                       
                    END LOOP;
                   
                    IF t_chevauchement = TRUE AND ident_concerne = FALSE THEN
                        Pack_Global.recuperer_message(21224, '%s1', ident_ano, '', l_msg);
                        p_message := l_msg;                    
                    END IF;
                    CLOSE c_contrat;
                END IF;
               
              ELSE
                p_message := '';
        END CASE;

    END TEST_PERIODE_RESSOURCES;

    -- -------------------------------------------------------------------
    -- Test pour savoir si il y a un chevauchement des periodes contrat.
    -- -------------------------------------------------------------------
    -- QC 1203
    -- Fp_message := 'xxxx' Erreur ;  p_message := '' => OK
    --
    --
    --
    -- -------------------------------------------------------------------
PROCEDURE CTRL_PERIODE_CREATION( P_NUMCONT    IN LIGNE_CONT.NUMCONT%TYPE,
                                 p_lcnum      IN LIGNE_CONT.LCNUM%TYPE,
                                 p_resdeb     IN VARCHAR2,
                                 p_resfin     IN VARCHAR2,
                                 p_cav        IN VARCHAR2,
                                 p_ident      IN VARCHAR2,
                                 p_message    OUT VARCHAR2 ) IS

    -- Recherche des lignes contrat d'une ressources qui sont englobant         
    CURSOR c_contrat IS
    SELECT DISTINCT l.LRESDEB, l.LRESFIN
    FROM ligne_cont l
    WHERE
        (
            (p_resdeb >= TO_CHAR(l.LRESDEB,'YYYYMMDD') AND p_resdeb <= TO_CHAR(l.LRESFIN,'YYYYMMDD'))
            OR
            ( p_resfin >= TO_CHAR(l.LRESDEB,'YYYYMMDD') AND p_resfin <= TO_CHAR(l.LRESFIN,'YYYYMMDD'))
            OR
            ( p_resdeb <= TO_CHAR(l.LRESDEB,'YYYYMMDD') AND p_resfin >= TO_CHAR(l.LRESFIN,'YYYYMMDD'))
        )
        AND l.numcont = P_NUMCONT
        AND l.CAV = TRIM(LPAD(NVL(p_cav,'0'),3,'0'))
        AND l.IDENT = p_ident ;

    t_contrat   c_contrat%ROWTYPE;

    l_msg       VARCHAR2(1024);
  
    BEGIN

        p_message := '';
 
        OPEN c_contrat;
        FETCH c_contrat INTO t_contrat;

            IF c_contrat%FOUND THEN

                Pack_Global.recuperer_message(21225, NULL, NULL, '', l_msg);
                p_message := l_msg;           

            END IF;
        CLOSE c_contrat;           
 

    END CTRL_PERIODE_CREATION;

    -- -------------------------------------------------------------------
    -- Test pour savoir si il y a un chevauchement des periodes contrat.
    -- -------------------------------------------------------------------
    -- QC 1203
    -- Fp_message := 'xxxx' Erreur ;  p_message := '' => OK
    --
    --
    --
    -- -------------------------------------------------------------------
PROCEDURE CTRL_PERIODE_MODIFICATION( P_NUMCONT    IN LIGNE_CONT.NUMCONT%TYPE,
                                     p_lcnum      IN LIGNE_CONT.LCNUM%TYPE,
                                     p_ident      IN VARCHAR2,
                                     p_resdeb     IN VARCHAR2,
                                     p_resfin     IN VARCHAR2,
                                     p_cav        IN VARCHAR2,
                                     p_message    OUT VARCHAR2 ) IS

    -- Recherche des lignes contrat d'une ressources qui sont englobant         
    CURSOR c_contrat IS
    SELECT DISTINCT l.LRESDEB, l.LRESFIN
    FROM ligne_cont l
    WHERE
        (
            (p_resdeb >= TO_CHAR(l.LRESDEB,'YYYYMMDD') AND p_resdeb <= TO_CHAR(l.LRESFIN,'YYYYMMDD'))
            OR
            ( p_resfin >= TO_CHAR(l.LRESDEB,'YYYYMMDD') AND p_resfin <= TO_CHAR(l.LRESFIN,'YYYYMMDD'))
            OR
            ( p_resdeb <= TO_CHAR(l.LRESDEB,'YYYYMMDD') AND p_resfin >= TO_CHAR(l.LRESFIN,'YYYYMMDD'))
        )
        AND l.numcont = P_NUMCONT
        AND l.CAV = TRIM(LPAD(NVL(p_cav,'0'),3,'0'))
        AND l.IDENT = p_ident
        AND l.LCNUM != p_lcnum ;

    t_contrat   c_contrat%ROWTYPE;

    l_msg       VARCHAR2(1024);
  
    BEGIN

        p_message := '';

        OPEN c_contrat;
        FETCH c_contrat INTO t_contrat;

            IF c_contrat%FOUND THEN

                Pack_Global.recuperer_message(21225, NULL, NULL, '', l_msg);
                p_message := l_msg;           

            END IF;
        CLOSE c_contrat;           

    END CTRL_PERIODE_MODIFICATION;

-- FAD PPM 64360 : Création d'une fonction qui vérifie si le forfait doit être affiché selon les nouvelles règles de gestion
-- FAD PPM 64360 QC 1932 : Modification des paramètres transmis à la fonction, seul le FIDENT est nécessaire.
-- la ligne contrat du forfait lié est incluse dans une seule situation du forfait lié et non dans la situation de la ressource en cours
FUNCTION VERIF_FORFAIT(V_FIDENT IN SITU_RESS.FIDENT%TYPE) RETURN VARCHAR2
IS
  NBRLC NUMBER;
BEGIN
  NBRLC := 0;

  FOR CUR IN (SELECT DISTINCT PRE.IDENT, PRE.DATSITU, DECODE(DER.DATDEP, SYSDATE, NULL, DER.DATDEP - 1) DATDEP
              FROM (SELECT IDENT, DATSITU, NVL(DATDEP + 1, SYSDATE) DATDEP FROM SITU_RESS WHERE IDENT = V_FIDENT) PRE
              INNER JOIN (SELECT IDENT, DATSITU, NVL(DATDEP + 1, SYSDATE) DATDEP FROM SITU_RESS WHERE IDENT = V_FIDENT) DER
              ON PRE.DATSITU < DER.DATDEP AND PRE.IDENT = DER.IDENT
              WHERE NOT EXISTS (SELECT *
              FROM (SELECT IDENT, DATSITU, NVL(DATDEP + 1, SYSDATE) DATDEP FROM SITU_RESS) SI1
              WHERE (SI1.DATSITU < PRE.DATSITU
              AND PRE.DATSITU <= SI1.DATDEP AND PRE.IDENT = SI1.IDENT)
              OR (SI1.DATSITU <= DER.DATDEP
              AND DER.DATDEP < SI1.DATDEP AND DER.IDENT = SI1.IDENT))
              AND NOT EXISTS (SELECT *
              FROM (SELECT IDENT, DATSITU, NVL(DATDEP + 1, SYSDATE) DATDEP FROM SITU_RESS WHERE IDENT = V_FIDENT) SI2
              WHERE PRE.DATSITU < SI2.DATSITU
              AND SI2.DATSITU <= DER.DATDEP AND DER.IDENT = SI2.IDENT AND PRE.IDENT = SI2.IDENT
              AND NOT EXISTS (SELECT *
              FROM (SELECT IDENT, DATSITU, NVL(DATDEP + 1, SYSDATE) DATDEP FROM SITU_RESS WHERE IDENT = V_FIDENT) SI3
              WHERE SI3.DATSITU < SI2.DATSITU
              AND SI2.DATSITU <= SI3.DATDEP AND SI3.IDENT = SI2.IDENT)))
  LOOP
    IF NBRLC = 0
    THEN
      SELECT COUNT(*) INTO NBRLC FROM LIGNE_CONT WHERE IDENT = V_FIDENT AND LRESDEB >= CUR.DATSITU AND (LRESFIN <= CUR.DATDEP OR CUR.DATDEP IS NULL);
    END IF;
  END LOOP;

  IF NBRLC = 0
  THEN
    RETURN NULL;
  END IF;

  RETURN 'OK';
END VERIF_FORFAIT;
-- FAD PPM 64360 QC 1932 : Fin
-- FAD PPM 64360 : Fin

END PACK_LIGCONT;
/









