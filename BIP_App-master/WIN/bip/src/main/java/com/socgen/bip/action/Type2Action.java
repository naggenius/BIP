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
import com.socgen.bip.form.Type2Form;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 11/06/2003
 * 
 * Action de mise � jour des Type2 chemin : Administration/Tables/ mise �
 * jour/Type2 pages : fmType2Ad.jsp et mType2Ad.jsp pl/sql : type2.sql
 */
public class Type2Action extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "type2.consulter.proc";

	private static String PACK_INSERT = "type2.creer.proc";

	private static String PACK_UPDATE = "type2.modifier.proc";

	private static String PACK_DELETE = "type2.supprimer.proc";

	private String nomProc;
	

	/**
	 * Method suite : permet l'ouverture de la premi�re page
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		return mapping.findForward("initial");
	}

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

		String signatureMethode = "Type2Action-creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		hParamProc.put("arctype", "");
		((Type2Form) form).setArctype("");
		((Type2Form) form).setTopActif("O");
		// ex�cution de la proc�dure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

		}// try
		catch (BaseException be) {
			logBipUser.debug("Type2Action-creer() --> BaseException :" + be);
			logBipUser.debug("Type2Action-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("Type2Action-creer() --> BaseException :" + be);
			logService.debug("Type2Action-creer() --> Exception :"
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
	 * Action qui permet de visualiser les donn�es li�es � un code Type2 pour la
	 * modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "Type2Action-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		Type2Form bipForm = (Type2Form) form;

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

							bipForm.setArctype(rset.getString(1));
							bipForm.setLibarc(rset.getString(2));
							bipForm.setTopActif(rset.getString(3));
							bipForm.setListeType1(rset.getString(4));
							bipForm.setFlaglock(rset.getInt(5));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("Type2Action-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("Type2Action-consulter() --> SQLException :"
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
									.debug("CentrefraisAction-suite() --> SQLException-rset.close() :"
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
				// le code Type2 n'existe pas, on r�cup�re le message
				bipForm.setMsgErreur(message);
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug(
					"Type2Action-consulter() --> BaseException :" + be, be);
			logBipUser.debug("Type2Action-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
					"Type2Action-consulter() --> BaseException :" + be, be);
			logService.debug("Type2Action-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

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
