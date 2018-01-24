package com.socgen.bip.action;


import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;


/**
 * @author N.BACCAM - 29/09/2003
 *
 * Formulaire de copie de la structure d'une ligne BIP
 * chemin : Saisie des réalisés/Copie de structure
 * pages  : fCopieStructSr.jsp
 * pl/sql : isac_copie.sql
 */
public class CopieStructureAction extends AutomateAction implements BipConstantes{


	private static String PACK_INSERT = "copieStructure.creer.proc";


	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")){
			cle=PACK_INSERT;
		}

		return cle;
	}

}
