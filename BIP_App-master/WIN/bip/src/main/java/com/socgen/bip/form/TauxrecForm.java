package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 18/06/2003
 *
 * Formulaire pour mise à jour des Taux de récupération
 * chemin : Administration/Tables/ mise à jour/Taux de récupération
 * pages  : fmTauxrecAd.jsp et mTauxrecAd.jsp
 * pl/sql : Txrecup.sql
 * 13/11/2003 NBM: ajout taux de charge salariale
 */
public class TauxrecForm extends AutomateForm{

	/*L'année 
	*/
	private String annee ;
	/*Le code filiale
	*/
	private String filcode ;
    /*Le taux de récupération
	*/
	private String taux_rec ;
	/*Le taux de charge salariale
	*/
	private String taux_sal ;
	/*Le flaglock
	*/
	private int flaglock ;
	
	/**
	 * Constructor for TauxrecForm.
	 */
	public TauxrecForm() {
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
	 * Returns the annee.
	 * @return String
	 */
	public String getAnnee() {
		return annee;
	}
	/**
	 * Returns the filcode.
	 * @return String
	 */
	public String getFilcode() {
		return filcode;
	}


	/**
	 * Sets the annee.
	 * @param annee The annee to set
	 */
	public void setAnnee(String annee) {
		this.annee = annee;
	}

	/**
		 * Sets the filcode.
		 * @param annee The filcode to set
		 */
		public void setFilcode(String filcode) {
			this.filcode = filcode;
		}


	/**
	 * Returns the taux_rec.
	 * @return String
	 */
	public String getTaux_rec() {
		return taux_rec;
	}

	/**
	 * Returns the taux_sal.
	 * @return String
	 */
	public String getTaux_sal() {
		return taux_sal;
	}

	/**
	 * Sets the taux_rec.
	 * @param taux_rec The taux_rec to set
	 */
	public void setTaux_rec(String taux_rec) {
		this.taux_rec = taux_rec;
	}

	/**
	 * Sets the taux_sal.
	 * @param taux_sal The taux_sal to set
	 */
	public void setTaux_sal(String taux_sal) {
		this.taux_sal = taux_sal;
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
