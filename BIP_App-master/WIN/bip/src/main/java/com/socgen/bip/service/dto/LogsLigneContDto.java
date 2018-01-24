package com.socgen.bip.service.dto;

/**
 * DTO pour la table LIGNE_CONT_LOGS
 * Fiche 607
 * @author X069538
 *
 */
public class LogsLigneContDto{
	
	  private String TYPE_ACTION; 
	  private String DATE_LOG;
	  private String USER_LOG;
	  private String CONTRAT;
	  private String PERIMETRE;
	  private String REFFOURNISSEUR; 
	  private String FOURNISSEUR;
	  private String LIGNE;
	  private String CODE_RESSOURCE;    
	  private String NOM_RESSOURCE;
	  private String DATEDEB_LIGNE; 
	  private String DATEFIN_LIGNE; 
	  private String SOCIETE;
	  private String SIREN;
	  private String AVENANT; 
	  private String DATDEBCONTRAT; 
	  private String DATFINCONTRAT;
	  
	  
	public String getAVENANT() {
		return AVENANT;
	}
	public void setAVENANT(String avenant) {
		AVENANT = avenant;
	}
	public String getCODE_RESSOURCE() {
		return CODE_RESSOURCE;
	}
	public void setCODE_RESSOURCE(String code_ressource) {
		CODE_RESSOURCE = code_ressource;
	}
	public String getCONTRAT() {
		return CONTRAT;
	}
	public void setCONTRAT(String contrat) {
		CONTRAT = contrat;
	}
	public String getDATDEBCONTRAT() {
		return DATDEBCONTRAT;
	}
	public void setDATDEBCONTRAT(String datdebcontrat) {
		DATDEBCONTRAT = datdebcontrat;
	}
	public String getDATE_LOG() {
		return DATE_LOG;
	}
	public void setDATE_LOG(String date_log) {
		DATE_LOG = date_log;
	}
	public String getDATEDEB_LIGNE() {
		return DATEDEB_LIGNE;
	}
	public void setDATEDEB_LIGNE(String datedeb_ligne) {
		DATEDEB_LIGNE = datedeb_ligne;
	}
	public String getDATEFIN_LIGNE() {
		return DATEFIN_LIGNE;
	}
	public void setDATEFIN_LIGNE(String datefin_ligne) {
		DATEFIN_LIGNE = datefin_ligne;
	}
	public String getDATFINCONTRAT() {
		return DATFINCONTRAT;
	}
	public void setDATFINCONTRAT(String datfincontrat) {
		DATFINCONTRAT = datfincontrat;
	}
	public String getFOURNISSEUR() {
		return FOURNISSEUR;
	}
	public void setFOURNISSEUR(String fournisseur) {
		FOURNISSEUR = fournisseur;
	}
	public String getLIGNE() {
		return LIGNE;
	}
	public void setLIGNE(String ligne) {
		LIGNE = ligne;
	}
	public String getNOM_RESSOURCE() {
		return NOM_RESSOURCE;
	}
	public void setNOM_RESSOURCE(String nom_ressource) {
		NOM_RESSOURCE = nom_ressource;
	}
	public String getPERIMETRE() {
		return PERIMETRE;
	}
	public void setPERIMETRE(String perimetre) {
		PERIMETRE = perimetre;
	}
	public String getREFFOURNISSEUR() {
		return REFFOURNISSEUR;
	}
	public void setREFFOURNISSEUR(String reffournisseur) {
		REFFOURNISSEUR = reffournisseur;
	}
	public String getSIREN() {
		return SIREN;
	}
	public void setSIREN(String siren) {
		SIREN = siren;
	}
	public String getSOCIETE() {
		return SOCIETE;
	}
	public void setSOCIETE(String societe) {
		SOCIETE = societe;
	}
	public String getTYPE_ACTION() {
		return TYPE_ACTION;
	}
	public void setTYPE_ACTION(String type_action) {
		TYPE_ACTION = type_action;
	}
	public String getUSER_LOG() {
		return USER_LOG;
	}
	public void setUSER_LOG(String user_log) {
		USER_LOG = user_log;
	}
	  

	  
	
	   
	
}
