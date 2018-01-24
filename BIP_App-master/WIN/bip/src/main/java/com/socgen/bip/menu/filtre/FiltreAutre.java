/*
 * Créé le 21 janv. 05
 *
 */
package com.socgen.bip.menu.filtre;

import java.lang.reflect.InvocationTargetException;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.menu.MenuException;
import com.socgen.bip.user.UserBip;

/**
 * FiltreMenu permettant d'exécuter une fonction d'une classe (tous deux spécifiés).<br>
 * Cette fonction DOIT avoir la signature suivante : <br>
 * 		public static Boolean maFonction(UserBip uBip) <br>
 * @see com.socgen.bip.menu.filtre.FiltreMenuFonction
 * @author X039435
 */
public class FiltreAutre extends FiltreMenu
{
	private String sClassName;
	private String sFunctionName;
	
	/**
	 * 
	 * @param bNot
	 * @param sClassName nom (complet) de la classe
	 * @param sFunctionName nom de la fonction de la classe à exécuter
	 */
	public FiltreAutre(boolean bNot, String sClassName, String sFunctionName)
	{
		super(bNot);
		
		this.sClassName = sClassName;
		this.sFunctionName = sFunctionName;
	}
	
	/**
	 * Fonction d'évaluation
	 * On utilise la fonction Tools.getInstanceOf pour évaluer l'appel
	 */
	public boolean eval(UserBip userBip) throws MenuException
	{
		boolean bRes = true;
		try
		{
			bRes = ((Boolean)Tools.getInstanceOf(sClassName, sFunctionName, userBip)).booleanValue();
		}
		catch (InvocationTargetException iTE)
		{
			logService.error("pb InvocationTargetException sur eval pour "+ sClassName+"."+sFunctionName, iTE);
			throw new MenuException("InvocationTargetException sur eval pour "+ sClassName+"."+sFunctionName, iTE);
		}
		catch (Exception e)
		{
			logService.error("Exception sur eval pour "+ sClassName+"."+sFunctionName, e);
			throw new MenuException("Exception sur eval pour "+ sClassName+"."+sFunctionName, e);
		}
		
		if (bNot)
			return !bRes;
		
		return bRes;
	}
}
