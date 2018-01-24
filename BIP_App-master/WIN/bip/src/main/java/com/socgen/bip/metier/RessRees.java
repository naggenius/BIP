package com.socgen.bip.metier;

/**
 * @author MMC
 *
 * represente une ressource dans l'outil des reestimes
 * chemin : Outil de reestime/Ressource
 * pages  : bRessourceRe.jsp, fmRessourceRe.jsp, mRessourceRe.jsp 
 * pl/sql : ree_ress.sql
 */
public class RessRees {

	/*
	 * Code DPG
	 */
	private String codsg;
	/*
	 *ident
	 */
	private String ident;
	/*
	 * nom
	 */
	private String rnom;
	/*
	 * prenom
	 */
	private String rprenom;
	/*
	 * type 
	 */
	private String type;
	/*
		 * code_ress
		 */
		private String code_ress;
	/*
	 * date de d'arrivee
	 */
	private String datarrivee;
	/*
	 * date de départ 
	 */
	private String datdep;
	/**
	 * 
	 */
	public RessRees() {
		super();
	}

	public RessRees(String codsg,String type, String ident, String rnom, String rprenom, String datdep,String code_ress, String p_datarrivee)
	{
		this.codsg = codsg;
		this.type = type;
		this.ident = ident;
		this.rnom = rnom;
		this.rprenom = rprenom;
		this.datdep = datdep;
		this.code_ress = code_ress;
		this.datarrivee = p_datarrivee;
		
	}
	
	
	/**
	 * @return
	 */
	public String getIdent() {
		return ident;
	}

	/**
	 * @return
	 */
	public String getCodsg() {
		return codsg;
	}

	/**
	 * @return
	 */
	public String getRnom() {
		return rnom;
	}
	/**
	 * @return
	 */
	public String getRprenom() {
		return rprenom;
	}
	/**
	 * @return
	 */
	public String getDatdep() {
		return datdep;
	}

	/**
	 * @return
	 */
	public String getType() {
		return type;
	}

	/**
	 * @param string
	 */
	public void setIdent(String string) {
		ident = string;
	}

	/**
	 * @param string
	 */
	public void setCodsg(String string) {
		codsg = string;
	}

	/**
	 * @param string
	 */
	public void setRnom(String string) {
		rnom = string;
	}
	/**
	 * @param string
	 */
	public void setRprenom(String string) {
		rprenom = string;
	}

	/**
	 * @param string
	 */
	public void setType(String string) {
		type = string;
	}
	/**
	 * @param string
	 */
	public void setDatdep(String string) {
		datdep = string;
	}

	/**
	 * @return
	 */
	public String getCode_ress() {
		return code_ress;
	}

	/**
	 * @param string
	 */
	public void setCode_ress(String string) {
		code_ress = string;
	}

	/**
	 * @return
	 */
	public String getDatarrivee() {
		return datarrivee;
	}

	/**
	 * @param string
	 */
	public void setDatarrivee(String string) {
		datarrivee = string;
	}

}
