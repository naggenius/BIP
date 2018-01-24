package com.socgen.bip.form;


import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author P. JOSSE - 16/11/2004
 *
 * Formulaire pour mise à jour des Paramètres de la BIP
 * chemin : Administration/Surveillance/Etat BIP
 * pages  : fmParametreAd.jsp et mParametreAd.jsp
 * pl/sql : parametre.sql
 */
public class ParametreForm extends AutomateForm{
	/*La clé du paramètre
	*/
	private String cle_param ;
	/*La valeur du paramètre
	*/
    private String valeur_param;

	private String libelle_param;
	private String listeValeurs_param;
	/**
	 * Constructor for ParametreForm.
	 */
	public ParametreForm() {
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
	 * @return
	 */
	public String getCle_param() {
		return cle_param;
	}

	/**
	 * @return
	 */
	public String getValeur_param() {
		return valeur_param;
	}

	/**
	 * @param string
	 */
	public void setCle_param(String string) {
		cle_param = string;
	}

	/**
	 * @param string
	 */
	public void setValeur_param(String string) {
		valeur_param = string;
	}

	/**
	 * @return
	 */
	public String getLibelle()
	{
		return libelle_param;
	}

	/**
	 * @return
	 */
	public String getListeValeurs()
	{
		return listeValeurs_param;
	}

	/**
	 * @param string
	 */
	public void setLibelle(String string)
	{
		libelle_param = string;
	}

	/**
	 * @param string
	 */
	public void setListeValeurs(String string)
	{
		listeValeurs_param = string;
	}

}