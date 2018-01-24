package com.socgen.bip.action;

import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.form.ClientForm;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 13/06/2003
 *
 * Action qui permet de changer de code client MO actif
 * chemin : Menu client/MAJ Direction
 * pages  : fMajclientMc.jsp 
 * pl/sql : 
 */
public class MajClientAction extends AutomateAction implements BipConstantes {
	static Config config = ConfigManager.getInstance("sql");
	static String client = "SQL.menus.client";
	
	

	/**
		* Action qui permet de changer de Client actif
		*/
	protected ActionForward suite(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors, Hashtable hParamProc)
		throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		HttpSession session = null;
		String requete;
		String lib;
		String clicode;

		String signatureMethode =
			"MajClientAction-suite( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);

		if (request.getParameter("mode").equals("initial")) { //Ouverture de la page à partir du menu
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward("initial");
		} else {

			ClientForm bipForm = (ClientForm) form;
			
			session = request.getSession(false);
			UserBip user = (UserBip) session.getAttribute("UserBip");
			//Mettre à jour le Client par défaut	
			clicode = bipForm.getClicode();
			user.setClicode_Defaut(clicode);
			
			requete = config.getString(client);
			requete = requete + "'"+clicode+"'";

			try {
				lib = jdbc.recupererInfo(requete);
				//Mettre en session le libelle du Client ou du centre de frais
				session.setAttribute(LIB_INFO, lib);
				//Afficher un message sur la page JSP
				bipForm.setMsgErreur("Mise à jour de la direction effectuée");
				//Mettre le focus=ok pour mise à jour du menu
				bipForm.setFocus("ok");
			} catch (BaseException be) {
				logBipUser.debug(
					"MajClientAction-suite() --> BaseException :" + be,
					be);
				logBipUser.debug(
					"MajClientAction-suite() --> Exception :"
						+ be.getInitialException().getMessage());

				logService.debug(
					"MajClientAction-suite() --> BaseException :" + be,
					be);
				logService.debug(
					"MajClientAction-suite() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			//logService.exit(signatureMethode);
			logBipUser.exit(signatureMethode);

			 jdbc.closeJDBC(); return mapping.findForward("ecran");
		}
	} //creer

}
