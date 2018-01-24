package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author MMC - 14/08/2003
 *
 * Factures / Corr factures validees
 * chemin : Ordonnancemement / Factures / Gestion /corr fact valid
 * pages  : fFactValideeOr.jsp 
 * pl/sql : facsegl.sql 
 */
public class FactValideeForm extends AutomateForm {

/*socfact
	*/
	private String socfact ;
	/*fmontttc
	*/
	private String fmontttc ;
	/*msg_info
	*/
	private String msg_info ;
	/*fdeppole
	*/
	private String fdeppole ;
	
/*faccsec
	*/
	private String faccsec ;
	/*fnumasn
	*/
	private String fnumasn ;
	/*soclib
	*/
	private String soclib ;
	/*fsocfour
	*/
	private String fsocfour ;
	/*socflib
	*/
	private String socflib ;
	/*llibanalyt
	*/
	private String llibanalyt ;
	/*fprovsdff1
	*/
	private String fprovsdff1 ;
	/*f
	*/
	private String fprovsegl2 ;
	/*fprovsdff1
	*/
	private String fprovsegl1 ;
	/*fprovsdff2
	*/
	private String fprovsdff2 ;
	/*numfact
	*/
	private String numfact ;
	/*fenvsec
	*/
	private String fenvsec ;
	/*cav
	*/
	private String cav ;
	
	/*socfactout
	*/
	private String socfactout ;

	/*soclibout
	*/
	private String soclibout ;
	/*numfactout
	*/
	private String numfactout ;
	/*cavout
	*/
	private String cavout ;
	/*numcont
	*/
	private String numcont;
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
	/*fstatut1
	*/
	private String fstatut1 ;
	/*fstatut2
	*/
	private String fstatut2 ;

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
	private String keyList3 ;
	/*keyList7
	*/
	private String keyList7 ;
	/*ftvaout
	*/
	private String ftvaout ;
	/*fregcompta
	*/
	private String fregcompta ;
	/*fmodreglt
	*/
	private String fmodreglt ;
	/*fmoiacompta
	*/
	private String fmoiacompta ;
	/* clelf
	 */
	private String clelf;
	/*keyList1
	*/
	private String keyList1 ;
	/*keyList2
	*/
	private String keyList2 ;
	/*keyList0
	*/
	private String keyList0 ;
	/*keyList4
	*/
	private String keyList4 ;
	/*keyList5
	*/
	private String keyList5 ;
	/*keyList6
	*/
	private String keyList6 ;
	
