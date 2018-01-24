create or replace
PACKAGE pack_utile_cout IS

   TYPE profilfi_ViewType IS RECORD ( DATE_EFFET            PROFIL_FI.DATE_EFFET%TYPE,
                                      PROFILFI              PROFIL_FI.PROFIL_FI%TYPE,
                                      PRESTATION             PROFIL_FI.PRESTATION%TYPE,
                                      TOPEGALPRESTATION     PROFIL_FI.TOPEGALPRESTATION%TYPE,
                                      LOCALISATION             PROFIL_FI.LOCALISATION%TYPE,
                                      TOPEGALLOCALISATION     PROFIL_FI.TOPEGALLOCALISATION%TYPE,
                                      CODE_ES                 PROFIL_FI.CODE_ES%TYPE,
                                      TOPEGALES             PROFIL_FI.TOPEGALES%TYPE
                                           );
   TYPE ProfilFiCurType IS REF CURSOR RETURN profilfi_ViewType;

   TYPE RefCurTyp IS REF CURSOR;

   PROCEDURE RECHERCHER_DOMFONC(
		p_cafi IN NUMBER,
		p_cdeb IN VARCHAR2,
		p_coddir IN NUMBER,
		p_codcamo IN LIGNE_BIP.CODCAMO%TYPE,
		p_profil_fi IN OUT VARCHAR2,
    p_cout_ft IN OUT NUMBER,
    p_cout_env IN OUT NUMBER
	);

	FUNCTION VERIF_CA(
		p_code_es PROFIL_FI.CODE_ES%TYPE,
		p_cafi NUMBER
	) RETURN BOOLEAN;

  FUNCTION getCout( p_soccode varchar2,
                         p_rtype   char,
                      p_annee   number,
                      p_metier  varchar2,
                      p_niveau  varchar2,
                      p_codsg   number ,
                      p_cout_ssii number) Return Number;

  FUNCTION getCoutTTC ( p_soccode varchar2,
                         p_rtype   char,
                      p_annee   number,
                      p_metier  varchar2,
                      p_niveau  varchar2,
                      p_codsg   number ,
                      p_cout_ssii number,
                      p_cdeb    varchar2 ) Return Number;


  FUNCTION AppliqueTauxHTR (   p_annee   number,
                      p_montant number,
                      p_cdeb    varchar2,
                      p_filcode varchar2 ) Return Number;

  FUNCTION getCoutHTR ( p_soccode varchar2,
                         p_rtype   char,
                      p_annee   number,
                      p_metier  varchar2,
                      p_niveau  varchar2,
                      p_codsg   number ,
                      p_cout_ssii number,
                      p_cdeb    varchar2,
                      p_filcode varchar2 ) Return Number ;

FUNCTION getCoutEnv ( p_soccode varchar2,
                         p_rtype   char,
                      p_annee   number,
                      p_codsg   number,
                      p_metier  varchar2  ) Return Number ;

FUNCTION getCoutEnvHTR_Generique ( p_codsg          IN NUMBER,
                                p_cafi           IN NUMBER,
                               p_prest          IN VARCHAR2,
                               p_ident          IN NUMBER,
                               p_cdeb           IN VARCHAR2,
                               p_soccode        IN VARCHAR2,
                               p_rtype          IN VARCHAR2,
                               p_metier         IN varchar2,
                               p_niveau         IN varchar2,
							   p_codcamo 	 	IN LIGNE_BIP.CODCAMO%TYPE,
							   p_annee   number,
							   p_filcode varchar2) Return Number ;					  
					  
FUNCTION getCoutEnvHTR ( p_soccode varchar2,
                         p_rtype   char,
                      p_annee   number,
                      p_codsg   number,
                      p_metier  varchar2,
                      p_cdeb     varchar2,
                      p_filcode varchar2  ) Return Number ;

PROCEDURE CALCUL_COUT_FI ( p_codsg          IN NUMBER,
                           p_cafi           IN NUMBER,
                           p_prest          IN VARCHAR2,
                           p_ident          IN NUMBER,
                           p_cdeb           IN VARCHAR2,
                           p_soccode        IN VARCHAR2,
                           p_rtype          IN VARCHAR2,
                           p_metier         IN varchar2,
                           p_niveau         IN varchar2,
						   p_codcamo 		IN LIGNE_BIP.CODCAMO%TYPE,
						   p_type_profil	OUT NUMBER,
                           p_profil_fi      OUT VARCHAR2,
                           p_cout           OUT NUMBER,
						   p_cout_env		OUT NUMBER
                         );

FUNCTION Get_Profil_Fi (    p_codsg          IN NUMBER,
                               p_cafi           IN NUMBER,
                               p_prest          IN VARCHAR2,
                               p_ident          IN NUMBER,
                               p_cdeb           IN VARCHAR2,
                               p_soccode        IN VARCHAR2,
                               p_rtype          IN VARCHAR2,
                               p_metier         IN varchar2,
                               p_niveau         IN varchar2,
							   p_codcamo 	 IN LIGNE_BIP.CODCAMO%TYPE,
                 p_pid IN varchar2
                       )   RETURN VARCHAR2 ;

FUNCTION Get_Profil_Fi_Mens (   p_ident     NUMBER,
                                p_moisprest DATE,
                                    p_pid varchar2
                       )   RETURN VARCHAR2 ;

FUNCTION Get_Cout_Fi (     p_codsg          IN NUMBER,
                           p_cafi           IN NUMBER,
                           p_prest          IN VARCHAR2,
                           p_ident          IN NUMBER,
                           p_cdeb           IN VARCHAR2,
                           p_soccode        IN VARCHAR2,
                           p_rtype          IN VARCHAR2,
                           p_metier         IN varchar2,
                           p_niveau         IN varchar2,
						   p_codcamo 	LIGNE_BIP.CODCAMO%TYPE
                     ) RETURN NUMBER;

FUNCTION getCoutHTR_STD_FI ( p_soccode varchar2,
                                 p_rtype   char,
                                 p_metier  varchar2,
                                 p_niveau  varchar2,
                                 p_codsg   number ,
                                 p_cout_ssii number,
                                 p_cdeb    varchar2,
                                 p_filcode varchar2,
                                 p_prest   VARCHAR2,
                                 p_ident   NUMBER,
                                 p_cafi    NUMBER,
								 p_codcamo	LIGNE_BIP.CODCAMO%TYPE
                            ) Return Number;
                            
