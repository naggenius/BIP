package com.socgen.bip.commun;

import org.apache.struts.action.ActionForward;

import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.log.Log;

/**
 * @author N.BACCAM
 *
 * Cette classe définit un certain nombre de constantes
 * Ce sont des actions qui peuvent être utilisées dans l'application
 */
public interface BipConstantes
{
	//logger
	public static final Log logIhm = ServiceManager.getInstance().getLogManager().getLogIhm();
	public static final Log logJdbc = ServiceManager.getInstance().getLogManager().getLogJdbc();
	public static final Log logService = ServiceManager.getInstance().getLogManager().getLogService();
		
	// Action liées au servlets
	public static final String ACTION_CREER			= 	"creer";
	public static final String ACTION_VALIDER   	=   "valider" ;
	public static final String ACTION_MODIFIER		=	"modifier" ;
	public static final String ACTION_SUPPRIMER		=	"supprimer" ;
	public static final String ACTION_ANNULER		=	"annuler" ;
	public static final String ACTION_SUITE			=	"suite" ;
	public static final String ACTION_SUITE_1		=	"suite1" ;
	public static final String ACTION_REFRESH		= 	"refresh";
	public static final String ACTION_INIT			= 	"initialiser";
	public static final String ACTION_RETOUR		= 	"retour";
	
	// Actions pour la pagination pour l'affichage des listes
	public static final String PAGE_SUIVANTE 		= "suivant" ;
	public static final String PAGE_PRECEDENTE  	= "precedent" ;
	public static final String PAGE_FIN 			= "fin" ;
	public static final String PAGE_DEBUT 			= "debut" ;
	public static final String PAGE_INDEX 			= "index" ;

	// Action qui indique qu'il ne faut rien faire et qu'il faut retourner null
	// Cela sert lorsqu'un fichier est retourné et qu'il ne faut pas faire de forward
	// On renseigne la page d'accueil au cas où...
	public static final ActionForward PAS_DE_FORWARD = new ActionForward("http://bip.it.socgen");
	
	public static final String BIP_MENUXML		= "/WEB-INF/classes/bip_menu.xml";
	//Fichier de ressources poure les procédure PLS/SQL
	public static final String BIP_PROC 		= "bip_proc";
	public static final String BIP_REPORT 	= "bip_reports";
	public static final String BIP_LISTE_DYNAMIQUE = "bip_liste_dynamique";
	public static final String BIP_CFG_RBIPINTRA = "bip_remontee_intra";
	
	public static final String PREFIXE_ERR_ORA_BIP = "ORA-2";
	
//	Paramètres dans la ServletContext
	//Flag sur l'activitation des statistiques sur les pages
	public static final String STATISTIQUE_PAGE 		    = "STATISTIQUE_PAGE";
	//Identifiant Weborama
	public static final String ID_WEBORAMA 		    = "ID_WEBORAMA";

	//Identifiant Zone Groupe Weborama
	public static final String WEBO_ZONE_GROUPE 	= "WEBO_ZONE_GROUPE";
	  
	//Heure du démarrage du serveur
	public static final String TIME_START_SERVER 	= "TIME_START_SERVER";

//Paramètres en session
	//Libellé des champs actifs (dpg, centre de frais)
	public static final String LIB_INFO 		= "LIB_INFO";
	//Libellé de la filiale (ordonnancement)
	public static final String LIB_FILIALE 	= "LIB_FILIALE";
	//tableau des réestimés
	public static final String REESTIME_EN_MASSE ="listeReestimes";
	//tableau des proposés Mo
	public static final String PROPOSE_EN_MASSE 	="listeProposes";
	//	tableau des arbitrage
	public static final String ARBITRE_EN_MASSE 	="listeArbitre";
	//tableau des budgets des dossiers projet d'un departement
	public static final String BUD_DOSS_PROJ_DEP 	="listeBudDossProjDep";
	//actualites
	public static final String ACTUALITES 	="listeActus";
	//tableau des consommés
	public static final String CONSOMME_EN_MASSE ="listeConsos";
    //paramétrage ligne bip
	public static final String PARAM_LIGNE_BIP ="paramlignebip";	
	//tableau des multi-CA
	public static final String MULTI_CA ="listeCALigneBIP";
	//tableau des Activites du DPG (outil de reestime)
	public static final String ACTIVITE 	="listeActivites";	
	//tableau des lignes BIP selon activite et DPG (outil de reestime)
	public static final String ACTIVITE_LIGNE 	="listeActivitesLignes";	
	//tableau des Scénarios du DPG (outil de reestime)
	public static final String SCENARIO 	="listeScenarios";	
	//	tableau des ressource du DPG (outil de reestime)
	public static final String RESSREES 	="listeRessRees";	
	public static final String RESSACT 	="listeRessAct";
	
    //	tableau des écarts de saisis pour les ressources
	public static final String  ECARTS	="listeEcarts";
	
    // tableau des écarts de saisis pour les ressources
	public static final String  ECARTPOLE	="listeEcartPole";
	
    // tableau des écarts de saisis pour les ressources
	 public static final String  MESSAGEECARTS	="messageEcarts";
	 
