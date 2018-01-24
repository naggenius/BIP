/*
 * Créé le 22 juin 05
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.metier;

/**
 * @author x054232
 *
 * Pour changer le modèle de ce commentaire de type généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
public class InfosPersonne {
	
	private String pname;
	private String name;
	private String id;
	private String lienHref;
	private String soccode;
	

	/**
	 * 
	 */
	public InfosPersonne() {
		super();
	}

	/**
	 * 
	 */
	public InfosPersonne(String idVar, String pnameVar,String nameVar,String lienHrefCHoix, String soccodeVar) {
		this.id = idVar;
		this.name = nameVar;
		this.pname = pnameVar;
		this.lienHref = lienHrefCHoix;
		this.soccode = soccodeVar;
	}
	
	/**
	 * 
	 */
	public InfosPersonne(String idVar, String pnameVar,String nameVar,String lienHrefCHoix) {
		this.id = idVar;
		this.name = nameVar;
		this.pname = pnameVar;
		this.lienHref = lienHrefCHoix;
	}
	
	
	/**
	 * 
	 */
	public InfosPersonne(String idVar, String pnameVar,String nameVar) {
		this.id = idVar;
		this.name = nameVar;
		this.pname = pnameVar;

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
	public String getName() {
		return name;
	}

	/**
	 * @return
	 */
	public String getPname() {
		return pname;
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
	public void setName(String string) {
		name = string;
	}

	/**
	 * @param string
	 */
	public void setPname(String string) {
		pname = string;
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

	/**
	 * @return
	 */
	public String getSoccode() {
		return soccode;
	}

	/**
	 * @param string
	 */
	public void setSoccode(String string) {
		soccode = string;
	}

}
