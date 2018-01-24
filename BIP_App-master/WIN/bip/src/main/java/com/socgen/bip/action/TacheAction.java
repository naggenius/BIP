package com.socgen.bip.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.DpcopiForm;
import com.socgen.bip.form.EtapeForm;
import com.socgen.bip.form.StructLbForm;
import com.socgen.bip.form.TacheForm;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 28/07/2003
 * 
 * Action de mise à jour des Taches chemin : Saisie des
 * réalisés/Paramétrage/Structure LigneBIP pages : fmTache.jsp et mTache.jsp
 * pl/sql : isac_tache.sql
 */
public class TacheAction extends AutomateAction {

	private static String PACK_SELECT_S = "tache.consulter_s.proc";

	private static String PACK_SELECT_L = "tache.consulter_l.proc";

	private static String PACK_SELECT = "tache.consulter.proc";

	private static String PACK_INSERT = "tache.creer.proc";

	private static String PACK_UPDATE = "tache.modifier.proc";

	private static String PACK_DELETE = "tache.supprimer.proc";
	
	private static String PACK_VERIFIER = "tache.verifier.proc";
	
	private static String PACK_MISE_A_VIDE = "tache.mise.a.vide.proc";
	
	private static String PACK_INITIALISER = "tache.initialiser.proc";
	
	/**
	 * Action qui permet d'accéder à l'écran de création d'une étape
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		alimenterInfosParentEtape(form, request, hParamProc);
		
		// Alimentation du numéro de la nouvelle tâche 
		return alimenterNumeroNouvelleTache(mapping, form, request, hParamProc);
	}
	
	/**
	 * Action qui permet de visualiser les données liées à un code Tache pour la
	 * modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		alimenterInfosParentEtape(form, request, hParamProc);
		return alimenterInfosTache(mapping, form, request, hParamProc);
	}
	
	public  ActionForward valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProctest ) throws ServletException {
		ActionForward actionForward = super.valider(mapping, form, mode, request, response, errors, hParamProctest);
		
		TacheForm bipForm = (TacheForm) form;
		
		// Si écran de création 
		// ou 
		// Si écran de suppression et message "Tâche supprimée"
		if (AutomateForm.modeCreer.equals(bipForm.getMode()) ||
				(AutomateForm.modeSupprimer.equals(bipForm.getMode()) && bipForm.suppressionOK())) {
			cocherEtapeParente(bipForm);
		}
		else {
			// Cocher la tâche
		}
		
		transmettreAttributs(bipForm, request);
		
		return actionForward;
	}
	
	/**
	 * Retour à l'écran structure d'une ligne BIP depuis l'écran d'administration des tâches
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {
		TacheForm bipForm = (TacheForm) form;
		
		// Si écran de création
		if (AutomateForm.modeCreer.equals(bipForm.getMode())) {
			cocherEtapeParente(bipForm);
		}
		// Si écran de modification ou suppression
		else {
			// Cocher la tâche
		}
		
		transmettreAttributs(bipForm, request);
		
		return mapping.findForward("initial");
	}
	
	/**
	 * 	Transmission en attribut de la request des éléments mis à jour dans le formulaire, 
		car seule la request est transmise lors du changement d'action (pas le formulaire)
	 * @param bipForm
	 * @param request
	 */
	private void transmettreAttributs(StructLbForm bipForm, HttpServletRequest request) {
		request.setAttribute("btRadioStructure", bipForm.getBtRadioStructure());
		request.setAttribute("setMsgErreur", bipForm.getMsgErreur());
	}
	
	/**
	 * Alimentation du bouton radio structure étape parente
	 * @param form
	 */
	private void cocherEtapeParente(TacheForm form) {
		String btRadioEtape = form.getBtRadioEtapeFromTache();
		
		if (StringUtils.isNotEmpty(btRadioEtape)) {
			// Cocher l'étape parente
			form.setBtRadioStructure(btRadioEtape);
		}
	}

