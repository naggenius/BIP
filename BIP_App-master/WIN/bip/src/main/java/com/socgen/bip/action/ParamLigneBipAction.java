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
import com.socgen.bip.commun.liste.ListeOption;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ParamLigneBipForm;
import com.socgen.bip.metier.Libelle;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author X059413
 * 
 * 
 * chemin : Ligne BIP / Paramètrage pages : fParamLigneBip.jsp pl/sql :
 */
public class ParamLigneBipAction extends AutomateAction {

	private static String PACK_SELECT_LIBELLE = "lignebipmod.consulter.proc";

	private static String PACK_SELECT_TYPE = "lignebiptype.consulter.proc";

	private static String PACK_UPDATE_SELECTION = "lignebipsel.modifier.proc";

	private static String PACK_UPDATE_LIBELLE = "lignebipmod.modifier.proc";

	private static String PACK_UPDATE_TYPE = "lignebiptype.modifier.proc";

	private static String PACK_TABLEAU = "plignebip.tableau.proc";

	private static String PACK_TOTAL = "plignebip.total.proc";

	private int blocksize = 15;
	
	

	/**
	 * Action qui permet de visualiser les données liées à un code activite et
	 * DPG pour la modification et la suppression
	 */

	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String codsg;
		String signatureMethode = "ParamLigneBipAction-creer(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
		// Création d'une nouvelle form
		ParamLigneBipForm activiteForm = (ParamLigneBipForm) form;
		// activiteForm.setCode_activite(null);
		// activiteForm.setCode_activite_choisi(null);

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

		String signatureMethode = "ParamLigneBipAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On détruit le tableau sauvegardé en session
		session.removeAttribute(ACTIVITE);
		logBipUser.debug("Destruction de la liste des activites en session");

		logBipUser.exit(signatureMethode);

