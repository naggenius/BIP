<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="exporterTraceDemFactureForm" scope="request" class="com.socgen.bip.form.ExporterTraceDemFactureForm" />
<html:html locale="true"> 



<!-- #BeginEditable "doctitle" --> 
<title><bean:message key="bip.ihm.export.facture.titre"  /></title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/exportExcellTraceChargFac.do"/>  
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">


<%
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>

var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="exporterTraceDemFactureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="exporterTraceDemFactureForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
}


function submitForm(action,numCharg,type){
		this.document.forms[0].action.value = action;
		this.document.forms[0].submit();
	}

</script>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
</body>
<% 
Integer id_webo_page = new Integer("1048"); 
com.socgen.bip.commun.form.AutomateForm formWebo = exporterTraceDemFactureForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 
