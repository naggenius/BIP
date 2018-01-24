package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author BAA - 05/08/2005
 *
 * représente le formulaire de gestion des ecarts
 * chemin : Ressource Ecarts
 * pages  : bEcartsAd.jsp et fEcartsAd.jsp
 * pl/sql : pack_ressource_ecart.sql
 */
public class ProposeRJHForm extends AutomateForm {

	/*
	 * Année
	 */
	private String annee;
		
	
	/*
	 * Code de la direction
	 */
	private String coddir;

		
	
	/*
	 * mois de la table
	 */
	private String mois_table;
		

	
	/**
	 * Constructeur pour ecartForm
	 */
	public ProposeRJHForm() {
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
	 * Returns the coddir.
	 * @return String
	 */
	public String getCoddir() {
		return coddir;
	}
	
	
	/**
	 * Returns the mois_table.
	 * @return String
	 */
	public String getMois_table() {
		  return mois_table;
	}
	

	
	/**
	 * Sets the annee.
	 * @param type The annee to set
	 */
	public void setAnnee(String string) {
		annee = string;
	}
	

	/**
	  * Sets the coddir.
	  * @param type The coddir to set
	 */
	public void setCoddir(String string) {
		coddir = string;
	}
	
	/**
	  * Sets the mois_table.
	  * @param type The mois_table to set
	  */
	public void setNumtrait(String string) {
		  mois_table = string;
	}
	
		


}
