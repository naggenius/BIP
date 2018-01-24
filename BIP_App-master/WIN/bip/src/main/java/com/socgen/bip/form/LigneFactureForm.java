package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

/**
 * @author MMC - 11/08/2003
 *
 * Factures / Lignes
 * chemin : Ordonnancemement / Factures / Gestion /facture
 * pages  : bLignefactureOr.jsp 
 * pl/sql : fligfact.sql 
 */
public class LigneFactureForm extends FactureForm {

	/*Numero Expense
	*/
	private String num_expense;
	
	/*clelf
	*/
	private String clelf ;
	
	/*socfactout
	*/
	private String socfactout ;

	
	/*numfactout
	*/
	private String numfactout ;
	
	/*numcont
	*/
	//private String numcont;
	/*numcontout
	*/
	private String numcontout ;
	
	/*Le flaglock
	*/
	private String flaglock ; 
	/*Le flaglockout
	*/
	private String flaglockout ; 
	/*lisetress
	*/
	private String listeress ;
	
	/*ftva
	*/
	private String ftva;
	/*ident
	*/
	private String ident ;
	/*typfact
	*/
	private String typfact ;
	/*typfactout
	*/
	private String typfactout ;
	/*datfact
	*/
	private String datfact ;
	/*datfactout
	*/
	private String datfactout ;
	/*fmontht
	*/
	private String fmontht ;
	/*lmontht
	*/
	private String lmontht ;
	/*lmoisprest
	*/
	private String lmoisprest ;
	/*lcodcompta
	*/
	private String lcodcompta ;
	/*lnum
	*/
	private String lnum ;
	/*fmonthtout
	*/
	private String fmonthtout ;

	/*identout
	*/
	private String identout ;
	/*rnomout
	*/
	private String rnomout ;
	/*rprenomout
	*/
	private String rprenomout ;
	
	/*rnom
	*/
	private String rnom ;
	/*rprenom
	*/
	private String rprenom ;
/*choix
	*/
	private String test ;
	/*keyList3
	*/
	//private String keyList3 ;
/*keyList7
	*/
	//private String keyList7 ;
	/*ftvaout
	*/
	private String ftvaout ;
	/*keyList1
	*/
	//private String keyList1 ;
	/*keyList2
	*/
	//private String keyList2 ;
	
	/*keyList4
	*/
	//private String keyList4 ;
	/*keyList5
	
	private String keyList5 ;*/
	/*keyList6
	*/
	//private String keyList6 ;
	
	// Mail a envoyé si écart rapprochement <> 0
	private String mailToSend;

	
	private String typdpg;
	
	private String fdeppolecontrat;
	
	private String fdeppoleressource;

