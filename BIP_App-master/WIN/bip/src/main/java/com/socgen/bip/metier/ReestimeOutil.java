package com.socgen.bip.metier;

import com.socgen.bip.form.SaisieReesForm;

/**
 * @author J. MAS - 31/05/2005
 *
 * représente un réestimé dans le menu Outil de Réestimé par Ressources
 * chemin : Outil de Réestimé par Ressources/Saisie Réestimé
 * pages  : bSaisieRe.jsp et fSaisieRe.jsp
 * pl/sql : isac_conso.sql
 */
public class ReestimeOutil extends SaisieReesForm {
					
 	/*Le consomme du mois de janvier
	*/
	private String rees_1;
	/*Le consomme du mois de février
	*/
	private String rees_2;
	/*Le consomme du mois de mars
	*/
	private String rees_3;
	/*Le consomme du mois de avril
	*/
	private String rees_4;
	/*Le consomme du mois de mai
	*/
	private String rees_5;
	/*Le consomme du mois de juin
	*/
	private String rees_6;
	/*Le consomme du mois de juillet
	*/
	private String rees_7;
	/*Le consomme du mois de aout
	*/
	private String rees_8;
	/*Le consomme du mois de septembre
	*/
	private String rees_9;
	/*Le consomme du mois de octobre
	*/
	private String rees_10;
	/*Le consomme du mois de novembre
	*/
	private String rees_11;
	/*Le consomme du mois de décembre
	*/
	private String rees_12;

	/*Le total de la ligne de consommé
	*/
	private String total_cons;
	
	/*Le total de la ligne de réestimé
	*/
	private String total_rees;
	
	/*Le total du mois de janvier
	*/
	private String tot_mois_1;
	/*Le total du mois de février
	*/
	private String tot_mois_2;
	/*Le total du mois de mars
	*/
	private String tot_mois_3;
	/*Le total du mois de avril
	*/
	private String tot_mois_4;
	/*Le total du mois de mai
	*/
	private String tot_mois_5;
	/*Le total du mois de juin
	*/
	private String tot_mois_6;
	/*Le total du mois de juillet
	*/
	private String tot_mois_7;
	/*Le total du mois de aout
	*/
	private String tot_mois_8;
	/*Le total du mois de septembre
	*/
	private String tot_mois_9;
	/*Le total du mois de octobre
	*/
	private String tot_mois_10;
	/*Le total du mois de novembre
	*/
	private String tot_mois_11;
	/*Le total du mois de décembre
	*/
	private String tot_mois_12;
	
	/*L'identifiant :a.pid||e.ecet||t.acta||st.acst
	*/
	private String identifiant;
	
	/* Nom de la ressource */
	private String nom_ress;
	
	/*Pour determiner si le champ est modifiable ou pas*/
	private String fermee;

	/**
	 * Constructor for ReestimeOutil.
	 */
	public ReestimeOutil() {
		super();
	}
    
	public ReestimeOutil(String code_activite, String rees_1, String rees_2, String rees_3, String rees_4, String rees_5, String rees_6,
					 String rees_7, String rees_8, String rees_9, String rees_10, String rees_11, String rees_12, 
					 String total_cons, String total_rees, String tot_mois_1, String tot_mois_2, String tot_mois_3, 
					 String tot_mois_4, String tot_mois_5, String tot_mois_6,	String tot_mois_7, 
					 String tot_mois_8, String tot_mois_9, String tot_mois_10, String tot_mois_11, 
					 String tot_mois_12) {
		super();
		setCode_activite( code_activite);
		this.rees_1 = rees_1;
		this.rees_2 = rees_2;
		this.rees_3 = rees_3;
		this.rees_4 = rees_4;
		this.rees_5 = rees_5;
		this.rees_6 = rees_6;
		this.rees_7 = rees_7;
		this.rees_8 = rees_8;
		this.rees_9 = rees_9;
		this.rees_10 = rees_10;
		this.rees_11 = rees_11;
		this.rees_12 = rees_12;
		this.total_cons = total_cons;
		this.total_rees = total_rees;
		this.tot_mois_1 = tot_mois_1;
		this.tot_mois_2 = tot_mois_2;
		this.tot_mois_3 = tot_mois_3;
		this.tot_mois_4 = tot_mois_4;
		this.tot_mois_5 = tot_mois_5;
		this.tot_mois_6 = tot_mois_6;
		this.tot_mois_7 = tot_mois_7;
		this.tot_mois_8 = tot_mois_8;
		this.tot_mois_9 = tot_mois_9;
		this.tot_mois_10 = tot_mois_10;
		this.tot_mois_11 = tot_mois_11;
		this.tot_mois_12 = tot_mois_12;
	}

	

