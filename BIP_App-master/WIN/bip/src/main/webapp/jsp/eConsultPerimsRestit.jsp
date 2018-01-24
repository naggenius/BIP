<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<!-- #BeginEditable "imports" -->
<%@ page language="java"
	import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"
	errorPage="../jsp/erreur.jsp"%>
<jsp:useBean id="consultPerimsRestitForm" scope="request"
	class="com.socgen.bip.form.ConsultPerimsRestitForm" />
<jsp:useBean id="listeRechercheId" scope="session" class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true">
<!-- #EndEditable -->

<!-- #BeginTemplate "/Templates/Page_edition.dwt" -->
<head>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>

<!-- #BeginEditable "doctitle" -->
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->

<bip:VerifUser page="/perimsRestit.do" />

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<STYLE TYPE="text/css">
ul {
margin-top: 0px;
}

</STYLE>
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

	
    int nbligne = 0;
   
%>
var pageAide = "<%= sPageAide %>";
var blnVerifFormat  = true;
var tabVerif        = new Object();


function MessageInitial()
{
	
    tabVerif["codeRestit"] = "VerifierAlphaMax(document.forms[0].codeRestit)";
    tabVerif["matRess"] = "VerifierAlphaMax(document.forms[0].matRess)";
    
	var Message="<bean:write filter="false"  name="consultPerimsRestitForm"  property="msgErreur" />";
	var Focus = "<bean:write name="consultPerimsRestitForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
	if(form.codeRestit.value=="" && form.matRess.value=="" && form.datedeb.value=="" && form.heuredeb.value=="" && form.datefin.value=="" && form.heurefin.value==""){
		alert("Vous devez renseigner au moins un critère");
		return false;
	}
	
	if(form.heuredeb.value!="" && form.datedeb.value==""){
		alert("Si vous entrez une heure de début, vous devez également saisir une date de début");
		return false;
	}
	
	if(form.heurefin.value!="" && form.datefin.value==""){
		alert("Si vous entrez une heure de fin, vous devez également saisir une date de fin");
		return false;
	}
	return true;
}

function clicMenu(num) { 

  // Booléen reconnaissant le navigateur (vu en partie 2)
  isIE = (document.all) 
  isNN6 = (!isIE) && (document.getElementById)

  // Compatibilité : l'objet menu est détecté selon le navigateur
  if (isIE) menu = document.all['description' + num];
  if (isNN6) menu = document.getElementById('description' + num);

  // On ouvre ou ferme
  if (menu.style.display == "none"){
    // Cas ou le tableau est caché
    menu.style.display = ""
  } else {
    // On le cache
    menu.style.display = "none"
   }
}


//Insertion du code permettant de verifier l'heure
function isNumeric(sText)
{
	var ValidChars = "0123456789";
	var IsNumber=true;
	var Char;
	
	for (i = 0; i < sText.length && IsNumber == true; i++)
	{
	Char = sText.charAt(i);
	if (ValidChars.indexOf(Char) == -1)
	{
	IsNumber = false;
	}
	}
	return IsNumber;
}

