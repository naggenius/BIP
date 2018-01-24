/*
 * Cr�� le 06 Septembre 2005
 *
 * Pour changer le mod�le de ce fichier g�n�r�, allez � :
 * Fen�tre&gt;Pr�f�rences&gt;Java&gt;G�n�ration de code&gt;Code et commentaires
 */
package com.socgen.bip.metier;

/**
 * @author DDI le 06/09/2005
 */
public class InfosCodcamo 
{
	private String libdsg;   //name
	private String codsg;    // id
	private String lienHref;

	/** Constructeur */
	public InfosCodcamo() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosCodcamo(String codsgVar, String libdsgVar,String lienHrefCHoix) {
		this.codsg = codsgVar;
		this.libdsg = libdsgVar;
		this.lienHref = lienHrefCHoix;
	}
	
	/**
	 * 
	 */
	public InfosCodcamo(String codsgVar,String libdsgVar) {
		this.codsg = codsgVar;
		this.libdsg = libdsgVar;
	}

	/**
	 * @return
	 */
	public String getId() {
		return codsg;
	}

	/**
	 * @return
	 */
	public String getName() {
		return libdsg;
	}

	/**
	 * @param string
	 */
	public void setId(String string) {
		codsg = string;
	}

	/**
	 * @param string
	 */
	public void setName(String string) {
		libdsg = string;
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
