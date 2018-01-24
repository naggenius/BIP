package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ForfaitForm;
import com.socgen.bip.form.LogicielForm;
import com.socgen.bip.form.PersonneForm;
import com.socgen.bip.menu.item.BipItemMenu;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;

public class RessourceAction extends AutomateAction { 

	private static String PACK_SELECT_RESS = "consultress.consulter.proc";
	private static String PACK_COUNT_RESS = "countress.consulter.proc";
	
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		return mapping.findForward("annuler");
	}
	
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		PersonneForm bipForm = (PersonneForm) form;
		if((!StringUtils.isEmpty(bipForm.getDebnom())) || (!StringUtils.isEmpty(bipForm.getNomcont()))){
			bipForm.setIdent("");
			if(StringUtils.isEmpty(bipForm.getCount())){
				return mapping.findForward("initial");
			}else{
				return mapping.findForward("list");
			}
		}
		return mapping.findForward("initial");
	}
	
	protected ActionForward retour(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		PersonneForm bipForm = (PersonneForm) form;
		
		if((!StringUtils.isEmpty(bipForm.getDebnom())) || (!StringUtils.isEmpty(bipForm.getNomcont()))){
			bipForm.setIdent("");
			bipForm.setCount("");
		}
		
		return mapping.findForward("initial");
	}
	
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		Vector vParamOut = new Vector();
		String message = "";
		String count = "";
		//String ident = "";
		ParametreProc paramOut;
		JdbcBip jdbc = new JdbcBip();
		
		
		String signatureMethode = "RessourceAction-consulter()";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		// Création d'une nouvelle form
		PersonneForm bipForm = (PersonneForm) form;
		Hashtable hParams = bipForm.getHParams();
		if (hParamProc == null) {
			logBipUser.debug("consultationRess-consulter-->hParamProc is null");
		}
		
		// le count de la recherche
		try {
			vParamOut = jdbc.getResult(hParamProc,configProc, PACK_COUNT_RESS);
			
//			pas besoin d'aller plus loin
			if (vParamOut == null) {
				 logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); 
				 return mapping.findForward("initial");
			}
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
									
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
				
				if (paramOut.getNom().equals("count")) {
					if (paramOut.getValeur() != null){
						count = (String) paramOut.getValeur();
					}
				}
				
				//Gestion des messages d'erreurs
				if (message != null && !message.equals("")) {
					// on récupère le message
					bipForm.setMsgErreur(message);
					((PersonneForm) form).setMsgErreur(message);
					return mapping.findForward("initial");
				}
			}
			
		}catch (BaseException be) {
			logBipUser.debug(
					"RessourceAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("RessourceAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"RessourceAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("RessourceAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message = BipException.getMessageFocus(
				BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((PersonneForm) form).setMsgErreur(message);
				jdbc.closeJDBC(); 
				return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException().getMessage());
				jdbc.closeJDBC(); 
				return mapping.findForward("error");
			}
		}	

	if(count.equals("1")){
		try {
			vParamOut = jdbc.getResult(hParamProc,configProc, PACK_SELECT_RESS);
			
			// pas besoin d'aller plus loin
			if (vParamOut == null) {
				 logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); 
				 return mapping.findForward("initial");
			}
			
//			 Récupération des résultats
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
		
				if (paramOut.getNom().equals("count")) {
					if (paramOut.getValeur() != null){
						count = (String) paramOut.getValeur();
					}	
				}
				
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
				
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
				
					try {
							
						while (rset.next()) {
							bipForm.setIdent(rset.getString(1));
							bipForm.setHParams(hParams);
							
							if(!StringUtils.isEmpty(rset.getString(2)) 
									&& 
								rset.getString(2).equalsIgnoreCase("P") ){
								if(rset.getString(13).equalsIgnoreCase("SG..")){
									bipForm.setRtype("A");
								}else{
									bipForm.setRtype(rset.getString(2));
								}
							}else{
								bipForm.setRtype(rset.getString(2));
							}
							
							bipForm.setRnom(rset.getString(3));
							bipForm.setRprenom(rset.getString(4));
							bipForm.setCout(rset.getString(5));
							bipForm.setCoutHTR(rset.getString(6));
							bipForm.setMatricule(rset.getString(7));
							bipForm.setRtel(rset.getString(8));
							bipForm.setBatiment(rset.getString(9));
							bipForm.setZone(rset.getString(10));
							bipForm.setEtage(rset.getString(11));
							bipForm.setBureau(rset.getString(12));
							bipForm.setSoccode(rset.getString(13));
							bipForm.setIgg(rset.getString(14));
						}
						
						if (rset != null)
						{
							rset.close();
							rset = null;
						}	
						
					} // try
					catch (SQLException sqle) {
						logService
								.debug("RessourceForm-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("RessourceForm-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			}
			
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"RessourceAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("RessourceAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"RessourceAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("RessourceAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message = BipException.getMessageFocus(
				BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((PersonneForm) form).setMsgErreur(message);
				jdbc.closeJDBC(); 
				return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException().getMessage());
				jdbc.closeJDBC(); 
				return mapping.findForward("error");
			}
		}

		logBipUser
				.debug("fmemory end   : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); 
		
//		Gestion des messages d'erreurs
		if (message != null && !message.equals("")) {
			// on récupère le message
			bipForm.setMsgErreur(message);
			((PersonneForm) form).setMsgErreur(message);
			return mapping.findForward("initial");
		}
		return mapping.findForward("detail");
		
	  }else{
		  bipForm.setCount(count);
		  return mapping.findForward("list");
	  }
	
	}
	
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		HttpSession session;
		String sous_menus = "";
		Vector<String> sous_menus_v = new Vector<String>();
		String message = "";
		
		session = request.getSession(false);
		if (session == null || session.getAttribute("UserBip") == null)	{
			return mapping.findForward("accueil");
		}
		PersonneForm bipForm = (PersonneForm) form;
		//FIXME DHA userBip no consistent between threads
		userBip = (UserBip)session.getAttribute("UserBip");
		
		sous_menus = userBip.getSousMenus();
		BipItemMenu menu = userBip.getCurrentMenu();
		String menuId = menu.getId(); 

		StringTokenizer strtk_sous_menu = new StringTokenizer(sous_menus, ",");
		while (strtk_sous_menu.hasMoreTokens()){
			String s_menu = strtk_sous_menu.nextToken();
			if (!sous_menus_v.contains(s_menu)) {
				sous_menus_v.addElement(s_menu);
			}
		}		
		
		if(menuId.equalsIgnoreCase("me")){
			//ABN - PPM 63953
			if(sous_menus_v.contains("ges") || sous_menus_v.contains("pcm") || sous_menus_v.contains("GES") || sous_menus_v.contains("PCM")){
				try{
			
				if(bipForm.getRtype().equalsIgnoreCase("P") || bipForm.getRtype().equalsIgnoreCase("A")){
					
					return mapping.findForward("ressource");
					
				}else if(bipForm.getRtype().equalsIgnoreCase("L")){
					
					LogicielForm logicielForm = new LogicielForm();
					logicielForm.setIdent(bipForm.getIdent());
					request.getSession().setAttribute("logicielForm", logicielForm);
					
					return mapping.findForward("logiciel");
					
				}else{
					
					ForfaitForm forfaitForm = new ForfaitForm();
					forfaitForm.setIdent(bipForm.getIdent());
					request.getSession().setAttribute("forfaitForm", forfaitForm);
					
					return mapping.findForward("forfait");
					
				}
			}catch (Exception e) {
				message = e.getMessage();
				((PersonneForm) form).setMsgErreur(message);
				return mapping.findForward("initial");
			}}else{
				return mapping.findForward("initial");
			}
		}else{
			try{
				
				if(bipForm.getRtype().equalsIgnoreCase("P") || bipForm.getRtype().equalsIgnoreCase("A")){
					
					return mapping.findForward("ressource");
					
				}else if(bipForm.getRtype().equalsIgnoreCase("L")){
					
					LogicielForm logicielForm = new LogicielForm();
					logicielForm.setIdent(bipForm.getIdent());
					request.getSession().setAttribute("logicielForm", logicielForm);
					
					return mapping.findForward("logiciel");
					
				}else{
					
					ForfaitForm forfaitForm = new ForfaitForm();
					forfaitForm.setIdent(bipForm.getIdent());
					request.getSession().setAttribute("forfaitForm", forfaitForm);
					
					return mapping.findForward("forfait");
					
				}
			}catch (Exception e) {
				message = e.getMessage();
				((PersonneForm) form).setMsgErreur(message);
				return mapping.findForward("initial");
			}
		}
	}
	
	protected ActionForward suite1(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		return consulter(mapping, form, request, response, errors,hParamProc);
	}
}
