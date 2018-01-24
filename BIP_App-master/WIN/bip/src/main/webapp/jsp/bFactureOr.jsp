 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="factureForm" scope="request" class="com.socgen.bip.form.FactureForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bFactureOr.jsp"/>
<%
java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("factureType");
pageContext.setAttribute("choixFactureType", list1);
java.util.ArrayList list2 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topImmo");
pageContext.setAttribute("choixTopImmo", list2);
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
   tabVerif["numcont"] = "VerifierAlphaMaxCarSpecContrat(document.forms[0].numcont)";
   tabVerif["rnom"]    = "VerifierAlphaMax(document.forms[0].rnom)";
   tabVerif["numfact"] = "VerifierAlphaMaxCarSpec(document.forms[0].numfact)";
   tabVerif["datfact"] = "VerifierDate2(document.forms[0].datfact,'jjmmaaaa')";
   tabVerif["numexpense"] = "VerifierAlphaMax(document.forms[0].numexpense)";
   
   if(document.forms[0].typfact[1].checked == true)
         document.forms[0].typfact[1].checked = true;
   else
        document.forms[0].typfact[0].checked = true;
   
   var Message="<bean:write filter="false"  name="factureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="factureForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].socfact.focus();
   }
}

function Verifier(form, action,mode, flag)
{
  blnVerification = flag;
  form.action.value = action;
  form.mode.value = mode;
//if (form.action.value=='suite') {
    //	}

}

//YNI ajout des tests sur le numero expense
function ValiderEcran(form)
{
   if (blnVerification) {
	if ( !VerifFormat(null) ) return false;
	if ( (form.numexpense.value == "")){
	
		if (!ChampObligatoire(form.socfact, "un code société")) return false;
		if (!ChampObligatoire(form.numfact, "un numéro de facturation")) return false;
		if (!form.typfact[0].checked && !form.typfact[1].checked) {
		   alert("Choisissez un type de facture");
		   return false;
		}
		if (!ChampObligatoire(form.datfact, "une date de facturation")) return false;
	
		if ( (form.numcont.value != "") && (form.rnom.value != "") ) {
		   alert("Saisir soit le N° de contrat, soit le nom de la ressource");
		   return false;
		}
		//if ( (form.numcont.value == "") && (form.rnom.value == "") ) {
		  // alert("Saisir un N° de contrat ou un nom de ressource");
		   //return false;
		//}
		form.keyList0.value = form.socfact.value;
		form.keyList1.value =(form.typfact[0].checked)?form.typfact[0].value:form.typfact[1].value;
		form.keyList2.value = form.datfact.value;
		form.keyList3.value = form.numfact.value;
		form.keyList4.value = form.socfact.value;		// SOCCONT
		form.keyList5.value = "";				// CAV
		form.keyList6.value = form.numcont.value;		// NUMCONT
		form.keyList7.value = form.rnom.value;
	}
	/*
	else{
		if ( (form.numexpense.value != "") && (form.numfact.value != "") ) {
		   alert("Saisir soit le N° expense, soit le N° de la facture");
		   return false;
		}
		
	  }*/
	}
  
   return true;
}


function rechercheSocieteID(){
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=socfact&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}  


function nextFocusLoupeSociete(){
	document.forms[0].numcont.focus();
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

function nextFocusNumfact(){
	document.forms[0].datfact.focus();
}	

function VerifFormat_1(fieldName){

    if (fieldName == "numexpense") {
	document.forms[0].socfact.value = "";
	document.forms[0].numcont.value = "";
	document.forms[0].rnom.value = "";
	document.forms[0].numfact.value = "";
	document.forms[0].datfact.value = "";
	
   }
   else{
   	document.forms[0].numexpense.value = "";
   }

   //return true;
   return VerifFormat(fieldName);
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Factures - 
            Gestion <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/facture"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
				  		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
				  		<html:hidden property="action"/> 
                  		<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
             			<html:hidden property="keyList0"/> 
                    	<html:hidden property="keyList1"/>
						<html:hidden property="keyList2"/> 
                    	<html:hidden property="keyList3"/>
						<html:hidden property="keyList4"/> 
                    	<html:hidden property="keyList5"/>
						<html:hidden property="keyList6"/> 
                    	<html:hidden property="keyList7"/>
				        <html:hidden property="test" value=""/>
				        <html:hidden property="flaglock"/> 
						<html:hidden property="choixfsc" value="N"/>
						<html:hidden property="cav"/>
						<html:hidden property="soclib"/>


                    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr>
                        <td>&nbsp;</td>
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="lib"><b>Code société :</b></td>
                        <td colspan=2> 
                      		<html:text property="socfact" styleClass="input" size="4" maxlength="4" onchange="VerifFormat_1();"/>
                      		&nbsp;&nbsp;<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusLoupeSociete();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société" align="absbottom"></a>
					      </td>
                      </tr>
                      <tr> 
                        <td class="lib">N° de contrat :</td>
                        <td colspan=2> 
                          <html:text property="numcont" styleClass="input" size="30" maxlength="27" onchange="VerifFormat_1(this.name);"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Nom de la ressource :</td>
                        <td colspan=2> 
                          <html:text property="rnom" styleClass="input" size="15" maxlength="15" onchange="VerifFormat_1(this.name);"/>
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
                        <td class="lib"><b>N° de facture :</b></td>
                        <td colspan=2> 
                          <html:text property="numfact" styleClass="input" size="15" maxlength="15" onchange="VerifFormat_1(this.name);"/>
                          &nbsp;&nbsp;<a href="javascript:rechercheFacture();" onFocus="javascript:nextFocusNumfact();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Facture" title="Rechercher Facture" align="absbottom"></a>            
                        </td>
                      </tr>
                      
                      <tr> 
                        <td class="lib"><b>Date de facture :</b></td>
                        <td colspan=2> 
                          <html:text property="datfact" styleClass="input" size="10" maxlength="10" onchange="VerifFormat_1(this.name);"/>
                        </td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan =3 align="center"><b>ou</b></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="lib">N° Expense :</td>
                        <td colspan=2> 
                          <html:text property="numexpense" styleClass="input" size="8" maxlength="8" onchange="VerifFormat_1(this.name);"/>
                        </td>
                      </tr>
                      
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
    
                    </table>




<table  border="0" width=63%>
                      <tr> 
                        <td align="right" width=15%> <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', 'insert', true);"/> 
                        </td>
                        <td align="center" width="7%">&nbsp;</td>
                        <td align="center" width=15%> <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', 'update', true);"/> 
                        </td>
                        <td align="left" width=7%></td>
                        <td align="center" width=15%> <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', 'delete',true);"/> 
                        </td>
                        <td align="left" width="7%">&nbsp;</td>
                        <td align="left" width=15%> <html:submit property="boutonLignes" value="Lignes" styleClass="input" onclick="Verifier(this.form, 'suite', 'lignes', true);"/> 
                        </td>
                      </tr>
                    </table>
<!-- #EndEditable --></div>
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
