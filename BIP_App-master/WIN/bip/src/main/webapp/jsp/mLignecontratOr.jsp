<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneContratForm" scope="request" class="com.socgen.bip.form.LigneContratForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bContrataveOr.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var tabVerif        = new Object();
var blnVerification = true;
var blnVerifFormat  = true;
var rafraichiEnCours = false;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
   

%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{         
   tabVerif["lcprest"]  = "VerifierAlphaMax(document.forms[0].lcprest)";
   tabVerif["lresdeb"]  = "VerifierDate2(document.forms[0].lresdeb,'jjmmaaaa')";
   tabVerif["lresfin"]  = "VerifierDate2(document.forms[0].lresfin,'jjmmaaaa')";
   tabVerif["lccouact"] = "VerifierNum2(document.forms[0].lccouact,12,2)";
   tabVerif["proporig"] = "VerifierNum2(document.forms[0].proporig,10,2)";
   
   var Message="<bean:write filter="false"  name="ligneContratForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ligneContratForm"  property="focus" />";
   
	if (document.forms[0].ident.value != '') 
	{
		document.getElementById('afficheMC').style.display = 'block';
	}
   
   
   if (Message != "") {
      alert(Message);      
   }
   
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();  
   else document.forms[0].lresdeb.focus();

}

function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
}

function renverseStrDate(sIn) {
  var sOut = "";
  if(sIn!=""){
	  sOut = sIn.charAt(6) + sIn.charAt(7) + sIn.charAt(8)+ sIn.charAt(9) + "/" + sIn.charAt(3)+ sIn.charAt(4) + "/" + sIn.charAt(0)+ sIn.charAt(1)
  }
  return(sOut);
}

function ValiderEcran(form)
{

  if(rafraichiEnCours)
  	return false;
  	
   form.ctypfact.value = "<%= ligneContratForm.getCtypfact() %>";
   if (blnVerification) {
	if ( !VerifFormat(null) ) return false;
	
	var datedeb = renverseStrDate(form.lresdeb.value);
  	var datefin = renverseStrDate(form.lresfin.value);
  	  	
	if (form.lresdeb.value!="" && datedeb > datefin){
 	  alert('Date de fin doit être égale ou ultérieure à la date de début');
 	  form.lresfin.value = '';
 	  return false;
	}
	
	if (!ChampObligatoire(form.lresdeb, "la date de début d'utilisation de la ressource")) return false;
	if (!ChampObligatoire(form.lresfin, "la date de fin d'utilisation de la ressource")) return false;
	if (!ChampObligatoire(form.ident, "le code ressource")) return false;
	if (!ChampObligatoire(form.modeContractuel, "le code du mode contractuel")) return false;
	if (form.modeContractuel.value == '???' || form.modeContractuel.value == 'XXX')
	{ 
		alert("Veuillez saisir un mode contractuel valide");
		form.modeContractuel.focus();
		return false;
	}
	if (!ChampObligatoire(form.lccouact, "le coût journalier HT du contrat")) return false;
	if (!ChampObligatoire(form.proporig, "le coût proposé d'origine")) return false;

	if (form.mode.value == 'insert') {
		ajaxCallRemotePage('/ligneContrat.do?action=ctrlPeriodeC&cav='+form.cav.value+'&lcnum='+form.lcnum.value+'&ident='+form.ident.value+'&numcont='+form.numcont.value+'&resdeb='+datedeb+'&resfin='+datefin);
		if (document.getElementById("ajaxResponse").innerHTML!='') {
			alert(document.getElementById("ajaxResponse").innerHTML);
			return false;
		}
	}
	
	if (form.mode.value == 'update') {
	
		ajaxCallRemotePage('/ligneContrat.do?action=ctrlPeriodeM&cav='+form.cav.value+'&lcnum='+form.lcnum.value+'&ident='+form.ident.value+'&numcont='+form.numcont.value+'&resdeb='+datedeb+'&resfin='+datefin);
		if (document.getElementById("ajaxResponse").innerHTML!='') {
			alert(document.getElementById("ajaxResponse").innerHTML);
			return false;
		}

	   if (!confirm("Voulez-vous modifier cette ligne de contrat ?")) return false;
	}
	if (form.mode.value == 'delete') {
	   if (!confirm("Voulez-vous supprimer cette ligne de contrat ?")) return false;
	}
	if (form.action.value == 'annuler') {
	form.keyList0.value = form.soccont.value;
	form.keyList1.value = form.numcont.value;
	form.keyList2.value = form.cav.value;
	return true;
	}	
		
   }
   return true;
}

