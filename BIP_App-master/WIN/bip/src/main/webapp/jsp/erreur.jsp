<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ page isErrorPage="true" %>

<html:html>

<head>

 
<title>Erreur</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Expires" content="0">
 
<script language="JavaScript" src="../js/lib_dhtml.js"></script>
<link rel="stylesheet" href="../css/style_cap.css" type="text/css">
<link rel="stylesheet" href="../css/style_graph.css" type="text/css">
<link rel="stylesheet" href="../css/style_data.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">

<script language="JavaScript">
function ouvrirAide(){
	window.open('../jsp/aide.jsp', 'Aide', 'toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=no, width=500, height=400') ;
	return ;
}
function ouvrirContacts(){
	window.open('../contacts.jsp', 'Contacts', 'toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=no, width=450, height=250') ;
	return ;
}
</script>

</head>

<body bgcolor="#FFFFFF" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td class="barrecouleur" nowrap>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td nowrap width="80"> 
              <html:link page="/chgmenu.do?action=creer" target="_top">
              	<img src="../images/bip_logo.jpg" border="0">
              </html:link>
              <img src="../images/blanc.gif" width="10" height="1"></td>
            <td nowrap class="titreaccueil">ERREUR</td>
          </tr>
        </table>
      </td>
    </tr>
  </table> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="barrechemin" nowrap>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td nowrap width="80"><img src="../images/blanc.gif" width="80" height="1" border="0"></td>
                  <td nowrap class="titreaccueil">Service indisponible</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td><img src="../images/blanc.gif" border="0" width="1" height="2"></td>
    </tr>
  </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="10">
    <tr> 
      <td>
      	<!-- #BeginEditable "barre-haut" -->
		<%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,true,true,false,false,false,false,false,false,request) ;%>
		<%=tb.printHtml()%>
		<!-- #EndEditable -->
      </td>
    </tr>
    <tr> 
      <td>
       <table width="100%" border="0" cellspacing="0" cellpadding="2">
          <tr class="titreaccueil"> 
            <td align="center" class="barrecouleur">Message d'aide<td>
          </tr>
          <tr>
            <td align="center" colspan="2">&nbsp;</td>
          </tr>
		  <tr>
				<% String message = (String)request.getAttribute("messageErreur") ;
				// Cas où les 3 mots de passes saisis sont erronés
				if ((message == null) && ("3".equals((String)ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("sessionError")))))) {
					message = "Votre identification sesame(login ou mot de passe) est erronnée";
				}
				if ((exception != null) && (exception.getMessage() != null)){ %>
		  			<td class="texte" align="center">
		  				Le service auquel vous tentez d'accéder n'est pas disponible.
					</td>
          		</tr>
		  		<tr>
            		<td align="center" colspan="2">&nbsp;</td>
          		</tr>
		  		<tr>
            		<td align="center" colspan="2" class="msgErreur">
  						Exception.getMessage 
  						<br><br><hr> <br>
						<%=exception.getMessage()%>
						<br>
						<hr>
						<%=exception.toString()%>
						<br><br><hr>
				<%}	else if (message == null){%>
		  			<td class="texte" align="center">
		  				Le service auquel vous tentez d'accéder n'est pas disponible.
					</td>
          		</tr>
		  		<tr>
            		<td align="center" colspan="2">&nbsp;</td>
          		</tr>
		  		<tr>
            		<td align="center" colspan="2" class="msgErreur">
						Action errors
						<html:errors/>
				<%} else {%>
            		<td align="center" colspan="2" class="msgErreur">
						Message : <%=message%>
				<%}%>
			</td>
		  </tr>
		   <tr>
            <td align="center" colspan="2">&nbsp;</td>
          </tr>
		</table>
      </td>
    </tr>
    <tr> 
      <td>
		<p align="center" class="texte"> 
			<a href="javascript:history.back()">Retour à la page précédente</a> 
		</p>
      </td>
    </tr>
    <tr>
    </tr>
  </table>
</body>
<% 
Integer id_webo_page = new Integer("9999"); 
com.socgen.bip.commun.form.AutomateForm formWebo = null ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>