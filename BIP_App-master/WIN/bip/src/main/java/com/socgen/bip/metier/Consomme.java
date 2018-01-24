package com.socgen.bip.metier;

import com.socgen.bip.form.SaisieConsoForm;

/**
 * @author N.BACCAM - 29/07/2003
 *

 * represente un consomme dans le menu Saisie des réalisés
 * chemin : Saisie des réalisés/Saisie des consommés
 * pages  : fSaisieConsoSr.jsp et bSaisieConsoSr.jsp
 * pl/sql : isac_conso.sql
 */
public class Consomme extends SaisieConsoForm{

	public static final Integer CHOIX_AUCUN = 1;
	public static final Integer CHOIX_DESAFFECTATION = 2;
	public static final Integer CHOIX_SUPPRESSION = 3;
	public static final Integer CHOIX_MISE_EN_FAVORITE = 4;
	
	/*Le consomme du mois de janvier
	*/
	private String conso_1;
	/*Le consomme du mois de février
	*/
	private String conso_2;
	/*Le consomme du mois de mars
	*/
	private String conso_3;
	/*Le consomme du mois de avril
	*/
	private String conso_4;
	/*Le consomme du mois de mai
	*/
	private String conso_5;
	/*Le consomme du mois de juin
	*/
	private String conso_6;
	/*Le consomme du mois de juillet
	*/
	private String conso_7;
	/*Le consomme du mois de aout
	*/
	private String conso_8;
	/*Le consomme du mois de septembre
	*/
	private String conso_9;
	/*Le consomme du mois de octobre
	*/
	private String conso_10;
	/*Le consomme du mois de novembre
	*/
	private String conso_11;
	/*Le consomme du mois de décembre
	*/
	private String conso_12;

	/*Le total de la ligne
	*/
	private String total_pid;
	/*L'identifiant :a.pid||e.ecet||t.acta||st.acst
	*/
	private String identifiant;
	/*type de l'étape
	*/
	private String typetape;
	
	/*Pour determiner si le champ est modifiable ou pas*/
	private String fermee;
	
	/*Type ligne bip*/
	private String typproj;
    private String moisfin;
	private String statut;
	private String datedebut;
	
	private String codsg;
	private Integer choix;
	//ABN - HP PPM 57735 (GESTION DES FAVORIS)
	private Integer choixOld;
	private String existeConsomme;
	 
	
	/**
	 * Start of BIP-196 user story - Adding subtask type id date column
	 */
	private String aist_moisfin;
	
	public String getAist_moisfin() {
		return aist_moisfin;
	}

	public void setAist_moisfin(String aist_moisfin) {
		this.aist_moisfin = aist_moisfin;
	}
	
	/**
	 * Constructor for PropoMassForm.
	 */
	public Consomme() {
		super();
	}
	
