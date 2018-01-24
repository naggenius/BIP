package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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
import com.socgen.bip.form.RapportTableRepartForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author J. MAS - 16/11/2005
 * 
 * Action de Rapport des chargements des tables de répartition chemin :
 * Administration/Lignes BIP/Répartition JH/Rapport pages : pl/sql :
 */
public class RapportTableRepartAction extends AutomateAction implements
		BipConstantes {

	private static String PACK_SELECT = "rjh_rapport_tr.consulter.proc";

	private static String PACK_SELECT_ALL = "rjh_rapport_tr.liste.proc";

	private static String PACK_SELECT_DETAIL = "rjh_rapport_tr.detail.proc";

	private static String PACK_SELECT_ERREUR = "rjh_rapport_tr.erreur.proc";

	private static String PACK_DELETE = "rjh_rapport_tr.supprimer.proc";

	private static String PACK_DELETE_ALL = "rjh_rapport_tr.purger.proc";
	
	

	/**
	 * Action qui permet de visualiser les données
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "RapportTableRepartAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		RapportTableRepartForm bipForm = (RapportTableRepartForm) form;

		ArrayList alChg = new ArrayList();

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_ALL);

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
						while (rset.next()) {
							RapportTableRepartForm fTemp = new RapportTableRepartForm();
							fTemp.setCodchr(rset.getInt(1));
							fTemp.setCodrep(rset.getString(2));
							fTemp.setMoisrep(rset.getString(3));
							fTemp.setNomFichier(rset.getString(4));
							fTemp.setStatut(rset.getInt(5));
							fTemp.setDatechg(rset.getString(6));
							fTemp.setMoisfin(rset.getString(7));

							alChg.add(fTemp);

							bipForm.setMsgErreur(null);
						}
						if (alChg.size() == 0)
							msg = true;
						else
							bipForm.setListeChg(alChg);

					} // try
					catch (SQLException sqle) {
						logService
								.debug("RapportTableRepartAction-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("RapportTableRepartAction-suite() --> SQLException :"
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
									.debug("RapportTableRepartAction-suite() --> SQLException-rset.close() :"
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
				// le code client n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser
					.debug(
							"RapportTableRepartAction-suite() --> BaseException :"
									+ be, be);
			logBipUser.debug("RapportTableRepartAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService
					.debug(
							"RapportTableRepartAction-suite() --> BaseException :"
									+ be, be);
			logService.debug("RapportTableRepartAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("initial");
	}

	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		String signatureMethode = "RapportTableRepartAction-refresh(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.exit(signatureMethode);

		
		 return suite(mapping, form, request, response, errors, hParamProc);
		//  jdbc.closeJDBC(); return mapping.findForward("initial");
	}

	/**
	 * Action qui permet de visualiser les données
	 */
	public ActionForward purger(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "RapportTableRepartAction-purger(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		RapportTableRepartForm bipForm = (RapportTableRepartForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_DELETE_ALL);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser
						.debug("RapportTableRepartAction-purger() --> BaseException :"
								+ be);
				logBipUser
						.debug("RapportTableRepartAction-purger() --> Exception :"
								+ be.getInitialException().getMessage());
				logService
						.debug("RapportTableRepartAction-purger() --> BaseException :"
								+ be);
				logService
						.debug("RapportTableRepartAction-purger() --> Exception :"
								+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if ((message != null) && (message.length() > 0)) {
				// Problème lors de la suppression
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"RapportTableRepartAction-purger() --> BaseException :"
							+ be, be);
			logBipUser
					.debug("RapportTableRepartAction-purger() --> Exception :"
							+ be.getInitialException().getMessage());

			logService.debug(
					"RapportTableRepartAction-purger() --> BaseException :"
							+ be, be);
			logService
					.debug("RapportTableRepartAction-purger() --> Exception :"
							+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return suite(mapping, form, request, response, errors, hParamProc);
		//  jdbc.closeJDBC(); return mapping.findForward("suite");
	}

	/**
	 * Action qui permet de visualiser les données
	 */
	public ActionForward detail(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "RapportTableRepartAction-detail(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		RapportTableRepartForm bipForm = (RapportTableRepartForm) form;

		ArrayList alChg = new ArrayList();

		// exécution de la procédure PL/SQL Selection de l'ENTETE
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
						if (rset.next()) {
							bipForm.setCodchr(rset.getInt(1));
							bipForm.setCodrep(rset.getString(2));
							bipForm.setMoisrep(rset.getString(3));
							bipForm.setNomFichier(rset.getString(4));
							bipForm.setStatut(rset.getInt(5));
							bipForm.setDatechg(rset.getString(6));
							bipForm.setMoisfin(rset.getString(7));
							bipForm.setMsgErreur(null);
						}

					} // try
					catch (SQLException sqle) {
						logService
								.debug("RapportTableRepartAction-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("RapportTableRepartAction-suite() --> SQLException :"
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
									.debug("RapportTableRepartAction-suite() --> SQLException-rset.close() :"
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
				// le code client n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser
					.debug(
							"RapportTableRepartAction-suite() --> BaseException :"
									+ be, be);
			logBipUser.debug("RapportTableRepartAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService
					.debug(
							"RapportTableRepartAction-suite() --> BaseException :"
									+ be, be);
			logService.debug("RapportTableRepartAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		} 

		// exécution de la procédure PL/SQL pour récupérer les ERREURS
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_ERREUR);

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
						ArrayList nErr = new ArrayList();
						ArrayList tErr = new ArrayList();
						ArrayList eErr = new ArrayList();
						while (rset.next()) {
							nErr.add(new Integer(rset.getInt(2)));
							tErr.add(rset.getString(3));
							eErr.add(rset.getString(4));
						}
						bipForm.setNumLigne(nErr);
						bipForm.setTxtLigne(tErr);
						bipForm.setErrLigne(eErr);

					} // try
					catch (SQLException sqle) {
						logService
								.debug("RapportTableRepartAction-detail() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("RapportTableRepartAction-detail() --> SQLException :"
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
									.debug("RapportTableRepartAction-detail() --> SQLException-rset.close() :"
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
				// on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"RapportTableRepartAction-detail() --> BaseException :"
							+ be, be);
			logBipUser
					.debug("RapportTableRepartAction-detail() --> Exception :"
							+ be.getInitialException().getMessage());

			logService.debug(
					"RapportTableRepartAction-detail() --> BaseException :"
							+ be, be);
			logService
					.debug("RapportTableRepartAction-detail() --> Exception :"
							+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			 jdbc.closeJDBC(); return mapping.findForward("error");
		} 

		// exécution de la procédure PL/SQL pour récupérer le DETAIL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_DETAIL);

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
						ArrayList tPID = new ArrayList();
						ArrayList lPID = new ArrayList();
						ArrayList tTAUX = new ArrayList();
						ArrayList tLIB = new ArrayList();
						ArrayList tCA = new ArrayList();
						ArrayList lCA = new ArrayList();
						while (rset.next()) {
							tPID.add(rset.getString(3));
							lPID.add(rset.getString(4));
							tTAUX.add(rset.getString(5));
							tLIB.add(rset.getString(6));
							tCA.add(rset.getString(7));
							lCA.add(rset.getString(8));
						}
						bipForm.setPid(tPID);
						bipForm.setLibPID(lPID);
						bipForm.setTauxrep(tTAUX);
						bipForm.setLiblignerep(tLIB);
						bipForm.setCodcamo(tCA);
						bipForm.setLibCodcamo(lCA);

					} // try
					catch (SQLException sqle) {
						logService
								.debug("RapportTableRepartAction-detail() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("RapportTableRepartAction-detail() --> SQLException :"
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
									.debug("RapportTableRepartAction-detail() --> SQLException-rset.close() :"
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
				// on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"RapportTableRepartAction-detail() --> BaseException :"
							+ be, be);
			logBipUser
					.debug("RapportTableRepartAction-detail() --> Exception :"
							+ be.getInitialException().getMessage());

			logService.debug(
					"RapportTableRepartAction-detail() --> BaseException :"
							+ be, be);
			logService
					.debug("RapportTableRepartAction-detail() --> Exception :"
							+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	/**
	 * Action qui permet de supprimer un chargement
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "RapportTableRepartAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		RapportTableRepartForm bipForm = (RapportTableRepartForm) form;

		if (bipForm.getMode().equals("delete")) {
			// exécution de la procédure PL/SQL
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_DELETE);
				try {
					message = jdbc.recupererResult(vParamOut, "creer");
				} catch (BaseException be) {
					logBipUser
							.debug("RapportTableRepartAction-consulter() --> BaseException :"
									+ be);
					logBipUser
							.debug("RapportTableRepartAction-consulter() --> Exception :"
									+ be.getInitialException().getMessage());
					logService
							.debug("RapportTableRepartAction-consulter() --> BaseException :"
									+ be);
					logService
							.debug("RapportTableRepartAction-consulter() --> Exception :"
									+ be.getInitialException().getMessage());
					// Erreur de lecture du resultSet
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11217"));
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
				if ((message != null) && (message.length() > 0)) {
					// Problème lors de la suppression
					bipForm.setMsgErreur(message);
					// on reste sur la même page
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				}
			} // try
			catch (BaseException be) {
				logBipUser.debug(
						"RapportTableRepartAction-consulter() --> BaseException :"
								+ be, be);
				logBipUser
						.debug("RapportTableRepartAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());

				logService.debug(
						"RapportTableRepartAction-consulter() --> BaseException :"
								+ be, be);
				logService
						.debug("RapportTableRepartAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

				 jdbc.closeJDBC(); return mapping.findForward("error");
			} 
		}// if

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return suite(mapping, form, request, response, errors, hParamProc);
		//  jdbc.closeJDBC(); return mapping.findForward("initial");
	}

}
