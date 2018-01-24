package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.InfosBranche;

public class RecupIdBrancheForm extends AutomateForm 
{
	
	private InfosBranche[] listeBranches;

	private String windowTitle ;
	public String nomChampDestinataire;
	public String habilitationPage;
	
	
	
	public RecupIdBrancheForm() {
		super();
		// TODO Raccord de constructeur auto-généré
	}
	

	
	public String getHabilitationPage() {
		return habilitationPage;
	}



	public void setHabilitationPage(String habilitationPage) {
		this.habilitationPage = habilitationPage;
	}



	public InfosBranche[] getListeBranches() {
		return listeBranches;
	}



	public void setListeBranches(InfosBranche[] listeBranches) {
		this.listeBranches = listeBranches;
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
