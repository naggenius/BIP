package com.socgen.bip.metier;

public class FavoriRessource {

	private String ident;
	
	private String favori;
	
	private String rattachementDirect;
	
	private String nom;
	
	private String prenom;
	
	private String type;

	public FavoriRessource() {
		super();
		// TODO Auto-generated constructor stub
	}

	public FavoriRessource(String ident, String favori, String rattachementDirect, String nom, String prenom, String type) {
		super();
		this.ident = ident;
		this.favori = favori;
		this.rattachementDirect = rattachementDirect;
		this.nom = nom;
		this.prenom = prenom;
		this.type = type;
	}

	public String getFavori() {
		return favori;
	}

	public void setFavori(String favori) {
		this.favori = favori;
	}

	public String getRattachementDirect() {
		return rattachementDirect;
	}

	public void setRattachementDirect(String rattachementDirect) {
		this.rattachementDirect = rattachementDirect;
	}

	public String getNom() {
		return nom;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}

	public String getPrenom() {
		return prenom;
	}

	public void setPrenom(String prenom) {
		this.prenom = prenom;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getIdent() {
		return ident;
	}

	public void setIdent(String ident) {
		this.ident = ident;
	}
	
}
