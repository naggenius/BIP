package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author MMC - 18/07/2003
 *
 * Consultation Statut
 * chemin : Gestionnaire/Immos/Consultation statut
 * pages  : bConsulStatutGe.jsp 
 * pl/sql : amortst.sql
 */
public class ConsulStatutForm extends AutomateForm {

	/*pid
	*/
	private String pid ;
	/*filsigle
	*/
	private String filsigle ;
	/*pnom
	*/
	private String pnom ;
	/*libstatut
	*/
	private String libstatut ;
	/*adatestatut
	*/
	private String adatestatut ;
	/*flaglock
	*/
	private int flaglock ;
	
	public ActionErrors validate(ActionMapping mapping,
                                 HttpServletRequest request) {


        ActionErrors errors = new ActionErrors();
        
        this.logIhm.debug("Début validation de la form -> " + this.getClass()) ;
     
        logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
        return errors; 
    }
	
	/**
	 * Constructor for ConsulStatutForm.
	 */
	public ConsulStatutForm() {
		super();
	}

	/**
	 * Returns the adatestatut.
	 * @return String
	 */
	public String getAdatestatut() {
		return adatestatut;
	}

	/**
	 * Returns the filsigle.
	 * @return String
	 */
	public String getFilsigle() {
		return filsigle;
	}

	
	/**
	 * Returns the libstatut.
	 * @return String
	 */
	public String getLibstatut() {
		return libstatut;
	}

	/**
	 * Returns the pid.
	 * @return String
	 */
	public String getPid() {
		return pid;
	}

	/**
	 * Returns the pnom.
	 * @return String
	 */
	public String getPnom() {
		return pnom;
	}

	/**
	 * Sets the adatestatut.
	 * @param adatestatut The adatestatut to set
	 */
	public void setAdatestatut(String adatestatut) {
		this.adatestatut = adatestatut;
	}

	/**
	 * Sets the filsigle.
	 * @param filsigle The filsigle to set
	 */
	public void setFilsigle(String filsigle) {
		this.filsigle = filsigle;
	}

	

	/**
	 * Sets the libstatut.
	 * @param libstatut The libstatut to set
	 */
	public void setLibstatut(String libstatut) {
		this.libstatut = libstatut;
	}

	/**
	 * Sets the pid.
	 * @param pid The pid to set
	 */
	public void setPid(String pid) {
		this.pid = pid;
	}

	/**
	 * Sets the pnom.
	 * @param pnom The pnom to set
	 */
	public void setPnom(String pnom) {
		this.pnom = pnom;
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


                