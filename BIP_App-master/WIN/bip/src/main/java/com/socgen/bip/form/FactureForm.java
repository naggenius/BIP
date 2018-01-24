package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author MMC - 31/07/2003
 *
 * Facture
 * chemin : Ordonnancemement / Factures / GESTIOn /Facture
 * pages  : bFactureOr.jsp 
 * pl/sql : facture.sql 
 */
public class FactureForm extends AutomateForm {

	/*socfact
	*/
	private String socfact ;
	
	private String siren;

	/*soclib
	*/
	private String soclib ;
	
	/*numfact
	*/
	private String numfact ;

	/*typfact
	*/
	private String typfact ;
	/*datfact
	*/
	private String datfact ;

	/*comcode
	*/
	private String comcode ;
	/*codsg
	*/
	private String codsg ;
	/*datrecp
	*/
	private String datrecp ;
	/*fmoiacompta
	*/
	private String fmoiacompta ;
	/*keyList0
	*/
	private String keyList0 ;
	/*keyList0
	*/
	private String keyList1 ;
	/*keyList0
	*/
	private String keyList2 ;
	/*keyList0
	*/
	private String keyList3 ;
	/*keyList0
	*/
	private String keyList4 ;
	/*keyList0
	*/
	private String keyList5 ;
	/*keyList0
	*/
	private String keyList6 ;
	/*keyList0
	*/
	private String keyList7 ;
	/*fstatut1
	*/
	private String fstatut1 ;
	/*fmontht
	*/
	private String fmontht ;
	/*Le flaglock
	*/
	private String flaglock ;
	//private int flaglock ; 
	/*soccont
	*/
	private String soccont ;
	/*numcont
	*/
	private String numcont ;

	/*cav
	*/
	private String cav ;

	/*fenrcompta
	*/
	private String fenrcompta ;
	/*faccsec
	*/
	private String faccsec ;
	/*fregcompta
	*/
	private String fregcompta ;
	
	/*fenvsec
	*/
	private String fenvsec ;
	/*fsocfour
	*/
	private String fsocfour ;
	/*date_reception
	*/
	private String date_reception ;
	/*fcodcompta
	*/
	private String fcodcompta ;
	/*fdeppole
	*/
	private String fdeppole ;
	/*ftvaout
	*/
	private String ftvaout ;
	/*ftva
	*/
	private String ftva ;
	/*clelc
	*/
	private String clelc ;
	
	/*rnom
	*/
	private String rnom ;
	
	
	/*choixfsc
	*/
	private String choixfsc ;
	
	/*msg_info
	*/
	private String msg_info ;
	
	/*test
	*/
	private String test ;
	
	/* Numéro Expense
	*/
	private String numexpense ;

	/* Cusag Expense
	*/
	private String cusagexpense ;
	
