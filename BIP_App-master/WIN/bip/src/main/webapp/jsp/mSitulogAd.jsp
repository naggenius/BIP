<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.util.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="logicielForm" scope="request" class="com.socgen.bip.form.LogicielForm" />
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
<bip:VerifUser page="jsp/bLogicielAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String Rtype = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rtype")));

	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
	
	Hashtable hKeyList= new Hashtable();
    hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
    hKeyList.put("rtype", ""+logicielForm.getRtype());
    hKeyList.put("code_domaine", ""+logicielForm.getCode_domaine());
    
    try {		
	    ArrayList listeDomaine = listeDynamique.getListeDynamique("domainetype", hKeyList);
	    pageContext.setAttribute("choixDomaine", listeDomaine);	
	}   
	catch (Exception e) {
		    //pageContext.setAttribute("choixRType", new ArrayList());
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
var pageAide = "<%= sPageAide %>";
var rafraichiEnCours = false;
var rtype= "<%= Rtype %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="logicielForm"  property="msgErreur" />";
   var Focus = "<bean:write name="logicielForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }

   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
     else if (document.forms[0].mode.value == "insert"){
	document.forms[0].datsitu.focus();
   }	else
		document.forms[0].datdep.focus();
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
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
	if (form.cpident &&!ChampObligatoire(form.cpident, "l'identifiant chef de projet")) return false;
	if (form.code_domaine && !ListeObligatoire(form.code_domaine, "le domaine")) return false;
	if (form.prestation && !ListeObligatoire(form.prestation, "la prestation")) return false;
	if (form.modeContractuelInd && !ChampObligatoire(form.modeContractuelInd, "le mode contractuel indicatif")) return false;
	
      if (form.mode.value == 'update') {
         if (!confirm("Voulez-vous modifier la situation de ce logiciel ?")) return false;
      }
       if (form.mode.value == 'delete') {
         if (!confirm("Voulez-vous supprimer la situation de ce logiciel ?")) return false;
      }
   }
   
   return true;
}
function rechercheID(){
	window.open("/recupIdPersonne.do?action=initialiser&nomChampDestinataire=cpident&windowTitle=Recherche Identifiant Chef de Projet&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
function rechercheDPG(){
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=codsg&rafraichir=OUI&windowTitle=Recherche Code DPG Fournisseur&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
function rechercheSocieteID(){
document.forms[0].focus.value = "soccode";
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=soccode&rafraichir=OUI&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
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

    function rechercheModeContractuel(){
        window.open("/recupModeContractuel2.do?action=initialiser&modeContractuelInd=<%= logicielForm.getModeContractuelInd() %>&nomChampDestinataire1=modeContractuelInd&rtype="+rtype+"&rafraichir=OUI&windowTitle=Recherche Mode Contractuel&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=900, height=450") ;
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
            <bean:write name="logicielForm" property="titrePage"/> une situation pour un logiciel<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/situlog"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			   <html:hidden property="titrePage"/>
              <html:hidden property="action"/>
		      <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		      <html:hidden property="rtype"/>
		      <html:hidden property="flaglock"/>
		      <html:hidden property="keyList0"/>
		      <html:hidden property="focus"/> 
		      <html:hidden property="oldatsitu"/>
		      <html:hidden property="mciObligatoire"/>
		      
              <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td colspan=6>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=6>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib" >Nom :</td>
                  <td><b><bean:write name="logicielForm"  property="rnom" /></b>
                    	<html:hidden property="rnom"/>
             
                  </td>

                  <td colspan=2>&nbsp;</td>
                  <td class="lib"> Co&ucirc;t HTR :</td>
                  <td colspan="2">
                  		<bean:write name="logicielForm"  property="coulog" />
                    	<html:hidden property="coulog"/>
              
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Identifiant :</td>
                  <td><bean:write name="logicielForm"  property="ident" />
                    	<html:hidden property="ident"/>
                   </td>
                  <td colspan=2>&nbsp;</td>
                  <td class="lib"> co&ucirc;t total :</td>
                  <td colspan="2">
                        <bean:write name="logicielForm"  property="coutot" />
                    	<html:hidden property="coutot"/>
              
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Type ressource :</td>
                  <td> <% if ( ("L").equals(logicielForm.getRtype())) {%>
                  	  	L - Logiciel « clé en mains »
                   		<% } %>
                    	<html:hidden property="rtype"/>
                   </td>
                  <td colspan=2>&nbsp;</td>
                  <td >
                    &nbsp;</td>
                  <td colspan="2">&nbsp;</td>
                </tr>
                </table>
                <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td align=center colspan=10>&nbsp;</td>
                </tr>
                <tr> 
                  <td  colspan=8> Corrigez ces valeurs par les nouvelles : </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Date de valeur :</b></td>
                  <td > 
                     		<logic:equal parameter="mode" value="insert">  	
	                  				<html:text property="datsitu" styleClass="input" size="8" maxlength="7" onchange="if(TestDate(this,'mm/aaaa')){refresh(this.name);};"/>
	                  	  		</logic:equal>
	                   		<logic:notEqual parameter="mode" value="insert">  
	                  	  		<bean:write name="logicielForm"  property="datsitu" />
                   			<html:hidden property="datsitu"/>
	                  	  </logic:notEqual>
        
 
                  </td>
                  <td >&nbsp; </td>
                  <td >&nbsp;</td>
                  <td class=lib>Date d&eacute;part :</td>
                  <td colspan=2>
                   <logic:notEqual parameter="action" value="supprimer"> 
                  	<html:text property="datdep" styleClass="input" size="10" maxlength="10" onchange="if(TestDate(this,'jj/mm/aaaa')){refresh(this.name);};"/>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	<bean:write name="logicielForm"  property="datdep" />
                   	<html:hidden property="datdep"/>
                   </logic:equal> 
                   
                  </td>
                </tr>
                <tr> 
                  <td class=lib> <b> DPG</b> : </td>
                  <td> 
                   <logic:notEqual parameter="action" value="supprimer"> 
                  	<html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange="VerifierNum(this,7,0);refresh(this.name);"/>&nbsp;
                  	<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusCpident()"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	<bean:write name="logicielForm"  property="codsg"/>
                   	<html:hidden property="codsg"/>
                   </logic:equal> 
                  </td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                  <td class=lib><b>Chef de projet :</b></td>
                  <td>
                   <logic:notEqual parameter="action" value="supprimer">&nbsp;
                  	<html:text property="cpident" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/>
                  	<a href="javascript:rechercheID();" onFocus="javascript:nextFocusSoccode();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant Chef de Projet" title="Rechercher Identifiant Chef de Projet" align="absbottom"></a>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	<bean:write name="logicielForm"  property="cpident" />
                   </logic:equal>
                  
                  </td>
                </tr>
                <tr> 
                  <td align=center colspan=5>&nbsp;</td>
                </tr>
                <tr> 
                  <td class=lib><b>Société :</b></td>
                  
                   <logic:notEqual parameter="action" value="supprimer"> 
                  	<td> 
                  	<html:text property="soccode" styleClass="input" size="4" maxlength="4" onchange="VerifierAlphaMax(this);refresh(this.name);"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  	<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusMC();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société" align="absbottom"></a>
                    </td>
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                     <td class=lib>Libellé société:</td>
                  	 <td><bean:write name="logicielForm"  property="lib_soccode" />
                  	 <html:hidden property="lib_soccode"/></td>
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   <td>
                   	<bean:write name="logicielForm"  property="soccode" />
                   	<html:hidden property="soccode"/>
                   	</td>
                   	<td >&nbsp;</td>
                  	<td >&nbsp;</td>
                  	<td >&nbsp;</td>
                  	<td >&nbsp;</td>
                   </logic:equal> 
                  </tr>
                  <tr>
                  	<td class=lib>SIREN :</td>
                  	<td><bean:write name="logicielForm"  property="lib_siren" />
                  	<html:hidden property="lib_siren"/></td>
                  	</tr>
                
                
                <tr> 
                 <logic:notEqual parameter="action" value="supprimer"> 
                     <td class="lib"><b>Domaine :</b></td>
                     <td colspan=5>
                   	<html:select property="code_domaine" styleClass="input" onchange="refresh(this.name);"> 
   						<bip:options collection="choixDomaine" />
					</html:select>
				  </logic:notEqual>
				  <logic:equal parameter="action" value="supprimer">
				    <td class="lib">Domaine :</td>
                     <td colspan=5> 
                  	<bean:write name="logicielForm"  property="code_domaine" />
				  </logic:equal>
                  </td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                 <logic:notEqual parameter="action" value="supprimer"> 
                     <td class="lib"><b>Prestation :</b></td>
                     <td colspan=5>
                   	 <html:select property="prestation" styleClass="input"> 
   						<bip:options collection="choixPrestation" />
					 </html:select>
				  </logic:notEqual>
				  <logic:equal parameter="action" value="supprimer">
				    <td class="lib">Prestation :</td>
                     <td colspan=5> 
                  	<bean:write name="logicielForm"  property="prestation" />
				  </logic:equal>
                  </td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                 <tr> 
                       <td class="lib"><b>Mode contractuel indicatif :</b></td>
                 			<logic:notEqual parameter="action" value="supprimer"> 
                                  <td colspan=6><html:text property="modeContractuelInd" styleClass="input" size="3" maxlength="3" onchange="VerifierAlphaMaxCarSpecModeContractuel(this); refresh(this.name);"/>
	                     &nbsp;&nbsp;<a href="javascript:rechercheModeContractuel();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Mode Contractuel Indicatif" title="Rechercher Mode Contractuel Indicatif"></a>
	                		&nbsp;&nbsp;<bean:write name="logicielForm"  property="lib_mci" /></td>
					 <html:hidden property="lib_mci"/> 
				  </logic:notEqual>
				  <logic:equal parameter="action" value="supprimer">
				           <td colspan=6> 
                  	<bean:write name="logicielForm"  property="modeContractuelInd" />
                  	<html:hidden property="modeContractuelInd"/>
				  </logic:equal>
                  </td>
                    <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                
                
                
                <td colspan=6>&nbsp;</td>
                <tr>
                  <td colspan=6>&nbsp;</td>
                <tr> 
                  <td colspan=6>&nbsp;</td>
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
            <!-- #BeginEditable "fin_form" -->
            </html:form><!-- #EndEditable --> 
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
Integer id_webo_page = new Integer("1031"); 
com.socgen.bip.commun.form.AutomateForm formWebo = logicielForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
