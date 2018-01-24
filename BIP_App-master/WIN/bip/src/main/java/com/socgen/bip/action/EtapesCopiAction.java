package com.socgen.bip.action;
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
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DateCopiForm;
import com.socgen.bip.form.ListeNotificationCopiForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * 
 * Gestion Axes Stratégique du COPI
 * 
 * @author X060314
 *
 */
public class EtapesCopiAction extends AutomateAction implements BipConstantes {
 
	
	private static String PACK_INSERT = "copi.etapescopi.creer.proc";
  
	private static String PACK_DELETE = "copi.etapescopi.supprimer.proc";
	
	private static String PACK_UPDATE = "copi.etapescopi.modifier.proc";
	
	
	
	protected ActionForward creer(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		 Vector vParamOut = new Vector();
		
		    String message=null;
		    ListeNotificationCopiForm bipForm = (ListeNotificationCopiForm) form;
		   
		    String signatureMethode = this.getClass().getName() +  "-creer(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
			
		    logBipUser.entry(signatureMethode);
			logBipUser.debug("mode de mise à jour:"+"creer");
			
			
			JdbcBip jdbc = new JdbcBip(); 
			
			//On exécute la procédure stockée
			try {
				
				vParamOut=jdbc.getResult ( hParamProc,configProc,PACK_INSERT);
			
				try {
						message=jdbc.recupererResult(vParamOut,"valider");
						
				 	}
				 	catch (BaseException be) {
				 		logBipUser.debug("creer() --> BaseException :"+be);
						logBipUser.debug("creer() --> Exception :"+be.getInitialException().getMessage());
				 		logService.debug("creer() --> BaseException :"+be);
						logService.debug("creer() --> Exception :"+be.getInitialException().getMessage());
						errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
				 	}
			
				 	if (message!=null && !message.equals("")) {
					// on récupère le message 
						bipForm.setMsgErreur(message);
						logBipUser.debug("valider() -->message :"+message);
						
						
					}
				 	
			} catch (BaseException be) {

				logService.debug("creer() --> BaseException :"+be);
				logService.debug("creer() --> Exception :"+be.getInitialException().getMessage());
				logBipUser.debug("creer() --> BaseException :"+be);
				logBipUser.debug("creer() --> Exception :"+be.getInitialException().getMessage());
				//Si exception sql alors extraire le message d'erreur du message global
				if (be.getInitialException().getClass().getName().equals(
				"java.sql.SQLException")) {
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			((DateCopiForm) form).setMsgErreur(message);
			 jdbc.closeJDBC(); return mapping.findForward("ecran");

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
					
			 jdbc.closeJDBC(); return mapping.findForward("ecran") ;

	}// creer
	
	
	//suppresion
	protected ActionForward consulter(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		 Vector vParamOut = new Vector();
		
		    String message=null;
		    ListeNotificationCopiForm bipForm = (ListeNotificationCopiForm) form;
		   
		    String signatureMethode = this.getClass().getName()+"-consulter(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
			
		    logBipUser.entry(signatureMethode);
			logBipUser.debug("mode de mise à jour:"+"supprimer");
			
			
			JdbcBip jdbc = new JdbcBip(); 
			
			//On exécute la procédure stockée
			try {
				
				vParamOut=jdbc.getResult ( hParamProc,configProc,PACK_DELETE);				
			
				try {
						message=jdbc.recupererResult(vParamOut,"valider");
						
				 	}
				 	catch (BaseException be) {
				 		logBipUser.debug("consulter() --> BaseException :"+be);
						logBipUser.debug("consulter() --> Exception :"+be.getInitialException().getMessage());
				 		logService.debug("consulter() --> BaseException :"+be);
						logService.debug("consulter() --> Exception :"+be.getInitialException().getMessage());
						errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
				 	}
			
				 	if (message!=null && !message.equals("")) {
					// on récupère le message 
						bipForm.setMsgErreur(message);
						logBipUser.debug("valider() -->message :"+message);
						
						
					}
				 	
			} catch (BaseException be) {

				logService.debug("consulter() --> BaseException :"+be);
				logService.debug("consulter() --> Exception :"+be.getInitialException().getMessage());
				logBipUser.debug("consulter() --> BaseException :"+be);
				logBipUser.debug("consulter() --> Exception :"+be.getInitialException().getMessage());
				//Si exception sql alors extraire le message d'erreur du message global
				if (be.getInitialException().getClass().getName().equals(
				"java.sql.SQLException")) {
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			((DateCopiForm) form).setMsgErreur(message);
			 jdbc.closeJDBC(); return mapping.findForward("ecran");

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
					
			 jdbc.closeJDBC(); return mapping.findForward("ecran") ;
	}
	//fin suppression
	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		}else if (mode.equals("delete")) {
			cle = PACK_DELETE;
		}else if (mode.equals("update")) {
			cle = PACK_UPDATE;
		}
		  return cle;
	}
}
