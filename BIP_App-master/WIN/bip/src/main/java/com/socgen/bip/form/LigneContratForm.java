package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author MMC - 28/07/2003
 *
 * COntrats Avenants / Lignes
 * chemin : Ordonnancemement / Contrats / contrats avenants
 * pages  : fmLignecontratOr.jsp 
 * pl/sql : cligcont.sql 
 */
public class LigneContratForm extends AutomateForm {

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
	
	/*soccontout
	*/
	private String soccontout ;

	/*soclibout
	*/
	private String soclibout ;
	/*numcontout
	*/
	private String numcontout ;
	/*cavout
	*/
	private String cavout ;
	/*lcprest
	*/
	private String lcprest ;
	/*lresdeb
	*/
	private String lresdeb ;
	/*lresfin
	*/
	private String lresfin ;
	/*cout
	*/
	private String cout ;
	/*coutout
	*/
	private String coutout ;
	/*lccouact
	*/
	private String lccouact ;
	/*proporig
	*/
	private String proporig ;  
	/*Le flaglock
	*/
	private int flaglock ; 
	
	
	/*ident
	*/
	private String ident ;
	/*rnom
	*/
	private String rnom ;
	/*rprenom
	*/
	private String rprenom ;
	/*rtype
	*/
	private String rtype ;
	



	/*identout
	*/
	private String identout ;
	/*rnomout
	*/
	private String rnomout ;
	/*rprenomout
	*/
	private String rprenomout ;
	/*choix
	*/
	private String test ;
	/*keyList3
	*/
	private String keyList3 ;
	/*lcnum
	*/
	private String lcnum ;
	/*keyList1
	*/
	private String keyList1 ;
	/*keyList2
	*/
	private String keyList2 ;
	/*keyList0
	*/
	private String keyList0 ;
	/*
	 * Domaine
	 */
	private String lcdomaine;
	/*
	 * Mode contractuel
	 */
	private String modeContractuel;
	/*
	 * Libelle du mode contactuel
	 */
	private String libModeContractuel;
	/*
	 * Type de facturation du contrat 
	 */
	private String ctypfact;
	/*
	 * Type du mode contractuel 
	 */
	private String mc;
	/*
	 * Type de la compatibilité ressource 
	 */
	private String tc;
	
