package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
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
import com.socgen.bip.form.BudgetCopiePropMasseForm;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

public class BudgetCopiePropMasseAction  extends AutomateAction implements BipConstantes {
	
	private static String PACK_RECHERCHE_ANNEE = "budget.copiemasse.recherche.annee.proc";
	
	private static String PACK_SIMULATION = "budget.copiemasse.simulation.proc";
	
	private static String PACK_VALIDATION = "budget.copiemasse.validation.proc";
	
	protected  ActionForward initialiser(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
	
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;
		int annee;
		
		BudgetCopiePropMasseForm bipForm = (BudgetCopiePropMasseForm) form;
		hParamProc.put("typeligne", "TOUS");
		hParamProc.put("dossproj", "TOUS");
		hParamProc.put("client", "TOUS");
		
		bipForm.setTypeligne("TOUS");
		bipForm.setLibelletypeligne("Tous");
		bipForm.setClient("TOUS");
		bipForm.setLibelleclient("Tous");
		bipForm.setDossproj("Tous");
		bipForm.setLibelledossproj("Tous");
		bipForm.setLibelledirection("Toutes");
			
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_RECHERCHE_ANNEE);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				//ABN - HP PPM 63174
				if (paramOut.getNom().equals("annee")) {
					if (paramOut.getValeur() != null && ((String)paramOut.getValeur()).contains("DS")) {
						annee = Integer.valueOf(((String)paramOut.getValeur()).split("_")[0]);
						bipForm.setAnnee_ref(String.valueOf(annee - 1));
						bipForm.setAnnee(String.valueOf(annee));
					} else {
						bipForm.setAnnee_ref((String) paramOut.getValeur());
						bipForm.setAnnee((String) paramOut.getValeur());
					}
				//ABN - HP PPM 63174
					hParamProc.put("annee",bipForm.getAnnee());
					
				}
				
//				 récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					bipForm.setMsgErreur(message);
				}
				
				
			}
			if (!"".equals(message)) {
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("ecran");
			}
					
		}// try
		catch (BaseException be) {
			logBipUser.debug("BudgetCopiePropMasseAction-suite() --> BaseException :"
					+ be, be);
			logBipUser.debug("BudgetCopiePropMasseAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("BudgetCopiePropMasseAction-suite() --> BaseException :"
					+ be, be);
			logService.debug("BudgetCopiePropMasseAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);
				jdbc.closeJDBC(); return mapping.findForward("ecran");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc.closeJDBC(); return mapping.findForward("error");
			}

		}
		
		
		
		
		
		return mapping.findForward("ecran") ;
	}
	
	protected  ActionForward suite(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;
	
		String signatureMethode = "BudgetCopiePropMasseAction-suite(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Création d'une nouvelle form
		BudgetCopiePropMasseForm bipForm = (BudgetCopiePropMasseForm) form;
		
		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SIMULATION);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message_simulation")) {
					bipForm.setMessage_simulation((String) paramOut.getValeur());
				}
				
//				 récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					bipForm.setMsgErreur(message);
				}
				
				
			}// for
			if (!"".equals(message)) {
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("ecran");
			}
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("BudgetCopiePropMasseAction-suite() --> BaseException :"
					+ be, be);
			logBipUser.debug("BudgetCopiePropMasseAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("BudgetCopiePropMasseAction-suite() --> BaseException :"
					+ be, be);
			logService.debug("BudgetCopiePropMasseAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);
				jdbc.closeJDBC(); return mapping.findForward("ecran");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc.closeJDBC(); return mapping.findForward("error");
			}

		}

	    logBipUser.exit(signatureMethode);

		jdbc.closeJDBC(); return mapping.findForward("ecran");
	}
	
	protected  ActionForward annuler(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors,Hashtable hParamProc  ) throws ServletException{
		  return mapping.findForward("favoris") ;
	}
	
	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("valider")) {
			cle = PACK_VALIDATION ;
		}
		  return cle;
	}
}
