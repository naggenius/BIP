package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author JMA - 06/06/2006
 *
 * Formulaire pour la liste des messages dans le forum
 * pages : lForumListe.jsp
 */

public class MessageForumForm extends AutomateForm {

	private int id = 0;
	private int parent_id = 0;
	private String auteur = "";
	private String menu = "";
	private String date_msg = "";
	private String titre = "";
	private String type_msg = "";
	private String statut = "";
	private String date_statut = "";
	private String texte = "";
	private String texte_modifie = "";
	private String motif_rejet = "";
	private String date_affichage = "";
	private String date_modification = "";
	private String msg_important = "";
	private int nbReponse = 0;
	private String dateDernReponse = "";
	private String listeMenu = "";
	private String typeEcran = "";
	private String chaineRecherche = "";

	// propriété pour la recherche avancée
	private String mot_cle = "";
	private String auteur_rech = "";
	private String date_debut = "";
	private String date_fin = "";
	private String chercheTitre = "";
	private String chercheTexte = "";

	public MessageForumForm() {
		super();
	}


	/**
	 * @return
	 */
	public String getAuteur() {
		return auteur;
	}

	/**
	 * @return
	 */
	public String getDate_affichage() {
		return date_affichage;
	}

	/**
	 * @return
	 */
	public String getDate_modification() {
		return date_modification;
	}

	/**
	 * @return
	 */
	public String getDate_msg() {
		return date_msg;
	}

	/**
	 * @return
	 */
	public String getDate_statut() {
		return date_statut;
	}

	/**
	 * @return
	 */
	public String getDateDernReponse() {
		return dateDernReponse;
	}

	/**
	 * @return
	 */
	public int getId() {
		return id;
	}

	/**
	 * @return
	 */
	public String getMenu() {
		return menu;
	}

	/**
	 * @return
	 */
	public String getMotif_rejet() {
		return motif_rejet;
	}

	/**
	 * @return
	 */
	public String getMsg_important() {
		return msg_important;
	}

	/**
	 * @return
	 */
	public int getNbReponse() {
		return nbReponse;
	}

	/**
	 * @return
	 */
	public int getParent_id() {
		return parent_id;
	}

	/**
	 * @return
	 */
	public String getStatut() {
		return statut;
	}

	/**
	 * @return
	 */
	public String getTexte() {
		return texte;
	}

	/**
	 * @return
	 */
	public String getTexte_modifie() {
		return texte_modifie;
	}

	/**
	 * @return
	 */
	public String getTitre() {
		return titre;
	}

	/**
	 * @return
	 */
	public String getType_msg() {
		return type_msg;
	}

	/**
	 * @param string
	 */
	public void setAuteur(String string) {
		auteur = string;
	}

	/**
	 * @param string
	 */
	public void setDate_affichage(String string) {
		date_affichage = string;
	}

	/**
	 * @param string
	 */
	public void setDate_modification(String string) {
		date_modification = string;
	}

	/**
	 * @param string
	 */
	public void setDate_msg(String string) {
		date_msg = string;
	}

	/**
	 * @param string
	 */
	public void setDate_statut(String string) {
		date_statut = string;
	}

	/**
	 * @param string
	 */
	public void setDateDernReponse(String string) {
		dateDernReponse = string;
	}

	/**
	 * @param i
	 */
	public void setId(int i) {
		id = i;
	}

	/**
	 * @param string
	 */
	public void setMenu(String string) {
		menu = string;
	}

	/**
	 * @param string
	 */
	public void setMotif_rejet(String string) {
		motif_rejet = string;
	}

	/**
	 * @param string
	 */
	public void setMsg_important(String string) {
		msg_important = string;
	}

	/**
	 * @param i
	 */
	public void setNbReponse(int i) {
		nbReponse = i;
	}

	/**
	 * @param i
	 */
	public void setParent_id(int i) {
		parent_id = i;
	}

	/**
	 * @param string
	 */
	public void setStatut(String string) {
		statut = string;
	}

	/**
	 * @param string
	 */
	public void setTexte(String string) {
		texte = string;
	}

	/**
	 * @param string
	 */
	public void setTexte_modifie(String string) {
		texte_modifie = string;
	}

	/**
	 * @param string
	 */
	public void setTitre(String string) {
		titre = string;
	}

	/**
	 * @param string
	 */
	public void setType_msg(String string) {
		type_msg = string;
	}

	/**
	 * @return
	 */
	public String getListeMenu() {
		return listeMenu;
	}

	/**
	 * @param string
	 */
	public void setListeMenu(String string) {
		listeMenu = string;
	}

	/**
	 * @return
	 */
	public String getChaineRecherche() {
		return chaineRecherche;
	}

	/**
	 * @return
	 */
	public String getTypeEcran() {
		return typeEcran;
	}

	/**
	 * @param string
	 */
	public void setChaineRecherche(String string) {
		chaineRecherche = string;
	}

	/**
	 * @param string
	 */
	public void setTypeEcran(String string) {
		typeEcran = string;
	}

	/**
	 * @return
	 */
	public String getAuteur_rech() {
		return auteur_rech;
	}

	/**
	 * @return
	 */
	public String getChercheTexte() {
		return chercheTexte;
	}

	/**
	 * @return
	 */
	public String getChercheTitre() {
		return chercheTitre;
	}

	/**
	 * @return
	 */
	public String getDate_debut() {
		return date_debut;
	}

	/**
	 * @return
	 */
	public String getDate_fin() {
		return date_fin;
	}

	/**
	 * @return
	 */
	public String getMot_cle() {
		return mot_cle;
	}

	/**
	 * @param string
	 */
	public void setAuteur_rech(String string) {
		auteur_rech = string;
	}

	/**
	 * @param string
	 */
	public void setChercheTexte(String string) {
		chercheTexte = string;
	}

	/**
	 * @param string
	 */
	public void setChercheTitre(String string) {
		chercheTitre = string;
	}

	/**
	 * @param string
	 */
	public void setDate_debut(String string) {
		date_debut = string;
	}

	/**
	 * @param string
	 */
	public void setDate_fin(String string) {
		date_fin = string;
	}

	/**
	 * @param string
	 */
	public void setMot_cle(String string) {
		mot_cle = string;
	}

}