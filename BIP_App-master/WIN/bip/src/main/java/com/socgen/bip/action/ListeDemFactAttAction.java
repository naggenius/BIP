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

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ListeDemFactAttForm;
import com.socgen.bip.metier.DemandeValFactu;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author JMA - 03/03/2006
 * 
 * Action : gestion des demandes en attente de validation
 * 
 */

public class ListeDemFactAttAction extends AutomateAction {

	private static String PACK_SELECT = "demandeValFact.liste.proc";

	private static String PACK_SELECT_DEMANDE = "demandeValFact.select.proc";

	private static String PACK_UPDATE = "demandeValFact.update.proc";

	private static String PACK_SELECT_ALL_FACTURE = "demandeValFact.ligne_toutes_fact.proc";
	
	

	/**
	 * Constructor for ListeDemFactAttAction.
	 */
	public ListeDemFactAttAction() {
		super();
	}

	/**
	 * Action permettant le premier appel de la JSP
	 * 
	 */
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ " - initialiser(paramProc, mapping, form , request,  response,  errors )";
		String methodeName = "-initialiser";
		logBipUser.entry(signatureMethode);
		ListeDemFactAttForm ldfaForm = (ListeDemFactAttForm) form;

		// exécution de la procédure PL/SQL
		try {
			hParamProc.put("mois", "01/2000");
			// hParamProc.put("statut", "");
			// ldfaForm.setStatut("");
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					if ((message != null) && (!message.equals("")))
						msg = true;
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						int prev_iddem = 0;
						while (rset.next()) {
							DemandeValFactu demande = new DemandeValFactu(rset
									.getString(1),
									prev_iddem != rset.getInt(2), rset
											.getInt(2), rset.getTimestamp(3),
									rset.getString(4), rset.getString(5), rset
											.getString(6), rset.getString(7),
									rset.getInt(8), rset.getString(9), rset
											.getString(10), rset.getString(11));
							prev_iddem = rset.getInt(2);
							ldfaForm.setMsgErreur(null);
							ldfaForm.addDemande(demande);
						}
					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						logBipUser.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.error(this.getClass().getName()
											+ methodeName
											+ " --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				} // if
			} // for
			if (msg) {
				// le code Personne n'existe pas, on récupère le message
				ldfaForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());

			logService.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logService.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeDemFactAttForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	/**
	 * Action qui permet de supprimer ou modifier l'ordre d'un favori
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ " - consulter(paramProc, mapping, form , request,  response,  errors )";
		String methodeName = "-consulter";
		logBipUser.entry(signatureMethode);
		ListeDemFactAttForm ldfaForm = (ListeDemFactAttForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					if ((message != null) && (!message.equals("")))
						msg = true;
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						int prev_iddem = 0;
						while (rset.next()) {
							DemandeValFactu demande = new DemandeValFactu(rset
									.getString(1),
									prev_iddem != rset.getInt(2), rset
											.getInt(2), rset.getTimestamp(3),
									rset.getString(4), rset.getString(5), rset
											.getString(6), rset.getString(7),
									rset.getInt(8), rset.getString(9), rset
											.getString(10), rset.getString(11));
							prev_iddem = rset.getInt(2);
							ldfaForm.setMsgErreur(null);
							ldfaForm.addDemande(demande);
						}
					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						logBipUser.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.error(this.getClass().getName()
											+ methodeName
											+ " --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				} // if
			} // for
			if (msg) {
				// le code Personne n'existe pas, on récupère le message
				ldfaForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());

			logService.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logService.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeDemFactAttForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");

	} // consulter

	/**
	 * Action qui permet de visualiser la cause d'une mise en suspens ou les
	 * dates de suivi saisies
	 */
	public ActionForward visualiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ " - visualiser(paramProc, mapping, form , request,  response,  errors )";
		String methodeName = "-visualiser";
		logBipUser.entry(signatureMethode);
		ListeDemFactAttForm ldfaForm = (ListeDemFactAttForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_DEMANDE);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					if ((message != null) && (!message.equals("")))
						msg = true;
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						String snumfact = "";
						while (rset.next()) {
							ldfaForm.setCausesuspens(rset.getString(1));
							ldfaForm.setFaccsec(rset.getString(2));
							ldfaForm.setFregcompta(rset.getString(3));
							ldfaForm.setFstatut2(rset.getString(4));
							ldfaForm.setMsgErreur(null);
							if (snumfact.length() > 0)
								snumfact += ", ";
							snumfact += rset.getString(5);
							ldfaForm.setListeFact(snumfact);
						}
					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						logBipUser.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.error(this.getClass().getName()
											+ methodeName
											+ " --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				} // if
			} // for
			if (msg) {
				ldfaForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());

			logService.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logService.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeDemFactAttForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d'exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("suite");

	} // visualiser