	/**
	 * Returns the rees_1.
	 * @return String
	 */
	public String getRees_1() {
		return rees_1;
	}

	/**
	 * Returns the rees_10.
	 * @return String
	 */
	public String getRees_10() {
		return rees_10;
	}

	/**
	 * Returns the rees_11.
	 * @return String
	 */
	public String getRees_11() {
		return rees_11;
	}

	/**
	 * Returns the rees_12.
	 * @return String
	 */
	public String getRees_12() {
		return rees_12;
	}

	/**
	 * Returns the rees_2.
	 * @return String
	 */
	public String getRees_2() {
		return rees_2;
	}

	/**
	 * Returns the rees_3.
	 * @return String
	 */
	public String getRees_3() {
		return rees_3;
	}

	/**
	 * Returns the rees_4.
	 * @return String
	 */
	public String getRees_4() {
		return rees_4;
	}

	/**
	 * Returns the rees_5.
	 * @return String
	 */
	public String getRees_5() {
		return rees_5;
	}

	/**
	 * Returns the rees_6.
	 * @return String
	 */
	public String getRees_6() {
		return rees_6;
	}

	/**
	 * Returns the rees_7.
	 * @return String
	 */
	public String getRees_7() {
		return rees_7;
	}

	/**
	 * Returns the rees_8.
	 * @return String
	 */
	public String getRees_8() {
		return rees_8;
	}

	/**
	 * Returns the rees_9.
	 * @return String
	 */
	public String getRees_9() {
		return rees_9;
	}

	/**
	 * Returns the identifiant.
	 * @return String
	 */
	public String getIdentifiant() {
		return identifiant;
	}

	/**
	 * Returns the total_cons.
	 * @return String
	 */
	public String getTotal_cons() {
		return total_cons;
	}

	/**
	 * Returns the fermee.
	 * @return String
	 */
	public String getFermee() {
		return fermee;
	}
	
	/**
	 * Sets the rees_1.
	 * @param rees_1 The rees_1 to set
	 */
	public void setRees_1(String rees_1) {
		this.rees_1 = rees_1;
	}

	/**
	 * Sets the rees_10.
	 * @param rees_10 The rees_10 to set
	 */
	public void setRees_10(String rees_10) {
		this.rees_10 = rees_10;
	}

	/**
	 * Sets the rees_11.
	 * @param rees_11 The rees_11 to set
	 */
	public void setRees_11(String rees_11) {
		this.rees_11 = rees_11;
	}

	/**
	 * Sets the rees_12.
	 * @param rees_12 The rees_12 to set
	 */
	public void setRees_12(String rees_12) {
		this.rees_12 = rees_12;
	}

	/**
	 * Sets the rees_2.
	 * @param rees_2 The rees_2 to set
	 */
	public void setRees_2(String rees_2) {
		this.rees_2 = rees_2;
	}

	/**
	 * Sets the rees_3.
	 * @param rees_3 The rees_3 to set
	 */
	public void setRees_3(String rees_3) {
		this.rees_3 = rees_3;
	}

	/**
	 * Sets the rees_4.
	 * @param rees_4 The rees_4 to set
	 */
	public void setRees_4(String rees_4) {
		this.rees_4 = rees_4;
	}

	/**
	 * Sets the rees_5.
	 * @param rees_5 The rees_5 to set
	 */
	public void setRees_5(String rees_5) {
		this.rees_5 = rees_5;
	}

