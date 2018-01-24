package com.socgen.bip.form;



import com.socgen.bip.commun.form.AutomateForm;


public class RequeteForm extends AutomateForm {
	
	private String nom;
	private String ident;
	private String num_contrat;
	private String siren;
	private String fournisseur;
	
	
	private String focus;

		
	public RequeteForm() {
		super();
	}


	public String getFournisseur() {
		return fournisseur;
	}


	public void setFournisseur(String fournisseur) {
		this.fournisseur = fournisseur;
	}


	public String getNom() {
		return nom;
	}


	public void setNom(String nom) {
		this.nom = nom;
	}


	public String getNum_contrat() {
		return num_contrat;
	}


	public void setNum_contrat(String num_contrat) {
		this.num_contrat = num_contrat;
	}


	public String getSiren() {
		return siren;
	}


	public void setSiren(String siren) {
		this.siren = siren;
	}


	public String getIdent() {
		return ident;
	}


	public void setIdent(String ident) {
		this.ident = ident;
	}


	public String getFocus() {
		return focus;
	}


	public void setFocus(String focus) {
		this.focus = focus;
	}


	
	
}
