 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="personneForm" scope="request" class="com.socgen.bip.form.PersonneForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bPersonneAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	String Rtype = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rtype")));
	String sRtype="";
		
    if(Rtype.equals("A"))
		   sRtype = " un agent SG ";
    else if(Rtype.equals("P"))
		   sRtype = " une prestation "; 
	
%>
var pageAide = "<%= sPageAide %>";
var rtype= "<%= Rtype %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
   var Focus = "<bean:write name="personneForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();

}

function Verifier(form, action, mode,flag)
{
  blnVerification = flag;
  form.mode.value = mode;
  form.action.value = action;
  
  // Si ressource SSII : message precisant la possibilite de creer un doublon
  
  if (document.forms[0].matricule.value.charAt(0) == "X")
  {
        alert("S'il s'agit de la même prestation avec un double contrat sur la même période, remplacer la lettre X du matricule par Y.");
            
   }	 	
  
}

function ValiderEcran(form) {
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
          <td height="20" class="TitrePage"><logic:equal parameter="mode" value="insert"><bean:write name="personneForm"  property="action" /></logic:equal><logic:notEqual parameter="mode" value="insert">Modifier</logic:notEqual><%= sRtype %></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/personne"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="action"/> 
            <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
			<html:hidden property="flaglock"/>
            <html:hidden property="soccode"/> 
            <input type="hidden" name="rtype" value="<%= Rtype %>">
            
            <logic:notEqual parameter="mode" value="insert">
            <html:hidden property="matricule"/> 
            <html:hidden property="codsg"/>
            <html:hidden property="rtel"/>  
            <html:hidden property="ident"/>
            <html:hidden property="icodimm"/> 
			<html:hidden property="batiment"/> 
			<html:hidden property="etage"/> 
			<html:hidden property="bureau" /> 
            </logic:notEqual>
			<html:hidden property="homonyme" value="true"/>
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
                  <td class="lib">Nom : </td>
                  <td> 
                    <bean:write name="personneForm"  property="rnom" />
                    	<html:hidden property="rnom"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Pr&eacute;nom :</td>
                  <td>
                <bean:write name="personneForm"  property="rprenom" />
                    	<html:hidden property="rprenom"/>
                    </td>
                </tr>
                <tr> 
                  <td class="lib">Matricule : </td>
                  <td> 
                    <logic:equal parameter="mode" value="insert">
                    	<bean:write name="personneForm"  property="matricule" />
                    	<html:hidden property="matricule"/>
                  	</logic:equal>
                  	<logic:notEqual parameter="mode" value="insert">
                    	<bean:write name="personneForm"  property="newmatricule" />
                    	<html:hidden property="newmatricule"/>
                  	</logic:notEqual>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Identifiant : </td>
                  <logic:equal parameter="mode" value="insert"> <td> 
                    <bean:write name="personneForm"  property="ident" />
                    	<html:hidden property="ident"/>
                  </td></logic:equal>
                  <logic:notEqual parameter="mode" value="insert"> <td> 
                    <bean:write name="personneForm"  property="newident" />
                    	<html:hidden property="newident"/>
                  </td></logic:notEqual>
                </tr>
                <tr> 
                  <td class="lib">Pole : </td>
                  <logic:equal parameter="mode" value="insert"> <td> 
                    <bean:write name="personneForm"  property="codsg" />
                    	<html:hidden property="codsg"/>
                  </td></logic:equal>
                  <logic:notEqual parameter="mode" value="insert"> <td> 
                    <bean:write name="personneForm"  property="newcodsg" />
                    	<html:hidden property="newcodsg"/>
                  </td></logic:notEqual>
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
            <table width="100%" border="0" class="tableBleu">
              <tr>
            	<td colspan=4 align="center">Cette personne existe déjà.<br>
            	<logic:equal parameter="mode" value="insert"> 
            	Voulez vous créer un homonyme ?</logic:equal> 
            	
            	<logic:notEqual parameter="mode" value="insert"> Si la ressource est en double, contactez l’administrateur.<br>
            	</logic:notEqual> 
            	</td>
              </tr>
              <tr> 
                <td width="25%">&nbsp;</td>
              <logic:equal parameter="mode" value="insert">   <td width="25%"> 
                  <div align="center"> <html:submit property="boutonCreer" value="Valider" styleClass="input" onclick="Verifier(this.form, 'creer', 'insert', true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td></logic:equal> 
                <logic:notEqual parameter="mode" value="insert"> <td width="25%"> 
                  <div align="center"> 
                  <html:submit property="boutonModifier" value="Retour" styleClass="input" onclick="Verifier(this.form, 'modifier', 'update', true);"/> 
                   <!--<input type="submit" name="boutonModifier" value="Retour" onclick="history.goback();" class="input">-->
                  </div>
                </td></logic:notEqual> 
                
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
</body></html:html>
<!-- #EndTemplate -->
