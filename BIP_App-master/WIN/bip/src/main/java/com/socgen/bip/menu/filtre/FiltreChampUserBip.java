/*
 * Cr�� le 21 janv. 05
 *
 */
package com.socgen.bip.menu.filtre;

import java.lang.reflect.Method;
import java.util.StringTokenizer;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.menu.MenuException;
import com.socgen.bip.user.UserBip;

/**
 * FiltreMenu permettant de tester si un champ donn� de UserBip est pr�sent dans la liste de valeurs porpos�es
 * 
 * @author X039435
 */
public class FiltreChampUserBip extends FiltreMenu implements BipConstantes
{
	private Method getter;
	private String sValeursOk;
	private String sUserBipClassName = "com.socgen.bip.user.UserBip";
	
	/**
	 * Constructeur
	 * 
	 * @param bNot negation du r�sultat ?
	 * @param sChamp nom du champ de UserBip � tester, il doit exister un getter public associ� => "get"+sChamp+"()" doit exister et �tre accessible 
	 * @param sValeursOk liste des valeurs (s�par�es par une virgule) autoris�es
	 * @throws NoSuchMethodException lev�e si le getter correspondant � sChamp n'existe pas
	 * @throws ClassNotFoundException lev�e si la classe correspondant � UserBip n'est pas trouv�e : NE DOIT JAMAIS SE PRODUIRE !!!
	 */
	public FiltreChampUserBip(boolean bNot, String sChamp, String sValeursOk) throws NoSuchMethodException, ClassNotFoundException
	{
		super(bNot);
		this.sValeursOk = sValeursOk;
		
		try
		{
			Class classUserBip = Class.forName(sUserBipClassName);
			getter = classUserBip.getMethod("get"+sChamp, null);
		}
		catch (NoSuchMethodException nSFE)
		{
			logService.error(sUserBipClassName+".get"+sChamp + "() n'existe pas",nSFE);
			throw nSFE;
		}
		catch (ClassNotFoundException cNFE)
		{
			logService.error(sUserBipClassName+" n'existe pas",cNFE);
			throw cNFE;
		}
	}
	
	/**
	 * Fonction d'�valuation
	 * On appelle le getter correspondant au champ demand�, si la valeur retourn�e est dans la liste des valeurs autoris�es on retourne true, false sinon
	 */
	public boolean eval(UserBip userBip) throws MenuException
	{
		boolean bRes;
		String sValeurChamp = null;
		
		try
		{
			sValeurChamp = (String)getter.invoke(userBip, null);
		}
		catch (Exception e)
		{
			logService.error("pb sur invoke de "+getter.toString(), e);
			throw new MenuException("Invoke de " + getter.toString());
		}
		
		bRes = false;
		StringTokenizer sTk = new StringTokenizer(sValeursOk);
		while (sTk.hasMoreElements())
		{
			String sCurrent = sTk.nextToken();
			if ( (sValeurChamp.toLowerCase()).indexOf(sCurrent.toLowerCase()) != -1)
			{
				bRes = true;
				break;
			}
		}
		
		if (bNot)
			return !bRes;
		
		return bRes;
	}
}
