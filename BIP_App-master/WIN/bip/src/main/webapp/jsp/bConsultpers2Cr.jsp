 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %><html:html locale="true"> 
<jsp:useBean id="consultPersForm" scope="request" class="com.socgen.bip.form.PersonneForm" />
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bConsultpersCr.jsp"/>

<%
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("situpers",consultPersForm.getHParams()); 
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
	String Rtype = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rtype")));
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
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/consultPers"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
					<html:hidden property="keyList0"/>
					<html:hidden property="rtype"/> 

                     <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib">Nom :</td>
                  <td ><bean:write name="consultPersForm"  property="rnom" />
                    	<html:hidden property="rnom"/>
                  </td>
                  <td width="30">&nbsp;</td>
                  <td class="lib"> Identifiant :</td>
                  <td >
                  		<bean:write name="consultPersForm"  property="ident" />
                    	<html:hidden property="ident"/>
                  
                     </td>
                </tr>
                <tr> 
                  <td class="lib" >Pr&eacute;nom :</td>
                  <td >
                  		<bean:write name="consultPersForm"  property="rprenom" />
                    	<html:hidden property="rprenom"/>
                  </td>
                  <td >&nbsp;</td>
                  <td class="lib"> Matricule :</td>
                  <td >
                     	<bean:write name="consultPersForm"  property="matricule" />
                    	<html:hidden property="matricule"/>
                  </td>
                </tr>
                <tr> 
                  <td align=center >&nbsp;</td>
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
				 <%					
				 if(!"SG..".equals(consultPersForm.getSoccode())){
                 %>
  				    <span STYLE="position: relative; left: 120px; z-index: 1;">Coût
                 <%}%>	
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
                <td align="center"> <a href="/consultPers.do?action=annuler&rtype=<%= Rtype %>"> 
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
