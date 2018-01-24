package com.socgen.bip.user;

//Import des classes générales
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.StringTokenizer;
import java.util.Vector;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.socgen.afe.afer.envc1.common.SocgenUser;
import com.socgen.bip.commun.BipConfigRTFE;
import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.menu.BipMenuManager;
import com.socgen.bip.menu.item.BipItemMenu;
import com.socgen.bip.metier.ParametreBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;

/**
 * @author Pierre JOSSE RSRH/ICH/GMO
 * Objet de session contenant les caractéristiques de l'utilisateur connecté.
 */

public class UserBip implements BipConstantes
{
	static Log logBipUser = BipAction.getLogBipUser();
	static Config configProc = ConfigManager.getInstance("bip_proc") ;
	static Config cfgSQL = ConfigManager.getInstance("sql");
	private static String sProcFiliale = "SQL.filiale";
	
	private static String PACK_INSERT 			= "connexion.creer.proc";
	private static String PACK_LISTE = "alertes.actualites.liste.proc";
	
	
	// ****Déclaration des variables d'instance du user****
	
	/** 
	 * Booléen qui dit si le User est habilité à la BIP
	 */
	private boolean habiliteBip = false;
	
	//**** Données concernant la filiale****
	/**
	 * Code de la filiale par défaut. (Sur deux chiffres mais sur 3 chars)
	 */
	private static String FIL_CODE_DEFAUT = "01 ";
	/**
	 * Code de la filiale
	 */
	private String filCode = FIL_CODE_DEFAUT;
	/**
	 * Code centre activité courant
	 */
	private String codcamoCourant = null;
	// ****Données du RTFE****
	/**
	 * Identifiant RTFE de l'utilisateur : "ID arpège" pour la zone arpège, "prénom.nom" pour SGIB
	 */
	private String idUser = null;
	/**
	 * Nom de l'utilisateur
	 */
	private String nomUser = null;
	
	/**
	 * Prénom de l'utilisateur
	 */
	private String prenomUser = null;
	
	// ****Données relatives aux Menus****	
	/**
	 * Listes des menus dont l'utilisateur à le droit d'accéder
	 */
	//private Vector listeMenu = null;
	private String sListeMenu = null;
	/**
	 * Listes des sous-menus dont l'utilisateur à le droit d'accéder
	 */
	private String sSousMenus = null;
	
	/**
	 * Menu auquel l'utilisateur est connecté en ce moment
	 */
	//private MenuIdBean menuUtil = null;
	private BipItemMenu currentMenu = null;
	
	// ****Données relatives aux BDDPG****
	/**
	 * Liste des BDDPG de l'utilisateur(séparateur : ",")
	 * Correspond au périmètre ME
	 */
	private Vector perim_ME = null;
	/**
	 * DPG par défaut de l'utilisateur
	 */
	private String dpg_Defaut = null;
	
	//****Code ressource du chef de projet****
	/**
	 * Codes ressources du chef de projet
	 */
	private Vector<String> chefProjet = null;
	
	// ****Données relatives aux Périmètres MO pour les utilisateurs non Client MO****
	/**
	 * Liste des CLIDOM des l'utilisateur (séparateur : ",")
	 * Correspond au périmètre MO
	 */
	private Vector perim_MO = null;
	
//	 ****Données relatives aux Périmètres MO pour les utilisateurs Client MO uniquement****
	/**
	 * Liste des CLIDOM des l'utilisateur (séparateur : ",")
	 * Correspond au périmètre MCLI
	 */
	private Vector perim_MCLI = null;
	
	/**
	 * Liste des CA Payeur auxquels l'utilisateur est habilité
	 */
	private Vector sCADA = null;
	
	/**
	 * Direction MO par défaut de l'utilisateur
	 */
	private String clicode_Defaut = null;
	
	/**
	 * Liste des centres de frais de l'utilisateur(séparateur : ",") dans une seul chaine
	 */
	private String liste_Centres_Frais = null;	
	
	
	/**
	 * Liste des centres de frais de l'utilisateur(séparateur : ",")
	 */
	private Vector liste_CF = null;
	
	
	
	
	//****Données relatives à l'ordonancement****
	/**
	 * Centre de frais
	 */
	private String centre_Frais = null;
	
	/**
	 * Liste des CA auxquels l'utilisateur est habilité
	 * Pour le suivi d'investissement
	 */
	private Vector ca_suivi = null;
	
	//	****Données relatives à l'habilitation par référentiel****
	/**
	 * Liste des Dossier projets auxquels l'utilisateur est habilité
	 */
	private String sDossProj = null;
	
	/**
	 * Liste des Projets auxquels l'utilisateur est habilité
	 */
	private String sProjet = null;
	
	/**
	 * Liste des Applications auxquelles l'utilisateur est habilité
	 */
	private String sAppli = null;
	
	/**
	 * Liste des CA FI auxquels l'utilisateur est habilité
	 */
	private String sCAFI = null;
	
	/**
	 * Liste des CA Payeur auxquels l'utilisateur est habilité
	 */
	private String sCAPayeur = null;
		
	/**
	 * Lien du Favori lors de la navigation inter-menu
	 */
	private String sLienFavori = null;
	
	/**
	 * Lien du Favori lors de la navigation inter-menu
	 */
	private String existeAlerte = "NON";
	
	/**
	 * Message d'erreur à afficher en cas de contrôle du RTFE négatif
	 */
	private String erreurRTFE = "";
	
	private String message="";
	
	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
	/**
	 * Constructeur de l'objet de session de l'utilisateur
	 * Tous les variables d'instances sont initialisées avec les données du RTFE
	 * Sauf la variable menuUtil. Par défaut cette variable est à null.
	 * @param id Identifiant de l'utilisateur connecté
	 * @param password Mot de passe RTFE de l'utilisateur
	 * @see java.lang.Object#Object()
	 */
	public UserBip(SocgenUser u) {
		// On extrait les données et met à jour les variables d'instance
		String userId = (((String[])u.getAttribute("uid"))[0]).toString();
		// Génération automatique des identifiants demandee par Antoine en mode bouchon
		//userId = UserIDGenerator.getNextID();
		logBipUser.info("+++++"+userId);
		//this.prenomUser = (String) u.getAttribute("givenname");
		this.prenomUser = (((String[])u.getAttribute("givenname"))[0]).toString();
		logBipUser.info("+++++"+prenomUser);
		//this.nomUser =(String) u.getAttribute("sn");
		this.nomUser = (((String[])u.getAttribute("sn"))[0]).toString();
		logBipUser.info("+++++"+nomUser);
		Hashtable roles = u.getRoleAttributes();

		logBipUser.info("+++++"+roles.size());
		
		//for (int i=0; i<roles.size(); i++) {
		for (Iterator iter = u.getRoleAttributes().keySet().iterator(); iter.hasNext();) {
			this.habiliteBip = true;
			String roleId = (String) iter.next();
			logBipUser.info("+++++"+roleId);
			// Si le nom du rôle n'est pas null
			// On met à jours les paramètres du rôle dans UserBip
			if (roleId != null) {
				try {
					recupParamsPourRole(u.getRoleAttributes().get(roleId));
				} catch (BipException e) {
					// TODO Bloc catch auto-généré
					BipAction.logBipUser.error("Error. Check the code", e);
				}
			}
		}
		this.recupInfosRTFE(userId);
		existAlertesActu();
	}
	
