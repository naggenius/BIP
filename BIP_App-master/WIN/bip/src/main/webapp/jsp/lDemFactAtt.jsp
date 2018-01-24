<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.ArrayList,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.metier.Favori,com.socgen.bip.user.UserBip"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true">
<jsp:useBean id="listeDemFactAttForm" scope="request" class="com.socgen.bip.form.ListeDemFactAttForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Page BIP</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/lFav2Val.do"/>
<%	try { 
		java.util.ArrayList listeActivite = listeDynamique.getListeDynamique("last12months", new java.util.Hashtable());
		pageContext.setAttribute("choix12mois", listeActivite);
	} catch (Exception e) {
        pageContext.setAttribute("choix12mois", new ArrayList());
    }
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
<% String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide"))); 
   String sStatut  = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("statut"))); %>
var pageAide = "<%= sPageAide %>";
var blnVerification = true;

function MessageInitial() {
   var Message = "";
   var Focus = "";
   if (Message != "") {
      alert(Message);
   }

	var mail2send = "<bean:write name="listeDemFactAttForm"  property="texte_mail" />";
	if (mail2send!=null && mail2send.length>0 && mail2send.length<2000) {
    	document.location.href = mail2send;
 	}
}

function modifOption(form) {
   form.action.value = "modifier";
   form.submit();
}

function Valider(p_action, p_mode, p_socfact, p_numfact, p_datfact, p_typfact, p_numligne, p_datdem) {
   this.listeDemFactAttForm.readonly.value  = "true";
   this.listeDemFactAttForm.action.value  = p_action;
   if (p_action=="creer") {
	   this.listeDemFactAttForm.action.value  = "visualiser";
	   this.listeDemFactAttForm.readonly.value  = "false";
   }
   this.listeDemFactAttForm.mode.value    = p_mode;
   this.listeDemFactAttForm.socfact.value = p_socfact;
   this.listeDemFactAttForm.numfact.value = p_numfact;
   this.listeDemFactAttForm.datfact.value = p_datfact;
   this.listeDemFactAttForm.typfact.value = p_typfact;
   this.listeDemFactAttForm.lnum.value    = p_numligne;
   this.listeDemFactAttForm.datdem.value  = p_datdem;
   this.listeDemFactAttForm.submit();
}

function Valider(p_action, p_mode, p_iddem) {
   this.listeDemFactAttForm.readonly.value  = "true";
   this.listeDemFactAttForm.action.value  = p_action;
   if (p_action=="creer") {
	   this.listeDemFactAttForm.action.value  = "visualiser";
	   this.listeDemFactAttForm.readonly.value  = "false";
   }
   this.listeDemFactAttForm.mode.value  = p_mode;
   this.listeDemFactAttForm.iddem.value = p_iddem;
   this.listeDemFactAttForm.submit();
}

function sendMailCP(p_iddem, p_nomcp) {
   this.listeDemFactAttForm.action.value  = "mailCP";
   this.listeDemFactAttForm.iddem.value = p_iddem;
   this.listeDemFactAttForm.nom_cp.value = p_nomcp;
   this.listeDemFactAttForm.submit();
}

