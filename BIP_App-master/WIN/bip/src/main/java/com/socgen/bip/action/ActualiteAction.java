package com.socgen.bip.action;

import java.io.IOException;
import java.io.InputStream;
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
import com.socgen.bip.commun.form.AutomateForm;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.ActualiteForm;
import com.socgen.bip.metier.Actualite;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author K. Hazard - 06/10/2004
 * 
 * Action de mise à jour des Actualites chemin : Administration/Gestion des
 * actualites pages : bActuAd.jsp et mActuAd.jsp pl/sql : actualite.sql
 */
public class ActualiteAction extends AutomateAction implements BipConstantes {
	public static final String TABLE_REMONTEE = "ACTUALITE";

	public static final String CHAMP_DATA = "FICHIER";

	private static String PACK_SELECT = "actualite.consulter.proc";

	private static String PACK_INSERT = "actualite.creer.proc";

	private static String PACK_UPDATE = "actualite.modifier.proc";

	private static String PACK_DELETE = "actualite.supprimer.proc";

	private static String PACK_LISTE = "actualites.liste.proc";

	private String nomProc;

	private int blocksize = 10;

	/**
	 * Action qui permet de créer une actualite
	 */
	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		String signatureMethode = "ActualiteAction-creer( mapping, form , request,  response,  errors )";

		// logService.entry(signatureMethode);;
		logBipUser.entry(signatureMethode);
		// exécution de la procédure PL/SQL

		// logService.exit(signatureMethode);
		logBipUser.exit(signatureMethode);

