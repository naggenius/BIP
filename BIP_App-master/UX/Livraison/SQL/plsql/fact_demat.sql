-- pack_activite PL/SQL
--
-- 
-- Créé le 03/11/2006 par BAA Fiche 481 dematerialisation des factures
-- Modifier le 08/08/2007 par EVI: Mise en commentaire de la ligne 1631
-- Modifier le 17/07/2008 par ABA: prise en compte du siren de la table agence et non societe
--  Suppression des verrous SMS 23/03/20011 par BSA : Fiche 837

--****************************************************************************

CREATE OR REPLACE PACKAGE Pack_Fact_Demat AS

TYPE Liste_datprest                IS VARRAY(8) OF   VARCHAR2(4);
TYPE Liste_nom_prenom      IS VARRAY(8) OF      VARCHAR2(32);
TYPE Liste_montht                   IS VARRAY(8) OF      VARCHAR2(20);


PROCEDURE insert_fact_demat  ( p_userid 	IN VARCHAR2,
                                                            p_chaine	IN VARCHAR2,
									   						p_code_err 	IN VARCHAR2,
															p_num_champs_err 	IN VARCHAR2,
                        									p_nbcurseur     OUT INTEGER,
                        									p_message       OUT VARCHAR2
															);

PROCEDURE decouper_chaine  (	p_chaine	IN VARCHAR2,
                                                                    l_NUM_CHARG    OUT NUMBER,
                                                                    l_EMETTEUR       OUT VARCHAR2,
  											                        l_DATE_FIC          OUT VARCHAR2,
  											                        l_NUMORD           OUT VARCHAR2,
  											                        l_REF_SG              OUT VARCHAR2,
  											                        l_SIREN                  OUT  VARCHAR2,
  											                        l_TYPFACT           OUT  CHAR,
  											                        l_NUMFACT          OUT VARCHAR2,
  											                        l_DATFACT           OUT VARCHAR2,
  											                        l_NUMCONT         OUT VARCHAR2,
  											                        l_RIB                         OUT VARCHAR2,
  											                        l_MONTHT             OUT VARCHAR2,
  											                        l_MONTTTC          OUT VARCHAR2,
  											                        l_MONTTVA          OUT VARCHAR2,
											                        l_nbprest                OUT  NUMBER,
											                        Tab_datprest      IN  OUT  Liste_datprest,
											                        Tab_nom_prenom  IN OUT Liste_nom_prenom,
											                        Tab_montht            IN OUT Liste_montht
																	 );

FUNCTION controle (	 p_NUM_CHARG    IN  NUMBER,
                                           p_EMETTEUR      IN OUT VARCHAR2,
  											p_DATE_FIC          IN DATE,
  											p_NUMORD           IN VARCHAR2,
  											p_REF_SG              IN VARCHAR2,
  											p_SIREN                  IN VARCHAR2,
  											p_TYPFACT           IN  CHAR,
  											p_NUMFACT          IN OUT VARCHAR2,
  											p_DATFACT           IN DATE,
  											p_NUMCONT         IN VARCHAR2,
  											p_rib                         IN OUT VARCHAR2,
  											p_MONTHT             IN VARCHAR2,
  											p_MONTTTC          IN VARCHAR2,
  											p_MONTTVA          IN VARCHAR2,
											p_nbprest                 IN NUMBER,
											Tab_datprest           IN  Liste_datprest,
											Tab_nom_prenom   IN Liste_nom_prenom,
											Tab_montht                 IN Liste_montht,
											l_count OUT NUMBER,
                                            l_soccode OUT CHAR,
                                            l_codsg OUT NUMBER,
                                            l_ccentrefrais OUT NUMBER,
                                            l_tva      OUT NUMBER,
                                            l_cav     OUT CHAR,
											v_cdeb OUT DATE,
											l_socfour OUT VARCHAR2,
											l_codcompta OUT VARCHAR2,
										    l_deppole OUT NUMBER,
											p_NUM_CHAMPS_ERR OUT VARCHAR2
										   ) RETURN  NUMBER;

PROCEDURE insert_demat_rejets(p_NUM_CHARG    IN NUMBER,
                                                                       p_CODE_ERR       IN NUMBER,
   																		p_EMETTEUR      IN VARCHAR2,
  																	    p_DATE_FIC     IN VARCHAR2,
  																		p_NUMORD       IN VARCHAR2,
  																		p_REF_SG       IN VARCHAR2,
  																		p_SIREN        IN VARCHAR2,
  																		p_TYPFACT    IN  CHAR,
  																		p_NUMFACT      IN VARCHAR2,
  																		p_DATFACT      IN VARCHAR2,
  																		p_NUMCONT      IN VARCHAR2,
  																		p_RIB          IN VARCHAR2,
  																		p_MONTHT       IN VARCHAR2,
  																		p_MONTTTC      IN VARCHAR2,
  																		p_MONTTVA      IN VARCHAR2,
																		p_NBPREST    IN NUMBER,
  																		p_DATPREST1    IN VARCHAR2,
  																		p_NOM_PRENOM1  IN VARCHAR2,
  																		p_MONTHT1      IN VARCHAR2,
  																		p_DATPREST2    IN VARCHAR2,
  																		p_NOM_PRENOM2  IN VARCHAR2,
  																		p_MONTHT2      IN VARCHAR2,
  																		p_DATPREST3    IN VARCHAR2,
  																		p_NOM_PRENOM3  IN VARCHAR2,
  																		p_MONTHT3      IN VARCHAR2,
  																		p_DATPREST4    IN VARCHAR2,
  																		p_NOM_PRENOM4  IN VARCHAR2,
  																		p_MONTHT4      IN VARCHAR2,
  																		p_DATPREST5    IN VARCHAR2,
  																		p_NOM_PRENOM5  IN VARCHAR2,
  																		p_MONTHT5      IN VARCHAR2,
  																		p_DATPREST6    IN VARCHAR2,
  																		p_NOM_PRENOM6  IN VARCHAR2,
  																		p_MONTHT6      IN VARCHAR2,
  																		p_DATPREST7    IN VARCHAR2,
  																		p_NOM_PRENOM7  IN VARCHAR2,
  																		p_MONTHT7      IN VARCHAR2,
  																		p_DATPREST8    IN VARCHAR2,
  																		p_NOM_PRENOM8  IN VARCHAR2,
  																		p_MONTHT8      IN VARCHAR2,
																		p_NUM_CHAMPS_ERR IN VARCHAR2
															 		 );


FUNCTION    insert_facture(p_SOCCODE      IN VARCHAR2,
                                                             p_NUMFACT      IN VARCHAR2,
                                                             p_TYPFACT        IN  CHAR,
  															 p_DATFACT        IN DATE,
                                                             p_MONTHT         IN VARCHAR2,
  															 p_MONTTTC       IN VARCHAR2,
															 p_EMETTEUR    IN VARCHAR2,
															 p_NUMCONT      IN VARCHAR2,
															 p_REF_SG           IN VARCHAR2,
															 p_CAV                    IN CHAR,
															 p_NUM_CHARG    IN NUMBER,
															 p_CDEB                    IN DATE,
															 p_cccentrefrais       IN NUMBER,
															 p_socfour                 IN VARCHAR2,
															 p_tva                          IN NUMBER,
															 p_codcompta         IN VARCHAR2,
															 p_deppole          IN NUMBER
															 ) RETURN NUMBER;


PROCEDURE    insert_ligne_facture(p_MONTHT            IN VARCHAR2,
                                                                         p_codcompta         IN VARCHAR2,
                                                                         p_deppole               IN NUMBER,
																		 p_CDEB                    IN DATE,
                                                                         p_SOCCODE          IN VARCHAR2,
   	                                                                     p_TYPFACT            IN  CHAR,
																		 p_DATFACT            IN DATE,
																		 p_NUMFACT           IN VARCHAR2,
																		p_tva                          IN NUMBER,
																		p_ident                      IN NUMBER,
																		p_num                        IN NUMBER
																		) ;


PROCEDURE verif_rapprochement (l_socfact     IN FACTURE.socfact%TYPE,
                               l_ident         IN VARCHAR2,
                               l_lmontht       IN VARCHAR2,
                               l_lmoisprest    IN VARCHAR2,
                               b_askGDM        IN VARCHAR2,
                               l_userid        IN VARCHAR2,
                               l_message          OUT VARCHAR2,
                               p_mail             OUT VARCHAR2
                              );



PROCEDURE rapprochement_facture (l_socfact     IN FACTURE.socfact%TYPE,
                                                                             l_ident         IN VARCHAR2,
                                                                             l_cdeb     IN DATE
                                                                              );



END Pack_Fact_Demat;
/


CREATE OR REPLACE PACKAGE BODY     Pack_Fact_Demat AS



PROCEDURE insert_fact_demat  ( p_userid 	IN VARCHAR2,
                                                            p_chaine	IN VARCHAR2,
									   						p_code_err 	IN VARCHAR2,
														    p_num_champs_err 	IN VARCHAR2,
                        									p_nbcurseur     OUT INTEGER,
                        									p_message       OUT VARCHAR2
															) IS

