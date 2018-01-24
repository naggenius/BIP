<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="lienLigneForm" scope="request" class="com.socgen.bip.form.LienLigneForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fLiendpAd.jsp"/> 
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
   var Message="<bean:write filter="false"  name="lienLigneForm"  property="msgErreur" />";
   var Focus = "<bean:write name="lienLigneForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
	    document.forms[0].pid_1.focus();
    }
}

function Verifier(form, action, mode, flag){
  blnVerification = flag;
  if (action=='annuler'){
    form.action.value = "annuler";
  }
  else {
     form.action.value = "modifier";
  }
}

function ValiderEcran(form)
{
  if (blnVerification == true) {
     if (!ChampObligatoire(form.pid_1, "un code ligne BIP")) return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
            Liens lignes BIP  - MO<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/lienMo"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
            <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" >
                <tr> 
                  <td align=center colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center><b>Code MO : </b></td>
                  <td><b><bean:write name="lienLigneForm"  property="clicode" /> - <bean:write name="lienLigneForm"  property="clilib" /> </b>
                    <html:hidden property="clicode"/>
                    <html:hidden property="clilib"/>
                    
                  </td>
                </tr>
                <tr> 
                  <td align=center colspan="2">&nbsp;</td>
                </tr>
                </table>
               <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" >
                <tr> 
                  <td align=center class="lib" ><b>Code ligne BIP : </b></td>
                </tr>
                <tr> 
                  <td align="center">
                    <html:text property="pid_1" styleClass="input" size="4" maxlength="4" onchange="return VerifierAlphaMax(this);"/>
                  </td>
                </tr>
                <tr> 
                  <td align="center">
                    <html:text property="pid_2" styleClass="input" size="4" maxlength="4" onchange="return VerifierAlphaMax(this);"/>
                  </td>
                </tr>
                <tr> 
                  <td align="center">
                    <html:text property="pid_3" styleClass="input" size="4" maxlength="4" onchange="return VerifierAlphaMax(this);"/>
                  </td>
                </tr>
                <tr> 
                  <td align="center">
                    <html:text property="pid_4" styleClass="input" size="4" maxlength="4" onchange="return VerifierAlphaMax(this);"/>
                  </td>
                </tr>
                <tr> 
                  <td align="center">
                    <html:text property="pid_5" styleClass="input" size="4" maxlength="4" onchange="return VerifierAlphaMax(this);"/>
                  </td>
                </tr>
                <tr> 
                  <td  align="center">
                    <html:text property="pid_6" styleClass="input" size="4" maxlength="4" onchange="return VerifierAlphaMax(this);"/>
                  </td>
                </tr>
                <tr>
                  <td >&nbsp;</td>
                </tr>
                <tr>
                  <td >&nbsp;</td>
                </tr>
                <tr>
                  <td >&nbsp;</td>
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
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
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
Integer id_webo_page = new Integer("1042"); 
com.socgen.bip.commun.form.AutomateForm formWebo = lienLigneForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
