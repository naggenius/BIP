/*
 * Cr�� le 23 avr. 04
 */
package com.socgen.bip.rbip.commun.erreur;

import java.util.NoSuchElementException;
import java.util.StringTokenizer;
import java.util.Vector;

import com.socgen.bip.rbip.commun.RBipConstants;

/**
 * @author X039435 / E.GREVREND
 * RBipErreur est la classe qui permet de repr�senter une erreur survenue lors des contr�les de remont�e effectu�s 
 */
public class RBipErreur implements RBipConstants, RBipErreurConstants
{	
	/**
	 * sCode repr�sente le code erreur de la pr�sente erreur
	 */
	private String sCode;
	
	/**
	 * sLibelle contient le libell� d�crivant le code erreur
	 */
	private String sLibelle;
	
	/**
	 * iNumLigne donne le num�ro de la ligne dans le fichier o� l'erreur a �t� d�tect�e
	 */
	private int iNumLigne;
	
	/**
	 * sFileName donne le nom du fichier dans lequel � �t� detect�e l'erreur
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
		 * Elle sont identifi�es par {n}, n correspondant au n-i�me �l�ment de vParams 
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
	 * @param sFileName Le nom du fichier o� a �t� d�tect�e l'erreur
	 * @param iNumLigne Le num�ro de la ligne o� a �t� d�tect�e l'erreur
	 * @param sCode Le code de l'erreur, on va chercher dans le fichier de ressource des erreur le libell� associ�
	 * @param vParams Le libell� associ� au code erreur peut contenir des zones variables. vParams contient la liste de ces zones 
	 */
	public RBipErreur(String sFileName, int iNumLigne, String sCode, Vector vParams)
	{
		buildErreur(TAG_ERREUR, sFileName, iNumLigne, sCode, vParams);
	}
	
	/**
	 * Constructeur de la classe <br>
	 * 
	 * @param sTagProperty Tag pr�fixant les codes erreur dans le fichier de ressource
	 * @param sFileName Le nom du fichier o� a �t� d�tect�e l'erreur
	 * @param iNumLigne Le num�ro de la ligne o� a �t� d�tect�e l'erreur
	 * @param sCode Le code de l'erreur, on va chercher dans le fichier de ressource des erreur le libell� associ�
	 * @param vParams Le libell� associ� au code erreur peut contenir des zones variables. vParams contient la liste de ces zones 
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
	 * @return String rep�sentation sous forme de cha�ne de caract�res de l'erreur.
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