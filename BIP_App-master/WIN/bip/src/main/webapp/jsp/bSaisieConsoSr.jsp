
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,
com.socgen.ich.ihm.menu.PaginationVector,com.socgen.ich.ihm.*,
java.lang.reflect.InvocationTargetException,java.util.Date,
com.socgen.bip.metier.ErreurSupprSsTache" 
errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="affectationForm" scope="request" class="com.socgen.bip.form.AffectationForm" />
<jsp:useBean id="saisieConsoForm" scope="request" class="com.socgen.bip.form.SaisieConsoForm" />
<jsp:useBean id="listeConsos" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<jsp:useBean id="UserBip" class="com.socgen.bip.user.UserBip" scope="session"/>
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 <!-- ABN - HP PPM 57735 (GESTION DES FAVORIS) -->

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!--  ABN - HP PPM 57787 - DEBUT  -->
 <!-- #BeginEditable "doctitle" --> 
<title>
	<% java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle("log");%>
	<%=rb.getString("env.titrepage")%>
</title>
<!-- #EndEditable --> 
<!--  ABN - HP PPM 57787 - FIN  -->

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/saisieConso.do"/> 
<% 	com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip");
	String sousmenu = userbip.getSousMenus().toUpperCase(); 
	boolean isSousMenusISAC = sousmenu.indexOf("ISAC")>=0;
	int i = 0;
   	int j = 0;
   	int k = 0;
  	int mois=0;
	int nbligne = 0;
	int kmois= (new Integer(saisieConsoForm.getMois().substring(0,2))).intValue();
	 /**  Start of Bip - 196 user story implmentation*/   
	int kanne = (new Integer(saisieConsoForm.getMois().substring(3,7))).intValue();
	 /*End of Bip - 196 user story implmentation*/  
	 //BIP 612 changes 
	int mon=1;
	String monLabel="conso_1_1";
	if(null!=saisieConsoForm.getRetroIdent()){ 
	mon=Integer.valueOf(saisieConsoForm.getMois().substring(0, saisieConsoForm.getMois().indexOf('/')));
	monLabel="conso_1_"+mon;
	}
	//End of BIP 612 changes 
	String libClicode="";
	String libPid="";
	String libEcet="";
	String libActa="";
	String libAcst="";
	String libEtape="";
	String libTache="";
	String libSousTache="";
	String libAffect="";
	String nbMois=saisieConsoForm.getNbmois();
	String libConso="";
	String libOld="";
	String libTotalPid="";
	String libExistConso="";
	String libChoix="";
	String libChoixOld="";
	String libChoixPrecedent="";
    String[] strTabCols = new String[] {  "fond1" , "fond2" };
    int index1;
    PaginationVector liste = (PaginationVector) (request.getSession(false)).getAttribute("listeConsos");
    index1 = liste.getCurrentBlock();
    
    String lock = (String)saisieConsoForm.getLock();
     %>
<script language="JavaScript" src="../js/function.cjs"></script>
<script language="JavaScript" src="../js/jquery.js"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<link rel="stylesheet" href="../css/style_aide.css" type="text/css">
<script language="JavaScript">
//ABN - HP PPM 64951
var oldConso;
//ABN - HP PPM 64000
function VerifEntree(Obj,EF, lig, numsEtapeTacheSsTache) {
	if (window.event.type == "keypress" & window.event.keyCode == 13) {
		//alert('Dans entreee');
		CalculerTotMois(Obj,EF, lig, numsEtapeTacheSsTache);
		
			
		
		
		
	}
	
}


var blnVerification = true;
var ident;
var codsg;
var ressource;
var Message;
var Focus;
var listecodsg;
var listesoustaches;

if("<bean:write name="affectationForm"  property="ident" />" != "")
{

	Message = "<bean:write name="affectationForm" filter="false"    property="msgErreur" />";
	Focus = "<bean:write name="affectationForm"  property="focus" />";
	
	ident = "<bean:write name="affectationForm"  property="ident" />";
	ressource = "<bean:write name="affectationForm"  property="ressource" />";
	codsg = "<bean:write name="affectationForm"  property="codsg" />";

	listecodsg = "<bean:write name="affectationForm"  property="listeCodsgString" />";
	listesoustaches = "<bean:write name="affectationForm"  property="listeSousTaches" />";
}
else
{

	Message = "<bean:write name="saisieConsoForm" filter="false"   property="msgErreur" />";
	Focus = "<bean:write name="saisieConsoForm"  property="focus" />";
	
   
	ident = "<bean:write name="saisieConsoForm"  property="ident" />";
	ressource = "<bean:write name="saisieConsoForm"  property="ressource" />";
	codsg = "<bean:write name="saisieConsoForm"  property="codsg" />";

	listecodsg = "<bean:write name="affectationForm"  property="listeCodsgString" />";
	listesoustaches = "<bean:write name="affectationForm"  property="listeSousTaches" />";
}


<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sIndexMenu = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("indexMenu")));
	String sPosition = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("position")));
	String sPosition_blocksize = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("position_blocksize")));
	
%>
var pageAide = "<%= sPageAide %>";

$(document).ready(function() {

	MessageInitial();
	$("input[name=<%=monLabel%>]").focus();

	$( "input[type=text]" ).focus(function() {
		$(this).css('border-color','#EFD242');
	});
	
	$( "input[type=text]" ).blur(function() {
		$(this).css('border-color','');
	});
	
});

var prefixeMessageErreurDesaffect = "Votre demande de Désaffectation sur ligne ";
var prefixeMessageErreurSuppr = "<%= ErreurSupprSsTache.messagePrefixe %>";
var prefixeMessageErreurSsTache = "<%= ErreurSupprSsTache.messagePrefixeSsTache %>";
var suffixeMessageErreurHabilitation = " ne peut pas être prise en compte car vous n\'etes pas habilité au paramétrage : veuillez modifier votre choix";
//MEH PPM 64935
var suffixeMessageErreurDesaffect = " ne peut pas être prise en compte car il y a encore du consommé dans l\'année : veuillez corriger puis attendre la prochaine mensuelle";
var suffixeMessageErreurSuppr = "<%= ErreurSupprSsTache.messageSuffixe %>";

