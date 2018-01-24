package com.socgen.bip.metier;

/**
 * @author X058813
 *
 * represente une actualite
 * chemin : 
 * pages  : 
 * pl/sql : 
 */
public class Libelle {

	/*
	 * cle
	 */
	private String cle;
	/*
	 * libelle
	 */
	private String libelle;
	
	/*
	* champ
	*/
	private String champ;
	
	/**
	 * 
	 */
	public Libelle() {
		super();
	}

	public Libelle(String cle, String libelle, String champ)
	{
		this.cle = cle;
		this.libelle = libelle;
		this.champ = champ;
		
	}
	
	
	
	/**
	 * @return
	 */
	public String getCle() {
		return cle;
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
	public String getChamp() {
			return champ;
	}
	
	/**
	 * @param string
	 */
	public void setCle(String string) {
		cle = string;
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
	public void setChamp(String string) {
		champ = string;
	} 
	

}
