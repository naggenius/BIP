-- pack_rep_facture PL/SQL
--
-- equipe SOPRA
--
-- crée le 29/10/1999
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
-- ------------------------------------------------------------------------
--                           MODIFICATION
--  AJOUT 09/12/1999 : select_facrap
-- ------------------------------------------------------------------------
--  Ano 071 : passage de p_filiale en char au lieu de varchar2 dans 
--            f_prologue_fe60 (causait un mauvais filtre sur la filiale)
-- ------------------------------------------------------------------------
--  Ano 088 : Correction du test de validité dans  verif_fe63
-- ------------------------------------------------------------------------
-- 26/12/2000    NBM      gestion des habilitation suivant le centre de frais
--			  - vérifier que le code PDG entré appartient au centre de frais
-- 23/05/2005    PPR      enlève la double définition de la fonction f_prologue_fe60
--- modifié le 06/11/2009 YSB modification de la procédure verif_lstfact : Ajout de la procédure select_Numexpense
-- 12/04/2011   BSA 1165  : suppression verif_fe61, verif_fe62

CREATE OR REPLACE PACKAGE     pack_rep_facture AS

  -- ------------------------------------------------------------------------
  -- Nom        : verif_facrap
  -- Auteur     : Equipe SOPRA
  -- Decription : Verification des parametres du report facrap
  -- Paramètres : p_param6  (IN) date de filtre
  --              p_userid  (IN)  user
  --              p_message (OUT) message d'erreur si erreur
  --
  -- ------------------------------------------------------------------------
  --                           MODIFICATION
  -- ------------------------------------------------------------------------
PROCEDURE verif_facrap (p_param6  IN VARCHAR2,
			p_userid  IN VARCHAR2,
			p_message OUT VARCHAR2
		       );


-- ------------------------------------------------------------------------
-- Nom        : verif_fe63
-- Auteur     : Equipe SOPRA
-- Decription : Verification des parametres du report fe63
-- Paramètres : p_datdebut      (IN)  date de debut
--              p_datfin        (IN)  date de fin
--              p_userid        (IN)  user
--              p_message       (OUT) message d'erreur si erreur
--
-- ------------------------------------------------------------------------
--                           MODIFICATION
-- ------------------------------------------------------------------------
PROCEDURE verif_fe63 ( p_datdebut IN VARCHAR2,
		       p_datfin  IN  VARCHAR2,
		       p_userid  IN  VARCHAR2,
		       p_message OUT VARCHAR2
		     );

-- ------------------------------------------------------------------------
-- Nom        : verif_fe63
-- Auteur     : Equipe SOPRA
-- Decription : Verification des parametres du report fe63
-- Paramètres : p_soccode       (IN)  code societe CHAR(4)
--              p_fregcompta1   (IN)  date
--              p_fregcompta2   (IN)  date
--              p_userid        (IN)  user
--              p_message       (OUT) message d'erreur si erreur
--
-- ------------------------------------------------------------------------
--                           MODIFICATION
-- ------------------------------------------------------------------------
PROCEDURE verif_factab6( p_soccode     IN  societe.soccode%TYPE,
			 p_fregcompta1 IN  VARCHAR2,
			 p_fregcompta2 IN  VARCHAR2,
			 p_userid      IN  VARCHAR2,
			 P_message     OUT VARCHAR2
		       );


