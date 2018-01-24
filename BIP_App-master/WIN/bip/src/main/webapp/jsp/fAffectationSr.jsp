<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="affectationForm" scope="request" class="com.socgen.bip.form.AffectationForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!--  ABN - HP PPM 57787 - DEBUT  -->
 <!-- #BeginEditable "doctitle" --> 
<title>
	<% java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle("log"); %>
	<%=rb.getString("env.titrepage")%>
</title>
<!-- #EndEditable --> 
<!--  ABN - HP PPM 57787 - FIN  --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="/affectation.do"/> 
<%  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_resscons",affectationForm.getHParams());
	java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_pid_modif",affectationForm.getHParams());
    pageContext.setAttribute("choixRess", list1);
    pageContext.setAttribute("choixPid", list2);
%> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));  
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="affectationForm"  property="msgErreur" />";
   var Focus = "<bean:write name="affectationForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  /* if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].CHAMP.focus();
   }*/
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = "creer";
}
function ValiderEcran(form)
{  if (blnVerification) {
	form.keyList0.value=form.ident.value;
	form.keyList1.value=form.pid.value;
	form.mode.value="insert";
   }
	

   return true;
}
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr > 
          <td> 
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->
          Affecter une sous-t&acirc;che &agrave; une ressource<!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td>
		    <div id="content"> 
    		<!-- #BeginEditable "debut_form" --><html:form action="/affectation"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
            <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
            <html:hidden property="keyList0"/> <!--ident-->
            <html:hidden property="keyList1"/> <!--pid-->  
              <table border="0" class="TableBleu" cellpadding="2" cellspacing="2"  >
                <tr> 
                  <td colspan="2" >&nbsp; </td>
                </tr>
                <tr> 
                  <td colspan="2" >&nbsp; </td>
                </tr>
                <tr> 
                  <td class="texte"><b>Choisissez une ressource :</b> </td>
                  <td > 
                    <html:select property="ident" size="1" styleClass="input">
                      <html:options collection="choixRess" property="cle" labelProperty="libelle"/>
                    </html:select>
                  </td>
                </tr>
                <tr> 
                  <td class="texte"><b>et une ligne BIP : </b> </td>
                  <td>
                  	<html:select property="pid" size="1" styleClass="input">
                  	   <html:options collection="choixPid" property="cle" labelProperty="libelle"/>
                	</html:select>
                  </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
				 <tr> 
				  <td align="center" colspan="2"> 
					<table width="100%" border="0">
					  <tr> 
						<td align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
						</td>
					  </tr>
					</table>
					<!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
					</div>
				  </td>
				</tr>
			</table>
			<!-- #EndEditable --></div></div>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body></html:html>
<!-- #EndTemplate -->
