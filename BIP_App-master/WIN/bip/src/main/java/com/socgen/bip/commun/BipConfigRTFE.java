package com.socgen.bip.commun;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.Set;
import java.util.Vector;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.python.modules.synchronize;

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.metier.ParametreBip;
import com.socgen.bip.user.UserBip;
import com.socgen.bip.util.BipStringUtil;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;

/**
 *
 * @author CMA 30/03/2011
 * Cette classe est un singleton qui contient la configuration dynamique 
 * du RTFE qui se base sur les param�tres BIP correspondant.
 * Elle doit �tre charg�e une seule fois et mise � jour
 * uniquement en cas de modification via l'IHM des param�tres BIP
 * correspondant afin de ne pas solliciter lourdement la base
 * � chaque connexion d'un utilisateur.
 */
public class BipConfigRTFE implements BipConstantes{

	protected static final String sLogCat = "BipUser";

	protected static Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);
	
	/** L'instance statique */
    private static BipConfigRTFE instance;
    
    private ParametreBip configMenus;
    
    private HashMap<String,ParametreBip> listeConfigSousMenus;
    
    private HashMap<String,ParametreBip> listeConfigChamps;
    
    private String date_effet;
    
    private String heure_effet;
    
    private String date_fin;
    
    private String heure_fin;
    
    private String erreurRTFE;
    
    private static String PACK_SELECT = "parambip.recuperer.proc";
    
    private static String PACK_DATE_EFFET = "dateseffet.consulter.proc";
    
    public static String CODACTION_RTFE = "RTFE";
    
    public static String CODVERSION_MENUS = "MENUS";
    
    public static String CODVERSION_SMENUS = "SMENUS";
    
    public static String CODVERSION_DEFAUT = "DEFAUT";
	
    //Constantes mot-cl� pour r�f�rentiels de valeurs
    //Accompagn�es de leur package respectif pour tester leur existence
 
    //Le DPG Bip sous sa forme compl�te (11 char)
    private static String BDDPG = "BDDPG";
    private static final String PACK_EXISTE_BDDPG = "rtfe.existence.bddpg";
    
//  Le DPG Bip sous sa forme tronqu�e (7 char)
    private static final String PACK_EXISTE_DPG = "rtfe.existence.dpg";
    
    //Le code ressource Bip
    private static String RESBIP = "RESBIP";
    private static final String PACK_EXISTE_RESBIP = "rtfe.existence.resbip";
    
    //Le code client Bip au format r�duit
    private static String CLIBIP = "CLIBIP";
    private static final String PACK_EXISTE_CLIBIP = "rtfe.existence.clibip";
    
    //Le code client Bip au format complet
    private static String BDCLIBIP = "BDCLIBIP";
    private static final String PACK_EXISTE_BDCLIBIP = "rtfe.existence.bdclibip";
    
    //Le centre de frais Bip
    private static String CFBIP = "CFBIP";
    private static final String PACK_EXISTE_CFBIP = "rtfe.existence.cfbip";
    
    //L'ES du RES
    private static String RES = "RES";
    private static final String PACK_EXISTE_RES = "rtfe.existence.res";
    
    //Le CA du RES
    private static String RESCA = "RESCA";
    private static final String PACK_EXISTE_RESCA = "rtfe.existence.resca";
    
    //Le code Dossier Projet Bip
    private static String DPBIP = "DPBIP";
    private static final String PACK_EXISTE_DPBIP = "rtfe.existence.dpbip";
    
    //Le code projet Bip
    private static String PROJBIP = "PROJBIP";
    private static final String PACK_EXISTE_PROJBIP = "rtfe.existence.projbip";
    
    //Le code application
    private static String IRT = "IRT";
    private static final String PACK_EXISTE_IRT = "rtfe.existence.irt";
    
    private static String PACK_CHARGER_RTFE_FROM_IDBIP = "rtfe.selectfromidbip.proc";
	private static String PACK_CHARGER_RTFE_FROM_IDBIP_PARAM = "ident";
	private static String PACK_CHARGER_RTFE_FROM_IDBIP_CURSEUR = "curseur";
	
	private static String PACK_EXISTS_USERRTFE = "rtfe.existsuserrtfe.proc";
	private static String PACK_EXISTS_USERRTFE_PARAM = "user_rtfe";
	private static String PACK_EXISTS_USERRTFE_RESULT = "result";
	private static String PACK_EXISTS_USERRTFE_RESULT_TRUE = "O";
	
	private static String PACK_SELECT_RTFE_USERS = "rtfe.users.charger.proc";
	private static String PACK_SELECT_RTFE_USERS_PARAM = "users_rtfe";
	/**
	 * S�parateur de la chaine contenant la concat�nation des ids RTFE dont on souhaite charger les profils
	 */
	private final static String SEPARATEUR_PARAM_RTFE_USERS = " ";
    
    //Format num�rique exclusivement
    private static String FORMAT_N ="N";
    
    //Format alphanum�rique (chiffres et lettres uniquement)
    private static String FORMAT_C ="C";
    
    //Tout caract�re possible
    private static String FORMAT_X ="X";
    
    //Aucun traitement sur la casse
    private static String CASSE_N ="N";
    
    //Minuscules interdites
    private static String CASSE_I ="I";
    
    //Conversion en majuscule avant contr�le et stockage
    public static String CASSE_C ="C";
    
    public static String CHAMP_BDDPG_DEFAUT = "BDDPG_DEFAUT";
    public static String CHAMP_PERIM_ME = "PERIM_ME";
    public static String CHAMP_CHEF_PROJET = "CHEF_PROJET";
    public static String CHAMP_MO_DEFAUT = "MO_DEFAUT";
    public static String CHAMP_PERIM_MO = "PERIM_MO";
    public static String CHAMP_PERIM_MCLI = "PERIM_MCLI";
    public static String CHAMP_CENTRE_FRAIS = "CENTRE_FRAIS";
    public static String CHAMP_CA_SUIVI = "CA_SUIVI";
    public static String CHAMP_DOSS_PROJ = "DOSS_PROJ";
    public static String CHAMP_PROJET = "PROJET";
    public static String CHAMP_APPLI = "APPLI";
    public static String CHAMP_CA_FI = "CA_FI";
    public static String CHAMP_CA_PAYEUR = "CA_PAYEUR";
    public static String CHAMP_CA_DA = "CA_DA";
    
    // Class responsible to create, store and get the singleton
    private static class LazyHolder {
           private static BipConfigRTFE instance = new BipConfigRTFE ();
     }

    
    /** R�cup�re l'instance unique de la classe.
    * Remarque : le constructeur est rendu inaccessible
    */
