/*
 * Créé le 19 nov. 04
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

import com.socgen.bip.form.RBipDisplayForm;
import com.socgen.bip.rbip.intra.RBipFichier;
import com.socgen.cap.fwk.exception.BaseException;

/**
 *
 * @author x039435
 */
public class RBipDisplayAdminAction extends RBipDisplayAction
{
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
				RBipFichier.supprimerFichier(displayF.getPID(), ((RBipDisplayForm)form).getIDRemonteur(),displayF.getFichier());
			}
			catch (BaseException bE)
			{
			}
			
			return mapping.findForward("initial");
		}
		
		return null;
	}
}
