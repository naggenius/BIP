<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,org.apache.struts.taglib.html.SelectTag,com.socgen.bip.commun.liste.ListeOption,com.socgen.bip.commun.Tools"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="forfaitForm" scope="request" class="com.socgen.bip.form.ForfaitForm" />
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
<bip:VerifUser page="jsp/bForfaitAd.jsp"/> 
<%  

	java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("typeRessourceForfait"); 
	pageContext.setAttribute("choixRType", list1);
	  
	
	Hashtable hKeyList= new Hashtable();  
    hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
    //hKeyList.put("rtype", ""+forfaitForm.getRtype());
    hKeyList.put("rtype", ""+forfaitForm.getTypeForfait());
    hKeyList.put("code_domaine", ""+forfaitForm.getCode_domaine());
  
  
	try {		
		    ArrayList listeDomaine = listeDynamique.getListeDynamique("domainetype", hKeyList);
		    pageContext.setAttribute("choixDomaine", listeDomaine);	
	}   
	catch (Exception e) {
		    pageContext.setAttribute("choixDomaine", new ArrayList());
	}
	
	
	try {
	    ArrayList listePrestation = listeDynamique.getListeDynamique("prestation", hKeyList);
	    pageContext.setAttribute("choixPrestation", listePrestation);
	}   
	catch (Exception e) {
	    pageContext.setAttribute("choixPrestation", new ArrayList());
	}
	

%>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
%>
var pageAide = "<%= sPageAide %>";
var rafraichiEnCours = false;


