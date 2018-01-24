-- PACK_DEMANDE_VAL_FACT PL/SQL
--
-- J. Mas
-- Créé le 30/03/2006
-- 
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE PACK_DEMANDE_VAL_FACT AS

   -- Définition curseur sur la table DEMANDE_VAL_FACT
	
   TYPE demvalf_ViewType IS RECORD ( mail_cp        VARCHAR2(60),
         				 		   	 iddem			DEMANDE_VAL_FACTU.IDDEM%TYPE,
         				 		   	 datdem			DEMANDE_VAL_FACTU.DATDEM%TYPE,
                   					 numfact        DEMANDE_VAL_FACTU.NUMFACT%TYPE,
					                 socfact        DEMANDE_VAL_FACTU.SOCFACT%TYPE,
                   					 typfact        DEMANDE_VAL_FACTU.TYPFACT%TYPE,
					                 datfact        DEMANDE_VAL_FACTU.DATFACT%TYPE,
					                 lnum        	DEMANDE_VAL_FACTU.LNUM%TYPE,
					                 ecart			VARCHAR2(60),
									 causesuspens   DEMANDE_VAL_FACTU.CAUSESUSPENS%TYPE,
									 statut			DEMANDE_VAL_FACTU.STATUT%TYPE
								   ); 
 
   TYPE demvalfCurType_Char IS REF CURSOR RETURN demvalf_ViewType;

/*******************************************************************************/
/*                                                                             */
/*       SELECTIONNE LES DEMANDES EFFECTUEES                                   */
/*                                                                             */
/*******************************************************************************/
   PROCEDURE select_liste_effectue ( p_userid       IN VARCHAR2,
                            	   	 p_mois         IN VARCHAR2,
                            		 p_statut       IN VARCHAR2,
                            		 p_curdemvalf   IN OUT demvalfCurType_Char ,
                            		 p_nbcurseur       OUT INTEGER,
                            		 p_message         OUT VARCHAR2
                          		   );

						  

/*******************************************************************************/
/*                                                                             */
/*       SELECTIONNE LES DEMANDES FAITES AU GDM                                */
/*                                                                             */
/*******************************************************************************/
   PROCEDURE select_liste ( p_userid       IN VARCHAR2,
                            p_mois         IN VARCHAR2,
                            p_statut       IN VARCHAR2,
                            p_curdemvalf   IN OUT demvalfCurType_Char ,
                            p_nbcurseur       OUT INTEGER,
                            p_message         OUT VARCHAR2
                          );

						  
   TYPE ligfact_ViewType IS RECORD ( socfact        FACTURE.SOCFACT%TYPE,
         				 		   	 soclib			SOCIETE.SOCLIB%TYPE,
                   					 numfact        FACTURE.NUMFACT%TYPE,
                   					 typfact        FACTURE.TYPFACT%TYPE,
					                 datfact        FACTURE.DATFACT%TYPE,
					                 lnum        	LIGNE_FACT.LNUM%TYPE,
					                 ecart			DEMANDE_VAL_FACTU.ECART%TYPE,
									 numcont  		FACTURE.NUMCONT%TYPE,
									 ident	 		LIGNE_FACT.IDENT%TYPE,
									 rnom	 		RESSOURCE.RNOM%TYPE,
									 rprenom		RESSOURCE.RPRENOM%TYPE,
                   					 lmoisprest     VARCHAR2(10),
                   					 lcodcompta     VARCHAR2(20),
                   					 lmontht        VARCHAR2(30),
                   					 coutj          VARCHAR2(10),
									 fenrcompta		VARCHAR2(10),
									 fenvsec		VARCHAR2(10),
									 fmodreglt		VARCHAR2(10),
									 fordrecheq		VARCHAR2(60),
									 fnom			VARCHAR2(60),
									 fadresse1		VARCHAR2(60),
									 fadresse2		VARCHAR2(60),
									 fadresse3		VARCHAR2(60),
									 fcodepost		VARCHAR2(10),
									 fburdistr		VARCHAR2(60),
                   					 cusag         	VARCHAR2(10),
                   					 consommeht     VARCHAR2(20)
								   ); 
 
   TYPE ligfactCurType_Char IS REF CURSOR RETURN ligfact_ViewType;

