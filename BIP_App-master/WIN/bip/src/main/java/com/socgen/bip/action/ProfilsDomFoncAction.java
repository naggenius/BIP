package com.socgen.bip.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.socgen.bip.form.ProfilsDomFoncForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * Action de gestion des profils par Domaine Fonctionnel
 */
public class ProfilsDomFoncAction extends AutomateAction {

	/**
	 * Clefs des procedures de creation / modification / suppression
	 */
	private static String PROC_INSERT = "profildomfonc.creer.proc";
	private static String PROC_UPDATE = "profildomfonc.modifier.proc";
	private static String PROC_DELETE = "profildomfonc.supprimer.proc";
	
	/**
	 * Clefs des procedures de creation / modification / suppression a partir de la liste
	 */
	private static String PROC_INSERT_LIST = "profildomfonc.creerlist.proc";
	private static String PROC_UPDATE_LIST = "profildomfonc.modifierlist.proc";
	private static String PROC_DELETE_LIST = "profildomfonc.supprimerlist.proc";
	
	private static String PROC_NOTEXISTS_PROFILDEFAUT_MAJ = "profildomfonc.notexistsprofildefautmaj.proc";

	/**
	 * Clefs des autres procedures
	 */
	private static String PROC_ISVALID_CODEDIR = "profilfi2.isvalidcodedir.proc";
	private static String PROC_NOTEXISTS_PROFILDEFAUT = "profildomfonc.notexistsprofildefaut.proc";
	private static String PROC_ISVALID_PROFILDOMFONC = "profildomfonc.isvalidprofildomfonc.proc";
	/*PROC_EXISTS_PROFILFI CHANGED THIS VALUE FOR UNICITY CHECK*/
	//private static String PROC_EXISTS_PROFILFI = "profilfi.exists.proc";
	private static String PROC_EXISTS_PROFILFI = "profilfi.profilloc.exists.proc";
	private static String PROC_EXISTS_PROFILDOMFONC = "profildomfonc.exists.proc";
	private static String PROC_ESTPROFILAFFECTERESSMENSANNEE_PROFILDOMFONC = "profildomfonc.estprofilaffecteressmensannee.proc";
	private static String PROC_ISVALID_CODEES = "profildomfonc.isvalidcodees.proc";
	
