package com.socgen.bip.action;

import java.io.OutputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.Hashtable;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.commun.BipConstantes;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.commun.action.BipAction;
import com.socgen.bip.commun.parametre.ParametreProc;
import com.socgen.bip.db.JdbcBip;
import com.socgen.bip.excell.FeuilleExcellSyntheseImmoMo;
import com.socgen.bip.form.AuditImmoForm;
import com.socgen.bip.service.SyntheseImmoDtoReader;
import com.socgen.bip.user.UserBip;

public class SyntheseImmoMoSituAction extends AutomateAction implements
		BipConstantes {

	protected ActionForward creer(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			ActionErrors errors, Hashtable hParamProc) throws ServletException
	 {
		String signatureMethode = "SyntheseImmoMoSituAction-creer( mapping, form , request,  response,  errors )";
		Locale lLocal = Locale.getDefault();
		ResourceBundle myResources =ResourceBundle.getBundle("ApplicationResources",lLocal);
		logBipUser.entry(signatureMethode);
		ActionForward forward = new ActionForward();
		hParamProc.put("P_global", userBip.getInfosUser());
		Collection<Collection> superCollection = new ArrayList<Collection>();
		ArrayList<String> codes = new ArrayList<String>();
		String proc="";
		if("PROJET".equals(((AuditImmoForm)form).getIcpi())){
			proc = "perim.cli.projet.proc";
		}else{
			proc="perim.cli.dpcode.proc";
		}
		// exécution de la procédure PL/SQL
		Vector vParamOut = new Vector();
		ParametreProc paramOut;
		JdbcBip jdbc = new JdbcBip(); 
		try{	
			vParamOut = jdbc.getResult(
					hParamProc, configProc, proc);
			// Récupération des résultats
			for (Enumeration e = vParamOut.elements(); e.hasMoreElements();) {
				paramOut = (ParametreProc) e.nextElement();
				
				if (paramOut.getNom().equals("curseur")) {
					// Récupération du Ref Cursor
					ResultSet rset = (ResultSet) paramOut.getValeur();
					try {
						while (rset.next()) {
							codes.add(rset.getString(1));
						}
						if (rset != null)
							rset.close();

					} // try
					catch (SQLException sqle) {
						logService.error(this.getClass().getName()
								+ ".creer() --> SQLException :" + sqle);
						if (rset != null)
							rset.close();
						jdbc.closeJDBC(); 
					}catch (Exception ex){
						logBipUser.debug("Une exception a été levée à la récupération des codes projet/dossier projet");
						if (rset != null)
							rset.close();
						jdbc.closeJDBC(); 
					}
				} // if
			} // for
		} // try
		catch (Exception e) {
			logBipUser.debug("Une exception a été levée à la récupération des codes projet/dossier projet : "+e);
		} 

		
		try {
			
			for(String code:codes){
				Collection collection = new ArrayList();
				if("PROJET".equals(((AuditImmoForm)form).getIcpi())){
					hParamProc.put("icpi", code);
					hParamProc.put("dpcode", "");
				}else{
					hParamProc.put("icpi", "");
					hParamProc.put("dpcode", code);
				}
				SyntheseImmoDtoReader syntheseImmoDtoReader = new SyntheseImmoDtoReader ();
				collection = syntheseImmoDtoReader.getSyntheseImmoExcell(hParamProc, form);
				superCollection.add(collection);
			}
			
			
			if (((AuditImmoForm) form).getMsgErreur() != null)
				return mapping.findForward("initial");
			DateFormat dateFormat = new SimpleDateFormat(myResources.getString("date.format.fichier.export"));
			Calendar today = new GregorianCalendar();
			String dateAujourdhui = dateFormat.format(today.getTime());
			String prefix=myResources.getString("excell.synthese.stock.immo."+((AuditImmoForm)form).getIcpi()+".prefix");
			UserBip user = (UserBip) request.getSession().getAttribute("UserBip");
			String theReportFile = prefix + user.getIdUser() +"_"+ dateAujourdhui + ".xls";
			logBipUser.debug("theReportFile =" + theReportFile);
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition","attachment; filename=\"" + theReportFile + "\"");
			OutputStream out = response.getOutputStream();
			logBipUser.debug("Appel pour la création du fichier Excell");
			FeuilleExcellSyntheseImmoMo ExcellSyntheseImmo = new FeuilleExcellSyntheseImmoMo(superCollection, form,lLocal);
			Workbook wb = new HSSFWorkbook();
			wb = ExcellSyntheseImmo.getWb();
			out.flush();
			wb.write(out);
			out.close();
			forward = null;
		} catch (Exception e) {
				BipAction.logBipUser.error("Error. Check the code", e);
				request.setAttribute("exception", e);
				jdbc.closeJDBC();
				return mapping.findForward("failure");
			}
			jdbc.closeJDBC();
			return (forward);
	}
	
}
