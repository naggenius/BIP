package com.socgen.bip.action;

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
import com.socgen.bip.form.SousTacheForm;
import com.socgen.bip.form.StructLbForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 28/07/2003
 * 
 * Action de mise à jour des SousTaches chemin : Saisie des
 * réalisés/Paramétrage/Structure LigneBIP pages : fSoustache.jsp,
 * fmSoustache.jsp et mSoustache.jsp pl/sql : isac_sous_tache.sql
 */
public class SousTacheAction extends AutomateAction {

	private static String PACK_SELECT_S = "sousTache.consulter_s.proc";

	private static String PACK_SELECT_L = "sousTache.consulter_l.proc";

	private static String PACK_SELECT = "sousTache.consulter.proc";

	private static String PACK_INSERT = "sousTache.creer.proc";

	private static String PACK_UPDATE = "sousTache.modifier.proc";

	private static String PACK_DELETE = "sousTache.supprimer.proc";

	private static String PACK_GETLIB = "sousTache.getlib.proc";
	
	/**
	 * Action qui permet d'accéder à l'écran de création d'étape
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		alimenterInfosParentsEtapeTache(form, request, hParamProc);
		return alimenterNumeroNouvelleSsTache(mapping, form, request, hParamProc);		
	}
	
	/**
	 * Action qui permet de visualiser les données liées à un code SousTache
	 * pour la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		alimenterInfosParentsEtapeTache(form, request, hParamProc);
		return alimenterInfosSsTache(mapping, form, request, hParamProc);
	}
	
	public ActionForward valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProctest ) throws ServletException {
		ActionForward actionForward = super.valider(mapping, form, mode, request, response, errors, hParamProctest);
		
		SousTacheForm bipForm = (SousTacheForm) form;
		
		// Si écran de création 
		// ou 
		// Si écran de suppression et suppression OK (message "Sous-tâche supprimée")
		if (AutomateForm.modeCreer.equals(bipForm.getMode()) ||
				(AutomateForm.modeSupprimer.equals(bipForm.getMode()) && bipForm.suppressionOK())) {
			cocherTacheParente(bipForm);
		}
		else {
			// Cocher la tâche
		}
		
		transmettreAttributs(bipForm, request);
		
		return actionForward;
	}
	
	
	/**
	 * Retour à l'écran structure d'une ligne BIP depuis l'écran d'administration des étapes
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) {
		
		SousTacheForm bipForm = (SousTacheForm) form;
		
		// Si écran de création
		if (AutomateForm.modeCreer.equals(bipForm.getMode())) {
			cocherTacheParente(bipForm);
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
	 * Alimentation du bouton radio structure tâche parente
	 * @param form
	 */
	private void cocherTacheParente(SousTacheForm form) {
		String btRadioTache = form.getBtRadioTacheFromSsTache();
		
		if (StringUtils.isNotEmpty(btRadioTache)) {
			// Cocher l'étape parente
			form.setBtRadioStructure(btRadioTache);
		}
	}
	
	
	/**
	 * Alimentation des attributs keyList2/keyList4 du formulaire avec les infos numéro d'étape/tâche et libellé d'étape/tâche parentes
	 * @param form
	 * @param request
	 * @param hParamProc
	 */
	protected void alimenterInfosParentsEtapeTache(ActionForm form, HttpServletRequest request, Hashtable hParamProc) {
		SousTacheForm bipForm = (SousTacheForm) form;
		
		String idEtape = bipForm.getIdEtapeFromBtRadio();
		
		if (StringUtils.isNotEmpty(idEtape)) {
			bipForm.setEtape(idEtape);
			hParamProc.put("etape", idEtape);
			bipForm.setKeyList1(idEtape);
		}
		
		String idTache = bipForm.getIdTacheFromBtRadio();
		
		if (StringUtils.isNotEmpty(idTache)) {
			bipForm.setTache(idTache);
			hParamProc.put("tache", idTache);
			hParamProc.put("etapeTache", idEtape + "-" + idTache);
			bipForm.setKeyList2(idTache);
		}
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";

		String signatureMethode = "SousTacheAction-alimenterInfosParentsEtapeTache( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_L);
			// Récupération des résultats
			bipForm.setKeyList3(((ParametreProc) vParamOut.get(0))
					.getValeur().toString());
			bipForm.setKeyList4(((ParametreProc) vParamOut.get(1))
					.getValeur().toString());

			try {
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser
						.debug("SousTacheAction -alimenterInfosParentsEtapeTache() --> BaseException :"
								+ be);
				logBipUser.debug("SousTacheAction -alimenterInfosParentsEtapeTache() --> Exception :"
						+ be.getInitialException().getMessage());
				logService
						.debug("SousTacheAction -alimenterInfosParentsEtapeTache() --> BaseException :"
								+ be);
				logService.debug("SousTacheAction -alimenterInfosParentsEtapeTache() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
						"11217"));
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((SousTacheForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
			}

		} // try
		catch (BaseException be) {
			logBipUser.debug("SousTacheAction-alimenterInfosParentsEtapeTache() --> BaseException :"
					+ be);
			logBipUser.debug("SousTacheAction-alimenterInfosParentsEtapeTache() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("SousTacheAction-alimenterInfosParentsEtapeTache() --> BaseException :"
					+ be);
			logService.debug("SousTacheAction-alimenterInfosParentsEtapeTache() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du
			// message global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(BipException
						.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SousTacheForm) form).setMsgErreur(message);

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
						"11201"));
				request.setAttribute("messageErreur", be
						.getInitialException().getMessage());
			}
		}

		logBipUser.exit(signatureMethode);
	}
	
	/**
	 * Alimentation du formulaire avec le numéro de la nouvelle sous-tâche
	 * @param mapping
	 * @param form
	 * @param request
	 * @param hParamProc
	 * @return
	 */
	protected ActionForward alimenterNumeroNouvelleSsTache(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, Hashtable hParamProc) {
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";

		String signatureMethode = "SousTacheAction -alimenterNumeroNouvelleSsTache( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_S);
			// Récupération des résultats
			SousTacheForm bipForm = (SousTacheForm) form;
			bipForm.setAcst(((ParametreProc) vParamOut.get(0)).getValeur()
					.toString());

			try {
				message = jdbc.recupererResult(vParamOut, "creer");
			} catch (BaseException be) {
				logBipUser.debug("SousTacheAction -alimenterNumeroNouvelleSsTache() --> BaseException :"
						+ be);
				logBipUser.debug("SousTacheAction -alimenterNumeroNouvelleSsTache() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("SousTacheAction -alimenterNumeroNouvelleSsTache() --> BaseException :"
						+ be);
				logService.debug("SousTacheAction -alimenterNumeroNouvelleSsTache() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((SousTacheForm) form).setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		} // try
		catch (BaseException be) {
			logBipUser
					.debug("SousTacheAction-alimenterNumeroNouvelleSsTache() --> BaseException :" + be);
			logBipUser.debug("SousTacheAction-alimenterNumeroNouvelleSsTache() --> Exception :"
					+ be.getInitialException().getMessage());
			logService
					.debug("SousTacheAction-alimenterNumeroNouvelleSsTache() --> BaseException :" + be);
			logService.debug("SousTacheAction-alimenterNumeroNouvelleSsTache() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SousTacheForm) form).setMsgErreur(message);
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
	 * Alimentation du formulaire avec les infos de la sous-tâche
	 * @param mapping
	 * @param form
	 * @param request
	 * @param hParamProc
	 * @return
	 */
	private ActionForward alimenterInfosSsTache(ActionMapping mapping, ActionForm form, HttpServletRequest request, Hashtable hParamProc) {
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "SousTacheAction-alimenterInfosSsTache(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		SousTacheForm bipForm = (SousTacheForm) form;
		
		String idSsTache = bipForm.getBtIdSsTacheFromBtRadio();
		
		if (StringUtils.isNotEmpty(idSsTache)) {
			// Alimentation du paramètre étape pour transmission
			bipForm.setSous_tache(idSsTache);
			hParamProc.put("sous_tache", idSsTache);
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

							bipForm.setSous_tache(rset.getString(1));
							bipForm.setAcst(rset.getString(2));
							bipForm.setAist(rset.getString(3));
							bipForm.setAsnom(rset.getString(4));
							bipForm.setAdeb(rset.getString(5));
							bipForm.setAfin(rset.getString(6));
							bipForm.setAnde(rset.getString(7));
							bipForm.setAnfi(rset.getString(8));
							bipForm.setAsta(rset.getString(9));
							bipForm.setAdur(rset.getString(10));
							bipForm.setParamLocal(rset.getString(11));
							bipForm.setFlaglock(rset.getString(12));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					} // try
					catch (SQLException sqle) {
						logService
								.debug("SousTacheAction-alimenterInfosSsTache() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SousTacheAction-alimenterInfosSsTache() --> SQLException :"
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
									.debug("SousTacheAction-alimenterInfosSsTache() --> SQLException-rset.close() :"
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
				// le code SousTache n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug("SousTacheAction-alimenterInfosSsTache() --> BaseException :"
					+ be, be);
			logBipUser.debug("SousTacheAction-alimenterInfosSsTache() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("SousTacheAction-alimenterInfosSsTache() --> BaseException :"
					+ be, be);
			logService.debug("SousTacheAction-alimenterInfosSsTache() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SousTacheForm) form).setMsgErreur(message);
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

	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		SousTacheForm bipForm = (SousTacheForm) form;
 
		Vector vParamOut = new Vector();

		try {

			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_GETLIB);
			bipForm.setLibpid((String) ((ParametreProc) vParamOut.elementAt(0))
					.getValeur());
			bipForm.setCodsg((String) ((ParametreProc) vParamOut.elementAt(1))
					.getValeur());
			bipForm.setLibcodsg((String) ((ParametreProc) vParamOut
					.elementAt(2)).getValeur());
			bipForm.setMsgErreur((String) ((ParametreProc) vParamOut
					.elementAt(3)).getValeur());

			// MAJ du Focus
			if (bipForm.getMsgErreur() == null)
				   bipForm.setFocus("asnom");
			else
				   bipForm.setAist(null);

		} catch (BaseException be) {
			logBipUser.debug("SousTacheAction-refresh() --> BaseException :"
					+ be, be);
			logBipUser.debug("SousTacheAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("SousTacheAction-refresh() --> BaseException :"
					+ be, be);
			logService.debug("SousTacheAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("error");
		}
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
}
