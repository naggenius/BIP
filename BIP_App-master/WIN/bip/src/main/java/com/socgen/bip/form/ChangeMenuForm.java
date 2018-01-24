package com.socgen.bip.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.AutomateForm;

/**
 * Formulaire Struts pour le choix du menu.
 * @author RSRH/ICH/CAP
 */
public class ChangeMenuForm extends AutomateForm
{
	/**
	 * L'identifiant du menu (Colonne "CODE_MENU") de la table MENU.
	 */
	private String menuId ;

	/**
	 * Construit un nouveau formulaire.
	 */
	public ChangeMenuForm()
	{
		super();
	}


	/**
	 * Renvoie l'identifiant du menu
	 * @return l'identifiant du menu
	 */
	public String getMenuId()
	{
		return menuId;
	}

	/**
	 * Positionne l'identifiant du menu
	 * @param menuId le nouvel identifiant du menu
	 */
	public void setMenuId(String menuId)
	{
		this.menuId = menuId;
	}
	
	/**
	 * Valide le formulaire et renvoie une erreur si le champ "menuId" n'est pas renseigné.
	 * @param mapping l'association entre l'url et l'action.
	 * @param request la requête HTTP.
	 * @return les erreurs s'il y en a.
	 * @see org.apache.struts.action.ActionForm#validate(ActionMapping, HttpServletRequest)
	 */
	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request)
	{
		ActionErrors errors = new ActionErrors() ;
		
		if ("valider".equals(request.getParameter("action")))
		{
			if (menuId == null || menuId.length() < 1)
			{	
				errors.add("menuId", new ActionError("error.menuId.missing")) ;
			}
		}	

		return errors ;
	}

}
