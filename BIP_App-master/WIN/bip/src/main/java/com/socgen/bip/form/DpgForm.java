package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;


/**
 * @author N.BACCAM - 13/06/2003
 *
 * Action de mise à jour des Dpgs 
 * chemin : Administration/Tables/ mise à jour/Dpg
 * pages  : fmDpgAd.jsp et mDpgAd.jsp
 * pl/sql : struct.sql
 * 
 * MAJ : JAL 25-04-2007 : rajout matricule
 * 
 */
public class DpgForm extends AutomateForm {

	/*Le code DPG
	*/
	private String codsg ;
	
	/*La branche/direction 
	*/
	private String coddir;
	
	/*Le sigle département
	*/
	private String sigdep;
	
	/*Le sigle pôle
	*/
	private String sigpole;
	
	/*Le libellé du DPG 
	*/
	private String libdsg;
	
	/*Le nom du responsable
	*/
	private String gnom;
	
	/*
	 * Le Matricule du responsable
	 */
	private String matricule;
	
	/*Le centre d'activité
	*/
	private String centractiv;
	
	/*Le CA FI
	*/
	private String cafi;
	
	/*Le code filiale
	*/
	private String filcode;
	
	/*Le code centre de frais
	*/
	private String scentrefrais;
	
	/*Le top fermeture (O/F)
	*/
	private String topfer;
	/*Le flaglock
	*/
	private int flaglock ;

	/*Identifiant Ressource GDM rattaché
	*/
	private String identgdm;
	
	/*Le top diva (O/F)
	*/
	private String top_diva;
	
	/*Le top diva (O/F)
	*/
	private String top_diva_int;
	
	private String datFerm;
	
	
	/**
	 * La vérification de la validité du matricule (appel serveur : DpgAction) a lieu à chaque fois l'utilisateur quitte le champ 
	 * matricule (onblur Javascript) de l'écran de modif/création Dpg.
	 * Il ne faut pas l'effectuer inutilement lorsque la valeur vient d'être changée par un matricule valide
	 * issu de la popup de recherche de matricules.  
	 * Si la variable flagRetourRechercheMatricule est présente et a pour valeur = 'O' dans le form  
	 * cela signifie que le le onlbur Javascript a lieu juste aprés l'appel à la popup recherche matricules
	 * et que l'on ne doit pas appeller un refresh de l'action.
	 * (le refresh de DpgAction est utilisé pour la vérification de validité du matricule)    
	 * 
	 * 
	 * 
	 */
	private String flagRetourRechercheMatricule ; 
	
	
	/**
	 * Constructor for DpgForm.
	 */
	public DpgForm() {
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
        // errors.add("Test" , new ActionError("errors.header"));
        logIhm.debug( "Fin validation de la form -> " + this.getClass()) ;
        return errors; 
    }


	/**
	 * Returns the cafi.
	 * @return String
	 */
	public String getCafi() {
		return cafi;
	}

	/**
	 * Returns the centractiv.
	 * @return String
	 */
	public String getCentractiv() {
		return centractiv;
	}

	/**
	 * Returns the coddir.
	 * @return String
	 */
	public String getCoddir() {
		return coddir;
	}

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * Returns the filcode.
	 * @return String
	 */
	public String getFilcode() {
		return filcode;
	}

	/**
	 * Returns the gnom.
	 * @return String
	 */
	public String getGnom() {
		return gnom;
	}

	/**
	 * Returns the libdsg.
	 * @return String
	 */
	public String getLibdsg() {
		return libdsg;
	}

	/**
	 * Returns the scentrefrais.
	 * @return String
	 */
	public String getScentrefrais() {
		return scentrefrais;
	}

	/**
	 * Returns the sigdep.
	 * @return String
	 */
	public String getSigdep() {
		return sigdep;
	}

	/**
	 * Returns the sigpole.
	 * @return String
	 */
	public String getSigpole() {
		return sigpole;
	}

	/**
	 * Returns the topfer.
	 * @return String
	 */
	public String getTopfer() {
		return topfer;
	}
	/**
	 * Returns the top_diva.
	 * @return String
	 */
	public String getTop_diva() {
		return top_diva;
	}
	/**
	 * Sets the cafi.
	 * @param cafi The cafi to set
	 */
	public void setCafi(String cafi) {
		this.cafi = cafi;
	}

	/**
	 * Sets the centractiv.
	 * @param centractiv The centractiv to set
	 */
	public void setCentractiv(String centractiv) {
		this.centractiv = centractiv;
	}

	/**
	 * Sets the coddir.
	 * @param coddir The coddir to set
	 */
	public void setCoddir(String coddir) {
		this.coddir = coddir;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Sets the filcode.
	 * @param filcode The filcode to set
	 */
	public void setFilcode(String filcode) {
		this.filcode = filcode;
	}

	/**
	 * Sets the gnom.
	 * @param gnom The gnom to set
	 */
	public void setGnom(String gnom) {
		this.gnom = gnom;
	}

	/**
	 * Sets the libdsg.
	 * @param libdsg The libdsg to set
	 */
	public void setLibdsg(String libdsg) {
		this.libdsg = libdsg;
	}

	/**
	 * Sets the scentrefrais.
	 * @param scentrefrais The scentrefrais to set
	 */
	public void setScentrefrais(String scentrefrais) {
		this.scentrefrais = scentrefrais;
	}

	/**
	 * Sets the sigdep.
	 * @param sigdep The sigdep to set
	 */
	public void setSigdep(String sigdep) {
		this.sigdep = sigdep;
	}

	/**
	 * Sets the sigpole.
	 * @param sigpole The sigpole to set
	 */
	public void setSigpole(String sigpole) {
		this.sigpole = sigpole;
	}

	/**
	 * Sets the topfer.
	 * @param topfer The topfer to set
	 */
	public void setTopfer(String topfer) {
		this.topfer = topfer;
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

	/**
	 * @return
	 */
	public String getIdentgdm() {
		return identgdm;
	}

	/**
	 * @param string
	 */
	public void setIdentgdm(String string) {
		identgdm = string;
	}
	/**
	 * Sets the top_diva.
	 * @param top_diva The top_diva to set
	 */
	public void setTop_diva(String top_diva) {
		this.top_diva = top_diva;
	}

	/**
	 * 
	 * @return
	 */
	public String getMatricule() {
		return this.matricule;
	}

	/**
	 * 
	 * @param pmatricule
	 */
	public void setMatricule(String pmatricule) {
		this.matricule = pmatricule;
	}

	public String getTop_diva_int() {
		return top_diva_int;
	}

	public void setTop_diva_int(String top_diva_int) {
		this.top_diva_int = top_diva_int;
	}
	
	/**
	 * 
	 * @return
	 */
	public String getFlagRetourRechercheMatricule() {
		return this.flagRetourRechercheMatricule;
	}
	
	/**
	 * @return the datFerm
	 */
	public String getDatFerm() {
		return datFerm;
	}

	/**
	 * @param datFerm the datFerm to set
	 */
	public void setDatFerm(String datFerm) {
		this.datFerm = datFerm;
	}

	/**
	 * 
	 * @param flagRetourRechercheMatricule
	 */
	public void setFlagRetourRechercheMatricule(String flagRetourRechercheMatricule) {
		this.flagRetourRechercheMatricule = flagRetourRechercheMatricule;
	}

}
