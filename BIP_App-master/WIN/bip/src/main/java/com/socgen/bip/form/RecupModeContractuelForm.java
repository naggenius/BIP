package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosModeContractuel;

public class RecupModeContractuelForm extends AutomateForm
{
	private String nomRecherche ;
	//private InfosPersonne[] listeNomsPrestatio;
	
	private String localisation;
	private String modeContractuelInd;
	private String libMdeContractuelInd;
	private String  rtype;
	private String typfact;
	private InfosModeContractuel[] listeModeContractuel;
	private String windowTitle ;
	public String nomChampDestinataire1;
	public String nomChampDestinataire2;
	public String habilitationPage;
	public String choix;
	// choix effectué dans le popup avec ou sans rais d'envionnement
	public String typeforfait;
	public String getChoix() {
		return choix;
	}

	public void setChoix(String choix) {
		this.choix = choix;
	}

	/**
	 * @return
	 */
	public String getNomRecherche() {
		return nomRecherche;
	}

	/**
	 * @param string
	 */
	public void setNomRecherche(String string) {
		nomRecherche = string;
	}

	/**
	 * @return
	 */
	public InfosModeContractuel[] getListeModeContractuel() {
		return listeModeContractuel;
	}

	/**
	 * @param personnes
	 */
	public void setListeModeContractuel(InfosModeContractuel[] personnes) {
		listeModeContractuel = personnes;
	}

	/**
	 * @return
	 */
	public String getWindowTitle() {
		return windowTitle;
	}

	/**
	 * @param string
	 */
	public void setWindowTitle(String string) {
		windowTitle = string;
	}

	/**
	 * @return
	 */
	public String getHabilitationPage() {
		return habilitationPage;
	}

	/**
	 * @param string
	 */
	public void setHabilitationPage(String string) {
		habilitationPage = string;
	}

	public void removeListe(HttpServletRequest request){
		(request.getSession(false)).removeAttribute("listeRechercheId");	
	}

	public String getLocalisation() {
		return localisation;
	}

	public void setLocalisation(String localisation) {
		this.localisation = localisation;
	}

	public String getModeContractuelInd() {
		return modeContractuelInd;
	}

	public void setModeContractuelInd(String modeContractuelInd) {
		this.modeContractuelInd = modeContractuelInd;
	}

	public String getNomChampDestinataire1() {
		return nomChampDestinataire1;
	}

	public void setNomChampDestinataire1(String nomChampDestinataire1) {
		this.nomChampDestinataire1 = nomChampDestinataire1;
	}

	public String getNomChampDestinataire2() {
		return nomChampDestinataire2;
	}

	public void setNomChampDestinataire2(String nomChampDestinataire2) {
		this.nomChampDestinataire2 = nomChampDestinataire2;
	}

	public String getLibMdeContractuelInd() {
		return libMdeContractuelInd;
	}

	public void setLibMdeContractuelInd(String libMdeContractuelInd) {
		this.libMdeContractuelInd = libMdeContractuelInd;
	}

	public String getRtype() {
		return rtype;
	}

	public void setRtype(String rtype) {
		this.rtype = rtype;
	}

	public String getTypfact() {
		return typfact;
	}

	public void setTypfact(String typfact) {
		this.typfact = typfact;
	}

	public String getTypeforfait() {
		return typeforfait;
	}

	public void setTypeforfait(String typeforfait) {
		this.typeforfait = typeforfait;
	}
	
	
	
}