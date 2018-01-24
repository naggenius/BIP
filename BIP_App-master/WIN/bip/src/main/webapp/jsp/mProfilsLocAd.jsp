<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.text.SimpleDateFormat,java.util.Locale" errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="profilsLocalizeForm" scope="request" class="com.socgen.bip.form.ProfilsLocalizeForm" />
<%@page import="com.socgen.bip.commun.form.BipForm"%>
<%@page import="com.socgen.bip.form.ProfilsLocalizeForm"%>
<html:html locale="true" xhtml="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

 <!-- #BeginEditable "doctitle" --> 
<title>GESTION DES PROFILS LOCALILZE : CREATION/MODIFICATION</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmProfilsLocAd.jsp"/> 
<%
	// On récupère la liste des top actif FI
    java.util.ArrayList choixTopActif = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topActif_Localize"); 
    pageContext.setAttribute("choixTopActif", choixTopActif);
    
 	// Récupèration de la liste profil par défaut
    java.util.ArrayList choixProfilParDefaut = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("profilParDefaut"); 
    pageContext.setAttribute("choixProfilParDefaut", choixProfilParDefaut);
    	
    if(profilsLocalizeForm.getTitrePage() != null && profilsLocalizeForm.getTitrePage().equals("Modifier")) {
		profilsLocalizeForm.setTitrePage("MODIFICATION");
	}
    else if(profilsLocalizeForm.getTitrePage() != null && profilsLocalizeForm.getTitrePage().equals("Supprimer")) {
		profilsLocalizeForm.setTitrePage("SUPPRESSION");
	}
    else {
		profilsLocalizeForm.setTitrePage("CREATION");
	}
%>

<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript"><!-- -->
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
var OnSubmitCheck = '';
var tmpes = '';
var tmplocal = '';
var envDate = 2017;


function TraitementInitial()
{
if(document.forms[0].mode.value === 'update') {
	tmplocal = document.forms[0].codelocal.value;
	tmpes = document.forms[0].code_es.value;
}
	// Si le mode est « modifier 
   if(document.forms[0].mode.value =="update") {
	   // Focus sur le champ Force de travail.
	   document.forms[0].force_travail.focus();
   }
   else if (document.forms[0].mode.value !="delete") {
		// Si le champ libellé est vide (création d'une 1ère date d'effet pour le profil Localize)
		if (document.forms[0].libelle.value == "") {
			// Focus sur le champ libellé
			document.forms[0].libelle.focus();
		}
		else {
			// Si le champ date d'effet est vide
			if (document.forms[0].date_effet.value == "") {
				// Focus sur le champ date d'effet
				document.forms[0].date_effet.focus();
			}
			else {
				// Champ Coût unitaire de travail
				document.forms[0].force_travail.focus();
				document.forms[0].frais_environnement.focus();
			}
		}
   }
   var Message="<bean:write filter="false"  name="profilsLocalizeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="profilsLocalizeForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if(document.forms[0].mode.value =="update")
   {
     document.forms[0].force_travail.focus();
	 //document.forms[0].frais_environnement.focus();
   }
	if(document.forms[0].mode.value =="insert")
   {
   	 if(document.forms[0].libelle.value ==""){
     document.forms[0].libelle.focus();
     } else {
	 
	 if(document.forms[0].date_effet.value=="" )
	 {
		document.forms[0].date_effet.focus();
		
     }
	 else
	 {
     	if(document.forms[0].force_travail.value=="" || document.forms[0].frais_environnement.value=="" )
	 {
		document.forms[0].force_travail.focus();
		
     }
	 }
   }
}

if(document.forms[0].mode.value !="delete")
{
if(document.forms[0].profil_defaut[1].checked)
	{
	document.forms[0].code_es.disabled = false; 
	document.forms[0].codelocal.disabled = false;
	}
else
	{
	document.forms[0].code_es.disabled = true;
	document.forms[0].codelocal.disabled = true;
	}
}
}

