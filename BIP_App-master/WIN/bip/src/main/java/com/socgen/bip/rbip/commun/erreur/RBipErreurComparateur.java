/*
 * Cr�� le 6 mai 04
 */
package com.socgen.bip.rbip.commun.erreur;

import java.util.Comparator;

/**
 * @author X039435 / E.GREVREND
 *
 * Permet le tri d'un java.util.Collection.<br>
 * L'ordre de tri est le suivant : <br>
 * <ol>
 * 	<li>le nom du fichier o� a �t� trouv� l'erreur</lu>
 *  <li>le num�ro de ligne dans le fichier</lu>
 * 	<li>le code de l'erreur</lu>
 * </ol>
 */
public class RBipErreurComparateur implements Comparator
{
	/**
	 * @param RBipErreur � comparer avec le 2eme param�tre
	 * @param RBipErreur � comparer avec le 1er param�tre
	 */
	public int compare(Object o1, Object o2)
		{
			RBipErreur rBipE1 = (RBipErreur)o1;
			RBipErreur rBipE2 = (RBipErreur)o2;
	
			int i;
	
			i = rBipE1.getFileName().compareTo(rBipE2.getFileName());
			if ( i > 0 )	return 1; 
			if ( i < 0 )	return -1;
	
			if (rBipE1.getNumLigne() > rBipE2.getNumLigne())	return 1;
			if (rBipE1.getNumLigne() < rBipE2.getNumLigne())	return -1;
	
			if ( rBipE1.getCode().compareTo(rBipE2.getCode()) < 0 )	return -1;
	
			return 1;
		}
}