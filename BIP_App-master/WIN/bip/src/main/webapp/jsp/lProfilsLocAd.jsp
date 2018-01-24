<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<!-- #BeginEditable "imports" -->
<%@ page language="java"
	import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"
	errorPage="../jsp/erreur.jsp"%>
<jsp:useBean id="profilsLocalizeForm" scope="request"
	class="com.socgen.bip.form.ProfilsLocalizeForm" />
<%@page import="com.socgen.bip.form.ProfilsLocalizeForm"%>
<html:html locale="true">
<!-- #EndEditable -->
<!-- #BeginTemplate "/Templates/Page_maj.dwt" -->
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>
<!-- #BeginEditable "doctitle" -->
<title>Liste des Profils et dates d'effet</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/fmProfilsLocAd.jsp" />
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("selectprofillocalize",profilsLocalizeForm.getHParams()); 
	pageContext.setAttribute("choix1", list1);
	
	String filtre_ini =	profilsLocalizeForm.getFiltre_lst_localize();
	java.util.ArrayList list2 = new java.util.ArrayList();
	if (list1 != null && list1.size() != 0) {
		if(filtre_ini == null || "".equals(filtre_ini)){
			profilsLocalizeForm.getHParams().put("filtre_lst_localize", ""+((ListeOption)list1.get(0)).getCle());
		} else {
			profilsLocalizeForm.getHParams().put("filtre_localize", filtre_ini);
		}
		list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("detailsprofillocalize",profilsLocalizeForm.getHParams()); 	
	} else {
		list2 = new java.util.ArrayList();
	}
	
	pageContext.setAttribute("choix2", list2); 

	
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var rafraichiEnCours = false;

var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   if(blnVerification){
   
	   	var Message="<bean:write filter="false"  name="profilsLocalizeForm"  property="msgErreur" />";
	   	if(Message != "") {
	      	alert(Message);
	    }

	    if(document.forms[0].filtre_lst_localize.selectedIndex==-1){	    	
		 	document.forms[0].filtre_lst_localize.selectedIndex=0;
		 	document.forms[0].lst_date_effet.selectedIndex=-1;
		 	document.forms[0].filtre_lst_localize.focus();
		//	refresh(document.forms[0].filtre_lst_localize.options[document.forms[0].filtre_lst_localize.selectedIndex].value);
		 }
	}else{
			document.forms[0].filtre_lst_localize.selectedIndex=-1;
			document.forms[0].lst_date_effet.selectedIndex=-1;
	}
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value =action;
}

function ajaxMessageCheck(tmp) {
tmp = tmp.toString();
return (tmp.indexOf(' ') >= 0);
}


function EstProfilLocAffecteRessMensAnnee() {
	ajaxCallRemotePage('/profilslocalize.do?action=estProfilLocAffecteRessMensAnnee&filtre_localize=' +  document.forms[0].filtre_lst_localize.value + '&date_effet=' + document.forms[0].lst_date_effet.value);
	
	var respAjax = document.getElementById("ajaxResponse").innerHTML;
	var respAjaxSplit = '';
	var mesgRetour = '';
	var tmp = (document.getElementById("ajaxResponse").innerHTML);
	if (ajaxMessageCheck(tmp)) {
		respAjaxSplit = respAjax.split("\\n");
		for (var i = 0; i < respAjaxSplit.length; i++) {
			mesgRetour = mesgRetour + respAjaxSplit[i] + "\n\n";
		}
		if (confirm(mesgRetour)) {
			return true;
		} else {
			return false;
		}
	}
}

function ValiderEcran(form)
{	
   var index = form.filtre_lst_localize.selectedIndex;
   var index2 = form.lst_date_effet.selectedIndex;

   if (blnVerification) {
	 
	if (form.action.value != 'creer') {
	
	if (index2==-1) {
	   		alert("Choisissez une date effet");
	   		return false;
		}
	
	if (form.action.value == 'supprimer')
		{
			if(EstProfilLocAffecteRessMensAnnee())
			{
			return true;
			}
			else 
			{
			return false;
			}
		}

	}
   }
   
   return true;
}

function SetFocus()
{
document.forms[0].filtre_lst_localize.focus();
document.forms[0].lst_date_effet.selectedIndex=0;
}

