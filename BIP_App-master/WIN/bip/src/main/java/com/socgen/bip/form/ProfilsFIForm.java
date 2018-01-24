package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;



/**
 * @author O. EL KHABZI - 13/01/2012
 *
 * Formulaire pour mise à jour des Profils FI
 * chemin : Administration/Tables/Mise à jour/Profil de FI
 * pages  : fmProfilsFIAd.jsp et mProfilsFIAd.jsp
 * pl/sql : profil_fi.sql
 */

public class ProfilsFIForm extends AutomateForm{

	/*Le Profil FI
	*/ 
	private String profi;
	
    /*Le libellé
	*/  
	private String libelle;
	
    /*La Date Effet
	*/  
	private String date_effet;
	
    /*Indicateur Actif
	*/ 
	private String top_actif;
	
    /*Le Coût Unitaire HTR
	*/ 
	private String cout;
	
    /*Les Commentaires
	*/ 
	private String commentaire;
	
    /*La Direction BIP
	*/ 
	private String coddir;
	
    /*Indicateur de Prestation
	*/ 
	private String topegalprestation;
	
    /*Les Codes Prestations
	*/ 
	private String prestation;
	
    /*Indicateur Localisation
	*/ 
	private String topegallocalisation;
	
    /*Localisation
	*/ 
	private String localisation;
	
    /*=/# Pour ES
	*/ 
	private String topegales;
	
    /*Codes ES
	*/ 
	private String code_es;
	  
	private String filtre_date;
	
	private String profi_detail;

	private String filtre_fi ;
	
	private String message_fi_ress;
	
	private String filtre_lst_fi;
	
	private String lst_date_effet;
		
	
	// ==============> Getters <========================== //

	/**
	 * Returns the Top_Actif.
	 * @return String
	 */	
	public String getTop_actif() {
		return top_actif;
	}
	
	/**
	 * Returns the Coddir.
	 * @return String
	 */	
	public String getCoddir() {
		return coddir;
	}

	/**
	 * Returns the Codes ES.
	 * @return String
	 */	
	public String getCode_es() {
		return code_es;
	}

	/**
	 * Returns the Codes Prestation.
	 * @return String
	 */	
	public String getPrestation() {
		return prestation;
	}

	/**
	 * Returns the Commenatires.
	 * @return String
	 */	
	public String getCommentaire() {
		return commentaire;
	}

	/**
	 * Returns the Coût.
	 * @return Double
	 */	
	public String getCout() {
		return cout;
	}

	/**
	 * Returns the Date Effet.
	 * @return String
	 */	
	public String getDate_effet() {
		return date_effet;
	}

	/**
	 * Returns the Indicateur ES.
	 * @return String
	 */	
	public String getTopegales() {
		return topegales;
	}

	/**
	 * Returns the Indicateur Localisation.
	 * @return String
	 */	
	public String getTopegallocalisation() {
		return topegallocalisation;
	}

	/**
	 * Returns the Indicateur de Prestations.
	 * @return String
	 */	
	public String getTopegalprestation() {
		return topegalprestation;
	}

	/**
	 * Returns the Libellé.
	 * @return String
	 */	
	public String getLibelle() {
		return libelle;
	}

	/**
	 * Returns the Localisation.
	 * @return String
	 */	
	public String getLocalisation() {
		return localisation;
	}

	/**
	 * Returns the Profil de FI.
	 * @return String
	 */	
	public String getProfi() {
		return profi;
	}


	// ==============> Setters <========================== //
	
	/**
	 * Sets the Top_Actif.
	 * @param Top_Actif The Top_Actif to set
	 */
	public void setTop_actif(String top_actif) {
		this.top_actif = top_actif;
	}

	/**
	 * Sets the coddir.
	 * @param coddir The coddir to set
	 */
	public void setCoddir(String coddir) {
		this.coddir = coddir;
	}

	/**
	 * Sets the code_es.
	 * @param code_es The code_es to set
	 */
	public void setCode_es(String code_es) {
		this.code_es = code_es;
	}

	/**
	 * Sets the Prestation.
	 * @param Prestation The Prestation to set
	 */
	public void setPrestation(String prestation) {
		this.prestation = prestation;
	}

	/**
	 * Sets the commentaire.
	 * @param commentaire The commentaire to set
	 */
	public void setCommentaire(String commentaire) {
		this.commentaire = commentaire;
	}

