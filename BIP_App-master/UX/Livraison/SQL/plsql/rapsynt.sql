-- Nom        :  prologue
-- Auteur     :  Equipe SOPRA
-- Decription :  Package pour l'edition rapsynt
-- Date       :  17/01/2000
--
-- ***********************************************************************************
-- Quand      Qui  Quoi
-- ---------- ---  ---------------------------------------------------------------------
-- 31/12/1999 MRZ  Création
-- 17/01/2000 VPR  Modif apres qualif-interne
-- 23/02/2000 QHL  Modif après recette client - voir surtout le report rapsynt.rdf
-- 16/03/2000 QHL  Function prologue - l_tva taillé à number(9,3) au lieu de 9(2)
--                 au niveau report : fusion dans un seul SELECT le rapprochement de tmprapsynt avec proplus
--                                  correction de date_de_fin doit etre le dernier jour du mois.
-- 01/02/2001 PHD  Ajout des nouvelles ss-taches DEMENA, RTT, PARTIE
--
-- ***********************************************************************************

-- SET SERVEROUTPUT OFF;


CREATE OR REPLACE PACKAGE pack_rapsynt AS

   -- ------------------------------------------------------------------------
   -- Nom        :  prologue
   -- Auteur     :  Equipe SOPRA
   -- Decription :  remplit la table tmprapsynt pour l'edition rapsynt
   -- Paramètres :  p_datdeb (IN) DATE: date debut de rapprochement
   --               p_datfin (IN) DATE: date fin de rapprochement
   --               p_datfin_fact (IN) DATE: date fin saisie facture
   --
   -- Retour     :  renvoie un numero de sequence pour le reports.
   --
   -- ------------------------------------------------------------------------

   FUNCTION prologue(	p_datdeb IN DATE,
           		p_datfin IN DATE,
           		p_datdeb_fact IN DATE,
           		p_datfin_fact IN DATE) RETURN number;

   -- ------------------------------------------------------------------------
   -- Nom        :  epilogue
   -- Auteur     :  Equipe SOPRA
   -- Decription :  supprime les elements lies a une edition de rapsynt
   -- Paramètres :  p_numseq (IN) NUMBER: numero de sequence
   --
   -- Retour     :  TRUE : suppression OK
   --               FALSE : suppression NOK
   --
   -- ------------------------------------------------------------------------

   FUNCTION epilogue(p_numseq IN NUMBER ) RETURN BOOLEAN;

   -- ------------------------------------------------------------------------
   -- Nom        :  verif_rapsynt
   -- Auteur     :  Equipe SOPRA
   -- Decription :  Test des parametres d'entrees de l'edition rapsynt
   -- Paramètres :  p_numseq (IN) NUMBER: numero de sequence
   --
   -- Retour     :  TRUE : suppression OK
   --               FALSE : suppression NOK
   --
   -- ------------------------------------------------------------------------
   PROCEDURE verif_rapsynt(	p_param6  IN  VARCHAR2,
            			p_param7  IN  VARCHAR2,
            			p_param8  IN  VARCHAR2,
            			p_param9  IN  VARCHAR2,
            			p_message OUT VARCHAR2
                );
 
   -- ------------------------------------------------------------------------
   --  Curseur global : Selection des lignes de factures
   CURSOR l_c_ligne_fact (v_datdeb DATE, v_datfin DATE, v_datdeb_fact DATE, v_datfin_fact DATE) IS
     SELECT  lig.ident,
             to_char(lig.lmoisprest,'YYYYMM') 	mois	  ,
             lig.ldeppole 			codsg	  ,
             lig.lcodcompta 			lcodcompta,
             lig.socfact 			socfact	  ,
             sum(decode(fac.typfact,
                         'A',(-1 * lig.lmontht * ((lig.tva/100) + 1)),
                            (lig.lmontht  * ((lig.tva/100) + 1 ))
                       )
               ) 				mntfact
     FROM   facture 	fac,
            ligne_fact 	lig
     WHERE  lig.lmoisprest BETWEEN v_datdeb AND v_datfin 
        AND lig.socfact <> 'SG..' 
        AND fac.socfact = lig.socfact 
        AND fac.numfact = lig.numfact 
        AND fac.typfact = lig.typfact 
        AND fac.datfact = lig.datfact 
        AND fac.fdatsai <= v_datfin_fact  
        AND fac.fdatsai >= v_datdeb_fact
        AND (lig.lcodcompta IN ('6395001','6396201','6396103','6396102','6396102','6322004','6391501','6391507','6391507',
                           '6391507','6391502','6391503','6391504','6391507','4379','6396206','6092001','4386','6391506')
             OR (lig.lcodcompta = '6396204' AND lig.lcodfinali <> 0)
            )
     GROUP BY  lig.ident,
               to_char(lig.lmoisprest,'YYYYMM'),
               lig.ldeppole,
               lig.lcodcompta,
               lig.socfact
     ORDER BY  codsg, ident, mois;

   -- ------------------------------------------------------------------------
   --  Curseur global : Selection de proplus
   CURSOR l_c_pro_plus(v_datdeb DATE, v_datfin DATE, v_tva NUMBER) IS
     SELECT pro.tires 				ident,
             to_char(pro.cdeb,'YYYYMM') 	mois,
             pro.divsecgrou 			codsg,
             sum(pro.cusag * pro.cout * v_tva ) mntpro,
             sum(pro.cusag) 			cusag
     FROM    proplus pro
     WHERE   pro.cdeb BETWEEN v_datdeb AND v_datfin AND
             pro.societe != 'SG..' AND
             pro.qualif NOT IN ('GRA','MO ') AND
             pro.aist NOT IN ('FORMAT','ABSDIV','CONGES','MOBILI','PARTIE','RTT')
     GROUP BY  pro.tires,
               to_char(pro.cdeb,'YYYYMM'),
               pro.divsecgrou
     ORDER BY  codsg, ident, mois;