l_chaine VARCHAR2(2000);


l_num_charg      NUMBER(5);
l_emetteur          VARCHAR2(6);
l_emetteur_init          VARCHAR2(6);
l_date_fic           VARCHAR2(20);
l_numord            VARCHAR2(6);
l_ref_sg              VARCHAR2(15);
l_siren                  VARCHAR2(10);
l_typfact              CHAR(1);
l_numfact            VARCHAR2(20);
l_datfact              VARCHAR2(20);
l_numcont           VARCHAR2(20);
l_rib                      VARCHAR2(23);
l_rib_init                      VARCHAR2(23);
l_montht               VARCHAR2(20);
l_monttva            VARCHAR2(20);
l_montttc              VARCHAR2(20);
l_nbprest             NUMBER(2);
Tab_datprest             Liste_datprest := Liste_datprest();
Tab_nom_prenom   Liste_nom_prenom := Liste_nom_prenom();
Tab_montht                 Liste_montht := Liste_montht();


l_code_err NUMBER(3);
l_num_champs_err NUMBER(3);


l_count NUMBER(5);
l_soccode CHAR(4);
l_codsg NUMBER(7);
l_ccentrefrais NUMBER(3);
l_tva      NUMBER(12,2);
l_cav     CHAR(2);
l_cdeb DATE;
l_socfour VARCHAR2(10);
l_codcompta VARCHAR2(11);
l_deppole      NUMBER(7);

l_ident NUMBER(5);

v_date_fic   DATE;
v_datfact     DATE;
v_cdeb DATE;

l_rapp  VARCHAR2(3);
l_msg         VARCHAR2(1024);
l_mail 		VARCHAR2(5000);

var NUMBER;

