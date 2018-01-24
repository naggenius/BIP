 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %><html:html locale="true"> 

<jsp:useBean id="rBipDisplayForm" scope="request" class="com.socgen.bip.form.RBipDisplayForm" />

<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Upload Files</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/rBipRemontee.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	com.socgen.bip.user.UserBip userBip = (com.socgen.bip.user.UserBip) session.getAttribute("UserBip");
	
	java.util.Vector vLignes = com.socgen.bip.rbip.intra.RBipFichier.getLignesFichier(rBipDisplayForm.getPID(), userBip.getIdUser(),rBipDisplayForm.getFichier());
	pageContext.setAttribute("vLignes", vLignes);
	
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message = "";
   var Focus = "";
   if (Message != "") {
      alert(Message);
   }
}

function back(form)
{
	form.action.value = 'suite';
}


</script>
<!-- #EndEditable --> 
</head>


<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0">

<html:form action="/rBipDisplay">
<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>

<table class="TableBleu" align="center">
<tr>
	<td align="center">
		<html:submit value="Retour" styleClass="input" onclick="back(this.form);"/>		
	</td>
</tr>
<tr>
	<td class="lib" align="center"><b> Lignes du fichier <bean:write name="rBipDisplayForm"  property="fichier" /></b></td>
</tr>
<tr>
	<td  width="500">
	<PRE><logic:iterate id="element" name="vLignes" scope="page">
<bean:write name="element"/></logic:iterate></PRE>
	</td>
</tr>
<tr>
	<td align="center">
		<html:submit value="Retour" styleClass="input" onclick="back(this.form);"/>		
	</td>
</tr>
</table>

</html:form>
	
</body></html:html>
<!-- #EndTemplate -->
