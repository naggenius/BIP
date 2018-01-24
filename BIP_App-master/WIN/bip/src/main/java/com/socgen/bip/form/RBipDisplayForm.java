/*
 * Créé le 24 août 04
 *
 */
package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 *
 * @author X039435
 */
public class RBipDisplayForm extends AutomateForm
{
	String sIDRemonteur;
	String sPID;
	String sFichier;

	/**
	 * @return
	 */
	public String getPID()
	{
		return sPID;
	}

	/**
	 * @param string
	 */
	public void setPID(String string)
	{
		sPID = string;
	}

	/**
	 * @return
	 */
	public String getFichier()
	{
		return sFichier;
	}

	/**
	 * @param string
	 */
	public void setFichier(String string)
	{
		sFichier = string;
	}

	/**
	 * @return
	 */
	public String getIDRemonteur()
	{
		return sIDRemonteur;
	}

	/**
	 * @param string
	 */
	public void setIDRemonteur(String string)
	{
		sIDRemonteur = string;
	}

}