-- ------------------------------------------------------------------------
-- Nom        : verif_fe63
-- Auteur     : Equipe SOPRA
-- Decription : Verification des parametres du report fe63
-- Paramètres : p_soccode       (IN)  code societe CHAR(4)
--              p_fregcompta1   (IN)  date
--              p_fregcompta2   (IN)  date
--              p_lmoisprest1   (IN)  date
--              p_lmoisprest2   (IN)  date
--              p_fdeppole      (IN)  number(6)
--              p_socnat        (IN)  sans utilite
--              p_comcode       (IN)  varchar2
--              p_fmontht       (IN)  sans utilite
--              p_userid        (IN)  user
--              p_message       (OUT) message d'erreur si erreur
--
-- ------------------------------------------------------------------------
--                           MODIFICATION
-- ------------------------------------------------------------------------
PROCEDURE verif_lstfact(
			p_soccode     IN  societe.soccode%TYPE,
			p_fenrcompta1 IN  VARCHAR2,
			p_fenrcompta2 IN  VARCHAR2,
			p_lmoisprest1 IN  VARCHAR2,
			p_lmoisprest2 IN  VARCHAR2,
			p_fdeppole    IN  VARCHAR2,
			p_socnat      IN  VARCHAR2,
			p_comcode     IN  VARCHAR2,
			p_fmontht     IN  VARCHAR2,
            p_numexpense  IN  VARCHAR2,
			p_userid      IN  VARCHAR2,
			P_message     OUT VARCHAR2
		       );

-- ------------------------------------------------------------------------
-- Nom        : verif_fe63
-- Auteur     : Equipe SOPRA
-- Decription :
-- Paramètres : p_comcode   (IN)
--              p_focus     (IN)
--              p_msg       (IN)
--
-- ------------------------------------------------------------------------
--                           MODIFICATION
-- ------------------------------------------------------------------------
PROCEDURE select_CodeComptable(p_comcode IN VARCHAR2,
			       p_focus IN  VARCHAR2,
			       p_msg OUT VARCHAR2
			      );

-- ------------------------------------------------------------------------
-- Nom        : f_prologue_fe60
-- Auteur     : Equipe SOPRA
-- Decription : prologue de fe60
-- Paramètres : p_filiale   (IN) code filiale
-- Retour     : le numéro de sequence d'insersion dans tmpfe60
--
-- ------------------------------------------------------------------------
--                           MODIFICATION
-- ------------------------------------------------------------------------
FUNCTION f_prologue_fe60(p_filiale IN CHAR, p_codcfrais IN CHAR) RETURN NUMBER;
FUNCTION f_prologue_tous_fe60(p_filiale IN CHAR) RETURN NUMBER;

-- ------------------------------------------------------------------------
-- Nom        : f_epilogue_fe60
-- Auteur     : Equipe SOPRA
-- Decription : epilogue de fe60
-- Paramètres : p_numseq    (IN) numero de sequence a supprimer dans tmpfe60
--
-- ------------------------------------------------------------------------
--                           MODIFICATION
-- ------------------------------------------------------------------------
FUNCTION f_epilogue_fe60(p_numseq NUMBER) RETURN BOOLEAN;



-- ------------------------------------------------------------------------
-- Nom        : f_entetecol_fe65
-- Auteur     : Equipe SOPRA
-- Decription : retourne le libelle des colonnes en fonction de numéro de
--              la colonne (1 à 5) dans l'edition fe65
-- Paramètres : p_numseq    (IN) numero de sequence a supprimer dans tmpfe60
--
-- ------------------------------------------------------------------------
--                           MODIFICATION
-- ------------------------------------------------------------------------
function f_entetecol_fe65(
			  p_num NUMBER
			 ) RETURN VARCHAR2;



-- ------------------------------------------------------------------------
-- Nom        : verif_fe65
-- Auteur     : Equipe SOPRA
-- Decription : Procedure qui controle les parametre d'entrées
-- Paramètres : p_datdeb        (IN) date
--              p_datfin        (IN) date
--              p_userid        (IN)  user
--              p_message       (OUT) message d'erreur si erreur
--
-- ------------------------------------------------------------------------
--                           MODIFICATION
-- ------------------------------------------------------------------------
PROCEDURE verif_fe65(
		     p_datdeb  IN VARCHAR2,         -- date
		     p_datfin  IN VARCHAR2,         -- date
		     p_userid  IN VARCHAR2,
		     P_message OUT VARCHAR2
		    );


