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
import com.socgen.bip.form.RecupIdDirectionForm;
import com.socgen.bip.metier.InfosDirection;
import com.socgen.cap.fwk.exception.BaseException;
import com.socgen.ich.ihm.menu.PaginationVector;

public class RecupIdDirectionAction extends AutomateAction {

	private static String PACK_SELECT = "recup.id.direction.proc";

	

		


	/**
	 * Constructor for RecupIdPersonneAction.
	 */
	public RecupIdDirectionAction() {
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
		RecupIdDirectionForm rechercheForm = (RecupIdDirectionForm) form;
		// D�truit la liste de la session si elle existait suite � uen recherche
		if (request.getSession(false).getAttribute(LISTE_RECHERCHE_ID_DIRECTION) != null)
			request.getSession(false).removeAttribute(
					LISTE_RECHERCHE_ID_DIRECTION);
		try {
			rechercheForm.setAction("modifier");
			rechercheForm.setListePourPagination(null);
			request.setAttribute("RecupIdDirectionForm", rechercheForm);
			consulter(mapping,form,request,response,errors,hParams);
		} catch (Exception ex) {
			 return mapping.findForward(processSsimpleException(this.getClass()
					.getName(), "consulter", ex, rechercheForm, request));
		}
		logBipUser.exit(signatureMethode);
		return mapping.findForward("ecran");
	}

	/**
	 * M�thode permettant de lister l'ensemble des noms de chefs de projet
	 * commen�ant par le texte saisi
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
		RecupIdDirectionForm rechercheForm = (RecupIdDirectionForm) form;
		int linesPerPage = 20;
		int compteur = 0;

	   // On ex�cute la proc�dure PL/SQL qui ram�ne les r�sultats pour le
		// tableau
		try {
			vParamOut = jdbc.getResult(hParams,
					configProc, PACK_SELECT);
			// R�cup�ration des r�sultats
			
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				if (paramOut.getNom().equals("curseur")) {
					// R�cup�ration du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						String hrefId;
						while (rset.next() && compteur < 99) {
							// On alimente le Bean Propose et on le stocke dans
							// un vector
							hrefId = rset.getString(1);
							vListe.add(new InfosDirection(rset.getString(1), rset
									.getString(2),
									buildUrl(hrefId)));
							compteur++;
						}
						if (rset != null)
							rset.close();
						PaginationVector vueListe = new PaginationVector(
								vListe, linesPerPage);
						request.setAttribute(LISTE_RECHERCHE_ID_DIRECTION,
								vueListe);
						(request.getSession(false)).setAttribute(
								LISTE_RECHERCHE_ID_DIRECTION, vueListe);
						rechercheForm.setListePourPagination(vueListe);
					}// try
					catch (SQLException sqle) {
						if (request.getSession(false).getAttribute(
								LISTE_RECHERCHE_ID_DIRECTION) != null)
							request.getSession(false).removeAttribute(
									LISTE_RECHERCHE_ID_DIRECTION);
						logBipUser.exit(signatureMethode);
						 jdbc.closeJDBC(); return mapping.findForward(processException(this
								.getClass().getName(), "consulter", sqle,
								rechercheForm, request));
					}
				}// if
			}// for
			// PaginationVector vueListe = new
			// PaginationVector(vueListe,linesPerPage);
			// request.setAttribute(LISTE_RECHERCHE_ID_DIRECTION, vueListe);
			// (request.getSession(false)).setAttribute(LISTE_RECHERCHE_ID_DIRECTION,
			// vueListe );
		}// try
		catch (BaseException be) {
			if (request.getSession(false).getAttribute(
					LISTE_RECHERCHE_ID_DIRECTION) != null)
				request.getSession(false).removeAttribute(
						LISTE_RECHERCHE_ID_DIRECTION);
			logBipUser.exit(signatureMethode);
			 jdbc.closeJDBC(); return mapping.findForward(processBaseExceptionRecup(
					"RecupIdDirectionForm", this.getClass().getName(),
					"consulter", be, rechercheForm, request));

		}
		logBipUser.exit(signatureMethode);
		request.setAttribute("RecupIdDirectionForm", rechercheForm);
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
		RecupIdDirectionForm rechercheForm = (RecupIdDirectionForm) form;
		if (page != null) {
			page.setBlock(Integer.parseInt(index));
			request.setAttribute("RecupIdDirectionForm", rechercheForm);
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
	 * Action envoy�e pour passer � la page suivante
	 * 
	 * @param request
	 *            la requ�te HTTP.
	 * @param response
	 *            la r�ponse HTTP.
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
		RecupIdDirectionForm rechercheForm = (RecupIdDirectionForm) form;
		if (page != null) {
			page.getNextBlock();
			request.setAttribute("RecupIdDirectionForm", rechercheForm);
			 return mapping.findForward("suite");

		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			 return mapping.findForward("error");
		}
	}

	/**
	 * Action envoy�e pour passer � la page pr�c�dente
	 * 
	 * @param request
	 *            la requ�te HTTP.
	 * @param response
	 *            la r�ponse HTTP.
	 */
	protected ActionForward pagePrecedente(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response, ActionErrors errors)
			throws ServletException {
		PaginationVector page;
		String pageName;
		// Extraction du nom de la page
		pageName = (String) request.getParameter("page");
		// Extraction de la liste � paginer
		page = (PaginationVector) request.getSession(false).getAttribute(
				pageName);
		RecupIdDirectionForm rechercheForm = (RecupIdDirectionForm) form;
		if (page != null) {
			page.getPreviousBlock();
			request.setAttribute("RecupIdDirectionForm", rechercheForm);
			  return mapping.findForward("suite");
		} else {
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(
					"error.page.noninitialisee"));
			this.saveErrors(request, errors);
			  return mapping.findForward("error");
		}
	}

	public String buildUrl(String idDirection) {
		 return ("<a href=\"javascript:fill('" + idDirection + "');\">");
	}

}