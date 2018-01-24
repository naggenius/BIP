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
import com.socgen.bip.form.DateSuiviForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 25/07/2003
 * 
 * Date suivi chemin : Ordonnancemement / Contrats / Date suivi pages :
 * fDatesuiviOr.jsp pl/sql : cdatcont.sql
 */

public class DateSuiviAction extends AutomateAction {

	private static String PACK_SELECT = "dateSuivi.consulter.proc";

	private static String PACK_UPDATE = "dateSuivi.modifier.proc";

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

		String signatureMethode = "DateSuiviAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		DateSuiviForm bipForm = (DateSuiviForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult( hParamProc, configProc, PACK_SELECT);

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
							bipForm.setSoccont(rset.getString(1));
							bipForm.setSoclib(rset.getString(2));
							bipForm.setNumcont(rset.getString(3));
							bipForm.setCav(rset.getString(4));
							bipForm.setCobjet1(rset.getString(5));
							bipForm.setCobjet2(rset.getString(6));
							bipForm.setCodsg(rset.getString(7));
							bipForm.setLibdsg(rset.getString(8));
							bipForm.setCdatsai(rset.getString(9));
							bipForm.setCdatdeb(rset.getString(10));
							bipForm.setCdatfin(rset.getString(11));
							bipForm.setCdatrpol(rset.getString(12));
							bipForm.setCdatdir(rset.getString(13));
							bipForm.setFlaglock(rset.getInt(14));
							bipForm.setSiren(rset.getString(15));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("DateSuiviAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("DateSuiviAction-consulter() --> SQLException :"
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
									.debug("DateSuiviAction-consulter() --> SQLException-rset.close() :"
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
				// le contrat n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("DateSuiviAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("DateSuiviAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("DateSuiviAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("DateSuiviAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DateSuiviForm) form).setMsgErreur(message);
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
