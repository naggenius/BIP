 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneFactureForm" scope="request" class="com.socgen.bip.form.LigneFactureForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bFactureOr.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var blnVerifFormat  = true;
var tabVerif        = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
  var Message="<bean:write filter="false"  name="ligneFactureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ligneFactureForm"  property="focus" />";
   
   tabVerif["lmontht"]    = "VerifierNum2(document.forms[0].lmontht,12,2)";
   tabVerif["lmoisprest"] = "VerifierDate2(document.forms[0].lmoisprest,'mmaaaa')";
   tabVerif["lcodcompta"] = "VerifierAlphaMax(document.forms[0].lcodcompta)";
   if (Message != "") {
      alert(Message);
   }
   if ( document.forms[0].mode.value != "delete")   {
	if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].lmontht.focus();
   }
	}


  	var mail2send = "<bean:write name="ligneFactureForm"  property="mailToSend" />";
	if (mail2send!=null && mail2send.length>0 && mail2send.length<2000) {
    	document.location.href = mail2send;
 	}

}

function Verifier(form, action,mode, flag)
{
  blnVerification = flag;
  
  //si rapprochement
  if (action=="rapprochement") {
  		form.rapprochement.value="oui";
  }
  else
  		form.rapprochement.value="non";
  if (action!="annuler")
  	form.action.value = "valider";
  else
  	form.action.value = action;
}

function ValiderEcran(form)
{
   if (blnVerification==true) {
	if ( !VerifFormat(null) ) return false;
	if (!ChampObligatoire(form.lmontht, "le montant HT")) return false;
	if (!ChampObligatoire(form.lmoisprest, "le mois/année de la prestation")) return false;
	if (form.lcodcompta){
		if (form.lcodcompta.value == 0) {
			alert("Le code comptable ne peut être égal à 0");
			form.lcodcompta.focus();
			return false;
		}
		if (!ChampObligatoire(form.lcodcompta, "le code comptable")) return false;
	}
	if (form.mode.value=="delete") {
	   	if (!confirm("Voulez-vous supprimer cette ligne de facture ?")) return false;
	}
	
	}

	if (form.rapprochement.value == "oui") form.boutonRapprochement.disabled = true;
   return true;
}

function rechercheCodeComptable(){
	window.open("/recupCodeCompta.do?action=initialiser&nomChampDestinataire=lcodcompta&windowTitle=Recherche Code Comptable&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=600") ;
}  

