package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.AnomalieForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 15/07/2003
 * 
 * Validation erreurs chemin : Ressources/BJH/Validation erreurs pages :
 * bAnomalieAd.jsp pl/sql : bjh_ano.sql
 */
public class AnomalieAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "anomalies.consulter.proc";

	private static String PACK_SELECT_UNE = "anomalies.consulter_une.proc";

	private static String PACK_LISTE = "anomalies.lister.proc";

	private static String PACK_UPDATE = "anomalies.modifier.proc";

	private static String PACK_DELETE = "anomalies.supprimer.proc";

	private static String PACK_SELECT_DPG = "bjhDpg.consulter.proc";

	private String nomProc;

	
	
	/**
	 * Action qui permet de visualiser les données
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		// Récupérer le mode
		String sMode = ((AnomalieForm) form).getMode();
		// String test = "dpg";
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "AnomalieAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		AnomalieForm bipForm = (AnomalieForm) form;

		// exécution de la procédure PL/SQL
		try {
			if (sMode.equals("dpg")) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_SELECT_DPG);
			} else if (sMode.equals("ress")) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_SELECT);
			} else if (sMode.equals("une")) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_SELECT_UNE);
			} else if (sMode.equals("liste")) {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_LISTE);
			}

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}

				if (sMode.equals("une")) {
					if (paramOut.getNom().equals("curseur")) {
						// Récupération du Ref Cursor
						ResultSet rset = (ResultSet) paramOut.getValeur();

						try {
							logService.debug("ResultSet");
							if (rset.next()) {
								bipForm.setMatricule(rset.getString(1));
								bipForm.setNom(rset.getString(2));
								bipForm.setPrenom(rset.getString(3));
								bipForm.setMois(rset.getString(4));
								bipForm.setTypeabsence(rset.getString(5));
								bipForm.setCoutgip(rset.getString(6));
								bipForm.setCoutbip(rset.getString(7));
								bipForm.setDateano(rset.getString(8));
								bipForm.setDiff(rset.getString(9));
								bipForm.setEcartcal(rset.getString(10));
								bipForm.setValidation1(rset.getString(11));
								bipForm.setValidation2(rset.getString(12));
								bipForm.setMsgErreur(null);
							} else
								msg = true;

						}// try
						catch (SQLException sqle) {
							logService
									.debug("AnomalieAction-suite() --> SQLException :"
											+ sqle);
							logBipUser
									.debug("AnomalieAction-suite() --> SQLException :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							// this.saveErrors(request,errors);
							 jdbc.closeJDBC(); return mapping.findForward("error");
						} finally {
							try {
								if (rset != null)
									rset.close();
							} catch (SQLException sqle) {
								logBipUser
										.debug("AnomalieAction-suite() --> SQLException-rset.close() :"
												+ sqle);
								// Erreur de lecture du resultSet
								errors.add(ActionErrors.GLOBAL_ERROR,
										new ActionError("11217"));
								 jdbc.closeJDBC(); return mapping.findForward("error");
							}

						}
					}// if
				}// if
				else if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setMatricule(rset.getString(1));
							bipForm.setNom(rset.getString(2));
							bipForm.setPrenom(rset.getString(3));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("AnomalieAction-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("AnomalieAction-suite() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("AnomalieAction-suite() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				}// if
			}// for

		}// try
		catch (BaseException be) {
			logBipUser.debug("AnomalieAction-suite() --> BaseException :" + be,
					be);
			logBipUser.debug("AnomalieAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("AnomalieAction-suite() --> BaseException :" + be,
					be);
			logService.debug("AnomalieAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((AnomalieForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);
		if (sMode.equals("dpg")) {
			 jdbc.closeJDBC(); return mapping.findForward("suite");
		} else if (sMode.equals("une")) {
			 jdbc.closeJDBC(); return mapping.findForward("ecran");
		} else
			 jdbc.closeJDBC(); return mapping.findForward("choix");
	}

	/**
	 * Action qui permet de visualiser les données
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "AnomalieAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		AnomalieForm bipForm = (AnomalieForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_UNE);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
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
							bipForm.setMatricule(rset.getString(1));
							bipForm.setNom(rset.getString(2));
							bipForm.setPrenom(rset.getString(3));
							bipForm.setMois(rset.getString(4));
							bipForm.setTypeabsence(rset.getString(5));
							bipForm.setCoutgip(rset.getString(6));
							bipForm.setCoutbip(rset.getString(7));
							bipForm.setDateano(rset.getString(8));
							bipForm.setDiff(rset.getString(9));
							bipForm.setEcartcal(rset.getString(10));
							bipForm.setValidation1(rset.getString(11));
							bipForm.setValidation2(rset.getString(12));
							bipForm.setMsgErreur(null);
						} else
							msg = true;
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("AnomalieAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("AnomalieAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}// if
			}// for
			if (msg) {
				// le code anomalie n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("AnomalieAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("AnomalieAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("AnomalieAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("AnomalieAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;

		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);
		// On récupère la clé pour trouver le nom de la procédure stockée dans
		// bip_proc.properties
		cle = recupererCle(mode);

		// On exécute la procédure stockée
		try {

			vParamOut = jdbc.getResult(
					hParamProc, configProc, cle);

			try {
				message = jdbc.recupererResult(vParamOut, "valider");

			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("valider() --> BaseException :" + be);
				logService.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on récupère le message
				((AnomalieForm) form).setMsgErreur(message);

			}

		} catch (BaseException be) {

			logService.debug("valider() --> BaseException :" + be);
			logService.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :" + be);
			logBipUser.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((AnomalieForm) form).setMsgErreur(message);

				if (!mode.equals("delete")) {
					 jdbc.closeJDBC(); return mapping.findForward("ecran");
				}
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("choix");

	}// valider

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("update")) {
			cle = PACK_UPDATE;
		} else if (mode.equals("lister")) {
			cle = PACK_LISTE;
		}

		  return cle;
	}

}
