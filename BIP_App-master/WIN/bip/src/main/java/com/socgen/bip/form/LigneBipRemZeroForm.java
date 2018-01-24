package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author DDI - 10/10/2005
 *
 * Formulaire pour initialisation des consommés
 * pages : mLigneBipRemZero.jsp
 */  
public class LigneBipRemZeroForm extends AutomateForm{
	/**code BIP
	*/
	private String pid ;
	
	/**
	 * Constructor 
	 */
	public LigneBipRemZeroForm() {
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

	
	public String getPid() {
		return pid;
	}

	public void setPid(String string) {
		pid = string;
	}

}
