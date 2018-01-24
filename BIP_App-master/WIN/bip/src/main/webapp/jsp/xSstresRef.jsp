<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<!-- #BeginEditable "imports" -->
<%@ page language="java"
	import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"
	errorPage="../jsp/erreur.jsp"%>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true">
<!-- #EndEditable -->

<head>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>

<!-- #BeginEditable "doctitle" -->
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/xSstresRef.jsp" />
<%
			com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip) session
			.getAttribute("UserBip");

	java.util.Hashtable hP = new java.util.Hashtable();
	java.util.Hashtable hP_cafi = new java.util.Hashtable();
	java.util.Hashtable hP_cada = new java.util.Hashtable();
	java.util.Hashtable hP_ca_payeur = new java.util.Hashtable();

	String ca_payeur = "";
	String ca_da = "";
	String ca_fi = "";
	Vector v = new Vector();

	v = userbip.getCADA();
	if (v != null) {
		for (int i = 0; i < v.size(); i++) {
			ca_da += (String) v.elementAt(i);
			if (i != (v.size() - 1))
		ca_da += ",";
		}
	}

	if (userbip.getCAFI() != null) {
		ca_fi = userbip.getCAFI();
	}

	if (userbip.getCAPayeur() != null) {
		ca_payeur = userbip.getCAPayeur();
	}
	if (userbip.getCAFI() != null) {
		ca_fi = userbip.getCAFI();
	}

	hP.put("userid", userbip.getInfosUser());
	hP_ca_payeur.put("ca_payeur", ca_payeur);
	hP_cafi.put("ca_payeur", ca_fi);
	hP_cada.put("ca_payeur", ca_da);

	java.util.ArrayList dossProj = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("dprojet_limitation_ref", hP);
	pageContext.setAttribute("choixDProjet", dossProj);

	java.util.ArrayList projet = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("projet_limitation_ref", hP);
	pageContext.setAttribute("choixProjet", projet);

	java.util.ArrayList appli = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("appli_limitation_ref", hP);
	pageContext.setAttribute("choixAppli", appli);

	java.util.ArrayList liste_cafi = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("ca_utilisateur_rtfe_ref", hP_cafi);
	pageContext.setAttribute("choixCafi", liste_cafi);

	java.util.ArrayList liste_ca_payeur = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("ca_utilisateur_rtfe_ref", hP_ca_payeur);
	pageContext.setAttribute("choixCa_payeur", liste_ca_payeur);

	java.util.ArrayList liste_cada = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("ca_utilisateur_rtfe_ref", hP_cada);
	pageContext.setAttribute("choixCada", liste_cada);
%>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var tabVerif = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = request.getParameter("pageAide");
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
		sJobId = "xSstresRef";
	
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
       && form.p_param10.value == "Pas de limitation"
       && form.p_param11.value == "Pas de limitation"
       && form.p_param12.value == "Pas de limitation")
  {
  	alert("Choisir au moins une valeur");
  	return false;
  }
	if(selectHabil()){
		alert('les choix « --- Habil Directe --- » et « --- Habil par DP --- » ne sont pas des valeurs fonctionnelles. \n Merci de sélectionner un code projet');
		return false;
	}	
	if ( !confirm("Confirmez-vous la demande d'extraction ?") ) return false;
	document.extractionForm.submit.disabled = true;
	return true;
}

function MAJTypeExtract(typeExtract){
	if (typeExtract == "1"){
		document.extractionForm.p_param6.value=".TXT";
	}
	else document.extractionForm.p_param6.value=".CSV";

	return true;
}
</script>

<!-- #EndEditable -->


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
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

</table>

<table width="95%" border="0" class="tableBleu" align="center">
	<html:form action="/extract" onsubmit="return ValiderEcran(this);">
		<!-- #BeginEditable "debut_hidden" -->
		
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
		<input type="hidden" name="initial" value="<%= sInitial %>">
		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		<input type="hidden" name="p_param6" value=".TXT">
		<div align="center">
		<tr>
			<td colspan=3 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td colspan=3 align="left"><b>Cet export prend en compte votre périmètre Dossier projet,
			projet, application, CAFI, CA payeur et CADA.<br>
			Vous pouvez limiter la demande aux éléments ci-dessous :</b></td>
		</tr>
		<tr>
			<td colspan=3 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left width="25%"><b>Limitation à un Dossier Projet :</b></td>
			<td><html:select property="p_param7" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixDProjet" property="cle" labelProperty="libelle" />
			</html:select></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan=3 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left width="25%"><b>Limitation à un Projet :</b></td>
			<td><html:select property="p_param8" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixProjet" property="cle" labelProperty="libelle" />
			</html:select></td>
			<td align="left" rowspan="7" width="25%">
			<fieldset>
			<div class="lib"><b>Explications sur les choix :</b></br>
			</br>
			<i>Tous ou Toutes</i></br>
			indique que vous souhaitez</br>
			retenir toutes les valeurs</br>
			du périmètre RTFE concerné;</br>
			</br>
			<i>Pas de limitation</i></br>
			indique que vous ne souhaitez</br>
			pas prendre en compte le</br>
			périmètre RTFE concerné.</div>
			</fieldset>
			</td>
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left width="25%"><b>Limitation à une application : </b></td>
			<td><html:select property="p_param9" styleClass="input">
				<option value="TOUS" SELECTED>Toutes</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixAppli" property="cle" labelProperty="libelle" />
			</html:select></td>
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left width="25%"><b>Limitation à un CAFI :</b></br>
			(les niveaux inférieurs sont pris en compte)</td>
			<td><html:select property="p_param10" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixCafi" property="cle" labelProperty="libelle" />
			</html:select></td>

		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left width="25%"><b>Limitation à un CA Payeur :</b></br>
			(les niveaux inférieurs sont pris en compte)</td>
			<td><html:select property="p_param11" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixCa_payeur" property="cle" labelProperty="libelle" />
			</html:select></td>

		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left width="25%"><b>Limitation à un CADA:</b></br>
			(les niveaux inférieurs sont pris en compte)</td>
			<td><html:select property="p_param12" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixCada" property="cle" labelProperty="libelle" />
			</html:select></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=right width="25%"><b>Extension du fichier :</b>&nbsp;</td>
			<td><select name="listeReports" class="input" onChange="return MAJTypeExtract(this.value)">
				<option value="1" SELECTED>.TXT</option>
				<option value="2">.CSV</option>
			</select></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan=3><html:submit value="Extraire" styleClass="input" /></td>
		</tr>
		</div>
		<!-- #BeginEditable "fin_form" -->
	</html:form>
	<!-- #EndEditable -->
</table>

<table>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
		<div align="center"><html:errors /><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>

</body>
</html:html>

