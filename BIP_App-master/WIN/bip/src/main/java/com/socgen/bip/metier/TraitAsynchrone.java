package com.socgen.bip.metier;

import java.io.File;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;

/**
 * @author RSRH/ICH/GMO Equipe Bip
 * @author E.GREVREND
 *
 * Gestion de la table des traitements asynchrones.<br>
 * Cette table 'TRAIT_ASYNCHRONE' est utilisée pour stocker les références aux fichiers qui sont générés en background (extractions, éditions asynchrones ...).<br>
 */
public class TraitAsynchrone implements BipConstantes {
	/**
	 * Config pointant sur le fichier de définition des procédures stockées des reports.<br>
	 * La valeur est récupérée de la classe com.socgen.bip.metier.Report
	 */
	//protected static Config cfgProc=Report.cfgProc;
	protected static Config cfgProc = ConfigManager.getInstance(BIP_PROC);
	/**
	 * Identifiant de la procédure stockée utilisée pour les updates sur TRAI_ASYNCHRONE
	 */
	protected static String PROC_UPDATE_ASYNC_ID = "async.update";
	protected static String PROC_UPDATE_ASYNC_EXTRACT = "async.update.extract";

	protected static String PROC_PURGER_ASYNC_ID = "async.delete";
	protected static String PACK_PURGER_LISTE_FICHIER = "async.liste_delete.proc";

	/**
	 * Logger JDBC
	 */
	protected static Log logJDBC = ServiceManager.getInstance().getLogManager().getLogJdbc();
	/**
	 * Logger de suivi des actions des utilisateurs
	 */
	protected static final Log logBipService = ServiceManager.getInstance().getLogManager().getLogService();
	/**
	 * Valeur du champ TRAIT_ASYNCHRONE.TYPE définissant une extraction.
	 */
	public static final String TYPE_EXTRACTION = "X";
	/**
	 * Valeur du champ TRAIT_ASYNCHRONE.TYPE définissant une edition.
	 */
	public static final String TYPE_EDITION = "E";
	/**
	 * Valeur du champ TRAIT_ASYNCHRONE.STATUT définissant un traitement terminé avec succès.
	 */
	public static final int STATUT_OK = 1;
	/**
	 * Valeur du champ TRAIT_ASYNCHRONE.STATUT définissant un traitement en échec.
	 */
	public static final int STATUT_KO = -1;
	/**
	 * Valeur du champ TRAIT_ASYNCHRONE.STATUT définissant un traitement en cours.
	 */
	public static final int STATUT_ENCOURS = 0;

	/**
	 * Fonction permettant d'ajouter une nouvelle ligne dans la table TRAIT_ASYNCHRONE.<br>
	 * @param sGlobal la chaîne identifiant l'utilisateur
	 * @param sType Edition ou eXtraction
	 * @param sTitre libellé associé au fichier
	 * @param sFichier nom temporaire attribué au fichier
	 * @param dDate date associée au fichier
	 * @param iStatut le statut associé au fichier (en cours, KO ou OK)
	 * @throws BaseException levée par connectOracle
	 * @see com.socgen.bip.metier.TraitAsynchrone#insert(String, String, String, String, Date)
	 * @see com.socgen.bip.metier.TraitAsynchrone#getGlobal(String) pour le formattage de sGlobal à partir de l'idArpege.
	 * @see com.socgen.bip.db.JdbcBip#connectOracle(String, Hashtable, Config, String)
	 */
	private static void insertPriv(
		String sGlobal,
		String sType,
		String sTitre,
		String sFichier,
		Date dDate,
		int iStatut,
		String sReportId,
	    String sIdJobReport)
		throws BaseException {
		String sMsg;
		String sDate;
		Vector vRes;
		Hashtable hParam = new Hashtable();

		JdbcBip jdbc = new JdbcBip(); 
		
		if (logJDBC.isDebugEnabled()) {
			logJDBC.debug("P_global : " + sGlobal);
			logJDBC.debug("P_type : " + sType);
			logJDBC.debug("P_titre : " + sTitre);
			logJDBC.debug("P_nomFichier : " + sFichier);
			logJDBC.debug("P_date : " + dDate.toString());
			logJDBC.debug("P_statut : " + iStatut);
			logJDBC.debug("P_reportId : " + sReportId);
			logJDBC.debug("P_idjobreport : " + sIdJobReport);
		}

		hParam.put("P_global", "" + sGlobal);
		hParam.put("P_type", "" + sType);
		hParam.put("P_titre", "" + sTitre);
		hParam.put("P_nomFichier", "" + sFichier);
		hParam.put("P_URL", "");
		hParam.put("P_date", dDate);
		hParam.put("P_statut", "" + iStatut);
		hParam.put("P_reportid", "" + sReportId);
		hParam.put("P_idjobreport", "" + sIdJobReport);

		vRes = jdbc.getResult(hParam, cfgProc, PROC_UPDATE_ASYNC_ID);
		jdbc.closeJDBC();

	}

