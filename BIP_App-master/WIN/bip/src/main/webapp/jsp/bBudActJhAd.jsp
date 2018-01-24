 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="budActJhForm" scope="request" class="com.socgen.bip.form.BudActJhForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bBudActJhAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
    java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	
	java.util.ArrayList structureCliente = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("departement",hP); 
	pageContext.setAttribute("structureCliente", structureCliente);
    
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="budActJhForm"  property="msgErreur" />";
   var Focus = "<bean:write name="budActJhForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].annee.focus();
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
   if (blnVerification==true) {
	if (!ChampObligatoire(form.annee, "une ann�e")) return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Saisie des budgets - activit�s JH - en Kilo�uros<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/budActJh"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					   <html:hidden property="action"/>
					   <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
	                 
                    <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                      <tr> 
                        <td align=center >&nbsp;</td>
                        <td >&nbsp;</td>
                      </tr>
                      <tr> 
                        <td >&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td><b>Ann&eacute;e :</b></td>
                        <td>
						<html:text property="annee" styleClass="input" size="4" maxlength="4" onchange="return VerifierDate(this,'aaaa');"/>  
						</td>
                      </tr>
                      <tr> 
                        <td><b>Struture cliente : </b></td>
                        <td colspan="4">
                   			<html:select property="clicode" styleClass="input"> 
   								<html:options collection="structureCliente" property="cle" labelProperty="libelle" />
							</html:select>
                  		</td>
                      </tr>
                      <tr>
                        <td align=center>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align=center>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align=center>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                    </table>
					
					<table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonModifier" value="Valider" styleClass="input" onclick="Verifier(this.form, 'modifier', 'update', true);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
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
