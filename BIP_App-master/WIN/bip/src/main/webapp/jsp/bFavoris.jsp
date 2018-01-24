<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="favorisForm" scope="request" class="com.socgen.bip.form.FavorisForm" />

<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<title>Page BIP</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- Page autorisé aux utilisateurs ayant accès à la liste des favoris -->
<bip:VerifUser page="/listeFavoris.do"/>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial() {
   var Message="<bean:write filter="false"  name="favorisForm"  property="msgErreur" />";
   
   if (Message != "") {
      alert(Message);
      Quitter();
   }
}

function ValiderEcran(form) {
	if (form.libelle && !ChampObligatoire(form.libelle, "le libellé")) return false;
	if (form.lienFav && !ChampObligatoire(form.lienFav, "le lien")) return false;
	if (form.userid && !ChampObligatoire(form.userid, "l'utilisateur")) return false;
    return true;
}

function Quitter(){
	window.close();
}

</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr > 
          <td> 
            <div align="center"><!-- #BeginEditable "barre_haut" --> 
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false) ;%>
              <%=tb.printHtml()%><!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage">Ajout d'un favori</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td></td>
        </tr>
        <BR>
        <tr> 
          <td><html:form action="/addFavoris.do" onsubmit="return ValiderEcran(this);">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="creer"/>
                     <html:hidden property="typFav"/>
                     <html:hidden property="lienFav"/>
                     <html:hidden property="userid"/>
                     <html:hidden property="menu"/>
                     <html:hidden property="mode" value="insert"/>
                     
                     <table align="center">					
                   	 	<tr>
	 						<td width="10">&nbsp;</td>
				        	<td width="150" class="lib">Libell&eacute; du favori :&nbsp;</td>
                     		<td width="480"><html:text property="libelle" size="80" maxlength="120"/></td>                 		                  		                     
	 						<td width="10">&nbsp;</td>
				        </tr>
	 					<tr><td colspan="4">&nbsp;</td></tr>
	 					<tr>
	 						<td width="10">&nbsp;</td>
                			<td colspan="2">
                	 			<div align="center">
                	  				<html:submit property="boutonValider" value="Valider" styleClass="input" />
                	  				&nbsp;&nbsp;&nbsp;
                	  				<html:button property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Quitter();"/>
              		 			</div>
                			</td>
	 						<td width="10">&nbsp;</td>
	 					</tr>
					</table>
                  
                  </div>
                </td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" -->
            </html:form>
            <!-- #EndEditable --> 
          </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html:html>
<!-- #EndTemplate -->
              
       