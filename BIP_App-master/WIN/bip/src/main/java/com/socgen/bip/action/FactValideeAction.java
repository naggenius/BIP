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
import com.socgen.bip.form.FactValideeForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 14/08/2003
 * 
 * Factures / Corr factures validees chemin : Ordonnancemement / Factures /
 * Gestion /corr fact valid pages : fFactValideeOr.jsp pl/sql : facsegl.sql
 */

public class FactValideeAction extends AutomateAction {

	private static String PACK_SELECT = "factValidee.consulter.proc";

	private static String PACK_SELECT2 = "factValidee.consulter2.proc";

	private static String PACK_UPDATE_LIGNE = "factValidee.modligne.proc";

	private static String PACK_UPDATE = "factValidee.modifier.proc";

	private static String PACK_SELECT_LIGNE = "factValidee.consligne.proc";

	private String nomProc;
	
	
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
		String sTest = request.getParameter("test");

		String signatureMethode = "FactValideeAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		FactValideeForm bipForm = (FactValideeForm) form;

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
				// récupérer
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");

						if (rset.next()) {

							bipForm.setSoclib(rset.getString(1));
							bipForm.setSocfact(rset.getString(2));
							bipForm.setNumfact(rset.getString(3));
							bipForm.setTypfact(rset.getString(4));
							bipForm.setDatfact(rset.getString(5));
							bipForm.setFaccsec(rset.getString(6));
							bipForm.setFnumasn(rset.getString(7));
							bipForm.setFregcompta(rset.getString(8));
							bipForm.setFenvsec(rset.getString(9));
							bipForm.setFmodreglt(rset.getString(10));
							bipForm.setFmontht(rset.getString(11));
							bipForm.setFmontttc(rset.getString(12));
							bipForm.setLlibanalyt(rset.getString(13));
							bipForm.setFmoiacompta(rset.getString(14));
							bipForm.setFstatut1(rset.getString(15));
							bipForm.setFstatut2(rset.getString(16));
							bipForm.setFprovsdff1(rset.getString(17));
							bipForm.setFprovsdff2(rset.getString(18));
							bipForm.setFprovsegl1(rset.getString(19));
							bipForm.setFprovsegl2(rset.getString(20));
							bipForm.setFsocfour(rset.getString(21));
							bipForm.setSocflib(rset.getString(22));
							bipForm.setNumcont(rset.getString(23));
							bipForm.setCav(rset.getString(24));
							bipForm.setFdeppole(rset.getString(25));
							bipForm.setFtva(rset.getString(26));
							bipForm.setFlaglock(rset.getString(27));
							bipForm.setMsgErreur(null);
						}

