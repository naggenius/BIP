package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 10/06/2003
 *
 * Formulaire pour mise à jour des Immeubles 
 * chemin : Administration/Tables/ mise à jour/Immeubles
 * pages  : fmImmeubleAd.jsp et mImmeubleAd.jsp
 * pl/sql : immeuble.sql
 */
public class ImmeubleForm extends AutomateForm{
	/*Le code Immeuble MO
	*/
	private String icodimm ;
	/*L'addresse abrégée
	*/
    private String iadrabr;
	/*Le flaglock
	*/
	private int flaglock ;
	
	
	/**
	 * Constructor for ImmeubleForm.
	 */
	public ImmeubleForm() {
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
	 * Returns the iadrabr.
	 * @return String
	 */
	public String getIadrabr() {
		return iadrabr;
	}

	/**
	 * Returns the icodimm.
	 * @return String
	 */
	public String getIcodimm() {
		return icodimm;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the iadrabr.
	 * @param iadrabr The iadrabr to set
	 */
	public void setIadrabr(String iadrabr) {
		this.iadrabr = iadrabr;
	}

	/**
	 * Sets the icodimm.
	 * @param icodimm The icodimm to set
	 */
	public void setIcodimm(String icodimm) {
		this.icodimm = icodimm;
	}

}
