package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class BudCopiMasseForm  extends AutomateForm {
	
	private String dpcopi;
	
	private String date_copi;
	
	private int four_copi;

	private int type_demande;
	
	private int annee;
	
	private java.util.Vector budget = new java.util.Vector() ;
	
	public BudCopiMasseForm() {
		super();
		// TODO Auto-generated constructor stub
	}

	public String getDate_copi() {
		return date_copi;
	}

	public void setDate_copi(String date_copi) {
		this.date_copi = date_copi;
	}

	public String getDpcopi() {
		return dpcopi;
	}

	public void setDpcopi(String dpcopi) {
		this.dpcopi = dpcopi;
	}

	public int getFour_copi() {
		return four_copi;
	}

	public void setFour_copi(int four_copi) {
		this.four_copi = four_copi;
	}

	public int getType_demande() {
		return type_demande;
	}

	public void setType_demande(int type_demande) {
		this.type_demande = type_demande;
	}

	public int getAnnee() {
		return annee;
	}

	public void setAnnee(int annee) {
		this.annee = annee;
	}

	public java.util.Vector getBudget() {
		return budget;
	}

	public void setBudget(java.util.Vector budget) {
		this.budget = budget;
	}

	
	
	
	
	

}
