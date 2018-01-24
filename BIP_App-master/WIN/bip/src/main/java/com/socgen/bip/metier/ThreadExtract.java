package com.socgen.bip.metier;

import java.io.File;
import java.util.GregorianCalendar;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ExtractParamForm;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;
import java.util.GregorianCalendar;

/**
 * @author N.BACCAM
 * La classe lance la génération de l'extraction paramétrée
 * 
 */
public class ThreadExtract extends Thread implements BipConstantes {
	/**
	 * Logger de suivi des actions des utilisateurs
	 */
	protected static final Log logBipUser = BipAction.getLogBipUser();
	/**
	 * Le répertoire dans lequel les fichiers peuvent être récuperes
	 */
	protected static final String sExtractOut =
		ConfigManager
			.getInstance(BIP_REPORT)
			.getString("report.out");
	/**
	 * Le répertoire dans lequel les fichiers sont crées physiquement
	 */
	protected static final String sUrl =
		ConfigManager
			.getInstance(BIP_REPORT)
			.getString("extractParam.fichier");

	private ExtractParamForm extractParamForm;
	private UserBip userBip;

	/**
	 * Constructor for ThreadExtract.
	 */
	public ThreadExtract(ExtractParamForm extractParamForm, UserBip userBip) {
		super();
		this.extractParamForm = extractParamForm;
		this.userBip = userBip;

	}

	/**
	 * Lancement du thread pour l'extraction.
	 */
	public void run() {
		String sEX;
		String sFichier;
		String sNomFichier;
		String sLibelleFichier;
		String sUrlFichier;


		String sUser = "";
		String sGlobal;
		File fichier;

		String signatureMethode = "ThreadExtract-run()";
		logBipUser.entry(signatureMethode);

		sEX = TraitAsynchrone.TYPE_EXTRACTION;
		//logBipUser.entry("sEX:" + sEX);
		try {

			String timeStamp = getTimeStamp(); 
			sNomFichier = extractParamForm.getNomFichier();
			sLibelleFichier = extractParamForm.getTitre();
			sGlobal = extractParamForm.getInfosUser();
			sUser = userBip.getIdUser();
			//sFichier = sExtractOut + sUser + "." + sNomFichier + ".CSV";
			//sUrlFichier = sUrl + sUser + "." + sNomFichier + ".CSV";
			
			sFichier = sExtractOut + sUser + "." + sNomFichier + timeStamp + ".CSV";
			sUrlFichier = sUrl + sUser + "." + sNomFichier + timeStamp +  ".CSV";

			TraitAsynchrone.updateExtract(
					sGlobal,
					sEX,
					sLibelleFichier,
					sFichier,
					TraitAsynchrone.STATUT_ENCOURS,
					"Audit");
			try {
				ExtractParamManager extractParamManager =
					new ExtractParamManager();

				//on génèrel'extraction	
				extractParamManager.execExtract(extractParamForm, sUrlFichier);

				//on valide l'entree dans la table trait_asynchrone 
				TraitAsynchrone.updateExtract(
					sGlobal,
					sEX,
					sLibelleFichier,
					sFichier,
					TraitAsynchrone.STATUT_OK,
					"Audit");
			} catch (BipException be) {
				//on invalide l'entree dans la table trait_asynchrone 
				TraitAsynchrone.updateExtract(
					sGlobal,
					sEX,
					sLibelleFichier,
					sNomFichier,
					TraitAsynchrone.STATUT_KO,
					"Audit");
				logBipUser.error(be.getMessage());
			}
		} catch (BaseException be) {
			logBipUser.error(be.getMessage());
		} catch (Exception e) {

			logBipUser.error(e.getMessage());
		}

		
		logBipUser.exit(signatureMethode);

	}
	
	/**
	 * Permet de retourner une chaine de caractères représentant le Time Stamp
	 * Servira à générer différents fichiers CVS avec un nom différents (afin corriger un bug
	 * et de pouvoir générer plusieurs Exports sur PC à la suite avec différents paramètres).
	 * 
	 * @return
	 */
	private String getTimeStamp(){
		GregorianCalendar calendar = new GregorianCalendar()  ;
		return String.valueOf(calendar.get(GregorianCalendar.YEAR)) +  String.valueOf(calendar.get(GregorianCalendar.MONTH)) + 
				String.valueOf(calendar.get(GregorianCalendar.DAY_OF_MONTH)) + String.valueOf(calendar.get(GregorianCalendar.MINUTE)) + 
				String.valueOf(calendar.get(GregorianCalendar.SECOND)) + String.valueOf(calendar.get(GregorianCalendar.MILLISECOND)) ; 
	}
	

}