						else
							msg = true;
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("FactValideeAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("FactValideeAction-consulter() --> SQLException :"
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
				// la facture n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try

		catch (BaseException be) {
			logBipUser.debug(
					"FactValideeAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("FactValideeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
					"FactValideeAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("FactValideeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((FactValideeForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);
		if (sTest.equals("lignes")) {
			 jdbc.closeJDBC(); return mapping.findForward("corr");
		}
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	/**
	 * Action qui permet de visualiser les données liées à une ligne de facture
	 * pour la modification
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "FactValideeAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		FactValideeForm bipForm = (FactValideeForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_LIGNE);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}
				if (paramOut.getNom().equals("socfactout")) {
					String sSocfactout = (String) paramOut.getValeur();
					logService.debug("Socfactout :" + sSocfactout);
					((FactValideeForm) form).setSocfact(sSocfactout);
				}// if
				if (paramOut.getNom().equals("soclibout")) {
					String sSoclibout = (String) paramOut.getValeur();
					logService.debug("Soclibout :" + sSoclibout);
					((FactValideeForm) form).setSoclib(sSoclibout);
				}// if
				if (paramOut.getNom().equals("numcontout")) {
					String sNumcontout = (String) paramOut.getValeur();
					logService.debug("Numcontout :" + sNumcontout);
					((FactValideeForm) form).setNumcont(sNumcontout);
				}// if
				if (paramOut.getNom().equals("cavout")) {
					String sCavout = (String) paramOut.getValeur();
					logService.debug("Cavout :" + sCavout);
					((FactValideeForm) form).setCav(sCavout);
				}// if
				if (paramOut.getNom().equals("numfactout")) {
					String sNumfactout = (String) paramOut.getValeur();
					logService.debug("Numfactout :" + sNumfactout);
					((FactValideeForm) form).setNumfact(sNumfactout);
				}// if
				if (paramOut.getNom().equals("typfactout")) {
					String sTypfactout = (String) paramOut.getValeur();
					logService.debug("Typfactout :" + sTypfactout);
					((FactValideeForm) form).setTypfact(sTypfactout);
				}// if
				if (paramOut.getNom().equals("datfactout")) {
					String sDatfactout = (String) paramOut.getValeur();
					logService.debug("Datfactout :" + sDatfactout);
					((FactValideeForm) form).setDatfact(sDatfactout);
				}// if
				if (paramOut.getNom().equals("lnumout")) {
					String sLnumout = (String) paramOut.getValeur();
					logService.debug("Lnumout :" + sLnumout);
					((FactValideeForm) form).setLnum(sLnumout);
				}// if
				if (paramOut.getNom().equals("identout")) {
					String sIdentout = (String) paramOut.getValeur();
					logService.debug("Identout :" + sIdentout);
					((FactValideeForm) form).setIdent(sIdentout);
				}// if
				if (paramOut.getNom().equals("rnomout")) {
					String sRnomout = (String) paramOut.getValeur();
					logService.debug("Rnomout :" + sRnomout);
					((FactValideeForm) form).setRnom(sRnomout);
				}// if
				if (paramOut.getNom().equals("rprenomout")) {
					String sRprenomout = (String) paramOut.getValeur();
					logService.debug("Rprenomout :" + sRprenomout);
					((FactValideeForm) form).setRprenom(sRprenomout);
				}// if
				if (paramOut.getNom().equals("lmonthtout")) {
					String sLmonthtout = (String) paramOut.getValeur();
					logService.debug("Lmonthtout :" + sLmonthtout);
					((FactValideeForm) form).setLmontht(sLmonthtout);
				}// if
				if (paramOut.getNom().equals("lmoisprestout")) {
					String sLmoisprestout = (String) paramOut.getValeur();
					logService.debug("Lmoisprestout :" + sLmoisprestout);
					((FactValideeForm) form).setLmoisprest(sLmoisprestout);
				}// if
				if (paramOut.getNom().equals("lcodcomptaout")) {
					String sLcodcomptaout = (String) paramOut.getValeur();
					logService.debug("Lcodcomptaout :" + sLcodcomptaout);
					((FactValideeForm) form).setLcodcompta(sLcodcomptaout);
				}// if
				if (paramOut.getNom().equals("fsocfourout")) {
					String sFsocfourout = (String) paramOut.getValeur();
					logService.debug("Fsocfourout :" + sFsocfourout);
					((FactValideeForm) form).setFsocfour(sFsocfourout);
				}// if
				if (paramOut.getNom().equals("flaglockout")) {
					String sFlaglockout = (String) paramOut.getValeur();
					logService.debug("Flaglockout :" + sFlaglockout);
					((FactValideeForm) form).setFlaglock(sFlaglockout);
				}// if

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("FactValideeAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("FactValideeAction-consulter() --> SQLException :"
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
									.debug("FactValideeAction-consulter() --> SQLException-rset.close() :"
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
				// le code FactValidee n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug(
					"FactValideeAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("FactValideeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
					"FactValideeAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("FactValideeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("corr2");
	}

	/**
	 * Method valider Action qui permet d'enregistrer les données pour la
	 * création, modification, suppression d'un code client
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @ jdbc.closeJDBC(); return ActionForward
	 * @throws ServletException
	 * 
	 */

	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;
		ParametreProc paramOut;
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
				// Récupération des résultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();
					if (paramOut.getNom().equals("flaglockout")) {
						String sFlaglockout = (String) paramOut.getValeur();
						logService.debug("Flaglockout :" + sFlaglockout);
						((FactValideeForm) form).setFlaglock(sFlaglockout);
					}// if
				}

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
				((FactValideeForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);

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
				((FactValideeForm) form).setMsgErreur(message);
				if (mode.equals("lignes")) {
					 jdbc.closeJDBC(); return mapping.findForward("corr2");
				} else
					 jdbc.closeJDBC(); return mapping.findForward("corr");

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
		if (mode.equals("lignes")) {
			 jdbc.closeJDBC(); return mapping.findForward("corr");
		} else
			 jdbc.closeJDBC(); return mapping.findForward("initial");

	}// valider

	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		FactValideeForm bipForm = (FactValideeForm) form;
		if (bipForm.getMode().equals("annuler")) {
			 return mapping.findForward("corr");
		} else
			  return mapping.findForward("initial");
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("update")) {
			cle = PACK_UPDATE;
		} else if (mode.equals("lignes")) {
			cle = PACK_UPDATE_LIGNE;
		}
		  return cle;
	}

}
