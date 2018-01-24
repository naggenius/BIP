package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author MMC - 25/07/2003
 *
 * Date suivi
 * chemin : Ordonnancemement / Contrats / Date suivi
 * pages  : fDatesuiviOr.jsp 
 * pl/sql : cdatcont.sql 
 */
public class DateSuiviForm extends AutomateForm {

	/*soccont
	*/
	private String soccont ;
	/*siren
	*/
	private String siren ;
	/*soclib
	*/
	private String soclib ;
	/*numcont
	*/
	private String numcont ;
	/*cav
	*/
	private String cav ;
	
	
	/*cobjet1
	*/
	private String cobjet1 ;
	/*cobjet2
	*/
	private String cobjet2 ;
	
	/*codsg
	*/
	private String codsg ;
	/*libdsg
	*/
	private String libdsg ;
	/*cdatrpol
	*/
	private String cdatrpol ;

	/*ctypfact
	*/
	private String ctypfact ;
	/*ccoutht
	*/
	private String ccoutht ;
	/*cdatsai
	*/
	private String cdatsai ;
	/*cdatdeb
	*/
	private String cdatdeb ;
	/*cdatfin
	*/
	private String cdatfin ;  
	/*Le flaglock
	*/
	private int flaglock ; 
	
	/*cdatdir
	*/
	private String cdatdir ;

	/**
	 * Constructor for DateSuiviForm.
	 */
	public DateSuiviForm() {
		super();
	}
	

	/**
	 * Returns the cav.
	 * @return String
	 */
	public String getCav() {
		return cav;
	}

	/**
	 * Returns the ccoutht.
	 * @return String
	 */
	public String getCcoutht() {
		return ccoutht;
	}

	/**
	 * Returns the cdatdeb.
	 * @return String
	 */
	public String getCdatdeb() {
		return cdatdeb;
	}

	/**
	 * Returns the cdatdir.
	 * @return String
	 */
	public String getCdatdir() {
		return cdatdir;
	}

	/**
	 * Returns the cdatfin.
	 * @return String
	 */
	public String getCdatfin() {
		return cdatfin;
	}

	/**
	 * Returns the cdatrpol.
	 * @return String
	 */
	public String getCdatrpol() {
		return cdatrpol;
	}

	/**
	 * Returns the cdatsai.
	 * @return String
	 */
	public String getCdatsai() {
		return cdatsai;
	}

	/**
	 * Returns the cobjet1.
	 * @return String
	 */
	public String getCobjet1() {
		return cobjet1;
	}

	/**
	 * Returns the cobjet2.
	 * @return String
	 */
	public String getCobjet2() {
		return cobjet2;
	}

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * Returns the ctypfact.
	 * @return String
	 */
	public String getCtypfact() {
		return ctypfact;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the libdsg.
	 * @return String
	 */
	public String getLibdsg() {
		return libdsg;
	}

	/**
	 * Returns the numcont.
	 * @return String
	 */
	public String getNumcont() {
		return numcont;
	}

	/**
	 * Returns the soccont.
	 * @return String
	 */
	public String getSoccont() {
		return soccont;
	}

	/**
	 * Returns the soclib.
	 * @return String
	 */
	public String getSoclib() {
		return soclib;
	}

	/**
	 * Sets the cav.
	 * @param cav The cav to set
	 */
	public void setCav(String cav) {
		this.cav = cav;
	}

	/**
	 * Sets the ccoutht.
	 * @param ccoutht The ccoutht to set
	 */
	public void setCcoutht(String ccoutht) {
		this.ccoutht = ccoutht;
	}

	/**
	 * Sets the cdatdeb.
	 * @param cdatdeb The cdatdeb to set
	 */
	public void setCdatdeb(String cdatdeb) {
		this.cdatdeb = cdatdeb;
	}

	/**
	 * Sets the cdatdir.
	 * @param cdatdir The cdatdir to set
	 */
	public void setCdatdir(String cdatdir) {
		this.cdatdir = cdatdir;
	}

	/**
	 * Sets the cdatfin.
	 * @param cdatfin The cdatfin to set
	 */
	public void setCdatfin(String cdatfin) {
		this.cdatfin = cdatfin;
	}

	/**
	 * Sets the cdatrpol.
	 * @param cdatrpol The cdatrpol to set
	 */
	public void setCdatrpol(String cdatrpol) {
		this.cdatrpol = cdatrpol;
	}

	/**
	 * Sets the cdatsai.
	 * @param cdatsai The cdatsai to set
	 */
	public void setCdatsai(String cdatsai) {
		this.cdatsai = cdatsai;
	}

	/**
	 * Sets the cobjet1.
	 * @param cobjet1 The cobjet1 to set
	 */
	public void setCobjet1(String cobjet1) {
		this.cobjet1 = cobjet1;
	}

	/**
	 * Sets the cobjet2.
	 * @param cobjet2 The cobjet2 to set
	 */
	public void setCobjet2(String cobjet2) {
		this.cobjet2 = cobjet2;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Sets the ctypfact.
	 * @param ctypfact The ctypfact to set
	 */
	public void setCtypfact(String ctypfact) {
		this.ctypfact = ctypfact;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the libdsg.
	 * @param libdsg The libdsg to set
	 */
	public void setLibdsg(String libdsg) {
		this.libdsg = libdsg;
	}

	/**
	 * Sets the numcont.
	 * @param numcont The numcont to set
	 */
	public void setNumcont(String numcont) {
		this.numcont = numcont.trim();
	}

	/**
	 * Sets the soccont.
	 * @param soccont The soccont to set
	 */
	public void setSoccont(String soccont) {
		this.soccont = soccont.trim();
	}

	/**
	 * Sets the soclib.
	 * @param soclib The soclib to set
	 */
	public void setSoclib(String soclib) {
		this.soclib = soclib;
	}


	public String getSiren() {
		return siren;
	}


	public void setSiren(String siren) {
		this.siren = siren;
	}

}