function verifierTime(heure)
{
	var IsTime = true;
	if (heure.value.length==5)
	{
		var Hrs = (isNumeric(heure.value.substring(0,2)) ? heure.value.substring(0,2) : -1);
		var Mins = (isNumeric(heure.value.substring(3,5)) ? heure.value.substring(3,5) : -1);
		
		if ( Hrs>=0 && Hrs<24 && Mins>=0 && Mins<60 && (heure.value.toLowerCase().substring(2,3)==":")){
			IsTime = true;
		}
		else{
			heure.value = "";
			IsTime = false;
		}
	}
	else
		if(heure.value.length==0){
			IsTime = true;
			}
		else
			{
			IsTime = false;
			heure.value = "";
			}
	
	
	if (!IsTime)
		alert ("Heure invalide (HH:mm)");
		
		return IsTime;
}
</script>
<!-- #EndEditable -->


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
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
				<td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Consultation des
				Perimètres des Restitutions<!-- #EndEditable --></td>
			</tr>
			<tr>
				<td background="../images/ligne.gif"></td>
			</tr>
			<tr>
				<td></td>
			</tr>
			<tr>
				<td><!-- #BeginEditable "debut_form" --> <html:form action="/perimsRestit"
					onsubmit="return ValiderEcran(this);">
					<!-- #EndEditable -->
					<!-- #BeginEditable "debut_hidden" -->
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					<html:hidden property="action" />
					<html:hidden property="mode" />
					<html:hidden property="arborescence" value="<%= arborescence %>"/>
					<html:hidden property="page" value="modifier" />
					<input type="hidden" name="index" value="modifier">
					<!-- #EndEditable -->
					<table width="100%" border="0">

						<tr>
							<td>
							<div align="center">
							<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
								<!-- #BeginEditable "contenu" -->

								<tr>
									<td colspan=5 align="center">&nbsp;</td>
								</tr>

								<tr>
									<td colspan=5 align="left"><b>Veuillez selectionner un ou plusieurs critères </b></td>
								</tr>

								<tr>
									<td colspan=5 align="center">&nbsp;</td>
								</tr>
								<tr>
									<td class="lib">Code de la restitution :</td>
									<td><html:text styleClass="input" property="codeRestit" maxlength="10" size="20"
										onchange="return  VerifierAlphaMax(this);" /></td>
									<td>&nbsp;</td>
									<td class="lib">Matricule de la ressource :</td>
									<td><html:text styleClass="input" property="matRess" maxlength="7" size="7"
										onchange="return  VerifierAlphaMax(this);" /></td>
								</tr>
								<tr>
									<td class="lib">Date de début (JJ/MM/AAAA) :</td>
									<td><html:text styleClass="input" property="datedeb" maxlength="10" size="10"
										onchange="return VerifierDate(this,'jj/mm/aaaa');" /></td>
									<td>&nbsp;</td>
									<td class="lib">Heure de début (HH:mm) :</td>
									<td><html:text styleClass="input" property="heuredeb" maxlength="5" size="5"
										onchange="return verifierTime(this);" /></td>
								</tr>
								<tr>
									<td class="lib">Date de fin (JJ/MM/AAAA) :</td>
									<td><html:text styleClass="input" property="datefin" maxlength="10" size="10"
										onchange="return VerifierDate(this,'jj/mm/aaaa');" /></td>
									<td>&nbsp;</td>
									<td class="lib">Heure de fin (HH:mm) :</td>
									<td><html:text styleClass="input" property="heurefin" maxlength="5" size="5"
										onchange="return verifierTime(this);" /></td>
								</tr>
							</table>
							<table>
								<!-- #EndEditable -->
							</table>
							</div>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>
							<div align="center"><html:submit property="boutonConsulter" value="Rechercher"
								styleClass="input" onclick="Verifier(this.form, 'refresh',this.form.mode.value,true);" /></div>
							</td>
						</tr>

					</table>

					<!-- YNI  -->

					<%
					if (listeRechercheId.size() >= 100) {
					%>
					<tr>
						<td class="libNoBackGround"><b>
						<center>Veuillez affiner votre recherche</center>
						</b></td>
					</tr>

					<%
					} else {
					%>

					<table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="90%" align="center">
						<tr>
							<td COLSPAN="5">&nbsp;</td>
						</tr>
						<tr align="center">
							<td class="lib"><b>Matricule</b></td>
							<td class="lib"><b>Nom Prenom</b></td>
							<td class="lib"><b>Extraction</b></td>
							<td class="lib"><b>Date (JJ/MM/AAAA HH:mm)</b></td>
							<td>&nbsp;</td>
						</tr>
						<%
								int i = 0;
								String[] strTabCols = new String[] { "fond1", "fond2" };
						%>


						<logic:iterate id="element" name="listeRechercheId"
							type="com.socgen.bip.metier.ConsultPerimsRestit" indexId="index">
							<%
										if (i == 0)
										i = 1;
									else
										i = 0;
									nbligne++;
							%>
							<tr class="contenu" align="center">
								<td class="<%= strTabCols[i] %>"><bean:write name="element" property="matricule" /></td>
								<td class="<%= strTabCols[i] %>"><bean:write name="element" property="nom" /> - <bean:write
									name="element" property="prenom" /></td>
								<td class="<%= strTabCols[i] %>"><bean:write name="element" property="extraction" /></td>
								<td class="<%= strTabCols[i] %>"><bean:write name="element" property="date" /></td>
								<td class="<%= strTabCols[i] %>"><IMG SRC="../images/zoom_in.gif"
									ALT="Afficher les paramètres"
									onClick="clicMenu(<%= nbligne %>);if(this.src.substring(this.src.lastIndexOf('/'))=='/zoom_in.gif'){this.src='../images/zoom_out.gif'}else {this.src='../images/zoom_in.gif'};">
								</td>
							</tr>
							<tr style="display:none" id="description<%= nbligne %>" class="contenu">
								<td colspan="5">
								<table width="100%" class="tableBleu" border="1px" BORDERCOLOR="black" cellspacing="0"
									cellpadding="2" style="border-collapse:collapse;">
									<tr>
										<td colspan="2" align="center">Ident : <b> <bean:write name="element"
											property="ident" filter="false" /></b> - nom du RDF: <b> <bean:write name="element"
											property="nom_rdf" filter="false" /></b> - JobId: <b> <bean:write name="element"
											property="jobid" filter="false" /></b> - Menu utilisé: <b> <bean:write name="element"
											property="menutil" filter="false" /></b></td>
									</tr>

									<tr>
										<td width="50%" style="vertical-align:top;">Périmètre RTFE utilisateur :
										<ul>
											<li>Perim ME :<b> <bean:write name="element" property="perim_me" filter="false" /></b></li>
											<li>Perim MO :<b> <bean:write name="element" property="perim_mo" filter="false" /></b></li>
											<li>Perim MCLI :<b> <bean:write name="element" property="perim_mcli" filter="false" /></b></li>
											<li>Dossier projet :<b> <bean:write name="element" property="doss_proj"
												filter="false" /></b></li>
											<li>Projets :<b> <bean:write name="element" property="projet" filter="false" /></b></li>
											<li>Applications :<b> <bean:write name="element" property="appli" filter="false" /></b></li>
											<li>CA de FI :<b> <bean:write name="element" property="ca_fi" filter="false" /></b></li>
											<li>CA Payeurs :<b> <bean:write name="element" property="ca_payeur"
												filter="false" /></b></li>
											<li>CADA :<b> <bean:write name="element" property="ca_da" filter="false" /></b></li>
										</ul>
										</td>
										<td width="50%" style="vertical-align:top;">Filtres sélectionnés : <bean:write
											name="element" property="filtres" filter="false" /></td>
									</tr>
								</table>
								</td>
							</tr>
						</logic:iterate>
					</table>
					<%
					}
					%>

					<!-- #BeginEditable "fin_form" -->
				</html:form> <!-- #EndEditable --></td>
			</tr>

			<tr>
				<td>
				<div align="center"><html:errors /><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
				</td>
			</tr>

		</table>
		</td>
	</tr>
</table>
</body>
</html:html>
<%
	Integer id_webo_page = new Integer("1003");
	com.socgen.bip.commun.form.AutomateForm formWebo = consultPerimsRestitForm;
%>
<%@ include file="/incWebo.jsp"%>
<!-- #EndTemplate -->
