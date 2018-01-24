<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="projetForm" scope="request" class="com.socgen.bip.form.ProjetForm" />
<html:html locale="true"> 

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/dpDomBancaire.do"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	java.util.ArrayList dossierProjet = com.socgen.bip.commun.liste.ListeGlobale.getListeGlobale("dossier_projet");
	java.util.ArrayList domBancaire = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("domBancaire",projetForm.getHParams()); 
	
	pageContext.setAttribute("choixDossierProjet", dossierProjet);
    pageContext.setAttribute("choixDomBancaire", domBancaire);
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="projetForm"  property="msgErreur" />";
   var Focus = "<bean:write name="projetForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
}


function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}
function ValiderEcran(form)
{
  if (blnVerification == true) {
     if (!ChampObligatoire(form.cod_db, "le code ensemble applicatif")) return false;
  }
  if (confirm("Voulez-vous mettre à jour tous les projets du dossier projet sélectionné?")) return true;
  else return false;
}
</script>

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
          <td height="20" class="TitrePage">Lien Dossier Projet / Domaine Bancaire</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
          	<html:form action="/dpDomBancaire"  onsubmit="return ValiderEcran(this);">
            <div align="center">
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td  >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Dossier Projet :</b></td>
                  <td colspan="4">
                    <html:select property="icodproj" styleClass="input"> 
   						<html:options collection="choixDossierProjet" property="cle" labelProperty="libelle" />
					</html:select>
                 
                  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Ensemble applicatif - Domaine Bancaire :</b></td>
                  <td colspan="4" >
                  	<html:select property="cod_db" styleClass="input"> 
   						<html:options collection="choixDomBancaire" property="cle" labelProperty="libelle" />
					</html:select>
                  </td>
                </tr>
          		<tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
              </table>
              </div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
              </tr>
            </table>
            </html:form>
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
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
Integer id_webo_page = new Integer("1027"); 
com.socgen.bip.commun.form.AutomateForm formWebo = projetForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>