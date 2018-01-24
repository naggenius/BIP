/*
 * Cr�� le 03/03/2014
 *
 * Pour changer le mod�le de ce fichier g�n�r�, allez � :
 * Fen�tre&gt;Pr�f�rences&gt;Java&gt;G�n�ration de code&gt;Code et commentaires
 */
package com.socgen.bip.rbip.commun.loader;

import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

/**
 * @author X116132 / K. RAOUZI
 * KRA 16/04/2015 - PPM 60612 : Cr�ation d'une classe StructureConstantsBIPS � impl�menter par la classe Tools
 * Ensembles des constantes permettant de d�finir les types des enregistrements.
 * Contient les tags permettant d'extraires les informations du fichier des ressources associ� � la d�finition de la structure
 */
public interface RBipStructureConstantsBIPS extends RBipStructureConstants
{
	/**
	 * A partir du fichier des ressources principal on r�cup�re le nom du fichier de ressources qui contient les infos sur les types de donn�es, structure du fichier de remont�e.<br> 
	 * cfgStruct est le RessourceBundle associ� � ce fichier  
	 */
	public static ResourceBundle cfgStructBIPS = PropertyResourceBundle.getBundle(cfgRbip.getString("structureBIPS"));
	
	
}
