<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="activiteForm" scope="request" class="com.socgen.bip.form.ActiviteForm" />
<html:html locale="true"> 
 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 
<title>Outil de r&eacute;estim&eacute;</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/bActiviteRe.jsp"/>
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
   var Message="<bean:write filter="false"  name="activiteForm"  property="msgErreur" />";
   var Focus = "<bean:write name="activiteForm"  property="focus" />";
   if (Message != "") 
   {
      alert(Message);
   }
   if (Focus != "")
   {
   		(eval( "document.forms[0]."+Focus )).focus();
   }
   else if (document.forms[0].mode.value=="creer")
   {
	   document.forms[0].code_activite.focus(); 
   }   
   else if (document.forms[0].mode.value=="modifier")
   {
	   document.forms[0].lib_activite.focus(); 
   }  	
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
  if (blnVerification == true) {
     
     if (form.mode.value== 'delete') {
        if (!confirm("Voulez-vous supprimer cette activit� ?")) return false;
     }
     else
     {
	 	if (!ChampObligatoire(form.lib_activite, "le libell� de l'activit�")) return false;
	
        if (form.mode.value== 'update') {
     		if (!confirm("Voulez-vous modifier cette activit� ?")) return false;
     	}
     	else
     	{
     		if (!ChampObligatoire(form.code_activite, "le code activit�")) return false;
     	}
     }
     
  }
 
   return true;
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
          <td height="20" class="TitrePage">
           <bean:write name="activiteForm" property="titrePage"/> une activit&eacute;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
          	<html:form action="/activite"  onsubmit="return ValiderEcran(this);"> 
            <div align="center">
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<%
		    if(activiteForm.getCode_activite() != null)
		    {
		    %>
		    	<html:hidden property="code_activite"/>
		    <%
		    }
		    %>
		    <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Code D&eacute;partement/P&ocirc;le/Groupe : </b></td>
                  <td colspan="4">
                    <b><bean:write name="activiteForm" property="codsg"/></b> 
                    <html:hidden property="codsg"/>
                 
                  </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Code de l'activit&eacute; : </b></td>
                  <td colspan="4" >
                    <logic:notEqual parameter="action" value="creer">
                    	<b><bean:write name="activiteForm"  property="code_activite"/><b>
                   </logic:notEqual>
                  	<logic:equal parameter="action" value="creer">
                   		<html:text property="code_activite" styleClass="input" size="12" maxlength="12" onchange="return VerifierAlphanum(this);"/>
                    </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Libell&eacute; de l'activit&eacute; : <b></td>
                  <td colspan="4" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="lib_activite" styleClass="input" size="60" maxlength="60" onchange="return VerifierAlphanum(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="activiteForm"  property="lib_activite" />
                    </logic:equal> 
                
                  </td>
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
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'suite', null, false);"/> 
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
Integer id_webo_page = new Integer("4001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = activiteForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>