package com.socgen.bip.form;

import java.util.LinkedList;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.GestBudgHisto;

/**
 * @author MMC - 09/07/2003
 *
 * Formulaire pour mise à jour des réestimés
 * chemin : Ligne Bip/Gestion/Reestimes ligne bip
 * pages  : fReestimeAd.jsp et mReestimeAd.jsp
 * pl/sql : reesbip.sql
 */
public class ReestimeForm extends AutomateForm{
	
	/**
	 * Mode de l'écran
	 */
	public static String modeConsulterHistoRees = "consulterHistoRees";
	/**
	 * Titre de l'écran
	 */
	public static String titrePageConsulterHistoRees = "Consulter un r&eacute;estim&eacute; et son historique";
	
	public static String libelleHistorique = "Historique";
	public static String valeurNeant = "n&eacute;ant";
	
	public static String libelleReestime = "R&eacute;estim&eacute; :";
	public static String libelleReestimeActuel = "R&eacute;estim&eacute; actuel :";
	
	public static int longueurMaxCommentaire = 200;
	
	/*
	 * La liste des historiques (valeur / date de modification / identifiant utilisé pour la modification / commentaire associé) des réestimés
	 */
	private LinkedList<GestBudgHisto> reesHisto;
	/*Le pid
	*/
	private String pid ;
	/*Le pnom
	*/
	private String pnom ;
	/*Le codsg
	*/
	private String codsg;
	/*Le xcusag0
	*/
	private String xcusag0 ;
	/*Le bnmont
	*/
	private String bnmont ;
	/*Le preesancou
	*/
	private String preesancou ;
	/*Le estimpluran
	*/
	private String estimpluran ;
	
	private int flaglock;
	private int flag;
	
	/*L'identifiant qui réalise l'opération sur le Budget réestimé
	*/
	private String ureestime ;
	
	/*
	 * commentaire éventuel associé à la dernière modification de la donnée réestimé
	 */
	private String reescomm;
	
	/*La Date de modification du budget réestimé
	*/
	private String redate ;

	/**
	 * Constructor for ReestimeForm.
	 */
	public ReestimeForm() {
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
	 * Returns the bnmont.
	 * @return String
	 */
	public String getBnmont() {
		return bnmont;
	}

	/**
	 * Returns the codsg.
	 * @return String
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * Returns the estimpluran.
	 * @return String
	 */
	public String getEstimpluran() {
		return estimpluran;
	}

	/**
	 * Returns the flag.
	 * @return int
	 */
	public int getFlag() {
		return flag;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Returns the pid.
	 * @return String
	 */
	public String getPid() {
		return pid;
	}

	/**
	 * Returns the pnom.
	 * @return String
	 */
	public String getPnom() {
		return pnom;
	}

	/**
	 * Returns the preesancou.
	 * @return String
	 */
	public String getPreesancou() {
		return preesancou;
	}

	/**
	 * Returns the xcusag0.
	 * @return String
	 */
	public String getXcusag0() {
		return xcusag0;
	}

	/**
	 * Returns the ureestime.
	 * @return String
	 */
	public String getUreestime() {
		return ureestime;
	}
	
	public String getReescomm() {
		return reescomm;
	}

	public void setReescomm(String reescomm) {
		this.reescomm = reescomm;
	}
	
	/**
	 * Obtention du nombre de caractères restants possibles en saisie d'un champ commentaire 
	 *
	 */
	public int obtenirNbCarRestantsComm(String commentaire, int longueurMax) {
  		int retour = 0;
  		
		// longueur initiale de la chaine Comm
  		int longueurComm = 0;
  		if (commentaire != null) {
  			longueurComm = commentaire.length();
  		}
  		
  		if (longueurComm < longueurMax) {
  			retour = longueurMax - longueurComm;
  		}
  		
  		return retour;
	}
	
	/**
	 * Obtention du nombre de caractères restants possibles en saisie du champ reesComm 
	 *
	 */
	public String getNbCarRestantsReescomm() {
		return String.valueOf(obtenirNbCarRestantsComm(getReescomm(), longueurMaxCommentaire));
	}

	/**
	 * Returns the redate.
	 * @return String
	 */
	
	public String getRedate() {
		return redate;
	}
	
	/**
	 * Sets the bnmont.
	 * @param bnmont The bnmont to set
	 */
	public void setBnmont(String bnmont) {
		this.bnmont = bnmont;
	}

	/**
	 * Sets the codsg.
	 * @param codsg The codsg to set
	 */
	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	/**
	 * Sets the estimpluran.
	 * @param estimpluran The estimpluran to set
	 */
	public void setEstimpluran(String estimpluran) {
		this.estimpluran = estimpluran;
	}

	/**
	 * Sets the flag.
	 * @param flag The flag to set
	 */
	public void setFlag(int flag) {
		this.flag = flag;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Sets the pid.
	 * @param pid The pid to set
	 */
	public void setPid(String pid) {
		this.pid = pid;
	}

	/**
	 * Sets the pnom.
	 * @param pnom The pnom to set
	 */
	public void setPnom(String pnom) {
		this.pnom = pnom;
	}

	/**
	 * Sets the preesancou.
	 * @param preesancou The preesancou to set
	 */
	public void setPreesancou(String preesancou) {
		this.preesancou = preesancou;
	}

	/**
	 * Sets the xcusag0.
	 * @param xcusag0 The xcusag0 to set
	 */
	public void setXcusag0(String xcusag0) {
		this.xcusag0 = xcusag0;
	}
	
	/**
	 * Sets the ureestime.
	 * @param ureestime The ureestime to set
	 */
	public void setUreestime(String ureestime) {
		this.ureestime = ureestime;
	}
	
	/**
	 * Sets the redate.
	 * @param redate The redate to set
	 */
	public void setRedate(String redate) {
		this.redate = redate;
	}

	public LinkedList<GestBudgHisto> getReesHisto() {
		return reesHisto;
	}

	public void setReesHisto(LinkedList<GestBudgHisto> reesHisto) {
		this.reesHisto = reesHisto;
	}
}	
    