function Verifier(form, action, mode, flag)
{
	if(action == "valider" && mode=="delete") {
		return ValiderSupprimer(form, action, mode, flag);
	}
	//document.forms[0].date_effet.value = null;
  	blnVerification = flag;
  	form.action.value =action;
}

function ValiderSupprimer(form, action, mode, flag) {
	if (EstProfilAffecteRessMensAnnee()) {
		blnVerification = flag;
		form.action.value =action;
	} else {
		return false;
	}
	return true;
}

function EstProfilAffecteRessMensAnnee() {
	if (document.forms[0].filtre_lst_localize.value != null && document.forms[0].filtre_lst_localize.value != '') {
		ajaxCallRemotePage('/profilslocalize.do?action=estProfilLocAffecteRessMensAnnee&filtre_localize=' + document.forms[0].filtre_lst_localize.value + '&date_effet=' + document.forms[0].lst_date_effet.value);
	} else {
		ajaxCallRemotePage('/profilslocalize.do?action=estProfilLocAffecteRessMensAnnee&filtre_localize=' + document.forms[0].filtre_localize.value + '&date_effet=' + document.forms[0].date_effet.value);
	}
	var respAjax = document.getElementById("ajaxResponse").innerHTML;
	var respAjaxSplit = '';
	var mesgRetour = '';
	if (document.getElementById("ajaxResponse").innerHTML != '') {
		respAjaxSplit = respAjax.split("\\n");
		for (var i = 0; i < respAjaxSplit.length; i++) {
			mesgRetour = mesgRetour + respAjaxSplit[i] + "\n\n";
		}
		if (confirm(mesgRetour)) {
			return true;
		} else {
			document.profilsLocalizeForm.filtre_localize.focus();
			return false;
		}
	}
}

function VerifAlphaMaxCar_profil_Lib( EF, champTest )
{
   
   var Accents = 'àâäçéèêëîïôöùûüÂÄÊËÈÀÇÉÎÏÔÖÙÛÜ$";&(@)*!:,"?§/<>+.~#-_{$%+[|`\\^]}=°¤£µ¨\'';
   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Champ "+champTest+" : évitez les caractères spéciaux");
	   EF.focus();
	   return false;
	}
	
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   EF.value=EF.value.toUpperCase();
   return true;
}

function VerifierDateSpec( EF, formatDate)
{
   var Accents = 'àâäçéèêëîïôöùûüÂÄÊËÈÀÇÉÎÏÔÖÙÛÜ$"; &(@)!:?§/<>+.~#{[|`\\^]}=°¤£µ¨\''

   var Champ = "";
   var Caractere;
   var caretoile = "*";

	if(EF.value.indexOf(caretoile) == 0 && EF.value.length != 1){
	   alert( "Date invalide (format "+formatDate+")");
	   EF.focus();
	   return false;	   
	}
	   
	if(EF.value.indexOf(caretoile) > 0){
	
	  alert( "Date invalide (format "+formatDate+")");
	   EF.focus();
	   return false;
	   
	}else{
		  
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	LaChaine = EF.value.charAt(Cpt);

	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Date invalide (format "+formatDate+")");
	   EF.focus();
	   return false;

	} 
    }

	} // end if global
   return true;
   
}