	private String codeloc;
	
	
private String cdatdeb;

private String cdatfin;


	
	/**
	 * Constructor for LigneContratForm.
	 */
	public LigneContratForm() {
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
	 * Returns the cav.
	 * @return String
	 */
	public String getCav() {
		return cav;
	}

	/**
	 * Returns the cout.
	 * @return String
	 */
	public String getCout() {
		return cout;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the ident.
	 * @return String
	 */
	public String getIdent() {
		return ident;
	}

	/**
	 * Returns the lccouact.
	 * @return String
	 */
	public String getLccouact() {
		return lccouact;
	}

	/**
	 * Returns the lcnum.
	 * @return String
	 */
	public String getLcnum() {
		return lcnum;
	}

	/**
	 * Returns the lcprest.
	 * @return String
	 */
	public String getLcprest() {
		return lcprest;
	}

	/**
	 * Returns the lresdeb.
	 * @return String
	 */
	public String getLresdeb() {
		return lresdeb;
	}

	/**
	 * Returns the lresfin.
	 * @return String
	 */
	public String getLresfin() {
		return lresfin;
	}

	/**
	 * Returns the numcont.
	 * @return String
	 */
	public String getNumcont() {
		return numcont;
	}

	/**
	 * Returns the proporig.
	 * @return String
	 */
	public String getProporig() {
		return proporig;
	}

	/**
	 * Returns the rnom.
	 * @return String
	 */
	public String getRnom() {
		return rnom;
	}

	/**
	 * Returns the rprenom.
	 * @return String
	 */
	public String getRprenom() {
		return rprenom;
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
	 * Returns the test.
	 * @return String
	 */
	public String getTest() {
		return test;
	}

	/**
	 * Sets the cav.
	 * @param cav The cav to set
	 */
	public void setCav(String cav) {
		this.cav = cav;
	}

	/**
	 * Sets the cout.
	 * @param cout The cout to set
	 */
	public void setCout(String cout) {
		this.cout = cout;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the ident.
	 * @param ident The ident to set
	 */
	public void setIdent(String ident) {
		this.ident = ident;
	}

	/**
	 * Sets the lccouact.
	 * @param lccouact The lccouact to set
	 */
	public void setLccouact(String lccouact) {
		this.lccouact = lccouact;
	}

	/**
	 * Sets the lcnum.
	 * @param lcnum The lcnum to set
	 */
	public void setLcnum(String lcnum) {
		this.lcnum = lcnum;
	}

	/**
	 * Sets the lcprest.
	 * @param lcprest The lcprest to set
	 */
	public void setLcprest(String lcprest) {
		this.lcprest = lcprest;
	}

	/**
	 * Sets the lresdeb.
	 * @param lresdeb The lresdeb to set
	 */
	public void setLresdeb(String lresdeb) {
		this.lresdeb = lresdeb;
	}

	/**
	 * Sets the lresfin.
	 * @param lresfin The lresfin to set
	 */
	public void setLresfin(String lresfin) {
		this.lresfin = lresfin;
	}

	/**
	 * Sets the numcont.
	 * @param numcont The numcont to set
	 */
	public void setNumcont(String numcont) {
		this.numcont = numcont.trim();
	}

	/**
	 * Sets the proporig.
	 * @param proporig The proporig to set
	 */
	public void setProporig(String proporig) {
		this.proporig = proporig;
	}

	/**
	 * Sets the rnom.
	 * @param rnom The rnom to set
	 */
	public void setRnom(String rnom) {
		this.rnom = rnom;
	}

	/**
	 * Sets the rprenom.
	 * @param rprenom The rprenom to set
	 */
	public void setRprenom(String rprenom) {
		this.rprenom = rprenom;
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
	 * Sets the keyList0.
	 * @param keyList0 The keyList0 to set
	 */
	public void setKeyList0(String keyList0) {
		this.keyList0 = keyList0;
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

	/**
	 * Returns the cavout.
	 * @return String
	 */
	public String getCavout() {
		return cavout;
	}

	/**
	 * Returns the coutout.
	 * @return String
	 */
	public String getCoutout() {
		return coutout;
	}

	/**
	 * Returns the identout.
	 * @return String
	 */
	public String getIdentout() {
		return identout;
	}

	/**
	 * Returns the numcontout.
	 * @return String
	 */
	public String getNumcontout() {
		return numcontout;
	}

	/**
	 * Returns the rnomout.
	 * @return String
	 */
	public String getRnomout() {
		return rnomout;
	}

	/**
	 * Returns the rprenomout.
	 * @return String
	 */
	public String getRprenomout() {
		return rprenomout;
	}

	/**
	 * Returns the soccontout.
	 * @return String
	 */
	public String getSoccontout() {
		return soccontout;
	}

	/**
	 * Returns the soclibout.
	 * @return String
	 */
	public String getSoclibout() {
		return soclibout;
	}

	/**
	 * Sets the cavout.
	 * @param cavout The cavout to set
	 */
	public void setCavout(String cavout) {
		this.cavout = cavout;
	}

	/**
	 * Sets the coutout.
	 * @param coutout The coutout to set
	 */
	public void setCoutout(String coutout) {
		this.coutout = coutout;
	}

	/**
	 * Sets the identout.
	 * @param identout The identout to set
	 */
	public void setIdentout(String identout) {
		this.identout = identout;
	}

	/**
	 * Sets the numcontout.
	 * @param numcontout The numcontout to set
	 */
	public void setNumcontout(String numcontout) {
		this.numcontout = numcontout;
	}

	/**
	 * Sets the rnomout.
	 * @param rnomout The rnomout to set
	 */
	public void setRnomout(String rnomout) {
		this.rnomout = rnomout;
	}

	/**
	 * Sets the rprenomout.
	 * @param rprenomout The rprenomout to set
	 */
	public void setRprenomout(String rprenomout) {
		this.rprenomout = rprenomout;
	}

	/**
	 * Sets the soccontout.
	 * @param soccontout The soccontout to set
	 */
	public void setSoccontout(String soccontout) {
		this.soccontout = soccontout;
	}

	/**
	 * Sets the soclibout.
	 * @param soclibout The soclibout to set
	 */
	public void setSoclibout(String soclibout) {
		this.soclibout = soclibout;
	}

	public String getLcdomaine() {
		return lcdomaine;
	}

	public void setLcdomaine(String lcdomaine) {
		this.lcdomaine = lcdomaine;
	}

	public String getLibModeContractuel() {
		return libModeContractuel;
	}

	public void setLibModeContractuel(String libModeContractuel) {
		this.libModeContractuel = libModeContractuel;
	}

	public String getModeContractuel() {
		return modeContractuel;
	}

	public void setModeContractuel(String modeContractuel) {
		this.modeContractuel = modeContractuel;
	}

	public String getRtype() {
		return rtype;
	}

	public void setRtype(String rtype) {
		this.rtype = rtype;
	}

	public String getCtypfact() {
		return ctypfact;
	}

	public void setCtypfact(String ctypfact) {
		this.ctypfact = ctypfact;
	}

	public String getMc() {
		return mc;
	}

	public void setMc(String mc) {
		this.mc = mc;
	}

	public String getTc() {
		return tc;
	}

	public void setTc(String tc) {
		this.tc = tc;
	}

	public String getCodeloc() {
		return codeloc;
	}

	public void setCodeloc(String codeloc) {
		this.codeloc = codeloc;
	}

	public String getCdatdeb() {
		return cdatdeb;
	}

	public void setCdatdeb(String cdatdeb) {
		this.cdatdeb = cdatdeb;
	}

	public String getCdatfin() {
		return cdatfin;
	}

	public void setCdatfin(String cdatfin) {
		this.cdatfin = cdatfin;
	}
	
	
}    
