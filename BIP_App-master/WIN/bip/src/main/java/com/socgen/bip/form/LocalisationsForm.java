package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class LocalisationsForm extends AutomateForm {
	
	private String codlocalisation;
	
	private String commentaire;
	
	private String libelle;
	

	public LocalisationsForm() {
		super();

	}


	public String getCodlocalisation() {
		return codlocalisation;
	}


	public void setCodlocalisation(String codlocalisation) {
		this.codlocalisation = codlocalisation;
	}


	public String getCommentaire() {
		return commentaire;
	}


	public void setCommentaire(String commentaire) {
		this.commentaire = commentaire;
	}


	public String getLibelle() {
		return libelle;
	}


	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	
	
	

}