	public UserBip() {
		
	}
	
	/**
	 * Initialisation de l'utilisateur, utilisée pour l'édition des profils à partir d'une liste de ressources
	 *
	 */
	public void init() {
		// Initialisation des attributs de l'utilisateur. Le sous-menu par défaut est admin.
		sListeMenu ="";
		sSousMenus="admin";
		dpg_Defaut="";
		perim_ME=new Vector();
		chefProjet=new Vector();
		clicode_Defaut="";
		perim_MO=new Vector();
		perim_MCLI=new Vector();
		liste_Centres_Frais="";
		ca_suivi=new Vector();
		sProjet="";
		sAppli="";
		sCAFI="";
		sCAPayeur="";
		sCADA=new Vector();
		sDossProj="";
		centre_Frais="";
		filCode="";
	}
	
	//****Méthodes qui interrogent le RTFE et qui met à jour les attibuts de la classe****
	/**
	 * Interroge le RTFE sur l'utilisateur et récupère les paramètres
	 * Met à jour les attributs du Bean
	 */
	
	public void recupInfosRTFE(String userID) {
		/**
		 * On met à jour les données relatives au RTFE
		 */
		this.idUser = userID.toUpperCase();
		logBipUser.info(idUser);
		
		/**
		 * On enregistre dans la table RTFE_LOG  la connexion du l'utilisateur
		 */ 
		InsertInfoLog(this.idUser);
		
		/**
		 * Si le user a au moins un rôle BIP,
		 * On valide l'utilisateur comme étant un utilisateur BIP
		 * On récupère la liste des ses rôles
		 * Et on met à jour les attributs de UserBip
		 * Qui sont récupérés depuis les rôles de l'utilisateur
		 */
		 alimCtrFraisEtCodeFil();
		//ABN - HP PPM 61422
		 //logBipUser.error("Chargement config RTFE dans UserBIP de l'utilisateur : " + this.idUser);
		 //Demande Antoine - PPM 64631
		//BipConfigRTFE.getInstance().rechargerConfigRTFE();
	}
	
	/**
	 * Alimentation du centre de frais et du code filliale
	 */
	public void alimCtrFraisEtCodeFil() {
		// Initialisation du centre de frais une fois qu'on a tout traité
		if (this.liste_CF != null){
			this.centre_Frais = (String)(this.liste_CF).get(0);
		}	
		
		if (this.centre_Frais != null)	{		
			JdbcBip jdbc = new JdbcBip(); 
			
			//on recupere le filcode du centre de frais
			String sSQL = cfgSQL.getString(sProcFiliale);
			sSQL += "'"+ this.centre_Frais +"'";
			try
			{
				this.filCode = jdbc.recupererInfo(sSQL);
			}
			catch (BaseException bE)
			{
				logService.error("RecupInfosRTFE : Erreur dans la récuperation de la filiale " + sSQL, bE);
			}
			
			jdbc.closeJDBC();
		}		
	}
	
