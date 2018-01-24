 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="suiviCopiRefForm" scope="request" class="com.socgen.bip.form.SuiviCopiRefForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Suivi COPI</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/feSuiviCopiRef.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var pageAide = "aide/hvide.htm";
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

String sInitial;

sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
if (sInitial == null)
	sInitial = request.getRequestURI();
else
	sInitial = request.getRequestURI() + "?" + sInitial;
sInitial = sInitial.substring(request.getContextPath().length());




%>
var pageAide = "<%= sPageAide %>";



function MessageInitial()
{
   var Message="<bean:write filter="false"  name="suiviCopiRefForm"  property="msgErreur" />";
   var Focus = "<bean:write name="suiviCopiRefForm"  property="focus" />";

}

function Verifier(form, action, flag)
{
   blnVerification = flag;
   form.action.value = action;

} 
function ValiderEcran(form)
{
 
   return true;
}

</script>
<!-- #EndEditable -->  


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<html:form action="/suiviCopi"  onsubmit="return ValiderEcran(this);">
           		<input type="hidden" name="pageAide" value="<%= sPageAide %>">  
           		
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="suite"/>
<html:hidden property="initial" value="<%= sInitial %>"/>


<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr><td>&nbsp;</td></tr>
<tr><td><%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%><%=tb.printHtml()%></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td background="../images/ligne.gif"></td></tr>
<tr><td height="20" class="TitrePage">Suivi des budgets COPI - JH/K&euro; Export - Editions</td></tr>
<tr><td>&nbsp;</td></tr>
</table>

<table width="50%" border="1" cellpadding="20" cellspacing="0" class="tableBleu" align="center">
	<tr>
		<td colspan="2" align="rigth" >
			<html:radio name="suiviCopiRefForm" property="typeSuiviCopi" value="ExportExcelBud"></html:radio> <b>Export du COPI - Budget</b><br>
			<html:radio name="suiviCopiRefForm" property="typeSuiviCopi" value="ExportExcelReal"></html:radio> <b>Export du COPI - Réalisé (prestations)</b><br>
			<html:radio name="suiviCopiRefForm" property="typeSuiviCopi" value="ExportExcelPorte"></html:radio> <b>Export du portefeuille à un COPI</b><br>
			<html:radio name="suiviCopiRefForm" property="typeSuiviCopi" value="ExportExcelDPCOPI"></html:radio> <b>Export de la table des DP COPI</b>
		</td>
	</tr>
	
	<tr><td align="rigth" width="85%">
		<b>&nbsp;&nbsp;&nbsp;Pour les prestations uniquement (Tous financements : )</b> <br><br>
		<html:radio name="suiviCopiRefForm" property="typeSuiviCopi" value="SynthGlobal"></html:radio>&nbsp;&nbsp;<b>Etat de synthèse globale par client métier </b><br>
		<html:radio name="suiviCopiRefForm" property="typeSuiviCopi" value="EtatClient"></html:radio>&nbsp;&nbsp;<b>Etat pour un client - tous ses DP_COPI </b><br>	
		<html:radio name="suiviCopiRefForm" property="typeSuiviCopi" value="EtatSuivi"></html:radio>&nbsp;&nbsp;<b>Etat de suivi d'un DP_COPI </b>
	</td>
 	<td align="center" width="15%"> <select name="extension" class="input">
				<option value=".PDF" SELECTED>.PDF</option>
				<option value=".CSV">.CSV</option></select></td>		
	</tr>
    	
</table>

<table width="100%" border="0">
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><html:submit property="boutonSuite" value="Suite" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/></td></tr>
<tr><td align="center"><html:errors/></td></tr>
</table>
</html:form>
</body>
</html:html> 

<!-- #EndTemplate -->