		return mapping.findForward("ecran");
	}// creer

	/**
	 * Action qui permet de visualiser les données liées à un code Actualite
	 * pour la modification et la suppression
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode = "ActualiteAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// Création d'une nouvelle form
		ActualiteForm bipForm = (ActualiteForm) form;

		// exécution de la procédure PL/SQL
		try {
			vParamOut = jdbc.getResult(hParamProc, configProc, PACK_SELECT);

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
							bipForm.setCode_actu(rset.getString(1));
							bipForm.setTitre(rset.getString(2));
							bipForm.setTexte(rset.getString(3));
							bipForm.setDate_affiche(rset.getString(4));
							bipForm.setDate_debut(rset.getString(5));
							bipForm.setDate_fin(rset.getString(6));
							bipForm.setValide(rset.getString(7));
							bipForm.setUrl(rset.getString(8));
							bipForm.setDerniere_minute(rset.getString(9));
							
							bipForm.setAlerte_actu(rset.getString(10));
							
							bipForm.setNom_fichier(rset.getString(11));
							bipForm.setMime_fichier(rset.getString(12));
							bipForm.setSize_fichier(rset.getInt(13));
							bipForm.setMsgErreur(null);

						} else
							msg = true;
					}// try
					catch (SQLException sqle) {
						logService
								.debug("ActualiteAction-consulter() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("ActualiteAction-consulter() --> SQLException :"
										+ sqle);
						// Erreur de lecture du resultSet
						errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
								"11217"));
						// this.saveErrors(request,errors);
						jdbc.closeJDBC(); return mapping.findForward("error");
					} finally {
						try {
							if (rset != null)
								rset.close();
						} catch (SQLException sqle) {
							logBipUser
									.debug("ActualiteAction-suite() --> SQLException-rset.close() :"
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
				// le code Actualite n'existe pas, on récupère le message
				bipForm.setMsgErreur(message);
				// on reste sur la même page
				jdbc.closeJDBC(); return mapping.findForward("initial");
			}
		}// try
		catch (BaseException be) {
			logBipUser.debug("ActualiteAction-consulter() --> BaseException :"
					+ be, be);
			logBipUser.debug("ActualiteAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("ActualiteAction-consulter() --> BaseException :"
					+ be, be);
			logService.debug("ActualiteAction-consulter() --> Exception :"
					+ be.getInitialException().getMessage());
			// Si exception sql alors extraire le message d'erreur du message
			// global
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((ActualiteForm) form).setMsgErreur(message);
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

	protected ActionForward annuler(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
		HttpSession session = request.getSession(false);

		String signatureMethode = "actualitesAction-annuler( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		// On détruit le tableau sauvegardé en session
		session.removeAttribute(ACTUALITES);
		logBipUser.debug("Destruction de la liste des proposés en session");

		logBipUser.exit(signatureMethode);

		return mapping.findForward("initial");
	}

	/**
	 * Méthode consulter : Affichage des données dont le tableau des proposés
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		Vector vListe = new Vector();
		PaginationVector vueListe;

		String signatureMethode = "actualitesAction-suite(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);

		// Récupération du form
		AutomateForm bipForm = (AutomateForm) form;

		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult( hParams, configProc, PACK_LISTE);

			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();

				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();

					try {
						while (rset.next()) {
							// On alimente le Bean Actualite et on le stocke
							// dans un vector
							vListe.add(new Actualite(rset.getString(1), rset
									.getString(2), rset.getString(3), rset
									.getString(4), rset.getString(5), rset
									.getString(6), rset.getString(7)));
						}
						if (rset != null)
							rset.close();
					}// try
					catch (SQLException sqle) {
						logService
								.debug("actualitesAction-suite() --> SQLException :"
										+ sqle);
						logBipUser
								.debug("actualitesAction-suite() --> SQLException :"
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
			logBipUser.debug("actualitesAction-suite() --> BaseException :"
					+ be, be);
			logBipUser.debug("actualitesAction-suite() --> Exception :"
					+ be.getInitialException().getMessage());

			logService.debug("actualitesAction-suite() --> BaseException :"
					+ be, be);
			logService.debug("actualitesAction-suite() --> Exception :"
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
		vueListe = new PaginationVector(vListe, blocksize);

		// Stocker le résultat dans la session
		(request.getSession(false)).setAttribute(ACTUALITES, vueListe);
		// Stocker le résultat dans le formulaire
		bipForm.setListePourPagination(vueListe);

		logBipUser.exit(signatureMethode);

		jdbc.closeJDBC(); return mapping.findForward("suite");

	}

	/**
	 * Method pageIndex.
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param errors
	 * @return ActionForward
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

	protected ActionForward valider(ActionMapping mapping, ActionForm form,
			String mode, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors,
			Hashtable hParamProctest) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vParamOut = new Vector();
		String cle = null;
		String message = null;
		String top_update_fichier = "O";

		String signatureMethode = "valider(ActionMapping mapping, ActionForm form, String mode, HttpServletRequest request, HttpServletResponse response, ActionErrors errors )";
		logBipUser.entry(signatureMethode);
		logBipUser.debug("mode de mise à jour:" + mode);
		// On récupère la clé pour trouver le nom de la procédure stockée dans
		// bip_proc.properties
		cle = recupererCle(mode);

		// On exécute la procédure stockée
		try {
			if (!mode.equals("delete")) {
				if (!((ActualiteForm) form).getNom_fichier().equals(""))

					// en mode update, top pour autoriser la mise à jour des
					// données relatives au fichier joint.
					top_update_fichier = "N";
				//

				hParamProctest.put("top_update_fichier", top_update_fichier);
				String pNom_fichier = ((ActualiteForm) form).getFichier()
						.getFileName();
				((ActualiteForm) form).setNom_fichier(pNom_fichier);
				hParamProctest.put("nom_fichier", pNom_fichier);
				String pMime_fichier = ((ActualiteForm) form).getFichier()
						.getContentType();
				((ActualiteForm) form).setMime_fichier(pMime_fichier);
				hParamProctest.put("mime_fichier", pMime_fichier);
				int pSize_fichier = ((ActualiteForm) form).getFichier()
						.getFileSize();
				((ActualiteForm) form).setSize_fichier(pSize_fichier);
				hParamProctest.put("size_fichier", (new java.lang.Integer(
						pSize_fichier)).toString());
			}
			vParamOut = jdbc.getResult( hParamProctest, configProc, cle);
			if (mode.equals("insert")
					|| (mode.equals("update") && top_update_fichier.equals("O"))) {
				try {
					for (Enumeration e = vParamOut.elements(); e
							.hasMoreElements();) {
						ParametreProc paramOut = (ParametreProc) e
								.nextElement();

						// cas de la création
						if (paramOut.getNom().equals("code_actu")) {
							((ActualiteForm) form)
									.setCode_actu((String) paramOut.getValeur());
						}

					}// for
					InputStream uploadFichier = ((ActualiteForm) form)
							.getFichier().getInputStream();
					String sCode_actu = ((ActualiteForm) form).getCode_actu();

				jdbc.alimBLOB(jdbc.DATASOURCE_ACTU, TABLE_REMONTEE,
						CHAMP_DATA, "CODE_ACTU='" + sCode_actu + "'",
						uploadFichier);
				} catch (IOException ioe) {
					logBipUser.debug("valider() --> IOException :" + ioe);
					logBipUser.debug("valider() --> Exception :"
							+ ioe.getMessage());
					logService.debug("valider() --> IOException :" + ioe);
					logService.debug("valider() --> Exception :"
							+ ioe.getMessage());
					errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
							"11217"));
					jdbc.closeJDBC(); return mapping.findForward("error");
				}
			}
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
			if (be.getInitialException().getClass().getName().equals(
					"java.sql.SQLException")) {
				message = BipException.getMessageFocus(
						BipException.getMessageOracle(be.getInitialException()
								.getMessage()), form);
				((AutomateForm) form).setMsgErreur(message);

				if (!mode.equals("delete")) {
					jdbc.closeJDBC(); return mapping.findForward("ecran");
				}
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

}