	/**
	 * Méthode qui récupère les paramètres d'un rôle
	 * Et qui met à jour les attributs de UserBip
	 * @param roles listes des rôles du l'utilisateur pour la BIP
	 * @param roleId Nom du rôle en cours de traitement
	 */	
	public void recupParamsPourRole(Hashtable roleParams) throws BipException{
		logBipUser.info("++++recupParamsPourRole");
		// Nom du paramètre
		String paramId = new String();
		// Liste des valeurs du paramètre(En fait ce n'est qu'une liste de 1)
		String[] values = null;
		
		//logBipUser.info("Role = " + roleId);				
		// Si la liste des paramètres n'est pas null
		if (roleParams != null) {
			logBipUser.info("++++roleParams != null");
			// On créé un iterator contenant la liste des paramètres
			
			logBipUser.info("Taille de la HashTable: " + roleParams.size()); 
			 
		    Iterator itValue = roleParams.values().iterator(); 
		    Iterator itKey = roleParams.keySet().iterator();
		 
		    while(itValue.hasNext()){ 
		    	paramId = (String)itKey.next();
				logBipUser.info("++++" + paramId);
				String value = (String) itValue.next();
				logBipUser.info("++++" + value);
		    	values = ((String) value).split(",");
				this.metAJourParam(paramId, values);		 
		    } 
		}
	}
	
	
	/**
	 * Permet de mettre à jour un attribut de Bip
	 * A partir de paramètres récupérés du RTFE
	 * @param paramId Nom du paramètre
	 * @param values Liste des valeurs correspondant au paramètre.
	 */
	private void metAJourParam(String paramId, String[] values/*, Hashtable tousLesMenus*/){
		// Nombre de valeurs du paramètre(En fait c'est 1)
		int n = 0;
		// Valeur du paramètre
		String value = new String();
		
		if (values != null) {
			n = values.length;
			for (int i = 0; i < n; i++) {
				value = values[i];
				
				logBipUser.info(paramId + " = " + value);
				
				if (value!=null && !("".equals(value)) ){
					/**
					 * Recherche du nom du paramètre et mise à jour
					 */
					//Est ce que c'est la liste des menus?
					if (paramId.equalsIgnoreCase("Menus"))
					{
						if (sListeMenu == null)
							sListeMenu = value;
						else
							sListeMenu += ","+value;			
					}
					
					//Est ce que c'est une liste de Sous Menus
					else if (paramId.equalsIgnoreCase("Ss_Menus")){
						if ((this.sSousMenus == null)||("".equals(this.sSousMenus))) this.sSousMenus = value.toLowerCase();
						else this.sSousMenus += ',' + value.toLowerCase();
					}
					
					//Est ce que c'est le BDDPG par défaut?
					else if (paramId.equalsIgnoreCase("BDDPG_defaut")){
						if (value.length() == 11){
							this.dpg_Defaut = value.substring(4,11);
							logBipUser.info("DPG_defaut : " + dpg_Defaut);
						}
						else if(value.length() > 0){
							this.dpg_Defaut = value;
							logBipUser.info("DPG_defaut : " + dpg_Defaut);
						}
					}
					
					//Est ce que c'est le périmètre ME?
					else if (paramId.equalsIgnoreCase("Perim_ME")){
						if (this.perim_ME == null){
							this.perim_ME = new Vector();
						}
						// On met à jour le vecteur contenant les périmètres ME
						StringTokenizer strtkPerim_ME = new StringTokenizer(value, ",");
						while (strtkPerim_ME.hasMoreTokens()){
							String lePerim = strtkPerim_ME.nextToken();
							if (!perim_ME.contains(lePerim)) {
								this.perim_ME.addElement(lePerim);
							}
						}
					}
					
					//Est ce que c'est le code ressource du chef de projet?
					else if (paramId.equalsIgnoreCase("Chef_Projet")){
						if (this.chefProjet == null){
							this.chefProjet = new Vector();
						}
						// On met à jour le vecteur contenant les périmètres ME
						//KRA PPM 61776 : décoder le codeRess*
						  // if(value.contains("*")){
							   value = Tools.lireListeChefsProjet(value);
						  // }
						//Fin KRA
						StringTokenizer strtkChef_Projet = new StringTokenizer(value, ",");
						while (strtkChef_Projet.hasMoreTokens()){
							String leChef=strtkChef_Projet.nextToken();
							if (!chefProjet.contains(leChef)) {
								this.chefProjet.addElement(leChef);
							}
						}
					}
					
					//Est ce que c'est une direction par défaut?
					else if (paramId.equalsIgnoreCase("MO_defaut")){
						this.clicode_Defaut = value;
					}
					
					//Est ce que c'est le périmètre MO?
					else if (paramId.equalsIgnoreCase("Perim_MO")){
						if (this.perim_MO == null){
							this.perim_MO = new Vector();
						}
						// On met à jour le vecteur contenant les périmètres MO
						StringTokenizer strtkPerim_MO = new StringTokenizer(value, ",");
						while (strtkPerim_MO.hasMoreTokens()){
							String lePerim = strtkPerim_MO.nextToken();
							if (!perim_MO.contains(lePerim)) {
								this.perim_MO.addElement(lePerim);
							}
						}
					}	//Est ce que c'est le périmètre MCLI?
					else if (paramId.equalsIgnoreCase("Perim_MCLI")){
						if (this.perim_MCLI == null){
							this.perim_MCLI = new Vector();
						}
						// On met à jour le vecteur contenant les périmètres MO
						StringTokenizer strtkPerim_MCLI = new StringTokenizer(value, ",");
						while (strtkPerim_MCLI.hasMoreTokens()){
							String lePerim = strtkPerim_MCLI.nextToken();
							if (!perim_MCLI.contains(lePerim)) {
								this.perim_MCLI.addElement(lePerim);
							}
						}
					}
					
					//Est ce que c'est le centre de frais?
					else if (paramId.equalsIgnoreCase("Centre_Frais")){
						if (this.liste_CF == null){
							this.liste_CF = new Vector();
						}
						// On met à jour le vecteur contenant les centres des frais
						
						StringTokenizer strtkPerim_CF = new StringTokenizer(value, ",");
						while (strtkPerim_CF.hasMoreTokens()){
							String leCf = strtkPerim_CF.nextToken();
							if (!liste_CF.contains(leCf)) {
								this.liste_CF.addElement(leCf);
								// On renseigne la liste des centres de frais (string)
								if (this.liste_Centres_Frais != null)
									this.liste_Centres_Frais += "," + leCf;
								else
									this.liste_Centres_Frais = leCf;
							}
						}
					}
					
					
					// Est ce que c'est un CA pour le suivi d'investissements?
					else if (paramId.equalsIgnoreCase("CA_Suivi")){
						if (this.ca_suivi == null){
							this.ca_suivi = new Vector();
						}
						// On met à jour le vecteur contenant les périmètres MO
						StringTokenizer strtkCA_Suivi = new StringTokenizer(value, ",");
						while (strtkCA_Suivi.hasMoreTokens()){
							String leCA = strtkCA_Suivi.nextToken();
							if (!this.ca_suivi.contains(leCA)) {
								this.ca_suivi.addElement(leCA);
							}
						}
					}
										
					//Est ce que une liste de dossiers projets
					else if (paramId.equalsIgnoreCase("Doss_proj")){
						if ((this.sDossProj==null) || ("".equals(this.sDossProj))) this.sDossProj = value;
						else this.sDossProj += ',' + value;
					}
					
					//Est ce que une liste de projets
					else if (paramId.equalsIgnoreCase("Projet")){
						if ((this.sProjet==null) || ("".equals(this.sProjet))) this.sProjet = value;
						else this.sProjet += ',' + value;
					}
					
					//Est ce que une liste d'applications
					else if (paramId.equalsIgnoreCase("Appli")){
						if ((this.sAppli==null) || ("".equals(this.sAppli))) this.sAppli = value;
						else this.sAppli += ',' + value;
					}
					
					//Est ce que une liste de CA FI
					else if (paramId.equalsIgnoreCase("CA_FI")){
						if ((this.sCAFI==null) || ("".equals(this.sCAFI))) this.sCAFI = value;
						else this.sCAFI += ',' + value;
					}
					
					//Est ce que une liste de CA Payeurs
					else if (paramId.equalsIgnoreCase("CA_Payeur")){
						if ((this.sCAPayeur==null) || ("".equals(this.sCAPayeur))) this.sCAPayeur = value;
						else this.sCAPayeur += ',' + value;
					}
					
//					Est ce que une liste de CA DA
					else if (paramId.equalsIgnoreCase("CA_DA")){
						if (this.sCADA == null){
							this.sCADA = new Vector();
						}
					
					// On met à jour le vecteur contenant les CA DA
					StringTokenizer strtkCA_Suivi = new StringTokenizer(value, ",");
						while (strtkCA_Suivi.hasMoreTokens()){
							String leCA = strtkCA_Suivi.nextToken();
							if (!this.sCADA.contains(leCA)) {
								this.sCADA.addElement(leCA);
							}
						}
					}
										
				}
			}
			
		}
		
	}
	
	
	//**** Méthode de vérification des droits de l'utilisateur ****
	/**
	 * Vrai si l'utilisateur a des autorisations d'accès à la Bip
	 * @return boolean
	 */
	public boolean isHabiliteBip() {
		return habiliteBip;
	}
	
	/**
	 * Vrai si l'utilisateur a accès au menu Administration
	 * @return boolean
	 */
	public boolean isAdministrateur() {
		boolean bR = false;
		Vector v = getListeMenu();
		StringBuffer sb = new StringBuffer();
		for (Enumeration vE=v.elements(); vE.hasMoreElements(); ) {
			BipItemMenu bim = (BipItemMenu) vE.nextElement();
			if (bim.getId().equals("DIR")) return true;
		}
		return bR;
	}
	
	//**** Accesseurs liés aux données RTFE de l'utilisateur****
	/**
	 * Retourne l'ID RTFE du user. 
	 * Si le user est dans la zone arpège : "ID Arpège"
	 * Si le user est dans la zone SGIB : "prenom.nom"
	 * @return String
	 */
	public String getIdUser() {
		return idUser;
	}
	
	/**
	 * Alimentation de l'attribut idUser
	 * @param idUser
	 */
	public void setIdUser(String idUser) {
		this.idUser = idUser;
	}
	
	//**** Accesseurs liés aux menus****
	/**
	 * Retourne la liste des menus auxquels est habilité l'utilisateur
	 * @return Vector
	 */
	public Vector getListeMenu()
	{
		if (sListeMenu == null)
			return null;
		
		Vector v = BipMenuManager.getInstance().getListeBipMenu(sListeMenu);
		
		/*for (int i = 0; i<v.size(); i++)
		 {
		 logService.debug( ((BipItemMenu)v.elementAt(i)).getId());
		 }*/
		
		return v;
	}
	
//	**** Accesseurs liés à la config des menus****
	/**
	 * Retourne la liste des libellés des menus auxquels est habilité l'utilisateur
	 * y compris ceux qui n'existent pas
	 * @return Vector
	 */
	public Vector getListeMenuConfig()
	{
		if (sListeMenu == null)
			return null;
		
		Vector v = BipMenuManager.getInstance().getListeBipMenuConfig(sListeMenu);
		
		/*for (int i = 0; i<v.size(); i++)
		 {
		 logService.debug( ((BipItemMenu)v.elementAt(i)).getId());
		 }*/
		
		return v;
	}
	
