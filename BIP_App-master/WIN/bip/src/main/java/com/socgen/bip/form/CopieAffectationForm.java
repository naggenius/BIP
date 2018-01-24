package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author BAA - 13/09/2005
 *
 * Formulaire de copie des affectations d'une ressource à l'autre
 * chemin : Saisie des réalisés/Copier affectation ressource
 * pages  : fCopieAffectationSr.jsp
 * pl/sql : isac_copie.sql
 */
public class CopieAffectationForm extends AutomateForm{
	/*La ressource à copier
	*/
	private String ident1;
	/*La ressource à affecter
	*/
	private String ident2;
	
		
	 /**
	 * Constructor for ClientForm.
	 */
	public CopieAffectationForm() {
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
	 * Returns the ident1.
	 * @return String
	 */
	public String getIdent1() {
		return ident1;
	}

	/**
	 * Returns the ident2.
	 * @return String
	 */
	public String getIdent2() {
		return ident2;
	}
	
		

	/**
	 * Sets the ident1.
	 * @param pid1 The ident1 to set
	 */
	public void setIdent1(String ident1) {
		this.ident1 = ident1;
	}

	/**
	 * Sets the ident2.
	 * @param ident2 The ident2 to set
	 */
	public void setIdent2(String ident2) {
		this.ident2 = ident2;
	}
	


}
