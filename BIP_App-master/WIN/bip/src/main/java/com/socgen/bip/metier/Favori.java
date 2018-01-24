package com.socgen.bip.metier;

import java.net.URLDecoder;

/**
 * @author x054232
 *
 * Pour changer le modèle de ce commentaire de type généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
public class Favori {

	private String userid;
	private String lien;
	private String libelle;
	private int ordre;
	private String type;
	private String menu;

	public Favori() {
		this.userid = "";
		this.lien = "";
		this.libelle = "";
		this.ordre = 0;
		this.type = "";
	}

	public Favori(
		String p_userid,
		String p_type,
		int p_ordre,
		String p_libelle,
		String p_lien,
		String p_menu) {
		this.userid = p_userid;
		this.type = p_type;
		this.ordre = p_ordre;
		this.libelle = p_libelle;
		this.lien = p_lien;
		this.menu = p_menu;
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
	public String getLien() {
		return replace(URLDecoder.decode(lien), "&amp;", "a");
	}
	
	private String replace(String str, String pattern, String replace) {
		int s = 0;
		int e = 0;
		StringBuffer result = new StringBuffer();
    
		while ((e = str.indexOf(pattern, s)) >= 0) {
			result.append(str.substring(s, e));
			result.append(replace);
			s = e+pattern.length();
		}
		result.append(str.substring(s));
		return result.toString();
	}



	/**
	 * @return
	 */
	public int getOrdre() {
		return ordre;
	}

	/**
	 * @return
	 */
	public String getType() {
		return type;
	}

	/**
	 * @return
	 */
	public String getUserid() {
		return userid;
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
	public void setLien(String string) {
		lien = string;
	}

	/**
	 * @param i
	 */
	public void setOrdre(int i) {
		ordre = i;
	}

	/**
	 * @param string
	 */
	public void setType(String string) {
		type = string;
	}

	/**
	 * @param string
	 */
	public void setUserid(String string) {
		userid = string;
	}

	/**
	 * @return
	 */
	public String getMenu() {
		return menu;
	}

	/**
	 * @param string
	 */
	public void setMenu(String string) {
		menu = string;
	}

}
