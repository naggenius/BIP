package com.socgen.bip.metier;

/**
 * @author BAA le 19/09/2005
 *
 */
public class InfosMo {
	
	private String sigle;
	private String libelle;
	private String id;
	private String lienHref;
	

	/**
	 * 
	 */
	public InfosMo() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosMo(String idVar, String sigle,String libelle,String lienHrefCHoix) {
		this.id = idVar;
		this.sigle = sigle;
		this.libelle = libelle;
		this.lienHref = lienHrefCHoix;
	}
	
	
	/**
	 * 
	 */
	public InfosMo(String idVar, String sigle,String libelle) {
		this.id = idVar;
		this.sigle = sigle;
		this.libelle = libelle;

	}

	/**
	 * @return
	 */
	public String getId() {
		return id;
	}

	/**
	 * @return
	 */
	public String getSigle() {
		return sigle;
	}

	/**
	 * @return
	 */
	public String getLibelle() {
		return libelle;
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
	public void setId(String string) {
		id = string;
	}

	/**
	 * @param string
	 */
	public void setSigle(String string) {
		sigle = string;
	}

	/**
	 * @param string
	 */
	public void setLibelle(String string) {
		libelle = string;
	}

	/**
	 * @param string
	 */
	public void setLienHref(String string) {
		lienHref = string;
	}

}
