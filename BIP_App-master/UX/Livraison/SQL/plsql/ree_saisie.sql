-- Package appelé par l'écran de saisie du réestimé
-- Outil de gestion du réestimé par ressources
-- 
-- 
-- Modifie le 10/07/2005 par PPR : ajout gestion des absences dans
--                                 f_get_activite_mois
-- Modifie le 26/07/2005 par BAA : Gestion des nombres < de 0
--                                 ajouter le champ date_depart pour recupere
-- 			           le nombre de mois à travailler
-- Modifie le 06/09/2005 par BAA : Ajout des exceptions
-- Modifie le 21/09/2005 par PPR : Ajustement des requetes dans PROPLUS
-- Modifie le 28/09/2005 par PPR : Permet l'initialisation pour les ressources fictives
-- Modifie le 23/11/2005 par PPR : Réduit le nombre de select dans lister_conso_reestime
-- Modifie le 13/01/2006 par PPR : Correction de début d'annéé
-- Modifie le 15/05/2006 par PPR : Correction : replace PID par FACTPID dans une requete sur proplus
-- Modifie le 18/05/2006 par PPR : Correction : Calcul des absences dans f_get_total_activite_annee
-- Modifie le 26/04/2006 par JMA : Ajout du critère date d'arrivée
--                                 Correction sur la date de départ dans 'select_ressource' dans le cas date de départ <
--								   à l'année en cours de traitement
-- Modifie le 23/06/2006 par PPR : Correction : Ajout d'un critere sur datsitu dans la recherche dans situ_ress_full
--                                 (cas du prestataire qui change de société)
-- modifié le 03/10/08 ABA TD 694 : ajout d'un message d'erreur lorsque le code dpg par defaut est erroné nottamment lors du chargement de la liste des scenarios
--*******************************************************************


CREATE OR REPLACE PACKAGE PACK_REE_SAISIE AS

TYPE ress_liste_ViewType IS RECORD ( 	CODE_RESSOURCE     	VARCHAR2(5),
                                    	RESSOURCE     		VARCHAR2(100)
                                     );
TYPE ress_listeCurType IS REF CURSOR RETURN ress_liste_ViewType;
PROCEDURE liste_ress_dpg( 	p_codsg 	IN VARCHAR2,
   							p_userid 	IN VARCHAR2,
   							p_curseur 	IN OUT ress_listeCurType
                             );

TYPE ressource_ViewType IS RECORD ( 	CODE_RESSOURCE     	VARCHAR2(5),
                                    	RESSOURCE     		VARCHAR2(100),
										MOIS 				VARCHAR2(7),
										NBMOIS 				NUMBER,
										KeyList4 			VARCHAR2(60),
										KeyList5 			VARCHAR2(7),
										KeyList6 			VARCHAR2(7),
										TYPE_RESS    		REE_RESSOURCES.TYPE%TYPE,
										date_depart 		NUMBER
										,date_arrivee 		VARCHAR2(10)
										,annee				NUMBER
                                     );
TYPE ressourceCurType IS REF CURSOR RETURN ressource_ViewType;

TYPE jourouvre_ListeViewType IS RECORD (	MOIS     VARCHAR2(2), NB_JOUR  CALENDRIER.CJOURS%TYPE);
TYPE jourouvre_listeCurType IS REF CURSOR RETURN jourouvre_ListeViewType;

PROCEDURE select_ressource(	p_ident	            IN VARCHAR2,
			    			p_userid 	   	    IN VARCHAR2,
		  					p_codsg 			IN VARCHAR2,
		  					p_code_scenario		IN VARCHAR2,
			    			p_curressource 		IN OUT ressourceCurType,
			   				p_nbpages      		OUT VARCHAR2,
                            p_numpage      		OUT VARCHAR2,
							p_menu		   		OUT VARCHAR2,
                            p_nbcurseur    		OUT INTEGER,
                            p_message      		OUT VARCHAR2
							);

FUNCTION f_get_nbjour_ouv_mois ( p_mois IN VARCHAR2	) RETURN NUMBER;

PROCEDURE lister_nb_jour_ouvre( p_curseur  IN OUT jourouvre_listeCurType );

FUNCTION f_get_activite_mois ( p_ident 		    IN NUMBER,
			  			       p_type_ress	    IN VARCHAR2,
			  			       p_mois 	   		IN VARCHAR2,
			  			       p_codsg			IN VARCHAR2,
			  			       p_code_activite	IN VARCHAR2,
                     				p_code_scenario 	IN VARCHAR2,
			  			       p_nbmois			IN NUMBER
							)  return VARCHAR2;

FUNCTION f_get_total_mois ( p_ident 		    IN NUMBER,
			  			    p_type_ress		    IN VARCHAR2,
			  			    p_mois 	   			IN VARCHAR2,
			  			    p_codsg				IN VARCHAR2,
                       		p_code_scenario 	IN VARCHAR2,
			  			    p_nbmois			IN NUMBER
							)  return VARCHAR2;

FUNCTION f_get_total_activite_annee ( p_ident 		    IN NUMBER,
  			    		    		  p_type_ress		IN VARCHAR2,
			  			    		  p_mois 	   		IN VARCHAR2,
			  			    		  p_codsg			IN VARCHAR2,
                       				  p_code_activite 	IN VARCHAR2,
                       				  p_code_scenario 	IN VARCHAR2,
			  			    		  p_nbmois			IN NUMBER,
			  			    		  p_cons_rees		IN VARCHAR2
									)  return VARCHAR2;

FUNCTION f_get_total_annee ( p_ident 		    IN NUMBER,
			  			    p_type_ress		    IN VARCHAR2,
			  			    p_mois 	   			IN VARCHAR2,
			  			    p_codsg				IN VARCHAR2,
                       		p_code_scenario 	IN VARCHAR2,
			  			    p_nbmois			IN NUMBER,
			  			    p_cons_rees			IN VARCHAR2
							)  return VARCHAR2;

-- Majuscule pour javascript qui utilise le nom des colonnes pour l'automates.
TYPE conso_rees_ListeViewType IS RECORD(
				 	CODE_ACTIVITE REE_ACTIVITES.CODE_ACTIVITE%TYPE,
				 	MOIS_1 		  VARCHAR2(9),
					MOIS_2		  VARCHAR2(9),
					MOIS_3 		  VARCHAR2(9),
					MOIS_4 		  VARCHAR2(9),
					MOIS_5 		  VARCHAR2(9),
					MOIS_6 		  VARCHAR2(9),
					MOIS_7		  VARCHAR2(9),
					MOIS_8		  VARCHAR2(9),
					MOIS_9 		  VARCHAR2(9),
					MOIS_10 	  VARCHAR2(9),
					MOIS_11		  VARCHAR2(9),
					MOIS_12		  VARCHAR2(9),
					TOTAL_CONS	  VARCHAR2(9),
					TOTAL_REES	  VARCHAR2(9),
					TOTAL_MOIS_1  VARCHAR2(9),
					TOTAL_MOIS_2  VARCHAR2(9),
					TOTAL_MOIS_3  VARCHAR2(9),
					TOTAL_MOIS_4  VARCHAR2(9),
					TOTAL_MOIS_5  VARCHAR2(9),
					TOTAL_MOIS_6  VARCHAR2(9),
					TOTAL_MOIS_7  VARCHAR2(9),
					TOTAL_MOIS_8  VARCHAR2(9),
					TOTAL_MOIS_9  VARCHAR2(9),
					TOTAL_MOIS_10 VARCHAR2(9),
					TOTAL_MOIS_11 VARCHAR2(9),
					TOTAL_MOIS_12 VARCHAR2(9)
                                         );

TYPE conso_rees_listeCurType IS REF CURSOR RETURN conso_rees_ListeViewType;


PROCEDURE lister_conso_reestime( 	p_ident         IN VARCHAR2,
                              		p_userid   		IN VARCHAR2,
                              		p_codsg    	    IN VARCHAR2,
                              		p_code_scenario IN VARCHAR2,
                              		p_curseur  		IN OUT conso_rees_listeCurType
								);

FUNCTION get_nb_jour_ouvre( p_date IN VARCHAR2 ) RETURN VARCHAR2;

TYPE total_ouvre_ListeViewType IS RECORD(
					TOTAL_MOIS_1     VARCHAR2(9),
					TOTAL_MOIS_2  	 VARCHAR2(9),
					TOTAL_MOIS_3  	 VARCHAR2(9),
					TOTAL_MOIS_4  	 VARCHAR2(9),
					TOTAL_MOIS_5  	 VARCHAR2(9),
					TOTAL_MOIS_6  	 VARCHAR2(9),
					TOTAL_MOIS_7  	 VARCHAR2(9),
					TOTAL_MOIS_8  	 VARCHAR2(9),
					TOTAL_MOIS_9  	 VARCHAR2(9),
					TOTAL_MOIS_10 	 VARCHAR2(9),
					TOTAL_MOIS_11 	 VARCHAR2(9),
					TOTAL_MOIS_12 	 VARCHAR2(9),
					TOTAL_ANNEE_CONS VARCHAR2(9),
					TOTAL_ANNEE_REES VARCHAR2(9),
					TOTAL_OUVRE_1  	 VARCHAR2(9),
					TOTAL_OUVRE_2  	 VARCHAR2(9),
					TOTAL_OUVRE_3  	 VARCHAR2(9),
					TOTAL_OUVRE_4  	 VARCHAR2(9),
					TOTAL_OUVRE_5  	 VARCHAR2(9),
					TOTAL_OUVRE_6  	 VARCHAR2(9),
					TOTAL_OUVRE_7  	 VARCHAR2(9),
					TOTAL_OUVRE_8  	 VARCHAR2(9),
					TOTAL_OUVRE_9  	 VARCHAR2(9),
					TOTAL_OUVRE_10 	 VARCHAR2(9),
					TOTAL_OUVRE_11 	 VARCHAR2(9),
					TOTAL_OUVRE_12 	 VARCHAR2(9)
                                         );

TYPE total_ouvre_listeCurType IS REF CURSOR RETURN total_ouvre_ListeViewType;

PROCEDURE lister_total_ouvre_mois( 	p_ident         IN VARCHAR2,
                              		p_codsg    	    IN VARCHAR2,
                              		p_code_scenario IN VARCHAR2,
                              		p_curseur  		IN OUT total_ouvre_listeCurType
                             	);

PROCEDURE update_rees(	p_chaine	IN  VARCHAR2,
                        p_nbcurseur OUT INTEGER,
                        p_message   OUT VARCHAR2
					 );

TYPE scenarios_ListeViewType IS RECORD(  CODE_ACTIVITE   VARCHAR2(12),
 							   			 LIB_ACTIVITE     VARCHAR2(75)
					  				  );
TYPE scenarios_listeCurType IS REF CURSOR RETURN scenarios_ListeViewType;
PROCEDURE lister_scenarios_dpg( 	p_codsg IN VARCHAR2,
   			 						p_userid 	IN VARCHAR2,
   									p_curseur IN OUT scenarios_listeCurType
                                 );

TYPE activites_ListeViewType IS RECORD( CODE_ACTIVITE   VARCHAR2(12),
  							 			LIB_ACTIVITE    VARCHAR2(60)
					  					);
TYPE activites_listeCurType IS REF CURSOR RETURN activites_ListeViewType;
PROCEDURE lister_activites_dpg(	p_codsg   		 IN VARCHAR2,
   								p_userid  		 IN VARCHAR2,
		  						p_curseur IN OUT activites_listeCurType
                             );

PROCEDURE ajout_activite( p_chaine	IN  VARCHAR2,
                          p_nbcurseur OUT INTEGER,
                          p_message   OUT VARCHAR2
					 	  );


	-- ------------------------------------------------------------------------
    --le type tableau_numerique définit un tableau de NUMBER
    -- ------------------------------------------------------------------------


    TYPE tableau_numerique IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

    TYPE Liste_chaine      is varray(500) of VARCHAR2(200);
	TYPE liste_date        is varray(500) of DATE;


   -- ------------------------------------------------------------------------
   -- Nom        : nb_jours_travail
   -- Auteur     : BAA
   -- Decription : renvoi le nombre de jours de travail pour un mois donner
   --
   -- Paramètres : p_ident  (IN) identifiant de la ressource
   --              p_type   (IN) type de la ressource
   --              p_date  (IN)  La date de travail sous from 01/mm/yyyy
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


     FUNCTION nb_jours_travail(p_ident IN ree_ressources.ident%TYPE,
     						   p_type IN ree_ressources.type%TYPE,
							  p_date IN DATE
				              ) RETURN NUMBER;


   -- ------------------------------------------------------------------------
   -- Nom        : nb_jours_travail_annee
   -- Auteur     : BAA
   -- Decription : renvoi le nombre de jours de travail pour l'anne en cours
   --
   -- Paramètres : p_ident  (IN) identifiant de la ressource
   --              p_type   (IN) type de la ressource
   --              p_moismens  (IN) le moismens de la table datdebex
   --
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


     FUNCTION nb_jours_travail_annee(p_ident IN ree_ressources.ident%TYPE,
     								p_type IN ree_ressources.type%TYPE,
							        p_moismens IN DATE
				                    ) RETURN NUMBER;


   -- ------------------------------------------------------------------------
   -- Nom        : ree_saisie_init_date
   -- Auteur     : BAA
   -- Decription : insere les lignes des consu_prevu pour chaque activite mois
   --
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_scenario  (IN) code du scenario
   --              p_ident  (IN) identifiant de la ressource
   --              p_type   (IN) type de la ressource
   --              p_date  (IN)  La date de travail sous from 01/mm/yyyy
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


     PROCEDURE ree_saisie_init_date(p_codsg 	IN ligne_bip.codsg%TYPE,
				                     p_code_scenario IN ree_scenarios.code_scenario%TYPE,
							         p_ident IN ree_ressources.ident%TYPE,
							         p_type IN ree_ressources.type%TYPE,
									 p_date IN DATE
									 );



   -- ------------------------------------------------------------------------
   -- Nom        : ree_saisie_init_absences
   -- Auteur     : BAA
   -- Decription : insere les lignes des consu_prevu pour de l'activite de l'annee
   --
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_scenario  (IN) code du scenario
   --              p_ident  (IN) identifiant de la ressource
   --              p_type   (IN) type de la ressource
   --              p_moismens  (IN) le moismens de la table datdebex
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


     PROCEDURE ree_saisie_init_absences(p_codsg 	IN ligne_bip.codsg%TYPE,
				                        p_code_scenario IN ree_scenarios.code_scenario%TYPE,
							            p_ident IN ree_ressources.ident%TYPE,
							            p_type IN ree_ressources.type%TYPE,
										p_moismens IN DATE
									    );


   -- ------------------------------------------------------------------------
   -- Nom        : ree_saisie_init_tous
   -- Auteur     : BAA
   -- Decription : insere les lignes des conso_prevu pour chaque activite l'annee en cours
   --              inclus l'activites absences
   --
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_scenario  (IN) code du scenario
   --              p_ident  (IN) identifiant de la ressource
   --              p_type   (IN) type de la ressource
   -- 			   NB_ACTIVITE (IN) le nombre d'activite dans la table ree_ressource_activite
   --              p_moismens  (IN) le moismens de la table datdebex
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


     PROCEDURE ree_saisie_init_tous(p_codsg 	     IN ligne_bip.codsg%TYPE,
				                     p_code_scenario IN ree_scenarios.code_scenario%TYPE,
							         p_ident         IN ree_ressources.ident%TYPE,
							         p_type          IN ree_ressources.type%TYPE,
									 NB_ACTIVITE 	 IN NUMBER,
									 p_moismens 	 IN DATE
									 );



   -- ------------------------------------------------------------------------
   -- Nom        : ree_saisie_initialise
   -- Auteur     : BAA
   -- Decription : c'est la methode major qui insere les lignes des consu_prevu pour chaque activite l'annee en cours
   --              inclus les activites absences si les activites existe
   --              sinon elle insere que des lignes de l'activites absences
   --
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_scenario  (IN) code du scenario
   --              p_ident  (IN) identifiant de la ressource
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------


     PROCEDURE ree_saisie_initialise(p_codsg 	     IN VARCHAR2,
				                     p_code_scenario IN ree_scenarios.code_scenario%TYPE,
							         p_ident         IN VARCHAR2
									 );



