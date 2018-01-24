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
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.cap.fwk.exception.BaseException;

public class AuditImmoAction extends AutomateAction implements BipConstantes{
	
	private static String PACK_UPDATE= "auditimmo.modifier.proc";
	
	
	
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProctest) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = null;

		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise � jour:" + mode);
		// On r�cup�re la cl� pour trouver le nom de la proc�dure stock�e dans
		// bip_proc.properties
		
		// On ex�cute la proc�dure stock�e
		try {

			vParamOut = jdbc.getResult(
					hParamProctest, configProc, PACK_UPDATE);

			try {
				message = jdbc.recupererResult(vParamOut, "valider");

			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("valider() --> BaseException :" + be);
				logService.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on r�cup�re le message
				((AutomateForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);
			}

		} catch (BaseException be) {

			logService.debug("valider() --> BaseException :" + be);
			logService.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :" + be);
			logBipUser.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((AutomateForm) form).setMsgErreur(message);
				
			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); return mapping.findForward("ecran");
		

	}// valider

}
