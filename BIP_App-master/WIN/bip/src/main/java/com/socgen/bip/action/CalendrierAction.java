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
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.CalendrierForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 22/07/2003
 *
 * Action de mise à jour du calendrier
 * chemin : Administration/Exploitation/MAJ Calendrier
 * pages  : fMajcalendAd.jsp et mMajcalendAd.jsp
 * pl/sql : calend.sql
 */
public class CalendrierAction extends AutomateAction implements BipConstantes{

	private static String PACK_SELECT = "calendrier.consulter.proc";
	private static String PACK_INSERT = "calendrier.creer.proc";
	private static String PACK_UPDATE = "calendrier.modifier.proc";
	//private static String PACK_DELETE = "Calendrier.supprimer.proc";
	private String nomProc;
	
	
	
   /**
	* Action qui permet de créer un code Calendrier
	*/
	protected ActionForward creer(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProc) throws ServletException{
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message="";
		boolean msg=false;
		
		String signatureMethode ="CalendrierAction-creer( mapping, form , request,  response,  errors )";

		//logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		//exécution de la procédure PL/SQL	
		try {
			 	vParamOut=jdbc.getResult (hParamProc,configProc,PACK_SELECT);
			 	try {
					message=jdbc.recupererResult(vParamOut,"creer");
			 	}
			 	catch (BaseException be) {
			 		logBipUser.debug("CalendrierAction-creer() --> BaseException :"+be);
					logBipUser.debug("CalendrierAction-creer() --> Exception :"+be.getInitialException().getMessage());
					logService.debug("CalendrierAction-creer() --> BaseException :"+be);
					logService.debug("CalendrierAction-creer() --> Exception :"+be.getInitialException().getMessage());
					//Erreur de lecture du resultSet
					errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
					//this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
			 	}
				if (!message.equals("")) {
				//Entité déjà existante, on récupère le message 
					((CalendrierForm)form) .setMsgErreur(message);
					logBipUser.debug("message d'erreur:"+message);
					logBipUser.exit(signatureMethode);
				//on reste sur la même page
					 jdbc.closeJDBC(); return mapping.findForward("initial");
				}	
			
		}//try
		catch (BaseException be) {
			logBipUser.debug("CalendrierAction-creer() --> BaseException :"+be);
			logBipUser.debug("CalendrierAction-creer() --> Exception :"+be.getInitialException().getMessage());
			logService.debug("CalendrierAction-creer() --> BaseException :"+be);
			logService.debug("CalendrierAction-creer() --> Exception :"+be.getInitialException().getMessage());
			//Erreur d''exécution de la procédure stockée
			errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
			//this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}	
			
		//logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);
	
	 jdbc.closeJDBC(); return mapping.findForward("ecran");	
	}//creer
	
   /**
	* Action qui permet de visualiser les données liées à un code Calendrier pour la modification et la suppression
	*/
	protected  ActionForward consulter(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProc) throws ServletException{
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message="";
		boolean msg=false;
		ParametreProc paramOut;
		String sMode;
		
		String signatureMethode =
			"CalendrierAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		CalendrierForm bipForm= (CalendrierForm)form ;
		
		//exécution de la procédure PL/SQL	
		try {
			logBipUser.entry("avant lecture");
			 vParamOut=jdbc.getResult ( hParamProc,configProc,PACK_SELECT);
			 logBipUser.entry("lecture ok !!");
			 sMode = ((ParametreProc)vParamOut.get(9)).getValeur().toString();
			 if (sMode.equals("update")){
			 //Récupération des résultats
			 bipForm.setCafin(((ParametreProc)vParamOut.get(0)).getValeur().toString());
			 bipForm.setCalanmois(((ParametreProc)vParamOut.get(1)).getValeur().toString());
			 bipForm.setCcloture(((ParametreProc)vParamOut.get(2)).getValeur().toString());
		     bipForm.setCjours(((ParametreProc)vParamOut.get(3)).getValeur().toString());
			 bipForm.setCnbjourssg(((ParametreProc)vParamOut.get(4)).getValeur().toString());
			 bipForm.setCnbjoursssii(((ParametreProc)vParamOut.get(5)).getValeur().toString());
			 bipForm.setCmensuelle(((ParametreProc)vParamOut.get(6)).getValeur().toString());
			 bipForm.setCpremens1(((ParametreProc)vParamOut.get(7)).getValeur().toString());
			 bipForm.setCpremens2(((ParametreProc)vParamOut.get(8)).getValeur().toString());
			 bipForm.setFlaglock(((ParametreProc)vParamOut.get(10)).getValeur().toString());
			 if( ((ParametreProc)vParamOut.get(11)).getValeur() != null  ){
			 bipForm.setTheorique(((ParametreProc)vParamOut.get(11)).getValeur().toString());
			 }

			 if( ((ParametreProc)vParamOut.get(12)).getValeur() != null  ){
				 bipForm.setDebutBlocageEbis(((ParametreProc)vParamOut.get(12)).getValeur().toString());
			 }			 
			 if( ((ParametreProc)vParamOut.get(13)).getValeur() != null  ){
				 bipForm.setDateDeblocageFacturesEbis(((ParametreProc)vParamOut.get(13)).getValeur().toString());
			 }

			 
			 
			 } 
			 bipForm.setMode(sMode);
	
		}//try
		catch (BaseException be) {
			logBipUser.debug("CalendrierAction-consulter() --> BaseException :"+be, be);
			logBipUser.debug("CalendrierAction-consulter() --> Exception :"+be.getInitialException().getMessage());

			logService.debug("CalendrierAction-consulter() --> BaseException :"+be, be);
			logService.debug("CalendrierAction-consulter() --> Exception :"+be.getInitialException().getMessage());	
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")){
				message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((CalendrierForm)form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial") ;
			}
			else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}	
			

		logBipUser.exit(signatureMethode);
		 
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}
	

	protected String recupererCle(String mode) {
		String cle = null;
		
		if (mode.equals("insert")){
			cle=PACK_INSERT;
		}
		else if (mode.equals("update")){
			cle=PACK_UPDATE;
		}
		
		  return cle;
	}

}
