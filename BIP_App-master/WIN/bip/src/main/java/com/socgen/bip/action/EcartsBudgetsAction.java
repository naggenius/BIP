package com.socgen.bip.action;

import java.io.IOException;
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
import com.socgen.bip.form.EcartsBudgetsForm;
import com.socgen.bip.metier.EcartBudgetPole;
import com.socgen.bip.metier.EcartsBudgets;
import com.socgen.bip.metier.MessageEcartsBudgets;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author DSIC/SUP Equipe Bip
 * @author D.DEDIEU
 * 
 * Action struts g�rant les �carts budg�taires des saisies
 */
public class EcartsBudgetsAction extends AutomateAction {
	private static String PACK_SELECT_TRAITEMENT = "ecarts.budgets.traitement.proc";

	private static String PACK_SELECT_LISTE = "ecarts.budgets.liste.proc";

	private static String PACK_SELECT_ECART_POLE = "ecarts.budgets.listepole.proc";

	private static String PACK_UPDATE = "ecarts.budgets.modifier.proc";

	private static String PACK_CREER = "ecarts.budgets.creer.proc";

	private int blocksize = 10;
	
	

	/**
	 * Constructeur Aucun traitement
	 */
	public EcartsBudgetsAction() {
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

		EcartsBudgetsForm automateForm = (EcartsBudgetsForm) form;

		// Extraction de la valeur action
		action = automateForm.getAction();

		// Extraction du nom de la page
		String pageName = (String) request.getParameter("page");

		logService.entry("D�but Action  = " + action);

		// Actions pour les listes multi-pages
		if (PAGE_INDEX.equals(action)) {

			if (ECARTSBUDGETS.equals(pageName)) {
				savePage(mapping, form, request, response, errors);
				actionForward = pageIndex(mapping, form, request, response,
						errors);
			} else
				actionForward = pageIndexpole(mapping, form, request, response,
						errors);
		}

		if (PAGE_SUIVANTE.equals(action)) {
			if (ECARTSBUDGETS.equals(pageName)) {
				savePage(mapping, form, request, response, errors);
				actionForward = pageSuivante(mapping, form, request, response,
						errors);
			} else {
				actionForward = pageSuivantepole(mapping, form, request,
						response, errors);
			}
		}
		if (PAGE_PRECEDENTE.equals(action)) {
			if (ECARTSBUDGETS.equals(pageName)) {
				savePage(mapping, form, request, response, errors);
				actionForward = pagePrecedente(mapping, form, request,
						response, errors);
			} else {
				actionForward = pagePrecedentepole(mapping, form, request,
						response, errors);
			}
		}

		// Actions courantes
		if (ACTION_ANNULER.equals(action)) {
			actionForward = annuler(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_SUITE.equals(action)) {
			actionForward = suite(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_CREER.equals(action)) {
			// on sauvegarde le titre de la page
			automateForm.setTitrePage("Cr�er");
			automateForm.setMode("insert");
			actionForward = creer(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_MODIFIER.equals(action)) {
			// on sauvegarde le titre de la page
			automateForm.setTitrePage("Modifier");
			automateForm.setMode("update");
			actionForward = consulter(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_SUPPRIMER.equals(action)) {
			// on sauvegarde le titre de la page
			automateForm.setTitrePage("Supprimer");
			automateForm.setMode("delete");
			actionForward = consulter(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_VALIDER.equals(action)) {
			sMode = automateForm.getMode();
			actionForward = valider(mapping, form, sMode, request, response,
					errors, hParamProc);
		} else if (ACTION_REFRESH.equals(action)) {
			// On recharge la m�me page(ecran)
			actionForward = refresh(mapping, form, request, response, errors,
					hParamProc);
		} else if (ACTION_INIT.equals(action)) {
			// On recharge la m�me page(ecran)
			actionForward = initialiser(mapping, form, request, response,
					errors, hParamProc);
		}

		// Action qui indique qu'il ne faut rien faire et qu'il faut retourner
		// null
		// Cela sert lorsqu'un fichier est retourn� et qu'il ne faut pas faire
		// de forward
		if (PAS_DE_FORWARD.equals(actionForward)) {
			return null;
		}
		// Pas d'action renseign�e, on renvoie vers la page d'erreur.
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

	/**
	 * Action qui permet initialiser la premiere page des ecarts
	 */
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
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

		String signatureMethode = "EcartsBudgetsAction-initialiser(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		// Cr�ation d'une nouvelle form
		EcartsBudgetsForm ecartsBudgetsForm = (EcartsBudgetsForm) form;

		// On ex�cute la proc�dure PL/SQL qui ram�ne les donn�es du taitement
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_TRAITEMENT);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {

					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							ecartsBudgetsForm.setNumtrait(rset.getString(1));
							ecartsBudgetsForm.setMsgtrait(rset.getString(2));
							ecartsBudgetsForm.setNexttrait(rset.getString(3));
						}
						if (rset != null)
							rset.close();
					} // try
					catch (SQLException sqle) {
						logService
								.debug("EcartsBudgets-suite() |tableau| --> SQLException :"
										+ sqle);
						logBipUser
								.debug("EcartsBudgets-suite() |tableau| --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			} // for
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"EcartsBudgets-initialiser() |tableau| --> BaseException :"
							+ be, be);
			logBipUser
					.debug("EcartsBudgets-initialiser() |tableau| --> Exception :"
							+ be.getInitialException().getMessage());
			logService.debug(
					"EcartsBudgets-initialiser() |tableau| --> BaseException :"
							+ be, be);
			logService
					.debug("EcartsBudgets-initialiser() |tableau| --> Exception :"
							+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((EcartsBudgetsForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} // fin de select_traitement

		 jdbc.closeJDBC(); return mapping.findForward("initial");

	}// init

	/**
	 * Action qui permet de recup�rer et d'afficher la liste des �carts
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

		String signatureMethode = "EcartsBudgetsAction-suite(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Cr�ation d'une nouvelle form
		EcartsBudgetsForm ecartsBudgetsForm = (EcartsBudgetsForm) form;

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
							// On alimente le Bean et on stocke les donn�es dans
							// un vector
							vListe.add(new EcartsBudgets(rset.getString(1),
									rset.getString(2), rset.getString(3), rset
											.getString(4), rset.getString(5),
									rset.getString(6), rset.getString(7), rset
											.getString(8), rset.getString(9),
									rset.getString(10), rset.getString(11),
									rset.getString(12)));
						}
						if (rset != null)
							rset.close();
					} // try
					catch (SQLException sqle) {
						logService
								.debug("EcartsBudgets-suite() |tableau| --> SQLException :"
										+ sqle);
						logBipUser
								.debug("EcartsBudgets-suite() |tableau| --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			} // for
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"EcartsBudgets-suite() |tableau| --> BaseException :" + be,
					be);
			logBipUser.debug("EcartsBudgets-suite() |tableau| --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"EcartsBudgets-suite() |tableau| --> BaseException :" + be,
					be);
			logService.debug("EcartsBudgets-suite() |tableau| --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((EcartsBudgetsForm) form).setMsgErreur(message);
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
		(request.getSession(false)).setAttribute(ECARTSBUDGETS, vueListe);
		// Stocker le r�sultat dans le formulaire
		ecartsBudgetsForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");

	}// suite

	/**
	 * Action qui permet de cr�er un message
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut;
		ParametreProc paramOut;
		String message;

		String codsg;
		String gnom;
		Vector vmessage = new Vector();

		EcartsBudgetsForm automateForm = (EcartsBudgetsForm) form;

		codsg = automateForm.getCodsg();
		gnom = automateForm.getGnom();

		// On ex�cute la proc�dure PL/SQL qui ram�ne les r�sultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_CREER);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {

					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							// On alimente le Bean et on le stocke dans un
							// vector
							vmessage.add(rset.getString(1));
						}
						if (rset != null)
							rset.close();
					} // try
					catch (SQLException sqle) {
						logService
								.debug("EcartsBudgets-creer() |tableau| --> SQLException :"
										+ sqle);
						logBipUser
								.debug("EcartsBudgets-creer() |tableau| --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			} // for
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"EcartsBudgets-creer() |tableau| --> BaseException :" + be,
					be);
			logBipUser.debug("EcartsBudgets-creer() |tableau| --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"EcartsBudgets-creer() |tableau| --> BaseException :" + be,
					be);
			logService.debug("EcartsBudgets-creer() |tableau| --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((EcartsBudgetsForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}

		MessageEcartsBudgets msg = new MessageEcartsBudgets(codsg, gnom,
				vmessage);

		// Stocker le r�sultat dans la session
		(request.getSession(false)).setAttribute(MESSAGEECARTSBUDGETS, msg);

		 jdbc.closeJDBC(); return mapping.findForward("message");
	} // creer

	/**
	 * Action qui permet de recupere la liste des groupes avec le nombre
	 * d'�carts
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
		Vector vListe = new Vector();
		PaginationVector vueListe;

		String signatureMethode = "EcartsBudgetsAction-consulter(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Cr�ation d'une nouvelle form
		EcartsBudgetsForm ecartsForm = (EcartsBudgetsForm) form;

		hParamProc.put("P_global", userBip.getInfosUser());

		// On ex�cute la proc�dure PL/SQL qui ram�ne les r�sultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_ECART_POLE);

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							// On alimente le Bean et on stocke les donn�es dans
							// un vector
							vListe.add(new EcartBudgetPole(rset.getString(1),
									rset.getString(2), rset.getString(3), rset
											.getString(4)));
						}
						if (rset != null)
							rset.close();
					} // try
					catch (SQLException sqle) {
						logService
								.debug("EcartsBudgets-suite() |tableau| --> SQLException :"
										+ sqle);
						logBipUser
								.debug("EcartsBudgets-suite() |tableau| --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			} // for
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"EcartsBudgets-suite() |tableau| --> BaseException :" + be,
					be);
			logBipUser.debug("EcartsBudgets-suite() |tableau| --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"EcartsBudgets-suite() |tableau| --> BaseException :" + be,
					be);
			logService.debug("EcartsBudgets-suite() |tableau| --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((EcartsBudgetsForm) form).setMsgErreur(message);
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
		(request.getSession(false)).setAttribute(ECARTBUDGETPOLE, vueListe);
		// Stocker le r�sultat dans le formulaire
		ecartsForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("suite");
	} // consulter

	/**
	 * M�thode valider : Met � jour le type de validation et le commentaire des
	 * �carts
	 */
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		String annee;
		String pid;
		String type;
		String valide;
		String commentaire;
		String code_activite;

		StringBuffer sbChaine = new StringBuffer();
		HttpSession session = request.getSession(false);
		Class[] parameterString = {};
		Object oRees;
		String signatureMethode = "EcartsBudgetsAction-valider()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		try {

			// On sauvegarde les donn�es du formulaire
			savePage(mapping, form, request, response, errors);

			PaginationVector page = (PaginationVector) session
					.getAttribute(ECARTSBUDGETS);

			// On construit la cha�ne qui doit �tre pass� en param�tre de la
			// forme
			// :annee;pid;type;valide;commentaire:
			EcartsBudgetsForm bipForm = ((EcartsBudgetsForm) form);

			int i = 0;
			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				EcartsBudgets ecart = (EcartsBudgets) e.nextElement();
				i++;

				annee = ecart.getAnnee();
				pid = ecart.getPid();
				type = ecart.getType();
				valide = ecart.getValide();
				commentaire = ecart.getCommentaire();

				sbChaine = new StringBuffer(":" + annee + ";" + pid + ";"
						+ type + ";" + valide + ";" + commentaire + ":");

				// Ajouter la chaine dans la hashtable des param�tres
				hParamProc.put("string", sbChaine.toString());

				// on ex�cute la procedure PLSQL qui met � jour les propos�s
				try {
					vParamOut = jdbc.getResult(
							hParamProc, configProc, PACK_UPDATE);
					
				} // try
				catch (BaseException be) {
					logBipUser.debug(
							"EcartsBudgetsAction-valider() --> BaseException :"
									+ be, be);
					logBipUser
							.debug("EcartsBudgetsAction-valider() --> Exception :"
									+ be.getInitialException().getMessage());
					logService.debug(
							"EcartsBudgetsAction-valider() --> BaseException :"
									+ be, be);
					logService
							.debug("EcartsBudgetsAction-valider() --> Exception :"
									+ be.getInitialException().getMessage());
					if (be.getInitialException().getClass().getName().equals(
							"java.sql.SQLException")) {
						message = BipException.getMessageFocus(BipException
								.getMessageOracle(be.getInitialException()
										.getMessage()), form);
						((EcartsBudgetsForm) form).setMsgErreur(message);
						 jdbc.closeJDBC(); return mapping.findForward("ecran");
					} else {
						// Erreur d'ex�cution de la proc�dure stock�e
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11201"));
						request.setAttribute("messageErreur", be
								.getInitialException().getMessage());
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				}
				// annuler la mise � jour
				if (vParamOut == null) {
					session.setAttribute("errorUpdate", "UPDATE");
					logBipUser.debug("!!! update cancelled ");
				}

			} // for

			// On d�truit le tableau sauvegard� en session
			session.removeAttribute(ECARTSBUDGETS);
			logBipUser.debug("Destruction de la liste des �carts");

		} catch (Exception e) {
			logBipUser.debug(signatureMethode + " --> exception : "
					+ e.getMessage());
			// Erreur d''ex�cution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}
		// probleme de memoire
		// hParamProc = null;
		logBipUser.debug("fmemory end : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("annuler");

	} // valider

	/**
	 * Action qui permet de passer � la page premi�re page avec reconstitution
	 * du menu
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		HttpSession session = request.getSession(false);
		String signatureMethode = "EcartsAction-annuler()";
		logBipUser.entry(signatureMethode);
		// On d�truit le tableau sauvegard� en session
		session.removeAttribute(ECARTBUDGETPOLE);
		session.removeAttribute(ECARTSBUDGETS);
		logBipUser
				.debug("Destruction de la liste des consos/r�estim�s en session");

		EcartsBudgetsForm bipForm = ((EcartsBudgetsForm) form);

		bipForm.setCodsg("");
		bipForm.setMsgErreur("");

		logBipUser.exit(signatureMethode);
		

		return mapping.findForward("annuler");
	}

	/**
	 * M�thode savePage : Sauvegarde des �carts
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {

		HttpSession session = request.getSession(false);
		PaginationVector page = (PaginationVector) session
				.getAttribute(ECARTSBUDGETS);
		String libAnnee;
		String libPid;
		String libType;
		String libValide;
		String libCommentaire;
		String a, b, c, d, ee, f;
		Class[] parameterString = { String.class };
		String signatureMethode = "EcartsRees-savePage()";
		logBipUser.entry(signatureMethode);

		// Sauvegarde du total par mois de la page pr�c�dente
		EcartsBudgetsForm bipForm = ((EcartsBudgetsForm) form);

		try {
			// r�cup�rer les champs modifiables
			for (int i = 1; i <= blocksize; i++) {

				libAnnee = "lib_annee_" + i;
				libPid = "lib_pid_" + i;
				libType = "lib_type_" + i;
				libValide = "lib_valide_" + i;
				libCommentaire = "lib_commentaire_" + i;

				for (Enumeration e = page.elements(); e.hasMoreElements();) {

					EcartsBudgets ecart = (EcartsBudgets) e.nextElement();

					if (request.getParameter(libAnnee) != null) {

						a = request.getParameter(libAnnee);
						b = ecart.getAnnee();

						c = request.getParameter(libPid);
						d = ecart.getPid();

						ee = request.getParameter(libType);
						f = ecart.getType();

						if ((request.getParameter(libAnnee)).equals(ecart
								.getAnnee())
								&& (request.getParameter(libPid)).equals(ecart
										.getPid())
								&& (request.getParameter(libType)).equals(ecart
										.getType())) {

							if (request.getParameter(libValide) == null) {
								// On met � jour le type de vaildation et le
								// commentaire pour le type N
								ecart.setValide("N");
								ecart.setCommentaire(request
										.getParameter(libCommentaire));
							} else {
								// On met � jour le type de vaildation et le
								// commentaire pour le type O
								ecart.setValide("O");
								ecart.setCommentaire(request
										.getParameter(libCommentaire));
							}

						}// if
					}

				} // for
			} // for
		} catch (NullPointerException npe) {
			logBipUser.debug("EcartsAction-savePage-->!!! valeur null dans : "
					+ npe.getMessage());
			// Erreur d''ex�cution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (SecurityException se) {
			// Erreur d''ex�cution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (IllegalArgumentException iae) {
			logBipUser.debug("arguments null : " + iae.getMessage());
			// Erreur d''ex�cution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}

		(request.getSession()).setAttribute(ECARTSBUDGETS, page);

		logBipUser.exit(signatureMethode);

	} // savePage

	/**
	 * cette Action est utilis�e pour le pagination ECARTBUDGETPOLE Method
	 * pageIndexpole.
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @ jdbc.closeJDBC(); return ActionForward
	 * @throws ServletException
	 */
	protected ActionForward pageIndexpole(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors)
			throws ServletException {
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
	 * cette est utilis�e pour le pagination ECARTBUDGETPOLE Action envoy�e pour
	 * passer � la page suivante
	 * 
	 * @param request
	 *            la requ�te HTTP.
	 * @param response
	 *            la r�ponse HTTP.
	 */
	protected ActionForward pageSuivantepole(ActionMapping mapping,
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
	 * cette est utilis�e pour le pagination ECARTBUDGETPOLE Action envoy�e pour
	 * passer � la page pr�c�dente
	 * 
	 * @param request
	 *            la requ�te HTTP.
	 * @param response
	 *            la r�ponse HTTP.
	 */
	protected ActionForward pagePrecedentepole(ActionMapping mapping,
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
}