	/**
	 * Fonction permettant de finaliser un enregistrement de la table TRAIT_ASYNCHRONE.<br>
	 * @param sGlobal la chaîne identifiant l'utilisateur formattée par getGlobal(tring)
	 * @param sType Edition ou eXtraction
	 * @param sTitre libellé associé au fichier
	 * @param sFichier nom du fichier à rechercher dans la table
	 * @param dDate date associée au fichier
	 * @param sNouveauFichier nouveau non associé au fichier
	 * @param iStatut
	 * @throws BaseException levée par connectOracle
	 * @see com.socgen.bip.metier.TraitAsynchrone#getGlobal(String) pour le formattage de sGlobal à partir de l'idArpege.
	 * @see com.socgen.bip.db.JdbcBip#connectOracle(String, Hashtable, Config, String)
	 * @see com.socgen.bip.metier.TraitAsynchrone#update(String, String, String, String, Date, String, int)
	 */
	//private static void updatePriv(String sGlobal,
	public static void update(
		String sGlobal,
		String sType,
		String sTitre,
		String sFichier,
		Date dDate,
		String sNouveauFichier,
		int iStatut,
		String sReportId,
	    String sIdJobReport)
		throws BaseException {
		String sMsg;
		Vector vRes;
		Hashtable hParam = new Hashtable();

		JdbcBip jdbc = new JdbcBip(); 
		
		if (logJDBC.isDebugEnabled()) {
			logJDBC.debug("Parametrage de la proc : " + PROC_UPDATE_ASYNC_ID);
			logJDBC.debug("P_global : " + sGlobal);
			logJDBC.debug("P_type : " + sType);
			logJDBC.debug("P_titre : " + sTitre);
			logJDBC.debug("P_nomFichier : " + sFichier);
			logJDBC.debug("P_URL : " + sNouveauFichier);
			logJDBC.debug("P_date : " + dDate.toString());
			logJDBC.debug("P_statut : " + iStatut);
			logJDBC.debug("P_reportid : " + sReportId);
			logJDBC.debug("P_idjobreport : " + sIdJobReport);
		}

		hParam.put("P_global", "" + sGlobal);
		hParam.put("P_type", "" + sType);
		hParam.put("P_titre", "" + sTitre);
		hParam.put("P_nomFichier", "" + sFichier);
		hParam.put("P_URL", "" + sNouveauFichier);
		hParam.put("P_date", dDate);
		hParam.put("P_statut", "" + iStatut);
		hParam.put("P_reportid", "" + sReportId);
		hParam.put("P_idjobreport", "" + sIdJobReport);

		vRes = jdbc.getResult( hParam, cfgProc, PROC_UPDATE_ASYNC_ID);
		jdbc.closeJDBC();
	}
	/**
	 * Fonction permettant de finaliser un enregistrement de la table TRAIT_ASYNCHRONE pour les extractions parametrées.<br>
	 * @param sGlobal la chaîne identifiant l'utilisateur formattée par getGlobal(tring)
	 * @param sType Edition ou eXtraction
	 * @param sTitre libellé associé au fichier
	 * @param sFichier nom du fichier à rechercher dans la table
	 * @param dDate date associée au fichier
	 * @param sNouveauFichier nouveau non associé au fichier
	 * @param iStatut
	 */
	public static void updateExtract(String sGlobal, String sType, String sTitre, String sFichier, int iStatut, String sReportId, String sIdJobReport)
		throws BaseException {
		String sMsg;
		Vector vRes;
		Hashtable hParam = new Hashtable();

		JdbcBip jdbc = new JdbcBip(); 
		
		hParam.put("P_global", "" + sGlobal);
		hParam.put("P_type", "" + sType);
		hParam.put("P_titre", "" + sTitre);
		hParam.put("P_nomFichier", "" + sFichier);
		hParam.put("P_statut", "" + iStatut);
		hParam.put("P_reportid", "" + sReportId);
		hParam.put("P_idjobreport", "" + sIdJobReport);

		vRes = jdbc.getResult(hParam, cfgProc, PROC_UPDATE_ASYNC_EXTRACT);
		jdbc.closeJDBC();
	}

