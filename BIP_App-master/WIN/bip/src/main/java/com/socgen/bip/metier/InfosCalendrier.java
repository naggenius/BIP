package com.socgen.bip.metier;

/**
 * @author x054232
 *
 * Pour changer le modèle de ce commentaire de type généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
public class InfosCalendrier {

	private String libMois;
	private String premens1;
	private String premens2;
	private String mensuelle;
	private String cjours;
	private String ccloture;

	private String css_libMois;
	private String css_premens1;
	private String css_premens2;
	private String css_mensuelle;
	private String css_cjours;

	public InfosCalendrier() {
		this.libMois = "";
		this.premens1 = "";
		this.premens2 = "";
		this.mensuelle = "";
		this.cjours = "";
		this.css_libMois = "";
		this.css_premens1 = "";
		this.css_premens2 = "";
		this.css_mensuelle = "";
		this.css_cjours = "";
	}

	public InfosCalendrier(
		String p_libMois,
		String p_premens1,
		String p_premens2,
		String p_mensuelle,
		String p_cjours,
		String p_ccloture) {
		this.libMois = p_libMois;
		this.premens1 = p_premens1;
		this.premens2 = p_premens2;
		this.mensuelle = p_mensuelle;
		this.cjours = p_cjours;
		this.ccloture = p_ccloture;
	}

	/**
	 * @return
	 */
	public String getCjours() {
		return cjours;
	}

	/**
	 * @return
	 */
	public String getLibMois() {
		return libMois;
	}

	/**
	 * @return
	 */
	public String getMensuelle() {
		return mensuelle;
	}

	/**
	 * @return
	 */
	public String getPremens1() {
		return premens1;
	}

	/**
	 * @return
	 */
	public String getPremens2() {
		return premens2;
	}

	/**
	 * @param string
	 */
	public void setCjours(String string) {
		cjours = string;
	}

	/**
	 * @param string
	 */
	public void setLibMois(String string) {
		libMois = string;
	}

	/**
	 * @param string
	 */
	public void setMensuelle(String string) {
		mensuelle = string;
	}

	/**
	 * @param string
	 */
	public void setPremens1(String string) {
		premens1 = string;
	}

	/**
	 * @param string
	 */
	public void setPremens2(String string) {
		premens2 = string;
	}

	/**
	 * @return
	 */
	public String getCss_cjours() {
		return css_cjours;
	}

	/**
	 * @return
	 */
	public String getCss_libMois() {
		return css_libMois;
	}

	/**
	 * @return
	 */
	public String getCss_mensuelle() {
		return css_mensuelle;
	}

	/**
	 * @return
	 */
	public String getCss_premens1() {
		return css_premens1;
	}

	/**
	 * @return
	 */
	public String getCss_premens2() {
		return css_premens2;
	}

	/**
	 * @param string
	 */
	public void setCss_cjours(String string) {
		css_cjours = string;
	}

	/**
	 * @param string
	 */
	public void setCss_libMois(String string) {
		css_libMois = string;
	}

	/**
	 * @param string
	 */
	public void setCss_mensuelle(String string) {
		css_mensuelle = string;
	}

	/**
	 * @param string
	 */
	public void setCss_premens1(String string) {
		css_premens1 = string;
	}

	/**
	 * @param string
	 */
	public void setCss_premens2(String string) {
		css_premens2 = string;
	}

	/**
	 * @return
	 */
	public String getCcloture() {
		return ccloture;
	}

	/**
	 * @param string
	 */
	public void setCcloture(String string) {
		ccloture = string;
	}

}
