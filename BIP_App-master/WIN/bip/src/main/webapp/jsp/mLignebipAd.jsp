<!DOCTYPE html>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.ListeOption,java.util.Iterator,com.socgen.bip.commun.Tools"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneBipForm" scope="request" class="com.socgen.bip.form.LigneBipForm" />
<html:html locale="true"> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 
<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<bip:VerifUser page="jsp/bLignebipAd.jsp"/>
<%
com.socgen.bip.commun.liste.ListeDynamique listeDynamique = new com.socgen.bip.commun.liste.ListeDynamique();
String valDPCOPI = ligneBipForm.getDpcopi();


java.util.ArrayList list_cli_dbs =new java.util.ArrayList();
list_cli_dbs = listeDynamique.getListeDynamique("listerclientsdbs",ligneBipForm.getHParams()); 
Iterator it_client_dbs=list_cli_dbs.iterator();
boolean client_dbs=false;
boolean dbs_obligatoire=false;
boolean dpcopieInList = false;
String str_clicode=request.getParameter("clicode");

// SEL 25/06/204 PPM 58143 QC 1624
if (ligneBipForm.getMode()=="update")
{
	str_clicode=ligneBipForm.getClicode();
}

while(it_client_dbs.hasNext())
{
	ListeOption lo=(ListeOption)it_client_dbs.next();

	if(lo.getCle().equals(str_clicode))
	{ // chercher le code client qui appartient a la liste des branches/directions du parametre OBLIGATION DBS
		client_dbs=true;
		break;
	}
	else
	{
		client_dbs=false;
	}
}

while(it_client_dbs.hasNext())
{
	ListeOption listOpt=(ListeOption)it_client_dbs.next();
	if(listOpt.getLibelle().equals("OUI")){ // récupère l'obligation ou non du DBS
		dbs_obligatoire=true;
		break;
	}
	else
	{
		dbs_obligatoire=false;
		break;
	}
}

//ABN - QC 1893
String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
String sdossierprojet;
String projetAvantModif = ligneBipForm.getIcpi(); 
if (ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("dpcode"))) == null)
	sdossierprojet = ligneBipForm.getCodeDPAvantModif();
else
	sdossierprojet = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("dpcode")));

// On récupère le menu courant	
com.socgen.bip.menu.item.BipItemMenu menu = ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getCurrentMenu();
String menuId = menu.getId();
//HP PPM 61434 - ABN - On récupère les sous menu de l'utilisateur
String sousMenus = ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getSousMenus().toLowerCase();
// Booléen qui dit si c'est un Grand T1
boolean grdT1 = ("1 ".equals(ligneBipForm.getTypproj())) && ("T1".equals(ligneBipForm.getArctype()));
boolean sTyp = ((("1 ".equals(ligneBipForm.getTypproj())) || ("2 ".equals(ligneBipForm.getTypproj()))) && (client_dbs));

boolean icpi_statut = ("N".equals(ligneBipForm.getStatut()) || "O".equals(ligneBipForm.getStatut()) || ligneBipForm.getStatut() == null  || "".equals(ligneBipForm.getStatut()));
boolean dpcode_actif = "O".equals(ligneBipForm.getActif());
String AfficheMessage = ligneBipForm.getAffichemessage();

//FAD PPM 64240
ligneBipForm.setAfficherDpcopi(false);
if (grdT1 && ligneBipForm.getDpcode() != null && ligneBipForm.getDpcode() != "" && !ligneBipForm.getDpcode().equals("00000") && !ligneBipForm.getDpcode().equals("") && !ligneBipForm.getDpcode().equals(null))
{
	String clicode = ligneBipForm.getClicode();
	//dev fad 64240
	//boolean afficherDpcopi= Tools.isClientBBRF03(clicode);
	ligneBipForm.setAfficherDpcopi(true);
}

Hashtable hKeyList= new Hashtable();
try
{
	java.util.ArrayList list10 = new ArrayList();
	java.util.ArrayList list5 = new ArrayList();
	java.util.ArrayList list1 = listeDynamique.getListeDynamique("type1",ligneBipForm.getHParams()); 
	java.util.ArrayList list2 = listeDynamique.getListeDynamique("type2",ligneBipForm.getHParams()); 
	java.util.ArrayList list3 = listeDynamique.getListeDynamique("projspec",ligneBipForm.getHParams()); 

	java.util.ArrayList list6 = listeDynamique.getListeDynamique("dossier_projet",ligneBipForm.getHParams()); 
	java.util.ArrayList list7 = listeDynamique.getListeDynamique("sous_typo",ligneBipForm.getHParams());
	java.util.ArrayList list9 = listeDynamique.getListeDynamique("dossier_projet_nonGT1",ligneBipForm.getHParams()); //KRA - PPM 59288 : dossier_projet_nonGT1

	pageContext.setAttribute("choixTypproj", list1);
	pageContext.setAttribute("choixArctype", list2);
	pageContext.setAttribute("choixProjspe", list3);
	pageContext.setAttribute("choixDProjets",list6);
	pageContext.setAttribute("choixSous_typo", list7);
	pageContext.setAttribute("choixDProjetsNonGT1", list9);//PPM 59288   
     
	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	hKeyList.put("codsg", ""+ligneBipForm.getCodsg());
	hKeyList.put("typproj", ""+ligneBipForm.getTypproj());
	hKeyList.put("ca_payeur", ""+ligneBipForm.getCodcamo());
	java.util.ArrayList listeMetier = listeDynamique.getListeDynamique("rubrique_metier_type", hKeyList);
	pageContext.setAttribute("choixMetier", listeMetier);

	if ( (ligneBipForm.getCodcamo()!=null) && (ligneBipForm.getCodcamo().equals("66666")) ) {
		java.util.ArrayList list8 = listeDynamique.getListeDynamique("table_repart",hKeyList);
		pageContext.setAttribute("choixCodrep", list8);
	}

	//SEL PPM 63412
	if(ligneBipForm.getDpcode() != null)
	{
		ligneBipForm.getHParams().put("dpcode", ligneBipForm.getDpcode());
	}

	if(ligneBipForm.isAfficherDpcopi())
	{
		list10 = listeDynamique.getListeDynamique("dpcopipardpccode2",ligneBipForm.getHParams());
		pageContext.setAttribute("choixDossProjCopi", list10);
		if (ligneBipForm.getDpcopi() == null || ligneBipForm.getDpcopi() == "" || ligneBipForm.getDpcopi() == "null")
		{
			if (list10.size() == 2)
				ligneBipForm.setDpcopi(((ListeOption) list10.get(1)).getCle());
			else
			{
				if (list10.size() == 3)
					ligneBipForm.setDpcopi(((ListeOption) list10.get(2)).getCle());
				else
					ligneBipForm.setDpcopi(((ListeOption) list10.get(0)).getCle());
			}
		}
		ligneBipForm.getHParams().put("dpcopi", ligneBipForm.getDpcopi());
		list5 = listeDynamique.getListeDynamique("projet2",ligneBipForm.getHParams());
		pageContext.setAttribute("choixProjets", list5);

		if (list5.size() == 1)
		{
			String cle = ((ListeOption) list5.get(0)).getCle();
			if (cle != " " && cle != "" && cle != null && !cle.equals(" ") && !cle.equals("") && !cle.equals(null))
			{
				if (ligneBipForm.getFocus() == "" || ligneBipForm.getFocus() == null || ligneBipForm.getFocus().equals("") || ligneBipForm.getFocus().equals(null))
					ligneBipForm.setFocus("codsg");
			}
		}
		else
			ligneBipForm.setFocus(null);
	}
	else
	{
		list5 = listeDynamique.getListeDynamique("projet",ligneBipForm.getHParams());
		pageContext.setAttribute("choixProjets", list5);
	}
}
catch (Exception e)
{
	%>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
}
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;

var pageAide = "<%= sPageAide %>";
var rafraichiEnCours = false;
var duplic = "<bean:write name="ligneBipForm"  property="duplic" />";
var AfficheMessage = "<%= AfficheMessage %>";
var r_dpcode = null;
<% if 	(ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("dpcode"))) == null || "".equals(ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("dpcode"))) ) ) %>
	r_dpcode = null;
<% else %>
	r_dpcode = <%=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("dpcode")))%>;//PPM 59288 : pour tester si on est dans le premier chargement de la page	 	


