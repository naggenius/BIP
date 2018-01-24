package com.socgen.bip.action;

import java.io.OutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.GregorianCalendar;
import java.util.Hashtable;
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
import com.socgen.bip.excell.FeuilleExcellExportDematIntegre;
import com.socgen.bip.excell.FeuilleExcellExportDematRejet;
import com.socgen.bip.form.ExporterTraceDemFactureForm;
import com.socgen.bip.service.RejetFactureDtoReader;
import com.socgen.bip.service.TraceIntegFactureDtoReader;
import com.socgen.bip.user.UserBip;

/**
 * <p>
 * Classe : ExporterRegleFiltrage</br> Cette classe permet à l’Administrateur
 * de l’application d’exporter sous Excel un rapport détaillé du paramétrage des
 * règles de filtrage actives de l’application.
 * </p>
 */
public class ExporterTraceDemFactureAction extends AutomateAction implements
		BipConstantes {

	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException
			 {
		String signatureMethode = "ExporterTraceDemFactureAction-creer( mapping, form , request,  response,  errors )";
		Locale lLocal = Locale.getDefault();
			
		ResourceBundle myResources =
			ResourceBundle.getBundle(
				"ApplicationResources",
				lLocal);

		logBipUser.entry(signatureMethode);

		ActionForward forward = new ActionForward();
		ExporterTraceDemFactureForm exporterTraceDemFactureForm = (ExporterTraceDemFactureForm) form;
		String numLot = request.getParameter("numlot");
		if (numLot == null) {
			logBipUser.error("numlot vide");
			exporterTraceDemFactureForm
					.setMsgErreur("numlot vide.");
			return mapping.findForward("error");
		} else {
				try {
					Collection collection = new ArrayList();
					String prefix = "rejet_lot_" + numLot;
					RejetFactureDtoReader rejetFactureDtoReader = new RejetFactureDtoReader(numLot);
					collection = rejetFactureDtoReader.getRejetFactureExportExcell(hParamProc);

					DateFormat dateFormat = new SimpleDateFormat(myResources.getString("date.format.fichier.export"));
					Calendar today = new GregorianCalendar();
					String dateAujourdhui = dateFormat.format(today.getTime());
					UserBip user = (UserBip) request.getSession().getAttribute("UserBip");
					String theReportFile = "Export" + prefix + "_" + user.getIdUser() +"_"
							+ dateAujourdhui + ".xls";

					logBipUser.debug("theReportFile =" + theReportFile);

					response.setContentType("application/octet-stream");
					response.setHeader("Content-Disposition",
							"attachment; filename=\"" + theReportFile + "\"");
					OutputStream out = response.getOutputStream();
					logBipUser
							.debug("Appel pour la création du fichier Excell");
					FeuilleExcellExportDematRejet exportExcellDmatRejet = new FeuilleExcellExportDematRejet(collection,lLocal);

					HSSFWorkbook wb = new HSSFWorkbook();
					wb = exportExcellDmatRejet.getWb();
					out.flush();
					wb.write(out);
					out.close();
					forward = null;
				} catch (Exception e) {
					logBipUser.debug(e.toString());
					request.setAttribute("exception", e);
					return mapping.findForward("failure");
				}
			}

			// Finish with
			return (forward);
		}

	public ActionForward consulter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc)
			 {
		String signatureMethode = "ExporterTraceDemFactureAction-consulter( mapping, form , request,  response,  errors )";

		logBipUser.entry(signatureMethode);
		Locale lLocal = Locale.getDefault();
		ResourceBundle myResources =
			ResourceBundle.getBundle(
				"ApplicationResources",
				lLocal);
		ActionForward forward = new ActionForward();
		ExporterTraceDemFactureForm rapportDemFactureForm = (ExporterTraceDemFactureForm) form;
		String numLot = request.getParameter("numlot");
		if (numLot == null) {
			logBipUser.error("numlot vide");
			rapportDemFactureForm
					.setMsgErreur("numlot vide");
			return mapping.findForward("error");
		} else {
				try {
					Collection collection = new ArrayList();
					String prefix = "integ_lot_" + numLot;
					TraceIntegFactureDtoReader traceIntegFactureDtoReader = new TraceIntegFactureDtoReader(numLot);
					collection = traceIntegFactureDtoReader
							.getRejetFactureExportExcell(hParamProc);
					DateFormat dateFormat = new SimpleDateFormat(myResources.getString("date.format.fichier.export"));
					Calendar today = new GregorianCalendar();
					String dateAujourdhui = dateFormat.format(today.getTime());
					UserBip user = (UserBip) request.getSession().getAttribute("UserBip");
					String theReportFile = "Export" + prefix + "_" + user.getIdUser() +"_"
							+ dateAujourdhui + ".xls";

					logBipUser.debug("theReportFile =" + theReportFile);

					response.setContentType("application/octet-stream");
					response.setHeader("Content-Disposition",
							"attachment; filename=\"" + theReportFile + "\"");
					OutputStream out = response.getOutputStream();
					logBipUser
							.debug("Appel pour la création du fichier Excell");
					FeuilleExcellExportDematIntegre exportExcellDmatInteg = new FeuilleExcellExportDematIntegre(collection,lLocal);

					HSSFWorkbook wb = new HSSFWorkbook();
					wb = exportExcellDmatInteg.getWb();
					out.flush();
					wb.write(out);
					out.close();
					forward = null;
				} catch (Exception e) {
					logBipUser.debug(e.toString());
					request.setAttribute("exception", e);
					return mapping.findForward("failure");
				}
			}

			// Finish with
			return (forward);
		
	}

	
}