-- ------------------------------------------------------------------------
-- Nom        : CalculOuvreAvantArrivee
-- Auteur     : JMA
-- Decription : permet de calculer le nombre de jour ouvré depuis le début du mois d'une date passer en paramètre
--
-- Paramètres : p_date (IN) date par rapport à laquelle le nb de jour ouvré est calculer
--
-- Retour     : number  : nb de jour ouvré avant la date donnée
--
-- ------------------------------------------------------------------------
FUNCTION CalculOuvreAvantArrivee( p_date IN DATE ) RETURN NUMBER;


END PACK_REE_SAISIE;
/


CREATE OR REPLACE PACKAGE BODY     PACK_REE_SAISIE AS

-- ************************************************************************************************
-- Procédure lister_conso_reestime
--
-- Renvoi le nombre de jour consommé et le nb de jour ouvré par mois pour une ressource et un code dpg
--
-- ************************************************************************************************
PROCEDURE lister_conso_reestime( 	p_ident         IN VARCHAR2,
                              		p_userid   		IN VARCHAR2,
                              		p_codsg    	    IN VARCHAR2,
                              		p_code_scenario IN VARCHAR2,
                              		p_curseur  		IN OUT conso_rees_listeCurType
                             	) IS
	l_anneecourante VARCHAR2(4);
	l_datemens 		DATE;
	l_annee 		DATE;
	l_mois_saisie   VARCHAR2(10);
	l_nbmois 		NUMBER(2);
	l_type_ress     REE_RESSOURCES.TYPE%TYPE;
	l_ident 	    REE_RESSOURCES.IDENT%TYPE;
	l_datearrivee	DATE;
BEGIN

-- On récupère le type de la ressource et l'identifiant de la ressource
	l_type_ress := substr(p_ident,length(p_ident),1);
	l_ident := to_number(substr(p_ident,0,length(p_ident)-1));

-- Nb de mois saisissables calculé suivant la date de la prochaine mensuelle
	select to_char(datdebex,'YYYY'), moismens, datdebex
	  into l_anneecourante, l_datemens, l_annee
	  from datdebex;

-- Correction de début d'annéé
	if (l_datemens<l_annee) then
		l_mois_saisie := TO_CHAR(l_annee,'MM/YYYY');
		l_nbmois := 0;
	else
		l_mois_saisie := TO_CHAR(l_datemens,'MM/YYYY');
		l_nbmois := TO_NUMBER(TO_CHAR(l_datemens,'MM'));
	end if ;

-- Correction si date d'arrivée renseignée
    BEGIN
	    select datarrivee into l_datearrivee from ree_ressources
		 where ident = l_ident
		   and type  = l_type_ress
		   and codsg = to_number(p_codsg);

	    if ( l_datearrivee>l_datemens ) then
		    if (l_nbmois < TO_NUMBER(TO_CHAR(l_datearrivee,'MM')) ) then
			    l_nbmois := TO_NUMBER(TO_CHAR(l_datearrivee,'MM'))-1;
			end if;
		end if;
	EXCEPTION
	    WHEN OTHERS THEN
			null;
	END;

-- Si la ressource n'est pas de type sous-traitance (cas normal)
	if (l_type_ress != 'S') then
	  	OPEN p_curseur FOR
-- On sélectionne le réestimé et le consomme
		select r.CODE_ACTIVITE CODE_ACTIVITE,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '01/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_1,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '02/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_2,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '03/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_3,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '04/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_4,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '05/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_5,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '06/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_6,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '07/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_7,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '08/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_8,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '09/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_9,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '10/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_10,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '11/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_11,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '12/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_12,
			   PACK_REE_SAISIE.f_get_total_activite_annee(l_ident, l_type_ress, l_mois_saisie, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois, 'C') TOTAL_CONS,
			   PACK_REE_SAISIE.f_get_total_activite_annee(l_ident, l_type_ress, l_mois_saisie, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois, 'R') TOTAL_RESS,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '01/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_1,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '02/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_2,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '03/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_3,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '04/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_4,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '05/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_5,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '06/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_6,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '07/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_7,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '08/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_8,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '09/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_9,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '10/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_10,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '11/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_11,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '12/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_12
		  from REE_ACTIVITES r
		 where r.CODE_ACTIVITE in (
		                             -- Activités pour lesquelles il y a du réestimé pour cette ressource
		 							 select distinct(rr.CODE_ACTIVITE)
									  from REE_REESTIME rr
								     where rr.IDENT = l_ident
								       and rr.TYPE = l_type_ress
								   	   and rr.CODSG = to_number(p_codsg)
									   and rr.CODE_SCENARIO = p_code_scenario
									 union
									 -- Activités pour lesquelles il y a du consommé pour cette ressource
									 select distinct(ra.CODE_ACTIVITE)
									  from REE_ACTIVITES_LIGNE_BIP ra, PROPLUS p
								     where ra.PID = p.FACTPID
								       and p.tires = l_ident
								   	   and ra.CODSG = to_number(p_codsg)
								   	   and p.cdeb >= l_annee
								   	 union
								   	 -- Sous traitance fournie
								   	 select 'SST FOURNIE' from dual
								   	 union
								   	 -- Absences
								   	 select 'ABSENCES' from dual
									 )
	   	   and r.CODSG = to_number(p_codsg)
 		 order by 1;
	else
-- si la ressource est une sous-traitance
	  	OPEN p_curseur FOR
		select r.CODE_ACTIVITE CODE_ACTIVITE,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '01/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_1,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '02/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_2,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '03/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_3,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '04/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_4,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '05/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_5,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '06/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_6,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '07/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_7,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '08/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_8,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '09/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_9,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '10/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_10,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '11/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_11,
			   PACK_REE_SAISIE.f_get_activite_mois(l_ident, l_type_ress, '12/'||l_anneecourante, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois) CONSO_12,
			   PACK_REE_SAISIE.f_get_total_activite_annee(l_ident, l_type_ress, l_mois_saisie, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois, 'C') TOTAL_CONS,
			   PACK_REE_SAISIE.f_get_total_activite_annee(l_ident, l_type_ress, l_mois_saisie, r.CODSG, r.CODE_ACTIVITE, p_code_scenario, l_nbmois, 'R') TOTAL_RESS,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '01/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_1,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '02/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_2,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '03/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_3,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '04/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_4,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '05/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_5,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '06/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_6,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '07/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_7,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '08/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_8,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '09/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_9,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '10/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_10,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '11/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_11,
			   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '12/'||l_anneecourante, r.CODSG, p_code_scenario, l_nbmois) TOTAL_MOIS_12
		  from REE_ACTIVITES r
		 where r.CODE_ACTIVITE in (
		 		                     -- Activités pour lesquelles il y a du réestimé pour cette ressource de sous-traitance
									 select distinct(rr.CODE_ACTIVITE)
									  from REE_REESTIME rr
								     where rr.IDENT = l_ident
								       and rr.TYPE = l_type_ress
								   	   and rr.CODSG = to_number(p_codsg)
									   and rr.CODE_SCENARIO = p_code_scenario
									union
									 -- Activités pour lesquelles il y a du consommé en sous-traitance
									select distinct(rr.CODE_ACTIVITE)
									  from REE_ACTIVITES_LIGNE_BIP rr, PROPLUS p
								     where p.FACTPID  = rr.PID
									   and p.FACTPDSG = rr.CODSG
								   	   and rr.CODSG = to_number(p_codsg)
								   	   and p.cdeb >= l_annee
									   and not exists ( select 1 from REE_RESSOURCES ress
							                                 where ress.codsg = to_number(p_codsg)
							                                   and ress.ident = p.tires
							                                   and ress.type <> 'X' )
									   )
	   	   and r.CODSG = to_number(p_codsg)
		 order by 1;
	end if;

END lister_conso_reestime;


--*************************************************************************************************
-- Procédure liste_ress_dpg
--
-- Sélectionne les liste des ressources disponible pour un DPG donné
--
-- ************************************************************************************************
PROCEDURE liste_ress_dpg( 	p_codsg 	IN VARCHAR2,
   							p_userid 	IN VARCHAR2,
   							p_curseur 	IN OUT ress_listeCurType
                             ) IS
	l_msg VARCHAR2(1024);
	l_codsg NUMBER;

BEGIN

	If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
	    pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
         
        --raise_application_error(-20203,l_msg);
    ELSE
        IF ( pack_habilitation.fhabili_me(p_codsg, p_userid) = 'faux' ) THEN
		    pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
			raise_application_error(-20364,l_msg);
        ELSE
			BEGIN
	        	OPEN p_curseur FOR
	              	SELECT ident||type code, rnom || ' ' || rprenom|| ' - ' ||type||' ' ||ident LIB_RESSß
	              	  FROM ree_ressources
	              	 WHERE codsg = TO_NUMBER(p_codsg)
	              	 ORDER by type,rnom,rprenom;
     		EXCEPTION
			    WHEN No_Data_Found THEN
                 BEGIN
				      l_msg := 'Veuillez selectionner une ressource';
				      raise_application_error(-20203,l_msg);
			     END;
		        WHEN OTHERS THEN
         		    raise_application_error( -20997, SQLERRM);
            END;
        END IF;
    END IF;
END liste_ress_dpg;


--*************************************************************************************************
-- Procédure select_ressource
--
-- Permet de récupérer des infos sur une ressource donnée
--
-- ************************************************************************************************
PROCEDURE select_ressource(	p_ident             IN VARCHAR2,
		  					p_userid 			IN VARCHAR2,
		  					p_codsg 			IN VARCHAR2,
		  					p_code_scenario		IN VARCHAR2,
							p_curressource 		IN OUT ressourceCurType,
			    			p_nbpages       	OUT VARCHAR2,
                            p_numpage       	OUT VARCHAR2,
							p_menu				OUT VARCHAR2,
                            p_nbcurseur     	OUT INTEGER,
                            p_message       	OUT VARCHAR2
							) IS
	l_count_rees NUMBER(3);
	l_count_cons NUMBER(3);
	l_count NUMBER(3);
	l_msg VARCHAR2(500);
	l_cpp_ident REE_RESSOURCES.ident%TYPE;
	l_datemens DATE;
	l_annee DATE;
	l_mois_saisie VARCHAR2(10);
	l_nbmois NUMBER(2);
	l_nbpages  NUMBER(5);
	l_menu VARCHAR2(25);

	l_ident 	    REE_RESSOURCES.IDENT%TYPE;
	l_type_ress REE_RESSOURCES.type%TYPE;
BEGIN

	 p_numpage := 'NumPage#1';

-- Nb de mois saisissables calculé suivant la date de la prochaine mensuelle
	select moismens, datdebex
	  into l_datemens, l_annee
	  from datdebex;


-- On récupère le type de la ressource

   BEGIN
	select type
	  into l_type_ress
	  from REE_RESSOURCES r
	 where to_char(r.ident)||type = p_ident
	   and r.CODSG = to_number(p_codsg);
  EXCEPTION
   WHEN No_Data_Found THEN
        l_msg := 'Veuillez selectionner une ressource';
	    raise_application_error(-20203,l_msg);
    END;

-- On récupère l'identifiant de la ressource
	l_ident := to_number(substr(p_ident,0,length(p_ident)-1));

-- Compter le nombre d'activité dans le réestimé pour la ressource

  BEGIN
   select count(distinct(r.code_activite))
	  into l_count_rees
	  from REE_REESTIME r
	 where r.ident = l_ident
	   and r.type = l_type_ress
	   and r.CODSG = to_number(p_codsg)
	   and r.CODE_SCENARIO = p_code_scenario ;

   EXCEPTION
   WHEN No_Data_Found THEN
        l_msg := 'Veuillez selectionner un scénario';
	    raise_application_error(-20203,l_msg);
    END;

