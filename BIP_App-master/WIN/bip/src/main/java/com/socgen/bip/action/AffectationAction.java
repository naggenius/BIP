package com.socgen.bip.action;

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
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.AffectationForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 29/07/2003
 *
 * Action d'affectation des SousTaches � une ressource
 * chemin : Saisie des r�alis�s/Ressource-Sous t�che
 * pages  : fSoustacheresSr.jsp, bSoustacheresSr.jsp, fAffectationSr.jsp, mAffectationSr.jsp
 * pl/sql : isac_affectation.sql
 */
public class AffectationAction extends AutomateAction {

	private static String PACK_SELECT_R = "affectation.consulter_r.proc";
	private static String PACK_SELECT = "affectation.consulter.proc";
	private static String PACK_INSERT = "affectation.creer.proc";
	private static String PACK_DELETE = "affectation.supprimer.proc";
	private static String PACK_NOMBRE = "affectation.nombre.proc";

	
	
//	private String nomProc;
	

	/**
		* Action qui permet de passer � la page suivante
		*/
	protected ActionForward suite(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,Hashtable hParamProc)
		throws ServletException {
//		HttpSession session = request.getSession(false);
		

		String signatureMethode =
			"AffectationAction-suite( mapping, form , request,  response,  errors )";
   
	   
		logBipUser.entry(signatureMethode);
		if (request.getParameter("mode").equals("consulter")) {
			//Ouverture de la page � partir du menu :sous taches d'une ressource
			logBipUser.exit(signatureMethode);
			 return mapping.findForward("ressource");
		} else if (request.getParameter("mode").equals("affecter")) {
			//Ouverture de la page � partir du menu : affectation
			logBipUser.exit(signatureMethode);
			 return mapping.findForward("initial");
		}
		 return mapping.findForward("initial");

	} //suite
	/**
	  * Action qui permet de passer � la page de d�but structure
	  */
	  public ActionForward retour(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws ServletException{
	
	   return mapping.findForward("retour");		
	  }//retour

	/**
	* Action qui permet de cr�er une �tape
	*/
	protected ActionForward creer(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,Hashtable hParamProc)
		throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
//		boolean msg = false;

		String signatureMethode =
			"AffectationAction -creer( mapping, form , request,  response,  errors )";

		//logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);

		AffectationForm bipForm = (AffectationForm) form;
		

		//ex�cution de la proc�dure PL/SQL 	
		try {
		 vParamOut = jdbc.getResult( hParamProc, configProc, PACK_NOMBRE);
		 
		 if (((ParametreProc) vParamOut.get(0)).getValeur() != null) {
				 message =((ParametreProc) vParamOut.get(0)).getValeur().toString();
		 }

		 if (!message.equals("")) {
			 //Entit� d�j� existante, on r�cup�re le message 
			 ((AffectationForm) form).setMsgErreur(message);
			 logBipUser.debug("message d'erreur:" + message);
			 logBipUser.exit(signatureMethode);
			 //on reste sur la m�me page
			  jdbc.closeJDBC(); return mapping.findForward("initial");
		 }//if
		} //try
		catch (BaseException be) {
		 logBipUser.debug(
						  "AffectationAction-suite() --> BaseException :" + be);
		 logBipUser.debug(
						  "AffectationAction-suite() --> Exception :"
							  + be.getInitialException().getMessage());
		 logService.debug(
						  "AffectationAction-suite() --> BaseException :" + be);
		 logService.debug(
						  "AffectationAction-suite() --> Exception :"
							  + be.getInitialException().getMessage());
		 //Si exception sql alors extraire le message d'erreur du message global
		 if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")) {
						  message =
							  BipException.getMessageFocus(
								  BipException.getMessageOracle(
									  be.getInitialException().getMessage()),
								  form);
						  ((AffectationForm) form).setMsgErreur(message);
						   jdbc.closeJDBC(); return mapping.findForward("initial");

		 } else {
						  //Erreur d''ex�cution de la proc�dure stock�e
						  errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
						  request.setAttribute(
							  "messageErreur",
							  be.getInitialException().getMessage());
						  //this.saveErrors(request,errors);
						   jdbc.closeJDBC(); return mapping.findForward("error");
	    }//if
	   }
		
		
		//ex�cution de la proc�dure PL/SQL	
		try {
			vParamOut =
				jdbc.getResult(
					
					hParamProc,
					configProc,
					PACK_SELECT);
			//R�cup�ration des r�sultats
			bipForm.setRessource(
				((ParametreProc) vParamOut.get(0)).getValeur().toString());
			bipForm.setLib(((ParametreProc) vParamOut.get(1)).getValeur().toString());	
				
				

			if (((ParametreProc) vParamOut.get(3)).getValeur() != null) {
				message =
					((ParametreProc) vParamOut.get(3)).getValeur().toString();
			}

			if (!message.equals("")) {
				//Entit� d�j� existante, on r�cup�re le message 
				 ((AffectationForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				//on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} //try
		catch (BaseException be) {
			logBipUser.debug(
				"AffectationAction-creer() --> BaseException :" + be);
			logBipUser.debug(
				"AffectationAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
				"AffectationAction-creer() --> BaseException :" + be);
			logService.debug(
				"AffectationAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be
				.getInitialException()
				.getClass()
				.getName()
				.equals("java.sql.SQLException")) {
				message =
					BipException.getMessageFocus(
						BipException.getMessageOracle(
							be.getInitialException().getMessage()),
						form);
				((AffectationForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				//Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute(
					"messageErreur",
					be.getInitialException().getMessage());
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}//catch

		//logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	} //creer

	/**
		* Action qui permet de visualiser les donn�es li�es � un code Affectation pour la modification et la suppression
		*/
	protected ActionForward consulter(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,Hashtable hParamProc)
		throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
//		boolean msg = false;
//		ParametreProc paramOut;
//		String select = "";

		String signatureMethode =
			"AffectationAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		AffectationForm bipForm = (AffectationForm) form;

		//ex�cution de la proc�dure PL/SQL	
		try {
			vParamOut =
				jdbc.getResult(
					
					hParamProc,
					configProc,
					PACK_SELECT_R);

			//R�cup�ration des r�sultats
			bipForm.setRessource(
				((ParametreProc) vParamOut.get(0)).getValeur().toString());

			if (((ParametreProc) vParamOut.get(2)).getValeur() != null) {
				message =
					((ParametreProc) vParamOut.get(2)).getValeur().toString();
			}

			if (!message.equals("")) {
				//le code Affectation n'existe pas, on r�cup�re le message 
				bipForm.setMsgErreur(message);
				//on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("ressource");
			}
		} //try
		catch (BaseException be) {
			logBipUser.debug(
				"AffectationAction-consulter() --> BaseException :" + be,
				be);
			logBipUser.debug(
				"AffectationAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
				"AffectationAction-consulter() --> BaseException :" + be,
				be);
			logService.debug(
				"AffectationAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be
				.getInitialException()
				.getClass()
				.getName()
				.equals("java.sql.SQLException")) {
				message =
					BipException.getMessageFocus(
						BipException.getMessageOracle(
							be.getInitialException().getMessage()),
						form);
				bipForm.setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("ressource");

			} else {
				//Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute(
					"messageErreur",
					be.getInitialException().getMessage());
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("sousTache");
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		} else if (mode.equals("delete")) {
			cle = PACK_DELETE;
		}
		  return cle;
	}

	protected ActionForward valider(
		ActionMapping mapping,
		ActionForm form,
		String mode,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors,Hashtable hParamProc)
		throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;
		
		

		String signatureMethode =
			"valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise � jour:" + mode);
		//On r�cup�re la cl� pour trouver le nom de la proc�dure stock�e dans bip_proc.properties
		cle = recupererCle(mode);
	
						
				
		
		
		
		
		//On ex�cute la proc�dure stock�e
		try {

			vParamOut =
				jdbc.getResult(
					
					hParamProc,
					configProc,
					cle);

			try {
				message = jdbc.recupererResult(vParamOut, "valider");
				
				
				

			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug(
					"valider() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("valider() --> BaseException :" + be);
				logService.debug(
					"valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on r�cup�re le message 
				 ((AffectationForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);

			}

		} catch (BaseException be) {

			logService.debug("valider() --> BaseException :" + be);
			logService.debug(
				"valider() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :" + be);
			logBipUser.debug(
				"valider() --> Exception :"
					+ be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be
				.getInitialException()
				.getClass()
				.getName()
				.equals("java.sql.SQLException")) {
				message =
					BipException.getMessageFocus(
						BipException.getMessageOracle(
							be.getInitialException().getMessage()),
						form);
				((AffectationForm) form).setMsgErreur(message);

			} else {
				//Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute(
					"messageErreur",
					be.getInitialException().getMessage());
				//this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);
		if (!mode.equals("delete"))
		{	
			 jdbc.closeJDBC(); return mapping.findForward("ecran");
		}
		else
		{	
			 jdbc.closeJDBC(); return mapping.findForward("sousTache");
		}		 

	} //valider
}