function ValiderEcran(form)
{
	/**
	-	Vérifier que les champs obligatoires sont remplis en utilisant la fonction JS ChampObligatoire (function.cjs)
	o	libellé
	o	date d'effet
	o	top actif
	o	Force de travail
	o	Frais d'environnement
	o	Direction Bip
	o	Codes ES (si Profil par défaut = « NON »)
	
	-	Si tous les champs obligatoires sont saisis, alimenter la propriété « action » du formulaire à la valeur choix
	**/
  if (blnVerification == true) {
  	  
	  
     if (form.libelle && !ChampObligatoire(form.libelle, "le libellé")) return false;
     if(!(VerifAlphaMaxCar_profil_Lib(document.forms[0].libelle,'libelle'))) return false;
     if (form.date_effet && !ChampObligatoire(form.date_effet, "la date effet")) return false;
     if(!(VerifierDateSpec(document.forms[0].date_effet,'AAAA'))) {
     	document.forms[0].elements[11].focus();
     	return false;
     }
	 if (!VerifierDateEffet(document.forms[0].date_effet)) return false;
     if (form.force_travail && !ChampObligatoire(form.force_travail, "le coût unitaire HTR force de travail")) return false;
     if(!(VerifierCout(document.forms[0].force_travail,12,2))) return false;
     if (form.frais_environnement && !ChampObligatoire(form.frais_environnement, "le coût unitaire HTR frais d'environnement")) return false;
     if(!(VerifierCout(document.forms[0].frais_environnement,12,2))) return false;
     if(!(VerifAlphaMaxCar_profil_Comm(document.forms[0].commentaire,'commentaire')))  return false;
     if (form.coddir && !ChampObligatoire(form.coddir, "le code direction")) return false;
	 	 if(!isValidCodeDir()) { return false;} 
	 if(form.profil_defaut[1].checked==true)
	 {
	 
	 if (form.codelocal && !ChampObligatoire(form.codelocal, "le code localisation")) 
	      {
		  return false;
		  }
	 if (form.code_es && !ChampObligatoire(form.code_es, "le code ES")) 
	      {

		  return false;
		  }
		  
	if(document.forms[0].code_es.value !== '*') {
	 if(!isValidCodeEs()) { 
	 return false;
	 } 
	 }
		  
	 }
	 
		  
	 
	 
	

	//test l'unicite du triplet (date_effet,coddir,profil_defaut) si profil_defaut est a OUI.

	for (var i = 0; i < form.profil_defaut.length; i++) {
        var button = form.profil_defaut[i];
        if (button.checked) {
	//si UPDATE , ignorer le test sur le profil en cours
		   if(document.forms[0].mode.value =="update")
		   {
		   if(!NotExistsProfilDefautMaj(document.forms[0].date_effet.value, document.forms[0].coddir.value, button))
			{
				return false; 
			}
		   }
		   else
		   {
			if(!NotExistsProfilDefaut(document.forms[0].date_effet.value, document.forms[0].coddir.value, button))
			{
				return false; 
			}
		   }
			
        }
		}


		
	if(!NotExistsProfilLocalizeList()) 
		{ 
			return false;
		}
		

  }
     tmpes = '';
	 tmplocal = '';
   return true;
}

//Appel en ajaxx pour regarder si le code direction existe déjà
function isValidCodeDir()
{
	var coddir;
	
	coddir = document.forms[0].coddir.value;
	if(!TraitementAjax('isValidCodeDir', '&coddir=' + coddir, 'coddir'))
	{
  	document.forms[0].elements[17].focus();
	return false ;
	}
	return true;
}

//Appel en ajaxx pour regarder si le code ES existe déjà
function isValidCodeEs()
{
	var code_es;
	
	code_es = document.forms[0].code_es.value;
	
	// Si la valeur du champ champProfilDefaut est « N »
	if(document.forms[0].profil_defaut[1].checked)
	{
		if(!TraitementAjax('isValidCodeEs', '&code_es=' + code_es, 'code_es'))
		{
		document.forms[0].elements[21].focus();
		return false;
		}
	}
	else
	{
		document.forms[0].code_es.value = ""; 
	}
	return true;
}

function eslocStore(tmpValue, tmpCode) {
	if(tmpValue !== '' || tmpValue !== null) { 
	if(tmpCode === 'loc') {
		tmplocal = tmpValue;
	}
	else {
		tmpes = tmpValue;
	}
	}
}


