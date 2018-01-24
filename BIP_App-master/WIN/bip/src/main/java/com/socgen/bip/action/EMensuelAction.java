package com.socgen.bip.action;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.ReportAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.exception.ReportException;
import com.socgen.bip.form.EMensuelForm;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

public class EMensuelAction  extends ReportAction
{
	static Config configProc = ConfigManager.getInstance("bip_reports_proc") ;

	public EMensuelAction() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public ActionForward bipPerform(	ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response,
			Hashtable hParamProc)
			throws ReportException, IOException
	{
		
		EMensuelForm rForm = (EMensuelForm)form ;
		String action = null;
		JdbcBip jdbc = new JdbcBip();
		//Extraction de la valeur action
		action = rForm.getAction() ;
		
	
		if(ACTION_REFRESH.equals(action))
		{
			  
			   Vector vParamOut = new Vector();
			   ParametreProc paramOut;
			   String message="";
			   HttpSession session;
			   session = request.getSession(false);
			com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
						
		
				try {
					
					//on verifie d'abord l'existence et l'habilitation
					hParamProc.put("P_param6", ""+request.getParameter("p_param6"));
					hParamProc.put("P_global", ""+rForm.getInfosUser());
					  vParamOut=jdbc.getResult (hParamProc,configProc,"report.select_verif_deppole_mens2");
					   for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
							paramOut = (ParametreProc) e.nextElement();
							if (paramOut.getNom().equals("message"))
								 message=(String)paramOut.getValeur();
						
					   }
					   
					  //On recharge la même page(ecran) s'il n'y a pas de message d'erreur
					   if(message!=null)
					   {
						  
						rForm.setMsgErreur(message);
						rForm.setP_param6(user.getDpg_Defaut_Etoile());
						
					   }
					 jdbc.closeJDBC(); return mapping.findForward("ecran") ; 
					
				}
	
				catch (BaseException be) {
					//Si exception sql alors extraire le message d'erreur du message global
					if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")){
						message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
						rForm.setMsgErreur(message);
						rForm.setP_param6(user.getDpg_Defaut_Etoile());
					}
					else {
					//Erreur d''exécution de la procédure stockée
					 errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
					 request.setAttribute("messageErreur",be.getInitialException().getMessage());
					//this.saveErrors(request,errors);
					 rForm.setMsgErreur(message);
					 rForm.setP_param6(user.getDpg_Defaut_Etoile());
					}
				}
					
			finally 
			{
				 jdbc.closeJDBC(); 
				 return mapping.findForward("ecran") ;
			}
					
		}
		else
		{
			return 	super.bipPerform(mapping,form, request,response, hParamProc);
		}
	}
}
