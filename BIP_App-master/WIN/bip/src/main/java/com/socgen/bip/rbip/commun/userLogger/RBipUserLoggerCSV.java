/*
 * Créé le 10 mai 04
 *
 */
package com.socgen.bip.rbip.commun.userLogger;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;

/**
 * @author X039435 / E.GREVREND
 *
 * Log pour générer un fichier CSV
 */
public class RBipUserLoggerCSV extends RBipUserLogger
{
	String sSeparateur = ";";
	
	/**
	 * Génère une log pour le fichier, la log informe que le contrôle du fichier est ok 
	 * @param sFileName
	 * @return une représentation de l'info
	 */
	public String toStringKO(RBipErreur rBipErr)
	{
		return 	Tools.getTimeStamp() + sSeparateur
				+ rBipErr.getFileName() + sSeparateur
				+ rBipErr.getNumLigne() + sSeparateur
				+ rBipErr.getCode() + sSeparateur
				+ rBipErr.getLibelle();		
	}
	
	/**
	 * Génère une log pour l'erreur donnée 
	 * @param rBipErr l'erreur qui doit être tracée
	 * @return Une représentation de l'erreur
	 */
	public String toStringOK(String sFileName)
	{
		return		Tools.getTimeStamp() + sSeparateur
				+	sFileName + sSeparateur
				+	sSeparateur
				+	"OK"+sSeparateur;		
	}
}