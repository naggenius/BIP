<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="factValideeForm" scope="request" class="com.socgen.bip.form.FactValideeForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> <bip:VerifUser page="jsp/fFactValideeOr.jsp"/> 

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

var blnVerifFormat  = true;
var blnVerifFormat  = true;
var tabVerif        = new Object();
function MessageInitial()
{
   var Message="<bean:write filter="false"  name="factValideeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="factValideeForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  
   }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
  
}

function ValiderEcran(form)
{
   if (blnVerification) {
	if ( !VerifFormat(null) ) return false;
	form.keyList0.value = form.socfact.value;
form.keyList1.value = form.typfact.value;
	form.keyList2.value = form.datfact.value;
	form.keyList3.value = form.numfact.value;
	form.keyList4.value = form.socfact.value;		// SOCCONT
	form.keyList5.value = "";		// CAV
	form.keyList6.value = "";		// NUMCONT
	form.keyList7.value = "";		//RNOM

	

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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Factures- Correction 
            d'une facture valid&eacute;e <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/factValidee"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
                    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <html:hidden property="action"/>
					 <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
                    <html:hidden property="keyList0"/>
					 <html:hidden property="keyList1"/> 
                    <html:hidden property="keyList2"/>
					 <html:hidden property="keyList3"/> 
                    <html:hidden property="keyList4"/>
					 <html:hidden property="keyList5"/> 
                    <html:hidden property="keyList6"/>
					 <html:hidden property="keyList7"/> 
					<html:hidden property="test" value="lignes"/>
					<html:hidden property="msg_info"/>
					<html:hidden property="flaglock"/> 
                    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu" >
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                     
                      <tr> 
                        <td class="lib">Société :</td>
                        <td colspan=5>
                          <html:hidden property="socfact"/>
                          <bean:write name="factValideeForm"  property="soclib" /> <html:hidden property="soclib"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">N° de facture :</td>
                        <td ><bean:write name="factValideeForm"  property="numfact" /> <html:hidden property="numfact"/>
						</td>
                        <td class="lib">Type de facture :</td>
                        <td><bean:write name="factValideeForm"  property="typfact" /> <html:hidden property="typfact"/>
                        </td>
                        <td class="lib">Date de facture :</td>
                        <td ><bean:write name="factValideeForm"  property="datfact" /> <html:hidden property="datfact"/>
                        </td>
                      </tr>
                      <tr>
                      <td class="lib">Accord du pôle :</td>
                        <td><bean:write name="factValideeForm"  property="faccsec" /> <html:hidden property="faccsec"/>
                        </td> 
                        <td class="lib">N° poste SDFF :</td>
                        <td>1<!--Donnée Export SMS supprimée, chiffre '1' laissé pour ne pas changer l'écran...-->
                        </td>
                        
                     
                        <td class="lib">N° dossier SDFF :</td>
                        <td><bean:write name="factValideeForm"  property="fnumasn" /> <html:hidden property="fnumasn"/>
                        </td>
                         </tr>
                      <tr> 
                        <td class="lib">Envoi règlem. compta :</td>
                        <td><bean:write name="factValideeForm"  property="fregcompta" /> <html:hidden property="fregcompta"/>
                        </td>
                        <td class="lib">Règlem. demandé :</td>
                        <td>
                          <bean:write name="factValideeForm"  property="fenvsec" /> <html:hidden property="fenvsec"/>
                        </td>
                        <td class="lib">Mode règlement :</td>
                        <td><bean:write name="factValideeForm"  property="fmodreglt" /> <html:hidden property="fmodreglt"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Code fournisseur :</td>
                        <td > 
                         <bean:write name="factValideeForm"  property="fsocfour" /> <html:hidden property="fsocfour"/>
				</td>
				<td colspan="2">
                         <bean:write name="factValideeForm"  property="socflib" /> <html:hidden property="socflib"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Montant HT :</td>
                        <td><bean:write name="factValideeForm"  property="fmontht" /> <html:hidden property="fmontht"/>
                          
                        </td>
                        <td class="lib">Montant TTC :</td>
                        <td><bean:write name="factValideeForm"  property="fmontttc" /> <html:hidden property="fmontttc"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Libellé analytique</td>
                        <td colspan=4><bean:write name="factValideeForm"  property="llibanalyt" /> <html:hidden property="llibanalyt"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Mois à comptabiliser :</td>
                        <td ><bean:write name="factValideeForm"  property="fmoiacompta" /> <html:hidden property="fmoiacompta"/>
                        </td>
                      
                        <td class="lib">Statut CS1 :</td>
                        <td><bean:write name="factValideeForm"  property="fstatut1" /> <html:hidden property="fstatut1"/>
                        </td>
                        <td class="lib">Statut CS2 :</td>
                        <td><bean:write name="factValideeForm"  property="fstatut2" /> <html:hidden property="fstatut2"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Provenance SDFF1 :</td>
                        <td>
						<bean:write name="factValideeForm"  property="fprovsdff1" /> <html:hidden property="fprovsdff1"/>
                          
                        </td>
                        <td  class="lib">Provenance SDFF2 :</td>
                        <td>
                          <bean:write name="factValideeForm"  property="fprovsdff2" /> <html:hidden property="fprovsdff2"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Provenance SEGL1 :</td>
                        <td>
                          <bean:write name="factValideeForm"  property="fprovsegl1" /> <html:hidden property="fprovsegl1"/>
                        </td>
                        <td class="lib">Provenance SEGL2 :</td>
                        <td>
                          <bean:write name="factValideeForm"  property="fprovsegl2" /> <html:hidden property="fprovsegl2"/>
                        </td>
                      </tr>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                    </table>
                    <table width="100%" border="0">
                      <tr> 
                        <td align="center"> <html:submit property="boutonLignes" value="Lignes" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
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
</body>
<% 
Integer id_webo_page = new Integer("3006"); 
com.socgen.bip.commun.form.AutomateForm formWebo = factValideeForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
