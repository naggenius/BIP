<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<!-- #BeginEditable "imports" -->

<%@ page language="java"
	import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Vector,com.socgen.bip.commun.BIPActionMapping,com.socgen.bip.commun.BipConstantes,com.socgen.bip.commun.form.BipForm,com.socgen.bip.log4j.BipUsersAppender,com.socgen.bip.user.UserBip,com.socgen.cap.fwk.ServiceManager,com.socgen.cap.fwk.log.Log,com.socgen.bip.commun.liste.ListeOption"
	errorPage="../jsp/erreur.jsp"%>
<jsp:useBean id="extractionForm" scope="request"
	class="com.socgen.bip.commun.form.ExtractionForm" />
<%@page
	import="org.owasp.esapi.ESAPI,org.apache.commons.lang.StringUtils"%>
<html:html locale="true">
<!-- #EndEditable -->

<head>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>

<!-- #BeginEditable "doctitle" -->
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="/simulimmoinit.do" />
<%
			com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip) session
			.getAttribute("UserBip");
	java.util.Hashtable hP = new java.util.Hashtable();

	hP.put("userid", userbip.getInfosUser());

	java.util.ArrayList dossProj = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("dprojet_limitation_ref", hP);
	dossProj.add(0, new ListeOption("TOUS", "Tous"));
	dossProj.add(1, new ListeOption("Pas de limitation",
			"Pas de limitation"));
	pageContext.setAttribute("choixDProjet", dossProj);

	java.util.ArrayList projet = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("projet_limitation_ref", hP);
	projet.add(0, new ListeOption("TOUS", "Tous"));
	projet.add(1, new ListeOption("Pas de limitation",
			"Pas de limitation"));
	pageContext.setAttribute("choixProjet", projet);

	java.util.ArrayList axe_strat = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("axe_strat_simul", hP);
	pageContext.setAttribute("choixAxe", axe_strat);

	java.util.ArrayList type_fin = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("type_fin_simul", hP);
	pageContext.setAttribute("choixTypeFin", type_fin);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var tabVerif = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
<%
	String sTitre;
	String sInitial;
	String sJobId;
%>


function MessageInitial()
{
	<%
		
		sJobId = "xSimulImmoRef";
		
	
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)
		{
			//redirect sur la page d'erreur
			sTitre = "Pas de titre";
		}		
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>

	document.getElementById("extraire").style.visibility = "visible";
	
	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";

   
   if (Message != "") {
      alert(Message);
   }

	if (Focus != "") {
		if (eval( "document.forms[0]."+Focus )){
			(eval( "document.forms[0]."+Focus )).focus();
		}
	}
	
}

function Verifier(form, action, flag)
{
     blnVerification = flag;
     form.action.value = action;
}
// PPM 58162 - fonction pour empêcher le choix des valeurss --- Habil Directe --- ou --- Habil par DP ---
function selectHabil(){
 if(document.forms[0].p_param8.value == '--- Habil Directe ---' || 
	document.forms[0].p_param8.value == '--- Habil par DP ---' ){
	document.forms[0].p_param8.value = 'TOUS';
	return true;
	}
	return false;
}
// PPM 58162 - Modification de la fonction pour intégrer le contrôle selectHabil() et affichage du message d'erreur
function ValiderEcran(form) {

	 // il faut au moins qu'un des critères soit différent de "Pas de limitation"
  if (form.p_param7.value == "Pas de limitation"
      && form.p_param8.value == "Pas de limitation"
       && form.p_param9.value == "Pas de limitation"
       && form.p_param10.value == "Pas de limitation")
  {
  	alert("Choisir au moins une valeur");
  	return false;
  }
  if(selectHabil()){
		alert('les choix « --- Habil Directe --- » et « --- Habil par DP --- » ne sont pas des valeurs fonctionnelles. \n Merci de sélectionner un code projet');
		return false;
	}

	if ( !confirm("Confirmez-vous la demande d'extraction ?") ) return false;
	document.forms[0].submit.disabled = true;
	return true;
}

function MAJTypeExtract(typeExtract){
	if (typeExtract == "1"){
		document.forms[0].p_param6.value=".TXT";
	}
	else document.forms[0].p_param6.value=".CSV";

	return true;
}

function selectionAxeStrat(){

 	window.open("/selectloupesimulimmo.do?action=initialiser&contexte=AXE&rafraichir=OUI&windowTitle=SELECTION d'ENVELOPPES BUDGETAIRES&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=no, scrollbars=no, width=700, height=600") ;
	
} 

function selectionTypeFinancement(){

 	window.open("/selectloupesimulimmo.do?action=initialiser&contexte=FIN&rafraichir=OUI&windowTitle=SELECTION de TYPES DE FINANCEMENT&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=no, scrollbars=no, width=700, height=400") ;
	
} 
</script>

