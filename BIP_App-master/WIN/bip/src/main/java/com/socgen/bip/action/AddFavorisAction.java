package com.socgen.bip.action;

import java.net.URLEncoder;
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

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.FavorisForm;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;


/**
 * @author JMA - 01/03/2006
 *
 * Action permettant d'ajouter un favori à partir de d'une fenêtre Popup 
 * 
 *  
 */

public class AddFavorisAction extends AutomateAction {

	
	
	
	private static String PACK_INSERT = "favoris.add.proc";

	/**
	 * Constructor for AddFavorisAction.
	 */
	public AddFavorisAction() {
		super();
	}

	/**
	* Action permettant le premier appel de la JSP
	*  	
	*/
	protected ActionForward initialiser(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,
		Hashtable hParams)
		throws ServletException {

		String signatureMethode =
			this.getClass().getName() + " - initialiser(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		FavorisForm favForm = (FavorisForm) form;

		try {
			UserBip userBip =  (UserBip) (request.getSession(false)).getAttribute("UserBip");
			favForm.setMenu(userBip.getCurrentMenu().getId());
			favForm.setTypFav(request.getParameter("typFav"));
			favForm.setLibelle(request.getParameter("libFav"));
			StringBuffer sbLien = new StringBuffer();
			sbLien.append(request.getParameter("lienFav"));
			int nbParam = 0;
			for (Enumeration vE = request.getParameterNames(); vE.hasMoreElements();) {
				String paramName = (String) vE.nextElement();
				if (paramName.startsWith("param")) {
					String param = request.getParameter(paramName);
					String valeur = request.getParameter("value" + paramName.substring(5));
					if (nbParam == 0)
						sbLien.append("?");
					else
						sbLien.append("&");
					sbLien.append(param + "=" + valeur);
					nbParam++;
				}
			}
			favForm.setLienFav(URLEncoder.encode(sbLien.toString()));
			request.setAttribute("favorisForm", favForm);

			// récupération userId
			UserBip user = (UserBip) request.getSession().getAttribute("UserBip");
			favForm.setUserid(user.getIdUser());

		} catch (Exception ex) {
			 return mapping.findForward(processSsimpleException(this.getClass().getName(), "consulter", ex, favForm, request));
		}
		logBipUser.exit(signatureMethode);

		  return mapping.findForward("ecran");
	}

	/**
	 * Action qui permet de créer un favori
	 */
	protected ActionForward creer(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,
		Hashtable hParamProc)
		throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = this.getClass().getName() + " - creer( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		//exécution de la procédure PL/SQL	
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_INSERT);
			try {
				message = jdbc.recupererResult(vParamOut, "valider");
			} catch (BaseException be) {
				logBipUser.debug(this.getClass().getName() + "-creer() --> BaseException :" + be);
				logBipUser.debug(this.getClass().getName() + "-creer() --> Exception :" + be.getInitialException().getMessage());
				logService.debug(this.getClass().getName() + "-creer() --> BaseException :" + be);
				logService.debug(this.getClass().getName() + "-creer() --> Exception :" + be.getInitialException().getMessage());
				//Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				//Entité déjà existante, on récupère le message 
				 ((FavorisForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				//on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} //try
		catch (BaseException be) {
			logBipUser.error(this.getClass().getName() + "-creer() --> BaseException :" + be);
			logBipUser.error(this.getClass().getName() + "-creer() --> Exception :" + be.getInitialException().getMessage());
			logService.error(this.getClass().getName() + "-creer() --> BaseException :" + be);
			logService.error(this.getClass().getName() + "-creer() --> Exception :" + be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
				message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);
				((FavorisForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException().getMessage());
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	} //creer
}