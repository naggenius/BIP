 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="lienLigneForm" scope="request" class="com.socgen.bip.form.LienLigneForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fLiencamoAd.jsp"/> 
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

}
function Verifier(form, action, mode, flag)
{
  blnVerification = flag;
  form.action.value = action;


}

function ValiderEcran(form)
{
   if (blnVerification) {
		if (form.action.value == 'retour') {
			history.back();
			return false;
		}
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Rattachement 
            en masse des lignes BIP - centre d'activit&eacute;<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/lienCamo"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <table border=0 cellspacing=2  cellpadding=2  class="tableBleu">
                    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                    <html:hidden property="mode" value="CAMO"/>
            		<html:hidden property="table" value="CAMO"/>
            		
                      <tr> 
                        <td align=center colspan="2">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align=center colspan="2">&nbsp;</td>
                      </tr>
                      <tr> 
                         <td align=center><b>Code centre d'activit&eacute; : </b></td>
		                  <td><b><bean:write name="lienLigneForm"  property="codcamo" /> - <bean:write name="lienLigneForm"  property="clibca" /> </b>
		                    <html:hidden property="codcamo"/>
		                    <html:hidden property="clibca"/>
		                    
		                  </td>
                      </tr>
                      <tr> 
                        <td align=center colspan="2">&nbsp;</td>
                      </tr>
                      </table>
                            <table border=0 cellspacing=0  cellpadding=2  class="tableBleu" >
                      <tr> 
                        <td class="lib"><b>Code ligne BIP</b></td>
                        <td class="lib"><b> Libellé ligne BIP </b></td>
                      </tr>
                      <tr> 
                        <td ><bean:write name="lienLigneForm"  property="pid_1" />
                          <html:hidden property="pid_1"/>
                        </td>
                        <td ><bean:write name="lienLigneForm"  property="pnom_1" />
                          <html:hidden property="flaglock_1"/>
                        </td>
                      </tr>
                      <tr >
                        <td ><bean:write name="lienLigneForm"  property="pid_2" />
                          <html:hidden property="pid_2"/>
                        </td>
                        <td ><bean:write name="lienLigneForm"  property="pnom_2" />
                          <html:hidden property="flaglock_2"/>
                        </td>
                      </tr>
                      <tr>
                        <td >
                          <bean:write name="lienLigneForm"  property="pid_3" />
                          <html:hidden property="pid_3"/>
                        </td>
                        <td ><bean:write name="lienLigneForm"  property="pnom_3" />
                          <html:hidden property="flaglock_3"/>
                        </td>
                      </tr>
                      <tr> 
                        <td >
                          <bean:write name="lienLigneForm"  property="pid_4" />
                          <html:hidden property="pid_4"/>
                        </td>
                        <td ><bean:write name="lienLigneForm"  property="pnom_4" />
                          <html:hidden property="flaglock_4"/>
                        </td>
                      </tr>
                      <tr>
                        <td > 
                         <bean:write name="lienLigneForm"  property="pid_5" />
                          <html:hidden property="pid_5"/>
                        </td>
                        <td ><bean:write name="lienLigneForm"  property="pnom_5" />
                          <html:hidden property="flaglock_5"/>
                        </td>
                      </tr>
                      <tr>
                        <td >
                          <bean:write name="lienLigneForm"  property="pid_6" />
                          <html:hidden property="pid_6"/>
                        </td>
                        <td ><bean:write name="lienLigneForm"  property="pnom_6" />
                          <html:hidden property="flaglock_6"/>
                        </td>
                      </tr>
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                    </table>
					 <table  border="0" width=100%>
                      <tr> 
                        <td align="right" width=33%> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', 'update',  true);"/> 
                        </td>
                        <td align="center" width=33%> <html:submit property="boutonModifier" value="Corriger" styleClass="input" onclick="Verifier(this.form, 'retour',null, true);"/> 
                        </td>
                        <td  width=33%> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null,true);"/> 
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
