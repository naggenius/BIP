-- pack_utile PL/SQL
--
-- equipe SOPRA
--
-- crée le 27/10/1999
-- Package fonctions utilitaires, notamment dans des reports.
--
-- Attention le PRAGMA restrict_references doit etre declare juste après la fonction !!!
--
-- Quand    Qui  Nom                   Quoi
-- -------- ---  --------------------  ----------------------------------------
--               f_get_pnom_lbip       recupere le libelle d'une ligne bip
--               f_get_codsg_lbip      recupere le codsg d'une ligne bip
--               f_get_deppole         renvoie le dép/pole, séparé par un '/'
--               f_get_deppole_codsg   renvoie le dép/pole, séparé par un '/'
-- 29/11/99 MRZ  f_get_deppolegrpe     renvoie le dép/pole/grpe, séparé par un '/'
--               f_get_filiale         renvoie la filiale et son identifiant 
--               f_get_dep             renvoie le département
--               f_verif_soccode       vérifie l'existence d'une société 
--               verif_soccode_msg     vérifie l'existence d'une société (call f_verif_soccode!)
--          HT   f_verif_facture       vérification directe de l'existence d'une facture 
--          HT   f_verif_numfact       vérification existence d'un N° de facture 
--               f_verif_dpg           verif existence du code DEP/POLE/GRP
--               f_situ_codsg          retourne le codsg de la derniere situation de la ressource
--               f_get_tva             retourne la tva correspondant à la date ??
--
-- 03/06/03 PJO 		       Migration vers un code DPG à 7 charactères (3+2+2)
-- 24/01/06 BAA	f_get_ref_partenaire   savoir si une societe est partenaire avec un code de departement
-- 30/06/06 PPR 	                   supprime table histo
-- 07/09/2012 BSA : QC 1293 : ajout verif_dpg_raise

CREATE OR REPLACE PACKAGE     Pack_Utile IS

TYPE t_array IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;

FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array;


FUNCTION GET_LISTE ( p_liste VARCHAR2) RETURN VARCHAR2;