function recherchePrestation(){
	window.open("/recupPrestation.do?action=initialiser&nomChampDestinataire=lcprest&windowTitle=Recherche Code Prestation&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}  

function rechercheID(){
	var date1 = document.forms[0].lresdeb.value;
	var date2 = document.forms[0].lresfin.value;
	
	if((date1 != "") && (date2 != "")){
		window.open("/recupIdPersonneCompatible.do?action=initialiser&rtype=<%= ligneContratForm.getCtypfact() %>&soccont=<%= ligneContratForm.getSoccont() %>&lresdeb=" + date1 + "&lresfin=" + date2 + "&nomChampDestinataire=ident&rafraichir=OUI&windowTitle=Recherche Identifiant Ressource&habilitationPage=HabilitationRestime"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	}else{
		alert('veuilez saisir la date de début et la date de fin');
	}
}  

function rechercheModeContractuel()
{
	var rtype="<%= ligneContratForm.getRtype() %>";
	if (rtype == 'P'  || rtype == 'L'){
		window.open("/recupModeContractuel.do?action=initialiser&localisation=<%= ligneContratForm.getCodeloc() %>&modeContractuelInd=<%= ligneContratForm.getModeContractuel() %>&rtype=<%= ligneContratForm.getRtype() %>&typfact=<%= ligneContratForm.getCtypfact() %>&nomChampDestinataire1=modeContractuel&rafraichir=OUI&windowTitle=Recherche Mode Contractuel&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=yes, menubar=no, resizable=yes, scrollbars=yes, width=900, height=450") ;
	}
	else
	{
	window.open("/recupModeContractuel.do?action=initialiser&localisation=<%= ligneContratForm.getCodeloc() %>&modeContractuelInd=<%= ligneContratForm.getModeContractuel() %>&rtype=<%= ligneContratForm.getRtype() %>&typfact=<%= ligneContratForm.getCtypfact() %>&nomChampDestinataire1=modeContractuel&rafraichir=OUI&windowTitle=Recherche Mode Contractuel&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=yes, menubar=no, resizable=yes, scrollbars=yes, width=500, height=450") ;
	
	}
}

function nextFocusLoupePrestation(){
	document.forms[0].lresdeb.focus();
}

function nextFocusLoupeCodeContractuel(){
	document.forms[0].modeContractuel.focus();
}

function nextFocusLoupeCoutContrat(){
	document.forms[0].lccouact.focus();
}

function refresh(focus) {

document.forms[0].focus.value = focus;

 if(!rafraichiEnCours)
	      {
		     rafraichir(document.forms[0]);
		     rafraichiEnCours = true;
	       }

}

function TestRefresh(focus)
{
	var lresdeb = renverseStrDate(document.forms[0].lresdeb.value);
  	var lresfin = renverseStrDate(document.forms[0].lresfin.value);
  	var cdatdeb = renverseStrDate(document.forms[0].cdatdeb.value);
  	var cdatfin = renverseStrDate(document.forms[0].cdatfin.value);
		
	if ( document.forms[0].lresdeb.value != "" && (lresdeb > cdatfin || lresdeb < cdatdeb)  )
	{
		alert("la date de début de la ligne doit etre incluse dans la période globale du contrat");
		document.forms[0].lresdeb.value = '';
		document.forms[0].lresfin.focus();

		
		
	}	else
	{
	
	if (document.forms[0].lresfin.value != "" && (lresfin > cdatfin || lresfin < cdatdeb)  )
	{
		alert("la date de fin de la ligne doit etre incluse dans la période globale du contrat");
		document.forms[0].lresfin.value = '';
		document.forms[0].lresdeb.focus();
	
		
		
	}	else
	{
	
	if (document.forms[0].lresdeb.value!="" && document.forms[0].lresfin.value!="" && lresdeb > lresfin)
	{
 	  alert('Date de fin doit être égale ou ultérieure à la date de début');
 	  document.forms[0].lresfin.value = '';
	  document.forms[0].lresdeb.focus();

 	  
	}
	else
	{	
		if (document.forms[0].lresfin.value != "" && document.forms[0].lresdeb.value!= "" && document.forms[0].ident.value!= "")
		{
			refresh(focus);
		}
	}	
	}
	}

	document.forms[0].elements[focus].focus();
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="ligneContratForm" property="titrePage"/>  
            une ligne de contrat <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/ligneContrat"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
           <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="titrePage"/>
			<html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		      <html:hidden property="focus"/> 
		   	<html:hidden property="keyList0"/> 
         	<html:hidden property="keyList1"/>
			<html:hidden property="keyList2"/>
			<html:hidden property="keyList3"/>  
		    <html:hidden property="flaglock"/>
   			<html:hidden property="lcnum"/> 
   			<html:hidden property="ctypfact"/> 
   			<html:hidden property="codeloc"/> 
   			<html:hidden property="rtype"/> 
   	   			
              <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                              
                <tr> 
                  <td class=lib>Code société : </td>
                  <td><b><bean:write name="ligneContratForm"  property="soccont" />
                    <html:hidden property="soccont"/></b>
                  </td>
                  <td >&nbsp;</td>
                  <td class=lib>Libellé société : </td>
                  <td ><bean:write name="ligneContratForm"  property="soclib" />
                    <html:hidden property="soclib"/>
                  </td>
                </tr>
                <tr> 
                  <td class=lib>Réf. du contrat : </td>
                  <td><b><bean:write name="ligneContratForm"  property="numcont" />
                    <html:hidden property="numcont"/></b>
                      </td>
                  <td >&nbsp;</td>
                  <td class=lib>N° d'avenant : </td>
                  <td><b><bean:write name="ligneContratForm"  property="cav" />
                    <html:hidden property="cav"/>
                  </td>
                   
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                </table>
              
             <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr>
                	<td class=lib>Période du contrat : </td>
                	<td>&nbsp;</td>
                	<td class=lib>Date de début : </td>
                	 <td><b><bean:write name="ligneContratForm"  property="cdatdeb" />
                    <html:hidden property="cdatdeb"/></b>
                      </td>
                       <td>&nbsp;</td>
                      <td class=lib>Date de fin : </td>
                	 <td><b><bean:write name="ligneContratForm"  property="cdatfin" />
                    <html:hidden property="cdatfin"/></b>
                      </td>
                </tr>
             </table>   
             
               
              <hr>
              
                <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
              	<tr>
                	<td class=lib>Période de la ligne : </td>
                	<td>&nbsp;</td>
                      <td class=lib><b>Date de début : </b></td>
                  
                  
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer"> 
                    	<html:text property="lresdeb" styleClass="input" size="10" maxlength="10" onchange="VerifFormat(this.name);TestRefresh(this.name);"/>
                     </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="ligneContratForm"  property="lresdeb" />
                  		<html:hidden property="lresdeb"/>
                    </logic:equal></td>
                  <td>&nbsp;</td>
                  <td class=lib><b>Date de fin : </b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer"> 
                    	<html:text property="lresfin" styleClass="input" size="10" maxlength="10" onchange="VerifFormat(this.name);TestRefresh(this.name);"/>
                     </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="ligneContratForm"  property="lresfin" />
                  		<html:hidden property="lresfin"/>
                    </logic:equal>
                  </td>
                             
                </tr>
                 </table>
             
             
              <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td colspan=7>&nbsp;</td>
                </tr>
                <tr> 
                  <!--  <td class=lib>Ident :</td>-->
                  <td class=lib><b>Code ress. Bip : </b></td>
                  <td >
                  	<logic:notEqual parameter="action" value="supprimer"> 
                    	<html:text property="ident" styleClass="input" size="5" maxlength="5" onchange="VerifierNum(this,5,0);refresh(this.name);"/>
                        &nbsp;&nbsp;<a href="javascript:rechercheID();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Ressource" title="Rechercher Ressource" align="absbottom"></a>
                     </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer"> 
                    	<bean:write name="ligneContratForm"  property="ident" />
                    	<html:hidden property="ident"/>
                    </logic:equal>
                  </td>
                  <td class=lib>Nom : </td>
                  <td colspan=2>
                  	<div id="rnomDiv">
                  		<bean:write name="ligneContratForm"  property="rnom" />
                  	</div>
                    <html:hidden property="rnom"/>
                  </td>
                 
                 <%if (ligneContratForm.getCtypfact().equals("F")){ %>
                 <td colspan=2>&nbsp;</td>
                 
                 <%}else { %>
                       <td class=lib>Prénom : </td>
                  <td >
                  	<div id="rprenomDiv">
                  		<bean:write name="ligneContratForm"  property="rprenom" />
                    </div>
                    <html:hidden property="rprenom"/>
                  </td>
                  <%} %>
                </tr>
                <tr> 
                  <td colspan=7>&nbsp;</td>
                </tr>
               <tr> 
                  <td class=lib>Domaine : </td>
                  <td colspan=6> 
                  		<bean:write name="ligneContratForm"  property="lcdomaine" />
                  		<html:hidden property="lcdomaine"/>
                  </td>
                </tr>
           
                  	<tr> 
	                  <td class=lib>Prestation : </td>
	                  <td colspan=6> 
                  		<bean:write name="ligneContratForm"  property="lcprest" />
                  		<html:hidden property="lcprest"/>
                  	  </td>
                	</tr>
                  <%//} %>
                  
                <tr> 
                  <td colspan=7>&nbsp;</td>
                </tr>  
                <tr>
                	<td class=lib>Mode Contractuel : </td>
                	<td colspan=6>&nbsp;</td>
                </tr>
                <tr> 
                  <td class=lib><b>Code : </b></td>
                             
                   <td>
                  	<logic:notEqual parameter="action" value="supprimer"> 
                  	<div id="afficheMC" style="display:none;">     
                    	  <html:text property="modeContractuel" styleClass="input" size="3" maxlength="3" onchange="VerifierAlphaMaxCarSpecModeContractuel(this);refresh(this.name);" />
	                        &nbsp;&nbsp;<a href="javascript:rechercheModeContractuel();" onFocus="javascript:nextFocusLoupeCoutContrat();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Mode Contractuel" title="Rechercher Mode Contractuel" ></a>
      </div>
     </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer"> 
                    	<bean:write name="ligneContratForm"  property="modeContractuel" />
                    	<html:hidden property="modeContractuel"/>
                    </logic:equal>
                  </td>
                 
                  <td class=lib>Libellé : </td>
                  <td colspan=4> 
                  <bean:write name="ligneContratForm"  property="libModeContractuel" />
                  	 	<html:hidden property="libModeContractuel"/>  
                  </td>
                </tr>
                <tr> 
                  <td colspan=7>&nbsp;</td>
                </tr>
                <tr>
                	<td class=lib>Coût journalier HT :</td>
                	<td colspan=6>&nbsp;</td>
                </tr>
                <tr> 
                  <td class=lib>de la situation :</td>
                  <td><bean:write name="ligneContratForm"  property="cout" />
                  		<html:hidden property="cout"/>
                  </td>
                  <td class=lib><b>du contrat :</b></td>
                  <td><logic:notEqual parameter="action" value="supprimer"> 
                    	<html:text property="lccouact" styleClass="input" size="13" maxlength="13" onchange="return VerifFormat(this.name);"/>
                     </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="ligneContratForm"  property="lccouact" />
                  		<html:hidden property="lccouact"/>
                    </logic:equal></td>
                  <td class=lib><b>d'origine :</b></td>
                  <td><logic:notEqual parameter="action" value="supprimer"> 
                    	<html:text property="proporig" styleClass="input" size="13" maxlength="13" onchange="return VerifFormat(this.name);"/>
                     </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="ligneContratForm"  property="proporig" />
                  		<html:hidden property="proporig"/>
                    </logic:equal></td>
                     <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=7>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=7>&nbsp;</td>
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
Integer id_webo_page = new Integer("3002"); 
com.socgen.bip.commun.form.AutomateForm formWebo = ligneContratForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->