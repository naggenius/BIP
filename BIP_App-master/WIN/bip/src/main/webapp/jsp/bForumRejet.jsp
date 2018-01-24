<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="listeMsgForm" scope="request" class="com.socgen.bip.form.ListeMsgForumForm" />

<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<title>Page BIP</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- Page autorisé aux utilisateurs ayant accès aux Forum -->
<bip:VerifUser page="/forumListe.do"/>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide"))); %>
var pageAide = "<%= sPageAide %>";
var motif = "<%= listeMsgForm.getMotif() %>";

// si le motif est renseigné c'est qu'on a déjà validé la page
if (motif != "") {
	window.close();
	window.opener.document.forms[0].submit();
}

function MessageInitial() {
   var Message="<bean:write filter="false"  name="listeMsgForm"  property="msgErreur" />";
   
   if (Message != "") {
      alert(Message);
      Quitter();
   }
}

function ValiderEcran(form) {
	if (!ChampObligatoire(form.motif, "le motif du rejet")) return false;

	// on recharge le fil de discussion pour prendre en compte le rejet
	window.opener.document.body.style.cursor = "wait";
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
          <td height="20" class="TitrePage">Forum : rejet d'un message</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td></td>
        </tr>
        <BR>
        <tr> 
          <td><html:form action="/forumDiscussion" onsubmit="return ValiderEcran(this);">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="rejeter"/>
                     <html:hidden property="parent_id"/>
                     <html:hidden property="id"/>
                     <html:hidden property="statut" value="R" />
                     
                     <table align="center">					
                   	 	<tr>
	 						<td width="10">&nbsp;</td>
				        	<td width="150" class="lib"> Motif du rejet :&nbsp;</td>
                     		<td width="480"><html:text property="motif" size="80" maxlength="500"/></td>                 		                  		                     
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
            <div align="center"><html:errors/></div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html:html>

              
       