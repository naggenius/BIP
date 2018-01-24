 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %><html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bFactureAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;

function MessageInitial()
{
   var Message = "";
   var Focus = "";
   if (Message != "") {
      alert(Message);
   }
  /* if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].CHAMP.focus();
   }*/
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Factures- 
            Gestion <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/client"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
   <tr><td colspan=3>&nbsp;</td></tr>
 <tr><td colspan=3>&nbsp;</td></tr>  
   <tr>
	<td class="lib">Filiale :</td>
	<td colspan=2>SGPM</td>
   </tr>
   
   <tr>
	<td class="lib"><b>Code société :</b></td>
	<td colspan=2><input type="text" size=4 maxlength=4 name="socfactT" class="input" value="3SIN" onChange="return VerifFormat(this.name);"></td>
   </tr>
   <tr>
	<td class="lib"><b>N° de facture :</b></td>
	<td colspan=2><input type="text" size=15 maxlength=15 name="numfact" class="input" value="F2300034" onChange="return VerifFormat(this.name);"></td>
   </tr>
   <tr>
	<td class="lib"><b>Type de facture :</b></td>
	<td><input type="radio" name="typfact" value="F" CHECKED>Facture</td>
	<td><input type="radio" name="typfact" value="A" >Avoir</td>
   </tr>
   <tr>
	<td class="lib"><b>Date de facture :</b></td>
	<td colspan=2><input type="text" size=10 maxlength=10 name="datfact" class="input" value="31/01/2003" onChange="return VerifFormat(this.name);"></td>
   </tr>
   <tr><td colspan=3>&nbsp;</td></tr>
   <tr><td colspan=3>&nbsp;</td></tr>
   <tr><td colspan=3>&nbsp;</td></tr>
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