function refresh(obj) {
		     	
 if(!rafraichiEnCours)
	       {
		     rafraichir(document.forms[0]); 
		     rafraichiEnCours = true;
		     
	       }
	
}

function SynchroniserTab()
{
	document.forms[0].lst_date_effet.selectedIndex=-1;
}

</script>


<!-- #EndEditable -->
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0"
	onLoad="MessageInitial(); SetFocus();">
	<div id="mainContainer">
	<div id="topContainer" style="min-height:98%;">
	<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
		<div style="display: none;" id="ajaxResponse"></div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
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
			<tr>
				<td background="../images/ligne.gif"></td>
			</tr>
			<tr>
				<td height="20" class="TitrePage">GESTION DES PROFILS Localisés
					: Liste des Profils et dates d'effet</td>
			</tr>
			<tr>
				<td background="../images/ligne.gif"></td>
			</tr>
		</table>

		<html:form action="/profilslocalize"
			onsubmit="return ValiderEcran(this);">
			<!-- #EndEditable -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="action" />
			<html:hidden property="mode" />
			<html:hidden property="arborescence" value="<%= arborescence %>" />
			<html:hidden property="filtre_date" />
			<html:hidden property="filtre_localize" />
			<html:hidden property="ecran_appel" value="initial" />

			<table cellspacing="2" cellpadding="2" class="tableBleu" border="0"
				width="50%" align="center">
				<tr>
					<td height='30'>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr align="center">
					<td class="lib"><b> <span
							STYLE="position: relative; z-index: 1; right: 326px">Profil
								Localisés:</span> <span
							STYLE="position: relative; z-index: 1; right: 280px">Libellé:</span>
					</b></td>
				</tr>
				<tr align="center">
					<td style="align: center; height: 25px;"><html:select
							property="filtre_lst_localize" styleClass="Multicol" size="5"
							onchange="refresh(this.form.filtre_lst_localize.options[this.form.filtre_lst_localize.selectedIndex].value);">

							<bip:options collection="choix1" />

						</html:select></td>
				</tr>
			</table>

			<table cellspacing="1" cellpadding="1" class="tableBleu" border="0"
				width="55%" align="center">
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td class="lib" align="center"><b> <span
							STYLE="position: relative; left: -148px; z-index: 1;">Date
								Effet</span> <span
							STYLE="position: relative; left: -120px; z-index: 1;">Actif
						</span> <span STYLE="position: relative; left: -97px; z-index: 1;">Coût
								FT</span> <span STYLE="position: relative; left: -59px; z-index: 1;">Coût
								ENV</span> <span STYLE="position: relative; left: -10px; z-index: 1;">Direction</span>
							<span STYLE="position: relative; left: 26px; z-index: 1;">Par
								défaut</span> <span STYLE="position: relative; left: 73px; z-index: 1;">Code
								Localisation</span> <span
							STYLE="position: relative; left: 90px; z-index: 1;">ES
								applicable</span>
					</b></td>
				</tr>
				<tr>
					<td style="align: center; height: 25px;" align="center"><html:select
							property="lst_date_effet" styleClass="Multicol" size="6"
							style="width:800px;">
							<bip:options collection="choix2" />
						</html:select></td>
				</tr>

				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>

			<table width="50%" border="0" align="center">

				<tr>

					<td align="left" width="20%"><html:submit
							property="boutonCreer" value="Cr&#233er" styleClass="input"
							onclick="Verifier(this.form, 'creer', true);" /></td>
					<td width="20%">&nbsp;</td>
					<td align="left" width="20%"><html:submit
							property="boutonModifier" value="Modifier" styleClass="input"
							onclick="Verifier(this.form, 'modifier', true);" /></td>
					<td width="20%">&nbsp;</td>
					<td align="left"><html:submit property="boutonSupprimer"
							value="Supprimer" styleClass="input"
							onclick="Verifier(this.form, 'supprimer', true);" /></td>
					<td width="20%">&nbsp;</td>
					<td width="20%" align="left"><html:submit
							property="boutonAnnuler" value="Annuler" styleClass="input"
							onclick="Verifier(this.form, 'annuler', false);" /></td>

				</tr>

			</table>

		</html:form>

		<table>
			<tr>
				<td><div align="center">
						<html:errors />
						<!-- #BeginEditable "barre_bas" -->
						<!-- #EndEditable -->
					</div></td>
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