function MessageInitial()
{
   	var Message="<bean:write filter="false"  name="ligneBipForm"  property="msgErreur" />";
   	var Focus = "<bean:write name="ligneBipForm"  property="focus" />";
   	var mode = "<bean:write name="ligneBipForm"  property="mode" />";
   	var exclure = "0";
   	
   	
   	
  //PPM 58315 : Changement message CA Payeur fonction ligne BIP
   	if (Message != "") {
   	  if (("<%=menuId%>"=="DIR" || ("ME"=="<%=menuId%>" && <%=sousMenus.indexOf("ges")%> >= 0)) && Message == "Le CA étant en cessation d'activité, veuillez saisir un autre code valide") {
   	  		document.forms[0].codcamo.focus();
   	  }
   	  alert(Message);
   	}
   	
   	if (document.forms[0].action.value == "refresh")
   	{
   		
   		if(document.forms[0].codcamo.value == "24000" ||
   			document.forms[0].codcamo.value == "23000" ||
   			document.forms[0].codcamo.value == "22000" ||
   			document.forms[0].codcamo.value == "00000")
   		{
   			exclure = "1";
   			
   		}
   		else
   			exclure = "0";
  	}
   	
   	if (AfficheMessage == "oui" && exclure ==  "0" )
   		alert("Attention: le CA payeur n'appartient pas à la branche du client - Merci de vérifier");
  
    if (Focus != "") {
       (eval( "document.forms[0]."+Focus )).focus();
   	}
   	else {
   		if(duplic=="OUI" || (duplic==="NON" && mode==="update")){
        	document.forms[0].pnom.focus();
		}
		if(duplic==="NON" && mode==="insert"){
			document.forms[0].pdatdebpre.focus();
		}
		
	}
	
   	 //forcer mode à insert si duplic egale à OUI
   
    if(duplic=="OUI"){
          document.forms[0].mode.value = "insert";
    //} debut PPM 59288 : on maintient le blocage actuel qu'En CREATION A PARTIR DE d'une ligne non GT1     
	// Function de refresh pour le cas où 
	// le dossier projet d'une ligne hors Grd T1
	// n'est pas égal à 0 (En raison de l'historique)	
	  if ((r_dpcode ==null) && (<%= grdT1%> == false) && (document.forms[0].dpcode.value != "00000") && !IsDirPrinImmo(document.forms[0].dpcode)){ 
		//alert("Seules les lignes de T1 doivent être rattachées à un dossier projet.\nLe dossier projet actuel va être réinitialisé");
		alert("ATTENTION : le type de ligne et le DP choisi ne sont pas compatibles compte tenu de la direction rattachée au DP");
		//document.forms[0].dpcode.value = "00000";
		rafraichir(document.forms[0]);
		rafraichiEnCours = true;
		}
	} 
	
	//Fin PPM 59288

	
	if ((<%= grdT1%> == true) && ((document.forms[0].dpcode.value == "00000")|| (document.forms[0].dpcode.value == ""))){
		document.forms[0].icpi.value = "";
	}	
	
}

function basculeTypologie(type){
	if (("<%=menuId%>"=="DIR") && (<%= grdT1%> == true) && (type.value !="T1")){
		if (document.forms[0].dpcode.value != "00000" && !IsDirPrinImmo(document.forms[0].dpcode)){ 
		alert("ATTENTION : le type de ligne et le DP choisi ne sont pas compatibles compte tenu de la direction rattachée au DP");
		//document.forms[0].dpcode.value = "00000";
		//rafraichiEnCours=false;		
		rafraichir(document.forms[0]);
		rafraichiEnCours = true;
		}
	}
	return false;
	}
	
function ChangeType2(type2){
	// si on passe de T1 à t1 ou vice versa, on rafraîchi
	if (("<%=menuId%>"=="DIR") && ((type2.value=="T1") || (type2.value=="P1"))){
		rafraichir(document.forms[0]);
		rafraichiEnCours = true;
	}
}

function chargeLib(libCherche) {
	if(!rafraichiEnCours)
	{ 
        document.forms[0].focus.value = libCherche;
        rafraichir(document.forms[0]);
		rafraichiEnCours = true;
	}
}

function refreshEcran() {
	if(!rafraichiEnCours)
	{     
        rafraichir(document.forms[0]);
		rafraichiEnCours = true;
	}
}


