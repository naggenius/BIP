package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class SousSystemeForm extends AutomateForm
{
	private String code;
	
    private String libelle;
 
    private String top_actif;
    
    private int nbDomaines;
    
    public SousSystemeForm() {
		super();
		
	}

	public int getNbDomaines() {
		return nbDomaines;
	}

	public void setNbDomaines(int nbDomaines) {
		this.nbDomaines = nbDomaines;
	}

	public String getTop_actif() {
		return top_actif;
	}

	public void setTop_actif(String top_actif) {
		this.top_actif = top_actif;
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


    
    
}
