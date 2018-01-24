/*
 * Cr�� le 10 mai 04
 *
 */
package com.socgen.bip.rbip.commun.userLogger;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;

/**
 * @author X039435 / E.GREVREND
 *
 * Log pour g�n�rer un fichier CSV
 */
public class RBipUserLoggerCSV extends RBipUserLogger
{
	String sSeparateur = ";";
	
	/**
	 * G�n�re une log pour le fichier, la log informe que le contr�le du fichier est ok 
	 * @param sFileName
	 * @return une repr�sentation de l'info
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
	 * G�n�re une log pour l'erreur donn�e 
	 * @param rBipErr l'erreur qui doit �tre trac�e
	 * @return Une repr�sentation de l'erreur
	 */
	public String toStringOK(String sFileName)
	{
		return		Tools.getTimeStamp() + sSeparateur
				+	sFileName + sSeparateur
				+	sSeparateur
				+	"OK"+sSeparateur;		
	}
}