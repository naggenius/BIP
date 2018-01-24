package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;



/**
 * @author N.BACCAM - 18/06/2003
 *
 * Formulaire pour mise à jour des dossiers projet
 * chemin : Administration/Référentiels/Dossiers projet
 * pages  : fmDossierprojAd.jsp et mDossierprojAd.jsp
 * pl/sql : dos_proj.sql
 */
public class DossierprojForm extends AutomateForm{

 
	/*Le code dossier projet
	*/   
    private String dpcode; 
 
    /*Le libellé
	*/  
    private String dplib; ;    
   
    //PPM 59288 debut
    /*
     * Le code de direction principale
     */
    private String dir_prin;    
    /*
     * Le libelle de "branche : direction"
     */
    private String libelleDirPrin;

    //Fin PPM 59288
    
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
	/**
	 * Constructor for ClientForm.
	 */
	public DossierprojForm() {
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
}
