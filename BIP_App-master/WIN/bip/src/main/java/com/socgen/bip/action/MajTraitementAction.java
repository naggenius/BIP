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
import com.socgen.bip.form.ListeShellForm;
import com.socgen.cap.fwk.exception.BaseException;

public class MajTraitementAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "shell.consulter.proc";

	private static String PACK_INSERT = "shell.creer.proc";

	private static String PACK_UPDATE = "shell.modifier.proc";
	
	private static String PACK_DELETE = "shell.supprimer.proc";

	
	/**
	 * Action qui permet de créer un code traitement
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		

		String signatureMethode = "MajTraitementAction-creer( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);

		logBipUser.exit(signatureMethode);

		 return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code rubrique pour
	 * la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "MajTraitementAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ListeShellForm bipForm = (ListeShellForm) form;

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
						if (rset.next()) {

							bipForm.setId_shell(rset.getInt(1));
							bipForm.setNom_shell(rset.getString(2));
							bipForm.setNom_fich(rset.getString(3));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("MajTraitementAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("MajTraitementAction-consulter() --> SQLException :"
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
									.debug("MajTraitementAction-suite() --> SQLException-rset.close() :"
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
				// le code rubrique n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("MajTraitementAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("MajTraitementAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("MajTraitementAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("MajTraitementAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ListeShellForm) form).setMsgErreur(message);
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

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		} else if (mode.equals("update")) {
			cle = PACK_UPDATE;
		}else if (mode.equals("delete")) {
			cle = PACK_DELETE;
		}
		  return cle;
	}
}
