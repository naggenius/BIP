<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="calendrierForm" scope="request" class="com.socgen.bip.form.CalendrierForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fMajcalendAd.jsp"/> 
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


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="calendrierForm"  property="msgErreur" />";
   var Focus = "<bean:write name="calendrierForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
	   document.forms[0].cpremens1.focus();
    }
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}
function ValiderEcran(form)
{
  if (blnVerification == true) {

	if (!ChampObligatoire(form.cpremens1, "la date de première pré-mensuelle")) return false;
	if (!ChampObligatoire(form.cpremens2, "la date de deuxième pré-mensuelle")) return false;
	if (!ChampObligatoire(form.cmensuelle, "la date de mensuelle")) return false;
	if (!ChampObligatoire(form.ccloture, "la date de clôture")) return false;
	if (!ChampObligatoire(form.cafin, "la date de fin de mois")) return false;
	if (!ChampObligatoire(form.cjours, "le nombre de jours")) return false;
	if (!ChampObligatoire(form.cnbjourssg, "le nombre de jours SG")) return false;
	if (!ChampObligatoire(form.cnbjoursssii, "le nombre de jours SSII")) return false;

	if (!ChampObligatoire(form.debutBlocageEbis, "la date de début de blocage EBIS")) return false;
	if (!ChampObligatoire(form.dateDeblocageFacturesEbis, "la date de déblocage EBIS")) return false;
	
	if ( form.debutBlocageEbis.value != ""  && form.dateDeblocageFacturesEbis != "" ) {
		if ( compareDate(form.dateDeblocageFacturesEbis, form.debutBlocageEbis ) == 1 
		     || compareDate(form.dateDeblocageFacturesEbis, form.debutBlocageEbis ) == 0 ) { 
			alert('La date de début de blocage doit être strictement inférieur à la date de déblocage ! ');
			return false;
		}
	}
	
	if (!confirm("Voulez-vous modifier ce mois ?")) return false;
	
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise 
            &agrave; jour du calendrier<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/calendrier"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            	<html:hidden property="action"/>
				<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
				<html:hidden property="flaglock"/>
              <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Mois : </b></td>
                  <td><b><bean:write name="calendrierForm" property="calanmois"/></b>
  				  	<html:hidden property="calanmois"/>
                   </td>
                </tr>
                <tr> 
                  <td class=lib><b>Date de la première pré-mensuelle :</b></td>
                  <td>
                    <html:text property="cpremens1" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa')"/>
                  
                  </td>
                </tr>
                <tr>
                  <td class=lib><b>Date de la deuxi&egrave;me pr&eacute;-mensuelle 
                    : </b></td>
                  <td><html:text property="cpremens2" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa')"/>
                 </td>
                </tr>
                <tr>
                  <td class=lib><b>Date de la mensuelle :</b></td>
                  <td><html:text property="cmensuelle" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa')"/>
                  </td>
                </tr>
                <tr>
                  <td class=lib><b>Date de la cl&ocirc;ture :</b></td>
                  <td><html:text property="ccloture" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa')"/>
                  </td>
                </tr>
                <tr>
                  <td class=lib><b>Dernier jour du mois :</b></td>
                  <td><html:text property="cafin" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa')"/>
                  </td>
                </tr>
                <tr>
                  <td class=lib><b>Nombre de jours ouvr&eacute;s du mois :</b></td>
                  <td><html:text property="cjours" styleClass="input" size="4" maxlength="4" onchange="return VerifierNum(this,3,1)"/>
                  </td>    
                </tr>
                <tr>
                  <td class=lib><b>Nombre de jours travaill&eacute;s SG :</b></td>
                  <td><html:text property="cnbjourssg" styleClass="input" size="4" maxlength="4" onchange="return VerifierNum(this,3,1)"/>
                  </td>
                </tr>
                <tr>
                  <td class=lib><b>Nombre de jours travaill&eacute;s SSII :</b></td>
                  <td><html:text property="cnbjoursssii" styleClass="input" size="4" maxlength="4" onchange="return VerifierNum(this,3,1)"/>
                  </td>
                </tr>
                
                <tr>
                  <td class=lib><b>Pourcentage th&eacute;orique du mois :</b></td>
                  <td><html:text property="theorique" styleClass="input" size="6" maxlength="6" onchange="return VerifierNum(this,5,2)"/>
                  </td>
                </tr>
                
                <tr>
                  <td class=lib><b>Date début blocage des factures Expense :</b></td>
                  <td><html:text property="debutBlocageEbis" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa')"/>
                  </td>
                </tr>
                             
                <tr>
                  <td class=lib><b>Date de déblocage des factures Expense :</b></td>
                  <td><html:text property="dateDeblocageFacturesEbis" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa')"/>
                  </td>
                </tr>
				  
				<tr>
				  <td>&nbsp;</td>
				</tr>   
				<tr>
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
Integer id_webo_page = new Integer("1061"); 
com.socgen.bip.commun.form.AutomateForm formWebo = calendrierForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