FUNCTION getCoutEnv_Generique ( p_codsg          IN NUMBER,
                                p_cafi           IN NUMBER,
                               p_prest          IN VARCHAR2,
                               p_ident          IN NUMBER,
                               p_cdeb           IN VARCHAR2,
                               p_soccode        IN VARCHAR2,
                               p_rtype          IN VARCHAR2,
                               p_metier         IN varchar2,
                               p_niveau         IN varchar2,
							   p_codcamo 	 	IN LIGNE_BIP.CODCAMO%TYPE,
							   p_annee   number,
							   p_filcode varchar2) Return Number ;
--PPM 58225                 
PROCEDURE CALCUL_COUT_STD ( p_codsg          IN NUMBER,
                           p_cafi           IN NUMBER,
                           p_prest          IN VARCHAR2,
                           p_ident          IN NUMBER,
                           p_cdeb           IN VARCHAR2,
                           p_soccode        IN VARCHAR2,
                           p_rtype          IN VARCHAR2,
                           p_metier         IN varchar2,
                           p_niveau         IN varchar2,
						   p_codcamo 		IN LIGNE_BIP.CODCAMO%TYPE,
						   p_type_profil	OUT NUMBER,
                           p_profil_fi      OUT VARCHAR2,
                           p_cout           OUT NUMBER,
						   p_cout_env		OUT NUMBER
                         );
                 
                 
/******************************************************************************
   NAME:       pack_utile_cout
   PURPOSE:    Contient des fonctions de calcul des couts utilises dans
           les etats et dans les procedures

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        31/03/2005   PPR             Repris de pack_x_ressmoi
          02/11/2005   PPR          Rajout d'une fonction pour les couts d environnement
          25/06/2007   EVI        Calcul du coutenv HTR
          02/07/2007   EVI        Creation d'une nouvelle fonction: getCoutEnvHTR
          30/11/2007   EVI        Modification de la fonction ApplicationtauxHTR
          18/12/2007   EVI        Application du taux HTR egelement au Forfait (F)
          13/02/2014   SEL        QC 1594 : correction coutENV profil DomFonc

******************************************************************************/
END pack_utile_cout;
/

create or replace
PACKAGE BODY pack_utile_cout AS


-- Renvoie le cout en fonction du type de ressource
FUNCTION getCout ( p_soccode varchar2,
                         p_rtype   char,
                      p_annee   number,
                      p_metier  varchar2,
                      p_niveau  varchar2,
                      p_codsg   number ,
                      p_cout_ssii number ) Return Number IS
l_cout NUMBER(12,2);
BEGIN
l_cout:=0;

 if (p_soccode='SG..') then
     select cout_sg into l_cout
    from cout_std_sg
    where p_codsg between dpg_bas and dpg_haut
    and metier = rtrim(p_metier)
    and niveau = decode(p_niveau,'L','HC','M','HC','N','HC',p_niveau)
    and annee = p_annee;
 else
      if p_rtype='L' then
         select cout_log into l_cout
        from cout_std2
        where p_codsg between dpg_bas and dpg_haut
         and annee  = p_annee
        and metier = 'ME';

     else
          l_cout := p_cout_ssii;

     end if;

 end if;


   RETURN l_cout;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RETURN l_cout;
     WHEN OTHERS THEN
       RETURN l_cout;
END getCout;

-- Renvoie le cout TTC en fonction du type de ressource
FUNCTION getCoutTTC ( p_soccode varchar2,
                         p_rtype   char,
                      p_annee   number,
                      p_metier  varchar2,
                      p_niveau  varchar2,
                      p_codsg   number ,
                      p_cout_ssii number,
                      p_cdeb    varchar2 ) Return Number IS
l_coutTTC NUMBER(12,2);
l_tva tva.tva%TYPE;
BEGIN
l_coutTTC:=0;

    -- Recherche le cout
    l_coutTTC :=getCout ( p_soccode, p_rtype, p_annee, p_metier, p_niveau, p_codsg, p_cout_ssii );

    -- Si ce n est pas un logiciel et c est un prestataire
    if (p_rtype<>'L' and p_soccode<>'SG..') then

        -- Recherche du taux de tva
        BEGIN
            SELECT t.tva into l_tva
                   FROM tva t
                   WHERE
                   t.datetva = (SELECT max(tva.datetva) FROM tva where datetva <= to_date(p_cdeb,'DD/MM/YYYY'));
              EXCEPTION
             WHEN OTHERS THEN
                     -- Code TVA inexistant
                    l_tva := 0 ;
              END;

        -- Applique la TVA au cout
        l_coutTTC := l_coutTTC * ( 1 + l_tva/100 ) ;
    end if ;

   RETURN l_coutTTC;

END getCoutTTC;


-- Applique le taux HTR a un montant
FUNCTION AppliqueTauxHTR (   p_annee   number,
                      p_montant number,
                      p_cdeb    varchar2,
                      p_filcode varchar2 ) Return Number IS
l_montant number(12,2);
l_tva tva.tva%TYPE;
l_taux_recup taux_recup.taux%TYPE;
BEGIN
l_montant:=p_montant;

-- Recherche du taux de tva
    BEGIN
        SELECT t.tva into l_tva
        FROM tva t
        WHERE
        t.datetva = (SELECT max(tva.datetva) FROM tva,datdebex where datetva <= to_char(datdebex.moismens,'DD/MM/YYYY') );
    EXCEPTION
     WHEN OTHERS THEN
             -- Code TVA inexistant
            l_tva := 0 ;
    END;

    -- Recherche du taux de recuperation pour la filiale
    BEGIN
        SELECT taux into l_taux_recup
        FROM taux_recup
        WHERE    annee = p_annee
        and     trim(filcode) = trim(p_filcode) ;

    EXCEPTION
     WHEN OTHERS THEN
             -- Taux de recuperation non trouve
        l_taux_recup := 0 ;
    END;

    -- Applique la TVA et le taux de recup au montant
    l_montant := l_montant * ( 1 + l_tva/100  * (1 - l_taux_recup/100)) ;

   RETURN l_montant;

END AppliqueTauxHTR;


-- Renvoie le cout HTR en fonction du type de ressource
FUNCTION getCoutHTR ( p_soccode varchar2,
                         p_rtype   char,
                      p_annee   number,
                      p_metier  varchar2,
                      p_niveau  varchar2,
                      p_codsg   number ,
                      p_cout_ssii number,
                      p_cdeb    varchar2,
                      p_filcode varchar2 ) Return Number IS
