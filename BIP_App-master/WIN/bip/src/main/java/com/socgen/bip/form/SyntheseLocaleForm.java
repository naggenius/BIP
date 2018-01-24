package com.socgen.bip.form;

import com.socgen.bip.commun.form.EditionForm;

/**
 * @author DISC/SUP Equipe Bip
 * @author B.AARAB
 *
 * Classe ActionForm spécifique aux édition de la BIP
 * Le parametre action permette de lancer<br>
 * n'importe quel synthese locale d'édition de la BIP
 */
public class SyntheseLocaleForm extends EditionForm
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
