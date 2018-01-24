/*
 * Créé le 3 déc. 04
 *
 */
package com.socgen.bip.menu.item;

import com.socgen.bip.menu.filtre.FiltreMenu;

/**
 *
 * @author x039435
 */
public class BipItem
{
	private String sId;
	private String sLibelle;
	private String sAltLib;
	private String sPageAide;
	/*private String sFilterClass;
	private String sFilterFunction;*/
	private String sLien;
	private String sOptionsLien;
	private FiltreMenu filtre;
	private String sNivSousMenu;

	public BipItem(BipItem bMItem)
	{
		sId = bMItem.getId();
		sLibelle = bMItem.getLibelle();
		sAltLib = bMItem.getAltLib();
		sPageAide = bMItem.getPageAide();
		filtre = null;
		sLien = bMItem.getLien();
		sOptionsLien = bMItem.getOptionsLien();
		sNivSousMenu = bMItem.getNivSousMenu();
	}

	public BipItem(	String sId,
					String sLibelle,
					String sAltLib,
					String sPageAide,
					FiltreMenu filtre,
					String sLien,
					String sOptionsLien,
					String sNivSousMenu)
	{
		this.sId = sId;
		this.sLibelle = sLibelle;
		this.sAltLib = sAltLib;
		this.sPageAide = sPageAide;
		this.filtre = filtre;
		this.sLien = sLien;
		this.sOptionsLien = sOptionsLien;
		this.sNivSousMenu = sNivSousMenu;
	}

	
	public String getNivSousMenu() {
		return sNivSousMenu;
	}

	public void setNivSousMenu(String nivSousMenu) {
		this.sNivSousMenu = nivSousMenu;
	}

	/**
	 * @return
	 */
	public String getLibelle()
	{
		return sLibelle;
	}
	
	/**
	 * @return
	 */
	public String getAltLib()
	{
		return sAltLib;
	}

	/**
	 * @return
	 */
	public String getPageAide()
	{
		return sPageAide;
	}

	/**
	 * @param string
	 */
	public void setLibelle(String string)
	{
		sLibelle = string;
	}

	/**
	 * @param string
	 */
	public void setPageAide(String string)
	{
		sPageAide = string;
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
	 * @param string
	 */
	public void setAltLib(String string)
	{
		sAltLib = string;
	}

	/**
	 * @return
	 */
	public String getLien()
	{
		return sLien;
	}

	/**
	 * @return
	 */
	public String getOptionsLien()
	{
		return sOptionsLien;
	}

	/**
	 * @param string
	 */
	public void setLien(String string)
	{
		sLien = string;
	}

	/**
	 * @param string
	 */
	public void setOptionsLien(String string)
	{
		sOptionsLien = string;
	}

	/**
	 * @return
	 */
	public FiltreMenu getFiltre()
	{
		return filtre;
	}

	/**
	 * @param menu
	 */
	public void setFiltre(FiltreMenu menu)
	{
		filtre = menu;
	}
}