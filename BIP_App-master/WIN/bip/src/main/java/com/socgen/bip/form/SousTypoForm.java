package com.socgen.bip.form;


import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author MMC
 *
 * Formulaire pour mise à jour des sous typologies
 * chemin : Administration/Tables/ mise à jour/Sous typologie
 * pages  : fmSousTypoAd.jsp et mSousTypoAd.jsp
  */
public class SousTypoForm extends AutomateForm{
	/*Le code 
	*/
	private String sous_type ;
	/*Le libelle
	*/
	private String libsoustype;
	/*Le flaglock
	*/
	private int flaglock ;
	
	
	/**
	 * Constructor 
	 */
	public SousTypoForm() {
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
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	
	

	/**
	 * @return
	 */
	public String getLibsoustype() {
		return libsoustype;
	}

	/**
	 * @return
	 */
	public String getSous_type() {
		return sous_type;
	}

	/**
	 * @param string
	 */
	public void setLibsoustype(String string) {
		libsoustype = string;
	}

	/**
	 * @param string
	 */
	public void setSous_type(String string) {
		sous_type = string;
	}

}
