package com.socgen.bip.metier;

public class TypeEtape {


	private String jeu;
	
	private String chronologie;
	
	public TypeEtape() {
		super();
		// TODO Auto-generated constructor stub
	}

	public TypeEtape(String jeu, String chronologie) {
		super();
		this.jeu = jeu;
		this.chronologie = chronologie;
	}

	public String getChronologie() {
		return chronologie;
	}

	public void setChronologie(String chronologie) {
		this.chronologie = chronologie;
	}

	public String getJeu() {
		return jeu;
	}

	public void setJeu(String jeu) {
		this.jeu = jeu;
	}

	
	
}
