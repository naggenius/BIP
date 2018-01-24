<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="mailForm" scope="request" class="com.socgen.bip.form.MailForm" />

<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true">
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 
<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
<%
 try
 {
  java.util.Hashtable hP = new java.util.Hashtable();
  hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
 
	 
  java.util.ArrayList list1 = listeDynamique.getListeDynamique("listeCodeRemontee",hP);
  pageContext.setAttribute("choixCodeRemontee", list1);
  
 }
 catch (Exception e) 
 { 
   %>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
 }
  
%>
 <!-- #BeginEditable "doctitle" --> 
<title>Gestion des @ mail</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bMailAd.jsp"/> 

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
   var Message="<bean:write filter="false"  name="mailForm"  property="msgErreur" />";
   var Focus = "<bean:write name="mailForm"  property="focus" />";
   
   if (Message != "") {
      alert(Message);
   }      
   
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.mode.value = mode;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Gestion des adresses mail
          <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/mail"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
               
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
				<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
				  <html:hidden property="action"/>
				<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
				  
                    <table width="60%" cellspacing="2" cellpadding="2" class="tableBleu">
                      <tr> 
                        <td colspan="2">&nbsp;</td>
                      </tr>    
                      <tr> 
                        	<td>&nbsp;</td>
                        	<td>&nbsp;</td>
                        <tr>                
	                <tr> 
	                  <td class="lib" width="38%"><b>Code remont�e :</b></td>
	                  <td>  
                     	<html:select property="codremonte" name="mailForm" styleClass="input"  > 
					      <html:options collection="choixCodeRemontee" property="cle" labelProperty="libelle" />
					  	</html:select>
                      </td>    
                    </tr>   
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </table>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="25%" colspan="2">&nbsp;</td>
                        <td width="25%"> 
                          <div align="center">
                          
                          	<html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'modifier', 'update',false);"/>                        
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
Integer id_webo_page = new Integer("5002"); 
com.socgen.bip.commun.form.AutomateForm formWebo = mailForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
