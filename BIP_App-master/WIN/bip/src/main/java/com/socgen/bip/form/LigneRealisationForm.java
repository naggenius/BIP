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
 * Formulaire de base pour le gestion des lignes de réalisation.
 */
public class LigneRealisationForm extends AutomateForm {
	private String annee;	
	/**
	 * Le centre d'activié de l'utilisateur.
	 */
	private String codcamo;
	private String libCa;
	/**
	 * le numéro de la ligne budgétaire.
	 */
	private String codinv;
	/**
	 * Type de commande.
	 */
	private String type_cmd;	
	/**
	 * Le numérp de commande.
	 */
	private String num_cmd;
	/**
	 * Type d'engagement
	 */
	private String type_eng;
	/**
	 * Type de la ligne d'investissement
	 */
	private String type_ligne;
	/**
	 * Projet
	 */
	private String projet;
	/**
	 * dossier projet
	 */
	private String dossier_projet;
	/**
	 * Disponible HT(ligne inv)
	 */
	private String disponible;
	/**
	 * Disponible HTR(ligne inv)
	 */
	private String disponible_htr;
	/**
	 * Marque.
	 */
	private String marque;
	/*Le flaglock
		*/
	private int flaglock;

	/*KeyList0: sert pour la création de la liste des situations d'une personne
	 * cette clé represente l'identifiant de la ressource
	*/
	protected String keyList0;
	
	/** le modele. */
	private String modele;
	/**
	 * comrea
	 */
	private String comrea;
	
	/**
	 * la date de saisie.
	 */
	private String date_saisie;
	
	/**
	 * Montants engagé pour cette ligne..
	 */
	private String engage;
		
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
	
	//-------------------------------------------------------------
	//accessors

	

	public String getCodrea() {
		return codrea;
	}

	public String getDate_saisie() {
		return date_saisie;
	}

	public String getEngage() {
		return engage;
	}

	public int getFlaglock() {
		return flaglock;
	}

	public String getKeyList0() {
		return keyList0;
	}

	public String getMarque() {
		return marque;
	}

	public String getComrea() {
		return comrea;
	}

	public String getModele() {
		return modele;
	}

	public String getNum_cmd() {
		return num_cmd;
	}

	public String getType_cmd() {
		return type_cmd;
	}

	public String getType_eng() {
		return type_eng;
	}

	public void setCodrea(String string) {
		codrea = string;
	}

	public void setDate_saisie(String string) {
		date_saisie = string;
	}

	public void setEngage(String string) {
		engage = string;
	}

	public void setFlaglock(int i) {
		flaglock = i;
	}

	public void setKeyList0(String string) {
		keyList0 = string;
	}

	public void setMarque(String string) {
		marque = string;
	}

	public void setComrea(String string) {
		comrea = string;
	}

	public void setModele(String string) {
		modele = string;
	}

	public void setNum_cmd(String string) {
		num_cmd = string;
	}

	public void setType_cmd(String string) {
		type_cmd = string;
	}

	public void setType_eng(String string) {
		type_eng = string;
	}

	public String getAnnee() {
		return annee;
	}

	public String getCodcamo() {
		return codcamo;
	}

	public String getCodinv() {
		return codinv;
	}

	public String getLibCa() {
		return libCa;
	}

	public void setAnnee(String string) {
		annee = string;
	}

	public void setCodcamo(String string) {
		codcamo = string;
	}

	public void setCodinv(String string) {
		codinv = string;
	}

	public void setLibCa(String string) {
		libCa = string;
	}

	/**
	 * @return
	 */
	public String getDossier_projet() {
		logIhm.debug("dossier projet GET : '"+dossier_projet+"'");
		return dossier_projet;
	}

	/**
	 * @return
	 */
	public String getProjet() {
		return projet;
	}

	/**
	 * @return
	 */
	public String getType_ligne() {
		return type_ligne;
	}

	/**
	 * @param string
	 */
	public void setDossier_projet(String string) {
		dossier_projet = string;
		logIhm.debug("dossier projet SET : '"+dossier_projet+"'");
	}

	/**
	 * @param string
	 */
	public void setProjet(String string) {
		projet = string;
	}

	/**
	 * @param string
	 */
	public void setType_ligne(String string) {
		type_ligne = string;
	}

	/**
	 * @return
	 */
	public String getDisponible() {
		return disponible;
	}
	/**
	 * @return
	 */
	public String getDisponible_htr() {
		return disponible_htr;
	}
	/**
	 * @param string
	 */
	public void setDisponible(String string) {
		disponible = string;
	}
	/**
	 * @param string
	 */
	public void setDisponible_htr(String string) {
		disponible_htr = string;
	}
}
