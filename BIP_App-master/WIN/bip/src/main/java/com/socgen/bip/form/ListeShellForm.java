package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

public class ListeShellForm extends AutomateForm {
	
	private int id_shell;
	
	private String nom_shell;
		
	private String nom_fich;
	
	private int flaglock;
	
	public ListeShellForm() {
		super();
		// TODO Raccord de constructeur auto-généré
	}

	public int getFlaglock() {
		return flaglock;
	}

	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	public int getId_shell() {
		return id_shell;
	}

	public void setId_shell(int id_shell) {
		this.id_shell = id_shell;
	}

	public String getNom_fich() {
		return nom_fich;
	}

	public void setNom_fich(String nom_fich) {
		this.nom_fich = nom_fich;
	}

	public String getNom_shell() {
		return nom_shell;
	}

	public void setNom_shell(String nom_shell) {
		this.nom_shell = nom_shell;
	}



}