PROCEDURE verif_facqua6  (p_param6  IN VARCHAR2,
			  p_param7  IN Varchar2,
			  p_userid  IN VARCHAR2,
			  p_message OUT VARCHAR2
			 );


-- Curseur de récupération des factures , classé par pôle.
cursor  c_fact (v_filcode CHAR,v_centrefrais NUMBER) IS
  SELECT
      'PAS DE CONTRAT',
      sti.coddep,
      sti.coddeppole,
      fac.fdatsai
  FROM
      facture fac,
      struct_info sti
  WHERE
      fac.fdeppole = sti.codsg
      AND ( fac.fregcompta IS NULL OR
             fac.faccsec IS NULL
          --OR fac.fenrcompta IS NULL
	    )
     AND fac.numcont IS NULL
     AND fac.fcentrefrais=v_centrefrais
UNION ALL
  SELECT
      'CONTRAT',
      sti.coddep,
      sti.coddeppole,
      fac.fdatsai
  FROM
      facture fac,
      struct_info sti,
      contrat cnt
  WHERE
      fac.fdeppole = sti.codsg
      AND fac.socfact = cnt.soccont
      AND fac.numcont = cnt.numcont
      AND fac.cav = cnt.cav
      AND( fac.fregcompta IS NULL OR
      	 fac.faccsec IS NULL
         --OR fac.fenrcompta IS NULL
	   )
      AND fac.numcont IS NOT NULL
      AND cnt.filcode = v_filcode
      AND fac.fcentrefrais=v_centrefrais
 ORDER BY 3;

-- Curseur de récupération des factures , classé par pôle.
cursor  c_all (v_filcode CHAR) IS
  SELECT
      'PAS DE CONTRAT',
      sti.coddep,
      sti.coddeppole,
      fac.fdatsai
  FROM
      facture fac,
      struct_info sti
  WHERE
      fac.fdeppole = sti.codsg
      AND (--fac.fenrcompta IS NULL OR
       fac.faccsec IS NULL
          OR fac.fregcompta IS NULL
	    )
     AND fac.numcont IS NULL
UNION ALL
  SELECT
      'CONTRAT',
      sti.coddep,
      sti.coddeppole,
      fac.fdatsai
  FROM
      facture fac,
      struct_info sti,
      contrat cnt
  WHERE
      fac.fdeppole = sti.codsg
      AND fac.socfact = cnt.soccont
      AND fac.numcont = cnt.numcont
      AND fac.cav = cnt.cav
      AND(--fac.fenrcompta IS NULL OR
       fac.faccsec IS NULL
         OR fac.fregcompta IS NULL
	   )
      AND fac.numcont IS NOT NULL
      AND cnt.filcode = v_filcode
 ORDER BY 3;


    PRAGMA RESTRICT_REFERENCES(f_entetecol_fe65,WNDS,WNPS);
END pack_rep_facture ;
/


CREATE OR REPLACE PACKAGE BODY     pack_rep_facture AS

  -- ------------------------------------------------------------------------
  -- Nom        : verif_facrap
  -- Auteur     : Equipe SOPRA
  -- Decription : Verification des parametres du report facrap
  -- Paramètres : p_param6  (IN) date de filtre
  --              p_userid  (IN)  user
  --              p_message (OUT) message d'erreur si erreur
  --
  -- ------------------------------------------------------------------------
  --                           MODIFICATION
  -- ------------------------------------------------------------------------
PROCEDURE verif_facrap (    p_param6  IN VARCHAR2,
			    p_userid  IN VARCHAR2,
			    p_message OUT VARCHAR2
			   ) IS

   l_msg      VARCHAR2(1024);
   l_datdebex VARCHAR2(20);

BEGIN

   BEGIN

      SELECT to_char(datdebex, 'YYYY')
	INTO l_datdebex
	FROM datdebex;

   EXCEPTION
      WHEN OTHERS THEN
	NULL;
   END;

   -- Si l'annee de la date saisie est <= a l'annee de datdebex on
   -- ne retourne aucun resultat donc erreur.
   IF substr(p_param6,7,4) < l_datdebex THEN
      pack_global.recuperer_message(20200, NULL, NULL, NULL, l_msg);
      raise_application_error(-20200, l_msg);
   END IF;

