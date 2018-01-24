-- -------------------------------------------------------------------
-- pack_verif_edsstr PL/SQL
--
-- equipe SOPRA (HT)
--
--
-- Package qui sert à la réalisation des états edsstr...

-- Modifié le 05/11/2001 par NBM:remplacement de la table cout_prestation par la table prestation
-- Modifié le 02/12/2003 par MMC : modifications IAS --> calcul des couts SG
--					ajout de ins_edsstr3, ins_edsstr4 et de f_calcul  
-- Modifié le 26/01/2004 par MMC : ajout règle de gestion sur les niveaux (L M N consideres comme HC)
--				   suppression des functions f_coutfi et f_codfi
-- Modifié le 04/05/2004 par PJO : Suppression des commits pour éviterles mélanges de données.    
-- Modifié le 12/05/2004 par PJO : Renommage des colonnes avec des noms homogènes pour la BIP      
-- Modifié le 26/05/2004 par PJO : Utilisation de la table situ_ress_full au lieu de situ_ress
--				   Supression de la restriction au type 1,2,3,4
--				   Supression de la fonction f_datsitu_recente qui ne sert plus
-- -------------------------------------------------------------------

-- SET SERVEROUTPUT ON SIZE 1000000;

CREATE OR REPLACE PACKAGE pack_verif_edsstr  AS


   -- Paramètres : 
   --              p_factpid (IN)         
   --			 p_soci(IN)     'SG ou SSII' soc. des ressources
   --              p_type (IN)    'M ou A' mensuel ou annuel  
   --              p_moisannee (IN)  Ex. : 01/04/1999             
   -- ---------------------------------------------------------------


FUNCTION f_cp(	p_pid	IN varchar2
			) RETURN VARCHAR2;


PRAGMA restrict_references(f_cp, WNDS, WNPS);

FUNCTION f_jhcout(	p_pole		in varchar2,
			p_pole_client	in varchar2,
			p_societe	in varchar2,
			p_type		in varchar2,
			p_fi		in varchar2,
			p_rf		in varchar2
			  ) return number;

PRAGMA restrict_references(f_jhcout, WNDS, WNPS);

FUNCTION f_calcul(	p_poler		IN  VARCHAR2 ,
			p_polee		IN  VARCHAR2 ,
			p_type		IN  VARCHAR2 ,
			p_ident		IN  VARCHAR2,
			p_ligr		in VARCHAR2,
			p_lige		IN VARCHAR2,
			p_soc		IN VARCHAR2   
			  ) return number;

PRAGMA restrict_references(f_calcul, WNDS, WNPS);

PROCEDURE f_ins_edsstr(p_pole in varchar2);
PROCEDURE f_ins_edsstr3(p_pole IN VARCHAR2);
PROCEDURE f_ins_edsstr4(p_pole IN VARCHAR2);

END pack_verif_edsstr;
/

CREATE OR REPLACE PACKAGE BODY pack_verif_edsstr  AS 
-- ---------------------------------------------------

FUNCTION f_cp (
		p_pid		IN varchar2
		) RETURN VARCHAR2
IS

l_nom_pid	VARCHAR2(30);

BEGIN
	select pnom into l_nom_pid from ligne_bip where pid=p_pid;
	return(l_nom_pid);
END f_cp;


/*******************************************************/
FUNCTION f_jhcout(	p_pole		IN  VARCHAR2 ,
			p_pole_client	IN  VARCHAR2 ,
			p_societe	IN  VARCHAR2 ,
			p_type		IN  VARCHAR2 ,
			p_fi		IN  VARCHAR2 ,
			p_rf		IN  VARCHAR2 
		  ) return number
IS

l_nombre	number(10,2);

