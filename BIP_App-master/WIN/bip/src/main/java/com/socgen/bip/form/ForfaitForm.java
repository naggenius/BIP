package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author N.BACCAM - 25/06/2003
 *
 * Formulaire pour mise à jour des forfaits
 * chemin : Ressources/ mise à jour/Forfaits
 * pages  : bForfaitAd.jsp et mForfaitAd.jsp
 * pl/sql : resfor.sql
 */
public class ForfaitForm extends AutomateForm{
	/*Le code forfait
	*/
	protected String ident ;
    /*Le libelle du forfait
	*/
	private String rnom ;
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
	private String	lib_soccode;
	/*Le type de forfait (F ou E)
	*/ 			   
	private String typeForfait ;
	/*Le domaine
	*/ 			   
	private String code_domaine ;
	/*Le code chef de projet
	*/
	private String prestation ; 
	/*Le mode contractuel indicatif
	*/ 			   
	private String modeContractuelInd ;
	/*Le code chef de projet
	*/
	
	private String lib_mci;
	
	 /*mciCalcule: sert pour indiquer dans le formulaire que le mci a ete calcule
	  * 
	*/
	private String mciCalcule;

	/*mciObligatoire: sert pour indiquer dans le formulaire que le mci est obligatoire pour le dpg
	  * 
	*/
	private String mciObligatoire;
	
	private String	cpident ;
	/*Le cout
	*/ 			   
	private String	coufor ;
	/* facturatio au 12eme
    */ 			   
	private String	montant_mens ;
	/* choix
		*/ 			   
	private String	choix ;
	/* YNI FDT 970
	 * rtype
	*/ 			   
	private String	rtype ;
	/* rtype
	*/ 			   	   
	private String	localisation ;
	/*Le flaglock
	*/
	private int flaglock ;
	 /*KeyList0: sert pour la formation de la liste des dates de situ
	*/   
    protected String keyList0 ; 
 			
	/**
	 * Constructor for ClientForm.
	 */
	public ForfaitForm() {
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
	 * Returns the cout.
	 * @return String
	 */
	public String getCoufor() {
		return coufor;
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
	public String getTypeForfait() {
		return typeForfait;
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
	 * Sets the cout.
	 * @param cout The cout to set
	 */
	public void setCoufor(String coufor) {
		this.coufor = coufor;
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
	public void setTypeForfait(String typeForfait) {
		this.typeForfait = typeForfait;
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

	/**
	 * Returns the prestation.
	 * @return String
	 */
	public String getPrestation() {
		return prestation;
	}

	/**
	 * Sets the prestation.
	 * @param prestation The prestation to set
	 */
	public void setPrestation(String prestation) {
		this.prestation = prestation;
	}

	/**
	 * @return
	 */
	public String getMontant_mens() {
		return montant_mens;
	}

	/**
	 * @param string
	 */
	public void setMontant_mens(String string) {
		montant_mens = string;
	}

	/**
	 * @return
	 */
	public String getChoix() {
		return choix;
	}

	/**
	 * @param string
	 */
	public void setChoix(String string) {
		choix = string;
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

	public String getRtype() {
		return rtype;
	}

	public void setRtype(String rtype) {
		this.rtype = rtype;
	}

	public String getModeContractuelInd() {
		return modeContractuelInd;
	}

	public void setModeContractuelInd(String modeContractuelInd) {
		this.modeContractuelInd = modeContractuelInd;
	}

	public String getCode_domaine() {
		return code_domaine;
	}

	public void setCode_domaine(String code_domaine) {
		this.code_domaine = code_domaine;
	}

	public String getLocalisation() {
		return localisation;
	}

	public void setLocalisation(String localisation) {
		this.localisation = localisation;
	}

	public String getLib_mci() {
		return lib_mci;
	}

	public void setLib_mci(String lib_mci) {
		this.lib_mci = lib_mci;
	}

	public String getMciCalcule() {
		return mciCalcule;
	}

	public void setMciCalcule(String mciCalcule) {
		this.mciCalcule = mciCalcule;
	}

	public String getMciObligatoire() {
		return mciObligatoire;
	}

	public void setMciObligatoire(String mciObligatoire) {
		this.mciObligatoire = mciObligatoire;
	}
	
}