/*******************************************************************************/
/*                                                                             */
/*       SELECTIONNE LA LIGNE DE FACTURE A AFFICHER                            */
/*                                                                             */
/*******************************************************************************/
   PROCEDURE ligne_facture ( p_iddem		IN NUMBER,
   			 			   	 p_socfact      IN VARCHAR2,
                             p_numfact      IN VARCHAR2,
                             p_typfact      IN VARCHAR2,
                             p_datfact      IN VARCHAR2,
                             p_lnum         IN NUMBER,
                             p_curligfact   IN OUT ligfactCurType_Char ,
                             p_nbcurseur       OUT INTEGER,
                             p_message         OUT VARCHAR2
                           );



   TYPE demande_ViewType IS RECORD ( causesuspens   DEMANDE_VAL_FACTU.CAUSESUSPENS%TYPE,
   						 		     faccsec		DEMANDE_VAL_FACTU.FACCSEC%TYPE,
									 fregcompta		DEMANDE_VAL_FACTU.FREGCOMPTA%TYPE,
									 fstatut2		DEMANDE_VAL_FACTU.FSTATUT2%TYPE,
									 numfact		DEMANDE_VAL_FACTU.NUMFACT%TYPE
								   ); 
 
   TYPE demandeCurType_Char IS REF CURSOR RETURN demande_ViewType;

/*******************************************************************************/
/*                                                                             */
/*       SELECTIONNE UNE DEMANDE                                               */
/*                                                                             */
/*******************************************************************************/
   PROCEDURE select_demande ( p_iddem		 IN NUMBER,
                              p_curdemande   IN OUT demandeCurType_Char ,
                              p_nbcurseur       OUT INTEGER,
                              p_message         OUT VARCHAR2
                            );


/*******************************************************************************/
/*                                                                             */
/*       MISE A JOUR D'UNE DEMANDE                                             */
/*                                                                             */
/*******************************************************************************/
   PROCEDURE maj_demande ( p_iddem		  IN NUMBER,
                           p_causesuspens IN VARCHAR2,
                           p_faccsec      IN VARCHAR2,
                           p_fregcompta   IN VARCHAR2,
                           p_fstatut2     IN VARCHAR2,
                           p_mode         IN VARCHAR2,
                           p_nbcurseur       OUT INTEGER,
                           p_message         OUT VARCHAR2
                         );
						 

/*******************************************************************************/
/*                                                                             */
/*       LISTE TOUTES LES FACTURES RELATIVE A LA DEMANDE					   */
/*                                                                             */
/*******************************************************************************/
PROCEDURE all_ligne_facture ( p_iddem		 IN NUMBER,
                          	  p_curligfact   IN OUT ligfactCurType_Char ,
                          	  p_nbcurseur       OUT INTEGER,
                          	  p_message         OUT VARCHAR2
                            );




   TYPE ligfactsuivi_ViewType IS RECORD ( socfact    FACTURE.SOCFACT%TYPE,
         				 		   	 	  soclib	 SOCIETE.SOCLIB%TYPE,
                   					 	  numfact    FACTURE.NUMFACT%TYPE,
                   					 	  typfact    FACTURE.TYPFACT%TYPE,
					                 	  datfact    FACTURE.DATFACT%TYPE,
									 	  fenrcompta VARCHAR2(10),
									 	  fenvsec	 VARCHAR2(10),
									 	  fmodreglt	 VARCHAR2(10),
									 	  fordrecheq VARCHAR2(60),
									 	  fnom		 VARCHAR2(60),
									 	  fadresse1	 VARCHAR2(60),
									 	  fadresse2	 VARCHAR2(60),
									 	  fadresse3	 VARCHAR2(60),
									 	  fcodepost	 VARCHAR2(10),
									 	  fburdistr	 VARCHAR2(60),
										  FACCSEC	 VARCHAR2(10),
										  FREGCOMPTA VARCHAR2(10),
										  FSTATUT2	 DEMANDE_VAL_FACTU.FSTATUT2%TYPE
								        ); 
 
   TYPE ligfactsuiviCurType_Char IS REF CURSOR RETURN ligfactsuivi_ViewType;

