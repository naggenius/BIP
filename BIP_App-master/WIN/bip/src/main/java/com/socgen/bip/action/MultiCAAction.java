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
import com.socgen.bip.form.MultiCAForm;
import com.socgen.bip.metier.MultiCA;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author P.JOSSE - 02/12/2004
 * 
 * Action de mise à jour des CA d'une ligne BIP multi-CA chemin :
 * Administration/Ligne Bip/Multi CA pages : fMulticaAd.jsp et bMulticaAd.jsp
 * pl/sql : multi_ca.sql, ls_ca_ligne_bip.sql
 */
public class MultiCAAction extends AutomateAction implements BipConstantes {
	private static String PACK_SELECT = "multi_ca.consulter.proc";

	private static String PACK_UPDATE = "multi_ca.modifier.proc";

	private static String PACK_VERIF_MULTI_CA = "multi_ca.verif_multi_ca.proc";

	private static String PACK_TABLEAU = "multi_ca.tableau.proc";

	private static int BLOCKSIZE = 10;
	
	

	/**
	 * Constructor for MultiCAAction.
	 */
	public MultiCAAction() {
		super();
	}

	/**
	 * Action qui permet de passer à la page première page avec destruction du
	 * tableau en session
	 */
	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		HttpSession session = request.getSession(false);

		String signatureMethode = "ReestMassAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On détruit le tableau sauvegardé en session
		session.removeAttribute(MULTI_CA);
		logBipUser.debug("Destruction de la liste des multi CA en session");
		logBipUser.exit(signatureMethode);

