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
import com.socgen.bip.form.ImmeubleForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 10/06/2003
 * 
 * Action de mise à jour des Immeubles chemin : Administration/Tables/ mise à
 * jour/Immeubles pages : fmImmeubleAd.jsp et mImmeubleAd.jsp pl/sql :
 * immeuble.sql
 */
public class ImmeubleAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "immeuble.consulter.proc";

	private static String PACK_INSERT = "immeuble.creer.proc";

	private static String PACK_UPDATE = "immeuble.modifier.proc";

	private static String PACK_DELETE = "immeuble.supprimer.proc";

	private String nomProc;
	
	

	/**
	 * Method suite : permet l'ouverture de la première page
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		return mapping.findForward("initial");
	}

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

		String signatureMethode = "ImmeubleAction-creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		hParamProc.put("icodimm", "");
		((ImmeubleForm) form).setIcodimm("");
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

		}// try
		catch (BaseException be) {
			logBipUser.debug("ImmeubleAction-creer() --> BaseException :" + be);
			logBipUser.debug("ImmeubleAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ImmeubleAction-creer() --> BaseException :" + be);
			logService.debug("ImmeubleAction-creer() --> Exception :"
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
	 * Action qui permet de visualiser les données liées à un code Immeuble pour
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
		String sIadrabr;

		String signatureMethode = "ImmeubleAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ImmeubleForm bipForm = (ImmeubleForm) form;

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
						logService.debug("ResultSet");
						if (rset.next()) {
							// SELECT clicode, substr(clidom,3,3) clidom ,
							// clisigle, clilib, clitopf, flaglock, filcode,
							// clidir, top_oscar
							bipForm.setIcodimm(rset.getString(1));
							bipForm.setFlaglock(rset.getInt(3));
							bipForm.setMsgErreur(null);

							sIadrabr = rset.getString(2);
							if (sIadrabr != null)
								bipForm.setIadrabr(sIadrabr.trim());
							else
								bipForm.setIadrabr(sIadrabr);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("ImmeubleAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ImmeubleAction-consulter() --> SQLException :"
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
									.debug("ImmeubleAction-consulter() --> SQLException-rset.close() :"
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
				// le code Immeuble n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ImmeubleAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ImmeubleAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ImmeubleAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ImmeubleAction-consulter() --> Exception :"
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
