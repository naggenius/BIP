package com.socgen.bip.service.dto;

/**
 * DTO pour la table EBIS_TT_LOGS
 * Fiche 613
 * @author X060314
 *
 */
public class LogsTTEbisDto{
	
	  private String  DPG;
	  private String  SOCCODE;
	  private String  IDENT;
	  private String  RNOM;
	  private String  LMOISPREST; 
	  private String  CUSAG;
	  private String  DATDEP;
	  private String  NUMCONT;
	  private String  CAV;
	  private String  SOCCONT;
	  private String  REFERENTIEL;
	  private String  PERIMETRE;
	  private String  CDATFIN; 
	  private String  MESSAGE;
	  private String  TIMESTAMP;
	  private String  CODE_RETOUR;
	  private String  DATE_TRAIT;
	  
	  private String CODSG_CONT ; 
	  private String  SYSCPT_RES;
	  private String  SYSCPT_CONT;
	  
	public String getCAV() {
		return this.CAV;
	}
	public void setCAV(String cav) {
		CAV = cav;
	}
	public String getCDATFIN() {
		return this.CDATFIN;
	}
	public void setCDATFIN(String cdatfin) {
		CDATFIN = cdatfin;
	}
	public String getCODE_RETOUR() {
		return this.CODE_RETOUR;
	}
	public void setCODE_RETOUR(String code_retour) {
		CODE_RETOUR = code_retour;
	}
	public String getCUSAG() {
		return this.CUSAG;
	}
	public void setCUSAG(String cusag) {
		CUSAG = cusag;
	}
	public String getDATDEP() {
		return this.DATDEP;
	}
	public void setDATDEP(String datdep) {
		DATDEP = datdep;
	}
	public String getDATE_TRAIT() {
		return this.DATE_TRAIT;
	}
	public void setDATE_TRAIT(String date_trait) {
		DATE_TRAIT = date_trait;
	}
	public String getDPG() {
		return this.DPG;
	}
	public void setDPG(String dpg) {
		DPG = dpg;
	}
	public String getIDENT() {
		return this.IDENT;
	}
	public void setIDENT(String ident) {
		IDENT = ident;
	}
	public String getLMOISPREST() {
		return this.LMOISPREST;
	}
	public void setLMOISPREST(String lmoisprest) {
		LMOISPREST = lmoisprest;
	}
	public String getMESSAGE() {
		return this.MESSAGE;
	}
	public void setMESSAGE(String message) {
		MESSAGE = message;
	}
	public String getNUMCONT() {
		return this.NUMCONT;
	}
	public void setNUMCONT(String numcont) {
		NUMCONT = numcont;
	}
	public String getRNOM() {
		return this.RNOM;
	}
	public void setRNOM(String rnom) {
		RNOM = rnom;
	}
	public String getSOCCONT() {
		return this.SOCCONT;
	}
	public void setSOCCONT(String soccont) {
		SOCCONT = soccont;
	} 
	public String getSOCCODE() {
		return SOCCODE;
	}
	public void setSOCCODE(String soccode) {
		SOCCODE = soccode;
	}
	public String getTIMESTAMP() {
		return this.TIMESTAMP;
	}
	public void setTIMESTAMP(String timestamp) {
		TIMESTAMP = timestamp;
	}
	public String getCODSG_CONT() {
		return this.CODSG_CONT;
	}
	public void setCODSG_CONT(String codsg_cont) {
		this.CODSG_CONT = codsg_cont;
	}
	public String getSYSCPT_CONT() {
		return this.SYSCPT_CONT;
	}
	public void setSYSCPT_CONT(String syscpt_cont) {
		this.SYSCPT_CONT = syscpt_cont;
	}
	public String getSYSCPT_RES() {
		return this.SYSCPT_RES;
	}
	public void setSYSCPT_RES(String syscpt_res) {
		this.SYSCPT_RES = syscpt_res;
	}
	public String getPERIMETRE() {
		return PERIMETRE;
	}
	public void setPERIMETRE(String perimetre) {
		PERIMETRE = perimetre;
	}
	public String getREFERENTIEL() {
		return REFERENTIEL;
	}
	public void setREFERENTIEL(String referentiel) {
		REFERENTIEL = referentiel;
	}
	   
	
}
