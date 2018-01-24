/*
 * Créé le 24 août 04
 *
 */
package com.socgen.bip.action;

import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.form.RBipDisplayForm;
import com.socgen.bip.rbip.intra.RBipFichier;
import com.socgen.cap.fwk.exception.BaseException;

/**
 *
 * @author X039435
 */
public class RBipDisplayAction extends AutomateAction
{
	private static String PACK_DELETE = "";
	// les visu de data et erreur ne se font pas par proc stock
	
	protected  ActionForward consulter(	ActionMapping mapping,
										ActionForm form ,
										HttpServletRequest request,
										HttpServletResponse response,
										ActionErrors errors,
										Hashtable hParamProc ) throws ServletException
	{
		RBipDisplayForm displayF = (RBipDisplayForm)form;
		if ("delete".equals(displayF.getMode()))
		{
			try
			{
				RBipFichier.supprimerFichier(displayF.getPID(), userBip.getIdUser(),displayF.getFichier());
			}
			catch (BaseException bE)
			{
			}
			
			return mapping.findForward("initial");
		}
		
		return null;
	}
	
	protected  ActionForward valider(	ActionMapping mapping,
										ActionForm form,
										String mode,
										HttpServletRequest request,
										HttpServletResponse response,
										ActionErrors errors ,
										Hashtable hParamProctest ) throws ServletException
	{
		if ("fichier".equals(mode))
		{
			return mapping.findForward("displayData");
		}
		else if ("erreurs".equals(mode))
		{
			return mapping.findForward("displayErreurs");
		}
		return null;
	}
}
