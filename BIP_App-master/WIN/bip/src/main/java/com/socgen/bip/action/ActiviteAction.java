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
import com.socgen.bip.form.ActiviteForm;
import com.socgen.bip.metier.Activite;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author X058813
 * 
 * Action de mise Ã  jour des activites de l'outil de reestime chemin : pages : ********
 * bActiviteRe.jsp, fmActiviteRe.jsp, mActiviteRe.jsp pl/sql : activite.sql
 */
public class ActiviteAction extends AutomateAction {
	private static String PACK_SELECT_LISTE = "activite.select.liste.proc";

	private static String PACK_SELECT_ACT = "activite.select.act.proc";

	private static String PACK_INSERT = "activite.insert.act.proc";

	private static String PACK_UPDATE = "activite.update.act.proc";

	private static String PACK_DELETE = "activite.delete.act.proc";

	
	
	private int blocksize = 10;

	/**
	 * Action qui permet de visualiser les données liées à un code activite et
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

		
		
		String signatureMethode = "ActiviteAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);

		// Création d'une nouvelle form
		ActiviteForm activiteForm = (ActiviteForm) form;
		// Cas où il y a un seul element dans la liste
		if (activiteForm.getCode_activite() == null
				&& (activiteForm.getCode_activite_choisi().equals(""))
				|| activiteForm.getCode_activite_choisi() == null) {
			HttpSession session = request.getSession(false);
			PaginationVector vueListe = (PaginationVector) session
					.getAttribute(ACTIVITE);
			// On prend la premiere et la seule Activite de la liste
			Activite activite = (Activite) vueListe.get(0);
			activiteForm.setCode_activite(activite.getCode_activite());
			hParamProc.put("code_activite", activiteForm.getCode_activite());
		} else if (activiteForm.getCode_activite_choisi() != null) {
			activiteForm.setCode_activite(activiteForm
					.getCode_activite_choisi());
			hParamProc.put("code_activite", activiteForm.getCode_activite_choisi());
		} else {
			hParamProc.put("code_activite", activiteForm.getCode_activite());
		}

		try {
			
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_ACT);

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
						logBipUser.debug("ResultSet");
						if (rset.next()) {
							activiteForm.setCodsg(rset.getString("codsg"));
							activiteForm.setCode_activite(rset
									.getString("code_activite"));
							activiteForm.setLib_activite(rset
									.getString("lib_activite"));

							activiteForm.setMsgErreur(null);
						} else
							msg = true;

						if (rset != null) {
							rset.close();
						}

					} // try
					catch (SQLException sqle) {
						logBipUser
								.debug("ActiviteAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ActiviteAction-consulter() --> SQLException :"
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
				// le code Personne n'existe pas, on rÃ©cupÃ¨re le message
				activiteForm.setMsgErreur(message);
				// on reste sur la même page
				jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug("ActiviteAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ActiviteAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logBipUser.debug("ActiviteAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ActiviteAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ActiviteForm) form).setMsgErreur(message);
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

		logService.exit(signatureMethode);

		jdbc.closeJDBC(); return mapping.findForward("ecran");
	} // consulter

	/**
	 * Action qui permet de visualiser la liste des activites liées à un code
	 * DPG
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

		String signatureMethode = "ActiviteAction-suite(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Création d'une nouvelle form
		ActiviteForm activiteForm = (ActiviteForm) form;
		activiteForm.setCode_activite(null);
		activiteForm.setCode_activite_choisi(null);

		hParamProc.put("P_global", userBip.getInfosUser());

		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_LISTE);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							// On alimente le Bean Propose et on le stocke dans
							// un vector
							vListe.add(new Activite(rset.getString(1), rset
									.getString(2), rset.getString(3)));
						}
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("ActiviteAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ActiviteAction-consulter() --> SQLException :"
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
			logBipUser.debug("ActiviteAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ActiviteAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ActiviteAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ActiviteAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				activiteForm.setMsgErreur(message);
				jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc.closeJDBC(); return mapping.findForward("error");
			}

		}

		// Construire un PaginationVector contenant les informations du FormBean
		vueListe = new PaginationVector(vListe, blocksize);

		// Stocker le résultat dans la session
		(request.getSession(false)).setAttribute(ACTIVITE, vueListe);
		// Stocker le résultat dans le formulaire
		activiteForm.setListePourPagination(vueListe);

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
		String signatureMethode = "ActiviteAction-creer(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
		// Création d'une nouvelle form
		ActiviteForm activiteForm = (ActiviteForm) form;
		activiteForm.setCode_activite(null);
		activiteForm.setCode_activite_choisi(null);

		logService.exit(signatureMethode);

		return mapping.findForward("ecran");
	}// fin creer

	/**
	 * Action qui permet de passer à la page première page avec destruction du
	 * tableau en session
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		HttpSession session = request.getSession(false);

		String signatureMethode = "ActiviteAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On détruit le tableau sauvegardé en session
		session.removeAttribute(ACTIVITE);
		logBipUser.debug("Destruction de la liste des activites en session");

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

		ActiviteForm activiteForm = (ActiviteForm) form;
		if (activiteForm.getCode_activite_choisi() != null) {
			activiteForm.setCode_activite(activiteForm
					.getCode_activite_choisi());
		}
		activiteForm.setCode_activite_choisi(null);

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
	 * Action envoyée pour passer à la page suivante
	 * 
	 * @param request
	 *            la requête HTTP.
	 * @param response
	 *            la réponse HTTP.
	 */
	protected ActionForward pageSuivante(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors)
			throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		PaginationVector page;
		String pageName;
		HttpSession session = request.getSession(false);

		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");
		page = (PaginationVector) session.getAttribute(pageName);

		ActiviteForm activiteForm = (ActiviteForm) form;
		if (activiteForm.getCode_activite_choisi() != null) {
			activiteForm.setCode_activite(activiteForm
					.getCode_activite_choisi());
		}
		activiteForm.setCode_activite_choisi(null);

		if (page != null) {
			page.getNextBlock();
			jdbc.closeJDBC(); return mapping.findForward("suite");

		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
		jdbc.closeJDBC(); return mapping.findForward("error");
		}
	}

	/**
	 * Action envoyée pour passer à la page précédente
	 * 
	 * @param request
	 *            la requête HTTP.
	 * @param response
	 *            la réponse HTTP.
	 */
	protected ActionForward pagePrecedente(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors)
			throws ServletException {
		
	 
		PaginationVector page;
		String pageName;

		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");

		// Extraction de la liste à paginer
		page = (PaginationVector) request.getSession(false).getAttribute(
				pageName);

		ActiviteForm activiteForm = (ActiviteForm) form;
		if (activiteForm.getCode_activite_choisi() != null) {
			activiteForm.setCode_activite(activiteForm
					.getCode_activite_choisi());
		}
		activiteForm.setCode_activite_choisi(null);

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
	 * Method valider Action qui permet d'enregistrer les données pour la
	 * création, modification, suppression d'un code client
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
		ActiviteForm activiteForm = (ActiviteForm) form;
		activiteForm.setCode_activite(null);
		activiteForm.setCode_activite_choisi(null);
		return suite(mapping, activiteForm, request, response, errors,
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