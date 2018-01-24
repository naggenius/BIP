<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="standardForm" scope="request" class="com.socgen.bip.form.StandardForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
 <bip:VerifUser page="jsp/fStandardAd.jsp"/> 
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
var tab_niveau=new Array('a','b','c','d','e','f','g','h','i','j','k','hc');
var tab_metier=new Array('Me','Mo','Hom','Gap');

function numberConversion(value) {
	return Number(value);
}
var arrRange = [];
var codsg_bas_tmp;
var codsg_haut_tmp;

function MessageInitial()
{
  arrRange = [];
   var Message="<bean:write filter="false"  name="standardForm"  property="msgErreur" />";
   var Focus = "<bean:write name="standardForm"  property="focus" />";
   var arrNum1 = [];
  var arrStr1 = document.forms[0].SGValue.value.split(' ');
	for (var i = 0; i <= arrStr1.length; i=i+2) {
		if (arrStr1[i] !== '' && arrStr1[i+1] !== '') {
   		 arrNum1.push({
        fromRange: numberConversion(arrStr1[i]),
        toRange: numberConversion(arrStr1[i+1])
   		 });
	}
}
arrRange = arrNum1;
   if (Message != "") {
      alert(Message);
   }
   	codsg_bas_tmp = Number(document.forms[0].codsg_bas.value);
	codsg_haut_tmp = Number(document.forms[0].codsg_haut.value);
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
       if(document.forms[0].mode.value!="delete" ) {
	    document.forms[0].codsg_bas.focus();
	    }
    }
    if (document.forms[0].mode.value=="insert"){
    
	    //Initialisation des DPG et des couts
	    	document.forms[0].codsg_bas.value='0000000';
	    	document.forms[0].codsg_haut.value='9999999';
	    	
	    if (document.forms[0].choix.value=="SG") {
	    	for (i=0;i<tab_niveau.length;i++) {
	    		for (j=0;j<tab_metier.length;j++) {
	    			eval( "document.forms[0]."+tab_niveau[i]+"_"+tab_metier[j]).value=',00';
	    		}
	    	}
	    }
	    else {
	    	document.forms[0].coulog_Me.value=',00';
	    	document.forms[0].coulog_Mo.value=',00';
	    	document.forms[0].coulog_Hom.value=',00';
	    	document.forms[0].coulog_Gap.value=',00';
	    	document.forms[0].coutenv_sg_Me.value=',00';
	    	document.forms[0].coutenv_sg_Mo.value=',00';
	    	document.forms[0].coutenv_sg_Hom.value=',00';
	    	document.forms[0].coutenv_sg_Gap.value=',00';
	    	document.forms[0].coutenv_ssii_Me.value=',00';
	    	document.forms[0].coutenv_ssii_Mo.value=',00';
	    	document.forms[0].coutenv_ssii_Hom.value=',00';
	    	document.forms[0].coutenv_ssii_Gap.value=',00';
	    }
	    		
    }
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.mode.value =mode;
   form.action.value = action;
} 

function rangeCheck(form) {
	var tcodsg_bas = Number(form.codsg_bas.value);
	var tcodsg_haut = Number(form.codsg_haut.value);
	var tmp = 0;
	if(form.mode.value === 'insert') {
		if(tcodsg_bas <= arrRange[0].fromRange && tcodsg_haut >= arrRange[arrRange.length - 1].toRange) {
		return true;
	}
	for(var i = 0; i < arrRange.length; i++) {
		 if ((tcodsg_bas >= arrRange[i].fromRange) && (tcodsg_bas <= arrRange[i].toRange) || (tcodsg_haut >= arrRange[i].fromRange) && (tcodsg_haut <= arrRange[i].toRange)) {
			return true;
		} else {
			tmp++;
		}
	}
	if(tmp === arrRange.length) {
		return false;
	}
} else if (form.mode.value === 'update') {

	if(tcodsg_bas <= arrRange[0].fromRange && tcodsg_haut >= arrRange[arrRange.length - 1].toRange) {
		return true;
	}

	if((tcodsg_bas >= codsg_bas_tmp && tcodsg_bas < codsg_haut_tmp) && (tcodsg_haut > codsg_bas_tmp && tcodsg_haut <= codsg_haut_tmp)) {
		return false;
	} 
	for(var i = 0; i < arrRange.length; i++) {
	if(!(arrRange[i].fromRange === codsg_bas_tmp && arrRange[i].toRange === codsg_haut_tmp)) {
		 if ((tcodsg_bas >= arrRange[i].fromRange) && (tcodsg_bas <= arrRange[i].toRange) || (tcodsg_haut >= arrRange[i].fromRange) && (tcodsg_haut <= arrRange[i].toRange)) {
			return true;
		} else {
			tmp++;
		}
		}
	}
	if(tmp === arrRange.length-1) {
		return false;
	}
}
	return false;
}