-- Compter le nombre d'activité dans le consommé pour la ressource
-- On ne prend pas en compte le scénario car il est uniquement utilisé pour le réestimé
	select count(distinct(r.code_activite))
	  into l_count_cons
	  from REE_ACTIVITES_LIGNE_BIP r, PROPLUS p
	 where p.FACTPID  = r.PID
	   and p.FACTPDSG = r.CODSG
	   and r.CODSG = to_number(p_codsg)
	   and p.cdeb >= l_annee
	   and ( (l_type_ress<>'S' and p.TIRES = l_ident )
	         or
			 (l_type_ress='S' and not exists ( select 1 from REE_RESSOURCES ress
                                                where ress.codsg = to_number(p_codsg)
                                                  and ress.ident = p.tires
                                                  and ress.type <> 'X' )
			 )
		   );


	l_count := l_count_rees;
	if (l_count < l_count_cons) then
	   l_count := l_count_cons;
	end if;

	l_nbpages := CEIL(l_count/10);
	if (l_nbpages=0) then
	    l_nbpages := 1;
	end if;
	p_nbpages := 'NbPages#'|| l_nbpages;

-- nom du menu courant
	l_menu := pack_global.lire_globaldata(p_userid).menutil;
	p_menu := 'Menu#'||l_menu;

-- Correction de début d'année
	if (l_datemens<l_annee) then
		l_mois_saisie := TO_CHAR(l_annee,'MM/YYYY');
		l_nbmois := 0;
	else
		l_mois_saisie := TO_CHAR(l_datemens,'MM/YYYY');
		l_nbmois := TO_NUMBER(TO_CHAR(l_datemens,'MM'));
	end if ;


	OPEN p_curressource  FOR
       	SELECT ident||type ident, rnom || ' ' || rprenom|| ' - ' ||type||' ' ||ident ressource,
			   l_mois_saisie  MOIS,
			   l_nbmois  NBMOIS,
			   RNOM||' '||RPRENOM KeyList4,
			   l_mois_saisie  KeyList5,
			   to_char(l_count) KeyList6,
			   type type_ress,
--			   DECODE(to_char(datdep,'yyyy'),to_char(l_annee,'yyyy'),DECODE(to_char(datdep,'dd'),'01',to_char(datdep,'mm'),(extract(MONTH FROM datdep)+1)),13)
			   TO_CHAR(datdep,'DD/MM/YYYY') datdep,
			   TO_CHAR(datarrivee,'DD/MM/YYYY') datarrivee,
			   to_number(to_char(l_annee,'yyyy')) annee
		 FROM ree_ressources
	     WHERE ident = l_ident
	     AND   type  = l_type_ress
		 AND   codsg = p_codsg;

END select_ressource;


--*************************************************************************************************
-- Procédure f_get_nbjour_ouv_mois
--
-- Renvoi le nombre de jour ouvré pour un mois donné
--
-- ************************************************************************************************
FUNCTION f_get_nbjour_ouv_mois ( p_mois IN VARCHAR2	) RETURN NUMBER IS
	l_nbjour NUMBER;
BEGIN
	select cjours
	  into l_nbjour
	  from calendrier
	 where to_char(calanmois,'MM/YYYY') = p_mois;

	return l_nbjour ;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Return 0;
END f_get_nbjour_ouv_mois;


--*************************************************************************************************
-- Procédure f_get_activite_mois
--
-- Renvoi le nombre de jour consommé pour une ressource, une activité et un mois donnés
--
-- ************************************************************************************************
FUNCTION f_get_activite_mois ( p_ident 		    IN NUMBER,
			  			       p_type_ress	    IN VARCHAR2,
			  			       p_mois   		IN VARCHAR2,
			  			       p_codsg			IN VARCHAR2,
			  			       p_code_activite	IN VARCHAR2,
                       		   p_code_scenario 	IN VARCHAR2,
			  			       p_nbmois			IN NUMBER
							)  return VARCHAR2  IS
    l_total NUMBER;
BEGIN
-- si on est dans un mois consommé
	if (p_nbmois >= TO_NUMBER(SUBSTR(p_mois,1,2))) then
	   -- Ressource de type Sous-traitance reçue
	    if (p_type_ress = 'S') then
			select nvl(sum(p.cusag),0)
			  into l_total
			  from REE_ACTIVITES_LIGNE_BIP r, PROPLUS p
		     where p.FACTPID = r.PID
			   and p.FACTPDSG = r.CODSG
		   	   and r.CODSG = to_number(p_codsg)
			   and r.CODE_ACTIVITE = p_code_activite
		   	   and to_char(p.cdeb,'MM/YYYY') = p_mois
			   and not exists ( select 1 from REE_RESSOURCES ress
                                 where ress.codsg = to_number(p_codsg)
                                   and ress.ident = p.tires
                                   and ress.type <> 'X' )
		  group by r.CODE_ACTIVITE;
	    else
			-- Cas particulier pour la sous-traitance
			if (p_code_activite='SST FOURNIE') then
			    -- Activité uniquement pour les personnes de type P ou F
			    if (p_type_ress = 'P' or p_type_ress = 'F') then
					select nvl(sum(p.cusag),0)
					  into l_total
					  from PROPLUS P
					 where P.TIRES = p_ident
					   and P.PTYPE<>7
				   	   and to_char(p.cdeb,'MM/YYYY') = p_mois
					   and not exists ( select 1
					   	   	   		  	  from REE_ACTIVITES_LIGNE_BIP r
										 where r.codsg = to_number(p_codsg)
										   and r.pid   = P.FACTPID);
				else
					l_total := 0;
				end if;
			-- Cas particulier pour les absences
			elsif (p_code_activite='ABSENCES') then
			    -- Activité uniquement pour les personnes de type P ou F
			    if (p_type_ress = 'P' or p_type_ress = 'F') then
					select nvl(sum(p.cusag),0)
					  into l_total
					  from PROPLUS P
					 where P.TIRES = p_ident
					   and P.PTYPE=7
				   	   and to_char(p.cdeb,'MM/YYYY') = p_mois ;
				else
					l_total := 0;
				end if;
			-- Pour les autres activités
			else
				select nvl(sum(p.cusag),0)
				  into l_total
				  from REE_ACTIVITES_LIGNE_BIP r, PROPLUS p
			     where p.FACTPID = r.PID
			       and p.tires = p_ident
			   	   and r.CODSG = to_number(p_codsg)
				   and r.CODE_ACTIVITE = p_code_activite
			   	   and to_char(p.cdeb,'MM/YYYY') = p_mois
			  group by r.CODE_ACTIVITE;
			end if;
	    end if;
	else
-- sinon on prend le réestimé
		select nvl(conso_prevu,0)
		  into l_total
		  from REE_REESTIME r
	     where r.IDENT = p_ident
	       and r.type = p_type_ress
	   	   and r.CODSG = to_number(p_codsg)
		   and r.CODE_ACTIVITE = p_code_activite
		   and r.CODE_SCENARIO = p_code_scenario
	   	   and to_char(r.CDEB,'MM/YYYY') = p_mois;
	end if;

	if (l_total<1 and l_total>0) then
	      return to_char(l_total,'FM999990D99');
    else
		return to_char(l_total);
    end if;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Return '0';

END f_get_activite_mois;

--*************************************************************************************************
-- Procédure f_get_total_mois
--
-- Renvoi le nombre de jour consommé ou le réestimé pour une ressource et un mois donné
--
-- ************************************************************************************************
FUNCTION f_get_total_mois ( p_ident 		    IN NUMBER,
			  			    p_type_ress		    IN VARCHAR2,
			  			    p_mois 	   			IN VARCHAR2,
			  			    p_codsg				IN VARCHAR2,
                       		p_code_scenario 	IN VARCHAR2,
			  			    p_nbmois			IN NUMBER
							)  return VARCHAR2  IS
    l_total  NUMBER;
    l_total2 NUMBER;
BEGIN
-- si on est dans un mois consommé
	if (p_nbmois >= TO_NUMBER(SUBSTR(p_mois,1,2))) then
	    if (p_type_ress='S') then
			select nvl(sum(p.cusag),0)
			  into l_total
			  from REE_ACTIVITES_LIGNE_BIP r, PROPLUS p
		     where p.FACTPID  = r.PID
			   and p.FACTPDSG = r.CODSG
		   	   and r.CODSG = to_number(p_codsg)
		   	   and to_char(p.cdeb,'MM/YYYY') = p_mois
			   and not exists ( select 1 from REE_RESSOURCES ress
                                 where ress.codsg = to_number(p_codsg)
                                   and ress.ident = p.tires
                                   and ress.type <> 'X' );
		else
			select nvl(sum(p.cusag),0)
			  into l_total
			  from REE_ACTIVITES_LIGNE_BIP r, PROPLUS p
		     where p.FACTPID = r.PID
		       and p.tires = p_ident
		   	   and r.CODSG = to_number(p_codsg)
		   	   and to_char(p.cdeb,'MM/YYYY') = p_mois;

			-- Cas particulier pour la sous-traitance : Activité uniquement pour les personnes de type P ou F
			if (p_type_ress = 'P' or p_type_ress = 'F') then
				select nvl(sum(p.cusag),0)
				  into l_total2
				  from PROPLUS P
				 where P.TIRES = p_ident
				 --  and P.PTYPE<>7
		   	   	   and to_char(p.cdeb,'MM/YYYY') = p_mois
				   and not exists ( select 1
				   	   	   		  	  from REE_ACTIVITES_LIGNE_BIP r
									 where r.codsg = to_number(p_codsg)
									   and r.pid   = P.FACTPID);
				l_total := l_total + l_total2;
			end if;
		end if;
	else
-- sinon on prend le réestimé
		select nvl(sum(r.conso_prevu),0)
		  into l_total
		  from REE_REESTIME r
	     where r.IDENT = p_ident
	       and r.type = p_type_ress
	   	   and r.CODSG = to_number(p_codsg)
		   and r.CODE_SCENARIO = p_code_scenario
	   	   and to_char(r.CDEB,'MM/YYYY') = p_mois;
	end if;

   if (l_total<1 and l_total>0) then
    	return to_char(l_total,'FM999990D99');
	else
		return to_char(l_total);
	end if;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Return '0';

END f_get_total_mois;

--*************************************************************************************************
-- Procédure f_get_total_activite_annee
--
-- Renvoi le nombre de jour consommé pour une ressource, une activité et une année donnés
--
-- ************************************************************************************************
FUNCTION f_get_total_activite_annee ( p_ident 		    IN NUMBER,
			  			    		  p_type_ress		IN VARCHAR2,
			  			    		  p_mois 	   		IN VARCHAR2,
			  			    		  p_codsg			IN VARCHAR2,
                       				  p_code_activite	IN VARCHAR2,
                       				  p_code_scenario 	IN VARCHAR2,
			  			    		  p_nbmois			IN NUMBER,
			  			    		  p_cons_rees		IN VARCHAR2
									)  return VARCHAR2 IS
    l_total   NUMBER;
	l_datdep  DATE;
	l_annee   DATE;

BEGIN


   SELECT datdep INTO l_datdep
	       FROM ree_ressources
		   where IDENT = p_ident
		   and TYPE = p_type_ress
	   	   and CODSG = to_number(p_codsg);

	SELECT datdebex INTO l_annee
	       FROM datdebex;

-- si on veut le total du consomme
	if (p_cons_rees = 'C') then
		if (p_type_ress = 'S') then
			select nvl(sum(p.cusag),0)
			  into l_total
			  from REE_ACTIVITES_LIGNE_BIP r, PROPLUS p
		     where p.FACTPID  = r.PID
			   and p.FACTPDSG = r.CODSG
		   	   and r.CODSG = to_number(p_codsg)
			   and r.CODE_ACTIVITE = p_code_activite
		   	   and to_char(p.cdeb,'YYYY') = substr(p_mois,4)
		   	   and to_number(to_char(p.cdeb,'MM')) <= to_number(substr(p_mois,1,2))
			   and not exists ( select 1 from REE_RESSOURCES ress
                                 where ress.codsg = to_number(p_codsg)
                                   and ress.ident = p.tires
                                   and ress.type <> 'X' )
		  group by r.CODE_ACTIVITE;
		else
			-- Cas particulier pour la sous-traitance
			if (p_code_activite='SST FOURNIE') then
			    -- Activité uniquement pour les personnes de type P ou F
			    if (p_type_ress = 'P' or p_type_ress = 'F') then
					select nvl(sum(p.cusag),0)
					  into l_total
					  from PROPLUS P
					 where P.TIRES = p_ident
					   and P.PTYPE<>7
			   	   	   and to_char(p.cdeb,'YYYY') = substr(p_mois,4)
			   	   	   and to_number(to_char(p.cdeb,'MM')) <= to_number(substr(p_mois,1,2))
					   and not exists ( select 1
					   	   	   		  	  from REE_ACTIVITES_LIGNE_BIP r
										 where r.codsg = to_number(p_codsg)
										   and r.pid   = P.FACTPID);
				else
					l_total := 0;
				end if;

			else
				-- Cas particulier des absences
				if (p_code_activite='ABSENCES') then
				    if (p_type_ress = 'P' or p_type_ress = 'F') then
						select nvl(sum(p.cusag),0)
						  into l_total
						  from PROPLUS P
						 where P.TIRES = p_ident
						   and P.PTYPE=7
					   	   and to_char(p.cdeb,'YYYY') = substr(p_mois,4)
   	   			   	   	   and to_number(to_char(p.cdeb,'MM')) <= to_number(substr(p_mois,1,2)) ;
					else
						l_total := 0;
					end if;
				else
					-- Pour les autres activités
						select nvl(sum(p.cusag),0)
						  into l_total
						  from REE_ACTIVITES_LIGNE_BIP r, PROPLUS p
					     where p.FACTPID = r.PID
					       and p.tires = p_ident
					   	   and r.CODSG = to_number(p_codsg)
						   and r.CODE_ACTIVITE = p_code_activite
					   	   and to_char(p.cdeb,'YYYY') = substr(p_mois,4)
					   	   and to_number(to_char(p.cdeb,'MM')) <= to_number(substr(p_mois,1,2))
					  group by r.CODE_ACTIVITE;
				end if ;
			end if;
	    end if;
	end if;
