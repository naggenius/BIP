 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="factureForm" scope="request" class="com.socgen.bip.form.FactureForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bFactureOr.jsp"/> 
<%
java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("contrats",factureForm.getHParams()); 
  pageContext.setAttribute("choixContrats", list1);
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
   var Message="<bean:write filter="false"  name="factureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="factureForm"  property="focus" />";
   
   if (Message != "") {
      alert(Message);
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
   var index = form.clelc.selectedIndex;

   if (blnVerification==true) {
   		if (form.action.value=="creer") {
			if ( index==-1 ) {
	   				alert("Choisissez un contrat");
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Consultation 
            des contrats<!-- #EndEditable --></td>
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
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
                <html:hidden property="mode" value="cont"/> 
				<html:hidden property="keyList0"/> 
                <html:hidden property="keyList1"/>
				<html:hidden property="keyList2"/> 
                <html:hidden property="keyList3"/>
				<html:hidden property="keyList4"/> 
                <html:hidden property="keyList5"/>
				<html:hidden property="keyList6"/> 
                <html:hidden property="keyList7"/>
				<html:hidden property="choixfsc" value="N"/>
				<html:hidden property="socfact"/> 
                <html:hidden property="numcont"/>
				<html:hidden property="rnom"/> 
                <html:hidden property="numfact"/>
				<html:hidden property="typfact"/> 
                <html:hidden property="datfact"/>
				<html:hidden property="test" value="cont"/>

				
 
                    
                    <table cellspacing="5" cellpadding="0" class="tableBleu" width="500">
				<tr> 
                        <td colspan=8 >&nbsp;</td>
                      </tr>
				<tr> 
                        <td colspan=8 >&nbsp;</td>
                      </tr>

                      <tr> 
                        <td colspan=8 align=center><b>Liste des contrats :</b></td>
                      </tr>
                      <tr> 
                        <td class=lib colspan=8>
		<span STYLE="position: relative; left: 30px; z-index: 1;">N° contrat</span>
		<span STYLE="position: relative; left: 140px; z-index: 1;">Av</span>		<!-- espace supp 40px -->
		<span STYLE="position: relative; left: 150px; z-index: 1;">Ident</span>		<!-- espace supp 10px -->
		<span STYLE="position: relative; left: 165px; z-index: 1;">Ress</span>		<!-- espace supp  0px -->
		<span STYLE="position: relative; left: 175px; z-index: 1;">Date deb</span>	<!-- espace supp  5px -->
		<span STYLE="position: relative; left: 180px; z-index: 1;">Date fin</span>	<!-- espace supp  0px -->
		<span STYLE="position: relative; left: 185px; z-index: 1;">Coût HT</span>	<!-- espace supp  0px -->
	
                        </td>
                      </tr>
                      <tr> 
                        <td colspan=8 >
                        	<html:select property="clelc" styleClass="Multicol" size="8">
						  		<bip:options collection="choixContrats"/>
					 		</html:select>
                        </td>
                      </tr>
                      <tr> 
                        <td colspan=8 align=center>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan=8 align=center>&nbsp;</td>
                      </tr>
                    </table>
					<table  border="0" width=100%>
                      <tr>
					  <td width="25%">&nbsp;</td>
                <td width="25%">  
                        <div align="center"><html:submit property="boutonCreer" value="Valider" styleClass="input" onclick="Verifier(this.form, 'creer', 'insert', true);"/> 
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
</body></html:html>
<!-- #EndTemplate -->