<!-- #EndEditable -->


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0"
	onLoad="MessageInitial();">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
		<div align="center"><!-- #BeginEditable "barre_haut" --> <%
 			ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm", false,
 			false, true, false, false, false, false, false, false,
 			request);
 %> <%=tb.printHtml()%><!-- #EndEditable --></div>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td background="../images/ligne.gif"></td>
	</tr>
	<tr>
		<td height="20" class="TitrePage"><%=sTitre%></td>
	</tr>
	<tr>
		<td background="../images/ligne.gif"></td>
	</tr>
	<tr>
		<td></td>
	</tr>
	<tr>
</table>

<html:form action="/simulimmoinit" onsubmit="return ValiderEcran(this);">
	<!-- #BeginEditable "debut_hidden" -->

	<html:hidden property="arborescence" value="<%= arborescence %>" />
	<html:hidden property="action" value="initialiser" />
	<input type="hidden" name="jobId" value="<%=sJobId%>">
	<input type="hidden" name="initial" value="<%= sInitial %>">
	<input type="hidden" name="pageAide" value="<%= sPageAide %>">
	<input type="hidden" name="p_param6" value=".CSV">
	<!-- #EndEditable -->
	<table width="80%" border="0" cellspacing="0" cellpadding="0"
		class="tableBleu" align="center">
		<tr>
			<td align="left"><b>Cette extraction prend en compte votre
			périmètre habilité sur les Dossiers projets et projets. </td>
		</tr>
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
		<tr>
			<td align="left">Vous pouvez limiter la demande aux éléments
			ci-dessous :</td>
		</tr>
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
	</table>


	<table border=0 class="tableBleu" width="90%" cellspacing="1"
		align="center" cellpadding="1">
		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		<tr>
			<td width="27%" class="lib" align=left><b>Limitation à un
			Dossier Projet :</b></td>
			<td width="3%">&nbsp;</td>
			<td width="45%"><html:select property="p_param7"
				styleClass="input">
				<html:options collection="choixDProjet" property="cle"
					labelProperty="libelle" />
			</html:select></td>

			<td align="center" width="25%" rowspan=11>
			<table>
				<tr>
					<td class="lib" width="200px"><b>Explications sur les
					choix :</b><br>
					<br>
					<i>Tous</i><br>
					indique que vous souhaitez<br>
					retenir toutes les valeurs<br>
					du critère concerné;<br>
					<br>
					<i>Pas de limitation</i><br>
					indique que vous ne souhaitez<br>
					pas prendre en compte le<br>
					critère concerné.</td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td colspan="2"><i>Toute catégorie</i></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2"><i>Avec ou sans date d'immobilisation</i></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan=3 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left><b>Limitation à un Projet :</b></td>
			<td>&nbsp;</td>
			<td><html:select property="p_param8" styleClass="input">
				<html:options collection="choixProjet" property="cle"
					labelProperty="libelle" />
			</html:select></td>

		</tr>
		<tr>
			<td colspan=3 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left><b>Limitation à une enveloppe budgétaire :</b></td>
			<td align="center"><a href="javascript:selectionAxeStrat();"><img
				border=0 src="/images/p_zoom_blue.gif"
				alt="Sélection enveloppe budgétaire" title="Sélection enveloppe budgétaire"
				align="absbottom"></a></td>
			<td><html:select property="p_param9" styleClass="input">
				<html:options collection="choixAxe" property="cle"
					labelProperty="libelle" />
			</html:select></td>

		</tr>
		<tr>
			<td><i>Si fonction COPI utilisée</i></td>
			<td colspan=2>&nbsp;</td>
		</tr>
		<tr>
			<td colspan=3>&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left><b>Limitation à un type de
			financement :</b></td>
			<td align="center"><a
				href="javascript:selectionTypeFinancement();"><img border=0
				src="/images/p_zoom_blue.gif" alt="Sélection type financement"
				title="Sélection type financement" align="absbottom"></a></td>
			<td><html:select property="p_param10" styleClass="input">
				<html:options collection="choixTypeFin" property="cle"
					labelProperty="libelle" />
			</html:select></td>
		</tr>
		<tr>
			<td><i>Si fonction COPI utilisée</i></td>
			<td colspan=2>&nbsp;</td>
		</tr>
		<tr>
			<td colspan=4 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align="left"><b>Extension du fichier :</b></td>
			<td>&nbsp;</td>
			<td colspan=3><select name="listeReports" class="input"
				onChange="return MAJTypeExtract(this.value)">
				<option value="1">.TXT</option>
				<option value="2" SELECTED>.CSV</option>
			</select></td>
		</tr>
		<tr>
			<td colspan=4 align="center">&nbsp;</td>
		</tr>

	</table>
	<div id="wait" align="center" class="tableBleu"
		style="font : normal 8pt Verdana, Helvetica, sans-serif;position:relative;padding:5px;display:none"><img
		src="../images/indicator.gif" /> Veuillez patienter...</div>

	<table id="extraire" border=0 class="tableBleu" width="90%"
		cellspacing="1" align="center" cellpadding="0">
		<tr>
			<td align="center"><html:submit value="Extraire"
				styleClass="input" onclick="Verifier(this.form,'extraire',true);" /></td>
		</tr>
	</table>

</html:form>

<html:errors />

</body>
</html:html>