	/**
	 * Constructeur.
	 * @param conso_1
	 * @param conso_2
	 * @param conso_3
	 * @param conso_4
	 * @param conso_5
	 * @param conso_6
	 * @param conso_7
	 * @param conso_8
	 * @param conso_9
	 * @param conso_10
	 * @param conso_11
	 * @param conso_12
	 * @param pid
	 * @param lib
	 * @param etape
	 * @param ecet
	 * @param libetape
	 * @param tache
	 * @param acta
	 * @param libtache
	 * @param sous_tache
	 * @param acst
	 * @param asnom
	 * @param aist
	 * @param mois
	 * @param total_pid
	 * @param identifiant
	 * @param typetape
	 * @param fermee
	 * @param moisfin
	 * @param statut
	 * @param datedebut
	 * @param typproj
	 * @param favorite
	 * @param existeConsomme
	 * @param codsg
	 */
	public Consomme(String conso_1, String conso_2, String conso_3, String conso_4, String conso_5, String conso_6,
					 String conso_7, String conso_8, String conso_9, String conso_10, String conso_11, String conso_12,
					 String pid, String lib, String etape, String ecet, String libetape,
					 String tache, String acta, String libtache,
					 String sous_tache, String acst, String asnom, String aist,
					 String mois , String total_pid, String identifiant,
   					  String typetape, String fermee, String moisfin, String statut,String datedebut, String typproj,
   					  String favorite, String existeConsomme, String codsg, String aist_moisfin) {
		super();
		this.conso_1 = conso_1;
		this.conso_2 = conso_2;
		this.conso_3 = conso_3;
		this.conso_4 = conso_4;
		this.conso_5 = conso_5;
		this.conso_6 = conso_6;
		this.conso_7 = conso_7;
		this.conso_8 = conso_8;
		this.conso_9 = conso_9;
		this.conso_10 = conso_10;
		this.conso_11 = conso_11;
		this.conso_12 = conso_12;
		this.pid = pid;
		this.lib = lib;
		this.etape = etape;
		this.ecet = ecet;
		this.libetape = libetape;
		this.tache= tache;
		this.acta = acta;
		this.libtache = libtache;
		this.sous_tache =sous_tache;	
		this.acst = acst;
		this.asnom = asnom;
		this.aist = aist;
		this.mois = mois;
		this.total_pid= total_pid;
		this.identifiant = identifiant;
		this.typetape = typetape;
		this.fermee = fermee;
		this.moisfin=moisfin;
		this.statut=statut;
		this.datedebut=datedebut;
		this.typproj = typproj;
		if ("1".equals(favorite)) {
			this.choix = CHOIX_MISE_EN_FAVORITE;
			this.choixOld = CHOIX_MISE_EN_FAVORITE;
		} else {
			this.choix = CHOIX_AUCUN;
			this.choixOld = CHOIX_AUCUN;
		}
		this.existeConsomme = existeConsomme;
		this.codsg = codsg;
		this.aist_moisfin = aist_moisfin;
	}

	/**
	 * @return the codsg
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * @param codsg the codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * @return the choix
	 */
	public Integer getChoix() {
		return choix;
	}

	/**
	 * @param choix
	 *            the choix to set
	 */
	public void setChoix(Integer choix) {
		this.choix = choix;
	}
	
	/**
	 * @return the choixOld
	 */
	public Integer getChoixOld() {
		return choixOld;
	}

	/**
	 * @param choixOld
	 *            the choixOld to set
	 */
	public void setChoixOld(Integer choixOld) {
		this.choixOld = choixOld;
	}

	/**
	 * @return the existeConsomme
	 */
	public String getExisteConsomme() {
		return existeConsomme;
	}

	/**
	 * @param existeConsomme
	 *            the existeConsomme to set
	 */
	public void setExisteConsomme(String existeConsomme) {
		this.existeConsomme = existeConsomme;
	}

	/**
	 * Returns the conso_1.
	 * 
	 * @return String
	 */
	public String getConso_1() {
		return conso_1;
	}

	/**
	 * Returns the conso_10.
	 * @return String
	 */
	public String getConso_10() {
		return conso_10;
	}

	/**
	 * Returns the conso_11.
	 * @return String
	 */
	public String getConso_11() {
		return conso_11;
	}

	/**
	 * Returns the conso_12.
	 * @return String
	 */
	public String getConso_12() {
		return conso_12;
	}

	/**
	 * Returns the conso_2.
	 * @return String
	 */
	public String getConso_2() {
		return conso_2;
	}

	/**
	 * Returns the conso_3.
	 * @return String
	 */
	public String getConso_3() {
		return conso_3;
	}

	/**
	 * Returns the conso_4.
	 * @return String
	 */
	public String getConso_4() {
		return conso_4;
	}

	/**
	 * Returns the conso_5.
	 * @return String
	 */
	public String getConso_5() {
		return conso_5;
	}

	/**
	 * Returns the conso_6.
	 * @return String
	 */
	public String getConso_6() {
		return conso_6;
	}

	/**
	 * Returns the conso_7.
	 * @return String
	 */
	public String getConso_7() {
		return conso_7;
	}

	/**
	 * Returns the conso_8.
	 * @return String
	 */
	public String getConso_8() {
		return conso_8;
	}

	/**
	 * Returns the conso_9.
	 * @return String
	 */
	public String getConso_9() {
		return conso_9;
	}

