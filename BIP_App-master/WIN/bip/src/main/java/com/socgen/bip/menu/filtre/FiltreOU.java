/*
 * Cr�� le 21 janv. 05
 *
 */
package com.socgen.bip.menu.filtre;

import java.util.Vector;

import com.socgen.bip.menu.MenuException;
import com.socgen.bip.user.UserBip;

/**
 *
 * @author X039435
 */
public class FiltreOU extends FiltreMenu
{
	Vector vFiltres;
	
	public FiltreOU(boolean bNot)
	{
		super(bNot);
		
		vFiltres = new Vector();
	}
	
	public FiltreOU(boolean bNot, Vector vFiltres)
	{
		super(bNot);
	
		this.vFiltres = vFiltres;
	}
	
	public void addFiltre(FiltreMenu filtre)
	{
		vFiltres.add(filtre);
	}
	
	public boolean eval(UserBip userBip) throws MenuException
	{
		boolean bRes = false;
		
		for (int i=0; i<vFiltres.size(); i++)
		{
			FiltreMenu filtre = (FiltreMenu)vFiltres.elementAt(i);
			bRes = bRes || filtre.eval(userBip);
		}
		
		if (bNot)
			return !bRes;
		return bRes;
	}
}
