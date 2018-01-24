<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="dpgForm" scope="request" class="com.socgen.bip.form.DpgForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/majDpg.do"/> 
<%	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
    String sDpg = user.getDpg_Defaut();
    		
    java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dpg",dpgForm.getHParams()); 
    pageContext.setAttribute("choixDpg", list1);
%> 
 
<script language="JavaScript" src="../js/function.cjs"></script>
<script language="JavaScript" src="../js/menu.js"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sTest = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("test")));
	String sIndexMenu = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("indexMenu")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="dpgForm"  property="msgErreur" />";
   var Focus = "<bean:write name="dpgForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
      
   }
   
  if (Focus == "ok") {
      parent.frames.menu.location = "menu.jsp";
      parent.frames.main.location = "/majDpg.do?pageAide=jsp/aide/hvide.htm&action=suite&mode=initial&test=ok&indexMenu="+<%=sIndexMenu%>;
      
   }
    test="<%=sTest%>";
 if (test=="ok") {//mise à jour du menu
  		   parent.frames.menu.location="javascript:refreshMenu("+<%=sIndexMenu%>+")";
  }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}
function ValiderEcran(form)
{
  var index = form.codsg.selectedIndex;

   if (blnVerification==true) {
      if ( index==-1 ) {
	   alert("Choisissez un DPG");
	   return false;
	 }
      form.mode.value="valider";
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise à jour du DPG actif <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/majDpg"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">	
            <input type="hidden" name="indexMenu" value="<%= sIndexMenu %>">
			 <html:hidden property="action"/>
			 <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			  <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                </table>
                <table border=1 cellspacing=1 cellpadding=5 class="TableBleu" bordercolor="#B980BF">
                <tr> 
                  <td align=center><b>DPG actif : <%=sDpg%> - <%=session.getAttribute("LIB_INFO")%>
                    </b></td>
                </tr>
                </table>
                <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center><b>Choisissez un département, pôle ou groupe 
                    :</b></td>
                </tr>
                <tr> 
                  <td align=center>
                  	<html:select property="codsg" styleClass="Multicol" size="20">
						  <bip:options collection="choixDpg"/>
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
</body>
<% 
Integer id_webo_page = new Integer("5003"); 
com.socgen.bip.commun.form.AutomateForm formWebo = dpgForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