-- si on veut le total du réestimé
	if (p_cons_rees = 'R') then
		select nvl(sum(conso_prevu),0)
		  into l_total
		  from REE_REESTIME r
	     where r.IDENT = p_ident
	       and r.type = p_type_ress
	   	   and r.CODSG = to_number(p_codsg)
		   and r.CODE_ACTIVITE = p_code_activite
		   and r.CODE_SCENARIO = p_code_scenario
	   	   and to_char(r.cdeb,'YYYY') = substr(p_mois,4)
	   	   and to_number(to_char(r.cdeb,'MM')) > to_number(substr(p_mois,1,2))
		   and to_number(to_char(r.cdeb,'MM')) < to_number(DECODE(to_char(l_datdep,'yyyy'),to_char(l_annee,'yyyy'),DECODE(to_char(l_datdep,'dd'),'01',to_char(l_datdep,'mm'),(extract(MONTH FROM l_datdep)+1)),13));

	end if;

	if (l_total<1 and l_total>0) then
		return to_char(l_total,'FM9990D99');
	else
		return to_char(l_total);
	end if;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Return '0';

END f_get_total_activite_annee;


--*************************************************************************************************
-- Procédure f_get_total_annee
--
-- Renvoi le nombre de jour consommé pour une ressource, une activité et une année donnés
--
-- ************************************************************************************************
FUNCTION f_get_total_annee (p_ident 		    IN NUMBER,
			  			    p_type_ress		    IN VARCHAR2,
			  			    p_mois 	   			IN VARCHAR2,
			  			    p_codsg				IN VARCHAR2,
                       		p_code_scenario 	IN VARCHAR2,
			  			    p_nbmois			IN NUMBER,
			  			    p_cons_rees			IN VARCHAR2
							)  return VARCHAR2 IS
    l_total  NUMBER;
    l_total2 NUMBER;
    l_total3 NUMBER;
	l_datdep DATE;
	l_annee  DATE;

BEGIN

    SELECT datdep INTO l_datdep
	       FROM ree_ressources
		   where IDENT = p_ident
		   and TYPE = p_type_ress
	   	   and CODSG = to_number(p_codsg);

	SELECT datdebex INTO l_annee
	       FROM datdebex;


-- si on veut le total du consomme
	if (p_cons_rees = 'C') then
	    if (p_type_ress = 'S') then
			select nvl(sum(p.cusag),0)
			  into l_total
			  from REE_ACTIVITES_LIGNE_BIP r, PROPLUS p
		     where p.FACTPID  = r.PID
			   and p.FACTPDSG = r.CODSG
		   	   and r.CODSG = to_number(p_codsg)
		   	   and to_char(p.cdeb,'YYYY') = substr(p_mois,4)
		   	   and to_number(to_char(p.cdeb,'MM')) <= p_nbmois
			   and not exists ( select 1 from REE_RESSOURCES ress
                                 where ress.codsg = to_number(p_codsg)
                                   and ress.ident = p.tires
                                   and ress.type <> 'X' );
		else
			select nvl(sum(p.cusag),0)
			  into l_total
			  from REE_ACTIVITES_LIGNE_BIP r, PROPLUS p
		     where p.FACTPID = r.PID
		       and p.tires = p_ident
		   	   and r.CODSG = to_number(p_codsg)
		   	   and to_char(p.cdeb,'YYYY') = substr(p_mois,4)
		   	   and to_number(to_char(p.cdeb,'MM')) <= p_nbmois;

			-- Cas particulier pour la sous-traitance : Activité uniquement pour les personnes de type P ou F
			if (p_type_ress = 'P' or p_type_ress = 'F') then
				select nvl(sum(p.cusag),0)
				  into l_total2
				  from PROPLUS P
				 where P.TIRES = p_ident
				   and P.PTYPE<>7
		   	   	   and to_char(p.cdeb,'YYYY') = substr(p_mois,4)
		   	   	   and to_number(to_char(p.cdeb,'MM')) <= p_nbmois
				   and not exists ( select 1
				   	   	   		  	  from REE_ACTIVITES_LIGNE_BIP r
									 where r.codsg = to_number(p_codsg)
									   and r.pid   = P.FACTPID);
				-- Cas particulier pour les absences
				select nvl(sum(p.cusag),0)
				  into l_total3
				  from PROPLUS P
				 where P.TIRES = p_ident
				   and P.PTYPE=7
			   	   and to_char(p.cdeb,'YYYY') = substr(p_mois,4)
		   	   	   and to_number(to_char(p.cdeb,'MM')) <= p_nbmois ;

				l_total := l_total + l_total2+ l_total3;
			end if;
		end if;
	end if;
-- si on veut le total du réestimé
	if (p_cons_rees = 'R') then
		select nvl(sum(conso_prevu),0)
		  into l_total
		  from REE_REESTIME r
	     where r.IDENT = p_ident
	       and r.TYPE = p_type_ress
	   	   and r.CODSG = to_number(p_codsg)
		   and r.CODE_SCENARIO = p_code_scenario
	   	   and to_char(r.cdeb,'YYYY') = substr(p_mois,4)
	   	   and to_number(to_char(r.cdeb,'MM')) > p_nbmois
		   and to_number(to_char(r.cdeb,'MM')) < to_number(DECODE(to_char(l_datdep,'yyyy'),to_char(l_annee,'yyyy'),DECODE(to_char(l_datdep,'dd'),'01',to_char(l_datdep,'mm'),(extract(MONTH FROM l_datdep)+1)),13));


	end if;

	if (l_total<1 and l_total>0) then
		return to_char(l_total,'FM9990D99');
	else
		return to_char(l_total);
	end if;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Return '0';

END f_get_total_annee;



-- ************************************************************************************************
-- Procédure lister_nb_jour_ouvre
--
-- Renvoi le nombre de jour ouvré par mois pour une année
--
-- ************************************************************************************************
PROCEDURE lister_nb_jour_ouvre( p_curseur  IN OUT jourouvre_listeCurType ) IS
	l_anneecourante VARCHAR2(4);
	l_annee date;
BEGIN
	select to_char(datdebex,'YYYY'), datdebex
	  into l_anneecourante, l_annee
	  from datdebex;

  	OPEN p_curseur FOR
	  select to_char(c.CALANMOIS, 'MM') MOIS, c.CJOURS NB_JOUR
	    from CALENDRIER c
	   where to_char(c.CALANMOIS, 'YYYY') = '2004'
	order by c.CALANMOIS;

END lister_nb_jour_ouvre;


-- ************************************************************************************************
-- Procédure get_nb_jour_ouvre
--
-- Renvoi le nombre de jour ouvré par mois pour une année
--
-- ************************************************************************************************
FUNCTION get_nb_jour_ouvre( p_date IN VARCHAR2 ) RETURN VARCHAR2 IS
	l_nbjour NUMBER;
BEGIN
    select c.CJOURS NB_JOUR
	  into l_nbjour
	  from CALENDRIER c
	 where to_char(c.CALANMOIS, 'MM/YYYY') = p_date;

    return to_char(l_nbjour );

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		Return '0';


END get_nb_jour_ouvre;

-- ************************************************************************************************
-- Procédure lister_total_ouvre_mois
--
-- Renvoi le total de consommée/réestimé et de jour ouvré par mois pour une ressource, un code dpg, et un scénario
--
-- ************************************************************************************************
PROCEDURE lister_total_ouvre_mois( 	p_ident         IN VARCHAR2,
                              		p_codsg    	    IN VARCHAR2,
                              		p_code_scenario IN VARCHAR2,
                              		p_curseur  		IN OUT total_ouvre_listeCurType
                             	) IS
	l_anneecourante VARCHAR2(4);
	l_datemens 		DATE;
	l_annee 		DATE;
	l_mois_saisie   VARCHAR2(10);
	l_nbmois 		NUMBER(2);
	l_ident 	    REE_RESSOURCES.IDENT%TYPE;
	l_type_ress 	REE_RESSOURCES.type%TYPE;
	l_datearrivee	DATE;

BEGIN

-- On récupère le type de la ressource et l'identifiant de la ressource
	l_type_ress := substr(p_ident,length(p_ident),1);
	l_ident := to_number(substr(p_ident,0,length(p_ident)-1));

-- Nb de mois saisissables calculé suivant la date de la prochaine mensuelle
	select to_char(datdebex,'YYYY'), moismens, datdebex
	  into l_anneecourante, l_datemens, l_annee
	  from datdebex;

-- Correction de début d'année
	if (l_datemens<l_annee) then
		l_mois_saisie := TO_CHAR(l_annee,'MM/YYYY');
		l_nbmois := 0;
	else
		l_mois_saisie := TO_CHAR(l_datemens,'MM/YYYY');
		l_nbmois := TO_NUMBER(TO_CHAR(l_datemens,'MM'));
	end if ;

-- Correction si date d'arrivée renseignée
    BEGIN
	    select datarrivee into l_datearrivee from ree_ressources
		 where ident = l_ident
		   and type  = l_type_ress
		   and codsg = to_number(p_codsg);

	    if ( l_datearrivee>l_datemens ) then
		    if (l_nbmois < TO_NUMBER(TO_CHAR(l_datearrivee,'MM')) ) then
			    l_nbmois := TO_NUMBER(TO_CHAR(l_datearrivee,'MM'))-1;
			end if;
		end if;
	EXCEPTION
	    WHEN OTHERS THEN
			null;
	END;

-- On enlève un mois par rapport à la prochaine mensuelle pour connaitre le dernier mois saisi

  	OPEN p_curseur FOR
	select PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '01/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_1,
		   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '02/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_2,
		   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '03/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_3,
		   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '04/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_4,
		   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '05/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_5,
		   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '06/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_6,
		   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '07/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_7,
		   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '08/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_8,
		   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '09/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_9,
		   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '10/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_10,
		   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '11/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_11,
		   PACK_REE_SAISIE.f_get_total_mois(l_ident, l_type_ress, '12/'||l_anneecourante, p_codsg, p_code_scenario, l_nbmois) TOTAL_MOIS_12,
		   PACK_REE_SAISIE.f_get_total_annee(l_ident, l_type_ress, '01/'||l_anneecourante, p_codsg,p_code_scenario, l_nbmois, 'C') TOTAL_ANNEE_CONS,
		   PACK_REE_SAISIE.f_get_total_annee(l_ident, l_type_ress, '01/'||l_anneecourante, p_codsg,p_code_scenario, l_nbmois, 'R') TOTAL_ANNEE_REES,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('01/'||l_anneecourante) NB_OUVRE_1,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('02/'||l_anneecourante) NB_OUVRE_2,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('03/'||l_anneecourante) NB_OUVRE_3,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('04/'||l_anneecourante) NB_OUVRE_4,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('05/'||l_anneecourante) NB_OUVRE_5,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('06/'||l_anneecourante) NB_OUVRE_6,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('07/'||l_anneecourante) NB_OUVRE_7,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('08/'||l_anneecourante) NB_OUVRE_8,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('09/'||l_anneecourante) NB_OUVRE_9,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('10/'||l_anneecourante) NB_OUVRE_10,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('11/'||l_anneecourante) NB_OUVRE_11,
		   PACK_REE_SAISIE.get_nb_jour_ouvre('12/'||l_anneecourante) NB_OUVRE_12
	  from DUAL;

END lister_total_ouvre_mois;


--*************************************************************************************************
-- Procédure update_rees
--
-- Permet de modifier les réestimés d'une ressource
--
-- ************************************************************************************************
PROCEDURE update_rees(	p_chaine	IN  VARCHAR2,
                        p_nbcurseur OUT INTEGER,
                        p_message   OUT VARCHAR2
					 ) IS
	l_length number(7);
	l_chaine varchar2(32000);
	l_pos number(7);
	l_pos1 number(7);
	l_ident VARCHAR2(6);
	l_ligne varchar2(32000);
	l_code_activite REE_REESTIME.CODE_ACTIVITE%TYPE;
	l_codsg REE_REESTIME.CODSG%TYPE;
	l_code_scenario REE_REESTIME.CODE_SCENARIO%TYPE;
	l_point1 number(7);
	l_point2 number(7);
	l_point3 number(7);
	l_point4 number(7);
	l_separateur number(7);
	l_separateur1 number(7);
	l_ligne_rees varchar2(32000);
	l_mois number(2);
	l_rees varchar2(100);
	l_exist number(1);
	l_annee varchar2(4);
	l_type_ressource REE_RESSOURCES.TYPE%TYPE;
	l_debug varchar2(1) := 'N';
	l_msg VARCHAR2(1024);
BEGIN
	l_debug := 'N';

	p_message:='';
-- p_chaine du type ':ident:code_activite1;REES_<ligne>_<mois>=;REES_<ligne>_<mois+1>=;....;:'
	l_length := LENGTH(p_chaine);
	l_ident  := SUBSTR(p_chaine,1,INSTR(p_chaine,';',1,1)-1);

-- On supprime le type se trouvant à la fin de l'identifiant
    l_type_ressource := substr(l_ident,length(l_ident));
	l_ident := substr(l_ident,0,length(l_ident)-1);

	if (l_debug='O') then
	   dbms_output.put_line('ident:'||l_ident);
	end if;

	l_point1 := INSTR(p_chaine,';',1,1);
	l_point2 := INSTR(p_chaine,';',1,2);
	l_point3 := INSTR(p_chaine,';',1,3);

	l_codsg := SUBSTR(p_chaine,l_point1+1,l_point2-l_point1-1);
	if (l_debug='O') then
	   dbms_output.put_line('codsg:'||l_codsg);
	end if;

	l_code_scenario := SUBSTR(p_chaine,l_point2+1,l_point3-l_point2-1);
	if (l_debug='O') then
	   dbms_output.put_line('code_scenario:'||l_code_scenario);
	end if;

