package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author MMC - 08/07/2003
 *
 * Formulaire pour mise à jour des proposes
 * chemin : Ligne Bip/Gestion/Proposes
 * pages  : fProposeAd.jsp et Propose.jsp
 * pl/sql : proposes.sql
 */
public class ProposeForm extends AutomateForm{
	/*Le pid
	*/
	private String pid ;
    /* annee
	*/
	private String bpannee;   
	/*Le pnom
	*/
	private String pnom;
    /* Le budget proposé ME
	*/
	private String bpmontme;   
	/*Le budget proposé MO
	*/
	private String bpmontmo;
	/*Appartenance au périmètre ME
	*/
	private String perime;
	/*Appartenance au périmètre MO
	*/
	private String perimo;
	/* le flaglock
	 */
	private String flaglock;
	/*
	 * Date de modification du budget proposé fournisseur
	 */
	private String bpdate; 
	/*
	 * Date de modification du budget proposé client
	 */
	private String bpmedate; 
	/*
	 * identifiant qui réalise l'opération sur le budget proposé par le fournisseur
	 */
	private String ubpmontme;
	/*
	 * identifiant qui réalise l'opération sur le budget proposé par le client
	 */
	private String ubpmontmo;

	/**
	 * Constructor for ProposeForm.
	 */
	public ProposeForm() {
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
	 * Returns the bpannee.
	 * @return String
	 */
	public String getBpannee() {
		return bpannee;
	}

	/**
	 * Returns the bpmont1.
	 * @return String
	 */
	public String getBpmontme() {
		return bpmontme;
	}

	/**
	 * Returns the bpmont2.
	 * @return String
	 */
	public String getBpmontmo() {
		return bpmontmo;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public String getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the pid.
	 * @return String
	 */
	public String getPid() {
		return pid;
	}

	/**
	 * Returns the pnom.
	 * @return String
	 */
	public String getPnom() {
		return pnom;
	}

	/**
	 * Sets the bpannee.
	 * @param bpannee The bpannee to set
	 */
	public void setBpannee(String bpannee) {
		this.bpannee = bpannee;
	}

	/**
	 * Sets the bpmont1.
	 * @param bpmont1 The bpmont1 to set
	 */
	public void setBpmontme(String bpmontme) {
		this.bpmontme = bpmontme;
	}

	/**
	 * Sets the bpmont2.
	 * @param bpmont2 The bpmont2 to set
	 */
	public void setBpmontmo(String bpmontmo) {
		this.bpmontmo = bpmontmo;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(String flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the pid.
	 * @param pid The pid to set
	 */
	public void setPid(String pid) {
		this.pid = pid;
	}

	/**
	 * Sets the pnom.
	 * @param pnom The pnom to set
	 */
	public void setPnom(String pnom) {
		this.pnom = pnom;
	}


	/**
	 * Returns the perime.
	 * @return String
	 */
	public String getPerime() {
		return perime;
	}

	/**
	 * Returns the perimo.
	 * @return String
	 */
	public String getPerimo() {
		return perimo;
	}

	/**
	 * Sets the perime.
	 * @param perime The perime to set
	 */
	public void setPerime(String perime) {
		this.perime = perime;
	}

	/**
	 * Sets the perimo.
	 * @param perimo The perimo to set
	 */
	public void setPerimo(String perimo) {
		this.perimo = perimo;
	}
	/**
	 * Returns the BPDATE.
	 * @return String
	 */
	
	public String getBpdate() {
		return bpdate;
	}

	/**
	 * Sets the BPDATE.
	 * @param BPDATE The bndate to set
	 */
	
	public void setBpdate(String bpdate) {
		this.bpdate = bpdate;
	}
	
	/**
	 * Returns the BPMEDATE.
	 * @return String
	 */
	
	public String getBpmedate() {
		return bpmedate;
	}

	/**
	 * Sets the BPMEDATE.
	 * @param BPMEDATE The bpmedate to set
	 */
	
	public void setBpmedate(String bpmedate) {
		this.bpmedate = bpmedate;
	}
	/**
	 * Returns the UBPMONTME.
	 * @return String
	 */
	
	public String getUbpmontme() {
		return ubpmontme;
	}

	/**
	 * Sets the UBPMONTME.
	 * @param UBPMONTME The ubpmontme to set
	 */
	
	public void setUbpmontme(String ubpmontme) {
		this.ubpmontme = ubpmontme;
	}
	
	/**
	 * Returns the UBPMONTMO.
	 * @return String
	 */
	
	public String getUbpmontmo() {
		return ubpmontmo;
	}

	/**
	 * Sets the UBPMONTMO.
	 * @param UBPMONTMO The ubpmontmo to set
	 */
	
	public void setUbpmontmo(String ubpmontmo) {
		this.ubpmontmo = ubpmontmo;
	}
}	 	