-- -----------------------------------------------
-- Curseur pour la MAJ de fact_aa1 dans tmprapsynt
-- -----------------------------------------------
	CURSOR C0 is
		select 
			distinct
			numseq,
			codsg,
			codcompta
		from 
			tmprapsynt
		where
			fact_aa1 is null;
END pack_rapsynt;
/

CREATE OR REPLACE PACKAGE BODY pack_rapsynt AS
  -- ************************************************************************
  -- Nom        :  prologue
  -- Auteur     :  Equipe SOPRA
  -- Decription :  remplit la table tmprapsynt pour l'edition rapsynt
  -- Paramètres :  p_datdeb (IN) DATE: date debut de rapprochement
  --               p_datfin (IN) DATE: date fin de rapprochement
  --               p_datfin_fact (IN) DATE: date fin saisie facture
  --
  -- Retour     :  renvoie un numero de sequence pour le reports.
  --
  -- ************************************************************************
FUNCTION prologue ( p_datdeb      IN DATE,
                    p_datfin      IN DATE,
                    p_datdeb_fact IN DATE,
                    p_datfin_fact IN DATE) RETURN number IS
   -- Booleens de test
   l_pro_plus_fetch_ok  BOOLEAN := true;
   l_lig_fact_fetch_ok  BOOLEAN := true;
   l_pro_plus_finished  BOOLEAN := false;
   l_lig_fact_finished  BOOLEAN := false;

   -- lignes de curseur
   l_lig_fact     l_c_ligne_fact%ROWTYPE;
   l_lig_pro_plus l_c_pro_plus%ROWTYPE;

   -- ligne de la table temporaire
   l_lig_tot      tmprapsynt%ROWTYPE;
   tmp_l_lig_tot  tmprapsynt.fact_aa1%type;
   ligne0 C0%rowtype;

   -- Valeurs de cles
   l_codcompta     varchar2(11);
   l_codcompta_old varchar2(11);
   l_codsg         NUMBER := 0;
   l_codsg_old     NUMBER := 0;

   -- Identifiants servant à calculer la jointure des deux curseurs
   l_id_proplus    NUMBER;
   l_id_lignefact  NUMBER;

   -- autre
   l_numseq        NUMBER;           -- Sequence dans la table temporaire
   first           BOOLEAN := true;  -- Boolean pour la 1er iteration du loop
   l_tva           NUMBER(9,3);      -- taux tva + 1  Modif QHL 16/3/2000
