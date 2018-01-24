<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- Imports --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="contactsForm" scope="request" class="com.socgen.bip.form.ContactsForm" />
<jsp:useBean id="UserBip" type="com.socgen.bip.user.UserBip" scope="session"/>

<html:html locale="true"> 
<!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

  
<title>Page BIP</title>
 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var Type="<bean:write name="contactsForm"  property="type" />";

function MessageInitial() {
   var Message="<bean:write filter="false"  name="contactsForm"  property="msgErreur" />";

   if (Message != "") {
      alert(Message);
      Quitter();
   }
}

function Quitter(){
	if(Type=="paramsession"){
		window.opener.top.close();
	}else{
		window.opener.close();
	}
	window.close();
}

function Fermer(){
	window.close();
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
 
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage">Erreur dans votre habilitation RTFE</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td class="tableBleu"><%=UserBip.getErreurRTFE()%></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td class="tableBleu">identifiant RTFE : <%=UserBip.getIdUser()%> (<%=UserBip.getNom()%> <%=UserBip.getPrenom()%>)</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td class="tableBleu"><b>Veuillez contacter l'Administrateur central de la Bip, de préférence PAR MESSAGERIE,</b></td>
        </tr>
        <tr> 
          <td class="tableBleu"><b>en joignant si possible une copie de cette fenêtre, pour faire corriger vos données RTFE : </b></td>
        </tr>
        <logic:iterate id="contact"  name="contactsForm" property="listeContacts" > 
        	<tr><td class="tableBleu"><bean:write name="contact" filter="false"/></td></tr>
        </logic:iterate>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td align="center">
	          <input type="button" class="input" value="Fermer" onclick="Quitter();"/>
	          <logic:equal name="contactsForm" property="type" value="paramsession">
	          	<input type="button" class="input" value="Annuler" onclick="Fermer();"/>
	          </logic:equal>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html:html>       