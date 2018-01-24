<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.user.UserBip"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="msgForumForm" scope="request" class="com.socgen.bip.form.MessageForumForm" />
<html:html locale="true">
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/forumListe.do"/>
<%
	java.util.ArrayList listeType = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("typeMsgForum"); 
	pageContext.setAttribute("listeType", listeType);

	UserBip userBip =  (UserBip) session.getAttribute("UserBip");
%>
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
   var Message="<bean:write filter="false"  name="msgForumForm"  property="msgErreur" />";
   var Focus = "<bean:write name="msgForumForm"  property="focus" />"
   if (Message != "") {
      alert(Message);
   }
}

function Verifier(form, action, mode, flag) {
    blnVerification = flag;
    form.action.value = action;
}

function ValiderEcran(form) {

   	if (blnVerification) {
		if (!ChampObligatoire(form.titre, 'le titre') ) return false;
		if (!ChampObligatoire(form.texte, 'le texte') ) return false;
		if (form.texte.value.length>2000) {
			alert('Le texte est trop long ('+form.texte.value.length+' caractères maxi. 2000).');
			return false;
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
          <td height="20" class="TitrePage">Forum : nouveau sujet</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->

		  <html:form action="/forumNvSujet"  onsubmit="return ValiderEcran(this);">

		  <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
		    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="mode" value="insert"/>
		    <html:hidden property="menu"/>
		    <html:hidden property="listeMenu"/>
		    
              <table cellspacing="2" cellpadding="2" class="tableBleu" >
              <tr> 
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->

            		<table cellspacing="0" border="0" width="680" >
            			<tr>
            				<td colspan="3">&nbsp;</td>
            			</tr>
            			<tr>
            			    <td width="20" >&nbsp;</td>
            			    <td class="lib" ><b>&nbsp;Titre : </b></td>
            			    <td class="contenuisac" ><html:text property="titre" styleClass="input" size="80" maxlength="200" /></td>
            			</tr>
            			<tr>
            				<td colspan="3">&nbsp;</td>
            			</tr>
            			<tr valign="top">
            			    <td width="20" >&nbsp;</td>
            			    <td class="lib"><b>&nbsp;Message :&nbsp;</b></td>
            			    <td class="contenuisac" ><html:textarea property="texte" cols="78" rows="10" styleClass="input" /></td>
            			</tr>
            			<tr>
            				<td colspan="3">&nbsp;</td>
            			</tr>
            			<tr>
            			    <td width="20" >&nbsp;</td>
            			    <td class="lib" ><b>&nbsp;Type : </b></td>
            			    <td >
		                   		<html:select property="type_msg" styleClass="input"> 
		   							<html:options collection="listeType" property="cle" labelProperty="libelle" />
								</html:select>
            			    </td>
            			</tr>
<% if (msgForumForm.getListeMenu().indexOf(";DIR;")>-1) { %>
            			<tr>
            				<td colspan="3">&nbsp;</td>
            			</tr>
            			<tr>
            			    <td width="20" >&nbsp;</td>
            			    <td class="lib" ><b>&nbsp;Message important : </b></td>
            			    <td >
		                   		<html:checkbox property="msg_important" styleClass="input" value="O" /> 
            			    </td>
            			</tr>
<% } else { %>
		    <html:hidden property="msg_important" value="N"/>
<% } %>
            			<tr>
            				<td colspan="3">&nbsp;</td>
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
				  	<div align="center">
                	 <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/>
                  	</div>
				  </td>
				  <td width="25%">  
				  	<div align="center"> 
                	 <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/>
                  		</div>
				  </td>
				  <td width="25%">&nbsp;</td>
				</tr>
         </table>
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
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
Integer id_webo_page = new Integer("1072"); 
com.socgen.bip.commun.form.AutomateForm formWebo = msgForumForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 

