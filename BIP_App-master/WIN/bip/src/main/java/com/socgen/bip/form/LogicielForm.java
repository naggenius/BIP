
package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 24/06/2003
 *
 * Formulaire pour mise à jour des Logiciels
 * chemin : Ressources/ mise à jour/Logiciels
 * pages  : bLogicielAd.jsp et mLogicielAd.jsp
 * pl/sql : reslog.sql
 */
public class LogicielForm extends AutomateForm{
	//rnom:1;2:codsg:1;3:soccode:1;4:filcode:1;5:datsitu:1;6:cout:1;7:cpident:1;8:coutot:1;9:flaglock:
	//oldatsitu:1;2:ident:1;3:coulog:1;4:rnom:1;5:coutot:1;6:datsitu:1;7:datdep:1;8:codsg:1;9:filcode:1;10:soccode:1;11:prestation:1;12:cpident:1;13:cout:1;14:flaglock:
	/*Le code Logiciel
	*/
	protected String ident ;
    /*Le libelle du Logiciel
	*/
	private String rnom ;
	/*Le cout du logiciel
	*/   
    private String coulog ;    
    /*Le cout total
	*/ 
	private String coutot ;
	/*La date de situ
	*/ 			   
	private String datsitu ;      
	/*La date de fin
	*/ 			   
	private String datdep ;  
	/*L 'ancienne date de situ
	*/ 			   
	private String oldatsitu ; 
	/*Le code DPG
	*/
	private String	codsg ;

	/*La societe
	*/
	private String	soccode ;
	/*Le siren
	*/
	private String	lib_siren ;
	/*Le libelle de la societe
	*/
	private String	lib_soccode ;
	/*Le domaine
	*/ 			   
	private String code_domaine ;
	/*La prestation
	*/ 			   
	private String prestation ; 
	/*Le mode contractuel
	*/ 			   
	private String modeContractuelInd ; 
	/*mciObligatoire: sert pour indiquer dans le formulaire que le mci est obligatoire pour le dpg
	*/
	private String mciObligatoire;
	/*Le code chef de projet
	*/
	private String	cpident ;
	/*Le flaglock
	*/
	private int flaglock ;
	
	/*Le type ressource
	*/
	private String	rtype ;
	
	/*Le libelle type ressource
	*/
	private String	lib_rtype ;
	 /*KeyList0: sert pour la formation de la liste des dates de situ
	*/   
    protected String keyList0 ;  
    
    private String lib_mci;
 			
	/**
	 * Constructor for ClientForm.
	 */
	public LogicielForm() {
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
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * Returns the coulog.
	 * @return String
	 */
	public String getCoulog() {
		return coulog;
	}


	/**
	 * Returns the coutot.
	 * @return String
	 */
	public String getCoutot() {
		return coutot;
	}

	/**
	 * Returns the cpident.
	 * @return String
	 */
	public String getCpident() {
		return cpident;
	}

	/**
	 * Returns the datdep.
	 * @return String
	 */
	public String getDatdep() {
		return datdep;
	}

	/**
	 * Returns the datsitu.
	 * @return String
	 */
	public String getDatsitu() {
		return datsitu;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the ident.
	 * @return String
	 */
	public String getIdent() {
		return ident;
	}

	/**
	 * Returns the keyList0.
	 * @return String
	 */
	public String getKeyList0() {
		return keyList0;
	}

	/**
	 * Returns the oldatsitu.
	 * @return String
	 */
	public String getOldatsitu() {
		return oldatsitu;
	}

	/**
	 * Returns the prestation.
	 * @return String
	 */
	public String getPrestation() {
		return prestation;
	}

	/**
	 * Returns the rnom.
	 * @return String
	 */
	public String getRnom() {
		return rnom;
	}

	/**
	 * Returns the soccode.
	 * @return String
	 */
	public String getSoccode() {
		return soccode;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Sets the coulog.
	 * @param coulog The coulog to set
	 */
	public void setCoulog(String coulog) {
		this.coulog = coulog;
	}

	/**
	 * Sets the coutot.
	 * @param coutot The coutot to set
	 */
	public void setCoutot(String coutot) {
		this.coutot = coutot;
	}

	/**
	 * Sets the cpident.
	 * @param cpident The cpident to set
	 */
	public void setCpident(String cpident) {
		this.cpident = cpident;
	}

	/**
	 * Sets the datdep.
	 * @param datdep The datdep to set
	 */
	public void setDatdep(String datdep) {
		this.datdep = datdep;
	}

	/**
	 * Sets the datsitu.
	 * @param datsitu The datsitu to set
	 */
	public void setDatsitu(String datsitu) {
		this.datsitu = datsitu;
	}


	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the ident.
	 * @param ident The ident to set
	 */
	public void setIdent(String ident) {
		this.ident = ident;
	}

	/**
	 * Sets the keyList0.
	 * @param keyList0 The keyList0 to set
	 */
	public void setKeyList0(String keyList0) {
		this.keyList0 = keyList0;
	}

	/**
	 * Sets the oldatsitu.
	 * @param oldatsitu The oldatsitu to set
	 */
	public void setOldatsitu(String oldatsitu) {
		this.oldatsitu = oldatsitu;
	}

	/**
	 * Sets the prestation.
	 * @param prestation The prestation to set
	 */
	public void setPrestation(String prestation) {
		this.prestation = prestation;
	}

	/**
	 * Sets the rnom.
	 * @param rnom The rnom to set
	 */
	public void setRnom(String rnom) {
		this.rnom = rnom;
	}

	/**
	 * Sets the soccode.
	 * @param soccode The soccode to set
	 */
	public void setSoccode(String soccode) {
		this.soccode = soccode;
	}

	public String getLib_siren() {
		return lib_siren;
	}

	public void setLib_siren(String lib_siren) {
		this.lib_siren = lib_siren;
	}

	public String getLib_soccode() {
		return lib_soccode;
	}

	public void setLib_soccode(String lib_soccode) {
		this.lib_soccode = lib_soccode;
	}

	public String getCode_domaine() {
		return code_domaine;
	}

	public void setCode_domaine(String code_domaine) {
		this.code_domaine = code_domaine;
	}

	public String getLib_rtype() {
		return lib_rtype;
	}

	public void setLib_rtype(String lib_rtype) {
		this.lib_rtype = lib_rtype;
	}

	public String getModeContractuelInd() {
		return modeContractuelInd;
	}

	public void setModeContractuelInd(String modeContractuelInd) {
		this.modeContractuelInd = modeContractuelInd;
	}

	public String getMciObligatoire() {
		return mciObligatoire;
	}

	public void setMciObligatoire(String mciObligatoire) {
		this.mciObligatoire = mciObligatoire;
	}

	public String getRtype() {
		return rtype;
	}

	public void setRtype(String rtype) {
		this.rtype = rtype;
	}

	public String getLib_mci() {
		return lib_mci;
	}

	public void setLib_mci(String lib_mci) {
		this.lib_mci = lib_mci;
	}
	
	
}
