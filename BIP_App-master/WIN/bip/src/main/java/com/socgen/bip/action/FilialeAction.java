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
import com.socgen.bip.form.FilialeForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 12/06/2003
 * 
 * Action de mise � jour des Filiales chemin : Administration/Tables/ mise �
 * jour/Filiales pages : fmFilialeAd.jsp et mFilialeAd.jsp pl/sql : filialec.sql
 */
public class FilialeAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "filiale.consulter.proc";

	private static String PACK_INSERT = "filiale.creer.proc";

	private static String PACK_UPDATE = "filiale.modifier.proc";

	private static String PACK_DELETE = "filiale.supprimer.proc";

	private String nomProc;
	
	

	/**
	 * Action qui permet de cr�er un code DPG
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = "FilialeAction-creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// ex�cution de la proc�dure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser.debug("FilialeAction-creer() --> BaseException :"
						+ be);
				logBipUser.debug("FilialeAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("FilialeAction-creer() --> BaseException :"
						+ be);
				logService.debug("FilialeAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entit� d�j� existante, on r�cup�re le message
				((FilialeForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("FilialeAction-creer() --> BaseException :" + be);
			logBipUser.debug("FilialeAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("FilialeAction-creer() --> BaseException :" + be);
			logService.debug("FilialeAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Erreur d''ex�cution de la proc�dure stock�e
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les donn�es li�es � un code Filiale pour
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

		String signatureMethode = "FilialeAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		FilialeForm bipForm = (FilialeForm) form;

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

							bipForm.setFilcode(rset.getString(1));
							bipForm.setFilsigle(rset.getString(2));
							bipForm.setTop_immo(rset.getString(3));
							bipForm.setTop_sdff(rset.getString(4));
							bipForm.setFlaglock(rset.getInt(5));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("FilialeAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("FilialeAction-consulter() --> SQLException :"
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
									.debug("FilialeAction-consulter() --> SQLException-rset.close() :"
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
				// le code Filiale n'existe pas, on r�cup�re le message
				bipForm.setMsgErreur(message);
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("FilialeAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("FilialeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("FilialeAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("FilialeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
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

}
