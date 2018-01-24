<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Page_extraction.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/xRessActParam.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>

<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var tabVerif = new Object();//KRA PPM 61346
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

%>
var pageAide = "<%= sPageAide %>";
<%
	String sTitre;
	String sInitial;
	String sJobId;

%>


function MessageInitial()
{
	<%
		sJobId = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("jobId")));
		
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)
		{
			//redirect sur la page d'erreur
			sTitre = "Pas de titre";
		}
		
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	//KRA PPM 61346
	tabVerif["p_param12"] = "Ctrl_dpg_generique(document.extractionForm.p_param12)";

	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";

   
   if (Message != "") {
      alert(Message);
   }
   else {
		if (Focus != "") {
			if (eval( "document.forms[0]."+Focus )){
				(eval( "document.forms[0]."+Focus )).focus();
			}
		}
		
		document.extractionForm.p_param12.value = "*******";
	}
   
	//FIN KRA PPM 61346
	
	document.extractionForm.p_param9.checked = true; // Valeur par défaut (au 1er jour de cette année)
}

function VerifierDate( EF, formatDate )
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
	   alert( "Année invalide" );
	   EF.focus();
	   //EF.value = "";
	   return false;
	}
	else return true;
   }

   if (EF.value.charAt(2) == separateur) {
	if (formatDate == 'jj/mm/aaaa') {
	   if (EF.value.charAt(5) != separateur) {
		alert( "Date invalide (format "+formatDate+")" );
		EF.focus();
		//EF.value = "";
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
	//EF.value = "";
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
	   case 3  : alert( "Année invalide" ); break;
	   default : alert( "Date invalide (format "+formatDate+")" );
	}
	EF.focus();
	//EF.value = "";
	return false;
   }

   if ( (mm < 1) || (mm > 12) ) {
	alert( "Mois invalide" );
	EF.focus();
	//EF.value = "";
	return false;
   }
   else {
	nbJours = new nbJoursAnnee(aaaa);
	if ((jj > nbJours[mm]) || (jj < 1)) {
	   alert( "Jour invalide" );
	   EF.focus();
	   //EF.value = "";
 	   return false;
	}
   }
   if ( (aaaa < 1900) || (aaaa > 2100) ) {
	alert( "Année invalide" );
	EF.focus();
	//EF.value = ""; 
	return false;
   }
   return true;
}


function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

function ValiderEcran(form)
{

	if( document.extractionForm.p_param7.checked == false  && document.extractionForm.p_param8.checked == false && document.extractionForm.p_param9.checked == false
  		&& document.extractionForm.p_param10.checked == false && document.extractionForm.p_param11.checked == false) {
  		alert('Veuillez cocher au moins un critère');
  		return false;		
  	}
	if(document.extractionForm.p_param6.value != ""){ 
		if(document.extractionForm.p_param7.checked == true &&  document.extractionForm.p_param8.checked == true){
			alert("La date ET l'option voulue doivent être saisies");
			return false;
		}
		if(document.extractionForm.p_param7.checked == false && document.extractionForm.p_param8.checked == false){
			alert("La date ET l'option voulue doivent être saisies");
			return false;
		}		
	}
	
	if(document.extractionForm.p_param6.value == ""){ 
		if(document.extractionForm.p_param7.checked == true || document.extractionForm.p_param8.checked == true){
			alert("La date ET l'option voulue doivent être saisies");
			return false;
		}
	}			

	if( document.extractionForm.p_param7.checked == false ){
		document.extractionForm.p_param7.value=""; }
	if( document.extractionForm.p_param8.checked == false ){
		document.extractionForm.p_param8.value=""; }
	if( document.extractionForm.p_param9.checked == false ){
		document.extractionForm.p_param9.value=""; }
	if( document.extractionForm.p_param10.checked == false ){
		document.extractionForm.p_param10.value=""; }
	if( document.extractionForm.p_param11.checked == false ){
		document.extractionForm.p_param11.value=""; }	
	
	//KRA PPM 61346
	if ( !VerifFormat(null) ) return false;	
	// Le DPG est obligatoire
	if (!ChampObligatoire(form.p_param12, "un code DPG")) return false;
	//Fin KRA PPM 61346	
	
	document.extractionForm.submit.disabled = true;
	return true;
}

