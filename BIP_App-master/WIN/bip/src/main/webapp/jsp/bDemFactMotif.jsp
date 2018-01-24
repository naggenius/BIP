<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="listeDemFactAttForm" scope="request" class="com.socgen.bip.form.ListeDemFactAttForm" />
<html:html locale="true">
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/lValFav.do"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var blnVerifFormat  = true;
var tabVerif        = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial() {
    var Message="<bean:write filter="false"  name="listeDemFactAttForm"  property="msgErreur" />";

    if (Message != "") {
        alert(Message);
    }
}

function Verifier(form, action) {
  this.listeDemFactAttForm.action.value = action;
  this.listeDemFactAttForm.submit();
}

</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr > 
		  <td> 
            <div align="center">
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%>
			</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage">
          		Demande en suspens
          </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/lValFav"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="titrePage"/>
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="mois"/>
			<html:hidden property="statut"/>
			<html:hidden property="iddem"/>

		<table cellspacing="0" border="0" width="780" class="tableBleu">
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>				
				<td width="140" >&nbsp;</td>
				<td width="160" class="lib">&nbsp;<b>N° de la facture :</b></td>
				<td width="340" >&nbsp;<bean:write name="listeDemFactAttForm"  property="listeFact" /></td>
				<td width="140" >&nbsp;</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>				
				<td width="140" >&nbsp;</td>
				<td width="160" class="lib">&nbsp;<b>Cause :</b></td>
				<td width="240" >
					&nbsp;<bean:write name="listeDemFactAttForm"  property="causesuspens" />
				</td>
				<td width="140" >&nbsp;</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
		</table>
					<!-- #EndEditable --></div>
                </td>
              </tr>
            
            </table>
            <!-- #BeginEditable "fin_form" --></form><!-- #EndEditable -->
          </td>
        </tr>
		<tr>
			<td align="center">
				<a href="javascript:Verifier(this.form, 'modifier');" onmouseover="window.status='';return true"><img src="/images/retour.gif" border="0"></a>
			</td>
		</tr>
        <tr> 
          <td> 
            <div align="center"><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          </td>
        </tr>
		<tr><td>&nbsp;</td></tr>
      </table>
		</html:form>
    </td>
  </tr>
</table>
</body></html:html>
