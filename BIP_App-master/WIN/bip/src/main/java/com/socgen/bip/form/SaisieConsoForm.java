package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

/**
 * @author N.BACCAM - 29/07/2003
 *
 * Formulaire de mise à jour des consommés d'une ressource
 * chemin : Saisie des réalisés/Saisie des consommés
 * pages  : fSaisieConsoSr.jsp , bSaisieConsoSr.jsp
 * pl/sql : isac_conso.sql
 */
public class SaisieConsoForm extends AffectationForm{
         
	
	/*La liste des dpg des affections 
	*/
	private String dpg ;
	
	/*Le nombre de lignes par page 
	*/
	private String blocksize ;
	
	/*position blocksize 
	*/
	private String position_blocksize;
	
	/*typfact
	*/
	private String choixRessources ;
	
	/*ordre de tri 
	*/
	private String ordre_tri ;

	private String choix_ress ;

	private String lock;
	
	private String retroIdent;
	
	/*Le mois courant
		*/
	protected String type_valider;
	
	/*Le mois courant
	*/
	protected String mois;

	 /*Le nombre de mois
	*/
	protected String nbmois;
	/*Les totaux par mois
	*/
	protected String tot_mois_1;
	protected String tot_mois_2;
	protected String tot_mois_3;
	protected String tot_mois_4;
	protected String tot_mois_5;
	protected String tot_mois_6;
	protected String tot_mois_7;
	protected String tot_mois_8;
	protected String tot_mois_9;
	protected String tot_mois_10;
	protected String tot_mois_11;
	protected String tot_mois_12;
	/*Les anciens totaux par mois
	*/
	protected String old_tot_mois_1;
	protected String old_tot_mois_2;
	protected String old_tot_mois_3;
	protected String old_tot_mois_4;
	protected String old_tot_mois_5;
	protected String old_tot_mois_6;
	protected String old_tot_mois_7;
	protected String old_tot_mois_8;
	protected String old_tot_mois_9;
	protected String old_tot_mois_10;
	protected String old_tot_mois_11;
	protected String old_tot_mois_12;
    /*Le total
	*/
	protected String total;
	 /*L'ancien total
	*/
	protected String old_total;
	/*Le nb de jous ouvrés par mois
	*/	
	protected String nbjour_1;
	protected String nbjour_2;
	protected String nbjour_3;
	protected String nbjour_4;
	protected String nbjour_5;
	protected String nbjour_6;
	protected String nbjour_7;
	protected String nbjour_8;
	protected String nbjour_9;
	protected String nbjour_10;
	protected String nbjour_11;
	protected String nbjour_12;			
	/*La position de la ressource dans la liste
	*/	
	protected String position;	
	
	// FAD PPM 64579 : Les totaux par mois avant modification
	protected String old_total_mois_1;
	protected String old_total_mois_2;
	protected String old_total_mois_3;
	protected String old_total_mois_4;
	protected String old_total_mois_5;
	protected String old_total_mois_6;
	protected String old_total_mois_7;
	protected String old_total_mois_8;
	protected String old_total_mois_9;
	protected String old_total_mois_10;
	protected String old_total_mois_11;
	protected String old_total_mois_12;
	
	public String getOld_total_mois_1() {
		return old_total_mois_1;
	}

	public void setOld_total_mois_1(String old_total_mois_1) {
		this.old_total_mois_1 = old_total_mois_1;
	}

	public String getOld_total_mois_2() {
		return old_total_mois_2;
	}

	public void setOld_total_mois_2(String old_total_mois_2) {
		this.old_total_mois_2 = old_total_mois_2;
	}

	public String getOld_total_mois_3() {
		return old_total_mois_3;
	}

	public void setOld_total_mois_3(String old_total_mois_3) {
		this.old_total_mois_3 = old_total_mois_3;
	}

	public String getOld_total_mois_4() {
		return old_total_mois_4;
	}

	public void setOld_total_mois_4(String old_total_mois_4) {
		this.old_total_mois_4 = old_total_mois_4;
	}

	public String getOld_total_mois_5() {
		return old_total_mois_5;
	}

