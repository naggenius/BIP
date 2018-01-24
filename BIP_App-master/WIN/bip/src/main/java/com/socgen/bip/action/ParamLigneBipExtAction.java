package com.socgen.bip.action;
import java.io.IOException;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.ReportAction;
import com.socgen.bip.commun.form.ExtractionForm;
import com.socgen.bip.exception.ReportException;



/**
 * @author B.AARAB - 04/08/2006
 */
public class ParamLigneBipExtAction extends ReportAction {
	
	
	
	public ParamLigneBipExtAction()
	{
		super();
	}
	
	
	/**
		 * Traitement pour les éditions
		 * On recupere les informations de ReportForm et de du userBip
		 * Puis ont lance une demande de travail a la classe metier Report
		 * 
		 * @see com.socgen.bip.commun.action.BipAction#bipPerform(ActionMapping, ActionForm, HttpServletRequest, HttpServletResponse)
		 * @return ActionForward
		 */
		public ActionForward bipPerform(	ActionMapping mapping,
											ActionForm form,
											HttpServletRequest request,
											HttpServletResponse response,
											Hashtable hParamProc)
											throws ReportException, IOException
		{
		
			ExtractionForm automateForm = (ExtractionForm)form ;
			String action = null;
			//Extraction de la valeur action
			action = automateForm.getP_param8() ;
		
			//si la valeur de action est egale à refresh
			//alors en refrech la liste des scenario correspandont au code pdg
		 
			if("param".equals(action))
			{
			  
				return mapping.findForward("param");  
			   
			}
			//sinon on continue notre action		
			else
			{
			
			return 	super.bipPerform(mapping,form, request,response, hParamProc);
			
			}
		}
		
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}	