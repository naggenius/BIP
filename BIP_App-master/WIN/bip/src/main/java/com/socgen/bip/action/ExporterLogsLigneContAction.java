package com.socgen.bip.action;
/**
 * EVI 16/04/2008
 * 
 * Fiche 607
 * 
 */
import java.io.OutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.GregorianCalendar;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.excell.FeuilleExcellExportRejetFacturesEbis;
import com.socgen.bip.excell.FeuilleExcellExportLigneCont;
import com.socgen.bip.form.ExporterLogsEbisForm;
import com.socgen.bip.service.LogsLigneContDtoReader;
import com.socgen.bip.service.dto.LogsLigneContDto;
import com.socgen.bip.user.UserBip;

public class ExporterLogsLigneContAction extends AutomateAction implements
		BipConstantes {

	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException
	{
		String signatureMethode = "ExporterLogsLigneContAction-creer( mapping, form , request,  response,  errors )";
		Locale lLocal = Locale.getDefault();
		ResourceBundle myResources =ResourceBundle.getBundle("ApplicationResources",lLocal);
		logBipUser.entry(signatureMethode);
		
		ExporterLogsEbisForm bipForm = (ExporterLogsEbisForm) form;
		//hParamProc.put("centreFrais", bipForm.getCentreFrais()); 
		ActionForward forward = new ActionForward();
		try {
			Collection collection = new ArrayList(); 
			LogsLigneContDtoReader rejetTTEbisDtoReader = new LogsLigneContDtoReader(); 
			collection = rejetTTEbisDtoReader.getRejetFacturesEbisDtoExportExcell(hParamProc);
			 
			DateFormat dateFormat = new SimpleDateFormat(myResources.getString("date.format.fichier.export"));
			Calendar today = new GregorianCalendar();
			String dateAujourdhui = dateFormat.format(today.getTime());
			String prefix=myResources.getString("excell.ebis.ll.logs.fichier.prefix");
			UserBip user = (UserBip) request.getSession().getAttribute("UserBip");
			String theReportFile = prefix + user.getIdUser() +"_"+ dateAujourdhui + ".xls";
			logBipUser.debug("theReportFile =" + theReportFile);
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition","attachment; filename=\"" + theReportFile + "\""); 
			OutputStream out = response.getOutputStream();
			logBipUser.debug("Appel pour la création du fichier Excell"); 
			FeuilleExcellExportLigneCont exportExcellLigneCont = new FeuilleExcellExportLigneCont(collection,lLocal);
			HSSFWorkbook wb = new HSSFWorkbook();
			wb = exportExcellLigneCont.getWb(); 
			out.flush();
			wb.write(out);
			out.close();
			forward = null;
		} catch (Exception e) {
				logBipUser.debug(e.toString());
				request.setAttribute("exception", e);
				return mapping.findForward("failure");
			}
			
		return (forward);
	}
}