/*
 * Créé le 03/03/2014
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.rbip.commun.loader;

import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

/**
 * @author X116132 / K. RAOUZI
 * KRA 16/04/2015 - PPM 60612 : Création d'une classe StructureConstantsBIPS à implémenter par la classe Tools
 * Ensembles des constantes permettant de définir les types des enregistrements.
 * Contient les tags permettant d'extraires les informations du fichier des ressources associé à la définition de la structure
 */
public interface RBipStructureConstantsBIPS extends RBipStructureConstants
{
	/**
	 * A partir du fichier des ressources principal on récupère le nom du fichier de ressources qui contient les infos sur les types de données, structure du fichier de remontée.<br> 
	 * cfgStruct est le RessourceBundle associé à ce fichier  
	 */
	public static ResourceBundle cfgStructBIPS = PropertyResourceBundle.getBundle(cfgRbip.getString("structureBIPS"));
	
	
}
