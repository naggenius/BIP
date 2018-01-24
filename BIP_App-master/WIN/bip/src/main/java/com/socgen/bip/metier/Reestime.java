package com.socgen.bip.metier;

import java.sql.Timestamp;

/**
 * @author user
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class Reestime{
	/*La direction
	*/
	private String clicode ;
	/*La ligne BIP
	*/
	private String pid ;
	/*Le type de la ligne
	 */
	private String type;
	/*Le libellé
	*/
	private String pnom ;
	/* Le DPG
	 */
	private String codsg;
	/*Le consommé
	*/
    private String xcusag0;
    /*Le notifié/arbitré
	*/
	private String xbnmont ;
	 /*Le réestimé
	*/
	private String preesancou;
	//YNI
	/*date de modification du budget reestime
	*/
	private String redate ;
	 /*Identifiant du modificateur du reestime
	*/
	private String ureestime;
	//Fin YNI
	
	 /*Le code projet
	*/
	private String icpi;

			
	private String flaglock;

	private String reescomm;
	


	/**
	 * Constructor for ReestimeDpg.
	 */
	public Reestime() {
		super();
	}

/**
	 * Constructor for ReestimeDpg.
	 */
	public Reestime(String clicode, String pid, String type, String pnom, String flaglock, String codsg, String xcusag0, String xbnmont, String preesancou, String icpi, String redate, String ureestime, String reescomm) {
		this.clicode = clicode;
		this.pid = pid;
		this.type = type;
		this.pnom = pnom;
		this.codsg =codsg;
		this.xcusag0 = xcusag0;
		this.xbnmont= xbnmont;
		this.preesancou = preesancou;
		this.flaglock = flaglock;
		this.icpi = icpi;
		this.redate = redate;
		this.ureestime = ureestime;
		this.reescomm = reescomm;
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
	 * Returns the flaglock.
	 * @return String
	 */
	public String getFlaglock() {
		return flaglock;
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
	 * Returns the preesancou.
	 * @return String
	 */
	public String getPreesancou() {
		return preesancou;
	}

	/**
	 * Returns the xbnmont.
	 * @return String
	 */
	public String getXbnmont() {
		return xbnmont;
	}

	/**
	 * Returns the xcusag0.
	 * @return String
	 */
	public String getXcusag0() {
		return xcusag0;
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
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(String flaglock) {
		this.flaglock = flaglock;
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
	 * Sets the preesancou.
	 * @param preesancou The preesancou to set
	 */
	public void setPreesancou(String preesancou) {
		this.preesancou = preesancou;
	}

	/**
	 * Sets the xbnmont.
	 * @param xbnmont The xbnmont to set
	 */
	public void setXbnmont(String xbnmont) {
		this.xbnmont = xbnmont;
	}

	/**
	 * Sets the xcusag0.
	 * @param xcusag0 The xcusag0 to set
	 */
	public void setXcusag0(String xcusag0) {
		this.xcusag0 = xcusag0;
	}

	/**
	 * Returns the type.
	 * @return String
	 */
	public String getType() {
		return type;
	}

	/**
	 * Sets the type.
	 * @param type The type to set
	 */
	public void setType(String type) {
		this.type = type;
	}

	public String getIcpi() {
		return icpi;
	}

	public void setIcpi(String icpi) {
		this.icpi = icpi;
	}

	/**
	 * @return the redate
	 */
	public String getRedate() {
		return redate;
	}

	/**
	 * @param redate the redate to set
	 */
	public void setRedate(String redate) {
		this.redate = redate;
	}

	/**
	 * @return the ureestime
	 */
	public String getUreestime() {
		return ureestime;
	}

	/**
	 * @param ureestime the ureestime to set
	 */
	public void setUreestime(String ureestime) {
		this.ureestime = ureestime;
	}

	public String getReescomm() {
		return reescomm;
	}

	public void setReescomm(String reescomm) {
		this.reescomm = reescomm;
	}

}
