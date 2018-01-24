package com.socgen.bip.metier;

public class ConsultLogsBip {
	
	private String nom_batch;
	
	private String datedeb;
	
	private String heure_deb;
	
	private String datefin;
	
	private String heure_fin;
	
	private String libelleora;
	
	private int ecrit;
	
	private int lu;
	
	private String statut;

	public ConsultLogsBip(String nom_batch, String datedeb, String heure_deb, String datefin, String heure_fin, String libelleora, int ecrit, int lu, String statut) {
		super();
		this.nom_batch = nom_batch;
		this.datedeb = datedeb;
		this.heure_deb = heure_deb;
		this.datefin = datefin;
		this.heure_fin = heure_fin;
		this.libelleora = libelleora;
		this.ecrit = ecrit;
		this.lu = lu;
		this.statut = statut;
	}

	public ConsultLogsBip() {
		super();
		// TODO Raccord de constructeur auto-généré
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

	public int getEcrit() {
		return ecrit;
	}

	public void setEcrit(int ecrit) {
		this.ecrit = ecrit;
	}

	public String getHeure_deb() {
		return heure_deb;
	}

	public void setHeure_deb(String heure_deb) {
		this.heure_deb = heure_deb;
	}

	public String getHeure_fin() {
		return heure_fin;
	}

	public void setHeure_fin(String heure_fin) {
		this.heure_fin = heure_fin;
	}

	public String getLibelleora() {
		return libelleora;
	}

	public void setLibelleora(String libelleora) {
		this.libelleora = libelleora;
	}

	public int getLu() {
		return lu;
	}

	public void setLu(int lu) {
		this.lu = lu;
	}

	public String getNom_batch() {
		return nom_batch;
	}

	public void setNom_batch(String nom_batch) {
		this.nom_batch = nom_batch;
	}

	public String getStatut() {
		return statut;
	}

	public void setStatut(String statut) {
		this.statut = statut;
	}

	
	

}
