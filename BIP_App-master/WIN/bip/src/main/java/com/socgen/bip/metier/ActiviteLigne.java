/*
 * Created on 2 mai 05
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.socgen.bip.metier;

/**
 * @author X058813
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class ActiviteLigne {

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
	 * libelle BIP
	 */
	private String lib_ligne;
	
	/**
	 * 
	 */
	public ActiviteLigne() {
		super();
	}

	public ActiviteLigne(String codsg, String code_activite, String lib_activite, String pid, String lib_ligne)
	{
		this.codsg = codsg;
		this.code_activite = code_activite;
		this.lib_activite = lib_activite;
		this.pid = pid;
		this.lib_ligne = lib_ligne;
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
	public String getLib_ligne() {
		return lib_ligne;
	}

	/**
	 * @return
	 */
	public String getPid() {
		return pid;
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
	public void setLib_ligne(String string) {
		lib_ligne = string;
	}

	/**
	 * @param string
	 */
	public void setPid(String string) {
		pid = string;
	}
	
	/**
	 * surcharge de la methode equals
	 * @param activiteLigne
	 */
	public boolean equals(ActiviteLigne activiteLigne) 
	{
		if( this.codsg.equals( activiteLigne.getCodsg() ) 
			&& this.code_activite.equals( activiteLigne.getCode_activite() )
			&& this.pid.equals( activiteLigne.getPid() ))
		{
			return true;		
		}
		return false;
	}

}