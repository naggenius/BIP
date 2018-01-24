<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<!-- #BeginEditable "imports" -->
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*" errorPage="../jsp/erreur.jsp"%>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true">
<!-- #EndEditable -->
<!-- #BeginTemplate "/Page_extraction.dwt" -->
<head>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>
<!-- #BeginEditable "doctitle" -->
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/xSansParam.jsp" />
<script language="JavaScript" src="../js/function.cjs"
	type="text/javascript"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript" type="text/javascript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
var tabVerif        = new Object();
<%
	String sTitre;
	String sInitial;
	String sJobId;
%>


function MessageInitial()
{
	<%
		sJobId = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("jobId")));
		
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)
		{
			//redirect sur la page d'erreur
			sTitre = "Pas de titre";
		}
		
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	tabVerif["p_param6"] = "Ctrl_dpg_generique(document.extractionForm.p_param6)";
	
	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	
		// initialisation de la liste avec le dpg par défaut lors du première affichage de la page
	
		document.forms[0].p_param6.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip"  property="dpg_Defaut" />" );
	
	
}

function majListe(form)
{
	bTestGroupe = false;
	sListe = "";
	if (form.ck1.checked)
	{
		if (form.listeReports.value == "")
			sListe="1";
		else
			sListe = sListe + ";1";
	}

	if (form.ck2.checked)
	{
		bTestGroupe = true;
		if (form.listeReports.value == "")
			sListe="2";
		else
			sListe = sListe + ";2";
	}
	
	form.listeReports.value = sListe;
	
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

function ValiderEcran(form)
{
		if (!ChampObligatoire(form.p_param6, "un code DPG")) return false;
	document.extractionForm.submit.disabled = true;
	return true;
}
</script>
<!-- #EndEditable -->
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0"
	onLoad="MessageInitial();">
	<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
		<div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>&nbsp;</td>
	</tr>
<!-- 	<tr> -->
<!-- 		<td background="../images/ligne.gif"></td> -->
<!-- 	</tr> -->
	<tr>
		<td height="20" class="TitrePage"><%=sTitre%></td>
	</tr>
<!-- 	<tr> -->
<!-- 		<td background="../images/ligne.gif"></td> -->
<!-- 	</tr> -->
</table>

<html:form action="/extract" onsubmit="return ValiderEcran(this);">
<table border="0" align="center" width="70%" cellpadding="1" cellspacing="1" class="tableBleu">
	
		<!-- #BeginEditable "debut_hidden" -->

		<html:hidden property="arborescence" value="<%= arborescence %>" />
		<input type="hidden" name="jobId" value="<%=sJobId%>">
		<input type="hidden" name="initial" value="<%= sInitial %>">
		<html:hidden property="listeReports" styleClass="input" />
		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		<!-- #EndEditable -->

		<tr>
			<td colspan=5 height="20">&nbsp;</td>
		</tr>
		<tr>
			<td class="texte" nowrap width="40%" align="left"><B>PCA4 par Groupe éclaté par mois</B></td>
			<td width="2%"><html:checkbox name="extractionForm" property="ck1" value="1" onChange="majListe(this.form);" /></td>
			<td width="4%">&nbsp;</td>
			<td class="texte" nowrap width="40%" align="left"><B>PCA4 par Client avec sous-traitance</B></td>
			<td width="2%"><html:checkbox name="extractionForm" property="ck2" value="2" onChange="majListe(this.form);" /></td>
			
		</tr>
		<tr>
			<td colspan=5>&nbsp;</td>
		</tr>
	
</table>
<table border="0" align="center" width="20%" cellpadding="2" cellspacing="2" class="tableBleu">
	<tr>
		<td colspan=2>&nbsp;</td>
	</tr>
	<tr align="left">
		<td class="texte" align="right"><B>Code DPG :</B></td>
		<td align="left"><html:text property="p_param6" styleClass="input" size="7" maxlength="7" onchange="return VerifFormat(this.name);" /></td>
	</tr>
	<tr>
		<td colspan=2>&nbsp;</td>

	</tr>
	<tr>
		<td colspan="2">
		<div align="center">
			<html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, 'Extraire', true);" />
		</div>
		</td>
	</tr>
	<tr>
		<td>
		<div align="center"><html:errors /><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
		</td>
	</tr>
</table>
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>

</html:form>


</body>
</html:html>
<!-- #EndTemplate -->
