package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

/**
 * @author N.BACCAM - 9/05/2003
 *
 * Formulaire pour mise à jour des étapes
 * pages : fmEtape.jsp, mEtape.jsp
 */
public class EtapeForm extends StructLbForm{
	/*Le numéro d'étape affiché
	*/
	protected String ecet;
	
	/*Le libellé de l'étape
	*/
	protected String libetape;
	
	/*Le type de l'étape
	*/
	protected String typetape;
	
	/*Le numéro d'étape
	*/
	protected String etape;
	
	private String jeu;
	
	
	/*Le flaglock
	*/
	private String flaglock;
	
	private static String msgErreurSupprEtapeSuffixe = "supprimée";
	
     /**
	 * Constructor for ClientForm.
	 */
	public EtapeForm() {
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
	 * Returns the ecet.
	 * @return String
	 */
	public String getEcet() {
		return ecet;
	}

	/**
	 * Returns the flaglock.
	 * @return String
	 */
	public String getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the libetape.
	 * @return String
	 */
	public String getLibetape() {
		return libetape;
	}

	/**
	 * Returns the typetape.
	 * @return String
	 */
	public String getTypetape() {
		return typetape;
	}

	/**
	 * Sets the ecet.
	 * @param ecet The ecet to set
	 */
	public void setEcet(String ecet) {
		this.ecet = ecet;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(String flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the libetape.
	 * @param libetape The libetape to set
	 */
	public void setLibetape(String libetape) {
		this.libetape = libetape;
	}

	/**
	 * Sets the typetape.
	 * @param typetape The typetape to set
	 */
	public void setTypetape(String typetape) {
		this.typetape = typetape;
	}

	/**
	 * Returns the etape.
	 * @return String
	 */
	public String getEtape() {
		return etape;
	}

	/**
	 * Sets the etape.
	 * @param etape The etape to set
	 */
	public void setEtape(String etape) {
		this.etape = etape;
	}

	public String getJeu() {
		return jeu;
	}

	public void setJeu(String jeu) {
		this.jeu = jeu;
	}

	public boolean suppressionOK() {
		return suppressionOK(msgErreurSupprEtapeSuffixe);
	}

}