BEGIN


	 p_message :='';


	 l_chaine := p_chaine;

	 l_code_err := 0;
	 l_num_champs_err := p_num_champs_err ;
	 l_ident := NULL;
	 l_rapp := 'OUI';

	 decouper_chaine  (	l_chaine,
                                             l_num_charg ,
                                          	 l_EMETTEUR,
  											 l_DATE_FIC,
  											 l_NUMORD ,
  											 l_REF_SG ,
  											 l_SIREN ,
  											 l_TYPFACT,
  											 l_NUMFACT ,
  											 l_DATFACT,
  											 l_NUMCONT,
  											 l_RIB ,
  											 l_MONTHT ,
  											 l_MONTTTC ,
  											 l_MONTTVA,
											 l_nbprest,
											 Tab_datprest,
											 Tab_nom_prenom,
											 Tab_montht
											 );


		l_emetteur_init := l_emetteur;
        l_rib_init := l_rib;

		SELECT INSTR(l_date_fic,'/') INTO var  FROM dual;
		IF(var <>0)THEN
		     v_date_fic   := TO_DATE(l_date_fic,'DD/MM/YYYYHH24:MI:SS');
	         l_date_fic := TO_CHAR(v_date_fic,'YYYYMMDDHH24MI');
		END IF;


		SELECT INSTR(l_datfact,'/') INTO var  FROM dual;
		IF(var <>0)THEN
              v_datfact     := TO_DATE(l_datfact,'DD/MM/YYYY');
			  l_datfact := TO_CHAR(v_datfact,'YYYYMMDD');
		END IF;


		IF( NVL(TO_NUMBER(p_code_err),0) <> 0 )THEN

		       insert_demat_rejets(l_num_charg, NVL(TO_NUMBER(p_code_err),0), l_emetteur_init, l_date_fic, l_numord ,
	                                                l_ref_sg, l_siren, l_typfact, l_numfact, l_datfact,
                                                    l_numcont, l_rib_init,l_montht, l_montttc, l_monttva,l_nbprest,
											        Tab_datprest(1) , Tab_nom_prenom(1) , Tab_montht(1) ,
											        Tab_datprest(2) , Tab_nom_prenom(2) , Tab_montht(2) ,
											        Tab_datprest(3) , Tab_nom_prenom(3) , Tab_montht(3) ,
											        Tab_datprest(4) , Tab_nom_prenom(4) , Tab_montht(4) ,
											        Tab_datprest(5) , Tab_nom_prenom(5) , Tab_montht(5) ,
											        Tab_datprest(6) , Tab_nom_prenom(6) , Tab_montht(6) ,
											        Tab_datprest(7) , Tab_nom_prenom(7) , Tab_montht(7) ,
											        Tab_datprest(8) , Tab_nom_prenom(8) , Tab_montht(8),
													l_num_champs_err
                                                    );

		ELSE






	  DBMS_OUTPUT.PUT_LINE('*l_datfact:'||l_datfact);

	l_code_err := controle(l_num_charg,
	                                             l_EMETTEUR,
  											     v_DATE_FIC,
  											     l_NUMORD ,
  											     l_REF_SG ,
  											     l_SIREN ,
  											     l_TYPFACT,
  											     l_NUMFACT ,
  											     v_DATFACT,
  											     l_NUMCONT,
  											     l_RIB ,
  											     l_MONTHT ,
  											     l_MONTTTC ,
  											     l_MONTTVA,
											     l_nbprest,
											     Tab_datprest,
											     Tab_nom_prenom,
											     Tab_montht,
											      l_count,
                                                  l_soccode,
                                                  l_codsg,
                                                  l_ccentrefrais,
                                                  l_tva,
                                                  l_cav,
												  l_cdeb,
												  l_socfour,
												  l_codcompta,
												  l_deppole,
												  l_num_champs_err
											      );

			v_cdeb := l_cdeb;

	       IF( l_code_err <> 0 )THEN

		   insert_demat_rejets(l_num_charg, l_code_err, l_emetteur_init, l_date_fic, l_numord ,
	                                                l_ref_sg, l_siren, l_typfact, l_numfact, l_datfact,
                                                    l_numcont, l_rib_init,l_montht, l_montttc, l_monttva,l_nbprest,
											        Tab_datprest(1) , Tab_nom_prenom(1) , Tab_montht(1) ,
											        Tab_datprest(2) , Tab_nom_prenom(2) , Tab_montht(2) ,
											        Tab_datprest(3) , Tab_nom_prenom(3) , Tab_montht(3) ,
											        Tab_datprest(4) , Tab_nom_prenom(4) , Tab_montht(4) ,
											        Tab_datprest(5) , Tab_nom_prenom(5) , Tab_montht(5) ,
											        Tab_datprest(6) , Tab_nom_prenom(6) , Tab_montht(6) ,
											        Tab_datprest(7) , Tab_nom_prenom(7) , Tab_montht(7) ,
											        Tab_datprest(8) , Tab_nom_prenom(8) , Tab_montht(8),
													l_num_champs_err
                                                    );



	   ELSE

		   --Insertion facture
		  l_code_err  :=   insert_facture(l_SOCCODE,
                                        l_NUMFACT,
                                        l_TYPFACT,
  										v_DATFACT,
                                        l_MONTHT,
  										l_MONTTTC,
										l_EMETTEUR,
										l_NUMCONT,
										l_REF_SG,
										l_CAV,
										l_NUM_CHARG,
										l_cdeb,
										l_ccentrefrais,
										l_socfour,
										l_tva,
										l_codcompta,
										l_deppole
                                        );


		  IF( l_code_err <> 0 )THEN

		   insert_demat_rejets(l_num_charg, l_code_err, l_emetteur_init, l_date_fic, l_numord ,
	                                                l_ref_sg, l_siren, l_typfact, l_numfact, l_datfact,
                                                    l_numcont, l_rib_init,l_montht, l_montttc, l_monttva,l_nbprest,
											        Tab_datprest(1) , Tab_nom_prenom(1) , Tab_montht(1) ,
											        Tab_datprest(2) , Tab_nom_prenom(2) , Tab_montht(2) ,
											        Tab_datprest(3) , Tab_nom_prenom(3) , Tab_montht(3) ,
											        Tab_datprest(4) , Tab_nom_prenom(4) , Tab_montht(4) ,
											        Tab_datprest(5) , Tab_nom_prenom(5) , Tab_montht(5) ,
											        Tab_datprest(6) , Tab_nom_prenom(6) , Tab_montht(6) ,
											        Tab_datprest(7) , Tab_nom_prenom(7) , Tab_montht(7) ,
											        Tab_datprest(8) , Tab_nom_prenom(8) , Tab_montht(8),
													l_num_champs_err
                                                    );


		ELSE

		--insertion lignes factures


		--aucun enregistrement
		IF(( Tab_nom_prenom(1) IS NULL ) OR (  l_nbprest =0 ) OR  ( Tab_nom_prenom(1) = '' )) THEN

		         --controle d'une seule ligne contrat
				 SELECT COUNT(*) INTO l_count FROM LIGNE_CONT
				                      WHERE trim(numcont)=l_numcont AND soccont=l_soccode AND cav=l_cav
									  AND TRUNC(lresdeb,'MM') <= l_cdeb  AND lresfin >=  l_cdeb;
		          IF( l_count <> 1)THEN
				             ROLLBACK;
							 l_num_champs_err :=8 ;
				             l_code_err := 17;
							 insert_demat_rejets(l_num_charg, l_code_err, l_emetteur_init, l_date_fic, l_numord ,
	                                                l_ref_sg, l_siren, l_typfact, l_numfact, l_datfact,
                                                    l_numcont, l_rib_init,l_montht, l_montttc, l_monttva,l_nbprest,
											        Tab_datprest(1) , Tab_nom_prenom(1) , Tab_montht(1) ,
											        Tab_datprest(2) , Tab_nom_prenom(2) , Tab_montht(2) ,
											        Tab_datprest(3) , Tab_nom_prenom(3) , Tab_montht(3) ,
											        Tab_datprest(4) , Tab_nom_prenom(4) , Tab_montht(4) ,
											        Tab_datprest(5) , Tab_nom_prenom(5) , Tab_montht(5) ,
											        Tab_datprest(6) , Tab_nom_prenom(6) , Tab_montht(6) ,
											        Tab_datprest(7) , Tab_nom_prenom(7) , Tab_montht(7) ,
											        Tab_datprest(8) , Tab_nom_prenom(8) , Tab_montht(8),
													l_num_champs_err
                                                    );
				  ELSE
				           --recherche de l'identifiant de la ressource
						  SELECT ident INTO l_ident FROM LIGNE_CONT WHERE trim(numcont)=l_numcont AND soccont=l_soccode AND cav=l_cav
						  AND TRUNC(lresdeb,'MM') <= l_cdeb  AND lresfin >=  l_cdeb;

						  IF( l_typfact = 'A' )THEN
					             SELECT COUNT(*) INTO l_count  FROM FACTURE f, LIGNE_FACT lf
                                                     WHERE f.socfact=l_soccode AND  trim(f.numcont)=l_numcont AND f.typfact=l_typfact
                                                     AND lf.socfact=f.socfact AND lf.numfact=f.numfact AND  lf.datfact=f.datfact AND lf.typfact=f.typfact AND lf.ident=l_ident AND lf.lmoisprest=l_cdeb;

								 IF( l_count = 0 )THEN
								                  ROLLBACK;
												   l_num_champs_err :=6;
												  l_code_err := 20;
												    insert_demat_rejets(l_num_charg, l_code_err, l_emetteur_init, l_date_fic, l_numord ,
	                                                l_ref_sg, l_siren, l_typfact, l_numfact, l_datfact,
                                                    l_numcont, l_rib_init,l_montht, l_montttc, l_monttva,l_nbprest,
											        Tab_datprest(1) , Tab_nom_prenom(1) , Tab_montht(1) ,
											        Tab_datprest(2) , Tab_nom_prenom(2) , Tab_montht(2) ,
											        Tab_datprest(3) , Tab_nom_prenom(3) , Tab_montht(3) ,
											        Tab_datprest(4) , Tab_nom_prenom(4) , Tab_montht(4) ,
											        Tab_datprest(5) , Tab_nom_prenom(5) , Tab_montht(5) ,
											        Tab_datprest(6) , Tab_nom_prenom(6) , Tab_montht(6) ,
											        Tab_datprest(7) , Tab_nom_prenom(7) , Tab_montht(7) ,
											        Tab_datprest(8) , Tab_nom_prenom(8) , Tab_montht(8),
													l_num_champs_err
                                                    );
								ELSE
								          insert_ligne_facture(l_montht, l_codcompta, l_deppole, l_cdeb, l_soccode, l_typfact,  v_datfact,   l_numfact ,  l_tva, l_ident,1);
										  verif_rapprochement(l_soccode, l_ident, l_montht, TO_CHAR(l_cdeb,'MM/YYYY'), 'OUI', p_userid, l_msg, l_mail);
														IF(SUBSTR(l_msg,0,3) = 'RAP')THEN
													      rapprochement_facture ( l_soccode,  l_ident, l_cdeb);
													END IF;

										UPDATE DEMAT_CHARGEMENT SET NB_INTEG= NB_INTEG+1 WHERE num_charg=l_num_charg;
									    COMMIT;

								END IF;
						  --tupfact = F
						  ELSE
						                 insert_ligne_facture(l_montht, l_codcompta, l_deppole, l_cdeb, l_soccode, l_typfact,  v_datfact,   l_numfact ,  l_tva, l_ident,1);
									    verif_rapprochement(l_soccode, l_ident, l_montht, TO_CHAR(l_cdeb,'MM/YYYY'), 'OUI', p_userid, l_msg, l_mail);
													IF(SUBSTR(l_msg,0,3) = 'RAP')THEN
													      rapprochement_facture ( l_soccode,  l_ident, l_cdeb);
													END IF;

										UPDATE DEMAT_CHARGEMENT SET NB_INTEG= NB_INTEG+1 WHERE num_charg=l_num_charg;
									    COMMIT;

						  END IF;

				END IF;



	    -- plusieurs enregistrements
	   ELSE
		          FOR i IN 1..8 LOOP
				   IF ( l_code_err  = 0 )THEN

				      IF ( Tab_nom_prenom(i) IS NOT NULL  ) THEN

					            --contrôle de la date de prestation
								 IF( Tab_datprest (i) IS  NOT NULL ) AND ( trim(Tab_datprest (i)) <> ''  )THEN
											 l_cdeb := TO_DATE(Tab_datprest (i), 'MMYY');
								ELSE
											  l_cdeb := v_cdeb;
								END IF;

					        --recherche ressource ligne contrat
					       SELECT COUNT(*) INTO l_count FROM RESSOURCE r, SITU_RESS s,LIGNE_CONT lc
                                             WHERE INSTR(Tab_nom_prenom(i), UPPER(rnom)) >0
                                             AND r.ident=s.ident AND s.soccode=l_soccode AND ROWNUM=1
                                             AND TRUNC(datsitu,'MM') <= l_cdeb  AND datdep >=  l_cdeb
											 AND lc.ident=r.ident
											 AND trim(lc.numcont)=l_numcont  AND lc.soccont=l_soccode
											 AND TRUNC(lc.lresdeb,'MM') <=  l_cdeb  AND lc.lresfin >=   l_cdeb;


					         IF( l_count = 0 )THEN
								                  ROLLBACK;
												  l_num_champs_err := 14 + (i-1)*3 ;
												  l_code_err := 18;
												    insert_demat_rejets(l_num_charg, l_code_err, l_emetteur_init, l_date_fic, l_numord ,
	                                                l_ref_sg, l_siren, l_typfact, l_numfact, l_datfact,
                                                    l_numcont, l_rib_init,l_montht, l_montttc, l_monttva,l_nbprest,
											        Tab_datprest(1) , Tab_nom_prenom(1) , Tab_montht(1) ,
											        Tab_datprest(2) , Tab_nom_prenom(2) , Tab_montht(2) ,
											        Tab_datprest(3) , Tab_nom_prenom(3) , Tab_montht(3) ,
											        Tab_datprest(4) , Tab_nom_prenom(4) , Tab_montht(4) ,
											        Tab_datprest(5) , Tab_nom_prenom(5) , Tab_montht(5) ,
											        Tab_datprest(6) , Tab_nom_prenom(6) , Tab_montht(6) ,
											        Tab_datprest(7) , Tab_nom_prenom(7) , Tab_montht(7),
											        Tab_datprest(8) , Tab_nom_prenom(8) , Tab_montht(8),
													l_num_champs_err
                                                    );
						      ELSE
							  		   SELECT r.ident INTO l_ident FROM RESSOURCE r, SITU_RESS s, LIGNE_CONT lc
                                             WHERE INSTR(Tab_nom_prenom(i), UPPER(rnom)) >0
                                             AND r.ident=s.ident AND s.soccode=l_soccode AND ROWNUM=1
                                             AND TRUNC(datsitu,'MM') <= l_cdeb  AND datdep >=  l_cdeb
											  AND lc.ident=r.ident
											 AND trim(lc.numcont)=l_numcont  AND lc.soccont=l_soccode
											 AND TRUNC(lc.lresdeb,'MM') <=  l_cdeb  AND lc.lresfin >=   l_cdeb;


										 --contrôle de la date de prestation n'est pas postérieur à la date de la facture
					                      IF( TO_DATE(l_datfact,'yyyymmdd') < l_cdeb )THEN
										         ROLLBACK;
												     l_num_champs_err := 13 + (i-1)*3 ;
													 l_code_err := 19;
												    insert_demat_rejets(l_num_charg, l_code_err, l_emetteur_init, l_date_fic, l_numord ,
	                                                l_ref_sg, l_siren, l_typfact, l_numfact, l_datfact,
                                                    l_numcont, l_rib_init,l_montht, l_montttc, l_monttva,l_nbprest,
											        Tab_datprest(1) , Tab_nom_prenom(1) , Tab_montht(1) ,
											        Tab_datprest(2) , Tab_nom_prenom(2) , Tab_montht(2) ,
											        Tab_datprest(3) , Tab_nom_prenom(3) , Tab_montht(3) ,
											        Tab_datprest(4) , Tab_nom_prenom(4) , Tab_montht(4) ,
											        Tab_datprest(5) , Tab_nom_prenom(5) , Tab_montht(5) ,
											        Tab_datprest(6) , Tab_nom_prenom(6) , Tab_montht(6) ,
											        Tab_datprest(7) , Tab_nom_prenom(7) , Tab_montht(7) ,
											        Tab_datprest(8) , Tab_nom_prenom(8) , Tab_montht(8),
													l_num_champs_err
                                                    );
										  ELSE
										  			insert_ligne_facture(TO_NUMBER(Tab_montht(i)), l_codcompta, l_deppole, l_cdeb, l_soccode, l_typfact,  v_datfact,   l_numfact ,  l_tva, l_ident, i);


													verif_rapprochement(l_soccode, l_ident, TO_NUMBER(Tab_montht(i)), TO_CHAR(l_cdeb,'MM/YYYY'), 'OUI', p_userid, l_msg, l_mail);
													IF(SUBSTR(l_msg,0,3) = 'RAP')THEN
													      rapprochement_facture ( l_soccode,  l_ident, l_cdeb);
													END IF;

										  END IF;


							  END IF;

					   END IF; --fin test non prenom
					 END IF; --fin test si il n'ya pas d'erreur sur le préstation précedante
				   END LOOP;


				 IF( l_code_err =0 )THEN
				       COMMIT;

					   	UPDATE DEMAT_CHARGEMENT SET NB_INTEG= NB_INTEG+1 WHERE num_charg=l_num_charg;

				END IF;


		     END IF;

		END IF;

		END IF;

	  END IF;

	END  insert_fact_demat;

