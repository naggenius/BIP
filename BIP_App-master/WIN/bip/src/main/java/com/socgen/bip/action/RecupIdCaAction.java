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
import com.socgen.bip.form.RecupIdCaForm;
import com.socgen.bip.metier.InfosCa;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author MMC - 22/06/2005
 * 
 * Action permettant de récupérer un ID d'une personne via une fenêtre Popup
 * 
 * 
 */

public class RecupIdCaAction extends AutomateAction {

	private static String PACK_SELECT = "recup.id.ca.proc";

	private int blocksize = 10;
	


	// private String HABILITATION_LIGNES_BIP_MAJTABLES =
	// "HabilitationLigneBip";

	/**
	 * Constructor for RecupIdPersonneAction.
	 */
	public RecupIdCaAction() {
		super();
	}

	/**
	 * Action permettant le premier appel de la JSP
	 * 
	 */
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		Vector vParamOut = new Vector();
		String signatureMethode = this.getClass().getName()
				+ " - creer(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		RecupIdCaForm rechercheForm = (RecupIdCaForm) form;
		// Détruit la liste de la session si elle existait suite à uen recherche
		if (request.getSession(false).getAttribute(LISTE_RECHERCHE_ID_CA) != null)
			request.getSession(false).removeAttribute(LISTE_RECHERCHE_ID_CA);
		try {
			rechercheForm.setAction("modifier");
			rechercheForm.setListePourPagination(null);
			rechercheForm.setEmptyResult(false);
			request.setAttribute("RecupIdCaForm", rechercheForm);
		} catch (Exception ex) {
			return mapping.findForward(processSsimpleException(this.getClass()
					.getName(), "consulter", ex, rechercheForm, request));
		}
		logBipUser.exit(signatureMethode);
		 return mapping.findForward("ecran");
	}

	/**
	 * Méthode permettant de lister l'ensemble des noms de chefs de projet
	 * commençant par le texte saisi
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
		RecupIdCaForm rechercheForm = (RecupIdCaForm) form;
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
					rechercheForm.setEmptyResult(false);
					try {
						int hrefId;
						while (rset.next() && compteur < 99) {
							// On alimente le Bean Propose et on le stocke dans
							// un vector
							hrefId = Integer.parseInt(rset.getString(1));
							vListe.add(new InfosCa(rset.getString(1), rset
									.getString(2), rset.getString(3),
									buildUrl(hrefId)));
							compteur++;
						}
						if (rset != null)
							rset.close();
						PaginationVector vueListe = new PaginationVector(
								vListe, linesPerPage);
						request.setAttribute(LISTE_RECHERCHE_ID_CA, vueListe);
						(request.getSession(false)).setAttribute(
								LISTE_RECHERCHE_ID_CA, vueListe);
						rechercheForm.setListePourPagination(vueListe);
						rechercheForm.setEmptyResult(false);
					}// try
					catch (SQLException sqle) {
						if (request.getSession(false).getAttribute(
								LISTE_RECHERCHE_ID_CA) != null)
							request.getSession(false).removeAttribute(
									LISTE_RECHERCHE_ID_CA);
						logBipUser.exit(signatureMethode);
						 jdbc.closeJDBC(); return mapping.findForward(processException(this
								.getClass().getName(), "consulter", sqle,
								rechercheForm, request));
					}
				} else {
					rechercheForm.setListePourPagination(null);
					rechercheForm.setEmptyResult(true);
				}// if
			}// for
		}// try
		catch (BaseException be) {

			if (request.getSession(false).getAttribute(LISTE_RECHERCHE_ID_CA) != null)
				request.getSession(false)
						.removeAttribute(LISTE_RECHERCHE_ID_CA);
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward(processBaseExceptionRecup(
					"RecupIdCaForm", this.getClass().getName(), "consulter",
					be, rechercheForm, request));

		}
		logBipUser.exit(signatureMethode);
		request.setAttribute("RecupIdCaForm", rechercheForm);
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
		RecupIdCaForm rechercheForm = (RecupIdCaForm) form;
		if (page != null) {
			page.setBlock(Integer.parseInt(index));
			request.setAttribute("RecupIdCaForm", rechercheForm);
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
		RecupIdCaForm rechercheForm = (RecupIdCaForm) form;
		if (page != null) {
			page.getNextBlock();
			request.setAttribute("RecupIdCaForm", rechercheForm);
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
		RecupIdCaForm rechercheForm = (RecupIdCaForm) form;
		if (page != null) {
			page.getPreviousBlock();
			request.setAttribute("RecupIdCaForm", rechercheForm);
			  return mapping.findForward("suite");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			return mapping.findForward("error");
		}
	}

	public String buildUrl(int idPersonne) {
		return ("<a href=\"javascript:fill('" + idPersonne + "');\">");
	}

}