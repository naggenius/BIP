<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<!-- #BeginEditable "imports" -->

<%@ page language="java"
	import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Vector,com.socgen.bip.commun.BIPActionMapping,com.socgen.bip.commun.BipConstantes,com.socgen.bip.commun.form.BipForm,com.socgen.bip.log4j.BipUsersAppender,com.socgen.bip.user.UserBip,com.socgen.cap.fwk.ServiceManager,com.socgen.cap.fwk.log.Log"
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
<bip:VerifUser page="jsp/xStockImmoSCRef.jsp" />
<%
			com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip) session
			.getAttribute("UserBip");
	java.util.Hashtable hP = new java.util.Hashtable();
	java.util.Hashtable hP1 = new java.util.Hashtable();
	java.util.Hashtable hP2 = new java.util.Hashtable();
	String sLogCat = "BipUser";
	String ca_da = "";
	String ca_fi = "";
	Vector v = new Vector();

	v = userbip.getCADA();
	if ((v != null) && (!v.isEmpty())) {
		for (int i = 0; i < v.size(); i++) {
			ca_da += (String) v.elementAt(i);
			if (i != (v.size() - 1))
		ca_da += ",";
		}
	}

	if (!StringUtils.isEmpty(userbip.getCAFI())) {
		ca_fi = userbip.getCAFI();
	}

	hP.put("userid", userbip.getInfosUser());
	hP1.put("ca_payeur", ca_da);
	hP2.put("ca_payeur", ca_fi);

	java.util.ArrayList dossProj = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("dprojet_limitation_ref", hP);
	pageContext.setAttribute("choixDProjet", dossProj);

	java.util.ArrayList projet = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("projet_limitation_ref", hP);
	pageContext.setAttribute("choixProjet", projet);

	java.util.ArrayList liste = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("ca_utilisateur_rtfe_ref", hP1);
	pageContext.setAttribute("choixCA", liste);

	java.util.ArrayList liste2 = new com.socgen.bip.commun.liste.ListeDynamique()
			.getListeDynamique("ca_utilisateur_rtfe_ref", hP2);
	pageContext.setAttribute("choixCAFI", liste2);
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
		
		sJobId = "xStockImmoSCRef";
		
	
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

function Verifier(form, flag)
{
  blnVerification = flag;
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

<html:form action="/extract" onsubmit="return ValiderEcran(this);">
	<!-- #BeginEditable "debut_hidden" -->

	<html:hidden property="arborescence" value="<%= arborescence %>" />
	<input type="hidden" name="jobId" value="<%=sJobId%>">
	<input type="hidden" name="initial" value="<%= sInitial %>">
	<input type="hidden" name="pageAide" value="<%= sPageAide %>">
	<input type="hidden" name="p_param6" value=".CSV">
	<!-- #EndEditable -->
	<table width="80%" border="0" cellspacing="0" cellpadding="0" class="tableBleu" align="center">
		<tr>
			<td align="left"><b>Cette extraction prend en compte
			votre périmètre Dossier projet, projet, CAFI et CADA.
			</td>
		</tr> 
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
		<tr>
			<td align="left"><U>ATTENTION : cette extraction ne concerne que les immobilisations sans
			lien avec la comptabilité.</U>
			</td>
		</tr> 
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
		<tr>
			<td align="left">
			Vous pouvez limiter la demande aux éléments ci-dessous :
			</td>
		</tr>
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
	</table>


	<table border=0 class="tableBleu" width="90%" cellspacing="1" align="center"
		cellpadding="1">
		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		<tr>
			<td width="20%" class="lib" align=left><b>Limitation à un
			Dossier Projet :</b></td>
			<td width="50%"><html:select property="p_param7" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixDProjet" property="cle"
					labelProperty="libelle" />
			</html:select></td>
			<td align="center" width="30%" rowspan=7>
		<table>
			<tr>
				<td class="lib" width="200px" ><b>Explications sur les choix
				:</b><br>
				<br>
				<i>Tous ou Toutes</i><br>
				indique que vous souhaitez<br>
				retenir toutes les valeurs<br>
				du périmètre RTFE concerné;<br>
				<br>
				<i>Pas de limitation</i><br>
				indique que vous ne souhaitez<br>
				pas prendre en compte le<br>
				périmètre RTFE concerné.</td>
			</tr>
		</table>
		</td>
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left ><b>Limitation à un Projet :</b></td>
			<td ><html:select property="p_param8" styleClass="input" >
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixProjet" property="cle"
					labelProperty="libelle" />
			</html:select></td>
		
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left><b>Limitation à un CAFI :</b></br>
			(les niveaux inférieurs sont pris en compte)</td>
			<td><html:select property="p_param10" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixCAFI" property="cle"
					labelProperty="libelle" />
			</html:select></td>
			
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr>
			<td class="lib" align=left><b>Limitation à un CADA :</b></br>
			(les niveaux inférieurs sont pris en compte)</td>
			<td><html:select property="p_param11" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixCA" property="cle"
					labelProperty="libelle" />
			</html:select></td>
		</tr>
		<tr>
			<td colspan=3 align="center">&nbsp;</td>
		</tr>
		<tr>
				<td class="lib" align="left"><b>Extension du
				fichier :</b>&nbsp;</td>
				<td colspan=2><select name="listeReports" class="input"
					onChange="return MAJTypeExtract(this.value)">
					<option value="1">.TXT</option>
					<option value="2" SELECTED>.CSV</option>
				</select></td>
		</tr>
		<tr>
			<td colspan=3 align="center">&nbsp;</td>
		</tr>
	</table>
	<table border=0 class="tableBleu" width="90%" cellspacing="1" align="center"
		cellpadding="1">
		<tr>
			<td align="center">
			<html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, true);" />
			</td>
		</tr>
	</table>
</html:form>
<html:errors />

</body>
</html:html>