function nextFocusLoupeCodeCompta(){
	<!-- document.forms[0].ccoutht.focus();-->
	return true;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="ligneFactureForm" property="titrePage"/>  
une ligne de facture<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/ligneFacture"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="titrePage"/>
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
		    	<html:hidden property="flaglock"/>
   			<html:hidden property="lnum"/>   
		    	<html:hidden property="fmontht"/>
   			<html:hidden property="ftva"/>
   			<input type="hidden" name="rapprochement" value="" >
 

                    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr>
                        <td colspan=4>&nbsp;</td>
                      </tr>
                    
                      <tr> 
                        <td class="lib">Code société :</td>
                        <td> <bean:write name="ligneFactureForm"  property="socfact" />
                    <html:hidden property="socfact"/>
                        </td>
                        <td>&nbsp;</td>
                        <td class="lib">Société :</td>
                        <td ><bean:write name="ligneFactureForm"  property="soclib" />
                    <html:hidden property="soclib"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">N° de contrat :</td>
                        <td><bean:write name="ligneFactureForm"  property="numcont" />
                    <html:hidden property="numcont"/>
                        </td>
                        <td>&nbsp;</td>
                        <td class="lib">N° d'avenant :</td>
                        <td><bean:write name="ligneFactureForm"  property="cav" />
                    <html:hidden property="cav"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">N° de facture :</td>
                        <td>
                          <bean:write name="ligneFactureForm"  property="numfact" />
                    <html:hidden property="numfact"/>
                        </td>
                        <td>&nbsp;</td>
                        <td class="lib">Type de facture :</td>
                        <td>
                          <bean:write name="ligneFactureForm"  property="typfact" />
                    <html:hidden property="typfact"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Date de facture :</td>
                        <td colspan=4><bean:write name="ligneFactureForm"  property="datfact" />
                    <html:hidden property="datfact"/>
                        </td>
                      </tr>
                    
                      <tr> 
                        <td class="lib">Identifiant :</td>
                        <td><bean:write name="ligneFactureForm"  property="ident" />
                    <html:hidden property="ident"/>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib">Nom :</td>
                        <td><bean:write name="ligneFactureForm"  property="rnom" />
                    <html:hidden property="rnom"/>
                        </td>
                      <td>&nbsp;</td>
                        <td class="lib">Prénom :</td>
                        <td><bean:write name="ligneFactureForm"  property="rprenom" />
                    <html:hidden property="rprenom"/>
                        </td>
                      </tr>
                       <tr>
                       <%
                       String valRadio = ligneFactureForm.getTypdpg();
                       String radioR="";
                       String radioC="";
                       if(valRadio==null)
                       {
                    	    radioR="";
                            radioC="checked";
                       }
                       
                       if(valRadio.equals("R"))radioR="checked";
                       else if(valRadio.equals("C"))radioC="checked";
                       %>
							<td class="lib"><b>Centre d'activité :</b></td>
							<td><input type="radio" name="typdpg" value="C" <%= radioC%> >Contrat</td>
							<td><input type="radio" name="typdpg" value="R" <%= radioR%> >Ressource</td>
							 <html:hidden property="typdpg"/>
   						</tr>
                      </table>
                    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr>
				<logic:notEqual parameter="mode" value="delete"> 
                        <td class="lib"><b>Montant HT :</b></td>
                        <td>
				<html:text property="lmontht" styleClass="input" size="13" maxlength="13" onchange="return VerifFormat(this.name);"/>
                        </td>
				</logic:notEqual>
				<logic:equal parameter="mode" value="delete">
				<td class="lib">Montant HT :</td>
                        <td>
 				<bean:write name="ligneFactureForm"  property="lmontht" />
                    <html:hidden property="lmontht"/>
                        </td>
				</logic:equal>
                      </tr>
                      <tr> 
				<logic:notEqual parameter="mode" value="delete">
                        <td class="lib"><b>Mois/année de prestation :</b>&nbsp;</td>
                        <td>
			<html:text property="lmoisprest" styleClass="input" size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>
                        </td>
				</logic:notEqual>
				
				<logic:equal parameter="mode" value="delete">
				<td class="lib">Mois/année de prestation :&nbsp;</td>
                        <td>
				<bean:write name="ligneFactureForm"  property="lmoisprest" />
                    	<html:hidden property="lmoisprest"/>
                        </td>
				</logic:equal>
                       </tr>
                      
				<tr> 
				<logic:notEqual parameter="mode" value="delete">
                        <td class="lib"><b>Code comptable :</b></td>
                        <td>
			  <html:text property="lcodcompta" styleClass="input" size="16" maxlength="11" onchange="return VerifFormat(this.name);"/>	
                            &nbsp;&nbsp;<a href="javascript:rechercheCodeComptable();" onFocus="javascript:nextFocusLoupeCodeCompta();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Comptable" title="Rechercher Code Comptable"></a>
                                                  
                          &nbsp; </td>
				</logic:notEqual>
				<logic:equal parameter="mode" value="delete">
				<td class="lib">Code comptable :</td>
                        <td>
				<bean:write name="ligneFactureForm"  property="lcodcompta" />
                    	<html:hidden property="lcodcompta"/>
                        </td>
				</logic:equal>
                       </tr>
                      <tr>
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr>
                        <td colspan=2>&nbsp;</td>
                      </tr>
            
                    </table>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="33%" align="right"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider',this.form.mode.value,true);"/> 
                        </td>
				<td width="33%" align="center">
				<logic:notEqual parameter="mode" value="delete">
 <html:submit property="boutonRapprochement" value="Rapprochement" styleClass="input" onclick="Verifier(this.form, 'rapprochement',this.form.mode.value, true);"/> 
                       </logic:notEqual>
				</td>
				<td width="33%" align="left"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
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
