package com.socgen.bip.action;

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

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DatesEffetForm;
import com.socgen.bip.form.ProfilsFIForm;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author O. EL KHABZI - 13/01/2012
 *
 * Formulaire pour mise à jour des Profils de FI
 * chemin : Administration/Tables/Mise à Jour/Profils de FI
 * pages  : fmProfilsFIAd.jsp / mProfilsFIAd.jsp / lProfilsFI.jsp
 * pl/sql : profil_fi.sql
 */
public class ProfilsFIAction extends AutomateAction {

	private static String PACK_SELECT = "profilfi.consulter.proc";
	private static String PACK_INSERT = "profilfi.creer.proc";
	private static String PACK_UPDATE = "profilfi.modifier.proc";
	private static String PACK_DELETE = "profilfi.supprimer.proc";
	private static String PACK_AJAX_CODIR   = "profilfi2.isvalidcodedir.proc";
	private static String PACK_AJAX_FI   = "profilfi.isvalidprofilfi.proc";
	private static String PACK_AJAX   		= "profilfi.isfiressource.proc";
	private static String PACK_LIB   		= "profilfi.getlibelleprofilfi.proc";

	
   /**
	* Action qui permet de créer un code Profil de FI
	*/
	protected ActionForward creer(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws ServletException{
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message="";
		String libelle="";
		boolean msg=false;
		ParametreProc paramOut;
		
		String signatureMethode ="ProfilsFIAction -creer( mapping, form , request,  response,  errors )";

		//logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		//exécution de la procédure PL/SQL	
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc,PACK_LIB);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				  paramOut = (ParametreProc) e.nextElement();

				//récupérer le libelle
				if (paramOut.getNom().equals("libelle")) {
					libelle=(String)paramOut.getValeur();
					((ProfilsFIForm)form).setLibelle(libelle);
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
					//le profil de FI n'existe pas, on récupère le message 
					((ProfilsFIForm)form).setMsgErreur(message);
					logBipUser.exit(signatureMethode);
					//on reste sur la même page
					jdbc.closeJDBC(); return mapping.findForward("initial");
				}

			}	
			// ----------------------------------------------------------
		}

		catch (BaseException be) {
			logBipUser.debug("ProfilsFIAction-creer() --> BaseException :"+be);
			logBipUser.debug("ProfilsFIAction-creer() --> Exception :"+be.getInitialException().getMessage());
			logService.debug("ProfilsFIAction-creer() --> BaseException :"+be);
			logService.debug("ProfilsFIAction-creer() --> Exception :"+be.getInitialException().getMessage());
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
	* Action qui permet de visualiser les données liées à un code client pour la modification et la suppression
	*/
	protected  ActionForward consulter(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors , Hashtable hParamProc) throws ServletException{
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message="";
		boolean msg=false;
		ParametreProc paramOut;
		
		String signatureMethode =
			"ClientAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ProfilsFIForm bipForm= (ProfilsFIForm)form ;
		
		//exécution de la procédure PL/SQL	
		try {
			 vParamOut= jdbc.getResult (hParamProc,configProc,PACK_SELECT);
	
		//Récupération des résultats
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				  paramOut = (ParametreProc) e.nextElement();
				
				//récupérer le message
				if (paramOut.getNom().equals("message")) {
					message=(String)paramOut.getValeur();
				}
			
				if (paramOut.getNom().equals("msg_fi_ress")) {
					bipForm.setMessage_fi_ress((String)paramOut.getValeur());
				}
				
				if (paramOut.getNom().equals("curseur")) {
					//Récupération du Ref Cursor
					ResultSet rset =(ResultSet)paramOut.getValeur();
			
					try {
					logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setProfi(rset.getString(1));
							bipForm.setLibelle(rset.getString(2)); 
							
							Date date_effet = rset.getDate(3);
							if (date_effet != null) {
							SimpleDateFormat sdf = new SimpleDateFormat("MM/yyyy", Locale.FRANCE);
							bipForm.setDate_effet((sdf.format(date_effet)).toString());
							}
 
							bipForm.setTop_actif(rset.getString(4));  
							bipForm.setCout(rset.getString(5).replace(".", ","));  
							bipForm.setCommentaire(rset.getString(6));  
							bipForm.setCoddir(rset.getString(7));  
							bipForm.setTopegalprestation(rset.getString(8));  
							bipForm.setPrestation(rset.getString(9));  
							bipForm.setTopegallocalisation(rset.getString(10));  
							bipForm.setLocalisation(rset.getString(11));  
							bipForm.setTopegales(rset.getString(12));  
							bipForm.setCode_es(rset.getString(13));
							bipForm.setMsgErreur(message);
							

						}
						else{
							msg=true;
						}    
					}//try
					catch (SQLException sqle) {
						logService.debug("ProfilsFIAction-consulter() --> SQLException :"+sqle);
						logBipUser.debug("ProfilsFIAction-consulter() --> SQLException :"+sqle);
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
							logBipUser.debug("ProfilsFIAction-consulter() --> SQLException-rset.close() :"+sqle);
							//Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
							jdbc.closeJDBC(); return mapping.findForward("error");
						}
					}
				}//if
			}//for
			if (msg) {	
				//le profil de FI n'existe pas, on récupère le message 
				bipForm.setMsgErreur(message);
				//on reste sur la même page
				jdbc.closeJDBC(); return mapping.findForward("initial");
			}	
		}//try
		catch (BaseException be) {
			logBipUser.debug("ProfilsFIAction-consulter() --> BaseException :"+be, be);
			logBipUser.debug("ProfilsFIAction-consulter() --> Exception :"+be.getInitialException().getMessage());

			logService.debug("ProfilsFIAction-consulter() --> BaseException :"+be, be);
			logService.debug("ProfilsFIAction-consulter() --> Exception :"+be.getInitialException().getMessage());	
			errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));

			//this.saveErrors(request,errors);
			jdbc.closeJDBC(); return mapping.findForward("error");
		}	
		logBipUser.exit(signatureMethode);

		jdbc.closeJDBC(); return mapping.findForward("ecran");
		
		
	}
	
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
	
		String signatureMethode ="ProfilsFIAction -lister( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		
		return mapping.findForward("list");	
					
	}
	
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

			return mapping.findForward("initial");

	}
	

	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
			 
		return mapping.findForward("list");

	}
	
	protected ActionForward suite1(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		return mapping.findForward("list");
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")){
			cle=PACK_INSERT;
		}
		else if (mode.equals("update")){
			cle=PACK_UPDATE;
		}
		else if (mode.equals("delete")){
			cle=PACK_DELETE;
		}
		return cle;
	}
	
	
	 //Action dédiée à un appel Ajax qui vérifie si un code direction existe déjà
	 public ActionForward isValidCodeDir(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		String signatureMethode = "isValidCodeDir(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
	  String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getInfosUser();
	  String coddir = (String)request.getParameter("coddir"); 
	         
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("coddir", coddir);
	  lParamProc.put("userid", userid);
	  
	  logBipUser.debug("ProfilsFIAction-isValidCodeDir() --> userid :" +userid);
	  logBipUser.debug("ProfilsFIAction-isValidCodeDir() --> coddir :" +coddir);
	  
	  
	  // exécution de la procédure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_AJAX_CODIR);
			// Récupération des résultats
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
								
			}			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("ProfilsFIAction-isValidCodeDir() --> BaseException :" + be);
			logBipUser.debug("ProfilsFIAction-isValidCodeDir() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ProfilsFIAction-isValidCodeDir() --> BaseException :" + be);
			logService.debug("ProfilsFIAction-isValidCodeDir() --> Exception :"
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
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC();
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On écrit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	  out.flush();

	  return PAS_DE_FORWARD;
	 }
	
	 //Action dédiée à un appel Ajax qui vérifie si un Profil FI existe déjà
	 public ActionForward isValidProfilFI(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		String signatureMethode = "isValidProfilFI(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
	  String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getInfosUser();
	  String filtre_fi = (String)request.getParameter("filtre_fi"); 
	         
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("filtre_fi", filtre_fi);
	  lParamProc.put("userid", userid);
	  
	  logBipUser.debug("ProfilsFIListAction-isValidProfilFI() --> userid :" +userid);
	  logBipUser.debug("ProfilsFIListAction-isValidProfilFI() --> filtre_fi :" +filtre_fi);
	  
	  
	  // exécution de la procédure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_AJAX_FI);
			// Récupération des résultats
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
								
			}			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("ProfilsFIListAction-isValidProfilFI() --> BaseException :" + be);
			logBipUser.debug("ProfilsFIListAction-isValidProfilFI() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ProfilsFIListAction-isValidProfilFI() --> BaseException :" + be);
			logService.debug("ProfilsFIListAction-isValidProfilFI() --> Exception :"
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
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC();
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On écrit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	  out.flush();

	  return PAS_DE_FORWARD;
	 }
	 
	 //Action dédiée à un appel Ajax qui vérifie si un Profil de FI est affecté à une ressource
	 public ActionForward isFiRessource(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		String signatureMethode = "isFiRessource(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
	  String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getInfosUser();
	  String filtre_fi = (String)request.getParameter("filtre_fi"); 
	  String date_effet = (String)request.getParameter("date_effet");
        
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("filtre_fi", filtre_fi);
	  lParamProc.put("date_effet", date_effet);
	  lParamProc.put("userid", userid);
	  
	  logBipUser.debug("ProfilsFIAction-isFiRessource() --> userid :" +userid);
	  logBipUser.debug("ProfilsFIAction-isFiRessource() --> filtre_fi :" +filtre_fi);
	  logBipUser.debug("ProfilsFIAction-isFiRessource() --> date_effet :" +date_effet);
	  
	  // exécution de la procédure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_AJAX);
			// Récupération des résultats
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
								
			}			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("ProfilsFIAction-isFiRessource() --> BaseException :" + be);
			logBipUser.debug("ProfilsFIAction-isFiRessource() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ProfilsFIAction-isFiRessource() --> BaseException :" + be);
			logService.debug("ProfilsFIAction-isFiRessource() --> Exception :"
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
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC();
//				 On écrit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On écrit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	  out.flush();

	  return PAS_DE_FORWARD;
	 }

}
