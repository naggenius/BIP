 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="stockFiForm" scope="request" class="com.socgen.bip.form.StockFiForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fStockfiAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">

<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
var blnVerification = true;
var blnVerifFormat  = true;
var tabVerif        = new Object();


function MessageInitial()
{

tabVerif["clicode"] = "VerifierAlphaMax(document.forms[0].clicode)";
tabVerif["cout12"] = "VerifierNum(document.forms[0].cout12,11,2)";
tabVerif["cout"] = "VerifierNum(document.forms[0].cout,11,2)";

   var Message="<bean:write filter="false"  name="stockFiForm"  property="msgErreur" />";
   var Focus = "<bean:write name="stockFiForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   
   
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
	   document.forms[0].clicode.focus();
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Facturation 
            interne <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/stockFi"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
				  <html:hidden property="action"/>
				  <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
				  			

  				 
                    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="lib">Code ligne BIP :</td>
                        <td><bean:write name="stockFiForm"  property="pid" />
                    	<html:hidden property="pid"/>
                          &nbsp;-&nbsp; 
                          <bean:write name="stockFiForm"  property="pnom" />
                    	<html:hidden property="pnom"/>
                          &nbsp; </td>
                      </tr>
                      <tr> 
                        <td colpsan=2>&nbsp;</td>
                      </tr>
                    </table>
                    <table border=0 cellspacing=2 cellspadding=2 class="TableBleu">
                      <tr> 
                        <td align=center class=lib><b>GESTION DES STOCKS</b></td>
					  </tr>
					  <tr>
                        <td align=center class=lib><b>FACTURATION INTERNE</b></td>
                      </tr>
                    </table>
                    <table border="1" cellspacing="2" cellpadging="2" Class="TableBleu">
                      <tr> 
                        <td> </td>
                        <td align=center class=lib>
						<bean:write name="stockFiForm"  property="anneeM4" />
                    	<html:hidden property="anneeM4"/>
                        </td>
                        <td align=center class=lib><bean:write name="stockFiForm"  property="anneeM3" />
                    	<html:hidden property="anneeM3"/>
                        </td>
                        <td align=center class=lib><bean:write name="stockFiForm"  property="anneeM2" />
                    	<html:hidden property="anneeM2"/>
                        </td>
                        <td align=center class=lib><bean:write name="stockFiForm"  property="anneeM1" />
                    	<html:hidden property="anneeM1"/>
                        </td>
                        <td align=center class=lib>
						<bean:write name="stockFiForm"  property="annee" />
                    	<html:hidden property="annee"/>
                        </td>
                      </tr>
                      <tr> 
                        <td align=center class=lib>CA payeur</td>
                        <td align=center >
						<bean:write name="stockFiForm"  property="clicodeM4" />
                    	<html:hidden property="clicodeM4"/>
                        </td>
                        <td align=center >
						<bean:write name="stockFiForm"  property="clicodeM3" />
                    	<html:hidden property="clicodeM3"/>
                        </td>
                        <td align=center >
						<bean:write name="stockFiForm"  property="clicodeM2" />
                    	<html:hidden property="clicodeM2"/>
                        </td>
                        <td align=center >
						<bean:write name="stockFiForm"  property="clicodeM1" />
                    	<html:hidden property="clicodeM1"/>
                        </td>
				<td align=center>
				<!--logic:notEqual parameter="test" value="oui"-->
				<!--bean:write name="stockFiForm"  property="clicode" /--><!--html:hidden property="clicode"/-->
				<!--/logic:notEqual-->
				<html:text property="clicode" styleClass="input" size="12" maxlength="5" onchange="return VerifFormat(this.name);"/> 
							
				</td>
						
                      <tr> 
                        <td align=center class=lib>Coût FI 12</td>
                        <td align=center>
						<bean:write name="stockFiForm"  property="cout12M4" />
                    	<html:hidden property="cout12M4"/>
                        </td>
                        <td align=center>
						<bean:write name="stockFiForm"  property="cout12M3" />
                    	<html:hidden property="cout12M3"/>
                        </td>
                        <td align=center>
						<bean:write name="stockFiForm"  property="cout12M2" />
                    	<html:hidden property="cout12M2"/>
                        </td>
                        <td align=center>
						<bean:write name="stockFiForm"  property="cout12M1" />
                    	<html:hidden property="cout12M1"/>
                        </td>
                        <td align=center>
						<html:text property="cout12" styleClass="input" size="12" maxlength="12" onchange="return VerifFormat(this.name);"/>  
                        </td>
                      </tr>
                      <tr> 
                        <td align=center class=lib>Coût FI</td>
                        <td align=center><bean:write name="stockFiForm"  property="coutM4" />
                    	<html:hidden property="coutM4"/>
                        </td>
                        <td align=center>
						<bean:write name="stockFiForm"  property="coutM3" />
                    	<html:hidden property="coutM3"/>
                        </td>
                        <td align=center>
						<bean:write name="stockFiForm"  property="coutM2" />
                    	<html:hidden property="coutM2"/>
                        </td>
                        <td align=center>
						<bean:write name="stockFiForm"  property="coutM1" />
                    	<html:hidden property="coutM1"/>
                        </td>
                        <td align=center>
						<html:text property="cout" styleClass="input" size="12" maxlength="12" onchange="return VerifFormat(this.name);"/>  
                        </td>
                      </tr>
                    </table>
                    <table border="0" cellspacing="2" cellpadging="2" Class="TableBleu">
                      <tr> 
                        <td colspan=6>&nbsp;</td>
                      <tr> 
                        <td colspan=6>&nbsp;</td>
                      <tr> 
                        <td colspan=6>&nbsp;</td>
                    </table>
					
        <table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%" > 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', 'update',true);"/> 
                  </div>
                </td>
                <td width="25%">  
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
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
