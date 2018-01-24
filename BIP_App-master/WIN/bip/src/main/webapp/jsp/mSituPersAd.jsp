<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="personneForm" scope="request" class="com.socgen.bip.form.PersonneForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bPersonneAd.jsp"/> 
<%
	String submit = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("action")));
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
	
	Hashtable hKeyList= new Hashtable();
    hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
    hKeyList.put("rtype", ""+personneForm.getRtype());
    hKeyList.put("code_domaine", ""+personneForm.getCode_domaine());
 
    try {		
	    ArrayList listeDomaine = listeDynamique.getListeDynamique("domainetype", hKeyList);
	    pageContext.setAttribute("choixDomaine", listeDomaine);	
	    
	    ArrayList listePrestation = listeDynamique.getListeDynamique("prestation", hKeyList);
	    pageContext.setAttribute("choixPrestation", listePrestation);
	    
	        	      	        
	}   
  catch (Exception e) {
	    pageContext.setAttribute("choixDomaine", new ArrayList());
	    pageContext.setAttribute("choixPrestation", new ArrayList());
  }	    
  
%>
<%
  //Liste dynamique sur les niveaux SG.
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("niveau",personneForm.getHParams()); 
  pageContext.setAttribute("choixNiveau", list1);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String Rtype = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rtype")));
	String sRtype="";
	
	if(Rtype.equals("A"))
		   sRtype = "un agent SG ";
    else if(Rtype.equals("P"))
		   sRtype = "une prestation ";
%>
var pageAide = "<%= sPageAide %>";
var rtype= "<%= Rtype %>";
var rafraichiEnCours = false;

function MessageInitial()
{
   //var mess = "<%= personneForm.getMode() %>";
   //alert(mess);

   var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
   var Focus = "<bean:write name="personneForm"  property="focus" />";
   
   if (Message != "") {
      alert(Message);
   }
		
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value == "insert"){
	document.forms[0].datsitu.focus();
   } else
		document.forms[0].datdep.focus();
		
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}

//Appel en ajaxx pour regarder si le MCI est obligatoire pour le DPG
function isMciObligatoireDpg(codsg)
{
	ajaxCallRemotePage('/personne.do?action=isMciObligatoire&codsg='+codsg);
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		document.forms[0].mciObligatoire.value = document.getElementById("ajaxResponse").innerHTML;
	}
	return true;
}

//Appel en ajaxx pour regarder si le MCI est obligatoire pour le DPG
function getMcidefaut()
{	
	if  (	
		 	( document.forms[0].prestation.value == 'SLT' && document.forms[0].fident.value != '')
	          || 
	        ( document.forms[0].prestation.value == 'IFO' && document.forms[0].cpident.value != '' )
         )
         {
        	var prestation = document.forms[0].prestation.value;
        	var cpident = document.forms[0].cpident.value;
        	var fident = '';
        	if (document.forms[0].fident) {
	        	fident = document.forms[0].fident.value;
	        }
        	var datsitu = document.forms[0].datsitu.value;
        	var datdep = document.forms[0].datdep.value;
        	
			ajaxCallRemotePage('/personne.do?action=getMciDefaut&prestation='+prestation+'&cpident='+cpident+'&fident='+fident+'&datsitu='+datsitu+'&datdep='+datdep);
			var mci = document.getElementById("ajaxResponse").innerHTML;
			tab_mci = mci.split(';');
			
			if ( tab_mci[0] != '' ) {
			
				if ( document.forms[0].modeContractuelInd.value != tab_mci[0] ) {
					alert('MCI récupéré automatiquement du forfait lié, veuillez valider de nouveau ');					
				}
				
				document.forms[0].modeContractuelInd.value = tab_mci[0]; // MCI
				document.getElementById("div_mci").innerHTML = tab_mci[1];  // Libelle			
				
				document.forms[0].modeContractuelInd.disabled = true;
				document.forms[0].mciCalcule.value = 'O';
					
			} else {
					document.forms[0].modeContractuelInd.disabled = false;
			   		document.forms[0].mciCalcule.value = 'N';
			}

		} else {
			// rendre la possibilite de saisir a nouveau le mci
			document.forms[0].modeContractuelInd.disabled = false;
	   		document.forms[0].mciCalcule.value = 'N';
		}
		
	return true;
}
	
