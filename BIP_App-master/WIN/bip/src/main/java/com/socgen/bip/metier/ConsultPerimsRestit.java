package com.socgen.bip.metier;

public class ConsultPerimsRestit {
	
	private String matricule;
	
	private String nom;
	
	private String prenom;
	
	private String extraction;
		
	private String date;
	
	private String ident;
	
	private String nom_rdf;
	
	private String jobid;
	
	private String menutil;
	
	private String perim_me;
	
	private String perim_mo;
	
	private String perim_mcli;
	
	private String doss_proj; 
	
	private String projet; 
	
	private String appli; 
	
	private String ca_fi; 
	
	private String ca_payeur; 
	
	private String ca_da;
	
	private String filtres;
	
	
	
	public ConsultPerimsRestit(String matricule, String nom, String prenom, String extraction, String date, String ident, String nom_rdf, String jobid, String menutil, String perim_me, String perim_mo, String perim_mcli, String doss_proj, String projet, String appli, String ca_fi, String ca_payeur, String ca_da, String filtres) {
		super();
		this.matricule = matricule;
		this.nom = nom;
		this.prenom = prenom;
		this.extraction = extraction;
		this.date = date;
		this.ident = ident;
		this.nom_rdf = nom_rdf;
		this.jobid = jobid;
		this.menutil = menutil;
		this.perim_me = perim_me;
		this.perim_mo = perim_mo;
		this.perim_mcli = perim_mcli;
		this.doss_proj = doss_proj;
		this.projet = projet;
		this.appli = appli;
		this.ca_fi = ca_fi;
		this.ca_payeur = ca_payeur;
		this.ca_da = ca_da;
		this.filtres = filtres;
	}

	public ConsultPerimsRestit() {
		super();
		// TODO Raccord de constructeur auto-généré
	}

	/**
	 * @return the appli
	 */
	public String getAppli() {
		return appli;
	}

	/**
	 * @param appli the appli to set
	 */
	public void setAppli(String appli) {
		this.appli = appli;
	}

	/**
	 * @return the ca_da
	 */
	public String getCa_da() {
		return ca_da;
	}

	/**
	 * @param ca_da the ca_da to set
	 */
	public void setCa_da(String ca_da) {
		this.ca_da = ca_da;
	}

	/**
	 * @return the ca_fi
	 */
	public String getCa_fi() {
		return ca_fi;
	}

	/**
	 * @param ca_fi the ca_fi to set
	 */
	public void setCa_fi(String ca_fi) {
		this.ca_fi = ca_fi;
	}

	/**
	 * @return the ca_payeur
	 */
	public String getCa_payeur() {
		return ca_payeur;
	}

	/**
	 * @param ca_payeur the ca_payeur to set
	 */
	public void setCa_payeur(String ca_payeur) {
		this.ca_payeur = ca_payeur;
	}

	/**
	 * @return the date
	 */
	public String getDate() {
		return date;
	}

	/**
	 * @param date the date to set
	 */
	public void setDate(String date) {
		this.date = date;
	}

	/**
	 * @return the doss_proj
	 */
	public String getDoss_proj() {
		return doss_proj;
	}

	/**
	 * @param doss_proj the doss_proj to set
	 */
	public void setDoss_proj(String doss_proj) {
		this.doss_proj = doss_proj;
	}

	/**
	 * @return the extraction
	 */
	public String getExtraction() {
		return extraction;
	}

	/**
	 * @param extraction the extraction to set
	 */
	public void setExtraction(String extraction) {
		this.extraction = extraction;
	}

	/**
	 * @return the matricule
	 */
	public String getMatricule() {
		return matricule;
	}

	/**
	 * @param matricule the matricule to set
	 */
	public void setMatricule(String matricule) {
		this.matricule = matricule;
	}

	/**
	 * @return the nom
	 */
	public String getNom() {
		return nom;
	}

	/**
	 * @param nom the nom to set
	 */
	public void setNom(String nom) {
		this.nom = nom;
	}

	/**
	 * @return the prenom
	 */
	public String getPrenom() {
		return prenom;
	}

	/**
	 * @param prenom the prenom to set
	 */
	public void setPrenom(String prenom) {
		this.prenom = prenom;
	}

	/**
	 * @return the projet
	 */
	public String getProjet() {
		return projet;
	}

	/**
	 * @param projet the projet to set
	 */
	public void setProjet(String projet) {
		this.projet = projet;
	}

	public String getFiltres() {
		return filtres;
	}

	public void setFiltres(String filtres) {
		this.filtres = filtres;
	}

	public String getIdent() {
		return ident;
	}

	public void setIdent(String ident) {
		this.ident = ident;
	}

	public String getJobid() {
		return jobid;
	}

	public void setJobid(String jobid) {
		this.jobid = jobid;
	}

	public String getMenutil() {
		return menutil;
	}

	public void setMenutil(String menutil) {
		this.menutil = menutil;
	}

	public String getNom_rdf() {
		return nom_rdf;
	}

	public void setNom_rdf(String nom_rdf) {
		this.nom_rdf = nom_rdf;
	}

	public String getPerim_me() {
		return perim_me;
	}

	public void setPerim_me(String perim_me) {
		this.perim_me = perim_me;
	}

	public String getPerim_mo() {
		return perim_mo;
	}

	public void setPerim_mo(String perim_mo) {
		this.perim_mo = perim_mo;
	}

	public String getPerim_mcli() {
		return perim_mcli;
	}

	public void setPerim_mcli(String perim_mcli) {
		this.perim_mcli = perim_mcli;
	}


}
