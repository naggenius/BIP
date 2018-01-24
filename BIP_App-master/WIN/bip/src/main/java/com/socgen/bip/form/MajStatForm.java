package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author MMC - 09/07/2003
 *
 * Action de mise à jour des statuts
 * chemin : Administration/Immobilisation/MAJ Statut
 * pages  : fMajstatAd.jsp et mMajstatAd.jsp
 * pl/sql : amortst.sql
 */
public class MajStatForm extends AutomateForm {

	/*pid
	*/
	private String pid;
	/*pnom
	*/
	private String pnom;

	/*filsigle
	*/
	private String filsigle;
	/*typproj
	*/
	private String typproj;
	/*astatut
	*/
	private String astatut;
	/*topfer
	*/
	private String topfer;
	/*top
	*/
	private String top;
	/*adatestatut
	*/
	private String adatestatut;
	/*valid
	*/
	private String valid;
	/*date
	*/
	private String date;
	/*flaglock
	*/
	private int flaglock;
	/*Audit du statut
	*/
	private String date_demande;
	private String demandeur;
	private String commentaire;
	/*Données du dossier projet
	*/
	private String dpcode;
	private String dplib;
	private String datimmo;
	private String actif;
	/*Données du projet
	*/
	private String icpi;
	private String ilibel;
	private String libstatut;
	private String datstatut;
	
	/**
	 * Constructor for MajStatForm.
	 */
	public MajStatForm() {
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
	public ActionErrors validate(
		ActionMapping mapping,
		HttpServletRequest request) {

		ActionErrors errors = new ActionErrors();

		this.logIhm.debug("Début validation de la form -> " + this.getClass());
		// errors.add("Test" , new ActionError("errors.header"));
		logIhm.debug("Fin validation de la form -> " + this.getClass());
		return errors;
	}

	/**
	 * Returns the adatestatut.
	 * @return String
	 */
	public String getAdatestatut() {
		return adatestatut;
	}

	/**
	 * Returns the astatut.
	 * @return String
	 */
	public String getAstatut() {
		return astatut;
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
	 * Returns the pid.
	 * @return String
	 */
	public String getPid() {
		return pid;
	}

	/**
	 * Returns the top.
	 * @return String
	 */
	public String getTop() {
		return top;
	}

	/**
	 * Returns the topfer.
	 * @return String
	 */
	public String getTopfer() {
		return topfer;
	}

	/**
	 * Returns the typproj.
	 * @return String
	 */
	public String getTypproj() {
		return typproj;
	}

	/**
	 * Returns the valid.
	 * @return String
	 */
	public String getValid() {
		return valid;
	}

	/**
	 * Sets the adatestatut.
	 * @param adatestatut The adatestatut to set
	 */
	public void setAdatestatut(String adatestatut) {
		this.adatestatut = adatestatut;
	}

	/**
	 * Sets the astatut.
	 * @param astatut The astatut to set
	 */
	public void setAstatut(String astatut) {
		this.astatut = astatut;
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
	 * Sets the pid.
	 * @param pid The pid to set
	 */
	public void setPid(String pid) {
		this.pid = pid;
	}

	/**
	 * Sets the top.
	 * @param top The top to set
	 */
	public void setTop(String top) {
		this.top = top;
	}

	/**
	 * Sets the topfer.
	 * @param topfer The topfer to set
	 */
	public void setTopfer(String topfer) {
		this.topfer = topfer;
	}

	/**
	 * Sets the typproj.
	 * @param typproj The typproj to set
	 */
	public void setTypproj(String typproj) {
		this.typproj = typproj;
	}

	/**
	 * Sets the valid.
	 * @param valid The valid to set
	 */
	public void setValid(String valid) {
		this.valid = valid;
	}

	/**
	 * Returns the date.
	 * @return String
	 */
	public String getDate() {
		return date;
	}

	/**
	 * Sets the date.
	 * @param date The date to set
	 */
	public void setDate(String date) {
		this.date = date;
	}

	/**
	 * Returns the pnom.
	 * @return String
	 */
	public String getPnom() {
		return pnom;
	}

	/**
	 * Sets the pnom.
	 * @param pnom The pnom to set
	 */
	public void setPnom(String pnom) {
		this.pnom = pnom;
	}

	/**
	 * Returns the commentaire.
	 * @return String
	 */
	public String getCommentaire() {
		return commentaire;
	}

	/**
	 * Returns the date_demande.
	 * @return String
	 */
	public String getDate_demande() {
		return date_demande;
	}

	/**
	 * Returns the demandeur.
	 * @return String
	 */
	public String getDemandeur() {
		return demandeur;
	}

	/**
	 * Returns the dpcode.
	 * @return String
	 */
	public String getDpcode() {
		return dpcode;
	}

	/**
	 * Returns the dplib.
	 * @return String
	 */
	public String getDplib() {
		return dplib;
	}

	/**
	 * Returns the datimmo.
	 * @return String
	 */
	public String getDatimmo() {
		return datimmo;
	}

	/**
	 * Returns the actif.
	 * @return String
	 */
	public String getActif() {
		return actif;
	}

	/**
	 * Returns the icpi.
	 * @return String
	 */
	public String getIcpi() {
		return icpi;
	}

	/**
	 * Returns the ilibel.
	 * @return String
	 */
	public String getIlibel() {
		return ilibel;
	}

	/**
	 * Returns the libstatut.
	 * @return String
	 */
	public String getLibstatut() {
		return libstatut;
	}

	/**
	 * Returns the datstatut.
	 * @return String
	 */
	public String getDatstatut() {
		return datstatut;
	}

	/**
	 * Sets the commentaire.
	 * @param commentaire The commentaire to set
	 */
	public void setCommentaire(String commentaire) {
		this.commentaire = commentaire;
	}

	/**
	 * Sets the date_demande.
	 * @param date_demande The date_demande to set
	 */
	public void setDate_demande(String date_demande) {
		this.date_demande = date_demande;
	}

	/**
	 * Sets the demandeur.
	 * @param demandeur The demandeur to set
	 */
	public void setDemandeur(String demandeur) {
		this.demandeur = demandeur;
	}

	/**
	 * Sets the dpcode.
	 * @param dpcode The dpcode to set
	 */
	public void setDpcode(String dpcode) {
		this.dpcode = dpcode;
	}
	
	/**
	 * Sets the dplib.
	 * @param dplib The dplib to set
	 */
	public void setDplib(String dplib) {
		this.dplib = dplib;
	}

	/**
	 * Sets the datimmo.
	 * @param datimmo The datimmo to set
	 */
	public void setDatimmo(String datimmo) {
		this.datimmo = datimmo;
	}	

	/**
	 * Sets the actif.
	 * @param actif The actif to set
	 */
	public void setActif(String actif) {
		this.actif = actif;
	}
	
	/**
	 * Sets the icpi.
	 * @param icpi The icpi to set
	 */
	public void setIcpi(String icpi) {
		this.icpi = icpi;
	}
	
	/**
	 * Sets the ilibel.
	 * @param ilibel The ilibel to set
	 */
	public void setIlibel(String ilibel) {
		this.ilibel = ilibel;
	}
	
	/**
	 * Sets the libstatut.
	 * @param libstatut The libstatut to set
	 */
	public void setLibstatut(String libstatut) {
		this.libstatut = libstatut;
	}
	
	/**
	 * Sets the datstatut.
	 * @param datstatut The datstatut to set
	 */
	public void setDatstatut(String datstatut) {
		this.datstatut = datstatut;
	}
}