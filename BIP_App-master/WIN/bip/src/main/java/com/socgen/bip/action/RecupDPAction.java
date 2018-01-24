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
import com.socgen.bip.form.RecupDPCopiForm;
import com.socgen.bip.metier.InfosDpCopi;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

/**
 * @author EVI 24/04/2008 Action permettant de récupérer un code DP COPI via une
 *         fenêtre Popup
 */

public class RecupDPAction extends AutomateAction {
	
	private static String PACK_SELECT = "recup.id.dpcopi.proc";

 
	
	
	/**
	 * Constructor for RecupDPCopiAction.
	 */
	public RecupDPAction() {
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
				+ " - RecupDPCopi creer(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		RecupDPCopiForm rechercheForm = (RecupDPCopiForm) form;
		// Détruit la liste de la session si elle existait suite à uen recherche
		if (request.getSession(false).getAttribute(LISTE_RECHERCHE_DPCOPI) != null)
			request.getSession(false).removeAttribute(LISTE_RECHERCHE_DPCOPI);
		try {
			rechercheForm.setAction("modifier");
			rechercheForm.setListePourPagination(null);
			request.setAttribute("RecupDPCopiForm", rechercheForm);
		} catch (Exception ex) {
			return mapping.findForward(processSsimpleException(this.getClass()
					.getName(), "consulter", ex, rechercheForm, request));
		}
		logBipUser.exit(signatureMethode);
		return mapping.findForward("ecran");
	}

	/**
	 * Méthode permettant de lister l'ensemble des codes DP COPI commençant par le
	 * texte saisi
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
		RecupDPCopiForm rechercheForm = (RecupDPCopiForm) form;
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
							logBipUser.entry("rset.getString(1):!!"+rset.getString(1)+" 2:"+rset.getString(2));
							hrefId =  rset.getString(1) ;
							vListe.add(new InfosDpCopi(rset.getString(1), rset
									.getString(2), buildUrl(hrefId)));
							compteur += 1;
						}
						 
						if (rset != null)
							 
							rset.close();
						PaginationVector vueListe = new PaginationVector(
								vListe, linesPerPage);
						request.setAttribute(LISTE_RECHERCHE_DPCOPI, vueListe);
						(request.getSession(false)).setAttribute(
								LISTE_RECHERCHE_DPCOPI, vueListe);
						rechercheForm.setListePourPagination(vueListe);
					}// try
					catch (SQLException sqle) {
						 
						if (request.getSession(false).getAttribute(
								LISTE_RECHERCHE_DPCOPI) != null)
							request.getSession(false).removeAttribute(
									LISTE_RECHERCHE_DPCOPI);
						logBipUser.exit(signatureMethode);
						 jdbc.closeJDBC(); return mapping.findForward(processException(this
								.getClass().getName(), "consulter", sqle,
								rechercheForm, request));
					}
				}// if
			}// for
		}// try
		catch (BaseException be) {
			 
			if (request.getSession(false).getAttribute(LISTE_RECHERCHE_DPCOPI) != null)
				request.getSession(false).removeAttribute(LISTE_RECHERCHE_DPCOPI);
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward(processBaseExceptionRecup(
					"RecupDPCopiForm", this.getClass().getName(), "consulter", be,
					rechercheForm, request));
		}
		logBipUser.exit(signatureMethode);
		request.setAttribute("RecupDPCopiForm", rechercheForm);
		
		 
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
		RecupDPCopiForm rechercheForm = (RecupDPCopiForm) form;
		if (page != null) {
			page.setBlock(Integer.parseInt(index));
			request.setAttribute("RecupDPCopiForm", rechercheForm);
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
		RecupDPCopiForm rechercheForm = (RecupDPCopiForm) form;
		if (page != null) {
			page.getNextBlock();
			request.setAttribute("RecupDPCopiForm", rechercheForm);
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
		RecupDPCopiForm rechercheForm = (RecupDPCopiForm) form;
		
		if (page != null) {
			page.getPreviousBlock();
			request.setAttribute("RecupDPCopiForm", rechercheForm);
			return mapping.findForward("suite");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			 return mapping.findForward("error");
		}
	}

	public String buildUrl(String dpcopi) {
		 return ("<a href=\"javascript:fill('" + dpcopi + "');\">");
	} 
 
	
	
}