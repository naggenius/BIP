package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 29/09/2003
 *
 * Formulaire de copie de la structure d'une ligne BIP
 * chemin : Saisie des réalisés/Copie de structure
 * pages  : fCopieStructSr.jsp
 * pl/sql : isac_copie.sql
 */
public class CopieStructureForm extends AutomateForm{
	/*La ligne à copier
	*/
	private String pid1;
	/*La ligne à remplir
	*/
	private String pid2;
	
	/*Affectation des ressources (OUI, NON ou AVEC)
	*/
	private String affecter;
	
	/*Le mois pour le déplacement des consommés pour le cas 
	  où affecter = AVEC*/
	private String mois;
	
	
	
     /**
	 * Constructor for ClientForm.
	 */
	public CopieStructureForm() {
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
	 * Returns the pid1.
	 * @return String
	 */
	public String getPid1() {
		return pid1;
	}

	/**
	 * Returns the pid2.
	 * @return String
	 */
	public String getPid2() {
		return pid2;
	}
	
	/**
	 * Returns the affecter.
	 * @return String
	 */
	public String getAffecter() {
			return affecter;
	}
	
	/**
	 * Returns the mois.
	 * @return int
	 */
	public String getMois() {
			return mois;
	}
	

	/**
	 * Sets the pid1.
	 * @param pid1 The pid1 to set
	 */
	public void setPid1(String pid1) {
		this.pid1 = pid1;
	}

	/**
	 * Sets the pid2.
	 * @param pid2 The pid2 to set
	 */
	public void setPid2(String pid2) {
		this.pid2 = pid2;
	}
	
	/**
	 * Sets the affecter.
	 * @param pid2 The affecter to set
	 */
	public void setAffecter(String affecter) {
			this.affecter = affecter;
	}
	
	/**
	 * Sets the mois.
	 * @param  The mois to set
	 */
	public void setMois(String mois) {
			this.mois = mois;
	}

}