l_coutHTR NUMBER(12,2);
l_tva tva.tva%TYPE;
l_taux_recup taux_recup.taux%TYPE;
BEGIN
l_coutHTR:=0;

    -- Recherche le cout
    l_coutHTR :=getCout ( p_soccode, p_rtype, p_annee, p_metier, p_niveau, p_codsg, p_cout_ssii );

    -- Si ce n est pas un logiciel et c est un prestataire

    if (p_soccode!='SG..' and (p_rtype='P' OR p_rtype='F' OR p_rtype='E')) then
        --Applique le taux HTR au cout
    l_coutHTR := AppliqueTauxHTR ( p_annee , l_coutHTR ,  p_cdeb , p_filcode ) ;
    end if ;




   RETURN l_coutHTR;

END getCoutHTR;

-- Renvoie le cout d environnement
FUNCTION getCoutEnv ( p_soccode varchar2,
                         p_rtype   char,
                      p_annee   number,
                      p_codsg   number,
                      p_metier  varchar2  ) Return Number IS
l_cout NUMBER(12,2);
BEGIN
l_cout:=0;

-- Ne fait le calcul que si ce n est pas un logiciel ou un forfait hors site
if (p_rtype<>'L' and p_rtype<>'E') then

    -- Recherche le cout standard d environnement associe au DPG pour l annee
    SELECT NVL(decode(p_soccode,'SG..',c.coutenv_sg,c.coutenv_ssii),0) into l_cout
    FROM cout_std2 c
    WHERE
    --Sur l annee
     c.annee = p_annee
    --sur le dpg de la ressource
    and p_codsg between c.dpg_bas and c.dpg_haut
    and rownum=1
    and rtrim(p_metier) = c.metier;

end if ;


RETURN l_cout;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RETURN l_cout;
     WHEN OTHERS THEN
       RETURN l_cout;
END getCoutEnv;

-- Renvoie le cout d environnement (soit le cout d environnement standard
-- soit celui associe au profil domfonc si trouve)
FUNCTION getCoutEnvHTR_Generique (p_codsg     IN NUMBER,
                                p_cafi          IN NUMBER,
                               p_prest          IN VARCHAR2,
                               p_ident          IN NUMBER,
                               p_cdeb           IN VARCHAR2,
                               p_soccode        IN VARCHAR2,
                               p_rtype          IN VARCHAR2,
                               p_metier         IN varchar2,
                               p_niveau         IN varchar2,
							   p_codcamo 	 	IN LIGNE_BIP.CODCAMO%TYPE,
							   p_annee   number,
							   p_filcode varchar2) Return Number IS


l_type_profil NUMBER;
l_profil_fi  PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE;
l_cout     PROFIL_DOMFONC.FORCE_TRAVAIL%TYPE;
l_cout_env PROFIL_DOMFONC.FRAIS_ENVIRONNEMENT%TYPE;
BEGIN
Calcul_Cout_Fi (p_codsg, p_cafi, p_prest, p_ident, p_cdeb, p_soccode, p_rtype, p_metier , p_niveau , p_codcamo, l_type_profil, l_profil_fi,l_cout,l_cout_env);

-- Si aucun profil domfonc ne correspond
IF (l_type_profil != 2) THEN
	-- Recuperation du cout d environnement standard
	return getCoutEnvHTR(p_soccode, p_rtype, p_annee, p_codsg, p_metier, p_cdeb, p_filcode);
-- Sinon (cas ou un profil domfonc est trouve)
ELSE
	-- Recuperation du cout d environnement lie au profil domfonc trouve
  return l_cout_env;
END IF;

END getCoutEnvHTR_Generique;

-- Renvoie le cout d environnement
FUNCTION getCoutEnvHTR ( p_soccode varchar2,
                         p_rtype   char,
                      p_annee   number,
                      p_codsg   number,
                      p_metier  varchar2,
                      p_cdeb     varchar2,
                      p_filcode varchar2) Return Number IS
l_cout NUMBER(12,2);
BEGIN
l_cout:=0;

-- Ne fait le calcul que si ce n est pas un logiciel ou un forfait hors site
if (p_rtype<>'L' and p_rtype<>'E') then

    -- Recherche le cout standard d environnement associe au DPG pour l annee
    SELECT NVL(decode(p_soccode,'SG..',c.coutenv_sg,c.coutenv_ssii),0) into l_cout
    FROM cout_std2 c
    WHERE
    --Sur l annee
     c.annee = p_annee
    --sur le dpg de la ressource
    and p_codsg between c.dpg_bas and c.dpg_haut
    and rownum=1
    and rtrim(p_metier) = c.metier;

    -- Applique le taux HTR au cout
    --l_cout := AppliqueTauxHTR ( p_annee , l_cout ,  p_cdeb , p_filcode ) ;
end if ;

RETURN l_cout;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RETURN l_cout;
     WHEN OTHERS THEN
       RETURN l_cout;
END getCoutEnvHTR;

/****************************************************************************************************
     Procedure de Calcul Profils de FI

     Attention les regles de gestion ci dessous doivent etre les memes que celui de la fonction
     get_profil_fi_mens ( en cas de changement de regles )


****************************************************************************************************/
PROCEDURE CALCUL_COUT_FI ( p_codsg          IN NUMBER,
                           p_cafi           IN NUMBER,
                           p_prest          IN VARCHAR2,
                           p_ident          IN NUMBER,
                           p_cdeb           IN VARCHAR2,
                           p_soccode        IN VARCHAR2,
                           p_rtype          IN VARCHAR2,
                           p_metier         IN varchar2,
                           p_niveau         IN varchar2,

						   p_codcamo 		IN LIGNE_BIP.CODCAMO%TYPE,
                           p_type_profil	OUT NUMBER,
						   p_profil_fi      OUT VARCHAR2,
                           p_cout           OUT NUMBER,
                           p_cout_env		OUT NUMBER
                         ) IS

    l_cout          NUMBER(12,2);
    l_cout_fi       NUMBER(12,2);
    l_cout_htr      NUMBER(12,2);
    l_cout_ht       NUMBER(12,2);
    i               NUMBER;
    l_profil_fi     VARCHAR2(12);

    t_prestation    BOOLEAN;
    t_localisation  BOOLEAN;
    t_code_es       BOOLEAN;
    t_cafi          BOOLEAN;
    

    return_value_p  bip.pack_profil_fi.string_array;
    return_value_l  bip.pack_profil_fi.string_array;

    l_coddir NUMBER;
    l_loc  VARCHAR2(3);

    CURSOR C_PROFIL (l_coddir IN NUMBER) IS
    SELECT DISTINCT fi.DATE_EFFET, fi.PROFIL_FI , fi.COUT, fi.PRESTATION ,fi.TOPEGALPRESTATION , fi.LOCALISATION,
                        fi.TOPEGALLOCALISATION, fi.CODE_ES, fi.TOPEGALES
        FROM profil_fi fi
        WHERE
        fi.CODDIR = l_coddir
        AND fi.DATE_EFFET <= to_date(p_cdeb,'DD/MM/YYYY')
        AND fi.TOP_ACTIF = 'O'
        ORDER BY date_effet DESC, PROFIL_FI asc;

    T_PROFIL  C_PROFIL%ROWTYPE;

    CAFI_LIST       VARCHAR2(32000);

    t_prest_valide  BOOLEAN;
    t_local_valide  BOOLEAN;
    t_es_valide     BOOLEAN;
    t_cafi_valide   BOOLEAN;
    t_profil_trouve BOOLEAN;

    l_tva tva.tva%TYPE;
    l_taux_recup taux_recup.taux%TYPE;

    PARAM_APP_PROFIL_FI BOOLEAN;
    P_PROFILFI_SEUIL BOOLEAN;
    L_SEUIL_BAS     NUMBER(12,2);
    L_SEUIL_HAUT    NUMBER(12,2);
    L_PROFIL_ENTRE2 VARCHAR2(12);
    L_PROFIL_AUDELA VARCHAR2(12);

    CURSOR C_PFI_SEUIL (t_profil IN VARCHAR2) IS
            SELECT COUT
            FROM PROFIL_FI
            WHERE PROFIL_FI = t_profil
            AND DATE_EFFET <= to_date(p_cdeb,'DD/MM/YYYY')
            AND TOP_ACTIF = 'O'
            AND ROWNUM = 1
            ORDER BY date_effet DESC;

    T_PFI_SEUIL  C_PFI_SEUIL%ROWTYPE;
	l_annee number;

