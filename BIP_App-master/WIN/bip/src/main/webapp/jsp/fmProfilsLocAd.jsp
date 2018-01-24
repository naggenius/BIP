 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="profilsLocalizeForm" scope="request" class="com.socgen.bip.form.ProfilsLocalizeForm" />
<%@page import="com.socgen.bip.form.ProfilsLocalizeForm"%>
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
<jsp:include page="ajax.jsp" flush="true" />


<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmProfilsLocAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
    String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
    
%>
var pageAide = "<%= sPageAide %>";
var envDate = 2017;
var tmpAction = "";
function MessageInitial()
{
   var Message="<bean:write filter="false"  name="profilsLocalizeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="profilsLocalizeForm"  property="focus" />";
   var test = new RegExp("cette Date Effet","gi");
   var recherche = Message.search(test);
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
   	  if(recherche!=-1)
   	  document.forms[0].date_effet.focus();
   	  else
   	  document.forms[0].filtre_localize.focus();
	  
   }
   document.forms[0].date_effet.value = '';
   
}

//Appel en ajaxx pour regarder si le code profil DomFonc existe déjà
function isValidProfilLocalize() {
	if (TraitementAjax('isValidProfilLocalize', '&filtre_localize=' + document.forms[0].filtre_localize.value + '&filtre_date=' + document.forms[0].filtre_date.value, 'filtre_localize') == false) {
		return false;
	}
	return true;
}

function Incoherence(nomChamp) {

	// Affichage d'une popup , mise en focus sur le champ incohérent et renvoie de false
	alert("Votre demande n'est pas compréhensible, veuillez saisir une combinaison de champs, de valeurs et un bouton cohérents");
	var element = document.getElementById(nomChamp);
	element.focus();
	return false;
}

function ValiderEcran(choix)
{
	if (!ChampObligatoire(document.forms[0].filtre_localize, "un Profil Localisés")) {
		return false;
	}
	 
	if(choix == "suite") {
		return ValiderSuite();
		
	} else {
		if(document.forms[0].filtre_localize.value == "*") {
			return Incoherence("filtre_localize");
		}
		if(choix == "creer") {
			return ValiderCreer();
		} else {
			if (document.forms[0].date_effet.value == null || document.forms[0].date_effet.value == "") {
				return Incoherence("date_effet");
			}
			if(choix == "modifier"){
				return ValiderModifier();
			} else {
				if(choix == "supprimer") {
					return ValiderSupprimer();
				}
			}
		}
	}
	
   return false;
}

function ValiderSuite() {
tmpAction = "suite";
 	if (!(VerifierAlphaMaxCarSpec(document.forms[0].filtre_localize)))	{
 			document.forms[0].elements[3].focus();
			return false;
	}
	else if (document.forms[0].filtre_date.value == null || document.forms[0].filtre_date.value == "")
  	{
  		alert("Filtre Date invalide"); 
  		document.forms[0].filtre_date.focus(); 
        document.forms[0].filtre_date.value="";
	    return false;
	} 
	else if (!(VerifierDateSpec(document.forms[0].filtre_date,'AAAA'))) {
		document.forms[0].elements[4].focus();
			return false;
	}
	else if (!(VerifierFiltreDate(document.forms[0].filtre_date))) {	
		document.forms[0].elements[4].focus();
			return false;
	}
	else if (document.forms[0].filtre_localize.value != null || document.forms[0].filtre_localize.value != ""){
		if(isValidProfilLocalize() == false){
		return false;
		}
	}
	document.forms[0].action.value = "suite";
	
}

function ValiderCreer() {
	tmpAction = 'creer';
	if (!(VerifierAlphaMaxCarSpec(document.forms[0].filtre_localize)))	{
 			document.forms[0].elements[3].focus();
			return false;
	}
	else if (!(VerifierDateSpec(document.forms[0].date_effet,'AAAA'))) {
		document.forms[0].elements[6].focus();
			return false;
	} else if (!(VerifierDateEffet(document.forms[0].date_effet,'AAAA'))) {
		document.forms[0].elements[6].focus();
			return false;
	}
			else if (NotExistsProfilLocalize()) {
				document.forms[0].action.value = "creer";
			} else {
				return false;
			} 
	}

function checkDateValider() {
	if(tmpAction == "suite") {
		if (document.forms[0].filtre_date.value == null || document.forms[0].filtre_date.value == "" || document.forms[0].filtre_date.value < envDate) {
				tmpAction="";
		 		return false;
		} else {
			tmpAction="";
			return true;
		}
	}
	else if(tmpAction !== "creer") {
		if (document.forms[0].date_effet.value == null || document.forms[0].date_effet.value == "" || document.forms[0].filtre_localize.value === '*') {
				tmpAction="";
				document.forms[0].elements[3].focus();
				return false;
		}else {
			tmpAction="";
			return true;
		}
	} else {
		if(document.forms[0].filtre_localize.value === '*') {
			tmpAction="";
			document.forms[0].elements[3].focus();
			return false;
		} else {
		tmpAction="";
		return true;
		}
	}	
	tmpAction="";
}


