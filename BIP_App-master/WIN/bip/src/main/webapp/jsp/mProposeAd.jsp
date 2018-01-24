<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="proposeForm" scope="request" class="com.socgen.bip.form.ProposeForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fProposeAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="proposeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="proposeForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();

}

function Verifier(form, action, flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form) {
  if (blnVerification == true) {
     if (form.mode.value == 'update') {
        if (!confirm("Voulez-vous modifier cette proposition de budget ?")) return false;
     }
  }
   return true;
}
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Proposition 
            de budget<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/propose"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="action"/> 
            <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
			<html:hidden property="flaglock"/>
			<html:hidden property="perime"/>
			<html:hidden property="perimo"/>
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td height="20" align=center >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td colspan=2 class="texte">Ligne BIP : </td>
                  <td colspan=2 class="texte"> 
                    <bean:write name="proposeForm"  property="pid" />
                    	<html:hidden property="pid"/>
                     &nbsp;-&nbsp;
					<bean:write name="proposeForm"  property="pnom" />
                    	<html:hidden property="pnom"/>&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td colspan=2 class="texte">Ann&eacute;e :</td>
                  <td colspan=2 class="texte">
                    <bean:write name="proposeForm"  property="bpannee" />
                    	<html:hidden property="bpannee"/>
                    </td>
                </tr>
                <tr align="left"> 
                  <td colspan=2 class="lib" align=center>BUDGET</td>
                  <td class="lib" align=center>
				    Date dernière</br>
				    Mise à jour
				  </td>
				  <td class="lib" align=center>
				    Identifiant</br>
				    mise à jour
				  </td>
                </tr>
                <tr align="left"> 
                  <td class=texte>Budget propos&eacute; Client <a>*</a> :</td>
<!--                   <td align="right"> -->
                  	<% // N'ouvrir le champ Proposé client en màj QUE SI le DPG de la ligne fait partie du Perim_ME ET le code client principal de la ligne fait partie du Perim_MO %>
                  	<% if ( "O".equals(proposeForm.getPerimo()) && "O".equals(proposeForm.getPerime()) ){ %>
				     <td align="right">
				      <html:text styleClass="input" property="bpmontmo" size="13" maxlength="13" onchange="return VerifierNumNegatif(this,12,2);" onfocus="alert(this.class);" />
				    </td>
				    <% }
				    else { %>
<!-- 				    PPM 63250 -->
				    <td class="texte" align="center">
				      <bean:write name="proposeForm"  property="bpmontmo"/>
				      <html:hidden property="bpmontmo"/>
				      </td>
				    <%}%>
<!-- 				  </td> -->
				  <td align="right" class="texte">
				   	<bean:write name="proposeForm"  property="bpmedate" />
                    <html:hidden property="bpmedate"/>
				  </td>
                  <td align="right" class="texte">
                  	<bean:write name="proposeForm"  property="ubpmontmo" />
                    <html:hidden property="ubpmontmo"/>
				  </td>
                </tr>
                <tr align="left"> 
                  <td class=texte>Budget propos&eacute; Fournisseur <a >*</a> :</td>
                  <td class="texte" align="right">
                  	<% if ("O".equals(proposeForm.getPerime())){ %>
				      <html:text property="bpmontme" styleClass="input" size="13" maxlength="13" onchange="return VerifierNumNegatif(this,12,2);"/> 
				    <% }
				    else { %>
				      <bean:write name="proposeForm"  property="bpmontme"/>
				      <html:hidden property="bpmontme"/>
				    <%}%>
				  </td>
				  <td align="right" class="texte">
				   	<bean:write name="proposeForm"  property="bpdate" />
                    <html:hidden property="bpdate"/>
				  </td>
                  <td align="right" class="texte">
                  <bean:write name="proposeForm"  property="ubpmontme" />
                    <html:hidden property="ubpmontme"/>
				  </td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                
                 <tr><td height="10"></td></tr>
                 
                <tr align="left"> 
                  <td align=center colspan=2 class="texte">* NB : C'est le proposé client qui fait foi pour la notification</td>
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
	        <td height="20"></td>
	        </tr>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
<% 
Integer id_webo_page = new Integer("1054"); 
com.socgen.bip.commun.form.AutomateForm formWebo = proposeForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
