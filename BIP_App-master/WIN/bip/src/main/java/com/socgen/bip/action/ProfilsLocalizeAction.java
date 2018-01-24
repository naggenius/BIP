package com.socgen.bip.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Locale;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConfigRTFE;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.form.BipForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DatesEffetForm;
import com.socgen.bip.form.ProfilsLocalizeForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * Action de gestion des profils Localize Fonctionnel
 */
public class ProfilsLocalizeAction extends AutomateAction {

/*	*//**
	 * Clefs des procedures de creation / modification / suppression
	 */
	private static String PROC_INSERT = "ProfilLocalize.creer.proc";
	private static String PROC_UPDATE = "ProfilLocalize.modifier.proc";
	private static String PROC_DELETE = "ProfilLocalize.supprimer.proc";
	
	/**
	 * Clefs des procedures de creation / modification / suppression a partir de la liste
	 */
	private static String PROC_INSERT_LIST = "ProfilLocalize.creerlist.proc";
	private static String PROC_UPDATE_LIST = "ProfilLocalize.modifierlist.proc";
	private static String PROC_DELETE_LIST = "ProfilLocalize.supprimerlist.proc";
	
	private static String PROC_NOTEXISTS_PROFILDEFAUT_MAJ = "ProfilLocalize.notexistsprofildefautmaj.proc";

	/**
	 * Clefs des autres procedures
	 */
	private static String PROC_ISVALID_CODEDIR = "profilfi2.isvalidcodedir.proc";
	private static String PROC_NOTEXISTS_PROFILDEFAUT = "ProfilLocalize.notexistsprofildefaut.proc";
	private static String PROC_ISVALID_PROFILLOCALIZE = "ProfilLocalize.isvalidProfilLocalize.proc";
	private static String PROC_CHECK_PROFIL_LOCALIZE = "ProfilLocalize.profilfi.check.proc";
	private static String PROC_EXISTS_PROFIL_LOCALIZE = "ProfilLocalize.exists.proc";
	private static String PROC_ESTPROFILAFFECTERESSMENSANNEE_PROFILLOCALIZE = "ProfilLocalize.estprofilaffecteressmensannee.proc";
	private static String PROC_ISVALID_CODEES = "profildomfonc.isvalidcodees.proc"; //we can use same SP of DOMFONC
	
	private static String PACK_LIB_LOCALIZE = "ProfilLocalize.getlibelleProfilLocalize.proc";
	private static String PACK_LIB_LIST_LOCALIZE = "ProfilLocalize.getlibelleProfilLocalizelist.proc";
    private static String PACK_SELECT = "ProfilLocalize.consulter.proc";
	private static String PACK_SELECT_LIST = "ProfilLocalize.listConsulter.proc";
	/**
	 * Redirections
	 */
	// Ecran de sï¿½lection des profils
	private static String REDIR_SELECT_INITIAL = "initial";
	// Ecran de liste des profils
	private static String REDIR_LIST = "list";
	// Ecran de crï¿½ation / modification des profils
	private static String REDIR_CREA_MODIF = "ecran";
	
