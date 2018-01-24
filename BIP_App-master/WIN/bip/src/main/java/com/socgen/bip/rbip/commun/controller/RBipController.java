/*
 * Créé le 26 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.controller;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.apache.log4j.helpers.NullEnumeration;
import org.threeten.bp.Instant;
import org.threeten.bp.LocalDate;
import org.threeten.bp.ZoneId;

import com.socgen.bip.commun.MonthAndYearFunctional;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.ToolsRBIPIntranetChannel;
import com.socgen.bip.commun.ValidityLineInformation;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.db.RBip_Jdbc;
import com.socgen.bip.rbip.batch.RBip;
import com.socgen.bip.rbip.commun.RBipConstants;
import com.socgen.bip.rbip.commun.erreur.RBipErreur;
import com.socgen.bip.rbip.commun.erreur.RBipErreurComparateur;
import com.socgen.bip.rbip.commun.erreur.RBipErreurConstants;
import com.socgen.bip.rbip.commun.erreur.RBipWarning;
import com.socgen.bip.rbip.commun.loader.RBipData;
import com.socgen.bip.rbip.commun.loader.RBipParser;
import com.socgen.bip.rbip.commun.loader.RBipStructureConstants;
import com.socgen.bip.rbip.commun.loader.RBipsComparateur;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.log.Log;

/**
 * @author X039435 / E.GREVREND
 * 
 *         la classe va s'occuper de faire tous les contrôles fonctionnels.
 */
public class RBipController implements RBipConstants, RBipErreurConstants, RBipStructureConstants {

	/**
	 * flag permettant de savoir si on a affaire à un fichier absence
	 */
	private boolean bAbsence;

	/**
	 * le PID de référence prend sa valeur du nom du fichier .<br>
	 */
	private String sPIDReference;
	/**
	 * dernier rectype valide rencontre (valide au sens ordre)
	 */
	private char cRecType;
	/**
	 * Vector dans lequel on va stoker les enregistrements En-Tête.<br>
	 * Dans un fichier valide il ne doit y en avoir qu'un seul.
	 */
	private Vector vEnTetes;
	/**
	 * Pour déterminer si les enregistrements sont dans le bon ordre on exclue les enregistrement mal ordonnés.<br>
	 * Par exemple on a une Activité avec ETS 010101, puis une autre avec ETS 010103, les 2 sont ok, iLastActivité pointe sur le ETS = 010104<br>
	 * Maintenant on a une Activité avec ETS=010102, elle est en erreur car sont ETS est inferieur a vActivites[iLastActivite]<br>
	 * Ensuite on aune Activite avec un ETS=010103, ont doit la rejeter car sont ETS est inférieure a l'ETS de la derniere Activite valide rencontree, c'est à dire clle pointée par
	 * iLastActivite<br>
	 * Dans le cas d'un Activite mal placée dans le fichier (par exemple apres une Allocation) cette Activite serait ajoutée a vActivite (comme toutes les Activités taritées) mais
	 * iLastActivité ne serait pas modifié.<br>
	 */
	private int iLastActivite;
	/**
	 * Liste des TOUTES les activités traitées (même celles qui ont généré des erreurs).
	 */
	private Vector vActivites;
	/**
	 * cf iLastActivite
	 */
	private int iLastAllocation;
	/**
	 * cf vActivites
	 */
	private Vector vAllocations;
	/**
	 * cf iLastActivite
	 */
	private int iLastConsomme;
	/**
	 * cf vActivités
	 */
	private Vector vConsommes;
	/**
	 * Liste des toutes les erreur générées, quelque soit leur origine (Activite, Allocation, ...)
	 */
	private Vector vErreurs;
	/**
	 * Liste des tous les warnings générées, quelque soit leur origine (Activite, Allocation, ...)
	 */
	private Vector vWarning;

	private Vector vRejetBips;

	private String prov;

	// flags de controle pour activite :
	// pour savoir si ETS courant > ETS precedant
	private int iEPrec;
	private int iNbEtape; // compte du nombre d'Etapes dans le fichier, sert
							// pour les fichiers Absence
	private String sTypeE;
	// pour le controle
	// "si une etape ne contient que des sstache et pas de taches alors T=0"
	// il faut pouvoir, si on rencontre une tache pour l'etape, mettre en erreur
	// les enregistrements qui avaient etes acceptes
	// car si on rencontre une tache, ce sera - a cause de l'odre des
	// enregistrement - apres avoir controle et accepte les ETS avec T=0
	// donc on met de cote les ETS qui ont un T=0 pour les rejeter si on
	// rencontre un T!=0
	// !!! RAZ a chaque changement de E
	private Vector vETS_RBipData = new Vector();
	boolean bTacheDansEtape = false;

	private Vector vTIRES = new Vector();

	public static String sRetour = "";

	public static String REJET = "REJET";

	public static String SANS_OBJET = "Sans objet";

	private static Log rBipLog = null;

	public RBipController() {
		sPIDReference = null;

		if (RBip_Jdbc.TOP == "INTRANET") {

			rBipLog = BipAction.logBipUser;

		} else {

			try {
				init();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				BipAction.logBipUser.error("Error. Check the code", e);
			}

		}

	}

	private void init() throws Exception {
		PropertyConfigurator.configure(cfgRbip.getString("log"));

		if (Logger.getLogger(RBIP_LOGGER).getAllAppenders() instanceof NullEnumeration) {
			throw new Exception("Echec de l'initialisation du logger");
		}

		rBipLog = new Log(RBIP_LOGGER);

	}

	// TOUTES les infos de vRBipData viennent du meme fichier, et RBipData a un
	// champ sFileName
	// PPM 60612 : modifier pour le cas de BIPS
	public void check(String sFileName, Vector vRBipData) {
		cRecType = ' ';
		iNbEtape = 0;
		iEPrec = -1;
		vEnTetes = new Vector();
		iLastActivite = -1;
		vActivites = new Vector();
		iLastAllocation = -1;
		vAllocations = new Vector();
		iLastConsomme = -1;
		vConsommes = new Vector();
		vErreurs = new Vector();
		vWarning = new Vector();

		RBipData rBipData = null;

		bAbsence = Tools.isProjetAbsence(sFileName);

		// Contrôle sur le PID, pour 0 le code ligne est inexistant
		// Pour la valeur 1 il suit le traitement normal
		if (Tools.isRBipPIDValid(Tools.getPIDFromFileName(sFileName)) == 0) {
			// erreur ...
			// Code ligne inexistant ...
			Vector vE = new Vector();
			vE.add(sFileName);
			addErreur(new RBipErreur(sFileName, 0, ERR_BAD_PID, vE));
		}

		// Premier Contrôle
		// le Vecteur de donnees de doit pas etre vide !!
		if (vRBipData.size() == 0) {
			// erreur
			addErreur(new RBipErreur(sFileName, 0, ERR_NODATA, null));
		}

		sPIDReference = Tools.getPIDFromFileName(sFileName);
		if (sPIDReference == null) {
			// erreur ...
			// normalement cette erreur aurait due etre detectee avant ...
			Vector vE = new Vector();
			vE.add(sFileName);
			addErreur(new RBipErreur(sFileName, 0, ERR_BAD_FILENAME, vE));
		}

		/*
		 * ServiceManager.getInstance().getLogManager().getLogService().debug( "SFilename : " + sFileName); ServiceManager.getInstance().getLogManager ().getLogService().debug(
		 * "SPIDref   : " + sPIDReference);
		 */

		for (int iPos = 0; iPos < vRBipData.size(); iPos++) {
			RBipEnTete rBipEnTete = null;
			rBipData = (RBipData) vRBipData.get(iPos);

			switch (((String) rBipData.getData(RECTYPE)).charAt(0)) {
			case (RECTYPE_ENTETE): {
				checkEnTete(rBipData);
				break;
			}
			case (RECTYPE_ACTIVITE): {
				checkActivite(rBipEnTete, rBipData);
				break;
			}
			case (RECTYPE_ALLOCATION): {
				checkAllocation(rBipData);
				break;
			}
			case (RECTYPE_CONSOMME): {
				checkConsomme(rBipData);
				break;
			}
			}
		}

		if ((vEnTetes.size() < 1) || (vActivites.size() < 1) || (vAllocations.size() < 1) || (vConsommes.size() < 1)) {
			addErreur(new RBipErreur(sFileName, 0, ERR_MISS_RECTYPE, null));
		}

		// S.EL PPM 60612
		Tools.supprimer_sr_si_existe(sPIDReference);

		Collections.sort(vErreurs, new RBipErreurComparateur());
		Collections.sort(vWarning, new RBipErreurComparateur());
	}