/*******************************************************************************/
/*                                                                             */
/*       LISTE LES FACTURES POUR MISE A JOUR DATE DE SUIVI					   */
/*                                                                             */
/*******************************************************************************/
PROCEDURE facture_date_suivi ( p_iddem		 IN NUMBER,
                          	   p_curligfact  IN OUT ligfactsuiviCurType_Char ,
                          	   p_nbcurseur      OUT INTEGER,
                          	   p_message        OUT VARCHAR2
                             );


/*******************************************************************************/
/*                                                                             */
/*       MISE A JOUR DES DATES DE SUIVI DES FACTURES						   */
/*                                                                             */
/*******************************************************************************/
PROCEDURE update_facture ( p_iddem		IN VARCHAR2,
						   p_socfact    IN VARCHAR2,
		  				   p_numfact    IN VARCHAR2,
						   p_typfact    IN VARCHAR2,
						   p_datfact    IN VARCHAR2,
						   p_faccsec    IN VARCHAR2,
                           p_fregcompta IN VARCHAR2,
                           p_fstatut2   IN VARCHAR2,
						   p_fenvsec	IN VARCHAR2,
						   p_fenrcompta IN VARCHAR2,
						   p_fmodreglt	IN VARCHAR2,
						   p_fordrecheq IN VARCHAR2,
						   p_fnom		IN VARCHAR2,
						   p_fadresse1	IN VARCHAR2,
						   p_fadresse2	IN VARCHAR2,
						   p_fadresse3	IN VARCHAR2,
						   p_fcodepost	IN VARCHAR2,
						   p_fburdistr	IN VARCHAR2,
                           p_nbcurseur     OUT INTEGER,
                           p_message       OUT VARCHAR2
                         );
						 
						 
END PACK_DEMANDE_VAL_FACT;
/





CREATE OR REPLACE PACKAGE BODY PACK_DEMANDE_VAL_FACT AS 



/*******************************************************************************/
/*                                                                             */
/*       SELECTIONNE LES DEMANDES EFFECTUEES AU GDM  (profil ACH)              */
/*                                                                             */
/*******************************************************************************/
PROCEDURE select_liste_effectue ( p_userid       IN VARCHAR2,
                         		  p_mois         IN VARCHAR2,
                         		  p_statut       IN VARCHAR2,
                         		  p_curdemvalf   IN OUT demvalfCurType_Char ,
                         		  p_nbcurseur       OUT INTEGER,
                         		  p_message         OUT VARCHAR2
                                ) IS
	l_msg	    VARCHAR2(1024);
	l_idarpege  RTFE_USER.USER_RTFE%TYPE;
	l_codcfrais		NUMBER(3);

BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	
    p_nbcurseur := 1;
    p_message   := '';
	l_idarpege  := PACK_GLOBAL.lire_globaldata(p_userid).idarpege;
	l_codcfrais := PACK_GLOBAL.lire_globaldata(p_userid).codcfrais;

    BEGIN
        OPEN p_curdemvalf FOR
			select ' ' mail_cp, d.IDDEM, d.DATDEM, d.NUMFACT, d.SOCFACT, d.TYPFACT, to_char(d.DATFACT, 'dd/mm/yyyy') datfact, d.LNUM, to_char(d.ECART,'FM99999990D00'), d.CAUSESUSPENS, d.STATUT
			  from DEMANDE_VAL_FACTU d
			 where ( d.codcfrais = l_codcfrais or l_codcfrais=0 )  
			   -- Affiche les statuts demandés ( X = Tous les statuts à traiter : En Attente , Validee GDM, En suspens )
			   and (    ( d.STATUT = p_statut )
					 OR ( p_statut = 'X' and d.STATUT IN ('A','V','S') )
				   )
				-- Si mois reçu à 01/2000 on ne tient pas compte de la date   
			   and ( p_mois = '01/2000' or trunc(d.DATDEM) between ('01/'||p_mois) and (add_months('01/'||p_mois,1)-1))  
			 order by d.DATDEM desc, d.IDDEM, d.NUMFACT, d.SOCFACT, d.TYPFACT, d.DATFACT, d.LNUM;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;
  
END select_liste_effectue;



