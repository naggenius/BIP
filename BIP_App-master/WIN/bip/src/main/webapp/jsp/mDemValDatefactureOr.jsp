<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="listeDemFactAttForm" scope="request" class="com.socgen.bip.form.ListeDemFactAttForm" />
<html:html locale="true">
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/lValFav.do"/>
<%
  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("modeReglt");
  java.util.ArrayList list2 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("statut_CS2"); 
  
  pageContext.setAttribute("choixModeReglt", list1);
  pageContext.setAttribute("choixStatutCS2", list2);
  
%>
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

   listeDemFactAttForm.setNbreFacture(listeDemFactAttForm.getListeDemande().size());
%>
var pageAide  = "<%= sPageAide %>";


function MessageInitial()
{
	var i=0;
	while (i<nbFacture) {
		tabVerif["faccsec"+i]    = "VerifierDate2(document.forms[0].faccsec["+i+"],'jjmmaaaa')";
		tabVerif["fregcompta"+i] = "VerifierDate2(document.forms[0].fregcompta["+i+"],'jjmmaaaa')";
		tabVerif["fenvsec"+i]    = "VerifierDate2(document.forms[0].fenvsec["+i+"],'jjmmaaaa')";
		tabVerif["fordrecheq"+i] = "VerifierAlphanum(document.forms[0].fordrecheq["+i+"])";
		tabVerif["fnom"+i]       = "VerifierAlphanum(document.forms[0].fnom["+i+"])";
		tabVerif["fadresse1"+i]  = "VerifierAlphanum(document.forms[0].fadresse1["+i+"])";
		tabVerif["fadresse2"+i]  = "VerifierAlphanum(document.forms[0].fadresse2["+i+"])";
		tabVerif["fadresse3"+i]  = "VerifierAlphanum(document.forms[0].fadresse3["+i+"])";
		tabVerif["fcodepost"+i]  = "VerifierNum(document.forms[0].fcodepost["+i+"],5,0)";
		tabVerif["fburdistr"+i]  = "VerifierAlphanum(document.forms[0].fburdistr["+i+"])";
		i=i+1;
	}

   	var Message="<bean:write filter="false"  name="listeDemFactAttForm"  property="msgErreur" />";
   	var Focus = "<bean:write name="listeDemFactAttForm"  property="focus" />";
   	if (Message != "") {
      	alert(Message);
   	}
   	if (Focus != "") {
   		(eval( "document.forms[0]."+Focus+"[0]" )).focus();
   	} else {
   		document.forms[0].faccsec[0].focus();
    }

}

function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
}