BEGIN
IF  p_type='1' THEN    -- calcul des jh
	IF  p_societe = 'SG..' THEN 
		BEGIN 
		SELECT  
			sum(nvl(cusag,0)) into l_nombre
		FROM 
			tmpedsstr
		WHERE 
			societe = 'SG..'
			and pole_r = LPAD(p_pole, 5, '0')
			and pole_e = LPAD(p_pole_client, 5, '0')
			and sstr = p_rf;
		end;
	ELSE 
		BEGIN 
		SELECT  
			sum(nvl(cusag,0)) into l_nombre
		FROM 
			tmpedsstr
		WHERE 
			societe <> 'SG..'
			and pole_r = LPAD(p_pole, 5, '0')
			and pole_e = LPAD(p_pole_client, 5, '0')
			and sstr = p_rf;
		END;
	END  IF ;
ELSIF  p_type='2' then	-- calcul des couts
  IF  p_fi = 'N' then
	IF  p_societe = 'SG..' then
		BEGIN 
		SELECT  
			sum(cout*nvl(cusag,0)) into l_nombre
		FROM 
			tmpedsstr
		WHERE 
			societe = 'SG..'
			and pole_r = LPAD(p_pole, 5, '0')
			and pole_e = LPAD(p_pole_client, 5, '0')
			and sstr = p_rf;
		END ;
	ELSE 
		BEGIN 
		SELECT  
			sum(cout*nvl(cusag,0)) into l_nombre
		FROM 
			tmpedsstr
		WHERE 
			societe <> 'SG..'
			and pole_r = LPAD(p_pole, 5, '0')
			and pole_e = LPAD(p_pole_client, 5, '0')
			and sstr = p_rf;
		END ;
	END  IF ;
    END  IF ;
END  IF ;

return(nvl(l_nombre,0));

END f_jhcout;

/*******************************************************/
FUNCTION f_calcul(	p_poler		IN  VARCHAR2 ,
			p_polee	IN  VARCHAR2 ,
			p_type		IN  VARCHAR2 ,
			p_ident		IN  VARCHAR2,
			p_ligr		in VARCHAR2,
			p_lige		IN VARCHAR2,
			p_soc		IN VARCHAR2 
		  ) return number
IS

l_nombre	NUMBER(10,2);

BEGIN
IF  p_type='1' THEN    -- calcul des jh
	BEGIN 
		SELECT  
			sum(nvl(cusag,0)) into l_nombre
		FROM 
			tmpedsstr
		WHERE 	pole_r = LPAD(p_poler, 5, '0')
			and pole_e = LPAD(p_polee, 5, '0')
			and ident = p_ident
			and pid_r = p_ligr
			and pid_e = p_lige
			and societe = p_soc;
	END;
ELSIF  p_type='2' then	-- calcul des couts
  		BEGIN 
		SELECT  
			sum(cout*nvl(cusag,0)) into l_nombre
		FROM 
			tmpedsstr
		WHERE   pole_r = LPAD(p_poler, 5, '0')
			AND pole_e = LPAD(p_polee, 5, '0')
			AND ident = p_ident
			and pid_r = p_ligr
			and pid_e = p_lige
			and societe = p_soc;
		END ;

END  IF ;

return(nvl(l_nombre,0));

END f_calcul;

/*****************************************/
PROCEDURE f_ins_edsstr(p_pole IN  VARCHAR2) 
IS

CURSOR C0 IS
--sous traitance recue
SELECT  
	 SUBSTR(TO_CHAR(p.divsecgrou, 'FM0000000'),1,5) pole_e,
	 SUBSTR(TO_CHAR(p.factpdsg, 'FM0000000'),1,5) 	pole_r,
	 p.factpid 	pid_r,
	 p.tires 	ident,
	 p.cusag 	cusag,
	 p.pid 		pid_e,
	 TO_CHAR(p.pdsg, 'FM0000000') 	codsg,
	 p.societe 	societe,
	 p.qualif 	qualif,
	 'R'		sstr,
	 p.divsecgrou
FROM 
	 proplus p,
	 situ_ress_full srf,
	 ressource r,
	 datdebex dx