BEGIN

        l_cout := 0;
        CAFI_LIST :='';
        t_profil_trouve := FALSE;
        p_profil_fi := 'STANDARD';
        P_PROFILFI_SEUIL := FALSE;
        PARAM_APP_PROFIL_FI := TRUE;
 
        BEGIN
            select coddir into l_coddir from struct_info where
            codsg = p_codsg;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            l_coddir := null;
        END;

       
-- PPM 58225 : QC 1602 : on commence par verifier si il s agit d un CA payeur non facturable
FOR i IN (

      select *
      from CENTRE_ACTIVITE
			where ctopact = 'S') 
      LOOP
      IF(p_codcamo = i.codcamo) THEN
      p_profil_fi:='N/A';
      EXIT;
      END IF;
  
  END LOOP;
  
-- PPM 58225 :QC 1604 : si il  s agit d un CA payeur facturable, on recherche les profils domfonc associes  
IF(p_profil_fi <> 'N/A') THEN
-- on commence par verifier si il s agit d un profil dom fonc
PACK_UTILE_COUT.RECHERCHER_DOMFONC(p_cafi, p_cdeb, l_coddir, p_codcamo, p_profil_fi, p_cout, p_cout_env);

-- Type Domfonc
p_type_profil := 2;

END IF;
  
	IF (p_profil_fi = 'STANDARD') THEN
		-- Type Standard ou FI
    		p_type_profil := 1;
        
        -----------------------------------------------------------------------------------------------------
        -- Parametre applicatif pour Gerer les seuils d application de Profils de FI
        -----------------------------------------------------------------------------------------------------
         BEGIN

            SELECT  TO_NUMBER(PACK_PROFIL_FI.PROFILFI_SEUIL_VALUES(valeur, separateur , 1)) ,
                    TO_NUMBER(PACK_PROFIL_FI.PROFILFI_SEUIL_VALUES(valeur, separateur , 2)) ,
                    PACK_PROFIL_FI.PROFILFI_SEUIL_VALUES(valeur, separateur , 3) ,
                    PACK_PROFIL_FI.PROFILFI_SEUIL_VALUES(valeur, separateur , 4)
            INTO L_SEUIL_BAS, L_SEUIL_HAUT , L_PROFIL_ENTRE2 , L_PROFIL_AUDELA
            FROM ligne_param_bip lpb
            WHERE lpb.code_action = 'PROFILSFI-SEUILS'
            AND   lpb.code_version = to_char(l_coddir)
            AND   lpb.num_ligne = (SELECT MIN (lpb.num_ligne) FROM ligne_param_bip lpb
                                   WHERE lpb.code_version = to_char(l_coddir)
                                   AND   lpb.code_action = 'PROFILSFI-SEUILS'
                                   AND   lpb.actif = 'O'
                                   );

            P_PROFILFI_SEUIL := TRUE;
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                P_PROFILFI_SEUIL := FALSE;
                L_SEUIL_BAS := null;
                L_SEUIL_HAUT := null;
                L_PROFIL_ENTRE2 := null;
                L_PROFIL_AUDELA := null;

            WHEN OTHERS THEN
                P_PROFILFI_SEUIL := FALSE;
        END; 
		-- Sinon on verifie si il ne s agit pas d'un profil de FI
        IF(P_PROFILFI_SEUIL = TRUE AND PARAM_APP_PROFIL_FI = TRUE) THEN

            BEGIN
                -- cout unitaire HT d une Ressource
                SELECT COUT INTO l_cout
                FROM SITU_RESS
                WHERE IDENT = p_ident
                AND to_date(p_cdeb,'DD/MM/YYYY') >= DATSITU
                AND (to_date(p_cdeb,'DD/MM/YYYY') <= DATDEP OR DATDEP IS NULL);

            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_cout := null;
            END;

            -- Recherche du taux de tva
            BEGIN
                SELECT t.tva into l_tva
                       FROM tva t
                       WHERE
                       t.datetva = (SELECT max(tva.datetva) FROM tva where datetva <= to_date(p_cdeb,'DD/MM/YYYY'));
            EXCEPTION
                 WHEN OTHERS THEN
                         -- Code TVA inexistant
                        l_tva := 0 ;
            END;

            -- Recherche du taux de recuperation pour la filiale
            BEGIN
                SELECT taux into l_taux_recup
                       FROM taux_recup tr, struct_info si
                       WHERE   tr.annee = to_number(substr(replace(p_cdeb,'/',''),5,4))
                       --and     filcode = p_filcode
                       and tr.FILCODE = si.FILCODE
                       and si.CODSG = p_codsg;

            EXCEPTION
                 WHEN OTHERS THEN
                         -- Taux de recuperation non trouve
                l_taux_recup := 0 ;
            END;

            IF (p_soccode='SG..') then

                BEGIN
                    -- On prend le cout deja HTR a partir de la table des couts standards SG COUT_STD_SG des lignes dont le code societe ='SG..' par annee,niveau,metier,dpg
                    select cout_sg into l_cout_htr
                    from cout_std_sg
                    where p_codsg between dpg_bas and dpg_haut
                    and metier = rtrim(p_metier)
                    and niveau = decode(p_niveau,'L','HC','M','HC','N','HC',p_niveau)
                    and annee = to_number(substr(replace(p_cdeb,'/',''),5,4));

                    l_cout_ht := l_cout_htr / ( 1 + l_tva/100 * (1 - l_taux_recup/100) );

                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_cout_htr := null;
                END;

            ELSE
                IF p_rtype='L' THEN
                    Begin
                        -- Logiciel : cout logiciel HTR de la table COUT_STD2 en fonction du DPG de la ressource
                        select cout_log into l_cout_htr
                        from cout_std2
                        where p_codsg between dpg_bas and dpg_haut
                        and annee = to_number(substr(replace(p_cdeb,'/',''),5,4));

                        l_cout_ht := l_cout_htr / ( 1 + l_tva/100 * (1 - l_taux_recup/100) );

                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_cout_htr := null;
                    END;

                ELSE
                     -- Un externe et On recupere directement son cout unitaire HT dans la situation
                     l_cout_ht := l_cout;
                END IF;

            END IF;

            IF(l_cout_ht >= L_SEUIL_HAUT) THEN
                OPEN C_PFI_SEUIL (L_PROFIL_AUDELA);
                FETCH C_PFI_SEUIL INTO T_PFI_SEUIL;

                IF C_PFI_SEUIL%NOTFOUND THEN
                    p_cout := null;
                    PARAM_APP_PROFIL_FI := FALSE;
                END IF;

                    p_cout := T_PFI_SEUIL.COUT;

                CLOSE C_PFI_SEUIL;

                p_profil_fi := L_PROFIL_AUDELA;

            ELSE

                IF (l_cout_ht >= L_SEUIL_BAS) THEN

                    OPEN C_PFI_SEUIL (L_PROFIL_ENTRE2);
                    FETCH C_PFI_SEUIL INTO T_PFI_SEUIL;

                    IF C_PFI_SEUIL%NOTFOUND THEN
                        p_cout := null;
                        PARAM_APP_PROFIL_FI := FALSE;
                    END IF;

                        p_cout := T_PFI_SEUIL.COUT;

                    CLOSE C_PFI_SEUIL;

                    p_profil_fi := L_PROFIL_ENTRE2;

                ELSE
                    PARAM_APP_PROFIL_FI := FALSE;
                END IF;

            END IF;

           
		-----------------------------------------------------------------------------------------------------

        IF ((PARAM_APP_PROFIL_FI = FALSE AND P_PROFILFI_SEUIL = TRUE) OR P_PROFILFI_SEUIL = FALSE) THEN

           p_profil_fi := 'STANDARD';
           
            BEGIN
            select mc.CODE_LOCALISATION into l_loc from situ_ress si, mode_contractuel mc where
            ident = p_ident
            and datsitu <= to_date(p_cdeb,'DD/MM/YYYY')
            and (datdep >= to_date(p_cdeb,'DD/MM/YYYY') or datdep is null)
            and mc.CODE_CONTRACTUEL = si.MODE_CONTRACTUEL_INDICATIF;

            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            l_loc := null;
            END;

             OPEN C_PROFIL (l_coddir) ;

                LOOP

                        FETCH C_PROFIL INTO T_PROFIL;
                        EXIT WHEN C_PROFIL%NOTFOUND;

                        IF(p_soccode='SG..' AND p_rtype='P') THEN
                            l_loc:='SG';
                        ELSE
                            IF(l_loc IS NULL) THEN

                                EXIT;
                            END IF;

                        END IF;

                        return_value_p := pack_profil_fi.split_string(
                        p_str=>T_PROFIL.PRESTATION,
                        p_delim=>',');

                        return_value_l := pack_profil_fi.split_string(
                        p_str=>T_PROFIL.LOCALISATION,
                        p_delim=>',');

                        t_prestation := FALSE;

                        IF return_value_p.count > 0 THEN

                              FOR i IN 1..return_value_p.COUNT LOOP

                                  IF (INSTR(return_value_p(i),'*') >0 ) THEN
                                    IF( SUBSTR(TRIM(return_value_p(i)),0,2) = SUBSTR(TRIM(p_prest),0,2) ) THEN
                                        t_prestation := TRUE;
                                      END IF;
                                  ELSE
                                      IF(TRIM(return_value_p(i)) = TRIM(p_prest)) THEN
                                        t_prestation := TRUE;
                                      END IF;
                                  END IF;

                              END LOOP;

                        END IF;

                    IF(T_PROFIL.CODE_ES is null) THEN

                        t_cafi_valide := TRUE;
                    ELSE
						t_cafi := VERIF_CA(T_PROFIL.CODE_ES, p_cafi);

                        IF(T_PROFIL.TOPEGALES ='=' ) THEN

                            IF(t_cafi = TRUE) THEN
                                t_cafi_valide := TRUE;
                            ELSE
                                t_cafi_valide := FALSE;
                            END IF;

                        ELSE

                            IF(t_cafi = TRUE) THEN
                                t_cafi_valide := FALSE;
                            ELSE
                                t_cafi_valide := TRUE;
                            END IF;

                        END IF;

                    END IF;
					
                        t_localisation := FALSE;

                        IF return_value_l.count > 0 THEN

                              FOR i IN 1..return_value_l.COUNT LOOP

                                  IF(TRIM(return_value_l(i)) = TRIM(l_loc)) THEN
                                    t_localisation := TRUE;
                                  END IF;

                              END LOOP;

                        END IF;

                        IF(T_PROFIL.TOPEGALPRESTATION ='=' ) THEN

                            IF(t_prestation = TRUE) THEN
                                t_prest_valide := TRUE;
                            ELSE
                                t_prest_valide := FALSE;
                            END IF;

                        ELSE

                            IF(t_prestation = TRUE) THEN
                                t_prest_valide := FALSE;
                            ELSE
                                t_prest_valide := TRUE;
                            END IF;

                        END IF;


                        IF(T_PROFIL.TOPEGALLOCALISATION ='=' ) THEN

                            IF(t_localisation = TRUE) THEN
                                t_local_valide := TRUE;

                            ELSE
                                t_local_valide := FALSE;
                            END IF;

                        ELSE

                            IF(t_localisation = TRUE) THEN
                                t_local_valide := FALSE;
                            ELSE
                                t_local_valide := TRUE;
                            END IF;


                        END IF;

                        IF(t_prest_valide = TRUE and t_local_valide = TRUE and t_cafi_valide = TRUE) THEN
                            t_profil_trouve := TRUE;
                            p_profil_fi := T_PROFIL.PROFIL_FI;
                            p_cout := T_PROFIL.COUT;

                            EXIT;
                        END IF;

                END LOOP;
            CLOSE C_PROFIL;
        END IF;
	END IF;
	END IF;
EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END Calcul_Cout_Fi;


	-- Recherche du profil domfonc applicable (profil domfonc standart si trouve,
  -- par defaut sinon)
	PROCEDURE RECHERCHER_DOMFONC(
		p_cafi IN NUMBER,
		p_cdeb IN VARCHAR2,
		p_coddir IN NUMBER,
		p_codcamo IN LIGNE_BIP.CODCAMO%TYPE,
		p_profil_fi IN OUT VARCHAR2,
    p_cout_ft IN OUT NUMBER,
    p_cout_env IN OUT NUMBER
	) IS
      -- Declaration des var locales
      l_profil PROFIL_DOMFONC%ROWTYPE;
	  l_profil_tmp PROFIL_DOMFONC%ROWTYPE;

      -- Curseur profil domfonc
      cursor c_profil_domfonc (l_coddir IN NUMBER) is
			select distinct PROFIL_DOMFONC.*
      from PROFIL_DOMFONC
			inner join CENTRE_ACTIVITE on (PROFIL_DOMFONC.CODE_ES IN (CENTRE_ACTIVITE.CODCAMO,
      CENTRE_ACTIVITE.CANIV1,
      CENTRE_ACTIVITE.CANIV2,
      CENTRE_ACTIVITE.CANIV3,
      CENTRE_ACTIVITE.CANIV4,
      CENTRE_ACTIVITE.CANIV5,
      CENTRE_ACTIVITE.CANIV6))
			where PROFIL_DOMFONC.TOP_ACTIF = 'O'
			and PROFIL_DOMFONC.CODDIR = l_coddir
			and PROFIL_DOMFONC.DATE_EFFET <= to_date(p_cdeb,'dd/MM/yyyy')
			and PROFIL_DOMFONC.PROFIL_DEFAUT = 'N'
			and CENTRE_ACTIVITE.CDATEFERM is null
			order by PROFIL_DOMFONC.DATE_EFFET desc, PROFIL_DOMFONC.PROFIL_DOMFONC asc;

      -- Curseur profil domfonc par defaut
		  cursor c_profil_domfonc_defaut (l_coddir IN NUMBER) is
			select PROFIL_DOMFONC.*
      from PROFIL_DOMFONC
			where PROFIL_DOMFONC.TOP_ACTIF = 'O'
			and PROFIL_DOMFONC.CODDIR = l_coddir
			and PROFIL_DOMFONC.DATE_EFFET <= to_date(p_cdeb,'dd/MM/yyyy')
			and PROFIL_DOMFONC.PROFIL_DEFAUT = 'O'
      and rownum <=1
			order by PROFIL_DOMFONC.DATE_EFFET desc, PROFIL_DOMFONC.PROFIL_DOMFONC asc;
      
	BEGIN
	-- Ouverture du curseur profil domfonc
	OPEN c_profil_domfonc (p_coddir);
		LOOP
			-- Alimentation du parametre local profil avec le profil trouve
			FETCH c_profil_domfonc INTO l_profil_tmp;
			EXIT WHEN c_profil_domfonc%notfound;

			IF (VERIF_CA(l_profil_tmp.code_es, p_codcamo) = TRUE) THEN
				-- Profil domfonc applicable trouve
				l_profil := l_profil_tmp;
				EXIT;
			END IF;
		END LOOP;
	-- Fermeture du curseur profil domfonc
	CLOSE c_profil_domfonc;

    -- Si profil non trouve
    IF (l_profil.PROFIL_DOMFONC IS NULL) THEN
      -- Ouverture du curseur profil domfonc par defaut
      OPEN c_profil_domfonc_defaut (p_coddir);

      -- Alimentation du parametre local profil avec le profil par defaut trouve
      FETCH c_profil_domfonc_defaut INTO l_profil;

      -- Fermeture du curseur profil domfonc par defaut
      CLOSE c_profil_domfonc_defaut;

    END IF;

    -- Si le profil trouve n est pas nul
    IF (l_profil.PROFIL_DOMFONC IS NOT NULL) THEN
      -- Alimentation des parametres de sortie
      -- - le code profil trouve
      p_profil_fi := l_profil.PROFIL_DOMFONC;

      -- - le cout unitaire de force de travail
      p_cout_ft := l_profil.FORCE_TRAVAIL;
      -- - le cout unitaire de frais d environnement

      p_cout_env := l_profil.FRAIS_ENVIRONNEMENT;

    END IF;
	END RECHERCHER_DOMFONC;

	-- Son code ES applicable doit correspondre au CA payeur de la ligne OU etre d un niveau superieur de la meme branche dans la pyramide budgetaire du RES
	FUNCTION VERIF_CA(
		p_code_es PROFIL_FI.CODE_ES%TYPE,
		p_cafi NUMBER
	) RETURN BOOLEAN IS
		return_value_es bip.pack_profil_fi.string_array;
		CAFI_LIST VARCHAR2(32000);
		t_cafi BOOLEAN;
	BEGIN
		-- L appel a la fonction PACK_PROFIL_FI.LIST_CAFI (code_es) retourne une liste qui contient le CA payeur de la ligne BIP
		return_value_es := pack_profil_fi.split_string(
			p_str=>p_code_es,
			p_delim=>',');

		IF return_value_es.count > 0 THEN
			CAFI_LIST :='';
			FOR i IN 1..return_value_es.COUNT LOOP
				CAFI_LIST := CAFI_LIST || pack_profil_fi.LIST_CAFI(return_value_es(i));
			END LOOP;
		END IF;

		t_cafi := FALSE;

		IF(INSTR(CAFI_LIST,p_cafi) >0) THEN
			t_cafi := TRUE;
		END IF;

		RETURN t_cafi;
	END VERIF_CA;


	FUNCTION Get_Cout_Fi ( p_codsg          IN NUMBER,
                           p_cafi           IN NUMBER,
                           p_prest          IN VARCHAR2,
                           p_ident          IN NUMBER,
                           p_cdeb           IN VARCHAR2,
                           p_soccode        IN VARCHAR2,
                           p_rtype          IN VARCHAR2,
                           p_metier         IN varchar2,

                           p_niveau         IN varchar2,
						   p_codcamo 	LIGNE_BIP.CODCAMO%TYPE
                         ) RETURN NUMBER IS

    t_profil_fi VARCHAR2(50);
    t_cout      NUMBER(12,2);
    v_mois          NUMBER;
    v_date_deb      VARCHAR(8);
	l_cout_env NUMBER;
	l_type_profil NUMBER;

	BEGIN

            -- Recherche le cout HTR
            Calcul_Cout_Fi ( p_codsg, p_cafi, p_prest,p_ident, p_cdeb,p_soccode,p_rtype, p_metier , p_niveau , p_codcamo, l_type_profil, t_profil_fi, t_cout, l_cout_env );
            RETURN t_cout;

	END Get_Cout_Fi;

	FUNCTION Get_Profil_Fi (   p_codsg          IN NUMBER,
                               p_cafi           IN NUMBER,
                               p_prest          IN VARCHAR2,
                               p_ident          IN NUMBER,
                               p_cdeb           IN VARCHAR2,
                               p_soccode        IN VARCHAR2,
                               p_rtype          IN VARCHAR2,
                               p_metier         IN varchar2,

                               p_niveau         IN varchar2,
							   p_codcamo 	 	IN LIGNE_BIP.CODCAMO%TYPE,
                 p_pid IN varchar2
                         )   RETURN VARCHAR2 IS

	  l_type_profil NUMBER;
    t_profil_fi VARCHAR2(50);
    t_cout      NUMBER(12,2);
    v_mois          NUMBER;
    v_date_deb      VARCHAR(8);
	  l_cout_env NUMBER;
    v_profil_fi VARCHAR2(50);
    l_profil_last VARCHAR2(50);
    l_profil_boolean BOOLEAN := FALSE;
    l_coddir NUMBER;
    p_cout_ft NUMBER(12,2);
    p_cout_env NUMBER(12,2);
