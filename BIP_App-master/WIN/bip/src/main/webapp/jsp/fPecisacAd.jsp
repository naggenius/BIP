<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="pecisacForm" scope="request" class="com.socgen.bip.form.PecisacForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fPecisacAd.jsp"/> 
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


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="pecisacForm"  property="msgErreur" />";
   var Focus = "<bean:write name="pecisacForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].cp1.focus();
   }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = "valider";
}

function ValiderEcran(form)
{
   if (blnVerification) {
	
   }

   return true;
}
function rechercheCP(champs){
	window.open("/recupIdPersonne.do?action=initialiser&nomChampDestinataire="+champs+"&rafraichir=OUI&windowTitle=Recherche Code Client&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
} 
function nextFocusCP2() {		document.forms[0].cp2.focus();}
function nextFocusCP3() {		document.forms[0].cp3.focus();}
function nextFocusCP4() {		document.forms[0].cp4.focus();}
function nextFocusCP5() {		document.forms[0].cp5.focus();}
function nextFocusValider() {		document.forms[0].boutonValider.focus();}
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Prise 
            en charge ISAC<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/pecisac"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			
			  <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td colspan=2 align=center>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2 align=center>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2 align=center class="lib"><B>Chefs de projet :</B> </td>
                </tr>
                <tr> 
                  <td>CP1 :</td>
                  <td>
                    <html:text property="cp1" styleClass="input" size="6" maxlength="5" /> 
                    <a href="javascript:rechercheCP('cp1');" onFocus="javascript:nextFocusCP2();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" align="absbottom"></a>
                  </td>
                </tr>
                <tr> 
                  <td>CP2 :</td>
                  <td> 
                    <html:text property="cp2" styleClass="input" size="6" maxlength="5" />
                    <a href="javascript:rechercheCP('cp2');" onFocus="javascript:nextFocusCP3();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" align="absbottom"></a>
                  </td>
                </tr>
                <tr> 
                  <td>CP3 :</td>
                  <td> 
                    <html:text property="cp3" styleClass="input" size="6" maxlength="5" />
                    <a href="javascript:rechercheCP('cp3');" onFocus="javascript:nextFocusCP4();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" align="absbottom"></a>
                  </td>
                </tr>
                <tr> 
                  <td>CP4 :</td>
                  <td> 
                    <html:text property="cp4" styleClass="input" size="6" maxlength="5" />
                    <a href="javascript:rechercheCP('cp4');" onFocus="javascript:nextFocusCP5();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" align="absbottom"></a>
                  </td>
                </tr>
                <tr> 
                  <td>CP5 :</td>
                  <td> 
                   <html:text property="cp5" styleClass="input" size="6" maxlength="5" />
                   <a href="javascript:rechercheCP('cp5');" onFocus="javascript:nextFocusValider();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" align="absbottom"></a>
                  </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
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
                <td align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
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
</body>
<% 
Integer id_webo_page = new Integer("1066"); 
com.socgen.bip.commun.form.AutomateForm formWebo = pecisacForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
