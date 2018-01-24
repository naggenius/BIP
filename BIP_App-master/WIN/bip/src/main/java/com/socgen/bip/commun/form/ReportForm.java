package com.socgen.bip.commun.form;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.metier.Report;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.config.Config;
import com.socgen.cap.fwk.config.ConfigManager;
import com.socgen.cap.fwk.exception.CriticalRuntimeException;
import com.socgen.cap.fwk.log.Log;

/**
 * @author RSRH/ICH/GMO Equipe Bip
 * @author E.GREVREND
 *
 * ReportForm est la classe mère des formulaires dédiés au états (reports)
 * 
 * @see com.socgen.bip.commun.action.ReportAction
 */
abstract public class ReportForm extends AutomateForm
{
	/**
	 * Valeur définissant le format HTML
	 */
	public static final String DESFORMAT_HTML="HTML";
	/**
	 * Valeur définissant le format PDF
	 */
	public static final String DESFORMAT_PDF="PDF";
	/**
	 * Valeur définissant le format DELIMITEDDATA
	 */
	public static final String DESFORMAT_DELIMITEDDATA="DELIMITEDDATA";
	
	/**
	 * Config pointant sur le fichier de ressource des reports
	 * @see com.socgen.bip.commun.form.ReportForm#validate(org.apache.struts.action.ActionMapping, javax.servlet.http.HttpServletRequest)
	 */
	private static Config reportCfg = ConfigManager.getInstance(BIP_REPORT);
	private static Config jobCfg=ConfigManager.getInstance(reportCfg.getString("report.jobCfg"));

	private String sListDelimiter = reportCfg.getString("report.listeDelimiter");
	protected Log logIhm = ServiceManager.getInstance().getLogManager().getLogIhm();


	private String sTitre;

	/**
	 * Identifiant du job d'édition à effectuer, il doit exister dans le fichier des ressources des reports
	 */	
	private Vector vListeReports = new Vector();
	private String sJobId;
	/**
	 * Type de sortie, doit avoir une valeur autorisée : HTML, PDF ou DELIMITEDDATA
	 */
	protected String sDesFormat;
	private String sInitial;
	
	/**
	 * Returns the sDesFormat.
	 * @return String
	 */
	public String getDesformat()
	{
		return DESFORMAT_PDF;
		
	}


	public String getListeReports()
	{
		String sListe = "";
		Enumeration enums = vListeReports.elements();
		while (enums.hasMoreElements())
		{
			sListe += enums.nextElement();
			if (enums.hasMoreElements())
			{
				sListe += sListDelimiter;
			}
		}
		
		return sListe;
	}
	/**
	 * Returns the sReport.
	 * @return String
	 */
	public final Vector getListeReportsEnum()
	{
		if (vListeReports.isEmpty())
		{
			logIhm.debug("vListeReports est vide => on prend la valeur par defaut");
			setListeReports(jobCfg.getString(sJobId+".listeReports"));
		}
		return vListeReports;
	}
	
	/**
	 * Returns the sJobId.
	 * @return String
	 */
	public String getJobId()
	{
		return sJobId;
	}

	/**
	 * Returns the sRequestJSP.
	 * @return String
	 */
	public String getInitial()
	{
		return sInitial;
	}
	
	/**
	 * Sets the sDesFormat.
	 * @param sDesFormat The sDesFormat to set
	 */
	public void setDesformat(String sDesFormat)
	{
		this.sDesFormat = sDesFormat.toUpperCase();
	}

	/**
	 * Sets the sReport.
	 * @param sReport The sReport to set
	 */
	public void setListeReports(String sReportList)
	{
		StringTokenizer stk = new StringTokenizer(sReportList, sListDelimiter);
		vListeReports.clear();
		
		while (stk.hasMoreElements())
		{
			vListeReports.add(stk.nextToken());
		}
		
		if (logIhm.isDebugEnabled())
		{
			for (int i = 0; i< vListeReports.size(); i++)
			{
				logIhm.debug("ListeReports["+i+"] :" + vListeReports.elementAt(i));
			}
		}

	}

	/**
	 * Sets the sJobId.
	 * @param sJobId The sJobId to set
	 */
	public void setJobId(String sJobId)
	{
		this.sJobId = sJobId;
	}

	/**
	 * validate est va vérifier que le format a une des valeurs autorisées<br>
	 * et que le report donné existe bien dans le fichier de définition des reports
	 * @see org.apache.struts.action.ActionForm#validate(org.apache.struts.action.ActionMapping, javax.servlet.http.HttpServletRequest)
	 */
	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request)
	{
		ActionErrors errors = new ActionErrors();
		
		//if (!isGoodFormat(sDesFormat)){
		//	errors.add("desformat", new ActionError("error.report.pbdesformat"));
		//}
		
		if ( (sJobId == null) || (sJobId.length() < 1) )
		{
			errors.add("jobId", new ActionError("error.report.noreport"));
		}
		else
		{
			//il faut vérifier qu'il est bien dans les reports disponibles
			try
			{
//				sTitre = Report.getTitre(sJobId);
			}
			catch (CriticalRuntimeException e)
			{
				errors.add("jobId", new ActionError("error.report.notexists"));
			}
		}
		
		logIhm.debug(getListeReports());
		
		if ( (!errors.empty()) && (logIhm.isDebugEnabled()) )
		{
			logIhm.debug("ReportForm.validate : echec");
			String sTmp;
			Iterator itProp;
			Iterator itActions;
			ActionError actionE;
			
			itProp = errors.properties();
			while (itProp.hasNext())
			{
				sTmp = (String)itProp.next();
				itActions = errors.get(sTmp);
				while (itActions.hasNext())
				{	
					actionE = (ActionError)itActions.next();
					logIhm.debug("ReportForm.validate [" + sTmp + "][" + actionE.getKey() + "]");
				}
			}
		}
		return errors;
	}

	/**
	 * Cette méthode abstraite permet a ReportAction de récupérer la liste des paramètres du formulaire appelant<br>
	 * Cette liste N'INCLUE PAS REPORT et DESFORMAT
	 * 
	 * @param hParamsJob la Hashtable qui va recevoir les parametres renseignés dans le formulaire
	 * 
	 * @see com.socgen.bip.commun.action.ReportAction#bipPerform(ActionMapping , ActionForm, HttpServletRequest, HttpServletResponse, ActionErrors)
	 */	
	abstract public void putParamsToHash(Hashtable hParamsJob);

	/**
	 * Cette méthode abstraite permet a ReportForm de vérifier que le desformat donné est valide. <br>
	 * 
	 * @param sDesFormat la valeur à vérifier
	 */	
	abstract public boolean isGoodFormat(String sDesFormat);
	/**
	 * @return
	 */
	public String getTitre()
	{
		return sTitre;
	}

	/**
	 * @param string
	 */
	public void setTitre(String string)
	{
		sTitre = string;
	}

	/**
	 * @param string
	 */
	public void setInitial(String string)
	{
		sInitial = string;
	}
}

