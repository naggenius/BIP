<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/ajaxtags.tld" prefix="ajax" %>


<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true"> 
<jsp:useBean id="copiValidDpForm" scope="request" class="com.socgen.bip.form.CopiValidDpForm" />
<jsp:useBean id="listeRechercheId" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
<script type="text/javascript" src="../js/ajax/prototype.js"></script>
<script type="text/javascript" src="../js/ajax/scriptaculous/scriptaculous.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_crossframe.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_iframe.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_hide.js"></script>
<script type="text/javascript" src="../js/ajax/overlibmws/overlibmws_shadow.js"></script>
<script type="text/javascript" src="../js/ajax/ajaxtags.js"></script>
<script type="text/javascript" src="../js/ajax/ajaxtags_controls.js"></script>
<script type="text/javascript" src="../js/ajax/ajaxtags_parser.js"></script>
 

<link rel="stylesheet" type="text/css" href="../css/ajax/displaytag.css" />

<title>Page BIP</title>
 <style type="text/css">
  .autocomplete {
	
	position: absolute;
	color: #333;
	background-color: #fff;
	border: 1px solid #666;
	font-family: Verdana;
	overflow-y: auto;
	height: 150px;
	
	
}

.autocomplete ul {
	padding: 0;
	margin: 0;
	list-style: none;
	overflow: hidden;
	width: 400px;
}

.autocomplete li {
	display: block;
	white-space: nowrap;
	cursor: pointer;
	margin: 0px;
	padding-left: 5px;
	padding-right: 5px;
	border: 1px solid #fff;
	text-align: justify;
	
}

.autocomplete li.selected {
	background-color: #ffb;
	border-top: 1px solid #9bc;
	border-bottom: 1px solid #9bc;
	font-weight:bold;
	
}
  </style>

<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/valideDpcopiPro.do"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">


<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	int nbligne = 0;
	
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="copiValidDpForm"  property="msgErreur" />";
   var Focus = "<bean:write name="copiValidDpForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }

   
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
   
}

function ValiderEcran(form)
{
	if (form.action.value == 'valider') {
		if (!ChampObligatoire(form.dpcopi_prov, "le code DP COPI provisoire")) return false;  
		if (!ChampObligatoire(form.dpcopi_def, "le code DP COPI définitif")) return false; 
		if (!ChampObligatoire(form.dpcode, "le code dossier projet")) return false;   
	}
	
	if (form.action.value == 'refresh') {
		if (!ChampObligatoire(form.dpcopi_prov, "le code DP COPI provisoire")) return false;  
	}
	
	if (form.action.value == 'annuler') {
		form.dpcopi_prov.value="";  
		form.dpcopi_def.value="";  
		form.dpcode.value=""; 
	}
	
   return true;
}

function paginer(page, index , action){
	document.forms[0].action.value = action;
	document.forms[0].page.value   = page;
    document.forms[0].index.value  = index;
    document.forms[0].submit();
}

function test(){

if (document.forms[0].dpcopi_prov.value.substr(0,2) != '88') {
alert("tout code DP COPI provisoire doit commencer par '88'");
 document.forms[0].boutonConsulter.disabled = true;
 <% if (listeRechercheId.getCount()!=0){%>

  document.forms[0].boutonValider.disabled = true; 
 <%}%>
}
else
{
document.forms[0].boutonConsulter.disabled = false;
  <% if (listeRechercheId.getCount()!=0){%>
  document.forms[0].boutonValider.disabled = true; 
 <%}%>
 }
}