	/**
	 * Retourne la liste des menus auxquels est habilité l'utilisateur en form d'une chaine avec le separaterur ','
	 * @return String
	 */
	public String getsListeMenu()
	{
		
		return sListeMenu;
	}
	
	/**
	 * Retourne le menu en cours de consultation par l'utilisateur.
	 * Si donnée non renseignée, la valeur retournée est null
	 * @return MenuIdBean
	 */
	public BipItemMenu getCurrentMenu() {
		return currentMenu;
	}
	/**
	 * Met à jour le menu demandé par l'utilisateur
	 * @param menuUtil Le nom du menu qui est demandé par l'utilisateur
	 */
	public void setCurrentMenu(BipItemMenu currentMenu)
	{
		this.currentMenu = currentMenu;
	}
	/**
	 * Renvoie vrai si le menu en String est contenu dans la liste des menus
	 * @param menuUtil Le nom du menu qui est demandé par l'utilisateur
	 */
	public boolean habiliteMenu(String menu)
	{
		if ((sListeMenu!= null) && 
				((sListeMenu.toUpperCase()).indexOf(menu.toUpperCase()) >= 0) )
			return true;
		
		return false;
	}
	/**
	 * @return
	 */
	public String getSousMenus() {
		
		String SousMenusRetourne = new String();
		
		if (sSousMenus!= null) {
			return sSousMenus;
		}
		else {
			SousMenusRetourne = "";
			return SousMenusRetourne;
		}
	}
	
	
	//****Accesseurs liés aux attributs relatifs aux BDDPG****
	/**
	 * Retourne la liste des BDDPG auxquels l'utilisateur est autorisé
	 * Si donnée non renseignée, la valeur retournée est null
	 * @return Vector
	 */
	public Vector getPerim_ME()
	{
		if (perim_ME == null)
			return null;
		
		return (Vector) perim_ME.clone();
	}
	
	/**
	 * Retourne le DPG du BDDPG par défaut.
	 * Si donnée non renseignée, la valeur retournée est null
	 * @return String
	 */
	public String getDpg_Defaut() {
		if (dpg_Defaut == null) return null;
		else if (dpg_Defaut.length() == 7) return dpg_Defaut;
		else if (dpg_Defaut.length() == 6) return "0" + dpg_Defaut;
		else if (dpg_Defaut.length() == 5) return "00" + dpg_Defaut;
		else return null;
	}
	
	public String getDpg_Defaut_Etoile(){
		String dpg = getDpg_Defaut();
		if(dpg!=null){

			if (Pattern.matches("0000000", dpg)) return "*******";
			if (Pattern.matches("([0-9][0-9][0-9])0000", dpg)) return dpg.replaceAll("([0-9][0-9][0-9])0000","$1****");
			if (Pattern.matches("([0-9][0-9][0-9][0-9][0-9])00", dpg)) return dpg.replaceAll("([0-9][0-9][0-9][0-9][0-9])00","$1**");
			if (Pattern.matches("00000", dpg)) return "*****";
			if (Pattern.matches("([0-9][0-9][0-9])00", dpg)) return dpg.replaceAll("([0-9][0-9][0-9])00","$1**");

			return dpg;
		}else return null;
		
		
	}
	
	/**
	 * Met à jour le DPG par défaut
	 * @param dpg_Defaut Le nouveau DPG à mettre à jour
	 */
	public void setDpg_Defaut(String dpg_Defaut) {
		this.dpg_Defaut = dpg_Defaut;
	}
	
	
	//****Code ressource du chef de projet****
	/**
	 * Retourne les codes ressources des chefs de projet
	 * Si donnée non renseignée, la valeur retournée est null
	 * @return Vector
	 */
	public Vector<String> getChefProjet() {
		if (chefProjet == null)
			return null;
	
		return new Vector<String>(chefProjet);
	}	
		
	
	// ****Données relatives aux Périmètres MO****
	/**
	 * Retourne la liste des CLIDOM auxquels l'utilisateurs est autorisé
	 * Si donnée non renseignée, la valeur retournée est null
	 * @return Vector
	 */
	public Vector getPerim_MO() {
		if (perim_MO == null) return null;
		else return (Vector) perim_MO.clone();
	}
	
	/**
	 * @return
	 */
	public Vector getCADA() {
		if (sCADA == null) return null;
		else return (Vector) sCADA.clone();
	}
	
	/**
	 * Rentourne le CLICOD par défaut de l'utilisateur
	 * Si donnée non renseignée, la valeur retournée est null
	 * @return String
	 */
	public String getClicode_Defaut() {
		return clicode_Defaut;
	}
	/**
	 * Met à jour le Clicode par défaut
	 * @param clicode_Defaut Le nouveau code par défaut.
	 */
	public void setClicode_Defaut(String clicode_Defaut) {
		this.clicode_Defaut = clicode_Defaut;
	}
	
	
	//****Données relatives à l'ordonancement****
	/**
	 * Retourne le code de la filiale
	 * Si donnée non renseignée, la valeur retournée est null
	 * @return String
	 */
	public String getFilCode() {
		return filCode;
	}
	/**
	 * Met à jour le code de la filiale
	 * @return String
	 */
	public void setFilCode(String newFilCode) {
		this.filCode = newFilCode;
	}
	//****Données relatives au suivi investissemnt****
	/**
	 * Retourne le codcamo courant
	 * Si donnée non renseignée, la valeur retournée est null
	 * @return String
	 */
	public String getCodcamoCourant() {
		return codcamoCourant;
	}
	/**
	 * Met à jour le codcamo courant
	 * @return String
	 */
	public void setCodcamoCourant(String newCodcamoCourant) {
		this.codcamoCourant = newCodcamoCourant;
	}
	
	
	/**
	 * Retourne la liste des codes des centre de frais de l'utilisateur dans une seul chaine de caractere
	 * Si donnée non renseignée, la valeur retournée est null
	 * @return String
	 */
	public String getListe_Centres_Frais() {
		return liste_Centres_Frais;
	}
	
	
	/**
	 * Retourne la liste des codes des centre de frais de l'utilisateur
	 * Si donnée non renseignée, la valeur retournée est null
	 * @return String
	 */
	public String getCentre_Frais() {
		return centre_Frais;
	}
	
