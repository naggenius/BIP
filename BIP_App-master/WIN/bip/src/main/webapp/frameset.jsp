<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<%@ page language="java" import="com.socgen.bip.user.UserBip"    errorPage="../jsp/erreur.jsp"  %>

<bip:VerifUser page="frameAccueil.jsp"/>
<html:html>

<!--cap:authchk redir="jsp/login.jsp"/-->
<head>
	<title>
		<% java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle("log"); %>
		<%=rb.getString("env.titrepage")%>
	</title>
</head>
<frameset cols="200,*" border="0" framespacing="0" frameborder="NO" >
	<frame name="menu" src="menu.jsp" scrolling="auto" style="overflow-x:hidden" noresize marginwidth="0" marginheight="2">
<% String lienFavori = "vide";
   if (((UserBip) session.getAttribute("UserBip")).getLienFavori()!= null) {
   		lienFavori = ((UserBip) session.getAttribute("UserBip")).getLienFavori();
   		((UserBip) session.getAttribute("UserBip")).setLienFavori(null);
   }
   if (lienFavori.equals("vide")) {
%>
	<frame name="main" src="/listeFavoris.do?addFav=no&action=initialiser" scrolling="auto" noresize marginwidth="3" marginheight="0">
<% } else { %>
	<frame name="main" src="<%= lienFavori %>" scrolling="auto" noresize marginwidth="3" marginheight="0">
<% } %>

</frameset>
</html:html>