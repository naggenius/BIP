package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class DomaineForm extends AutomateForm
{
	private String code;
	
    private String libelle;
 
    private String code_ss;
    
    private String libelle_code_ss;
    
    private String top_actif;
    
    private int nbbloc;
    private int nbProjet;
    private int nbDPCOPI;

	public String getTop_actif() {
		return top_actif;
	}

	public void setTop_actif(String top_actif) {
		this.top_actif = top_actif;
	}

	public DomaineForm() {
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

	public String getCode_ss() {
		return code_ss;
	}

	public void setCode_ss(String code_ss) {
		this.code_ss = code_ss;
	}

	public String getLibelle_code_ss() {
		return libelle_code_ss;
	}

	public void setLibelle_code_ss(String libelle_code_ss) {
		this.libelle_code_ss = libelle_code_ss;
	}

	public int getNbbloc() {
		return nbbloc;
	}

	public void setNbbloc(int nbbloc) {
		this.nbbloc = nbbloc;
	}

	public int getNbDPCOPI() {
		return nbDPCOPI;
	}

	public void setNbDPCOPI(int nbDPCOPI) {
		this.nbDPCOPI = nbDPCOPI;
	}

	public int getNbProjet() {
		return nbProjet;
	}

	public void setNbProjet(int nbProjet) {
		this.nbProjet = nbProjet;
	}


    
    
}
