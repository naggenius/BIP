package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author MMC - 24/07/2003
 *
 * COntrats Avenants
 * chemin : Ordonnancemement / Contrats / contrats avenants
 * pages  : bContrataveOr.jsp 
 * pl/sql : contrat.sql 
 */
public class ContratAveForm extends AutomateForm {

	/*soccont
	*/
	private String soccont ;

	/*soclib
	*/
	private String soclib ;
	/*numcont
	*/
	private String numcont ;
	/*cav
	*/
	private String cav ;
	/*cagrement
	*/
	private String cagrement ;
	/*niche
	*/
	private String niche ;
	/*cnaffair
	*/
	private String cnaffair ;
	/*crang
	*/
	private String crang ;

	/*cdatarr
	*/
	private String cdatarr ;
	
	/*csourcecontrat
	*/
	private String csourcecontrat ;
	
	/*cobjet1
	*/
	private String cobjet1 ;
	/*cobjet2
	*/
	private String cobjet2 ;
	/*crem
	*/
	private String crem ;
	/*codsg
	*/
	private String codsg ;
	/*comcode
	*/
	private String comcode ;

	/*ctypfact
	*/
	private String ctypfact ;
	/*ccoutht
	*/
	private String ccoutht ;
	/*ccharesti
	*/
	private String ccharesti ;
	/*cdatdeb
	*/
	private String cdatdeb ;
	/*cdatfin
	*/
	private String cdatfin ;  
	/*Le flaglock
	*/
	private int flaglock ; 
	
	/*socout
	*/
	private String socout ;
	/*cavout
	*/
	private String cavout ;
	/*choixout
	*/
	private String choixout ;
	/*cnaffout
	*/
	private String cnaffout ;
	
	/*keyList1
	*/
	private String keyList1 ;
	/*keyList2
	*/
	private String keyList2 ;
	/*keyList0
	*/
	private String keyList0 ;
	/*keyList3
	*/
	private String keyList3 ;
	/*choix
	*/
	private String test ;
	
	/*socfact
	*/
	private String socfact ;
                                                     
   private String siren;                              
	/**
	 * Constructor for ContratAveForm.
	 */
	public ContratAveForm() {
		super();
	}

/**
     * Validate the properties that have been set from this HTTP request,
     * and return an <code>ActionErrors</code> object that encapsulates any
     * validation errors that have been found.  If no errors are found, return
     * <code>null</code> or an <code>ActionErrors</code> object with no
     * recorded error messages.
     *
     * @param mapping The mapping used to select this instance
     * @param request The servlet request we are processing
     */
    public ActionErrors validate(ActionMapping mapping,
                                 HttpServletRequest request) {


        ActionErrors errors = new ActionErrors();
        
        this.logIhm.debug("Début validation de la form -> " + this.getClass()) ;
  
        
        logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
        return errors; 
    }
	
	/**
	 * Returns the cagrement.
	 * @return String
	 */
	public String getCagrement() {
		return cagrement;
	}

	/**
	 * Returns the cav.
	 * @return String
	 */
	public String getCav() {
		return cav;
	}

	/**
	 * Returns the ccharesti.
	 * @return String
	 */
	public String getCcharesti() {
		return ccharesti;
	}

	/**
	 * Returns the ccoutht.
	 * @return String
	 */
	public String getCcoutht() {
		return ccoutht;
	}

	/**
	 * Returns the cdatarr.
	 * @return String
	 */
	public String getCdatarr() {
		return cdatarr;
	}

	/**
	 * Returns the cdatdeb.
	 * @return String
	 */
	public String getCdatdeb() {
		return cdatdeb;
	}

	/**
	 * Returns the cdatfin.
	 * @return String
	 */
	public String getCdatfin() {
		return cdatfin;
	}