function NotExistsProfilDefaut(date_effet, coddir, champProfilDefaut) {
if(tmpes === '' || tmplocal === '') {
	tmpes = document.forms[0].code_es.value;
	 tmplocal = document.forms[0].codelocal.value;
}
	
	// Si la valeur du champ champProfilDefaut est « O »
	if (champProfilDefaut.value == "O") {
		// Faire un appel ajax de la méthode pMethode de l'action profilslocalize.do
		// Si la réponse ajax est non vide
		if (! TraitementAjax('notExistsProfilDefaut', '&date_effet=' + date_effet + '&coddir=' + coddir, champProfilDefaut)) {
			// Positionnement du bouton radio champProfilDefaut à « NON » (value= 'N')
			document.forms[0].profil_defaut[1].checked = true;
			document.forms[0].code_es.disabled = false;
			document.forms[0].codelocal.disabled = false;
			return false;
		}
		else {
			// Vidage du champ Code ES applicable
			document.forms[0].code_es.value = ""; 
			document.forms[0].codelocal.value = ""; 
			return true;
		}
	} else {
			document.forms[0].code_es.value = tmpes; 
			document.forms[0].codelocal.value = tmplocal;
	}

	return true;
}

function NotExistsProfilDefautMaj(date_effet, coddir, champProfilDefaut) {

	var p_localize;
	
	if(document.forms[0].filtre_lst_localize.value==null || document.forms[0].filtre_lst_localize.value=="" )
		{
		p_localize=document.forms[0].filtre_localize.value;
		}
		else
		{
		p_localize=document.forms[0].filtre_lst_localize.value;
		}
	if(tmpes === '' || tmplocal === '') {
	tmpes = document.forms[0].code_es.value;
	 tmplocal = document.forms[0].codelocal.value;
}
	// Si la valeur du champ champProfilDefaut est « O »
	if (champProfilDefaut.value == "O") {
		// Faire un appel ajax de la méthode pMethode de l'action profilslocalize.do
		// Si la réponse ajax est non vide
		if (! TraitementAjax('notExistsProfilDefautMaj', '&filtre_localize=' + p_localize +'&date_effet=' + date_effet + '&coddir=' + coddir, champProfilDefaut)) {
			// Positionnement du bouton radio champProfilDefaut à « NON » (value= 'N')
			document.forms[0].profil_defaut[1].checked = true;
			document.forms[0].code_es.disabled = false;
			document.forms[0].codelocal.disabled = false;
			return false;
		}
		else {
			// Vidage du champ Code ES applicable
			document.forms[0].code_es.value = ""; 
			document.forms[0].codelocal.value = ""; 
			return true;
		}
	}else {
			document.forms[0].code_es.value = tmpes; 
			document.forms[0].codelocal.value = tmplocal;
	}

	return true;
}

/**
 * Appel ajax
 * Si la réponse est non vide :
 * - Affichage du message d'erreur
 * - Focus sur le champ en erreur
 */
function TraitementAjax(pMethode, pParams, pFocus) {
	
	// Appel ajax de la méthode pMethode de l'action profilslocalize.do
	ajaxCallRemotePage('/profilslocalize.do?action=' + pMethode + pParams);
	var tmp = (document.getElementById("ajaxResponse").innerHTML);
	// Si la réponse ajax est non vide :
	if (ajaxMessageCheck(tmp)) {
		// Affichage d'une popup avec le contenu de la réponse
		alert(document.getElementById("ajaxResponse").innerHTML);
		// Focus sur le champ
		if(pFocus.name =='profil_defaut')
		{
		pFocus.focus();
		}
		else
		{
		OnSubmitCheck = pFocus;
		}
		
		return false;
	}
	return true;
}

function ajaxMessageCheck(tmp) {
tmp = tmp.toString();
return (tmp.indexOf(' ') >= 0);
}

/**
 * Appel de la méthode notExistsProfillocalize en ajax
 */
function NotExistsProfilLocalize() {
			

	if (document.forms[0].mode.value != "delete") {
		return TraitementAjax('notExistsProfilLocalize', '&filtre_localize=' + document.forms[0].filtre_localize.value + '&date_effet=' + document.forms[0].date_effet.value, "date_effet");
	}
	else {
		return true;
	}		
			
		
	
}

/**
 * Appel de la méthode notExistsProfillocalize en ajax
 */
function NotExistsProfilLocalizeList() {


	if(document.forms[0].mode.value =="insert")
	{
	return TraitementAjax('notExistsProfilLocalize', 
			'&filtre_lst_localize=' 
			+ document.forms[0].filtre_lst_localize.value 
			+ '&date_effet=' 
			+ document.forms[0].date_effet.value, 
			"date_effet");
	}
	
	return true;
	
}

