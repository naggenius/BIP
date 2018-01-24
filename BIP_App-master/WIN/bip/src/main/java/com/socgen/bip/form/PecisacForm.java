package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;



/**
 * @author N.BACCAM - 25/06/2003
 *
 * Formulaire pour la prise en charge sur ISAC
 * chemin : Administration/Prise en charge ISAC
 * pages  : fPecisacAd.jsp 
 * pl/sql : pmw2isac.sql
 */
public class PecisacForm extends AutomateForm{

	/*Le chef de projet 1
	*/   
    private String cp1 ; 
   /*Le chef de projet 2
	*/   
    private String cp2 ; 
    /*Le chef de projet 3
	*/   
    private String cp3 ; 
    /*Le chef de projet 4
	*/   
    private String cp4 ; 
    /*Le chef de projet 5
	*/   
    private String cp5 ; 
	
				
	/**
	 * Constructor for ClientForm.
	 */
	public PecisacForm() {
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
	 * Returns the cp1.
	 * @return String
	 */
	public String getCp1() {
		return cp1;
	}

/**
 * Returns the cp2.
 * @return String
 */
public String getCp2() {
	return cp2;
}

	/**
	 * Returns the cp3.
	 * @return String
	 */
	public String getCp3() {
		return cp3;
	}

	/**
	 * Returns the cp4.
	 * @return String
	 */
	public String getCp4() {
		return cp4;
	}

	/**
	 * Returns the cp5.
	 * @return String
	 */
	public String getCp5() {
		return cp5;
	}

	/**
	 * Sets the cp1.
	 * @param cp1 The cp1 to set
	 */
	public void setCp1(String cp1) {
		this.cp1 = cp1;
	}

/**
 * Sets the cp2.
 * @param cp2 The cp2 to set
 */
public void setCp2(String cp2) {
	this.cp2 = cp2;
}

	/**
	 * Sets the cp3.
	 * @param cp3 The cp3 to set
	 */
	public void setCp3(String cp3) {
		this.cp3 = cp3;
	}

	/**
	 * Sets the cp4.
	 * @param cp4 The cp4 to set
	 */
	public void setCp4(String cp4) {
		this.cp4 = cp4;
	}

	/**
	 * Sets the cp5.
	 * @param cp5 The cp5 to set
	 */
	public void setCp5(String cp5) {
		this.cp5 = cp5;
	}

}
