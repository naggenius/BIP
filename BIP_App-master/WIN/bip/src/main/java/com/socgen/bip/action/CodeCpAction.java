package com.socgen.bip.action;

import com.socgen.bip.commun.action.AutomateAction;

/**
 * @author s LALLIER
 * Action de mise à jour des codes chef de projets.
 * chemin : Administration/Tables/ mise à jour/MAJ code CP
 * pages  : mCodeCpAd.jsp
 * pl/sql : codecp.sql
 */
public class CodeCpAction extends AutomateAction {

	private static String PACK_UPDATE = "codecp.modifier.proc";

	protected String recupererCle(String mode) {
		String cle = null;

		if (mode.equals("update")) {
			cle = PACK_UPDATE;
		}

		return cle;
	}

}
