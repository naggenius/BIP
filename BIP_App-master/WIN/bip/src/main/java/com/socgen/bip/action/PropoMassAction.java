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

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.BudgMassForm;
import com.socgen.bip.metier.Propose;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author N.BACCAM - 15/07/2003
 * 
 * Action de mise à jour des budgets (proposés et réestimés) en masse chemin :
 * Administration/Budjet JH/Saisie en masse pages : fBudgMassAd.jsp et
 * bPropoMassAd.jsp pl/sql : propomassmo.sql, ls_mopropo.sql
 */
public class PropoMassAction extends AutomateAction implements BipConstantes {
	private static String PACK_SELECT = "propomass.consulter.proc";

	private static String PACK_UPDATE = "propomass.modifier.proc";

	private static String PACK_TABLEAU = "propomass.tableau.proc";

	private static String PACK_TOTAL = "propomass.total.proc";

	int blocksize = 10;
	
	

	/**
	 * Constructor for PropoMassAction.
	 */
	public PropoMassAction() {
		super();
	}

	/**
	 * Action qui permet de passer à la page première page avec destruction du
	 * tableau en session
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		HttpSession session = request.getSession(false);

		String signatureMethode = "PropoMassAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On détruit le tableau sauvegardé en session
		session.removeAttribute(PROPOSE_EN_MASSE);
		logBipUser.debug("Destruction de la liste des proposés en session");

		BudgMassForm bipForm = ((BudgMassForm) form);
		// on sauvegarde en session la position de la ressource dans la liste
		// déroulante
		session.setAttribute("POSITIONCLIENT", bipForm.getPosClient());
		// on sauvegarde en session la position du scénario dans la liste
		// déroulante
		session.setAttribute("POSITIONAPPLI", bipForm.getPosAppli());
		// on sauvegarde en session do DPG
		session.setAttribute("CODSG", bipForm.getCodsg());
		// on sauvegarde l'année
		session.setAttribute("ANNEE", bipForm.getAnnee());

		logBipUser.exit(signatureMethode);

		 return mapping.findForward("initial");
	}

	/**
	 * Méthode consulter : Affichage des données dont le tableau des proposés
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		Vector vParamOut2 = new Vector();
		boolean msg = false;
		ParametreProc paramOut;
		Vector vListe = new Vector();
		PaginationVector vueListe;

		String signatureMethode = "PropoMassAction-consulter(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Récupération du form
		BudgMassForm bipForm = (BudgMassForm) form;
				
		// exécution de la procédure PL/SQL pour affichage du sigle du code
		// client MO
		try {
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_SELECT);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				// récupérer le message
				if (paramOut.getNom().equals("message")) {
					message = (String) paramOut.getValeur();
				}

				// Récupérer le lib du codsg
				if (paramOut.getNom().equals("libcodsg")) {
					bipForm.setLibcodsg((String) paramOut.getValeur());
				}

				// Récupérer le lib du clicode
				if (paramOut.getNom().equals("libclicode")) {
					bipForm.setLibclicode((String) paramOut.getValeur());
				}

				// Récupérer le lib de l'application
				if (paramOut.getNom().equals("libairt")) {
					bipForm.setLibairt((String) paramOut.getValeur());
				}
				
				if (paramOut.getNom().equals("perime")) {
					String sPerime = (String) paramOut.getValeur();
					logService.debug("Perime :" + sPerime);
					bipForm.setPerime(sPerime);
				}// if

				if (paramOut.getNom().equals("perimo")) {
					String sPerimo = (String) paramOut.getValeur();
					logService.debug("Perimo :" + sPerimo);
					bipForm.setPerimo(sPerimo);
				}// if				

			}// for
			if (msg) {
				// on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("PropoMassAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("PropoMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("PropoMassAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("PropoMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((BudgMassForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");

			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());

				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} 

		// ******* exécution de la procédure PL/SQL pour des totaux et du nb de
		// jours ouvrés
		try {
			vParamOut2 = jdbc.getResult(
					hParams, configProc, PACK_TOTAL);

			// pas besoin d'aller plus loin
			if (vParamOut2 == null) {
				logBipUser
						.debug("PropoMassAction-consulter(totaux) :!!! cancel forward  ");
				logBipUser.exit(signatureMethode);
				 jdbc.closeJDBC(); return mapping.findForward("suite");
			}
			// Récupération des résultats
			for (Enumeration e = vParamOut2.elements(); e.hasMoreElements();) {
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
							bipForm.setTot_bpmontme(rset.getString(1));
							bipForm.setTot_bpmontmo(rset.getString(2));

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
								.debug("PropoMassAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("PropoMassAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						 jdbc.closeJDBC(); return mapping.findForward("error");
					}
				} // if
			} // for
			if (msg) {
				// on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		} // try
		catch (BaseException be) {
			logBipUser.debug("PropoMassAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("PropoMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("PropoMassAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("PropoMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((BudgMassForm) form).setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		} 

		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_TABLEAU);

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
							vListe.add(new Propose(rset.getString(1), rset
									.getString(2), rset.getString(3), rset
									.getString(4), rset.getString(5), rset
									.getString(6), rset.getString(7), rset
									.getString(8), rset.getString(9), rset
									.getString(10), rset.getString(11),
									rset.getString(12),rset.getString(13),
									rset.getString(14),rset.getString(15),rset.getString(16)));
											}
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("PropoMassAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("PropoMassAction-consulter() --> SQLException :"
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
			logBipUser.debug("PropoMassAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("PropoMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("PropoMassAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("PropoMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);
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

		if (bipForm.getBlocksize() != null)
			blocksize = Integer.parseInt(bipForm.getBlocksize());

		vueListe = new PaginationVector(vListe, blocksize);

		// Stocker le résultat dans la session
		(request.getSession(false)).setAttribute(PROPOSE_EN_MASSE, vueListe);
		// Stocker le résultat dans le formulaire
		bipForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");

	}

	/**
	 * Méthode valider : Met à jour les proposés dans la base de données
	 */
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParams)
			throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String pid;
		String flaglock;
		String proposeME;
		String proposeMO;
		String annee;
		String chaine = ";";
		String save;
		HttpSession session = request.getSession(false);

		String signatureMethode = "PropoMassAction-valider(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		PaginationVector page = (PaginationVector) session
				.getAttribute(PROPOSE_EN_MASSE);

		// On sauvegarde les données du formulaire
		savePage(mapping, form, request, response, errors);

		BudgMassForm bipForm = ((BudgMassForm) form);

		// On construit la chaîne qui doit être passé en paramètre de la forme
		// ;annee;pid;flaglock;bpmontme; (on bpmontmo)
		annee = ((BudgMassForm) form).getAnnee();
		chaine = chaine + annee + ";";

		for (Enumeration e = page.elements(); e.hasMoreElements();) {
			Propose PropoMass = (Propose) e.nextElement();
			proposeME = null;
			proposeMO = null;

			pid = PropoMass.getPid();
			flaglock = PropoMass.getFlaglock();
			// proposé
			proposeME = PropoMass.getBpmontme();
			proposeMO = PropoMass.getBpmontmo();
			// flaglock
			if (flaglock == null) {
				flaglock = "0";
			}
			if (proposeME == null)
				proposeME = "";
			if (proposeMO == null)
				proposeMO = "";
			chaine = chaine + pid + ";" + flaglock + ";" + proposeME + ";"
					+ proposeMO + ";";
		}// for
		
		System.out.println(chaine);
		// Ajouter la chaine dans la hashtable des paramètres
		hParams.put("string", chaine);
		// on exécute la procedure PLSQL qui met à jour les proposés
		try {
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_UPDATE);

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
				((BudgMassForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);
			}

			// on sauvegarde en session la position de la ressource dans la
			// liste déroulante
			session.setAttribute("POSITIONCLIENT", bipForm.getPosClient());
			// on sauvegarde en session la position du scénario dans la liste
			// déroulante
			session.setAttribute("POSITIONAPPLI", bipForm.getPosAppli());
			// on sauvegarde en session do DPG
			session.setAttribute("CODSG", bipForm.getCodsg());
			// on sauvegarde l'année
			session.setAttribute("ANNEE", bipForm.getAnnee());

		}// try
		catch (BaseException be) {
			logBipUser.debug("PropoMassAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("PropoMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("PropoMassAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("PropoMassAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((BudgMassForm) form).setMsgErreur(message);
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

		save = bipForm.getSave();
		if (save.equals("OUI")) {
			 jdbc.closeJDBC(); return mapping.findForward("ecran");
		} else {
			// On détruit le tableau sauvegardé en session
			session.removeAttribute(PROPOSE_EN_MASSE);
			logBipUser.debug("Destruction de la liste des proposés en session");
			 jdbc.closeJDBC(); return mapping.findForward("initial");
		}

	}// valider

	/**
	 * Méthode savePage : Sauvegarde les proposés en session
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {

		String annee;
		String pid;
		String flaglock;
		String proposeME;
		String proposeMO;

		PaginationVector page = (PaginationVector) (request.getSession())
				.getAttribute(PROPOSE_EN_MASSE);
		BudgMassForm budget = (BudgMassForm) form;

		if (budget.getBlocksize() != null)
			blocksize = Integer.parseInt(budget.getBlocksize());

		// récupérer les champs modifiables
		for (int i = 1; i <= blocksize; i++) {
			pid = "pid_" + i;
			flaglock = "flaglock_" + i;
			proposeME = "bpmontme_" + i;
			proposeMO = "bpmontmo_" + i;

			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				Propose PropoMass = (Propose) e.nextElement();
				if (request.getParameter(pid) != null) {
					if ((request.getParameter(pid)).equals(PropoMass.getPid())) {
						// On met à jour le proposé MO ou le propose MO de la
						// ligne
						if (budget.getCodsg() != null) {
							PropoMass.setBpmontme(request
									.getParameter(proposeME));
						} else if (budget.getClicode() != null) {
							PropoMass.setBpmontmo(request
									.getParameter(proposeMO));
						}
					}// if
				}// if
			}// for
		} // for

		(request.getSession()).setAttribute(PROPOSE_EN_MASSE, page);

	}// savePage

	/*
	 * sauvegarde des mois anciens
	 */
	private void saveOldMonths(BudgMassForm bipForm) {

		bipForm.setOld_tot_bpmontme(bipForm.getTot_bpmontme());
		bipForm.setOld_tot_bpmontme(bipForm.getTot_bpmontme());

	}

}
