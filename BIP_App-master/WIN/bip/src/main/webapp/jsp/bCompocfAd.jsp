 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="centrefraisForm" scope="request" class="com.socgen.bip.form.CentrefraisForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bCentrefraisAd.jsp"/> 
<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("compocfrais",centrefraisForm.getHParams()); 
  pageContext.setAttribute("choixCompocf", list1);
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
   var Message="<bean:write filter="false"  name="centrefraisForm"  property="msgErreur" />";

   if (Message != "") {
      alert(Message);
   }

}

function Verifier(form, action, flag)
{
 
   blnVerification = flag;
   form.action.value = action;

}
function ValiderEcran(form)
{
   var index = form.bddpg.selectedIndex;
				
   if (blnVerification==true) {
   		if (form.action.value=='valider') {
 			if ( index==-1 ) {
	   				alert("Choisissez un BDDPG");
	  				 return false;
	   		}
			if (!confirm("Voulez-vous supprimer ce BDDPG du centre de frais ?")) return false;
			form.mode.value="delete";
			
        }
  }
  else {
        //pour rediriger vers la bonne page lors de l'annulation
        	form.mode.value="avant";
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Composition 
            du centre de frais<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/compocf"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <html:hidden property="action"/>
                    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                    <html:hidden property="keyList0"/> <!--code centre frais -->
					<html:hidden property="keyList1"/> <!--niveau d'habilitation -->
					<html:hidden property="habilitation"/> 
                    <table cellspacing="2" cellpadding="2" class="tableBleu">
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="lib" >Centre de frais : </td>
                        <td><b><bean:write name="centrefraisForm"  property="codcfrais" />
                    		<html:hidden property="codcfrais"/></b>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib" >Libell&eacute; : </td>
                        <td ><b><bean:write name="centrefraisForm"  property="libcfrais" />
                    		<html:hidden property="libcfrais"/></b>
                        </td>
                      </tr>
                      <tr>
                        <td class="lib" >Filiale : </td>
                        <td> 
                  	        <b><bean:write name="centrefraisForm"  property="filcode" /> - <bean:write name="centrefraisForm"  property="filsigle" /></b>
  				            <html:hidden property="filcode"/>
  				            <html:hidden property="filsigle"/>
                        </td> 
                      </tr>
                      <tr> 
                        <td  colspan="2" align="center" >&nbsp;</td>
                      </tr>
                      </table>
                      <table cellspacing="2" cellpadding="2" class="tableBleu" width="450" >
                      <tr> 
                        <td  colspan="2" align="center"><b><u> Liste des BDDPG </u></b></td>
                      </tr>
                      <tr> 
                        <td  colspan=2 class="lib" >
                        <span STYLE="position: relative; left:  4px; z-index: 1;">Br</span>
						<span STYLE="position: relative; left:  7px; z-index: 1;">Dir</span>	
						<span STYLE="position: relative; left: 10px; z-index: 1;">DPG</span>
						<span STYLE="position: relative; left: 42px; z-index: 1;">Libell&eacute;</span>
						<span STYLE="position: relative; left: 212px; z-index: 1;">Habilitation</span>	
				        <span STYLE="position: relative; left: 230px; z-index: 1;">O/F</span>	               
                        </td>
                      </tr>
                      <tr> 
                        <td colspan=2 > 
                           <html:select property="bddpg" styleClass="Multicol" size="5">
						      <bip:options collection="choixCompocf"/>
					       </html:select>
                        </td>
                      </tr>
                      <tr> 
                        <td colspan=2>&nbsp;</td>
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
                <td width="33%" align="right"> <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/> 
                </td>
                <td width="33%" align="center"> <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'valider', true);"/>  
                </td>
                <td width="33%" align="left"><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/>  
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
