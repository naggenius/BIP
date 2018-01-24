package com.socgen.bip.form;




/**
 * @author MMC - 25/07/2003
 *
 * Date suivi
 * chemin : Ordonnancemement / Factures / GESTIOn /Date suivi
 * pages  : fDatefactureOr.jsp 
 * pl/sql : fdatfact.sql 
 */
public class DateFactureForm extends LigneFactureForm {

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
	/*fnom
	*/
	private String fnom ;
	/*fstatut2
	*/
	private String fstatut2 ;

	/*typfact
	*/
	//private String typfact ;
	/*fmodreglt
	*/
	private String fmodreglt ;
	/*datfact
	*/
	//private String datfact ;
	/*fordrecheq
	*/
	private String fordrecheq ;
	/*fburdistr
	*/
	private String fburdistr ;
	/*cdatfin
	*/
	private String cdatfin ;  
	/*Le flaglock
	*/
	//private int flaglock ; 
	private String flaglock ; 
/*fcodepost
	*/
	private String fcodepost ;
	/*fadresse1
	*/
	private String fadresse1 ;
	/*fadresse2
	*/
	private String fadresse2 ;
	/*fadresse3
	*/
	private String fadresse3 ;

/*msg_info
	*/
	private String msg_info ;

	/* SIREN de la société
	 */
	 private String siren;
	
	/**
	 * Constructor for DateFactureForm.
	 */
	public DateFactureForm() {
		super();
	}

	/**
	 * Returns the cdatfin.
	 * @return String
	 */
	public String getCdatfin() {
		return cdatfin;
	}

	

	/**
	 * Returns the faccsec.
	 * @return String
	 */
	public String getFaccsec() {
		return faccsec;
	}

	/**
	 * Returns the fadresse1.
	 * @return String
	 */
	public String getFadresse1() {
		return fadresse1;
	}

	/**
	 * Returns the fadresse2.
	 * @return String
	 */
	public String getFadresse2() {
		return fadresse2;
	}

	/**
	 * Returns the fadresse3.
	 * @return String
	 */
	public String getFadresse3() {
		return fadresse3;
	}

/**
 * Returns the fcodepost.
 * @return String
 */
public String getFcodepost() {
	return fcodepost;
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
	 * Returns the fmodreglt.
	 * @return String
	 */
	public String getFmodreglt() {
		return fmodreglt;
	}

	/**
	 * Returns the fnom.
	 * @return String
	 */
	public String getFnom() {
		return fnom;
	}

	/**
	 * Returns the fordrecheq.
	 * @return String
	 */
	public String getFordrecheq() {
		return fordrecheq;
	}

	/**
	 * Returns the fregcompta.
	 * @return String
	 */
	public String getFregcompta() {
		return fregcompta;
	}

	/**
	 * Returns the fstatut2.
	 * @return String
	 */
	public String getFstatut2() {
		return fstatut2;
	}

/**
 * Returns the msg_info.
 * @return String
 */
public String getMsg_info() {
	return msg_info;
}

	
	

	/**
	 * Sets the cdatfin.
	 * @param cdatfin The cdatfin to set
	 */
	public void setCdatfin(String cdatfin) {
		this.cdatfin = cdatfin;
	}


	/**
	 * Sets the faccsec.
	 * @param faccsec The faccsec to set
	 */
	public void setFaccsec(String faccsec) {
		this.faccsec = faccsec;
	}

	/**
	 * Sets the fadresse1.
	 * @param fadresse1 The fadresse1 to set
	 */
	public void setFadresse1(String fadresse1) {
		this.fadresse1 = fadresse1;
	}

	/**
	 * Sets the fadresse2.
	 * @param fadresse2 The fadresse2 to set
	 */
	public void setFadresse2(String fadresse2) {
		this.fadresse2 = fadresse2;
	}

	/**
	 * Sets the fadresse3.
	 * @param fadresse3 The fadresse3 to set
	 */
	public void setFadresse3(String fadresse3) {
		this.fadresse3 = fadresse3;
	}

/**
 * Sets the fcodepost.
 * @param fcodepost The fcodepost to set
 */
public void setFcodepost(String fcodepost) {
	this.fcodepost = fcodepost;
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
	 * Sets the fmodreglt.
	 * @param fmodreglt The fmodreglt to set
	 */
	public void setFmodreglt(String fmodreglt) {
		this.fmodreglt = fmodreglt;
	}

	/**
	 * Sets the fnom.
	 * @param fnom The fnom to set
	 */
	public void setFnom(String fnom) {
		this.fnom = fnom;
	}

	/**
	 * Sets the fordrecheq.
	 * @param fordrecheq The fordrecheq to set
	 */
	public void setFordrecheq(String fordrecheq) {
		this.fordrecheq = fordrecheq;
	}

	/**
	 * Sets the fregcompta.
	 * @param fregcompta The fregcompta to set
	 */
	public void setFregcompta(String fregcompta) {
		this.fregcompta = fregcompta;
	}

	/**
	 * Sets the fstatut2.
	 * @param fstatut2 The fstatut2 to set
	 */
	public void setFstatut2(String fstatut2) {
		this.fstatut2 = fstatut2;
	}

/**
 * Sets the msg_info.
 * @param msg_info The msg_info to set
 */
public void setMsg_info(String msg_info) {
	this.msg_info = msg_info;
}

	

	

	/**
	 * Returns the fburdistr.
	 * @return String
	 */
	public String getFburdistr() {
		return fburdistr;
	}

	/**
	 * Sets the fburdistr.
	 * @param fburdistr The fburdistr to set
	 */
	public void setFburdistr(String fburdistr) {
		this.fburdistr = fburdistr;
	}

	/**
	 * Returns the flaglock.
	 * @return String
	 */
	public String getFlaglock() {
		return flaglock;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(String flaglock) {
		this.flaglock = flaglock;
	}

	public String getSiren() {
		return siren;
	}

	public void setSiren(String siren) {
		this.siren = siren;
	}

}