/*******************************************************************************/
/*                                                                             */
/*       SELECTIONNE LES DEMANDES POUR LE GDM (profil ME)                      */
/*                                                                             */
/*******************************************************************************/
PROCEDURE select_liste ( p_userid       IN VARCHAR2,
                         p_mois         IN VARCHAR2,
                         p_statut       IN VARCHAR2,
                         p_curdemvalf   IN OUT demvalfCurType_Char ,
                         p_nbcurseur       OUT INTEGER,
                         p_message         OUT VARCHAR2
                       ) IS
	l_msg	     VARCHAR2(1024);
	l_ident	 	 NUMBER(5);
	l_idarpege   RTFE_USER.USER_RTFE%TYPE;
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	
    p_nbcurseur  := 1;
    p_message    := '';
	l_idarpege   := PACK_GLOBAL.lire_globaldata(p_userid).idarpege;

    BEGIN

	-- Recherche si le GDM existe en tant que ressource BIP

	   BEGIN
	    SELECT IDENT
		  INTO l_ident
		  FROM RTFE_USER
		 WHERE USER_RTFE = upper(l_idarpege);
		EXCEPTION
 		    WHEN NO_DATA_FOUND THEN
 		    	-- S'il n'existe pas on ne bloque pas le traitement pour autant - on positionne l'ident à 0
				l_ident     := 0;
	        WHEN OTHERS THEN
	            raise_application_error(-20997, SQLERRM);
		END;


        OPEN p_curdemvalf FOR
			select cp.RNOM||' '||cp.RPRENOM mail_cp, d.IDDEM, d.DATDEM, d.NUMFACT, d.SOCFACT, d.TYPFACT, to_char(d.DATFACT, 'dd/mm/yyyy') datfact, d.LNUM, to_char(d.ECART,'FM99999990D00'), d.CAUSESUSPENS, d.STATUT
			  from DEMANDE_VAL_FACTU d, SITU_RESS_FULL sr, RESSOURCE cp
			 where d.IDENT_GDM = l_ident
			   and (    ( d.STATUT = p_statut )
					 OR ( p_statut = 'X' and d.STATUT IN ('A','S') )
					 OR ( p_statut = 'V' and d.STATUT IN ('T','V') )
				   )
			   and d.IDENT   = sr.IDENT
				-- Si mois reçu à 01/2000 on ne tient pas compte de la date   
			   and ( p_mois = '01/2000' or trunc(d.DATDEM) between ('01/'||p_mois) and (add_months('01/'||p_mois,1)-1))  
			   and sr.DATSITU <= d.LMOISPREST
			   and (sr.DATDEP > d.LMOISPREST or sr.DATDEP is null)
			   and sr.CPIDENT = cp.IDENT
			 order by d.DATDEM desc, d.IDDEM, d.NUMFACT, d.SOCFACT, d.TYPFACT, d.DATFACT, d.LNUM;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;
  
END select_liste;