	public void setOld_total_mois_5(String old_total_mois_5) {
		this.old_total_mois_5 = old_total_mois_5;
	}

	public String getOld_total_mois_6() {
		return old_total_mois_6;
	}

	public void setOld_total_mois_6(String old_total_mois_6) {
		this.old_total_mois_6 = old_total_mois_6;
	}

	public String getOld_total_mois_7() {
		return old_total_mois_7;
	}

	public void setOld_total_mois_7(String old_total_mois_7) {
		this.old_total_mois_7 = old_total_mois_7;
	}

	public String getOld_total_mois_8() {
		return old_total_mois_8;
	}

	public void setOld_total_mois_8(String old_total_mois_8) {
		this.old_total_mois_8 = old_total_mois_8;
	}

	public String getOld_total_mois_9() {
		return old_total_mois_9;
	}

	public void setOld_total_mois_9(String old_total_mois_9) {
		this.old_total_mois_9 = old_total_mois_9;
	}

	public String getOld_total_mois_10() {
		return old_total_mois_10;
	}

	public void setOld_total_mois_10(String old_total_mois_10) {
		this.old_total_mois_10 = old_total_mois_10;
	}

	public String getOld_total_mois_11() {
		return old_total_mois_11;
	}

	public void setOld_total_mois_11(String old_total_mois_11) {
		this.old_total_mois_11 = old_total_mois_11;
	}

	public String getOld_total_mois_12() {
		return old_total_mois_12;
	}

	public void setOld_total_mois_12(String old_total_mois_12) {
		this.old_total_mois_12 = old_total_mois_12;
	}
	// FAD PPM 64579 : Fin
	
	protected String save;		
	
	private boolean isAnneeEntiere = false;
	
	public static String codeErreurSupprSsTacheAvecConsomme = "1";
	 
