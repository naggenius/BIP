package com.socgen.bip.form;


import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author BAA - 30/01/2006
 *
 * Action de mise à jour des comptes 
 * chemin : Administration/Tables/ mise à jour/Compte
 * pages  : fmCompteAd.jsp et mCompteAd.jsp
 * pl/sql : compte.sql
 */
public class CompteForm extends AutomateForm {

	/*Le code Compte
	*/
	private String codcompte ;
	
	/*libellé du compte
	*/
	private String libcompte;
	
	/*Le type du compte
	*/
	private String type;
	

	private int flaglock ;
	/**
	 * Constructor for CompteForm.
	 */
	
	
	public CompteForm() {
		super();
	}

	

	/**
	 * Returns the codcompte.
	 * @return String
	 */
	public String getCodcompte() {
		return codcompte;
	}

	/**
	 * Returns the libcompte.
	 * @return String
	 */
	public String getLibcompte() {
		return libcompte;
	}

	/**
	 * Returns the type.
	 * @return String
	 */
	public String getType() {
		return type;
	}


	/**
	 * Sets the codcompte.
	 * @param codcompte The codcompte to set
	 */
	public void setCodcompte(String codcompte) {
		this.codcompte = codcompte;
	}

	/**
	 * Sets the libcompte.
	 * @param libcompte The libcompte to set
	 */
	public void setLibcompte(String libcompte) {
		this.libcompte = libcompte;
	}

	/**
	 * Sets the type.
	 * @param type The type set
	 */
	public void setType(String type)
	{
		this.type = type;
	}


	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

}
