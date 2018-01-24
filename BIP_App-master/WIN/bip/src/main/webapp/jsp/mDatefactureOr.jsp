<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="dateFactureForm" scope="request" class="com.socgen.bip.form.DateFactureForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fDatefactureOr.jsp"/>
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
%>
var pageAide = "<%= sPageAide %>";
function MessageInitial()
{
	tabVerif["fenrcompta"] = "VerifierDate2(document.forms[0].fenrcompta,'jjmmaaaa')";
   tabVerif["faccsec"]    = "VerifierDate2(document.forms[0].faccsec,'jjmmaaaa')";
   tabVerif["fregcompta"] = "VerifierDate2(document.forms[0].fregcompta,'jjmmaaaa')";
   tabVerif["fenvsec"]    = "VerifierDate2(document.forms[0].fenvsec,'jjmmaaaa')";
   tabVerif["fordrecheq"] = "VerifierAlphanum(document.forms[0].fordrecheq)";
   tabVerif["fnom"]       = "VerifierAlphanum(document.forms[0].fnom)";
   tabVerif["fadresse1"]  = "VerifierAlphanum(document.forms[0].fadresse1)";
   tabVerif["fadresse2"]  = "VerifierAlphanum(document.forms[0].fadresse2)";
   tabVerif["fadresse3"]  = "VerifierAlphanum(document.forms[0].fadresse3)";
  tabVerif["fcodepost"]  = "VerifierNum(document.forms[0].fcodepost,5,0)";
   tabVerif["fburdistr"]  = "VerifierAlphanum(document.forms[0].fburdistr)";


   var Message="<bean:write filter="false"  name="dateFactureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="dateFactureForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "")
   {  if (Focus = "fmodreglt")
   document.forms[0].fmodreglt.focus();
	else
   (eval( "document.forms[0]."+Focus )).focus();
   }
    else {
	   document.forms[0].faccsec.focus();
    }
    
}

function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
}


