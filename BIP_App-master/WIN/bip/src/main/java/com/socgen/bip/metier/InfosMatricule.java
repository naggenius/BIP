package com.socgen.bip.metier;

/**
 * @author JAL le 25/04/2005
 *
 */
public class InfosMatricule {
	
	private String matricule;
	private String nomPrenom ; 
	private String nom ; 
	private String prenom ; 
	private String lienHref;
	
	

	/**
	 * 
	 */
	public InfosMatricule() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosMatricule(String pmatricule,String pnomPrenom, String lienHrefCHoix) {
		this.matricule =pmatricule;
		this.nomPrenom = pnomPrenom ; 
		this.lienHref = lienHrefCHoix;
	}
	
	
	
	/**
	 * 
	 */
	public InfosMatricule(String pmatricule,String pNom, String pPrenom,String pNomPrenom , String lienHrefCHoix) {
		this.matricule =pmatricule;
		this.nomPrenom = pNomPrenom ; 
		this.nom = pNom ; 
		this.prenom = pPrenom ; 
		this.lienHref = lienHrefCHoix;
	}
	




	/**
	 * @return
	 */
	public String getLienHref() {
		return lienHref;
	}




	/**
	 * @param string
	 */
	public void setLienHref(String string) {
		lienHref = string;
	}

	/**
	 * 
	 * @return
	 */
	public String getMatricule() {
		return matricule;
	}

	/**
	 * 
	 * @param matricule
	 */
	public void setMatricule(String matricule) {
		this.matricule = matricule;
	}

	/**
	 * 
	 * @return
	 */
	public String getNomPrenom() {
		return nomPrenom;
	}

	/**
	 * 
	 * @param nomPrenom
	 */
	public void setNomPrenom(String nomPrenom) {
		this.nomPrenom = nomPrenom;
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
	

}
