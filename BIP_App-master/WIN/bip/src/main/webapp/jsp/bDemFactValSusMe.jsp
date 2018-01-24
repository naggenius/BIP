<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="listeDemFactAttForm" scope="request" class="com.socgen.bip.form.ListeDemFactAttForm" />
<html:html locale="true">
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/lFav2Val.do"/>
<%
  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("statut_CS2"); 
  
  pageContext.setAttribute("choixStatutCS2", list1);
%>
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
function submitenter(e)
{
var keycode;
if (window.event) keycode = window.event.keyCode;
else if (e) keycode = e.which;
else return true;

if (keycode == 13)
   {
  this.listeDemFactAttForm.action.value = "creer";
  this.listeDemFactAttForm.submit();
  return false;
   }
else
   return true;
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
		  <logic:equal name="listeDemFactAttForm" property="readonly" value="true">
		  	<logic:equal name="listeDemFactAttForm" property="mode" value="causesuspens">
          		Demande en suspens
          	</logic:equal>
		  	<logic:equal name="listeDemFactAttForm" property="mode" value="datesuivi">
          		Ecart de rapprochement valid&eacute;
          	</logic:equal>
          </logic:equal>
		  <logic:equal name="listeDemFactAttForm" property="readonly" value="false">
		  	<logic:equal name="listeDemFactAttForm" property="mode" value="causesuspens">
          		Mise en suspens
          	</logic:equal>
		  	<logic:equal name="listeDemFactAttForm" property="mode" value="datesuivi">
          		Validation &eacute;cart rapprochement de facture
          	</logic:equal>
          </logic:equal>
          </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/lFav2Val" ><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="titrePage"/>
			<html:hidden property="action" value="creer"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="mois"/>
			<html:hidden property="statut"/>
			<html:hidden property="iddem"/>

		<table cellspacing="0" border="0" width="780" class="tableBleu">
		<% int w1 = 200;
		   int w2 = 300;
		   if (listeDemFactAttForm.getMode().equals("causesuspens")) {
				w1 = w1-40;
				w2 = w2+40;
		   }
		%>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>				
				<td width="140" >&nbsp;</td>
				<td width="<%=w1%>" class="lib">&nbsp;<b>N° de la facture :</b></td>
				<td width="<%=w2%>" >&nbsp;<bean:write name="listeDemFactAttForm"  property="listeFact" /></td>
				<td width="140" >&nbsp;</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
		  	<logic:equal name="listeDemFactAttForm" property="mode" value="causesuspens">
				<html:hidden property="faccsec"/>
				<html:hidden property="fregcompta"/>
				<html:hidden property="fstatut2"/>
			<tr>				
				<td width="140" >&nbsp;</td>
				<td width="<%=w1%>" class="lib">&nbsp;<b>Cause :</b></td>
				<td width="<%=w2%>" >
			  	<logic:equal name="listeDemFactAttForm" property="readonly" value="true">
					&nbsp;<bean:write name="listeDemFactAttForm"  property="causesuspens" />
				</logic:equal>
			  	<logic:equal name="listeDemFactAttForm" property="readonly" value="false">
					<html:text property="causesuspens" styleClass="input"  size="80" maxlength="250" onKeyPress="return submitenter(event)"/>
				</logic:equal>
				</td>
				<td width="140" >&nbsp;</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			</logic:equal>
		  	<logic:equal name="listeDemFactAttForm" property="mode" value="datesuivi">
				<html:hidden property="causesuspens"/>
			<tr>				
				<td width="140" >&nbsp;</td>
				<td width="200" class="lib">&nbsp;<b>Date accord p&ocirc;le :</b></td>
				<td width="300" >
			  	<logic:equal name="listeDemFactAttForm" property="readonly" value="true">
					&nbsp;<bean:write name="listeDemFactAttForm"  property="faccsec" />
				</logic:equal>
			  	<logic:equal name="listeDemFactAttForm" property="readonly" value="false">
					&nbsp;<html:text property="faccsec" styleClass="input"  size="11" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa');"/>
				</logic:equal>
				</td>
				<td width="140" >&nbsp;</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>				
				<td width="140" >&nbsp;</td>
				<td width="200" class="lib">&nbsp;<b>Date r&eacute;glement comptable :</b></td>
				<td width="300" >
			  	<logic:equal name="listeDemFactAttForm" property="readonly" value="true">
					&nbsp;<bean:write name="listeDemFactAttForm"  property="fregcompta" />
				</logic:equal>
			  	<logic:equal name="listeDemFactAttForm" property="readonly" value="false">
					&nbsp;<html:text property="fregcompta" styleClass="input"  size="11" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa');"/>
				</logic:equal>
				</td>
				<td width="140" >&nbsp;</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>				
				<td width="140" >&nbsp;</td>
				<td width="200" class="lib">&nbsp;<b>Statut CS2 :</b></td>
				<td width="300" >
			  	<logic:equal name="listeDemFactAttForm" property="readonly" value="true">
					&nbsp;<bean:write name="listeDemFactAttForm"  property="fstatut2" />
				</logic:equal>
			  	<logic:equal name="listeDemFactAttForm" property="readonly" value="false">
					&nbsp;<html:text property="fstatut2" styleClass="input" size="5" disabled="true" value="AE"/>
				</logic:equal>
				</td>
				<td width="140" >&nbsp;</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			</logic:equal>
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
				<logic:equal name="listeDemFactAttForm" property="readonly" value="true">
					<a href="javascript:Verifier(this.form, 'modifier');" onmouseover="window.status='';return true"><img src="/images/retour.gif" border="0"></a>
				</logic:equal>
				<logic:equal name="listeDemFactAttForm" property="readonly" value="false">
					<html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'creer');"/>&nbsp;&nbsp;&nbsp;
					<html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'modifier');"/> 
				</logic:equal>
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