/*******************************************************************************/
/*                                                                             */
/*       SELECTIONNE LA LIGNE DE FACTURE A AFFICHER                            */
/*                                                                             */
/*******************************************************************************/
PROCEDURE ligne_facture ( p_iddem		 IN NUMBER,
		  				  p_socfact      IN VARCHAR2,
                          p_numfact      IN VARCHAR2,
                          p_typfact      IN VARCHAR2,
                          p_datfact      IN VARCHAR2,
                          p_lnum         IN NUMBER,
                          p_curligfact   IN OUT ligfactCurType_Char ,
                          p_nbcurseur       OUT INTEGER,
                          p_message         OUT VARCHAR2
                       ) IS
	l_msg	    VARCHAR2(1024);
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	
    p_nbcurseur := 1;
    p_message := '';

    BEGIN
        OPEN p_curligfact FOR
	        SELECT dvf.SOCFACT, s.SOCLIB, dvf.NUMFACT, dvf.TYPFACT, to_char(dvf.DATFACT, 'dd/mm/yyyy') datfact, 
				   dvf.lnum, to_char(dvf.ECART,'FM99999990D00'),
				   f.NUMCONT, dvf.ident, r.rnom ,r.rprenom ,
	               TO_CHAR(dvf.lmoisprest,'MM/YYYY') lmoisprest,
				   lf.lcodcompta,
				   TO_CHAR(lf.lmontht,'FM99999990D00'),
				   to_char(sr.COUT),
				   to_char(f.fenrcompta, 'dd/mm/yyyy'), to_char(f.fenvsec, 'dd/mm/yyyy'), TO_CHAR(f.fmodreglt), 
				   f.fordrecheq, f.fnom, f.fadresse1, f.fadresse2, f.fadresse3, TO_CHAR(f.fcodepost), f.fburdistr,
				   TO_CHAR(dvf.cusag,'FM990D00') ,
				   TO_CHAR(dvf.consommeht,'FM99999990D00') 
	        FROM ligne_fact lf, ressource r, societe s, facture f, demande_val_factu dvf, situ_ress_full sr
	        WHERE   dvf.ident    = r.ident
			    AND dvf.socfact  = s.soccode
	            AND dvf.socfact = p_socfact
	            AND dvf.typfact = p_typfact
	            AND dvf.datfact = to_date(p_datfact, 'dd/mm/yyyy')
	            AND dvf.numfact = RPAD(p_numfact,15)
				AND dvf.IDDEM   = p_iddem
				AND f.SOCFACT   = lf.SOCFACT
				AND f.TYPFACT   = lf.TYPFACT
				AND f.NUMFACT   = lf.NUMFACT
				AND f.DATFACT   = lf.DATFACT
				AND dvf.SOCFACT = lf.SOCFACT
				AND dvf.TYPFACT = lf.TYPFACT
				AND dvf.NUMFACT = lf.NUMFACT
				AND dvf.DATFACT = lf.DATFACT
				AND dvf.LNUM  	= lf.LNUM
			    AND sr.DATSITU <= dvf.LMOISPREST
			    AND (sr.DATDEP  > dvf.LMOISPREST or sr.DATDEP is null)
				AND sr.IDENT    = r.IDENT ;


    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;
  
END ligne_facture;





/*******************************************************************************/
/*                                                                             */
/*       SELECTIONNE UNE DEMANDE                                               */
/*                                                                             */
/*******************************************************************************/
PROCEDURE select_demande ( p_iddem		  IN NUMBER,
                           p_curdemande   IN OUT demandeCurType_Char ,
                           p_nbcurseur       OUT INTEGER,
                           p_message         OUT VARCHAR2
						 ) IS
	l_msg	    VARCHAR2(1024);
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	
    p_nbcurseur := 1;
    p_message := '';

    BEGIN
        OPEN p_curdemande FOR
	        SELECT causesuspens, to_char(faccsec,'dd/mm/yyyy') faccsec, to_char(fregcompta,'dd/mm/yyyy') fregcompta,
				   fstatut2, numfact
	          FROM demande_val_factu
	         WHERE iddem = p_iddem;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;
  
END select_demande;




/*******************************************************************************/
/*                                                                             */
/*       MISE A JOUR D'UNE DEMANDE                                             */
/*                                                                             */
/*******************************************************************************/
PROCEDURE maj_demande ( p_iddem		   IN NUMBER,
                        p_causesuspens IN VARCHAR2,
                        p_faccsec      IN VARCHAR2,
                        p_fregcompta   IN VARCHAR2,
                        p_fstatut2     IN VARCHAR2,
                        p_mode         IN VARCHAR2,
                        p_nbcurseur       OUT INTEGER,
                        p_message         OUT VARCHAR2
					  ) IS
	l_msg	       VARCHAR2(1024);
	l_statut       VARCHAR2(1);
	l_causesuspens DEMANDE_VAL_FACTU.CAUSESUSPENS%TYPE;
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	
    p_nbcurseur := 1;
    p_message := '';
    l_statut := '';

	if (p_mode = 'causesuspens') then
	    l_statut := 'S';
		--p_message := 'Demande mise en suspens.';
		l_causesuspens := p_causesuspens;
	elsif (p_mode = 'datesuivi') then
	    l_statut := 'V';
		--p_message := 'Demande validee.';
		l_causesuspens := '';
	end if;
	
    BEGIN
		UPDATE demande_val_factu
		   SET statut       = l_statut,
		   	   datstat		= sysdate,
		       causesuspens = l_causesuspens,
		       faccsec      = to_date(p_faccsec,'dd/mm/yyyy'),
			   fregcompta   = to_date(p_fregcompta,'dd/mm/yyyy'),
			   fstatut2     = p_fstatut2
         WHERE iddem   = p_iddem;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;
  
