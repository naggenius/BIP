package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author JMA - 01/03/2006
 *
 * Formulaire pour ajouter un favoris
 * pages : bFavoris.jsp
 */

public class FavorisForm extends AutomateForm {

	private String userid;
	private String menu;
	private String libelle;
	private String typFav;
	private String lienFav;


	/**
	 * @return
	 */
	public String getLibelle() {
		return libelle;
	}

	/**
	 * @return
	 */
	public String getTypFav() {
		return typFav;
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
	public void setTypFav(String string) {
		typFav = string;
	}

	/**
	 * @return
	 */
	public String getLienFav() {
		return lienFav;
	}

	/**
	 * @param string
	 */
	public void setLienFav(String string) {
		lienFav = string;
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