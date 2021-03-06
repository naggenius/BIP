<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>IMPRESSION DES PROFILS DE FI: S�lection</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/eProfilsFiAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<jsp:useBean id="UserBip" scope="session" class="com.socgen.bip.user.UserBip" />
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide"))); %>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif		= new Object();

<%
	String sTitre;
	String sInitial;
	String p_global=((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser();
%>

function MessageInitial()
{
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre("eProfilsFiAd");
		if (sTitre == null)	sTitre = "Pas de titre";

		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null) sInitial = request.getRequestURI();
		else sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	
	if (Focus != "")
		(eval( "document.editionForm."+Focus )).focus();
	else {
		document.editionForm.p_param6.focus();
	}
}

function Verifier(form, bouton, flag) {
	form.action.value=bouton;
}

function ValiderEcran(form) {

	if (blnVerification==true) {
		if (!ChampObligatoire(document.forms[0].p_param6, "une direction BIP")) return false;
		if(document.forms[0].p_param6.value!="" && document.forms[0].p_param9.value==""){
		if (!ChampObligatoire(document.forms[0].p_param7, "* pour toutes les p�riodes ou une date (MM/AAAA)")) return false;
		}
		if(document.forms[0].p_param7.value==""){
		if (!ChampObligatoire(document.forms[0].p_param9, "une date (MM/AAAA) de la Mensuelle")) return false;
		}
		
		// on fait appel aux tables d'histo 
		if (document.forms[0].p_param7.value.length == 0)
		{	
			document.forms[0].jobId.value="eProfilsFiHistAd";
		
		}
		else
		{
			document.forms[0].jobId.value="eProfilsFiAd";
		}
    }
    
	return true;
}

//fonction creee pour empecher la saisie de caracteres speciaux dans le Profil de FI

function VerifierAlphaMaxCarSpec( EF )
{
   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   var Accents = '��������������������$"; &(@)!:?�/<>+-.~#{[|`\\_^]}=�����\''

   var Champ = "";
   var Caractere;
   var caretoile = "*";

	if(EF.value.indexOf(caretoile) == 0 && EF.value.length != 1){
	   alert( "Code direction invalide" );
	   EF.focus();
	   EF.value="";
	   return false;	   
	}
	   
	if(EF.value.indexOf(caretoile) > 0){
	
	   alert( "Code direction invalide" );
	   EF.focus();
	   EF.value="";
	   return false;
	   
	}else{
		  
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	LaChaine = EF.value.charAt(Cpt);

	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Code direction invalide" );
	   EF.focus();
	   EF.value="";
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
	   EF.value="";
	   return false;	   
	}
	
   if (EF.value == caretoile) return true;

   if (EF.value == '') return true;
   
   if (formatDate == 'aaaa') {
	aaaa = parseInt( EF.value, 10);
	if ((isNaN(aaaa) == true) || (aaaa < 1900) || (aaaa > 2100) ) {
	   alert( "Ann�e invalide" );
	   EF.focus();
	   EF.value = "";
	   return false;
	}
	else return true;
   }

   if (EF.value.charAt(2) == separateur) {
	if (formatDate == 'jj/mm/aaaa') {
	   if (EF.value.charAt(5) != separateur) {
		alert( "Date invalide (format "+formatDate+")" );
		EF.focus();
		EF.value = "";
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
	EF.value = "";
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
	   case 2  : alert( "Mois invalide" );  break;
	   case 3  : alert( "Ann�e invalide" ); break;
	   default : alert( "Date invalide (format "+formatDate+")" );
	}
	EF.focus();
	EF.value = "";
	return false;
   }

   if ( (mm < 1) || (mm > 12) ) {
	alert( "Mois invalide" );
	EF.focus();
	EF.value = "";
	return false;
   }
   else {
	nbJours = new nbJoursAnnee(aaaa);
	if ((jj > nbJours[mm]) || (jj < 1)) {
	   alert( "Jour invalide" );
	   EF.focus();
	   EF.value = "";
 	   return false;
	}
   }
   if ( (aaaa < 2011) || (aaaa > 2100) ) {
	alert( "Ann�e invalide" );
	EF.focus();
	EF.value = ""; 
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
	   alert( "Ann�e invalide" );
	   EF.focus();
	   EF.value = "";
	   return false;
	}
	else return true;
   }

   if (EF.value.charAt(2) == separateur) {
	if (formatDate == 'jj/mm/aaaa') {
	   if (EF.value.charAt(5) != separateur) {
		alert( "Date invalide (format "+formatDate+")" );
		EF.focus();
		EF.value = "";
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
	EF.value = "";
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
	   case 2  : alert( "Mois invalide" );  break;
	   case 3  : alert( "Ann�e invalide" ); break;
	   default : alert( "Date invalide (format "+formatDate+")" );
	}
	EF.focus();
	EF.value = "";
	return false;
   }

   if ( (mm < 1) || (mm > 12) ) {
	alert( "Mois invalide" );
	EF.focus();
	EF.value = "";
	return false;
   }
   else {
	nbJours = new nbJoursAnnee(aaaa);
	if ((jj > nbJours[mm]) || (jj < 1)) {
	   alert( "Jour invalide" );
	   EF.focus();
	   EF.value = "";
 	   return false;
	}
   }
   if ( (aaaa < 2011) || (aaaa > 2100) ) {
	alert( "Ann�e invalide" );
	EF.focus();
	EF.value = ""; 
	return false;
   }
   return true;
}

//Appel en ajaxx pour regarder si le code direction existe d�j�
function isValidCodeDir()
{
var p_param6;
if(document.getElementById("p_param6").value!="*"){
	p_param6 = document.getElementById("p_param6").value;
	ajaxCallRemotePage('/listprofilsfi.do?action=isValidCodeDir&p_param6='+p_param6);
	if (document.getElementById("ajaxResponse").innerHTML!='') {
	alert(document.getElementById("ajaxResponse").innerHTML);
	document.editionForm.p_param6.value="";
	document.editionForm.p_param6.focus();
	return false;
	
	}
}
return true;
}


/** Pour vider deux champs  */
function viderChamps(elt) {
	
	if (elt.value != '') {
		if (elt.name == 'p_param7') {
			var p_param8 = document.getElementsByName('p_param8')[0];
			document.getElementsByName('p_param9')[0].value = '';
		}
		else if (elt.name == 'p_param9') {
			var p_param8 = document.getElementsByName('p_param8')[0];
			document.getElementsByName('p_param7')[0].value = '';
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
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/edition" onsubmit="return ValiderEcran(this);">
		  <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="jobId">
            <input type="hidden" name="initial" value="<%= sInitial %>">
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="action" value="refresh"/>
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <input type="hidden" name="p_global" value="<%= p_global %>">

			<table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib">Direction Bip:</td>
                  <td> 
					<html:text property="p_param6" styleClass="input"  size="3" maxlength="2" onchange="return isValidCodeDir(); return VerifierAlphaMaxCarSpec(this);"/>
					&nbsp;&nbsp;(* si toutes)
				  </td><td>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr><td>&nbsp;</td> 
                  <td class="lib" align="left">A compter de:&nbsp;&nbsp;&nbsp;</td>
                  <td> 
					<html:text property="p_param7" styleClass="input"  size="8" maxlength="7" onkeyUp="viderChamps(this)" onblur="viderChamps(this)" onchange="return VerifierFiltreDate(this,'MM/AAAA');" />
					&nbsp;&nbsp; (* pour toutes p�riodes, ou � compter du mois MM/AAAA)
				  </td>
                </tr>
                <tr> <td>&nbsp;</td>
                  <td class="lib">Dates d'effet: </td>
                  <td> 
					<input type="radio" name="p_param8" value="ACTIVES" checked />&nbsp; Actives
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" name="p_param8" value="TOUTES" />&nbsp; Toutes
				  </td>
                </tr>
                <!--<tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                 <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr> -->
                <tr> <td>&nbsp;</td>
                  <td align=left><u><b>OU</b></u></td>
                </tr>
                <tr> <td>&nbsp;</td>
                  <td class="lib" align="left">Mensuelle de:&nbsp;&nbsp;&nbsp;</td>
                  <td> 
					<html:text property="p_param9" styleClass="input"  size="8" maxlength="7" onkeyUp="viderChamps(this)" onblur="viderChamps(this)" onchange="return VerifierDateEffet(this,'MM/AAAA');"/>
					&nbsp;&nbsp;(MM/AAAA)
				  </td>
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

		<table width="100%" border="0">
		
              <tr> 
                <td align="center"> 
                	<html:submit value="Liste" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/> 
                </td>
              </tr>
            
            </table>
		
			  <!-- #BeginEditable "fin_form" -->
			  </html:form>
			  <!-- #EndEditable -->
			  
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

<!-- #EndTemplate -->