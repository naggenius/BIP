package com.socgen.bip.form;

import java.util.List;

import com.socgen.bip.commun.form.AutomateForm;

public class ContactsForm extends AutomateForm{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7973219424517617015L;

	private List<String> listeContacts;
	
	private List<String> listeVersions;
	
	private String type = null;

	public List<String> getListeContacts() {
		return listeContacts;
	}

	public void setListeContacts(List<String> listeContacts) {
		this.listeContacts = listeContacts;
	}

	public List<String> getListeVersions() {
		return listeVersions;
	}

	public void setListeVersions(List<String> listeVersions) {
		this.listeVersions = listeVersions;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
}
