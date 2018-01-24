<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<!-- #BeginEditable "imports" -->
<%@ page language="java"
	import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.form.GestBudgForm"
	errorPage="../jsp/erreur.jsp"%>
<jsp:useBean id="gestBudgForm" scope="request"
	class="com.socgen.bip.form.GestBudgForm" />
<html:html locale="true">
<!-- #EndEditable -->
<!-- #BeginTemplate "/Templates/Page_bip.dwt" -->
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>
<!-- #BeginEditable "doctitle" -->
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/bGestionbudgAd.jsp" />
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
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

//KRA 64613
var anneeCourante = '<bip:value champ="to_char(datdebex, 'YYYY')" table="datdebex" clause1="1" clause2="1" />';

function MessageInitial()
{
    var Message="<bean:write filter="false"  name="gestBudgForm"  property="msgErreur" />";
   var Focus = "<bean:write name="gestBudgForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].pid.focus();
   }
   //KRA 64613
	document.forms[0].annee.value = anneeCourante; 
}

function Verifier(form, action,mode, flag)
{
  blnVerification = flag;
  form.action.value = action;
  form.mode.value = mode;
  if (ValiderEcran(form)) {
   		form.submit();
   }
}

function ValiderEcran(form)
{
   if (blnVerification==true) {
	if (!ChampObligatoire(form.pid, "un code ligne BIP")) return false;
	if (!ChampObligatoire(form.annee, "une année")) return false;
   }
   
   return true;
}


function recherchePID(champs){
	window.open("/recupPID.do?action=initialiser&nomChampDestinataire="+champs+"&windowTitle=Recherche Code Ligne BIP"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
} 

function nextFocusCodeDPG(champs){
	document.forms[0].elements[champs].focus();
}

</script>
<!-- #EndEditable -->
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0"
	onLoad="MessageInitial();">
	<div id="mainContainer">
		<div id="topContainer" style="min-height:98%;">
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
								<td background="../images/ligne.gif"></td>
							</tr>
							<tr>
								<td height="20" class="TitrePage">
									<!-- #BeginEditable "titre_page" -->Gestion des budgets par
									ligne BIP<!-- #EndEditable -->
								</td>
							</tr>
							<tr>
								<td background="../images/ligne.gif"></td>
							</tr>
							<tr>
								<td></td>
							</tr>
							<tr>
								<td>
									<!-- #BeginEditable "debut_form" -->
									<html:form action="/gestBudg">
										<!-- #EndEditable -->
										<table width="100%" border="0">
											<tr>
												<td>
													<div align="center">
														<!-- #BeginEditable "contenu" -->
														<input type="hidden" name="pageAide"
															value="<%=sPageAide%>">
														<html:hidden property="action" />
														<html:hidden property="mode" />
														<html:hidden property="arborescence"
															value="<%= arborescence %>" />

														<table border=0 cellpadding=2 cellspacing=2
															class="tableBleu">
															<tr>
																<td height="20" align=center>&nbsp;</td>
																<td>&nbsp;</td>
															</tr>
															<tr>
																<td>&nbsp;</td>
																<td>&nbsp;</td>
															</tr>
															<tr align="left">
																<td class="texte"><b>Code ligne BIP : </b>
																</td>
																<td class="texte"><html:text property="pid"
																		styleClass="input" size="4" maxlength="4"
																		onchange="return VerifierAlphaMax(this);" />
																	&nbsp;<a href="javascript:recherchePID('pid');"
																	onFocus="javascript:nextFocusCodeDPG('annee');"><img
																		border=0 src="/images/p_zoom_blue.gif"
																		alt="Rechercher Code Ligne BIP"
																		title="Rechercher Code Ligne BIP" style="vertical-align : middle;">
																</a></td>
															</tr>
															<tr align="left">
																<td class="texte"><b>Ann&eacute;e :</b>
																</td>
																<td class="texte"><html:text property="annee"
																		styleClass="input" size="4" maxlength="4"
																		onchange="return VerifierDate(this,'aaaa');" /></td>
															</tr>
															<tr>
																<td align=center>&nbsp;</td>
																<td>&nbsp;</td>
															</tr>
															<tr>
																<td align=center>&nbsp;</td>
																<td>&nbsp;</td>
															</tr>
															<tr>
																<td align=center>&nbsp;</td>
																<td>&nbsp;</td>
															</tr>
														</table>

														<table width="100%" border="0">
														
															<tr><td height="20"></td></tr>
															
															<tr>
																<td width="25%">&nbsp;</td>
																<td width="25%">
																	<div align="center">
																		<html:button property="boutonConsulterGlob"
																			value="Consulter globalement" 
																			style="width: 210px"
																			onclick="<%= \"Verifier(this.form,'administrer','\" + GestBudgForm.modeConsulterGlobalement + \"',true);\"%>" />
																	</div></td>
																<td width="25%">
																	<div align="center">
																		<html:button property="boutonModifier"
																			value="Modifier" styleClass="input"
																			onclick="Verifier(this.form, 'administrer', 'update', true);" />
																	</div></td>
																<td width="25%">&nbsp;</td>
															</tr>
															<tr>
																<td width="25%">&nbsp;</td>
																<td width="25%">
																	<div align="center">
																		<html:button property="boutonConsulterHistoArbi"
																			value="Consulter historique Arbitr&eacute;"
																			styleClass="input" style="width: 210px"
																			onclick="<%= \"Verifier(this.form,'\" + GestBudgForm.actionConsulterHisto + \"','\" + GestBudgForm.modeConsulterHistoArb + \"',true);\"%>" />
																	</div></td>
																<td width="25%"></td>
																<td width="25%">&nbsp;</td>
															</tr>
															<tr>
																<td width="25%">&nbsp;</td>
																<td width="25%">
																	<div align="center">
																		<html:button property="boutonConsulterHistoRees"
																			value="Consulter historique R&eacute;estim&eacute;"
																			styleClass="input" style="width: 210px"
																			onclick="<%= \"Verifier(this.form,'\" + GestBudgForm.actionConsulterHisto + \"','\" + GestBudgForm.modeConsulterHistoRees + \"',true);\"%>" />
																	</div></td>
																<td width="25%">
																	<div align="center">
																		<html:button property="boutonAnnuler" value="Annuler"
																			styleClass="input"
																			onclick="window.location.href='/listeFavoris.do?arborescence=Menu Client/Favoris&sousMenu=&pageAide=/jsp/aide/Guide_Menu_Client.doc&addFav=no&action=initialiser&titlePage=Liste+des+favoris&lienFav=%2FlisteFavoris.do'" />
																	</div></td>
																<td width="25%">&nbsp;</td>
															</tr>
														</table>

														<!-- #EndEditable -->
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
</body>
</html:html>
<!-- #EndTemplate -->