END verif_facrap;



  -- ------------------------------------------------------------------------
  -- Nom        : f_prologue_fe60

  -- Auteur     : Equipe SOPRA
  -- Decription : Préparation du report fe60, insère dans la table tmpfe60
  -- Paramètres : p_filiale    IN             numéro de filiale
  -- Retour     : Si le prologue ne se passe pas bien, renvoie 0, sinon
  --              renvoie le numéro de séquence sur lequel il faut filtrer
  --              sur tmpfe60
  --
  -- ------------------------------------------------------------------------
  --                           MODIFICATION
  --
  -- ------------------------------------------------------------------------
FUNCTION f_prologue_fe60(p_filiale IN CHAR, p_codcfrais IN CHAR) RETURN NUMBER IS

   -- Variables pour le count
   l_count_pascont  NUMBER := 0;
   l_count00_30     NUMBER := 0;
   l_count31_60     NUMBER := 0;
   l_count61_90     NUMBER := 0;
   l_count91_120    NUMBER := 0;
   l_count120       NUMBER := 0;

   -- Variables de réception du curseur
   l_iscontrat      VARCHAR2(30);
   l_coddep         struct_info.coddep%type ;
   l_coddeppole     struct_info.coddeppole%type;
   l_fdatsai        DATE ;
   l_sysdate        DATE ;
   l_oldcoddeppole  struct_info.coddeppole%type;
   l_oldcoddep      struct_info.coddep%type;
   l_numseq         NUMBER ; -- numéro de séquence identifiant l'extraction en cours
   l_Nbjours        NUMBER(5);

   x_errparms       EXCEPTION;

BEGIN
   -- initialisations
   l_sysdate := trunc(sysdate) ;
   l_oldcoddeppole := -1;   --  On ne prend pas 0 car il y a un dep à 0 et un pole à 0 !!!
   l_oldcoddep    := -1;
   SELECT sfe60.nextval INTO l_numseq FROM dual;

   IF c_fact%ISOPEN THEN
      close c_fact;
   END IF;

    open c_fact(p_filiale, to_number(p_codcfrais));

    LOOP
   	fetch c_fact INTO l_iscontrat, l_coddep, l_coddeppole, l_fdatsai ;
        -- dbms_output.put_line (l_coddep);
      	IF c_fact%notfound THEN
	   	EXIT;
      	END IF;
         -- Sauvegarde de la ligne dans la table temporaire
      IF (l_oldcoddeppole = -1) THEN
	   -- Cas de lancement de la boucle, on initialise oldcoddeppole et on ne fait rien
	   l_oldcoddeppole := l_coddeppole;
	   l_oldcoddep     := l_coddep;
      ELSIF (l_oldcoddeppole != l_coddeppole) THEN
	   -- On a changé de pole, on insere une ligne  ...
	   INSERT INTO tmpfe60
	     (numseq, coddep, coddeppole, count_pascont,
	     count00_30, count31_60, count61_90, count91_120, count120
	     )
	   VALUES (
	     l_numseq, l_oldcoddep, l_oldcoddeppole, l_count_pascont,
	      l_count00_30, l_count31_60, l_count61_90, l_count91_120, l_count120);

	   -- ... Et on remet à 0 les compteurs
	   l_count_pascont := 0;
	   l_count00_30    := 0;
	   l_count31_60    := 0;
	   l_count61_90    := 0;
	   l_count91_120    := 0;
	   l_count120       := 0;

	   -- Et on positionne oldcoddeppole à la nouvelle valeur !
	   l_oldcoddeppole := l_coddeppole;
	   l_oldcoddep     := l_coddep;
      END IF;

      -- Affectation en fonction de la présence d'un contrat
      IF (l_iscontrat = 'PAS DE CONTRAT') THEN
	  l_count_pascont := l_count_pascont + 1;
	  -- dbms_output.putline('PAS CONT');
      ELSIF (l_iscontrat = 'CONTRAT') THEN -- Un autre cas serait étonnant...

 	  -- Affectation en fonction de la date de saisie
        l_Nbjours:= l_sysdate - trunc(l_fdatsai);

	  IF ( (l_Nbjours >= 0) AND (l_Nbjours <= 30)) THEN
	    l_count00_30 := l_count00_30 + 1;
	  ELSIF ( (l_Nbjours >= 31 ) AND (l_Nbjours <= 60)) THEN
	    l_count31_60 := l_count31_60 + 1;
	  ELSIF ( (l_Nbjours >= 61 ) AND (l_Nbjours <= 90)) THEN
	    l_count61_90 := l_count61_90 + 1;
	  ELSIF ( (l_Nbjours >= 91 ) AND (l_Nbjours <= 120)) THEN
	    l_count91_120 := l_count91_120 + 1;
	  ELSIF (l_Nbjours >= 121 ) THEN
	    l_count120 := l_count120 + 1;
	  ELSE
	    NULL;
	  END IF;
      ELSE
	   -- Un autre cas des plus improbables
	   NULL;
      END IF;
    END LOOP;

   -- Si on a au moins traité une ligne
   IF (l_oldcoddeppole != -1) THEN
      -- On a changé de pole, on insere une ligne  ...
      INSERT INTO tmpfe60
	(numseq, coddep, coddeppole, count_pascont,
	count00_30, count31_60, count61_90, count91_120, count120
	)
	VALUES (
	l_numseq, l_oldcoddep, l_oldcoddeppole, l_count_pascont,
	l_count00_30, l_count31_60, l_count61_90, l_count91_120, l_count120);
   END IF;

   -- Fermeture du curseur et retour...
   close c_fact;

   commit;

   RETURN l_numseq;