function ValiderEcran(form)
{
   if (blnVerification==true) {
	if ( !VerifFormat(null) ) return false;
	if (!ChampObligatoire(form.fenrcompta, "la date d'envoi à l'enregistrement comptable")) return false;
	//si date accord pôle entré alors envoi rglt compta obligatoire et statut CS2= AE ou SE
	if (form.faccsec.value.length > 0) {
		if (!ChampObligatoire(form.fregcompta, "la date d'envoi au règlement comptable")) return false;
		if ((form.fstatut2.value!="AE")&&(form.fstatut2.value!="SE")) {
			alert("Le statut CS2 doit être égal à AE ou SE");
			return false; 
		}
   }
   //si annulation date accord pôle entré et envoi rglt compta obligatoires et statut CS2= AE ou SE
   if (form.fmodreglt.value=="8") {
 		if (!ChampObligatoire(form.faccsec, "la date accord pôle")) return false;
		if (!ChampObligatoire(form.fregcompta, "la date d'envoi au règlement comptable")) return false;
		if ((form.fstatut2.value!="AE")&&(form.fstatut2.value!="SE")) {
			alert("Le statut CS2 doit être égal à AE ou SE");
			return false; 
		}
	}
	
	if (form.fstatut2.value=="  ") {
		if (form.fregcompta.value!="") {
		alert("La date d'envoi au règlement comptable ne doit pas être renseignée");
		form.fregcompta.value="";
		return false;
		}
	}
	

	if (!confirm("Voulez-vous modifier les dates de suivi de cette facture ?")) return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Modifier 
            les dates de suivi d'une facture<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/dateFacture"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
           <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="action"/>
			 <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			 <html:hidden property="flaglock"/>
			 <html:hidden property="num_expense"/> 
              <table border=0 cellspacing=2 cellpadding=2 class="TableBLeu">
                <tr> 
                  <td colspan=6>&nbsp;</td>
                </tr>
                
                <tr> 
                  <td class="lib">Société - SIREN:</td>
                  <td colspan=4>
				  <bean:write name="dateFactureForm"  property="socfact" /> 
                    <html:hidden property="socfact"/>
					<bean:write name="dateFactureForm"  property="soclib" /> 
                    <html:hidden property="soclib"/> - 
				    <bean:write name="dateFactureForm"  property="siren" /> 
                  </td>
                </tr>
                
                <tr> 
                  <td class="lib" >N° de facture :</td>
                  <td ><bean:write name="dateFactureForm"  property="numfact" /> 
                    <html:hidden property="numfact"/>
                  </td>
                  <td class="lib" >Date de facture :</td>
                  <td ><bean:write name="dateFactureForm"  property="datfact" /> 
                    <html:hidden property="datfact"/>
                    </td>
                    <td class="lib"> Type :</td>
                  <td ><bean:write name="dateFactureForm"  property="typfact" /> 
                    <html:hidden property="typfact"/>
                  </td>
                </tr>
                
                <tr> 
                  <td class="lib" >Envoi enreg. compta :</td>
                  <td ><bean:write name="dateFactureForm"  property="fenrcompta"/> 
                  	<html:hidden property="fenrcompta"/>
                  </td>
				  <td class="lib" ><b>Accord du pôle :</b></td>
				   <td ><html:text property="faccsec" styleClass="input" size="10" maxlength="10" onchange="return VerifFormat(this.name);"/> 
					</td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Envoi règlem. compta :</b></td>
                  <td ><html:text property="fregcompta" styleClass="input" size="10" maxlength="10" onchange="return VerifFormat(this.name);"/> 
                  </td>
				<td class="lib">Règlem. demandé :</td>
				<td ><html:text property="fenvsec" styleClass="input" size="10" maxlength="10" onchange="return VerifFormat(this.name);"/> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Statut d'envoi CS2 :</b></td>
                  <td> <html:select property="fstatut2" styleClass="input"> 
   						<html:options collection="choixStatutCS2" property="cle" labelProperty="libelle" />
						</html:select>
                  </td>
                  <td class="lib" ><b>Mode de règlem. :</b></td>
                  <td ><html:select property="fmodreglt" styleClass="input"> 
   						<html:options collection="choixModeReglt" property="cle" labelProperty="libelle" />
						</html:select>
                  </td>
                </tr>
				
                <tr> 
                  <td class="lib" >Ordre de chèque :</td>
                  <td colspan="5">
				  <html:text property="fordrecheq" styleClass="input" size="32" maxlength="32" onchange="return VerifFormat(this.name);"/> 
				  </td>
				  </tr>
				<tr>
                  <td class="lib" > Nom du bénéficiaire :</td>
                  <td colspan="5">
				  <html:text property="fnom" styleClass="input" size="30" maxlength="30" onchange="return VerifFormat(this.name);"/> 
				  </td>
                </tr>
				
				<tr> 
                  <td class="lib" >Adresse 1 :</td>
                  <td colspan="5">
				  <html:text property="fadresse1" styleClass="input" size="32" maxlength="32" onchange="return VerifFormat(this.name);"/> 
				  </td>
				  </tr>
				  <tr>
                  <td class="lib" >Adresse 2 :</td>
                  <td colspan="5">
				  <html:text property="fadresse2" styleClass="input" size="32" maxlength="32" onchange="return VerifFormat(this.name);"/> 
				  </td>
                </tr>
				<tr>
                  <td class="lib" >Adresse 3 :</td>
                  <td colspan="5">
				  <html:text property="fadresse3" styleClass="input" size="32" maxlength="32" onchange="return VerifFormat(this.name);"/> 
				  </td>
                </tr>
				<tr>
				<td class="lib" >Code postal :</td>
				<td ><html:text property="fcodepost" styleClass="input" size="5" maxlength="5" onchange="return VerifFormat(this.name);"/> 
                </td>
				<td class="lib" >Bureau distrib. :&nbsp;</td>
				<td colspan=2><html:text property="fburdistr" styleClass="input" size="16" maxlength="16" onchange="return VerifFormat(this.name);"/> 
                </td>
				</tr>
				<tr> 
                  <td colspan=6>&nbsp;</td>
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
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', 'update',true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false); "/> 
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
Integer id_webo_page = new Integer("3005"); 
com.socgen.bip.commun.form.AutomateForm formWebo = dateFactureForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
