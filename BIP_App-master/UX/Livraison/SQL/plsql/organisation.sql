 /* ***************************************
 
  Package servant à l'édition de l'organisation structure
  Appelée par organisation.rdf
  
  Modifié par  le // :  
  
  ****************************************** */

CREATE OR REPLACE PACKAGE BIP.pack_organisation AS


FUNCTION Delete_Organisation (P_numseq IN NUMBER) -- Numéro de séquence
RETURN BOOLEAN;

FUNCTION Select_Organisation (p_coddep  IN VARCHAR2) 	-- Code du département
RETURN NUMBER ;
   
END pack_organisation;
/

CREATE OR REPLACE PACKAGE BODY BIP.pack_organisation AS


-- -------------------------------------------------------------------------
-- FUNCTION Delete_Organisation
-- Role : Supprime, dans la table TMP_ORGANISATION, les données creees par la 
-- fonction Select_Organisation A la fin de l'édition. 
-- -------------------------------------------------------------------------

FUNCTION Delete_Organisation (
			 P_numseq IN NUMBER   
                         ) RETURN BOOLEAN IS
BEGIN
   DELETE FROM TMP_ORGANISATION
   WHERE  numseq = p_numseq;
   COMMIT;
   RETURN TRUE;
EXCEPTION
      WHEN OTHERS THEN RETURN(FALSE); -- NOK
END Delete_Organisation;

-- -------------------------------------------------------------------------
-- FUNCTION Select_Organisation
-- -------------------------------------------------------------------------
FUNCTION Select_Organisation (
			p_coddep  IN VARCHAR2 	-- Code du département
                        ) RETURN NUMBER IS
   
   l_numseq         NUMBER ; 	-- numéro de séquence identifiant l'edition en cours 
   l_annee0  		NUMBER(4); 	-- année courante