EXCEPTION
   WHEN OTHERS THEN
     -- dbms_output.putline ('Une erreur !!!');
     rollback;
     RETURN 0;
END;
-- ====================================================================================
-- ***********************************************************************************
-- ====================================================================================
FUNCTION f_prologue_tous_fe60(p_filiale IN CHAR) RETURN NUMBER IS

   -- Variables pour le count
   l_count_pascont  NUMBER := 0;
   l_count00_30     NUMBER := 0;
   l_count31_60     NUMBER := 0;
   l_count61_90     NUMBER := 0;
   l_count91_120     NUMBER := 0;
   l_count120        NUMBER := 0;

   -- Variables de réception du curseur
   l_iscontrat      VARCHAR2(30);
   l_coddep         struct_info.coddep%type ;
   l_coddeppole     struct_info.coddeppole%type;
   l_fdatsai        DATE ;
   l_sysdate        DATE ;
   l_oldcoddeppole  struct_info.coddeppole%type;
   l_oldcoddep      struct_info.coddep%type;
   l_numseq         NUMBER ; -- numéro de séquence identifiant l'extraction en cours
   l_Nbjours        NUMBER(5);

   x_errparms       EXCEPTION;

BEGIN
   -- initialisations
   l_sysdate := trunc(sysdate) ;
   l_oldcoddeppole := -1;   --  On ne prend pas 0 car il y a un dep à 0 et un pole à 0 !!!
   l_oldcoddep    := -1;
   SELECT sfe60.nextval INTO l_numseq FROM dual;

   IF c_all%ISOPEN THEN
      close c_all;
   END IF;

    open c_all(p_filiale);

    LOOP
   	fetch c_all INTO l_iscontrat, l_coddep, l_coddeppole, l_fdatsai ;

      	IF c_all%notfound THEN
	   	EXIT;
      	END IF;
         -- Sauvegarde de la ligne dans la table temporaire
      IF (l_oldcoddeppole = -1) THEN
	   -- Cas de lancement de la boucle, on initialise oldcoddeppole et on ne fait rien
	   l_oldcoddeppole := l_coddeppole;
	   l_oldcoddep     := l_coddep;
      ELSIF (l_oldcoddeppole != l_coddeppole) THEN
	   -- On a changé de pole, on insere une ligne  ...
	   INSERT INTO tmpfe60
	     (numseq, coddep, coddeppole, count_pascont,
	     count00_30, count31_60, count61_90, count91_120, count120
	     )
	   VALUES (
	     l_numseq, l_oldcoddep, l_oldcoddeppole, l_count_pascont,
	    l_count00_30, l_count31_60, l_count61_90, l_count91_120, l_count120);

	   -- ... Et on remet à 0 les compteurs
	   l_count_pascont := 0;
	   l_count00_30    := 0;
	   l_count31_60    := 0;
	   l_count61_90    := 0;
	   l_count91_120    := 0;
	   l_count120       := 0;

	   -- Et on positionne oldcoddeppole à la nouvelle valeur !
	   l_oldcoddeppole := l_coddeppole;
	   l_oldcoddep     := l_coddep;
      END IF;

      -- Affectation en fonction de la présence d'un contrat
      IF (l_iscontrat = 'PAS DE CONTRAT') THEN
	  l_count_pascont := l_count_pascont + 1;
	  -- dbms_output.putline('PAS CONT');
      ELSIF (l_iscontrat = 'CONTRAT') THEN -- Un autre cas serait étonnant...

 	  -- Affectation en fonction de la date de saisie
        l_Nbjours:= l_sysdate - trunc(l_fdatsai);

	  IF ( (l_Nbjours >= 0) AND (l_Nbjours <= 30)) THEN
	    l_count00_30 := l_count00_30 + 1;
	  ELSIF ( (l_Nbjours >= 31 ) AND (l_Nbjours <= 60)) THEN
	    l_count31_60 := l_count31_60 + 1;
	  ELSIF ( (l_Nbjours >= 61 ) AND (l_Nbjours <= 90)) THEN
	    l_count61_90 := l_count61_90 + 1;
	  ELSIF ( (l_Nbjours >= 91 ) AND (l_Nbjours <= 120)) THEN
	    l_count91_120 := l_count91_120 + 1;
	  ELSIF (l_Nbjours >= 121 ) THEN
	    l_count120 := l_count120 + 1;
	  ELSE
	    NULL;
	  END IF;
      ELSE
	   -- Un autre cas des plus improbables
	   NULL;
      END IF;
    END LOOP;

   -- Si on a au moins traité une ligne
   IF (l_oldcoddeppole != -1) THEN
      -- On a changé de pole, on insere une ligne  ...
      INSERT INTO tmpfe60
	(numseq, coddep, coddeppole, count_pascont,
	count00_30, count31_60, count61_90, count91_120, count120
	)
	VALUES (
	l_numseq, l_oldcoddep, l_oldcoddeppole, l_count_pascont,
	 l_count00_30, l_count31_60, l_count61_90, l_count91_120, l_count120);
   END IF;

   -- Fermeture du curseur et retour...
   close c_all;

   commit;

   RETURN l_numseq;

