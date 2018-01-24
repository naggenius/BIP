/*
 * Créé le 26 mai 04
 *
 */
package com.socgen.bip.rbip.commun.erreur;

import java.util.Vector;

/**
 * @author X039435 / E.GREVREND
 * Contrairement aux RBipErreurs, les RBipWarning ne sont pas bloquant : les fichiers seront tout de même acceptés
 */
public class RBipWarning extends RBipErreur
{
	/**
	 * @param sFileName
	 * @param iNumLigne
	 * @param sCode
	 * @param vParams
	 */
	public RBipWarning(	String sFileName, int iNumLigne, String sCode, Vector vParams)
	{
		super(TAG_WARNING, sFileName, iNumLigne, sCode, vParams);
	}

}
