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
import com.socgen.bip.form.LigneFactureAffForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author JMA - 03/03/2006
 * 
 * Action permettant d'ajouter un favori à partir de d'une fenêtre Popup
 * 
 * 
 */

public class DetailFactureAction extends AutomateAction {

	private static String PACK_SELECT = "demandeValFact.ligne_fact.proc";

	
	
	/**
	 * Constructor for DetailFactureAction.
	 */
	public DetailFactureAction() {
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
		LigneFactureAffForm lfaForm = (LigneFactureAffForm) form;

		// exécution de la procédure PL/SQL
		try {
			hParamProc.put("socfact", request.getParameter("socfact"));
			hParamProc.put("numfact", request.getParameter("numfact"));
			hParamProc.put("typfact", request.getParameter("typfact"));
			hParamProc.put("datfact", request.getParameter("datfact"));
			hParamProc.put("lnum", request.getParameter("lnum"));
			hParamProc.put("iddem", request.getParameter("iddem"));
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
							lfaForm.setSocfact(rset.getString(1));
							lfaForm.setSoclib(rset.getString(2));
							lfaForm.setNumfact(rset.getString(3));
							lfaForm.setTypfact(rset.getString(4));
							lfaForm.setDatfact(rset.getString(5));
							lfaForm.setLnum(rset.getString(6));
							lfaForm.setNumcont(rset.getString(8));
							lfaForm.setIdent(rset.getString(9));
							lfaForm.setRnom(rset.getString(10));
							lfaForm.setRprenom(rset.getString(11));
							lfaForm.setLmoisprest(rset.getString(12));
							lfaForm.setLcodcompta(rset.getString(13));
							lfaForm.setLmontht(rset.getString(14));
							lfaForm.setCoutj(rset.getString(15));
							lfaForm.setCusag(rset.getString(26));
							lfaForm.setConso(rset.getString(27));
							lfaForm.setEcart(rset.getString(7));
							lfaForm.setMsgErreur(null);
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
				lfaForm.setMsgErreur(message);
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
				((LigneFactureAffForm) form).setMsgErreur(message);
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

}