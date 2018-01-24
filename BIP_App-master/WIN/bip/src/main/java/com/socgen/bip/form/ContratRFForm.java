package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;



/**
 * KRA : PPM 59805
 * Formulaire Edition eContratRF 
 * 
 * chemin : Ordonnancement > Edition > "Contrats / Ress / Fact"
 * ou : Responsable d'études > Ressources > Editions > "Contrats / Ress / Fact"
 * pages  : eContratRF.jsp
 * pl/sql : 
 * 
 */
public class ContratRFForm extends AutomateForm {

 private static final long serialVersionUID = 1L;

 private String critereDosPac;
  
 private String critereRefCon;
 
 private String critereRefAve;
 
 private String critereNom;
 
 private String critereIgg;
 
 private String critereMatArp;
 
 private String critereIdenBip;
 
 private String critereRefFac;
 
 private String critereRefExp;
 
 private String champsDosPac;
 
 private String champsRefCon;
 
 private String champsRefAve;
 
 private String champsNom;
 
 private String champsIgg;
 
 private String champsMatArp;
 
 private String champsIdenBip;
 
 private String champsRefFac;
 
 private String champsRefExp;
   
 private String champsRacine;
 
 private String champsAvenant;

 private String userid ;
 
 private String centrefrais;
 
 private String perime;
 
 private int numProcess;
 
    
	/**
	 * Constructor for ClientForm.
	 */
	public ContratRFForm() {
		super();
	}
	
   
    public ActionErrors validate(ActionMapping mapping,HttpServletRequest request) 
    {
        this.logIhm.debug("(ContratRFForm) (validate) => debut") ;
        ActionErrors errors = new ActionErrors();
        this.logIhm.debug("(ContratRFForm) (validate) => fin") ;
        return errors; 
    }
	
	

public String getCritereDosPac() {
	return critereDosPac;
}

public void setCritereDosPac(String critereDosPac) {
	this.critereDosPac = critereDosPac;
}

public String getCritereRefCon() {
	return critereRefCon;
}

public void setCritereRefCon(String critereRefCon) {
	this.critereRefCon = critereRefCon;
}


public String getCritereRefAve() {
	return critereRefAve;
}

public void setCritereRefAve(String critereRefAve) {
	this.critereRefAve = critereRefAve;
}

public String getCritereNom() {
	return critereNom;
}

public void setCritereNom(String critereNom) {
	this.critereNom = critereNom;
}


public String getCritereIgg() {
	return critereIgg;
}

public void setCritereIgg(String critereIgg) {
	this.critereIgg = critereIgg;
}


public String getCritereMatArp() {
	return critereMatArp;
}

public void setCritereMatArp(String critereMatArp) {
	this.critereMatArp = critereMatArp;
}


public String getCritereIdenBip() {
	return critereIdenBip;
}

public void setCritereIdenBip(String critereIdenBip) {
	this.critereIdenBip = critereIdenBip;
}


public String getCritereRefFac() {
	return critereRefFac;
}

public void setCritereRefFac(String critereRefFac) {
	this.critereRefFac = critereRefFac;
}


public String getCritereRefExp() {
	return critereRefExp;
}

public void setCritereRefExp(String critereRefExp) {
	this.critereRefExp = critereRefExp;
}

public String getChampsDosPac() {
	return champsDosPac;
}

public void setChampsDosPac(String champsDosPac) {
	this.champsDosPac = champsDosPac;
}

public String getChampsRefCon() {
	return champsRefCon;
}

public void setChampsRefCon(String champsRefCon) {
	this.champsRefCon = champsRefCon;
}



public String getChampsRefAve() {
	return champsRefAve;
}

public void setChampsRefAve(String champsRefAve) {
	this.champsRefAve = champsRefAve;
}


public String getChampsNom() {
	return champsNom;
}

public void setChampsNom(String champsNom) {
	this.champsNom = champsNom;
}


public String getChampsIgg() {
	return champsIgg;
}

public void setChampsIgg(String champsIgg) {
	this.champsIgg = champsIgg;
}


public String getChampsMatArp() {
	return champsMatArp;
}

public void setChampsMatArp(String champsMatArp) {
	this.champsMatArp = champsMatArp;
}


public String getChampsIdenBip() {
	return champsIdenBip;
}

public void setChampsIdenBip(String champsIdenBip) {
	this.champsIdenBip = champsIdenBip;
}


public String getChampsRefFac() {
	return champsRefFac;
}

public void setChampsRefFac(String champsRefFac) {
	this.champsRefFac = champsRefFac;
}

public String getChampsRefExp() {
	return champsRefExp;
}

public void setChampsRefExp(String champsRefExp) {
	this.champsRefExp = champsRefExp;
}

public String getChampsRacine() {
	return champsRacine;
}

public void setChampsRacine(String champsRacine) {
	this.champsRacine = champsRacine;
}


public String getChampsAvenant() {
	return champsAvenant;
}

public void setChampsAvenant(String champsAvenant) {
	this.champsAvenant = champsAvenant;
}
 

public String getUserid() {
	return this.userid;
}

public void setUserid(String userid) {
	this.userid = userid;
}


public String getCentrefrais() {
	return centrefrais;
}


public void setCentrefrais(String centrefrais) {
	this.centrefrais = centrefrais;
}


public String getPerime() {
	return perime;
}


public void setPerime(String perime) {
	this.perime = perime;
}


public int getNumProcess() {
	return numProcess;
}


public void setNumProcess(int numProcess) {
	this.numProcess = numProcess;
}




}
