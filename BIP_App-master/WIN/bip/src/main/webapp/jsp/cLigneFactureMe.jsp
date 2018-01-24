<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneFactureAffForm" scope="request" class="com.socgen.bip.form.LigneFactureAffForm" />
<html:html locale="true">
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- on utilise la page "jsp/eMonProfilAd.jsp" pour l'autorisation pour pouvoir appeller cette page dans 2 pages différentes -->
<bip:VerifUser page="jsp/eMonProfilAd.jsp"/>
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

function MessageInitial()
{
    var Message="<bean:write filter="false"  name="ligneFactureAffForm"  property="msgErreur" />";

    if (Message != "") {
        alert(Message);
    }

}

function Quitter() {
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
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->R&eacute;capitulatif facture<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/afficheFacture"  onsubmit="Quitter();"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="titrePage"/>
			<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>

		<table cellspacing="0" border="0" width="730" class="tableBleu">
			<tr>				
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>Soci&eacute;t&eacute; :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="socfact" /> - <bean:write name="ligneFactureAffForm"  property="soclib" /></td>
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>N° de facture :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="numfact" /></td>
				<td width="10" >&nbsp;</td>
			</tr>
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr>				
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>Date facture :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="datfact" /></td>
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>Montant HT :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="lmontht" /></td>
				<td width="10" >&nbsp;</td>
			</tr>
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr>				
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>N° du contrat :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="numcont" /></td>
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>Code comptable :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="lcodcompta" /></td>
				<td width="10" >&nbsp;</td>
			</tr>
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr>				
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>Ressource :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="ident" /> <bean:write name="ligneFactureAffForm"  property="rnom" /> <bean:write name="ligneFactureAffForm"  property="rprenom" /></td>
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>Co&ucirc;t journalier :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="coutj" /></td>
				<td width="10" >&nbsp;</td>
			</tr>
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr>				
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>Mois prestation :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="lmoisprest" /></td>
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>Consomm&eacute; :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="conso" /></td>
				<td width="10" >&nbsp;</td>
			</tr>
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr>				
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>Ecart :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="ecart" /></td>
				<td width="10" >&nbsp;</td>
				<td width="150" class="lib"><b>Nombre de jours :</b></td>
				<td width="200" ><bean:write name="ligneFactureAffForm"  property="cusag" /></td>
				<td width="10" >&nbsp;</td>
			</tr>
			<tr><td colspan="7">&nbsp;</td></tr>
		</table>
					<!-- #EndEditable --></div>
                </td>
              </tr>
            
            </table>
            <!-- #BeginEditable "fin_form" --></form><!-- #EndEditable -->
          </td>
        </tr>
		<tr><td align="center"><a href="javascript:Quitter();"><img src="/images/retour.gif" border="0"></a></td></tr>
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
