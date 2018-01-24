package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author X058813
 *
 * Formualire correspondant aux activites de l'outil de reestime
 * chemin : Mise à jour / Activite
 * pages  : fActiviteRe.jsp , bActiviteRe.jsp, fmActiviteRe.jsp
 * pl/sql : ree_activites.sql
 */
public class ActiviteForm extends AutomateForm {

	/*
	 * Code DPG
	 */
	private String codsg;
	/*
	 * Code activite
	 */
	private String code_activite;
	/*
	 * Code activite choisi
	 */
	private String code_activite_choisi;
	/*
	 * libelle activite
	 */
	private String lib_activite;
	/*
	 * type de l'activite
	 */
	private String type;

	/**
	 * Constructeur pour activiteForm
	 */
	public ActiviteForm() {
		super();
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

	/**
	 * @return
	 */
	public String getCode_activite_choisi() {
		return code_activite_choisi;
	}

	/**
	 * @param string
	 */
	public void setCode_activite_choisi(String string) {
		code_activite_choisi = string;
	}

}
