<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.text.SimpleDateFormat,java.util.Locale" errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="profilsDomFoncForm" scope="request" class="com.socgen.bip.form.ProfilsDomFoncForm" />
<%@page import="com.socgen.bip.commun.form.BipForm"%>
<%@page import="com.socgen.bip.form.ProfilsDomFoncForm"%>
<html:html locale="true" xhtml="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

 <!-- #BeginEditable "doctitle" --> 
<title>GESTION DES PROFILS DOMFONC : CREATION/MODIFICATION</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmProfilsDomFoncAd.jsp"/> 
<%
	// On récupère la liste des top actif FI
    java.util.ArrayList choixTopActif = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topActif_DomFonc"); 
    pageContext.setAttribute("choixTopActif", choixTopActif);
    
 	// Récupèration de la liste profil par défaut
    java.util.ArrayList choixProfilParDefaut = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("profilParDefaut"); 
    pageContext.setAttribute("choixProfilParDefaut", choixProfilParDefaut);
    	
    if(profilsDomFoncForm.getTitrePage() != null && profilsDomFoncForm.getTitrePage().equals("Modifier")) {
		profilsDomFoncForm.setTitrePage("MODIFICATION");
	}
    else if(profilsDomFoncForm.getTitrePage() != null && profilsDomFoncForm.getTitrePage().equals("Supprimer")) {
		profilsDomFoncForm.setTitrePage("SUPPRESSION");
	}
    else {
		profilsDomFoncForm.setTitrePage("CREATION");
	}
%>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript"><!-- -->
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function TraitementInitial()
{

	// Si le mode est « modifier 
   if(document.forms[0].mode.value =="update") {
	   // Focus sur le champ Force de travail.
	   document.forms[0].force_travail.focus();
   }
   else if (document.forms[0].mode.value !="delete") {
		// Si le champ libellé est vide (création d'une 1ère date d'effet pour le profil DomFonc)
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
   var Message="<bean:write filter="false"  name="profilsDomFoncForm"  property="msgErreur" />";
   var Focus = "<bean:write name="profilsDomFoncForm"  property="focus" />";
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
	}
else
	{
	document.forms[0].code_es.disabled = true;
	}
}
}

function Verifier(form, action, mode, flag)
{
	if(action == "valider" && mode=="delete") {
		return ValiderSupprimer(form, action, mode, flag);
	}
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
	if (document.getElementById("filtre_lst_domfonc").value != null && document.getElementById("filtre_lst_domfonc").value != '') {
		ajaxCallRemotePage('/profilsdomfonc.do?action=estProfilAffecteRessMensAnnee&filtre_domfonc=' + document.getElementById("filtre_lst_domfonc").value + '&date_effet=' + document.getElementById("lst_date_effet").value);
	} else {
		ajaxCallRemotePage('/profilsdomfonc.do?action=estProfilAffecteRessMensAnnee&filtre_domfonc=' + document.getElementById("filtre_domfonc").value + '&date_effet=' + document.getElementById("date_effet").value);
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
			document.profilsDomFoncForm.filtre_domfonc.focus();
			return false;
		}
	}
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
     if (form.date_effet && !ChampObligatoire(form.date_effet, "la date effet")) return false;
	 if (!VerifierDateEffet(document.forms[0].date_effet)) return false;
     if (form.force_travail && !ChampObligatoire(form.force_travail, "le coût unitaire HTR force de travail")) return false;
     if (form.frais_environnement && !ChampObligatoire(form.frais_environnement, "le coût unitaire HTR frais d'environnement")) return false;
     if (form.coddir && !ChampObligatoire(form.coddir, "le code direction")) return false;
	 
	 if(form.profil_defaut[1].checked==true)
	 {
	 

	 if (form.code_es && !ChampObligatoire(form.code_es, "le code ES")) 
	      {

		  return false;
		  }
		  
	 if(!isValidCodeEs()) { return false;} 
		  
	 }
	 
	 if(!isValidCodeDir()) { return false;} 
		  
	 
	 
	

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


		
	if(!NotExistsProfilDomFoncList()) 
		{ 
			return false;
		}
		

  }
  
   return true;
}

