<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="arbitrageForm" scope="request" class="com.socgen.bip.form.ArbitrageForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/fBudgMassMEAd.jsp"/> 
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
var tabVerif = new Object();
var anneeCourante = '<bip:value champ="to_char(datdebex, 'YYYY')" table="datdebex" clause1="1" clause2="1" />';

function MessageInitial()
{
   
    var Message="<bean:write filter="false"  name="arbitrageForm"  property="msgErreur" />";
    var Focus = "<bean:write name="arbitrageForm"  property="focus" />";
    if (Message != "") {
      alert(Message);
   }
   document.forms[0].annee.value = anneeCourante;
 }

function VerifArbitrage(form, action,flag) {
	form.action.value = action;	
}

function ValiderEcran(form) {

	MajOrdreTri(form);
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

}

function SaisiePid()
{
document.forms[0].codsg.value="";
document.forms[0].dpcode.value="";
document.forms[0].icpi.value="";
document.forms[0].metier.value="";
}

function SaisieCritete()
{
document.forms[0].pid.value="";
}

</script>
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
          <td height="20" class="TitrePage">Outil d'arbitrage des JH</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <html:form action="/arbitrage" onsubmit="return ValiderEcran(this);">
            <div align="center">
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<input type="hidden" name="annee" >
            <input type="hidden" name="action" value="refresh">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td align=center >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Dossier Projet :</b></td>
                  <td> 
                  <html:text property="dpcode" styleClass="input" size="5" maxlength="5" onChange="VerifierNum(this,5,0); SaisieCritete();"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Projet :</b></td>
                  <td> 
                  <html:text property="icpi" styleClass="input" size="20" maxlength="60" onChange="SaisieCritete();"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Metier :</b></td>
                  <td> 
                  <html:text property="metier" styleClass="input" size="20" maxlength="28" onChange="SaisieCritete();"/>
                  </td>
                </tr>
                <tr> 
                 <td align=center class="lib"><b>Code D&eacute;partement/P&ocirc;le/Groupe : </b></td>
                  <td>
                  <html:text property="codsg" styleClass="input" size="25" maxlength="80" onChange="SaisieCritete();"/>
				  </td>
                </tr>
                <tr>
                <td>&nbsp;</td> 
                <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Ligne Bip :</b></td>
                  <td> 
                  <html:text property="pid" styleClass="input" size="40" maxlength="500" onChange="SaisiePid();"/>
                  </td>
                </tr>
                <tr>
                <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Nombre de lignes par page :</b></td>
                  <td> 
               		<html:select property="blocksize" size="1" styleClass="input">
							<option value="10">10</option>
							<option value="20">20</option>
							<option value="30">30</option>
							<option value="40">40</option>
							<option value="50">50</option>
							<option value="60">60</option>
							<option value="70">70</option>
							<option value="80">80</option>
							<option value="90">90</option>
							<option value="100">100</option>
					</html:select>
			       </td>
                </tr>
                <tr>
						<td colspan=1 class="lib"><b>Ordre de tri par :</b></td>
						<td colspan=1><input type=radio name="ordre_tri" value="1" checked>Code dossier projet</td>
				</tr>
				<tr>		
						<td></td>
						<td colspan=1><input type=radio name="ordre_tri" value="2" >Code projet</td>
				</tr>
                
                <tr>
                	    <td></td>
                	    <td colspan=1><input type=radio name="ordre_tri" value="3" >Code ligne BIP</td>
                </tr>
                <tr>
                	    <td></td>
                	    <td colspan=1><input type=radio name="ordre_tri" value="4" >Ecarts</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2 align=center>Les champs sont multi-valeur: <br>le séparateur est le point virgule (;)</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
              </div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td align="center" width="25%"> 
                	<html:submit property="boutonValider" value="Arbitrage" styleClass="input" onclick="VerifArbitrage(this.form, 'modifier', true);"/> 
                </td>
                </html:form>  
          
              </tr>
            </table>

          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
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
