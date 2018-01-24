<%@ page language="java" import="com.socgen.bip.commun.bd.*"%>
<%@ page language="java" import="java.util.*" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<bip:VerifUser page="frameAccueil.jsp"/>
<jsp:useBean id="UserBip" type="com.socgen.bip.user.UserBip" scope="session"/>

<html:html locale="true">
<head>
<script language="JavaScript" src="js/lib_dhtml.js"></script>
<%
String menu = UserBip.getsListeMenu();
%>

<script language="JavaScript">
var menu  ="<%= menu %>";
var MyBox = null;
function BoxInit()
	{
	if (document.getElementById("conteneur")!=null)
		{
		MyBox = new Box('MyBox', 'conteneur', 1, 25, 500, 10);
		window.setTimeout("MyBox.start()",2000);
		}
	}

</script>
<link rel="stylesheet" href="css/style_graph.css" type="text/css">
<link rel="stylesheet" href="css/style_data.css" type="text/css">
<link rel="stylesheet" href="css/style_cap.css" type="text/css">
<link rel="stylesheet" href="css/style_bip.css" type="text/css">
<STYLE type=text/css>
.titre {color: #A51852;}
.posrelative {POSITION: relative;}
#conteneur {LEFT: 5px; OVERFLOW: hidden; WIDTH: 100%; CLIP: rect(0px 200px 200px 0px); POSITION: relative; TOP: 1px; HEIGHT: 80px}
</STYLE>
</head>
<body onLoad="BoxInit();" onResize="">
<%  if (ParametreBD.getValeur("ETAT_BIP").equals("BLOQUEE")) {%>
<input type="hidden" name="test" value="testbaseoracle">
<% }%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align  = "left"><img src="images/bip.jpg" width="251" height="140"></td>
	<td align="right"
        valign="top">
        <%if (menu.indexOf("dir") != -1) { %>
              <a href="accueil.jsp?bloquee=O" target="_top">administrateur uniquement</a></td>
		<%}else { %>
		&nbsp;
		<%} %>
			
</tr>

</table>
<br>

<H2 align = "center"><font color="purple"><A><font color="#B980BF">A T T E N T I O N
<br><br></H2>
<H3 align = "center">L'application BIP est actuellement fermée
</font></a></font></H3>

<H3 align="center">
<font color="purple"><A><font color="#B980BF">
Veuillez nous excuser pour la gêne occasionnée.<br><br>
Reconnectez-vous de temps en temps pour suivre l'évolution de la situation <br>ou du message ci-dessous.
</font></a></font>
</H3>
<br>
<table>
	<tr> 
      <td colspan="2" align=center> </td>
    </tr>
    <tr> 
      <td valign="top" width="140">
		<table position=absolute cellSpacing=0 cellPadding=5 width="400" border=0>
			<tr><td align=left>
				<bip:ListeActu derniereMinute="P"/>
			</td></tr>
		</table>
	  </td>
    </tr>
</table>

</body>
</html:html>