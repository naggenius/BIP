/*
 * Created on 2 mai 05
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.socgen.bip.action;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
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
import com.socgen.bip.metier.ActiviteLigne;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author X058813
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class ActiviteLigneAction extends AutomateAction {

	private static String PACK_INSERT = "activiteLigne.creer.proc";

	private static String PACK_SELECT_LISTE = "activiteLigne.liste.proc";

	private static String PACK_SELECT_LIGNE = "activiteLigne.ligne.proc";
	
	private static String PACK_VERIFIE_CODSG = "activiteLigne.verifcodsg.proc";

	
	private int blocksize = 10;

	/**
	 * Action qui permet de supprimer une ligne BIP de la liste des lignes BIP
	 * de l'activite du DPG
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		String signatureMethode = "ActiviteLigneAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		// Récupération des données et de l'activite ligne choisie
		ActiviteLigneForm activiteLigneForm = (ActiviteLigneForm) form;
		ActiviteLigne activiteLigne = new ActiviteLigne();
		activiteLigne.setCode_activite(activiteLigneForm.getCode_activite());
		activiteLigne.setLib_activite(activiteLigneForm.getLib_activite());
		activiteLigne.setCodsg(activiteLigneForm.getCodsg());
		activiteLigne.setPid(activiteLigneForm.getPid_choisi());

		// Recuperation de la liste en session
		HttpSession session = request.getSession(false);
		PaginationVector vueListe = (PaginationVector) session
				.getAttribute(ACTIVITE_LIGNE);
		Vector listeActiviteLigne = new Vector(vueListe);
		for (int i = 0; i < listeActiviteLigne.size(); i++) {
			if (activiteLigne.equals((ActiviteLigne) listeActiviteLigne.get(i))) {
				listeActiviteLigne.removeElementAt(i);
			}
		}

		// Construire un PaginationVector contenant les informations du FormBean
		PaginationVector liste = new PaginationVector(listeActiviteLigne,
				blocksize);

		// Stocker le résultat dans la session
		(request.getSession(false)).setAttribute(ACTIVITE_LIGNE, liste);
		// Stocker le résultat dans le formulaire
		activiteLigneForm.setListePourPagination(liste);

		logService.exit(signatureMethode);

		return mapping.findForward("ecran");
	} // consulter

	/**
	 * Action qui permet de visualiser la liste des lignes Bip liées à un code
	 * DPG et à une activité
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

		String signatureMethode = "ActiviteLigneAction-suite(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Création d'une nouvelle form
		ActiviteLigneForm activiteLigneForm = (ActiviteLigneForm) form;

		hParamProc.put("P_global", userBip.getInfosUser());

		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_LISTE);
						
			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("lib_activite")) {
					activiteLigneForm.setLib_activite((String) paramOut
							.getValeur());
				}

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							// On alimente le Bean ActiviteLigne et on le stocke
							// dans un vector
							vListe.add(new ActiviteLigne(rset.getString(1),
									rset.getString(2), rset.getString(3), rset
											.getString(4), rset.getString(5)));
						}
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("ActiviteLigneAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ActiviteLigneAction-consulter() --> SQLException :"
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
				activiteLigneForm.setMsgErreur(message);
				
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
		(request.getSession(false)).setAttribute(ACTIVITE_LIGNE, vueListe);

		// Stocker l'index selectionné du menu
		(request.getSession(false)).setAttribute("POS_MENUACT", "");

		// Stocker le résultat dans le formulaire
		activiteLigneForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");

	} // consulter

	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String codsg;
		String signatureMethode = "ActiviteLigneAction-creer(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);

		// Récupération des données et de l'activite ligne choisie
		ActiviteLigneForm activiteLigneForm = (ActiviteLigneForm) form;
		ActiviteLigne activiteLigne = new ActiviteLigne();
		activiteLigne.setCode_activite(activiteLigneForm.getCode_activite());
		activiteLigne.setCodsg(activiteLigneForm.getCodsg());
		activiteLigne.setPid(activiteLigneForm.getPid());
		activiteLigne.setLib_activite(activiteLigneForm.getLib_activite());

		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT_LIGNE);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("lib_ligne")) {
					activiteLigne.setLib_ligne((String) paramOut.getValeur());
				}
			}// for
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
				activiteLigneForm.setMsgErreur(message);
				
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
				.getAttribute(ACTIVITE_LIGNE);
		Vector listeActiviteLigne = new Vector(vueListe);
		listeActiviteLigne.add(activiteLigne);

		// Construire un PaginationVector contenant les informations du FormBean
		PaginationVector liste = new PaginationVector(listeActiviteLigne,
				blocksize);

		// Stocker le résultat dans la session
		(request.getSession(false)).setAttribute(ACTIVITE_LIGNE, liste);
		// Stocker le résultat dans le formulaire
		activiteLigneForm.setListePourPagination(liste);

		// on sauvegarde en session la position du ligne bip dans la liste
		// déroulante
		(request.getSession(false)).setAttribute("POS_MENUACT",
				activiteLigneForm.getPos_menu());

		logService.exit(signatureMethode);

		jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// fin creer

	/**
	 * Action qui permet de passer à la page première page avec destruction du
	 * tableau en session
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		HttpSession session = request.getSession(false);

		String signatureMethode = "ActiviteLigneAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On détruit le tableau sauvegardé en session
		session.removeAttribute(ACTIVITE_LIGNE);
		logBipUser
				.debug("Destruction de la liste des activites Lignes en session");
		logBipUser.exit(signatureMethode);

		return mapping.findForward("initial");
	}

	/**
	 * Method valider Action qui permet d'enregistrer les données en session
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
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = null;
		String pid;
		String codsg;
		String code_activite;
		String chaine = ";";

		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);

		// Recuperation de la liste en session
		HttpSession session = request.getSession(false);
		Vector listeActiviteLigne = (Vector) session
				.getAttribute(ACTIVITE_LIGNE);

		ActiviteLigneForm activiteLigneForm = (ActiviteLigneForm) form;
		codsg = activiteLigneForm.getCodsg();
		code_activite = activiteLigneForm.getCode_activite();
		chaine = chaine + codsg + ";" + code_activite + ";";

		for (Iterator iterActiviteLigne = listeActiviteLigne.iterator(); iterActiviteLigne
				.hasNext();) {
			ActiviteLigne activiteLigne = (ActiviteLigne) iterActiviteLigne
					.next();
			pid = activiteLigne.getPid();
			chaine = chaine + pid + ";";
		}
		chaine = chaine + "-1;";

		// On détruit le tableau sauvegardé en session
		session.removeAttribute(ACTIVITE_LIGNE);
		logBipUser
				.debug("Destruction de la liste des activites lignes en session");

		// Ajouter la chaine dans la hashtable des paramètres
		hParamProc.put("string", chaine);

		// On exécute la procédure stockée
		try {

			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_INSERT);

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
				((ActiviteLigneForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug("ReestMassAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ReestMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("ReestMassAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ReestMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ActiviteLigneForm) form).setMsgErreur(message);
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
		ActiviteLigneForm activiteLigneForm = (ActiviteLigneForm) form;
 
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
				activiteLigneForm.setMsgErreur(message);
				
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				activiteLigneForm.setMsgErreur(be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}

		}  
		   return mapping.findForward("initial");
	}
	
}