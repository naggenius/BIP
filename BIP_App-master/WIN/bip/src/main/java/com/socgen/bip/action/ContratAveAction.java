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
import com.socgen.bip.form.ContratAveForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 24/07/2003
 * 
 * Choix filiale chemin : Ordonnancemement / Contrats / contrats avenants pages :
 * bContrataveOr.jsp pl/sql : contrat.sql
 */

public class ContratAveAction extends AutomateAction {

	private static String PACK_SELECT = "contrat.consulter.proc";

	private static String PACK_INSERT = "contrat.creer.proc";

	private static String PACK_UPDATE = "contrat.modifier.proc";

	private static String PACK_DELETE = "contrat.supprimer.proc";

	private String nomProc;
	
	
	/**
	 * Action qui permet la création
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = "ContratAveAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);

		ContratAveForm bipForm = (ContratAveForm) form;
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
				// récupérer les paramètres out
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					ParametreProc paramOut = (ParametreProc) e.nextElement();

					// récupérer
					if (paramOut.getNom().equals("socout")) {
						String sSocout = (String) paramOut.getValeur();

						logService.debug("Socout :" + sSocout);
						bipForm.setSoclib(sSocout.trim());
					}// if
					// récupérer
					if (paramOut.getNom().equals("cavout")) {
						String sCavout = (String) paramOut.getValeur();
						logService.debug("Cavout :" + sCavout);
						bipForm.setCav(sCavout);
					}// if

					// récupérer
					if (paramOut.getNom().equals("choixout")) {
						String sChoixout = (String) paramOut.getValeur();
						logService.debug("Choixout :" + sChoixout);
						bipForm.setChoixout(sChoixout);
					}// if

					// récupérer
					if (paramOut.getNom().equals("cnaffout")) {
						String sCnaffout = (String) paramOut.getValeur();
						logService.debug("Cnaffout :" + sCnaffout);
						bipForm.setCnaffair(sCnaffout);
					}// if
					// récupérer
					if (paramOut.getNom().equals("codsg")) {
						String sCodsg = (String) paramOut.getValeur();
						logService.debug("Codsg :" + sCodsg);
						bipForm.setCodsg(sCodsg);
					}// if
					// récupérer
					if (paramOut.getNom().equals("comcode")) {
						String sComcode = (String) paramOut.getValeur();
						logService.debug("Comcode :" + sComcode);
						bipForm.setComcode(sComcode);
					}// if
					if (paramOut.getNom().equals("cobjet1")) {
						String sCobjet1 = (String) paramOut.getValeur();
						logService.debug("Cobjet1 :" + sCobjet1);
						bipForm.setCobjet1(sCobjet1);
					}// if
					if (paramOut.getNom().equals("cobjet2")) {
						String sCobjet2 = (String) paramOut.getValeur();
						logService.debug("Cobjet2 :" + sCobjet2);
						bipForm.setCobjet2(sCobjet2);
					}

				}// for

			} catch (BaseException be) {
				logBipUser
						.debug("ContratAveAction -creer() --> BaseException :"
								+ be);
				logBipUser.debug("ContratAveAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService
						.debug("ContratAveAction -creer() --> BaseException :"
								+ be);
				logService.debug("ContratAveAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((ContratAveForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("ContratAveAction-creer() --> BaseException :"
					+ be);
			logBipUser.debug("ContratAveAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ContratAveAction-creer() --> BaseException :"
					+ be);
			logService.debug("ContratAveAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}// if
		}// catch

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code ContratAve
	 * pour la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "ContratAveAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ContratAveForm bipForm = (ContratAveForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);

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

							bipForm.setSoccont(rset.getString(1).trim());
							bipForm.setSoclib(rset.getString(2));
							bipForm.setNumcont(rset.getString(3).trim());
							bipForm.setCav(rset.getString(4));
							bipForm.setCagrement(rset.getString(5));
							bipForm.setNiche(rset.getString(6));
							bipForm.setCnaffair(rset.getString(7));
							bipForm.setCrang(rset.getString(8));
							bipForm.setCdatarr(rset.getString(9));
							bipForm.setCobjet1(rset.getString(10));
							bipForm.setCobjet2(rset.getString(11));
							bipForm.setCrem(rset.getString(12));
							bipForm.setCodsg(rset.getString(13));
							bipForm.setComcode(rset.getString(14));
							bipForm.setCtypfact(rset.getString(15));
							bipForm.setCcoutht(rset.getString(16));
							bipForm.setCcharesti(rset.getString(17));
							bipForm.setCdatdeb(rset.getString(18));
							bipForm.setCdatfin(rset.getString(19));
							bipForm.setFlaglock(rset.getInt(20));
							bipForm.setSiren(rset.getString(21));
							bipForm.setCsourcecontrat(rset.getString(22));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("ContratAveAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ContratAveAction-consulter() --> SQLException :"
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
									.debug("ContratAveAction-consulter() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				}// if
			}// for
			if (msg) {
				// le code ContratAve n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ContratAveAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ContratAveAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ContratAveAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ContratAveAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}// if
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		} else if (mode.equals("update")) {
			cle = PACK_UPDATE;
		} else if (mode.equals("delete")) {
			cle = PACK_DELETE;
		}
		  return cle;
	}

	/**
	 * Action qui permet d'ouvrir sur la page de composition des lignes contrat
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "ContratAveAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ContratAveForm bipForm = (ContratAveForm) form;
		

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);

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

							bipForm.setSoclib(rset.getString(2));
							bipForm.setNumcont(rset.getString(3));
							bipForm.setCav(rset.getString(4));
							bipForm.setCtypfact(rset.getString(15));
							bipForm.setCdatdeb(rset.getString(18));
							bipForm.setCdatfin(rset.getString(19));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("ContratAveAction-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ContratAveAction-suite() --> SQLException :"
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
									.debug("ContratAveAction-suite() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				}// if
			}// for
			if (msg) {
				// le code n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ContratAveAction-suite() --> BaseException :"
					+ be, be);
			logBipUser.debug("ContratAveAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ContratAveAction-suite() --> BaseException :"
					+ be, be);
			logService.debug("ContratAveAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ContratAveForm) form).setMsgErreur(message);
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

		 jdbc.closeJDBC(); return mapping.findForward("suite");
	}
}