BEGIN

-- PPM 58225
IF(p_codcamo=77777) THEN

  for i in (    
  select CODCAMO from repartition_ligne 
  where PID=p_pid AND datdeb<=p_cdeb AND datfin IS NOT NULL AND p_cdeb<datfin
  UNION
  select CODCAMO from repartition_ligne 
  where PID=p_pid AND datdeb<=p_cdeb AND datfin IS NULL
  
  ) LOOP
          -- retourne le code profil FI dans le cas d un CA multi 77777
        Calcul_Cout_Fi ( p_codsg, p_cafi, p_prest,p_ident, p_cdeb,p_soccode,p_rtype, p_metier , p_niveau , i.codcamo, l_type_profil, t_profil_fi, t_cout, l_cout_env );
         IF (l_profil_boolean) 
          THEN 
                 
            IF (l_profil_last <> t_profil_fi) THEN
                 t_profil_fi:='multiCA';
               EXIT;
            ELSE
              l_profil_last := t_profil_fi;
            END IF;
         ELSE 
              l_profil_last := t_profil_fi;
              l_profil_boolean := TRUE;
         END IF;

		END LOOP;

  ELSE
          -- retourne le code profil FI dans le cas d un CA direct
          Calcul_Cout_Fi ( p_codsg, p_cafi, p_prest,p_ident, p_cdeb,p_soccode,p_rtype, p_metier , p_niveau , p_codcamo, l_type_profil, t_profil_fi, t_cout, l_cout_env );
              
  END IF;
  -- retourne le code profil FI dans le cas d un CA multi 66666
  IF (p_codcamo=66666) THEN
      t_profil_fi:='multiCA';
  END IF;

  RETURN t_profil_fi;

	END Get_Profil_Fi;


