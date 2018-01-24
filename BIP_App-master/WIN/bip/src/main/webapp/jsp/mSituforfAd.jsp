<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,java.util.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
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
   Hashtable hKeyList= new Hashtable();
   
   hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
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
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<!-- <link rel="stylesheet" href="../css/style_bip.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var tabVerif        = new Object();
var rafraichiEnCours = false;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   tabVerif["codcontractuel"] = "VerifierAlphaMaxCarSpecModeContractuel(document.forms[0].codcontractuel)";
   var Message="<bean:write filter="false"  name="forfaitForm"  property="msgErreur" />";
   var Focus = "<bean:write name="forfaitForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
    if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
     else if (document.forms[0].mode.value =="insert")
     	{
		document.forms[0].datsitu.focus();
		} 	else
		document.forms[0].datdep.focus();
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

function ValiderEcran(form)
{
  
  if(rafraichiEnCours)
  	return false;
  
   if (blnVerification) {
   
   	if (   
		( form.mciObligatoire.value == 'O' )
		&& ( form.mode.value != 'delete' )
		&& ( form.modeContractuelInd.value == "" || form.modeContractuelInd.value == "XXX" || form.modeContractuelInd.value == "???" )
       ) {
			alert('Un vrai mci est obligatoire pour les ressources externes de votre entité, veuillez le saisir');
			form.modeContractuelInd.focus();
			return false;
	     }	
	if (form.datsitu && !ChampObligatoire(form.datsitu, "la date de valeur")) return false;
	if (form.codsg && !ChampObligatoire(form.codsg, "le code Département/Pôle/Groupe")) return false;
	if (form.soccode && !ChampObligatoire(form.soccode, "le code société")) return false;
	if (form.code_domaine && !ListeObligatoire(form.code_domaine, "le domaine")) return false;
	if (form.prestation && !ListeObligatoire(form.prestation, "la prestation")) return false;
	if (form.modeContractuelInd && !ChampObligatoire(form.modeContractuelInd, "le mode contractuel indicatif")) return false;
	if (form.cpident &&!ChampObligatoire(form.cpident, "l'identifiant chef de projet")) return false;
	if (form.code_domaine && !ListeObligatoire(form.code_domaine, "le domaine")) return false;
	if (form.prestation && !ListeObligatoire(form.prestation, "la prestation")) return false;
		
	if (form.mode.value != 'delete') {
	//Tester que le coût est différent de 0
	
		if ((form.coufor.value==null||form.coufor.value==""||form.coufor.value=="0,00"||form.coufor.value==",00") ) {
			alert("Le coût doit être différent de 0");
			form.coufor.focus();
			return false;
	
	}
	
	}
      if (form.mode.value == 'update') {
         if (!confirm("Voulez-vous modifier la situation de ce forfait?")) return false;
      }
       if (form.mode.value == 'delete') {
         if (!confirm("Voulez-vous supprimer la situation de ce forfait ?")) return false;
      }
   }
   
   
   if (form.montant_mens.value=="0,00"||form.montant_mens.value==",00"||form.montant_mens.value=="0" ) {
			form.montant_mens.value='';			
	}
   
   return true;
}
function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=codsg&rafraichir=OUI&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
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

function nextFocusSoccode(){
	document.forms[0].soccode.focus();
}

function nextFocusCpident(){
	document.forms[0].cpident.focus();
}

function nextFocusMC(){
	document.forms[0].modeContractuelInd.focus();
}

