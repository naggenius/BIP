/*
 * Created on 31 juil. 03
 *
 * To change the template for this generated file go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.BipForm;
import com.socgen.bip.metier.TraitAsynchrone;

/**
 * @author X039435
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class RecupForm extends BipForm
{
	private String sType; 
	
	/**
	 * @return
	 */
	public String getType()
	{
		return sType;
	}

	/**
	 * @param string
	 */
	public void setType(String string)
	{
		sType = string;
	}

	public ActionErrors validate(	ActionMapping mapping,
									HttpServletRequest request)
	{
		ActionErrors errors = new ActionErrors();
		
		if ((!sType.equals(TraitAsynchrone.TYPE_EDITION)) &&
			(!sType.equals(TraitAsynchrone.TYPE_EXTRACTION)))
		{
			//bouhhhh
		}
		
		return errors;		
	}
}
