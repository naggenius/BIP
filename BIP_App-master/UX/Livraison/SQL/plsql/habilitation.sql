create or replace
PACKAGE     pack_habilitation AS

TYPE RefCurTyp IS REF CURSOR;

TYPE t_array IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;

-- **************************************************************************************
-- Nom 		: verif_habili_me
-- Auteur 	: NBM
-- Description 	: Vrifie si l'utilisateur est habilit au BDDPG
--		  en vrifiant d'abord l'existence du code DPG demand
--		  ( pack_utile.f_verif_dpg(p_codsg)= true or false )
-- Paramtres 	: p_codsg (IN) code DPG demand (16**** ou 1616** ou 161612 ou 16** )
--		  p_global (IN) contenant le code primtre de l'utilisateur
-- Retour	: message d'erreur si non habilitation
--
-- **************************************************************************************
  PROCEDURE verif_habili_me_old ( p_codsg   IN VARCHAR2,
				 p_global  IN VARCHAR2,
				 p_message OUT VARCHAR2 );

-- **************************************************************************************
-- Nom 		: verif_habili_me_gen
-- Auteur 	: NBM
-- Description 	: Vrifie si l'utilisateur est habilit au BDDPG
--		  en vrifiant d'abord l'existence du code DPG demand
--		  ( pack_utile.f_verif_dpg(p_codsg)= true or false )
-- Paramtres 	: p_codsg (IN) code DPG demand
--                              *******
--                              N******
--                              NN*****
--                              NNN****
--                              NNNN***
--                              NNNNN**
--                              NNNNNN*
--                              NNNNNNN
--		  p_global (IN) contenant le code primtre de l'utilisateur
-- Retour	: message d'erreur si non habilitation
--
-- **************************************************************************************
  PROCEDURE verif_habili_me ( p_codsg   IN VARCHAR2,
                				  p_global  IN VARCHAR2,
                				  p_message OUT VARCHAR2 );


-- **************************************************************************************
-- Nom 		:
-- Auteur 	: NBM
-- Description 	: Vrifie que le codsg appartient ou pas au primtre de l'utilisateur
-- Paramtres 	: p_codsg (IN) code DPG demand (161612 )
--		  p_global (IN) contenant le code primtre de l'utilisateur
-- Retour	:  retourne 'vrai' si habilitation, 'faux' sinon
--
-- **************************************************************************************

-- FAD PPM 63560
  PROCEDURE habili_me_dpg_ouv_fer ( p_codsg   IN VARCHAR2,
                				  p_global  IN VARCHAR2,
                				  p_message OUT VARCHAR2 );


-- **************************************************************************************
-- Nom 		:
-- Auteur 	: FAD
-- Description 	: Vrifie que le codsg (ouvert ou ferm) appartient ou pas au primtre de l'utilisateur
-- Paramtres 	: p_codsg (IN) code DPG demand (161612 )
--		  p_global (IN) contenant le code primtre de l'utilisateur
-- Retour	:  retourne 'vrai' si habilitation, 'faux' sinon
--
-- **************************************************************************************

  FUNCTION fhabili_me ( p_codsg   IN VARCHAR2,
			p_global  IN VARCHAR2) RETURN VARCHAR2;

-- **************************************************************************************
-- Nom 		: verif_perim_me
-- Auteur 	: BSA
-- Description 	: Vrifie perim me RTFE de l'utilisateur
--                si tous les codes du perime me  sont inexistant alors KO
-- Paramtres 	: p_global (IN) contenant le code primtre de l'utilisateur
-- Retour	:  retourne 'KO' si tous les prerimetre me sont inexistant
--
-- **************************************************************************************

  FUNCTION verif_perim_me ( p_global  IN VARCHAR2) RETURN VARCHAR2;

 PROCEDURE select_verif_deppole_mens  (p_codsg     IN VARCHAR2,
                                  p_global    IN CHAR,
                                  p_libcodsg     OUT VARCHAR2,
                                  p_nbcurseur    OUT INTEGER,
                                  p_message      OUT VARCHAR2
                                 );
-- **************************************************************************************
-- Nom 		: fverif_habili_mo
-- Auteur 	: NCM
-- Description 	: Vrifie si l'utilisateur est habilit au dpartement ou  la direction
--
-- Paramtres 	: p_codperimo (IN) code primtre MO de l'utilisateur
--		  p_direction (IN) code direction ou dpartement
-- Retour	: true si habilit, false sinon
--
-- **************************************************************************************
  FUNCTION  fverif_habili_mo( p_perimo IN VARCHAR2,
			      p_direction IN client_mo.clicode%TYPE
			  ) RETURN BOOLEAN;

-- **************************************************************************************
-- Nom 		: verif_perimetre
-- Auteur 	: MMC
-- Description 	: mme chose que select_verif_deppole_mens mais on enlve lel contrle dans
-- le cas ou l'utilisateur saisit *******
--
-- Paramtres 	: p_codsg (IN) code DPG demand (16**** ou 1616** ou 161612 ou 16** )
--		  p_global (IN) contenant le code primtre de l'utilisateur
-- Retour	: message d'erreur si non habilitation
--
-- **************************************************************************************
PROCEDURE verif_perimetre  (p_codsg     IN VARCHAR2,
                                  p_global    IN CHAR,
                                  p_libcodsg     OUT VARCHAR2,
                                  p_nbcurseur    OUT INTEGER,
                                  p_message      OUT VARCHAR2
                                 );


-- **************************************************************************************
-- Nom 		: verif_habili_dpg_appli
-- Auteur 	: JMA
-- Description 	: Vrifie si l'utilisateur est habilit au DPG
--		  en vrifiant d'abord l'existence du code DPG demand
--		  ( pack_utile.f_verif_dpg(p_codsg)= true or false )
--		  et si le code application est dans le primtre de l'utilisateur
-- Paramtres 	: p_codsg (IN) code DPG demand (16**** ou 1616** ou 161612 ou 16** )
-- 				  p_airt (IN) code application
--		  		  p_global (IN) contenant le code primtre de l'utilisateur
-- Retour	: message d'erreur si non habilitation
--
-- **************************************************************************************
  PROCEDURE verif_habili_dpg_appli ( p_codsg   IN VARCHAR2,
  								     p_airt    IN VARCHAR2,
				 					 p_global  IN VARCHAR2,
				 					 p_message OUT VARCHAR2 );

    PROCEDURE verif_dpg_centrefrais ( p_codsg   IN VARCHAR2,
  								      p_centrefrais    IN VARCHAR2,
				 					  p_global  IN VARCHAR2,
				 					  p_message OUT VARCHAR2 );
    -- **************************************************************************************
-- Nom 		: verif_perim_ressource
-- Auteur 	: CMA
-- Description 	: Vrifie que l'utilisateur a le droit de consulter les informations de la ressource passe en paramtres :
--        * la ressource a une situation qui est, au moment de la demande, rattache  un DPG qui est dans le primtre ME de l'utilisateur; OU
--        * la ressource est parmi les CP ou subordonns immdiats, habilits dans le profil Saisie directe de l'utilisateur, s'il existe
-- Paramtres 	: p_ident (IN) Identifiant de la ressource que l'utilisateur souhaite consulter
-- 				  p_global (IN) contenant le code primtre de l'utilisateur
-- Retour	: message d'erreur si non habilit
--
-- **************************************************************************************
    PROCEDURE verif_perim_ressource ( p_ident   IN VARCHAR2,
  								      p_global  IN VARCHAR2,
				 					  p_message OUT VARCHAR2 );

  FUNCTION isDpgMe ( p_codsg   IN VARCHAR2,
			         p_perim_me  IN VARCHAR2) RETURN VARCHAR2;


    -- **************************************************************************************
-- Nom 		: isPerimMo
-- Auteur 	: BSA
-- Description 	: Retourne "O" si le client fait parti du perimetre RTFE
-- Paramtres 	: p_clicode (IN) Identifiant du client l'utilisateur souhaite consulter
-- 				  p_perim_mo (IN) contenant le code primtre mo de l'utilisateur
-- Retour	: "O" pour oui, "N" pour non.
--
-- **************************************************************************************

  FUNCTION isPerimMo ( p_clicode    IN VARCHAR2,
			           p_perim_mo   IN VARCHAR2) RETURN VARCHAR2;


    -- **************************************************************************************
-- Nom 		: isPerimCafi
-- Auteur 	: BSA
-- Description 	: Retourne "O" si le cafi fait parti du perimetre RTFE en prenant compte le multi niveau du cafi
-- Paramtres 	: p_cafi (IN) Identifiant de la ressource que l'utilisateur souhaite consulter
-- 				  p_perim_cafi (IN) contenant le code primtre cafi de l'utilisateur
-- Retour	: "O" pour oui, "N" pour non.
--
-- **************************************************************************************

  FUNCTION isPerimCafi ( p_cafi         IN VARCHAR2,
			             p_perim_cafi   IN VARCHAR2) RETURN VARCHAR2;



-- ******************************************************************************************************************
-- Nom            : verif_direction_perime
-- Auteur         : OEL
-- Description    : Vrifie si la direction fait partie du perimetre ME de l'utilisateur
--
-- Paramtres     : p_userid (IN)
--                  p_coddir (IN) code direction sur 2 caractres
-- Retour         : False si non habilitation / True si habilitation
--
-- ******************************************************************************************************************
    FUNCTION VERIF_PERIME_DIRECTION(   p_userid    IN  VARCHAR2,
                                       p_coddir    IN  VARCHAR2
                                   ) RETURN VARCHAR2;

    -- **************************************************************************************
-- Nom 		: verif_perim_ligne
-- Auteur 	: SEL
-- Date     : 17/03/2015
-- Description 	: Vrifie que l'utilisateur a le droit de consulter les informations sur une ligne BIP:
--
-- Paramtres 	: p_pid (IN) Identifiant de la ligne BIP que l'utilisateur souhaite consulter
-- 				        p_global (IN) contenant le code primtre de l'utilisateur
-- Retour	: message d'erreur si non habilit
--
-- **************************************************************************************
    PROCEDURE verif_perim_ligne_bip ( p_pid   IN VARCHAR2,
  								      p_liste_cp  IN VARCHAR2,
				 					  p_message OUT VARCHAR2 );

-- FAD PPM 63956 : Retourne le primtre de Directions ou Branches BIP habilites
PROCEDURE HABILITATION_SUIVBASE(	P_ID_USER   IN RTFE.USER_RTFE%TYPE,
									P_PERIM  OUT VARCHAR2,
									P_MESSAGE OUT VARCHAR2);
-- FAD PPM 63956 : Fin

-- FAD PPM 63956 : Vrifier les rgles de gestion lis au IHM
PROCEDURE VERIF_EXISTANCE_ENTREE(P_CODSG IN VARCHAR2,
								P_DPCODE IN VARCHAR2,
								P_DP_COPI IN VARCHAR2,
								P_ICPI IN VARCHAR2,
								P_AIRT IN VARCHAR2,
								P_PERIM_ME IN VARCHAR2,
								P_HABIL IN VARCHAR2,
								P_MESSAGE OUT VARCHAR2);
-- FAD PPM 63956 : Fin

								
--DHA optimization bips--
PROCEDURE find_pid_avec_cdp_valides ( id_lignes_in  IN  ARRAY_TABLE,                                                                                                                                                          
                                      liste_cp_in IN ARRAY_TABLE,
                                      id_lignes OUT ARRAY_TABLE);
END pack_habilitation;
/

create or replace
PACKAGE BODY     pack_habilitation AS

