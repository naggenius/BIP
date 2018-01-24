/*
 * Créé l4 avril 2008 par E.VINATIER
 */
package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosDpCopi;

public class RecupDPForm extends AutomateForm
{
	private String nomRecherche ;
	private InfosDpCopi[] listeLibellesDpCopi;

	private String type;
	
	private String windowTitle ;
	public String nomChampDestinataire;
	public String habilitationPage;
	public  String rafraichir;	

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
 
	public InfosDpCopi[] getListeLibellesDpCopi() {
		return listeLibellesDpCopi;
	}

	public void setListeLibellesDpCopi(InfosDpCopi[] listeLibellesDpCopi) {
		this.listeLibellesDpCopi = listeLibellesDpCopi;
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

	/**
	 * @return
	 */
	public String getRafraichir() {
		return rafraichir;
	}	
	/**
	 * @param string
	 */
	public void setRafraichir(String string) {
		rafraichir = string;
	}

	public void removeListe(HttpServletRequest request){
		(request.getSession(false)).removeAttribute("listeRechercheId");	
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	
}