	//	tableau des écarts de saisis pour les budgets
	public static final String  ECARTSBUDGETS	="listeEcartsBudgets";
	
	// tableau des écarts de saisis pour les budgets
	public static final String  ECARTBUDGETPOLE	="listeEcartBudgetPole";
	
	// tableau des écarts de saisis pour les budgets
	 public static final String  MESSAGEECARTSBUDGETS	="messageEcartsBudgets";	 
	
	//Liste de recherche de l'ID des Personnes
	public static final String LISTE_RECHERCHE_ID 	="listeRechercheId";
	
	//Liste de recherche des matricules des personnes
	public static final String LISTE_RECHERCHE_MATRICULES ="listeRechercheMatricules";
	
	//Liste de recherche de l'ID investissement
	public static final String LISTE_RECHERCHE_INVEST 	="listeRechercheInvest";
	//Liste de recherche des codes de dossier de projet
	public static final String LISTE_RECHERCHE_DOS_PROJ 	="listeRechercheDosProj";
	//Liste de recherche de l'ID d'une societe
	public static final String LISTE_RECHERCHE_ID_SOCIETE 	="listeRechercheIdSociete";
//	Liste de recherche de l'ID d'une societe
	public static final String LISTE_RECHERCHE_ID_SOCIETE_OUVERT 	="listeRechercheIdSocieteouvert";
//	Liste de recherche de l'ID d'une direction
	public static final String LISTE_RECHERCHE_ID_DIRECTION 	="listeRechercheIdDirection";
//	Liste de recherche de l'ID d'une branche
	public static final String LISTE_RECHERCHE_ID_BRANCHE 	="listeRechercheIdBranche";
//	Liste de recherche de l'ID d'un traitement
	public static final String LISTE_RECHERCHE_ID_TRAITEMENT 	="listeRechercheIdTraitement";

	//Liste de recherche de l'ID d'une societe
	public static final String LISTE_RECHERCHE_ID_CA 	="listeRechercheIdCa";
	
    //Liste de recherche de l'ID d'un client
	public static final String LISTE_RECHERCHE_ID_MO 	="listeRechercheIdMo";
	
    //Liste de recherche de l'ID d'un client
	public static final String LISTE_RECHERCHE_ID_FOURCOPI	="listeRechercheIdFourCopi";
	
	//Liste de recherche de l'PID d'une lignebip
	public static final String LISTE_RECHERCHE_PID 	="listeRecherchePID";
	
    //Liste de recherche d'un numéro contrat
	public static final String LISTE_RECHERCHE_CONTRAT 	="listeRechercheContrat";
	
	//Liste de recherche d'un numéro contrat
	public static final String LISTE_RECHERCHE_FACTURE 	="listeRechercheFacture";

	//Liste de recherche de l'ID des Personnes
	public static final String LISTE_RECHERCHE_CODREP 	="listeRechercheTabRepart";
	
	//Liste de recherche des DP Copi
	public static final String LISTE_RECHERCHE_DPCOPI 	="listeRechercheDpCopi";
	
	//Ligne BIP active dans Saisie des réalisés
	public static final String PID ="PID";
	//Libellé de la ligne BIP active dans Saisie des réalisés
	public static final String PNOM ="PNOM";

	//tableau des réestimés dans Outil de Réestimé par Ressources
	public static final String REESTIME ="listeReestimes";
   
	public static final String DEFAULT_LISTE_FILNAME="rBip.lst";

	//tableau des messages du forum
	public static final String MESSAGE_FORUM ="listeMessageForum";
	public static final String DISCUSSION_FORUM ="listeDiscussionForum";

//nom des variables d'environnements
	//pour les remonteurs
	public static final String REPERTOIRE_LISTE = "BIP_REMONTEUR";
	public static final String FICHIER_LISTE="BIP_FICHIER_REMONTEUR";
	//pour les reports
	public static final String REPORT_SERVER = "REPORT_SERVER";
	public static final String DIR_REPORT_CMD = "DIR_INTRA_EXECREPORTS";
	public static final String REPORT_CMD = "EXECREPORTS";
	public static final String DIR_REPORT_IN = "DIR_REPORT";
	public static final String DIR_REPORT_OUT = "DIR_REPORT_OUT";
	public static final String DIR_DATA = "BIP_DATA";
	
	public static final String MENU_COULEUR_FOND = "MENU_COULEUR_FOND";
	public static final String MENU_LIB_ENV = "MENU_LIB_ENV";
	
	public static String FICHIER_BIP = "BIP";
	public static String FICHIER_PBIP = "PBIP";
	public static String FICHIER_BIPS = "BIPS";//PPM 60612
	public static String sBipExtension = ".bip";
	public static String sPBipExtension = ".pbip";
	public static String sPBipsExtension = ".bips";//PPM 60612
	
	public static String ID_PERSONNE = "ID_PERSONNE";
	
	public static String BUDGET_COPI_EN_MASSE="listeBudgetCopi";
	
	public static String TRAITEMENT_BATCH="traitementbatch";
	public static String BEAN_RESSOURCE="listeBeanRess";
	
}