	/**
	 * Retourne les CA auxquels sont habilités l'utilisateur pour le suivi d'investissement
	 * @return Vector
	 */
	public Vector getCa_suivi() {
		return ca_suivi;
	}
	
	
	//****Méthodes spéciales pour les packages****
	/**
	 * Méthode qui renvoie la chaîne d'informations de l'utilisateur connecté
	 * Cette méthode est utilisée dans les packages SQL
	 * Le String retournée est de la forme : 
	 * ID du User; Menu courrant; Clicode par défaut; Code DPG par défaut; Code Filliale courant, 
	 * Périmètre ME, Périmètre MO, Code centre de frais, Code chef de projet
	 */
	public String getInfosUser() {
		String chaineRetournee = new String();
		if (idUser!=null) chaineRetournee += idUser + ";";
		else chaineRetournee += ";";
		
		if (currentMenu!=null) chaineRetournee += currentMenu.getId() + ";";
		else chaineRetournee += ";";
		
		if (clicode_Defaut!=null) chaineRetournee += clicode_Defaut + ";";
		else chaineRetournee += ";";
		
		if (dpg_Defaut!=null) chaineRetournee += dpg_Defaut + ";";
		else chaineRetournee += ";";
		
		if (filCode!=null) chaineRetournee += filCode + ";";
		else chaineRetournee += ";";
		
		if (perim_ME!=null) {
			// On retourne la liste des périmètres avec pour séparateur la virgule
			for(int i =0; i < perim_ME.size(); i++){
				chaineRetournee += (String) perim_ME.elementAt(i);
				if (i != (perim_ME.size()-1)) chaineRetournee += ",";
			}
		}
		chaineRetournee += ";";
		
		if (perim_MO!=null) {
			// On retourne la liste des périmètres avec pour séparateur la virgule
			for(int i =0; i < perim_MO.size(); i++){
				chaineRetournee += (String) perim_MO.elementAt(i);
				if (i != (perim_MO.size()-1)) chaineRetournee += ",";
			}
		}

		chaineRetournee += ";";
				
		if (centre_Frais!=null) chaineRetournee += centre_Frais;
		chaineRetournee += ";";
		
		if (chefProjet!=null) {
			String leChefProjet;
			// On retourne la liste des chefs de projets avec pour séparateur la virgule
			for(int i =0; i < chefProjet.size(); i++){
				leChefProjet = (String) chefProjet.elementAt(i);
				// On vérifie que c'est bien formaté sur 5 caractères
				if (leChefProjet.length() == 1) leChefProjet = "0000".concat(leChefProjet);
				else if (leChefProjet.length() == 2) leChefProjet = "000".concat(leChefProjet);
				else if (leChefProjet.length() == 3) leChefProjet = "00".concat(leChefProjet);
				else if (leChefProjet.length() == 4) leChefProjet = "0".concat(leChefProjet);
				
				chaineRetournee += leChefProjet;
				if (i != (chefProjet.size()-1)) chaineRetournee += ",";
			}
		}
		chaineRetournee += ";";
		
		if (sDossProj!=null) {
			// On fait un boucle pour mettre les codes dossiers projet sur 5 caractères
			StringTokenizer strtkDoss_Proj = new StringTokenizer(sDossProj, ",");
			while (strtkDoss_Proj.hasMoreTokens()){
				String leDoss_Proj = strtkDoss_Proj.nextToken();
				if (leDoss_Proj.length()==1) chaineRetournee += "0000" + leDoss_Proj;
				else if (leDoss_Proj.length()==2) chaineRetournee += "000" + leDoss_Proj;
				else if (leDoss_Proj.length()==3) chaineRetournee += "00" + leDoss_Proj;
				else if (leDoss_Proj.length()==4){
					if ("TOUS".equals(leDoss_Proj.toUpperCase())) chaineRetournee += "TOUS";
					else chaineRetournee += "0" + leDoss_Proj;
				} 
				else if (leDoss_Proj.length()>=5) chaineRetournee += leDoss_Proj;
				if (strtkDoss_Proj.hasMoreTokens()) chaineRetournee += ",";
			}
		} 
		chaineRetournee += ";";
		
		if (sAppli!=null) chaineRetournee += sAppli.toUpperCase();
		chaineRetournee += ";";
		
		if (sProjet!=null) chaineRetournee += sProjet.toUpperCase();
		chaineRetournee += ";";
		
		if (sCAFI!=null) chaineRetournee += sCAFI.toUpperCase();
		chaineRetournee += ";";
		
		if (sCAPayeur!=null) chaineRetournee += sCAPayeur.toUpperCase();
		chaineRetournee += ";";
		
		if (sSousMenus!=null) chaineRetournee += sSousMenus;		
		chaineRetournee += ";";
		
		if (sCADA!=null) {
			// On retourne la liste des CADAs avec pour séparateur la virgule
			for(int i =0; i < sCADA.size(); i++){
				chaineRetournee += (String) sCADA.elementAt(i);
				if (i != (sCADA.size()-1)) chaineRetournee += ",";
			}
		}
		chaineRetournee += ";";
		
		if (sListeMenu!=null) chaineRetournee += sListeMenu;
		chaineRetournee += ";";
		
		if (ca_suivi!=null) {
			// On retourne la liste des CADAs avec pour séparateur la virgule
			for(int i =0; i < ca_suivi.size(); i++){
				chaineRetournee += (String) ca_suivi.elementAt(i);
				if (i != (ca_suivi.size()-1)) chaineRetournee += ",";
			}
		}
		
		chaineRetournee += ";";
		
		if (perim_MCLI!=null) {
			// On retourne la liste des périmètres avec pour séparateur la virgule
			for(int i =0; i < perim_MCLI.size(); i++){
				chaineRetournee += (String) perim_MCLI.elementAt(i);
				if (i != (perim_MCLI.size()-1)) chaineRetournee += ",";
			}
		}
		
		return chaineRetournee;
	}
	