		 return mapping.findForward("initial");
	}

	/**
	 * Action qui permet de passer à la page première page avec destruction du
	 * tableau en session
	 */
	protected ActionForward defaut(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		HttpSession session = request.getSession(false);

		String signatureMethode = "ParamLigneBipAction-defaut( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On détruit le tableau sauvegardé en session
		session.removeAttribute(ACTIVITE);
		logBipUser.debug("Destruction de la liste des activites en session");

		logBipUser.exit(signatureMethode);

		return mapping.findForward("defaut");
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

		String type_action;

		ParamLigneBipForm paramForm = (ParamLigneBipForm) form;

		type_action = paramForm.getType_action();

		if (type_action.equals("valider_selection"))
		{	
			  return valider_selection(mapping, form, mode, request, response,
					errors, hParamProctest);
		}

		else if (type_action.equals("valider_libelle"))
		{	
			 return valider_libelle(mapping, form, mode, request, response,
					errors, hParamProctest);
		}	 

		else if (type_action.equals("valider_type"))
		{	
			 return valider_type(mapping, form, mode, request, response, errors,
					hParamProctest);
		}

		else if (type_action.equals("defaut"))
		{
			return defaut(mapping, form, request, response, errors,
					hParamProctest);
		}

		return mapping.findForward("ecran");

	}// valider

	protected ActionForward valider_selection(ActionMapping mapping,
			ActionForm form, String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		String cle;
		String libelle;
		String[] aListe;
		ListeOption listeOption;
		int j = 0;

		StringBuffer sbChaine = new StringBuffer();
		HttpSession session = request.getSession(false);
		Class[] parameterString = {};
		Object oRees;
		String signatureMethode = "ParamLigneBipModAction-valider()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		try {

			// On construit la chaîne qui doit être passé en paramètre de la
			// forme
			// :cdeb;ident;type;valide;commentaire:
			ParamLigneBipForm bipForm = ((ParamLigneBipForm) form);

			aListe = bipForm.getChampselect();

			// int i = 0;

			sbChaine = new StringBuffer(":");

			for (int k = 0; k < aListe.length; k++)
				sbChaine = sbChaine.append(aListe[k] + ";" + k + ":");

			// Ajouter la chaine dans la hashtable des paramètres
			hParamProc.put("string", sbChaine.toString());

			// on exécute la procedure PLSQL qui met à jour les proposés
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_UPDATE_SELECTION);
			} // try
			catch (BaseException be) {
				logBipUser.debug(
						"ParamLigneBipAction-valider() --> BaseException :"
								+ be, be);
				logBipUser
						.debug("ParamLigneBipAction-valider() --> Exception :"
								+ be.getInitialException().getMessage());
				logService.debug(
						"ParamLigneBipAction-valider() --> BaseException :"
								+ be, be);
				logService
						.debug("ParamLigneBipAction-valider() --> Exception :"
								+ be.getInitialException().getMessage());
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((ParamLigneBipForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("ecran");
				} else {
					// Erreur d'exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					request.setAttribute("messageErreur", be
							.getInitialException().getMessage());
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}
			// annuler la mise à jour
			if (vParamOut == null) {
				session.setAttribute("errorUpdate", "UPDATE");
				logBipUser.debug("!!! update cancelled ");
			}

			// On détruit le tableau sauvegardé en session
			session.removeAttribute(PARAM_LIGNE_BIP);
			logBipUser.debug("Destruction de la liste des libellés");

		} catch (Exception e) {
			logBipUser.debug(signatureMethode + " --> exception : "
					+ e.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}
		// probleme de memoire
		// hParamProc = null;
		logBipUser.debug("fmemory end : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("initial");

	} // valider_selection

	/**
	 * Method valider Action qui permet d'enregistrer les données pour la
	 * création, modification, suppression d'un code client
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @return ActionForward
	 * @throws ServletException
	 * 
	 */

	/**
	 * Méthode valider : Met à jour le type de validation et le commenatire des
	 * écarts
	 */
	protected ActionForward valider_libelle(ActionMapping mapping,
			ActionForm form, String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {

		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		String cle;
		String libelle;

		StringBuffer sbChaine = new StringBuffer();
		HttpSession session = request.getSession(false);
		Class[] parameterString = {};
		Object oRees;
		String signatureMethode = "ParamLigneBipModAction-valider()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		try {

			// On sauvegarde les données du formulaire
			savePage(mapping, form, request, response, errors);

			PaginationVector page = (PaginationVector) session
					.getAttribute(PARAM_LIGNE_BIP);

			// On construit la chaîne qui doit être passé en paramètre de la
			// forme
			// :cdeb;ident;type;valide;commentaire:
			ParamLigneBipForm bipForm = ((ParamLigneBipForm) form);

			int i = 0;

			sbChaine = new StringBuffer(":");

			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				Libelle lib = (Libelle) e.nextElement();
				i++;

				cle = lib.getCle();
				libelle = lib.getLibelle();

				sbChaine = sbChaine.append(cle + ";" + libelle + ":");

			}

			// Ajouter la chaine dans la hashtable des paramètres
			hParamProc.put("string", sbChaine.toString());

			// on exécute la procedure PLSQL qui met à jour les proposés
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_UPDATE_LIBELLE);
			} // try
			catch (BaseException be) {
				logBipUser.debug(
						"ParamLigneBipAction-valider() --> BaseException :"
								+ be, be);
				logBipUser
						.debug("ParamLigneBipAction-valider() --> Exception :"
								+ be.getInitialException().getMessage());
				logService.debug(
						"ParamLigneBipAction-valider() --> BaseException :"
								+ be, be);
				logService
						.debug("ParamLigneBipAction-valider() --> Exception :"
								+ be.getInitialException().getMessage());
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((ParamLigneBipForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("ecran");
				} else {
					// Erreur d'exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					request.setAttribute("messageErreur", be
							.getInitialException().getMessage());
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}
			// annuler la mise à jour
			if (vParamOut == null) {
				session.setAttribute("errorUpdate", "UPDATE");
				logBipUser.debug("!!! update cancelled ");
			}

			// On détruit le tableau sauvegardé en session
			session.removeAttribute(PARAM_LIGNE_BIP);
			logBipUser.debug("Destruction de la liste des libellés");

		} catch (Exception e) {
			logBipUser.debug(signatureMethode + " --> exception : "
					+ e.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}
		// probleme de memoire
		// hParamProc = null;
		logBipUser.debug("fmemory end : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("initial");

	} // valider_libelle

	protected ActionForward valider_type(ActionMapping mapping,
			ActionForm form, String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		String cle;
		String libelle;

		StringBuffer sbChaine = new StringBuffer();
		HttpSession session = request.getSession(false);
		Class[] parameterString = {};
		Object oRees;
		String signatureMethode = "ParamLigneBipModAction-valider()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		try {

			// On sauvegarde les données du formulaire
			savePage_type(mapping, form, request, response, errors);

			PaginationVector page = (PaginationVector) session
					.getAttribute(PARAM_LIGNE_BIP);

			// On construit la chaîne qui doit être passé en paramètre de la
			// forme
			// :cdeb;ident;type;valide;commentaire:
			ParamLigneBipForm bipForm = ((ParamLigneBipForm) form);

			int i = 0;

			sbChaine = new StringBuffer(":");

			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				Libelle lib = (Libelle) e.nextElement();
				i++;

				cle = lib.getCle();
				libelle = lib.getLibelle();

				sbChaine = sbChaine.append(cle + ";" + libelle + ":");

			}

			// Ajouter la chaine dans la hashtable des paramètres
			hParamProc.put("string", sbChaine.toString());

			// on exécute la procedure PLSQL qui met à jour les proposés
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_UPDATE_TYPE);
			} // try
			catch (BaseException be) {
				logBipUser.debug(
						"ParamLigneBipAction-valider() --> BaseException :"
								+ be, be);
				logBipUser
						.debug("ParamLigneBipAction-valider() --> Exception :"
								+ be.getInitialException().getMessage());
				logService.debug(
						"ParamLigneBipAction-valider() --> BaseException :"
								+ be, be);
				logService
						.debug("ParamLigneBipAction-valider() --> Exception :"
								+ be.getInitialException().getMessage());
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((ParamLigneBipForm) form).setMsgErreur(message);
					 jdbc.closeJDBC(); return mapping.findForward("ecran");
				} else {
					// Erreur d'exécution de la procédure stockée
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11201"));
					request.setAttribute("messageErreur", be
							.getInitialException().getMessage());
					 jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}
			// annuler la mise à jour
			if (vParamOut == null) {
				session.setAttribute("errorUpdate", "UPDATE");
				logBipUser.debug("!!! update cancelled ");
			}

			// On détruit le tableau sauvegardé en session
			session.removeAttribute(PARAM_LIGNE_BIP);
			logBipUser.debug("Destruction de la liste des libellés");

		} catch (Exception e) {
			logBipUser.debug(signatureMethode + " --> exception : "
					+ e.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}
		// probleme de memoire
		// hParamProc = null;
		logBipUser.debug("fmemory end : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("initial");

	} // valider_type

	/**
	 * 
	 */

	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		String type_action;

		ParamLigneBipForm paramForm = (ParamLigneBipForm) form;

		type_action = paramForm.getType_action();

		if (type_action.equals("modifier_libelle")) {
			return modifier_libelle(mapping, form, request, response, errors, hParamProc);

		}
		if (type_action.equals("modifier_selection")) {
			  return mapping.findForward("ecranSelection");
		}
		if (type_action.equals("modifier_type")) {
			return modifier_type(mapping, form, request, response, errors,
					hParamProc);
		}

	 return mapping.findForward("ecran");

	} // consulter

	/**
	 * Action qui permet de visualiser les données liées à un code activite et
	 * DPG pour la modification et la suppression
	 */
	protected ActionForward modifier_libelle(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		Vector vListe = new Vector();
		PaginationVector vueListe;
		HttpSession session = request.getSession(false);

		String signatureMethode = "ParamLigneBipAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);

		// Création d'une nouvelle form
		ParamLigneBipForm paramLigneBipForm = (ParamLigneBipForm) form;

		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_LIBELLE);

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
						while (rset.next()) {

							vListe.add(new Libelle(rset.getString(1), rset
									.getString(2), rset.getString(3)));

							paramLigneBipForm.setMsgErreur(null);

						}
						if (rset != null)
							rset.close();

					} // try
					catch (SQLException sqle) {
						logBipUser
								.debug("ParamLigneBipAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ParamLigneBipAction-consulter() --> SQLException :"
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
				// le code Personne n'existe pas, on récupère le message
				paramLigneBipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"ParamLigneBipAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("ParamLigneBipAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logBipUser.debug(
					"ParamLigneBipAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("ParamLigneBipAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ParamLigneBipForm) form).setMsgErreur(message);
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

		// Construire un PaginationVector contenant les informations du FormBean
		vueListe = new PaginationVector(vListe, blocksize);

		// Stocker le résultat dans la session
		session.setAttribute(PARAM_LIGNE_BIP, vueListe);

		logService.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecranLibelle");

	} // modifier_libelle

	/**
	 * Action qui permet de visualiser les données liées à un code activite et
	 * DPG pour la modification et la suppression
	 */
	protected ActionForward modifier_type(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		Vector vListe = new Vector();
		PaginationVector vueListe;
		HttpSession session = request.getSession(false);

		String signatureMethode = "ParamLigneBipAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);

		// Création d'une nouvelle form
		ParamLigneBipForm paramLigneBipForm = (ParamLigneBipForm) form;

		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_TYPE);

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
						while (rset.next()) {

							vListe.add(new Libelle(rset.getString(1), rset
									.getString(2), rset.getString(3)));

							paramLigneBipForm.setMsgErreur(null);

						}
						if (rset != null)
							rset.close();

					} // try
					catch (SQLException sqle) {
						logBipUser
								.debug("ParamLigneBipAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ParamLigneBipAction-consulter() --> SQLException :"
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
				// le code Personne n'existe pas, on récupère le message
				paramLigneBipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"ParamLigneBipAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("ParamLigneBipAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logBipUser.debug(
					"ParamLigneBipAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("ParamLigneBipAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ParamLigneBipForm) form).setMsgErreur(message);
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

		// Construire un PaginationVector contenant les informations du FormBean
		vueListe = new PaginationVector(vListe, blocksize);

		// Stocker le résultat dans la session
		session.setAttribute(PARAM_LIGNE_BIP, vueListe);

		logService.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecranType");

	} // modifier_type

	/**
	 * Méthode savePage : Sauvegarde
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {

		HttpSession session = request.getSession(false);
		PaginationVector page = (PaginationVector) session
				.getAttribute(PARAM_LIGNE_BIP);

		String cle;
		String libelle;

		String consomme = "";
		Class[] parameterString = { String.class };
		String signatureMethode = "SaisieConso-savePage()";
		logBipUser.entry(signatureMethode);

		ParamLigneBipForm paramLigneBipForm = ((ParamLigneBipForm) form);

		try {
			// récupérer les champs modifiables
			for (int i = 1; i <= blocksize; i++) {

				for (Enumeration e = page.elements(); e.hasMoreElements();) {

					Libelle lib = (Libelle) e.nextElement();

					cle = lib.getCle();
					libelle = lib.getLibelle();

					if (request.getParameter(cle) != null)
						lib.setLibelle(request.getParameter(cle));

				} // for

			} // for

		} catch (NullPointerException npe) {
			logBipUser
					.debug("ParamLigneBipAction-savePage-->!!! valeur null dans : "
							+ npe.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (SecurityException se) {
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (IllegalArgumentException iae) {
			logBipUser.debug("arguments null : " + iae.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}
		session.setAttribute(PARAM_LIGNE_BIP, page);
		logBipUser.exit(signatureMethode);

	} // savePage

	/**
	 * Méthode savePage : Sauvegarde
	 */
	protected void savePage_type(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {

		HttpSession session = request.getSession(false);
		PaginationVector page = (PaginationVector) session
				.getAttribute(PARAM_LIGNE_BIP);

		String cle;
		String libelle;

		String cle1;
		String libelle1;

		String consomme = "";
		Class[] parameterString = { String.class };
		String signatureMethode = "SaisieConso-savePage()";
		logBipUser.entry(signatureMethode);

		ParamLigneBipForm paramLigneBipForm = ((ParamLigneBipForm) form);

		try {
			// récupérer les champs modifiables
			for (int i = 1; i <= blocksize; i++) {

				for (Enumeration e = page.elements(); e.hasMoreElements();) {

					Libelle lib = (Libelle) e.nextElement();

					cle = lib.getCle();
					libelle = lib.getLibelle();

					cle1 = request.getParameter(cle);

					if (request.getParameter(cle) != null) {
						lib.setLibelle(request.getParameter(cle));
					}

					if (request.getParameter(cle) == null)
						lib.setLibelle(" ");

				} // for

			} // for

		} catch (NullPointerException npe) {
			logBipUser
					.debug("ParamLigneBipAction-savePage-->!!! valeur null dans : "
							+ npe.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (SecurityException se) {
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (IllegalArgumentException iae) {
			logBipUser.debug("arguments null : " + iae.getMessage());
			// Erreur d''exécution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}
		session.setAttribute(PARAM_LIGNE_BIP, page);
		logBipUser.exit(signatureMethode);

	} // savePage_type
	
	protected  ActionForward pageIndex(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors ) throws ServletException 
	{
		PaginationVector page ;
		String pageName ;
		String index ;
		HttpSession session = request.getSession(false) ;
		ActionForward actionForward=null;
			
		// Extraction du nom de la page
		pageName = (String)request.getParameter("page") ;
		
		
		// Extraction de l'index
		index = (String)request.getParameter("index");
		
		
		page = (PaginationVector)session.getAttribute(pageName);
		
		if ( page != null ) {
			page.setBlock(Integer.parseInt(index));
			actionForward = mapping.findForward("ecranLibelle") ;
			
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR , new ActionError("error.page.noninitialisee"));	
			actionForward =  mapping.findForward("error") ;
			
		}//else if
		
		
		 return actionForward;
		
	}//pageIndex
	
	

}