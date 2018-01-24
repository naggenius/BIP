<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="dateSuiviForm" scope="request" class="com.socgen.bip.form.DateSuiviForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fDatesuiviOr.jsp"/>
<%  
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
%> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var blnVerifFormat  = true;
var tabVerif        = new Object();

function MessageInitial()
{
	tabVerif["cdatrpol"] = "VerifierDate2(document.forms[0].cdatrpol,'jjmmaaaa')";
   tabVerif["cdatdir"]  = "VerifierDate2(document.forms[0].cdatdir,'jjmmaaaa')";

   var Message="<bean:write filter="false"  name="dateSuiviForm"  property="msgErreur" />";
   var Focus = "<bean:write name="dateSuiviForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
	   document.forms[0].cdatrpol.focus();
    }
}

function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = "update";
}

function ValiderEcran(form)
{
   if (blnVerification) {
	if ( !VerifFormat(null) ) return false;
	if (!ChampObligatoire(form.cdatrpol, "la date d'envoi au pôle")) return false;
	if (!ChampObligatoire(form.cdatdir, "la date de retour au pôle")) return false;
	if (!confirm("Voulez-vous modifier les dates de suivi de ce contrat ?")) return false;
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
            les dates de suivi d'un contrat<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/dateSuivi"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<html:hidden property="action"/>
			 <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			 <html:hidden property="flaglock"/> 
              <table border=0 cellspacing=2 cellpadding=2 class="TableBLeu">
                <tr> 
                  <td colspan=4>&nbsp;</td>
                </tr>
                               
                <tr> 
                  <td class="lib">Code société - SIREN :</td>
                  <td >
				  <bean:write name="dateSuiviForm"  property="soccont" /> - 
				  <bean:write name="dateSuiviForm"  property="siren" /> 
                    <html:hidden property="soccont"/>
                  </td>
             
                  <td class="lib">Société :</td>
                  <td><bean:write name="dateSuiviForm"  property="soclib" /> 
                    <html:hidden property="soclib"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">N° de contrat :</td>
                  <td><bean:write name="dateSuiviForm"  property="numcont" /> 
                    <html:hidden property="numcont"/>
                  </td>
                  <td class="lib">N° d'avenant :</td>
                  <td><bean:write name="dateSuiviForm"  property="cav" /> 
                    <html:hidden property="cav"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Objet :</td>
                  <td colspan=3><bean:write name="dateSuiviForm"  property="cobjet1" /> 
                    <html:hidden property="cobjet1"/>
                    &nbsp; </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan=3><bean:write name="dateSuiviForm"  property="cobjet2" />
                    <html:hidden property="cobjet2"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Code DPG :</td>
                  <td colspan=3> <bean:write name="dateSuiviForm"  property="codsg" /> 
                    <html:hidden property="codsg"/> - <bean:write name="dateSuiviForm"  property="libdsg" /> 
                    <html:hidden property="libdsg"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Date de saisie :</td>
                  <td colspan=3><bean:write name="dateSuiviForm"  property="cdatsai" /> 
                    <html:hidden property="cdatsai"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Date de début :</td>
                  <td><bean:write name="dateSuiviForm"  property="cdatdeb" /> 
                    <html:hidden property="cdatdeb"/>
                  </td>
                  <td class="lib">Date de fin :</td>
                  <td><bean:write name="dateSuiviForm"  property="cdatfin" /> 
                    <html:hidden property="cdatfin"/>
                  </td>
                </tr>
              
                <tr> 
                  <td class="lib"><b>Date d'envoi au pôle :</b></td>
                  <td>
				  <html:text property="cdatrpol" styleClass="input" size="10" maxlength="10" onchange="return VerifFormat(this.name);"/> 
				  </td>
                  <td class="lib"><b>Date de retour du pôle :</b></td>
                  <td>
				  <html:text property="cdatdir" styleClass="input" size="10" maxlength="10" onchange="return VerifFormat(this.name);"/> 
				  </td>
                </tr>
                <tr> 
                  <td colspan=4>&nbsp;</td>
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
Integer id_webo_page = new Integer("3003"); 
com.socgen.bip.commun.form.AutomateForm formWebo = dateSuiviForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
