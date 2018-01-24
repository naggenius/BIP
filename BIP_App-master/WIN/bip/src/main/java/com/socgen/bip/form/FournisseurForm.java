package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

/**
 * @author N.BACCAM - 02/06/2003
 *
 * Formulaire pour mise à jour des fournisseurs (sociétés)
 * chemin : Administration/Tables/ mise à jour/Societe/Foutnisseurs
 * pages  : fmFournisseurAd.jsp et mFournisseurAd.jsp
 * pl/sql : agence.sql
 */
public class FournisseurForm extends SocieteForm{
 
 
	/*Le code fournisseur
	*/   
    private String socfour ; 
    /*Le libellé fournisseur
	*/   
    private String socflib ;  
   
    /*Le SIREN
	*/   
    private String fsiren ;  
    
    /*Le RIB
	*/   
    private String frib ;  
    
    /*Le RIB code banque
	*/   
    private String frib1 ;  
    /*Le RIB code guichet
	*/   
    private String frib2 ;  
    /*Le RIB n°de compte
	*/   
    private String frib3 ;  
    /*Le RIB clef
	*/   
    private String frib4 ;  
    
    /*Le Top actif
	*/   
    private String factif ;  
    
	/*Le flaglock
	*/
	private int flaglock ;
	
				
	/**
	 * Constructor for ClientForm.
	 */
	public FournisseurForm() {
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
	 * Returns the frib.
	 * @return String
	 */
	public String getFrib() {
		return frib;
	}
	/**
	 * Returns the frib.
	 * @return String
	 */
	public String getFrib1() {
		return frib1;
	}
	/**
	 * Returns the frib.
	 * @return String
	 */
	public String getFrib2() {
		return frib2;
	}
	/**
	 * Returns the frib.
	 * @return String
	 */
	public String getFrib3() {
		return frib3;
	}
	/**
	 * Returns the frib.
	 * @return String
	 */
	public String getFrib4() {
		return frib4;
	}
	/**
	 * Returns the fsiren.
	 * @return String
	 */
	public String getFsiren() {
		return fsiren;
	}
	/**
	 * Returns the factif.
	 * @return String
	 */
	public String getFactif() {
		return factif;
	}
	/**
	 * Returns the socfour.
	 * @return String
	 */
	public String getSocfour() {
		return socfour;
	}


	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the frib.
	 * @param frib The frib to set
	 */
	public void setFrib(String frib) {
		this.frib = frib;
	}
	/**
	 * Sets the frib.
	 * @param frib The frib to set
	 */
	public void setFrib1(String frib1) {
		this.frib1 = frib1;
	}
	/**
	 * Sets the frib.
	 * @param frib The frib to set
	 */
	public void setFrib2(String frib2) {
		this.frib2 = frib2;
	}
	/**
	 * Sets the frib.
	 * @param frib The frib to set
	 */
	public void setFrib3(String frib3) {
		this.frib3 = frib3;
	}
	/**
	 * Sets the frib.
	 * @param frib The frib to set
	 */
	public void setFrib4(String frib4) {
		this.frib4 = frib4;
	}
	/**
	 * Sets the fsiren.
	 * @param fsiren The fsiren to set
	 */
	public void setFsiren(String fsiren) {
		this.fsiren = fsiren;
	}
	/**
	 * Sets the factif.
	 * @param factif The factif to set
	 */
	public void setFactif(String factif) {
		this.factif = factif;
	}
	/**
	 * Sets the socfour.
	 * @param socfour The socfour to set
	 */
	public void setSocfour(String socfour) {
		this.socfour = socfour;
	}



	



	/**
	 * Returns the socflib.
	 * @return String
	 */
	public String getSocflib() {
		return socflib;
	}

	/**
	 * Sets the socflib.
	 * @param socflib The socflib to set
	 */
	public void setSocflib(String socflib) {
		this.socflib = socflib;
	}

}
