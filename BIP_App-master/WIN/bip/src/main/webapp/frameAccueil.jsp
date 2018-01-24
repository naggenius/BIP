<%@ page language="java" import="com.socgen.bip.commun.bd.*,org.owasp.esapi.ESAPI"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
<html:html>

<head>
	<title>
		<% java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle("log"); %>
		<%=rb.getString("env.titrepage")%>	
	</title>
</head>
<script language="JavaScript">
function init(){
window.open(document.links[0].href,document.links[0].target); 
}
</script>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="init();">
<%  if (ParametreBD.getValeur("ETAT_BIP").equals("BLOQUEE")) {%>
	<form  method="POST" target="_top">
		<a href="bloquee.jsp" target="_top"></a>
	</form>
<% } else { %>

 <form  method="POST" target="_top">
 <%if ("O".equals(ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("redirect"))))) {%>
 	<a href="accueil.jsp?redirect=O" target="_top"></a>
 <%} else if ("O".equals(ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("bloquee"))))) {%>
 	<a href="accueil.jsp?bloquee=O" target="_top"></a>
 <% }else { %>
 	<a href="accueil.jsp" target="_top"></a>
 <%}%>
 </form>
</body>
<% } %>
</html:html>