/*	BEGIN
		select r.type
		  into l_type_ressource
		  from REE_RESSOURCES r
		 where to_char(r.IDENT)||r.TYPE = l_ident
		   and r.CODSG = to_number(l_codsg);
    EXCEPTION
	    WHEN NO_DATA_FOUND THEN
		    pack_global.recuperer_message(20978, '%s1', l_ident, '%s2', l_codsg, NULL, l_msg);
	        raise_application_error(-20978, l_msg);
	    WHEN OTHERS THEN
       	    raise_application_error( -20997, SQLERRM);
	END;*/

	FOR i IN 1..l_length LOOP
		l_pos := INSTR(p_chaine,':',1,i);
		l_pos1 := INSTR(p_chaine,':',1,i+1);
		l_ligne := SUBSTR(p_chaine,l_pos+1,l_pos1-l_pos-1);
		l_point1 := INSTR(l_ligne,';',1,1);
		l_point2 := INSTR(l_ligne,';',1,2);
		l_point3 := INSTR(l_ligne,';',1,3);
		l_point4 := INSTR(l_ligne,';',1,4);

		if (l_debug='O') then
		   dbms_output.put_line('ligne:'||l_ligne);
		end if;

		l_code_activite := SUBSTR(l_ligne,1,l_point1-1);

		if (l_debug='O') then
		   dbms_output.put_line('code_activite:'||l_code_activite);
		end if;

		For j IN 1..LENGTH(l_ligne) LOOP
			l_separateur  := INSTR(l_ligne,';',1,j);
			l_separateur1 := INSTR(l_ligne,';',1,j+1);

			l_ligne_rees := SUBSTR(l_ligne,l_separateur+1,l_separateur1-l_separateur-1);

			if (l_debug='O') then
			   dbms_output.put_line('ligne_rees: |'||l_ligne_rees||'|');
			end if;

			if (l_ligne_rees = '' or l_ligne_rees is null) then
				if (l_debug='O') then
				   dbms_output.put_line('Activité suivante');
				   dbms_output.put_line('==========================');
				end if;
			    exit;
			end if;

		-- Rechercher le mois du réestimé
			l_mois:=TO_NUMBER(SUBSTR(l_ligne_rees,INSTR(l_ligne_rees,'_',1,2)+1,INSTR(l_ligne_rees,'=',1,1)-INSTR(l_ligne_rees,'_',1,2)-1));


		-- Rechercher le réestimé
			l_rees:=SUBSTR(l_ligne_rees,INSTR(l_ligne_rees,'=',1,1)+1,LENGTH(l_ligne_rees)-INSTR(l_ligne_rees,'=',1,1));

			if (l_debug='O') then
			   dbms_output.put_line('mois:'||l_mois||' rees:'||l_rees);
			end if;

		-- Rechercher si l'activité a déjà un réestimé pour le mois
		    BEGIN
				select to_char(datdebex,'YYYY') into l_annee from datdebex;

				select 1
				  into l_exist
				  from REE_REESTIME r
				 where r.IDENT = to_number(l_ident)
				   and r.TYPE  = l_type_ressource
				   and r.CODSG = l_codsg
				   and r.CODE_SCENARIO = l_code_scenario
				   and to_char(r.CDEB,'MM/YYYY') = to_char(l_mois,'FM00')||'/'||l_annee
				   and r.CODE_ACTIVITE = l_code_activite;
				-- si cette requête ne ramène rien on déclenche l'exception NO_DATA_FOUND

				-- Modifier le réestimé s'il n'est pas nul
		   	   	if l_rees is not null then

					if (l_debug='O') then
					   dbms_output.put_line('Modification du réestimé');
					end if;

					update REE_REESTIME r
					   set conso_prevu = to_number(l_rees)
					 where r.IDENT = to_number(l_ident)
				       and r.TYPE  = l_type_ressource
					   and r.CODSG = l_codsg
					   and r.CODE_SCENARIO = l_code_scenario
					   and to_char(r.CDEB,'MM/YYYY') = to_char(l_mois,'FM00')||'/'||l_annee
					   and r.CODE_ACTIVITE = l_code_activite;
		   		else

					if (l_debug='O') then
					   dbms_output.put_line('Suppression du réestimé');
					end if;

					delete REE_REESTIME r
					 where r.IDENT = to_number(l_ident)
				       and r.TYPE  = l_type_ressource
					   and r.CODSG = l_codsg
					   and r.CODE_SCENARIO = l_code_scenario
					   and to_char(r.CDEB,'MM/YYYY') = to_char(l_mois,'FM00')||'/'||l_annee
					   and r.CODE_ACTIVITE = l_code_activite;
		   		end if;

		    commit;

	        EXCEPTION
				WHEN NO_DATA_FOUND THEN
					-- pas de réestimé pour l'activité
					if (l_rees!='' or l_rees is not null) then
					   -- Ajouter le nouveau réestimé
						insert into REE_REESTIME (
							   CODSG, CODE_SCENARIO,
							   CDEB,
							   TYPE, IDENT, CODE_ACTIVITE, CONSO_PREVU )
					    VALUES (
						       l_codsg, l_code_scenario,
							   to_date('01/'||to_char(l_mois,'FM00')||'/'||l_annee, 'DD/MM/YYYY'),
							   l_type_ressource, to_number(l_ident), l_code_activite, to_number(l_rees));
					end if;
		    END;

		END LOOP;

		if (INSTR(p_chaine,':',1,i+2)=0) then
			exit;
		end if;
	END LOOP;

	commit;

END update_rees;


--*************************************************************************************************
-- Procédure lister_scenarios_dpg
--
-- Permet de lister les cénario d'un dpg
--
-- ************************************************************************************************
PROCEDURE lister_scenarios_dpg( 	p_codsg IN VARCHAR2,
   			 						p_userid 	IN VARCHAR2,
   									p_curseur IN OUT scenarios_listeCurType
                                 ) IS
	l_msg VARCHAR2(1024);
	l_codsg NUMBER;

BEGIN

	If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
       
    /* TD 694  on retoune une liste avec le code erreur pour l'affichage du message via une popup dans l'ecran*/
         BEGIN
            OPEN p_curseur FOR
            Select 'ERREUR' CODE_ACTIVITE,
                       ' ' LIB_ACTIVITE
                 from dual;
        END;
        --raise_application_error(-20203,l_msg);
    ELSE
     	IF ( pack_habilitation.fhabili_me(p_codsg, p_userid)= 'faux' ) THEN
		    pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
			raise_application_error(-20364,l_msg);
        ELSE

			BEGIN
        		OPEN p_curseur FOR
              		SELECT CODE_SCENARIO,CODE_SCENARIO||' - '||LIB_SCENARIO LIB_SCENARIO
					  FROM REE_SCENARIOS
				     WHERE CODSG=TO_NUMBER(p_codsg)
				     ORDER BY OFFICIEL desc, CODE_SCENARIO;
      		EXCEPTION
			     WHEN No_Data_Found THEN
				 BEGIN
				      l_msg := 'Veuillez selectionner un scénario';
				      raise_application_error(-20203,l_msg);
			     END;
			    WHEN OTHERS THEN
         			raise_application_error( -20997, SQLERRM);
            END;
        END IF;
    END IF;

END lister_scenarios_dpg;



--*************************************************************************************************
-- Procédure lister_activites_dpg
--
-- Permet de lister les cénario d'un dpg
--
-- ************************************************************************************************
PROCEDURE lister_activites_dpg(	p_codsg   		 IN VARCHAR2,
   								p_userid  		 IN VARCHAR2,
		  						p_curseur   	 IN OUT activites_listeCurType
                             ) IS
    l_msg 	        VARCHAR2(1024);
	l_codsg    		NUMBER;
	l_act_ress 		VARCHAR2(32000);
	l_code_activite REE_REESTIME.code_activite%TYPE;
BEGIN

	If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
	    pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
        raise_application_error(-20203,l_msg);
    ELSE
        IF ( pack_habilitation.fhabili_me(p_codsg, p_userid) = 'faux' ) THEN
		    pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
			raise_application_error(-20364,l_msg);
        ELSE
			BEGIN
	        	    OPEN p_curseur FOR
	              	    SELECT code_activite CODE_ACTIVITEß, code_activite || ' - ' || lib_activite LIB_ACTIVITEß
	              	      FROM ree_activites
	              	     WHERE codsg = TO_NUMBER(p_codsg)
					     ORDER BY type desc, code_activite;
      		EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
            END;
        END IF;
    END IF;

END lister_activites_dpg;

--*************************************************************************************************
-- Procédure ajout_activite
--
-- Permet d'ajouter une nouvelle activite au réestimé d'une ressource
--
-- 20/06/2005 : INUTILISE car on fait le test d'existance en javascript maintenant dans la page fSaisieRe.jsp
--
-- ************************************************************************************************
PROCEDURE ajout_activite( p_chaine	IN  VARCHAR2,
                          p_nbcurseur OUT INTEGER,
                          p_message   OUT VARCHAR2
					 	  ) IS
	l_length number(7);
	l_chaine varchar2(32000);
	l_pos number(7);
	l_pos1 number(7);
	l_ident VARCHAR2(6);
	l_ligne varchar2(32000);
	l_code_activite REE_REESTIME.CODE_ACTIVITE%TYPE;
	l_codsg REE_REESTIME.CODSG%TYPE;
	l_code_scenario REE_REESTIME.CODE_SCENARIO%TYPE;
	l_point1 number(7);
	l_point2 number(7);
	l_point3 number(7);
	l_point4 number(7);
	l_separateur number(7);
	l_separateur1 number(7);
	l_ligne_rees varchar2(32000);
	l_mois number(2);
	l_rees varchar2(100);
	l_exist number(1);
	l_annee varchar2(4);
	l_type_ressource REE_RESSOURCES.TYPE%TYPE;
	l_debug varchar2(1) := 'N';
	l_msg VARCHAR2(1024);
BEGIN
	l_debug := 'N';

	p_message:='';
-- p_chaine du type ':ident||type:code_activite1;REES_<ligne>_<mois>=;REES_<ligne>_<mois+1>=;....;:'
	l_length := LENGTH(p_chaine);
	l_ident  := SUBSTR(p_chaine,1,INSTR(p_chaine,';',1,1)-1);

-- On supprime le type se trouvant à la fin de l'identifiant
    l_type_ressource := substr(l_ident,length(l_ident));
	l_ident  := substr(l_ident,0,length(l_ident)-1);

	if (l_debug='O') then
	   dbms_output.put_line('ident:'||l_ident);
	end if;

	l_point1 := INSTR(p_chaine,';',1,1);
	l_point2 := INSTR(p_chaine,';',1,2);
	l_point3 := INSTR(p_chaine,';',1,3);

	l_codsg := SUBSTR(p_chaine,l_point1+1,l_point2-l_point1-1);
	if (l_debug='O') then
	   dbms_output.put_line('codsg:'||l_codsg);
	end if;

	l_code_scenario := SUBSTR(p_chaine,l_point2+1,l_point3-l_point2-1);
	if (l_debug='O') then
	   dbms_output.put_line('code_scenario:'||l_code_scenario);
	end if;

/*	BEGIN
		select r.type
		  into l_type_ressource
		  from REE_RESSOURCES r
		 where to_char(r.IDENT)||r.TYPE = l_ident
		   and r.CODSG = to_number(l_codsg);
    EXCEPTION
	    WHEN NO_DATA_FOUND THEN
		    pack_global.recuperer_message(20978, '%s1', l_ident, '%s2', l_codsg, NULL, l_msg);
	        raise_application_error(-20978, l_msg);
	    WHEN OTHERS THEN
       	    raise_application_error( -20997, SQLERRM);
	END;*/

	FOR i IN 1..l_length LOOP
		l_pos := INSTR(p_chaine,':',1,i);
		l_pos1 := INSTR(p_chaine,':',1,i+1);
		l_ligne := SUBSTR(p_chaine,l_pos+1,l_pos1-l_pos-1);
		l_point1 := INSTR(l_ligne,';',1,1);
		l_point2 := INSTR(l_ligne,';',1,2);
		l_point3 := INSTR(l_ligne,';',1,3);
		l_point4 := INSTR(l_ligne,';',1,4);

		if (l_debug='O') then
		   dbms_output.put_line('ligne:'||l_ligne);
		end if;

		l_code_activite := SUBSTR(l_ligne,1,l_point1-1);

		if (l_debug='O') then
		   dbms_output.put_line('code_activite:'||l_code_activite);
		end if;

		For j IN 1..LENGTH(l_ligne) LOOP
			l_separateur  := INSTR(l_ligne,';',1,j);
			l_separateur1 := INSTR(l_ligne,';',1,j+1);

			l_ligne_rees := SUBSTR(l_ligne,l_separateur+1,l_separateur1-l_separateur-1);

			if (l_debug='O') then
			   dbms_output.put_line('ligne_rees: |'||l_ligne_rees||'|');
			end if;

			if (l_ligne_rees = '' or l_ligne_rees is null) then
				if (l_debug='O') then
				   dbms_output.put_line('Activité suivante');
				   dbms_output.put_line('==========================');
				end if;
			    exit;
			end if;

		-- Rechercher le mois du réestimé
			l_mois:=TO_NUMBER(SUBSTR(l_ligne_rees,INSTR(l_ligne_rees,'_',1,2)+1,INSTR(l_ligne_rees,'=',1,1)-INSTR(l_ligne_rees,'_',1,2)-1));


		-- Rechercher le réestimé
			l_rees:=SUBSTR(l_ligne_rees,INSTR(l_ligne_rees,'=',1,1)+1,LENGTH(l_ligne_rees)-INSTR(l_ligne_rees,'=',1,1));

			if (l_debug='O') then
			   dbms_output.put_line('mois:'||l_mois||' rees:'||l_rees);
			end if;

		-- Rechercher si l'activité a déjà un réestimé pour le mois
		    BEGIN
				select to_char(datdebex,'YYYY') into l_annee from datdebex;

				select 1
				  into l_exist
				  from REE_REESTIME r
				 where r.IDENT = to_number(l_ident)
				   and r.TYPE  = l_type_ressource
				   and r.CODSG = l_codsg
				   and r.CODE_SCENARIO = l_code_scenario
				   and to_char(r.CDEB,'MM/YYYY') = to_char(l_mois,'FM00')||'/'||l_annee
				   and r.CODE_ACTIVITE = l_code_activite;
				-- si cette requête ne ramène rien on déclenche l'exception NO_DATA_FOUND

				-- La ressource a déjà un réestimé sur cette activité donc on ne la met pas à jour
				pack_global.recuperer_message(21017, NULL, NULL, NULL, l_msg);
	        	p_message := l_msg;

	        EXCEPTION
				WHEN NO_DATA_FOUND THEN
					-- pas de réestimé pour l'activité
					if (l_rees!='' or l_rees is not null) then
					   -- Ajouter le nouveau réestimé
						insert into REE_REESTIME (
							   CODSG, CODE_SCENARIO,
							   CDEB,
							   TYPE, IDENT, CODE_ACTIVITE, CONSO_PREVU )
					    VALUES (
						       l_codsg, l_code_scenario,
							   to_date('01/'||to_char(l_mois,'FM00')||'/'||l_annee, 'DD/MM/YYYY'),
							   l_type_ressource, to_number(l_ident), l_code_activite, to_number(l_rees));
					end if;
		    END;

		END LOOP;

		if (INSTR(p_chaine,':',1,i+2)=0) then
			exit;
		end if;
	END LOOP;

	commit;

