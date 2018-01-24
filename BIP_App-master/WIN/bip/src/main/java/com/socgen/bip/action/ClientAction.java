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
import com.socgen.bip.form.ClientForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 9/05/2003
 * 
 * Action de mise à jour des clients MO chemin : Administration/Tables/ mise à
 * jour/Clients pages : fmClientAd.jsp et mClientAd.jsp pl/sql : clientmo.sql
 */
public class ClientAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "client.consulter.proc";

	private static String PACK_INSERT = "client.creer.proc";

	private static String PACK_UPDATE = "client.modifier.proc";

	private static String PACK_DELETE = "client.supprimer.proc";

	private static String PACK_GETLIBCAMO = "libelles.getLibCAMO.proc";

	private String nomProc;
	
	
	/**
	 * Action qui permet de créer un code DPG
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = "ClientAction-creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser.debug("ClientAction-creer() --> BaseException :"
						+ be);
				logBipUser.debug("ClientAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("ClientAction-creer() --> BaseException :"
						+ be);
				logService.debug("ClientAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((ClientForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("ClientAction-creer() --> BaseException :" + be);
			logBipUser.debug("ClientAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ClientAction-creer() --> BaseException :" + be);
			logService.debug("ClientAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Erreur d''exécution de la procédure stockée
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code client pour
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

		String signatureMethode = "ClientAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ClientForm bipForm = (ClientForm) form;

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
							// clicode, filcode, clilib, clisigle, clidir,
							// clidep, clipol, codcamo, libcodcamo, clitopf
							bipForm.setClicode(rset.getString(1));
							bipForm.setFilcode(rset.getString(2));
							bipForm.setClilib(rset.getString(3));
							bipForm.setClisigle(rset.getString(4));
							bipForm.setCliDir(rset.getInt(5));
							bipForm.setCliDep(rset.getString(6));
							bipForm.setCliPole(rset.getString(7));
							bipForm.setCodcamo(rset.getString(8));
							bipForm.setLibCodeCAMO(rset.getString(9));
							bipForm.setClitopf(rset.getString(10));
							bipForm.setTop_diva(rset.getString(11));
							bipForm.setFlaglock(rset.getInt(12));

							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("ClientAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ClientAction-consulter() --> SQLException :"
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
									.debug("ClientAction-consulter() --> SQLException-rset.close() :"
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
				// le code client n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ClientAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ClientAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ClientAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ClientAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		ClientForm bipForm = (ClientForm) form;
		Vector vParamOut = new Vector();

		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_GETLIBCAMO);
			bipForm.setLibCodeCAMO((String) ((ParametreProc) vParamOut
					.elementAt(0)).getValeur());
			bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
					.elementAt(1)).getValeur());
		} catch (BaseException be) {
			logBipUser.debug("ClientAction-refresh() --> BaseException :" + be,
					be);
			logBipUser.debug("ClientAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ClientAction-refresh() --> BaseException :" + be,
					be);
			logService.debug("ClientAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		bipForm.setFocus("codcamo");
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
