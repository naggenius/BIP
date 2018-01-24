package com.socgen.bip.metier;

/**
 * @author J. MAS 06/06/2006
 *
 * Objet métier pour les message du forum
 */
public class MessageForum {

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
	private String user_rtfe = "";
	private int tab = 0;
	
	public MessageForum() {
	}

	public MessageForum(
		 int p_id,
		 int p_parent_id,
		 String p_auteur,
		 String p_menu,
		 String p_date_msg,
		 String p_titre,
		 String p_type_msg,
		 String p_statut,
		 String p_date_statut,
		 String p_msg_important,
		 String p_texte,
		 String p_texte_modifie,
		 String p_motif_rejet,
		 String p_date_affichage,
		 String p_date_modification,
		 int    p_nbReponse,
		 String p_datedernmsg,
         String p_user_rtfe ) {
			this.id                = p_id;                 
			this.parent_id         = p_parent_id;          
			this.auteur            = p_auteur;             
			this.menu              = p_menu;               
			this.date_msg          = p_date_msg;           
			this.titre             = p_titre;              
			this.type_msg          = p_type_msg;           
			this.statut            = p_statut;             
			this.date_statut       = p_date_statut;        
			this.texte             = p_texte;              
			this.texte_modifie     = p_texte_modifie;      
			this.motif_rejet       = p_motif_rejet;        
			this.date_affichage    = p_date_affichage;     
			this.date_modification = p_date_modification;  
			this.msg_important     = p_msg_important;
			this.nbReponse         = p_nbReponse;
			this.dateDernReponse   = p_datedernmsg;
			this.user_rtfe		   = p_user_rtfe;      
	}


	public MessageForum(
		 int p_id,
		 int p_parent_id,
		 String p_auteur,
		 String p_menu,
		 String p_date_msg,
		 String p_titre,
		 String p_type_msg,
		 String p_statut,
		 String p_date_statut,
		 String p_msg_important,
		 String p_texte,
		 String p_texte_modifie,
		 String p_motif_rejet,
		 String p_date_affichage,
		 String p_date_modification,
		 int    p_nbReponse,
		 String p_datedernmsg ) {
			this.id                = p_id;                 
			this.parent_id         = p_parent_id;          
			this.auteur            = p_auteur;             
			this.menu              = p_menu;               
			this.date_msg          = p_date_msg;           
			this.titre             = p_titre;              
			this.type_msg          = p_type_msg;           
			this.statut            = p_statut;             
			this.date_statut       = p_date_statut;        
			this.texte             = p_texte;              
			this.texte_modifie     = p_texte_modifie;      
			this.motif_rejet       = p_motif_rejet;        
			this.date_affichage    = p_date_affichage;     
			this.date_modification = p_date_modification;  
			this.msg_important     = p_msg_important;
			this.nbReponse         = p_nbReponse;
			this.dateDernReponse   = p_datedernmsg;
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
	public String getDateDernReponse() {
		return dateDernReponse;
	}

	/**
	 * @return
	 */
	public int getNbReponse() {
		return nbReponse;
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
	public void setNbReponse(int i) {
		nbReponse = i;
	}

	/**
	 * @return
	 */
	public String getUser_rtfe() {
		return user_rtfe;
	}

	/**
	 * @param string
	 */
	public void setUser_rtfe(String string) {
		user_rtfe = string;
	}

	/**
	 * @return
	 */
	public int getTab() {
		return tab;
	}

	/**
	 * @param i
	 */
	public void setTab(int i) {
		tab = i;
	}

}
