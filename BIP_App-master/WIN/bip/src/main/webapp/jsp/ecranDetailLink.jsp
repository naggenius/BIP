<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,org.owasp.esapi.ESAPI"    errorPage="../jsp/erreur.jsp"  %>

<bip:VerifUser page="ecranDetailLink.jsp"/>
<html:html>


<head>
	<title>
		<% java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle("log"); %>
		<%=rb.getString("env.titrepage")%>
	</title>
</head>
<script language="JavaScript" src="js/menu.js"></script>
<script language="JavaScript">
function init(){
document.title = '<%=rb.getString("env.titrepage")%>';
}
</script>
<frameset cols="200,*" border="0" framespacing="0" frameborder="NO"  onLoad="init();">
	<frame name="menu" src="../menu.jsp" scrolling=auto noresize marginwidth=0 marginheight=2>
	<% if(request.getParameter("cpident")!=null){ 
	%>
	<frame name="main" src="/consultRess.do?ident=<%=request.getParameter("cpident")%>&action=modifier" scrolling=auto noresize marginwidth=3 marginheight=0>
	<%} %>
	<%if (request.getParameter("fident")!=null) { 
	%>
	<frame name="main" src="/consultRess.do?ident=<%=request.getParameter("fident")%>&action=modifier" scrolling=auto noresize marginwidth=3 marginheight=0>
	<%} %>
</frameset>
</html:html>


