package com.socgen.bip.form;


import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 11/06/2003
 *
 * Formulaire pour mise à jour des Type1
 * chemin : Administration/Tables/ mise à jour/Type1
 * pages  : fmType1Ad.jsp et mType1Ad.jsp
 * pl/sql : Type1.sql
 */
public class Type1Form extends AutomateForm{
	/*Le code Type1
	*/
	private String typproj ;
	/*Le libelle
	*/
    private String libtyp;
	/*Le flaglock
	*/
	private int flaglock ;
	
	
	/**
	 * Constructor for Type1Form.
	 */
	public Type1Form() {
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
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the libtyp.
	 * @return String
	 */
	public String getLibtyp() {
		return libtyp;
	}

	/**
	 * Returns the typproj.
	 * @return String
	 */
	public String getTypproj() {
		return typproj;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the libtyp.
	 * @param libtyp The libtyp to set
	 */
	public void setLibtyp(String libtyp) {
		this.libtyp = libtyp;
	}

	/**
	 * Sets the typproj.
	 * @param typproj The typproj to set
	 */
	public void setTypproj(String typproj) {
		this.typproj = typproj;
	}

}
