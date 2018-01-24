<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="java.util.Vector,org.owasp.esapi.ESAPI,java.util.*,org.owasp.esapi.ESAPI,java.sql.*,com.socgen.bip.commun.liste.ListeOption,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm"/>
<html:html locale="true">
<!-- #EndEditable --> 
<!-- eContratRF.jsp -->

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<bip:VerifUser page="jsp/eContratRF.jsp"/>
<%
	// FAD PPM 60955 : Ajout de la procédure pour alimenter la liste des rejets
	Hashtable hKeyList= new Hashtable();
	com.socgen.bip.commun.liste.ListeDynamique listeDynamique = new com.socgen.bip.commun.liste.ListeDynamique();
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;

	//Récupération du menu courant
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();

	//Récupération du PerimME
	Vector perimME = user.getPerim_ME();
	String perimme = "";
	for (int i = 0; i<= perimME.size() - 1; i++)
	{
		perimme = perimme + (String)perimME.get(i) + ",";
	}
	perimme = perimme.substring(0, perimme.length() - 1);

	//Récupération du Ventre_Frais
	String centre_frais = user.getListe_Centres_Frais();
	String id_traitement = "";
	
	try {
		hKeyList.put("userid", ""+user.getInfosUser());
		hKeyList.put("menuid", ""+menuId);
		hKeyList.put("perimme", ""+perimme);
		hKeyList.put("centre_frais", ""+centre_frais);
		java.util.ArrayList listR = listeDynamique.getListeDynamique("libelle_rejet_pac", hKeyList);
		id_traitement = ((com.socgen.bip.commun.liste.ListeOption)(listR.get(listR.size()-1))).getCle();
		listR.remove(listR.size()-1);
		pageContext.setAttribute("libellerejetpac", listR);
		
	} catch (Exception e) { 
		%>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
		System.err.println(e.toString());
	}
	// FAD PPM 60955 : Fin
%>

<!-- #BeginEditable "fichier" --> 
<script language="JavaScript" src="../js/function.cjs"></script>

<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<!-- FAD PPM 60955 : Appel du css de la liste des rejets -->
<link rel="stylesheet" href="../css/jqueryMultiSelectRejets.css" type="text/css" />

<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<!-- <link rel="stylesheet" href="../css/style_bip.css" type="text/css"> -->
<!-- FAD PPM 60955 : Appel du js de la liste des rejets -->
<script type="text/javascript" src="../js/jquery.js"></script>
<script type="text/javascript" src="../js/jquery.dimensions.js"></script>
<script type="text/javascript" src="../js/jqueryMultiSelectRejets.js"></script>
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
var blnVerifFormat  = true;
var tabVerif        = new Object();

var racine = "";
var avenant = "";

<%
	String sTitre="Recherche Contrat / Ressource / Facture";
	String sInitial;
	String sJobId="e_aecontrf";
	
%>

function MessageInitial()
{
	<%
	//sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
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
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	if (Focus != "") (eval( "document.editionForm."+Focus )).focus();
	else {
		document.editionForm.p_param7.focus();
	}
}


function verifier_Contrat_Critere()
{

if ( !(((document.forms[0].p_param7.value != "") && (document.forms[0].p_param9.value == "") && (document.forms[0].p_param11.value == "")) ||
	 ((document.forms[0].p_param7.value == "") && (document.forms[0].p_param9.value != "") && (document.forms[0].p_param11.value == "")) ||
	 ((document.forms[0].p_param7.value == "") && (document.forms[0].p_param9.value != "") && (document.forms[0].p_param11.value != "")) )
	)  {
	alert('Critères de recherches incohérents');
	return false;
	}
	else return true ;
	
}



