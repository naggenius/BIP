package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

/**
 * @author N.BACCAM - 28/07/2003
 *
 * Formulaire de mise à jour des SousTaches 
 * chemin : Saisie des réalisés/Paramétrage/Structure LigneBIP
 * pages  : fSoustache.jsp, fmSoustache.jsp et mSoustache.jsp
 * pl/sql : isac_sous_tache.sql
 */
public class SousTacheForm extends TacheForm{                
      
	/*Le numéro de la SousTache affiché
	*/
	protected String acst;
	
	/*Le libellé de la SousTache
	*/
	protected String asnom;
	
	/*Le numéro la SousTache
	*/
	protected String sous_tache;
	
	/*Les numéros des SousTaches
	HPPM_31695 CPA Gestion de la multi-selection
	*/
	protected String[] sous_tacheMulti ;
	
	protected String SelectConcat;
	/*
	/*Le type de la SousTache 
	*/
	protected String aist;
	
	/*Le libellé de la SousTache
	*/
	protected String asta;
	
	/*La date de debut initiale de la SousTache
	*/
	private String adeb;
	
	/*La date de fin initiale de la SousTache
	*/
	private String afin;
	
	/*La date de debut révisée de la SousTache
	*/
	private String ande;
	
	/*La date  de fin révisée  de la SousTache
	*/
	private String anfi;
	
	/*La durée de la SousTache
	*/
	private String adur;
	
	/*Liste des etapes/taches 
	*/
	private String etapeTache;
	
	/*keyList3 : ECET - LIBETAPE
	*/
	private String keyList3;
	
	/*keyList4 : ACTA - LIBTACHE
	*/
	private String keyList4;
	
	/*Paramètre Local de la sous-tâche
	 */
	private String paramLocal;
	
	
	/*Libellé ligne bip
	*/
	private String libpid;
		
	/*codsg
	*/
	private String codsg;	
		
	/*Libellé du codsg
	*/
	private String libcodsg;	
	
	private static String msgErreurSupprSsTacheSuffixe = "supprimée";
	
