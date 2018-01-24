<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneBipMoForm" scope="request" class="com.socgen.bip.form.LigneBipMoForm" />
<html:html locale="true">
<head> 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/fFermeLigneAl.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide"))); %>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
  var Message="<bean:write filter="false"  name="ligneBipMoForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ligneBipMoForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].pid.focus();
   }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}

function ValiderEcran(form)
{
	if (!VerifierAlphaMax(form.pid)) return false;
	if (!ChampObligatoire(form.pid, "un code ligne BIP")) return false;
	if (form.recupDate.value=="NON")
		if (!ChampObligatoire(form.adatestatut, "une date de statut")) return false;

	// dans le cas où la touche entrée est appuyée
	if ((form.action==null) || (form.action.value=="")) form.action.value = "modifier";
	return true;
}

function recherchePID(champs){
	window.open("/recupPID.do?action=initialiser&nomChampDestinataire="+champs+"&windowTitle=Recherche Code Ligne BIP"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
} 

function nextFocusCodeDPG(){
	if (document.forms[0].recupDate.value=="NON")
		document.forms[0].adatestatut.focus();
	else
		document.forms[0].boutonValider.focus();
}

</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
        <tr > 
          <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr align="left"> 
          <td height="20" class="TitrePage">Lignes BIP - Fermeture</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td> 
          	<html:form action="/fermeLigneBip"  onsubmit="return ValiderEcran(this);">
            <div align="center">
			  <input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
			  <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
			  <html:hidden property="recupDate"/> 
              
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td height="20">&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
<% if (ligneBipMoForm.getRecupDate().equals("OUI")) { %>
                <tr align="left"> 
                  <td class="texte"><b>Code ligne BIP : </b></td>
                  <td class="texte"> <html:text property="pid" styleClass="input" size="4" maxlength="4" onchange="return VerifierAlphaMax(this);"/> 
                 &nbsp;<a href="javascript:recherchePID('pid');" onFocus="javascript:nextFocusCodeDPG();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" style="vertical-align : middle;"></a>
                  </td>
                </tr>
<% } else { %>
                <tr align="left"> 
                  <td class="texte"><b>Code ligne BIP : </b></td>
                  <td class="texte">
                  	  <bean:write name="ligneBipMoForm" property="pid" />&nbsp;-&nbsp;<bean:write name="ligneBipMoForm" property="pnom" />
                  	  <html:hidden property="pid" />
                  </td>
                </tr>
                <tr align="left"> 
                  <td class="texte"><b>Date de fermeture<br />(format mm/aaaa)</b></td>
                  <td class="texte"> 
                  	<html:text property="adatestatut" styleClass="input" size="7" maxlength="7" onchange="return VerifierDate(this,'mm/aaaa');"  /> 
                  *
                  </td>
                  
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td class="texte" colspan="2">
                  	<u><b>(*) Date au plus t&ocirc;t &agrave; laquelle peut-&ecirc;tre ferm&eacute;e la ligne.<br />
                  		Les JxH saisis au titre du mois de fermeture sont pris en compte par la BIP</b></u>
                  </td>
                </tr>
<% } %>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td align="center" class="texte"> 
                	<html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/> 
<% if (!ligneBipMoForm.getRecupDate().equals("OUI")) { %>
                	<html:submit property="boutonRetour" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', true);"/> 
<% } %>
                </td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
<% 
Integer id_webo_page = new Integer("5001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = ligneBipMoForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