	/**
	 * Sets the cout.
	 * @param cout The cout to set
	 */
	public void setCout(String cout) {
		this.cout = cout;
	}

	/**
	 * Sets the date_effet.
	 * @param date_effet The date_effet to set
	 */
	public void setDate_effet(String date_effet) {
		this.date_effet = date_effet;
	}

	/**
	 * Sets the topegales.
	 * @param topegales The topegales to set
	 */
	public void setTopegales(String topegales) {
		this.topegales = topegales;
	}

	/**
	 * Sets the topegallocalisation.
	 * @param topegallocalisation The topegallocalisation to set
	 */
	public void setTopegallocalisation(String topegallocalisation) {
		this.topegallocalisation = topegallocalisation;
	}

	/**
	 * Sets the topegalprestation.
	 * @param topegalprestation The topegalprestation to set
	 */
	public void setTopegalprestation(String topegalprestation) {
		this.topegalprestation = topegalprestation;
	}

	/**
	 * Sets the libelle.
	 * @param libelle The libelle to set
	 */
	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	/**
	 * Sets the localisation.
	 * @param localisation The localisation to set
	 */
	public void setLocalisation(String localisation) {
		this.localisation = localisation;
	}

	/**
	 * Sets the profi.
	 * @param profi The profi to set
	 */
	public void setProfi(String profi) {
		this.profi = profi;
	}
	

	// ============================================================================================

	/**
	 * Constructor for ClientForm.
	 */
	public ProfilsFIForm() {
		super();
	}
	
   /**
     * Validate the properties that have been set from this HTTP request,
     * and return an <code>ActionErrors</code> object that encapsulates any
     * validation errors that have been found.  If no errors are found, return
     * <code>null</code> or an <code>ActionErrors</code> object with no
     * recorded error messages.
     *
     * @param mapping The mapping used to select this instance
     * @param request The servlet request we are processing
     */
    public ActionErrors validate(ActionMapping mapping,
                                 HttpServletRequest request) {

        ActionErrors errors = new ActionErrors();
        
        this.logIhm.debug("Début validation de la form -> " + this.getClass()) ;
     
        logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
        return errors; 
    }

	/**
	 * Constructor Avec Paramètres.
	 */
	

	public ProfilsFIForm(String profi, String libelle, String date_effet, String top_actif, String cout, String commentaire, String coddir, String topegalprestation, String prestation, String topegallocalisation, String localisation, String topegales, String code_es, String filtre_date, String profi_detail, String filtre_fi, String message_fi_ress, String filtre_lst_fi, String lst_date_effet) {
		super();
		this.profi = profi;
		this.libelle = libelle;
		this.date_effet = date_effet;
		this.top_actif = top_actif;
		this.cout = cout;
		this.commentaire = commentaire;
		this.coddir = coddir;
		this.topegalprestation = topegalprestation;
		this.prestation = prestation;
		this.topegallocalisation = topegallocalisation;
		this.localisation = localisation;
		this.topegales = topegales;
		this.code_es = code_es;
		this.filtre_date = filtre_date;
		this.profi_detail = profi_detail;
		this.filtre_fi = filtre_fi;
		this.message_fi_ress = message_fi_ress;
		this.filtre_lst_fi = filtre_lst_fi;
		this.lst_date_effet = lst_date_effet;
	}
    

	public String getProfi_detail() {
		return profi_detail;
	}

	public void setProfi_detail(String profi_detail) {
		this.profi_detail = profi_detail;
	}

	public String getFiltre_date() {
		return filtre_date;
	}

	public String getFiltre_fi() {
		return filtre_fi;
	}

	public void setFiltre_date(String filtre_date) {
		this.filtre_date = filtre_date;
	}

	public void setFiltre_fi(String filtre_fi) {
		this.filtre_fi = filtre_fi;
	}

	public String getMessage_fi_ress() {
		return message_fi_ress;
	}

	public void setMessage_fi_ress(String message_fi_ress) {
		this.message_fi_ress = message_fi_ress;
	}


	public String getFiltre_lst_fi() {
		return filtre_lst_fi;
	}

	public void setFiltre_lst_fi(String filtre_lst_fi) {
		this.filtre_lst_fi = filtre_lst_fi;
	}

	public String getLst_date_effet() {
		return lst_date_effet;
	}

	public void setLst_date_effet(String lst_date_effet) {
		this.lst_date_effet = lst_date_effet;
	}



	

	
}