     /**
	 * Constructor for ClientForm.
	 */
	public SousTacheForm() {
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
	 * Returns the acst.
	 * @return String
	 */
	public String getAcst() {
		return acst;
	}

	/**
	 * Returns the adeb.
	 * @return String
	 */
	public String getAdeb() {
		return adeb;
	}

	/**
	 * Returns the adur.
	 * @return String
	 */
	public String getAdur() {
		return adur;
	}

	/**
	 * Returns the afin.
	 * @return String
	 */
	public String getAfin() {
		return afin;
	}

	/**
	 * Returns the aist.
	 * @return String
	 */
	public String getAist() {
		return aist;
	}

	/**
	 * Returns the ande.
	 * @return String
	 */
	public String getAnde() {
		return ande;
	}

	/**
	 * Returns the anfi.
	 * @return String
	 */
	public String getAnfi() {
		return anfi;
	}

	/**
	 * Returns the asnom.
	 * @return String
	 */
	public String getAsnom() {
		return asnom;
	}

	/**
	 * Returns the asta.
	 * @return String
	 */
	public String getAsta() {
		return asta;
	}

	/**
	 * Returns the sous_tache.
	 * @return String
	 */
	public String getSous_tache() {
		return sous_tache;
	}
	
	/**
	 * Returns the sous_tache.
	 * @return String[]
	 * HPPM_31695 CPA Gestion de la multi-selection
	 */
   	public String[] getSous_tacheMulti() {
   		/*	
		StringBuffer sbSousTache = new StringBuffer();
		
		for (int i = 0; i < sous_tacheMulti.length; i++) {
			sbSousTache.append(i);
			if (i < (sous_tacheMulti.length-1)){
				sbSousTache.append("/");
			}
		}*/
   		return sous_tacheMulti;
	}

	public void setSous_tacheMulti(String[] sous_tacheMulti) {
		this.sous_tacheMulti = sous_tacheMulti;
	}

	/**
	 * Sets the acst.
	 * @param acst The acst to set
	 */
	public void setAcst(String acst) {
		this.acst = acst;
	}

	/**
	 * Sets the adeb.
	 * @param adeb The adeb to set
	 */
	public void setAdeb(String adeb) {
		this.adeb = adeb;
	}

	/**
	 * Sets the adur.
	 * @param adur The adur to set
	 */
	public void setAdur(String adur) {
		this.adur = adur;
	}

	/**
	 * Sets the afin.
	 * @param afin The afin to set
	 */
	public void setAfin(String afin) {
		this.afin = afin;
	}

	/**
	 * Sets the aist.
	 * @param aist The aist to set
	 */
	public void setAist(String aist) {
		this.aist = aist;
	}

	/**
	 * Sets the ande.
	 * @param ande The ande to set
	 */
	public void setAnde(String ande) {
		this.ande = ande;
	}

	/**
	 * Sets the anfi.
	 * @param anfi The anfi to set
	 */
	public void setAnfi(String anfi) {
		this.anfi = anfi;
	}

	/**
	 * Sets the asnom.
	 * @param asnom The asnom to set
	 */
	public void setAsnom(String asnom) {
		this.asnom = asnom;
	}

	/**
	 * Sets the asta.
	 * @param asta The asta to set
	 */
	public void setAsta(String asta) {
		this.asta = asta;
	}

	/**
	 * Sets the sous_tache.
	 * @param sous_tache The sous_tache to set
	 */
	public void setSous_tache(String sous_tache) {
		this.sous_tache = sous_tache;
	}

	/**
	 * Returns the keyList3.
	 * @return String
	 */
	public String getKeyList3() {
		return keyList3;
	}

	/**
	 * Returns the keyList4.
	 * @return String
	 */
	public String getKeyList4() {
		return keyList4;
	}

	/**
	 * Sets the keyList3.
	 * @param keyList3 The keyList3 to set
	 */
	public void setKeyList3(String keyList3) {
		this.keyList3 = keyList3;
	}

	/**
	 * Sets the keyList4.
	 * @param keyList4 The keyList4 to set
	 */
	public void setKeyList4(String keyList4) {
		this.keyList4 = keyList4;
	}

	/**
	 * Returns the etapeTache.
	 * @return String
	 */
	public String getEtapeTache() {
		return etapeTache;
	}

	/**
	 * Sets the etapeTache.
	 * @param etapeTache The etapeTache to set
	 */
	public void setEtapeTache(String etapeTache) {
		this.etapeTache = etapeTache;
	}

	/**
	* Sets the paramLocal.
	* @param paramLocal The paramLocal to set
	*/
	public void setParamLocal(String paramLocal) {
			this.paramLocal = paramLocal;
	}


	/**
	 * Returns the paramLocal.
	 * @return String
	 */
	public String getParamLocal() {
		 return paramLocal;
	}

	/**
	* Returns the libpid.
	* @return String
	*/
	public String getLibpid() {
	     return libpid;
	}

	/**
	 * Sets the libpid.
	 * @param libpid The libpid to set
	 */
	public void setLibpid(String libpid) {
		this.libpid = libpid;
	}
	
	/**
	* Returns the codsg.
	* @return String
	*/
	public String getCodsg() {
			return codsg;
	}
	
	
	/**
	* Sets the codsg.
	* @param codsg The codsg to set
	*/
	public void setCodsg(String codsg) {
			this.codsg = codsg;
	}

    
	/**
	* Returns the libcodsg.
	* @return String
	*/
	public String getLibcodsg() {
			return libcodsg;
	}


	/**
	* Sets the codsg.
	* @param codsg The codsg to set
	*/
	public void setLibcodsg(String libcodsg) {
			this.libcodsg = libcodsg;
	}

	public String getSelectConcat() {
		return SelectConcat;
	}

	public void setSelectConcat(String selectConcat) {
		this.SelectConcat = selectConcat;
	}

	public boolean suppressionOK() {
		return suppressionOK(msgErreurSupprSsTacheSuffixe);
	}
}