TYPE RefCurTyp IS REF CURSOR;

   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_pnom_lbip
   -- Auteur     :  Equipe SOPRA
   -- Decription :  recupere le libelle d'une ligne bip
   -- Paramètres :  p_pid (IN) identifiant du code projet
   --
   -- Retour     :  le libelle du projet
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_pnom_lbip(p_pid IN LIGNE_BIP.pid%TYPE) RETURN VARCHAR2;
       PRAGMA RESTRICT_REFERENCES(f_get_pnom_lbip,wnds,wnps);

   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_ref_partenaire
   -- Decription :  savoir si une societe est partenaire avec un code de departement
   -- Paramètres :  p_coddep (IN) code departement
   --                            p_soccode (IN) code societe
   --
   -- Retour     :  Partenaire ou Non partenaire
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_ref_partenaire(p_coddep IN STRUCT_INFO.coddep%TYPE , p_soccode IN SOCIETE.soccode%TYPE) RETURN VARCHAR2;
       PRAGMA RESTRICT_REFERENCES( f_get_ref_partenaire,wnds,wnps);

   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_codsg_lbip
   -- Auteur     :  Equipe SOPRA
   -- Decription :  recupere le codsg d'une ligne bip
   -- Paramètres :  p_pid (IN) identifiant du code projet
   --
   -- Retour     :  le code DEP/POL/GR de la ligne bip
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_codsg_lbip(p_pid IN LIGNE_BIP.pid%TYPE) RETURN VARCHAR2;
       PRAGMA RESTRICT_REFERENCES(f_get_codsg_lbip,wnds,wnps);

   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_deppole
   -- Auteur     :  Equipe SOPRA
   -- Decription :  renvoie le département/pole, séparé par un '/'
   -- Paramètres :  p_coddeppole (IN)    code département/pole
   --
   -- Retour     :  renvoie le département/pole, séparé par un '/'
   --              en cas d'erreur, renvoie une chaine vide.
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_deppole(p_coddeppole IN STRUCT_INFO.coddeppole%TYPE) RETURN VARCHAR2;
       PRAGMA RESTRICT_REFERENCES(f_get_deppole,wnds,wnps);


   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_deppole_codsg
   -- Auteur     :  Equipe SOPRA
   -- Decription :  renvoie le département/pole, séparé par un '/'
   -- Paramètres :  p_codsg (IN)    code département/pole/Groupe
   --
   -- Retour     :  renvoie le département/pole, séparé par un '/'
   --              en cas d'erreur, renvoie une chaine vide.
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_deppole_codsg(p_codsg IN STRUCT_INFO.codsg%TYPE) RETURN VARCHAR2;
       PRAGMA RESTRICT_REFERENCES(f_get_deppole_codsg,wnds,wnps);

   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_deppolegrpe
   -- Auteur     :  Equipe SOPRA
   -- Decription :  renvoie le département/pole/groupe, séparé par un '/'
   -- Paramètres :  p_cosg  (IN)    code département/pole/groupe
   --
   -- Retour     :  renvoie le département/pole/groupe, séparé par un '/'
   --              en cas d'erreur, renvoie une chaine vide.
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_deppolegrpe(p_codsg IN STRUCT_INFO.codsg%TYPE) RETURN VARCHAR2;
       PRAGMA RESTRICT_REFERENCES(f_get_deppolegrpe,wnds,wnps);


   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_filiale
   -- Auteur     :  Equipe SOPRA
   -- Decription :  renvoie la filiale et son identifiant
   -- Paramètres :  p_filcode (IN)        code filiale
   --
   -- Retour     :  renvoie la filiale et son identifiant
   --              en cas d'erreur, renvoie une chaine vide.
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_filiale(p_filcode IN FILIALE_CLI.filcode%TYPE) RETURN VARCHAR2;
       PRAGMA RESTRICT_REFERENCES(f_get_filiale,wnds);


   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_dep
   -- Auteur     :  Equipe SOPRA
   -- Decription :  renvoie le département
   -- Paramètres :  p_coddep (IN)        code département
   --
   -- Retour     :  renvoie le département
   --              en cas d'erreur, renvoie une chaine vide.
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_dep(p_coddep IN STRUCT_INFO.coddep%TYPE) RETURN VARCHAR2;
             PRAGMA RESTRICT_REFERENCES(f_get_dep,wnds,wnps);

   -- ------------------------------------------------------------------------
   -- Nom        :  f_verif_soccode
   -- Auteur     :  Equipe SOPRA
   -- Decription :  vérifie l'existence d'une société
   -- Paramètres :  p_soccode (IN)        code société
   --
   -- Retour     :  renvoie TRUE si on trouve la société
   --              FALSE si la société n'est pas trouvé
   --              Lève une erreur application en cas d'erreur Oracle
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_verif_soccode(p_soccode IN SOCIETE.soccode%TYPE) RETURN BOOLEAN;
       PRAGMA RESTRICT_REFERENCES(f_verif_soccode,wnds);


   -- ------------------------------------------------------------------------
   --
   -- Nom        :  f_verif_facture
   -- Auteur     :  Equipe SOPRA (HT)
   -- Decription :  vérification directe de l'existence d'une facture
   -- Paramètres :
   --              p_tablefact IN             de la table des factures
   --              p_socfact (IN)           Code société
   --              p_numfact IN              Numéro facture
   --              p_typfact IN              Type facture
   --              p_datfact IN              date facture
   -- Retour     :  renvoie TRUE si on trouve la Facture
   --              FALSE si la Facture n'est pas trouvée
   --              Lève une erreur application en cas d'erreur Oracle
   --
   -- Remarque   : Si p_tablefact différent de 'FACTURE'
   --             On retourne FAUX!!!
   -- ------------------------------------------------------------------------
   FUNCTION f_verif_facture(
                p_tablefact IN VARCHAR2,
                p_socfact IN FACTURE.socfact%TYPE,
                p_numfact IN FACTURE.numfact%TYPE,
                p_typfact IN FACTURE.typfact%TYPE,
                p_datfact IN FACTURE.datfact%TYPE
               ) RETURN BOOLEAN;
       PRAGMA RESTRICT_REFERENCES(f_verif_facture,wnds);


   -- ------------------------------------------------------------------------
   --
   -- Nom        :  f_verif_numfact
   -- Auteur     :  Equipe SOPRA (HT)
   -- Decription :  vérification existence d'un N° de facture
   -- Paramètres :
   --              p_tablefact IN             de la table des factures
   --              p_numfact IN              Numéro facture
   -- Retour     :  renvoie TRUE si on trouve le N° de Facture dans la table p_tablefact
   --              FALSE si la Facture n'est pas trouvée
   --              Lève une erreur application en cas d'erreur Oracle
   --
   -- Remarque   : Si p_tablefact différent de 'FACTURE'
   --             On retourne FAUX!!!
   -- ------------------------------------------------------------------------
   FUNCTION f_verif_numfact(p_tablefact IN VARCHAR2,
                               p_numfact IN FACTURE.numfact%TYPE
                              ) RETURN BOOLEAN;
       PRAGMA RESTRICT_REFERENCES(f_verif_numfact,wnds);

   -- ------------------------------------------------------------------------
   -- Nom        :  f_verif_dpg
   -- Auteur     :  Equipe SOPRA
   -- Decription :
   --
   -- Paramètres :  p_codsg   (IN)  code SG, peut avoir une valeur = '1313**'
   --                              ou '131312' ou '1312  ' (avec des blancs)
   --                              suivant la longueur, on recherchera un
   --                              département, un pôle ou un groupe.
   --
   -- Retour     :  renvoie TRUE si on trouve le DEP/POLE/GRP,
   --            FALSE si la Facture n'est pas trouvée
   --            Lève une erreur application en cas d'erreur Oracle
   -- ------------------------------------------------------------------------
   FUNCTION  f_verif_dpg_old(p_codsg   IN VARCHAR2) RETURN BOOLEAN ;

    -- **********************************************************************
    -- Nom        : f_verif_dpg_gen
    -- Auteur     : BSA
    -- Decription : Prise en compte des dpg generique
    --
    -- Paramètres : p_codsg   (IN)  code SG, peut avoir les valeurs suivantes :
    --                              N******
    --                              NN*****
    --                              NNN****
    --                              NNNN***
    --                              NNNNN**
    --                              NNNNNN*
    --                              NNNNNNN
    --                              suivant la longueur, on recherchera un
    --                              département, un pôle ou un groupe.
    --
    -- Retour     : renvoie TRUE si on trouve le DEP/POLE/GRP,
    --            FALSE si pas trouvée
    --            Lève une erreur application en cas d'erreur Oracle
    -- -----    ---  --------------------------------------------------------
    -- **********************************************************************

      -- ------------------------------------------------------------------------
   -- Nom        :  verif_dpg
   -- Auteur     :  CMA
   -- Decription :
   --
   -- Paramètres :  p_codsg   (IN)
   --
   -- Retour     :  envoit un message d'erreur si le CODSG n'existe pas
   -- ------------------------------------------------------------------------
   PROCEDURE  verif_dpg_old(p_codsg   IN VARCHAR2, p_message OUT VARCHAR2);


    -- **********************************************************************
    -- Nom        : f_verif_dpg_gen
    -- Auteur     : BSA
    -- Decription : Prise en compte des dpg generique
    --
    -- Paramètres : p_codsg   (IN)  code SG, peut avoir les valeurs suivantes :
    --                              N******
    --                              NN*****
    --                              NNN****
    --                              NNNN***
    --                              NNNNN**
    --                              NNNNNN*
    --                              NNNNNNN
    --
    -- Retour     : renvoie TRUE si on trouve le DEP/POLE/GRP,
    --            FALSE si pas trouvée
    --            Lève une erreur application en cas d'erreur Oracle
    -- -----    ---  --------------------------------------------------------
    -- **********************************************************************
   FUNCTION  f_verif_dpg(p_codsg   IN VARCHAR2) RETURN BOOLEAN ;

      -- ------------------------------------------------------------------------
   -- Nom        :  verif_dpg_gen
   -- Auteur     :  CMA
   -- Decription :
   --
   -- Paramètres :  p_codsg   (IN)
   --
   -- Retour     :  envoit un message d'erreur si le CODSG n'existe pas
   -- ------------------------------------------------------------------------
   PROCEDURE  verif_dpg(p_codsg   IN VARCHAR2, p_message OUT VARCHAR2);

   PROCEDURE  verif_dpg_raise(p_codsg   IN VARCHAR2, p_message OUT VARCHAR2);

   -- ------------------------------------------------------------------------
   -- Nom        : verif_soccode_msg
   -- Auteur     : Equipe SOPRA
   -- Decription : vérifie l'existence d'une société,
   --              gère le message d'erreur standard et le focus passé
   -- Paramètres : p_soccode (IN)           code société
   --              p_focus   (IN)            champ sur lequel mettre le focus
   --                                        en cas d'erreur
   --              p_msg     (OUT)           message d'erreur
   --
   -- ------------------------------------------------------------------------
   PROCEDURE verif_soccode_msg
     (p_soccode IN  SOCIETE.soccode%TYPE,
      p_focus IN  VARCHAR2,
      p_msg OUT VARCHAR2
     );

   -- ------------------------------------------------------------------------
   -- Nom        :  f_situ_codsg
   -- Auteur     :  Equipe SOPRA
   -- Decription :  retourne le codsg de la derniere situation de la ressource
   --
   -- Paramètres :  p_ident   (IN)  identifiant de la ressource
   --
   -- Retour     :  un varchar2 contenant le codsg
   -- ------------------------------------------------------------------------
   FUNCTION f_situ_codsg(p_ident IN RESSOURCE.ident%TYPE) RETURN VARCHAR2;
       PRAGMA RESTRICT_REFERENCES(f_situ_codsg, wnds, wnps);


   -- ------------------------------------------------------------------------
   -- Nom        :  f_get_tva
   -- Auteur     :  Equipe SOPRA
   -- Decription :  retourne la tva correspondant à la date
   --
   -- Paramètres :  p_date (IN)  date
   --
   -- Retour     :  la TVA
   -- ------------------------------------------------------------------------
   FUNCTION f_get_tva(p_date IN DATE ) RETURN NUMBER;
       PRAGMA RESTRICT_REFERENCES(f_get_tva, wnds, wnps);


