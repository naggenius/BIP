package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author MMC - 09/07/2003
 *
 * Action de mise à jour des types d'absence 
 * chemin : Administration/Ressources/BJH/type absence
 * pages  : fmTypeabsAd.jsp et mTypeabsAd.jsp
 * pl/sql : bjh_typea.sql
 */
public class TypeAbsForm extends AutomateForm {

	/*bipabs
	*/
	private String bipabs ;
	
	/*gipabs
	*/
	private String gipabs ;
	
/**
	 * Constructor for DpgForm.
	 */
	public TypeAbsForm() {
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
        // errors.add("Test" , new ActionError("errors.header"));
        logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
        return errors; 
    }	
	/**
	 * Returns the bipabs.
	 * @return String
	 */
	public String getBipabs() {
		return bipabs;
	}

	/**
	 * Returns the gipabs.
	 * @return String
	 */
	public String getGipabs() {
		return gipabs;
	}

	/**
	 * Sets the bipabs.
	 * @param bipabs The bipabs to set
	 */
	public void setBipabs(String bipabs) {
		this.bipabs = bipabs;
	}

	/**
	 * Sets the gipabs.
	 * @param gipabs The gipabs to set
	 */
	public void setGipabs(String gipabs) {
		this.gipabs = gipabs;
	}

}	