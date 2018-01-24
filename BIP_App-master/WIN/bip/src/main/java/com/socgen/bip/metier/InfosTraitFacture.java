package com.socgen.bip.metier;

/**
 * @author BAA le 29/03/2003
 *
 */
public class InfosTraitFacture {
	
	private String nomFichier;
	private String numfacture;
	private String dateChargement;
	private String utilisateur;
	private String nbreFactInteg;
	private String nbreFactRejet;
	private String nbreEnreg;

	

	/**
	 * 
	 */
	public InfosTraitFacture() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosTraitFacture(String numfacture, String nomFichier,String dateChargement, String utilisateur, String nbreFactInteg, String nbreFactRejet, String nbreEnreg) {
		this.numfacture=numfacture;
		this.nomFichier=nomFichier;
		this.dateChargement=dateChargement;
		this.utilisateur=utilisateur;
		this.nbreFactInteg=nbreFactInteg;
		this.nbreFactRejet=nbreFactRejet;
		this.nbreEnreg=nbreEnreg;
	}

	public String getNomFichier() {
		return nomFichier;
	}

	public void setNomFichier(String nomFichier) {
		this.nomFichier = nomFichier;
	}

	public String getDateChargement() {
		return dateChargement;
	}

	public void setDateChargement(String dateChargement) {
		this.dateChargement = dateChargement;
	}

	public String getNbreFactInteg() {
		return nbreFactInteg;
	}

	public void setNbreFactInteg(String nbreFactInteg) {
		this.nbreFactInteg = nbreFactInteg;
	}

	public String getNbreFactRejet() {
		return nbreFactRejet;
	}

	public void setNbreFactRejet(String nbreFactRejet) {
		this.nbreFactRejet = nbreFactRejet;
	}

	public String getNumfacture() {
		return numfacture;
	}

	public void setNumfacture(String numfacture) {
		this.numfacture = numfacture;
	}

	public String getUtilisateur() {
		return utilisateur;
	}

	public void setUtilisateur(String utilisateur) {
		this.utilisateur = utilisateur;
	}

	public String getNbreEnreg() {
		return nbreEnreg;
	}

	public void setNbreEnreg(String nbreEnreg) {
		this.nbreEnreg = nbreEnreg;
	}
	
	
	
	
}