	/**
	 * Returns the cnaffair.
	 * @return String
	 */
	public String getCnaffair() {
		return cnaffair;
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
	 * Returns the comcode.
	 * @return String
	 */
	public String getComcode() {
		return comcode;
	}

	/**
	 * Returns the crang.
	 * @return String
	 */
	public String getCrang() {
		return crang;
	}

	/**
	 * Returns the crem.
	 * @return String
	 */
	public String getCrem() {
		return crem;
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
	 * Returns the niche.
	 * @return String
	 */
	public String getNiche() {
		return niche;
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
	 * Sets the cagrement.
	 * @param cagrement The cagrement to set
	 */
	public void setCagrement(String cagrement) {
		this.cagrement = cagrement;
	}

	/**
	 * Sets the cav.
	 * @param cav The cav to set
	 */
	public void setCav(String cav) {
		this.cav = cav;
	}

	/**
	 * Sets the ccharesti.
	 * @param ccharesti The ccharesti to set
	 */
	public void setCcharesti(String ccharesti) {
		this.ccharesti = ccharesti;
	}

	/**
	 * Sets the ccoutht.
	 * @param ccoutht The ccoutht to set
	 */
	public void setCcoutht(String ccoutht) {
		this.ccoutht = ccoutht;
	}

	/**
	 * Sets the cdatarr.
	 * @param cdatarr The cdatarr to set
	 */
	public void setCdatarr(String cdatarr) {
		this.cdatarr = cdatarr;
	}

	/**
	 * Sets the cdatdeb.
	 * @param cdatdeb The cdatdeb to set
	 */
	public void setCdatdeb(String cdatdeb) {
		this.cdatdeb = cdatdeb;
	}

	/**
	 * Sets the cdatfin.
	 * @param cdatfin The cdatfin to set
	 */
	public void setCdatfin(String cdatfin) {
		this.cdatfin = cdatfin;
	}

	/**
	 * Sets the cnaffair.
	 * @param cnaffair The cnaffair to set
	 */
	public void setCnaffair(String cnaffair) {
		this.cnaffair = cnaffair;
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
	 * Sets the comcode.
	 * @param comcode The comcode to set
	 */
	public void setComcode(String comcode) {
		this.comcode = comcode;
	}

	/**
	 * Sets the crang.
	 * @param crang The crang to set
	 */
	public void setCrang(String crang) {
		this.crang = crang;
	}

	/**
	 * Sets the crem.
	 * @param crem The crem to set
	 */
	public void setCrem(String crem) {
		this.crem = crem;
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
	 * Sets the niche.
	 * @param niche The niche to set
	 */
	public void setNiche(String niche) {
		this.niche = niche;
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
		this.soccont = soccont;
	}

	/**
	 * Sets the soclib.
	 * @param soclib The soclib to set
	 */
	public void setSoclib(String soclib) {
		this.soclib = soclib;
	}

	/**
	 * Returns the cavout.
	 * @return String
	 */
	public String getCavout() {
		return cavout;
	}

	/**
	 * Returns the choixout.
	 * @return String
	 */
	public String getChoixout() {
		return choixout;
	}

	/**
	 * Returns the cnaffout.
	 * @return String
	 */
	public String getCnaffout() {
		return cnaffout;
	}

	/**
	 * Returns the socout.
	 * @return String
	 */
	public String getSocout() {
		return socout;
	}

	/**
	 * Sets the cavout.
	 * @param cavout The cavout to set
	 */
	public void setCavout(String cavout) {
		this.cavout = cavout;
	}

	/**
	 * Sets the choixout.
	 * @param choixout The choixout to set
	 */
	public void setChoixout(String choixout) {
		this.choixout = choixout;
	}

	/**
	 * Sets the cnaffout.
	 * @param cnaffout The cnaffout to set
	 */
	public void setCnaffout(String cnaffout) {
		this.cnaffout = cnaffout;
	}

	/**
	 * Sets the socout.
	 * @param socout The socout to set
	 */
	public void setSocout(String socout) {
		this.socout = socout;
	}

	/**
	 * Returns the test.
	 * @return String
	 */
	public String getTest() {
		return test;
	}

	/**
	 * Sets the test.
	 * @param test The test to set
	 */
	public void setTest(String test) {
		this.test = test;
	}

	/**
	 * Returns the keyList0.
	 * @return String
	 */
	public String getKeyList0() {
		return keyList0;
	}

	/**
	 * Sets the keyList0.
	 * @param keyList0 The keyList0 to set
	 */
	public void setKeyList0(String keyList0) {
		this.keyList0 = keyList0;
	}

	/**
	 * Returns the keyList1.
	 * @return String
	 */
	public String getKeyList1() {
		return keyList1;
	}

	/**
	 * Returns the keyList2.
	 * @return String
	 */
	public String getKeyList2() {
		return keyList2;
	}

	/**
	 * Sets the keyList1.
	 * @param keyList1 The keyList1 to set
	 */
	public void setKeyList1(String keyList1) {
		this.keyList1 = keyList1;
	}

	/**
	 * Sets the keyList2.
	 * @param keyList2 The keyList2 to set
	 */
	public void setKeyList2(String keyList2) {
		this.keyList2 = keyList2;
	}

	/**
	 * Returns the socfact.
	 * @return String
	 */
	public String getSocfact() {
		return socfact;
	}

	/**
	 * Sets the socfact.
	 * @param socfact The socfact to set
	 */
	public void setSocfact(String socfact) {
		this.socfact = socfact;
	}

	/**
	 * Returns the keyList3.
	 * @return String
	 */
	public String getKeyList3() {
		return keyList3;
	}

	/**
	 * Sets the keyList3.
	 * @param keyList3 The keyList3 to set
	 */
	public void setKeyList3(String keyList3) {
		this.keyList3 = keyList3;
	}

	public String getSiren() {
		return siren;
	}

	public void setSiren(String siren) {
		this.siren = siren;
	}

	public String getCsourcecontrat() {
		return csourcecontrat;
	}

	public void setCsourcecontrat(String csourcecontrat) {
		this.csourcecontrat = csourcecontrat;
	}

}                               