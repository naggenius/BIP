<%@page import="java.util.Date"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/ajaxtags.tld" prefix="ajax"%>

<%@ page language="java"
	import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"
	errorPage="../jsp/erreur.jsp"%>
<jsp:useBean id="projetForm" scope="request"
	class="com.socgen.bip.form.ProjetForm" />
<jsp:useBean id="editionForm" scope="request"
	class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true">

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>
<jsp:include page="ajax.jsp" flush="true" />

<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/fmProjetAd.jsp" />
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var rafraichiEnCours = false;
var projaxemetierInit;
var statut ="";
//ABN : PPM 63482
<%
if (projetForm.getProjaxemetier() == null) {
%>
projaxemetierInit = "";
<%
} else {
%>
projaxemetierInit = "<%= projetForm.getProjaxemetier() %>";
<%}%>
<%java.util.ArrayList statutsProjet = new com.socgen.bip.commun.liste.ListeDynamique()
						.getListeDynamique("pstatut", projetForm.getHParams());
				java.util.ArrayList domBancaire = new com.socgen.bip.commun.liste.ListeDynamique()
						.getListeDynamique("domaine_npsi_actif",
								projetForm.getHParams());
				java.util.ArrayList dossierProjetAlpha = new com.socgen.bip.commun.liste.ListeDynamique()
						.getListeDynamique("dprojet_alpha",
								projetForm.getHParams());
				//user story -307 
				//java.util.ArrayList caDisponibles = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ca",projetForm.getHParams()); 

	java.util.ArrayList listeDpCopi = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dpcopipardpccode",projetForm.getHParams()); 
	listeDpCopi.add(0,new ListeOption("","")) ; 
	
	java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("ouiNon"); 
	pageContext.setAttribute("choixTopEnvoi", list1);
	
	
    pageContext.setAttribute("statutsProjet", statutsProjet);
    pageContext.setAttribute("choixDomBancaire", domBancaire);
				pageContext.setAttribute("choixDossierProjet",
						dossierProjetAlpha);
				//user story -307 
				//  pageContext.setAttribute("choixCa", caDisponibles);
    pageContext.setAttribute("choixDpCopi", listeDpCopi);
    
    java.util.ArrayList listeType = new java.util.ArrayList();
	listeType.add(0,new com.socgen.bip.commun.liste.ListeOption("", ""));
	listeType.add(1,new com.socgen.bip.commun.liste.ListeOption("A", "Avec"));
	listeType.add(2,new com.socgen.bip.commun.liste.ListeOption("S", "Sans"));
	pageContext.setAttribute("choixLienCodeProjetCA", listeType);
    
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String topenvoi = projetForm.getTopenvoi();
	String datenvoi = projetForm.getDate_envoi();
	String dpcopi = projetForm.getDpcopi();
	String dossier_projet = projetForm.getIcodproj();
	String dat_fonctionnel = projetForm.getDatefonctionnel();
	String count = projetForm.getCount();
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{

	statut = "<%= projetForm.getStatut() %>";

   var Message="<bean:write filter="false"  name="projetForm"  property="msgErreur" />";
   var Focus = "<bean:write name="projetForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value!="delete"){
	   document.forms[0].ilibel.focus();	  
   }

   if ((document.forms[0].mode.value=="insert")&&(document.forms[0].action.value!="refresh") ){   	
	   document.forms[0].icpir.value=document.forms[0].icpi.value;	   	
   }
   
   var topenvoi = "<%= topenvoi %>";
   var datenvoi = "<%= datenvoi %>";
 	var dpcopi = "<%= dpcopi%>";
 	var dossier_projet = "<%= dossier_projet%>";
 
 
 	
 	if(dossier_projet === 0)
 	{
 		ligne = document.getElementById('ligneImmo');
 		ligne.style.display = "none";
 	}
  
   if (topenvoi=="N" && datenvoi=="01/01/1900" )
   {
    
   	   menu = document.getElementById('envoi');
   		menu1 = document.getElementById('envoi1');
   		menu.style.display = "none";
   		menu1.style.display = "none";
    }

}

function Verifier(form, action, mode, flag,edition)
{
   blnVerification = flag;
   form.action.value = action;
   form.edition.value = edition;   
}

