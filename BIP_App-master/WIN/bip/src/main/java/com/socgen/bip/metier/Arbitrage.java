package com.socgen.bip.metier;

import java.sql.Timestamp;


/**
 * @author N.BACCAM - 15/07/2003
 *
 * represente un arbitrage
 * chemin : Administration/Budgets JH/Arbitrage
 * pages  : fBudgMassAd.jsp et bAbitrageAd.jsp
 */
public class Arbitrage {
	
    private String icpi;
    
    private String dpcode;
    
    private String metier;
    
    private String fournisseur;
    
	/*La ligne BIP
	*/
	private String pid ;
	/*Le type principal de la ligne BIP
	 */
    private String type;
    /*Le type secondaire de la ligne BIP
	 */
    private String arctype;
	/*Le code DPG
	*/
	private String codsg;
	
	/*Le proposé MO
	*/
    private String bpmontmo;
    /*Le arbitre
	*/
    private String anmont;
    /*ecart 
	*/
    private String ecart;
    //YNI
    /*Le arbitre
	*/
    private Timestamp date;
    /*ecart 
	*/
    private String identifiant;
    //Fin YNI
    
    // KRA - Version SIOP - PPM 61919 - §6.9
    private String ref_demande;
    
    private String consoAnnee;
    //Fin KRA
	/*Le flaglock
	*/
    private String flaglock;
    
    private String clilib;
    
    private String dp_copi;
    
    private String ck;

	public String getIcpi() {
		return icpi;
	}

	public void setIcpi(String icpi) {
		this.icpi = icpi;
	}

	/**
	 * Constructor for PropoMassForm.
	 */
	public Arbitrage() {
		super();
	}

    /**
	 * Constructor for Propose
	 *  KRA - Version SIOP - PPM 61919 - §6.9
	 */
	public Arbitrage(String clilib, String dpcode,String dp_copi, String icpi, String metier, String fournisseur, String pid, String type, String arctype,String bpmontmo, String ecart, String anmont, String flaglock, String ck, Timestamp date, String identifiant, String ref_demande, String consoAnnee) {
		this.clilib = clilib;
		this.dpcode = dpcode;
		this.dp_copi = dp_copi;
		this.icpi = icpi;
		this.metier = metier;
		this.fournisseur = fournisseur;
		this.pid = pid;
		this.type = type;
		this.arctype = arctype;
		this.bpmontmo = bpmontmo;
		this.ecart = ecart;
		this.anmont = anmont;
		this.flaglock = flaglock;
		this.ck = ck;
		this.date = date;
		this.identifiant = identifiant;
		this.ref_demande = ref_demande;// KRA - Version SIOP - PPM 61919 - §6.9
		this.consoAnnee = consoAnnee;// KRA - Version SIOP - PPM 61919 - §6.9
	}

	public String getAnmont() {
		return anmont;
	}

	public void setAnmont(String anmont) {
		this.anmont = anmont;
	}

	public String getBpmontmo() {
		return bpmontmo;
	}

	public void setBpmontmo(String bpmontmo) {
		this.bpmontmo = bpmontmo;
	}

	public String getCodsg() {
		return codsg;
	}

	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	public String getDpcode() {
		return dpcode;
	}

	public void setDpcode(String dpcode) {
		this.dpcode = dpcode;
	}

	public String getEcart() {
		return ecart;
	}

	public void setEcart(String ecart) {
		this.ecart = ecart;
	}

	public String getFlaglock() {
		return flaglock;
	}

	public void setFlaglock(String flaglock) {
		this.flaglock = flaglock;
	}

	public String getMetier() {
		return metier;
	}

	public void setMetier(String metier) {
		this.metier = metier;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getCk() {
		return ck;
	}

	public void setCk(String ck) {
		this.ck = ck;
	}

	public String getFournisseur() {
		return fournisseur;
	}

	public void setFournisseur(String fournisseur) {
		this.fournisseur = fournisseur;
	}

	public String getClilib() {
		return clilib;
	}

	public void setClilib(String clilib) {
		this.clilib = clilib;
	}

	public String getDp_copi() {
		return dp_copi;
	}

	public void setDp_copi(String dp_copi) {
		this.dp_copi = dp_copi;
	}

	/**
	 * @return the date
	 */
	public Timestamp getDate() {
		return date;
	}

	/**
	 * @param date the date to set
	 */
	public void setDate(Timestamp date) {
		this.date = date;
	}

	/**
	 * @return the identifiant
	 */
	public String getIdentifiant() {
		return identifiant;
	}

	/**
	 * @param identifiant the identifiant to set
	 */
	public void setIdentifiant(String identifiant) {
		this.identifiant = identifiant;
	}

	public String getArctype() {
		return arctype;
	}

	public void setArctype(String arctype) {
		this.arctype = arctype;
	}
// KRA - Version SIOP - PPM 61919 - §6.9
	/**
	 * @return the ref_demande
	 */
	public String getRef_demande() {
		return ref_demande;
	}

	/**
	 * @param ref_demande the ref_demande to set
	 */
	public void setRef_demande(String ref_demande) {
		this.ref_demande = ref_demande;
	}

	/**
	 * @return the consoAnnee
	 */
	public String getConsoAnnee() {
		return consoAnnee;
	}

	/**
	 * @param consoAnnee the consoAnnee to set
	 */
	public void setConsoAnnee(String consoAnnee) {
		this.consoAnnee = consoAnnee;
	}
	//Fin KRA
   

	

}
