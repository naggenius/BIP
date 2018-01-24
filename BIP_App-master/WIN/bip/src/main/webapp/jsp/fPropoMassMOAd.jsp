<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="budgMassForm" scope="request" class="com.socgen.bip.form.BudgMassForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fPropoMassMOAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
var anneeCourante = '<bip:value champ="to_char(datdebex, 'YYYY')" table="datdebex" clause1="1" clause2="1" />';
var anneePlusUn = parseInt(anneeCourante) + 1;
var moisCourant = '<bip:value champ="to_number(to_char(sysdate, 'MM'))" table="dual" clause1="1" clause2="1" />';
	

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="budgMassForm"  property="msgErreur" />";
   var Focus = "<bean:write name="budgMassForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	document.forms[0].clicode.focus();
   }
   if (moisCourant >= 7) {
         document.forms[0].annee.value = anneePlusUn;
   }
   else
   {
   document.forms[0].annee.value = anneeCourante;
   }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
  
  MajOrdreTri(form);
   
}

function ValiderEcran(form)
{
   if (blnVerification) {
	
	if (!ChampObligatoire(form.clicode, "un code maîtrise d'ouvrage")) return false;
	if (!ChampObligatoire(form.annee, "une année de proposition de budget")) return false;
	
   }
   return true;
}

function MajOrdreTri(form)
{
	form.ordre_tri.value = "1";
	if (document.forms[0].ordre_tri[0].checked)
	{
	form.ordre_tri.value = "1";
	}
	if (document.forms[0].ordre_tri[1].checked)
	{
	form.ordre_tri.value = "2";
	}
	if (document.forms[0].ordre_tri[2].checked)
	{
	form.ordre_tri.value = "3";
	}
	if (document.forms[0].ordre_tri[3].checked)
	{
	form.ordre_tri.value = "4";
	}
	if (document.forms[0].ordre_tri[4].checked)
	{
	form.ordre_tri.value = "5";
	}
}

function rechercheID(){
	window.open("/recupIdMo.do?action=initialiser&nomChampDestinataire=clicode&windowTitle=Recherche Code Client&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
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
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Saisie en masse des proposés pour un code client<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/propoMassMO"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td align=center height="20">&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td class="texte"><b>Code MO : </b></td>
                  <td class="texte"> 
                  <html:text property="clicode" styleClass="input" size="6" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
				  &nbsp;<a href="javascript:rechercheID();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Client" title="Rechercher Code Client" style="vertical-align : middle;"></a>
                  </td>
                </tr>
                <tr align="left"> 
                  <td class="texte"><b>Ann&eacute;e de proposition :</b></td>
                  <td> 
                    <html:text property="annee" styleClass="input" size="4" maxlength="4" onchange="return VerifierDate(this,'aaaa');"/>
      
                  </td>
                </tr>
                
                <tr align="left">
						<td colspan=1 class="texte"><b>Ordre de tri par :</b></td>
						<td colspan=1 class="texte"><input type=radio name="ordre_tri" value="1">Code du client</td>
				</tr>
				<tr align="left">		
						<td></td>
						<td class="texte" colspan=1><input type=radio name="ordre_tri" value="2" checked>Code de la ligne BIP</td>
				</tr>
                
                <tr align="left">
                	    <td></td>
                	    <td class="texte" colspan=1><input type=radio name="ordre_tri" value="3" >Libell&eacute; de la ligne BIP</td>
                </tr>
                
                 <tr align="left">
                	    <td></td>
                	    <td class="texte" colspan=1><input type=radio name="ordre_tri" value="4" >Libell&eacute; de l'application et Type de la ligne BIP</td>
                </tr>
                
                 <tr align="left">
                	    <td></td>
                	    <td class="texte" colspan=1><input type=radio name="ordre_tri" value="5" >Libell&eacute; de l'application et Code de la ligne BIP</td>
                </tr>
                
                
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="15" align=center>&nbsp;</td>
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
                <td align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/> 
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
