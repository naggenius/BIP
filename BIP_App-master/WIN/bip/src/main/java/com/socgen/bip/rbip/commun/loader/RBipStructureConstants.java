/*
 * Créé le 10 mai 04
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.rbip.commun.loader;

import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;
import com.socgen.bip.rbip.commun.RBipConstants;

/**
 * @author X039435 / E.GREVREND
 *
 * Ensembles des constantes permettant de définir les types des enregistrements.
 * Contient les tags permettant d'extraires les informations du fichier des ressources associé à la définition de la structure
 */
public interface RBipStructureConstants extends RBipConstants
{
	/**
	 * A partir du fichier des ressources principal on récupère le nom du fichier de ressources qui contient les infos sur les types de données, structure du fichier de remontée.<br> 
	 * cfgStruct est le RessourceBundle associé à ce fichier  
	 */
	public static ResourceBundle cfgStruct = PropertyResourceBundle.getBundle(cfgRbip.getString("structure"));
	
	//PPM 60612
	public static ResourceBundle cfgStructBips = PropertyResourceBundle.getBundle(cfgRbip.getString("structure_bips"));
	
	/**
	 * Tag permettant de recupérer les infos dans le fichier des ressources.
	 */
	public static final String TAG_DATA = "data.";
	public static final String TAG_VERSION = TAG_DATA+"version";
	public static final String TAG_RECTYPES = TAG_DATA+"rectypes";
	public static final String TAG_TYPE = TAG_DATA+"type.";
	public static final String TAG_TYPE_FIELDS = ".fields";
	public static final String TAG_TYPE_COF = ".cof";
	public static final String TAG_TYPE_SIZE = ".size";
	public static final String TAG_TYPE_NBRE = ".nbre";// KRA 16/04/2015 - PPM 60612

	public static final String TAG_TYPE_CLASS = ".class";
	public static final String TAG_TYPE_METHOD = ".method";

	public static final String TAG_FIELD_POS = ".pos";
	public static final String TAG_FIELD_SIZE = ".size";
	public static final String TAG_FIELD_TYPE = ".type";
	public static final String TAG_FIELD_NOTNULL = ".notNull";
	public static final String TAG_FIELD_COF = ".cof";
	
	//********************************//	
	/**
	 * Définition des valeurs autorisées pour les différents types de données 
	 */
	public static final int CHARGE_JH_MAX=9999999; //soit "09999999" en sVal et 99999,99 en valeur reelle
	// les champs
	public static final String RECTYPE="RECTYPE";
	public static final char RECTYPE_ENTETE		='A';
	public static final char RECTYPE_ACTIVITE	='G';
	public static final char RECTYPE_ALLOCATION	='I';
	public static final char RECTYPE_CONSOMME	='J';
	public static final String PID="PID";
	
	public static final String A_CLE="CLE";
	public static final String A_DCREATION="DATE_CREAT";
	public static final String A_VERSION="VERSION";
	
	public static final String NUM_ETAPE="NUM_ETAPE";
	public static final String NUM_TACHE="NUM_TACHE";
	public static final String NUM_SSTA="NUM_SSTACHE";
	public static final String ETS="ETS";

	public static final String PACTE_ES = "ES    ";
	public static final String PACTE_NO = "NO    ";
	public static final String PACTE_BLANC="      ";
		
	public static final String SSTACHE_AB_CONGES	= "CONGES";
	public static final String SSTACHE_AB_ABSDIV	= "ABSDIV";
	public static final String SSTACHE_AB_MOBILI	= "MOBILI";
	public static final String SSTACHE_AB_CLUBUT	= "CLUBUT";
	public static final String SSTACHE_AB_FORFAC	= "FORFAC";
	public static final String SSTACHE_AB_ACCUEI	= "ACCUEI";
	public static final String SSTACHE_AB_FORMAT	= "FORMAT";
	public static final String SSTACHE_AB_SEMINA	= "SEMINA";
	public static final String SSTACHE_AB_INTEGR	= "INTEGR";
	public static final String SSTACHE_AB_FORHUM	= "FORHUM";
	public static final String SSTACHE_AB_FOREAO	= "FOREAO";
	public static final String SSTACHE_AB_FORINF	= "FORINF";
	public static final String SSTACHE_AB_FOREXT	= "FOREXT";
	public static final String SSTACHE_AB_FORINT	= "FORINT";
	public static final String SSTACHE_AB_COLOQU	= "COLOQU";
	public static final String SSTACHE_AB_RTT 		= "RTT   ";
	public static final String SSTACHE_AB_PARTIE	= "PARTIE";
	public static final String SSTACHE_AB_DEMENA	= "DEMENA";
	public static final String [] SSTACHE_AB	= {	SSTACHE_AB_CONGES, SSTACHE_AB_ABSDIV, SSTACHE_AB_MOBILI,
													SSTACHE_AB_CLUBUT, SSTACHE_AB_FORFAC, SSTACHE_AB_ACCUEI,
													SSTACHE_AB_FORMAT, SSTACHE_AB_SEMINA, SSTACHE_AB_INTEGR,
													SSTACHE_AB_FORHUM, SSTACHE_AB_FOREAO, SSTACHE_AB_FORINF,
													SSTACHE_AB_FOREXT, SSTACHE_AB_FORINT, SSTACHE_AB_COLOQU,
													SSTACHE_AB_RTT, SSTACHE_AB_PARTIE, SSTACHE_AB_DEMENA };
	
