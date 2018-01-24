package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author MMC - 15/07/2003
 *
 * Validation erreurs
 * chemin : Ressources/BJH/Validation erreurs
 * pages  : bAnomalieAd.jsp 
 * pl/sql : bjh_ano.sql
 */
public class AnomalieForm extends AutomateForm {

	/*ident
	*/
	private String ident ;
	/*codsg
	*/
	private String codsg ;
	/*nom
	*/
	private String nom ;
	/*matricule
	*/
	private String matricule ;
	/*prenom
	*/
	private String prenom ;
	/*mois
	*/
	private String mois ;
	/*typeabsence
	*/
	private String typeabsence ;
	/*dateano
	*/
	private String dateano ;
	/*coutbip
	*/
	private String coutbip ;
	
	/*coutgip
	*/
	private String coutgip ;
	/*diff
	*/
	private String diff ;
	/*ecartcal
	*/
	private String ecartcal ;
	/*validation1
	*/
	private String validation1 ;
	/*validation2
	*/
	private String validation2 ;
	
	private String keyList1 ;
	private String keyList0 ;
	private String ano;
	
	
	/**
	 * Constructor for AnomalieForm.
	 */
	public AnomalieForm() {
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
	 * Returns the coutbip.
	 * @return String
	 */
	public String getCoutbip() {
		return coutbip;
	}

	/**
	 * Returns the coutgip.
	 * @return String
	 */
	public String getCoutgip() {
		return coutgip;
	}

	/**
	 * Returns the dateano.
	 * @return String
	 */
	public String getDateano() {
		return dateano;
	}

	/**
	 * Returns the diff.
	 * @return String
	 */
	public String getDiff() {
		return diff;
	}

	/**
	 * Returns the ecartcal.
	 * @return String
	 */
	public String getEcartcal() {
		return ecartcal;
	}

	/**
	 * Returns the matricule.
	 * @return String
	 */
	public String getMatricule() {
		return matricule;
	}

	/**
	 * Returns the mois.
	 * @return String
	 */
	public String getMois() {
		return mois;
	}

	/**
	 * Returns the nom.
	 * @return String
	 */
	public String getNom() {
		return nom;
	}

	/**
	 * Returns the prenom.
	 * @return String
	 */
	public String getPrenom() {
		return prenom;
	}

	/**
	 * Returns the typeabsence.
	 * @return String
	 */
	public String getTypeabsence() {
		return typeabsence;
	}

	/**
	 * Returns the validation1.
	 * @return String
	 */
	public String getValidation1() {
		return validation1;
	}

	/**
	 * Returns the validation2.
	 * @return String
	 */
	public String getValidation2() {
		return validation2;
	}

	/**
	 * Sets the coutbip.
	 * @param coutbip The coutbip to set
	 */
	public void setCoutbip(String coutbip) {
		this.coutbip = coutbip;
	}

	/**
	 * Sets the coutgip.
	 * @param coutgip The coutgip to set
	 */
	public void setCoutgip(String coutgip) {
		this.coutgip = coutgip;
	}

	/**
	 * Sets the dateano.
	 * @param dateano The dateano to set
	 */
	public void setDateano(String dateano) {
		this.dateano = dateano;
	}

	/**
	 * Sets the diff.
	 * @param diff The diff to set
	 */
	public void setDiff(String diff) {
		this.diff = diff;
	}

	/**
	 * Sets the ecartcal.
	 * @param ecartcal The ecartcal to set
	 */
	public void setEcartcal(String ecartcal) {
		this.ecartcal = ecartcal;
	}

	/**
	 * Sets the matricule.
	 * @param matricule The matricule to set
	 */
	public void setMatricule(String matricule) {
		this.matricule = matricule;
	}

	/**
	 * Sets the mois.
	 * @param mois The mois to set
	 */
	public void setMois(String mois) {
		this.mois = mois;
	}

	/**
	 * Sets the nom.
	 * @param nom The nom to set
	 */
	public void setNom(String nom) {
		this.nom = nom;
	}

	/**
	 * Sets the prenom.
	 * @param prenom The prenom to set
	 */
	public void setPrenom(String prenom) {
		this.prenom = prenom;
	}

	/**
	 * Sets the typeabsence.
	 * @param typeabsence The typeabsence to set
	 */
	public void setTypeabsence(String typeabsence) {
		this.typeabsence = typeabsence;
	}

	/**
	 * Sets the validation1.
	 * @param validation1 The validation1 to set
	 */
	public void setValidation1(String validation1) {
		this.validation1 = validation1;
	}

	/**
	 * Sets the validation2.
	 * @param validation2 The validation2 to set
	 */
	public void setValidation2(String validation2) {
		this.validation2 = validation2;
	}

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * Returns the ident.
	 * @return String
	 */
	public String getIdent() {
		return ident;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Sets the ident.
	 * @param ident The ident to set
	 */
	public void setIdent(String ident) {
		this.ident = ident;
	}

	/**
	 * Returns the keylist0.
	 * @return String
	 */
	public String getKeyList0() {
		return keyList0;
	}

	/**
	 * Returns the keylist1.
	 * @return String
	 */
	public String getKeyList1() {
		return keyList1;
	}

	/**
	 * Sets the keylist0.
	 * @param keylist0 The keylist0 to set
	 */
	public void setKeyList0(String keyList0) {
		this.keyList0 = keyList0;
	}

	/**
	 * Sets the keylist1.
	 * @param keylist1 The keylist1 to set
	 */
	public void setKeyList1(String keyList1) {
		this.keyList1 = keyList1;
	}

	/**
	 * Returns the anomalies.
	 * @return String
	 */
	public String getAno() {
		return ano;
	}

	/**
	 * Sets the anomalies.
	 * @param anomalies The anomalies to set
	 */
	public void setAno(String ano) {
		this.ano = ano;
	}

}	


                                  
                                      
                             