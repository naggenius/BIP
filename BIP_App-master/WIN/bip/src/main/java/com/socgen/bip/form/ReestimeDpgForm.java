package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author user
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class ReestimeDpgForm extends AutomateForm {
	PaginationVector listeReestime;

	/**
	 * Constructor for ReestimeDpgForm.
	 */
	public ReestimeDpgForm() {
		super();
	}

	/**
	 * Returns the listeReestime.
	 * @return PaginationVector
	 */
	public PaginationVector getListeReestime() {
		return listeReestime;
	}

	/**
	 * Sets the listeReestime.
	 * @param listeReestime The listeReestime to set
	 */
	public void setListeReestime(PaginationVector listeReestime) {
		this.listeReestime = listeReestime;
	}

}
