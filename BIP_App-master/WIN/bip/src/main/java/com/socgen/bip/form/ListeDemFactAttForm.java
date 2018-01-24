package com.socgen.bip.form;

import java.util.ArrayList;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author JMA - 03/03/2006
 *
 * Formulaire 
 * pages : 
 */

public class ListeDemFactAttForm extends AutomateForm {

	private ArrayList listeDemande;
	private String mois;
	private String statut;

	private String socfact;
	private String typfact;
	private String datfact;
	private String numfact;
	private String lnum;
	private String iddem;
	private String datdem;
	private String causesuspens;
	private String readonly;	// visualisation ou saisi cause suspens/date suivi
	private String listeFact;  	// liste des numéros de facture afficher lors de la mise en suspens ou de la validation
	private String nom_cp;     	// nom du chef de projet pour le mail
	private String texte_mail; 	// texte du mail à envoyer

	private String faccsec;    	// date accord pole
	private String fregcompta; 	// date envoi réglement comptable
	private String fstatut2;
	private String fenrcompta ;
	private String fenvsec ;
	private String fnom ;
	private String fmodreglt ;
	private String fordrecheq ;
	private String fburdistr ;
	private String cdatfin ;  
	private String flaglock ; 
	private String fcodepost ;
	private String fadresse1 ;
	private String fadresse2 ;
	private String fadresse3 ;
	private String msg_info ;

	private int nbreFacture=0;		// nombre de facture rattaché à la demande

	/**
	 * 
	 */
	public ListeDemFactAttForm() {
		super();
		listeDemande = new ArrayList();
	}


	/**
	 * @return
	 */
	public ArrayList getListeDemande() {
		return listeDemande;
	}

	/**
	 * @return
	 */
	public String getMois() {
		return mois;
	}

	/**
	 * @return
	 */
	public String getStatut() {
		return statut;
	}

	/**
	 * @param list
	 */
	public void setListeDemande(ArrayList list) {
		listeDemande = list;
	}

	public void addDemande(Object o) {
		listeDemande.add(o);
	}

	/**
	 * @param string
	 */
	public void setMois(String string) {
		mois = string;
	}

	/**
	 * @param string
	 */
	public void setStatut(String string) {
		statut = string;
	}

	/**
	 * @return
	 */
	public String getDatdem() {
		return datdem;
	}

	/**
	 * @return
	 */
	public String getDatfact() {
		return datfact;
	}

	/**
	 * @return
	 */
	public String getLnum() {
		return lnum;
	}

	/**
	 * @return
	 */
	public String getNumfact() {
		return numfact;
	}

	/**
	 * @return
	 */
	public String getSocfact() {
		return socfact;
	}

	/**
	 * @return
	 */
	public String getTypfact() {
		return typfact;
	}

	/**
	 * @param string
	 */
	public void setDatdem(String string) {
		datdem = string;
	}

	/**
	 * @param string
	 */
	public void setDatfact(String string) {
		datfact = string;
	}

	/**
	 * @param string
	 */
	public void setLnum(String string) {
		lnum = string;
	}

	/**
	 * @param string
	 */
	public void setNumfact(String string) {
		numfact = string;
	}

	/**
	 * @param string
	 */
	public void setSocfact(String string) {
		socfact = string;
	}

	/**
	 * @param string
	 */
	public void setTypfact(String string) {
		typfact = string;
	}

	/**
	 * @return
	 */
	public String getCausesuspens() {
		return causesuspens;
	}

	/**
	 * @return
	 */
	public String getFaccsec() {
		return faccsec;
	}

	/**
	 * @return
	 */
	public String getFregcompta() {
		return fregcompta;
	}

	/**
	 * @return
	 */
	public String getFstatut2() {
		return fstatut2;
	}

	/**
	 * @param string
	 */
	public void setCausesuspens(String string) {
		causesuspens = string;
	}

	/**
	 * @param string
	 */
	public void setFaccsec(String string) {
		faccsec = string;
	}

	/**
	 * @param string
	 */
	public void setFregcompta(String string) {
		fregcompta = string;
	}