function nextFocusCoufor(){
	document.forms[0].coufor.focus();
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
<div id="topContainer" style="min-height:98%;">
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
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> 
<!--             <div align="center">#BeginEditable "barre_haut"  -->
<%--               <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%> --%>
<%--               <%=tb.printHtml()%><!-- #EndEditable --></div> --%>
          </td>
        </tr>
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
           <bean:write name="forfaitForm" property="titrePage"/> une situation pour un forfait<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/situforf"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			  <html:hidden property="titrePage"/>
              <html:hidden property="action"/>
              <html:hidden property="focus"/> 
		      <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		      <html:hidden property="flaglock"/>
		      <html:hidden property="keyList0"/>
		      <html:hidden property="oldatsitu"/>
		      <html:hidden property="typeForfait"/>
		      <html:hidden property="localisation"/>
		      <html:hidden property="mciObligatoire"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td colspan=6>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=6 height="20">&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td class="texte" >Nom :</td>
                  <td class="texte"><b><bean:write name="forfaitForm"  property="rnom" /></b>
                    	<html:hidden property="rnom"/>
                  </td>
                  <td colspan=2>&nbsp;</td>                  
                  <td class="texte">Type de ressource :</td>
                  <td colspan="2" class="texte">
						<% if ( ("F").equals(forfaitForm.getTypeForfait())) {%>
                  	  	F - Forfait AVEC frais d'environnement
                   		<% }
                   		else { %>
               		  	E - Forfait SANS frais d'environnement
               			<% } %>
                   	<html:hidden property="typeForfait"/>
                   </td>
                </tr>
                <tr align="left"> 
                  <td class="texte">Identifiant :</td>
                  <td class="texte"><bean:write name="forfaitForm"  property="ident" />
                    	<html:hidden property="ident"/>
                   </td>
                  <td colspan=2>&nbsp;</td>
                  <td class="texte"> co&ucirc;t total :</td>
                  <td colspan="2" class="texte">
                    <bean:write name="forfaitForm"  property="coutot" />
                    	<html:hidden property="coutot"/>
                </tr>
                <tr> 
                  <td align=center colspan=10>&nbsp;</td>
                </tr>
                <tr align="left">
			<logic:notEqual parameter="action" value="supprimer"> 
                  <td  colspan=8 class="texte"> Corrigez ces valeurs par les nouvelles : </td>
			</logic:notEqual>
                </tr>
                <tr align="left"> 
                  <td class="texte"><b>Date de valeur :</b></td>
                  
                          <logic:equal parameter="mode" value="insert">  		                    
			                 <td><html:text property="datsitu" styleClass="input" size="8" maxlength="7" onchange="if(TestDate(this,'mm/aaaa')){refresh(this.name)};"/></td>        	
		                  	</logic:equal> 
		                  	 <logic:notEqual parameter="mode" value="insert">  		                    
			                 <td class="texte"><bean:write name="forfaitForm"  property="datsitu" />
		                   	<html:hidden property="datsitu"/></td>
		                  	</logic:notEqual> 
	           
                  
                  <td >&nbsp; </td>
                  <td >&nbsp;</td>
                  <td class=texte><b>Date d&eacute;part :</b></td>
                  <logic:notEqual parameter="action" value="supprimer"> 
                  	<td colspan=2 ><html:text property="datdep" styleClass="input" size="10" maxlength="10" onchange="if(TestDate(this,'jj/mm/aaaa')){refresh(this.name)};"/></td>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	<td class="texte" colspan=2><bean:write name="forfaitForm"  property="datdep" />
                   	<html:hidden property="datdep"/></td>
                   </logic:equal>
                </tr>
                <tr align="left"> 
                  <td class=texte> <b> DPG</b> : </td>
                  <logic:notEqual parameter="action" value="supprimer"> 
                  		<td class="texte"><html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange="if ( VerifierNum(this,7,0)){refresh(this.name);};"/>
                  		&nbsp;<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusSoccode();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" style="vertical-align : middle;"></a></td>
                   	</logic:notEqual>
                   	<logic:equal parameter="action" value="supprimer">
                   		<td class="texte" ><bean:write name="forfaitForm"  property="codsg"/>
                   		<html:hidden property="codsg"/></td>
                   	</logic:equal> 
                  
                  <td >&nbsp; </td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td align=center colspan=5>&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td class=texte><b>Société :</b></td>                  
                    <logic:notEqual parameter="action" value="supprimer"> 
                  		<td class="texte"> <html:text property="soccode" styleClass="input" size="4" maxlength="4" onchange="if(VerifierAlphaMax(this)){refresh(this.name)};"/>
                  		&nbsp;<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusMC();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société" style="vertical-align : middle;"></a>
                   		</td>
                   		<td >&nbsp;</td>
                  		<td >&nbsp;</td>
                  		<td class=texte>Libellé société:</td>
                  	 	<td class=texte><bean:write name="forfaitForm"  property="lib_soccode" />
                  	 	<html:hidden property="lib_soccode"/></td>                  		                  		
                   	</logic:notEqual>
                   	<logic:equal parameter="action" value="supprimer">
                   		<td class=texte><bean:write name="forfaitForm"  property="soccode" />
                   		<html:hidden property="soccode"/>
                   		</td>
                   		<td >&nbsp;</td>
                  		<td >&nbsp;</td>
                  		<td >&nbsp;</td>
                  		<td >&nbsp;</td>
                   	</logic:equal>                                     
                </tr>
                <tr align="left">
                 <td class=texte>SIREN :</td>
                 <td class=texte><bean:write name="forfaitForm"  property="lib_siren" />
                 <html:hidden property="lib_siren"/></td>
                </tr>
                
                <tr> 
                  <td align=center colspan=5>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=5>&nbsp;</td>
                </tr>
                
                 <tr align="left"> 
                 <logic:notEqual parameter="action" value="supprimer">
                     <td class="texte"><b>Domaine :</b></td>
                     <td colspan=6>
                   	<html:select property="code_domaine" styleClass="input" onchange="refresh(this.name);"> 
   						<bip:options collection="choixDomaine" />
					</html:select>
				  </logic:notEqual>
				  <logic:equal parameter="action" value="supprimer">
				    <td class="texte">Domaine :</td>
                     <td colspan=6 class=texte> 
                  	<bean:write name="forfaitForm"  property="code_domaine" />
                  	<html:hidden property="code_domaine"/>
				  </logic:equal>
                  </td>
                </tr>
                <tr align="left">
                 <logic:notEqual parameter="action" value="supprimer"> 
                     <td class="texte"><b>Prestation :</b></td>
                     <td colspan=6>
                   	 <html:select property="prestation" styleClass="input"> 
   						<bip:options collection="choixPrestation" />
					 </html:select>
				  </logic:notEqual>
				  <logic:equal parameter="action" value="supprimer">
				    <td class="texte">Prestation :</td>
                     <td colspan=6 class=texte> 
                  	<bean:write name="forfaitForm"  property="prestation" />
                  	<html:hidden property="prestation"/>
				  </logic:equal>
                  </td>
                </tr>
                <tr align="left"> 
                 <logic:notEqual parameter="action" value="supprimer"> 
                     <td class="texte"><b>Mode contractuel indicatif :</b></td>
                     <td colspan=6 class="texte"><html:text property="modeContractuelInd" styleClass="input" size="3" maxlength="3" onchange="VerifierAlphaMaxCarSpecModeContractuel(this); refresh(this.name);"/>
	                     &nbsp;<a href="javascript:rechercheModeContractuel();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Mode Contractuel" title="Rechercher Mode Contractuel" style="vertical-align : middle;"></a>
	                		&nbsp;&nbsp;<bean:write name="forfaitForm"  property="lib_mci" /></td>
					 <html:hidden property="lib_mci"/> 
				  </logic:notEqual>
				  <logic:equal parameter="action" value="supprimer">
				    <td class="texte">Mode contractuel indicatif :</td>
                     <td colspan=6 class=texte> 
                  	<bean:write name="forfaitForm"  property="modeContractuelInd" />
                  	<html:hidden property="modeContractuelInd"/>
				  </logic:equal>
                  </td>
                </tr>
                
                <tr> 
                  <td align=center colspan=5>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=5>&nbsp;</td>
                </tr>
                
                <tr align="left"> 
                  <td class=texte><b>Chef de projet :</b></td>
                  
                   <logic:notEqual parameter="action" value="supprimer"> 
                   	<td colspan=6 class="texte"><html:text property="cpident" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/>
                   	&nbsp;<a href="javascript:rechercheID();"  onFocus="javascript:nextFocusCoufor();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant Chef de Projet" title="Rechercher Identifiant Chef de Projet" style="vertical-align : middle;"></a></td>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	<td colspan=6 class="texte"> <bean:write name="forfaitForm"  property="cpident" /></td>
                   </logic:equal>
                 </tr>
                
                <logic:notEqual parameter="action" value="supprimer">
                <tr align="left">
                	<td class="texte"><b>Co&ucirc;t unitaire HT :</b></td>
                  <td colspan=6> 
                   <html:text property="coufor" styleClass="input" size="13" maxlength="13" onchange="return VerifierNum(this,12,2);"/>
                  </td>
                </tr>
                <tr align="left"> 
                  <td class="texte"><b>Facturation au 12&egraveme - Montant mensuel :</b></td>
                  <td colspan=6> 
                   <html:text property="montant_mens" styleClass="input" size="13" maxlength="13" onchange="return VerifierNum(this,12,2);"/>
                  </td>
                 </tr> 
               </logic:notEqual>
                
                <logic:equal parameter="action" value="supprimer">
                <tr align="left">
                	<td class=texte>Co&ucirc;t unitaire HT :</td>
                		<td colspan=6 class=texte><bean:write name="forfaitForm"  property="coufor" />
                		<html:hidden property="coufor"/>
                	</td>
                </tr>
                <tr align="left">
                	<td class=texte>Facturation au 12&egraveme :</td>
                		<td colspan=6 class=texte><bean:write name="forfaitForm"  property="montant_mens" />
                		<html:hidden property="montant_mens"/>
                		</td>
                </tr>
                </logic:equal>
                
                <tr> 
                  <td colspan=6>&nbsp;</td>
                <tr> 
                  <td colspan=6 height="15">&nbsp;</td>
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
Integer id_webo_page = new Integer("1033"); 
com.socgen.bip.commun.form.AutomateForm formWebo = forfaitForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
