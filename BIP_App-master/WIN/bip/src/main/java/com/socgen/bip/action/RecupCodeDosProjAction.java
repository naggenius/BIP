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
import com.socgen.bip.form.RecupCodeDosProjForm;
import com.socgen.bip.metier.InfosDossierProjet;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

public class RecupCodeDosProjAction extends AutomateAction {

	private static String PACK_SELECT = "recup.id.dosproj.proc";
	
	

	/**
	 * Constructor for RecupCodeDosProjAction.
	 */
	public RecupCodeDosProjAction() {
		super();
	}

	/**
	 * Action permettant le premier appel de la JSP
	 */
	protected ActionForward initialiser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		String signatureMethode = this.getClass().getName()
				+ " - creer(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		RecupCodeDosProjForm rechercheForm = (RecupCodeDosProjForm) form;
		// Détruit la liste de la session si elle existait suite à uen recherche
		if (request.getSession(false).getAttribute(LISTE_RECHERCHE_DOS_PROJ) != null)
			request.getSession(false).removeAttribute(LISTE_RECHERCHE_DOS_PROJ);
		try {
			rechercheForm.setAction("modifier");
			rechercheForm.setListePourPagination(null);
			request.setAttribute("RecupCodeDosProjForm", rechercheForm);
		} catch (Exception ex) {
			 return mapping.findForward(processSsimpleException(this.getClass()
					.getName(), "consulter", ex, rechercheForm, request));
		}
		logBipUser.exit(signatureMethode);
		 return mapping.findForward("ecran");
	}

	/**
	 * Méthode permettant de lister l'ensemble de code dossier de projet
	 * commençant par le texte saisi
	 */
	protected ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParams) throws ServletException {
		
		JdbcBip jdbc = new JdbcBip(); 
		Vector vListe = new Vector();
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		String signatureMethode = this.getClass().getName()
				+ " - consulter(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		RecupCodeDosProjForm rechercheForm = (RecupCodeDosProjForm) form;
		int linesPerPage = 10;
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
						int hrefId;
						while (rset.next()) {
							// On alimente le Bean Propose et on le stocke dans
							// un vector
							hrefId = Integer.parseInt(rset.getString(1));
							vListe.add(new InfosDossierProjet(
									rset.getString(1), rset.getString(2),
									buildUrl(hrefId)));
						}
						if (rset != null)
							rset.close();
						PaginationVector vueListe = new PaginationVector(
								vListe, linesPerPage);
						request
								.setAttribute(LISTE_RECHERCHE_DOS_PROJ,
										vueListe);
						(request.getSession(false)).setAttribute(
								LISTE_RECHERCHE_DOS_PROJ, vueListe);
						rechercheForm.setListePourPagination(vueListe);
					} catch (SQLException sqle) {
						if (request.getSession(false).getAttribute(
								LISTE_RECHERCHE_DOS_PROJ) != null)
							request.getSession(false).removeAttribute(
									LISTE_RECHERCHE_DOS_PROJ);
						logBipUser.exit(signatureMethode);
						 jdbc.closeJDBC(); return mapping.findForward(processException(this
								.getClass().getName(), "consulter", sqle,
								rechercheForm, request));
					}
				}
			}
		} catch (BaseException be) {
			if (request.getSession(false)
					.getAttribute(LISTE_RECHERCHE_DOS_PROJ) != null)
				request.getSession(false).removeAttribute(
						LISTE_RECHERCHE_DOS_PROJ);
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward(processBaseExceptionRecup(
					"RecupCodeDosProjForm", this.getClass().getName(),
					"consulter", be, rechercheForm, request));
		}
		logBipUser.exit(signatureMethode);
		request.setAttribute("RecupCodeDosProjForm", rechercheForm);
		 jdbc.closeJDBC(); return mapping.findForward("ecran");
	}

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
		RecupCodeDosProjForm rechercheForm = (RecupCodeDosProjForm) form;
		if (page != null) {
			page.setBlock(Integer.parseInt(index));
			request.setAttribute("RecupCodeDosProjForm", rechercheForm);
			actionForward = mapping.findForward("suite");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			actionForward = mapping.findForward("error");
		}

		 return actionForward;

	}

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
		RecupCodeDosProjForm rechercheForm = (RecupCodeDosProjForm) form;
		if (page != null) {
			page.getNextBlock();
			request.setAttribute("RecupCodeDosProjForm", rechercheForm);
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
		RecupCodeDosProjForm rechercheForm = (RecupCodeDosProjForm) form;
		if (page != null) {
			page.getPreviousBlock();
			request.setAttribute("RecupCodeDosProjForm", rechercheForm);
			  return mapping.findForward("suite");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			 return mapping.findForward("error");
		}
	}

	public String buildUrl(int idDosProj) {
		 return ("<a href=\"javascript:fill('" + idDosProj + "');\">");
	}
}