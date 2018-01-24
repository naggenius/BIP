package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class DirectionsForm extends AutomateForm {
	
	private int coddir;
	
	private String libdir;
	
	private int codbr;
	
	private int topme;
	
	private int flaglock;
	
	private String syscompta;
	
	private String codref;
	
	private String codperim;

	public DirectionsForm() {
		super();
		// TODO Raccord de constructeur auto-généré
	}

	public int getCodbr() {
		return codbr;
	}

	public void setCodbr(int codbr) {
		this.codbr = codbr;
	}

	public int getCoddir() {
		return coddir;
	}

	public void setCoddir(int coddir) {
		this.coddir = coddir;
	}

	public String getCodperim() {
		return codperim;
	}

	public void setCodperim(String codperim) {
		this.codperim = codperim;
	}

	public String getCodref() {
		return codref;
	}

	public void setCodref(String codref) {
		this.codref = codref;
	}

	public int getFlaglock() {
		return flaglock;
	}

	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	public String getLibdir() {
		return libdir;
	}

	public void setLibdir(String libdir) {
		this.libdir = libdir;
	}

	public String getSyscompta() {
		return syscompta;
	}

	public void setSyscompta(String syscompta) {
		this.syscompta = syscompta;
	}

	public int getTopme() {
		return topme;
	}

	public void setTopme(int topme) {
		this.topme = topme;
	}
	
	
	

}
