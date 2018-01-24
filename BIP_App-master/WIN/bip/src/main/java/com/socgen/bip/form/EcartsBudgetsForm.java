package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author DDI - 24/03/2006
 *
 * représente le formulaire de gestion des ecarts budgétaires
 * chemin : Budget JH / Ecarts Budgétaires
 * pages  : bEcartsBudgetsAd.jsp
 * pl/sql : pack_budget_ecart.sql  
 */
public class EcartsBudgetsForm extends AutomateForm {

	/*
	 * Code DPG
	 */
	private String codsg;
		
	
	/*
	 * type de validaion
	 */
	private String valide;
		
	
	/*
	 * numero du traitement
	 */
	private String numtrait;
		
		
	/*
	 * message du traitement
	 */
	private String msgtrait;			
	 
	 
	/*
	 * date du prochain traitement
	 */
	 private String nexttrait;
				
				
				
	/*
		 * nom du responsable du groupe
		 */
		private String gnom;
										 
	 
	
	/**
	 * Constructeur pour ecartForm
	 */
	public EcartsBudgetsForm() {
		super();
	}

	

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}


	/**
	 * Returns the valider.
	 * @return String
	 */
	public String getValider() {
	   return valide;
	}
	
	
	/**
	 * Returns the numtrait.
	 * @return String
	 */
	public String getNumtrait() {
		  return numtrait;
	}
	

	/**
	 * Returns the msgtrait.
	 * @return String
	 */
	public String getMsgtrait() {
		  return msgtrait;
	}
		
		
	/**
	 * Returns the nexttrait.
	 * @return String
	 */
	public String getNexttrait() {
		  return nexttrait;
	}	
     
    

	/**
	 * Returns the gnom.
	 * @return String
	 */
	public String getGnom() {
		return gnom;
	}

	
	/**
	 * Sets the codsg.
	 * @param type The codsg to set
	 */
	public void setCodsg(String string) {
		codsg = string;
	}
	

	/**
	 * Sets the valider.
	 * @param type The valider to set
	 */
	public void setValider(String string) {
		valide = string;
	}
	
	
	/**
	  * Sets the numtrait.
	  * @param type The numtrait to set
	  */
	public void setNumtrait(String string) {
		  numtrait = string;
	}
	
	

	/**
	  * Sets the msgtrait.
	  * @param type The msgtrait to set
	  */
	public void setMsgtrait(String string) {
		  msgtrait = string;
	}
	

	/**
	  * Sets the nexttrait.
	  * @param type The nexttrait to set
	  */
	public void setNexttrait(String string) {
		  nexttrait = string;
	}
	
	
	/**
	 * Sets the gnom.
	 * @param type The gnom to set
	 */
	public void setGnom(String gnom) {
		this.gnom = gnom;
	}
}