	/**
	 * Retourne le role du user : client ou fournisseur
	 * valeur de retour : "client" "fournisseur"
	 * @return String
	 */
	public String getActeur() {

		int etape = 2; //------numéro étape-------
		String sListeId = "";
		Vector Vperime = new Vector();
		Vector Vperim_mcli = new Vector();
		String perim_mcli = "";
		String acteur = "";
		sListeId = this.sListeMenu ;
		
		Vperime = this.getPerim_ME();
		Vperim_mcli = this.getPerim_MCLI();
		
		if (
				(!StringUtils.isEmpty(sListeId))	
					&& 
				(	
					((sListeId.toUpperCase()).indexOf("dir".toUpperCase()) >= 0) 
						||
					((sListeId.toUpperCase()).indexOf("me".toUpperCase()) >= 0) 	
						||
					((sListeId.toUpperCase()).indexOf("suiviact".toUpperCase()) >= 0) 	
						||
					((sListeId.toUpperCase()).indexOf("ore".toUpperCase()) >= 0) 
						||
					((sListeId.toUpperCase()).indexOf("mo".toUpperCase()) >= 0) 	
				)
			){
			
			etape = 1;
			// perim_me saisi
			if((Vperime != null) && (!Vperime.isEmpty())){
				acteur = "fournisseur";
			} else {
				// perim_me vide ou non dispo
				if(Vperime == null || Vperime.isEmpty()){
					// perim_mo non dispo ou vide
					if (Vperim_mcli == null || Vperim_mcli.isEmpty()){
						etape = 2;
					} else {
						// recherche de la valeur 099988888 dans le perim_mo
						for(int i =0; i < Vperim_mcli.size(); i++){
							perim_mcli = (String) Vperim_mcli.elementAt(i);
							if(perim_mcli.equals("099988888")){
								etape = 2;
							}
						}
						// ici perim_mo saisi et different de 099988888
						if (etape == 1) {
							acteur = "client";
						}
					}

				}
			}
		
		} else {
			etape = 2 ;
		}

		if(etape == 2){
			if((this.sCAFI != null) && (!StringUtils.isEmpty(this.sCAFI))){
				acteur = "fournisseur";
			}else{
				acteur = "client";
			}
		}

		return acteur;	
	}
	
	
	//cette methode insert les info de la connexion dans la table RTFE_LOG
	//pour permettre la surviellance des connexions
	public void InsertInfoLog(String user)
	{
		
		
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		Hashtable hParamProc = new Hashtable();
		
		JdbcBip jdbc = new JdbcBip(); 
		
		hParamProc.put("user_rtfe",user);
		
		
		String signatureMethode ="InsertRTFE_LOG";
		
		logBipUser.entry(signatureMethode);
		
		//exécution de la procédure PL/SQL			
		try {
			
			vParamOut=jdbc.getResult(hParamProc,configProc,PACK_INSERT);						
			
		}//try
		catch (BaseException be) {
			logBipUser.error( this.getClass().getName() + "." + signatureMethode +" --> BaseException :"+be);
			logBipUser.error( this.getClass().getName() + "." + signatureMethode +" --> Exception :"+be.getInitialException().getMessage());
			
		} finally {
			jdbc.closeJDBC();
		}
		
		logBipUser.exit(signatureMethode);
		
	}
	
	public boolean verifRTFE(){
		try{
			BipConfigRTFE configRTFE = BipConfigRTFE.getInstance();
			//Si on est pas dans les dates d'effet de RTFE/MENUS, on ne fait aucun test
			if(!configRTFE.isActifVerifRtfe())
				return true;
			//erreurRTFE = "Votre habilitation RTFE est fausse car blah blah blah......";
			//On vérifie que le champ des menus est bien formé et contient des valeurs conformes
			if(!configRTFE.checkChamp(sListeMenu, configRTFE.getConfigMenus())){
				erreurRTFE = "Votre habilitation RTFE aux menus Bip est incorrecte";
				return false;
			}
			//Pour chaque menu que l'utilisateur possède, 
			//On cherche le paramètre BIP correspondant : RTFE-<menu>/SMENUS
			//Et on prend les sous-menus qu'il autorise
			//On en fait une liste des sous-menus autorisés
			// ABN - HP PPM 61422 - DEBUT
			String sousMenusAutorises="";
  			String sousMenusAutorisesParMenu = "";
  			int nbrSMenusParMenu = 0;
			for(String menu:sListeMenu.split("["+configRTFE.getConfigMenus().getSeparateur()+"]")){
				ParametreBip paramSousMenu = configRTFE.getListeConfigSousMenus().get(BipConfigRTFE.CODACTION_RTFE+"-"+menu.toUpperCase());
				if(paramSousMenu!=null && paramSousMenu.getValeur()!=null && !"".equals(paramSousMenu.getValeur())){
  					sousMenusAutorisesParMenu = paramSousMenu.getValeur().toUpperCase();;
  					if("".equals(sousMenusAutorises)){
						sousMenusAutorises += paramSousMenu.getValeur().toUpperCase();
						
  					}else{
						sousMenusAutorises += configRTFE.getConfigMenus().getSeparateur()+paramSousMenu.getValeur().toUpperCase();
  					}
  				}
  				nbrSMenusParMenu = 0;
  				if (sSousMenus != null && !"".equals(sSousMenus)) {
  		  			for(String sousMenu:sSousMenus.split("["+configRTFE.getConfigMenus().getSeparateur()+"]")){
  		  				if(!"".equals(sousMenu) && BipConfigRTFE.contient(
  		  						sousMenu, sousMenusAutorisesParMenu, configRTFE.getConfigMenus().getSeparateur())){
  		  					nbrSMenusParMenu ++;
  		  				}
  		  			}
  		  			if (nbrSMenusParMenu == 0 && !sousMenusAutorisesParMenu.toUpperCase().contains("VIDE")) {
  		  				erreurRTFE = "Votre habilitation RTFE au menu Bip " + menu.toUpperCase() + " ne comporte aucun sous menu";
  		  				return false;
  		  			}
  				} else if (!sousMenusAutorisesParMenu.toUpperCase().contains("VIDE")) {
  					erreurRTFE = "Votre habilitation RTFE au menu Bip ne comporte aucun sous menu";
  					return false;
  				}
  			}
			//Pour chaque sous-menu de l'utilisateur, on vérifie s'il est bien présent
			//dans la liste de sous-menus que l'on vient de créer
			if (sSousMenus != null) {
				// ABN - HP PPM 61422 - FIN
				for(String sousMenu:sSousMenus.split("["+configRTFE.getConfigMenus().getSeparateur()+"]")){
					if(!"".equals(sousMenu) && !BipConfigRTFE.contient(sousMenu, sousMenusAutorises, configRTFE.getConfigMenus().getSeparateur())){
						erreurRTFE = "Votre habilitation RTFE aux sous-menus Bip est incorrecte";
						return false;
					}
				}
			} else if (!sousMenusAutorises.toUpperCase().contains("VIDE")) {
				erreurRTFE = "Votre habilitation RTFE au menu Bip ne comporte aucun sous menu";
				return false;
			}
			
			String champDejaControleSpecifique="";
  			String champDejaControleDefaut="";
  			//Pour chaque menu de l'utilisateur, on va chercher le paramètre RTFE-<menu>/SMENUS
  			for(String menu:sListeMenu.split("["+configRTFE.getConfigMenus().getSeparateur()+"]")){
  				ParametreBip paramSousMenu = configRTFE.getListeConfigSousMenus().get(BipConfigRTFE.CODACTION_RTFE+"-"+menu.toUpperCase());
  				if(paramSousMenu!=null){
  					//Dans ce paramètre, on va regarder s'il y a un paramètre lié, qui logiquement est dela forme RTFE-<menu>/CHAMPS
  					if(paramSousMenu.getParametreLie()!=null && paramSousMenu.getParametreLie().getValeur()!=null){
  						//Si ce paramètre lié existe, on va, pour chaque élément que contient sa valeur chercher le paramètre bip RTFE-<champ>/<menu>
  						//On fait d'abord le tour pour les paramètres spécifiques à un menu, qui sont prioritaires
  						//Seulement après, on regarde pour les paramètres par défaut si les champs n'ont pas déjà été contrôlé avec un paramètre spécifique
  						for(String champ:paramSousMenu.getParametreLie().getValeur().split("["+paramSousMenu.getParametreLie().getSeparateur()+"]")){
  							ParametreBip paramChamp  = configRTFE.getListeConfigChamps().get(BipConfigRTFE.CODACTION_RTFE+"-"+champ.toUpperCase()+"/"+menu.toUpperCase());
  							//S'il existe, on teste le champ équivalent avec ce paramètre
  							//Et on rajoute ce champ à la liste des champs déjà contrôlés par un paramètre spécifique, pour plus tard
  							if(paramChamp!=null){
  								champDejaControleSpecifique += (("".equals(champDejaControleSpecifique))?"":",")+champ.toUpperCase();
  								if(!chercheChamp(configRTFE,paramChamp)){
  									erreurRTFE = "Votre habilitation RTFE au menu Bip comporte des valeurs applicatives incorrectes (Champ "+champ+")";
  									return false;
  								}
  							}
						}
  					}
  				}
  			}
  			//On refait la même chose, mais pour les périmètres par défaut des champs cette fois
  			for(String menu:sListeMenu.split("["+configRTFE.getConfigMenus().getSeparateur()+"]")){
  				ParametreBip paramSousMenu = configRTFE.getListeConfigSousMenus().get(BipConfigRTFE.CODACTION_RTFE+"-"+menu.toUpperCase());
  				if(paramSousMenu!=null){
  					//Dans ce paramètre, on va regarder s'il y a un paramètre lié, qui logiquement est dela forme RTFE-<menu>/CHAMPS
  					if(paramSousMenu.getParametreLie()!=null && paramSousMenu.getParametreLie().getValeur()!=null){
//  			  		On cherche le paramètre bip RTFE-<champ>/DEFAUT cette fois
  						for(String champ:paramSousMenu.getParametreLie().getValeur().split("["+paramSousMenu.getParametreLie().getSeparateur()+"]")){
  								ParametreBip paramChamp  = configRTFE.getListeConfigChamps().get(BipConfigRTFE.CODACTION_RTFE+"-"+champ.toUpperCase()+"/"+BipConfigRTFE.CODVERSION_DEFAUT);
  								//Si un champ a déjà été testé par un paramètre spécifique à un menu. On ne le reteste pas avec un paramètre par défaut
  								//Les règles du paramètre spécifique prévalent
  								//Une fois qu'un champ a été testé par son paramètre par défaut, si on retrouve ce champ venant d'un autre menu, on ne le reteste pas
  								if(paramChamp!=null && !BipConfigRTFE.contient(champ, champDejaControleSpecifique, ",") && !BipConfigRTFE.contient(champ, champDejaControleDefaut, ",")){
  									champDejaControleDefaut += (("".equals(champDejaControleDefaut))?"":",")+champ.toUpperCase();
  									if(!chercheChamp(configRTFE,paramChamp)){
  										erreurRTFE = "Votre habilitation RTFE au menu Bip comporte des valeurs applicatives incorrectes (Champ "+champ+")";
  										return false;
  									}
  								}
  						}
  					}
  				}
  			}


			erreurRTFE="";
			return true;
		}catch(Exception e){
			logBipUser.debug("UserBip.verifRTFE() - Exception à la vérification du profil RTFE", e);			
			erreurRTFE="";
			return true;
		}
	}
	
