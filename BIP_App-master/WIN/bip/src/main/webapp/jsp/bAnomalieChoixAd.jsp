<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="anomalieForm" scope="request" class="com.socgen.bip.form.AnomalieForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> <bip:VerifUser page="jsp/bAnomalieAd.jsp"/> 
<%
java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("anomalies",anomalieForm.getHParams()); 
  pageContext.setAttribute("choixAnomalies", list1);
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


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="anomalieForm"  property="msgErreur" />";
   var Focus = "<bean:write name="anomalieForm"  property="focus" />";
   
   if (Message != "") {
      alert(Message);
   }
  
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
//  form.mode.value = mode;
}

function ValiderEcran(form)
{
   var index = form.ano.selectedIndex;

   if (blnVerification==true) {
   		if (form.action.value=='suite') {
			form.mode.value = "une";
 			if ( index==-1 ) {
	   				alert("Choisissez une anomalie");
	  				 return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Liste 
            des anomalies<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/anomalie"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
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
                    <table cellspacing="2" cellpadding="2" class="tableBleu" >
                      <tr> 
                        <td align=center colspan=6>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align=center colspan=6>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td  class=lib>Matricule : 
                        <td  colspan=3><bean:write name="anomalieForm"  property="matricule" /> 
                          <html:hidden property="matricule"/> 
                      </tr>
                      <tr> 
                        <td  class=lib>Nom :</td>
                        <td  colspan=4> <bean:write name="anomalieForm"  property="nom" /> 
                          <html:hidden property="nom"/> </td>
                      </tr>
                      <tr> 
                        <td  class=lib>Pr&eacute;nom :</td>
                        <td  colspan=3> <bean:write name="anomalieForm"  property="prenom" /> 
                          <html:hidden property="prenom"/> </td>
                      </tr>
                      <tr> 
                        <td colspan=6>&nbsp; </td>
                      </tr>
                    </table>
                    <table cellspacing="5" cellpadding="0" class="tableBleu" width="400">
                      <tr> 
                        <td colspan=6 align=center>Liste des anomalies existantes 
                          :</td>
                      </tr>
                      <tr> 
                        <td class=lib colspan=6> <span STYLE="position: relative; left:  28px; z-index: 1;">Mois</span> 
                          <span STYLE="position: relative; left: 45px; z-index: 1;">Type 
                          Abs</span> <span STYLE="position: relative; left: 65px; z-index: 1;">Abs 
                          BIP</span> <span STYLE="position: relative; left: 80px; z-index: 1;">Abs 
                          GIP</span> <span STYLE="position: relative; left: 100px; z-index: 1;">Ecart</span>	
                          <span STYLE="position: relative; left: 110px; z-index: 1;">Validée</span>	
                        </td>
                      </tr>
                      <tr> 
                        <td colspan=6 > 
                        	<html:select property="ano" styleClass="Multicol" size="6">
							  <bip:options collection="choixAnomalies"/>
					 		</html:select>
                        </td>
                      <tr> 
                        <td colspan=6 align=center>&nbsp;</td>
                      <tr> 
                        <td colspan=6 align=center>&nbsp;</td>
                      <tr> 
                        <td colspan=6 align=center>&nbsp;</td>
                    </table>
					<table  border="0" width=100%>
                      <tr>
					  <td width="25%">&nbsp;</td>
                <td width="25%">  
                        <div align="center"><html:submit property="boutonSelectionner" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
                        </div></td>
						<td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
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
</body>
<% 
Integer id_webo_page = new Integer("1069"); 
com.socgen.bip.commun.form.AutomateForm formWebo = anomalieForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
