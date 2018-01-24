package com.socgen.bip.form;
import com.socgen.bip.commun.form.EditionForm;

/**
 * @author DSIC/SUP Equipe Bip
 * @author K. HAZARD
 *
 * SuivInvReportForm est la classe mère des formulaires dédiés aux états (reports)
 * pour le suivi d'investissement
 * 
 * @see com.socgen.bip.commun.action.SuivInvReportAction
 */
public class SuivInvEditionForm extends EditionForm
{
	/**
	 * codcamo à garder en session
	 */	
		private String codcamo;
	/**
	 * Returns the codcamo.
	 * @return String
	 */
	public String getCodcamo()
	{
		return codcamo;
	}
	/**
	 * Sets the codcamo.
	 * @param codcamo The codcamo to set
	 */
	public void setCodcamo(String codcamo)
	{
		this.codcamo = codcamo;
	}
}