function validerChoix(elt, oldElt, lig, idSousTache, idRess, numsEtapeTacheSsTache) {

	var conso = 0;
	var oldValue = $('input[name="'+oldElt+'"]');
	var tab = elt.name.split('_');
	var i=tab[1];
	if (parseFloat(eval('document.forms[0].total_pid_' + i).value) > 0) {
		conso = 1;
	}

	// Si choix "Désaffectation" et sous menu différent de ISAC
	if ((elt.value == '2') && <%= !isSousMenusISAC %>) {
		alert(prefixeMessageErreurDesaffect + lig + prefixeMessageErreurSsTache + numsEtapeTacheSsTache + suffixeMessageErreurHabilitation);
	}
	// Si choix "Suppression" et sous menu différent de ISAC
	else if ((elt.value == '3') && <%= !isSousMenusISAC %>) {
		alert(prefixeMessageErreurSuppr + lig + prefixeMessageErreurSsTache + numsEtapeTacheSsTache + suffixeMessageErreurHabilitation);
	}
	// Si choix "Désaffectation" et existence de consommé sur la ressource en cours et l'année courante
	else if (elt.value == '2' && conso > 0) {
		alert(prefixeMessageErreurDesaffect + lig + prefixeMessageErreurSsTache + numsEtapeTacheSsTache + suffixeMessageErreurDesaffect);
	} 
	else if (elt.value == '2' && existeConcommeDef(idSousTache, idRess)) {
		alert(prefixeMessageErreurDesaffect + lig + prefixeMessageErreurSsTache + numsEtapeTacheSsTache + suffixeMessageErreurDesaffect);
	} 
	// Si choix "Suppression" et existence de consommé sur la ressource en cours et l'année courante
	else if (elt.value == '3' && conso > 0) {
		alert(prefixeMessageErreurSuppr + lig + prefixeMessageErreurSsTache + numsEtapeTacheSsTache + suffixeMessageErreurSuppr);
	}
	// Si choix "Suppression" et existence de consommé sur une ressource différente de la ressource en cours et l'année courante
	else if (elt.value == '3' && existeConcomme(idSousTache, idRess)) {
		alert(prefixeMessageErreurSuppr + lig + prefixeMessageErreurSsTache + numsEtapeTacheSsTache + suffixeMessageErreurSuppr);
	}
	// Sinon (cas d'un choix valide)
	else {
		// Mise à jour de l'ancienne valeur avec la valeur courante
		document.getElementsByName(oldElt)[0].value=elt.value;
		// Sortie de la fonction
		return;
	}

	// Cas d'un choix invalide : restitution de l'ancienne valeur, et focus sur le champ
	elt.value=oldValue.val();
	elt.focus();
}

function existeConcomme(idSousTache, idRess) {
	ajaxCallRemotePage('/saisieConso.do?action=existsConsomme&soustache=' + idSousTache + '&ident=' + idRess);
	var respAjax = document.getElementById("ajaxResponse").innerHTML;
	return (respAjax == 1);
}
//MEH PPM 64935
function existeConcommeDef(idSousTache, idRess) {
	ajaxCallRemotePage('/saisieConso.do?action=existsConsommeDef&soustache=' + idSousTache + '&ident=' + idRess);
	var respAjax = document.getElementById("ajaxResponse").innerHTML;
	return (respAjax == 1);
}

function MessageInitial()
{
//FAD PPM 64579 : appel de la fonction de style de fond des mois à l'entrée initiale de la page
   setStyleAllMoisAnnee();
   if (Message != "") {
      alert(Message);
   }
}
function VerifierDec( EF, longueur, decimale )
{
 var posSeparateur = -1;
 var Chiffre = "1234567890";
 var champ   = "";
 var deb     = 0;
 var debut   = 0;

   while (EF.value.charAt(debut)=='0' && debut <= EF.value.length)  {
      debut++;
   }

   if (EF.value.length == (debut) && EF.value.charAt(0)=='0')
         deb = 0;
   else if ((EF.value.charAt(1)==',' || EF.value.charAt(1)=='.') && EF.value.charAt(0)=='0')
        deb = 0;
   else if (EF.value.charAt(0)==',' || EF.value.charAt(0)=='.') {
        deb = 0;
        champ += '0';
   }
   else
      deb = debut;

   while (deb <= EF.value.length)  {
      if (Chiffre.indexOf(EF.value.charAt(deb))== -1) {
         switch (EF.value.charAt(deb)) {
              case '.' :
              case ',' : champ += '.';
                         posSeparateur = deb;
                         if ( (deb <= (longueur-decimale+debut)) && ((EF.value.length-posSeparateur-1) <= decimale) )
                               break;
              default  : alert( "Nombre invalide");
                         EF.focus();
                         EF.value = "";
                         return false;
         }
      }
      else champ += EF.value.charAt(deb);
      deb++;
   }

   if (posSeparateur==-1) {
	if (EF.value.length > (longueur-decimale+debut)) {
	   alert( "Nombre invalide");
	   EF.focus();
	   EF.value = "";
	   return false;
	}
      //if(decimale !=0) {
        // champ += ',';
      //}
      nbDecimales=0;
   }
   else if (decimale != 0) {
	nbDecimales = EF.value.length-posSeparateur-1;
   }
   else {alert( "Nombre invalide");
	   EF.focus();
	   EF.value = "";
	   return false;
   }

 //  for (Cpt=1; Cpt <= (decimale-nbDecimales); Cpt++ ) {
   //   champ += '0';
   //}
   EF.value=champ;

return true;
}   


//PPM 57865 - KRA

