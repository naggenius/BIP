<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="factValideeForm" scope="request" class="com.socgen.bip.form.FactValideeForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fFactValideeOr.jsp"/><script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var blnVerifFormat  = true;
var tabVerif        = new Object();
function MessageInitial()
{
 tabVerif["lmoisprest"] = "VerifierDate2(document.forms[0].lmoisprest,'mmaaaa')";
   tabVerif["lcodcompta"] = "VerifierAlphaMax(document.forms[0].lcodcompta)";

    var Message="<bean:write filter="false"  name="factValideeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="factValideeForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].lmoisprest.focus();
    }
}

function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
form.mode.value = mode;

}

function ValiderEcran(form)
{
   if (blnVerification) {
	if ( !VerifFormat(null) ) return false;
	if (!ChampObligatoire(form.lmoisprest, "le mois/année de la prestation")) return false;
	if (!ChampObligatoire(form.lcodcompta, "le code comptable")) return false;
	if (!confirm("Voulez-vous modifier cette ligne de facture ?")) return false;
   }

   return true;
}




function rechercheCodeComptable(){
	window.open("/recupCodeCompta.do?action=initialiser&nomChampDestinataire=lcodcompta&windowTitle=Recherche Code Comptable&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=600") ;
}  

function nextFocusCodeCompta(){
	document.forms[0].lcodcompta.focus();
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
            <div align="center"><!-- #BeginEditable "barre_haut" --> 
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Correction 
            d'une ligne de facture valid&eacute;e par SEGL<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/factValidee"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
<html:hidden property="action"/>
<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
<html:hidden property="keyList0"/>
<html:hidden property="keyList1"/> 
 <html:hidden property="keyList2"/>
<html:hidden property="keyList3"/> 
<html:hidden property="keyList4"/>
<html:hidden property="keyList5"/> 
<html:hidden property="keyList6"/>
<html:hidden property="keyList7"/> 
<html:hidden property="msg_info"/> 
<html:hidden property="lnum"/> 
<html:hidden property="fdeppole"/>
<html:hidden property="flaglock"/>  
<html:hidden property="fmontht"/>              
<html:hidden property="ftva"/> 
<html:hidden property="fmontttc"/>
 
              <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib">Code société :</td>
                  <td ><bean:write name="factValideeForm"  property="socfact" /> <html:hidden property="socfact"/>
                  </td>
                  <td>&nbsp;</td>
                  <td class="lib">Société :</td>
                  <td ><bean:write name="factValideeForm"  property="soclib" /> <html:hidden property="soclib"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">N° de contrat :</td>
                  <td><bean:write name="factValideeForm"  property="numcont" /> <html:hidden property="numcont"/>
                  </td>
                  <td>&nbsp;</td>
                  <td class="lib">N° d'avenant :</td>
                  <td><bean:write name="factValideeForm"  property="cav" /> <html:hidden property="cav"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">N° de facture :</td>
                  <td><bean:write name="factValideeForm"  property="numfact" /> <html:hidden property="numfact"/>
                  </td>
                  <td>&nbsp;</td>
                  <td class="lib">Type de facture :</td>
                  <td><bean:write name="factValideeForm"  property="typfact" /> <html:hidden property="typfact"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Date de facture :</td>
                  <td colspan=4><bean:write name="factValideeForm"  property="datfact" /> <html:hidden property="datfact"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Identifiant :</td>
                  <td><bean:write name="factValideeForm"  property="ident" /> <html:hidden property="ident"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Nom :</td>
                  <td><bean:write name="factValideeForm"  property="rnom" /> <html:hidden property="rnom"/>
                  </td>
                 <td>&nbsp;</td>
                  <td class="lib">Prénom :</td>
                  <td><bean:write name="factValideeForm"  property="rprenom" /> <html:hidden property="rprenom"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Montant HT :</td>
                  <td><bean:write name="factValideeForm"  property="lmontht" /> <html:hidden property="lmontht"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Mois/année de prestation :</b></td>
                  <td> 
                    <html:text property="lmoisprest" styleClass="input" size="7" maxlength="7" onchange="return VerifFormat(this.name);"/> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code comptable :</b></td>
                  <td> 
                    <html:text property="lcodcompta" styleClass="input" size="16" maxlength="11" onchange="return VerifFormat(this.name);"/> 
                    <a href="javascript:rechercheCodeComptable();" onFocus="javascript:nextFocusCodeCompta();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Comptable" title="Rechercher Code Comptable" align="absbottom"></a> 	
                  </td>
                  
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
				<tr> 
                  <td >&nbsp;</td>
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
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', 'lignes',true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', 'annuler', false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
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
</body>
<% 
Integer id_webo_page = new Integer("3007"); 
com.socgen.bip.commun.form.AutomateForm formWebo = factValideeForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
