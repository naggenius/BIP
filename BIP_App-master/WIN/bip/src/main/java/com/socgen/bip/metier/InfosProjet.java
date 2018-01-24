/*
 * Créé le 06 Septembre 2005
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.metier;

/**
 * @author DDI le 23/09/2005
 */
public class InfosProjet 
{
	private String ilibel;   //name
	private String icpi;    // id
	private String lienHref;

	/** Constructeur */
	public InfosProjet() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosProjet(String icpiVar, String ilibelVar,String lienHrefCHoix) {
		this.icpi = icpiVar;
		this.ilibel = ilibelVar;
		this.lienHref = lienHrefCHoix;
	}
	
	/**
	 * 
	 */
	public InfosProjet(String icpiVar,String ilibelVar) {
		this.icpi = icpiVar;
		this.ilibel = ilibelVar;
	}

	/**
	 * @return
	 */
	public String getId() {
		return icpi;
	}

	/**
	 * @return
	 */
	public String getName() {
		return ilibel;
	}

	/**
	 * @param string
	 */
	public void setId(String string) {
		icpi = string;
	}

	/**
	 * @param string
	 */
	public void setName(String string) {
		ilibel = string;
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