	/**
	 * Constructor for LigneFactureForm.
	 */
	public LigneFactureForm() {
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
	 
	public String getCav() {
		return cav;
	}*/


	/**
	 * Returns the datfact.
	 * @return String
	 */
	public String getDatfact() {
		return datfact;
	}

	/**
	 * Returns the datfactout.
	 * @return String
	 */
	public String getDatfactout() {
		return datfactout;
	}

	/**
	 * Returns the flaglock.
	 * @return String
	 */
	public String getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the flaglockout.
	 * @return String
	 */
	public String getFlaglockout() {
		return flaglockout;
	}

	/**
	 * Returns the fmontht.
	 * @return String
	 */
	public String getFmontht() {
		return fmontht;
	}

	/**
	 * Returns the fmonthtout.
	 * @return String
	 */
	public String getFmonthtout() {
		return fmonthtout;
	}

	/**
	 * Returns the ftva.
	 * @return String
	 */
	public String getFtva() {
		return ftva;
	}

	/**
	 * Returns the ftvaout.
	 * @return String
	 */
	public String getFtvaout() {
		return ftvaout;
	}

	/**
	 * Returns the ident.
	 * @return String
	 */
	public String getIdent() {
		return ident;
	}

	/**
	 * Returns the identout.
	 * @return String
	 */
	public String getIdentout() {
		return identout;
	}


	/**
	 * Returns the listeress.
	 * @return String
	 */
	public String getListeress() {
		return listeress;
	}


	/**
	 * Returns the numcontout.
	 * @return String
	 */
	public String getNumcontout() {
		return numcontout;
	}

	

	/**
	 * Returns the numfactout.
	 * @return String
	 */
	public String getNumfactout() {
		return numfactout;
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
	 * Returns the socfact.
	 * @return String
	 */
	/*public String getSocfact() {
		return socfact;
	}*/

	/**
	 * Returns the socfactout.
	 * @return String
	 */
	public String getSocfactout() {
		return socfactout;
	}

	/**
	 * Returns the soclib.
	 * @return String
	
	public String getSoclib() {
		return soclib;
	} */

	

/**
 * Returns the test.
 * @return String
 */
public String getTest() {
	return test;
}

	/**
	 * Returns the typfact.
	 * @return String
	 */
	public String getTypfact() {
		return typfact;
	}

	/**
	 * Returns the typfactout.
	 * @return String
	 */
	public String getTypfactout() {
		return typfactout;
	}

	/**
	 * Sets the cav.
	 * @param cav The cav to set
	 
	public void setCav(String cav) {
		this.cav = cav;
	}*/

	
	/**
	 * Sets the datfact.
	 * @param datfact The datfact to set
	 */
	public void setDatfact(String datfact) {
		this.datfact = datfact;
	}

	/**
	 * Sets the datfactout.
	 * @param datfactout The datfactout to set
	 */
	public void setDatfactout(String datfactout) {
		this.datfactout = datfactout;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(String flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the flaglockout.
	 * @param flaglockout The flaglockout to set
	 */
	public void setFlaglockout(String flaglockout) {
		this.flaglockout = flaglockout;
	}

	/**
	 * Sets the fmontht.
	 * @param fmontht The fmontht to set
	 */
	public void setFmontht(String fmontht) {
		this.fmontht = fmontht;
	}

	/**
	 * Sets the fmonthtout.
	 * @param fmonthtout The fmonthtout to set
	 */
	public void setFmonthtout(String fmonthtout) {
		this.fmonthtout = fmonthtout;
	}

	/**
	 * Sets the ftva.
	 * @param ftva The ftva to set
	 */
	public void setFtva(String ftva) {
		this.ftva = ftva;
	}

	/**
	 * Sets the ftvaout.
	 * @param ftvaout The ftvaout to set
	 */
	public void setFtvaout(String ftvaout) {
		this.ftvaout = ftvaout;
	}

	/**
	 * Sets the ident.
	 * @param ident The ident to set
	 */
	public void setIdent(String ident) {
		this.ident = ident;
	}

	/**
	 * Sets the identout.
	 * @param identout The identout to set
	 */
	public void setIdentout(String identout) {
		this.identout = identout;
	}

	
	/**
	 * Sets the listeress.
	 * @param listeress The listeress to set
	 */
	public void setListeress(String listeress) {
		this.listeress = listeress;
	}

	
	/**
	 * Sets the numcontout.
	 * @param numcontout The numcontout to set
	 */
	public void setNumcontout(String numcontout) {
		this.numcontout = numcontout;
	}

	/**
	 * Sets the numfact.
	 * @param numfact The numfact to set
	 */
	/*public void setNumfact(String numfact) {
		this.numfact = numfact;
	}*/

	/**
	 * Sets the numfactout.
	 * @param numfactout The numfactout to set
	 */
	public void setNumfactout(String numfactout) {
		this.numfactout = numfactout;
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
	 * Sets the socfactout.
	 * @param socfactout The socfactout to set
	 */
	public void setSocfactout(String socfactout) {
		this.socfactout = socfactout;
	}

	/**
	 * Sets the soclib.
	 * @param soclib The soclib to set
	 
	public void setSoclib(String soclib) {
		this.soclib = soclib;
	}*/

	

/**
 * Sets the test.
 * @param test The test to set
 */
public void setTest(String test) {
	this.test = test;
}

	/**
	 * Sets the typfact.
	 * @param typfact The typfact to set
	 */
	public void setTypfact(String typfact) {
		this.typfact = typfact;
	}

	/**
	 * Sets the typfactout.
	 * @param typfactout The typfactout to set
	 */
	public void setTypfactout(String typfactout) {
		this.typfactout = typfactout;
	}

	/**
	 * Returns the clelf.
	 * @return String
	 */
	public String getClelf() {
		return clelf;
	}

	/**
	 * Sets the clelf.
	 * @param clelf The clelf to set
	 */
	public void setClelf(String clelf) {
		this.clelf = clelf;
	}

	/**
	 * Returns the keyList4.
	 * @return String
	 */
	/*public String getKeyList4() {
		return keyList4;
	}*/

	/**
	 * Returns the keyList5.
	 * @return String
	
	/*public String getKeyList5() {
		return keyList5;
	} */

	/**
	 * Returns the keyList6.
	 * @return String
	 */
	/*public String getKeyList6() {
		return keyList6;
	}*/

	/**
	 * Sets the keyList4.
	 * @param keyList4 The keyList4 to set
	 */
	/*public void setKeyList4(String keyList4) {
		this.keyList4 = keyList4.trim();
	}*/

	/**
	 * Sets the keyList5.
	 * @param keyList5 The keyList5 to set
	 
	public void setKeyList5(String keyList5) {
		this.keyList5 = keyList5;
	}*/

	/**
	 * Sets the keyList6.
	 * @param keyList6 The keyList6 to set
	 */
	/*public void setKeyList6(String keyList6) {
		this.keyList6 = keyList6;
	}*/

	/**
	 * Returns the lcodcompta.
	 * @return String
	 */
	public String getLcodcompta() {
		return lcodcompta;
	}

	/**
	 * Returns the lmoisprest.
	 * @return String
	 */
	public String getLmoisprest() {
		return lmoisprest;
	}

	/**
	 * Returns the lmontht.
	 * @return String
	 */
	public String getLmontht() {
		return lmontht;
	}

	/**
	 * Returns the lnum.
	 * @return String
	 */
	public String getLnum() {
		return lnum;
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
	 * Sets the lcodcompta.
	 * @param lcodcompta The lcodcompta to set
	 */
	public void setLcodcompta(String lcodcompta) {
		this.lcodcompta = lcodcompta;
	}

	/**
	 * Sets the lmoisprest.
	 * @param lmoisprest The lmoisprest to set
	 */
	public void setLmoisprest(String lmoisprest) {
		this.lmoisprest = lmoisprest;
	}

	/**
	 * Sets the lmontht.
	 * @param lmontht The lmontht to set
	 */
	public void setLmontht(String lmontht) {
		this.lmontht = lmontht;
	}

	/**
	 * Sets the lnum.
	 * @param lnum The lnum to set
	 */
	public void setLnum(String lnum) {
		this.lnum = lnum;
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
	 * @return
	 */
	public String getMailToSend() {
		return mailToSend;
	}

	/**
	 * @param string
	 */
	public void setMailToSend(String string) {
		mailToSend = string;
	}

	public String getTypdpg() {
		return typdpg;
	}


	public void setTypdpg(String typdpg) {
		this.typdpg = typdpg;
	}


	public String getFdeppolecontrat() {
		return fdeppolecontrat;
	}


	public void setFdeppolecontrat(String fdeppolecontrat) {
		this.fdeppolecontrat = fdeppolecontrat;
	}


	public String getFdeppoleressource() {
		return fdeppoleressource;
	}


	public void setFdeppoleressource(String fdeppoleressource) {
		this.fdeppoleressource = fdeppoleressource;
	}


	public String getNum_expense() {
		return num_expense;
	}


	public void setNum_expense(String num_expense) {
		this.num_expense = num_expense;
	}

}    
