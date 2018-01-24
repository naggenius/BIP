 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="profilsfiForm" scope="request" class="com.socgen.bip.form.ProfilsFIForm" />
<%@page import="com.socgen.bip.form.ProfilsFIForm"%>
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
<jsp:include page="ajax.jsp" flush="true" />


<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmProfilsFIAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
    String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
    
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="profilsfiForm"  property="msgErreur" />";
   var Focus = "<bean:write name="profilsfiForm"  property="focus" />";
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
   	  document.forms[0].filtre_fi.focus();
	  
   }
   
}

function Verifier(form, action, flag)
{
      blnVerification = flag;
      form.action.value =action;
 
}

//Appel en ajaxx pour regarder si le code profil fi existe déjà
function isValidProfilFI()
{
var filtre_fi;

	filtre_fi = document.getElementById("filtre_fi").value;
	ajaxCallRemotePage('/profilsfi.do?action=isValidProfilFI&filtre_fi='+filtre_fi);
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		alert(document.getElementById("ajaxResponse").innerHTML);
		document.profilsfiForm.filtre_fi.focus();
		return false;
	
	}
return true;

}

function ValiderEcran(choix)
{

   if (blnVerification==true) {
	if (!ChampObligatoire(document.forms[0].filtre_fi, "un Profil de FI")) return false;
   }
	
	if(choix == "suite"){
		if (document.forms[0].filtre_fi.value != null || document.forms[0].filtre_fi.value != ""){
			if(isValidProfilFI() == false){return false;}
		}
		if (document.forms[0].filtre_date.value == null || document.forms[0].filtre_date.value == "")
      	{
      		alert("Filtre Date invalide"); 
      		document.forms[0].filtre_date.focus(); 
	        document.forms[0].filtre_date.value="";
		    return false;
		}

		document.forms[0].action.value = "suite";

	}
	
		if(choix == "creer"){
		
			if(document.forms[0].filtre_fi.value == "*"){
			
				alert("Profil de FI invalide"); 
	      		document.forms[0].filtre_fi.focus(); 
		        document.forms[0].filtre_fi.value="";
			    return false;
			}
			
			document.forms[0].action.value = "creer";
		}
	
	if(choix == "modifier"){
		if (document.forms[0].date_effet.value == null || document.forms[0].date_effet.value == "")
      	{
      		alert("La Date Effet: MM/AAAA est obligatoire pour Modifier."); 
      		document.forms[0].date_effet.focus(); 
	        document.forms[0].date_effet.value="";
		    return false;
		}
		document.forms[0].action.value = "modifier";
	}
	
	if(choix == "supprimer"){
		if (document.forms[0].date_effet.value == null || document.forms[0].date_effet.value == "")
      	{
      		alert("La Date Effet: MM/AAAA est obligatoire pour Supprimer.");
      		document.forms[0].date_effet.focus(); 
	        document.forms[0].date_effet.value="";
		    return false;
		}
		document.forms[0].action.value = "supprimer";
	}

   return true;
}

function nextFocusCreer(){document.forms[0].boutonCreer.focus();}


//fonction creee pour empecher la saisie de caracteres speciaux dans le Profil de FI

