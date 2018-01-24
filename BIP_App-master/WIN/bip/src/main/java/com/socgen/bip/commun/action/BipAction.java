package com.socgen.bip.commun.action;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BIPActionMapping;
import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.form.BipForm;
import com.socgen.bip.log4j.BipUsersAppender;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.log.Log;

/**
 * @author RSRH/ICH/GMO Equipe Bip
 * @author E.GREVREND
 *
 * Classe abstraite racine des classes Actions de la Bip
 * Cette classe apporte la gestion des log par rapport au userId
 * ainsi qu'un catch global
 */
public abstract class BipAction extends Action  implements BipConstantes
{
	protected static final String sLogCat = "BipUser";
	public static Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);
	protected ActionErrors errors;

	
	//FIXME DHA don't store the userBIP as Struts Action classes are not designed to be thread safe  
	// BIG problem !!!!
	protected UserBip userBip;
	/**
	 * Constructeur de la classe
	 * Aucun traitement
	 */	
	public BipAction()
	{
		super();
	}
	
	/**
	 * Fonction perform
	 * @see org.apache.struts.action.Action#perform(BIPActionMapping, ActionForm, HttpServletRequest, HttpServletResponse)
	 * @return ActionForward
	 */
	public final ActionForward perform(	ActionMapping mapping,
									ActionForm form,
									HttpServletRequest request,
									HttpServletResponse response)
									throws IOException, ServletException {
		HttpSession session;
		String sParameterName;
		String sParameterValue;
		String sBouton;
		String sInfosUser;	
	    Hashtable hParams;
	
		errors = new ActionErrors();
		logBipUser.info("Entrée dans BIPACTION ActionForward perform") ;
		//verif de la validite de la session	
		session = request.getSession(false);
		if (session == null || session.getAttribute("UserBip") == null)	{
			return mapping.findForward("accueil");
		}

		try		{	
			//recup du sUserId de la session
			userBip = (UserBip)session.getAttribute("UserBip");		
			BipUsersAppender.setUserId(userBip.getIdUser());
			
			//Initialisation de la table de hash contenant les données dans le Form
			hParams = new Hashtable();
		    
			// on récupère les paramètres passés dans la page 
			for (Enumeration e=request.getParameterNames();e.hasMoreElements();) {
				sParameterName= (String)e.nextElement();
				sParameterValue = request.getParameter(sParameterName);
				// PPR le 13/09 - J'enlève les multiples traces pour alléger la log
				//logBipUser.info("Parms :"+" ("+sParameterName+","+sParameterValue+")") ;
				hParams.put(sParameterName,sParameterValue);
	
			}
			//on rajoute les informations sur l'utilisateur dans les hashTables hParamProc et  hParamKeyList
			//Récupérer la chaîne d'info sur l'utilisateur à partir du Bean UserBip
			sInfosUser=userBip.getInfosUser();	
					
			hParams.put("userid",sInfosUser);					
			logBipUser.info("Parms : "+" (userid,"+sInfosUser+")") ;			
			
			BipForm bipForm = (BipForm)form ;
			
			//Sauvegarder la hParamsList
			bipForm.setHParams(hParams);
			//Sauvegarder les infos du User
			bipForm.setInfosUser(sInfosUser);		
			
			return bipPerform(mapping, form, request, response,hParams);
		}
		catch (Throwable e)	{
			//les exceptions non gerees		
			logBipUser.error("Catch global de BipAction.perform", e);
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("error.nongeree", e.getClass().getName()));
			return mapping.findForward("failure");
		}
		
		finally	{
			if (!errors.empty()){
				
				this.saveErrors(request, errors);
			}
			BipUsersAppender.removeUserId();
		}
	}
	
	/**
	 * getter sur logBipUser permettant d'y acceder à partir des objets metiers ...
	 * @return Log
	 */
	public static Log getLogBipUser()
	{
		return logBipUser;
	}
	
	/**
	 * Fonction abstraite de la classe qui va contenir tout le traitement
	 * Toutes les exceptions levées dans cette méthode seront interceptées par perform
	 * @return ActionForward
	 */
	public abstract ActionForward bipPerform(	ActionMapping mapping,
									ActionForm form,
									HttpServletRequest request,
									HttpServletResponse response,
									Hashtable hParamProc)
									throws Throwable;

}
