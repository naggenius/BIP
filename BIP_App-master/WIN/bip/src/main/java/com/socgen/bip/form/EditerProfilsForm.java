package com.socgen.bip.form;

import java.util.LinkedList;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.upload.FormFile;

import com.socgen.bip.commun.form.EditionForm;
import com.socgen.bip.metier.EnregistrementCsvEditionProfils;

/**
 * @author x119481 - 04/02/2013
 *
 * Formulaire pour édition du rapport profils à partir d'une liste de ressources
 * page  : eProfilsListeRessources.jsp
 */
public class EditerProfilsForm extends EditionForm {
	
	/**
	 * Statut
	 */
	private String statut;
	// Valeur OK du champ statut
	public static String statutOk = "OK";
	// Valeur KO du champ statut
	private static String statutKo = "KO";
	/**
	 * Message fichier techniquement invalide
	 */
	private String messageFichierTechniquementInvalide;
	/**
	 * Messages d'erreur fichier techniquement invalide
	 */
	public final static String ERREUR_PROBLEME_FORMAT = "Problème de format";
	public final static String ERREUR_PROBLEME_EN_TETE = "Problème d'en-tête";
	public final static String ERREUR_PROBLEME_ENREGISTREMENT = "Problème d'enregistrement";
	public final static String ERREUR_TAILLE_FICHIER = "Problème de taille de fichier";
	
	/**
	 * Messages d'erreur autres
	 */
	public final static String ERREUR_FICHIER_NON_TROUVE = "Fichier non trouvé";
	/**
	 * Liste des enregistrements erronés (lignes)
	 */
	private LinkedList<EnregistrementCsvEditionProfils> enregistrementsErrones;
	/**
	 * Liste des identifiants RTFE des ressources BIP valides (pour génération du rapport)
	 */
	private LinkedList<String> idRessBipValides;
	/**
	 * Nombre d'enregistrements lus
	 */
	private int nbEnregistrementsLus;
	/**
	 * Nombre d'enregistrements identifiés Bip
	 */
	private int nbEnregistrementsIdentifiesBip;
	/**
	 * Nombre d'enregistrements non identifiés Bip
	 */
	private int nbEnregistrementsNonIdentifiesBip;
	/**
	 * Champ Fichier csv
	 */
	private FormFile fichierCsv;
	/**
	 * Champ caché 
	 */	
	private String nomAttributSessionIdRessValides;
	
	public String getNomAttributSessionIdRessValides() {
		return nomAttributSessionIdRessValides;
	}

	public void setNomAttributSessionIdRessValides(
			String nomAttributSessionIdRessValides) {
		this.nomAttributSessionIdRessValides = nomAttributSessionIdRessValides;
	}

	public EditerProfilsForm() {
		super();
		idRessBipValides = new LinkedList<String>();
		// Initialisation des compteurs
		nbEnregistrementsLus = 0;
		nbEnregistrementsIdentifiesBip = 0;
		nbEnregistrementsNonIdentifiesBip = 0;
	}
	
	/**
	 * Alimentation des champs autocalculés à partir des varables d'instance
	 *
	 */
	public void alimenterChampsCalcules() {
		alimenterNbEnregistrementsLus();
		alimenterStatut();
	}
	
	private void alimenterNbEnregistrementsLus() {
		// NbEnrgLus = identifiés + non identifiés
		nbEnregistrementsLus = nbEnregistrementsIdentifiesBip + nbEnregistrementsNonIdentifiesBip;
	}
	
	private void alimenterStatut() {
		// Si fichier techniquement invalide
		if (StringUtils.isNotEmpty(messageFichierTechniquementInvalide)) {
			statut = messageFichierTechniquementInvalide;
		}
		// Sinon, si certains enregistrements ne sont pas identifiés Bip
		else if (nbEnregistrementsNonIdentifiesBip > 0) {
			statut = statutKo;
		}
		else {
			statut = statutOk;
		}
			
	}

	public static String getStatutKo() {
		return statutKo;
	}

	public static void setStatutKo(String statutKo) {
		EditerProfilsForm.statutKo = statutKo;
	}

	public static String getStatutOk() {
		return statutOk;
	}

	public static void setStatutOk(String statutOk) {
		EditerProfilsForm.statutOk = statutOk;
	}

	public LinkedList<EnregistrementCsvEditionProfils> getEnregistrementsErrones() {
		return enregistrementsErrones;
	}

	public void setEnregistrementsErrones(
			LinkedList<EnregistrementCsvEditionProfils> enregistrementsErrones) {
		this.enregistrementsErrones = enregistrementsErrones;
	}
	
	public int getNbEnregistrementsErrones() {
		int retour = 0;
		if (enregistrementsErrones != null) {
			retour = enregistrementsErrones.size();
		}
		
		return retour;
	}
	
	public void ajouterEnregistrementErrone(EnregistrementCsvEditionProfils enregistrement) {
		if (enregistrementsErrones == null) {
			enregistrementsErrones = new LinkedList<EnregistrementCsvEditionProfils>();
		}
		enregistrementsErrones.add(enregistrement);
	}

	public String getMessageFichierTechniquementInvalide() {
		return messageFichierTechniquementInvalide;
	}

	public void setMessageFichierTechniquementInvalide(
			String messageFichierTechniquementInvalide) {
		this.messageFichierTechniquementInvalide = messageFichierTechniquementInvalide;
	}

	public int getNbEnregistrementsIdentifiesBip() {
		return nbEnregistrementsIdentifiesBip;
	}

	public void setNbEnregistrementsIdentifiesBip(int nbEnregistrementsIdentifiesBip) {
		this.nbEnregistrementsIdentifiesBip = nbEnregistrementsIdentifiesBip;
	}
	
	public void incrementerNbEnregistrementsIdentifiesBip() {
		this.nbEnregistrementsIdentifiesBip ++;
	}

	public int getNbEnregistrementsLus() {
		return nbEnregistrementsLus;
	}

	public void setNbEnregistrementsLus(int nbEnregistrementsLus) {
		this.nbEnregistrementsLus = nbEnregistrementsLus;
	}

	public int getNbEnregistrementsNonIdentifiesBip() {
		return nbEnregistrementsNonIdentifiesBip;
	}

	public void setNbEnregistrementsNonIdentifiesBip(
			int nbEnregistrementsNonIdentifiesBip) {
		this.nbEnregistrementsNonIdentifiesBip = nbEnregistrementsNonIdentifiesBip;
	}
	
	public void incrementerNbEnregistrementsNonIdentifiesBip() {
		this.nbEnregistrementsNonIdentifiesBip ++;
	}

	public String getStatut() {
		return statut;
	}

	public void setStatut(String statut) {
		this.statut = statut;
	}

	public FormFile getFichierCsv() {
		return fichierCsv;
	}

	public void setFichierCsv(FormFile fichierCsv) {
		this.fichierCsv = fichierCsv;
	}

	public LinkedList<String> getIdRessBipValides() {
		return idRessBipValides;
	}

	public void setIdRessBipValides(LinkedList<String> idRessBipValides) {
		this.idRessBipValides = idRessBipValides;
	}


	
}
