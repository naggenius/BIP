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
import org.owasp.esapi.ESAPI;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DatesEffetForm;
import com.socgen.bip.form.DpgForm;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.bip.user.UserBip;
import java.lang.Object;
/**
 * @author N.BACCAM - 13/06/2003
 * 
 * Action de mise � jour des Dpgs chemin : Administration/Tables/ mise �
 * jour/Dpg pages : fmDpgAd.jsp et mDpgAd.jsp pl/sql : struct.sql
 */
public class DpgAction extends AutomateAction implements BipConstantes {

	private static String PACK_SELECT = "dpg.consulter.proc";

	private static String PACK_INSERT = "dpg.creer.proc";

	private static String PACK_UPDATE = "dpg.modifier.proc";

	private static String PACK_DELETE = "dpg.supprimer.proc";
	
	private static String PACK_VERIF_MATRICULE = "recup.id.matricule.nomprenom.proc";

	private static String PACK_EXISTE = "dpg.existe.proc";
	
	private static String PACK_ISDPGFRAIS = "dpg.isdpgfrais.proc";
	
	private static String PACK_ISDPGPERIMME = "dpg.isdpgperimme.proc";
	
	private String nomProc;
	
	

	/**
	 * Action qui permet de cr�er un code DPG
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = "DpgAction-creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// ex�cution de la proc�dure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser.debug("DpgAction-creer() --> BaseException :" + be);
				logBipUser.debug("DpgAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("DpgAction-creer() --> BaseException :" + be);
				logService.debug("DpgAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entit� d�j� existante, on r�cup�re le message
				((DpgForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("DpgAction-creer() --> BaseException :" + be);
			logBipUser.debug("DpgAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("DpgAction-creer() --> BaseException :" + be);
			logService.debug("DpgAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DpgForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
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
	}// creer

	/**
	 * Action qui permet de visualiser les donn�es li�es � un code Dpg pour la
	 * modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "DpgAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		DpgForm bipForm = (DpgForm) form;

		// ex�cution de la proc�dure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {

							bipForm.setCodsg(rset.getString(1));
							bipForm.setSigdep(rset.getString(2));
							bipForm.setSigpole(rset.getString(3));
							bipForm.setLibdsg(rset.getString(4));
							bipForm.setGnom(rset.getString(5));
							bipForm.setCentractiv(rset.getString(6));
							bipForm.setTopfer(rset.getString(7));
							bipForm.setFlaglock(rset.getInt(8));
							bipForm.setCoddir(rset.getString(9));
							bipForm.setCafi(rset.getString(10));
							bipForm.setScentrefrais(rset.getString(11));
							bipForm.setFilcode(rset.getString(12));
							bipForm.setTop_diva(rset.getString(13));
							bipForm.setIdentgdm(rset.getString(14));
							bipForm.setMatricule(rset.getString(15));
							bipForm.setTop_diva_int(rset.getString(16));
							bipForm.setDatFerm(rset.getString(17));
							bipForm.setMsgErreur(null);
							
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("DpgAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("DpgAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("DpgAction-suite() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				}// if
			}// for
			if (msg) {
				// le code Dpg n'existe pas, on r�cup�re le message
				bipForm.setMsgErreur(message);
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("DpgAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("DpgAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("DpgAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("DpgAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DpgForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}
	
	
	

	/**
	 * Appell� lorsque le focus est perdu sur le champ matricule 
	 * Permet de v�rifier que 
	 * - le matricule existe si il a �t� saisi
	 *   et remplace les noms pr�noms saisis par ceux trouv�s en base 
	 *   si le matricule saisi est correct
	 * 
	 */
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "DpgAction-refresh(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		DpgForm bipForm = (DpgForm) form;
		

