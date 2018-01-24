 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneFactureForm" scope="request" class="com.socgen.bip.form.LigneFactureForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> <bip:VerifUser page="jsp/bFactureOr.jsp"/>
<%
java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("identress",ligneFactureForm.getHParams()); 
  pageContext.setAttribute("choixIdentress", list1);
%>
 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var blnVerifFormat  = true;
var tabVerif        = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
tabVerif["ident"] = "VerifierNum(document.forms[0].ident,5,0)";
  var Message="<bean:write filter="false"  name="ligneFactureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ligneFactureForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
	   document.forms[0].ident.focus();
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
	if (!ChampObligatoire(form.ident, "l'identifiant de la ressource")) return false;
	if (form.action.value == 'annuler') {
	form.keyList0.value = form.soccont.value;
	//form.keyList1.value = form.numcont.value;
	form.keyList5.value = form.cav.value;
	return true;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Saisir 
            l'identifiant d'une ressource<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/ligneFacture"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
 
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="suite"/> 
 <html:hidden property="titrePage"/>
<html:hidden property="mode" value="insert"/>
<html:hidden property="keyList0"/> 
<html:hidden property="keyList1"/>
<html:hidden property="keyList2"/> 
<html:hidden property="keyList3"/>
<html:hidden property="keyList4"/> 
<html:hidden property="keyList5"/>
<html:hidden property="keyList6"/> 
<html:hidden property="fmontht"/>
<html:hidden property="ftva"/>
<html:hidden property="lnum"/>
<html:hidden property="keyList7"/>
<html:hidden property="flaglock"/>
<html:hidden property="choixfsc" value="N"/>
  
                    <table border=0 cellspacing=2 cellpadding=2 class="TableBLeu">
                      <tr> 
                        <td colspan=4>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="lib">Code société :</td>
                        <td > <bean:write name="ligneFactureForm"  property="socfact" /> 
                          <html:hidden property="socfact"/> </td>
                      <td>&nbsp;</td>
                        <td class="lib">Société :</td>
                        <td colspan=4><bean:write name="ligneFactureForm"  property="soclib" /> 
                          <html:hidden property="soclib"/> </td>
                      </tr>
                      <tr> 
                        <td class="lib">N° de contrat :</td>
                        <td><bean:write name="ligneFactureForm"  property="numcont" /> 
                          <html:hidden property="numcont"/> </td>
                        <td width=50>&nbsp;</td>
                        <td class="lib">N° d'avenant :</td>
                        <td><bean:write name="ligneFactureForm"  property="cav" /> 
                          <html:hidden property="cav"/> </td>
                      </tr>
                      <tr> 
                        <td class="lib">N° de facture :</td>
                        <td> <bean:write name="ligneFactureForm"  property="numfact" /> 
                          <html:hidden property="numfact"/> </td>
                        <td>&nbsp;</td>
                        <td class="lib">Type de facture :</td>
                        <td><bean:write name="ligneFactureForm"  property="typfact" /> 
                          <html:hidden property="typfact"/> </td>
                      </tr>
                      <tr> 
                        <td class="lib">Date de facture :</td>
                        <td colspan=4><bean:write name="ligneFactureForm"  property="datfact" /> 
                          <html:hidden property="datfact"/> </td>
                      </tr>
                    </table>
                    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr> 
                        <td colspan=2>Liste des ressources </td>
                      </tr>
                      <tr> 
                        <td colspan=2> 
                         <html:select property="listeress" styleClass="input" onclick="ident.value=listeress.value" > 
   						<html:options collection="choixIdentress" property="cle" labelProperty="libelle" />
						</html:select>
                      </td>
                      </tr>
                      <tr> 
                        <td class="lib"><b>Identifiant :</b></td>
                        <td> <html:text property="ident" styleClass="input" size="5" maxlength="5" onchange="return VerifFormat(this.name);"/> 
                        </td>
                      </tr>
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
           
                    </table>
					<table border=0 cellspacing=2 cellpadding=2 class="TableBleu" width="100%">
				<tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/> 
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
