package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ScenarioForm;
import com.socgen.bip.metier.Scenario;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author A131188
 * 
 * Action de mise � jour des sc�narios de l'outil de reestime chemin : pages :
 * mScenarioRe.jsp , bScenarioRe.jsp, fmScenarioRe.jsp pl/sql :
 * ree_scenarios.sql
 */
public class ScenarioAction extends AutomateAction {
	private static String PACK_SELECT_LISTE = "scenario.liste.proc";

	private static String PACK_SELECT = "scenario.select.proc";

	private static String PACK_INSERT = "scenario.insert.proc";

	private static String PACK_UPDATE = "scenario.update.proc";

	private static String PACK_DELETE = "scenario.delete.proc";

	private int blocksize = 10;
	
	

	/**
	 * Action qui permet de visualiser les donn�es li�es � un code scenario et
	 * DPG pour la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String codsg;

		String signatureMethode = "ScenarioAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);

		// Cr�ation d'une nouvelle form
		ScenarioForm scenarioForm = (ScenarioForm) form;
		scenarioForm.setCode_scenario(scenarioForm.getCode_scenario_choisi());

		hParamProc.put("code_scenario", scenarioForm.getCode_scenario_choisi());

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
						logBipUser.debug("ResultSet");
						if (rset.next()) {
							scenarioForm.setCodsg(rset.getString("codsg"));
							scenarioForm.setCode_scenario(rset
									.getString("code_scenario"));
							scenarioForm.setLib_scenario(rset
									.getString("lib_scenario"));
							scenarioForm
									.setOfficiel(rset.getString("officiel"));
							scenarioForm.setCommentaire(rset
									.getString("commentaire"));

							scenarioForm.setMsgErreur(null);
						} else
							msg = true;

						if (rset != null) {
							rset.close();
						}

					} // try
					catch (SQLException sqle) {
						logBipUser
								.debug("ScenarioAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ScenarioAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			} // for
			if (msg) {
				// le code Personne n'existe pas, on r�cup�re le message
				scenarioForm.setMsgErreur(message);
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug("ScenarioAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ScenarioAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logBipUser.debug("ScenarioAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ScenarioAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ScenarioForm) form).setMsgErreur(message);
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

		logService.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	} // consulter

	/**
	 * Action qui permet de visualiser la liste des sc�narios li�s � un code DPG
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String codsg;
		Vector vListe = new Vector();
		PaginationVector vueListe;

		String signatureMethode = "ScenarioAction-suite(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Cr�ation d'une nouvelle form
		ScenarioForm scenarioForm = (ScenarioForm) form;

		hParamProc.put("P_global", userBip.getInfosUser());

		// On ex�cute la proc�dure PL/SQL qui ram�ne les r�sultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_LISTE);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							// On alimente le Bean Propose et on le stocke dans
							// un vector
							vListe.add(new Scenario(rset.getString(1), rset
									.getString(2), rset.getString(3), rset
									.getString(4)));
						}
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("ScenarioAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ScenarioAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));

						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}// if
			}// for
		}// try
		catch (BaseException be) {
			logBipUser.debug("ScenarioAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ScenarioAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ScenarioAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ScenarioAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				scenarioForm.setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());

				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

		}

		// Construire un PaginationVector contenant les informations du FormBean
		vueListe = new PaginationVector(vListe, blocksize);

		// Stocker le r�sultat dans la session
		(request.getSession(false)).setAttribute(SCENARIO, vueListe);
		// Stocker le r�sultat dans le formulaire
		scenarioForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("suite");

	} // consulter

	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String codsg;
		String signatureMethode = "ScenarioAction-creer(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		ScenarioForm scenarioForm = (ScenarioForm) form;

		// Force officiel � Non
		scenarioForm.setOfficiel("N");

		logService.exit(signatureMethode);

		 return mapping.findForward("ecran");
	}// fin creer

	/**
	 * Action qui permet de passer � la page premi�re page avec destruction du
	 * tableau en session
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		HttpSession session = request.getSession(false);

		String signatureMethode = "ScenarioAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On d�truit le tableau sauvegard� en session
		session.removeAttribute(SCENARIO);
		logBipUser.debug("Destruction de la liste des sc�narios en session");

		logBipUser.exit(signatureMethode);

		  return mapping.findForward("initial");
	}

	/**
	 * Method pageIndex.
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @ jdbc.closeJDBC(); return ActionForward
	 * @throws ServletException
	 */
	protected ActionForward pageIndex(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) throws ServletException {
		PaginationVector page;
		String pageName;
		String index;
		HttpSession session = request.getSession(false);
		ActionForward actionForward = null;

		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");

		// Extraction de l'index
		index = (String) request.getParameter("index");

		page = (PaginationVector) session.getAttribute(pageName);

		if (page != null) {
			page.setBlock(Integer.parseInt(index));
			actionForward = mapping.findForward("suite");

		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			actionForward = mapping.findForward("error");

		}// else if

		 return actionForward;

	}// pageIndex

	/**
	 * Action envoy�e pour passer � la page suivante
	 * 
	 * @param request
	 *            la requ�te HTTP.
	 * @param response
	 *            la r�ponse HTTP.
	 */
	protected ActionForward pageSuivante(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors)
			throws ServletException {
		PaginationVector page;
		String pageName;
		HttpSession session = request.getSession(false);

		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");
		page = (PaginationVector) session.getAttribute(pageName);

		if (page != null) {
			page.getNextBlock();
			 return mapping.findForward("suite");

		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			 return mapping.findForward("error");
		}
	}

	/**
	 * Action envoy�e pour passer � la page pr�c�dente
	 * 
	 * @param request
	 *            la requ�te HTTP.
	 * @param response
	 *            la r�ponse HTTP.
	 */
	protected ActionForward pagePrecedente(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors)
			throws ServletException {
		PaginationVector page;
		String pageName;

		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");

		// Extraction de la liste � paginer
		page = (PaginationVector) request.getSession(false).getAttribute(
				pageName);

		if (page != null) {
			page.getPreviousBlock();
			return mapping.findForward("suite");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			 return mapping.findForward("error");
		}
	}

	/**
	 * Method valider Action qui permet d'enregistrer les donn�es pour la
	 * cr�ation, modification, suppression d'un code client
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @ jdbc.closeJDBC(); return ActionForward
	 * @throws ServletException
	 * 
	 */
	public ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProctest) throws ServletException {
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;

		super.valider(mapping, form, mode, request, response, errors,
				hParamProctest);

		ScenarioForm scenarioForm = (ScenarioForm) form;
		scenarioForm.setCode_scenario(null);
		scenarioForm.setCode_scenario_choisi(null);

		return suite(mapping, scenarioForm, request, response, errors,
				hParamProctest);

	}// valider

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