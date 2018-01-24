package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosDirection;

public class RecupIdDirectionForm extends AutomateForm 
{
	
	private InfosDirection[] listeDirections;

	private String windowTitle ;
	public String nomChampDestinataire;
	public String habilitationPage;
	
	
	
	public RecupIdDirectionForm() {
		super();
		// TODO Raccord de constructeur auto-généré
	}
	

	
	public String getHabilitationPage() {
		return habilitationPage;
	}



	public void setHabilitationPage(String habilitationPage) {
		this.habilitationPage = habilitationPage;
	}



	public InfosDirection[] getListeDirections() {
		return listeDirections;
	}



	public void setListeDirections(InfosDirection[] listeDirections) {
		this.listeDirections = listeDirections;
	}



	public String getNomChampDestinataire() {
		return nomChampDestinataire;
	}



	public void setNomChampDestinataire(String nomChampDestinataire) {
		this.nomChampDestinataire = nomChampDestinataire;
	}



	public String getWindowTitle() {
		return windowTitle;
	}



	public void setWindowTitle(String windowTitle) {
		this.windowTitle = windowTitle;
	}

}