PROCEDURE decouper_chaine  (p_chaine	IN VARCHAR2,
                                                                    l_NUM_CHARG    OUT NUMBER,
                                                                    l_EMETTEUR       OUT VARCHAR2,
  											                        l_DATE_FIC          OUT VARCHAR2,
  											                        l_NUMORD           OUT VARCHAR2,
  											                        l_REF_SG              OUT VARCHAR2,
  											                        l_SIREN                  OUT  VARCHAR2,
  											                        l_TYPFACT           OUT  CHAR,
  											                        l_NUMFACT          OUT VARCHAR2,
  											                        l_DATFACT           OUT VARCHAR2,
  											                        l_NUMCONT         OUT VARCHAR2,
  											                        l_RIB                         OUT VARCHAR2,
  											                        l_MONTHT             OUT VARCHAR2,
  											                        l_MONTTTC          OUT VARCHAR2,
  											                        l_MONTTVA          OUT VARCHAR2,
											                        l_nbprest                OUT  NUMBER,
											                        Tab_datprest       IN OUT  Liste_datprest,
											                        Tab_nom_prenom  IN OUT Liste_nom_prenom,
											                        Tab_montht         IN     OUT Liste_montht
																	)	 IS

l_point1 NUMBER(7);
l_point2 NUMBER(7);
l_point3 NUMBER(7);
l_point4 NUMBER(7);
l_point5 NUMBER(7);
l_point6 NUMBER(7);
l_point7 NUMBER(7);
l_point8 NUMBER(7);
l_point9 NUMBER(7);
l_point10 NUMBER(7);
l_point11 NUMBER(7);
l_point12 NUMBER(7);
l_point13 NUMBER(7);
l_point14 NUMBER(7);
l_point15 NUMBER(7);

l_chaine VARCHAR2(2000);


BEGIN

       l_chaine := REPLACE (p_chaine,' ', '');

        l_point1 := INSTR(l_chaine,';',1,1);
		l_point2 := INSTR(l_chaine,';',1,2);
		l_point3 := INSTR(l_chaine,';',1,3);
	    l_point4 := INSTR(l_chaine,';',1,4);
		l_point5 := INSTR(l_chaine,';',1,5);
		l_point6 := INSTR(l_chaine,';',1,6);
		l_point7 := INSTR(l_chaine,';',1,7);
		l_point8 := INSTR(l_chaine,';',1,8);
		l_point9 := INSTR(l_chaine,';',1,9);
		l_point10 := INSTR(l_chaine,';',1,10);
		l_point11 := INSTR(l_chaine,';',1,11);
		l_point12 := INSTR(l_chaine,';',1,12);
		l_point13 := INSTR(l_chaine,';',1,13);
		l_point14 := INSTR(l_chaine,';',1,14);
		l_point15 := INSTR(l_chaine,';',1,15);



		l_num_charg := NVL(TO_NUMBER(SUBSTR(l_chaine, 1, l_point1-1)),0);
		DBMS_OUTPUT.PUT_LINE('num_charg:'||l_num_charg);

		l_emetteur   := SUBSTR(l_chaine, l_point1+1, l_point2-l_point1-1);
		DBMS_OUTPUT.PUT_LINE('emetteur:'||l_emetteur);


	    l_date_fic     := SUBSTR(l_chaine, l_point2+1, l_point3-l_point2-1);
		DBMS_OUTPUT.PUT_LINE(' l_dat_fic:'|| l_date_fic);

	    l_numord   := SUBSTR(l_chaine, l_point3+1, l_point4-l_point3-1);
		DBMS_OUTPUT.PUT_LINE('l_numord:'||l_numord);

	    l_ref_sg      := SUBSTR(l_chaine, l_point4+1, l_point5-l_point4-1);
		DBMS_OUTPUT.PUT_LINE('l_ref_sg :'||l_ref_sg );

	    l_siren         := SUBSTR(l_chaine, l_point5+1, l_point6-l_point5-1);
		DBMS_OUTPUT.PUT_LINE('l_siren:'||l_siren);

	    l_typfact      := SUBSTR(l_chaine, l_point6+1, l_point7-l_point6-1);
		DBMS_OUTPUT.PUT_LINE(' l_typfact '|| l_typfact );

	    l_numfact    := SUBSTR(l_chaine, l_point7+1, l_point8-l_point7-1);
		DBMS_OUTPUT.PUT_LINE('l_numfact '||l_numfact );

        l_datfact      := SUBSTR(l_chaine, l_point8+1, l_point9-l_point8-1);
		DBMS_OUTPUT.PUT_LINE('l_datfact :'||l_datfact );

        l_numcont   := SUBSTR(l_chaine, l_point9+1, l_point10-l_point9-1);
		DBMS_OUTPUT.PUT_LINE('l_numcont :'||l_numcont );

		l_rib               := SUBSTR(l_chaine, l_point10+1, l_point11-l_point10-1);
		DBMS_OUTPUT.PUT_LINE('l_rib :'||l_rib );

        l_montht       := SUBSTR(l_chaine, l_point11+1, l_point12-l_point11-1);
		DBMS_OUTPUT.PUT_LINE('l_montht:'||l_montht);

		l_monttva    := SUBSTR(l_chaine, l_point12+1, l_point13-l_point12-1);
		DBMS_OUTPUT.PUT_LINE('l_monttva:'||l_monttva);

		l_montttc     := SUBSTR(l_chaine, l_point13+1, l_point14-l_point13-1);
		DBMS_OUTPUT.PUT_LINE('l_montttc :'||l_montttc );

		l_nbprest    :=TO_NUMBER(SUBSTR(l_chaine, l_point14+1, l_point15-l_point14-1));
        DBMS_OUTPUT.PUT_LINE('nbprest:'||l_nbprest);


		FOR i IN 1..8LOOP

				Tab_datprest.EXTEND;
		        Tab_nom_prenom.EXTEND;
				Tab_montht.EXTEND;

				IF(i<=l_nbprest) THEN


			   l_point1 := INSTR(l_chaine,';',1,(i-1)*3+15);
		       l_point2 := INSTR(l_chaine,';',1,(i-1)*3+1+15);
			   l_point3 := INSTR(l_chaine,';',1,(i-1)*3+2+15);
			   l_point4 := INSTR(l_chaine,';',1,(i-1)*3+3+15);


		       Tab_datprest(i)              :=  NVL(SUBSTR(l_chaine, l_point1+1, l_point2-l_point1-1),'');
			   DBMS_OUTPUT.PUT_LINE('datprest:'||Tab_datprest(i)  );
               Tab_nom_prenom(i)    :=  NVL(SUBSTR(l_chaine, l_point2+1, l_point3-l_point2-1),'');
			   DBMS_OUTPUT.PUT_LINE('nom_prenom :'||Tab_nom_prenom(i) );
			   Tab_montht(i)                 :=  NVL(SUBSTR(l_chaine, l_point3+1, l_point4-l_point3-1),'');
			    DBMS_OUTPUT.PUT_LINE('montht :'||Tab_montht(i) );




		   ELSE

		       Tab_datprest(i)              :=  '';
			   Tab_nom_prenom(i)    :=  '';
			   Tab_montht(i)                 := '';

		   END IF;

	   END LOOP;

END decouper_chaine;


