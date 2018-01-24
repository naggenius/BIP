 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="dateFactureForm" scope="request" class="com.socgen.bip.form.DateFactureForm" />
<jsp:useBean id="ligneFactureForm" scope="request" class="com.socgen.bip.form.LigneFactureForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fDatefactureOr.jsp"/>
<%
java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("factureType");
pageContext.setAttribute("choixFactureType", list1);
%>
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

var blnVerifFormat  = true;
var tabVerif        = new Object();

function MessageInitial()
{
  tabVerif["socfact"] = "VerifierAlphaMax(document.forms[0].socfact)";
  tabVerif["numfact"] = "VerifierAlphaMaxCarSpec(document.forms[0].numfact)";
  tabVerif["datfact"] = "VerifierDate2(document.forms[0].datfact,'jjmmaaaa')";


   if(document.forms[0].typfact[1].checked == true)
         document.forms[0].typfact[1].checked = true;
   else
        document.forms[0].typfact[0].checked = true;
  
   var Message="<bean:write filter="false"  name="ligneFactureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ligneFactureForm"  property="focus" />";
   var Message1 = "<bean:write name="dateFactureForm"  property="msgErreur" />";
   var Focus1 = "<bean:write name="dateFactureForm"  property="focus" />";
   
    if(document.forms[0].num_expense.value != ""){
      	document.forms[0].socfact.value = "";
   		document.forms[0].numfact.value = "";
   		document.forms[0].datfact.value = "";
   }
     
   if (Message != "") {
      alert(Message);
   }
    
   if (Message1 != "") {
      alert(Message1);
   }
   
   
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	 document.forms[0].socfact.focus(); 
	 if(document.forms[0].num_expense.value != "") document.forms[0].num_expense.focus();
   }
   if (Focus1 != "") (eval( "document.forms[0]."+Focus1 )).focus();
   else {
   		document.forms[0].socfact.focus();
   		if(document.forms[0].num_expense.value != ""){
   		 document.forms[0].num_expense.focus();
   		 	if(document.forms[0].socfact.value != "" || document.forms[0].numfact.value != "" || document.forms[0].datfact.value != ""){
   		 		document.forms[0].num_expense.value = "";
   		 	}
   		}
   } 
     	
	
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}

function ValiderEcran(form)
{
   if (blnVerification) {
   
   if(form.num_expense.value == "") {
	if ( !VerifFormat(null) ) return false;
    	if (!ChampObligatoire(form.socfact, "un code société")) return false;
		if (!ChampObligatoire(form.numfact, "un numéro de facturation")) return false;
		if (!form.typfact[0].checked && !form.typfact[1].checked) {
		   alert("Choisissez un type de facture");
		
		   return false;
		}
	
		if (!ChampObligatoire(form.datfact, "une date de facturation")) return false;
	}   
   }
   return true;
}


function rechercheSocieteID(){
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=socfact&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}  

function nextFocusNumfact(){
	document.forms[0].numfact.focus();
}


function rechercheFacture(){

   var typeFacture;
   
   if (document.forms[0].socfact.value == '')  {
      alert("Veuillez saisir le code de la société");
      document.forms[0].socfact.focus();
   }
   else
   {
   
   		if(document.forms[0].typfact[0].checked == true)
      		typeFacture = "F";
   		else  
      		typeFacture = "A";
      		
      	
		window.open("/recupFacture.do?action=initialiser&socfact="+document.forms[0].socfact.value+"&typeFacture="+typeFacture+"&nomChampDestinataire=numfact&nomChampDestinataire2=datfact&windowTitle=Recherche &habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=700, height=600") ;
	}
}  

function nextFocusDatfact(){
	document.forms[0].datfact.focus();
}

/** Pour vider les champs  */
function viderChamps(elt) {
	
	if (elt.value != '') {
		if (elt.name == 'num_expense') {
			document.getElementsByName('socfact')[0].value = '';
			document.getElementsByName('numfact')[0].value = '';
			document.getElementsByName('datfact')[0].value = '';
			
		}
		else if (elt.name == 'socfact' || elt.name == 'numfact' || elt.name == 'datfact') {
			document.getElementsByName('num_expense')[0].value = '';
		}		
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Factures - Dates de suivi<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/dateFacture"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			 <html:hidden property="action"/>
			 <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			  <html:hidden property="msg_info"/>
			  			  			  
              <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code société :</b></td>
                  <td>
				  <html:text property="socfact" styleClass="input" size="4" maxlength="4" onchange="return VerifFormat(this.name);" onkeyUp="viderChamps(this);" onblur="viderChamps(this);" />
				  &nbsp;&nbsp;<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusNumfact();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société" align="absbottom"></a>    
                  </td>
                </tr>
                
                <tr> 
                  <td class="lib"><b>Type de facture :</b></td>
                  <td>
				  <logic:iterate id="element" name="choixFactureType">
						<bean:define id="choix" name="element" property="cle"/>
						<html:radio property="typfact" value="<%=choix.toString()%>"/>
			 			<bean:write name="element" property="libelle"/>
						</logic:iterate> 
				  
                  </td>
                </tr>
                
                <tr> 
                  <td class="lib"><b>N&deg; de facture :</b></td>
                  <td>
				  <html:text property="numfact" styleClass="input" size="15" maxlength="15" onchange="return VerifFormat(this.name);" onkeyUp="viderChamps(this);" onblur="viderChamps(this);" /> 
				  &nbsp;&nbsp;<a href="javascript:rechercheFacture();" onFocus="javascript:nextFocusDatfact();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Facture" title="Rechercher Facture" align="absbottom"></a>           
                  </td>
                </tr>
				
				<tr> 
                  <td class="lib"><b>Date de facture :</b></td>
                  <td>
				  <html:text property="datfact" styleClass="input" size="10" maxlength="10" onchange="return VerifFormat(this.name);" onkeyUp="viderChamps(this);" onblur="viderChamps(this);"/> 
                  </td>
                </tr>

					 <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                     </tr>
		            <tr> 
    	              <td align=center><u><b>OU</b></u></td>
	                </tr>
					 
					 <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                     </tr>
                     					
					<tr>
						<td class="lib"><b>N&deg; Expense :</b></td>
						<td colspan=2><html:text property="num_expense" styleClass="input"  size="9" maxlength="8" onkeyUp="viderChamps(this);" onblur="viderChamps(this);" onchange="return VerifFormat(this.name);"/></td>
					</tr>                
                
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
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
</body></html:html>
<!-- #EndTemplate -->
