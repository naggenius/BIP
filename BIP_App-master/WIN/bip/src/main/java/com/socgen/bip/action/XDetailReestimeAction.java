package com.socgen.bip.action;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.socgen.bip.form.XDetailReestimeForm;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
/**
 * @author DSIC/SUP Equipe Bip
 * @author B.AARAB
 *
 * Action struts g�rant les demandes d'extraction
 * pour les details
 * 
 * @see com.socgen.bip.commun.action.ReportAction
 * @see com.socgen.bip.metier.Report
 */
public class XDetailReestimeAction extends ReportAction
{
	static Config configProc = ConfigManager.getInstance("bip_reports_proc") ;
	
	
	
	/**
	 * Constructeur
	 * Aucun traitement
	 */
	public XDetailReestimeAction()
	{
		super();
	}
	
	/**
	 * Traitement pour les �ditions
	 * On recupere les informations de ReportForm et de du userBip
	 * Puis ont lance une demande de travail a la classe metier Report
	 * 
	 * @see com.socgen.bip.commun.action.BipAction#bipPerform(ActionMapping, ActionForm, HttpServletRequest, HttpServletResponse)
	 * @ jdbc.closeJDBC(); return ActionForward
	 */
	public ActionForward bipPerform(	ActionMapping mapping,
										ActionForm form,
										HttpServletRequest request,
										HttpServletResponse response,
										Hashtable hParamProc)
										throws ReportException, IOException
	{
		
		JdbcBip jdbc = new JdbcBip(); 
		XDetailReestimeForm automateForm = (XDetailReestimeForm)form ;
		String action = null;
		//Extraction de la valeur action
		action = automateForm.getAction() ;
		if (action==null)
				action= request.getParameter("action");
		//si la valeur de action est egale � refresh
		//alors en refrech la liste des scenario correspandont au code pdg
		 
		if(ACTION_REFRESH.equals(action))
		{
			  
			   Vector vParamOut = new Vector();
			   ParametreProc paramOut;
			   String message="";
		       			
			    
			    
				try {
					
					//on verifie d'abord l'existance et l'habilitation
					
					  vParamOut=jdbc.getResult (hParamProc,configProc,"report.verif_perimetre_minsc");
					   for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
							paramOut = (ParametreProc) e.nextElement();
							if (paramOut.getNom().equals("message"))
								 message=(String)paramOut.getValeur();
					   }
					   
					  //On recharge la m�me page(ecran) s'il n'y a pas de message d'erreur
					   if(message!=null)
					   {
						((XDetailReestimeForm)form).setMsgErreur(message);
						((XDetailReestimeForm)form).setP_param6(((XDetailReestimeForm)form).getP_param8());
						 
					   }
					 jdbc.closeJDBC(); return mapping.findForward("ecran") ; 
					
				}
	
				catch (BaseException be) {
					//Si exception sql alors extraire le message d'erreur du message global
					if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")){
						message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
					((XDetailReestimeForm)form).setMsgErreur(message);
					((XDetailReestimeForm)form).setP_param6(((XDetailReestimeForm)form).getP_param8());
					}
					else {
					//Erreur d''ex�cution de la proc�dure stock�e
					 errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
					 request.setAttribute("messageErreur",be.getInitialException().getMessage());
					//this.saveErrors(request,errors);
					((XDetailReestimeForm)form).setMsgErreur(be.getInitialException().getMessage());
					((XDetailReestimeForm)form).setP_param6(((XDetailReestimeForm)form).getP_param8());
					}
				}
					
			finally 
			{
				 jdbc.closeJDBC(); return mapping.findForward("ecran") ;
			}
					
		}
		//sinon on continue notre action		
		else
		{
			
		 jdbc.closeJDBC(); return 	super.bipPerform(mapping,form, request,response, hParamProc);
			
		}
	}
		
		
	
}