<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<jsp:useBean id="UserBip" scope="session" class="com.socgen.bip.user.UserBip" />
<html:html locale="true">
<!-- #EndEditable --> 

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
<!-- Le nom de la page à utiliser dans bip:VerifUser ne doit pas être jsp/xLigneAd.jsp . Il doit rester jsp/xRedirectLigne.jsp -->
<bip:VerifUser page="jsp/xRedirectLigne.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var tabVerif = new Object();
var retourAjax = "";

//Réversibilité BIP : Problème lancement extraction même si format DPG erroné
var verifDPG = true;
//Réversibilité BIP : Fin
<%
	String arborescence = request.getParameter("arborescence");
	String sPageAide = request.getParameter("pageAide");
	/*String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));*/
	
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	
	String menuId = menu.getId();
	String userbip = user.getIdUser();
%>
var pageAide = "<%= sPageAide %>";
var userbip = "<%= userbip %>";
<%
	String sTitre;
	String sInitial;
	String sJobId;
%>
// Réversibilité BIP : Problème lancement extraction même si format DPG erroné
function verif_DPG(nom)
{
	verifDPG = VerifFormat(nom);
	DPG_Change();
}
//Réversibilité BIP : Fin

function DPG_Change()
{
	if(document.forms[0].p_param6.value != "") {
		document.extractionForm.p_param7.checked = false;
	}
}

function PERIMETRE_Change()
{
	if(document.extractionForm.p_param7.checked == true) {
		document.forms[0].p_param6.value = "";
	}
}



function TraitementAjax(pMethode, pParam) {
	// Appel ajax de la méthode pMethode de l'action extract.do
	ajaxCallRemotePage('/ligneBip.do?action=' + pMethode + pParam);
	// Si la réponse ajax est non vide :	
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		// Affectation de la valeur retourné pour traitement
		retourAjax = document.getElementById("ajaxResponse").innerHTML;
	}
	return true;
}

function MessageInitial()
{
	TraitementAjax('recupHabilitationSuivbase', '&p_global=' + userbip);

	// Récupération du message d'erreur et du paramètre d'habilitation
	var erreur = retourAjax.substring(0,retourAjax.indexOf(";"));
	if (erreur != "")
		erreur = erreur + "\nVeuillez prévenir l'équipe MO BIP par mail, en joignant une copie de cette fenêtre";

	var habilitation = retourAjax.substring(retourAjax.indexOf(";") + 1);
	if (habilitation != "")
		document.forms[0].p_param16.value = habilitation;

	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";

	if (Message != "") {
		alert(Message);
	}
	else
	{
		if (erreur != "")
		{
			// Affichage du message d'erreur et redirection vers la page des favoris
			alert(erreur);
			document.forms[0].action.value = "annuler";
			document.forms[0].submit();
			return true;
		}
		document.forms[0].p_param6.focus();
		document.extractionForm.p_param7.checked = true;
	}

	<%
	sJobId = "xLigneAdSuivbase";
	sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
	if (sTitre == null)
	{
		//redirect sur la page d'erreur
		sTitre = "Pas de titre";
	}
	//sInitial = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
	sInitial = request.getParameter("initial");
	if (sInitial == null)
		sInitial = request.getRequestURI();
	else
		sInitial = request.getRequestURI() + "?" + sInitial;
	sInitial = sInitial.substring(request.getContextPath().length());
	%>

	if (document.getElementsByName("p_param6")[0] !== undefined) {
		tabVerif["p_param6"] = "Ctrl_dpg_generique(document.extractionForm.p_param6)";
	}
}

function Verifier(form, flag)
{
	blnVerification = flag;
}

function ValiderEcran(form) {
	// Réversibilité BIP : Problème lancement extraction même si format DPG erroné
	if  (verifDPG == false){
		verifDPG = true;
		return false;
	}
	// Réversibilité BIP : Fin
	else
	{
		if (document.forms[0].p_param6.value == "" && document.forms[0].p_param8.value == "" &&
			document.forms[0].p_param9.value == "" && document.forms[0].p_param10.value == "" &&
			document.forms[0].p_param11.value == "" && document.forms[0].p_param12.value == "" &&
			document.forms[0].p_param7.checked == false)
		{
			alert("Vous n'avez pas effectué le minimum de saisie ou de choix d'option : veuillez corriger");
			return false;
		}
	}

	return true;
}

</script>

