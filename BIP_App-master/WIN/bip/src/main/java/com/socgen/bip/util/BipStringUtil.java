package com.socgen.bip.util;

import java.text.StringCharacterIterator;
import java.util.ArrayList;
import java.util.Vector;

import org.apache.commons.lang.StringUtils;

public class BipStringUtil {

	public static boolean isAlphaNumeric(String str) {

		return StringUtils.isAlphanumericSpace(str);
	}

	/**
	 * Remplace dans un objet String la primi�re occurence d'une chaine de
	 * caract�res par une autre chaine de caract�re
	 * 
	 * @param source
	 *            Le String o� on veut remplacer la sous-chaine
	 * @param pattern
	 *            La sous-chaine � remplacer
	 * @param replace
	 *            La chaine qui remplacera l'occurence de <i>pattern</i>
	 * @return La nouvelle chaine de caract�re modifi�e. La m�me chaine si rien
	 *         n'a �t� remplac� sinon un String vide
	 */
	public static String replaceFirst(String source, String pattern,
			String replace) {
		return StringUtils.replaceOnce(source, pattern, replace);
	}

	/**
	 * Remplace dans un objet String toutes les occurences d'une chaine de
	 * caract�res par une autre chaine de caract�re
	 * 
	 * @param source
	 *            Le String o� on veut remplacer la sous-chaine
	 * @param pattern
	 *            La sous-chaine � remplacer
	 * @param replace
	 *            La chaine qui remplacera l'occurence de <i>pattern</i>
	 * @return La nouvelle chaine de caract�re modifi�e. La m�me chaine si rien
	 *         n'a �t� remplac� sinon un String vide
	 */
	public static String replaceAll(String source, String pattern,
			String replace) {
		return StringUtils.replace(source, pattern, replace);
	}

	/**
	 * Charge le fichier de donn�es dans un vecteur.
	 * 
	 * @param fichier
	 *            Le fichier � charger
	 * @return un vecteur contenant toutes les lignes de donn�es du fichiers
	 */

	public static String addRightSpaceToString(String str, int longueur) {
		return StringUtils.rightPad(str, longueur - str.length() + 1);
	}

	public static String addLeftSpaceToString(String str, int longueur) {
		return StringUtils.leftPad(str, longueur);
	}

	public static ArrayList getStringTokenized(String str, char seprateur) {
		ArrayList lstExpression = new ArrayList();
		StringCharacterIterator iterator = new StringCharacterIterator(str);
		char caractere = iterator.first();
		StringBuffer buffer = new StringBuffer("");

		for (int i = iterator.getBeginIndex(); i < iterator.getEndIndex(); i++) {
			if (caractere == seprateur) {
				lstExpression.add(buffer.toString());
				buffer = new StringBuffer("");
			} else {
				buffer.append(caractere);
			}
			caractere = iterator.next();
		}
		lstExpression.add(buffer.toString());
		return lstExpression;
	}

	/**
	 * Remplacement des ";" par des "," dans une chaine.
	 * @param chaine
	 * @return
	 */
	public static String replacePtVirgParVirg(String chaine) {
		if (chaine == null) {
			return chaine;
		}
		else {
			return chaine.replace(';',',');
		}
	}
	
	/**
	 * Remplacement des ";" par des "," dans une chaine et
	 * ajout des nouveaux �l�ments � la chaine existante, s'il ne sont pas d�j� pr�sents 
	 * @param ajouts : �l�ments � ajouter
	 * @param existant : chaine existante
	 * @return
	 */
	public static String ajoutSansRedondance(String ajouts, String existant){
		if (ajouts == null) {
			return null;
		}
		
		String[] listeAjouts = replacePtVirgParVirg(ajouts).split(",");
		String retour = existant;
		
		if (listeAjouts != null) {
			for (String ajout:listeAjouts) {
				// Si l'�l�ment � ajouter n'est pas vide et s'il n'est pas d�j� pr�sent
				if(StringUtils.isNotEmpty(ajout) 
						&& (existant == null || !existant.contains(ajout)) ) {
					if(StringUtils.isNotBlank(retour)) {
						retour += ","+ajout;
					}
					else {
						retour = ajout;
					}
				}
			}
		}
		
		return retour;
	}
	
	/**
	 * Remplacement des ";" par des "," dans une chaine et
	 * ajout des nouveaux �l�ments � chaque �l�ment de la liste des chaines existantes, s'il ne sont pas d�j� pr�sents 
	 * @param ajouts : �l�ments � ajouter
	 * @param existant : liste de chaines existantes
	 * @return
	 */
	public static Vector ajoutSansRedondanceVector(String ajouts, Vector existant){
		if (ajouts == null) {
			return null;
		}
		
		String[] listeAjouts = replacePtVirgParVirg(ajouts).split(",");
		Vector retour = existant;
		
		if (listeAjouts != null) {
			for (String ajout:listeAjouts) {
				// Si l'�l�ment � ajouter n'est pas vide et s'il n'est pas d�j� pr�sent
				if(StringUtils.isNotEmpty(ajout) 
						&& (existant == null || !existant.contains(ajout)) ) {
					if(retour != null) {
						retour.add(ajout);
					}
					else {
						retour = new Vector<String>();
						retour.add(ajout);
					}
				}
			}
		}
		
		return retour;
	}
}