function afficheFacture(p_socfact, p_numfact, p_datfact, p_typfact, p_numligne, p_iddem){
	window.open("/afficheFacture.do?action=initialiser&socfact="+p_socfact+"&numfact="+p_numfact+"&typfact="+p_typfact+"&datfact="+p_datfact+"&lnum="+p_numligne+"&iddem="+p_iddem+"&windowTitle=Récapitulatif facture"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=no, width=750, height=360") ;
}  

</script>

</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr > 
		  <td> 
            <div align="center">
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%>
			</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
        <% if ("V".equals(sStatut)) { %>
          <td height="20" class="TitrePage">Liste des factures validées</td>
		<% } else { %>
          <td height="20" class="TitrePage">Liste des demandes de validation de facture</td>
		<% }%>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
		<tr><td>&nbsp;</td></tr>
        <tr> 
          <td>
		    <!-- #BeginEditable "debut_form" -->
		  	<html:form action="/lFav2Val">
		  	<!-- #EndEditable -->
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
              		<html:hidden property="pageAide" value="<%= sPageAide %>"/>
              		<html:hidden property="action"/>
              		<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              		<html:hidden property="socfact"/>
              		<html:hidden property="numfact"/>
              		<html:hidden property="datfact"/>
              		<html:hidden property="typfact"/>
              		<html:hidden property="lnum"/>
              		<html:hidden property="iddem"/>
              		<html:hidden property="readonly"/>
              		<html:hidden property="nom_cp"/>

					
		<table cellspacing="0" border="0" width="800">
			<tr><td colspan="6">&nbsp;</td></tr>
			<tr>
				<td width="180">&nbsp;</td>
<% if ("V".equals(sStatut)) { %>				
				<td class="lib" align="right" width="130"><b>Mois Demande&nbsp;:&nbsp;</b></td>
				<td width="80">				
					<html:select property="mois" styleClass="input" onchange="modifOption(this.form);"> 
   						<html:options collection="choix12mois" property="cle" labelProperty="libelle" />
					</html:select>
				</td>				
				<td class="lib" align="right" width="70"><b>Statut&nbsp;:&nbsp;</b></td>
				<td width="80">
				 <html:select property="statut" styleClass="input">
				 	 <html:option value="V">Validée</html:option>
				 </html:select>
<% } else { %>
				<td align="right" width="130">&nbsp;</td>
				<td width="80">
					<html:hidden property="mois" value="01/2000"/>
				</td>				
				<td class="lib" align="right" width="70"><b>Statut&nbsp;:&nbsp;</b></td>
				<td width="80">
					 <html:select property="statut" styleClass="input" onchange="modifOption(this.form);">
					 	 <html:option value="X">Tout</html:option>
					 	 <html:option value="A">En attente</html:option>
					 	 <html:option value="S">En suspens</html:option>
					 </html:select>
<% }%>
				</td>
				<td width="240">&nbsp;</td>
			</tr>
			<tr><td colspan="6">&nbsp;</td></tr>
			<tr>				
				<td width="800" colspan="6">
					<table class="tableBleu" cellspacing="0" border="0">

						<tr>
							<td class="lib" width="60"><b>Mail CP</b></td>
							<td class="lib" width="80"><b>Date</b></td>
							<td class="lib" width="120"><b>Facture</b></td>
							<td class="lib" width="120"><b>Soci&eacute;t&eacute;</b></td>
							<td class="lib" width="80"><b>Ecart</b></td>
							<td class="lib" width="100"><b>Cause suspens</b></td>
							<td class="lib" width="100"><b>Etat</b></td>
							<td class="lib" width="120" colspan="2"><b>Action</b></td>
						</tr>
<logic:iterate id="demande" name="listeDemFactAttForm" property="listeDemande" type="com.socgen.bip.metier.DemandeValFactu" indexId="it">
						<logic:greaterThan name="it" value="1">
							<logic:equal name="demande" property="nouvelle_demande" value="true">
							<tr style="height:1px;" >
								<td colspan="8" style="border-bottom:1px solid #999999;">&nbsp;</td>
							</tr>
							</logic:equal>
						</logic:greaterThan>
						<tr>
							<td class="null" width="60">
							<logic:equal name="demande" property="nouvelle_demande" value="true">
								<logic:notEqual name="demande" property="statut" value="V">
									<input type="image" src="/images/message.jpg" border="0" alt="Envoyer un mail au chef de projet" onclick="javascript:sendMailCP('<bean:write name="demande" property="iddem"/>', '<bean:write name="demande" property="mail_cp"/>')" >
								</logic:notEqual>
								<logic:equal name="demande" property="statut" value="V">
									&nbsp;
								</logic:equal>
							</logic:equal>
							<logic:notEqual name="demande" property="nouvelle_demande" value="true">&nbsp;</logic:notEqual>
							</td>
							<td class="null" width="80">
							<logic:equal name="demande" property="nouvelle_demande" value="true">
								<bean:write name="demande" property="datdemFormat"/>
							</logic:equal>
							<logic:notEqual name="demande" property="nouvelle_demande" value="true">&nbsp;</logic:notEqual>
							</td>
							<td class="null" width="120">
								<a href="javascript:afficheFacture('<bean:write name="demande" property="socfact"/>', '<bean:write name="demande" property="numfact"/>', '<bean:write name="demande" property="datfact"/>', '<bean:write name="demande" property="typfact"/>', '<bean:write name="demande" property="lnum"/>', '<bean:write name="demande" property="iddem"/>')" onmouseover="window.status='';return true"><bean:write name="demande" property="numfact"/></a>
							</td>
							<td class="null" width="120">
								<bean:write name="demande" property="socfact"/>
							</td>
							<td class="null" width="80">
							<logic:equal name="demande" property="nouvelle_demande" value="true">
								<bean:write name="demande" property="ecart"/>
							</logic:equal>
							<logic:notEqual name="demande" property="nouvelle_demande" value="true">&nbsp;</logic:notEqual>
							</td>
							<td class="null" width="100">
							<logic:equal name="demande" property="nouvelle_demande" value="true">
								<a href="javascript:Valider('visualiser', 'causesuspens', '<bean:write name="demande" property="iddem"/>')" title="Visualiser la cause de la mise en suspens" onmouseover="window.status='';return true"><bean:write name="demande" property="causesuspensCourt"/></a>
							</logic:equal>
							<logic:notEqual name="demande" property="nouvelle_demande" value="true">&nbsp;</logic:notEqual>
							</td>
							<td class="null" width="100">
							<logic:equal name="demande" property="nouvelle_demande" value="true">
								<logic:equal name="demande" property="statut" value="A">
									<img src="/images/imageENCOURS.bmp" border="0" />&nbsp;En attente
								</logic:equal>
								<logic:equal name="demande" property="statut" value="V">
									<a href="javascript:Valider('visualiser', 'datesuivi', '<bean:write name="demande" property="iddem"/>')" title="Visualiser les dates de suivi saisies" onmouseover="window.status='';return true"><img src="/images/imageOK.bmp" border="0" />&nbsp;Valid&eacute;e</a>
								</logic:equal>
								<logic:equal name="demande" property="statut" value="T">
									<a href="javascript:Valider('visualiser', 'datesuivi', '<bean:write name="demande" property="iddem"/>')" title="Visualiser les dates de suivi saisies" onmouseover="window.status='';return true"><img src="/images/imageOK.bmp" border="0" />&nbsp;Valid&eacute;e</a>
								</logic:equal>
								<logic:equal name="demande" property="statut" value="S">
									<img src="/images/imageKO.bmp" border="0" />&nbsp;En suspens
								</logic:equal>
							</logic:equal>
							<logic:notEqual name="demande" property="nouvelle_demande" value="true">&nbsp;</logic:notEqual>
							</td>
							<td class="null" width="120">
							<logic:equal name="demande" property="nouvelle_demande" value="true">
								<logic:equal name="demande" property="statut" value="V">
									&nbsp;
								</logic:equal>
								<logic:equal name="demande" property="statut" value="S">
									<input type="submit" name="btnValider" value="&nbsp;&nbsp;&nbsp;Valider&nbsp;&nbsp;" onclick="javascript:Valider('creer', 'datesuivi', '<bean:write name="demande" property="iddem"/>')" class="input">
								</logic:equal>
								<logic:equal name="demande" property="statut" value="A">
									<input type="submit" name="btnValider" value="&nbsp;&nbsp;&nbsp;Valider&nbsp;&nbsp;" onclick="javascript:Valider('creer', 'datesuivi', '<bean:write name="demande" property="iddem"/>')" class="input">
									<input type="submit" name="btnSuspendre" value="Suspendre" onclick="javascript:Valider('creer', 'causesuspens', '<bean:write name="demande" property="iddem"/>')" class="input">
								</logic:equal>
							</logic:equal>
							<logic:notEqual name="demande" property="nouvelle_demande" value="true">&nbsp;</logic:notEqual>
							</td>
						</tr>
</logic:iterate>						
					</table>
				</td>
			</tr>

			<tr><td colspan="6">&nbsp;</td></tr>
		</table>
					<!-- #EndEditable --></div>
                </td>
              </tr>
            
            </table>
            </html:form>
          </td>
        </tr>
		<tr><td>&nbsp;</td></tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
          </td>
        </tr>
		<tr><td>&nbsp;</td></tr>
      </table>
    </td>
  </tr>
</table>
</body>
<% 
Integer id_webo_page = new Integer("5004"); 
com.socgen.bip.commun.form.AutomateForm formWebo = listeDemFactAttForm;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
