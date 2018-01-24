package com.socgen.bip.metier;

import java.sql.Timestamp;


/**
 * @author N.BACCAM - 15/07/2003
 *
 * represente un propose
 * chemin : Administration/Budgets JH/Saisie en masse
 * pages  : fBudgMassAd.jsp et bPropoMassAd.jsp
 * pl/sql : propomass.sql
 */
public class Propose {
	/*La direction
	*/
	private String clicode ;
	/*La ligne BIP
	*/
	private String pid ;
	/*Le type de la ligne BIP
	 */
    private String type;
	/*Le libellé de la ligne BIP
	*/
	private String pnom;
	/*Le code DPG
	*/
	private String codsg;
	/* L'intitulé du code DPG
	 */
	private String libCodsg;
	/*Le proposé ME
	*/
    private String bpmontme;
	/*Le proposé MO
	*/
    private String bpmontmo;
    
    //YNI
    /*DAte modification budget ME
	*/
    private String bpdate;
	/*Identifant du modificateur MO
	*/
    private String ubpmontme;
    /*DAte modification budget ME
	*/
    private String bpmedate;
	/*Identifant du modificateur MO
	*/
    private String ubpmontmo;
    //Fin YNI
    
	/*Le flaglock
	*/
    private String flaglock;
    
    private String icpi;

    private String isPerimMo;
    
    private String isPerimMe;
    
    
	public String getIsPerimMe() {
		return isPerimMe;
	}

	public void setIsPerimMe(String isPerimMe) {
		this.isPerimMe = isPerimMe;
	}

	public String getIsPerimMo() {
		return isPerimMo;
	}

	public void setIsPerimMo(String isPerimMo) {
		this.isPerimMo = isPerimMo;
	}

	public String getIcpi() {
		return icpi;
	}

	public void setIcpi(String icpi) {
		this.icpi = icpi;
	}

	/**
	 * Constructor for PropoMassForm.
	 */
	public Propose() {
		super();
	}

    /**
	 * Constructor for Propose
	 */
	public Propose(String clicode, String pid, String type, String pnom, String codsg, String libCodsg, String bpmontme, String bpmontmo, String flaglock, String icpi, String bpdate, String ubpmontme, String bpmedate, String ubpmontmo, String isperimmo, String ispreimme) {
		this.clicode = clicode;
		this.pid = pid;
		this.type = type;
		this.pnom = pnom;
		this.codsg = codsg;
		this.libCodsg = libCodsg;
		this.bpmontme = bpmontme;
		this.bpmontmo = bpmontmo;
		this.flaglock = flaglock;
		this.icpi = icpi;
		this.bpdate = bpdate;
		this.ubpmontme = ubpmontme;
		this.bpmedate = bpmedate;
		this.ubpmontmo = ubpmontmo;
		this.isPerimMo = isperimmo;
		this.isPerimMe = ispreimme;
		
	}
   

	/**
	 * Returns the clicode.
	 * @return String
	 */
	public String getClicode() {
		return clicode;
	}

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * Sets the clicode.
	 * @param clicode The clicode to set
	 */
	public void setClicode(String clicode) {
		this.clicode = clicode;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Returns the bpmontmo.
	 * @return int
	 */
	public String getBpmontmo() {
		return bpmontmo;
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
	 * Sets the bpmontmo.
	 * @param bpmontmo The bpmontmo to set
	 */
	public void setBpmontmo(String bpmontmo) {
		this.bpmontmo = bpmontmo;
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
	 * Returns the bpmontme.
	 * @return String
	 */
	public String getBpmontme() {
		return bpmontme;
	}

	/**
	 * Returns the flaglock.
	 * @return String
	 */
	public String getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the libCodsg.
	 * @return String
	 */
	public String getLibCodsg() {
		return libCodsg;
	}

	/**
	 * Returns the type.
	 * @return String
	 */
	public String getType() {
		return type;
	}

	/**
	 * Sets the bpmontme.
	 * @param bpmontme The bpmontme to set
	 */
	public void setBpmontme(String bpmontme) {
		this.bpmontme = bpmontme;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(String flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the libCodsg.
	 * @param libCodsg The libCodsg to set
	 */
	public void setLibCodsg(String libCodsg) {
		this.libCodsg = libCodsg;
	}

	/**
	 * Sets the type.
	 * @param type The type to set
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * @return the bpdate
	 */
	public String getBpdate() {
		return bpdate;
	}

	/**
	 * @param bpdate the bpdate to set
	 */
	public void setBpdate(String bpdate) {
		this.bpdate = bpdate;
	}

	/**
	 * @return the bpmedate
	 */
	public String getBpmedate() {
		return bpmedate;
	}

	/**
	 * @param bpmedate the bpmedate to set
	 */
	public void setBpmedate(String bpmedate) {
		this.bpmedate = bpmedate;
	}

	/**
	 * @return the ubpmontme
	 */
	public String getUbpmontme() {
		return ubpmontme;
	}

	/**
	 * @param ubpmontme the ubpmontme to set
	 */
	public void setUbpmontme(String ubpmontme) {
		this.ubpmontme = ubpmontme;
	}

	/**
	 * @return the ubpmontmo
	 */
	public String getUbpmontmo() {
		return ubpmontmo;
	}

	/**
	 * @param ubpmontmo the ubpmontmo to set
	 */
	public void setUbpmontmo(String ubpmontmo) {
		this.ubpmontmo = ubpmontmo;
	}

	

}
