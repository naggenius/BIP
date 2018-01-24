package com.socgen.bip.form;



import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author JMA - 06/06/2006
 *
 * Formulaire pour la liste des messages dans le forum
 * pages : lForumListe.jsp
 */

public class ListeMsgForumForm extends AutomateForm {

	private int id;
	private String parent_id;
	private int nb_message = 0;
	private String tri = "";
	private String statut = "";
	private String motif = "";
	private String typeEcran = "";
	private String chaineRecherche = "";
	
	// propriété pour la recherche avancée
	private String mot_cle = "";
	private String auteur_rech = "";
	private String date_debut = "";
	private String date_fin = "";
	private String menu = "";
	private String chercheTitre = "";
	private String chercheTexte = "";

	/*Le nombre de lignes par page 
	*/
	private String blocksize ;
	
	/*position blocksize 
	*/
	private String position_blocksize;

	private String listeMenu = "";

	public ListeMsgForumForm() {
		super();
	}

	/**
	 * @return
	 */
	public String getParent_id() {
		return parent_id;
	}

	/**
	 * @return
	 */
	public int getNb_message() {
		return nb_message;
	}

	/**
	 * @return
	 */
	public String getTri() {
		return tri;
	}

	/**
	 * @param i
	 */
	public void setParent_id(String i) {
		parent_id = i;
	}

	/**
	 * @param i
	 */
	public void setNb_message(int i) {
		nb_message = i;
	}

	/**
	 * @param string
	 */
	public void setTri(String string) {
		tri = string;
	}

	/**
	 * @return
	 */
	public String getBlocksize() {
		return blocksize;
	}

	/**
	 * @return
	 */
	public String getPosition_blocksize() {
		return position_blocksize;
	}

	/**
	 * @param string
	 */
	public void setBlocksize(String string) {
		blocksize = string;
	}

	/**
	 * @param string
	 */
	public void setPosition_blocksize(String string) {
		position_blocksize = string;
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
	public int getId() {
		return id;
	}

	/**
	 * @param i
	 */
	public void setId(int i) {
		id = i;
	}

	/**
	 * @return
	 */
	public String getStatut() {
		return statut;
	}

	/**
	 * @param string
	 */
	public void setStatut(String string) {
		statut = string;
	}

	/**
	 * @return
	 */
	public String getMotif() {
		return motif;
	}

	/**
	 * @param string
	 */
	public void setMotif(String string) {
		motif = string;
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
	public void setTypeEcran(String string) {
		typeEcran = string;
	}

	/**
	 * @return
	 */
	public String getChaineRecherche() {
		return chaineRecherche;
	}

	/**
	 * @param string
	 */
	public void setChaineRecherche(String string) {
		chaineRecherche = string;
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
	public String getMenu() {
		return menu;
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
	public void setMenu(String string) {
		menu = string;
	}

	/**
	 * @param string
	 */
	public void setMot_cle(String string) {
		mot_cle = string;
	}

}