	public static final String SSTACHE_ES_FM		= "FM    ";
	public static final String SSTACHE_ES_EN		= "EN    ";
	public static final String SSTACHE_ES_ST		= "ST    ";
	public static final String [] SSTACHE_ES	= {	SSTACHE_ES_FM, SSTACHE_ES_EN, SSTACHE_ES_ST };
	
	public static final String SSTACHE_HEUSUP		= "HEUSUP";
	public static final String SSTACHE_EN			= "EN    ";
	public static final String SSTACHE_BLANC		= "      ";
	public static final String [] SSTACHE_SANS_PID	= {	SSTACHE_HEUSUP, SSTACHE_EN, SSTACHE_BLANC };
	
	public static final String SSTACHE_FF			= "FF";
	public static final String SSTACHE_DF			= "DF";
	public static final String [] SSTACHE_PID	= {	SSTACHE_FF, SSTACHE_DF};
	
	public static final String SSTACHE_FC			= "FC";
	public static final String SSTACHE_DC			= "DC";
	public static final String [] SSTACHE_PID_PROJET	= {	SSTACHE_FC, SSTACHE_DC };
	
	/**
	 * Nom des champs associes
	 */
	public static final String TYPE_ETAPE="TYPE_ETAPE";
	public static final String TYPE_SSTACHE="TYPE_SSTA";
	public static final String DATE_DEB	=	"DATE_DEB";
	public static final String DATE_DEB_INI="DATE_DEB_INI";
	public static final String DATE_FIN_INI="DATE_FIN_INI";
	public static final String DATE_DEB_REV="DATE_DEB_REV";
	public static final String DATE_FIN_REV="DATE_FIN_REV";
	//public static final String NOM_ACTIVITE="NOM_ACTIVITE";
	public static final String NOM_SSTA="NOM_SSTA";
	public static final String POURCENTAGE="POURC";
	public static final String NB_JOURS="NB_JOURS";
	public static final String TYPE_CONSOMME="TYPE_CONSO";
	
	public static final String TIRES="TIRES";
	
	public static final String CHARGE_PLANIFIEE	=	"CHARGE_P";
	public static final String CHARGE_CONSOMMEE	=	"CHARGE_C";
	public static final String CHARGE_RAF		=	"CHARGE_R";
	
	public static final String CONSOMME_TYPE_0		= "0";
	public static final String CONSOMME_TYPE_1		= "1";
	public static final String CONSOMME_TYPE_2		= "2";
	public static final String [] CONSOMME_TYPE	= {	CONSOMME_TYPE_0, CONSOMME_TYPE_1, CONSOMME_TYPE_2 };
	
	// KRA 16/04/2015 - PPM 60612 : déclaration des champs constants
	
	public static final String LIGNE_BIP_CODE		= "LIGNEBIPCODE";
	public static final String LIGNE_BIP_CLE 		= "LIGNEBIPCLE";
	public static final String STRUCTURE_ACTION 	= "STRUCTUREACTION";
	public static final String ETAPE_NUM 			= "ETAPENUM";
	public static final String ETAPE_TYPE 			= "ETAPETYPE";
	public static final String ETAPE_LIBEL 		= "ETAPELIBEL";
	public static final String TACHE_NUM 			= "TACHENUM";
	public static final String TACHE_LIBEL 		= "TACHELIBEL";
	public static final String TACHE_AXE_METIER		= "TACHEAXEMETIER";
	public static final String STACHE_NUM 			= "STACHENUM";
	public static final String STACHE_TYPE 		= "STACHETYPE";
	public static final String STACHE_LIBEL 		= "STACHELIBEL";
	public static final String STACHE_INIT_DEB_DATE= "STACHEINITDEBDATE";
	public static final String STACHE_INIT_FIN_DATE= "STACHEINITFINDATE";
	public static final String STACHE_REV_DEB_DATE = "STACHEREVDEBDATE";
	public static final String STACHE_REV_FIN_DATE = "STACHEREVFINDATE";
	public static final String STACHE_STATUT 		= "STACHESTATUT";
	public static final String STACHE_DUREE 		= "STACHEDUREE";
	public static final String STACHE_PARAM_LOCAL  = "STACHEPARAMLOCAL";
	public static final String RESS_BIP_CODE 		= "RESSBIPCODE";
	public static final String RESS_BIP_NOM 		= "RESSBIPNOM";
	public static final String CONSO_DEB_DATE 		= "CONSODEBDATE";
	public static final String CONSO_FIN_DATE 		= "CONSOFINDATE";
	public static final String CONSO_QTE 			= "CONSOQTE";
	// Fin KRA 16/04/2015 - PPM 60612
	public static final String PROVENANCE 			= "PROVENANCE";
	public static final String PRIORITE				= "PRIORITE";
	public static final String TOP_BIPS					= "TOP";
	public static final String USER_PEC				= "USER_PEC";
	public static final String DATE_PEC				= "DATE_PEC";
	public static final String FICHIER				= "FICHIER";
}
