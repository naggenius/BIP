/*
 * Cr�� le 10 mai 04
 *
 */
package com.socgen.bip.rbip.commun.userLogger;

import com.socgen.bip.rbip.commun.erreur.RBipErreur;

/**
 * @author X039435 / E.GREVREND
 *
 * La classe permet de g�n�rer une log pour un fichier dont la contr�le est un succ�s ainsi que pour les erreurs
 * @see RBipUserLoggerCSV
 * @see RBipUserLoggerTXT
 */
public abstract class RBipUserLogger
{
	public RBipUserLogger() {}
	/**
	 * G�n�re une log pour le fichier, la log informe que le contr�le du fichier est ok 
	 * @param sFileName
	 * @return une repr�sentation de l'info
	 */
	public abstract String toStringOK(String sFileName);
	/**
	 * G�n�re une log pour l'erreur donn�e 
	 * @param rBipErr l'erreur qui doit �tre trac�e
	 * @return Une repr�sentation de l'erreur
	 */
	public abstract String toStringKO(RBipErreur rBipErr);
}