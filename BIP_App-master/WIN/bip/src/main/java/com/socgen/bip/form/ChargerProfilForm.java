package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 20/06/2003
 *
 * Formulaire pour mise à jour des Personnes
 * chemin : Ressources/ mise à jour/Personne
 * pages  : bPersonneAd.jsp et mPersonneAd.jsp
 * pl/sql : resper.sql
 */


public class ChargerProfilForm extends AutomateForm{

	/*Le code Personne
	*/
	protected String ident ;
	/*Début Nom
	*/
	protected String debnom;
	/*Nom contient
	*/
	protected String nomcont;
	/*Le nom de la Personne
	*/
	private String nom ;
	/*Le prénom de la Personne
	*/   
	private String prenom ;
	/*Le matricule de la Personne
	*/ 
	private String user_rtfe ;
	
	/*Le nombre de résultat renvoyés par la recherche
	 */	
	private String count;


	/**
	 * Constructor for ClientForm.
	 */
	public ChargerProfilForm() {
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
	 * Returns the ident.
	 * @return String
	 */
	public String getIdent() {
		return ident;
	}

	/**
	 * Returns the matricule.
	 * @return String
	 */
	public String getUser_rtfe() {
		return user_rtfe;
	}

	

	/**
	 * Returns the rnom.
	 * @return String
	 */
	public String getNom() {
		return nom;
	}

	/**
	 * Returns the rprenom.
	 * @return String
	 */
	public String getPrenom() {
		return prenom;
	}

	

	/**
	 * Sets the ident.
	 * @param ident The ident to set
	 */
	public void setIdent(String ident) {
		this.ident = ident;
	}

	/**
	 * Sets the matricule.
	 * @param matricule The matricule to set
	 */
	public void setUser_rtfe(String matricule) {
		this.user_rtfe = matricule;
	}

	
	/**
	 * Sets the rnom.
	 * @param rnom The rnom to set
	 */
	public void setNom(String rnom) {
		this.nom = rnom;
	}

	/**
	 * Sets the rprenom.
	 * @param rprenom The rprenom to set
	 */
	public void setPrenom(String rprenom) {
		this.prenom = rprenom;
	}
	
	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}

	public String getDebnom() {
		return debnom;
	}

	public void setDebnom(String debnom) {
		this.debnom = debnom;
	}

	public String getNomcont() {
		return nomcont;
	}

	public void setNomcont(String nomcont) {
		this.nomcont = nomcont;
	}


}
