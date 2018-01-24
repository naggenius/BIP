package com.socgen.bip.action;

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
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.GestBudgForm;
import com.socgen.bip.form.NotificationForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC 25/06/2003
 *
 * Notification des budgets
 * chemin : Administration/Lignes bip/Gestion/notification
 * pages  : fNotificationAd.jsp et mNotificationAd.jsp
 * pl/sql : initbdg.sql
 */
public class NotificationAction extends AutomateAction implements BipConstantes{

	private static String PACK_GRAND_PROJET = "notification.grand_projet.proc";
	private static String PACK_HORS_GRAND_PROJET = "notification.hors_grand_projet.proc";
	private static String PACK_TYPE_9 = "notification.type_9.proc";
	
	private String nomProc;
	
	
   
   	String message="";
		boolean msg=false;

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("1")){
			cle=PACK_GRAND_PROJET;
		}
		else if (mode.equals("2")){
			cle=PACK_HORS_GRAND_PROJET;
		}
		else if (mode.equals("3")){
					cle=PACK_TYPE_9;
				}
				
		  return cle;
	}



protected  ActionForward valider(ActionMapping mapping,
		 ActionForm form,
		 String mode,
		 HttpServletRequest request,
		 HttpServletResponse response,
		 ActionErrors errors,
		 Hashtable hParamProc ) throws ServletException{
	
	    JdbcBip jdbc = new JdbcBip(); 
	    Vector vParamOut = new Vector();
	    String cle = null;
	    String message="";
		boolean msg=false;
		ParametreProc paramOut; //HPPM 58337 - KRA - ajout d'un paramètre
	    
	    String signatureMethode =
			"valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		NotificationForm bipForm= (NotificationForm)form ;
		logBipUser.debug("mode de mise à jour:"+mode);
		//On récupère la clé pour trouver le nom de la procédure stockée dans bip_proc.properties
		cle=recupererCle(mode);

	   	//On exécute la procédure stockée
		try {
		
			vParamOut=jdbc.getResult (hParamProc,configProc,cle);
		
			//try {
					//message=jdbc.recupererResult(vParamOut,"valider");
				// Récupération des résultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					// récupérer le message
					if (paramOut.getNom().equals("message")) {
						message = (String) paramOut.getValeur();

					}
					// récupérer le nombre de notification mis à jour
					if (paramOut.getNom().equals("nbnotif")) {
						String iNbNotif = "";
						try{
							iNbNotif = (String) paramOut.getValeur();
							if(iNbNotif!=null){
								bipForm.setNbNotif(Integer.parseInt(iNbNotif));
							}
						}catch (Exception ex){
							logBipUser.debug("valider() --> BaseException :"+ex);
							logBipUser.debug("valider() --> Exception :"+ex.getMessage());
						}
						
					}
				}
					
//			 	}
//			 	catch (BaseException be) {
//			 		logBipUser.debug("valider() --> BaseException :"+be);
//					logBipUser.debug("valider() --> Exception :"+be.getInitialException().getMessage());
//			 		logService .debug("valider() --> BaseException :"+be);
//					logService .debug("valider() --> Exception :"+be.getInitialException().getMessage());
//					errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
//					//this.saveErrors(request,errors);
//					 jdbc.closeJDBC(); return mapping.findForward("error");
//			 	}
			if (msg) {	
				//on récupère le message 
				bipForm.setMsgErreur(message);
				//on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}	 	
			 	
		}
		catch (BaseException be) {

			logService.debug("valider() --> BaseException :"+be);
			logService.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :"+be);
			logBipUser.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")){
				message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((NotificationForm)form).setMsgErreur(message);
			
				if (!mode.equals("delete")) {
					 jdbc.closeJDBC(); return mapping.findForward("ecran") ;
				}
			}
			else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
		    	request.setAttribute("messageErreur",be.getInitialException().getMessage());
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}	
		
		logBipUser.exit(signatureMethode);
		// HPPM 58337 : on reste sur la même page
		 jdbc.closeJDBC();
		 if(bipForm.getType_init()=="3"){
			 return mapping.findForward("suite");
		 }else{
			 return mapping.findForward("ecran");
		 }
		 //Fin HPPM 58337

	}//valider

}