function MessageInitial()
{
   
   document.forms[0].rnom.value="<%= forfaitForm.getRnom() %>";
   document.forms[0].codsg.value="<%= forfaitForm.getCodsg() %>";

   var Message="<bean:write filter="false"  name="forfaitForm"  property="msgErreur" />";
   var Focus = "<bean:write name="forfaitForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
    else if (document.forms[0].mode.value=="insert"){
      document.forms[0].coutot.value=",00";
      document.forms[0].coufor.value=",00";
      document.forms[0].montant_mens.value=",00";
     
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value=="insert"){
	  document.forms[0].soccode.focus();
   }
   else if (document.forms[0].mode.value=="update"){;
	  document.forms[0].rnom.focus();
   }
  
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function renverseStrDate(sIn) {
  var sOut = "";
  if(sIn!=""){
	  sOut = sIn.charAt(6) + sIn.charAt(7) + sIn.charAt(8)+ sIn.charAt(9) + "/" + sIn.charAt(3)+ sIn.charAt(4) + "/" + sIn.charAt(0)+ sIn.charAt(1)
  }
  return(sOut);
}

function TestDate(champ1, format1, champ2, format2){
	if(VerifierDate(champ1,format1)){
		if (VerifierDateSansAlerte(champ2, format2)){
			var datesitu = renverseStrDate('01/' + document.forms[0].datsitu.value);
  	 		var datedep = renverseStrDate(document.forms[0].datdep.value);
  			if (datedep != "" && datesitu > datedep){
	  			alert('Date de départ doit être égale ou ultérieure à la date d\'arrivée');
	  			champ1.value = '';
	  			return false;
  	  		}
  	  		return true;
		}
		else {
			return true;
		}
	}
	else {
		return true;
	}
}

function VerifierDateSansAlerte( EF, formatDate )
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
	  
	   return false;
	}
	else return true;
   }

   if (EF.value.charAt(2) == separateur) {
	if (formatDate == 'jj/mm/aaaa') {
	   if (EF.value.charAt(5) != separateur) {
		
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
   else {
	return false;
   }

   jj = parseInt( strJJ, 10);
   mm = parseInt( strMM, 10);
   aaaa = parseInt( strAA, 10);

   if (isNaN(jj) == true) err = 1;
   else if (isNaN(mm) == true) err = 2;
   else if (isNaN(aaaa) == true) err = 3;

   if (err != 0) {
	return false;
   }

   if ( (mm < 1) || (mm > 12) ) {
	return false;
   }
   else {
	nbJours = new nbJoursAnnee(aaaa);
	if ((jj > nbJours[mm]) || (jj < 1)) {
 	   return false;
	}
   }
   if ( (aaaa < 1900) || (aaaa > 2100) ) {
	return false;
   }
   return true;
}

function ValiderEcran(form)
{
   if (blnVerification) {
   		if (form.rtype && !ListeObligatoire(form.rtype, "le type ressource")) return false;
      	if (form.soccode && !ChampObligatoire(form.soccode, "la société")) return false;
      	if (form.code_domaine && !ListeObligatoire(form.code_domaine, "le domaine")) return false;
		if (form.prestation && !ListeObligatoire(form.prestation, "la prestation")) return false;
		if (form.modeContractuelInd && !ChampObligatoire(form.modeContractuelInd, "le mode contractuel indicatif")) return false;
	    if (form.datsitu && !ChampObligatoire(form.datsitu, "la date d'arrivée")) return false;
	    if (form.datdep && !ChampObligatoire(form.datdep, "la date de départ")) return false;
		if (form.cpident && !ChampObligatoire(form.cpident, "le code chef de projet")) return false;
		//Tester que les coûts sont différents de 0
	if (form.coutot){
		if (form.coutot.value==null||form.coutot.value==""||form.coutot.value=="0,00"||form.coutot.value==",00") {
			alert("Le coût total doit être différent de 0");
			form.coutot.focus();
			return false;
		}
	
	}
	
	if (   
		( form.mciObligatoire.value == 'O' )
		&& ( form.modeContractuelInd.value == "" || form.modeContractuelInd.value == "XXX" || form.modeContractuelInd.value == "???" )
       ) {
			alert('Un vrai mci est obligatoire pour les ressources externes de votre entité, veuillez le saisir');
			form.modeContractuelInd.focus();
			return false;
	     }	
	
	if (form.mode.value == 'insert') {
	
		if ((form.coufor.value==null||form.coufor.value==""||form.coufor.value=="0,00"||form.coufor.value==",00") ) {
			alert("Le coût doit être différent de 0");
			form.coufor.focus();
			return false;
		}
	}

		if (form.mode.value == 'update') {
         if (!confirm("Voulez-vous modifier ce forfait ?")) return false;
      	}
       if (form.mode.value == 'delete') {
         if (!confirm("Voulez-vous supprimer ce forfait ?")) return false;
      	}
   }
 
   return true;
}
function rechercheID(){
	window.open("/recupIdPersonne.do?action=initialiser&nomChampDestinataire=cpident&windowTitle=Recherche Identifiant Chef de Projet&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
function rechercheSocieteID(){
	document.forms[0].focus.value='soccode';
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=soccode&rafraichir=OUI&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function rechercheModeContractuel(){
	
 	window.open("/recupModeContractuel2.do?action=initialiser&modeContractuelInd=<%= forfaitForm.getModeContractuelInd() %>&localisation=<%= forfaitForm.getLocalisation() %>&rtype=<%= forfaitForm.getTypeForfait() %>&nomChampDestinataire1=modeContractuelInd&nomChampDestinataire2=localisation&rafraichir=OUI&windowTitle=Recherche Mode Contractuel&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=yes, menubar=no, resizable=yes, scrollbars=yes, width=600, height=450") ;
	
}

function nextFocusDatsitu(){
	document.forms[0].datsitu.focus();
}

function nextFocusCoutot(){
	document.forms[0].coutot.focus();
}

function nextFocusMC(){
	document.forms[0].modeContractuelInd.focus();
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
<div id="topContainer" style="height:120%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
        <tr > 
          <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
            <bean:write name="forfaitForm" property="titrePage"/> un forfait <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/forfait"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			  <input type="hidden" name="pageAide" value="<%= sPageAide %>">
              <html:hidden property="titrePage"/>
			  <html:hidden property="action"/>
			  <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			  <html:hidden property="flaglock"/>
			  <html:hidden property="focus"/> 
		     <html:hidden property="localisation"/>
		     <html:hidden property="mciObligatoire"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <br/><br/><br/>
				 <tr align="left"> 
                  <td class="texte"><b>Nom :</b> </td>
                   <td class="texte">
                   <logic:equal parameter="mode" value="insert"> 
                   		<b><bean:write name="forfaitForm"  property="rnom" />
                    	<html:hidden property="rnom"/></b>
                    </logic:equal>
                   <logic:equal parameter="mode" value="update"> 
                   		<html:text property="rnom" styleClass="input" size="32" maxlength="30" onchange="return VerifierAlphaMax(this);"/> 
                   </logic:equal>
                  </td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
				  </tr>
				<!-- Modifier --> 
		       <logic:equal parameter="mode" value="update"> 
				 <tr align="left"> 
				   <td class="texte">Identifiant : </td>
                       <td class="texte"><bean:write name="forfaitForm"  property="ident" />
                    	<html:hidden property="ident"/>
                       </td>
                       <td>&nbsp;</td>
                       <td>&nbsp;</td>
                       </tr>
                 </logic:equal>
				<tr> 
                  <td>&nbsp;</td>
                </tr>
				
				<tr align="left">
					<logic:equal parameter="mode" value="update">
						<td class="texte"><b>Type de ressource:</b></td>
						<td class="texte"><html:select property="typeForfait" styleClass="input">
                    			<html:options collection="choixRType" property="cle" labelProperty="libelle" /> 
            				</html:select>
            				<html:hidden property="typeForfait"/>
            			</td>
					</logic:equal>
					<logic:notEqual parameter="mode" value="update">
	                    <td class="texte"><b>Type de ressource:</b></td>
	                    <td class="texte"><% if ( ("F").equals(forfaitForm.getTypeForfait())) {%>
	                  	  	F - Forfait AVEC frais d'environnement
	                   		<% }
	                   		else { %>
	               		  	E - Forfait SANS frais d'environnement
	               			<% } %>
	                   	<html:hidden property="typeForfait"/>
	                    </td>
                    </logic:notEqual>
                    
                    <logic:equal parameter="mode" value="insert">
	                	<td class="texte"><b>Code DPG :</b></td>
	                  	<td class="texte"><bean:write name="forfaitForm"  property="codsg" />
	                    <html:hidden property="codsg"/> 
	                  	</td>
                  	</logic:equal>
                  	<logic:notEqual parameter="mode" value="insert">
	                  	<td>&nbsp;</td>
	                  	<td>&nbsp;</td>
                  	</logic:notEqual>
                </tr>
        <logic:equal parameter="mode" value="insert"> 
                <tr align="left"> 
                  <td class="texte"><b>Société :</b></td>
                  <td class="texte">  
                  	<html:text property="soccode" styleClass="input" size="4" maxlength="4" onchange="VerifierAlphaMax(this); refresh(this.name);"/>
                  &nbsp;<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusMC();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société" style="vertical-align : middle;"></a>
                  </td>
                  <td class="texte">SIREN :</td>               
				   <td class="texte"><bean:write name="forfaitForm"  property="lib_siren" /></td>
                 <html:hidden property="lib_siren"/> 
                </tr>
                
                <tr align="left"> 
                   <td class="texte"><b>Domaine :</b></td>
                   <td colspan=3>
                 	 <html:select property="code_domaine" styleClass="input" onchange="refresh(this.name);"> 
 						<bip:options collection="choixDomaine" />
			      	 </html:select>
                  </td>
                </tr>
                <tr align="left" >
                     <td class="texte"><b>Prestation :</b></td>
                     <td colspan=3><html:select property="prestation" styleClass="input"> 
   						<bip:options collection="choixPrestation" />
					 </html:select>
                  </td>
                </tr>
                <tr align="left"> 
                     <td class="texte"><b>Mode contractuel indicatif :</b></td>
                     <td class="texte"><html:text property="modeContractuelInd" styleClass="input" size="3" maxlength="3" onchange="VerifierAlphaMaxCarSpecModeContractuel(this); refresh(this.name);" />
	                    &nbsp;<a href="javascript:rechercheModeContractuel();" onFocus="javascript:nextFocusDatsitu();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Mode Contractuel" title="Rechercher Mode Contractuel" style="vertical-align : middle;"></a>
					&nbsp;&nbsp;<bean:write name="forfaitForm"  property="lib_mci" /></td>
					 <html:hidden property="lib_mci"/> 
                </tr>
                
                 <tr align="left"> 
                 <logic:equal parameter="mode" value="insert"> 
                     <td class="texte"><b>Date d'arrivée :</b></td>
                     <td>
                   	<html:text property="datsitu" styleClass="input" size="8" maxlength="7" onchange="return TestDate(this,'mm/aaaa', document.forms[0].datdep,'jj/mm/aaaa' );"/> 
				  </logic:equal>
				  <logic:equal parameter="mode" value="update">
				    <td class="texte"><b>Date d'arrivée :</b></td>
                     <td> 
                  	<bean:write name="forfaitForm"  property="datsitu" />
				  </logic:equal>
                  </td>
                  <td class="texte"><b>Date de départ :</b></td>
                  <td>
                   	<html:text property="datdep" styleClass="input" size="10" maxlength="10" onchange="return TestDate(this,'jj/mm/aaaa', document.forms[0].datsitu,'mm/aaaa');"/> 
				  </td>
                </tr>
                <tr align="left"> 
				  <td class="texte"><b>Id. chef de pr. :</b></td>
                  <td class="texte"> 
                    <html:text property="cpident" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/>
                   &nbsp;<a href="javascript:rechercheID();"  onFocus="javascript:nextFocusCoutot();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant" title="Rechercher Identifiant" style="vertical-align : middle;"></a>
                  </td>
                </tr>
                <tr> 
                 
                </tr>
        </logic:equal>
                <tr align="left"> 
                  <td class="texte"><b>Co&ucirc;t total (EUR) : </b></td>
                  <td> 
                   <html:text property="coutot" styleClass="input" size="13" maxlength="13" onchange="return VerifierNum(this,12,2);"/> 
	              </td>
                </tr>
        <logic:equal parameter="mode" value="insert">
                <tr align="left">
                	<td class="texte"><b>Co&ucirc;t unitaire HT :</b></td>
                  <td> 
                   <html:text property="coufor" styleClass="input" size="13" maxlength="13" onchange="return VerifierNum(this,12,2);"/>
                  </td>
            
                </tr>
                <tr align="left"> 
                  <td class="texte"><b>Facturation au 12&egraveme -<br>Montant mensuel :</b></td>
                  <td> 
                   <html:text property="montant_mens" styleClass="input" size="13" maxlength="13" onchange="return VerifierNum(this,12,2);"/>
                  </td>
         </logic:equal>
                </tr>
                <tr>
                  <td colspan=2>&nbsp;</td>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
<% 
Integer id_webo_page = new Integer("1032"); 
com.socgen.bip.commun.form.AutomateForm formWebo = forfaitForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->