/*
 * Créé le 26 avr. 04
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.rbip.commun;

import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

/**
 * @author X039435
 *
 * Pour changer le modèle de ce commentaire de type généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 * Constante pour la remontee java
 * On y définit (entre autre) les tag du fichier de ressources de la remontee
 */
public interface RBipConstants
{
	public static String DIR_REMONTEE = "BIP_DATA_REMONTEE";
	public static String RBIP_RESSOURCE_FILE = "bip_remontee";
	public static String RBIP_LOGGER = "rbip";
	public static ResourceBundle cfgRbip = PropertyResourceBundle.getBundle(RBIP_RESSOURCE_FILE);
	
	public static String TAG_USER		=	"user.";
	public static String TAG_USER_LISTE	=	TAG_USER+"liste";
	
	public static String TAG_SUFFIX		=	".suffix";
	public static String TAG_DIR_IN		=	".dirIn";
	public static String TAG_DIR_OK		=	".dirOK";
	public static String TAG_LOGGER		=	".logger";
	
	//SEL 6.11.2
	public static String TAG_PARAM_AXEMETIER_ACTION = "AXEMETIER_";
	public static String TAG_PARAM_AXEMETIER_VERSION = "TAC";
	
	public static String TAG_PARAM_DIR_REGLAGES_ACTION = "DIR-REGLAGES";
	
	public static Integer TAG_PARAM_OBLIGATOIRE = 5;
	public static Integer TAG_PARAM_VALEUR = 17;
	
	public static String CATALOGUE = "C";
	
	public static String AXE_METIER_ABSENT = "AXE_MET_ABSN";
	
	public static String TAG_PARAM_TYPETAPESJEUX_ACTION = "TYPETAPES-JEUX";
	
	/*
	// c'est constantes sont définies pour envoyer le fichier de log par email
	public static String TAG_EMAIL			=	".email";
	public static String TAG_EMAIL_BOUCHON 	=	"email.bouchon";	
	public static String TAG_EMAIL_OK		=	"email.ok.";
	public static String TAG_EMAIL_KO		=	"email.ko.";
	public static String TAG_EMAIL_EXP		=	"email.exp";
	public static String TAG_SUJET			=	"subject";
	public static String TAG_CORPS			=	"corps";
	public static String TAG_SIGNATURE		=	"email.signature";
	*/
	 
}
