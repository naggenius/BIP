 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="consulStatutForm" scope="request" class="com.socgen.bip.form.ConsulStatutForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fConsulstatutGe.jsp"/> 
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

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
tabVerif["pid"] = "VerifierAlphaMax(document.forms[0].pid)";

   var Message="<bean:write filter="false"  name="consulStatutForm"  property="msgErreur" />";
   var Focus = "<bean:write name="consulStatutForm"  property="focus" />";
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

function ValiderEcran(form) {
   if (blnVerification==true) {
	if ( !VerifFormat(null) ) return false;
	if (!ChampObligatoire(form.pid, "un code ligne BIP")) return false;
   }
   return true;
}

function recherchePID(champs){
	window.open("/recupPID.do?action=initialiser&nomChampDestinataire="+champs+"&windowTitle=Recherche Code Ligne BIP"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Amortissements<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/consulStatut"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="suite"/>
			<table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                    <tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>

	<tr><td class="lib" align=center><b>Code ligne BIP : &nbsp</b></td>
	<td>		<html:text property="pid" styleClass="input" size="4" maxlength="4" onchange="return VerifFormat(this.name);"/> 
			&nbsp;&nbsp;<a href="javascript:recherchePID('pid');" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" align="absbottom"></a>
                       
	</td></tr>
	
	<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr>
	
	
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
</body></html:html>
<!-- #EndTemplate -->
