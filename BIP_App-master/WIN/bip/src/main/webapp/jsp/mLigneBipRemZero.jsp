<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneBipRemZeroForm" scope="request" class="com.socgen.bip.form.LigneBipRemZeroForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/mLigneBipRemZero.jsp"/>

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
   var Message="<bean:write filter="false"  name="ligneBipRemZeroForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ligneBipRemZeroForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
}

function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;

}

function ValiderEcran(form)
{ 
   if (blnVerification == true) 
   {
	if ( !VerifFormat(null) ) return false; 
	if (form.pid.value=='') 
	{ 
		alert("Choisissez une ligne BIP");
   	 	return false;
	}
	if (!confirm("Voulez-vous vraiment initialiser les consommés de la ligne BIP ?")) return false;
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
          <td height="20" class="TitrePage">Initialisation des consomm&eacute;s</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td><!-- Formulaire --> <html:form action="/remisezero"  onsubmit="return ValiderEcran(this);">
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
									
              <table cellspacing="2" cellpadding="2" class="tableBleu">
			    <tr> 
                  <td colspan="3">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="3">&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan="3">
                  	<b> 
                    	<H1><font color="purple"><A><font color="#B980BF">A T T E N T I O N</font></a></font></H1>
                    </b>
                  </td>
                </tr>
                <tr> 
                  <td align=center colspan="3">
                  	<b>
                  		<font color="#B980BF">CETTE PROCEDURE EST IRREVERSIBLE</font>
                  	</b>
                  </td>
                </tr>
                <tr> 
                  <td align=center colspan="3">&nbsp;</td>
                </tr>                
                <tr>
                  <td>&nbsp;</td>
				</tr>
				<tr></tr>
              </table>
              <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr>     
				  <td class=lib><b>Code ligne BIP : </b></td>
                  <td>
	                  <input type="text" name="pid" size="4" maxlength="4" onchange="return VerifierAlphaMax(this);"/>
                      <a href="javascript:recherchePID('pid');"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" align="absbottom"></a>
				  </td>
				</tr>
				<tr>
				  <td>&nbsp;</td>
                  <td>&nbsp;</td>
				</tr>
    			<tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
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
                <td width="50%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
              </tr>
            </table>
            <!-- "fin_form" --></html:form><!-- #EndEditable --> 
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
Integer id_webo_page = new Integer("1065"); 
com.socgen.bip.commun.form.AutomateForm formWebo = ligneBipRemZeroForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