		try {
			
				String mat = bipForm.getMatricule() ; 
			
				if(mat !=null && mat.length()>0){
						//V�rification matricule valide 
						vParamOut = jdbc.getResult(
								hParamProc, configProc, PACK_VERIF_MATRICULE );
						
						String  nomPrenom = (String) ((ParametreProc) vParamOut
								.elementAt(0)).getValeur() ; 
					
						//Si matricule trouv� en base on affiche le Nom/Pr�nom correspondant
						if(nomPrenom != null){
							bipForm.setGnom(nomPrenom) ; 
		                //Sinon message erreur
						}else{
							bipForm.setMsgErreur("Matricule non trouv� en base : Veuillez le resaisir ou laisser le champ vide !") ; 					
						}
				}
				
		}

		catch (BaseException be) {
			logBipUser.debug("ClientAction-refresh() --> BaseException :" + be,
					be);
			logBipUser.debug("ClientAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ClientAction-refresh() --> BaseException :" + be,
					be);
			logService.debug("ClientAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	
	
	
	
	
	/**
	 * Method valider
	 * Action qui permet d'enregistrer les donn�es pour la cr�ation, modification, suppression d'un code client
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 * 
	*/	
	protected  ActionForward valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProctest ) throws ServletException{
	    Vector vParamOut = new Vector();
	    String cle = null;
	    String message=null;
	    
	    String signatureMethode =
			"valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise � jour:"+mode);
		//On r�cup�re la cl� pour trouver le nom de la proc�dure stock�e dans bip_proc.properties
		cle=recupererCle(mode);

		JdbcBip jdbc1 = new JdbcBip(); 
		
		//On ex�cute la proc�dure stock�e
		try {

			DpgForm bipForm = (DpgForm) form;						
		
		 
			//Correction : Si pas ne mode supression (et si matricule non NULL)
			if ( ! mode.equals("delete") && bipForm.getMatricule()!=null && bipForm.getMatricule().length()>0){
				//R�cup nom,pr�nom d'apr�s matricule		
				 vParamOut = jdbc1.getResult(
						hParamProctest, configProc, PACK_VERIF_MATRICULE );
				
				String  nomPrenom = (String) ((ParametreProc) vParamOut
						.elementAt(0)).getValeur() ; 
				//Si matricule trouv� en base on affiche le Nom/Pr�nom correspondant
				if(nomPrenom != null){					
					bipForm.setGnom(nomPrenom) ;
					hParamProctest.put("gnom",nomPrenom) ; 
				//Matricule non valide : affichage message erreur et retour �cran
				}else{
					bipForm.setMsgErreur("Matricule non trouv� en base : Veuillez le resaisir ou laisser le champ vide !") ;
					logBipUser.exit(signatureMethode);
					jdbc1.closeJDBC(); return mapping.findForward("ecran") ;
				}				
				
				
			}
			
			//R�cup nom,pr�nom d'apr�s matricule		
			/* vParamOut = jdbc1.getResult(
					hParamProctest, configProc, PACK_VERIF_MATRICULE );
			
			String  nomPrenom = (String) ((ParametreProc) vParamOut
					.elementAt(0)).getValeur() ; 
		
			//Si le matricule a �t� saisi : v�rification qu'il existe et r�cup�ration du nom/pr�nom correspondants
			//qui remplaceront la saisie utilisateur nom/pr�nom
			 if( bipForm.getMatricule()!=null && bipForm.getMatricule().length()>0){
				
				//Si matricule trouv� en base on affiche le Nom/Pr�nom correspondant
				if(nomPrenom != null){					
					bipForm.setGnom(nomPrenom) ;
					hParamProctest.put("gnom",nomPrenom) ; 
				//Matricule non valide : affichage message erreur et retour �cran
				}else{
					bipForm.setMsgErreur("Matricule non trouv� en base : Veuillez le resaisir ou laisser le champ vide !") ;
					logBipUser.exit(signatureMethode);
					jdbc1.closeJDBC(); return mapping.findForward("ecran") ;
				}														
			} */
					
			//Reprise fonctionnement normal de la proc�dure de Validation de AutomateAction 
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
				// on r�cup�re le message 
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
				//Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("11201"));
		    	request.setAttribute("messageErreur",be.getInitialException().getMessage());
				 jdbc1.closeJDBC(); return mapping.findForward("error");
			}
		}	
		