function ValiderEcran(form)
{
  var champ;
  if (blnVerification == true) {
   if (form.mode.value != 'delete') {
     if (form.codsg_bas &&!ChampObligatoire(form.codsg_bas, "le code DPG bas")) return false;
     if (form.codsg_haut &&!ChampObligatoire(form.codsg_haut, "le code DPG haut")) return false;
 	 if(rangeCheck(form)) {
 	 alert('Doublon avec l existant sur au moins 1 DPG de votre plage');
 	 return false;
 	 }
	}
     if (form.mode.value == 'update') {
        if (!confirm("Voulez-vous modifier ce coût standard ?")) return false;
     }
     if (form.mode.value == 'delete') {
	 	if (!confirm("Voulez-vous supprimer ce coût standard ?")) return false;
	 }
  }
	arrRange = [];
   return true;
}

function copiePrec(form, type) {
	log_prec  = document.forms[0].coulog_Me.value;
	sg_prec   = document.forms[0].coutenv_sg_Me.value;
	ssii_prec = document.forms[0].coutenv_ssii_Me.value;
	
	if ( (document.forms[0].coulog_Mo.value=='') || (document.forms[0].coulog_Mo.value=='0,00') || (document.forms[0].coulog_Mo.value==',00') )
		document.forms[0].coulog_Mo.value       = log_prec;
	
	if ( (document.forms[0].coutenv_sg_Mo.value=='') || (document.forms[0].coutenv_sg_Mo.value=='0,00') || (document.forms[0].coutenv_sg_Mo.value==',00') )
		document.forms[0].coutenv_sg_Mo.value       = sg_prec;

	if ( (document.forms[0].coutenv_ssii_Mo.value=='') || (document.forms[0].coutenv_ssii_Mo.value=='0,00') || (document.forms[0].coutenv_ssii_Mo.value==',00') )
		document.forms[0].coutenv_ssii_Mo.value       = ssii_prec;

	log_prec  = document.forms[0].coulog_Mo.value;
	sg_prec   = document.forms[0].coutenv_sg_Mo.value;
	ssii_prec = document.forms[0].coutenv_ssii_Mo.value;

	if ( (type=='HOM') || (type=='GAP') ) {
		if ( (document.forms[0].coulog_Hom.value=='') || (document.forms[0].coulog_Hom.value=='0,00') || (document.forms[0].coulog_Hom.value==',00') )
			document.forms[0].coulog_Hom.value       = log_prec;
		
		if ( (document.forms[0].coutenv_sg_Hom.value=='') || (document.forms[0].coutenv_sg_Hom.value=='0,00') || (document.forms[0].coutenv_sg_Hom.value==',00') )
			document.forms[0].coutenv_sg_Hom.value       = sg_prec;
	
		if ( (document.forms[0].coutenv_ssii_Hom.value=='') || (document.forms[0].coutenv_ssii_Hom.value=='0,00') || (document.forms[0].coutenv_ssii_Hom.value==',00') )
			document.forms[0].coutenv_ssii_Hom.value       = ssii_prec;
	
		log_prec  = document.forms[0].coulog_Hom.value;
		sg_prec   = document.forms[0].coutenv_sg_Hom.value;
		ssii_prec = document.forms[0].coutenv_ssii_Hom.value;
	}

	if (type=='GAP') {
		if ( (document.forms[0].coulog_Gap.value=='') || (document.forms[0].coulog_Gap.value=='0,00') || (document.forms[0].coulog_Gap.value==',00') )
			document.forms[0].coulog_Gap.value       = log_prec;
		
		if ( (document.forms[0].coutenv_sg_Gap.value=='') || (document.forms[0].coutenv_sg_Gap.value=='0,00') || (document.forms[0].coutenv_sg_Gap.value==',00') )
			document.forms[0].coutenv_sg_Gap.value       = sg_prec;
	
		if ( (document.forms[0].coutenv_ssii_Gap.value=='') || (document.forms[0].coutenv_ssii_Gap.value=='0,00') || (document.forms[0].coutenv_ssii_Gap.value==',00') )
			document.forms[0].coutenv_ssii_Gap.value       = ssii_prec;
	}

	
} 

