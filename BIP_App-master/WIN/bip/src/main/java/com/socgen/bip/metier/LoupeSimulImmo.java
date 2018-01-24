package com.socgen.bip.metier;

public class LoupeSimulImmo {
	
	private String select;
	
	private String numero;
	
	private String libelle;

	
	
	public LoupeSimulImmo() {
		super();
		// TODO Auto-generated constructor stub
	}

	public LoupeSimulImmo(String select, String numero, String libelle) {
		super();
		this.select = select;
		this.numero = numero;
		this.libelle = libelle;
	}

	public String getLibelle() {
		return libelle;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	public String getSelect() {
		return select;
	}

	public void setSelect(String select) {
		this.select = select;
	}

	

	public String getNumero() {
		return numero;
	}

	public void setNumero(String numero) {
		this.numero = numero;
	}
	
	

}
