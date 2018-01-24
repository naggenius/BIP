package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;



/**
 * @author N.BACCAM - 02/06/2003
 *
 * Formulaire pour mise à jour des codes prestations
 * chemin : Administration/Tables/ mise à jour/Prestations
 * pages  : fmPrestationAd.jsp et mPrestationAd.jsp
 * pl/sql : coutpres.sql
 */
public class PrestationForm extends AutomateForm{
 
 
	/*Le code prestation
	*/   
    private String codprest ;
    /*Le libellé de la prestation
	*/  
    private String libprest ; 
    /*Le cout FI
	*/  
    private String codfi ;
    /*Le top actif
	*/   
    private String top_actif ; 
    
	/*Le flaglock
	*/
	private int flaglock ;
	/*Le code domaine
	*/  
	private String code_domaine ;
	/*Le code d'acha
	*/   
	private String code_acha ; 
    /*Le rtype
	*/
	private String rtype ;
	
	
	
				
	/**
	 * Constructor for ClientForm.
	 */
	public PrestationForm() {
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
	 * Returns the codfi.
	 * @return String
	 */
	public String getCodfi() {
		return codfi;
	}

	/**
	 * Returns the codprest.
	 * @return String
	 */
	public String getCodprest() {
		return codprest;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the libprest.
	 * @return String
	 */
	public String getLibprest() {
		return libprest;
	}

	/**
	 * Returns the top_actif.
	 * @return String
	 */
	public String getTop_actif() {
		return top_actif;
	}
	
	
	/**
	 * Returns the code_domaine.
	 * @return int
	 */
	public String getCode_domaine() {
		return code_domaine;
	}

	/**
	 * Returns the code_acha.
	 * @return String
	 */
	public String getCode_acha() {
		return code_acha;
	}

	/**
	 * Returns the rtype.
	 * @return String
	 */
	public String getRtype() {
		return rtype;
	}
	
	
	

	/**
	 * Sets the codfi.
	 * @param codfi The codfi to set
	 */
	public void setCodfi(String codfi) {
		this.codfi = codfi;
	}

	/**
	 * Sets the codprest.
	 * @param codprest The codprest to set
	 */
	public void setCodprest(String codprest) {
		this.codprest = codprest;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the libprest.
	 * @param libprest The libprest to set
	 */
	public void setLibprest(String libprest) {
		this.libprest = libprest;
	}

	/**
	 * Sets the top_actif.
	 * @param top_actif The top_actif to set
	 */
	public void setTop_actif(String top_actif) {
		this.top_actif = top_actif;
	}
	
	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setCode_domaine(String code_domaine) {
		this.code_domaine = code_domaine;
	}

	/**
	 * Sets the code_acha.
	 * @param libprest The code_acha to set
	 */
	public void setCode_acha(String code_acha) {
		this.code_acha = code_acha;
	}

	/**
	 * Sets the rtype.
	 * @param top_actif The rtype to set
	 */
	public void setRtype(String rtype) {
		this.rtype = rtype;
	}
	

}
