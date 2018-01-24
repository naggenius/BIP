package com.socgen.bip.metier;

/**
 * @author MMC
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class RessAct {

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
	 * code ress
	 */
	private String code_ress;
	/*
	* libelle ress
	*/
	private String lib_ress;
	/*
	* type de ress
	*/
		private String type_ress;
	/*
	* repartition
	*/
	private String repartition;
		
	/**
	 * 
	 */
	public RessAct() {
		super();
	}

	public RessAct(String codsg, String code_ress,String type_ress, String lib_ress,String code_activite, String lib_activite, String repartition)
	{
		this.codsg = codsg;
		this.code_ress = code_ress;
		this.type_ress = type_ress;
		this.lib_ress = lib_ress;
		this.code_activite = code_activite;
		this.lib_activite = lib_activite;
		this.repartition = repartition;
		
	}
	
	public RessAct(String codsg, String code_ress,String code_activite)
		{
			this.codsg = codsg;
			this.code_ress = code_ress;
			this.code_activite = code_activite;
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
	public String getCode_ress() {
		return code_ress;
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
	public void setCode_ress(String string) {
		code_ress = string;
	}
	
	/**
	 * surcharge de la methode equals
	 * @param activiteLigne
	 */
	public boolean equals(RessAct ressAct) 
	{
		if( this.codsg.equals( ressAct.getCodsg() ) 
			&& this.code_activite.equals( ressAct.getCode_activite() )
			&& this.code_ress.equals( ressAct.getCode_ress() )
			&& this.type_ress.equals( ressAct.getType_ress() )
		    && this.lib_activite.equals( ressAct.getLib_activite() )
		    && this.lib_ress.equals( ressAct.getLib_ress() )
		    && this.repartition.equals( ressAct.getRepartition() )
			)
		{
			return true;		
		}
		return false;
	}

	/**
	 * @return
	 */
	public String getLib_ress() {
		return lib_ress;
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
	public void setLib_ress(String string) {
		lib_ress = string;
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
	public String getType_ress() {
		return type_ress;
	}

	/**
	 * @param string
	 */
	public void setType_ress(String string) {
		type_ress = string;
	}

}