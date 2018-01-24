<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.user.UserBip"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="listeForumForm" scope="request" class="com.socgen.bip.form.ListeMsgForumForm" />
<html:html locale="true">
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/forumListe.do"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	UserBip userBip =  (UserBip) session.getAttribute("UserBip");
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="listeForumForm"  property="msgErreur" />";
   var Focus = "<bean:write name="listeForumForm"  property="focus" />"

   if (Message != "") {
      alert(Message);
   }
   
   document.forms[0].mot_cle.focus();
   
}

function Verifier(form, action) {
    form.action.value = action;
}

function ValiderEcran(form) {

	if (!VerifierDate2(document.forms[0].date_debut,'jjmmaaaa')) return false;
	if (!VerifierDate2(document.forms[0].date_fin,'jjmmaaaa')) return false;

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
          <td height="20" class="TitrePage">Forum : recherche avanc&eacute;e</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->

		  <html:form action="/forumRecherche"  onsubmit="return ValiderEcran(this);">

		  <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
		    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="menu"/>
		    <html:hidden property="listeMenu"/>
		    <html:hidden property="typeEcran" value="rechercheAvancee"/>
		    
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
            				<td width="200" class="lib">&nbsp;Recherche par mots-cl&eacute;s : </td>
            				<td width="480" ><html:text property="mot_cle" styleClass="input" size="80" /></td>
            			</tr>
            			<tr>
            			    <td colspan="2"></td>
            			</tr>
            			<tr>
            				<td width="200" class="lib">&nbsp;Dans le champ : </td>
            				<td width="480" class="contenuisac" >&nbsp;&nbsp;Titre <html:checkbox property="chercheTitre" styleClass="input" value="O" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Texte <html:checkbox property="chercheTexte" styleClass="input" value="O" /></td>
            			</tr>
            			<tr>
            			    <td colspan="2">&nbsp;</td>
            			</tr>
            			<tr>
            				<td width="200" class="lib">&nbsp;Auteur : </td>
            				<td width="480" ><html:text property="auteur_rech" styleClass="input" size="80" /></td>
            			</tr>
            			<tr>
            			    <td colspan="2">&nbsp;</td>
            			</tr>
            			<tr>
            				<td width="200" class="lib">&nbsp;Date du message : </td>
            				<td width="480" class="contenuisac">entre le <html:text property="date_debut" styleClass="input" size="10" maxlength="10" /> et le <html:text property="date_fin" styleClass="input" size="10" maxlength="10" /></td>
            			</tr>
            			<tr>
            				<td colspan="2">&nbsp;</td>
            			</tr>
            		</table>
					
				  </div>
                </td>
              </tr>
            

		<tr>
		<td align="center">
		<table width="100%" border="0">
                <tr>
                  <td width="100%">  
				  	<div align="center">
                	 <html:submit property="boutonRechercher" value="Rechercher" styleClass="input" onclick="Verifier(this.form, 'recherche');"/>
                  	</div>
				  </td>
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
Integer id_webo_page = new Integer("1075"); 
com.socgen.bip.commun.form.AutomateForm formWebo = listeForumForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 

