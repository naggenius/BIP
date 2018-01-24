 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="anomalieForm" scope="request" class="com.socgen.bip.form.AnomalieForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> <bip:VerifUser page="jsp/bAnomalieAd.jsp"/>
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
   var Message="<bean:write filter="false"  name="anomalieForm"  property="msgErreur" />";
   var Focus = "<bean:write name="anomalieForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
	   document.forms[0].validation1.focus();
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
	
	if ((form.validation1.value=="")&&(form.validation2.value!=""))
	{
		alert("Veuillez d'abord renseigner la première ligne");
		form.validation1.focus();
		form.validation2.value="";
		return false;
	}

      if (form.action.value == 'valider') {
	  form.mode.value="update";
	  form.keyList0.value=form.matricule.value;
		if (form.validation1.value=="")
		{
			if (!confirm("Voulez-vous annuler cette justification d'anomalie?")) return false;
		}
	  	 else {
         		if (!confirm("Voulez-vous justifier cette anomalie?")) return false;
			}
	 }
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Justifier 
            une anomalie du bouclage<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/anomalie"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
			<html:hidden property="keyList0"/>
			<html:hidden property="keyList1"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td colspan=6>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=6>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib">Nom :</td>
                  <td>
				  <bean:write name="anomalieForm"  property="nom" />
                    		<html:hidden property="nom"/>
                  </td>
                  <td colspan=2>&nbsp;</td>
                  <td class="lib"> Identifiant :</td>
                  <td colspan="2">
				  <bean:write name="anomalieForm"  property="matricule" />
                    		<html:hidden property="matricule"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Pr&eacute;nom :</td>
                  <td>
				  <bean:write name="anomalieForm"  property="prenom" />
                    		<html:hidden property="prenom"/>
                  </td>
                  <td colspan=2>&nbsp;</td>
                  <td class="lib"> Mois :</td>
                  <td colspan="2">
				  <bean:write name="anomalieForm"  property="mois" />
                    		<html:hidden property="mois"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Type d'absence :</td>
                  <td>
				  <bean:write name="anomalieForm"  property="typeabsence" />
                    		<html:hidden property="typeabsence"/>
                  </td>
                  <td colspan=2>&nbsp;</td>
                  <td class="lib">Date d'anomalie :</td>
                  <td colspan="2">
				  <bean:write name="anomalieForm"  property="dateano" />
                    		<html:hidden property="dateano"/>
				  </td>
                </tr>
                <tr> 
                  <td class="lib" >Données BIP :</td>
                  <td>
				  <bean:write name="anomalieForm"  property="coutbip" />
                  <html:hidden property="coutbip"/>
                  </td>
                  <td colspan=2>&nbsp;</td>
                  <td class="lib">Donn&eacute;es RSRH :</td>
                  <td colspan="2">
				  <bean:write name="anomalieForm"  property="coutgip" />
                    		<html:hidden property="coutgip"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Diff&eacute;rence :</td>
                  <td>
				  <bean:write name="anomalieForm"  property="diff" />
                    		<html:hidden property="diff"/>
                  </td>
                  <td colspan=2>&nbsp;</td>
                  <td class="lib">Ecart calendrier :</td>
                  <td colspan="2">
				  <bean:write name="anomalieForm"  property="ecartcal" />
                    		<html:hidden property="ecartcal"/>
                  </td>
                </tr>
                <tr> 
                  <td align=center colspan=10>&nbsp;</td>
                </tr>
                <tr> 
                  <td  colspan=8> <b>Justifier cette anomalie : </b></td>
                </tr>
                <tr> 
                  <td colspan=8>
				  <html:text property="validation1" styleClass="input" size="60" maxlength="50" onchange="return VerifierAlphanum(this);"/>
                  </td>
                </tr>
                <tr> 
                  <td colspan=8>
                    <html:text property="validation2" styleClass="input" size="60" maxlength="50" onchange="return VerifierAlphanum(this);"/>
                  </td>
                </tr>
                <td colspan=6>&nbsp;</td>
                <tr> 
                  <td colspan=6>&nbsp;</td>
                <tr> 
                  <td colspan=6>&nbsp;</td>
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
</body></html:html>
<!-- #EndTemplate -->