function ValiderEcran(form) {
	if (blnVerification==true) {
		var i=0;
		while ( i<nbFacture ) {
			if ( !VerifFormat(null) ) return false;
			//si date accord pôle entré alors envoi rglt compta obligatoire et statut CS2= AE ou SE
			if (form.faccsec[i].value.length > 0) {
				if (!ChampObligatoire(form.fregcompta[i], "la date d'envoi au règlement comptable")) return false;
				if ((form.fstatut2[i].value!="AE")&&(form.fstatut2[i].value!="SE")) {
					alert("Le statut CS2 doit être égal à AE ou SE");
					return false; 
				}
		   	}
		   	//si annulation date accord pôle entré et envoi rglt compta obligatoires et statut CS2= AE ou SE
		   	if (form.fmodreglt[i].value=="8") {
		 		if (!ChampObligatoire(form.faccsec[i], "la date accord pôle")) return false;
				if (!ChampObligatoire(form.fregcompta[i], "la date d'envoi au règlement comptable")) return false;
				if ((form.fstatut2[i].value!="AE")&&(form.fstatut2[i].value!="SE")) {
					alert("Le statut CS2 doit être égal à AE ou SE");
					return false; 
				}
			}
		
			if (form.fstatut2[i].value=="  ") {
				if (form.fregcompta[i].value!="") {
				alert("La date d'envoi au règlement comptable ne doit pas être renseignée");
				form.fregcompta[i].value="";
				return false;
				}
			}
			
			i=i+1;
		}
	
		//if (!confirm("Voulez-vous modifier les dates de suivi ?")) return false;
   	}
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
          <td height="20" class="TitrePage">Modifier les dates de suivi d'une facture</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
<html:form action="/lValFav"  onsubmit="return ValiderEcran(this);">
            <div align="center"><!-- #BeginEditable "contenu" -->
           	<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="flaglock"/> 
			<html:hidden property="mois"/>
			<html:hidden property="statut"/>
			<html:hidden property="iddem"/>
           	<html:hidden property="nbreFacture"/> 
           	
           	
              <table border=0 cellspacing=2 cellpadding=2 class="TableBLeu">
<logic:iterate id="demande" name="listeDemFactAttForm" property="listeDemande" type="com.socgen.bip.metier.DemandeValFactu" indexId="it">
                <tr> 
                  <td colspan=6>&nbsp;</td>
                </tr>
                
                <tr> 
                  <td class="lib">Soci&eacute;t&eacute; :</td>
                  <td colspan=4>
				    <bean:write name="demande"  property="socfact" /> 
                    <html:hidden name="demande" property="socfact"/> - 
					<bean:write name="demande"  property="soclib" /> 
                    <html:hidden name="demande" property="soclib"/>
                  </td>
                </tr>
                
                <tr> 
                  <td class="lib" >N° de facture :</td>
                  <td ><bean:write name="demande"  property="numfact" /> 
                    <html:hidden name="demande" property="numfact"/>
                  </td>
                  <td class="lib" >Date de facture :</td>
                  <td ><bean:write name="demande"  property="datfact" /> 
                    <html:hidden name="demande" property="datfact"/>
                    </td>
                    <td class="lib"> Type :</td>
                  <td ><bean:write name="demande"  property="typfact" /> 
                    <html:hidden name="demande" property="typfact"/>
                  </td>
                </tr>
                
                <tr> 
                  <td class="lib" >Envoi enreg. compta :</td>
                  <td ><bean:write name="demande"  property="fenrcompta"/> 
                  	<html:hidden name="demande" property="fenrcompta"/>
                  </td>
				  <td class="lib" ><b>Accord du pôle :</b></td>
				   <td >
						<input type="text" name="faccsec" value="<bean:write name="demande" property="faccsec" />" class="input" size="10" maxlength="10" onchange="return VerifFormat(this.name+<bean:write name="it" />);"/> 					
					</td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Envoi r&egrave;glem. compta :</b></td>
                  <td >
						<input type="text" name="fregcompta" value="<bean:write name="demande" property="fregcompta" />" class="input" size="10" maxlength="10" onchange="return VerifFormat(this.name+<bean:write name="it" />);"/> 					
                  </td>
				<td class="lib">R&egrave;glem. demand&eacute; :</td>
				<td >
						<input type="text" name="fenvsec" value="<bean:write name="demande" property="fenvsec" />" class="input" size="10" maxlength="10" onchange="return VerifFormat(this.name+<bean:write name="it" />);"/> 					
                  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Statut d'envoi CS2 :</b></td>
                  <td> <html:select name="demande" property="fstatut2" styleClass="input"> 
   						<html:options collection="choixStatutCS2" property="cle" labelProperty="libelle" />
						</html:select>
                  </td>
                  <td class="lib" ><b>Mode de r&egrave;glem. :</b></td>
                  <td ><html:select name="demande" property="fmodreglt" styleClass="input"> 
   						<html:options collection="choixModeReglt" property="cle" labelProperty="libelle" />
						</html:select>
                  </td>
                </tr>
				
                <tr> 
                  <td class="lib" >Ordre de ch&egrave;que :</td>
                  <td colspan="5">
					<input type="text" name="fordrecheq" value="<bean:write name="demande" property="fordrecheq" />" class="input" size="32" maxlength="32" onchange="return VerifFormat(this.name+<bean:write name="it" />);"/> 					
				  </td>
				  </tr>
				<tr>
                  <td class="lib" > Nom du b&eacute;n&eacute;ficiaire :</td>
                  <td colspan="5">
					<input type="text" name="fnom" value="<bean:write name="demande" property="fnom" />" class="input" size="30" maxlength="30" onchange="return VerifFormat(this.name+<bean:write name="it" />);"/> 					
				  </td>
                </tr>
				
				<tr> 
                  <td class="lib" >Adresse 1 :</td>
                  <td colspan="5">
					<input type="text" name="fadresse1" value="<bean:write name="demande" property="fadresse1" />" class="input" size="32" maxlength="32" onchange="return VerifFormat(this.name+<bean:write name="it" />);"/> 					
				  </td>
				  </tr>
				  <tr>
                  <td class="lib" >Adresse 2 :</td>
                  <td colspan="5">
					<input type="text" name="fadresse2" value="<bean:write name="demande" property="fadresse2" />" class="input" size="32" maxlength="32" onchange="return VerifFormat(this.name+<bean:write name="it" />);"/> 					
				  </td>
                </tr>
				<tr>
                  <td class="lib" >Adresse 3 :</td>
                  <td colspan="5">
					<input type="text" name="fadresse3" value="<bean:write name="demande" property="fadresse3" />" class="input" size="32" maxlength="32" onchange="return VerifFormat(this.name+<bean:write name="it" />);"/> 					
				  </td>
                </tr>
				<tr>
				<td class="lib" >Code postal :</td>
				<td >
					<input type="text" name="fcodepost" value="<bean:write name="demande" property="fcodepost" />" class="input" size="5" maxlength="5" onchange="return VerifFormat(this.name+<bean:write name="it" />);"/> 					
                </td>
				<td class="lib" >Bureau distrib. :&nbsp;</td>
				<td colspan=2>
					<input type="text" name="fburdistr" value="<bean:write name="demande" property="fburdistr" />" class="input" size="16" maxlength="16" onchange="return VerifFormat(this.name+<bean:write name="it" />);"/> 					
                </td>
				</tr>
				<tr> 
                  <td colspan=6>&nbsp;</td>
                </tr>
</logic:iterate>
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
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'majdate', 'update',true);"/> 
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
Integer id_webo_page = new Integer("3010"); 
com.socgen.bip.commun.form.AutomateForm formWebo = listeDemFactAttForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
