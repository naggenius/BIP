package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author MMC - 25/06/2003
 *
 * Formulaire pour notification des budgets
 * pages : fNotificationAd.jsp, mNotificationAd.jsp
 */
public class NotificationForm extends AutomateForm{
	/**code direction
	*/
	private String clidom ;
	
	/**metier
		*/
		private String metier ;
    
	/**dossier projet			*/
			private String dpcode ;
	/**code projet			*/
				private String icpi ;
				
	/** direction client			*/
					private String dirmo ;
	private String dirmo_entier ;
	private String dirmo_partie ;
	private String code_mo ;
	private String choix_client ;
	
	/** direction fournisseur			*/
						private String dirme ;
									
    /**Le code dep ou pole ME
	*/
	private String deppole ;
	
	/**Le type projet
	*/
	private String typeprojet ;
	
	private String test ;
	
private String	TYPE_INIT;

	/**Le flaglock
	*/
	private int flaglock ;
	
	/**
	 * HPPM 58337 : KRA - le nombre des notifications mises à jour
	 */
	private int nbNotif = -1;
	/**
	 * Constructor 
	 */
	public NotificationForm() {
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
	
	public String getClidom() {
		return clidom;
	}

	public String getDeppole() {
		return deppole;
	}

public String getTest() {
		return test;
	}
	
	public String getType_init() {
		return TYPE_INIT;
	}
	
	public String getTypeprojet() {
		return typeprojet;
	}
	
	public void setDeppole(String deppole) {
		this.deppole = deppole;
	}

	public void setClidom(String clidom) {
		this.clidom = clidom;
	}

public void setTest(String test) {
		this.test = test;
	}
	public void setType_init(String TYPE_INIT) {
		this.TYPE_INIT = TYPE_INIT;
	}
	
	public void setTypeprojet(String typeprojet) {
		this.typeprojet = typeprojet;
	}

		
	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * @return
	 */
	public String getMetier() {
		return metier;
	}

	/**
	 * @param string
	 */
	public void setMetier(String string) {
		metier = string;
	}

	/**
	 * @return
	 */
	public String getDpcode() {
		return dpcode;
	}

	/**
	 * @param string
	 */
	public void setDpcode(String string) {
		dpcode = string;
	}

	/**
	 * @return
	 */
	public String getIcpi() {
		return icpi;
	}

	/**
	 * @param string
	 */
	public void setIcpi(String string) {
		icpi = string;
	}

	/**
	 * @return
	 */
	public String getDirmo() {
		return dirmo;
	}

	/**
	 * @param string
	 */
	public void setDirmo(String string) {
		dirmo = string;
	}

	/**
	 * @return
	 */
	public String getDirme() {
		return dirme;
	}

	/**
	 * @param string
	 */
	public void setDirme(String string) {
		dirme = string;
	}

	/**
	 * @return
	 */
	public String getDirmo_entier() {
		return dirmo_entier;
	}

	/**
	 * @return
	 */
	public String getDirmo_partie() {
		return dirmo_partie;
	}

	/**
	 * @param string
	 */
	public void setDirmo_entier(String string) {
		dirmo_entier = string;
	}

	/**
	 * @param string
	 */
	public void setDirmo_partie(String string) {
		dirmo_partie = string;
	}

	/**
	 * @return
	 */
	public String getCode_mo() {
		return code_mo;
	}

	/**
	 * @param string
	 */
	public void setCode_mo(String string) {
		code_mo = string;
	}

	/**
	 * @return
	 */
	public String getChoix_client() {
		return choix_client;
	}

	/**
	 * @param string
	 */
	public void setChoix_client(String string) {
		choix_client = string;
	}

	public int getNbNotif() {
		return nbNotif;
	}

	public void setNbNotif(int nbNotif) {
		this.nbNotif = nbNotif;
	}

}
