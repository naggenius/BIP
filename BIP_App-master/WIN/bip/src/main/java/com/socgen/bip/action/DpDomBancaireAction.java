package com.socgen.bip.action;

import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;

/**
 * @author PJO - 17/12/2004
 *
 * Action de d'ajout d'un ensemble applicatif sur les projet rattachés au dossier projet
 * chemin : Administration/Référentiels/Liens DP/Dom. Bancaire
 * pages  : mDpDomBancaireAd.jsp
 * pl/sql : proj_info.sql
 */
public class DpDomBancaireAction extends AutomateAction implements BipConstantes{

	private static String PACK_UPDATE = "projet.updateDomBancaire.proc";
	private String nomProc;
	
   
   /**
	* Action qui permet de visualiser les données liées à un code dossier projet
	*/
	protected  ActionForward consulter(ActionMapping mapping,ActionForm form , HttpServletRequest request, HttpServletResponse response, ActionErrors errors, Hashtable hParamProc ) throws ServletException{
		return mapping.findForward("ecran");
	}
	
	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("update")){
			cle=PACK_UPDATE;
		}
		return cle;
	}
}