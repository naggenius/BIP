package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class BudgetCopiePropMasseForm extends AutomateForm{
	
	private String typeligne;
	private String libelletypeligne;
	
	private String dossproj;
	private String libelledossproj;
	
	private String client;
	private String libelleclient;
	
	private String direction;
	private String libelledirection;
	
	private String annee;
	
	// annee fonctionnelle bip (datdebex)
	private String annee_ref; 
	
	private String message_simulation;

	public BudgetCopiePropMasseForm() {
		super();
		// TODO Auto-generated constructor stub
	}

	public String getTypeligne() {
		return typeligne;
	}

	public void setTypeligne(String typeligne) {
		this.typeligne = typeligne;
	}

	public String getDossproj() {
		return dossproj;
	}

	public void setDossproj(String dossproj) {
		this.dossproj = dossproj;
	}

	public String getClient() {
		return client;
	}

	public void setClient(String client) {
		this.client = client;
	}

	public String getDirection() {
		return direction;
	}

	public void setDirection(String direction) {
		this.direction = direction;
	}

	public String getAnnee() {
		return annee;
	}

	public void setAnnee(String annee) {
		this.annee = annee;
	}

	public String getLibelletypeligne() {
		return libelletypeligne;
	}

	public void setLibelletypeligne(String libelletypeligne) {
		this.libelletypeligne = libelletypeligne;
	}

	public String getLibelleclient() {
		return libelleclient;
	}

	public void setLibelleclient(String libelleclient) {
		this.libelleclient = libelleclient;
	}

	public String getLibelledirection() {
		return libelledirection;
	}

	public void setLibelledirection(String libelledirection) {
		this.libelledirection = libelledirection;
	}

	public String getLibelledossproj() {
		return libelledossproj;
	}

	public void setLibelledossproj(String libelledossproj) {
		this.libelledossproj = libelledossproj;
	}

	public String getMessage_simulation() {
		return message_simulation;
	}

	public void setMessage_simulation(String message_simulation) {
		this.message_simulation = message_simulation;
	}

	public String getAnnee_ref() {
		return annee_ref;
	}

	public void setAnnee_ref(String annee_ref) {
		this.annee_ref = annee_ref;
	}
	
	
	

}
