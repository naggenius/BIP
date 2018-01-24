package com.socgen.bip.action;

import java.lang.reflect.InvocationTargetException;
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

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.SaisieReesForm;
import com.socgen.bip.metier.ReestimeOutil;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author J .MAS - 27/05/2005
 * 
 * Action de mise � jour du r�estim� chemin : Saisie des r�alis�s/ consomm�s
 * pages : fSaisieRe.jsp pl/sql :
 */
public class SaisieReesAction extends AutomateAction implements BipConstantes {
	private static String PACK_SELECT = "ressSaisie.consulter.proc";

	private static String PACK_UPDATE = "ressSaisie.modifier.proc";

	// 20/06/2005 : On n'utilise plus la proc�dure stock�e car on fait le test
	// d'existance dans la page jsp
	// fSaisieRe.jsp pour plus de r�activit� au niveau de l'utilisateur
	// private static String PACK_ADD_ACTIVITE =
	// "ressSaisie.ajoutActivite.proc";
	private static String PACK_ADD_ACTIVITE = "ressSaisie.modifier.proc";

	private static String PACK_TABLEAU = "ressSaisie.tableau.proc";

	private static String PACK_JOUR_OUVRE = "ressSaisie.jourouvre.proc";

	private static String PACK_REINIT = "ressSaisie.initialiser.proc";

	private int blocksize = 10;
	


	/**
	 * Action qui permet de passer � la page suivante
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		String signatureMethode = "SaisieRessAction-suite()";
		logBipUser.entry(signatureMethode);
		logBipUser.exit(signatureMethode);
		  return mapping.findForward("initial");

	} // suite

	/**
	 * Action qui permet de passer � la page premi�re page avec reconstitution
	 * du menu
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		HttpSession session = request.getSession(false);
		String signatureMethode = "SaisieRessAction-annuler()";
		logBipUser.entry(signatureMethode);
		// On d�truit le tableau sauvegard� en session
		session.removeAttribute(REESTIME);
		logBipUser
				.debug("Destruction de la liste des consos/r�estim�s en session");

		SaisieReesForm bipForm = ((SaisieReesForm) form);
		// on sauvegarde en session la position de la ressource dans la liste
		// d�roulante
		session.setAttribute("POSITION", bipForm.getPosition());
		// on sauvegarde en session la position du sc�nario dans la liste
		// d�roulante
		session.setAttribute("POSSCEN", bipForm.getPosScen());
		// on sauvegarde en session do DPG
		session.setAttribute("CODSG", bipForm.getCodsg());

		logBipUser.exit(signatureMethode);
		return mapping.findForward("suite");
	}

	/**
	 * Action qui permet le rafraichissement de la page initiale
	 */
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		HttpSession session = request.getSession(false);
		String signatureMethode = "SaisieRessAction-initialiser()";
		logBipUser.entry(signatureMethode);
		// On d�truit le tableau sauvegard� en session
		session.removeAttribute(REESTIME);
		logBipUser
				.debug("Destruction de la liste des consos/r�estim�s en session");

		SaisieReesForm bipForm = ((SaisieReesForm) form);
		// on sauvegarde en session la position de la ressource dans la liste
		// d�roulante
		session.setAttribute("POSITION", bipForm.getPosition());
		// on sauvegarde en session la position du sc�nario dans la liste
		// d�roulante
		session.setAttribute("POSSCEN", bipForm.getPosScen());
		// on sauvegarde en session do DPG
		session.setAttribute("CODSG", bipForm.getCodsg());