	private static String PACK_LIB = "profildomfonc.getlibelleprofildomfonc.proc";
	private static String PACK_LIB_LIST = "profildomfonc.getlibelleprofildomfonclist.proc";
    private static String PACK_SELECT = "profildomfonc.consulter.proc";
	private static String PACK_SELECT_LIST = "profildomfonc.listConsulter.proc";
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
	 *  dans l ecran GESTION DES PROFILS DOMFONC
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 */
	public ActionForward isValidProfilDomFonc (
			ActionMapping mapping,ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws Exception {
		
		String signatureMethode = "isValidProfilDomFonc(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc)";
		logBipUser.entry(signatureMethode);
		
      String filtre_domfonc = (String)request.getParameter("filtre_domfonc");
	  String filtre_date = (String)request.getParameter("filtre_date");
	         
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("filtre_domfonc", filtre_domfonc);
	  lParamProc.put("filtre_date", filtre_date);
	  
	  logBipUser.debug("ProfilsDomFoncAction-isValidProfilDomFonc() --> filtre_domfonc :" + filtre_domfonc);
	  logBipUser.debug("ProfilsDomFoncAction-isValidProfilDomFonc() --> filtre_date :" + filtre_date);
	  
	  
	  // execution de la procedure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PROC_ISVALID_PROFILDOMFONC);
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
			logBipUser.debug("ProfilsDomFoncAction-isValidProfilDomFonc() --> BaseException :" + be);
			logBipUser.debug("ProfilsDomFoncAction-isValidProfilDomFonc() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ProfilsDomFoncAction-isValidProfilDomFonc() --> BaseException :" + be);
			logService.debug("ProfilsDomFoncAction-isValidProfilDomFonc() --> Exception :"
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
	 *  egale au profil DOMFONC saisi
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 * @throws Exception
	 */
	public ActionForward existsProfilFI(
			ActionMapping mapping,ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws Exception {
		
	  String signatureMethode = "existsProfilFI(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc)";
	  logBipUser.entry(signatureMethode);
		
      String filtre_domfonc = (String)request.getParameter("filtre_domfonc");
	         
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("filtre_domfonc", filtre_domfonc);
	  
	  logBipUser.debug("ProfilsDomFoncAction-existsProfilFI() --> filtre_domfonc :" + filtre_domfonc);
		
	  // execution de la procedure PL/SQL
	  try {
		
		  vParamOut = jdbc.getResult(
					lParamProc, configProc, PROC_EXISTS_PROFILFI);
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
			logBipUser.debug("ProfilsDomFoncAction-existsProfilFI() --> BaseException :" + be);
			logBipUser.debug("ProfilsDomFoncAction-existsProfilFI() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ProfilsDomFoncAction-existsProfilFI() --> BaseException :" + be);
			logService.debug("ProfilsDomFoncAction-existsProfilFI() --> Exception :"
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
	 * Verification de l'existance d'un profil DOMFONC
	 *  egale au profil DOMFONC saisi
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 * @throws Exception
	 */
	public ActionForward existsProfilDomFonc(
			ActionMapping mapping,ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws Exception {
		
		  String signatureMethode = "existsProfilDomFonc(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc)";
		  logBipUser.entry(signatureMethode);
			
	      String filtre_domfonc = (String)request.getParameter("filtre_domfonc");
	      String date_effet = (String)request.getParameter("date_effet");
		         
		  JdbcBip jdbc = new JdbcBip(); 
		  Vector vParamOut = new Vector();
		  String message = "";
		  String result = "";
		  ParametreProc paramOut;
		  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		  
		  lParamProc.put("filtre_domfonc", filtre_domfonc);
		  lParamProc.put("date_effet", date_effet);
		  
		  logBipUser.debug("ProfilsDomFoncAction-existsProfilDomFonc() --> filtre_domfonc :" + filtre_domfonc);
		  logBipUser.debug("ProfilsDomFoncAction-existsProfilDomFonc() --> date_effet :" + date_effet);
			
		  // execution de la procedure PL/SQL
		  try {
			
			  vParamOut = jdbc.getResult(
						lParamProc, configProc, PROC_EXISTS_PROFILDOMFONC);
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
				logBipUser.debug("ProfilsDomFoncAction-existsProfilDomFonc() --> BaseException :" + be);
				logBipUser.debug("ProfilsDomFoncAction-existsProfilDomFonc() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("ProfilsDomFoncAction-existsProfilDomFonc() --> BaseException :" + be);
				logService.debug("ProfilsDomFoncAction-existsProfilDomFonc() --> Exception :"
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
			  // On ecrit le message de retour du pl/sql dans la response
			  response.setContentType("text/html");
			  PrintWriter out = response.getWriter();
			  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
			  out.flush();
		 }

		  return PAS_DE_FORWARD;
		}
	
	/**
	 * Verification de non existance d'un profil DOMFONC
	 *  egale au profil DOMFONC saisi
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @param hParamProc
	 * @return
	 * @throws Exception
	 */
	public ActionForward notExistsProfilDomFonc(
			ActionMapping mapping,ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws Exception {
		
		  String signatureMethode = "notExistsProfilDomFonc(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc)";
		  logBipUser.entry(signatureMethode);
			
	      String filtre_domfonc = (String)request.getParameter("filtre_domfonc")!=null ?(String)request.getParameter("filtre_domfonc"): (String)request.getParameter("filtre_lst_domfonc");
	      String date_effet = (String)request.getParameter("date_effet");
		         
		  JdbcBip jdbc = new JdbcBip(); 
		  Vector vParamOut = new Vector();
		  String message = "";
		  String result = "";
		  ParametreProc paramOut;
		  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		  
		  lParamProc.put("filtre_domfonc", filtre_domfonc);
		  lParamProc.put("date_effet", date_effet);
		  
		  logBipUser.debug("ProfilsDomFoncAction-notExistsProfilDomFonc() --> filtre_domfonc :" + filtre_domfonc);
		  logBipUser.debug("ProfilsDomFoncAction-notExistsProfilDomFonc() --> date_effet :" + date_effet);
			
		  // execution de la procedure PL/SQL
		  try {
			
			  vParamOut = jdbc.getResult(
						lParamProc, configProc, PROC_EXISTS_PROFILDOMFONC);
				// Recuperation des resultats
				
				for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
					paramOut = (ParametreProc) e1.nextElement();
					
					if (paramOut.getNom().equals("message")) {
						if (paramOut.getValeur() != null) {
							message = (String) paramOut.getValeur();
						}
					} 
					if (paramOut.getNom().equals("result")) {
						if (paramOut.getValeur() != null){
							result = (String) paramOut.getValeur();
						}
					}
									
				}
				
			}// try
			catch (BaseException be) {
				logBipUser.debug("ProfilsDomFoncAction-notExistsProfilDomFonc() --> BaseException :" + be);
				logBipUser.debug("ProfilsDomFoncAction-notExistsProfilDomFonc() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("ProfilsDomFoncAction-notExistsProfilDomFonc() --> BaseException :" + be);
				logService.debug("ProfilsDomFoncAction-notExistsProfilDomFonc() --> Exception :"
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
			 
		 if (result != null && result.equals("O") && message != null && !message.equals("")) {
			  // On ecrit le message de retour du pl/sql dans la response
			  response.setContentType("text/html");
			  PrintWriter out = response.getWriter();
			  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
			  out.flush();
		 }

		  return PAS_DE_FORWARD;
		}
	
	public ActionForward estProfilAffecteRessMensAnnee(
			ActionMapping mapping,ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws Exception {
		
		  String signatureMethode = "estProfilAffecteRessMensAnnee(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc)";
		  logBipUser.entry(signatureMethode);
			
	      String filtre_domfonc = (String)request.getParameter("filtre_domfonc");
	      String date_effet = (String)request.getParameter("date_effet");
		         
		  JdbcBip jdbc = new JdbcBip(); 
		  Vector vParamOut = new Vector();
		  String message = "";
		  ParametreProc paramOut;
		  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		  
		  lParamProc.put("filtre_domfonc", filtre_domfonc);
		  lParamProc.put("date_effet", date_effet);
		  
		  logBipUser.debug("ProfilsDomFoncAction-estProfilAffecteRessMensAnnee() --> filtre_domfonc :" + filtre_domfonc);
		  logBipUser.debug("ProfilsDomFoncAction-estProfilAffecteRessMensAnnee() --> date_effet :" + date_effet);
			
		  // execution de la procedure PL/SQL
		  try {
			
			  vParamOut = jdbc.getResult(
						lParamProc, configProc, PROC_ESTPROFILAFFECTERESSMENSANNEE_PROFILDOMFONC);
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
				logBipUser.debug("ProfilsDomFoncAction-estProfilAffecteRessMensAnnee() --> BaseException :" + be);
				logBipUser.debug("ProfilsDomFoncAction-estProfilAffecteRessMensAnnee() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("ProfilsDomFoncAction-estProfilAffecteRessMensAnnee() --> BaseException :" + be);
				logService.debug("ProfilsDomFoncAction-estProfilAffecteRessMensAnnee() --> Exception :"
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
	 * Rï¿½cupï¿½ration des informations pour affichage de l'ï¿½cran de crï¿½ation de profil DomFonc
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
		
		String signatureMethode ="ProfilsDomFoncAction -creer( mapping, form , request,  response,  errors )";

		//logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		//exécution de la procédure PL/SQL	
		try {
			if(hParamProc.get("filtre_lst_domfonc")!=null)
			{
				((ProfilsDomFoncForm)form).setEcran_appel("list");
				vParamOut= jdbc.getResult (hParamProc,configProc,PACK_LIB_LIST);
			}
			else
			{
			((ProfilsDomFoncForm)form).setEcran_appel("initial");
			vParamOut= jdbc.getResult (hParamProc,configProc,PACK_LIB);
			}
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				  paramOut = (ParametreProc) e.nextElement();

				//récupérer le libelle
				if (paramOut.getNom().equals("libelle")) {
					libelle=(String)paramOut.getValeur();
					((ProfilsDomFoncForm)form).setLibelle(libelle);
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
					((ProfilsDomFoncForm)form).setMsgErreur(message);
					logBipUser.exit(signatureMethode);
					//on reste sur la même page
					jdbc.closeJDBC(); return mapping.findForward("initial");
				}

			}	
			// ----------------------------------------------------------
		}

		catch (BaseException be) {
			logBipUser.debug("ProfilsDomFoncAction-creer() --> BaseException :"+be);
			logBipUser.debug("ProfilsDomFoncAction-creer() --> Exception :"+be.getInitialException().getMessage());
			logService.debug("ProfilsDomFoncAction-creer() --> BaseException :"+be);
			logService.debug("ProfilsDomFoncAction-creer() --> Exception :"+be.getInitialException().getMessage());
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
			"ProfilsDomFoncAction-modifier(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ProfilsDomFoncForm bipForm= (ProfilsDomFoncForm)form ;
		
		//exécution de la procédure PL/SQL	
		try {
			if ((String)hParamProc.get("filtre_lst_domfonc") != null) {
				bipForm.setEcran_appel("list");
				vParamOut= jdbc.getResult (hParamProc,configProc,PACK_SELECT_LIST);
			} else {
				bipForm.setEcran_appel("initial");
				 vParamOut= jdbc.getResult (hParamProc,configProc,PACK_SELECT);
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
							bipForm.setProfil_domfonc(rset.getString(1));
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
							bipForm.setCode_es(rset.getString(10));
						}  
					}//try
					catch (SQLException sqle) {
						logService.debug("ProfilsDomFoncAction-modifier() --> SQLException :"+sqle);
						logBipUser.debug("ProfilsDomFoncAction-modifier() --> SQLException :"+sqle);
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
							logBipUser.debug("ProfilsDomFoncAction-modifier() --> SQLException-rset.close() :"+sqle);
							//Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
							jdbc.closeJDBC(); return mapping.findForward("error");
						}
					}
				}//if
			}//for
		}//try
		catch (BaseException be) {
			logBipUser.debug("ProfilsDomFoncAction-modifier() --> BaseException :"+be, be);
			logBipUser.debug("ProfilsDomFoncAction-modifier() --> Exception :"+be.getInitialException().getMessage());

			logService.debug("ProfilsDomFoncAction-modifier() --> BaseException :" + be, be);
			logService.debug("ProfilsDomFoncAction-modifier() --> Exception :" + be.getInitialException().getMessage());	
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
		String signatureMethode ="ProfilsDomFoncAction - isValidCodeDir";
		logBipUser.entry(signatureMethode);
		
		String redirection = null;
		
		ProfilsDomFoncForm profilsDomFoncForm = (ProfilsDomFoncForm) form;
		redirection = profilsDomFoncForm.getEcran_appel();
	
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
		
		if(hParamProctest.get("filtre_lst_domfonc")==null || "".equals(hParamProctest.get("filtre_lst_domfonc")) )
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
		}
		else
		{
		 jdbc1.closeJDBC(); return mapping.findForward("initial") ;
		}

	}//valider

	
	public ActionForward isValidCodeDir(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ProfilsDomFoncAction - isValidCodeDir";
		
		return traitementAjax(PROC_ISVALID_CODEDIR, signatureMethode, mapping, form, response, hParamProc);
	}
	
	public ActionForward isValidCodeEs(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ProfilsDomFoncAction - isValidCodeEs";
		
		return traitementAjax(PROC_ISVALID_CODEES, signatureMethode, mapping, form, response, hParamProc);
	}
		
	public ActionForward notExistsProfilDefaut(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ProfilsDomFoncAction - notExistsProfilDefaut";
		
		return traitementAjax(PROC_NOTEXISTS_PROFILDEFAUT, signatureMethode, mapping, form, response, hParamProc);
	}
	
	public ActionForward notExistsProfilDefautMaj(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="ProfilsDomFoncAction - notExistsProfilDefaut";
		
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
	
		String signatureMethode ="ProfilsDomFoncAction -lister( mapping, form , request,  response,  errors )";
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
