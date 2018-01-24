package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosPersonne;

public class ExporterTraceDemFactureForm extends AutomateForm
{
	private String nomRecherche ;
	private InfosPersonne[] listeNomsAppli;

	private String windowTitle ;
	public String nomChampDestinataire;
	public String habilitationPage;

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
	public InfosPersonne[] getListeNomsAppli() {
		return listeNomsAppli;
	}

	/**
	 * @param personnes
	 */
	public void setListeNomsAppli(InfosPersonne[] personnes) {
		listeNomsAppli = personnes;
	}

	/**
	 * @return
	 */
	public String getNomChampDestinataire() {
		return nomChampDestinataire;
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
	public void setNomChampDestinataire(String string) {
		nomChampDestinataire = string;
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
}