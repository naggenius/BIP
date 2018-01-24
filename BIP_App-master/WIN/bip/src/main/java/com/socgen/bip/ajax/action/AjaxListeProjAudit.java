package com.socgen.bip.ajax.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.ajaxtags.helpers.AjaxXmlBuilder;
import org.ajaxtags.servlets.BaseAjaxAction;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.ajax.attributListe.AutocompleteAttribut;
import com.socgen.bip.ajax.service.AutocompleteProjAudit;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.log.Log;


public class AjaxListeProjAudit extends BaseAjaxAction  {
	
	protected static  String sLogCat = "BipUser";
	protected static Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);

public String getXmlContent(ActionMapping action, ActionForm Form,
	       HttpServletRequest request,
	      HttpServletResponse response) 
      throws Exception {
    String libelle = request.getParameter("libelle");
    AutocompleteProjAudit service = new AutocompleteProjAudit();
    List<AutocompleteAttribut> list = service.RecupListe(libelle, request, response);
    return new AjaxXmlBuilder().addItems(list, "libelle", "id",true).toString().replace("&", "&amp; ");
}

}