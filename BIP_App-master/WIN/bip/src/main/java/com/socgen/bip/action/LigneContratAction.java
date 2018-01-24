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
import com.socgen.bip.form.LigneContratForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author MMC - 28/07/2003
 * 
 * COntrats Avenants / Lignes chemin : Ordonnancemement / Contrats / contrats
 * avenants pages : fmLignecontratOr.jsp pl/sql : cligcont.sql
 */


public class LigneContratAction extends ContratAveAction {

	private static String PACK_SELECT = "ligneContrat.consulter.proc";

	private static String PACK_SELECT_AJOUT = "ligneContrat.ajout.proc";

	private static String PACK_INSERT = "ligneContrat.creer.proc";

	private static String PACK_UPDATE = "ligneContrat.modifier.proc";

	private static String PACK_DELETE = "ligneContrat.supprimer.proc";

	private static String PACK_SELECT_1 = "contrat.consulter.proc";

	private static String PACK_SELECT_INS = "ligneContrat.consulter_ins.proc";
	
	private static String PACK_VERIF_RESSOURCE= "ligneContrat.verif_ressource.proc";
	
	private static String PACK_RECUP_LIB_MC= "ligneContrat.recup_lib_mci.proc";

	private static String PACK_TEST_LC_PERIODE= "ligneContrat.test_periode_ressources.proc";

	private static String PACK_CTRL_PERIODE_C= "ligneContrat.ctrl_periode_creation.proc";
	
	private static String PACK_CTRL_PERIODE_M= "ligneContrat.ctrl_periode_modification.proc";

	private String nomProc;

