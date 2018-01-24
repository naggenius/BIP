package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author MMC
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class RessActForm extends AutomateForm {

	/*
	 * Code DPG
	 */
	private String codsg;
	/*
	 * Code ress
	 */
	private String code_ress;
	/*
	* rnom		 */
	private String rnom;
	/*
	* Lib ress
	*/
	private String lib_ress;
	/*
	*repartition
	*/
	private String repartition;
	/*
	* total taux de repartition
	*/
		private String total_rep;
	/*
	* ancien taux de repartition
	*/
		private String oldRep;	
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
	* taux repartition
	*/
	private String tauxrep;
	/*
	 * ident
	 */
	private String ident;
	/*
	 * type
	 */
	private String type;
	/*
	 * ident choisi
	 */
	private String ident_choisi;
	
	/*
     * postion du menu
	 */
    private String pos_menu;
	

	/**
	 * Constructeur 
	 */
	public RessActForm() {
		super();
	}
	/**
	 * @return
	 */
	public String getCode_ress() {
		return code_ress;
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
	public String getIdent() {
		return ident;
	}

	/**
	 * @return
	 */
	public String getIdent_choisi() {
		return ident_choisi;
	}

	/**
	 * @return
	 */
	public String getType() {
		return type;
	}

	/**
	 * @return
	 */
	public String getPos_menu() {
		return pos_menu;
	}

	/**
	 * @param string
	 */
	public void setCode_ress(String string) {
		code_ress = string;
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
	public void setIdent(String string) {
		ident = string;
	}

	/**
	 * @param string
	 */
	public void setIdent_choisi(String string) {
		ident_choisi = string;
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
	public String getCode_activite() {
		return code_activite;
	}

	/**
	 * @return
	 */
	public String getLib_activite() {
		return lib_activite;
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
	public void setLib_activite(String string) {
		lib_activite = string;
	}

	/**
	 * @return
	 */
	public String getLib_ress() {
		return lib_ress;
	}

	/**
	 * @param string
	 */
	public void setLib_ress(String string) {
		lib_ress = string;
	}

	/**
	 * @return
	 */
	public String getRepartition() {
		return repartition;
	}

	/**
	 * @param string
	 */
	public void setRepartition(String string) {
		repartition = string;
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

	/**
	 * @return
	 */
	public String getTauxrep() {
		return tauxrep;
	}

	/**
	 * @param string
	 */
	public void setTauxrep(String string) {
		tauxrep = string;
	}

	/**
	 * @return
	 */
	public String getTotal_rep() {
		return total_rep;
	}

	/**
	 * @param string
	 */
	public void setTotal_rep(String string) {
		total_rep = string;
	}
	
	/**
	 * @param string
	 */
	public void setPos_menu(String string) {
		pos_menu = string;
	}	
	

}
