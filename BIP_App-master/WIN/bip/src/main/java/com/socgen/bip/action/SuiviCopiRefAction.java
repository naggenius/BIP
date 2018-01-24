package com.socgen.bip.action;

import java.io.PrintWriter;
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
import com.socgen.bip.form.SuiviCopiRefForm;
import com.socgen.cap.fwk.exception.BaseException;

public class SuiviCopiRefAction extends AutomateAction {
	
	private static String PACK_VERIF_DP = "suivicopi.verif_code_dp";

	protected  ActionForward suite(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProc ) throws ServletException{
		 
		//Spécifique à l'écran Export du COPI-Réalisé
		ActionForward a = null;
		if (request.getParameter("action") != null) {
			String action = request.getParameter("action");
			if (action.equals("controleDP")) {
				try {
					a = controleDP(mapping, form, request, response, errors, hParamProc);
				} catch (Exception e) {
					logBipUser.debug("SuiviCopiRefAction-suite() --> Exception :"
							+ e.getMessage());
				}
				return a;
			}
		}	
		
		return mapping.findForward("suite") ;
	}
	
	/**
	 * Verification de l'existence du dossier projet
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 * @throws Exception
	 */
	public ActionForward controleDP(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	{
		 JdbcBip jdbc = new JdbcBip(); 
		 Vector vParamOut = new Vector();
		 String message = "";
		 ParametreProc paramOut;
		
		 //On écrit le message de retour du pl/sql dans la response
		 response.setContentType("text/html");
		 
		 try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_VERIF_DP);
			//Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
			//récupérer le message
			if (paramOut.getNom().equals("message")) {
				if (null != paramOut.getValeur())
					message = (String) paramOut.getValeur();	
			}
			}
		 }
		 catch (BaseException be) {
			 	logBipUser.debug("SuiviCopiRefAction-controleDP() --> BaseException :"
						+ be, be);
				logBipUser.debug("SuiviCopiRefAction-controleDP() --> Exception :"
						+ be.getInitialException().getMessage());

				logBipUser.debug("SuiviCopiRefAction-controleDP() --> BaseException :"
						+ be, be);
				logBipUser.debug("SuiviCopiRefAction-controleDP() --> Exception :"
						+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du message
				// global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(
							BipException.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((SuiviCopiRefForm) form).setMsgErreur(message);
					jdbc.closeJDBC(); return mapping.findForward("initial");

				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
					request.setAttribute("messageErreur", be.getInitialException()
							.getMessage());
					// this.saveErrors(request,errors);
					jdbc.closeJDBC(); return mapping.findForward("suite");
				}
		 }

			if (!message.equals("")) {
				//Entité déjà existante, on récupère le message 
				/*((SuiviCopiRefForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				
				//on reste sur la même page
				 jdbc.closeJDBC(); return PAS_DE_FORWARD;*/
			
				  // Write the text to response 	   
				  response.setContentType("text/html"); 	   
				  PrintWriter out = response.getWriter(); 	   
				  out.println(message); 	  
				  out.flush(); 	   
				  return mapping.findForward("suite"); 				
			}			

			jdbc.closeJDBC(); 
			return mapping.findForward("PAS_DE_FORWARD");
	}	
	
}
