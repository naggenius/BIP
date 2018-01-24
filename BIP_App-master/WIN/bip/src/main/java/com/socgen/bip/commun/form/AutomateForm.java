package com.socgen.bip.commun.form;

import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.log.Log;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author RSRH/ICH/GMO Equipe Bip
 * @author N/BACCAM 25/04/2003
 *
 * Form générique pour les pages de mises à jour de la BIP
 */
public class AutomateForm  extends BipForm {
	
	protected  String action;
	protected  String mode;
	protected  PaginationVector listePourPagination;
	
	protected  Log logIhm = null ;

	public static String modeCreer = "insert";
	public static String modeModifier = "update";
	public static String modeSupprimer = "delete";
	
	/**
	 * Constructor for selectForm.
	 */
	public AutomateForm() {
		ServiceManager.getInstance().init(this);
		ServiceManager sm ;
		sm = ServiceManager.getInstance() ;
		logIhm = sm.getLogManager().getLogIhm();
		logIhm.debug("Début validate AutomateForm -> " + getClass()) ; 
        logIhm.debug( "Fin validate AutomateForm -> " + getClass()) ;
	}
	
	/**
	 * Returns the action.
	 * @return String
	 */
	public String getAction() {
		return action;
	}

	/**
	 * Sets the action.
	 * @param action The action to set
	 */
	public void setAction(String action) {
		this.action = action;
	}

	/**
	 * Returns the mode.
	 * @return String
	 */
	public String getMode() {
		return mode;
	}

	/**
	 * Sets the mode.
	 * @param mode The mode to set
	 */
	public void setMode(String mode) {
		this.mode = mode;
	}

  

	/**
	 * Returns the listePourPagination.
	 * @return PaginationVector
	 */
	public PaginationVector getListePourPagination() {
		return listePourPagination;
	}

	/**
	 * Sets the listePourPagination.
	 * @param listePourPagination The listePourPagination to set
	 */
	public void setListePourPagination(PaginationVector listePourPagination) {
		this.listePourPagination = listePourPagination;
	}
	
	/**
	 * Indicateur sur l'action : true si et seulement si l'action est créer ou valider
	 * @return
	 */
	public boolean estActionCreerOuValider() {
		return ACTION_CREER.equals(action) || ACTION_VALIDER.equals(action);
	}

}//AutomateForm