function ValiderEcran(form)
{
	if (blnVerification == true)
	{
	
	
	
		var dossier_projet = "<%= dossier_projet%>";
		var msgDsr="";
		/* BIP 335 - checking the project values linked to BIP ligne  */
		if(form.mode.value=='update' && dossier_projet == '0' ){
		
			msgDsr= verifierProj(document.forms[0].icpi.value); // MCH : QC1811
			
			if(!msgDsr){
		
				return false;
			}
			
		}
	
		// FAD PPM 63826 : Début
		if (form.dureeamor.value != "")
		{
			var pp = verifierDureeAmort(form.dureeamor.value);
			var tab = pp.split(";");
			if (tab[1] == "KO")
			{
				if (!confirm("Votre durée d'amortissement n'est pas standard et nécessite l'accord du service en charge des immobilisations. Confirmez-vous cette durée ?"))
				{
					form.dureeamor.focus();
					return false;
				}
			}
		}
		// FAD PPM 63826 : Fin
		

		// PPM 64510 : Debut
		if(statut=="O" && form.statut.value=="Q"){
			if(true){
				//window.open("jsp/mProjetAdPopUp");
				window.open("/projet.do?action=statutPopUp&message=&windowTitle=Initialisation de statut"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=no, scrollbars=no, width=500, height=120") ;
				return false;
			}
		}
		
		// PPM 64510 : Fin
		
		

		// HMI : PPM 61919 chapitre 6.8
		if (document.forms[0].mode.value == 'insert' || form.mode.value == 'update')
		{
			var res= verifierAxe(document.forms[0].icpi.value,document.forms[0].projaxemetier.value,document.forms[0].clicode.value,document.forms[0].codsg.value,document.forms[0].dpcopi.value); // MCH : QC1811
		 if(!res) return false;
		}
		// fin HMI : PPM 61919 chapitre 6.8
		if ( (form.icpi) && (form.icpi.value=="") )
		{
			alert("Le code projet doit être saisi.");
			form.icpi.focus();
			return false;
		}

		if (form.ilibel && !ChampObligatoire(form.ilibel, "le libellé"))
			return false;

		// suppression du caractère tabulation dans le libellé et la description
		var regex = /[\t]+/g;
		form.ilibel.value = form.ilibel.value.replace(regex,"");
		form.descr.value = form.descr.value.replace(regex,"");

		if (form.cada && !ChampObligatoire(form.cada, "le cada"))
			return false;

		if ((form.statut) && (form.statut.value!="") && (form.statut.value!="O") && (form.statut.value!="N"))
		{
			if (form.cada.value==0)
			{
				alert("Le cada doit être différent de 0");
				form.cada.focus();
				return false;
			}
			else
				if (form.cada.value=="28553")
				{
					alert("Le cada doit être différent de 28553");
					form.cada.focus();
					return false;
				}
		}

		if ((form.statut) && ((form.statut.value=="D") || (form.statut.value=="A") || (form.statut.value=="Q") || (form.statut.value=="R")))
		{
			if (!ChampObligatoire(form.dateDemarrage, "la date de prise en compte du statut"))
				return false;
		}
		else
		{
			if ((form.dateDemarrage) && (form.dateDemarrage.value!=""))
			{
				alert("La date de statut ne doit pas être renseigné pour ce statut");
				form.dateDemarrage.focus();
				return false;
			}
		}
		if ( (form.icpir) && (form.icpir.value=="") )
		{
			alert("Le code projet groupe doit être saisi.");
			form.icpir.focus();
			return false;
		}

		if ((form.mode.value== 'update')&& (form.edition.value!='OUI'))
		{
			if (!confirm("Voulez-vous modifier ce projet informatique ?"))
				return false;
		}

		if ((form.mode.value== 'update')&& (form.edition.value=='OUI'))
		{
			if (!confirm("Voulez-vous imprimer ce projet informatique ?"))
				return false;
		}

		if (form.mode.value== 'delete')
		{
			if (!confirm("Voulez-vous supprimer ce projet informatique ?"))
				return false;
		}

		if ((form.icpi) && !(ChampObligatoire(form.icpi, "le nouveau Code Projet")))
			return false;

		if ((form.topenvoi.value == 'O') && (form.date_envoi.value==""))
		{
			alert("la date envoi immobilisation doit être renseigné pour ce top envoi");
			form.date_envoi.focus();
			return false;
		}

		/* Nous interdisons la demarrage des projets avec une année  = A-1, seul la saisie avec une annee A  ou  A+1 est autorisé */
		var topenvoi = "<%= topenvoi %>";
		
		
		var annee_en_cours = "<%= dat_fonctionnel%>";	
		var annee_saisie = form.dateDemarrage.value.substring(3,7);

		if ((annee_saisie < annee_en_cours) && annee_saisie != "" && topenvoi == "N" && dossier_projet != 0)
		{
			alert("Le démarrage ou l'abandon d'un projet est interdit sur l'année précédente");
			form.dateDemarrage.focus();
			return false;
		}

		if (form.count.value != '0')
		{
			if (!confirm("Il existe des lignes rattachées au couple \n projet/DP initial.Si vous cliquez sur OK,le \n lien et les lignes seront mis à jour "))
				return false;
		}
	}
	return true;	
}

//Sprint 6 : 335 user story 
function verifierProjectLigneLink(p_icpi){
	
	ajaxCallRemotePage('/projet.do?action=verifierProjectLigneLink&icpi='+p_icpi);
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
}

//HMI : PPM 61919 chapitre 6.8
//ABN : PPM 63482
function verifierProjAxeMetier(p_icpi,p_projaxemetier,p_clicode,p_codsg,p_dpcopi){
	// Appel ajax de la méthode de l'action 
	ajaxCallRemotePage('/projet.do?action=verifierProjetAxeMetier&icpi='+p_icpi+'&projaxemetier='+p_projaxemetier+'&clicode='+p_clicode+'&codsg='+p_codsg+'&dpcopi='+p_dpcopi);
	// Si la réponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
	
}

//FAD PPM 63826 : Début
function verifierDureeAmort(p_duramort){
	// Appel ajax de la méthode de l'action 
	ajaxCallRemotePage('/projet.do?action=verifierDureeAmort&duramort='+p_duramort);
	// Si la réponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
}
//FAD PPM 63826 : Fin

function mettreAvide(p_type,p_param_id){
	<% String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getIdUser(); %>
	// Appel ajax de la méthode de l'action 
	ajaxCallRemotePage('/projet.do?action=mettreAvide&type='+p_type+'&param_id='+p_param_id+'&userid='+'<%=userid%>');
	// Si la réponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
	
}


function verifierProj(p_icpi){


var result = verifierProjectLigneLink(p_icpi);
var tab =result.split(';');

var pid=tab[0].split(',');
var message=tab[1];
	
	if(message.replace(/\s+/, "")==='PIDACTIVE'){
		var len=pid.length;
	
		for (var i=0;i<len;i++){ 
		alert("Au moins 1 ligne BIP amortissable ("+pid[i]+") est liée au projet en cours :\n vous devez donc commencer par modifier au moins cette ligne pour la passer dans une autre typologie,\n ou alors la passer à un autre projet.");
		}
	
	return false;
	}
	return true;
}

//MCH : QC1811
//ABN : PPM 63482
function verifierAxe(p_icpi,p_projaxemetier,p_clicode,p_codsg,p_dpcopi){
	
	var result = verifierProjAxeMetier(p_icpi,p_projaxemetier,p_clicode,p_codsg,p_dpcopi);
    
    var tab = result.split(';');
    var type = tab[0];
    var param_id = tab[1];
    var message = tab[2];
    
    var valide = message.replace(/ /g,"");
    
    var valid = valide.split('#');
    
 
    //alert("message1="+message);//.substring(0,9).toUpperCase());
    if(valid[0] == 'valid' ){
    	if(valid[1] == 'axe' ){
    		if (document.forms[0].mode.value=="insert") {
    			document.forms[0].projaxemetier.value = "";
    		} else {
	    		if (projaxemetierInit != document.forms[0].projaxemetier.value) {
	    			document.forms[0].projaxemetier.value = projaxemetierInit;
	    		}
    		}
    	}
  	  return true;
    }
    else
//    Debut	HMI - PPM corrective :  63927 
    	{
    	 if(message =='valid')
    	    {
    	    	return true;
    	    }
    	    else {
    	if(message!="" && message.substring(0,9).toUpperCase() == 'ATTENTION'){
    	
  	  if(confirm(message)){
  		
  		  mettreAvide(type,param_id);
//   		  return verifierAxe(p_icpi,p_projaxemetier,p_clicode,p_codsg);
  		  return verifierAxe(p_icpi,p_projaxemetier,p_clicode,p_codsg,p_dpcopi);
  	  }
  	  else {
  		
  		  document.forms[0].projaxemetier.focus();
  		  return false;
  	  }
//    Fin HMI - PPM corrective :  63927 
  	  //window.open("/dpcopiMessage.do?action=initialiser&message='+message+'&windowTitle=Message de la page web"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=no, scrollbars=no, width=450, height=150") ;
		
    }
    else {
    	
  	  alert(message);
 
  	  document.forms[0].projaxemetier.focus();
		  return false;
    }
    	}
    	}
	
}

//fin HMI : PPM 61919 chapitre 6.8


function rechercheIdProjet(){
	window.open("/recupIdProjet.do?action=initialiser&nomChampDestinataire=icpi&windowTitle=Recherche du Code Projet&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450");
	return ;
}
function VerifierNum3( EF, longueur, decimale )
{
if (EF.value == 0) {
	alert('Nombre invalide');
	EF.value = '';
}
else
   VerifierNum(EF, longueur, decimale);
}
function VerifierClicode(champ)
{
	 // Test spécifique pour forcer le clicode à " AB" si l'utilisateur saisit "AB"
     if (champ.value.toUpperCase() == "AB" ) 
     {
        champ.value = " AB" ;
     }	
	 if (VerifierAlphaMax(champ)) chargeLib(champ.name);
}
function VerifierCodsg(champ)
{
	 if (VerifierNum( champ, 7, 0)) chargeLib(champ.name);
}
function VerifierCada(champ)
{
	 if (VerifierNum( champ, 5, 0)) chargeLib(champ.name);
}
function VerifierDurAmor(champ)
{
	 if (VerifierNum3( champ, 3, 0)) chargeLib(champ.name);
}
function chargeLib(libCherche)
{
	if(!rafraichiEnCours)
	{
        document.forms[0].focus.value = libCherche;
        rafraichir(document.forms[0]);
		rafraichiEnCours = true;
	}
}

function refreshEcran(libCherche) {
	if(!rafraichiEnCours)
	{     
        if(libCherche == 'icodproj'){
        	document.forms[0].focus.value = libCherche;
        }
        rafraichir(document.forms[0]);
		rafraichiEnCours = true;
	}
}


function nextFocus(){
	document.forms[0].ilibel.focus();
}
function rechercheIDMo(champs){
	window.open("/recupIdMo.do?action=initialiser&nomChampDestinataire="+champs+"&rafraichir=OUI&windowTitle=Recherche Code Client&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
function rechercheDPG(){
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=codsg&rafraichir=OUI&windowTitle=Recherche Code ME&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
function rechercheDPCopi(){
		window
				.open(
						"/recupDPCopi.do?action=initialiser&type=creation&nomChampDestinataire=dpcopi&windowTitle=Recherche Code Dossier Projet COPI",
						"",
						"toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450");
		return;
	}
	//BIP 307 user story javascript changes
	function rechercheCodcamo1() {
		
window.open("/recupCodcamo.do?action=initialiser&nomChampDestinataire=codcamo1&rafraichir=OUI&windowTitle=Recherche Codecamo&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
		return;
	}
	function rechercheCodcamo2() {
		
window.open("/recupCodcamo.do?action=initialiser&nomChampDestinataire=codcamo2&rafraichir=OUI&windowTitle=Recherche Codecamo&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
} 
	function rechercheCodcamo3() {

window.open("/recupCodcamo.do?action=initialiser&nomChampDestinataire=codcamo3&rafraichir=OUI&windowTitle=Recherche Codecamo&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
		return;
	}
	function rechercheCodcamo4() {
		window.open("/recupCodcamo.do?action=initialiser&nomChampDestinataire=codcamo4&rafraichir=OUI&windowTitle=Recherche Codecamo&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
		return;
	}
	function rechercheCodcamo5() {

window.open("/recupCodcamo.do?action=initialiser&nomChampDestinataire=codcamo5&rafraichir=OUI&windowTitle=Recherche Codecamo&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
		return;
	}
	//BIP 307 user story end of javascript changes
	function nextFocusIMOP() {
		document.forms[0].imop.focus();
	}
	function nextFocusICME() {
		document.forms[0].icme.focus();
	}
	function nextFocusDPCOPI() {
		document.forms[0].dpcopi.focus();
	}

	function affiche_date() {
	menu = document.getElementById('envoi');
	menu1 = document.getElementById('envoi1');
	if (document.forms[0].date_envoi.value=="01/01/1900")
	{
	document.forms[0].date_envoi.value="";
	}
	
	if ((document.forms[0].topenvoi.value=="N") && (document.forms[0].date_envoi.value==""))
   {
   
   menu.style.display = "none";
   menu1.style.display = "none";
   }
   else
   {
   	
   	 menu.style.display = "";
   	 menu1.style.display = "";
   }
   
}
function limite( this_,  max_){
  var Longueur = this_.value.length;

  if ( Longueur > max_){
    this_.value = this_.value.substring( 0, max_);
    Longueur = max_;
   }
  document.getElementById('reste').innerHTML = (max_ - Longueur) +" sur 305 caractères restant";
}
 
</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0"
	onLoad="MessageInitial();">
	<div style="display: none;" id="ajaxResponse"></div>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<div align="center">
								<!-- #BeginEditable "barre_haut" -->
								<%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
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
						<td height="20" class="TitrePage">
							<% 	
 			if ( ("OUI".equals(projetForm.getDuplic())) ) 
 			{
 			   		projetForm.setTitrePage("Dupliquer");
 	        }
 	        //Permet de garder l'action initiale. Car la valeur de Action est écrasée par le refresh
 	        if (  !("refresh".equals(projetForm.getAction())) && ("NON".equals(projetForm.getDuplic())) && !("valider".equals(projetForm.getAction())) ) 
 			{
 	           		projetForm.setTopaction(projetForm.getAction());
 			}
 			else if ("OUI".equals(projetForm.getDuplic()))
 			{
 			  		projetForm.setTopaction("creer");
 			}
 			%> <bean:write name="projetForm" property="titrePage" /> un projet
							informatique
						</td>
					</tr>
					<tr>
						<td background="../images/ligne.gif"></td>
					</tr>
					<tr>
						<td><html:form action="/projet"
								onsubmit="return ValiderEcran(this);">
								<html:hidden property="focus" />
								<html:hidden property="titrePage" />
								<div align="center">
									<input type="hidden" name="pageAide" value="<%= sPageAide %>">
									<html:hidden property="action" />
									<html:hidden property="duplic" />
									<html:hidden property="mode" />
									<html:hidden property="arborescence"
										value="<%= arborescence %>" />
									<html:hidden property="flaglock" />
									<html:hidden property="topaction" />
									<html:hidden property="datcre" />
									<html:hidden property="edition" />
									<!--PPM 50589 - QC 1617 -->
									<html:hidden property="datefonctionnel" />
									<!--PPM 64510 -->
									<html:hidden property="updatestatut" value="N" />


									<table cellspacing="2" cellpadding="2" class="tableBleu">
										<tr>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td class="lib"><b>Projet :</b></td>
											<td colspan="2"><logic:notEqual parameter="duplic"
													value="OUI">
													<b><bean:write name="projetForm" property="icpi" /></b>
													<html:hidden property="icpi" />
												</logic:notEqual> <logic:equal parameter="duplic" value="OUI">
													<html:text property="icpi" styleClass="input" size="6"
														maxlength="5"
														onchange="this.value = this.value.toUpperCase();return VerifierAlphanum(this);" />
												</logic:equal></td>
											<logic:notEqual name="projetForm" property="topaction"
												value="creer">
												<td class="lib">Date de cr&eacute;ation du projet
													:&nbsp;</td>
												<td><bean:write name="projetForm" property="datcre" />
												</td>
											</logic:notEqual>
											<logic:equal name="projetForm" property="topaction"
												value="creer">
												<td colspan="2">&nbsp;</td>
											</logic:equal>
										</tr>
										<tr>
											<td class="lib"><b>Libellé :</b></td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="ilibel" styleClass="input" size="58"
														maxlength="50" onchange="return VerifierAlphanum(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="ilibel" />
												</logic:equal></td>
										</tr>
										<tr>
											<td class="lib">Description :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:textarea property="descr" styleClass="input" rows="6"
														cols="60" onchange="return VerifierAlphanum(this);"
														onkeyup="limite( this,  305);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="descr" />
												</logic:equal></td>
											<td width="30">&nbsp;</td>

											<!--   HMI : PPM 61919 chapitre 6.8 -->
											<td valign="top">

												<table>
													<tr>

														<td class="lib"><b>Ref_demande :</b></td>
														<td><logic:notEqual parameter="action"
																value="supprimer">
																<html:text property="projaxemetier" styleClass="input"
																	size="14" maxlength="12"
																	onchange="return VerifierAlphanum(this);" />

															</logic:notEqual> <logic:equal parameter="action" value="supprimer">
																<bean:write name="projetForm" property="projaxemetier" />
															</logic:equal></td>

													</tr>
													<tr>
													</tr>
													<tr>
													</tr>
													<tr>
													</tr>

												</table>
											</td>

										</tr>
										<!--   fin HMI : PPM 61919 chapitre 6.8 -->

										<tr>
											<td>&nbsp;</td>
											<td><b><div id="reste"></div></b></td>
										</tr>
										<tr>
											<td class="lib">Code MO :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="clicode" styleClass="input" size="5"
														maxlength="5" onchange="VerifierClicode(this);" />
                   		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a
														href="javascript:rechercheIDMo('clicode');"
														onFocus="javascript:nextFocusIMOP();"><img border=0
														src="/images/p_zoom_blue.gif" alt="Rechercher Code Client"
														title="Rechercher Code Client" align="absbottom"></a>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="clicode" />
												</logic:equal> &nbsp;&nbsp;<bean:write name="projetForm" property="clilib" />
												<html:hidden property="clilib" /></td>
											<td width="30">&nbsp;</td>
											<td class="lib">Nom MO :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="imop" styleClass="input" size="22"
														maxlength="20" onchange="return VerifierAlphaMax(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="imop" />
												</logic:equal></td>
										</tr>
										<tr>
											<td class="lib">Code ME :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="codsg" styleClass="input" size="8"
														maxlength="7" onchange="return VerifierCodsg(this);" />
                   	    &nbsp;<a href="javascript:rechercheDPG();"
														onFocus="javascript:nextFocusICME();"><img border=0
														src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG"
														title="Rechercher Code DPG" align="absbottom"></a>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="codsg" />
												</logic:equal> &nbsp;&nbsp;<bean:write name="projetForm" property="libdsg" />
												<html:hidden property="libdsg" /></td>
											<td width="30">&nbsp;</td>
											<td class="lib">Nom ME : &nbsp;</td>
											<td colspan="2"><logic:notEqual parameter="action"
													value="supprimer">
													<html:text property="icme" styleClass="input" size="22"
														maxlength="20" onchange="return VerifierAlphaMax(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="icme" />
												</logic:equal></td>
										</tr>
										<tr>
										<tr>
											<td class="lib">Sercice Responsable Bancaire :&nbsp;</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="librpb" styleClass="input" size="22"
														maxlength="20" onchange="return VerifierAlphaMax(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="librpb" />
												</logic:equal></td>
											<td width="30">&nbsp;</td>
											<td class="lib">Nom Responsable Bancaire :&nbsp;</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="idrpb" styleClass="input" size="22"
														maxlength="20" onchange="return VerifierAlphaMax(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="idrpb" />
												</logic:equal></td>
										</tr>
										<tr>
											<td class="lib">Dossier projet :</td>
											<td>
												<% if ( ( "modifier".equals(projetForm.getAction()) && !"creer".equals(projetForm.getTopaction()) ) || "modifier".equals(projetForm.getTopaction()) ) {
                  		if ( "O".equals(projetForm.getDpactif() )) { %> <html:select
													property="icodproj" styleClass="input"
													onchange="refreshEcran(this.name);">
													<html:options collection="choixDossierProjet"
														property="cle" labelProperty="libelle" />
												</html:select> <html:hidden property="dplib" /> <html:hidden
													property="icodproj" /> <html:hidden property="dpactif" />
												<html:hidden property="count" value="<%=count%>" /> <%}
                  					else
                  					{%> <bean:write name="projetForm"
													property="dplib" /> - <bean:write name="projetForm"
													property="icodproj" /> <html:hidden property="dplib" /> <html:hidden
													property="icodproj" /> <%} 
                  						}%> <% if (  "creer".equals(projetForm.getAction()) || "creer".equals(projetForm.getTopaction()) ) {%>
												<html:select property="icodproj" styleClass="input"
													onchange="chargeLib(icodproj);">
													<html:options collection="choixDossierProjet"
														property="cle" labelProperty="libelle" />
												</html:select> <%} %> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="icodproj" />
												</logic:equal>
											</td>
											<td>&nbsp;</td>
											<td class="lib"><b>Code projet groupe:</b></td>
											<td colspan="2"><logic:notEqual parameter="action"
													value="supprimer">
													<html:text property="icpir" styleClass="input" size="7"
														maxlength="5" onchange="return VerifierAlphaMax(this);" />
													<html:hidden property="icpir" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="icpir" />
												</logic:equal></td>
										</tr>

										<tr>
											<td class="lib">Dossier Projet COPI :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<% if( pageContext.getAttribute("choixDpCopi") != null ) {%>
													<html:select property="dpcopi" styleClass="input"
														onchange="chargeLib(this.name);">
														<html:options collection="choixDpCopi" property="cle"
															labelProperty="libelle" />
													</html:select>
													<% } %>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="dpcopi" />
												</logic:equal></td>
											<td></td>

										</tr>
										<tr>
											<% if (projetForm.getDpcopi() == null || projetForm.getDpcopi().equals(""))
                  {%>
											<td class="lib">Lien NPSI (Domaine) :</td>
											<td colspan="3"><logic:notEqual parameter="action"
													value="supprimer">
													<html:select property="cod_db" styleClass="input">
														<html:options collection="choixDomBancaire" property="cle"
															labelProperty="libelle" />
													</html:select>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="lib_domaine" />

												</logic:equal></td>
											<%}
                  else {%>
											<td class="lib">Lien NPSI :</td>
											<td colspan="3"><bean:write name="projetForm"
													property="lib_domaine" /> <html:hidden
													property="lib_domaine" /> <html:hidden property="cod_db" />

											</td>
											<%} %>
										</tr>




										<tr>
											<td class="lib">Statut :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:select property="statut" styleClass="input">
														<html:options collection="statutsProjet" property="cle"
															labelProperty="libelle" />
													</html:select>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="statut" />
												</logic:equal></td>
											<td></td>
											<td class="lib">Date de prise en compte du statut :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="dateDemarrage" styleClass="input"
														size="7" maxlength="7"
														onchange="return VerifierDate(this, 'mm/aaaa');" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="dateDemarrage" />
												</logic:equal></td>
										</tr>
										<logic:notEqual name="projetForm" property="topaction"
											value="creer">
											<tr id="ligneImmo">
												<td class="lib">Top envoyé :</td>
												<td><logic:notEqual parameter="action"
														value="supprimer">
														<html:select property="topenvoi" styleClass="input"
															onchange="affiche_date();">
															<html:options collection="choixTopEnvoi" property="cle"
																labelProperty="libelle" />
														</html:select>
													</logic:notEqual> <logic:equal parameter="action" value="supprimer">
														<bean:write name="projetForm" property="topenvoi" />
													</logic:equal></td>
												<td width="30">&nbsp;</td>
												<td class="lib" id="envoi">Date envoi immobilisation :</td>
												<td id="envoi1"><logic:notEqual parameter="action"
														value="supprimer">
														<html:text property="date_envoi" styleClass="input"
															size="10" maxlength="10"
															onchange="return VerifierDate(this, 'jj/mm/aaaa');" />
													</logic:notEqual> <logic:equal parameter="action" value="supprimer">
														<bean:write name="projetForm" property="date_envoi" />
													</logic:equal></td>

											</tr>
										</logic:notEqual>

										<tr>

											<td class="lib"><b>CADA :</b></td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="cada" styleClass="input" size="5"
														maxlength="5" onchange="return VerifierCada(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="cada" />
												</logic:equal> &nbsp;&nbsp;<bean:write name="projetForm"
													property="libcada" /> <html:hidden property="libcada" /></td>
											<td width="30">&nbsp;</td>
											<td class="lib">Durée d'amortissement en mois :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="dureeamor" styleClass="input" size="3"
														maxlength="3" onchange="return VerifierDurAmor(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="dureeamor" />
												</logic:equal></td>
										</tr>
										<!--  
                <tr>
                  <td class="lib" >Ensemble Applicatif -<br/>Domaine Bancaire:</td>
                  <td colspan="4"> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="cod_db" styleClass="input"> 
   						<html:options collection="choixDomBancaire" property="cle" labelProperty="libelle" />
					  </html:select>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="projetForm"  property="cod_db" />
                    </logic:equal>                   
                  </td>
                </tr>
 -->
										<tr>
											<td class="lib">Date initiale de mise en production :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<% if  ("OUI".equals(projetForm.getDuplic())) {%>
													<html:text property="datprod" styleClass="input" size="7"
														maxlength="7"
														onchange="return VerifierDate( this, 'mm/aaaa' );" />
													<%}else{%>
													<html:text property="datprod" styleClass="input" size="7"
														maxlength="7"
														onchange="return VerifierDate( this, 'mm/aaaa' );" />
													<%}%>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datprod" />
												</logic:equal></td>
											<td width="30">&nbsp;</td>
											<td class="lib">Date de dernière modification du statut
												:</td>
											<td><logic:equal parameter="action" value="supprimer">
													<input type="hidden" name="dateStatut" value="">
												</logic:equal> <logic:notEqual parameter="duplic" value="OUI">
													<bean:write name="projetForm" property="dateStatut" />
													<html:hidden property="dateStatut" />
												</logic:notEqual></td>
										</tr>
										<tr>
											<td class="lib">Critère de regroupement :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="crireg" styleClass="input" size="7"
														maxlength="5" onchange="return VerifierAlphanum(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="crireg" />
												</logic:equal></td>
											<td width="30">&nbsp;</td>
											<td class="lib">Date révisée de mise en production :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<% if  ("OUI".equals(projetForm.getDuplic())) {%>
													<html:text property="datrpro" styleClass="input" size="7"
														maxlength="7"
														onchange="return VerifierDate( this, 'mm/aaaa' );" />
													<%}else{%>
													<html:text property="datrpro" styleClass="input" size="7"
														maxlength="7"
														onchange="return VerifierDate( this, 'mm/aaaa' );" />
													<%}%>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datrpro" />
												</logic:equal></td>
										</tr>
										<tr>
											<td class="lib">Liens code Projet/CA :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:select property="licodprca" styleClass="input">
														<bip:options collection="choixLienCodeProjetCA" />
													</html:select>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="licodprca" />
													<html:hidden property="licodprca" />
												</logic:equal></td>
											<td width="30">&nbsp;</td>
											<td class="lib">Dernière année de restitution :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="deanre" styleClass="input" size="7"
														maxlength="7"
														onchange="return VerifierDate( this, 'aaaa' );" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="deanre" />
												</logic:equal></td>
										</tr>
										<!-- Début Données CA 1 -->
										<!--  purpose 307-->

										<tr>
											<td class="lib">Code CA1 :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<%-- <html:select property="codcamo1" styleClass="input">
														<html:options collection="choixCa" property="cle"
															labelProperty="libelle" />
													</html:select> --%>
													<%-- <html:text property="codcamo1" styleClass="input" size="60" maxlength="60" />
                  								 <span	id="indicator1" style="display:none;"><img
															src="../images/indicator.gif" alt="" /></span> --%>
													<html:text property="codcamo1" styleClass="input" size="40"
														maxlength="80" onchange="return VerifierAlphanum(this);" />
                   	    &nbsp;<a href="javascript:rechercheCodcamo1();"><img
														border=0 src="/images/p_zoom_blue.gif"
														alt="Rechercher Codecamo" title="Rechercher Codecamo"
														align="absbottom"></a>

												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="codcamo1" />
                    	&nbsp;&nbsp;<bean:write name="projetForm"
														property="clibca1" />
													<html:hidden property="codcamo1" />
												</logic:equal></td>

											<td width="30">&nbsp;</td>

											<td class="lib">Date de validité du lien CA1 :</td>
											<td><logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datvalli1" />
													<html:hidden property="datvalli1" />
												</logic:equal> <logic:notEqual parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datvalli1" />
													<html:hidden property="datvalli1" />
												</logic:notEqual></td>
										</tr>

										<tr>
											<td class="lib">Responsable de la validation du lien CA1
												:</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="respval1" styleClass="input" size="40"
														maxlength="40" onchange="return VerifierAlphaMax(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="respval1" />
												</logic:equal></td>
										</tr>
										<!-- Fin Données CA 1 -->
										<!-- Début Données CA 2 -->
										<tr>
											<td class="lib">Code CA2 :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<%-- <html:select property="codcamo2" styleClass="input">
														<html:options collection="choixCa" property="cle"
															labelProperty="libelle" />
													</html:select> --%>
													<html:text property="codcamo2" styleClass="input" size="40"
														maxlength="80" onchange="return VerifierAlphanum(this);" />
                   	    &nbsp;<a href="javascript:rechercheCodcamo2();"><img
														border=0 src="/images/p_zoom_blue.gif"
														alt="Rechercher Codecamo" title="Rechercher Codecamo"
														align="absbottom"></a>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="codcamo2" />
                    	&nbsp;&nbsp;<bean:write name="projetForm"
														property="clibca2" />
													<html:hidden property="codcamo2" />
												</logic:equal></td>

											<td width="30">&nbsp;</td>

											<td class="lib">Date de validité du lien CA2 :</td>
											<td><logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datvalli2" />
												</logic:equal> <logic:notEqual parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datvalli2" />
													<html:hidden property="datvalli2" />
												</logic:notEqual></td>
										</tr>

										<tr>
											<td class="lib">Responsable de la validation du lien CA2
												:</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="respval2" styleClass="input" size="40"
														maxlength="40" onchange="return VerifierAlphaMax(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="respval2" />
												</logic:equal></td>
										</tr>
										<!-- Fin Données CA 2 -->
										<!-- Début Données CA 3 -->
										<tr>
											<td class="lib">Code CA3 :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<%-- <html:select property="codcamo3" styleClass="input">
														<html:options collection="choixCa" property="cle"
															labelProperty="libelle" />
													</html:select> --%>
													<html:text property="codcamo3" styleClass="input" size="40"
														maxlength="80" onchange="return VerifierAlphanum(this);" />
                   	    &nbsp;<a href="javascript:rechercheCodcamo3();"><img
														border=0 src="/images/p_zoom_blue.gif"
														alt="Rechercher Codecamo" title="Rechercher Codecamo"
														align="absbottom"></a>

												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="codcamo3" />
                    	&nbsp;&nbsp;<bean:write name="projetForm"
														property="clibca3" />
													<html:hidden property="codcamo3" />
												</logic:equal></td>

											<td width="30">&nbsp;</td>

											<td class="lib">Date de validité du lien CA3 :</td>
											<td><logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datvalli3" />
												</logic:equal> <logic:notEqual parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datvalli3" />
													<html:hidden property="datvalli3" />
												</logic:notEqual></td>
										</tr>

										<tr>
											<td class="lib">Responsable de la validation du lien CA3
												:</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="respval3" styleClass="input" size="40"
														maxlength="40" onchange="return VerifierAlphaMax(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="respval3" />
												</logic:equal></td>
										</tr>
										<!-- Fin Données CA 3 -->
										<!-- Début Données CA 4 -->
										<tr>
											<td class="lib">Code CA4 :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<%-- <html:select property="codcamo4" styleClass="input">
														<html:options collection="choixCa" property="cle"
															labelProperty="libelle" />
													</html:select> --%>
													<html:text property="codcamo4" styleClass="input" size="40"
														maxlength="80" onchange="return VerifierAlphanum(this);" />
                   	    &nbsp;<a href="javascript:rechercheCodcamo4();"><img
														border=0 src="/images/p_zoom_blue.gif"
														alt="Rechercher Codecamo" title="Rechercher Codecamo"
														align="absbottom"></a>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="codcamo4" />
                    	&nbsp;&nbsp;<bean:write name="projetForm"
														property="clibca4" />
													<html:hidden property="codcamo4" />
												</logic:equal></td>

											<td width="30">&nbsp;</td>

											<td class="lib">Date de validité du lien CA4 :</td>
											<td><logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datvalli4" />
												</logic:equal> <logic:notEqual parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datvalli4" />
													<html:hidden property="datvalli4" />
												</logic:notEqual></td>
										</tr>

										<tr>
											<td class="lib">Responsable de la validation du lien CA4
												:</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="respval4" styleClass="input" size="40"
														maxlength="40" onchange="return VerifierAlphaMax(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="respval4" />
												</logic:equal></td>
										</tr>
										<!-- Fin Données CA 4 -->
										<!-- Début Données CA 5 -->
										<tr>
											<td class="lib">Code CA5 :</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<%-- <html:select property="codcamo5" styleClass="input">
														<html:options collection="choixCa" property="cle"
															labelProperty="libelle" />
													</html:select> --%>
													<html:text property="codcamo5" styleClass="input" size="40"
														maxlength="80" onchange="return VerifierAlphanum(this);" />
                   	    &nbsp;<a href="javascript:rechercheCodcamo5();"><img
														border=0 src="/images/p_zoom_blue.gif"
														alt="Rechercher Codecamo" title="Rechercher Codecamo"
														align="absbottom"></a>
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="codcamo5" />
                    	&nbsp;&nbsp;<bean:write name="projetForm"
														property="clibca5" />
													<html:hidden property="codcamo5" />
												</logic:equal></td>

											<td width="30">&nbsp;</td>

											<td class="lib">Date de validité du lien CA5 :</td>
											<td><logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datvalli5" />
												</logic:equal> <logic:notEqual parameter="action" value="supprimer">
													<bean:write name="projetForm" property="datvalli5" />
													<html:hidden property="datvalli5" />
												</logic:notEqual></td>
										</tr>

										<tr>
											<td class="lib">Responsable de la validation du lien CA5
												:</td>
											<td><logic:notEqual parameter="action" value="supprimer">
													<html:text property="respval5" styleClass="input" size="40"
														maxlength="40" onchange="return VerifierAlphaMax(this);" />
												</logic:notEqual> <logic:equal parameter="action" value="supprimer">
													<bean:write name="projetForm" property="respval5" />
												</logic:equal></td>
										</tr>
										<!-- Fin Données CA 5 -->


										<tr>
											<td>&nbsp;</td>
										</tr>
									</table>
								</div></td>
					</tr>
					<tr>
						<td align="center">
							<table width="100%" border="0">
								<tr>
									<td width="5%">&nbsp;</td>
									<td width="60%">
										<% if ( ("OUI".equals(projetForm.getDuplic())) ) {%>
										<div align="center">
											<table width="100%" border="0">
												<tr>
													<td align="right"><html:submit
															property="boutonValider" value="Valider"
															styleClass="input"
															onclick="Verifier(this.form, 'valider', this.form.mode.value='insert',true,'NON');" />
													</td>
													<logic:notEqual parameter="action" value="supprimer">
														<td align="center"><html:submit
																property="boutonValider" value="Imprimer"
																styleClass="input"
																onclick="Verifier(this.form, 'valider', this.form.mode.value='insert',true,'OUI');" />
														</td>
													</logic:notEqual>
													<logic:equal parameter="action" value="supprimer">
														<td>&nbsp;</td>
													</logic:equal>
												</tr>
											</table>
										</div> <%}else{%>
										<div align="center">
											<table width="100%" border="0">
												<tr>
													<td align="right"><html:submit
															property="boutonValider" value="Valider"
															styleClass="input"
															onclick="Verifier(this.form, 'valider', this.form.mode.value,true,'NON');" />
													</td>
													<logic:notEqual parameter="action" value="supprimer">
														<td align="center"><html:submit
																property="boutonValider" value="Imprimer"
																styleClass="input"
																onclick="Verifier(this.form, 'valider', this.form.mode.value,true,'OUI');" />
														</td>
													</logic:notEqual>
													<logic:equal parameter="action" value="supprimer">
														<td>&nbsp;</td>
													</logic:equal>
												</tr>
											</table>
										</div> <%}%>
									</td>
									<td width="30%">
										<div align="left">
											<html:submit property="boutonAnnuler" value="Annuler"
												styleClass="input"
												onclick="Verifier(this.form, 'annuler', null, false);" />
										</div>
									</td>
									<td width="5%">&nbsp;</td>
								</tr>
							</table> </html:form>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<div align="center">
								<html:errors />
							</div>
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
<% 
Integer id_webo_page = new Integer("1024"); 
com.socgen.bip.commun.form.AutomateForm formWebo = projetForm ;
%>
<%@ include file="/incWebo.jsp"%>
</html:html>