//Appel en ajaxx pour regarder si le code direction existe déjà
function isValidCodeDir()
{
	var coddir;
	
	coddir = document.getElementById("coddir").value;
	if(!TraitementAjax('isValidCodeDir', '&coddir=' + coddir, 'coddir'))
	{
	return false ;
	}
	return true;
}

//Appel en ajaxx pour regarder si le code ES existe déjà
function isValidCodeEs()
{
	var code_es;
	
	code_es = document.getElementById("code_es").value;
	
	// Si la valeur du champ champProfilDefaut est « N »
	if(document.forms[0].profil_defaut[1].checked)
	{
		if(!TraitementAjax('isValidCodeEs', '&code_es=' + code_es, 'code_es'))
		{
		return false;
		}
	}
	else
	{
		document.getElementById("code_es").value = ""; 
	}
	return true;
}

function NotExistsProfilDefaut(date_effet, coddir, champProfilDefaut) {

	// Si la valeur du champ champProfilDefaut est « O »
	if (champProfilDefaut.value == "O") {
		// Faire un appel ajax de la méthode pMethode de l'action profilsdomfonc.do
		// Si la réponse ajax est non vide
		if (! TraitementAjax('notExistsProfilDefaut', '&date_effet=' + date_effet + '&coddir=' + coddir, champProfilDefaut)) {
			// Positionnement du bouton radio champProfilDefaut à « NON » (value= 'N')
			document.forms[0].profil_defaut[1].checked = true;
			document.forms[0].code_es.disabled = false;
			return false;
		}
		else {
			// Vidage du champ Code ES applicable
			document.getElementById("code_es").value = ""; 
			return true;
		}
	}

	return true;
}

function NotExistsProfilDefautMaj(date_effet, coddir, champProfilDefaut) {

	var p_domfonc;
	
	if(document.forms[0].filtre_lst_domfonc.value==null || document.forms[0].filtre_lst_domfonc.value=="" )
		{
		p_domfonc=document.forms[0].filtre_domfonc.value;
		}
		else
		{
		p_domfonc=document.forms[0].filtre_lst_domfonc.value;
		}

	// Si la valeur du champ champProfilDefaut est « O »
	if (champProfilDefaut.value == "O") {
		// Faire un appel ajax de la méthode pMethode de l'action profilsdomfonc.do
		// Si la réponse ajax est non vide
		if (! TraitementAjax('notExistsProfilDefautMaj', '&filtre_domfonc=' + p_domfonc +'&date_effet=' + date_effet + '&coddir=' + coddir, champProfilDefaut)) {
			// Positionnement du bouton radio champProfilDefaut à « NON » (value= 'N')
			document.forms[0].profil_defaut[1].checked = true;
			document.forms[0].code_es.disabled = false;
			return false;
		}
		else {
			// Vidage du champ Code ES applicable
			document.getElementById("code_es").value = ""; 
			return true;
		}
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
	
	// Appel ajax de la méthode pMethode de l'action profilsdomfonc.do
	ajaxCallRemotePage('/profilsdomfonc.do?action=' + pMethode + pParams);
	// Si la réponse ajax est non vide :
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		// Affichage d'une popup avec le contenu de la réponse
		alert(document.getElementById("ajaxResponse").innerHTML);
		// Focus sur le champ
		if(pFocus.name=='profil_defaut')
		{
		pFocus.focus();
		}
		else
		{
		var element=document.getElementById(pFocus);
		element.focus();
		}
		
		return false;
	}
	return true;
}

/**
 * Appel de la méthode notExistsProfilDomFonc en ajax
 */
function NotExistsProfilDomFonc() {
			

	if (document.forms[0].mode.value != "delete") {
		return TraitementAjax('notExistsProfilDomFonc', '&filtre_domfonc=' + document.getElementById("filtre_domfonc").value + '&date_effet=' + document.getElementById("date_effet").value, "date_effet");
	}
	else {
		return true;
	}		
			
		
	
}

