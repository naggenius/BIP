
package com.socgen.bip.metier;


/**
 * @author A131188
 *
 * Objet M�tier repr�sentant une ligne de sc�nario pour l'outil de reestime
 * chemin : Outil de r�estim� / Sc�narios
 * pages  : mScenarioRe.jsp , bScenarioRe.jsp, fmScenarioRe.jsp
 * pl/sql : ree_scenarios.sql
 */
public class Scenario {
	/*
	 * Code DPG
	 */
	private String codsg;
	/*
	 * Code sc�nario
	 */
	private String code_scenario;
	/*
	 * Code sc�nario choisi
	 */
	private String code_scenario_choisi;
	/*
	 * libelle sc�nario
	 */
	private String lib_scenario;
	/*
	 * D�finit si le sc�nario est officiel
	 */
	private String officiel;
	/*
	 * Commentaire pour d�crire le sc�nario
	 */
	private String commentaire;

	/**
	 * Constructeur pour scenario
	 */
	public Scenario() {
		super();
	}

	public Scenario(String codsg, String code_scenario, String lib_scenario, String officiel)
	{
		this.codsg = codsg;
		this.code_scenario = code_scenario;
		this.lib_scenario = lib_scenario;
		this.officiel = officiel;
	}


	/**
	 * @return
	 */
	public String getCode_scenario() {
		return code_scenario;
	}

	/**
	 * @return
	 */
	public String getCode_scenario_choisi() {
		return code_scenario_choisi;
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
	public String getCommentaire() {
		return commentaire;
	}

	/**
	 * @return
	 */
	public String getLib_scenario() {
		return lib_scenario;
	}

	/**
	 * @return
	 */
	public String getOfficiel() {
		return officiel;
	}

	/**
	 * @param string
	 */
	public void setCode_scenario(String string) {
		code_scenario = string;
	}

	/**
	 * @param string
	 */
	public void setCode_scenario_choisi(String string) {
		code_scenario_choisi = string;
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
	public void setCommentaire(String string) {
		commentaire = string;
	}

	/**
	 * @param string
	 */
	public void setLib_scenario(String string) {
		lib_scenario = string;
	}

	/**
	 * @param string
	 */
	public void setOfficiel(String string) {
		officiel = string;
	}

}
