/*
 * Created on 14 nov. 03
 * 
 */
package com.socgen.bip.metier;

/**
 * @author S.LALLIER - 15/07/2003
 *
 * represente une ligne de réalisation
 * chemin : Ligne Investissement/Saisie des réalisés
 * chemin : Supervision des Investissement/Saisie des réalisés
 * pages  : mLigneReaLb.jsp et bPropoMassAd.jsp
 * pl/sql : realise.sql
 */
public class Realise {

	/**
	 * numéro de la ligne de réalisation.
	 */
	private String codrea;
	/**
		 * numéro de la ligne d'investissement.
		 */
	private String codinv;
	private String typeCommande;
	private String numeroCommade;
	private String typeEngagement;
	private String marque;
	private String modele;
	private String matricule;
	private String dateSaisie;
	private String montantEngage;

	public Realise(
		String codrea,
		String codinv,
		String typeCommande,
		String numeroCommade,
		String typeEngagement,
		String marque,
		String modele,
		String matricule,
		String dateSaisie,
		String montantEngage) {
		this.codrea = codrea;
		this.codinv = codinv;
		this.typeCommande = typeCommande;
		this.numeroCommade = numeroCommade;
		this.typeEngagement = typeEngagement;
		this.marque = marque;
		this.modele = modele;
		this.matricule = matricule;
		this.dateSaisie = dateSaisie;
		this.montantEngage = montantEngage;
	}

	public String getCodinv() {
		return codinv;
	}

	public String getCodrea() {
		return codrea;
	}

	public String getDateSaisie() {
		return dateSaisie;
	}

	public String getMarque() {
		return marque;
	}

	public String getMatricule() {
		return matricule;
	}

	public String getModele() {
		return modele;
	}

	public String getMontantEngage() {
		return montantEngage;
	}

	public String getNumeroCommade() {
		return numeroCommade;
	}

	public String getTypeCommande() {
		return typeCommande;
	}

	public String getTypeEngagement() {
		return typeEngagement;
	}

	public void setCodinv(String string) {
		codinv = string;
	}

	public void setCodrea(String string) {
		codrea = string;
	}

	public void setDateSaisie(String string) {
		dateSaisie = string;
	}

	public void setMarque(String string) {
		marque = string;
	}

	public void setMatricule(String string) {
		matricule = string;
	}

	public void setModele(String string) {
		modele = string;
	}

	public void setMontantEngage(String string) {
		montantEngage = string;
	}

	public void setNumeroCommade(String string) {
		numeroCommade = string;
	}

	public void setTypeCommande(String string) {
		typeCommande = string;
	}

	public void setTypeEngagement(String string) {
		typeEngagement = string;
	}

}