//KRA PPM 61346
function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param12&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
//Fin KRA PPM 61346


</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" --><%=sTitre%><!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <html:form action="/extract.do"  onsubmit="return ValiderEcran(this);"> 
            <!-- #BeginEditable "debut_hidden" --> 
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>

<input type="hidden" name="jobId" value="<%=sJobId%>">
<input type="hidden" name="initial" value="<%= sInitial %>">
            <div id="content">
            <!-- #EndEditable --> 
            <table width="100%" border="0" align="center">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
                    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <!-- #EndEditable -->
                   </div>
                </td>
              </tr>
              
              <tr> 
                <td>&nbsp; </td>
              </tr>
				<tr> 
                <td>
				
				<table width="50" border="0" align="center" class="tableBleu"> 
					<!-- KRA PPM 61346 -->
					<tr><td colspan=5 align="center">&nbsp;</td></tr>
					<tr align="left">
							<td colspan=1 class="texte" align=right><B>Code DPG :</B></td>
							<td class="texte" colspan=4 align=left><html:text property="p_param12" styleClass="input"  size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>
							&nbsp;<a href="javascript:rechercheDPG();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" style="vertical-align : middle;"></a>   
					                    </td>
					</tr>	
					<tr><td colspan=5 align="center">&nbsp;</td></tr>
					<!-- Fin KRA PPM 61346 -->				
							<tr>
							<td class="texteGras" nowrap align="center" rowspan="6"><b>Ressource actives : </b></td>
							  <!--<td width="5%">&nbsp;</td> -->
							   <td width="1%">
									<html:checkbox name="extractionForm" property="p_param7" value="1" />
            				   </td>
							   <td class="texteGras" nowrap width="5%"><B>à cette date ou ultérieurement : </B></td>
							   
							   <td rowspan="2">
        							&nbsp;&nbsp;&nbsp;<html:text property="p_param6" styleClass="input" size="11" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa');"/> 
					  		   </td>
							   <td rowspan="2" class="texte">(JJ/MM/AAAA)</td>						
							</tr>
							
							<tr>	
								<!-- <td width="5%">&nbsp;</td> -->
								<td width="1%">
									<html:checkbox name="extractionForm" property="p_param8" value="2" />
								</td>
								<td class="texteGras" nowrap width="5%"><B>à cette date : </B></td>
								<td>
								</td>
							</tr>



							<tr> 
					          <td>&nbsp; </td>
					        </tr>
					        
					          <tr> 
					            <!-- <td class="lib" nowrap align="center"><b>Ressource actives : </b></td> -->
					            <!--<td></td>-->
								<td width="1%">
									<html:checkbox name="extractionForm" property="p_param9" value="3" />
								</td>
								<td class="texteGras" nowrap width="5%"><B>au 1er jour de cette année</B></td>
					         </tr>
					         
					         <tr> 
								<!--<td>&nbsp; </td>-->
								<td width="1%">
									<html:checkbox name="extractionForm" property="p_param10" value="4" />
								</td>
								<td class="texteGras" nowrap width="5%"><B>au 1er de ce mois</B></td>
							</tr>
							
					        <tr> 
								<!--<td>&nbsp; </td>-->
								<td width="1%">
									<html:checkbox name="extractionForm" property="p_param11" value="5" />
								</td>
									<td class="texteGras" nowrap width="5%"><B>aujourd'hui</B></td>
							</tr>
			 
             <!--  <tr> 
                <td> 
                  <div align="center"> <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, 'Extraire', true);"/> 
                  </div>
                </td>
              </tr>  -->
            </table>
            <table align="center">
            <tr>
            	<td>&nbsp;</td>
            	<td align="center" class="texte">Cocher un ou plusieurs critères (pris en compte avec un OU)</td>
        	</tr>
        	<tr> 
				<td>&nbsp; </td>
			</tr>
			</table>
							
            <div align="center"> <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, 'Extraire', true);"/> </div>
            
			</td>
            </tr>
			</table> 
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
			</div>
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
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body></html:html>
<!-- #EndTemplate -->
