package com.socgen.bip.commun.liste;

import java.util.ArrayList;
import java.util.Hashtable;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.exception.BipException;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;

/**
 * @author user
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class ListeDynamique  {
	static Config configListe = ConfigManager.getInstance("bip_liste_dynamique") ;
    static Log logBipUser = BipAction.getLogBipUser();
    ArrayList listeDynamique;
    
    private String errorBaseMsg;
	
	/**
	 * Constructor for ListeDynamique.
	 */
	public ListeDynamique() {
		super();
	}

	/**
	 * Returns the listeDynamique.
	 * @return ArrayList
	 */
	
   	public ArrayList getListeDynamique(String cle, Hashtable hParamKeyList) {
	 	String signature ="getListeDynamique("+cle+")";	
     	logBipUser.entry(signature);
     	if(cle == null || cle.length() == 0 || hParamKeyList == null ){
			logBipUser.debug("!!! l'un des parametres est null : "+signature);
			logBipUser.debug("!!! cle = " + cle + "; hParamKeyList = [" + hParamKeyList + "]" );		
     	}
     
        try {
			setErrorBaseMsg("");
			//récupérer la chaîne qui caractérise la liste dans bip_liste_dynamique.properties
			String cleProc="liste."+cle;
			//Récupérer le nom de la procédure stockée déclarée dans bip_liste_dynamique.properties
			String procPLSQL= configListe.getString(cleProc); //"pack_liste_dirme.lister_dirme(?,?)";
		
			//paramKeyList:hashtable des paramètres en entrée de la procédure pour liste
			//construire le tableau qui génère la liste dynamique
			listeDynamique = new ListeManager().RecupererListeDynamique(procPLSQL,hParamKeyList,configListe, cleProc);
		} catch (BaseException be) {
			// Exception remontée lors d'un raise
			logBipUser.debug("ListeDynamique-getListeDynamique() --> BaseException :" + be);
			logBipUser.debug("ListeDynamique-getListeDynamique() --> Exception :" + be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")){
				String message = BipException.getMessageOracle(be.getInitialException().getMessage());
				setErrorBaseMsg(message);
			}
		} catch (Exception e) {
			logBipUser.debug("Problème au niveau de la liste dynamique : "+e);			
		}
		
		logBipUser.exit(signature);	
		return listeDynamique;
	}

	/**
	 * @return
	 */
	public String getErrorBaseMsg() {
		return errorBaseMsg;
	}

	/**
	 * @param string
	 */
	public void setErrorBaseMsg(String string) {
		errorBaseMsg = string;
	}

}
