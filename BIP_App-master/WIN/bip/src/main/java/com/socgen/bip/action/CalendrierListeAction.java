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
import com.socgen.bip.form.CalendrierListeForm;
import com.socgen.bip.metier.InfosCalendrier;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author J. MAS - 06/02/2006
 * 
 * Action d'affichage du calendrier chemin : Boite à outil/Calendrier pages :
 * bCalendrierAl.jsp pl/sql : calend.sql
 */
public class CalendrierListeAction extends AutomateAction implements
		BipConstantes {

	private static String PACK_SELECT = "calendrier.liste.proc";

	private static String PACK_SELECT_ENTETE = "calendrier.entete.proc";

	private String nomProc;

	
	
	/**
	 * Action qui permet de visualiser les données liées à un code Calendrier
	 * pour la modification et la suppression
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "CalendrierListeAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		CalendrierListeForm bipForm = (CalendrierListeForm) form;

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
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						boolean next = false;
						while (rset.next()) {
							InfosCalendrier ic = new InfosCalendrier(rset
									.getString(1), rset.getString(2), rset
									.getString(3), rset.getString(4), rset
									.getString(5), rset.getString(6));
							double css = rset.getDouble(7);
							if (css < 0) {
								ic.setCss_premens1("case_grise");
							} else if (!next) {
								ic.setCss_premens1("case_rouge");
								next = true;
							}
							css = rset.getDouble(8);
							if (css < 0) {
								ic.setCss_premens2("case_grise");
							} else if (!next) {
								ic.setCss_premens2("case_rouge");
								next = true;
							}
							css = rset.getDouble(9);
							if (css < 0) {
								ic.setCss_mensuelle("case_grise");
							} else if (!next) {
								ic.setCss_mensuelle("case_rouge");
								next = true;
							}
							bipForm.setMsgErreur(null);
							bipForm.addListMois(ic);
						}
					} // try
					catch (SQLException sqle) {
						logService
								.debug("CalendrierListeAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("CalendrierListeAction-consulter() --> SQLException :"
										+ sqle);
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
									.debug("CalendrierListeAction-consulter() --> SQLException-rset.close() :"
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
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"CalendrierListeAction-consulter() --> BaseException :"
							+ be, be);
			logBipUser
					.debug("CalendrierListeAction-consulter() --> Exception :"
							+ be.getInitialException().getMessage());

			logService.debug(
					"CalendrierListeAction-consulter() --> BaseException :"
							+ be, be);
			logService
					.debug("CalendrierListeAction-consulter() --> Exception :"
							+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((CalendrierListeForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} 

		// exécution de la procédure PL/SQL pour récupérer l'entête
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_ENTETE);

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
						while (rset.next()) {
							bipForm.addEntete(rset.getString(2));
							bipForm.setMsgErreur(null);
						}
					} // try
					catch (SQLException sqle) {
						logService
								.debug("CalendrierListeAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("CalendrierListeAction-consulter() --> SQLException :"
										+ sqle);
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
									.debug("CalendrierListeAction-consulter() --> SQLException-rset.close() :"
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
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"CalendrierListeAction-consulter() --> BaseException :"
							+ be, be);
			logBipUser
					.debug("CalendrierListeAction-consulter() --> Exception :"
							+ be.getInitialException().getMessage());

			logService.debug(
					"CalendrierListeAction-consulter() --> BaseException :"
							+ be, be);
			logService
					.debug("CalendrierListeAction-consulter() --> Exception :"
							+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((CalendrierListeForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}// catch

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// suite

}// class
