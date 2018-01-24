package com.socgen.bip.form;

import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.form.AutomateForm;
/**
 * @author K. Hazard - 05/10/2004
 *
 * represente une actualite
 * chemin : Administration/Gestion des actualités
 * pages  : bActuAd.jsp 
 * pl/sql : actualite.sql
 */
public class ActualiteForm extends AutomateForm {
	/*
	*/

	private String code_actu;
  	private String titre     ;       
  	private String texte      ;      
  	private String date_affiche;     
  	private String date_debut   ;    
  private String date_fin ;
  private String valide   ;
  private String url;
  private String derniere_minute;
  private String string_menus;
  private String nom_fichier;
  private FormFile fichier;
  private String  mime_fichier;
  private int  size_fichier;
  private String alerte_actu;
  
	/**
	 * Constructor for .
	 */
	public ActualiteForm() {
		super();
	}

  
	
	/**
	 * Returns the code_actu.
	 * @return String
	 */
	public String getCode_actu() {
		return code_actu;
	}

	/**
	 * Sets the code_actu.
	 * @param code_actu The code_actu to set
	 */
	public void setCode_actu(String code_actu) {
		this.code_actu = code_actu;
	}

 	/**
	 * Returns the titre.
	 * @return String
	 */
	  public String getTitre () {
		return   titre ;
	}        
 	 /**
	 * Returns the texte.
	 * @return String
	 */
	 public String getTexte() {
		return    texte ;
	}        
  	/**
	 * Returns the date_affiche.
	 * @return String
	 */
	 public String getDate_affiche () {
		return  date_affiche ;
	}  
  	/**
	 * Returns the date_debut.
	 * @return String
	 */
	 public String getDate_debut () {
		return  date_debut;
	}     
  
  	/**
	 * Returns the date_fin.
	 * @return String
	 */
	 public String getDate_fin () {
		return  date_fin ;
	}      
 	/**
	 * Returns the valide.
	 * @return String
	 */
	  public String getValide   () {
		return  valide ;
	}      
 	/**
	 * Returns the url.
	 * @return String
	 */
	  public String getUrl () {
		return   url   ;
	}        
  	/**
	 * Returns the derniere_minute.
	 * @return String
	 */
	 public String getDerniere_minute() {
		return derniere_minute;
	}
  

	/**
	 * Sets the titre.
	 * @param titre The titre to set
	 */
	public void setTitre (String titre) {
		this.titre = titre;
	}           
 
	/**
	 * Sets the texte.
	 * @param texte The texte to set
	 */
	public void setTexte (String texte) {
		this.texte = texte;
	}           
 
	/**
	 * Sets the date_affiche.
	 * @param date_affiche The date_affiche to set
	 */
	public void setDate_affiche (String date_affiche) {
		this.date_affiche = date_affiche;
	}    
 
	/**
	 * Sets the date_debut.
	 * @param date_debut The date_debut to set
	 */
	public void setDate_debut(String date_debut) {
		this.date_debut = date_debut;
	}       
 
	/**
	 * Sets the date_fin.
	 * @param date_fin The date_fin to set
	 */
	public void setDate_fin (String date_fin) {
		this.date_fin = date_fin;
	}        

	/**
	 * Sets the valide.
	 * @param valide The valide to set
	 */
	public void setValide (String valide) {
		this.valide = valide;
	}         
 
	/**
	 * Sets the url.
	 * @param url The url to set
	 */
	public void setUrl (String url) {
		this.url = url;
	}             
 
	/**
	 * Sets the derniere_minute.
	 * @param derniere_minute The derniere_minute to set
	 */
	public void setDerniere_minute(String derniere_minute) {
		this.derniere_minute = derniere_minute;
	}

	/**
	 * Returns the menus.
	 * @return String
	 */
	public String getString_menus() {
		if (string_menus!=null)
		{return string_menus;
		}
		else
		return new String();
		
	}

	/**
	 * Sets the code_actu.
	 * @param code_actu The code_actu to set
	 */
	public void setString_menus(String menus) {
		this.string_menus = menus;
	}
	/**
		 * Returns the fichier.
		 * @return FormFile
		 */
	public FormFile getFichier()
	{
		return fichier;
	}

	/**
	 * @param file
	 */
	public void setFichier(FormFile file)
	{
		fichier = file;
	}
	/**
	 * Returns the nom_fichier.
	 * @return String
	 */
	public String getNom_fichier() {

		return nom_fichier;
	}

	/**
	 * Sets the nom_fichier.
	 * @param nom_fichier The nom_fichier to set
	 */
	public void setNom_fichier(String nom_fichier) {
		this.nom_fichier = nom_fichier;
	}
	/**
	 * Returns the mime_fichier.
	 * @return String
	 */
	public String getMime_fichier() {

		return mime_fichier;
	}

	/**
	 * Sets the mime_fichier.
	 * @param mime_fichier The mime_fichier to set
	 */
	public void setMime_fichier(String mime_fichier) {
		this.mime_fichier = mime_fichier;
	}
	/**
	 * Returns the size_fichier.
	 * @return String
	 */
	public int getSize_fichier() {

		return size_fichier;
	}

	/**
	 * Sets the size_fichier.
	 * @param size_fichier The size_fichier to set
	 */
	public void setSize_fichier(int size_fichier) {
		this.size_fichier = size_fichier;
	}



	public String getAlerte_actu() {
		return alerte_actu;
	}



	public void setAlerte_actu(String alerte_actu) {
		this.alerte_actu = alerte_actu;
	}
	
	
	
} 
 