/****************************************************************************************************
     Fonction qui retourne les Profils de FI historise ( derniere mensuelle )
     On recupere le Profil de FI non plus a partir de la table PROFIL_FI,
     mais de la table historise HISTO_RESS_PROFIL_FI

     12/03/2014 SEL   PPM 58225
                      -Ajout de parametre en entree PID de la ligne BIP pour s'assurer que la requete
                       ne retourne qu'un seul resultat.
                      -Gestion de l'exception TOO_MANY_ROWS pour dire qu'il s'agit d'un multiCA

****************************************************************************************************/
	FUNCTION GET_PROFIL_FI_MENS (   p_ident     NUMBER,
                                    p_moisprest DATE,
                                    p_pid varchar2
                                )
              RETURN VARCHAR2 IS

    L_PROFIL_FI           VARCHAR2(12);

	BEGIN


        SELECT DISTINCT hist.profil_fi into l_profil_fi
        FROM  HISTO_RESS_PROFIL_FI hist
        WHERE
        hist.ident = p_ident AND
        hist.MOISPREST = p_moisprest
        AND hist.pid=p_pid;


        RETURN L_PROFIL_FI;

	EXCEPTION
       WHEN NO_DATA_FOUND THEN
          L_PROFIL_FI := 'N/A';
          return L_PROFIL_FI;
      WHEN TOO_MANY_ROWS THEN
          L_PROFIL_FI := 'multiCA';
          return L_PROFIL_FI;
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);

	END GET_PROFIL_FI_MENS;

	FUNCTION getCoutHTR_STD_FI ( p_soccode varchar2,
                                 p_rtype   char,
                                 p_metier  varchar2,
                                 p_niveau  varchar2,
                                 p_codsg   number ,
                                 p_cout_ssii number,
                                 p_cdeb    varchar2,
                                 p_filcode varchar2,
                                 p_prest   VARCHAR2,
                                 p_ident   NUMBER,

                                 p_cafi    NUMBER,
								 p_codcamo	LIGNE_BIP.CODCAMO%TYPE) Return Number IS

    l_coutHTR NUMBER(12,2);
    l_tva tva.tva%TYPE;
    l_taux_recup taux_recup.taux%TYPE;
	l_type_profil NUMBER;
    t_profil_fi VARCHAR2(12);
	l_cout_env NUMBER;

	BEGIN
		l_coutHTR:=0;

        pack_utile_cout.Calcul_Cout_Fi ( p_codsg, p_cafi, p_prest,p_ident, p_cdeb, p_soccode, p_rtype, p_metier , p_niveau , p_codcamo, l_type_profil, t_profil_fi, l_coutHTR, l_cout_env );

        IF (t_profil_fi = 'STANDARD') THEN
            -- Recherche le cout
            l_coutHTR :=getCout ( p_soccode, p_rtype, TO_NUMBER(substr(p_cdeb,5,4)), p_metier, p_niveau, p_codsg, p_cout_ssii );

            -- Si ce n est pas un logiciel et c est un prestataire
            --if (p_rtype<>'L' and p_soccode<>'SG..') then

            if (p_soccode!='SG..' and (p_rtype='P' OR p_rtype='F' OR p_rtype='E')) then
                --Applique le taux HTR au cout
            l_coutHTR := AppliqueTauxHTR ( TO_NUMBER(substr(p_cdeb,5,4)) , l_coutHTR ,  p_cdeb , p_filcode ) ;
            end if ;

        END IF;

           RETURN l_coutHTR;

	END getCoutHTR_STD_FI;

  --QC 1594

  FUNCTION getCoutEnv_Generique (p_codsg     IN NUMBER,
                                p_cafi          IN NUMBER,
                               p_prest          IN VARCHAR2,
                               p_ident          IN NUMBER,
                               p_cdeb           IN VARCHAR2,
                               p_soccode        IN VARCHAR2,
                               p_rtype          IN VARCHAR2,
                               p_metier         IN varchar2,
                               p_niveau         IN varchar2,
							   p_codcamo 	 	IN LIGNE_BIP.CODCAMO%TYPE,
							   p_annee   number,
							   p_filcode varchar2) Return Number IS


