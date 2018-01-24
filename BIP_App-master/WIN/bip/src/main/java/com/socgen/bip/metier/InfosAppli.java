package com.socgen.bip.metier;

/**
 * @author X054232 - JMA - 07/10/2005
 */
public class InfosAppli
{
	private String libelle;   //name
	private String code;    // id
	private String lienHref;

	/** Constructeur */
	public InfosAppli() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosAppli(String codeVar, String libelleVar,String lienHrefCHoix) {
		this.code = codeVar;
		this.libelle = libelleVar;
		this.lienHref = lienHrefCHoix;
	}
	
	/**
	 * 
	 */
	public InfosAppli(String codeVar,String libelleVar) {
		this.code = codeVar;
		this.libelle = libelleVar;
	}

	/**
	 * @return
	 */
	public String getId() {
		return code;
	}

	/**
	 * @return
	 */
	public String getName() {
		return libelle;
	}

	/**
	 * @param string
	 */
	public void setId(String string) {
		code = string;
	}

	/**
	 * @param string
	 */
	public void setName(String string) {
		libelle = string;
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
