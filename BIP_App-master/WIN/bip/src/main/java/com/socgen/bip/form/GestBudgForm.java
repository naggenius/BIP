package com.socgen.bip.form;

import java.util.LinkedList;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.metier.GestBudgHisto;

/**
 * @author MMC - 04/07/2003
 *
 * Formulaire pour mise à jour des budgets
 * chemin : Ligne Bip/Gestion/Gestion budget
 * pages  : bGestionbudgAd.jsp et mGestionbudgAd.jsp
 * pl/sql : gestbudg.sql
 */
public class GestBudgForm extends AutomateForm{
	
	/**
	 * Modes des écrans, utilisés dans la jsp bGestionbudgAd.jsp 
	 */
	public static String modeConsulterGlobalement = "consulterGlobalement";
	public static String modeConsulterHistoArb = "consulterHistoArbi";
	public static String modeConsulterHistoRees = "consulterHistoRees";
	
	/**
	 * Nom de la méthode de l'action GestBudgAction à appeler 
	 * pour les écrans Consulter un arbitré / réestimé et son historique
	 */
	public static String actionConsulterHisto = "consulterHisto";
	
	/**	
	 * Mode utilisé dans mGestionbudgAd et dans la psql PACK_SELECT
	 */ 
	public static String modeModifier = "update";
	/**
	 * Titres des écrans
	 */
	public static String titrePageConsulterGlobalement = "Consulter le budget d'une ann&eacute;e pour une ligne BIP";
	public static String titrePageConsulterHistoArb = "Consulter un arbitr&eacute; et son historique";
	public static String titrePageConsulterHistoRees = "Consulter un r&eacute;estim&eacute; et son historique";
	
	public static String libelleArbitre ="Arbitr&eacute; :";
	public static String libelleArbitreActuel = "Arbitr&eacute; actuel :";
	public static String libelleHistorique = "Historique";
	public static String valeurNeant = "n&eacute;ant";
	
	public static String libelleReestime = "R&eacute;estim&eacute; :";
	public static String libelleReestimeActuel = "R&eacute;estim&eacute; actuel :";
	
	public static int longueurMaxCommentaire = 200;
	
	/* La liste des historiques (valeur / date de modification / identifiant utilisé pour la modification / commentaire associé) des arbitrés / réestimés
	 */
	private LinkedList<GestBudgHisto> arbHisto;
	/*
	 * La liste des historiques (valeur / date de modification / identifiant utilisé pour la modification / commentaire associé) des réestimés
	 */
	private LinkedList<GestBudgHisto> reesHisto;

	/*Le pid
	*/
	private String pid;
	/*
	 *Le code DPG : Code departement pole groupe
	 */
	private String codsg;
	/*
	 *Le libellé du DPG
	 */
	private String libdsg;
    /*L'annee saisie
	*/
	private String annee;   
	/*
    *Le pnom
	*/
	private String pnom;
	/*Le budget proposé
	*/
	private String bud_prop;	
	/*Le
	*/
	private String bud_propmo; 
	/*Le budget notifié
	*/
	private String bud_not; 
	/*Le budget 
	*/
	private String bud_rst;	

	/*Le budget réserve
	*/
	private String reserve; 
	/*
	 * La date de modification du budget réserve
	 */
	private String bresdate;
	/*
	 * L’identifiant utilisé pour la modification du budget 
	 */
	private String ureserve;
	/*Le budget arbitré
	*/
	private String bud_arb;	

	private String astatut;
	private String date_statut;
	private int flaglock;	
	private String bud_rees;	
	private String annee_sav;	
	private String bud_test;
	/*
	 * Date de modification du budget proposé fournisseur
	 */
	private String bpdate; 
	/*
	 * Date de modification du budget proposé client
	 */
	private String bpmedate; 
	/*
	 * Date de modification du budget notifié
	 */
	private String bndate;
	/*
	 * Date de modification du budget réestimé
	 */
	private String redate;
	
	/*
	 * identifiant qui réalise l''opération sur le budget proposé par le fournisseur
	 */
	private String ubpmontme;
	/*
	 * identifiant qui réalise l''opération sur le budget proposé par le client
	 */
	private String ubpmontmo;
	/*
	 * identifiant qui réalise l''opération sur le budget notifié
	 */
	private String ubnmont;
	/*
	 * identifiant qui réalise l''opération sur le budget arbité notifié
	 */
	private String uanmont;

	/*
	 * commentaire éventuel associé à la dernière modification de la donnée arbitré
	 */
	private String arbcomm;

	/*
	 * identifiant qui réalise l''opération sur le budget réestimé
	 */
	private String ureestime;

	/*
	 * commentaire éventuel associé à la dernière modification de la donnée réestimé
	 */
	private String reescomm;

	/*
	 * Date de modification du budget notifié arbitré
	 */
	private String bnadate;

	/*
	 * YNI
	 * Perimetre MO
	 */
	private String perimo;
	
