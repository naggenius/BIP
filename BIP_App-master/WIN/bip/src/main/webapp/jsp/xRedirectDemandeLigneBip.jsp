<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="UserBip" scope="session" class="com.socgen.bip.user.UserBip" />
<html:html locale="true">
<!-- #EndEditable --> 

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/xRedirectDemandeLigneBip.jsp"/>
<script language="JavaScript">
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	String ssMenus = user.getSousMenus();
	// Réversibilité BIP : Problème chargement écran lié à SUIVBASE dans le menu admin
	String menu = user.getCurrentMenu().getId();
	// Réversibilité BIP : Fin
%>

function MessageInitial()
{
	<%
	String sInitial = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
	if (sInitial == null)
		sInitial = request.getRequestURI();
	else
		sInitial = request.getRequestURI() + "?" + sInitial;
	sInitial = sInitial.substring(request.getContextPath().length());
	%>
	// Réversibilité BIP : Problème chargement écran lié à SUIVBASE dans le menu admin
	var menu = "<%= menu %>";
	var ssMenus = "<%= ssMenus %>";
	if ((menu == "ME" && (ssMenus.indexOf("SUIVBASE") > -1 || ssMenus.indexOf("suivbase") > -1)) || (menu == "GENERAL"))
	{
		document.forms[1].submit();
	}
	else
	{
		document.forms[0].submit();
	}
	// Réversibilité BIP : Fin
}

</script>

</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<form action="xSansParam.jsp?addFav=yes&typFav=X&jobId=xDdeLigneBip&pageAide=<%= sPageAide %>" method="post">
<input type="hidden" name="arborescence" value="<%= arborescence %>">
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
<input type="hidden" name="initial" value="<%= sInitial %>">
<input type="hidden" name=titlePage value="Extract. des demandes et lignes BIP">
<input type="hidden" name=lienFav value="/jsp/xRedirectDemandeLigneBip.jsp">
</form>

<form action="xDemandesLigneBipAssociees.jsp?addFav=yes&typFav=X&pageAide=<%= sPageAide %>" method="post">
<input type="hidden" name="arborescence" value="<%= arborescence %>">
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
<input type="hidden" name="initial" value="<%= sInitial %>">
<input type="hidden" name=titlePage value="Extract. des demandes et lignes BIP">
<input type="hidden" name=lienFav value="/jsp/xRedirectDemandeLigneBip.jsp">
</form>
</body>
</html:html>

