 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="datesEffetForm" scope="request" class="com.socgen.bip.form.DatesEffetForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmDatesEffetAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var tabVerif        = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   tabVerif["codaction"] = "VerifierAlphaMaxCarSpecDateEffet(document.forms[0].codaction)";
   tabVerif["codversion"] = "VerifierAlphaMaxCarSpecDateEffet(document.forms[0].codversion)";
   
   var Message="<bean:write filter="false"  name="datesEffetForm"  property="msgErreur" />";
   var Focus = "<bean:write name="datesEffetForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].codaction.focus();
   }
}

function Verifier(form, action, flag)
{
   blnVerification = flag;
   form.action.value = action;

} 
function ValiderEcran(form)
{
   if (blnVerification==true) {
	if (form.codaction && !ChampObligatoire(form.codaction,"le code action")) return false;
	if (form.codversion && !ChampObligatoire(form.codversion,"le code version")) return false;
	
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
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise &agrave; jour des Paramètres BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
  		<!-- #BeginEditable "debut_form" --><html:form action="/majDatesEffet" onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
        <tr> 
          <td>		 
		    <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="creer"/>
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
                  	<td align=center><b>Code Action	: &nbsp </b></td>
                  	<td> 
                     <html:text property="codaction" styleClass="input" size="25" maxlength="25"  onchange="return  VerifierAlphaMaxCarSpecDateEffet(this);"/>
					</td>
                </tr>
                <tr> 
                  	<td align=center><b>Code Version : &nbsp </b></td>
                  	<td> 
                     <html:text property="codversion" styleClass="input" size="8" maxlength="8"  onchange="return  VerifierAlphaMaxCarSpecDateEffet(this);"/>
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
			  <!-- #EndEditable --></div>
            
		</td>
		</tr>
		<tr>
		<td align="center">

			<table width="100%" border="0">
                <tr> 
                <td width="20%">&nbsp;</td>
                <td width="20%"> 
                  <div align="center"> 
                	 <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/>
                	</div>
                   </td>
                <td width="20%"> 
                  <div align="center"> 
     				 <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/>
                  </div>
                </td>
                <td width="20%"> 
                  <div align="center"> 
     				 <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', true);"/>
                  </div>
                </td>
                <td width="20%">&nbsp;</td>
              </tr>
            </table>
		
			  
          </td>
        </tr>
        <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
		<tr> 
          <td>&nbsp;</td>
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
</html:html> 

<!-- #EndTemplate -->