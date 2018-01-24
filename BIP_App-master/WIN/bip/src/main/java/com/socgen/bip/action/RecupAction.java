/*
 * Created on 31 juil. 03
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.socgen.bip.action;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.form.RecupForm;
import com.socgen.bip.metier.TraitAsynchrone;

/**
 * @author X039435
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class RecupAction extends BipAction
{

	/* (non-Javadoc)
	 * @see com.socgen.bip.commun.action.BipAction#bipPerform(org.apache.struts.action.ActionMapping, org.apache.struts.action.ActionForm, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public ActionForward bipPerform(ActionMapping mapping,
									ActionForm form,
									HttpServletRequest request,
									HttpServletResponse response,
									Hashtable hParamProc)
									throws Throwable
	{
		RecupForm rForm = (RecupForm)form;
		if ("reload".equals(rForm.getType()))
			return mapping.findForward("initial");
		
		Vector vFileName = new Vector();

		for (Enumeration vE=request.getParameterNames(); vE.hasMoreElements();) {
			String pName = (String) vE.nextElement();
			
			if (pName.startsWith("del"+rForm.getType()+"["))
				vFileName.add(request.getParameter(pName));
		}
		
		try {
			TraitAsynchrone.purger(rForm.getType(), userBip.getInfosUser(), vFileName);
		} catch (BipException be) {
			errors.add( ActionErrors.GLOBAL_ERROR, new ActionError("11000"));
			request.setAttribute( "messageErreur", be.getMessage());
			return mapping.findForward("error");
		}
		
		return mapping.findForward("initial");
	}

}