FUNCTION controle (	p_NUM_CHARG    IN NUMBER,
                                           p_EMETTEUR      IN OUT VARCHAR2,
  											p_DATE_FIC          IN DATE,
  											p_NUMORD           IN VARCHAR2,
  											p_REF_SG              IN VARCHAR2,
  											p_SIREN                  IN VARCHAR2,
  											p_TYPFACT           IN  CHAR,
  											p_NUMFACT          IN OUT VARCHAR2,
  											p_DATFACT           IN DATE,
  											p_NUMCONT         IN VARCHAR2,
  											p_rib                         IN OUT VARCHAR2,
  											p_MONTHT             IN VARCHAR2,
  											p_MONTTTC          IN VARCHAR2,
  											p_MONTTVA          IN VARCHAR2,
											p_nbprest                 IN NUMBER,
											Tab_datprest           IN  Liste_datprest,
											Tab_nom_prenom   IN Liste_nom_prenom,
											Tab_montht                 IN Liste_montht,
											l_count OUT NUMBER,
                                            l_soccode OUT CHAR,
                                            l_codsg OUT NUMBER,
                                            l_ccentrefrais OUT NUMBER,
                                            l_tva      OUT NUMBER,
                                            l_cav     OUT CHAR,
											v_cdeb OUT DATE,
										    l_socfour OUT VARCHAR2,
											l_codcompta OUT VARCHAR2,
										    l_deppole OUT NUMBER,
											p_num_champs_err OUT VARCHAR2
										   ) RETURN  NUMBER IS


v_montht        NUMBER(12,2);
v_desc           NUMBER;


BEGIN

      --test emetteur
	   IF( p_emetteur = 'DESKOM')THEN

	            SELECT COUNT(*) INTO v_desc FROM FACTURE WHERE num_charg=  p_NUM_CHARG;

	   	         p_emetteur := 'DSKM' || TO_CHAR(TRUNC ((TO_NUMBER(v_desc)/50)+1),'FM00');
				 DBMS_OUTPUT.PUT_LINE('p_emetteur:'||p_emetteur);
	   END IF;




	   --controle du rib
	   IF( p_rib IS NOT NULL )  AND ( p_rib <> '11111111111111111111111' ) THEN


		         --test du siren
	             SELECT COUNT(*)  INTO l_count FROM AGENCE WHERE SIREN=TO_NUMBER(p_siren) AND ACTIF='O';
	             IF( l_count = 0)THEN
				          p_num_champs_err := 4;
	                      RETURN 2;
	            END IF;

				  SELECT COUNT(*)  INTO l_count FROM AGENCE WHERE RIB=p_rib  AND ACTIF='O';
			      IF( l_count = 0)THEN
				      p_num_champs_err := 9;
	                  RETURN 4;
			        END IF;



	           SELECT COUNT(*) INTO l_count FROM AGENCE a, SOCIETE s
                                   WHERE a.SIREN=TO_NUMBER(p_siren) AND RIB=p_rib AND ACTIF='O'
								   AND s.soccode=a.soccode
                                   AND (s.soccre <= p_DATFACT OR s.soccre IS NULL)
                                  AND (s.socfer >= p_DATFACT OR s.socfer IS NULL) AND ROWNUM =1;
	           IF( l_count = 0)THEN
			            p_num_champs_err := 4;
	                   RETURN 3;
	           END IF;


			       --societe ouvert
	           SELECT  a.soccode  INTO l_soccode FROM AGENCE a, SOCIETE s
                                   WHERE a.SIREN=TO_NUMBER(p_siren) AND RIB=p_rib AND ACTIF='O'
								   AND s.soccode=a.soccode
                                  AND (s.soccre <= p_DATFACT OR s.soccre IS NULL)
                                 AND (s.socfer >= p_DATFACT OR s.socfer IS NULL) AND ROWNUM =1;


	   ELSE


				  --test du siren
	             SELECT COUNT(*)  INTO l_count FROM AGENCE WHERE SIREN=TO_NUMBER(p_siren) AND ACTIF='O';
	             IF( l_count = 0)THEN
				            p_num_champs_err := 4;
	                       RETURN 2;
	             END IF;




	             SELECT COUNT(*) INTO l_count FROM AGENCE a, SOCIETE s
                                   WHERE a.SIREN=TO_NUMBER(p_siren) AND ACTIF='O'
								   AND s.soccode=a.soccode
                                      AND (s.soccre <= p_DATFACT OR s.soccre IS NULL)
                                 AND (s.socfer >= p_DATFACT OR s.socfer IS NULL) AND ROWNUM =1;
	            IF( l_count = 0)THEN
				        p_num_champs_err := 4;
	                    RETURN 3;
			    END IF;

				    --societe ouvert
				 SELECT  a.soccode  INTO l_soccode FROM AGENCE a, SOCIETE s
                                   WHERE a.SIREN=TO_NUMBER(p_siren) AND ACTIF='O'
								   AND s.soccode=a.soccode
                                        AND (s.soccre <= p_DATFACT OR s.soccre IS NULL)
                                 AND (s.socfer >= p_DATFACT OR s.socfer IS NULL) AND ROWNUM =1;


				SELECT rib INTO p_rib FROM AGENCE WHERE SOCCODE=l_soccode AND SIREN=TO_NUMBER(p_siren)  AND ACTIF='O' AND ROWNUM=1;
				 IF(p_rib IS NULL )THEN
				      p_num_champs_err := 4;
	                  RETURN 5;
	             END IF;


		END IF;

		SELECT socfour INTO l_socfour FROM AGENCE WHERE rib=p_rib AND SIREN=TO_NUMBER(p_siren)  AND ACTIF='O' AND ROWNUM=1;

		   DBMS_OUTPUT.PUT_LINE('*l_rib:'||p_rib);

	   --controle du num contrat
	   DBMS_OUTPUT.PUT_LINE('*l_numcount:AA'||p_numcont||'AA');
	    SELECT COUNT(*) INTO l_count FROM CONTRAT WHERE  trim(numcont)=p_numcont;
		DBMS_OUTPUT.PUT_LINE('*l_count:AA'||l_count||'AA');
		IF( l_count = 0)THEN
		        p_num_champs_err := 8;
		        RETURN 6;
	   END IF;

	    --controle du num contrat pour la societe
	   SELECT COUNT(*) INTO l_count FROM CONTRAT WHERE  trim(numcont)=p_numcont AND soccont=l_soccode;
	    IF( l_count = 0)THEN
		        p_num_champs_err := 8;
	            RETURN 7;
	   END IF;

	   IF ( p_datfact > SYSDATE ) THEN
	            p_num_champs_err := 7;
                RETURN 13;
	   ELSIF  ( ADD_MONTHS(p_datfact,12) < SYSDATE )THEN
			       p_num_champs_err := 7;
                   RETURN 13;
		END IF;

	   --controle numfact
	   SELECT TRIM(TRANSLATE(p_numfact, '~#{[|`@]}¿e''(-è_çà)=^$ù*<,;:!°+£%µ>?./§', ' '))  INTO p_numfact FROM DUAL;

	   --controle de la taille du numfact
	   IF( NVL(LENGTH(p_numfact),0) > 15)THEN
	             p_num_champs_err := 6;
	             RETURN 12;
	   END IF;

	    --controle numfact pour la societe et le type
	   SELECT COUNT(*) INTO l_count FROM FACTURE WHERE  trim(numfact)=p_numfact AND socfact=l_soccode AND typfact=p_typfact;
	   IF( l_count <> 0)THEN
	             p_num_champs_err := 6;
	             RETURN 11;
	   END IF;




	   	--determiner l'avenant
	   IF( Tab_datprest(1)  = '') OR ( Tab_datprest(1)  IS NULL)THEN
	          l_count := TO_NUMBER(TO_CHAR(p_datfact,'dd'));

			   DBMS_OUTPUT.PUT_LINE('**l_count:'||l_count);

			  IF((l_count >=1) AND (l_count <=24))THEN
	                  v_cdeb := ADD_MONTHS(TO_DATE(TO_CHAR(p_datfact,'mmyyyy'),'mmyyyy'),-1);

		      ELSE
			            v_cdeb := TO_DATE(TO_CHAR(p_datfact,'mmyyyy'),'mmyyyy');
			  END IF;

	   ELSE
	        		 v_cdeb := TO_DATE(Tab_datprest(1),'mmyy');
	  END IF;


	   DBMS_OUTPUT.PUT_LINE('**v_cdeb:'||v_cdeb);

	   SELECT COUNT(*) INTO l_count FROM CONTRAT
		                   WHERE trim(NUMCONT)=p_numcont AND SOCCONT=l_soccode
		                  AND TRUNC(CDATDEB,'MM') <= v_cdeb AND (CDATFIN >= v_cdeb OR CDATFIN IS NULL) ;
	    IF(  l_count = 0)THEN
		         p_num_champs_err := 8;
	             RETURN 8;
	    ELSE
	             SELECT MAX(cav) INTO l_cav FROM CONTRAT
		                           WHERE trim(NUMCONT)=p_numcont AND SOCCONT=l_soccode
		                          AND TRUNC(CDATDEB,'MM') <= v_cdeb AND CDATFIN >= v_cdeb ;
	   END IF;



		DBMS_OUTPUT.PUT_LINE('**l_cav:'||l_cav);


	   --controle montant ht
	   IF((Tab_nom_prenom(1)  <> '') OR ( Tab_nom_prenom(1) IS NOT NULL ))THEN
	         v_montht := 0;
	        FOR i IN 1..p_nbprest LOOP
				   	       v_montht := v_montht + TO_NUMBER(Tab_montht(i)) ;
            END LOOP;
	        IF( ABS(v_montht-p_montht)/100 > 1 )THEN
			         p_num_champs_err := 10;
	                 RETURN 15;
	        END IF;
	   END IF;

	   SELECT codsg, ccentrefrais, comcode, codsg INTO l_codsg, l_ccentrefrais, l_codcompta, l_deppole FROM CONTRAT WHERE  trim(numcont)=p_numcont AND soccont=l_soccode
	   AND cav=l_cav;


	    --controle du dpg
	   SELECT COUNT(*) INTO l_count FROM STRUCT_INFO WHERE CODSG=l_codsg AND TOPFER='O';
	    IF(  l_count = 0)THEN
	             RETURN 14;
	   END IF;

	   --controle du centre de faris
	   IF( ( l_ccentrefrais <> 74 ) AND ( l_ccentrefrais <> 77 ) )THEN
	           RETURN 9;
	   END IF;


          IF((p_monttva+p_montht) <> p_montttc)THEN
               p_num_champs_err := 12;
               RETURN 16;

          END IF;

	   --calcule du taux tva


	   l_tva := ((p_monttva/p_montht)*100);

	   DBMS_OUTPUT.PUT_LINE('*l_tva:'||l_tva);
	   DBMS_OUTPUT.PUT_LINE('**abs_tva:'||ABS(l_tva-19.6) );