function ValiderEcran(form)
{

 if(rafraichiEnCours)
  	return false;

   if (blnVerification) {
   	if (form.datsitu && !ChampObligatoire(form.datsitu, "la date de valeur")) return false;
	if (form.codsg && !ChampObligatoire(form.codsg, "le code Département/Pôle/Groupe")) return false;
	if (form.soccode && !ChampObligatoire(form.soccode, "le code société")) return false;
	if (form.code_domaine && !ListeObligatoire(form.code_domaine, "le domaine")) return false;
	if (form.prestation && !ListeObligatoire(form.prestation, "la prestation")) return false;
	if (form.rtype.value != 'A' && form.modeContractuelInd && !ChampObligatoire(form.modeContractuelInd, "le mode contractuel indicatif")) return false;
	if (form.cpident &&!ChampObligatoire(form.cpident, "l'identifiant chef de projet")) return false;
	if (form.dispo && !ChampObligatoire(form.dispo, "la disponibilité")) return false;
	<%if ( "SLT".equals(personneForm.getPrestation()) ) { %>
	if (form.fident &&!ChampObligatoire(form.fident, "l'identifiant forfait")) return false;
	<%}%>
		   
   if (form.mode.value == 'update' || form.action.value == 'creer' || form.mode.value == 'insert') {
   
   	// rendre le mci obligatoire
	if ( 
	    form.prestation.value != 'SLT' 
	    && form.prestation.value != 'IFO'
	    && form.mciObligatoire.value == 'O'
	    && form.rtype.value != 'A'
		&& ( form.modeContractuelInd.value == "" || form.modeContractuelInd.value == "XXX" || form.modeContractuelInd.value == "???" )
	   ) {
		alert('Un vrai MCI est obligatoire pour les ressources externes de votre entité, veuillez le saisir');
		form.modeContractuelInd.focus();
		return false;
	}
	
	if(rtype=='A')
	{
        if (!confirm("Voulez-vous modifier la situation de cet agent SG ?")) return false;
    }    
    else
	{
	    if (!confirm("Voulez-vous modifier la situation de cette prestation ?")) return false;
	}
		
   }
   if (form.mode.value == 'delete') {
    if(rtype=='A')
	{
         if (!confirm("Voulez-vous supprimer la situation de cet agent SG ?")) return false;
    }
    else
    {
	    if (!confirm("Voulez-vous supprimer la situation de cette prestation ?")) return false;
	}		
   }

 }
    
   return true;
}

function renverseStrDate(sIn) {
  var sOut = "";
  if(sIn!=""){
	  sOut = sIn.charAt(6) + sIn.charAt(7) + sIn.charAt(8)+ sIn.charAt(9) + "/" + sIn.charAt(3)+ sIn.charAt(4) + "/" + sIn.charAt(0)+ sIn.charAt(1)
  }
  return(sOut);
}

function TestDate(champ,format){
	if(VerifierDate(champ,format)){
	 var datesitu = renverseStrDate('01/' + document.forms[0].datsitu.value);
  	 var datedep = renverseStrDate(document.forms[0].datdep.value);
  	
  	 if (datedep != "" && datesitu > datedep){
	  	  alert('Date de départ doit être égale ou ultérieure à la date de valeur');
	  	  document.forms[0].datdep.value = '';
	  	  return false;
  	  }
	return true;
	}

}

