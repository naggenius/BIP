<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<!-- #BeginEditable "imports" -->
<%@ page language="java"
	import="java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*, org.owasp.esapi.ESAPI"
	errorPage="../jsp/erreur.jsp"%>
<jsp:useBean id="extractionForm" scope="request"
	class="com.socgen.bip.commun.form.ExtractionForm" />
<jsp:useBean id="listeDynamique" scope="request"
	class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true">
<!-- #EndEditable -->

<head>
<style>
#topContainer TABLE TABLE TR {
	font-size: 12px;
}
</style>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>

<!-- #BeginEditable "doctitle" -->
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1">

<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/xBips.jsp" />

<script type="text/javascript" src="../js/jquery.js"></script>
<script type="text/javascript" src="../js/jquery.dimensions.js"></script>
<script type="text/javascript" src="../js/jqueryMultiSelectBips.js"></script>
<script language="JavaScript" src="../js/function.cjs"></script>

<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">

<link rel="stylesheet" href="../css/jqueryMultiSelectBips.css"
	type="text/css" />
<script language="JavaScript">
var blnVerification = true;
var tabVerif = new Object();
<%String arborescence = ESAPI.encoder().encodeForJavaScript(
						ESAPI.encoder().canonicalize(
								request.getParameter("arborescence")));
				String sPageAide = ESAPI.encoder().encodeForJavaScript(
						ESAPI.encoder().canonicalize(
								request.getParameter("pageAide")));

				com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip) session
						.getAttribute("UserBip");
				com.socgen.bip.menu.item.BipItemMenu menu = user
						.getCurrentMenu();
				String menuId = menu.getId();

				java.util.Hashtable hP = new java.util.Hashtable();
				hP.put("userid", user.getInfosUser());

				java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique()
						.getListeDynamique("isac_pid_modif", hP);

				pageContext.setAttribute("choixPid", list1);%>
var pageAide = "<%=sPageAide%>";
<%String sTitre;
				String sInitial;
				String sJobId;%>
	function MessageInitial() {
		document.forms[0].p_param10.value = "toutes";
<%sJobId = "xBips";

				sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
				//sTitre = "TEST GENERATION .BIPS";
				if (sTitre == null) {
					//redirect sur la page d'erreur
					sTitre = "Pas de titre";
				}
				sInitial = ESAPI.encoder().encodeForJavaScript(
						ESAPI.encoder().canonicalize(request.getQueryString()));
				if (sInitial == null)
					sInitial = request.getRequestURI();
				else
					sInitial = request.getRequestURI() + "?" + sInitial;
				sInitial = sInitial
						.substring(request.getContextPath().length());%>
	var Message = "<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
		var Focus = "<bean:write name="extractionForm"  property="focus" />";

		if (Message != "") {
			alert(Message);
		}

		if (Focus != "") {
			if (eval("document.forms[0]." + Focus)) {
				(eval("document.forms[0]." + Focus)).focus();
			}
		}

	}

	function Verifier(form, flag) {
		blnVerification = flag;
	}

	function ValiderEcran(form) {

		document.forms[0].p_param11.value = document.forms[0].p_param11.value
				.replace(',f', '');

		document.extractionForm.submit.disabled = true;

		return true;
	}

	$(document).ready(function() {
		MessageInitial();

		$('select[name="pid"]').multiSelect({
			selectAll : false,
			selectAllText : 'Tout sélectionner',
			noneSelected : 'Choisir les lignes...',
			oneOrMoreSelected : '*'

		});
	});

	function selectAll() {
		document.forms[0].p_param10.value = "toutes";
		$('select[name="pid"]').deSelectAll({
			noneSelected : 'Choisir les lignes...'
		});
	}

	function display() {

		var alertBox = "";
		alertBox += "G&eacute;n&eacute;ration du fichier csv au format .BIPS en cours : consultez les Traitements diff&eacute;r&eacute;s";
		alertBox += "<br/>";
		alertBox += "<br/>";
		alertBox += "Quand vous voudrez recharger ce fichier en Bip, pensez au pr&eacute;alable";
		alertBox += "<br/>";
		alertBox += " &nbsp; * &agrave; revoir le contenu de certains champs (StructureAction, RessBipNom, etc...) si n&eacute;cessaire";
		alertBox += "<br/>";
		alertBox += " &nbsp; * &agrave; renommer le fichier en .BIPS</p>";
		alertBox += "<br/>";
		alertBox += "<div align=\"center\" ><input type=\"button\" name=\"btnOk\" value =\"Ok\" onClick=\"test();\"> </div>";
		alertBox += "</div>";
		alertBox += "<script language=\"JavaScript\">";

		alertBox += "function test(){ ";
		alertBox += "self.close(); ";
		alertBox += "} ";

		var divAlert = document.getElementById("divAlert");
		divAlert.innerHTML = alertBox;

		alert(divAlert.innerText);

	}
</script>

<!-- #EndEditable -->


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0"
	onLoad="MessageInitial();">

	<div id="mainContainer">
		<div id="topContainerbips" style="min-height: 98%;">
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
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td><div id="outils" align="center">
										<!-- #BeginEditable "barre_haut" -->
										<%
											ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",
														false, false, true, true, false, false, false, false,
														false, request);
										%>
										<%=tb.printHtml()%><!-- #EndEditable -->
									</div>
								</td>
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
								<td></td>
							</tr>
							<tr>
								<td><html:form action="/extract"
										onsubmit="display();return ValiderEcran(this);">
										<!-- #BeginEditable "debut_hidden" -->

										<html:hidden property="arborescence"
											value="<%= arborescence %>" />
										<input type="hidden" name="jobId" value="<%=sJobId%>">
										<input type="hidden" name="initial" value="<%=sInitial%>">
										<input type="hidden" name="pageAide" value="<%=sPageAide%>">
										<input type="hidden" name="p_param8" value="<%=menuId%>">
										<input type="hidden" name="listeReports" value="1">
										<input type="hidden" name="p_param6" value=".CSV" />

										<!-- #EndEditable -->

										<table width="100%" border="0">
											<tr>
												<td height="20"></td>
											</tr>
											<tr>
												<td>
													<div align="center">
														<!-- #BeginEditable "contenu" -->
														<table border=0 cellspacing=10 cellpadding=10
															class="tableBleu">

															<tr align="left">
																<td class="texte" align=right><b>S&eacute;lectionner
																		toutes mes lignes Bip habilit&eacute;es :</b>&nbsp;</td>
																<td><input checked type="radio" name="p_param10"
																	value="" onclick="selectAll();" /></td>
															</tr>
															<tr align="left">

																<td valign="baseline" class="texte" align=right><b>S&eacute;lectionner
																		certaines lignes Bip parmi mes lignes
																		habilit&eacute;es :</b>&nbsp;</td>
																<td valign="baseline" width="250px"><html:select
																		size="1" property="pid" multiple="true"
																		styleClass="input">
																		<html:options collection="choixPid" property="cle"
																			labelProperty="libelle" />
																	</html:select></td>

															</tr>

														</table>

														<!-- #EndEditable -->
													</div></td>
											</tr>
											<tr>
												<td>&nbsp; <input type="hidden" name="p_param11"
													value="" /></td>

											</tr>

											<tr>
												<td>
													<div align="center">
														<html:submit value="Valider" styleClass="input"
															onclick="Verifier(this.form, true);" />

													</div></td>
											</tr>

										</table>
										<!-- #BeginEditable "fin_form" -->
									</html:form>
									<!-- #EndEditable --></td>
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
	<span style="display: none;" id="divAlert"></span>
</body>
</html:html>