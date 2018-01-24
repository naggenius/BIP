package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author S LALLIER
 * Formulaire de base pour l'administration des investissements.
 */
public class InvestissementForm extends AutomateForm {

	/**
	 * Le code du type d'investissement.
	 */
	private String type;
	/**
	 * Le libellé du type d'investissement.
	 */
	private String lib_type;
	/**
	 * le poste pour l'investissment.
	 */
	private String poste;
	/**
		 * Le libellé du poste.
		 */
	private String lib_poste;
	/**
	 * la nature de l'investissement.
	 */
	private String nature;
	/**
		 * Le libellé de la nature d'investissement.
		 */
	private String lib_nature;

	/*Le flaglock
	*/
	private int flaglock;

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
	public ActionErrors validate(
		ActionMapping mapping,
		HttpServletRequest request) {

		ActionErrors errors = new ActionErrors();

		this.logIhm.debug("Début validation de la form -> " + this.getClass());

		logIhm.debug("Fin validation de la form -> " + this.getClass());
		return errors;
	}


	public int getFlaglock() {
		return flaglock;
	}

	public String getLib_nature() {
		return lib_nature;
	}

	public String getLib_poste() {
		return lib_poste;
	}

	public String getLib_type() {
		return lib_type;
	}

	public String getNature() {
		return nature;
	}

	public String getPoste() {
		return poste;
	}

	public String getType() {
		return type;
	}

	public void setFlaglock(int i) {
		flaglock = i;
	}

	public void setLib_nature(String string) {
		lib_nature = string;
	}

	public void setLib_poste(String string) {
		lib_poste = string;
	}

	public void setLib_type(String string) {
		lib_type = string;
	}

	public void setNature(String string) {
		nature = string;
	}

	public void setPoste(String string) {
		poste = string;
	}

	public void setType(String string) {
		type = string;
	}

}