function VerifierAlphaMaxCarSpec( EF )
{
   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   var Accents = 'àâäçéèêëîïôöùûüÂÄÊËÈ$"; &(@)!:?§/<>+.~#{[|`\\^]}=°¤£µ¨\''

   var Champ = "";
   var Caractere;
   var caretoile = "*";

	if(EF.value.indexOf(caretoile) == 0 && EF.value.length != 1){
	   alert( "Saisie invalide : \n\n - (*) pour tous les Profils de FI. \n - 12car maxi composés de chiffres ou lettres majuscules non accentuées.");
	   EF.focus();
	   return false;	   
	}
	   
	if(EF.value.indexOf(caretoile) > 0){
	
	   alert( "Saisie invalide : \n\n - (*) pour tous les Profils de FI. \n - 12car maxi composés de chiffres ou lettres majuscules non accentuées.");
	   EF.focus();
	   return false;
	   
	}else{
		  
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	LaChaine = EF.value.charAt(Cpt);

	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Saisie invalide : \n\n - (*) pour tous les Profils de FI. \n - 12car maxi composés de chiffres ou lettres majuscules non accentuées.");
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
   var Chiffre = "1234567890/";
   var separateur = '/';
   var nbJours;
   var Jpos = 0;
   var err = 0;
   var strJJ = "02";
   var caretoile = "*";
   
   	if(EF.value.indexOf(caretoile)== 0 && EF.value.length !=1){
	   alert( "Date invalide");
	   EF.focus();
	   return false;	   
	}
	
   if (EF.value == caretoile) return true;

   if (EF.value == '') return true;
   
   if (formatDate == 'aaaa') {
	aaaa = parseInt( EF.value, 10);
	if ((isNaN(aaaa) == true) || (aaaa < 1900) || (aaaa > 2100) ) {
	   alert( "Année invalide : AAAA >= 2011" );
	   EF.focus();
	   return false;
	}
	else return true;
   }

   if (EF.value.charAt(2) == separateur) {
	if (formatDate == 'jj/mm/aaaa') {
	   if (EF.value.charAt(5) != separateur) {
		alert( "Date invalide (format "+formatDate+")" );
		EF.focus();
		return false;
	   }
	   else {
		Jpos = formatDate.indexOf('jj') + 3;
		strJJ = EF.value.substring( Jpos -3 , Jpos -1);
	   }
	}
	strMM = EF.value.substring( Jpos , Jpos + 2);
	strAA = EF.value.substring( Jpos + 3 , Jpos + 7);
   }
   else {alert( "Date invalide (format "+formatDate+")" );
	EF.focus();
	return false;
   }

   jj = parseInt( strJJ, 10);
   mm = parseInt( strMM, 10);
   aaaa = parseInt( strAA, 10);

   if (isNaN(jj) == true) err = 1;
   else if (isNaN(mm) == true) err = 2;
   else if (isNaN(aaaa) == true) err = 3;

   if (err != 0) {
	switch(err) {
	   case 1  : alert( "Jour invalide" );  break;
	   case 2  : alert( "Mois invalide : 1<=MM<=12" );  break;
	   case 3  : alert( "Année invalide : AAAA >= 2011" ); break;
	   default : alert( "Date invalide (format "+formatDate+")" );
	}
	EF.focus();
	return false;
   }

   if ( (mm < 1) || (mm > 12) ) {
	alert( "Mois invalide : 1<=MM<=12" );
	EF.focus();
	return false;
   }
   else {
	nbJours = new nbJoursAnnee(aaaa);
	if ((jj > nbJours[mm]) || (jj < 1)) {
	   alert( "Jour invalide" );
	   EF.focus();
 	   return false;
	}
   }
   if ( (aaaa < 2011) || (aaaa > 2100) ) {
	alert( "Année invalide : AAAA >= 2011" );
	EF.focus(); 
	return false;
   }
   return true;
}

function VerifierDateEffet( EF, formatDate )
{
   var Chiffre = "1234567890/";
   var separateur = '/';
   var nbJours;
   var Jpos = 0;
   var err = 0;
   var strJJ = "02";

   if (EF.value == '') return true;
   
   if (formatDate == 'aaaa') {
	aaaa = parseInt( EF.value, 10);
	if ((isNaN(aaaa) == true) || (aaaa < 1900) || (aaaa > 2100) ) {
	   alert( "Année invalide : AAAA >= 2011" );
	   EF.focus();
	   return false;
	}
	else return true;
   }

   if (EF.value.charAt(2) == separateur) {
	if (formatDate == 'jj/mm/aaaa') {
	   if (EF.value.charAt(5) != separateur) {
		alert( "Date invalide (format "+formatDate+")" );
		EF.focus();
		return false;
	   }
	   else {
		Jpos = formatDate.indexOf('jj') + 3;
		strJJ = EF.value.substring( Jpos -3 , Jpos -1);
	   }
	}
	strMM = EF.value.substring( Jpos , Jpos + 2);
	strAA = EF.value.substring( Jpos + 3 , Jpos + 7);
   }
   else {alert( "Date invalide (format "+formatDate+")" );
	EF.focus();
	return false;
   }

   jj = parseInt( strJJ, 10);
   mm = parseInt( strMM, 10);
   aaaa = parseInt( strAA, 10);

   if (isNaN(jj) == true) err = 1;
   else if (isNaN(mm) == true) err = 2;
   else if (isNaN(aaaa) == true) err = 3;

   if (err != 0) {
	switch(err) {
	   case 1  : alert( "Jour invalide" );  break;
	   case 2  : alert( "Mois invalide : 1<=MM<=12" ); break;
	   case 3  : alert( "Année invalide : AAAA >= 2011" ); break;
	   default : alert( "Date invalide (format "+formatDate+")" );
	}
	EF.focus();
	return false;
   }

   if ( (mm < 1) || (mm > 12) ) {
	alert( "Mois invalide : 1<=MM<=12" );
	EF.focus();
	return false;
   }
   else {
	nbJours = new nbJoursAnnee(aaaa);
	if ((jj > nbJours[mm]) || (jj < 1)) {
	   alert( "Jour invalide" );
	   EF.focus();
 	   return false;
	}
   }
   if ( (aaaa < 2011) || (aaaa > 2100) ) {
	alert( "Année invalide : AAAA >= 2011" );
	EF.focus();
	return false;
   }
   return true;
}


/** Pour vider deux champs  */
function viderChamps(elt) {
	
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->GESTION DES PROFILS DE FI: Sélection du profil<!-- #EndEditable --></td>
        </tr>
        <tr>
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/profilsfi" ><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="action" value="creer"/>
			  <html:hidden property="message_fi_ress" />
			  
              <table border=0 cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td align=center colspan=3>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=3>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=right class="lib"><b>Profil de FI :</b></td>
                  <td> 
                  	<html:text property="filtre_fi" styleClass="input" size="13" maxlength="12" onchange="return VerifierAlphaMaxCarSpec(this); " />
                   
                   <span id="indicator3" style="display:none;"><img src="../images/indicator.gif" alt="" /></span>
                   
                  </td>
                  <td align=left>
                  	<p>* pour tous les Profils de FI</p>
                  </td>
                </tr>
                
                <tr> 
                  <td align=center colspan=3>&nbsp;</td>
                </tr>
                
                <tr> 
                  <td align=right class="lib"><b>A compter de :</b></td>
                  <td> 
                  	<html:text property="filtre_date" styleClass="input" size="8" maxlength="7" onkeyUp="viderChamps(this)" onblur="viderChamps(this)" onchange="return VerifierFiltreDate(this,'MM/AAAA');"/>
                  </td>
                  <td>
                  	<p>* pour toutes périodes<br>
                  	ou à compter du mois MM/AAAA (facultatif)</p> 
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
            		  <html:text property="date_effet" styleClass="input" size="8" maxlength="7" onkeyUp="viderChamps(this)" onblur="viderChamps(this)" onchange="return VerifierDateEffet(this,'MM/AAAA');"/>
            	  </td>
            	  <td>
                  	<p>MM/AAAA obligatoire pour Modifier ou Supprimer</p> 
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