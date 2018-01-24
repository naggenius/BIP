package com.socgen.bip.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Array;
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

import com.socgen.bip.commun.form.BipForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DpcopiForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author E.VINATIER 18/04/2008
 * 
 */
public class DpcopiAction extends SocieteAction {

	private static String PACK_SELECT = "dpcopi.consulter.proc";

	private static String PACK_INSERT = "dpcopi.creer.proc";

	private static String PACK_UPDATE = "dpcopi.modifier.proc";

	private static String PACK_DELETE = "dpcopi.supprimer.proc";
	
	// MCH : PPM 61919 chapitre 6.7
	private static String PACK_MISEAVIDE = "dpcopi.mise.vide.proc";
	
	private static String VERIFIER_DPCOPI_AXE = "dpcopi.verifieraxe.proc";
	// fin MCH : PPM 61919 chapitre 6.7
	
	private String nomProc;

	
		
	/**
	 * Action qui permet de créer un dpcopi
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = "DpcopiAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {

			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);
			try {
				message = jdbc.recupererResult(vParamOut, "creer");
				
			} catch (BaseException be) {
				logBipUser
						.debug("DpcopiAction -creer() --> BaseException :" + be);
				logBipUser.debug("DpcopiAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService
						.debug("DpcopiAction -creer() --> BaseException :" + be);
				logService.debug("DpcopiAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((DpcopiForm) form).setMsgErreur(message);

				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("DpcopiAction-creer() --> BaseException :" + be);
			logBipUser.debug("DpcopiAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("DpcopiAction-creer() --> BaseException :" + be);
			logService.debug("DpcopiAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DpcopiForm) form).setMsgErreur(message);
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
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à dpcopi pour
	 * la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String sClibrca;

		String signatureMethode = "ClientAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		DpcopiForm bipForm = (DpcopiForm) form;

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

							bipForm.setDp_copi(rset.getString(1));
							bipForm.setLibelle(rset.getString(2));
							bipForm.setDpcode(rset.getString(3));
							bipForm.setClicode(rset.getString(4));
							bipForm.setFlaglock(rset.getInt(5));
							bipForm.setDomaine(rset.getString(6));
							bipForm.setDomaine_lib(rset.getString(7));
							bipForm.setAxe_strategique(rset.getString(8));
							bipForm.setEtape(rset.getString(9));
							bipForm.setTypeFinancement(rset.getString(10));
							bipForm. setQuote_part(rset.getString(11));
							bipForm. setdpcopiaxemetier(rset.getString(12));
							} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("DpcopiAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("DpcopiAction-consulter() --> SQLException :"
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
									.debug("DpcopiAction-consulter() --> SQLException-rset.close() :"
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
				// le code Camo n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("DpcopiAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("DpcopiAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("DpcopiAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("DpcopiAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}
	
	// MCH : PPM 61919 chapitre 6.7
	/**
	 * Action qui permet de mettre à vide le champ *axemétier
	 */
	/*protected ActionForward mettreAVide(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode = "DpcopiAction -mettreAVide( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {

			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_MISEAVIDE);
			try {
				message = jdbc.recupererResult(vParamOut, "mettreavide");

			} catch (BaseException be) {
				logBipUser
						.debug("DpcopiAction -mettreavide() --> BaseException :" + be);
				logBipUser.debug("DpcopiAction -mettreavide() --> Exception :"
						+ be.getInitialException().getMessage());
				logService
						.debug("DpcopiAction -mettreavide() --> BaseException :" + be);
				logService.debug("DpcopiAction -mettreavide() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((DpcopiForm) form).setMsgErreur(message);

				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("DpcopiAction-mettreavide() --> BaseException :" + be);
			logBipUser.debug("DpcopiAction-mettreavide() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("DpcopiAction-mettreavide() --> BaseException :" + be);
			logService.debug("DpcopiAction-mettreavide() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((DpcopiForm) form).setMsgErreur(message);
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
	}// mettreAVide*/

	public ActionForward verifierDpcopiAxe(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="DpcopiAction - verifierDpcopiAxe";
		
		return traitementAjax(VERIFIER_DPCOPI_AXE, signatureMethode, mapping, form, response, hParamProc);
	}
	
	private ActionForward traitementAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		DpcopiForm bipForm = (DpcopiForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		String type = "";
		String param_id = "";
		String result = "";
		
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
				if (paramOut.getNom().equals("type")) {
					if (paramOut.getValeur() != null) {
						type = (String) paramOut.getValeur();
					}
				}
				if (paramOut.getNom().equals("param_id")) {
					if (paramOut.getValeur() != null) {
						param_id = (String) paramOut.getValeur();
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
		result = type.concat(";").concat(param_id).concat(";").concat(message);
		out.print(new String(result.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	
	public ActionForward mettreAvide(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="DpcopiAction - mettreAvide";
		
		return traitAjax(PACK_MISEAVIDE, signatureMethode, mapping, form, response, hParamProc);
	}
	
	private ActionForward traitAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		DpcopiForm bipForm = (DpcopiForm) form;
		
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
		out.print(new String(message.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
	}
	// fin MCH : PPM 61919 chapitre 6.7

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