function get_Contrat_RacineAvenantCommandePAC(str,critere)
{
	str = str.toUpperCase();
	if ((critere == "E") && (str.length = 13) && (str.indexOf('CW') == 0)) {
	racine = str;
	avenant = '0' + str.substr(11, 2);
	}
	else if ((critere == "E") && (str.length = 15) && ((str.indexOf('ATU-') == 0) || (str.indexOf('FOR-') == 0))) {
	racine = str.substr(0, 12);
	avenant = '0' + str.substr(13, 2);
	}
	else if ((critere == "E") && (str.length = 16) && (str.indexOf('ATG-') == 0)) {
	racine = str;
	avenant = '000';
	} else if ((critere == "P") && (str.length >= 4) && (str.length <= 13)) {
	if ((str.indexOf('ATU-') == 0) || (str.indexOf('FOR-') == 0)) {
		//racine = str ;
		//Dans le cas ou str.length est entre 4 est 13 alors str doit contenir les 12 pemiers caractéres  
		racine = str.substr(0, 12);
		avenant = '';	
	}
	else if ((str.indexOf('CW') == 0) || (str.indexOf('ATG-') == 0)) {
	racine = str ;
	avenant = '';	
	} 	
	}
	else if ((critere == "P") && (str.length == 14)) {
	if ((str.indexOf('ATU-') == 0) || (str.indexOf('FOR-') == 0)) {
	racine = str.substr(0, 12);
	avenant = '';
	}
	else if ((str.indexOf('ATG-') == 0)) {
	racine = str ;
	avenant = '';
	} 	
	}
	else if ((critere == "P") && (str.length == 15)) {
	if ((str.indexOf('ATU-') == 0) || (str.indexOf('FOR-') == 0)) {
	racine = str.substr(0, 12);
	avenant = '0' + str.substr(13, 2);
	}
	else if ((str.indexOf('ATG-') == 0)) {
	racine = str ;
	avenant = '';
	} 	
	}else if ((critere == "P") && (str.length == 16) && (str.indexOf('ATG-') == 0)) {
	racine = str;
	avenant = '000';
	}
	else if (critere == "C") {
	// C-critere1
	racine =  str ;
	avenant = '%';
	}
}

