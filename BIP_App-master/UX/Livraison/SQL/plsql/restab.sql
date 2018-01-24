-- -------------------------------------------------------------------
-- pack_verif_restab PL/SQL
--
-- equipe SOPRA (HT)
--
-- crée le 23/02/2000
--
-- Package qui sert à la réalisation de l'état RESTAB...
--                   
-- -------------------------------------------------------------------
--
--*********************************************************************************************
-- Quand      Qui  Quoi
-- -----      ---  ----------------------------------------------------------------------------
-- 01/02/2001 PHD  Ajout des nouvelles ss-taches DEMENA, RTT, PARTIE
--*********************************************************************************************

-- SET SERVEROUTPUT ON SIZE 1000000;

CREATE OR REPLACE PACKAGE pack_verif_restab  AS
   --
   -- Nom        : f_reserve
   -- Auteur     : Equipe SOPRA (HT)
   -- Paramètres : 
   --              p_factpid (IN)         
   --			 p_soci(IN)     'SG ou SSII' soc. des ressources
   --              p_type (IN)    'M ou A' mensuel ou annuel  
   --              p_moisannee (IN)  Ex. : 01/04/1999             
   -- ---------------------------------------------------------------

   FUNCTION f_datsitu_recente(
			    p_ident             IN NUMBER
			     ) RETURN DATE;

PRAGMA restrict_references(f_datsitu_recente, WNDS, WNPS);

   FUNCTION f_date_arrivee(
			    p_ident             IN NUMBER
			    ) RETURN VARCHAR2;


PRAGMA restrict_references(f_date_arrivee, WNDS, WNPS);

   FUNCTION f_codsoc(
			    p_ident	IN NUMBER
			    ) RETURN VARCHAR2;


PRAGMA restrict_references(f_codsoc, WNDS, WNPS);

   FUNCTION f_dateclot(
			  date_cloture 	IN DATE,
			  typ		IN CHAR
			    ) RETURN VARCHAR2;


PRAGMA restrict_references(f_dateclot, WNDS, WNPS);

   FUNCTION f_absences(
			  p_tires		IN NUMBER,
			  mois_calcule		IN VARCHAR2,
			  annee_calculee	IN VARCHAR2,
			  typ			IN VARCHAR2,
			  codsg			IN VARCHAR2
			) RETURN NUMBER;


PRAGMA restrict_references(f_absences, WNDS, WNPS);

   FUNCTION f_cp(
			cpident		IN NUMBER
			) RETURN VARCHAR2;


PRAGMA restrict_references(f_cp, WNDS, WNPS);
	
END pack_verif_restab;
/

CREATE OR REPLACE PACKAGE BODY pack_verif_restab  AS 
-- ---------------------------------------------------


FUNCTION f_datsitu_recente(
			p_ident             IN NUMBER	
		) return DATE
IS

p_datsitu_recente	DATE;

BEGIN
	select max(datsitu) into p_datsitu_recente from situ_ress where ident=p_ident
		;
	return(p_datsitu_recente);

END f_datsitu_recente;


FUNCTION f_date_arrivee(
			   p_ident             IN NUMBER
			) return VARCHAR2
IS			     

compteur 	NUMBER(5);
nbjour		NUMBER(7);
datsitu_max	DATE;
datdep_prec	DATE;
p_date_arrivee  VARCHAR2(10);

CURSOR C1 IS select datsitu,datdep from situ_ress where ident=p_ident order by datsitu;
CURSOR C2 IS select datsitu,datdep from situ_ress where ident=p_ident order by datsitu;
ligne1 C1%rowtype;
ligne2 C2%rowtype;

BEGIN
select max(datsitu) into datsitu_max from situ_ress where ident=p_ident;
select count(*) into compteur from situ_ress where ident=p_ident;      
if compteur=1 then 
	select to_char(datsitu,'DD/MM/YYYY') into p_date_arrivee 
		from situ_ress where ident=p_ident;