EXCEPTION
   WHEN OTHERS THEN
     --dbms_output.put_line ('Une erreur !!!');
    rollback;
    RETURN 0;
END;


-- ------------------------------------------------------------------------
-- Nom        : f_epilogue_fe60

-- Auteur     : Equipe SOPRA
-- Decription : Efface les lignes de tmpfe60, correspondant à p_numseq
-- Paramètres : p_numseq    IN             numéro de séquence
-- Retour     : Si le prologue ne se passe pas bien, renvoie false, sinon
--              false
--
-- ------------------------------------------------------------------------
--                           MODIFICATION
--
-- ------------------------------------------------------------------------
FUNCTION f_epilogue_fe60(p_numseq NUMBER) RETURN BOOLEAN IS
BEGIN

   DELETE tmpfe60 WHERE numseq = p_numseq;
   commit;
   RETURN true;
EXCEPTION
   WHEN OTHERS THEN
     -- Une erreur oracle
     RETURN false;
END;



-- ------------------------------------------------------------------------
-- Nom        : verif_fe63
-- Auteur     :
-- Decription :  p_datdebut  (IN)       Date de début de la période de
--                                      règlement comptable
--               p_datfin    (IN)       Date de fin de la période de
--                                      règlement comptable
--               p_userid    (IN)       User de l'utilisateur
--               p_message   (OUT)      Message eventuel d'erreur
--

