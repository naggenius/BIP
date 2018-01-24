/*
 * Created on 12 nov. 03
 * 
 */
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
import com.socgen.bip.commun.parametre.ParametreProc;

/**
 * @author S.Lallier - 12/11/2003
 *
 * Action de mise à jour des lignes budgétaires
 * chemin : Ressources/MAJ/Personnes
 * pages  : bSuivInvLb.jsp et mSuivInvLb.jsp
 * pl/sql : suivinv.sql
 */
public class NotificationLbAction extends AutomateAction {

	private static String PACK_SELECT_C = "investissement.consulter_c.proc";
	private static String PACK_SELECT_M = "investissement.consulter_m.proc";
	private static String PACK_SELECT_S = "investissement.consulter_s.proc";
	private static String PACK_INSERT = "investissement.creer.proc";
	private static String PACK_UPDATE = "investissement.modifier.proc";
	private static String PACK_DELETE = "investissement.supprimer.proc";

	//private String nomProc;

	/**
		* Action qui permet de créer une ligne d'investissement
		*/
	protected ActionForward creer(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors, Hashtable hParamProc)
		throws ServletException {
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;

		String signatureMethode =
			"SuiviInvestissementAction -creer( mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);
		;

		logService.exit(signatureMethode);

		return mapping.findForward("ecran");
	} //creer

	/**
		* Action qui permet de visualiser les données liées à un code Personne pour la modification et la suppression
		*/
	protected ActionForward consulter(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors, Hashtable hParamProc)
		throws ServletException {

		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode =
			"SuiviInvestissementAction-consulter(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);

		logService.exit(signatureMethode);

		return mapping.findForward("ecran");
	} //consulter

	protected ActionForward suite(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response,
		ActionErrors errors, Hashtable hParamProc)
		throws ServletException {
		Vector vParamOut = new Vector();
		String message = "";
		boolean msg = false;
		ParametreProc paramOut;

		String signatureMethode =
			"SuiviInvestissementAction-suite(paramProc, mapping, form , request,  response,  errors )";

		logService.entry(signatureMethode);

		logService.exit(signatureMethode);

		return mapping.findForward("suite");
	}

	protected String recupererCle(String mode) {
		String cle = null;
		if (mode.equals("insert")) {
			cle = PACK_INSERT;
		} else if (mode.equals("update")) {
			cle = PACK_UPDATE;
		} else if (mode.equals("delete")) {
			cle = PACK_DELETE;
		}

		return cle;
	}

}
