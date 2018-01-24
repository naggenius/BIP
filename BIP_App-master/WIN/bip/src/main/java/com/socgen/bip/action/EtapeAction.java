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
import com.socgen.bip.form.EtapeForm;
import com.socgen.bip.form.StructLbForm;
import com.socgen.cap.fwk.exception.BaseException;

/**
 * @author N.BACCAM - 27/05/2003
 * 
 * Action de mise à jour des Etapes chemin : Saisie des
 * réalisés/Paramétrage/Structure LigneBIP pages : fmEtape.jsp et mEtape.jsp
 * pl/sql : isac_etape.sql
 */
public class EtapeAction extends AutomateAction {

	private static String PACK_SELECT_S = "etape.consulter_s.proc";

	private static String PACK_SELECT = "etape.consulter.proc";

	private static String PACK_INSERT = "etape.creer.proc";

	private static String PACK_UPDATE = "etape.modifier.proc";

	private static String PACK_DELETE = "etape.supprimer.proc";
	
	/**
	 * Action qui permet d'afficher l'écran de création d'une étape
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		return alimenterNumeroNouvelleEtapeEtJeu(mapping, form, request, hParamProc);
		
	}

	/**
	 * Action qui permet de visualiser les données liées à un code Etape pour la
	 * modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		return alimenterInfosEtape(mapping, form, request, hParamProc);
		
	}
	
	public ActionForward valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors ,Hashtable hParamProctest ) throws ServletException {
		ActionForward actionForward = super.valider(mapping, form, mode, request, response, errors, hParamProctest);
		
		EtapeForm bipForm = (EtapeForm) form;
		
		// Si écran de suppression et suppression OK (message "Etape supprimée")
		if (AutomateForm.modeSupprimer.equals(bipForm.getMode()) && bipForm.suppressionOK()) {
			// Aucune case cochée
			bipForm.setBtRadioStructure(null);
			
		}
		else {
			// Cocher l'étape
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
		
		EtapeForm bipForm = (EtapeForm) form;
		
		// Si écran de création
		if (AutomateForm.modeCreer.equals(bipForm.getMode())) {
			// Aucune case cochée
			bipForm.setBtRadioStructure(null);
		}
		// Si écran de modification ou suppression
		else {
			// Cocher l'étape
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
	
	protected ActionForward alimenterNumeroNouvelleEtapeEtJeu(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, Hashtable hParamProc) {
//		 Alimentation du numéro de la nouvelle étape et du jeu 
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "EtapeAction -creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_S);
			// Récupération des résultats
			EtapeForm bipForm = (EtapeForm) form;
			bipForm.setEcet(((ParametreProc) vParamOut.get(0)).getValeur()
					.toString());

			try {
				message = jdbc.recupererResult(vParamOut, "creer");
				
				for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
					paramOut = (ParametreProc) e.nextElement();

					// récupérer le message
					if (paramOut.getNom().equals("jeu")) {
						bipForm.setJeu((String) paramOut.getValeur());
						logBipUser.debug("test antoine inti jeu : "
								+ bipForm.getJeu());

					}
				}
				
				
			} catch (BaseException be) {
				logBipUser.debug("EtapeAction -creer() --> BaseException :"
						+ be);
				logBipUser.debug("EtapeAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("EtapeAction -creer() --> BaseException :"
						+ be);
				logService.debug("EtapeAction -creer() --> Exception :"
						+ be.getInitialException().getMessage());
				// Erreur de lecture du resultSet
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				// this.saveErrors(request,errors);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
			if (!message.equals("")) {
				// Entité déjà existante, on récupère le message
				((EtapeForm) form).setMsgErreur(message);
				// HMI - PPM 60709 : $5.3
				bipForm.setMsgErreur(message);
				logBipUser.debug("message d'erreur:" + message);
				logBipUser.exit(signatureMethode);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("EtapeAction-creer() --> BaseException :" + be);
			logBipUser.debug("EtapeAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("EtapeAction-creer() --> BaseException :" + be);
			logService.debug("EtapeAction-creer() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((EtapeForm) form).setMsgErreur(message);
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
	 * Alimentation du formulaire avec les infos de l'étape
	 * @param mapping
	 * @param form
	 * @param request
	 * @param hParamProc
	 * @return
	 */
	private ActionForward alimenterInfosEtape(ActionMapping mapping, ActionForm form, HttpServletRequest request, Hashtable hParamProc) {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "EtapeAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		
		EtapeForm bipForm = (EtapeForm) form;
		
		String idEtape = bipForm.getIdEtapeFromBtRadio();
		
		if (StringUtils.isNotEmpty(idEtape)) {
			bipForm.setEtape(idEtape);
			hParamProc.put("etape", idEtape);
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

							bipForm.setEtape(rset.getString(1));
							bipForm.setPid(rset.getString(2));
							bipForm.setEcet(rset.getString(3));
							bipForm.setLibetape(rset.getString(4));
							bipForm.setTypetape(rset.getString(5));
							bipForm.setFlaglock(rset.getString(6));
							bipForm.setJeu(rset.getString(7));
							bipForm.setMsgErreur(null);
						} else
							msg = true;

					}// try
					catch (SQLException sqle) {
						logService
								.debug("EtapeAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("EtapeAction-consulter() --> SQLException :"
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
									.debug("EtapeAction-consulter() --> SQLException-rset.close() :"
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
				// le code Etape n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug(
					"EtapeAction-consulter() --> BaseException :" + be, be);
			logBipUser.debug("EtapeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
					"EtapeAction-consulter() --> BaseException :" + be, be);
			logService.debug("EtapeAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((EtapeForm) form).setMsgErreur(message);
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
