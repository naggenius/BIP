package com.socgen.bip.action;


import java.io.IOException;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.form.ChangeMenuForm;
import com.socgen.bip.menu.item.BipItemMenu;
import com.socgen.bip.rbip.commun.RBipConstants;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * Action Struts g�rant les actions li�es au choix du menu par l'utilisateur.
 * Cette action est invoqu�e lors de l'affichage du formulaire de choix du menu (ChamgeMenuForm et /jsp/choixMenu.jsp) et
 * lors de sa validation.
 * @author RSRH/ICH/CAP
 */
public class ChangeMenuAction extends AutomateAction implements RBipConstants
{
   /**
	* Action qui permet de cr�er un nouveau formulaire
	*/
	
	
	protected ActionForward creer(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProctest ) throws ServletException{
		ChangeMenuForm changeMenuForm = (ChangeMenuForm)form ;
	
	// Cr�ation d'un nouveau formulaire. Celui-ci est r�f�renc� parmi les attributs de la requ�te
		changeMenuForm = new ChangeMenuForm()  ;
		request.setAttribute(mapping.getAttribute(), changeMenuForm) ;
		return mapping.findForward("initial");
	}//creer
	/**
	 * Affichage du formulaire pr�-remplis. Modification du choix pr�c�dent de l'utilisateur.
	 */
	protected  ActionForward consulter(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc ) throws ServletException{
	ChangeMenuForm changeMenuForm = (ChangeMenuForm)form ;
	
	// R�cup�ration de l'instance d'utilisateur stock� dans la session.
			UserBip user = (UserBip)request.getSession(false).getAttribute("UserBip" ) ;
			
			// R�cup�ration de l'id du menu en cours d'utilisation
			/*
			MenuIdBean menuId = user.getMenuUtil() ;
			// Cr�ation du formulaire et pr�s�lection du menu en cours d'utilisation
			changeMenuForm = new ChangeMenuForm() ;
			if (menuId != null)
			{
				changeMenuForm.setMenuId(menuId.getId().toString()) ;
			}
			*/
			BipItemMenu bM = user.getCurrentMenu();
			if (bM != null)
			{
				changeMenuForm.setMenuId(bM.getId()) ;
			}
			
			
			// Mise � jour de la requ�te avec le nouveau formulaire.
			request.setAttribute(mapping.getAttribute(), changeMenuForm) ;
		return mapping.findForward("ecran");

	}//consulter
	
	/**
	 * Tracer l'acces des utilisateurs a travers du menu BIP
	 * 
	 */
	public void traceUser(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc ) throws ServletException
	{	

		String PACK_INSERT = "user_trace.insert.proc";
		
		// R�cup�ration de l'instance d'utilisateur stock� dans la session.
		UserBip uBip = (UserBip)request.getSession(false).getAttribute("UserBip" ) ;
		
		Vector vParamOut = new Vector();

		//Hashtable hParamProc = new Hashtable();
		Config configProc = ConfigManager.getInstance(BIP_PROC) ;
		
		//HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
		String signatureMethode = "ChangeMenuAction-traceUser(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc )";
		
		logBipUser.entry(signatureMethode);
			
		JdbcBip jdbc = new JdbcBip(); 
		
		/*hParamProc.put("idarpege", uBip.getIdUser() );
		hParamProc.put("nom", uBip.getNom() );
		hParamProc.put("prenom", uBip.getPrenom() );
		hParamProc.put("code_menu",uBip.getCurrentMenu().getId() );
		hParamProc.put("sous_menu_liste",uBip.getSousMenus() );
		hParamProc.put("sous_menu",request.getParameter("sousMenu") );*/
					
		//ex�cution de la proc�dure PL/SQL			
		try {
			
			vParamOut=jdbc.getResult(hParamProc,configProc,PACK_INSERT);						
			
		}//try
		catch (BaseException be) {
			logBipUser.error( this.getClass().getName() + "." + signatureMethode +" --> BaseException :"+be);
			logBipUser.error( this.getClass().getName() + "." + signatureMethode +" --> Exception :"+be.getInitialException().getMessage());
			
		} finally {
			jdbc.closeJDBC();
		}
									
		logBipUser.exit(signatureMethode);		
				
	}
	
	protected  ActionForward valider(ActionMapping mapping,ActionForm form ,  String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc ) throws ServletException{
		ChangeMenuForm changeMenuForm = (ChangeMenuForm)form ;
		// Modification de l'instance de l'utilisateur stock� dans la session
		// afin de prendre en compte  le nouveau menu s�lectionn�
		UserBip user = (UserBip)request.getSession().getAttribute("UserBip") ;
		//Integer id = new Integer(changeMenuForm.getMenuId()) ;
		String sId = changeMenuForm.getMenuId();
		
		//user.setMenuUtil(id);
		user.setCurrentMenu(sId);
		
		// Gestion de la trace/droit des users au niveau menu
		traceUser( user,hParamProc);
		
		if("RBIP".equals(sId))
		{
			Tools.setListParamBip(Tools.recup_param_bip_global(TAG_PARAM_TYPETAPESJEUX_ACTION));
			
			if(Tools.getListParamBip().isEmpty())
			{
				
				user.setMessage("Anomalie de param�trage des types d'�tapes, veuillez pr�venir l'�quipe MO Bip.");
				return mapping.findForward("initial") ;
			}
			
		}
		
		return mapping.findForward("ecran") ;

	}//valider
	
	protected void traceUser(UserBip uBip,Hashtable hParamProc)
	{	
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		Config configProc = ConfigManager.getInstance(BIP_PROC) ;
		String PACK_INSERT = "user_trace.insert.proc";

		Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		
		String signatureMethode = "ChangeMenuAction-traceUser(uBip )";
		
		logBipUser.entry(signatureMethode);
			
		JdbcBip jdbc = new JdbcBip(); 

		lParamProc.put("userid", uBip.getInfosUser() );
		lParamProc.put("menuId",uBip.getCurrentMenu().getId() );

		//ex�cution de la proc�dure PL/SQL			
		try {
			
			vParamOut=jdbc.getResult(lParamProc,configProc,PACK_INSERT);						
			
		}//try
		catch (BaseException be) {
			logBipUser.error( this.getClass().getName() + "." + signatureMethode +" --> BaseException :"+be);
			logBipUser.error( this.getClass().getName() + "." + signatureMethode +" --> Exception :"+be.getInitialException().getMessage());
			
		} finally {
			jdbc.closeJDBC();
		}
				
		logBipUser.exit(signatureMethode);		
				
	}
	
}
