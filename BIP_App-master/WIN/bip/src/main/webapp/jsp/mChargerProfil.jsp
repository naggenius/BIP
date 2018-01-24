<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="chargerProfilForm" scope="request" class="com.socgen.bip.form.ChargerProfilForm" />
<html:html locale="true">
<!-- #EndEditable --> 
 
<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
  
<bip:VerifUser page="jsp/mChargerProfil.jsp"/>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">

<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
   
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{	
	var Message="<bean:write filter="false"  name="chargerProfilForm"  property="msgErreur" />";
		
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
	    	|| (document.forms[0].ident.value == "" && document.forms[0].nomcont.value == "" && document.forms[0].debnom.value == ""))
	    {
			
			alert("Vous devez saisir SOIT un identifiant, SOIT début de nom, SOIT un extrait de nom");
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
			debnom.value = '';
			nomcont.value = '';
		}
		else if (elt.name == 'debnom') {
			var ident = document.getElementsByName('ident')[0];
			var nomcont = document.getElementsByName('nomcont')[0];
			ident.value = '';
			nomcont.value = '';
		}
		else if (elt.name == 'nomcont') {
			var ident = document.getElementsByName('ident')[0];
			var debnom = document.getElementsByName('debnom')[0];		
			ident.value = '';
			debnom.value = '';
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Chargement d'un profil RTFE : recherche<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/chargerProfil" onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
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
						<tr>
							<td class="lib">Identifiant  :</td>
							<td><html:text styleClass="input" property="ident" size="10" onkeyUp="viderChamps(this)" onblur="viderChamps(this)"/></td>
							<td>&nbsp;</td>
							<td>ou</td>
							<td>&nbsp;</td>
							<td class="lib">Début du nom  :</td>
							<td><html:text styleClass="input" property="debnom" size="20" onkeyUp="viderChamps(this)" onblur="viderChamps(this)"/></td>
						</tr> 
					    <tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>ou</td>
							<td>&nbsp;</td>
							<td class="lib">Nom contient :</td>
							<td><html:text styleClass="input" property="nomcont" size="20" onkeyUp="viderChamps(this)" onblur="viderChamps(this)"/></td>
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
	                  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'consulter', this.form.mode.value,true);"/> 
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
</body>
</html:html>
<% 
Integer id_webo_page = new Integer("1003"); 
com.socgen.bip.commun.form.AutomateForm formWebo = chargerProfilForm ;
%>
<%@ include file="/incWebo.jsp" %>
<!-- #EndTemplate -->