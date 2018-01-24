package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;



/**
 * @author N.BACCAM - 02/06/2003
 *
 * Formulaire pour mise à jour des codes centre activite 
 * chemin : Administration/Tables/ mise à jour/CA MO
 * pages  : fmCamoAd.jsp et mCamoAd.jsp
 * pl/sql : ca_mo.sql
 */
public class CamoForm extends AutomateForm{
 
 
	/*Le code centre d'activite
	*/   
    private String codcamo ; 
    /*Le top amortissable
	*/   
    private String ctopact ;
    /*Le libellé
	*/  
    private String clibca ; 
    /*Le libellé réduit
	*/   
    private String clibrca ;
    
    /* Le code de facturation */   
    private String cdfain ;  
    /* La date d'ouverture */   
    private String cdateouve ;
    /* La date de fermeture */   
    private String cdateferm ;  
   
	/*Le flaglock
	*/
	private int flaglock ;
	
				
	/**
	 * Constructor for ClientForm.
	 */
	public CamoForm() {
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
	 * Returns the clibca.
	 * @return String
	 */
	public String getClibca() {
		return clibca;
	}

	/**
	 * Returns the clibrca.
	 * @return String
	 */
	public String getClibrca() {
		return clibrca;
	}

	/**
	 * Returns the ctopact.
	 * @return String
	 */
	public String getCtopact() {
		return ctopact;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}
	
	/**
	 * Returns the cdfain.
	 * @return String
	 */
	public String getCdfain() {
		return cdfain;
	}
	
	/**
	 * Returns the cdateouve.
	 * @return String
	 */
	public String getCdateouve() {
		return cdateouve;
	}
	
	/**
	 * Returns the flaglock.
	 * @return String
	 */
	public String getCdateferm() {
		return cdateferm;
	}

	

	/**
	 * Sets the clibca.
	 * @param clibca The clibca to set
	 */
	public void setClibca(String clibca) {
		this.clibca = clibca;
	}

	/**
	 * Sets the clibrca.
	 * @param clibrca The clibrca to set
	 */
	public void setClibrca(String clibrca) {
		this.clibrca = clibrca;
	}

	/**
	 * Sets the ctopact.
	 * @param ctopact The ctopact to set
	 */
	public void setCtopact(String ctopact) {
		this.ctopact = ctopact;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Returns the codcamo.
	 * @return String
	 */
	public String getCodcamo() {
		return codcamo;
	}

	/**
	 * Sets the codcamo.
	 * @param codcamo The codcamo to set
	 */
	public void setCodcamo(String codcamo) {
		this.codcamo = codcamo;
	}
	
	/**
	 * Sets the cdfain.
	 * @param cdfain The cdfain to set
	 */
	public void setCdfain(String cdfain) {
		this.cdfain = cdfain;
	}
	
	/**
	 * Sets the cdateouve.
	 * @param cdateouve The cdateouve to set
	 */
	public void setCdateouve(String cdateouve) {
		this.cdateouve = cdateouve;
	}
	
	/**
	 * Sets the cdateferm.
	 * @param cdateferm The cdateferm to set
	 */
	public void setCdateferm(String cdateferm) {
		this.cdateferm = cdateferm;
	}

}
