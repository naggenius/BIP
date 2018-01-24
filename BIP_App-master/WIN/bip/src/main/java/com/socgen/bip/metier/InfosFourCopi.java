package com.socgen.bip.metier;

public class InfosFourCopi {

	private String code;   //id
	private String libelle;    // name
	private String lienHref;
	
	public InfosFourCopi() {
		super();
		// TODO Raccord de constructeur auto-généré
	}

	public InfosFourCopi(String libelle, String code, String lienHref) {
		super();
		this.libelle = libelle;
		this.code = code;
		this.lienHref = lienHref;
	}
	
	public InfosFourCopi(String libelle, String code) {
		super();
		this.libelle = libelle;
		this.code = code;
		
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getLibelle() {
		return libelle;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	public String getLienHref() {
		return lienHref;
	}

	public void setLienHref(String lienHref) {
		this.lienHref = lienHref;
	}
	
	
}
