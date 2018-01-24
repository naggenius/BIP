package com.socgen.bip.commun.action;

import java.io.IOException;
import java.lang.reflect.Method;
import java.sql.SQLException;
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

import com.socgen.bip.commun.BipConfigRTFE;
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.LigneBipForm;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author RSRH/ICH/GMO Equipe Bip
 * @author N/BACCAM 25/04/2003
 * 
 *         Action générique pour les pages de mises à jour de la BIP
 */
public class AutomateAction extends BipAction {
	/**
	 * Référence sur la log de la couche ihm qui sera initalisé par le
	 */
	// protected static Log logService =
	// ServiceManager.getInstance().getLogManager().getLogService();
	// Initialise la variable config à pointer sur le fichier properties sql
	protected static Config configProc = ConfigManager.getInstance(BIP_PROC);
	private static String PACK_INITIALISE_LIGNE2 = "lignebip.intial.ligne2.proc";

	/**
	 * Constructor for AutomateAction.
	 */
	public AutomateAction() {
		super();
	}

	/**
	 * @see org.apache.struts.action.Action#perform(ActionMapping, ActionForm,
	 *      HttpServletRequest, HttpServletResponse)
	 */
	public ActionForward bipPerform(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			Hashtable hParamProc) throws IOException, ServletException {
		ActionForward actionForward = null;
		HttpSession session = request.getSession(false);

		String action = null;
		String sMode = null;

		AutomateForm automateForm = (AutomateForm) form;

		// Extraction de la valeur action
		action = automateForm.getAction();

		logService.entry("Début Action  = " + action);

		// Actions pour les listes multi-pages
		if (PAGE_INDEX.equals(action)) {
			savePage(mapping, form, request, response, errors);
			actionForward = pageIndex(mapping, form, request, response, errors);
		}

		else if (PAGE_SUIVANTE.equals(action)) {
			savePage(mapping, form, request, response, errors);
			actionForward = pageSuivante(mapping, form, request, response,
					errors);
		} else if (PAGE_PRECEDENTE.equals(action)) {
			savePage(mapping, form, request, response, errors);
			actionForward = pagePrecedente(mapping, form, request, response,
					errors);
		}
		// Actions courantes
		else if (ACTION_ANNULER.equals(action)) {
			actionForward = annuler(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_SUITE.equals(action)) {
			actionForward = suite(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_SUITE_1.equals(action)) {
			actionForward = suite1(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_CREER.equals(action)) {
			// on sauvegarde le titre de la page
			automateForm.setTitrePage("Créer");
			automateForm.setMode("insert");
			String message = initialiserLigneAxeMetier2(mapping, form, request,
					response, errors, hParamProc);
			request.setAttribute("messageInit", message);
			actionForward = creer(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_MODIFIER.equals(action)) {
			// on sauvegarde le titre de la page
			automateForm.setTitrePage("Modifier");

			if ("insert".equalsIgnoreCase(automateForm.getMode())) {
				String message = initialiserLigneAxeMetier2(mapping, form,
						request, response, errors, hParamProc);
				request.setAttribute("messageInit", message);
				request.setAttribute("title", "TITLE");

			}
			automateForm.setMode("update");
			actionForward = consulter(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_SUPPRIMER.equals(action)) {
			// on sauvegarde le titre de la page
			automateForm.setTitrePage("Supprimer");
			automateForm.setMode("delete");
			if ("profilsDomFoncForm".equals(mapping.getName())
					|| "profilsLocalizeForm".equals(mapping.getName())) {
				sMode = automateForm.getMode();
				actionForward = valider(mapping, form, sMode, request,
						response, errors, hParamProc);
			} else {
				actionForward = consulter(mapping, form, request, response,
						errors, hParamProc);
			}

		} else if (ACTION_VALIDER.equals(action)) {
			sMode = automateForm.getMode();
			actionForward = valider(mapping, form, sMode, request, response,
					errors, hParamProc);
		} else if (ACTION_REFRESH.equals(action)) {
			// On recharge la même page(ecran)
			actionForward = refresh(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_INIT.equals(action)) {
			// On recharge la même page(ecran)
			actionForward = initialiser(mapping, form, request, response,
					errors, hParamProc);
		} else if (ACTION_RETOUR.equals(action)) {
			// On recharge la même page(ecran)
			actionForward = retour(mapping, form, request, response, errors,
					hParamProc);
		} else if ((action != null) && (action.length() > 0)) {
			// Si l'action n'est pas définie précedemment on recherche s'il
			// existe une méthode correspondante
			// càd avec le même nom
			try {
				// liste des types des paramètres de la méthode recherchée ce
				// sont les mêmes que n'importe quelle
				// méthode action
				Class partypes[] = new Class[6];
				partypes[0] = ActionMapping.class;
				partypes[1] = ActionForm.class;
				partypes[2] = HttpServletRequest.class;
				partypes[3] = HttpServletResponse.class;
				partypes[4] = ActionErrors.class;
				partypes[5] = Hashtable.class;

				// liste des objets à passer en paramètre à la fonction
				Object arglist[] = new Object[6];
				arglist[0] = mapping;
				arglist[1] = form;
				arglist[2] = request;
				arglist[3] = response;
				arglist[4] = errors;
				arglist[5] = hParamProc;

				// Recherche de la fonction
				Method meth = this.getClass().getDeclaredMethod(action,
						partypes);

				// Appel de la fonction
				Object retobj = meth.invoke((Object) this, arglist);

				// Récupération de l'objet retourné
				actionForward = (ActionForward) retobj;

			} catch (NoSuchMethodException e) {
				logBipUser.error("La méthode <" + action
						+ "> correspondant à l'action <" + action
						+ "> est introuvable dans la classe <"
						+ this.getClass().getName() + ">.");
			} catch (Throwable e) {
				logBipUser.debug("Erreur lors de la reflexion : "
						+ e.toString());
				logBipUser.debug("Erreur lors de la reflexion : "
						+ e.getMessage());
				logBipUser.debug("Erreur lors de la reflexion : "
						+ e.getLocalizedMessage());
			}
		}

		// Action qui indique qu'il ne faut rien faire et qu'il faut retourner
		// null
		// Cela sert lorsqu'un fichier est retourné et qu'il ne faut pas faire
		// de forward
		if (PAS_DE_FORWARD.equals(actionForward)) {
			return null;
		}
		// Pas d'action renseignée, on renvoie vers la page d'erreur.
		else if (actionForward == null) {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.action.inconnue", action));
			logService.error("l'action [" + action + "] est inconnue");
			return mapping.findForward("error");
		} else {
			logService.exit("Fin Action  = " + action);
			return actionForward;
		}
	}// perform

	// BIP 29 - initilaising the ligne axemetier2
	public String initialiserLigneAxeMetier2(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws IOException {
		String signatureMethode = "LigneAction - initialiserLigneAxeMetier";
		// user story BIP 29
		JdbcBip jdbc = new JdbcBip();
		Vector vParamOut = new Vector();
		String message = "";
		String msg = "";
		try {

			vParamOut = jdbc.getResult(hParamProc, configProc,
					PACK_INITIALISE_LIGNE2);
			// ----------------------------------------------------------
			msg = (String) (((ParametreProc) vParamOut.elementAt(0))
					.getValeur());
			// (String) (((ParametreProc) vParamOut.elementAt(0)).getValeur())
			if (msg.equalsIgnoreCase("SUCCESS")) {
				return msg;
			}
		} catch (BaseException be) {
			logBipUser.debug(signatureMethode + " --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(signatureMethode + " --> BaseException :" + be);

			message = BipException.getMessageFocus(BipException
					.getMessageOracle(be.getInitialException().getMessage()),
					form);

			// Erreur de lecture du resultSet
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
			// this.saveErrors(request,errors);
			jdbc.closeJDBC();
		}
		return msg;
	}

	/**
	 * Method pageIndex.
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 *            @ jdbc1.closeJDBC(); return ActionForward
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
			actionForward = mapping.findForward("ecran");

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
			return mapping.findForward("ecran");

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
			return mapping.findForward("ecran");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			return mapping.findForward("error");
		}
	}

	/**
	 * Method creer
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 *            @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
				"error.action.non-implementee"));
		return mapping.findForward("error");
	}// creer

	/**
	 * Method consulter
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 *            @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
				"error.action.non-implementee"));
		return mapping.findForward("error");
	}// consulter

	/**
	 * Method valider Action qui permet d'enregistrer les données pour la
	 * création, modification, suppression d'un code client
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 *            @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 * 
	 */

	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProctest) throws ServletException {
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;

		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);
		// On récupère la clé pour trouver le nom de la procédure stockée dans
		// bip_proc.properties
		cle = recupererCle(mode);

		JdbcBip jdbc1 = new JdbcBip();

		// checking the ligne2 conditions before modifier or create action

		// On exécute la procédure stockée
		try {

			vParamOut = jdbc1.getResult(hParamProctest, configProc, cle);

			try {
				message = jdbc1.recupererResult(vParamOut, "valider");

			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("valider() --> BaseException :" + be);
				logService.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				jdbc1.closeJDBC();
				return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on récupère le message
				((AutomateForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);
			}

		} catch (BaseException be) {

			logService.debug("valider() --> BaseException :" + be);
			logService.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			logBipUser.debug("valider() --> BaseException :" + be);
			logBipUser.debug("valider() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName()
					.equals("java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((AutomateForm) form).setMsgErreur(message);

				if (!mode.equals("delete")) {
					jdbc1.closeJDBC();
					return mapping.findForward("ecran");
				}
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				jdbc1.closeJDBC();
				return mapping.findForward("error");
			}
		}
		// Si l'élément sur lequel on vient de faire une MàJ est un paramètre
		// BIP au code action commençant par RTFE,
		// on recharge le paramétrage RTFE depuis la base.
		String codaction = (String) hParamProctest.get("codaction");
		if (codaction != null && "RTFE".equals(codaction.substring(0, 4))) {
			BipConfigRTFE.getInstance().rechargerConfigRTFE();
		}
		logBipUser.exit(signatureMethode);
		jdbc1.closeJDBC();
		return mapping.findForward("initial");

	}// valider

	/**
	 * Method recupererCle récupère la clé pour le fichier .properties suivant
	 * le mode de mise à jour
	 */
	protected String recupererCle(String mode) {
		return null;
	};

	/**
	 * Method savePage
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 *            @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {

	};

	/**
	 * Method suite
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 *            @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		return mapping.findForward("suite");
	}

	protected ActionForward suite1(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		return mapping.findForward("suite1");
	}

	/**
	 * Method annuler
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 *            @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		return mapping.findForward("initial");
	}

	/**
	 * Method refresh
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 *            @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 */
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		return mapping.findForward("ecran");
	}

	/**
	 * Method initialiser
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 *            @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 */
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		return mapping.findForward("ecran");
	}

	/**
	 * Method initialiser
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 *            @ jdbc1.closeJDBC(); return ActionForward
	 * @throws ServletException
	 */
	protected ActionForward retour(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		return mapping.findForward("ecran");
	}

	/****************************************************************
	 * Error functions
	 **************************************************************** 
	 * 
	 * Methodes prenant en charge les erreurs dans les actions : - Ecriture dans
	 * les logs - Création et save des actionErrors
	 * 
	 * @author x054232
	 */

	/**
	 * 
	 * Traitement BaseException
	 * 
	 * @param BaseException
	 * @param AutomateForm
	 * @param request
	 *            @ jdbc1.closeJDBC(); return page (forward action)
	 */
	public String processBaseException(String className, String methodName,
			BaseException be, AutomateForm form, HttpServletRequest request) {
		logBipUser.debug(className + " - " + methodName + "--> BaseException :"
				+ be, be);
		logBipUser.debug(className + " - " + methodName + " --> Exception :"
				+ be.getInitialException().getMessage());

		if (be.getInitialException().getClass().getName()
				.equals("java.sql.SQLException")) {
			String message = BipException.getMessageFocus(BipException
					.getMessageOracle(be.getInitialException().getMessage()),
					form);
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(message));
			this.saveErrors(request, errors);
			form.setMsgErreur(message);
			return "initial";
		} else {
			// Erreur d''exécution de la procédure stockée
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			this.saveErrors(request, errors);
			request.setAttribute("messageErreur", be.getInitialException()
					.getMessage());
			return "error";
		}
	}

	/**
	 * 
	 * Traitement BaseException
	 * 
	 * @param formulaire
	 * @param BaseException
	 * @param AutomateForm
	 * @param request
	 *            @ return page (forward action)
	 */
	public String processBaseExceptionRecup(String formulaire,
			String className, String methodName, BaseException be,
			AutomateForm form, HttpServletRequest request) {

		logBipUser.debug(className + " - " + methodName + "--> BaseException :"
				+ be, be);
		logBipUser.debug(className + " - " + methodName + " --> Exception :"
				+ be.getInitialException().getMessage());

		if (be.getInitialException().getClass().getName()
				.equals("java.sql.SQLException")) {

			String message = BipException.getMessageFocus(BipException
					.getMessageOracle(be.getInitialException().getMessage()),
					form);

			if (message.substring(0, 4).equals("ORA-")) {
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(message));
				this.saveErrors(request, errors);
			} else
				form.setMsgErreur(message);

			request.setAttribute(formulaire, form);

			return "initial";
		} else {
			// Erreur d''exécution de la procédure stockée
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
			this.saveErrors(request, errors);
			request.setAttribute("messageErreur", be.getInitialException()
					.getMessage());
			return "error";
		}
	}

	/**
	 * general exception
	 * 
	 * @param BaseException
	 * @param AutomateForm
	 * @param request
	 *            @ jdbc1.closeJDBC(); return page (forward action)
	 */
	public String processException(String className, String methodName,
			Exception exception, AutomateForm form, HttpServletRequest request) {
		logBipUser.debug(className + " - " + methodName
				+ "--> BusinessException :" + exception.getMessage());
		errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("10000"));
		this.saveErrors(request, errors);
		form.setMsgErreur(exception.getMessage());
		return "error";
	}

	/**
	 * @param technic
	 *            exception
	 * @param Exception
	 * @param form
	 * @param request
	 * 
	 *            @ jdbc1.closeJDBC(); return page Forward
	 */
	public String processTechnicException(String className, String methodName,
			Exception exception, AutomateForm form, HttpServletRequest request) {
		logBipUser.debug(className + " - " + methodName + "--> Technic Error :"
				+ exception.getMessage());
		errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11000"));
		this.saveErrors(request, errors);
		form.setMsgErreur(exception.getMessage());
		return "error";
	}

	/**
	 * @param technic
	 *            exception
	 * @param form
	 * @param request
	 *            @ jdbc1.closeJDBC(); return
	 */
	public String processSsimpleException(String className, String methodName,
			Exception exception, AutomateForm form, HttpServletRequest request) {
		logBipUser.debug(className + "." + methodName, exception);
		logService.debug(className + "." + methodName, exception);
		errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11000"));
		this.saveErrors(request, errors);
		form.setMsgErreur(exception.getMessage());
		return "error";
	}

	/**
	 * @param User
	 *            error
	 * @param form
	 * @param request
	 *            @ jdbc1.closeJDBC(); return
	 */
	public String processUserError(String message, AutomateForm form,
			HttpServletRequest request) {
		errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11000"));
		this.saveErrors(request, errors);
		form.setMsgErreur(message);
		return "initial";
	}

	/**
	 * @param SQL
	 *            Exception
	 * @param form
	 * @param request
	 *            @ jdbc1.closeJDBC(); return
	 */
	public String SqlException(String className, String methodName,
			SQLException sqle, AutomateForm form, HttpServletRequest request) {
		logService.debug(className + " - " + methodName + "--> SQLException :"
				+ sqle);
		logBipUser.debug(className + " - " + methodName + "--> SQLException :"
				+ sqle);
		errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
		this.saveErrors(request, errors);
		return "error";
	}

}
