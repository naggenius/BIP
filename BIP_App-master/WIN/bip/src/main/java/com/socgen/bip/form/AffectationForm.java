package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

/**
 * @author N.BACCAM - 29/07/2003
 *
 * Formulaire d'affectation des SousTaches à une ressource
 * chemin : Saisie des réalisés/Ressource-Sous tâche
 * pages  : fSoustacheresSr.jsp, bSoustacheresSr.jsp, fAffectationSr.jsp, mAffectationSr.jsp
 * pl/sql : isac_affectation.sql
 */
public class AffectationForm extends SousTacheForm{
	
	/** Numero de serie de la classe. */
	private static final long serialVersionUID = -2195551698982841118L;
	/** Valeur du radio bouton - liste des sous-taches : Toutes. */
	public static final int LISTE_SOUS_TACHES_TOUTES = 1;
	/** Valeur du radio bouton - liste des sous-taches : Les favorites. */
	public static final int LISTE_SOUS_TACHES_FAVORITES = 2;
	/** Valeur du radio bouton - liste des sous-taches : Avec consomme. */
	public static final int LISTE_SOUS_TACHES_AVEC_CONSO = 3;
	
	/** Liste des CODSG. */
	private String[] listeCodsg;
	/** Liste des sous-taches selectionne. */
	private String listeSousTaches;
	
	/** L'identifiant de la ressource. */
	protected String ident;
	/** Le nom de la ressource + identifiant. */
	protected String ressource;

	/**
	 * 1 : Ressources habilitées, affectées et actives
	 * 2 : Ressources affectées sur vos lignes habilitées
	 */
	protected String choix_filtre;
	
     /**
	 * Constructor for ClientForm.
	 */
	public AffectationForm() {
		super();
	}
	
   /**
	 * {@inheritDoc}
	 */
	@Override
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		final HttpSession session = request.getSession(false);
		if (session.getAttribute("LISTECODSG") != null) {
			// L'attribut "listeCodsgString" est present dans la session
			listeCodsg = ((String) session.getAttribute("LISTECODSG")).split(",");
			session.removeAttribute("LISTECODSG");
		}
		if (session.getAttribute("RESSOURCE") != null) {
			// L'attribut "ressource" est present dans la session
			ressource = (String) session.getAttribute("RESSOURCE");
			session.removeAttribute("RESSOURCE");
		}
		if (session.getAttribute("LISTESOUSTACHES") != null) {
			// L'attribut "listeSousTaches" est present dans la session
			listeSousTaches = (String) session.getAttribute("LISTESOUSTACHES");
			session.removeAttribute("LISTESOUSTACHES");
		} else {
			// Selection par defaut
			listeSousTaches = String.valueOf(LISTE_SOUS_TACHES_TOUTES);
		}
	}

	/**
	 * Validate the properties that have been set from this HTTP request, and
	 * return an <code>ActionErrors</code> object that encapsulates any
	 * validation errors that have been found. If no errors are found, return
	 * <code>null</code> or an <code>ActionErrors</code> object with no
	 * recorded error messages.
	 * 
	 * @param mapping
	 *            The mapping used to select this instance
	 * @param request
	 *            The servlet request we are processing
	 */
    public ActionErrors validate(ActionMapping mapping,
                                 HttpServletRequest request) {


        ActionErrors errors = new ActionErrors();
        
        this.logIhm.debug("Début validation de la form -> " + this.getClass()) ;
   
 
        logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
        return errors; 
    }
	
    public void setListeCodsgString(String codsg) {
    	if (codsg != null && codsg.length() > 0) {
    		listeCodsg = codsg.split(",");
    	}
    }
    
    public String getListeCodsgString() {
    	final StringBuilder listeCodsgString = new StringBuilder();
    	if (listeCodsg != null) {
	    	for (String codsg : listeCodsg) {
	    		listeCodsgString.append(codsg);
	    		if (!codsg.equals(listeCodsg[listeCodsg.length - 1])) {
	    			listeCodsgString.append(",");
	    		}
	    	}
    	}
    	return listeCodsgString.toString();
    }
	
	/**
	 * @return the listeCodsg
	 */
	public String[] getListeCodsg() {
		return listeCodsg;
	}

	/**
	 * @param listeCodsg
	 *            the listeCodsg to set
	 */
	public void setListeCodsg(String[] listeCodsg) {
		this.listeCodsg = listeCodsg;
	}

	/**
	 * @return the listeSousTaches
	 */
	public String getListeSousTaches() {
		return listeSousTaches;
	}

	/**
	 * @param listeSousTaches
	 *            the listeSousTaches to set
	 */
	public void setListeSousTaches(String listeSousTaches) {
		this.listeSousTaches = listeSousTaches;
	}

	/**
	 * Returns the ident.
	 * @return String
	 */
	public String getIdent() {
		return ident;
	}

	/**
	 * Sets the ident.
	 * @param ident The ident to set
	 */
	public void setIdent(String ident) {
		this.ident = ident;
	}


	/**
	 * Returns the ressource.
	 * @return String
	 */
	public String getRessource() {
		return ressource;
	}

	/**
	 * Sets the ressource.
	 * @param ressource The ressource to set
	 */
	public void setRessource(String ressource) {
		this.ressource = ressource;
	}

	public String getChoix_filtre() {
		return choix_filtre;
	}

	public void setChoix_filtre(String choix_filtre) {
		this.choix_filtre = choix_filtre;
	}



}
