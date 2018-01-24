package com.socgen.bip.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.form.BipForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.db.RBip_Jdbc;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.SaisieConsoForm;
import com.socgen.bip.form.StructLbForm;
import com.socgen.bip.metier.Consomme;
import com.socgen.bip.metier.ErreurSupprSsTache;
import com.socgen.bip.metier.StructLb;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author N.BACCAM - 27/05/2003
 * 
 *         Action de mise à jour des consommés chemin : Saisie des réalisés/
 *         consommés pages : fSaisieConsoSr.jsp pl/sql :
 */
public class SaisieConsoAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "conso.consulter.proc";
	private static String PACK_UPDATE = "conso.modifier.proc";
	private static String PACK_TABLEAU = "conso.tableau.proc";
	private static String PACK_TOTAL = "conso.total.proc";
	private static String PACK_VERIF_PERIOCLOT = "perioClot.consulter.proc";
	private static String PACK_LOCK = "lock.proc";
	private static String PACK_LOCK_INIT = "lock.init.proc";
	private static String FONCTION_LOCK = "SASIE_CONSOMME";
	private static final String PACK_VERIF_SOUS_TACHES = "conso.soustaches.proc";
	private static final String PACK_SOUS_TACHES_FAV = "sousTache.conso.favorite.proc";
	private static final String PACK_SOUS_TACHES_DES = "sousTache.conso.desaffecter.proc";
	private static final String PACK_SOUS_TACHES_SUP = "sousTache.conso.supprimer.proc";
	private static final String PACK_SOUS_TACHES_EXISTE_CONSO = "sousTache.conso.existeconsomme.proc";
	// MEH PPM 64935
	private static final String PACK_SOUS_TACHES_EXISTE_CONSO_DEF = "sousTache.conso.existeconsommedef.proc";
	
	
	private static final String PACK_COULEUR_FOND_MOIS = "conso.couleur_fond_mois.proc";
	
	//FAD PPM 64579 : Déclaration procédure stocké
	private static final String PACK_COULEUR_FOND_ANNEE = "conso.couleur_fond_annee.proc";
	//FAD PPM 64579 : Fin
	
	private int blocksize = 10;

	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		logBipUser.debug("SaisieConsoAction-initialiser() ");

		String signatureMethode = "SaisieConsoAction-initialiser()";

		logBipUser.entry(signatureMethode);
		logBipUser.exit(signatureMethode);
		Vector vParamOut = new Vector();
		JdbcBip jdbc = new JdbcBip();
		ParametreProc paramOut;
		String periode = "";

		try {

			vParamOut = jdbc.getResult(hParamProc, configProc,
					PACK_VERIF_PERIOCLOT);

			if (vParamOut == null) {
				jdbc.closeJDBC();
				return mapping.findForward("initial");
			}
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				// récupérer le message
				if (paramOut.getNom().equals("periode")) {
					periode = (String) paramOut.getValeur();
				}
				jdbc.closeJDBC();
				if (periode.equals("OUI"))
					return mapping.findForward("cloture");
				else
					return mapping.findForward("initial");

			}
		} catch (BaseException be) {
			
			logBipUser.debug(
					"SaisieConsoAction-initialiser() --> BaseException :" + be,
					be);
			logBipUser.debug("SaisieConsoAction-initialiser() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"SaisieConsoAction-initialiser() --> BaseException :" + be,
					be);
			logService.debug("SaisieConsoAction-initialiser() --> Exception :"
					+ be.getInitialException().getMessage());

		}
		
		jdbc.closeJDBC();
		return mapping.findForward("initial");
	}

	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		logBipUser.debug("SaisieConsoAction-suite() ");

		String signatureMethode = "SaisieConsoAction-suite()";

		// Mise a jour du lock sur la ressource
		gestion_lock(mapping, form, request, response, errors);
		logBipUser.entry(signatureMethode);
		logBipUser.exit(signatureMethode);
		Vector vParamOut = new Vector();
		JdbcBip jdbc = new JdbcBip();
		ParametreProc paramOut;
		String periode = "";

		try {

			vParamOut = jdbc.getResult(hParamProc, configProc,
					PACK_VERIF_PERIOCLOT);

			if (vParamOut == null) {
				jdbc.closeJDBC();
				return mapping.findForward("initial");
			}
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				// récupérer le message
				if (paramOut.getNom().equals("periode")) {
					periode = (String) paramOut.getValeur();
				}
				jdbc.closeJDBC();
				if (periode.equals("OUI"))
					return mapping.findForward("cloture");
				else
					return mapping.findForward("initial");

			}
		} catch (BaseException be) {

			logBipUser.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

		}
		jdbc.closeJDBC();
		return mapping.findForward("initial");
	} // suite

	/**
	 * Action qui permet de passer à la page première page avec reconstitution
	 * du menu
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		HttpSession session = request.getSession(false);
		String signatureMethode = "SaisieConsoAction-annuler()";

		logBipUser.entry(signatureMethode);
		// On détruit le tableau sauvegardé en session
		session.removeAttribute(CONSOMME_EN_MASSE);

		SaisieConsoForm bipForm = ((SaisieConsoForm) form);
		// bipForm.setPosition("2");

		// session.setAttribute("POSITION", "1");
		// on sauvegarde en session la position de la ressource dans la liste
		// déroulante

		session.setAttribute("POSITION", bipForm.getPosition());
		session.setAttribute("IDENT", bipForm.getIdent());
		session.setAttribute("CODSG", bipForm.getCodsg());
		session.setAttribute("POSITION_BLOCKSIZE",
				bipForm.getPosition_blocksize());
		session.setAttribute("ORDRE_TRI", bipForm.getOrdre_tri());
		session.setAttribute("CHOIXRESS", bipForm.getChoix_ress());

		request.setAttribute("indexMenu", "2");

		// suppression des locks de l utilisateur
		reset_lock_user(mapping, form, request, response, errors, hParamProc);

		logBipUser.debug("Destruction de la liste des consos en session");
		logBipUser.exit(signatureMethode);
		return mapping.findForward("suite");
	}

	/**
	 * Méthode consulter : Affichage des données dont le tableau des consommés
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		Vector vParamOut1 = new Vector();
		Vector vParamOut2 = new Vector();
		Vector vParamOut3 = new Vector();
		String message = "";
		String retroIdent ="";
		boolean msg = false;
		ParametreProc paramOut;
		Vector vListe = new Vector();
		PaginationVector vueListe;
		HttpSession session = request.getSession(false);
		JdbcBip jdbc = new JdbcBip();

		String signatureMethode = "SaisieConsoActionAction-consulter()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		// Création d'une nouvelle form
		SaisieConsoForm bipForm = (SaisieConsoForm) form;
		// Ajout du paramètre pour la liste des DPG séparés par des virgules
		hParamProc.put("listeCodsgString", bipForm.getListeCodsgString());

		// session.setAttribute("POSITION", "1");
		// on sauvegarde en session la position de la ressource dans la liste
		// déroulante
		session.setAttribute("POSITION", bipForm.getPosition());
		session.setAttribute("IDENT", bipForm.getIdent());
		session.setAttribute("POSITION_BLOCKSIZE",
				bipForm.getPosition_blocksize());
		session.setAttribute("ORDRE_TRI", bipForm.getOrdre_tri());
		session.setAttribute("CHOIXRESS", bipForm.getChoix_ress());
		session.setAttribute("LISTECODSG", bipForm.getListeCodsgString());
		session.setAttribute("LISTESOUSTACHES", bipForm.getListeSousTaches());
		session.setAttribute("RESSOURCE", bipForm.getRessource());
				
		/*BIP 612 changes*/
		retroIdent=checkRetroAccess(bipForm.getIdent(),((UserBip) request.getSession().getAttribute("UserBip")).getSousMenus().toLowerCase());
		bipForm.setRetroIdent(retroIdent);
		
		/*BIP-184 checking the empty condition */
		if (bipForm.getBlocksize() != null || bipForm.getBlocksize().isEmpty() )
			blocksize = Integer.parseInt(bipForm.getBlocksize());

		if (hParamProc == null) {
			logBipUser.debug("SaisieConso-consulter-->hParamProc is null");
		}

		// ******* exécution de la procédure PL/SQL pour verifier le lock de la
		// ressource
		gestion_lock(mapping, form, request, response, errors);
		if ("O".equals(bipForm.getLock())) {
			jdbc.closeJDBC();
			// le message de retour est fait dans la fonction gestion_lock
			return mapping.findForward("suite");

		}

		// Vérification de la présence de sous-tâches
		try {
			final Vector vParamOut4 = jdbc.getResult(hParamProc, configProc,
					PACK_VERIF_SOUS_TACHES);

			if (vParamOut4 == null) {
				logBipUser
						.debug("SaisieConso-consulter(a des sous-tâches) :!!! cancel forward ");
				logBipUser.exit(signatureMethode);
				jdbc.closeJDBC();
				return mapping.findForward("suite");
			}
			
			// Récupération des résultats
			String res = "O";
			for (Enumeration e = vParamOut4.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}
				if (paramOut.getNom().equals("resultat")) {
					// Récupération du resultat
					res = (String) paramOut.getValeur();
				} // if
			} // for
			
			if ("N".equals(res)) {
				bipForm.setMsgErreur(message);
				jdbc.closeJDBC();				
				return mapping.findForward("suite");
			}			
		} catch (final BaseException be) {
			logBipUser.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SaisieConsoForm) form).setMsgErreur(message);
				jdbc.closeJDBC();
				return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc.closeJDBC();
				return mapping.findForward("error");
			}
		}
		
		// ******* exécution de la procédure PL/SQL pour affichage ressource
		try {

			vParamOut1 = jdbc.getResult(hParamProc, configProc, PACK_SELECT);

			// pas besoin d'aller plus loin
			if (vParamOut1 == null) {
				logBipUser
						.debug("SaisieConso-consulter(affichage ressource) :!!! cancel forward ");
				logBipUser.exit(signatureMethode);
				jdbc.closeJDBC();
				return mapping.findForward("suite");
			}

			// Récupération des résultats
			for (Enumeration e = vParamOut1.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setIdent(rset.getString(1));
							bipForm.setRessource(rset.getString(2));
							bipForm.setMois(rset.getString(3));
							bipForm.setNbmois(rset.getString(4));
							bipForm.setMsgErreur(null);
						} else {
							msg = true;
						}
						rset.close();
					} // try
					catch (SQLException sqle) {
						logService
								.debug("SaisieConsoAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SaisieConsoAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						jdbc.closeJDBC();
						return mapping.findForward("error");
					} finally {
						try {
							if (rset != null) {
								rset.close();
								rset = null;
							}
						} catch (SQLException sqle) {
							logBipUser
									.debug("SaisieConsoAction-consulter() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							jdbc.closeJDBC();
							return mapping.findForward("error");
						}

					}
				} // if
			} // for
			if (msg) {
				// on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				// jdbc.closeJDBC(); return mapping.findForward("initial");
				jdbc.closeJDBC();
				return mapping.findForward("suite");
			}
		} // try
		catch (BaseException be) {

			// suppression des locks de l utilisateur
			reset_lock_user(mapping, form, request, response, errors,
					hParamProc);

			logBipUser.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName()
					.equals("java.sql.SQLException")) {

				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SaisieConsoForm) form).setMsgErreur(message);
				// jdbc.closeJDBC(); return mapping.findForward("initial");
				jdbc.closeJDBC();
				return mapping.findForward("suite");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc.closeJDBC();
				return mapping.findForward("error");
			}
		}

		// ******* exécution de la procédure PL/SQL pour des totaux et du nb de
		// jours ouvrés
		try {
			vParamOut2 = // (new JdbcBip()).getResult(
			jdbc.getResult(hParamProc, configProc, PACK_TOTAL);

			// pas besoin d'aller plus loin
			if (vParamOut2 == null) {
				logBipUser
						.debug("SaisieConso-consulter(totaux) :!!! cancel forward  ");
				logBipUser.exit(signatureMethode);
				jdbc.closeJDBC();
				return mapping.findForward("suite");
			}
			// Récupération des résultats
			for (Enumeration e = vParamOut2.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setTot_mois_1(rset.getString(1));
							bipForm.setTot_mois_2(rset.getString(2));
							bipForm.setTot_mois_3(rset.getString(3));
							bipForm.setTot_mois_4(rset.getString(4));
							bipForm.setTot_mois_5(rset.getString(5));
							bipForm.setTot_mois_6(rset.getString(6));
							bipForm.setTot_mois_7(rset.getString(7));
							bipForm.setTot_mois_8(rset.getString(8));
							bipForm.setTot_mois_9(rset.getString(9));
							bipForm.setTot_mois_10(rset.getString(10));
							bipForm.setTot_mois_11(rset.getString(11));
							bipForm.setTot_mois_12(rset.getString(12));
							bipForm.setTotal(rset.getString(13));
							bipForm.setNbjour_1(rset.getString(14));
							bipForm.setNbjour_2(rset.getString(15));
							bipForm.setNbjour_3(rset.getString(16));
							bipForm.setNbjour_4(rset.getString(17));
							bipForm.setNbjour_5(rset.getString(18));
							bipForm.setNbjour_6(rset.getString(19));
							bipForm.setNbjour_7(rset.getString(20));
							bipForm.setNbjour_8(rset.getString(21));
							bipForm.setNbjour_9(rset.getString(22));
							bipForm.setNbjour_10(rset.getString(23));
							bipForm.setNbjour_11(rset.getString(24));
							bipForm.setNbjour_12(rset.getString(25));

							// sauvegarde des mois anciens
							saveOldMonths(bipForm);
							bipForm.setMsgErreur(null);
						} else {
							msg = true;
						}
						if (rset != null) {
							rset.close();
							rset = null;
						}
					} // try
					catch (SQLException sqle) {
						logService
								.debug("SaisieConsoAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SaisieConsoAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						jdbc.closeJDBC();
						return mapping.findForward("error");
					}
				} // if
			} // for
			if (msg) {
				// on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				jdbc.closeJDBC();
				return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName()
					.equals("java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SaisieConsoForm) form).setMsgErreur(message);
				jdbc.closeJDBC();
				return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc.closeJDBC();
				return mapping.findForward("error");
			}
		}
		// Tools.forceFullGarbageCollection();
		// ******* exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut3 = // (new
							// JdbcBip()).getResult(hParamProc,
			jdbc.getResult(hParamProc, configProc, PACK_TABLEAU);
			// pas besoin d'aller plus loin
			if (vParamOut3 == null) {
				logBipUser
						.debug("SaisieConso-consulter(tableau) :!!! cancel forward ");
				logBipUser.exit(signatureMethode);
				jdbc.closeJDBC();
				return mapping.findForward("suite");
			}
			// Récupération des résultats
			for (Enumeration e = vParamOut3.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							// On alimente le Bean consomme et on le stocke dans
							// un vector
							vListe.add(new Consomme(rset.getString(1), rset
									.getString(2), rset.getString(3), rset
									.getString(4), rset.getString(5), rset
									.getString(6), rset.getString(7), rset
									.getString(8), rset.getString(9), rset
									.getString(10), rset.getString(11), rset
									.getString(12), rset.getString(13), rset
									.getString(14), rset.getString(15), rset
									.getString(16), rset.getString(17), rset
									.getString(18), rset.getString(19), rset
									.getString(20), rset.getString(21), rset
									.getString(22), rset.getString(23), rset
									.getString(24), rset.getString(25), rset
									.getString(26), rset.getString(27), rset
									.getString(28), rset.getString(29), rset
									.getString(30), rset.getString(31), rset
									.getString(32), rset.getString(33), rset
									.getString(34), rset.getString(35), rset
									.getString(36), rset.getString("AIST_MOISFIN")));
						}
						if (rset != null) {
							rset.close();
							rset = null;
						}
					} // try
					catch (SQLException sqle) {
						logService
								.debug("SaisieConsoAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SaisieConsoAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						jdbc.closeJDBC();
						return mapping.findForward("error");
					}
				} // if
			} // for
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"SaisieConsoAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("SaisieConsoAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName()
					.equals("java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SaisieConsoForm) form).setMsgErreur(message);
				jdbc.closeJDBC();
				return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc.closeJDBC();
				return mapping.findForward("error");
			}
		}
		

		if (bipForm.getBlocksize() != null)
			blocksize = Integer.parseInt(bipForm.getBlocksize());

		// Construire un PaginationVector contenant les informations du FormBean
		vueListe = new PaginationVector(vListe, blocksize);
		// Stocker le résultat dans la session
		// if (session.getAttribute("listeConsos") == null) {
		session.setAttribute(CONSOMME_EN_MASSE, vueListe);
		// probleme memoire
		hParamProc = null;
		// Tools.forceFullGarbageCollection();
		// } else {
		// session.removeAttribute("listeConsos");
		// session.setAttribute("listeConsos", vueListe);
		// }
		// Stocker le résultat dans le formulaire
		bipForm.setListePourPagination(vueListe);
		logBipUser
				.debug("fmemory end   : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC();
		return mapping.findForward("ecran");
	}

	/**
	 * Méthode valider : Met à jour les proposés dans la base de données
	 */
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		Vector vParamOut = new Vector();
		Vector vParamOutST = new Vector();
		String message = "";
		String type_valider = "";
		String ident;
		String pid;
		String etape;
		String tache;
		String sous_tache;
		String consomme;
		String libConso;
		String save;
		String libChoix;
		String libChoixOld;
		String valueChoix;
		String valueChoixOld;

		JdbcBip jdbc = new JdbcBip();
		//QC 1928 - PPM 64368
		//ABN - PPM 64836
		StringBuffer[] sbChainet = new StringBuffer[1000];
		int si = 0;
		sbChainet[si] = new StringBuffer();

		HttpSession session = request.getSession(false);
		Class[] parameterString = {};
		Object oConso;
		String signatureMethode = "SaisieConsoActionAction-valider()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());

		SaisieConsoForm bipForm = ((SaisieConsoForm) form);
		// Extraction de la valeur action
		type_valider = bipForm.getType_valider();
		
		session.setAttribute("LISTECODSG", bipForm.getListeCodsgString());
		session.setAttribute("LISTESOUSTACHES", bipForm.getListeSousTaches());
		session.setAttribute("RESSOURCE", bipForm.getRessource());
		
		String erreurSupprConsoPresent;
		String codeErreurSuppr;
		ErreurSupprSsTache erreur;
		ArrayList<ErreurSupprSsTache> listeErreurs = new ArrayList<ErreurSupprSsTache>();
		
		PaginationVector page = (PaginationVector) session
		.getAttribute(CONSOMME_EN_MASSE);
		// On sauvegarde les données du formulaire
		savePage(mapping, form, request, response, errors);

		
		try {


			// On construit la chaîne qui doit être passé en paramètre de la
			// forme
			// ident:pid;etape;tache;sous_tache;CONSO_1_1=;CONSO_1_2=;....CONSO_1_12=;:
			// 16894:C7G;990;1670;6204;CONSO_1_1=;CONSO_1_2=;CONSO_1_3=;
			
			ident = bipForm.getIdent();
			sbChainet[si].append(ident);
			int i = 0;
			//ABN - HP PPM 57735 (GESTION DES FAVORIS) - DEBUT
			//int nbrPage = 1;
			
			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				jdbc = new JdbcBip();
				Consomme SaisieConso = (Consomme) e.nextElement();
				i++;
				pid = SaisieConso.getPid();
				etape = SaisieConso.getEtape();
				tache = SaisieConso.getTache();
				sous_tache = SaisieConso.getSous_tache();
				
				//libChoix = "choix_" + i + "_" + nbrPage;
				//valueChoix = request.getParameter(libChoix);
				//if (valueChoix == null) {
					valueChoix = String.valueOf(SaisieConso.getChoix());
				//}


				//libChoixOld = "choix_old_" + i + "_" + nbrPage;
				//valueChoixOld = request.getParameter(libChoixOld);
				//if (valueChoixOld == null) {
					valueChoixOld = String.valueOf(SaisieConso.getChoixOld());
				//}


				//if (i%blocksize == 0 ) {
					// nbrPage++;
					// i = 0;
				//}


				
				// Si clic sur un bouton différent de Affecter sous-tâche
				if (!"affecter".equals(type_valider)) {
					//ABN - HP PPM 57735 (GESTION DES FAVORIS) - FIN
					if (valueChoixOld != null && valueChoix != null) {
						hParamProc.put("soustache", sous_tache);
						if (Integer.parseInt(valueChoix) == Consomme.CHOIX_AUCUN
								&& Integer.parseInt(valueChoixOld) == Consomme.CHOIX_MISE_EN_FAVORITE) {
							// Suppression de la mise en favorite
							// appeler PACK_ISAC_SOUS_TACHE.mettre_en_favorite()
							// - second parametre 0
							hParamProc.put("favorite", "0");
							vParamOutST = jdbc.getResult(hParamProc, configProc,
									PACK_SOUS_TACHES_FAV);
							if (vParamOutST == null) {
								session.setAttribute("errorUpdate", "UPDATE");
								logBipUser.debug("!!! update cancelled ");
							}
						}
						if (Integer.parseInt(valueChoix) == Consomme.CHOIX_DESAFFECTATION) {
							if (Integer.parseInt(valueChoixOld) == Consomme.CHOIX_MISE_EN_FAVORITE) {
								// Suppression de la mise en favorite
								// appeler
								// PACK_ISAC_SOUS_TACHE.mettre_en_favorite() -
								// second parametre 0
								hParamProc.put("favorite", "0");
								vParamOutST = jdbc.getResult(hParamProc,
										configProc, PACK_SOUS_TACHES_FAV);
								if (vParamOutST == null) {
									session.setAttribute("errorUpdate", "UPDATE");
									logBipUser.debug("!!! update cancelled ");
								}
							}
							// Desaffectation de la sous-tache
							// appeler PACK_ISAC_SOUS_TACHE.desaffecter()
							vParamOutST = jdbc.getResult(hParamProc, configProc,
									PACK_SOUS_TACHES_DES);
							if (vParamOutST == null) {
								session.setAttribute("errorUpdate", "UPDATE");
								logBipUser.debug("!!! update cancelled ");
							}
						
						}
						if (Integer.parseInt(valueChoix) == Consomme.CHOIX_SUPPRESSION) {
							// Suppression de la sous-tache
							// appeler PACK_ISAC_SOUS_TACHE.supprimer()
							vParamOutST = jdbc.getResult(hParamProc, configProc,
									PACK_SOUS_TACHES_SUP);
							if (vParamOutST == null) {
								session.setAttribute("errorUpdate", "UPDATE");
								logBipUser.debug("!!! update cancelled ");
							}
							else if (!vParamOutST.isEmpty()){
								codeErreurSuppr = (String) ((ParametreProc) vParamOutST.get(0)).getValeur();
								
								if (SaisieConsoForm.codeErreurSupprSsTacheAvecConsomme.equals(codeErreurSuppr)) {
									erreur = new ErreurSupprSsTache(pid, SaisieConso.getEcet(), SaisieConso.getActa(), SaisieConso.getAcst());
									listeErreurs.add(erreur);
								} 

							}
						}
						if (Integer.parseInt(valueChoix) == Consomme.CHOIX_MISE_EN_FAVORITE
								&& Integer.parseInt(valueChoixOld) != Consomme.CHOIX_MISE_EN_FAVORITE) {
							// Mise en favorite
							// appeler PACK_ISAC_SOUS_TACHE.mettre_en_favorite()
							// - second parametre 1
							hParamProc.put("favorite", "1");
							vParamOutST = jdbc.getResult(hParamProc, configProc,
									PACK_SOUS_TACHES_FAV);
							if (vParamOutST == null) {
								session.setAttribute("errorUpdate", "UPDATE");
								logBipUser.debug("!!! update cancelled ");
							}
						}
						hParamProc.remove("favorite");
						hParamProc.remove("soustache");
					}
				}
				
				
				
				if (sbChainet[si].length() > 30000) {
					sbChainet[si].append(":");
					si++;
					sbChainet[si] = new StringBuffer();
					sbChainet[si].append(ident);
				}

				sbChainet[si].append(":" + pid + ";" + etape + ";" + tache
						+ ";" + sous_tache + ";");
				for (int j = 1; j <= 12; j++) {
					libConso = "conso_" + i + "_" + j + "=";
					Object[] param1 = {};
					try {
						oConso = SaisieConso
								.getClass()
								.getDeclaredMethod("getConso_" + j,
										parameterString)
								.invoke((Object) SaisieConso, param1);
						if (oConso != null)
							consomme = oConso.toString();
						else
							consomme = "";
						// libConso = libConso + consomme + ";";
						sbChainet[si].append(libConso + consomme + ";");
					} // try
					catch (NullPointerException npe) {
						logBipUser.debug("!!! valeur null dans : "
								+ npe.getMessage());
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (NoSuchMethodException me) {
						logBipUser.debug("Méthode inexistante");
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (SecurityException se) {
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (IllegalAccessException ia) {
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (IllegalArgumentException iae) {
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (InvocationTargetException ite) {
						// Erreur d''exécution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					}
				} // for
				jdbc.closeJDBC();
			} // for
			

			sbChainet[si].append(":");

			logBipUser.debug("Destruction de la liste des consos en session");
			// Ajouter la chaine dans la hashtable des paramètres
			//ABN - HP PPM 64836
			if (sbChainet[0] != null)
				hParamProc.put("string", sbChainet[0].toString());
			if (sbChainet[1] != null)
				hParamProc.put("string2", sbChainet[1].toString());
			//hParamProc.put("string", sbChainet[0].toString());
			if (sbChainet[2] != null)
				hParamProc.put("string3", sbChainet[2].toString());
			if (sbChainet[3] != null)
				hParamProc.put("string4", sbChainet[3].toString());
			if (sbChainet[4] != null)
				hParamProc.put("string5", sbChainet[4].toString());
			if (sbChainet[5] != null)
				hParamProc.put("string6", sbChainet[5].toString());
			if (sbChainet[6] != null)
				hParamProc.put("string7", sbChainet[6].toString());

			// on exécute la procedure PLSQL qui met à jour les proposés
			try {

				logBipUser.debug("variable du LOCK" + bipForm.getLock());
				if (!"affecter".equals(type_valider)) {
					if ("N".equals(bipForm.getLock())) {
						jdbc = new JdbcBip();
						vParamOut = jdbc.getResult(hParamProc, configProc,
								PACK_UPDATE);
					}
				}
			} // try
			catch (BaseException be) {
				logBipUser.debug(
						"SaisieConsoAction-consulter() --> BaseException :"
								+ be, be);
				logBipUser
						.debug("SaisieConsoAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				logService.debug(
						"SaisieConsoAction-consulter() --> BaseException :"
								+ be, be);
				logService
						.debug("SaisieConsoAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				if (be.getInitialException().getClass().getName()
						.equals("java.sql.SQLException")) {
					/*BIP 612 changes*/
					String retroIdent="";
					retroIdent=checkRetroAccess(bipForm.getIdent(),((UserBip) request.getSession().getAttribute("UserBip")).getSousMenus().toLowerCase());
					bipForm.setRetroIdent(retroIdent);
					/*End of BIP 612 changes*/
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((SaisieConsoForm) form).setMsgErreur(message);
					jdbc.closeJDBC();
					return mapping.findForward("ecran");
				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					request.setAttribute("messageErreur", be
							.getInitialException().getMessage());
					jdbc.closeJDBC();
					return mapping.findForward("error");
				}
			}
			// annuler la mise à jour
			if (vParamOut == null) {
				session.setAttribute("errorUpdate", "UPDATE");
				logBipUser.debug("!!! update cancelled ");
			} else {

				// on sauvegarde en session la position de la ressource dans la
				// liste déroulante
				session.setAttribute("POSITION", bipForm.getPosition());
				session.setAttribute("POSITION_BLOCKSIZE",
						bipForm.getPosition_blocksize());
				session.setAttribute("ORDRE_TRI", bipForm.getOrdre_tri());
				session.setAttribute("CHOIXRESS", bipForm.getChoix_ress());

			}

		} catch (Exception e) {
			logBipUser.debug(signatureMethode + " --> exception : "
					+ e.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}
		// probleme de memoire
		// hParamProc = null;
		logBipUser.debug("fmemory end : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);

		// bipForm.setPosition("2");
		// session.setAttribute("POSITION", "0");
		session.setAttribute("POSITION", bipForm.getPosition());
		session.setAttribute("POSITION_BLOCKSIZE",
				bipForm.getPosition_blocksize());
		session.setAttribute("ORDRE_TRI", bipForm.getOrdre_tri());
		session.setAttribute("CHOIXRESS", bipForm.getChoix_ress());

		request.setAttribute("indexMenu", "0");

		
		
		
		if ("affecter".equals(type_valider)) {

			// On libere le lock sur la ressource
			reset_lock_user(mapping, form, request, response, errors,
					hParamProc);

			// On détruit le tableau sauvegardé en session
			//session.removeAttribute(CONSOMME_EN_MASSE);

			// session.setAttribute("POSITION", "1");
			// jdbc.closeJDBC(); return consulter(mapping,form, request,
			// response ,
			// errors,hParamProc) ;
			bipForm.setIdent(bipForm.getIdent());
			bipForm.setRessource(bipForm.getRessource());

			session.removeAttribute(CONSOMME_EN_MASSE);
			session.setAttribute(CONSOMME_EN_MASSE, page);
			jdbc.closeJDBC();
			return mapping.findForward("affecter");

		} else {
			if (!listeErreurs.isEmpty()) {
				erreurSupprConsoPresent = ErreurSupprSsTache.getMessage(listeErreurs);
				if (erreurSupprConsoPresent != null) {
					bipForm.setMsgErreur(erreurSupprConsoPresent);
				}
			}
			
			save = bipForm.getSave();
			if (save.equals("OUI")) {

				jdbc.closeJDBC();
				if ("N".equals(bipForm.getLock())){
					/*BIP 612 changes*/
					String retroIdent="";
					retroIdent=checkRetroAccess(bipForm.getIdent(),((UserBip) request.getSession().getAttribute("UserBip")).getSousMenus().toLowerCase());
					bipForm.setRetroIdent(retroIdent);
					/*End od BIP 612 changes*/
					page = (PaginationVector) session
					.getAttribute(CONSOMME_EN_MASSE);
					int currentBlock = page.getCurrentBlock();
					consulter(mapping, bipForm, request, response, errors, hParamProc);
					page = (PaginationVector) session
					.getAttribute(CONSOMME_EN_MASSE);
					session.removeAttribute(CONSOMME_EN_MASSE);
					page.setCurrentBlock(currentBlock);
					session.setAttribute(CONSOMME_EN_MASSE, page);
					return mapping.findForward("ecran");
				}
				else {
					// On libere le lock sur la ressource
					reset_lock_user(mapping, form, request, response, errors,
							hParamProc);
					// On détruit le tableau sauvegardé en session
					session.removeAttribute(CONSOMME_EN_MASSE);
					return mapping.findForward("suite");
				}
			} else {

				// On libere le lock sur la ressource
				reset_lock_user(mapping, form, request, response, errors,
						hParamProc);

				// On détruit le tableau sauvegardé en session
				session.removeAttribute(CONSOMME_EN_MASSE);
				jdbc.closeJDBC();
				return mapping.findForward("suite");
			}

		}

	} // valider

	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		SaisieConsoForm bipForm = (SaisieConsoForm) form;
		ActionForward actionForward = null;
		String retroIdent ="";
		// ******* exécution de la procédure PL/SQL pour verifier le lock de la
		// ressource
		gestion_lock(mapping, form, request, response, errors);

		bipForm.setNbmois("12");
		bipForm.setIsAnneeEntiere(true);
		/*BIP 612 changes*/
		retroIdent=checkRetroAccess(bipForm.getIdent(),((UserBip) request.getSession().getAttribute("UserBip")).getSousMenus().toLowerCase());
		bipForm.setRetroIdent(retroIdent);
		savePage(mapping, form, request, response, errors);
		actionForward = this
				.pageIndex(mapping, form, request, response, errors);

		return actionForward;
	} // refresh

	/**
	 * Méthode savePage : Sauvegarde les proposés en session
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {
		HttpSession session = request.getSession(false);
		PaginationVector page = (PaginationVector) session
				.getAttribute(CONSOMME_EN_MASSE);
		String sous_tache;
		String libSousTache;
		String libTotalPid;
		String consomme = "";
		String choix = "";Object[] paramTest = { (Object) request.getParameter("choix_precedent_" + (page.getCurrentBlock() + 1)) };
		String libChoixOld;
		Class[] parameterString = { String.class };
		Class[] parameterInt = { Integer.class };
		String signatureMethode = "SaisieConso-savePage()";
		String retroIdent="";
		logBipUser.entry(signatureMethode);
		// Sauvegarde du total par mois de la page précédente
		// fiche gamma 214
		SaisieConsoForm bipForm = ((SaisieConsoForm) form);
		
		
		/*BIP 612 changes*/
		retroIdent=checkRetroAccess(bipForm.getIdent(),((UserBip) request.getSession().getAttribute("UserBip")).getSousMenus().toLowerCase());
		bipForm.setRetroIdent(retroIdent);
		// mise a jour du lock sur la ressource
		gestion_lock(mapping, form, request, response, errors);

		// sauvegarde des mois anciens
		saveOldMonths(bipForm);

		if (bipForm.getBlocksize() != null)
			blocksize = Integer.parseInt(bipForm.getBlocksize());

		try {
			Enumeration enumeration = page.elements();
			if (enumeration.hasMoreElements()) {
				Consomme SaisieConso = (Consomme) enumeration.nextElement();
				mapPageForm(bipForm, SaisieConso);
			}
			// récupérer les champs modifiables
			for (int i = 1; i <= blocksize; i++) {
				libSousTache = "sous_tache_" + i;
				libTotalPid = "total_pid_" + i;
				Object[] param2 = { (Object) request.getParameter(libTotalPid) };
				for (Enumeration e = page.elements(); e.hasMoreElements();) {
					Consomme SaisieConso = (Consomme) e.nextElement();
					sous_tache = SaisieConso.getSous_tache();
					for (int j = 1; j <= 12; j++) {

						consomme = "conso_" + i + "_" + j;
						Object[] param1 = { (Object) request
								.getParameter(consomme) };

						if (request.getParameter(libSousTache) != null) {
							if ((request.getParameter(libSousTache))
									.equals(sous_tache)) {
								SaisieConso
										.getClass()
										.getDeclaredMethod("setTotal_pid",
												parameterString)
										.invoke((Object) SaisieConso, param2);
								// On met à jour les consommé de la ligne
								// On doit récupérer les méthodes suivant le
								// mois
								// pour cela, on utilise les méthodes
								// - Method getDeclaredMethod(String name,
								// Class[] parameterTypes) : récupère la bonne
								// méthode
								// - puis Object invoke(Object obj, Object[]
								// args) : exécute la méthode

								if (request.getParameter(consomme) != null) {
									SaisieConso
											.getClass()
											.getDeclaredMethod("setConso_" + j,
													parameterString)
											.invoke((Object) SaisieConso,
													param1);
								}
							} // if
						} // if

					} // for
				} // for
			} // for
			
			//ABN - HP PPM 57735 (GESTION DES FAVORIS) - DEBUT
			Enumeration e = page.elements();
			for (int l = 1; l <= page.getBlockCount(); l++) {

				for (int k = 1; k <= blocksize; k++) {
					if (e.hasMoreElements()) {
						Consomme SaisieConso = (Consomme) e.nextElement();
						// for (Enumeration e = page.elements();
						// e.hasMoreElements();) {
						// Consomme SaisieConso = (Consomme) e.nextElement();
						choix = "choix_precedent_" + k + "_" + l;
						Object[] param3 = { (Object) request
								.getParameter(choix) };

						libChoixOld = "choix_old_" + k + "_" + l;
						Object[] valueChoixOld = { (Object) request
								.getParameter(libChoixOld) };

						if (request.getParameter(choix) != null) {
							SaisieConso.getClass().getDeclaredMethod(
									"setChoix", parameterInt).invoke(
									(Object) SaisieConso,
									new Integer(param3[0] + ""));
						}
						if (request.getParameter(libChoixOld) != null) {
							SaisieConso.getClass().getDeclaredMethod(
									"setChoixOld", parameterInt).invoke(
									(Object) SaisieConso,
									new Integer(valueChoixOld[0] + ""));
						}
					}
					// k++;
					// }
				}

			}
			//ABN - HP PPM 57735 (GESTION DES FAVORIS) - FIN
			
		} catch (NullPointerException npe) {
			logBipUser
					.debug("SaisieConsoAction-savePage-->!!! valeur null dans : "
							+ npe.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (NoSuchMethodException me) {
			logBipUser.debug("Méthode inexistante " + me.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (SecurityException se) {
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (IllegalAccessException ia) {
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (IllegalArgumentException iae) {
			logBipUser.debug("arguments null : " + iae.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (InvocationTargetException ite) {
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}
		session.setAttribute(CONSOMME_EN_MASSE, page);
		logBipUser.exit(signatureMethode);
	} // savePage

	/*
	 * sauvegarde des mois anciens
	 */
	private void saveOldMonths(SaisieConsoForm bipForm) {

		bipForm.setOld_tot_mois_1(bipForm.getTot_mois_1());
		bipForm.setOld_tot_mois_2(bipForm.getTot_mois_2());
		bipForm.setOld_tot_mois_3(bipForm.getTot_mois_3());
		bipForm.setOld_tot_mois_4(bipForm.getTot_mois_4());
		bipForm.setOld_tot_mois_5(bipForm.getTot_mois_5());
		bipForm.setOld_tot_mois_6(bipForm.getTot_mois_6());
		bipForm.setOld_tot_mois_7(bipForm.getTot_mois_7());
		bipForm.setOld_tot_mois_8(bipForm.getTot_mois_8());
		bipForm.setOld_tot_mois_9(bipForm.getTot_mois_9());
		bipForm.setOld_tot_mois_10(bipForm.getTot_mois_10());
		bipForm.setOld_tot_mois_11(bipForm.getTot_mois_11());
		bipForm.setOld_tot_mois_12(bipForm.getTot_mois_12());
	}

	private void reset_lock_user(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {

		Vector vParamOut1 = new Vector();
		JdbcBip jdbc = new JdbcBip();
		ParametreProc paramOut;
		String message = "";
		String signatureMethode = "SaisieConsoAction-reset_lock_user()";
		SaisieConsoForm bipForm = ((SaisieConsoForm) form);

		// suppression des locks de l utilisateur
		try {
			hParamProc.put("fonction", FONCTION_LOCK);
			vParamOut1 = jdbc.getResult(hParamProc, configProc, PACK_LOCK_INIT);

			// Récupération des résultats
			for (Enumeration e = vParamOut1.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				// récupérer le lock
				if (paramOut.getNom().equals("lock")) {
					if (paramOut.getValeur() != null)
						bipForm.setLock((String) paramOut.getValeur());
				} // if
			} // for

		} // try
		catch (BaseException be) {

			logBipUser
					.debug(signatureMethode + " --> BaseException :" + be, be);
			logBipUser.debug(signatureMethode + " --> Exception :"
					+ be.getInitialException().getMessage());
			logService
					.debug(signatureMethode + " --> BaseException :" + be, be);
			logService.debug(signatureMethode + " --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName()
					.equals("java.sql.SQLException")) {

				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SaisieConsoForm) form).setMsgErreur(message);
				// jdbc.closeJDBC(); return mapping.findForward("initial");
				jdbc.closeJDBC();
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc.closeJDBC();
			}
		}
		
		jdbc.closeJDBC();

	}

	private void gestion_lock(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {

		Vector vParamOut1 = new Vector();
		JdbcBip jdbc = new JdbcBip();
		ParametreProc paramOut;
		String message = "";
		String signatureMethode = "SaisieConsoAction-gestion_lock()";
		SaisieConsoForm bipForm = ((SaisieConsoForm) form);
		Hashtable<String, String> hParamProc = new Hashtable<String, String>();

		String userid = ((UserBip) request.getSession().getAttribute("UserBip"))
				.getInfosUser();

		try {

			hParamProc.put("userid", userid);
			hParamProc.put("fonction", FONCTION_LOCK);
			hParamProc.put("ident", (String) bipForm.getIdent());

			vParamOut1 = jdbc.getResult(hParamProc, configProc, PACK_LOCK);

			// pas besoin d'aller plus loin
			if (vParamOut1 == null) {
				logBipUser.debug(signatureMethode + " :!!! cancel forward ");
				logBipUser.exit(signatureMethode);
				jdbc.closeJDBC();
			}

			// Récupération des résultats
			for (Enumeration e = vParamOut1.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					bipForm.setMsgErreur((String) paramOut.getValeur());
				}
				// récupérer le lock
				if (paramOut.getNom().equals("lock")) {
					if (paramOut.getValeur() != null)
						bipForm.setLock((String) paramOut.getValeur());
				} // if
			} // for

		} // try
		catch (BaseException be) {

			logBipUser
					.debug(signatureMethode + " --> BaseException :" + be, be);
			logBipUser.debug(signatureMethode + " --> Exception :"
					+ be.getInitialException().getMessage());
			logService
					.debug(signatureMethode + " --> BaseException :" + be, be);
			logService.debug(signatureMethode + " --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName()
					.equals("java.sql.SQLException")) {

				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SaisieConsoForm) form).setMsgErreur(message);
				// jdbc.closeJDBC(); return mapping.findForward("initial");
				jdbc.closeJDBC();
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc.closeJDBC();
			}
		}
		jdbc.closeJDBC();

	}
	
	protected  ActionForward pagePrecedente(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors ) throws ServletException 
	{
		PaginationVector page ;
		String pageName ;
		SaisieConsoForm bipForm = ((SaisieConsoForm) form);
		
		
		// Si la session gérée par TMP_LOCK a expiré on revient sur la page initial à l'aide de l'action annuler
		if ("O".equals(bipForm.getLock()))
			return annuler(mapping,form, request, response, errors,bipForm.getHParams());
		else
		{
			
			// Extraction du nom de la page
			pageName = (String)request.getParameter("page") ;
			
			// Extraction de la liste à paginer
			page = (PaginationVector)request.getSession(false).getAttribute(pageName);
			
			if ( page != null ) {
				page.getPreviousBlock();
				return mapping.findForward("ecran") ;
			} else {
				errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("error.page.noninitialisee"));
				this.saveErrors(request,errors);		
				return mapping.findForward("error") ;
			}
		}
	}
	
	protected  ActionForward pageIndex(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors ) throws ServletException 
	{
		PaginationVector page ;
		String pageName ;
		String index ;
		HttpSession session = request.getSession(false) ;
		ActionForward actionForward=null;
		SaisieConsoForm bipForm = ((SaisieConsoForm) form);
		
		// Si la session gérée par TMP_LOCK a expiré on revient sur la page initial à l'aide de l'action annuler
		if ("O".equals(bipForm.getLock()))
			return annuler(mapping,form, request, response, errors,bipForm.getHParams());
		else
		{
			// Extraction du nom de la page
			pageName = (String)request.getParameter("page") ;
			
			
			// Extraction de l'index
			index = (String)request.getParameter("index");
			
			
			page = (PaginationVector)session.getAttribute(pageName);
			
			if ( page != null ) {
				page.setBlock(Integer.parseInt(index));
				actionForward = mapping.findForward("ecran") ;
				
			} else {
				errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("error.page.noninitialisee"));	
				actionForward =  mapping.findForward("error") ;
				
			}//else if
			
			
			return actionForward;
		}
	}//pageIndex
	
	protected  ActionForward pageSuivante(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors ) throws ServletException 
	{
		PaginationVector page ;
		String pageName ;
		HttpSession session = request.getSession(false) ;
		SaisieConsoForm bipForm = ((SaisieConsoForm) form);
		
		// Si la session gérée par TMP_LOCK a expiré on revient sur la page initial à l'aide de l'action annuler
		if ("O".equals(bipForm.getLock()))
			return annuler(mapping,form, request, response, errors,bipForm.getHParams());
		else
		{
			// Extraction du nom de la page
			pageName = (String)request.getParameter("page");
			page = (PaginationVector)session.getAttribute(pageName);
			
			if ( page != null ) {
				page.getNextBlock();
				return mapping.findForward("ecran") ;
				
			} else {
				errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("error.page.noninitialisee"));
				this.saveErrors(request,errors);		
				  return mapping.findForward("error") ;
			}
		}
	}
	
	public ActionForward existsConsomme(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="SaisieConsoAction - existsConsomme";

		return traitementAjax(PACK_SOUS_TACHES_EXISTE_CONSO, signatureMethode, mapping, form, response, hParamProc);
	}
	
	//MEH PPM 64935
	public ActionForward existsConsommeDef(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="SaisieConsoAction - existsConsomme";

		return traitementAjax(PACK_SOUS_TACHES_EXISTE_CONSO_DEF, signatureMethode, mapping, form, response, hParamProc);
	}
	private ActionForward traitementAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		BipForm bipForm = (BipForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		
		// Appel de la procédure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du message de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	
	public ActionForward annulerAffect(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		SaisieConsoForm bipForm = ((SaisieConsoForm) form);
		bipForm.setLock("N");
		
		// Extraction du nom de la page
		PaginationVector page = (PaginationVector)request.getSession().getAttribute(CONSOMME_EN_MASSE);
		Enumeration e = page.elements();
		if (e.hasMoreElements()) {
			Consomme SaisieConso = (Consomme) e.nextElement();
			mapFormPage (bipForm, SaisieConso);
		}
		if ( page != null ) {
			/*BIP 612 changes*/
			String retroIdent="";
			retroIdent=checkRetroAccess(bipForm.getIdent(),((UserBip) request.getSession().getAttribute("UserBip")).getSousMenus().toLowerCase());
			bipForm.setRetroIdent(retroIdent);
			/*End of BIP 612 changes*/
			return mapping.findForward("ecran") ;
			
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("error.page.noninitialisee"));
			this.saveErrors(request,errors);		
			  return mapping.findForward("error") ;
		}
		// return mapping.findForward("ecran") ;
	}
	
	public ActionForward validerAffect(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		PaginationVector page = (PaginationVector)request.getSession().getAttribute(CONSOMME_EN_MASSE);
		consulter(mapping, form, request, response, errors, hParamProc);
		HttpSession session = request.getSession(false);
		Vector vListe = new Vector();
		PaginationVector vueListe;
		boolean trouvee;
		SaisieConsoForm bipForm = (SaisieConsoForm) form;
		Enumeration ep = page.elements();
		if (ep.hasMoreElements()) {
			Consomme SaisieConso = (Consomme) ep.nextElement();
			mapFormConsom(bipForm, SaisieConso);
		}
		PaginationVector listePourPagination = (bipForm).getListePourPagination();
		for (Enumeration e = listePourPagination.elements(); e.hasMoreElements();) {
			trouvee = false;
			Consomme SaisieConsom = (Consomme) e.nextElement();
			for (Enumeration el = page.elements(); el.hasMoreElements();) {
				Consomme SaisieConso = (Consomme) el.nextElement();
				if (SaisieConso.getSous_tache() != null && SaisieConso.getSous_tache().equals(SaisieConsom.getSous_tache())) {
					trouvee = true;
					SaisieConsom.setConso_1(SaisieConso.getConso_1());
					SaisieConsom.setConso_2(SaisieConso.getConso_2());
					SaisieConsom.setConso_3(SaisieConso.getConso_3());
					SaisieConsom.setConso_4(SaisieConso.getConso_4());
					SaisieConsom.setConso_5(SaisieConso.getConso_5());
					SaisieConsom.setConso_6(SaisieConso.getConso_6());
					SaisieConsom.setConso_7(SaisieConso.getConso_7());
					SaisieConsom.setConso_8(SaisieConso.getConso_8());
					SaisieConsom.setConso_9(SaisieConso.getConso_9());
					SaisieConsom.setConso_10(SaisieConso.getConso_10());
					SaisieConsom.setConso_11(SaisieConso.getConso_11());
					SaisieConsom.setConso_12(SaisieConso.getConso_12());
					SaisieConsom.setTot_mois_1(SaisieConso.getTot_mois_1());
					SaisieConsom.setTot_mois_2(SaisieConso.getTot_mois_2());
					SaisieConsom.setTot_mois_3(SaisieConso.getTot_mois_3());
					SaisieConsom.setTot_mois_4(SaisieConso.getTot_mois_4());
					SaisieConsom.setTot_mois_5(SaisieConso.getTot_mois_5());
					SaisieConsom.setTot_mois_6(SaisieConso.getTot_mois_6());
					SaisieConsom.setTot_mois_7(SaisieConso.getTot_mois_7());
					SaisieConsom.setTot_mois_8(SaisieConso.getTot_mois_8());
					SaisieConsom.setTot_mois_9(SaisieConso.getTot_mois_9());
					SaisieConsom.setTot_mois_10(SaisieConso.getTot_mois_10());
					SaisieConsom.setTot_mois_11(SaisieConso.getTot_mois_11());
					SaisieConsom.setTot_mois_12(SaisieConso.getTot_mois_12());
					SaisieConsom.setOld_tot_mois_1(SaisieConso.getOld_tot_mois_1());
					SaisieConsom.setOld_tot_mois_2(SaisieConso.getOld_tot_mois_2());
					SaisieConsom.setOld_tot_mois_3(SaisieConso.getOld_tot_mois_3());
					SaisieConsom.setOld_tot_mois_4(SaisieConso.getOld_tot_mois_4());
					SaisieConsom.setOld_tot_mois_5(SaisieConso.getOld_tot_mois_5());
					SaisieConsom.setOld_tot_mois_6(SaisieConso.getOld_tot_mois_6());
					SaisieConsom.setOld_tot_mois_7(SaisieConso.getOld_tot_mois_7());
					SaisieConsom.setOld_tot_mois_8(SaisieConso.getOld_tot_mois_8());
					SaisieConsom.setOld_tot_mois_9(SaisieConso.getOld_tot_mois_9());
					SaisieConsom.setOld_tot_mois_10(SaisieConso.getOld_tot_mois_10());
					SaisieConsom.setOld_tot_mois_11(SaisieConso.getOld_tot_mois_11());
					SaisieConsom.setOld_tot_mois_12(SaisieConso.getOld_tot_mois_12());
					SaisieConsom.setTotal(SaisieConso.getTotal());
					SaisieConsom.setOld_total(SaisieConso.getOld_total());
					SaisieConsom.setChoix(SaisieConso.getChoix());
					SaisieConsom.setChoixOld(SaisieConso.getChoixOld());
					SaisieConsom.setTotal_pid(SaisieConso.getTotal_pid());
					vListe.add(SaisieConsom);
					break;
				}
				
			}
			if(!trouvee) {
				vListe.add(SaisieConsom);
			}
		}
		if (bipForm.getBlocksize() != null)
			blocksize = Integer.parseInt(bipForm.getBlocksize());

		// Construire un PaginationVector contenant les informations du FormBean
		vueListe = new PaginationVector(vListe, blocksize);
		
		bipForm.setListePourPagination(vueListe);
		/*BIP 612 changes*/
		String retroIdent="";
		retroIdent=checkRetroAccess(bipForm.getIdent(),((UserBip) request.getSession().getAttribute("UserBip")).getSousMenus().toLowerCase());
		bipForm.setRetroIdent(retroIdent);
		/*End of BIP 612 changes*/
		// Stocker le résultat dans la session
		// if (session.getAttribute("listeConsos") == null) {
		session.removeAttribute(CONSOMME_EN_MASSE);
		session.setAttribute(CONSOMME_EN_MASSE, vueListe);
		return mapping.findForward("ecran") ;
	}
	
	private void mapFormPage (SaisieConsoForm saisieConsoForm, Consomme consomme) {
		
		saisieConsoForm.setTot_mois_1(consomme.getTot_mois_1());
		saisieConsoForm.setTot_mois_2(consomme.getTot_mois_2());
		saisieConsoForm.setTot_mois_3(consomme.getTot_mois_3());
		saisieConsoForm.setTot_mois_4(consomme.getTot_mois_4());
		saisieConsoForm.setTot_mois_5(consomme.getTot_mois_5());
		saisieConsoForm.setTot_mois_6(consomme.getTot_mois_6());
		saisieConsoForm.setTot_mois_7(consomme.getTot_mois_7());
		saisieConsoForm.setTot_mois_8(consomme.getTot_mois_8());
		saisieConsoForm.setTot_mois_9(consomme.getTot_mois_9());
		saisieConsoForm.setTot_mois_10(consomme.getTot_mois_10());
		saisieConsoForm.setTot_mois_11(consomme.getTot_mois_11());
		saisieConsoForm.setTot_mois_12(consomme.getTot_mois_12());
		saisieConsoForm.setOld_tot_mois_1(consomme.getOld_tot_mois_1());
		saisieConsoForm.setOld_tot_mois_2(consomme.getOld_tot_mois_2());
		saisieConsoForm.setOld_tot_mois_3(consomme.getOld_tot_mois_3());
		saisieConsoForm.setOld_tot_mois_4(consomme.getOld_tot_mois_4());
		saisieConsoForm.setOld_tot_mois_5(consomme.getOld_tot_mois_5());
		saisieConsoForm.setOld_tot_mois_6(consomme.getOld_tot_mois_6());
		saisieConsoForm.setOld_tot_mois_7(consomme.getOld_tot_mois_7());
		saisieConsoForm.setOld_tot_mois_8(consomme.getOld_tot_mois_8());
		saisieConsoForm.setOld_tot_mois_9(consomme.getOld_tot_mois_9());
		saisieConsoForm.setOld_tot_mois_10(consomme.getOld_tot_mois_10());
		saisieConsoForm.setOld_tot_mois_11(consomme.getOld_tot_mois_11());
		saisieConsoForm.setOld_tot_mois_12(consomme.getOld_tot_mois_12());
		saisieConsoForm.setTotal(consomme.getTotal());
		saisieConsoForm.setNbmois(consomme.getNbmois());
		saisieConsoForm.setNbjour_1(consomme.getNbjour_1());
		saisieConsoForm.setNbjour_2(consomme.getNbjour_2());
		saisieConsoForm.setNbjour_3(consomme.getNbjour_3());
		saisieConsoForm.setNbjour_4(consomme.getNbjour_4());
		saisieConsoForm.setNbjour_5(consomme.getNbjour_5());
		saisieConsoForm.setNbjour_6(consomme.getNbjour_6());
		saisieConsoForm.setNbjour_7(consomme.getNbjour_7());
		saisieConsoForm.setNbjour_8(consomme.getNbjour_8());
		saisieConsoForm.setNbjour_9(consomme.getNbjour_9());
		saisieConsoForm.setNbjour_10(consomme.getNbjour_10());
		saisieConsoForm.setNbjour_11(consomme.getNbjour_11());
		saisieConsoForm.setNbjour_12(consomme.getNbjour_12());
		saisieConsoForm.setMois(consomme.getMois());
		saisieConsoForm.setRessource(consomme.getRessource());
		saisieConsoForm.setBlocksize(consomme.getBlocksize());
		saisieConsoForm.setChoix_ress(consomme.getChoix_ress());
		saisieConsoForm.setHParams(consomme.getHParams());
		saisieConsoForm.setIdent(consomme.getIdent());
		saisieConsoForm.setInfosUser(consomme.getInfosUser());
		saisieConsoForm.setKeyList0(consomme.getKeyList0());
		saisieConsoForm.setKeyList1(consomme.getKeyList1());
		saisieConsoForm.setKeyList2(consomme.getKeyList2());
		saisieConsoForm.setKeyList3(consomme.getKeyList3());
		saisieConsoForm.setKeyList4(consomme.getKeyList4());
		saisieConsoForm.setListeCodsg(consomme.getListeCodsg());
		saisieConsoForm.setListeCodsgString(consomme.getListeCodsgString());
		saisieConsoForm.setListeSousTaches(consomme.getListeSousTaches());
		saisieConsoForm.setLock(consomme.getLock());
		saisieConsoForm.setOrdre_tri(consomme.getOrdre_tri());
		saisieConsoForm.setPageAide(consomme.getPageAide());
		saisieConsoForm.setPosition(consomme.getPosition());
		saisieConsoForm.setPosition_blocksize(consomme.getPosition_blocksize());
		saisieConsoForm.setStructLb(consomme.getStructLb());
	}
	
private void mapFormConsom (SaisieConsoForm saisieConsoForm, Consomme consomme) {
		
		saisieConsoForm.setTot_mois_1(consomme.getTot_mois_1());
		saisieConsoForm.setTot_mois_2(consomme.getTot_mois_2());
		saisieConsoForm.setTot_mois_3(consomme.getTot_mois_3());
		saisieConsoForm.setTot_mois_4(consomme.getTot_mois_4());
		saisieConsoForm.setTot_mois_5(consomme.getTot_mois_5());
		saisieConsoForm.setTot_mois_6(consomme.getTot_mois_6());
		saisieConsoForm.setTot_mois_7(consomme.getTot_mois_7());
		saisieConsoForm.setTot_mois_8(consomme.getTot_mois_8());
		saisieConsoForm.setTot_mois_9(consomme.getTot_mois_9());
		saisieConsoForm.setTot_mois_10(consomme.getTot_mois_10());
		saisieConsoForm.setTot_mois_11(consomme.getTot_mois_11());
		saisieConsoForm.setTot_mois_12(consomme.getTot_mois_12());
		saisieConsoForm.setOld_tot_mois_1(consomme.getOld_tot_mois_1());
		saisieConsoForm.setOld_tot_mois_2(consomme.getOld_tot_mois_2());
		saisieConsoForm.setOld_tot_mois_3(consomme.getOld_tot_mois_3());
		saisieConsoForm.setOld_tot_mois_4(consomme.getOld_tot_mois_4());
		saisieConsoForm.setOld_tot_mois_5(consomme.getOld_tot_mois_5());
		saisieConsoForm.setOld_tot_mois_6(consomme.getOld_tot_mois_6());
		saisieConsoForm.setOld_tot_mois_7(consomme.getOld_tot_mois_7());
		saisieConsoForm.setOld_tot_mois_8(consomme.getOld_tot_mois_8());
		saisieConsoForm.setOld_tot_mois_9(consomme.getOld_tot_mois_9());
		saisieConsoForm.setOld_tot_mois_10(consomme.getOld_tot_mois_10());
		saisieConsoForm.setOld_tot_mois_11(consomme.getOld_tot_mois_11());
		saisieConsoForm.setOld_tot_mois_12(consomme.getOld_tot_mois_12());
		saisieConsoForm.setTotal(consomme.getTotal());
}
	
private void mapPageForm (SaisieConsoForm saisieConsoForm, Consomme consomme) {
		
		consomme.setTot_mois_1(saisieConsoForm.getTot_mois_1());
		consomme.setTot_mois_2(saisieConsoForm.getTot_mois_2());
		consomme.setTot_mois_3(saisieConsoForm.getTot_mois_3());
		consomme.setTot_mois_4(saisieConsoForm.getTot_mois_4());
		consomme.setTot_mois_5(saisieConsoForm.getTot_mois_5());
		consomme.setTot_mois_6(saisieConsoForm.getTot_mois_6());
		consomme.setTot_mois_7(saisieConsoForm.getTot_mois_7());
		consomme.setTot_mois_8(saisieConsoForm.getTot_mois_8());
		consomme.setTot_mois_9(saisieConsoForm.getTot_mois_9());
		consomme.setTot_mois_10(saisieConsoForm.getTot_mois_10());
		consomme.setTot_mois_11(saisieConsoForm.getTot_mois_11());
		consomme.setTot_mois_12(saisieConsoForm.getTot_mois_12());
		consomme.setOld_tot_mois_1(saisieConsoForm.getOld_tot_mois_1());
		consomme.setOld_tot_mois_2(saisieConsoForm.getOld_tot_mois_2());
		consomme.setOld_tot_mois_3(saisieConsoForm.getOld_tot_mois_3());
		consomme.setOld_tot_mois_4(saisieConsoForm.getOld_tot_mois_4());
		consomme.setOld_tot_mois_5(saisieConsoForm.getOld_tot_mois_5());
		consomme.setOld_tot_mois_6(saisieConsoForm.getOld_tot_mois_6());
		consomme.setOld_tot_mois_7(saisieConsoForm.getOld_tot_mois_7());
		consomme.setOld_tot_mois_8(saisieConsoForm.getOld_tot_mois_8());
		consomme.setOld_tot_mois_9(saisieConsoForm.getOld_tot_mois_9());
		consomme.setOld_tot_mois_10(saisieConsoForm.getOld_tot_mois_10());
		consomme.setOld_tot_mois_11(saisieConsoForm.getOld_tot_mois_11());
		consomme.setOld_tot_mois_12(saisieConsoForm.getOld_tot_mois_12());
		consomme.setTotal(saisieConsoForm.getTotal());
		consomme.setNbmois(saisieConsoForm.getNbmois());
		consomme.setNbjour_1(saisieConsoForm.getNbjour_1());
		consomme.setNbjour_2(saisieConsoForm.getNbjour_2());
		consomme.setNbjour_3(saisieConsoForm.getNbjour_3());
		consomme.setNbjour_4(saisieConsoForm.getNbjour_4());
		consomme.setNbjour_5(saisieConsoForm.getNbjour_5());
		consomme.setNbjour_6(saisieConsoForm.getNbjour_6());
		consomme.setNbjour_7(saisieConsoForm.getNbjour_7());
		consomme.setNbjour_8(saisieConsoForm.getNbjour_8());
		consomme.setNbjour_9(saisieConsoForm.getNbjour_9());
		consomme.setNbjour_10(saisieConsoForm.getNbjour_10());
		consomme.setNbjour_11(saisieConsoForm.getNbjour_11());
		consomme.setNbjour_12(saisieConsoForm.getNbjour_12());
		consomme.setMois(saisieConsoForm.getMois());
		consomme.setRessource(saisieConsoForm.getRessource());
		consomme.setBlocksize(saisieConsoForm.getBlocksize());
		consomme.setChoix_ress(saisieConsoForm.getChoix_ress());
		consomme.setHParams(saisieConsoForm.getHParams());
		consomme.setIdent(saisieConsoForm.getIdent());
		consomme.setInfosUser(saisieConsoForm.getInfosUser());
		consomme.setKeyList0(saisieConsoForm.getKeyList0());
		consomme.setKeyList1(saisieConsoForm.getKeyList1());
		consomme.setKeyList2(saisieConsoForm.getKeyList2());
		consomme.setKeyList3(saisieConsoForm.getKeyList3());
		consomme.setKeyList4(saisieConsoForm.getKeyList4());
		consomme.setListeCodsg(saisieConsoForm.getListeCodsg());
		consomme.setListeCodsgString(saisieConsoForm.getListeCodsgString());
		consomme.setListeSousTaches(saisieConsoForm.getListeSousTaches());
		consomme.setLock(saisieConsoForm.getLock());
		consomme.setOrdre_tri(saisieConsoForm.getOrdre_tri());
		consomme.setPageAide(saisieConsoForm.getPageAide());
		consomme.setPosition(saisieConsoForm.getPosition());
		consomme.setPosition_blocksize(saisieConsoForm.getPosition_blocksize());
		consomme.setStructLb(saisieConsoForm.getStructLb());
	}
	

/**
 * PPM 57865
 * Recherche de la couleur du fond à mettre pour le mois passé en paramètre
 * @param form
 * @param ident
 * @param mois_annee
 * @param hParamProc
 * @return
 */

public ActionForward couleurFondMois(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
	String signatureMethode ="SaisieConsoAction - couleurFondMois";

	return traitAjaxCouleurFondMois(PACK_COULEUR_FOND_MOIS, signatureMethode, mapping, form, response, hParamProc);
}

//FAD PPM 64579 : Déclaration Méthode couleurFondAnnee pour appeler la procédure stockée
public ActionForward couleurFondAnnee(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
	String signatureMethode ="SaisieConsoAction - couleurFondAnnee";

	return traitAjaxCouleurFondAnnee(PACK_COULEUR_FOND_ANNEE, signatureMethode, mapping, form, response, hParamProc);
}
//FAD PPM 64579 : Fin

private ActionForward traitAjaxCouleurFondMois(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
	logBipUser.entry(signatureMethode);
	
	JdbcBip jdbc = new JdbcBip(); 
	Vector vParamOut;
	ParametreProc paramOut;
	String result = "";
	
	// Appel de la procédure
	try {
		vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
	 	// ----------------------------------------------------------
		for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
			paramOut = (ParametreProc) e.nextElement();

			if (paramOut.getNom().equals("result")) {
				if (paramOut.getValeur() != null) {
					result = (String) paramOut.getValeur();
				}
			}
		}	
	}
	catch (BaseException be) {
		logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
		logService.debug(signatureMethode + " --> BaseException :"+be);
		
		if (!be.getInitialException().getClass().getName().equals(
		"java.sql.SQLException")) {
			// Erreur d'execution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
		} 
	}	
	
	jdbc.closeJDBC();
	
	// Ecriture de la valeur de retour dans la response
	response.setContentType("text/html");
	PrintWriter out = response.getWriter();
	out.println(new String(result.getBytes("utf8"), "iso-8859-1"));
	out.flush();
	
	logBipUser.exit(signatureMethode);
	
	return PAS_DE_FORWARD;
}
//FAD PPM 64579 : Déclaration Méthode Ajax pour appeler la procédure stockée
private ActionForward traitAjaxCouleurFondAnnee(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
	logBipUser.entry(signatureMethode);
	
	JdbcBip jdbc = new JdbcBip(); 
	Vector vParamOut;
	ParametreProc paramOut;
	String result = "";
	
	// Appel de la procédure
	try {
		vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
	 	// ----------------------------------------------------------
		for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
			paramOut = (ParametreProc) e.nextElement();

			if (paramOut.getNom().equals("result")) {
				if (paramOut.getValeur() != null) {
					result = (String) paramOut.getValeur();
				}
			}
		}	
	}
	catch (BaseException be) {
		logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
		logService.debug(signatureMethode + " --> BaseException :"+be);
		
		if (!be.getInitialException().getClass().getName().equals(
		"java.sql.SQLException")) {
			// Erreur d'execution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
		} 
	}	
	
	jdbc.closeJDBC();
	
	// Ecriture de la valeur de retour dans la response
	response.setContentType("text/html");
	PrintWriter out = response.getWriter();
	out.println(new String(result.getBytes("utf8"), "iso-8859-1"));
	out.flush();
	
	logBipUser.exit(signatureMethode);
	
	return PAS_DE_FORWARD;
}
//FAD PPM 64579 : Fin


/*BIP 612 changes*/
public static String checkRetroAccess(String ressIdent,String userid) {
	
	Map<String, Set<Date>>  uniqueRessIdent= new HashMap<String, Set<Date>>();
	String tmpRess=null;
	uniqueRessIdent.put(ressIdent, null);	
	//Tools.checkRetroApplicativeParam(uniqueRessIdent);
	if (!Arrays.asList(userid).contains("retro")) {
		if(!Tools.checkRetroApplicativeParam(uniqueRessIdent).isEmpty()){
			tmpRess= ressIdent;
		}
	}
		
	return tmpRess;
}


















}