	/**
	 * Action qui permet de supprimer ou modifier l'ordre d'un favori
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ " - creer(paramProc, mapping, form , request,  response,  errors )";
		String methodeName = "-creer";
		logBipUser.entry(signatureMethode);

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_UPDATE);
			try {
				message = jdbc.recupererResult(vParamOut, "valider");
			} catch (BaseException be) {
				logBipUser.debug(this.getClass().getName()
						+ "-creer() --> BaseException :" + be);
				logBipUser.debug(this.getClass().getName()
						+ "-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug(this.getClass().getName()
						+ "-creer() --> BaseException :" + be);
				logService.debug(this.getClass().getName()
						+ "-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (message != null && !message.equals("")) {
				// Entité déjà existante, on récupère le message
				((ListeDemFactAttForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName()
					+ "-creer() --> BaseException :" + be);
			logBipUser.error(this.getClass().getName()
					+ "-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.error(this.getClass().getName()
					+ "-creer() --> BaseException :" + be);
			logService.error(this.getClass().getName()
					+ "-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeDemFactAttForm) form).setMsgErreur(message);
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
		
		 jdbc.closeJDBC(); return consulter(mapping, form, request, response, errors, hParamProc);

	} // creer

	/**
	 * Action qui permet de générer un mail à envoyer au chef de projet
	 */
	public ActionForward mailCP(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = this.getClass().getName()
				+ " - mailCP(paramProc, mapping, form , request,  response,  errors )";
		String methodeName = "-mailCP";
		logBipUser.entry(signatureMethode);
		ListeDemFactAttForm ldfaForm = (ListeDemFactAttForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_ALL_FACTURE);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					if ((message != null) && (!message.equals("")))
						msg = true;
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						String snumfact = "";
						String retourLigne = "%0a";
						int num_fact = 0;
						String ecart = "";
						StringBuffer sbMail = new StringBuffer();
						StringBuffer numFact = new StringBuffer();
						StringBuffer sujetMail = new StringBuffer();
						sujetMail.append("Demande de validation ");
						while (rset.next()) {
							sbMail.append(retourLigne
									+ "Référence de la facture :" + retourLigne
									+ retourLigne);
							sbMail.append("    - N° facture            : "
									+ rset.getString(3) + retourLigne);
							sbMail.append("    - Société               : "
									+ rset.getString(1) + " - "
									+ rset.getString(2) + retourLigne);
							sbMail.append("    - Date facture        : "
									+ rset.getString(5) + retourLigne);
							sbMail.append("    - Montant HT         : "
									+ rset.getString(14) + retourLigne);
							sbMail.append("    - N° contrat           : "
									+ rset.getString(8) + retourLigne);
							sbMail.append("    - Ressource          : "
									+ rset.getString(9) + " - "
									+ rset.getString(10) + " "
									+ rset.getString(11) + retourLigne);
							sbMail.append("    - Mois prestation   : "
									+ rset.getString(12) + retourLigne);
							sbMail.append("    - Coût journalier     : "
									+ rset.getString(15) + retourLigne);
							sbMail.append("    - Nombre de jours  : "
									+ rset.getString(26) + retourLigne);
							sbMail.append("    - Consommé HT     : "
									+ rset.getString(27) + retourLigne);
							sbMail.append("    - Ecart                  : "
									+ rset.getString(7) + retourLigne);
							sbMail.append("    - Code comptable  : "
									+ rset.getString(13) + retourLigne);
							if (num_fact > 0)
								numFact.append(", ");
							numFact.append(rset.getString(3).trim());
							num_fact++;
							ecart = rset.getString(7);
						}
						StringBuffer mail = new StringBuffer();
						mail.append("Bonjour," + retourLigne + retourLigne);
						if (num_fact > 1) {
							mail.append("Les factures "
									+ numFact.toString().trim()
									+ " présentent ");
							sujetMail.append("des factures "
									+ numFact.toString());
						} else {
							mail.append("La facture " + numFact.toString()
									+ " présente ");
							sujetMail.append("de la facture "
									+ numFact.toString());
						}
						mail
								.append("un écart de "
										+ ecart
										+ " euros. Merci de bien vouloir vérifier le consommé de la ressource concernée et répondre par retour de ce mail."
										+ retourLigne);
						mail.append(sbMail.toString());

						ldfaForm.setTexte_mail("mailto:" + ldfaForm.getNom_cp()
								+ "?subject=" + sujetMail.toString() + "&body="
								+ mail.toString());

					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						logBipUser.error(this.getClass().getName()
								+ methodeName + " --> SQLException :" + sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.error(this.getClass().getName()
											+ methodeName
											+ " --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				} // if
			} // for
			if (msg) {
				ldfaForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logBipUser.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());

			logService.error(this.getClass().getName() + methodeName
					+ " --> BaseException :" + be, be);
			logService.error(this.getClass().getName() + methodeName
					+ " --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeDemFactAttForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d'exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return consulter(mapping, form, request, response, errors, hParamProc);

	} // mailCP

}