function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=codsg&rafraichir=OUI&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
function rechercheID(){
	window.open("/recupIdPersonne.do?action=initialiser&nomChampDestinataire=cpident&rafraichir=OUI&windowTitle=Recherche Identifiant Chef de Projet&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
function rechercheSocieteID(){
document.forms[0].focus.value = "soccode";
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=soccode&rafraichir=OUI&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	
	return ;
}  
function rechercheFIDENT(){
		window.open("/recupIdPersonneType.do?action=initialiser&rtype=F&nomChampDestinataire=fident&rafraichir=OUI&windowTitle=Recherche Identifiant Forfait&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
		return ;
}

function nextFocusSoccode(){
     document.forms[0].soccode.focus();
}

function nextFocusCodedomaine(){
   document.forms[0].code_domaine.focus();
}

function nextFocusDispo(){
   document.forms[0].dispo.focus();
}

function nextFocusMC(){

if (rtype = 'P') 
	document.forms[0].modeContractuelInd.focus();
else
	document.forms[0].cpident.focus();
}

function nextFocusCpident(){
	document.forms[0].cpident.focus();
}

function rechercheModeContractuel(){
	if ( document.forms[0].mciCalcule.value != 'O' ) {
	    window.open("/recupModeContractuel2.do?action=initialiser&modeContractuelInd=<%= personneForm.getModeContractuelInd() %>&nomChampDestinataire1=modeContractuelInd&rtype="+rtype+"&rafraichir=OUI&windowTitle=Recherche Mode Contractuel&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=900, height=450") ;
		}    
}

function refresh(focus) {

	document.forms[0].focus.value = focus;

 	if(!rafraichiEnCours)
		{
			rafraichir(document.forms[0]);
			rafraichiEnCours = true;
		 }

}

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
<div style="display:none;" id="ajaxResponse"></div>
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
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->
          <bean:write name="personneForm" property="titrePage"/> une situation pour <%= sRtype %><!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <div id="content"><html:form action="/situpers"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
		      <input type="hidden" name="pageAide" value="<%= sPageAide %>">
		      <html:hidden property="titrePage"/>
                      <html:hidden property="action"/>
		      <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		      <html:hidden property="rtype"/>
		      <html:hidden property="focus"/> 
		      <html:hidden property="flaglock"/>
		      <html:hidden property="keyList0"/>
		      <html:hidden property="oldatsitu"/>
              <html:hidden property="mciCalcule"/>
			  <html:hidden property="mciObligatoire"/>
			  <input type="hidden" name="confirm" value="non">
			  
            <table border="0" cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
					<td >&nbsp;</td>
                </tr>
                <tr align="left"> 
					<td class="texteGras">Nom :</td>
					<td class="texte"><b><bean:write name="personneForm"  property="rnom" /></b>
                    	<html:hidden property="rnom"/>
					</td>
					<td colspan=2>&nbsp;</td>
					<td class="texteGras"> Identifiant :</td>
					<td colspan="2" class="texte"><bean:write name="personneForm"  property="ident" />
                    	<html:hidden property="ident"/>
                    </td>
                </tr>
                <tr align="left"> 
					<td class="texteGras" >Pr&eacute;nom :</td>
					<td  class="texte"><bean:write name="personneForm"  property="rprenom" />
                    	<html:hidden property="rprenom"/>
					</td>
					<td colspan=2>&nbsp;</td>
					<td class="texteGras"> Matricule :</td>
					<td colspan="2" class="texte" ><bean:write name="personneForm"  property="matricule" />
                    	<html:hidden property="matricule"/>
					</td>				  
                </tr>
                <tr align="left"> 
					<td>&nbsp;</td>
					<td >&nbsp;</td>
					<td colspan=2>&nbsp;</td>
					<td class="texteGras"> IGG :</td>
					<td colspan="2" class="texte"><bean:write name="personneForm"  property="igg" />
                    	<html:hidden property="igg"/>
					</td>				  
                </tr>                
				<tr> 
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>  
					<td>&nbsp;</td>					  
					<td>&nbsp;</td>	
            	</tr>
                
					<logic:notEqual parameter="action" value="supprimer">
                <tr> 
					<td colspan=8 class="texte"> Corrigez ces valeurs par les nouvelles : </td>
                </tr>
				</logic:notEqual>
				<tr> 
					<td align=center colspan=10>&nbsp;</td>
                </tr>
                <tr align="left"> 
					<td class="texteGras"><b>Date de valeur :</b></td>
						<%if ((personneForm.getRtype().equals("A")) || (personneForm.getRtype().equals("P") && personneForm.getSoccode().equals("SG.."))) { %>
					<td class="texte">
                    	<logic:equal parameter="mode" value="insert">  	
                       	<html:text property="datsitu" styleClass="input" size="8" maxlength="7" onchange="return TestDate(this,'mm/aaaa');"/>
                  		</logic:equal>
                  		<logic:notEqual parameter="mode" value="insert"> 
                  		<bean:write name="personneForm"  property="datsitu" />
                   		<html:hidden property="datsitu"/>
						</logic:notEqual>
					</td>           
						<%} else {%>
					<td class="texte">
                    	<logic:equal parameter="mode" value="insert">  	
						<html:text property="datsitu" styleClass="input" size="8" maxlength="7" onchange="if(TestDate(this,'mm/aaaa')){refresh(this.name)};"/>
                  		</logic:equal>
                  		<logic:notEqual parameter="mode" value="insert"> 
                  		<bean:write name="personneForm"  property="datsitu" />
                   		<html:hidden property="datsitu"/>
						</logic:notEqual>
					</td>                  
						<%}%>
					<td >&nbsp;</td>
					<td >&nbsp;</td>         
					<td class="texteGras"><b>Date de départ :</b></td>
						<% if ((personneForm.getRtype().equals("A")) || (personneForm.getRtype().equals("P") && personneForm.getSoccode().equals("SG.."))) { %>
					<td colspan=2 class="texte" > 
						<logic:notEqual parameter="action" value="supprimer"> 
						<html:text property="datdep" styleClass="input" size="10" maxlength="10" onchange="if ( TestDate(this,'jj/mm/aaaa')) {refresh(this.name);};"/>
						</logic:notEqual>
						<logic:equal parameter="action" value="supprimer">
						<bean:write name="personneForm"  property="datdep" />
						<html:hidden property="datdep"/>
						</logic:equal> 
					</td>
						<%} else {%>
					<td colspan=2 class="texte" > 
						<logic:notEqual parameter="action" value="supprimer"> 
						<html:text property="datdep" styleClass="input" size="10" maxlength="10" onchange="if(TestDate(this,'jj/mm/aaaa')){refresh(this.name)};"/>
						</logic:notEqual>
						<logic:equal parameter="action" value="supprimer">
						<bean:write name="personneForm"  property="datdep" />
						<html:hidden property="datdep"/>
						</logic:equal> 
					</td>
						<%}%>
				</tr>
                <tr align="left"> 
					<td class="texteGras"><b>DPG :</b></td>
					<td class="texte"> 
						<logic:notEqual parameter="action" value="supprimer"> 
                  		<html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange="VerifierNum(this,7,0);refresh(this.name);"/>&nbsp;
                  		<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusSoccode();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>
						</logic:notEqual>
						<logic:equal parameter="action" value="supprimer">
                   		<bean:write name="personneForm"  property="codsg"/>
                   		<html:hidden property="codsg"/>
						</logic:equal> 
					</td> 
					<td >&nbsp;</td>
					<td >&nbsp;</td>     
					<td >&nbsp;</td>
					<td >&nbsp;</td>
                </tr>
                <tr> 
					<td align=center colspan=5>&nbsp;</td>
                </tr>
                <tr align="left">
                    <td class="texteGras"><b>Société :</b></td>
                  	<td class="texte">
						<logic:notEqual parameter="action" value="supprimer"> 
						<html:text property="soccode" styleClass="input" size="4" maxlength="4" onchange="VerifierAlphaMax(this); refresh(this.name);"/>&nbsp;&nbsp;
						<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusMC();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>                  	
						</logic:notEqual>
						<logic:equal parameter="action" value="supprimer">
						<bean:write name="personneForm"  property="soccode" />
						<html:hidden property="soccode"/>
						</logic:equal>     
                  	</td>    
                  	<td >&nbsp;</td>
                 	<td >&nbsp;</td> 
                   	<td class="texteGras">
						<logic:notEqual parameter="action" value="supprimer"> 
                   	Libellé société:</td>
                  	<td class="texte"><bean:write name="personneForm"  property="lib_soccode" />
                  	 	<html:hidden property="lib_soccode"/>
                  	 	</logic:notEqual>
                  	</td>
                </tr>
                <logic:notEqual parameter="soccode" value="SG..">
                <tr align="left">
                  	<td class="texteGras">SIREN :</td>
                  	<td class="texte"><bean:write name="personneForm"  property="lib_siren" />
                  	 	<html:hidden property="lib_siren"/>
					</td>
                  	<td >&nbsp;</td>
                 	<td >&nbsp;</td> 
                 	<td >&nbsp;</td>
                 	<td >&nbsp;</td> 
                </tr>
                </logic:notEqual>
                <tr> 
					<td align=center colspan=5>&nbsp;</td>
                </tr>
                <tr align="left">
					<td  class="texteGras"><b>Domaine :</b> </td>
					<td colspan=5 class="texte">
                        <logic:notEqual parameter="action" value="supprimer">
                       	<html:select property="code_domaine" styleClass="input" onchange="refresh(this.name);"> 
   						<bip:options collection="choixDomaine" />
						</html:select>
						</logic:notEqual>
						<logic:equal parameter="action" value="supprimer">
                   	       <bean:write name="personneForm"   property="code_domaine" />
                        </logic:equal>  
					</td>
                </tr>	
                <tr align="left"> 
                    <td  class="texteGras"><b>Prestation :</b> </td>
                    <td colspan=5 class="texte" >
                        <logic:notEqual parameter="action" value="supprimer"> 
                       	<html:select property="prestation" styleClass="input" onchange="refresh(this.name);"> 
   						<bip:options collection="choixPrestation"  />
						</html:select>
						</logic:notEqual>
						<logic:equal parameter="action" value="supprimer">
                   	       <bean:write name="personneForm"  property="prestation" />
                        </logic:equal>  
                    </td>
                </tr> 
					<%if ( !personneForm.getSoccode().equals("SG..") ) { %>
                <tr align="left"> 
                    <td class="texteGras"><b>Mode contractuel indicatif :</b></td>
					<logic:notEqual parameter="action" value="supprimer"> 
                    <td class="texte">
							<% if ( "O".equals(personneForm.getMciCalcule()) ) { %>
								<bean:write name="personneForm" property="modeContractuelInd"/>
								<html:hidden property="modeContractuelInd"/>
							<% } else { %>
								<html:text property="modeContractuelInd" styleClass="input" size="3" maxlength="3" onchange="VerifierAlphaMaxCarSpecModeContractuel(this); refresh(this.name);"/>													
									&nbsp;&nbsp;							 			
								<a href="javascript:rechercheModeContractuel();" onFocus="javascript:nextFocusCpident();" >
									<img id="cpident_loupe" border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Mode Contractuel Indicatif" title="Rechercher Mode Contractuel Indicatif">
								</a>
							<% } %>
					</td>
	                <td colspan="4" class="texte""><bean:write name="personneForm"  property="lib_mci" />
	                </td>
					<html:hidden property="lib_mci"/> 
					</logic:notEqual>
				  
					<logic:equal parameter="action" value="supprimer">			        
						<td colspan=6 class="texte"> 
							<bean:write name="personneForm"  property="modeContractuelInd" />
							<html:hidden property="modeContractuelInd"/>
						</td>
					</logic:equal>			  
                </tr>
                    <%} %>
                <tr> 
					<td align=center colspan=10>&nbsp;</td>
                </tr>
                <%if ( "DI".equals(personneForm.getCode_domaine()) && "SLT".equals(personneForm.getPrestation()) ) { %>
				<tr align="left">		
					<td class="texteGras"><b>Ident Forfait :</b></td>
					<td >
						<logic:notEqual parameter="action" value="supprimer">
						<html:text property="fident" styleClass="input" size="5" maxlength="5" onchange="if ( VerifierNum(this,5,0)) {refresh(this.name);};"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="javascript:rechercheFIDENT();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant Forfait" title="Rechercher Identifiant Forfait" align="absbottom"></a>
						</logic:notEqual>
						<logic:equal parameter="action" value="supprimer">
							<bean:write name="personneForm"  property="fident" />
						</logic:equal>
					</td>			
				</tr>
				<tr>	
					<%} %>	
                <tr align="left"> 
					<td class="texteGras"><b>Chef de projet :</b></td>
					<td class="texte">
						<logic:notEqual parameter="action" value="supprimer"> 
						<html:text property="cpident" styleClass="input" size="5" maxlength="5" onchange="if ( VerifierNum(this,5,0)) {refresh(this.name);};"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="javascript:rechercheID();"  onFocus="javascript:nextFocusDispo();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant Chef de Projet" title="Rechercher Identifiant Chef de Projet" align="absbottom"></a>
						</logic:notEqual>
						<logic:equal parameter="action" value="supprimer">
							<bean:write name="personneForm"  property="cpident" />
						</logic:equal>
					</td>
					<td >&nbsp;</td>
					<td >&nbsp;</td>              
					<td class="texteGras"><b>Disponibilité :</b></td>
					<td class="texte">
						<logic:notEqual parameter="action" value="supprimer"> 
						<html:text property="dispo" styleClass="input" size="3" maxlength="3" onchange="return VerifierNum(this,2,1);"/>
						</logic:notEqual>
						<logic:equal parameter="action" value="supprimer">
							<bean:write name="personneForm"  property="dispo" />
						</logic:equal>
                    &nbsp;(J/S)</td>
				</tr>
                <tr align="left"> 
                
                <%if("SG..".equals(personneForm.getSoccode()) && menuId.equals("DIR")){%>
	  			  	<logic:notEqual parameter="action" value="creer">                  				                
					<td class="texteGras"> Niveau :</td>					  
					<td colspan="2" class="texte" >
						<logic:notEqual parameter="action" value="supprimer">
						<html:select property="niveau" styleClass="input" size="1"> 
						<html:options collection="choixNiveau" property="cle" labelProperty="libelle" />
						</html:select> 
						</logic:notEqual>	
						<logic:equal parameter="action" value="supprimer">
						<bean:write name="personneForm"  property="niveau" />
						</logic:equal>
					</td>	
					</logic:notEqual>			  
				<%}else if("SG..".equals(personneForm.getSoccode())) {%>
						<html:hidden property="niveau"/>
				<%}%>                               
                
                <% 				
                  if(!"SG..".equals(personneForm.getSoccode())){
                %>
					<td class="texteGras"><b>Co&ucirc;t journalier HT :</b></td>
					<td class="texte">
						<logic:notEqual parameter="action" value="supprimer"> 
						<html:text property="cout" styleClass="input" size="13" maxlength="13" onchange="return VerifierNum(this,12,2);"/>
						</logic:notEqual>
						<logic:equal parameter="action" value="supprimer">
							<bean:write name="personneForm"  property="cout" />
						</logic:equal>
					</td>
                 <%} %>
                </tr>
 
<%
/*else {
	if(menuId.equals("dirmenu")){*/
%>
<%--
		  <td class=lib>Niveau :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer"> 
                  	<html:select property="niveau" styleClass="input"> 
				<html:options collection="choixNiveau" property="cle" labelProperty="libelle" />
			</html:select>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	<bean:write name="personneForm"  property="niveau" />
                   </logic:equal>
                  </td>	
--%>                  		
<%	/*}//fin if
  }//fin else*/ 
%>
 
					<td>&nbsp;</td>
				<tr> 
					<td colspan=8 align="center"> 
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
					<!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --></div> 
					</td>
				</tr>
			</table>
				<!-- #EndEditable --></div>
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

<% if ( "O".equals(personneForm.getMciAlert()) ) { %>
<script>
	alert('MCI récupéré automatiquement du forfait lié, veuillez valider de nouveau ');
</script>	
<% } %>


</body>
<% 
Integer id_webo_page = new Integer("1029"); 
com.socgen.bip.commun.form.AutomateForm formWebo = personneForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
