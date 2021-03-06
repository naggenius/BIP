 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="majStatForm" scope="request" class="com.socgen.bip.form.MajStatForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fMajstatAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var blnVerifFormat  = true;
var tabVerif		= new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="majStatForm"  property="msgErreur" />";
   var Focus = "<bean:write name="majStatForm"  property="focus" />";
   
   tabVerif["pid"]  = "VerifierAlphaMax(document.forms[0].pid)";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {document.forms[0].pid.focus();}
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;

}

function ValiderEcran(form)
{
   if (blnVerification==true) {
    if ( !VerifFormat(null) ) return false;

	if (!ChampObligatoire(form.pid, "un code ligne BIP")) return false;
	
   }
   return true;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise � jour du statut d'une ligne BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/majStat"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="suite"/>  
			<html:hidden property="mode" value="update"/>
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center  ><b>Code ligne BIP :&nbsp;</b></td>
                  <td>
				  <html:text property="pid" styleClass="input" size="4" maxlength="4" onchange="return VerifFormat(this.name);"/> 
                   </td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
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
</body></html:html>
<!-- #EndTemplate -->
