/*
 * Created on 12 nov. 03
 * 
 */
package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author S LALLIER
 * Formulaire de base pour le gestion des lignes bugétaires
 */
public class SuiviInvestissementForm extends AutomateForm {
	/**
	 * l'année de l'exercice budgétaire.
	 */
	private String annee;	
	/**
	 * Le centre d'activié de l'utilisateur.
	 */
	private String ca;
	private String libCa;
	/**
	 * le numéro de la ligne budgétaire.
	 */
	private String codinv;
	/*Le flaglock
		*/
	private int flaglock;

	/*KeyList0: sert pour la création de la liste des situations d'une personne
	 * cette clé represente l'identifiant de la ressource
	*/
	protected String keyList0;
	
	/** le code du type de matériel demandé. */
	private String type;
	private String libType;
	
	/**
	 * le projet.
	 */
	private String pcode;
	private String libProjet;
	
	/**
	 * le dossier projet.
	 */
	private String dpcode;
	private String libDossierProjet;
	
	/**
	 * le libellé de la ligne budgétaire.
	 */
	private String libelle;
	
	/**
	 * la quantité de matériel à commander.
	 */
	private String quantite;
	
	/**
	 * le budget demandé.
	 */
	private String demande;
	
	/**
	 * le budget re_estimé par le superviseur.
	 */
	private String re_estime;
	
	/**
	 * Valeur du champ demandé après validation du formulaire.
	 */
	private String notifie;
	
	/**
	 * Total des montants engagés dans les lignes de réalisations correspondantes.
	 */
	private String engage;
	
	/**
	 * Différencte entre demnade et engagé
	 */
	private String disponible;
	
	/**
	 * Le niveau du centre d'activité.
	 */
	private String niveau;
		
	/**
	 * Le max des numéros des lignes de réalisations.
	 */
	private String codrea;

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

		logIhm.debug("Fin validation de la form -> " + this.getClass());
		return errors;
	}
	
	private String getAnneeCourante(){
		java.util.Date data = new java.util.Date(System.currentTimeMillis());
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy");
		return  sdf.format(data);
	}

	//-------------------------------------------------------------
	//accessors

	public String getAnnee() {
		return annee;
	}

	public String getCa() {
		return ca;
	}

	public String getCodinv() {
		return codinv;
	}

	public int getFlaglock() {
		return flaglock;
	}

	public String getKeyList0() {
		return keyList0;
	}

	public void setAnnee(String string) {
		annee = string;
	}

	public void setCa(String string) {
		ca = string;
	}

	public void setCodinv(String string) {
		codinv = string;
	}

	public void setFlaglock(int i) {
		flaglock = i;
	}

	public void setKeyList0(String key) {
		keyList0 = key;
	}

	public String getDpcode() {
		return dpcode;
	}

	public String getLibelle() {
		return libelle;
	}

	public String getPcode() {
		return pcode;
	}

	public String getDemande() {
		return demande;
	}

	public String getQuantite() {
		return quantite;
	}

	public String getRe_estime() {
		return re_estime;
	}

	public String getType() {
		return type;
	}

	public void setDpcode(String string) {
		dpcode = string;
	}

	public void setLibelle(String string) {
		libelle = string;
	}

	public void setPcode(String string) {
		pcode = string;
	}

	public void setDemande(String string) {
		demande = string;
	}

	public void setQuantite(String string) {
		quantite = string;
	}

	public void setRe_estime(String string) {
		re_estime = string;
	}

	public void setType(String string) {
		type = string;
	}	
	
	public String getCodrea() {
		return codrea;
	}

	public void setCodrea(String string) {
		codrea = string;
	}

	public String getNotifie() {
		return notifie;
	}

	public void setNotifie(String string) {
		notifie = string;
	}

	public String getNiveau() {
		return niveau;
	}

	public void setNiveau(String string) {
		niveau = string;
	}

	public String getEngage() {
		return engage;
	}

	public void setEngage(String string) {
		engage = string;
	}

	public String getDisponible() {
		return disponible;
	}

	public void setDisponible(String string) {
		disponible = string;
	}

	public String getLibCa() {
		return libCa;
	}

	public String getLibDossierProjet() {
		return libDossierProjet;
	}

	public String getLibProjet() {
		return libProjet;
	}

	public String getLibType() {
		return libType;
	}

	public void setLibCa(String string) {
		libCa = string;
	}

	public void setLibDossierProjet(String string) {
		libDossierProjet = string;
	}

	public void setLibProjet(String string) {
		libProjet = string;
	}

	public void setLibType(String string) {
		libType = string;
	}

}
