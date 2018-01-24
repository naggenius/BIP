package com.socgen.bip.metier;

/**
 * @author X054232 - JMA - 14/11/2005
 * 
 */
public class InfosTableRep {
	private String comlib; //name
	private String comcode; // id
	private String lienHref;

	/** Constructeur */
	public InfosTableRep() {
		super();
	}

	/**
	 * 
	 */
	public InfosTableRep(String comcodeVar, String comlibVar, String lienHrefCHoix) {
		this.comcode = comcodeVar;
		this.comlib = comlibVar;
		this.lienHref = lienHrefCHoix;
	}

	/**
	 * 
	 */
	public InfosTableRep(String comcodeVar, String comlibVar) {
		this.comcode = comcodeVar;
		this.comlib = comlibVar;
	}

	/**
	 * @return
	 */
	public String getId() {
		return comcode;
	}

	/**
	 * @return
	 */
	public String getName() {
		return comlib;
	}

	/**
	 * @param string
	 */
	public void setId(String string) {
		comcode = string;
	}

	/**
	 * @param string
	 */
	public void setName(String string) {
		comlib = string;
	}

	/**
	 * @return
	 */
	public String getLienHref() {
		return lienHref;
	}

	/**
	 * @param string
	 */
	public void setLienHref(String string) {
		lienHref = string;
	}

}