     /**
	 * Constructor for ClientForm.
	 */
	public SaisieConsoForm() {
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
	

	public String getChoixRessources() {
		return choixRessources;
	}

	public void setChoixRessources(String choixRessources) {
		this.choixRessources = choixRessources;
	}

	/**
	 * Returns the dpg.
	 * @return String
	 */
	public String getDpg() {
		return dpg;
	}
	
	/**
	 * Returns the blocksize.
	 * @return String
	 */
	public String getBlocksize() {
		return blocksize;
	}
	
	
	/**
    * Returns the ordre_tri.
	* @return String
	*/
	public String getOrdre_tri() {
		return ordre_tri;
	}
	
	public String getChoix_ress() {
		return choix_ress;
	}

	public void setChoix_ress(String choix_ress) {
		this.choix_ress = choix_ress;
	}	
	
	public String getLock() {
		return lock;
	}

	public void setLock(String lock) {
		this.lock = lock;
	}

	/**
		 * Returns the mois.
		 * @return String
		 */
	public String getType_valider() {
			return type_valider;
	}
	

	/**
	 * Returns the mois.
	 * @return String
	 */
	public String getMois() {
		return mois;
	}

	/**
	 * Returns the nbmois.
	 * @return String
	 */
	public String getNbmois() {
		return nbmois;
	}

	/**
	 * Sets the mois.
	 * @param mois The mois to set
	 */
	public void setMois(String mois) {
		this.mois = mois;
	}

	/**
	 * Sets the nbmois.
	 * @param nbmois The nbmois to set
	 */
	public void setNbmois(String nbmois) {
		this.nbmois = nbmois;
	}

	/**
	 * Returns the nbjour_1.
	 * @return String
	 */
	public String getNbjour_1() {
		return nbjour_1;
	}

	/**
	 * Returns the nbjour_10.
	 * @return String
	 */
	public String getNbjour_10() {
		return nbjour_10;
	}

	/**
	 * Returns the nbjour_11.
	 * @return String
	 */
	public String getNbjour_11() {
		return nbjour_11;
	}

	/**
	 * Returns the nbjour_12.
	 * @return String
	 */
	public String getNbjour_12() {
		return nbjour_12;
	}

	/**
	 * Returns the nbjour_2.
	 * @return String
	 */
	public String getNbjour_2() {
		return nbjour_2;
	}

	/**
	 * Returns the nbjour_3.
	 * @return String
	 */
	public String getNbjour_3() {
		return nbjour_3;
	}

	/**
	 * Returns the nbjour_4.
	 * @return String
	 */
	public String getNbjour_4() {
		return nbjour_4;
	}

	/**
	 * Returns the nbjour_5.
	 * @return String
	 */
	public String getNbjour_5() {
		return nbjour_5;
	}

	/**
	 * Returns the nbjour_6.
	 * @return String
	 */
	public String getNbjour_6() {
		return nbjour_6;
	}

	/**
	 * Returns the nbjour_7.
	 * @return String
	 */
	public String getNbjour_7() {
		return nbjour_7;
	}

	/**
	 * Returns the nbjour_8.
	 * @return String
	 */
	public String getNbjour_8() {
		return nbjour_8;
	}

	/**
	 * Returns the nbjour_9.
	 * @return String
	 */
	public String getNbjour_9() {
		return nbjour_9;
	}

	/**
	 * Returns the tot_mois_1.
	 * @return String
	 */
	public String getTot_mois_1() {
		return tot_mois_1;
	}

	/**
	 * Returns the tot_mois_10.
	 * @return String
	 */
	public String getTot_mois_10() {
		return tot_mois_10;
	}

	/**
	 * Returns the tot_mois_11.
	 * @return String
	 */
	public String getTot_mois_11() {
		return tot_mois_11;
	}

	/**
	 * Returns the tot_mois_12.
	 * @return String
	 */
	public String getTot_mois_12() {
		return tot_mois_12;
	}

	/**
	 * Returns the tot_mois_2.
	 * @return String
	 */
	public String getTot_mois_2() {
		return tot_mois_2;
	}

	/**
	 * Returns the tot_mois_3.
	 * @return String
	 */
	public String getTot_mois_3() {
		return tot_mois_3;
	}

	/**
	 * Returns the tot_mois_4.
	 * @return String
	 */
	public String getTot_mois_4() {
		return tot_mois_4;
	}

	/**
	 * Returns the tot_mois_5.
	 * @return String
	 */
	public String getTot_mois_5() {
		return tot_mois_5;
	}

	/**
	 * Returns the tot_mois_6.
	 * @return String
	 */
	public String getTot_mois_6() {
		return tot_mois_6;
	}

	/**
	 * Returns the tot_mois_7.
	 * @return String
	 */
	public String getTot_mois_7() {
		return tot_mois_7;
	}

	/**
	 * Returns the tot_mois_8.
	 * @return String
	 */
	public String getTot_mois_8() {
		return tot_mois_8;
	}

	/**
	 * Returns the tot_mois_9.
	 * @return String
	 */
	public String getTot_mois_9() {
		return tot_mois_9;
	}

	/**
	 * Returns the total.
	 * @return String
	 */
	public String getTotal() {
		return total;
	}
	

	/**
	* Sets the dpg.
	* @param 
	*/
	public void setDpg(String dpg) {
		this.dpg = dpg;
	} 
	
	/**
	* Sets the blocksize.
	* @param annee The annee to set
	*/
	public void setBlocksize(String blocksize) {
		this.blocksize = blocksize;
	} 

	

	/**
		 * Sets the nbjour_1.
		 * @param nbjour_1 The nbjour_1 to set
		 */
	public void setType_valider(String type_valider) {
			this.type_valider = type_valider;
	}



	/**
	 * Sets the nbjour_1.
	 * @param nbjour_1 The nbjour_1 to set
	 */
	public void setNbjour_1(String nbjour_1) {
		this.nbjour_1 = nbjour_1;
	}

	/**
	 * Sets the nbjour_10.
	 * @param nbjour_10 The nbjour_10 to set
	 */
	public void setNbjour_10(String nbjour_10) {
		this.nbjour_10 = nbjour_10;
	}

	/**
	 * Sets the nbjour_11.
	 * @param nbjour_11 The nbjour_11 to set
	 */
	public void setNbjour_11(String nbjour_11) {
		this.nbjour_11 = nbjour_11;
	}

	/**
	 * Sets the nbjour_12.
	 * @param nbjour_12 The nbjour_12 to set
	 */
	public void setNbjour_12(String nbjour_12) {
		this.nbjour_12 = nbjour_12;
	}

	/**
	 * Sets the nbjour_2.
	 * @param nbjour_2 The nbjour_2 to set
	 */
	public void setNbjour_2(String nbjour_2) {
		this.nbjour_2 = nbjour_2;
	}

	/**
	 * Sets the nbjour_3.
	 * @param nbjour_3 The nbjour_3 to set
	 */
	public void setNbjour_3(String nbjour_3) {
		this.nbjour_3 = nbjour_3;
	}

	/**
	 * Sets the nbjour_4.
	 * @param nbjour_4 The nbjour_4 to set
	 */
	public void setNbjour_4(String nbjour_4) {
		this.nbjour_4 = nbjour_4;
	}

	/**
	 * Sets the nbjour_5.
	 * @param nbjour_5 The nbjour_5 to set
	 */
	public void setNbjour_5(String nbjour_5) {
		this.nbjour_5 = nbjour_5;
	}

	/**
	 * Sets the nbjour_6.
	 * @param nbjour_6 The nbjour_6 to set
	 */
	public void setNbjour_6(String nbjour_6) {
		this.nbjour_6 = nbjour_6;
	}

	/**
	 * Sets the nbjour_7.
	 * @param nbjour_7 The nbjour_7 to set
	 */
	public void setNbjour_7(String nbjour_7) {
		this.nbjour_7 = nbjour_7;
	}

	/**
	 * Sets the nbjour_8.
	 * @param nbjour_8 The nbjour_8 to set
	 */
	public void setNbjour_8(String nbjour_8) {
		this.nbjour_8 = nbjour_8;
	}

	/**
	 * Sets the nbjour_9.
	 * @param nbjour_9 The nbjour_9 to set
	 */
	public void setNbjour_9(String nbjour_9) {
		this.nbjour_9 = nbjour_9;
	}

	/**
	 * Sets the tot_mois_1.
	 * @param tot_mois_1 The tot_mois_1 to set
	 */
	public void setTot_mois_1(String tot_mois_1) {
		this.tot_mois_1 = tot_mois_1;
	}

	/**
	 * Sets the tot_mois_10.
	 * @param tot_mois_10 The tot_mois_10 to set
	 */
	public void setTot_mois_10(String tot_mois_10) {
		this.tot_mois_10 = tot_mois_10;
	}

	/**
	 * Sets the tot_mois_11.
	 * @param tot_mois_11 The tot_mois_11 to set
	 */
	public void setTot_mois_11(String tot_mois_11) {
		this.tot_mois_11 = tot_mois_11;
	}

	/**
	 * Sets the tot_mois_12.
	 * @param tot_mois_12 The tot_mois_12 to set
	 */
	public void setTot_mois_12(String tot_mois_12) {
		this.tot_mois_12 = tot_mois_12;
	}

	/**
	 * Sets the tot_mois_2.
	 * @param tot_mois_2 The tot_mois_2 to set
	 */
	public void setTot_mois_2(String tot_mois_2) {
		this.tot_mois_2 = tot_mois_2;
	}

	/**
	 * Sets the tot_mois_3.
	 * @param tot_mois_3 The tot_mois_3 to set
	 */
	public void setTot_mois_3(String tot_mois_3) {
		this.tot_mois_3 = tot_mois_3;
	}

	/**
	 * Sets the tot_mois_4.
	 * @param tot_mois_4 The tot_mois_4 to set
	 */
	public void setTot_mois_4(String tot_mois_4) {
		this.tot_mois_4 = tot_mois_4;
	}

	/**
	 * Sets the tot_mois_5.
	 * @param tot_mois_5 The tot_mois_5 to set
	 */
	public void setTot_mois_5(String tot_mois_5) {
		this.tot_mois_5 = tot_mois_5;
	}

	/**
	 * Sets the tot_mois_6.
	 * @param tot_mois_6 The tot_mois_6 to set
	 */
	public void setTot_mois_6(String tot_mois_6) {
		this.tot_mois_6 = tot_mois_6;
	}

	/**
	 * Sets the tot_mois_7.
	 * @param tot_mois_7 The tot_mois_7 to set
	 */
	public void setTot_mois_7(String tot_mois_7) {
		this.tot_mois_7 = tot_mois_7;
	}

	/**
	 * Sets the tot_mois_8.
	 * @param tot_mois_8 The tot_mois_8 to set
	 */
	public void setTot_mois_8(String tot_mois_8) {
		this.tot_mois_8 = tot_mois_8;
	}

	/**
	 * Sets the tot_mois_9.
	 * @param tot_mois_9 The tot_mois_9 to set
	 */
	public void setTot_mois_9(String tot_mois_9) {
		this.tot_mois_9 = tot_mois_9;
	}

	/**
	 * Sets the total.
	 * @param total The total to set
	 */
	public void setTotal(String total) {
		this.total = total;
	}

	/**
	 * Returns the old_tot_mois_1.
	 * @return String
	 */
	public String getOld_tot_mois_1() {
		return old_tot_mois_1;
	}

	/**
	 * Returns the old_tot_mois_10.
	 * @return String
	 */
	public String getOld_tot_mois_10() {
		return old_tot_mois_10;
	}

	/**
	 * Returns the old_tot_mois_11.
	 * @return String
	 */
	public String getOld_tot_mois_11() {
		return old_tot_mois_11;
	}

	/**
	 * Returns the old_tot_mois_12.
	 * @return String
	 */
	public String getOld_tot_mois_12() {
		return old_tot_mois_12;
	}

	/**
	 * Returns the old_tot_mois_2.
	 * @return String
	 */
	public String getOld_tot_mois_2() {
		return old_tot_mois_2;
	}

	/**
	 * Returns the old_tot_mois_3.
	 * @return String
	 */
	public String getOld_tot_mois_3() {
		return old_tot_mois_3;
	}

	/**
	 * Returns the old_tot_mois_4.
	 * @return String
	 */
	public String getOld_tot_mois_4() {
		return old_tot_mois_4;
	}

	/**
	 * Returns the old_tot_mois_5.
	 * @return String
	 */
	public String getOld_tot_mois_5() {
		return old_tot_mois_5;
	}

	/**
	 * Returns the old_tot_mois_6.
	 * @return String
	 */
	public String getOld_tot_mois_6() {
		return old_tot_mois_6;
	}

	/**
	 * Returns the old_tot_mois_7.
	 * @return String
	 */
	public String getOld_tot_mois_7() {
		return old_tot_mois_7;
	}

	/**
	 * Returns the old_tot_mois_8.
	 * @return String
	 */
	public String getOld_tot_mois_8() {
		return old_tot_mois_8;
	}

	/**
	 * Returns the old_tot_mois_9.
	 * @return String
	 */
	public String getOld_tot_mois_9() {
		return old_tot_mois_9;
	}

	/**
	 * Sets the old_tot_mois_1.
	 * @param old_tot_mois_1 The old_tot_mois_1 to set
	 */
	public void setOld_tot_mois_1(String old_tot_mois_1) {
		this.old_tot_mois_1 = old_tot_mois_1;
	}

	/**
	 * Sets the old_tot_mois_10.
	 * @param old_tot_mois_10 The old_tot_mois_10 to set
	 */
	public void setOld_tot_mois_10(String old_tot_mois_10) {
		this.old_tot_mois_10 = old_tot_mois_10;
	}

	/**
	 * Sets the old_tot_mois_11.
	 * @param old_tot_mois_11 The old_tot_mois_11 to set
	 */
	public void setOld_tot_mois_11(String old_tot_mois_11) {
		this.old_tot_mois_11 = old_tot_mois_11;
	}

	/**
	 * Sets the old_tot_mois_12.
	 * @param old_tot_mois_12 The old_tot_mois_12 to set
	 */
	public void setOld_tot_mois_12(String old_tot_mois_12) {
		this.old_tot_mois_12 = old_tot_mois_12;
	}

	/**
	 * Sets the old_tot_mois_2.
	 * @param old_tot_mois_2 The old_tot_mois_2 to set
	 */
	public void setOld_tot_mois_2(String old_tot_mois_2) {
		this.old_tot_mois_2 = old_tot_mois_2;
	}

	/**
	 * Sets the old_tot_mois_3.
	 * @param old_tot_mois_3 The old_tot_mois_3 to set
	 */
	public void setOld_tot_mois_3(String old_tot_mois_3) {
		this.old_tot_mois_3 = old_tot_mois_3;
	}

	/**
	 * Sets the old_tot_mois_4.
	 * @param old_tot_mois_4 The old_tot_mois_4 to set
	 */
	public void setOld_tot_mois_4(String old_tot_mois_4) {
		this.old_tot_mois_4 = old_tot_mois_4;
	}

	/**
	 * Sets the old_tot_mois_5.
	 * @param old_tot_mois_5 The old_tot_mois_5 to set
	 */
	public void setOld_tot_mois_5(String old_tot_mois_5) {
		this.old_tot_mois_5 = old_tot_mois_5;
	}

	/**
	 * Sets the old_tot_mois_6.
	 * @param old_tot_mois_6 The old_tot_mois_6 to set
	 */
	public void setOld_tot_mois_6(String old_tot_mois_6) {
		this.old_tot_mois_6 = old_tot_mois_6;
	}

	/**
	 * Sets the old_tot_mois_7.
	 * @param old_tot_mois_7 The old_tot_mois_7 to set
	 */
	public void setOld_tot_mois_7(String old_tot_mois_7) {
		this.old_tot_mois_7 = old_tot_mois_7;
	}

	/**
	 * Sets the old_tot_mois_8.
	 * @param old_tot_mois_8 The old_tot_mois_8 to set
	 */
	public void setOld_tot_mois_8(String old_tot_mois_8) {
		this.old_tot_mois_8 = old_tot_mois_8;
	}

	/**
	 * Sets the old_tot_mois_9.
	 * @param old_tot_mois_9 The old_tot_mois_9 to set
	 */
	public void setOld_tot_mois_9(String old_tot_mois_9) {
		this.old_tot_mois_9 = old_tot_mois_9;
	}

	/**
	 * Returns the old_total.
	 * @return String
	 */
	public String getOld_total() {
		return old_total;
	}

	/**
	 * Sets the old_total.
	 * @param old_total The old_total to set
	 */
	public void setOld_total(String old_total) {
		this.old_total = old_total;
	}

	/**
	 * Returns the position.
	 * @return String
	 */
	public String getPosition() {
		return position;
	}

	/**
	 * Sets the position.
	 * @param position The position to set
	 */
	public void setPosition(String position) {
		this.position = position;
	}
	
	
	/**
	* Returns the position_blocksize.
	* @return String
	*/
	public String getPosition_blocksize() {
			return position_blocksize;
	}

	/**
	* Sets the position.
	* @param position The position to set
	*/
	public void setPosition_blocksize(String position) {
			this.position_blocksize = position;
	}
	
	
	
	/**
	 * @return
	*/
	public String getSave() {
		 return save;
	}

    /**
	 * @param string
	 */
    public void setSave(String string) {
		 save = string;
	}	
  
	/**
	* Sets the ordre_tri.
	* @param annee The annee to set
	*/
	public void setOrdre_tri(String ordre_tri) {
			this.ordre_tri = ordre_tri;
	}
	
	public boolean getIsAnneeEntiere() {
		return isAnneeEntiere;
	} 

	public void setIsAnneeEntiere(boolean isAnneeEntiere) {
		this.isAnneeEntiere = isAnneeEntiere;
	}

	public String getRetroIdent() {
		return retroIdent;
	}

	public void setRetroIdent(String retroIdent) {
		this.retroIdent = retroIdent;
	} 
	
	

}
