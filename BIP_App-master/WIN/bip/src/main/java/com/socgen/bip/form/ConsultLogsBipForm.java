package com.socgen.bip.form;



import com.socgen.bip.commun.form.AutomateForm;


public class ConsultLogsBipForm extends AutomateForm {
	
	private String datedeb;
	private String datefin;
	
	private String nom_shell;
		
	public ConsultLogsBipForm() {
		super();
	}

	public String getDatedeb() {
		return datedeb;
	}

	public void setDatedeb(String datedeb) {
		this.datedeb = datedeb;
	}

	public String getDatefin() {
		return datefin;
	}

	public void setDatefin(String datefin) {
		this.datefin = datefin;
	}

	public String getNom_shell() {
		return nom_shell;
	}

	public void setNom_shell(String nom_shell) {
		this.nom_shell = nom_shell;
	}
	
	
}
