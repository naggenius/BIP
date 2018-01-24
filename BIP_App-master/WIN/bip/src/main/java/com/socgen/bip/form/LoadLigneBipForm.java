package com.socgen.bip.form;

import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.form.AutomateForm;


public class LoadLigneBipForm extends AutomateForm {
         
	
	/*
	 * Fichier à charger
	 */
	private FormFile nomfichier;
	
	/*
	 * Exercice courant
	 */
    private int datdebex; 
    
     /**
	 * Constructor for ClientForm.
	 */
	public LoadLigneBipForm() {
		super();
	}

	

	public FormFile getNomfichier() {
		return nomfichier;
	}

	public void setNomfichier(FormFile nomfichier) {
		this.nomfichier = nomfichier;
	}



	public int getDatdebex() {
		return datdebex;
	}



	public void setDatdebex(int datdebex) {
		this.datdebex = datdebex;
	}
	

}