	// S.EL 60612
	// FIXME DHA method with about 1700 lines! Beyond 100, refactoring is very often required.
	public void checkBips(String sFileName, Vector<RBipData> vRBipData, UserBip userbip) throws Exception {
		vErreurs = new Vector();
		vWarning = new Vector();

		RBipData rBipData = null;
		RBipData rBipDataNext;
		RBipData rBipDataCoherence;
		RBipData rBipDataCoherenceNext = null;
		String sPidNext = "";// PID de la ligne suivante
		String listPidRejet = "";
		String listNumRejet = "";
		String[] tRetour = { "", "" };

		// SEL 6.11.2
		Vector<RBipData> vDataRemoveLe = new Vector(); // vecteur contenant les données à
		// rejeter quand la condition
		// "LE" n'est pas satisfaite

		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

		// Premier Contrôle
		// le Vecteur de donnees de doit pas etre vide !!
		if (vRBipData.size() == 0) {
			addErreur(new RBipErreur(sFileName, 0, ERR_NODATA, null));
		}
		/*
		 * on effectue le tri par : • Code ligne Bip, ascendant, • Numéro d'étape, ascendant, • Numéro de tâche, ascendant, • Numéro de sous-tâche, ascendant, • Date de début de
		 * période, ascendant, • Code ressource, ascendant.
		 */
		Collections.sort(vRBipData, new RBipsComparateur());

		boolean ctrl_coherence = false;
		CommonDataForRBipLineProcessing commonDataForRBipLineProcessing;
		try {
			commonDataForRBipLineProcessing = findCommonDataForRBipLineProcessing(userbip, vRBipData);
		}

		catch (Exception e) {
			BipAction.logBipUser.error("error durant l'appel à findCommonDataForRBipLineProcessing()", e);
			Vector<String> vE = new Vector<String>();
			addErreur(new RBipErreur(sFileName, 0, REJET_GLOBAL_TECHNIQUE, vE));
			return;
		}

		// Verifier la coherence des codes structures action
		rBipLog.info("DEBUT traitement coherence ");
		if (!ctrl_coherence) {

			ctrl_coherence = true;
			String listActions = "";
			for (int i = 1; i < vRBipData.size(); i++) {

				rBipDataCoherence = vRBipData.get(i);

				String sPid = (String) rBipDataCoherence.getData(LIGNE_BIP_CODE);
				String sCle = (String) rBipDataCoherence.getData(LIGNE_BIP_CLE);
				if (sPid == null)
					sPid = "";

				String action = (String) rBipDataCoherence.getData(STRUCTURE_ACTION);
				String pidNext = "";

				if (!listPidRejet.contains(sPid)) // le ligne BIP n'est pas
													// rejetée globalement
				{
					// Si le user n'est pas habilité sur la ligne, alors rejeter
					// tous le fichier
					String liste_cp = "";
					if (!"UNIX".equals(RBip_Jdbc.TOP)) {
						liste_cp = userbip.getChefProjet().toString().replace('[', ',').replace(']', ',');

					}

					// 1- Contrôle du code de la ligne Bip
					if (commonDataForRBipLineProcessing.isLigneInexistante(rBipDataCoherence)) {
						Vector<String> vE = new Vector<String>();
						vE.add(sPid);
						addErreur(new RBipErreur(sFileName, rBipDataCoherence.getNumLigne(), REJET_GLOBAL_BIPS_PID_INEXISTANTE, vE));
						listPidRejet += sPid + ";";
						continue;
					} else if ("intra".equals(this.prov) && commonDataForRBipLineProcessing.isStructureSr(sPid)) {
						// en mode intranet et la ligne possede une structure SR
						if (!commonDataForRBipLineProcessing.isCdpValide(sPid)) {
							Vector vE = new Vector();
							vE.add(sPid);
							addErreur(new RBipErreur(sFileName, rBipDataCoherence.getNumLigne(), REJET_GLOBAL_PID_HAB, vE));
							listPidRejet += sPid + ";";
							continue;
						}
					} 

					Integer iEtape = 0;
					Integer iTache = 0;
					Integer iSous_tache = 0;
					boolean bErrFormatEtape = false;
					boolean bErrFormatTache = false;
					boolean bErrFormatSTache = false;
					try {
						iEtape = RBipParser.parseInteger(rBipDataCoherence.getData(ETAPE_NUM).toString());
					} catch (Exception e) {
						bErrFormatEtape = true;
					}
					try {
						iTache = RBipParser.parseInteger(rBipDataCoherence.getData(TACHE_NUM).toString());
					} catch (Exception e) {
						bErrFormatTache = true;
					}
					try {
						iSous_tache = RBipParser.parseInteger(rBipDataCoherence.getData(STACHE_NUM).toString());
					} catch (Exception e) {
						bErrFormatSTache = true;
					}

					String sEtape = iEtape == 0 ? "00" : (iEtape < 10 ? "0".concat(iEtape.toString()) : iEtape.toString());
					String sTache = iTache == 0 ? "00" : (iTache < 10 ? "0".concat(iTache.toString()) : iTache.toString());
					;
					String sSous_tache = iSous_tache == 0 ? "00" : (iSous_tache < 10 ? "0".concat(iSous_tache.toString()) : iSous_tache.toString());
					;
					String sActivite = sEtape.concat(sTache).concat(sSous_tache);

					Integer iRess_code = 0;
					try {
						iRess_code = RBipParser.parseInteger(rBipDataCoherence.getData(RESS_BIP_CODE).toString());
					} catch (Exception e) {
						iRess_code = 0;
					}
					String sRess_code = iRess_code == 0 ? "" : iRess_code.toString();

					Date dDate_deb_conso = new Date();
					String sDate_deb_conso = "";

					try {
						dDate_deb_conso = (Date) rBipDataCoherence.getData(CONSO_DEB_DATE);
						sDate_deb_conso = new String(dateFormat.format(dDate_deb_conso));
					} catch (Exception e) {
						sDate_deb_conso = String.valueOf(rBipDataCoherence.getData(CONSO_DEB_DATE));
					}

					// 2- Contrôle du clé de la ligne Bip
					if (!Tools.isValidCle(sPid, sCle)) {
						Vector<String> vE = new Vector<String>();
						vE.add(sPid);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						addErreur(new RBipErreur(sFileName, rBipDataCoherence.getNumLigne(), REJET_BIPS_CLE, vE));
						continue;
					}

						/*BIP-355 Outsourcing not allowed for non-productive BIP Line- STARTS*/
						if(null != rBipDataCoherence.getData(STACHE_TYPE)) {
							//to check OutSourcing condition
							if (!commonDataForRBipLineProcessing.validFFbyLigneBipIdCheck(sPid, (String) rBipDataCoherence.getData(STACHE_TYPE))) {
								Vector<String> vE = new Vector<String>();
								vE.add(sPid);
								vE.add(sRess_code);
								vE.add(sActivite);
								vE.add(sDate_deb_conso);
								addErreur(new RBipErreur(sFileName,
										rBipDataCoherence.getNumLigne(),
										REJET_BIPS_NON_OUT_SOURCE, vE));
								//listPidRejet += sPid + ";";
								continue;
						}
					}
					/*BIP-355 Outsourcing not allowed for non-productive BIP Line- ENDS*/
						
						if(null != rBipDataCoherence.getData(CONSO_DEB_DATE)) {
							//to check OutSourcing condition
							if (!commonDataForRBipLineProcessing.retroDataCheck(rBipDataCoherence.getData(RESS_BIP_CODE).toString(),(Date)rBipDataCoherence.getData(CONSO_DEB_DATE))) {
								Vector<String> vE = new Vector<String>();
								vE.add(sPid);
								vE.add(sRess_code);
								vE.add(sActivite);
								vE.add(sDate_deb_conso);
								addErreur(new RBipErreur(sFileName,
										rBipDataCoherence.getNumLigne(),
										REJET_BIPS_NON_RETRO, vE));
								continue;
						}
					}

					if (!listActions.contains(action)) {
						listActions += action + ";";
					}

					if (i < vRBipData.size() - 1) {
						rBipDataCoherenceNext = (RBipData) vRBipData.get(i + 1);
						pidNext = (String) rBipDataCoherenceNext.getData(LIGNE_BIP_CODE);
					}

					if ((listActions.contains("LA") && (listActions.contains("AE") || listActions.contains("AF") || listActions.contains("LE")))
							|| (listActions.contains("LE") && (listActions.contains("AE") || listActions.contains("AF") || listActions.contains("LA")))) {
						Vector<String> vE = new Vector<String>();
						vE.add(sPid);
						addErreur(new RBipErreur(sFileName, rBipDataCoherence.getNumLigne(), REJET_GLOBAL_BIPS_STRUCT_ACTION, vE));
						listPidRejet += sPid + ";";
						listActions = "";
						vRBipData.remove(rBipDataCoherenceNext);
						continue;
					}

					if (!pidNext.equals(sPid)) {
						listActions = "";
					}

				}

			}
		}
		rBipLog.info("FIN traitement coherence ");
		Vector<RBipData> rBipDataRemove = new Vector<RBipData>();

		for (Iterator<RBipData> iterator = vRBipData.iterator(); iterator.hasNext();) {
			RBipData rBipDataDel = iterator.next();

			if (listPidRejet.contains(String.valueOf(rBipDataDel.getData(LIGNE_BIP_CODE)))) {
				rBipDataRemove.add(rBipDataDel);
			}

		}

		if (rBipDataRemove.size() > 0) {
			vRBipData.removeAll(rBipDataRemove);
		}

		// controle 1er niveau
		rBipLog.info("DEBUT controle 1er niveau ");

		// FAD PPM 64368 : Récupération d'un id unique pour le traitement en cours
		String numSeq = Tools.getNumSeq();
		// FAD PPM 64368 : Changer la limite existante pour rejeter l'enregistrement si le consommé est supérieur à 999,99 au lieu de 99999.99

		for (int iPos = 0; iPos < vRBipData.size(); iPos++) {
			// RBipEnTete rBipEnTete = null;
			rBipData = (RBipData) vRBipData.get(iPos);

			if (rBipData.getNumLigne() == 1) // PPM 60612 QC 1746
			{
				continue;
			}

			String idLigneBip = (String) rBipData.getData(LIGNE_BIP_CODE);

			if (rBipData.getNumLigne() > 1 && !listPidRejet.contains(idLigneBip)) {

				rBipLog.info("		controle 1er niveau ligne " + idLigneBip + "-" + rBipData.getData(ETAPE_NUM) + "-" + rBipData.getData(TACHE_NUM) + "-"
						+ rBipData.getData(STACHE_NUM) + "-" + rBipData.getData(RESS_BIP_CODE) + "-" + rBipData.getData(CONSO_DEB_DATE) + "-");

				String sCle = (String) rBipData.getData(LIGNE_BIP_CLE);
				if (idLigneBip == null)
					idLigneBip = "";
				if (sCle == null)
					sCle = "";

				String sSa = (String) rBipData.getData(STRUCTURE_ACTION).toString();

				Integer iEtape = 0;
				Integer iTache = 0;
				Integer iSous_tache = 0;
				boolean bErrFormatEtape = false;
				boolean bErrFormatTache = false;
				boolean bErrFormatSTache = false;
				try {
					iEtape = RBipParser.parseInteger(rBipData.getData(ETAPE_NUM).toString());
				} catch (Exception e) {
					bErrFormatEtape = true;
				}
				try {
					iTache = RBipParser.parseInteger(rBipData.getData(TACHE_NUM).toString());
				} catch (Exception e) {
					bErrFormatTache = true;
				}
				try {
					iSous_tache = RBipParser.parseInteger(rBipData.getData(STACHE_NUM).toString());
				} catch (Exception e) {
					bErrFormatSTache = true;
				}

				String sEtape = StringUtils.leftPad(String.valueOf(iEtape), 2, '0');
				String sTache = StringUtils.leftPad(String.valueOf(iTache), 2, '0');
				String sSous_tache = StringUtils.leftPad(String.valueOf(iSous_tache), 2, '0');
				String sActivite = sEtape.concat(sTache).concat(sSous_tache);

				Integer iRess_code = 0;
				try {
					iRess_code = RBipParser.parseInteger(rBipData.getData(RESS_BIP_CODE).toString());
				} catch (Exception e) {
					iRess_code = 0;
				}
				String sRess_code = iRess_code == 0 ? "" : iRess_code.toString();

				Date dDate_deb_conso = new Date();
				String sDate_deb_conso = "";

				try {
					dDate_deb_conso = (Date) rBipData.getData(CONSO_DEB_DATE);
					sDate_deb_conso = new String(dateFormat.format(dDate_deb_conso));
				} catch (Exception e) {
					sDate_deb_conso = String.valueOf(rBipData.getData(CONSO_DEB_DATE));
				}

				// 3- Contrôle des activités de ligne Bip (StructureAction)
				// toutes les activités de la Ligne doivent Exister
				rBipLog.info("DEBUT Contrôle des activités de ligne Bip (StructureAction) ");
				if ("LE".equals(sSa)) {

					for (int iPosNext = 1; iPosNext < vRBipData.size(); iPosNext++) {
						if (idLigneBip.equals((String) ((RBipData) vRBipData.get(iPosNext)).getData(LIGNE_BIP_CODE).toString())
								&& "LE".equals((String) ((RBipData) vRBipData.get(iPosNext)).getData(STRUCTURE_ACTION).toString())) {

							rBipDataNext = (RBipData) vRBipData.get(iPosNext);

							sPidNext = (String) rBipDataNext.getData(LIGNE_BIP_CODE).toString();

							sEtape = StringUtils.leftPad((String) rBipDataNext.getData(ETAPE_NUM).toString(), 2, '0');
							sTache = StringUtils.leftPad((String) rBipDataNext.getData(TACHE_NUM).toString(), 2, '0');
							sSous_tache = StringUtils.leftPad((String) rBipDataNext.getData(STACHE_NUM).toString(), 2, '0');

							if (!Tools.isValidActivite(idLigneBip, sEtape, sTache, sSous_tache)) {
								Vector<String> vE = new Vector<String>();
								vE.add(idLigneBip);
								vE.add(sRess_code);
								vE.add(sActivite);
								vE.add(sDate_deb_conso);
								// toutes les activité de la Ligne doivent
								// Exister
								addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_NUM_STACHE_INEXISTE, vE));
								listPidRejet += idLigneBip + ";";
								// break;
							}

							if (listPidRejet.contains(sPidNext)) {
								vDataRemoveLe.add(rBipDataNext);
							}

						}

					}

				} else
					// cette Activité doit Exister
					if ("AE".equals(sSa)) {
					// on vérfier si l'actvité de cette ligne existe, sinon
					// rejet uniquement sur cette ligne
					if (!Tools.isValidActivite(idLigneBip, sEtape, sTache, sSous_tache)) {
						Vector<String> vE = new Vector<String>();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_NUM_STACHE_INEXISTE, vE));
						continue;
					}
				} else
						// cette Activité est Facultative
						if ("AF".equals(sSa)) {

				} else
							// Annule et remplace de la Ligne
							if ("LA".equals(sSa)) {

				} else {
					// code non conforme
					Vector<String> vE = new Vector<String>();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_STRUCT_ACTION, vE));
					continue;

				}
				rBipLog.info("Fin Contrôle des activités de ligne Bip (StructureAction) ");

				if (listPidRejet.contains(idLigneBip)) {
					continue;
				}

				// 4-Contrôle du Numéro de l'étape
				rBipLog.info("Debut Contrôle du Numéro de l'étape ");
				if (iEtape < 1 || iEtape > 98 || bErrFormatEtape) {
					// Format erronée ou le numéro d'étape est hors plage
					// autorisée
					Vector<String> vE = new Vector<String>();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_NUM_ETAPE, vE));
					continue;
				}
				rBipLog.info("Fin Contrôle du Numéro de l'étape ");

				// 5-Contrôle du type d'étape
				rBipLog.info("Debut Contrôle du type d'étape ");
				String sType_etape = "";
				// vérification du format 2AN
				boolean bErrFormatTypeEtape = false;

				try {
					sType_etape = RBipParser.parseString((String) rBipData.getData(ETAPE_TYPE).toString());
				} catch (Exception e) {
					bErrFormatTypeEtape = true;
				}

				if (sType_etape.length() == 0 || sType_etape.length() > 2 || bErrFormatTypeEtape) {
					Vector<String> vE = new Vector<String>();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_TYPE_ETAPE_FORMAT, vE));
					continue;
				}

				String retour = Tools.isValidEtapeType(idLigneBip, sActivite, sType_etape, sSa);

				if ("REJET".equals(retour)) {
					// type d'étape est inconnu ou incompatible avec la ligne
					// Bip
					Vector<String> vE = new Vector<String>();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_TYPE_ETAPE_INCONNU, vE));
					continue;
				}
				/*
				 * else if (!"OK".equals(retour)) { rBipData.put(ETAPE_TYPE, retour); }
				 */
				rBipLog.info("Fin Contrôle du type d'étape ");
				// 6-Contrôle du Libellé d'étape
				rBipLog.info("Debut Contrôle du Libellé d'étape ");
				String sEtapeLibel = "";
				// vérification du format 2AN
				boolean bErrFormatEtapeLibel = false;

				try {
					sEtapeLibel = RBipParser.parseString((String) rBipData.getData(ETAPE_LIBEL).toString());
				} catch (Exception e) {
					bErrFormatEtapeLibel = true;
				}

				if (bErrFormatEtapeLibel || sEtapeLibel.length() == 0) {
					sEtapeLibel = sEtape;
				}

				if (!commonDataForRBipLineProcessing.isStructureSr(idLigneBip) && sEtapeLibel.length() > 15) {
					// warning : le libellé d'étape est trop long et sera
					// tronqué
					Vector<String> vE = new Vector<String>();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					// addErreur(new RBipErreur(sFileName,
					// rBipData.getNumLigne(), WARNING_BIPS_LIBELLE_ETAPE, vE));
					addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_LIBELLE_ETAPE, vE));
				}
				rBipLog.info("Debut Contrôle du numéro tâche ");
				// 7-Contrôle du numéro tâche
				if (iTache < 1 || iTache > 97 || bErrFormatTache) {
					// Format erronée ou le numéro de tâche est hors plage
					// autorisée
					Vector<String> vE = new Vector<String>();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_NUM_TACHE, vE));
					continue;
				}
				rBipLog.info("Fin Contrôle du numéro tâche ");
				// 8-Contrôle du libellé de tâche
				rBipLog.info("Debut Contrôle du libellé tâche ");
				String sTacheLibel = "";
				// vérification du format 30AN
				boolean bErrFormatTacheLibel = false;

				try {
					sTacheLibel = RBipParser.parseString((String) rBipData.getData(TACHE_LIBEL).toString());
				} catch (Exception e) {
					bErrFormatTacheLibel = true;
				}

				if (bErrFormatTacheLibel || sTacheLibel.length() == 0) {
					sTacheLibel = sTache;
				}

				if (!commonDataForRBipLineProcessing.isStructureSr(idLigneBip) && sTacheLibel.length() > 15) {
					// warning : le libellé de tâche est trop long et sera
					// tronqué
					Vector<String> vE = new Vector<String>();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					// addErreur(new RBipErreur(sFileName,
					// rBipData.getNumLigne(), WARNING_BIPS_LIBELLE_TACHE, vE));
					addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_LIBELLE_TACHE, vE));
				}
				rBipLog.info("Fin Contrôle du libellé tâche ");
				// SEL 6.11.2 - Controle sur le champ TacheAxeMetier
				rBipLog.info("Debut Controle sur le champ TacheAxeMetier ");
				String sTacheAxeMetier = "";

				// FIXME DHA Eviter les NullPointer
				try {

					Object dataAxeMetier = rBipData.getData(TACHE_AXE_METIER);

					if (dataAxeMetier == null) {
						sTacheAxeMetier = "";
					}

					else {
						String dataAxeMetierString = dataAxeMetier.toString();
						int limitString = 12;
						if (dataAxeMetierString.length() < limitString) {
							limitString = dataAxeMetierString.length();
						}
						sTacheAxeMetier = RBipParser.parseString(dataAxeMetierString).substring(0, limitString);
					}

					// if (dataAxeMetier.toString().length() > 12) {
					// sTacheAxeMetier = RBipParser.parseString((String) dataAxeMetier.toString()).substring(0, 12);
					// }
					//
					// else {
					// sTacheAxeMetier = RBipParser.parseString((String) dataAxeMetier.toString());
					// }

					// sRetour=Tools.verifier_tache_axe_metier(sTacheAxeMetier,sPid);
					// SEL QC 1811
					tRetour = Tools.verifier_tache_axe_metier_bips(sTacheAxeMetier, idLigneBip);
					/*if tRetour is in A,P or D chack DMP link at ligne level, if link at line is available change
					 * tRetour[0] to N <<Changes made for BIP-7- starts>>*/
					if(tRetour[0].equalsIgnoreCase("A") || tRetour[0].equalsIgnoreCase("P") || tRetour[0].equalsIgnoreCase("D")){
						String[] lineDmpLink = Tools.verifier_ligne_axe_metier_bips(idLigneBip);

						if(lineDmpLink[0].equalsIgnoreCase("LINK")){
							tRetour[0] = "N";
						}
					}		
					/*<<Changes made for BIP-7- ends>>*/

					if ("A".equals(tRetour[0])) {
						Vector<String> vE = new Vector<String>();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_TACHE_AXE_METIER_INCOHERENT, vE));
					} else if ("P".equals(tRetour[0])) {
						for (int i = 0; i < Integer.parseInt(tRetour[1]); i++) {
							Vector<String> vE = new Vector<String>();
							vE.add(idLigneBip);
							vE.add(sRess_code);
							vE.add(sActivite);
							vE.add(sDate_deb_conso);
							addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_TACHE_AXE_METIER_PROJET, vE));
						}
					} else if ("D".equals(tRetour[0])) {
						for (int i = 0; i < Integer.parseInt(tRetour[1]); i++) {
							Vector<String> vE = new Vector<String>();
							vE.add(idLigneBip);
							vE.add(sRess_code);
							vE.add(sActivite);
							vE.add(sDate_deb_conso);
							addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_TACHE_AXE_METIER_DPCOPI, vE));
						}
					}

					rBipData.put(TACHE_AXE_METIER, sTacheAxeMetier);

				} catch (Exception e) {
				}
				rBipLog.info("Fin Controle sur le champ TacheAxeMetier ");
				// 9-Contrôle du numéro de sous-tâche
				rBipLog.info("Debut Contrôle du numéro de sous-tâche ");
				if (iSous_tache < 1 || iSous_tache > 99 || bErrFormatSTache) {
					// Format erronée ou le numéro de sous-tâche est hors plage
					// autorisée
					Vector<String> vE = new Vector<String>();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_NUM_STACHE_FORMAT, vE));
					continue;
				}
				rBipLog.info("Fin Contrôle du numéro de sous-tâche ");
				// 10-Contrôle du Type de sous-tâche
				rBipLog.info("Debut Contrôle du Type de sous-tâche ");
				String sSTacheType = "";
				boolean bErrFormatSTacheType = false;
				try {
					String dataTacheType = (String) rBipData.getData(STACHE_TYPE.toString());
					if (dataTacheType != null) {
						sSTacheType = RBipParser.parseString(dataTacheType);
					}
				} catch (Exception e) {
					bErrFormatSTacheType = true;
				}
				// on récupère le code retour de contrôle du type de sous tâche
				String sMsgRetour = Tools.getRejetStacheType(idLigneBip, sSTacheType);
				// SI ligne productive : vide ou FFxxxx
				// Si la ligne est productive : la ligne Bip xxxx désignée par
				// FF est inexistante ou fermée
				
				
				//DHA