	/**
	 * Alimentation du formulaire avec le numéro de la nouvelle tâche
	 * @param mapping
	 * @param form
	 * @param request
	 * @param hParamProc
	 * @return
	 */
	private ActionForward alimenterNumeroNouvelleTache(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, Hashtable hParamProc) {
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		String signatureMethode = "TacheAction -alimenterNumeroNouvelleTache( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_S);
			// Récupération des résultats
			TacheForm bipForm = (TacheForm) form;
			bipForm.setActa(((ParametreProc) vParamOut.get(0)).getValeur()
					.toString());

			try {
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser.debug("TacheAction -alimenterNumeroNouvelleTache() --> BaseException :"
						+ be);
				logBipUser.debug("TacheAction -alimenterNumeroNouvelleTache() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("TacheAction -alimenterNumeroNouvelleTache() --> BaseException :"
						+ be);
				logService.debug("TacheAction -alimenterNumeroNouvelleTache() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((TacheForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser.debug("TacheAction-alimenterNumeroNouvelleTache() --> BaseException :" + be);
			logBipUser.debug("TacheAction-alimenterNumeroNouvelleTache() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("TacheAction-alimenterNumeroNouvelleTache() --> BaseException :" + be);
			logService.debug("TacheAction-alimenterNumeroNouvelleTache() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((TacheForm) form).setMsgErreur(message);
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

	/**
	 * Alimentation de l'attribut keyList2 du formulaire avec les infos numéro d'étape et libellé d'étape parente
	 * @param form
	 * @param request
	 * @param hParamProc
	 */
	protected void alimenterInfosParentEtape(ActionForm form, HttpServletRequest request, Hashtable hParamProc) {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";

		String signatureMethode = "TacheAction-getInfosEtape( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		
		TacheForm bipForm = (TacheForm) form;
		
		String idEtape = bipForm.getIdEtapeFromBtRadio();
		
		if (StringUtils.isNotEmpty(idEtape)) {
			bipForm.setEtape(idEtape);
			hParamProc.put("etape", idEtape);
		}
		
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_L);
			// Récupération des résultats
			bipForm.setKeyList2(((ParametreProc) vParamOut.get(0))
					.getValeur().toString());

			try {
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser.debug("TacheAction -getInfosEtape() --> BaseException :"
						+ be);
				logBipUser.debug("TacheAction -getInfosEtape() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("TacheAction -getInfosEtape() --> BaseException :"
						+ be);
				logService.debug("TacheAction -getInfosEtape() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
						"11217"));
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((TacheForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
			}

		} // try
		catch (BaseException be) {
			logBipUser
					.debug("TacheAction-creer() --> BaseException :" + be);
			logBipUser.debug("TacheAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService
					.debug("TacheAction-creer() --> BaseException :" + be);
			logService.debug("TacheAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du
			// message global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(BipException
						.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((TacheForm) form).setMsgErreur(message);

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
						"11201"));
				request.setAttribute("messageErreur", be
						.getInitialException().getMessage());
			}
		}

		logBipUser.exit(signatureMethode);
		jdbc.closeJDBC(); 
	}

	/**
	 * Alimentation du formulaire avec les infos de la tâche
	 * @param mapping
	 * @param form
	 * @param request
	 * @param hParamProc
	 * @return
	 */
	private ActionForward alimenterInfosTache(ActionMapping mapping, ActionForm form, HttpServletRequest request, Hashtable hParamProc) {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "TacheAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);

		// Création d'une nouvelle form
		TacheForm bipForm = (TacheForm) form;
		
		String idTache = bipForm.getIdTacheFromBtRadio();
		
		if (StringUtils.isNotEmpty(idTache)) {
			bipForm.setTache(idTache);
			hParamProc.put("tache", idTache);
		}
		
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

							bipForm.setTache(rset.getString(1));
							bipForm.setPid(rset.getString(2));
							bipForm.setEtape(rset.getString(3));
							bipForm.setActa(rset.getString(4));
							bipForm.setLibtache(rset.getString(5));
							bipForm.setFlaglock(rset.getString(6));
							bipForm.setTacheaxemetier(rset.getString(7));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					} // try
					catch (SQLException sqle) {
						logService
								.debug("TacheAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("TacheAction-consulter() --> SQLException :"
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
									.debug("TacheAction-consulter() --> SQLException-rset.close() :"
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
				// le code Tache n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"TacheAction-consulter() --> BaseException :" + be, be);
			logBipUser.debug("TacheAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
					"TacheAction-consulter() --> BaseException :" + be, be);
			logService.debug("TacheAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((TacheForm) form).setMsgErreur(message);
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

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}
	// MCH : PPM 61919 chapitre 6.7 
	public ActionForward verifierTacheAxeMetier(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="TacheAction - verifierTacheAxeMetier";
		
		return traitementAjax(PACK_VERIFIER, signatureMethode, mapping, form, response, hParamProc);
	}
	
	private ActionForward traitementAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		TacheForm bipForm = (TacheForm) form;
		
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
	
	// MCH : PPM 61919 chapitre 6.7
	public ActionForward mettreAvide(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="TacheAction - mettreAvide";
		
		return traitAjax(PACK_MISE_A_VIDE, signatureMethode, mapping, form, response, hParamProc, request);
	}
	
	private ActionForward traitAjax(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc, HttpServletRequest request) throws IOException {
		logBipUser.entry(signatureMethode);
		
		TacheForm bipForm = (TacheForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message = "";
		
		// Appel de la procï¿½dure
		try {
			String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getIdUser();
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
	
	// MCH : PPM 61919 chapitre 6.7
	public ActionForward initialiserTacheAxeMetier(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws IOException{
		String signatureMethode ="TacheAction - initialiserTacheAxeMetier";
		return traitementAjaxInit(PACK_INITIALISER, signatureMethode, mapping, form, response, hParamProc);
	}
	
	private ActionForward traitementAjaxInit(String cleProc, String signatureMethode, ActionMapping mapping, ActionForm form, HttpServletResponse response, Hashtable hParamProc) throws IOException {
		logBipUser.entry(signatureMethode);
		
		TacheForm bipForm = (TacheForm) form;
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String tacheaxemetier = "";
		String result = "";
		
		// Appel de la procï¿½dure
		try {
			vParamOut= jdbc.getResult (hParamProc,configProc, cleProc);
		 	// ----------------------------------------------------------
			for (Enumeration e=vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("tacheaxemetier")) {
					if (paramOut.getValeur() != null) {
						tacheaxemetier = (String) paramOut.getValeur();
					}
				}
			}	
		}
		catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"+be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :"+be);
			
			
			
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
		result = tacheaxemetier;
		out.print(new String(result.getBytes("utf8"), "iso-8859-1"));
		out.flush();
		
		logBipUser.exit(signatureMethode);
		
		return PAS_DE_FORWARD;
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
