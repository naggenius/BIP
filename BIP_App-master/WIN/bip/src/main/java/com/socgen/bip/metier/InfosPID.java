package com.socgen.bip.metier;

/**
 * @author BAA le 04/10/2005
 *
 */
public class InfosPID {
	
	private String pid;
	private String libelle;
	private String lienHref;
	

	/**
	 * 
	 */
	public InfosPID() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosPID(String pid, String libelle,String lienHrefCHoix) {
		this.pid = pid;
		this.libelle = libelle;
		this.lienHref = lienHrefCHoix;
	}
	
	
	

	/**
	 * @return
	 */
	public String getPid() {
		return pid;
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
	public void setPid(String string) {
		pid = string;
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