	//En fonction du nom du paramètre Bip, on localise, dans l'UserBip, le champ à tester.
	//Les valeurs sont testées en dur car il n'y a pas d'équivalence directe entre ces valeurs 
	//et le nom des variables utilisées
private boolean chercheChamp(BipConfigRTFE configRTFE, ParametreBip paramChamp) {
		String champ = paramChamp.getCode_action().substring(5);
		if(BipConfigRTFE.CHAMP_BDDPG_DEFAUT.equals(champ)){
			if(!configRTFE.checkChamp(dpg_Defaut,paramChamp))
				return false;
		}else
		if(BipConfigRTFE.CHAMP_PERIM_ME.equals(champ)){
			String perimMEString="";
			if (perim_ME!=null) {
				// On retourne la liste des périmètres avec pour séparateur la virgule
				for(int i =0; i < perim_ME.size(); i++){
					perimMEString += (String) perim_ME.elementAt(i);
					if (i != (perim_ME.size()-1)) perimMEString += paramChamp.getSeparateur();
				}
			}
			if(!configRTFE.checkChamp(perimMEString,paramChamp))
				return false;
		}else
		if(BipConfigRTFE.CHAMP_CHEF_PROJET.equals(champ)){
			String chefProjetString="";
			if (chefProjet!=null) {
				String leChefProjet;
				// On retourne la liste des chefs de projets avec pour séparateur la virgule
				for(int i =0; i < chefProjet.size(); i++){
					leChefProjet = (String) chefProjet.elementAt(i);
					// On vérifie que c'est bien formaté sur 5 caractères
					if (leChefProjet.length() == 1) leChefProjet = "0000".concat(leChefProjet);
					else if (leChefProjet.length() == 2) leChefProjet = "000".concat(leChefProjet);
					else if (leChefProjet.length() == 3) leChefProjet = "00".concat(leChefProjet);
					else if (leChefProjet.length() == 4) leChefProjet = "0".concat(leChefProjet);
					
					chefProjetString += leChefProjet;
					if (i != (chefProjet.size()-1)) chefProjetString += paramChamp.getSeparateur();
				}
			}
			if(!configRTFE.checkChamp(chefProjetString,paramChamp))
				return false;
		}else
		if(BipConfigRTFE.CHAMP_MO_DEFAUT.equals(champ)){
			if(!configRTFE.checkChamp(clicode_Defaut,paramChamp))
				return false;
		}else
		if(BipConfigRTFE.CHAMP_PERIM_MO.equals(champ)){
			String perimMOString="";
			if (perim_MO!=null) {
				// On retourne la liste des périmètres avec pour séparateur la virgule
				for(int i =0; i < perim_MO.size(); i++){
					perimMOString += (String) perim_MO.elementAt(i);
					if (i != (perim_MO.size()-1)) perimMOString += paramChamp.getSeparateur();
				}
			}
			if(!configRTFE.checkChamp(perimMOString,paramChamp))
				return false;
		}else
			if(BipConfigRTFE.CHAMP_PERIM_MCLI.equals(champ)){
				String perimMCLIString="";
				if (perim_MCLI!=null) {
					// On retourne la liste des périmètres avec pour séparateur la virgule
					for(int i =0; i < perim_MCLI.size(); i++){
						perimMCLIString += (String) perim_MCLI.elementAt(i);
						if (i != (perim_MCLI.size()-1)) perimMCLIString += paramChamp.getSeparateur();
					}
				}
				if(!configRTFE.checkChamp(perimMCLIString,paramChamp))
					return false;
			}else
		if(BipConfigRTFE.CHAMP_CENTRE_FRAIS.equals(champ)){
			if(!configRTFE.checkChamp(liste_Centres_Frais,paramChamp))
				return false;
		}else
		if(BipConfigRTFE.CHAMP_CA_SUIVI.equals(champ)){
			String caSuiviString="";
			if (ca_suivi!=null) {
				// On retourne la liste des CADAs avec pour séparateur la virgule
				for(int i =0; i < ca_suivi.size(); i++){
					caSuiviString += (String) ca_suivi.elementAt(i);
					if (i != (ca_suivi.size()-1)) caSuiviString += paramChamp.getSeparateur();
				}
			}
			if(!configRTFE.checkChamp(caSuiviString,paramChamp))
				return false;
		}else
		if(BipConfigRTFE.CHAMP_DOSS_PROJ.equals(champ)){
			if(!configRTFE.checkChamp(sDossProj,paramChamp))
				return false;
		}else
		if(BipConfigRTFE.CHAMP_PROJET.equals(champ)){
			if(!configRTFE.checkChamp(sProjet,paramChamp))
				return false;
		}else
		if(BipConfigRTFE.CHAMP_APPLI.equals(champ)){
			if(!configRTFE.checkChamp(sAppli,paramChamp))
				return false;
		}else
		if(BipConfigRTFE.CHAMP_CA_FI.equals(champ)){
			if(!configRTFE.checkChamp(sCAFI,paramChamp))
				return false;
		}else
		if(BipConfigRTFE.CHAMP_CA_PAYEUR.equals(champ)){
			if(!configRTFE.checkChamp(sCAPayeur,paramChamp))
				return false;
		}else
		if(BipConfigRTFE.CHAMP_CA_DA.equals(champ)){
			String CADAString="";
			if (sCADA!=null) {
				// On retourne la liste des CADAs avec pour séparateur la virgule
				for(int i =0; i < sCADA.size(); i++){
					CADAString += (String) sCADA.elementAt(i);
					if (i != (sCADA.size()-1)) CADAString += paramChamp.getSeparateur();
				}
			}
			if(!configRTFE.checkChamp(CADAString,paramChamp))
				return false;
		}
		return true;
	}