	/**
	 * Validation des criteres de recherche
	 *  dans l ecran GESTION DES PROFILS LOCALIZE
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward isValidProfilLocalize (
			ActionMapping mapping,ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws Exception {
		
		String signatureMethode = "isValidProfilLocalize(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc)";
		logBipUser.entry(signatureMethode);
		
      String filtre_localize = (String)request.getParameter("filtre_localize");
	  String filtre_date = (String)request.getParameter("filtre_date");
	         
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("filtre_localize", filtre_localize);
	  lParamProc.put("filtre_date", filtre_date);
	  
	  logBipUser.debug("ProfilsLocalizeAction-isValidProfilLocalize() --> filtre_localize :" + filtre_localize);
	  logBipUser.debug("ProfilsLocalizeAction-isValidProfilLocalize() --> filtre_date :" + filtre_date);
	  
	  
	  // execution de la procedure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PROC_ISVALID_PROFILLOCALIZE);
			// Recuperation des resultats
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
								
			}			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("ProfilsLocalizeAction-isValidProfilLocalize() --> BaseException :" + be);
			logBipUser.debug("ProfilsLocalizeAction-isValidProfilLocalize() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ProfilsLocalizeAction-isValidProfilLocalize() --> BaseException :" + be);
			logService.debug("ProfilsLocalizeAction-isValidProfilLocalize() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DatesEffetForm) form).setMsgErreur(message);
				 jdbc.closeJDBC();
//				 On ecrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;

			} else {
				// Erreur d''execution de la procedure stockee
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC();
//				 On ecrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On ecrit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	  out.flush();

	  return PAS_DE_FORWARD;
	 }
	
	/**
	 * Verification de l'existance d'un profil FI
	 *  egale au profil LOCALIZE saisi
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 * @throws Exception
	 */
	/*public ActionForward existsProfilFIDomFonc (
			ActionMapping mapping,ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws Exception {
		
		String signatureMethode = "existsProfilFIDomFonc(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc)";
		logBipUser.entry(signatureMethode);
		
      String filtre_localize = (String)request.getParameter("filtre_localize");
	  
	         
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("filtre_localize_fi", filtre_localize);
	//  lParamProc.put("filtre_localize_domfonc", filtre_localize);
	  
	  logBipUser.debug("ProfilsLocalizeAction-isValidProfilLocalize() --> filtre_localize :" + filtre_localize);
	  
	  
	  
	  // execution de la procedure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PROC_EXISTS_PROFILFIDOMFONC);
			// Recuperation des resultats
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
								
			}			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("ProfilsLocalizeAction-isValidProfilLocalize() --> BaseException :" + be);
			logBipUser.debug("ProfilsLocalizeAction-isValidProfilLocalize() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ProfilsLocalizeAction-isValidProfilLocalize() --> BaseException :" + be);
			logService.debug("ProfilsLocalizeAction-isValidProfilLocalize() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DatesEffetForm) form).setMsgErreur(message);
				 jdbc.closeJDBC();
//				 On ecrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;

			} else {
				// Erreur d''execution de la procedure stockee
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC();
//				 On ecrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On ecrit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	  return PAS_DE_FORWARD;
	 }*/
	
