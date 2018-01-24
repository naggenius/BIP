 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="profilsDomFoncForm" scope="request" class="com.socgen.bip.form.ProfilsDomFoncForm" />
<%@page import="com.socgen.bip.form.ProfilsDomFoncForm"%>
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
<jsp:include page="ajax.jsp" flush="true" />


<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmProfilsDomFoncAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
    String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
    
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="profilsDomFoncForm"  property="msgErreur" />";
   var Focus = "<bean:write name="profilsDomFoncForm"  property="focus" />";
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
   	  document.forms[0].filtre_domfonc.focus();
	  
   }
   
}

//Appel en ajaxx pour regarder si le code profil DomFonc existe déjà
function IsValidProfilDomFonc() {
	if (TraitementAjax('isValidProfilDomFonc', '&filtre_domfonc=' + document.getElementById("filtre_domfonc").value + '&filtre_date=' + document.getElementById("filtre_date").value, 'filtre_domfonc') == false) {
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
	if (!ChampObligatoire(document.forms[0].filtre_domfonc, "un Profil de DomFonc")) {
		return false;
	}
	
	if(choix == "suite") {
		return ValiderSuite();
		
	} else {
		if(document.forms[0].filtre_domfonc.value == "*") {
			return Incoherence("filtre_domfonc");
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

	if (document.forms[0].filtre_date.value == null || document.forms[0].filtre_date.value == "")
  	{
  		alert("Filtre Date invalide"); 
  		document.forms[0].filtre_date.focus(); 
        document.forms[0].filtre_date.value="";
	    return false;
	}

	if (document.forms[0].filtre_domfonc.value != null || document.forms[0].filtre_domfonc.value != ""){
		if(IsValidProfilDomFonc() == false){return false;}
	}
	
	document.forms[0].action.value = "suite";
	
}

function ValiderCreer() {

	if (ExistsProfilFi()) {
		if (document.forms[0].date_effet.value != null && document.forms[0].date_effet.value != "") {
			if (NotExistsProfilDomFonc()) {
				document.forms[0].action.value = "creer";
			} else {
				return false;
			}
		} else {
			document.forms[0].action.value = "creer";
		}
	} else {
		return false;
	}
}

function ValiderModifier() {
	if (ExistsProfilDomFonc()) {
		document.forms[0].action.value = "modifier";
	} else {
		return false;
	}
}

function ValiderSupprimer() {
	if (ExistsProfilDomFonc()) {
			if(EstProfilAffecteRessMensAnnee())
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

function EstProfilAffecteRessMensAnnee() {
	
		ajaxCallRemotePage('/profilsdomfonc.do?action=estProfilAffecteRessMensAnnee&filtre_domfonc=' + document.getElementById("filtre_domfonc").value + '&date_effet=' + document.getElementById("date_effet").value);
	
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

function TraitementAjax(pMethode, pParams, pFocus) {
	ajaxCallRemotePage('/profilsdomfonc.do?action=' + pMethode + pParams);
	if (document.getElementById("ajaxResponse").innerHTML != '') {
		alert(document.getElementById("ajaxResponse").innerHTML);
		var element = document.getElementById(pFocus);
		element.focus();
		return false;
	}
	return true;
}

function ExistsProfilFi() {

	if (TraitementAjax('existsProfilFI', '&filtre_domfonc=' + document.getElementById("filtre_domfonc").value, 'filtre_domfonc') == false) {
		return false;
	}
	return true;
}

function ExistsProfilDomFonc() {

	if (TraitementAjax('existsProfilDomFonc', '&filtre_domfonc=' + document.getElementById("filtre_domfonc").value + '&date_effet=' + document.getElementById("date_effet").value, 'filtre_domfonc') == false) {
		return false;
	}
	return true;
}

function NotExistsProfilDomFonc() {

	if (TraitementAjax('notExistsProfilDomFonc', '&filtre_domfonc=' + document.getElementById("filtre_domfonc").value + '&date_effet=' + document.getElementById("date_effet").value, 'date_effet') == false) {
		return false;
	}
	return true;
}

//fonction creee pour empecher la saisie de caracteres speciaux dans le Profil de DomFonc

function VerifierAlphaMaxCarSpec( EF )
{
   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   var Accents = 'àâäçéèêëîïôöùûüÂÄÊËÈÀÇÉÎÏÔÖÙÛÜ$"; &(@)!:?§/<>+.~#{[|`\\^]}=°¤£µ¨\''

   var Champ = "";
   var Caractere;
   var caretoile = "*";

	if(EF.value.indexOf(caretoile) == 0 && EF.value.length != 1){
	   alert( "Saisie invalide : \n\n - (*) pour tous les Profils de DomFonc. \n - 12car maxi composés de chiffres ou lettres majuscules non accentuées.");
	   EF.focus();
	   return false;	   
	}
	   
	if(EF.value.indexOf(caretoile) > 0){
	
	   alert( "Saisie invalide : \n\n - (*) pour tous les Profils de DomFonc. \n - 12car maxi composés de chiffres ou lettres majuscules non accentuées.");
	   EF.focus();
	   return false;
	   
	}else{
		  
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	LaChaine = EF.value.charAt(Cpt);

	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Saisie invalide : \n\n - (*) pour tous les Profils de DomFonc. \n - 12car maxi composés de chiffres ou lettres majuscules non accentuées.");
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
			return false
		 }
		if (aaaa < 2014) {
			alert( "Année invalide : AAAA >= 2014");
			EF.focus();
			return false
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
		if (aaaa < 2014) {
			alert( "Année invalide : AAAA >= 2014");
			EF.focus();
			return false
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
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->GESTION DES PROFILS par Domaine Fonctionnelle : Sélection du profil<!-- #EndEditable --></td>
        </tr>
        <tr>
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/profilsdomfonc" ><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="action" value="creer"/>
			  
              <table border=0 cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td align=center colspan=3>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=3>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=right class="lib"><b>Profil DomFonc :</b></td>
                  <td> 
                  	<html:text property="filtre_domfonc" styleClass="input" size="13" maxlength="12" onblur="return VerifierAlphaMaxCarSpec(this); " />
                   
                   <span id="indicator3" style="display:none;"><img src="../images/indicator.gif" alt="" /></span>
                   
                  </td>
                  <td align=left>
                  	<p>* pour tous les Profils de Dom Fonc</p>
                  </td>
                </tr>
                
                <tr> 
                  <td align=center colspan=3>&nbsp;</td>
                </tr>
                
                <tr> 
                  <td align=right class="lib"><b>A compter de :</b></td>
                  <td> 
                  	<html:text property="filtre_date" styleClass="input" size="8" maxlength="4" onkeyUp="viderAutreChampDate(this)" onblur="viderAutreChampDate(this)" onchange="return VerifierFiltreDate(this,'AAAA');"/>
                  </td>
                  <td>
                  	<p>* pour toutes périodes<br>
                  	ou à compter de l'année AAAA (facultatif)</p> 
                  </td>
                </tr>
                
                <tr> 
                  <td align=center colspan=3>&nbsp;</td>
				</tr>

                <tr> 
                  <td align=center colspan=1>&nbsp;</td>
                  <td align="center">  
                	 <html:submit property="boutonListe" value="Liste" styleClass="input" onclick="return ValiderEcran('suite');" />
                  </td>
                </tr>
                
                <tr> 
                  <td align=center><u><b>OU</b></u></td>
                </tr>
                
                <tr> 
                  <td align=center colspan=3>&nbsp;</td>
                </tr>
                
                <tr>
                  <td align=right class="lib"><b>Date Effet :</b></td>
                  <td> 
            		  <html:text property="date_effet" styleClass="input" size="8" maxlength="4" onkeyUp="viderAutreChampDate(this)" onblur="viderAutreChampDate(this)" onblur="return VerifierDateEffet(this,'AAAA');"/>
            	  </td>
            	  <td>
                  	<p>AAAA obligatoire pour Modifier ou Supprimer</p> 
                  </td>
                </tr>
                
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                
              </table>
              <!-- #EndEditable --></div>
            
		</td>
		</tr>
		<tr>
		<td align="center">

		<table width="50%" border="0">
		
                <tr> 
                  <td width="20%" align="left">  
                	 <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="return ValiderEcran('creer');"/>
                  </td>
				   <td width="20%" align="left">  
     				 <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="return ValiderEcran('modifier');"/>
                  </td>
				   <td width="20%" align="left">  
					<html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="return ValiderEcran('supprimer');"/>
                  </td>
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
</body>
</html:html> 