	//	recherche s'il existe une alerte actualité à valider par le user.
	//pour permettre la surveillance des connexions
	public void existAlertesActu()
	{
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		Hashtable hParamProc = new Hashtable();
		JdbcBip jdbc = new JdbcBip();
		
		String signatureMethode ="existAlertesActu";
		logBipUser.entry(signatureMethode);
		
		existeAlerte = "NON";
		
		int count = 0;		
		
		try {
			Vector vProfil = getListeMenu();
			String sProfil = new String();
			
			for (int i = 0; i < vProfil.size(); i++) {
				BipItemMenu bIMenu = (BipItemMenu) vProfil.elementAt(i);
				sProfil = sProfil + ";" + bIMenu.getId();
			}
			
			hParamProc.put("userid",idUser);
			hParamProc.put("profils",sProfil);
			//vParamOut=jdbc.getResult(hParamProc,configProc,PACK_EXIST_ACTU_USER);		
			vParamOut = jdbc.getResult( hParamProc,configProc, PACK_LISTE);
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						if(rset.next())
							existeAlerte = "EXIST";
					} catch (SQLException sqle) {
						logService
						.debug("PopupActualiteAction-suite() --> SQLException :"
								+ sqle);
						logBipUser
						.debug("PopupActualiteAction-suite() --> SQLException :"
								+ sqle);
						
						jdbc.closeJDBC();
					}
				}	
			}// for
		}//try
		catch (BaseException be) {
			logBipUser.error( this.getClass().getName() + "." + signatureMethode +" --> BaseException :"+be);
			logBipUser.error( this.getClass().getName() + "." + signatureMethode +" --> Exception :"+be.getInitialException().getMessage());
			existeAlerte = "NON";			
		} finally {
			jdbc.closeJDBC();
			
		}
		
		logBipUser.exit(signatureMethode);
		
	}
	
	public void setCurrentMenu(String sMenuId)
	{
		if (sListeMenu == null || sMenuId == null)
		{
			currentMenu = null ;
			return ;
		}
		currentMenu = BipMenuManager.getInstance().getBipMenu(sMenuId);
	}
	
	public String renderChefDeProjectWithoutBracketChars(){
		return null;
//		liste_cp = userbip.getChef_Projet().toString().replace('[', ',').replace(']', ',');
	}
	/**
	 * @return
	 */
	public String getAppli() {
		return sAppli;
	}
	
	/**
	 * @return
	 */
	public String getCAFI() {
		return sCAFI;
	}
	
	/**
	 * @return
	 */
	public String getCAPayeur() {
		return sCAPayeur;
	}
	
	/**
	 * @return
	 */
	public String getDossProj() {
		return sDossProj;
	}
	
	/**
	 * @return
	 */
	public String getProjet() {
		return sProjet;
	}
	/**
	 * @return
	 */
	public String getNom()
	{
		return nomUser;
	}
	
	/**
	 * @return
	 */
	public String getPrenom()
	{
		return prenomUser;
	}
	
	/**
	 * @param string
	 */
	public void setNom(String string)
	{
		nomUser = string;
	}
	
	/**
	 * @param string
	 */
	public void setPrenom(String string)
	{
		prenomUser = string;
	}
	
	/**
	 * @param string
	 */
	public void setCentre_Frais(String string)
	{
		centre_Frais = string;
	}
	
	public void setListeMenus(String chaine)
	{
		sListeMenu=chaine;
	}
	
	public void setSousMenus(String chaine)
	{
		sSousMenus=chaine;
	}
	
	
	public void setPerim_ME(Vector vector)
	{
		perim_ME=vector;
	}
	
	public void setDpg_Default(String chaine)
	{ 
		dpg_Defaut=chaine;
	}
	
	public void setChef_Projet(Vector vector)
	{
		chefProjet=vector;
	}
	
	
	public void setPerim_MO(Vector vector)
	{
		perim_MO=vector;
	}
	
	public void setCADA(Vector vector)
	{	
		sCADA=vector;
	}
	
	public void setListe_Centres_Frais(String chaine)
	{	
		liste_Centres_Frais=chaine;	
	}
	
	public void setCa_suivi(Vector vector)
	{
		ca_suivi=vector;
	}
	
	public void setProjet(String chaine)
	{	
		sProjet=chaine;
	}
	
	public void setAppli(String chaine)
	{
		sAppli=chaine;
	}
	
	public void setCAFI(String chaine)
	{	
		sCAFI=chaine;
	}
	
	public void setCAPayeur(String chaine)
	{	
		sCAPayeur=chaine;
	}
	
	public void setDossProj(String chaine)
	{	
		sDossProj=chaine;
	}
	
	/**
	 * @return
	 */
	public String getLienFavori() {
		return sLienFavori;
	}
	
	/**
	 * @param string
	 */
	public void setLienFavori(String string) {
		sLienFavori = string;
	}
	public String getExisteAlerte() {
		return existeAlerte;
	}
	
	public void setExisteAlerte(String existeAlerte) {
		this.existeAlerte = existeAlerte;
	}
	
	public void setHabiliteBip(boolean habiliteBip) {
		this.habiliteBip = habiliteBip;
	}

	public String getErreurRTFE() {
		return erreurRTFE;
	}

	public void setErreurRTFE(String erreurRTFE) {
		this.erreurRTFE = erreurRTFE;
	}

	public Vector getPerim_MCLI() {
		if (perim_MCLI == null) return null;
		else return (Vector) perim_MCLI.clone();
	}

	public void setPerim_MCLI(Vector perim_MCLI) {
		this.perim_MCLI = perim_MCLI;
	}
	
}
