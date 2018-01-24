package com.socgen.bip.form;

//import javax.servlet.http.HttpServletRequest;

//import org.apache.struts.action.ActionErrors;
//import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author J. MAS - 03/11/2005
 *
 * Formulaire de saisie des tables de répartition
 * chemin : Lignes BIP/Répartition JH/Table de répartition
 * pages  : fTableRepart.jsp , mTableRepart.jsp
 * pl/sql : ls_rjh.sql
 */
public class TableRepartForm extends AutomateForm {
         
	/*
	 * Code Table de répartition
	 */
	private String codrep;

	/*
	 * Libellé Table de répartiton
	 */
	private String librep;
	
	/*
	 * Code de la direction
	 */
	private String coddir;
	
	/*
	 * Libellé de la direction
	 */
	private String libdir;
	
	/*
	 * Flag d'activité
	 */
	private String flagactif;
	
	/*
	 * CODE DPG
	 */
	private String coddeppole;
	
	/*
	 * lib DPG
	 */
	private String libdeppole;

	/*
	 * La position de la table de répartition dans la liste 
	 */	
	protected String posTabRepart;			
	
     /**
	 * Constructor for ClientForm.
	 */
	public TableRepartForm() {
		super();
		this.setFlagactif("false");
	}
	

	/**
	 * @return
	 */
	public String getCoddir() {
		return coddir;
	}

	/**
	 * @return
	 */
	public String getFlagactif() {
		return flagactif;
	}

	/**
	 * @return
	 */
	public String getLibrep() {
		return librep;
	}
	
	/**
	 * @return
	 */
	public String getCoddeppole() {
		return coddeppole;
	}
	/**
	 * @return
	 */
	public String getLibdeppole() {
		return libdeppole;
	}

	/**
	 * @return
	 */
	public String getPosTabRepart() {
		return posTabRepart;
	}

	/**
	 * @param string
	 */
	public void setCoddir(String string) {
		coddir = string;
	}

	/**
	 * @param string
	 */
	public void setFlagactif(String string) {
		flagactif = string;
	}
	
	/**
	 * @param string
	 */
	public void setCoddeppole(String string) {
		coddeppole = string;
	}
	/**
	 * @param string
	 */
	public void setLibdeppole(String string) {
		libdeppole= string;
	}

	/**
	 * @param string
	 */
	public void setLibrep(String string) {
		librep = string;
	}

	/**
	 * @param string
	 */
	public void setPosTabRepart(String string) {
		posTabRepart = string;
	}

	/**
	 * @return
	 */
	public String getLibdir() {
		return libdir;
	}

	/**
	 * @param string
	 */
	public void setLibdir(String string) {
		libdir = string;
	}

	/**
	 * @return
	 */
	public String getCodrep() {
		return codrep;
	}

	/**
	 * @param string
	 */
	public void setCodrep(String string) {
		codrep = string;
	}

}
