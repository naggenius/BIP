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
<%
 //java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeGlobale.getListeGlobale("filiale");
 //pageContext.setAttribute("choixFiliale", list1);	
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var rafraichiEnCours = false;
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
var rtype= "<%= Rtype %>";
	


function MessageInitial()
{
   
   var Message="<bean:write filter="false"  name="logicielForm"  property="msgErreur" />";
   var Focus = "<bean:write name="logicielForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   else if (document.forms[0].mode.value=="insert"){
      document.forms[0].coutot.value=",00";
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value=="insert"){
	  document.forms[0].soccode.focus();
   }
   else if (document.forms[0].mode.value=="update"){
	  document.forms[0].rnom.focus();
   }
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
			&& ( form.modeContractuelInd.value == "" || form.modeContractuelInd.value == "XXX" || form.modeContractuelInd.value == "???" )
	       ) {
			alert('Un vrai mci est obligatoire pour les ressources externes de votre entité, veuillez le saisir');
			form.modeContractuelInd.focus();
			return false;
	     }
      	if (form.soccode && !ChampObligatoire(form.soccode, "la société")) return false;
		if (form.datsitu && !ChampObligatoire(form.datsitu, "la date d'arrivée")) return false;	
		if (form.code_domaine && !ListeObligatoire(form.code_domaine, "le domaine")) return false;
	    if (form.prestation && !ListeObligatoire(form.prestation, "la prestation")) return false;
	    if (form.modeContractuelInd && !ChampObligatoire(form.modeContractuelInd, "le mode contractuel indicatif")) return false;
		if (form.cpident && !ChampObligatoire(form.cpident, "le code chef de projet")) return false;	
		if (form.mode.value == 'update') {
         		if (!confirm("Voulez-vous modifier ce logiciel ?")) return false;
      		}
       		if (form.mode.value == 'delete') {
         		if (!confirm("Voulez-vous supprimer ce logiciel ?")) return false;
      		}
   }
   return true;
}
function rechercheID(){
	window.open("/recupIdPersonne.do?action=initialiser&nomChampDestinataire=cpident&windowTitle=Recherche Identifiant Chef de Projet&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
function rechercheSocieteID(){
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=soccode&rafraichir=OUI&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}



function nextFocusCpident(){
	document.forms[0].cpident.focus();
}

function nextFocusCoutot(){
	document.forms[0].coutot.focus();
}


    function rechercheModeContractuel(){
        window.open("/recupModeContractuel2.do?action=initialiser&modeContractuelInd=<%= logicielForm.getModeContractuelInd() %>&nomChampDestinataire1=modeContractuelInd&rtype="+rtype+"&rafraichir=OUI&windowTitle=Recherche Mode Contractuel&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=900, height=450") ;
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
            <bean:write name="logicielForm" property="titrePage"/> un logiciel <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/logiciel"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
          <html:hidden property="titrePage"/>
		  <html:hidden property="action"/>
		  <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		  <html:hidden property="focus"/> 
		  <html:hidden property="flaglock"/>
		  <html:hidden property="rtype"/>
		  <html:hidden property="mciObligatoire"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
				 <tr> 
                  <td ><b>Nom :</b> </td>
                   <td>
                   <logic:equal parameter="mode" value="insert"> 
                   		<b><bean:write name="logicielForm"  property="rnom" />
                    	<html:hidden property="rnom"/></b>
                    </logic:equal>
                   <logic:equal parameter="mode" value="update"> 
                   		<html:text property="rnom" styleClass="input" size="32" maxlength="30" onchange="return VerifierAlphaMax(this);"/> 
                   </logic:equal>
                  </td>
				  </tr>
				<!-- Modifier --> 
		       <logic:equal parameter="mode" value="update"> 
				 <tr> 
				   <td  align=center>Identifiant :  </td>
                   <td><bean:write name="logicielForm"  property="ident" />
                    	<html:hidden property="ident"/>
                   </td>
                </tr>
               </logic:equal>
				<tr> 
                  <td>&nbsp;</td>
                </tr>
				</table>
				<table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td class="lib">Code DPG :</td>
                  <td><bean:write name="logicielForm"  property="codsg" />
                    	<html:hidden property="codsg"/> 
                 
                  </td>
                  
                  <logic:equal parameter="mode" value="insert"> 
                     <td class="lib"><b>Date d'arrivée :</b></td>
                     <td>
                   	<html:text property="datsitu" styleClass="input" size="8" maxlength="7" onchange="return VerifierDate(this,'mm/aaaa');"/> 
				  </logic:equal>
				  <logic:equal parameter="mode" value="update">
				    <td class="lib">Date d'arrivée :</td>
                     <td> 
                  	<bean:write name="logicielForm"  property="datsitu" />
				  </logic:equal>
                  </td>

                </tr>
        <logic:equal parameter="mode" value="insert"> 
                <tr> 
                  <td class="lib"><b>Société :</b></td>
                  <td> 
                  	<html:text property="soccode" styleClass="input" size="4" maxlength="4" onchange="VerifierAlphaMax(this); refresh(this.name);"/>&nbsp;
                  	<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusMC();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société" align="absbottom"></a>
                  </td>
                  	<td class="lib">SIREN :</td>
				  	<td><bean:write name="logicielForm"  property="lib_siren" />
				  	<html:hidden property="lib_siren"/></td>
                </tr>
               	    <tr> 
                       <td  class="lib"><b>Domaine :</b> </td>
                       <td colspan=3 >
                       	<html:select property="code_domaine" styleClass="input" onchange="refresh(this.name);"> 
   						<bip:options collection="choixDomaine" />
						</html:select>
                     </td>
                    </tr>	
                    
                    <tr> 
                       <td  class="lib"><b>Prestation :</b> </td>
                       <td colspan=3 >
                       	<html:select property="prestation" styleClass="input"> 
   						<bip:options collection="choixPrestation" />
						</html:select>
                     </td>
                     
                    </tr>
                    
                    <tr> 
                       <td class="lib"><b>Mode contractuel indicatif :</b></td>
                 			<logic:notEqual parameter="action" value="supprimer"> 
                                  <td colspan=6><html:text property="modeContractuelInd" styleClass="input" size="3" maxlength="3" onchange="VerifierAlphaMaxCarSpecModeContractuel(this); refresh(this.name);"/>
	                     &nbsp;&nbsp;<a href="javascript:rechercheModeContractuel();"   onFocus="javascript:nextFocusCpident();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Mode Contractuel Indicatif" title="Rechercher Mode Contractuel Indicatif"></a>
	                		&nbsp;&nbsp;<bean:write name="logicielForm"  property="lib_mci" /></td>
					 <html:hidden property="lib_mci"/> 
				  </logic:notEqual>
				  <logic:equal parameter="action" value="supprimer">
				           <td colspan=6> 
                  	<bean:write name="logicielForm"  property="modeContractuelInd" />
                  	<html:hidden property="modeContractuelInd"/>
				  </logic:equal>
                  </td>
                </tr>
               
                <tr> 
				 <logic:equal parameter="mode" value="insert"> 
				   <td class="lib">Co&ucirc;t HTR :</td>
                  <td> 
                   	<bean:write name="logicielForm"  property="coulog" />
                   	<html:hidden property="coulog"/>
                  </td>
            	 </logic:equal>
				   <td class="lib"><b>Id. chef de pr. :</b></td>
                  <td> 
                    <html:text property="cpident" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/>&nbsp;
                    <a href="javascript:rechercheID();"  onFocus="javascript:nextFocusCoutot();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant Chef de Projet" title="Rechercher Identifiant Chef de Projet" align="absbottom"></a> 
                  </td>
                </tr>
                <tr> 
                 
                </tr>
        </logic:equal>
             
                <tr> 
                  <td class="lib">Co&ucirc;t total (EUR) :
				  </td>
                  <td> 
                   <html:text property="coutot" styleClass="input" size="13" maxlength="13" onchange="return VerifierNum(this,12,2);"/> 
                  </td>
                  <td></td>
                  <td></td>
                </tr>
                <tr>
                  <td colspan=2>&nbsp;</td>
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
</body>
<% 
Integer id_webo_page = new Integer("1030"); 
com.socgen.bip.commun.form.AutomateForm formWebo = logicielForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
