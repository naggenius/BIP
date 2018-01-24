<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="datesEffetForm" scope="request" class="com.socgen.bip.form.DatesEffetForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmDatesEffetAd.jsp"/> 

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   
   var Message="<bean:write filter="true"  name="datesEffetForm"  property="msgErreur" />";
   var Focus = "<bean:write name="datesEffetForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }

   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value == "insert"){
	document.forms[0].num_ligne.focus();
   } else
		document.forms[0].actif.focus();
   
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function checkOuiNon(champ){
	champ.value = champ.value.toUpperCase();
	if (champ.value!='O' && champ.value!='N'){
		alert("Valeur non autorisée pour ce champ");
		champ.focus();
		return false;
	}
	return true;
}

function checkNCX(champ){
	champ.value = champ.value.toUpperCase();
	if (champ.value!='N' && champ.value!='C' && champ.value!='X'){
		alert("Valeur non autorisée pour ce champ");
		champ.focus();
		return false;
	}
	return true;
}

function checkNIC(champ){
	champ.value = champ.value.toUpperCase();
	if (champ.value!='N' && champ.value!='I' && champ.value!='C'){
		alert("Valeur non autorisée pour ce champ");
		champ.focus();
		return false;
	}
	return true;
}

function attente(){
	return true;
}

//Appel en ajaxx pour regarder si la ligne existe
function existeParamBIP(codaction,codversion,num_ligne_lie){
	ajaxCallRemotePage('/majLignesParamBip.do?action=existeParamBIP&codaction='+codaction+'&codversion='+codversion+'&num_ligne_lie='+num_ligne_lie);
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		return false;
	}
	return true;
}

//Appel en ajaxx pour regarder si la ligne est active
function activeLigneParamBip(codaction,codversion,num_ligne_lie){
	ajaxCallRemotePage('/majLignesParamBip.do?action=activeLigneParamBIP&codaction='+codaction+'&codversion='+codversion+'&num_ligne_lie='+num_ligne_lie);
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		return false;
	}
	return true;
}

