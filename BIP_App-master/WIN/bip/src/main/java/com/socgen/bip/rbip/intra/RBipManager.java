/*
 * Créé le 12 août 04
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package com.socgen.bip.rbip.intra;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;
import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.db.RBip_Jdbc;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;

/**
 * On limite le nombre de controles simultanes.
 * 
 * @author X039435
 */
public class RBipManager extends Thread implements BipConstantes {
	protected static String PROC_SELECT_FICHIER_STATUT = "remontee.select_fichiers_statut";


	protected static String NBMAX = "rbip.intra.nbMax";
	
	

	/**
	 * Logger
	 */
	protected static Log logService = ServiceManager.getInstance()
			.getLogManager().getLogService();

	protected static Config cfgRBipIntra = ConfigManager
			.getInstance(BIP_CFG_RBIPINTRA);

	/**
	 * Instance du RBipManager
	 */
	static private RBipManager instance = new RBipManager();

	
	private int nbMax = new Integer(cfgRBipIntra.getString(NBMAX)).intValue();

	/**
	 * vPile contient la liste de controles a effectuer On pourrait se passer de
	 * ce vecteur et ne se baser que sur la base Cette solution permet de
	 * limiter les accès
	 */
	//FIXME DHA mysterious naming
	Vector vPile;

	/**
	 * vEnCours contient la liste des controles en cours On pourrait également
	 * se passer ce vecteur.
	 */
	Vector vEnCours;

	//FIXME DHA mysterious naming
	Hashtable hPile;

	int iSalve;
	
	//FIXME DHA spécifique à un fichier en cours de traitement. Donc ne devrait pas être stocké dans RBIPManager
	String sNomFichier;


	private RBipManager() {
		vPile = new Vector();
		hPile = new Hashtable();
		vEnCours = new Vector();
		iSalve = 0;

//		rebuildPile();
		logService.info("RBipManager::nbMax = " + nbMax);
		setPriority(Thread.MIN_PRIORITY);
		logService.info("RBipManager::prorite : MIN");
		start();
	}

//	/**
//	 * Retourne l'instance statique du RBipManager, si elle est encore a 'null'
//	 * elle est instanciée.
//	 */
	public static RBipManager getInstance() {
		return instance;
	}

	/**
	 * Permet de reconstruire le vecteur vPile au redémarrage de l'appli Ainsi
	 * tous les fichiers en base non controles a l'arret / plantage sont bien
	 * pris en charge. Si on trouve des enregistrements dans la base qui sont en
	 * satut 'controle en cours', ils sont remis a un statut 'a controler'.
	 * 
	 * 
	 */
	private void rebuildPile() {
		
		
//		// tous les enregistrements en etat 1 doivent etre repris pour être
//		// controles
//		try {
//			Vector vRes;
//			Hashtable hParam = new Hashtable();
//
//			hParam.put("statut", "" + RBipFichier.STATUT_NON_CONTROLE);
//
//			vRes = jdbc.getResult( hParam,
//					RBipFichier.cfgProc, PROC_SELECT_FICHIER_STATUT);
//			ParametreProc pP = (ParametreProc) vRes.firstElement();
//			ResultSet rset = (ResultSet) pP.getValeur();
//
//			try {
//				String sPID;
//				String sIDRemonteur;
//				String sFichier;
//				int iStatut;
//				Date dStatutDate;
//				String sStatutInfo;
//
//				while (rset.next()) {
//					try {
//						sPID = rset.getString(1);
//						sIDRemonteur = rset.getString(2);
//						sFichier = rset.getString(3);
//						iStatut = rset.getInt(4);
//						// dStatutDate = rset.getDate(5);
//						sStatutInfo = rset.getString(6);
//						
//						RBipFichier rBip = new RBipFichier(sPID, sIDRemonteur,
//								sFichier, iStatut, null,// dStatutDate,
//								sStatutInfo, RBipFichier.getLignesFichier(sPID,
//										sIDRemonteur,sFichier));
//
//						addControle(rBip);
//					} catch (SQLException sqlE) {
//						// exception sur gestion d'un des fichiers ...
//						// il faut continuer
//						logService
//								.error(
//										"RBipManager.rebuildPile : Probleme dans recuperation des fichiers non contrôles, on passe au fichier suivant",
//										sqlE);
//					}
//				}
//				if (rset != null)
//					rset.close();
//			} catch (SQLException sqlE) {
//				logService
//						.error(
//								"RBipManager.rebuildPile : Probleme dans recuperation des fichiers non contrôles : auncun fichier ne sera recupere",
//								sqlE);
//			}
//		} catch (BaseException bE) {
//			logService
//					.error(
//							"RBipManager.rebuildPile : Probleme dans recuperation des fichiers non contrôles : auncun fichier ne sera recupere",
//							bE);
//		} 
//		
//		finally{
//		jdbc.closeJDBC();
//		}
	}

	
	
	
	//FIXME DHA : Dead code for the overloaded addControle(). Noise and error prone
	/**
	 * Appele a priori par la servlet d'upload. l'objet passe correspond a un
	 * fichier de remontee a controler. il est deja reference dans la base de
	 * donnee. on l'ajoute a la fin de la pile des controles
	 * 
	 * @param rbipc
	 */
	/**
	 */
//	public void addControle(String sIDRemonteur, String sFileName,
//			Vector vLignes) {
//		// On récupère le PID à partir du nom de fichier .bip
//		RBip_Jdbc.P_PID = Tools.getPIDFromFileName(sFileName);
//		String sCle = Tools.getPIDFromFileName(sFileName) + "-" + sIDRemonteur;
//		RBipFichier rbipNew = new RBipFichier(sIDRemonteur, sFileName, vLignes);
//		Object o = hPile.put(sCle, rbipNew);
//
//		if (o != null) {
//			logService.info("RBipManager::addControle : " + sCle
//					+ " on retire l'ancienne occurance");
//			vPile.remove(o);
//		}
//		vPile.add(rbipNew);
//	}
	
	
	//FIXME DHA addControle() is a bad chosen method name as the method may both perform control and save operations
	//FIXME DHA addControle() is not thread safe and has race conditions as callable by multiple instances of RBipZipExtractorThread.run() and of RBipUploadAction.bipPerform()
	public void addControle(UserBip userBip, String sFileName,
			Vector vLignes,String action) {
		// On récupère le PID à partir du nom de fichier .bip
		sNomFichier = sFileName;
		// FIXME DHA You change the value of a global variable. With concurrent access, it could make inconsistency the value for the caller 
		RBip_Jdbc.P_PID = Tools.getPIDFromFileName(sFileName);
		// FIXME DHA duplicate invocation of Tools.getPIDFromFileName(sFileName) 
		String sCle = Tools.getPIDFromFileName(sFileName) + "-" + userBip.getIdUser();
		
		RBipFichier rbipNew = new RBipFichier(userBip, sFileName, vLignes,action);
		rbipNew.setStatut(RBipFichier.STATUT_NON_CONTROLE, "controler");
		Object o = hPile.put(sCle, rbipNew);

		//FIXME DHA Mysterious processing : why having a Vector (vPile) that synchronizes its state according to a HashTable (hPile)
		// Why not directly use the HashTable that already contains the values ?
		if (o != null) {
			logService.info("RBipManager::addControle : " + sCle
					+ " on retire l'ancienne occurance");
			vPile.remove(o);
		}
		vPile.add(rbipNew);
		//FIXME DHA end of mysterious processing 
	}

//	private void addControle(RBipFichier rbipc) {
//		hPile.put(getCle(rbipc), rbipc);
//		vPile.add(rbipc);
//	}