	public static void updateExtract(String sGlobal, String sType, String sTitre, String sFichier, int iStatut, String sReportId)
	throws BaseException {
	updateExtract(sGlobal, sType, sTitre, sFichier, iStatut, sReportId,"");
}
	
	public static void updateExtract(String sGlobal, String sType, String sTitre, String sFichier, int iStatut)
		throws BaseException {
		updateExtract(sGlobal, sType, sTitre, sFichier, iStatut, "","");
	}

	/**
	 * Fonction qui permet d'ajouter une nouvelle entrée dans la table TRAIT_ASYNCHRONE.<br>
	 * Le nouvel enregistrement à un statut 'en_cours'
	 * @param sIdArpege l'identifiant de l'utilisateur
	 * @param sType Edition ou eXtraction
	 * @param sTitre libellé associé au fichier
	 * @param sFichier nom du fichier
	 * @param dDate date associée au fichier
	 * @throws BaseException levée par insertPriv(...)
	 */
	public static void insert(String sGlobal, String sType, String sTitre, String sFichier, Date dDate, String sReportId, String sIdJobReport)
		throws BaseException {
		insertPriv(sGlobal, sType, sTitre, sFichier, dDate, STATUT_ENCOURS, sReportId, sIdJobReport);
	}// insert

	public static void purger(String sType, String sGlobal, Vector vFileName) throws BaseException, BipException {
		String name_proc = "TraitAsynchrone-purger()";
		Vector vRes;
		Hashtable hParam = new Hashtable();
		boolean suppressionOK = true;

		hParam.put("type", "" + sType);
		hParam.put("global", "" + sGlobal);

		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		Vector file2delete = new Vector();

		//Récupération des résultats
		file2delete = vFileName;
		
		JdbcBip jdbc = new JdbcBip(); 

		
		String dirData = Tools.getSysProperties().getProperty(DIR_DATA);
		if (dirData == null) {
			logBipService.error(DIR_DATA + " == null ");
			Object tab[] = { DIR_DATA };
			//il n'est pas normal de ne pas avoir la var de definie => erreur
			throw new BipException(20006, null, tab);
		}

		for (Enumeration vE = file2delete.elements(); vE.hasMoreElements();) {
			String f2d = (String) vE.nextElement();
			File f_fichier = new File(dirData + "/" + f2d);
			if (f_fichier.isFile()) {
				if (!f_fichier.delete()) {
					logBipService.debug(dirData + "/" + f2d + " --> Erreur lors de la suppression.");
					suppressionOK = false;
				}
			} else {
				logBipService.error(dirData + "/" + f2d + " ne correspond pas à un fichier.");
			}
		}
		
	
		
		if (suppressionOK) {
			StringBuffer sb = new StringBuffer();
			for (int i=0; i<file2delete.size(); i++) {
				if (sb.length()>0) sb.append(",");
				sb.append("'"+file2delete.get(i)+"'");
			}
				
			hParam.put("file2delete", sb.toString());
			vRes = jdbc.getResult(hParam, cfgProc, PROC_PURGER_ASYNC_ID);
			
		}

		jdbc.closeJDBC();
		
	}// purger

}
