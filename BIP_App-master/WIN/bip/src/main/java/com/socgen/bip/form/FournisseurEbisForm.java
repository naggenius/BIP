package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

/**
 * @author B.POLLEDRI - 26/04/2007
 *
 * Formulaire pour mise à jour des fournisseurs Ebis (sociétés)
 * chemin : Administration/Tables/ mise à jour/Societe/Fournisseurs
 * pages  : fmFournisseurEbisAd.jsp et mFournisseurEbisAd.jsp
 * pl/sql : agence.sql
 */

public class FournisseurEbisForm extends FournisseurForm{

	/**
	 * Le code SIREN
	 */
	private String fsiren ; 
	
	/*Le code perimetre
	*/   
    private String perimetre ;

	/*Le code referentiel
	*/   
    private String referentiel ;

	/*Le code fournisseur Ebis
	*/   
    private String fournebis ;
    

    
    /**
     * Anciennes valeurs avant update
     */
    
    /*Le code perimetre
	*/   
    private String perimetre_sav ;

	/*Le code referentiel
	*/   
    private String referentiel_sav ;

	/*Le code fournisseur Ebis
	*/   
    private String fournebis_sav ;
    
    /*Le code fsiren_sav
	*/   
    private String fsiren_sav ;

    
    
    
	/**
	 * Constructor for ClientForm.
	 */
	public FournisseurEbisForm() {
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
	 * Returns the perimetre.
	 * @return String
	 */
	public String getPerimetre() {
		return perimetre;
	}
	
	/**
	 * Returns the referentiel.
	 * @return String
	 */
	public String getReferentiel() {
		return referentiel;
	}

	/**
	 * Returns the fournisseur Ebis.
	 * @return String
	 */
	public String getFournebis() {
		return fournebis;
	}
	

	/**
	 * Sets the perimetre.
	 * @param perimetre The perimetre to set
	 */
	public void setPerimetre(String perimetre) {
		this.perimetre = perimetre;
	}
	
	/**
	 * Sets the referentiel.
	 * @param referentiel The refrentiel to set
	 */
	public void setReferentiel(String referentiel) {
		this.referentiel = referentiel;
	}
	
	/**
	 * Sets the founisseur Ebis.
	 * @param fournebis The fournisseur Ebis to set
	 */
	public void setFournebis(String fournebis) {
		this.fournebis = fournebis;
	}

	public String getFournebis_sav() {
		return fournebis_sav;
	}

	public void setFournebis_sav(String fournebis_sav) {
		this.fournebis_sav = fournebis_sav;
	}

	public String getPerimetre_sav() {
		return perimetre_sav;
	}

	public void setPerimetre_sav(String perimetre_sav) {
		this.perimetre_sav = perimetre_sav;
	}

	public String getReferentiel_sav() {
		return referentiel_sav;
	}

	public void setReferentiel_sav(String referentiel_sav) {
		this.referentiel_sav = referentiel_sav;
	}

	public String getFsiren_sav() {
		return fsiren_sav;
	}

	public void setFsiren_sav(String fsiren_sav) {
		this.fsiren_sav = fsiren_sav;
	}

	public String getFsiren() {
		return fsiren;
	}

	public void setFsiren(String fsiren) {
		this.fsiren = fsiren;
	}
}
