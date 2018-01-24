package com.socgen.bip.commun.action;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.form.ReportForm;
import com.socgen.bip.exception.BipException;
import com.socgen.bip.exception.ReportException;
import com.socgen.bip.metier.Report;
import com.socgen.bip.metier.ReportManager;

/**
 * @author RSRH/ICH/GMO Equipe Bip
 * @author E.GREVREND
 *
 * Action struts gérant les demandes d'éditions
 * Pour chaque report à générer, un appel a ReportLauncher est effectue
 * 
 * @see com.socgen.bip.commun.action.BipAction
 * @see com.socgen.bip.metier.Report
 */
public class ReportAction extends BipAction
{
	/**
	 * Constructeur
	 * Aucun traitement
	 */
	public ReportAction()
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
		String sLocation;
		ReportForm rForm = (ReportForm)form;
		Hashtable hParamsJob = new Hashtable();
		
		if (ACTION_ANNULER.equals(rForm.getAction())){
					return mapping.findForward("annuler");
		}
		
		//on recup les 5 parametres de bipUser
		addUserParamToHash(hParamsJob);
		
		//on ajoute les parametres supplementaires definis
		rForm.putParamsToHash(hParamsJob);
		hParamsJob.put("arborescence", rForm.getArborescence().replaceAll("'", " "));
			
		
		if (logBipUser.isDebugEnabled())
		{
			logBipUser.debug("ReportAction.bipPerform: hParamsJob :");
			for(Enumeration enums = hParamsJob.keys(); enums.hasMoreElements();)
			{
				String sP = (String)enums.nextElement();
				logBipUser.debug("	" + sP + "	: " + (String)hParamsJob.get(sP));
				
			}
		}		
        
		
	 
		 
			
			
		String sSchema = null;
		try
		{
			hParamsJob.put(Report.PARAM_DESFORMAT, rForm.getDesformat());

			sSchema = Report.checkParamJob(rForm.getJobId(), hParamsJob);
			if (sSchema.length() != 0)
			{
				//extraire le vrai shema ...
				sSchema = sSchema.substring("NOM_SCHEMA#".length(), sSchema.length());
				logBipUser.debug("Valeur du shema : " + sSchema);
			}
		}
		catch (ReportException e)
		{
			if (e.getSubType() == ReportException.REPORT_BADPARAM)
			{
				logBipUser.debug("msgErreur : " + BipException.getMessageFocus(e.getMessage(), form));
				rForm.setMsgErreur(BipException.getMessageFocus(e.getMessage(), form));
	
				return new ActionForward(rForm.getInitial());
			}
			//exception non applicative
			errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(""+e.getSubType(), e.getMessage()));	
			logBipUser.info("ReportAction.bipPerform: redirection struts : failure");
			return mapping.findForward("failure");
		}
		
		if (Report.isSynchrone(rForm.getJobId()))
		{
			try
			{
				sLocation = ReportManager.getInstance().addJob(rForm.getJobId(), rForm.getListeReportsEnum(), userBip, hParamsJob, sSchema, ReportManager.JOB_SYNCHRONE);
				
				response.sendRedirect(sLocation);
			}
			catch (ReportException e)
			{
				logBipUser.error("ReportAction.bipPerform: exception sur job synchrone", e);
				logBipUser.error("ReportAction.bipPerform: " + e.getSubType());
				
				errors.add(ActionErrors.GLOBAL_ERROR, new ActionError(""+e.getSubType(), e.getMessage()));
				
				logBipUser.info("ReportAction.bipPerform: redirection struts : failure");
				return mapping.findForward("failure");
			}
		}
		else
		{	
			if (Report.isExtractionMiseEnForme(rForm.getJobId()))
				hParamsJob.put(Report.PARAM_DESFORMAT, "DELIMITED");
			ReportManager.getInstance().addJob(rForm.getJobId(), rForm.getListeReportsEnum(), userBip, hParamsJob, sSchema, ReportManager.JOB_ASYNCHRONE);
				
			logBipUser.info("ReportAction.bipPerform: redirection struts : async");
			return mapping.findForward("async");
		}
		
		return null;
	}
	
	/**
	 * addUserParams va ajouter les P_param1..5 à la Hashtable des parametres
	 * @param hParam la hastable qui va se voir ajouter les parametres del'utilisateur Bip
	 */
	protected void addUserParamToHash(Hashtable hParams)
	{
		hParams.put("P_param0", userBip.getActeur());		//indique si utilisateur est un clien ou fournisseur
		
		hParams.put("P_param1", userBip.getIdUser());		//idArpege
		// Pôle
		if (userBip.getDpg_Defaut() != null) hParams.put("P_param2", userBip.getDpg_Defaut());
		else hParams.put("P_param2", "");
		//filliale
		if (userBip.getFilCode() != null) hParams.put("P_param3", userBip.getFilCode());
		else hParams.put("P_param3", "");
		//direction
		if (userBip.getClicode_Defaut() != null) hParams.put("P_param4", userBip.getClicode_Defaut());
		else hParams.put("P_param4", "");
		//centre2frais
		if (userBip.getCentre_Frais() != null) hParams.put("P_param5", userBip.getCentre_Frais());
		else hParams.put("P_param5", "");
		
		hParams.put("P_global", userBip.getInfosUser());
		
	}	
	
	 
	
}