<!-- #EndEditable --> 


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div style="display:none;" id="ajaxResponse"></div>
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr > 
		  <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
				<%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%>              
				<!-- <ul id="tabs"><li class="homeLink"><a href="../chgmenu.do?action=creer"><img src="../images/home.gif" width="31" height="30" border="0" /></a></li>
				<li><a href="javascript:ouvrirAide();" onmouseover="window.status='';return true"  >Aide</a></li>
				<li><a href="javascript:window.print();" onmouseover="window.status='';return true"  >Imprimer</a></li>
				<li><a href="javascript:ajouterFavoris('Lignes BIP','/jsp/xRedirectLigne.jsp&param0=pageAide&value0=/jsp/aide/Guide_Resp_etudes.doc&param1=typFav&value1=X&param2=addFav&value2=yes&param3=jobId&value3=&param4=titlePage&value4=&param5=lienFav&value5=%2Fjsp%2FxRedirectLigne.jsp&param6=sousMenu&value6=&param7=indexMenu&value7=71&param8=arborescence&value8=Responsable%20d études/Exports%20sur%20PC/Lignes%20BIP','X');" onmouseover="window.status='';return true"  >Ajouter aux favoris</a></li></ul> -->
				
				<!-- #EndEditable -->

		</div>&nbsp;</td>
        </tr>
        <tr> 
<!--           <td background="../images/ligne.gif"></td> -->
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
        <tr> 
<!--           <td background="../images/ligne.gif"></td> -->
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  <html:form action="/extract"  onsubmit="return ValiderEcran(this);">
			<!-- #BeginEditable "debut_hidden" -->	
            
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="action"/>
			<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <input type="hidden" name="p_param14" value="<%= menuId %>">
            <input type="hidden" name="p_param16" >
            <input type="hidden" name="listeReports" value="1">
			<!-- #EndEditable -->

            <table width="100%" border="0">
            	<tr><td height="20"></td></tr>
                <tr> 
                  <td> 
                    <div align="center">
                      <!-- #BeginEditable "contenu" -->
					<table border=0 cellspacing=5 cellpadding=0 class="tableBleu">	
						<tr><td colspan=5 align="center">&nbsp;</td></tr>
						<tr align="left">
								<td colspan=1 class="texte" align=left>Code DPG :</td>
								<!-- Réversibilité BIP : Problème lancement extraction même si format DPG erroné -->
								<td class="texte" colspan=1 align=left><html:text property="p_param6" styleClass="input"  size="12" maxlength="7" onchange="verif_DPG(this.name);"></html:text>
								<!-- Réversibilité BIP : Fin -->
								&nbsp;OU&nbsp;&nbsp;</td>
						        <td class="texte" colspan=1 align=left><html:checkbox name="extractionForm" property="p_param7" value="1" onclick="return PERIMETRE_Change();" />&nbsp;Périmètre complet</td>
						</tr>
						<tr align="left">
								<td colspan=1 class="texte" align=left>Dossier projet :</td>
								<td class="texte" colspan=1 align=left><html:text property="p_param8" styleClass="input"  size="12" maxlength="5"/>&nbsp;</td>					        
						</tr>
						<tr align="left">
								<td colspan=1 class="texte" align=left>Lot DPCOPI :</td>
								<td class="texte" colspan=1 align=left><html:text property="p_param9" styleClass="input"  size="12" maxlength="6"/>&nbsp;</td>					        
						</tr>
						<tr align="left">
								<td colspan=1 class="texte" align=left>Projet :</td>
								<td class="texte" colspan=1 align=left><html:text property="p_param10" styleClass="input"  size="12" maxlength="5"/>&nbsp;</td>					        
						</tr>
						<tr align="left">
								<td colspan=1 class="texte" align=left>Application :</td>
								<td class="texte" colspan=1 align=left><html:text property="p_param11" styleClass="input"  size="12" maxlength="5"/>&nbsp;</td>					        
						</tr>
						<tr align="left">
								<td colspan=1 class="texte" align=left>Réf. Demande :</td>
								<td class="texte" colspan=1 align=left><html:text property="p_param12" styleClass="input"  size="12" maxlength="12"/>&nbsp;</td>					        
						</tr>
	
						<tr align="left">
								<td colspan=1 class="texte" align=left>Lignes :</td>
								<td class="texte" colspan=1 align=left><input type=radio name="p_param13" value="1" checked>&nbsp;Actives sur l'année</td>
								<td class="texte" colspan=1 align=left><input type=radio name="p_param13" value="2" >&nbsp;Toutes</td>					        
						</tr>				
						<tr>
	                        <td colspan=2 align="center">&nbsp;</td>
	                    </tr>
				   </table>
					
					  <!-- #EndEditable -->
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
				  <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, true);"/>
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
</body>
</html:html>

