package com.socgen.bip.action;

import java.io.PrintWriter;
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

import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DatesEffetForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author C.MARTINS - 28/02/2011
 * 
 * Action mise à jour des lignes d'un paramètre Bip :
 * Tables/Mise à jour/Paramètre BIP : fmLignesParamBipAd.jsp et
 * mLignesParamBipAd.jsp pl/sql : param_bip.sql
 */
public class LignesParamBipAction extends DatesEffetAction {

	private static String PACK_SELECT = "parambip.consulter.proc";

	private static String PACK_INSERT = "parambip.creer.proc";

	private static String PACK_UPDATE = "parambip.modifier.proc";

	private static String PACK_DELETE = "parambip.supprimer.proc";
	
	private static String PACK_EXISTE = "parambip.existe.proc";
	
	private static String PACK_ACTIF = "parambip.actif.proc";

	/**
	 * Action qui permet de créer une ligne paramètre Bip
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		

		String signatureMethode = "LignesParamBipAction -creer( mapping, form , request,  response,  errors, hParamProc )";


		logBipUser.entry(signatureMethode);
		DatesEffetForm bipForm = (DatesEffetForm) form;
		
		bipForm.setNum_ligne("");
		bipForm.setActif("O");
		bipForm.setApplicable("N");
		bipForm.setObligatoire("O");
		bipForm.setMulti("");
		bipForm.setSeparateur("");
		bipForm.setFormat("");
		bipForm.setCasse("C");
		bipForm.setCodaction_lie("");
		bipForm.setCodversion_lie("");
		bipForm.setNum_ligne_lie("");
		bipForm.setMin_size_unit("");
		bipForm.setMax_size_unit("");
		bipForm.setMin_size_tot("");
		bipForm.setMax_size_tot("");
		bipForm.setValeur("");
		bipForm.setCommentaire_ligne("");
		
		return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code client pour
	 * la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		// boolean msg=false;
		ParametreProc paramOut;

		String signatureMethode = "LignesParamBipAction -consulter( mapping, form , request,  response,  errors, hParamProc )";


		logBipUser.entry(signatureMethode);

		// exécution de la procédure PL/SQL
		try {

		
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			// Récupération des résultats
			DatesEffetForm bipForm = (DatesEffetForm) form;
			
			for (Enumeration e1 = vParamOut.elements(); e1.hasMoreElements();) {
				paramOut = (ParametreProc) e1.nextElement();
				
				if (paramOut.getNom().equals("message")) {
					if (paramOut.getValeur() != null)
						message = (String) paramOut.getValeur();
				}
				
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
				
					try {
						while (rset.next()) {
						//	Il n'y a normalement qu'un seul élément

							bipForm.setNum_ligne(rset.getString(3));
							bipForm.setActif(rset.getString(4));
							bipForm.setApplicable(rset.getString(5));
							bipForm.setObligatoire(rset.getString(6));
							bipForm.setMulti(rset.getString(7));
							bipForm.setSeparateur(rset.getString(8));
							bipForm.setFormat(rset.getString(9));
							bipForm.setCasse(rset.getString(10));
							bipForm.setCodaction_lie(rset.getString(11));
							bipForm.setCodversion_lie(rset.getString(12));
							bipForm.setNum_ligne_lie(rset.getString(13));
							bipForm.setMin_size_unit(rset.getString(14));
							bipForm.setMax_size_unit(rset.getString(15));
							bipForm.setMin_size_tot(rset.getString(16));
							bipForm.setMax_size_tot(rset.getString(17));
							bipForm.setValeur(rset.getString(18));
							bipForm.setCommentaire_ligne(rset.getString(19));
						  
						}
					}catch (SQLException sqle) {
							logService
									.debug("DatesEffetForm-consulter() --> SQLException :"
											+ sqle);
							logBipUser
									.debug("DatesEffetForm-consulter() --> SQLException :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
									"11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}
					}
				}
			
			
		}// try
		catch (BaseException be) {
			logBipUser.debug("LignesParamBipAction-creer() --> BaseException :" + be);
			logBipUser.debug("LignesParamBipAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("LignesParamBipAction-creer() --> BaseException :" + be);
			logService.debug("LignesParamBipAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DatesEffetForm) form).setMsgErreur(message);
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
		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	public ActionForward retour(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		return mapping.findForward("retour");

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
	
	//Action dédiée à un appel Ajax qui vérifie l'existence d'un paramètre BIP ou de sa ligne
	 public ActionForward existeParamBIP(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {

	  String signatureMethode = "LignesParamBipAction -existeParamBIP( mapping, form , request,  response )";
	  logBipUser.entry(signatureMethode);
	
	  String codaction = (String)request.getParameter("codaction");
	  String codversion = (String)request.getParameter("codversion");
	  String num_ligne = ((String)request.getParameter("num_ligne_lie")!=null)?(String)request.getParameter("num_ligne_lie"):"";
	  
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("codaction", codaction);
	  lParamProc.put("codversion", codversion);
	  lParamProc.put("num_ligne", num_ligne);
	  

	  // exécution de la procédure PL/SQL
		try {

		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_EXISTE);
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
			logBipUser.debug("LignesParamBipAction-existeParamBIP() --> BaseException :" + be);
			logBipUser.debug("LignesParamBipAction-existeParamBIP() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("LignesParamBipAction-existeParamBIP() --> BaseException :" + be);
			logService.debug("LignesParamBipAction-existeParamBIP() --> Exception :"
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
				  out.println(message);
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
				  out.println(message);
				  out.flush();
				  return PAS_DE_FORWARD;
			}
		}

		 jdbc.closeJDBC();

	  // On écrit le message de retour du pl/sql dans la response
	  response.setContentType("text/html");
	  PrintWriter out = response.getWriter();
	  out.println(message);
	  out.flush();

	  return PAS_DE_FORWARD;
	 }
	 
	 //Action dédiée à un appel Ajax qui vérifie que la ligne BIP liée est bien active
	 public ActionForward activeLigneParamBIP(ActionMapping mapping, ActionForm form,        
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		  String signatureMethode = "LignesParamBipAction -activeLigneParamBIP( mapping, form , request,  response )";
		  logBipUser.entry(signatureMethode);
	  
		  String codaction = (String)request.getParameter("codaction");
		  String codversion = (String)request.getParameter("codversion");
		  String num_ligne = ((String)request.getParameter("num_ligne_lie")!=null)?(String)request.getParameter("num_ligne_lie"):"";
		  
		  JdbcBip jdbc = new JdbcBip(); 
		  Vector vParamOut = new Vector();
		  String message = "";
		  ParametreProc paramOut;
		  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		  
		  lParamProc.put("codaction", codaction);
		  lParamProc.put("codversion", codversion);
		  lParamProc.put("num_ligne", num_ligne);
		  

		  // exécution de la procédure PL/SQL
			try {

			
				vParamOut = jdbc.getResult(
						lParamProc, configProc, PACK_ACTIF);
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
				logBipUser.debug("LignesParamBipAction-existeParamBIP() --> BaseException :" + be);
				logBipUser.debug("LignesParamBipAction-existeParamBIP() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("LignesParamBipAction-existeParamBIP() --> BaseException :" + be);
				logService.debug("LignesParamBipAction-existeParamBIP() --> Exception :"
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
//					 On écrit le message de retour du pl/sql dans la response
					  response.setContentType("text/html");
					  PrintWriter out = response.getWriter();
					  out.println(message);
					  out.flush();
					  return PAS_DE_FORWARD;

				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
					request.setAttribute("messageErreur", be.getInitialException()
							.getMessage());
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC();
//					 On écrit le message de retour du pl/sql dans la response
					  response.setContentType("text/html");
					  PrintWriter out = response.getWriter();
					  out.println(message);
					  out.flush();
					  return PAS_DE_FORWARD;
				}
			}

			 jdbc.closeJDBC();
		  
		  // On écrit le message de retour du pl/sql dans la response
		  response.setContentType("text/html");
		  PrintWriter out = response.getWriter();
		  out.println(message);
		  out.flush();
		  return PAS_DE_FORWARD;
	 }



}
