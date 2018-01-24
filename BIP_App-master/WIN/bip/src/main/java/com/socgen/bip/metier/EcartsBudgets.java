package com.socgen.bip.metier;
/**
 * @author DDI - 24/03/2006
 *
 * représente un écart
 * chemin : Budget JH / Ecarts Budgétaires
 * pages  : bEcartsBudgetsAd.jsp 
 * pl/sql : pack_budget_ecart.sql
 */
public class EcartsBudgets {

	/* Le dpg */
	private String codsg;
	/*L'année du budget yyyy*/
	private String annee;
	/*Identifiant de la ligne bip */
	private String pid;
	/*Le nom de la la ligne BIP	*/
	private String pnom;
	/*Budget reestime */
	private String reestime;
	/*Budget Arbitré */
	private String anmont;
	/*Budget proposé ME*/
	private String bpmontme;
	/*Budget notifié */
	private String bnmont;	
	/*Budget consommé */
	private String cusag;
	/*Type décart */
	private String type;
	/*Type de validation de l'écart N ou O */
	private String valide;
	/*Le commentaire de l'écart */
	private String commentaire;

	
	/**
	 * Constructor for EcartsBudgets.
	 */
	public EcartsBudgets() {
		super();
	}
    
	public EcartsBudgets(String codsg, String annee, String pid, String pnom, String reestime, String anmont,
	 			 String bpmontme, String bnmont, String cusag, String type,
	 			 String valide, String commentaire 
			     ) {
		super();
		
		this.codsg = codsg;
		this.annee = annee;
		this.pid = pid;
		this.pnom = pnom;
		this.reestime = reestime;
		this.anmont = anmont;
		this.bpmontme = bpmontme;
		this.bnmont = bnmont;
		this.cusag = cusag;
		this.type = type;
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
	 * Returns the annee.
	 * @return String
	 */
	public String getAnnee() {
		return annee;
	}

	/**
	 * Returns the pid.
	 * @return String
	 */
	public String getPid() {
		return pid;
	}

	/**
	 * Returns the pnom.
	 * @return String
	 */
	public String getPnom() {
		return pnom;
	}

	/**
	 * Returns the reestime.
	 * @return String
	 */
	public String getReestime() {
		return reestime;
	}

	/**
	 * Returns the anmont.
	 * @return String
	 */
	public String getAnmont() {
		return anmont;
	}

	/**
	 * Returns the bpmontme.
	 * @return String
	 */
	public String getBpmontme() {
		return bpmontme;
	}

	/**
	 * Returns the bnmont.
	 * @return String
	 */
	public String getBnmont() {
		return bnmont;
	}

	/**
	 * Returns the cusag.
	 * @return String
	 */
	public String getCusag() {
		return cusag;
	}

	/**
	 * Returns the type.
	 * @return String
	 */
	public String getType() {
		return type;
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
	 * Sets the annee.
	 * @param annee The annee to set
	 */
	public void setAnnee(String annee) {
		this.annee = annee;
	}

	/**
	 * Sets the pid.
	 * @param pid The pid to set
	 */
	public void setPid(String pid) {
		this.pid = pid;
	}

	/**
	 * Sets the pnom.
	 * @param pnom The pnom to set
	 */
	public void setPnom(String pnom) {
		this.pnom = pnom;
	}

	/**
	 * Sets the datsitu.
	 * @param datsitu The datsitu to set
	 */
	public void setReestime(String reestime) {
		this.reestime = reestime;
	}

	/**
	 * Sets the anmont.
	 * @param anmont The anmont to set
	 */
	public void setAnmont(String anmont) {
		this.anmont = anmont;
	}

	/**
	 * Sets the bpmontme.
	 * @param bpmontme The bpmontme to set
	 */
	public void setBpmontme(String bpmontme) {
		this.bpmontme = bpmontme;
	}

	/**
	 * Sets the bnmont.
	 * @param bnmont The bnmont to set
	 */
	public void setBnmont(String bnmont) {
		this.bnmont = bnmont;
	}

	/**
	 * Sets the cusag.
	 * @param cusag The cusag to set
	 */
	public void setCusag(String cusag) {
		this.cusag = cusag;
	}

	/**
	 * Sets the type.
	 * @param type The type to set
	 */
	public void setType(String type) {
		this.type = type;
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
