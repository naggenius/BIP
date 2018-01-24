package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class AuditImmoForm extends AutomateForm{
	
	private String annee;
	
	private String pid;
	
	private String icpi;
	
	private String perim = "false";
	
	private String dpcode;   //TD 760 
	
	private String moismens; // TD 760
	
	private String dplib; // TD 760
	
	private String libprojet; // TD 760

	public AuditImmoForm() {
		super();
		// TODO Auto-generated constructor stub
	}

	public String getAnnee() {
		return annee;
	}

	public void setAnnee(String annee) {
		this.annee = annee;
	}

	public String getIcpi() {
		return icpi;
	}

	public void setIcpi(String icpi) {
		this.icpi = icpi;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getDpcode() {
		return dpcode;
	}

	public void setDpcode(String dpcode) {
		this.dpcode = dpcode;
	}

	public String getMoismens() {
		return moismens;
	}

	public void setMoismens(String moismens) {
		this.moismens = moismens;
	}

	public String getDplib() {
		return dplib;
	}

	public void setDplib(String dplib) {
		this.dplib = dplib;
	}

	public String getLibprojet() {
		return libprojet;
	}

	public void setLibprojet(String libprojet) {
		this.libprojet = libprojet;
	}

	public String getPerim() {
		return perim;
	}

	public void setPerim(String perim) {
		this.perim = perim;
	}
	

}