/*
	   IF(ABS(l_tva-19.6) > 0.1) THEN
	     	   IF (ABS(l_tva-5.5) > 0.1) THEN
	                     IF (l_tva <> 0) THEN
	                          RETURN 16;
					      END IF;
				ELSE
					      l_tva := 5.5;
				END IF;
	   ELSE
		   l_tva := 19.6;
	   END IF;
*/
	   DBMS_OUTPUT.PUT_LINE('**l_tva:'||l_tva);
	   DBMS_OUTPUT.PUT_LINE('**p_datfact:'||p_datfact);
	    DBMS_OUTPUT.PUT_LINE('**ddp_datfact:'||TO_CHAR(p_datfact,'dd'));
	   DBMS_OUTPUT.PUT_LINE('**mmp_datfact:'||TO_CHAR(p_datfact,'mm'));




		RETURN 0;

END controle;




PROCEDURE insert_demat_rejets(p_NUM_CHARG    IN NUMBER,
                                                                       p_CODE_ERR       IN NUMBER,
   																	   p_EMETTEUR      IN VARCHAR2,
  																	   p_DATE_FIC     IN VARCHAR2,
  																		p_NUMORD       IN VARCHAR2,
  																		p_REF_SG       IN VARCHAR2,
  																		p_SIREN        IN VARCHAR2,
  																		p_TYPFACT    IN  CHAR,
  																		p_NUMFACT      IN VARCHAR2,
  																		p_DATFACT      IN VARCHAR2,
  																		p_NUMCONT      IN VARCHAR2,
  																		p_RIB          IN VARCHAR2,
  																		p_MONTHT       IN VARCHAR2,
  																		p_MONTTTC      IN VARCHAR2,
  																		p_MONTTVA      IN VARCHAR2,
																		p_NBPREST IN NUMBER,
  																		p_DATPREST1    IN VARCHAR2,
  																		p_NOM_PRENOM1  IN VARCHAR2,
  																		p_MONTHT1      IN VARCHAR2,
  																		p_DATPREST2    IN VARCHAR2,
  																		p_NOM_PRENOM2  IN VARCHAR2,
  																		p_MONTHT2      IN VARCHAR2,
  																		p_DATPREST3    IN VARCHAR2,
  																		p_NOM_PRENOM3  IN VARCHAR2,
  																		p_MONTHT3      IN VARCHAR2,
  																		p_DATPREST4    IN VARCHAR2,
  																		p_NOM_PRENOM4  IN VARCHAR2,
  																		p_MONTHT4      IN VARCHAR2,
  																		p_DATPREST5    IN VARCHAR2,
  																		p_NOM_PRENOM5  IN VARCHAR2,
  																		p_MONTHT5      IN VARCHAR2,
  																		p_DATPREST6    IN VARCHAR2,
  																		p_NOM_PRENOM6  IN VARCHAR2,
  																		p_MONTHT6      IN VARCHAR2,
  																		p_DATPREST7    IN VARCHAR2,
  																		p_NOM_PRENOM7  IN VARCHAR2,
  																		p_MONTHT7      IN VARCHAR2,
  																		p_DATPREST8    IN VARCHAR2,
  																		p_NOM_PRENOM8  IN VARCHAR2,
  																		p_MONTHT8      IN VARCHAR2,
																		p_num_champs_err IN VARCHAR2
															 		 )   IS

BEGIN




  INSERT INTO DEMAT_REJETS(   NUM_CHARG,
                                                                        CODE_ERR,
   																		EMETTEUR,
  																		DATE_FIC,
  																		NUMORD,
  																		REF_SG,
  																		SIREN,
  																		TYPFACT,
  																		NUMFACT,
  																		DATFACT,
  																		NUMCONT,
  																		RIB,
  																		MONTHT,
  																		MONTTTC,
  																		MONTTVA,
																		NBPREST,
  																		DATPREST1,
  																		NOM_PRENOM1,
  																		MONTHT1,
  																		DATPREST2,
  																		NOM_PRENOM2,
  																		MONTHT2,
  																		DATPREST3,
  																		NOM_PRENOM3,
  																		MONTHT3,
  																		DATPREST4,
  																		NOM_PRENOM4,
  																		MONTHT4,
  																		DATPREST5,
  																		NOM_PRENOM5,
  																		MONTHT5,
  																		DATPREST6,
  																		NOM_PRENOM6,
  																		MONTHT6,
  																		DATPREST7,
  																		NOM_PRENOM7,
  																		MONTHT7,
  																		DATPREST8,
  																		NOM_PRENOM8,
  																		MONTHT8,
																		num_champs_err)
  VALUES
                                                                       (p_NUM_CHARG,
                                                                        p_CODE_ERR,
   																		p_EMETTEUR,
  																		p_DATE_FIC,
  																		p_NUMORD,
  																		p_REF_SG,
  																		p_SIREN,
  																		p_TYPFACT,
  																		p_NUMFACT,
  																		p_DATFACT,
  																		p_NUMCONT,
  																		p_RIB,
  																		p_MONTHT,
  																		p_MONTTTC,
  																		p_MONTTVA,
																		p_NBPREST,
  																		p_DATPREST1,
  																		p_NOM_PRENOM1,
  																		p_MONTHT1,
  																		p_DATPREST2,
  																		p_NOM_PRENOM2,
  																		p_MONTHT2,
  																		p_DATPREST3,
  																		p_NOM_PRENOM3,
  																		p_MONTHT3,
  																		p_DATPREST4,
  																		p_NOM_PRENOM4,
  																		p_MONTHT4,
  																		p_DATPREST5,
  																		p_NOM_PRENOM5,
  																		p_MONTHT5,
  																		p_DATPREST6,
  																		p_NOM_PRENOM6,
  																		p_MONTHT6,
  																		p_DATPREST7,
  																		p_NOM_PRENOM7,
  																		p_MONTHT7,
  																		p_DATPREST8,
  																		p_NOM_PRENOM8,
  																		p_MONTHT8,
																		TO_NUMBER(p_num_champs_err));


		UPDATE DEMAT_CHARGEMENT SET NB_REJET= NB_REJET+1 WHERE num_charg=p_NUM_CHARG;


	    COMMIT;
		--il faut sortire;

END insert_demat_rejets;


FUNCTION   insert_facture(p_SOCCODE      IN VARCHAR2,
                                                             p_NUMFACT      IN VARCHAR2,
                                                             p_TYPFACT        IN  CHAR,
  															 p_DATFACT        IN DATE,
                                                             p_MONTHT         IN VARCHAR2,
  															 p_MONTTTC       IN VARCHAR2,
															 p_EMETTEUR    IN VARCHAR2,
															 p_NUMCONT      IN VARCHAR2,
															 p_REF_SG           IN VARCHAR2,
															 p_CAV                    IN CHAR,
															 p_NUM_CHARG    IN NUMBER,
															 p_CDEB                    IN DATE,
															 p_cccentrefrais       IN NUMBER,
															 p_socfour                 IN VARCHAR2,
															 p_tva                          IN NUMBER,
															 p_codcompta         IN VARCHAR2,
															 p_deppole              IN NUMBER
                                                           	 )   RETURN NUMBER IS


