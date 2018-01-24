/*
 * Créé le 23 avr. 04
 */
package com.socgen.bip.rbip.commun.erreur;

import java.util.NoSuchElementException;
import java.util.StringTokenizer;
import java.util.Vector;

import com.socgen.bip.rbip.commun.RBipConstants;

/**
 * @author X039435 / E.GREVREND
 * RBipErreur est la classe qui permet de représenter une erreur survenue lors des contrôles de remontée effectués 
 */
public class RBipErreur implements RBipConstants, RBipErreurConstants
{	
	/**
	 * sCode représente le code erreur de la présente erreur
	 */
	private String sCode;
	
	/**
	 * sLibelle contient le libellé décrivant le code erreur
	 */
	private String sLibelle;
	
	/**
	 * iNumLigne donne le numéro de la ligne dans le fichier où l'erreur a été détectée
	 */
	private int iNumLigne;
	
	/**
	 * sFileName donne le nom du fichier dans lequel à été detectée l'erreur
	 */
	private String sFileName;
	
	private String sTag;

	
	protected void buildErreur(String sTagProperty, String sFileName, int iNumLigne, String sCode, Vector vParams)
	{
		this.sFileName = sFileName;
		this.iNumLigne = iNumLigne;
		this.sCode = sCode;
		this.sLibelle = cfgErr.getString(sTagProperty+sCode);
		this.sTag = sTagProperty;

		/*
		 * On recherche dans le libelle les zones variables
		 * Elle sont identifiées par {n}, n correspondant au n-ième élément de vParams 
		 */
		if (vParams != null)
		{		
			for (int i=0; i< vParams.size(); i++)
			{
				String sTag = "{"+i+"}";
				int p = sLibelle.indexOf(sTag);
		
				if (p>=0)
				{
					sLibelle = sLibelle.substring(0, p) + vParams.get(i).toString() + sLibelle.substring(p+sTag.length());
				}	
			}
		}
	}
	
	/**
	 * Constructeur de la classe <br>
	 * 
	 * @param sFileName Le nom du fichier où a été détectée l'erreur
	 * @param iNumLigne Le numéro de la ligne où a été détectée l'erreur
	 * @param sCode Le code de l'erreur, on va chercher dans le fichier de ressource des erreur le libellé associé
	 * @param vParams Le libellé associé au code erreur peut contenir des zones variables. vParams contient la liste de ces zones 
	 */
	public RBipErreur(String sFileName, int iNumLigne, String sCode, Vector vParams)
	{
		buildErreur(TAG_ERREUR, sFileName, iNumLigne, sCode, vParams);
	}
	
	/**
	 * Constructeur de la classe <br>
	 * 
	 * @param sTagProperty Tag préfixant les codes erreur dans le fichier de ressource
	 * @param sFileName Le nom du fichier où a été détectée l'erreur
	 * @param iNumLigne Le numéro de la ligne où a été détectée l'erreur
	 * @param sCode Le code de l'erreur, on va chercher dans le fichier de ressource des erreur le libellé associé
	 * @param vParams Le libellé associé au code erreur peut contenir des zones variables. vParams contient la liste de ces zones 
	 */
	public RBipErreur(String sTagProperty, String sFileName, int iNumLigne, String sCode, Vector vParams)
	{
		buildErreur(sTagProperty, sFileName, iNumLigne, sCode, vParams);
	}
	
	public RBipErreur(String sCSV)
	{
		StringTokenizer sTK = new StringTokenizer(sCSV, ";");

		try
		{		
			sFileName = sTK.nextToken();
			iNumLigne = new Integer(sTK.nextToken()).intValue();
			sCode = sTK.nextToken();
			sLibelle = sTK.nextToken();
		}
		catch (NumberFormatException nFE)
		{
			throw nFE;
		}
		catch (NoSuchElementException nSEE)
		{
			throw nSEE;
		}

	}
	
	/**
	 * @return String repésentation sous forme de chaîne de caractères de l'erreur.
	 */
	public String toString()
	{
		String sFiller = " - ";
		return	sFileName + sFiller + 
				iNumLigne + sFiller + 
				sCode + sFiller + 
				sLibelle;
	}
	/**
	 * @return
	 */
	public int getNumLigne() {
		return iNumLigne;
	}

	/**
	 * @return
	 */
	public String getCode() {
		return sCode;
	}

	/**
	 * @return
	 */
	public String getFileName() {
		return sFileName;
	}

	/**
	 * @return
	 */
	public String getLibelle() {
		return sLibelle;
	}
	
	public String getCSVToSave()
	{
		String sFiller = ";";
		return 	sFileName + sFiller + 
				iNumLigne + sFiller + 
				sCode + sFiller + 
				sLibelle;
	}

	public String getsTag() {
		return sTag;
	}

	public void setsTag(String sTag) {
		this.sTag = sTag;
	}
}