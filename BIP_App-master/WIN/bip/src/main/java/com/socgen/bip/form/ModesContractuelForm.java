package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class ModesContractuelForm extends AutomateForm {
	
	private String codcontractuel;
	
	private String commentaire;
	
	private String libelle;
	
	private String typeressource;
	
	private String codlocalisation;
	
	private String topactif;


	public ModesContractuelForm() {
		super();
		// TODO Raccord de constructeur auto-généré
	}


	public String getCodcontractuel() {
		return codcontractuel;
	}


	public void setCodcontractuel(String codcontractuel) {
		this.codcontractuel = codcontractuel;
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


	public String getTopactif() {
		return topactif;
	}


	public void setTopactif(String topactif) {
		this.topactif = topactif;
	}


	public String getTyperessource() {
		return typeressource;
	}


	public void setTyperessource(String typeressource) {
		this.typeressource = typeressource;
	}

	
	
}
