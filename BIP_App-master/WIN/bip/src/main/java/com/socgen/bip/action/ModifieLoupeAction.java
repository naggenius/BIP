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

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ModifieLoupeForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author JAL 08/08/2008 Action permettant de modifier un Axe Stratégique via une
 *         fenêtre Popup
 */

public class ModifieLoupeAction extends AutomateAction {
	
 
	
	private static String PACK_UPDATE = "copi.axestrategique.modifier.proc";
	 
  
	/**
	 * Constructor for RecupDPCopiAction.
	 */
	public ModifieLoupeAction() {
		super();
	}
	
	
	/**
	 * Action permettant le premier appel de la JSP
	 */
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		Vector vParamOut = new Vector(); 
		
		String signatureMethode = this.getClass().getName()
				+ " - initialiser creer(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
	 
  
	     //ModifieLoupeForm mform = (ModifieLoupeForm)form ; 
	     //mform.setCodeAxeModifier(request.getParameter("codeAxeModifier")); 
	     
	     
		logBipUser.exit(signatureMethode);
		logBipUser.exit("##### fin méthode initialiser!!");
		return mapping.findForward("initial");
	}

	
	/**
	 * Method valider
	 * Action qui permet d'enregistrer les données pour la création, modification, suppression d'un code client
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 * 
	*/
	
	protected  ActionForward valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProctest ) throws ServletException{
	    Vector vParamOut = new Vector();
	    String cle = null;
	    String message=null;
	    
	    String signatureMethode =
			"valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:"+mode);
		//On récupère la clé pour trouver le nom de la procédure stockée dans bip_proc.properties
		

		ModifieLoupeForm mform = (ModifieLoupeForm) form ; 
		cle=mform.getUpdateProcedure() ; 
		
	 
		JdbcBip jdbc1 = new JdbcBip(); 
		
		//On exécute la procédure stockée
		try {

		
			   vParamOut=jdbc1.getResult ( hParamProctest,configProc,cle);
			   mform.setMajTermine("MAJ_OK");
		
			try {
					message=jdbc1.recupererResult(vParamOut,"valider");
					//mform.setMajTermine("MAJ_OK") ; 
			 	}
			 	catch (BaseException be) {
			 		logBipUser.debug("valider() --> BaseException :"+be);
					logBipUser.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			 		logService .debug("valider() --> BaseException :"+be);
					logService .debug("valider() --> Exception :"+be.getInitialException().getMessage());
					errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
					 jdbc1.closeJDBC(); return mapping.findForward("error");
			 	}
		
			 	if (message!=null && !message.equals("")) {
				// on récupère le message 
					((AutomateForm)form).setMsgErreur(message);
					logBipUser.debug("valider() -->message :"+message);
				}
				
		} catch (BaseException be) {

			logService.debug("valider() --> BaseException :"+be);
			logService.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :"+be);
			logBipUser.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")){
				message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((AutomateForm)form).setMsgErreur(message);
			
				if (!mode.equals("delete")) {
					 jdbc1.closeJDBC(); return mapping.findForward("ecran") ;
				}
			}
			else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
		    	request.setAttribute("messageErreur",be.getInitialException().getMessage());
				 jdbc1.closeJDBC(); return mapping.findForward("error");
			}
		}	
		
	 
		logBipUser.exit(signatureMethode);
		 jdbc1.closeJDBC(); return mapping.findForward("initial") ;

	}//valider

	
	protected String recupererCle(String mode) {
		String cle = null;	
		if (mode.equals("update")) {
			cle = PACK_UPDATE; 
		}		
	    return cle;
	}
	
	
}