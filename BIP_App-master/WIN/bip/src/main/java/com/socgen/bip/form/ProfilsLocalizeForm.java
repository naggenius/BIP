package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;


public class ProfilsLocalizeForm extends AutomateForm{

	/*Le Profil DomFonc
	*/ 
	private String profil_localize;
	
    /*Le libell�
	*/  
	private String libelle;
	
    /*La Date Effet
	*/  
	private String date_effet;
	
    /*Indicateur Actif
	*/ 
	private String top_actif;
	
	/*Indicateur Force_travaild
	*/ 
	private String force_travail;
	
	/*Indicateur Frais_environnement
	*/ 
	private String frais_environnement;
	
    /*Les Commentaires
	*/ 
	private String commentaire;
	
    /*La Direction BIP
	*/ 
	private String coddir;
	
	/*Le profil par defaut
	*/ 
	private String profil_defaut;
	
	/**
	 * Code Localization
	 */
	private String codelocal;
    
	
    /*Codes ES
	*/ 
	private String code_es;
	  
	private String filtre_date;
	
	private String filtre_localize ;

	
	private String filtre_lst_localize;
	
	private String lst_date_effet;
	
	/**
	 * Ecran d'appel
	 */
	private String ecran_appel;

	public ProfilsLocalizeForm() {
		super();
	}
		
	public ProfilsLocalizeForm(
			String profil_localize, 
			String libelle, 
			String date_effet, 
			String top_actif, 
			String force_travail,
			String frais_environnement, 
			String commentaire, 
			String coddir,
			String profil_defaut,
			String code_es, 
			String filtre_date, 
			String filtre_localize, 
			String filtre_lst_localize, 
			String lst_date_effet) {
		super();
		this.profil_localize = profil_localize;
		this.libelle = libelle;
		this.date_effet = date_effet;
		this.top_actif = top_actif;
		this.force_travail = force_travail;
		this.frais_environnement = frais_environnement;
		this.commentaire = commentaire;
		this.coddir = coddir;
		this.profil_defaut = profil_defaut;
		this.code_es = code_es;
		this.filtre_date = filtre_date;
		this.filtre_localize = filtre_localize;
		this.filtre_lst_localize = filtre_lst_localize;
		this.lst_date_effet = lst_date_effet;
	}

	
	

	public String getProfil_localize() {
		return profil_localize;
	}

	public void setProfil_localize(String profilDomfonc) {
		profil_localize = profilDomfonc;
	}

	public String getLibelle() {
		return libelle;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	public String getDate_effet() {
		return date_effet;
	}

	public void setDate_effet(String dateEffet) {
		date_effet = dateEffet;
	}

	public String getTop_actif() {
		return top_actif;
	}

	public void setTop_actif(String topActif) {
		top_actif = topActif;
	}

	public String getForce_travail() {
		return force_travail;
	}

	public void setForce_travail(String forceTravail) {
		force_travail = forceTravail;
	}

	public String getFrais_environnement() {
		return frais_environnement;
	}

	public void setFrais_environnement(String fraisEnvironnement) {
		frais_environnement = fraisEnvironnement;
	}

	public String getCommentaire() {
		return commentaire;
	}

	public void setCommentaire(String commentaire) {
		this.commentaire = commentaire;
	}

	public String getCoddir() {
		return coddir;
	}

	public void setCoddir(String coddir) {
		this.coddir = coddir;
	}

	public String getProfil_defaut() {
		return profil_defaut;
	}

	public void setProfil_defaut(String profilDefaut) {
		profil_defaut = profilDefaut;
	}

	public String getCode_es() {
		return code_es;
	}

	public void setCode_es(String codeEs) {
		code_es = codeEs;
	}

	public String getFiltre_date() {
		return filtre_date;
	}

	public void setFiltre_date(String filtreDate) {
		filtre_date = filtreDate;
	}

	public String getFiltre_localize() {
		return filtre_localize;
	}

	public void setFiltre_localize(String filtreDomfonc) {
		filtre_localize = filtreDomfonc;
	}

	public String getFiltre_lst_localize() {
		return filtre_lst_localize;
	}

	public void setFiltre_lst_localize(String filtreLstlocalize) {
		filtre_lst_localize = filtreLstlocalize;
	}

	public String getLst_date_effet() {
		return lst_date_effet;
	}

	public void setLst_date_effet(String lstDateEffet) {
		lst_date_effet = lstDateEffet;
	}

	public String getEcran_appel() {
		return ecran_appel;
	}

	public void setEcran_appel(String ecranAppel) {
		ecran_appel = ecranAppel;
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
        
        this.logIhm.debug("D�but validation de la form -> " + this.getClass()) ;
     
        logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
        return errors; 
    }

public String getCodelocal() {
	return codelocal;
}

public void setCodelocal(String codelocal) {
	this.codelocal = codelocal;
}

	/**
	 * Constructor Avec Param�tres.
	 */
	

    



	

	

	
}
