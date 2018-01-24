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
import com.socgen.bip.form.RessReesForm;
import com.socgen.bip.metier.RessRees;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author MMC
 * 
 * Action de mise à jour des ressources de l'outil de reestime pages :
 * bRessourceRe.jsp, fmRessourceRe.jsp, mRessourceRe.jsp, pl/sql : ree_ress.sql
 */
public class RessReesAction extends AutomateAction {
	private static String PACK_SELECT = "ressrees.consulter.proc";

	private static String PACK_SELECT_RESS = "ressrees.liste.proc";

	private static String PACK_SELECT_DONNEES = "ressrees.ress.proc";

	private static String PACK_INSERT = "ressrees.creer.proc";

	private static String PACK_UPDATE = "ressrees.modifier.proc";

	private static String PACK_DELETE = "ressrees.supprimer.proc";

	private static String PACK_INIT = "ressrees.init.proc";

	private int blocksize = 10;
	
	

	/**
	 * Action qui permet de visualiser la liste des ressources liées à un code
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

		String signatureMethode = "RessReesAction-suite(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Création d'une nouvelle form
		RessReesForm ressReesForm = (RessReesForm) form;
		ressReesForm.setIdent(null);
		ressReesForm.setIdent_choisi(null);

		hParamProc.put("P_global", userBip.getInfosUser());

		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_RESS);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							// On alimente le Bean et on le stocke dans un
							// vector
							vListe.add(new RessRees(rset.getString(1), rset
									.getString(2), rset.getString(3), rset
									.getString(4), rset.getString(5), rset
									.getString(6), rset.getString(7), rset
									.getString(8)));
						}
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("RessReesAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("RessReesAction-consulter() --> SQLException :"
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
			logBipUser.debug("RessReesAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("RessReesAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("RessReesAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("RessReesAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				ressReesForm.setMsgErreur(message);
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
		(request.getSession(false)).setAttribute(RESSREES, vueListe);
		// Stocker le résultat dans le formulaire
		ressReesForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("suite");

	}

	/**
	 * Action qui permet de visualiser les données liées à une ressource pour la
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
		String codsg;

		String signatureMethode = "RessReesAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		RessReesForm ressReesForm = (RessReesForm) form;
		// Cas où il y a un seul element dans la liste
		if (ressReesForm.getIdent() == null
				&& (ressReesForm.getIdent_choisi().equals(""))
				|| ressReesForm.getIdent_choisi() == null) {
			HttpSession session = request.getSession(false);
			PaginationVector vueListe = (PaginationVector) session
					.getAttribute(RESSREES);
			// On prend la premiere et la seule ressource de la liste
			RessRees ressRees = (RessRees) vueListe.get(0);
			ressReesForm.setIdent(ressRees.getIdent());
			hParamProc.put("ident", ressReesForm.getIdent());
		} else if (ressReesForm.getIdent_choisi() != null) {
			ressReesForm.setIdent(ressReesForm.getIdent_choisi());
			hParamProc.put("ident", ressReesForm.getIdent_choisi());
		} else {
			hParamProc.put("ident", ressReesForm.getIdent());
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
							ressReesForm.setCodsg(rset.getString("codsg"));
							ressReesForm.setType(rset.getString("type"));
							// ressReesForm.setIdent(rset.getString("ident"));
							ressReesForm.setRnom(rset.getString("rnom"));
							ressReesForm.setRprenom(rset.getString("rprenom"));
							ressReesForm.setDatdep(rset.getString(6));
							ressReesForm.setCode_ress(rset.getString(7));
							ressReesForm.setDatarrivee(rset.getString(8));

							ressReesForm.setMsgErreur(null);
						} else
							msg = true;
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("RessReesAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("RessReesAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("RessReesAction-consulter() --> SQLException-rset.close() :"
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
				// le code n'existe pas, on récupère le message
				ressReesForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("RessReesAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("RessReesAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("RessReesAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("RessReesAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((RessReesForm) form).setMsgErreur(message);
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

	// consulter

	/**
	 * Action qui permet de créer une nouvelle ressource
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String codsg;
		String signatureMethode = "RessReesAction-creer(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
		// Création d'une nouvelle form
		RessReesForm ressReesForm = (RessReesForm) form;
		ressReesForm.setIdent(null);
		ressReesForm.setIdent_choisi(null);

		logService.exit(signatureMethode);

		return mapping.findForward("ecran");
	}// fin creer

	/**
	 * Method valider Action qui permet d'enregistrer les données pour la
	 * création, modification, suppression
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
		RessReesForm ressReesForm = (RessReesForm) form;
		ressReesForm.setIdent(null);
		ressReesForm.setIdent_choisi(null);
		  return suite(mapping, form, request, response, errors, hParamProctest);

	}// valider

	/**
	 * Action qui permet de passer à la page première page avec destruction du
	 * tableau en session
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		HttpSession session = request.getSession(false);

		String signatureMethode = "RessRessAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On détruit le tableau sauvegardé en session
		session.removeAttribute(RESSREES);
		logBipUser.debug("Destruction de la liste des ressources en session");

		logBipUser.exit(signatureMethode);

		 return mapping.findForward("initial");
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

	/*
	 * Fonction réinitialisant le réestimé d'une ressource suivant la
	 * répartition saisie
	 */
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut1 = new Vector();
		Vector vParamOut2 = new Vector();
		Vector vParamOut3 = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut = null;
		Vector vListe = new Vector();
		PaginationVector vueListe;
		HttpSession session = request.getSession(false);
		Vector vParamOut = new Vector();