	/**
	 * Verification de l'existance d'un profil Localize
	 *  egale au profil Localize saisi
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 * @throws Exception
	 */
	public ActionForward existsProfilLocalize(
			ActionMapping mapping,ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws Exception {
		
		  String signatureMethode = "existsProfilLocalize(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc)";
		  logBipUser.entry(signatureMethode);
			
	      String filtre_localize = (String)request.getParameter("filtre_localize");
	      String date_effet = (String)request.getParameter("date_effet");
		         
		  JdbcBip jdbc = new JdbcBip(); 
		  Vector vParamOut = new Vector();
		  String message = "";
		  String result = "";
		  //String prof_flag = "M";
		  ParametreProc paramOut;
		  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		  
		  lParamProc.put("filtre_localize", filtre_localize);
		  lParamProc.put("date_effet", date_effet);
		  //lParamProc.put("profile_flag", prof_flag);
		  
		  logBipUser.debug("ProfilsLocalizeAction-existsProfilLocalize() --> filtre_localize :" + filtre_localize);
		  logBipUser.debug("ProfilsLocalizeAction-existsProfilLocalize() --> date_effet :" + date_effet);
			
		  // execution de la procedure PL/SQL
		  try {
			
			  vParamOut = jdbc.getResult(
						lParamProc, configProc, PROC_CHECK_PROFIL_LOCALIZE);
				// Recuperation des resultats
				
			  for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
					paramOut = (ParametreProc) e1.nextElement();
					
					if (paramOut.getNom().equals("message")) {
						if (paramOut.getValeur() != null) {
							message = (String) paramOut.getValeur();
						}
					} 
					if (paramOut.getNom().equals("result")) {
						if (paramOut.getValeur() != null) {
							result = (String) paramOut.getValeur();
						}
					}
									
				}
				
			}// try
			catch (BaseException be) {
				logBipUser.debug("ProfilsLocalizeAction-existsProfilLocalize() --> BaseException :" + be);
				logBipUser.debug("ProfilsLocalizeAction-existsProfilLocalize() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("ProfilsLocalizeAction-existsProfilLocalize() --> BaseException :" + be);
				logService.debug("ProfilsLocalizeAction-existsProfilLocalize() --> Exception :"
						+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du message
				// global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(
							BipException.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((DatesEffetForm) form).setMsgErreur(message);
					 jdbc.closeJDBC();
					 // On ecrit le message de retour du pl/sql dans la response
					  response.setContentType("text/html");
					  PrintWriter out = response.getWriter();
					  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
					  out.flush();
					  return PAS_DE_FORWARD;

				} else {
					// Erreur d''execution de la procedure stockee
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
					request.setAttribute("messageErreur", be.getInitialException()
							.getMessage());
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC();
					 //On ecrit le message de retour du pl/sql dans la response
					  response.setContentType("text/html");
					  PrintWriter out = response.getWriter();
					  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
					  out.flush();
					  return PAS_DE_FORWARD;
				}
			}

			 jdbc.closeJDBC();
			 if (result != null && result.equals("N") && message != null && !message.equals("")) {
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
			 }
			 
		  return PAS_DE_FORWARD;
		}
	
	/**
	 * Verification de non existance d'un profil LOCALLIZE
	 *  egale au profil LOCALIZE saisi
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 * @throws Exception
	 */
	public ActionForward notExistsProfilLocalize(
			ActionMapping mapping,ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws Exception {
		
		  String signatureMethode = "notExistsProfilLocalize(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc)";
		  logBipUser.entry(signatureMethode);
			
	      String filtre_localize = (String)request.getParameter("filtre_localize")!=null ?(String)request.getParameter("filtre_localize"): (String)request.getParameter("filtre_lst_localize");
	      String date_effet = (String)request.getParameter("date_effet");
		         
		  JdbcBip jdbc = new JdbcBip(); 
		  Vector vParamOut = new Vector();
		  String message = "";
		  String prof_flag = "C";
		  ParametreProc paramOut;
		  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		  
		  lParamProc.put("filtre_localize", filtre_localize);
		  lParamProc.put("date_effet", date_effet);
		  lParamProc.put("profile_flag", prof_flag);
		  
		  logBipUser.debug("ProfilsLocalizeAction-notExistsProfilLocalize() --> filtre_localize :" + filtre_localize);
		  logBipUser.debug("ProfilsLocalizeAction-notExistsProfilLocalize() --> date_effet :" + date_effet);
			
		  // execution de la procedure PL/SQL
		  try {
			
			  vParamOut = jdbc.getResult(
						lParamProc, configProc, PROC_EXISTS_PROFIL_LOCALIZE);
				// Recuperation des resultats
				
				for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
					paramOut = (ParametreProc) e1.nextElement();
					
					if (paramOut.getNom().equals("message")) {
						if (paramOut.getValeur() != null) {
							message = (String) paramOut.getValeur();
						}
					} 
					
									
				}
				
			}// try
			catch (BaseException be) {
				logBipUser.debug("ProfilsLocalizeAction-notExistsProfilLocalize() --> BaseException :" + be);
				logBipUser.debug("ProfilsLocalizeAction-notExistsProfilLocalize() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("ProfilsLocalizeAction-notExistsProfilLocalize() --> BaseException :" + be);
				logService.debug("ProfilsLocalizeAction-notExistsProfilLocalize() --> Exception :"
						+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du message
				// global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(
							BipException.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((DatesEffetForm) form).setMsgErreur(message);
					 jdbc.closeJDBC();
					 // On ecrit le message de retour du pl/sql dans la response
					  response.setContentType("text/html");
					  PrintWriter out = response.getWriter();
					  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
					  out.flush();
					  return PAS_DE_FORWARD;

				} else {
					// Erreur d''execution de la procedure stockee
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
					request.setAttribute("messageErreur", be.getInitialException()
							.getMessage());
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC();
					 //On ecrit le message de retour du pl/sql dans la response
					  response.setContentType("text/html");
					  PrintWriter out = response.getWriter();
					  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
					  out.flush();
					  return PAS_DE_FORWARD;
				}
			}

			 jdbc.closeJDBC();
			 
			  response.setContentType("text/html");
			  PrintWriter out = response.getWriter();
			  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
			  out.flush();

		  return PAS_DE_FORWARD;
		}
	
	public ActionForward estProfilLocAffecteRessMensAnnee(
			ActionMapping mapping,ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws Exception {
		
		  String signatureMethode = "estProfilLocAffecteRessMensAnnee(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc)";
		  logBipUser.entry(signatureMethode);
			
	      String filtre_localize = (String)request.getParameter("filtre_localize");
	      String date_effet = (String)request.getParameter("date_effet");
		         
		  JdbcBip jdbc = new JdbcBip(); 
		  Vector vParamOut = new Vector();
		  String message = "";
		  ParametreProc paramOut;
		  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		  
		  lParamProc.put("filtre_localize", filtre_localize);
		  lParamProc.put("date_effet", date_effet);
		  
		  logBipUser.debug("ProfilsLocalizeAction-estProfilLocAffecteRessMensAnnee() --> filtre_localize :" + filtre_localize);
		  logBipUser.debug("ProfilsLocalizeAction-estProfilLocAffecteRessMensAnnee() --> date_effet :" + date_effet);
			
		  // execution de la procedure PL/SQL
		  try {
			
			  vParamOut = jdbc.getResult(
						lParamProc, configProc, PROC_ESTPROFILAFFECTERESSMENSANNEE_PROFILLOCALIZE);
				// Recuperation des resultats
				
				for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
					paramOut = (ParametreProc) e1.nextElement();
					
					if (paramOut.getNom().equals("message")) {
						if (paramOut.getValeur() != null)
							message = (String) paramOut.getValeur();
					}
				}
				
			}// try
			catch (BaseException be) {
				logBipUser.debug("ProfilsLocalizeAction-estProfilLocAffecteRessMensAnnee() --> BaseException :" + be);
				logBipUser.debug("ProfilsLocalizeAction-estProfilLocAffecteRessMensAnnee() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("ProfilsLocalizeAction-estProfilLocAffecteRessMensAnnee() --> BaseException :" + be);
				logService.debug("ProfilsLocalizeAction-estProfilLocAffecteRessMensAnnee() --> Exception :"
						+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du message
				// global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(
							BipException.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((DatesEffetForm) form).setMsgErreur(message);
					 jdbc.closeJDBC();
					 // On ecrit le message de retour du pl/sql dans la response
					  response.setContentType("text/html");
					  PrintWriter out = response.getWriter();
					  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
					  out.flush();
					  return PAS_DE_FORWARD;

				} else {
					// Erreur d''execution de la procedure stockee
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
					request.setAttribute("messageErreur", be.getInitialException()
							.getMessage());
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC();
					 //On ecrit le message de retour du pl/sql dans la response
					  response.setContentType("text/html");
					  PrintWriter out = response.getWriter();
					  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
					  out.flush();
					  return PAS_DE_FORWARD;
				}
			}

			 jdbc.closeJDBC();
			 
		  // On ecrit le message de retour du pl/sql dans la response
		  response.setContentType("text/html");
		  PrintWriter out = response.getWriter();
		  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
		  out.flush();

		  return PAS_DE_FORWARD;
		}
	
	
	/**
	 * Rï¿½cupï¿½ration des informations pour affichage de l'ï¿½cran de crï¿½ation de profil Localize
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	protected ActionForward creer(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws ServletException{
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message="";
		String libelle="";
		boolean msg=false;
		ParametreProc paramOut;
		
		String signatureMethode ="ProfilsLocalizeAction -creer( mapping, form , request,  response,  errors )";

		//logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		//exécution de la procédure PL/SQL	
		try {
			if(hParamProc.get("filtre_lst_localize")!=null)
			{
				((ProfilsLocalizeForm)form).setEcran_appel("list");
				vParamOut= jdbc.getResult (hParamProc,configProc,PACK_LIB_LIST_LOCALIZE);
			}
			else
			{
			((ProfilsLocalizeForm)form).setEcran_appel("initial");
			vParamOut= jdbc.getResult (hParamProc,configProc,PACK_LIB_LOCALIZE);
			}
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				  paramOut = (ParametreProc) e.nextElement();

				//récupérer le libelle
				if (paramOut.getNom().equals("libelle")) {
					libelle=(String)paramOut.getValeur();
					((ProfilsLocalizeForm)form).setLibelle(libelle);
				}  
				//récupérer le message
				if (paramOut.getNom().equals("message")) {
					message=(String)paramOut.getValeur();
					if(message != null)
						msg = true;
					else{
						msg = false;
						jdbc.closeJDBC(); return mapping.findForward("ecran");
					}
				}
				
				if (msg) {	
					//le profil de DomFonc n'existe pas, on récupère le message 
					((ProfilsLocalizeForm)form).setMsgErreur(message);
					logBipUser.exit(signatureMethode);
					//on reste sur la même page
					jdbc.closeJDBC(); return mapping.findForward("initial");
				}

			}	
			// ----------------------------------------------------------
		}

		catch (BaseException be) {
			logBipUser.debug("ProfilsLocalizeAction-creer() --> BaseException :"+be);
			logBipUser.debug("ProfilsLocalizeAction-creer() --> Exception :"+be.getInitialException().getMessage());
			logService.debug("ProfilsLocalizeAction-creer() --> BaseException :"+be);
			logService.debug("ProfilsLocalizeAction-creer() --> Exception :"+be.getInitialException().getMessage());
			//Erreur d''exécution de la procédure stockée
			errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
			//this.saveErrors(request,errors);
			jdbc.closeJDBC(); return mapping.findForward("error");
		}	
			
		//logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		jdbc.closeJDBC(); return mapping.findForward("ecran");
		
	}//creer
	
	/**
	 * Recuperation des informations pour affichage de l'ecran de modification de profil DomFonc
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	protected ActionForward consulter(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ){
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		
		String signatureMethode =
			"ProfilsLocalizeAction-modifier(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ProfilsLocalizeForm bipForm= (ProfilsLocalizeForm)form ;
		
		//exécution de la procédure PL/SQL	
		try {
			if ((String)hParamProc.get("filtre_lst_localize") != null) {
				bipForm.setEcran_appel("list");
				vParamOut= jdbc.getResult (hParamProc,configProc,PACK_SELECT_LIST);
			} else {
				bipForm.setEcran_appel("initial");
				vParamOut = jdbc.getResult (hParamProc,configProc,PACK_SELECT);
			}
	
			//Récupération des résultats
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				  paramOut = (ParametreProc) e.nextElement();
				
				if (paramOut.getNom().equals("curseur")) {
					//Récupération du Ref Cursor
					ResultSet rset =(ResultSet)paramOut.getValeur();
			
					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setProfil_localize(rset.getString(1));
							bipForm.setLibelle(rset.getString(2)); 
							
							Date date_effet = rset.getDate(3);
							if (date_effet != null) {
								SimpleDateFormat sdf = new SimpleDateFormat("yyyy", Locale.FRANCE);
								bipForm.setDate_effet((sdf.format(date_effet)).toString());
							}
 
							bipForm.setTop_actif(rset.getString(4)); 
							if (rset.getString(5) != null) {
								bipForm.setForce_travail(rset.getString(5).replace(".", ","));
							}
							if (rset.getString(6) != null) {
								bipForm.setFrais_environnement(rset.getString(6).replace(".", ","));
							}
							bipForm.setCommentaire(rset.getString(7));  
							bipForm.setCoddir(rset.getString(8));
							bipForm.setProfil_defaut(rset.getString(9));
							bipForm.setCodelocal(rset.getString(10));
							bipForm.setCode_es(rset.getString(11));
						}  
					}//try
					catch (SQLException sqle) {
						logService.debug("ProfilsLocalizeAction-modifier() --> SQLException :"+sqle);
						logBipUser.debug("ProfilsLocalizeAction-modifier() --> SQLException :"+sqle);
						//Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
						//this.saveErrors(request,errors);
						jdbc.closeJDBC(); return mapping.findForward("error");
					}
					finally {
						try {
							if (rset != null)
								rset.close();
						}
						catch (SQLException sqle) {
							logBipUser.debug("ProfilsLocalizeAction-modifier() --> SQLException-rset.close() :"+sqle);
							//Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
							jdbc.closeJDBC(); return mapping.findForward("error");
						}
					}
				}//if
			}//for
		}//try
		catch (Exception be) {
			logBipUser.debug("ProfilsLocalizeAction-modifier() --> BaseException :"+be, be);
			logBipUser.debug("ProfilsLocalizeAction-modifier() --> Exception :"+be.getMessage());

			logService.debug("ProfilsLocalizeAction-modifier() --> BaseException :" + be, be);
			logService.debug("ProfilsLocalizeAction-modifier() --> Exception :" + be.getMessage());	
			errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));

			//this.saveErrors(request,errors);
			jdbc.closeJDBC(); return mapping.findForward("error");
		}	
		logBipUser.exit(signatureMethode);

		jdbc.closeJDBC(); return mapping.findForward("ecran");
		
		
	}
		
//	protected ActionForward supprimer(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ){
//		return null;
//	}	
	
	/**
	 * Action d'annulation (retour à l'écran appelant	)
	 */
	protected ActionForward annuler(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ){
		String signatureMethode ="ProfilsLocalizeAction - isValidCodeDir";
		logBipUser.entry(signatureMethode);
		
		String redirection = null;
		
		ProfilsLocalizeForm profilsLocalizeForm = (ProfilsLocalizeForm) form;
		redirection = profilsLocalizeForm.getEcran_appel();
	
		logBipUser.exit(signatureMethode);
		return mapping.findForward(redirection);
	}
	
	/**
	 * Action de création / modification / suppression, puis retour à l'écran d'appel
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	protected  ActionForward valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProctest ) throws ServletException{
	    Vector vParamOut = new Vector();
	    String cle = null;
	    String message=null;
	    
	    String signatureMethode =
			"valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:"+mode);
		//On récupère la clé pour trouver le nom de la procédure stockée dans bip_proc.properties
		
		if(hParamProctest.get("filtre_lst_localize")==null || "".equals(hParamProctest.get("filtre_lst_localize")) )
		{
		cle=recupererCle(mode);
		}
		else
		{
		cle=recupererCleList(mode);
		}

		JdbcBip jdbc1 = new JdbcBip(); 

		
		//On exécute la procédure stockée
		try {
		
			vParamOut=jdbc1.getResult ( hParamProctest,configProc,cle);
			try {
					message=jdbc1.recupererResult(vParamOut,"valider");
					
			 	}
			 	catch (BaseException be) {
			 		logBipUser.debug("valider() --> BaseException :"+be);
					logBipUser.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			 		logService .debug("valider() --> BaseException :"+be);
					logService .debug("valider() --> Exception :"+be.getInitialException().getMessage());
					errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
					 jdbc1.closeJDBC(); return mapping.findForward("error");
			 	}
			 	if (message!=null && !message.equals("")) {
				// on récupère le message 
					((AutomateForm)form).setMsgErreur(message);
					logBipUser.debug("valider() -->message :"+message);
				}
				
		} catch (BaseException be) {

			logService.debug("valider() --> BaseException :"+be);
			logService.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :"+be);
			logBipUser.debug("valider() --> Exception :"+be.getInitialException().getMessage());
			//Si exception sql alors extraire le message d'erreur du message global
			if (be.getInitialException().getClass().getName().equals("java.sql.SQLException")){
				message = BipException.getMessageFocus(BipException.getMessageOracle(be.getInitialException().getMessage()), form);


				((AutomateForm)form).setMsgErreur(message);
			
				if (!mode.equals("delete")) {
					 jdbc1.closeJDBC(); return mapping.findForward("ecran") ;
				}
			}
			else {
				//Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
		    	request.setAttribute("messageErreur",be.getInitialException().getMessage());

				 jdbc1.closeJDBC(); return mapping.findForward("error");
			}
		}	
		//Si l'élément sur lequel on vient de faire une MàJ est un paramètre BIP au code action commençant par RTFE, 
		//on recharge le paramétrage RTFE depuis la base.
		String codaction = (String)hParamProctest.get("codaction");
		if(codaction!=null && "RTFE".equals(codaction.substring(0, 4))){
			BipConfigRTFE.getInstance().rechargerConfigRTFE();
		}

		logBipUser.exit(signatureMethode);
		if (mode.equals("delete") && (hParamProctest.get("filtre_lst_domfonc")!=null && !"".equals(hParamProctest.get("filtre_lst_domfonc")))) {
			 jdbc1.closeJDBC(); return mapping.findForward("list") ;
		} else if (mode.equals("delete") && (hParamProctest.get("filtre_lst_localize")!=null && !"".equals(hParamProctest.get("filtre_lst_localize")))) {
			 jdbc1.closeJDBC(); return mapping.findForward("list") ;
		}
		else
		{
		 jdbc1.closeJDBC(); 
		 //return mapping.findForward("initial") ;
		 ProfilsLocalizeForm profilsLocalizeForm = (ProfilsLocalizeForm) form;
		 if (null != profilsLocalizeForm.getEcran_appel()) {
			 return mapping.findForward(profilsLocalizeForm.getEcran_appel());
		 }else {
			 return mapping.findForward("initial") ;
		 }		 
		}

	}//valider

	
	public ActionForward isValidCodeDir(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ProfilsLocalizeAction - isValidCodeDir";
		
		return traitementAjax(PROC_ISVALID_CODEDIR, signatureMethode, mapping, form, response, hParamProc);
	}
	
	public ActionForward isValidCodeEs(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ProfilsLocalizeAction - isValidCodeEs";
		
		return traitementAjax(PROC_ISVALID_CODEES, signatureMethode, mapping, form, response, hParamProc);
	}
		
	public ActionForward notExistsProfilDefaut(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ProfilsLocalizeAction - notExistsProfilDefaut";
		
		return traitementAjax(PROC_NOTEXISTS_PROFILDEFAUT, signatureMethode, mapping, form, response, hParamProc);
	}
	
	public ActionForward notExistsProfilDefautMaj(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ProfilsLocalizeAction - notExistsProfilDefaut";
		
		return traitementAjax(PROC_NOTEXISTS_PROFILDEFAUT_MAJ, signatureMethode, mapping, form, response, hParamProc);
	}
	
	/**
	 * @param cleProc
	 * @param signatureMethode
	 * @param mapping
	 * @param form
	 * @param response
	 * @param hParamProc
	 * @return
	 * @throws IOException
	 */
	private ActionForward traitementAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		BipForm bipForm = (BipForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		
		// Appel de la procï¿½dure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null) {
						message = (String) paramOut.getValeur();
					}
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			message = BipException.getMessageFocus(
					BipException.getMessageOracle(be.getInitialException()
							.getMessage()), form);
			
			if (!be.getInitialException().getClass().getName().equals(
			"java.sql.SQLException")) {
				// Erreur d'exï¿½cution
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			} 
		}	
		
		jdbc.closeJDBC();
		
		// Ecriture du message de retour dans la response
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	
	protected String recupererCle(String mode) {
		String cle = null;
		if ("insert".equals(mode)){
			cle=PROC_INSERT;
		}
		else if ("update".equals(mode)){
			cle=PROC_UPDATE;
		}
		else if ("delete".equals(mode)){
			cle=PROC_DELETE;
		}
		return cle;
	}
	
	protected String recupererCleList(String mode) {
		String cle = null;
		if ("insert".equals(mode)){
			cle=PROC_INSERT_LIST;
		}
		else if ("update".equals(mode)){
			cle=PROC_UPDATE_LIST;
		}
		else if ("delete".equals(mode)){
			cle=PROC_DELETE_LIST;
		}
		return cle;
	} 
	
	/* (non-Javadoc)
	 * @see com.socgen.bip.commun.action.AutomateAction#suite(org.apache.struts.action.ActionMapping, org.apache.struts.action.ActionForm, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, org.apache.struts.action.ActionErrors, java.util.Hashtable)
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
	
		String signatureMethode ="ProfilsLocalizeAction -lister( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		
		return mapping.findForward("list");	
					
	}
	
	/* (non-Javadoc)
	 * @see com.socgen.bip.commun.action.AutomateAction#refresh(org.apache.struts.action.ActionMapping, org.apache.struts.action.ActionForm, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, org.apache.struts.action.ActionErrors, java.util.Hashtable)
	 */
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
			 
		return mapping.findForward("list");

}
}
