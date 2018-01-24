package com.socgen.bip.action;

import java.io.IOException;
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
import com.socgen.bip.commun.action.ReportAction;
import com.socgen.bip.commun.form.ExtractionForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.exception.ReportException;
import com.socgen.bip.form.EditionReForm;
import com.socgen.bip.form.TypeEtapeForm;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.cap.fwk.log.Log;

public class SimulImmoAction extends ReportAction implements BipConstantes {
	
	private static String PACK_INIT= "simul_immo.liste.init.proc";
	protected static final String sLogCat = "BipUser";
	protected static Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);
	protected static Config configProc = ConfigManager.getInstance(BIP_PROC);
	
	public SimulImmoAction()
	{
		super();
	}
	
	public ActionForward bipPerform(	ActionMapping mapping,
										ActionForm form,
										HttpServletRequest request,
										HttpServletResponse response,
										Hashtable hParamProc)
										throws ReportException, IOException
	{
		
		
		JdbcBip jdbc = new JdbcBip(); 
		
		ExtractionForm bipForm = (ExtractionForm) form;
		String action = null;
		//Extraction de la valeur action
		action = bipForm.getAction() ;
			
		if(ACTION_INIT.equals(action) || ACTION_REFRESH.equals(action))
		{
			  
			if (ACTION_REFRESH.equals(action))
				try{
					  //do what you want to do before sleeping
					  Thread.currentThread().sleep(3500);//sleep for 1000 ms
					  //do what you want to do after sleeptig
					}
					catch(Exception ie){
//					If this thread was intrrupted by nother thread 
					}
			
					
		Vector vParamOut = new Vector();
			   ParametreProc paramOut;
			   String message="";
		       			
			    
			    
				try {
			vParamOut = jdbc.getResult(hParamProc, configProc , PACK_INIT);
			
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) 
			{
				paramOut = (ParametreProc) e.nextElement();
		
//				 récupérer le message
				if (paramOut.getNom().equals("p_param7")) {
					bipForm.setP_param7((String) paramOut.getValeur());
				}
		
				if (paramOut.getNom().equals("p_param8")) {
					bipForm.setP_param8((String) paramOut.getValeur());
				}
				if (paramOut.getNom().equals("p_param9")) {
					bipForm.setP_param9((String) paramOut.getValeur());
				}
				if (paramOut.getNom().equals("p_param10")) {
					bipForm.setP_param10((String) paramOut.getValeur());
				}
			}
		}
				
				catch (BaseException be) {
					logBipUser.debug("SimulImmoAction-initialiser() --> BaseException :"
							+ be, be);
					logBipUser.debug("SimulImmoAction-initialiser() --> Exception :"
							+ be.getInitialException().getMessage());

					logService.debug("SimulImmoAction-initialiser() --> BaseException :"
							+ be, be);
					logService.debug("SimulImmoAction-initialiser() --> Exception :"
							+ be.getInitialException().getMessage());
					// Si exception sql alors extraire le message d'erreur du message
					// global
					if (be.getInitialException().getClass().getName().equals(
							"java.sql.SQLException")) {
						message = BipException.getMessageFocus(
								BipException.getMessageOracle(be.getInitialException()
										.getMessage()), form);
						((TypeEtapeForm) form).setMsgErreur(message);
						jdbc.closeJDBC();
						return mapping.findForward("ecran");

					} else {
						// Erreur d''exécution de la procédure stockée
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
						request.setAttribute("messageErreur", be.getInitialException()
								.getMessage());
						// this.saveErrors(request,errors);
						jdbc.closeJDBC();
						return mapping.findForward("error");
					}
				}

				
					
			finally 
			{
				 jdbc.closeJDBC(); 
				 return mapping.findForward("ecran") ;
				
			}
			
		}
		//sinon on continue notre action		
		else
		{
			
		 jdbc.closeJDBC(); return 	super.bipPerform(mapping,form, request,response, hParamProc);
			
		}
	}
	
	
}
