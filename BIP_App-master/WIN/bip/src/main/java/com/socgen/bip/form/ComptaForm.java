package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 12/06/2003
 *
 * Formulaire pour mise à jour des codes Comptables
 * chemin : Administration/Tables/ mise à jour/Compta
 * pages  : fmComptaAd.jsp et mComptaAd.jsp
 * pl/sql : codecomp.sql
 */
public class ComptaForm extends AutomateForm{

	/*Le code Compta 
	*/
	private String comcode;
    /*Le libelle
	*/
	private String comlib;
	/*Le type
	*/
	private String comtyp ;
	

	/*Le flaglock
	*/
	private int flaglock ;
	
	
	/**
	 * Constructor for ComptaForm.
	 */
	public ComptaForm() {
		super();
	}
	
   /**
     * Validate the properties that have been set from this HTTP request,
     * and return an <code>ActionErrors</code> object that encapsulates any
     * validation errors that have been found.  If no errors are found, return
     * <code>null</code> or an <code>ActionErrors</code> object with no
     * recorded error messages.
     *
     * @param mapping The mapping used to select this instance
     * @param request The servlet request we are processing
     */
    public ActionErrors validate(ActionMapping mapping,
                                 HttpServletRequest request) {


        ActionErrors errors = new ActionErrors();
        
        this.logIhm.debug("Début validation de la form -> " + this.getClass()) ;

        
        logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
        return errors; 
    }
	

	/**
	 * Returns the comcode.
	 * @return String
	 */
	public String getComcode() {
		return comcode;
	}

	/**
	 * Returns the comlib.
	 * @return String
	 */
	public String getComlib() {
		return comlib;
	}

	/**
	 * Returns the comtyp.
	 * @return String
	 */
	public String getComtyp() {
		return comtyp;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Sets the comcode.
	 * @param comcode The comcode to set
	 */
	public void setComcode(String comcode) {
		this.comcode = comcode;
	}

	/**
	 * Sets the comlib.
	 * @param comlib The comlib to set
	 */
	public void setComlib(String comlib) {
		this.comlib = comlib;
	}

	/**
	 * Sets the comtyp.
	 * @param comtyp The comtyp to set
	 */
	public void setComtyp(String comtyp) {
		this.comtyp = comtyp;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

}