	/**
	 * Action qui permet d'ajouter une ligne contrat
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "LigneContratAction-creer(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		LigneContratForm bipForm = (LigneContratForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_AJOUT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();

				}

				if (paramOut.getNom().equals("soclib")) {
					String sSoclib = (String) paramOut.getValeur();
					logService.debug("Soclib :" + sSoclib);
					((LigneContratForm) form).setSoclib(sSoclib);
				} // if
				
				if (paramOut.getNom().equals("cdatdeb")) {
						((LigneContratForm) form).setCdatdeb( (String) paramOut.getValeur());
				} // if
			 
				if (paramOut.getNom().equals("cdatfin")) {
					((LigneContratForm) form).setCdatfin( (String) paramOut.getValeur());
				} 
			} // for
			if (message != null) {
				// le code ligneContrat n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug("ligneContratAction-creer() --> BaseException :"
					+ be, be);
			logBipUser.debug("ligneContratAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ligneContratAction-creer() --> BaseException :"
					+ be, be);
			logService.debug("ligneContratAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);
		// if (sMode .equals("insert")) {
		//  jdbc.closeJDBC(); return mapping.findForward("ajout");
		// }else
		 jdbc.closeJDBC(); return mapping.findForward("ajout");
	}

	/**
	 * Action qui permet de visualiser les données liées à une ligne contrat
	 * pour la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String sMode = request.getParameter("mode");

		String signatureMethode = "LigneContratAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		LigneContratForm bipForm = (LigneContratForm) form;

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

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setSoccont(rset.getString(1));
							bipForm.setSoclib(rset.getString(2));
							bipForm.setNumcont(rset.getString(3));
							bipForm.setCav(rset.getString(4));
							bipForm.setLcnum(rset.getString(5));
							bipForm.setIdent(rset.getString(6));
							bipForm.setRnom(rset.getString(7));
							bipForm.setRprenom(rset.getString(8));
							bipForm.setLcprest(rset.getString(9));
							bipForm.setLresdeb(rset.getString(10));
							bipForm.setLresfin(rset.getString(11));
							bipForm.setCout(rset.getString(12));
							bipForm.setLccouact(rset.getString(13));
							bipForm.setProporig(rset.getString(14));
							bipForm.setFlaglock(rset.getInt(15));
							bipForm.setModeContractuel(rset.getString(16));
							bipForm.setLibModeContractuel(rset.getString(17));
							bipForm.setLcdomaine(rset.getString(18));
							bipForm.setRtype(rset.getString(19));
							bipForm.setCodeloc(rset.getString(20));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					} // try
					catch (SQLException sqle) {
						logService
								.debug("ligneContratAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ligneContratAction-consulter() --> SQLException :"
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
									.debug("ligneContratAction-consulter() --> SQLException-rset.close() :"
											+ sqle);
							// Erreur de lecture du resultSet
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11217"));
							 jdbc.closeJDBC(); return mapping.findForward("error");
						}

					}
				} // if
			} // for
			if (msg) {
				// le code ligneContrat n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"ligneContratAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("ligneContratAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
					"ligneContratAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("ligneContratAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);
		// if (sMode .equals("insert")) {
		//  jdbc.closeJDBC(); return mapping.findForward("ajout");
		// }else
		 jdbc.closeJDBC(); return mapping.findForward("ecran");

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

	/**
	 * Action qui permet d'ouvrir sur la page de composition des lignes contrat
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String sMode = request.getParameter("mode");
		String signatureMethode = "LigneContratAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		if (sMode.equals("insert")) { // exécution de la procédure PL/SQL
			LigneContratForm bipForm = (LigneContratForm) form;
			// Initialiser le numéro de ligne de contrat à 0
			bipForm.setLcnum("0");
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_SELECT_INS);

				// Récupération des résultats
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					// récupérer le message
					if (paramOut.getNom().equals("message")) {
						message = (String) paramOut.getValeur();

					}
					// Récupérer le nom
					if (paramOut.getNom().equals("rnomout")) {
						String sRnomout = (String) paramOut.getValeur();
						bipForm.setRnom(sRnomout);
					} // if
					// récupérer le prenom
					if (paramOut.getNom().equals("rprenomout")) {
						String sRprenomout = (String) paramOut.getValeur();
						bipForm.setRprenom(sRprenomout);
					} // if
					// récupérer le cout de la ressource
					if (paramOut.getNom().equals("coutout")) {
						String sCoutout = (String) paramOut.getValeur();
						bipForm.setCout(sCoutout);
					} // if

				} // for

			} // try
			catch (BaseException be) {
				logBipUser.debug(
						"ligneContratAction-consulter() --> BaseException :"
								+ be, be);
				logBipUser
						.debug("ligneContratAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());

				logService.debug(
						"ligneContratAction-consulter() --> BaseException :"
								+ be, be);
				logService
						.debug("ligneContratAction-consulter() --> Exception :"
								+ be.getInitialException().getMessage());
				// Si exception sql alors extraire le message d'erreur du
				// message global
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((LigneContratForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("ajout");
				} else {
					// Erreur d''exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					request.setAttribute("messageErreur", be
							.getInitialException().getMessage());
					// this.saveErrors(request,errors);
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}

			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward("ecran");
		} else {
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward("initial");
		}
	}
	

	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		LigneContratForm bipForm = (LigneContratForm) form;
		String focus = bipForm.getFocus();
		String message = "";
		Vector vParamOut = new Vector();

		try {
				if(!"modeContractuel".equals(focus)){
					//Recherche du nom et prenom et champs de la situation
					vParamOut = jdbc.getResult(
							hParamProc, configProc, PACK_VERIF_RESSOURCE);
					bipForm.setRnom((String) ((ParametreProc) vParamOut
							.elementAt(0)).getValeur());
					bipForm.setRprenom((String) ((ParametreProc) vParamOut
							.elementAt(1)).getValeur());
					bipForm.setRtype((String) ((ParametreProc) vParamOut
							.elementAt(2)).getValeur());
					bipForm.setLcprest((String) ((ParametreProc) vParamOut
							.elementAt(3)).getValeur());
					bipForm.setLcdomaine((String) ((ParametreProc) vParamOut
							.elementAt(4)).getValeur());
					bipForm.setCout((String) ((ParametreProc) vParamOut
							.elementAt(5)).getValeur());
					bipForm.setModeContractuel((String) ((ParametreProc) vParamOut
							.elementAt(6)).getValeur());
					bipForm.setLibModeContractuel((String) ((ParametreProc) vParamOut
							.elementAt(7)).getValeur());
					bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
							.elementAt(8)).getValeur());
					
					// en cas d'erreur on reinitialise l'ident, le nom et prenom
					if (bipForm.getMsgErreur() != null)
					{
						bipForm.setIdent("");
						bipForm.setRnom("");
						bipForm.setRprenom("");
					}
				}
				
				if("modeContractuel".equals(focus)){
					vParamOut = jdbc.getResult(
							hParamProc, configProc, PACK_RECUP_LIB_MC);
					bipForm.setLibModeContractuel((String) ((ParametreProc) vParamOut
							.elementAt(0)).getValeur());
				}												

		} catch (BaseException be) {
			logBipUser.debug(
					"ligneContratAction-consulter() --> BaseException :"
							+ be, be);
			logBipUser
					.debug("ligneContratAction-consulter() --> Exception :"
							+ be.getInitialException().getMessage());

			logService.debug(
					"ligneContratAction-consulter() --> BaseException :"
							+ be, be);
			logService
					.debug("ligneContratAction-consulter() --> Exception :"
							+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du
			// message global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(BipException
						.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((LigneContratForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("ajout");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
						"11201"));
				request.setAttribute("messageErreur", be
						.getInitialException().getMessage());
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
		}
	}
		jdbc.closeJDBC(); return mapping.findForward("ecran");
}

//	Action dédiée à un appel Ajax qui vérifie que les periode des lignes contrat 
//	ne se chevauche pas
	public ActionForward testLContratPeriode(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	{
		String signatureMethode = "testLContratPeriode(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
		 String numcount = (String)request.getParameter("numcont");
		 String mode = (String)request.getParameter("mode");
		 String lcnum = (String)request.getParameter("lcnum");
		 String cav = (String)request.getParameter("cav");
		 
		 JdbcBip jdbc = new JdbcBip(); 
		 Vector vParamOut = new Vector();
		 String message = "";
		 ParametreProc paramOut;
		 Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		 
		 lParamProc.put("numcont", numcount); 
		 lParamProc.put("mode", mode); 
		 lParamProc.put("lcnum", lcnum); 
		 lParamProc.put("cav", cav); 

	 // exécution de la procédure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_TEST_LC_PERIODE);
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
			logBipUser.debug("ligneContratAction-testLContratPeriode() --> BaseException :" + be);
			logBipUser.debug("ligneContratAction-testLContratPeriode() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ligneContratAction-testLContratPeriode() --> BaseException :" + be);
			logService.debug("ligneContratAction-testLContratPeriode() --> Exception :"
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

	 //out.println(message);
	 out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	 
	 out.flush();

	 return PAS_DE_FORWARD;
	}

//	Action dédiée à un appel Ajax qui vérifie que les periode des lignes contrat 
//	ne se chevauche pas pour la creation
	public ActionForward ctrlPeriodeC(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	{
		String signatureMethode = "ctrlPeriodeC(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
		 String numcont = (String)request.getParameter("numcont");
		 String lcnum = (String)request.getParameter("lcnum");
		 String resdeb = (String)request.getParameter("resdeb");
		 String resfin = (String)request.getParameter("resfin");
		 String cav = (String)request.getParameter("cav");
		 String ident = (String)request.getParameter("ident");
		 
		 resdeb = resdeb.replaceAll ("/","");
		 resfin = resfin.replaceAll ("/","");
		 
		 JdbcBip jdbc = new JdbcBip(); 
		 Vector vParamOut = new Vector();
		 String message = "";
		 ParametreProc paramOut;
		 Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		 
		 
		 lParamProc.put("numcont", numcont); 
		 lParamProc.put("lcnum", lcnum); 
		 lParamProc.put("resdeb", resdeb); 
		 lParamProc.put("resfin", resfin); 
		 lParamProc.put("cav", cav); 
		 lParamProc.put("ident", ident);

	 // exécution de la procédure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_CTRL_PERIODE_C);
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
			logBipUser.debug("ligneContratAction-ctrlPeriodeC() --> BaseException :" + be);
			logBipUser.debug("ligneContratAction-ctrlPeriodeC() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ligneContratAction-ctrlPeriodeC() --> BaseException :" + be);
			logService.debug("ligneContratAction-ctrlPeriodeC() --> Exception :"
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

	 //out.println(message);
	 out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	 
	 out.flush();

	 return PAS_DE_FORWARD;
	}

//	Action dédiée à un appel Ajax qui vérifie que les periode des lignes contrat 
//	ne se chevauche pas pour la creation
	public ActionForward ctrlPeriodeM(ActionMapping mapping, ActionForm form,
			 HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc) throws Exception
	{
		String signatureMethode = "ctrlPeriodeM(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		
		 String numcont = (String)request.getParameter("numcont");
		 String lcnum = (String)request.getParameter("lcnum");
		 String ident = (String)request.getParameter("ident");
		 String resdeb = (String)request.getParameter("resdeb");
		 String resfin = (String)request.getParameter("resfin");
		 String cav = (String)request.getParameter("cav");
		 
		 resdeb = resdeb.replaceAll ("/","");
		 resfin = resfin.replaceAll ("/","");
		 
		 JdbcBip jdbc = new JdbcBip(); 
		 Vector vParamOut = new Vector();
		 String message = "";
		 ParametreProc paramOut;
		 Hashtable<String,String> lParamProc = new Hashtable<String,String>();
		 
		 
		 lParamProc.put("numcont", numcont); 
		 lParamProc.put("lcnum", lcnum); 
		 lParamProc.put("ident", ident); 
		 lParamProc.put("resdeb", resdeb); 
		 lParamProc.put("resfin", resfin); 
		 lParamProc.put("cav", cav); 

	 // exécution de la procédure PL/SQL
		try {
		
			vParamOut = jdbc.getResult(
					lParamProc, configProc, PACK_CTRL_PERIODE_M);
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
			logBipUser.debug("ligneContratAction-ctrlPeriodeM() --> BaseException :" + be);
			logBipUser.debug("ligneContratAction-ctrlPeriodeM() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ligneContratAction-ctrlPeriodeM() --> BaseException :" + be);
			logService.debug("ligneContratAction-ctrlPeriodeM() --> Exception :"
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

	 //out.println(message);
	 out.println(new String(message.getBytes("utf8"), "iso-8859-1"));
	 
	 out.flush();

	 return PAS_DE_FORWARD;
	}
	
	// class
}