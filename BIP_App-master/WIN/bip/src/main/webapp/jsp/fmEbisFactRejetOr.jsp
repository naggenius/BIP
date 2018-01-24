 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ebisFactRejetForm" scope="request" class="com.socgen.bip.form.EbisFactRejetForm" />
<jsp:useBean id="UserBip" scope="session" class="com.socgen.bip.user.UserBip" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Facture Expense</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmEbisFactRejetOr.jsp"/> 
<%
  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topetat"); 
  pageContext.setAttribute("choixTopEtat", list1);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	String centre_Frais = user.getCentre_Frais();
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="ebisFactRejetForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ebisFactRejetForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].datfactdebut.focus();
   }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value =action;
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
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Visualiser facture expense rejetée<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/EbisFactRejet" ><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="creer"/>
            <input type="hidden" name="centreFrais" value="<%=centre_Frais%>"/>
            
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center  ><b> Date debut : </b></td>
                  <td> 
                  <html:text property="datfactdebut" styleClass="input" size="11" maxlength="10"/>
                  </td>
                 
                  <td align=center  ><b> Date Fin : </b></td>
                  <td> 
                  <html:text property="datfactfin" styleClass="input" size="11" maxlength="10"/>
                  </td>
                </tr>
                <tr> 
                  <td align=center  ><b>Top etat :</b></td>
                  <td> 
                  <html:select property="topetat" styleClass="input"> 
                  			<option value="TT" >Tout</option>
   							<html:options collection="choixTopEtat" property="cle" labelProperty="libelle" />
				</html:select>	
                  </td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan=2>&nbsp;</td>
                </tr>
              </table>
              <!-- #EndEditable --></div>
            
		</td>
		</tr>
		<tr>
		<td align="center">

		<table width="100%" border="0"> 
                <tr> 
				   <td width="33%" align="center">  
     				 <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/>
                  </td>
                </tr>
            
            </table>
		
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
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
</html:html> 

<!-- #EndTemplate -->