END ajout_activite;



--*************************************************************************************************
-- Procédures et Fonctions suivantes sont utililés pour l'initialisation du réestimé d'une ressource
--
--
--
-- ************************************************************************************************

FUNCTION nb_jours_travail( p_ident IN ree_ressources.ident%TYPE,
						   p_type IN ree_ressources.type%TYPE,
						   p_date IN DATE
				         ) RETURN NUMBER IS
    v_SOCCODE VARCHAR2(4);
	NB_JOURS  NUMBER(3,1);
BEGIN

		-- Si on ne traite pas une ressource fictive
		IF p_type <> 'X' THEN

		    --on recupere le SOCCODE de la ressource
		    SELECT DISTINCT SOCCODE INTO v_SOCCODE
	              FROM SITU_RESS_FULL
	              WHERE IDENT=p_ident
	              AND (DATSITU is NULL OR DATSITU<= p_date)
	              AND (DATDEP is NULL OR DATDEP> p_date);
		ELSE
			-- On considère arbitrairement que la ressource fictive est un prestataire
			v_SOCCODE:='XXXX';
		END IF;

	    --on compare le soccode si le soccode est = SG..
		--alors le champ CHAMP= NB_TRAVAIL_SG sinon NB_TRAVAIL_SII
	    IF(v_SOCCODE='SG..')THEN
		        --on recupre le nonbre de jours pour un mois donné
	            SELECT NB_TRAVAIL_SG INTO NB_JOURS
			          FROM CALENDRIER
			          WHERE CALANMOIS=p_date;
	    ELSE
	          --on recupre le nonbre de jours pour un mois donné
	            SELECT NB_TRAVAIL_SSII INTO NB_JOURS
			          FROM CALENDRIER
			          WHERE CALANMOIS=p_date;
	    END IF;

	    RETURN NB_JOURS;

EXCEPTION
    WHEN OTHERS THEN raise; --RETURN 0;

END nb_jours_travail;


FUNCTION nb_jours_travail_annee(p_ident IN ree_ressources.ident%TYPE,
								p_type IN ree_ressources.type%TYPE,
							    p_moismens IN DATE
				               ) RETURN NUMBER IS
	    v_SOCCODE	VARCHAR2(4);
		NB_JOURS    NUMBER;


BEGIN

		-- Si on ne traite pas une ressource fictive
		IF p_type <> 'X' THEN

		    --on recupere le SOCCODE de la ressource
		    SELECT DISTINCT SOCCODE INTO v_SOCCODE
	              FROM SITU_RESS_FULL
	              WHERE IDENT=p_ident
	              AND (DATSITU is NULL OR DATSITU<= p_moismens)
	              AND (DATDEP is NULL OR DATDEP> p_moismens);
		ELSE
			-- On considère arbitrairement que la ressource fictive est un prestataire
			v_SOCCODE:='XXXX';
		END IF;


	    --on compare le soccode si le soccode est = SG..
		--alors le champ CHAMP= NB_TRAVAIL_SG sinon NB_TRAVAIL_SII
	    IF(v_SOCCODE='SG..')THEN
		        --on recupre le nonbre de jours pour l'annee en cours
	            SELECT SUM(NB_TRAVAIL_SG) INTO NB_JOURS
			          FROM CALENDRIER
			          WHERE to_char(calanmois,'yyyy')=to_char(p_MOISMENS,'yyyy');

	    ELSE
	          --on recupre le nonbre de jours pour l'annee en cours
	            SELECT SUM(NB_TRAVAIL_SSII) INTO NB_JOURS
			          FROM CALENDRIER
			          WHERE to_char(calanmois,'yyyy')=to_char(p_MOISMENS,'yyyy');

	    END IF;


	    RETURN NB_JOURS;


EXCEPTION
    WHEN OTHERS THEN raise; --RETURN 0;

END nb_jours_travail_annee;





PROCEDURE ree_saisie_init_absences( p_codsg 	IN ligne_bip.codsg%TYPE,
			                        p_code_scenario IN ree_scenarios.code_scenario%TYPE,
						            p_ident IN ree_ressources.ident%TYPE,
							        p_type IN ree_ressources.type%TYPE,
								    p_moismens IN DATE
									) IS

	v_CJOURS		      calendrier.CJOURS%TYPE;
	v_NB_JOURS            CALENDRIER.NB_TRAVAIL_SG%TYPE;
	v_date 				  DATE;
	v_MOISARRIVEE		  NUMBER;
	v_DATEARRIVEE		  DATE;
	nb_jour_ouvre_av_arr  NUMBER;
	p_nb_enl			  NUMBER;
	v_DATDEP			  DATE;
	v_MOISDEPART		  NUMBER;
	nb_jour_ouvre_av_dep  NUMBER;
BEGIN

	BEGIN
		select datarrivee, datdep
		  into v_DATEARRIVEE, v_DATDEP
		  from ree_ressources
		 where ident = p_ident
		   and type  = p_type
                   and codsg = p_codsg;
	EXCEPTION
	    WHEN OTHERS then
			v_DATEARRIVEE := null;
			v_DATDEP 	  := null;
	END;



	-- *********************************
	--    Traitement date d'arrivée
	-- *********************************

	-- si pas de date d'arrivée on initialise tous les mois
	if ( (v_DATEARRIVEE is null) OR (v_DATEARRIVEE = '') ) then
	    v_MOISARRIVEE := 1;
	else
		-- si la date d'arrivée est dans l'année courante ou dans les suivantes
		-- on initialise qu'à partir du mois d'arrivée
		if ( to_number(to_char(v_DATEARRIVEE,'yyyy')) = to_number(to_char(p_moismens,'yyyy')) ) then
		    v_MOISARRIVEE := to_number(to_char(v_DATEARRIVEE,'mm'));
		elsif ( to_number(to_char(v_DATEARRIVEE,'yyyy')) > to_number(to_char(p_moismens,'yyyy')) ) then
		    v_MOISARRIVEE := 13;
		else
			-- si la date d'arrivée est antérieure à l'année courante, on initialise tous les mois de l'année
		    v_MOISARRIVEE := 1;
		end if;
	end if;


    -- on insère 0 pour les mois précédents la date d'arrivée
	FOR i in 1..v_MOISARRIVEE-1 LOOP

        v_date := TO_DATE('01/'||i||'/'||to_char(p_moismens,'yyyy'),'dd/mm/yyyy');

      	-- insert dans la table ree_reestime la ligne de l'activite ABSENCES
	    INSERT INTO REE_REESTIME (
			   					 CODSG,
					  			 CODE_SCENARIO,
					    		 CDEB,
								 TYPE,
					      		 IDENT,
								 CODE_ACTIVITE,
								 CONSO_PREVU
								 )
	    VALUES (
		 		   p_codsg,
				   p_code_scenario,
				   v_date,
				   p_type,
				   p_ident,
				   'ABSENCES',
				   0
				 );


	END LOOP;



	-- *********************************
	--    Traitement date de départ
	-- *********************************

	-- si pas de date de départ on initialise tous les mois
	if ( (v_DATDEP is null) OR (v_DATDEP = '') ) then
	    v_MOISDEPART := 12;
	else
		-- si la date de départ est dans l'année courante
		-- on initialise jusqu'à la date de départ
		if ( to_number(to_char(v_DATDEP,'yyyy')) = to_number(to_char(p_moismens,'yyyy')) ) then
		    v_MOISDEPART := to_number(to_char(v_DATDEP,'mm'));
		elsif ( to_number(to_char(v_DATDEP,'yyyy')) > to_number(to_char(p_moismens,'yyyy')) ) then
		    v_MOISDEPART := 12;
		else
			-- si la date de départ est antérieure à l'année courante on initialise rien
		    v_MOISDEPART := 0;
		end if;
	end if;

    -- on insère 0 pour les mois suivants la date de départ
	FOR i in (v_MOISDEPART+1)..12 LOOP

        v_date := TO_DATE('01/'||i||'/'||to_char(p_moismens,'yyyy'),'dd/mm/yyyy');

      	-- insert dans la table ree_reestime la ligne de l'activite ABSENCES
	    INSERT INTO REE_REESTIME (
			   					 CODSG,
					  			 CODE_SCENARIO,
					    		 CDEB,
								 TYPE,
					      		 IDENT,
								 CODE_ACTIVITE,
								 CONSO_PREVU
								 )
	    VALUES (
		 		   p_codsg,
				   p_code_scenario,
				   v_date,
				   p_type,
				   p_ident,
				   'ABSENCES',
				   0
				 );


	END LOOP;




	    --on insere toutes les lignes de l'activite absences de toute l'annee
		FOR i in v_MOISARRIVEE..v_MOISDEPART LOOP

	            v_date := TO_DATE('01/'||i||'/'||to_char(p_moismens,'yyyy'),'dd/mm/yyyy');

	      	    --On recupere le cjours du mois
	    		SELECT DISTINCT CJOURS INTO v_CJOURS
	       		       FROM CALENDRIER
		     	       WHERE CALANMOIS=v_date;


			    --On recupere le nombre de jour pour le mois
	             v_NB_JOURS := nb_jours_travail(p_ident,p_type,v_date);


			 -- ***************************************************************
			 --   REDUCTION du nombre de jour ouvré si DATE_ARRIVEE           *
			 -- ***************************************************************

				 -- Si la date d'arrivée est renseignée
				 -- on recalcul le nb de jour ouvré et le nb de jour travaillé moyen
			 	 if ( (i=v_MOISARRIVEE) AND (v_DATEARRIVEE is not null) AND (length(v_DATEARRIVEE)>0) ) then
				 	 -- calcul du nb de jour ouvré avant la date d'arrivée
				 	 nb_jour_ouvre_av_arr := CalculOuvreAvantArrivee(v_DATEARRIVEE);

					 -- pourcentage de jour ouvré à enlever sur le mois
					 p_nb_enl := nb_jour_ouvre_av_arr / v_CJOURS;

					 -- on décrémente le nb de jour ouvré
					 v_CJOURS := v_CJOURS - nb_jour_ouvre_av_arr;

					 -- on décrémente le nb de jour travaillé suivant le pourcentage de jour ouvré enlevé
					 v_NB_JOURS := v_NB_JOURS-round(v_NB_JOURS*p_nb_enl);

				 end if;

			 -- ***************************************************************
			 --   REDUCTION du nombre de jour ouvré si DATE_DEPART            *
			 -- ***************************************************************

				 -- Si la date de départ est renseignée
				 -- on recalcul le nb de jour ouvré et le nb de jour travaillé moyen
			 	 if ( (i=v_MOISDEPART) AND (v_DATDEP is not null) AND (length(v_DATDEP)>0) ) then
				 	 -- calcul du nb de jour ouvré avant la date de départ
				 	 nb_jour_ouvre_av_dep := CalculOuvreAvantArrivee(v_DATDEP);

					 -- le nombre de jour à enlever c'est le nb de jour ouvré du mois - le nb de jour ouvré avant la date de départ
					 nb_jour_ouvre_av_dep := v_CJOURS - nb_jour_ouvre_av_dep;

					 -- pourcentage de jour ouvré à enlever sur le mois
					 p_nb_enl := nb_jour_ouvre_av_dep / v_CJOURS;

					 -- on décrémente le nb de jour ouvré
					 v_CJOURS := v_CJOURS - nb_jour_ouvre_av_dep;

					 -- on décrémente le nb de jour travaillé suivant le pourcentage de jour ouvré enlevé
					 v_NB_JOURS := v_NB_JOURS-round(v_NB_JOURS*p_nb_enl);

				 end if;

	      -- insert dans la table ree_reestime la ligne de l'activite ABSENCES
	       INSERT INTO REE_REESTIME (
			   					 CODSG,
					  			 CODE_SCENARIO,
					    		 CDEB,
								 TYPE,
					      		 IDENT,
								 CODE_ACTIVITE,
								 CONSO_PREVU
								 )
	       VALUES (
		 		   p_codsg,
				   p_code_scenario,
				   v_date,
				   p_type,
				   p_ident,
				   'ABSENCES',
				   (v_CJOURS-v_NB_JOURS)
				 );


	END LOOP;


EXCEPTION
    WHEN OTHERS THEN raise; --RETURN 0;

END ree_saisie_init_absences;