	private boolean isServerFree() {
		
		//FIXME DHA Why is it free if it is a file with a bips extension ?
		// le controle dans le else devrait être suffisant
		if (sNomFichier != null && sNomFichier.endsWith(sPBipsExtension.toUpperCase()))
		{
			return true;
			
		}
		else
		{
		return (vEnCours.size() < nbMax);
		}
	}

	public void run() {
		RBipFichier rbipTmp;

		logService.info("RBipManager : Go !!!!");
		while (true) {
			synchronized (this) {
				if (isServerFree()) {
					if (!vPile.isEmpty()) {
						rbipTmp = (RBipFichier) vPile.firstElement();
						traiter(rbipTmp);
					} else {
						/*
						 * if (logService.isDebugEnabled())
						 * logService.debug("RBipManager.run : server NOT free :
						 * "+vEnCours.size()+"/"+nbMax);
						 */
						if ((vEnCours.isEmpty()) && (iSalve > 0)) {
							logService.info("RBipManager : salve de " + iSalve
									+ " controles consecutifs");
							iSalve = 0;
						}

						try {
							sleep(100);
						} catch (InterruptedException iE) {
							logService
									.error("RBipManager.run : pb avec un sleep");
						}
					}
				} else {
					try {
						sleep(100);
					} catch (InterruptedException iE) {
						logService.error("RBipManager.run : pb avec un sleep");
					}
				}
			}
		}
	}

	/**
	 * 
	 * @param rbip
	 */
	//FIXME DHA (WARN):  the method is not blocking. 
	public void traiter(RBipFichier rbip) {
		String sMsg = "RBipManager.traiter : ";
		vEnCours.add(rbip);

		vPile.remove(rbip);
		hPile.remove(getCle(rbip));

		if (logService.isDebugEnabled())
			logService.debug(sMsg + " on lance le controle de : "
					+ rbip.toString());

		RBipControleThread tR = new RBipControleThread(rbip);
		tR.start();
		try {
			tR.join();
		} catch (InterruptedException e) {
			BipAction.logBipUser.error("error durant le join du thread controller", e);
			
		}

		iSalve++;
	}

	private String getCle(RBipFichier rbip) {
		return rbip.getPID() + "-" + rbip.getIDRemonteur();
	}

	public void retirer(RBipFichier rbip) {
		String sMsg = "RBipManager.retirer : ";
		if (vEnCours.remove(rbip)) {
			if (logService.isDebugEnabled())
				logService.debug(sMsg + "retrait de : " + rbip.toString()
						+ " - enCours/a traiter : = " + vEnCours.size() + " / "
						+ vPile.size());
		} else {
			// ??????
			logService
					.warning(sMsg
							+ " tentative de retrait d'un rbip qui n'est pas dans vEnCours : "
							+ rbip.toString());
		}
	}
}
