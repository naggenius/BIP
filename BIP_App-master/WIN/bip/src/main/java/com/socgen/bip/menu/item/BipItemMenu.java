/*
 * Créé le 10 déc. 04
 *
 */
package com.socgen.bip.menu.item;

import java.util.Vector;

/**
 *
 * @author x039435
 */
public class BipItemMenu extends BipItem
{
	private Vector vInfos;
	private String sCouleurFond;
	
	public BipItemMenu(BipItem bItem)
	{
		super(bItem);
		sCouleurFond = null;
		vInfos = new Vector();
	}
	
	public BipItemMenu(BipItem bItem, String sCouleurFond)
	{
		super(bItem);
		this.sCouleurFond = sCouleurFond;
		vInfos = new Vector();
	}
	
	public BipItemMenu(BipItem bItem, Vector vInfos)
	{
		super(bItem);
		this.vInfos = vInfos;
		sCouleurFond = null;
	}
	
	public BipItemMenu(BipItem bItem, Vector vInfos, String sCouleurFond)
	{
		super(bItem);
		this.vInfos = vInfos;
		this.sCouleurFond = sCouleurFond;
	}
	
	public BipItemMenu(	String sId,
					String sLibelle,
					String sAltLib,
					String sPageAide,
					String sLien,
					String sOptionsLien,
					String sCouleurFond,
					String sNivSousMenu)
	{
		super(sId, sLibelle, sAltLib, sPageAide, null, sLien, sOptionsLien,sNivSousMenu);
		this.sCouleurFond = sCouleurFond;
		
		vInfos = new Vector(); 		
	}
	
	public void addInfo(BipMenuInfoItem bMI)
	{
		vInfos.add(bMI);
	}
	
	public Vector getInfos()
	{
		return vInfos;
	}
	/**
	 * @return
	 */
	public String getCouleurFond()
	{
		return sCouleurFond;
	}

	/**
	 * @param string
	 */
	public void setCouleurFond(String string)
	{
		sCouleurFond = string;
	}

}
