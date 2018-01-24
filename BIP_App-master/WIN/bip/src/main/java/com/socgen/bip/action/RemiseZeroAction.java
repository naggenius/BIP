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
import com.socgen.bip.form.LigneBipRemZeroForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author DDI 11/10/2005
 *
 * Notification des budgets
 * chemin : Administration/Surveillance/Remise à zéro Ligne BIP
 * pages  : mLigneBipRemZero.jsp
 * pl/sql : ligneBip.sql
 */
public class RemiseZeroAction extends AutomateAction implements BipConstantes{

	private static String PACK_UPDATE = "lignebip.remazero.proc";
	
	private String nomProc;
	
	
	
   	String message="";
		boolean msg=false;

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
		ParametreProc paramOut;
		
	    
	    String signatureMethode =
			"valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		LigneBipRemZeroForm bipForm= (LigneBipRemZeroForm)form ;
		logBipUser.debug("mode de mise à jour:"+mode);

	   	//On exécute la procédure stockée
		try {
		
			vParamOut=jdbc.getResult (hParamProc,configProc,PACK_UPDATE);
		
		
//			Récupération des résultats
					  for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
						paramOut = (ParametreProc) e.nextElement();
		
		               //récupérer le message
		              if (paramOut.getNom().equals("message")) {
			               message=(String)paramOut.getValeur();
			               msg=true;	
		              }
										
			
							  
					  }//for
		
		
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
				((LigneBipRemZeroForm)form).setMsgErreur(message);
			
			  
				      jdbc.closeJDBC(); return mapping.findForward("initial");

			
			}
			else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
		    	request.setAttribute("messageErreur",be.getInitialException().getMessage());
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}//catch	
		
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("initial") ;

	}//valider

}
