package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;



/**
 * @author H.MIRI -  62325
 *
 *
 */
public class SuiviBudgProjetForm extends AutomateForm{

 
	/*Le code dossier projet
	*/   
    private String dpcode; 
 
    /*Le libellé
	*/  
    private String dplib; ;    
   
    
    /*
     * Le code de direction principale
     */
    private String dir_prin;    
    /*
     * Le libelle de "branche : direction"
     */
    private String libelleDirPrin;

  
    
	/*Le flaglock
	*/
	private int flaglock ;
	
	/*La date d'immobilisation
	*/
	private String dateimmo;
	
	/* Le top actif
	 */
	private String topActif;
	
	/* Le type du dossier projet
	 */
	private String typdp;
	
	private String dp1;
	private String dp2;
	
	
	/*Le code dossier projet copi
	*/   
    private String dp_copi ; 
    
    /*Le libelle du dossier projet copi
	*/   
    private String libelle ;
    
    /*Le code dossier projet
	*/  
    
 private String clicode ;
    
    private String sous_systeme;
    
    private String domaine;
    
    private String sous_systeme_lib;
    
    private String domaine_lib;
private String axe_strategique;
	
	private String etape;
	
	private String typeFinancement;
	
	private String quote_part;
	private String dpcopiaxemetier;
	/**
	 * Constructor for ClientForm.
	 */
	public SuiviBudgProjetForm() {
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
	 * Returns the dpcode.
	 * @return String
	 */
	public String getDpcode() {
		return dpcode;
	}

	/**
	 * Returns the dplib.
	 * @return String
	 */
	public String getDplib() {
		return dplib;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Sets the dpcode.
	 * @param dpcode The dpcode to set
	 */
	public void setDpcode(String dpcode) {
		this.dpcode = dpcode;
	}

	/**
	 * Sets the dplib.
	 * @param dplib The dplib to set
	 */
	public void setDplib(String dplib) {
		this.dplib = dplib;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Returns the dateimmo.
	 * @return String
	 */
	public String getDateimmo() {
		return dateimmo;
	}

	/**
	 * Sets the dateimmo.
	 * @param dateimmo The dateimmo to set
	 */
	public void setDateimmo(String dateimmo) {
		this.dateimmo = dateimmo;
	}

	/**
	 * Returns the topActif.
	 * @return String
	 */
	public String getTopActif() {
		return topActif;
	}

	/**
	 * Sets the topActif.
	 * @param topActif The topActif to set
	 */
	public void setTopActif(String topActif) {
		this.topActif = topActif;
	}

	/**
	 * @return
	 */
	public String getTypdp() {
		return typdp;
	}

	/**
	 * @param string
	 */
	public void setTypdp(String typdp) {
		this.typdp = typdp;
	}

	public String getDp1() {
		return dp1;
	}

	public void setDp1(String dp1) {
		this.dp1 = dp1;
	}

	public String getDp2() {
		return dp2;
	}

	public void setDp2(String dp2) {
		this.dp2 = dp2;
	}
	//PPM 59288 debut
	public String getDir_prin() {
		return dir_prin;
	}

	public void setDir_prin(String dir_prin) {
		this.dir_prin = dir_prin;
	}
	
	public String getLibelleDirPrin() {
		return libelleDirPrin;
	}

	public void setLibelleDirPrin(String libelleDirPrin) {
		this.libelleDirPrin = libelleDirPrin;
	}
	//PPM 59288 fin	

	public String getDp_copi() {
		return dp_copi;
	}

	public void setDp_copi(String dp_copi) {
		this.dp_copi = dp_copi;
	}

	public String getLibelle() {
		return libelle;
	}

	public void setLibelle(String libelle) {
		this.libelle = libelle;
	}

	public String getClicode() {
		return clicode;
	}

	public void setClicode(String clicode) {
		this.clicode = clicode;
	}

	public String getSous_systeme() {
		return sous_systeme;
	}

	public void setSous_systeme(String sous_systeme) {
		this.sous_systeme = sous_systeme;
	}

	public String getDomaine() {
		return domaine;
	}

	public void setDomaine(String domaine) {
		this.domaine = domaine;
	}

	public String getSous_systeme_lib() {
		return sous_systeme_lib;
	}

	public void setSous_systeme_lib(String sous_systeme_lib) {
		this.sous_systeme_lib = sous_systeme_lib;
	}

	public String getDomaine_lib() {
		return domaine_lib;
	}

	public void setDomaine_lib(String domaine_lib) {
		this.domaine_lib = domaine_lib;
	}

	public String getAxe_strategique() {
		return axe_strategique;
	}

	public void setAxe_strategique(String axe_strategique) {
		this.axe_strategique = axe_strategique;
	}

	public String getEtape() {
		return etape;
	}

	public void setEtape(String etape) {
		this.etape = etape;
	}

	public String getTypeFinancement() {
		return typeFinancement;
	}

	public void setTypeFinancement(String typeFinancement) {
		this.typeFinancement = typeFinancement;
	}

	public String getQuote_part() {
		return quote_part;
	}

	public void setQuote_part(String quote_part) {
		this.quote_part = quote_part;
	}

	public String getDpcopiaxemetier() {
		return dpcopiaxemetier;
	}

	public void setDpcopiaxemetier(String dpcopiaxemetier) {
		this.dpcopiaxemetier = dpcopiaxemetier;
	}
}