		 return mapping.findForward("initial");
	}

	/**
	 * Méthode consulter : Affichage des données dont le tableau des CA
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		Vector vListe = new Vector();
		PaginationVector vueListe;

		String signatureMethode = "MultiCAAction-consulter(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Création d'une nouvelle form
		MultiCAForm bipForm = (MultiCAForm) form;

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
				// Récupérer le lib du pid
				if (paramOut.getNom().equals("pnom")) {
					bipForm.setPnom((String) paramOut.getValeur());
				}
				// Récupérer l'année d'exercice
				if (paramOut.getNom().equals("anneeExercice")) {
					bipForm.setAnneeExercice((String) paramOut.getValeur());
				}

			}// for
			if (msg) {
				// on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				 jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("MultiCAAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("MultiCAAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug("MultiCAAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("MultiCAAction-consulter() --> Exception :"
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
							// On alimente le Bean reestime et on le stocke dans
							// un vector
							vListe.add(new MultiCA(rset.getString(1), rset
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
								.debug("MultiCAAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("MultiCAAction-consulter() --> SQLException :"
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
			logBipUser.debug("MultiCAAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("MultiCAAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("MultiCAAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("MultiCAAction-consulter() --> Exception :"
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
		vueListe = new PaginationVector(vListe, BLOCKSIZE);

		// Stocker le résultat dans la session
		(request.getSession(false)).setAttribute(MULTI_CA, vueListe);
		// Stocker le résultat dans le formulaire
		bipForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

	/**
	 * Méthode valider : Met à jour les reestimés dans la base de données
	 */
	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors, Hashtable hParams)
			throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		// boolean msg=false;
		// ParametreProc paramOut;
		// String pid;
		String datdeb;
		String codcamo;
		String clicode;
		String tauxrep;
		String chaine = ";";
		HttpSession session = request.getSession(false);

		String signatureMethode = "MultiCAAction-valider(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		PaginationVector page = (PaginationVector) (request.getSession())
				.getAttribute(MULTI_CA);

		// On sauvegarde les données du formulaire
		savePage(mapping, form, request, response, errors);

		// On construit la chaîne qui doit être passé en paramètre de la forme
		// ;datdeb;codcamo;clicode;tauxrep;
		for (Enumeration e = page.elements(); e.hasMoreElements();) {
			MultiCA multiCA = (MultiCA) e.nextElement();
			datdeb = multiCA.getDatdeb();
			codcamo = multiCA.getCodcamo();
			clicode = multiCA.getClicode();
			if (clicode == null)
				clicode = "";
			tauxrep = multiCA.getTauxrep();
			chaine = chaine + datdeb + ";" + codcamo + ";" + clicode + ";"
					+ tauxrep + ";";
		}// for

		// Ajouter la chaine dans la hashtable des paramètres
		hParams.put("string", chaine);
		// on exécute la procedure PLSQL qui met à jour les CA
		try {
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_UPDATE);
			// On détruit le tableau sauvegardé en session
			session.removeAttribute(MULTI_CA);
			logBipUser.debug("Destruction de la liste des CA en session");
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
				((MultiCAForm) form).setMsgErreur(message);
				logBipUser.debug("valider() -->message :" + message);
			}

		}// try
		catch (BaseException be) {
			logBipUser.debug(
					"MultiCAAction-valider() --> BaseException :" + be, be);
			logBipUser.debug("MultiCAAction-valider() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"MultiCAAction-valider() --> BaseException :" + be, be);
			logService.debug("MultiCAAction-valider() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((MultiCAForm) form).setMsgErreur(message);
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
	 * Methode refresh : vérif si c'est un bon code CA et ajout dans la liste
	 */
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		ParametreProc paramOut;
		// Vector vListe = new Vector();
		Vector multiCA;
		String libCA = "";
		String clilib = "";

		String signatureMethode = "MultiCAAction-refresh(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Récupération du formulaire
		MultiCAForm bipForm = (MultiCAForm) form;

		// exécution de la procédure PL/SQL pour affichage du sigle du code
		// client MO
		try {
			// On sauvegarde les données du formulaire
			savePage(mapping, form, request, response, errors);

			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_VERIF_MULTI_CA);
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
					}
				}

				// récupérer le libellé du CA
				if (paramOut.getNom().equals("libca")) {
					libCA = (String) paramOut.getValeur();
				}

				// récupérer le libellé du client MO
				if (paramOut.getNom().equals("clilib")) {
					clilib = (String) paramOut.getValeur();
					if (clilib == null)
						clilib = "";
				}
			}// for

			// Si le message est vide, on ajoute l'item dans la liste
			if ((message == null) || ("".equals(message))) {
				multiCA = (Vector) (request.getSession())
						.getAttribute(MULTI_CA);
				multiCA.insertElementAt(new MultiCA(bipForm.getPid(), bipForm
						.getDatdeb(), null, bipForm.getCodcamo(), libCA,
						bipForm.getClicode(), clilib, bipForm.getTauxrep()), 0);
				// On lance la procédure qui permet une repagination
				(request.getSession()).setAttribute(MULTI_CA,
						new PaginationVector(multiCA, BLOCKSIZE));

				// On remet à vide les champs
				bipForm.setDatdeb("");
				bipForm.setCodcamo("");
				bipForm.setClicode("");
				bipForm.setTauxrep("");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug(
					"MultiCAAction-refresh() --> BaseException :" + be, be);
			logBipUser.debug("MultiCAAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());
			logService.debug(
					"MultiCAAction-refresh() --> BaseException :" + be, be);
			logService.debug("MultiCAAction-refresh() --> Exception :"
					+ be.getInitialException().getMessage());

			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				bipForm.setMsgErreur(message);
				 jdbc.closeJDBC(); return mapping.findForward("error");
			} else {
				// Erreur d''exécution de la procédure stockée
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError("11201"));
				request.setAttribute("messageErreur", be.getInitialException()
						.getMessage());
				 jdbc.closeJDBC(); return mapping.findForward("error");
			}
		}
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// refresh

	/**
	 * Méthode savePage : Sauvegarde les reestimés en session
	 */
	protected void savePage(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors) {
		String pid;
		String datdeb;
		String codcamo;
		String tauxrep;

		PaginationVector page = (PaginationVector) (request.getSession())
				.getAttribute(MULTI_CA);
		// récupérer les champs modifiables
		for (int i = 1; i <= BLOCKSIZE; i++) {
			pid = "pid_" + i;
			datdeb = "datdeb_" + i;
			codcamo = "codcamo_" + i;
			tauxrep = "tauxrep_" + i;

			for (Enumeration e = page.elements(); e.hasMoreElements();) {
				MultiCA multiCA = (MultiCA) e.nextElement();
				if (request.getParameter(pid) != null) {
					if ((request.getParameter(pid)).equals(multiCA.getPid())
							&& (request.getParameter(datdeb)).equals(multiCA
									.getDatdeb())
							&& (request.getParameter(codcamo)).equals(multiCA
									.getCodcamo())) {
						// On met à jour le taux de facturation de la ligne
						multiCA.setTauxrep(request.getParameter(tauxrep));
					}// if
				}// if
			}// for
		} // for

		(request.getSession()).setAttribute(MULTI_CA, page);
	}// savePage
}
