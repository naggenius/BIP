/*
 * Créé le 22 juin 05
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 * Modifié le 12/09/2005 par DDI (Ajout adresse complète + date de fermeture société).
 */
package com.socgen.bip.metier;

/**
 * @author x054232
 *
 * Pour changer le modèle de ce commentaire de type généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 * 
 * JAL 12/09/2008 : rajout Groupe Société
 *  
 */
public class InfosSociete {
	
	private String libelle;
	private String adress;	
	private String id;
	private String lienHref;
	private String adress2;
	private String datfer;		
	private String siren;
	private String socGroupe ; //Groupe Société
	
	public String getSiren() {
		return siren;
	}

	public void setSiren(String siren) {
		this.siren = siren;
	}

	/**
	 * 
	 */
	public InfosSociete() {
		super();

	}
	
	/**
	 * 
	 */
	public InfosSociete(String p_id, String p_libelle, String p_siren,String p_adress,String p_adress2,String p_datfer, String lienHrefCHoix) 
	{
		this.id = p_id;
		this.libelle = p_libelle;
		this.siren = p_siren;
		this.adress = p_adress;
		this.adress2 = p_adress2;
		this.datfer = p_datfer;
		this.lienHref = lienHrefCHoix;
	}
	
	
	/**
	 * 
	 */
	public InfosSociete(String p_id, String p_libelle, String p_siren,String p_adress,String p_adress2,String p_datfer, String lienHrefCHoix, String p_socGroupe) 
	{
		this.id = p_id;
		this.libelle = p_libelle;
		this.siren = p_siren;
		this.adress = p_adress;
		this.adress2 = p_adress2;
		this.datfer = p_datfer;
		this.lienHref = lienHrefCHoix;
		this.socGroupe = p_socGroupe ; 
	}

	/**
	 * 
	 */
	public InfosSociete(String p_id, String p_libelle, String p_siren, String p_adress,String p_adress2, String p_datfer) 
	{
		this.id = p_id;
		this.libelle = p_libelle;
		this.siren = p_siren;
		this.adress = p_adress;
		this.adress2 = p_adress2;
		this.datfer = p_datfer;
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
	public String getAdress() {
		return adress;
	}

	/**
	 * @return
	 */
	public String getAdress2() {
		return adress2;
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
	 * @param string
	 */
	public String getDatfer() {
		return datfer;
	}

	/**
	 * @param string
	 */
	public void setAdress(String string) {
		adress = string;
	}
	
	/**
	 * @param string
	 */
	public void setAdress2(String string) {
		adress2 = string;
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
	public void setDatfer(String string) {
		datfer = string;
	}

	public String getSocGroupe() {
		return this.socGroupe;
	}

	public void setSocGroupe(String socGroupe) {
		this.socGroupe = socGroupe;
	}

}
