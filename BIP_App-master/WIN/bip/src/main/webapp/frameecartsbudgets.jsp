<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,org.owasp.esapi.ESAPI"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ecartsBudgetsForm" scope="request" class="com.socgen.bip.form.EcartsBudgetsForm" />


<bip:VerifUser page="frameAccueil.jsp"/>
<html:html>


<head>
	<title>
		<% java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle("log"); %>
		<%=rb.getString("env.titrepage")%>
	</title>
</head>
<script language="JavaScript" src="js/menu.js"></script>
<script language="JavaScript">
   <% 
  
   String sIndexMenu;
   
       			
   	sIndexMenu = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("indexMenu")));
      	
      	
    %>   
	
function init(){

   var Message="<bean:write filter="false"  name="ecartsBudgetsForm"  property="msgErreur" />";
   parent.frames.menu.location="javascript:refreshFrame("+<%=sIndexMenu%>+")";
   
  if (Message != "") {
      alert(Message);
    
   }
}
</script>
<frameset cols="200,*" border="0" framespacing="0" frameborder="NO"  onLoad="init();">
	<frame name="menu" src="menu.jsp" scrolling=auto noresize marginwidth=0 marginheight=2>
	<frame name="main" src="jsp/vide.jsp"scrolling=auto noresize marginwidth=3 marginheight=0>
</frameset>
</html:html>