		logBipUser.exit(signatureMethode);
		 return mapping.findForward("initial");
	}

	/**
	 * M�thode consulter : Affichage des donn�es ->le tableau des r�sestim�s
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut1 = new Vector();
		Vector vParamOut2 = new Vector();
		Vector vParamOut3 = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		Vector vListe = new Vector();
		PaginationVector vueListe;
		HttpSession session = request.getSession(false);

		String signatureMethode = "SaisieRessAction-consulter()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		// Cr�ation d'une nouvelle form
		SaisieReesForm bipForm = (SaisieReesForm) form;

		if (hParamProc == null) {
			logBipUser.debug(signatureMethode + "-->hParamProc is null");
		}

		// on sauvegarde en session la position de la ressource dans la liste
		// d�roulante
		session.setAttribute("POSITION", bipForm.getPosition());
		// on sauvegarde en session la position du sc�nario dans la liste
		// d�roulante
		session.setAttribute("POSSCEN", bipForm.getPosScen());

		// ******* ex�cution de la proc�dure PL/SQL pour affichage ressource
		try {
			vParamOut1 = jdbc.getResult(
					hParamProc, configProc, PACK_SELECT);

			try {
				message = jdbc.recupererResult(vParamOut1, "valider");
			} catch (BaseException be) {
				logBipUser.debug("SaisieRessAction-creer() --> BaseException :"
						+ be);
				logBipUser.debug("SaisieRessAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("SaisieRessAction-creer() --> BaseException :"
						+ be);
				logService.debug("SaisieRessAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11217"));
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}

			if (message != null && !message.equals("")) {
				// on r�cup�re le message
				msg = true;
				bipForm.setMsgErreur(message);
				logBipUser.debug("SaisieRessAction-creer() -->message :"
						+ message);
			}

			// pas besoin d'aller plus loin
			if (vParamOut1 == null) {
				logBipUser
						.debug("SaisieReesAction-consulter(affichage ressource) :!!! cancel forward ");
				logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); return mapping.findForward("suite");
			}

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut1.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				// r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setIdent(rset.getString(1));
							bipForm.setRessource(rset.getString(2));
							bipForm.setMois(rset.getString(3));
							bipForm.setNbmois(rset.getString(4));
							bipForm.setMsgErreur(null);
							bipForm.setType_ress(rset.getString(8));
							bipForm.setDate_depart(rset.getString(9));
							bipForm.setDate_arrivee(rset.getString(10));
							bipForm.setAnnee(rset.getInt(11));
						} else
							msg = true;
						// rset.close();
					} catch (SQLException sqle) {
						logService
								.debug("SaisieRessAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SaisieRessAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("SaisieRessAction-consulter() --> SQLException-rset.close() :"
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
				// on r�cup�re le message
				bipForm.setMsgErreur(message);
				// on reste sur la m�me page
				//  jdbc.closeJDBC(); return mapping.findForward("initial");
				 jdbc.closeJDBC(); return mapping.findForward("suite");
			}
		} // try
		catch (BaseException be) {

			logBipUser.debug(
					"SaisieRessAction-consulter() |affichage ressource| --> BaseException :"
							+ be, be);
			logBipUser
					.debug("SaisieRessAction-consulter() |affichage ressource| --> Exception :"
							+ be.getInitialException().getMessage());
			logService.debug(
					"SaisieRessAction-consulter() |affichage ressource| --> BaseException :"
							+ be, be);
			logService
					.debug("SaisieRessAction-consulter() |affichage ressource| --> Exception :"
							+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {

				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SaisieReesForm) form).setMsgErreur(message);
				//  jdbc.closeJDBC(); return mapping.findForward("initial");
				 jdbc.closeJDBC(); return mapping.findForward("suite");
			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} 

		// ******* ex�cution de la proc�dure PL/SQL pour le total par mois, le
		// nb de jours ouvr�s, et les totaux g�n�raux
		try {
			vParamOut2 = jdbc.getResult(
					hParamProc, configProc, PACK_JOUR_OUVRE);

			// pas besoin d'aller plus loin
			if (vParamOut2 == null) {
				logBipUser
						.debug("SaisieReesAction-consulter(totaux) :!!! cancel forward  ");
				logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); return mapping.findForward("suite");
			}

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut2.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				// r�cup�rer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						logService.debug("ResultSet");
						if (rset.next()) {
							bipForm.setTot_mois_1(rset.getString(1));
							bipForm.setTot_mois_2(rset.getString(2));
							bipForm.setTot_mois_3(rset.getString(3));
							bipForm.setTot_mois_4(rset.getString(4));
							bipForm.setTot_mois_5(rset.getString(5));
							bipForm.setTot_mois_6(rset.getString(6));
							bipForm.setTot_mois_7(rset.getString(7));
							bipForm.setTot_mois_8(rset.getString(8));
							bipForm.setTot_mois_9(rset.getString(9));
							bipForm.setTot_mois_10(rset.getString(10));
							bipForm.setTot_mois_11(rset.getString(11));
							bipForm.setTot_mois_12(rset.getString(12));
							bipForm.setTotal_cons(rset.getString(13));
							bipForm.setTotal_rees(rset.getString(14));
							bipForm.setNbjour_1(rset.getString(15));
							bipForm.setNbjour_2(rset.getString(16));
							bipForm.setNbjour_3(rset.getString(17));
							bipForm.setNbjour_4(rset.getString(18));
							bipForm.setNbjour_5(rset.getString(19));
							bipForm.setNbjour_6(rset.getString(20));
							bipForm.setNbjour_7(rset.getString(21));
							bipForm.setNbjour_8(rset.getString(22));
							bipForm.setNbjour_9(rset.getString(23));
							bipForm.setNbjour_10(rset.getString(24));
							bipForm.setNbjour_11(rset.getString(25));
							bipForm.setNbjour_12(rset.getString(26));

							// sauvegarde des mois anciens
							saveOldMonths(bipForm);
							bipForm.setMsgErreur(null);
						} else
							msg = true;
						if (rset != null)
							rset.close();
					} // try
					catch (SQLException sqle) {
						logService
								.debug("SaisieRessAction-consulter() |jours ouvr�s| --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SaisieRessAction-consulter() |jours ouvr�s| --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			} // for
			if (msg) {
				// on r�cup�re le message
				bipForm.setMsgErreur(message);
				// on reste sur la m�me page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug(
					"SaisieRessAction-consulter() |jours ouvr�s| --> BaseException :"
							+ be, be);
			logBipUser
					.debug("SaisieRessAction-consulter() |jours ouvr�s| --> Exception :"
							+ be.getInitialException().getMessage());
			logService.debug(
					"SaisieRessAction-consulter() |jours ouvr�s| --> BaseException :"
							+ be, be);
			logService
					.debug("SaisieRessAction-consulter() |jours ouvr�s| --> Exception :"
							+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SaisieReesForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} 


		//Tools.forceFullGarbageCollection();

		// ******* ex�cute la proc�dure PL/SQL qui ram�ne les r�sultats pour le
		// tableau
		try {
			vParamOut3 = jdbc.getResult(
					hParamProc, configProc, PACK_TABLEAU);

			// pas besoin d'aller plus loin
			if (vParamOut3 == null) {
				logBipUser
						.debug("SaisieReesAction-consulter(tableau) :!!! cancel forward ");
				logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); return mapping.findForward("suite");
			}

			// R�cup�ration des r�sultats
			for (Enumeration e = vParamOut3.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							// On alimente le Bean ReestimeOutil et on le stocke
							// dans un vector
							vListe.add(new ReestimeOutil(rset.getString(1),
									rset.getString(2), rset.getString(3), rset
											.getString(4), rset.getString(5),
									rset.getString(6), rset.getString(7), rset
											.getString(8), rset.getString(9),
									rset.getString(10), rset.getString(11),
									rset.getString(12), rset.getString(13),
									rset.getString(14), rset.getString(15),
									rset.getString(16), rset.getString(17),
									rset.getString(18), rset.getString(19),
									rset.getString(20), rset.getString(21),
									rset.getString(22), rset.getString(23),
									rset.getString(24), rset.getString(25),
									rset.getString(26), rset.getString(27)));
						}
						if (rset != null)
							rset.close();
					} // try
					catch (SQLException sqle) {
						logService
								.debug("SaisieRessAction-consulter() |tableau| --> SQLException :"
										+ sqle);
						logBipUser
								.debug("SaisieRessAction-consulter() |tableau| --> SQLException :"
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
					"SaisieRessAction-consulter() |tableau| --> BaseException :"
							+ be, be);
			logBipUser
					.debug("SaisieRessAction-consulter() |tableau| --> Exception :"
							+ be.getInitialException().getMessage());
			logService.debug(
					"SaisieRessAction-consulter() |tableau| --> BaseException :"
							+ be, be);
			logService
					.debug("SaisieRessAction-consulter() |tableau| --> Exception :"
							+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((SaisieReesForm) form).setMsgErreur(message);
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
		session.setAttribute(REESTIME, vueListe);
		// probleme memoire
		hParamProc = null;
		//Tools.forceFullGarbageCollection();
		// Stocker le r�sultat dans le formulaire
		bipForm.setListePourPagination(vueListe);
		logBipUser
				.debug("fmemory end   : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	/**
	 * M�thode valider : Met � jour les r�estim�s dans la base de donn�es
	 */
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProc) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		String ident;
		String code_activite;
		String etape;
		String tache;
		String sous_tache;
		String reestime;
		String libRees;
		StringBuffer sbChaine = new StringBuffer();
		HttpSession session = request.getSession(false);
		Class[] parameterString = {};
		Object oRees;
		String signatureMethode = "SaisieRessAction-valider()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());
		try {

			PaginationVector page = (PaginationVector) session
					.getAttribute(REESTIME);

			// On sauvegarde les donn�es du formulaire
			savePage(mapping, form, request, response, errors);

			// On construit la cha�ne qui doit �tre pass� en param�tre de la
			// forme
			// ident:code_activite;REES_<ligne>_<mois>=;REES_<ligne>_<mois+1>=;....;:
			// 7267:ABSENCES;rees_1_11=2;rees_1_12=5;:ACHA;rees_2_11=12,6;rees_2_12=11;:
			SaisieReesForm bipForm = ((SaisieReesForm) form);
			ident = bipForm.getIdent();
			sbChaine.append(ident + ";" + bipForm.getCodsg() + ";"
					+ bipForm.getCode_scenario() + ";");
			int i = 0;
			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				ReestimeOutil saisieRees = (ReestimeOutil) e.nextElement();
				i++;
				code_activite = saisieRees.getCode_activite();
				sbChaine.append(":" + code_activite + ";");
				for (int j = (Integer.parseInt(bipForm.getNbmois()) + 1); j <= 12; j++) {
					libRees = "rees_" + i + "_" + j + "=";
					Object[] param1 = {};
					try {
						oRees = saisieRees.getClass().getDeclaredMethod(
								"getRees_" + j, parameterString).invoke(
								(Object) saisieRees, param1);
						if (oRees != null)
							reestime = oRees.toString();
						else
							reestime = "";
						sbChaine.append(libRees + reestime + ";");
					} // try
					catch (NullPointerException npe) {
						logBipUser.debug("!!! valeur null dans : "
								+ npe.getMessage());
						// Erreur d''ex�cution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (NoSuchMethodException me) {
						logBipUser.debug("M�thode inexistante");
						// Erreur d''ex�cution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (SecurityException se) {
						// Erreur d''ex�cution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (IllegalAccessException ia) {
						// Erreur d''ex�cution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (IllegalArgumentException iae) {
						// Erreur d''ex�cution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					} catch (InvocationTargetException ite) {
						// Erreur d''ex�cution
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11209"));
						this.saveErrors(request, errors);
					}
				} // for
			} // for

			sbChaine.append(":");
			// On d�truit le tableau sauvegard� en session
			session.removeAttribute(REESTIME);
			logBipUser
					.debug("Destruction de la liste des consos/r�estim�s en session");
			// Ajouter la chaine dans la hashtable des param�tres
			hParamProc.put("string", sbChaine.toString());
			// on ex�cute la procedure PLSQL qui met � jour les propos�s
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_UPDATE);
			} // try
			catch (BaseException be) {
				logBipUser
						.debug(
								"SaisieRessAction-consulter() --> BaseException :"
										+ be, be);
				logBipUser.debug("SaisieRessAction-consulter() --> Exception :"
						+ be.getInitialException().getMessage());
				logService
						.debug(
								"SaisieRessAction-consulter() --> BaseException :"
										+ be, be);
				logService.debug("SaisieRessAction-consulter() --> Exception :"
						+ be.getInitialException().getMessage());
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					((SaisieReesForm) form).setMsgErreur(message);
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
			} else {
				// on sauvegarde en session la position de la ressource dans la
				// liste d�roulante
				session.setAttribute("POSITION", bipForm.getPosition());
				// on sauvegarde en session la position du sc�nario dans la
				// liste d�roulante
				session.setAttribute("POSSCEN", bipForm.getPosScen());
				// on sauvegarde en session do DPG
				session.setAttribute("CODSG", bipForm.getCodsg());
			}

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
		 jdbc.closeJDBC(); return mapping.findForward("suite");
	} // valider

	/**
	 * M�thode savePage : Sauvegarde les r�estim�s en session
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {

		HttpSession session = request.getSession(false);
		PaginationVector page = (PaginationVector) session
				.getAttribute(REESTIME);
		String activite;
		String libActivite;
		String libTotalRees;
		String reestime = "";
		Class[] parameterString = { String.class };
		String signatureMethode = "SaisieRees-savePage()";
		logBipUser.entry(signatureMethode);
		// Sauvegarde du total par mois de la page pr�c�dente

		SaisieReesForm bipForm = ((SaisieReesForm) form);
		// sauvegarde des mois anciens
		saveOldMonths(bipForm);

		// sauvegarde de la nouvelle activit� � ajouter
		try {
			String paramNCA = request.getParameter("newCodeActivite");
			if (paramNCA != null) {
				bipForm.setNewCodeActivite(paramNCA);
			}
		} catch (NullPointerException e) {
			logBipUser
					.debug("Probl�me lors de la r�cup�ration de la nouvelle activit� : "
							+ e.getMessage());
		}

		try {
			// r�cup�rer les champs modifiables
			for (int i = 1; i <= blocksize; i++) {
				libActivite = "code_activite_" + i;
				libTotalRees = "total_rees_" + i;
				Object[] param2 = { (Object) request.getParameter(libTotalRees) };

				for (Enumeration e = page.elements(); e.hasMoreElements();) {
					ReestimeOutil saisieRees = (ReestimeOutil) e.nextElement();
					activite = saisieRees.getCode_activite();
					for (int j = 1; j <= 12; j++) {

						reestime = "rees_" + i + "_" + j;
						Object[] param1 = { (Object) request
								.getParameter(reestime) };
						if (request.getParameter(libActivite) != null) {
							if ((request.getParameter(libActivite))
									.equals(activite)) {

								saisieRees.getClass().getDeclaredMethod(
										"setTotal_rees", parameterString)
										.invoke((Object) saisieRees, param2);
								// On met � jour les consomm� de la ligne
								// On doit r�cup�rer les m�thodes suivant le
								// mois
								// pour cela, on utilise les m�thodes
								// - Method getDeclaredMethod(String name,
								// Class[] parameterTypes) : r�cup�re la bonne
								// m�thode
								// - puis Object invoke(Object obj, Object[]
								// args) : ex�cute la m�thode

								if (request.getParameter(reestime) != null) {
									saisieRees
											.getClass()
											.getDeclaredMethod("setRees_" + j,
													parameterString)
											.invoke((Object) saisieRees, param1);

								}
							} // if
						} // if

					} // for
				} // for
			} // for
		} catch (NullPointerException npe) {
			logBipUser
					.debug("SaisieRessAction-savePage-->!!! valeur null dans : "
							+ npe.getMessage());
			// Erreur d''ex�cution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (NoSuchMethodException me) {
			logBipUser.debug("M�thode inexistante " + me.getMessage());
			// Erreur d''ex�cution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (SecurityException se) {
			// Erreur d''ex�cution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (IllegalAccessException ia) {
			// Erreur d''ex�cution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (IllegalArgumentException iae) {
			logBipUser.debug("arguments null : " + iae.getMessage());
			// Erreur d''ex�cution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		} catch (InvocationTargetException ite) {
			// Erreur d''ex�cution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}

		session.setAttribute(REESTIME, page);
		logBipUser.exit(signatureMethode);

	} // savePage

	/*
	 * sauvegarde des mois anciens
	 */
	private void saveOldMonths(SaisieReesForm bipForm) {

		bipForm.setOld_tot_mois_1(bipForm.getTot_mois_1());
		bipForm.setOld_tot_mois_2(bipForm.getTot_mois_2());
		bipForm.setOld_tot_mois_3(bipForm.getTot_mois_3());
		bipForm.setOld_tot_mois_4(bipForm.getTot_mois_4());
		bipForm.setOld_tot_mois_5(bipForm.getTot_mois_5());
		bipForm.setOld_tot_mois_6(bipForm.getTot_mois_6());
		bipForm.setOld_tot_mois_7(bipForm.getTot_mois_7());
		bipForm.setOld_tot_mois_8(bipForm.getTot_mois_8());
		bipForm.setOld_tot_mois_9(bipForm.getTot_mois_9());
		bipForm.setOld_tot_mois_10(bipForm.getTot_mois_10());
		bipForm.setOld_tot_mois_11(bipForm.getTot_mois_11());
		bipForm.setOld_tot_mois_12(bipForm.getTot_mois_12());
	}

	/*
	 * Fonction permettant d'ajouter une nouvelle activit� � la ressource
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String libRees;
		StringBuffer sbChaine = new StringBuffer();
		HttpSession session = request.getSession(false);
		String signatureMethode = "SaisieReesAction-creer(paramProc, mapping, form , request,  response,  errors )";
		logService.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());

		try {

			// PaginationVector page = (PaginationVector)
			// session.getAttribute(REESTIME);

			// On sauvegarde les donn�es du formulaire
			// savePage(mapping, form, request, response, errors);
			// On construit la cha�ne qui doit �tre pass� en param�tre de la
			// forme
			// ident:code_activite;REES_<ligne>_<mois>=;REES_<ligne>_<mois+1>=;....;:
			// 7267:ABSENCES;rees_1_11=2;rees_1_12=5;:ACHA;rees_2_11=12,6;rees_2_12=11;:
			SaisieReesForm bipForm = (SaisieReesForm) form;
			bipForm.setMsgErreur("");
			sbChaine.append(bipForm.getIdent() + ";" + bipForm.getCodsg() + ";"
					+ bipForm.getCode_scenario() + ";");

			int i = 1;
			// on teste s'il faut sauvegarder les modifications ou non
			if (bipForm.getModifRees().equals("true")) {
				Object oRees;
				String code_activite;
				String reestime;
				Class[] parameterString = {};
				PaginationVector page = (PaginationVector) session
						.getAttribute(REESTIME);
				// On sauvegarde les donn�es du formulaire
				savePage(mapping, form, request, response, errors);
				for (Enumeration e = page.elements(); e.hasMoreElements(); i++) {
					ReestimeOutil saisieRees = (ReestimeOutil) e.nextElement();
					code_activite = saisieRees.getCode_activite();
					sbChaine.append(":" + code_activite + ";");
					for (int j = (Integer.parseInt(bipForm.getNbmois()) + 1); j <= 12; j++) {
						libRees = "rees_" + i + "_" + j + "=";
						Object[] param1 = {};
						try {
							oRees = saisieRees.getClass().getDeclaredMethod(
									"getRees_" + j, parameterString).invoke(
									(Object) saisieRees, param1);
							if (oRees != null)
								reestime = oRees.toString();
							else
								reestime = "";
							sbChaine.append(libRees + reestime + ";");
						} // try
						catch (NullPointerException npe) {
							logBipUser.debug("!!! valeur null dans : "
									+ npe.getMessage());
							// Erreur d''ex�cution
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11209"));
							this.saveErrors(request, errors);
						} catch (NoSuchMethodException me) {
							logBipUser.debug("M�thode inexistante");
							// Erreur d''ex�cution
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11209"));
							this.saveErrors(request, errors);
						} catch (SecurityException se) {
							// Erreur d''ex�cution
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11209"));
							this.saveErrors(request, errors);
						} catch (IllegalAccessException ia) {
							// Erreur d''ex�cution
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11209"));
							this.saveErrors(request, errors);
						} catch (IllegalArgumentException iae) {
							// Erreur d''ex�cution
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11209"));
							this.saveErrors(request, errors);
						} catch (InvocationTargetException ite) {
							// Erreur d''ex�cution
							errors.add(ActionErrors.GLOBAL_ERROR,
									new ActionError("11209"));
							this.saveErrors(request, errors);
						}
					} // for
				} // for
			}

			sbChaine.append(":" + bipForm.getNewCodeActivite() + ";");
			for (int j = (Integer.parseInt(bipForm.getNbmois()) + 1); j <= 12; j++) {
				libRees = "rees_" + i + "_" + j + "=";
				sbChaine.append(libRees + "0;");
			} // for

			sbChaine.append(":");
			// Ajouter la chaine dans la hashtable des param�tres
			hParamProc.put("string", sbChaine.toString());

			logBipUser.debug("sbChaine : " + sbChaine.toString());

			// on ex�cute la procedure PLSQL qui met � jour les propos�s
			try {
				vParamOut = jdbc.getResult(
						hParamProc, configProc, PACK_ADD_ACTIVITE);
				try {
					message = jdbc.recupererResult(vParamOut, "valider");
				} catch (BaseException be) {
					logBipUser
							.debug("SaisieRessAction-creer() --> BaseException :"
									+ be);
					logBipUser.debug("SaisieRessAction-creer() --> Exception :"
							+ be.getInitialException().getMessage());
					logService
							.debug("SaisieRessAction-creer() --> BaseException :"
									+ be);
					logService.debug("SaisieRessAction-creer() --> Exception :"
							+ be.getInitialException().getMessage());
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11217"));
					 jdbc.closeJDBC(); return mapping.findForward("error");
				} 

				if (message != null && !message.equals("")) {
					// on r�cup�re le message indiquant que l'activit� est d�j�
					// affect� � la ressource
					bipForm.setMsgErreur(message);
					logBipUser.debug("SaisieRessAction-creer() -->message :"
							+ message);
				} else {
					consulter(mapping, form, request, response, errors,
							hParamProc);
				}
			} // try
			catch (BaseException be) {
				logBipUser.debug("SaisieRessAction-creer() --> BaseException :"
						+ be, be);
				logBipUser.debug("SaisieRessAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				logService.debug("SaisieRessAction-creer() --> BaseException :"
						+ be, be);
				logService.debug("SaisieRessAction-creer() --> Exception :"
						+ be.getInitialException().getMessage());
				if (be.getInitialException().getClass().getName().equals(
						"java.sql.SQLException")) {
					message = BipException.getMessageFocus(BipException
							.getMessageOracle(be.getInitialException()
									.getMessage()), form);
					bipForm.setMsgErreur(message);
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
			if (vParamOut == null) {
				session.setAttribute("errorUpdate", "UPDATE");
				logBipUser
						.debug("SaisieRessAction-creer() --> Erreur lors de l'insert pour l'ajout de l'activit�");
			}
		} catch (Exception e) {
			logBipUser.debug(signatureMethode + " --> exception : "
					+ e.getMessage());
			// Erreur d''ex�cution
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11209"));
			this.saveErrors(request, errors);
		}

		logBipUser.debug("fmemory end : " + Runtime.getRuntime().freeMemory());

		logService.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// fin creer

	/*
	 * Fonction r�initialisant le r�estim� d'une ressource suivant la
	 * r�partition saisie
	 */
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut1 = new Vector();
		Vector vParamOut2 = new Vector();
		Vector vParamOut3 = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		Vector vListe = new Vector();
		PaginationVector vueListe;
		HttpSession session = request.getSession(false);

		String signatureMethode = "SaisieRessAction-refresh()";
		logBipUser.entry(signatureMethode);
		logBipUser
				.debug("fmemory start : " + Runtime.getRuntime().freeMemory());

		SaisieReesForm bipForm = ((SaisieReesForm) form);

		if (hParamProc == null) {
			logBipUser.debug(signatureMethode + "-->hParamProc is null");
		}

		// ******* ex�cution de la proc�dure PL/SQL pour r�initialiser le
		// r�estim�
		try {
			vParamOut1 = jdbc.getResult(
					hParamProc, configProc, PACK_REINIT);

			try {
				message = jdbc.recupererResult(vParamOut1, "valider");
			} catch (BaseException be) {
				logBipUser.debug(signatureMethode
						+ " --> Probl�me pour r�cup�rer le message.");
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
				// on r�cup�re le message
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
				((SaisieReesForm) form).setMsgErreur(message);
			} else {
				// Erreur d''ex�cution de la proc�dure stock�e
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} 

		logBipUser.debug("fmemory end : " + Runtime.getRuntime().freeMemory());
		logBipUser.exit(signatureMethode);

		//  jdbc.closeJDBC(); return mapping.findForward("ecran");
		 jdbc.closeJDBC(); return consulter(mapping, form, request, response, errors, hParamProc);
	}// fin refresh

}
