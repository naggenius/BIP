package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class CopiValidDpForm extends AutomateForm {
	
	/**
	 * 
	 */
	
	

	private String dpcopi_prov;
	
	private String dpcopi_def;
	
	private String dpcode;
	
	private String libelle;

	public CopiValidDpForm() {
		super();
	}

	public String getDpcopi_def() {
		return dpcopi_def;
	}

	public void setDpcopi_def(String dpcopi_def) {
		this.dpcopi_def = dpcopi_def;
	}

	public String getDpcopi_prov() {
		return dpcopi_prov;
	}

	public void setDpcopi_prov(String dpcopi_prov) {
		this.dpcopi_prov = dpcopi_prov;
	}

	public String getLibelle() {
		return libelle;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	public String getDpcode() {
		return dpcode;
	}

	public void setDpcode(String dpcode) {
		this.dpcode = dpcode;
	}
	
	
	
	

}