BEGIN




  INSERT INTO FACTURE( SOCFACT,
                                                       NUMFACT,
                                                       TYPFACT,
                                                       DATFACT,
                                                       FNUMASN,
                                                       FNUMORDRE,
                                                       FREGCOMPTA,
                                                       LLIBANALYT,
                                                       FMODREGLT,
                                                       FMOIACOMPTA,
                                                       FMONTHT,
                                                       FMONTTTC,
                                                       FCODUSER,
                                                       FCENTREFRAIS,
                                                       FDATMAJ,
                                                       FDATSAI,
                                                       FENRCOMPTA,
													   FSTATUT1,
                                                       FSTATUT2,
													   FACCSEC,
													   FSOCFOUR,
                                                       FTVA,
													   FCODCOMPTA,
                                                       FDEPPOLE,
													   FLAGLOCK,
                                                       SOCCONT,
                                                       CAV,
                                                       NUMCONT,
													   FDATRECEP,
                                                       NUM_SMS,
                                                       REF_SG,
                                                       NUM_CHARG
                                                )
                            VALUES(  p_SOCCODE,
                                                 p_NUMFACT,
                                                 p_TYPFACT,
                                                 p_DATFACT,
												 0,
												 0,
												 '',
												 p_SOCCODE || '-'|| TO_CHAR(p_cdeb,'MMYYYY') ||  '-' || p_NUMFACT || '-' || p_numcont,
												 1,
												 TO_DATE(TO_CHAR(SYSDATE,'MM/YYYY'),'MM/YYYY'),
												 TO_NUMBER(p_MONTHT)/100,
												 TO_NUMBER(p_MONTTTC)/100,
												 p_EMETTEUR,
												 p_cccentrefrais,
												 SYSDATE,
												 SYSDATE,
												 SYSDATE,
												 'AE',
												 '  ',
												 NULL,
												 p_socfour,
												 p_tva,
												 p_codcompta,
												 p_deppole,
												 0,
												 p_soccode,
												 p_cav,
												 p_numcont,
												 p_datfact,
												 '',
												 p_ref_sg,
                                                 p_NUM_CHARG
                                                );

						  RETURN 0;

	  EXCEPTION

			       WHEN DUP_VAL_ON_INDEX THEN
								  ROLLBACK;
								  RETURN 11;


               WHEN OTHERS THEN
								  ROLLBACK;
					RETURN 111;


END insert_facture;




PROCEDURE    insert_ligne_facture(p_MONTHT            IN VARCHAR2,
                                                                         p_codcompta         IN VARCHAR2,
                                                                         p_deppole               IN NUMBER,
																		 p_CDEB                    IN DATE,
                                                                         p_SOCCODE          IN VARCHAR2,
   	                                                                     p_TYPFACT            IN  CHAR,
																		 p_DATFACT            IN DATE,
																		 p_NUMFACT           IN VARCHAR2,
																		 p_tva                          IN NUMBER,
																		 p_ident                      IN NUMBER,
																		 p_num                        IN NUMBER
																		 )   IS


BEGIN




  INSERT INTO LIGNE_FACT(LNUM,
                                                            LMONTHT,
                                                            LCODCOMPTA,
                                                            LDEPPOLE,
															LMOISPREST,
															SOCFACT,
   	                                                        TYPFACT,
															DATFACT,
															NUMFACT,
														    TVA,
															IDENT
                                                          )
                            VALUES(  p_num,
							                    TO_NUMBER(p_MONTHT)/100,
                                                p_codcompta,
                                                p_deppole,
												p_CDEB,
                                                p_SOCCODE,
   	                                            p_TYPFACT,
												p_DATFACT,
												p_NUMFACT,
												p_tva,
												p_ident
                                                );


EXCEPTION

		WHEN DUP_VAL_ON_INDEX THEN

						UPDATE LIGNE_FACT SET LMONTHT= TO_NUMBER(p_MONTHT)/100 ,  LCODCOMPTA=p_codcompta,
                                                                                  LDEPPOLE=p_deppole, LMOISPREST=p_CDEB
						WHERE SOCFACT=p_SOCCODE  AND NUMFACT=p_NUMFACT
						AND TYPFACT=p_TYPFACT AND DATFACT=p_DATFACT
						AND LNUM=p_num;


		WHEN OTHERS THEN
	         ROLLBACK;


END insert_ligne_facture;






PROCEDURE rapprochement_facture (l_socfact     IN FACTURE.socfact%TYPE,
                                                                              l_ident         IN VARCHAR2,
                                                                              l_cdeb     IN DATE
                                                                              ) IS

-- -------------------------------------------------------------------------------
   --  Curseur qui ramène toutes les lignes de facture de la ressource pour le mois
   -- -------------------------------------------------------------------------------
   CURSOR cur_lignefact ( cl_socfact     IN FACTURE.socfact%TYPE,
                          cl_ident       IN VARCHAR2,
                          cl_lmoisprest  IN DATE
                        ) IS
    SELECT fac.socfact, fac.numfact, fac.typfact, fac.datfact, fac.FSTATUT2, fac.faccsec, fac.fregcompta
	FROM LIGNE_FACT lf , FACTURE fac
	WHERE lf.numfact=fac.numfact
	AND   lf.socfact=fac.socfact
	AND   lf.datfact=fac.datfact
	AND   lf.typfact=fac.typfact
	AND   lf.ident=TO_NUMBER(cl_ident,'FM99999')
	AND   lf.lmoisprest=cl_lmoisprest
	AND   lf.socfact    = cl_socfact
	AND   (fac.fmodreglt!=8 OR fac.fmodreglt IS NULL)
	--AND   lf.lcodcompta NOT IN (6350001, 6350002, 6398001)
	GROUP BY fac.socfact, fac.numfact, fac.typfact, fac.datfact, fac.FSTATUT2, fac.faccsec, fac.fregcompta;



	l_statut2             VARCHAR2(2);
	l_faccsec          DATE;
	l_fregcompta   DATE;

BEGIN



    FOR rec_fact IN cur_lignefact (l_socfact, l_ident, l_cdeb)
    LOOP

	       IF( rec_fact.fstatut2 IS NULL OR trim(rec_fact.fstatut2) = '' OR rec_fact.fstatut2 = '  ')THEN
		         l_statut2 := 'AE';
		  ELSE
				l_statut2 := rec_fact.fstatut2;
		  END IF;


		  IF( rec_fact.faccsec IS NULL OR rec_fact.faccsec = '' )THEN
		         l_faccsec := SYSDATE;
		  ELSE
				l_faccsec := rec_fact.faccsec;
		  END IF;


		    IF( rec_fact.fregcompta IS NULL OR rec_fact.fregcompta = '' )THEN
		         l_fregcompta := SYSDATE;
		  ELSE
				l_fregcompta := rec_fact.fregcompta;
		  END IF;

	       UPDATE FACTURE SET fstatut2=l_statut2, faccsec=l_faccsec, fregcompta=l_fregcompta
		                                             WHERE socfact=rec_fact.socfact AND numfact=rec_fact.numfact
													 AND typfact=rec_fact.typfact AND datfact=rec_fact.datfact;

			COMMIT;

           END LOOP;


END;