END Pack_Utile;
/


CREATE OR REPLACE PACKAGE BODY     Pack_Utile IS

    FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array
    IS

       i       number :=0;
       pos     number :=0;
       lv_str  varchar2(32767) := p_in_string;

    strings t_array;

    BEGIN

       -- determine first chuck of string
       pos := instr(lv_str,p_delim,1,1);

        IF pos = 0 THEN
            IF LENGTH(p_in_string) > 0 THEN
                strings(1) := p_in_string;
            END IF;
        ELSE
            -- while there are chunks left, loop
            WHILE ( pos != 0) LOOP

               -- increment counter
               i := i + 1;

               -- create array element for chuck of string
               strings(i) := substr(lv_str,1,pos-1);

               -- remove chunk from string
               lv_str := substr(lv_str,pos+1,length(lv_str));

               -- determine next chunk
               pos := instr(lv_str,p_delim,1,1);

               -- no last chunk, add to array
               IF pos = 0 THEN

                  strings(i+1) := lv_str;

               END IF;

            END LOOP;

        END IF;

        -- return array
        RETURN strings;

    END SPLIT;

    FUNCTION GET_LISTE ( p_liste VARCHAR2) RETURN VARCHAR2
    IS

    t_table     t_array;
    t_liste     VARCHAR2(1000);

    BEGIN

    t_table := SPLIT(p_liste,',');
    t_liste := '-1';

    FOR I IN 1..t_table.COUNT LOOP
        IF (t_liste = '-1' ) THEN
            t_liste := '''' || t_table(I) || '''';
        ELSE
            t_liste := t_liste || ',' || '''' || t_table(I) || '''';
        END IF;


    END LOOP;


       -- return varchar2
       RETURN t_liste;

    END GET_LISTE;

   -- **********************************************************************
   -- Nom        : f_get_pnom_lbip
   -- Auteur     : Equipe SOPRA
   -- Decription : recupere le libelle d'une ligne bip
   -- Paramètres : p_pid (IN) identifiant du code projet
   --
   -- Retour     : le libelle du projet
   --
   -- **********************************************************************
   FUNCTION f_get_pnom_lbip(p_pid IN LIGNE_BIP.pid%TYPE) RETURN VARCHAR2 IS

      l_pnom LIGNE_BIP.pnom%TYPE;

   BEGIN
      SELECT  lib.pnom
    INTO  l_pnom
    FROM  LIGNE_BIP lib
    WHERE lib.pid = p_pid;

      RETURN l_pnom;

   END f_get_pnom_lbip;


     -- ------------------------------------------------------------------------
   -- Nom        :  f_get_ref_partenaire
   -- Decription :  savoir si une societe est partenaire avec un code de departement
   -- Paramètres :  p_coddep (IN) code departement
   --                            p_soccode (IN) code societe
   --
   -- Retour     :  Partenaire ou Non partenaire
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_get_ref_partenaire(p_coddep IN STRUCT_INFO.coddep%TYPE , p_soccode IN SOCIETE.soccode%TYPE) RETURN VARCHAR2 IS
           l_lib NUMBER;
  BEGIN

         SELECT COUNT(* ) INTO  l_lib
         FROM  PARTENAIRE pa
         WHERE pa.coddep = p_coddep
         AND pa.soccode = p_soccode;


         IF(l_lib = 0)THEN
            RETURN 'Non partenaire';
         ELSE
              RETURN 'Partenaire';
        END IF;

   END f_get_ref_partenaire;




   -- **********************************************************************
   -- Nom        : f_get_codsg_lbip
   -- Auteur     : Equipe SOPRA
   -- Decription : recupere le codsg d'une ligne bip
   -- Paramètres : p_pid (IN) identifiant du code projet
   --
   -- Retour     : le code DEP/POL/GR de la ligne bip
   --
   -- **********************************************************************
   FUNCTION f_get_codsg_lbip(p_pid IN LIGNE_BIP.pid%TYPE) RETURN VARCHAR2 IS

      l_codsg LIGNE_BIP.codsg%TYPE;

   BEGIN
      SELECT  lib.codsg
       INTO  l_codsg
       FROM  LIGNE_BIP lib
       WHERE lib.pid = p_pid;

      RETURN TO_CHAR(l_codsg, 'FM00000');

   END f_get_codsg_lbip;

   -- **********************************************************************
   -- Nom        : f_get_deppole
   -- Aute        : f_get_deppole
   -- Auteur     : Equipe SOPRA
   -- Decription : renvoie le département/pole, séparé par un '/'
   -- Paramètres : p_coddeppole (IN)     code département/pole
   --
   -- Retour     : renvoie le département/pole, séparé par un '/'
   --               en cas d'erreur, renvoie une chaine vide.
   --
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   --
   -- **********************************************************************
   FUNCTION f_get_deppole(p_coddeppole IN STRUCT_INFO.coddeppole%TYPE) RETURN VARCHAR2 IS
      l_ret VARCHAR2 (20);
   BEGIN
      SELECT  sigdep||'/'||sigpole INTO l_ret
    FROM STRUCT_INFO
    WHERE
    coddeppole = p_coddeppole
    AND ROWNUM <= 1;
      RETURN l_ret;
   EXCEPTION
      WHEN OTHERS THEN
    RETURN 'err :';
   END f_get_deppole ;

   -- **********************************************************************
   -- Nom        : f_get_deppole_codsg
   -- Auteur     : Equipe SOPRA
   -- Decription : renvoie le département/pole, séparé par un '/'
   -- Paramètres : p_codsg (IN)    code département/pole/Groupe
   --
   -- Retour     : renvoie le département/pole, séparé par un '/'
   --              en cas d'erreur, renvoie une chaine vide.
   --
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- **********************************************************************
   FUNCTION f_get_deppole_codsg(p_codsg IN STRUCT_INFO.codsg%TYPE) RETURN VARCHAR2 IS
      l_ret VARCHAR2 (20);
   BEGIN
      SELECT  sigdep||'/'||sigpole INTO l_ret
       FROM STRUCT_INFO
       WHERE codsg = p_codsg
             AND ROWNUM <= 1;
      RETURN l_ret;
   EXCEPTION
      WHEN OTHERS THEN     RETURN '';
   END f_get_deppole_codsg ;


   -- **********************************************************************
   -- Nom        : f_get_dep
   -- Auteur     : Equipe SOPRA
   -- Decription : renvoie le département
   -- Paramètres : p_coddep (IN)        code département
   --
   -- Retour     : renvoie le département
   --              en cas d'erreur, renvoie une chaine vide.
   --
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- **********************************************************************
   FUNCTION f_get_dep(p_coddep IN STRUCT_INFO.coddep%TYPE) RETURN VARCHAR2 IS
      l_ret VARCHAR2 (20);
   BEGIN
      SELECT  sigdep INTO l_ret
       FROM STRUCT_INFO
       WHERE     coddep = p_coddep
                AND ROWNUM <= 1;
      RETURN l_ret;
   EXCEPTION
      WHEN OTHERS THEN     RETURN '';
   END f_get_dep ;


   -- **********************************************************************
   -- Nom        : f_get_filiale
   -- Auteur     : Equipe SOPRA
   -- Decription : renvoie la filiale et son identifiant
   -- Paramètres : p_filcode (IN)        code filiale
   --
   -- Retour     : renvoie la filiale et son identifiant
   --              en cas d'erreur, renvoie une chaine vide.
   --
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- **********************************************************************
   FUNCTION f_get_filiale(p_filcode IN FILIALE_CLI.filcode%TYPE) RETURN VARCHAR2 IS
      l_ret VARCHAR2(40);
   BEGIN

      IF p_filcode IS NOT NULL THEN
          SELECT filsigle
          INTO   l_ret
          FROM   FILIALE_CLI
          WHERE  RTRIM(filcode)= RTRIM(p_filcode);

          RETURN p_filcode || ' ' ||l_ret;

         ELSE     RETURN '';
      END IF;

   EXCEPTION

      WHEN OTHERS THEN
    RETURN '';

   END f_get_filiale;


   -- **********************************************************************
   -- Nom        : f_verif_soccode
   -- Auteur     : Equipe SOPRA
   -- Decription : vérifie l'existence d'une société
   -- Paramètres : p_soccode (IN)        code société
   --
   -- Retour     : renvoie TRUE si on trouve la société
   --              FALSE si la société n'est pas trouvé
   --              Lève une erreur application en cas d'erreur Oracle
   --
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- **********************************************************************
   FUNCTION f_verif_soccode(p_soccode IN SOCIETE.soccode%TYPE) RETURN BOOLEAN IS
      l_count NUMBER;
   BEGIN
      -- TEST existente de la societe dans la table societe.
      BEGIN

         SELECT COUNT(*) INTO l_count
          FROM   SOCIETE
          WHERE  soccode = p_soccode;

          IF (l_count != 1) THEN   RETURN FALSE ;
                            ELSE      RETURN TRUE;
          END IF ;

      EXCEPTION
          WHEN OTHERS THEN  RAISE_APPLICATION_ERROR(-20997, SQLERRM);
      END;
   END f_verif_soccode;


   -- **********************************************************************
   --
   -- Nom        : f_verif_facture
   -- Auteur     : Equipe SOPRA (HT)
   -- Decription : vérification directe de l'existence d'une facture
   -- Paramètres :
   --              p_tablefact IN            Nom de la table des factures
   --              p_socfact (IN)        code société
   --              p_numfact IN              Numéro facture
   --              p_typfact IN              Type facture
   --              p_datfact IN              date facture
   -- Retour     : renvoie TRUE si on trouve la Facture
   --              FALSE si la Facture n'est pas trouvée
   --              Lève une erreur application en cas d'erreur Oracle
   --
   -- Remarque :  Si p_tablefact différent de 'FACTURE'
   --             On retourne FAUX!!!
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- **********************************************************************
   FUNCTION f_verif_facture(p_tablefact IN VARCHAR2,
                p_socfact IN FACTURE.socfact%TYPE,
                p_numfact IN FACTURE.numfact%TYPE,
                p_typfact IN FACTURE.typfact%TYPE,
                p_datfact IN FACTURE.datfact%TYPE
               ) RETURN BOOLEAN IS
      l_count NUMBER;
      l_lgnumfact CONSTANT NUMBER := 15;  -- Length de la colonne numfact

   BEGIN

      -- TEST existence de la facture dans la table p_tablefact

      BEGIN
          IF ( LTRIM(RTRIM(UPPER(p_tablefact))) = 'FACTURE' )
                  THEN
                      SELECT COUNT(*) INTO l_count
                      FROM   FACTURE
                      WHERE  socfact = p_socfact AND
                      numfact = RPAD(p_numfact, l_lgnumfact) AND
                      typfact = p_typfact AND
                      datfact = p_datfact;
                   ELSE  l_count := 0;
          END IF;

          IF (l_count != 1)   THEN   RETURN FALSE ;
                              ELSE   RETURN TRUE;
          END IF ;
      EXCEPTION
         WHEN OTHERS THEN  RAISE_APPLICATION_ERROR(-20997, SQLERRM);
      END;
   END f_verif_facture;

   -- **********************************************************************
   --
   -- Nom        : f_verif_numfact
   -- Auteur     : Equipe SOPRA (HT)
   -- Decription : vérification existence d'un N° de facture
   -- Paramètres :
   --              p_tablefact IN            Nom de la table des factures
   --              p_numfact IN              Numéro facture
   -- Retour     : renvoie TRUE si on trouve le N° de Facture dans la table p_tablefact
   --              FALSE si la Facture n'est pas trouvée
   --              Lève une erreur application en cas d'erreur Oracle
   --
   -- Remarque :  Si p_tablefact différent de 'FACTURE'
   --             On retourne FAUX!!!
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- **********************************************************************
   FUNCTION f_verif_numfact(p_tablefact IN VARCHAR2,
                p_numfact IN FACTURE.numfact%TYPE
               ) RETURN BOOLEAN IS
      l_count NUMBER;
      l_lgnumfact CONSTANT NUMBER := 15;  -- Length de la colonne numfact

   BEGIN
      -- TEST existente du N° de facture dans la table p_tablefact
      BEGIN

          IF ( LTRIM(RTRIM(UPPER(p_tablefact))) = 'FACTURE' ) THEN
             SELECT COUNT(*) INTO l_count
             FROM   FACTURE
             WHERE  numfact = RPAD(p_numfact, l_lgnumfact);
          ELSE
             l_count := 0;
          END IF;

          IF (l_count = 0) THEN    RETURN FALSE;
                           ELSE    RETURN TRUE;
          END IF ;

      EXCEPTION
          WHEN OTHERS THEN  RAISE_APPLICATION_ERROR(-20997, SQLERRM);
      END;
   END f_verif_numfact;


   -- **********************************************************************
   -- Nom        : verif_soccode_msg
   -- Auteur     : Equipe SOPRA
   -- Decription : vérifie l'existence d'une société,
   --              gère le message d'erreur standard et le focus passé
   -- Paramètres : p_soccode (IN)           code société
   --              p_focus   (IN)            champ sur lequel mettre le focus
   --                                        en cas d'erreur
   --              p_msg     (OUT)           message d'erreur
   --
   --
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --               ANO 074 : on retournait pas le message (stocké dans une variable locale)
   -- **********************************************************************
   PROCEDURE verif_soccode_msg
     (p_soccode IN  SOCIETE.soccode%TYPE,
      p_focus IN  VARCHAR2,
      p_msg OUT VARCHAR2
     ) IS
   BEGIN
      IF (p_soccode IS NOT NULL) THEN
           IF (f_verif_soccode(p_soccode) = FALSE) THEN
              Pack_Global.recuperer_message(Pack_Utile_Numsg.nuexc_soccode_inexistant, NULL, NULL , p_focus, p_msg);
           END IF ;
      END IF ;
   END verif_soccode_msg;


   -- **********************************************************************
   -- Nom        : f_verif_dpg
   -- Auteur     : Equipe SOPRA
   -- Decription :
   --
   -- Paramètres : p_codsg   (IN)  code SG, peut avoir une valeur = '1313**'
   --                              ou '131312' ou '1312  ' (avec des blancs)
   --                              suivant la longueur, on recherchera un
   --                              département, un pôle ou un groupe.
   --
   -- Retour     : renvoie TRUE si on trouve le DEP/POLE/GRP,
   --            FALSE si la Facture n'est pas trouvée
   --            Lève une erreur application en cas d'erreur Oracle
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --          MRZ  creation?
   -- 29/12/99 QHL  ajout FM000000 pour prendre en compte cas ancien code
   -- **********************************************************************
   FUNCTION  f_verif_dpg_old(p_codsg   IN VARCHAR2
                             ) RETURN BOOLEAN IS
      l_codsg2 STRUCT_INFO.codsg%TYPE;

   BEGIN
      -- P_codsg peut avoir une valeur = '1313**' ou '131312' ou '1312  ' (avec des blancs)
      -- S'il possed un metacaractere (' ', '*'), on va le supprimer
      -- Puis former la condition Where du Select en fonction du longueur de P_codsg

      SELECT   codsg  INTO  l_codsg2
      FROM   STRUCT_INFO
    -- On formate codsg sur 7 caracteres et on le compare avec p_codsg qui est également formaté sur 7 caracteres.
    -- Ensuite on enleve les '*'
    WHERE  SUBSTR(TO_CHAR(codsg,'FM0000000'),1, LENGTH(RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*')))) = RTRIM(RTRIM(LPAD(p_codsg,7,'0'),'*'))
          AND ROWNUM <= 1;

      RETURN TRUE;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN  RETURN FALSE;
      WHEN OTHERS        THEN     RAISE_APPLICATION_ERROR(-20997,SQLERRM);
   END  f_verif_dpg_old;

    -- **********************************************************************
    -- Nom        : f_verif_dpg
    -- Auteur     : BSA
    -- Decription : Prise en compte des dpg generique
    --
    -- Paramètres : p_codsg   (IN)  code SG, peut avoir les valeurs suivantes :
    --                              N******
    --                              NN*****
    --                              NNN****
    --                              NNNN***
    --                              NNNNN**
    --                              NNNNNN*
    --                              NNNNNNN
    --
    -- Retour     : renvoie TRUE si on trouve le DEP/POLE/GRP,
    --            FALSE si pas trouvée
    --            Lève une erreur application en cas d'erreur Oracle
    -- -----    ---  --------------------------------------------------------
    -- **********************************************************************
    FUNCTION  f_verif_dpg(p_codsg   IN VARCHAR2
                              ) RETURN BOOLEAN IS

    c_codsg RefCurTyp;

    t_codsg     STRUCT_INFO.CODSG%TYPE;
    t_retour    BOOLEAN;
    t_req       VARCHAR2(1000);

    BEGIN
        -- P_codsg peut avoir une valeur = ' 0313** '
        -- On enleve les espaces a droite et a gauche
        -- On enleve les 0 a gauche
        -- On remplace les '*' par '%'
        -- Puis former la condition Where du Select en fonction du p_codsg

        t_req := ' SELECT  codsg FROM  STRUCT_INFO WHERE 1=1 ';
        t_req := t_req || ' AND CODSG LIKE ''' || REPLACE(LTRIM(TRIM(p_codsg),'0'),'*','%') || '''';
        t_req := t_req || ' AND ROWNUM <= 1' ;

        OPEN c_codsg FOR t_req;
        FETCH c_codsg INTO t_codsg;
        IF c_codsg%FOUND THEN
            t_retour := TRUE;
        ELSE
            t_retour := FALSE;
        END IF;

        RETURN t_retour;


    EXCEPTION
        WHEN OTHERS        THEN     RAISE_APPLICATION_ERROR(-20997,SQLERRM);
    END  f_verif_dpg;




    -- **********************************************************************
    -- Nom        : verif_dpg
    -- Auteur     : CMA
    -- Decription :
    --
    -- Paramètres : p_codsg   (IN)
    -- Retour     : Renvoie un message d'erreur si le codsg n'existe pas
    -- Quand    Qui  Quoi
    -- -----    ---  --------------------------------------------------------
    --          MRZ  creation?
    -- **********************************************************************
    PROCEDURE  verif_dpg(p_codsg   IN VARCHAR2, p_message OUT VARCHAR2
                              ) IS

        l_msg          varchar2(1024);

    BEGIN

        l_msg:='';
        IF ( pack_utile.f_verif_dpg(LPAD(p_codsg, 7, '0'))= FALSE ) THEN -- Message Dep/pole inconnu
            pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
        End if;
        p_message := l_msg;

    END  verif_dpg;

    -- **********************************************************************
    -- Nom        : verif_dpg_raise
    -- Auteur     : CMA
    -- Decription :
    --
    -- Paramètres : p_codsg   (IN)
    -- Retour     : Raise un message d'erreur si le codsg n'existe pas
    -- Quand    Qui  Quoi
    -- -----    ---  --------------------------------------------------------
    --          MRZ  creation?
    -- **********************************************************************
    PROCEDURE  verif_dpg_raise(p_codsg   IN VARCHAR2, p_message OUT VARCHAR2
                              ) IS

        l_msg          varchar2(1024);

    BEGIN

        l_msg:='';
        IF ( pack_utile.f_verif_dpg(LPAD(p_codsg, 7, '0'))= FALSE ) THEN -- Message Dep/pole inconnu
            pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
            raise_application_error(-20327,l_msg);
        End if;
        p_message := l_msg;

    END  verif_dpg_raise;

      -- **********************************************************************
   -- Nom        : verif_dpg
   -- Auteur     : CMA
   -- Decription :
   --
   -- Paramètres : p_codsg   (IN)
   -- Retour     : Renvoie un message d'erreur si le codsg n'existe pas
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --          MRZ  creation?
   -- **********************************************************************
   PROCEDURE  verif_dpg_old(p_codsg   IN VARCHAR2, p_message OUT VARCHAR2
                             ) IS

    l_msg          varchar2(1024);
   BEGIN
    l_msg:='';
     If ( pack_utile.f_verif_dpg(LPAD(p_codsg, 7, '0'))= false ) then -- Message Dep/pole inconnu
               pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
     End if;
    p_message := l_msg;
   END  verif_dpg_old;

   -- **********************************************************************
   -- Nom        : f_situ_codsg
   -- Auteur     : Equipe SOPRA
   -- Decription : retourne le codsg de la derniere situation de la ressource
   --
   -- Paramètres : p_ident   (IN)  identifiant de la ressource
   --
   -- Retour     : un varchar2 contenant le codsg
   -- Quand    Qui  Quoi
   -- -----    ---  --------------------------------------------------------
   --
   -- **********************************************************************
   FUNCTION f_situ_codsg (p_ident IN RESSOURCE.ident%TYPE) RETURN VARCHAR2 IS
     l_ret VARCHAR2(20);
   BEGIN
     SELECT  MAX(codsg)
       INTO  l_ret
     FROM  SITU_RESS
     WHERE datsitu = (SELECT MAX(datsitu)
                       FROM   SITU_RESS
                       WHERE  ident = p_ident
                       GROUP BY ident)
       AND   ident = p_ident;

     RETURN l_ret;
   EXCEPTION
     WHEN OTHERS THEN   RETURN 'err :';
   END f_situ_codsg ;

  -- **********************************************************************
  -- Nom        : f_get_deppolegrpe
  -- Auteur     : Equipe SOPRA
  -- Decription : retourne le libelle correspondant au groupe
  --
  -- Paramètres : p_codsg  (IN) code sg du groupe
  --
  -- Retour     : un varchar2 le libelle du dep/pole/groupe
  -- Quand    Qui  Quoi
  -- -----    ---  --------------------------------------------------------
  --
  -- **********************************************************************
  FUNCTION f_get_deppolegrpe(p_codsg IN STRUCT_INFO.codsg%TYPE) RETURN VARCHAR2 IS
      l_ret VARCHAR2 (30);
   BEGIN
      SELECT  libdsg INTO l_ret
          FROM  STRUCT_INFO
          WHERE codsg = p_codsg
                AND ROWNUM <= 1;
      RETURN l_ret;
   EXCEPTION
      WHEN OTHERS THEN     RETURN 'err :';
   END f_get_deppolegrpe ;

  -- **********************************************************************
  -- Nom        : f_get_tva
  -- Auteur     : Equipe SOPRA
  -- Decription : retourne la tva correspondant à la date ???
  --
  -- Paramètres : p_date (IN)  date
  --
  -- Retour     : la TVA
  -- **********************************************************************
  FUNCTION f_get_tva(p_date IN DATE ) RETURN NUMBER IS
     l_ret NUMBER;
  BEGIN

     SELECT TVA INTO l_ret
       FROM TVA
       WHERE datetva IS NOT NULL AND
       datetva = (SELECT MAX(datetva) FROM TVA WHERE datetva IS NOT NULL);
     RETURN  l_ret;

  EXCEPTION
     WHEN OTHERS THEN   RETURN 0;
  END ;
  
END Pack_Utile;
/
