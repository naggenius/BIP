<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<!-- #BeginEditable "imports" -->
<%@ page language="java"
	import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"
	errorPage="../jsp/erreur.jsp"%>
<jsp:useBean id="tacheForm" scope="request"
	class="com.socgen.bip.form.TacheForm" />
<html:html locale="true">
<!-- #EndEditable -->
<!-- #BeginTemplate "/Templates/Page_maj.dwt" -->
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>
<!-- #BeginEditable "doctitle" -->
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="/structLb.do" />
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%String arborescence = ESAPI.encoder().encodeForJavaScript(
						ESAPI.encoder().canonicalize(
								request.getParameter("arborescence")));
				String sPageAide = ESAPI.encoder().encodeForJavaScript(
						ESAPI.encoder().canonicalize(
								request.getParameter("pageAide")));%>
var pageAide = "<%=sPageAide%>";


function MessageInitial()
{
	
   var Message="<bean:write filter="false"  name="tacheForm"  property="msgErreur" />";
   
   if (Message != "") {
      alert(Message);
   }
   
   <logic:notEqual name="tacheForm" property="mode" value="delete">
	   var Focus = "<bean:write name="tacheForm"  property="focus" />";
	   
	   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
	    else {
		   document.forms[0].libtache.focus();
	    }
	</logic:notEqual>
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
} 

function ValiderEcran(form) {
	  if (blnVerification == true) {
	     if ((form.action.value!="valider")&&(form.action.value!="annuler"))
	  		form.action.value ="valider";
	     if (!ChampObligatoire(form.libtache, "le libelle de la tâche")) return false;
	     if (form.action.value == 'valider' && form.mode.value == 'update') {
			if (!ChampObligatoire(form.acta, "le numéro de la tâche")) return false;

			Replace_Double_Chiffre("acta");	//Mettre le n° sur 2 chiffres si bug onChange
			if ((form.acta.value=="00")|(form.acta.value=="0")){
				alert("Entrez un autre numéro de tâche");
				form.acta.focus();
				return false;

			}
	        if (!confirm("Voulez-vous modifier cette tâche ?")) return false;
	     }
	     
	  // MCH : PPM 61919 chapitre 6.7
	     if (form.mode.value == 'insert' || form.mode.value == 'update') {
	         return verifierAxe(document.forms[0].pid.value,document.forms[0].tacheaxemetier.value); // MCH : QC1811
	        
	
	         
	     }
	  }
	  // On désactive le bouton valider pour éviter un double click
	  form.boutonValider.disabled=true;
	  return true;
	}
	
	
//MCH : 08/10/2015 PPM 61919 chapitre 6.10 définition des méthodes de contrôle , d'initialisation et de mise à vide du champ tacheaxemetier 
function verifierTacheAxeMetier(p_pid,p_tacheaxemetier){
	// Appel ajax de la méthode de l'action 
	ajaxCallRemotePage('/tache.do?action=verifierTacheAxeMetier&pid='+p_pid+'&tacheaxemetier='+p_tacheaxemetier);
	// Si la réponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
	
}

function initialiserTacheAxeMetier(p_pid){
	// Appel ajax de la méthode de l'action 
	ajaxCallRemotePage('/tache.do?action=initialiserTacheAxeMetier&pid='+p_pid);
	// Si la réponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
		
	return ajaxres;
	
}

function mettreAvide(p_type,p_param_id){
	<% String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getIdUser(); %>
	// Appel ajax de la méthode de l'action
	ajaxCallRemotePage('/tache.do?action=mettreAvide&type='+p_type+'&param_id='+p_param_id+'&userid='+'<%=userid%>');
	// Si la réponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
	
}
//MCH : QC1811
function verifierAxe(p_pid,p_tacheaxemetier)
{
	var result = verifierTacheAxeMetier(p_pid,p_tacheaxemetier);
    var tab = result.split(';');
    var type = tab[0];
    var param_id = tab[1];
    var message = tab[2];
    if(message =='absence')
  	 {
   	 document.forms[0].absence_param.value = message; 
   	 return true;
  	 }
    else
    {
    if(message =='valid')
    {
   	
  	  	return true;
    }
    else
    {
    	if(message!="" && message.substring(0,9).toUpperCase() == 'ATTENTION')
    	{
   		
   	 	if(confirm(message))
   	 	{
   	    	mettreAvide(type,param_id);
   	    	
   	       	return verifierAxe(p_pid,p_tacheaxemetier);
   	    }
   	    else 
   	    {
   	       	document.forms[0].tacheaxemetier.focus();
   	       	return false;
   	    }
   	}
   	else
   	{
   		alert(message);
   		document.forms[0].tacheaxemetier.focus();
        	return false;
   	}
   }
    
    
}
}

