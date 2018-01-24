 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %><html:html locale="true"> 

<jsp:useBean id="rBipDisplayAdminForm" scope="request" class="com.socgen.bip.form.RBipDisplayForm" />

<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Upload Files</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/rBipDisplayAdmin.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;

<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	com.socgen.bip.user.UserBip userBip = (com.socgen.bip.user.UserBip) session.getAttribute("UserBip");
	
	java.util.Vector vLignes = com.socgen.bip.rbip.intra.RBipFichier.getErreursFichier(request.getParameter("PID"), rBipDisplayAdminForm.getIDRemonteur());
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

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">

<html:form action="/rBipDisplayAdmin">
<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="IDRemonteur"/>

<table class="TableBleu" align="center">
<tr>
	<td align="center">
		<html:submit value="Retour" styleClass="input" onclick="back(this.form);"/>		
	</td>
</tr>
<tr>
	<td align="center" colspan="3"><b> Erreurs du Fichier <bean:write name="rBipDisplayAdminForm"  property="fichier" />  de <bean:write name="rBipDisplayAdminForm"  property="IDRemonteur" /> </b></td>
</tr>
<tr>
	<td class="lib"><b> Ligne </b></td>
	<td class="lib"><b> Code erreur </b></td>
	<td class="lib"><b> Libellé </b></td>
</tr>

<%
	String sCode;
	String sLigne;
	String sLibelle;
	
	for (int i=0; i< vLignes.size(); i++)
	{
		java.util.StringTokenizer sTK = new java.util.StringTokenizer((String)vLignes.elementAt(i), ";");
		sTK.nextToken();
		sLigne = sTK.nextToken();
		sCode = sTK.nextToken();
		sLibelle = sTK.nextToken();
	%>
<tr>
	<td align="center"> <%=sLigne%> </td>
	<td align="center"> <%=sCode%> </td>
	<td aligne="right"> <%=sLibelle%> </td>
</tr>
	<%
	}
%>	
<tr>
	<td align="center">
		<html:submit value="Retour" styleClass="input" onclick="back(this.form);"/>		
	</td>
</tr>
</table>

</html:form>



</body></html:html>
<!-- #EndTemplate -->
