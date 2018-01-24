/*
 * Créé le 21 janv. 05
 *
 */
package com.socgen.bip.menu.filtre;

import java.lang.reflect.Method;
import java.util.StringTokenizer;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.menu.MenuException;
import com.socgen.bip.user.UserBip;

/**
 * FiltreMenu permettant de tester si un champ donné de UserBip est présent dans la liste de valeurs porposées
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
	 * @param bNot negation du résultat ?
	 * @param sChamp nom du champ de UserBip à tester, il doit exister un getter public associé => "get"+sChamp+"()" doit exister et étre accessible 
	 * @param sValeursOk liste des valeurs (séparées par une virgule) autorisées
	 * @throws NoSuchMethodException levée si le getter correspondant à sChamp n'existe pas
	 * @throws ClassNotFoundException levée si la classe correspondant à UserBip n'est pas trouvée : NE DOIT JAMAIS SE PRODUIRE !!!
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
	 * Fonction d'évaluation
	 * On appelle le getter correspondant au champ demandé, si la valeur retournée est dans la liste des valeurs autorisées on retourne true, false sinon
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
