<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="personneForm" scope="request" class="com.socgen.bip.form.PersonneForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Recherche identifiant d'une ressource</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/consultationRess.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("selectress",personneForm.getHParams()); 
	pageContext.setAttribute("choix1", list1);  
	
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   if(blnVerification){
	   	var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
	   	if(Message != "") {
	      	alert(Message);}
	    if(document.forms[0].ident.selectedIndex==-1){
		 	document.forms[0].ident.selectedIndex=0;}
	}else{
		document.forms[0].ident.selectedIndex=-1;
	}
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value =action;
 
}

function ValiderEcran(form)
{
   var index = form.ident.selectedIndex;

   if (blnVerification) {
	if (index==-1) {
	   alert("Choisissez une ressource");
	   return false;
	}
   }
   
   return true;
}
</script>


<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td>            
			<div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
	</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td height="20" class="TitrePage"><div id="titre" >Recherche identifiant d'une ressource</div></td></tr>
</table>

<html:form action="/consultRess"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
<html:hidden property="action"/>
<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="debnom" /> 
<html:hidden property="nomcont" />
<html:hidden property="matricule" />
<html:hidden property="igg" />
<html:hidden property="count"/>				 
			<div id="content">
			<table cellspacing="2" cellpadding="2" class="tableBleu" border="0" width="65%" align="center">
				<tr><td >&nbsp;</td></tr>
				<tr align="center">
					<td class="texte"><b>
				    <span STYLE="position: relative; z-index: 1; right : 250px ">Code</span>
					<span STYLE="position: relative; z-index: 1; right : 230px">Nom</span>	
					<span STYLE="position: relative; z-index: 1; right : 50px">Prénom</span>
					<span STYLE="position: relative; z-index: 1; left : 10px">Matricule</span>
					<span STYLE="position: relative; z-index: 1; left : 40px">IGG</span>
					<span STYLE="position: relative; z-index: 1; left : 140px">Type</span>	
				    </b></td> 		
			    </tr>
				<tr align="center">
			       <td style="align:center; height:25px;">
			        	<html:select property="ident" styleClass="Multicol" size="15">
							<bip:options collection="choix1"/>
						</html:select>
			       </td>
			     </tr>
				 <tr><td >&nbsp;</td></tr>
				 <tr>
					<td>
						<table width="100%" border="0">
					
							<tr> 
							  <td width=10%>&nbsp;</td>
							  <td width="20%" align="center">  
							  <html:submit property="boutonModifier" value="Sélectionner" styleClass="input" onclick="Verifier(this.form, 'suite1', true);"/>
							  </td>
							  <td width="20%" align="center">  
							  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'retour', false);"/>
							  </td>
							  <td width=10%>&nbsp;</td>
							  
							</tr>
						</table>
					</td>
				 </tr>
				 <tr><td >&nbsp;</td></tr>
				</table>
			</div>
</html:form>
 
<table>      
	<tr><td><div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div></td></tr>
</table>
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
</body>
</html:html>
<!-- #EndTemplate -->
