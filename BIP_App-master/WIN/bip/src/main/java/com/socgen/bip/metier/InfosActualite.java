package com.socgen.bip.metier;

/**
 * @author X054232 - JMA - 07/10/2005
 */
public class InfosActualite
{

	private String code_actu;
	private String	titre ;
	private String	texte;
	private String	date_affiche ;
	private String	URL     ;
	private String	date_tri;
	/** Constructeur */
	public InfosActualite() {
		super();
	}
	
	/**
	 * 
	 */
	public InfosActualite(String code_actu, String titre,String texte, String date_affiche,String URL, String date_tri) {
		this.code_actu = code_actu;
		this.titre = titre;
		this.texte = texte;
		this.date_affiche = date_affiche;
		this.URL = URL;
		this.date_tri = date_tri;
	}

	public String getCode_actu() {
		return code_actu;
	}

	public void setCode_actu(String code_actu) {
		this.code_actu = code_actu;
	}

	public String getDate_affiche() {
		return date_affiche;
	}

	public void setDate_affiche(String date_affiche) {
		this.date_affiche = date_affiche;
	}

	public String getDate_tri() {
		return date_tri;
	}

	public void setDate_tri(String date_tri) {
		this.date_tri = date_tri;
	}

	public String getTexte() {
		return texte;
	}

	public void setTexte(String texte) {
		this.texte = texte;
	}

	public String getTitre() {
		return titre;
	}

	public void setTitre(String titre) {
		this.titre = titre;
	}

	public String getURL() {
		return URL;
	}

	public void setURL(String url) {
		URL = url;
	}
	
	
}
