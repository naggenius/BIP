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
import com.socgen.bip.form.EditionReForm;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
/**
 * @author Equipe Bip
 * @author E.VINATIER
 *
 * Action struts gérant les demandes d'éditions
 * pour les reestime par activite
 * 
 * @see com.socgen.bip.commun.action.ReportAction
 * @see com.socgen.bip.metier.Report
 */
public class EditionReAction extends ReportAction
{
	static Config configProc = ConfigManager.getInstance("bip_reports_proc") ;
	

	
	/**
	 * Constructeur
	 * Aucun traitement
	 */
	public EditionReAction()
	{
		super();
	}
	
	/**
	 * Traitement pour les éditions
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
		EditionReForm automateForm = (EditionReForm)form ;
		String action = null;
		//Extraction de la valeur action
		action = automateForm.getAction() ;
		
		
		//si la valeur de action est egale à refresh
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
					   
					  //On recharge la même page(ecran) s'il n'y a pas de message d'erreur
					   if(message!=null)
					   {
						((EditionReForm)form).setMsgErreur(message);
						((EditionReForm)form).setP_param6(((EditionReForm)form).getP_param8());
						 
					   }
					 jdbc.closeJDBC(); return mapping.findForward("ecran") ; 
					
				}
	
				catch (BaseException be) {
					//Si exception sql alors extraire le message d'erreur du message global
					if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")){
						message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
					((EditionReForm)form).setMsgErreur(message);
					((EditionReForm)form).setP_param6(((EditionReForm)form).getP_param8());
					}
					else {
					//Erreur d''exécution de la procédure stockée
					 errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
					 request.setAttribute("messageErreur",be.getInitialException().getMessage());
					//this.saveErrors(request,errors);
					((EditionReForm)form).setMsgErreur(be.getInitialException().getMessage());
					((EditionReForm)form).setP_param6(((EditionReForm)form).getP_param8());
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