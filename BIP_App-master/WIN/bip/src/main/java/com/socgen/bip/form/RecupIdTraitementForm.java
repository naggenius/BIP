package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.TraitBatch;

public class RecupIdTraitementForm extends AutomateForm 
{
	
	private TraitBatch[] listeTraitements;

	private String windowTitle ;
	public String nomChampDestinataire;
	public String habilitationPage;
	
	
	
	public RecupIdTraitementForm() {
		super();
		// TODO Raccord de constructeur auto-généré
	}
	

	
	public String getHabilitationPage() {
		return habilitationPage;
	}



	public void setHabilitationPage(String habilitationPage) {
		this.habilitationPage = habilitationPage;
	}


	public TraitBatch[] getListeTraitements() {
		return listeTraitements;
	}

	public void setListeTraitements(TraitBatch[] listeTraitements) {
		this.listeTraitements = listeTraitements;
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
