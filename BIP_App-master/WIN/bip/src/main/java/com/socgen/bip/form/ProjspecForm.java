package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 11/06/2003
 *
 * Formulaire pour mise à jour des Projets speciaux 
 * chemin : Administration/Tables/ mise à jour/Projets speciaux
 * pages  : fmProjspecAd.jsp et mProjspecAd.jsp
 * pl/sql : prjspc.sql
 */
public class ProjspecForm extends AutomateForm{
	/*Le code Projet special
	*/
	private String codpspe ;
	/*Le libelle
	*/
    private String libpspe;
	/*Le flaglock
	*/
	private int flaglock ;
	
	
	/**
	 * Constructor for ProjspecForm.
	 */
	public ProjspecForm() {
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
	 * Returns the codpspe.
	 * @return String
	 */
	public String getCodpspe() {
		return codpspe;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the libpspe.
	 * @return String
	 */
	public String getLibpspe() {
		return libpspe;
	}

	/**
	 * Sets the codpspe.
	 * @param codpspe The codpspe to set
	 */
	public void setCodpspe(String codpspe) {
		this.codpspe = codpspe;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the libpspe.
	 * @param libpspe The libpspe to set
	 */
	public void setLibpspe(String libpspe) {
		this.libpspe = libpspe;
	}

}
