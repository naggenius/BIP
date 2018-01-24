package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class BranchesForm extends AutomateForm {
	
	private int codbr;
	
	private String libbr;
		
	private String combr;
	
	private int flaglock;
	
	public BranchesForm() {
		super();
		// TODO Raccord de constructeur auto-généré
	}

	public int getCodbr() {
		return codbr;
	}

	public void setCodbr(int codbr) {
		this.codbr = codbr;
	}

	public int getFlaglock() {
		return flaglock;
	}

	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	public String getLibbr() {
		return libbr;
	}

	public void setLibbr(String libbr) {
		this.libbr = libbr;
	}

	public String getCombr() {
		return combr;
	}

	public void setCombr(String combr) {
		this.combr = combr;
	}

}