function verifier_Contrat_CommandePAC()
{
	if ( (document.forms[0].p_param6.value == "C") && (document.forms[0].p_param7.value.length >= 1) )  {
		//--------------------- CONTRAT CRITERE CONTIENT ---------------------/
		//-- critere1 --/
		get_Contrat_RacineAvenantCommandePAC(document.forms[0].p_param7.value, "C");
	}
	else if ((document.forms[0].p_param8.value == "C") && (document.forms[0].p_param9.value.length >= 1))
	{
		//--- critere2 ---/
		racine = document.forms[0].p_param9.value ;		

		if ((document.forms[0].p_param11.value == "")) {
			avenant = '';
		}
		else if (document.forms[0].p_param11.value != "") {
			//--- critere3 ---/
			if (document.forms[0].p_param10.value == "E") avenant = document.forms[0].p_param11.value ;
			else if (document.forms[0].p_param10.value == "P") avenant =  document.forms[0].p_param11.value  + '%';
			else if (document.forms[0].p_param10.value == "C") avenant =  '%'+ document.forms[0].p_param11.value  + '%';			
		}
	}
	else if ((document.forms[0].p_param6.value == "P"))
	{
		//---------------------------- CONTRAT CRITERE COMMENCE PAR ----------------------------/
		//--- critere1 ---/	
		
		if ((document.forms[0].p_param7.value.length >= 1) && (document.forms[0].p_param7.value.length <= 3))
		{
			racine =  document.forms[0].p_param7.value;
			avenant = "";
		}
		else if ((document.forms[0].p_param7.value.length >= 4) && (document.forms[0].p_param7.value.length <= 13))
		{
			if ((document.forms[0].p_param7.value.toUpperCase().indexOf('ATU-') == 0) || (document.forms[0].p_param7.value.toUpperCase().indexOf('FOR-') == 0) || (document.forms[0].p_param7.value.toUpperCase().indexOf('CW') == 0) || (document.forms[0].p_param7.value.toUpperCase().indexOf('ATG-') == 0))
			{
				get_Contrat_RacineAvenantCommandePAC(document.forms[0].p_param7.value, "P");
			}
			else {
				//--- critere1 P-4a13---/
				alert('Référence de dossier P@C impossible');
				document.forms[0].p_param7.focus();
				return false;
			}
		}
		else if ((document.forms[0].p_param7.value.length == 14)) {
			if ((document.forms[0].p_param7.value.toUpperCase().indexOf('ATU-') == 0) || (document.forms[0].p_param7.value.toUpperCase().indexOf('FOR-') == 0) || (document.forms[0].p_param7.value.toUpperCase().indexOf('ATG-') == 0))
			{
				get_Contrat_RacineAvenantCommandePAC(document.forms[0].p_param7.value, "P");
			}
			else {
				//--- critere1 P-14---/
				alert('Référence de dossier P@C impossible');
				document.forms[0].p_param7.focus();
				return false;
			}
		}
		else if ((document.forms[0].p_param7.value.length == 15)) {
			if ((document.forms[0].p_param7.value.toUpperCase().indexOf('ATU-') == 0) || (document.forms[0].p_param7.value.toUpperCase().indexOf('FOR-') == 0) || (document.forms[0].p_param7.value.toUpperCase().indexOf('ATG-') == 0))
			{
				get_Contrat_RacineAvenantCommandePAC(document.forms[0].p_param7.value, "P");
			}
			else {
				//--- critere1 P-15---/
				alert('Référence de dossier P@C impossible');
				document.forms[0].p_param7.focus();
				return false;
			}
		}
		else if ((document.forms[0].p_param7.value.length == 16)) {
			if (document.forms[0].p_param7.value.toUpperCase().indexOf('ATG-') == 0)
			{
				get_Contrat_RacineAvenantCommandePAC(document.forms[0].p_param7.value, "P");
			}
			else
			{
				//--- critere1 P-16---/
				alert('Référence de dossier P@C impossible');
				document.forms[0].p_param7.focus();
				return false;
			}
		}
		else if ((document.forms[0].p_param7.value.length > 16)) {
			//--- critere1 P>16---/
			alert('Référence de dossier P@C impossible');
			document.forms[0].p_param7.focus();
			return false;
		}
	}
	else if ((document.forms[0].p_param8.value == "P"))
	{
		racine = document.forms[0].p_param9.value ; 
		if (document.forms[0].p_param11.value == "") {
			//---critere2 P ---/
			avenant = "" ;
		} 
		else if (document.forms[0].p_param11.value != "")  
		{
			//---critere3  P ---/
			if (document.forms[0].p_param10.value == "E") {avenant = document.forms[0].p_param11.value ; }
			else if (document.forms[0].p_param10.value == "P") avenant = document.forms[0].p_param11.value ;
			else if (document.forms[0].p_param10.value == "C") avenant = document.forms[0].p_param11.value ;
		}
	}
	else if ((document.forms[0].p_param6.value == "E") && document.forms[0].p_param7.value != "")
	{
		//--------------------------- CONTRAT CRITERE EGAL COMMANDE PAC -----------------------/
		//--- critere1 E-1a12 ---/
		if ((document.forms[0].p_param7.value.length >= 1) && (document.forms[0].p_param7.value.length <= 12)) 
		{
			alert('Référence de dossier P@C impossible');
			document.forms[0].p_param7.focus();
			return false;
		} 
		else if ((document.forms[0].p_param7.value.length == 13)){
			//--- critere1 E-13 ---/
			if (document.forms[0].p_param7.value.toUpperCase().indexOf('CW') == 0) 
			{
				get_Contrat_RacineAvenantCommandePAC(document.forms[0].p_param7.value, "E");
			}
			else  
			{
				alert('Référence de dossier P@C impossible');
				document.forms[0].p_param7.focus();
			return false;
			}
		}
		else if ((document.forms[0].p_param7.value.length == 14)){
			//--- critere1 E-14 ---/
			alert('Référence de dossier P@C impossible');
			document.forms[0].p_param7.focus();
			return false;
		}
		else if ((document.forms[0].p_param7.value.length == 15)){
			//--- critere1 E-15 ---/
			if ((document.forms[0].p_param7.value.toUpperCase().indexOf('ATU-') == 0) || (document.forms[0].p_param7.value.toUpperCase().indexOf('FOR-') == 0)) 
			{
				get_Contrat_RacineAvenantCommandePAC(document.forms[0].p_param7.value, "E");
			}
			else  
			{
				alert('Référence de dossier P@C impossible');
				document.forms[0].p_param7.focus();
				return false;
			}
		} 
		else if ((document.forms[0].p_param7.value.length == 16)){
			//---- critere1 E-16 ---/
			if (document.forms[0].p_param7.value.toUpperCase().indexOf('ATG-') == 0) 
			{
				get_Contrat_RacineAvenantCommandePAC(document.forms[0].p_param7.value, "E");
			}
			else  
			{
				alert('Référence de dossier P@C impossible');
				document.forms[0].p_param7.focus();
				return false;
			}
		} 
		else if ((document.forms[0].p_param7.value.length > 16)){
			//--- critere1 E->16 ---/
			alert('Référence de dossier P@C impossible');
			document.forms[0].p_param7.focus();
			return false;
		}
	} 
	else if (document.forms[0].p_param8.value == "E" && document.forms[0].p_param9.value != "")
	{ 
		//-------------------------------- CONTRAT CRITERE EGAL --------------------------------/
		racine = document.forms[0].p_param9.value ; 
		if (document.forms[0].p_param11.value == "") {
			//---critere2 ---/
			avenant = "" ;
		} 
		else if (document.forms[0].p_param11.value != "")  
		{
			//---critere3  ---/
			if (document.forms[0].p_param10.value == "E") {avenant = document.forms[0].p_param11.value; }
			else if (document.forms[0].p_param10.value == "P") avenant = document.forms[0].p_param11.value  ; 
			else if (document.forms[0].p_param10.value == "C") avenant =  document.forms[0].p_param11.value ; 
		}
	}
	else
	{
		racine = document.forms[0].p_param9.value ;
		avenant = document.forms[0].p_param11.value ;
	}
	document.forms[0].p_param24.value = racine ;
	document.forms[0].p_param25.value = avenant ;

	return true;
}

