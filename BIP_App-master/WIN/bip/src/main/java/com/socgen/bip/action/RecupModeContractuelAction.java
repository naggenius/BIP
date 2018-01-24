package com.socgen.bip.action;

import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.form.RecupModeContractuelForm;

/**
 * @author X090949 - YNI - 15/06/2010 Action permettant de r�cup�rer un mode contractuel
 *  via une fen�tre Popup
 */

public class RecupModeContractuelAction extends AutomateAction {
	
	
	/**
	 * Constructor for RecupPrestationAction.
	 */
	public RecupModeContractuelAction() {
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
				+ " - initialiser(paramProc, mapping, form , request,  response,  errors )";
		logBipUser.entry(signatureMethode);
		RecupModeContractuelForm rechercheForm = (RecupModeContractuelForm) form;
		// D�truit la liste de la session si elle existait suite � uen recherche
		if (request.getSession(false).getAttribute(LISTE_RECHERCHE_ID) != null)
			request.getSession(false).removeAttribute(LISTE_RECHERCHE_ID);
		try {
			rechercheForm.setAction("modifier");
			rechercheForm.setListePourPagination(null);
			request.setAttribute("RecupModeContractuelForm", rechercheForm);
		} catch (Exception ex) {
			  return mapping.findForward(processSsimpleException(this.getClass()
					.getName(), "consulter", ex, rechercheForm, request));
		}
		logBipUser.exit(signatureMethode);
		  return mapping.findForward("ecran");
	}

	/**
	 * M�thode permettant de lister l'ensemble des Modes contractuels 
	 * selon le code de localisation saisi
	 */
	protected ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {

			RecupModeContractuelForm rechercheForm = (RecupModeContractuelForm) form;
			return mapping.findForward("suite");
	} 

	/**
	 * M�thode permettant de lister l'ensemble des Modes contractuels 
	 * selon le code de localisation saisi
	 */
	protected ActionForward suite(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException {
			
			RecupModeContractuelForm rechercheForm = (RecupModeContractuelForm) form;
			request.setAttribute("RecupModeContractuelForm", rechercheForm);
			return mapping.findForward("suite");
	}

}