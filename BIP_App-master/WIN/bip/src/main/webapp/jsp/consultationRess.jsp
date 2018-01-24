<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="personneForm" scope="request" class="com.socgen.bip.form.PersonneForm" />
<html:html locale="true">
<!-- #EndEditable --> 
 
<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
  
<bip:VerifUser page="jsp/consultationRess.jsp"/>

<script language="JavaScript" src="../js/function.cjs"></script>

<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">

<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
    int nbligne = 0;
   
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{	


	var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
		
	if (Message != "") {
		alert(Message);
	}
	setFocusOnInput(document.getElementsByName('ident')[0]);	
}

/**
 * Sets the focus on an input element.
 */
function setFocusOnInput(elt) {
	elt.focus();
}



function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
	
	
	if(blnVerification){
		if (!VerifierNum(document.forms[0].ident,10,0)) {
			return false;
		} 
		if((document.forms[0].ident.value != "" && document.forms[0].debnom.value != "") 
	    	|| (document.forms[0].ident.value != "" && document.forms[0].nomcont.value != "")
	    	|| (document.forms[0].nomcont.value != "" && document.forms[0].debnom.value != "")
	    	|| (document.forms[0].ident.value == "" && document.forms[0].nomcont.value == "" && document.forms[0].debnom.value == "" && document.forms[0].matricule.value == "" && document.forms[0].igg.value == ""))
	    {
			
			alert("Vous devez saisir SOIT un identifiant, SOIT début de nom, SOIT un extrait de nom, SOIT un matricule, SOIT un IGG");
			document.forms[0].ident.value = "";
			document.forms[0].nomcont.value = "";
			document.forms[0].debnom.value = "";
			document.forms[0].ident.focus();
			
			return false;
		}
		return true;
	}
}

function clicMenu(num) { 

  // Booléen reconnaissant le navigateur (vu en partie 2)
  isIE = (document.all) 
  isNN6 = (!isIE) && (document.getElementById)

  // Compatibilité : l'objet menu est détecté selon le navigateur
  if (isIE) menu = document.all['description' + num];
  if (isNN6) menu = document.getElementById('description' + num);

  // On ouvre ou ferme
  if (menu.style.display == "none"){
    // Cas ou le tableau est caché
    menu.style.display = ""
  } else {
    // On le cache
    menu.style.display = "none"
   }
}
/** Pour vider deux champs  */
function viderChamps(elt) {
	
	if (elt.value != '') {
		if (elt.name == 'ident') {
			var debnom = document.getElementsByName('debnom')[0];
			var nomcont = document.getElementsByName('nomcont')[0];
			var matricule = document.getElementsByName('matricule')[0];
			var igg = document.getElementsByName('igg')[0];				
			debnom.value = '';
			nomcont.value = '';
			matricule.value = '';
			igg.value = '';
		}
		else if (elt.name == 'debnom') {
			var ident = document.getElementsByName('ident')[0];
			var nomcont = document.getElementsByName('nomcont')[0];
			var matricule = document.getElementsByName('matricule')[0];
			var igg = document.getElementsByName('igg')[0];
			ident.value = '';
			nomcont.value = '';
			matricule.value = '';
			igg.value = '';
		}
		else if (elt.name == 'nomcont') {
			var ident = document.getElementsByName('ident')[0];
			var debnom = document.getElementsByName('debnom')[0];
			var matricule = document.getElementsByName('matricule')[0];
			var igg = document.getElementsByName('igg')[0];		
			ident.value = '';
			debnom.value = '';
			matricule.value = '';
			igg.value = '';
		}	
		else if (elt.name == 'matricule') {
			var ident = document.getElementsByName('ident')[0];
			var debnom = document.getElementsByName('debnom')[0];
			var nomcont = document.getElementsByName('nomcont')[0];
			var igg = document.getElementsByName('igg')[0];		
			ident.value = '';
			debnom.value = '';
			nomcont.value = '';
			igg.value = '';
		}
		else if (elt.name == 'igg') {
			var ident = document.getElementsByName('ident')[0];
			var debnom = document.getElementsByName('debnom')[0];
			var nomcont = document.getElementsByName('nomcont')[0];
			var matricule = document.getElementsByName('matricule')[0];		
			ident.value = '';
			debnom.value = '';
			nomcont.value = '';
			matricule.value = '';
		}
	}	
}

