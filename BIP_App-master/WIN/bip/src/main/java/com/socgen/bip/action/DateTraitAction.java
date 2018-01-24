package com.socgen.bip.action;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;

/**
 * @author N.BACCAM - 22/07/2003
 *
 * Action de mise à jour des dates de traitement
 * chemin : Administration/Exploitation/ Date de traitement
 * pages  : fDatetraitjsp
 * pl/sql : datetr.sql
 */
public class DateTraitAction extends AutomateAction implements BipConstantes{

	private static String PACK_UPDATE = "dateTrait.modifier.proc";

	private String nomProc;
	
   

	protected String recupererCle(String mode) {
		String cle = null;
	
			cle=PACK_UPDATE;
	
		return cle;
	}

}