BEGIN
	-- Recherche l'année courante
	SELECT TO_NUMBER( TO_CHAR( datdebex, 'YYYY') )
	INTO l_annee0
	FROM datdebex;

	-- Recherche du numéro de séquence de l'édition
	SELECT sdetail.nextval INTO l_numseq FROM dual;   

	-- Renseigne la structure à partir de STRUCT_INFO
	INSERT INTO TMP_ORGANISATION (numseq, codsg, libdsg, gnom, libpole, ident, chef_projet )
	SELECT l_numseq,
		   s.codsg,
		   s.libdsg,
		   s.gnom,
		   d.libdir ||'/'||s.sigdep||'/'||s.sigpole,
		   0,
		   ' ' 
	FROM STRUCT_INFO s , DIRECTIONS d
	WHERE s.coddir = d.coddir 
	AND s.coddep = p_coddep
	AND s.topfer='O';	  

	COMMIT ;
	
	DECLARE
	CURSOR cur_codsg IS
		SELECT codsg, libdsg, gnom, libpole
		FROM TMP_ORGANISATION 
		WHERE numseq = l_numseq 
		AND EXISTS  ( SELECT r.rnom FROM LIGNE_BIP l , RESSOURCE r 
		              WHERE l.codsg = TMP_ORGANISATION.codsg
						AND ( l.adatestatut is null OR TO_NUMBER(TO_CHAR(l.adatestatut,'YYYY'))=l_annee0 )
						AND l.pcpi = r.ident
						AND l.typproj in ('1','2','3','4','6','8')
						AND r.rtype = 'P' ) ;
					
	BEGIN
		-- Boucle sur chaque DPG				
		FOR un_codsg IN cur_codsg LOOP
	
			-- Insère dans la table de travail une ligne par chef de projet des lignes du dpg
			INSERT INTO TMP_ORGANISATION (numseq, codsg, libdsg, gnom, libpole, ident, chef_projet )
			SELECT DISTINCT	l_numseq,
				   un_codsg.codsg,
				   un_codsg.libdsg,
				   un_codsg.gnom,
				   un_codsg.libpole,
				   r.ident,
				   r.rnom || ' ' || NLS_INITCAP(rprenom)
			FROM LIGNE_BIP l , RESSOURCE r
			WHERE l.codsg = un_codsg.codsg
			AND ( l.adatestatut is null OR TO_NUMBER(TO_CHAR(l.adatestatut,'YYYY'))=l_annee0 )
			AND l.pcpi = r.ident 
			AND l.typproj in ('1','2','3','4','6','8')
			AND r.rtype = 'P' ;	  
			
	
		END LOOP;
		COMMIT;
	EXCEPTION 
    	WHEN OTHERS THEN
    	RETURN 0; -- code d'erreur
	END;

	-- Calcul des consommés de chaque chef de projet
    UPDATE TMP_ORGANISATION o
    SET (cusag) = ( SELECT SUM(c.cusag) 
       				FROM CONSOMME c
       				WHERE c.annee=l_annee0
       				AND c.pid in (  SELECT l.pid
       								FROM LIGNE_BIP l
       							 	WHERE l.codsg = o.codsg
									AND ( l.adatestatut is null OR TO_NUMBER(TO_CHAR(l.adatestatut,'YYYY'))=l_annee0 )
									AND l.pcpi = o.ident 
									AND l.typproj in ('1','2','3','4','6','8')
								 )
				   )
	WHERE o.numseq = l_numseq 
	AND   o.ident != 0;

	COMMIT;

	-- Calcul des consommés de chaque groupe
    UPDATE TMP_ORGANISATION o
    SET (cusag) = ( SELECT SUM(c.cusag) 
       				FROM CONSOMME c
       				WHERE c.annee=l_annee0
       				AND c.pid in (  SELECT l.pid
       								FROM LIGNE_BIP l
       							 	WHERE l.codsg = o.codsg
									AND ( l.adatestatut is null OR TO_NUMBER(TO_CHAR(l.adatestatut,'YYYY'))=l_annee0 )
									AND l.typproj in ('1','2','3','4','6','8')
								 )
				   )
	WHERE o.numseq = l_numseq 
	AND   o.ident = 0;

	COMMIT;


	-- Calcul des budgets de chaque chef de projet
    UPDATE TMP_ORGANISATION o
    SET (anmont, reestime) = ( SELECT SUM(b.anmont), SUM(b.reestime)  
       				FROM BUDGET b
       				WHERE b.annee=l_annee0
       				AND b.pid in (  SELECT l.pid
       								FROM LIGNE_BIP l
       							 	WHERE l.codsg = o.codsg
									AND ( l.adatestatut is null OR TO_NUMBER(TO_CHAR(l.adatestatut,'YYYY'))=l_annee0 )
									AND l.pcpi = o.ident 
									AND l.typproj in ('1','2','3','4','6','8')
								 )
				   )
	WHERE o.numseq = l_numseq 
	AND   o.ident != 0;

	COMMIT;

	-- Calcul des budgets de chaque groupe
    UPDATE TMP_ORGANISATION o
    SET (anmont, reestime) = ( SELECT SUM(b.anmont), SUM(b.reestime)  
       				FROM BUDGET b
       				WHERE b.annee=l_annee0
       				AND b.pid in (  SELECT l.pid
       								FROM LIGNE_BIP l
       							 	WHERE l.codsg = o.codsg
									AND ( l.adatestatut is null OR TO_NUMBER(TO_CHAR(l.adatestatut,'YYYY'))=l_annee0 )
									AND l.typproj in ('1','2','3','4','6','8')
								 )
				   )
	WHERE o.numseq = l_numseq 
	AND   o.ident = 0;

	COMMIT;

	-- Calcul des ressources de chaque chef de projet
    UPDATE TMP_ORGANISATION o
    SET (nb_ress, nb_ress_sg, nb_ress_ssii) = 
                  ( SELECT count(s.ident),sum(decode(s.soccode,'SG..',1,0)),sum(decode(s.soccode,'SG..',0,1))                     
       				FROM SITU_RESS s
       				WHERE s.cpident=o.ident
       				AND s.codsg=o.codsg
       				AND s.datsitu <= sysdate
					AND (s.datdep is null OR s.datdep>= sysdate)
       				AND s.ident in (  SELECT r.ident
       								FROM RESSOURCE r
       							 	WHERE trim(r.rtype)='P'
								    )
				  )
	WHERE o.numseq = l_numseq 
	AND   o.ident != 0;
	
	COMMIT;
	
	-- Calcul des ressources de chaque groupe
    UPDATE TMP_ORGANISATION o
    SET (nb_ress, nb_ress_sg, nb_ress_ssii) = 
                  ( SELECT count(s.ident),sum(decode(s.soccode,'SG..',1,0)),sum(decode(s.soccode,'SG..',0,1))                     
       				FROM SITU_RESS s
       				WHERE s.codsg=o.codsg
       				AND s.datsitu <= sysdate
					AND (s.datdep is null OR s.datdep>= sysdate)
       				AND s.ident in (  SELECT r.ident
       								FROM RESSOURCE r
       							 	WHERE trim(r.rtype)='P'
								    )
				  )
	WHERE o.numseq = l_numseq 
	AND   o.ident = 0;

	COMMIT;

	-- Supprime les lignes avec des données vides
	DELETE FROM TMP_ORGANISATION
    WHERE ( cusag is null   	or cusag = 0)
    AND   ( anmont is null  	or anmont = 0)
    AND   ( reestime is null  	or reestime = 0)
    AND   ( nb_ress is null  	or nb_ress = 0)
    AND   ( nb_ress_sg is null  or nb_ress_sg = 0)
    AND   ( nb_ress_ssii is null  or nb_ress_ssii = 0)
    AND   numseq = l_numseq
 	AND   ident != 0;  
	COMMIT;

	
	-- Recalcule les données du groupe en soustrayant les données des chefs de projet
    UPDATE TMP_ORGANISATION o
    SET (o.cusag) = ( SELECT GREATEST(- SUM(o1.cusag) + o.cusag,0)  
       				FROM TMP_ORGANISATION o1
       				WHERE o1.numseq = l_numseq
       				AND  o1.codsg = o.codsg 
       				AND  o1.ident != 0      			
				  )
	WHERE numseq = l_numseq 
	AND   ident = 0;

   UPDATE TMP_ORGANISATION o
    SET (o.anmont) = ( SELECT GREATEST(- SUM(o1.anmont) + o.anmont,0)
       				FROM TMP_ORGANISATION o1
       				WHERE o1.numseq = l_numseq
       				AND  o1.codsg = o.codsg 
       				AND  o1.ident != 0     			
				  )
	WHERE o.numseq = l_numseq 
	AND   o.ident = 0;

   UPDATE TMP_ORGANISATION o
    SET (o.reestime) = ( SELECT GREATEST(- SUM(o1.reestime) + o.reestime,0)
       				FROM TMP_ORGANISATION o1
       				WHERE o1.numseq = l_numseq
       				AND  o1.codsg = o.codsg 
       				AND  o1.ident != 0     			
				  )
	WHERE o.numseq = l_numseq 
	AND   o.ident = 0;
	
   UPDATE TMP_ORGANISATION o
    SET (o.nb_ress) = ( SELECT GREATEST(- SUM(o1.nb_ress) + o.nb_ress,0)
       				FROM TMP_ORGANISATION o1
       				WHERE o1.numseq = l_numseq
       				AND  o1.codsg = o.codsg 
       				AND  o1.ident != 0      			
				  )
	WHERE o.numseq = l_numseq 
	AND   o.ident = 0;
	
   UPDATE TMP_ORGANISATION o
    SET (o.nb_ress_sg) = ( SELECT GREATEST(- SUM(o1.nb_ress_sg) + o.nb_ress_sg,0)
       				FROM TMP_ORGANISATION o1
       				WHERE o1.numseq = l_numseq
       				AND  o1.codsg = o.codsg 
       				AND  o1.ident != 0     			
				  )
	WHERE o.numseq = l_numseq 
	AND   o.ident = 0;
	
   UPDATE TMP_ORGANISATION o
    SET (o.nb_ress_ssii) = ( SELECT GREATEST(- SUM(o1.nb_ress_ssii) + o.nb_ress_ssii,0)
       				FROM TMP_ORGANISATION o1
       				WHERE o1.numseq = l_numseq
       				AND  o1.codsg = o.codsg 
       				AND  o1.ident != 0      			
				  )
	WHERE o.numseq = l_numseq 
	AND   o.ident = 0;

	COMMIT;

	-- Supprime les lignes avec des données vides

	DELETE FROM TMP_ORGANISATION o
    WHERE ( o.cusag is null   		or o.cusag = 0)
    AND   ( o.anmont is null  		or o.anmont = 0)
    AND   ( o.reestime is null  	or o.reestime = 0)
    AND   ( o.nb_ress is null  		or o.nb_ress = 0)
    AND   ( o.nb_ress_sg is null  	or o.nb_ress_sg = 0)
    AND   ( o.nb_ress_ssii is null  or o.nb_ress_ssii = 0)
    AND   o.numseq = l_numseq
    AND   o.ident = 0
    AND NOT EXISTS ( SELECT o1.ident FROM TMP_ORGANISATION o1
                     WHERE o1.numseq = l_numseq
                     AND   o1.codsg  = o.codsg
                     AND   o1.ident  != 0 )
    ;  
	COMMIT;




	RETURN l_numseq;

EXCEPTION 
    WHEN OTHERS THEN
    RETURN 0; -- code d'erreur
END Select_Organisation;


END pack_organisation;
/
