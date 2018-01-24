/*
 * Créé le 21 janv. 05
 *
 */
package com.socgen.bip.menu.filtre;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.menu.MenuException;
import com.socgen.bip.user.UserBip;

/**
 *
 * @author X039435
 */
public abstract class FiltreMenu implements BipConstantes
{
	protected boolean bNot;
	
	public FiltreMenu(boolean bNot)
	{
		this.bNot = bNot;
	}
	
	public FiltreMenu()
	{
		this.bNot = false;
	}
	
	public abstract boolean eval(UserBip userBip) throws MenuException;
}
