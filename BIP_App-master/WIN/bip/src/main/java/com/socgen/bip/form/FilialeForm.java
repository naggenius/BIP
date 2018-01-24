package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 12/06/2003
 *
 * Formulaire pour mise à jour des codes Filiales 
 * chemin : Administration/Tables/ mise à jour/Filiales
 * pages  : fmFilialeAd.jsp et mFilialeAd.jsp
 * pl/sql : filialec.sql
 */
public class FilialeForm extends AutomateForm{
	
	/*Le code Filiale 
	*/
	private String filcode ;
    /*Le sigle
	*/
	private String filsigle ;
	/*Le top immobilisation
	*/
	private String top_immo ;
	/*Le top SDFF
	*/
	private String top_sdff ;

	/*Le flaglock
	*/
	private int flaglock ;
	
	
	/**
	 * Constructor for FilialeForm.
	 */
	public FilialeForm() {
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
	 * Returns the filcode.
	 * @return String
	 */
	public String getFilcode() {
		return filcode;
	}

	/**
	 * Returns the filsigle.
	 * @return String
	 */
	public String getFilsigle() {
		return filsigle;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the top_immo.
	 * @return String
	 */
	public String getTop_immo() {
		return top_immo;
	}

	/**
	 * Returns the top_sdff.
	 * @return String
	 */
	public String getTop_sdff() {
		return top_sdff;
	}

	/**
	 * Sets the filcode.
	 * @param filcode The filcode to set
	 */
	public void setFilcode(String filcode) {
		this.filcode = filcode;
	}

	/**
	 * Sets the filsigle.
	 * @param filsigle The filsigle to set
	 */
	public void setFilsigle(String filsigle) {
		this.filsigle = filsigle;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the top_immo.
	 * @param top_immo The top_immo to set
	 */
	public void setTop_immo(String top_immo) {
		this.top_immo = top_immo;
	}

	/**
	 * Sets the top_sdff.
	 * @param top_sdff The top_sdff to set
	 */
	public void setTop_sdff(String top_sdff) {
		this.top_sdff = top_sdff;
	}

}
