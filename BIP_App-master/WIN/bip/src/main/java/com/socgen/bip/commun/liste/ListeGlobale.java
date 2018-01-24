package com.socgen.bip.commun.liste;

import java.util.ArrayList;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;

/**
 * @author N.BACCAM
 *
 * instancie une liste sur l'ensemble d'une table
 */
public class ListeGlobale implements ListeConstantes{
	static Config configListe = ConfigManager.getInstance("bip_liste_dynamique") ;
	
	static String prefixeCle=LISTE_GLOBALE ; //"liste.table."
    static ArrayList listeGlobale;
    static Log logBipUser = BipAction.getLogBipUser();
	private static String errorBaseMsg;
	
	/** 
	 * Returns the listeGlobale.
	 * @return ArrayList
	 */
	public static ArrayList getListeGlobale(String cleTable) throws BaseException{
		
		String nomTable;
		String signature ="getListeGlobale("+cleTable+")";	
        logBipUser.entry(signature);
        try {
		setErrorBaseMsg("");
		//Récupérer le nom de la table
		nomTable = configListe.getString(prefixeCle+cleTable);		
		listeGlobale = ListeManager.RecupererListeGlobale(nomTable);
        }
	    catch (Exception ex) {
	    		logBipUser.debug("Problème au niveau de la liste globale");
			    setErrorBaseMsg(ex.getMessage());
		}
	    logBipUser.exit(signature);
		return listeGlobale;
	}
	
	public String getErrorBaseMsg() {
			return errorBaseMsg;
		}

		/**
		 * @param string
		 */
	 public static void setErrorBaseMsg(String string) {
			errorBaseMsg = string;
		}
	
	
}