/**
 * Appel de la méthode ExistsProfilFi en ajax
 */
function ExistsProfilFi() {

	if (TraitementAjax('existsProfilFI', '&filtre_localize=' + document.forms[0].filtre_localize.value, 'filtre_localize') == false) {
		return false;
	}
	return true;
}

/**
 * Vérification de la date d'effet
 */
function VerifierDateEffet(pChamp) {

	aaaa = parseInt(pChamp.value, 10);
	// Si champ vide, aucune vérification à effectuer
	if (pChamp.value != '') {
	
	  if (isNaN(aaaa) == true) {

			alert( "Date invalide (format AAAA)" );
			pChamp.focus();
			return false;

		}
   else if (aaaa < envDate) {
		// affichage d'une popup contenant le message « Année invalide : AAAA >= 2014 »
		alert( "Année invalide : AAAA <= "+ envDate);
		pChamp.focus();
		return false;
	}

	// Vérification que le champ pChamp est un entier postérieure ou égale à 2014
	// Si OK
   if (EstDateEffetValide(pChamp)) {
	   // Vérification de non existence du profil localize (pour le couple code profil, date effet saisis)
	   if(document.forms[0].filtre_localize && document.forms[0].mode.value =="insert")
	   {
			if(!NotExistsProfilLocalize())
			{
			return false;
			}
	   }
			else
	   {
			if(!NotExistsProfilLocalizeList())
			{
			return false;
			}
	   }
   }
   else
   {
   pChamp.focus();
   }
   }
   return true;
}

/**
 * Vérification que la date d'effet est un entier >= 2014
 */
function EstDateEffetValide(pChamp) {
	aaaa = parseInt(pChamp.value, 10);

		if (isNaN(aaaa) == true) {

			alert( "Date invalide (format AAAA)" );
			return false;

		}

	
	else if (aaaa < envDate) {
		// affichage d'une popup contenant le message « Année invalide : AAAA >= 2014 »
		alert( "Année invalide : AAAA >= "+envDate );
		pChamp.focus();
		return false;
	}

		return true;
}



function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function esValidCheck(evt) {
 evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if(!(charCode === 42)) {
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    }
    return true;
}

