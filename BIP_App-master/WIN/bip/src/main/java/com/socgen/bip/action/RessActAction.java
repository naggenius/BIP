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
import com.socgen.bip.form.ActiviteLigneForm;
import com.socgen.bip.form.RessActForm;
import com.socgen.bip.metier.RessAct;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author MMC
 * 
 */
public class RessActAction extends AutomateAction {

	private static String PACK_INSERT = "ressAct.creer.proc";

	private static String PACK_SELECT_LISTE = "ressAct.liste.proc";

	private static String PACK_SELECT_LIGNE = "ressAct.ligne.proc";

	private static String PACK_VERIFIE_CODSG = "activiteLigne.verifcodsg.proc";
	
	
	private int blocksize = 10;
	
	

	/**
	 * Method refresh
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @ jdbc.closeJDBC(); return ActionForward
	 * @throws ServletException
	 */
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
	 
		 JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		//boolean msg = false;
		ParametreProc paramOut;
		//String codsg;
		//Vector vListe = new Vector();
		//PaginationVector vueListe;
		
		String signatureMethode = "ActiviteLigneAction-refresh(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Création d'une nouvelle form
		RessActForm ressActForm = (RessActForm) form;

		 hParamProc.put("P_global", userBip.getInfosUser()); 
		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_VERIFIE_CODSG);
						
			 
		}// try
		catch (BaseException be) {
			logBipUser.debug(
					"ActiviteLigneAction-consulter() --> BaseException :" + be,
					be);
			logBipUser.debug("ActiviteLigneAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug(
					"ActiviteLigneAction-consulter() --> BaseException :" + be,
					be);
			logService.debug("ActiviteLigneAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				ressActForm.setMsgErreur(message);
				
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				ressActForm.setMsgErreur(be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}  
		 
		return mapping.findForward("initial");
	}

	/**
	 * Action qui permet de visualiser la liste des activités liées à un code
	 * DPG et à une ressource
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

		String signatureMethode = "RessActAction-suite(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Création d'une nouvelle form
		RessActForm ressActForm = (RessActForm) form;

		hParamProc.put("P_global", userBip.getInfosUser());

		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_LISTE);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// Affichage sur la page Affectation Ressources - Activités
				// du nom de la ressource selectionnee
				if (paramOut.getNom().equals("lib_ress")) {
					ressActForm.setLib_ress((String) paramOut.getValeur());
				}

				// recuperation du total des taux de repartition
				if (paramOut.getNom().equals("total_rep")) {
					ressActForm.setTotal_rep((String) paramOut.getValeur());
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							// On alimente le Bean RessAct et on le stocke dans
							// un vector
							vListe.add(new RessAct(rset.getString(1), rset
									.getString(2), rset.getString(3), rset
									.getString(4), rset.getString(5), rset
									.getString(6), rset.getString(7)));
						}
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("RessActAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("RessActAction-consulter() --> SQLException :"
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
			logBipUser.debug("RessActAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("RessActAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("RessActAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("RessActAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				ressActForm.setMsgErreur(message);
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
		(request.getSession(false)).setAttribute(RESSACT, vueListe);

		// Stocker l'index selectionné du menu
		(request.getSession(false)).setAttribute("POS_MENU", "");

		// Stocker le résultat dans le formulaire
		ressActForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");

	}

	// suite

	// pour creer une activite
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String codsg;
		String signatureMethode = "RessActAction-creer(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);

		// Récupération des données et de l'activite ligne choisie
		RessActForm ressActForm = (RessActForm) form;
		RessAct ressAct = new RessAct();
		ressAct.setCode_activite(ressActForm.getCode_activite());
		ressAct.setCodsg(ressActForm.getCodsg());
		ressAct.setCode_ress(ressActForm.getCode_ress());
		ressAct.setLib_activite(ressActForm.getLib_activite());
		ressAct.setRepartition(ressActForm.getRepartition());

		// Récupération du libellé de l'activité
		try {
			vParamOut = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT_LIGNE);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("lib_activite")) {
					ressAct.setLib_activite((String) paramOut.getValeur());
				}
			}// for
		}// try
		catch (BaseException be) {
			logBipUser.debug("RessActAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("RessActAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("RessActAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("RessActAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				ressActForm.setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());

				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

		}

		// Recuperation de la liste en session
		HttpSession session = request.getSession(false);
		PaginationVector vueListe = (PaginationVector) session
				.getAttribute(RESSACT);
		Vector listeRessAct = new Vector(vueListe);

		// On sauvegarde les données en session pour ne pas les perdre lors du
		// rafraichissement de l'ecran
		savePage(mapping, form, request, response, errors);

		// ajout de la nouvelle activité dans la liste
		listeRessAct.add(ressAct);

		// Construire un PaginationVector contenant les informations du FormBean
		PaginationVector liste = new PaginationVector(listeRessAct, blocksize);

		// Stocker le résultat dans la session
		(request.getSession(false)).setAttribute(RESSACT, liste);
		// Stocker le résultat dans le formulaire
		ressActForm.setListePourPagination(liste);

		// on sauvegarde en session la position du ligne bip dans la liste
		// déroulante
		(request.getSession(false)).setAttribute("POS_MENU", ressActForm
				.getPos_menu());

		logService.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// fin creer

	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParams)
			throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = null;
		String code_activite;
		String codsg;
		String code_ress;
		String repartition;
		String chaine = ";";
		HttpSession session = request.getSession(false);

		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);

		PaginationVector page = (PaginationVector) (request.getSession())
				.getAttribute(RESSACT);

		// Recuperation de la liste en session
		Vector listeRessAct = (Vector) session.getAttribute(RESSACT);

		RessActForm ressActForm = (RessActForm) form;
		codsg = ressActForm.getCodsg();
		code_ress = ressActForm.getCode_ress();
		chaine = "chaine;" + codsg + ";" + code_ress + ";";

		// On sauvegarde les données du formulaire
		savePage(mapping, form, request, response, errors);

		// for (Iterator iterRessAct = listeRessAct.iterator();
		// iterRessAct.hasNext();)
		for (Enumeration e = page.elements(); e.hasMoreElements();) {
			// RessAct ressAct = (RessAct) iterRessAct.next();
			RessAct ressAct = (RessAct) e.nextElement();
			// code activite + taux de repartition
			codsg = ressActForm.getCodsg();
			code_ress = ressActForm.getCode_ress();
			code_activite = ressAct.getCode_activite();
			repartition = ressAct.getRepartition();
			chaine = chaine + codsg + ";" + code_ress + ";" + code_activite
					+ ";" + repartition + ";";
			// chaine = chaine + code_activite + ";"+ repartition + ";";
		}
		// chaine = chaine + "-1;";

		// On détruit le tableau sauvegardé en session
		session.removeAttribute(RESSACT);
		logBipUser.debug("Destruction de la liste des activites en session");
		// Ajouter la chaine dans la hashtable des paramètres
		hParams.put("string", chaine);

		// On exécute la procédure stockée
		try {

			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_INSERT);

			try {
				message = jdbc.recupererResult(vParamOut, "valider");
			} catch (BaseException be) {
				logBipUser.debug("valider() --> BaseException :" + be);
				logBipUser.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("valider() --> BaseException :" + be);
				logService.debug("valider() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on récupère le message
				((RessActForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("RessActAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("RessActAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("RessActAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("RessActAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((RessActForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("ecran");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("initial");

	}// valider

	/**
	 * Action qui permet de passer à la page première page avec destruction du
	 * tableau en session
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		HttpSession session = request.getSession(false);

		String signatureMethode = "RessActAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On détruit le tableau sauvegardé en session
		session.removeAttribute(RESSACT);
		logBipUser
				.debug("Destruction de la liste des ressources activites en session");
		logBipUser.exit(signatureMethode);

		 return mapping.findForward("initial");
	}

	// annuler

	/**
	 * Méthode savePage : Sauvegarde les répartitions en session
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {
		String code_activite;
		String lib_activite;
		String repartition;

		PaginationVector page = (PaginationVector) (request.getSession())
				.getAttribute(RESSACT);
		// récupérer les champs modifiables
		for (int i = 1; i <= blocksize; i++) {
			code_activite = "code_activite_" + i;
			lib_activite = "lib_activite_" + i;
			repartition = "repartition_" + i;

			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				RessAct ressAct = (RessAct) e.nextElement();
				if (request.getParameter(code_activite) != null) {
					if ((request.getParameter(code_activite)).equals(ressAct
							.getCode_activite())
							&& (request.getParameter(lib_activite))
									.equals(ressAct.getLib_activite())) {
						// On met à jour le taux de facturation de la ligne
						ressAct.setRepartition(request
								.getParameter(repartition));
					}// if
				}// if
			}// for
		} // for

		(request.getSession()).setAttribute(RESSACT, page);
	}// savePage

	/**
	 * Action qui permet de supprimer une activite de la liste des activites
	 * d'une ressource
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		String signatureMethode = "RessActAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		// Récupération des données et de l'activite ligne choisie
		RessActForm ressActForm = (RessActForm) form;
		RessAct ressAct = new RessAct();

		// si on est dans le cas d'une suppression d'activité, il faut
		// sauvegarder les info en session car
		// il a pu y avoir des modifications effectuées par l'utilisateur
		if (ressActForm.getMode().equals("delete")) {
			savePage(mapping, form, request, response, errors);
		}

		// ressAct.setCode_ress((ressActForm.getCode_ress()).substring(1));
		ressAct.setCodsg(ressActForm.getCodsg());
		ressAct.setCode_activite(ressActForm.getCode_activite_choisi());

		// Recuperation de la liste en session
		HttpSession session = request.getSession(false);
		PaginationVector vueListe = (PaginationVector) session
				.getAttribute(RESSACT);
		Vector listeRessAct = new Vector(vueListe);

		for (int i = 0; i < listeRessAct.size(); i++) { // Object bidule =
														// listeRessAct.firstElement();
			// Object truc = listeRessAct.get(1);
			if (((String) ressAct.getCode_activite())
					.equals((String) ((RessAct) listeRessAct.get(i))
							.getCode_activite()))

			{
				listeRessAct.removeElementAt(i);
			}
		}

		// Construire un PaginationVector contenant les informations du FormBean
		PaginationVector liste = new PaginationVector(listeRessAct, blocksize);

		// Stocker le résultat dans la session
		(request.getSession(false)).setAttribute(RESSACT, liste);
		// Stocker le résultat dans le formulaire
		ressActForm.setListePourPagination(liste);

		logService.exit(signatureMethode);

		 return mapping.findForward("ecran");
	} // consulter

}