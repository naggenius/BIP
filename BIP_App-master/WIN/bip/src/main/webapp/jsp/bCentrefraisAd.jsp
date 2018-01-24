 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="centrefraisForm" scope="request" class="com.socgen.bip.form.CentrefraisForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bCentrefraisAd.jsp"/> 
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
   var Message="<bean:write filter="false"  name="centrefraisForm"  property="msgErreur" />";
   var Focus = "<bean:write name="centrefraisForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].codcfrais.focus();
   }
}

function Verifier(form, action, mode, flag)
{
 
   blnVerification = flag;
   form.mode.value=mode;
   form.action.value = action;

}

function ValiderEcran(form)
{
   if (blnVerification) {
		if (!ChampObligatoire(form.codcfrais, "un code centre de frais")) return false;
     	form.keyList0.value = form.codcfrais.value;
     	
	   	if (form.codcfrais.value=="0") {
	   		if (form.mode.value=='delete') {
					alert("Suppression du centre de frais 0 impossible");
	  				return false;
			}
			if (form.mode.value=='avant') {
					alert("Ce centre de frais permet d'accéder à toute la BIP");
	  				 return false;
			}
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise &agrave; jour des Centres de Frais<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/centrefrais"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="creer"/>
                    <html:hidden property="mode" value="insert"/>
                     <html:hidden property="keyList0"/> <!--code centre frais -->
					<html:hidden property="keyList1"/> <!--niveau d'habilitation -->
			  

                    <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                      <tr> 
                        <td align=center >&nbsp;</td>
                        <td >&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align=center >&nbsp;</td>
                        <td >&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align=center  ><b>Centre de frais :</b></td>
                        <td > 
                         <html:text property="codcfrais" styleClass="input" size="4" maxlength="3" onchange="return VerifierNum(this,3,0);"/>
                       
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
                    <table  border="0" width=63%>
                      <tr> 
                        <td align="right" width=15%> <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', 'insert', true);"/> 
                        </td>
                        <td align="center" width="7%">&nbsp;</td>
                        <td align="center" width=15%> <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', 'update',  true);"/> 
                        </td>
                        <td align="left" width=7%></td>
                        <td align="center" width=15%> <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', 'delete',  true);"/> 
                        </td>
                        <td align="left" width="7%">&nbsp;</td>
                        <td align="left" width=15%> <html:submit property="boutonComposition" value="Composition" styleClass="input" onclick="Verifier(this.form, 'suite', 'avant', true);"/> 
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