BEGIN
   -- Initialisations
   SELECT srapsynt.nextval INTO l_numseq FROM dual;
   l_tva := ((pack_utile.f_get_tva(sysdate) / 100) + 1);
   open l_c_pro_plus (p_datdeb, p_datfin, l_tva);
   open l_c_ligne_fact (p_datdeb, p_datfin,p_datdeb_fact, p_datfin_fact);
   l_lig_tot.codsg        := 0; l_lig_tot.codcompta    := '0'; l_lig_tot.numseq       := l_numseq;
   l_lig_tot.jh_fac_eq0   := 0; l_lig_tot.mc_fac_eq0   := 0; l_lig_tot.jh_fac_eqcon := 0;
   l_lig_tot.mf_fac_eqcon := 0; l_lig_tot.mc_fac_eqcon := 0; l_lig_tot.jh_fac_necon := 0;
   l_lig_tot.mf_fac_necon := 0; l_lig_tot.mc_fac_necon := 0; l_lig_tot.mf_con_eq0   := 0;
   l_lig_tot.fact_aa1     := 0; tmp_l_lig_tot := 0;
   -- ===================================
   -- Parcours des curseurs
   -- ===================================
   LOOP
      -- ===============================================================
      -- Fetch conditionnels des curseurs, calculs des cles de jointures
      -- ===============================================================
      IF (l_pro_plus_fetch_ok = true) THEN
          fetch l_c_pro_plus INTO l_lig_pro_plus;
          l_id_proplus := rtrim(ltrim(nvl(to_char(l_lig_pro_plus.codsg,'FM0000000'),'0000000'))) ||
                          rtrim(ltrim(nvl(to_char(l_lig_pro_plus.ident,'FM00000'),'00000')))   ||
                          l_lig_pro_plus.mois;
      END IF;
      IF (l_lig_fact_fetch_ok = true) THEN
          fetch l_c_ligne_fact INTO l_lig_fact;
          l_id_lignefact := rtrim(ltrim(nvl(to_char(l_lig_fact.codsg,'FM0000000'),'0000000'))) ||
                            rtrim(ltrim(nvl(to_char(l_lig_fact.ident,'FM00000'),'00000')))   ||
                            l_lig_fact.mois;
      END IF;
      -- ===============================================================
      -- Positionnement des flags de sortie des curseurs sortie de la boucle quand les deux curseurs sont finis
      -- ===============================================================
      IF l_c_pro_plus%NOTFOUND THEN
          l_pro_plus_finished   := true;
          l_id_proplus   := '999999999999999999';    -- Cette cle sera toujours la plus grande
      END IF;
      IF l_c_ligne_fact%NOTFOUND THEN
          l_lig_fact_finished   := true;
          l_id_lignefact := '999999999999999999';    -- Cette cle sera toujours la plus grande
      END IF;
      IF (l_lig_fact_finished = true ) AND (l_pro_plus_finished = true) THEN
          EXIT;
      END IF;
      -- Maj du code comptable et codsg
      IF (l_id_proplus = l_id_lignefact) THEN
            -- Dans ce cas, on prend le code comptable/sg de facture ...
            l_codcompta := l_lig_fact.lcodcompta;
            l_codsg     := l_lig_fact.codsg;
         ELSIF (l_id_proplus < l_id_lignefact) THEN
            -- on prend 0 comme code comptable, et le code SG dans proplus
            l_codcompta := '0';
            l_codsg     := l_lig_pro_plus.codsg;
         ELSE  -- Cas restant, l_id_proplus > l_id_lignefact
            -- On prend le code comptable de ligne_fact
            l_codcompta := l_lig_fact.lcodcompta;
            l_codsg     := l_lig_fact.codsg;
      END IF;
      -- ================================
      -- Cas de la 1er boucle
      -- ================================
      IF (first = true) THEN
          l_codcompta_old := l_codcompta;
          l_codsg_old     := l_codsg;
          first := false;
      END IF;
      -- -----------------------------------------------------------------------------
      -- Ecriture de la ligne dans la table temporaire si on change de code comptable
      -- -----------------------------------------------------------------------------
      IF (l_codcompta != l_codcompta_old ) OR (l_codsg != l_codsg_old)
         THEN
          l_lig_tot.codsg     := l_codsg_old;
          l_lig_tot.codcompta := l_codcompta_old;
          l_codcompta_old     := l_codcompta;
          l_codsg_old         := l_codsg;
          INSERT INTO  tmprapsynt
            VALUES (l_lig_tot.numseq      , l_lig_tot.codsg       , l_lig_tot.codcompta   ,
                    l_lig_tot.jh_fac_eq0  , l_lig_tot.mc_fac_eq0  , l_lig_tot.jh_fac_eqcon,
                    l_lig_tot.mf_fac_eqcon, l_lig_tot.mc_fac_eqcon, l_lig_tot.jh_fac_necon,
                    l_lig_tot.mf_fac_necon, l_lig_tot.mc_fac_necon, l_lig_tot.mf_con_eq0  ,
                    l_lig_tot.fact_aa1
                   );
          -- Mise à 0 des compteurs, pour nouvelle affectation;
          l_lig_tot.codsg        := 0;
          l_lig_tot.codcompta    := '0'; l_lig_tot.jh_fac_eq0   := 0; l_lig_tot.mc_fac_eq0   := 0;
          l_lig_tot.jh_fac_eqcon := 0; l_lig_tot.mf_fac_eqcon := 0; l_lig_tot.mc_fac_eqcon := 0;
          l_lig_tot.jh_fac_necon := 0; l_lig_tot.mf_fac_necon := 0; l_lig_tot.mc_fac_necon := 0;
          l_lig_tot.mf_con_eq0   := 0; l_lig_tot.fact_aa1     := 0; tmp_l_lig_tot := 0;
      END IF ;
      -- ---------------------------------------
      -- 'Jointure' entre les deux curseurs
      -- ---------------------------------------
      IF (l_id_proplus = l_id_lignefact)
         THEN
             l_pro_plus_fetch_ok := true;
             l_lig_fact_fetch_ok := true;
             -- Et on effecture les sommes (uniquement les différence et les égalités, les absences ne sont pas
             -- puisqu'on a la jointure entre les deux curseurs
             IF ((l_lig_fact.mntfact != 0 ) AND  (l_lig_pro_plus.mntpro != 0))
               THEN
                  IF (l_lig_fact.mntfact = l_lig_pro_plus.mntpro) OR (l_lig_fact.mntfact - l_lig_pro_plus.mntpro < 0.01)
                     THEN
                      l_lig_tot.jh_fac_eqcon :=  l_lig_tot.jh_fac_eqcon + l_lig_pro_plus.cusag;
                      l_lig_tot.mf_fac_eqcon :=  l_lig_tot.mf_fac_eqcon + l_lig_fact.mntfact;
                      l_lig_tot.mc_fac_eqcon :=  l_lig_tot.mc_fac_eqcon + l_lig_pro_plus.mntpro;
                     ELSE  -- Cas de la difference  :>   l_lig_fact.mntfact - l_lig_pro_plus.mntpro >= 0.01
                      l_lig_tot.jh_fac_necon :=  l_lig_tot.jh_fac_necon + l_lig_pro_plus.cusag;
                      l_lig_tot.mf_fac_necon :=  l_lig_tot.mf_fac_necon + l_lig_fact.mntfact;
                      l_lig_tot.mc_fac_necon :=  l_lig_tot.mc_fac_necon + l_lig_pro_plus.mntpro;
                  END IF;
             END IF;
	     l_lig_tot.fact_aa1 := null; -- La MAJ de cette donnée est faite à la fin du traitement avec le curseur C0
         ELSIF (l_id_proplus < l_id_lignefact) THEN
             -- on avance sur proplus, pas sur ligne fact, c'est la ligne de proplus que l'on va traiter
             l_pro_plus_fetch_ok := true;
             l_lig_fact_fetch_ok := false;
             -- on ne fait que les calculs correspondant à la partie proplus
             l_lig_tot.jh_fac_eq0 := l_lig_tot.jh_fac_eq0 + l_lig_pro_plus.cusag;  -- ajout du cusag
             l_lig_tot.mc_fac_eq0 := l_lig_tot.mc_fac_eq0 + l_lig_pro_plus.mntpro;
         ELSE  -- Cas restant, l_id_proplus > l_id_lignefact
             -- on avance sur lignefact, pas sur proplus, c'est la ligne de ligne_fact que l'on va traiter
             l_pro_plus_fetch_ok := false;
             l_lig_fact_fetch_ok := true;
             -- On ne fait que les calculs correspondant à la partie de ligne_fact
             l_lig_tot.mf_con_eq0 := l_lig_tot.mf_con_eq0 + l_lig_fact.mntfact ; -- Ajout de la facture
             -- Cas particulier du montant FACT_AA1
		l_lig_tot.fact_aa1 := null;
         END IF ;
   END LOOP;
   CLOSE l_c_pro_plus;
   CLOSE l_c_ligne_fact;

	OPEN C0;
	LOOP
	fetch C0 into ligne0;
	exit when C0%notfound;
	-- Recherche du fact_aa1 = consomme des années antérieures
	BEGIN
	SELECT  
			nvl(
				sum(decode(
						fac.typfact,
                  	     		'A',(-1 * lig.lmontht * ((lig.tva/100) + 1)),
                            		(lig.lmontht  * ((lig.tva/100) + 1 ))
                 		))
			,0)
			INTO
				tmp_l_lig_tot
     			FROM   
				facture fac,
	            		ligne_fact lig
	     		WHERE  
			  	lig.lmoisprest <= to_date('12' || to_char(add_months(p_datdeb,-12),'yyyy'),'MMYYYY')
				AND lig.socfact <> 'SG..' 
		        	AND fac.socfact = lig.socfact 
		        	AND fac.numfact = lig.numfact 
		        	AND fac.typfact = lig.typfact 
		        	AND fac.datfact = lig.datfact 
		        	AND fac.fdatsai <= p_datfin_fact 
				AND fac.fdatsai >= to_date('0101' || to_char(p_datdeb_fact,'yyyy'),'DDMMYYYY') 
		        	AND (lig.lcodcompta IN ('6395001', '6396201', '6396103', '6396102', '6396102', '6322004',
 								'6391501', '6391507', '6391507', '6391507', '6391502', '6391503',
 								'6391504', '6391507', '4379', '6396206', '6092001', '4386', '6391506')
		             	OR (lig.lcodcompta = '6396204' AND lig.lcodfinali <> 0)
		            	)
				AND substr(TO_CHAR(lig.ldeppole, 'FM0000000'),1,5) = substr(TO_CHAR(ligne0.codsg, 'FM0000000'),1,5)
				AND lig.lcodcompta = ligne0.codcompta;
	Exception
		when no_data_found then tmp_l_lig_tot := 0;
	END;

	-- MAJ de tmprapsynt pour fact_aa1
	update tmprapsynt t
	set fact_aa1 = tmp_l_lig_tot
	where numseq = l_numseq
		and substr(TO_CHAR(t.codsg, 'FM0000000'),1,5) = substr(TO_CHAR(ligne0.codsg, 'FM0000000'),1,5)
		and t.codcompta = ligne0.codcompta; 

END LOOP;
CLOSE C0;

RETURN  l_numseq;
EXCEPTION
   WHEN OTHERS THEN
     RETURN 0; -- code d'erreur
END prologue;

-- ************************************************************************
-- Nom        :  epilogue
-- Auteur     :  Equipe SOPRA
-- Decription :  supprime les elements lies a une edition de rapsynt
-- Paramètres :  p_numseq (IN) NUMBER: numero de sequence
--
-- Retour     :  TRUE : suppression OK
--               FALSE : suppression NOK
--
-- ************************************************************************
   FUNCTION epilogue (p_numseq IN NUMBER ) RETURN BOOLEAN IS
   BEGIN
      DELETE FROM tmprapsynt WHERE numseq = p_numseq;
      RETURN true;
   EXCEPTION
         WHEN OTHERS THEN
           IF l_c_pro_plus%ISOPEN = true THEN
              close l_c_pro_plus;
           END IF;
           IF l_c_ligne_fact%ISOPEN = true THEN
         close l_c_ligne_fact;
           END IF;
           RETURN false;
   END epilogue;

-- ************************************************************************
-- Nom        :  verif_rapsynt
-- Auteur     :  Equipe SOPRA
-- Decription :  Test des parametres d'entrees de l'edition rapsynt
-- Paramètres :  p_numseq (IN) NUMBER: numero de sequence
--
-- Retour     :  TRUE : suppression OK
--               FALSE : suppression NOK
--
-- exec pack_rapsynt.verif_rapsynt('01/1999', '02/1999', '01/01/1999', '26/10/1999', :msg);
-- ************************************************************************
   PROCEDURE verif_rapsynt(p_param6  IN  VARCHAR2,
            p_param7  IN  VARCHAR2,
            p_param8  IN  VARCHAR2,
            p_param9  IN  VARCHAR2,
            p_message OUT VARCHAR2
                ) IS
      l_msg VARCHAR2(1024);
   BEGIN
      IF to_date('01/'||p_param6, 'dd/mm/yyyy') > to_date('01/'||p_param7, 'dd/mm/yyyy') THEN
         pack_global.recuperer_message(20284, NULL, NULL, 'P_param6', l_msg);
         raise_application_error(-20284, l_msg);
      END IF;
      IF to_date(p_param8, 'dd/mm/yyyy') > to_date(p_param9, 'dd/mm/yyyy') THEN
         pack_global.recuperer_message(20284, NULL, NULL, 'P_param8', l_msg);
         raise_application_error(-20284, l_msg);
      END IF;
   END verif_rapsynt;
END  pack_rapsynt;
/
