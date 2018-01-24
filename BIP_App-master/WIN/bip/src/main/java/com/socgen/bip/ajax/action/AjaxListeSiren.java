
/**
 * Copyright 2005 Darren L. Spurgeon
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.socgen.bip.ajax.action;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.ajaxtags.helpers.AjaxXmlBuilder;
import org.ajaxtags.servlets.*;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import com.socgen.bip.ajax.attributListe.AutocompleteAttribut;
import com.socgen.bip.ajax.service.AutocompleteSiren;
import com.socgen.cap.fwk.ServiceManager;
import com.socgen.cap.fwk.log.Log;


public class  AjaxListeSiren extends BaseAjaxAction  {
	
	protected static  String sLogCat = "BipUser";
	protected static Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);

public String getXmlContent(ActionMapping action, ActionForm Form,
	       HttpServletRequest request,
	      HttpServletResponse response) 
      throws Exception {
    String libelle = request.getParameter("libelle");
    AutocompleteSiren service = new AutocompleteSiren();
    List<AutocompleteAttribut> list = service.RecupListe(libelle, request, response);
    return new AjaxXmlBuilder().addItems(list, "libelle", "id",true).toString().replace("&", "&amp; ");
}

}