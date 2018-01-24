package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

/**
 * @author N.BACCAM - 28/07/2003
 *
 * Formulaire de mise à jour des Taches 
 * chemin : Saisie des réalisés/Paramétrage/Structure LigneBIP
 * pages  : fmTache.jsp et mTache.jsp
 * pl/sql : isac_tache.sql
 */
public class TacheForm extends EtapeForm{
      
	/*Le numéro de la tache affiché
	*/
	protected String acta;
	
	/*Le libellé de la tache
	*/
	protected String libtache;
	
	
	/*Le numéro la tache
	*/
	protected String tache;
	
	// MCH : PPM 61919 chapitre 6.7
	/*La ref_demande de la tache
	*/
	protected String tacheaxemetier;
	
	protected String absence_param;
	
	/*Le keyList1 = n°etape réel
	*/

	private String keyList1;
	/*Le keyList2 = n°etape affiché - libellé étape
	*/
	private String keyList2;
	
	private static String msgErreurSupprTacheSuffixe = "supprimée";
	
     /**
	 * Constructor for ClientForm.
	 */
	public TacheForm() {
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
	 * Returns the acta.
	 * @return String
	 */
	public String getActa() {
		return acta;
	}

	/**
	 * Returns the libtache.
	 * @return String
	 */
	public String getLibtache() {
		return libtache;
	}
	
	/**
	 * Returns the refdemande.
	 * @return String
	 */
	public String getTacheaxemetier() {
		return tacheaxemetier;
	}

	/**
	 * Returns the tache.
	 * @return String
	 */
	public String getTache() {
		return tache;
	}

	/**
	 * Sets the acta.
	 * @param acta The acta to set
	 */
	public void setActa(String acta) {
		this.acta = acta;
	}

	/**
	 * Sets the libtache.
	 * @param libtache The libtache to set
	 */
	public void setLibtache(String libtache) {
		this.libtache = libtache;
	}
	
	/**
	 * Sets the refdemande.
	 * @param refdemande The refdemande to set
	 */
	public void setTacheaxemetier(String tacheaxemetier) {
		this.tacheaxemetier = tacheaxemetier;
	}

	/**
	 * Sets the tache.
	 * @param tache The tache to set
	 */
	public void setTache(String tache) {
		this.tache = tache;
	}

	/**
	 * Returns the keyList1.
	 * @return String
	 */
	public String getKeyList1() {
		return keyList1;
	}

	/**
	 * Sets the keyList1.
	 * @param keyList1 The keyList1 to set
	 */
	public void setKeyList1(String keyList1) {
		this.keyList1 = keyList1;
	}

	/**
	 * Returns the keyList2.
	 * @return String
	 */
	public String getKeyList2() {
		return keyList2;
	}

	/**
	 * Sets the keyList2.
	 * @param keyList2 The keyList2 to set
	 */
	public void setKeyList2(String keyList2) {
		this.keyList2 = keyList2;
	}

	public boolean suppressionOK() {
		return suppressionOK(msgErreurSupprTacheSuffixe);
	}

	public String getAbsence_param() {
		return absence_param;
	}

	public void setAbsence_param(String absence_param) {
		this.absence_param = absence_param;
	}
	
}
