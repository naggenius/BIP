package com.socgen.bip.form;


import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author BAA - 31/01/2006
 *
 * Action de mise à jour des Rubriques
 * chemin : Administration/Tables/ mise à jour/Rubrique
 * pages  : fmRubriqueAd.jsp et mRubriqueAd.jsp
 * pl/sql : rubrique.sql
 */
public class RubriqueForm extends AutomateForm {

	/*Le code rubrique
	*/
	private String codrub ;
	
	/*code diréction
	*/
	private String coddir;
	
	/*libellé diréction
    */
    private String libdir;
	
	/*libelle
	*/
	private String libelle;
	
	/*Code élément de pilotage
	*/
	private String codep;
	
	/*codfei
	*/
	private String codfei;
	
	/*Le code CAFI
	*/
	private String cafi ;
	
	/*Le libelle CAFI
	*/
    private String libcafi ;

	/*Code compte à débiter 
	*/
	private String comptedeb;
	
	/*code compte à créditer
	*/
	private String comptecre;
	
	/*libelle compte à débiter 
	*/
	private String libcomptedeb;
	
	/*libelle compte à créditer
	*/
	private String libcomptecre;
	
	/*code schema comptable
	*/
	private String schemacpt;
	
	/*Application
	*/
	private String appli;
	
	/*DAte de la demamde
	*/
	private String datedemande;
	
	/*Date du retour
	*/
	private String dateretour ;
	

	/*Commentaires
	*/
	private String commentaires;
	
	
	private int flaglock ;
	/**
	 * Constructor for CompteForm.
	 */
	
	
	public RubriqueForm() {
		super();
	}

	

	/**
	 * Returns the codrub.
	 * @return String
	 */
	public String getCodrub() {
		return codrub;
	}

	/**
	 * Returns the coddir.
	 * @return String
	 */
	public String getCoddir() {
		return coddir;
	}
	
	/**
    * Returns the libdir.
    * @return String
	*/
	public String getlibdir() {
		return libdir;
	}
	
	/**
	* Returns the libelle.
	* @return String
	*/
	public String getLibelle() {
		return libelle;
	}
	

	/**
	 * Returns the codep.
	 * @return String
	 */
	public String getCodep() {
		return codep;
	}

	/**
	* Returns the codfei.
	* @return String
    */
	public String getCodfei() {
			return codfei;
	}

	/**
	* Returns the codCafi.
	* @return String
	*/
	public String getCafi() {
			return cafi;
	}

	/**
	* Returns the comptedeb.
	* @return String
    */
	public String getComptedeb() {
			return comptedeb;
	} 
    
	/**
	* Returns the comptecre.
	* @return String
	*/
	public String getComptecre() {
			return comptecre;
	} 
    
	/**
	* Returns the codCafi.
	* @return String
	*/
	public String getLibcafi() {
		return libcafi;
	}

	/**
	* Returns the libcomptedeb.
	* @return String
	*/
	public String getLibcomptedeb() {
		return libcomptedeb;
	} 
    
    /**
	* Returns the libcomptecre.
	* @return String
	*/
	public String getLibcomptecre() {
		return libcomptecre;
	} 
	/**
	* Returns the schemacpt.
	* @return String
	*/
	public String getSchemacpt() {
				return schemacpt;
	} 
  
	/**
	* Returns the appli.
	* @return String
	*/
	public String getAppli() {
				return appli;
	} 

	/**
	* Returns the datedemande.
	* @return String
	*/
	public String getDatedemande() {
			return datedemande;
	} 

	/**
	* Returns the dateretour.
	* @return String
	*/
	public String getDateretour() {
			return dateretour;
	} 

	/**
	* Returns the commentaires.
	* @return String
	*/
	public String getCommentaires() {
			return commentaires;
	} 


	/**
	 * Sets the codrub.
	 * @param codrub The codrub to set
	 */
	public void setCodrub(String codrub) {
		this.codrub = codrub;
	}

	/**
	 * Sets the coddir.
	 * @param coddir The coddir to set
	 */
	public void setCoddir(String coddir) {
		this.coddir = coddir;
	}

	/**
	* Sets the libdir.
	* @param libdir The libdir to set
	*/
	public void setLibdir(String libdir) {
		this.libdir = libdir;
	}
    
	/**
	* Sets the libelle.
	* @param coddir The libelle to set
	*/
	public void setLibelle(String libelle) {
			this.libelle = libelle;
	}
 

	/**
	 * Sets the codep.
	 * @param codep The codep set
	 */
	public void setCodep(String codep)
	{
		this.codep = codep;
	}

	/** Sets the codfei.
	* @param codfei The codfei set
	*/
	public void setCodfei(String codfei)
	{
		   this.codfei = codfei;
	}

	/** Sets the cafi.
	* @param cafi The cafi set
	*/
	public void setCafi(String cafi)
	{
		   this.cafi = cafi;
	}

	/** Sets the comptedeb.
	* @param comptedeb The comptedeb set
	*/
	public void setComptedeb(String comptedeb)
	{
		   this.comptedeb = comptedeb;
	}
   
	/** Sets the comptecre.
	* @param comptecre The comptecre set
	*/
	public void setComptecre(String comptecre)
	{
		    this.comptecre = comptecre;
	}

	/** Sets the libcafi.
	* @param libcafi The libcafi set
	*/
	public void setLibcafi(String libcafi)
	{
			   this.libcafi = libcafi;
	}

	/** Sets the libcomptedeb.
	* @param libcomptedeb The libcomptedeb set
	*/
	public void setLibcomptedeb(String libcomptedeb)
	{
		this.libcomptedeb = libcomptedeb;
	}
   
	/** Sets the libcomptecre.
	* @param libcomptecre The libcomptecre set
	*/
	public void setLibcomptecre(String libcomptecre)
	{
		this.libcomptecre = libcomptecre;
	}


	/** Sets the schemacpt.
	* @param schemacpt The schemacpt set
	*/
	public void setSchemacpt(String schemacpt)
	{
		   this.schemacpt = schemacpt;
	}


	/** Sets the appli.
	* @param appli The appli set
	*/
	public void setAppli(String appli)
	{
			this.appli = appli;
	}

	/** Sets the datedemande.
	* @param datedemande The datedemande set
	*/
	public void setDatedemande(String datedemande)
	{
		   this.datedemande = datedemande;
	}

	/** Sets the dateretour.
	* @param dateretour The dateretour set
	*/
	public void setDateretour(String dateretour)
	{
		   this.dateretour = dateretour;
	}

	/** Sets the commentaires.
	* @param commentaires The commentaires set
	*/
	public void setCommentaires(String commentaires)
	{
	   this.commentaires = commentaires;
	}


	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

}