		String signatureMethode = "RessReesAction-initialiser()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());

		RessReesForm bipForm = ((RessReesForm) form);

		if (hParamProc == null) {
			logBipUser.debug(signatureMethode + "-->hParamProc is null");
		}

		// ******* exécution de la procédure PL/SQL pour réinitialiser
		try {
			vParamOut1 = jdbc.getResult(
					hParamProc, configProc, PACK_INIT);
			try {
				message = jdbc.recupererResult(vParamOut1, "valider");
			} catch (BaseException be) {
				logBipUser.debug(signatureMethode
						+ " --> Problème pour récupérer le message.");
				logBipUser
						.debug(signatureMethode + " --> BaseException :" + be);
				logBipUser.debug(signatureMethode + ") --> Exception :"
						+ be.getInitialException().getMessage());
				logService
						.debug(signatureMethode + " --> BaseException :" + be);
				logService.debug(signatureMethode + ") --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on récupère le message
				msg = true;
				bipForm.setMsgErreur(message);
				logBipUser.debug(signatureMethode + " -->message :" + message);

			}

		} catch (BaseException be) {
			logBipUser
					.debug(signatureMethode + " --> BaseException :" + be, be);
			logBipUser.debug(signatureMethode + " --> Exception :"
					+ be.getInitialException().getMessage());
			logService
					.debug(signatureMethode + " --> BaseException :" + be, be);
			logService.debug(signatureMethode + " --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {

				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((RessReesForm) form).setMsgErreur(message);

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} 
		
		logBipUser.debug("fmemory end : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);

		//  jdbc.closeJDBC(); return mapping.findForward("suite");
		 jdbc.closeJDBC(); return suite(mapping, form, request, response, errors, hParamProc);

	}// fin initialiser

	// refresh
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		RessReesForm bipForm = (RessReesForm) form;
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		String message = "";

		try {
			// On sauvegarde les données du formulaire
			savePage(mapping, form, request, response, errors);
			if (bipForm.getChoix().equals("h")) {
				bipForm.setCode_ress(bipForm.getIdent_hors());
				hParamProc.put("ident", bipForm.getIdent_hors());
				hParamProc.put("choix", bipForm.getChoix());
				bipForm.setFocus("datarrivee");
			}
			if (bipForm.getChoix().equals("g")) {
				hParamProc.put("ident", bipForm.getCode_ress());
				hParamProc.put("choix", bipForm.getChoix());
				bipForm.setFocus("datarrivee");
			}
			if (bipForm.getChoix().equals("f")) {
				hParamProc.put("ident", "0");
				hParamProc.put("choix", bipForm.getChoix());
				bipForm.setFocus("rnom");
			}
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_DONNEES);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
					if ((message != null) && (!"".equals(message))) {
						message = BipException
								.getMessageFocus(message, bipForm);
						bipForm.setMsgErreur(message);
						 jdbc.closeJDBC(); return mapping.findForward("suite");
					}
				}

				// récupérer le nom
				if (paramOut.getNom().equals("rnom")) {
					bipForm.setRnom((String) paramOut.getValeur());
				}

				// récupérer le prenom
				if (paramOut.getNom().equals("rprenom")) {
					// bipForm.setRprenom((String)((ParametreProc)vParamOut.elementAt(1)).getValeur());
					bipForm.setRprenom((String) paramOut.getValeur());
				}

				// récupérer la date de depart
				if (paramOut.getNom().equals("date")) {
					bipForm.setDatdep((String) paramOut.getValeur());
				}
				if (paramOut.getNom().equals("choix_retour")) {
					bipForm.setChoix((String) paramOut.getValeur());
				}
				bipForm.setTitrePage("Créer");
				bipForm.setMode("insert");

			}// for
		} catch (BaseException be) {
			logBipUser.debug("RessReesAction-refresh() --> BaseException :"
					+ be, be);
			logBipUser.debug("RessReesAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("RessReesAction-refresh() --> BaseException :"
					+ be, be);
			logService.debug("RessReesAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));

			// this.saveErrors(request,errors);
			 jdbc.closeJDBC(); return mapping.findForward("suite");
		}

		
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}
	// fin refresh
}