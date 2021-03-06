 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractParamForm" scope="request" class="com.socgen.bip.form.ExtractParamForm" />
<html:html locale="true"> <!-- #EndEditable --> 
<!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bAuditAd.jsp"/>
<%
	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	java.util.ArrayList listExtract = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("extraction", hP); 
	pageContext.setAttribute("choixExtract", listExtract);
%>
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

   var Message="<bean:write filter="false"  name="extractParamForm"  property="msgErreur" />";

   if (Message != "") {
      alert(Message);
   }

}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;

}

function ValiderEcran(form)
{
  	form.titre.value=form.nomFichier.options[form.nomFichier.selectedIndex].text;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Audit 
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/extractParam"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
			<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="titre"/>
			<html:hidden property="mode" value="filtre"/>
                    <table cellspacing="2" cellpadding="2" class="tableBleu">
                      <tr> 
                        <td >&nbsp;</td>
                      </tr>
                      <tr> 
                        <td >&nbsp;</td>
                      </tr>
                      <tr> 
                      <td>
							<html:select property="nomFichier" styleClass="input" size="1"> 
							<html:options collection="choixExtract" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
						</tr>
                      <tr> 
                        <td >&nbsp;</td>
                        <td >&nbsp;</td>
                      <tr> 
                        <td >&nbsp;</td>
                        <td >&nbsp;</td>
                      <tr> 
                        <td >&nbsp;</td>
                        <td >&nbsp;</td>
                    </table>
                    <table  border="0" width=100%>
                      <tr> 
                        <td  width=100% align=center> <html:submit property="boutonValider" value="Suite" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
                        </td>
                      </tr>
                    </table>
                    <!-- #EndEditable --></div>
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