WHERE 
	srf.ident=p.tires
	AND srf.ident=r.ident
	AND (srf.datsitu <= p.cdeb or srf.datsitu IS NULL)
	AND (srf.datdep >= p.cdeb or srf.datdep IS NULL)
	and substr(TO_CHAR(p.divsecgrou, 'FM0000000'),1,5)<>substr(TO_CHAR(p.factpdsg, 'FM0000000'),1,5)
	and p.cusag <>0 and p.cusag is not null
	and substr(to_char(p.factpdsg, 'FM0000000'),1,5) like LPAD(p_pole, 5 , '0')
	and trunc(p.cdeb,'Y') = dx.datdebex
	and trunc(p.cdeb,'mm') <= dx.moismens
        and p.qualif not in ('MO ','STA','INT','IFO','GRA')
UNION ALL
--sous traitance fournie	 
SELECT 
	substr(TO_CHAR(p.divsecgrou, 'FM0000000'),1,5) 	pole_e, 
	substr(TO_CHAR(p.factpdsg, 'FM0000000'),1,5)	pole_r,
	p.factpid					pid_r,
	p.tires						ident,
	p.cusag						cusag,
	p.pid						pid_e,
	TO_CHAR(p.pdsg, 'FM0000000')			codsg,
	p.societe					societe,
	p.qualif					qualif,
	'F'						sstr,
	p.divsecgrou
FROM 
	proplus p,
	situ_ress_full srf,
	ressource r,
	datdebex dx
WHERE 
	srf.ident=p.tires
	AND srf.ident=r.ident
	AND (srf.datsitu <= p.cdeb or srf.datsitu IS NULL)
	AND (srf.datdep >= p.cdeb or srf.datdep IS NULL)
	and substr(TO_CHAR(p.divsecgrou, 'FM0000000'),1,5)<>substr(TO_CHAR(p.factpdsg, 'FM0000000'),1,5)
	and p.cusag <>0 and p.cusag is not null
	and substr(TO_CHAR(p.divsecgrou, 'FM0000000'),1,5) like LPAD(p_pole,5,'0')
	and trunc(p.cdeb,'Y') = dx.datdebex
	and trunc(p.cdeb,'mm') <= dx.moismens
        and p.qualif not in ('MO ','STA','INT','IFO','GRA');
	
ligne0 C0%rowtype;
l_coutfi number(12,2);

BEGIN

OPEN C0;
LOOP
FETCH C0 into ligne0;
EXIT when C0%notfound;



INSERT  into tmpedsstr
(pole_e,pole_r,pid_r,ident,cout,coutfi,cusag,pid_e,codsg,societe,sstr)
values
(ligne0.pole_e,
ligne0.pole_r,
ligne0.pid_r,
ligne0.ident,
0,
0,
ligne0.cusag,
ligne0.pid_e,
ligne0.codsg,
ligne0.societe,
ligne0.sstr
);
END LOOP;


END f_ins_edsstr;

/*******************************************************/
PROCEDURE f_ins_edsstr3(p_pole IN VARCHAR2) 
IS
--cette procedure est appelee pour le reports EDSSTR3.rdf
--qui calcule la sous traitance fournie
CURSOR C0 IS
--sous traitance fournie en tenant compte du périmètre utilisateur
SELECT SUBSTR(TO_CHAR(p.divsecgrou, 'FM0000000'),1,5) pole_e,
         SUBSTR(TO_CHAR(p.factpdsg, 'FM0000000'),1,5) pole_r,
         p.factpid 	pid_r,
         p.tires 	ident,
         p.cusag 	cusag,
         p.pid 		pid_e,
         TO_CHAR(p.pdsg, 'FM0000000') codsg,
         p.societe 	societe,
         p.qualif 	qualif,
         'F'            sstr
FROM
        datdebex d,
        situ_ress_full srf,
        ressource r,
        proplus p
