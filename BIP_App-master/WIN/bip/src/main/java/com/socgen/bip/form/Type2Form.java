package com.socgen.bip.form;


import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 11/06/2003
 *
 * Formulaire pour mise à jour des Type2 
 * chemin : Administration/Tables/ mise à jour/Type2
 * pages  : fmType2Ad.jsp et mType2Ad.jsp
 * pl/sql : Type2.sql
 */
public class Type2Form extends AutomateForm{
	/*Le code Type2
	*/
	private String arctype ;
	/*Le libelle
	*/
    private String libarc;
    /*Le Top Actif
     */
    private String topActif;
    /*Liste des types 1 rattachés
     */
    private String listeType1;
    /* Liste déroulante de sélection des types 1
     */
    private String lst_Type1;
	/*Le flaglock
	*/
	private int flaglock ;
	
	
	/**
	 * Constructor for Type2Form.
	 */
	public Type2Form() {
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
	 * Returns the arctype.
	 * @return String
	 */
	public String getArctype() {
		return arctype;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the libarc.
	 * @return String
	 */
	public String getLibarc() {
		return libarc;
	}

	/**
	 * Sets the arctype.
	 * @param arctype The arctype to set
	 */
	public void setArctype(String arctype) {
		this.arctype = arctype;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the libarc.
	 * @param libarc The libarc to set
	 */
	public void setLibarc(String libarc) {
		this.libarc = libarc;
	}

	/**
	 * Returns the listeType1.
	 * @return String
	 */
	public String getListeType1() {
		return listeType1;
	}

	/**
	 * Returns the topActif.
	 * @return String
	 */
	public String getTopActif() {
		return topActif;
	}

	/**
	 * Sets the listeType1.
	 * @param listeType1 The listeType1 to set
	 */
	public void setListeType1(String listeType1) {
		this.listeType1 = listeType1;
	}

	/**
	 * Sets the topActif.
	 * @param topActif The topActif to set
	 */
	public void setTopActif(String topActif) {
		this.topActif = topActif;
	}

	/**
	 * Returns the lst_Type1.
	 * @return String
	 */
	public String getLst_Type1() {
		return lst_Type1;
	}

	/**
	 * Sets the lst_Type1.
	 * @param lst_Type1 The lst_Type1 to set
	 */
	public void setLst_Type1(String lst_Type1) {
		this.lst_Type1 = lst_Type1;
	}

}
