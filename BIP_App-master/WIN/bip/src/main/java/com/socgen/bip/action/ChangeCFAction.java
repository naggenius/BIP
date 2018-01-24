package com.socgen.bip.action;

import java.io.IOException;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.ReportAction;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.ReportException;
import com.socgen.bip.form.ChangeCFForm;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
/**
 * @author DSIC/SUP Equipe Bip
 * @author B.AARAB
 *
 * Action struts gérant les demandes d'extraction
 * pour les details
 * 
 * @see com.socgen.bip.commun.action.ReportAction
 * @see com.socgen.bip.metier.Report
 */
public class ChangeCFAction extends ReportAction
{
	
	static Config configProc = ConfigManager.getInstance("bip_reports_proc") ;
	static Config cfgSQL = ConfigManager.getInstance("sql");
	private static String sProcFiliale = "SQL.filiale";
	
   
	
	/**
	 * Constructeur
	 * Aucun traitement
	 */
	public ChangeCFAction()
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
		HttpSession session = request.getSession();

		com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
						
		ChangeCFForm automateForm = (ChangeCFForm)form ;
		String action = null;
		String centre_Frais_old = user.getCentre_Frais();
		String centre_Frais;
		String filcode=null;
		ActionForward map;
		String sSQL;
		
		
		//Extraction de la valeur action
		action = automateForm.getAction() ;
		centre_Frais = automateForm.getCentre_Frais() ;
			
				
	    sSQL = cfgSQL.getString(sProcFiliale);
		UserBip uBip = (UserBip)session.getAttribute("UserBip");
		sSQL += "'"+ centre_Frais +"'";
		try
		{
			filcode = jdbc.recupererInfo(sSQL);
		}
		catch (BaseException bE)
		{
			logService.error("InfoMenu.getInfoFiliale : Erreur dans la récuperationde la filiale " + sSQL, bE);
		}

		
		
		
		
		
					
		if((!centre_Frais_old.equals(centre_Frais))&&(centre_Frais != null)){	
					
				user.setCentre_Frais(centre_Frais);
			    user.setFilCode(filcode);
		        session.setAttribute("UserBip",user);
		        automateForm.setFocus("ok");
			    map = mapping.findForward("ecran");
			
		}
		else
		     map = mapping.findForward("initial");
		     
			
		
		
						
		 jdbc.closeJDBC(); return 	  map;
		
			
		
	}
		
		
	
}