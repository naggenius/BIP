/*
 * Créé le 10 mai 04
 *
 */
package com.socgen.bip.rbip.commun.erreur;

import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

import com.socgen.bip.rbip.commun.RBipConstants;

/**
 * @author X039435 / E.GREVREND
 *
 * Contient les tag nécessaires pour retrouver les infos dans le fichier de ressource.<br>
 * Contienr les différentes codes erreurs que l'on DOIT pouvoir retrouver dans le fichier de ressource des erreurs. 
 */
public interface RBipErreurConstants extends RBipConstants
{
	/**
	 * Dans le fichier des ressources de RBip (cf RBipConstants) on recherche le nom du fichier de ressources des erreurs.<br>
	 * cfgErr est le RessourceBundle associé à ce fichier
	 */
	public static ResourceBundle cfgErr = PropertyResourceBundle.getBundle(cfgRbip.getString("erreurs"));
	
	/**
	 * Tag préfixant les codes erreurs dans le fichier des ressources
	 */
	public static final String TAG_ERREUR="erreur.";
	
	/**
	 * Tag préfixant les codes warning dans le fichier des ressources
	 */
	public static final String TAG_WARNING="warning.";
	
	/**
	 * Les codes erreurs ...
	 */
	//erreur elementaire strictes (types ...)
	public static final String ERR_NODATA		=	"X000";	//pas de donnees dans le fichier
	public static final String ERR_BAD_FILENAME	=	"X001";	//nom de fichier non valide
	public static final String ERR_BAD_RECTYPE	=	"X002";	//type d'enregistrement non gere
	public static final String ERR_MISS_RECTYPE	=	"X003";	//tous les rectypes doivent etres presents
	public static final String ERR_BAD_PID		=	"X004";	// QC1283 - Erreur : Code ligne Inexistant
	
	public static final	String ERR_BAD_SIZE			=	"000";	//un enregistrement qui n'a pas la bonne longueur
	public static final String ERR_NOT_NULL			=	"001";	//si un champ n'est pas definit alors qu'il est obligatoire
	public static final String ERR_BAD_TYPE			=	"002";	//la valeur ne correspond au type du champ

	//erreurs referentiels
	public static final String A_ERR_BAD_PID		=	"A010";	// le PID ne correspond pas a celui du projet en cours
	public static final String G_ERR_BAD_PID		=	"G010";	// le PID ne correspond pas a celui du projet en cours
	public static final String I_ERR_BAD_PID		=	"I010";	// le PID ne correspond pas a celui du projet en cours
	public static final String J_ERR_BAD_PID		=	"J010";	// le PID ne correspond pas a celui du projet en cours

	public static final String A_ERR_BAD_CLE		=	"A011";	// le PID ne correspond pas a celui du projet en cours

	public static final String G_ERR_A_FIRST		=	"G100";	//En-Tete doit etre le premier enr du fichier
	public static final String I_ERR_A_FIRST		=	"I100";	//En-Tete doit etre le premier enr du fichier
	public static final String J_ERR_A_FIRST		=	"J100";	//En-Tete doit etre le premier enr du fichier
	public static final String PARAM_ERR_FIRST		=	"P100";	//Param doit etre le premiere enr du fichier 

	public static final String A_ERR_UNIQUE			=	"A101";	//un seul En-Tete par fichier
	public static final String G_ERR_AGIJ			=	"G101";	//Ordre AGIJ a respecter dans le fichier
	public static final String I_ERR_AGIJ			=	"I101";	//Ordre AGIJ a respecter dans le fichier
	public static final String J_ERR_AGIJ			=	"J101";	//Ordre AGIJ a respecter dans le fichier
	public static final String PARAM_ERR_UNIQUE		=	"P101";	//un seul param par PID

	public static final String A_ERR_PREM			=	"A102";	//En-Tete doit etre a la premiere ligne
	public static final String PARAM_ERR_PREM		=	"P102";	//la ligne param doit etre placee avant les lignes de détail

	public static final String G_ERR_ETS_ORDRE		=	"G110";
	public static final String G_ERR_ETS_UNIQUE		=	"G111";
	public static final String G_ERR_ETS_E			=	"G112";
	public static final String G_ERR_ETS_T_00		=	"G113";
	public static final String G_ERR_ETS_T_MAX		=	"G114";
	public static final String G_ERR_ETS_S			=	"G115";
	public static final String G_ERR_TYPE_ETAPE		=	"G116";
	public static final String G_ERR_AB_TYPE_ETAPE	=	"G117";
	public static final String G_ERR_AB_NB_ETAPE	=	"G118";
	public static final String G_ERR_AB_TYPE_SSTACHE=	"G119";
	public static final String G_ERR_ES_TYPE_SSTACHE_BLANC	= "G120";
	public static final String G_ERR_ES_TYPE_SSTACHE=	"G121";
	public static final String G_ERR_NES_TYPE_SSTACHE=	"G122";
	public static final String G_ERR_NES_TYPE_SSTACHE_PID=	"G123";
	public static final String G_ERR_TYPE_ETAPE_NO	=	"G124"; 		//SEL PPM 60709 6.4
	
	public static final String G_WAR_TYPE_ETAPE		=	"GW01";

	public static final String I_ERR_ETS_ORDRE		=	"I110";	
	public static final String I_ERR_REF_ACTIVITE	=	"I111";
	public static final String I_ERR_TIRES_UNIQUE	=	"I112";

	public static final String J_ERR_ETS_ORDRE		=	"J110";	
	public static final String J_ERR_REF_ALLOCATION	=	"J111";
	public static final String J_ERR_POURC			=	"J112";
	
	public static final String AUTRE_ERR_MAX		=	"*110";
	
