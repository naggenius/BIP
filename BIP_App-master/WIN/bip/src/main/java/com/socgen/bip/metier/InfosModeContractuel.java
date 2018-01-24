package com.socgen.bip.metier;

/**
 * @author JAL le 25/04/2005
 *
 */
public class InfosModeContractuel {
	
	private String code;
	private String libelle ; 
	private String lienHref;
	
	

	/**
	 * 
	 */
	public InfosModeContractuel() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosModeContractuel(String code,String libelle, String lienHrefCHoix) {
		this.code =code;
		this.libelle = libelle ; 
		this.lienHref = lienHrefCHoix;
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

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getLibelle() {
		return libelle;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}



}
