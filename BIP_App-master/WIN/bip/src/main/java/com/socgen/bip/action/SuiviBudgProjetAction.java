/**
 * @author H.MIRI
 *  Action du Suivi du Budget Projets
 * pages  : SuiviBudgProj.jsp
 * 62325
 */

package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
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
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DossierprojForm;
import com.socgen.bip.form.DpcopiForm;
import com.socgen.bip.form.EtapeForm;
import com.socgen.bip.form.StructLbForm;
import com.socgen.bip.form.SuiviBudgProjetForm;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;
import com.socgen.bip.commun.form.EditionForm;

public class SuiviBudgProjetAction extends AutomateAction implements 
		BipConstantes {

	private static String PACK_AFFICHER_TOUS = "dossier.projet.afficher.tous.proc";

	
	
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,HttpServletRequest request,  HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) {
//		 Alimentation du numéro de la nouvelle étape et du jeu 
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

	
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_AFFICHER_TOUS);
			// Récupération des résultats
			SuiviBudgProjetForm bipForm = (SuiviBudgProjetForm) form;
			
		
			
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("p_param7")) {
					bipForm.setDpcode((String) paramOut.getValeur());
					logBipUser.debug("test dpcode : "
							+ bipForm.getDpcode());
				}
				
				else 	if (paramOut.getNom().equals("p_param6")) {
					bipForm.setDp_copi((String) paramOut.getValeur());
					logBipUser.debug("test dp_copi : "
							+ bipForm.getDp_copi());
				}
				
				else if (paramOut.getNom().equals("p_param8")) {
					bipForm.setDp_copi((String) paramOut.getValeur());
					logBipUser.debug("test dp_copi : "
							+ bipForm.getDp_copi());
				}
				
				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					bipForm.setMsgErreur(message);
				}
			}
			
			
			//bipForm.setDpcode("TOUS");
	/*		for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("dpcode")) {
					bipForm.setDpcode((String) paramOut.getValeur());
					logBipUser.debug("test dpcode : "
							+ bipForm.getDpcode());
				}
				
				else 	if (paramOut.getNom().equals("dp_copi")) {
					bipForm.setDp_copi((String) paramOut.getValeur());
					logBipUser.debug("test dp_copi : "
							+ bipForm.getDp_copi());
				}
				
				else if (paramOut.getNom().equals("dpcopiaxemetier")) {
					bipForm.setDpcopiaxemetier((String) paramOut.getValeur());
					logBipUser.debug("test dpcopiaxemetier : "
							+ bipForm.getDpcopiaxemetier());
				}
				
				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					bipForm.setMsgErreur(message);
				}
			}*/
		

		}// try
		catch (BaseException be) {
			logBipUser.debug("EtapeAction-creer() --> BaseException :" + be);
			logBipUser.debug("EtapeAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("EtapeAction-creer() --> BaseException :" + be);
			logService.debug("EtapeAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SuiviBudgProjetForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("error");

			} 
		}

	

		 jdbc.closeJDBC(); return mapping.findForward("initial");
	}
	
	
	
	
	/*protected ActionForward initialiser(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip();
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;
		
		SuiviBudgProjetForm bipForm = (SuiviBudgProjetForm) form;
		
		
//		hParamProc.put("dpcode", "TOUS");
//		hParamProc.put("dp_copi", "TOUS");
//		hParamProc.put("dpcopiaxemetier", "TOUS");

	
		
		bipForm.setDpcode("TOUS");
		bipForm.setDp_copi("TOUS");
		bipForm.setDpcopiaxemetier("TOUS");
		
		

		try {
			vParamOut = jdbc.getResult(hParamProc, configProc,
					PACK_AFFICHER_TOUS);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				/*if (paramOut.getNom().equals("dpcode")) {
					bipForm.setDpcode((String) paramOut.getValeur());
					hParamProc.put("dpcode", "" + (String) paramOut.getValeur());

				}
				
				
				if (paramOut.getNom().equals("dp_copi")) {
					bipForm.setDp_copi((String) paramOut.getValeur());
					hParamProc.put("dp_copi", "" + (String) paramOut.getValeur());

				}
				
				if (paramOut.getNom().equals("dpcopiaxemetier")) {
					bipForm.setDpcopiaxemetier((String) paramOut.getValeur());
					hParamProc.put("dpcopiaxemetier", "" + (String) paramOut.getValeur());

				}
				
				
				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					bipForm.setMsgErreur(message);
				}

			}
			if (!"".equals(message)) {
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				jdbc.closeJDBC();
				return mapping.findForward("ecran");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug(
					"BudgetCopiePropMasseAction-suite() --> BaseException :"
							+ be, be);
			logBipUser
					.debug("BudgetCopiePropMasseAction-suite() --> Exception :"
							+ be.getInitialException().getMessage());

			logService.debug(
					"BudgetCopiePropMasseAction-suite() --> BaseException :"
							+ be, be);
			logService
					.debug("BudgetCopiePropMasseAction-suite() --> Exception :"
							+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName()
					.equals("java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);
				jdbc.closeJDBC();
				return mapping.findForward("ecran");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc.closeJDBC();
				return mapping.findForward("error");
			}

		}

		return mapping.findForward("ecran");
	} 
	*/
	public ActionForward valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProctest ) throws ServletException {
		ActionForward actionForward = super.valider(mapping, form, mode, request, response, errors, hParamProctest);
		
		SuiviBudgProjetForm bipForm = (SuiviBudgProjetForm) form;
		
	
		
		transmettreAttributs(bipForm, request);
		return mapping.findForward("ecran");
//		return actionForward;
	}

	private void transmettreAttributs(SuiviBudgProjetForm bipForm, HttpServletRequest request) {
		request.setAttribute("setMsgErreur", bipForm.getMsgErreur());
	}
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		return mapping.findForward("favoris");
	}

}
