package com.socgen.bip.form;
import java.sql.Blob;

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
public class DownloadFileForm extends AutomateForm {
	/*
	*/

	private String code_actu;
   private String nom_fichier;
  private FormFile fichier;
  private String  mime_fichier;
  private int  size_fichier;
  private Blob  blob_fichier;
  
	/**
	 * Constructor for .
	 */
	public DownloadFileForm() {
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
	
	/**
	 * Returns the blob_fichier.
	 * @return String
	 */
	public Blob getBlob_fichier() {

		return blob_fichier;
	}

	/**
	 * Sets the blob_fichier.
	 * @param blob_fichier The blob_fichier to set
	 */
	public void setBlob_fichier(Blob blob_fichier) {
		this.blob_fichier = blob_fichier;
	}
} 
 