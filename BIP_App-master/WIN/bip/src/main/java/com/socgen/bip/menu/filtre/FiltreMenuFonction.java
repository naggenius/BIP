/*
 * Créé le 3 déc. 04
 *
 */
package com.socgen.bip.menu.filtre;

// Import des classes générales
import java.util.Calendar;
import java.util.Vector;

import com.socgen.bip.user.UserBip;

/**
 *
 * @author x039435
 */
public class FiltreMenuFonction
{
	static public Boolean filtreVide(UserBip uBip)
	{
		return Boolean.TRUE;
	}
	
	static public Boolean filtreMenu(UserBip uBip)
	{
		/*if (sMenuId == "")
			return Boolean.TRUE;
			
		StringTokenizer sTK = new StringTokenizer(sMenuId.toUpperCase(), ",");
		String sId = uBip.getMenuUtil().getNom().toUpperCase();
		System.out.println(sId + " - " + sMenuId.toUpperCase());
		while (sTK.hasMoreTokens())
		{
			if (sId.equals(sTK.nextToken().trim()))
				return Boolean.TRUE;
		}

			
		return Boolean.FALSE;*/
		return Boolean.TRUE;
	}
	
	static public Boolean filtreMatin(UserBip uBip)
	{
		if ( (Calendar.getInstance()).get(Calendar.AM_PM) == Calendar.AM) return Boolean.TRUE;
		
		return Boolean.FALSE;
		
	}

/**
 * Cette fonction renvoie vrai si le périmètre ME de l'utilisateur comprend la direction SISE.<br>
 * On teste si les 4 premiers caractères du périmètre ME comprend l'une des valeurs suivantes: <br>
 *  - 0000 : habilitation pour toute la BIP <br>
 *  - 0300 : habilitation pour la branche PAEN <br>
 *  - 0314 : habilitation pour la direction SISE <br>
 * Cette fonction est utilisée pour n'afficher une option de menu qu'aux <br>
 * seuls utilisateurs de SISE.<br>
 * @param uBip User Bip
 *
 */

	static public Boolean filtreDirSISE(UserBip uBip)
	{

		String chaineTravail = null;
		Vector perim_ME = uBip.getPerim_ME();
		Boolean valeurRetour = Boolean.FALSE;
  
		if (perim_ME!=null) {
			// On retourne la liste des périmètres avec pour séparateur la virgule
			for(int i =0; i < perim_ME.size(); i++){
				chaineTravail = ((String) perim_ME.elementAt(i)).substring(0,4);
				
				// Si le périmètre comprend les valeurs retenues on renvoie true
				if ((chaineTravail.equals("0000")) || (chaineTravail.equals("0300"))||(chaineTravail.equals("0314")))
				{
					valeurRetour = Boolean.TRUE;
				}
			}
		}
				
		return valeurRetour;
		
	}

}
