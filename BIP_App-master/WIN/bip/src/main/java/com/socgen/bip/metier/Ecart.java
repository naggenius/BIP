package com.socgen.bip.metier;


/**
 * @author BAA - 05/08/2005
 *
 * représente un écart
 * chemin : Ressource Ecarts
 * pages  : bEcartsAd.jsp et fEcartsAd.jsp
 * pl/sql : pack_ressource_ecart.sql
 */
public class Ecart {
					
	

	/*Le dpg
	*/
	private String codsg;
	/*Le mois de l'écart format (mm/yyyy)
	*/
	private String cdeb;
	/*Identifiant de la ressource
	*/
	private String ident;
	/*Le nom de la ressource
	*/
	private String nom;
	/*La String du debut la situation
	*/
	private String datsitu;
	/*La String de départ
	*/
	private String datdep;
	/*Type d'écart
	*/
	private String type;
	/*Nombre de jours dans la bip
	*/
	private String nbjbip;
	/*Nombre de jours de gershwin
	*/
	private String nbjgersh;
	/*Nombre de jour dans le mois
	*/
	private String nbjmois;
	/*Type de validation de l'écart N ou O
	*/
	private String valide;
	/*Le commentaire de l'écart
	*/
	private String commentaire;

	
	/**
	 * Constructor for Ecart.
	 */
	public Ecart() {
		super();
	}
    
	public Ecart(String codsg, String cdeb, String ident, String nom, String datsitu, String datdep,
	 			 String type, String nbjbip, String nbjgersh, String nbjmois,
	 			 String valide, String commentaire 
			     ) {
		super();
		
		this.codsg = codsg;
		this.cdeb = cdeb;
		this.ident = ident;
		this.nom = nom;
		this.datsitu = datsitu;
		this.datdep = datdep;
		this.type = type;
		this.nbjbip = nbjbip;
		this.nbjgersh = nbjgersh;
		this.nbjmois = nbjmois;
		this.valide = valide;
		this.commentaire = commentaire;
			
	}

	

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * Returns the cdeb.
	 * @return String
	 */
	public String getCdeb() {
		return cdeb;
	}

	/**
	 * Returns the ident.
	 * @return String
	 */
	public String getIdent() {
		return ident;
	}

	/**
	 * Returns the nom.
	 * @return String
	 */
	public String getNom() {
		return nom;
	}

	/**
	 * Returns the datsitu.
	 * @return String
	 */
	public String getDatsitu() {
		return datsitu;
	}

	/**
	 * Returns the datdep.
	 * @return String
	 */
	public String getDatdep() {
		return datdep;
	}

	/**
	 * Returns the type.
	 * @return String
	 */
	public String getType() {
		return type;
	}

	/**
	 * Returns the nbjbip.
	 * @return String
	 */
	public String getNbjbip() {
		return nbjbip;
	}

	/**
	 * Returns the nbjgersh.
	 * @return String
	 */
	public String getNbjgersh() {
		return nbjgersh;
	}

	/**
	 * Returns the nbjmois.
	 * @return String
	 */
	public String getNbjmois() {
		return nbjmois;
	}

	/**
	 * Returns the valide.
	 * @return String
	 */
	public String getValide() {
		return valide;
	}

	/**
		 * Returns the commentaire.
		 * @return String
		 */
		public String getCommentaire() {
			return commentaire;
		}
		
	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Sets the cdeb.
	 * @param cdeb The cdeb to set
	 */
	public void setCdeb(String cdeb) {
		this.cdeb = cdeb;
	}

	/**
	 * Sets the ident.
	 * @param ident The ident to set
	 */
	public void setIdent(String ident) {
		this.ident = ident;
	}

	/**
	 * Sets the nom.
	 * @param nom The nom to set
	 */
	public void setNom(String nom) {
		this.nom = nom;
	}

	/**
	 * Sets the datsitu.
	 * @param datsitu The datsitu to set
	 */
	public void setDatsitu(String datsitu) {
		this.datsitu = datsitu;
	}

	/**
	 * Sets the datdep.
	 * @param datdep The datdep to set
	 */
	public void setDatdep(String datdep) {
		this.datdep = datdep;
	}

	/**
	 * Sets the type.
	 * @param type The type to set
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * Sets the nbjbip.
	 * @param nbjbip The nbjbip to set
	 */
	public void setNbjbip(String nbjbip) {
		this.nbjbip = nbjbip;
	}

	/**
	 * Sets the nbjgersh.
	 * @param nbjgersh The nbjgersh to set
	 */
	public void setNbjgersh(String nbjgersh) {
		this.nbjgersh = nbjgersh;
	}

	/**
	 * Sets the nbjmois.
	 * @param nbjmois The nbjmois to set
	 */
	public void setNbjmois(String nbjmois) {
		this.nbjmois = nbjmois;
	}

	/**
	 * Sets the valide.
	 * @param valide The valide to set
	 */
	public void setValide(String valide) {
		this.valide = valide;
	}

	/**
	 * Sets the commentaire.
	 * @param commentaire The commentaire to set
	 */
	public void setCommentaire(String commentaire) {
		this.commentaire = commentaire;
	}




}
