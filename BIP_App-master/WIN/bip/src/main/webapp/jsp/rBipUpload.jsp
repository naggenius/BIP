 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,
java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.*"   
errorPage="../jsp/erreur.jsp"  %>

<html:html locale="true"> 

<jsp:useBean id="rBipUploadForm" scope="request" class="com.socgen.bip.form.RBipUploadForm" />

<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Upload Files</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/rBipRemontee.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>

<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">

<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sEtatRemontee = com.socgen.bip.commun.bd.ParametreBD.getValeur("ETAT_REMONTEE");
	
	
		
	
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var boutonCtrlSlmt = document.forms[0].boutonControler;
   boutonCtrlSlmt.style.visibility='hidden';
   
   var Message="<bean:write filter="false"  name="rBipUploadForm"  property="msgErreur" />";
   var Focus = "";
   if (Message != "") {
      alert(Message);
   }
}

function ValiderEcran(form)
{
   if (form.fichier.value == "")
   {
   alert("Vous devez sélectionner un fichier");
   	return false;
   }
   return true;
}

function verifier(form,action)
{
	form.action.value=action;
}

function verifierFichier()
{
	var nomFichier = document.forms[0].fichier.value;
	var boutonCtrlSlmt = document.forms[0].boutonControler;
	
	if(endsWith(nomFichier, "bips")==true || endsWith(nomFichier, "BIPS")==true)
		{
		boutonCtrlSlmt.style.visibility='visible';
		}
	else
		{
		boutonCtrlSlmt.style.visibility='hidden';
		}
	
	if(endsWith(nomFichier, "zip")==true || endsWith(nomFichier, "ZIP")==true)
		{
		boutonCtrlSlmt.style.visibility='visible';
		}
	
}


function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}

function isZipContainBips()
{
		var fichier;

		fichier= document.forms[0].fichier;
		
		if (!TraitementAjax('isZipContainBips','&fichier_path=' + fichier.value, 'fichier')) {
			return false;
		}
		return true;
	}

	function TraitementAjax(pMethode, pParams, pFocus) {


		ajaxCallRemotePage('/rBipUpload.do?action=' + pMethode + pParams);
		var boutonCtrlSlmt = document.forms[0].boutonControler;

		if (document.getElementById("ajaxResponse").innerHTML != '') {

			boutonCtrlSlmt.style.visibility='visible';
			return false;
		}
		boutonCtrlSlmt.style.visibility='hidden';
		return true;
	}

</script>
<!-- #EndEditable --> 
</head>


<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div style="display:none;" id="ajaxResponse"></div>
<table align="center">
	<tr>
	<% if ( "ACTIVE".equals(sEtatRemontee) )
	{ %>
		<html:form action="/rBipUpload" enctype="multipart/form-data" method="post" onsubmit="return ValiderEcran(this);">
		<html:hidden property="action" />
		
<html:hidden property="arborescence" value="<%= arborescence %>"/>		
		<td width="350">
			<html:file onchange="verifierFichier();" property="fichier" accept="bip,zip,bips" size="47"/>			
		</td>
		
		<td>
			<html:submit property="boutonControler" value="Contrôler seulement" styleClass="input" onclick="verifier(this.form,'controler');"/>
		</td>
		
		<td>
			<html:submit property="boutonValider" value="Envoyer au Serveur" styleClass="input" onclick="verifier(this.form,'creer');"/>
		</td>
		</html:form>
	<% }
	else
	{ %>
		<td>
			<b> La remontée Bip est actuellement bloquée </b> Consultez les brèves sur la page d'accueil
		</td>
	<%
	} %>
	</tr>
</table>
</body>
<script language="JavaScript">
</script>


</html:html>