//Insertion du code permettant de verifier l'heure
function isNumeric(sText)
{
	var ValidChars = "0123456789";
	var IsNumber=true;
	var Char;
	
	for (i = 0; i < sText.length && IsNumber == true; i++)
	{
	Char = sText.charAt(i);
	if (ValidChars.indexOf(Char) == -1)
	{
	IsNumber = false;
	}
	}
	return IsNumber;
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
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr > 
		  <td> 
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->Consultation d'une ressource : sélection<!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  <div id="content">
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/consultRess" onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
		  	<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="page" value="modifier"/>
			<input type="hidden" name="index" value="modifier">					
			<!-- #EndEditable -->
            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
						
						<tr>
	                    	<td colspan=5 align="center">&nbsp;</td>
	                    </tr>
						<tr  align="left">
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td class="texteGras">Identifiant  :</td>
							<td><html:text styleClass="input" property="ident" size="10" onkeyUp="viderChamps(this)" onblur="viderChamps(this)"/></td>
							<td>&nbsp;</td>
							<td class="texteGras" >ou</td>
							<td class="texteGras">Début du nom  :</td>
							<td><html:text styleClass="input" property="debnom" size="20" onkeyUp="viderChamps(this)" onblur="viderChamps(this)"/></td>
						</tr> 
					    <tr  align="left">
					    	<td>&nbsp;</td>
					    	<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td class="texteGras" >ou</td>
							<td class="texteGras">Nom contient :</td>
							<td><html:text styleClass="input" property="nomcont" size="20" onkeyUp="viderChamps(this)" onblur="viderChamps(this)"/></td>
						</tr>
						<tr  align="left">
							<td class="texteGras">ou</td>
							<td>&nbsp;</td>
							<td class="texteGras">Matricule :</td>
							<td><html:text styleClass="input" property="matricule" size="7" maxlength="7" onkeyUp="viderChamps(this)" onblur="viderChamps(this)"/></td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr align="left">
							<td class="texteGras">ou</td>
							<td>&nbsp;</td>
							<td class="texteGras">IGG :</td>
							<td><html:text styleClass="input" property="igg" size="10" maxlength="10" onkeyUp="viderChamps(this)" onblur="viderChamps(this)"/></td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td class="texte" colspan=3>Saisir UN des critères ci-dessus</td>
							<td>&nbsp;</td>
						</tr>
					</table>
					<table>
					<!-- #EndEditable -->
			   		</table>
					</div>
                  </td>
                </tr>
				<tr> 
          		  <td>&nbsp;  
          		  </td>
        		</tr>
                <tr> 
	                <td> 
	                <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<tr>
					<td>	
	                  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'modifier', this.form.mode.value,true);"/> 
	                </td>
	                <td>&nbsp;&nbsp;  
          		  	</td>
	                <td>
	                  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler',this.form.mode.value, false);"/> 
	                </td>
	                </tr>
	                </table>
	                </div>
	                </td>
                </tr>
            
            </table>
			  <!-- #BeginEditable "fin_form" -->
			  </html:form>
			  <!-- #EndEditable -->
          </div>
		  </td>
        </tr>
		
        <tr> 
          <td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          </td>
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
</html:html>
<% 
Integer id_webo_page = new Integer("1003"); 
com.socgen.bip.commun.form.AutomateForm formWebo = personneForm ;
%>
<%@ include file="/incWebo.jsp" %>
<!-- #EndTemplate -->