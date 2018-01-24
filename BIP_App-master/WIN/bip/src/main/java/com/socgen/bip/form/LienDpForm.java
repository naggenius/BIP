package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author MMC - 26/05/2003
 *
 * Formulaire pour Lien Dossier Projet
 * pages : fLienDpAd.jsp, mLienDpAd.jsp
 */
public class LienDpForm extends AutomateForm{
	/*Le code dossier projet
	*/
	private String dpcode ;
	
    /*Le libellé
	*/
	private String dplib ;
	
	/*Le pid de la ligne bip
	 */
private String pid ;
	private String pid_1 ;
	private String pid_2 ;
	private String pid_3 ;
	private String pid_4 ;
	private String pid_5 ;
	private String pid_6 ;
	
	/*Le libelle de la ligne bip
	 */
private String pnom ;
	private String pnom_1 ;
	private String pnom_2 ;
	private String pnom_3 ;
	private String pnom_4 ;
	private String pnom_5 ;
	private String pnom_6 ;
	/*Le flaglock
	*/
	private int flaglock ;
	
	private int flaglock_1 ;
	private int flaglock_2 ;
	private int flaglock_3 ;
	private int flaglock_4 ;
	private int flaglock_5 ;
	private int flaglock_6 ;
	/**
	 * Constructor 
	 */
	public LienDpForm() {
		super();
	}

	/**
	 * Returns 
	 * @return String
	 */
	public String getDpcode() {
		return dpcode;
	}


	/**
	 * Returns 
	 * @return String
	 */
	public String getDplib() {
		return dplib;
	}

	/**
	 * Returns
	 * @return String
	 */
	public String getPid() {
		return pid;
	}
	public String getPid_1() {
		return pid_1;
	}
	public String getPid_2() {
		return pid_2;
	}
	public String getPid_3() {
		return pid_3;
	}
	public String getPid_4() {
		return pid_4;
	}
	public String getPid_5() {
		return pid_5;
	}
	public String getPid_6() {
		return pid_6;
	}

/**
	 * Returns
	 * @return String
	 */
public String getPnom() {
		return pnom;
	}
	public String getPnom_1() {
		return pnom_1;
	}
	public String getPnom_2() {
		return pnom_2;
	}
	public String getPnom_3() {
		return pnom_3;
	}
	public String getPnom_4() {
		return pnom_4;
	}
	public String getPnom_5() {
		return pnom_5;
	}
	public String getPnom_6() {
		return pnom_6;
	}
		/**
	 * Sets 
	 * @param 
	 */
	public void setDpcode(String dpcode) {
		this.dpcode = dpcode;
	}


	/**
	 * 
	 */
	public void setDplib(String dplib) {
		this.dplib = dplib;
	}

	/**
	 * set pid
	 */
	public void setPid(String pid) {
		this.pid = pid;
	}
	public void setPid_1(String pid_1) {
		this.pid_1 = pid_1;
	}
	public void setPid_2(String pid_2) {
		this.pid_2 = pid_2;
	}
	public void setPid_3(String pid_3) {
		this.pid_3 = pid_3;
	}
	public void setPid_4(String pid_4) {
		this.pid_4 = pid_4;
	}
	public void setPid_5(String pid_5) {
		this.pid_5 = pid_5;
	}
	public void setPid_6(String pid_6) {
		this.pid_6 = pid_6;
	}
	
	/**
	 * set pnom
	 */
	public void setPnom(String pnom) {
		this.pnom = pnom;
	}
	public void setPnom_1(String pnom_1) {
		this.pnom_1 = pnom_1;
	}
	public void setPnom_2(String pnom_2) {
		this.pnom_2 = pnom_2;
	}
	public void setPnom_3(String pnom_3) {
		this.pnom_3 = pnom_3;
	}
	public void setPnom_4(String pnom_4) {
		this.pnom_4 = pnom_4;
	}
	public void setPnom_5(String pnom_5) {
		this.pnom_5 = pnom_5;
	}
	public void setPnom_6(String pnom_6) {
		this.pnom_6 = pnom_6;
	}
	
	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}
	
	public void setFlaglock_1(int flaglock_1) {
		this.flaglock_1 = flaglock_1;
	}
	public void setFlaglock_2(int flaglock_2) {
		this.flaglock_2 = flaglock_2;
	}
	public void setFlaglock_3(int flaglock_3) {
		this.flaglock_3 = flaglock_3;
	}
	public void setFlaglock_4(int flaglock_4) {
		this.flaglock_4 = flaglock_4;
	}
	public void setFlaglock_5(int flaglock_5) {
		this.flaglock_5 = flaglock_5;
	}
	public void setFlaglock_6(int flaglock_6) {
		this.flaglock_6 = flaglock_6;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

public int getFlaglock_1() {
		return flaglock_1;
	}
public int getFlaglock_2() {
		return flaglock_2;
	}
public int getFlaglock_3() {
		return flaglock_3;
	}
public int getFlaglock_4() {
		return flaglock_4;
	}
public int getFlaglock_5() {
		return flaglock_5;
	}
public int getFlaglock_6() {
		return flaglock_6;
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
	
}