	/*
	 * YNI
	 * Perimetre ME
	 */
	private String perime;
	/**
	 * Constructor 
	 */
	public GestBudgForm() {
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
	 * Returns the annee.
	 * @return String
	 */
	public String getAnnee() {
		return annee;
	}

	/**
	 * Returns the bud_arb.
	 * @return String
	 */
	public String getBud_arb() {
		return bud_arb;
	}

	/**
	 * Returns the bud_not.
	 * @return String
	 */
	public String getBud_not() {
		return bud_not;
	}

	/**
	 * Returns the bud_prop.
	 * @return String
	 */
	public String getBud_prop() {
		return bud_prop;
	}

	/**
	 * Returns the bud_propmov.
	 * @return String
	 */
	public String getBud_propmo() {
		return bud_propmo;
	}

	/**
	 * Returns the bud_rst.
	 * @return String
	 */
	public String getBud_rst() {
		return bud_rst;
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
	 * Returns the reserve.
	 * @return String
	 */
	public String getReserve() {
		return reserve;
	}

	/**
	 * Sets the annee.
	 * @param annee The annee to set
	 */
	public void setAnnee(String annee) {
		this.annee = annee;
	}

	/**
	 * Sets the bud_arb.
	 * @param bud_arb The bud_arb to set
	 */
	public void setBud_arb(String bud_arb) {
		this.bud_arb = bud_arb;
	}

	/**
	 * Sets the bud_not.
	 * @param bud_not The bud_not to set
	 */
	public void setBud_not(String bud_not) {
		this.bud_not = bud_not;
	}

	/**
	 * Sets the bud_prop.
	 * @param bud_prop The bud_prop to set
	 */
	public void setBud_prop(String bud_prop) {
		this.bud_prop = bud_prop;
	}

	/**
	 * Sets the bud_propmov.
	 * @param bud_propmov The bud_propmov to set
	 */
	public void setBud_propmo(String bud_propmo) {
		this.bud_propmo = bud_propmo;
	}

	/**
	 * Sets the bud_rst.
	 * @param bud_rst The bud_rst to set
	 */
	public void setBud_rst(String bud_rst) {
		this.bud_rst = bud_rst;
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
	 * Sets the reserve.
	 * @param reserve The reserve to set
	 */
	public void setReserve(String reserve) {
		this.reserve = reserve;
	}

	/**
	 * Returns the astatut.
	 * @return String
	 */
	public String getAstatut() {
		return astatut;
	}

	/**
	 * Returns the date_statut.
	 * @return String
	 */
	public String getDate_statut() {
		return date_statut;
	}

	/**
	 * Returns the flaglock.
	 * @return int
	 */
	public int getFlaglock() {
		return flaglock;
	}

	/**
	 * Sets the astatut.
	 * @param astatut The astatut to set
	 */
	public void setAstatut(String astatut) {
		this.astatut = astatut;
	}

	/**
	 * Sets the date_statut.
	 * @param date_statut The date_statut to set
	 */
	public void setDate_statut(String date_statut) {
		this.date_statut = date_statut;
	}

	/**
	 * Sets the flaglock.
	 * @param flaglock The flaglock to set
	 */
	public void setFlaglock(int flaglock) {
		this.flaglock = flaglock;
	}

	/**
	 * Returns the bud_rees.
	 * @return String
	 */
	public String getBud_rees() {
		return bud_rees;
	}

	/**
	 * Sets the bud_rees.
	 * @param bud_rees The bud_rees to set
	 */
	public void setBud_rees(String bud_rees) {
		this.bud_rees = bud_rees;
	}

	/**
	 * Returns the annee_sav.
	 * @return String
	 */
	public String getAnnee_sav() {
		return annee_sav;
	}

	/**
	 * Sets the annee_sav.
	 * @param annee_sav The annee_sav to set
	 */
	public void setAnnee_sav(String annee_sav) {
		this.annee_sav = annee_sav;
	}

	/**
	 * Returns the bud_test.
	 * @return String
	 */
	public String getBud_test() {
		return bud_test;
	}

	/**
	 * Sets the bud_test.
	 * @param bud_test The bud_test to set
	 */
	public void setBud_test(String bud_test) {
		this.bud_test = bud_test;
	}
	
	/**
	 * Returns the BPDATE.
	 * @return String
	 */
	
	public String getBpdate() {
		return bpdate;
	}

	/**
	 * Sets the BPDATE.
	 * @param BPDATE The bndate to set
	 */
	
	public void setBpdate(String bpdate) {
		this.bpdate = bpdate;
	}
	
	/**
	 * Returns the BNDATE.
	 * @return String
	 */
	
	public String getBndate() {
		return bndate;
	}

	/**
	 * Sets the BNDATE.
	 * @param BNDATE The bndate to set
	 */
	
	public void setBndate(String bndate) {
		this.bndate = bndate;
	}

	/**
	 * Returns the BPMEDATE.
	 * @return String
	 */
	
	public String getBpmedate() {
		return bpmedate;
	}

	/**
	 * Sets the BPMEDATE.
	 * @param BPMEDATE The bpmedate to set
	 */
	
	public void setBpmedate(String bpmedate) {
		this.bpmedate = bpmedate;
	}

	/**
	 * Returns the REDATE.
	 * @return String
	 */
	
	public String getRedate() {
		return redate;
	}

	/**
	 * Sets the REDATE.
	 * @param REDATE The redate to set
	 */
	
	public void setRedate(String redate) {
		this.redate = redate;
	}

	/**
	 * Returns the UANMONT.
	 * @return String
	 */
	
	public String getUanmont() {
		return uanmont;
	}

	/**
	 * Sets the UANMONT.
	 * @param UANMONT The uanmont to set
	 */
	
	public void setUanmont(String uanmont) {
		this.uanmont = uanmont;
	}

	/**
	 * Returns the UBNMONT.
	 * @return String
	 */
	
	public String getUbnmont() {
		return ubnmont;
	}

	/**
	 * Sets the UBNMONT.
	 * @param UBNMONT The ubnmont to set
	 */
	
	public void setUbnmont(String ubnmont) {
		this.ubnmont = ubnmont;
	}

	/**
	 * Returns the UBPMONTME.
	 * @return String
	 */
	
	public String getUbpmontme() {
		return ubpmontme;
	}

	/**
	 * Sets the UBPMONTME.
	 * @param UBPMONTME The ubpmontme to set
	 */
	
	public void setUbpmontme(String ubpmontme) {
		this.ubpmontme = ubpmontme;
	}

	/**
	 * Returns the UBPMONTMO.
	 * @return String
	 */
	
	public String getUbpmontmo() {
		return ubpmontmo;
	}

	/**
	 * Sets the UBPMONTMO.
	 * @param UBPMONTMO The ubpmontmo to set
	 */
	
	public void setUbpmontmo(String ubpmontmo) {
		this.ubpmontmo = ubpmontmo;
	}
	
	/**
	 * Returns the UREESTIME.
	 * @return String
	 */
	
	public String getUreestime() {
		return ureestime;
	}

	/**
	 * Sets the UREESTIME.
	 * @param UREESTIME The ureestime to set
	 */
	
	public void setUreestime(String ureestime) {
		this.ureestime = ureestime;
	}
	
	/**
	 * Returns the bnadate.
	 * @return String
	 */
	
	public String getBnadate() {
		return bnadate;
	}
	
	/**
	 * Sets the bnadate.
	 * @param bnadate The bnadate to set
	 */
	
	public void setBnadate(String bnadate) {
		this.bnadate = bnadate;
	}

	/**
	 * @return the perime
	 */
	public String getPerime() {
		return perime;
	}

	/**
	 * @param perime the perime to set
	 */
	public void setPerime(String perime) {
		this.perime = perime;
	}

	/**
	 * @return the perimo
	 */
	public String getPerimo() {
		return perimo;
	}

	/**
	 * @param perimo the perimo to set
	 */
	public void setPerimo(String perimo) {
		this.perimo = perimo;
	}

	public String getCodsg() {
		return codsg;
	}

	public void setCodsg(String codsg) {
		this.codsg = codsg;
	}

	public String getArbcomm() {
		return arbcomm;
	}

	public void setArbcomm(String arbcomm) {
		this.arbcomm = arbcomm;
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
	 * Obtention du nombre de caractères restants possibles en saisie du champ arbComm 
	 *
	 */
	public String getObtenirNbCarRestantsArbcomm() {
		return String.valueOf(obtenirNbCarRestantsComm(getArbcomm(), longueurMaxCommentaire));
	}
	
	public String getReescomm() {
		return reescomm;
	}

	public void setReescomm(String reescomm) {
		this.reescomm = reescomm;
		StringUtils.isNotEmpty("");
	}
	
	/**
	 * Obtention du nombre de caractères restants possibles en saisie du champ reesComm 
	 *
	 */
	public String getNbCarRestantsReescomm() {
		return String.valueOf(obtenirNbCarRestantsComm(getReescomm(), longueurMaxCommentaire));
	}

	public String getBresdate() {
		return bresdate;
	}

	public void setBresdate(String bresdate) {
		this.bresdate = bresdate;
	}

	public String getLibdsg() {
		return libdsg;
	}

	public void setLibdsg(String libsg) {
		this.libdsg = libsg;
	}

	public String getUreserve() {
		return ureserve;
	}

	public void setUreserve(String ureserve) {
		this.ureserve = ureserve;
	}

	public LinkedList<GestBudgHisto> getArbHisto() {
		return arbHisto;
	}

	public void setArbHisto(LinkedList<GestBudgHisto> arbHisto) {
		this.arbHisto = arbHisto;
	}

	public LinkedList<GestBudgHisto> getReesHisto() {
		return reesHisto;
	}

	public void setReesHisto(LinkedList<GestBudgHisto> reesHisto) {
		this.reesHisto = reesHisto;
	}

}