	/**
	 * Sets the rees_6.
	 * @param rees_6 The rees_6 to set
	 */
	public void setRees_6(String rees_6) {
		this.rees_6 = rees_6;
	}

	/**
	 * Sets the rees_7.
	 * @param rees_7 The rees_7 to set
	 */
	public void setRees_7(String rees_7) {
		this.rees_7 = rees_7;
	}

	/**
	 * Sets the rees_8.
	 * @param rees_8 The rees_8 to set
	 */
	public void setRees_8(String rees_8) {
		this.rees_8 = rees_8;
	}

	/**
	 * Sets the rees_9.
	 * @param rees_9 The rees_9 to set
	 */
	public void setRees_9(String rees_9) {
		this.rees_9 = rees_9;
	}

	/**
	 * Sets the identifiant.
	 * @param identifiant The identifiant to set
	 */
	public void setIdentifiant(String identifiant) {
		this.identifiant = identifiant;
	}

	/**
	 * Sets the total_cons.
	 * @param total_cons The total_cons to set
	 */
	public void setTotal_cons(String total_pid) {
		this.total_cons = total_pid;
	}

	/**
	 * Returns the nom_ress.
	 * @return String
	 */
	public String getNom_ress() {
		return nom_ress;
	}

	/**
	 * Sets the nom_ress.
	 * @param nom_ress The nom_ress to set
	 */
	public void setNom_ress(String nom_ress) {
		this.nom_ress = nom_ress;
	}
	
	/**
	 * Sets the fermee.
	 * @param fermee The fermee to set
	 */
	public void setFermee(String fermee) {
		this.fermee = fermee;
	}

	/**
	 * @return
	 */
	public String getTotal_rees() {
		return total_rees;
	}

	/**
	 * @param string
	 */
	public void setTotal_rees(String string) {
		total_rees = string;
	}

	/**
	 * @return
	 */
	public String getTot_mois_1() {
		return this.tot_mois_1;
	}

	/**
	 * @return
	 */
	public String getTot_mois_10() {
		return this.tot_mois_10;
	}

	/**
	 * @return
	 */
	public String getTot_mois_11() {
		return this.tot_mois_11;
	}

	/**
	 * @return
	 */
	public String getTot_mois_12() {
		return this.tot_mois_12;
	}

	/**
	 * @return
	 */
	public String getTot_mois_2() {
		return this.tot_mois_2;
	}

	/**
	 * @return
	 */
	public String getTot_mois_3() {
		return this.tot_mois_3;
	}

	/**
	 * @return
	 */
	public String getTot_mois_4() {
		return this.tot_mois_4;
	}

	/**
	 * @return
	 */
	public String getTot_mois_5() {
		return this.tot_mois_5;
	}

	/**
	 * @return
	 */
	public String getTot_mois_6() {
		return this.tot_mois_6;
	}

	/**
	 * @return
	 */
	public String getTot_mois_7() {
		return this.tot_mois_7;
	}

	/**
	 * @return
	 */
	public String getTot_mois_8() {
		return this.tot_mois_8;
	}

	/**
	 * @return
	 */
	public String getTot_mois_9() {
		return this.tot_mois_9;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_1(String string) {
		tot_mois_1 = string;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_10(String string) {
		this.tot_mois_10 = string;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_11(String string) {
		this.tot_mois_11 = string;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_12(String string) {
		this.tot_mois_12 = string;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_2(String string) {
		this.tot_mois_2 = string;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_3(String string) {
		this.tot_mois_3 = string;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_4(String string) {
		this.tot_mois_4 = string;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_5(String string) {
		this.tot_mois_5 = string;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_6(String string) {
		this.tot_mois_6 = string;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_7(String string) {
		this.tot_mois_7 = string;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_8(String string) {
		this.tot_mois_8 = string;
	}

	/**
	 * @param string
	 */
	public void setTot_mois_9(String string) {
		this.tot_mois_9 = string;
	}

}
