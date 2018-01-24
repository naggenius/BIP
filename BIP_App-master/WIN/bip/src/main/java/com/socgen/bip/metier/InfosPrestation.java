package com.socgen.bip.metier;

/**
 * @author X054232 - JMA - 03/10/2005
 */
public class InfosPrestation 
{
	private String libpresta;   //name
	private String codepresta;    // id
	private String lienHref;

	/** Constructeur */
	public InfosPrestation() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosPrestation(String codeprestaVar, String libprestaVar,String lienHrefCHoix) {
		this.codepresta = codeprestaVar;
		this.libpresta = libprestaVar;
		this.lienHref = lienHrefCHoix;
	}
	
	/**
	 * 
	 */
	public InfosPrestation(String codeprestaVar,String libprestaVar) {
		this.codepresta = codeprestaVar;
		this.libpresta = libprestaVar;
	}

	/**
	 * @return
	 */
	public String getId() {
		return codepresta;
	}

	/**
	 * @return
	 */
	public String getName() {
		return libpresta;
	}

	/**
	 * @param string
	 */
	public void setId(String string) {
		codepresta = string;
	}

	/**
	 * @param string
	 */
	public void setName(String string) {
		libpresta = string;
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