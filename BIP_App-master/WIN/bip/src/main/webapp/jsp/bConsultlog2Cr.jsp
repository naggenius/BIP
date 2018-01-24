 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %><html:html locale="true"> 
<jsp:useBean id="logicielForm" scope="request" class="com.socgen.bip.form.LogicielForm" />
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bConsultlogCr.jsp"/>

<%
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("situpers",logicielForm.getHParams()); 
	pageContext.setAttribute("choix1", list1);
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
   var Message = "";
   var Focus = "";
   if (Message != "") {
      alert(Message);
   }
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Situations 
            d'une personne<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/consultLog"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
					<html:hidden property="keyList0"/> 

                     <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td colspan="11">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="11">&nbsp;</td>
                </tr>
                <tr> 
                   <td class="lib" colspan="3" >Nom :</td>
                  <td ><b><bean:write name="logicielForm"  property="rnom" /></b>
                    	<html:hidden property="rnom"/> 
                  </td>
                  <td colspan=2>&nbsp;</td>
                  <td class="lib" colspan="4"> Coût standard :</td>
                  <td colspan="2">
                        <bean:write name="logicielForm"  property="coulog" />
                    	<html:hidden property="coulog"/>
                   
                  </td>
                </tr>
                <tr> 
                 
                  <td class="lib" colspan="3">Identifiant :</td>
                  <td ><bean:write name="logicielForm"  property="ident" />
                    	<html:hidden property="ident"/>
                   </td>
                  <td colspan=2>&nbsp;</td>
                  <td class="lib" colspan="4"> Co&ucirc;t total :</td>
                  <td colspan="2" ><bean:write name="logicielForm"  property="coutot" />
                    	<html:hidden property="coutot"/>
               
                  </td>
                </tr>
                <tr> 
                  <td align=center colspan=11>&nbsp;</td>
                </tr>
				</table>
                 <table cellspacing="2" cellpadding="2" class="tableBleu" border="0" width=200>
                <tr> 
                  <td align=center ><u>Liste des situations existantes</u> 
                    : </td>
                </tr>
                <tr> 
                  <td class="lib"><b>
			        <span STYLE="position: relative; left:  4px; z-index: 1;">Date début</span>
					<span STYLE="position: relative; left:  7px; z-index: 1;">Date fin </span>	
					<span STYLE="position: relative; left: 30px; z-index: 1;">DPG</span>
					<span STYLE="position: relative; left: 55px; z-index: 1;">Prest.</span>
					<span STYLE="position: relative; left: 60px; z-index: 1;">Soc.</span>	
			        <span STYLE="position: relative; left: 120px; z-index: 1;">Coût</span>
			        </b>	               
                  </td> 
                 
                  
                </tr>
                <tr> 
                  <td align=center>
                   		<html:select property="datsitu" styleClass="Multicol" size="5">
						   <bip:options collection="choix1"/>
					 	</html:select>
                  </td>
                </tr>
                <tr>
                <td align="center"> <a href="/consultLog.do?action=annuler"> 
                          <img src="../images/exit.gif" border=0 width=25 height=29 alt="Retour"></a></td>
                  
                <tr> 
               
                
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