function ValiderEcran(form)
{

    if (blnVerification) {
    if(form.mode.value == 'update' || form.mode.value == 'insert'){

		
	   	if (form.num_ligne && !ChampObligatoire(form.num_ligne, "le numéro de ligne")) return false;
		if (form.actif && !ChampObligatoire(form.actif, "le champ actif (O/N)")) return false;
		if (form.applicable && !ChampObligatoire(form.applicable, "le champ applicable (O/N)")) return false;
		if (form.obligatoire && !ChampObligatoire(form.obligatoire, "le champ obligatoire (O/N)")) return false;
		if (form.multi && !ChampObligatoire(form.multi, "le champ multivalué (O/N)")) return false;
		if (form.format &&!ChampObligatoire(form.format, "le format attendu, hors séparateur (N/C/X)")) return false;
		if (form.casse && !ChampObligatoire(form.casse, "la gestion des minuscules (N/I/C)")) return false;
	   	if (form.min_size_tot && !ChampObligatoire(form.min_size_tot, "la longueur totale minimale")) return false;
		if (form.max_size_tot && !ChampObligatoire(form.max_size_tot, "la longueur totale maximale")) return false;
		if(form.actif && !checkOuiNon(form.actif))return false;
		if(form.applicable && !checkOuiNon(form.applicable))return false;
		if(form.obligatoire && !checkOuiNon(form.obligatoire))return false;
		if(form.multi && !checkOuiNon(form.multi))return false;
		if(form.format && !checkNCX(form.format))return false;
		if(form.casse && !checkNIC(form.casse))return false;
		if(form.multi && form.multi.value=="O" && form.separateur && form.separateur.value==""){
			alert("Le séparateur est obligatoire si la ligne paramètre Bip est multivaluée");
			form.separateur.focus();
			return false;
		}
		if(form.multi && form.multi.value=="N" && form.separateur && form.separateur.value!=""){
			alert("Le champ séparateur doit être vide si la ligne paramètre BIP n'est pas multivaluée");
			form.separateur.focus();
			return false;
		}
		if(form.multi && form.multi.value=="O"){
			if (form.min_size_unit && !ChampObligatoire(form.min_size_unit, "la longueur unitaire minimale")) return false;
			if (form.max_size_unit && !ChampObligatoire(form.max_size_unit, "la longueur unitaire maximale")) return false;
		}
		if (form.num_ligne && !VerifierNumMessage( form.num_ligne, 2, 0, "N° de ligne erroné"))return false;
		if (form.num_ligne && !(parseInt(form.num_ligne.value)>=1 && parseInt(form.num_ligne.value)<=99)){ 
			alert("N° de ligne erroné");
			form.num_ligne.focus();
			return false;
		}
		var valeurSansRetour = form.valeur.value.replace(new RegExp("(\r\n|\r|\n)", "g" ),"");
		if(form.valeur.value!='' && valeurSansRetour.length>300){
			alert("Le champ valeur ne doit pas excéder 300 caractères");
			form.valeur.focus();
			return false;
		}
		if(form.commentaire_ligne.value!='' && form.commentaire_ligne.value.length>200){
			alert("Le champ commentaire ne doit pas excéder 200 caractères");
			form.commentaire_ligne.focus();
			return false;
		}	
		if(form.codaction_lie.value!="" || form.codversion_lie.value!="" || form.num_ligne_lie.value!=""){
			if(form.codaction_lie.value==""){
				alert("Si vous avez besoin d'un paramètre Bip lié, il faut au minimum que son code action ET son code version soient saisis");
				form.codaction_lie.focus();
				return false;
			}
			if(form.codversion_lie.value==""){
				alert("Si vous avez besoin d'un paramètre Bip lié, il faut au minimum que son code action ET son code version soient saisis");
				form.codversion_lie.focus();
				return false;
			}
			if(!existeParamBIP(form.codaction_lie.value,form.codversion_lie.value,form.num_ligne_lie.value)){
				alert("Le paramètre Bip lié ou sa ligne n'existe pas");
				form.codaction_lie.focus();
				return false;
			}
			if(form.num_ligne_lie.value!="" && !activeLigneParamBip(form.codaction_lie.value,form.codversion_lie.value,form.num_ligne_lie.value)){
				if(!confirm("ATTENTION : la ligne du paramètre Bip lié est INACTIVE. Continuer ?")){
					form.codaction_lie.focus();
					return false;
				}
			}
		}
		if (form.min_size_unit && form.min_size_unit.value!="" && !VerifierNumMessage( form.min_size_unit, 2, 0, "Valeur non autorisée pour ce champ"))return false;
		if (form.min_size_unit && form.min_size_unit.value!="" && !(parseInt(form.min_size_unit.value)>0 && parseInt(form.min_size_unit.value)<=50)){ 
			alert("Valeur non autorisée pour ce champ");
			form.min_size_unit.focus();
			return false;
		}
		if (form.max_size_unit && form.max_size_unit.value!="" && !VerifierNumMessage( form.max_size_unit, 2, 0, "Valeur non autorisée pour ce champ"))return false;
		if (form.max_size_unit && form.max_size_unit.value!="" && !(parseInt(form.max_size_unit.value)>0 && parseInt(form.max_size_unit.value)<=50)){ 
			alert("Valeur non autorisée pour ce champ");
			form.max_size_unit.focus();
			return false;
		}
		if (form.max_size_unit && form.max_size_unit.value!="" && form.min_size_unit.value!="" && form.min_size_unit && !(parseInt(form.min_size_unit.value)<=parseInt(form.max_size_unit.value))){ 
			alert("La longueur unitaire minimale doit être inférieure à la longueur unitaire maximale");
			form.max_size_unit.focus();
			return false;
		}
		if (form.min_size_tot && !VerifierNumMessage( form.min_size_tot, 3, 0, "Valeur non autorisée pour ce champ"))return false;
		var valeur_max=0;
		if(form.applicable.value=='O'){
			valeur_max=300;
		}else{
			valeur_max=9999;// PPM 63485 : augmenter la capacité de 999 à 9999
		}
		if (form.min_size_tot && !(parseInt(form.min_size_tot.value)>0 && parseInt(form.min_size_tot.value)<=valeur_max)){ 
			alert("Valeur non autorisée pour ce champ");
			form.min_size_tot.focus();
			return false;
		}
		if (form.max_size_tot && !VerifierNumMessage( form.max_size_tot, 4, 0, "Valeur non autorisée pour ce champ"))return false;//PPM 63485 : augmenter la taille de 3 à 4
		if (form.max_size_tot && !(parseInt(form.max_size_tot.value)>0 && parseInt(form.max_size_tot.value)<=valeur_max)){ 
			alert("Valeur non autorisée pour ce champ");
			form.max_size_tot.focus();
			return false;
		}
		if (form.max_size_tot && form.min_size_tot && !(parseInt(form.min_size_tot.value)<=parseInt(form.max_size_tot.value))){ 
			alert("La longueur totale minimale doit être inférieure à la longueur totale maximale");
			form.max_size_tot.focus();
			return false;
		}
		
		if(form.applicable.value=='O'){
			if(form.obligatoire.value=='O'){
				if(form.valeur.value==''){
					alert("Le champ valeur est obligatoire");
					form.valeur.focus();
					return false;
				}
			}
			
			if(form.valeur.value!=''){
				if(form.multi.value=='O'){
					var tabValeurs = form.valeur.value.split(form.separateur.value);
					for (var i=0; i<tabValeurs.length; i++) {
		 				if(tabValeurs[i].length>parseInt(form.max_size_unit.value) || tabValeurs[i].length<parseInt(form.min_size_unit.value)){
		 					alert("La valeur '"+tabValeurs[i]+"' doit avoir une taille comprise entre "+form.min_size_unit.value+" et "+form.max_size_unit.value);
							form.valeur.focus();
							return false;
		 				}
					}
				}
			}
					
			if(form.valeur.value!='' && (form.valeur.value.length>parseInt(form.max_size_tot.value) || form.valeur.value.length<parseInt(form.min_size_tot.value))){
					alert("Le champ valeur doit avoir une taille totale comprise entre "+form.min_size_tot.value+" et "+form.max_size_tot.value);
					form.valeur.focus();
					return false;
			}	
			
			if(form.valeur.value!='' && form.format.value=='N'){
				if(form.multi.value=='O'){
					var tabValeurs = form.valeur.value.split(form.separateur.value);
					for (var i=0; i<tabValeurs.length; i++) {
		 				if(isNaN(tabValeurs[i])){
							alert("La valeur '"+tabValeurs[i]+"' doit être un nombre");
							form.valeur.focus();
							return false;
		 				}
					}
				}else{
					if(isNaN(form.valeur.value)){
						alert("Le champ valeur doit être un nombre");
						form.valeur.focus();
						return false;
		 			}
				}
			}else if(form.valeur.value!='' && form.format.value=='C'){
				if(form.multi.value=='O'){
					var tabValeurs = form.valeur.value.split(form.separateur.value);
					for (var i=0; i<tabValeurs.length; i++) {
		 				if(!checkAlphanum(tabValeurs[i])){
							alert("La valeur '"+tabValeurs[i]+"' doit contenir exclusivement des chiffres et des lettres");
							form.valeur.focus();
							return false;
		 				}
					}
				}else{
					if(!checkAlphanum(form.valeur.value)){
						alert("Le champ valeur doit contenir exclusivement des chiffres et des lettres");
						form.valeur.focus();
						return false;
		 			}
				}
			}	
			if(form.valeur.value!='' && form.casse.value=='I'){
				if(form.multi.value=='O'){
					var tabValeurs = form.valeur.value.split(form.separateur.value);
					for (var i=0; i<tabValeurs.length; i++) {
		 				if(isLowerCase(tabValeurs[i])){
							alert("La valeur '"+tabValeurs[i]+"' ne doit comporter aucune minuscule");
							form.valeur.focus();
							return false;
		 				}
					}
				}else{
					if(isLowerCase(form.valeur.value)){
						alert("Les minuscules sont interdites pour le champ valeur");
						form.valeur.focus();
						return false;
		 			}
				}
			}else if(form.valeur.value!='' && form.casse.value=='C'){
				form.valeur.value = form.valeur.value.toUpperCase();
			}	
		}
	}
   if (form.mode.value == 'update') {

        if (!confirm("Voulez-vous modifier cette ligne de paramètre BIP ?")) return false;
		
   }
   if (form.mode.value == 'delete') {
   
	    if (!confirm("Voulez-vous supprimer cette ligne de paramètre BIP ?")) return false;
		
   }

 }
    
   return true;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
          <bean:write name="datesEffetForm" property="titrePage"/> une ligne de paramètre Bip<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/majLignesParamBip"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
		      <input type="hidden" name="pageAide" value="<%= sPageAide %>">
		      <html:hidden property="arborescence" value="<%= arborescence %>"/>
		      <html:hidden property="titrePage"/>
              <html:hidden property="action"/>
		      <html:hidden property="mode"/>
		      <html:hidden property="commentaire"/>
		  	  <html:hidden property="dateffet"/>
		  	  <html:hidden property="heureffet"/>
		  	  <html:hidden property="datfin"/>
		  	  <html:hidden property="heurfin"/>
              <logic:equal name="datesEffetForm" property="mode" value="insert"> 
              	<table style="margin-left:-155px;" cellspacing="2" cellpadding="2" class="tableBleu">
              </logic:equal>
              <logic:notEqual name="datesEffetForm" property="mode" value="insert"> 
              	<table style="margin-left:-62px;" cellspacing="2" cellpadding="2" class="tableBleu">
              </logic:notEqual>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib">Code action :</td>
                  <td><b><bean:write name="datesEffetForm"  property="codaction" /></b>
                    	<html:hidden property="codaction"/>
                  </td>
                  <td class="lib"> Code version :</td>
                  <td><bean:write name="datesEffetForm"  property="codversion" />
                    	<html:hidden property="codversion"/>
                   </td>
                  <logic:notEqual name="datesEffetForm" property="mode" value="insert"> 
                  	<td class="lib">n° de ligne :</td>
                  	<td width="120"><b><bean:write name="datesEffetForm"  property="num_ligne" /></b> <!-- PPM 63485 ajout de width=120 pour le style-->
	                    	<html:hidden property="num_ligne"/>
	                 </td>
                  </logic:notEqual>
                </tr>
                <tr> 
                	<logic:equal name="datesEffetForm" property="mode" value="insert"> 
	                   <td class="lib"> n° de ligne :</td>
	                   <td width="120"><html:text size="2" maxlength="2" property="num_ligne"/></td> <!-- PPM 63485 ajout de width=120 pour le style-->
                   </logic:equal>
                  <logic:notEqual name="datesEffetForm" property="mode" value="insert"> 
                  	<td colspan="2">&nbsp;</td> 
                  </logic:notEqual>
                  <td class="lib"> Actif (O/N) :</td>
                  <td><html:text size="1" maxlength="1" property="actif"/></td>
                </tr>
                <tr> 
                  <td class="lib" >Applicable ici (O/N) :</td>
                  <td >
                    	<html:text size="1" maxlength="1" property="applicable"/>
                  </td>
                  <td  class="lib"> Obligatoire (O/N) :</td>
                  <td>
                    	<html:text size="1" maxlength="1" property="obligatoire"/>
                  </td>	
                </tr>
                <tr> 
                  <td class="lib" >Multivalué (O/N) :</td>
                  <td >
                    	<html:text size="1" maxlength="1" property="multi"/>
                  </td>
                  <td  class="lib"> Séparateur si multivalué :</td>
                  <td>
                    	<html:text size="1" maxlength="1" property="separateur"/>
                  </td>	
                </tr>
                <tr> 
                  <td class="lib" >Format attendu, hors séparateur (N/C/X) :</td>
                  <td >
                    	<html:text size="1" maxlength="1" property="format"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Gestion des minuscules (N/I/C) :</td>
                  <td >
                    	<html:text size="1" maxlength="1" property="casse"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Paramètre Bip lié - action / version / ligne :</td>
                  <td >
                    	<html:text size="30" maxlength="25" property="codaction_lie"/>
                  </td>
                  <td >
                    	<html:text size="8" maxlength="8" property="codversion_lie"/>
                  </td>
                  <td >
                    	<html:text size="2" maxlength="2" property="num_ligne_lie"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Longueur unitaire minimale (1 à 50 car) :</td>
                  <td >
                    	<html:text size="2" maxlength="2" property="min_size_unit"/>
                  </td>
                  <td  class="lib">maximale (1 à 50 car) :</td>
                  <td>
                    	<html:text size="2" maxlength="2" property="max_size_unit"/>
                  </td>	
                </tr>
                <tr> 
                  <td class="lib" >Longueur totale minimale (1 à 999 car) :</td>
                  <td >
                    	<html:text size="3" maxlength="3" property="min_size_tot"/>
                  </td>
                  <td  class="lib">maximale (1 à 9999 car) :</td> <!-- PPM 63485 modifier le libellé de 999 à 9999 -->
                  <td>
                    	<html:text size="4" maxlength="4" property="max_size_tot"/> <!-- PPM 63485 : augmenter la taille du champ de 3 à 4 -->
                  </td>
                  <td colspan="2" class="lib3"><i>maxi = 300 car. si applicable ici</i></td> <!--  PPM 63485 ajout de libellé en italique -->	
                </tr>
            </table>
            <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td class="lib" >Commentaire sur cette ligne</td>
                </tr>
                <tr> 
                  <td ><html:textarea property="commentaire_ligne" cols="100" rows="2"/></td>
                </tr>
                <tr> 
                  <td class="lib" >Valeur</td>
                </tr>
                <tr> 
                  <td ><textarea style="padding-left:3px;border:none;background-color:transparent;overflow:hidden" readonly cols="105" rows="1">         1         2         3         4         5         6         7         8         9        10</textarea></td>
                </tr>
                <tr> 
				  <td ><textarea style="padding-left:3px;border:none;background-color:transparent;overflow:hidden" readonly cols="105" rows="1">1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890</textarea></td>
                </tr>
                <tr> 
                  <td ><html:textarea property="valeur" cols="100" rows="3"/></td>
                </tr>
			 </table>
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
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
<% 
Integer id_webo_page = new Integer("1029"); 
com.socgen.bip.commun.form.AutomateForm formWebo = datesEffetForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