</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="TraitementInitial();">
<div id="mainContainer">
	<div id="topContainer" style="min-height:98%; " align="center" >
	<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<div style="display:none;" id="ajaxResponse"></div>

      	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
        <tr> 
          <td>&nbsp; </td>
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
          <td height="20"  class="TitrePage" ><!-- #BeginEditable "titre_page" -->GESTION DES PROFILS Localisés : 
           <bean:write name="profilsLocalizeForm" property="titrePage"/><!--GESTION DES PROFILS DE FI : CREATION--><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
       </table>
         
           <!-- #BeginEditable "debut_form" --> 
           <html:form action="/profilslocalize"  onsubmit="return ValiderEcran(this);" ><!-- #EndEditable --> 
            
           
            <!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="titrePage"/>
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="filtre_localize"/>
			<html:hidden property="filtre_lst_localize" />
			<html:hidden property="lst_date_effet" />
			<html:hidden property="ecran_appel" />
			<html:hidden property="filtre_date" />
			<table border="0" cellspacing="0" cellpadding="0" width="95%" > <tr> <td>
					    
              	 <table width="100%" border="0" cellspacing="1" cellpadding="1" align="center">
                
                <tr>
                <td width="17%"></td><td width="20%"></td><td width="12%"></td><td width="37%"></td><td width="14%"></td>
                </tr>
                <tr> 
                  <td class="texte"><b>Profil Localisé :</b></td>
                 <td class="texte">
	                 <logic:equal parameter="action" value="valider">
                   	    <bean:write name="profilsLocalizeForm"  property="filtre_localize" />
	                 	<html:hidden property="filtre_localize"/>
					<html:hidden property="date_effet"/>
                     </logic:equal>
					 <logic:equal parameter="action" value="creer">
	                 	<!--  action CREER-->
						 <logic:equal parameter="filtre_lst_localize" value="">
						  <!--  depuis INITIAL-->
						<bean:write name="profilsLocalizeForm"  property="filtre_localize" />
						 </logic:equal>
						
						 <logic:notEqual parameter="filtre_lst_localize" value="">
						  <!--  depuis LISTE-->
						<bean:write name="profilsLocalizeForm"  property="filtre_lst_localize" />
						 </logic:notEqual>
	                 </logic:equal>
	                 
	                  <logic:equal parameter="action" value="supprimer">
						<logic:notEmpty name="profilsLocalizeForm" property="filtre_lst_localize">
							<bean:write name="profilsLocalizeForm"  property="filtre_lst_localize" />
	                 	</logic:notEmpty>
						<logic:empty name="profilsLocalizeForm" property="filtre_lst_localize">
							<bean:write name="profilsLocalizeForm"  property="filtre_localize" />
	                 	</logic:empty>
	                 </logic:equal>
	                 
	                <logic:equal parameter="action" value="modifier">
						<logic:notEmpty name="profilsLocalizeForm" property="filtre_lst_localize">
							<bean:write name="profilsLocalizeForm"  property="filtre_lst_localize" />
	                 	</logic:notEmpty>
						<logic:empty name="profilsLocalizeForm" property="filtre_lst_localize">
							<bean:write name="profilsLocalizeForm"  property="filtre_localize" />
							
	                 	</logic:empty>
						
	                 </logic:equal>

	                 
                  </td>
                  <td class="texte" ><b>Libell&eacute; :</b></td>
  		          <td colspan="2" class="texte">
			                 <!--  Si l'attribut action du formulaire est créer -->
		                <logic:equal parameter="action" value="creer">
						
																
							<logic:empty name="profilsLocalizeForm" property="libelle" >
							<!--  depuis INITIAL-->
                	 
							<html:text property="libelle" styleClass="input" size="65" maxlength="30" onchange="return VerifAlphaMaxCar_profil_Lib(this,'libelle');"/>	
												
							</logic:empty>
						
							<logic:notEmpty name="profilsLocalizeForm" property="libelle" >
							<!--  depuis LISTE-->
							<bean:write name="profilsLocalizeForm"  property="libelle" />
							<html:hidden property="libelle"/>	  
							</logic:notEmpty>
						 
	                	</logic:equal>
						<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsLocalizeForm"  property="libelle" />

						</logic:equal> 
	                	<!--  Si l'attribut action du formulaire est modifier -->
		                <logic:equal parameter="action" value="modifier">
		                    <html:text property="libelle" styleClass="input" size="65" maxlength="30" onchange="return VerifAlphaMaxCar_profil_Lib(this,'libelle');"/> 
		                 </logic:equal>
		           </td>            
                </tr>
                <tr> 
                  <td class="texte" ><b>Date Effet:</b></td>
                  <td class="texte" > 
                    <logic:equal parameter="action" value="creer">
					
					 <logic:empty name="profilsLocalizeForm" property="filtre_lst_localize">
						<!--  depuis INITIAL -->
							<logic:empty name="profilsLocalizeForm" property="date_effet" >
									<!--  date effet vide-->
								<html:text property="date_effet" styleClass="input" size="14" maxlength="4" />
							</logic:empty>
							
							<logic:notEmpty name="profilsLocalizeForm" property="date_effet" >
									<!--  date effet non vide-->
									<bean:write name="profilsLocalizeForm"  property="date_effet" />
									<html:hidden property="date_effet"/>
							</logic:notEmpty>
						
					 </logic:empty>
					 
					  <logic:notEqual parameter="filtre_lst_localize" value="">
						<!--  depuis INITIAL-->
						<html:text property="date_effet" styleClass="input" size="5" maxlength="4" />
					 </logic:notEqual>
					 
                    </logic:equal>
					<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsLocalizeForm"  property="date_effet" />
						<html:hidden property="date_effet"/>
	                </logic:equal> 
                     <logic:equal parameter="action" value="modifier">
	                 	<bean:write name="profilsLocalizeForm"  property="date_effet" />
	                 	<html:hidden property="date_effet"/>
	                  </logic:equal>
                  </td>
					<logic:notEqual parameter="action" value="supprimer">
					
                  <td colspan="3" style="font-size: 11px;">Date de début d'effet, au format AAAA</td>
					</logic:notEqual>
					
                </tr>
                <tr> 
                  <td class="texte"><b>Top actif :</b></td>
                  <td class="texte">
                    <logic:equal parameter="action" value="creer">
						 <input type="radio" name="top_actif" value="O" checked >OUI
				 		 <input type="radio" name="top_actif" value="N" >NON	
					</logic:equal> 
					<logic:equal parameter="action" value="supprimer">
	                 	<logic:iterate id="elementTopActif" name="choixTopActif">
							<bean:define id="choixTA" name="elementTopActif" property="cle"/>
							<html:radio property="top_actif" value="<%=choixTA.toString()%>" disabled="true"/>
			 				<bean:write name="elementTopActif" property="libelle"/>
						</logic:iterate> 
	                 </logic:equal> 
                     <logic:equal parameter="action" value="modifier">
				 		 <logic:iterate id="elementTopActif" name="choixTopActif">
							<bean:define id="choixTA" name="elementTopActif" property="cle"/>
							<html:radio property="top_actif" value="<%=choixTA.toString()%>" />
			 				<bean:write name="elementTopActif" property="libelle"/>
						</logic:iterate> 
					</logic:equal>
                  </td> <td colspan="3"></td>
                </tr>
				<tr>
					<td colspan="2" class="texte"><i>Co&ucirc;ts unitaires HTR ...</i></td><td></td>
					<td ></td><td ></td>
				</tr>
				<tr> 
                  <td class="texte" ><b>Force de travail :</b></td>
                   <td colspan="3" style="font-size: 11px;">
                  	<logic:notEqual parameter="action" value="supprimer"> 

                   	<html:text property="force_travail" styleClass="input" size="14" maxlength="13"/>
                   &nbsp;0 à 2 d&eacute;cimales
                   	</logic:notEqual>
                   	<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsLocalizeForm"  property="force_travail" />
	                 </logic:equal> 
                  </td>
                  <td colspan="1"></td>
                </tr>
                <tr> 
                  <td class="texte"><b>Frais d'environnement :</b></td>
                  <td colspan="3" style="font-size: 11px;">
                  	<logic:notEqual parameter="action" value="supprimer">

                   	<html:text property="frais_environnement" styleClass="input" size="14" maxlength="13" />
                   	&nbsp;0 à 2 d&eacute;cimales
                   	</logic:notEqual>
                   	<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsLocalizeForm"  property="frais_environnement" />
	                 </logic:equal> 
                  </td><td colspan="1"></td>
                </tr>
                <tr> 
                  <td class="texte"><b>Commentaire :</b></td>
                 <td colspan="4" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:textarea property="commentaire" styleClass="input" size="60" maxlength="300" rows="5" onkeyup="limite( this,  300);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
	                 	<html:textarea property="commentaire" styleClass="input" size="60" rows="5" DISABLED="true" />
	                 </logic:equal> 
                  </td>
                </tr>
				<tr>
					
					<td colspan="5"><b></b></td>                
				</tr>
                <tr> 
                  <td class="texte" ><b>Direction Bip :</b></td>
                  <td>
                  	<logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="coddir" styleClass="input" size="14" maxlength="2"/>
                   	</logic:notEqual>
                   	<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsLocalizeForm"  property="coddir" />
	                 </logic:equal> 
                  </td>
                  <td class="texte">
                   	Profil par d&eacute;faut :
                  </td>
                  <td colspan="2" >
                  <font style="font-size: 11px;">
                   	<logic:equal parameter="action" value="creer">
						 <input type="radio" name="profil_defaut" onclick="document.forms[0].code_es.disabled = true; document.forms[0].codelocal.disabled = true; NotExistsProfilDefaut(document.forms[0].date_effet.value, document.forms[0].coddir.value, this);	" value="O" >OUI
				 		 <input type="radio" name="profil_defaut" onclick="document.forms[0].code_es.disabled = false; document.forms[0].codelocal.disabled = false; NotExistsProfilDefaut(document.forms[0].date_effet.value, document.forms[0].coddir.value, this);	" value="N" checked>NON
					</logic:equal> 
                    <logic:equal parameter="action" value="modifier">
				 		 <logic:iterate id="elementProfilParDefaut" name="choixProfilParDefaut">
							<bean:define id="choixPPD" name="elementProfilParDefaut" property="cle"/>
							<html:radio property="profil_defaut" onclick="
														if(document.forms[0].profil_defaut[1].checked){
														document.forms[0].code_es.disabled = false;
														document.forms[0].codelocal.disabled = false;
														 }
														else
														{
														document.forms[0].code_es.disabled = true;
														document.forms[0].codelocal.disabled = true;}
														
														NotExistsProfilDefautMaj(document.forms[0].date_effet.value, document.forms[0].coddir.value, this)" value="<%=choixPPD.toString()%>" />
			 				<bean:write name="elementProfilParDefaut" property="libelle"/>
						</logic:iterate> 
					</logic:equal>
					<logic:equal parameter="action" value="supprimer">
				 		 <logic:iterate id="elementProfilParDefaut" name="choixProfilParDefaut">
							<bean:define id="choixPPD" name="elementProfilParDefaut" property="cle"/>
							<html:radio property="profil_defaut" onchange="NotExistsProfilDefaut(document.forms[0].date_effet.value, document.forms[0].coddir.value, this)" value="<%=choixPPD.toString()%>" disabled="true"/>
			 				<bean:write name="elementProfilParDefaut" property="libelle"/>
						</logic:iterate> 
					</logic:equal></font>
					<logic:notEqual parameter="action" value="supprimer">
					<font style="font-size: 11px;">&nbsp;1 Profil par défaut, au plus, par Direction et par date d'effet</font>
					</logic:notEqual>
                  </td>
                </tr> 
                
                
				<tr>
                  <td class="texte" ><b>Code localisation :</b></td>
                  <td colspan="4" style="font-size: 11px;">
                  	<logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="codelocal" styleClass="input" size="14" maxlength="1" onchange="eslocStore(this.value,'loc');" onkeypress="return isNumber(event);"/>
                   	</logic:notEqual>
                   	<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsLocalizeForm"  property="codelocal" />
	                 </logic:equal> 
	                 &nbsp;Obligatoire, sauf si Profil par défaut (vide dans ce cas) : Code localisation applicable, selon dernier chiffre des DPG
                  </td>
                  
                </tr> 
                
                
                <tr> 
                  <td class="texte" ><b>Code ES applicable :</b></td>
                  <td colspan="4" style="font-size: 11px;"> 
					<logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="code_es" styleClass="input" size="14" maxlength="6" onchange="eslocStore(this.value,'es');" onkeypress="return esValidCheck(event);"/>
                  	&nbsp;Obligatoire, sauf si Profil par défaut (vide dans ce cas). Indiquez * si applicable à tous les ES
					</logic:notEqual>
					
					<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsLocalizeForm"  property="code_es" />
	                </logic:equal> 
                  </td>
                </tr>
				<tr> 
                  <td colspan="1" align="right" class="texte">(tous niveaux)</td><td colspan="4"></td>
                </tr>
				<tr> 
                  <td colspan="5">&nbsp;</td>
                </tr>
                <tr>
              <td colspan="1"></td>
                <td > 
                  <div align="right"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td colspan="3"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
              </tr>	
              
              <tr height="60"> <td colspan="5"></td></tr>
              
              </table>
              </td>
              </tr>
              </table>
              <!-- #EndEditable -->
             
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
	</div>
</body>
</html:html>
<!-- #EndTemplate -->