-- ******************************************************************************
--
--  Verification Rapprochement du Montant de la ligne de facture
--
--  Modif 09/02/00 QHL : test via la table proplus
--
-- ******************************************************************************
PROCEDURE verif_rapprochement (l_socfact     IN FACTURE.socfact%TYPE,
                               l_ident         IN VARCHAR2,
                               l_lmontht       IN VARCHAR2,
                               l_lmoisprest    IN VARCHAR2,
                               b_askGDM        IN VARCHAR2,
                               l_userid        IN VARCHAR2,
                               l_message          OUT VARCHAR2,
                               p_mail             OUT VARCHAR2
                              ) IS

   l_NbJoursTravail	PROPLUS.cusag%TYPE;	-- cumul du nb de jours travaillés
   l_cout_total     PROPLUS.cout%TYPE;   -- Cout total
   l_msg            VARCHAR2(5000);
   l_rapprochement  LIGNE_FACT.lrapprocht%TYPE;
   l_tot_fact		NUMBER(12,2);
   l_montant_mensuel NUMBER(12,2);
   l_liste_fact  	VARCHAR2(5000);
   l_ecart 		    NUMBER(12,2);
   l_rapprocht		VARCHAR2(5000);
   l_mail			VARCHAR2(5000);
   l_ident_gdm		NUMBER(5);
   l_fdeppole    	FACTURE.fdeppole%TYPE;
   l_datedem		DATE;
   l_iddem			DEMANDE_VAL_FACTU.IDDEM%TYPE;
   TYPE Liste_date    IS VARRAY(50) OF DATE;
   TYPE Liste_char1   IS VARRAY(50) OF CHAR(1);
   TYPE Liste_char4   IS VARRAY(50) OF CHAR(4);
   TYPE Liste_char15  IS VARRAY(50) OF CHAR(15);
   TYPE Liste_number2 IS VARRAY(50) OF NUMBER(2);
   TYPE Liste_number3 IS VARRAY(50) OF NUMBER(3);
   t_socfact		Liste_char4  := Liste_char4();  -- Contiendra la liste des sociétés
   t_numfact		Liste_char15 := Liste_char15(); -- Contiendra la liste des numéros de facture
   t_typfact		Liste_char1  := Liste_char1();  -- Contiendra la liste des type de facture
   t_datfact		Liste_date   := Liste_date();   -- Contiendra la liste des dates de facture
   t_lnum			Liste_number2:= Liste_number2();-- Contiendra la liste des numéro de ligne de facture
   t_codcfrais		Liste_number3:= Liste_number3();-- Contiendra la liste des centre de frais
   l_idarpege		VARCHAR2(60);

   -- --------------------------------------------------------------------
   --  Curseur d'extraction du cout et du consomme pour le mois demandé
   -- --------------------------------------------------------------------
   CURSOR cur_coutcons  ( cl_socfact     IN FACTURE.socfact%TYPE,
                          cl_ident       IN VARCHAR2,
                          cl_lmoisprest  IN VARCHAR2
                        ) IS
  	   SELECT   P1.cusag , P1.cout
	   FROM	PROPLUS P1
	   WHERE P1.tires      = TO_NUMBER(cl_ident,'FM99999')
	   AND	P1.SOCIETE    = cl_socfact
	   AND	P1.cdeb       = TO_DATE(cl_lmoisprest,'MM/YYYY')
	   AND (     P1.aist NOT IN ( 'FORMAT','CONGES', 'ABSDIV','MOBILI','PARTIE', 'RTT','RTT   ')
		   OR	P1.aist    IS NULL
		 );

   -- -------------------------------------------------------------------------------
   --  Curseur qui ramène toutes les lignes de facture de la ressource pour le mois
   -- -------------------------------------------------------------------------------
   CURSOR cur_lignefact ( cl_socfact     IN FACTURE.socfact%TYPE,
                          cl_ident       IN VARCHAR2,
                          cl_lmoisprest  IN VARCHAR2
                        ) IS
	SELECT lf.lnum,lf.typfact, lf.numfact, lf.socfact, lf.datfact,DECODE(lf.typfact,'A',-1,1)*lmontht lmontht,
			fac.FDEPPOLE fdeppole, fac.fcentrefrais codcfrais
	FROM LIGNE_FACT lf , FACTURE fac
	WHERE lf.numfact=fac.numfact
	AND   lf.socfact=fac.socfact
	AND   lf.datfact=fac.datfact
	AND   lf.typfact=fac.typfact
	AND   lf.ident=TO_NUMBER(cl_ident,'FM99999')
	AND   lf.lmoisprest=TO_DATE(cl_lmoisprest,'MM/YYYY')
	AND   lf.socfact    = cl_socfact
	AND   (fac.fmodreglt!=8 OR fac.fmodreglt IS NULL)
	--AND   lf.lcodcompta NOT IN (6350001, 6350002, 6398001)
	ORDER BY lf.typfact DESC, lf.numfact
	;


BEGIN

      l_message := '';
	  p_mail := '';
	-----------------------------------------------------------
	-- Calcul du consommé de la ressource pour le mois choisi
	-----------------------------------------------------------
      	l_cout_total := 0;
      	l_NbJoursTravail := 0;
      	FOR ligne_pp IN cur_coutcons (l_socfact, l_ident, l_lmoisprest)
         LOOP
            l_cout_total := l_cout_total + (ligne_pp.cusag * ligne_pp.cout);
            l_NbJoursTravail := l_NbJoursTravail + ligne_pp.cusag ;
      	END LOOP;

	-----------------------------------------------------------
	-- Recherche s'il s'agit d'un forfait au 12 è
	-----------------------------------------------------------
 	SELECT NVL(montant_mensuel,0) INTO l_montant_mensuel
 	FROM SITU_RESS_FULL
 	WHERE ident = l_ident
 	AND   datsitu <= TO_DATE(l_lmoisprest,'MM/YYYY')
 	AND  (datdep > TO_DATE(l_lmoisprest,'MM/YYYY') OR datdep IS NULL ) ;

 	IF l_montant_mensuel > 0 THEN
 		-- Si montant mensuel , positionne le consommé de la ressource à cette valeur
 		l_cout_total := l_montant_mensuel;
 		l_NbJoursTravail := -1 ;
 	END IF;


	----------------------------------------------------------
	-- Calcul du montant facturé pour la ressource et le mois
	----------------------------------------------------------
	l_tot_fact := 0;
	l_liste_fact := '';
	l_fdeppole := 0;
	l_ident_gdm := 0;

	FOR rec_fact IN cur_lignefact (l_socfact, l_ident, l_lmoisprest)
    LOOP
       	l_tot_fact := l_tot_fact + NVL(rec_fact.lmontht,0);
		l_liste_fact := l_liste_fact||' numfact : '||rec_fact.numfact||
				', montant : '||TO_CHAR(rec_fact.lmontht,'FM999999990D00')||'\n ' ;

		-- On ne traitera qu'avec un seul GDM , s'il y a plusieurs DPG impliqués tant pis
		IF (l_fdeppole = 0) THEN
		   l_fdeppole := rec_fact.fdeppole;
		END IF;

		t_socfact.EXTEND;
	   	t_socfact(t_socfact.COUNT) := rec_fact.socfact;
		t_numfact.EXTEND;
	   	t_numfact(t_numfact.COUNT) := rec_fact.numfact;
		t_typfact.EXTEND;
	   	t_typfact(t_typfact.COUNT) := rec_fact.typfact;
		t_datfact.EXTEND;
	   	t_datfact(t_datfact.COUNT) := rec_fact.datfact;
		t_lnum.EXTEND;
	   	t_lnum(t_lnum.COUNT) := rec_fact.lnum;
		t_codcfrais.EXTEND;
	   	t_codcfrais(t_codcfrais.COUNT) := rec_fact.codcfrais;
    END LOOP;

	l_ecart := l_tot_fact - l_cout_total ;
	l_liste_fact:= l_liste_fact||
			' \n Total facture(s): '||TO_CHAR(l_tot_fact,'FM999999990D00')||
			' \n Total consommé: '||TO_CHAR(l_cout_total,'FM999999990D00')||
			' \n Ecart : '||TO_CHAR(l_ecart,'FM999999990D00');

	IF ABS(l_ecart)<1 THEN
		l_rapprocht:='RAPPROCHEMENT JUSTE :  \n ---------------------------------------------- \n ';
	ELSE
		l_rapprocht:='NON RAPPROCHEMENT : \n ------------------------------------------- \n ';
		-- Doit-on faire une demande de validation au GDM ?
		IF (b_askGDM = 'OUI') THEN
		    BEGIN
		        -- Vérifie s'il y a un GDM déclaré
				SELECT s.ident_gdm
				  INTO l_ident_gdm
				  FROM STRUCT_INFO s
				 WHERE s.CODSG = l_fdeppole;

				IF (l_ident_gdm>0) THEN

					-- sauvegarde de la demande
					l_datedem := SYSDATE;
					l_idarpege := l_userid;

					SELECT NVL(MAX(iddem),0)+1 INTO l_iddem FROM DEMANDE_VAL_FACTU;
					FOR i IN 1..(t_socfact.COUNT) LOOP


						INSERT INTO DEMANDE_VAL_FACTU (IDDEM, DATDEM, USERDEM, SOCFACT, NUMFACT, TYPFACT, DATFACT,
						   						   LNUM, ECART, STATUT, DATSTAT, CODCFRAIS, IDENT_GDM, IDENT, LMOISPREST,
						   						   CONSOMMEHT , CUSAG )
				           	   VALUES ( l_iddem, l_datedem, l_idarpege, t_socfact(i), t_numfact(i), t_typfact(i), t_datfact(i),
							                       t_lnum(i), l_ecart, 'A', l_datedem, t_codcfrais(i), l_ident_gdm, TO_NUMBER(l_ident,'FM99999'),TO_DATE(l_lmoisprest,'MM/YYYY'),
							                       l_cout_total, l_NbJoursTravail);
					END LOOP;

				ELSE
					Pack_Global.recuperer_message(20366, '%s1', 'Pas de GDM déclaré pour ce service : demande de validation non sauvegardée.', NULL, l_msg);
					l_message := l_msg||'\n\n';
				END IF;

			EXCEPTION
		        WHEN OTHERS THEN
		            RAISE_APPLICATION_ERROR(-20997,SQLERRM);
			END;
		END IF;
	END IF;

	Pack_Global.recuperer_message(20366, '%s1', l_rapprocht||'Mois de prestation : '||l_lmoisprest||' \n '||l_liste_fact, NULL, l_msg);
	l_message := l_message||l_msg;

	-- Si on a pressé sur le bouton Rapprochement - On fait un Rollback global de tout cela
	IF (b_askGDM = 'NON') THEN
    	RAISE_APPLICATION_ERROR(-20366,l_msg);
	END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN   -- msg Pas de consommé pour le mois demandé
         Pack_Global.recuperer_message(20130, NULL, NULL, NULL, l_msg);
         --RAISE_APPLICATION_ERROR(-20130, l_msg);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20997,SQLERRM);

END verif_rapprochement;


END Pack_Fact_Demat ;
/


