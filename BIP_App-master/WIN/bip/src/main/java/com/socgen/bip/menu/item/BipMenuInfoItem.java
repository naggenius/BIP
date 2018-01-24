/*
 * Créé le 10 déc. 04
 *
 */
package com.socgen.bip.menu.item;

/**
 *
 * @author x039435
 */
public class BipMenuInfoItem
{
	private String sId;

	private String sClassName;
	private String sFunctionName;
	
	

	public BipMenuInfoItem(String sId, String sClassName, String sFunctionName)
	{
		this.sId = sId;
		this.sClassName = sClassName;
		this.sFunctionName = sFunctionName;
	}


	/**
	 * @return
	 */
	public String getId()
	{
		return sId;
	}

	/**
	 * @param string
	 */
	public void setId(String string)
	{
		sId = string;
	}

	/**
	 * @return
	 */
	public String getClassName()
	{
		return sClassName;
	}

	/**
	 * @return
	 */
	public String getFunctionName()
	{
		return sFunctionName;
	}

	/**
	 * @param string
	 */
	public void setClassName(String string)
	{
		sClassName = string;
	}

	/**
	 * @param string
	 */
	public void setFunctionName(String string)
	{
		sFunctionName = string;
	}

}
