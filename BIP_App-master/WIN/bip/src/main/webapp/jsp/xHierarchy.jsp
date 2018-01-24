<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*" errorPage="../jsp/erreur.jsp"%>

<jsp:useBean id="editionForm" scope="request"
	class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true">
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>

<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/xHierarchy.jsp" />
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%String arborescence = ESAPI.encoder().encodeForJavaScript(
						ESAPI.encoder().canonicalize(
								request.getParameter("arborescence")));
				String sPageAide = ESAPI.encoder().encodeForJavaScript(
						ESAPI.encoder().canonicalize(
								request.getParameter("pageAide")));%>
var pageAide = "<%=sPageAide%>";

	var blnVerifFormat = true;
	var tabVerif = new Object();
<%

	String sTitre;
	String sInitial;
	String p_global=((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser();
	String sJobId="xHierarchy1";
	
%>
	function MessageInitial() {
<%//sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
				sTitre = "Pas de titre";
				/* if (sTitre == null)	{
					//redirect sur la page d'erreur
					sTitre = "Pas de titre";
				} */
				sInitial = ESAPI.encoder().encodeForJavaScript(
						ESAPI.encoder().canonicalize(request.getQueryString()));
				if (sInitial == null)
					sInitial = request.getRequestURI();
				else
					sInitial = request.getRequestURI() + "?" + sInitial;
				sInitial = sInitial
						.substring(request.getContextPath().length());%>
	tabVerif["p_param7"] = "VerifierAlphaMax(document.editionForm.p_param7)";

		var Message = "<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
		var Focus = "<bean:write name="editionForm"  property="focus" />";

		if (Message != "") {
			alert(Message);
		}
		/* if (Focus != "")
			(eval("document.forms[0]." + Focus)).focus();
		else {
			document.forms[0].p_param6.focus();
		} */
	}

	function Verifier(form, bouton, flag) {
		blnVerification = flag;
		form.action.value=bouton;
	}

	function ValiderEcran(form) {
	
	if(blnVerification){
		var choix;
		var coche = false;
		if (blnVerification) {
			for (i = 0; i < document.forms[0].choix.length; i++) {
				if (document.forms[0].choix[i].checked) {
					choix = document.forms[0].choix[i].value;
					coche = true;
				}
			}

			if (coche == false) {
				choix = "non";
			}

			switch (choix) {
			case "1":
			document.editionForm.p_param8.value='1';
			break;
			case "2":
			document.editionForm.p_param8.value='2';
			break;
			case "3":
			document.editionForm.p_param8.value='3';
			break;
			case "4":
			document.editionForm.p_param8.value='4';
				if (!ChampObligatoirePersonnalise(form.p_param6, "Vous devez saisir une valeur "))
					return false;
				break;
			case "5":
			document.editionForm.p_param8.value='5';
				if (!ChampObligatoirePersonnalise(form.p_param7, "Vous devez saisir une valeur "))
					return false;
				break;
			
			case "non":
				alert("Select the choice");
				return false;
				break;
			}
			
						
			if(document.forms[0].order[0].checked){
				document.editionForm.p_param9.value='1';
			}
			else if (document.forms[0].order[1].checked){
				document.editionForm.p_param9.value='2';
			}
			else{
				alert("Select the order");
				return false;
			}
			
			if (!VerifFormat(null))
				return false;

		}
		
	if(!TraitementAjax('validateHierarchyInput', '&p_param6=' + document.editionForm.p_param6.value+'&p_param7=' + document.editionForm.p_param7.value))
	{
	return false;
	}
		document.editionForm.submit.disabled = true;
		return true;
	}


}

function TraitementAjax(pMethode, pParams) {	
	ajaxCallRemotePage('/projet.do?action=' + pMethode + pParams);
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		alert(document.getElementById("ajaxResponse").innerHTML);
		return false;
	}
	return true;
}

function checkOption(obj){

if(obj.name== 'p_param6'){
document.getElementById("txt1").checked = true;
}
else if(obj.name== 'p_param7'){
document.getElementById("txt2").checked = true;
}

}

function ChangeAff(newAff) {
		
	 	document.forms[0].p_param6.style.display = "none";
		document.forms[0].p_param7.style.display = "none"; 
		
		if (newAff == "4"){
			document.forms[0].p_param7.value = "";
			document.forms[0].p_param6.style.display = "";
			 
			}
		else if (newAff == "5") {
			document.forms[0].p_param6.value = "";
			document.forms[0].p_param7.style.display = "";
			}
		else {
			document.forms[0].p_param6.value = "";
			document.forms[0].p_param7.value = "";
			}
		
	}
</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0"
	onLoad="MessageInitial();">
	<div id="mainContainer">
		<div id="topContainer" style="min-height: 98%;">
			<div id="entete"></div>
			<div id="logo">
				<div id="logo_sg">
					<img src="../images/logo_SG.gif" width="162" height="33" border="0" />
				</div>
				<div id="nomdusite">
					<img src="../images/bip_logo.png" width="78" height="46" border="0" />
				</div>
			</div>
			<div style="display: none;" id="ajaxResponse"></div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							<tr>
								<td><div id="outils" align="center">
										<!-- #BeginEditable "barre_haut" -->
									<%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false, false, true, true, false, false, false, false,false, request);
									%><%=tb.printHtml()%><!-- #EndEditable -->
									</div>
								</td>
							</tr>
							<!--         <tr>  -->
							<!--           <td background="../images/ligne.gif"></td> -->
							<!--         </tr> -->
							<tr>
								<td height="20" class="TitrePage">Restitution de la hiérarchie de resources</td>
							</tr>
							<tr>
								<td background="../images/ligne.gif"></td>
							</tr>
							<tr>
								<td><html:form action="/edition"
										onsubmit="return ValiderEcran(this);">
										<div align="center">
											<input type="hidden" name="jobId" value="<%= sJobId %>">
            								<input type="hidden" name="initial" value="<%= sInitial %>">
											<html:hidden property="arborescence" value="<%= arborescence %>"/>
											<html:hidden property="action" value="refresh"/>
											<input type="hidden" name="pageAide" value="<%=sPageAide%>">
            								<input type="hidden" name="p_global" value="<%= p_global %>">
											<html:hidden property="p_param8"/>
											<html:hidden property="p_param9"/>
											
											<table border=0 cellpadding=2 cellspacing=2 class="tableBleu" width="80%">

												<tr>
													<td>&nbsp;</td>
													<td height="20">&nbsp;</td>
												</tr>
												<tr>
													<td class="lib" rowspan="5" nowrap><B>Ressource	concernée :</B></td>
													<td class="texte" colspan="5"><input type=radio  name="choix" value="1" onclick="ChangeAff(this.value);">
                         								 Moi-même, selon les <u>situations de mes N-1</u>
                         							</td>
													
												</tr>
												<tr>
													<td colspan="5" class="texte"><input type="radio"  name="choix" value="2"	onclick="ChangeAff(this.value);">
														 Moi-même,dans ma hiérarchie complète, selon les <u>situations</u></td>
												</tr>
												<tr>
													<td colspan="5" class="texte"><input type="radio" name="choix" value="3" onclick="ChangeAff(this.value);" checked="checked"> 
														 Moi-même,selon mes <u>habilitations</u> </td>
												</tr>
												<tr>
													<td	colspan="1" class="texte" ><input type="radio" name="choix" value="4" id="txt1" onclick="ChangeAff(this.value);"> 
														Utilisateur tiers :
													</td>
													<td colspan="1"><html:text property="p_param6" styleClass="input" style="display='none'" size="8"  maxlength="6"
														onclick="checkOption(this);"  onchange="return VerifierAlphaMax(this);" />
													</td>
													<td colspan="3" class="texte">
														selon les <u>situations</u> (code ress Bip ou code ress Bip*)</td>
												</tr>
												<tr>
													<td colspan="1" class="texte"><input type="radio" name="choix"  value="5" id="txt2"  onclick="ChangeAff(this.value);"> 
														&nbsp;Utilisateur tiers :</td>
													<td colspan="1"><html:text property="p_param7" styleClass="input" style="display='none'" size="12" maxlength="10"
														onclick="checkOption(this);" onchange="return VerifierAlphaMax(this);"/></td>
													<td colspan="3" class="texte">selon ses <u>habilitations</u> (code ress Bip ou ID connexion RTFE ou IGG)&nbsp;</td>
												</tr>
												<tr>
													<td colspan="1" class="lib" nowrap><B>Tri des ressources sur :</B></td>
													<td colspan="1" class="texte"><input type="radio" name="order" value="1" > 
													 Leur code </td>
													<td colspan="4" class="texte"><input type="radio" name="order" value="2" checked="checked"> 
													Leur Nom et prénom</td>
												</tr>
												<tr>
													<td>&nbsp;</td>
													<td>&nbsp;</td>
												</tr>
												<tr>
													<td>&nbsp;</td>
													<td>&nbsp;</td>
												</tr>
												<tr>
													<td>&nbsp;</td>
													<td>&nbsp;</td>
												</tr>
												<tr>
													<td colspan="1"></td>
													<td align="left"><html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'liste', true);" /></td>
													<td align="center"><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);" />
													</td>
												</tr>
											</table>
										</div>
									</html:form></td>
							</tr>

							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>
									<div align="center">
										<html:errors />
									</div>
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