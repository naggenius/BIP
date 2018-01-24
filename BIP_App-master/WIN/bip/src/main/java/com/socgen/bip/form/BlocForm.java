package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class BlocForm extends AutomateForm
{
	private String code;
	
    private String libelle;
 
    private String code_d;
    
    private String libelle_code_d;
    
    private String top_actif;
    
    private int nbApplication;

	public String getTop_actif() {
		return top_actif;
	}

	public void setTop_actif(String top_actif) {
		this.top_actif = top_actif;
	}

	public BlocForm() {
		super();
		
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getLibelle() {
		return libelle;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	
	public String getCode_d() {
		return code_d;
	}

	public void setCode_d(String code_d) {
		this.code_d = code_d;
	}

	public String getLibelle_code_d() {
		return libelle_code_d;
	}

	public void setLibelle_code_d(String libelle_code_d) {
		this.libelle_code_d = libelle_code_d;
	}

	public int getNbApplication() {
		return nbApplication;
	}

	public void setNbApplication(int nbApplication) {
		this.nbApplication = nbApplication;
	}
		
	
	

    
    
}

