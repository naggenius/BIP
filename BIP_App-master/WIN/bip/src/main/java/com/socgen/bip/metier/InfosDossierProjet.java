
package com.socgen.bip.metier;

public class InfosDossierProjet 
{
	private String dpLib;   //name
	private String dpCode;    // id

	private String lienHref; 

 
	/** Constructeur */
	public InfosDossierProjet() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosDossierProjet(String dpCodeVar, String dpLibVar,String lienHrefCHoix) {
		this.dpCode = dpCodeVar;
		this.dpLib = dpLibVar;
		this.lienHref = lienHrefCHoix;
	}
	
	/**
	 * 
	 */
	public InfosDossierProjet(String dpCodeVar, String dpLibVar) {
		this.dpCode = dpCodeVar;
		this.dpLib = dpLibVar;

	}

	/**
	 * @return
	 */
	public String getId() {
		return dpCode;
	}

	/**
	 * @return
	 */
	public String getName() {
		return dpLib;
	}

	/**
	 * @param string
	 */
	public void setId(String string) {
		dpCode = string;
	}

	/**
	 * @param string
	 */
	public void setName(String string) {
		dpLib = string;
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
