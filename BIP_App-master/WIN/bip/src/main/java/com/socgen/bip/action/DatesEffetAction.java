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
import com.socgen.bip.form.DatesEffetForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author YNI - 19/05/2010
 * 
 * Action de mise � jour des dates effet : Administration/Tables/ mise �
 * jour/Dates Effet pages : fmDatesEffetAd.jsp et mDatesEffetAd.jsp pl/sql :
 * dateseffet.sql
 */
public class DatesEffetAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "dateseffet.consulter.proc";

	private static String PACK_INSERT = "dateseffet.creer.proc";

	private static String PACK_UPDATE = "dateseffet.modifier.proc";

	private static String PACK_DELETE = "dateseffet.supprimer.proc";
	
	private String nomProc;
	
	

	/**
	 * Action qui permet de cr�er une date effet
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "dateEffetAction-creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// ex�cution de la proc�dure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");

			} catch (BaseException be) {
				logBipUser.debug("dateEffetAction-creer() --> BaseException :"
						+ be);
				logBipUser.debug("dateEffetAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("dateEffetAction-creer() --> BaseException :"
						+ be);
				logService.debug("dateEffetAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entit� d�j� existante, on r�cup�re le message

				message = "Date effet d�j� existante";

				((DatesEffetForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("dateEffetAction-creer() --> BaseException :" + be);
			logBipUser.debug("dateEffetAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("dateEffetAction-creer() --> BaseException :" + be);
			logService.debug("dateEffetAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DatesEffetForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les donn�es li�es � une date effet pour
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

		String signatureMethode = "dateEffetAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		DatesEffetForm bipForm = (DatesEffetForm) form;

		// ex�cution de la proc�dure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setCodaction(rset.getString(1));
							bipForm.setCodversion(rset.getString(2));
							bipForm.setCommentaire(rset.getString(3));
							bipForm.setDateffet(rset.getString(4));
							bipForm.setHeureffet(rset.getString(5));
							bipForm.setDatfin(rset.getString(6));
							bipForm.setHeurfin(rset.getString(7));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("dateEffetAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("dateEffetAction-consulter() --> SQLException :"
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
									.debug("dateEffetAction-suite() --> SQLException-rset.close() :"
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
				// la date effet n'existe pas, on r�cup�re le message
				bipForm.setMsgErreur(message);
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("datesEffetAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("datesEffetAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("datesEffetAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("datesEffetAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DatesEffetForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
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
		} else if (mode.equals("delete")) {
			cle = PACK_DELETE;
		}
		  return cle;
	}
	
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		String signatureMethode = "DateEffetAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);

		 return mapping.findForward("suite");
	}

}
