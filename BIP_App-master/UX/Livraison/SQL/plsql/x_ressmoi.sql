create or replace
PACKAGE     PACK_X_RESSMOI IS
   FUNCTION getCout( p_soccode varchar2,
                      p_rtype   char,
                      p_metier  varchar2,
                      p_niveau  varchar2,
                      p_codsg   number ,
                      p_cafi    NUMBER,
                      p_cout_ssii number,
                      p_prest     VARCHAR2,
                      p_ident     NUMBER,
                      p_cdeb      VARCHAR2,
					  p_codcamo LIGNE_BIP.CODCAMO%TYPE
                     ) Return Number;

  FUNCTION getCoutTTC ( p_soccode varchar2,
                      p_rtype   char,
                      p_metier  varchar2,
                      p_niveau  varchar2,
                      p_codsg   number ,
                      p_cafi    NUMBER,
                      p_cout_ssii number,
                      p_prest     VARCHAR2,
                      p_ident     NUMBER,
                      p_cdeb    varchar2 ,
					  p_codcamo LIGNE_BIP.CODCAMO%TYPE) Return Number;
  FUNCTION getCoutHTR ( p_soccode varchar2,
                      p_rtype   char,
                      p_metier  varchar2,
                      p_niveau  varchar2,
                      p_codsg   number ,
                      p_cafi    NUMBER,
                      p_cout_ssii number,
                      p_prest     VARCHAR2,
                      p_ident     NUMBER,
                      p_cdeb    varchar2,
                      p_filcode varchar2,
					  p_codcamo LIGNE_BIP.CODCAMO%TYPE) Return Number ;
END pack_x_ressmoi;
/

create or replace
PACKAGE BODY     PACK_X_RESSMOI AS

FUNCTION getCout (    p_soccode VARCHAR2,
                      p_rtype   CHAR,
                      p_metier  VARCHAR2,
                      p_niveau  VARCHAR2,
                      p_codsg   NUMBER ,
                      p_cafi    NUMBER,
                      p_cout_ssii NUMBER,
                      p_prest     VARCHAR2,
                      p_ident     NUMBER,
                      p_cdeb      VARCHAR2,
					  p_codcamo LIGNE_BIP.CODCAMO%TYPE
                 ) Return Number IS

l_cout NUMBER(12,2);
l_cout_env NUMBER(12,2);
l_type_profil NUMBER;
t_profil_fi VARCHAR2(12);


    BEGIN
        l_cout:=0;
       
       --PPM 58225
       --pack_utile_cout.CALCUL_COUT_STD(p_codsg, p_cafi, p_prest , p_ident, p_cdeb, p_soccode, p_rtype, p_metier , p_niveau , p_codcamo, l_type_profil, t_profil_fi , l_cout, l_cout_env);

       --IF( t_profil_fi = 'STANDARD' ) THEN

             IF (p_soccode='SG..') then
                 select cout_sg into l_cout
                from cout_std_sg
               where p_codsg between dpg_bas and dpg_haut
                and metier = rtrim(p_metier)
                and niveau = decode(p_niveau,'L','HC','M','HC','N','HC',p_niveau)
                and annee = to_number(substr(p_cdeb,5,4))
               ;
             ELSE
                 IF p_rtype='L' then
                     select cout_log into l_cout
                    from cout_std2
                    where p_codsg between dpg_bas and dpg_haut
                     and annee = to_number(substr(p_cdeb,5,4));

                 ELSE
                      l_cout := p_cout_ssii;

                 END IF;

             END IF;

       --END IF;

        RETURN l_cout;

   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RETURN l_cout;
     WHEN OTHERS THEN
       RETURN l_cout;
    END getCout;

-- Renvoie le cout TTC
FUNCTION getCoutTTC ( p_soccode varchar2,
                      p_rtype   char,
                      p_metier  varchar2,
                      p_niveau  varchar2,
                      p_codsg   number ,
                      p_cafi    NUMBER,
                      p_cout_ssii number,
                      p_prest     VARCHAR2,
                      p_ident     NUMBER,
                      p_cdeb    varchar2 ,
					  p_codcamo LIGNE_BIP.CODCAMO%TYPE) Return Number IS


l_coutTTC NUMBER(12,2);
l_cout_env NUMBER(12,2);
l_tva tva.tva%TYPE;
l_type_profil NUMBER;
t_profil_fi VARCHAR2(12);

BEGIN
    l_coutTTC:=0;
        
         --PPM 58225
        --pack_utile_cout.CALCUL_COUT_FI(p_codsg, p_cafi, p_prest , p_ident, p_cdeb, p_soccode, p_rtype, p_metier , p_niveau , p_codcamo, l_type_profil, t_profil_fi , l_coutTTC, l_cout_env);

       -- IF (t_profil_fi = 'STANDARD') THEN
            -- Recherche le cout
            l_coutTTC := getCout ( p_soccode, p_rtype, p_metier, p_niveau, p_codsg, p_cafi, p_cout_ssii, p_prest, p_ident , p_cdeb, p_codcamo );

            -- Si ce n'est pas un logiciel et c'est un prestataire
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

       -- END IF;

       RETURN l_coutTTC;

END getCoutTTC;

-- Renvoie le cout HTR
FUNCTION getCoutHTR ( p_soccode varchar2,
                      p_rtype   char,
                      p_metier  varchar2,
                      p_niveau  varchar2,
                      p_codsg   number ,
                      p_cafi    NUMBER,
                      p_cout_ssii number,
                      p_prest     VARCHAR2,
                      p_ident     NUMBER,
                      p_cdeb    varchar2,
                      p_filcode varchar2,
					  p_codcamo LIGNE_BIP.CODCAMO%TYPE) Return Number IS

    l_coutHTR NUMBER(12,2);
	l_cout_env NUMBER(12,2);
    l_tva tva.tva%TYPE;
    l_taux_recup taux_recup.taux%TYPE;
	l_type_profil NUMBER;
    t_profil_fi VARCHAR2(12);

BEGIN

    l_coutHTR:=0;
    
     --PPM 58225
     --pack_utile_cout.CALCUL_COUT_FI(p_codsg, p_cafi, p_prest , p_ident, p_cdeb, p_soccode, p_rtype, p_metier , p_niveau , p_codcamo, l_type_profil, t_profil_fi , l_coutHTR, l_cout_env);
     --IF (t_profil_fi = 'STANDARD') THEN
     -- Recherche le cout
     
        l_coutHTR :=getCout ( p_soccode, p_rtype, p_metier, p_niveau, p_codsg, p_cafi, p_cout_ssii, p_prest, p_ident , p_cdeb, p_codcamo );

        -- Si ce n'est pas un logiciel et c'est un prestataire
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

            -- Recherche du taux de récupération pour la filiale
            BEGIN
                SELECT taux into l_taux_recup
                       FROM taux_recup
                       WHERE    annee = to_number(substr(p_cdeb,5,4))
                       and     filcode = p_filcode ;

            EXCEPTION
                 WHEN OTHERS THEN
                         -- Taux de récupération non trouvé
                l_taux_recup := 0 ;
            END;

            -- Applique la TVA et le taux de récup au cout
            l_coutHTR := l_coutHTR * ( 1 + l_tva/100 * (1 - l_taux_recup/100) ) ;
        end if ;

   -- END IF;

   RETURN l_coutHTR;

END getCoutHTR;

END pack_x_ressmoi;
/

show errors