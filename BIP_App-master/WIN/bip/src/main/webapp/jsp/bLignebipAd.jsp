<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneBipForm" scope="request" class="com.socgen.bip.form.LigneBipForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bLignebipAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->

<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">

<script language="JavaScript">

<!-- ABN - HP PPM 60464--> 
document.onkeypress = VerifEntree;
function VerifEntree() {

	

	if (window.event.type == "keypress" & window.event.keyCode == 13) {
		
		if(document.forms[0].pnom.value != "") {
			(document.getElementsByName('boutonCreer')[0]).click();
			
		} else if(document.forms[0].pid1.value != "") {
			(document.getElementsByName('boutonDupliquer')[0]).click();
			
		} else if(document.forms[0].pid.value != "") {
			(document.getElementsByName('boutonModifier')[0]).click();
		}
		
		
		
	}
	
}


/** Un seul des 3 champs de saisie doit etre obligatoirement renseigne */
function viderChamps(elt) {
	
	if (elt.value != '') {
		if (elt.name == 'pnom') {
			var pid1 = document.getElementsByName('pid1')[0];
			var pid = document.getElementsByName('pid')[0];
			pid1.value = '';
			pid.value = '';
		}
		else if (elt.name == 'pid1') {
			var pnom = document.getElementsByName('pnom')[0];
			var pid = document.getElementsByName('pid')[0];
			pnom.value = '';
			pid.value = '';
		}
		else if (elt.name == 'pid') {
			var pid1 = document.getElementsByName('pid1')[0];
			var pnom = document.getElementsByName('pnom')[0];
			pid1.value = '';
			pnom.value = '';
		}
	}	
}

var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
<%
	// On récupère le menu courant
  	com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)
		session.getAttribute("UserBip");
	com.socgen.bip.menu.item.BipItemMenu menu = userbip.getCurrentMenu();
		String menuId = menu.getId();
%>
var menuCourant = "<%= menuId %>";

function MessageInitial()
{
    var Message="<bean:write filter="false"  name="ligneBipForm"  property="msgErreur" />";

   if (Message != "") {
      alert(Message);
   }

	document.forms[0].pnom.focus();
	document.forms[0].pnom.value="";

    if(document.forms[0].pid1.value!="") 
        document.forms[0].pid.value="";
    else    
       	document.forms[0].pid1.value="";
}


function ValiderEcran(form, action, mode,duplic,flag)
{  


// On vérifie qu'on va pas créer un grand T1 ou hors GT1
  if (action == 'creerGT1') {
	  form.arctype.value='T1';
	  form.typproj.value='1 ';
	  form.action.value = 'creer';
  } else {
	  form.arctype.value='';
	  form.typproj.value='';
	  form.action.value = action;
  }
  blnVerification = flag;
  form.mode.value = mode;
  form.duplic.value = duplic;
  
  if (blnVerification) {
    if(form.duplic.value=="NON"){
		if (form.mode.value=="insert") {
	 		form.pid.value = "";
	 		form.pid1.value = "";
			if (!ChampObligatoire(form.pnom, "le nom d'une ligne bip")) return false;
			if(!existParamApp()) return false;
		}else {
  	        form.pnom.value = "";
  	        form.pid1.value = "";
			if (!ChampObligatoire(form.pid, "le code d'une ligne bip")) return false;
			if(!existParamApp()) return false;
		}
		
	}	
	else{

	   if (!ChampObligatoire(form.pid1, "le code d'une ligne bip")) return false;
	   if(!existParamApp()) return false;
	   form.pid.value = form.pid1.value;
	
	}	
  }
  
	if (!VerifierAlphanum(form.pnom) || !VerifierAlphaMax(form.pid1) || !VerifierAlphaMax(form.pid)) {
		return false
	}
   document.forms[0].submit();
}


function recherchePID(champs){
	window.open("/recupPID.do?action=initialiser&nomChampDestinataire="+champs+"&windowTitle=Recherche Code Ligne BIP"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
} 

function TraitementAjax(pMethode, pParams) {
	
	// Appel ajax de la méthode pMethode de l'action lignebip.do
	ajaxCallRemotePage('/ligneBip.do?action=' + pMethode + pParams);
	// Si la réponse ajax est non vide :
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		// Affichage d'une popup avec le contenu de la réponse
		alert(document.getElementById("ajaxResponse").innerHTML);
		return false;
	}
	return true;
}