//fonction de mise en style d'un mois passé en paramètre
function updateCouleurFond(moisAnnee){
	//appel de la fonction de recherche du couleur de fond de mois selon la situation de la ressource
	ajaxCallRemotePage('/saisieConso.do?action=couleurFondMois&ident=' + ident + '&moissitu=' + moisAnnee);
	var tabMoisAnnee = moisAnnee.split("/");
	var mois = tabMoisAnnee[0];
	var annee = tabMoisAnnee[1];
	var idclass = "";

	//vérification de style pendant la saisie des consommés
	var m = parseInt( mois, 10);	
	var totalMois= eval("document.forms[0].tot_mois_"+m).value;

	if (totalMois=="") totalMois=0;
    	virgules=totalMois.toString().split(',');
    	tot_mois=parseFloat(virgules[0]+'.'+virgules[1])+parseFloat(totalMois); 

	switch(mois) {
	   case "01": 
		   idclass = document.getElementById("jan");
		   break;
	   case "02": 
		   idclass = document.getElementById("fev");
		   break;
	   case "03": 
		   idclass = document.getElementById("mar");
		   break;
	   case "04": 
		   idclass = document.getElementById("avr");
		   break;
	   case "05": 
		   idclass = document.getElementById("mai");
		   break;
	   case "06": 
		   idclass = document.getElementById("jun");
		   break;
	   case "07": 
		   idclass = document.getElementById("jul");
		   break;
	   case "08": 
		   idclass = document.getElementById("aou");
		   break;
	   case "09": 
		   idclass = document.getElementById("sep");
		   break;
	   case "10": 
		   idclass = document.getElementById("oct");
		   break;
	   case "11": 
		   idclass = document.getElementById("nov");
		   break;
	   case "12": 
		   idclass = document.getElementById("dec");
		   break;		   
	   default: 
		   alert("Mois incorrect");
		   break;

}
	//récupération de la valeur retournée par la procédure couleurFondMois()
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	if(ajaxres.trim() == "1"){
		//style css libisac1 : rectangle Vert	(le mois est couvert par la situation de ressource)	
		idclass.className = "libisac1";
	}else if(ajaxres.trim() == "2"){
		//style css libisac2 : triangle Vert (le mois est partiellement couvert par la situation de ressource)
		idclass.className = "libisac2";
	}else if(ajaxres.trim() == "3"){
		//style css libisac3 : rectangle orange (le mois non couvert par la situation de ressource et le consommé du mois différent de 0)
		//vérification de style pendant la saisie des consommés
		if(tot_mois>0){
			idclass.className = "libisac3";
		}else{
			idclass.className = "libisac";
		}
		
	}else{
		//style css libisac : couleur du fond initial (le mois non couvert par la situation de ressource et le consommé du mois égale à 0)
		//vérification de style pendant la saisie des consommés
		if(tot_mois>0){
			idclass.className = "libisac3";
		}else{
			idclass.className = "libisac";
		}
	}

}

//FAD PPM 64579 : fonction de mise en style des mois d'une année passéd en paramètre
function updateCouleurFondAnnee(Annee){
	//appel de la fonction de recherche du couleur de fond de mois selon la situation de la ressource
	ajaxCallRemotePage('/saisieConso.do?action=couleurFondAnnee&ident=' + ident + '&anneesitu=' + Annee);

	//récupération de la valeur retournée par la procédure couleurFondAnnee()
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	var retourAnnee = ajaxres.split(";");

	var idclass = "";
	var m;
	var totalMois;
	var i;
	for (i = 0; i<12; i++){
		idclass = "";

		//vérification de style pendant la saisie des consommés
		m = i + 1;
		totalMois = eval("document.forms[0].tot_mois_"+m).value;

		if (totalMois == "")
			totalMois = 0;

		virgules = totalMois.toString().split(',');
		tot_mois = parseFloat(virgules[0]+'.'+virgules[1])+parseFloat(totalMois); 
		switch(m) {
			case 1:
				idclass = document.getElementById("jan");
				break;
			case 2:
				idclass = document.getElementById("fev");
				break;
			case 3:
				idclass = document.getElementById("mar");
				break;
			case 4:
				idclass = document.getElementById("avr");
				break;
			case 5:
				idclass = document.getElementById("mai");
				break;
			case 6:
				idclass = document.getElementById("jun");
				break;
			case 7:
				idclass = document.getElementById("jul");
				break;
			case 8:
				idclass = document.getElementById("aou");
				break;
			case 9:
				idclass = document.getElementById("sep");
				break;
			case 10:
				idclass = document.getElementById("oct");
				break;
			case 11:
				idclass = document.getElementById("nov");
				break;
			case 12:
				idclass = document.getElementById("dec");
				break;
			default:
				alert("Mois incorrect");
				break;
		}

		if(retourAnnee[i].trim() == "1"){
			//style css libisac1 : rectangle Vert	(le mois est couvert par la situation de ressource)
			idclass.className = "libisac1";
		}
		else{
			if(retourAnnee[i].trim() == "2"){
				//style css libisac2 : triangle Vert (le mois est partiellement couvert par la situation de ressource)
				idclass.className = "libisac2";
			}
			else{
				if(retourAnnee[i].trim() == "3"){
					//style css libisac3 : rectangle orange (le mois non couvert par la situation de ressource et le consommé du mois différent de 0)
					//vérification de style pendant la saisie des consommés
					if(tot_mois>0){
						idclass.className = "libisac3";
					}
					else{
						idclass.className = "libisac";
					}
				}
				else{
					//style css libisac : couleur du fond initial (le mois non couvert par la situation de ressource et le consommé du mois égale à 0)
					//vérification de style pendant la saisie des consommés
					if(tot_mois>0){
						idclass.className = "libisac3";
					}
					else{
						idclass.className = "libisac";
					}
				}
			}
		}
	}
}
//FAD PPM 64579 : Fin

//fonction de mise à jour du style du mois
function setStyleMois(Obj){
	//on réupère le mois de saisie
	var indiceMois = Obj.split('_')[2];
	var mm = indiceMois;
	if(indiceMois<10){
		mm = "0"+indiceMois;
	}
	//on récupère l'année courante
	var MA = "<bean:write name="saisieConsoForm" property="mois"/>";
	var yyyy = MA.split('/')[1];
	//formatage de la date sous forme MM/YYYY
	var MMYYYY = mm+"/"+yyyy;
	//Appel de la fonction de recherche de la couleur du fond du mois passé en paramètre
	updateCouleurFond(MMYYYY);
}

//Fin PPM 57865

//FAD PPM 64579 : fonction de mise à jour du style de tous les mois de l'année courante (Execution PLSQL)
function setStyleAllMoisAnnee(){
	//on récupère le mois de saisie et l'année courante
	var MA = "<bean:write name="saisieConsoForm" property="mois"/>";
	var yyyy = MA.split('/')[1];
	updateCouleurFondAnnee(yyyy);
}
//FAD PPM 64579 : Fin

//ABN - HP PPM 64951
function valueOfOldConso(EF) {
	
	oldConso = EF.value;
}



function CalculerTotMois(Obj,EF, lig, numsEtapeTacheSsTache)
{//alert('oldConso: ' + oldConso);
	if ((oldConso != EF.value) && (EF.value == "" || EF.value.trim() == "")) {//alert('EF.value: ' + EF.value);
		EF.value = "0";
	}
	
	
	if (!CalculerTotaux(Obj,EF)) { 
		EF.focus;
		return false;
	}
	//PPM 57865 : appel de la fonction de mise en style du mois
	//FAD PPM 64579 : l'appel de la fonction setStyleMois ne va plus se faire qu'à conditions 
	//setStyleMois(Obj);	
			
	// Si valeur saisie non vide et strictement positive
	if (EF.value && EF.value != "" && parseInt(EF.value) > 0) {		
		
		var indiceLigne = Obj.split('_')[1];

		var choix =  document.getElementsByName("choix_" + indiceLigne + "_" + (<%=index1 %> + 1))[0];
 
		// Si le choix est "Désaffecter"
		if (choix.value == "2") {
			// Afficher message erreur métier
			alert(prefixeMessageErreurDesaffect + lig + prefixeMessageErreurSsTache + numsEtapeTacheSsTache + suffixeMessageErreurDesaffect);
			// Focus sur le champ
			EF.focus();
			return false;
		}
		// Si le choix est "Supprimer"
		else if (choix.value == "3") {
			alert(prefixeMessageErreurSuppr + lig + prefixeMessageErreurSsTache + numsEtapeTacheSsTache + suffixeMessageErreurSuppr);
			// Focus sur le champ
			EF.focus();
			return false;
		}

	}
	
	return true; 
}