	//60612
	public static final	String ERR_BAD_REC			=	"111";	//1er enregistrement n'est pas conform
	public static final String ERR_S1						=	"0S1";	
	public static final String ERR_S2						=	"0S2";	
	public static final String ERR_S3						=	"0S3";	
	public static final String REJET_GLOBAL_PID_HAB		=	"222";
	public static final String REJET_GLOBAL_TECHNIQUE	=	"R999";

	// KRA 16/04/2015 - PPM 60612 : ajout des erreurs de rejets pour un fichier .bips
	public static final String REJET_GLOBAL_BIPS_PID_INEXISTANTE =	"R001A";
	public static final String REJET_GLOBAL_BIPS_PID_FERMEE=	"R001B";
	public static final String REJET_BIPS_PID_FF_INEXISTANTE=	"R001C";
	public static final String REJET_BIPS_PID_FF_FERMEE=	"R001D";
//	public static final String REJET_BIPS_PERIODE_ANTERIEURE	 =	"R001E";
//	public static final String REJET_BIPS_PERIODE_ULTERIEURE = "R001F";
	
	//FIXME To remove when bipsmensuel will be updated with the good rule
	public static final String REJET_BIPS_TYPE_STACHE_INEXISTE	 =	"R011";

	
	
	public static final String REJET_BIPS_CLE					 =	"R002";
	public static final String REJET_BIPS_STRUCT_ACTION			 =	"R003";
	public static final String REJET_GLOBAL_BIPS_STRUCT_ACTION	 =	"R004";
	public static final String REJET_BIPS_NUM_ETAPE				 =	"R005";
	public static final String REJET_BIPS_TYPE_ETAPE_FORMAT		 =	"R006";
	public static final String REJET_BIPS_TYPE_ETAPE_INCONNU	 =	"R007";
	public static final String REJET_BIPS_NUM_TACHE				 =	"R008";
	public static final String REJET_BIPS_NUM_STACHE_FORMAT		 =	"R009";
	public static final String REJET_BIPS_NUM_STACHE_INEXISTE	 =	"R010";
	public static final String REJET_BIPS_TYPE_STACHE_INCONNU	 =	"R012";
	public static final String REJET_BIPS_RESS_CODE_INEXISTANT	 =	"R013";
	public static final String REJET_BIPS_RESS_NOM				 =	"R014";
	public static final String REJET_BIPS_CONSO_DEB_DATE_INVALIDE=	"R015";
	public static final String REJET_BIPS_CONSO_FIN_DATE_INVALIDE=	"R016";
	public static final String REJET_BIPS_CONSO_FIN_DATE_ELOIGNEE=	"R017";
	public static final String REJET_BIPS_CONSO_QTE_INVALIDE	 =	"R018";
	
	public static final String REJET_GLOBAL_BIPS_ACTIVITE_DOUBLONS=	"R019";
	public static final String REJET_BIPS_PERIODE_ANTERIEURE	 =	"R020";
	public static final String REJET_BIPS_PERIODE_ULTERIEURE	 =	"R021";
	public static final String REJET_GLOBAL_BIPS_PERIODE_DOUBLONS=	"R022";
	public static final String REJET_BIPS_TYPE_STACHE_PRO_INCONNU	 =	"R023";
	public static final String REJET_BIPS_ANNEE_ULTERIEURE	 =	"R024";
	public static final String REJET_BIPS_TYPE_ETAPE_INCOMPATIBLE	 =	"R025";

	// FAD PPM 64368 : Ajout des nouveaux rejets
	public static final String REJET_BIPS_CONSO_QTE_SR_MOIS		=	"R026";
	public static final String REJET_BIPS_CONSO_QTE_SR_ANNEE	=	"R027";
		// FAD PPM 64368 : Fin
	
	public static final String REJET_BIPS_NON_OUT_SOURCE	=	"R028";
	public static final String REJET_BIPS_NON_RETRO	=	"R029";

	// KRA 16/04/2015 - PPM 60612 : ajout des warning
	public static final String WARNING_BIPS_LIBELLE_ETAPE				 =	"W001";
	public static final String WARNING_BIPS_LIBELLE_TACHE				 =	"W002";
	public static final String WARNING_BIPS_LIBELLE_STACHE_LONG			 =	"W003";
	public static final String WARNING_BIPS_LIBELLE_STACHE_CAR_INTERDITS =	"W004";
	public static final String WARNING_BIPS_STACHE_INIT_DEB_DATE_INVALIDE=	"W005";
	public static final String WARNING_BIPS_STACHE_INIT_FIN_DATE_INVALIDE=	"W006";
	public static final String WARNING_BIPS_STACHE_REV_DEB_DATE_INVALIDE =	"W007";
	public static final String WARNING_BIPS_STACHE_REV_FIN_DATE_INVALIDE =	"W008";
	public static final String WARNING_BIPS_STACHE_DUREE				 =	"W009";
	public static final String WARNING_BIPS_STACHE_PLOCAL_CAR_INTERDITS  =	"W010";
	public static final String WARNING_BIPS_RESS_CODE_SITU				 =	"W011";
	// Fin KRA 16/04/2015 - PPM 60612
	public static final String WARNING_BIPS_RESS_NOM_COMP				 =	"W012";
	
	public static final String WARNING_TACHE_AXE_METIER_INCOHERENT		 =	"W013";
	public static final String WARNING_TACHE_AXE_METIER_PROJET			 =	"W014";
	public static final String WARNING_TACHE_AXE_METIER_DPCOPI			 =	"W015";
	public static final String WARNING_BIPS_TYPE_ETAPE_INCOMPATIBLE			 =	"W016";
}