function ValiderModifier() {
tmpAction = "modifier";
if (!(VerifierAlphaMaxCarSpec(document.forms[0].filtre_localize)))	{
 			document.forms[0].elements[3].focus();
			return false;
	}
	else if (!(VerifierDateSpec(document.forms[0].date_effet,'AAAA'))) {
		document.forms[0].elements[6].focus();
			return false;
	} else if (!(VerifierDateEffet(document.forms[0].date_effet,'AAAA'))) {
		document.forms[0].elements[6].focus();
			return false;
	}
	else if (ExistsProfilLocalize()) {
		document.forms[0].action.value = "modifier";
	} else {
		return false;
	}
	
}

function ValiderSupprimer() {
tmpAction = 'supprimer';
if (!(VerifierAlphaMaxCarSpec(document.forms[0].filtre_localize)))	{
 			document.forms[0].elements[3].focus();
			return false;
	}
	else if (!(VerifierDateSpec(document.forms[0].date_effet,'AAAA'))) {
		document.forms[0].elements[6].focus();
			return false;
	} else if (!(VerifierDateEffet(document.forms[0].date_effet,'AAAA'))) {
		document.forms[0].elements[6].focus();
			return false;
	}
	else if (ExistsProfilLocalize()) {
			if(EstProfilLocAffecteRessMensAnnee())
			{
			document.forms[0].action.value = "supprimer";
			}
			else 
			{
			return false;
			}
	} else {
		return false;
	}
}

function EstProfilLocAffecteRessMensAnnee() {
		ajaxCallRemotePage('/profilslocalize.do?action=estProfilLocAffecteRessMensAnnee&filtre_localize=' + document.forms[0].filtre_localize.value + '&date_effet=' + document.forms[0].date_effet.value);
	
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
			document.forms[0].elements[3].focus();
			return false;
		}
	}
}

function TraitementAjax(pMethode, pParams, pFocus) {
	ajaxCallRemotePage('/profilslocalize.do?action=' + pMethode + pParams);
	var tmp = (document.getElementById("ajaxResponse").innerHTML);
	if (ajaxMessageCheck(tmp)) {
		alert(document.getElementById("ajaxResponse").innerHTML);
		var element = document.forms[0].elements[3];
		element.focus();
		return false;
	}
	return true;
}

function ajaxMessageCheck(tmp) {
tmp = tmp.toString();
return (tmp.indexOf(' ') >= 0);
}

/*function ExistsProfilFiDomFonc() {

	if (TraitementAjax('existsProfilFIDomFonc', '&filtre_localize=' + document.forms[0].filtre_localize.value, 'filtre_localize') == false) {
		return false;
	}
	return true;
}*/

function ExistsProfilLocalize() {
	if (TraitementAjax('existsProfilLocalize', '&filtre_localize=' + document.forms[0].filtre_localize.value + '&date_effet=' +document.forms[0].date_effet.value, 'filtre_localize') == false) {
		return false;
	}
	return true;
}

function NotExistsProfilLocalize() {

	if (TraitementAjax('notExistsProfilLocalize', '&filtre_localize=' +  document.forms[0].filtre_localize.value + '&date_effet=' +  document.forms[0].date_effet.value, 'date_effet') == false) {
		return false;
	}
	return true;
}

//fonction creee pour empecher la saisie de caracteres speciaux dans le Profil de DomFonc

function VerifierAlphaMaxCarSpec( EF )
{
   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   var Accents = 'àâäçéèêëîïôöùûüÂÄÊËÈÀÇÉÎÏÔÖÙÛÜ$"; &(@)!:?§/<>+.~#-_{$%+[|`\\^]}=°¤£µ¨\'';

   var Champ = "";
   var Caractere;
   var caretoile = "*";

	if(EF.value.indexOf(caretoile) == 0 && EF.value.length != 1){
	   alert( "Saisie invalide : \n\n - (*) pour tous les Profils Localisés. \n - 12car maxi composés de chiffres ou lettres majuscules non accentuées.");
	   EF.focus();
	   return false;	   
	}
	   
	if(EF.value.indexOf(caretoile) > 0){
	
	   alert( "Saisie invalide : \n\n - (*) pour tous les Profils Localisés. \n - 12car maxi composés de chiffres ou lettres majuscules non accentuées.");
	   EF.focus();
	   return false;
	   
	}else{
		  
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	LaChaine = EF.value.charAt(Cpt);

	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Saisie invalide : \n\n - (*) pour tous les Profils Localisés. \n - 12car maxi composés de chiffres ou lettres majuscules non accentuées.");
	   EF.focus();
	   return false;

	} 
	else if (Alphamin.indexOf(Caractere,0) != -1) {
	   Champ += Alphamax.charAt(Alphamin.indexOf(Caractere,0));
	}
	else
	   Champ += Caractere;
    }

	} // end if global
   EF.value = Champ;
   return true;
   
}