/**
 * Appel de la méthode notExistsProfilDomFonc en ajax
 */
function NotExistsProfilDomFoncList() {


	if(document.forms[0].mode.value =="insert")
	{
	return TraitementAjax('notExistsProfilDomFonc', 
			'&filtre_lst_domfonc=' 
			+ document.getElementById("filtre_lst_domfonc").value 
			+ '&date_effet=' 
			+ document.getElementById("date_effet").value, 
			"date_effet");
	}
	
	return true;
	
}

/**
 * Appel de la méthode ExistsProfilFi en ajax
 */
function ExistsProfilFi() {

	if (TraitementAjax('existsProfilFI', '&filtre_domfonc=' + document.getElementById("filtre_domfonc").value, 'filtre_domfonc') == false) {
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
   else if (aaaa < 2014) {
		// affichage d'une popup contenant le message « Année invalide : AAAA >= 2014 »
		alert( "Année invalide : AAAA >= 2014" );
		pChamp.focus();
		return false;
	}

	// Vérification que le champ pChamp est un entier postérieure ou égale à 2014
	// Si OK
   if (EstDateEffetValide(pChamp)) {
	   // Vérification de non existence du profil domfonc (pour le couple code profil, date effet saisis)
	   if(document.getElementById("filtre_domfonc") && document.forms[0].mode.value =="insert")
	   {
			if(!NotExistsProfilDomFonc())
			{
			return false;
			}
	   }
			else
	   {
			if(!NotExistsProfilDomFoncList())
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

	
	else if (aaaa < 2014) {
		// affichage d'une popup contenant le message « Année invalide : AAAA >= 2014 »
		alert( "Année invalide : AAAA >= 2014" );
		pChamp.focus();
		return false;
	}

		return true;
}

</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="TraitementInitial();">
<div style="display:none;" id="ajaxResponse"></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> 
            <div align="center"><!-- #BeginEditable "barre_haut" --> 
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%><!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->GESTION DES PROFILS par Domaine Fonctionnel :  
           <bean:write name="profilsDomFoncForm" property="titrePage"/><!--GESTION DES PROFILS DE FI : CREATION--><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/profilsdomfonc"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="titrePage"/>
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="filtre_domfonc"/>
			<html:hidden property="filtre_lst_domfonc" />
			<html:hidden property="lst_date_effet" />
			<html:hidden property="ecran_appel" />
			<html:hidden property="filtre_date" />
			
					    
              <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" align="center">
                <tr> 
                  <td colspan=1 >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Profil DomFonc :</b></td>
                 <td>
	                 <logic:equal parameter="action" value="valider">
                   	    <bean:write name="profilsDomFoncForm"  property="filtre_domfonc" />
	                 	<html:hidden property="filtre_domfonc"/>
					<html:hidden property="date_effet"/>
                     </logic:equal>
					 <logic:equal parameter="action" value="creer">
	                 	<!--  action CREER-->
						 <logic:equal parameter="filtre_lst_domfonc" value="">
						  <!--  depuis INITIAL-->
						<bean:write name="profilsDomFoncForm"  property="filtre_domfonc" />
						 </logic:equal>
						
						 <logic:notEqual parameter="filtre_lst_domfonc" value="">
						  <!--  depuis LISTE-->
						<bean:write name="profilsDomFoncForm"  property="filtre_lst_domfonc" />
						 </logic:notEqual>
	                 </logic:equal>
	                 
	                  <logic:equal parameter="action" value="supprimer">
						<logic:notEmpty name="profilsDomFoncForm" property="filtre_lst_domfonc">
							<bean:write name="profilsDomFoncForm"  property="filtre_lst_domfonc" />
	                 	</logic:notEmpty>
						<logic:empty name="profilsDomFoncForm" property="filtre_lst_domfonc">
							<bean:write name="profilsDomFoncForm"  property="filtre_domfonc" />
	                 	</logic:empty>
	                 </logic:equal>
	                 
	                <logic:equal parameter="action" value="modifier">
						<logic:notEmpty name="profilsDomFoncForm" property="filtre_lst_domfonc">
							<bean:write name="profilsDomFoncForm"  property="filtre_lst_domfonc" />
	                 	</logic:notEmpty>
						<logic:empty name="profilsDomFoncForm" property="filtre_lst_domfonc">
							<bean:write name="profilsDomFoncForm"  property="filtre_domfonc" />
							
	                 	</logic:empty>
						
	                 </logic:equal>

	                 
                  </td>
                  <td class="lib" width="10%"><b>Libellé :</b></td>
  		          <td>
			                 <!--  Si l'attribut action du formulaire est créer -->
		                <logic:equal parameter="action" value="creer">
						
																
							<logic:empty name="profilsDomFoncForm" property="libelle" >
							<!--  depuis INITIAL-->
                	 
							<html:text property="libelle" styleClass="input" size="16" maxlength="30" onchange="return VerifAlphaMaxCar_profil_Lib(this,'libelle');"/>	
												
							</logic:empty>
						
							<logic:notEmpty name="profilsDomFoncForm" property="libelle" >
							<!--  depuis LISTE-->
							<bean:write name="profilsDomFoncForm"  property="libelle" />
							<html:hidden property="libelle"/>	  
							</logic:notEmpty>
						 
	                	</logic:equal>
						<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsDomFoncForm"  property="libelle" />

						</logic:equal> 
	                	<!--  Si l'attribut action du formulaire est modifier -->
		                <logic:equal parameter="action" value="modifier">
		                    <html:text property="libelle" styleClass="input" size="16" maxlength="30" onchange="return VerifAlphaMaxCar_profil_Lib(this,'libelle');"/> 
		                 </logic:equal>
		           </td>            
                </tr>
                <tr> 
                  <td class="lib" ><b>Date Effet:</b></td>
                  <td> 
                    <logic:equal parameter="action" value="creer">
					
					 <logic:empty name="profilsDomFoncForm" property="filtre_lst_domfonc">
						<!--  depuis INITIAL -->
							<logic:empty name="profilsDomFoncForm" property="date_effet" >
									<!--  date effet vide-->
								<html:text property="date_effet" styleClass="input" size="5" maxlength="4" onchange="return VerifierDateEffet(this);"/>
							</logic:empty>
							
							<logic:notEmpty name="profilsDomFoncForm" property="date_effet" >
									<!--  date effet non vide-->
									<bean:write name="profilsDomFoncForm"  property="date_effet" />
									<html:hidden property="date_effet"/>
							</logic:notEmpty>
						
					 </logic:empty>
					 
					  <logic:notEqual parameter="filtre_lst_domfonc" value="">
						<!--  depuis INITIAL-->
						<html:text property="date_effet" styleClass="input" size="5" maxlength="4" onchange="return VerifierDateEffet(this);"/>
					 </logic:notEqual>
					 
                    </logic:equal>
					<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsDomFoncForm"  property="date_effet" />
						<html:hidden property="date_effet"/>
	                </logic:equal> 
                     <logic:equal parameter="action" value="modifier">
	                 	<bean:write name="profilsDomFoncForm"  property="date_effet" />
	                 	<html:hidden property="date_effet"/>
	                  </logic:equal>
                  </td>
					<logic:notEqual parameter="action" value="supprimer">
					
                  <td colspan="2"><font size="1">1er mois d'effet, au format AAAA</font></td>
					</logic:notEqual>
					
                </tr>
                <tr> 
                  <td class="lib"><b>Top actif :</b></td>
                  <td>
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
                  </td>
                </tr>
				<tr>
					<td colspan="2" class="lib"><i>Co&ucirc;ts unitaires HTR ...</i></td>
				</tr>
				<tr> 
                  <td class="lib" ><b>Force de travail :</b></td>
                   <td colspan="3">
                  	<logic:notEqual parameter="action" value="supprimer"> 

                   	<html:text property="force_travail" styleClass="input" size="14" maxlength="13" onblur="return VerifierCout(this,12,2);"/>
                   	<font size="1">&nbsp;0 à 2 d&eacute;cimales</font>
                   	</logic:notEqual>
                   	<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsDomFoncForm"  property="force_travail" />
	                 </logic:equal> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Frais d'environnement :</b></td>
                  <td colspan="3">
                  	<logic:notEqual parameter="action" value="supprimer">

                   	<html:text property="frais_environnement" styleClass="input" size="14" maxlength="13" onblur="return VerifierCout(this,12,2);"/>
                   	<font size="1">&nbsp;0 à 2 d&eacute;cimales</font>
                   	</logic:notEqual>
                   	<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsDomFoncForm"  property="frais_environnement" />
	                 </logic:equal> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Commentaire :</b></td>
                 <td colspan="4" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:textarea property="commentaire" styleClass="input" size="80" maxlength="300" rows="5" onblur="return VerifAlphaMaxCar_profil_Comm(this,'commentaire');" onkeyup="limite( this,  300);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
	                 	<html:textarea property="commentaire" styleClass="input" size="80" rows="5" DISABLED="true" />
	                 </logic:equal> 
                  </td>
                </tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="4"><b><div id="reste"></div></b></td>                
				</tr>
                <tr> 
                  <td class="lib" ><b>Direction Bip :</b></td>
                  <td>
                  	<logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="coddir" styleClass="input" size="3" maxlength="2" onchange="return isValidCodeDir();"/>
                   	</logic:notEqual>
                   	<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsDomFoncForm"  property="coddir" />
	                 </logic:equal> 
                  </td>
                  <td>
                   	Profil par d&eacute;faut :
                  </td>
                  <td colspan="2">
                   	<logic:equal parameter="action" value="creer">
						 <input type="radio" name="profil_defaut" onclick="document.forms[0].code_es.disabled = true; NotExistsProfilDefaut(document.forms[0].date_effet.value, document.forms[0].coddir.value, this);	" value="O" >OUI
				 		 <input type="radio" name="profil_defaut" onclick="document.forms[0].code_es.disabled = false; NotExistsProfilDefaut(document.forms[0].date_effet.value, document.forms[0].coddir.value, this);	" value="N" checked>NON
					</logic:equal> 
                    <logic:equal parameter="action" value="modifier">
				 		 <logic:iterate id="elementProfilParDefaut" name="choixProfilParDefaut">
							<bean:define id="choixPPD" name="elementProfilParDefaut" property="cle"/>
							<html:radio property="profil_defaut" onclick="
														if(document.forms[0].profil_defaut[1].checked){
														document.forms[0].code_es.disabled = false; }
														else
														{document.forms[0].code_es.disabled = true};
														
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
					</logic:equal>
					<logic:notEqual parameter="action" value="supprimer">
					<font size="1">&nbsp;1 et 1 seul par Direction et par date d'effet</font>
					</logic:notEqual>
                  </td>
                </tr> 
                <tr> 
                  <td class="lib"><b>Code ES applicable :</b></td>
                  <td colspan="3"> 
					<logic:notEqual parameter="action" value="supprimer">
                   	<html:text property="code_es" styleClass="input" size="7" maxlength="6" onchange="this.value=this.value.toUpperCase();" onKeypress="if(event.keyCode < 44 || event.keyCode > 57) event.returnValue = false; if(event.which < 44 || event.which > 57) return false;"/>
                  	<font size="1">&nbsp;Obligatoire, sauf si Profil par défaut (vide dans ce cas)</font></td>
					</logic:notEqual>
					
					<logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsDomFoncForm"  property="code_es" />
	                </logic:equal> 
                  </td>
                </tr>
				<tr> 
                  <td colspan="1" align="right"><font size="1">(tous niveaux)</font></td>
                </tr>
				<tr> 
                  <td colspan="1">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
              </table>
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="50%" border="0">
              <tr> 
                <!-- <td width="25%">&nbsp;</td> -->
                <td width="15%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="15%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
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
</body>
</html:html>
<!-- #EndTemplate -->
