package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 02/06/2003
 *
 * Formulaire pour mise à jour des dates du calendrier BIP 
 * chemin : Administration/Exploitation/ MAJ calendrier
 * pages  : fMajcalandAd.jsp et mMajcalendAd.jsp
 * pl/sql : calend.sql
 */
public class CalendrierForm extends AutomateForm{
     
 
	/*Le début du mois
	*/   
    private String calanmois ; 
    /*La date de cloture
	*/   
    private String ccloture ;
    /*La fin du mois
	*/  
    private String cafin ; 
    /*La date de la 1ère prémensuelle
	*/   
    private String cpremens1 ;    
    /*La date de la 2ème prémensuelle
	*/   
    private String cpremens2 ; 
     /*La date de la mensuelle
	*/   
    private String cmensuelle ; 
   /*Le nombre de jour ouvré
	*/   
    private String cjours ; 
	/*Le flaglock
	*/
	private String flaglock ;
	/*Nb jours travailles SG
	 */
	private String cnbjourssg ;
	/*Nb jours travailles SSII
	 */
	private String cnbjoursssii ;
	
	/*pourcentage theorique
	*/
	private String theorique ;

	/*Date début blocage factures EBIS
	 */
	private String debutBlocageEbis ; 
	
	/*Date déblocage factures EBIS
	 */
	private String dateDeblocageFacturesEbis ; 
	
	/**
	 * Constructor for ClientForm.
	 */
	public CalendrierForm() {
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
	 * Returns the cafin.
	 * @return String
	 */
	public String getCafin() {
		return cafin;
	}

	/**
	 * Returns the calanmois.
	 * @return String
	 */
	public String getCalanmois() {
		return calanmois;
	}

	/**
	 * Returns the ccloture.
	 * @return String
	 */
	public String getCcloture() {
		return ccloture;
	}

/**
 * Returns the cjours.
 * @return String
 */
public String getCjours() {
	return cjours;
}

	/**
	 * Returns the cmensuelle.
	 * @return String
	 */
	public String getCmensuelle() {
		return cmensuelle;
	}

	/**
	 * Returns the cpremens1.
	 * @return String
	 */
	public String getCpremens1() {
		return cpremens1;
	}

	/**
	 * Returns the cpremens2.
	 * @return String
	 */
	public String getCpremens2() {
		return cpremens2;
	}

	
	/**
	* Returns the theorique.
	* @return String
	*/
	public String getTheorique() {
		return theorique;
	}
	

	/**
	 * Sets the cafin.
	 * @param cafin The cafin to set
	 */
	public void setCafin(String cafin) {
		this.cafin = cafin;
	}

	/**
	 * Sets the calanmois.
	 * @param calanmois The calanmois to set
	 */
	public void setCalanmois(String calanmois) {
		this.calanmois = calanmois;
	}

	/**
	 * Sets the ccloture.
	 * @param ccloture The ccloture to set
	 */
	public void setCcloture(String ccloture) {
		this.ccloture = ccloture;
	}

/**
 * Sets the cjours.
 * @param cjours The cjours to set
 */
public void setCjours(String cjours) {
	this.cjours = cjours;
}

	/**
	 * Sets the cmensuelle.
	 * @param cmensuelle The cmensuelle to set
	 */
	public void setCmensuelle(String cmensuelle) {
		this.cmensuelle = cmensuelle;
	}

	/**
	 * Sets the cpremens1.
	 * @param cpremens1 The cpremens1 to set
	 */
	public void setCpremens1(String cpremens1) {
		this.cpremens1 = cpremens1;
	}

	/**
	 * Sets the cpremens2.
	 * @param cpremens2 The cpremens2 to set
	 */
	public void setCpremens2(String cpremens2) {
		this.cpremens2 = cpremens2;
	}

	

	/**
	 * Returns the flaglock.
	 * @return String
	 */
	public String getFlaglock() {
		return flaglock;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(String flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * @return
	 */
	public String getCnbjourssg() {
		return cnbjourssg;
	}

	/**
	 * @return
	 */
	public String getCnbjoursssii() {
		return cnbjoursssii;
	}

	/**
	 * @param string
	 */
	public void setCnbjourssg(String string) {
		cnbjourssg = string;
	}

	/**
	 * @param string
	 */
	public void setCnbjoursssii(String string) {
		cnbjoursssii = string;
	}
  
	/**
	* @param string
	*/
	public void setTheorique(String string) {
			theorique = string;
	}
 	
	public String getDateDeblocageFacturesEbis() {
		return this.dateDeblocageFacturesEbis;
	} 
	
	public void setDateDeblocageFacturesEbis(String dateDeblocageFacturesEbis) {
		this.dateDeblocageFacturesEbis = dateDeblocageFacturesEbis;
	}

	public String getDebutBlocageEbis() {
		return debutBlocageEbis;
	}

	public void setDebutBlocageEbis(String debutBlocageEbis) {
		this.debutBlocageEbis = debutBlocageEbis;
	}

	 
	
}