</script>
<!-- #EndEditable -->
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0"
	onLoad="MessageInitial();">
	<div id="mainContainer">
		<div id="topContainer">
			<div style="display: none;" id="ajaxResponse"></div>
			<div id="entete"></div>
			<div id="logo">
				<div id="logo_sg">
					<img src="../images/logo_SG.gif" width="162" height="33" border="0" />
				</div>
				<div id="nomdusite">
					<img src="../images/bip_logo.png" width="78" height="46" border="0" />
				</div>
			</div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<div id="outils" align="center">
										<!-- #BeginEditable "barre_haut" -->
										<%
											ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",
														false, false, true, true, false, false, false, false,
														false, request);
										%>
										<%=tb.printHtml()%><!-- #EndEditable -->
									</div></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td height="20" class="TitrePage">
									<!-- #BeginEditable "titre_page" -->
									<div id="titre">
										<bean:write name="tacheForm" property="titrePage" />
										une t&acirc;che
										<!-- #EndEditable -->
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<!-- #BeginEditable "debut_form" --> <html:form action="/tache"
										onsubmit="return ValiderEcran(this);">
										<!-- #EndEditable -->
										<div id="content">
											<div align="center">
												<!-- #BeginEditable "contenu" -->
												<input type="hidden" name="pageAide"
													value="<%=sPageAide%>">
												<html:hidden property="action" />
												<html:hidden property="mode" />
												<html:hidden property="arborescence"
													value="<%= arborescence %>" />
												<html:hidden property="keyList0" />
												<!--pid-->
												<html:hidden property="keyList1" />
												<!--n°etape-->
												<html:hidden property="keyList2" />
												<!--etape - libelle etape-->
												<html:hidden property="etape" />
												<html:hidden property="tache" />
												<html:hidden property="flaglock" />
												<html:hidden property="pid" />
												<html:hidden property="titrePage" />
												<html:hidden property="typproj" />
												<html:hidden property="btRadioStructure" />
												<html:hidden property="direction" />
												<html:hidden property="absence_param" />
												<table border="0" cellpadding="0" cellspacing="0"
													width="100%" class="tableBleu">
													<tr>
														<td>&nbsp;</td>
													</tr>
													<tr>
														<td>&nbsp;</td>
													</tr>
												</table>
												<table border=2 cellspacing=0 cellpadding=10
													class="TableBleu" bordercolor="#2E2E2E">
													<tr>
														<td align="center" height="10" class="texte"><b>Ligne
																BIP </b>:<b> <bean:write name="tacheForm" property="lib" />
																<html:hidden property="lib" />
														</b></td>
													</tr>
													<tr>
														<td align="center" height="10" class="texte"><b>Etape
														</b>:<b> <bean:write name="tacheForm" property="keyList2" />
																<html:hidden property="keyList2" />
														</b></td>
													</tr>
												</table>
												<table border="0" cellpadding="2" cellspacing="2"
													class="tableBleu">
													<tr>
														<td>&nbsp;</td>
													</tr>
													<tr>
														<td>&nbsp;</td>
													</tr>
													<tr align="left">
														<td class="texteGras"><b>N° tâche :</b></td>
														<td class="texte"><logic:equal name="tacheForm"
																property="mode" value="update">
																<html:text property="acta" styleClass="input" size="3"
																	maxlength="2"
																	onchange="return Replace_Double_Chiffre(this.name);" />
															</logic:equal> <logic:notEqual name="tacheForm" property="mode"
																value="update">
																<bean:write name="tacheForm" property="acta" />
																<html:hidden property="acta" />
															</logic:notEqual></td>
													</tr>
													<tr align="left">
														<td class="texteGras"><b>Libellé :</b></td>
														<td class="texte">
															<%
																// Si mode suppression
															%> <logic:equal name="tacheForm"
																property="mode" value="delete">
																<bean:write name="tacheForm" property="libtache" />
																<html:hidden property="libtache" />
															</logic:equal> <%
 	// Sinon
 %> <logic:notEqual name="tacheForm"
																property="mode" value="delete">
																<html:text property="libtache" styleClass="input"
																	size="35" maxlength="30" />
															</logic:notEqual></td>
													</tr>
													<tr align="left">
														<td class="texteGras"><b>Ref_demande :</b></td>
														<td class="texte">
															<%
																// Si mode suppression
															%> <logic:equal name="tacheForm"
																property="mode" value="delete">
																<bean:write name="tacheForm" property="tacheaxemetier" />
																<html:hidden property="tacheaxemetier" />
															</logic:equal> <%
 	// Sinon
 %> <logic:notEqual name="tacheForm"
																property="mode" value="delete">
																<html:text id="tacheaxemetier" property="tacheaxemetier"
																	styleClass="input" size="12" maxlength="12" />
															</logic:notEqual></td>
													</tr>
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
												<!-- #EndEditable -->
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
													<html:submit property="boutonValider" value="Valider"
														styleClass="input"
														onclick="Verifier(this.form, 'valider', this.form.mode.value,true);" />
												</div></td>
											<td width="25%">
												<div align="center">
													<html:submit property="boutonAnnuler" value="Annuler"
														styleClass="input"
														onclick="Verifier(this.form, 'annuler', this.form.mode.value, false);" />
												</div></td>
											<td width="25%">&nbsp;</td>
										</tr>
									</table> <!-- #BeginEditable "fin_form" -->
									</html:form>
									<!-- #EndEditable -->
									</div></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>
									<div align="center">
										<html:errors />
										<!-- #BeginEditable "barre_bas" -->
										<!-- #EndEditable -->
									</div></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
						</table></td>
				</tr>
			</table>
		</div>
		<div id="bottomContainer">
			<div>&nbsp;</div>
		</div>
	</div>
</body>
<script language="JavaScript">
if (document.forms[0].mode.value == 'insert'){
	document.forms[0].tacheaxemetier.value = initialiserTacheAxeMetier(document.forms[0].pid.value);}
</script>
</html:html>
<%
	Integer id_webo_page = new Integer("6002");
	com.socgen.bip.commun.form.AutomateForm formWebo = tacheForm;
%>
<%@ include file="/incWebo.jsp"%>
<!-- #EndTemplate -->