function VerifierFiltreDate( EF, formatDate )
{
   var caretoile = "*";
   aaaa = parseInt( EF.value, 10);
   
   if (EF.value != '' && EF.value != caretoile) {
		 if (isNaN(aaaa) == true) {
			alert( "Date invalide (format "+formatDate+")" );
			EF.focus();
			return false;
		 }
		if (aaaa < envDate) {
			alert( "Année invalide : AAAA <= "+envDate);
			EF.focus();
			return false;
		} 
   } 
   return true;
}

function VerifierDateEffet( EF, formatDate )
{
   aaaa = parseInt( EF.value, 10);
   if (EF.value != '') {
		 if (isNaN(aaaa) == true) {
			alert( "Date invalide (format "+formatDate+")" );
			EF.focus();
			return false
		 }
		if (aaaa < envDate) {
			alert( "Année invalide : AAAA <= "+envDate);
			EF.focus();
			return false
		} 
   } 
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


function VerifierFiltreDate( EF, formatDate )
{
   var caretoile = "*";
   aaaa = parseInt( EF.value, 10);
   
   if (EF.value != '' && EF.value != caretoile) {
		 if (isNaN(aaaa) == true) {
			alert( "Date invalide (format "+formatDate+")" );
			EF.focus();
			return false;
		 }
		if (aaaa < envDate) {
			alert( "Année invalide : AAAA <= "+envDate);
			EF.focus();
			return false;
		} 
   } 
   return true;
}

/** Pour vider deux champs  */
function viderAutreChampDate(elt) {
	
	if (elt.value != '') {
		if (elt.name == 'filtre_date') {
			document.getElementsByName('date_effet')[0].value = '';
		}
		else if (elt.name == 'date_effet') {
			document.getElementsByName('filtre_date')[0].value = '';
		}		
	}	
}


</script>
<!-- #EndEditable -->  


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
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
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->GESTION DES PROFILS Localisés : Sélection du profil<!-- #EndEditable --></td>
        </tr>
        <tr>
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/profilslocalize" onsubmit = "return checkDateValider()" ><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="action" value="creer"/>
			  
              <table border=0 cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td height="40" center colspan=3>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=3>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=left class="texte"><b>Profil Localisé :</b></td>
                  <td> 
                  	<html:text property="filtre_localize" styleClass="input" size="15" maxlength="12" />
                   
                   <span id="indicator3" style="display:none;"><img src="../images/indicator.gif" alt="" /></span>
                   
                  </td>
                  <td align=left class="texte">
                  	<p>* pour tous les Profils localisés<br>
                  	&nbsp;&nbsp;ou 12car maxi composés de chiffres ou lettres majuscules non accentuées,<br>
                  	&nbsp;&nbsp;saisie du début du code profil autorisée</p>
                  </td>
                </tr>
                
                <tr> 
                  <td align=center colspan=3>&nbsp;</td>
                </tr>
                
                <tr> 
                  <td align=left class="texte"><b>A compter de :</b></td>
                  <td> 
                  	<html:text property="filtre_date" styleClass="input" size="15" maxlength="4"/>
                  </td>
                  <td class="texte">
                  	<p>* pour toutes périodes<br>
                  	&nbsp;&nbsp;ou à compter de l'année AAAA (facultatif)</p> 
                  </td>
                </tr>
                
                <tr> 
                  <td height="10" align=center colspan=3>&nbsp;</td>
				</tr>

                <tr> 
                  <td align=center colspan=1>&nbsp;</td>
                  <td align="center">  
                	 <html:submit property="boutonListe" value="Liste" styleClass="input" onclick="return ValiderEcran('suite');" />
                  </td>
                </tr>
                 <tr> 
                  <td align=center colspan=3>&nbsp;</td>
				</tr>
                <tr> 
                  <td height="20" align=center class="texte"><p><b>OU</b></p></td>
                </tr>
                
                <tr> 
                  <td align=center colspan=3>&nbsp;</td>
                </tr>
                
                <tr>
                  <td align=left class="texte"><b>Date Effet :</b></td>
                  <td> 
            		  <html:text property="date_effet" styleClass="input" size="15" maxlength="4"/>
            	  </td>
            	  <td class="texte">
                  	<p>&nbsp;&nbsp;AAAA obligatoire pour Modifier ou Supprimer</p> 
                  </td>
                </tr>
                
                <tr> 
                  <td height="10" align=center colspan=2>&nbsp;</td>
                </tr>
                
              </table>
              <!-- #EndEditable --></div>
            
		</td>
		</tr>
		<tr>
		<td>

		<table align="center" border="0" cellpadding="2" cellspacing="2" class="tableBleu" width="700">
		
                <tr> 
                  <td width="17%" align="center" >  
                	 <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="return ValiderEcran('creer');"/>
                  </td>
                  
				   <td width="25%" align="center">  
     				 <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="return ValiderEcran('modifier');"/>
                  </td>
				   <td width="25%" align="center">  
					<html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="return ValiderEcran('supprimer');"/>
                  </td>
                  <td></td>
                  <td></td>
                </tr>
            
            </table>
		
<!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
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
</div>
</body>
</html:html> 