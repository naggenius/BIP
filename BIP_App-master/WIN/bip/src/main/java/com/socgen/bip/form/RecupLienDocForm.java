package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;
/**
 * @author S.GARCIA - 16/11/2012
 *
 * Formulaire pour la redirection vers la page documentaire
 * Responsable d'étude/Outils/documentation pages : recupLienDoc.jsp
 * pl/sql : pack_url_doc.sql
 */

public class RecupLienDocForm extends AutomateForm{

/**************************
 * Les variables
 * ************************
 */	
	/*
	 * Le message d'erreur applicatif
	 */
	protected  String msgErreur;
	
	/*Libellé du code MO
	 */
	public String liendoc ;
	
/*********************************
* Constructor for RecupLienDocForm.
*/

	public RecupLienDocForm() {
		super();
		// TODO Auto-generated constructor stub
	}

/**************************
* Getters
* ************************
*/		

	/**
	 * Returns the liendoc.
	 * @return String
	 */
	public String getLiendoc() {
		return liendoc;
	}
	
	/**
	 * Returns MsgErreur.
	 * @return String
	 */
	
	public String getMsgErreur() {
		return msgErreur;
	}

/**************************
* Setters
* ************************
*/	
	
	/**
	 * Sets the liendoc.
	 * @param liendoc The liendoc to set
	 */
	
	public void setLiendoc(String liendoc) {
		this.liendoc = liendoc;
	}

	/**
	 * Sets the msgErreur.
	 * @param msgErreur The msgErreur to set
	 */

	public void setMsgErreur(String msgErreur) {
		this.msgErreur = msgErreur;
	} 


}
