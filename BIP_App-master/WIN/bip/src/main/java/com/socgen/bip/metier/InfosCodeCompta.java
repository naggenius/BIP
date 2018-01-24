package com.socgen.bip.metier;

/**
 * @author X054232 - JMA - 03/10/2005
 * 
 */
public class InfosCodeCompta {
	private String comlib; //name
	private String comcode; // id
	private String lienHref;

	/** Constructeur */
	public InfosCodeCompta() {
		super();
	}

	/**
	 * 
	 */
	public InfosCodeCompta(String comcodeVar, String comlibVar, String lienHrefCHoix) {
		this.comcode = comcodeVar;
		this.comlib = comlibVar;
		this.lienHref = lienHrefCHoix;
	}

	/**
	 * 
	 */
	public InfosCodeCompta(String comcodeVar, String comlibVar) {
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