PROCEDURE ree_saisie_init_date( p_codsg 	IN ligne_bip.codsg%TYPE,
		                        p_code_scenario IN ree_scenarios.code_scenario%TYPE,
							    p_ident IN ree_ressources.ident%TYPE,
					         	p_type IN ree_ressources.type%TYPE,
							 	p_date IN DATE
							  ) IS


     v_CODE_ACTIVITE      ree_activites.code_activite%TYPE;
	 v_TAUXREP            ree_ressources_activites.TAUXREP%TYPE;
	 v_CJOURS		      calendrier.CJOURS%TYPE;
	 v_NB_JOURS           CALENDRIER.NB_TRAVAIL_SG%TYPE;
	 NB_ACTIVITE          NUMBER;
	 Tab_consom           tableau_numerique;--Contiendra la liste des consu_prevu pour chaque activite
	 Tab_appr             tableau_numerique;--Contiendra la liste des consu_prevu approcher (consu_prevu -  MOD(consu_prevu,0.5) afin d'avoir la valeur apres la vergule = à 0 ou 0.5)
	 Tab_suppr            tableau_numerique;--Contiendra la liste de la valeur MOD(consu_prevu,0.5) que on a enlevé du consu_prevu
	 Tab_code_activite    Liste_chaine := Liste_chaine(); --Contiendra la liste des codes actiivites
	 nb                   NUMBER;
     dif                  NUMBER;
	 aug                  NUMBER;
	 a                    NUMBER;
	 d                    NUMBER;
	 rest                 NUMBER;
	 indice               NUMBER;
	 mini                 NUMBER;
	 min_found            NUMBER;
	 consom  			  NUMBER;
	 appr 				  NUMBER;
	 code_activite		  ree_activites.code_activite%TYPE;
	 total 				  NUMBER; --le total du consu_prevu approche pour un mois



	 --Le curseur qui recupere la liste des codes activite et leur taux de repartition
	 cursor l_c_a(c_codsg CHAR, c_ident NUMBER, c_type CHAR) IS
	       SELECT CODE_ACTIVITE,TAUXREP
		   FROM REE_RESSOURCES_ACTIVITES
		   WHERE CODSG=c_codsg
		   AND IDENT=c_ident
		   AND TYPE=c_type;

	nbRees		  NUMBER;
	v_DATEARRIVEE		  DATE;
	nb_jour_ouvre_av_arr  NUMBER;
	p_nb_enl			  NUMBER;
	v_DATDEP		      DATE;
	nb_jour_ouvre_av_dep  NUMBER;
BEGIN

	    --On recupere le cjours du mois
	    SELECT DISTINCT CJOURS INTO v_CJOURS
	          FROM CALENDRIER
		      WHERE CALANMOIS=p_date;

		--On recupere le nombre d'activite
		SELECT COUNT(DISTINCT CODE_ACTIVITE) INTO NB_ACTIVITE
		      FROM REE_RESSOURCES_ACTIVITES
		      WHERE CODSG=p_codsg
		      AND IDENT=p_ident
		      AND TYPE=p_type;

	 	--On recupere le nombre de jour pour le mois
	    v_NB_JOURS := nb_jours_travail(p_ident,p_type,p_date);


	 	-- récupération de la date d'arrivée et de départ
		BEGIN
			select datarrivee, datdep
			  into v_DATEARRIVEE , v_DATDEP
			  from ree_ressources
			 where ident = p_ident
			   and type  = p_type
			   and codsg = p_codsg;
		EXCEPTION
		    WHEN OTHERS then
				v_DATEARRIVEE := null;
				v_DATDEP      := null;
		END;


		-- ****************************************************
		--    Gestion de la DATE d'ARRIVEE                    *
		-- ****************************************************

		-- si pas de date d'arrivée on initialise tout le mois
		if ( (v_DATEARRIVEE is null) OR (v_DATEARRIVEE = '') ) then
			nbRees := (v_CJOURS-v_NB_JOURS);
		else
			-- si la date d'arrivée est dans l'année courante ou dans les suivantes
			-- on initialise qu'à partir du mois d'arrivée
			if ( to_number(to_char(v_DATEARRIVEE,'yyyymm')) > to_number(to_char(p_date,'yyyymm')) ) then
			    nbRees := 0;
			else
				-- si la date d'arrivée est antérieure à l'année courante, on initialise tous les mois de l'année

				-- Si la date d'arrivée est renseignée
				-- on recalcul le nb de jour ouvré et le nb de jour travaillé moyen
				if ( to_number(to_char(v_DATEARRIVEE,'yyyymm')) = to_number(to_char(p_date,'yyyymm')) ) then
					-- calcul du nb de jour ouvré avant la date d'arrivée
				 	nb_jour_ouvre_av_arr := CalculOuvreAvantArrivee(v_DATEARRIVEE);

					-- pourcentage de jour ouvré à enlever sur le mois
					p_nb_enl := nb_jour_ouvre_av_arr / v_CJOURS;

					-- on décrémente le nb de jour ouvré
					v_CJOURS := v_CJOURS - nb_jour_ouvre_av_arr;

					-- on décrémente le nb de jour travaillé suivant le pourcentage de jour ouvré enlevé
					v_NB_JOURS := v_NB_JOURS-round(v_NB_JOURS*p_nb_enl);
				end if;

				nbRees := (v_CJOURS-v_NB_JOURS);
			end if;
		end if;



		-- ****************************************************
		--    Gestion de la DATE de DEPART                    *
		-- ****************************************************

		-- si pas de date de départ on initialise tout le mois
		-- sinon on recalcule suivant la date de départ
		if ( (v_DATDEP is not null) OR (length(v_DATDEP)>0) ) then

			-- si la date départ est inférieure à au mois calculé "Réestimé = 0"
			if ( to_number(to_char(v_DATDEP,'yyyymm')) < to_number(to_char(p_date,'yyyymm')) ) then
			    nbRees := 0;
			else
				-- Si la date de départ est dans le mois en cours de traitement
				-- on recalcul le nb de jour ouvré et le nb de jour travaillé moyen
				if ( to_number(to_char(v_DATDEP,'yyyymm')) = to_number(to_char(p_date,'yyyymm')) ) then
					-- calcul du nb de jour ouvré avant la date de départ
				 	nb_jour_ouvre_av_dep := CalculOuvreAvantArrivee(v_DATDEP);

					-- le nombre de jour à enlever c'est le nb de jour ouvré du mois - le nb de jour ouvré avant la date de départ
					nb_jour_ouvre_av_dep := v_CJOURS - nb_jour_ouvre_av_dep;

					-- pourcentage de jour ouvré à enlever sur le mois
					p_nb_enl := nb_jour_ouvre_av_dep / v_CJOURS;

					-- on décrémente le nb de jour ouvré
					v_CJOURS := v_CJOURS - nb_jour_ouvre_av_dep;

					-- on décrémente le nb de jour travaillé suivant le pourcentage de jour ouvré enlevé
					v_NB_JOURS := v_NB_JOURS-round(v_NB_JOURS*p_nb_enl);

    				nbRees := (v_CJOURS-v_NB_JOURS);
				end if;

			end if;

		end if;


	    -- insert dans la table ree_reestime la ligne de l'activite ABSENCES
	    INSERT INTO REE_REESTIME (
			   					 CODSG,
					  			 CODE_SCENARIO,
					    		 CDEB,
								 TYPE,
					      		 IDENT,
								 CODE_ACTIVITE,
								 CONSO_PREVU
								 )
	    VALUES (
				p_codsg,
				p_code_scenario,
				p_date,
				p_type,
				p_ident,
				'ABSENCES',
--				(v_CJOURS-v_NB_JOURS)
				nbRees
				);



		OPEN l_c_a(p_codsg, p_ident, p_type);

		nb := 1;
		total := 0;

		LOOP


		  FETCH l_c_a  INTO v_CODE_ACTIVITE, v_TAUXREP;

	      IF l_c_a%NOTFOUND THEN
	      EXIT;
	      END IF;


			Tab_code_activite.extend;
		   	Tab_code_activite(Tab_code_activite.count) := v_CODE_ACTIVITE;
		    Tab_consom(nb):= ((v_TAUXREP*v_NB_JOURS)/100);

			Tab_appr(nb) := Tab_consom(nb)-MOD(Tab_consom(nb),0.5);
			Tab_suppr(nb) := MOD(Tab_consom(nb),0.5);

			total := total + Tab_appr(nb);

		 nb := nb + 1;

	   END LOOP;

		-- Fermeture du curseur
        CLOSE l_c_a;



		--tri du tableau tab_supp et les tableaux correspondants
		FOR i IN 1..(NB_ACTIVITE-1) LOOP

               min_found := 0;
			   mini := Tab_suppr(i);
			   code_activite := Tab_code_activite(i);
			   appr := Tab_appr(i);
			   consom := Tab_consom(i);


			   FOR j IN (i+1)..NB_ACTIVITE LOOP

		             IF(mini > Tab_suppr(j))THEN

					      mini := Tab_suppr(j);
			     		  code_activite := Tab_code_activite(j);
			   			  appr := Tab_appr(j);
			   			  consom := Tab_consom(j);
						  min_found := 1;
						  indice := j;

					 END IF;

               END LOOP;

			   IF(min_found=1)THEN

			          Tab_suppr(indice) := Tab_suppr(i);
					  Tab_code_activite(indice) := Tab_code_activite(i);
			   		  Tab_appr(indice) := Tab_appr(i);
			   		  Tab_consom(indice) := Tab_consom(i);


					  Tab_suppr(i) := mini;
					  Tab_code_activite(i) := code_activite;
			   		  Tab_appr(i) := appr;
			   		  Tab_consom(i) := consom;


			   END IF;

	   END LOOP;


	   --on calcule la difference entre le total des jours real et le total des jours approché pour le mois
	   --pour trouver combien de fois,

	   nb := (NB_ACTIVITE-((v_NB_JOURS-total)/0.5)+1);


	   -- il faudrait rajouter la valeur 0.5 au consu_prevu
	   -- la valeur 0.5 l'additionne au nb consu_prevu que la valeur enlevée est plus grande

	   FOR k IN 1..NB_ACTIVITE LOOP

	          IF(k>=nb)THEN

                     Tab_consom(k) := Tab_appr(k) + 0.5;

			  ELSE

			         Tab_consom(k) := Tab_appr(k);

			  END IF;

	   END LOOP;


        --la boucle qui permet d'inserer les lignes dans la table ree_reestime pour chaque activite

		FOR i IN 1..NB_ACTIVITE LOOP


			-- ****************************************************
			--    Gestion de la DATE d'ARRIVEE                    *
			-- ****************************************************

			-- si pas de date d'arrivée on initialise tous les mois
			if ( (v_DATEARRIVEE is null) OR (v_DATEARRIVEE = '') ) then
				nbRees := Tab_consom(i);
			else
				-- si la date d'arrivée est dans l'année courante ou dans les suivantes
				-- on initialise qu'à partir du mois d'arrivée
				if ( to_number(to_char(v_DATEARRIVEE,'yyyymm')) > to_number(to_char(p_date,'yyyymm')) ) then
				    nbRees := 0;
				else
					-- si la date d'arrivée est antérieure à l'année courante, on initialise tous les mois de l'année
					nbRees := Tab_consom(i);
				end if;
			end if;

			-- ****************************************************
			--    Gestion de la DATE de DEPART                    *
			-- ****************************************************
			-- si pas de date d'arrivée on initialise tous les mois
			if ( (v_DATDEP is null) OR (v_DATDEP = '') ) then
				nbRees := Tab_consom(i);
			else
				-- si la date de départ est inférieur à la date du traitement
				-- on initialise à 0
				if ( to_number(to_char(v_DATDEP,'yyyymm')) < to_number(to_char(p_date,'yyyymm')) ) then
				    nbRees := 0;
				else
					-- si la date de départ est postérieure
					nbRees := Tab_consom(i);
				end if;
			end if;


			-- insert dans la table tmp_ree_detail des lignes pour chaque activite de chaque ressource
		    INSERT INTO REE_REESTIME (
				   					 CODSG,
						  			 CODE_SCENARIO,
						    		 CDEB,
									 TYPE,
						      		 IDENT,
									 CODE_ACTIVITE,
									 CONSO_PREVU
									 )
		    VALUES (
					p_codsg,
					p_code_scenario,
					p_date,
					p_type,
					p_ident,
					Tab_code_activite(i),
--					Tab_consom(i)
					nbRees
					);

		   commit;

	   END LOOP;



      EXCEPTION
           WHEN OTHERS THEN raise; --RETURN 0;


END ree_saisie_init_date;



	 PROCEDURE ree_saisie_init_tous( p_codsg    	 IN ligne_bip.codsg%TYPE,
				                     p_code_scenario IN ree_scenarios.code_scenario%TYPE,
							         p_ident         IN ree_ressources.ident%TYPE,
							         p_type          IN ree_ressources.type%TYPE,
                              		 NB_ACTIVITE NUMBER,
									 p_moismens IN DATE
									 ) IS


	 v_SOCCODE	          VARCHAR2(4);
	 v_CODE_ACTIVITE      ree_activites.code_activite%TYPE;
	 v_TAUXREP            ree_ressources_activites.TAUXREP%TYPE;
	 v_CDEB               ree_reestime.CDEB%TYPE;
	 v_CONSO_PREVU        ree_reestime.CONSO_PREVU%TYPE;
	 Tab_code_activite    Liste_chaine := Liste_chaine();
	 Tab_a_real           tableau_numerique;--contiendra la somme des jours real pour chaque activite de toute l'annee
	 Tab_a_reestime       tableau_numerique;--contiendra la somme des consu_prevu pour chaque activite de toute l'annee
	 Tab_diff             tableau_numerique;
	 Tab_appr             tableau_numerique;
	 Tab_suppr            tableau_numerique;
	 Tab_ordre            tableau_numerique;
	 Tab_ajout            tableau_numerique;
	 Tab_matrice_conso    tableau_numerique;
	 Tab_matrice_a        Liste_chaine := Liste_chaine();
	 Tab_matrice_cdeb     Liste_date := Liste_date();
	 nb                   NUMBER;
	 nb_ligne_matrice     NUMBER;
	 nb_jour_annee        NUMBER;
	 indice               NUMBER;
	 mini                 NUMBER;
	 min_found            NUMBER;
	 code_activite		  ree_activites.code_activite%TYPE;
	 reel  		    	  NUMBER;
	 reestime  			  NUMBER;
	 appr 				  NUMBER;
	 total 				  NUMBER;
	 i                    NUMBER;
	 j                    NUMBER;
	 trouver 			  NUMBER;
	 f  				  NUMBER;
	 k                    NUMBER;


	 -- ce curseur permet de recupere la liste des codes d'activite
	 cursor l_activite(c_codsg CHAR, c_ident NUMBER, c_type CHAR) IS
	       select code_activite,tauxrep
		   from ree_ressources_activites
		   where codsg=c_codsg
		   and ident=c_ident
		   and type=c_type
		   order by code_activite;


	 -- ce curseur permet de recupere la liste des activite et leurs conso_prevu de la meme annee que moismens
     cursor l_a_conso (c_codsg CHAR, c_code_scenario CHAR, c_ident NUMBER, c_type CHAR, c_MOISMENS DATE) IS
	       select cdeb,code_activite,conso_prevu
		   from ree_reestime
		   where codsg=c_codsg
		   and code_scenario=c_code_scenario
		   and ident=c_ident
		   and type=c_type
		   and code_activite<>'ABSENCES'
		   and to_char(cdeb,'yyyy')=to_char(c_MOISMENS,'yyyy')
		   order by code_activite,cdeb;


	 BEGIN

		--On recupere le nombre de jour pour toute l'annee
		nb_jour_annee := nb_jours_travail_annee(p_ident,p_type,p_MOISMENS);


		--on insere toutes les lignes de toute l'annee
		FOR i in 1..12 LOOP

	           ree_saisie_init_date(p_codsg,p_code_scenario,p_ident,p_type,TO_DATE('01/'||i||'/'||to_char(p_MOISMENS,'yyyy'),'dd/mm/yyyy'));

	     END LOOP;



		 --ici on va recalculer les consu_prevu pour que la somme des consu_prevu  de toute l'anne
		 --soit egale à la somme real  pour chaque activite




		 --on recupere tous les consu_prevu de toute l'annee
		 nb := 1;
		 total := 0;

		 OPEN l_activite(p_codsg,p_ident,p_type);

		 LOOP


		    FETCH l_activite  INTO v_CODE_ACTIVITE, v_TAUXREP;

	        IF l_activite%NOTFOUND THEN
	        EXIT;
	        END IF;


			Tab_code_activite.extend;
		   	Tab_code_activite(Tab_code_activite.count) := v_CODE_ACTIVITE;

			Tab_a_real(nb):= (nb_jour_annee*v_TAUXREP)/100;

			Tab_appr(nb) := Tab_a_real(nb)-MOD(Tab_a_real(nb),0.5);
			Tab_suppr(nb) := MOD(Tab_a_real(nb),0.5);
		    total := total + Tab_appr(nb);

			SELECT SUM(CONSO_PREVU) INTO Tab_a_reestime(nb)
			      from ree_reestime
                  where codsg=p_codsg
				  and ident=p_ident
				  and code_scenario=p_code_scenario
				  and code_activite=v_CODE_ACTIVITE;



		    nb := nb + 1;

	     END LOOP;


		 CLOSE l_activite;



		--le tableau qui contindra l'ordre

		FOR i IN 1..NB_ACTIVITE LOOP

		Tab_ordre(i) := 0;

		END LOOP;


		 nb := 1;

		--remplire le tab_ordre, ou  on met le numero d'ordre des valeurs du tableaux tab_a_real
		 FOR k IN 1..NB_ACTIVITE LOOP

		 FOR i IN 1..NB_ACTIVITE LOOP
		        IF(Tab_ordre(i)=0)THEN

                   min_found := 0;
			       mini := Tab_suppr(i);

			       FOR j IN 1..NB_ACTIVITE LOOP

		               IF(Tab_ordre(j)=0)THEN

					       IF(mini > Tab_suppr(j))THEN

							   mini := Tab_suppr(j);
			     		       min_found := 1;
						       indice := j;

						  END IF;
					 END IF;

                   END LOOP;

			   IF(min_found=1)THEN

					  Tab_ordre(indice) := nb;

			   ELSE
			         Tab_ordre(i) := nb;
			   END IF;

			    nb := nb + 1;

			  END IF;

            END LOOP;
	   END LOOP;


       --on calcule la difference entre le total des jours real et le total des jours approché pour toute l'anne
	   --pour trouver combien de fois,

	   nb := (NB_ACTIVITE-((nb_jour_annee-total)/0.5)+1);


	   -- il faudrais rajouter la valeur 0.5 au consu_prevu
	   -- la valeur 0.5 l'additionne au nb consu_prevu que la valeur enleve est plus grande


	   FOR k IN 1..NB_ACTIVITE LOOP

	          IF(k>=nb)THEN

                     Tab_a_real(k) := Tab_appr(k) + 0.5;

			  ELSE

			         Tab_a_real(k) := Tab_appr(k);

			  END IF;

			  Tab_diff(k) := Tab_a_real(k) - Tab_a_reestime(k);

	   END LOOP;


		 nb_ligne_matrice := 1;
		 --on remplis les matrices
		 OPEN l_a_conso (p_codsg,p_code_scenario,p_ident,p_type,p_moismens);

		 LOOP


		    FETCH l_a_conso  INTO v_CDEB, v_CODE_ACTIVITE, v_CONSO_PREVU;

	        IF l_a_conso%NOTFOUND THEN
	        EXIT;
	        END IF;

			        Tab_matrice_cdeb.extend;
					Tab_matrice_a.extend;

				    Tab_matrice_cdeb(Tab_matrice_cdeb.count) := v_CDEB;
				   	Tab_matrice_a(Tab_matrice_a.count) := v_CODE_ACTIVITE;
					Tab_matrice_conso(nb_ligne_matrice) := v_CONSO_PREVU;


			nb_ligne_matrice := nb_ligne_matrice + 1;

	     END LOOP;


		 CLOSE l_a_conso;



		--trier le tabelau Tab_diff an numeroter l'odre des valeurs dans la Tab_ordre


		FOR i IN 1..NB_ACTIVITE LOOP

		Tab_ordre(i) := 0;

		END LOOP;


		nb := 1;

		--remplire le tab_ordre, ou  on met le numero d'ordre des valeurs du tableaux tab_diff
		 FOR k IN 1..NB_ACTIVITE LOOP

		 FOR i IN 1..NB_ACTIVITE LOOP
		        IF(Tab_ordre(i)=0)THEN

                   min_found := 0;
			       mini := ABS(Tab_diff(i));

			       FOR j IN 1..NB_ACTIVITE LOOP

		               IF(Tab_ordre(j)=0)THEN

					       IF(mini > ABS(Tab_diff(j)))THEN

							   mini := ABS(Tab_diff(j));
			     		       min_found := 1;
						       indice := j;

						  END IF;
					 END IF;

                   END LOOP;

			   IF(min_found=1)THEN

					  Tab_ordre(indice) := nb;

			   ELSE
			          Tab_ordre(i) := nb;
			   END IF;

			    nb := nb + 1;

			  END IF;

            END LOOP;
	   END LOOP;



		--on initialise le tableau Tab_ajout
	    FOR i IN 1..12 LOOP

		     Tab_ajout(i) := 0;

		END LOOP;



			 i := NB_ACTIVITE;
			 WHILE  i>=1 LOOP

		     k := 1;

			 trouver := 0;
		     WHILE trouver=0 LOOP

			      IF(Tab_ordre(k)=i)THEN

				       trouver := 1;

				  ELSE

				       k := k + 1;

			      END IF;

			 END LOOP;


			 nb := ABS(Tab_diff(k)/0.5);

			 IF(nb>0)THEN

			       IF(Tab_diff(k)>0)THEN

						-- si la valeur est positif de l'activite numero k
							f := 1;
			                FOR j IN 1..nb LOOP
							trouver := 0;

							WHILE trouver=0 LOOP

							      IF( (MOD(Tab_ajout(f),0.5)=0) AND (Tab_ajout(f)<0) )THEN

								        trouver := 1;
										Tab_ajout(f) := 0;
										Tab_matrice_conso((k*NB_ACTIVITE)-NB_ACTIVITE+f) := Tab_matrice_conso((k*NB_ACTIVITE)-NB_ACTIVITE+f) + 0.5;


								  ELSIF(Tab_ajout(f)=0)THEN

								   		trouver := 1;
										Tab_ajout(f) := 0.5;
										Tab_matrice_conso((k*NB_ACTIVITE)-NB_ACTIVITE+f) := Tab_matrice_conso((k*NB_ACTIVITE)-NB_ACTIVITE+f) + 0.5;


								  ELSE

								        f := f + 1;

								  END IF;
								  IF(f>=12)THEN
								       trouver := 1;
									   Tab_ajout(1) := Tab_ajout(1) + 0.5;
									   Tab_matrice_conso((k*NB_ACTIVITE)-NB_ACTIVITE+f) := Tab_matrice_conso((k*NB_ACTIVITE)-NB_ACTIVITE+f) + 0.5;
                                   END IF;


							 END LOOP;--while

						END LOOP;--for


					ELSE

						    f := 1;
			                FOR j IN 1..nb LOOP
						    trouver := 0;
							WHILE trouver=0 LOOP

							     IF( (MOD(Tab_ajout(f),0.5)=0) and (Tab_ajout(f)>0) )THEN

								        trouver := 1;
										Tab_ajout(f) := 0;
										Tab_matrice_conso((k*NB_ACTIVITE)-NB_ACTIVITE+f) := Tab_matrice_conso((k*NB_ACTIVITE)-NB_ACTIVITE+f) - 0.5;


								  ELSE

								        f := f + 1;

								  END IF;
								  IF(f>=12)THEN
								       trouver := 1;
									   Tab_ajout(1) := Tab_ajout(1) - 0.5;
									   Tab_matrice_conso((k*NB_ACTIVITE)-NB_ACTIVITE+f) := Tab_matrice_conso((k*NB_ACTIVITE)-NB_ACTIVITE+f) - 0.5;
                                   END IF;


							 END LOOP;--while

						  END LOOP;--for

						END IF;



			 END IF;




		i := i - 1;
		END LOOP;--premier while


         --on fait une mise ajoure sur la table ree_reestime
		 FOR i IN 1..(nb_ligne_matrice-1) LOOP

		        UPDATE ree_reestime
			    SET conso_prevu=Tab_matrice_conso(i)
			    WHERE codsg=p_codsg
			         and code_scenario=p_code_scenario
					 and cdeb=Tab_matrice_cdeb(i)
					 and ident=p_ident
					 and code_activite=Tab_matrice_a(i);

		 END LOOP;


		 EXCEPTION
            WHEN OTHERS THEN raise; --RETURN 0;



	 END ree_saisie_init_tous;


   -- ------------------------------------------------------------------------
   -- Nom        : ree_saisie_initialise
   -- Auteur     : BAA
   -- Decription : c'est la methode major qui insere les lignes des consu_prevu pour chaque activite l'annee en cours
   --              inclus les activites absences si les activites existe
   --              sinon elle insere que des lignes de l'activites absences
   --
   -- Paramètres : p_codsg (IN) codsg du projet
   --              p_code_scenario  (IN) code du scenario
   --              p_ident  (IN) identifiant de la ressource
   -- Retour     : number  : numero de sequence > 0, 0 cas d'erreur
   --
   -- ------------------------------------------------------------------------

PROCEDURE ree_saisie_initialise( p_codsg 	     IN VARCHAR2,
				                 p_code_scenario IN ree_scenarios.code_scenario%TYPE,
							     p_ident         IN VARCHAR2
								) IS
	NB_ACTIVITE NUMBER;
	v_MOISMENS 	DATE;
	l_annee 	DATE;
	l_ident     ree_ressources.ident%TYPE;
	l_type		VARCHAR2(1);
BEGIN

    -- On supprime le type se trouvant à la fin de l'identifiant
	l_ident  := substr(p_ident,0,length(p_ident)-1);
	-- On récupère le type
	l_type   := substr(p_ident,length(p_ident),1) ;

    --On recupere le nombre d'activite
	SELECT COUNT(DISTINCT CODE_ACTIVITE) INTO NB_ACTIVITE
	  FROM REE_RESSOURCES_ACTIVITES
	 WHERE CODSG = to_number(p_codsg)
	   AND to_char(IDENT)||TYPE = p_ident;

    SELECT MOISMENS,DATDEBEX
	  INTO v_MOISMENS,l_annee
	  FROM DATDEBEX;

-- Correction de début d'annéé
	if (v_MOISMENS<l_annee) then
	   v_MOISMENS:=l_annee ;
	end if ;

    --on supprime toutes les lignes de la table ree_reestime s'il existe
	DELETE FROM ree_reestime
	 WHERE codsg = to_number(p_codsg)
	   AND code_scenario = p_code_scenario
	   AND to_char(IDENT)||TYPE = p_ident;


	--si il n'y a pas d'activite alors on insere que des lignes conçernant les activites absences
    IF (NB_ACTIVITE = 0) THEN
		ree_saisie_init_absences(to_number(p_codsg),p_code_scenario,to_number(l_ident),l_type,v_MOISMENS);
	ELSE
	--sinon on insere toutes les lignes pour toutes les activites inclus l'activite absences
	    ree_saisie_init_tous(to_number(p_codsg),p_code_scenario,to_number(l_ident),l_type,NB_ACTIVITE,v_MOISMENS);
    END IF;


EXCEPTION
    WHEN OTHERS THEN raise; --RETURN 0;

END ree_saisie_initialise;





-- ------------------------------------------------------------------------
-- Nom        : CalculOuvreAvantArrivee
-- Auteur     : JMA
-- Decription : permet de calculer le nombre de jour ouvré depuis le début du mois d'une date passer en paramètre
--
-- Paramètres : p_date (IN) date par rapport à laquelle le nb de jour ouvré est calculer
--
-- Retour     : number  : nb de jour ouvré avant la date donnée
--
-- ------------------------------------------------------------------------
FUNCTION CalculOuvreAvantArrivee( p_date IN DATE ) RETURN NUMBER IS
	modulo		NUMBER;
	ecart		NUMBER;
	nb_sem		NUMBER;
	jour_sem	NUMBER;
	indice		NUMBER;
	delta		NUMBER;
	d_jour		DATE;
BEGIN
	delta    := to_number(to_char(p_date,'dd'))-1;
	d_jour   := p_date;
	modulo   := mod(delta,7);
	nb_sem   := trunc(delta/7);
	jour_sem := to_number(to_char(d_jour, 'd'))-1;
	indice	 := 1 - jour_sem;

	-- cas spécifique du dimanche
	if ( (jour_sem=6) AND (modulo>0) ) then
	    modulo := modulo - 1;
	end if;

	if (modulo=0) then
	    ecart := nb_sem*5;
	else
		if (jour_sem<=modulo) AND (modulo<=(2+jour_sem)) then
		    ecart := (nb_sem*5) + jour_sem;
		else
			if (modulo<jour_sem) then
			    ecart := (nb_sem*5) + modulo;
			else
				ecart := (nb_sem*5) + modulo - ((jour_sem+indice)*2);
			end if;
		end if;
	end if;

	return ecart;

EXCEPTION
    WHEN OTHERS THEN
		 RETURN 0;

END CalculOuvreAvantArrivee;


END PACK_REE_SAISIE;
/