FUNCTION split (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array
    IS

       i       number :=0;
       pos     number :=0;
       lv_str  varchar2(4000) := p_in_string;

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

    END split;

FUNCTION isDpgMe (  p_codsg   IN VARCHAR2,
                    p_perim_me  IN VARCHAR2) RETURN VARCHAR2 IS



    t_retour    VARCHAR2(10);

    t_req       VARCHAR2(1000);
    c_req       RefCurTyp;
    t_codsg     vue_dpg_perime.CODSG%TYPE;

    BEGIN

        t_req := ' SELECT codsg FROM vue_dpg_perime ';
        t_req := t_req || ' WHERE INSTR('''||p_perim_me||''', codbddpg ) > 0  ';
        t_req := t_req || ' AND CODSG = ' || TO_NUMBER(p_codsg) ;

        OPEN c_req FOR t_req;
        FETCH c_req INTO t_codsg;
        IF c_req%FOUND THEN
            t_retour := 'O';
        ELSE
            t_retour := 'N';
        END IF;

        CLOSE c_req;

        RETURN t_retour;

    EXCEPTION
        WHEN OTHERS THEN
           return  'N';

END isDpgMe;

    -- **************************************************************************************
-- Nom 		: isPerimMo
-- Auteur 	: BSA
-- Description 	: Retourne "O" si le client fait parti du perimetre RTFE
-- Paramtres 	: p_clicode (IN) Identifiant du client l'utilisateur souhaite consulter
-- 				  p_perim_mo (IN) contenant le code primtre mo de l'utilisateur
-- Retour	: "O" pour oui, "N" pour non.
--
-- **************************************************************************************

  FUNCTION isPerimMo ( p_clicode    IN VARCHAR2,
			           p_perim_mo   IN VARCHAR2) RETURN VARCHAR2 IS



    t_retour    VARCHAR2(10);

    t_req       VARCHAR2(1000);
    c_req       RefCurTyp;
    t_codsg     vue_dpg_perime.CODSG%TYPE;

    BEGIN

        t_req := ' SELECT CLICODE FROM vue_clicode_perimo ';
        t_req := t_req || ' WHERE INSTR('''||p_perim_mo||''', BDCLICODE ) > 0  ';
        t_req := t_req || ' AND CLICODE = ''' || p_clicode || '''' ;

        OPEN c_req FOR t_req;
        FETCH c_req INTO t_codsg;
        IF c_req%FOUND THEN
            t_retour := 'O';
        ELSE
            t_retour := 'N';
        END IF;

        CLOSE c_req;

        RETURN t_retour;

    EXCEPTION
        WHEN OTHERS THEN
           return  'N';

END isPerimMo;

  PROCEDURE verif_habili_me( p_codsg   IN VARCHAR2,
                 p_global  IN VARCHAR2,
                 p_message OUT VARCHAR2 ) IS

 -- Cration du curseur qui ramne tous les BDDPG du primtre de l'utilisateur
 --  CURSOR cur_bddpg (p_perimetre IN number) IS
 --    select codbddpg, codhabili
 --    from detail_perimetre_me
 --    where codperime=p_perimetre
 --    order by codbddpg;

 -- Variables qui contiennent un BDDPG et le code d'habilitation
  codbddpg            VARCHAR2(25);
  codhabili            VARCHAR2(15);

  l_perimetre          VARCHAR2(1000);


  c_branche         VARCHAR2(10);
  c_direction         VARCHAR2(10);
  c_departement     VARCHAR2(10);
  c_pole             VARCHAR2(10);
  c_groupe             VARCHAR2(10);
  --l_dpg             VARCHAR2(10);
  l_habilitation    VARCHAR2(10);
  l_msg             VARCHAR2(1024);
  l_saisi             VARCHAR2(15);
  pos_bddpg            INTEGER;
  pos_bddpg_suiv    INTEGER;
  nb_bddpg            INTEGER;
  l_perimTermine    BOOLEAN;
  t_req_br          VARCHAR2(1000);
  t_req_dir         VARCHAR2(1000);

  c_br              RefCurTyp;
  t_br              NUMBER;

  c_dir             RefCurTyp;
  t_dir             NUMBER;
  t_codsg           VARCHAR2(7);
  l_menutil         VARCHAR2(50);

  BEGIN
    l_msg:=p_message ;
    l_msg:='';
    l_habilitation := 'faux';

    -- retrouver le primtre me de l'utilisateur
    l_perimetre := pack_global.lire_globaldata(p_global).perime;


    -- On complete a gauche par 0 sur 7 position
    t_codsg := LPAD(p_codsg,7,'0');

    -- Si le codsg est null on le remplace par *******
    IF t_codsg IS NULL THEN
        t_codsg := '*******';
    END IF;
    IF t_codsg = '' THEN
        t_codsg := '*******';
    END IF;

  -- **************************************************************
  -- 0) Controle du perim RTFE de l'utilisateur
  -- ***************************************************************
  IF (l_perimetre is null or trim(l_perimetre) = '') THEN

        NULL;

  ELSE
        IF ( VERIF_PERIM_ME ( P_GLOBAL ) = 'KO' ) THEN

            -- Votre primtre ME est invalide, veuillez contacter la MO.
            pack_global.recuperer_message(21240, NULL, NULL, NULL, l_msg);
            raise_application_error(-20327,l_msg);

        END IF;

  END IF;


  -- **************************************************************
  -- 1) Vrification de l'existence du code DPG demand
  -- ***************************************************************

      IF (t_codsg!='*******' )  THEN
    If ( pack_utile.f_verif_dpg(t_codsg)= false ) then -- Message Dep/pole inconnu
        pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);
         End if;
     END IF;

  -- *********************************************************************************
  -- 2) Vrification de l'habilitation de l'utilisateur par rapport  son primtre
  -- *********************************************************************************


    if substr(t_codsg,4,4)='****' then --un dpartement
        l_saisi :='dpt';
    else
        if substr(t_codsg,6,2)='**' then --un ple
            l_saisi :='pole';
        else
            if t_codsg!='*******' then --un groupe
                l_saisi :='groupe';
            else
                l_saisi :='all';
            end if;
        end if;
    end if;


    -- On initialise les paramtrers de la boucle while comptant le nombre de BDDPG du primtre
    pos_bddpg := 0;
    nb_bddpg := 0;
    pos_bddpg_suiv := 0;
    l_perimTermine := false;

    -- Test si perimetre ME est vide on ne va pas plus loin
    if (l_perimetre is null or trim(l_perimetre) = '') then
        l_perimTermine := true;
    end if ;


    -- Tant qu'il y a des bddpg dans le primtre, on tourne.
    WHILE NOT (l_perimTermine) LOOP

      --On met  jour les paramtres identifiant les BDDPG du primtre ME.
      pos_bddpg := pos_bddpg_suiv + 1;
      nb_bddpg := nb_bddpg + 1;
      pos_bddpg_suiv := INSTR(l_perimetre, ',', 1, nb_bddpg);

      IF pos_bddpg_suiv = 0 THEN
         l_perimTermine := true;
      END IF;

      --On met  jour le BDDPG courant
      --Si c'est le dernier, on prend la longueur de chane du primtre - la position de la virgule
      --Sinon on prend la position du suivant - la position de l'actuel
      IF l_perimTermine THEN
         codbddpg := SUBSTR(l_perimetre, pos_bddpg, LENGTH(l_perimetre)-pos_bddpg + 1);
      ELSE
         codbddpg := SUBSTR(l_perimetre, pos_bddpg, pos_bddpg_suiv-pos_bddpg);
      END IF;

      -- On trouve le codhabili en fonction du format du BDDPG
    if codbddpg= '00000000000' then
       codhabili :='all';
    else
      if substr(codbddpg,3,9)='000000000' then --une branche
          codhabili :='br';
      else
         if substr(codbddpg,5,7)='0000000' then --une direction
            codhabili :='dir';
         else
          if substr(codbddpg,8,4)='0000' then --un dpartement
              codhabili :='dpt';
          else
            if substr(codbddpg,10,2)='00' then --un ple
                codhabili :='pole';
            else
                if substr(codbddpg,1,11) !='00000000000' then --un groupe
                    codhabili :='tout';
                end if;
            end if;
          end if;
         end if;
      end if;
    end if;

    -- On rcupre les diffrentes composantes du bddpg
    c_branche     := SUBSTR(codbddpg,1,2);              --03
    c_direction     := SUBSTR(codbddpg,3,2);        --14
    c_departement := SUBSTR(codbddpg,1,7);        --0314016
    c_pole     := SUBSTR(codbddpg,5,5);        --01616
    c_groupe     := SUBSTR(codbddpg,5,7);        --0161612

    t_req_br := 'SELECT 1 FROM struct_info s, directions d WHERE 1=1 ';
    t_req_br := t_req_br || ' AND LPAD(s.coddep,3,0) LIKE ''' || SUBSTR(REPLACE(t_codsg,'*','%'),1,3) || '''';
    t_req_br := t_req_br || ' AND LPAD(d.codbr,2,0) = ' || c_branche ;
    t_req_br := t_req_br || ' AND s.coddir=d.coddir ';
    t_req_br := t_req_br || ' AND s.topfer=''O'' ' ;
    t_req_br := t_req_br || ' AND ROWNUM=1';

    t_req_dir := 'SELECT 1 FROM struct_info s, directions d WHERE 1=1 ';
    t_req_dir := t_req_dir || ' AND LPAD(s.coddep,3,0) LIKE ''' || SUBSTR(REPLACE(t_codsg,'*','%'),1,3) || '''';
    t_req_dir := t_req_dir || ' AND LPAD(d.codbr,2,0) = ' || c_branche ;
    t_req_dir := t_req_dir || ' AND LPAD(d.coddir,2,0) = ' || c_direction ;
    t_req_dir := t_req_dir || ' AND s.coddir=d.coddir ';
    t_req_dir := t_req_dir || ' AND s.topfer=''O'' ' ;
    t_req_dir := t_req_dir || ' AND ROWNUM=1';

     -- Cas o on veut tout (*******)
    IF (l_saisi='all' and codhabili='all') THEN
            l_habilitation := 'vrai';
        EXIT;
    END IF;

    -- ******************************************
           -- cas 1 : habilitation  toute la BIP
    -- ******************************************
    IF codhabili='all' THEN
        --dbms_output.put_line('Vous tes habilit  toute la BIP  ');
        l_habilitation := 'vrai';

        EXIT;
    ELSE
     -- ******************************************
     -- cas 2 : habilitation  toute une branche
     -- ******************************************
    IF codhabili='br' THEN

        -- Rechercher la branche du departement saisie (complet ou partiel) et comparer avec celui de son perimetre
        OPEN c_br FOR t_req_br;
        FETCH c_br INTO t_br;
        IF c_br%FOUND THEN
            l_habilitation := 'vrai';
            CLOSE c_br;
            EXIT;
        END IF;

    ELSE
     -- ********************************************
     -- cas 3 : habilitation  toute une direction
     -- ********************************************
    if codhabili='dir' then

        -- Rechercher la direction du departement saisie (complet ou partiel) et comparer avec celui de son perimetre
        OPEN c_dir FOR t_req_dir;
        FETCH c_dir INTO t_dir;
        IF c_dir%FOUND THEN
            l_habilitation := 'vrai';
            CLOSE c_dir;
            EXIT;
        END IF;
        CLOSE c_dir;

    ELSE
     -- ********************************************
     -- cas 4 : habilitation  tout un dpartement
     -- ********************************************
    if codhabili='dpt' then
        -- Comparaison du dept saisie (complet ou partiel) et celui de son perimetre

        IF t_codsg = '*******' THEN
            l_habilitation := 'vrai';
            exit;

        ELSIF SUBSTR(t_codsg,2,6) = '******' THEN
            IF SUBSTR(c_groupe,1,1) = SUBSTR(t_codsg,1,1) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,3,5) = '*****' THEN
            IF SUBSTR(c_groupe,1,2) = SUBSTR(t_codsg,1,2) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(c_groupe,1,3) = SUBSTR(t_codsg,1,3) THEN
                l_habilitation := 'vrai';
                exit;
        END IF;

    ELSE
      -- ********************************************
     -- cas 5 : habilitation  tout un pole
     -- ********************************************
    IF codhabili='pole' THEN

        -- Comparaison du pole saisie (complet ou partiel) et celui de son perimetre
        IF t_codsg = '*******' THEN
            l_habilitation := 'vrai';
            exit;

        ELSIF SUBSTR(t_codsg,2,6) = '******' THEN
            IF SUBSTR(c_groupe,1,1) = SUBSTR(t_codsg,1,1) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,3,5) = '*****' THEN
            IF SUBSTR(c_groupe,1,2) = SUBSTR(t_codsg,1,2) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,4,4) = '****' THEN
            IF SUBSTR(c_groupe,1,3) = SUBSTR(t_codsg,1,3) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,5,3) = '***' THEN
            IF SUBSTR(c_groupe,1,4) = SUBSTR(t_codsg,1,4) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(c_groupe,1,5) = SUBSTR(t_codsg,1,5) THEN
                l_habilitation := 'vrai';
                exit;
        END IF;

    ELSE

     -- ********************************************
     -- cas 6 : habilitation  un BDDPG complet
     -- ********************************************
        -- Comparaison du groupe saisie (complet ou partiel) et celui de son perimetre
        -- Comparaison du pole saisie (complet ou partiel) et celui de son perimetre
        IF t_codsg = '*******' THEN
            l_habilitation := 'vrai';
            exit;

        ELSIF SUBSTR(t_codsg,2,6) = '******' THEN
            IF SUBSTR(c_groupe,1,1) = SUBSTR(t_codsg,1,1) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,3,5) = '*****' THEN
            IF SUBSTR(c_groupe,1,2) = SUBSTR(t_codsg,1,2) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,4,4) = '****' THEN
            IF SUBSTR(c_groupe,1,3) = SUBSTR(t_codsg,1,3) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,5,3) = '***' THEN
            IF SUBSTR(c_groupe,1,4) = SUBSTR(t_codsg,1,4) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,6,2) = '**' THEN
            IF SUBSTR(c_groupe,1,5) = SUBSTR(t_codsg,1,5) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,7,1) = '*' THEN
            IF SUBSTR(c_groupe,1,6) = SUBSTR(t_codsg,1,6) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        -- aucune '*'
        ELSE
            IF c_groupe = t_codsg THEN
                l_habilitation := 'vrai';
                EXIT;
            END IF;
        END IF;

    END IF;
    END IF;
    END IF;
    END IF;
    END IF;

    END LOOP;

    IF l_habilitation='faux' THEN
        IF ( LENGTH(RTRIM(t_codsg,'*')) >= 6 AND LENGTH(RTRIM(t_codsg,'*')) <= 7 ) THEN
        -- Vous n'tes pas habilit  ce groupe
        /*COMMENTED FOR BIP-36 IMPLEMENTATION*/
            /*pack_global.recuperer_message(20329, NULL, NULL, NULL, l_msg);
                             raise_application_error(-20329,l_msg);*/
                             NULL;
        ELSE
            IF  ( LENGTH(RTRIM(t_codsg,'*')) >= 4 AND LENGTH(RTRIM(t_codsg,'*')) <= 5 ) THEN
              -- Vous n'tes pas habilit  ce ple
                  pack_global.recuperer_message(20328, NULL, NULL, NULL, l_msg);
                                raise_application_error(-20328,l_msg);
            ELSE
                IF  ( LENGTH(RTRIM(t_codsg,'*')) >= 1 AND  LENGTH(RTRIM(t_codsg,'*')) <= 3) THEN
                    -- Vous n'tes pas habilit  ce dpartement
                    pack_global.recuperer_message(20327, NULL, NULL, NULL, l_msg);
                    raise_application_error(-20327,l_msg);
                ELSE
                    -- Vous n'tes pas habilit  toute la BIP
                    pack_global.recuperer_message(20357, NULL, NULL, NULL, l_msg);
                    raise_application_error(-20357,l_msg);
                END IF;
             END IF;
        END IF;
    END IF;

  END verif_habili_me;

-------------------------------------------------------------------------------------------------------------------------
-- ******************************************************************************************************************* --
-- FAD PPM 63560 : Reproduction de la procdure verif_habili_me pour vrifier les habilitations des DPG ouverts et ferms
-- dans le cadre du besoin de la PPM 63560
-- ******************************************************************************************************************* --
-------------------------------------------------------------------------------------------------------------------------
  PROCEDURE habili_me_dpg_ouv_fer( p_codsg   IN VARCHAR2,
                 p_global  IN VARCHAR2,
                 p_message OUT VARCHAR2 ) IS

 -- Cration du curseur qui ramne tous les BDDPG du primtre de l'utilisateur
 --  CURSOR cur_bddpg (p_perimetre IN number) IS
 --    select codbddpg, codhabili
 --    from detail_perimetre_me
 --    where codperime=p_perimetre
 --    order by codbddpg;

 -- Variables qui contiennent un BDDPG et le code d'habilitation
  codbddpg            VARCHAR2(25);
  codhabili            VARCHAR2(15);

  l_perimetre          VARCHAR2(1000);


  c_branche         VARCHAR2(10);
  c_direction         VARCHAR2(10);
  c_departement     VARCHAR2(10);
  c_pole             VARCHAR2(10);
  c_groupe             VARCHAR2(10);
  --l_dpg             VARCHAR2(10);
  l_habilitation    VARCHAR2(10);
  l_msg             VARCHAR2(1024);
  l_saisi             VARCHAR2(15);
  pos_bddpg            INTEGER;
  pos_bddpg_suiv    INTEGER;
  nb_bddpg            INTEGER;
  l_perimTermine    BOOLEAN;
  t_req_br          VARCHAR2(1000);
  t_req_dir         VARCHAR2(1000);

  c_br              RefCurTyp;
  t_br              NUMBER;

  c_dir             RefCurTyp;
  t_dir             NUMBER;
  t_codsg           VARCHAR2(7);
  l_menutil         VARCHAR2(50);

  BEGIN
    l_msg:=p_message ;
    l_msg:='';
    l_habilitation := 'faux';
    -- retrouver le primtre me de l'utilisateur
    l_perimetre := pack_global.lire_globaldata(p_global).perime;
    -- On complete a gauche par 0 sur 7 position
    t_codsg := LPAD(p_codsg,7,'0');

    -- Si le codsg est null on le remplace par *******
    IF t_codsg IS NULL THEN
        t_codsg := '*******';
    END IF;
    IF t_codsg = '' THEN
        t_codsg := '*******';
    END IF;

  -- **************************************************************
  -- 0) Controle du perim RTFE de l'utilisateur
  -- ***************************************************************
  IF (l_perimetre is null or trim(l_perimetre) = '') THEN

        NULL;

  ELSE
        IF ( VERIF_PERIM_ME ( P_GLOBAL ) = 'KO' ) THEN

            -- Votre primtre ME est invalide, veuillez contacter la MO.
            pack_global.recuperer_message(21240, NULL, NULL, NULL, l_msg);
            raise_application_error(-20327,l_msg);

        END IF;

  END IF;


  -- **************************************************************
  -- 1) Vrification de l'existence du code DPG demand
  -- ***************************************************************

      IF (t_codsg!='*******' )  THEN
    If ( pack_utile.f_verif_dpg(t_codsg)= false ) then -- Message Dep/pole inconnu
        pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);
         End if;
     END IF;

  -- *********************************************************************************
  -- 2) Vrification de l'habilitation de l'utilisateur par rapport  son primtre
  -- *********************************************************************************


    if substr(t_codsg,4,4)='****' then --un dpartement
        l_saisi :='dpt';
    else
        if substr(t_codsg,6,2)='**' then --un ple
            l_saisi :='pole';
        else
            if t_codsg!='*******' then --un groupe
                l_saisi :='groupe';
            else
                l_saisi :='all';
            end if;
        end if;
    end if;


    -- On initialise les paramtrers de la boucle while comptant le nombre de BDDPG du primtre
    pos_bddpg := 0;
    nb_bddpg := 0;
    pos_bddpg_suiv := 0;
    l_perimTermine := false;

    -- Test si perimetre ME est vide on ne va pas plus loin
    if (l_perimetre is null or trim(l_perimetre) = '') then
        l_perimTermine := true;
    end if ;


    -- Tant qu'il y a des bddpg dans le primtre, on tourne.
    WHILE NOT (l_perimTermine) LOOP

      --On met  jour les paramtres identifiant les BDDPG du primtre ME.
      pos_bddpg := pos_bddpg_suiv + 1;
      nb_bddpg := nb_bddpg + 1;
      pos_bddpg_suiv := INSTR(l_perimetre, ',', 1, nb_bddpg);

      IF pos_bddpg_suiv = 0 THEN
         l_perimTermine := true;
      END IF;

      --On met  jour le BDDPG courant
      --Si c'est le dernier, on prend la longueur de chane du primtre - la position de la virgule
      --Sinon on prend la position du suivant - la position de l'actuel
      IF l_perimTermine THEN
         codbddpg := SUBSTR(l_perimetre, pos_bddpg, LENGTH(l_perimetre)-pos_bddpg + 1);
      ELSE
         codbddpg := SUBSTR(l_perimetre, pos_bddpg, pos_bddpg_suiv-pos_bddpg);
      END IF;

      -- On trouve le codhabili en fonction du format du BDDPG
    if codbddpg= '00000000000' then
       codhabili :='all';
    else
      if substr(codbddpg,3,9)='000000000' then --une branche
          codhabili :='br';
      else
         if substr(codbddpg,5,7)='0000000' then --une direction
            codhabili :='dir';
         else
          if substr(codbddpg,8,4)='0000' then --un dpartement
              codhabili :='dpt';
          else
            if substr(codbddpg,10,2)='00' then --un ple
                codhabili :='pole';
            else
                if substr(codbddpg,1,11) !='00000000000' then --un groupe
                    codhabili :='tout';
                end if;
            end if;
          end if;
         end if;
      end if;
    end if;
    -- On rcupre les diffrentes composantes du bddpg
    c_branche     := SUBSTR(codbddpg,1,2);              --03
    c_direction     := SUBSTR(codbddpg,3,2);        --14
    c_departement := SUBSTR(codbddpg,1,7);        --0314016
    c_pole     := SUBSTR(codbddpg,5,5);        --01616
    c_groupe     := SUBSTR(codbddpg,5,7);        --0161612

    t_req_br := 'SELECT 1 FROM struct_info s, directions d WHERE 1=1 ';
    t_req_br := t_req_br || ' AND LPAD(s.coddep,3,0) LIKE ''' || SUBSTR(REPLACE(t_codsg,'*','%'),1,3) || '''';
    t_req_br := t_req_br || ' AND LPAD(d.codbr,2,0) = ' || c_branche ;
    t_req_br := t_req_br || ' AND s.coddir=d.coddir ';
    t_req_br := t_req_br || ' AND ROWNUM=1';

    t_req_dir := 'SELECT 1 FROM struct_info s, directions d WHERE 1=1 ';
    t_req_dir := t_req_dir || ' AND LPAD(s.coddep,3,0) LIKE ''' || SUBSTR(REPLACE(t_codsg,'*','%'),1,3) || '''';
    t_req_dir := t_req_dir || ' AND LPAD(d.codbr,2,0) = ' || c_branche ;
    t_req_dir := t_req_dir || ' AND LPAD(d.coddir,2,0) = ' || c_direction ;
    t_req_dir := t_req_dir || ' AND s.coddir=d.coddir ';
    t_req_dir := t_req_dir || ' AND ROWNUM=1';

     -- Cas o on veut tout (*******)
    IF (l_saisi='all' and codhabili='all') THEN
            l_habilitation := 'vrai';
        EXIT;
    END IF;

    -- ******************************************
           -- cas 1 : habilitation  toute la BIP
    -- ******************************************
    IF codhabili='all' THEN
        --dbms_output.put_line('Vous tes habilit  toute la BIP  ');
        l_habilitation := 'vrai';

        EXIT;
    ELSE
     -- ******************************************
     -- cas 2 : habilitation  toute une branche
     -- ******************************************
    IF codhabili='br' THEN

        -- Rechercher la branche du departement saisie (complet ou partiel) et comparer avec celui de son perimetre
        OPEN c_br FOR t_req_br;
        FETCH c_br INTO t_br;
        IF c_br%FOUND THEN
            l_habilitation := 'vrai';
            CLOSE c_br;
            EXIT;
        END IF;

    ELSE
     -- ********************************************
     -- cas 3 : habilitation  toute une direction
     -- ********************************************
    if codhabili='dir' then

        -- Rechercher la direction du departement saisie (complet ou partiel) et comparer avec celui de son perimetre
        OPEN c_dir FOR t_req_dir;
        FETCH c_dir INTO t_dir;
        IF c_dir%FOUND THEN
            l_habilitation := 'vrai';
            CLOSE c_dir;
            EXIT;
        END IF;
        CLOSE c_dir;

    ELSE
     -- ********************************************
     -- cas 4 : habilitation  tout un dpartement
     -- ********************************************
    if codhabili='dpt' then
        -- Comparaison du dept saisie (complet ou partiel) et celui de son perimetre

        IF t_codsg = '*******' THEN
            l_habilitation := 'vrai';
            exit;

        ELSIF SUBSTR(t_codsg,2,6) = '******' THEN
            IF SUBSTR(c_groupe,1,1) = SUBSTR(t_codsg,1,1) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,3,5) = '*****' THEN
            IF SUBSTR(c_groupe,1,2) = SUBSTR(t_codsg,1,2) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(c_groupe,1,3) = SUBSTR(t_codsg,1,3) THEN
                l_habilitation := 'vrai';
                exit;
        END IF;

    ELSE
      -- ********************************************
     -- cas 5 : habilitation  tout un pole
     -- ********************************************
    IF codhabili='pole' THEN

        -- Comparaison du pole saisie (complet ou partiel) et celui de son perimetre
        IF t_codsg = '*******' THEN
            l_habilitation := 'vrai';
            exit;

        ELSIF SUBSTR(t_codsg,2,6) = '******' THEN
            IF SUBSTR(c_groupe,1,1) = SUBSTR(t_codsg,1,1) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,3,5) = '*****' THEN
            IF SUBSTR(c_groupe,1,2) = SUBSTR(t_codsg,1,2) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,4,4) = '****' THEN
            IF SUBSTR(c_groupe,1,3) = SUBSTR(t_codsg,1,3) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,5,3) = '***' THEN
            IF SUBSTR(c_groupe,1,4) = SUBSTR(t_codsg,1,4) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(c_groupe,1,5) = SUBSTR(t_codsg,1,5) THEN
                l_habilitation := 'vrai';
                exit;
        END IF;

    ELSE

     -- ********************************************
     -- cas 6 : habilitation  un BDDPG complet
     -- ********************************************
        -- Comparaison du groupe saisie (complet ou partiel) et celui de son perimetre
        -- Comparaison du pole saisie (complet ou partiel) et celui de son perimetre
        IF t_codsg = '*******' THEN
            l_habilitation := 'vrai';
            exit;

        ELSIF SUBSTR(t_codsg,2,6) = '******' THEN
            IF SUBSTR(c_groupe,1,1) = SUBSTR(t_codsg,1,1) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,3,5) = '*****' THEN
            IF SUBSTR(c_groupe,1,2) = SUBSTR(t_codsg,1,2) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,4,4) = '****' THEN
            IF SUBSTR(c_groupe,1,3) = SUBSTR(t_codsg,1,3) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,5,3) = '***' THEN
            IF SUBSTR(c_groupe,1,4) = SUBSTR(t_codsg,1,4) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,6,2) = '**' THEN
            IF SUBSTR(c_groupe,1,5) = SUBSTR(t_codsg,1,5) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        ELSIF SUBSTR(t_codsg,7,1) = '*' THEN
            IF SUBSTR(c_groupe,1,6) = SUBSTR(t_codsg,1,6) THEN
                l_habilitation := 'vrai';
                exit;
            END IF;
        -- aucune '*'
        ELSE
            IF c_groupe = t_codsg THEN
                l_habilitation := 'vrai';
                EXIT;
            END IF;
        END IF;

    END IF;
    END IF;
    END IF;
    END IF;
    END IF;

    END LOOP;

    IF l_habilitation='faux' THEN
        IF ( LENGTH(RTRIM(t_codsg,'*')) >= 6 AND LENGTH(RTRIM(t_codsg,'*')) <= 7 ) THEN
        -- Vous n'tes pas habilit  ce groupe
            pack_global.recuperer_message(20329, NULL, NULL, NULL, l_msg);
                             raise_application_error(-20329,l_msg);
        ELSE
            IF  ( LENGTH(RTRIM(t_codsg,'*')) >= 4 AND LENGTH(RTRIM(t_codsg,'*')) <= 5 ) THEN
              -- Vous n'tes pas habilit  ce ple
                  pack_global.recuperer_message(20328, NULL, NULL, NULL, l_msg);
                                raise_application_error(-20328,l_msg);
            ELSE
                IF  ( LENGTH(RTRIM(t_codsg,'*')) >= 1 AND  LENGTH(RTRIM(t_codsg,'*')) <= 3) THEN
                    -- Vous n'tes pas habilit  ce dpartement
                    pack_global.recuperer_message(20327, NULL, NULL, NULL, l_msg);
                    raise_application_error(-20327,l_msg);
                ELSE
                    -- Vous n'tes pas habilit  toute la BIP
                    pack_global.recuperer_message(20357, NULL, NULL, NULL, l_msg);
                    raise_application_error(-20357,l_msg);
                END IF;
             END IF;
        END IF;
    END IF;

  END habili_me_dpg_ouv_fer;

-------------------------------------------------------------------------------------------------------------------------
-- =====================================================================================================================
-------------------------------------------------------------------------------------------------------------------------
  PROCEDURE verif_habili_me_old( p_codsg   IN VARCHAR2,
                 p_global  IN VARCHAR2,
                 p_message OUT VARCHAR2 ) IS

 -- Cration du curseur qui ramne tous les BDDPG du primtre de l'utilisateur
 --  CURSOR cur_bddpg (p_perimetre IN number) IS
 --    select codbddpg, codhabili
 --    from detail_perimetre_me
 --    where codperime=p_perimetre
 --    order by codbddpg;

 -- Variables qui contiennent un BDDPG et le code d'habilitation
  codbddpg    VARCHAR2(25);
  codhabili    VARCHAR2(15);

  l_perimetre       varchar2(1000);
  l_branche      varchar2(10);
  l_direction      varchar2(10);
  l_departement  varchar2(10);
  l_pole      varchar2(10);
  l_groupe      varchar2(10);
  c_branche      varchar2(10);
  c_direction      varchar2(10);
  c_departement  varchar2(10);
  c_pole      varchar2(10);
  c_groupe      varchar2(10);
  l_dpg          varchar2(10);
  l_habilitation varchar2(10);
  l_msg          varchar2(1024);
  l_saisi      varchar2(15);
  pos_bddpg     integer;
  pos_bddpg_suiv integer;
  nb_bddpg     integer;
  l_perimTermine boolean;

  BEGIN
    l_msg:=p_message ;
    l_msg:='';
    l_habilitation := 'faux';

  -- **************************************************************
  -- 1) Vrification de l'existence du code DPG demand
  -- ***************************************************************

      IF (p_codsg!='*******' )  THEN
    If ( pack_utile.f_verif_dpg(LPAD(p_codsg, 7, '0'))= false ) then -- Message Dep/pole inconnu
        pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);
         End if;
     END IF;
  -- *********************************************************************************
  -- 2) Vrification de l'habilitation de l'utilisateur par rapport  son primtre
  -- *********************************************************************************

    -- retrouver le primtre me de l'utilisateur
    l_perimetre := pack_global.lire_globaldata(p_global).perime;


       -- Remplacer les '*' du code DPG par des 0 et remet le code sur 7 caractres
    l_dpg := LPAD(REPLACE(p_codsg,'*','0'),7,'0');

    if substr(l_dpg,4,4)='0000' then --un dpartement
        l_saisi :='dpt';
    else
        if substr(l_dpg,6,2)='00' then --un ple
            l_saisi :='pole';
        else
            if l_dpg!='0000000' then --un groupe
                l_saisi :='groupe';
            else
                l_saisi :='all';
            end if;
        end if;
    end if;


    -- Retrouver la direction et la branche du code DPG
     IF (p_codsg!='*******' )  THEN
    BEGIN
      select distinct lpad(d.codbr,2,0), lpad(d.coddir,2,0)
        into l_branche     , l_direction
      from struct_info s, directions d
      where ( s.codsg=to_number(l_dpg) or s.coddeppole=to_number(substr(l_dpg,1,5)) or s.coddep=to_number(substr(l_dpg,1,3)) )
      and s.coddir=d.coddir
      and s.topfer='O'
      and rownum=1;


      l_departement := l_branche||l_direction||SUBSTR(l_dpg,1,3);
      l_pole     := SUBSTR(l_dpg,1,5);
      l_groupe     := l_dpg;

--dbms_output.put_line(l_perimetre||', '||l_branche||', '||l_direction||', '||l_departement);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN   --'Le codsg n''est rattach  aucune direction'
            pack_global.recuperer_message(20356,'%s1', 'codsg', NULL, l_msg);
                       raise_application_error(-20356,l_msg);
    END;
     END IF;

    -- On initialise les paramtrers de la boucle while comptant le nombre de BDDPG du primtre
    pos_bddpg := 0;
    nb_bddpg := 0;
    pos_bddpg_suiv := 0;
    l_perimTermine := false;

    -- Test si perimetre ME est vide on ne va pas plus loin
    if (l_perimetre is null or trim(l_perimetre) = '') then
        l_perimTermine := true;
    end if ;


    -- Tant qu'il y a des bddpg dans le primtre, on tourne.
    WHILE NOT (l_perimTermine) LOOP

      --On met  jour les paramtres identifiant les BDDPG du primtre ME.
      pos_bddpg := pos_bddpg_suiv + 1;
      nb_bddpg := nb_bddpg + 1;
      pos_bddpg_suiv := INSTR(l_perimetre, ',', 1, nb_bddpg);

      IF pos_bddpg_suiv = 0 THEN
         l_perimTermine := true;
      END IF;

      --On met  jour le BDDPG courant
      --Si c'est le dernier, on prend la longueur de chane du primtre - la position de la virgule
      --Sinon on prend la position du suivant - la position de l'actuel
      IF l_perimTermine THEN
         codbddpg := SUBSTR(l_perimetre, pos_bddpg, LENGTH(l_perimetre)-pos_bddpg + 1);
      ELSE
         codbddpg := SUBSTR(l_perimetre, pos_bddpg, pos_bddpg_suiv-pos_bddpg);
      END IF;

      -- On trouve le codhabili en fonction du format du BDDPG
    if codbddpg= '00000000000' then
       codhabili :='all';
    else
      if substr(codbddpg,3,9)='000000000' then --une branche
          codhabili :='br';
      else
         if substr(codbddpg,5,7)='0000000' then --une direction
            codhabili :='dir';
         else
          if substr(codbddpg,8,4)='0000' then --un dpartement
              codhabili :='dpt';
          else
            if substr(codbddpg,10,2)='00' then --un ple
                codhabili :='pole';
            else
                if substr(codbddpg,1,11) !='00000000000' then --un groupe
                    codhabili :='tout';
                end if;
            end if;
          end if;
         end if;
      end if;
    end if;

      -- On rcupre les diffrentes composantes du bddpg
       c_branche     := SUBSTR(codbddpg,1,2);              --03
      c_direction     := SUBSTR(codbddpg,3,2);        --14
      c_departement := SUBSTR(codbddpg,1,7);        --0314016
      c_pole     := SUBSTR(codbddpg,5,5);        --01616
      c_groupe     := SUBSTR(codbddpg,5,7);        --0161612

      --dbms_output.put_line(l_perimetre||', '||l_dpg||', '||c_branche||', '||c_direction||', '||c_departement||', '||c_pole||', '||c_groupe||', '||codhabili);

      -- Cas o on veut tout (*******)
        if (l_saisi='all' and codhabili='all') then
             l_habilitation := 'vrai';
            exit;
        end if;

       -- ******************************************
          -- cas 1 : habilitation  toute la BIP
      -- ******************************************
        if codhabili='all' then
            --dbms_output.put_line('Vous tes habilit  toute la BIP  ');
            l_habilitation := 'vrai';

            exit;
        else
      -- ******************************************
      -- cas 2 : habilitation  toute une branche
      -- ******************************************
        if codhabili='br' then
            if c_branche=l_branche then
            --dbms_output.put_line('Vous tes habilit  toute la branche : '||l_branche);
                l_habilitation := 'vrai';
                exit;
            end if;
        --dbms_output.put_line('Votre habilitation branche est  :'||c_branche||', et non : '||l_branche);

        else
      -- ********************************************
      -- cas 3 : habilitation  toute une direction
      -- ********************************************
        if codhabili='dir' then
            if c_direction=l_direction then
            --dbms_output.put_line('Vous tes habilit  toute la direction : '||l_direction);
                l_habilitation := 'vrai';
                exit;
            end if;
        --dbms_output.put_line('Votre habilitation direction est : '||c_direction||', et non :'||l_direction);

        else
      -- ********************************************
      -- cas 4 : habilitation  tout un dpartement
      -- ********************************************
        if codhabili='dpt' then
            if c_departement=l_departement then
            --dbms_output.put_line('Vous tes habilit  tout le departement : '||l_departement);
                l_habilitation := 'vrai';
                exit;
            end if;
        --dbms_output.put_line('Votre habilitation dpartement est '||c_departement||', et non :'||l_departement);

        else
       -- ********************************************
      -- cas 5 : habilitation  tout un pole
      -- ********************************************
        if codhabili='pole' then
            if c_pole=l_pole then
            --dbms_output.put_line('Vous tes habilit  tout le pole : '||l_pole);
                l_habilitation := 'vrai';
                exit;
            /*else
            -- cas habilitation  un pole (0301000) avec un choix (030****)
                if (l_saisi='dpt' and substr(c_pole,1,2)=substr(l_pole,1,2)) then
                    --dbms_output.put_line('Vous tes habilit  tout le pole : '||l_pole);
                    l_habilitation := 'vrai';
                    exit;
                end if;*/
            end if;
        else
      -- ********************************************
      -- cas 6 : habilitation  un BDDPG complet
      -- ********************************************

            if( c_groupe=l_groupe )then
                --dbms_output.put_line('Vous tes habilit au groupe : '||l_groupe);
                l_habilitation := 'vrai';
                exit;
              end if;

            end if;
        end if;
        end if;
        end if;
        end if;

    END LOOP;

     --dbms_output.put_line(l_habilitation);
    If l_habilitation='faux' then
        if ( length(rtrim(p_codsg,'*'))=7 ) then
        -- Vous n'tes pas habilit  ce groupe
            pack_global.recuperer_message(20329, NULL, NULL, NULL, l_msg);
                       raise_application_error(-20329,l_msg);
        else
          if  ( length(rtrim(p_codsg,'*'))=5 ) then
           -- Vous n'tes pas habilit  ce ple
               pack_global.recuperer_message(20328, NULL, NULL, NULL, l_msg);
                       raise_application_error(-20328,l_msg);
          else
             if  ( length(rtrim(p_codsg,'*'))=3) then
             -- Vous n'tes pas habilit  ce dpartement
            pack_global.recuperer_message(20327, NULL, NULL, NULL, l_msg);
                       raise_application_error(-20327,l_msg);
             else
             -- Vous n'tes pas habilit  toute la BIP
            pack_global.recuperer_message(20357, NULL, NULL, NULL, l_msg);
                       raise_application_error(-20357,l_msg);
             end if;
          end if;
        end if;
    End if;


  END verif_habili_me_old;

-------------------------------------------------------------------------------------------------------------------------
-- =====================================================================================================================
-------------------------------------------------------------------------------------------------------------------------
FUNCTION fhabili_me ( p_codsg   IN VARCHAR2,
            p_global  IN VARCHAR2) RETURN VARCHAR2 IS


  codbddpg    VARCHAR2(25);
  codhabili    VARCHAR2(15);

  l_coduser      varchar2(255);
  l_perimetre       varchar2(1000);

  l_branche      varchar2(10);
  l_direction      varchar2(10);
  l_departement  varchar2(10);
  l_pole      varchar2(10);
  l_groupe      varchar2(10);
  c_branche      varchar2(10);
  c_direction      varchar2(10);
  c_departement  varchar2(10);
  c_pole      varchar2(10);
  c_groupe      varchar2(10);
  l_dpg          varchar2(10);
  l_habilitation varchar2(10);
  l_msg          varchar2(1024);

  pos_bddpg     integer;
  pos_bddpg_suiv integer;
  nb_bddpg     integer;
  l_perimTermine boolean;


  BEGIN

    l_msg:='';
    l_habilitation := 'faux';
  -- **************************************************************
  -- 1) Vrification de l'existence du code DPG demand
  -- **************************************************************
    If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu

        pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
                   raise_application_error(-20203,l_msg);
         End if;

    -- Si on trouve des '*' dans le code DPG demand - On sort
     IF (INSTR(p_codsg,'*',1,1) > 0) then
        pack_global.recuperer_message(20385, NULL, NULL, NULL, l_msg);
                   raise_application_error(-20385,l_msg);
         End if;

  -- *********************************************************************************
  -- 2) Vrification de l'habilitation de l'utilisateur par rapport  son primtre
  -- *********************************************************************************
    -- retrouver le code primtre de l'utilisateur
    l_perimetre := pack_global.lire_globaldata(p_global).perime;


    -- Retrouver la direction et la branche du code DPG
    BEGIN
      select distinct d.codbr, d.coddir
        into l_branche     , l_direction
      from struct_info s, directions d
      where s.codsg=to_number(p_codsg)
      and s.coddir=d.coddir;

      l_departement := LPAD(l_branche,2,0)||LPAD(l_direction,2,0)||SUBSTR(LPAD(p_codsg,7,'0'),1,3);
      l_pole     := SUBSTR(LPAD(p_codsg,7,'0'),1,5);
      l_groupe     := LPAD(p_codsg,7,'0');

        --dbms_output.put_line(l_perimetre||', '||l_branche||', '||l_direction||', '||l_departement);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN   --'Le codsg n''est rattach  aucune direction'
            pack_global.recuperer_message(20356,'%s1', 'codsg', NULL, l_msg);
                       raise_application_error(-20356,l_msg);
    END;


    -- On initialise les paramtrers de la boucle while comptant le nombre de BDDPG du primtre
    pos_bddpg := 0;
    nb_bddpg := 0;
    pos_bddpg_suiv := 0;
    l_perimTermine := false;

    -- Test si perimetre ME est vide on ne va pas plus loin
    if (l_perimetre is null or trim(l_perimetre) = '') then
        l_perimTermine := true;
    end if ;

    -- Tant qu'il y a des bddpg dans le primtre, on tourne.
    WHILE (NOT l_perimTermine) LOOP

      --On met  jour les paramtres identifiant les BDDPG du primtre ME.
      pos_bddpg := pos_bddpg_suiv + 1;
      nb_bddpg := nb_bddpg + 1;
      pos_bddpg_suiv := INSTR(l_perimetre, ',', 1, nb_bddpg);

      IF pos_bddpg_suiv = 0 THEN
         l_perimTermine := true;
      END IF;

      --On met  jour le BDDPG courant
      --Si c'est le dernier, on prend la longueur de chane du primtre - la position de la virgule
      --Sinon on prend la position du suivant - la position de l'actuel
      IF l_perimTermine THEN
         codbddpg := SUBSTR(l_perimetre, pos_bddpg, LENGTH(l_perimetre)-pos_bddpg + 1);
      ELSE
         codbddpg := SUBSTR(l_perimetre, pos_bddpg, pos_bddpg_suiv-pos_bddpg);
      END IF;



      -- On trouve le codhabili en fonction du format du BDDPG
    if codbddpg= '00000000000' then -- Toute la BIP
       codhabili :='all';
    else
      if substr(codbddpg,3,9)='000000000' then --une branche
          codhabili :='br';
      else
         if substr(codbddpg,5,7)='0000000' then --une direction
            codhabili :='dir';
         else
          if substr(codbddpg,8,4)='0000' then --un dpartement
              codhabili :='dpt';
          else
            if substr(codbddpg,10,2)='00' then --un ple
                codhabili :='pole';
            else
                if substr(codbddpg,1,11) !='00000000000' then --un groupe
                    codhabili :='tout';
                end if;
            end if;
          end if;
         end if;
      end if;
    end if;

      -- On rcupre les diffrentes composantes du bddpg
          c_branche     := SUBSTR(codbddpg,1,2);              --03
      c_direction     := SUBSTR(codbddpg,3,2);        --14
      c_departement := SUBSTR(codbddpg,1,7);        --0314016
      c_pole     := SUBSTR(codbddpg,5,5);        --01616
      c_groupe     := SUBSTR(codbddpg,5,7);        --0161612

--dbms_output.put_line(l_perimetre||', '||l_dpg||', '||c_branche||', '||c_direction||', '||c_departement||', '||c_pole||', '||c_groupe);
       -- ******************************************
          -- cas 1 : habilitation  toute la BIP
      -- ******************************************
        if codhabili='all' then
            --dbms_output.put_line('Vous tes habilit  toute la BIP  ');
            l_habilitation := 'vrai';

            exit;
        else
      -- ******************************************
      -- cas 2 : habilitation  toute une branche
      -- ******************************************
        if codhabili='br' then
            if to_number(c_branche) = to_number(l_branche) then
            --dbms_output.put_line('Vous tes habilit  toute la branche : '||l_branche);
                l_habilitation := 'vrai';
                exit;
            end if;
        --dbms_output.put_line('Votre habilitation branche est  :'||c_branche||', et non : '||l_branche);

        else
      -- ********************************************
      -- cas 3 : habilitation  toute une direction
      -- ********************************************
        if codhabili='dir' then
            if to_number(c_direction) = to_number(l_direction) then
            --dbms_output.put_line('Vous tes habilit  toute la direction : '||l_direction);
                l_habilitation := 'vrai';
                exit;
            end if;
        --dbms_output.put_line('Votre habilitation direction est : '||c_direction||', et non :'||l_direction);

        else
      -- ********************************************
      -- cas 4 : habilitation  tout un dpartement
      -- ********************************************
        if codhabili='dpt' then
            if to_number(c_departement) = to_number(l_departement) then
            --dbms_output.put_line('Vous tes habilit  tout le departement : '||l_departement);
                l_habilitation := 'vrai';
                exit;
            end if;
        --dbms_output.put_line('Votre habilitation dpartement est '||c_departement||', et non :'||l_departement);

        else
       -- ********************************************
      -- cas 5 : habilitation  tout un pole
      -- ********************************************
        if codhabili='pole' then
            if to_number(c_pole) = to_number(l_pole) then
            --dbms_output.put_line('Vous tes habilit  tout le pole : '||l_pole);
                l_habilitation := 'vrai';
                exit;
            end if;

        else
      -- ********************************************
      -- cas 6 : habilitation  un BDDPG complet
      -- ********************************************

            if to_number(c_groupe) = to_number(l_groupe ) then
                --dbms_output.put_line('Vous tes habilit au groupe : '||l_groupe);
                l_habilitation := 'vrai';
                exit;

            end if;
                    --dbms_output.put_line('Votre habilitation groupe est '||c_groupe||', et non :'||l_groupe);

            end if;
        end if;
        end if;
        end if;
        end if;

    END LOOP;

    return (l_habilitation);
END fhabili_me;

-- **************************************************************************************
-- Nom 		: verif_perim_me
-- Auteur 	: BSA
-- Description 	: Vrifie perim me RTFE de l'utilisateur
--                si tous les codes du perime me  sont inexistant alors KO
-- Paramtres 	: p_global (IN) contenant le code primtre de l'utilisateur
-- Retour	:  retourne 'KO' si tous les prerimetre me sont inexistant
--
-- **************************************************************************************

  FUNCTION verif_perim_me ( p_global  IN VARCHAR2) RETURN VARCHAR2 IS

    t_retour        VARCHAR2(15);
    l_perimetre     VARCHAR2(1000);
    t_table         t_array;
    t_trouve        BOOLEAN;

    CURSOR c_vue_perime ( t_perim VUE_DPG_PERIME.CODBDDPG%TYPE) IS
        SELECT CODBDDPG
        FROM VUE_DPG_PERIME
        WHERE CODBDDPG = t_perim;

    t_vue_perime c_vue_perime%ROWTYPE;

BEGIN

    t_trouve := FALSE;

    -- retrouver le primtre me de l'utilisateur
    l_perimetre := NVL(pack_global.lire_globaldata(p_global).perime,'00000000000') ;

    IF ( l_perimetre != '00000000000' ) THEN
        -- Controle pour chaque valeur du perim me son existance
        t_table := split(l_perimetre , ',');
        FOR I IN 1..t_table.COUNT LOOP

            OPEN c_vue_perime (t_table(I));
            FETCH c_vue_perime INTO t_vue_perime;
            IF ( c_vue_perime%FOUND ) THEN

                t_trouve := TRUE;
                CLOSE c_vue_perime;
                EXIT;

            END IF;
            CLOSE c_vue_perime;

        END LOOP;

    ELSE

        t_trouve := TRUE;

    END IF;

    IF t_trouve = TRUE THEN
        t_retour := 'OK';
    ELSE
        t_retour := 'KO';
    END IF;


    return t_retour;

END verif_perim_me;

-------------------------------------------------------------------------------------------------------------------------
-- =====================================================================================================================
-------------------------------------------------------------------------------------------------------------------------
 PROCEDURE select_verif_deppole_mens  (p_codsg     IN VARCHAR2,
                                  p_global    IN CHAR,
                                  p_libcodsg     OUT VARCHAR2,
                                  p_nbcurseur    OUT INTEGER,
                                  p_message      OUT VARCHAR2
                                 ) IS
      l_msg        VARCHAR2(512);
      l_libcodsg   VARCHAR2(100);
      l_pcoddp     VARCHAR2(10);
      l_coddep     CHAR(3);
      l_codpol     CHAR(2);

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';

      l_pcoddp := LPAD(p_codsg, 7, '0');

      l_coddep := substr(LPAD(p_codsg, 7, '0'),1,3);
      l_codpol := substr(LPAD(p_codsg, 7, '0'),4,2);


      IF (INSTR(l_coddep,'*',1,1) > 0) OR (INSTR(l_coddep,' ',1,1) > 0 )
         THEN  -- Il y a * = Tous les dep : on ne verifie pas l'existence du dep/pole
               l_libcodsg := 'Tous les Dep.';
            l_libcodsg := 'Tout le primtre';
         ELSE

               IF (LENGTH(l_codpol) IS NULL) OR (INSTR(l_codpol,'*',1,1) > 0) OR (INSTR(l_codpol,' ',1,1) > 0 )
                  THEN -- il y a * = Tous les pole, mais il faut verifier le dep
                     BEGIN
                        l_pcoddp := l_coddep || '__';
                        SELECT  sigdep INTO l_libcodsg   FROM struct_info
                         WHERE TO_CHAR(coddeppole, 'FM00000') like l_pcoddp AND ROWNUM <= 1;
                     EXCEPTION
                        WHEN OTHERS THEN -- Msg Code  Dep/Pole inconnu
                           pack_global.recuperer_message(20135, NULL, NULL, NULL, l_msg);
                           raise_application_error(-20135,l_msg);
                     END;
                  ELSE  -- il y a DEP et POLE , verifions !
             IF substr(p_codsg,6,2)='**' THEN
                         BEGIN
                            l_pcoddp := substr(LPAD(p_codsg, 7 , '0'),1,5) ;
                            SELECT  sigdep || '/' || sigpole INTO l_libcodsg   FROM struct_info
                             WHERE TO_CHAR(coddeppole, 'FM00000') = l_pcoddp AND ROWNUM <= 1;
                         EXCEPTION
                            WHEN OTHERS THEN -- Msg Code  Dep/Pole inconnu
                               pack_global.recuperer_message(20135, NULL, NULL, NULL, l_msg);
                               raise_application_error(-20135,l_msg);
                         END;
            ELSE
            BEGIN
                SELECT libdsg INTO l_libcodsg   FROM struct_info
                WHERE codsg = to_number(p_codsg) AND ROWNUM <= 1;
                         EXCEPTION
                            WHEN OTHERS THEN -- Msg Code  Dep/Pole inconnu
                               pack_global.recuperer_message(20135, NULL, NULL, NULL, l_msg);
                               raise_application_error(-20135,l_msg);

            END;
            END IF;
               END IF;

      END IF;

      -- ================================================================================
      -- OK le deppole existe : Verifier l'habilitation dep pole de l'utilisateur
      -- ================================================================================

      -- ====================================================================
      -- 12/02/2001 : Test appartenance du DPG au primtre de l'utilisateur
    -- 18/03/2002 MMC : on ne fait plus de verification sur l'appartenance
    -- du DPG au perimetre utilisateur. Ce controle s'effectue au niveau des
    -- etats, ce qui permet de lancer directement 1 etat avec tout le perimetre
    -- d'un utilisateur. (fiche 362)
         -- PLUS VRAI !!
       -- ==============================================================
       pack_habilitation.verif_habili_me(  p_codsg,p_global,l_msg  );

         p_libcodsg := 'LIBCODSG#' || l_libcodsg ;


   -- var vmsg varchar2(100)
   -- var p6   varchar2(50)
   -- exec pack_utile3A.verif_deppole_mens('15','IT5C530;;;;01;',:p6,:vmsg)

   END select_verif_deppole_mens;
-------------------------------------------------------------------------------------------------------------------------
-- =====================================================================================================================
-------------------------------------------------------------------------------------------------------------------------
 FUNCTION fverif_habili_mo( p_perimo IN VARCHAR2,
                 p_direction IN client_mo.clicode%TYPE )
                RETURN BOOLEAN IS
  l_exist number;
  l_dir varchar2(15);
  l_msg varchar2(1024);
  l_habilitation varchar2(10);

  l_bdclicode         VARCHAR2(10);
  l_branches         VARCHAR2(50);
  l_directions        VARCHAR2(50);
  l_clicodes         VARCHAR2(255);
  nb_bdclicodes        INTEGER;
  pos_bdclicode        INTEGER;
  pos_bdclicode_suiv INTEGER;

  BEGIN

    -- Existence de la direction
     BEGIN

        select 1 into l_exist
        from client_mo
        where  rtrim(ltrim(clicode))=rtrim(ltrim(p_direction));

         EXCEPTION
    WHEN NO_DATA_FOUND THEN -- Direction inexistante
         pack_global.recuperer_message( 20505, '%s1', p_direction, NULL, l_msg);
             raise_application_error( -20505, l_msg );
         END;

    -- Appartenance de la direction ou dpartment au primtre MO choisi
    BEGIN

          --On met toutes les branches globales(la branche suivie de '0000000') dans l_branches
          -- Les directions globales (la direction suivie de '00000') dans l_dir
          --et la liste des clicodes du primtre dans l_clicodes
          -- On initialise les paramtrers de la boucle while comptant le nombre de bdclicode du primtre
        pos_bdclicode := 1;
        nb_bdclicodes := 1;
        pos_bdclicode_suiv := INSTR(p_perimo, ',', 1, nb_bdclicodes);
        l_branches := '';
        l_directions := '';
        l_clicodes := '';

        -- Tant qu'il y a des clicodes dans le primtre, on boucle.
        WHILE (pos_bdclicode_suiv!=0) LOOP

            --On met  jour le CLICODE courant
            l_bdclicode := SUBSTR(p_perimo, pos_bdclicode, pos_bdclicode_suiv - pos_bdclicode);

            IF SUBSTR(l_bdclicode,3,7) = '0000000' THEN
               l_branches := l_branches || SUBSTR(l_bdclicode,1,2)||',';
            ELSIF SUBSTR(l_bdclicode,5,5) = '00000' THEN
               l_directions := l_directions || SUBSTR(l_bdclicode,3,2)||',';
            ELSE
               l_clicodes := l_clicodes || SUBSTR(l_bdclicode,5,5)||',';
            END IF;

            --On met  jour les paramtres identifiant les clicodes du primtre MO.
            pos_bdclicode := pos_bdclicode_suiv +1;
            nb_bdclicodes := nb_bdclicodes + 1;
            pos_bdclicode_suiv := INSTR(p_perimo, ',', 1, nb_bdclicodes);

          END LOOP;

        -- On gre le dernier code
        --On met  jour le dernier CLICODE
        l_bdclicode := SUBSTR(p_perimo, pos_bdclicode, LENGTH(p_perimo) - pos_bdclicode + 1);

        IF SUBSTR(l_bdclicode,3,7) = '0000000' THEN
           l_branches := l_branches || SUBSTR(l_bdclicode,1,2)||',';
        ELSIF SUBSTR(l_bdclicode,5,5) = '00000' THEN
           l_directions := l_directions || SUBSTR(l_bdclicode,3,2)||',';
        ELSE
           l_clicodes := l_clicodes || SUBSTR(l_bdclicode,5,5)||',';
        END IF;

        --On slctionne les clicodes pour lesquels
        --Le clicode est gal au clicode demand(p_direction)
        --Et pour lesquels, l'utilisateur est habilit

--        select clicode into l_dir
--        from client_mo cmo, directions d
--        where cmo.clidir=d.coddir
--          and (cmo.clicode = p_direction)
--          and ((INSTR(l_clicodes, LPAD(RTRIM(LTRIM(cmo.clicode)), 5, '0')) > 0)
--              or (INSTR(l_directions, LPAD(TO_CHAR(cmo.clidir),2,'0')) > 0)
--              or (INSTR(l_branches, LPAD(TO_CHAR(d.codbr),2,'0')) > 0))
--          and rownum < 2;
        select
            clicode into l_dir
        from
            vue_clicode_perimo cmo
        where
            cmo.clicode = p_direction
        and INSTR(p_perimo, cmo.bdclicode) > 0
        and rownum < 2;



    EXCEPTION
    WHEN NO_DATA_FOUND THEN -- La direction ne fait pas partie du primtre choisi
         return (false);
         END;

    return (true);

 END fverif_habili_mo;

 -- ==================================================================================
 -- verif_perimetre
 -- procedure pour verifier les habilitations de l'utilisateur
 -- si ****** : pas de contrle, c'est dans l'tat que l'on prendra tout son primtre
 -- ==================================================================================

PROCEDURE verif_perimetre (p_codsg     IN VARCHAR2,
                                  p_global    IN CHAR,
                                  p_libcodsg     OUT VARCHAR2,
                                  p_nbcurseur    OUT INTEGER,
                                  p_message      OUT VARCHAR2
                                 ) IS
      l_msg        VARCHAR2(512);
      l_libcodsg   VARCHAR2(100);
      l_pcoddp     VARCHAR2(10);
      l_coddep     CHAR(3);
      l_codpol     CHAR(2);

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';

      l_pcoddp := LPAD(p_codsg, 7, '0');

      l_coddep := substr(LPAD(p_codsg, 7, '0'),1,3);
      l_codpol := substr(LPAD(p_codsg, 7, '0'),4,2);


      IF (INSTR(l_coddep,'*',1,1) > 0) OR (INSTR(l_coddep,' ',1,1) > 0 )
         THEN  -- Il y a * = Tous les dep : on ne verifie pas l'existence du dep/pole
                l_libcodsg := 'Tous les Dep.';
        l_libcodsg := 'Tout le primtre';
         ELSE

               IF (LENGTH(l_codpol) IS NULL) OR (INSTR(l_codpol,'*',1,1) > 0) OR (INSTR(l_codpol,' ',1,1) > 0 )
                  THEN -- il y a * = Tous les pole, mais il faut verifier le dep
                     BEGIN
                        l_pcoddp := l_coddep || '__';
                        SELECT  sigdep INTO l_libcodsg   FROM struct_info
                         WHERE TO_CHAR(coddeppole, 'FM00000') like l_pcoddp AND ROWNUM <= 1;
                     EXCEPTION
                        WHEN OTHERS THEN -- Msg Code  Dep/Pole inconnu
                           pack_global.recuperer_message(20135, NULL, NULL, NULL, l_msg);
                           raise_application_error(-20135,l_msg);
                     END;
                  ELSE  -- il y a DEP et POLE , verifions !
             IF substr(p_codsg,6,2)='**' THEN
                         BEGIN
                            l_pcoddp := substr(LPAD(p_codsg, 7 , '0'),1,5) ;
                            SELECT  sigdep || '/' || sigpole INTO l_libcodsg   FROM struct_info
                             WHERE TO_CHAR(coddeppole, 'FM00000') = l_pcoddp AND ROWNUM <= 1;
                         EXCEPTION
                            WHEN OTHERS THEN -- Msg Code  Dep/Pole inconnu
                               pack_global.recuperer_message(20135, NULL, NULL, NULL, l_msg);
                               raise_application_error(-20135,l_msg);
                         END;
            ELSE
            BEGIN
                SELECT libdsg INTO l_libcodsg   FROM struct_info
                WHERE codsg = to_number(p_codsg) AND ROWNUM <= 1;
                         EXCEPTION
                            WHEN OTHERS THEN -- Msg Code  Dep/Pole inconnu
                               pack_global.recuperer_message(20135, NULL, NULL, NULL, l_msg);
                               raise_application_error(-20135,l_msg);

            END;
            END IF;
               END IF;
   END IF;


      -- ==============================================================
      -- Test appartenance du DPG au primtre de l'utilisateur
      -- ==============================================================
      IF (p_codsg!='*******' )  THEN
       pack_habilitation.verif_habili_me(  p_codsg,p_global,l_msg  );
      END IF;

         p_libcodsg := 'LIBCODSG#' || l_libcodsg ;

   END verif_perimetre;





PROCEDURE verif_habili_dpg_appli( p_codsg   IN VARCHAR2,
                                    p_airt    IN VARCHAR2,
                                  p_global  IN VARCHAR2,
                                   p_message OUT VARCHAR2 ) IS

    l_msg          varchar2(1024);
    appli_codsg       application.codsg%type;
    l_perim_me      VARCHAR2(1000);

    CURSOR c_hab_appli(p1_airt VARCHAR2, p_perim_me VARCHAR2 ) IS
        SELECT 1
        FROM ligne_bip l
        WHERE l.airt = p1_airt
            AND l.codsg IN (SELECT codsg FROM vue_dpg_perime where INSTR(p_perim_me, codbddpg) > 0 );

    t_hab_appli c_hab_appli%ROWTYPE;

BEGIN

    -- retrouver le primtre me de l'utilisateur
    l_perim_me := pack_global.lire_globaldata(p_global).perime;

    IF ( (p_codsg IS NOT NULL) AND (LENGTH(p_codsg)>0) ) THEN
       verif_habili_me(p_codsg, p_global, l_msg);
    END IF;

    IF ( (p_airt IS NOT NULL) AND (LENGTH(p_airt)>0) ) THEN

        BEGIN
            SELECT codsg
              INTO appli_codsg
              FROM application
             WHERE airt = p_airt;

        EXCEPTION
            WHEN NO_DATA_FOUND then
                   pack_global.recuperer_message(20733, NULL, NULL, NULL, l_msg);
                raise_application_error(-20733,l_msg);
        END;

        OPEN c_hab_appli(p_airt,l_perim_me);
        FETCH c_hab_appli INTO t_hab_appli;
        IF c_hab_appli%NOTFOUND THEN

            -- Votre primtre ne vous permet pas de visualiser les informations sur cette application.
            pack_global.recuperer_message(21246, NULL, NULL, NULL, l_msg);
            raise_application_error(-20733,l_msg);

        END IF;

        CLOSE c_hab_appli;

    END IF;

END verif_habili_dpg_appli;
-------------------------------------------------------------------------------------------------------------------------
-- =====================================================================================================================
-------------------------------------------------------------------------------------------------------------------------
PROCEDURE verif_dpg_centrefrais( p_codsg   IN VARCHAR2,
                                 p_centrefrais    IN VARCHAR2,
                                 p_global  IN VARCHAR2,
                                 p_message OUT VARCHAR2 ) IS

    l_msg          varchar2(1024);
    l_codsg        varchar2(1024);
    verif_codsg    varchar2(1024);
    l_centrefrais STRUCT_INFO.SCENTREFRAIS%TYPE;
    l_scentrefrais STRUCT_INFO.SCENTREFRAIS%TYPE;

BEGIN

     -- P_codsg est de la forme 'N******', 'NN*****', .... 'NNNNNNN'
     -- On formate sur 7 caracteres a gauche par 0 puis on supprime les *
     l_codsg := RTRIM(RTRIM(LPAD(p_codsg, 7, '0'),'*')) || '%';

     -- On test si le DPG existe
    BEGIN
        select codsg into verif_codsg
        from STRUCT_INFO
        where TO_CHAR(codsg,'FM0000000') like l_codsg
            and rownum = 1;

    EXCEPTION
        WHEN NO_DATA_FOUND then
               -- Code Dpartement/Ple/Groupe %s1 inexistant
              pack_global.recuperer_message(21080,'%s1', p_codsg, NULL, l_msg);
              raise_application_error(-20334, l_msg);
              WHEN OTHERS then
                 	raise_application_error(-20997, SQLERRM);
    END;

    -- si centre de frais diffrent de 0. 0 -> toutes la BIP
    IF p_centrefrais != 0 THEN
	    BEGIN
	        select scentrefrais
	          into l_scentrefrais
		      from STRUCT_INFO
		     where TO_CHAR(codsg,'FM0000000') like l_codsg
                and scentrefrais = p_centrefrais
                and rownum = 1;

		EXCEPTION
		    WHEN NO_DATA_FOUND then
                --msg:Ce DPG n'appartient pas  ce centre de frais
                pack_global.recuperer_message(21216, NULL, NULL, NULL, l_msg);
                raise_application_error(-20334, l_msg);
            WHEN OTHERS then
               	raise_application_error(-20997, SQLERRM);
		END;
    END IF;


END verif_dpg_centrefrais;

-------------------------------------------------------------------------------------------------------------------------
-- =====================================================================================================================
-- Vrification que l'utilisateur a le droit de consulter les informations de la ressource passe en paramtres :
--        * la ressource a une situation qui est, au moment de la demande, rattache  un DPG qui est dans le primtre ME de l'utilisateur; OU
--        * la ressource est parmi les CP ou subordonns immdiats, habilits dans le profil Saisie directe de l'utilisateur, s'il existe
-------------------------------------------------------------------------------------------------------------------------
PROCEDURE verif_perim_ressource( p_ident   IN VARCHAR2,
                                    p_global    IN VARCHAR2,
                                   p_message OUT VARCHAR2 ) IS
    l_msg          varchar2(1024);
    l_chefs_projet varchar2(10000);-- PPM 63485 : augmenter la taille  4000
    l_chefs_projet_ress varchar2(10000);-- PPM 63485 : augmenter la taille  4000
    l_perime       varchar2(1024);
    l_ident        varchar2(5);
    l_num          NUMBER(1);
    l_retour       varchar(1);
    l_menu         varchar2(5);

BEGIN
    l_menu := pack_global.LIRE_GLOBALDATA(p_global).menutil;
    if l_menu != 'DIR' THEN
        l_retour :=0;
        l_chefs_projet := pack_global.lire_globaldata(p_global).chefprojet;
        --KRA PPM 61776 debut
        l_chefs_projet_ress :='';
        IF INSTR(p_ident,'*') >0 THEN
          l_chefs_projet_ress := pack_global.get_liste_chefs_projet(p_ident);
          l_ident := substr(p_ident,0,length(p_ident)-1);
        ELSE
        l_ident := p_ident;
        END IF;
        --Fin KRA 61776
        BEGIN
            SELECT  count(*)
            INTO    l_num
            FROM    SITU_RESS sit
            WHERE   (INSTR(l_chefs_projet,to_char(sit.ident,'FM00000'))>0 OR INSTR(l_chefs_projet,to_char(sit.cpident,'FM00000'))>0 OR INSTR(l_chefs_projet_ress,to_char(sit.ident,'FM00000'))>0)
            AND     to_char(sit.datsitu,'yyyymm') <= to_char(sysdate,'yyyymm')
            AND     ( to_char(sit.datdep,'yyyymm') >= to_char(sysdate,'yyyymm')  or sit.datdep is null)
            AND     sit.ident = l_ident --KRA PPM 61776
            AND ROWNUM = 1;
            IF(l_num>0)THEN
                l_retour :=1;
            END IF;
        END;

        l_perime := pack_global.lire_perime(p_global);
        BEGIN
            SELECT  count(*)
            INTO    l_num
            FROM    SITU_RESS sit,
                    VUE_DPG_PERIME perime
            WHERE   sit.codsg = perime.CODSG
            AND     sit.IDENT = l_ident --KRA PPM 61776
            AND     to_char(sit.datsitu,'yyyymm') <= to_char(sysdate,'yyyymm')
            AND     ( to_char(sit.datdep,'yyyymm') >= to_char(sysdate,'yyyymm')  or sit.datdep is null)
            AND     INSTR(l_perime, to_char(perime.codbddpg,'FM00000000000'))>0
            AND     ROWNUM=1;
            IF(l_num>0)THEN
                l_retour :=1;
            END IF;
        END;

        IF l_retour =0 THEN
            pack_global.recuperer_message(21208, NULL, NULL, NULL, l_msg);
            raise_application_error(-20998, l_msg);
        END IF;
    END IF;


END verif_perim_ressource;




--SEL PPM 60612
PROCEDURE verif_perim_ligne_bip ( p_pid   IN VARCHAR2,
                                  p_liste_cp  IN VARCHAR2,
                                  p_message OUT VARCHAR2 ) IS


l_chef_de_projet_ligne  VARCHAR2(6000);-- PPM 63485 : augmenter la taille des chefs de projets  4000
l_chef_de_projet_user   VARCHAR2(6000);-- PPM 63485 : augmenter la taille des chefs de projets  4000
l_retour                VARCHAR2(1024);


BEGIN

--recuperer chef de projet de la ligne bip
SELECT ','||pcpi||',' into l_chef_de_projet_ligne FROM ligne_bip where pid=p_pid;

--recuperer les chefs de projet de l'utilisateur
select REPLACE(p_liste_cp,' ') into l_chef_de_projet_user from dual; --QC 1748


--verifier que le chef de projet de la ligne bip fait partie des chefs de projet de l'utilisateur
SELECT INSTR(l_chef_de_projet_user,l_chef_de_projet_ligne) into l_retour from dual;

/*
DBMS_OUTPUT.PUT_LINE('l_chef_de_projet_ligne = ' || l_chef_de_projet_ligne);
DBMS_OUTPUT.PUT_LINE('l_chef_de_projet_user = ' || l_chef_de_projet_user);
DBMS_OUTPUT.PUT_LINE('l_retour = ' || l_retour);
*/

 p_message:='OK';

IF (l_retour = 0) THEN

 p_message:='KO';



END IF;


END verif_perim_ligne_bip;

-- **************************************************************************************
-- Nom 		: isPerimCafi
-- Auteur 	: BSA
-- Description 	: Retourne "O" si le cafi fait parti du perimetre RTFE en prenant compte le multi niveau du cafi
-- Paramtres 	: p_cafi (IN) Identifiant de la ressource que l'utilisateur souhaite consulter
-- 				  p_perim_cafi (IN) contenant le code primtre cafi de l'utilisateur
-- Retour	: "O" pour oui, "N" pour non.
--
-- **************************************************************************************

  FUNCTION isPerimCafi ( p_cafi         IN VARCHAR2,
			             p_perim_cafi   IN VARCHAR2) RETURN VARCHAR2 IS

    t_retour    VARCHAR2(10);

    t_req       VARCHAR2(1000);
    c_req       RefCurTyp;
    t_codsg     vue_dpg_perime.CODSG%TYPE;

    BEGIN
 -- Cas ou le cafi est egal a TOUS
        IF (p_perim_cafi = 'TOUS') THEN
            t_retour := 'O';
        ELSE
        t_req := ' SELECT codcamo FROM centre_activite ';
        t_req := t_req || ' WHERE (  ';
        t_req := t_req || '         codcamo  IN (' || p_perim_cafi || ')';
        t_req := t_req || '     OR  CANIV1 IN (' || p_perim_cafi || ')';
        t_req := t_req || '     OR  CANIV2 IN (' || p_perim_cafi || ')';
        t_req := t_req || '     OR  CANIV3 IN (' || p_perim_cafi || ')';
        t_req := t_req || '     OR  CANIV4 IN (' || p_perim_cafi || ')';
        t_req := t_req || '     OR  CANIV5 IN (' || p_perim_cafi || ')';
        t_req := t_req || '     OR  CANIV6 IN (' || p_perim_cafi || ')';
        t_req := t_req || '       )  ';
        t_req := t_req || ' AND (cdateferm is null or substr(TO_DATE(cdateferm, ''DD/MM/YYYY''), 7, 8) = substr(TO_DATE(sysdate, ''DD/MM/YYYY''), 7, 8)) ';
        t_req := t_req || ' AND codcamo = ' || p_cafi;

        OPEN c_req FOR t_req;
        FETCH c_req INTO t_codsg;
        IF c_req%FOUND THEN
            t_retour := 'O';
        ELSE
            t_retour := 'N';
        END IF;

        CLOSE c_req;

        -- Cas ou le cafi fait parti du perim_cafi
        IF ( NVL(INSTR(p_perim_cafi, p_cafi ),-1) > 0 ) THEN
            t_retour := 'O';
        END IF;

        END IF;

        RETURN t_retour;

    EXCEPTION
        WHEN OTHERS THEN
           return  'N';

END isPerimCafi;


-- ******************************************************************************************************************
-- Nom            : verif_direction_perime
-- Auteur         : OEL
-- Description    : Vrifie si la direction fait partie du perimetre ME de l'utilisateur
--
-- Paramtres     : p_userid (IN)
--                  p_coddir (IN) code direction sur 2 caractres
-- Retour         : False si non habilitation / True si habilitation
--
-- ******************************************************************************************************************
    FUNCTION VERIF_PERIME_DIRECTION(   p_userid    IN  VARCHAR2,
                                       p_coddir    IN  VARCHAR2
                                   ) RETURN VARCHAR2 IS
       l_coddir  number;
       l_perime VARCHAR2(255);
       p_out    VARCHAR2(10);

    BEGIN
        p_out :='O';

        -- Rcuprer le primtre de l'utilisateur
           l_perime := Pack_Global.lire_globaldata(p_userid).perime ;
        DBMS_OUTPUT.PUT_LINE(l_perime);
        IF ( l_perime != '00000000000' ) THEN

            SELECT DISTINCT 1 INTO l_coddir
            FROM  vue_dpg_perime v, struct_info si
            WHERE v.codsg = si.codsg
            AND   si.coddir = p_coddir
            AND   INSTR(l_perime,v.codbddpg)>0;

        END IF;

        RETURN p_out;

    EXCEPTION
         WHEN NO_DATA_FOUND THEN -- p_out := 'N' --> Vous n'tes pas habilit  cette direction
         p_out := 'N';
         RETURN p_out;

    END VERIF_PERIME_DIRECTION;

-- FAD PPM 63956 : Retourne le primtre de Directions ou Branches BIP habilites
PROCEDURE HABILITATION_SUIVBASE(	P_ID_USER   IN RTFE.USER_RTFE%TYPE,
									P_PERIM  OUT VARCHAR2,
									P_MESSAGE OUT VARCHAR2) IS
L_IGG_RTFE RTFE.IGG_RTFE%TYPE;
L_NOM RTFE.NOM%TYPE;
L_PRENOM RTFE.PRENOM%TYPE;
L_SGSTRUCTURE TMP_RTFE.SGSTRUCTURE%TYPE;
L_SGSERVICENAME VARCHAR2(7);
ID_SPECIFIQUE VARCHAR2(16);
L_VALEUR_PARAM_DEFAUT LIGNE_PARAM_BIP.VALEUR%TYPE;
L_SEPARATEUR_DEFAUT LIGNE_PARAM_BIP.SEPARATEUR%TYPE;
L_VALEUR_PARAM LIGNE_PARAM_BIP.VALEUR%TYPE;
L_SEPARATEUR LIGNE_PARAM_BIP.SEPARATEUR%TYPE;
CAS VARCHAR2(10);

BEGIN
	CAS := NULL;
	P_MESSAGE := NULL;
	P_PERIM := NULL;

	BEGIN
		SELECT IGG_RTFE, NOM, PRENOM INTO L_IGG_RTFE, L_NOM, L_PRENOM FROM RTFE WHERE UPPER(USER_RTFE) = UPPER(P_ID_USER) AND ROWNUM = 1;
	EXCEPTION WHEN NO_DATA_FOUND THEN
		BEGIN
			SELECT IGG_RTFE, NOM, PRENOM INTO L_IGG_RTFE, L_NOM, L_PRENOM FROM RTFE_ERROR WHERE UPPER(USER_RTFE) = UPPER(P_ID_USER) AND ROWNUM = 1;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			L_IGG_RTFE := NULL;
			L_NOM := NULL;
			L_PRENOM := NULL;
		END;
	END;

	IF L_IGG_RTFE IS NOT NULL THEN
		ID_SPECIFIQUE := L_IGG_RTFE;
	ELSE
		IF LENGTH(P_ID_USER) <= 16 THEN
			ID_SPECIFIQUE := P_ID_USER;
		ELSE
			ID_SPECIFIQUE := NULL;-------Cas non spcifique, poursuivre cas gnral
			CAS := 'GENERAL';
		END IF;
	END IF;

	IF ID_SPECIFIQUE IS NOT NULL THEN
		BEGIN
			SELECT VALEUR, SEPARATEUR
			INTO L_VALEUR_PARAM_DEFAUT, L_SEPARATEUR_DEFAUT
			FROM LIGNE_PARAM_BIP
			WHERE CODE_ACTION = 'SUIVBASE_' || ID_SPECIFIQUE
			AND CODE_VERSION = 'DEFAUT'
			AND NUM_LIGNE = (SELECT MIN (NUM_LIGNE)
							FROM LIGNE_PARAM_BIP
							WHERE CODE_VERSION = 'DEFAUT'
							AND CODE_ACTION = 'SUIVBASE_' || ID_SPECIFIQUE
							AND ACTIF = 'O');
			BEGIN
				SELECT VALEUR, SEPARATEUR
				INTO L_VALEUR_PARAM, L_SEPARATEUR
				FROM LIGNE_PARAM_BIP
				WHERE CODE_ACTION = 'SUIVBASE-PERIM'
				AND CODE_VERSION = L_VALEUR_PARAM_DEFAUT
				AND NUM_LIGNE = (SELECT MIN (NUM_LIGNE)
								FROM LIGNE_PARAM_BIP
								WHERE CODE_VERSION = L_VALEUR_PARAM_DEFAUT --A confirmer
								AND CODE_ACTION = 'SUIVBASE-PERIM'
								AND ACTIF = 'O');
				P_PERIM := REPLACE(L_VALEUR_PARAM, L_SEPARATEUR, ',');

			EXCEPTION WHEN NO_DATA_FOUND THEN
				P_MESSAGE := 'Impossible de déterminer le périmètre de DPG suivbase pour l''utilisateur ' || P_ID_USER || ' Nom, prénom : ' || L_NOM || ', ' || L_PRENOM || ' :';
				--P_MESSAGE := P_MESSAGE || 'Veuillez prévenir l''équipe MO BIP par mail, en joignant une copie de cette fenêtre';
			END;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			CAS := 'GENERAL';
			-------Cas non spcifique, poursuivre cas gnral
		END;
	END IF;

	IF CAS = 'GENERAL' THEN
		BEGIN
			SELECT SGSTRUCTURE, SUBSTR(REPLACE(SGSERVICENAME, '/', ''), 1, 7) INTO L_SGSTRUCTURE, L_SGSERVICENAME FROM TMP_RTFE WHERE UPPER(SGZONEID) = UPPER(P_ID_USER);
		EXCEPTION WHEN NO_DATA_FOUND THEN
			L_SGSTRUCTURE := NULL;
			L_SGSERVICENAME := NULL;
		END;

		IF (L_SGSTRUCTURE IS NOT NULL AND LENGTH(L_SGSTRUCTURE) >= 1 AND LENGTH(L_SGSTRUCTURE) <= 8 ) THEN
			BEGIN
				SELECT VALEUR, SEPARATEUR
				INTO L_VALEUR_PARAM, L_SEPARATEUR
				FROM LIGNE_PARAM_BIP
				WHERE CODE_ACTION = 'SUIVBASE-PERIM'
				AND CODE_VERSION = L_SGSTRUCTURE
				AND NUM_LIGNE = (SELECT MIN (NUM_LIGNE)
								FROM LIGNE_PARAM_BIP
								WHERE CODE_VERSION = L_SGSTRUCTURE --A confirmer
								AND CODE_ACTION = 'SUIVBASE-PERIM'
								AND ACTIF = 'O');

				P_PERIM := REPLACE(L_VALEUR_PARAM, L_SEPARATEUR, ',');

			EXCEPTION WHEN NO_DATA_FOUND THEN
				BEGIN
					SELECT VALEUR, SEPARATEUR
					INTO L_VALEUR_PARAM, L_SEPARATEUR
					FROM LIGNE_PARAM_BIP
					WHERE CODE_ACTION = 'SUIVBASE-PERIM'
					AND CODE_VERSION = L_SGSERVICENAME
					AND NUM_LIGNE = (SELECT MIN (NUM_LIGNE)
									FROM LIGNE_PARAM_BIP
									WHERE CODE_VERSION = L_SGSERVICENAME --A confirmer
									AND CODE_ACTION = 'SUIVBASE-PERIM'
									AND ACTIF = 'O');

					P_PERIM := REPLACE(L_VALEUR_PARAM, L_SEPARATEUR, ',');

				EXCEPTION WHEN NO_DATA_FOUND THEN
					P_MESSAGE := 'Impossible de déterminer le périmètre de DPG suivbase pour l''utilisateur ' || P_ID_USER || ' Nom, prénom : ' || L_NOM || ', ' || L_PRENOM || ' :';
					--P_MESSAGE := P_MESSAGE || 'Veuillez prévenir l''équipe MO BIP par mail, en joignant une copie de cette fenêtre';
				END;
			END;
		ELSE
			BEGIN
				SELECT VALEUR, SEPARATEUR
				INTO L_VALEUR_PARAM, L_SEPARATEUR
				FROM LIGNE_PARAM_BIP
				WHERE CODE_ACTION = 'SUIVBASE-PERIM'
				AND CODE_VERSION = L_SGSERVICENAME
				AND NUM_LIGNE = (SELECT MIN (NUM_LIGNE)
								FROM LIGNE_PARAM_BIP
								WHERE CODE_VERSION = L_SGSERVICENAME --A confirmer
								AND CODE_ACTION = 'SUIVBASE-PERIM'
								AND ACTIF = 'O');

				P_PERIM := REPLACE(L_VALEUR_PARAM, L_SEPARATEUR, ',');

			EXCEPTION WHEN NO_DATA_FOUND THEN
				P_MESSAGE := 'Impossible de déterminer le périmètre de DPG suivbase pour l''utilisateur ' || P_ID_USER || ' Nom, prénom : ' || L_NOM || ', ' || L_PRENOM || ' :';
				--P_MESSAGE := P_MESSAGE || 'Veuillez prévenir l''équipe MO BIP par mail, en joignant une copie de cette fenêtre';
			END;
		END IF;
	END IF;
END HABILITATION_SUIVBASE;
-- FAD PPM 63956 : Fin

-- FAD PPM 63956 : Vrifier les rgles de gestion lis au IHM
PROCEDURE VERIF_EXISTANCE_ENTREE(P_CODSG IN VARCHAR2,
								P_DPCODE IN VARCHAR2,
								P_DP_COPI IN VARCHAR2,
								P_ICPI IN VARCHAR2,
								P_AIRT IN VARCHAR2,
								P_PERIM_ME IN VARCHAR2,
								P_HABIL IN VARCHAR2,
								P_MESSAGE OUT VARCHAR2) IS
	DPG_EXIST NUMBER(1);
	DP_EXIST NUMBER(1);
	DPCOPI_EXIST NUMBER(1);
	ICPI_EXIST NUMBER(1);
	AIRT_EXIST NUMBER(1);
	P_DP NUMBER;
	II NUMBER;
	P_BRANCHE NUMBER;
	P_DIRECTION NUMBER;
	L_PERIM_ME VARCHAR2(500);
	P_HABILITATION VARCHAR2(500);
	P_WHERE VARCHAR2(4000);
	P_REQ VARCHAR2(4000);
BEGIN
	P_MESSAGE := NULL;

	IF P_CODSG NOT LIKE '%*' THEN
		BEGIN
			SELECT 1 INTO DPG_EXIST FROM STRUCT_INFO WHERE CODSG = P_CODSG;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			P_MESSAGE := 'Code DPG inexistant ou d''un format incorrect : veuillez corriger';
			RAISE_APPLICATION_ERROR(-20000, P_MESSAGE);
		END;
	END IF;

	IF P_PERIM_ME IS NOT NULL AND P_CODSG IS NOT NULL THEN
		P_HABILITATION := REPLACE(P_HABIL, ' ', '');
		IF P_HABILITATION NOT LIKE '00%' AND P_HABILITATION NOT LIKE '%,00%' THEN
			P_WHERE := 'SELECT DISTINCT S.CODSG FROM STRUCT_INFO S WHERE (';
			LOOP
				P_BRANCHE := TO_NUMBER(SUBSTR(P_HABILITATION, 1, 2));
				P_DIRECTION := TO_NUMBER(SUBSTR(P_HABILITATION, 3, 2));
				P_HABILITATION := SUBSTR(P_HABILITATION, 6);
				IF P_DIRECTION = 0 THEN
					P_WHERE := P_WHERE || ' (S.CODSG IN (SELECT DISTINCT SI.CODSG FROM STRUCT_INFO SI, DIRECTIONS D WHERE SI.CODDIR = D.CODDIR AND D.CODBR = ' || P_BRANCHE || ')) ';
				ELSE
					P_WHERE := P_WHERE || ' (S.CODSG IN (SELECT DISTINCT SI.CODSG FROM STRUCT_INFO SI WHERE SI.CODDIR = ' || P_DIRECTION || ')) ';
				END IF;
				P_WHERE := P_WHERE || ' OR';
			EXIT WHEN P_HABILITATION IS NULL;
			END LOOP;
			-- FAD PPM 63956 : on enlve le dernier OR ajout et on ferme la parenthse
			P_WHERE := SUBSTR(P_WHERE , 1, LENGTH(P_WHERE ) - 2) || ')';

			P_REQ := 'SELECT COUNT(*) FROM (';
			P_REQ := P_REQ || P_WHERE;
			P_REQ := P_REQ || ') WHERE CODSG >= TO_NUMBER(REPLACE(''' || P_CODSG || ''',''*'',''0'')) AND CODSG <= TO_NUMBER(REPLACE(''' || P_CODSG || ''',''*'',''9''))';
			EXECUTE IMMEDIATE P_REQ INTO II;
			IF II = 0 THEN
				P_MESSAGE := 'Vous n''êtes pas habilité à demander ce code DPG : veuillez corriger';
				RAISE_APPLICATION_ERROR(-20000, P_MESSAGE);
			END IF;
		END IF;


	END IF;

	IF P_DPCODE IS NOT NULL THEN
		BEGIN
			P_DP := TO_NUMBER(P_DPCODE);
			BEGIN
				SELECT 1 INTO DP_EXIST FROM DOSSIER_PROJET where DPCODE = P_DP;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				P_MESSAGE := 'Code Dossier projet inexistant : veuillez corriger';
				RAISE_APPLICATION_ERROR(-20000, P_MESSAGE);
			END;
		EXCEPTION WHEN VALUE_ERROR THEN
			P_MESSAGE := 'Code Dossier projet inexistant : veuillez corriger';
			RAISE_APPLICATION_ERROR(-20000, P_MESSAGE);
		END;
	END IF;

	IF P_DP_COPI IS NOT NULL THEN
		BEGIN
			SELECT 1 INTO DPCOPI_EXIST from DOSSIER_PROJET_COPI where DP_COPI = P_DP_COPI;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			P_MESSAGE := 'Code lot DPCOPI inexistant : veuillez corriger';
			RAISE_APPLICATION_ERROR(-20000, P_MESSAGE);
		END;
	END IF;

	IF P_ICPI IS NOT NULL THEN
		BEGIN
			SELECT 1 INTO ICPI_EXIST from PROJ_INFO where ICPI = P_ICPI;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			P_MESSAGE := 'Code Projet inexistant : veuillez corriger';
			RAISE_APPLICATION_ERROR(-20000, P_MESSAGE);
		END;
	END IF;

	IF P_AIRT IS NOT NULL THEN
		BEGIN
			SELECT 1 INTO AIRT_EXIST from APPLICATION where AIRT = P_AIRT;
		EXCEPTION WHEN NO_DATA_FOUND THEN
			P_MESSAGE := 'Code Application inexistant : veuillez corriger';
			RAISE_APPLICATION_ERROR(-20000, P_MESSAGE);
		END;
	END IF;
END VERIF_EXISTANCE_ENTREE;
-- FAD PPM 63956 : Fin

--DHA optimization bips--
PROCEDURE find_pid_avec_cdp_valides ( id_lignes_in  IN  ARRAY_TABLE,                                                                                                                                                          
                                      liste_cp_in IN ARRAY_TABLE,
                                      id_lignes OUT ARRAY_TABLE) IS
                                      
actual_pid ARRAY_TABLE;
actual_cdp ARRAY_TABLE;
current_actual_cdp ligne_bip.pcpi%TYPE;
current_actual_pid ligne_bip.pid%TYPE;
is_cdp_contained NUMBER;
indx_ligne_bip_out NUMBER;


BEGIN

  id_lignes := ARRAY_TABLE();
  indx_ligne_bip_out := 1;
  --recuperer les chefs de projets de la ligne bip
  SELECT DISTINCT pid, pcpi
  BULK COLLECT INTO actual_pid, actual_cdp
  FROM ligne_bip WHERE pid IN  (select column_value from table(id_lignes_in))
  GROUP BY pid, pcpi;
  
  IF actual_cdp.COUNT > 0
    THEN
       FOR indx IN actual_cdp.FIRST .. actual_cdp.LAST
       LOOP
          is_cdp_contained := 0;
          current_actual_cdp :=  actual_cdp(indx);

          SELECT NVL( (SELECT 1 from dual
                      WHERE current_actual_cdp IN  (select column_value from table(liste_cp_in))),  0) 
          INTO is_cdp_contained  from dual;     
          
          IF is_cdp_contained = 1 THEN
            current_actual_pid := actual_pid(indx);
            id_lignes.extend(1);
            id_lignes(indx_ligne_bip_out) := current_actual_pid;
            indx_ligne_bip_out := indx_ligne_bip_out+1;
          END IF;   
          
       END LOOP;
  END IF;          

END find_pid_avec_cdp_valides;


END pack_habilitation;
/
