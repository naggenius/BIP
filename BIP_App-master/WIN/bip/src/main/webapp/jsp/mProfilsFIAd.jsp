<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.text.SimpleDateFormat,java.util.Locale"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="profilsfiForm" scope="request" class="com.socgen.bip.form.ProfilsFIForm" />
<%@page import="com.socgen.bip.commun.form.BipForm"%>
<%@page import="com.socgen.bip.form.ProfilsFIForm"%>
<html:html locale="true" xhtml="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmProfilsFIAd.jsp"/> 
<%

	//String comm = profilsfiForm.getCommentaire().substring(0,profilsfiForm.getCommentaire().length());
	// On récupère la liste des top actif FI
    java.util.ArrayList choixTopActif = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topActif_FI"); 
    pageContext.setAttribute("choixTopActif", choixTopActif);

	// On récupère la liste des TopEgalPrestation
    java.util.ArrayList choixTopEgalPrestation = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("TopEgalPrestation"); 
    pageContext.setAttribute("choixTopEgalPrestation", choixTopEgalPrestation);
    
	// On récupère la liste des TopEgalLocalisation
    java.util.ArrayList choixTopEgalLocalisation = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("TopEgalLocalisation"); 
    pageContext.setAttribute("choixTopEgalLocalisation", choixTopEgalLocalisation);
    
	// On récupère la liste des TopEgalES
    java.util.ArrayList choixTopEgalES = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("TopEgalES"); 
    pageContext.setAttribute("choixTopEgalES", choixTopEgalES);
	
    if(profilsfiForm.getTitrePage() == "Modifier") profilsfiForm.setTitrePage("MODIFICATION");
    else if(profilsfiForm.getTitrePage() == "Supprimer") profilsfiForm.setTitrePage("SUPPRESSION");
    else profilsfiForm.setTitrePage("CREATION");
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


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="profilsfiForm"  property="msgErreur" />";
   var Focus = "<bean:write name="profilsfiForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if(document.forms[0].mode.value =="update")
   {
     document.forms[0].cout.focus();
   }
	if(document.forms[0].mode.value =="insert")
   {
   	 if(document.forms[0].libelle.value ==""){
     document.forms[0].libelle.focus();
     } else {
     	if(document.forms[0].cout.value=="")
     	document.forms[0].date_effet.focus();
     }
   }

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


function ConvertComma()
{
	parseFloat(document.forms[0].cout.value.replace(',','.'));
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}
function ValiderEcran(form)
{
  if (blnVerification == true) {
  	   	 
     if (form.libelle && !ChampObligatoire(form.libelle, "le libellé")) return false;
     if (form.date_effet && !ChampObligatoire(form.date_effet, "la date effet")) return false;
     if (form.cout && !ChampObligatoire(form.cout, "le coût unitaire HTR")) return false;
     if (form.coddir && !ChampObligatoire(form.coddir, "le code direction")) return false;
     if (form.prestation && !ChampObligatoire(form.prestation, "les codes prestations)")) return false;
     if (form.localisation && !ChampObligatoire(form.localisation, "les Localisations")) return false;
	
     if (form.mode.value== 'update') {
        if (!confirm("Voulez-vous modifier ce profil de FI  ?")) return false;
     }
     if (form.mode.value== 'delete') {	
       	var msg_db = form.message_fi_ress.value;
     	var reg=new RegExp("[.]+", "g");
		var tableau=msg_db.split(reg);
		for (var i=0; i<tableau.length; i++) {}
     	var msg = tableau[0] +"\n\n" +tableau[1]+ "\n\nValidez-vous la suppression ?";
     	     	if (!confirm(msg)) return false;
       	
     }
     
     // suppression du caractère tabulation dans le libellé et la description
 	var regex = /[\t]+/g;
	form.commentaire.value = form.commentaire.value.replace(regex,"");
  }
 
   return true;
}

//Appel en ajaxx pour regarder si le code direction existe déjà
function isValidCodeDir()
{
var coddir;

	coddir = document.getElementById("coddir").value;
	ajaxCallRemotePage('/profilsfi.do?action=isValidCodeDir&coddir='+coddir);
	if (document.getElementById("ajaxResponse").innerHTML!='') {
	alert(document.getElementById("ajaxResponse").innerHTML);
	document.profilsfiForm.coddir.focus();
	return false;
	
	}

return true;
}

