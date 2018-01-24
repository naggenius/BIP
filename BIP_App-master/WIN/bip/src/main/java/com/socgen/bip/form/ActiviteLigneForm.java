/*
 * Created on 2 mai 05
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.socgen.bip.form;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * @author X058813
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class ActiviteLigneForm extends AutomateForm {

	/*
	 * Code DPG
	 */
	private String codsg;
	/*
	 * Code activite
	 */
	private String code_activite;
	/*
	 * Code activite
	 */
	private String lib_activite;
	/*
	 * code BIP
	 */
	private String pid;
	/*
	 * code BIP
	 */
	private String pid_choisi;
	/*
	 * Lib BIP
	 */
	private String lib_ligne;
	/*
     * Position menu
	*/
		private String pos_menu;	
	


	/**
	 * Constructeur pour activiteForm
	 */
	public ActiviteLigneForm() {
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
	 * @return
	 */
	public String getPid() {
		return pid;
	}

	/**
	 * @return
	 */
	public String getPid_choisi() {
		return pid_choisi;
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
	public void setPid(String string) {
		pid = string;
	}

	/**
	 * @param string
	 */
	public void setPid_choisi(String string) {
		pid_choisi = string;
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
	public void setLib_activite(String string) {
		lib_activite = string;
	}

	/**
	 * @return
	 */
	public String getLib_ligne() {
		return lib_ligne;
	}

	/**
	 * @param string
	 */
	public void setLib_ligne(String string) {
		lib_ligne = string;
	}
	
	/**
	 * @param string
	 */
	public void setPos_menu(String string) {
		pos_menu = string;
	}

}
