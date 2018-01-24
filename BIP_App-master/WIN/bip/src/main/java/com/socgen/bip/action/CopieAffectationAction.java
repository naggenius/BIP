package com.socgen.bip.action;


import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;


/**
 * @author BAA - 13/09/2005
 *
 * Formulaire de copie des affectations d'une ressource à l'autre
 * chemin : Saisie des réalisés/Copier affectation ressource
 * pages  : fCopieAffectationSr.jsp
 * pl/sql : isac_copie.sql
 */
public class CopieAffectationAction extends AutomateAction implements BipConstantes{


	private static String PACK_INSERT = "copieAffectation.creer.proc";


	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")){
			cle=PACK_INSERT;
		}

		return cle;
	}

}