-- ------------------------------------------------------------------------
--                           MODIFICATION
--
-- ------------------------------------------------------------------------
PROCEDURE verif_fe63 ( p_datdebut IN  VARCHAR2,
		       p_datfin   IN  VARCHAR2,
		       p_userid   IN  VARCHAR2,
		       p_message  OUT VARCHAR2
		     ) IS
BEGIN

   -- Vérification de la cohérence des dates
   IF (to_date(p_datdebut,'DD/MM/YYYY')  > to_date(p_datfin,'DD/MM/YYYY')) THEN
      pack_global.recuperer_message(20284,NULL, NULL, 'P_param6', p_message);
   END IF ;

   -- Vérification des bornes pour les dates
   IF (to_number(substr(p_datdebut,7)) < 1985 OR to_number(substr(p_datdebut,7)) > 2099)  THEN
      pack_global.recuperer_message(1000,NULL, NULL, 'P_param6', p_message);
   END IF ;
   IF (to_number(substr(p_datfin,7)) < 1985 OR to_number(substr(p_datfin,7)) > 2099)  THEN
      pack_global.recuperer_message(1000,NULL, NULL, 'P_param7', p_message);
   END IF ;
END;

PROCEDURE verif_factab6(
			p_soccode IN  societe.soccode%TYPE, -- CHAR(4)
  			p_fregcompta1 IN VARCHAR2,          -- date
  			p_fregcompta2 IN VARCHAR2,          -- date
  			p_userid  IN  VARCHAR2,
  			P_message OUT VARCHAR2
		       ) is

   l_message   VARCHAR2(1024);
BEGIN
   l_message := '';

   IF (p_soccode IS NOT NULL) THEN
      pack_ctl_lstcontl.select_societe (p_soccode,'P_param6', l_message);
   END IF;

   -- Controle de la periode
   IF (l_message IS NULL) THEN
      pack_ctl_lstcontl.select_periode(p_fregcompta1 , p_fregcompta2 , 'P_param7','P_param8', l_message);
   END IF;

   p_message := l_message;
END verif_factab6;


PROCEDURE verif_lstfact(
			 p_soccode IN  societe.soccode%TYPE, -- char(4)
			 p_fenrcompta1 IN VARCHAR2,          -- date
 			 p_fenrcompta2 IN VARCHAR2,          -- date
			 p_lmoisprest1 IN VARCHAR2,          -- date
 			 p_lmoisprest2 IN VARCHAR2,          -- date
 			 p_fdeppole    IN VARCHAR2,          --  NUMBER(7)
 			 p_socnat      IN VARCHAR2,          --  char(1)
 			 p_comcode     IN VARCHAR2,          --  varchar(11)
 			 p_fmontht     IN VARCHAR2,          --  Sans utilité
             p_numexpense  IN  VARCHAR2,
 			 p_userid      IN VARCHAR2,
  			 P_message     OUT VARCHAR2
			) is

   l_message   VARCHAR2(1024);
