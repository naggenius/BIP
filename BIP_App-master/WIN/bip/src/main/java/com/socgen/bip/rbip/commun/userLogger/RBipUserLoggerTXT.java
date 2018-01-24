/*
 * Créé le 10 mai 04
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.rbip.commun.userLogger;

import com.socgen.bip.rbip.commun.erreur.RBipErreur;

/**
 * @author X039435
 *
 * Pour changer le modèle de ce commentaire de type généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
public class RBipUserLoggerTXT extends RBipUserLogger
{
	private int iTailleFileName = 13;
	private int iTailleNumLigne = 4;
	private int iTailleCodeErreur = 4;
	private int iTailleLibelle = 110;
	
	String sFillerFileName = "             ";
	String sFillerNumLigne = "0000";
	String sFillerCode = "    ";
	String sFillerLibelle = "                                                                                                              ";
	
	String sSeparateur = " ";
	
	/**
	 * Génère une log pour le fichier, la log informe que le contrôle du fichier est ok 
	 * @param sFileName
	 * @return une représentation de l'info
	 */
	public String toStringKO(RBipErreur rBipErr)
	{
		//longueur du champ fileName : 13
		//longueur du champ numLigne : 4
		//longueur du champ code	 : 4
		//longueur du champ libelle	 : 110
		String sFileName = rBipErr.getFileName() + sFillerFileName;
		String sNumLigne = sFillerNumLigne + rBipErr.getNumLigne();
		String sCode = rBipErr.getCode() + sFillerCode;
		String sLibelle = rBipErr.getLibelle()+ sFillerLibelle;
		
		sFileName = sFileName.substring(0,iTailleFileName);
		sNumLigne = sNumLigne.substring(sNumLigne.length()-iTailleNumLigne,sNumLigne.length());
		sCode = sCode.substring(0,iTailleCodeErreur);
		sLibelle = sLibelle.substring(0, iTailleLibelle);
		
		return sFileName+ sSeparateur + sNumLigne + sSeparateur + sCode + sSeparateur + sLibelle;
	}
	
	/**
	 * Génère une log pour l'erreur donnée 
	 * @param rBipErr l'erreur qui doit être tracée
	 * @return Une représentation de l'erreur
	 */
	public String toStringOK(String sFileName)
	{
		return sFileName+sSeparateur+sSeparateur+"OK"+sSeparateur+sSeparateur;		
	}
}