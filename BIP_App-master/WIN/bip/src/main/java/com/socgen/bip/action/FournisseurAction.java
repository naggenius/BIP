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

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.form.FournisseurForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 28/05/2003
 * 
 * Action mise à jour des fournisseurs (sociétés) chemin :
 * Administration/Tables/ mise à jour/Societe/Foutnisseurs pages :
 * fmFournisseurAd.jsp et mFournisseurAd.jsp pl/sql : agence.sql
 */
public class FournisseurAction extends SocieteAction {

	private static String PACK_SELECT = "fournisseur.consulter.proc";

	private static String PACK_INSERT = "fournisseur.creer.proc";

	private static String PACK_UPDATE = "fournisseur.modifier.proc";

	private static String PACK_DELETE = "fournisseur.supprimer.proc";

	private String nomProc;
	
	
	/**
	 * Action qui permet de créer un code fournisseur
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = "fournisseurAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			hParamProc.put("socfour", "");

			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");

			} catch (BaseException be) {
				logBipUser
						.debug("fournisseurAction -creer() --> BaseException :"
								+ be);
				logBipUser.debug("fournisseurAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService
						.debug("fournisseurAction -creer() --> BaseException :"
								+ be);
				logService.debug("fournisseurAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((FournisseurForm) form).setMsgErreur(message);

				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("fournisseurAction-creer() --> BaseException :"
					+ be);
			logBipUser.debug("fournisseurAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("fournisseurAction-creer() --> BaseException :"
					+ be);
			logService.debug("fournisseurAction-creer() --> Exception :"
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
		FournisseurForm bipForm = (FournisseurForm) form;

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

							bipForm.setSocfour(rset.getString(1));
							bipForm.setSocflib(rset.getString(2));
							bipForm.setFlaglock(rset.getInt(3));
							bipForm.setSoccode(rset.getString(4));
							bipForm.setFsiren(rset.getString(5));
							bipForm.setFrib(rset.getString(6));
							bipForm.setFactif(rset.getString(7));
							
						try{
							bipForm.setFrib1(rset.getString(6).substring(0,5));	//Code Banque	
							bipForm.setFrib2(rset.getString(6).substring(5,10));		//Code Guichet
							bipForm.setFrib3(rset.getString(6).substring(10,21));	//N° de compte
							bipForm.setFrib4(rset.getString(6).substring(21,23));	//Clef RIB
						 } catch (Exception e1) {}//try

							bipForm.setMsgErreur(null);
							
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("fournisseurAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("fournisseurAction-consulter() --> SQLException :"
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
									.debug("fournisseurAction-consulter() --> SQLException-rset.close() :"
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
				// le code fournisseur n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug(
					"fournisseurAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("fournisseurAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
					"fournisseurAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("fournisseurAction-consulter() --> Exception :"
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

	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
	  return mapping.findForward("initial");
	}
	
	protected  ActionForward annuler(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		  return mapping.findForward("depart") ;
	}
}