function Verifier(form, action, mode, flag)
{
	blnVerification = flag;
	form.action.value = action;
	form.mode.value=mode;
}

function VerifierBlocContrat()
{
	if ((document.forms[0].p_param7.value == "") && (document.forms[0].p_param9.value == "") && (document.forms[0].p_param11.value == ""))
		return false;
	return true;
}

function VerifierBlocRessource()
{
	if ((document.forms[0].p_param13.value == "") && (document.forms[0].p_param15.value == "") && (document.forms[0].p_param17.value == "") && (document.forms[0].p_param19.value == ""))
		return false;
	return true;
}

function VerifierBlocFacture()
{
	if ((document.forms[0].p_param21.value == "") && (document.forms[0].p_param23.value == ""))
		return false;
	return true;
}

function ValiderEcran(form)
{
	// FAD PPM 60955 : Modification de la fonction pour implémenté la nouvelle règle de gestion relative à la liste des rejets
	var p26 = "";
	if (form.action.value != "annuler")
	{
		if (document.forms[0].p_param26.value == "")
		{
			if (form.p_param6.value != "E" || form.p_param7.value != "" || form.p_param8.value != "E" ||
					form.p_param9.value != "" || form.p_param10.value != "E" || form.p_param11.value != "" ||
					form.p_param12.value != "E" || form.p_param13.value != "" || form.p_param14.value != "E" ||
					form.p_param15.value != "" || form.p_param16.value != "E" || form.p_param17.value != "" ||
					form.p_param18.value != "E" || form.p_param19.value != "" || form.p_param20.value != "E" ||
					form.p_param21.value != "" || form.p_param22.value != "E" || form.p_param23.value != "")
			{
				if (!VerifierBlocContrat())
				{
					//verifier les autres blocs
					if (!VerifierBlocRessource())
					{
						if (!VerifierBlocFacture())
						{
							alert('Critères de recherches incohérents');
							return false;
						}
					}
					document.forms[0].p_param24.value = "" ;
					document.forms[0].p_param25.value = "" ;
				}
				else
				{
					if (!verifier_Contrat_Critere())
						return false;
		
					if (!verifier_Contrat_CommandePAC()){
						return false;
					}
				
				}		
				//QC 1675 : IGG doit être numérique
				if(document.forms[0].p_param15.value!="" && !isNumeric(document.forms[0].p_param15.value)){
					alert("Format incorrect du code IGG");
					return false;
				}
			}
			else
				return true;
		}
		else
		{
			if(form.p_param6.value != "E" || form.p_param7.value != "" || form.p_param8.value != "E" ||
				form.p_param9.value != "" || form.p_param10.value != "E" || form.p_param11.value != "" ||
				form.p_param12.value != "E" || form.p_param13.value != "" || form.p_param14.value != "E" ||
				form.p_param15.value != "" || form.p_param16.value != "E" || form.p_param17.value != "" ||
				form.p_param18.value != "E" || form.p_param19.value != "" || form.p_param20.value != "E" ||
				form.p_param21.value != "" || form.p_param22.value != "E" || form.p_param23.value != "")
			{
				alert('Critères de recherches incohérents');
				return false;	
			}
			p26 = form.p_param26.value;
			if (p26.substring(0,2) == "on")
				form.p_param26.value = "";
			return true;
		}
	}
	else
	{
		if( !(form.p_param6.value == "E" && form.p_param7.value == "" && 
				form.p_param8.value == "E" && form.p_param9.value == "" &&
				form.p_param10.value == "E" && form.p_param11.value == "" &&
				form.p_param12.value == "E" && form.p_param13.value == "" &&
				form.p_param14.value == "E" && form.p_param15.value == "" &&
				form.p_param16.value == "E" && form.p_param17.value == "" &&
				form.p_param18.value == "E" && form.p_param19.value == "" &&
				form.p_param20.value == "E" && form.p_param21.value == "" &&
				form.p_param22.value == "E" && form.p_param23.value == "" &&
				form.p_param26.value == "") )
		{
			form.p_param6.value = "E";
			form.p_param7.value = "";
			form.p_param8.value = "E";
			form.p_param9.value = "";
			form.p_param10.value = "E";
			form.p_param11.value = "";
			form.p_param12.value = "E";
			form.p_param13.value = "";
			form.p_param14.value = "E";
			form.p_param15.value = "";
			form.p_param16.value = "E";
			form.p_param17.value = "";
			form.p_param18.value = "E";
			form.p_param19.value = "";
			form.p_param20.value = "E";
			form.p_param21.value = "";
			form.p_param22.value = "E";
			form.p_param23.value = "";
			$('select[name="listeRejet"]').deSelectAll({
				noneSelected : 'Tous'
			});
			form.p_param26.value = "";
			return false;
		}
	}
	return true;
}
//QC 1675 : fonction pour vérifier si une valeur est numérique
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

