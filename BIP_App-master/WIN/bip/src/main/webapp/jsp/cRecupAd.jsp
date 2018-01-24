<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %><html:html locale="true">
 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" -->
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">



<!-- Fiche 385 : JAL 11/06/2008  Force lecture fichiers sans aller chercher dnas le cache de IE --> 

<meta http-equiv="cache-control"
content="no-cache">
<meta http-equiv="expires"
content="0">



<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="frameAccueil.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide"))); %>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message = "";
   var Focus = "";
   if (Message != "") {
      alert(Message);
   }
}

function setType(type)
{
	var msg;
	msg = '';
	
	if (type == 'reload')
	{
		document.forms[0].type.value = 'reload';
		return;
	}
	
	var bGotCheck = false;
   	for (i=0; document.getElementById("del"+type+"["+i+"]")!=null;i++) 
   		if (document.getElementById("del"+type+"["+i+"]").checked) bGotCheck = true;

	if (type == 'E') {
	   	if (bGotCheck==false) {
	   		alert('Vous devez sélectionner au moins une édition.');
	   	} else {
			msg = 'Etes vous sûr de vouloir purger les Editions sélectionnées ?'; 
		}
	} else if (type == 'X') {
	   	if (bGotCheck==false) {
	   		alert('Vous devez sélectionner au moins une extraction.');
	   	} else {
			msg = 'Etes vous sûr de vouloir purger les Extractions sélectionnées ?'; 
		}
	}
	
	document.forms[0].type.value = 'reload';

	if (msg!='') {
		if (confirm(msg)) 
			document.forms[0].type.value = type;
	}
}

function selectAll(type) {

   	for (i=0; document.getElementById("del"+type+"["+i+"]")!=null;i++) 
   		document.getElementById("del"+type+"["+i+"]").checked = document.getElementById("delAll"+type).checked;


	// Mise à jour de la bulle d'aide
    var objTooltip = document.getElementById("tooltipsAll");

	if (type=="E")
		sTxt = " de toutes les &eacute;ditions";
	else
		sTxt = " de toutes les extractions";

	if (document.getElementById("delAll"+type).checked)
		objTooltip.innerHTML = "Des&eacute;lection"+sTxt;
	else
		objTooltip.innerHTML = "S&eacute;lection"+sTxt;
			
}

function showTooltips(bShow, pType, e) {
    var objTooltip = document.getElementById("tooltipsAll");

	// on récupère la position de la souris
	x = (navigator.appName.substring(0,3) == "Net") ? e.clientX : event.x+document.body.scrollLeft;
	y = (navigator.appName.substring(0,3) == "Net") ? e.clientY : event.y+document.body.scrollTop;

	// on positionne la bulle d'aide
	objTooltip.style.left = x+15;
	objTooltip.style.top  = y+15;

	if (bShow) {
		if (pType=="E")
			sTxt = " de toutes les &eacute;ditions";
		else
			sTxt = " de toutes les extractions";

		// on met à jour le texte de la bulle d'aide
		if (document.getElementById("delAll"+pType).checked)
			objTooltip.innerHTML = "Des&eacute;lection"+sTxt;
		else
			objTooltip.innerHTML = "S&eacute;lection"+sTxt;
			
		// on affiche la bulle d'aide	
        objTooltip.style.visibility = "visible";
        	
    } else {
		// on cache la bulle d'aide
        objTooltip.style.visibility = "hidden";
    }
        
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
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->Traitements diff&eacute;r&eacute;s<!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
          <div id="content">
		  <!-- #BeginEditable "debut_form" --><html:form action="/recup"><!-- #EndEditable -->
            <table width="100%" border="0">
              
                
              <tr> 
                  
                <td> 
                    
                  <div align="center"><!-- #BeginEditable "contenu" -->
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					<input type="hidden" name="type">
					
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		<table cellspacing="0" border="0" width="485">
			<tr>
				<td class="texteGras">
					<div align="center"><b>Editions</b>  <html:submit value="Purger" styleClass="input" onclick="setType('E');"/></div>
				</td>
			</tr>
			<tr>				
				<td width="485" colspan=2> <bip:listeAsync type="E" tableauStyle="texteGras" labelStyle="texte" valeurStyle="texte" largeurs="260;80;120;25"/></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr> 
				<td class="texteGras">
					<div align="center"><b>Extractions</b>  <html:submit value="Purger" styleClass="input" onclick="setType('X');"/></div>
				</td>
			</tr>
			<tr>
				<td width="485" colspan=2> <bip:listeAsync type="X" tableauStyle="texteGras" labelStyle="texte" valeurStyle="texte" largeurs="260;80;120;25"/></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp; </td>
			</tr>
			<tr>
				<td colspan=2>
				<div align="center"><html:submit value="Rafraîchir" styleClass="input" onclick="setType('reload');"/></div>
				</td>
			</tr>
		</table>
					<!-- #EndEditable --></div>
                </td>
              </tr>
            
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
            <div id="tooltipsAll" class="tooltip">
			S&eacute;lection/Des&eacute;lection de tous les traitements
			</div>
            </div>
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
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

</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body></html:html>

<!-- #EndTemplate -->