//    public static BipConfigRTFE getInstance() {
//        if (null == instance) { // Premier appel
//            instance = new BipConfigRTFE();
//        }
//        return instance;
//    }
    
        /** Constructeur red�fini comme �tant priv� pour interdire
    * son appel et forcer � passer par la m�thode getInstance()
    */
    private BipConfigRTFE() {
	    //On initialise les variables de classe
	    //Puis on fait appel � la m�thode qui va les charger avec les donn�es en base
    	logService.debug(this.getClass().getName()
				+ ".BipConfigRTFE() - Chargement de la configuration RTFE en cours");
	    configMenus = new ParametreBip();
	    listeConfigSousMenus = new HashMap<String,ParametreBip>();
	    listeConfigChamps = new HashMap<String,ParametreBip>();
	    erreurRTFE = null;
	    chargementParametrage();
	    logService.debug(this.getClass().getName()
				+ ".BipConfigRTFE() - Chargement de la configuration RTFE fini");
    }
    
    /** R�cup�re l'instance unique de la classe.
     * Remarque : le constructeur est rendu inaccessible
     */
    public static BipConfigRTFE getInstance() {
        return LazyHolder.instance;
    }
    
    //M�thode servant � recharger le param�trage RTFE depuis la base, quand il a �t� modifi� par un admin via l'IHM
    public void rechargerConfigRTFE(){
//    	On initialise les variables de classe
	    //Puis on fait appel � la m�thode qui va les charger avec les donn�es en base
    	logService.debug(this.getClass().getName()
				+ ".BipConfigRTFE() - Rechargement de la configuration RTFE en cours suite � une modification de la config RTFE");
	    configMenus = new ParametreBip();
	    listeConfigSousMenus = new HashMap<String,ParametreBip>();
	    listeConfigChamps = new HashMap<String,ParametreBip>();
	    erreurRTFE = null;
	    chargementParametrage();
	    logService.debug(this.getClass().getName()
				+ ".BipConfigRTFE() - Rechargement de la configuration RTFE fini");
    }
    
    //Demande Antoine - PPM 64631 
    private synchronized boolean chargementParametrage() {
        // R�cup�ration dans les tables param�tres BIP Date_Effet et Ligne_Parametre_Bip
        // de toute la config RTFE
    	
		Hashtable hParamProc = new Hashtable();
		// Initialise la variable config � pointer sur le fichier properties sql
		Config configProc = ConfigManager.getInstance(BipConstantes.BIP_PROC);
		
		//On cherche d'abord la date_effet RTFE/MENUS pour en extraire les dates de d�but et de fin
		hParamProc.put("codaction", CODACTION_RTFE);
		hParamProc.put("codversion", CODVERSION_MENUS);
		hParamProc.put("userid", "O");
		
		// ex�cution de la proc�dure PL/SQL
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		JdbcBip jdbc = new JdbcBip(); 
		try{	
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_DATE_EFFET);
			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							date_effet = (rset.getString(4));
							heure_effet = (rset.getString(5));
							date_fin = (rset.getString(6));
							heure_fin = (rset.getString(7));
						}
						if (rset != null)
							rset.close();

					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ ".recupererParametreBip() --> SQLException :" + sqle);
						if (rset != null)
							rset.close();
						jdbc.closeJDBC(); 
						erreurRTFE = "Erreur de param�trage RTFE (param�tre Bip de liste des menus introuvable) - veuillez pr�venir l'�quipe Bip";
						return false;
					}catch (Exception ex){
						logBipUser.debug("Une exception a �t� lev�e dans le param�tre li�");
						if (rset != null)
							rset.close();
						jdbc.closeJDBC(); 
						erreurRTFE = "Erreur de param�trage RTFE (param�tre Bip de liste des menus introuvable) - veuillez pr�venir l'�quipe Bip";
						return false;
					}
				} // if
			} // for
		} // try
		catch (Exception e) {
			jdbc.closeJDBC(); 
			erreurRTFE = "Erreur de param�trage RTFE (param�tre Bip de liste des menus introuvable) - veuillez pr�venir l'�quipe Bip";
			return false;	 
		} 
		jdbc.closeJDBC(); 

		//On recherche ensuite la premi�re ligne param�tre BIP active pour RTFE/MENUS
		hParamProc.put("codaction", CODACTION_RTFE);
		hParamProc.put("codversion", CODVERSION_MENUS);
		hParamProc.put("actives", "O");
		hParamProc.put("nbLignes", "1");
		
		// ex�cution de la proc�dure PL/SQL
		try {
			configMenus = recupererParametreBip(hParamProc,configProc);
		}catch(Exception e){
			erreurRTFE = "Erreur de param�trage RTFE (param�tre Bip de liste des menus introuvable) - veuillez pr�venir l'�quipe Bip";
			return false;
		}
		if(configMenus.getValeur()==null){
			erreurRTFE = "Erreur de param�trage RTFE (param�tre Bip de liste des menus introuvable) - veuillez pr�venir l'�quipe Bip";
			return false;
		}
		//Puis pour chaque sous-menus d�clar� dans sa valeur, on va chercher tous les param�tres de sous-menus
		String menuCourant="";
		hParamProc.put("codversion", CODVERSION_SMENUS);
		try{
			for(String menu : configMenus.getValeur().split("["+configMenus.getSeparateur()+"]")){
				if(menu!=null && !"".equals(menu)){
					menuCourant = menu;
					hParamProc.put("codaction", CODACTION_RTFE+"-"+menu);
					logBipUser.info("Dans chargementParametrage 000: " + menu) ;
					listeConfigSousMenus.put(CODACTION_RTFE+"-"+menu, recupererParametreBip(hParamProc,configProc));
				}
			}
		}catch(Exception e){
			erreurRTFE = "Erreur de param�trage RTFE (param�tre Bip de liste des sous-menus "+menuCourant+" introuvable ou param�tre bip li� introuvable) - veuillez pr�venir l'�quipe Bip)";
			return false;
		}
		//Puis, pour chaque champ d�clar� dans chacune des valeurs des sous-menus, on va chercher les param�tres de champs
		String champCourant="";
		try{
			for(ParametreBip paramSousMenu : listeConfigSousMenus.values()){
				if(paramSousMenu.getParametreLie()!=null){
					if(paramSousMenu.getParametreLie().getValeur()!=null){
						for(String champ : paramSousMenu.getParametreLie().getValeur().split("["+paramSousMenu.getParametreLie().getSeparateur()+"]")){
							if(champ!=null && !"".equals(champ)){
								champCourant = champ;
								hParamProc.put("codaction", CODACTION_RTFE+"-"+champ.toUpperCase());
								logBipUser.debug("Dans chargementParametrage 2222: " + CODACTION_RTFE+"-"+champ.toUpperCase()) ;
								hParamProc.put("codversion", paramSousMenu.getCode_action().substring(5));
								logBipUser.debug("Dans chargementParametrage 3333 " + paramSousMenu.getCode_action().substring(5)) ;
								try{
									if(!listeConfigChamps.containsKey(CODACTION_RTFE+"-"+champ.toUpperCase()+"/"+paramSousMenu.getCode_action().substring(5))){
									    	logBipUser.debug("Dans chargementParametrage 444") ;
										listeConfigChamps.put(CODACTION_RTFE+"-"+champ.toUpperCase()+"/"+paramSousMenu.getCode_action().substring(5), recupererParametreBip(hParamProc,configProc));
										logBipUser.debug("Dans chargementParametrage 5555: " + recupererParametreBip(hParamProc,configProc)) ;
									}
								}catch(Exception e){
								    //Demande Antoine - PPM 64631
									logBipUser.debug("Pour DEBUG, exception dans BipConfigRTFE-chargementParametrage() avec champ courant=" + champCourant);
									//Cas o� le champ sp�cifique � ce menu n'existe pas, on charge alors le d�faut pour ce champ
									hParamProc.put("codversion", CODVERSION_DEFAUT);
									if(!listeConfigChamps.containsKey(CODACTION_RTFE+"-"+champ.toUpperCase()+"/"+CODVERSION_DEFAUT)){
									    logBipUser.debug("Dans chargementParametrage 888") ;
										listeConfigChamps.put(CODACTION_RTFE+"-"+champ.toUpperCase()+"/"+CODVERSION_DEFAUT, recupererParametreBip(hParamProc,configProc));
									}
								}
							}
						}
					}
				}
			}
		}catch(Exception e){
		    erreurRTFE = "Erreur de param�trage RTFE (param�tre Bip de contr�le d'un champ introuvable ("+champCourant+")) - veuillez pr�venir l'�quipe Bip)";
		    logBipUser.error("Pour DEBUG, exception dans BipConfigRTFE-chargementParametrage() avec champ courant=" + champCourant,e);
		    return false;
		}
		return true;
	}



	private Calendar construireDate(String date, String heure) {
		int year, month, day, hourOfDay, minute;
		year = Integer.parseInt(date.split("[/]")[2]);
		month = Integer.parseInt(date.split("[/]")[1])-1;
		day = Integer.parseInt(date.split("[/]")[0]);
		hourOfDay = Integer.parseInt(heure.split("[:]")[0]);
		minute = Integer.parseInt(heure.split("[:]")[1]);
		Calendar cal = Calendar.getInstance();
		cal.set(year, month, day, hourOfDay, minute);
		return cal;
	}

	private ParametreBip recupererParametreBip(Hashtable hParamProc, Config configProc) throws Exception{
		
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		ParametreBip paramBip = new ParametreBip();
		JdbcBip jdbc = new JdbcBip(); 
		try{	
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							paramBip.setCode_action(rset.getString(1));
							paramBip.setCode_version(rset.getString(2));
							paramBip.setNum_ligne(rset.getInt(3));
							paramBip.setActif(("O".equals(rset.getString(4)))?true:false);
							paramBip.setApplicable(("O".equals(rset.getString(5)))?true:false);
							paramBip.setObligatoire(("O".equals(rset.getString(6)))?true:false);
							paramBip.setMulti(("O".equals(rset.getString(7)))?true:false);
							paramBip.setSeparateur(rset.getString(8));
							paramBip.setFormat(rset.getString(9));
							paramBip.setCasse(rset.getString(10));
							paramBip.setCode_action_lie(rset.getString(11));
							paramBip.setCode_version_lie(rset.getString(12));
							paramBip.setNum_ligne_lie(rset.getInt(13));
							if(paramBip.getCode_action_lie()!=null && !"".equals(paramBip.getCode_action_lie())
									&& paramBip.getCode_version_lie()!=null && !"".equals(paramBip.getCode_version_lie())){
								Hashtable paramProcLie = new Hashtable();
								paramProcLie.put("codaction", paramBip.getCode_action_lie());
								paramProcLie.put("codversion", paramBip.getCode_version_lie());
								paramProcLie.put("actives", "O");
								paramProcLie.put("nbLignes", "1");
								paramBip.setParametreLie(recupererParametreBip(paramProcLie, configProc));
							}
							paramBip.setMin_size_unit(rset.getInt(14));
							paramBip.setMax_size_unit(rset.getInt(15));
							paramBip.setMin_size_tot(rset.getInt(16));
							paramBip.setMax_size_tot(rset.getInt(17));
							paramBip.setValeur(rset.getString(18));
							paramBip.setCommentaire(rset.getString(19));
						}
						if (rset != null)
							rset.close();

					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ ".recupererParametreBip() --> SQLException :" + sqle);
						if (rset != null)
							rset.close();
						jdbc.closeJDBC(); 
						throw new Exception();
					}catch (Exception ex){
						logBipUser.debug("Une exception a �t� lev�e dans le param�tre li�");
						if (rset != null)
							rset.close();
						jdbc.closeJDBC(); 
						throw new Exception();
					}
				} // if
			} // for
		} // try
		catch (BaseException be) {
				jdbc.closeJDBC(); 
				throw new Exception();
		} 
		jdbc.closeJDBC(); 
		return paramBip;
	}
	
	public boolean checkChamp(String valeur, ParametreBip param){
		
		if(param.isObligatoire() && (valeur==null || "".equals(valeur)))
			return false;
		
		if(!param.isObligatoire() && (valeur==null || "".equals(valeur)))
			return true;
		
		if(valeur.length()<param.getMin_size_tot() || valeur.length()>param.getMax_size_tot())
			return false;
		
		if(CASSE_C.equals(param.getCasse())){
			valeur = valeur.toUpperCase();
		}
		
		if(!param.isMulti()){//Si le champ n'est pas multivalu�
			if(!checkFormat(valeur,param.getFormat()))
				return false;
			if(!checkCasse(valeur,param.getCasse()))
				return false;
			if(valeur.length()<param.getMin_size_unit() || valeur.length()>param.getMax_size_unit())
				return false;
			if(!checkValeur(valeur,param.getValeur()))
				return false;
		}else{//Si le champ est multivalu�
			for(String item : valeur.split("["+param.getSeparateur()+"]")){
				if(!checkFormat(item,param.getFormat()))
					return false;
				if(!checkCasse(item,param.getCasse()))
					return false;
				if(item.length()<param.getMin_size_unit() || item.length()>param.getMax_size_unit())
					return false;
				if(!checkValeur(item,param.getValeur()))
					return false;
			}
		}
		
		
		return true;
	}

	private boolean checkValeur(String valeur, String valeurParam) {
		if("".equals(valeur))
			return true;
		else{
			for(String param:valeurParam.split("[,]")){
				if(param.equals(BDDPG)){
					String pack="";
					if (valeur.length()==7)
						pack = PACK_EXISTE_DPG;
					else
						pack = PACK_EXISTE_BDDPG;
					if(checkData(valeur,pack) || param.toUpperCase().equals(valeur.toUpperCase()))
						return true;
				}else if(param.equals(RESBIP)){
					if(checkData(valeur,PACK_EXISTE_RESBIP) || param.toUpperCase().equals(valeur.toUpperCase()))
						return true;
				}else if(param.equals(CLIBIP)){
					if(checkData(valeur,PACK_EXISTE_CLIBIP) || param.toUpperCase().equals(valeur.toUpperCase()))
						return true;
				}else if(param.equals(BDCLIBIP)){
					if(checkData(valeur,PACK_EXISTE_BDCLIBIP) || param.toUpperCase().equals(valeur.toUpperCase()))
						return true;
				}else if(param.equals(CFBIP)){
					if(checkData(valeur,PACK_EXISTE_CFBIP) || param.toUpperCase().equals(valeur.toUpperCase()))
						return true;
				}else if(param.equals(RES)){
					if(checkData(valeur,PACK_EXISTE_RES) || param.toUpperCase().equals(valeur.toUpperCase()))
						return true;
				}else if(param.equals(RESCA)){
					if(checkData(valeur,PACK_EXISTE_RESCA) || param.toUpperCase().equals(valeur.toUpperCase()))
						return true;
				}else if(param.equals(DPBIP)){
					if(checkData(valeur,PACK_EXISTE_DPBIP) || param.toUpperCase().equals(valeur.toUpperCase()))
						return true;
				}else if(param.equals(PROJBIP)){
					if(checkData(valeur,PACK_EXISTE_PROJBIP) || param.toUpperCase().equals(valeur.toUpperCase()))
						return true;
				}else if(param.equals(IRT)){
					if(checkData(valeur,PACK_EXISTE_IRT) || param.toUpperCase().equals(valeur.toUpperCase()))
						return true;
				}else{
					if(param.toUpperCase().equals(valeur.toUpperCase()))
						return true;
				}
			}
		}
		return false;
	}

	private boolean checkData(String valeur, String pack) {
		Hashtable hParamProc = new Hashtable();
		// Initialise la variable config � pointer sur le fichier properties sql
		Config configProc = ConfigManager.getInstance(BipConstantes.BIP_PROC);
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		String message="";
		hParamProc.put(pack.split("[.]")[2], valeur);
		JdbcBip jdbc = new JdbcBip(); 
		try{	
			vParamOut = jdbc.getResult(
					hParamProc, configProc, pack);
			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				
				if (paramOut.getNom().equals("message")) {
					message = (String)paramOut.getValeur();
				} // if
			} // for
		} // try
		catch (BaseException be) {
				logBipUser.debug("BipConfigRTFE.checkData("+valeur+","+pack+") a lev� une BaseException � l'appel de la requ�te");
				logBipUser.debug(be.toString());
				jdbc.closeJDBC(); 
				return false;
		} 
		jdbc.closeJDBC();
		if(message!=null && !"".equals(message))
			return false;
		return true;
	}

	private boolean checkCasse(String valeur, String casse) {
		if(!"".equals(valeur)){
			if(CASSE_N.equals(casse)){
				return true;
			}else if(CASSE_I.equals(casse)){
				String c;
				for (int i=0;i<valeur.length();i++){
				c = String.valueOf(valeur.charAt(i));
				//if(Pattern.compile("[a-z���������������]").matcher(c).matches())
				if(c.matches("[a-z���������������]"))
					return false;
				}
			}
		}
		return true;
	}
	
	public boolean isActifVerifRtfe(){
	
		Calendar today = Calendar.getInstance();
		//On d�termine, en fonction de ces dates, si la v�rification du RTFE est active ou non
		//Si les dates de d�but et de fin ne sont pas renseign�es, c'est actif
		if((date_effet==null || "".equals(date_effet))&&(date_fin==null || "".equals(date_fin))){
			return true;
		}//Si seule la date de fin est renseign�e, on v�rifie que la date de fin n'est pas d�pass�e
		else if ((date_effet==null || "".equals(date_effet))&& date_fin!=null && !"".equals(date_fin)){
			//Si l'heure de fin n'est pas renseign�e, on consid�re qu'elle est � 23h59
			if(heure_fin==null || "".equals(heure_fin)){
				heure_fin = "23:59";
			}
			Calendar dateLimite = construireDate(date_fin, heure_fin);
			if(dateLimite.after(today))
				return true;
			else
				return false;
		}//Si seule la date effete st renseign�e, on v�rifie que la date effet est atteinte
		else if ((date_fin==null || "".equals(date_fin)) && date_effet!=null && !"".equals(date_effet)){
			//Si l'heure d'effet n'est pas renseign�e, on consid�re qu'elle est � minuit
			if(heure_effet==null || "".equals(heure_effet)){
				heure_effet = "00:00";
			}
			Calendar dateDebut = construireDate(date_effet, heure_effet);
			if(dateDebut.before(today))
				return true;
			else
				return false;
		}//Si les deux dates sont renseign�es, on v�rifie qu'on est bien dans le cr�neau
		else if (date_effet!=null && !"".equals(date_effet) && date_fin!=null && !"".equals(date_fin)){
			if(heure_fin==null || "".equals(heure_fin)){
				heure_fin = "23:59";
			}
			Calendar dateLimite = construireDate(date_fin, heure_fin);
			if(heure_effet==null || "".equals(heure_effet)){
				heure_effet = "00:00";
			}
			Calendar dateDebut = construireDate(date_effet, heure_effet);
			if(dateDebut.before(today) && dateLimite.after(today))
				return true;
			else
				return false;
		}
		return false;
	}

	private boolean checkFormat(String valeur, String format) {
		//Si la valeur est Tous, on ne v�rifie pas son format
		if(!"".equals(valeur)){
			if(FORMAT_N.equals(format)){
				try{
					Float.parseFloat(valeur);
				}catch(NumberFormatException e){
					return false;
				}
			}else if(FORMAT_C.equals(format)){
				//if(!Pattern.compile("/[^A-Za-z0-9 ]+/").matcher(valeur).matches())
				if(!valeur.matches("^[0-9A-Za-z]+$"))
					return false;
			}else if(FORMAT_X.equals(format)){
				return true;
			}
		}
		return true;
	}
	
	public static boolean contient(String valeur, String chaine, String separateur){
		for(String elem:chaine.split("["+separateur+"]")){
			if(elem.toUpperCase().equals(valeur.toUpperCase()))
				return true;
		}
		return false;
	}
	
	/**
	 * V�rification de l'habilitation d'un id RTFE (existence dans RTFE.USER_RTFE/RTFE_ERROR.USER_RTFE)
	 * @param idRtfe
	 * @return
	 */
	public static boolean estHabiliteBip(String idRtfe, Config configProc) {
		boolean retour = false;
		Vector vParamOut;

		JdbcBip jdbc = new JdbcBip();
		ParametreProc paramOut;
		Hashtable<String, String> hParamProc = new Hashtable<String, String>();
		hParamProc.put(PACK_EXISTS_USERRTFE_PARAM, idRtfe);
		
		try {
			vParamOut = jdbc.getResult(hParamProc,configProc, PACK_EXISTS_USERRTFE);

			if (vParamOut != null) {
				for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
					paramOut = (ParametreProc) e1.nextElement();
										
					if (paramOut.getNom().equals(PACK_EXISTS_USERRTFE_RESULT)) {
						if (paramOut.getValeur() != null)
							retour = PACK_EXISTS_USERRTFE_RESULT_TRUE.equals((String) paramOut.getValeur());
					}
				}
			}
		} catch (BaseException be) {
			logBipUser.debug(
					"BipConfigRTFE-estHabiliteBip() --> BaseException :" + be,
					be);
			logBipUser.debug("BipConfigRTFE-estHabiliteBip() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"BipConfigRTFE-estHabiliteBip() --> BaseException :" + be,
					be);
			logService.debug("BipConfigRTFE-estHabiliteBip() --> Exception :"
					+ be.getInitialException().getMessage());
		}	
		
		jdbc.closeJDBC(); 
		
		return retour;
	}
	
	/**
	 * R�cup�ration des identifiants RTFE associ�s � un identifiant BIP
	 * @return
	 */
	public static LinkedList<String> chargerIdsRtfeFromIdBip(int idRessourceBip, Config configProc, ActionErrors errors) {
		LinkedList<String> retour = new LinkedList<String>();
		Vector vParamOut;

		JdbcBip jdbc = new JdbcBip();
		ParametreProc paramOut;
		Hashtable<String, String> hParamProc = new Hashtable<String, String>();
		hParamProc.put(PACK_CHARGER_RTFE_FROM_IDBIP_PARAM, String.valueOf(idRessourceBip));
		
		try {
			vParamOut = jdbc.getResult(hParamProc,configProc, PACK_CHARGER_RTFE_FROM_IDBIP);

			if (vParamOut != null) {
				for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
					paramOut = (ParametreProc) e1.nextElement();
										
					if (paramOut.getNom().equals(PACK_CHARGER_RTFE_FROM_IDBIP_CURSEUR)) {
						if (paramOut.getValeur() != null) {
							ResultSet rset = (ResultSet) paramOut.getValeur();
							
							if (rset != null) {
								try {
									while (rset.next()) {
										retour.add(rset.getString(1));
									}
								} catch (SQLException sqle) {
									logService
									.debug("BipConfigRTFE-chargerIdsRtfeFromIdBip() --> SQLException :"
											+ sqle);
									logBipUser
											.debug("BipConfigRTFE-chargerIdsRtfeFromIdBip() --> SQLException :"
													+ sqle);
									// Erreur de lecture du resultSet
									errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
											"11217"));
								} finally {
									try {
										if (rset != null)
											rset.close();
									} catch (SQLException sqle) {
										logBipUser
												.debug("BipConfigRTFE-chargerIdsRtfeFromIdBip()  --> SQLException-rset.close() :"
														+ sqle);
										// Erreur de lecture du resultSet
										errors.add(ActionErrors.GLOBAL_ERROR,
												new ActionError("11217"));
									}
								}
							}
						}
					}
				}
			}
		} catch (BaseException be) {
			logBipUser.debug(
					"BipConfigRTFE-chargerIdsBipFromIdRtfe() --> BaseException :" + be,
					be);
			logBipUser.debug("BipConfigRTFE-chargerIdsBipFromIdRtfe() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"BipConfigRTFE-chargerIdsBipFromIdRtfe() --> BaseException :" + be,
					be);
			logService.debug("BipConfigRTFE-chargerIdsBipFromIdRtfe() --> Exception :"
					+ be.getInitialException().getMessage());
		}	
		
		jdbc.closeJDBC(); 
		
		return retour;
	}
	
	/**
	 * Proc�dure de chargement d'utilisateurs
	 * @param idsRtfe : liste d'id RTFE
	 */
	public static Collection<UserBip> chargerUtilisateurs(final LinkedList<String> idsRtfe, Config configProc, ActionErrors errors) {
		final String signatureMethode = "BipConfigRTFE-chargerUtilisateurs()";
		logBipUser.entry(signatureMethode);
		
		LinkedHashMap<String, UserBip> listeUtilisateurs = null;
		
		Vector vParamOut = new Vector();

		ParametreProc paramOut;
		final JdbcBip jdbc = new JdbcBip();
		
		final Hashtable hParamProc =  new Hashtable();
		
		// Si la liste des ids RTFE contient des �l�ments
		if (idsRtfe != null && !idsRtfe.isEmpty()) {
			// Concat�nation des ids RTFE dont on souhaite charger les utilisateus - valeur du param�tre users_rtfe
			String paramConcatIdsRtfe = SEPARATEUR_PARAM_RTFE_USERS;
			
			// Pour chaque �l�ment de la liste des ids RTFE
			for (final String idRtfe : idsRtfe) {
				// Ajout � la chaine de concat�nation
				paramConcatIdsRtfe += idRtfe + SEPARATEUR_PARAM_RTFE_USERS;
			}
			
			// Alimentation de la liste des param�tres hmap
			hParamProc.put(PACK_SELECT_RTFE_USERS_PARAM, paramConcatIdsRtfe);
		}
		
		try{
			// R�cup�ration des utilisateurs RTFE associ�s aux identifiants RTFE
			vParamOut = jdbc.getResult(hParamProc,configProc, PACK_SELECT_RTFE_USERS);
			
			if (vParamOut == null) {
				 logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); 
				 return null;
			}
			
			// R�cup�ration des r�sultats
			for (final Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					
					if (rset != null) {
						try {
							listeUtilisateurs = new LinkedHashMap<String, UserBip>();
							
							// Tant qu'il existe des r�sultats
							while (rset.next()) {
								majListeUtilisateurs(listeUtilisateurs, rset);
							}
							
							rset.close();
							rset = null;
						}
						catch (final SQLException sqle) {
							logService.debug(signatureMethode + " --> SQLException :"	+ sqle);
							logBipUser.debug(signatureMethode + " --> SQLException :"	+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
						}
					}
				}
			}
		}
		catch (final BaseException be) {
			logBipUser.debug(signatureMethode + " --> BaseException :" + be, be);
			logBipUser.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> Exception :" + be.getInitialException().getMessage());
			
			if (!be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			}
			else {
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(""+be.getSubType(), be.getMessage()));
			}
		}
		
		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); 
		
		return (Collection<UserBip>) listeUtilisateurs.values();
	}
	
	/**
	 * Mise � jour de la liste d'utilisateurs � partir d'une ligne r�sultat (entr�e de la table RTFE)
	 * @param listeUtilisateurs
	 * @param rset
	 * @throws SQLException
	 */
	private static void majListeUtilisateurs(LinkedHashMap<String, UserBip> listeUtilisateurs, ResultSet rset) throws SQLException {
		// USER_RTFE (2�me param�tre de retour)
		String paramCurseurRtfeUser = rset.getString(2);
		// Si le 2�me param�tre de retour existe
		if (StringUtils.isNotEmpty(paramCurseurRtfeUser)) {
		
			UserBip utilisateurCourant;
			
			// Si l'utilisateur est d�j� dans la liste 
			if (listeUtilisateurs.containsKey(paramCurseurRtfeUser)) {
				utilisateurCourant = listeUtilisateurs.get(paramCurseurRtfeUser);
			}
			// Si l'utilisateur n'est pas encore pr�sent
			else {
				// Instanciation d'un nouvel utilisateur
				utilisateurCourant = new UserBip();
				utilisateurCourant.init();
				
				// Alimentation des diff�rents attributs uniques communs de l'utilisateur
				utilisateurCourant.setIdUser(paramCurseurRtfeUser);
				utilisateurCourant.setNom(rset.getString(3));
				utilisateurCourant.setPrenom(rset.getString(4));
				
				listeUtilisateurs.put(paramCurseurRtfeUser, utilisateurCourant);
			}
			
			// Alimentation des diff�rents attributs uniques mais non communs de l'utilisateur
			if (StringUtils.isNotEmpty(rset.getString(8))) {
				String dpgDef = BipStringUtil.replacePtVirgParVirg(rset.getString(8));
				
				// Limitation aux 7 derniers caract�res uniquement le DPG  alors que dans la base le BDDPG est sur 11 caract�res
				if (dpgDef != null && dpgDef.length()>7){
					dpgDef = dpgDef.substring(dpgDef.length()-7);
				}
				
				utilisateurCourant.setDpg_Defaut(dpgDef);
			}
		    if(StringUtils.isNotEmpty(rset.getString(11)) && (!"88888".equals(rset.getString(11)))){ // Le code 88888 est un code fictif
			    utilisateurCourant.setClicode_Defaut(BipStringUtil.replacePtVirgParVirg(rset.getString(11)));
		    }
			
			// Alimentation des diff�rents attributs potentiellement multiples de l'utilisateur
			if (StringUtils.isNotEmpty(rset.getString(6))) {
				String menus = BipStringUtil.ajoutSansRedondance(rset.getString(6), utilisateurCourant.getsListeMenu());
				// Ajout du menu DIR aux param�tres RTFE s'il n'est pas d�j� pr�sent.
				boolean dirFound = false;
				if(StringUtils.isNotEmpty(menus)){
					int i = 0;
					while (!dirFound && i < menus.split(",").length) {
						if("dir".equals(menus.split(",")[i])){
							dirFound = true;
						}
						i++;
					}
					if(!dirFound){
						menus+=",dir";
					}
				} 
				else {
					menus = "dir";
				}
				utilisateurCourant.setListeMenus(menus);
			}
	
			if (StringUtils.isNotEmpty(rset.getString(7))) {
				utilisateurCourant.setSousMenus(BipStringUtil.ajoutSansRedondance(rset.getString(7), utilisateurCourant.getSousMenus()));
			}
			if (StringUtils.isNotEmpty(rset.getString(9))) {
				utilisateurCourant.setPerim_ME(BipStringUtil.ajoutSansRedondanceVector(rset.getString(9), utilisateurCourant.getPerim_ME()));
			}
			if (StringUtils.isNotEmpty(rset.getString(10))) {
				//KRA PPM 61776
				String chef_Projet = rset.getString(10);
				  // if(chef_Projet.contains("*")){
					   chef_Projet = Tools.lireListeChefsProjet(chef_Projet);
				//   }				   
				utilisateurCourant.setChef_Projet(BipStringUtil.ajoutSansRedondanceVector(chef_Projet, utilisateurCourant.getChefProjet()));
				//Fin KRA
			}
			if (StringUtils.isNotEmpty(rset.getString(12))) {
				utilisateurCourant.setPerim_MO(BipStringUtil.ajoutSansRedondanceVector(rset.getString(12), utilisateurCourant.getPerim_MO()));
			}
			if (StringUtils.isNotEmpty(rset.getString(13))) {
				utilisateurCourant.setListe_Centres_Frais(BipStringUtil.ajoutSansRedondance(rset.getString(13), utilisateurCourant.getListe_Centres_Frais()));
				// Alimentation du centre de frais et du code filliale
				utilisateurCourant.alimCtrFraisEtCodeFil();
			}
			if (StringUtils.isNotEmpty(rset.getString(14))) {
				utilisateurCourant.setCa_suivi(BipStringUtil.ajoutSansRedondanceVector(rset.getString(14), utilisateurCourant.getCa_suivi()));
			}
			if (StringUtils.isNotEmpty(rset.getString(15))) {
				utilisateurCourant.setProjet(BipStringUtil.ajoutSansRedondance(rset.getString(15), utilisateurCourant.getProjet()));
			}
			if (StringUtils.isNotEmpty(rset.getString(16))) {
				utilisateurCourant.setAppli(BipStringUtil.ajoutSansRedondance(rset.getString(16), utilisateurCourant.getAppli()));
			}
			if (StringUtils.isNotEmpty(rset.getString(17))) {
				utilisateurCourant.setCAFI(BipStringUtil.ajoutSansRedondance(rset.getString(17), utilisateurCourant.getCAFI()));
			}
			if (StringUtils.isNotEmpty(rset.getString(18))) {
				utilisateurCourant.setCAPayeur(BipStringUtil.ajoutSansRedondance(rset.getString(18), utilisateurCourant.getCAPayeur()));
			}
			if (StringUtils.isNotEmpty(rset.getString(19))) {
				utilisateurCourant.setDossProj(BipStringUtil.ajoutSansRedondance(rset.getString(19), utilisateurCourant.getDossProj()));
			}
			if (StringUtils.isNotEmpty(rset.getString(20))) {
				utilisateurCourant.setCADA(BipStringUtil.ajoutSansRedondanceVector(rset.getString(20), utilisateurCourant.getCADA()));
			}
			// Le param 21 n'est pas utilis�
			if (StringUtils.isNotEmpty(rset.getString(22))) {
				utilisateurCourant.setPerim_MCLI(BipStringUtil.ajoutSansRedondanceVector(rset.getString(22), utilisateurCourant.getPerim_MCLI()));
			}
		}
	}

	public ParametreBip getConfigMenus() {
		return configMenus;
	}

	public void setConfigMenus(ParametreBip configMenus) {
		this.configMenus = configMenus;
	}

	public HashMap<String, ParametreBip> getListeConfigChamps() {
		return listeConfigChamps;
	}

	public void setListeConfigChamps(HashMap<String, ParametreBip> listeConfigChamps) {
		this.listeConfigChamps = listeConfigChamps;
	}

	public HashMap<String, ParametreBip> getListeConfigSousMenus() {
		return listeConfigSousMenus;
	}

	public void setListeConfigSousMenus(
			HashMap<String, ParametreBip> listeConfigSousMenus) {
		this.listeConfigSousMenus = listeConfigSousMenus;
	}

	public String getErreurRTFE() {
		return erreurRTFE;
	}

	public void setErreurRTFE(String erreurRTFE) {
		this.erreurRTFE = erreurRTFE;
	}
	
}
