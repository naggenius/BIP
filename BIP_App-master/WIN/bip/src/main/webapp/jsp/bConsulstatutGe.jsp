 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="consulStatutForm" scope="request" class="com.socgen.bip.form.ConsulStatutForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
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


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="consulStatutForm"  property="msgErreur" />";
   var Focus = "<bean:write name="consulStatutForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  
}

function Verifier(form, action,flag)
{
  blnVerification = flag;
  form.action.value = action;
   
}

function ValiderEcran(form)
{
   if (blnVerification == true) {
	if ( !VerifFormat(null) ) return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Consulter 
            le statut d'une ligne BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/consulStatut"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
				  <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
				  <html:hidden property="flaglock"/>
                    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="lib">Code ligne BIP :</td>
                        <td>
						<bean:write name="consulStatutForm"  property="pid" />
                    	<html:hidden property="pid"/>
						<bean:write name="consulStatutForm"  property="pnom" />
                    	<html:hidden property="pnom"/>
                        &nbsp; </td>
                      </tr>
                      <tr> 
                        <td class="lib">Filiale : </td>
                        <td>
						<bean:write name="consulStatutForm"  property="filsigle" />
                    	<html:hidden property="filsigle"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Statut de la ligne BIP :</td>
                        <td>
						<bean:write name="consulStatutForm"  property="libstatut" />
                    	<html:hidden property="libstatut"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Date du statut :</td>
                        <td>
						<bean:write name="consulStatutForm"  property="adatestatut" />
                    	<html:hidden property="adatestatut"/>
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
	 
	  <table width="100%" border="0">
              <tr> 
			  <td width="25%"> 
                  <div align="center"> 
                <html:submit property="boutonAnnuler" value="Quitter" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                </div>
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