		logBipUser.exit(signatureMethode);
		 jdbc1.closeJDBC(); return mapping.findForward("initial") ;

	}//valider
	
	
	
	

	/**
	 * 
	 */
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

	
	//Action d�di�e � un appel Ajax qui v�rifie l'appartenance d'un DPG a un centre de frais
	 public ActionForward isDpgFrais(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		String signatureMethode = "isDpgFrais(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
		String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getInfosUser();
		String codsg = (String)request.getParameter("codsg");
	  
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("codsg", codsg);
	  lParamProc.put("userid", userid);  

	  // ex�cution de la proc�dure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_ISDPGFRAIS);
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
			logBipUser.debug("DpgAction-isDpgFrais() --> BaseException :" + be);
			logBipUser.debug("DpgAction-isDpgFrais() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("DpgAction-isDpgFrais() --> BaseException :" + be);
			logService.debug("DpgAction-isDpgFrais() --> Exception :"
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
//				 On �crit le message de retour du pl/sql dans la response
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
//				 On �crit le message de retour du pl/sql dans la response
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

		//Action d�di�e � un appel Ajax qui v�rifie l'appartenance d'un DPG au perim me
	 public ActionForward isDpgPerimMe(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	 {
		String signatureMethode = "isDpgPerimMe(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
		String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getInfosUser();
		String codsg = (String)request.getParameter("codsg");
	  
	  JdbcBip jdbc = new JdbcBip(); 
	  Vector vParamOut = new Vector();
	  String message = "";
	  ParametreProc paramOut;
	  Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	  
	  lParamProc.put("codsg", codsg);
	  lParamProc.put("userid", userid);  

	  // ex�cution de la proc�dure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_ISDPGPERIMME);
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
			logBipUser.debug("DpgAction-isDpgFrais() --> BaseException :" + be);
			logBipUser.debug("DpgAction-isDpgFrais() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("DpgAction-isDpgFrais() --> BaseException :" + be);
			logService.debug("DpgAction-isDpgFrais() --> Exception :"
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
//				 On �crit le message de retour du pl/sql dans la response
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
//				 On �crit le message de retour du pl/sql dans la response
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
	 
//Action d�di�e � un appel Ajax qui v�rifie l'existance d'un DPG et son ouverture
public ActionForward testDpg(ActionMapping mapping, ActionForm form,
		 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
{
	String signatureMethode = "isDpgFrais(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
	logBipUser.entry(signatureMethode);
	
	 String codsg = (String)request.getParameter("codsg");
	 
	 JdbcBip jdbc = new JdbcBip(); 
	 Vector vParamOut = new Vector();
	 String message = "";
	 ParametreProc paramOut;
	 Hashtable<String,String> lParamProc = new Hashtable<String,String>();
	 
	 lParamProc.put("codsg", codsg); 

 // ex�cution de la proc�dure PL/SQL
	try {
	
		vParamOut = jdbc.getResult(
				lParamProc, configProc, PACK_EXISTE);
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
		logBipUser.debug("DpgAction-existDpg() --> BaseException :" + be);
		logBipUser.debug("DpgAction-existDpg() --> Exception :"
				+ be.getInitialException().getMessage());
		logService.debug("DpgAction-existDpg() --> BaseException :" + be);
		logService.debug("DpgAction-existDpg() --> Exception :"
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
//			 On �crit le message de retour du pl/sql dans la response
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
//			 On �crit le message de retour du pl/sql dans la response
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

 //out.println(message);
 out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
 
 out.flush();

 return PAS_DE_FORWARD;
}	

}
