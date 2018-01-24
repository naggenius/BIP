package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * represente une actualite
 * chemin : Administration/Gestion des actualités
 * pages  : popupActualite.jsp 
 */
public class PopupActualiteForm extends AutomateForm {
	/*
	 */

	private String codes;

	/**
	 * Constructor for .
	 */
	public PopupActualiteForm() {
		super();
	}

	public String getCodes() {
		return codes;
	}

	public void setCodes(String codes) {
		this.codes = codes;
	}

	
}