WHERE
	srf.ident=p.tires
	AND srf.ident=r.ident
	AND (srf.datsitu <= p.cdeb or srf.datsitu IS NULL)
	AND (srf.datdep >= p.cdeb or srf.datdep IS NULL)
        and substr(TO_CHAR(p.divsecgrou, 'FM0000000'),1,5)<>substr(TO_CHAR(p.factpdsg, 'FM0000000'),1,5)
        and p.cusag <>0 and p.cusag is not null
        and trunc(p.cdeb,'YEAR')=d.datdebex
        and substr(to_char(p.divsecgrou, 'FM0000000'),1,5) like LPAD(p_pole, 5 , '0')
        and to_char(p.cdeb,'mm') <= to_char(d.moismens,'mm')
        and p.qualif not in ('MO ','STA','INT','IFO','GRA')
;

	
ligne0 C0%rowtype;
l_coutfi number(12,2);

BEGIN

	OPEN C0;
	LOOP
	FETCH C0 into ligne0;
	EXIT when C0%notfound;

	INSERT  into tmpedsstr
		(pole_e,pole_r,pid_r,ident,cout,coutfi,cusag,pid_e,codsg,societe,sstr)
	values	(ligne0.pole_e,
		ligne0.pole_r,
		ligne0.pid_r,
		ligne0.ident,
		0,
		0,
		ligne0.cusag,
		ligne0.pid_e,
		ligne0.codsg,
		ligne0.societe,
		ligne0.sstr);
	END LOOP;

END f_ins_edsstr3;
/*******************************************************/

/*******************************************************/
PROCEDURE f_ins_edsstr4(p_pole IN VARCHAR2) 
IS
--cette procedure est appelee pour le reports EDSSTR4.rdf
--qui calcule la sous traitance recue
CURSOR C0 IS
--sous traitance recue pour le périmètre de l'utilisateur
SELECT SUBSTR(TO_CHAR(p.divsecgrou, 'FM0000000'),1,5) pole_e,
         SUBSTR(TO_CHAR(p.factpdsg, 'FM0000000'),1,5) pole_r,
         p.factpid pid_r,
         p.tires ident,
         p.cusag cusag,
         p.pid pid_e,
         TO_CHAR(p.pdsg, 'FM0000000') codsg,
         p.societe societe,
         p.qualif qualif,
         'R'            sstr
FROM
        datdebex d,
        situ_ress_full srf,
        ressource r,
        proplus p
WHERE
	srf.ident=p.tires
	AND srf.ident=r.ident
	AND (srf.datsitu <= p.cdeb or srf.datsitu IS NULL)
	AND (srf.datdep >= p.cdeb or srf.datdep IS NULL)
        and substr(TO_CHAR(p.divsecgrou, 'FM0000000'),1,5)<>substr(TO_CHAR(p.factpdsg, 'FM0000000'),1,5)
        and p.cusag <>0 and p.cusag is not null
        and substr(to_char(p.factpdsg, 'FM0000000'),1,5) like LPAD(p_pole, 5 , '0')
        and to_char(p.cdeb,'yyyy') =  TO_CHAR(d.datdebex,'yyyy')
        and to_char(p.cdeb,'mm') <= to_char(d.moismens,'mm')
        and p.qualif not in ('MO ','STA','INT','IFO','GRA')
;

ligne0 C0%rowtype;
l_coutfi number(12,2);

BEGIN
	OPEN C0;
	LOOP FETCH C0 into ligne0;
	EXIT when C0%notfound;

	INSERT  into tmpedsstr
		(pole_e, pole_r, pid_r, ident, cout, coutfi, cusag, pid_e, codsg, societe, sstr)
	values
		(ligne0.pole_e,
		ligne0.pole_r,
		ligne0.pid_r,
		ligne0.ident,
		0,
		0,
		ligne0.cusag,
		ligne0.pid_e,
		ligne0.codsg,
		ligne0.societe,
		ligne0.sstr);
	END LOOP;

END f_ins_edsstr4;

END pack_verif_edsstr;
/
