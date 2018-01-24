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
import com.socgen.bip.form.DateFactureForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 25/07/2003
 * 
 * Date Facture chemin : Ordonnancemement / Factures / Gestion / Date suivi
 * pages : fDatefactureOr.jsp pl/sql : fdatfact.sql
 */

public class DateFactureAction extends AutomateAction {

	private static String PACK_SELECT = "dateFacture.consulter.proc";

	private static String PACK_UPDATE = "dateFacture.modifier.proc";

	private String nomProc;
	


	/**
	 * Action qui permet de passer à la première page en venant de la validation
	 * de la facture (lignes)
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		 return mapping.findForward("initial");
	}// consulter

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

		String signatureMethode = "DateFactureAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		DateFactureForm bipForm = (DateFactureForm) form;

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
				if (paramOut.getNom().equals("msg_info")) {
					String sMsg_info = (String) paramOut.getValeur();
					logService.debug("msg_info :" + sMsg_info);
					((DateFactureForm) form).setMsg_info(sMsg_info);
				}// if
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setSoclib(rset.getString(1));
							bipForm.setSocfact(rset.getString(2));
							bipForm.setNumfact(rset.getString(3).trim());
							bipForm.setTypfact(rset.getString(4));
							bipForm.setDatfact(rset.getString(5));
							bipForm.setFnom(rset.getString(6));
							bipForm.setFordrecheq(rset.getString(7));
							bipForm.setFenvsec(rset.getString(8));
							bipForm.setFregcompta(rset.getString(9));
							bipForm.setFmodreglt(rset.getString(10));
							bipForm.setFenrcompta(rset.getString(11));
							bipForm.setFburdistr(rset.getString(12));
							bipForm.setFcodepost(rset.getString(13));
							bipForm.setFstatut2(rset.getString(14));
							bipForm.setFaccsec(rset.getString(15));
							bipForm.setFadresse1(rset.getString(16));
							bipForm.setFadresse2(rset.getString(17));
							bipForm.setFadresse3(rset.getString(18));
							bipForm.setFlaglock(rset.getString(19));
							bipForm.setSiren(rset.getString(20));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("DateFactureAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("DateFactureAction-consulter() --> SQLException :"
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
									.debug("DateFactureAction-consulter() --> SQLException-rset.close() :"
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
				// la facture n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug(
					"DateFactureAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("DateFactureAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
					"DateFactureAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("DateFactureAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DateFactureForm) form).setMsgErreur(message);
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

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("update")) {
			cle = PACK_UPDATE;
		}

		  return cle;
	}

}
