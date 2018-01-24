package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;


/**
 * @author NBM - 18/08/2003
 *
 * Formulaire pour creation ou modification d'une ligne bip : menus CDG client et Saisie Client
 * pages : bLignebipMoCc.jsp, mLignebipMoCc.jsp
 */
public class LigneBipMoForm extends LigneBipForm{
	               
   /**L'année
	*/
	private String annee;
	 /**Le libellé du projet
	*/
	private String ilibel;
	 /**Le libellé de l'appli
	*/
	private String alibel;
	
	 /**Le libellé du dossier projet
	*/
	private String dplib;
 	/**Le libellé du projet spécial
	*/
	private String libpspe;
	
	/**Le libellé du DPG
	*/
	private String libdsg;
    /**Le nom du CP
	*/
	private String rnom;
	/**Le notifié
	*/
    private String bnmont ;
	/**Le proposé ME
	*/
	private String bpmontme ;
	/**L'arbitré
	*/
	private String anmont ;
	/**Le réestimé
	*/
	private String	reestime;
	/**Le Estimation pluriannuelle 
	*/
	
	private String	estimplurian;
	/**Le Réalisé
	*/
	private String	cusag;
	
	/**Le Proposé MO
	*/
	private String bpmontmo ;
	
	/**
	 * Champ indiquant si la date doit être récupérée
	 */
	private String recupDate="OUI";


	/**Le flaglock
	*/
	private int flag;
	
	/**
	 * Constructor 
	 */
	public LigneBipMoForm() {
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
	 * Returns the anmont.
	 * @return String
	 */
	public String getAnmont() {
		return anmont;
	}

/**
 * Returns the annee.
 * @return String
 */
public String getAnnee() {
	return annee;
}

	/**
	 * Returns the bnmont.
	 * @return String
	 */
	public String getBnmont() {
		return bnmont;
	}

	/**
	 * Returns the bpmontme.
	 * @return String
	 */
	public String getBpmontme() {
		return bpmontme;
	}

	/**
	 * Returns the bpmontmo.
	 * @return String
	 */
	public String getBpmontmo() {
		return bpmontmo;
	}

	/**
	 * Returns the cusag.
	 * @return String
	 */
	public String getCusag() {
		return cusag;
	}

	/**
	 * Returns the estimplurian.
	 * @return String
	 */
	public String getEstimplurian() {
		return estimplurian;
	}

	/**
	 * Returns the flag.
	 * @return int
	 */
	public int getFlag() {
		return flag;
	}

	/**
	 * Returns the reestime.
	 * @return String
	 */
	public String getReestime() {
		return reestime;
	}

	/**
	 * Sets the anmont.
	 * @param anmont The anmont to set
	 */
	public void setAnmont(String anmont) {
		this.anmont = anmont;
	}

/**
 * Sets the annee.
 * @param annee The annee to set
 */
public void setAnnee(String annee) {
	this.annee = annee;
}

	/**
	 * Sets the bnmont.
	 * @param bnmont The bnmont to set
	 */
	public void setBnmont(String bnmont) {
		this.bnmont = bnmont;
	}

	/**
	 * Sets the bpmontme.
	 * @param bpmontme The bpmontme to set
	 */
	public void setBpmontme(String bpmontme) {
		this.bpmontme = bpmontme;
	}

	/**
	 * Sets the bpmontmo.
	 * @param bpmontmo The bpmontmo to set
	 */
	public void setBpmontmo(String bpmontmo) {
		this.bpmontmo = bpmontmo;
	}

	/**
	 * Sets the cusag.
	 * @param cusag The cusag to set
	 */
	public void setCusag(String cusag) {
		this.cusag = cusag;
	}

	/**
	 * Sets the estimplurian.
	 * @param estimplurian The estimplurian to set
	 */
	public void setEstimplurian(String estimplurian) {
		this.estimplurian = estimplurian;
	}

	/**
	 * Sets the flag.
	 * @param flag The flag to set
	 */
	public void setFlag(int flag) {
		this.flag = flag;
	}

	/**
	 * Sets the reestime.
	 * @param reestime The reestime to set
	 */
	public void setReestime(String reestime) {
		this.reestime = reestime;
	}

	/**
	 * Returns the ilibel.
	 * @return String
	 */
	public String getIlibel() {
		return ilibel;
	}

	/**
	 * Sets the ilibel.
	 * @param ilibel The ilibel to set
	 */
	public void setIlibel(String ilibel) {
		this.ilibel = ilibel;
	}

	/**
	 * Returns the alibel.
	 * @return String
	 */
	public String getAlibel() {
		return alibel;
	}

	/**
	 * Returns the dplib.
	 * @return String
	 */
	public String getDplib() {
		return dplib;
	}

	/**
	 * Returns the libpspe.
	 * @return String
	 */
	public String getLibpspe() {
		return libpspe;
	}

	/**
	 * Sets the alibel.
	 * @param alibel The alibel to set
	 */
	public void setAlibel(String alibel) {
		this.alibel = alibel;
	}

	/**
	 * Sets the dplib.
	 * @param dplib The dplib to set
	 */
	public void setDplib(String dplib) {
		this.dplib = dplib;
	}

	/**
	 * Sets the libpspe.
	 * @param libpspe The libpspe to set
	 */
	public void setLibpspe(String libpspe) {
		this.libpspe = libpspe;
	}


	/**
	 * Returns the libdsg.
	 * @return String
	 */
	public String getLibdsg() {
		return libdsg;
	}

	/**
	 * Returns the rnom.
	 * @return String
	 */
	public String getRnom() {
		return rnom;
	}

	/**
	 * Sets the libdsg.
	 * @param libdsg The libdsg to set
	 */
	public void setLibdsg(String libdsg) {
		this.libdsg = libdsg;
	}

	/**
	 * Sets the rnom.
	 * @param rnom The rnom to set
	 */
	public void setRnom(String rnom) {
		this.rnom = rnom;
	}

	/**
	 * @return
	 */
	public String getRecupDate() {
		return recupDate;
	}

	/**
	 * @param string
	 */
	public void setRecupDate(String string) {
		recupDate = string;
	}

}
