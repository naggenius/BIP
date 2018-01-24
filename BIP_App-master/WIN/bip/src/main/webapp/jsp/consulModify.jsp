<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"      %> 
<html:html locale="true"> 
<jsp:useBean id="consulModifyForm" scope="request" class="com.socgen.bip.form.ConsulModifyForm" />
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/consulModify.do"/> 

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">

<script language="JavaScript">
function ValiderEcran(form)
{
	
	
	if (form.action.value == 'modifier') {
	
	return true;
	 
	}
	
	
   return true;
}


function displayDetails(){
	
	
}

<%
String titre;
titre = "Consulation and Modification of the records ";
String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
String type=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("type")));

java.util.ArrayList list = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("resscopi",consulModifyForm.getHParams()); 
/* java.util.ArrayList list = new java.util.ArrayList();
list.add(0, "bharath");
list.add(1, "bharath1");
list.add(2, "bharath2"); */
 list.add(0,new ListeOption("select", "---" )); 
pageContext.setAttribute("listRess", list);


%>

</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0">	
<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr><td>&nbsp;</td></tr>
        <tr><td> 
            <div align="center"><!-- #BeginEditable "barre_haut" --> 
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%><!-- #EndEditable --></div>
          </td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td background="../images/ligne.gif"></td></tr>
        <tr><td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Consultation/Modification - Selection<!-- #EndEditable --></td></tr>
        <tr><td background="../images/ligne.gif"></td></tr>
    </table>
     
 <html:form action="/budCopiMasse"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->    
      <input type="hidden" name="pageAide" value="<%= sPageAide %>">
     <input type="hidden" name="titre" value="<%= titre %>">
      <input type="hidden" name="type" value="<%= type %>">
    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="index" value="modifier">

<table width="50%" border="0" cellpadding=2 cellspacing=2 class="tableBleu" align="center">
    	<tr><td colspan=6>&nbsp;</td></tr>
        <tr><td colspan=6>&nbsp;</td></tr>
       
		 <tr>			                    
            <td class="lib"><b>Resource ID :</b></td>
            <td><html:select property="code_ress" name="consulModifyForm" styleClass="input"  onchange="displayDetails();" > 
				 <html:options collection="listRess" property="cle"  />
				 </html:select>
		     </td>
        </tr> 	
        
        <tr><td colspan=6>&nbsp; </td></tr>
        <tr><td colspan=6>&nbsp; </td></tr>
        <tr><td colspan=6>&nbsp; </td></tr>
  </table>

</html:form>


</html:html>








