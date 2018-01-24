package com.socgen.bip.action;
import java.sql.ResultSet;
import java.sql.SQLException;
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

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.FourCopiForm;
import com.socgen.cap.fwk.exception.BaseException;

public class FourCopiAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "fourcopi.consulter.proc";

	private static String PACK_INSERT = "fourcopi.creer.proc";

	private static String PACK_UPDATE = "fourcopi.modifier.proc";

	private static String PACK_DELETE = "fourcopi.supprimer.proc";

	
	

	/**
	 * Action qui permet de créer un code rubrique
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;
		String libelle = null; 
		String signatureMethode = "fourCopiAction-creer(( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			        vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			  
			
//			      Récupération des résultats
					for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
						paramOut = (ParametreProc) e.nextElement();

						// récupérer le message
						if (paramOut.getNom().equals("message")) {
							message = (String) paramOut.getValeur();
						}
							if (paramOut.getNom().equals("libelle")) {
								libelle = (String) paramOut.getValeur();
						}	
					}		
	 
				    if(libelle == null){
				    	
				    	message = jdbc.recupererResult(vParamOut, "creer");
				    	logBipUser.exit(signatureMethode);
				    	jdbc.closeJDBC(); return mapping.findForward("ecran");
				    	
				    }else{
				    	
				    	message = "Ce fournisseur existe déjà" ; 
				    	FourCopiForm four = (FourCopiForm) form;  
				    	four.setMsgErreur(message);
				    	logBipUser.exit(signatureMethode);
				    	 jdbc.closeJDBC(); return mapping.findForward("initial");
				    }

		 
		}// try
		catch (BaseException be) {
			logBipUser.debug("fourCopiAction-creer() --> BaseException :" + be);
			logBipUser.debug("fourCopiAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("fourCopiAction-creer() --> BaseException :" + be);
			logService.debug("fourCopiAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((FourCopiForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		// logService.exit(signatureMethode);
	//	logBipUser.exit(signatureMethode);

//		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code rubrique pour
	 * la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		String libelle = null;
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "fourCopiAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}
					if (paramOut.getNom().equals("libelle")) {
						libelle = (String) paramOut.getValeur();
					}	
					
				
				// if
			}// for
				if (libelle == null)
				{
					message = "Fournisseur COPI inexistant" ; 
					FourCopiForm four = (FourCopiForm) form;  
			    	four.setMsgErreur(message);
			    	logBipUser.exit(signatureMethode);
		    	 	 jdbc.closeJDBC(); return mapping.findForward("initial");
				}
				else
				{
					FourCopiForm four = (FourCopiForm) form;  
					four.setLibelle(libelle);
			    	four.setMsgErreur(message);
			    	logBipUser.exit(signatureMethode);
		    	 	jdbc.closeJDBC(); return mapping.findForward("ecran");
					
				}
				
			}
			
		
			// try
		catch (BaseException be) {
			logBipUser.debug("fourCopiAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("fourCopiAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("fourCopiAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("fourCopiAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((FourCopiForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

	
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		} else if (mode.equals("update")) {
			cle = PACK_UPDATE;
		} else if (mode.equals("delete")) {
			cle = PACK_DELETE;
		}
		  return cle;
	}

}
