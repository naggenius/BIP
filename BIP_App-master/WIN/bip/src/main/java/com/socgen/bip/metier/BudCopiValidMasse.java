package com.socgen.bip.metier;

public class BudCopiValidMasse {
	
	private String date_copi;
	
	private String dpcopi;
	
	private String annee;
	
	private String metier;
	
	private String code_four_copi;
	
	private String four_copi;
	
	private String code_type_demande;
	
	private String type_demande;
	
//	Buget Copi Demandé
	private String budgetCopi_1;
	
	//	Buget Copi Decide
	private String budgetCopi_2;
	
	//	Buget Copi cantonné demande
	private String budgetCopi_3;
	
	//	Buget Copi cantonne decide
	private String budgetCopi_4;
	
	//	Buget Copi prévisonnel demande
	private String budgetCopi_5;
	
	//	Buget Copi prévisonnel decide
	private String budgetCopi_6;

	public BudCopiValidMasse() {
		super();
		// TODO Auto-generated constructor stub
	}

	

	public BudCopiValidMasse(String date_copi, String dpcopi, String annee, String metier, String code_four_copi, String four_copi, String code_type_demande, String type_demande, String budgetCopi_1, String budgetCopi_2, String budgetCopi_3, String budgetCopi_4, String budgetCopi_5, String budgetCopi_6) {
		super();
		this.date_copi = date_copi;
		this.dpcopi = dpcopi;
		this.annee = annee;
		this.metier = metier;
		this.code_four_copi = code_four_copi;
		this.four_copi = four_copi;
		this.code_type_demande = code_type_demande;
		this.type_demande = type_demande;
		this.budgetCopi_1 = budgetCopi_1;
		this.budgetCopi_2 = budgetCopi_2;
		this.budgetCopi_3 = budgetCopi_3;
		this.budgetCopi_4 = budgetCopi_4;
		this.budgetCopi_5 = budgetCopi_5;
		this.budgetCopi_6 = budgetCopi_6;
	}



	public String getAnnee() {
		return annee;
	}

	public void setAnnee(String annee) {
		this.annee = annee;
	}

	public String getBudgetCopi_1() {
		return budgetCopi_1;
	}

	public void setBudgetCopi_1(String budgetCopi_1) {
		this.budgetCopi_1 = budgetCopi_1;
	}

	public String getBudgetCopi_2() {
		return budgetCopi_2;
	}

	public void setBudgetCopi_2(String budgetCopi_2) {
		this.budgetCopi_2 = budgetCopi_2;
	}

	public String getBudgetCopi_3() {
		return budgetCopi_3;
	}

	public void setBudgetCopi_3(String budgetCopi_3) {
		this.budgetCopi_3 = budgetCopi_3;
	}

	public String getBudgetCopi_4() {
		return budgetCopi_4;
	}

	public void setBudgetCopi_4(String budgetCopi_4) {
		this.budgetCopi_4 = budgetCopi_4;
	}

	public String getBudgetCopi_5() {
		return budgetCopi_5;
	}

	public void setBudgetCopi_5(String budgetCopi_5) {
		this.budgetCopi_5 = budgetCopi_5;
	}

	public String getBudgetCopi_6() {
		return budgetCopi_6;
	}

	public void setBudgetCopi_6(String budgetCopi_6) {
		this.budgetCopi_6 = budgetCopi_6;
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

	public String getFour_copi() {
		return four_copi;
	}

	public void setFour_copi(String four_copi) {
		this.four_copi = four_copi;
	}

	public String getMetier() {
		return metier;
	}

	public void setMetier(String metier) {
		this.metier = metier;
	}

	public String getType_demande() {
		return type_demande;
	}

	public void setType_demande(String type_demande) {
		this.type_demande = type_demande;
	}

	public String getCode_four_copi() {
		return code_four_copi;
	}

	public void setCode_four_copi(String code_four_copi) {
		this.code_four_copi = code_four_copi;
	}

	public String getCode_type_demande() {
		return code_type_demande;
	}

	public void setCode_type_demande(String code_type_demande) {
		this.code_type_demande = code_type_demande;
	}

	
	
}
