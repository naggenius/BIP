package com.socgen.bip.metier;

import java.sql.CallableStatement;
import java.sql.ResultSet;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.db.ExtractParamDb;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ExtractParamForm;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;


/**
 * @author N.BACCAM
 *
 * Classe qui gère les extractions paramétrées
 */
public class ExtractParamManager {
	// Initialise la variable config à pointer sur le fichier properties sql
	private static Config configSQL =
		ServiceManager.getInstance().getConfigManager().getSQL();
	/**
	 * Logger de suivi des actions des utilisateurs
	 */
	protected static final Log logBipUser = BipAction.getLogBipUser();

	private String sNomFichier;
	/**
	 * Constructor for ExtractParamManager.
	 */
	public ExtractParamManager() {
		super();
	}

	public void launchExtract(ExtractParamForm extractParamForm,UserBip userBip) {
		sNomFichier = extractParamForm.getNomFichier();
		String signatureMethode = "launchExtract(" + sNomFichier + ")";
		logBipUser.entry(signatureMethode);
		ThreadExtract tR = new ThreadExtract(extractParamForm,userBip);
		tR.start();
		logBipUser.exit(signatureMethode);

	}
	/**
	* execution de la requete et création du fichier
	*/
	public void execExtract(ExtractParamForm extractParamForm,String url) throws BipException {

		String requete;
		int nbData;
		String nomDonnees;

		int iStep;
		CallableStatement cstmt;
		ResultSet cursor;
		String sTextSql;
		

		String sSelect = "";
		String sCode;
		String sType;
		String sObligatoire;

		sNomFichier = extractParamForm.getNomFichier();
		String signatureMethode = "execExtract(" + sNomFichier + ")";
		logBipUser.entry(signatureMethode);
		try {
			ExtractParamDb db = new ExtractParamDb();
			//recuperation de la requete SQL d'origine
			sTextSql = db.getRequete(extractParamForm);
			logBipUser.debug("sTextSql:"+sTextSql);
			//exécution de la requête
			extractParamForm.setRequete(sTextSql);
			db.execRequete(extractParamForm,url);
			

			

		} catch (Exception e) {
			logBipUser.error(e.getMessage());
			if (e instanceof BaseException)
			{
				logBipUser.error(((BaseException)e).getInitialException().getMessage());
			}
			throw new BipException(20003, e);
		}

		logBipUser.exit(signatureMethode);
	}

}
