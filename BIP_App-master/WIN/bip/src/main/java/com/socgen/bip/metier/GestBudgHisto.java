package com.socgen.bip.metier;

/**
 * Classe métier représentant un historique H d’arbitré ou de réestimé d’un budget
 * @author X119481
 *
 */
public class GestBudgHisto {
	/**
	 * Valeur
	 */
	private String valeur;
	/**
	 * Date de modification
	 */	
	private String dateModif;
	/**
	 * Identifiant utilisé pour la modification : matricule
	 */
	private String matricule;
	/**
	 * Commentaire associé
	 */
	private String commentaire;
	public String getCommentaire() {
		return commentaire;
	}
	public void setCommentaire(String commentaire) {
		this.commentaire = commentaire;
	}
	public String getDateModif() {
		return dateModif;
	}
	public void setDateModif(String dateModif) {
		this.dateModif = dateModif;
	}
	public String getMatricule() {
		return matricule;
	}
	public void setMatricule(String matricule) {
		this.matricule = matricule;
	}
	public String getValeur() {
		return valeur;
	}
	public void setValeur(String valeur) {
		this.valeur = valeur;
	}

}
