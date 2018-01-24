/*
 * Created on 12 avr. 05
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.socgen.bip.metier;

/**
 * @author X058813
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class BudActJh {
	/*
	 * Le clicode
	*/
	private String dpcode;
	/*
	 * Le libelle clicode
	*/
	private String dplib;
	/*
	 * Le budget Hors taux
	*/
	private String budgetHtr;
	
	/**
	 * 
	 */
	public BudActJh() {
		super();
	}
	
	/**
	 * 
	 */
	public BudActJh(String dpcode, String dplib, String budgetHtr) {
		this.dpcode = dpcode;
		this.dplib = dplib;
		this.budgetHtr = budgetHtr;
	}

	/**
	 * @return
	 */
	public String getBudgetHtr() {
		return budgetHtr;
	}

	/**
	 * @param string
	 */
	public void setBudgetHtr(String string) {
		budgetHtr = string;
	}

	/**
	 * @return
	 */
	public String getDpcode() {
		return dpcode;
	}

	/**
	 * @return
	 */
	public String getDplib() {
		return dplib;
	}

	/**
	 * @param string
	 */
	public void setDpcode(String string) {
		dpcode = string;
	}

	/**
	 * @param string
	 */
	public void setDplib(String string) {
		dplib = string;
	}

}