//Appel en ajaxx pour regarder si le Profil de FI est utilisé par une ressource
function isFiRessource()
{
var filtre_fi;
var date_effet;
var userid;
filtre_fi = document.getElementById("filtre_fi").value;
date_effet = document.getElementById("date_effet").value;
alert('filtre_fi:'+filtre_fi);alert('date_effet:'+date_effet);
ajaxCallRemotePage('/profilsfi.do?action=isFiRessource&filtre_fi='+filtre_fi+'&date_effet='+date_effet);
return true;
}

<!-- --></script>
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->GESTION DES PROFILS DE FI :  
           <bean:write name="profilsfiForm" property="titrePage"/><!--GESTION DES PROFILS DE FI : CREATION--><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/profilsfi"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="titrePage"/>
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="message_fi_ress" />
		    
              <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" align="center">
                <tr> 
                  <td colspan=1 >&nbsp;</td>
                </tr>

                <tr> 
                  <td class="lib"><b>Profil de FI:</b></td>
                  <td>


	                 <logic:equal parameter="action" value="valider">
                   	    <bean:write name="profilsfiForm"  property="filtre_fi" />
	                 	<html:hidden property="filtre_fi"/>
                     </logic:equal>
					 <logic:equal parameter="action" value="creer">
	                 	<bean:write name="profilsfiForm"  property="filtre_fi" />
	                 	<html:hidden property="filtre_fi"/>	                	
	                 </logic:equal>
	                 <logic:equal parameter="action" value="supprimer">
	                 	<bean:write name="profilsfiForm"  property="filtre_fi" />
	                 	<html:hidden property="filtre_fi"/>
	                 </logic:equal> 

	                 <logic:equal parameter="action" value="modifier">
	                 	<bean:write name="profilsfiForm"  property="filtre_fi" />
	                 	<html:hidden property="filtre_fi"/>
	                 </logic:equal> 
	                 
                  </td>
                  
                <%
          	    if(profilsfiForm.getLibelle() != null) {
          	    %>
          	    
                  <td class="lib" width="10%"><b>Libellé :</b></td>
					<td>
 	                 <logic:equal parameter="action" value="valider">
                   	    <bean:write name="profilsfiForm"  property="libelle" />
	                 	<html:hidden property="libelle"/>
                     </logic:equal>
					 <logic:equal parameter="action" value="creer">
	                 	<bean:write name="profilsfiForm"  property="libelle" />
	                 	<html:hidden property="libelle"/>
	                 </logic:equal>
	                <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="profilsfiForm"  property="libelle" />
                    </logic:equal> 
                    <logic:equal parameter="action" value="modifier">
	                 	<html:text property="libelle" styleClass="input" size="16" maxlength="30" onchange="return VerifAlphaMaxCar_profil_Lib(this,'libelle'); this.value=this.value.toUpperCase(); "/>
	                 </logic:equal>	                 
	                 
	              </td>

	                 
	              <% }else{ %>         
                  
                  <td class="lib" width="10%"><b>Libellé :</b></td>                 
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="libelle" styleClass="input" size="16" maxlength="30" onchange="return VerifAlphaMaxCar_profil_Lib(this,'libelle'); this.value=this.value.toUpperCase(); " />
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="profilsfiForm"  property="libelle" />
                    </logic:equal> 
                  
                 
                  </td> 
                <% } %>                 
                </tr>
                
                <tr> 
                  <td class="lib" ><b>Date Effet:</b></td>
          
                  <td> 
                  
                    <logic:equal parameter="action" value="valider">
                   		<html:text property="date_effet" styleClass="input" size="8" maxlength="7" onchange="return VerifierDateEffet(this,'MM/AAAA');"/>
                    </logic:equal>
                    
                      <logic:equal parameter="action" value="modifier">
	                 	<bean:write name="profilsfiForm"  property="date_effet" />
	                 	<html:hidden property="date_effet"/>
	                  </logic:equal>
                    <logic:equal parameter="action" value="creer">
                   		<html:text property="date_effet" styleClass="input" size="8" maxlength="7" onchange="return VerifierDateEffet(this,'MM/AAAA');"/>
                    </logic:equal>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="profilsfiForm"  property="date_effet" />
                    	<html:hidden property="date_effet"/>
                    </logic:equal> 
                 
                  </td>
                  
                  <logic:notEqual parameter="action" value="supprimer">
                  	<td colspan="2"><font size="1">1er mois d'effet, au format MM/AAAA</font></td>
                  </logic:notEqual>
                  
                </tr>
                
                <tr> 
                  <td class="lib"><b>Top actif :</b></td>
                  <td>

                    <logic:equal parameter="action" value="valider">
						 <input type="radio" name="top_actif" value="O" checked >OUI
				 		 <input type="radio" name="top_actif" value="N" >NON
					</logic:equal>
					
                    <logic:equal parameter="action" value="creer">
						 <input type="radio" name="top_actif" value="O" checked >OUI
				 		 <input type="radio" name="top_actif" value="N" >NON
					</logic:equal> 
                  
                    <logic:equal parameter="action" value="modifier">
				 		 <logic:iterate id="element" name="choixTopActif">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="top_actif" value="<%=choix.toString()%>" />
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:equal>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="profilsfiForm" property="top_actif"/>
  					</logic:equal>
                  </td>
                </tr>
				
                    <tr> 
                  <td class="lib" ><b>Coût HTR :</b></td>
          
                  <td colspan="3" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="cout" styleClass="input" size="14" maxlength="13" onchange="ConvertComma(); return VerifierCout(this,12,2);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="profilsfiForm"  property="cout" />
                    </logic:equal> 
                 
                  </td>
                </tr>
                   <tr> 
                  <td class="lib" ><b>Commentaire :</b></td>
          
                  <td colspan="4" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:textarea property="commentaire" styleClass="input" size="80" maxlength="300" rows="5" onchange="return VerifAlphaMaxCar_profil_Comm(this,'commentaire');" onkeyup="limite( this,  300);"/>
                   		
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<html:textarea property="commentaire" styleClass="input" size="50" rows="5" DISABLED="true" onkeyup="limite(this,300);" />
                    </logic:equal> 
                 
                  </td>
                </tr>
                
				<tr>
					<td>&nbsp;</td>
					<td colspan="4"><b><div id="reste"></div></b></td>                
				<tr>
                 
                   <tr> 
                  <td class="lib" ><b>Code Direction :</b></td>
          
                  <td colspan="3" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="coddir" styleClass="input" size="3" maxlength="2" onchange="return isValidCodeDir(); return VerifierAlphanum(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="profilsfiForm"  property="coddir" />
                    </logic:equal> 
                 
                  </td>
                </tr> 

                <tr> 
                  <td class="lib"><b>ET Codes Prestation :</b></td>
                  <td>

						<logic:equal parameter="action" value="modifier">
				 		 <logic:iterate id="element" name="choixTopEgalPrestation">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="topegalprestation" value="<%=choix.toString()%>"/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 					
						</logic:equal>
						
					<logic:equal parameter="action" value="valider">
					   <%
                       String valRadio = profilsfiForm.getTopegalprestation() ;
                       String radioE="";
                       String radioD="";
                       if(valRadio==null)
                       {
                    	    radioE="checked";
                            radioD="";
                       }
                       
                       if(valRadio.equals("="))radioE="checked";
                       else if(valRadio.equals("#"))radioD="checked";
                       %>
					
						 <input type="radio" name="topegalprestation" value="=" <%= radioE%> >Egaux
				 		 <input type="radio" name="topegalprestation" value="#" <%= radioD%> >Différents
					</logic:equal>
					
					<logic:equal parameter="action" value="creer">
						 <input type="radio" name="topegalprestation" value="=" checked >Egaux
				 		 <input type="radio" name="topegalprestation" value="#" >Différents
					</logic:equal> 	

  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="profilsfiForm" property="topegalprestation"/>
  					</logic:equal>
                  </td>
                  <td colspan="2"> 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="prestation" styleClass="input" size="30" maxlength="119" onchange="this.value=this.value.toUpperCase();"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<html:text property="prestation" styleClass="input" size="30" maxlength="119" DISABLED="true" onchange="this.value=this.value.toUpperCase();"/>
                    </logic:equal> 
                  </td>
                  
                  <logic:notEqual parameter="action" value="supprimer">
                 	<td><font size="1">1 à 30 codes de 3car. séparés par une virgule<br>chaque code peut être générique (PP*)</font></td>
                  </logic:notEqual>
                  
                  
                </tr>
                				 
                <tr> 
                  <td class="lib"><b>ET Localisation :</b></td>
                  <td>
					<logic:equal parameter="action" value="modifier">
				 		 <logic:iterate id="element" name="choixTopEgalLocalisation">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="topegallocalisation" value="<%=choix.toString()%>"/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:equal>		
					
					<logic:equal parameter="action" value="valider">
					   <%
                       String valRadio2 = profilsfiForm.getTopegallocalisation() ;
                       String radioE2="";
                       String radioD2="";
                       if(valRadio2==null)
                       {
                    	    radioE2="checked";
                            radioD2="";
                       }
                       
                       if(valRadio2.equals("="))radioE2="checked";
                       else if(valRadio2.equals("#"))radioD2="checked";
                       %>
						 <input type="radio" name="topegallocalisation" value="=" <%= radioE2%> >Egaux
				 		 <input type="radio" name="topegallocalisation" value="#" <%= radioD2%> >Différents
					</logic:equal>
								
					<logic:equal parameter="action" value="creer">
						 <input type="radio" name="topegallocalisation" value="=" checked >Egaux
				 		 <input type="radio" name="topegallocalisation" value="#" >Différents
					</logic:equal> 					
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="profilsfiForm" property="topegallocalisation"/>
  					</logic:equal>
                  </td>
                  <td colspan="2" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="localisation" styleClass="input" size="30" maxlength="29" onchange="this.value=this.value.toUpperCase();" />
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="profilsfiForm"  property="localisation" />
                    </logic:equal> 
                  </td>
                  
                  <logic:notEqual parameter="action" value="supprimer">
                  	<td><font size="1">1 à 10 codes de 2car. séparés par une virgule</font></td>
                  </logic:notEqual>
                  
                </tr>				

                <tr> 
                  <td class="lib"><b>ET Code ES :</b></td>
                  <td>

					<logic:equal parameter="action" value="modifier">
				 		 <logic:iterate id="element" name="choixTopEgalES">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="topegales" value="<%=choix.toString()%>"/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:equal>	
					
					<logic:equal parameter="action" value="valider">
					   <%
                       String valRadio3 = profilsfiForm.getTopegales() ;
                       String radioE3="";
                       String radioD3="";
                       if(valRadio3==null)
                       {
                    	    radioE3="checked";
                            radioD3="";
                       }
                       
                       if(valRadio3.equals("="))radioE3="checked";
                       else if(valRadio3.equals("#"))radioD3="checked";
                       %>
						 <input type="radio" name="topegales" value="=" <%= radioE3%> >Egaux
				 		 <input type="radio" name="topegales" value="#" <%= radioD3%> >Différents
					</logic:equal> 
									
					<logic:equal parameter="action" value="creer">
						 <input type="radio" name="topegales" value="=" checked >Egaux
				 		 <input type="radio" name="topegales" value="#" >Différents
					</logic:equal> 					
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="profilsfiForm" property="topegales"/>
  					</logic:equal>
                  </td>
                  <td colspan="2" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="code_es" styleClass="input" size="30" maxlength="29" onchange="this.value=this.value.toUpperCase();" onKeypress="if(event.keyCode < 44 || event.keyCode > 57) event.returnValue = false; if(event.which < 44 || event.which > 57) return false;"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="profilsfiForm"  property="code_es" />
                    </logic:equal> 
                  </td>
                  
                  <logic:notEqual parameter="action" value="supprimer">
                  	<td><font size="1">0 à 5 codes de 5car. séparés par une virgule<br>ou vide si non utilisé</font></td>
                  </logic:notEqual>
                  
                </tr>
				
				<tr> 
                  <td colspan="1" align="right"><font size="1">(tous niveaux)</font></td>
                </tr>
				
				<tr> 
                  <td colspan="1">&nbsp;</td>
                </tr>
				
				
				<logic:notEqual parameter="action" value="supprimer">
				
				<tr> 
                  <td colspan="1">&nbsp;</td>
                </tr>
				
				<tr> 
                  <td colspan="1"><u><i>Exemples</i></u></td>
                </tr>
					<tr> 
	                  <td bgcolor="#CCFFFF"><b><i>ET Localisations</i></b></td>
					  
						<td colspan="3" bgcolor="#CCFFFF"><i>
							 <input type="radio" name="1" value="=" checked disabled>Egaux
							 <input type="radio" name="1" value="#" disabled>Différents
							 <input type="text" name="1" maxlength="29" size="33" value="FR,99" class="input" disabled />
							 <br><font size="0">Signification: Sélectionner si code localisation =FR OU si code localisation =99</font></i>
						</td>	  
	                </tr>
           
					<tr> 
	                  <td class="lib"><b><i>ET Localisations</i></b></td>
					  
						<td colspan="3" class="lib"><i>
							 <input type="radio" name="2" value="=" disabled>Egaux
							 <input type="radio" name="2" value="#" checked disabled>Différents
							 <input type="text" name="2" maxlength="29" size="33" value="FR,99" class="input" disabled />
							 <br><font size="0">Signification: Sélectionner si code localisation <>FR ET si code localisation <>99</font></i>
						</td>				  
	                </tr>				
					
                </logic:notEqual> 
                  
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