</script>
<!-- #EndEditable --> 

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr><td>&nbsp;</td></tr>
        <tr><td> 
            <div align="center"><!-- #BeginEditable "barre_haut" --> 
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%><!-- #EndEditable --></div>
          </td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td background="../images/ligne.gif"></td></tr>
        <tr><td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Validation d'un DP COPI provisoire<!-- #EndEditable --></td></tr>
        <tr><td background="../images/ligne.gif"></td></tr>
    </table>
     
    <html:form action="/valideDpcopiPro"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
	<html:hidden property="mode" value="update"/>
	<html:hidden property="libelle"/>
	<html:hidden property="page" value="modifier"/>
	<input type="hidden" name="index" value="modifier">
	
    <table width="80%" border="0" cellpadding=2 cellspacing=2 class="tableBleu" align="center">
    	<tr><td colspan=6>&nbsp; </td></tr>
        <tr><td align="center" colspan=6><b>Cet écran vous permet de changer le code d'un DP COPI provisoire par un code définitif : </b></td></tr>
        <tr><td colspan=6>&nbsp; </td></tr>
        <tr><td align="right" ><b>Code DP COPI provisoire :</b> </td>
            <td align="left" ><html:text property="dpcopi_prov" styleClass="input" size="7" maxlength="6" /> <span id="indicator3" style="display:none;"><img src="../images/indicator.gif" /></span></td>
            <td align="right" ><b>Code DP COPI définitif : </b></td>
            <td align="left" ><html:text property="dpcopi_def" styleClass="input" size="7" maxlength="6" /></td>
            <td align="right"><b>Code DP : </b></td>
            <td align="left"><html:text property="dpcode" styleClass="input" size="6" maxlength="5" onchange="return VerifierNum(this,5,0);"/></td>
        	</tr>
        <tr><td colspan=6>&nbsp; </td></tr>
   	</table>
   	
   	<ajax:autocomplete
								  source="dpcopi_prov"
  								  target="dpcopi_prov"
  								  parameters="libelle={dpcopi_prov}"
 								  baseUrl="/autocompletedpCopi.do"
  								  className="autocomplete"
                                  indicator="indicator3"
                                  minimumCharacters="2"
                                  preFunction="test"/>

	<table  border="0" width=100%>
		<tr><td  align="center" ><html:submit property="boutonConsulter" value="Consulter" styleClass="input" onclick="Verifier(this.form, 'refresh', true);"/></td></tr>
    </table>

            <!-- #BeginEditable "fin_form" -->
	<!-- #EndEditable --> 
         
    <table>
    	<tr><td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          	</td></tr>
    </table>
<%if (listeRechercheId.getCount()!=0) {%>


<table cellspacing="2" cellpadding="2" class="tableBleu" WIDTH="95%" align="center" border=0>
	<tr><td colspan=10 align="center"><b> Libellé : </b> <bean:write name="copiValidDpForm" property="libelle"/></td></tr>
	<tr><td colspan=10>&nbsp; </td></tr>
	<tr align="center" ><td class="lib"><b>Année</b></td>
                  		<td class="lib"><b>Date</b></td>
                  		<td class="lib"><b>Métier</b></td>
                  		<td class="lib"><b>Jh cout Total</b></td>
                  		<td class="lib"><b>Jh arb. dem.</b></td>
                  		<td class="lib"><b>Jh arb. dec.</b></td>
                  		<td class="lib"><b>Jh cant. dem.</b></td>
                  		<td class="lib"><b>Jh arb. dec</b></td>
                  		<td class="lib"><b>Type</b></td>
                  		<td class="lib"><b>Fournisseur</b></td>
    </tr>
<% int i =0;
    String[] strTabCols = new String[] {  "fond1" , "fond2" };
    String[] extension = new String[] { "Violet.bmp" , ".bmp" };
%>     
    <logic:iterate id="element"  name="listeRechercheId"  length="<%=listeRechercheId.getCountInBlock()%>" 
          					offset="<%=listeRechercheId.getOffset(0)%>" type="com.socgen.bip.metier.CopiValidDp" indexId="index"> 
							<% if ( i == 0) i = 1; else i = 0; nbligne ++; 	%>
	<tr class="contenu"><td class="<%= strTabCols[i] %>" align="left"><bean:write name="element" property="annee" /></td>
						<td class="<%= strTabCols[i] %>" align="left"><bean:write name="element" property="metier" /></td>
						<td class="<%= strTabCols[i] %>" align="left"><bean:write name="element" property="date_copi" /></td>
						<td class="<%= strTabCols[i] %>" align="right"><bean:write name="element" property="jh_couttotal" /></td>
						<td class="<%= strTabCols[i] %>" align="right"><bean:write name="element" property="jh_arbdemandes" /></td>
						<td class="<%= strTabCols[i] %>" align="right"><bean:write name="element" property="jh_arbdecides" /></td>
						<td class="<%= strTabCols[i] %>" align="right"><bean:write name="element" property="jh_cantdemandes" /></td>
						<td class="<%= strTabCols[i] %>" align="right"><bean:write name="element" property="jh_cantdecides" /></td>
						<td class="<%= strTabCols[i] %>" align="left"><bean:write name="element" property="type_demande" /></td>
						<td class="<%= strTabCols[i] %>" align="left"><bean:write name="element" property="four_copi" /></td>
	</tr>							
	</logic:iterate>
	<tr><td align="center" colspan="10" class="contenu"><bip:pagination beanName="listeRechercheId"/></td></tr>
</table>

<table  border="0" width=70% align="center">
		<tr><td  align="center" ><html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true);"/></td>
    	<td  align="center" ><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', true);"/></td></tr>
</table>
<%} %>

</html:form>                              
</body><% 
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = copiValidDpForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
