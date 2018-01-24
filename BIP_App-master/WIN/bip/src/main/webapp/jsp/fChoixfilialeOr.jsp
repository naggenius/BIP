 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="choixFilialeForm" scope="request" class="com.socgen.bip.form.ChoixFilialeForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fChoixfilialeOr.jsp"/>
<%
  com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
  String sFiliale = user.getFilCode();
  
  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeGlobale.getListeGlobale("filiale");
  pageContext.setAttribute("choixFiliale", list1);
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
   var Message="<bean:write filter="false"  name="choixFilialeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="choixFilialeForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus == "ok") {
      parent.frames.menu.location = "menu.jsp";
      parent.frames.main.location = "jsp/vide.jsp?pageAide=aide/help_pcm.htm";
   }
  
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}
function ValiderEcran(form)
{
  var index = form.filcode.selectedIndex;

   if (blnVerification==true) {
      if ( index==-1 ) {
	   alert("Choisissez une filiale");
	   return false;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Choix 
            filiale <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/choixFiliale"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" --> 
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">	
			 <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td>&nbsp; </td>
                <tr> 
                  <td>&nbsp; </td>
                </tr>
                
                 </table>
                <table border=1 cellspacing=1 cellpadding=5 class="TableBleu" bordercolor="#B980BF">
                <tr> 
                  <td align=center><b>Filiale active : <%=sFiliale%> - <%=session.getAttribute("LIB_FILIALE")%>
                    </b></td>
                </tr>
                </table>
                <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center><b>Choisissez une filiale : </b></td>
               
                  <td> 
                    	<html:select property="filcode" styleClass="input" > 
                		<html:options collection="choixFiliale" property="cle" labelProperty="libelle" />
						</html:select>
					</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                </tr>
              </table>
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
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