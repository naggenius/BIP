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
import com.socgen.bip.form.RecupIdProjetForm;
import com.socgen.bip.metier.InfosProjet;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author DDI - 23/09/2005 Action permettant de récupérer un code Projet via
 *         une fenêtre Popup
 */

public class RecupIdProjetAction extends AutomateAction {
	private static String PACK_SELECT = "recup.id.projet.proc";

	private int blocksize = 10;

	private String HABILITATION_LIGNES_BIP = "HabilitationLigneBip";

	private String HABILITATION_RESTIME = "HabilitationRestime";

	private String HABILITATION_RESSOURCES = "HabilitationRessources";

	
	
	/**
	 * Constructor for RecupIdProjetAction.
	 */
	public RecupIdProjetAction() {
		super();
	}

	/**
	 * Action permettant le premier appel de la JSP
	 */
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		Vector vParamOut = new Vector();
		String signatureMethode = this.getClass().getName()
				+ " - creer(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		RecupIdProjetForm rechercheForm = (RecupIdProjetForm) form;
		// Détruit la liste de la session si elle existait suite à uen recherche
		if (request.getSession(false).getAttribute(LISTE_RECHERCHE_ID) != null)
			request.getSession(false).removeAttribute(LISTE_RECHERCHE_ID);
		try {
			rechercheForm.setAction("modifier");
			rechercheForm.setListePourPagination(null);
			request.setAttribute("RecupIdProjetForm", rechercheForm);
		} catch (Exception ex) {
			  return mapping.findForward(processSsimpleException(this.getClass()
					.getName(), "consulter", ex, rechercheForm, request));
		}
		logBipUser.exit(signatureMethode);
		return mapping.findForward("ecran");
	}

	/**
	 * Méthode permettant de lister l'ensemble des codes Projet commençant par
	 * le texte saisi
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vListe = new Vector();
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;
		String signatureMethode = this.getClass().getName()
				+ " - consulter(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		RecupIdProjetForm rechercheForm = (RecupIdProjetForm) form;
		int linesPerPage = 10;
		int compteur = 0;
		// On exécute la procédure PL/SQL qui ramène les résultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_SELECT);
			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						String hrefId;
						while (rset.next() && compteur < 99) {
							// On alimente le Bean Propose et on le stocke dans
							// un vector
							hrefId = rset.getString(1);
							vListe.add(new InfosProjet(rset.getString(1), rset
									.getString(2), buildUrl(hrefId)));
							compteur++;
						}
						if (rset != null)
							rset.close();
						PaginationVector vueListe = new PaginationVector(
								vListe, linesPerPage);
						request.setAttribute(LISTE_RECHERCHE_ID, vueListe);
						(request.getSession(false)).setAttribute(
								LISTE_RECHERCHE_ID, vueListe);
						rechercheForm.setListePourPagination(vueListe);
					}// try
					catch (SQLException sqle) {
						if (request.getSession(false).getAttribute(
								LISTE_RECHERCHE_ID) != null)
							request.getSession(false).removeAttribute(
									LISTE_RECHERCHE_ID);
						logBipUser.exit(signatureMethode);
						 jdbc.closeJDBC(); return mapping.findForward(processException(this
								.getClass().getName(), "consulter", sqle,
								rechercheForm, request));
					}
				}// if
			}// for
		}// try
		catch (BaseException be) {
			if (request.getSession(false).getAttribute(LISTE_RECHERCHE_ID) != null)
				request.getSession(false).removeAttribute(LISTE_RECHERCHE_ID);
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward(processBaseExceptionRecup(
					"RecupIdProjetForm", this.getClass().getName(),
					"consulter", be, rechercheForm, request));

		}
		logBipUser.exit(signatureMethode);
		request.setAttribute("RecupIdProjetForm", rechercheForm);
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}// consulter

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
		RecupIdProjetForm rechercheForm = (RecupIdProjetForm) form;
		if (page != null) {
			page.setBlock(Integer.parseInt(index));
			request.setAttribute("RecupIdProjetForm", rechercheForm);
			actionForward = mapping.findForward("suite");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
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
		RecupIdProjetForm rechercheForm = (RecupIdProjetForm) form;
		if (page != null) {
			page.getNextBlock();
			request.setAttribute("RecupIdProjetForm", rechercheForm);
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
		RecupIdProjetForm rechercheForm = (RecupIdProjetForm) form;
		if (page != null) {
			page.getPreviousBlock();
			request.setAttribute("RecupIdProjetForm", rechercheForm);
			  return mapping.findForward("suite");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			 return mapping.findForward("error");
		}
	}

	public String buildUrl(String idProjet) {
		return ("<a href=\"javascript:fill('" + idProjet + "');\">");
	}

}