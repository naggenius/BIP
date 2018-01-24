/*
 * Created on 12 avr. 05
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author X058813
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class BudActJhForm  extends AutomateForm{

	/*
	 * L'annee saisie
	*/
	private String annee;   
	/*
	* Le dpcode
	*/
	private String dpcode;
	/*
	* Le dplib
	*/
	private String dplib;
	/*
	 * Le clicode
	*/
	private String clicode;
	/*
	 * Le libelle clicode
	*/
	private String libClicode;
	/*
	 * Le budget Hors taux
	*/
	private String budgetHtr; 
	
 			
	/**
	 * Constructor 
	 */
	public BudActJhForm() {
		super();
	}
	
   /**
	 * Validate the properties that have been set from this HTTP request,
	 * and return an <code>ActionErrors</code> object that encapsulates any
	 * validation errors that have been found.  If no errors are found, return
	 * <code>null</code> or an <code>ActionErrors</code> object with no
	 * recorded error messages.
	 *
	 * @param mapping The mapping used to select this instance
	 * @param request The servlet request we are processing
	 */
	public ActionErrors validate(ActionMapping mapping,
								 HttpServletRequest request) {


		ActionErrors errors = new ActionErrors();
        
		this.logIhm.debug("Début validation de la form -> " + this.getClass()) ;
     
		logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
		return errors; 
	}
	
	

	
	/**
	 * Returns the annee.
	 * @return String
	 */
	public String getAnnee() {
		return annee;
	}

	/**
	 * Sets the annee.
	 * @param annee The annee to set
	 */
	public void setAnnee(String annee) {
		this.annee = annee;
	}
	/**
	 * @return
	 */
	public String getBudgetHtr() {
		return budgetHtr;
	}

	/**
	 * @return
	 */
	public String getClicode() {
		return clicode;
	}

	/**
	 * @return
	 */
	public String getDpcode() {
		return dpcode;
	}

	/**
	 * @param string
	 */
	public void setBudgetHtr(String string) {
		budgetHtr = string;
	}

	/**
	 * @param string
	 */
	public void setClicode(String string) {
		clicode = string;
	}

	/**
	 * @param string
	 */
	public void setDpcode(String string) {
		dpcode = string;
	}

	/**
	 * @return
	 */
	public String getLibClicode() {
		return libClicode;
	}

	/**
	 * @param string
	 */
	public void setLibClicode(String string) {
		libClicode = string;
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
	public void setDplib(String string) {
		dplib = string;
	}

}


