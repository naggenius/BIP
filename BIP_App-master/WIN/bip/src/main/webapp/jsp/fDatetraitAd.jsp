 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="automateForm" scope="request" class="com.socgen.bip.commun.form.AutomateForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fDatetraitAd.jsp"/> 
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
   var Message="<bean:write filter="false"  name="automateForm"  property="msgErreur" />";
   var Focus = "<bean:write name="automateForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].contenu.focus();
   }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}
function ValiderEcran(form)
{
   if (blnVerification==true) {
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Exploitation<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/dateTrait"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
           

	<table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
	<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
	<html:hidden property="mode" value="update"/>
	<input type="hidden" name="idfic" value="calendrier">
	
	<tr>
	   <td>&nbsp;</td>
	 	 </tr>
	 <tr> 
       <td>&nbsp;</td>
	   	 </tr>            	 
 	 
	
	<tr><td align=center>


	<textarea name="contenu" rows=22 cols=56 class="textarea"><bip:value champ="contenu" table="fichier" clause1="idfic" clause2="calendrier" />
    </textarea>
	</td></tr>
		<tr>
	   <td>&nbsp;</td>
	   </tr>
	 <tr> 
       <td>&nbsp;</td>
	   
	 </tr>      
	 <tr>
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
                <td align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true);"/> 
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
