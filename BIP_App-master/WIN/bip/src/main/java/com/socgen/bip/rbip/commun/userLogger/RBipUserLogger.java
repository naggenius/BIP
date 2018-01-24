/*
 * Créé le 10 mai 04
 *
 */
package com.socgen.bip.rbip.commun.userLogger;

import com.socgen.bip.rbip.commun.erreur.RBipErreur;

/**
 * @author X039435 / E.GREVREND
 *
 * La classe permet de générer une log pour un fichier dont la contrôle est un succès ainsi que pour les erreurs
 * @see RBipUserLoggerCSV
 * @see RBipUserLoggerTXT
 */
public abstract class RBipUserLogger
{
	public RBipUserLogger() {}
	/**
	 * Génère une log pour le fichier, la log informe que le contrôle du fichier est ok 
	 * @param sFileName
	 * @return une représentation de l'info
	 */
	public abstract String toStringOK(String sFileName);
	/**
	 * Génère une log pour l'erreur donnée 
	 * @param rBipErr l'erreur qui doit être tracée
	 * @return Une représentation de l'erreur
	 */
	public abstract String toStringKO(RBipErreur rBipErr);
}