BEGIN
   l_message := '';

   IF (p_soccode IS NOT NULL) THEN
      pack_ctl_lstcontl.select_societe (p_soccode,'P_param6', l_message);

   END IF;

   -- Controle de la periode
   IF (l_message IS NULL) THEN
      pack_ctl_lstcontl.select_periode(p_fenrcompta1, p_fenrcompta2, 'P_param7', l_message);
   END IF;

   IF (l_message IS NULL) THEN
      pack_ctl_lstcontl.select_periode(p_lmoisprest1 , p_lmoisprest2, 'P_param9', l_message);
   END IF;

   IF (l_message IS NULL) and (p_fdeppole IS NOT NULL ) THEN
      pack_ctl_lstcontl.select_dpg (p_userid,p_fdeppole, 'P_param11', l_message);
   END IF;

   IF (l_message IS NULL) and (p_comcode IS NOT NULL) THEN
      select_CodeComptable (p_comcode,'P_param13',l_message);
   END IF;

   IF (l_message IS NULL) and (p_numexpense IS NOT NULL) THEN
      pack_ctl_lstcontl.select_Numexpense (p_numexpense,'P_param15',l_message);
   END IF;


   p_message := l_message;
END verif_lstfact;

-- ------------------
PROCEDURE select_CodeComptable(
			       p_comcode IN VARCHAR2,
			       p_focus IN  VARCHAR2,
			       p_msg OUT VARCHAR2
			      ) IS

   l_msg   VARCHAR2(1024);
   l_comcode code_compt.comcode%TYPE;

BEGIN
   l_msg := '';
   BEGIN
      SELECT comcode INTO l_comcode
	FROM   code_compt
	WHERE  comcode = p_comcode;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
	-- Code comptable %s1 inexistant
	pack_global.recuperer_message(2023, '%s1' , p_comcode , p_focus, l_msg);
      WHEN OTHERS THEN
	raise_application_error(-20997,SQLERRM);
   END;

   p_msg := l_msg;
END select_CodeComptable;

function f_entetecol_fe65(
			  p_num NUMBER
			 ) RETURN VARCHAR2
                    IS
BEGIN
 	IF (p_num = 1) THEN
   		RETURN '1NB Factures    entregistrées';
 	END IF ;
 	IF (p_num = 2) THEN
   		RETURN '2NB Factures    réglées';
 	END IF ;
 	IF (p_num = 3) THEN
   		RETURN '3NB Factures    sans contrat';
 	END IF ;
 	IF (p_num = 4) THEN
   		RETURN '4Nb tot. fact.  en att./periode';
 	END IF ;
 	IF (p_num = 5) THEN
   		RETURN '5Nb tot. fact.  en attente';
 	END IF ;

END f_entetecol_fe65;

-- ---------------------------------------------
PROCEDURE verif_fe65(
                 p_datdeb  IN  VARCHAR2,         -- date
                 p_datfin  IN  VARCHAR2,         -- date
                 p_userid  IN  VARCHAR2,
                 P_message OUT VARCHAR2
                 ) is

      l_message   VARCHAR2(1024);
BEGIN
      pack_ctl_lstcontl.select_periode (p_datdeb, p_datfin, 'P_param6', TRUE, l_message);
      p_message := l_message;
END verif_fe65;

PROCEDURE verif_facqua6 (p_param6  IN VARCHAR2,
			 p_param7  IN VARCHAR2,
			 p_userid  IN VARCHAR2,
			 p_message OUT VARCHAR2
			 ) IS

   l_msg   VARCHAR2(1024);

BEGIN

   -- Initialiser le message retour
   p_message := '';

   IF (to_date(p_param6,'DD/MM/YYYY')  > to_date(p_param7,'DD/MM/YYYY')) THEN
      pack_global.recuperer_message(20284, NULL, NULL, NULL, l_msg);
      raise_application_error(-20284, l_msg);
   END IF;

   IF to_number(substr(p_param6, 7,4)) < 1985 THEN
      pack_global.recuperer_message(20291, NULL, NULL, NULL, l_msg);
      raise_application_error(-20291, l_msg);
   END IF;

END verif_facqua6;

END pack_rep_facture ;
/