function CalculerTotaux(Obj,EF)
{
 nombre='';
  if (!VerifierDec( EF,5,2)) nombre='invalid'; 

tab = Obj.split('_');
i=tab[1];
j=tab[2];

tab_oldconso=eval("document.forms[0].old_"+i+"_"+j).value.split(',');
old_conso=tab_oldconso[0]+(tab_oldconso[1]==undefined?"":'.'+tab_oldconso[1]);

//Calcul du total de la sous-tÃ¢che
 totalpid=0;
 nbmois= document.forms[0].nbmois.value ;

 for (k=1;k<=nbmois;k++) {
   TOTPID =eval("document.forms[0].conso_"+i+"_"+k).value;
   if (TOTPID=="") TOTPID=0;
    virgule=TOTPID.toString().split(',');
    totalpid=parseFloat(virgule[0]+'.'+virgule[1])+parseFloat(totalpid); 
  }

    totalpid= Math.round(totalpid*100)/100;

    TOT_PID=totalpid.toString().split('.');
 
        totalpid=TOT_PID[0]+(TOT_PID[1]==undefined?"":','+TOT_PID[1]);
  
  eval("document.forms[0].total_pid_"+tab[1]).value=(totalpid==0?"":totalpid);


 //calcul du total du mois en colonne
 //nb de lignes dans la page
 /*nbtotligne=parseInt("14");
 if (nbtotligne>10) {
    nbligne = Math.round(nbtotligne/10);
    nbligne = (nbligne<1?nbligne:10);
 }
 else
   nbligne=nbtotligne;*/

//nbligne=10;

 nbligne=<bean:write name="saisieConsoForm"  property="blocksize" />;

  //On calcule la somme des consos pour la page, on la soustrait du total du mois,
  // puis on ajoute la somme des nouveaux consos
 oldtotalmois=0;
 for (k=1;k<=nbligne;k++) {
       if (eval("document.forms[0].old_"+k+"_"+j)) {
        	old_conso = eval("document.forms[0].old_"+k+"_"+j).value;
			old_conso = (old_conso=="" ? 0 : old_conso);
			tab_oldconso=old_conso.toString().split(',');
         	oldtotalmois=parseFloat(tab_oldconso[0]+'.'+tab_oldconso[1])+parseFloat(oldtotalmois);
		}
        else 
          break;

}
  oldtotalmois= Math.round(oldtotalmois*100)/100;


  totalmois=0;
  for (k=1;k<=nbligne;k++) {
    if (eval("document.forms[0].conso_"+k+"_"+j)) {
  		CONSO = eval("document.forms[0].conso_"+k+"_"+j).value;
		CONSO = (CONSO=="" ? 0 : CONSO);
		tab_conso=CONSO.toString().split(',');
         totalmois=parseFloat(tab_conso[0]+'.'+tab_conso[1])+parseFloat(totalmois);
     }
     else break;
}
 totalmois= Math.round(totalmois*100)/100;

 oldtotmois=eval("document.forms[0].old_tot_mois_"+j).value;
 oldtotmois = oldtotmois==""?0:oldtotmois;
 tab_oldtotmois=oldtotmois.toString().split(',');
 oldtotmois=tab_oldtotmois[0]+'.'+tab_oldtotmois[1]; 
 
TOT_MOIS = parseFloat(oldtotmois) - oldtotalmois +totalmois;

 tab_totmois=TOT_MOIS.toString().split('.');
//FAD PPM 64579 : Sauvegarde de l'ancienne valeur du total
 eval("document.forms[0].old_total_mois_"+j).value = eval("document.forms[0].tot_mois_"+j).value;
 var oldtt = eval("document.forms[0].old_total_mois_"+j).value;
 if (oldtt == "" || oldtt == null)
	 oldtt = "0";
//FAD PPM 64579 : Fin  
 eval("document.forms[0].tot_mois_"+j).value =tab_totmois[0]+
					(tab_totmois[1]==undefined?"":','+tab_totmois[1]);
 
//FAD PPM 64579 : Test pour n'exécuter la procédure setStyleMois de changement de couleur que si le nouveau total est différent de l'ancien
 var tt = eval("document.forms[0].tot_mois_"+j).value;
 if (tt == "" || tt == null)
	 tt = "0";

 if ((tt != "0" && oldtt == "0") || (tt == "0" && oldtt != "0"))
 {
	 setStyleMois("document.forms[0].tot_mois_"+j); 
 }
 //FAD PPM 64579 : Fin

//calcul du total des consos de la ressource pour l'annÃ©e
 tot=0;
 for (k=1;k<=nbmois;k++) {
    TOTAL= eval("document.forms[0].tot_mois_"+k).value;
    TOTAL= (TOTAL==""?0:TOTAL);
    tab_tot=TOTAL.toString().split(',');
    tot = parseFloat(tab_tot[0]+'.'+tab_tot[1])+parseFloat(tot);
 
 }
     tot =Math.round(tot*100)/100;
     tab_total=tot.toString().split('.');

 document.forms[0].total.value=tab_total[0]+(tab_total[1]==undefined?"":','+tab_total[1]);

if (nombre=='invalid') return false;
else {
tab_conso=EF.value.split('.');
CONSO=tab_conso[0]+(tab_conso[1]==undefined?"":','+tab_conso[1]);
EF.value=CONSO;
return true;
 }  
}


function Verifier(form, action, flag, save)
{
	blnVerification = flag;
	form.action.value = action;
	form.save.value = save;
}
function ValiderEcran(form)
{
           
    return true;
}

function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}

function rafraichir(page, action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
	document.forms[0].index.value=<%= index1 %>;
	document.forms[0].submit();
}


