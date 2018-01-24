package com.socgen.bip.metier;

/**
 * @author JAL le 25/04/2005
 *
 */
public class InfosDpCopi {
	
	private String dp_copi;
	private String libelle ; 
	private String lienHref;
	
	

	/**
	 * 
	 */
	public InfosDpCopi() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosDpCopi(String p_dpcopi,String p_libelle, String lienHrefCHoix) {
		this.dp_copi =p_dpcopi;
		this.libelle = p_libelle ; 
		this.lienHref = lienHrefCHoix;
	}
 

	 

	public String getLibelle() {
		return this.libelle;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	/**
	 * @return
	 */
	public String getLienHref() {
		return this.lienHref;
	}
 
	/**
	 * @param string
	 */
	public void setLienHref(String string) {
		lienHref = string;
	}

	public String getDp_copi() {
		return dp_copi;
	}

	public void setDp_copi(String dp_copi) {
		this.dp_copi = dp_copi;
	}

	 

}