elsif compteur > 1 then
	BEGIN
	OPEN C1;
	LOOP
	FETCH C1 into ligne1;
	datdep_prec := ligne1.datdep;
	EXIT when C1%notfound;
		OPEN C2;
		LOOP
		FETCH C2 into ligne2;
		EXIT when C2%notfound;
			if ligne2.datsitu <= ligne1.datsitu then
				 null;
			else 
				nbjour := ligne2.datsitu - datdep_prec;
				if nbjour >= 365 then 
					exit;
				else
					datdep_prec := ligne2.datdep;
					if ligne2.datsitu = datsitu_max then
					p_date_arrivee := to_char(ligne1.datsitu,'DD/MM/YYYY');
					exit;
					end if;
				end if;
			end if; 
		END LOOP;
		CLOSE C2;		
	if p_date_arrivee is not null then exit;end if;
	END LOOP;
	CLOSE C1;
	if p_date_arrivee is null then p_date_arrivee := to_char(datsitu_max,'DD/MM/YYYY');
	end if;
	END;
end if;
return(p_date_arrivee);
END f_date_arrivee;

FUNCTION f_codsoc(
			p_ident             IN NUMBER	
		) return VARCHAR2
IS

code_societe VARCHAR2(4);
p_date_arrivee	VARCHAR2(10);

BEGIN
	p_date_arrivee := f_date_arrivee(p_ident);
	select soccode into code_societe from situ_ress 
		where datsitu=to_date(p_date_arrivee,'DD/MM/YYYY')
		and ident = p_ident;
return(code_societe);

END f_codsoc;


FUNCTION f_dateclot(
			date_cloture	 IN DATE,
			typ		 IN CHAR	
		) return VARCHAR2
IS

mois_calcule	VARCHAR2(2);
annee_calculee	VARCHAR2(4);

BEGIN

	if date_cloture > sysdate and to_char(date_cloture,'YYYY')=to_char(sysdate,'YYYY') then
		mois_calcule := '12';
		annee_calculee := to_char(add_months(sysdate,-12),'YYYY');
	else
		mois_calcule := to_char(add_months(sysdate,-1),'MM');
		annee_calculee :=  to_char(add_months(sysdate,-1),'YYYY');
	end if;

	if typ = 'M' then
		return(mois_calcule);
	elsif typ = 'A' then
		return(annee_calculee);
	end if;

END f_dateclot;

FUNCTION f_absences(
		p_tires 	IN NUMBER,
		mois_calcule	IN VARCHAR2,
		annee_calculee	IN VARCHAR2,
		typ		IN VARCHAR2,
		codsg		IN VARCHAR2
			) return NUMBER
IS

calcul		NUMBER;
dern_jour	DATE;
l_codsg 	varchar2(10);

BEGIN

dern_jour :=last_day(to_date(mois_calcule || '/' || annee_calculee, 'MM/YYYY'));
l_codsg := codsg||'%';

	select sum(cusag) into calcul from proplus 
	where tires=p_tires 
	and ((TO_CHAR(divsecgrou, 'FM0000000')) like l_codsg
	    or (TO_CHAR(divsecgrou)) like l_codsg)
	and cdeb between 
		to_date('01/01/' || (annee_calculee),'DD/MM/YYYY')
		and
		dern_jour
	and aist like decode(typ,'TOTAL','%',typ)
	and aist in ('CONGES','ABSDIV','FORMAT','FORFAC','MOBILI','CLUBUT','SEMINA','DEMENA','PARTIE','RTT');

return(calcul);
END f_absences;


FUNCTION f_cp (
		cpident		IN NUMBER
		) RETURN VARCHAR2
IS

nom_cp	VARCHAR2(30);

BEGIN
	select rnom into nom_cp from ressource where ident=cpident;
	return(nom_cp);
END f_cp;

END pack_verif_restab;
/
