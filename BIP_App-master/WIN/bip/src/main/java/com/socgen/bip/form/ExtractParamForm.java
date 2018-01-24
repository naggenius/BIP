package com.socgen.bip.form;



import java.util.Date;
import java.util.Hashtable;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author RSRH/ICH/GMO Equipe Bip
 * @author N.BACCAM - 02/09/2003
 *
 * Classe ActionForm spécifique aux extractions paramétrées de la BIP
 */
public class ExtractParamForm extends AutomateForm
{
	/*Le nom de l'extraction
	*/
	private String nomFichier;
	/*Le libellé de l'extraction
	*/
	private String titre;
	/*La hashtable des filtres
	*/
	private Hashtable filtre;
	/*La partie filtre de la requete
	*/
	private String filtreSql;
	/*La liste des colonnes
	*/
	private String data;
	/*Le nombre de colonne
	*/
	private String nbData;
	/*La date courante
	*/
	private Date date;
	/*La requête 
	*/
	private String requete;
	/*Affichage ou non de l'entête
	*/
	private boolean enTete;
	/*Le choix des colonnes
	*/
	private String choix;

	/**
	 * Constructor for ExtractParamForm.
	 */
	public ExtractParamForm() {
		super();
	}

	
	/**
	 * Returns the nomFichier.
	 * @return String
	 */
	public String getNomFichier() {
		return nomFichier;
	}

	
	/**
	 * Sets the nomFichier.
	 * @param nomFichier The nomFichier to set
	 */
	public void setNomFichier(String nomFichier) {
		this.nomFichier = nomFichier;
	}

	/**
	 * Returns the titre.
	 * @return String
	 */
	public String getTitre() {
		return titre;
	}

	/**
	 * Sets the titre.
	 * @param titre The titre to set
	 */
	public void setTitre(String titre) {
		this.titre = titre;
	}

	


	/**
	 * Returns the filtreSql.
	 * @return String
	 */
	public String getFiltreSql() {
		return filtreSql;
	}

	/**
	 * Sets the filtreSql.
	 * @param filtreSql The filtreSql to set
	 */
	public void setFiltreSql(String filtreSql) {
		this.filtreSql = filtreSql;
	}



	/**
	 * Returns the data.
	 * @return String
	 */
	public String getData() {
		return data;
	}

	/**
	 * Sets the data.
	 * @param data The data to set
	 */
	public void setData(String data) {
		this.data = data;
	}

	/**
	 * Returns the filtre.
	 * @return Hashtable
	 */
	public Hashtable getFiltre() {
		return filtre;
	}

	/**
	 * Sets the filtre.
	 * @param filtre The filtre to set
	 */
	public void setFiltre(Hashtable filtre) {
		this.filtre = filtre;
	}

	/**
	 * Returns the nbData.
	 * @return String
	 */
	public String getNbData() {
		return nbData;
	}

	/**
	 * Sets the nbData.
	 * @param nbData The nbData to set
	 */
	public void setNbData(String nbData) {
		this.nbData = nbData;
	}

	/**
	 * Returns the date.
	 * @return Date
	 */
	public Date getDate() {
		return date;
	}

	/**
	 * Sets the date.
	 * @param date The date to set
	 */
	public void setDate(Date date) {
		this.date = date;
	}

	/**
	 * Returns the entete.
	 * @return boolean
	 */
	public boolean isEnTete() {
		return enTete;
	}

	/**
	 * Returns the requete.
	 * @return String
	 */
	public String getRequete() {
		return requete;
	}

	

	/**
	 * Sets the requete.
	 * @param requete The requete to set
	 */
	public void setRequete(String requete) {
		this.requete = requete;
	}

	/**
	 * Returns the choix.
	 * @return String
	 */
	public String getChoix() {
		return choix;
	}

	/**
	 * Sets the choix.
	 * @param choix The choix to set
	 */
	public void setChoix(String choix) {
		this.choix = choix;
	}

	/**
	 * Sets the enTete.
	 * @param enTete The enTete to set
	 */
	public void setEnTete(boolean enTete) {
		this.enTete = enTete;
	}

}
