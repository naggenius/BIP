/*
 * Cr�� le 22 juin 05
 *
 * Pour changer le mod�le de ce fichier g�n�r�, allez � :
 * Fen�tre&gt;Pr�f�rences&gt;Java&gt;G�n�ration de code&gt;Code et commentaires
 */
package com.socgen.bip.metier;

/**
 * @author x054232
 *
 * Pour changer le mod�le de ce commentaire de type g�n�r�, allez � :
 * Fen�tre&gt;Pr�f�rences&gt;Java&gt;G�n�ration de code&gt;Code et commentaires
 */
public class InfosCa {
	
	private String libelleCourt;
	private String libelleLong;
	private String id;
	private String lienHref;
	

	/**
	 * 
	 */
	public InfosCa() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosCa(String idVar, String libelleCourtVar,String libelleLongVar,String lienHrefCHoix) {
		this.id = idVar;
		this.libelleCourt = libelleCourtVar;
		this.libelleLong = libelleLongVar;
		this.lienHref = lienHrefCHoix;
	}
	
	
	/**
	 * 
	 */
	public InfosCa(String idVar, String libelleCourtVar,String libelleLongVar) {
		this.id = idVar;
		this.libelleCourt = libelleCourtVar;
		this.libelleLong = libelleLongVar;

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
	public String getLibelleCourt() {
		return libelleCourt;
	}

	/**
	 * @return
	 */
	public String getLibelleLong() {
		return libelleLong;
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
	public void setLibelleCourt(String string) {
		libelleCourt = string;
	}

	/**
	 * @param string
	 */
	public void setLibelleLong(String string) {
		libelleLong = string;
	}

	/**
	 * @param string
	 */
	public void setLienHref(String string) {
		lienHref = string;
	}

}
