package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author DDI - 31/01/2006
 *
 * représente le formulaire de gestion des arbitrés
 * chemin : Ligne BIP /Répartition JH / Arbitrés
 * pages  : bmArbitreRJH.jsp 
 * pl/sql : .sql
 */
public class ArbitreRJHForm extends AutomateForm {

	/*
	 * Année
	 */
	private String annee;
		
	/*
	 * mois de la table
	 */
	private String mois_table;
		
	/*
	 * Code de la direction
	 */
	private String coddir;

	
	/**
	 * Constructeur pour ecartForm
	 */
	public ArbitreRJHForm() {
		super();
	}

	

	/**
	 * Returns the annee.
	 * @return String
	 */
	public String getAnnee() {
		return annee;
	}


	
	
	/**
	 * Returns the mois_table.
	 * @return String
	 */
	public String getMois_table() {
		  return mois_table;
	}
	
	/**
	 * Returns the coddir.
	 * @return String
	 */
	public String getCoddir() {
		return coddir;
	}

	
	/**
	 * Sets the annee.
	 * @param type The annee to set
	 */
	public void setAnnee(String string) {
		annee = string;
	}
	

	
	
	/**
	  * Sets the mois_table.
	  * @param type The mois_table to set
	  */
	public void setNumtrait(String string) {
		  mois_table = string;
	}
	
	/**
	  * Sets the coddir.
	  * @param type The coddir to set
	 */
	public void setCoddir(String string) {
		coddir = string;
	}
		


}
