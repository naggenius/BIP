<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="copieAffectationForm" scope="request" class="com.socgen.bip.form.CopieAffectationForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/fCopieAffectationSr.jsp"/> 
<%  java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_copie_ident1",hP);
	java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_copie_ident2",hP);

    pageContext.setAttribute("choixPid1", list1);
    pageContext.setAttribute("choixPid2", list2);
   
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
   var Message="<bean:write filter="false"  name="copieAffectationForm"  property="msgErreur" />";
   var Focus = "<bean:write name="copieAffectationForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }

}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = "valider";
}
function ValiderEcran(form)
{ 
 
  
  if (!alertAffectation(form.ident1, form.ident2)) return false;

  if (blnVerification) {
	form.mode.value = "insert";
	if (!confirmAffectation(form.ident1, form.ident2)) return false;
			
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
           Copier les affectations d'une ressource<!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/copieAffectation"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div id="content">
			<div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
            <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
         
              <table border="0" class="TableBleu" cellpadding="2" cellspacing="2"  >
                <tr> 
                  <td colspan="2" >&nbsp; </td>
                </tr>
                <tr> 
                  <td colspan="2" >&nbsp; </td>
                </tr>
                <tr> 
                  <td class="texteGras"><b>Choisissez la ressource origine :</b> </td>
                  <td > 
                  	<html:select property="ident1" size="1" styleClass="input">
                  	   <html:options collection="choixPid1" property="cle" labelProperty="libelle"/>
                	</html:select>
                  </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="texteGras"><b>Choisissez la ressource destination :</b> </td>
                  <td> 
                  	<html:select property="ident2" size="1" styleClass="input">
                  	   <html:options collection="choixPid2" property="cle" labelProperty="libelle"/>
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
				  <td align="center" colspan="2"> 
					<table width="100%" border="0">
					  <tr> 
						<td align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
						</td>
					  </tr>
					</table>
					<!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
				  </td>
				</tr>
			</table>
		  </td>
        </tr>
		    <!-- #EndEditable --></div></div>
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
</body>
<% 
Integer id_webo_page = new Integer("6007"); 
com.socgen.bip.commun.form.AutomateForm formWebo = copieAffectationForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
