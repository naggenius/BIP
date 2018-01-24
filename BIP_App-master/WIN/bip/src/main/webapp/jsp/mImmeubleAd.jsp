<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="immeubleForm" scope="request" class="com.socgen.bip.form.ImmeubleForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/immeuble.do"/>

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
    var Message="<bean:write filter="false"  name="immeubleForm"  property="msgErreur" />";
   var Focus = "<bean:write name="immeubleForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
     if (document.forms[0].icodimm &&document.forms[0].mode.value=="insert") {
     document.forms[0].icodimm.focus();
     }
     else if (document.forms[0].iadrabr) {
	 document.forms[0].iadrabr.focus();
	 }
   }
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value =mode;

}

function ValiderEcran(form)
{
  
  if (blnVerification == true) {
  
  	if ((form.action.value!="valider")&&(form.action.value!="annuler"))
  		form.action.value ="valider";
   
	if (form.mode.value=="update") {
		if (!confirm("Voulez-vous modifier cet immeuble ?")) return false;
	}
	if (form.mode.value=="delete") {
	
		if (!confirm("Voulez-vous supprimer cet immeuble ?")) return false;
	}
	if (form.icodimm) {
		if (!ChampObligatoire(form.icodimm,"le code de l'immeuble")) return false;
	}
	if (form.iadrabr) {
		if (!ChampObligatoire(form.iadrabr,"l'adresse abrégée de l'immeuble")) return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="immeubleForm" property="titrePage"/> 
          un code immeuble<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/immeuble"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
				<input type="hidden" name="pageAide" value="<%= sPageAide %>">
				<html:hidden property="titrePage"/>
            	<html:hidden property="action"/>
				<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
				<html:hidden property="flaglock"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu"  >
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp; </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code immeuble :</b></td>
                  <td>
                  <logic:equal parameter="mode" value="insert"> 
                  	<html:text property="icodimm" styleClass="input" size="6" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
                  </logic:equal>
  				  <logic:notEqual parameter="mode" value="insert">
  				  	<bean:write name="immeubleForm" property="icodimm"/>
  				  	<html:hidden property="icodimm"/>
  				  </logic:notEqual>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Adresse abrégée de l'immeuble :</b></td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                    	<html:text property="iadrabr" styleClass="input" size="12" maxlength="10" onchange="return VerifierAlphanum(this);"/>
           			</logic:notEqual>
           			<logic:equal parameter="action" value="supprimer">
           			   	<bean:write name="immeubleForm" property="iadrabr"/>
           			</logic:equal> 
                  </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
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
Integer id_webo_page = new Integer("1008"); 
com.socgen.bip.commun.form.AutomateForm formWebo = immeubleForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