	/**
	 * Constructor for FactValideeForm.
	 */
	public FactValideeForm() {
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
	 * Returns the cavout.
	 * @return String
	 */
	public String getCavout() {
		return cavout;
	}

	

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
	 * Returns the lcodcompta.
	 * @return String
	 */
	public String getLcodcompta() {
		return lcodcompta;
	}

	/**
	 * Returns the listeress.
	 * @return String
	 */
	public String getListeress() {
		return listeress;
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
	 * Returns the numcont.
	 * @return String
	 */
	public String getNumcont() {
		return numcont;
	}

	/**
	 * Returns the numcontout.
	 * @return String
	 */
	public String getNumcontout() {
		return numcontout;
	}

	/**
	 * Returns the numfact.
	 * @return String
	 */
	public String getNumfact() {
		return numfact;
	}

	/**
	 * Returns the numfactout.
	 * @return String
	 */
	public String getNumfactout() {
		return numfactout;
	}

	/**
	 * Returns the rnom.
	 * @return String
	 */
	public String getRnom() {
		return rnom;
	}

	/**
	 * Returns the rnomout.
	 * @return String
	 */
	public String getRnomout() {
		return rnomout;
	}

	/**
	 * Returns the rprenom.
	 * @return String
	 */
	public String getRprenom() {
		return rprenom;
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
public String getSocfact() {
	return socfact;
}

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
	 */
	public String getSoclib() {
		return soclib;
	}

	/**
	 * Returns the soclibout.
	 * @return String
	 */
	public String getSoclibout() {
		return soclibout;
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
	 * Returns the typfactout.
	 * @return String
	 */
	public String getTypfactout() {
		return typfactout;
	}

	/**
	 * Sets the cav.
	 * @param cav The cav to set
	 */
	public void setCav(String cav) {
		this.cav = cav;
	}

	/**
	 * Sets the cavout.
	 * @param cavout The cavout to set
	 */
	public void setCavout(String cavout) {
		this.cavout = cavout;
	}

	

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
		this.keyList4 = keyList4;
	}

	/**
	 * Sets the keyList5.
	 * @param keyList5 The keyList5 to set
	 */
	public void setKeyList5(String keyList5) {
		this.keyList5 = keyList5;
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
	 * Sets the lcodcompta.
	 * @param lcodcompta The lcodcompta to set
	 */
	public void setLcodcompta(String lcodcompta) {
		this.lcodcompta = lcodcompta;
	}

	/**
	 * Sets the listeress.
	 * @param listeress The listeress to set
	 */
	public void setListeress(String listeress) {
		this.listeress = listeress;
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
	 * Sets the numcont.
	 * @param numcont The numcont to set
	 */
	public void setNumcont(String numcont) {
		this.numcont = numcont.trim();
	}

	/**
	 * Sets the numcontout.
	 * @param numcontout The numcontout to set
	 */
	public void setNumcontout(String numcontout) {
		this.numcontout = numcontout.trim();
	}

	/**
	 * Sets the numfact.
	 * @param numfact The numfact to set
	 */
	public void setNumfact(String numfact) {
		this.numfact = numfact.trim();
	}

	/**
	 * Sets the numfactout.
	 * @param numfactout The numfactout to set
	 */
	public void setNumfactout(String numfactout) {
		this.numfactout = numfactout.trim();
	}

	/**
	 * Sets the rnom.
	 * @param rnom The rnom to set
	 */
	public void setRnom(String rnom) {
		this.rnom = rnom;
	}

	/**
	 * Sets the rnomout.
	 * @param rnomout The rnomout to set
	 */
	public void setRnomout(String rnomout) {
		this.rnomout = rnomout;
	}

	/**
	 * Sets the rprenom.
	 * @param rprenom The rprenom to set
	 */
	public void setRprenom(String rprenom) {
		this.rprenom = rprenom;
	}

	/**
	 * Sets the rprenomout.
	 * @param rprenomout The rprenomout to set
	 */
	public void setRprenomout(String rprenomout) {
		this.rprenomout = rprenomout;
	}

/**
 * Sets the socfact.
 * @param socfact The socfact to set
 */
public void setSocfact(String socfact) {
	this.socfact = socfact;
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
	 */
	public void setSoclib(String soclib) {
		this.soclib = soclib;
	}

	/**
	 * Sets the soclibout.
	 * @param soclibout The soclibout to set
	 */
	public void setSoclibout(String soclibout) {
		this.soclibout = soclibout;
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
	 * Sets the typfactout.
	 * @param typfactout The typfactout to set
	 */
	public void setTypfactout(String typfactout) {
		this.typfactout = typfactout;
	}

	/**
	 * Returns the fmontttc.
	 * @return String
	 */
	public String getFmontttc() {
		return fmontttc;
	}

	/**
	 * Returns the msg_info.
	 * @return String
	 */
	public String getMsg_info() {
		return msg_info;
	}

	/**
	 * Sets the msg_info.
	 * @param msg_info The msg_info to set
	 */
	public void setMsg_info(String msg_info) {
		this.msg_info = msg_info;
	}

	/**
	 * Returns the faccsec.
	 * @return String
	 */
	public String getFaccsec() {
		return faccsec;
	}

	/**
	 * Returns the fmoiacompta.
	 * @return String
	 */
	public String getFmoiacompta() {
		return fmoiacompta;
	}

	/**
	 * Returns the fnumasn.
	 * @return String
	 */
	public String getFnumasn() {
		return fnumasn;
	}

	/**
	 * Returns the fregcompta.
	 * @return String
	 */
	public String getFregcompta() {
		return fregcompta;
	}

	/**
	 * Sets the fmoiacompta.
	 * @param fmoiacompta The fmoiacompta to set
	 */
	public void setFmoiacompta(String fmoiacompta) {
		this.fmoiacompta = fmoiacompta;
	}

	/**
	 * Returns the fenvsec.
	 * @return String
	 */
	public String getFenvsec() {
		return fenvsec;
	}

	/**
	 * Returns the fprovsdff1.
	 * @return String
	 */
	public String getFprovsdff1() {
		return fprovsdff1;
	}

	/**
	 * Returns the fprovsdff2.
	 * @return String
	 */
	public String getFprovsdff2() {
		return fprovsdff2;
	}

	/**
	 * Returns the fprovsegl1.
	 * @return String
	 */
	public String getFprovsegl1() {
		return fprovsegl1;
	}

	/**
	 * Returns the fprovsegl2.
	 * @return String
	 */
	public String getFprovsegl2() {
		return fprovsegl2;
	}

	/**
	 * Returns the fsocfour.
	 * @return String
	 */
	public String getFsocfour() {
		return fsocfour;
	}

	/**
	 * Returns the llibanalyt.
	 * @return String
	 */
	public String getLlibanalyt() {
		return llibanalyt;
	}

	/**
	 * Returns the fmodreglt.
	 * @return String
	 */
	public String getFmodreglt() {
		return fmodreglt;
	}

	/**
	 * Returns the fstatut1.
	 * @return String
	 */
	public String getFstatut1() {
		return fstatut1;
	}

	/**
	 * Returns the fstatut2.
	 * @return String
	 */
	public String getFstatut2() {
		return fstatut2;
	}

	/**
	 * Sets the faccsec.
	 * @param faccsec The faccsec to set
	 */
	public void setFaccsec(String faccsec) {
		this.faccsec = faccsec;
	}

	/**
	 * Sets the fenvsec.
	 * @param fenvsec The fenvsec to set
	 */
	public void setFenvsec(String fenvsec) {
		this.fenvsec = fenvsec;
	}

	/**
	 * Sets the fmodreglt.
	 * @param fmodreglt The fmodreglt to set
	 */
	public void setFmodreglt(String fmodreglt) {
		this.fmodreglt = fmodreglt;
	}

	/**
	 * Sets the fmontttc.
	 * @param fmontttc The fmontttc to set
	 */
	public void setFmontttc(String fmontttc) {
		this.fmontttc = fmontttc;
	}

	/**
	 * Sets the fnumasn.
	 * @param fnumasn The fnumasn to set
	 */
	public void setFnumasn(String fnumasn) {
		this.fnumasn = fnumasn;
	}

	/**
	 * Sets the fprovsdff1.
	 * @param fprovsdff1 The fprovsdff1 to set
	 */
	public void setFprovsdff1(String fprovsdff1) {
		this.fprovsdff1 = fprovsdff1;
	}

	/**
	 * Sets the fprovsdff2.
	 * @param fprovsdff2 The fprovsdff2 to set
	 */
	public void setFprovsdff2(String fprovsdff2) {
		this.fprovsdff2 = fprovsdff2;
	}

	/**
	 * Sets the fprovsegl1.
	 * @param fprovsegl1 The fprovsegl1 to set
	 */
	public void setFprovsegl1(String fprovsegl1) {
		this.fprovsegl1 = fprovsegl1;
	}

	/**
	 * Sets the fprovsegl2.
	 * @param fprovsegl2 The fprovsegl2 to set
	 */
	public void setFprovsegl2(String fprovsegl2) {
		this.fprovsegl2 = fprovsegl2;
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
	 * Sets the fstatut2.
	 * @param fstatut2 The fstatut2 to set
	 */
	public void setFstatut2(String fstatut2) {
		this.fstatut2 = fstatut2;
	}

	/**
	 * Sets the llibanalyt.
	 * @param llibanalyt The llibanalyt to set
	 */
	public void setLlibanalyt(String llibanalyt) {
		this.llibanalyt = llibanalyt;
	}

	/**
	 * Returns the socflib.
	 * @return String
	 */
	public String getSocflib() {
		return socflib;
	}

	/**
	 * Sets the socflib.
	 * @param socflib The socflib to set
	 */
	public void setSocflib(String socflib) {
		this.socflib = socflib;
	}

	/**
	 * Returns the fdeppole.
	 * @return String
	 */
	public String getFdeppole() {
		return fdeppole;
	}

	/**
	 * Sets the fdeppole.
	 * @param fdeppole The fdeppole to set
	 */
	public void setFdeppole(String fdeppole) {
		this.fdeppole = fdeppole;
	}

	/**
	 * @return
	 */
	public String getClelf() {
		return clelf;
	}

	/**
	 * @param string
	 */
	public void setClelf(String string) {
		clelf = string;
	}

}
	