END maj_demande;




/*******************************************************************************/
/*                                                                             */
/*       LISTE TOUTES LES FACTURES RELATIVE A LA DEMANDE					   */
/*                                                                             */
/*******************************************************************************/
PROCEDURE all_ligne_facture ( p_iddem		 IN NUMBER,
                          	  p_curligfact   IN OUT ligfactCurType_Char ,
                          	  p_nbcurseur       OUT INTEGER,
                          	  p_message         OUT VARCHAR2
                            ) IS
	l_msg	    VARCHAR2(1024);
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	
    p_nbcurseur := 1;
    p_message := '';

    BEGIN
        OPEN p_curligfact FOR
	        SELECT dvf.SOCFACT, s.SOCLIB, dvf.NUMFACT, dvf.TYPFACT, to_char(dvf.DATFACT, 'dd/mm/yyyy') datfact, 
				   dvf.lnum, to_char(dvf.ECART,'FM99999990D00'),
				   f.NUMCONT, dvf.ident, r.rnom ,r.rprenom ,
	               TO_CHAR(dvf.lmoisprest,'MM/YYYY') lmoisprest,
				   lf.lcodcompta,
				   TO_CHAR(lf.lmontht,'FM99999990D00'),
				   to_char(sr.COUT),
				   to_char(f.fenrcompta, 'dd/mm/yyyy'), to_char(f.fenvsec, 'dd/mm/yyyy'), TO_CHAR(f.fmodreglt), 
				   f.fordrecheq, f.fnom, f.fadresse1, f.fadresse2, f.fadresse3, TO_CHAR(f.fcodepost), f.fburdistr,
				   TO_CHAR(dvf.cusag,'FM990D00') ,
				   TO_CHAR(dvf.consommeht,'FM99999990D00') 
	        FROM ligne_fact lf, ressource r, societe s, facture f, demande_val_factu dvf, situ_ress_full sr
	        WHERE   dvf.ident   = r.ident
			    AND dvf.socfact  = s.soccode
				AND dvf.IDDEM   = p_iddem
				AND f.SOCFACT   = lf.SOCFACT
				AND f.TYPFACT   = lf.TYPFACT
				AND f.NUMFACT   = lf.NUMFACT
				AND f.DATFACT   = lf.DATFACT
				AND dvf.SOCFACT = lf.SOCFACT
				AND dvf.TYPFACT = lf.TYPFACT
				AND dvf.NUMFACT = lf.NUMFACT
				AND dvf.DATFACT = lf.DATFACT
				AND dvf.LNUM  	= lf.LNUM
				AND sr.IDENT    = r.IDENT
				AND sr.DATSITU <= dvf.LMOISPREST
			    AND (sr.DATDEP  > dvf.LMOISPREST or sr.DATDEP is null);

    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;

END all_ligne_facture;


/*******************************************************************************/
/*                                                                             */
/*       LISTE LES FACTURES POUR MISE A JOUR DATE DE SUIVI					   */
/*                                                                             */
/*******************************************************************************/
PROCEDURE facture_date_suivi ( p_iddem		 IN NUMBER,
                          	   p_curligfact  IN OUT ligfactsuiviCurType_Char ,
                          	   p_nbcurseur      OUT INTEGER,
                          	   p_message        OUT VARCHAR2
                             ) IS
	l_msg	    VARCHAR2(1024);
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	
    p_nbcurseur := 1;
    p_message := '';

    BEGIN
        OPEN p_curligfact FOR
	        SELECT dvf.SOCFACT, s.SOCLIB, dvf.NUMFACT, dvf.TYPFACT, to_char(dvf.DATFACT, 'dd/mm/yyyy') datfact, 
				   to_char(f.fenrcompta, 'dd/mm/yyyy'), to_char(f.fenvsec, 'dd/mm/yyyy'), TO_CHAR(f.fmodreglt), 
				   f.fordrecheq, f.fnom, f.fadresse1, f.fadresse2, f.fadresse3, TO_CHAR(f.fcodepost), f.fburdistr,
				   to_char(dvf.FACCSEC, 'dd/mm/yyyy'), to_char(dvf.FREGCOMPTA, 'dd/mm/yyyy'), dvf.FSTATUT2
	        FROM societe s, facture f, demande_val_factu dvf
	        WHERE   dvf.IDDEM   = p_iddem
				AND dvf.SOCFACT = f.SOCFACT
				AND dvf.TYPFACT = f.TYPFACT
				AND dvf.NUMFACT = f.NUMFACT
				AND dvf.DATFACT = f.DATFACT
			    AND f.socfact  	= s.soccode;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;