	/**
	 * Constructor for FactureForm.
	 */
	public FactureForm() {
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
	 * Returns the choixfsc.
	 * @return String
	 */
	public String getChoixfsc() {
		return choixfsc;
	}

	/**
	 * Returns the clelc.
	 * @return String
	 */
	public String getClelc() {
		return clelc;
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
	 * Returns the date_reception.
	 * @return String
	 */
	public String getDate_reception() {
		return date_reception;
	}

	/**
	 * Returns the datfact.
	 * @return String
	 */
	public String getDatfact() {
		return datfact;
	}

	/**
	 * Returns the datrecp.
	 * @return String
	 */
	public String getDatrecp() {
		return datrecp;
	}

	/**
	 * Returns the faccsec.
	 * @return String
	 */
	public String getFaccsec() {
		return faccsec;
	}

	/**
	 * Returns the fcodcompta.
	 * @return String
	 */
	public String getFcodcompta() {
		return fcodcompta;
	}

	/**
	 * Returns the fdeppole.
	 * @return String
	 */
	public String getFdeppole() {
		return fdeppole;
	}

	/**
	 * Returns the fenrcompta.
	 * @return String
	 */
	public String getFenrcompta() {
		return fenrcompta;
	}

	/**
	 * Returns the fenvsec.
	 * @return String
	 */
	public String getFenvsec() {
		return fenvsec;
	}

	/**
	 * Returns the flaglock.
	 * @return String
	 */
	public String getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the fmoiacompta.
	 * @return String
	 */
	public String getFmoiacompta() {
		return fmoiacompta;
	}

	/**
	 * Returns the fmontht.
	 * @return String
	 */
	public String getFmontht() {
		return fmontht;
	}

	/**
	 * Returns the fregcompta.
	 * @return String
	 */
	public String getFregcompta() {
		return fregcompta;
	}

	/**
	 * Returns the fsocfour.
	 * @return String
	 */
	public String getFsocfour() {
		return fsocfour;
	}

	/**
	 * Returns the fstatut1.
	 * @return String
	 */
	public String getFstatut1() {
		return fstatut1;
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
	 * Returns the keyList3.
	 * @return String
	 */
	public String getKeyList3() {
		return keyList3;
	}

	/**
	 * Returns the keyList4.
	 * @return String
	 */
	public String getKeyList4() {
		return keyList4;
	}

	/**
	 * Returns the keyList5.
	 * @return String
	 */
	public String getKeyList5() {
		return keyList5;
	}

	/**
	 * Returns the keyList6.
	 * @return String
	 */
	public String getKeyList6() {
		return keyList6;
	}

	/**
	 * Returns the keyList7.
	 * @return String
	 */
	public String getKeyList7() {
		return keyList7;
	}

	/**
	 * Returns the msg_info.
	 * @return String
	 */
	public String getMsg_info() {
		return msg_info;
	}

	/**
	 * Returns the numcont.
	 * @return String
	 */
	public String getNumcont() {
		return numcont;
	}

	/**
	 * Returns the numfact.
	 * @return String
	 */
	public String getNumfact() {
		return numfact;
	}

	/**
	 * Returns the rnom.
	 * @return String
	 */
	public String getRnom() {
		return rnom;
	}

	/**
	 * Returns the soccont.
	 * @return String
	 */
	public String getSoccont() {
		return soccont;
	}

	/**
	 * Returns the socfact.
	 * @return String
	 */
	public String getSocfact() {
		return socfact;
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
	 * Returns the typfact.
	 * @return String
	 */
	public String getTypfact() {
		return typfact;
	}
	
	/**
	 * Returns the num_expensetypfact.
	 * @return String
	 */
	public String getNumexpense() {
		return numexpense;
	}

	/**
	 * Sets the cav.
	 * @param cav The cav to set
	 */
	public void setCav(String cav) {
		this.cav = cav;
	}

	/**
	 * Sets the choixfsc.
	 * @param choixfsc The choixfsc to set
	 */
	public void setChoixfsc(String choixfsc) {
		this.choixfsc = choixfsc;
	}

	/**
	 * Sets the clelc.
	 * @param clelc The clelc to set
	 */
	public void setClelc(String clelc) {
		this.clelc = clelc;
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
	 * Sets the date_reception.
	 * @param date_reception The date_reception to set
	 */
	public void setDate_reception(String date_reception) {
		this.date_reception = date_reception;
	}

	/**
	 * Sets the datfact.
	 * @param datfact The datfact to set
	 */
	public void setDatfact(String datfact) {
		this.datfact = datfact;
	}

	/**
	 * Sets the datrecp.
	 * @param datrecp The datrecp to set
	 */
	public void setDatrecp(String datrecp) {
		this.datrecp = datrecp;
	}

	/**
	 * Sets the faccsec.
	 * @param faccsec The faccsec to set
	 */
	public void setFaccsec(String faccsec) {
		this.faccsec = faccsec;
	}

	/**
	 * Sets the fcodcompta.
	 * @param fcodcompta The fcodcompta to set
	 */
	public void setFcodcompta(String fcodcompta) {
		this.fcodcompta = fcodcompta;
	}

	/**
	 * Sets the fdeppole.
	 * @param fdeppole The fdeppole to set
	 */
	public void setFdeppole(String fdeppole) {
		this.fdeppole = fdeppole;
	}

	/**
	 * Sets the fenrcompta.
	 * @param fenrcompta The fenrcompta to set
	 */
	public void setFenrcompta(String fenrcompta) {
		this.fenrcompta = fenrcompta;
	}

	/**
	 * Sets the fenvsec.
	 * @param fenvsec The fenvsec to set
	 */
	public void setFenvsec(String fenvsec) {
		this.fenvsec = fenvsec;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(String flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the fmoiacompta.
	 * @param fmoiacompta The fmoiacompta to set
	 */
	public void setFmoiacompta(String fmoiacompta) {
		this.fmoiacompta = fmoiacompta;
	}

	/**
	 * Sets the fmontht.
	 * @param fmontht The fmontht to set
	 */
	public void setFmontht(String fmontht) {
		this.fmontht = fmontht;
	}

	/**
	 * Sets the fregcompta.
	 * @param fregcompta The fregcompta to set
	 */
	public void setFregcompta(String fregcompta) {
		this.fregcompta = fregcompta;
	}

	/**
	 * Sets the fsocfour.
	 * @param fsocfour The fsocfour to set
	 */
	public void setFsocfour(String fsocfour) {
		this.fsocfour = fsocfour;
	}

	/**
	 * Sets the fstatut1.
	 * @param fstatut1 The fstatut1 to set
	 */
	public void setFstatut1(String fstatut1) {
		this.fstatut1 = fstatut1;
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
	 * Sets the keyList3.
	 * @param keyList3 The keyList3 to set
	 */
	public void setKeyList3(String keyList3) {
		this.keyList3 = keyList3;
	}

	/**
	 * Sets the keyList4.
	 * @param keyList4 The keyList4 to set
	 */
	public void setKeyList4(String keyList4) {
		this.keyList4 = keyList4.trim();
	}

	/**
	 * Sets the keyList5.
	 * @param keyList5 The keyList5 to set
	 */
	public void setKeyList5(String keyList5) {
		this.keyList5 = keyList5.trim();
	}

	/**
	 * Sets the keyList6.
	 * @param keyList6 The keyList6 to set
	 */
	public void setKeyList6(String keyList6) {
		this.keyList6 = keyList6;
	}

	/**
	 * Sets the keyList7.
	 * @param keyList7 The keyList7 to set
	 */
	public void setKeyList7(String keyList7) {
		this.keyList7 = keyList7;
	}

	/**
	 * Sets the msg_info.
	 * @param msg_info The msg_info to set
	 */
	public void setMsg_info(String msg_info) {
		this.msg_info = msg_info;
	}

	/**
	 * Sets the numcont.
	 * @param numcont The numcont to set
	 */
	public void setNumcont(String numcont) {
		if (numcont!=null) {
			this.numcont = numcont.trim();
		}
		else 
			this.numcont = numcont;
	}

	/**
	 * Sets the numfact.
	 * @param numfact The numfact to set
	 */
	public void setNumfact(String numfact) {
		this.numfact = numfact.trim();
	}

	/**
	 * Sets the rnom.
	 * @param rnom The rnom to set
	 */
	public void setRnom(String rnom) {
		this.rnom = rnom;
	}

	/**
	 * Sets the soccont.
	 * @param soccont The soccont to set
	 */
	public void setSoccont(String soccont) {
		this.soccont = soccont;
	}

	/**
	 * Sets the socfact.
	 * @param socfact The socfact to set
	 */
	public void setSocfact(String socfact) {
		this.socfact = socfact;
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
	 * Sets the typfact.
	 * @param typfact The typfact to set
	 */
	public void setTypfact(String typfact) {
		this.typfact = typfact;
	}
	
	/**
	 * Sets the cav.
	 * @param cav The cav to set
	 */
	public void setNum_expense(String numexpense) {
		this.numexpense = numexpense;
	}

	/**
	 * Sets the cav.
	 * @param cav The cav to set
	 */
	public void setNumexpense(String numexpense) {
		this.numexpense = numexpense;
	}
	
	public String getCusagexpense() {
		return cusagexpense;
	}

	public void setCusagexpense(String cusagexpense) {
		this.cusagexpense = cusagexpense;
	}

	public String getSiren() {
		return siren;
	}

	public void setSiren(String siren) {
		this.siren = siren;
	}	

	
}