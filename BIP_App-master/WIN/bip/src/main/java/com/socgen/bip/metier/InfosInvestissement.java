
package com.socgen.bip.metier;

public class InfosInvestissement 
{
	private String libType;   //name
	private String codeType;    // id

	private String lienHref; 

 
	/** Constructeur */
	public InfosInvestissement() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosInvestissement(String codeTypeVar, String libTypeVar,String lienHrefCHoix) {
		this.codeType = codeTypeVar;
		this.libType = libTypeVar;
		this.lienHref = lienHrefCHoix;
	}
	
	/**
	 * 
	 */
	public InfosInvestissement(String codeTypeVar, String libTypeVar) {
		this.codeType = codeTypeVar;
		this.libType = libTypeVar;

	}

	/**
	 * @return
	 */
	public String getId() {
		return codeType;
	}

	/**
	 * @return
	 */
	public String getName() {
		return libType;
	}

	/**
	 * @param string
	 */
	public void setId(String string) {
		codeType = string;
	}

	/**
	 * @param string
	 */
	public void setName(String string) {
		libType = string;
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
