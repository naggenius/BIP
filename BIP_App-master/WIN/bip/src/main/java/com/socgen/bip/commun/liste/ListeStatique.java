package com.socgen.bip.commun.liste;

import java.util.ArrayList;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.log.Log;

/**
 * @author user
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class ListeStatique implements ListeConstantes{
	static Config configListe = ConfigManager.getInstance(BIP_LISTE_STATIQUE) ;
	static Config configListeUpload = ConfigManager.getInstance(BIP_LISTE_REP_UPLOAD) ;

    static String prefixeCle="liste.statique.";
    static ArrayList listeStatique;
    static ArrayList listeStatiqueUpload;
    static Log logBipUser = BipAction.getLogBipUser();
	
	/**
	 * Returns the listeStatique.
	 * @return ArrayList
	 */
	public static ArrayList getListeStatique(String cle) {
		try {
		listeStatique= ListeManager.RecupererListeStatique(configListe.getString(prefixeCle+cle));
		}
		catch (Exception e){
			logBipUser.debug("Problème au niveau de la liste statique :"+e);
		}
		return listeStatique;
	}
	
	/**
	 * Returns the listeStatique contenant les repertoires d'upload des fichiers metiers.
	 * @return ArrayList
	 */
	public static ArrayList getListeStatiqueUpload(String cle) {
		try {
		listeStatiqueUpload= ListeManager.RecupererListeStatique(configListeUpload.getString(cle));
		}
		catch (Exception e){
			logBipUser.debug("Problème au niveau de la liste statique :"+e);
		}
		return listeStatiqueUpload;
	}

}
