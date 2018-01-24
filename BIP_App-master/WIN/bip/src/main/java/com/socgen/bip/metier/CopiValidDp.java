package com.socgen.bip.metier;

public class CopiValidDp {
	
	private String annee;
	
	private String metier;
	
	private String date_copi;
	
	private String jh_couttotal;
	
	private String jh_arbdemandes;
	
	private String jh_arbdecides;
	
	private String jh_cantdemandes;
	
	private String jh_cantdecides;
	
	private String type_demande;
	
	private String four_copi;

	public CopiValidDp() {
		super();
		// TODO Auto-generated constructor stub
	}

	public CopiValidDp(String annee, String metier, String date_copi, String jh_couttotal, String jh_arbdemandes, String jh_arbdecides, String jh_cantdemandes, String jh_cantdecides, String type_demande, String four_copi) {
		super();
				this.annee = annee;
		this.metier = metier;
		this.date_copi = date_copi;
		this.jh_couttotal = jh_couttotal;
		this.jh_arbdemandes = jh_arbdemandes;
		this.jh_arbdecides = jh_arbdecides;
		this.jh_cantdemandes = jh_cantdemandes;
		this.jh_cantdecides = jh_cantdecides;
		this.type_demande = type_demande;
		this.four_copi = four_copi;
	}

	public String getAnnee() {
		return annee;
	}

	public void setAnnee(String annee) {
		this.annee = annee;
	}

	public String getDate_copi() {
		return date_copi;
	}

	public void setDate_copi(String date_copi) {
		this.date_copi = date_copi;
	}

	public String getFour_copi() {
		return four_copi;
	}

	public void setFour_copi(String four_copi) {
		this.four_copi = four_copi;
	}

	public String getJh_arbdecides() {
		return jh_arbdecides;
	}

	public void setJh_arbdecides(String jh_arbdecides) {
		this.jh_arbdecides = jh_arbdecides;
	}

	public String getJh_arbdemandes() {
		return jh_arbdemandes;
	}

	public void setJh_arbdemandes(String jh_arbdemandes) {
		this.jh_arbdemandes = jh_arbdemandes;
	}

	public String getJh_cantdecides() {
		return jh_cantdecides;
	}

	public void setJh_cantdecides(String jh_cantdecides) {
		this.jh_cantdecides = jh_cantdecides;
	}

	public String getJh_cantdemandes() {
		return jh_cantdemandes;
	}

	public void setJh_cantdemandes(String jh_cantdemandes) {
		this.jh_cantdemandes = jh_cantdemandes;
	}

	public String getJh_couttotal() {
		return jh_couttotal;
	}

	public void setJh_couttotal(String jh_couttotal) {
		this.jh_couttotal = jh_couttotal;
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
	
	

}
