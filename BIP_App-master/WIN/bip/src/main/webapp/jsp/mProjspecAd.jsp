<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="projspecForm" scope="request" class="com.socgen.bip.form.ProjspecForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/projspec.do"/> 
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
  
  var Message="<bean:write filter="false"  name="projspecForm"  property="msgErreur" />";
   var Focus = "<bean:write name="projspecForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
		if (document.forms[0].libpspe)
	   		document.forms[0].libpspe.focus();
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
    if ((form.action.value!="valider")&&(form.action.value!="annuler"))
  		form.action.value ="valider";
	
	if ((form.codpspe)&&(!ChampObligatoire(form.codpspe, "l'identifiant projet spécial"))) return false;
	if ((form.libpspe)&&(!ChampObligatoire(form.libpspe, "le libellé projet spécial"))) return false;
	if (form.mode.value == 'update') {
     	if (!confirm("Voulez-vous modifier ce projet spécial?")) return false;
     }
     if (form.mode.value == 'delete') {
     	if (!confirm("Voulez-vous supprimer ce projet spécial ?")) return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
          <bean:write name="projspecForm" property="titrePage"/> 
          un projet sp&eacute;cial<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/projspec"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
  				<html:hidden property="titrePage"/>
            	<html:hidden property="action"/>
              	<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              	<html:hidden property="flaglock"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu"  >
                <tr> 
                  <td colspan=2 >&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Identifiant :</b></td>
                  <td>
                   <logic:equal parameter="mode" value="insert">
                    	<html:text property="codpspe" styleClass="input" size="2" maxlength="1" onchange="return VerifierAlphaMax(this);"/> 
                    </logic:equal>
                     <logic:notEqual parameter="mode" value="insert"> 
                   		<bean:write name="projspecForm"  property="codpspe" />
                   		<html:hidden property="codpspe"/>
                    </logic:notEqual> 

                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Libellé :</b></td>
                  <td> 
                      <logic:notEqual parameter="action" value="supprimer">
                    	<html:text property="libpspe" styleClass="input" size="12" maxlength="10" onchange="return VerifierAlphanum(this);"/>  
 					</logic:notEqual>
 					 <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="projspecForm"  property="libpspe" />
                    </logic:equal>
                    
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
			  <!-- #EndEditable --></div>
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
Integer id_webo_page = new Integer("1012"); 
com.socgen.bip.commun.form.AutomateForm formWebo = projspecForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