END facture_date_suivi;




/*******************************************************************************/
/*                                                                             */
/*       MISE A JOUR DES DATES DE SUIVI DES FACTURES						   */
/*                                                                             */
/*******************************************************************************/
PROCEDURE update_facture ( p_iddem		IN VARCHAR2,
						   p_socfact    IN VARCHAR2,
		  				   p_numfact    IN VARCHAR2,
						   p_typfact    IN VARCHAR2,
						   p_datfact    IN VARCHAR2,
						   p_faccsec    IN VARCHAR2,
                           p_fregcompta IN VARCHAR2,
                           p_fstatut2   IN VARCHAR2,
						   p_fenvsec	IN VARCHAR2,
						   p_fenrcompta IN VARCHAR2,
						   p_fmodreglt	IN VARCHAR2,
						   p_fordrecheq IN VARCHAR2,
						   p_fnom		IN VARCHAR2,
						   p_fadresse1	IN VARCHAR2,
						   p_fadresse2	IN VARCHAR2,
						   p_fadresse3	IN VARCHAR2,
						   p_fcodepost	IN VARCHAR2,
						   p_fburdistr	IN VARCHAR2,
                           p_nbcurseur     OUT INTEGER,
                           p_message       OUT VARCHAR2
					  ) IS
	l_msg	       VARCHAR2(1024);
	l_fenvsec	   DATE;
	l_fenrcompta   DATE;
	l_faccsec	   DATE;
	l_fregcompta   DATE;
	nb			   NUMBER;
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
	
    p_nbcurseur  := 1;
    p_message 	 := '';
	l_fenvsec 	 := null;
	l_fenrcompta := null;
	l_faccsec 	 := null;
	l_fregcompta := null;

	if (p_fenvsec is not null) then
	    l_fenvsec := to_date(p_fenvsec,'dd/mm/yyyy');
	end if;	
	if (p_fenrcompta is not null) then
	    l_fenrcompta := to_date(p_fenrcompta,'dd/mm/yyyy');
	end if;	
	if (p_faccsec is not null) then
	    l_faccsec := to_date(p_faccsec,'dd/mm/yyyy');
	end if;	
	if (p_fregcompta is not null) then
	    l_fregcompta := to_date(p_fregcompta,'dd/mm/yyyy');
	end if;	
	
    BEGIN
		UPDATE FACTURE
		   SET fenvsec		= l_fenvsec,
			   fenrcompta 	= l_fenrcompta,
			   fmodreglt	= p_fmodreglt,
			   fordrecheq 	= p_fordrecheq,
			   fnom			= p_fnom,
			   fadresse1	= p_fadresse1,
			   fadresse2	= p_fadresse2,
			   fadresse3	= p_fadresse3,
			   fcodepost	= p_fcodepost,
			   fburdistr	= p_fburdistr,
		       faccsec      = l_faccsec,
			   fregcompta   = l_fregcompta,
			   fstatut2     = p_fstatut2
         WHERE socfact = rpad(p_socfact,4,' ')
		   AND numfact = rpad(p_numfact,15,' ')
		   AND typfact = p_typfact
		   AND datfact = to_date(p_datfact,'dd/mm/yyyy');
		  
		 -- Positionne la demande val facture à traitee ORD  
		 UPDATE DEMANDE_VAL_FACTU 
		 SET   statut='T'
		 WHERE iddem = TO_NUMBER(p_iddem) ; 
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;
  
END update_facture;



END PACK_DEMANDE_VAL_FACT;
/