function affectST(){

document.forms[0].action.value ="valider";
document.forms[0].type_valider.value ="affecter";
document.forms[0].submit();
window.open("/affectation_ident.do?action=suite&mode=affecter&ident="+ident+"&listecodsg="+listecodsg+"&listesoustaches="+listesoustaches+"&codsg="+codsg+"&ressource="+ressource,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=800, height=800") ;
return true;
}  


function affectation(){
document.forms[0].action.value ="valider";
document.forms[0].type_valider.value ="affecter";
document.forms[0].submit();

//window.opener.location.href="/affectation_ident.do?action=suite&mode=affecter&ident="+ident+"&ressource="+ressource+"&position=<%= sPosition %>&position_blocksize=<%= sPosition_blocksize %>&indexMenu=<%= sIndexMenu %>";

var page_location = "";

page_location = '/affectation_ident.do?action=suite&mode=affecter&ident='+ident+'&listecodsg='+listecodsg+'&listesoustaches='+listesoustaches+'&codsg='+codsg+'&ressource='+ressource+'&position=<%= sPosition %>&position_blocksize=<%= sPosition_blocksize %>&indexMenu=<%= sIndexMenu %>&choix_ress="<bean:write name="saisieConsoForm"  property="choix_ress" />&ordre_tri="<bean:write name="saisieConsoForm"  property="ordre_tri" />"&blocksize="<bean:write name="saisieConsoForm"  property="blocksize" />"';


page_location;

page_location = '/affectation_ident.do?action=suite&mode=affecter&ident='+ident+'&listecodsg='+listecodsg+'&listesoustaches='+listesoustaches+'&codsg='+codsg+'&ressource='+ressource+'&position=<%= sPosition %>&position_blocksize=<%= sPosition_blocksize %>&indexMenu=<%= sIndexMenu %>&choix_ress="<bean:write name="saisieConsoForm"  property="choix_ress" />&ordre_tri="<bean:write name="saisieConsoForm"  property="ordre_tri" />"&blocksize="<bean:write name="saisieConsoForm"  property="blocksize" />"';


page_location;


return true;
}


</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0">
<div style="display:none;" id="ajaxResponse"></div>
<div id="divAideChoix">
	<img src="../images/pucenoir.gif"><b>(Vide)</b>: Aucune particularit&eacute; demand&eacute;e pour cette sous-t&acirc;che,<br>
	<img src="../images/pucenoir.gif"><b>"D"</b>: Demande de <u>D&eacute;saffectation</u> (suppression de l'aff&eacute;ctation &agrave; cette sous-t&acirc;che),<br>
	<img src="../images/pucenoir.gif"><b>"S"</b>: Demande de <u>Suppression</u> de la sous-t&acirc;che,<br>
	<img src="../images/pucenoir.gif"><b>"F"</b>: Demande ou maintient de mise en <u>Favorite</u> de la sous-t&acirc;che.<br>
</div>
<!-- FAD PPM 64368 QC 1914 : Modification du style pour agrandir l'écran --> 
<div style="height:118%;" id="mainContainer2">
<div id="topContainer2">
<!-- FAD PPM 64368 QC 1914 : Fin --> 
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
       

        <tr> 
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->
          Saisie des consomm&eacute;s
           <!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/saisieConso"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0" cellspacing="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     <input type="hidden" name="indexMenu" value="<%= sIndexMenu %>">
                     <html:hidden property="action"/>
					<html:hidden property="arborescence" value="<%= arborescence %>"/>
                     <html:hidden property="save"/>
                     <html:hidden property="blocksize"/>
                     <html:hidden property="type_valider"/>
                     <html:hidden property="ordre_tri"/>
                     <html:hidden property="page" value="modifier"/>
                     <input type="hidden" name="index" value="modifier">
                     <html:hidden property="nbmois"/>
                     <html:hidden property="isAnneeEntiere"/>
                     <html:hidden property="ident"/>
                     <html:hidden property="codsg"/>
                     <html:hidden property="keyList0"/> <!--ident-->
                     <html:hidden property="position"/> <!--position de la ressource dans la liste-->
                     <html:hidden property="position_blocksize"/> <!--position de la ressource dans la liste-->
                     <html:hidden property="choix_ress"/> <!--choix de la liste des ressources-->
                     <html:hidden property="lock"/>
					 <html:hidden property="listeCodsgString"/>
					 <html:hidden property="listeSousTaches" />
                     
				    <div id="content">
					<table border=0 cellspacing=0 cellpadding=2 class="tableBleu">
						<tr>
							<td>&nbsp;</td>
							<td align="left" class="texte"><b>Ressource : <bean:write name="saisieConsoForm" property="ressource"/></b>
							   <html:hidden property="ressource"/>
							</td>
							<td>&nbsp;</td>

							<td align="left" class="texte"><b>Mois : <bean:write name="saisieConsoForm" property="mois"/></b>
							  <html:hidden property="mois"/>
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td align="left" colspan=5>
                      <table border=0 cellspacing=0 cellpadding=2 >
       
                      <tr> 
                      	
					<td width="130px" class=libisac><b>Ligne<br>BIP	</b></td>
					<td width="30" class=libisac align="center"><b>Choix<br><img src="../images/aide.png" id="aideChoix" width="12" height="12"></b></td>
					<td height="10" class=libisac><b>Etape<BR>	
						&nbsp;&nbsp;T&acirc;che<BR>
					&nbsp;&nbsp;&nbsp;&nbsp;Sous-t&acirc;che	</b></td>
					<td align="center" class=libisac id="jan"><b>jan</b></td>
					<td align="center" class=libisac id="fev"><b>fev</b></td>
					<td align="center" class=libisac id="mar"><b>mar</b></td>
					<td align="center" class=libisac id="avr"><b>avr</b></td>
					<td align="center" class=libisac id="mai"><b>mai</b></td>
					<td align="center" class=libisac id="jun"><b>jun</b></td>
					<td align="center" class=libisac id="jul"><b>jul</b></td>
					<td align="center" class=libisac id="aou"><b>aou</b></td>
					<td align="center" class=libisac id="sep"><b>sep</b></td>
					<td align="center" class=libisac id="oct"><b>oct</b></td>
					<td align="center" class=libisac id="nov"><b>nov</b></td>
					<td align="center" class=libisac id="dec"><b>dec</b></td>
					<td align="center" class=libisac><b>Total</b></td>
					
				</tr>
      
			<logic:iterate id="element" name="listeConsos" length="<%=  listeConsos.getCountInBlock()  %>" 
            			offset="<%=  listeConsos.getOffset(0) %>"
						type="com.socgen.bip.metier.Consomme"
						indexId="index"> 
			<% if ( i == 0) i = 1; else i = 0;
			   nbligne ++;
			   libPid="pid_"+nbligne;
			   libEcet="ecet_"+nbligne;
			   libActa="acta_"+nbligne;
			   libAcst="acst_"+nbligne;
			   libEtape="etape_"+nbligne;
			   libTache="tache_"+nbligne;
			   libSousTache="sous_tache_"+nbligne;
			   libTotalPid="total_pid_"+nbligne;
			   libAffect="affect_"+nbligne;
			   libExistConso="existeConsomme_"+nbligne;
			   libChoix="choix_"+nbligne + "_" + (index1 + 1);
			   libChoixOld="choix_old_" + nbligne + "_" + (index1 + 1);
			   libChoixPrecedent="choix_precedent_" + nbligne + "_" + (index1 + 1);
			%>
				<tr class="<%= strTabCols[i] %>">
					<td colspan="2">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td class="contenuisac" width="130px">
									<bean:write name="element" property="typetape" /> - <bean:write name="element" property="typproj" /><BR>	
									<B><bean:write name="element" property="pid" /></B>
								</td>
								<td align="right">
									<input type="hidden" name="<%=libChoixOld %>" value="<%=element.getChoixOld() %>">
									<input type="hidden" name="<%=libChoixPrecedent %>" value="<%=element.getChoix() %>">
									<select name="<%=libChoix %>" <% if (saisieConsoForm.getIsAnneeEntiere()) { %> disabled<% } %> onchange="validerChoix(this, 
																																		'<%=libChoixPrecedent %>', 
																																		'<bean:write name="element" property="pid" />', 
																																		'<bean:write name="element" property="sous_tache" />',
																																		'<bean:write name="saisieConsoForm" property="ident"/>',
																																		'<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />')">
										<option value="1" <% if (element.getChoix().equals(new Integer(1))) {%>selected="selected"<%} %>>&nbsp;</option>
										<option value="2" <% if (element.getChoix().equals(new Integer(2))) {%>selected="selected"<%} %>>D</option>
										<option value="3" <% if (element.getChoix().equals(new Integer(3))) {%>selected="selected"<%} %>>S</option>
										<option value="4" <% if (element.getChoix().equals(new Integer(4))) {%>selected="selected"<%} %>>F</option>
									</select>
								</td>
							</tr>
							<tr>
								<td class="contenuisac" width="160px" colspan="2">
									<bean:write name="element" property="lib" />
									<input type="hidden" name="<%=libPid%>" value="<bean:write name='element' property='pid' />">
									<input type="hidden" name="<%=libExistConso%>" value="<bean:write name='element' property='existeConsomme' />">
									<BR>
									<bean:write name="element" property="aist" />
								</td>
							</tr>
						</table>
   					</td>
   					<td >
<PRE class="etapeisac"><bean:write name="element" property="ecet" /> - <bean:write name="element" property="libetape" />
<bean:write name="element" property="acta" /> - <bean:write name="element" property="libtache" />
<bean:write name="element" property="acst" /> - <bean:write name="element" property="asnom" /></PRE>
						<input type="hidden" name="<%=libEcet%>" value="<bean:write name="element" property="ecet" />">
						<input type="hidden" name="<%=libActa%>" value="<bean:write name="element" property="acta" />">
						<input type="hidden" name="<%=libAcst%>" value="<bean:write name="element" property="acst" />">
						<input type="hidden" name="<%=libEtape%>" value="<bean:write name="element" property="etape" />">
						<input type="hidden" name="<%=libTache%>" value="<bean:write name="element" property="tache" />">
						<input type="hidden" name="<%=libSousTache%>" value="<bean:write name="element" property="sous_tache" />">
				</td>
				<%	
					int aist_moisFerme = 13;
				    int aist_anneeFerme = 0;
 				    int moisFerme=(new Integer(element.getMoisfin().substring(0,2))).intValue();
				    int moisDebut=(new Integer(element.getDatedebut().substring(0,2))).intValue();
				    int anneeDebut=(new Integer(element.getDatedebut().substring(3,7))).intValue();
				    int anneeFerme=(new Integer(element.getMoisfin().substring(3,7))).intValue();
				      //Start of BIP-196 user story implementation 
				      if(element.getAist_moisfin() != null) {
				     aist_moisFerme = (new Integer(element.getAist_moisfin().substring(0,2))).intValue();
				     aist_anneeFerme = (new Integer(element.getAist_moisfin().substring(3,7))).intValue();
				    }
				      //End of BIP-196 user story implementation
				    java.util.GregorianCalendar  date = new java.util.GregorianCalendar();
				    int anneeCourant = date.get(java.util.Calendar.YEAR);
				    int moisCourant = date.get(java.util.Calendar.MONTH) + 1;				    
				    k= (new Integer(nbMois)).intValue();
				    String statut = element.getStatut();
				    if (statut==null) statut="";
				  			    
				    Class[] parameterString = {};
				    String conso="";
				    Object oConso=null;
				    Object ofermee=null;
				    String fermee="";
				    //Start of BIP-196 user story implementation
				  int finalMoisFerme = moisFerme;
				  int finalAnneeFerme = anneeFerme;
				  //Start of BIP-196 user story implementation
				  if(aist_moisFerme != 13) {
				  	if(aist_anneeFerme < anneeFerme) {
				  		finalMoisFerme = aist_moisFerme;
				  		finalAnneeFerme = aist_anneeFerme;
				  	} else if(aist_anneeFerme == anneeFerme && (aist_moisFerme <= moisFerme)) {
				  		finalMoisFerme = aist_moisFerme;
				  		finalAnneeFerme = aist_anneeFerme;
				  	}
				  }
				  //End of BIP-196 user story implementation
			
				 
				for (j=1 ; j<=k;j++) {
						//mois=j-1;
                        	    libConso="conso_"+nbligne+"_"+j;
                            	    libOld="old_"+nbligne+"_"+j;
                        	try {
                        		
                        	   Object[] param1 = {};
                     
                        	   oConso= element.getClass().getDeclaredMethod("getConso_"+j,parameterString).invoke((Object) element, param1);
                        	   if (oConso!=null) conso=oConso.toString();
                        	   else conso="";
                        	   
                        	   ofermee=element.getClass().getDeclaredMethod("getFermee",parameterString).invoke((Object) element, param1);
                        	   if (ofermee!=null) fermee=ofermee.toString();
                        	   else fermee="";
                        
             
							  //BIP 612 changes - retro sub menu check
							   
							     if(null!=saisieConsoForm.getRetroIdent()){ 
							    			 
							    				if(j<mon){
							     %>
							   							<td  align="center" >
                										<input type='text' size=2  class="inputmois" name="<%=libConso%>" value="<%=conso%>"  disabled   onfocus="valueOfOldConso(this);" onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" >
                										<input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                										</td>
							  <% 
							  					}else
							  						   { %>
							  						   <td  align="center" >
                										<input type='text' size=2  name="<%=libConso%>" value="<%=conso%>"  <% if ( "O".equals(lock)) {%> disabled <%}%>  onfocus="valueOfOldConso(this);" onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" >
                										<input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                										</td>
							  						  <%}
							  						   }				  
							  //CAS PAS DE DATE DE FERMETURE : TOUT EST SAISISSABLE/MODIFIABLE SUR L'ANNEE EN COURS 
                               else	if(moisFerme==13 && aist_moisFerme == 13){
                		            	   		if(j==kmois){
                									%>
                										<td  align="center" >
                										<input type='text' size=2  class="inputmois" name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%>  onfocus="valueOfOldConso(this);" onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" >
                										<input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                										</td>
                									<%
                								}else{ 
                									%>
                										<td  align="center" >
                										<input type='text' size=2  name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%> onfocus="valueOfOldConso(this);" onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" >
                										<input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                										</td>
                									<%
                								}            	               	                                                         	   
                               //CAS ANNEE COURANTE > ANNEE FERMETURE  : Aucune Saisie/modification possible 
                               /*Start of Bip - 196 user story implmentation*/              
                               }else if(finalMoisFerme < kmois && finalAnneeFerme <= kanne) {
                               			%> 
                			            	   <td  align="center">
                			   					   <input type='text'  class=inputgras disabled  size=2 name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%> onfocus="valueOfOldConso(this);"onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" readonly="true" >
                			   					   <input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                			   			       </td> 
                							<%	
                               }else if(finalMoisFerme >= kmois && finalAnneeFerme >= kanne) {
                               		if(j<=finalMoisFerme) {
                               				%>
                										<td  align="center" >
                										<input type='text' size=2  name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%> onfocus="valueOfOldConso(this);" onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" >
                										<input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                										</td>
                									<%
                									} else {
                									%>
                										 <td  align="center">
                			   					   <input type='text'  class=inputgras disabled  size=2 name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%> onfocus="valueOfOldConso(this);"onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" readonly="true" >
                			   					   <input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                			   			       </td>
                			   			      <%
                									}
                               }
                                /*End of Bip - 196 user story implmentation*/   
                               else if(moisFerme<13 && anneeCourant>anneeFerme){
                		       				%> 
                			            	   <td  align="center">
                			   					   <input type='text'  class=inputgras disabled  size=2 name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%> onfocus="valueOfOldConso(this);"onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" readonly="true" >
                			   					   <input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                			   			       </td> 
                							<%				                                       	   
                			  //CAS ANNEE COURANTE = ANNEE FERMETURE 
                              }else if(moisFerme<13 && anneeFerme==anneeCourant) {
                	            	 //Si mois en cours > mois de Fermeture : Aucune saisie/modification possible
                	            	 if( moisCourant >  moisFerme){
                	            		 %>
                	   					   <td  align="center">
                	   					   <input type='text'  class=inputgras disabled  size=2 name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%> onfocus="valueOfOldConso(this);" onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" readonly="true" >
                	   					   <input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                	   				       </td>
                	   					 <%	            	    
                            	    //Si le mois en cours <= mois de fermeture : on peut saisir ou modifier de janvier à M.
                              		}else if(moisCourant <= moisFerme) {
                		           	  			 
                		           	  			if(j > moisFerme){
			                		           	  		%>
			    											<td  align="center" >
			    											<input type='text'class=inputgras disabled   size=2  name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%> onfocus="valueOfOldConso(this);" onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" >
			    											<input type='hidden' name="<%=libOld%>" value="<%=conso%>">
			    											</td>
			    										<%
                		           	  			}else if(j==kmois) {
                										%>
                											<td  align="center" >
                											<input type='text' size=2  class="inputmois" name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%> onfocus="valueOfOldConso(this);" onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" >
                											<input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                											</td>
                										<%
                								}else { 
                										%>
                											<td  align="center" >
                											<input type='text' size=2  name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%> onfocus="valueOfOldConso(this);" onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" >
                											<input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                											</td>
                										<%
                								} 	   
                					
                	           	}//Fin si moisCourant <= moisFermé
                           	//anneeFerme  > anneeCourant   : Tout est saisissable
                            }else if(anneeFerme > anneeCourant) {		
                           	  			if(j==kmois) {
                									%>
                										<td  align="center" >
                										<input type='text' size=2  class="inputmois" name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%> onfocus="valueOfOldConso(this);" onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" >
                										<input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                										</td>
                									<%
                						}else { 
                									%>
                										<td  align="center" >
                										<input type='text' size=2  name="<%=libConso%>" value="<%=conso%>" <% if ( "O".equals(lock)) {%> disabled <%}%> onfocus="valueOfOldConso(this);" onkeypress="VerifEntree(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" onBlur="return CalculerTotMois(this.name,this, '<bean:write name="element" property="pid" />','<bean:write name="element" property="ecet" />/<bean:write name="element" property="acta" />/<bean:write name="element" property="acst" />');" >
                										<input type='hidden' name="<%=libOld%>" value="<%=conso%>">
                										</td>
                									<%
                						}	           	  			  									
                          }//FIN TESTS SUR ANNEE                        	      
               
				} catch (NoSuchMethodException me) {
					%>
					NoSuchMethodException 
					
					<%
					} catch (SecurityException se) {
					%>SecurityException
					<%	
					} catch (IllegalAccessException ia) {
					%>IllegalAccessException
					<%
					} catch (IllegalArgumentException iae) {
					%>IllegalArgumentException
					<%
					} catch (InvocationTargetException ite) {
					%>InvocationTargetException
					<%	
					}
					}//for
					
					int l=0;
					for (l=1; l<=12-k;l++) {
					%>	
						<td> &nbsp;</td>
					<%	
					}
					%>
	               <td align="center"><input readonly class=inputgras type='text' size=3 name="<%=libTotalPid%>" value="<bean:write name="element" property="total_pid" />">

     			   </td>
				    			
   				</tr>		
                  </logic:iterate> 
                  
                  <tr>
<td colspan="3" align="center" class="libisac"><b>Total</b></td>
<!-- FAD PPM 64368 : Elargissement de la taille des champs totaux -->
<td align="right" class="libisac"><B> <html:text property="tot_mois_1" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_1"/>
<!-- FAD PPM 64579 : Ajout de la variable hidden old_total_mois_ qui comportera les valeurs des totaux avant MAJ -->
<html:hidden property="old_total_mois_1"/>
</td>
<td align="right" class="libisac"><B> <html:text property="tot_mois_2" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_2"/>
<html:hidden property="old_total_mois_2"/>
</td>
<td align="right" class="libisac"><B> <html:text property="tot_mois_3" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_3"/>
<html:hidden property="old_total_mois_3"/>
</td>
<td align="right" class="libisac"><B> <html:text property="tot_mois_4" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_4"/>
<html:hidden property="old_total_mois_4"/>
</td>
<td align="right" class="libisac"><B> <html:text property="tot_mois_5" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_5"/>
<html:hidden property="old_total_mois_5"/>
</td>
<td align="right" class="libisac"><B> <html:text property="tot_mois_6" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_6"/>
<html:hidden property="old_total_mois_6"/>
</td>
<td align="right" class="libisac"><B> <html:text property="tot_mois_7" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_7"/>
<html:hidden property="old_total_mois_7"/>
</td>
<td align="right" class="libisac"><B> <html:text property="tot_mois_8" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_8"/>
<html:hidden property="old_total_mois_8"/>
</td>
<td align="right" class="libisac"><B> <html:text property="tot_mois_9" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_9"/>
<html:hidden property="old_total_mois_9"/>
</td>
<td align="right" class="libisac"><B> <html:text property="tot_mois_10" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_10"/>
<html:hidden property="old_total_mois_10"/>
</td>
<td align="right" class="libisac"><B> <html:text property="tot_mois_11" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_11"/>
<html:hidden property="old_total_mois_11"/>
</td>
<td align="right" class="libisac"><B> <html:text property="tot_mois_12" styleClass="inputgras" size="7" readonly="true"/> </B>
<html:hidden property="old_tot_mois_12"/>
<html:hidden property="old_total_mois_12"/>
</td>

<td align="right" class="libisac"> <html:text  property="total" styleClass="inputgras" size="8" readonly="true"/>
<html:hidden property="old_total"/>
</td>
<!-- FAD PPM 64368 : Fin -->

</tr>
<tr>
<td colspan="3" align="center" class="libisac"><b>Nombre de jours ouvr&eacute;s</b></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_1" />&nbsp;<html:hidden property="nbjour_1"/></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_2" />&nbsp;<html:hidden property="nbjour_2"/></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_3" />&nbsp;<html:hidden property="nbjour_3"/></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_4" />&nbsp;<html:hidden property="nbjour_4"/></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_5" />&nbsp;<html:hidden property="nbjour_5"/></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_6" />&nbsp;<html:hidden property="nbjour_6"/></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_7" />&nbsp;<html:hidden property="nbjour_7"/></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_8" />&nbsp;<html:hidden property="nbjour_8"/></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_9" />&nbsp;<html:hidden property="nbjour_9"/></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_10" />&nbsp;<html:hidden property="nbjour_10"/></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_11" />&nbsp;<html:hidden property="nbjour_11"/></td>
<td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieConsoForm" property="nbjour_12" />&nbsp;<html:hidden property="nbjour_12"/></td>
<td class="libisac">&nbsp;</td>

</tr>
     
                      
                   
               	</table>
             
             	<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   	<tr>
					<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeConsos"/>
					</td>
				</tr>
	 			<tr><td colspan="4">&nbsp;
	 			</tr>
	 			<tr>
              		              		
	                <% if(isSousMenusISAC){ %>
			   		<td width="20%">
                	 <div align="center">
                      <logic:equal name="saisieConsoForm" property="lock" value="N">    
                     <BUTTON name="annuler" Class="input" onclick="affectation();">Affecter S-t&acirc;che</BUTTON>	 
                       </logic:equal>
                       <logic:equal name="saisieConsoForm" property="lock" value="O">
                	    <BUTTON disabled name="annuler" Class="input" onclick="affectation();">Affecter S-t&acirc;che</BUTTON>	 
                	  </logic:equal>
     	             </div>
               		</td> 
			      <%} %>
			      
              		<% 
                     if(k != 12){ %>
				
			   		<td width="20%"> 
                  	 <div align="center">
                  	 <logic:equal name="saisieConsoForm" property="lock" value="N"> 
                  	 <BUTTON name="boutonAnnuler" Class="input" onclick="rafraichir('listeConsos','refresh');">Ann&eacute;e enti&egrave;re</BUTTON>
                	  </logic:equal>
                	  <logic:equal name="saisieConsoForm" property="lock" value="O">
                	  <input type="submit" name="boutonAnnuler" value="Ann&eacute;e enti&egrave;re" disabled class="input">
                	  </logic:equal>
              		 </div>
                     </td>
			      <%}%>
              		
              		
              		<td width="20%">
                	 <div align="center">
                	 <logic:equal name="saisieConsoForm" property="lock" value="N">
                	  	<html:submit property="boutonValider" value="Valider" styleClass="inputvalider" onclick="Verifier(this.form, 'valider', true, 'NON');"/>
                	  </logic:equal>
                	  <logic:equal name="saisieConsoForm" property="lock" value="O">
                	  	<input type="submit" name="boutonValider" value="Valider" disabled class="inputvalider">
                	  </logic:equal>
                	 </div>
               		</td> 
               		
               		<td width="20%">
		                	 <div align="center">
		                	 <logic:equal name="saisieConsoForm" property="lock" value="N">
		                	  <html:submit property="boutonSave" value="Brouillon" styleClass="inputsubmit" onclick="Verifier(this.form, 'valider', true, 'OUI');"/>
		                	 </logic:equal>
		                	 <logic:equal name="saisieConsoForm" property="lock" value="O">
		                	 <input type="submit" name="boutonSave" value="Brouillon" disabled class="inputsubmit">
		                	 </logic:equal>
		                	 </div>
		            </td> 
               		               		
               		<td width="20%"> 
                  	 <div align="center"> 
                	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false, 'NON');"/>
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
				</div>
				
				
				</table>
                    <!-- #EndEditable --></div>
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
</div>
<!-- FAD PPM 64368 QC 1914 : Modification du style pour agrandir l'écran --> 
<div id="bottomContainer1">
<!-- FAD PPM 64368 QC 1914 : Fin --> 
		<div>&nbsp;</div>
</div>
</div>

<script>
$('#aideChoix').hover(
	function(event) {
		$('#divAideChoix').show();
		$('#divAideChoix').css({ 'top': event.y - 155 + 'px', 'left': event.x + 200 + 'px' });
	},
	function(event) {
		$('#divAideChoix').hide();
});
</script>

</body>
<% 
Integer id_webo_page = new Integer("6009"); 
com.socgen.bip.commun.form.AutomateForm formWebo = saisieConsoForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