l_type_profil NUMBER;
l_profil_fi  PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE;
l_cout     PROFIL_DOMFONC.FORCE_TRAVAIL%TYPE;
l_cout_env PROFIL_DOMFONC.FRAIS_ENVIRONNEMENT%TYPE;
BEGIN
Calcul_Cout_Fi (p_codsg, p_cafi, p_prest, p_ident, p_cdeb, p_soccode, p_rtype, p_metier , p_niveau , p_codcamo, l_type_profil, l_profil_fi,l_cout,l_cout_env);

-- Si aucun profil domfonc ne correspond
IF (l_type_profil != 2) THEN
	-- Recuperation du cout d environnement standard
	return getCoutEnv(p_soccode, p_rtype, p_annee , p_codsg, p_metier);
-- Sinon (cas ou un profil domfonc est trouve)
ELSE
	-- Recuperation du cout d environnement lie au profil domfonc trouve
	return l_cout_env;
END IF;

END getCoutEnv_Generique;

/****************************************************************************************************
     12/03/2014 SEL PPM 58225   Procedure de Calcul Standards , similaire a CALCUL_COUT_FI mais forcee
                                a ne se baser que sur les couts standards

****************************************************************************************************/
PROCEDURE CALCUL_COUT_STD ( p_codsg          IN NUMBER,
                           p_cafi           IN NUMBER,
                           p_prest          IN VARCHAR2,
                           p_ident          IN NUMBER,
                           p_cdeb           IN VARCHAR2,
                           p_soccode        IN VARCHAR2,
                           p_rtype          IN VARCHAR2,
                           p_metier         IN varchar2,
                           p_niveau         IN varchar2,

						   p_codcamo 		IN LIGNE_BIP.CODCAMO%TYPE,
                           p_type_profil	OUT NUMBER,
						   p_profil_fi      OUT VARCHAR2,
                           p_cout           OUT NUMBER,
                           p_cout_env		OUT NUMBER
                         ) IS

    l_cout          NUMBER(12,2);
    l_cout_fi       NUMBER(12,2);
    l_cout_htr      NUMBER(12,2);
    l_cout_ht       NUMBER(12,2);
    i               NUMBER;
    l_profil_fi     VARCHAR2(12);

    t_prestation    BOOLEAN;
    t_localisation  BOOLEAN;
    t_code_es       BOOLEAN;
    t_cafi          BOOLEAN;


    l_coddir NUMBER;
    l_loc  VARCHAR2(3);

    CAFI_LIST       VARCHAR2(32000);
    t_profil_trouve BOOLEAN;


    l_tva tva.tva%TYPE;
    l_taux_recup taux_recup.taux%TYPE;

  	l_annee number;

BEGIN

        l_cout := 0;
        t_profil_trouve := FALSE;
        p_profil_fi := 'STANDARD';

    		-- Type Standard ou FI
		    p_type_profil := 1;

            BEGIN
                -- cout unitaire HT d une Ressource
                SELECT COUT INTO l_cout
                FROM SITU_RESS
                WHERE IDENT = p_ident
                AND to_date(p_cdeb,'DD/MM/YYYY') >= DATSITU
                AND (to_date(p_cdeb,'DD/MM/YYYY') <= DATDEP OR DATDEP IS NULL);

            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_cout := null;
            END;

            -- Recherche du taux de tva
            BEGIN
                SELECT t.tva into l_tva
                       FROM tva t
                       WHERE
                       t.datetva = (SELECT max(tva.datetva) FROM tva where datetva <= to_date(p_cdeb,'DD/MM/YYYY'));
            EXCEPTION
                 WHEN OTHERS THEN
                         -- Code TVA inexistant
                        l_tva := 0 ;
            END;

            -- Recherche du taux de recuperation pour la filiale
            BEGIN
                SELECT taux into l_taux_recup
                       FROM taux_recup tr, struct_info si
                       WHERE   tr.annee = to_number(substr(replace(p_cdeb,'/',''),5,4))
                       --and     filcode = p_filcode
                       and tr.FILCODE = si.FILCODE
                       and si.CODSG = p_codsg;

            EXCEPTION
                 WHEN OTHERS THEN
                         -- Taux de recuperation non trouve
                l_taux_recup := 0 ;
            END;

            IF (p_soccode='SG..') then

                BEGIN
                    -- On prend le cout deja HTR a partir de la table des couts standards SG COUT_STD_SG des lignes dont le code societe ='SG..' par annee,niveau,metier,dpg
                    select cout_sg into l_cout_htr
                    from cout_std_sg
                    where p_codsg between dpg_bas and dpg_haut
                    and metier = rtrim(p_metier)
                    and niveau = decode(p_niveau,'L','HC','M','HC','N','HC',p_niveau)
                    and annee = to_number(substr(replace(p_cdeb,'/',''),5,4));

                    l_cout_ht := l_cout_htr / ( 1 + l_tva/100 * (1 - l_taux_recup/100) );

                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_cout_htr := null;
                END;

            ELSE

                IF p_rtype='L' THEN
                    Begin
                        -- Logiciel : cout logiciel HTR de la table COUT_STD2 en fonction du DPG de la ressource
                        select cout_log into l_cout_htr
                        from cout_std2
                        where p_codsg between dpg_bas and dpg_haut
                        and annee = to_number(substr(replace(p_cdeb,'/',''),5,4));

                        l_cout_ht := l_cout_htr / ( 1 + l_tva/100 * (1 - l_taux_recup/100) );

                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        l_cout_htr := null;
                    END;

                ELSE
                     -- Un externe et On recupere directement son cout unitaire HT dans la situation
                     l_cout_ht := l_cout;
                END IF;

            END IF;

            p_cout := l_cout_ht;

  p_profil_fi:='STANDARD';

EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END Calcul_Cout_Std;

END pack_utile_cout;
/

show errors