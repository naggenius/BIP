package com.socgen.bip.commun.parametre;
import java.util.Hashtable;
import java.util.NoSuchElementException;
import java.util.StringTokenizer;
import java.util.Vector;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.log.Log;
/**
 * @author user
 *
 * encapsule la gestion des paramètres IN et OUT
 */
public class ParametreManager {
	protected static final String sLogCat = "BipUser";
	protected static Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);
	private static Log logJdbc = ServiceManager.getInstance().getLogManager().getLogJdbc();
	/**
	 * Constructor for ParametreManager.
	 */
	public ParametreManager() {
		super();
	}
	/**
	 * encapsule la récupération des paramètres OUT de la procédure stockée
	 */
	public  Vector recupererParamOut(
		Config configProc,
		String positionOut) {
		Vector vParamOut = new Vector();
		String position;
		String type;
		String typeOut;
		String nom;
		String chaine;
		StringTokenizer stko;
		String argument;
		//on récupère la chaine qui recense tous les arguments de la procédure
		// de la forme "position1:nom de l'argument1:type;position2:nom de l'argument2:type..."
		chaine = configProc.getString(positionOut);
		StringTokenizer stk = new StringTokenizer(chaine, ";");
		while (stk.hasMoreTokens()) {
			argument = stk.nextToken();
			stko = new StringTokenizer(argument, ":");
			try {
				position = stko.nextToken();
				nom = stko.nextToken();
				type = stko.nextToken();
				vParamOut.add(new ParametreProc(position, nom, type, null));
			}
			catch (NoSuchElementException nse) {
				throw nse;
			}
		}
		return vParamOut;
	}
	/**
	 * encapsule la récupération des paramètres IN pour exécuter la procédure stockée
	 */
	public Vector recupererParamIn(
		Config configProc,
		String positionIn,
		Hashtable hParamIn) {
			
		if(configProc == null || positionIn == null || hParamIn == null)
			logBipUser.debug(" l'un des args est null dans ParametreManager-recuperer(configProc,positionIn,hParamIn)");
			
		Vector vParamIn = new Vector();
		String nom;
		String position;
		String type;
		Object valeur;
		String chaine;
		StringTokenizer stko;
		String argument;
		//on compare les paramètres récupérés de la page JSP stockées dans une hashtable au fichier bip.properties
		//on récupère la chaine qui recense tous les arguments de la procédure
		// de la forme "position1:nom de l'argument1:type;position2:nom de l'argument2:type..."
		try {
			
			chaine = configProc.getString(positionIn);
			StringTokenizer stk = new StringTokenizer(chaine, ";");
			
			while (stk.hasMoreTokens()) {
				argument = stk.nextToken();
				stko = new StringTokenizer(argument, ":");
				position = stko.nextToken();
				nom = stko.nextToken();
				type = stko.nextToken();
				//le nom de l'argument est de la forme P_CODSG
				//le nom du paramètre est de la forme codsg
				//il faut transformer le nom de l'argument qui doit devenir codsg
				//nom = nom.substring(2,nom.length()).toLowerCase();
				//on récupère la valeur du paramètre IN saisie dans la page
				valeur = hParamIn.get(nom);
				if (valeur == null) {
					logBipUser.debug("Null value for : " + nom);
					logJdbc.debug("Null value for : " + nom);
				}
				vParamIn.add(new ParametreProc(position, nom, type, valeur));
			}
		}
		catch (NoSuchElementException e) {
			logBipUser.error(" pas d'elements dans le stringTokenizer.. "+positionIn);
			BipAction.logBipUser.error("Error. Check the code", e);
		}
		catch (Exception e) {
			logBipUser.error(" ParametreManager-recupereParamIn()... ");
			BipAction.logBipUser.error("Error. Check the code", e);			
		}	
		return vParamIn;
	} //recupererParamIn
}
