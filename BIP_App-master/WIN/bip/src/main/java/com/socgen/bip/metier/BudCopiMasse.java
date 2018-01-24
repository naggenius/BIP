package com.socgen.bip.metier;

public class BudCopiMasse {
	
	//Buget Copi annee n
	private String budgetCopi_1;
	
	//	Buget Copi annee n+1
	private String budgetCopi_2;
	
	//	Buget Copi annee n+2
	private String budgetCopi_3;
	
	//	Buget Copi annee n+3
	private String budgetCopi_4;
	
	//	Buget Copi annee n+4
	private String budgetCopi_5;
	
	//	Buget Copi annee n+5
	private String budgetCopi_6;
	
	// Metier du budget MO, ME, HOM
	private String metier;
	
	/*
	type_bud = 0 correspond au previsionnel précedent
				1 correspond au budget prévisionnel demandé 
           2 correspond au budget préviosnnel decidé 
           3 correspond à l'engagé précedent  
           4 correspond au cantonné précédent
           5 correspond au budget demanndé 
           6 correspond au budget decidé  
           7 correspond au budget cantonné demandé 
           8 correspond au budget cantonne decidé  
	 */
	private int typ_bud;

	public BudCopiMasse() {
		super();
		// TODO Auto-generated constructor stub
	}

	public BudCopiMasse(String budgetCopi_1, String budgetCopi_2, String budgetCopi_3, String budgetCopi_4, String budgetCopi_5, String budgetCopi_6, String metier, int typ_bud) {
		super();
		this.budgetCopi_1 = budgetCopi_1;
		this.budgetCopi_2 = budgetCopi_2;
		this.budgetCopi_3 = budgetCopi_3;
		this.budgetCopi_4 = budgetCopi_4;
		this.budgetCopi_5 = budgetCopi_5;
		this.budgetCopi_6 = budgetCopi_6;
		this.metier = metier;
		this.typ_bud = typ_bud;
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

	public String getMetier() {
		return metier;
	}

	public void setMetier(String metier) {
		this.metier = metier;
	}

	public int getTyp_bud() {
		return typ_bud;
	}

	public void setTyp_bud(int typ_bud) {
		this.typ_bud = typ_bud;
	}

	

	
}
