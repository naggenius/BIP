-- --------------------------------------------------------------------------
-- Créé le 06/03/2006 par DDI pour la fiche TD365
--
-- Modifié le 28/03/2006 par DDI . Motif : Fiche TD384
-- --------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_ecartsbud AS
  -- ------------------------------------------------------------------------
  -- Decription :  Permet de déterminer le type d'alerte sur les écarts budgétaires
  -- Paramètres :  p_param6 (IN) situ_ress.codsg%type: code dpg
  -- param
  --               p_message (out) varchar2
  --               p_alerte  (out) varchar2 (type d'écart budgétaire)
  -- Retour     :  renvoie rien si ok, erreur sinon
  -- ------------------------------------------------------------------------


FUNCTION  verif_reecons(p_reestime IN number,
			p_consomme IN number
			) return VARCHAR2;

FUNCTION  verif_reearb( p_reestime IN number,
			p_arbitre IN number
			) return VARCHAR2;

FUNCTION  verif_conso_sans_budget(p_consomme IN number,
				  p_arbitre IN number,
				  p_propose IN number,
				  p_notifie IN number
				) return VARCHAR2;

FUNCTION  verif_ecarts_budgetaires(
		    	p_pid      IN varchar2,
		  	p_reestime IN number,
			p_consomme IN number,
			p_arbitre  IN number,
			p_propose  IN number,
			p_notifie  IN number
			) return VARCHAR2;				

END pack_ecartsbud;
/


CREATE OR REPLACE PACKAGE BODY pack_ecartsbud AS

  -- ------------------------------------------------------------------------
  --
  -- ------------------------------------------------------------------------

-- ---------------------------------------------------
FUNCTION  verif_reecons(p_reestime IN number,
			p_consomme IN number
			) RETURN VARCHAR2 IS

  l_msg VARCHAR2(1024) :='';
  p_alerte VARCHAR2(20);

BEGIN

 	if (p_reestime < p_consomme)
 	then
      		p_alerte := 'Estimé à revoir';
      	else 	p_alerte := '';
  	end if;

  	return p_alerte;

END verif_reecons;
-- ---------------------------------------------------
FUNCTION  verif_reearb(	p_reestime IN number,
			p_arbitre IN number
			) RETURN VARCHAR2 IS

  l_msg VARCHAR2(1024) :='';
  p_alerte VARCHAR2(20);

BEGIN

 	if (p_reestime > p_arbitre)
 	then
      		p_alerte := 'A justifier';
      	else 	p_alerte := '';
  	end if;

  	return p_alerte;

END verif_reearb;
-- ----------------------------------------------------
FUNCTION  verif_conso_sans_budget(p_consomme IN number,
				  p_arbitre IN number,
				  p_propose IN number,
				  p_notifie IN number
				  ) RETURN VARCHAR2 IS

  l_msg VARCHAR2(1024) :='';
  p_alerte VARCHAR2(20);

BEGIN
 	if ((p_consomme > 0) and ( p_arbitre = 0 and p_propose =0 and p_notifie = 0 )	)
 	then
      		p_alerte := 'Conso sans budget';
      	else 	p_alerte := '';
  	end if;
  	return p_alerte;

END verif_conso_sans_budget;
-- ----------------------------------------------------
-- ---------------------------------------------------
FUNCTION  verif_ecarts_budgetaires(
		    	p_pid      IN varchar2,
		    	p_reestime IN number,
			p_consomme IN number,
			p_arbitre  IN number,
			p_propose  IN number,
			p_notifie  IN number
			) RETURN VARCHAR2 IS

  l_msg VARCHAR2(1024) :='';
  p_alerte VARCHAR2(255);
  l_commentaire1 VARCHAR2(255) := ' ';
  l_commentaire2 VARCHAR2(255) := ' ';
  l_commentaire3 VARCHAR2(255) := ' ';
BEGIN
	p_alerte := '';
	
 	if (p_reestime < p_consomme)
 	then
      		l_commentaire1 := 'Estimé à revoir';
  	end if;
	
--	dbms_output.put_line('1: '||l_commentaire1);
	
-----------	
	if (p_reestime > p_arbitre)
 	then
		
	  BEGIN		
		select commentaire into l_commentaire2
		from budget_ecart 
		where pid         = p_pid
		  and type        = 'REE>ARB';

		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
          l_commentaire2 := ' ';
  	  END;  
		  
--	dbms_output.put_line('2: '||l_commentaire2);  

  	end if;
-----------
	if ((p_consomme > 0) and ( p_arbitre = 0 and p_propose =0 and p_notifie = 0 )	)
 	then
		
	  BEGIN
		select commentaire into l_commentaire3
		from budget_ecart 
		where pid         = p_pid
		  and type        = 'CONS-BUD';

		EXCEPTION
		  WHEN NO_DATA_FOUND THEN
          l_commentaire3 := ' ';
  	  END;  
	  
--	dbms_output.put_line('3: '||l_commentaire3);
	  
  	end if;
-----------	
	p_alerte := l_commentaire1 || ';' || l_commentaire2 || ';' || l_commentaire3;
--	dbms_output.put_line('ALERTE: '||p_alerte);

  	return p_alerte;

END verif_ecarts_budgetaires;
-- ---------------------------------------------------
END pack_ecartsbud;
/

