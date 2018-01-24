package com.socgen.bip.action;



import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ProposeRJHForm;
import com.socgen.cap.fwk.exception.BaseException;


/**
 * @author DSIC/SUP Equipe Bip
 * @author B.AARAB
 *
 * Action struts permet la mise à jour des proposé de lignes des repertition
 * 
 * 
 */
public class ProposeRJHAction extends AutomateAction
{
		
	private static String PACK_UPDATE = "propose_rjh.modifier.proc";
	private int blocksize=10;
	
	
	/**
	  * Constructeur
	  * Aucun traitement
	  */
	public ProposeRJHAction()
	{
		super();
	}
	
	
					
									
									
	/**
		* Méthode valider : Met à jour les proposé pour lignes des repertition
		*/
		protected  ActionForward valider(ActionMapping mapping, ActionForm form ,String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParams ) throws ServletException{
			
			JdbcBip jdbc = new JdbcBip(); 
			Vector vParamOut = new Vector();
			String message="";
			boolean msg=false;
			ParametreProc paramOut;
			
			
			
			HttpSession session = request.getSession(false);
		
			String signatureMethode =
					"ProposeRJHAction-valider(paramProc, mapping, form , request,  response,  errors )";
			logBipUser.entry(signatureMethode);
		
		
			//on exécute la procedure PLSQL qui met à jour les propsés
				try {
					 vParamOut=jdbc.getResult (hParams,configProc,PACK_UPDATE);
				 
					try {
							message=jdbc.recupererResult(vParamOut,"valider");
					} catch (BaseException be) {
							logBipUser.debug("valider() --> BaseException :"+be);
							logBipUser.debug("valider() --> Exception :"+be.getInitialException().getMessage());
							logService .debug("valider() --> BaseException :"+be);
							logService .debug("valider() --> Exception :"+be.getInitialException().getMessage());
							errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
					}
		
					if (message!=null && !message.equals("")) {
					// on récupère le message 
						((ProposeRJHForm)form).setMsgErreur(message);
						logBipUser.debug("valider() -->message :"+message);
					}

					
					

				}//try
				catch (BaseException be) {
					logBipUser.debug("ProposeRJHAction-valider() --> BaseException :"+be, be);
					logBipUser.debug("ProposeRJHAction-valider() --> Exception :"+be.getInitialException().getMessage());
					logService.debug("ProposeRJHAction-valider() --> BaseException :"+be, be);
					logService.debug("ProposeRJHAction-valider() --> Exception :"+be.getInitialException().getMessage());
				
					if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")){
						message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
						((ProposeRJHForm)form).setMsgErreur(message);
						 jdbc.closeJDBC(); return mapping.findForward("ecran");
	
					}
					else {
						//Erreur d''exécution de la procédure stockée
						errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
						request.setAttribute("messageErreur",be.getInitialException().getMessage());	
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}		
				}		 
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward("initial");
			}//valider		
	
		
		
}
					