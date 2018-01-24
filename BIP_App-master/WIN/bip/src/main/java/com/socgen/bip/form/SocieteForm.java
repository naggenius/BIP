package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 28/05/2003
 *
 * Formulaire pour mise à jour des societes
 * chemin : Administration/Tables/ mise à jour/Societe
 * pages  : bSocieteAd.jsp et mSocieteAd.jsp
 * pl/sql : societe.sql
 */
public class SocieteForm extends AutomateForm{
	/*Le code societe
	*/
	protected String soccode ;
	/*Le libelle de la societe
	*/
	protected String lib_soccode ;
	/*Le groupe de la societe
	*/
	protected String socgrpe ;
    /*Le libelle de la societe
	*/
	private String soclib ;
	/*La nature de la societe
	*/   
    private String socnat ;    
    /*La catégorie de la societe
	*/ 
	private String soccat ;
	/*La date de création
	*/ 			   
	private String soccre ;      
	/*La date de fermeture lors du changement de société
	*/ 			   
	private String socfer_ch ;  
	/*Le code de la nouvelle société
	*/ 			   
	private String socnou ; 
	/*Le commentaire du changement
	*/
	private String	soccop ;
	/*La date de fermeture provisoire de société
	*/ 			   
	private String	socfer_cl ;
	/*Le commentaire de la fermeture provisoire
	*/
	private String	soccom ;
	/*Le flaglock
	*/
	private int flaglock ;
	 /*KeyList0: sert pour la formation de la liste des fournisseurs
	  * 
	*/
	
	private String siren;
	
	private String toppresence;
	
    protected String keyList0 ;  
 			
	/**
	 * Constructor for ClientForm.
	 */
	public SocieteForm() {
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
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the keyList0.
	 * @return String
	 */
	public String getKeyList0() {
		return keyList0;
	}

	/**
	 * Returns the soccat.
	 * @return String
	 */
	public String getSoccat() {
		return soccat;
	}

	/**
	 * Returns the soccode.
	 * @return String
	 */
	public String getSoccode() {
		return soccode;
	}

	/**
	 * Returns the soccom.
	 * @return String
	 */
	public String getSoccom() {
		return soccom;
	}

	/**
	 * Returns the soccop.
	 * @return String
	 */
	public String getSoccop() {
		return soccop;
	}

	/**
	 * Returns the soccre.
	 * @return String
	 */
	public String getSoccre() {
		return soccre;
	}

	/**
	 * Returns the socfer_ch.
	 * @return String
	 */
	public String getSocfer_ch() {
		return socfer_ch;
	}

	/**
	 * Returns the socfer_cl.
	 * @return String
	 */
	public String getSocfer_cl() {
		return socfer_cl;
	}

	/**
	 * Returns the soclib.
	 * @return String
	 */
	public String getSoclib() {
		return soclib;
	}

	/**
	 * Returns the socnat.
	 * @return String
	 */
	public String getSocnat() {
		return socnat;
	}

	/**
	 * Returns the socnou.
	 * @return String
	 */
	public String getSocnou() {
		return socnou;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the keyList0.
	 * @param keyList0 The keyList0 to set
	 */
	public void setKeyList0(String keyList0) {
		this.keyList0 = keyList0;
	}

	/**
	 * Sets the soccat.
	 * @param soccat The soccat to set
	 */
	public void setSoccat(String soccat) {
		this.soccat = soccat;
	}

	/**
	 * Sets the soccode.
	 * @param soccode The soccode to set
	 */
	public void setSoccode(String soccode) {
		this.soccode = soccode;
	}

	/**
	 * Sets the soccom.
	 * @param soccom The soccom to set
	 */
	public void setSoccom(String soccom) {
		this.soccom = soccom;
	}

	/**
	 * Sets the soccop.
	 * @param soccop The soccop to set
	 */
	public void setSoccop(String soccop) {
		this.soccop = soccop;
	}

	/**
	 * Sets the soccre.
	 * @param soccre The soccre to set
	 */
	public void setSoccre(String soccre) {
		this.soccre = soccre;
	}

	/**
	 * Sets the socfer_ch.
	 * @param socfer_ch The socfer_ch to set
	 */
	public void setSocfer_ch(String socfer_ch) {
		this.socfer_ch = socfer_ch;
	}

	/**
	 * Sets the socfer_cl.
	 * @param socfer_cl The socfer_cl to set
	 */
	public void setSocfer_cl(String socfer_cl) {
		this.socfer_cl = socfer_cl;
	}

	/**
	 * Sets the soclib.
	 * @param soclib The soclib to set
	 */
	public void setSoclib(String soclib) {
		this.soclib = soclib;
	}

	/**
	 * Sets the socnat.
	 * @param socnat The socnat to set
	 */
	public void setSocnat(String socnat) {
		this.socnat = socnat;
	}

	/**
	 * Sets the socnou.
	 * @param socnou The socnou to set
	 */
	public void setSocnou(String socnou) {
		this.socnou = socnou;
	}

	public String getSocgrpe() {
		return socgrpe;
	}

	public void setSocgrpe(String socgrpe) {
		this.socgrpe = socgrpe;
	}

	public String getLib_soccode() {
		return lib_soccode;
	}

	public void setLib_soccode(String lib_soccode) {
		this.lib_soccode = lib_soccode;
	}

	public String getSiren() {
		return siren;
	}

	public void setSiren(String siren) {
		this.siren = siren;
	}

	public String getToppresence() {
		return toppresence;
	}

	public void setToppresence(String toppresence) {
		this.toppresence = toppresence;
	}
	
	
}