	/**
	 * @param string
	 */
	public void setFstatut2(String string) {
		fstatut2 = string;
	}

	/**
	 * @return
	 */
	public String getReadonly() {
		return readonly;
	}

	/**
	 * @param string
	 */
	public void setReadonly(String string) {
		readonly = string;
	}

	/**
	 * @return
	 */
	public String getIddem() {
		return iddem;
	}

	/**
	 * @param string
	 */
	public void setIddem(String string) {
		iddem = string;
	}

	/**
	 * @return
	 */
	public String getListeFact() {
		return listeFact;
	}

	/**
	 * @param string
	 */
	public void setListeFact(String string) {
		listeFact = string;
	}

	/**
	 * @return
	 */
	public String getNom_cp() {
		return nom_cp;
	}

	/**
	 * @param string
	 */
	public void setNom_cp(String string) {
		nom_cp = string;
	}

	/**
	 * @return
	 */
	public String getTexte_mail() {
		return texte_mail;
	}

	/**
	 * @param string
	 */
	public void setTexte_mail(String string) {
		texte_mail = string;
	}

	/**
	 * @return
	 */
	public String getCdatfin() {
		return cdatfin;
	}

	/**
	 * @return
	 */
	public String getFadresse1() {
		return fadresse1;
	}

	/**
	 * @return
	 */
	public String getFadresse2() {
		return fadresse2;
	}

	/**
	 * @return
	 */
	public String getFadresse3() {
		return fadresse3;
	}

	/**
	 * @return
	 */
	public String getFburdistr() {
		return fburdistr;
	}

	/**
	 * @return
	 */
	public String getFcodepost() {
		return fcodepost;
	}

	/**
	 * @return
	 */
	public String getFenrcompta() {
		return fenrcompta;
	}

	/**
	 * @return
	 */
	public String getFenvsec() {
		return fenvsec;
	}

	/**
	 * @return
	 */
	public String getFlaglock() {
		return flaglock;
	}

	/**
	 * @return
	 */
	public String getFmodreglt() {
		return fmodreglt;
	}

	/**
	 * @return
	 */
	public String getFnom() {
		return fnom;
	}

	/**
	 * @return
	 */
	public String getFordrecheq() {
		return fordrecheq;
	}

	/**
	 * @return
	 */
	public String getMsg_info() {
		return msg_info;
	}

	/**
	 * @param string
	 */
	public void setCdatfin(String string) {
		cdatfin = string;
	}

	/**
	 * @param string
	 */
	public void setFadresse1(String string) {
		fadresse1 = string;
	}

	/**
	 * @param string
	 */
	public void setFadresse2(String string) {
		fadresse2 = string;
	}

	/**
	 * @param string
	 */
	public void setFadresse3(String string) {
		fadresse3 = string;
	}

	/**
	 * @param string
	 */
	public void setFburdistr(String string) {
		fburdistr = string;
	}

	/**
	 * @param string
	 */
	public void setFcodepost(String string) {
		fcodepost = string;
	}

	/**
	 * @param string
	 */
	public void setFenrcompta(String string) {
		fenrcompta = string;
	}

	/**
	 * @param string
	 */
	public void setFenvsec(String string) {
		fenvsec = string;
	}

	/**
	 * @param string
	 */
	public void setFlaglock(String string) {
		flaglock = string;
	}

	/**
	 * @param string
	 */
	public void setFmodreglt(String string) {
		fmodreglt = string;
	}

	/**
	 * @param string
	 */
	public void setFnom(String string) {
		fnom = string;
	}

	/**
	 * @param string
	 */
	public void setFordrecheq(String string) {
		fordrecheq = string;
	}

	/**
	 * @param string
	 */
	public void setMsg_info(String string) {
		msg_info = string;
	}

	/**
	 * @return
	 */
	public int getNbreFacture() {
		return nbreFacture;
	}

	/**
	 * @param i
	 */
	public void setNbreFacture(int i) {
		nbreFacture = i;
	}

}