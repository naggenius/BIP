package com.socgen.bip.form;

import com.socgen.bip.commun.form.EditionForm;

/**
 * @author Equipe Bip
 * @author E.VINATIER 
 * 
 *  *
 * Classe ActionForm spécifique aux édition de la BIP
 * Le parametre action permette de lancer<br>
 * n'importe quel edition des reestime par activite
 */
public class EditionReForm extends EditionForm
{	
	/**
	 * Valeur de action
	 */
	private String action;

	/**
	 * @return
	 */
	public String getAction()
	{
		return action;
	}

	/**
	 * @param string
	 */
	public void setAction(String string)
	{
		action = string;
	}

}