function existParamApp()
{
	var code_action='OBLIGATION-DBS';
	var code_version='DEFAUT';
	var num_ligne = '1';
	
	if(!TraitementAjax('recupParamApp', '&code_action=' + code_action+'&code_version=' + code_version+'&num_ligne='+num_ligne))
	{
	return false;
	}
	return true;
}
 
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<div style="display:none;" id="ajaxResponse"></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
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
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Lignes 
            BIP- Gestion<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20"> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/ligneBip"  onsubmit=""><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
				  <html:hidden property="action"/>
                  <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                  <html:hidden property="arctype"/>
				  <html:hidden property="typproj"/> 
				  <html:hidden property="duplic" value="NON"/>
				  
                    <table cellspacing="2" cellpadding="2" class="tableBleu">
                      <tr> 
                        <td colspan="2">&nbsp;</td>
                      </tr>
                      <!--tr> 
                        <td colspan="2">&nbsp;</td>
                      </tr-->
                      <tr align="left"> 
					   <td colspan="2" class="texte" align="center"><b>Cr&eacute;er</b></td>
 						</tr>
                      <tr align="left"> 
                        <td class="texte">Nom de la ligne BIP:</td>
                        <td> 
						<html:text property="pnom" styleClass="input" size="30" maxlength="30" onchange="return VerifierAlphanum(this);" onkeyUp="viderChamps(this)" onblur="viderChamps(this)" /> 
                        </td>
                      </tr> 
                      <tr align="left"> 
                        <td class="texte">Créer à partir de la ligne BIP :</td>
                        <td class="texte"> 
                        <input class="input" type="text" name="pid1" size="4" maxlength="4" onchange="return VerifierAlphaMax(this);" onkeyUp="viderChamps(this)" onblur="viderChamps(this)" /> 
                       &nbsp;<a href="javascript:recherchePID('pid1');"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" style="vertical-align : middle;"></a>
                       </td>
                      </tr> 
                      <tr>  
                                          	
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>                       
                      </tr>
                      <tr> 
                        <td colspan="2" align=center height="40"class="texte"><u>OU</u></td>
					  </tr>
                        <tr> 
                    <td colspan="2" class="texte" align="center"><b>Modifier</b></td>
					</tr>
                      <tr align="left"> 
                        <td class="texte">Code de la ligne BIP :</td>
                        <td class="texte"> 
						<html:text property="pid" styleClass="input" size="4" maxlength="4" onchange="return VerifierAlphaMax(this);" onkeyUp="viderChamps(this)" onblur="viderChamps(this)" /> 
						&nbsp;<a href="javascript:recherchePID('pid');"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" style="vertical-align : middle;"></a>
                       </td>
                       </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      <tr> 
                        <td>&nbsp;</td>
                        <td height="20">&nbsp;</td>
                    </table>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="10%">&nbsp;</td>
                        <td width="20%"> 
                          <div align="center"> <html:button property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="ValiderEcran(this.form, 'creer', 'insert','NON',true);"/> 
                          </div>
                        </td>
                        <td width="20%" align="center">  
                		<html:button property="boutonDupliquer" value="Créer à partir de" styleClass="input" onclick="ValiderEcran(this.form, 'modifier', 'insert', 'OUI',true);"/>
                	    </td> 
                        <td width="20%"> 
                          <div align="center"> <html:button property="boutonCreer" value="Cr&#233er Grand T1" styleClass="input" onclick="ValiderEcran(this.form, 'creerGT1', 'insert','NON',true);"/> 
                          </div>
                        </td>
                        <td width="20%"> 
                          <div align="center"> <html:button property="boutonModifier" value="Modifier" styleClass="input" onclick="ValiderEcran(this.form, 'modifier', 'update','NON', true);"/> 
                          </div>
                        </td>
                        <td width="20%">&nbsp;</td>
                      </tr>
                    </table>
                    <!-- #EndEditable --></div>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body></html:html>
<!-- #EndTemplate -->