function raffraichiListe(){
	if(!rafraichiEnCours)
	{
	    
		rafraichir(document.forms[0]);
		rafraichiEnCours = true;
		
	}
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


function VerifierCodeApplication(champ)
{ 
	if (VerifierAlphaMax(champ)) {	 	   
	 
	  <%if(ligneBipForm.getMode().equals("update") && ligneBipForm.isRealiseAnterieurNotNullDiffZero()
			 &&  (!ligneBipForm.getCodeAppliAvantModif().equals("A0000"))   &&  (!ligneBipForm.getCodeAppliAvantModif().equals("A9000"))  )  {
		  
   	    	if(menuId.equals("DIR")) {%>	    	 	       	        
		    		 alert("<%=ligneBipForm.getMessageAdminBlocage()%>") ;   		 
	    	<%}else{%> 
	     			 alert("<%=ligneBipForm.getMessageMeBlocage() %>") ;   
	       		     champ.value = "<%=ligneBipForm.getCodeAppliAvantModif() %>" ;
			<%}
	    	
	   }%>
	       
       refreshEcran();
   
   }
		
}



// FAD PPM 64183 : Suppression de la fonction VerifierMetier() de champ "Métier"


function VerifierDpCode(valeurDpCode)
{ 
	

  <%
	//Si ligne Grand T1 
  //Si possède du réal ou arbitré -> message de blocage
  if( ligneBipForm.getMode().equals("update") && grdT1 &&  ( ligneBipForm.isRealiseAnterieurNotNullDiffZero() || ligneBipForm.isArbitreActuelNotNullDiffZero() )  ) {  
		    if(menuId.equals("DIR")) {%>
	    		 alert("<%=ligneBipForm.getMessageAdminBlocage()%>");
	    	<%}else{%>
     			 alert("<%=ligneBipForm.getMessageMeBlocage()%>"); 
       		     valeurDpCode.value = "<%=ligneBipForm.getCodeDPAvantModif()%>"; 
		 	<%} 
  }  //Fin si Update  %> 


	  
  raffraichiListe() ; 
}

function Verifier(form, action,mode, flag)
{
   //ValiderEcran(form);
     if(duplic=="OUI")
      document.forms[0].mode.value = "insert";
        
   blnVerification = flag;
   form.action.value = action;
  
}

function Annuler(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
}

/*******************************************************************
** Ajoute la fonction trim comme méthode de l'objet String.       **
** Exemple :                                                      **
**              var tmp = s.trim();                               **
*******************************************************************/
String.prototype.trim = function()
{ return this.replace(/(^\s*)|(\s*$)/g, ""); }


function mettreAvide(p_type,p_param_id){
	<% String userid = ((UserBip)request.getSession().getAttribute("UserBip")).getIdUser(); %>
	// Appel ajax de la mÃ©thode de l'action
	ajaxCallRemotePage('/ligneBip.do?action=mettreAvide&type='+p_type+'&param_id='+p_param_id+'&userid='+'<%=userid%>');
	// Si la rÃ©ponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
	
}

function verifierligneaxemetier2(p_pid,p_ligneaxemetier2,typproj,arctype,clicode,codsg,pzone){
	// Appel ajax de la mÃ©thode de l'action 
	//QC 2008 chnages to add typproj,arctype,clicode,codsg,pzone
	ajaxCallRemotePage('/ligneBip.do?action=verifierligneaxemetier2&pid='+p_pid+'&ligneaxemetier2='+p_ligneaxemetier2+'&typproj='+typproj+'&arctype='+arctype+'&clicode='+clicode+'&codsg='+codsg+'&pzone='+pzone);
	// Si la rÃ©ponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
	
}

//QC 2008 chnages to add typproj,arctype,clicode,codsg,pzone
function verifierAxe(p_pid,p_ligneaxemetier2,typproj,arctype,clicode,codsg,pzone)
{

	var result = verifierligneaxemetier2(p_pid,p_ligneaxemetier2,typproj,arctype,clicode,codsg,pzone);
	//alert("result is :"+result);
    var tab = result.split(';');
    var type = tab[0];
    var param_id = tab[1];
    var message = tab[2];
    //alert("type : "+type);
   // alert("param_id : "+param_id);
   // alert("message : "+message);
    if(message =='PROCEED' || message =='NOLINK')
  	 {
   	 
   	 return true;
  	 }
    else
    {
    if(message =='GOBACK')
    {
    
   	  alert("L'axe métier Ligne 2 est absent ou incorrect");
  	  	return false;
    }
    else
    {
    	if(message!="" && message.substring(0,9).toUpperCase() == 'ATTENTION')
    	{
   		
   	 	if(confirm(message))
   	 	{
   	    	mettreAvide(type,param_id);
   	    	
   	       	return verifierAxe(p_pid,p_ligneaxemetier2,typproj,arctype,clicode,codsg,pzone);
   	    }
   	    else 
   	    {
   	       	document.forms[0].ligneaxemetier2.focus();
   	       	return false;
   	    }
   	}
   	
   }
    
    
}
}


function ValiderEcran(form)
{

if (blnVerification == true) {
 
     if (!ChampObligatoire(form.pnom, "le nom de la ligne BIP")) return false;
     if (!ListeObligatoire(form.typproj, "le type de projet")) return false; 
     if (!ListeObligatoire(form.arctype, "le type d'activité")) return false;
     if (!ChampObligatoire(form.pdatdebpre, "la date de début")) return false;
     
      
     if((form.arctype.value == 'T1') && ((form.document.forms[0].dossierprojet.value == '00000') || (form.document.forms[0].dossierprojet.value == '')))
     {
          alert("Le code dossier projet est obligatoire");
          return false;
      }
     
	 //PPM 59288 : contrôle de validité du DP après le clic sur <<Valider>>
	 //PPM 61695 : if(!VerifierDirDbs(form.document.forms[0].dossierprojet)){
	if(!VerifierDirImmo(form.document.forms[0].dossierprojet)){
	return false;
	}
        
     if (!ChampObligatoire(form.codsg, "le code Département/Pôle/Groupe")) return false;
     if (!ChampObligatoire(form.pcpi, "le code du responsable de la ligne")) return false;
     if (!ChampObligatoire(form.clicode, "le code maître d'ouvrage")) return false;
     if (!ChampObligatoire(form.liste_objet, "la première ligne de l'objet")) return false;
     if (!ListeObligatoire(form.icpi, "le code projet informatique")) return false;
     if (!ChampObligatoire(form.airt, "le code application")) return false;
     if (!ListeObligatoire(form.metier, "le metier")) return false;
     
     //Bip defect 379 changes are done
	 document.forms[0].pobjet.value = document.forms[0].liste_objet.value;
	 var pType = form.typproj.value.trim();
	 /* On interdit la gestion du multi CA sur les lignes de type GT1, 7 et 9 */
	 if ( (form.codcamo.value=="66666") && ((pType == "1")  && ( form.arctype.value == "T1" ) || (pType == "7") || (pType == "9"))  ) {
	     alert("Ce type de ligne n'est pas compatible avec l'utilisation du multiCA payeur 66666");
	     return false;
	 }
    
    if (<%= sTyp && dbs_obligatoire%> == true) {if (!ListeObligatoireDBS(form.sous_typo, "le DBS")) return false;}
// Debut FAD PPM 64269: Regul HMI- PPM 63824  
//QC 1888

	
	<% String codedp1 = ligneBipForm.getCodeDPAvantModif();
	 /* Using the form element to get the code projet value for comparision*/
	 String copeproj  = ligneBipForm.getCodePrjAvantModif();
	%>
	
	var choixPrecDP1 = "<%=codedp1%>";
	var copeproj1 = "<%=copeproj%>";

	
	if (document.forms[0].mode.value == "insert") {
	//add typproj,arctype,clicode,codsg,pzone
	         return verifierAxe(document.forms[0].pnom.value,document.forms[0].ligneaxemetier2.value,
	         document.forms[0].typproj.value,document.forms[0].arctype.value,
	         document.forms[0].clicode.value,document.forms[0].codsg.value
	         ,document.forms[0].pzone.value); // MCH : QC1811
	
	 }
	
	//user story 29 - verify ligneaxemetier2
	if (document.forms[0].mode.value == "update") {
			//add typproj,arctype,clicode,codsg,pzone
			//alert("in axemetier check");
			var  isValidDp = true;
	        var  isValidLigne= verifierAxe(document.forms[0].pid.value,document.forms[0].ligneaxemetier2.value,
	         document.forms[0].typproj.value,document.forms[0].arctype.value,
	         document.forms[0].clicode.value,document.forms[0].codsg.value
	         ,document.forms[0].pzone.value); // MCH : QC1811
	         
	//alert("isValid"+isValid);
	//form.typproj.value.trim()
	
	//ABN - QC 1891
	if ((document.forms[0].mode.value == "update") && (!<%="DIR".equals(menuId)%>) && ((document.forms[0].icpi.value != "<%=copeproj%>" ) || ("<%=codedp1%>" != "<%=ligneBipForm.getDpcode()%>" ))){
	  var result = verifierMajDpProj(document.forms[0].pid.value,document.forms[0].dpcode.value,document.forms[0].icpi.value,document.forms[0].clicode.value,document.forms[0].codsg.value);
	//alert("result"+result);
    var tab = result.split(';');
    var message = tab[0];
    var codeproj = tab[1];
   
        	
	  if(message!=null && message!=""){
			alert (message);
			<% String codedp = ligneBipForm.getCodeDPAvantModif();%>
			
			var choixPrecDP = "<%=codedp%>";
 			document.forms[0].dpcode.value = choixPrecDP;
			document.forms[0].dpcode.focus();
			
    	          
           document.forms[0].update_controle.value = true;
       	   
       	   rafraichir(document.forms[0]);
   		   rafraichiEnCours = true;
   		
			//return false;
			isValidDp=false;
			
	  }
	  else  isValidDp=true;//return true;
	
	}
	if(!isValidLigne){
		document.forms[0].ligneaxemetier2.focus();
		return isValidLigne;
		}
	else
		return isValidDp;
	
 }		
	// FIN FAD PPM 64269: Regul HMI - PPM 63824
	
	 
	
if (document.forms[0].pobjet) {
	 chaine="";
	 for (Cpt=0; Cpt < document.forms[0].pobjet.value.length; Cpt++ ) {
		if ((form.pobjet.value.charAt(Cpt)!=" ")&&(escape(form.pobjet.value.charAt(Cpt))!="%0D")&&(escape(form.pobjet.value.charAt(Cpt))!="%0A")){
			chaine = chaine+form.pobjet.value.charAt(Cpt);
		}
	 }
	 if (chaine.length==0) {
		alert("Entrez l'objet de la ligne BIP");
		form.liste_objet.focus();
		return false;
	 }
	 if (form.mode.value == "update") {
	 	 if (!ChampObligatoire(form.clicode_oper, "le code maître d'ouvrage Opérationnel")) return false;
         if (!confirm("Voulez-vous modifier cette ligne bip ?")) return false;
     }
   	return true;
} else {
	alert('ERREUR');
	return false;
}
	}

}

// Debut FAD PPM 64269: Regul HMI PPM  : 63824
function verifierMajDpProj(p_pid,p_dpcode,p_icpi,p_clicode,p_codsg){
	// Appel ajax de la méthode de l'action 
	ajaxCallRemotePage('/ligneBip.do?action=verifierMajDpProj&pid='+p_pid+'&dpcode='+p_dpcode+'&icpi='+p_icpi+'&clicode='+p_clicode+'&codsg='+p_codsg);
	// Si la réponse ajax est non vide :
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
	
}
//Fin FAD PPM 64269: Regul HMI PPM  : 63824

function rechercheAppli(){
	window.open("/recupAppli.do?action=initialiser&nomChampDestinataire=airt&windowTitle=Recherche Code Application&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}


function rechercheID(){
	window.open("/recupIdPersonne.do?action=initialiser&nomChampDestinataire=pcpi&windowTitle=Recherche Identifiant Chef de Projet&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function rechercheDPG(){
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=codsg&rafraichir=OUI&windowTitle=Recherche Code DPG Fournisseur&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function rechercheCA(){
    window.open("/recupIdCa.do?action=initialiser&nomChampDestinataire=codcamo&rafraichir=OUI&windowTitle=Recherche CA payeur&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function rechercheIDMo(champs){
	window.open("/recupIdMo.do?action=initialiser&nomChampDestinataire="+champs+"&rafraichir=OUI&windowTitle=Recherche Code Client&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
} 
/*QC 2002- focus is moved to dpcode after code application.*/
function nextFocusAppli(){		document.forms[0].dpcode.focus();}
function nextFocusDPG(){		document.forms[0].pcpi.focus();}
function nextFocusID() {		document.forms[0].clicode.focus();}
function nextFocusID_modif() {	
	if ("<%=menuId%>"=="DIR" || ("ME"=="<%=menuId%>" && <%=sousMenus.indexOf("ges")%> >= 0)) 	document.forms[0].clicode.focus();
	else 						document.forms[0].clicode_oper.focus() ;
}
function nextFocusIDMo() {		document.forms[0].clicode_oper.focus();}
function nextFocusIDMo_oper() {	document.forms[0].codcamo.focus();}
function nextFocusCA() {		document.forms[0].pnmouvra.focus();}
function nextFocusIDMo_oper_modif() {
	if ("<%=menuId%>"=="DIR" || ("ME"=="<%=menuId%>" && <%=sousMenus.indexOf("ges")%> >= 0))   document.forms[0].codcamo.focus();
	else						document.forms[0].pnmouvra.focus();
}

// TD 532
//  Permet l'affichage  d'une bulle d'aide lors du passage de la souris sur le champ correspondant à la saisie du CA payeur
// Variables :
// 	bShow : true (bulle affichée) / false (bulle cachée)
//	pListe : Liste des CA retournés 
function showTooltips(bShow, pListe) {
    var objTooltip = document.getElementById("tooltipsAll");

	// on récupère la position de la souris
	x = (navigator.appName.substring(0,3) == "Net") ? Event.MOUSEMOVE.pageX : event.x+document.body.scrollLeft;
	y = (navigator.appName.substring(0,3) == "Net") ? Event.MOUSEMOVE.pageY : event.y+document.body.scrollTop;

	//	MHA : 64238
	objTooltip.style.left = x+250;
	objTooltip.style.top  = y-35;
	
	if (bShow) {
	
		if (pListe=="")
		{
			objTooltip.innerHTML = "<FONT color=white size=2>Aucun CA pr&eacuteconis&eacute</FONT>";
			objTooltip.style.width = '200px';
		} else {
			sTxt = pListe;
			objTooltip.innerHTML = "<FONT color=white size=2>CA préconisé(s) :"+sTxt+"</FONT>";
			objTooltip.style.width = '300px';
		}
			
		// on affiche la bulle d'aide
        objTooltip.style.visibility = "visible";

    } else {
		// on cache la bulle d'aide
        objTooltip.style.visibility = "hidden";
    }
   return ;     
}

function TraitementAjax(pMethode, pParams) {
	
	// Appel ajax de la méthode pMethode de l'action lignebip.do
	ajaxCallRemotePage('/ligneBip.do?action=' + pMethode + pParams);
	// Si la réponse ajax est non vide :
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		// Affichage d'une popup avec le contenu de la réponse
		alert(document.getElementById("ajaxResponse").innerHTML);
		return false;
	}
	return true;
}

function existParamApp()
{
	var code_action='OBLIGATION-DBS';
	var code_version='DEFAUT';
	var num_ligne = '1';
	
	if(!TraitementAjax('recupParamApp', '&code_action=' + code_action+'&code_version=' + code_version+'&num_ligne='+num_ligne))
	{
	return false;
	}
	return true;
}

//PPM 59288 debut
//PPM 59288 : fonction qui recupere le dirprin à partir d'un dpcode
function recupDirPrinDp(p_dpcode)
{
	//appel de la fonction ajax de controle de cohérence de direction parincipale à un Dossier Projet
	ajaxCallRemotePage('/ligneBip.do?action=dirPrinDp&dpcode=' + p_dpcode);
	//récupération de la valeur retournée
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
}

//PPM 59288 : fonction de verification si la direction d'un DP appartient à la liste des directions liées au paramètre DBS
function VerifierDirDbs(p_dpcode){
	var l_grdT1 = <%= grdT1%>;
	if((l_grdT1!= true) && (p_dpcode.value!="00000")){
		var dirPrinDp = recupDirPrinDp(p_dpcode.value);
		if(dirPrinDp!=null && dirPrinDp!=""){
		<% java.util.ArrayList<String> liste_dir_dbs = (java.util.ArrayList<String>)session.getAttribute("listeDirDbs");%>
		var listDirDbs = <%=liste_dir_dbs%>;
		for ( i=0;i<listDirDbs.length;i++){
			var dirPrinDBS = listDirDbs[i];
			if(dirPrinDBS==dirPrinDp){
				if(duplic=="OUI"){
					if(r_dpcode!=null){//Si on n'est pas dans le premier chargement de la page CREATION A PARTIR DE, on fait le même traitement qu'en modification
						alert("Le DP "+p_dpcode.value+" n'est pas autorisé pour une ligne non GT1, compte-tenu de la Direction principalement concernée, associée à ce DP");
						var choixPrecDP = "<%=sdossierprojet%>";
						document.forms[0].dpcode.value = choixPrecDP;//en cas de "création à partir de", on applique les mêmes nouvelles règles que pour une modification d'une ligne non GT1 
					}					
				}else{
					alert("Le DP "+p_dpcode.value+" n'est pas autorisé pour une ligne non GT1, compte-tenu de la Direction principalement concernée, associée à ce DP");
					if(document.forms[0].mode.value == "insert"){
						document.forms[0].dpcode.value = "00000";//en cas de création, on réintialise la liste des DP à 0
					}else{
						var choixPrecDP = "<%=sdossierprojet%>";
						document.forms[0].dpcode.value = choixPrecDP;//en cas de modification, on réinitialise le choix du DP à sa valeur précédente
					}
				}
				raffraichiListe();
				return false;
			}
		}
		}
	}
	return true;
}

//IF p_dirprin IS  NULL OR NOT is_obligation_dp_immo(p_dirprin,p_message) OR t_table IS NULL THEN 
   
 //PPM 61695
function VerifierDirImmo(p_dpcode){
	var l_grdT1 = <%= grdT1%>;
	<% java.util.ArrayList<String> liste_dir_immo = (java.util.ArrayList<String>)session.getAttribute("listeDirImmo");%>
	var listDirImmo = <%=liste_dir_immo%>;
	if((l_grdT1!= true) && (p_dpcode.value!="00000") && (listDirImmo != null)){
		var dirPrinDp = recupDirPrinDp(p_dpcode.value);
		if(dirPrinDp!=null && dirPrinDp!=""){
			for ( i=0;i<listDirImmo.length;i++){
				var dirPrinImmo = listDirImmo[i];
				if(dirPrinImmo==dirPrinDp){
					if(duplic=="OUI"){
						if(r_dpcode!=null){//Si on n'est pas dans le premier chargement de la page CREATION A PARTIR DE, on fait le même traitement qu'en modification
							alert("Le DP "+p_dpcode.value+" n'est pas autorisé pour une ligne non GT1, compte-tenu de la Direction principalement concernée, associée à ce DP");
							var choixPrecDP = "<%=sdossierprojet%>";
							document.forms[0].dpcode.value = choixPrecDP;//en cas de "création à partir de", on applique les mêmes nouvelles règles que pour une modification d'une ligne non GT1 
						}
					}
					else
					{
						alert("Le DP "+p_dpcode.value+" n'est pas autorisé pour une ligne non GT1, compte-tenu de la Direction principalement concernée, associée à ce DP");
						if(document.forms[0].mode.value == "insert"){
							document.forms[0].dpcode.value = "00000";//en cas de création, on réintialise la liste des DP à 0
						}
						else
						{
							var choixPrecDP = "<%=sdossierprojet%>";
							document.forms[0].dpcode.value = choixPrecDP;//en cas de modification, on réinitialise le choix du DP à sa valeur précédente
						}
					}
					raffraichiListe();
					return false;
				}
			}
		}
	}
	return true;
}

function IsAutorisElargis(p_dpcode){
	var dirPrinDp = recupDirPrinDp(p_dpcode.value);
	<% java.util.ArrayList<String> liste_dir_dp_immo = (java.util.ArrayList<String>)session.getAttribute("listeDirDbs");%>
	var listDirDpImmo = <%=liste_dir_dp_immo%>;
		if((dirPrinDp==null && dirPrinDp=="") || (IsDirPrinDbs(p_dpcode)) || (listDirDpImmo.length<0) )
		return true;
	else if((dirPrinDp!=null && dirPrinDp!="") && (!IsDirPrinDbs(p_dpcode))){
			
		VerifierDirDbs(p_dpcode);
		return false;
	}
	}
		


function IsDirPrinDbs(p_dpcode){

	if(p_dpcode.value!="" && p_dpcode.value!="00000"){
		var dirPrinDp = recupDirPrinDp(p_dpcode.value);
		if(dirPrinDp!=null && dirPrinDp!=""){
		<% java.util.ArrayList<String> liste_dir_prin_dbs = (java.util.ArrayList<String>)session.getAttribute("listeDirDbs");%>
		var listDirDbs = <%=liste_dir_prin_dbs%>;
		for ( i=0;i<listDirDbs.length;i++){
			var dirPrinDBS = listDirDbs[i];
			if(dirPrinDBS==dirPrinDp){
				return false;
			}
		}
		}
	}
	return true;
}

//PPM 59288 fin

//FAD PPM 61695
function IsDirPrinImmo(p_dpcode){
	var l_grdT1 = <%= grdT1%>;
	//if((l_grdT1!= true) && p_dpcode.value!="" && p_dpcode.value!="00000"){
	if(p_dpcode.value!="" && p_dpcode.value!="00000"){
		var dirPrinDp = recupDirPrinDp(p_dpcode.value);
		if(dirPrinDp!=null && dirPrinDp!=""){
			<% java.util.ArrayList<String> liste_dir_prin_immo = (java.util.ArrayList<String>)session.getAttribute("listeDirImmo");%>
			var listDirImmo = <%=liste_dir_prin_immo%>;
			for ( i=0;i<listDirImmo.length;i++){
				var dirPrinDBS = listDirImmo[i];
				if(dirPrinDBS==dirPrinDp){
					return false;
				}
			}
		}
	}
	return true;
}
//PPM 61695

// FAD PPM 64240 : Ajout de la fonction reinitDPCOPI pour réinitialiser la valeur de DPCOPI à null
function reinitDPCOPI(){
	if(typeof(document.forms[0].dpcopi) != 'undefined')
	{
		document.forms[0].dpcopi.value = "";
	}
}

//FAD PPM 64240 : Ajout de la fonction raffraichiListeProj pour verifier si la valeur de DPCOPI est null
function raffraichiListeProj(valDPCOPI){
	var oldDPCOPI = "<%=ligneBipForm.getDpcopi()%>";
	if (valDPCOPI == " ")
	{
		alert("Vous devez obligatoirement choisir une valeur parmi celles proposées dans la liste déroulante des codes DPCOPI");
		document.forms[0].dpcopi.value = oldDPCOPI;
	}
	else
	{
		document.forms[0].dpcopi.value = valDPCOPI;
	}

	rafraichir(document.forms[0]);
}


function initAxemetier2(){
	//alert("inside create Axemetier");
	var j_typproj=document.forms[0].typproj.value;
	var j_arctype=document.forms[0].arctype.value;
	var j_clicode=document.forms[0].clicode.value;
	var j_codsg=document.forms[0].codsg.value;
	var j_pzone=document.forms[0].pzone.value;
	if(document.forms[0].mode.value == "insert" || duplic=="OUI"){
	 if(( j_typproj!=null && j_typproj!="" && j_typproj!=''  && j_arctype!=null && j_arctype!=""  && j_arctype!='' && j_clicode!=null && j_clicode!="" && j_clicode!=''  && j_pzone!=null && j_pzone!=""  && j_pzone!='')
	|| (j_typproj!=null && j_typproj!="" && j_typproj!=''  && j_arctype!=null && j_arctype!=""  && j_arctype!='' && j_codsg!=null && j_codsg!="" && j_codsg!='' && j_pzone!=null && j_pzone!=""  && j_pzone!=''  )  ) 
	{	
	 ajaxCallRemotePage('/ligneBip.do?action=guiInitialiserligneaxemetier2&typproj='+j_typproj+'&arctype='+j_arctype+'&clicode='+j_clicode+'&codsg='+j_codsg+'&pzone='+j_pzone);
	// Si la réponse ajax est non vide :
	var result = document.getElementById("ajaxResponse").innerHTML; 
	if(result=="SUCCESS"){
	document.forms[0].ligneaxemetier2.value='000000';
	}
	}
	}
}

</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainerBip29">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
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
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage">
          	<bean:write name="ligneBipForm" property="titrePage"/> une ligne BIP
          	<% if (grdT1) { %>
          		grand T1<bean:write name="ligneBipForm" property="createFromTitle"/>	
          		          		
          	<% }
                    else { %>
            	hors grand T1<bean:write name="ligneBipForm" property="createFromTitle"/>	
            <% } %>
          </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>

        <tr> 
          <td>
          	<html:form action="/ligneBip" onsubmit="return ValiderEcran(this);">

                     	
          	
            <div align="center">
            <input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
             <input type="hidden" name="dossierprojet" value ="<%= sdossierprojet %>"> 
            <html:hidden property="action"/> 
            <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
            <html:hidden property="focus"/> 
            <html:hidden property="flaglock"/> 
            <html:hidden property="titrePage"/>
            <html:hidden property="codbr" />
            <html:hidden property="duplic"/> 
            <html:hidden property="listecapreconise"/>
            <html:hidden property="codeAppliAvantModif"/>
            <html:hidden property="codeDPAvantModif"/> 
            <html:hidden property="codePrjAvantModif"/>
            <html:hidden property="codeMetierAvantModif"/> 
            <html:hidden property="realiseanterieur"/> 
            <html:hidden property="arbitreactuel"/> 
            <html:hidden property="messageAdminBlocage"/> 
            <html:hidden property="messageMeBlocage"/>  
            <html:hidden property="realiseAnterieurNotNullDiffZero"/>  
            <html:hidden property="arbitreActuelNotNullDiffZero"/>  
			<html:hidden property="alertedbs"/>
   <!-- 	FAD PPM 64269: Regul PPM HMI 63824 -->
			<html:hidden property="update_controle" />
   <!-- 		FIN	FAD PPM 64269: Regul PPM HMI 63824 -->   
             
              <!-- ===========================================   -->               
              <!-- Modifier                                      -->
              <!-- ===========================================   -->
 

              <logic:equal parameter="mode" value="update"> 
	              <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" width=900>
                <tr> 
                  <td height="2">&nbsp;</td>
                </tr>
                
                <tr align="left"> 
	                  <td class=texte >Code/cl&eacute  :</td>
                  <td class=texte><bean:write name="ligneBipForm"  property="pid" /> 
                    <html:hidden property="pid"/> &nbsp; <bean:write name="ligneBipForm"  property="pcle" /> 
                    <html:hidden property="pcle"/> &nbsp; </td>
	                    <td></td>
	                      <td class=texte width="150">Top fermeture :</td>
	                  <td class=texte ><bean:write name="ligneBipForm"  property="topfer" /> 
	                    <html:hidden property="topfer"/></td>
	                 
                </tr>
			
                <tr align="left"> 
                  <td class=texte >Statut :</td>
                  <td class=texte ><bean:write name="ligneBipForm"  property="libstatut" /> 
                    <bean:write name="ligneBipForm"  property="astatut" /> <html:hidden property="astatut"/></td>
	                <td></td>
	                  <td class=texte>Date Statut :</td>
                  <td class=texte><bean:write name="ligneBipForm"  property="adatestatut" /> 
                    <html:hidden property="adatestatut"/></td>
                </tr>
	            <tr align="left"> 
	                	 <td class=texte >Libell&eacute; ligne BIP</td>
	                 	 <td colspan="2" class="texte"> <html:text property="pnom" styleClass="input" size="46" maxlength="30" onchange="return VerifierAlphanum(this);"/> 
	                    </td>
	                	<td class=texte>Date de d&eacute;but :</td>
	                  	<td> <html:text property="pdatdebpre" styleClass="input" size="7" maxlength="7" onchange="return VerifierDate( this, 'mm/aaaa' );"/> 
	                 	</td>
	                 </tr>
		            <tr align="left"> 
	                  <td class=texte>Type principal:</td>
	                  <td class=texte colspan="2">
                  	<% if ("DIR".equals(menuId) && (icpi_statut) && (dpcode_actif)) { %>
	                  	  <html:select property="typproj" styleClass="input" size="1" style="width:300px;" onchange="raffraichiListe();basculeTypologie(this);initAxemetier2();"> 
                    	<html:options collection="choixTypproj" property="cle" labelProperty="libelle" /> 
                      </html:select>
                      <html:hidden property="statut"/>
                      <html:hidden property="actif"/>
                    <% }
                    else { %>
                    	<bean:write name="ligneBipForm"  property="typproj" />  <bean:write name="ligneBipForm"  property="libtyp" /> 
                    	<html:hidden property="typproj"/>
                    	<html:hidden property="libtyp"/>
                    <% } %>
                  </td>
	                  <td class=texte>Top tri : </td>
	                  <td > <html:text property="toptri" styleClass="input" size="7" maxlength="3" onchange="return Verifier;"/> 
                  </td>
                </tr>
				
                <tr align="left"> 
	                  <td class=texte >Type secondaire :</td>
	                  <td class=texte colspan="2" >                   
                  	<% if ( ((grdT1) && (!"DIR".equals(menuId))) || ((!icpi_statut) && (!dpcode_actif) )){ %>
                  	  <bean:write name="ligneBipForm"  property="arctype" />  <bean:write name="ligneBipForm"  property="libtyp2" /> 
                  	  <html:hidden property="arctype"/>
                  	  <html:hidden property="libtyp2"/>
                  	<% }
                    else { %>
                    		<% if ( (icpi_statut) && (dpcode_actif) ){ %>
	                  	  <html:select property="arctype" styleClass="input" size="1" style="width:300px;" onchange="ChangeType2(this);basculeTypologie(this);initAxemetier2();"> 
                    	<html:options collection="choixArctype" property="cle" labelProperty="libelle" /> 
                      </html:select> 
                      <html:hidden property="actif"/>
                      <html:hidden property="statut"/>
                      			<% }
                    		else { %>
                      		<bean:write name="ligneBipForm"  property="arctype" /> <bean:write name="ligneBipForm"  property="libtyp2" /> 
                      		<html:hidden property="arctype"/>
                  	  		<html:hidden property="libtyp2"/>
                      		 <% } %>
                      		
                      		
                    <% } %>
                  </td>
	                  
	                  <td class="texte">Param&egrave;tre local :</td>
	                  <td> <html:text property="pzone" styleClass="input" size="20" maxlength="20" onchange="return VerifierAlphanum(this);" onblur="initAxemetier2();"/> 
                  </td>
                </tr>
                <tr align="left"> 
	                	<td class="texte" >Axe m&eacutetier ligne 1:</td>
	                	<td class="texte"><html:text id="ligneaxemetier1" property="ligneaxemetier1"
																		styleClass="input" size="46" maxlength="40" onchange="return VerifierAlphanum(this);" /></td>
	                		<%-- <td> <html:text property="ligneaxemetier1" styleClass="input" size="20" maxlength="20" name="ligneaxemetier1" onchange="return VerifierAlphanum(this);"/> </td> 
	                		 <td class="texte"> <bean:write name="ligneBipForm"  property="ligneaxemetier1" /> <html:hidden property="ligneaxemetier1"/> </td>
	                     --%>
	                     <td ></td>
	                    <td class="texte">Axe m&eacutetier ligne 2:</td>
	                    <td class="texte"><html:text id="ligneaxemetier2" property="ligneaxemetier2"
																		styleClass="input" size="20" maxlength="12" onchange="return VerifierAlphanum(this);" /></td>
	                		<%-- <td> <html:text property="ligneaxemetier2" styleClass="input" size="20" maxlength="20" name="ligneaxemetier2" onchange="return VerifierAlphanum(this);"/> </td>
	                		 <td class="texte"> <bean:write name="ligneBipForm"  property="ligneaxemetier2" />  <html:hidden property="ligneaxemetier2"/></td>
	                     --%>
	                </tr>
	              
                <tr align="left"> 
                 <td width=200 colspan="1"> 
                    <hr>
                  </td>
                  <td   width="300" class="texte" align="center" colspan="2"><b> 
                  
                      R&eacutef&eacuterentiel projets 
                    
                    </b></td>
                  <td width=250  colspan="2"> 
                    <hr>
                  </td>
                </tr>
             
                <tr align="left"> 
                  <td class=texte >Projet sp&eacute;cial :</td>
                  <td width="150"> 
                  	<html:select property="codpspe" styleClass="input" size="1" style="width:200px;"> 
                    <html:options collection="choixProjspe" property="cle" labelProperty="libelle" /> 
                    </html:select> 
                  </td>
                  <td></td>
                  <td class=texte width="250" >Code Application : </td>
                  <td width="80"><html:text property="airt" styleClass="input"  size="7" maxlength="5" onchange="VerifierCodeApplication(this);raffraichiListe();"  />
                  <a href="javascript:rechercheAppli();"  onFocus="javascript:nextFocusAppli();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Application" title="Rechercher Code Application" style="vertical-align : middle;"></a>                                    
                  </td>
                </tr>
                <tr align="left">
                  <% if (grdT1) { %>
                    <td class=texte width="120" nowrap="nowrap">Code Dossier projet :</td>
                  			<td class=texte colspan="4"> 
                  			<!--  FAD PPM 64240 : Ajout de la fonction reinitDPCOPI pour rÃ©initialiser la valeur de DPCOPI Ã  null -->
                  	 		 <html:select property="dpcode" styleClass="input" size="1" style="width:600px;" onchange="reinitDPCOPI();VerifierDpCode(this);"> 
                    			<html:options collection="choixDProjets" property="cle" labelProperty="libelle"/> 
                      		</html:select>
                    		</td>					
                  <% } else { %>
                    <!-- Debut PPM 59288 : Ajout de la liste des dossiers projets pour les lignes non GT1 -->
					<td class=texte width="120" nowrap="nowrap">Code Dossier projet :</td>
                  			<td colspan="4"> 
                  	 		 <html:select property="dpcode" styleClass="input" size="1" style="width:600px;" onchange="VerifierDirImmo(this);raffraichiListe();">
                    			<html:options collection="choixDProjetsNonGT1" property="cle" labelProperty="libelle"/> 
                      		</html:select>                      		
                    		</td>
					<!-- Fin PPM 59288 : Ajout de la liste des dossiers projets pour les lignes non GT1 -->
                  <% } %>                  			
                </tr>
                <!--PPM 59288 <html:hidden property="dpcode"/>-->
                
                 <% //FAD PPM 64240
                 
                 if(ligneBipForm.isAfficherDpcopi()){ 
                	 
                 %>
                <tr align="left">
                  <td class="texte" width=120>Code DPCOPI :</td>
                  <td colspan="4">
                  	<html:select property="dpcopi" styleClass="input" style="width:600px;" size="1" onchange="raffraichiListeProj(this.value);"> 
                    	<html:options collection="choixDossProjCopi" property="cle" labelProperty="libelle" /> 
                    </html:select>
                  </td>
                 </tr>
                 <%} %>
                
                <tr align="left"> 
                <td class="texte" width=120>Code Projet :</td>
                <td class=texte colspan="4"> 
                  	<html:select property="icpi" styleClass="input" style="width:600px;" size="1" onchange="raffraichiListe();"> 
                    	<html:options collection="choixProjets" property="cle" labelProperty="libelle" /> 
                    </html:select>
                    
                </td>
                 </tr>
                 
                 
                <tr align="left" > 
                 
                 <td width=200 colspan="1"> 
                    <hr>
                  </td>
                  <td   width="300" class="texte" align="center" colspan="2"><b> 
                  
                      Clients et Fournisseur
                    
                    </b></td>
                  <td width=250  colspan="2"> 
                    <hr>
                  </td>
                </tr>
             
                <tr align="left"> 
                  <td class="texte" width="150">Code DPG Fournisseur :</td>
                  <td class="texte" width="320">
                  	<html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange="if (VerifierNum(this, 7, 0)) chargeLib(this.name);" onblur="initAxemetier2();"/>
                  	&nbsp;<a href="javascript:rechercheDPG();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" style="vertical-align : middle;"></a>
                  </td><td></td>
                  <td  class="texte" align="left" width="300">Code du responsable<br> de la ligne :</td>
                  <td class="texte" align="left">
                   <html:text property="pcpi" styleClass="input" size="7" maxlength="5" onchange="return VerifierNum(this, 5, 0);" onfocus="initAxemetier2();"/><a href="javascript:rechercheID();"  onFocus="javascript:nextFocusID_modif();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant" title="Rechercher Identifiant" style="vertical-align : middle;"></a>
                  </td>           
                </tr>
                <tr align="left"> 
                  <td class="texte">Code client principal :</td>
                  <td class="texte" colspan="3"> 
                  	<% if (("DIR".equals(menuId)) || ("ME".equals(menuId) && sousMenus.indexOf("ges") >= 0)) { %>
                  		<html:text property="clicode" styleClass="input" size="7" maxlength="5" onchange="VerifierClicode(this);"  onblur="initAxemetier2();"/>
						&nbsp;<a href="javascript:rechercheIDMo('clicode');" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Client" title="Rechercher Code Client" style="vertical-align : middle;"></a>                       
                 	<% }
                    else { %>
						<bean:write name="ligneBipForm"  property="clicode" />
						<html:hidden property="clicode"/>
	                    
                    <% } %>
                  	&emsp;&emsp;&nbsp;
                  	<bean:write name="ligneBipForm"  property="clilib" />
					<html:hidden property="clilib"/>
                  </td>
                  <td></td>
                </tr>
                <tr align="left"> 
                  <td class="texte">Code client op&eacuterationnel :</td>
                  <td class="texte"  colspan="3"> 
                  	<html:text property="clicode_oper" styleClass="input" size="7" maxlength="5" onchange="VerifierClicode(this);" onfocus="initAxemetier2();"/>
					&nbsp;<a href="javascript:rechercheIDMo('clicode_oper');" onFocus="javascript:nextFocusIDMo_oper_modif();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Client" title="Rechercher Code Client" style="vertical-align : middle;"></a>
                    &emsp;&emsp;&nbsp;
                  	<bean:write name="ligneBipForm"  property="clilib_oper" />
					<html:hidden property="clilib_oper"/>
				</td>
                </tr>
                <tr align="left">
                  <td class="texte">CA payeur :
	                 <td class="texte" colspan="1"> 
                  	<% if (("DIR".equals(menuId)) || ("ME".equals(menuId) && sousMenus.indexOf("ges") >= 0)) { %>
                  	   <html:text property="codcamo" styleClass="input" size="7" maxlength="6" onchange="if (VerifierNum( this, 6, 0)) chargeLib(this.name);" onFocus="showTooltips(true, listecapreconise.value);" onblur="document.getElementById('tooltipsAll').style.visibility = 'hidden';"/>
                  	   &nbsp;<a href="javascript:rechercheCA();"  onFocus="javascript:nextFocusCA();" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher CA payeur" title="Rechercher CA payeur" style="vertical-align : middle;"></a>
                 	<% }
                    else { %>
						<bean:write name="ligneBipForm"  property="codcamo" /> 
                    	<html:hidden property="codcamo"/>
                    <% } %>
                    &emsp;&emsp;&nbsp;
                  	<bean:write name="ligneBipForm"  property="libCodCAMO" /> 
                    <html:hidden property="libCodCAMO"/>
                  </td>
                </tr>
                <tr align="left">
           		  <td class="texte" width="300">Nom du correspondant MO:</td>
                  <td > 
                  	<html:text property="pnmouvra" styleClass="input" size="30" maxlength="15" onchange="return VerifierAlphanum(this);"/> 
                  </td><td></td>
                  <td class="texte"  >M&eacutetier :</td>
                  <td> 
                  	<!-- FAD PPM 64183 : Suppression de la fonction VerifierMetier() de champ "MÃ©tier" -->
                  	<html:select property="metier" styleClass="input" style="width:70px;" size="1">
                      <bip:options collection="choixMetier" /> 
                    </html:select>
                  </td>
                </tr>
                 
                <% if ( (ligneBipForm.getCodcamo()!=null) && (ligneBipForm.getCodcamo().equals("66666")) ) { %>
                <tr align="left">
                  <td class="texte">Table de r&eacute;partition JH : 
                  <td colspan="3"> 
                  	  <html:select property="codrep" styleClass="input" size="1" onchange="" style="width:300px;"> 
                    	<html:options collection="choixCodrep" property="cle" labelProperty="libelle" /> 
                      </html:select> 
                  </td><td></td>
                </tr>
                <% } else { %>
                   	<html:hidden property="codrep" value=""/>
                <% } %>
              
              <% if (sTyp){ %>
              
                  <tr align="left"> 
                  <td class="texte" width="300">Pr&eacutecisez le Domaine Bancaire<br> Strat&eacutegique : </td>
                  <td colspan="3"> 
                  	<html:select property="sous_typo" styleClass="input" style="width:300px;" size="1" > 
                    <html:options collection="choixSous_typo" property="cle" labelProperty="libelle" /> 
                    </html:select> 
                  </td>
                  <td></td>
                </tr>
               
              <% 	
              } %>
               
            
                <tr align="left"> 
                  
                  <td width=200 colspan="1"> 
                    <hr>
                  </td>
                  <td   width="300" class="texte" align="center" colspan="2"><b> 
                  
                      Objet (Maximum 5 lignes de 60 caract&egrave;res) 
                    
                    </b></td>
                  <td width=250  colspan="2"> 
                    <hr>
                  </td>
                </tr>
              
                <tr> 
                	<td></td>
                   <td colspan="4" align="left"> <html:hidden property="pobjet"/> 
                    <script language="JavaScript">
						var obj = document.forms[0].pobjet.value;
						document.write("<textarea name=liste_objet class='tableBleuText' rows=5 cols=69 wrap onchange='return VerifierAlphanum(this);' >" + obj +"</textarea>");
					</script>
                  </td>

                </tr>
               
              </table>
              </logic:equal>

              <!-- ===========================================   -->               
              <!-- Fin Modifier                                  -->
              <!-- ===========================================   -->
              
              
              
              <!-- ===========================================   -->               
              <!-- Créer                                         -->
              <!-- ===========================================   -->
              

              <logic:equal parameter="mode" value="insert"> 
               <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" width=900>
                 <tr> 
                  <td height="2">&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td class="texte" width="300">Libell&eacute ligne BIP</td>
                  <% if (("OUI".equals(ligneBipForm.getDuplic()))) {%>
                  <td colspan="2" class="texte"> <html:text property="pnom" styleClass="input" size="46" maxlength="30" onchange="return VerifierAlphanum(this);"/></td> 
                  <%}else{%>
                  <td colspan="2" class="texte" > <bean:write name="ligneBipForm"  property="pnom" /></td> <html:hidden property="pnom"/>
                  <%}%>
                  
                   <td class="texte" >Date de d&eacute;but :</td>
                  <td > <html:text property="pdatdebpre" styleClass="input" size="7"  maxlength="7" onchange="return VerifierDate( this, 'mm/aaaa' );"/> 
                  </td>
                </tr>
              
                <tr align="left">
                 
               	  <% if ((grdT1) && (!"DIR".equals(menuId))){ %>
               	    <html:hidden property="typproj"/><td colspan="2" ></td>
                  <% }
                  else { %>
                    <td class="texte" width="350">Type principal:</td>
                    <td> 
                  	  <html:select property="typproj" styleClass="input" size="1" style="width:300px;" onchange="raffraichiListe();initAxemetier2();"> 
                    	<html:options collection="choixTypproj" property="cle" labelProperty="libelle" /> 
                      </html:select>
                    </td>
                  <% } %>
                  <td></td>
                  <td class="texte" >Top tri : </td>
                  <td > <html:text property="toptri" styleClass="input" size="7" maxlength="3" onchange="return Verifier;"/> 
                  </td>
                </tr>
                <tr align="left">
               
               	<% if ((grdT1) && (!"DIR".equals(menuId))){ %>
                  	  <html:hidden property="arctype"/><td colspan="2" ></td>
               	<% }
                else { %>
                  <td class="texte" >Type secondaire :</td>
                  <td >
                  	  <html:select  property="arctype" styleClass="input" style="width:300px;" size="1" onchange="ChangeType2(this);initAxemetier2();"> 
                    	<html:options style="  " collection="choixArctype" property="cle" labelProperty="libelle" /> 
                      </html:select> 
                  </td>
                <% } %>
                <td></td>
                <td class="texte" width="250">Param&egrave;tre local :</td>
                  <td> <html:text property="pzone" styleClass="input" size="20" maxlength="20" onchange="return VerifierAlphanum(this);" onblur="initAxemetier2();"/> 
                  </td>
                </tr>
                <tr align="left"> 
                	<td class="texte">Axe m&eacutetier ligne 1:</td>
                	<td class="texte" ><html:text id="ligneaxemetier1" property="ligneaxemetier1"
																	styleClass="input" size="46" maxlength="40" onchange="return VerifierAlphanum(this);" /></td>
                	<td></td>                
                    <td class="texte" width="250">Axe m&eacutetier ligne 2:</td>
                    
                    <td class="texte"><html:text id="ligneaxemetier2" property="ligneaxemetier2"
																	styleClass="input" size="20" maxlength="12" onchange="return VerifierAlphanum(this);" /></td>
                	
                </tr>
             
                <tr align="left"> 
                  <td  colspan="1"> 
                    <hr>
                  </td>
                  <td   width="200" class="texte" align="center" colspan="2"><b> 
                  
                       &emsp; &nbsp; R&eacutef&eacuterentiel projets 
                    
                    </b></td>
                  <td  colspan="2"> 
                    <hr>
                  </td>
                </tr>
              
                <tr align="left"> 
                  <td class="texte" >Projet sp&eacute;cial :</td>
                  <td> 
                  	<html:select style="width: 200px" property="codpspe" styleClass="input" size="1"> 
                    <html:options collection="choixProjspe" property="cle" labelProperty="libelle" /> 
                    </html:select> 
                  </td>
                  <td></td>
                  <td class="texte" width="250">Code Application : </td>
                  <td class="texte"><html:text property="airt" styleClass="input"  size="7" maxlength="5" onchange="VerifierCodeApplication(this);raffraichiListe();"  />
                 &nbsp;<a href="javascript:rechercheAppli();"  onFocus="javascript:nextFocusAppli();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Application" title="Rechercher Code Application" style="vertical-align : middle;"></a>
                  
                  </td>
                </tr>
                <tr align="left">
                  <% if (grdT1) { %>
                    <td class="texte" nowrap="nowrap" >Code Dossier projet :</td>
                    <td colspan="4"> 
                      <!--  FAD PPM 64240 : Ajout de la fonction reinitDPCOPI pour rÃ©initialiser la valeur de DPCOPI Ã  null -->
                  	  <html:select property="dpcode" styleClass="input" size="1" style="width:600px;" onchange="reinitDPCOPI();raffraichiListe();"> 
                    	<html:options collection="choixDProjets" property="cle" labelProperty="libelle"/> 
                      </html:select>
                    </td>
                  <% }
                    else { %>
                    <!--    <html:hidden property="dpcode"/>-->
                    <!-- Debut PPM 59288 : Ajout de la liste des dossiers projets pour les lignes non GT1 -->
                   
					<td class="texte" nowrap="nowrap" >Code Dossier projet :</td>
                  			<td colspan="4"> 
                  	 		 <html:select property="dpcode" styleClass="input" size="1" style="width:600px;" onchange="VerifierDirImmo(this);raffraichiListe();">
                    			<html:options collection="choixDProjetsNonGT1" property="cle" labelProperty="libelle"/> 
                      		</html:select>
                    		</td>
							<!-- Fin PPM 59288 : Ajout de la liste des dossiers projets pour les lignes non GT1 -->
                  <% } %>
                </tr>
                <% //FAD PPM 64240 : Affichage et alimentation de la liste DPCOPI
                if(ligneBipForm.isAfficherDpcopi()){ %>
                <tr align="left">
                  <td class="texte" >Code DPCOPI :</td>
                  <td colspan="4">
                  	<html:select property="dpcopi" styleClass="input" size="1" style="width:600px;" onchange="raffraichiListeProj(this.value);"> 
                     	<html:options collection="choixDossProjCopi" property="cle" labelProperty="libelle" />
                    </html:select>
                  </td>
                 </tr>
                 <%} //FAD PPM 64240 : Fin%>
                
                <tr align="left">
                  <td class="texte" width=120>Code Projet :</td>
                  <td colspan="4"> 
                  	<html:select  property="icpi" styleClass="input" size="1" style="width:600px;" onchange="raffraichiListe();"> 
                    	<html:options collection="choixProjets" property="cle" labelProperty="libelle" /> 
                    </html:select>
                  </td>
                 </tr>
              
                <tr align="left"> 
                  <td  colspan="1"> 
                    <hr>
                  </td>
                  <td   width="300" class="texte" align="center" colspan="2"><b> 
                  
                      Clients et Fournisseur
                    
                    </b></td>
                  <td   colspan="2"> 
                    <hr>
                  </td>
                </tr>
              
                <tr align="left"> 
                  <td class="texte" colspan="1" width="350">Code DPG (fournisseur) :</td>
                  <td class="texte"> 
                  	<html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange="if (VerifierNum(this, 7, 0)) chargeLib(this.name);" onblur="initAxemetier2();"/> 
				  	&nbsp;<a href="javascript:rechercheDPG();"  ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" style="vertical-align : middle;"></a>
                  </td>
                   <td></td>
                  <td  class="texte" align="left" width="300">Code du responsable<br> de la ligne :</td>
                  <td class="texte" align="left" width="100"> <html:text property="pcpi" styleClass="input" size="7" maxlength="5" onchange="return VerifierNum(this, 5, 0);" onfocus="initAxemetier2();"/>                
                  <a href="javascript:rechercheID();" onFocus="javascript:nextFocusID();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant" style="vertical-align : middle;"></a></td>
                </tr>                
				<tr align="left"> 
                  <td class="texte">Code client principal:</td>
                  <td class="texte" colspan=3> 
                  	<html:text property="clicode" styleClass="input" size="7" maxlength="5"  onchange="VerifierClicode(this);"   onblur="initAxemetier2();" /> <!-- onFocus="javascript:nextFocusIDMo();" -->
						&nbsp;<a href="javascript:rechercheIDMo('clicode');" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Client" title="Rechercher Code Client" style="vertical-align : middle;"></a>
                        &emsp;&emsp;&nbsp;
                  	<bean:write name="ligneBipForm"  property="clilib" />
					<html:hidden property="clilib"/>
				</td>
				<td></td>	
                </tr>
                <tr align="left"> 
                  <td class="texte" width="200">Code client op&eacuterationnel:</td>
                  <td class="texte" colspan="3"> 
                  	<html:text property="clicode_oper" styleClass="input" size="7" maxlength="5" onchange="VerifierClicode(this);" onfocus="initAxemetier2();"/>
						&nbsp;<a href="javascript:rechercheIDMo('clicode_oper');" onFocus="javascript:nextFocusIDMo_oper();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Client" title="Rechercher Code Client" style="vertical-align : middle;"></a>
                     &emsp;&emsp;&nbsp;
                  	<bean:write name="ligneBipForm"  property="clilib_oper" />
					<html:hidden property="clilib_oper"/>
                  </td>
                  <td></td>
                </tr>
                <tr align="left">
                  <td class="texte">CA payeur :
                  </td>
                  <td class="texte" colspan="3"> 
               	   	<html:text property="codcamo" styleClass="input" size="7" maxlength="6" onchange="if (VerifierNum( this, 6, 0)) chargeLib(this.name);" onFocus="showTooltips(true, listecapreconise.value);" onblur="document.getElementById('tooltipsAll').style.visibility = 'hidden';"/>
               	   	&nbsp;<a href="javascript:rechercheCA();"  onFocus="javascript:nextFocusCA();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher CA payeur" title="Rechercher CA payeur" style="vertical-align : middle;"></a>
                    &emsp;&emsp;&nbsp;
                  	<bean:write name="ligneBipForm"  property="libCodCAMO" /> 
                    <html:hidden property="libCodCAMO"/>
                  </td>
                  <td></td>
                </tr>
                <tr align="left">
                  <td class="texte" width="350">Nom du correspondant MO :</td>
                  <td colspan="1" class="texte"> 
                  	<html:text property="pnmouvra" styleClass="input" size="30" maxlength="15" onchange="return VerifierAlphanum(this);"/> 
                  </td>
                  <td></td>
                  <td class="texte"  colspan="1">M&eacutetier :</td>
                  <td colspan="1"> 
                  	<html:select property="metier" style="width:70px;" styleClass="input" size="1"> 
                    	<bip:options collection="choixMetier" /> 
                    </html:select>
                    
                    
                  </td>
                </tr>
				<% if ( (ligneBipForm.getCodcamo()!=null) && (ligneBipForm.getCodcamo().equals("66666")) ) { %>
                <tr align="left">
                  <td class="texte">Table de r&eacute;partition JH : 
                  <td colspan="3" > 
                  	  <html:select property="codrep" styleClass="input" size="1" onchange="" style="width:300px;"> 
                    	<html:options collection="choixCodrep" property="cle" labelProperty="libelle" /> 
                      </html:select> 
                  </td><td></td>
                </tr>
                <% } else { %>
                    <html:hidden property="codrep" value=""/>
                <% } %>                
              
              <% if (sTyp) { %>
              
                  <tr align="left"> 
                  <td class="texte" width="200">Pr&eacutecisez le Domaine Bancaire <br> Strat&eacutegique : </td>
                  <td colspan="3"> 
                  	<html:select property="sous_typo" styleClass="input" size="1" style="width:300px;"> 
                    <html:options collection="choixSous_typo" property="cle" labelProperty="libelle" /> 
                    </html:select> 
                  </td>
                  <td></td>
                </tr>
                
              <% } %>
              
                <tr align="left"> 
                 <td  colspan="1"> 
                    <hr>
                  </td>
                  <td   width="300" class="texte" align="center" colspan="2"><b> 
                  
                      Objet (Maximum 5 lignes de 60 caract&egrave;res) 
                    
                    </b></td>
                  <td   colspan="2"> 
                    <hr>
                  </td>
                </tr>
             
                  <tr> 
                  <td></td>
                   <td colspan="4" align="left"  class='tableBleuText' > <html:hidden property="pobjet"/> 
                    <script language="JavaScript">
						var obj = document.forms[0].pobjet.value;
						document.write("<textarea name=liste_objet class='tableBleuText' rows=5 cols=69 wrap onchange='return VerifierAlphanum(this);' >" + obj +"</textarea>");
					</script>
					
                  </td>

                </tr>
                  
              </table>
              </logic:equal> 


              <!-- ===========================================   -->               
              <!-- Fin Creer                                     -->
              <!-- ===========================================   -->
              


              </div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="26.5%">&nbsp;</td>
                <td width="32.5%"> 
                    <% if ( ("OUI".equals(ligneBipForm.getDuplic())) ) {%>
                  		<div align="left"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider','',true);"/> 
                  		</div>
                   	<%}else{%>             
                  		<div align="left"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider','',true);"/> 
                  		</div>
                  	<%}%>
                
                </td>
                <td width="33%"> 
                  <div align="left"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Annuler(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
                <td width="18%">&nbsp;</td>
              </tr>
            </table>
            </html:form>
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<div id="tooltipsAll" class="tooltip">
<FONT color=white size=2>Aucun CA pr&eacuteconis&eacute</FONT>
</div>
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
<% 
Integer id_webo_page = new Integer("1038"); 
com.socgen.bip.commun.form.AutomateForm formWebo = ligneBipForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>