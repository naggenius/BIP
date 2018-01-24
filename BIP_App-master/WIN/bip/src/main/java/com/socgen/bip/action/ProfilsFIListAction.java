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
 * Formulaire pour mise � jour des Profils de FI
 * chemin : Administration/Tables/Mise � Jour/Profils de FI
 * pages  : fmProfilsFIAd.jsp / mProfilsFIAd.jsp / lProfilsFI.jsp
 * pl/sql : profil_fi.sql
 */
public class ProfilsFIListAction extends AutomateAction {

	private static String PACK_SELECT 		= "lstprofilfi.consulter.proc";
	private static String PACK_INSERT 		= "lstprofilfi.creer.proc";
	private static String PACK_UPDATE 		= "lstprofilfi.modifier.proc";
	private static String PACK_DELETE 		= "lstprofilfi.supprimer.proc";
	private static String PACK_AJAX   		= "profilfi2.isfiressource.proc";
	private static String PACK_AJAX_CODIR_PERIME   = "profilfi.isvalidcodedirperime.proc";
	private static String PACK_LIB   		= "profilfi2.getlibelleprofilfi.proc";
	
   /**
	* Action qui permet de cr�er un code de Profil de FI
	*/
	protected ActionForward creer(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws ServletException{
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String libelle="";
		ParametreProc paramOut;
		
		String signatureMethode ="ProfilsFIListAction -creer( mapping, form , request,  response,  errors )";

		//logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		//ex�cution de la proc�dure PL/SQL	
		try {
				
				vParamOut= jdbc.getResult (hParamProc,configProc,PACK_LIB);
				
			 	// ----------------------------------------------------------
				for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
					  paramOut = (ParametreProc) e.nextElement();
					
					//r�cup�rer le libelle
					if (paramOut.getNom().equals("libelle")) {
						libelle=(String)paramOut.getValeur();
						((ProfilsFIForm)form).setLibelle(libelle);
					}

				}	
				// ----------------------------------------------------------
			
		}//try
		catch (BaseException be) {
			logBipUser.debug("ProfilsFIListAction-creer() --> BaseException :"+be);
			logBipUser.debug("ProfilsFIListAction-creer() --> Exception :"+be.getInitialException().getMessage());
			logService.debug("ProfilsFIListAction-creer() --> BaseException :"+be);
			logService.debug("ProfilsFIListAction-creer() --> Exception :"+be.getInitialException().getMessage());
			//Erreur d''ex�cution de la proc�dure stock�e
			errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
			//this.saveErrors(request,errors);
			jdbc.closeJDBC(); return mapping.findForward("error");
		}	
			
		//logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		jdbc.closeJDBC(); return mapping.findForward("ecran");	
	
	}//creer
	