// FAD PPM 60955 : Initialisation de la liste des rejets
$(document).ready(function() {
	MessageInitial();
	
	$('select[name="listeRejet"]').multiSelect({
		selectAll: true,
		selectAllText: 'Tout sélectionner',
		noneSelected: 'Tous',
		oneOrMoreSelected: '*'
	});
});
</script>
<!-- #EndEditable --> 


</head>



<!-- <body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();"> -->
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0">
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<!-- Menu Haut -->
		<tr > 
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
<!--         <tr> -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr>
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td> 
            
          </td>
        </tr>
        
        <!---------------------- Main Part ------------------------------->
        <tr>
          <td>
          <div id="content">
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/edition"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
		  	<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<input type="hidden" name="jobId" value="<%=sJobId%>">
			<input type="hidden" name="initial" value="<%= sInitial %>">			
			<input type="hidden" name=p_param24 value ="" >
			<input type="hidden" name=p_param25 value = "" >
			<!-- FAD PPM 60955 : Ajout d'une nouvelle variable qui comportera la liste des rejets à transmettre au rapport -->
			<input type="hidden" name=p_param26 value = "" >
			<input type="hidden" name=p_param27 value = "<%= id_traitement %>" >
			<!-- #EndEditable -->
            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center">
					
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<!---------------------- Main Part_2 ------------------------------->
					
						<tr>
	                    	<td colspan=4 align="center">&nbsp;</td>
	                    </tr>
	                    
	                    <!--  CONTRAT --------------------------------------->
						<tr  align="left">
							<td class="texteGras" >Contrat</td>	
							<td colspan="3"></td>
						</tr> 
					
						<tr  align="left">
							<td class="texte">&nbsp;</td>
							<td class="texte">Dossier de prestation P@C</td>
							<td><label> <span class="custom-dropdown custom-dropdown--white"> 
									<select class="custom-dropdown__select custom-dropdown__select--white" name="p_param6">
										<option value="E" SELECTED>égal à</option>
										<option value="P">commence par</option>
										<option value="C">contient</option>
									</select> </span> </label></td>
							<td align="right"><html:text property="p_param7" styleClass="input"  size="40" maxlength="20" onchange="return VerifFormat(this.name);"/></td>
						</tr> 
						
						<tr  align="left">
							<td class="texte">&nbsp;</td>
							<td class="texte">Référence de contrat</td>
							<td><label> <span class="custom-dropdown custom-dropdown--white"> 
									<select class="custom-dropdown__select custom-dropdown__select--white" name="p_param8">
										<option value="E" SELECTED>égal à</option>
										<option value="P">commence par</option>
										<option value="C">contient</option>
									</select> </span> </label></td>
							<td align="right"><html:text property="p_param9" styleClass="input"  size="40" maxlength="27" onchange="return VerifFormat(this.name);"/></td>
						</tr> 
					
						<tr  align="left">
							<td class="texte">&nbsp;</td>
							<td class="texte">Référence d'avenant</td>
							<td><label> <span class="custom-dropdown custom-dropdown--white"> 
									<select class="custom-dropdown__select custom-dropdown__select--white" name="p_param10">
										<option value="E" SELECTED>égal à</option>
										<option value="P">commence par</option>
										<option value="C">contient</option>
									</select> </span> </label></td>
							<td align="right"><html:text property="p_param11" styleClass="input"  size="40" maxlength="3" onchange="return VerifFormat(this.name);"/></td>
						</tr> 
						
						<!-- -------- RESSOURCE ------------------------------>
						<tr  align="left">
							<td class="texteGras" >Ressource</td>
							<td colspan="3"></td>
						</tr> 
					
						<tr  align="left">
							<td class="texte">&nbsp;</td>
							<td class="texte">Nom</td>
							<td><label> <span class="custom-dropdown custom-dropdown--white"> 
									<select class="custom-dropdown__select custom-dropdown__select--white" name="p_param12">
										<option value="E" SELECTED>égal à</option>
										<option value="P">commence par</option>
										<option value="C">contient</option>
									</select> </span> </label></td>
							<td align="right"><html:text property="p_param13" styleClass="input"  size="40" maxlength="30" onchange="return VerifFormat(this.name);"/></td>
						</tr> 
						
						<tr  align="left">
							<td class="texte">&nbsp;</td>
							<td class="texte">IGG</td>
							<td><label> <span class="custom-dropdown custom-dropdown--white"> 
									<select class="custom-dropdown__select custom-dropdown__select--white" name="p_param14">
										<option value="E" SELECTED>égal à</option>
										<option value="P">commence par</option>
										<option value="C">contient</option>
									</select> </span> </label></td>
							<td align="right"><html:text property="p_param15" styleClass="input"  size="40" maxlength="10" onchange="return VerifFormat(this.name);"/></td>
						</tr> 
					
						<tr  align="left">
							<td class="texte">&nbsp;</td>
							<td class="texte">Matricule Arpège</td>
							<td><label> <span class="custom-dropdown custom-dropdown--white"> 
									<select class="custom-dropdown__select custom-dropdown__select--white" name="p_param16">
										<option value="E" SELECTED>égal à</option>
										<option value="P">commence par</option>
										<option value="C">contient</option>
									</select> </span> </label></td>
							<td align="right"><html:text property="p_param17" styleClass="input"  size="40" maxlength="7" onchange="return VerifFormat(this.name);"/></td>
						</tr> 
						
						<tr  align="left">
							<td class="texte">&nbsp;</td>
							<td class="texte">Identifiant BIP</td>
							<td><label> <span class="custom-dropdown custom-dropdown--white"> 
									<select class="custom-dropdown__select custom-dropdown__select--white" name="p_param18">
										<option value="E" SELECTED>égal à</option>
										<option value="P">commence par</option>
										<option value="C">contient</option>
									</select> </span> </label></td>
							<td align="right"><html:text property="p_param19" styleClass="input"  size="40" maxlength="5" onchange="return VerifFormat(this.name);"/></td>
						</tr> 
						
						<!--  FACTURE ------------------>
						<tr  align="left" >
							<td class="texteGras">Facture</td>
							<td colspan="3"></td>
						</tr> 
					
						<tr  align="left">
							<td class="texte">&nbsp;</td>
							<td class="texte">Référence de la facture</td>
							<td><label> <span class="custom-dropdown custom-dropdown--white"> 
									<select class="custom-dropdown__select custom-dropdown__select--white" name="p_param20">
										<option value="E" SELECTED>égal à</option>
										<option value="P">commence par</option>
										<option value="C">contient</option>
									</select> </span> </label></td>
							<td align="right"><html:text property="p_param21" styleClass="input"  size="40" maxlength="15" onchange="return VerifFormat(this.name);"/></td>
						</tr> 
						
						<tr  align="left">
							<td class="texte">&nbsp;</td>
							<td class="texte">Référence de pièce Expense</td>
							<td><label> <span class="custom-dropdown custom-dropdown--white"> 
									<select class="custom-dropdown__select custom-dropdown__select--white" name="p_param22">
										<option value="E" SELECTED>égal à</option>
										<option value="P">commence par</option>
										<option value="C">contient</option>
									</select> </span> </label></td>
							<td align="right"><html:text property="p_param23" styleClass="input"  size="40" maxlength="8" onchange="return VerifFormat(this.name);"/></td>
						</tr>
						<!-- FAD PPM 60955 : Ajout de la liste des rejets -->
						<!--  REJET P@C ------------------>
						<tr  align="center"><td colspan=4 align="center">&nbsp;</td></tr>
						<tr  align="center"><td colspan=4 class="texteGras" align="center">OU</td></tr>
						<tr  align="center"><td colspan=4 align="center">&nbsp;</td></tr>
						
						<tr  align="left" >
							<td class="texteGras">Rejet P@C</td>
							<td colspan="3"></td>
						</tr> 
					
						<tr>
							<td class="texte">&nbsp;</td>
							<td align="left" class="texte">Motif de rejet</td>
							<td align="left" colspan="3"><!-- <label> <span class="custom-dropdown custom-dropdown--white"> -->
								<html:select property="listeRejet" multiple="true" size="1" styleClass="input">
									<html:options collection="libellerejetpac" property="cle" labelProperty="libelle"/>
								</html:select>
							<!-- </span> </label> -->
							</td>
						</tr>  
						
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>
				<tr> 
				  <td>&nbsp;</td>
				  
                  <td align="right">  
					<div align="right">
					<html:submit property="boutonCreer" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider',null, true);"/>
						</div></td>
				  <td>&nbsp;</td>
                  <td align="left">  
                  <div align="left">
				  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler',this.form.mode.value, false);"/>
                  </div>
                  </td>
                </tr>
			  </table>
	
					  <table>
					<!-- #EndEditable -->
			   		</table>
					</div>
                  </td>
                </tr>
				<tr> 
          		  <td>&nbsp;  
          		  </td>
        		</tr>
            </table>
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
			</div>
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

<!-- #EndTemplate -->