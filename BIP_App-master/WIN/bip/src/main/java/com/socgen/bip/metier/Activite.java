package com.socgen.bip.metier;

/**
 * @author X058813
 *
 * represente une actualite
 * chemin : Outil de reestime/Activite
 * pages  : bActiviteRe.jsp, fmActiviteRe.jsp, mActiviteRe.jsp 
 * pl/sql : ree_activites.sql
 */
public class Activite {

	/*
	 * Code DPG
	 */
	private String codsg;
	/*
	 * Code activite
	 */
	private String code_activite;
	/*
	 * libelle activite
	 */
	private String lib_activite;
	/*
	 * type de l'activite
	 */
	private String type;
	
	/**
	 * 
	 */
	public Activite() {
		super();
	}

	public Activite(String codsg, String code_activite, String lib_activite, String type)
	{
		this.codsg = codsg;
		this.code_activite = code_activite;
		this.lib_activite = lib_activite;
		this.type = type;
	}
	
	public Activite(String codsg, String code_activite, String lib_activite)
	{
		this.codsg = codsg;
		this.code_activite = code_activite;
		this.lib_activite = lib_activite;
	}
	
	/**
	 * @return
	 */
	public String getCode_activite() {
		return code_activite;
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
	public String getLib_activite() {
		return lib_activite;
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
	public void setCode_activite(String string) {
		code_activite = string;
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
	public void setLib_activite(String string) {
		lib_activite = string;
	}

	/**
	 * @param string
	 */
	public void setType(String string) {
		type = string;
	}

}