function VerifierNumLoc( EF, longueur, decimale )
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
              case ',' : champ += ',';
                         posSeparateur = deb;
                         if ( (deb <= (longueur-decimale+debut)) && ((EF.value.length-posSeparateur-1) <= decimale) )
                               break;
              default  : alert("Nombre invalide");
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
	   alert("Nombre invalide");
	   EF.focus();
	   EF.value = "";
	   return false;
	}
      if(decimale !=0) {
         champ += ',';
      }
      nbDecimales=0;
   }
   else if (decimale != 0) {
	nbDecimales = EF.value.length-posSeparateur-1;
   }
   else {alert("Nombre invalide");
	   EF.focus();
	   EF.value = "";
	   return false;
   }

   for (Cpt=1; Cpt <= (decimale-nbDecimales); Cpt++ ) {
      champ += '0';
   }
	
   champ = formatDPG(champ);
   EF.value=champ;
   
   return true;
} 

 function formatDPG(DPG){
 while(DPG.length != 7) 
	{
		DPG = "0"+DPG;
	} 
 return DPG;
 }
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="standardForm" property="titrePage"/> un coût standard<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/standard"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			  <html:hidden property="titrePage"/>
              <html:hidden property="action"/>
		      <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		      <html:hidden property="choix"/>
		      <html:hidden property="keyList0"/>
		      <html:hidden property="flaglock"/>
			  <html:hidden property="cdeDPG"/>
			   <html:hidden property="SGValue"/>
			   
				<table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td>&nbsp;</td>
                  
                </tr>
                <tr> 
                  
                  <td><b>Année : <bean:write name="standardForm"  property="couann" /></b> 
                    		<html:hidden property="couann"/> 
                  </td>
				 
                </tr>
                <tr>
                  <td >&nbsp;</td>
                
                </tr>
              </table>
			  			  
			 
              <table border=0  cellspacing="2" cellpadding="2" class="tableBleu" >
                <tr> 
                  <td class="lib" colspan="2"><B>DPG BAS :</B></td>
                  <td colspan="2">
                     <logic:notEqual parameter="action" value="supprimer">  
                   		<html:text property="codsg_bas" styleClass="input" size="8" maxlength="7" onchange="return VerifierNumLoc(this,7,0);"/> 
                    	<html:hidden property="codsg_bas_old"/>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                        <bean:write name="standardForm"  property="codsg_bas" /> 
                     	<html:hidden property="codsg_bas"/>
                     </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" colspan="2"><b>DPG HAUT :</b></td>
                  <td colspan="2">
                    <logic:notEqual parameter="action" value="supprimer"> 
                  		<html:text property="codsg_haut" styleClass="input" size="8" maxlength="7" onchange="return VerifierNumLoc(this,7,0);"/> 
                    </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                     	<bean:write name="standardForm"  property="codsg_haut"/>
                     </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td colspan="3" >&nbsp;</td>
                 
                </tr>
              </table>
              <logic:equal parameter="choix" value="SG">	
                <table cellspacing="2" cellpadding="2" class="tableBleu"  >
                <tr>
                  <td class="lib"><b> Niveau</b>
                  </td>
                  <td colspan="4" align="center" class="lib"><b> Métier</b>
                  </td>
                </tr>
                 <tr>
                  <td > &nbsp;
                  </td>
                  <td >ME
                  </td>
                   <td >MO
                  </td>
                   <td >HOM
                  </td>
                   <td >GAP
                  </td>
                </tr>
                 <tr>
                  <td > Agent SG niveau A
                  </td>
                  <td ><html:text property="a_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="a_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="a_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="a_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                <tr>
                  <td > Agent SG niveau B
                  </td>
                  <td ><html:text property="b_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="b_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="b_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="b_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                 <tr>
                  <td > Agent SG niveau C
                  </td>
                  <td ><html:text property="c_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="c_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="c_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="c_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                <tr>
                  <td > Agent SG niveau D
                  </td>
                  <td ><html:text property="d_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="d_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="d_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="d_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                 <tr>
                  <td > Agent SG niveau E
                  </td>
                  <td ><html:text property="e_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="e_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="e_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="e_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                <tr>
                  <td > Agent SG niveau F
                  </td>
                  <td ><html:text property="f_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="f_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="f_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="f_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                 <tr>
                  <td > Agent SG niveau G
                  </td>
                  <td ><html:text property="g_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="g_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="g_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="g_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                <tr>
                  <td > Agent SG niveau H
                  </td>
                  <td ><html:text property="h_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="h_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="h_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="h_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                  <tr>
                  <td > Agent SG niveau I
                  </td>
                  <td ><html:text property="i_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="i_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="i_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="i_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                <tr>
                  <td > Agent SG niveau J
                  </td>
                  <td ><html:text property="j_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="j_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="j_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="j_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                 <tr>
                  <td > Agent SG niveau K
                  </td>
                  <td ><html:text property="k_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="k_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="k_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="k_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                <tr>
                  <td > Agent SG niveau HC
                  </td>
                  <td ><html:text property="hc_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="hc_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="hc_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                   <td ><html:text property="hc_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> 
                  </td>
                </tr>
                 <tr> 
                  <td>&nbsp;</td>
                </tr> 
                </table>
			  </logic:equal>
			  <logic:equal parameter="choix" value="AUTRE">
			   <table cellspacing="2" cellpadding="2" class="tableBleu"  >
                <tr>
                  <td class="lib">Logiciel</td>
                  <td ><html:text property="coulog_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> </td>
                  <td ><html:hidden property="coulog_Mo" /> </td>
                  <td ><html:hidden property="coulog_Hom" /> </td>
                  <td ><html:hidden property="coulog_Gap" /> </td>
                </tr>
                 <tr> 
                  <td>&nbsp;</td>
                </tr> 
                <tr>
                  <td class="lib"><b> Type</b>
                  </td>
                  <td colspan="4" align="center" class="lib"><b> M&eacute;tier</b>
                  </td>
                </tr>
                 <tr>
                  <td >&nbsp;</td>
                  <td >ME</td>
                  <td ><button class="input" onclick="copiePrec(this, 'MO');">=</button>&nbsp;MO</td>
                  <td ><button class="input" onclick="copiePrec(this, 'HOM');">=</button>&nbsp;HOM</td>
                  <td ><button class="input" onclick="copiePrec(this, 'GAP');">=</button>&nbsp;GAP</td>
                </tr>
                <tr>
                  <td class="lib">Frais d'environnement SSII</td>
                  <td ><html:text property="coutenv_ssii_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> </td>
                  <td ><html:text property="coutenv_ssii_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> </td>
                  <td ><html:text property="coutenv_ssii_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> </td>
                  <td ><html:text property="coutenv_ssii_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> </td>
                </tr>
                 <tr>
                  <td class="lib">Frais d'environnement SG</td>
                  <td ><html:text property="coutenv_sg_Me" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> </td>
                  <td ><html:text property="coutenv_sg_Mo" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> </td>
                  <td ><html:text property="coutenv_sg_Hom" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> </td>
                  <td ><html:text property="coutenv_sg_Gap" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,6,2);"/> </td>
                </tr>
                 <tr> 
                  <td>&nbsp;</td>
                </tr>
                </table>
         
			  </logic:equal>
			  
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
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'suite', null, false);"/> 
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
Integer id_webo_page = new Integer("1007"); 
com.socgen.bip.commun.form.AutomateForm formWebo = standardForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