//				if ("REJET".equalsIgnoreCase(sMsgRetour) && !"".equalsIgnoreCase(sSTacheType) && sSTacheType.startsWith(RBipData.SOUS_TRAITANCE_PREFIX)) {
//					Vector<String> vE = new Vector<String>();
//					vE.add(idLigneBip);
//					vE.add(sRess_code);
//					vE.add(sActivite);
//					vE.add(sDate_deb_conso);
//					vE.add(sSTacheType.substring(2));// FFxxxx pour afficher le
//														// pid de la ligne xxxx
//					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_TYPE_STACHE_INEXISTE, vE));
//					continue;
//				}
				// Si la ligne est non productive : le type de sous-tâche non
				// productive est inconnu
				if ("REJET_ABSENCE".equalsIgnoreCase(sMsgRetour)) {
					Vector<String> vE = new Vector<String>();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_TYPE_STACHE_INCONNU, vE));
					continue;
				}

				// Si la ligne est productive : le type de sous-tâche productive
				// est inconnu
				if ("REJET_PRO_INCONNU".equalsIgnoreCase(sMsgRetour)) {
					Vector<String> vE = new Vector<String>();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_TYPE_STACHE_PRO_INCONNU, vE));
					continue;
				}
				rBipLog.info("Fin Contrôle du Type de sous-tâche ");
				// 11-Contrôle Libellé de la sous-tâche
				rBipLog.info("Debut Contrôle Libellé de la sous-tâche ");
				String sSTacheLibel = "";
				// vérification du format 30AN
				boolean bErrFormatSTacheLibel = false;

				try {
					sSTacheLibel = RBipParser.parseString((String) rBipData.getData(STACHE_LIBEL).toString());
				} catch (Exception e) {
					bErrFormatSTacheLibel = true;
				}

				if (bErrFormatSTacheLibel || sSTacheLibel.length() == 0) {
					sSTacheLibel = sSous_tache;
				}

				if (!commonDataForRBipLineProcessing.isStructureSr(idLigneBip) && sSTacheLibel.length() > 15) {
					// warning : le libellé de tâche est trop long et sera
					// tronqué
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					// addErreur(new RBipErreur(sFileName,
					// rBipData.getNumLigne(), WARNING_BIPS_LIBELLE_STACHE_LONG,
					// vE));
					addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_LIBELLE_STACHE_LONG, vE));
				}

				// si les deux chaines ne sont pas égaux, alors la chaine a été
				// modifiée
				if (!sSTacheLibel.equals(Tools.replaceCarSpec(sSTacheLibel))) {
					// warning : le libellé de sous-tâche a été modifié car il
					// comportait des car. interdits
					((RBipData) (vRBipData.get(iPos))).put(STACHE_LIBEL, Tools.replaceCarSpec(sSTacheLibel));
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					// addErreur(new RBipErreur(sFileName,
					// rBipData.getNumLigne(),
					// WARNING_BIPS_LIBELLE_STACHE_CAR_INTERDITS, vE));
					addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_LIBELLE_STACHE_CAR_INTERDITS, vE));

				}
				rBipLog.info("Fin Contrôle Libellé de la sous-tâche ");
				// 12-Contrôle de la Date initiale de début prévue
				rBipLog.info("Debut Contrôle de la Date initiale de début prévue ");
				Date dStacheInitDebDate = new Date();
				if (rBipData.getData(STACHE_INIT_DEB_DATE) != null) {
					boolean bErrStacheInitDebDate = false;
					try {
						dStacheInitDebDate = (Date) rBipData.getData(STACHE_INIT_DEB_DATE);
						dStacheInitDebDate = RBipParser.parseJJMMAAAADate(new String(dateFormat.format(dStacheInitDebDate)));
					} catch (Exception e) {
						bErrStacheInitDebDate = true;
					}
					String sStacheInitDebDate = new String(dateFormat.format(dStacheInitDebDate));
					if (bErrStacheInitDebDate || sStacheInitDebDate == null || "".equals(sStacheInitDebDate)) {
						// warning : la date initiale de début prévue est
						// invalide et ne sera pas prise en compte
						Vector vE = new Vector();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						// addErreur(new RBipErreur(sFileName,
						// rBipData.getNumLigne(),
						// WARNING_BIPS_STACHE_INIT_DEB_DATE_INVALIDE, vE));
						addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_STACHE_INIT_DEB_DATE_INVALIDE, vE));
						rBipData.put(STACHE_INIT_DEB_DATE, null);
					}
				}
				rBipLog.info("Fin Contrôle de la Date initiale de début prévue ");
				// 13-Contrôle de la Date initiale de fin prévue
				rBipLog.info("Debut Contrôle de la Date initiale de fin prévue ");
				Date dStacheInitFinDate = new Date();
				if (rBipData.getData(STACHE_INIT_FIN_DATE) != null) {
					boolean bErrStacheInitFinDate = false;
					try {
						dStacheInitFinDate = (Date) rBipData.getData(STACHE_INIT_FIN_DATE);
						dStacheInitFinDate = RBipParser.parseJJMMAAAADate(new String(dateFormat.format(dStacheInitFinDate)));
					} catch (Exception e) {
						bErrStacheInitFinDate = true;
					}
					String sStacheInitFinDate = new String(dateFormat.format(dStacheInitFinDate));
					if (bErrStacheInitFinDate || sStacheInitFinDate == null || "".equals(sStacheInitFinDate)
							|| (dStacheInitFinDate != null && dStacheInitDebDate.compareTo(dStacheInitFinDate) > 0)) {
						// warning : la date initiale de fin prévue est invalide
						// ou incohérente et ne sera pas prise en compte
						Vector vE = new Vector();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						// addErreur(new RBipErreur(sFileName,
						// rBipData.getNumLigne(),
						// WARNING_BIPS_STACHE_INIT_FIN_DATE_INVALIDE, vE));
						addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_STACHE_INIT_FIN_DATE_INVALIDE, vE));
						rBipData.put(STACHE_INIT_FIN_DATE, null);
					}
				}
				rBipLog.info("Fin Contrôle de la Date initiale de fin prévue ");
				// 14-Contrôle de la Date révisée ou réelle de début prévue
				rBipLog.info("Debut Contrôle de la Date révisée ou réelle de début prévue ");
				Date dStacheRevDebDate = new Date();
				if (rBipData.getData(STACHE_REV_DEB_DATE) != null) {
					boolean bErrStacheRevDebDate = false;
					try {
						dStacheRevDebDate = (Date) rBipData.getData(STACHE_REV_DEB_DATE);
						dStacheRevDebDate = RBipParser.parseJJMMAAAADate(new String(dateFormat.format(dStacheRevDebDate)));
					} catch (Exception e) {
						bErrStacheRevDebDate = true;
					}
					String sStacheRevDebDate = new String(dateFormat.format(dStacheRevDebDate));
					if (bErrStacheRevDebDate || sStacheRevDebDate == null || "".equals(sStacheRevDebDate)) {
						// warning : la date révisée de début prévue est
						// invalide et ne sera pas prise en compte
						Vector vE = new Vector();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						// addErreur(new RBipErreur(sFileName,
						// rBipData.getNumLigne(),
						// WARNING_BIPS_STACHE_REV_DEB_DATE_INVALIDE, vE));
						addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_STACHE_REV_DEB_DATE_INVALIDE, vE));
						rBipData.put(STACHE_REV_DEB_DATE, null);
					}
				}
				rBipLog.info("Fin Contrôle de la Date révisée ou réelle de début prévue ");
				// 15-Contrôle de la Date révisée ou réelle de fin prévue
				rBipLog.info("Debut Contrôle de la Date révisée ou réelle de fin prévue ");
				Date dStacheRevFinDate = new Date();
				if (rBipData.getData(STACHE_REV_FIN_DATE) != null) {
					boolean bErrStacheRevFinDate = false;
					try {
						dStacheRevFinDate = (Date) rBipData.getData(STACHE_REV_FIN_DATE);
						dStacheRevFinDate = RBipParser.parseJJMMAAAADate(new String(dateFormat.format(dStacheRevFinDate)));
					} catch (Exception e) {
						bErrStacheRevFinDate = true;
					}
					String sStacheRevFinDate = new String(dateFormat.format(dStacheRevFinDate));
					if (bErrStacheRevFinDate || sStacheRevFinDate == null || "".equals(sStacheRevFinDate)
							|| (dStacheRevFinDate != null && dStacheRevDebDate.compareTo(dStacheRevFinDate) > 0)) {
						// warning : la date révisée de fin prévue est invalide
						// ou incohérente et ne sera pas prise en compte
						Vector vE = new Vector();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						// addErreur(new RBipErreur(sFileName,
						// rBipData.getNumLigne(),
						// WARNING_BIPS_STACHE_REV_FIN_DATE_INVALIDE, vE));
						addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_STACHE_REV_FIN_DATE_INVALIDE, vE));
						rBipData.put(STACHE_REV_FIN_DATE, null);
					}
				}
				rBipLog.info("Fin Contrôle de la Date révisée ou réelle de fin prévue ");
				// 16-Contrôle du Statut local de la sous-tâche
				rBipLog.info("Debut Contrôle du Statut local de la sous-tâche ");
				// Aucun contrôle. Si non valorisée, pas d'action.
				String sStacheStatut = (String) rBipData.getData(STACHE_STATUT);

				// 17-Contrôle de la Durée de la sous-tâche en jours ouvrés
				Integer iStacheDuree = 0;
				if (rBipData.getData(STACHE_DUREE) != null) {
					boolean bErrStacheDuree = false;
					try {
						iStacheDuree = RBipParser.parseInteger(rBipData.getData(STACHE_DUREE).toString());
					} catch (Exception e) {
						bErrStacheDuree = true;
					}

					if (bErrStacheDuree || iStacheDuree < 0 || iStacheDuree > 99999) {
						// warning : la durée est invalide et ne sera pas prise
						// en compte
						Vector vE = new Vector();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						// addErreur(new RBipErreur(sFileName,
						// rBipData.getNumLigne(), WARNING_BIPS_STACHE_DUREE,
						// vE));
						addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_STACHE_DUREE, vE));
						rBipData.put(STACHE_DUREE, null);
					}
				}
				rBipLog.info("Fin Contrôle du Statut local de la sous-tâche ");
				// 18-Contrôle du Paramètre local de la sous-tâche
				rBipLog.info("Debut Contrôle du Paramètre local de la sous-tâche ");
				String sStacheParamLocal = "";
				if (rBipData.getData(STACHE_PARAM_LOCAL) != null) {
					boolean bErrStacheParamLocal = false;
					try {
						sStacheParamLocal = RBipParser.parseString((String) rBipData.getData(STACHE_PARAM_LOCAL));
					} catch (Exception e) {
						bErrStacheParamLocal = true;
					}
					String l_sStacheParamLocal = Tools.replaceCarSpecPar_(sStacheParamLocal);
					if (!sStacheParamLocal.equals(l_sStacheParamLocal)) {
						// warning : le paramètre local a été modifié en xxxxx
						// car il comportait des car. interdits
						Vector vE = new Vector();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						vE.add(l_sStacheParamLocal);
						// addErreur(new RBipErreur(sFileName,
						// rBipData.getNumLigne(),
						// WARNING_BIPS_STACHE_PLOCAL_CAR_INTERDITS, vE));
						addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_STACHE_PLOCAL_CAR_INTERDITS, vE));
						rBipData.put(STACHE_PARAM_LOCAL, l_sStacheParamLocal);
					}
				}
				rBipLog.info("Fin Contrôle du Paramètre local de la sous-tâche ");
				// 19-Contrôle du Code de la ressource qui impute
				rBipLog.info("Debut Contrôle du Code de la ressource qui impute ");
				Integer iRessCode = 0;
				String sRessBipCode = "";
				String sConsoDebDate = "";
				String sConsoFinDate = "";
				boolean bErrFormatRessBipCode = false;

				try {
					iRessCode = RBipParser.parseInteger(rBipData.getData(RESS_BIP_CODE).toString());

				} catch (Exception e) {
					bErrFormatRessBipCode = true;
				}

				if (rBipData.getData(CONSO_DEB_DATE) == null) {
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add("\"\"");
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_DEB_DATE_INVALIDE, vE));
					listNumRejet += rBipData.getNumLigne() + "-";
					continue;
				} else {

					try {

						Date dDateDebConso = (Date) rBipData.getData(CONSO_DEB_DATE);
						sConsoDebDate = new String(dateFormat.format(dDateDebConso));

						sConsoDebDate = RBipParser.parseString(sConsoDebDate);
					} catch (Exception e) {

						Vector vE = new Vector();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(rBipData.getData(CONSO_DEB_DATE));
						addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_DEB_DATE_INVALIDE, vE));
						listNumRejet += rBipData.getNumLigne() + "-";
						continue;
					}
				}

				if (rBipData.getData(CONSO_FIN_DATE) == null) {
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sConsoDebDate);
					vE.add("\"\"");
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_FIN_DATE_INVALIDE, vE));
					listNumRejet += rBipData.getNumLigne() + "-";
					continue;
				} else {
					try {
						Date dDateFinConso = (Date) rBipData.getData(CONSO_FIN_DATE);
						sConsoFinDate = new String(dateFormat.format(dDateFinConso));

						sConsoFinDate = RBipParser.parseString(sConsoFinDate);

					} catch (Exception e) {
						Vector vE = new Vector();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sConsoDebDate);
						vE.add(rBipData.getData(CONSO_FIN_DATE));
						addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_FIN_DATE_INVALIDE, vE));
						listNumRejet += rBipData.getNumLigne() + "-";
						continue;
					}
				}

				sRessBipCode = iRess_code == 0 ? "" : iRess_code.toString();
				// on récupère le code retour de contrôle du RessBipCode

				String sMsgRejetRessBipCode = Tools.getRejetRessBipCode(sRessBipCode, sConsoDebDate, sConsoFinDate);
				// Si le code ressource est inexistant
				if (bErrFormatRessBipCode || "REJET".equalsIgnoreCase(sMsgRejetRessBipCode)) {
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_RESS_CODE_INEXISTANT, vE));
					continue;
				}
				// Si pas de situation couvrant totalement la période de
				// consommé : avertissement
				if ("WARNING".equalsIgnoreCase(sMsgRejetRessBipCode)) {
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					// addErreur(new RBipErreur(sFileName,
					// rBipData.getNumLigne(), WARNING_BIPS_RESS_CODE_SITU,
					// vE));
					addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_RESS_CODE_SITU, vE));
				}
				rBipLog.info("Fin Contrôle du Code de la ressource qui impute ");
				// 20-Contrôle du Nom ou début du nom de la ressource
				rBipLog.info("Debut Contrôle du Nom ou début du nom de la ressource ");

				// isValidRessBipNom
				String sRessBipNom = "";
				if (rBipData.getData(RESS_BIP_NOM) != null) {
					boolean bErrRessBipNom = false;
					try {
						sRessBipNom = RBipParser.parseString((String) rBipData.getData(RESS_BIP_NOM));
					} catch (Exception e) {
						bErrRessBipNom = true;
					}

					// si le code ressource n'existe pas, alors c pas la peine
					// de chercher le nom associé à ce code
					if (bErrRessBipNom || (!"REJET".equalsIgnoreCase(sMsgRejetRessBipCode) && !Tools.isValidRessBipNom(sRessBipCode, sRessBipNom))) {
						// Rejet : la ressource n'a pas le même nom ou début de
						// nom en Bip
						Vector vE = new Vector();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_RESS_NOM, vE));
						continue;
					}

					String nomClair = Tools.replaceCarSpec(sRessBipNom);

					if (nomClair.equals(Tools.replaceCarSpec(sRessBipNom)) && !nomClair.equals(sRessBipNom)) {
						Vector vE = new Vector();
						vE.add(idLigneBip);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						vE.add(nomClair);
						// addErreur(new RBipErreur(sFileName,
						// rBipData.getNumLigne(), WARNING_BIPS_RESS_CODE_SITU,
						// vE));
						addWarning(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_RESS_NOM_COMP, vE));
						rBipData.put(RESS_BIP_NOM, nomClair.toUpperCase());
					}

				}
				rBipLog.info("Fin Contrôle du Nom ou début du nom de la ressource ");
				// 21-Contrôle de la Date de début de la période concernée
				rBipLog.info("Debut Contrôle de la Date de début de la période concernée ");
				Date dConsoDebDate = new Date();
				boolean bErrConsoDebDate = false;
				try {
					dConsoDebDate = (Date) rBipData.getData(CONSO_DEB_DATE);
					dConsoDebDate = RBipParser.parseJJMMAAAADate(new String(dateFormat.format(dConsoDebDate)));
					sConsoDebDate = new String(dateFormat.format(dConsoDebDate));
				} catch (Exception e) {
					bErrConsoDebDate = true;
				}

				if (bErrConsoDebDate /*
										 * !Tools.isValidConsoDebDate(sRessBipCode, sConsoDebDate)
										 */) {
					//
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(rBipData.getData(CONSO_DEB_DATE));
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_DEB_DATE_INVALIDE, vE));
					listNumRejet += rBipData.getNumLigne() + "-";
					continue;
				}
				rBipLog.info("Fin Contrôle de la Date de début de la période concernée ");
				// 22-Contrôle de la Date de fin de la période concernée à
				// l'intérieur du même mois
				rBipLog.info("Debut Contrôle de la Date de fin de la période concernée à l interieur ");
				Date dConsoFinDate = new Date();
				boolean bErrConsoFinDate = false;
				try {
					dConsoFinDate = (Date) rBipData.getData(CONSO_FIN_DATE);
					dConsoFinDate = RBipParser.parseJJMMAAAADate(new String(dateFormat.format(dConsoFinDate)));
					sConsoFinDate = new String(dateFormat.format(dConsoFinDate));
				} catch (Exception e) {
					bErrConsoFinDate = true;
				}
				if (bErrConsoFinDate || (dConsoDebDate != null && dConsoDebDate.compareTo(dConsoFinDate) > 0)) {
					// Rejet : la date de fin de période consommée JJ/MM/AAAA
					// est invalide ou incohérente
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					vE.add(rBipData.getData(CONSO_FIN_DATE));
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_FIN_DATE_INVALIDE, vE));
					continue;
				}
				if (!bErrConsoFinDate && dConsoDebDate != null && !compareConsoDate(dConsoDebDate, dConsoFinDate)) {
					// Rejet : la date de fin de période consommée JJ/MM/AAAA
					// est trop éloignée du début de période
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					vE.add(sConsoFinDate);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_FIN_DATE_ELOIGNEE, vE));
					continue;
				}
				// 23-Contrôle de la Quantité consommée sur la période
				Float fConsoQte = 0.0F;
				Float fConsoQteFormat = null;
				boolean bErrConsoQte = false;
				// fConsoQte =
				// RBipParser.parseDecimal((String)rBipData.getData(CONSO_QTE));
				try {
					fConsoQte = (Float) rBipData.getData(CONSO_QTE);
					BigDecimal bdConsoQte = new BigDecimal(fConsoQte);
					bdConsoQte = bdConsoQte.setScale(2, BigDecimal.ROUND_HALF_UP);
					fConsoQteFormat = bdConsoQte.floatValue();
				} catch (Exception e) {
					bErrConsoQte = true;
				}

				// FAD PPM 64368 : Changer la limite existante pour rejeter l'enregistrement si le consommé est supérieur à 999,99 au lieu de 99999.99
				// 0 à 2 décimales. Valeur comprise entre 0 et 999,99. Si
				// format ou valeur non conforme : rejet
				if (fConsoQte > 999.99F || fConsoQte < 0.0F || bErrConsoQte || !fConsoQteFormat.equals(fConsoQte)) {
					// la qté consommée est invalide
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_QTE_INVALIDE, vE));
					continue;
				}

				// FAD PPM 64368 : Insertion de la ligne en cours dans une table temporaire
				String structAction = (String) rBipData.getData(STRUCTURE_ACTION);
				Integer etapeNum = Integer.valueOf((String) rBipData.getData(ETAPE_NUM));
				Integer tacheNum = (Integer) rBipData.getData(TACHE_NUM);
				Integer stacheNum = (Integer) rBipData.getData(STACHE_NUM);
				Integer ressBip = (Integer) rBipData.getData(RESS_BIP_CODE);

				Tools.insererConsommationTmp(Integer.parseInt(numSeq), idLigneBip, structAction, etapeNum, tacheNum, stacheNum, sDate_deb_conso, sConsoFinDate, ressBip, fConsoQte);

				// FAD PPM 64368 : Contrôle de la capacité maximale attendue dans un mois et une année
				if (!Tools.consoMoisOk(Integer.parseInt(numSeq), idLigneBip, structAction, etapeNum, tacheNum, stacheNum, sDate_deb_conso, sConsoFinDate, ressBip, fConsoQte)) {
					// la qté consommée est invalide sur le mois
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_QTE_SR_MOIS, vE));
					continue;
				}

				if (!Tools.consoAnneeOK(Integer.parseInt(numSeq), idLigneBip, structAction, etapeNum, tacheNum, stacheNum, sDate_deb_conso, sConsoFinDate, ressBip, fConsoQte)) {
					// la qté consommée est invalide sur l'année
					Vector vE = new Vector();
					vE.add(idLigneBip);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_QTE_SR_ANNEE, vE));
					continue;
				}
				// FAD PPM 64368 : Fin

				rBipLog.info("Fin Contrôle de la Date de fin de la période concernée à l interieur ");
			}

		}

		// FAD PPM 64368 : Purge de la table temporaire
		Tools.purgeConsommationTmp(Integer.parseInt(numSeq));
		// FAD PPM 64368 : Fin

		vRBipData.removeAll(vDataRemoveLe);

		// Contrôle du 2ème niveau
		doControlesSecondNiveau(sFileName, vRBipData, listPidRejet, listNumRejet, dateFormat, commonDataForRBipLineProcessing);

		String listWarnings = "";
		Vector vWarningRemove = new Vector();
		for (Iterator iteratorW = vWarning.iterator(); iteratorW.hasNext();) {
			RBipWarning warning = (RBipWarning) iteratorW.next();

			for (Iterator iteratorE = vErreurs.iterator(); iteratorE.hasNext();) {
				RBipErreur erreur = (RBipErreur) iteratorE.next();

				if (warning.getNumLigne() == erreur.getNumLigne()) {
					vWarningRemove.add(warning);
				}

			}
		}

		vWarning.removeAll(vWarningRemove);

		// Fin KRA 16/04/2015 - PPM 60612
		Collections.sort(vErreurs, new RBipErreurComparateur());
		Collections.sort(vWarning, new RBipErreurComparateur());
	}

	private CommonDataForRBipLineProcessing findCommonDataForRBipLineProcessing(UserBip userbip, Vector<RBipData> rbipDataList) throws Exception {

		/*BIP-355 Outsourcing not allowed for non-productive BIP Line- STARTS*/
		Map <String,Set<String>> validFFbyLigneBipId = getOutSourcedData(rbipDataList);	
		/*BIP-355 Outsourcing not allowed for non-productive BIP Line- ENDS*/
		MonthAndYearFunctional monthAndYearFunctional = Tools.findMoisFonctionnel();
		Map<String,Set<Date>> retroIdentData = new HashMap<String,Set<Date>>();
		if (!((Arrays.asList(userbip.getSousMenus().toLowerCase().split(",")).contains("retro".toString()))&&(userbip.getsListeMenu().toLowerCase().contains("isacm")))) {
			retroIdentData = getRetroData(rbipDataList, monthAndYearFunctional);
		}
		Set<String> bipIdLignesToProcessSet = findUniqueLigneBipIdToProcess(rbipDataList);
		Set<String> bipIdLignesSousTraitancePlusIdLignesToProcess = new HashSet(bipIdLignesToProcessSet);
		bipIdLignesSousTraitancePlusIdLignesToProcess.addAll(findUniqueLigneBipSousTraitance(rbipDataList));

		// processing
		Set<String> lignesBipQuiSontDesStructureSR = Tools.getIdLigneBipQuiSontDesStructureSR(bipIdLignesToProcessSet);
		// Map<String, Boolean> mapIsValideCleByIdLigneBip = Tools.getMapOfIsValideCleByIdLigneBip(clesInputByIdLigneBip);
		Map<String, ValidityLineInformation> validityLinesInformationByidLigne = Tools.findValidityInformationForIdLigneBip(bipIdLignesSousTraitancePlusIdLignesToProcess);
		Set<String> idLignesBipAvecCDPValides = ToolsRBIPIntranetChannel.getInstance().findIdLignesBipAvecChefDeProjetValides(bipIdLignesToProcessSet, userbip.getChefProjet());

		CommonDataForRBipLineProcessing commonDataForRBipLineProcessing = new CommonDataForRBipLineProcessing.Builder().monthAndYearFunctional(monthAndYearFunctional)
				.idLignesBipAvecStructures(lignesBipQuiSontDesStructureSR).validityLinesInformationByidLigne(validityLinesInformationByidLigne)
				.idLignesBipAvecCdpValides(idLignesBipAvecCDPValides).validFFbyLigneBipId(validFFbyLigneBipId).retroData(retroIdentData).build();

		// commonDataForRBipLineProcessing.isValide("", "")
		return commonDataForRBipLineProcessing;
	}

	/*BIP-355 Outsourcing not allowed for non-productive BIP Line- STARTS*/
	private Map<String, Set<String>> getOutSourcedData(
			Vector<RBipData> rbipDataList) {
		
		Map <String,Set<String>> validFFbyLigneBipId = new HashMap<String, Set<String>>();		
		for (RBipData rbipData : rbipDataList) {
			if(null != rbipData.getData(STACHE_TYPE)){
				String stacheType = (String)rbipData.getData(STACHE_TYPE);
				
				if(validFFbyLigneBipId.containsKey((String)rbipData.getData(LIGNE_BIP_CODE))) {
					Set<String> stacheTypeSet = new HashSet<String>();
					stacheTypeSet.addAll(validFFbyLigneBipId.get((String)rbipData.getData(LIGNE_BIP_CODE)));
					stacheTypeSet.add(stacheType);
					validFFbyLigneBipId.remove((String)rbipData.getData(LIGNE_BIP_CODE));
					validFFbyLigneBipId.put((String)rbipData.getData(LIGNE_BIP_CODE), stacheTypeSet);;
				} else {
					Set<String> stacheTypeSet = new HashSet<String>();
					stacheTypeSet.add(stacheType);
					validFFbyLigneBipId.put((String)rbipData.getData(LIGNE_BIP_CODE), stacheTypeSet);
				}				
			}
		}		
		if(!validFFbyLigneBipId.isEmpty()){
			validFFbyLigneBipId = Tools.getOutSourcedData(validFFbyLigneBipId);
		}		
		return validFFbyLigneBipId;
	}
	/*BIP-355 Outsourcing not allowed for non-productive BIP Line- END*/
	
	
	/*Habilitation of retroactivite- STARTS*/
	private Map<String,Set<Date>> getRetroData(
			Vector<RBipData> rbipDataList, MonthAndYearFunctional monthAndYearFunctional) {

		Map<String,Set<Date>> uniqueIdent = new HashMap<String, Set<Date>>();
		for (RBipData rbipData : rbipDataList) {
			
			if(null != rbipData.getData(CONSO_DEB_DATE)){	
				LocalDate monthDate = Instant.ofEpochMilli(((Date) rbipData.getData(CONSO_DEB_DATE)).getTime()).atZone(ZoneId.systemDefault()).toLocalDate();
				if(monthDate.getMonthValue()< monthAndYearFunctional.getMonthFunctional()) {
					
					if(uniqueIdent.containsKey(rbipData.getData(RESS_BIP_CODE).toString())) {
						Set<Date> consoDateSet = new HashSet<Date>();
						consoDateSet.addAll(uniqueIdent.get(rbipData.getData(RESS_BIP_CODE).toString()));
						consoDateSet.add((Date) rbipData.getData(CONSO_DEB_DATE));
						uniqueIdent.remove(rbipData.getData(RESS_BIP_CODE).toString());
						uniqueIdent.put(rbipData.getData(RESS_BIP_CODE).toString(), consoDateSet);;
					} else {
						Set<Date> consoDateSet = new HashSet<Date>();
						consoDateSet.add((Date) rbipData.getData(CONSO_DEB_DATE));
						uniqueIdent.put(rbipData.getData(RESS_BIP_CODE).toString(), consoDateSet);
					}
				}
			}
		}
		
		if (!uniqueIdent.isEmpty()){
			uniqueIdent = Tools.checkRetroApplicativeParam(uniqueIdent);
		}
		return uniqueIdent;
	}
	/*Habilitation of retroactivite- END*/
	
	private Set<String> findUniqueLigneBipIdToProcess(Vector<RBipData> rbipDataList) {
		Set<String> bipIdSet = new HashSet<String>();
		for (RBipData rbipData : rbipDataList) {
			String id = (String) rbipData.getData(LIGNE_BIP_CODE);
			if (id != null) {
				bipIdSet.add(id);
			}
		}
		return bipIdSet;
	}

	private Set<String> findUniqueLigneBipSousTraitance(Vector<RBipData> rbipDataList) {
		Set<String> bipIdSet = new HashSet<String>();
		for (RBipData rbipData : rbipDataList) {
			boolean isSousTraitance = rbipData.isSousTraitance();
			if (isSousTraitance) {
				bipIdSet.add(rbipData.extractIdLigneBipFromSousTacheType());
			}
		}
		return bipIdSet;
	}

	private void doControlesSecondNiveau(String sFileName, Vector vRBipData, String listPidRejet, String listNumRejet, SimpleDateFormat dateFormat, CommonDataForRBipLineProcessing commonDataForRBipLineProcessing) {
		RBipData referenceRBipData;
		RBipData currentRBipData;
		String currentPid;
		rBipLog.info("Debut Contrôle du 2ème niveau");
		for (int positionInFor = 0; positionInFor < vRBipData.size(); positionInFor++) {
			RBipEnTete rBipEnTete = null;
			referenceRBipData = (RBipData) vRBipData.get(positionInFor);

			// rBipLog.info("positionInFor=" + positionInFor + "->" + referenceRBipData);

			if (referenceRBipData.getNumLigne() == 1) // PPM 60612 QC 1746
			{
				continue;
			}

			boolean bRejetActivite = false;
			boolean bRejetPeriode = false;
			String sConsoDebDate = "";

			String referencePid = (String) referenceRBipData.getData(LIGNE_BIP_CODE);

			if (referenceRBipData.getNumLigne() > 1 && !listPidRejet.contains(referencePid) && !listNumRejet.contains(String.valueOf(referenceRBipData.getNumLigne()))) {

				rBipLog.info("		controle 2ème niveau ligne " + referencePid + "-" + referenceRBipData.getData(ETAPE_NUM) + "-" + referenceRBipData.getData(TACHE_NUM) + "-"
						+ referenceRBipData.getData(STACHE_NUM) + "-" + referenceRBipData.getData(RESS_BIP_CODE) + "-" + referenceRBipData.getData(CONSO_DEB_DATE) + "-");

				if (referencePid == null)
					referencePid = "";
				String referenceActivite = Tools.getActivite(referenceRBipData);

				Date dDate_deb_conso = new Date();
				String sDate_deb_conso = "";

				try {
					dDate_deb_conso = (Date) referenceRBipData.getData(CONSO_DEB_DATE);
					sDate_deb_conso = new String(dateFormat.format(dDate_deb_conso));
				} catch (Exception e) {
					sDate_deb_conso = referenceRBipData.getData(CONSO_DEB_DATE).toString();
				}

				// String sRess_code =
				// (String)rBipData.getData(RESS_BIP_CODE).toString();
				Integer iRess_code = 0;
				try {
					iRess_code = RBipParser.parseInteger(referenceRBipData.getData(RESS_BIP_CODE).toString());
				} catch (Exception e) {
					iRess_code = 0;
				}
				String sRess_code = iRess_code == 0 ? "" : iRess_code.toString();

				// s'il y a encore des lignes, on peut vérifier si la ligne
				// suivante a le même PID
				if (positionInFor < vRBipData.size() - 1) {
					// on initialise le curseur par le numéro de la ligne
					// suivante
					int positionInWhile = positionInFor + 1;
					currentRBipData = (RBipData) vRBipData.get(positionInWhile);
					currentPid = (String) currentRBipData.getData(LIGNE_BIP_CODE);
					if (currentPid == null)
						currentPid = "";
					while (positionInWhile < vRBipData.size() && referencePid.equals(currentPid)) {
						// on récupère le PID de la ligne suivante
						currentRBipData = (RBipData) vRBipData.get(positionInWhile);

						// rBipLog.info("positionInWhile=" + positionInWhile + "->" + currentRBipData);

						currentPid = (String) currentRBipData.getData(LIGNE_BIP_CODE);
						if (currentPid == null)
							currentPid = "";
						// on recupère l'activité de la ligne suivante
						String sActiviteNext = Tools.getActivite(currentRBipData);
						Date dDate_deb_consoNext = new Date();

						Date dConsoDebDate = new Date();
						try {
							dDate_deb_consoNext = (Date) currentRBipData.getData(CONSO_DEB_DATE);
							dDate_deb_consoNext = RBipParser.parseJJMMAAAADate(new String(dateFormat.format(dDate_deb_consoNext)));
							sConsoDebDate = new String(dateFormat.format(dDate_deb_consoNext));
						} catch (Exception e) {
							BipAction.logBipUser.warning("erreur lors de la récupération de la donnée CONSO_DEB_DATE. Caused by :" + e.getMessage());
							positionInWhile++;
							continue;
						}

						String sDate_deb_consoNext = new String(dateFormat.format(dDate_deb_consoNext));
						// String sRess_codeNext =
						// (String)rBipDataNext.getData(RESS_BIP_CODE);
						Integer iRess_codeNext = 0;
						try {
							iRess_codeNext = RBipParser.parseInteger(currentRBipData.getData(RESS_BIP_CODE).toString());
						} catch (Exception e) {
							iRess_codeNext = 0;
						}
						String sRess_codeNext = iRess_codeNext == 0 ? "" : iRess_codeNext.toString();
						if (sRess_codeNext == null)
							sRess_codeNext = "";

						if (referenceActivite.equals(sActiviteNext) && sDate_deb_conso.equals(sDate_deb_consoNext) && sRess_code.equals(sRess_codeNext)
								&& referencePid.equals(currentPid)) {
							// REJET GLOBAL pour la ligne xxxx, ressource nnnn,
							// activité nnnnn et début de période consommée
							// JJ/MM/AAAA,
							// car il y a des doublons sur ces critères
							if (!bRejetActivite) { // si la ligne n'a pas été
													// déjà rejetée
								Vector vE = new Vector();
								vE.add(referencePid);
								vE.add(sRess_code);
								vE.add(referenceActivite);
								vE.add(sDate_deb_conso);
								addErreur(new RBipErreur(sFileName, referenceRBipData.getNumLigne(), REJET_GLOBAL_BIPS_ACTIVITE_DOUBLONS, vE));
								bRejetActivite = true;

								vRBipData.remove(currentRBipData);
								Vector vWarningRemove = new Vector();
								for (Iterator iterator = vWarning.iterator(); iterator.hasNext();) {
									RBipWarning rBipWarning = (RBipWarning) iterator.next();
									if (rBipWarning.getNumLigne() == currentRBipData.getNumLigne()) {
										vWarningRemove.add(rBipWarning);
									}
									if (rBipWarning.getNumLigne() == referenceRBipData.getNumLigne()) {
										vWarningRemove.add(rBipWarning);
									}
								}
								vWarning.removeAll(vWarningRemove);
								break;
							}
						} else if (referenceActivite.equals(sActiviteNext) && sRess_code.equals(sRess_codeNext) && referencePid.equals(currentPid)) {
							Date dDate_fin_conso;
							String sDate_fin_conso;
							try {
								dDate_fin_conso = (Date) referenceRBipData.getData(CONSO_FIN_DATE);
								sDate_fin_conso = new String(dateFormat.format(dDate_fin_conso));
							} catch (Exception e1) {
								positionInWhile++;
								continue;
							}

							Date dDate_fin_consoNext;
							try {
								dDate_fin_consoNext = (Date) currentRBipData.getData(CONSO_FIN_DATE);
							} catch (Exception e) {
								positionInWhile++;
								continue;
							}
							if ((dDate_deb_consoNext.after(dDate_deb_conso) && dDate_deb_consoNext.before(dDate_fin_conso))
									|| (dDate_deb_consoNext.before(dDate_deb_conso) && dDate_fin_consoNext.after(dDate_deb_conso))
									|| (dDate_deb_consoNext.equals(dDate_deb_conso))) {
								// REJET GLOBAL pour la ligne xxxx, ressource
								// nnnn, activité nnnnn,
								// le début de période consommée JJ/MM/AAAA et
								// la fin de période consommée JJ/MM/AAAA, car
								// des périodes sont en doublon ou se
								// chevauchent
								if (!bRejetPeriode) {// pour ne pas rejeter la
														// ligne plusieurs fois
														// (un seul rejet global
														// pour une ligne)
									Vector vE = new Vector();
									vE.add(referencePid);
									vE.add(sRess_code);
									vE.add(referenceActivite);
									vE.add(sDate_deb_conso);
									vE.add(sDate_fin_conso);
									addErreur(new RBipErreur(sFileName, referenceRBipData.getNumLigne(), REJET_GLOBAL_BIPS_PERIODE_DOUBLONS, vE));
									bRejetPeriode = true;

									vRBipData.remove(currentRBipData);
									Vector vWarningRemove = new Vector();
									for (Iterator iterator = vWarning.iterator(); iterator.hasNext();) {
										RBipWarning rBipWarning = (RBipWarning) iterator.next();
										if (rBipWarning.getNumLigne() == currentRBipData.getNumLigne()) {
											vWarningRemove.add(rBipWarning);
										}
										if (rBipWarning.getNumLigne() == referenceRBipData.getNumLigne()) {
											vWarningRemove.add(rBipWarning);
										}
									}
									vWarning.removeAll(vWarningRemove);
									Vector vErreurRemove = new Vector();
									for (Iterator iterator = vErreurs.iterator(); iterator.hasNext();) {
										RBipErreur rBipErreur = (RBipErreur) iterator.next();
										if (rBipErreur.getNumLigne() == currentRBipData.getNumLigne()) {
											vErreurRemove.add(rBipErreur);
										}
										/*
										 * if (rBipErreur.getNumLigne() == rBipData.getNumLigne()) { vErreurRemove.add(rBipErreur); }
										 */
									}
									vErreurs.removeAll(vErreurRemove);
									break;
									// continue;
								}
							}
						}
						// on incrémente le curseur
						positionInWhile++;
					}
				}
				try {
					// Si mention d'une période de consommé antérieure au 1er
					// janvier de l'année fonctionnelle, alors rejet
					if (Tools.isPeriodeAnterieureAnneeFonct(sDate_deb_conso)) {
						// la période indiquée est antérieure à l'année
						// fonctionnelle en cours
						Vector vE = new Vector();
						vE.add(referencePid);
						vE.add(sRess_code);
						vE.add(referenceActivite);
						vE.add(sDate_deb_conso);
						addErreur(new RBipErreur(sFileName, referenceRBipData.getNumLigne(), REJET_BIPS_PERIODE_ANTERIEURE, vE));
						continue;
					}
				} catch (Exception e) {
					Vector vE = new Vector();
					vE.add(referencePid);
					vE.add(sRess_code);
					vE.add(referenceActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, referenceRBipData.getNumLigne(), REJET_BIPS_CONSO_DEB_DATE_INVALIDE, vE));
					continue;
				}

				try {
					// Si mention d'une période de consommé ultérieure au mois
					// fonctionnel en cours, alors
					String result = Tools.isPeriodeUlterieureMoisFonct(sDate_deb_conso, referencePid);

					// si result = null ou vide, alors la période est ultérieure
					// au mois fonctionnel en cours
					if (!"".equals(result) && result != null) {
						// SI la ligne Bip n'est pas gérée en structure SR,
						// alors REJET
						if ("REJET".equals(result)) {
							// la période indiquée est dans le futur et ne peut
							// donc pas encore être traitée
							Vector vE = new Vector();
							vE.add(referencePid);
							vE.add(sRess_code);
							vE.add(referenceActivite);
							vE.add(sDate_deb_conso);
							addErreur(new RBipErreur(sFileName, referenceRBipData.getNumLigne(), REJET_BIPS_PERIODE_ULTERIEURE, vE));
							continue;
						}

					}
				} catch (Exception e) {
					Vector vE = new Vector();
					vE.add(referencePid);
					vE.add(sRess_code);
					vE.add(referenceActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, referenceRBipData.getNumLigne(), REJET_BIPS_CONSO_DEB_DATE_INVALIDE, vE));
					continue;
				}

				try {// SEL PPM 62605
						// Si mention d'une période de consommé ultérieure à
						// l'année fonctionnelle en cours, alors
					String result = Tools.isPeriodeUlterieureAnneeFonct(sDate_deb_conso, referencePid);

					// si result = REJET, alors la période est ultérieure à
					// l'année fonctionnelle en cours
					if ("REJET".equals(result)) {
						// la période indiquée est dans le futur et ne peut donc
						// pas encore être traitée
						Vector vE = new Vector();
						vE.add(referencePid);
						vE.add(sRess_code);
						vE.add(referenceActivite);
						vE.add(sDate_deb_conso);
						addErreur(new RBipErreur(sFileName, referenceRBipData.getNumLigne(), REJET_BIPS_ANNEE_ULTERIEURE, vE));
						continue;
					}
				} catch (Exception e) {
					Vector vE = new Vector();
					vE.add(referencePid);
					vE.add(sRess_code);
					vE.add(referenceActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, referenceRBipData.getNumLigne(), REJET_BIPS_CONSO_DEB_DATE_INVALIDE, vE));
					continue;
				}
				
				// DHA
				
				if (commonDataForRBipLineProcessing.isLigneBipFermee(referenceRBipData)){
					Vector vE = new Vector();
					vE.add(referencePid);
					vE.add(sRess_code);
					vE.add(referenceActivite);
					vE.add(sDate_deb_conso);
					addErreur(new RBipErreur(sFileName, referenceRBipData.getNumLigne(), REJET_GLOBAL_BIPS_PID_FERMEE, vE));
				}
				
				boolean isLigneBipFFInexistante = commonDataForRBipLineProcessing.isLigneBipFFInexistante(referenceRBipData);
				if (isLigneBipFFInexistante){
					Vector vE = new Vector();
					vE.add(referencePid);
					vE.add(sRess_code);
					vE.add(referenceActivite);
					vE.add(sDate_deb_conso);
					vE.add(referenceRBipData.extractIdLigneBipFromSousTacheType());
					addErreur(new RBipErreur(sFileName, referenceRBipData.getNumLigne(), REJET_BIPS_PID_FF_INEXISTANTE, vE));
				}
				
				
				if (!isLigneBipFFInexistante && commonDataForRBipLineProcessing.isLigneBipFFFermee(referenceRBipData)){
					Vector vE = new Vector();
					vE.add(referencePid);
					vE.add(sRess_code);
					vE.add(referenceActivite);
					vE.add(sDate_deb_conso);
					vE.add(referenceRBipData.extractIdLigneBipFromSousTacheType());
					addErreur(new RBipErreur(sFileName, referenceRBipData.getNumLigne(), REJET_BIPS_PID_FF_FERMEE, vE));
				}
				

			}
		}

		rBipLog.info("Fin Contrôle du 2ème niveau");
	}

	/**
	 * @param dConsoDebDate
	 * @param dConsoFinDate
	 * @return
	 */
	private boolean compareConsoDate(Date dConsoDebDate, Date dConsoFinDate) {

		Calendar c = Calendar.getInstance();
		c.setTime(dConsoDebDate);
		int anneeDeb = c.get(Calendar.YEAR);
		int moisDeb = c.get(Calendar.MONTH);
		c = Calendar.getInstance();
		c.setTime(dConsoFinDate);
		int anneeFin = c.get(Calendar.YEAR);
		int moisFin = c.get(Calendar.MONTH);

		if (anneeDeb == anneeFin) {

			if (moisDeb == moisFin) {
				return true;
			}
		}

		return false;
	}

	// return le PID
	private void checkEnTete(RBipData rBipData) {
		// vecteur utilise pour la gestion des erreurs
		Vector vE;
		RBipEnTete rBipET = new RBipEnTete((String) rBipData.getData(PID), (String) rBipData.getData(A_CLE), (Date) rBipData.getData(A_DCREATION));
		vEnTetes.add(rBipET);

		if (vEnTetes.size() > 1) {
			// Un EnTete a deja ete trouve !
			addErreur(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), A_ERR_UNIQUE, null));
		} else if (rBipData.getNumLigne() != 1) {
			// l'entete doit etre en premiere position dans le fichier
			addErreur(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), A_ERR_PREM, null));
		} else {
			// rBipEnTete = rBipET;
			cRecType = RECTYPE_ENTETE;
		}

		String sPID;
		Date dCreation;

		if (!sPIDReference.equals(rBipET.getPID())) {
			vE = new Vector();
			vE.add(rBipET.getPID());
			vE.add(sPIDReference);
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), A_ERR_BAD_PID, vE));
		}

		// controle de la cle
		if (!rBipET.getCle().equals(Tools.getClePID(rBipET.getPID()))) {
			vE = new Vector();
			vE.add(rBipET.getCle());
			vE.add(rBipET.getPID());
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), A_ERR_BAD_CLE, vE));
		}
	}

	private void checkActivite(RBipEnTete rBipEnTete, RBipData rBipData) {
		Vector vE;
		String sETS;

		RBipActivite rBipActivite = new RBipActivite((Integer) rBipData.getData(NUM_ETAPE), (Integer) rBipData.getData(NUM_TACHE), (Integer) rBipData.getData(NUM_SSTA),
				(String) rBipData.getData(ETS), (String) rBipData.getData(TYPE_ETAPE), (String) rBipData.getData(TYPE_SSTACHE), (Date) rBipData.getData(DATE_DEB_INI),
				(Date) rBipData.getData(DATE_FIN_INI), (Date) rBipData.getData(DATE_DEB_REV), (Date) rBipData.getData(DATE_FIN_REV), (String) rBipData.getData(NOM_SSTA),
				(Integer) rBipData.getData(POURCENTAGE), (Integer) rBipData.getData(NB_JOURS));

		vActivites.add(rBipActivite);

		// 1 - si premier enr, pas normal
		if (rBipData.getNumLigne() == 1) {
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_A_FIRST, null));

		} // test si rectype bien dans ordre A G I J
		else if ((cRecType != RECTYPE_ENTETE) && (cRecType != RECTYPE_ACTIVITE)) {
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_AGIJ, null));
		} else {
			cRecType = RECTYPE_ACTIVITE;
		}

		// controle du PID
		if (!((String) rBipData.getData(PID)).equals(sPIDReference)) {
			vE = new Vector();
			vE.add(rBipData.getData(PID));
			vE.add(sPIDReference);
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_BAD_PID, vE));
		}

		sETS = (String) rBipData.getData(ETS);

		// test ETS valide
		// ETS courant > ETS prec
		// test doublon
		String sETSPrec;
		if (iLastActivite >= 0) {
			sETSPrec = ((RBipActivite) vActivites.get(iLastActivite)).getETS();
		} else {
			sETSPrec = "";
		}

		if (sETS.equals(sETSPrec)) {
			vE = new Vector();
			vE.add(sETS);
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_ETS_UNIQUE, vE));
		} else if (sETS.compareTo("" + sETSPrec) < 0) {
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_ETS_ORDRE, null));
		} else {
			iLastActivite = vActivites.size() - 1;
		}

		// changement d'etape, on vide la liste des ETS qui ont une Tache=0, on
		// marque l'etape en cours et son type
		if (iEPrec != ((Integer) rBipData.getData(NUM_ETAPE)).intValue()) {
			vETS_RBipData.clear();
			iEPrec = rBipActivite.getNumEtape().intValue();
			sTypeE = rBipActivite.getTypeEtape();
			iNbEtape++;
			bTacheDansEtape = false;

		}

		// 0<E<99
		// 0<=T<98 si que des sstache et pas de taches pour l'etape
		// 0<T<98 sinon
		// O<S<100
		int iVal;

		iVal = rBipActivite.getNumEtape().intValue();
		if ((iVal == 0) || (iVal > 98)) {
			// erreur 0<E<99
			vE = new Vector();
			vE.add(new Integer(iVal).toString());
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_ETS_E, vE));
		}

		// Une tache peut etre a 0 ssi il n'y a que des sstache pour l'etape
		// courante
		iVal = rBipActivite.getNumTache().intValue();
		if (iVal == 0) {
			if (bTacheDansEtape) {
				vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_ETS_T_00, null));
			} else {
				vETS_RBipData.add(rBipData);
			}
		} else {
			bTacheDansEtape = true;
			for (int i = 0; i < vETS_RBipData.size(); i++) {
				// on rencontre une tache pour l'etape alors qu'il y a eu des
				// sstache sans etapes
				// regle
				// "si une etape ne contient que des sstache et pas de taches alors T=0"
				// il faut rejeter les ETS qui avaient une Tache=0
				RBipData rBipD;
				rBipD = (RBipData) vETS_RBipData.get(i);
				vErreurs.add(new RBipErreur(rBipD.getFileName(), rBipD.getNumLigne(), G_ERR_ETS_T_00, null));
			}
			// vETS_Activites.clear();
			vETS_RBipData.clear();
		}

		if (iVal > 97) {
			// erreur T>97
			vE = new Vector();
			vE.add(new Integer(iVal).toString());
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_ETS_T_MAX, vE));
		}

		iVal = rBipActivite.getNumSSTache().intValue();
		if ((iVal == 0) || (iVal > 99)) {
			// erreur 0<S<100
			vE = new Vector();
			vE.add(new Integer(iVal).toString());
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_ETS_S, vE));
		}

		if (!rBipActivite.getTypeEtape().equals(sTypeE)) {
			vE = new Vector();
			vE.add(rBipActivite.getTypeEtape());
			vE.add(sTypeE);
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_TYPE_ETAPE, vE));
		}

		if (bAbsence) {
			if (!rBipActivite.getTypeEtape().equals(PACTE_ES)) {
				vE = new Vector();
				vE.add(PACTE_ES);
				vE.add(rBipActivite.getTypeEtape());
				vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_AB_TYPE_ETAPE, vE));
			} else if (!Tools.isTypeSSTacheAB(rBipActivite.getTypeSSTache())) {
				// absence et ES => type sstache dans liste des ident d'absences
				vE = new Vector();
				vE.add(PACTE_ES);
				vE.add(rBipActivite.getTypeSSTache());
				vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_AB_TYPE_SSTACHE, vE));
			}
			if (iNbEtape > 1) // une seule etape ES pour fichier absence
			{
				vE = new Vector();
				vE.add(PACTE_ES);
				vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_AB_NB_ETAPE, vE));
			}

		} else {

			// SEL PPM 60709 5.4

			String sVerifTypeEtape = Tools.isValidEtapeType((String) rBipData.getData(PID), sETS, rBipActivite.getTypeEtape(), "LA");
			// (String) rBipData.getData(PID));

			if (REJET.equals(sVerifTypeEtape)) {
				vE = new Vector();
				vE.add((String) rBipData.getData(PID));
				vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_TYPE_ETAPE_NO, vE));
			}
			// si pas type absence
			// type etape dans ETAPES_PACTE, c'est deja le cas, sinon le
			// controle aurait ete arrete aux controles elementaires
			// si pas ES => on autorise typeSST HEUSUP, EN , blanc, FF****,
			// DF****, FC****, DC****
			// si ES , TypeSST != blanc, TypeSST = FM , EN ou ST
			if (PACTE_ES.equals(rBipActivite.getTypeEtape())) {
				if (rBipActivite.getTypeSSTache().equals(SSTACHE_BLANC)) {
					// erreur
					vE = new Vector();
					vE.add(PACTE_ES);
					vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_ES_TYPE_SSTACHE_BLANC, vE));
				} else if (!Tools.isTypeSSTacheES(rBipActivite.getTypeSSTache())) {
					// erreur
					vE = new Vector();
					vE.add(PACTE_ES);
					vE.add(rBipActivite.getTypeSSTache());
					vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_ES_TYPE_SSTACHE, vE));
				}
			} else {
				if (!Tools.isTypeSSTacheSansPID(rBipActivite.getTypeSSTache())) {
					if (!Tools.isTypeSSTachePIDProjet(rBipActivite.getTypeSSTache())) {
						if (!Tools.isTypeSSTachePID(rBipActivite.getTypeSSTache())) {
							// erreur
							vE = new Vector();
							vE.add(rBipActivite.getTypeSSTache());
							vE.add(PACTE_ES);
							vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_NES_TYPE_SSTACHE, vE));
						}
					} else if (!Tools.getPIDFromTypeSSTache(rBipActivite.getTypeSSTache()).equals(sPIDReference)) {
						// le PID specifie dans le type de sous tache doit etre
						// celui du PID de reference
						// erreur
						vE = new Vector();
						vE.add(rBipActivite.getTypeSSTache());
						vE.add(sPIDReference);
						vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), G_ERR_NES_TYPE_SSTACHE_PID, vE));
					}
				}
			}
		}
	}

	private void checkAllocation(RBipData rBipData) {
		Vector vE;
		RBipActivite rBipA;

		rBipA = getActivite((String) rBipData.getData(ETS));

		RBipAllocation rBipAllocation = new RBipAllocation( /* rBipA, */
				(Integer) rBipData.getData(NUM_ETAPE), (Integer) rBipData.getData(NUM_TACHE), (Integer) rBipData.getData(NUM_SSTA), (String) rBipData.getData(ETS),
				(String) rBipData.getData(TIRES), (Double) rBipData.getData(CHARGE_PLANIFIEE), (Double) rBipData.getData(CHARGE_CONSOMMEE), (Double) rBipData.getData(CHARGE_RAF));
		vAllocations.add(rBipAllocation);

		// 1 - si premier enr, pas normal
		if (rBipData.getNumLigne() == 1) {
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), I_ERR_A_FIRST, null));
		} // test si rectype bien dans ordre A G I J
		else if ((cRecType != RECTYPE_ACTIVITE) && (cRecType != RECTYPE_ALLOCATION)) {
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), I_ERR_AGIJ, null));
		} else {
			cRecType = RECTYPE_ALLOCATION;
		}

		// controle du PID
		if (!((String) rBipData.getData(PID)).equals(sPIDReference)) {
			vE = new Vector();
			vE.add(rBipData.getData(PID));
			vE.add(sPIDReference);
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), I_ERR_BAD_PID, vE));
		}

		if (rBipA == null) {
			// pas d'activite avec meme ETS
			// erreur
			vE = new Vector();
			vE.add(rBipAllocation.getETS());
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), I_ERR_REF_ACTIVITE, vE));
		}
		// les alloc sont ordonnees par ETS
		String sETSPrec;
		if (iLastAllocation >= 0) {
			sETSPrec = ((RBipAllocation) vAllocations.get(iLastAllocation)).getETS();
		} else {
			sETSPrec = "";
		}

		if (rBipAllocation.getETS().equals(sETSPrec)) {
			for (int i = 0; i < vTIRES.size(); i++) {
				// une et une seule alloc pour ETS+tires (plusieurs tires pour
				// un ETS, mais tires uniques
				// la ressource ne doit pas avoir deja ete traitee pour l'ETS
				if (((String) vTIRES.get(i)).equals(rBipAllocation.getTires())) {
					// erreur
					vE = new Vector();
					vE.add(rBipAllocation.getETS());
					vE.add(rBipAllocation.getTires());
					vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), I_ERR_TIRES_UNIQUE, vE));
					break;
				}
			}

		} else if (rBipAllocation.getETS().compareTo("" + sETSPrec) < 0) {
			// les alloc doivent etre ordonnes par ETS
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), I_ERR_ETS_ORDRE, null));
		} else {
			vTIRES.clear();
			vTIRES.add(rBipAllocation.getTires());
			iLastAllocation = vAllocations.size() - 1;
		}
	}

	private void checkConsomme(RBipData rBipData) {
		Vector vE;
		RBipAllocation rBipAll;

		rBipAll = getAllocation((String) rBipData.getData(ETS), (String) rBipData.getData(TIRES));

		RBipConsomme rBipConsomme = new RBipConsomme( /* rBipAll, */
				(Integer) rBipData.getData(NUM_ETAPE), (Integer) rBipData.getData(NUM_TACHE), (Integer) rBipData.getData(NUM_SSTA), (String) rBipData.getData(ETS),
				(String) rBipData.getData(TIRES), (Integer) rBipData.getData(POURCENTAGE), (Date) rBipData.getData(DATE_DEB), (Integer) rBipData.getData(NB_JOURS),
				(Double) rBipData.getData(CHARGE_CONSOMMEE), (String) rBipData.getData(TYPE_CONSOMME));
		vConsommes.add(rBipConsomme);

		// 1 - si premier enr, pas normal
		if (rBipData.getNumLigne() == 1) {
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), J_ERR_A_FIRST, null));
		} // test si rectype bien dans ordre A G I J
		else if ((cRecType != RECTYPE_ALLOCATION) && (cRecType != RECTYPE_CONSOMME)) {
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), J_ERR_AGIJ, null));
		} else {
			cRecType = RECTYPE_ALLOCATION;
		}

		// controle du PID
		if (!((String) rBipData.getData(PID)).equals(sPIDReference)) {
			vE = new Vector();
			vE.add(rBipData.getData(PID));
			vE.add(sPIDReference);
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), J_ERR_BAD_PID, vE));
		}

		if (rBipAll == null) {
			// pas d'activite avec meme ETS
			// erreur
			vE = new Vector();
			vE.add(rBipConsomme.getETS());
			vE.add(rBipConsomme.getTires());
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), J_ERR_REF_ALLOCATION, vE));
		}

		// les consommes sont ordonnees par ETS
		String sETSPrec;
		if (iLastConsomme >= 0) {
			sETSPrec = ((RBipConsomme) vConsommes.get(iLastConsomme)).getETS();
		} else {
			sETSPrec = "";
		}

		if (rBipConsomme.getETS().compareTo("" + sETSPrec) < 0) {
			// les alloc doivent etre ordonnes par ETS
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), J_ERR_ETS_ORDRE, null));
		} else {
			iLastConsomme = vConsommes.size() - 1;
		}

		// le pourcentage doit etre = 100
		if (!rBipConsomme.getPourcentage().equals(new Integer(100))) {
			vE = new Vector();
			vE.add(rBipConsomme.getPourcentage().toString());
			vErreurs.add(new RBipErreur(rBipData.getFileName(), rBipData.getNumLigne(), J_ERR_POURC, vE));
		}
	}

	protected String getPIDFromFileName(String sFileName) {
		sFileName = sFileName.toUpperCase();
		if (sFileName.length() == 12)
			return sFileName.substring(0, 3) + " ";
		else
			return sFileName.substring(0, 4);
	}

	private RBipActivite getActivite(String sETS) {
		RBipActivite rBipA;
		for (int i = 0; i < vActivites.size(); i++) {
			rBipA = (RBipActivite) vActivites.get(i);
			if (rBipA.getETS().equals(sETS))
				return rBipA;
		}
		return null;
	}

	private RBipAllocation getAllocation(String sETS, String sTires) {
		RBipAllocation rBipAll;
		for (int i = 0; i < vAllocations.size(); i++) {
			rBipAll = (RBipAllocation) vAllocations.get(i);
			if ((rBipAll.getETS().equals(sETS)) && (rBipAll.getTires().equals(sTires)))
				return rBipAll;
		}
		return null;
	}

	/*
	 * protected RBipEnregistrement getFils(Object oKey) { return null;}
	 */

	public Vector getErreurs() {
		return vErreurs;
	}

	public Vector getWarning() {
		return vWarning;
	}

	private void addErreur(RBipErreur rBipE) {
		vErreurs.add(rBipE);
	}

	// KRA 16/04/2015 - PPM 60612 : Ajout de warning
	private void addWarning(RBipWarning rBipW) {
		vWarning.add(rBipW);
	}

	public String getProv() {
		return prov;
	}

	public void setProv(String prov) {
		this.prov = prov;
	}

	public void checkBipMensuelle(Vector<RBipData> vRBipData) {

		vErreurs = new Vector();
		vWarning = new Vector();
		vRejetBips = new Vector();

		RBipData rBipData;
		RBipData rBipDataNext;
		RBipData rBipDataCoherence;
		RBipData rBipDataCoherenceNext = null;
		String sPidNext = "";// PID de la ligne suivante
		String listPidRejet = "";
		String listPidLA = "";
		String listNumRejet = "";
		String sFileName = "BIPS_GLOBAL";
		String[] tRetour = { "", "" };

		// SEL 6.11.2
		Vector vDataRemoveLe = new Vector(); // vecteur contenant les données à
												// rejeter quand la condition
												// "LE" n'est pas satisfaite

		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

		/*
		 * on effectue le tri par : • Code ligne Bip, ascendant, • Numéro d'étape, ascendant, • Numéro de tâche, ascendant, • Numéro de sous-tâche, ascendant, • Date de début de
		 * période, ascendant, • Code ressource, ascendant.
		 */

		Collections.sort(vRBipData, new RBipsComparateur());

		boolean ctrl_coherence = false;

		// Verifier la coherence des codes structures action
		if (!ctrl_coherence) {

			ctrl_coherence = true;
			String listActions = "";
			for (int i = 0; i < vRBipData.size(); i++) {
				rBipDataCoherence = (RBipData) vRBipData.get(i);

				String sPid = (String) rBipDataCoherence.getData(LIGNE_BIP_CODE);
				String sCle = (String) rBipDataCoherence.getData(LIGNE_BIP_CLE);
				if (sPid == null)
					sPid = "";
				if (sCle == null)
					sCle = "";

				String action = (String) rBipDataCoherence.getData(STRUCTURE_ACTION);
				String pidNext = "";

				if (!listPidRejet.contains(sPid)) // le ligne BIP n'est pas
													// rejetée globalement
				{
					// 1- Contrôle du code de la ligne Bip
					if (!Tools.isValidPid(sPid)) {
						Vector vE = new Vector();
						vE.add(sPid);
						addErreurBips(new RBipErreur(sFileName, rBipDataCoherence.getNumLigne(), REJET_GLOBAL_BIPS_PID_INEXISTANTE, vE), sPid, "", "", "", "");
						listPidRejet += sPid + ";";
						continue;
					}

					Integer iEtape = 0;
					Integer iTache = 0;
					Integer iSous_tache = 0;
					boolean bErrFormatEtape = false;
					boolean bErrFormatTache = false;
					boolean bErrFormatSTache = false;
					try {
						iEtape = RBipParser.parseInteger(rBipDataCoherence.getData(ETAPE_NUM).toString());
					} catch (Exception e) {
						bErrFormatEtape = true;
					}
					try {
						iTache = RBipParser.parseInteger(rBipDataCoherence.getData(TACHE_NUM).toString());
					} catch (Exception e) {
						bErrFormatTache = true;
					}
					try {
						iSous_tache = RBipParser.parseInteger(rBipDataCoherence.getData(STACHE_NUM).toString());
					} catch (Exception e) {
						bErrFormatSTache = true;
					}

					String sEtape = iEtape == 0 ? "00" : (iEtape < 10 ? "0".concat(iEtape.toString()) : iEtape.toString());
					String sTache = iTache == 0 ? "00" : (iTache < 10 ? "0".concat(iTache.toString()) : iTache.toString());
					;
					String sSous_tache = iSous_tache == 0 ? "00" : (iSous_tache < 10 ? "0".concat(iSous_tache.toString()) : iSous_tache.toString());
					;
					String sActivite = sEtape.concat(sTache).concat(sSous_tache);

					Integer iRess_code = 0;
					try {
						iRess_code = RBipParser.parseInteger(rBipDataCoherence.getData(RESS_BIP_CODE).toString().trim());
					} catch (Exception e) {
						iRess_code = 0;
					}
					String sRess_code = iRess_code == 0 ? "" : iRess_code.toString();

					Date dDate_deb_conso = new Date();
					String sDate_deb_conso = rBipDataCoherence.getData(CONSO_DEB_DATE).toString();

					try {
						dDate_deb_conso = sqlToJava(sDate_deb_conso);
						sDate_deb_conso = new String(dateFormat.format(dDate_deb_conso));
					} catch (Exception e) {
						sDate_deb_conso = String.valueOf(rBipDataCoherence.getData(CONSO_DEB_DATE));
					}

					if (!listActions.contains(action)) {
						listActions += action + ";";
					}

					if (i < vRBipData.size() - 1) {
						rBipDataCoherenceNext = (RBipData) vRBipData.get(i + 1);
						pidNext = (String) rBipDataCoherenceNext.getData(LIGNE_BIP_CODE);
					}

					if ((listActions.contains("LA") && (listActions.contains("AE") || listActions.contains("AF") || listActions.contains("LE")))
							|| (listActions.contains("LE") && (listActions.contains("AE") || listActions.contains("AF") || listActions.contains("LA")))) {
						Vector vE = new Vector();
						vE.add(sPid);
						addErreurBips(new RBipErreur(sFileName, rBipDataCoherence.getNumLigne(), REJET_GLOBAL_BIPS_STRUCT_ACTION, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
								rBipDataCoherence.getData(CONSO_QTE).toString());
						listPidRejet += sPid + ";";
						listActions = "";
					}

					if (!pidNext.equals(sPid)) {
						listActions = "";
					}

				}

			}
		}

		vRBipData = Tools.listPmwBips();

		// controle 1er niveau
		for (int iPos = 0; iPos < vRBipData.size(); iPos++) {
			RBipEnTete rBipEnTete = null;
			rBipData = (RBipData) vRBipData.get(iPos);

			if (rBipData.getNumLigne() == 1) // PPM 60612 QC 1746
			{
				continue;
			}

			String sPid = (String) rBipData.getData(LIGNE_BIP_CODE);

			if (rBipData.getNumLigne() > 1 && !listPidRejet.contains(sPid)) {

				String sCle = (String) rBipData.getData(LIGNE_BIP_CLE);
				if (sPid == null)
					sPid = "";
				if (sCle == null)
					sCle = "";

				String sSa = (String) rBipData.getData(STRUCTURE_ACTION).toString();

				Integer iEtape = 0;
				Integer iTache = 0;
				Integer iSous_tache = 0;
				boolean bErrFormatEtape = false;
				boolean bErrFormatTache = false;
				boolean bErrFormatSTache = false;
				try {
					iEtape = RBipParser.parseInteger(rBipData.getData(ETAPE_NUM).toString());
				} catch (Exception e) {
					bErrFormatEtape = true;
				}
				try {
					iTache = RBipParser.parseInteger(rBipData.getData(TACHE_NUM).toString());
				} catch (Exception e) {
					bErrFormatTache = true;
				}
				try {
					iSous_tache = RBipParser.parseInteger(rBipData.getData(STACHE_NUM).toString());
				} catch (Exception e) {
					bErrFormatSTache = true;
				}

				String sEtape = StringUtils.leftPad(String.valueOf(iEtape), 2, '0');
				String sTache = StringUtils.leftPad(String.valueOf(iTache), 2, '0');
				String sSous_tache = StringUtils.leftPad(String.valueOf(iSous_tache), 2, '0');
				String sActivite = sEtape.concat(sTache).concat(sSous_tache);

				Integer iRess_code = 0;
				try {
					iRess_code = RBipParser.parseInteger(rBipData.getData(RESS_BIP_CODE).toString().trim());
				} catch (Exception e) {
					iRess_code = 0;
				}
				String sRess_code = iRess_code == 0 ? "" : iRess_code.toString();

				Date dDate_deb_conso = new Date();
				String sDate_deb_conso = rBipData.getData(CONSO_DEB_DATE).toString();

				try {
					dDate_deb_conso = sqlToJava(sDate_deb_conso);
					sDate_deb_conso = new String(dateFormat.format(dDate_deb_conso));

				} catch (Exception e) {
					sDate_deb_conso = String.valueOf(rBipData.getData(CONSO_DEB_DATE));
				}

				Date dDate_fin_conso = new Date();
				String sDate_fin_conso = rBipData.getData(CONSO_FIN_DATE).toString();

				try {

					dDate_fin_conso = sqlToJava(sDate_fin_conso);
					sDate_fin_conso = new String(dateFormat.format(dDate_fin_conso));

				} catch (Exception e) {
					sDate_fin_conso = String.valueOf(rBipData.getData(CONSO_FIN_DATE));
				}

				// 2- Contrôle des activités de ligne Bip (StructureAction)
				// toutes les activités de la Ligne doivent Exister
				if ("LE".equals(sSa)) {
					boolean top = true;

					for (int iPosNext = 1; iPosNext < vRBipData.size(); iPosNext++) {
						if (sPid.equals((String) ((RBipData) vRBipData.get(iPosNext)).getData(LIGNE_BIP_CODE).toString())
								&& "LE".equals((String) ((RBipData) vRBipData.get(iPosNext)).getData(STRUCTURE_ACTION).toString())) {

							rBipDataNext = (RBipData) vRBipData.get(iPosNext);

							sPidNext = (String) rBipDataNext.getData(LIGNE_BIP_CODE).toString();

							String sEtapeNext = StringUtils.leftPad((String) rBipDataNext.getData(ETAPE_NUM).toString(), 2, '0');
							String sTacheNext = StringUtils.leftPad((String) rBipDataNext.getData(TACHE_NUM).toString(), 2, '0');
							String sSous_tacheNext = StringUtils.leftPad((String) rBipDataNext.getData(STACHE_NUM).toString(), 2, '0');

							String sActiviteNext = sEtapeNext.concat(sTacheNext).concat(sSous_tacheNext);

							try {
								int iRess_codeNext = RBipParser.parseInteger(rBipDataNext.getData(RESS_BIP_CODE).toString().trim());
							} catch (Exception e) {
								iRess_code = 0;
							}
							String sRess_codeNext = iRess_code == 0 ? "" : iRess_code.toString();

							String sDate_deb_consoNext = rBipDataNext.getData(CONSO_DEB_DATE).toString();
							try {

								Date dDate_deb_consoNext = sqlToJava(sDate_deb_consoNext);
								sDate_deb_consoNext = new String(dateFormat.format(dDate_deb_conso));

							} catch (Exception e) {
								sDate_deb_consoNext = String.valueOf(rBipDataNext.getData(CONSO_DEB_DATE));
							}

							if (!Tools.isValidActivite(sPidNext, sEtapeNext, sTacheNext, sSous_tacheNext)) {

								if (top) {
									Vector vE = new Vector();
									vE.add(sPid);
									vE.add(sRess_code);
									vE.add(sActivite);
									vE.add(sDate_deb_conso);
									// toutes les activité de la Ligne doivent
									// Exister
									addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_NUM_STACHE_INEXISTE, vE), sPid, sRess_code, sActivite,
											sDate_deb_conso, rBipData.getData(CONSO_QTE).toString());
									listPidRejet += sPid + ";";
									top = false;
								}
								Vector vE = new Vector();
								vE.add(sPidNext);
								vE.add(sRess_codeNext);
								vE.add(sActiviteNext);
								vE.add(sDate_deb_consoNext);
								// toutes les activité de la Ligne doivent
								// Exister
								addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_NUM_STACHE_INEXISTE, vE), sPidNext, sRess_codeNext, sActiviteNext,
										sDate_deb_consoNext, rBipDataNext.getData(CONSO_QTE).toString());
								listPidRejet += sPid + ";";
							}

							if (listPidRejet.contains(sPidNext)) {
								vDataRemoveLe.add(rBipDataNext);
							}

						}

					}

				} else
					// cette Activité doit Exister
					if ("AE".equals(sSa)) {
					// on vérfier si l'actvité de cette ligne existe, sinon
					// rejet uniquement sur cette ligne
					if (!Tools.isValidActivite(sPid, sEtape, sTache, sSous_tache)) {
						Vector vE = new Vector();
						vE.add(sPid);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_NUM_STACHE_INEXISTE, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
								rBipData.getData(CONSO_QTE).toString());
						continue;
					}
				} else
						// cette Activité est Facultative
						if ("AF".equals(sSa)) {

				} else
							// Annule et remplace de la Ligne
							if ("LA".equals(sSa)) {

				} else {
					// code non conforme
					Vector vE = new Vector();
					vE.add(sPid);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_STRUCT_ACTION, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
							rBipData.getData(CONSO_QTE).toString());
					continue;

				}

				if (listPidRejet.contains(sPid)) {
					continue;
				}

				// 3-Contrôle du type d'étape
				String sType_etape = "";
				// vérification du format 2AN
				boolean bErrFormatTypeEtape = false;

				try {
					sType_etape = RBipParser.parseString((String) rBipData.getData(ETAPE_TYPE).toString().trim());
				} catch (Exception e) {
					bErrFormatTypeEtape = true;
				}

				if (sType_etape.length() == 0 || sType_etape.length() > 2 || bErrFormatTypeEtape) {
					Vector vE = new Vector();
					vE.add(sPid);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_TYPE_ETAPE_FORMAT, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
							rBipData.getData(CONSO_QTE).toString());
					continue;
				}

				String retour = Tools.isValidEtapeType(sPid, sActivite, sType_etape, sSa);

				if ("REJET".equals(retour)) {
					// type d'étape est inconnu ou incompatible avec la ligne
					// Bip
					Vector vE = new Vector();
					vE.add(sPid);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_TYPE_ETAPE_INCONNU, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
							rBipData.getData(CONSO_QTE).toString());
					continue;
				}

				// 4-Contrôle - Controle sur le champ TacheAxeMetier SEL 6.11.2

				String sTacheAxeMetier = "";

				try {
					try {
						if (rBipData.getData(TACHE_AXE_METIER).toString().length() > 12) {
							sTacheAxeMetier = RBipParser.parseString((String) rBipData.getData(TACHE_AXE_METIER).toString()).substring(0, 12);
						} else {
							sTacheAxeMetier = RBipParser.parseString((String) rBipData.getData(TACHE_AXE_METIER).toString());
						}
					} catch (NullPointerException e) {
						sTacheAxeMetier = "";
					}

					tRetour = Tools.verifier_tache_axe_metier_bips(sTacheAxeMetier, sPid);

					if ("A".equals(tRetour[0])) {
						Vector vE = new Vector();
						vE.add(sPid);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						addWarningBips(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_TACHE_AXE_METIER_INCOHERENT, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
								rBipData.getData(CONSO_QTE).toString());
					} else if ("P".equals(tRetour[0])) {
						for (int i = 0; i < Integer.parseInt(tRetour[1]); i++) {
							Vector vE = new Vector();
							vE.add(sPid);
							vE.add(sRess_code);
							vE.add(sActivite);
							vE.add(sDate_deb_conso);
							addWarningBips(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_TACHE_AXE_METIER_PROJET, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
									rBipData.getData(CONSO_QTE).toString());
						}
					} else if ("D".equals(tRetour[0])) {
						for (int i = 0; i < Integer.parseInt(tRetour[1]); i++) {
							Vector vE = new Vector();
							vE.add(sPid);
							vE.add(sRess_code);
							vE.add(sActivite);
							vE.add(sDate_deb_conso);
							addWarningBips(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_TACHE_AXE_METIER_DPCOPI, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
									rBipData.getData(CONSO_QTE).toString());
						}
					}

					rBipData.put(TACHE_AXE_METIER, sTacheAxeMetier);

				} catch (Exception e) {
				}

				// 5-Contrôle du Type de sous-tâche
				String sSTacheType = "";
				boolean bErrFormatSTacheType = false;
				try {
					sSTacheType = RBipParser.parseString((String) rBipData.getData(STACHE_TYPE.toString()));
				} catch (Exception e) {
					bErrFormatSTacheType = true;
				}
				// on récupère le code retour de contrôle du type de sous tâche
				String sMsgRetour = Tools.getRejetStacheType(sPid, sSTacheType);
				// SI ligne productive : vide ou FFxxxx
				// Si la ligne est productive : la ligne Bip xxxx désignée par
				// FF est inexistante ou fermée
				if ("REJET".equalsIgnoreCase(sMsgRetour) && !"".equalsIgnoreCase(sSTacheType) && sSTacheType.startsWith(RBipData.SOUS_TRAITANCE_PREFIX)) {
					Vector vE = new Vector();
					vE.add(sPid);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					vE.add(sSTacheType.substring(2));// FFxxxx pour afficher le
														// pid de la ligne xxxx
					addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_TYPE_STACHE_INEXISTE, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
							rBipData.getData(CONSO_QTE).toString());
					continue;
				}
				// Si la ligne est non productive : le type de sous-tâche non
				// productive est inconnu
				if ("REJET_ABSENCE".equalsIgnoreCase(sMsgRetour)) {
					Vector vE = new Vector();
					vE.add(sPid);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_TYPE_STACHE_INCONNU, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
							rBipData.getData(CONSO_QTE).toString());
					continue;
				}

				// Si la ligne est productive : le type de sous-tâche productive
				// est inconnu
				if ("REJET_PRO_INCONNU".equalsIgnoreCase(sMsgRetour)) {
					Vector vE = new Vector();
					vE.add(sPid);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_TYPE_STACHE_PRO_INCONNU, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
							rBipData.getData(CONSO_QTE).toString());
					continue;
				}

				// 6-Contrôle du Code de la ressource qui impute
				Integer iRessCode = 0;
				String sRessBipCode = "";
				String sConsoDebDate = "";
				String sConsoFinDate = "";
				boolean bErrFormatRessBipCode = false;

				try {
					iRessCode = RBipParser.parseInteger(rBipData.getData(RESS_BIP_CODE).toString().trim());

				} catch (Exception e) {
					bErrFormatRessBipCode = true;
				}

				sRessBipCode = iRess_code == 0 ? "" : iRess_code.toString();
				// on récupère le code retour de contrôle du RessBipCode

				String sMsgRejetRessBipCode = Tools.getRejetRessBipCode(sRessBipCode, sDate_deb_conso, sDate_fin_conso);
				// Si le code ressource est inexistant
				if (bErrFormatRessBipCode || "REJET".equalsIgnoreCase(sMsgRejetRessBipCode)) {
					Vector vE = new Vector();
					vE.add(sPid);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_RESS_CODE_INEXISTANT, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
							rBipData.getData(CONSO_QTE).toString());
					continue;
				}
				// Si pas de situation couvrant totalement la période de
				// consommé : avertissement
				if ("WARNING".equalsIgnoreCase(sMsgRejetRessBipCode)) {
					Vector vE = new Vector();
					vE.add(sPid);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					// addErreurBips(new RBipErreur(sFileName,
					// rBipData.getNumLigne(), WARNING_BIPS_RESS_CODE_SITU,
					// vE));
					addWarningBips(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_RESS_CODE_SITU, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
							rBipData.getData(CONSO_QTE).toString());
				}

				// 7-Contrôle du Nom ou début du nom de la ressource
				String sRessBipNom = "";
				if (rBipData.getData(RESS_BIP_NOM) != null) {
					boolean bErrRessBipNom = false;
					try {
						sRessBipNom = RBipParser.parseString((String) rBipData.getData(RESS_BIP_NOM));
					} catch (Exception e) {
						bErrRessBipNom = true;
					}

					// si le code ressource n'existe pas, alors c pas la peine
					// de chercher le nom associé à ce code
					if (bErrRessBipNom || (!"REJET".equalsIgnoreCase(sMsgRejetRessBipCode) && !Tools.isValidRessBipNom(sRessBipCode, sRessBipNom))) {
						// Rejet : la ressource n'a pas le même nom ou début de
						// nom en Bip
						Vector vE = new Vector();
						vE.add(sPid);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_RESS_NOM, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
								rBipData.getData(CONSO_QTE).toString());
						continue;
					}

					String nomClair = Tools.replaceCarSpec(sRessBipNom);

					if (nomClair.equals(Tools.replaceCarSpec(sRessBipNom)) && !nomClair.equals(sRessBipNom)) {
						Vector vE = new Vector();
						vE.add(sPid);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						vE.add(sDate_fin_conso);
						vE.add(nomClair);
						// addErreurBips(new RBipErreur(sFileName,
						// rBipData.getNumLigne(), WARNING_BIPS_RESS_CODE_SITU,
						// vE));
						addWarningBips(new RBipWarning(sFileName, rBipData.getNumLigne(), WARNING_BIPS_RESS_NOM_COMP, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
								rBipData.getData(CONSO_QTE).toString());
						rBipData.put(RESS_BIP_NOM, nomClair.toUpperCase());
					}

				}

			}

		}

		vRBipData.removeAll(vDataRemoveLe);

		// Contrôle du 2ème niveau
		vRBipData = Tools.listPmwBips();
		Collections.sort(vRBipData, new RBipsComparateur());

		for (int iPos = 0; iPos < vRBipData.size(); iPos++) {
			RBipEnTete rBipEnTete = null;
			rBipData = (RBipData) vRBipData.get(iPos);

			if (rBipData.getNumLigne() == 1) // PPM 60612 QC 1746
			{
				continue;
			}

			boolean bRejetActivite = false;
			boolean bRejetPeriode = false;
			String sConsoDebDate = "";

			String sPid = (String) rBipData.getData(LIGNE_BIP_CODE);

			if (rBipData.getNumLigne() > 1 && !listPidRejet.contains(sPid) && !listNumRejet.contains(String.valueOf(rBipData.getNumLigne()))) {

				if (sPid == null)
					sPid = "";
				String sActivite = Tools.getActivite(rBipData);

				Date dDate_deb_conso = new Date();
				String sDate_deb_conso = rBipData.getData(CONSO_DEB_DATE).toString();

				try {
					dDate_deb_conso = sqlToJava(sDate_deb_conso);
					sDate_deb_conso = new String(dateFormat.format(dDate_deb_conso));
				} catch (Exception e) {
					sDate_deb_conso = rBipData.getData(CONSO_DEB_DATE).toString();
				}

				// String sRess_code =
				// (String)rBipData.getData(RESS_BIP_CODE).toString();
				Integer iRess_code = 0;
				try {
					iRess_code = RBipParser.parseInteger(rBipData.getData(RESS_BIP_CODE).toString().trim());
				} catch (Exception e) {
					iRess_code = 0;
				}
				String sRess_code = iRess_code == 0 ? "" : iRess_code.toString();

				// s'il y a encore des lignes, on peut vérifier si la ligne
				// suivante a le même PID

				if (iPos < vRBipData.size() - 1) {
					// on initialise le curseur par le numéro de la ligne
					// suivante
					int iPosNext = iPos + 1;
					rBipDataNext = (RBipData) vRBipData.get(iPosNext);
					sPidNext = (String) rBipDataNext.getData(LIGNE_BIP_CODE);
					if (sPidNext == null)
						sPidNext = "";
					int s = vRBipData.size();
					while (iPosNext < vRBipData.size() && sPid.equals(sPidNext)) {
						// on récupère le PID de la ligne suivante
						rBipDataNext = (RBipData) vRBipData.get(iPosNext);
						sPidNext = (String) rBipDataNext.getData(LIGNE_BIP_CODE);
						if (sPidNext == null)
							sPidNext = "";
						// on recupère l'activité de la ligne suivante
						String sActiviteNext = Tools.getActivite(rBipDataNext);
						Date dDate_deb_consoNext = new Date();

						Date dConsoDebDate = new Date();
						boolean bErrConsoDebDate = false;
						try {
							dDate_deb_consoNext = sqlToJava(rBipDataNext.getData(CONSO_DEB_DATE).toString());
							dDate_deb_consoNext = RBipParser.parseJJMMAAAADate(new String(dateFormat.format(dDate_deb_consoNext)));
							sConsoDebDate = new String(dateFormat.format(dDate_deb_consoNext));
						} catch (Exception e) {
							BipAction.logBipUser.warning("erreur lors de la récupération de la donnée CONSO_DEB_DATE (second traitement). Caused by :" + e.getMessage());
							iPosNext++;
							continue;
						}

						String sDate_deb_consoNext = new String(dateFormat.format(dDate_deb_consoNext));
						// String sRess_codeNext =
						// (String)rBipDataNext.getData(RESS_BIP_CODE);
						Integer iRess_codeNext = 0;
						try {
							iRess_codeNext = RBipParser.parseInteger(rBipDataNext.getData(RESS_BIP_CODE).toString().trim());
						} catch (Exception e) {
							iRess_codeNext = 0;
						}
						String sRess_codeNext = iRess_codeNext == 0 ? "" : iRess_codeNext.toString();
						if (sRess_codeNext == null)
							sRess_codeNext = "";

						if (sActivite.equals(sActiviteNext) && sDate_deb_conso.equals(sDate_deb_consoNext) && sRess_code.equals(sRess_codeNext) && sPid.equals(sPidNext)) {
							// REJET GLOBAL pour la ligne xxxx, ressource nnnn,
							// activité nnnnn et début de période consommée
							// JJ/MM/AAAA,
							// car il y a des doublons sur ces critères
							if (!bRejetActivite) { // si la ligne n'a pas été
													// déjà rejetée
								Vector vE = new Vector();
								vE.add(sPid);
								vE.add(sRess_code);
								vE.add(sActivite);
								vE.add(sDate_deb_conso);
								addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_GLOBAL_BIPS_ACTIVITE_DOUBLONS, vE), sPid, sRess_code, sActivite,
										sDate_deb_conso, rBipData.getData(CONSO_QTE).toString());

								vRBipData = Tools.listPmwBips();

							}
						} else if (sActivite.equals(sActiviteNext) && sRess_code.equals(sRess_codeNext) && sPid.equals(sPidNext)) {
							Date dDate_fin_conso;
							String sDate_fin_conso;
							try {
								dDate_fin_conso = sqlToJava(rBipData.getData(CONSO_FIN_DATE).toString());
								sDate_fin_conso = new String(dateFormat.format(dDate_fin_conso));
							} catch (Exception e1) {
								iPosNext++;
								continue;
							}

							Date dDate_fin_consoNext;
							String sDate_fin_consoNext;
							try {
								dDate_fin_consoNext = sqlToJava(rBipDataNext.getData(CONSO_FIN_DATE).toString());
								sDate_fin_consoNext = new String(dateFormat.format(dDate_fin_consoNext));
							} catch (Exception e) {
								iPosNext++;
								continue;
							}
							if ((dDate_deb_consoNext.after(dDate_deb_conso) && dDate_deb_consoNext.before(dDate_fin_conso))
									|| (dDate_deb_consoNext.before(dDate_deb_conso) && dDate_fin_consoNext.after(dDate_deb_conso))
									|| (dDate_deb_consoNext.equals(dDate_deb_conso))) {
								// REJET GLOBAL pour la ligne xxxx, ressource
								// nnnn, activité nnnnn,
								// le début de période consommée JJ/MM/AAAA et
								// la fin de période consommée JJ/MM/AAAA, car
								// des périodes sont en doublon ou se
								// chevauchent
								// if (!bRejetPeriode) {// pour ne pas rejeter la
								// ligne plusieurs fois
								// (un seul rejet global
								// pour une ligne)
								Vector vE = new Vector();
								vE.add(sPid);
								vE.add(sRess_code);
								vE.add(sActivite);
								vE.add(sDate_deb_conso);
								vE.add(sDate_fin_conso);
								addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_GLOBAL_BIPS_PERIODE_DOUBLONS, vE), sPid, sRess_code, sActivite,
										sDate_deb_conso, rBipData.getData(CONSO_QTE).toString());
								iPosNext--;

								Vector vEr = new Vector();
								vEr.add(sPid);
								vEr.add(sRess_code);
								vEr.add(sActivite);
								vEr.add(sDate_deb_consoNext);
								vEr.add(sDate_fin_consoNext);
								addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_GLOBAL_BIPS_PERIODE_DOUBLONS, vEr), sPid, sRess_code, sActivite,
										sDate_deb_consoNext, rBipDataNext.getData(CONSO_QTE).toString());
								iPosNext--;
								bRejetPeriode = true;

								vRBipData = Tools.listPmwBips();

								// vRBipData.remove(rBipDataNext);
								Vector vWarningRemove = new Vector();

							}
							// }
						}
						// on incrémente le curseur
						iPosNext++;
					}
				}
				try {
					// Si mention d'une période de consommé antérieure au 1er
					// janvier de l'année fonctionnelle, alors rejet
					if (Tools.isPeriodeAnterieureAnneeFonct(sDate_deb_conso)) {
						// la période indiquée est antérieure à l'année
						// fonctionnelle en cours
						Vector vE = new Vector();
						vE.add(sPid);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_PERIODE_ANTERIEURE, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
								rBipData.getData(CONSO_QTE).toString());
						continue;
					}
				} catch (Exception e) {
					Vector vE = new Vector();
					vE.add(sPid);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_DEB_DATE_INVALIDE, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
							rBipData.getData(CONSO_QTE).toString());
					continue;
				}

				try {
					// Si mention d'une période de consommé ultérieure au mois
					// fonctionnel en cours, alors
					String result = Tools.isPeriodeUlterieureMoisFonct(sDate_deb_conso, sPid);

					// si result = null ou vide, alors la période est ultérieure
					// au mois fonctionnel en cours
					if (!"".equals(result) && result != null) {
						// SI la ligne Bip n'est pas gérée en structure SR,
						// alors REJET
						if ("REJET".equals(result)) {
							// la période indiquée est dans le futur et ne peut
							// donc pas encore être traitée
							Vector vE = new Vector();
							vE.add(sPid);
							vE.add(sRess_code);
							vE.add(sActivite);
							vE.add(sDate_deb_conso);
							addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_PERIODE_ULTERIEURE, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
									rBipData.getData(CONSO_QTE).toString());
							continue;
						}

					}
				} catch (Exception e) {
					Vector vE = new Vector();
					vE.add(sPid);
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_DEB_DATE_INVALIDE, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
							rBipData.getData(CONSO_QTE).toString());
					continue;
				}

				try {// SEL PPM 62605
						// Si mention d'une période de consommé ultérieure à
						// l'année fonctionnelle en cours, alors
					String result = Tools.isPeriodeUlterieureAnneeFonct(sDate_deb_conso, sPid);

					// si result = REJET, alors la période est ultérieure à
					// l'année fonctionnelle en cours
					if ("REJET".equals(result)) {
						// la période indiquée est dans le futur et ne peut donc
						// pas encore être traitée
						Vector vE = new Vector();
						vE.add(sPid);
						vE.add(sRess_code);
						vE.add(sActivite);
						vE.add(sDate_deb_conso);
						addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_ANNEE_ULTERIEURE, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
								rBipData.getData(CONSO_QTE).toString());
						continue;
					}
				} catch (Exception e) {
					Vector vE = new Vector();
					vE.add(sRess_code);
					vE.add(sActivite);
					vE.add(sDate_deb_conso);
					addErreurBips(new RBipErreur(sFileName, rBipData.getNumLigne(), REJET_BIPS_CONSO_DEB_DATE_INVALIDE, vE), sPid, sRess_code, sActivite, sDate_deb_conso,
							rBipData.getData(CONSO_QTE).toString());
					continue;
				}

			}
		}

		// Fin KRA 16/04/2015 - PPM 60612
		Collections.sort(vErreurs, new RBipErreurComparateur());
		Collections.sort(vWarning, new RBipErreurComparateur());

	}

	private void addErreurBips(RBipErreur rBipErreur, String sPid, String sRess, String sActivite, String sDeb, String sConso) {

		Tools.inserer_erreur_bips(rBipErreur, sPid, sRess, sActivite, sDeb, sConso);

	}

	private void addWarningBips(RBipErreur rBipErreur, String sPid, String sRess, String sActivite, String sDeb, String sConso) {

		Tools.inserer_erreur_bips(rBipErreur, sPid, sRess, sActivite, sDeb, sConso);

	}

	public Vector getVRejetBips() {
		return vRejetBips;
	}

	public Date sqlToJava(String sDate) {

		int annee = Integer.parseInt(sDate.substring(0, 4)) - 1900;
		int mois = Integer.parseInt(sDate.substring(5, 7)) - 1;
		int jour = Integer.parseInt(sDate.substring(8, 10));

		return new Date(annee, mois, jour);
	}
}