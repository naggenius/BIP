package com.socgen.bip.metier;

public class Requete {
	
	private String code;
	
	private String fournisseur;
	
	private String siren;
	
	private String nom;
	
	private String prenom;
	
	private String ident;
	
	private String num_contrat;
	
	private String cav;
	
	private String lib_dpg;
	
	private String datdeb;
	
	private String datfin;
	

	public Requete(String fournisseur, String siren, String nom, String prenom, String ident, String num_contrat, String cav, String lib_dpg, String datdeb, String datfin, String code) {
		super();
		this.code = code;
		this.fournisseur = fournisseur;
		this.siren = siren;
		this.nom = nom;
		this.prenom = prenom;
		this.ident = ident;
		this.num_contrat = num_contrat;
		this.cav = cav;
		this.lib_dpg = lib_dpg;
		this.datdeb = datdeb;
		this.datfin = datfin;
	}

	public Requete() {
		super();
		// TODO Raccord de constructeur auto-généré
	}

	public String getCav() {
		return cav;
	}

	public void setCav(String cav) {
		this.cav = cav;
	}

	public String getDatdeb() {
		return datdeb;
	}

	public void setDatdeb(String datdeb) {
		this.datdeb = datdeb;
	}

	public String getDatfin() {
		return datfin;
	}

	public void setDatfin(String datfin) {
		this.datfin = datfin;
	}

	public String getFournisseur() {
		return fournisseur;
	}

	public void setFournisseur(String fournisseur) {
		this.fournisseur = fournisseur;
	}

	public String getLib_dpg() {
		return lib_dpg;
	}

	public void setLib_dpg(String lib_dpg) {
		this.lib_dpg = lib_dpg;
	}

	public String getNom() {
		return nom;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}

	public String getNum_contrat() {
		return num_contrat;
	}

	public void setNum_contrat(String num_contrat) {
		this.num_contrat = num_contrat;
	}

	public String getPrenom() {
		return prenom;
	}

	public void setPrenom(String prenom) {
		this.prenom = prenom;
	}

	public String getSiren() {
		return siren;
	}

	public void setSiren(String siren) {
		this.siren = siren;
	}

	public String getIdent() {
		return ident;
	}

	public void setIdent(String ident) {
		this.ident = ident;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

}
