package com.socgen.bip.action;

import java.io.IOException;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.action.ReportAction;
import com.socgen.bip.exception.ReportException;
import com.socgen.bip.form.SuivInvEditionForm;
import com.socgen.bip.user.UserBip;
/**
 * @author DSIC/SUP Equipe Bip
 * @author K. HAZARD
 *
 * Action struts gérant les demandes d'éditions
 * pour le suivi d'investissement
 * 
 * @see com.socgen.bip.commun.action.ReportAction
 * @see com.socgen.bip.metier.Report
 */
public class SuivInvEditionAction extends ReportAction
{
	/**
	 * Constructeur
	 * Aucun traitement
	 */
	public SuivInvEditionAction()
	{
		super();
	}
	
	/**
	 * Traitement pour les éditions
	 * On recupere les informations de ReportForm et de du userBip
	 * Puis ont lance une demande de travail a la classe metier Report
	 * 
	 * @see com.socgen.bip.commun.action.BipAction#bipPerform(ActionMapping, ActionForm, HttpServletRequest, HttpServletResponse)
	 * @return ActionForward
	 */
	public ActionForward bipPerform(	ActionMapping mapping,
										ActionForm form,
										HttpServletRequest request,
										HttpServletResponse response,
										Hashtable hParamProc)
										throws ReportException, IOException
	{
		
		SuivInvEditionForm siForm = (SuivInvEditionForm)form;
		
		String codcamoCourant;
		HttpSession session = null;
		session = request.getSession(false);
		UserBip user = (UserBip) session.getAttribute("UserBip");
		//Mettre à jour le code centre activité courant	
		codcamoCourant = siForm.getCodcamo();
		user.setCodcamoCourant(codcamoCourant);
		
		return super.bipPerform(mapping,form, request,response, hParamProc);
	}	
}