	/**
	 * Returns the identifiant.
	 * @return String
	 */
	public String getIdentifiant() {
		return identifiant;
	}

	/**
	 * Returns the total_pid.
	 * @return String
	 */
	public String getTotal_pid() {
		return total_pid;
	}

	/**
	 * Returns the fermee.
	 * @return String
	 */
	public String getFermee() {
		return fermee;
	}
	
	/**
	 * Returns the fermee.
	 * @return String
	 */
	public String getTypproj() {
		return typproj;
	}
	
	/**
	 * Sets the conso_1.
	 * @param conso_1 The conso_1 to set
	 */
	public void setConso_1(String conso_1) {
		this.conso_1 = conso_1;
	}

	/**
	 * Sets the conso_10.
	 * @param conso_10 The conso_10 to set
	 */
	public void setConso_10(String conso_10) {
		this.conso_10 = conso_10;
	}

	/**
	 * Sets the conso_11.
	 * @param conso_11 The conso_11 to set
	 */
	public void setConso_11(String conso_11) {
		this.conso_11 = conso_11;
	}

	/**
	 * Sets the conso_12.
	 * @param conso_12 The conso_12 to set
	 */
	public void setConso_12(String conso_12) {
		this.conso_12 = conso_12;
	}

	/**
	 * Sets the conso_2.
	 * @param conso_2 The conso_2 to set
	 */
	public void setConso_2(String conso_2) {
		this.conso_2 = conso_2;
	}

	/**
	 * Sets the conso_3.
	 * @param conso_3 The conso_3 to set
	 */
	public void setConso_3(String conso_3) {
		this.conso_3 = conso_3;
	}

	/**
	 * Sets the conso_4.
	 * @param conso_4 The conso_4 to set
	 */
	public void setConso_4(String conso_4) {
		this.conso_4 = conso_4;
	}

	/**
	 * Sets the conso_5.
	 * @param conso_5 The conso_5 to set
	 */
	public void setConso_5(String conso_5) {
		this.conso_5 = conso_5;
	}

	/**
	 * Sets the conso_6.
	 * @param conso_6 The conso_6 to set
	 */
	public void setConso_6(String conso_6) {
		this.conso_6 = conso_6;
	}

	/**
	 * Sets the conso_7.
	 * @param conso_7 The conso_7 to set
	 */
	public void setConso_7(String conso_7) {
		this.conso_7 = conso_7;
	}

	/**
	 * Sets the conso_8.
	 * @param conso_8 The conso_8 to set
	 */
	public void setConso_8(String conso_8) {
		this.conso_8 = conso_8;
	}

	/**
	 * Sets the conso_9.
	 * @param conso_9 The conso_9 to set
	 */
	public void setConso_9(String conso_9) {
		this.conso_9 = conso_9;
	}

	/**
	 * Sets the identifiant.
	 * @param identifiant The identifiant to set
	 */
	public void setIdentifiant(String identifiant) {
		this.identifiant = identifiant;
	}

	/**
	 * Sets the total_pid.
	 * @param total_pid The total_pid to set
	 */
	public void setTotal_pid(String total_pid) {
		this.total_pid = total_pid;
	}

	/**
	 * Returns the typetape.
	 * @return String
	 */
	public String getTypetape() {
		return typetape;
	}

	/**
	 * Sets the typetape.
	 * @param typetape The typetape to set
	 */
	public void setTypetape(String typetape) {
		this.typetape = typetape;
	}
	
	/**
	 * Sets the fermee.
	 * @param fermee The fermee to set
	 */
	public void setFermee(String fermee) {
		this.fermee = fermee;
	}
	/**
	 * Sets the typproj.
	 * @param typproj The typproj to set
	 */
	public void setTypproj(String typproj) {
		this.typproj = typproj;
	}
	public String getMoisfin() {
		return moisfin;
	}
	public void setMoisfin(String moisfin) {
		this.moisfin = moisfin;
	}
	public String getStatut() {
		return statut;
	}
	public void setStatut(String statut) {
		this.statut = statut;
	}
	public String getDatedebut() {
		return datedebut;
	}
	public void setDatedebut(String datedebut) {
		this.datedebut = datedebut;
	}
	
}