   /**
	* Action qui permet de visualiser les donn�es li�es � un code client pour la modification et la suppression
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
		// Cr�ation d'une nouvelle form
		ProfilsFIForm bipForm= (ProfilsFIForm)form ;
		
		//ex�cution de la proc�dure PL/SQL	
		try {
			 vParamOut= jdbc.getResult (hParamProc,configProc,PACK_SELECT);
	
		//R�cup�ration des r�sultats
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				  paramOut = (ParametreProc) e.nextElement();
				
				//r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message=(String)paramOut.getValeur();
				}
			
				if (paramOut.getNom().equals("msg_fi_ress")) {
					bipForm.setMessage_fi_ress((String)paramOut.getValeur());
				}
				
				if (paramOut.getNom().equals("curseur")) {
					//R�cup�ration du Ref Cursor
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
							bipForm.setMsgErreur(null);
							

						}
						else
							msg=true;
        				
					}//try
					catch (SQLException sqle) {
						logService.debug("ProfilsFIListAction-consulter() --> SQLException :"+sqle);
						logBipUser.debug("ProfilsFIListAction-consulter() --> SQLException :"+sqle);
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
							logBipUser.debug("ProfilsFIListAction-consulter() --> SQLException-rset.close() :"+sqle);
							//Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11217"));
							jdbc.closeJDBC(); return mapping.findForward("error");
						}
					}
				}//if
			}//for
			if (msg) {	
				//le profil de FI n'existe pas, on r�cup�re le message 
				bipForm.setMsgErreur(message);
				//on reste sur la m�me page
				jdbc.closeJDBC(); return mapping.findForward("initial");
			}	
		}//try
		catch (BaseException be) {
			logBipUser.debug("ProfilsFIListAction-consulter() --> BaseException :"+be, be);
			logBipUser.debug("ProfilsFIListAction-consulter() --> Exception :"+be.getInitialException().getMessage());

			logService.debug("ProfilsFIListAction-consulter() --> BaseException :"+be, be);
			logService.debug("ProfilsFIListAction-consulter() --> Exception :"+be.getInitialException().getMessage());	
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
				
		String signatureMethode ="ProfilsFIListAction -lister( mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
	
		return mapping.findForward("list");	
					
				
	}
	
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

			return mapping.findForward("annuler");

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
	

	//Action d�di�e � un appel Ajax qui v�rifie si un Profil de FI est affect� � une ressource
	 public ActionForward isFiRessource(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		String signatureMethode = "isFiRessource(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
	  String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getInfosUser();
	  String filtre_lst_fi = (String)request.getParameter("filtre_lst_fi"); 
	  String lst_date_effet = (String)request.getParameter("lst_date_effet");
        
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("filtre_lst_fi", filtre_lst_fi);
	  lParamProc.put("lst_date_effet", lst_date_effet);
	  lParamProc.put("userid", userid);
	  
	  logBipUser.debug("ProfilsFIListAction-isFiRessource() --> userid :" +userid);
	  logBipUser.debug("ProfilsFIListAction-isFiRessource() --> filtre_lst_fi :" +filtre_lst_fi);
	  logBipUser.debug("ProfilsFIListAction-isFiRessource() --> lst_date_effet :" +lst_date_effet);
	  
	  // ex�cution de la proc�dure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_AJAX);
			// R�cup�ration des r�sultats
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
								
			}			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("ProfilsFIListAction-isFiRessource() --> BaseException :" + be);
			logBipUser.debug("ProfilsFIListAction-isFiRessource() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ProfilsFIListAction-isFiRessource() --> BaseException :" + be);
			logService.debug("ProfilsFIListAction-isFiRessource() --> Exception :"
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
				  // On �crit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC();
			    // On �crit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On �crit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	  out.flush();

	  return PAS_DE_FORWARD;
	 }
	 
	 //Action d�di�e � un appel Ajax qui v�rifie si un code direction existe d�j�
	 public ActionForward isValidCodeDir(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		String signatureMethode = "isValidCodeDir(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
	  String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getInfosUser();
	  String p_param6 = (String)request.getParameter("p_param6");
        
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("p_param6", p_param6);
	  lParamProc.put("userid", userid);
	  
	  logBipUser.debug("ProfilsFIListAction-isValidCodeDir() --> userid :" +userid);
	  logBipUser.debug("ProfilsFIListAction-isValidCodeDir() --> Code Direction :" +p_param6);
	  
	  // ex�cution de la proc�dure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_AJAX_CODIR_PERIME);
			// R�cup�ration des r�sultats
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
								
			}			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("ProfilsFIListAction-isValidCodeDir() --> BaseException :" + be);
			logBipUser.debug("ProfilsFIListAction-isValidCodeDir() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ProfilsFIListAction-isValidCodeDir() --> BaseException :" + be);
			logService.debug("ProfilsFIListAction-isValidCodeDir() --> Exception :"
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
				  // On �crit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				  // this.saveErrors(request,errors);
				 jdbc.closeJDBC();
				  // On �crit le message de retour du pl/sql dans la response
				  response.setContentType("text/html");
				  PrintWriter out = response.getWriter();
				  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On �crit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	  out.flush();

	  return PAS_DE_FORWARD;
	 }
	
	
}
