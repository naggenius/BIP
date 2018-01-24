package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author BAA - 13/10/2005
 *
 * Formulaire modidier les parametres session
 * pages : fmClientAd.jsp, mClientAd.jsp
 */
public class ParamsessionForm extends AutomateForm{
	
	
	
     /**
	  * Listes des menus dont l'utilisateur à le droit d'accéder
	  */
	 private String listeMenus = null;
	 
	 /**
	  * Listes des sous-menus dont l'utilisateur à le droit d'accéder
	  */
	 private String sousMenus = null;
	
	/**
	  * DPG par défaut de l'utilisateur
	  */
	private String dpg_Defaut = null;  
	  
	   
	 /**
	  * Liste des BDDPG de l'utilisateur(séparateur : ",")
	  * Correspond au périmètre ME
	  */
	 private String perim_ME = null;
	 

	
	  /**
	   * Codes ressources du chef de projet
	   */
	private String chef_Projet = null;

	
	/**
	  * Direction MO par défaut de l'utilisateur
	  */
	private String clicode_Defaut = null;
	
	
	/**
	 * Liste des CLIDOM des l'utilisateur hors client MO(séparateur : ",")
	 * Correspond au périmètre MO
	 */
    private String perim_MO = null;
    
    /**
	 * Liste des CLIDOM des l'utilisateur client MO(séparateur : ",")
	 * Correspond au périmètre MCLI
	 */
    private String perim_MCLI = null;
	

	/**
	  * Liste des centres de frais de l'utilisateur(séparateur : ",") dans une seul chaine
	  */
	private String liste_Centres_Frais = null;	
	
	
	/**
	  * Liste des CA auxquels l'utilisateur est habilité
	  * Pour le suivi d'investissement
	  */
	private String ca_suivi = null;
	
	
	/**
	  * Liste des Projets auxquels l'utilisateur est habilité
	  */
	private String projet = null;
	
	
	
	/**
	  * Liste des Applications auxquelles l'utilisateur est habilité
	  */
	private String appli = null;
	
	/**
	  * Liste des CA FI auxquels l'utilisateur est habilité
	  */
	private String CAFI = null;
	
	
	/**
	  * Liste des CA Payeur auxquels l'utilisateur est habilité
	  */
	private String CAPayeur = null;
	
	/**
	  * Liste des CA DA auxquels l'utilisateur est habilité
	  */
	private String CADA = null;
		
	/**
	  * Liste des Dossier projets auxquels l'utilisateur est habilité
	  */
	private String dossProj = null;
	
	/**
	 * 
	 * Message d'erreur dans le cas où la saisie ne répond pas au paramétrage du RTFE défini dans les paramètres BIP
	 */
	private String erreurRTFE = null;

	
	
	/**
	 * Constructor for ClientForm.
	 */
	public ParamsessionForm() {
		super();
	}
	
	
	
	
	
	/**
	  * Retourne la liste des menus auxquels est habilité l'utilisateur
	  * @return Vector
	  */
	public String getListeMenus()
	{
			return listeMenus;
	}
	
	
	/**
	  * Retourne la liste des sous menus auxquels est habilité l'utilisateur
	  * @return Vector
	  */
	public String getSousMenus()
	{
		return sousMenus;
	}
	
	
	public String getPerim_ME()
	{
	     return perim_ME;
	}
	
	public String getDpg_Defaut()
	{ 
		return dpg_Defaut;
	}
	
	public String getChef_Projet()
	{
	    return chef_Projet;
	}
	
	public String getClicode_Defaut()
	{	
		return clicode_Defaut;
	}	
	
	public String getPerim_MO()
	{
	    return perim_MO;
	}
	
	public String getPerim_MCLI()
	{
	    return perim_MCLI;
	}

	public String getListe_Centres_Frais()
	{	
	    return liste_Centres_Frais;	
	}
	
	public String getCa_suivi()
	{
		return ca_suivi;
	}
	
	public String getProjet()
	{	
		return projet;
	}
	
	public String getAppli()
	{
			return appli;
	}
		
	public String getCAFI()
	{	
		 return CAFI;
	}
	
	public String getCAPayeur()
	{	
		return CAPayeur;
	}
	
	public String getCADA()
	{	
		return CADA;
	}
	
	public String getDossProj()
	{	
	    return dossProj;
	}
		
	
	
	public void setListeMenus(String chaine)
	{
			listeMenus=chaine;
	}
		
	public void setSousMenus(String chaine)
	{
		 sousMenus=chaine;
	}
	
	
	public void setPerim_ME(String chaine)
	{
		  perim_ME=chaine;
	}
	
	public void setDpg_Defaut(String chaine)
	{ 
		 dpg_Defaut=chaine;
	}
	
	public void setChef_Projet(String chaine)
	{
		 chef_Projet=chaine;
	}
	
	public void setClicode_Defaut(String chaine)
	{	
		 clicode_Defaut=chaine;
	}	
	
	public void setPerim_MO(String chaine)
	{
		 perim_MO=chaine;
	}

	public void setPerim_MCLI(String chaine)
	{
		 perim_MCLI=chaine;
	}
	
	public void setListe_Centres_Frais(String chaine)
	{	
		 liste_Centres_Frais=chaine;	
	}
	
	public void setCa_suivi(String chaine)
	{
		 ca_suivi=chaine;
	}
	
	public void setProjet(String chaine)
	{	
		 projet=chaine;
	}
	
	public void setAppli(String chaine)
	{
		 appli=chaine;
	}
		
	public void setCAFI(String chaine)
	{	
		  CAFI=chaine;
	}
	
	public void setCAPayeur(String chaine)
	{	
		 CAPayeur=chaine;
	}
	
	public void setCADA(String chaine)
	{	
		 CADA=chaine;
	}
	
	public void setDossProj(String chaine)
	{	
		 dossProj=chaine;
	}

	public String getErreurRTFE() {
		return erreurRTFE;
	}

	public void setErreurRTFE(String erreurRTFE) {
		this.erreurRTFE = erreurRTFE;
	}


}
