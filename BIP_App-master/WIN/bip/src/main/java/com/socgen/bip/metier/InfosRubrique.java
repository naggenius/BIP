/*
 * Créé le 22 juin 05
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.metier;

/**
 * @author BAA
 *
 * Pour changer le modèle de ce commentaire de type généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
public class InfosRubrique {
	
	private String id;
	private String libelle;
	private String cafi;
	private String libcafi;
	private String lienHref;
	

	/**
	 * 
	 */
	public InfosRubrique() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosRubrique(String idVar, String libelleVar,String cafiVar, String libellecafiVar, String lienHrefCHoix) {
		this.id = idVar;
		this.libelle = libelleVar;
		this.cafi = cafiVar;
		this.libcafi = libellecafiVar;
		this.lienHref = lienHrefCHoix;
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
	public String getLibelle() {
		return libelle;
	}

	/**
	* @return
	*/
	public String getCafi() {
		return cafi;
	}

	/**
	 * @return
	 */
	public String getLibcafi() {
		return libcafi;
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
	public void setLibelle(String string) {
		libelle = string;
	}

	/**
	* @param string
	*/
   public void setCafi(String string) {
			cafi = string;
	}

	/**
	 * @param string
	 */
	public void setLibcafi(String string) {
		libcafi = string;
	}

	/**
	 * @param string
	 */
	public void setLienHref(String string) {
		lienHref = string;
	}

}
